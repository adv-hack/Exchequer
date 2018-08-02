unit oEmploye;

interface

Uses Classes, Dialogs, Forms, SysUtils, Windows, CustAbsU, GlobVar, VarConst,
     CustTypU;

Type
  { NOTE: Must be kept in sync with CustAbsU.Pas }
  // MH 20/03/13 v7.0.2 ABSEXCH-14162: Extended Employee class for HF Group with TAbsEmployee4
  TEmployee = Class(TAbsEmployee5)
  Private
    RecAccess  : TRecAccessStatus;
    PropAccess : Array [1..33] Of TPropertyAccess;
    FuncAccess : Array [1..1] Of TFunctionAccess;
    RecChanged : Boolean;

    EntSys     : TEnterpriseSystem;

    DataRec, OrigRec : EmplType;
  Protected
    Function  GetRecStatus : TRecAccessStatus; Override;
    Function  GetRecChanged : Boolean; Override;

    Function  GetCode : cuStr6; Override;
    Procedure SetCode(Value : cuStr6); Override;
    Function  GetSupplier : cuStr6; Override;
    Procedure SetSupplier(Value : cuStr6); Override;
    Function  GetName : cuStr30; Override;
    Procedure SetName(Value : cuStr30); Override;
    Function  GetAddress(Index : cuAddrIndex) : cuStr30; Override;
    Procedure SetAddress(Index : cuAddrIndex; Value : cuStr30); Override;
    Function  GetPhone : cuStr20; Override;
    Procedure SetPhone(Value : cuStr20); Override;
    Function  GetFax : cuStr20; Override;
    Procedure SetFax(Value : cuStr20); Override;
    Function  GetMobile : cuStr20; Override;
    Procedure SetMobile(Value : cuStr20); Override;
    Function  GetType : Byte; Override;
    Procedure SetType(Value : Byte); Override;
    Function  GetPayrollNumber : cuStr10; Override;
    Procedure SetPayrollNumber(Value : cuStr10); Override;
    Function  GetCertificateNumber : cuStr30; Override;
    Procedure SetCertificateNumber(Value : cuStr30); Override;
    Function  GetCertificateExpiry : cuLongDate; Override;
    Procedure SetCertificateExpiry(Value : cuLongDate); Override;
    Function  GetUserField (Index: Integer) : cuStr20; Override;
    Procedure SetUserField(Index: Integer; Value : cuStr20); Override;
    Function  GetCostCentre : cuStr3; Override;
    Procedure SetCostCentre(Value : cuStr3); Override;
    Function  GetDepartment : cuStr3; Override;
    Procedure SetDepartment(Value : cuStr3); Override;
    Function  GetOwnTimeRatesOnly : Boolean; Override;
    Procedure SetOwnTimeRatesOnly(Value : Boolean); Override;
    Function  GetSelfBilling : Boolean; Override;
    Procedure SetSelfBilling(Value : Boolean); Override;
    Function  GetGroupCertificate : Boolean; Override;
    Procedure SetGroupCertificate(Value : Boolean); Override;
    Function  GetCertificateType : Byte; Override;
    Procedure SetCertificateType(Value : Byte); Override;
    Function  GetNationalInsuranceNo : cuStr10; Override;
    Procedure SetNationalInsuranceNo(Value : cuStr10); Override;

    // HM 04/06/03: Added TAbsEmployee2
    Function GetLabourViaPL : WordBool; Override;
    Procedure SetLabourViaPL(Value : WordBool); Override;

    // MH 02/02/2010 (v6.3): Added TAbsEmployee3
    Function GetEmailAddr : cuStr100; Override;
    Procedure SetEmailAddr(Value : cuStr100); Override;

    // MH 20/03/13 v7.0.2 ABSEXCH-14162: Extended Employee class for HF Group with TAbsEmployee4
    Function GetContractorType : Byte; Override;
    Procedure SetContractorType(Value : Byte); Override;
    Function GetTagged : Byte; Override;
    Procedure SetTagged(Value : Byte); Override;
    Function GetTimeRateRules : Byte; Override;
    Procedure SetTimeRateRules(Value : Byte); Override;
    Function GetUTRCode : cuStr10; Override;
    Procedure SetUTRCode(Value : cuStr10); Override;
    Function GetVerificationNo : cuStr13; Override;
    Procedure SetVerificationNo(Value : cuStr13); Override;

    //RB 22/11/2017 2018-R1 ABSEXCH-19396: GDPR (POST 19352) - 8.3.1.1.1 - DLL + COM Customisation Support
    function GetStatus: TEmpStatus; override;
    procedure SetStatus(Value: TEmpStatus); override;
    function GetAnonymisationStatus: TCustomerAnonymisationStatus; override;
    procedure SetAnonymisationStatus(Value: TCustomerAnonymisationStatus);
      override;
    function GetAnonymisedDate: cuStr8; override;
    procedure SetAnonymisedDate(Value: cuStr8); override;
    function GetAnonymisedTime: cuStr6; override;
    procedure SetAnonymisedTime(Value: cuStr6); override;
  Public
    Constructor Create (hEntSys : TEnterpriseSystem);
    Destructor  Destroy; Override;

    Procedure   Assign (Const WinId, HandlerId : LongInt;
                        Const EmplRec          : JobMiscRec);
  End; { TEmployee }

