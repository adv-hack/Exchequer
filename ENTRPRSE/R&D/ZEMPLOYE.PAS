unit zEmploye;

interface

uses
  ComObj, ActiveX, AxCtrls, Classes, Dialogs, StdVcl, SysUtils,
  Enterprise_TLB, CustTypU, CustAbsU;

type
  // MH 20/03/13 v7.0.2 ABSEXCH-14162: Extended Employee class for HF Group with
  //                                   TAbsEmployee4/ICOMEmployee4
  TCOMEmployee = class(TAutoIntfObject, ICOMEmployee, ICOMEmployee2, ICOMEmployee3, ICOMEmployee4, ICOMEmployee5)
  private
    FEntSysObj : TEnterpriseSystem;
    FEmployee : TAbsEmployee5;
  protected
    { Property methods }
    function Get_AccessRights: TRecordAccessStatus; safecall;
    function Get_emCode: WideString; safecall;
    procedure Set_emCode(const Value: WideString); safecall;
    function Get_emSupplier: WideString; safecall;
    procedure Set_emSupplier(const Value: WideString); safecall;
    function Get_emName: WideString; safecall;
    procedure Set_emName(const Value: WideString); safecall;
    function Get_emAddress(Index: Integer): WideString; safecall;
    procedure Set_emAddress(Index: Integer; const Value: WideString); safecall;
    function Get_emPhone: WideString; safecall;
    procedure Set_emPhone(const Value: WideString); safecall;
    function Get_emFax: WideString; safecall;
    procedure Set_emFax(const Value: WideString); safecall;
    function Get_emMobile: WideString; safecall;
    procedure Set_emMobile(const Value: WideString); safecall;
    function Get_emType: Integer; safecall;
    procedure Set_emType(Value: Integer); safecall;
    function Get_emPayrollNumber: WideString; safecall;
    procedure Set_emPayrollNumber(const Value: WideString); safecall;
    function Get_emCertificateNumber: WideString; safecall;
    procedure Set_emCertificateNumber(const Value: WideString); safecall;
    function Get_emCertificateExpiry: WideString; safecall;
    procedure Set_emCertificateExpiry(const Value: WideString); safecall;
    function Get_emUserField1: WideString; safecall;
    procedure Set_emUserField1(const Value: WideString); safecall;
    function Get_emUserField2: WideString; safecall;
    procedure Set_emUserField2(const Value: WideString); safecall;
    function Get_emUserField3: WideString; safecall;
    procedure Set_emUserField3(const Value: WideString); safecall;
    function Get_emUserField4: WideString; safecall;
    procedure Set_emUserField4(const Value: WideString); safecall;
    function Get_emCostCentre: WideString; safecall;
    procedure Set_emCostCentre(const Value: WideString); safecall;
    function Get_emDepartment: WideString; safecall;
    procedure Set_emDepartment(const Value: WideString); safecall;
    function Get_emOwnTimeRatesOnly: WordBool; safecall;
    procedure Set_emOwnTimeRatesOnly(Value: WordBool); safecall;
    function Get_emSelfBilling: WordBool; safecall;
    procedure Set_emSelfBilling(Value: WordBool); safecall;
    function Get_emGroupCertificate: WordBool; safecall;
    procedure Set_emGroupCertificate(Value: WordBool); safecall;
    function Get_emCertificateType: Integer; safecall;
    procedure Set_emCertificateType(Value: Integer); safecall;
    function Get_emNationalInsuranceNo: WideString; safecall;
    procedure Set_emNationalInsuranceNo(const Value: WideString); safecall;

    // HM 04/06/03: Added ICOMEmployee2
    function Get_emLabourViaPL: WordBool; safecall;
    procedure Set_emLabourViaPL(Value: WordBool); safecall;

    // MH 02/02/2010 (v6.3): Added ICOMEmployee3 for TAbsEmployee3
    function Get_emEmailAddr: WideString; safecall;
    procedure Set_emEmailAddr(const Value: WideString); safecall;

    // MH 20/03/13 v7.0.2 ABSEXCH-14162: Extended Employee class for HF Group with
    //                                   TAbsEmployee4/ICOMEmployee4
    function Get_emContractorType: Integer; safecall;
    procedure Set_emContractorType(Value: Integer); safecall;
    function Get_emTagged: Integer; safecall;
    procedure Set_emTagged(Value: Integer); safecall;
    function Get_emTimeRateRules: Integer; safecall;
    procedure Set_emTimeRateRules(Value: Integer); safecall;
    function Get_emUTRCode: WideString; safecall;
    procedure Set_emUTRCode(const Value: WideString); safecall;
    function Get_emVerificationNo: WideString; safecall;
    procedure Set_emVerificationNo(const Value: WideString); safecall;

    //RB 22/11/2017 2018-R1 ABSEXCH-19396: GDPR (POST 19352) - 8.3.1.1.1 - DLL + COM Customisation Support        
    function Get_emStatus: Enterprise_TLB.TEmployeeStatus; safecall;
    procedure Set_emStatus(Value: Enterprise_TLB.TEmployeeStatus); safecall;
    function Get_emAnonymisationStatus: Enterprise_TLB.TEntityAnonymisationStatus; safecall;
    procedure Set_emAnonymisationStatus(Value: Enterprise_TLB.TEntityAnonymisationStatus); safecall;
    function Get_emAnonymisedDate: WideString; safecall;
    procedure Set_emAnonymisedDate(const Value: WideString); safecall;
    function Get_emAnonymisedTime: WideString; safecall;
    procedure Set_emAnonymisedTime(const Value: WideString); safecall;
    
  public
    Constructor Create;
    Destructor Destroy; Override;

    procedure InitEmployee(EntSysObj: TEnterpriseSystem);
  End; { TCOMEmployee }


