unit oJobRet;
{ markd6 15:34 01/11/2001: Disabled Byte Alignment in Delphi 6.0 }
{$ALIGN 1}  { Variable Alignment Disabled }


interface

Uses Classes, Dialogs, Forms, SysUtils, Windows, ComObj, ActiveX,
     {$IFNDEF WANTEXE}Enterprise01_TLB{$ELSE}Enterprise04_TLB{$ENDIF},
     oBtrieve, GlobVar, VarConst, VarCnst3, MiscFunc,
     BtrvU2, ExBTTH1U, GlobList;

const
  spSales = 'C';
  spPurchase = 'S';


type
  TJobRetention = class(TBtrieveFunctions, IJobRetention, IJobRetention2, IBrowseInfo)
  private
    FRetRec : JobRetType;
    FSalesPurchaseType : Char;
    FIntfType  : TInterfaceMode;
    FParentJobCode : string;
    FToolkit : TObject;
    procedure SetRecordIndexFields;
    function ValidateJobRetRecord : integer;
    function CreateCreditNote : integer;
    function UpdateCreditNote(const NewDate : string) : Integer;
  protected
    function Get_jrtAnalysisCode: WideString; safecall;
    procedure Set_jrtAnalysisCode(const Value: WideString); safecall;
    function Get_jrtOriginalCurrency: Integer; safecall;
    function Get_jrtYear: Integer; safecall;
    procedure Set_jrtYear(Value: Integer); safecall;
    function Get_jrtPeriod: Integer; safecall;
    procedure Set_jrtPeriod(Value: Integer); safecall;
    function Get_jrtPosted: WordBool; safecall;
    function Get_jrtPercent: Double; safecall;
    procedure Set_jrtPercent(Value: Double); safecall;
    function Get_jrtCurrency: Integer; safecall;
    procedure Set_jrtCurrency(Value: Integer); safecall;
    function Get_jrtValue: Double; safecall;
    procedure Set_jrtValue(Value: Double); safecall;
    function Get_jrtJobCode: WideString; safecall;
    procedure Set_jrtJobCode(const Value: WideString); safecall;
    function Get_jrtCreditDoc: WideString; safecall;
    function Get_jrtExpiryDate: WideString; safecall;
    procedure Set_jrtExpiryDate(const Value: WideString); safecall;
    function Get_jrtInvoiced: WordBool; safecall;
    procedure Set_jrtInvoiced(Value: WordBool); safecall;
    function Get_jrtAcCode: WideString; safecall;
    procedure Set_jrtAcCode(const Value: WideString); safecall;
    function Get_jrtEntryDate: WideString; safecall;
    procedure Set_jrtEntryDate(const Value: WideString); safecall;
    function Get_jrtCostCentre: WideString; safecall;
    procedure Set_jrtCostCentre(const Value: WideString); safecall;
    function Get_jrtDepartment: WideString; safecall;
    procedure Set_jrtDepartment(const Value: WideString); safecall;
    function Get_jrtDefVatCode: WideString; safecall;
    procedure Set_jrtDefVatCode(const Value: WideString); safecall;
    function Get_jrtTransaction: WideString; safecall;
    procedure Set_jrtTransaction(const Value: WideString); safecall;

    function Get_Index: TJobRetentionIndexType; safecall;
    procedure Set_Index(Value: TJobRetentionIndexType); safecall;

    procedure ImportDefaults; safecall;
    function Get_jrtTransactionI: ITransaction; safecall;
    function Get_jrtAcCodeI: IAccount; safecall;
    function Get_jrtCreditDocI: ITransaction; safecall;

    function Get_jrtCISTax: Double; safecall;
    function Get_jrtCISGross: Double; safecall;
    function Get_jrtCISEmployee: WideString; safecall;

    function Get_jrtApplicationMode: TRetentionAppType; safecall;
    procedure Set_jrtApplicationMode(Value: TRetentionAppType); safecall;


    function BuildInvoicedIndex(Invoiced: WordBool; const Date: WideString): WideString; safecall;
    function BuildDateIndex(const Date: WideString): WideString; safecall;

    //IBrowseInfo
    function Get_ibInterfaceMode: Integer; safecall;


    Function AuthoriseFunction (Const FuncNo     : Byte;
                                Const MethodName : String;
                                Const AccessType : Byte = 0) : Boolean; Override;
    Procedure CopyDataRecord; Override;
    Function GetDataRecord (Const BtrOp : SmallInt; Const SearchKey : String = '') : Integer; Override;

    // Local methods
    Procedure CloneDetails (Const RetDets : JobRetType);

    function Add: IJobRetention; safecall;
    function Clone: IJobRetention; safecall;
    function Save: Integer; safecall;
    function Delete: Integer; safecall;
    function UpdateExpiryDate(const NewDate: WideString): Integer; safecall;
  public
    Constructor Create(Const IType     : TInterfaceMode;
                       const Toolkit   : TObject;
                       Const BtrIntf   : TCtkTdPostExLocalPtr;
                       const SalePurch : Char;
                       const JobCode   : string);
    destructor Destroy; override;
  end;

  function CreateTJobRetention(Const Toolkit : TObject; Const ClientId : Integer;
                               const SalePurch : Char; const JobCode : string) : TJobRetention;


