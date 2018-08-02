unit oJobAct;

interface

Uses Classes, Dialogs, Forms, SysUtils, Windows, CustAbsU, GlobVar, VarConst,
     CustTypU;

Type
  { NOTE: Must be kept in sync with CustAbsU.Pas }
  TJobActual = Class(TAbsJobActual)
  Private
    RecAccess  : TRecAccessStatus;
    PropAccess : Array [1..34] Of TPropertyAccess;
    FuncAccess : Array [1..1] Of TFunctionAccess;
    RecChanged : Boolean;

    EntSys     : TEnterpriseSystem;

    DataRec, OrigRec : JobActType;

    FCcyTri    : TAbsCurrencyTriangulation;
  Protected
    Function  GetRecStatus : TRecAccessStatus; Override;
    Function  GetRecChanged : Boolean; Override;

    Function  GetAnalysisCode : cuStr10; Override;
    Procedure SetAnalysisCode(Value : cuStr10); Override;
    Function  GetCurrency : cuCurrencyType; Override;
    Procedure SetCurrency(Value : cuCurrencyType); Override;
    Function  GetPeriod : Byte; Override;
    Procedure SetPeriod(Value : Byte); Override;
    Function  GetPosted : Boolean; Override;
    Procedure Setposted(Value : Boolean); Override;
    Function  GetLineFolio : LongInt; Override;
    Procedure SetLineFolio(Value : LongInt); Override;
    Function  GetLineNumber : LongInt; Override;
    Procedure SetLineNumber(Value : LongInt); Override;
    Function  GetDocRef : cuStr10; Override;
    Procedure SetDocRef(Value : cuStr10); Override;
    Function  GetStockCode : cuStr16; Override;
    Procedure SetStockCode(Value : cuStr16); Override;
    Function  GetDate : cuLongDate; Override;
    Procedure SetDate(Value : cuLongDate); Override;
    Function  GetQty : Double; Override;
    Procedure SetQty(Value : Double); Override;
    Function  GetCost : Double; Override;
    Procedure SetCost(Value : Double); Override;
    Function  GetCharge : Double; Override;
    Procedure SetCharge(Value : Double); Override;
    Function  GetInvoiced : Boolean; Override;
    Procedure SetInvoiced(Value : Boolean); Override;
    Function  GetInvoiceRef : cuStr10; Override;
    Procedure SetInvoiceRef(Value : cuStr10); Override;
    Function  GetEmployeeCode : cuStr6; Override;
    Procedure SetEmployeeCode(Value : cuStr6); Override;
    Function  GetAnalysisType : Byte; Override;
    Procedure SetAnalysisType(Value : Byte); Override;
    Function  GetPostedRun : LongInt; Override;
    Procedure SetPostedRun(Value : LongInt); Override;
    Function  GetReverseWIP : Boolean; Override;
    Procedure SetReverseWIP(Value : Boolean); Override;
    Function  GetReconciled : Boolean; Override;
    Procedure SetReconciled(Value : Boolean); Override;
    Function  GetDocType : cuDocTypes; Override;
    Procedure SetDocType(Value : cuDocTypes); Override;
    Function  GetChargeCurrency : cuCurrencyType; Override;
    Procedure SetChargeCurrency(Value : cuCurrencyType); Override;
    Function  GetAccountCode : cuStr6; Override;
    Procedure SetAccountCode(Value : cuStr6); Override;
    Function  GetHoldFlag : Byte; Override;
    Procedure SetHoldFlag(Value : Byte); Override;
    Function  GetPostedToStock : Boolean; Override;
    Procedure SetPostedToStock(Value : Boolean); Override;
    Function  GetCompanyRate : Double; Override;
    Procedure SetCompanyRate(Value : Double); Override;
    Function  GetDailyRate : Double; Override;
    Procedure SetDailyRate(Value : Double); Override;
    Function  GetTagged : Boolean; Override;
    Procedure SetTagged(Value : Boolean); Override;
    Function  GetGLCode : LongInt; Override;
    Procedure SetGLCode(Value : LongInt); Override;
    Function  GetUseORate : Byte; Override;
    Procedure SetUseORate(Value : Byte); Override;
    Function  GetTriangulation : TAbsCurrencyTriangulation; Override;
    Function  GetPriceMultiplier : Double; Override;
    Procedure SetPriceMultiplier(Value : Double); Override;
    Function  GetYear : Byte; Override;
    Procedure SetYear(Value : Byte); Override;
    Function  GetUpliftTotal : Double; Override;
    Procedure SetUpliftTotal(Value : Double); Override;
    Function  GetUpliftGL : LongInt; Override;
    Procedure SetUpliftGL(Value : LongInt); Override;
  Public
    Constructor Create (hEntSys : TEnterpriseSystem);
    Destructor  Destroy; Override;

    Procedure   Assign (Const WinId, HandlerId : LongInt;
                        Const JobDetl          : JobDetlRec);
  End; { TJobActual }

