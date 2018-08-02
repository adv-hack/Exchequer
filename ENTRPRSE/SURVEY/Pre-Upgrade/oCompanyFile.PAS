unit oCompanyFile;

{$ALIGN 1}

interface

{$Warn Unit_Platform Off}
{$Warn Symbol_Platform Off}

Uses Classes, Dialogs, FileCtrl, SysUtils, Windows, oBtrieveFile, MCM571;

Type
  TCompanyFile = Class(TBaseBtrieveFile)
  Private
    function GetMcmCode: ShortString;
    function GetMcmCompany: ShortString;
    function GetMcmPath: ShortString;
    function GetRecType: Char;

    function Company : CompRec571;
  Protected
  Public
    Property mcmCode : ShortString Read GetMcmCode;
    Property mcmCompany : ShortString Read GetMcmCompany;
    Property mcmPath : ShortString Read GetMcmPath;
    Property RecType : Char Read GetRecType;

    Constructor Create (ClientId : Byte = 0);
    Destructor Destroy; Override;
  End;


implementation

//--------------------------------------------------------------------------

Constructor TCompanyFile.Create (ClientId : Byte = 0);
Begin { Create }
  Inherited Create(ClientId);
  FDataRecLen := SizeOf(CompRec571);
  GetMem(FDataRec, FDataRecLen);
End; { Create }

//---------------------------------------

Destructor TCompanyFile.Destroy;
Begin { Destroy }
  FreeMem(FDataRec);
  inherited;
End; { Destroy }

//--------------------------------------------------------------------------

function TCompanyFile.Company : CompRec571;
Var
  pCompany : ^CompRec571;
Begin // Company
  pCompany := FDataRec;
  Result := pCompany^;
End; // Company

//--------------------------------------------------------------------------

function TCompanyFile.GetMcmCode: ShortString;
begin
  Result := Company.CompDet.CompCode;
end;

//---------------------------------------

function TCompanyFile.GetMcmCompany: ShortString;
begin
  Result := Company.CompDet.CompName;
end;

//---------------------------------------

function TCompanyFile.GetMcmPath: ShortString;
begin
  Result := Company.CompDet.CompPath;
end;

//---------------------------------------

function TCompanyFile.GetRecType: Char;
begin
  Result := Company.RecPFix;
end;

//--------------------------------------------------------------------------

end.
