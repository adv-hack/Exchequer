unit T2xAdd;

{ prutherford440 09:53 30/10/2001: Disabled Byte Alignment in Delphi 6.0 }
{$ALIGN 1}  { Variable Alignment Disabled }


interface

Uses Classes, Dialogs, Forms, SysUtils, Windows,
     ComObj, ActiveX, Enterprise03_TLB, LogFile;

type
  TGetAddrLineFunc = Function (AddrIdx, Idx : Byte) : String Of Object;
  TSetAddrLineProc = Procedure (AddrIdx, Idx : Byte; Value : String) Of Object;

  TXmlAddress = class(TLogAutoIntf, IXmlAddress)
  private
    FAddressIdx     : Byte;
    FGeTXmlAddressLine : TGetAddrLineFunc;
    FSeTXmlAddressLine : TSetAddrLineProc;
  protected
    function  Get_Lines(Index: Integer): WideString; safecall;
    procedure Set_Lines(Index: Integer; const Value: WideString); safecall;
    function  Get_Street1: WideString; safecall;
    procedure Set_Street1(const Value: WideString); safecall;
    function  Get_Street2: WideString; safecall;
    procedure Set_Street2(const Value: WideString); safecall;
    function  Get_Town: WideString; safecall;
    procedure Set_Town(const Value: WideString); safecall;
    function  Get_County: WideString; safecall;
    procedure Set_County(const Value: WideString); safecall;
    function  Get_PostCode: WideString; safecall;
    procedure Set_PostCode(const Value: WideString); safecall;
    procedure AssignAddress(const Address: IXmlAddress); safecall;
  public
    Constructor Create (AddrIdx : Byte; GetProc : TGetAddrLineFunc; SetProc : TSetAddrLineProc);
    Destructor Destroy; override;
  End; { TXmlAddress }

implementation

uses ComServ;

{-------------------------------------------------------------------------------------------------}

Constructor TXmlAddress.Create (AddrIdx : Byte; GetProc : TGetAddrLineFunc; SetProc : TSetAddrLineProc);
Begin { Create }
  Inherited Create (ComServer.TypeLib, IXmlAddress);

  FAddressIdx := AddrIdx;
  FGeTXmlAddressLine := GetProc;
  FSeTXmlAddressLine := SetProc;
End; { Create }

{-----------------------------------------}

function TXmlAddress.Get_Lines(Index: Integer): WideString;
begin
  Result := FGeTXmlAddressLine(FAddressIdx, Index);
end;

procedure TXmlAddress.Set_Lines(Index: Integer; const Value: WideString);
begin
  FSeTXmlAddressLine (FAddressIdx, Index, Value);
end;

{-----------------------------------------}

function TXmlAddress.Get_Street1: WideString;
begin
  Result := FGeTXmlAddressLine(FAddressIdx, 1);
end;

procedure TXmlAddress.Set_Street1(const Value: WideString);
begin
  FSeTXmlAddressLine (FAddressIdx, 1, Value);
end;

{-----------------------------------------}

function TXmlAddress.Get_Street2: WideString;
begin
  Result := FGeTXmlAddressLine(FAddressIdx, 2);
end;

procedure TXmlAddress.Set_Street2(const Value: WideString);
begin
  FSeTXmlAddressLine (FAddressIdx, 2, Value);
end;

{-----------------------------------------}

function TXmlAddress.Get_Town: WideString;
begin
  Result := FGeTXmlAddressLine(FAddressIdx, 3);
end;

procedure TXmlAddress.Set_Town(const Value: WideString);
begin
  FSeTXmlAddressLine (FAddressIdx, 3, Value);
end;

{-----------------------------------------}

function TXmlAddress.Get_County: WideString;
begin
  Result := FGeTXmlAddressLine(FAddressIdx, 4);
end;

procedure TXmlAddress.Set_County(const Value: WideString);
begin
  FSeTXmlAddressLine (FAddressIdx, 4, Value);
end;

{-----------------------------------------}

function TXmlAddress.Get_PostCode: WideString;
begin
  Result := FGeTXmlAddressLine(FAddressIdx, 5);
end;

procedure TXmlAddress.Set_PostCode(const Value: WideString);
begin
  FSeTXmlAddressLine (FAddressIdx, 5, Value);
end;

{-----------------------------------------}

procedure TXmlAddress.AssignAddress(const Address: IXmlAddress);
Var
  I : Byte;
begin
  For I := 1 To 5 Do
    FSeTXmlAddressLine (FAddressIdx, I, Address[I]);
end;

destructor TXmlAddress.Destroy;
begin

  inherited Destroy;
end;

end.
