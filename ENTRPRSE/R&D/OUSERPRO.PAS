unit OUserPro;

interface

Uses Classes, Dialogs, SysUtils, Windows, CustAbsU, CustTypU, GlobVar,
     VarConst, VarRec2U;

Type
  { NOTE: Must be kept in sync with CustAbsU.Pas }
  TUserProfile = Class(TAbsUserProfile5)   //PR: 18/08/2011 Changed for UserProfile2.  ABSEXCH-7994; PR: 12/07/2012 UserProfile3 ABSEXCH-12452
  Private
    RecAccess  : TRecAccessStatus;
    PropAccess : Array [1..22] Of TPropertyAccess;
    RecChanged : Boolean;

    EntSys     : TEnterpriseSystem;

    DataRec, OrigRec  : ^tPassDefType;
  Protected
    { Abstract Property Access methods from TAbsCostCentre }
    Function  GetRecStatus : TRecAccessStatus; Override;
    Function  GetRecChanged : Boolean; Override;

    Function GetUserId : cuStr10; Override;
    Procedure SetUserId (Value : cuStr10); Override;
    Function GetName : cuStr50; Override;
    Procedure SetName (Value : cuStr50); Override;
    Function GetEmail : cuStr100; Override;
    Procedure SetEmail (Value : cuStr100); Override;
    Function GetLockOutMins : SmallInt; Override;
    Procedure SetLockOutMins (Value : SmallInt); Override;
    Function GetDefSRICust : cuStr6; Override;
    Procedure SetDefSRICust (Value : cuStr6); Override;
    Function GetDefPPISupp : cuStr6; Override;
    Procedure SetDefPPISupp (Value : cuStr6); Override;
    Function GetDefCostCentre : cuStr3; Override;
    Procedure SetDefCostCentre (Value : cuStr3); Override;
    Function GetDefDepartment : cuStr3; Override;
    Procedure SetDefDepartment (Value : cuStr3); Override;
    Function GetDefCCDeptRule : SmallInt; Override;
    Procedure SetDefCCDeptRule (Value : SmallInt); Override;

    Function GetDefLocation : cuStr3; Override;
    Procedure SetDefLocation (Value : cuStr3); Override;
    Function GetDefLocRule : SmallInt; Override;
    Procedure SetDefLocRule (Value : SmallInt); Override;
    Function GetDefSalesBankGL : LongInt; Override;
    Procedure SetDefSalesBankGL (Value : LongInt); Override;
    Function GetDefPurchBankGL : LongInt; Override;
    Procedure SetDefPurchBankGL (Value : LongInt); Override;
    Function GetMaxSalesAuth : Double; Override;
    Procedure SetMaxSalesAuth (Value : Double); Override;
    Function GetMaxPurchAuth : Double; Override;
    Procedure SetMaxPurchAuth (Value : Double); Override;
    Function GetReportPrinter : cuStr50; Override;
    Procedure SetReportPrinter (Value : cuStr50); Override;
    Function GetFormPrinter : cuStr50; Override;
    Procedure SetFormPrinter (Value : cuStr50); Override;
    Function GetPwordExpiryMode : Byte; Override;
    Procedure SetPwordExpiryMode (Value : Byte); Override;
    Function GetPwordExpiryDays : SmallInt; Override;
    Procedure SetPwordExpiryDays (Value : SmallInt); Override;
    Function GetPwordExpiryDate : cuLongDate; Override;
    Procedure SetPwordExpiryDate (Value : cuLongDate); Override;
    Function  GetSecurityFlags(Index : SmallInt) : Byte; Override;
    Procedure SetSecurityFlags(Index : SmallInt; Value : Byte); Override;

    //PR: 18/08/2011 ABSEXCH-7994
    Function GetShowGLCodesInTree : Boolean; Override;
    Procedure SetShowGLCodesInTree (Value : Boolean); Override;

    //PR: 12/07/2012  ABSEXCH-12452
    function GetShowProductTypesInTree : Boolean; override;
    procedure SetShowProductTypesInTree (Value : Boolean); override;
    function GetShowStockCodesInTree : Boolean; override;
    procedure SetShowStockCodesInTree (Value : Boolean); override;

    // MH 06/09/2017 2017-R2 ABSEXCH-18855: Added new User Profile fields into Customisation
    Function GetWindowsUserID : cuStr100; override;
    Procedure SetWindowsUserID (Value : cuStr100); override;

    //RB 22/11/2017 2018-R1 ABSEXCH-19403: GDPR (POST User Profile Mods) - 8.3.1.1.2 - DLL + COM Customisation Support
    function GetHighlightPIIFields: Boolean; override;
    procedure SetHighlightPIIFields(aValue: Boolean); override;
    function GetHighlightPIIColour: Integer; override;
    procedure SetHighlightPIIColour(aValue: Integer); override;
  Public
    Constructor Create (hEntSys : TEnterpriseSystem);
    Destructor  Destroy; Override;

    Procedure   Assign (Const WinId, HandlerId : LongInt);
  End; { TUserProfile }


