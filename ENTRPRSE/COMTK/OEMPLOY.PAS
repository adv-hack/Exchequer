unit oEmploy;

{ markd6 15:34 01/11/2001: Disabled Byte Alignment in Delphi 6.0 }
{$ALIGN 1}  { Variable Alignment Disabled }


interface

Uses Classes, Dialogs, Forms, SysUtils, Windows, ComObj, ActiveX,
     {$IFNDEF WANTEXE}Enterprise01_TLB{$ELSE}Enterprise04_TLB{$ENDIF}, oBtrieve, GlobVar, VarConst, VarCnst3, MiscFunc,
     BtrvU2, ExBTTH1U, oAddr, oRates, oNotes, oLinks, GlobList;

type
  TEmployee = class(TBtrieveFunctions, IEmployee, IEmployee2, IEmployee3, IEmployee4, IEmployee5,
                   IEmployee6, IEmployee7, IEmployee8, IBrowseInfo)
  private
    FEmployeeRec : TBatchEmplRec;

    FAddressO  : TAddress;
    FAddressI  : IAddress;

    FTimeRatesO  : TTimeRates;
    FTimeRatesI  : ITimeRates;

    FNotesO : TNotes;
    FNotesI : INotes;

    FLinksO : TLinks;
    FLinksI : ILinks;

    FIntfType  : TInterfaceMode;

    FToolkit : TObject;


  protected
  //IEmployee functions
    function  Get_emCode: WideString; safecall;
    procedure Set_emCode(const Value: WideString); safecall;
    function  Get_emSupplier: WideString; safecall;
    procedure Set_emSupplier(const Value: WideString); safecall;
    function  Get_emName: WideString; safecall;
    procedure Set_emName(const Value: WideString); safecall;
    function  Get_emAddress: IAddress; safecall;
    function  Get_emPhone: WideString; safecall;
    procedure Set_emPhone(const Value: WideString); safecall;
    function  Get_emFax: WideString; safecall;
    procedure Set_emFax(const Value: WideString); safecall;
    function  Get_emMobile: WideString; safecall;
    procedure Set_emMobile(const Value: WideString); safecall;
    function  Get_emType: TEmployeeType; safecall;
    procedure Set_emType(Value: TEmployeeType); safecall;
    function  Get_emPayrollNumber: WideString; safecall;
    procedure Set_emPayrollNumber(const Value: WideString); safecall;
    function  Get_emCertificateNumber: WideString; safecall;
    procedure Set_emCertificateNumber(const Value: WideString); safecall;
    function  Get_emCertificateExpiry: WideString; safecall;
    procedure Set_emCertificateExpiry(const Value: WideString); safecall;
    function  Get_emUserField1: WideString; safecall;
    procedure Set_emUserField1(const Value: WideString); safecall;
    function  Get_emUserField2: WideString; safecall;
    procedure Set_emUserField2(const Value: WideString); safecall;
    function  Get_emTimeRates: ITimeRates; safecall;
    function  Get_emCostCentre: WideString; safecall;
    procedure Set_emCostCentre(const Value: WideString); safecall;
    function  Get_emDepartment: WideString; safecall;
    procedure Set_emDepartment(const Value: WideString); safecall;
    function  Get_emOwnTimeRatesOnly: WordBool; safecall;
    procedure Set_emOwnTimeRatesOnly(Value: WordBool); safecall;
    function  Get_emNotes: INotes; safecall;

    function  Get_Index: TEmployeeIndex; safecall;
    procedure Set_Index(Value: TEmployeeIndex); safecall;

    function  Clone: IEmployee; safecall;
    function BuildCodeIndex(const Code : WideString) : WideString; safecall;
    function BuildSupplierIndex(const Supplier : WideString) : WideString; safecall;

    // IAddress / TAddress implementation
    //PR: 15/10/2013 MRD 2.5.18 Add DirectToLines default parameter
    function GetAddrLine (AddrIdx, Idx : Byte; DirectToLines : Boolean = True) : String;
    Procedure SetAddrLine(AddrIdx, Idx : Byte; Value : String; DirectToLines : Boolean = True);

    //IEmployee2 methods
    function Update: IEmployee2; safecall;
    function Add: IEmployee2; safecall;
    function Save: Integer; safecall;
    procedure Cancel; safecall;
    function Get_emNISerialNo: WideString; safecall;
    procedure Set_emNISerialNo(const Value: WideString); safecall;
    function Get_emLinks: ILinks; safecall;

    //IEmployee3 methods
    function Get_emLabourViaPL: WordBool; safecall;
    procedure Set_emLabourViaPL(Value: WordBool); safecall;

    //IEmployee4 methods
    function Get_emTimeRateRules: TTimeRateRulesType; safecall;
    procedure Set_emTimeRateRules(Value: TTimeRateRulesType); safecall;

    //IBrowseInfo
    function Get_ibInterfaceMode: Integer; safecall;

    function Get_emSelfBilling: WordBool; safecall;
    procedure Set_emSelfBilling(Value: WordBool); safecall;
    function Get_emGroupCertificate: WordBool; safecall;
    procedure Set_emGroupCertificate(Value: WordBool); safecall;
    function Get_emCertificateType: TEmployeeCertificateType; safecall;
    procedure Set_emCertificateType(Value: TEmployeeCertificateType); safecall;
    function Get_emUserField3: WideString; safecall;
    procedure Set_emUserField3(const Value: WideString); safecall;
    function Get_emUserField4: WideString; safecall;
    procedure Set_emUserField4(const Value: WideString); safecall;
    function Get_emUTRCode: WideString; safecall;
    procedure Set_emUTRCode(const Value: WideString); safecall;
    function Get_emVerificationNo: WideString; safecall;
    procedure Set_emVerificationNo(const Value: WideString); safecall;
    function Get_emTagged: WordBool; safecall;
    procedure Set_emTagged(Value: WordBool); safecall;

    function Get_emContractorType: TContractorType; safecall;
    procedure Set_emContractorType(Value: TContractorType); safecall;

    //PR 04/02/2010 IEmployee6 methods
    function Get_emEmailAddress: WideString; safecall;
    procedure Set_emEmailAddress(const Value: WideString); safecall;

    //AP 17/11/2017 ABSEXCH-19395 IEmployee7 methods
    function  Get_emStatus: TEmployeeStatusType; safecall;
    function  Get_emAnonymisationStatus: TEntityAnonymisationStatusType; safecall;
    function  Get_emAnonymisedDate: WideString; safecall;
    function  Get_emAnonymisedTime: WideString; safecall;

    //HV 20/06/2018 2018-R1.1 ABSEXCH-20851: Com Toolkit > Employee Status > The new Employee Status field should fully implement the Open/Close status changes as per HLD section 6.3.2 Close Employee Process
    procedure Set_emStatus(Value: TEmployeeStatusType); safecall;

    function Get_KeyString2: WideString; override; safecall;


    //Local methods
    Function  AuthoriseFunction (Const FuncNo : Byte;
                                 Const MethodName : String;
                                 Const AccessType : Byte = 0) : Boolean; Override;
    Function  GetDataRecord (Const BtrOp : SmallInt; Const SearchKey : String = '') : Integer; Override;
    procedure InitObjects;
    procedure CopyDataRecord; override;
    procedure InitNewRecord;
    Procedure LoadDetails (Const EmpDets : TBatchEmplRec; Const LockPos : LongInt);
    //AP : 19/10/2016 : ABSEXCH-11837 The index emIdxSupplier on the IEmployee interface is incorrect - it should be 2 rather than 1
    Function TranslateIndex (Const IdxNo : SmallInt; Const FromTLB : Boolean) : SmallInt; Override;
  public
    Constructor Create(Const IType : TInterfaceMode;
                       Const Toolkit   : TObject;
                       Const BtrIntf   : TCtkTdPostExLocalPtr);
    Destructor Destroy; override;
    procedure CloneDetails(const EmployeeDetails : TBatchEmplRec);
  end;

  Function CreateTEmployee (Const Toolkit : TObject; Const ClientId : Integer) : TEmployee;



