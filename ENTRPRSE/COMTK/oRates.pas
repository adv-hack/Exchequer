unit oRates;

{ markd6 15:34 01/11/2001: Disabled Byte Alignment in Delphi 6.0 }
{$ALIGN 1}  { Variable Alignment Disabled }


interface

Uses Classes, Dialogs, Forms, SysUtils, Windows, ComObj, ActiveX,
     {$IFNDEF WANTEXE}Enterprise01_TLB{$ELSE}Enterprise04_TLB{$ENDIF}, oBtrieve, GlobVar, VarConst, VarCnst3, MiscFunc,
     BtrvU2, ExBTTH1U, GlobList;


type
  TTimeRates = class(TBtrieveFunctions, ITimeRates, ITimeRates2, IBrowseInfo)
  private
    FTimeRateRec : TBatchJobRateRec;

    FIntfType  : TInterfaceMode;

    FToolkit : TObject;

    FRecTypeCode : Char;//Global if created by JobCosting,
                        //Employee if cloned by employee

    FEmployeeCode : WideString;
    FJobCode : WideString;


  protected
    function  Get_trEmployeeCode: WideString; safecall;
    procedure Set_trEmployeeCode(const Value: WideString); safecall;
    function  Get_trRateCode: WideString; safecall;
    procedure Set_trRateCode(const Value: WideString); safecall;
    function  Get_trCostCurrency: Smallint; safecall;
    procedure Set_trCostCurrency(Value: Smallint); safecall;
    function  Get_trTimeCost: Double; safecall;
    procedure Set_trTimeCost(Value: Double); safecall;
    function  Get_trChargeCurrency: Smallint; safecall;
    procedure Set_trChargeCurrency(Value: Smallint); safecall;
    function  Get_trTimeCharge: Double; safecall;
    procedure Set_trTimeCharge(Value: Double); safecall;
    function  Get_trAnalysisCode: WideString; safecall;
    procedure Set_trAnalysisCode(const Value: WideString); safecall;
    function  Get_trPayrollCode: Integer; safecall;
    procedure Set_trPayrollCode(Value: Integer); safecall;
    function  Get_trDescription: WideString; safecall;
    procedure Set_trDescription(const Value: WideString); safecall;
    function  Get_trPayFactor: Smallint; safecall;
    procedure Set_trPayFactor(Value: Smallint); safecall;
    function  Get_trPayRate: Smallint; safecall;
    procedure Set_trPayRate(Value: Smallint); safecall;

    function  Clone: ITimeRates; safecall;

    //ITimerate2 methods
    function Update: ITimeRates2; safecall;
    function Add: ITimeRates2; safecall;
    function Save: Integer; safecall;
    procedure Cancel; safecall;

    //IBrowseInfo
    function Get_ibInterfaceMode: Integer; safecall;

    //Local methods
    Procedure LoadDetails (Const RateDets : TBatchJobRateRec; Const LockPos : LongInt);
    procedure InitNewRecord(const EmpCode : string; RecType : Char);
    function GetEmployeeCode : String;
    procedure SetEmployeeCode(Value : string);
    function GetJobCode : String;
    procedure SetJobCode(Value : string);

    Function  AuthoriseFunction (Const FuncNo     : Byte;
                                 Const MethodName : String;
                                 Const AccessType : Byte = 0) : Boolean; Override;
    Function  GetDataRecord (Const BtrOp : SmallInt; Const SearchKey : String = '') : Integer; Override;
    procedure InitObjects;
    procedure CopyDataRecord; override;
  public
    Constructor Create(Const IType     : TInterfaceMode;
                       Const Toolkit   : TObject;
                       Const BtrIntf   : TCtkTdPostExLocalPtr);
    Destructor Destroy; override;
    procedure CloneDetails(const RateDetails : TBatchJobRateRec);
    property EmployeeCode : String read GetEmployeeCode
                                   write SetEmployeeCode;
    property JobCode : String read GetJobCode
                                   write SetJobCode;
  end;

  Function CreateTTimeRates (Const Toolkit : TObject; Const ClientId : Integer) : TTimeRates;




implementation

uses
  ComServ, DllMiscU, DllErrU, BtKeys1U, EtStrU, DllJobU, oToolkit;

Function CreateTTimeRates (Const Toolkit : TObject; Const ClientId : Integer) : TTimeRates;
Var
  BtrIntf : TCtkTdPostExLocalPtr;