implementation

Uses EtStrU, BtKeys1U, CustWinU;

Const
  UserProfErrStr = 'User Profile ';

Constructor TUserProfile.Create (hEntSys : TEnterpriseSystem);
Begin
  Inherited Create;

  EntSys := hEntSys;

  New (DataRec);
  FillChar (DataRec^, SizeOf (DataRec^), #0);
  New (OrigRec);
  FillChar (OrigRec^, SizeOf (OrigRec^), #0);

  RecAccess  := NotAvailable;
  RecChanged := False;
End;

Destructor TUserProfile.Destroy;
Begin
  Dispose (DataRec);
  Dispose (OrigRec);

  Inherited Destroy;
End;

{-------------------------------------------------------------------------------------------------}

Procedure TUserProfile.Assign (Const WinId, HandlerId : LongInt);
Var
  I : SmallInt;
Begin
  { Set Security Access to Record - User Profile available globally for reference }
  RecAccess := ReadOnly;

  { Copy fields in from global variable }
  RecChanged := False;
  DataRec^ := UserProfile^;
  OrigRec^ := DataRec^;

  { Adjust Security Access for field by Window and Event }
  If (RecAccess <> NotAvailable) Then Begin
    { Set Default Security options }
    For I := Low(PropAccess) To High(PropAccess) Do
      If (RecAccess = ReadOnly) Then
        PropAccess[I] := paReadOnly
      Else
        PropAccess[I] := paReadWrite;

    { Modify default for specific cases }
    (*
    Case ((WinId * 1000) + HandlerId) Of
      ???
    End; { Case }
    *)
  End; { If }
End;

{-------------------------------------------------------------------------------------------------}

Function TUserProfile.GetRecStatus : TRecAccessStatus;
Begin
  Result := RecAccess;
End;

Function TUserProfile.GetRecChanged : Boolean;
Begin
  Result := RecChanged;
End;

{-------------------------------------------------------------------------------------------------}

(*
Function TUserProfile.GetCode : cuStr3;
Begin
  If (RecAccess <> NotAvailable) Then
    Result := DataRec.PCostC
  Else Begin
    Result := '';
    EntSys.DataAccessErrDlg(True, CCCodeStr + 'Code');
  End; { Else }
End;

Procedure TUserProfile.SetCode (Value : cuStr3);
Var
  TmpStr : ShortString;
Begin
  If (RecAccess <> NotAvailable) And (PropAccess[1] = paReadWrite) Then Begin
    TmpStr := LJVar(UpperCase(Value), CCKeyLen);
    If (DataRec.PCostC <> TmpStr) Then Begin
      { Validate }
      If (Trim(TmpStr) <> '') And
         ((TmpStr = OrigRec^.PCostC) Or (Not EntSys.CheckForRec(FullCCKey(CostCCode,CSubCode[IsCC],TmpStr),PWrdF,PWK))) Then Begin
        DataRec.PCostC := TmpStr;
        RecChanged := True;
      End { If }
      Else
        EntSys.CustomException (CCCodeStr + 'Code');
    End; { If }
  End { If }
  Else
    EntSys.DataAccessErrDlg(False, CCCodeStr + 'Code');
End;
*)

//-----------------------------------------------------------------------------

function TUserProfile.GetUserId: cuStr10;
begin
  If (RecAccess <> NotAvailable) Then
  // HM 12/01/05: Changed to take User Id from EntryRec as DataRec will be
  // blank if the Enhanced Security Record doesn't exist.
  //Result := Trim(DataRec^.Login)

    Result := Trim(EntryRec^.Login)
  Else
  Begin
    Result := '';
    EntSys.DataAccessErrDlg(True, UserProfErrStr + 'User Id');
  End; { Else }
end;

procedure TUserProfile.SetUserId(Value: cuStr10);
begin
  EntSys.DataAccessErrDlg(False, UserProfErrStr + 'User Id');
end;

//---------------------------------------------------

function TUserProfile.GetName: cuStr50;
begin
  If (RecAccess <> NotAvailable) Then
    Result := Trim(DataRec^.UserName)
  Else Begin
    Result := '';
    EntSys.DataAccessErrDlg(True, UserProfErrStr + 'Name');
  End; { Else }
end;

procedure TUserProfile.SetName(Value: cuStr50);
begin
  EntSys.DataAccessErrDlg(False, UserProfErrStr + 'Name');
end;

//---------------------------------------------------

function TUserProfile.GetEmail: cuStr100;
begin
  If (RecAccess <> NotAvailable) Then
    Result := Trim(DataRec^.EmailAddr)
  Else Begin
    Result := '';
    EntSys.DataAccessErrDlg(True, UserProfErrStr + 'Email Address');
  End; { Else }
end;

procedure TUserProfile.SetEmail(Value: cuStr100);
begin
  EntSys.DataAccessErrDlg(False, UserProfErrStr + 'Email Address');
end;

//---------------------------------------------------

function TUserProfile.GetLockOutMins: SmallInt;
begin
  If (RecAccess <> NotAvailable) Then
    Result := DataRec^.PWTimeOut
  Else Begin
    Result := 0;
    EntSys.DataAccessErrDlg(True, UserProfErrStr + 'Lock Out Minutes');
  End; { Else }
end;

procedure TUserProfile.SetLockOutMins(Value: SmallInt);
begin
  EntSys.DataAccessErrDlg(False, UserProfErrStr + 'Lock Out Minutes');
end;

//---------------------------------------------------

function TUserProfile.GetDefSRICust: cuStr6;
begin
  If (RecAccess <> NotAvailable) Then
    Result := DataRec^.DirCust
  Else Begin
    Result := '';
    EntSys.DataAccessErrDlg(True, UserProfErrStr + 'Default SRI Customer');
  End; { Else }
end;

procedure TUserProfile.SetDefSRICust(Value: cuStr6);
begin
  EntSys.DataAccessErrDlg(False, UserProfErrStr + 'Default SRI Customer');
end;

//---------------------------------------------------

function TUserProfile.GetDefPPISupp: cuStr6;
begin
  If (RecAccess <> NotAvailable) Then
    Result := DataRec^.DirSupp
  Else Begin
    Result := '';
    EntSys.DataAccessErrDlg(True, UserProfErrStr + 'Default PPI Supplier');
  End; { Else }
end;

procedure TUserProfile.SetDefPPISupp(Value: cuStr6);
begin
  EntSys.DataAccessErrDlg(False, UserProfErrStr + 'Default PPI Supplier');
end;

//---------------------------------------------------

function TUserProfile.GetDefCostCentre: cuStr3;
begin
  If (RecAccess <> NotAvailable) Then
    Result := DataRec^.CCDep[BOn]
  Else Begin
    Result := '';
    EntSys.DataAccessErrDlg(True, UserProfErrStr + 'Default Cost Centre');
  End; { Else }
end;

procedure TUserProfile.SetDefCostCentre(Value: cuStr3);
begin
  EntSys.DataAccessErrDlg(False, UserProfErrStr + 'Default Cost Centre');
end;

//---------------------------------------------------

function TUserProfile.GetDefDepartment: cuStr3;
begin
  If (RecAccess <> NotAvailable) Then
    Result := DataRec^.CCDep[BOff]
  Else Begin
    Result := '';
    EntSys.DataAccessErrDlg(True, UserProfErrStr + 'Default Department');
  End; { Else }
end;

procedure TUserProfile.SetDefDepartment(Value: cuStr3);
begin
  EntSys.DataAccessErrDlg(False, UserProfErrStr + 'Default Department');
end;

//---------------------------------------------------

function TUserProfile.GetDefCCDeptRule: SmallInt;
begin
  If (RecAccess <> NotAvailable) Then
    Result := DataRec^.CCDepRule
  Else Begin
    Result := 0;
    EntSys.DataAccessErrDlg(True, UserProfErrStr + 'Default CC/Dept Rule');
  End; { Else }
end;

procedure TUserProfile.SetDefCCDeptRule(Value: SmallInt);
begin
  EntSys.DataAccessErrDlg(False, UserProfErrStr + 'Default CC/Dept Rule');
end;

//---------------------------------------------------

function TUserProfile.GetDefLocation: cuStr3;
begin
  If (RecAccess <> NotAvailable) Then
    Result := DataRec^.Loc
  Else Begin
    Result := '';
    EntSys.DataAccessErrDlg(True, UserProfErrStr + 'Default Location');
  End; { Else }
end;

procedure TUserProfile.SetDefLocation(Value: cuStr3);
begin
  EntSys.DataAccessErrDlg(False, UserProfErrStr + 'Default Location');
end;

//---------------------------------------------------

function TUserProfile.GetDefLocRule: SmallInt;
begin
  If (RecAccess <> NotAvailable) Then
    Result := DataRec^.LocRule
  Else Begin
    Result := 0;
    EntSys.DataAccessErrDlg(True, UserProfErrStr + 'Default Location Rule');
  End; { Else }
end;

procedure TUserProfile.SetDefLocRule(Value: SmallInt);
begin
  EntSys.DataAccessErrDlg(False, UserProfErrStr + 'Default Location Rule');
end;

//---------------------------------------------------

function TUserProfile.GetDefSalesBankGL: LongInt;
begin
  If (RecAccess <> NotAvailable) Then
    Result := DataRec^.SalesBank
  Else Begin
    Result := 0;
    EntSys.DataAccessErrDlg(True, UserProfErrStr + 'Default Sales Bank GL');
  End; { Else }
end;

procedure TUserProfile.SetDefSalesBankGL(Value: Integer);
begin
  EntSys.DataAccessErrDlg(False, UserProfErrStr + 'Default Sales Bank GL');
end;

//---------------------------------------------------

function TUserProfile.GetDefPurchBankGL: LongInt;
begin
  If (RecAccess <> NotAvailable) Then
    Result := DataRec^.PurchBank
  Else Begin
    Result := 0;
    EntSys.DataAccessErrDlg(True, UserProfErrStr + 'Default Purchase Bank GL');
  End; { Else }
end;

procedure TUserProfile.SetDefPurchBankGL(Value: Integer);
begin
  EntSys.DataAccessErrDlg(False, UserProfErrStr + 'Default Purchase Bank GL');
end;

//---------------------------------------------------

function TUserProfile.GetMaxSalesAuth: Double;
begin
  If (RecAccess <> NotAvailable) Then
    Result := DataRec^.MaxSalesA
  Else Begin
    Result := 0.0;
    EntSys.DataAccessErrDlg(True, UserProfErrStr + 'Max Sales Authorisation');
  End; { Else }
end;

procedure TUserProfile.SetMaxSalesAuth(Value: Double);
begin
  EntSys.DataAccessErrDlg(False, UserProfErrStr + 'Max Sales Authorisation');
end;

//---------------------------------------------------

function TUserProfile.GetMaxPurchAuth: Double;
begin
  If (RecAccess <> NotAvailable) Then
    Result := DataRec^.MaxPurchA
  Else Begin
    Result := 0.0;
    EntSys.DataAccessErrDlg(True, UserProfErrStr + 'Max Purchase Authorisation');
  End; { Else }
end;

procedure TUserProfile.SetMaxPurchAuth(Value: Double);
begin
  EntSys.DataAccessErrDlg(False, UserProfErrStr + 'Max Purchase Authorisation');
end;

//---------------------------------------------------

function TUserProfile.GetReportPrinter: cuStr50;
begin
  If (RecAccess <> NotAvailable) Then
    Result := DataRec^.ReportPrn
  Else Begin
    Result := '';
    EntSys.DataAccessErrDlg(True, UserProfErrStr + 'Report Printer');
  End; { Else }
end;

procedure TUserProfile.SetReportPrinter(Value: cuStr50);
begin
  EntSys.DataAccessErrDlg(False, UserProfErrStr + 'Report Printer');
end;

//---------------------------------------------------

function TUserProfile.GetFormPrinter: cuStr50;
begin
  If (RecAccess <> NotAvailable) Then
    Result := DataRec^.FormPrn
  Else Begin
    Result := '';
    EntSys.DataAccessErrDlg(True, UserProfErrStr + 'Form Printer');
  End; { Else }
end;

procedure TUserProfile.SetFormPrinter(Value: cuStr50);
begin
  EntSys.DataAccessErrDlg(False, UserProfErrStr + 'Form Printer');
end;

//---------------------------------------------------

function TUserProfile.GetPwordExpiryMode: Byte;
begin
  If (RecAccess <> NotAvailable) Then
    Result := DataRec^.PWExpMode
  Else Begin
    Result := 0;
    EntSys.DataAccessErrDlg(True, UserProfErrStr + 'Password Expiry Mode');
  End; { Else }
end;

procedure TUserProfile.SetPwordExpiryMode(Value: Byte);
begin
  EntSys.DataAccessErrDlg(False, UserProfErrStr + 'Password Expiry Mode');
end;

//---------------------------------------------------

function TUserProfile.GetPwordExpiryDays: SmallInt;
begin
  If (RecAccess <> NotAvailable) Then
    Result := DataRec^.PWExPDays
  Else Begin
    Result := 0;
    EntSys.DataAccessErrDlg(True, UserProfErrStr + 'Password Expiry Days');
  End; { Else }
end;

procedure TUserProfile.SetPwordExpiryDays(Value: SmallInt);
begin
  EntSys.DataAccessErrDlg(False, UserProfErrStr + 'Password Expiry Days');
end;

//---------------------------------------------------

function TUserProfile.GetPwordExpiryDate: cuLongDate;
begin
  If (RecAccess <> NotAvailable) Then
    Result := DataRec^.PWExpDate
  Else Begin
    Result := '';
    EntSys.DataAccessErrDlg(True, UserProfErrStr + 'Password Expiry Date');
  End; { Else }
end;

procedure TUserProfile.SetPwordExpiryDate(Value: cuLongDate);
begin
  EntSys.DataAccessErrDlg(False, UserProfErrStr + 'Password Expiry Date');
end;

//---------------------------------------------------

function TUserProfile.GetSecurityFlags(Index: SmallInt) : Byte;
begin
  Result := 0;
  If (RecAccess <> NotAvailable) Then Begin
    With EntryRec^ Do
      If (Index >= Low(Access)) And (Index <= High(Access)) Then
        Result := Access[Index]
      Else
        EntSys.CustomException ('Security Flag Index');
  End { If (RecAccess ... }
  Else Begin
    Result := 0;
    EntSys.DataAccessErrDlg(True, UserProfErrStr + 'Security Flags');
  End; { Else }
end;

procedure TUserProfile.SetSecurityFlags(Index: SmallInt; Value: Byte);
begin
  EntSys.DataAccessErrDlg(False, UserProfErrStr + 'Security Flags');
end;

//---------------------------------------------------

//PR: 18/08/2011 ABSEXCH-7994
function TUserProfile.GetShowGLCodesInTree: Boolean;
begin
  If (RecAccess <> NotAvailable) Then
    Result := DataRec^.ShowGLCodes
  Else Begin
    Result := False;
    EntSys.DataAccessErrDlg(True, UserProfErrStr + 'Show GL Codes In Tree');
  End; { Else }
end;

procedure TUserProfile.SetShowGLCodesInTree(Value: Boolean);
begin
  EntSys.DataAccessErrDlg(False, UserProfErrStr + 'Show GL Codes In Tree');
end;

function TUserProfile.GetShowProductTypesInTree: Boolean;
begin
  If (RecAccess <> NotAvailable) Then
    Result := DataRec^.ShowProductType
  Else Begin
    Result := False;
    EntSys.DataAccessErrDlg(True, UserProfErrStr + 'Show Product Types In Tree');
  End; { Else }
end;

function TUserProfile.GetShowStockCodesInTree: Boolean;
begin
  If (RecAccess <> NotAvailable) Then
    Result := DataRec^.ShowStockCode
  Else Begin
    Result := False;
    EntSys.DataAccessErrDlg(True, UserProfErrStr + 'Show Stock Codes In Tree');
  End; { Else }
end;

procedure TUserProfile.SetShowProductTypesInTree(Value: Boolean);
begin
  EntSys.DataAccessErrDlg(False, UserProfErrStr + 'Show Product Types In Tree');
end;

procedure TUserProfile.SetShowStockCodesInTree(Value: Boolean);
begin
  EntSys.DataAccessErrDlg(False, UserProfErrStr + 'Show Stock Codes Codes In Tree');
end;

//-------------------------------------------------------------------------

// MH 06/09/2017 2017-R2 ABSEXCH-18855: Added new User Profile fields into Customisation
Function TUserProfile.GetWindowsUserID : cuStr100;
Begin // GetWindowsUserID
  If (RecAccess <> NotAvailable) Then
    Result := DataRec^.WindowUserId
  Else Begin
    Result := '';
    EntSys.DataAccessErrDlg(True, UserProfErrStr + 'Windows User ID');
  End; { Else }
End; // GetWindowsUserID
Procedure TUserProfile.SetWindowsUserID (Value : cuStr100);
Begin // SetWindowsUserID
  EntSys.DataAccessErrDlg(False, UserProfErrStr + 'Windows User ID');
End; // SetWindowsUserID

//-------------------------------------------------------------------------
//RB 22/11/2017 2018-R1 ABSEXCH-19403: GDPR (POST User Profile Mods) - 8.3.1.1.2 - DLL + COM Customisation Support
function TUserProfile.GetHighlightPIIColour: Integer;
begin
  If (RecAccess <> NotAvailable) Then
    Result := DataRec^.HighlightPIIColour
  Else Begin
    Result := 0;
    EntSys.DataAccessErrDlg(True, UserProfErrStr + 'HighlightPIIColour');
  End; { Else }
end;
procedure TUserProfile.SetHighlightPIIColour(aValue: Integer);
begin
  EntSys.DataAccessErrDlg(False, UserProfErrStr + 'HighlightPIIColour');
end;

//-------------------------------------------------------------------------

function TUserProfile.GetHighlightPIIFields: Boolean;
begin
  If (RecAccess <> NotAvailable) Then
    Result := DataRec^.HighlightPIIFields
  Else Begin
    Result := false;
    EntSys.DataAccessErrDlg(True, UserProfErrStr + 'HighlightPIIFields');
  End; { Else }
end;
procedure TUserProfile.SetHighlightPIIFields(aValue: Boolean);
begin
  EntSys.DataAccessErrDlg(True, UserProfErrStr + 'HighlightPIIFields');
end;

//-------------------------------------------------------------------------

end.