implementation
                                                                                                                
uses
  ComServ, DllMiscU, DllErrU, BtKeys1U, EtStrU, DllJobU, oToolkit;

Function CreateTEmployee (Const Toolkit : TObject; Const ClientId : Integer) : TEmployee;
Var
  BtrIntf : TCtkTdPostExLocalPtr;
Begin { CreateTJobAnalysis }
  // Create common btrieve interface for objects
  New (BtrIntf, Create(ClientId));

  // Open files needed by object
  BtrIntf^.Open_System(JMiscF, JMiscF);
  BtrIntf^.Open_System(JCtrlF, JCtrlF);   {TimeRates}
  BtrIntf^.Open_System(PwrdF,  PwrdF);   { Notes }
  //PR: 03/01/2012 ABSEXCH-12350 Need to open MiscF for links.
  BtrIntf^.Open_System(MiscF, MiscF); {Links}

  // Create bas TEmployee object
  Result := TEmployee.Create(imGeneral, Toolkit, BtrIntf);

  if SQLBeingUsed then
    Result.SetFileNos([PwrdF, JCtrlF, JMiscF, MiscF]);

End; { CreateTJobAnalysis }


Constructor TEmployee.Create(Const IType     : TInterfaceMode;
                                Const Toolkit   : TObject;
                                Const BtrIntf   : TCtkTdPostExLocalPtr);
