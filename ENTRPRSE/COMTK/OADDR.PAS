unit oAddr;

{ markd6 15:34 01/11/2001: Disabled Byte Alignment in Delphi 6.0 }
{$ALIGN 1}  { Variable Alignment Disabled }


interface

Uses Classes, Dialogs, Forms, SysUtils, Windows,
     ComObj, ActiveX, {$IFNDEF WANTEXE}Enterprise01_TLB{$ELSE}Enterprise04_TLB{$ENDIF},
     ExceptIntf;

const
  IDX_COUNTRY = 6;

type
  TGetAddrLineFunc = Function (AddrIdx, Idx : Byte; DirectToLines : Boolean = True) : String Of Object;
  TSetAddrLineProc = Procedure (AddrIdx, Idx : Byte; Value : String; DirectToLines : Boolean = True) Of Object;

  TAddress = class(TAutoIntfObjectEx, IAddress, IAddress2)
  private
    FAddressIdx     : Byte;
    FGetAddressLine : TGetAddrLineFunc;
    FSetAddressLine : TSetAddrLineProc;
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
    procedure AssignAddress(const Address: IAddress); safecall;

    //PR: 26/11/2014 Order Payments
    function Get_Country: ICountryDetails; safecall;
    procedure Set_Country(const Value: ICountryDetails); safecall;
  public
    Constructor Create (AddrIdx : Byte; GetProc : TGetAddrLineFunc; SetProc : TSetAddrLineProc);
    {Destructor Destroy; override;}
  End; { TAddress }

implementation

uses ComServ, CountryCodes, oSetup;

{-------------------------------------------------------------------------------------------------}

Constructor TAddress.Create (AddrIdx : Byte; GetProc : TGetAddrLineFunc; SetProc : TSetAddrLineProc);
Begin { Create }
  Inherited Create (ComServer.TypeLib, IAddress2);

  FAddressIdx := AddrIdx;
  FGetAddressLine := GetProc;
  FSetAddressLine := SetProc;
End; { Create }

{-----------------------------------------}

function TAddress.Get_Lines(Index: Integer): WideString;
begin
  Result := FGetAddressLine(FAddressIdx, Index);
end;

procedure TAddress.Set_Lines(Index: Integer; const Value: WideString);
begin
  FSetAddressLine (FAddressIdx, Index, Value);
end;

{-----------------------------------------}

function TAddress.Get_Street1: WideString;
begin
  Result := FGetAddressLine(FAddressIdx, 1);
end;

procedure TAddress.Set_Street1(const Value: WideString);
begin
  FSetAddressLine (FAddressIdx, 1, Value);
end;

{-----------------------------------------}

function TAddress.Get_Street2: WideString;
begin
  Result := FGetAddressLine(FAddressIdx, 2);
end;

procedure TAddress.Set_Street2(const Value: WideString);
begin
  FSetAddressLine (FAddressIdx, 2, Value);
end;

{-----------------------------------------}

function TAddress.Get_Town: WideString;
begin
  Result := FGetAddressLine(FAddressIdx, 3);
end;

procedure TAddress.Set_Town(const Value: WideString);
begin
  FSetAddressLine (FAddressIdx, 3, Value);
end;

{-----------------------------------------}

function TAddress.Get_County: WideString;
begin
  Result := FGetAddressLine(FAddressIdx, 4);
end;

procedure TAddress.Set_County(const Value: WideString);
begin
  FSetAddressLine (FAddressIdx, 4, Value);
end;

{-----------------------------------------}

function TAddress.Get_PostCode: WideString;
begin
  //PR: 15/10/2013 MRD 2.5.18 Add false parameter so that postcode is retrieved appropriately
  Result := FGetAddressLine(FAddressIdx, 5, False);
end;

procedure TAddress.Set_PostCode(const Value: WideString);
begin
  //PR: 15/10/2013 MRD 2.5.18 Add false parameter so that postcode is set appropriately
  FSetAddressLine (FAddressIdx, 5, Value, False);
end;

{-----------------------------------------}

procedure TAddress.AssignAddress(const Address: IAddress);
Var
  I : Byte;
begin
  For I := 1 To 5 Do //PR: 15/10/2013 MRD 2.5.18 Add false parameter so that postcode is retrieved and set appropriately
    FSetAddressLine (FAddressIdx, I, Address[I], False);
end;

function TAddress.Get_Country: ICountryDetails;
var
  CountryCode : string;
  I : Integer;
begin
  CountryCode := FGetAddressLine(FAddressIdx, IDX_COUNTRY, False);

  //Check if it's a valid country code
  I := ISO3166CountryCodes.IndexOf(ifCountry2, CountryCode);

  if I <> -1 then //Valid
    Result := TSystemSetupCountryDetails.Create(ISO3166CountryCodes.ccCountryDetails[I])
  else
    Result := nil;
end;

procedure TAddress.Set_Country(const Value: ICountryDetails);
begin
  if Assigned(Value) then
    FSetAddressLine(FAddressIdx, IDX_COUNTRY, Value.cdCode2, False)
  else
    FSetAddressLine(FAddressIdx, IDX_COUNTRY, '', False);
end;

end.
