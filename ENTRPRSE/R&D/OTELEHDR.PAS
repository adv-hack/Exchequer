unit oTeleHdr;

interface

Uses Classes, Dialogs, Forms, SysUtils, Windows, CustAbsU, GlobVar, VarConst,
     CustTypU, VarRec2U, oTeleLin;

Type
  { NOTE: Must be kept in sync with CustAbsU.Pas }
  TTelesales = Class(TAbsTelesales4)
  Private
    RecAccess  : TRecAccessStatus;
    PropAccess : Array [1..37] Of TPropertyAccess;
    FuncAccess : Array [1..1] Of TFunctionAccess;
    RecChanged : Boolean;

    EntSys     : TEnterpriseSystem;

    DataRec, OrigRec : TeleCustType;

    FSalesLine : TAbsTelesalesLine;
  Protected
    Function  GetRecStatus : TRecAccessStatus; Override;
    Function  GetRecChanged : Boolean; Override;

    Function GetCustCode : cuStr6; Override;
    Procedure SetCustCode (Value : cuStr6); Override;
    Function GetCurrency : Byte; Override;
    Procedure SetCurrency (Value : Byte); Override;
    Function GetCompanyRate : Real; Override;
    Procedure SetCompanyRate (Value : Real); Override;
    Function GetDailyRate : Real; Override;
    Procedure SetDailyRate (Value : Real); Override;
    Function GetYourRef : cuStr10; Override;
    Procedure SetYourRef (Value : cuStr10); Override;
    Function GetAltRef : cuStr20; Override;
    Procedure SetAltRef (Value : cuStr20); Override;
    Function GetCostCentre : cuStr3; Override;
    Procedure SetCostCentre (Value : cuStr3); Override;
    Function GetDepartment : cuStr3; Override;
    Procedure SetDepartment (Value : cuStr3); Override;
    Function GetLocation : cuStr3; Override;
    Procedure SetLocation (Value : cuStr3); Override;
    Function GetJobCode : cuStr10; Override;
    Procedure SetJobCode (Value : cuStr10); Override;
    Function GetJobAnal : cuStr10; Override;
    Procedure SetJobAnal (Value : cuStr10); Override;
    Function  GetDelAddr(Index : cuAddrIndex) : cuStr30; Override;
    Procedure SetDelAddr(Index : cuAddrIndex; Value : cuStr30); Override;
    Function GetTransDate : cuLongDate; Override;
    Procedure SetTransDate (Value : cuLongDate); Override;
    Function GetDueDate : cuLongDate; Override;
    Procedure SetDueDate (Value : cuLongDate); Override;
    Function GetNetTotal : Double; Override;
    Procedure SetNetTotal (Value : Double); Override;
    Function GetVATTotal : Double; Override;
    Procedure SetVATTotal (Value : Double); Override;
    Function GetTotalDiscount : Double; Override;
    Procedure SetTotalDiscount (Value : Double); Override;
    Function GetUser : cuStr10; Override;
    Procedure SetUser (Value : cuStr10); Override;
    Function GetInProgress : Boolean; Override;
    Procedure SetInProgress (Value : Boolean); Override;
    Function GetTransportNature : Byte; Override;
    Procedure SetTransportNature (Value : Byte); Override;
    Function GetTransportMode : Byte; Override;
    Procedure SetTransportMode (Value : Byte); Override;
    Function GetDelTerms : cuStr3; Override;
    Procedure SetDelTerms (Value : cuStr3); Override;
    Function GetControlGL : LongInt; Override;
    Procedure SetControlGL (Value : LongInt); Override;
    Function GetVATCode : Char; Override;
    Procedure SetVATCode (Value : Char); Override;
    Function GetHistoryAnalysisMode : Byte; Override;
    Procedure SetHistoryAnalysisMode (Value : Byte); Override;
    Function GetListScaleMode : Byte; Override;
    Procedure SetListScaleMode (Value : Byte); Override;
    Function GetWasNew : Boolean; Override;
    Procedure SetWasNew (Value : Boolean); Override;
    Function GetUseORate : Byte; Override;
    Procedure SetUseORate (Value : Byte); Override;
    Function GetDefaultGLCode : LongInt; Override;
    Procedure SetDefaultGLCode (Value : LongInt); Override;
    Function GetInclusiveVATCode : Char; Override;
    Procedure SetInclusiveVATCode (Value : Char); Override;
    Function GetDefSettleDisc : Double; Override;
    Procedure SetDefSettleDisc (Value : Double); Override;
    Function GetTransactionType : Byte; Override;
    Procedure SetTransactionType (Value : Byte); Override;
    Function GetSalesLine : TAbsTelesalesLine; Override;

    // MH 30/09/2013 MRD Branch for v7.0.7: Added new fields for Delivery Postcode
    Function GetDeliveryPostCode : cuStr20; Override;
    Procedure SetDeliveryPostCode (Value : cuStr20); Override;

    // MH 26/11/2014: Added new field for Delivery Country Code
    Function GetDeliveryCountry : cuStr2; Override;
    Procedure SetDeliveryCountry (Value : cuStr2); Override;

    // MH 20/01/2016 Exch2016-R1: Intrastat enhancements - TAbsTelesales4
    Function GetSSDProcess : Char; Override;
    Procedure SetSSDProcess (Value : Char); Override;

    // Internal Methods
    Function GetoSalesLine : TTelesalesLine;
  Public
    Property oSalesLine : TTelesalesLine Read GetoSalesLine;

    Constructor Create (hEntSys : TEnterpriseSystem);
    Destructor  Destroy; Override;

    Procedure   Assign (Const WinId, HandlerId : LongInt;
                        Const TeleRec          : MLocRec);
  End; { TTelesales }