implementation

uses ComServ, CustIntU, ZUtils;

//=========================================================================

Constructor TCOMEmployee.Create;
Begin { Create }
  // MH 20/03/13 v7.0.2 ABSEXCH-14162: Extended Employee class for HF Group with
  //                                   TAbsEmployee4/ICOMEmployee4
  Inherited Create (ComServer.TypeLib, ICOMEmployee5);

  FEntSysObj := Nil;
End; { Create }

//------------------------------

destructor TCOMEmployee.Destroy;
begin
  FEntSysObj := NIL;

  inherited;
end;

//-------------------------------------------------------------------------

procedure TCOMEmployee.InitEmployee(EntSysObj: TEnterpriseSystem);
begin
  FEntSysObj := EntSysObj;

  // MH 20/03/13 v7.0.2 ABSEXCH-14162: Extended Employee class for HF Group with
  //                                   TAbsEmployee4/ICOMEmployee4
  FEmployee := FEntSysObj.JobCosting.Employee As TAbsEmployee5;
end;

//-------------------------------------------------------------------------

function TCOMEmployee.Get_AccessRights: TRecordAccessStatus;
begin
  Result := Ord(FEmployee.AccessRights);
end;

//------------------------------

function TCOMEmployee.Get_emCode: WideString;
begin
  Result := FEmployee.emCode;
end;

procedure TCOMEmployee.Set_emCode(const Value: WideString);
begin
  FEmployee.emCode := Value;
end;

//------------------------------

function TCOMEmployee.Get_emSupplier: WideString;
begin
  Result := FEmployee.emSupplier;
end;

procedure TCOMEmployee.Set_emSupplier(const Value: WideString);
begin
  FEmployee.emSupplier := Value;
end;

//------------------------------

function TCOMEmployee.Get_emName: WideString;
begin
  Result := FEmployee.emName;
end;

procedure TCOMEmployee.Set_emName(const Value: WideString);
begin
  FEmployee.emName := Value;
end;

//------------------------------

function TCOMEmployee.Get_emAddress(Index: Integer): WideString;
begin
  Result := FEmployee.emAddress[Index];
end;

procedure TCOMEmployee.Set_emAddress(Index: Integer; const Value: WideString);
begin
  FEmployee.emAddress[Index] := Value;
end;

//------------------------------

function TCOMEmployee.Get_emPhone: WideString;
begin
  Result := FEmployee.emPhone;
end;

procedure TCOMEmployee.Set_emPhone(const Value: WideString);
begin
  FEmployee.emPhone := Value;
end;

//------------------------------

function TCOMEmployee.Get_emFax: WideString;
begin
  Result := FEmployee.emFax;
end;

procedure TCOMEmployee.Set_emFax(const Value: WideString);
begin
  FEmployee.emFax := Value;
end;

//------------------------------

function TCOMEmployee.Get_emMobile: WideString;
begin
  Result := FEmployee.emMobile;
end;

procedure TCOMEmployee.Set_emMobile(const Value: WideString);
begin
  FEmployee.emMobile := Value;
end;

//------------------------------

function TCOMEmployee.Get_emType: Integer;
begin
  Result := FEmployee.emType;
end;

procedure TCOMEmployee.Set_emType(Value: Integer);
begin
  FEmployee.emType := Value;
end;

