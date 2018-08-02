unit oOrderPaymentRefundPayments;

{$ALIGN 1}  { Variable Alignment Disabled }

interface

Uses Classes, Dialogs, Forms, SysUtils, Windows, ComObj, ActiveX,
     {$IFNDEF WANTEXE}Enterprise01_TLB{$ELSE}Enterprise04_TLB{$ENDIF},
     Contnrs, ExBtth1U, oOPPayment, oOrderPaymentsRefundManager, VarConst,
     oOrderPaymentsSRC, OrderPaymentsInterfaces, oTrans, ExceptIntf;


type

  TOrderPaymentRefundPaymentDetails = Class(TAutoIntfObjectEx, IOrderPaymentRefundPaymentDetails)
  protected
    FNetPayment : Double;
    FRefundAmount : Double;

    FLineI : ITransactionLine;
    FPaymentLineI : IOrderPaymentsTransactionPaymentInfoPaymentLine;

    function Get_oprpdNetPayment: Double; safecall;
    function Get_oprpdRefundValue: Double; safecall;
    procedure Set_oprpdRefundValue(Value: Double); safecall;
    function Get_oprpdTransactionLine: ITransactionLine; safecall;
    function Get_oprpdLineNo: Integer; safecall;
    procedure SetFullRefund; safecall;
  public
    constructor Create(const oLine : ITransactionLine;
                       const oPaymentLine : IOrderPaymentsTransactionPaymentInfoPaymentLine);
    destructor Destroy; override;
  end;

  TOrderPaymentRefundPaymentDetailsList = Class(TAutoIntfObjectEx, IOrderPaymentRefundPaymentDetailsList)
  protected
    FList : TInterfaceList;
    function Get_oprpdCount: Integer; safecall;
    function Get_oprpdPaymentDetails(Index: Integer): IOrderPaymentRefundPaymentDetails; safecall;

  public
    procedure Add(const oLine : ITransactionLine;
                       const oPaymentLine : IOrderPaymentsTransactionPaymentInfoPaymentLine);
    constructor Create;
    destructor Destroy; override;
  end;


  TOrderPaymentRefundPayment = Class(TAutoIntfObjectEx, IOrderPaymentRefundPayment)
  protected
    FTransactionI : ITransaction; //SRC for payment
    FOriginalTransactionI : ITransaction; //Transaction we're refunding
    FPayment :  IOrderPaymentsTransactionPaymentInfoPaymentHeader;
    FDoRefund : Boolean;

    FDetailsListO : TOrderPaymentRefundPaymentDetailsList;
    FDetailsListI : IOrderPaymentRefundPaymentDetailsList;

    FRefundTransI : ITransaction;
    FRefundOurRef : string;

    FTransO : TTransaction;

    function Get_oprpPaymentTransactionI: ITransaction; safecall;
    function Get_oprpPaymentDetails: IOrderPaymentRefundPaymentDetailsList; safecall;
    function Get_oprpNetValue: Double; safecall;
    function Get_oprpRefundTransaction: WideString; safecall;
    function Get_oprpRefundTransactionI: ITransaction; safecall;
    procedure SetFullRefund; safecall;

    procedure LoadDetails;
  public
    constructor Create(const oOrigTrans : ITransaction; const oTrans : ITransaction;
                       const OPayment: IOrderPaymentsTransactionPaymentInfoPaymentHeader;
                       const ATTrans : TTRansaction);
    destructor Destroy; override;
    property RefundOurRef : string read FRefundOurRef write FRefundOurRef;
  end;

  pOPRPaymentRec = ^TOPRPaymentRec;
  TOPRPaymentRec = Record
    FPaymentO : TOrderPaymentRefundPayment;
    FPaymentI : IOrderPaymentRefundPayment;
  end;


  TOrderPaymentRefundPaymentList = Class(TAutoIntfObjectEx, IOrderPaymentRefundPaymentList)
  protected
    FList : TList;

    //Clone of SRC
    FTransaction : ITransaction;

    //Interface functions
    function Get_oprpCount: Integer; safecall;
    function Get_oprpPayments(Index: Integer): IOrderPaymentRefundPayment; safecall;

  public
    procedure Add(const oOriginalTrans : ITransaction; const oTrans : ITransaction;
                  const OPayment : IOrderPaymentsTransactionPaymentInfoPaymentHeader;
                       const ATTrans : TTRansaction);
    constructor Create;
    destructor Destroy; override;

    function GetPaymentObject(Index: Integer) : TOrderPaymentRefundPayment;

    property Transaction : ITransaction read FTransaction write FTransaction;
  end;

implementation

uses
  ComServ, MiscFunc, MathUtil;

