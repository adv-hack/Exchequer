unit xml_writ;

{ prutherford440 09:53 30/10/2001: Disabled Byte Alignment in Delphi 6.0 }
{$ALIGN 1}  { Variable Alignment Disabled }


interface

uses
  ComObj, ActiveX, Enterprise03_TLB, StdVcl, T2Xml, t2xconfg;

type
  TXmlWriter = class(TAutoObject, IXmlWriter)
  private
    FTransO : TXmlTransaction;
    FTransI : IXmlTransaction2;

    FConfigO : TXmlConfiguration;
    FConfigI : IXmlConfiguration2;
    procedure InitObjects;
  protected
    function Get_Transaction: IXmlTransaction; safecall;
    function Get_Version: WideString; safecall;
    function Get_Configuration: IXmlConfiguration; safecall;
    { Protected declarations }
    function GetConfigO : TXmlConfiguration;
  public
    procedure Initialize; override;
    destructor Destroy; override;
    property ConfigurationObject : TXmlConfiguration read GetConfigO;

  end;

implementation

uses ComServ;

procedure TXmlWriter.Initialize;
begin
  inherited Initialize;
  InitObjects;
end;

destructor TXmlWriter.Destroy;
begin
  InitObjects;
  inherited Destroy;
end;

procedure TXmlWriter.InitObjects;
begin
  FTransO := nil;
  FTransI := nil;

  FConfigO := nil;
  FConfigI := nil;
end;

function TXmlWriter.Get_Transaction: IXmlTransaction;
begin
  if not Assigned(FTransO) then
  begin
    FTransO := TXmlTransaction.Create(Self);

    FTransI := FTransO;
  end;

  Result := FTransI;

end;

function TXmlWriter.Get_Version: WideString;
begin
  Result := 'v7.0.7.024';
end;

function TXmlWriter.Get_Configuration: IXmlConfiguration;
begin
  if not Assigned(FConfigO) then
  begin
    FConfigO := TXmlConfiguration.Create;

    FConfigI := FConfigO;
  end;

  Result := FConfigI;
end;

function TXmlWriter.GetConfigO : TXmlConfiguration;
begin
  if not Assigned(FConfigO) then
  begin
    FConfigO := TXmlConfiguration.Create;

    FConfigI := FConfigO;
  end;
  Result := FConfigO;
end;

initialization
  TAutoObjectFactory.Create(ComServer, TXmlWriter, Class_XmlWriter,
    ciMultiInstance, tmApartment);
end.