//------------------------------

function TCOMEmployee.Get_emPayrollNumber: WideString;
begin
  Result := FEmployee.emPayrollNumber;
end;

procedure TCOMEmployee.Set_emPayrollNumber(const Value: WideString);
begin
  FEmployee.emPayrollNumber := Value;
end;

//------------------------------

function TCOMEmployee.Get_emCertificateNumber: WideString;
begin
  Result := FEmployee.emCertificateNumber;
end;

procedure TCOMEmployee.Set_emCertificateNumber(const Value: WideString);
begin
  FEmployee.emCertificateNumber := Value;
end;

//------------------------------

function TCOMEmployee.Get_emCertificateExpiry: WideString;
begin
  Result := FEmployee.emCertificateExpiry;
end;

procedure TCOMEmployee.Set_emCertificateExpiry(const Value: WideString);
begin
  FEmployee.emCertificateExpiry := Value;
end;

//------------------------------

function TCOMEmployee.Get_emUserField1: WideString;
begin
  Result := FEmployee.emUserField1;
end;

procedure TCOMEmployee.Set_emUserField1(const Value: WideString);
begin
  FEmployee.emUserField1 := Value;
end;

//------------------------------

function TCOMEmployee.Get_emUserField2: WideString;
begin
  Result := FEmployee.emUserField2;
end;

procedure TCOMEmployee.Set_emUserField2(const Value: WideString);
begin
  FEmployee.emUserField2 := Value;
end;

//------------------------------

function TCOMEmployee.Get_emUserField3: WideString;
begin
  Result := FEmployee.emUserField3;
end;

procedure TCOMEmployee.Set_emUserField3(const Value: WideString);
begin
  FEmployee.emUserField3 := Value;
end;

//------------------------------

function TCOMEmployee.Get_emUserField4: WideString;
begin
  Result := FEmployee.emUserField4;
end;

procedure TCOMEmployee.Set_emUserField4(const Value: WideString);
begin
  FEmployee.emUserField4 := Value;
end;

//------------------------------

function TCOMEmployee.Get_emCostCentre: WideString;
begin
  Result := FEmployee.emCostCentre;
end;

procedure TCOMEmployee.Set_emCostCentre(const Value: WideString);
begin
  FEmployee.emCostCentre := Value;
end;

//------------------------------

function TCOMEmployee.Get_emDepartment: WideString;
begin
  Result := FEmployee.emDepartment;
end;

procedure TCOMEmployee.Set_emDepartment(const Value: WideString);
begin
  FEmployee.emDepartment := Value;
end;

//------------------------------

function TCOMEmployee.Get_emOwnTimeRatesOnly: WordBool;
begin
  Result := FEmployee.emOwnTimeRatesOnly;
end;

procedure TCOMEmployee.Set_emOwnTimeRatesOnly(Value: WordBool);
begin
  FEmployee.emOwnTimeRatesOnly := Value;
end;

//------------------------------

function TCOMEmployee.Get_emSelfBilling: WordBool;
begin
  Result := FEmployee.emSelfBilling;
end;

procedure TCOMEmployee.Set_emSelfBilling(Value: WordBool);
begin
  FEmployee.emSelfBilling := Value;
end;

//------------------------------

function TCOMEmployee.Get_emGroupCertificate: WordBool;
begin
  Result := FEmployee.emGroupCertificate;
end;

procedure TCOMEmployee.Set_emGroupCertificate(Value: WordBool);
begin
  FEmployee.emGroupCertificate := Value;
end;

//------------------------------

function TCOMEmployee.Get_emCertificateType: Integer;
begin
  Result := FEmployee.emCertificateType;
end;

procedure TCOMEmployee.Set_emCertificateType(Value: Integer);
begin
  FEmployee.emCertificateType := Value;
end;

//------------------------------

function TCOMEmployee.Get_emNationalInsuranceNo: WideString;
begin
  Result := FEmployee.emNationalInsuranceNo;
end;

procedure TCOMEmployee.Set_emNationalInsuranceNo(const Value: WideString);
begin
  FEmployee.emNationalInsuranceNo := Value;
end;

//------------------------------

function TCOMEmployee.Get_emLabourViaPL: WordBool;
begin
  Result := FEmployee.emLabourViaPL;
end;

procedure TCOMEmployee.Set_emLabourViaPL(Value: WordBool);
begin
  FEmployee.emLabourViaPL := Value;
end;

//------------------------------

function TCOMEmployee.Get_emEmailAddr: WideString;
Begin // Get_emEmailAddr
  Result := FEmployee.emEmailAddr;
