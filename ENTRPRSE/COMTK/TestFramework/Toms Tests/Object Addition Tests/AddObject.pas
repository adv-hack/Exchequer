unit AddObject;

interface
 uses enterprise04_tlb, INIFiles;

type TAddObject = Class
 protected
  fToolkit : IToolKit;
  fINIPath : string;
  fIniFile : TINIFile;
  fObjType : shortint;
  function SaveObjectFromIni : Integer; virtual; abstract;
 public
  property iniFile : TINIFile read fIniFile write fIniFile;
  property toolkit : IToolKit read fToolkit write fToolkit;
  property INIPath : string read fINIPath write fINIPath;
  property ObjType : shortint read fObjType write fObjType;
  function SaveObject : integer; virtual;
  procedure ReadINI;
 end;
{
 CostCentre, Department, Location, Stock (Group), Stock (Product),
 Transaction (SQU/PQU/SOR/POR/SIN/PIN/NOM/ADJ/TSH)
}
type TAddCCDept = class(TAddObject)
public
  function SaveObjectFromIni : longint; override;
  function SaveDepartmentObject : longint;
  function SaveCostCentreObject : longint;
end;

type TAddLocation = class(TAddObject)
public
  function SaveObjectFromIni : longint; override;
end;

type TAddStock = class(TAddObject)
public
  function SaveObjectFromIni : longint; override;
  function SaveStockProductObject : longint;
  function SaveStockGroupObject : longint;
end;

{
 CostCentre, Department, Location, Stock (Group), Stock (Product),
 Transaction (SQU/PQU/SOR/POR/SIN/PIN/NOM/ADJ/TSH)
}

function GetObjectType(objType : Integer) : TAddObject;

implementation
uses
 AddTransaction;
 
procedure TAddObject.ReadINI;
begin
  iniFile := TINIFile.Create(INIPath);
end;

function GetObjectType(objType : Integer) : TAddObject;
begin
  Case objType of
    0 : Result := TAddCCDept.Create;
    1 : Result := TAddCCDept.Create;
    2 : Result := TAddLocation.Create;
    3 : Result := TAddStock.Create;
    4 : Result := TAddStock.Create; 
    5 : Result := TAddSalesPurchase.Create(dtSor);
    6 : Result := TAddSalesPurchase.Create(dtPor);
    7 : Result := TAddNominal.Create;
    8 : Result := TAddTimeSheet.Create;
  else
    Result := nil;
  end;
end;

function TAddObject.SaveObject : integer;
begin
  Result := SaveObjectFromIni;
end;
{==TAddCCDept==}
function TAddCCDept.SaveObjectFromIni : longint;
begin
  ReadINI;

  if(objType = 0) then
    Result := SaveCostCentreObject
  else
    Result := SaveDepartmentObject;
end;

function TAddCCDept.SaveCostCentreObject : longint;
var
  fCostCenter : ICCDept2;
begin
  with fToolkit.CostCentre as ICCDept2 do
  begin
    fCostCenter := Add;

    with fCostCenter do
    begin
      cdCodeW := iniFile.ReadString('Main','cdCodeW','');
      cdNameW := iniFile.ReadString('Main','cdNameW','');
      cdInactive := iniFile.ReadBool('Main','cdInactive',false);
    end;
    
    Result := fCostCenter.Save;
  end;
end;

function TAddCCDept.SaveDepartmentObject : longint;
var
  fDepartment : ICCDept2;
begin
  with fToolkit.Department as ICCDept2 do
  begin
    fDepartment := Add;

    with fDepartment do
    begin
      cdCodeW := iniFile.ReadString('Main','cdCodeW','');
      cdNameW := iniFile.ReadString('Main','cdNameW','');
      cdInactive := iniFile.ReadBool('Main','cdInactive',false);
    end;

    Result := fDepartment.Save;
  end;
end;

{Location}
function TAddLocation.SaveObjectFromIni : longint;
var
  fLocation : ILocation;
begin
  ReadINI;
  with fToolkit.Location do
  begin
    fLocation := Add;

    with fLocation do
    begin
      loCode := iniFile.ReadString('Main','loCode','das');
      loName := iniFile.ReadString('Main','loName','asd');
      loContact := iniFile.ReadString('Main','loContact','dsd');
      loPhone := iniFile.ReadString('Main','loPhone','sdf');
      loCurrency := iniFile.ReadInteger('Main','loCurrency',-1);
      loArea := iniFile.ReadString('Main','loArea','tyy');
      loCostCentre := iniFile.ReadString('Main','loCostCentre','sdf');
      loDepartment := iniFile.ReadString('Main','loDepartment','dfg');
    end;
    Result := fLocation.Save;
  end;
  iniFile.Free;
end;

{==TAddStock==}
function TAddStock.SaveObjectFromIni : longint;
begin
  ReadINI;

  if(objType = 3) then
    Result := SaveStockGroupObject
  else
    Result := SaveStockProductObject;
end;

{StockGroup}
function TAddStock.SaveStockGroupObject : longint;
var
  fStock : Istock;
begin
  with fToolkit.Stock do
  begin
    fStock := Add;

    with fStock do
    begin
      stCode := iniFile.ReadString('Main','stCode','');
      stDesc[1] := iniFile.ReadString('Main','stDesc','');
      stAltCode := iniFile.ReadString('Main','stAltCode','');
      stType := iniFile.ReadInteger('Main','stType',0);
      stSalesGL := iniFile.ReadInteger('Main','stSalesGL',-1);
      stCOSGL := iniFile.ReadInteger('Main','stCOSGL',-1);
      stCostPriceCur := iniFile.ReadInteger('Main','stCostPriceCur',-1);
      stCostPrice := iniFile.ReadInteger('Main','stCostPrice',-1);
      stParentCode := iniFile.ReadString('Main','stParentCode','');
    end;

    Result := fStock.Save;
  end;
end;
{StockProduct}
function TAddStock.SaveStockProductObject : longint;
var
  fStock : Istock;
begin
  with fToolkit.Stock do
  begin
    fStock := Add;

    with fStock do
    begin
      stCode := iniFile.ReadString('Main','stCode','');
      stDesc[1] := iniFile.ReadString('Main','stDesc','');
      stAltCode := iniFile.ReadString('Main','stAltCode','');
      stType := iniFile.ReadInteger('Main','stType',0);
      stSalesGL := iniFile.ReadInteger('Main','stSalesGL',-1);
      stCOSGL := iniFile.ReadInteger('Main','stCOSGL',-1);
      stCostPriceCur := iniFile.ReadInteger('Main','stCostPriceCur',-1);
      stCostPrice := iniFile.ReadInteger('Main','stCostPrice',-1);
      stParentCode := iniFile.ReadString('Main','stParentCode','');
    end;

    Result := fStock.Save;
  end;
end;
end.