implementation

uses
  BtKeys1U, ComServ, ETDateU, DllTh_Up, oToolkit, ComnUnit, EtMiscU, VarRec2U, Bts1, CurrncyU, MiscU,
  BtSupU1, DllErrU;

function CreateTJobRetention(Const Toolkit : TObject; Const ClientId : Integer;
                             const SalePurch : Char; const JobCode : string) : TJobRetention;
Var
  BtrIntf : TCtkTdPostExLocalPtr;
Begin { CreateTAccount }
  // Create common btrieve interface for objects
  New (BtrIntf, Create(ClientId));

  // Open files needed by object
  BtrIntf^.Open_System(JDetlF, JDetlF);
  BtrIntf^.Open_System(CustF, CustF);
  BtrIntf^.Open_System(InvF, InvF);
  BtrIntf^.Open_System(IDetailF, IDetailF);
  BtrIntf^.Open_System(JobF, JobF);
  BtrIntf^.Open_System(JMiscF, JMiscF);
  BtrIntf^.Open_System(PwrdF, PwrdF);

  Result := TJobRetention.Create(imGeneral, Toolkit, BtrIntf, SalePurch, JobCode);

  if SQLBeingUsed then
    Result.SetFileNos([CustF, InvF, IDetailF, PwrdF, JDetlF, JMiscF, JobF]);

End; { CreateTAccount }



Constructor TJobRetention.Create(Const IType     : TInterfaceMode;
                                 const Toolkit   : TObject;
                                 Const BtrIntf   : TCtkTdPostExLocalPtr;
                                 const SalePurch : Char;
                                 const JobCode : string);
begin
  Inherited Create (ComServer.TypeLib, IJobRetention2, BtrIntf); //PR: 21/01/2011 ABSEXCH-10392

  // Initialise Btrieve Ancestor
  FBtrIntf := BtrIntf;
  FFileNo := JDetlF;
  FIntfType := IType;

  // Initialise variables
  FillChar(FRetRec, SizeOf(FRetRec), 0);

  FToolkit := Toolkit;
  FSalesPurchaseType := SalePurch;
  FParentJobCode := JobCode;

  if SalePurch = spSales then
    FObjectID := tkoSalesRet
  else
    FObjectID := tkoPurchRet;
  FSQLParentKey := JobCode;
end;

destructor TJobRetention.Destroy;
begin

  If (FIntfType = imGeneral) Then
    Dispose (FBtrIntf, Destroy);

  inherited Destroy;

end;

function TJobRetention.Get_jrtAnalysisCode: WideString;
begin
  Result := FRetRec.AnalCode;
end;

procedure TJobRetention.Set_jrtAnalysisCode(const Value: WideString);
begin
  FRetRec.AnalCode := FullJACode(Value);
end;

function TJobRetention.Get_jrtOriginalCurrency: Integer;
begin
  Result := FRetRec.OrgCurr;
end;


function TJobRetention.Get_jrtYear: Integer;
begin
  Result := FRetRec.RetYr;
end;

procedure TJobRetention.Set_jrtYear(Value: Integer);
begin
  FRetRec.RetYr := Value;
end;

function TJobRetention.Get_jrtPeriod: Integer;
begin
  Result := FRetRec.RetPr;
end;

