unit oCompany;
interface

{$REALCOMPATIBILITY ON}
{$ALIGN 1}

Uses oBtrieveFile, GlobVar, VarConst;

type
  ISNArrayType   = Array[1..8] of Byte;
  Str16 = string;

{$I CompVar}

Type
  TCompanyFile = Class(TBaseBtrieveFile)
  Private
    FCompany : CompRec;
    function GetHkVersion: SmallInt;
    procedure SetHkVersion(const Value: SmallInt);
    function GetHkSecCode: Str16;
    procedure SetHkSecCode(const Value: Str16);
    procedure SetRecPFix(const Value: Char);
    function GetRecPFix: Char;
    function GetHkEncryptedCode: Str16;
    procedure SetHkEncryptedCode(const Value: Str16);

    //PR: 07/10/2016 ABSEXCH-17457
    function GetHkExpiryDate : Real48;
    procedure SetHkExpiryDate(const Value: Real48);
    function GetHkSysRelStatus : Byte;
    procedure SetHkSysRelStatus(const Value : Byte);
  Protected
    Function GetRecordPointer : Pointer;

  Public
    Property RecordPointer : Pointer Read GetRecordPointer;
    property RecPFix: Char read GetRecPFix write SetRecPFix;
    property hkVersion: SmallInt read GetHkVersion write SetHkVersion;
    property hkSecCode: Str16 read GetHkSecCode write SetHkSecCode;
    property hkEncryptedCode: Str16 read GetHkEncryptedCode write SetHkEncryptedCode;
    property hkExpiryDate : Real48 read GetHkExpiryDate write SetHkExpiryDate; //PR: 07/10/2016 ABSEXCH-17457
    property hkSysRelStatus : Byte read GetHkSysRelStatus write SetHkSysRelStatus; //PR: 07/10/2016 ABSEXCH-1745

    Constructor Create;
  End; // TCompanyFile

implementation

//=========================================================================

Constructor TCompanyFile.Create;
Begin // Create
  Inherited Create;

  FDataRecLen := SizeOf(FCompany);
  FDataRec := @FCompany;
End; // Create

//-------------------------------------------------------------------------

function TCompanyFile.GetHkEncryptedCode: Str16;
begin
  Result := FCompany.PlugInSec.hkEncryptedCode;
end;

//-------------------------------------------------------------------------

function TCompanyFile.GetHkExpiryDate: Real48;
begin
  Result := FCompany.PlugInSec.hkSysExpiry;
end;

function TCompanyFile.GetHkSecCode: Str16;
begin
  Result := FCompany.PlugInSec.hkSecCode;
end;

//-------------------------------------------------------------------------

function TCompanyFile.GetHkSysRelStatus: Byte;
begin
  Result := FCompany.PlugInSec.hkSysRelStatus;
end;

function TCompanyFile.GetHkVersion: SmallInt;
begin
  Result := FCompany.PlugInSec.hkVersion;
end;

//-------------------------------------------------------------------------

Function TCompanyFile.GetRecordPointer : Pointer;
Begin // GetRecordPointer
  Result := FDataRec;
End; // GetRecordPointer

//-------------------------------------------------------------------------

function TCompanyFile.GetRecPFix: Char;
begin
  Result := FCompany.RecPFix;
end;

//-------------------------------------------------------------------------

procedure TCompanyFile.SetHkEncryptedCode(const Value: Str16);
begin
  FCompany.PlugInSec.hkEncryptedCode := Value;
end;

//-------------------------------------------------------------------------


procedure TCompanyFile.SetHkExpiryDate(const Value: Real48);
begin
  FCompany.PlugInSec.hkSysExpiry := Value;
end;

procedure TCompanyFile.SetHkSecCode(const Value: Str16);
begin
  FCompany.PlugInSec.hkSecCode := Value;
end;

//-------------------------------------------------------------------------

procedure TCompanyFile.SetHkSysRelStatus(const Value: Byte);
begin
  FCompany.PlugInSec.hkSysRelStatus := Value;
end;

procedure TCompanyFile.SetHkVersion(const Value: SmallInt);
begin
  FCompany.PlugInSec.hkVersion := Value;
end;

//-------------------------------------------------------------------------

procedure TCompanyFile.SetRecPFix(const Value: Char);
begin
  FCompany.RecPFix := Value;
end;

end.