//===============================================================================================================
{ TOrderPaymentRefundPaymentDetails }

constructor TOrderPaymentRefundPaymentDetails.Create(const oLine: ITransactionLine;
                       const oPaymentLine : IOrderPaymentsTransactionPaymentInfoPaymentLine);
begin
  inherited Create(ComServer.TypeLib, IOrderPaymentRefundPaymentDetails);

  FLineI := oLine;
  FPaymentLineI := oPaymentLine;

  FRefundAmount := 0.0;
  FNetPayment := 0.0;
end;

destructor TOrderPaymentRefundPaymentDetails.Destroy;
begin
  FLineI := nil;
  inherited;
end;

function TOrderPaymentRefundPaymentDetails.Get_oprpdLineNo: Integer;
begin
  Result := FPaymentLineI.opplOrderLine.opolLine.AbsLineNo;
end;

function TOrderPaymentRefundPaymentDetails.Get_oprpdNetPayment: Double;
begin
  Result := FPaymentLineI.opplNetPaymentValue;
end;

function TOrderPaymentRefundPaymentDetails.Get_oprpdRefundValue: Double;
begin
  Result := FPaymentLineI.opplRefundValue;
end;

function TOrderPaymentRefundPaymentDetails.Get_oprpdTransactionLine: ITransactionLine;
begin
  Result := FLineI;
end;

procedure TOrderPaymentRefundPaymentDetails.SetFullRefund;
begin
  Set_oprpdRefundValue(Get_oprpdNetPayment);
end;

procedure TOrderPaymentRefundPaymentDetails.Set_oprpdRefundValue(
  Value: Double);
begin
  FPaymentLineI.opplRefundValue := Value;
  FPaymentLineI.opplRefundSelected := not ZeroFloat(Value);
end;


//===============================================================================================================
{ TOrderPaymentRefundPaymentDetailsList }

procedure TOrderPaymentRefundPaymentDetailsList.Add(
  const oLine: ITransactionLine;
  const oPaymentLine: IOrderPaymentsTransactionPaymentInfoPaymentLine);
var
  oDetails : TOrderPaymentRefundPaymentDetails;
begin
  oDetails := TOrderPaymentRefundPaymentDetails.Create(oLine, oPaymentLine);
  FList.Add(oDetails);
end;

constructor TOrderPaymentRefundPaymentDetailsList.Create;
begin
  inherited Create(ComServer.TypeLib, IOrderPaymentRefundPaymentDetailsList);

  FList := TInterfaceList.Create;
end;

destructor TOrderPaymentRefundPaymentDetailsList.Destroy;
var
  i : Integer;
begin
  //Free interfaces in list
  for i := 0 to FList.Count - 1 do
    FList[i] := nil;
  FList.Free;

  inherited;
end;

function TOrderPaymentRefundPaymentDetailsList.Get_oprpdCount: Integer;
begin
  Result := FList.Count;
end;

function TOrderPaymentRefundPaymentDetailsList.Get_oprpdPaymentDetails(
  Index: Integer): IOrderPaymentRefundPaymentDetails; safecall;
begin
  if (Index >= 1) and (Index <= FList.Count) then
    Result := FList[Index - 1] as IOrderPaymentRefundPaymentDetails
  else
    ERangeError.Create('Index out of range (' + IntToStr(Index) + ')');
end;

//===============================================================================================================
{ TOrderPaymentRefundPayment }

constructor TOrderPaymentRefundPayment.Create(const oOrigTrans : ITransaction; const oTrans : ITransaction;
                                              const OPayment: IOrderPaymentsTransactionPaymentInfoPaymentHeader;
                                              const ATTrans : TTRansaction);
begin
  inherited Create(ComServer.TypeLib, IOrderPaymentRefundPayment);

  FDetailsListO := nil;
  FDetailsListI := nil;
  FRefundTransI := nil;
  FRefundOurRef := '';

  FTransactionI := oTrans;
  FPayment := oPayment;
  FOriginalTransactionI := oOrigTrans;

  FTransO := ATTrans;

  FDoRefund := False;
end;

destructor TOrderPaymentRefundPayment.Destroy;
begin
  FDetailsListO := nil;
  FDetailsListI := nil;
  FRefundTransI := nil;

  inherited;
end;

function TOrderPaymentRefundPayment.Get_oprpNetValue: Double;
begin
  Result := FPayment.opphNetValue;
end;

function TOrderPaymentRefundPayment.Get_oprpPaymentDetails: IOrderPaymentRefundPaymentDetailsList;
begin
  if not Assigned(FDetailsListO) then
  begin
    FDetailsListO := TOrderPaymentRefundPaymentDetailsList.Create;

    LoadDetails;

    FDetailsListI := FDetailsListO;
  end;
  Result := FDetailsListI;