procedure TJobRetention.Set_jrtPeriod(Value: Integer);
begin
  FRetRec.RetPr := Value;
end;

function TJobRetention.Get_jrtPosted: WordBool;
begin
  Result := BoolToWordBool(FRetRec.Posted);
end;

function TJobRetention.Get_jrtPercent: Double;
begin
  Result := FRetRec.RetDisc;
end;

procedure TJobRetention.Set_jrtPercent(Value: Double);
begin
  FRetRec.RetDisc := Value;
end;

function TJobRetention.Get_jrtCurrency: Integer;
begin
  Result := FRetRec.RetCurr;
end;

procedure TJobRetention.Set_jrtCurrency(Value: Integer);
begin
  FRetRec.RetCurr := Value;
end;

function TJobRetention.Get_jrtValue: Double;
begin
  Result := FRetRec.RetValue;
end;

procedure TJobRetention.Set_jrtValue(Value: Double);
begin
  FRetRec.RetValue := Value;
end;

function TJobRetention.Get_jrtJobCode: WideString;
begin
  Result := FRetRec.JobCode;
end;

procedure TJobRetention.Set_jrtJobCode(const Value: WideString);
begin
  FRetRec.JobCode := FullJobCode(Value);
end;

function TJobRetention.Get_jrtCreditDoc: WideString;
begin
  Result := FRetRec.RetCrDoc;
end;

function TJobRetention.Get_jrtExpiryDate: WideString;
begin
  Result := FRetRec.RetDate;
end;

procedure TJobRetention.Set_jrtExpiryDate(const Value: WideString);
begin
  FRetRec.RetDate := Value
end;

function TJobRetention.Get_jrtInvoiced: WordBool;
begin
  Result := BoolToWordBool(FRetRec.Invoiced);
end;


procedure TJobRetention.Set_jrtInvoiced(Value: WordBool);
begin
  FRetRec.Invoiced := WordBoolToBool(Value);
end;

function TJobRetention.Get_jrtAcCode: WideString;
begin
  Result := FRetRec.RetCustCode;
end;

procedure TJobRetention.Set_jrtAcCode(const Value: WideString);
begin
  FRetRec.RetCustCode := Value;
end;

function TJobRetention.Get_jrtEntryDate: WideString;
begin
  Result := FRetRec.OrigDate;
end;

procedure TJobRetention.Set_jrtEntryDate(const Value: WideString);
begin
  FRetRec.OrigDate := Value
end;

function TJobRetention.Get_jrtCostCentre: WideString;
begin
  Result := FRetRec.RetCCDep[True];
end;

procedure TJobRetention.Set_jrtCostCentre(const Value: WideString);
begin
  FRetRec.RetCCDep[True] := Value;
end;

function TJobRetention.Get_jrtDepartment: WideString;
begin
  Result := FRetRec.RetCCDep[False];
end;

procedure TJobRetention.Set_jrtDepartment(const Value: WideString);
begin
  FRetRec.RetCCDep[False] := Value;
end;

function TJobRetention.Get_jrtDefVatCode: WideString;
begin
  Result := FRetRec.DefVATCode;
end;

procedure TJobRetention.Set_jrtDefVatCode(const Value: WideString);
begin
  if Length(Value) > 0 then
    FRetRec.DefVATCode := ExtractChar(Value, ' ');
end;

function TJobRetention.Add: IJobRetention;
var
  JobRetO : TJobRetention;
begin
  AuthoriseFunction(100, 'Add');

  JobRetO := TJobRetention.Create(imAdd, FToolkit, FBtrIntf, FSalesPurchaseType, FParentJobCode);

  Result := JobRetO;
end;

function TJobRetention.Clone: IJobRetention;
var
  TempO : TJobRetention;
begin
  AuthoriseFunction(104, 'Clone');
  TempO := TJobRetention.Create(imClone, FToolkit, FBtrIntf, FSalesPurchaseType, FParentJobCode);
  TempO.CloneDetails(FRetRec);

  Result := TempO;
end;

