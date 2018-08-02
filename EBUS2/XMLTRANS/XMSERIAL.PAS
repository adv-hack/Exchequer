unit xmSerial;

{ prutherford440 09:53 30/10/2001: Disabled Byte Alignment in Delphi 6.0 }
{$ALIGN 1}  { Variable Alignment Disabled }


interface

uses
  ComObj, Enterprise03_TLB, Classes, XmlTrans, Logfile;


type

    TXmlSerialBatchDetails = class(TLogAutoIntf, IXmlSerialBatchDetails)
      private
        Data : TXmlSerialBatchDetailRec;
      protected
        function  Get_snType: TxmlSerialBatchType; safecall;
        procedure Set_snType(Value: TxmlSerialBatchType); safecall;
        function  Get_snSerialNo: WideString; safecall;
        procedure Set_snSerialNo(const Value: WideString); safecall;
        function  Get_snBatchNo: WideString; safecall;
        procedure Set_snBatchNo(const Value: WideString); safecall;
        function  Get_snQtyUsed: Double; safecall;
        procedure Set_snQtyUsed(Value: Double); safecall;
      public
        constructor Create(LNo : longint);
        Destructor Destroy; override;
      end;

      TXmlSerialType = Record
        SNO  : TXmlSerialBatchDetails;
        SNI  : IXmlSerialBatchDetails;
      end;

      pXmlSerialType = ^TXmlSerialType;


    TXmlSerialBatch = class(TLogAutoIntf, IXmlSerialBatch)
      private
        FLines : TList;
        FParent : TObject;
        FLineNo : longint;
        DetO : TXmlSerialBatchDetails;
        DetI : IXmlSerialBatchDetails;

      protected
        function  Get_sbLine(Index: Integer): IXmlSerialBatchDetails; safecall;
        function  Get_sbLineCount: Integer; safecall;
        procedure Delete(Index: Integer); safecall;
        function  Add: IXmlSerialBatchDetails; safecall;
      public
        constructor Create;
        destructor Destroy; override;
        property Lines : TList read FLines write FLines;
        property LineNo : longint read FLineNo write FLineNo;
      end;

implementation

uses
  ComServ, SysUtils;


// TXmlSerialBatch methods

constructor TXmlSerialBatch.Create;
begin
  inherited Create(ComServer.TypeLib, IXmlSerialBatch);
  FLines := TList.Create;
end;

destructor TXmlSerialBatch.Destroy;
var
  i : integer;
begin
  for i := 0 to FLines.Count - 1 do
    if Assigned(FLines.Items[i]) then
      FLines.Items[i] := nil;

  FLines.Free;
  inherited Destroy;
end;

procedure TXmlSerialBatch.Delete(Index: Integer);
begin
  if Assigned(FLines) then
  begin
    FLines.Items[Index] := nil;
    FLines.Delete(Index);
  end;
end;

function  TXmlSerialBatch.Add: IXmlSerialBatchDetails;
var
  oSerial : pXmlSerialType;
begin
  DetO := TxmlSerialBatchDetails.Create(FLineNo);
  if Assigned(DetO) then
  begin
    New(oSerial);

    with oSerial^ do
    begin
      SNO := DetO;
      SNI := DetO;
    end;

    FLines.Add(oSerial);
    Result := oSerial.SNI;
  end
  else
    Result := nil;
end;

function  TXmlSerialBatch.Get_sbLine(Index: Integer): IXmlSerialBatchDetails; safecall;
begin
  if Assigned(FLines) then
    Result := pXmlSerialType(FLines[Index])^.SNI;
end;

function  TXmlSerialBatch.Get_sbLineCount: Integer; safecall;
begin
  if Assigned(FLines) then
    Result := FLines.Count
  else
    Result := 0;
end;

//------------------------------------------------------------------------------
//TxmlSerialBatchDetails methods
constructor TxmlSerialBatchDetails.Create(LNo : longint);
begin
  inherited Create(ComServer.TypeLib, IXmlSerialBatchDetails);
  FillChar(Data, SizeOf(Data), #0);
  Data.FLineNo := LNo;
end;

Destructor TxmlSerialBatchDetails.Destroy;
begin
  inherited Destroy;
end;

function  TXmlSerialBatchDetails.Get_snType: TxmlSerialBatchType;
begin
  Result := TXmlSerialBatchType(Data.FType);
end;

procedure TXmlSerialBatchDetails.Set_snType(Value: TxmlSerialBatchType);
begin
  Data.FType := Integer(Value);
end;

Function  TXmlSerialBatchDetails.Get_snSerialNo: WideString;
begin
  Result := Data.FSerialNo;
end;

procedure TXmlSerialBatchDetails.Set_snSerialNo(const Value: WideString);
begin
  Data.FSerialNo := Value;
end;

Function  TXmlSerialBatchDetails.Get_snBatchNo: WideString;
begin
  Result := Data.FBatchNo;
end;

procedure TXmlSerialBatchDetails.Set_snBatchNo(const Value: WideString);
begin
  Data.FBatchNo := Value;
end;

function  TXmlSerialBatchDetails.Get_snQtyUsed: Double;
begin
  Result := Data.FQtyUsed;
end;

procedure TXmlSerialBatchDetails.Set_snQtyUsed(Value: Double);
begin
  Data.FQtyUsed := Value;
end;




end.