Begin { CreateTTimeRates }
  // Create common btrieve interface for objects
  New (BtrIntf, Create(ClientId));

  // Open files needed by object
  BtrIntf^.Open_System(JCtrlF, JCtrlF);

  // Create bas TAccount object
  Result := TTimeRates.Create(imGeneral, Toolkit, BtrIntf);

  if SQLBeingUsed then
    Result.SetFileNos([JCtrlF]);

End; { CreateTTimeRates }


Constructor TTimeRates.Create(Const IType     : TInterfaceMode;
                                Const Toolkit   : TObject;
                                Const BtrIntf   : TCtkTdPostExLocalPtr);
begin
  Inherited Create (ComServer.TypeLib, ITimeRates2, BtrIntf); //PR: 21/01/2011 ABSEXCH-10392

  // Initialise Btrieve Ancestor
  FFileNo := JCtrlF;

  FillChar(FTimeRateRec, SizeOf(FTimeRateRec), #0);

  InitObjects;
  FIntfType := IType;

  FToolkit := Toolkit;
  FEmployeeCode := '';



end;

Destructor TTimeRates.Destroy;
begin
  InitObjects;
  //Don't want to destroy the interface if it's shared with IEmployee (19) or with IJob (11)
  If (FIntfType = imGeneral) and (FBtrIntf.ExClientId.TaskID <> 19) and
                                 (FBtrIntf.ExClientId.TaskID <> 11) then
    Dispose (FBtrIntf, Destroy);

  inherited Destroy;
end;

procedure TTimeRates.InitObjects;
begin
  FToolkit := nil;
end;

function TTimeRates.Get_trEmployeeCode: WideString;
begin
  Result := FTimeRateRec.JEmpCode;
end;

procedure TTimeRates.Set_trEmployeeCode(const Value: WideString);
begin
  FTimeRateRec.JEmpCode := Value;
end;

function TTimeRates.Get_trRateCode: WideString;
begin
  Result := FTimeRateRec.JRateCode;
end;

procedure TTimeRates.Set_trRateCode(const Value: WideString);
begin
  FTimeRateRec.JRateCode := Value;
end;

function TTimeRates.Get_trCostCurrency: Smallint;
begin
  Result := FTimeRateRec.CostCurr;
end;

procedure TTimeRates.Set_trCostCurrency(Value: Smallint);
begin
  FTimeRateRec.CostCurr := Value;
end;

function TTimeRates.Get_trTimeCost: Double;
begin
  Result := FTimeRateRec.Cost;
end;

procedure TTimeRates.Set_trTimeCost(Value: Double);
begin
  FTimeRateRec.Cost := Value;
end;

function TTimeRates.Get_trChargeCurrency: Smallint;
begin
  Result := FTimeRateRec.ChargeCurr;
end;

procedure TTimeRates.Set_trChargeCurrency(Value: Smallint);
begin
  FTimeRateRec.ChargeCurr := Value;
end;

function TTimeRates.Get_trTimeCharge: Double;
begin
  Result := FTimeRateRec.ChargeRate;
end;

procedure TTimeRates.Set_trTimeCharge(Value: Double);
begin
  FTimeRateRec.ChargeRate := Value;
end;

function TTimeRates.Get_trAnalysisCode: WideString;
begin
  Result := FTimeRateRec.JAnalCode;
end;

procedure TTimeRates.Set_trAnalysisCode(const Value: WideString);
begin
  FTimeRateRec.JAnalCode := Value;
end;

function TTimeRates.Get_trPayrollCode: Integer;
begin
//  Result := FTimeRateRec.PayrollCode;
  Result := FTimeRateRec.PayRate;
end;

procedure TTimeRates.Set_trPayrollCode(Value: Integer);
begin
//  FTimeRateRec.PayRollCode := Value;
  FTimeRateRec.PayRate := Value;
end;

function TTimeRates.Get_trDescription: WideString;
begin
  Result := FTimeRateRec.JRateDesc;
end;

procedure TTimeRates.Set_trDescription(const Value: WideString);
begin
  FTimeRateRec.JRateDesc := Value;
end;

function  TTimeRates.Get_trPayFactor: Smallint;
begin
  Result := FTimeRateRec.PayFactor;
end;

procedure TTimeRates.Set_trPayFactor(Value: Smallint);
begin
  FTimeRateRec.PayFactor := Value;
end;

function  TTimeRates.Get_trPayRate: Smallint;
begin
  Result := FTimeRateRec.PayRate;
end;

procedure TTimeRates.Set_trPayRate(Value: Smallint);
begin
  FTimeRateRec.PayRate := Value;
end;


function TTimeRates.Clone: ITimeRates;
Var
  CloneO : TTimeRates;
  Rtype : Byte;
Begin { Clone }
  // Check Clone method is available
  AuthoriseFunction(104, 'Clone');

  Case FRecTypeCode of
    JBECode : RType := 0;
    JBPCode : RType := 1;
  end;


  CloneO := TTimeRates.Create(imClone, FToolkit, FBtrIntf);
  if Assigned(CloneO) then
  begin
    CloneO.CloneDetails(FTimeRateRec);
    CloneO.EmployeeCode := FEmployeeCode;
  end;
  Result := CloneO;
end;


Function  TTimeRates.AuthoriseFunction (Const FuncNo : Byte;
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

Function  TTimeRates.GetDataRecord (Const BtrOp : SmallInt; Const SearchKey : String = '') : Integer;
Var
  BtrOpCode, BtrOpCode2 : SmallInt;
  KeyS                  : Str255;
  Loop                  : Boolean;
Begin { GetDataRecord }
  Result := 0;
  LastErDesc := '';




  With FBtrIntf^ Do Begin
    // General index including CC, Dept, Notes, Matching, etc... records
    BtrOpCode := BtrOp;
    KeyS := SetKeyString(BtrOp, JBRCode + FRecTypeCode + FullJBCode(UpperCase(FEmployeeCode), 0, UpperCase(SearchKey)));

    Loop := True;
    Case BtrOp of
      // Moving forward through file
      B_GetGEq,
      B_GetGretr,
      B_GetNext    : BtrOpCode2 := B_GetNext;

      B_GetFirst   : Begin
                       {KeyS := JBRCode + FRecTypeCode + #0;}
                       BtrOpCode  := B_GetGEq;
                       BtrOpCode2 := B_GetNext;
                     End;

      // Moving backward through file
      B_GetLess,
      B_GetLessEq,
      B_GetPrev    : BtrOpCode2 := B_GetPrev;

      B_GetLast    : Begin
                       {KeyS := JBRCode + FRecTypeCode + #255;}
                       Keys := JBRCode + FRecTypeCode + FullJBCode(UpperCase(FEmployeeCode),
                                                0, UpperCase(#255));
                       BtrOpCode  := B_GetLessEq;
                       BtrOpCode2 := B_GetPrev;
                     End;

      // Looking for exact match - can't get that here so
      //go for greater or equal and only return 0 if we can match the code at {1} below.
      B_GetEq      : begin
                       BtrOPCode := B_GetGEq;
                       BtrOpCode2 := B_GetNext;
                       {Loop := False;}
                     end;
    Else
      Raise Exception.Create ('Invalid Btrieve Operation');
    End; { Case BtrOp}

    Repeat
      Result := LFind_Rec (BtrOpCode, FFileNo, FIndex, KeyS);

      BtrOpCode := BtrOpCode2;

      {PR 24/06/2008 - If we've passed the Prefix/SubType we want then drop out of loop
       to avoid reading remaining records in file - may improve SQL performance.}
      if (Result = 0) and ((LJobCtrl.RecPFix <> JBRCode) or (LJobCtrl.SubType <> FRecTypeCode)) then
        Result := 9;

    Until (Result <> 0) Or (Not Loop) Or ((LJobCtrl.RecPFix = JBRCode) And (LJobCtrl.SubType = FRecTypeCode));

    FKeyString := KeyS;

    If (Result = 0) Then Begin
      // check correct record type was returned
      If (LJobCtrl.RecPFix = JBRCode) And (LJobCtrl.SubType = FRecTypeCode) and
         (not(FRecTypeCode in [JBPCode, JBECode]) or (Trim(LJobCtrl.EmplPay.EmpCode) = Trim(FEmployeeCode))) and
       {1}((BtrOp <> B_GetEq) or
           (Trim(UpperCase(LJobCtrl.EmplPay.EStockCode)) = Trim(SearchKey)))  Then
      begin
        // Convert to Toolkit structure
        CopyDataRecord;
        
      end
      Else
      begin  //Need to return the appropriate result
        if BtrOp = B_GetEq then
          Result := 4
        else
          Result := 9;
      end;
    End; { If (Result = 0) }
  End; { With FBtrIntf^ }

  If (Result <> 0) Then
    LastErDesc := Ex_ErrorDescription (64, Result);

End; { GetDataRecord }

procedure TTimeRates.CopyDataRecord;
begin
  CopyExJRateToTKJRate (FBtrIntf^.LJobCtrl^.EmplPay, FTimeRateRec);
  //PR: 20/11/2009 RecType wasn't being set,  so update failed
  FTimeRateRec.RecType := FBtrIntf^.LJobCtrl^.SubType;
  FTimeRateRec.OriginalCostCurr := FTimeRateRec.CostCurr;
end;


procedure TTimeRates.CloneDetails(const RateDetails : TBatchJobRateRec);
begin
  FTimeRateRec := RateDetails;
end;

function TTimeRates.GetEmployeeCode : String;
begin
  Result := FEmployeeCode;
end;

procedure TTimeRates.SetEmployeeCode(Value : string);
//set Employee code & record subtype
begin
  if Value = FullNomKey(-1) then
    FRecTypeCode := JBECode
  else
    FRecTypeCode := JBPCode;

  FEmployeeCode := Value;
end;

function TTimeRates.Update: ITimeRates2;
Var
  UpdateO : TTimeRates;
  FuncRes  : LongInt;
begin { Update }
  Result := Nil;
  AuthoriseFunction(101, 'Update');

  // Lock Current Record
  FuncRes := Lock;

  If (FuncRes = 0) Then Begin
    // Create an update object
    UpdateO := TTimeRates.Create(imUpdate, FToolkit, FBtrIntf);

    // Pass current job Record and Locking Details into sub-object
    UpdateO.LoadDetails(FTimeRateRec, LockPosition);
    LockCount := 0;
    LockPosition := 0;

    Result := UpdateO;
  End; { If (FuncRes = 0) }
end;


function TTimeRates.Add: ITimeRates2;
Var
  AddO : TTimeRates;
begin { Add }
  AuthoriseFunction(100, 'Add');

  AddO := TTimeRates.Create(imAdd, FToolkit, FBtrIntf);
  AddO.InitNewRecord(FEmployeeCode, FRecTypeCode);

  Result := AddO;
end;


function TTimeRates.Save: Integer;
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
    FTimeRateRec.RecType := FRecTypeCode;
  End; { Else }

  If (Result = 0) Then Begin
    // Add/Update
    SaveExLocalPos(SaveInfo2);
    Result := Ex_StoreJobTimeRate (@FTimeRateRec, SizeOf(FTimeRateRec), FIndex, BtrOp);
    RestoreExLocalPos(SaveInfo2);

    //PR: 18/02/2016 v2016 R1 ABSEXCH-16860 After successful save convert to clone object
    if Result = 0 then
      FIntfType := imClone;
  End; { If (Res = 0) }

  If (Result <> 0) Then
    LastErDesc := Ex_ErrorDescription (170, Result);

  // Restore original file positions
  RestoreSystemFilePos (SaveInfo);
end;

procedure TTimeRates.Cancel;
begin
  AuthoriseFunction(103, 'Cancel');

  Unlock;
end;

procedure TTimeRates.InitNewRecord(const EmpCode : string; RecType : Char);
var
  Len : Byte;
begin
  FRecTypeCode := RecType;
  if (FRecTypeCode = JBECode) then
    Len := JobCodeLen
  else
    Len := 6; //Employee
  FillChar(FTimeRateRec, SizeOf(FTimeRateRec), 0);
  FTimeRateRec.JEmpCode := LJVar(EmpCode, Len);
end;

Procedure TTimeRates.LoadDetails (Const RateDets : TBatchJobRateRec; Const LockPos : LongInt);
begin
  FTimeRateRec := RateDets;

  LockCount := 1;
  LockPosition := LockPos;
end;

function TTimeRates.GetJobCode : String;
begin
  Result := FEmployeeCode;
end;

procedure TTimeRates.SetJobCode(Value : string);
begin
  FRecTypeCode := JBECode;
  FEmployeeCode := Value;
end;



//IBrowseInfo
function TTimeRates.Get_ibInterfaceMode: Integer;
begin
  Result := Ord(FIntfType);
end;







end.