End; // Get_emEmailAddr

procedure TCOMEmployee.Set_emEmailAddr(const Value: WideString);
Begin // Set_emEmailAddr
  FEmployee.emEmailAddr := Value;
End; // Set_emEmailAddr

//------------------------------

function TCOMEmployee.Get_emContractorType: Integer;
Begin // Get_emContractorType
  Result := FEmployee.emContractorType;
End; // Get_emContractorType

procedure TCOMEmployee.Set_emContractorType(Value: Integer);
Begin // Set_emContractorType
  FEmployee.emContractorType := Value;
End; // Set_emContractorType

//------------------------------

function TCOMEmployee.Get_emTagged: Integer;
Begin // Get_emTagged
  Result := FEmployee.emTagged;
End; // Get_emTagged

procedure TCOMEmployee.Set_emTagged(Value: Integer);
Begin // Set_emTagged
  FEmployee.emTagged := Value;
End; // Set_emTagged

//------------------------------

function TCOMEmployee.Get_emTimeRateRules: Integer;
Begin // Get_emTimeRateRules
  Result := FEmployee.emTimeRateRules;
End; // Get_emTimeRateRules

procedure TCOMEmployee.Set_emTimeRateRules(Value: Integer);
Begin // Set_emTimeRateRules
  FEmployee.emTimeRateRules := Value;
End; // Set_emTimeRateRules

//------------------------------

function TCOMEmployee.Get_emUTRCode: WideString;
Begin // Get_emUTRCode
  Result := FEmployee.emUTRCode;
End; // Get_emUTRCode

procedure TCOMEmployee.Set_emUTRCode(const Value: WideString);
Begin // Set_emUTRCode
  FEmployee.emUTRCode := Value;
End; // Set_emUTRCode

//------------------------------

function TCOMEmployee.Get_emVerificationNo: WideString;
Begin // Get_emVerificationNo
  Result := FEmployee.emVerificationNo;
End; // Get_emVerificationNo

procedure TCOMEmployee.Set_emVerificationNo(const Value: WideString);
Begin // Set_emVerificationNo
  FEmployee.emVerificationNo := Value;
End; // Set_emVerificationNo

//=========================================================================

//------------------------------
//RB 22/11/2017 2018-R1 ABSEXCH-19396: GDPR (POST 19352) - 8.3.1.1.1 - DLL + COM Customisation Support
function TCOMEmployee.Get_emAnonymisationStatus: Enterprise_TLB.TEntityAnonymisationStatus;
begin
  case FEmployee.emAnonymisationStatus of
    asNotRequested  : Result := Enterprise_TLB.asNotRequested;
    asPending       : Result := Enterprise_TLB.asPending;
    asAnonymised    : Result := Enterprise_TLB.asAnonymised;
  end;
end;

procedure TCOMEmployee.Set_emAnonymisationStatus(
  Value: TEntityAnonymisationStatus);
begin
  Case Value Of
    Enterprise_TLB.asNotRequested  : FEmployee.emAnonymisationStatus := asNotRequested;
    Enterprise_TLB.asPending       : FEmployee.emAnonymisationStatus := asPending;
    Enterprise_TLB.asAnonymised    : FEmployee.emAnonymisationStatus := asAnonymised;
  End;
end;

//------------------------------

function TCOMEmployee.Get_emAnonymisedDate: WideString;
begin
  Result := FEmployee.emAnonymisedDate;
end;

procedure TCOMEmployee.Set_emAnonymisedDate(const Value: WideString);
begin
  FEmployee.emAnonymisedDate := Value;
end;

//------------------------------

function TCOMEmployee.Get_emAnonymisedTime: WideString;
begin
  Result := FEmployee.emAnonymisedTime;
end;

procedure TCOMEmployee.Set_emAnonymisedTime(const Value: WideString);
begin
  FEmployee.emAnonymisedTime := Value;
end;

//------------------------------

function TCOMEmployee.Get_emStatus: Enterprise_TLB.TEmployeeStatus;
begin
  case FEmployee.emStatus of
    emsOpen     : Result := Enterprise_TLB.emsOpen;
    emsClosed   : Result := Enterprise_TLB.emsClosed;
  end;
end;

procedure TCOMEmployee.Set_emStatus(Value: TEmployeeStatus);
begin
  case Value of
    Enterprise_TLB.emsOpen    : FEmployee.emStatus := emsOpen;
    Enterprise_TLB.emsClosed  : FEmployee.emStatus := emsClosed;
  end;
end;

//====================================================================
end.