begin
  Inherited Create (ComServer.TypeLib, IEmployee8, BtrIntf);

  // Initialise Btrieve Ancestor
  FFileNo := JMiscF;

  FillChar(FEmployeeRec, SizeOf(FEmployeeRec), #0);

  InitObjects;
  FIntfType := IType;

  FToolkit := Toolkit;

end;

Destructor TEmployee.Destroy;
begin
  InitObjects;

    If (FIntfType = imGeneral) Then
    Dispose (FBtrIntf, Destroy);

  inherited Destroy;
end;

procedure TEmployee.InitObjects;
begin
  FToolkit := nil;
  FAddressO := nil;
  FAddressI := nil;

  FTimeRatesO  := nil;
  FTimeRatesI  := nil;

  FNotesO := nil;
  FNotesI := nil;

  FLinksO := nil;
  FLinksI := nil;

end;



function  TEmployee.Get_emCode: WideString;
begin
  Result := FEmployeeRec.EmpCode;
end;

procedure TEmployee.Set_emCode(const Value: WideString);
begin
  If (FIntfType = imAdd) Then
    FEmployeeRec.EmpCode := Value;
end;

function  TEmployee.Get_emSupplier: WideString;
begin
  Result := FEmployeeRec.Supplier;
end;

procedure TEmployee.Set_emSupplier(const Value: WideString);
begin
  FEmployeeRec.Supplier := Value;
end;

function  TEmployee.Get_emName: WideString;
begin
  Result := FEmployeeRec.EmpName;
end;

procedure TEmployee.Set_emName(const Value: WideString);
begin
  FEmployeeRec.EmpName := Value;
end;

function  TEmployee.Get_emPhone: WideString;
begin
  Result := FEmployeeRec.Phone;
end;

procedure TEmployee.Set_emPhone(const Value: WideString);
begin
  FEmployeeRec.Phone := Value;
end;

function  TEmployee.Get_emFax: WideString;
begin
  Result := FEmployeeRec.Fax;
end;

procedure TEmployee.Set_emFax(const Value: WideString);
begin
  FEmployeeRec.Fax := Value;
end;

function  TEmployee.Get_emMobile: WideString;
begin
  Result := FEmployeeRec.Mobile;
end;

procedure TEmployee.Set_emMobile(const Value: WideString);
begin
  FEmployeeRec.Mobile := Value;
end;

function  TEmployee.Get_emType: TEmployeeType;
begin
  Case FEmployeeRec.EmpType of
    'P'  : Result := emTypeProduction;
    'S'  : Result := emTypeSubContract;
    'O'  : Result := emTypeOverhead;
  end;
end;

procedure TEmployee.Set_emType(Value: TEmployeeType);
begin
  Case Value of
    emTypeProduction  : FEmployeeRec.EmpType := 'P';
    emTypeSubContract : FEmployeeRec.EmpType := 'S';
    emTypeOverhead    : FEmployeeRec.EmpType := 'O';
  end;
end;

function  TEmployee.Get_emPayrollNumber: WideString;
begin
  Result := FEmployeeRec.PayNo;
end;

procedure TEmployee.Set_emPayrollNumber(const Value: WideString);
begin
  FEmployeeRec.PayNo := Value;
end;

function  TEmployee.Get_emCertificateNumber: WideString;
begin
  Result := FEmployeeRec.CertNo;
end;

procedure TEmployee.Set_emCertificateNumber(const Value: WideString);
begin
  FEmployeeRec.CertNo := Value;
end;

function  TEmployee.Get_emCertificateExpiry: WideString;
begin
  Result := FEmployeeRec.CertExpiry;
end;

procedure TEmployee.Set_emCertificateExpiry(const Value: WideString);
begin
  FEmployeeRec.CertExpiry := Value;
end;

function  TEmployee.Get_emUserField1: WideString;
begin
  Result := FEmployeeRec.UserDef1;
end;

procedure TEmployee.Set_emUserField1(const Value: WideString);
begin
  FEmployeeRec.UserDef1 := Value;
end;

function  TEmployee.Get_emUserField2: WideString;
begin
  Result := FEmployeeRec.UserDef2;
end;

procedure TEmployee.Set_emUserField2(const Value: WideString);
begin
  FEmployeeRec.UserDef2 := Value;
end;

function TEmployee.Get_emTimeRates : ITimeRates;
begin
  If (Not Assigned(FTimeRatesO)) Then Begin
    { Create and initialise the Job Record sub-object }
    FTimeRatesO := TTimeRates.Create(imGeneral, FToolkit, FBtrIntF);

    FTimeRatesI := FTimeRatesO;
  End; { If (Not Assigned(FJobO)) }

  FTimeRatesO.EmployeeCode := Get_emCode;

  Result := FTimeRatesI;
end;

function  TEmployee.Get_emCostCentre: WideString;
begin
  Result := FEmployeeRec.CC;
end;

procedure TEmployee.Set_emCostCentre(const Value: WideString);
begin
  FEmployeeRec.CC := Value;
end;

function  TEmployee.Get_emDepartment: WideString;
begin
  Result := FEmployeeRec.Dep;
end;

procedure TEmployee.Set_emDepartment(const Value: WideString);
begin
  FEmployeeRec.Dep := Value;
end;

function  TEmployee.Get_emOwnTimeRatesOnly: WordBool;
begin
  Result := FEmployeeRec.UseORate = 1;
end;

procedure TEmployee.Set_emOwnTimeRatesOnly(Value: WordBool);
begin
  if Value then
    FEmployeeRec.UseORate := 1
  else
    FEmployeeRec.UseORate := 0;
end;

//PR: 15/10/2013 MRD 2.5.18 Add DirectToLines default parameter
function TEmployee.GetAddrLine (AddrIdx, Idx : Byte; DirectToLines : Boolean = True) : String;
begin
  Result := FEmployeeRec.Addr[Idx];
end;

//PR: 15/10/2013 MRD 2.5.18 Add DirectToLines default parameter
Procedure TEmployee.SetAddrLine(AddrIdx, Idx : Byte; Value : String; DirectToLines : Boolean = True);
begin
  FEmployeeRec.Addr[Idx] := Value;
end;

function TEmployee.Get_emAddress: IAddress;
begin
  If (Not Assigned(FAddressO)) Then Begin
    { Create and initialise Customer Address Sub-Object}
    FAddressO := TAddress.Create(1, GetAddrLine, SetAddrLine);

    FAddressI := FAddressO;
  End; { If (Not Assigned(FAddressO)) }

  Result := FAddressI;
end;

function  TEmployee.Get_Index: TEmployeeIndex;
begin
  Result := inherited Get_Index;
end;

procedure TEmployee.Set_Index(Value: TEmployeeIndex);
begin
  inherited Set_Index(Value);
end;


Function  TEmployee.AuthoriseFunction (Const FuncNo : Byte;
                                          Const MethodName : String;
                                          Const AccessType : Byte = 0) : Boolean;
begin
  Case FuncNo Of
    // Step functions
    1..4      : Result := False;  { Not supported as CustF is shared file }

    5..99     : Result := (FIntfType = imGeneral);

    // .Add method
    100       : Result := (FIntfType = imGeneral);
    // .Update method
    101       : Result := (FIntfType = imGeneral);
    // .Save method
    102       : Result := (FIntfType In [imAdd, imUpdate]);
    // .Cancel method
    103       : Result := (FIntfType = imUpdate);
    // .Clone method
    104       : Result := (FIntfType = imGeneral);
  Else
    Result := False;
  End; { Case FuncNo }

  If (Not Result) Then Begin
    If (AccessType = 0) Then
      // Method
      Raise EInvalidMethod.Create ('The method ' + QuotedStr(MethodName) + ' is not available in this object')
    Else
      // Property
      Raise EInvalidMethod.Create ('The property ' + QuotedStr(MethodName) + ' is not available in this object');
  End; { If (Not Result) }

end;

Function  TEmployee.GetDataRecord (Const BtrOp : SmallInt; Const SearchKey : String = '') : Integer;
Var
  BtrOpCode, BtrOpCode2 : SmallInt;
  KeyS                  : Str255;
  Loop                  : Boolean;
Begin { GetDataRecord }
  Result := 0;
  LastErDesc := '';
  BtrOpCode2 := 0;
  With FBtrIntf^ Do Begin
    // General index including CC, Dept, Notes, Matching, etc... records
    BtrOpCode := BtrOp;
    KeyS := SetKeyString(BtrOp, JARCode + JAECode + SearchKey);

    Loop := True;
    Case BtrOp of
      // Moving forward through file
      B_GetGEq,
      B_GetGretr,
      B_GetNext    : BtrOpCode2 := B_GetNext;

      B_GetFirst   : Begin
                       KeyS := JARCode + JAECode + #0;
                       BtrOpCode  := B_GetGEq;
                       BtrOpCode2 := B_GetNext;
                     End;

      // Moving backward through file
      B_GetLess,
      B_GetLessEq,
      B_GetPrev    : BtrOpCode2 := B_GetPrev;

      B_GetLast    : Begin
                       KeyS := JARCode + JAECode + #255;
                       BtrOpCode  := B_GetLessEq;
                       BtrOpCode2 := B_GetPrev;
                     End;

      // Looking for exact match - do it and finish
      B_GetEq      : Loop := False;
    Else
      Raise Exception.Create ('Invalid Btrieve Operation');
    End; { Case BtrOp}

    Repeat
      Result := LFind_Rec (BtrOpCode, FFileNo, FIndex, KeyS);

      BtrOpCode := BtrOpCode2;


      {PR 24/06/2008 - If we've passed the Prefix/SubType we want then drop out of loop
       to avoid reading remaining records in file - may improve SQL performance.}
      if (Result = 0) and ((LJobMisc.RecPFix <> JARCode) or (LJobMisc.SubType <> JAECode)) then
        Result := 9;
    Until (Result <> 0) Or (Not Loop) Or ((LJobMisc.RecPFix = JARCode) And (LJobMisc.SubType = JAECode));



    If (Result = 0) Then Begin
      // check correct record type was returned
      If (LJobMisc.RecPFix = JARCode) And (LJobMisc.SubType = JAECode) Then
      begin
        // Convert to Toolkit structure
        CopyDataRecord;
        FKeyString := KeyS;
      end
      Else
        Result := 4;
    End; { If (Result = 0) }
  End; { With FBtrIntf^ }

  If (Result <> 0) Then
    LastErDesc := Ex_ErrorDescription (63, Result);
End; { GetDataRecord }

procedure TEmployee.CopyDataRecord;
begin
  CopyExEmployeeToTKEmployee (FBtrIntf^.LJobMisc^.EmplRec, FEmployeeRec);
end;


procedure TEmployee.CloneDetails(const EmployeeDetails : TBatchEmplRec);
begin
  FEmployeeRec := EmployeeDetails;
end;

function  TEmployee.Clone: IEmployee;
Var
  CloneO : TEmployee;
Begin { Clone }
  // Check Clone method is available
  AuthoriseFunction(104, 'Clone');

  CloneO := TEmployee.Create(imClone, FToolkit, FBtrIntf);
  if Assigned(CloneO) then
  begin
    CloneO.CloneDetails(FEmployeeRec);
  end;
  Result := CloneO;
end;

function TEmployee.BuildCodeIndex(const Code : WideString) : WideString;
begin
  Result := LJVar(UpperCase(Code), 6);
end;

function TEmployee.BuildSupplierIndex(const Supplier : WideString) : WideString;
begin
  Result := LJVar(UpperCase(Supplier), 6);
end;

function  TEmployee.Get_emNotes: INotes;
begin

  { Check Notes sub-object has been initialised }
  If (Not Assigned(FNotesO)) Then Begin
    { Create and initialise Customer Details }
    FNotesO := TNotes.Create(imGeneral,
                             FToolkit,
                             FBtrIntF,
                             'EMP',
                             '2',
                             False);

    FNotesI := FNotesO;
  End; { If (Not Assigned(FNotesO)) }

  FNotesO.SetStartKey (FullNCode(FEmployeeRec.EmpCode),
                       NoteTCode + NoteECode + FullNCode(FEmployeeRec.EmpCode));

  Result := FNotesI;
end;

function TEmployee.Update: IEmployee2;
Var
  UpdateO : TEmployee;
  FuncRes  : LongInt;
begin { Update }
  Result := Nil;
  AuthoriseFunction(101, 'Update');

  // Lock Current Record
  FuncRes := Lock;

  If (FuncRes = 0) Then Begin
    // Create an update object
    UpdateO := TEmployee.Create(imUpdate, FToolkit, FBtrIntf);

    // Pass current job Record and Locking Details into sub-object
    UpdateO.LoadDetails(FEmployeeRec, LockPosition);
    LockCount := 0;
    LockPosition := 0;

    Result := UpdateO;
  End; { If (FuncRes = 0) }
end;

function TEmployee.Add: IEmployee2;
Var
  AddO : TEmployee;
begin { Add }
  AuthoriseFunction(100, 'Add');

  AddO := TEmployee.Create(imAdd, FToolkit, FBtrIntf);
  AddO.InitNewRecord;

  Result := AddO;
end;

function TEmployee.Save: Integer;
Var
  SaveInfo  : TBtrieveSavePosType;
  SaveInfo2 : TBtrieveFileSavePos;
  BtrOp     : SmallInt;
begin
  AuthoriseFunction(102, 'Save');

  // Save current file positions in main files
  SaveInfo := SaveSystemFilePos ([]);

  If (FIntfType = imUpdate) Then Begin
    // Updating - Reposition on original Locked Stock item
    Result := PositionOnLock;
    BtrOp := B_Update;
  End { If (FIntfType = imUpdate) }
  Else Begin
    // Adding - no need to do anything
    Result := 0;
    BtrOp := B_Insert;
  End; { Else }

  If (Result = 0) Then Begin
    // Add/Update
    SaveExLocalPos(SaveInfo2);
    Result := Ex_StoreJobEmployee (@FEmployeeRec, SizeOf(FEmployeeRec), FIndex, BtrOp);
    RestoreExLocalPos(SaveInfo2);

    //PR: 18/02/2016 v2016 R1 ABSEXCH-16860 After successful save convert to clone object
    if Result = 0 then
      FIntfType := imClone;
  End; { If (Res = 0) }

  If (Result <> 0) Then
    LastErDesc := Ex_ErrorDescription (167, Result);

  // Restore original file positions
  RestoreSystemFilePos (SaveInfo);
end;

procedure TEmployee.Cancel;
begin
  AuthoriseFunction(103, 'Cancel');

  Unlock;
end;

procedure TEmployee.InitNewRecord;
begin
  FillChar(FEmployeeRec, SizeOf(FEmployeeRec), 0);
end;

Procedure TEmployee.LoadDetails (Const EmpDets : TBatchEmplRec; Const LockPos : LongInt);
begin
  FEmployeeRec := EmpDets;

  LockCount := 1;
  LockPosition := LockPos;
end;

function TEmployee.Get_emSelfBilling: WordBool;
begin
  Result := FEmployeeRec.SelfBill;
end;

procedure TEmployee.Set_emSelfBilling(Value: WordBool);
begin
  FEmployeeRec.SelfBill := Value;
end;

function TEmployee.Get_emGroupCertificate: WordBool;
begin
  Result := FEmployeeRec.GroupCert;
end;

procedure TEmployee.Set_emGroupCertificate(Value: WordBool);
begin
  FEmployeeRec.GroupCert := Value;
end;

function TEmployee.Get_emCertificateType: TEmployeeCertificateType;
begin
  Case FEmployeeRec.CertType of
      'N' :   Result := ecNA;
      '4'  :  Result := ecCIS4;
      '5'  :  Result := ecCIS5;
      '6'  :  Result := ecCIS6;
      '7'  :  Result := ecCIS4P;
      '8'  :  Result := ecCIS5P;
      else
        Result := 0;
  end;
end;

procedure TEmployee.Set_emCertificateType(Value: TEmployeeCertificateType);
begin
  with FEmployeeRec do
  Case Value of
      ecNA         :  CertType := 'N';
      ecCIS4       :  CertType := '4';
      ecCIS5       :  CertType := '5';
      ecCIS6       :  CertType := '6';
      ecCIS4P      :  CertType := '7';
      ecCIS5P      :  CertType := '8';
      else
        CertType := 'N';
  end;
end;

function TEmployee.Get_emUserField3: WideString;
begin
  Result := FEmployeeRec.UserDef3;
end;

procedure TEmployee.Set_emUserField3(const Value: WideString);
begin
  FEmployeeRec.UserDef3 := Value;
end;

function TEmployee.Get_emUserField4: WideString;
begin
  Result := FEmployeeRec.UserDef4;
end;

procedure TEmployee.Set_emUserField4(const Value: WideString);
begin
  FEmployeeRec.UserDef4 := Value;
end;

function TEmployee.Get_emNISerialNo: WideString;
begin
  Result := FEmployeeRec.ENINo;
end;

procedure TEmployee.Set_emNISerialNo(const Value: WideString);
begin
  FEmployeeRec.ENINo := Value;
end;

function TEmployee.Get_emLinks: ILinks;
begin
  if Not Assigned(FLinksO) then
  begin
    FLinksO := TLinks.Create(imGeneral, FBtrIntf, 'E', FEmployeeRec.EmpCode, 0);

    FLinksI := FLinksO;
  end;

  FLinksO.OwnerType := 'E';
  FLinksO.OwnerCode := FEmployeeRec.EmpCode;
  FLinksO.OwnerFolio := 0;

  Result := FLinksI;
end;

function TEmployee.Get_emLabourViaPL: WordBool;
begin
  Result := BoolToWordBool(FEmployeeRec.LabourPLOnly);
end;

procedure TEmployee.Set_emLabourViaPL(Value: WordBool);
begin
  FEmployeeRec.LabourPLOnly := WordBoolToBool(Value);
end;

function TEmployee.Get_KeyString2: WideString;
begin
  Result := Copy(FKeyString, 3, Length(FKeyString));
end;

function TEmployee.Get_emTimeRateRules: TTimeRateRulesType;
begin
  Result := FEmployeeRec.UseORate;
end;

procedure TEmployee.Set_emTimeRateRules(Value: TTimeRateRulesType);
begin
  if Value in [trGlobalOwnJob..trJobOnly] then
    FEmployeeRec.UseORate := Value
  else
    raise ERangeError.Create('Value out of range (' + IntToStr(Value) + ')');
end;



//IBrowseInfo
function TEmployee.Get_ibInterfaceMode: Integer;
begin
  Result := Ord(FIntfType);
end;


function TEmployee.Get_emTagged: WordBool;
begin
  Result := FEmployeeRec.Tagged;
end;

function TEmployee.Get_emUTRCode: WideString;
begin
  Result := FEmployeeRec.UTRCode;
end;

function TEmployee.Get_emVerificationNo: WideString;
begin
  Result := FEmployeeRec.VerificationNo;
end;

procedure TEmployee.Set_emTagged(Value: WordBool);
begin
  FEmployeeRec.Tagged := Value;
end;

procedure TEmployee.Set_emUTRCode(const Value: WideString);
begin
  FEmployeeRec.UTRCode := Value;
end;

procedure TEmployee.Set_emVerificationNo(const Value: WideString);
begin
  FEmployeeRec.VerificationNo := Value;
end;

function TEmployee.Get_emContractorType: TContractorType;
begin
  Result := FEmployeeRec.ContractorType;
end;

procedure TEmployee.Set_emContractorType(Value: TContractorType);
begin
  FEmployeeRec.ContractorType := Value;
end;

function TEmployee.Get_emEmailAddress: WideString;
begin
  Result := FEmployeeRec.emEmailAddress;
end;

procedure TEmployee.Set_emEmailAddress(const Value: WideString);
begin
  FEmployeeRec.emEmailAddress := Value;
end;

//AP 17/11/2017 ABSEXCH-19395 IEmployee7 methods
function TEmployee.Get_emStatus: TEmployeeStatusType;
begin
  Result := Ord(FEmployeeRec.emStatus);
end;

function TEmployee.Get_emAnonymisationStatus: TEntityAnonymisationStatusType;
begin
  Result := Ord(FEmployeeRec.emAnonymisationStatus);
end;

function TEmployee.Get_emAnonymisedDate: WideString;
begin
  Result := FEmployeeRec.emAnonymisedDate;
end;

function TEmployee.Get_emAnonymisedTime: WideString;
begin
  Result := FEmployeeRec.emAnonymisedTime;
end;

//AP : 19/10/2016 : ABSEXCH-11837 The index emIdxSupplier on the IEmployee interface is incorrect - it should be 2 rather than 1
function TEmployee.TranslateIndex(const IdxNo: SmallInt;
  const FromTLB: Boolean): SmallInt;
begin
  If FromTLB Then
  Begin
    // Converting a TLB Index number into an Enterprise File Index Number
    Case IdxNo Of
      emIdxCode     : Result := 0;
      emIdxSupplier : Result := 2;
      emIdxSurname  : Result := 1;
    Else
      Raise EInvalidIndex.Create ('Index ' + IntToStr(IdxNo) + ' is not valid in the Transaction object');
    End; { Case }
  End { If FromTLB  }
  Else
  Begin
    // Converting an Enterprise File Index Number into a TLB Index Number
    Case IdxNo Of
      0 : Result := emIdxCode;
      1 : Result := emIdxSurname;
      2 : Result := emIdxSupplier;
    Else
      Raise EInvalidIndex.Create ('The Transaction object is using an invalid index');
    End; { Case }
  End; { Else }
end;

//HV 20/06/2018 2018-R1.1 ABSEXCH-20851: Com Toolkit > Employee Status > The new Employee Status field should fully implement the Open/Close status changes as per HLD section 6.3.2 Close Employee Process
procedure TEmployee.Set_emStatus(Value: TEmployeeStatusType);
begin
  case Value of
    0 : FEmployeeRec.emStatus := emOpen;
    1 : FEmployeeRec.emStatus := emClosed;
  else
    raise EValidation.Create ('Invalid Employee Status (' + IntToStr(Value) + ')');
  end; { Case }
end;

end.