function TJobRetention.Save: Integer;
begin
  AuthoriseFunction(102, 'Save');

  Result := ValidateJobRetRecord;

  if Result = 0 then
  begin
    SetRecordIndexFields;

    Result := CreateCreditNote;

    if Result = 0 then
    begin
      FBtrIntf^.LJobDetl.RecPfix := JARCode;
      FBtrIntf^.LJobDetl.SubType := JBPCode;
      Move(FRetRec, FBtrIntf^.LJobDetl.JobReten, SizeOf(FRetRec));
      if FIntfType = imGeneral then
        Result := FBtrIntf^.LPut_Rec(FFileNo, FIndex)
      else
        Result := FBtrIntf^.LAdd_Rec(FFileNo, FIndex);

      //PR: 18/02/2016 v2016 R1 ABSEXCH-16860 After successful save convert to clone object
      if Result = 0 then
        FIntfType := imClone;
    end;

  end;

  If (Result <> 0) Then
    LastErDesc := Ex_ErrorDescription (601, Result);
end;

function TJobRetention.Delete: Integer;
begin
  AuthoriseFunction(106, 'Delete');
  Result := FBtrIntf^.LDelete_Rec(FFileNo, FIndex);
end;

function TJobRetention.UpdateExpiryDate(const NewDate: WideString): Integer;
var
  Res : integer;
begin
  AuthoriseFunction(105, 'UpdateExpiryDate');
  if ValidDate(NewDate) then
  begin
    Result := LockCID;

    if Result = 0 then
    begin
      FRetRec.RetDate := NewDate;
      FBtrIntf^.LJobDetl.JobReten.RetDate := NewDate;
      Result := FBtrIntf^.LPut_Rec(FFileNo, FIndex);
    end;
  end
  else
    Result := 30000;
end;

Function TJobRetention.AuthoriseFunction (Const FuncNo     : Byte;
                                          Const MethodName : String;
                                          Const AccessType : Byte = 0) : Boolean;
begin
  Result := False;
  Case FuncNo Of
    //Btrieve funcs
    1..99     : Result := (FIntfType = imGeneral);
    // .Add method
    100       : Result := (FIntfType = imGeneral);
    // .Save method
    102       : Result := (FIntfType = imAdd);
    // .Clone method
    104       : Result := (FIntfType = imGeneral);
    // .UpdateExpiryDate method
    105       : Result := (FIntfType = imGeneral);
    // .Delete method
    106       : Result := (FIntfType = imGeneral);
  end;
end;

Procedure TJobRetention.CopyDataRecord;
begin
  Move(FBtrIntf^.LJobDetl.JobReten, FRetRec, SizeOf(FRetRec));
end;

Function TJobRetention.GetDataRecord (Const BtrOp : SmallInt; Const SearchKey : String = '') : Integer;
Var
  BtrOpCode, BtrOpCode2 : SmallInt;
  KeyS                  : Str255;
  Loop                  : Boolean;
Begin { GetDataRecord }
  Result := 0;
  LastErDesc := '';
  BtrOpCode2 := 0;
  With FBtrIntf^ Do Begin
    BtrOpCode := BtrOp;

    if FIndex = jrtIdxInvoiced then
      KeyS := SetKeyString(BtrOp, JARCode + JBPCode + FullJobCode(FParentJobCode) + FSalesPurchaseType + SearchKey)
    else
      KeyS := SetKeyString(BtrOp, JARCode + JBPCode + FSalesPurchaseType + SearchKey + FullJobCode(FParentJobCode));

    Loop := True;
    Case BtrOp of
      // Moving forward through file
      B_GetGEq,
      B_GetGretr,
      B_GetNext    : BtrOpCode2 := B_GetNext;

      B_GetFirst   : Begin
                       if FIndex = jrtIdxInvoiced then
                         KeyS := JARCode + JBPCode + FullJobCode(FParentJobCode) + FSalesPurchaseType + #0
                       else
                         KeyS := JARCode + JBPCode + FSalesPurchaseType + #0;
                       BtrOpCode  := B_GetGEq;
                       BtrOpCode2 := B_GetNext;
                     End;

      // Moving backward through file
      B_GetLess,
      B_GetLessEq,
      B_GetPrev    : BtrOpCode2 := B_GetPrev;

      B_GetLast    : Begin
                       if FIndex = jrtIdxInvoiced then
                         KeyS := JARCode + JBPCode + FullJobCode(FParentJobCode) + FSalesPurchaseType + #255
                       else
                         KeyS := JARCode + JBPCode + FSalesPurchaseType + #255;
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

    Until (Result <> 0) Or (Not Loop) Or ((LJobDetl.RecPFix = JARCode) And (LJobDetl.SubType = JBPCode));



    If (Result = 0) Then Begin
      // check correct record type was returned
      If (LJobDetl.RecPFix = JARCode) And (LJobDetl.SubType = JBPCode) and
         (LJobDetl.JobReten.AccType = FSalesPurchaseType) and
         ((Trim(LJobDetl.JobReten.JobCode) = Trim(FParentJobCode)) or (FParentJobCode = ''))  Then
      begin
        // Convert to Toolkit structure
        CopyDataRecord;
        FKeyString := KeyS;
      end
      Else
      //AP : 3/11/2016 : ABSEXCH-16305 GetNext returning Error 4 on Customer Object
      Begin
        If BtrOp = B_GetEq Then
          Result := 4
        else
          Result := 9;
      End;
    End; { If (Result = 0) }
  End; { With FBtrIntf^ }