implementation

Uses CustWinU, EtStrU, BtKeys1U, BtrvU2, oCcyTri;

Const
  ObjErrStr = 'Job ACtual ';

//=========================================================================

Constructor TJobActual.Create (hEntSys : TEnterpriseSystem);
Begin
  Inherited Create;

  EntSys := hEntSys;

  FillChar (DataRec, SizeOf (DataRec), #0);
  FillChar (OrigRec, SizeOf (OrigRec), #0);

  FCcyTri := TCurrencyTriangulation.Create(hEntSys);
End;

//------------------------------

Destructor TJobActual.Destroy;
Begin { Destroy }
  FreeAndNIL(FCcyTri);
  EntSys := NIL;

  Inherited Destroy;
End; { Destroy }

//-------------------------------------------------------------------------

Procedure TJobActual.Assign (Const WinId, HandlerId : LongInt;
                             Const JobDetl          : JobDetlRec);
Var
  I : SmallInt;
Begin { Assign }
  { Set Security Access to Record }
  If (WinId = wiJobRec) Then
    RecAccess:=ReadOnly
  Else
    RecAccess:=NotAvailable;

  { Load fields from ExLocal }
  FillChar (DataRec, SizeOf (DataRec), #0);
  RecChanged := False;
  If (RecAccess <> NotAvailable) Then Begin
    If (JobDetl.RecPfix = JBRCode) And (JobDetl.SubType = JBECode) Then
      DataRec := JobDetl.JobActual
    Else
      RecAccess := NotAvailable;
  End; { If }
  OrigRec := DataRec;

  { Adjust Security Access for field by Window and Event }
  If (RecAccess <> NotAvailable) Then Begin
    { Set Default Security options }
    For I := Low(PropAccess) To High(PropAccess) Do
      If (RecAccess = ReadOnly) Then
        PropAccess[I] := paReadOnly
      Else
        PropAccess[I] := paReadWrite;

    { Disable additional functions }
    For I := Low(FuncAccess) To High(FuncAccess) Do
      FuncAccess[I] := pfDisabled;

    { Modify default for specific cases }
    //Case ((WinId * 1000) + HandlerId) Of

      // Enable Writeable fields here for each hook point

    //End; { Case ((WinId * 1000) + HandlerId) }

    // Setup Triangulation sub-object
    TCurrencyTriangulation(FCcyTri).Assign (WinId, HandlerId, DataRec.PCTriR);
  End; { If }
End; { Assign }

//-------------------------------------------------------------------------

Function TJobActual.GetRecStatus : TRecAccessStatus;
Begin
  Result := RecAccess;
End;

//-------------------------------------------------------------------------

Function TJobActual.GetRecChanged : Boolean;
Begin
  Result := RecChanged;
End;

//-------------------------------------------------------------------------

function TJobActual.GetAnalysisCode: cuStr10;
begin
  If (RecAccess <> NotAvailable) Then
    Result := DataRec.AnalCode
  Else
    EntSys.DataAccessErrDlg(True, ObjErrStr + 'AnalysisCode');
end;

procedure TJobActual.SetAnalysisCode(Value: cuStr10);
begin
  EntSys.NotImplException ('TAbsJobActual.jaAnalysisCode');
end;

//------------------------------

function TJobActual.GetCurrency: cuCurrencyType;
begin
  Result := Low(cuCurrencytype);
  If (RecAccess <> NotAvailable) Then
    Result := DataRec.ActCurr
  Else
    EntSys.DataAccessErrDlg(True, ObjErrStr + 'Currency');
end;

procedure TJobActual.SetCurrency(Value: cuCurrencyType);
begin
  EntSys.NotImplException ('TAbsJobActual.jaCurrency');
end;

//------------------------------

function TJobActual.GetPeriod: Byte;
begin
  Result := 0;
  If (RecAccess <> NotAvailable) Then
    Result := DataRec.ActPr
  Else
    EntSys.DataAccessErrDlg(True, ObjErrStr + 'Period');
end;

procedure TJobActual.SetPeriod(Value: Byte);
begin
  EntSys.NotImplException ('TAbsJobActual.jaPeriod');
end;

//------------------------------

function TJobActual.GetPosted: Boolean;
begin
  Result := False;
  If (RecAccess <> NotAvailable) Then
    Result := DataRec.Posted
  Else
    EntSys.DataAccessErrDlg(True, ObjErrStr + 'Posted');
end;

procedure TJobActual.SetPosted(Value: Boolean);
begin
  EntSys.NotImplException ('TAbsJobActual.jaPosted');
end;

//------------------------------

function TJobActual.GetLineFolio: LongInt;
begin
  Result := 0;
  If (RecAccess <> NotAvailable) Then
    Result := DataRec.LineFolio
  Else
    EntSys.DataAccessErrDlg(True, ObjErrStr + 'LineFolio');
end;

procedure TJobActual.SetLineFolio(Value: Integer);
begin
  EntSys.NotImplException ('TAbsJobActual.jaLineFolio');
end;

//------------------------------

function TJobActual.GetLineNumber: LongInt;
begin
  Result := 0;
  If (RecAccess <> NotAvailable) Then
    Result := DataRec.LineNo
  Else
    EntSys.DataAccessErrDlg(True, ObjErrStr + 'LineNumber');
end;

procedure TJobActual.SetLineNumber(Value: Integer);
begin
  EntSys.NotImplException ('TAbsJobActual.jaLineNumber');
end;

//------------------------------

function TJobActual.GetDocRef: cuStr10;
begin
  If (RecAccess <> NotAvailable) Then
    Result := DataRec.LineORef
  Else
    EntSys.DataAccessErrDlg(True, ObjErrStr + 'DocRef');
end;

procedure TJobActual.SetDocRef(Value: cuStr10);
begin
  EntSys.NotImplException ('TAbsJobActual.jaDocRef');
end;

//------------------------------

function TJobActual.GetStockCode: cuStr16;
begin
  If (RecAccess <> NotAvailable) Then
    Result := DataRec.StockCode
  Else
    EntSys.DataAccessErrDlg(True, ObjErrStr + 'StockCode');
end;

procedure TJobActual.SetStockCode(Value: cuStr16);
begin
  EntSys.NotImplException ('TAbsJobActual.jaStockCode');
end;

//------------------------------

function TJobActual.GetDate: cuLongDate;
begin
  If (RecAccess <> NotAvailable) Then
    Result := DataRec.JDate
  Else
    EntSys.DataAccessErrDlg(True, ObjErrStr + 'Date');
end;

procedure TJobActual.SetDate(Value: cuLongDate);
begin
  EntSys.NotImplException ('TAbsJobActual.jaDate');
end;

//------------------------------

function TJobActual.GetQty: Double;
begin
  Result := 0;
  If (RecAccess <> NotAvailable) Then
    Result := DataRec.Qty
  Else
    EntSys.DataAccessErrDlg(True, ObjErrStr + 'Qty');
end;

procedure TJobActual.SetQty(Value: Double);
begin
  EntSys.NotImplException ('TAbsJobActual.jaQty');
end;

//------------------------------

function TJobActual.GetCost: Double;
begin
  Result := 0;
  If (RecAccess <> NotAvailable) Then
    Result := DataRec.Cost
  Else
    EntSys.DataAccessErrDlg(True, ObjErrStr + 'Cost');
end;

procedure TJobActual.SetCost(Value: Double);
begin
  EntSys.NotImplException ('TAbsJobActual.jaCost');
end;

//------------------------------

function TJobActual.GetCharge: Double;
begin
  Result := 0;
  If (RecAccess <> NotAvailable) Then
    Result := DataRec.Charge
  Else
    EntSys.DataAccessErrDlg(True, ObjErrStr + 'Charge');
end;

procedure TJobActual.SetCharge(Value: Double);
begin
  EntSys.NotImplException ('TAbsJobActual.jaCharge');
end;

//------------------------------

function TJobActual.GetInvoiced: Boolean;
begin
  Result := False;
  If (RecAccess <> NotAvailable) Then
    Result := DataRec.Invoiced
  Else
    EntSys.DataAccessErrDlg(True, ObjErrStr + 'Invoiced');
end;

procedure TJobActual.SetInvoiced(Value: Boolean);
begin
  EntSys.NotImplException ('TAbsJobActual.jaInvoiced');
end;

//------------------------------

function TJobActual.GetInvoiceRef: cuStr10;
begin
  If (RecAccess <> NotAvailable) Then
    Result := DataRec.InvRef
  Else
    EntSys.DataAccessErrDlg(True, ObjErrStr + 'InvoiceRef');
end;

procedure TJobActual.SetInvoiceRef(Value: cuStr10);
begin
  EntSys.NotImplException ('TAbsJobActual.jaInvoiceRef');
end;

//------------------------------

function TJobActual.GetEmployeeCode: cuStr6;
begin
  If (RecAccess <> NotAvailable) Then
    Result := DataRec.EmplCode
  Else
    EntSys.DataAccessErrDlg(True, ObjErrStr + 'EmployeeCode');
end;

procedure TJobActual.SetEmployeeCode(Value: cuStr6);
begin
  EntSys.NotImplException ('TAbsJobActual.jaEmployeeCode');
end;

//------------------------------

function TJobActual.GetAnalysisType: Byte;
begin
  Result := 0;
  If (RecAccess <> NotAvailable) Then
    Result := DataRec.JAType
  Else
    EntSys.DataAccessErrDlg(True, ObjErrStr + 'AnalysisType');
end;

procedure TJobActual.SetAnalysisType(Value: Byte);
begin
  EntSys.NotImplException ('TAbsJobActual.jaAnalysisType');
end;

//------------------------------

function TJobActual.GetPostedRun: LongInt;
begin
  Result := 0;
  If (RecAccess <> NotAvailable) Then
    Result := DataRec.PostedRun
  Else
    EntSys.DataAccessErrDlg(True, ObjErrStr + 'PostedRun');
end;

procedure TJobActual.SetPostedRun(Value: Integer);
begin
  EntSys.NotImplException ('TAbsJobActual.jaPostedRun');
end;

//------------------------------

function TJobActual.GetReverseWIP: Boolean;
begin
  Result := False;
  If (RecAccess <> NotAvailable) Then
    Result := DataRec.Reverse
  Else
    EntSys.DataAccessErrDlg(True, ObjErrStr + 'ReverseWIP');
end;

procedure TJobActual.SetReverseWIP(Value: Boolean);
begin
  EntSys.NotImplException ('TAbsJobActual.jaReverseWIP');
end;

//------------------------------

function TJobActual.GetReconciled: Boolean;
begin
  Result := False;
  If (RecAccess <> NotAvailable) Then
    Result := DataRec.ReconTS
  Else
    EntSys.DataAccessErrDlg(True, ObjErrStr + 'Reconciled');
end;

procedure TJobActual.SetReconciled(Value: Boolean);
begin
  EntSys.NotImplException ('TAbsJobActual.jaReconciled');
end;

//------------------------------

function TJobActual.GetDocType: cuDocTypes;
begin
  Result := Low(cuDocTypes);
  If (RecAccess <> NotAvailable) Then
    Result := cuDocTypes(DataRec.JDDT)
  Else
    EntSys.DataAccessErrDlg(True, ObjErrStr + 'DocType');
end;

procedure TJobActual.SetDocType(Value: cuDocTypes);
begin
  EntSys.NotImplException ('TAbsJobActual.jaDocType');
end;

//------------------------------

function TJobActual.GetChargeCurrency: cuCurrencyType;
begin
  Result := Low(cuCurrencyType);
  If (RecAccess <> NotAvailable) Then
    Result := DataRec.CurrCharge
  Else
    EntSys.DataAccessErrDlg(True, ObjErrStr + 'ChargeCurrency');
end;

procedure TJobActual.SetChargeCurrency(Value: cuCurrencyType);
begin
  EntSys.NotImplException ('TAbsJobActual.jaChargeCurrency');
end;

//------------------------------

function TJobActual.GetAccountCode: cuStr6;
begin
  If (RecAccess <> NotAvailable) Then
    Result := DataRec.ActCCode
  Else
    EntSys.DataAccessErrDlg(True, ObjErrStr + 'AccountCode');
end;

procedure TJobActual.SetAccountCode(Value: cuStr6);
begin
  EntSys.NotImplException ('TAbsJobActual.jaAccountCode');
end;

//------------------------------

function TJobActual.GetHoldFlag: Byte;
begin
  Result := 0;
  If (RecAccess <> NotAvailable) Then
    Result := DataRec.HoldFlg
  Else
    EntSys.DataAccessErrDlg(True, ObjErrStr + 'HoldFlag');
end;

procedure TJobActual.SetHoldFlag(Value: Byte);
begin
  EntSys.NotImplException ('TAbsJobActual.jaHoldFlag');
end;

//------------------------------

function TJobActual.GetPostedToStock: Boolean;
begin
  Result := False;
  If (RecAccess <> NotAvailable) Then
    Result := DataRec.Post2Stk
  Else
    EntSys.DataAccessErrDlg(True, ObjErrStr + 'PostedToStock');
end;

procedure TJobActual.SetPostedToStock(Value: Boolean);
begin
  EntSys.NotImplException ('TAbsJobActual.jaPostedToStock');
end;

//------------------------------

function TJobActual.GetCompanyRate: Double;
begin
  Result := 0;
  If (RecAccess <> NotAvailable) Then
    Result := DataRec.PCRates[False]
  Else
    EntSys.DataAccessErrDlg(True, ObjErrStr + 'CompanyRate');
end;

procedure TJobActual.SetCompanyRate(Value: Double);
begin
  EntSys.NotImplException ('TAbsJobActual.jaCompanyRate');
end;

//------------------------------

function TJobActual.GetDailyRate: Double;
begin
  Result := 0;
  If (RecAccess <> NotAvailable) Then
    Result := DataRec.PCRates[True]
  Else
    EntSys.DataAccessErrDlg(True, ObjErrStr + 'DailyRate');
end;

procedure TJobActual.SetDailyRate(Value: Double);
begin
  EntSys.NotImplException ('TAbsJobActual.jaDailyRate');
end;

//------------------------------

function TJobActual.GetTagged: Boolean;
begin
  Result := False;
  If (RecAccess <> NotAvailable) Then
    Result := DataRec.Tagged
  Else
    EntSys.DataAccessErrDlg(True, ObjErrStr + 'Tagged');
end;

procedure TJobActual.SetTagged(Value: Boolean);
begin
  EntSys.NotImplException ('TAbsJobActual.jaTagged');
end;

//------------------------------

function TJobActual.GetGLCode: LongInt;
begin
  Result := 0;
  If (RecAccess <> NotAvailable) Then
    Result := DataRec.OrigNCode
  Else
    EntSys.DataAccessErrDlg(True, ObjErrStr + 'GLCode');
end;

procedure TJobActual.SetGLCode(Value: Integer);
begin
  EntSys.NotImplException ('TAbsJobActual.jaGLCode');
end;

//------------------------------

function TJobActual.GetUseORate: Byte;
begin
  Result := 0;
  If (RecAccess <> NotAvailable) Then
    Result := DataRec.JUseORate
  Else
    EntSys.DataAccessErrDlg(True, ObjErrStr + 'UseORate');
end;

procedure TJobActual.SetUseORate(Value: Byte);
begin
  EntSys.NotImplException ('TAbsJobActual.jaUseORate');
end;

//------------------------------

function TJobActual.GetTriangulation: TAbsCurrencyTriangulation;
begin
  Result := nil;
  If (RecAccess <> NotAvailable) Then
    Result := FCcyTri
  Else
    EntSys.DataAccessErrDlg(True, ObjErrStr + 'Triangulation');
end;

//------------------------------

function TJobActual.GetPriceMultiplier: Double;
begin
  Result := 0;
  If (RecAccess <> NotAvailable) Then
    Result := DataRec.JPriceMulX
  Else
    EntSys.DataAccessErrDlg(True, ObjErrStr + 'PriceMultiplier');
end;

procedure TJobActual.SetPriceMultiplier(Value: Double);
begin
  EntSys.NotImplException ('TAbsJobActual.jaPriceMultiplier');
end;

//------------------------------

function TJobActual.GetYear: Byte;
begin
  Result := 0;
  If (RecAccess <> NotAvailable) Then
    Result := DataRec.ActYr
  Else
    EntSys.DataAccessErrDlg(True, ObjErrStr + 'Year');
end;

procedure TJobActual.SetYear(Value: Byte);
begin
  EntSys.NotImplException ('TAbsJobActual.jaYear');
end;

//------------------------------

function TJobActual.GetUpliftTotal: Double;
begin
  Result := 0;
  If (RecAccess <> NotAvailable) Then
    Result := DataRec.UpliftTotal
  Else
    EntSys.DataAccessErrDlg(True, ObjErrStr + 'UpliftTotal');
end;

procedure TJobActual.SetUpliftTotal(Value: Double);
begin
  EntSys.NotImplException ('TAbsJobActual.jaUpliftTotal');
end;

//------------------------------

function TJobActual.GetUpliftGL: LongInt;
begin
  Result := 0;
  If (RecAccess <> NotAvailable) Then
    Result := DataRec.UpliftGL
  Else
    EntSys.DataAccessErrDlg(True, ObjErrStr + 'UpliftGL');
end;

procedure TJobActual.SetUpliftGL(Value: Integer);
begin
  EntSys.NotImplException ('TAbsJobActual.jaUpliftGL');
end;

//-------------------------------------------------------------------------

end.
