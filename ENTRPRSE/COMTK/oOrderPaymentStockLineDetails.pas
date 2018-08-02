unit oOrderPaymentStockLineDetails;

{$ALIGN 1}  { Variable Alignment Disabled }

interface

Uses Classes, Dialogs, Forms, SysUtils, Windows, ComObj, ActiveX, ComServ,
     {$IFNDEF WANTEXE}Enterprise01_TLB{$ELSE}Enterprise04_TLB{$ENDIF},
     Contnrs, ExceptIntf;

//PR: 17/09/2014 Order Payments T104
type

//=======================================================================================================================
{ TStockRefundLineDetails }
//=======================================================================================================================

  TStockRefundLineDetailsRec = Record
    LineNo : Integer;
    Qty : Double;
  end;

  TStockRefundLineDetails = Class(TAutoIntfObjectEx, IStockRefundLineDetails)
  protected
    FDetails : TStockRefundLineDetailsRec;
    function Get_srldLineNo: Integer; safecall;
    procedure Set_srldLineNo(Value: Integer); safecall;
    function Get_srldQty: Double; safecall;
    procedure Set_srldQty(Value: Double); safecall;
    function Get_sldLocation: WideString; safecall;
    procedure Set_sldLocation(const Value: WideString); safecall;
  public
    constructor Create;
  end;

//=======================================================================================================================
{ TStockRefundLineDetailsList }
//=======================================================================================================================

  TStockRefundLineDetailsList = Class(TAutoIntfObjectEx, IStockRefundLineDetailsList)
  protected
    FList : TObjectList;
    function Get_sldCount: Integer; safecall;
    function Get_sldItems(Index: Integer): IStockRefundLineDetails; safecall;
    function Add: IStockRefundLineDetails; safecall;
    procedure Delete(Index: Integer); safecall;
  public
    constructor Create;
    destructor Destroy; override;
  end;

  

implementation

uses
  MiscFunc;

//=======================================================================================================================
{ TStockRefundLineDetails }
//=======================================================================================================================

constructor TStockRefundLineDetails.Create;
begin
  inherited Create(ComServer.TypeLib, IStockRefundLineDetails);
  FillChar(FDetails, SizeOf(FDetails), 0);
end;



//=======================================================================================================================
{ TStockRefundLineDetailsList }
//=======================================================================================================================

function TStockRefundLineDetailsList.Add: IStockRefundLineDetails;
var
  ADetails : TStockRefundLineDetails;
begin
  ADetails := TStockRefundLineDetails.Create;
  Result := ADetails;
  FList.Add(ADetails);
end;

constructor TStockRefundLineDetailsList.Create;
begin
  inherited Create(ComServer.TypeLib, IStockRefundLineDetailsList);
  FList := TObjectList.Create;
end;

procedure TStockRefundLineDetailsList.Delete(Index: Integer);
begin
  if (Index >= 0) and (Index < FList.Count) then
    FList.Delete(Index)
  else
    raise EInvalidIndex.Create('Index out of range (' + IntToStr(Index) + ')');
end;

destructor TStockRefundLineDetailsList.Destroy;
begin
  FList.Free;
  inherited;
end;

function TStockRefundLineDetailsList.Get_sldCount: Integer;
begin
  Result := FList.Count;
end;

function TStockRefundLineDetailsList.Get_sldItems(
  Index: Integer): IStockRefundLineDetails;
begin
  Result := FList[Index] as TStockRefundLineDetails;
end;

function TStockRefundLineDetails.Get_sldLocation: WideString;
begin

end;

function TStockRefundLineDetails.Get_srldLineNo: Integer;
begin

end;

function TStockRefundLineDetails.Get_srldQty: Double;
begin

end;

procedure TStockRefundLineDetails.Set_sldLocation(const Value: WideString);
begin

end;

procedure TStockRefundLineDetails.Set_srldLineNo(Value: Integer);
begin

end;

procedure TStockRefundLineDetails.Set_srldQty(Value: Double);
begin

end;

end.