{  If (Result <> 0) Then
    LastErDesc := Ex_ErrorDescription (63, Result);}
End; { GetDataRecord }

Procedure TJobRetention.CloneDetails (Const RetDets : JobRetType);
begin
  Move(RetDets, FRetRec, SizeOf(FRetRec));
end;

function TJobRetention.Get_Index: TJobRetentionIndexType;
begin
  Result := Inherited Get_Index;
end;

procedure TJobRetention.Set_Index(Value: TJobRetentionIndexType);
begin
  inherited Set_Index(Value);
end;

function TJobRetention.Get_jrtTransaction: WideString; safecall;
begin
  Result := FRetRec.RetDoc;
end;

procedure TJobRetention.Set_jrtTransaction(const Value: WideString); safecall;
begin
  FRetRec.RetDoc := Value;
end;


function TJobRetention.BuildInvoicedIndex(Invoiced: WordBool; const Date: WideString): WideString;
var
  TempBool : Boolean;
begin
  TempBool := WordBoolToBool(Invoiced);
  Result := Char(Ord(TempBool)) + Date;
{  if FParentJobCode = '' then
    Result := FullJobCode(JobCode) + Result;}
end;

function TJobRetention.BuildDateIndex(const Date: WideString): WideString;
begin
  Result := Date;
{  if FParentJobCode = '' then
    Result := Result + FullJobCode(JobCode);}
end;

procedure TJobRetention.SetRecordIndexFields;
//Validation has been done by this point
begin
  FRetRec.AccType := FSalesPurchaseType;
  FRetRec.RetenCode := FRetRec.JobCode + FSalesPurchaseType +
                         Char(Ord(FRetRec.Invoiced)) + FRetRec.RetDate;
  FRetRec.InvoiceKey := FSalesPurchaseType + FRetRec.RetDate + FRetRec.JobCode;
end;

function TJobRetention.ValidateJobRetRecord : integer;
var
  Vat : Char;
  StatCheck : Boolean;
  TestVal : Double;
  Decs : integer;
