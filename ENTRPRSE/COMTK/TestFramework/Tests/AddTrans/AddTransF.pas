unit AddTransF;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, TESTFORMTEMPLATE, StdCtrls, Enterprise04_TLB;

type
  TfrmTestTemplate1 = class(TfrmTestTemplate)
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
    FStockCode : string;
    FQty : Double;
    FValue : Double;
    FAction : Word;
    FSerialPrefix : string;
    DocType : TDocTypes;
  protected
    procedure RunTest; override;
    procedure AddSOR;
    procedure ProcessAction;
    function WantAction(WhichAction : Word) : Boolean;
  public
    { Public declarations }
  end;

var
  frmTestTemplate1: TfrmTestTemplate1;

implementation

{$R *.dfm}

const
  ACTION_NONE = 0;
  ACTION_QTY = 1;
  ACTION_EXPLODE_BOM = 2;
  ACTION_PICK = 4;
  ACTION_VALUE = 8;
  ACTION_SN_PREFIX = 16;

{ TfrmTestTemplate1 }

procedure TfrmTestTemplate1.AddSOR;
var
  TransO : ITransaction;
  Res    : SmallInt;
  oLine : ITransactionLine;

  procedure DoSerial(const LineO : ITransactionLine);
  var
    i, FuncRes : integer;
    KeyS : string;
    StkSerialO : ISerialBatch;
  begin
    for i := 1 to Trunc(LineO.tlQty) do
    begin
      if DocType in [dtPOR, dtPIN, dtPCR, dtPJI] then
      begin
        with LineO.tlSerialBatch.Add do
        begin
          snSerialNo := FSerialPrefix + IntToStr(i);
          snCostPrice := LineO.tlNetValue;
          snCostPriceCurrency := 1;
          Save;
        end;
      end
      else
      begin
        StkSerialO := LineO.tlStockCodeI.stSerialBatch;
        with StkSerialO do
        begin
          // Use Used index - lists unsold items first
          Index := snIdxUsedSerialNo;
          KeyS := BuildUsedSerialIndex(False, 'TF100' + IntToStr(i));
          FuncRes := GetEqual(KeyS);

          if (FuncRes = 0) and (not snSold) then
            FuncRes := LineO.tlSerialBatch.UseSerialBatch(StkSerialO);
        end;
      end;
    end; //for i
  end;

begin
  SplitExtraParam;
  DocType := StringToDocType(UpperCase(FExtraParamList[0]));
  FSTockCode := UpperCase(FExtraParamList[1]);
  if FExtraParamList.Count > 2 then
    ProcessAction;
  // Create an Add Transaction object for the SPOP Transaction
  TransO := oToolkit.Transaction.Add(DocType) as ITransaction8;

  with TransO do
  begin

    // Customer/Supplier Account Code
      if DocType in [dtPOR, dtPIN, dtPCR, dtPJI] then
        thAcCode := 'ACEE02'
      else
        thAcCode :=  'ABAP01';

    // Bring in defaults for Account:- Ctrl GL, Delivery Addr, Due Date, Settlement Disc, etc...

      thJobCode := 'BATH01';
      thAnalysisCode := 'B-DIRECT';

    ImportDefaults;


    thCurrency := 1; //Base
    oLine := thLines.Add;
    with oLine do
    begin
      tlStockCode := FStockCode;
      tlQty := FQty;
      ImportDefaults;

      if WantAction(ACTION_VALUE) then
        tlNetValue := FValue;

      if tlNetValue = 0 then
        tlNetValue := 100;

      if Trim(tlLocation) = '' then
        tlLocation := 'AAA';

      if WantAction(ACTION_PICK) then
        tlQtyPicked := FQty;

      Save;
    end;

    if WantAction(ACTION_EXPLODE_BOM) then
      (thLines[1] as ITransactionLine7).ExplodeBOM;
    FResult := Save(True);

    if FResult = 0 then
    begin //Do Serial Nos if needed
      if thLines.thLine[1].tlSerialBatch.tlUsesSerialBatchNo then
        DoSerial(thLines.thLine[1]);

    end;

  end; // With TransO

  // Remove reference to Transaction Object to destroy it
  TransO := nil;
end;

procedure TfrmTestTemplate1.ProcessAction;
var
  s : string;
  i : integer;
begin
  i := 2;
  while i < FExtraParamList.Count do
  begin
    s := Trim(UpperCase(FExtraParamList[i]));
    if Copy(s, 1, 4) = 'QTY:' then
    begin
      FAction := FAction or ACTION_QTY;
      FQty := StrToFloat(Copy(s, 5, Length(s)));
    end
    else
    if s = 'EXPLODEBOM' then
      FAction := FAction or ACTION_EXPLODE_BOM
    else
    if (s = 'PICK') and (DocType in [dtSOR, dtPOR]) then
      FAction := FAction or ACTION_PICK
    else
    if (Copy(s, 1, 4) = 'VAL:') then
    begin
      FAction := FAction or ACTION_VALUE;
      FValue := StrToFloat(Copy(s, 5, Length(s)));
    end
    else
    if (Copy(s, 1, 4) = 'SNP:') then
    begin
      FAction := FAction or ACTION_SN_PREFIX;
      FSerialPrefix := Copy(s, 5, Length(s));
    end;

    inc(i);
  end;
end;

procedure TfrmTestTemplate1.RunTest;
begin
  AddSOR;
end;

procedure TfrmTestTemplate1.FormCreate(Sender: TObject);
begin
  inherited;
  FQty := 1;
  FAction := ACTION_NONE;
  FValue := 0;
  FSerialPrefix := 'TF100';
end;

function TfrmTestTemplate1.WantAction(WhichAction: Word): Boolean;
begin
  Result := FAction and WhichAction = WhichAction;
end;

end.