implementation

Uses CustWinU, EtStrU, BtKeys1U, BtrvU2;

Const
  EmplRecErrStr = 'Employee ';

  //RB 22/11/2017 2018-R1 ABSEXCH-19396: GDPR (POST 19352) - 8.3.1.1.1 - DLL + COM Customisation Support
  idxEmpStatus = 30;
  idxAnonymisationStatus = 31;
  idxAnonymisedDate = 32;
  idxAnonymisedTime = 33;

//=========================================================================

Constructor TEmployee.Create (hEntSys : TEnterpriseSystem);
Begin
  Inherited Create;

  EntSys := hEntSys;

  FillChar (DataRec, SizeOf (DataRec), #0);
  FillChar (OrigRec, SizeOf (OrigRec), #0);
End;

//------------------------------

Destructor TEmployee.Destroy;
Begin { Destroy }
  EntSys := NIL;

  Inherited Destroy;
End; { Destroy }

//-------------------------------------------------------------------------

Procedure TEmployee.Assign (Const WinId, HandlerId : LongInt;
                            Const EmplRec          : JobMiscRec);
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
    If (EmplRec.RecPfix = JARCode) And (EmplRec.SubType = JAECode) Then
      DataRec := EmplRec.EmplRec
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
    Case ((WinId * 1000) + HandlerId) Of
      // Enable Writeable fields here for each hook point
      //RB 22/11/2017 2018-R1 ABSEXCH-19396: GDPR (POST 19352) - 8.3.1.1.1 - DLL + COM Customisation Support
      105000052
        : Begin
            PropAccess[idxEmpStatus] := paReadOnly;
          end;
    End; { Case ((WinId * 1000) + HandlerId) }
  End; { If }

End; { Assign }

//-------------------------------------------------------------------------

Function TEmployee.GetRecStatus : TRecAccessStatus;
Begin
  Result := RecAccess;
End;

//-------------------------------------------------------------------------

Function TEmployee.GetRecChanged : Boolean;
Begin
  Result := RecChanged;
End;

//-------------------------------------------------------------------------

function TEmployee.GetCode: cuStr6;
begin
  If (RecAccess <> NotAvailable) Then
    Result := DataRec.EmpCode
  Else Begin
    Result := '';
    EntSys.DataAccessErrDlg(True, EmplRecErrStr + 'Code');
  End; { Else }
end;

procedure TEmployee.SetCode(Value: cuStr6);
begin
  If (RecAccess <> NotAvailable) And (PropAccess[1] = paReadWrite) Then Begin
    If (DataRec.EmpCode <> Value) Then Begin
      DataRec.EmpCode := Value;
      RecChanged := True;
    End; { If }
  End { If }
  Else
    EntSys.DataAccessErrDlg(False, EmplRecErrStr + 'Code');
end;

//------------------------------

function TEmployee.GetSupplier: cuStr6;
begin
  If (RecAccess <> NotAvailable) Then
    Result := DataRec.Supplier
  Else Begin
    Result := '';
    EntSys.DataAccessErrDlg(True, EmplRecErrStr + 'Supplier');
  End; { Else }
end;

procedure TEmployee.SetSupplier(Value: cuStr6);
begin
  If (RecAccess <> NotAvailable) And (PropAccess[2] = paReadWrite) Then Begin
    If (DataRec.Supplier <> Value) Then Begin
      DataRec.Supplier := Value;
      RecChanged := True;
    End; { If }
  End { If }
  Else
    EntSys.DataAccessErrDlg(False, EmplRecErrStr + 'Supplier');
end;

//------------------------------

function TEmployee.GetName: cuStr30;
begin
  If (RecAccess <> NotAvailable) Then
    Result := DataRec.EmpName
  Else Begin
    Result := '';
    EntSys.DataAccessErrDlg(True, EmplRecErrStr + 'Name');
  End; { Else }
end;

procedure TEmployee.SetName(Value: cuStr30);
begin
  If (RecAccess <> NotAvailable) And (PropAccess[3] = paReadWrite) Then Begin
    If (DataRec.EmpName <> Value) Then Begin
      DataRec.EmpName := Value;
      RecChanged := True;
    End; { If }
  End { If }
  Else
    EntSys.DataAccessErrDlg(False, EmplRecErrStr + 'Name');
end;

//------------------------------

function TEmployee.GetAddress(Index: cuAddrIndex): cuStr30;
begin
  If (RecAccess <> NotAvailable) Then
    Result := DataRec.Addr[Index]
  Else Begin
    Result := '';
    EntSys.DataAccessErrDlg(True, EmplRecErrStr + 'Address');
  End; { Else }
end;

procedure TEmployee.SetAddress(Index: cuAddrIndex; Value: cuStr30);
begin
  If (RecAccess <> NotAvailable) And (PropAccess[4] = paReadWrite) Then Begin
    If (DataRec.Addr[Index] <> Value) Then Begin
      DataRec.Addr[Index] := Value;
      RecChanged := True;
    End; { If }
  End { If }
  Else
    EntSys.DataAccessErrDlg(False, EmplRecErrStr + 'Address');
end;

//------------------------------

function TEmployee.GetPhone: cuStr20;
begin
  If (RecAccess <> NotAvailable) Then
    Result := DataRec.Phone
  Else Begin
    Result := '';
    EntSys.DataAccessErrDlg(True, EmplRecErrStr + 'Phone');
  End; { Else }
end;

procedure TEmployee.SetPhone(Value: cuStr20);
begin
  If (RecAccess <> NotAvailable) And (PropAccess[5] = paReadWrite) Then Begin
    If (DataRec.Phone <> Value) Then Begin
      DataRec.Phone := Value;
      RecChanged := True;
    End; { If }
  End { If }
  Else
    EntSys.DataAccessErrDlg(False, EmplRecErrStr + 'Phone');
end;

//------------------------------

function TEmployee.GetFax: cuStr20;
begin
  If (RecAccess <> NotAvailable) Then
    Result := DataRec.Fax
  Else Begin
    Result := '';
    EntSys.DataAccessErrDlg(True, EmplRecErrStr + 'Fax');
  End; { Else }
end;

procedure TEmployee.SetFax(Value: cuStr20);
begin
  If (RecAccess <> NotAvailable) And (PropAccess[6] = paReadWrite) Then Begin
    If (DataRec.Fax <> Value) Then Begin
      DataRec.Fax := Value;
      RecChanged := True;
    End; { If }
  End { If }
  Else
    EntSys.DataAccessErrDlg(False, EmplRecErrStr + 'Fax');
end;

//------------------------------

function TEmployee.GetMobile: cuStr20;
begin
  If (RecAccess <> NotAvailable) Then
    Result := DataRec.Phone2
  Else Begin
    Result := '';
    EntSys.DataAccessErrDlg(True, EmplRecErrStr + 'Mobile');
  End; { Else }
end;

procedure TEmployee.SetMobile(Value: cuStr20);
begin
  If (RecAccess <> NotAvailable) And (PropAccess[7] = paReadWrite) Then Begin
    If (DataRec.Phone2 <> Value) Then Begin
      DataRec.Phone2 := Value;
      RecChanged := True;
    End; { If }
  End { If }
  Else
    EntSys.DataAccessErrDlg(False, EmplRecErrStr + 'Mobile');
end;

//------------------------------

function TEmployee.GetType: Byte;
begin
  If (RecAccess <> NotAvailable) Then
    Result := DataRec.EType
  Else Begin
    Result := 0;
    EntSys.DataAccessErrDlg(True, EmplRecErrStr + 'Type');
  End; { Else }
end;

procedure TEmployee.SetType(Value: Byte);
begin
  If (RecAccess <> NotAvailable) And (PropAccess[8] = paReadWrite) Then Begin
    If (Value In [1..3]) Then Begin
      DataRec.EType := Value;
      RecChanged := True;
    End { If }
    Else
      EntSys.CustomException (EmplRecErrStr + 'Type');
  End { If }
  Else
    EntSys.DataAccessErrDlg(False, EmplRecErrStr + 'Type');
end;

//------------------------------

function TEmployee.GetPayrollNumber: cuStr10;
begin
  If (RecAccess <> NotAvailable) Then
    Result := DataRec.PayNo
  Else Begin
    Result := '';
    EntSys.DataAccessErrDlg(True, EmplRecErrStr + 'PayrollNumber');
  End; { Else }
end;

procedure TEmployee.SetPayrollNumber(Value: cuStr10);
begin
  If (RecAccess <> NotAvailable) And (PropAccess[9] = paReadWrite) Then Begin
    If (DataRec.PayNo <> Value) Then Begin
      DataRec.PayNo := Value;
      RecChanged := True;
    End; { If }
  End { If }
  Else
    EntSys.DataAccessErrDlg(False, EmplRecErrStr + 'PayrollNumber');
end;

//------------------------------

function TEmployee.GetCertificateNumber: cuStr30;
begin
  If (RecAccess <> NotAvailable) Then
    Result := DataRec.CertNo
  Else Begin
    Result := '';
    EntSys.DataAccessErrDlg(True, EmplRecErrStr + 'CertificateNumber');
  End; { Else }
end;

procedure TEmployee.SetCertificateNumber(Value: cuStr30);
begin
  If (RecAccess <> NotAvailable) And (PropAccess[10] = paReadWrite) Then Begin
    If (DataRec.CertNo <> Value) Then Begin
      DataRec.CertNo := Value;
      RecChanged := True;
    End; { If }
  End { If }
  Else
    EntSys.DataAccessErrDlg(False, EmplRecErrStr + 'CertificateNumber');
end;

//------------------------------

function TEmployee.GetCertificateExpiry: cuLongDate;
begin
  If (RecAccess <> NotAvailable) Then
    Result := DataRec.CertExpiry
  Else Begin
    Result := '';
    EntSys.DataAccessErrDlg(True, EmplRecErrStr + 'CertificateExpiry');
  End; { Else }
end;

procedure TEmployee.SetCertificateExpiry(Value: cuLongDate);
begin
  If (RecAccess <> NotAvailable) And (PropAccess[11] = paReadWrite) Then Begin
    If (DataRec.CertExpiry <> Value) Then Begin
      If EntSys.ValidDate(Value) Then Begin
        DataRec.CertExpiry := Value;
        RecChanged := True;
      End { If }
      Else
        EntSys.CustomException (EmplRecErrStr + 'CertificateExpiry');
    End; { If }
  End { If }
  Else
    EntSys.DataAccessErrDlg(False, EmplRecErrStr + 'CertificateExpiry');
end;

//------------------------------

function TEmployee.GetUserField(Index: Integer): cuStr20;
begin
  If (RecAccess <> NotAvailable) And ((Index >= 1) And (Index <= 4)) Then
    Case Index Of
      1 : Result := DataRec.UserDef1;
      2 : Result := DataRec.UserDef2;
      3 : Result := DataRec.UserDef3;
      4 : Result := DataRec.UserDef4;
    End { Case }
  Else Begin
    Result := '';
    EntSys.DataAccessErrDlg(True, EmplRecErrStr + 'UserField' + IntToStr(Index));
  End; { Else }
end;

procedure TEmployee.SetUserField(Index: Integer; Value: cuStr20);
begin
  If (RecAccess <> NotAvailable) And (PropAccess[11 + Index] = paReadWrite) Then Begin
    Case Index Of
      1 : DataRec.UserDef1 := Value;
      2 : DataRec.UserDef2 := Value;
      3 : DataRec.UserDef3 := Value;
      4 : DataRec.UserDef4 := Value;
    Else
      EntSys.CustomException (EmplRecErrStr + 'UserField' + IntToStr(Index));
    End; { Case }
    RecChanged := True;
  End { If }
  Else
    EntSys.DataAccessErrDlg(False, EmplRecErrStr + 'UserField' + IntToStr(Index));
end;

//------------------------------

function TEmployee.GetCostCentre: cuStr3;
begin
  If (RecAccess <> NotAvailable) Then
    Result := DataRec.CCDep[BOn]
  Else Begin
    Result := '';
    EntSys.DataAccessErrDlg(True, EmplRecErrStr + 'CostCentre');
  End; { Else }
end;

procedure TEmployee.SetCostCentre(Value: cuStr3);
var
  TmpStr : ShortString;
begin
  If (RecAccess <> NotAvailable) And (PropAccess[16] = paReadWrite) Then Begin
    TmpStr := LJVar(UpperCase(Value), CCKeyLen);
    If (DataRec.CCDep[True] <> TmpStr) Then Begin
      { Can be blank if not using CC/Dept, else must be set }
      If ((Not Syss.UseCCDep) And (Trim(TmpStr) = '')) Or
         EntSys.CheckForRec(FullCCKey(CostCCode,CSubCode[True],TmpStr),PWrdF,PWK) Then Begin
        DataRec.CCDep[BOn] := TmpStr;
        RecChanged := True;
      End { If }
      Else
        Entsys.CustomException (EmplRecErrStr + 'CostCentre');
    End; { If }
  End { If }
  Else
    EntSys.DataAccessErrDlg(False, EmplRecErrStr + 'CostCentre');
end;

//------------------------------

function TEmployee.GetDepartment: cuStr3;
var
  TmpStr : ShortString;
begin
  If (RecAccess <> NotAvailable) Then
    Result := DataRec.CCDep[BOff]
  Else Begin
    Result := '';
    EntSys.DataAccessErrDlg(True, EmplRecErrStr + 'Department');
  End; { Else }
end;

procedure TEmployee.SetDepartment(Value: cuStr3);
var
  TmpStr : ShortString;
begin
  If (RecAccess <> NotAvailable) And (PropAccess[17] = paReadWrite) Then Begin
    TmpStr := LJVar(UpperCase(Value), CCKeyLen);
    If (DataRec.CCDep[BOff] <> TmpStr) Then Begin
      { Can be blank if not using CC/Dept, else must be set }
      If ((Not Syss.UseCCDep) And (Trim(TmpStr) = '')) Or
         EntSys.CheckForRec(FullCCKey(CostCCode,CSubCode[BOff],TmpStr),PWrdF,PWK) Then Begin
        DataRec.CCDep[BOff] := TmpStr;
        RecChanged := True;
      End { If }
      Else
        Entsys.CustomException (EmplRecErrStr + 'Department');
    End; { If }
  End { If }
  Else
    EntSys.DataAccessErrDlg(False, EmplRecErrStr + 'Department');
end;

//------------------------------

function TEmployee.GetOwnTimeRatesOnly: Boolean;
begin
  If (RecAccess <> NotAvailable) Then
    Result := (DataRec.UseORate=1)
  Else Begin
    Result := False;
    EntSys.DataAccessErrDlg(True, EmplRecErrStr + 'OwnTimeRatesOnly');
  End; { Else }
end;

procedure TEmployee.SetOwnTimeRatesOnly(Value: Boolean);
begin
  If (RecAccess <> NotAvailable) And (PropAccess[18] = paReadWrite) Then Begin
    If (DataRec.UseORate <> Byte(Ord(Value))) Then Begin
      DataRec.UseORate := Byte(Ord(Value));
      RecChanged := True;
    End; { If }
  End { If }
  Else
    EntSys.DataAccessErrDlg(False, EmplRecErrStr + 'OwnTimeRatesOnly');
end;

//------------------------------

function TEmployee.GetSelfBilling: Boolean;
begin
  If (RecAccess <> NotAvailable) Then
    Result := DataRec.GSelfBill
  Else Begin
    Result := False;
    EntSys.DataAccessErrDlg(True, EmplRecErrStr + 'SelfBilling');
  End; { Else }
end;

procedure TEmployee.SetSelfBilling(Value: Boolean);
begin
  If (RecAccess <> NotAvailable) And (PropAccess[19] = paReadWrite) Then Begin
    If (DataRec.GSelfBill <> Value) Then Begin
      DataRec.GSelfBill := Value;
      RecChanged := True;
    End; { If }
  End { If }
  Else
    EntSys.DataAccessErrDlg(False, EmplRecErrStr + 'SelfBilling');
end;

//------------------------------

function TEmployee.GetGroupCertificate: Boolean;
begin
  If (RecAccess <> NotAvailable) Then
    Result := DataRec.GroupCert
  Else Begin
    Result := False;
    EntSys.DataAccessErrDlg(True, EmplRecErrStr + 'GroupCertificate');
  End; { Else }
end;

procedure TEmployee.SetGroupCertificate(Value: Boolean);
begin
  If (RecAccess <> NotAvailable) And (PropAccess[20] = paReadWrite) Then Begin
    If (DataRec.GroupCert <> Value) Then Begin
      DataRec.GroupCert := Value;
      RecChanged := True;
    End; { If }
  End { If }
  Else
    EntSys.DataAccessErrDlg(False, EmplRecErrStr + 'GroupCertificate');
end;

//------------------------------

function TEmployee.GetCertificateType: Byte;
begin
  If (RecAccess <> NotAvailable) Then
    Result := DataRec.CISType
  Else Begin
    Result := 0;
    EntSys.DataAccessErrDlg(True, EmplRecErrStr + 'CertificateType');
  End; { Else }
end;

procedure TEmployee.SetCertificateType(Value: Byte);
begin
  If (RecAccess <> NotAvailable) And (PropAccess[21] = paReadWrite) Then Begin
    If (DataRec.CISType <> Value) Then Begin
      If (Value In [0..5]) Then Begin
        DataRec.CISType := Value;
        RecChanged := True;
      End { If (Value In [0..5])  }
      Else
        Entsys.CustomException (EmplRecErrStr + 'CertificateType');
    End; { If }
  End { If }
  Else
    EntSys.DataAccessErrDlg(False, EmplRecErrStr + 'CertificateType');
end;

//------------------------------

function TEmployee.GetNationalInsuranceNo: cuStr10;
begin
  If (RecAccess <> NotAvailable) Then
    Result := DataRec.ENINo
  Else Begin
    Result := '';
    EntSys.DataAccessErrDlg(True, EmplRecErrStr + 'NationalInsuranceNo');
  End; { Else }
end;

procedure TEmployee.SetNationalInsuranceNo(Value: cuStr10);
begin
  If (RecAccess <> NotAvailable) And (PropAccess[22] = paReadWrite) Then Begin
    If (DataRec.ENINo <> Value) Then Begin
      DataRec.ENINo := Value;
      RecChanged := True;
    End; { If }
  End { If }
  Else
    EntSys.DataAccessErrDlg(False, EmplRecErrStr + 'NationalInsuranceNo');
end;

//------------------------------

Function TEmployee.GetLabourViaPL : WordBool;
begin
  Result := False;
  If (RecAccess <> NotAvailable) Then
    Result := DataRec.LabPLOnly
  Else
    EntSys.DataAccessErrDlg(True, EmplRecErrStr + 'LabourViaPL');
end;

Procedure TEmployee.SetLabourViaPL(Value : WordBool);
begin
  If (RecAccess <> NotAvailable) And (PropAccess[23] = paReadWrite) Then
  Begin
    If (DataRec.LabPLOnly <> Value) Then Begin
      DataRec.LabPLOnly := Value;
      RecChanged := True;
    End; { If }
  End { If }
  Else
    EntSys.DataAccessErrDlg(False, EmplRecErrStr + 'LabourViaPL');
end;

//-------------------------------------------------------------------------

// MH 02/02/2010 (v6.3): Added TAbsEmployee3
Function TEmployee.GetEmailAddr : cuStr100;
Begin // GetEmailAddr
  If (RecAccess <> NotAvailable) Then
    Result := DataRec.emEmailAddr
  Else
    EntSys.DataAccessErrDlg(True, EmplRecErrStr + 'EmailAddr');
End; // GetEmailAddr

Procedure TEmployee.SetEmailAddr(Value : cuStr100);
Begin // SetEmailAddr
  If (RecAccess <> NotAvailable) And (PropAccess[24] = paReadWrite) Then
  Begin
    If (DataRec.emEmailAddr <> Value) Then
    Begin
      DataRec.emEmailAddr := Value;
      RecChanged := True;
    End; { If }
  End { If }
  Else
    EntSys.DataAccessErrDlg(False, EmplRecErrStr + 'EmailAddr');
End; // SetEmailAddr

//-------------------------------------------------------------------------

Function TEmployee.GetContractorType : Byte;
Begin // GetContractorType
  Result := 0;
  If (RecAccess <> NotAvailable) Then
    Result := DataRec.CISSubType
  Else
    EntSys.DataAccessErrDlg(True, EmplRecErrStr + 'ContractorType');
End; // GetContractorType

Procedure TEmployee.SetContractorType(Value : Byte);
Begin // SetContractorType
  EntSys.NotImplException ('TAbsEmployee4.emContractorType');
End; // SetContractorType

//------------------------------

Function TEmployee.GetTagged : Byte;
Begin // GetTagged
  Result := 0;
  If (RecAccess <> NotAvailable) Then
    Result := DataRec.Tagged
  Else
    EntSys.DataAccessErrDlg(True, EmplRecErrStr + 'Tagged');
End; // GetTagged

Procedure TEmployee.SetTagged(Value : Byte);
Begin // SetTagged
  EntSys.NotImplException ('TAbsEmployee4.emTagged');
End; // SetTagged

//------------------------------

Function TEmployee.GetTimeRateRules : Byte;
Begin // GetTimeRateRules
  Result := 0;
  If (RecAccess <> NotAvailable) Then
    Result := DataRec.UseORate
  Else
    EntSys.DataAccessErrDlg(True, EmplRecErrStr + 'TimeRateRules');
End; // GetTimeRateRules

Procedure TEmployee.SetTimeRateRules(Value : Byte);
Begin // SetTimeRateRules
  EntSys.NotImplException ('TAbsEmployee4.emTimeRateRules');
End; // SetTimeRateRules

//------------------------------

Function TEmployee.GetUTRCode : cuStr10;
Begin // GetUTRCode
  If (RecAccess <> NotAvailable) Then
    Result := DataRec.UTRCode
  Else
    EntSys.DataAccessErrDlg(True, EmplRecErrStr + 'UTRCode');
End; // GetUTRCode

Procedure TEmployee.SetUTRCode(Value : cuStr10);
Begin // SetUTRCode
  EntSys.NotImplException ('TAbsEmployee4.emUTRCode');
End; // SetUTRCode

//------------------------------

Function TEmployee.GetVerificationNo : cuStr13;
Begin // GetVerificationNo
  If (RecAccess <> NotAvailable) Then
    Result := DataRec.VerifyNo
  Else
    EntSys.DataAccessErrDlg(True, EmplRecErrStr + 'VerificationNo');
End; // GetVerificationNo

Procedure TEmployee.SetVerificationNo(Value : cuStr13);
Begin // SetVerificationNo
  EntSys.NotImplException ('TAbsEmployee4.emVerificationNo');
End; // SetVerificationNo

//=========================================================================

//------------------------------

//RB 22/11/2017 2018-R1 ABSEXCH-19396: GDPR (POST 19352) - 8.3.1.1.1 - DLL + COM Customisation Support
function TEmployee.GetAnonymisationStatus: TCustomerAnonymisationStatus;
begin
  If (RecAccess <> NotAvailable) Then
  begin
    Case DataRec.emAnonymisationStatus Of
      VarConst.asNotRequested     : Result := CustABSU.asNotRequested;
      VarConst.asPending          : Result := CustABSU.asPending;
      VarConst.asAnonymised       : Result := CustABSU.asAnonymised;
    End
  end
  Else
    EntSys.DataAccessErrDlg(True, EmplRecErrStr + 'AnonymisationStatus');
end;

procedure TEmployee.SetAnonymisationStatus(
  Value: TCustomerAnonymisationStatus);
begin
  EntSys.NotImplException ('TAbsEmployee5.emAnonymisationStatus');
end;

//------------------------------

function TEmployee.GetAnonymisedDate: cuStr8;
begin
  If (RecAccess <> NotAvailable) Then
    Result := DataRec.emAnonymisedDate
  Else
    EntSys.DataAccessErrDlg(True, EmplRecErrStr + 'AnonymisedDate');
end;

procedure TEmployee.SetAnonymisedDate(Value: cuStr8);
begin
  EntSys.NotImplException ('TAbsEmployee5.emAnonymisedDate');
end;

//------------------------------

function TEmployee.GetAnonymisedTime: cuStr6;
begin
  If (RecAccess <> NotAvailable) Then
    Result := DataRec.emAnonymisedTime
  Else
    EntSys.DataAccessErrDlg(True, EmplRecErrStr + 'AnonymisedTime');
end;

procedure TEmployee.SetAnonymisedTime(Value: cuStr6);
begin
  EntSys.NotImplException ('TAbsEmployee5.emAnonymisedTime');
end;

//------------------------------

function TEmployee.GetStatus: TEmpStatus;
begin
  If (RecAccess <> NotAvailable) Then
  begin
    Case DataRec.emStatus Of
      VarConst.emsOpen     : Result := CustABSU.emsOpen;
      VarConst.emsClosed   : Result := CustABSU.emsClosed;
    End;
  end
  Else
    EntSys.DataAccessErrDlg(True, EmplRecErrStr + 'AnonymisationStatus');
end;

procedure TEmployee.SetStatus(Value: TEmpStatus);
begin
  EntSys.NotImplException ('TAbsEmployee5.emAnonymisationStatus');
end;

//==========================================================================

end.

