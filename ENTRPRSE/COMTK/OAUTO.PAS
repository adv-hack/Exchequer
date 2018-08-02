unit oAuto;

interface

Uses Classes, Dialogs, Forms, SysUtils, Windows, ComObj, ActiveX,
     {$IFNDEF WANTEXE}Enterprise01_TLB{$ELSE}Enterprise04_TLB{$ENDIF}, VarCnst3, MiscFunc,
      ExceptIntf;

type


  TAutoTransactionSettings = Class(TAutoIntfObjectEx, IAutoTransactionSettings, IAutoTransactionSettings2)
  private
    FTH : ^TBatchTHRec;
    FIsAuto : WordBool;
    FIntfType       : TInterfaceMode;

  protected
    function Get_atIncrementType: TAutoIncrementType; safecall;
    procedure Set_atIncrementType(Value: TAutoIncrementType); safecall;
    function Get_atIncrement: Integer; safecall;
    procedure Set_atIncrement(Value: Integer); safecall;
    function Get_atAutoCreateOnPost: WordBool; safecall;
    procedure Set_atAutoCreateOnPost(Value: WordBool); safecall;
    function Get_atStartDate: WideString; safecall;
    procedure Set_atStartDate(const Value: WideString); safecall;
    function Get_atStartPeriod: Integer; safecall;
    procedure Set_atStartPeriod(Value: Integer); safecall;
    function Get_atStartYear: Integer; safecall;
    procedure Set_atStartYear(Value: Integer); safecall;
    function Get_atEndDate: WideString; safecall;
    procedure Set_atEndDate(const Value: WideString); safecall;
    function Get_atEndPeriod: Integer; safecall;
    procedure Set_atEndPeriod(Value: Integer); safecall;
    function Get_atEndYear: Integer; safecall;
    procedure Set_atEndYear(Value: Integer); safecall;
    function Get_atAutoTransaction: WordBool; safecall;
    procedure Set_atAutoTransaction(Value: WordBool); safecall;
    function Get_atKeepDate: WordBool; safecall;
    procedure Set_atKeepDate(Value: WordBool); safecall;

  public
    constructor Create(TH : Pointer; TransMode : TInterfaceMode);
  end;

implementation

uses
  ComServ;

constructor TAutoTransactionSettings.Create(TH : Pointer; TransMode : TInterfaceMode);
begin
  Inherited Create (ComServer.TypeLib, IAutoTransactionSettings2);

  FTH := TH;
  FIntfType := TransMode;
end;

function TAutoTransactionSettings.Get_atIncrementType: TAutoIncrementType;
begin
  Case FTH^.AutoIncBy of
    'D' : Result := aiDays;
    'P' : Result := aiPeriods;
  end;
end;

procedure TAutoTransactionSettings.Set_atIncrementType(Value: TAutoIncrementType);
begin
  Case Value of
    aiDays    : FTH^.AutoIncBy := 'D';
    aiPeriods : FTH^.AutoIncBy := 'P';
  end;
end;

function TAutoTransactionSettings.Get_atIncrement: Integer;
begin
  Result := FTH^.AutoInc;
end;

procedure TAutoTransactionSettings.Set_atIncrement(Value: Integer);
begin
  FTH^.AutoInc := Value;
end;

function TAutoTransactionSettings.Get_atAutoCreateOnPost: WordBool;
begin
  Result := FTH^.AutoPost;
end;

procedure TAutoTransactionSettings.Set_atAutoCreateOnPost(Value: WordBool);
begin
  FTH^.AutoPost := Value;
end;

function TAutoTransactionSettings.Get_atStartDate: WideString;
begin
  Result := FTH^.TransDate;
end;

procedure TAutoTransactionSettings.Set_atStartDate(const Value: WideString);
begin
  FTH^.TransDate := Value;
  //If do by days then set due date to startdate + increment days
end;

function TAutoTransactionSettings.Get_atStartPeriod: Integer;
begin
  Result := FTH^.AcPr;
end;

procedure TAutoTransactionSettings.Set_atStartPeriod(Value: Integer);
begin
  FTH^.AcPr := Value;
end;

function TAutoTransactionSettings.Get_atStartYear: Integer;
begin
  Result := FTH^.AcYr;
end;

procedure TAutoTransactionSettings.Set_atStartYear(Value: Integer);
begin
  FTH^.AcYr := Value;
end;

function TAutoTransactionSettings.Get_atEndDate: WideString;
begin
  Result := FTH^.AutoEndDate;
end;

procedure TAutoTransactionSettings.Set_atEndDate(const Value: WideString);
begin
  FTH^.AutoEndDate := Value;
end;

function TAutoTransactionSettings.Get_atEndPeriod: Integer;
begin
  Result := FTH^.AutoEndPr;
end;

procedure TAutoTransactionSettings.Set_atEndPeriod(Value: Integer);
begin
  FTH^.AutoEndPr := Value;
end;

function TAutoTransactionSettings.Get_atEndYear: Integer;
begin
  Result := FTH^.AutoEndYr;
end;

procedure TAutoTransactionSettings.Set_atEndYear(Value: Integer);
begin
  FTH^.AutoEndYr := Value;
end;

function TAutoTransactionSettings.Get_atAutoTransaction: WordBool;
begin
  Result := FIsAuto;
end;

procedure TAutoTransactionSettings.Set_atAutoTransaction(Value: WordBool);
begin
  if (FIntfType = imAdd) or ((FIntfType = imUpdate) and (FTH^.RunNo = -2)) then
    FIsAuto := Value
  else
    raise EInvalidProperty.Create('This Transaction cannot be made an Auto-Transaction');
end;




function TAutoTransactionSettings.Get_atKeepDate: WordBool;
begin
  Result := FTH^.thOnPickRun;
end;

procedure TAutoTransactionSettings.Set_atKeepDate(Value: WordBool);
begin
  FTH^.thOnPickRun := Value;
end;

end.