end;

function TOrderPaymentRefundPayment.Get_oprpPaymentTransactionI: ITransaction;
begin
  Result := FTransactionI;
end;

function TOrderPaymentRefundPayment.Get_oprpRefundTransaction: WideString;
begin
  Result := FRefundOurRef;
end;

function TOrderPaymentRefundPayment.Get_oprpRefundTransactionI: ITransaction;
begin
  if FRefundOurRef <> '' then
  begin
    if not Assigned(FRefundTransI) then
      FRefundTransI := FTransO.GetCloneInterface(FRefundOurRef);
  end;

  Result := FRefundTransI;
end;

procedure TOrderPaymentRefundPayment.LoadDetails;
var
  i : Integer;

  function GetLineNo : Integer;
  var
    j, LineNo, CheckLine : Integer;
  begin
    Result := 1; //Set default to 1 as there's no point crashing the application if there's any problem.

    LineNo := FPayment.opphPaymentLines[i].opplOrderLine.opolLine.AbsLineNo;

    for j := 1 to FOriginalTransactionI.thLines.thLineCount do
    begin
      //Find equivalent line in the transaction using AbsLineNo from order line - if SOR then use
      //tlAbsLineNo, if SIN then use tlSOPAbsLineNo
      if FOriginalTransactionI.thDocType = dtSOR then
        CheckLine := FOriginalTransactionI.thLines[j].tlAbsLineNo
      else
        CheckLine := FOriginalTransactionI.thLines[j].tlSOPAbsLineNo;

      if CheckLine = LineNo then
      begin
        Result := j;
        Break;
      end; // if CheckLine = LineNo

    end; // for j := 1 to FOriginalTransactionI.thLines.thLineCount
  end; //GetLineNo

begin
  //Create details object with payment line and equivalent line from SOR/IN
  for i := 0 to FPayment.opphPaymentLineCount - 1 do
     FDetailsListO.Add(FOriginalTransactionI.thLines[GetLineNo], FPayment.opphPaymentLines[i]);
end;

procedure TOrderPaymentRefundPayment.SetFullRefund;
var
  i : integer;
begin
  //PR: 27/01/2015 ABSEXCH-16066 Need to call Get_oprpPaymentDetails to create the list
  for i := 1 to Get_oprpPaymentDetails.oprpdCount do
    FDetailsListI.oprpdPaymentDetails[i].SetFullRefund;
end;


//===============================================================================================================

{ TOrderPaymentRefundPaymentList }

procedure TOrderPaymentRefundPaymentList.Add(const oOriginalTrans : ITransaction; const oTrans : ITransaction;
  const oPayment: IOrderPaymentsTransactionPaymentInfoPaymentHeader;
                       const ATTrans : TTRansaction);
var
  oPaymentO : TOrderPaymentRefundPayment;
  PayRec : pOPRPaymentRec;
begin
  New(PayRec);
  oPaymentO := TOrderPaymentRefundPayment.Create(oOriginalTrans, oTrans, oPayment, ATTrans);
  PayRec.FPaymentO := oPaymentO;
  PayRec.FPaymentI := oPaymentO;
  FList.Add(PayRec);
end;

constructor TOrderPaymentRefundPaymentList.Create;
begin
  inherited Create(ComServer.TypeLib, IOrderPaymentRefundPaymentList);

  FList := TList.Create;
end;

destructor TOrderPaymentRefundPaymentList.Destroy;
var
  i : integer;
begin
  for i := 0 to FList.Count - 1 do
  begin
    //Set interface to nil to free object
    TOPRPaymentRec(FList[i]^).FPaymentI := nil;

    //Free memory for record
    Dispose(FList[i]);
  end;
  FList.Free;

  inherited;
end;

function TOrderPaymentRefundPaymentList.Get_oprpCount: Integer;
begin
  Result := FList.Count;
end;

function TOrderPaymentRefundPaymentList.Get_oprpPayments(
  Index: Integer): IOrderPaymentRefundPayment;
begin
  if (Index >= 1) and (Index <= FList.Count) then
    Result := TOPRPaymentRec(FList[Index - 1]^).FPaymentI
  else
    ERangeError.Create('Index out of range (' + IntToStr(Index) + ')');
end;

function TOrderPaymentRefundPaymentList.GetPaymentObject(
  Index: Integer): TOrderPaymentRefundPayment;
begin
  Result := TOPRPaymentRec(FList[Index - 1]^).FPaymentO;
end;

end.
