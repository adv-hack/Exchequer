unit oVoucher;

{ markd6 15:34 01/11/2001: Disabled Byte Alignment in Delphi 6.0 }
{$ALIGN 1}  { Variable Alignment Disabled }


interface

Uses Classes, Dialogs, Forms, SysUtils, Windows, ComObj, ActiveX,
     {$IFNDEF WANTEXE}Enterprise01_TLB{$ELSE}Enterprise04_TLB{$ENDIF}, oBtrieve, GlobVar, VarConst, VarCnst3, MiscFunc,
     BtrvU2, ExBTTH1U, oAddr, GlobList;

type
  TCISVoucher = class(TBtrieveFunctions, ICISVoucher, IBrowseInfo)
  private
    FIntfType : TInterfaceMode;
    FCISRec : JobCISType;
    FAddrO : TAddress;
    FAddrI : IAddress;
    FToolkit : TObject;

    FEmployee : string;
    FDate : string;
    FSupplier : string;
    FFolio : longint;
    FVoucherNo : string;
  protected
    function Get_cvNumber: WideString; safecall;
    procedure Set_cvNumber(const Value: WideString); safecall;
    function Get_cvEmployee: WideString; safecall;
    procedure Set_cvEmployee(const Value: WideString); safecall;
    function Get_cvDate: WideString; safecall;
    procedure Set_cvDate(const Value: WideString); safecall;
    function Get_cvTransaction: WideString; safecall;
    procedure Set_cvTransaction(const Value: WideString); safecall;
    function Get_cvFolio: Integer; safecall;
    function Get_cvCertificateNo: WideString; safecall;
    procedure Set_cvCertificateNo(const Value: WideString); safecall;
    function Get_cvGrossTotal: Double; safecall;
    procedure Set_cvGrossTotal(Value: Double); safecall;
    function Get_cvType: TCISVoucherType; safecall;
    procedure Set_cvType(Value: TCISVoucherType); safecall;
    function Get_cvAutoTotalTax: Double; safecall;
    procedure Set_cvAutoTotalTax(Value: Double); safecall;
    function Get_cvManualTax: WordBool; safecall;
    procedure Set_cvManualTax(Value: WordBool); safecall;
    function Get_cvTaxableTotal: Double; safecall;
    procedure Set_cvTaxableTotal(Value: Double); safecall;
    function Get_cvCurrency: Integer; safecall;
    procedure Set_cvCurrency(Value: Integer); safecall;
    function Get_cvAddress: IAddress; safecall;
    function Get_cvBehalf: WideString; safecall;
    procedure Set_cvBehalf(const Value: WideString); safecall;
    function Get_cvCorrection: WordBool; safecall;
    procedure Set_cvCorrection(Value: WordBool); safecall;
    function Get_cvTaxDue: Double; safecall;
    procedure Set_cvTaxDue(Value: Double); safecall;
    function Get_cvSupplier: WideString; safecall;
    procedure Set_cvSupplier(const Value: WideString); safecall;

    function Clone: ICISVoucher; safecall;
    function Get_Index: TCISVoucherIndex; safecall;
    procedure Set_Index(Value: TCISVoucherIndex); safecall;
    function BuildEmployeeDateIndex(const EmployeeCode: WideString; const ADate: WideString): WideString; safecall;
    function BuildDateEmployeeTypeIndex(const ADate: WideString; const Employee: WideString;
                                        AType: TCISVoucherType): WideString; safecall;
    function BuildNumberIndex(const VoucherNo: WideString): WideString; safecall;
    function BuildFolioIndex(FolioNumber: Integer): WideString; safecall;
    function BuildDateSupplierIndex(const ADate: WideString; const Supplier: WideString): WideString; safecall;
    function BuildSupplierDateIndex(const Supplier: WideString; const ADate: WideString): WideString; safecall;

    //IBrowseInfo
    function Get_ibInterfaceMode: Integer; safecall;
    // IAddress / TAddress implementation
    //PR: 15/10/2013 MRD 2.5.18 Add DirectToLines default parameter
    function GetAddrLine (AddrIdx, Idx : Byte; DirectToLines : Boolean = True) : String;
    Procedure SetAddrLine(AddrIdx, Idx : Byte; Value : String; DirectToLines : Boolean = True);

    //Local methods
    Function  AuthoriseFunction (Const FuncNo     : Byte;
                                 Const MethodName : String;
                                 Const AccessType : Byte = 0) : Boolean; Override;
    Function  GetDataRecord (Const BtrOp : SmallInt; Const SearchKey : String = '') : Integer; Override;
    procedure InitObjects;
    procedure CopyDataRecord; override;
    procedure CloneDetails(const Rec : JobCISType);
  public
    constructor Create(Const IType    : TInterfaceMode;
                       Const Toolkit  : TObject;
                       Const BtrIntf  : TCtkTdPostExLocalPtr);
    destructor Destroy; override;
  end;

  Function CreateTCISVoucher (Const Toolkit : TObject; Const ClientId : Integer) : TCISVoucher;