implementation

Uses CustWinU, EtStrU, BtKeys1U, BtrvU2;

Const
  ObjErrStr = 'Telesales ';

//=========================================================================

Constructor TTelesales.Create (hEntSys : TEnterpriseSystem);
Begin
  Inherited Create;

  EntSys := hEntSys;

  FillChar (DataRec, SizeOf (DataRec), #0);
  FillChar (OrigRec, SizeOf (OrigRec), #0);

  FSalesLine := TTelesalesLine.Create(hEntSys);
End;

//------------------------------

Destructor TTelesales.Destroy;
Begin { Destroy }
  FreeAndNIL(FSalesLine);

  EntSys := NIL;

  Inherited Destroy;
End; { Destroy }

//-------------------------------------------------------------------------

Procedure TTelesales.Assign (Const WinId, HandlerId : LongInt;
                             Const TeleRec          : MLocRec);
Var
  I : SmallInt;
Begin { Assign }
  { Set Security Access to Record }
  If (WinId = wiAccount) Or (WinId = wiTransaction) Or (WinId = wiTransLine) Then
    RecAccess:=ReadOnly
  Else
    RecAccess:=NotAvailable;

  { Load fields from ExLocal }
  FillChar (DataRec, SizeOf (DataRec), #0);
  RecChanged := False;
  If (RecAccess <> NotAvailable) Then Begin
    If (TeleRec.RecPfix = MatchTCode) And (TeleRec.SubType = PostLCode) Then
      DataRec := TeleRec.TeleSRec
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
  End; { If }

  TTelesalesLine(FSalesLine).Assign(WinId, HandlerId, TeleRec);
End; { Assign }

//-------------------------------------------------------------------------

Function TTelesales.GetRecStatus : TRecAccessStatus;
Begin
  Result := RecAccess;
End;

//-------------------------------------------------------------------------

Function TTelesales.GetRecChanged : Boolean;
Begin
  Result := RecChanged Or
            // HM 17/03/03: Added sub-object
            FSalesLine.DataChanged;
End;

//-------------------------------------------------------------------------

function TTelesales.GetCustCode: cuStr6;
begin
  If (RecAccess <> NotAvailable) Then
    Result := DataRec.tcCustCode
  Else
    EntSys.DataAccessErrDlg(True, ObjErrStr + 'CustCode');
end;

procedure TTelesales.SetCustCode(Value: cuStr6);
begin
  EntSys.NotImplException ('TAbsTelesales.teCustCode');
end;

//------------------------------

function TTelesales.GetCurrency: Byte;
begin
  Result := 0;
  If (RecAccess <> NotAvailable) Then
    Result := DataRec.tcCurr
  Else
    EntSys.DataAccessErrDlg(True, ObjErrStr + 'Currency');
end;

procedure TTelesales.SetCurrency(Value: Byte);
begin
  EntSys.NotImplException ('TAbsTelesales.teCurrency');
end;

//------------------------------

function TTelesales.GetCompanyRate: Real;
begin
  Result := 0;
  If (RecAccess <> NotAvailable) Then
    Result := DataRec.tcCXrate[BOff]
  Else
    EntSys.DataAccessErrDlg(True, ObjErrStr + 'CompanyRate');
end;

procedure TTelesales.SetCompanyRate(Value: Real);
begin
  EntSys.NotImplException ('TAbsTelesales.teCompanyRate');
end;

//------------------------------

function TTelesales.GetDailyRate: Real;
begin
  Result := 0;
  If (RecAccess <> NotAvailable) Then
    Result := DataRec.tcCXrate[BOn]
  Else
    EntSys.DataAccessErrDlg(True, ObjErrStr + 'DailyRate');
end;

procedure TTelesales.SetDailyRate(Value: Real);
begin
  EntSys.NotImplException ('TAbsTelesales.DailyRate');
end;

//------------------------------

function TTelesales.GetYourRef: cuStr10;
begin
  If (RecAccess <> NotAvailable) Then
    Result := DataRec.tcYourRef
  Else
    EntSys.DataAccessErrDlg(True, ObjErrStr + 'YourRef');
end;

procedure TTelesales.SetYourRef(Value: cuStr10);
begin
  EntSys.NotImplException ('TAbsTelesales.teYourRef');
end;

//------------------------------

function TTelesales.GetAltRef: cuStr20;
begin
  If (RecAccess <> NotAvailable) Then
    Result := DataRec.tcLYRef
  Else
    EntSys.DataAccessErrDlg(True, ObjErrStr + 'AltRef');
end;

procedure TTelesales.SetAltRef(Value: cuStr20);
begin
  EntSys.NotImplException ('TAbsTelesales.teAltRef');
end;

//------------------------------

function TTelesales.GetCostCentre: cuStr3;
begin
  If (RecAccess <> NotAvailable) Then
    Result := DataRec.tcCCDep[BOn]
  Else
    EntSys.DataAccessErrDlg(True, ObjErrStr + 'CostCentre');
end;

procedure TTelesales.SetCostCentre(Value: cuStr3);
begin
  EntSys.NotImplException ('TAbsTelesales.teCostCentre');
end;

//------------------------------

function TTelesales.GetDepartment: cuStr3;
begin
  If (RecAccess <> NotAvailable) Then
    Result := DataRec.tcCCDep[BOff]
  Else
    EntSys.DataAccessErrDlg(True, ObjErrStr + 'Department');
end;

procedure TTelesales.SetDepartment(Value: cuStr3);
begin
  EntSys.NotImplException ('TAbsTelesales.teDepartment');
end;

//------------------------------

function TTelesales.GetLocation: cuStr3;
begin
  If (RecAccess <> NotAvailable) Then
    Result := DataRec.tcLocCode
  Else
    EntSys.DataAccessErrDlg(True, ObjErrStr + 'Location');
end;

procedure TTelesales.SetLocation(Value: cuStr3);
begin
  EntSys.NotImplException ('TAbsTelesales.teLocation');
end;

//------------------------------

function TTelesales.GetJobCode: cuStr10;
begin
  If (RecAccess <> NotAvailable) Then
    Result := DataRec.tcJobCode
  Else
    EntSys.DataAccessErrDlg(True, ObjErrStr + 'JobCode');
end;

procedure TTelesales.SetJobCode(Value: cuStr10);
begin
  EntSys.NotImplException ('TAbsTelesales.teJobCode');
end;

//------------------------------

function TTelesales.GetJobAnal: cuStr10;
begin
  If (RecAccess <> NotAvailable) Then
    Result := DataRec.tcJACode
  Else
    EntSys.DataAccessErrDlg(True, ObjErrStr + 'JobAnal');
end;

procedure TTelesales.SetJobAnal(Value: cuStr10);
begin
  EntSys.NotImplException ('TAbsTelesales.teJobAnal');
end;

//------------------------------

function TTelesales.GetDelAddr(Index: cuAddrIndex): cuStr30;
begin
  If (RecAccess <> NotAvailable) Then
    Result := DataRec.tcDAddr[Index]
  Else
    EntSys.DataAccessErrDlg(True, ObjErrStr + 'DelAddr');
end;

procedure TTelesales.SetDelAddr(Index: cuAddrIndex; Value: cuStr30);
begin
  EntSys.NotImplException ('TAbsTelesales.teDelAddr');
end;

//------------------------------

function TTelesales.GetTransDate: cuLongDate;
begin
  If (RecAccess <> NotAvailable) Then
    Result := DataRec.tcTDate
  Else
    EntSys.DataAccessErrDlg(True, ObjErrStr + 'TransDate');
end;

procedure TTelesales.SetTransDate(Value: cuLongDate);
begin
  EntSys.NotImplException ('TAbsTelesales.teTransDate');
end;

//------------------------------

function TTelesales.GetDueDate: cuLongDate;
begin
  If (RecAccess <> NotAvailable) Then
    Result := DataRec.tcDelDate
  Else
    EntSys.DataAccessErrDlg(True, ObjErrStr + 'DueDate');
end;

procedure TTelesales.SetDueDate(Value: cuLongDate);
begin
  EntSys.NotImplException ('TAbsTelesales.teDueDate');
end;

//------------------------------

function TTelesales.GetNetTotal: Double;
begin
  Result := 0;
  If (RecAccess <> NotAvailable) Then
    Result := DataRec.tcNetTotal
  Else
    EntSys.DataAccessErrDlg(True, ObjErrStr + 'NetTotal');
end;

procedure TTelesales.SetNetTotal(Value: Double);
begin
  EntSys.NotImplException ('TAbsTelesales.teNetTotal');
end;

//------------------------------

function TTelesales.GetVATTotal: Double;
begin
  Result := 0;
  If (RecAccess <> NotAvailable) Then
    Result := DataRec.tcVATTotal
  Else
    EntSys.DataAccessErrDlg(True, ObjErrStr + 'VATTotal');
end;

procedure TTelesales.SetVATTotal(Value: Double);
begin
  EntSys.NotImplException ('TAbsTelesales.teVATTotal');
end;

//------------------------------

function TTelesales.GetTotalDiscount: Double;
begin
  Result := 0;
  If (RecAccess <> NotAvailable) Then
    Result := DataRec.tcDiscTotal
  Else
    EntSys.DataAccessErrDlg(True, ObjErrStr + 'TotalDiscount');
end;

procedure TTelesales.SetTotalDiscount(Value: Double);
begin
  EntSys.NotImplException ('TAbsTelesales.teTotalDiscount');
end;

//------------------------------

function TTelesales.GetUser: cuStr10;
begin
  If (RecAccess <> NotAvailable) Then
    Result := DataRec.tcLastOpo
  Else
    EntSys.DataAccessErrDlg(True, ObjErrStr + 'User');
end;

procedure TTelesales.SetUser(Value: cuStr10);
begin
  EntSys.NotImplException ('TAbsTelesales.teUser');
end;

//------------------------------

function TTelesales.GetInProgress: Boolean;
begin
  Result := False;
  If (RecAccess <> NotAvailable) Then
    Result := DataRec.tcInProg
  Else
    EntSys.DataAccessErrDlg(True, ObjErrStr + 'InProgress');
end;

procedure TTelesales.SetInProgress(Value: Boolean);
begin
  EntSys.NotImplException ('TAbsTelesales.teInProgress');
end;

//------------------------------

function TTelesales.GetTransportNature: Byte;
begin
  Result := 0;
  If (RecAccess <> NotAvailable) Then
    Result := DataRec.tcTransNat
  Else
    EntSys.DataAccessErrDlg(True, ObjErrStr + 'TransportNature');
end;

procedure TTelesales.SetTransportNature(Value: Byte);
begin
  EntSys.NotImplException ('TAbsTelesales.teTransportNature');
end;

//------------------------------

function TTelesales.GetTransportMode: Byte;
begin
  Result := 0;
  If (RecAccess <> NotAvailable) Then
    Result := DataRec.tcTransMode
  Else
    EntSys.DataAccessErrDlg(True, ObjErrStr + 'TransportMode');
end;

procedure TTelesales.SetTransportMode(Value: Byte);
begin
  EntSys.NotImplException ('TAbsTelesales.teTransportMode');
end;

//------------------------------

function TTelesales.GetDelTerms: cuStr3;
begin
  If (RecAccess <> NotAvailable) Then
    Result := DataRec.tcDelTerms
  Else
    EntSys.DataAccessErrDlg(True, ObjErrStr + 'DelTerms');
end;

procedure TTelesales.SetDelTerms(Value: cuStr3);
begin
  EntSys.NotImplException ('TAbsTelesales.teDelTerms');
end;

//------------------------------

function TTelesales.GetControlGL: LongInt;
begin
  Result := 0;
  If (RecAccess <> NotAvailable) Then
    Result := DataRec.tcCtrlCode
  Else
    EntSys.DataAccessErrDlg(True, ObjErrStr + 'ControlGL');
end;

procedure TTelesales.SetControlGL(Value: Integer);
begin
  EntSys.NotImplException ('TAbsTelesales.teControlGL');
end;

//------------------------------

function TTelesales.GetVATCode: Char;
begin
  Result := #0;
  If (RecAccess <> NotAvailable) Then
    Result := DataRec.tcVATCode
  Else
    EntSys.DataAccessErrDlg(True, ObjErrStr + 'VATCode');
end;

procedure TTelesales.SetVATCode(Value: Char);
begin
  EntSys.NotImplException ('TAbsTelesales.teVATCode');
end;

//------------------------------

function TTelesales.GetHistoryAnalysisMode: Byte;
begin
  Result := 0;
  If (RecAccess <> NotAvailable) Then
    Result := DataRec.tcOrdMode
  Else
    EntSys.DataAccessErrDlg(True, ObjErrStr + 'HistoryAnalysisMode');
end;

procedure TTelesales.SetHistoryAnalysisMode(Value: Byte);
begin
  EntSys.NotImplException ('TAbsTelesales.teHistoryAnalysisMode');
end;

//------------------------------

function TTelesales.GetListScaleMode: Byte;
begin
  Result := 0;
  If (RecAccess <> NotAvailable) Then
    Result := DataRec.tcScaleMode
  Else
    EntSys.DataAccessErrDlg(True, ObjErrStr + 'ListScaleMode');
end;

procedure TTelesales.SetListScaleMode(Value: Byte);
begin
  EntSys.NotImplException ('TAbsTelesales.teListScaleMode');
end;

//------------------------------

function TTelesales.GetWasNew: Boolean;
begin
  Result := False;
  If (RecAccess <> NotAvailable) Then
    Result := DataRec.tcWasNew
  Else
    EntSys.DataAccessErrDlg(True, ObjErrStr + 'WasNew');
end;

procedure TTelesales.SetWasNew(Value: Boolean);
begin
  EntSys.NotImplException ('TAbsTelesales.teWasNew');
end;

//------------------------------

function TTelesales.GetUseORate: Byte;
begin
  Result := 0;
  If (RecAccess <> NotAvailable) Then
    Result := DataRec.tcUseORate
  Else
    EntSys.DataAccessErrDlg(True, ObjErrStr + 'UseORate');
end;

procedure TTelesales.SetUseORate(Value: Byte);
begin
  EntSys.NotImplException ('TAbsTelesales.teUseORate');
end;

//------------------------------

function TTelesales.GetDefaultGLCode: LongInt;
begin
  Result := 0;
  If (RecAccess <> NotAvailable) Then
    Result := DataRec.tcDefNomCode
  Else
    EntSys.DataAccessErrDlg(True, ObjErrStr + 'DefaultGLCode');
end;

procedure TTelesales.SetDefaultGLCode(Value: Integer);
begin
  EntSys.NotImplException ('TAbsTelesales.teDefaultGLCode');
end;

//------------------------------

function TTelesales.GetInclusiveVATCode: Char;
begin
  Result := #0;
  If (RecAccess <> NotAvailable) Then
    Result := DataRec.tcVATIncFlg
  Else
    EntSys.DataAccessErrDlg(True, ObjErrStr + 'InclusiveVATCode');
end;

procedure TTelesales.SetInclusiveVATCode(Value: Char);
begin
  EntSys.NotImplException ('TAbsTelesales.teInclusiveVATCode');
end;

//------------------------------

function TTelesales.GetDefSettleDisc: Double;
begin
  Result := 0;
  If (RecAccess <> NotAvailable) Then
    Result := DataRec.tcSetDisc
  Else
    EntSys.DataAccessErrDlg(True, ObjErrStr + 'DefSettleDisc');
end;

procedure TTelesales.SetDefSettleDisc(Value: Double);
begin
  EntSys.NotImplException ('TAbsTelesales.teDefSettleDisc');
end;

//------------------------------

function TTelesales.GetTransactionType: Byte;
begin
  Result := 0;
  If (RecAccess <> NotAvailable) Then
    Result := DataRec.tcGenMode
  Else
    EntSys.DataAccessErrDlg(True, ObjErrStr + 'TransactionType');
end;

procedure TTelesales.SetTransactionType(Value: Byte);
begin
  EntSys.NotImplException ('TAbsTelesales.teTransactionType');
end;

//------------------------------

Function TTelesales.GetSalesLine : TAbsTelesalesLine;
begin
  Result := FSalesLine;
end;

Function TTelesales.GetoSalesLine : TTelesalesLine;
begin
  Result := TTelesalesLine(FSalesLine);
end;

//-------------------------------------------------------------------------

// MH 30/09/2013 MRD Branch for v7.0.7: Added new fields for Delivery Postcode
Function TTelesales.GetDeliveryPostCode : cuStr20;
Begin // GetDeliveryPostCode
  If (RecAccess <> NotAvailable) Then
    Result := DataRec.tcDeliveryPostCode
  Else
    EntSys.DataAccessErrDlg(True, ObjErrStr + 'DeliveryPostCode');
End; // GetDeliveryPostCode

Procedure TTelesales.SetDeliveryPostCode (Value : cuStr20);
Begin // SetDeliveryPostCode
  EntSys.NotImplException ('TAbsTelesales.teDeliveryPostCode');
End; // SetDeliveryPostCode

//-------------------------------------------------------------------------

// MH 26/11/2014: Added new field for Delivery Country Code
Function TTelesales.GetDeliveryCountry : cuStr2;
Begin // GetDeliveryCountry
  If (RecAccess <> NotAvailable) Then
    Result := DataRec.tcDeliveryCountry
  Else
    EntSys.DataAccessErrDlg(True, ObjErrStr + 'DeliveryCountry');
End; // GetDeliveryCountry
Procedure TTelesales.SetDeliveryCountry (Value : cuStr2);
Begin // SetDeliveryCountry
  EntSys.NotImplException ('TAbsTelesales.teDeliveryCountry');
End; // SetDeliveryCountry

//-------------------------------------------------------------------------

// MH 20/01/2016 Exch2016-R1: Intrastat enhancements - TAbsTelesales4
Function TTelesales.GetSSDProcess : Char;
Begin // GetSSDProcess
  Result := #0;
  If (RecAccess <> NotAvailable) Then
    Result := DataRec.tcSSDProcess
  Else
    EntSys.DataAccessErrDlg(True, ObjErrStr + 'SSDProcess');
End; // GetSSDProcess
Procedure TTelesales.SetSSDProcess (Value : Char);
Begin // SetSSDProcess
  EntSys.NotImplException ('TAbsTelesales.teSSDProcess');
End; // SetSSDProcess

//=========================================================================

end.
