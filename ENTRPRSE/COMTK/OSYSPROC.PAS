unit oSysProc;
{$ALIGN 1}  { Variable Alignment Disabled }

interface

uses
  ComObj, ActiveX, {$IFNDEF WANTEXE}Enterprise01_TLB{$ELSE}Enterprise04_TLB{$ENDIF}, oConvert;

type

  TSystemProcesses = Class(TAutoIntfObject, ISystemProcesses)
  private
    FTrans : ITransaction;
    FToolkit : TObject;
  protected
    function ConvertToPDN: IConvertList; safecall;
    function ConvertToPIN: IConvertList; safecall;
    function ConvertToPOR: IConvertList; safecall;
    function ConvertToSDN: IConvertList; safecall;
    function ConvertToSIN: IConvertList; safecall;
    function ConvertToSOR: IConvertList; safecall;
  public
    Constructor Create(Trans : ITransaction; Toolkit : TObject);
  end;


implementation

uses
  ComServ;

Constructor TSystemProcesses.Create(Trans : ITransaction; Toolkit : TObject);
begin
  inherited Create(ComServer.TypeLib, ISystemProcesses);
  FTrans := Trans;
  FToolkit := Toolkit;
end;

function TSystemProcesses.ConvertToPDN: IConvertList;
begin
  Result := TConvertList.Create(dtPDN, FTrans, FToolkit);
end;

function TSystemProcesses.ConvertToPIN: IConvertList;
begin
  Result := TConvertList.Create(dtPIN, FTrans, FToolkit);
end;

function TSystemProcesses.ConvertToPOR: IConvertList;
begin
  Result := TConvertList.Create(dtPOR, FTrans, FToolkit);
end;

function TSystemProcesses.ConvertToSDN: IConvertList;
begin
  Result := TConvertList.Create(dtSDN, FTrans, FToolkit);
end;

function TSystemProcesses.ConvertToSIN: IConvertList;
begin
  Result := TConvertList.Create(dtSIN, FTrans, FToolkit);
end;

function TSystemProcesses.ConvertToSOR: IConvertList;
begin
  Result := TConvertList.Create(dtSOR, FTrans, FToolkit);
end;


end.
