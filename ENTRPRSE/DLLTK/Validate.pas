unit Validate;

interface

uses
  EntLicence, VarConst;

const
//Stock GL Codes
  sglSales    = 1;
  sglCos      = 2;
  sglClosing  = 3;
  sglValue    = 4;
  sglFinished = 5;

  sglWIP      = 6;
  sglSalesRet = 7;
  sglPurchRet = 8;

//Nominal Classes
  ncBankAc    = 10;
  ncClosing   = 20;
  ncFinished  = 30;
  ncValue     = 40;
  ncWIP       = 50;
  ncOverheads = 60;
  ncMisc      = 70;
  ncSalesRet  = 80;
  ncPurchRet  = 90;

  StkValueSet    =  ['F','L','A','C','S','R'];  {* Permitted valuation methods *}
  IAOStkValueSet =  ['S', 'F', 'A']; {Limited set allowed for IAO}




  function ValidateStockGL(WhichField : Integer; oNom : NominalRec) : Boolean;
  function ValidateStockValuationMethod(StkValType : Char) : Boolean;

implementation

function ValidateStockGL(WhichField : Integer; oNom : NominalRec) : Boolean;
begin
  Result := False;
  if not Syss.UseGLClass then
    Result := oNom.NomType In [BankNHCode,PLNHCode]
  else
    Case WhichField of
      sglSales,
      sglCos        : Result := oNom.NomType = PLNHCode;
      sglClosing    : Result := oNom.NomClass = ncClosing;
      sglValue      : Result := oNom.NomClass = ncValue;
      sglFinished   : Result := oNom.NomClass = ncFinished;
      sglWIP        : Result := (oNom.NomClass = ncWIP) or (EnterpriseLicence.elProductType in [ptLITECust, ptLITEAcct]);

      sglSalesRet   : Result := (oNom.NomClass = ncSalesRet) or
                         (EnterpriseLicence.elProductType in [ptLITECust, ptLITEAcct]);
      sglPurchRet   : Result := (oNom.NomClass = ncPurchRet) or
                         (EnterpriseLicence.elProductType in [ptLITECust, ptLITEAcct]);
    end;
end;

function ValidateStockValuationMethod(StkValType : Char) : Boolean;
begin
  if (EnterpriseLicence.elProductType in [ptLITECust, ptLITEAcct]) then
    Result := StkValType in IAOStkValueSet
  else
    Result := StkValType in StkValueSet;
end;

end.
