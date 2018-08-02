unit oCustBal;

{ markd6 15:34 01/11/2001: Disabled Byte Alignment in Delphi 6.0 }
{$ALIGN 1}  { Variable Alignment Disabled }


interface

Uses Classes, Dialogs, Forms, SysUtils, Windows, ComObj, ActiveX,
     {$IFNDEF WANTEXE}Enterprise01_TLB{$ELSE}Enterprise04_TLB{$ENDIF}, VarToolk, MiscFunc,
     ExceptIntf;

type
  TAccountBalance = class(TAutoIntfObjectEx, IAccountBalance, IAccountBalance2)
  protected
    FAccDetails : pBatchCURec;
    FHistRec    : THistoryBalRec;

    // IAccountBalance
    function  Get_acCurrency: Integer; safecall;
    procedure Set_acCurrency(Value: Integer); safecall;
    function  Get_acPeriod: Integer; safecall;
    procedure Set_acPeriod(Value: Integer); safecall;
    function  Get_acYear: Integer; safecall;
    procedure Set_acYear(Value: Integer); safecall;
    function  Get_acBalance: Double; safecall;
    function  Get_acSales: Double; safecall;
    function  Get_acCosts: Double; safecall;
    function  Get_acMargin: Double; safecall;
    function  Get_acDebits: Double; safecall;
    function  Get_acCredits: Double; safecall;
    function  Get_acBudget: Double; safecall;
    function  Get_acCommitted: Double; safecall;

    //PR: 01/08/2011 Added revised budget (ABSEXCH-11018)
    // IAccountBalance2
    function  Get_acRevisedBudget: Double; safecall;

    // 'Local' methods
    Function  GetBalance(Const HistType : Byte) : Double;
  public
    Constructor Create (Const AccDetails : pBatchCURec);
  End; { TAccountBalance }


implementation

uses ComServ, DLL01U, DllErrU, EtMiscU;

{-------------------------------------------------------------------------------------------------}

Constructor TAccountBalance.Create (Const AccDetails : pBatchCURec);
Begin { Create }
  Inherited Create (ComServer.TypeLib, IAccountBalance);

  // Initialise variables
  FAccDetails := AccDetails;

  // Initialise History Details - default to current customer balance
  FillChar (FHistRec, SizeOf(FHistRec), #0);
  With FHistRec Do Begin
    Period     := sYTDHistory;
    Year       := '';
    Currency   := 0;
  End; { With }
End; { Create }

{-----------------------------------------}

function TAccountBalance.Get_acCurrency: Integer;
begin
  Result := FHistRec.Currency;
end;

procedure TAccountBalance.Set_acCurrency(Value: Integer);
begin
  FHistRec.Currency := ValidateCurrencyNo(Value);
end;

{-----------------------------------------}

function TAccountBalance.Get_acPeriod: Integer;
begin
  With FHistRec Do Begin
    // Check for 'YTD' constant
    If (Period = sYTDHistory) Then
      Result := iYTDHistory
    Else
      // numerical period
      Result := StrToInt(Period);
  End; { With FHistRec }
end;

procedure TAccountBalance.Set_acPeriod(Value: Integer);
begin
  // Check for -99 'YTD' constant
  If (Value = iYTDHistory) Then
    FHistRec.Period := sYTDHistory
  Else
    // numerical period
    FHistRec.Period := IntToStr(Value);
end;

{-----------------------------------------}

function TAccountBalance.Get_acYear: Integer;
begin
  With FHistRec Do Begin
    // Check for 0 constant
    If (Year = '') Then
      Result := iYearEverything
    Else Begin
      // numerical period - convert string to year
      Result := StrToInt (Year);

      If (Result < 1900) Then
        // Convert Accounting Year to real year
        Result := Result + 1900;
    End; { Else }
  End; { With FHistRec }
end;

procedure TAccountBalance.Set_acYear(Value: Integer);
begin
  // Check for 0 constant
  If (Value = iYearEverything) Then
    FHistRec.Year := ''
  Else
    // numerical period
    If (Value > 1900) Then
      // Proper Year - convert to Accounting Year
      FHistRec.Year := IntToStr(Value - 1900)
    Else
      // Acounting Year - e.g. 99 = 1999, 101 = 2001
      FHistRec.Year := IntToStr(Value);
end;

{-----------------------------------------}

Function TAccountBalance.GetBalance (Const HistType : Byte) : Double;
Var
  AcCode     : PChar;
  Res        : Integer;
Begin { GetBalance }
  Result := 0;

  // Setup Account Code
  AcCode := StrAlloc(255);
  StrPCopy (AcCode, FAccDetails.CustCode);

  If (HistType <> 8) Then
    // Get Balance
    Res := EX_GETACCOUNTBALANCE(@FHistRec, SizeOf(FHistRec), AcCode, HistType)
  Else
    // Get Committed Balance
    Res := EX_GETACCOUNTBALANCE(@FHistRec, SizeOf(FHistRec), AcCode, 1);

  //PR 03/07/07 Changed to round to 2 dec places. (Bug 200415111503)
  If (Res = 0) Then Begin
    If (HistType = 8) Then
      Result := Round_Up(FHistRec.CommitVal, 2)
    Else
      Result := Round_Up(FHistRec.Value, 2);
  End { If (Res = 0) }
  Else
    Raise Exception.Create (Ex_ErrorDescription (1000, Res));
End; { GetBalance }

{-----------------------------------------}

function TAccountBalance.Get_acBalance: Double;
begin
  Result := GetBalance (0);
end;

function TAccountBalance.Get_acBudget: Double;
begin
  // HM 03/04/01: Modified to pickup correct budget after fixed in Toolkit DLL
  //Result := GetBalance (6);
  Result := GetBalance (7);
end;

function TAccountBalance.Get_acCommitted: Double;
begin
  Result := GetBalance (8);
end;

function TAccountBalance.Get_acCosts: Double;
begin
  Result := GetBalance (2);
end;

function TAccountBalance.Get_acCredits: Double;
begin
  Result := GetBalance (5);
end;

function TAccountBalance.Get_acDebits: Double;
begin
  Result := GetBalance (4);
end;

function TAccountBalance.Get_acMargin: Double;
begin
  Result := GetBalance (3);
end;

function TAccountBalance.Get_acSales: Double;
begin
  Result := GetBalance (1);
end;

{-----------------------------------------}

function TAccountBalance.Get_acRevisedBudget: Double;
begin
  Result := GetBalance(9);
end;

end.

