unit oCcyTri;

interface

Uses Classes, Dialogs, Forms, SysUtils, Windows, CustAbsU, GlobVar, VarConst,
     CustTypU, VarRec2U;

Type
  { NOTE: Must be kept in sync with CustAbsU.Pas }
  TCurrencyTriangulation = Class(TAbsCurrencyTriangulation)
  Private
    RecAccess  : TRecAccessStatus;
    EntSys     : TEnterpriseSystem;
    DataRec, OrigRec : TriCurType;
  Protected
    Function  GetRate : Double; Override;
    Procedure SetRate(Value : Double); Override;
    Function  GetEuro : Byte; Override;
    Procedure SetEuro(Value : Byte); Override;
    Function  GetInvert : Boolean; Override;
    Procedure SetInvert(Value : Boolean); Override;
    Function  GetFloat : Boolean; Override;
    Procedure SetFloat(Value : Boolean); Override;
  Public
    Constructor Create (hEntSys : TEnterpriseSystem);
    Destructor  Destroy; Override;
    Procedure   Assign (Const WinId, HandlerId : LongInt;
                        Const CcyTri           : TriCurType);
  End; { TCurrencyTriangulation }

implementation

Uses CustWinU, EtStrU, BtKeys1U, BtrvU2;

Const
  ObjErrStr = 'Currency Triangulation ';

//=========================================================================

Constructor TCurrencyTriangulation.Create (hEntSys : TEnterpriseSystem);
Begin
  Inherited Create;

  EntSys := hEntSys;

  FillChar (DataRec, SizeOf (DataRec), #0);
  FillChar (OrigRec, SizeOf (OrigRec), #0);
End;

//------------------------------

Destructor TCurrencyTriangulation.Destroy;
Begin { Destroy }
  EntSys := NIL;

  Inherited Destroy;
End; { Destroy }

//-------------------------------------------------------------------------

Procedure TCurrencyTriangulation.Assign (Const WinId, HandlerId : LongInt;
                                         Const CcyTri           : TriCurType);
Begin { Assign }
  RecAccess := ReadOnly;
  DataRec := CcyTri;
  OrigRec := DataRec;
End; { Assign }

//-------------------------------------------------------------------------

function TCurrencyTriangulation.GetRate: Double;
begin
  Result := 0;
  If (RecAccess <> NotAvailable) Then
    Result := DataRec.TriRates
  Else
    EntSys.DataAccessErrDlg(True, ObjErrStr + 'Rate');
end;

procedure TCurrencyTriangulation.SetRate(Value: Double);
begin
  EntSys.NotImplException ('TAbsCurrencyTriangulation.tcRate');
end;

//------------------------------

function TCurrencyTriangulation.GetEuro: Byte;
begin
  Result := 0;
  If (RecAccess <> NotAvailable) Then
    Result := DataRec.TriEuro
  Else
    EntSys.DataAccessErrDlg(True, ObjErrStr + 'Euro');
end;

procedure TCurrencyTriangulation.SetEuro(Value: Byte);
begin
  EntSys.NotImplException ('TAbsCurrencyTriangulation.tcEuro');
end;

//------------------------------

function TCurrencyTriangulation.GetInvert: Boolean;
begin
  Result := False;
  If (RecAccess <> NotAvailable) Then
    Result := DataRec.TriInvert
  Else
    EntSys.DataAccessErrDlg(True, ObjErrStr + 'Invert');
end;

procedure TCurrencyTriangulation.SetInvert(Value: Boolean);
begin
  EntSys.NotImplException ('TAbsCurrencyTriangulation.tcInvert');
end;

//------------------------------

function TCurrencyTriangulation.GetFloat: Boolean;
begin
  Result := False;
  If (RecAccess <> NotAvailable) Then
    Result := DataRec.TriFloat
  Else
    EntSys.DataAccessErrDlg(True, ObjErrStr + 'Float');
end;

procedure TCurrencyTriangulation.SetFloat(Value: Boolean);
begin
  EntSys.NotImplException ('TAbsCurrencyTriangulation.tcFloat');
end;

//-------------------------------------------------------------------------


end.