implementation

uses
  BtKeys1U, ComServ, EtStrU;

Function CreateTCISVoucher (Const Toolkit : TObject; Const ClientId : Integer) : TCISVoucher;
Var
  BtrIntf : TCtkTdPostExLocalPtr;
Begin
  // Create common btrieve interface for objects
  New (BtrIntf, Create(ClientId));

  // Open files needed by Voucher object
  BtrIntf^.Open_System(JDetlF, JDetlF);   { Employee Time Rates for TSH }
  BtrIntf^.Open_System(MiscF, MiscF);   { Links }

  Result := TCISVoucher.Create(imGeneral, Toolkit, BtrIntf);

  if SQLBeingUsed then
    Result.SetFileNos([JDetlF, MiscF]);

End;

constructor TCISVoucher.Create(Const IType    : TInterfaceMode;
                               Const Toolkit  : TObject;
                               Const BtrIntf  : TCtkTdPostExLocalPtr);
begin
  inherited Create(ComServer.TypeLib, ICISVoucher, BtrIntf);

  FFileNo := JDetlF;
  FIntfType := IType;
  FillChar(FCISRec, SizeOf(FCISRec), #0);
  FToolkit := Toolkit;

  InitObjects;
end;

destructor TCISVoucher.Destroy;
begin
  InitObjects;

  inherited Destroy;
end;



function KeyNomFull(const s : string) : longint;
begin
  Move(s[1], Result, SizeOf(Result));
end;

function TCISVoucher.Get_cvNumber: WideString;
begin
  Result := FCISRec.CISCertNo;
end;

procedure TCISVoucher.Set_cvNumber(const Value: WideString);
begin
  FVoucherNo := Value;
end;

function TCISVoucher.Get_cvEmployee: WideString;
begin
  Result := FEmployee;
end;

procedure TCISVoucher.Set_cvEmployee(const Value: WideString);
begin
  FEmployee := Value;
end;

function TCISVoucher.Get_cvDate: WideString;
begin
  Result := FDate;
end;

procedure TCISVoucher.Set_cvDate(const Value: WideString);
begin
  FDate := Value;
end;

function TCISVoucher.Get_cvTransaction: WideString;
begin
  Result := FCISRec.CISVORef;
end;

procedure TCISVoucher.Set_cvTransaction(const Value: WideString);
begin
  FCISRec.CISVORef := Value;
end;

function TCISVoucher.Get_cvFolio: Integer;
begin
  Result := FFolio;
end;

function TCISVoucher.Get_cvCertificateNo: WideString;
begin
  Result := FCISRec.CISVCert;
end;

procedure TCISVoucher.Set_cvCertificateNo(const Value: WideString);
begin
  FCISRec.CISVCert := Value;
end;

function TCISVoucher.Get_cvGrossTotal: Double;
begin
  Result := FCISRec.CISvGrossTotal;
end;

procedure TCISVoucher.Set_cvGrossTotal(Value: Double);
begin
  FCISRec.CISvGrossTotal := Value;
end;

function TCISVoucher.Get_cvType: TCISVoucherType;
begin
  Result := TCISVoucherType(FCISRec.CISCType);
end;

procedure TCISVoucher.Set_cvType(Value: TCISVoucherType);
begin
  FCISRec.CISCType := Value;
end;

function TCISVoucher.Get_cvAutoTotalTax: Double;
begin
  Result := FCISRec.CISvAutoTotalTax;
end;

procedure TCISVoucher.Set_cvAutoTotalTax(Value: Double);
begin
  FCISRec.CISvAutoTotalTax := Value;
end;

function TCISVoucher.Get_cvManualTax: WordBool;
begin
  Result := WordBoolToBool(FCISRec.CISvManualTax);
end;

procedure TCISVoucher.Set_cvManualTax(Value: WordBool);
begin
  FCISRec.CISvManualTax := WordBoolToBool(Value);
end;

function TCISVoucher.Get_cvTaxableTotal: Double;
begin
  Result := FCISRec.CISTaxableTotal;
end;

procedure TCISVoucher.Set_cvTaxableTotal(Value: Double);
begin
  FCISRec.CISTaxableTotal := Value;
end;

function TCISVoucher.Get_cvCurrency: Integer;
begin
  Result := FCISRec.CISCurr;
end;

procedure TCISVoucher.Set_cvCurrency(Value: Integer);
begin
  FCISRec.CISCurr := ValidateCurrencyNo (Value);
end;

function TCISVoucher.Get_cvAddress: IAddress;
begin
  If (Not Assigned(FAddrO)) Then Begin
    { Create and initialise Customer Address Sub-Object}
    FAddrO := TAddress.Create(1, GetAddrLine, SetAddrLine);

    FAddrI := FAddrO;
  End; { If (Not Assigned(FDelAddrO)) }

  Result := FAddrI;
end;

function TCISVoucher.Get_cvBehalf: WideString;
begin
  Result := FCISRec.CISBehalf;
end;

procedure TCISVoucher.Set_cvBehalf(const Value: WideString);
begin
  FCISRec.CISBehalf := Value;
end;

function TCISVoucher.Get_cvCorrection: WordBool;
begin
  Result := BoolToWordBool(FCISRec.CISCorrect);
end;

procedure TCISVoucher.Set_cvCorrection(Value: WordBool);
begin
  FCISRec.CISCorrect := WordBoolToBool(Value);
end;

function TCISVoucher.Get_cvTaxDue: Double;
begin
  Result := FCISRec.CISvTaxDue;
end;

procedure TCISVoucher.Set_cvTaxDue(Value: Double);
begin
  FCISRec.CISvTaxDue := Value;
end;

Function  TCISVoucher.AuthoriseFunction (Const FuncNo     : Byte;
                             Const MethodName : String;
                             Const AccessType : Byte = 0) : Boolean;
begin
  Case FuncNo Of
    // Step functions
    1..4      : Result := False;  { Not supported as JDetlF is shared file }

    5..99     : Result := (FIntfType = imGeneral);

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

Function  TCISVoucher.GetDataRecord (Const BtrOp : SmallInt; Const SearchKey : String = '') : Integer;
Var
  BtrOpCode, BtrOpCode2 : SmallInt;
  KeyS                  : Str255;
  Loop                  : Boolean;
Begin { GetDataRecord }
  Result := 0;
  LastErDesc := '';
  BtrOpCode2 := 0;
  KeyS := SetKeyString(BtrOp, JATCode + JBSCode + SearchKey);

  With FBtrIntf^ Do Begin
    BtrOpCode := BtrOp;

    Loop := True;
    Case BtrOp of
      // Moving forward through file
      B_GetGEq,
      B_GetGretr,
      B_GetNext    : BtrOpCode2 := B_GetNext;

      B_GetFirst   : Begin
                       KeyS := JATCode + JBSCode + #0;
                       BtrOpCode  := B_GetGEq;
                       BtrOpCode2 := B_GetNext;
                     End;

      // Moving backward through file
      B_GetLess,
      B_GetLessEq,
      B_GetPrev    : BtrOpCode2 := B_GetPrev;

      B_GetLast    : Begin
                       KeyS := JATCode + JBSCode + #255;
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
      if (Result = 0) and ((LJobDetl.RecPFix <> JATCode) or (LJobDetl.SubType <> JBSCode)) then
        Result := 9;
    Until (Result <> 0) Or (Not Loop) Or ((LJobDetl.RecPFix = JATCode) And (LJobDetl.SubType = JBSCode));

    FKeyString := KeyS;

    If (Result = 0) Then Begin
      // check correct record type was returned
      If (LJobDetl.RecPFix = JATCode) And (LJobDetl.SubType = JBSCode) Then
      begin
        // Convert to Toolkit structure
        CopyDataRecord;
        
      end
      Else
        Result := 4;
    End; { If (Result = 0) }
  End; { With FBtrIntf^ }

{  If (Result <> 0) Then
    LastErDesc := Ex_ErrorDescription (63, Result);}
end;

procedure TCISVoucher.InitObjects;
begin
  FAddrO := nil;
  FAddrI := nil;
end;

procedure TCISVoucher.CopyDataRecord;
begin
  Move(FBtrIntf^.LJobDetl^.JobCISV, FCISRec, SizeOf(FCISRec));

  FEmployee := Copy(FCISRec.CISvCode1, 1, EmplKeyLen);
  FDate     := Copy(FCISRec.CISvCode2, 1, 8);
  FSupplier := Copy(FCISRec.CISVSDate, 1, CustKeyLen);
  FFolio    := KeyNomFull(FCISRec.CISFolio);
end;

function TCISVoucher.Clone: ICISVoucher;
var
  CloneO : TCISVoucher;
begin
  // Check Clone method is available
  AuthoriseFunction(104, 'Clone');

  // Create new Transaction object
  CloneO := TCISVoucher.Create(imClone, FToolkit, FBtrIntf);

  CloneO.CloneDetails(FCISRec);

  Result := CloneO;
end;

function TCISVoucher.Get_Index: TCISVoucherIndex;
begin
  Result := TCISVoucherIndex(FIndex);
end;

procedure TCISVoucher.Set_Index(Value: TCISVoucherIndex);
begin
  FIndex := Ord(Value);
end;

// IAddress / TAddress implementation
//PR: 15/10/2013 MRD 2.5.18 Add DirectToLines default parameter
function TCISVoucher.GetAddrLine (AddrIdx, Idx : Byte; DirectToLines : Boolean = True) : String;
begin
  Result := FCISRec.CISAddr[Idx];
end;

//PR: 15/10/2013 MRD 2.5.18 Add DirectToLines default parameter
Procedure TCISVoucher.SetAddrLine(AddrIdx, Idx : Byte; Value : String; DirectToLines : Boolean = True);
begin
  FCISRec.CISAddr[Idx] := Value;
end;

function TCISVoucher.Get_cvSupplier: WideString;
begin
  Result := FSupplier;
end;

procedure TCISVoucher.Set_cvSupplier(const Value: WideString);
begin
  FSupplier := Value;
end;

procedure TCISVoucher.CloneDetails(const Rec : JobCISType);
begin
  FCISRec := Rec;
end;

function TCISVoucher.BuildEmployeeDateIndex(const EmployeeCode: WideString; const ADate: WideString): WideString;
begin
  Result := LJVar(EmployeeCode, EmplKeyLen) + ADate;
end;

function TCISVoucher.BuildDateEmployeeTypeIndex(const ADate: WideString; const Employee: WideString;
                                    AType: TCISVoucherType): WideString;
begin
  result := ADate + LJVar(Employee, EmplKeyLen) + Char(Ord(AType));
end;

function TCISVoucher.BuildNumberIndex(const VoucherNo: WideString): WideString;
begin
  Result := LJVar(VoucherNo, 26);
end;

function TCISVoucher.BuildFolioIndex(FolioNumber: Integer): WideString;
begin
  Result := FullNomKey(FolioNumber) + HelpKStop;
end;

function TCISVoucher.BuildDateSupplierIndex(const ADate: WideString; const Supplier: WideString): WideString;
begin
  Result := ADate + LJVar(Supplier, CustKeyLen);
end;

function TCISVoucher.BuildSupplierDateIndex(const Supplier: WideString; const ADate: WideString): WideString;
begin
  Result := LJVar(Supplier, CustKeyLen) + ADate;
end;


//IBrowseInfo
function TCISVoucher.Get_ibInterfaceMode: Integer; safecall;
begin
  Result := Ord(FIntfType);
end;


end.