begin
  Result := 0;

  if FParentJobCode <> '' then
    FRetRec.JobCode := FullJobCode(FParentJobCode);

  if (FRetRec.JobCode = '') or not FBtrIntf^.LCheckExsists(FullJobCode(FRetRec.JobCode), JobF, 0) then
    Result := 30000; //Invalid Job Code

  if Result = 0 then
  begin
    if (FRetRec.AnalCode = '') or not FBtrIntf^.LCheckExsists(JARCode + JAACode + FullJACode(FRetRec.AnalCode), JMiscF, 0) then
      Result := 30001; //Invalid Analysis Code
  end;


  if Result = 0 then
  begin
    if not (FRetRec.DefVATCode in VatSet) then
    begin
      Vat := ExtractChar(TToolkit(FToolkit).ConfigI.DefaultVatCode, #0);

      if (Vat in VatSet) then
        FRetRec.DefVATCode := Vat
      else
        Result := 30003; //Invalid VAT Code
    end;
  end;

  if (Result = 0) and (Trim(FRetRec.RetDoc) <> '') then
  begin
    StatCheck := (FRetRec.RetDoc <> '') and FBtrIntf^.LCheckRecExsists(FullOurRefKey(FRetRec.RetDoc), InvF, InvOurRefK);

    if StatCheck then
    begin
      if FSalesPurchaseType = 'S' then //supplier
        StatCheck := FBtrIntf^.LInv.InvDocHed in [PIN, PPY, PCR]
      else
        StatCheck := FBtrIntf^.LInv.InvDocHed in [SIN, SRC, SCR];

      if StatCheck then
        FRetRec.OrgCurr := FBtrIntf^.LInv.Currency
      else
        Result := 30005; //Invalid doc type
    end
    else
      Result := 30004; //invalid document
  end;

  if Result = 0 then
  begin
    if Trim(FRetRec.RetCustCode) = '' then
      FRetRec.RetCustCode := FBtrIntf^.LInv.CustCode;

    if (FRetRec.RetCustCode = '') or not FBtrIntf^.LCheckExsists(FullCustCode(FRetRec.RetCustCode), CustF, 0) then
      Result := 30002; //Invalid Account Code

    if Result = 0 then
    begin
      if Trim(FRetRec.RetCustCode) <> Trim(FBtrIntf^.LInv.CustCode) then
        Result := 30015;
    end;
  end;


  if Result = 0 then
  begin
    if not ValidDate(FRetRec.OrigDate) then
      Result := 30006;
  end;

  if Result = 0 then
  begin
    if not ValidDate(FRetRec.RetDate) then
      Result := 30007;
  end;

  if Result = 0 then
  begin
    if FRetRec.OrigDate > FRetRec.RetDate then
      Result := 30008;
  end;

  if Result = 0 then
  begin
    if ExSyss.AutoSetPr then
      SimpleDate2Pr(FRetRec.OrigDate, FRetRec.RetPr, FRetRec.RetYr);

    StatCheck := (FRetRec.RetPr >= 1) and (FRetRec.RetPr <= Syss.PrInYr);
    if StatCheck then
    begin
      if FRetRec.RetYr = 0 then
        Result := 30010; // Invalid year
    end
    else
      Result := 30009; //Invalid period
  end;

  if Result = 0 then
  begin
    If (ExSyss.MCMode) then
    begin
      StatCheck := ((FRetRec.RetCurr >= 1) and (FRetRec.RetCurr <= CurrencyType));
      {* 18.08.99 - Added to use Default Currency *}
      If (Not StatCheck) then
      begin
        FRetRec.RetCurr := ExSyss.DefCur;
        StatCheck := ((FRetRec.RetCurr >= 1) and (FRetRec.RetCurr <= CurrencyType));
      end;
    end
    else
    begin
      StatCheck := True;
      FRetRec.RetCurr := 0;
    end;

    if not StatCheck then
      Result := 30011; //Invalid retention currency
  end;

  if (Result = 0) and Syss.UseCCDep then
  begin
    if (FRetRec.RetCCDep[False] = '') or not FBtrIntf^.LCheckExsists(CostCCode+CSubCode[False]+FRetRec.RetCCDep[False], PwrdF, PWK) then
      Result := 30012; //Invalid Department

    if Result = 0 then
    begin
      if (FRetRec.RetCCDep[True] = '') or not FBtrIntf^.LCheckExsists(CostCCode+CSubCode[True]+FRetRec.RetCCDep[True], PwrdF, PWK) then
        Result := 30013; //Invalid CostCentre
    end;
  end;

  if (Result = 0) and (FRetRec.RetDisc <> 0) then
  begin
    if FSalesPurchaseType = 'S' then
      Decs := Syss.NoCosDec
    else
      Decs := Syss.NoNetDec;

    TestVal := TToolkit(FToolkit).FuncsI.entConvertAmount(FBtrIntf^.LInv.InvNetVal, FBtrIntf^.LInv.Currency, FRetRec.RetCurr, 0);

    TestVal := Round_Up(((TestVal * FRetRec.RetDisc) / 100), Decs);

    if FRetRec.RetValue = 0 then
      FRetRec.RetValue := TestVal
    else
    begin
      if Round_Up(FRetRec.RetValue, Decs) <> TestVal then
        Result := 30014; //Retention percent and value don't agree
    end;
  end;

{  if (Result = 0) and (FRetRec.RetValue = 0) then
    Result := 30016; //Retention has no value      }

end;

function TJobRetention.CreateCreditNote : integer;
var
  KeyS : Str255;
  Res : SmallInt;
  i : integer;
begin
  with FBtrIntf^ do
  begin
    FillChar(LInv, SizeOf(LInv), 0);
    FillChar(LID, SizeOf(LID), 0);

    if FSalesPurchaseType = 'S' then
      LInv.InvDocHed := PCR
    else
      LInv.InvDocHed := SCR;

    SetNextDocNos(LInv, True, True);
    FRetRec.RetCrDoc := LInv.OurRef;

    LInv.Currency := FRetRec.RetCurr;
    LInv.AcYr := FRetRec.RetYr;
    LInv.AcPr := FRetRec.RetPr;
    LInv.NomAuto := True;

    LInv.DueDate := FRetRec.RetDate;
    LInv.TransDate := FRetRec.OrigDate;
    LInv.CustCode := FRetRec.RetCustCode;
    LInv.CustSupp := FSalesPurchaseType;
    LInv.YourRef := FRetRec.RetDoc;

    LInv.DJobCode := FRetRec.JobCode;
    LInv.DJobAnal := FRetRec.AnalCode;

    LInv.InvNetVal := FRetRec.RetValue;
    LInv.OrigRates[False] := TToolkit(FToolkit).SystemSetupI.ssCurrency[FRetRec.RetCurr].scCompanyRate;
    LInv.OrigRates[True] := TToolkit(FToolkit).SystemSetupI.ssCurrency[FRetRec.RetCurr].scDailyRate;

    LInv.CXRate[True] := LInv.OrigRates[True];

    LInv.VatCRate[False] := TToolkit(FToolkit).SystemSetupI.ssCurrency[Syss.VATCurr].scCompanyRate;
    LInv.VatCRate[True] := TToolkit(FToolkit).SystemSetupI.ssCurrency[Syss.VATCurr].scDailyRate;

    LInv.ILineCount := 3;
    LInv.NLineCount := 1;



    //============= Both lines ================
    LID.FolioRef := LInv.FolioNum;

    LID.Currency := LInv.Currency;
    LID.PYr := LInv.AcYr;
    LID.PPr := LInv.AcPr;

    LID.CCDep := LInv.FRCCDep;
    LID.JobCode := LInv.DJobCode;
    LID.AnalCode := LInv.DJobAnal;

    LID.LineType := StkLineType[LInv.InvDocHed];
    LID.Payment := DocPayType[LInv.InvDocHed];

    LID.CXRate := LInv.OrigRates;
    LID.CustCode := LInv.CustCode;


    //============ Line 1 ================
    LID.LineNo := 1;
    LID.AbsLineNo := 1;
    LID.Desc := 'Retention Credit. Expires '+PoutDate(FRetRec.RetDate);

    Result := LAdd_Rec(IDetailF, 0);

    if Result = 0 then
    begin
      //============ Line 2 ================
      LID.LineNo := 2;
      LID.AbsLineNo := 2;
      LID.Desc := 'for ' + FRetRec.RetDoc;
      LID.Qty := 1.0;
      LID.QtyMul := 1.0;
      LID.NetValue := FRetRec.RetValue;

      LID.VATCode := FRetRec.DefVATCode;
      CalcVAT(LID, 0);
      LInv.InvVatAnal[GetVATNo(LID.VATCode,#0)] := LID.VAT;
      LInv.InvVat := LID.VAT;

      LInv.CurrSettled := LInv.InvNetVal;
      LInv.Settled := ConvCurrITotal(LInv, True, False, True);

      Result := LAdd_Rec(IDetailF, IDFolioK);

      if Result = 0 then
      begin
        Result := LAdd_Rec(InvF, InvOurRefK);

        if Result <> 0 then
        begin
          //Delete lines 1 & 2
          for i := 1 to 2 do
          begin
            KeyS := FullRunNoKey(LInv.FolioNum, IDetailF);

            Res := LFind_Rec(B_GetEq, IDetailF, IDFolioK, KeyS);

            if (Res = 0) and (LID.FolioRef = LInv.FolioNum) then
              LDelete_Rec(IDetailF, IDFolioK);
          end;
        end;

      end
      else  //Delete line 1
        LDelete_Rec(IdetailF, IDFolioK);


    end;


  end;
end;

function TJobRetention.UpdateCreditNote(const NewDate : string) : Integer;
Var
  KeyS    :  Str255;
  LOk,
  Locked  :  Boolean;
  FNum, FNum2 : integer;
  KeyPath, KeyPath2 : integer;

Begin

  With FBtrIntf^ do
  Begin

    FNum := InvF;
    KeyPath := InvOurRefK;

    FNum2 := IDetailF;
    KeyPath2 := IDFolioK;

    Locked:=BOff;

    KeyS:=FRetRec.RetCrDoc;

    Result:=Find_Rec(B_GetEq,F[Fnum],Fnum,LRecPtr[Fnum]^,KeyPath,KeyS);

    If (Result = 0) then
    Begin

      LOk:=LGetMultiRec(B_GetDirect,B_MultLock,KeyS,KeyPAth,Fnum,BOn,Locked);


      If (LOk) and (Locked) then
      With LInv do
      Begin
        KeyS:=FullRunNoKey(FolioNum,1);

        DueDate:=NewDate;

        Result:=Find_Rec(B_GetEq,F[Fnum2],Fnum2,LRecPtr[Fnum2]^,KeyPath2,KeyS);

        If (Result = 0) then
        Begin
          LId.Desc:='Retention Credit. Expires '+PoutDate(DueDate);

          Result:=Put_Rec(F[Fnum2],Fnum2,LRecPtr[Fnum2]^,KeyPath2);

        end;

        Result:=Put_Rec(F[Fnum],Fnum,LRecPtr[Fnum]^,KeyPath);

        UnLockMLock(Fnum,LastRecAddr[Fnum]);

      end;

    end; {If Doc Found ok..}
  end; {With..}

end;

procedure TJobRetention.ImportDefaults;
var
  GotDoc, GotAc : Boolean;
begin
  GotDoc := False;
  if FRetRec.RetDoc <> '' then
    GotDoc := (FRetRec.RetDoc <> '') and FBtrIntf^.LCheckRecExsists(FullOurRefKey(FRetRec.RetDoc), InvF, InvOurRefK);

  if FRetRec.RetCustCode = '' then
    if GotDoc then
      FRetRec.RetCustCode := FBtrIntf^.LInv.CustCode;

  if FRetRec.RetCustCode <> '' then
  begin
    GotAc := (FRetRec.RetCustCode <> '') and FBtrIntf^.LCheckRecExsists(FullCustCode(FRetRec.RetCustCode), CustF, 0);

    if GotAc then
    begin
      FRetRec.DefVATCode := FBtrIntf^.LCust.VATCode;

      FRetRec.RetCCDep[False] := FBtrIntf^.LCust.CustDep;
      FRetRec.RetCCDep[True] := FBtrIntf^.LCust.CustCC;
    end;
  end;

end;

function TJobRetention.Get_jrtTransactionI: ITransaction;
begin
  Result := TToolkit(FToolkit).TransactionO.GetCloneInterface(FRetRec.RetDoc);
end;

function TJobRetention.Get_jrtAcCodeI: IAccount;
begin
  With FToolkit As TToolkit Do Begin
    If FSalesPurchaseType = 'C' Then
      Result := CustomerO.GetCloneInterface(FRetRec.RetCustCode)
    Else
      Result := SupplierO.GetCloneInterface(FRetRec.RetCustCode);
  End; { With FToolkit As TToolkit }
end;

function TJobRetention.Get_jrtCreditDocI: ITransaction;
begin
  Result := TToolkit(FToolkit).TransactionO.GetCloneInterface(FRetRec.RetCrDoc);
end;

function TJobRetention.Get_jrtCISTax: Double;
begin
  Result := FRetRec.RetCISTax;
end;

function TJobRetention.Get_jrtCISGross: Double;
begin
  Result := FRetRec.RetCISGross;
end;

function TJobRetention.Get_jrtCISEmployee: WideString;
begin
  Result := FRetRec.RetCISEmpl;
end;

function TJobRetention.Get_jrtApplicationMode: TRetentionAppType;
begin
  Result := FRetRec.RetAppMode;
end;

procedure TJobRetention.Set_jrtApplicationMode(Value: TRetentionAppType);
begin
  FRetRec.RetAppMode := Value;
end;



//IBrowseInfo
function TJobRetention.Get_ibInterfaceMode: Integer;
begin
  Result := Ord(FIntfType);
end;



end.
