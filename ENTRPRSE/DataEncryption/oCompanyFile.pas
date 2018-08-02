unit oCompanyFile;
interface
{$REALCOMPATIBILITY ON}
{$ALIGN 1}

uses
  oBtrieveFile, GlobVar, VarConst;

type
  ISNArrayType   = Array[1..8] of Byte;
  Str16 = string;

{$I W:\ENTRPRSE\MULTCOMP\COMPVAR.PAS}

Type
  TCompanyBtrieveFile = Class(TBaseBtrieveFile)
  protected
    FCompany : CompRec;
    function GetCompanyDetails : CompanyDetRec;
    Function GetRecordPointer : Pointer;
  public
    constructor Create;
    property CompanyDetails : CompanyDetRec read GetCompanyDetails;
  end;

implementation

uses
  Dialogs, SysUtils;

{ oCompanyBtrieveFile }

constructor TCompanyBtrieveFile.Create;
begin
  Inherited Create;

  FDataRecLen := SizeOf(CompRec);
  FDataRec := @FCompany;
end;

function TCompanyBtrieveFile.GetCompanyDetails: CompanyDetRec;
begin
  REsult := FCompany.CompDet;
end;


function TCompanyBtrieveFile.GetRecordPointer: Pointer;
begin
  Result := FDataRec;
end;

end.
