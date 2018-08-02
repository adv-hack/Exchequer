// Implementation of the "Address" COM Object
unit oAddr;

interface

{$IFNDEF TCCU}  // Trade Counter Customisation
   This module should not be included within the application being compiled
{$ENDIF}

uses
  ComObj, ActiveX, EnterpriseTrade_TLB, StdVcl, SysUtils, GlobVar, CustomP
  , DLLInc;


type
  pAddress = ^AddrTyp;

  TAddressPropertyIndex = (pIdxStreet1, pIdxStreet2, pIdxTown, pIdxCounty, pIdxPostcode, pIdxAssignAddress);
  TWhichAddress = (waTransaction, waSysLocation, waCustomer, waCustomerDelivery, waEventLocation);

  TTradeAddress = class(TAutoIntfObject, ITradeAddress)
  private
    // Records changes to properties of this object
    FDataChanged : Boolean;
    FWhichAddress : TWhichAddress;
    oEventData : TObject;
    ptrAddress : pAddress;
  protected
    function Get_Lines(Index: Integer): WideString; safecall;
    procedure Set_Lines(Index: Integer; const Value: WideString); safecall;
    function Get_Street1: WideString; safecall;
    procedure Set_Street1(const Value: WideString); safecall;
    function Get_Street2: WideString; safecall;
    procedure Set_Street2(const Value: WideString); safecall;
    function Get_Town: WideString; safecall;
    procedure Set_Town(const Value: WideString); safecall;
    function Get_County: WideString; safecall;
    procedure Set_County(const Value: WideString); safecall;
    function Get_PostCode: WideString; safecall;
    procedure Set_PostCode(const Value: WideString); safecall;
    procedure AssignAddress(const Address: ITradeAddress); safecall;
    property Lines[Index: Integer]: WideString read Get_Lines write Set_Lines; default;
    property Street1: WideString read Get_Street1 write Set_Street1;
    property Street2: WideString read Get_Street2 write Set_Street2;
    property Town: WideString read Get_Town write Set_Town;
    property County: WideString read Get_County write Set_County;
    property PostCode: WideString read Get_PostCode write Set_PostCode;

    Procedure AuthoriseProperty (Const PropertyIdx : TAddressPropertyIndex; const PropName : ShortString);
  public
    // DataChanged flag indicates whether Plug-Ins made any changes to
    Property DataChanged : Boolean Read FDataChanged;

    Constructor Create;
    Destructor Destroy; override;

    Procedure Assign(const EventData : TObject; WhichAddress : TWhichAddress);
  End; { TTradeAddress }

implementation

uses
  oEvent, ComServ;

//---------------------------------------------------------------------------

Constructor TTradeAddress.Create;
Begin { Create }
  Inherited Create (ComServer.TypeLib, ITradeAddress);
  FDataChanged := False;
  oEventData := nil;
End; { Create }

//---------------------------------------------------------------------------

Destructor TTradeAddress.Destroy;
Begin { Destroy }
  Inherited;
End; { Destroy }

//---------------------------------------------------------------------------

Procedure TTradeAddress.Assign(const EventData : TObject; WhichAddress : TWhichAddress);
begin { Assign }
  // Reset Datachanged flag for new event
  FDataChanged := False;
  FWhichAddress := WhichAddress;
  oEventData := EventData;

  Case FWhichAddress of
    waTransaction : ptrAddress := @TTradeEventData(oEventData).LTXRec.TKTXHeader.DAddr;
    waSysLocation : ptrAddress := @AddrTyp(TTradeEventData(oEventData).LTKLocationRec.loAddr);
    waCustomer : ptrAddress := @TTradeEventData(oEventData).LTXRec.LCust.Addr;
    waCustomerDelivery : ptrAddress := @TTradeEventData(oEventData).LTXRec.LCust.Addr;
    waEventLocation : ptrAddress := @AddrTyp(TTradeEventData(oEventData).LTKLocationRec.loAddr)
  end;{caase}

end; { Assign }

//---------------------------------------------------------------------------

// Returns True if the specified property can be written to by the Plug-In during the current event
Procedure TTradeAddress.AuthoriseProperty (Const PropertyIdx : TAddressPropertyIndex; const PropName : ShortString);
Var
  Authorised : Boolean;
Begin { AuthoriseProperty }
  // Check for specific enablement of fields
  if oEventData = nil then Raise ERightsError.Create(Format('Customisation Error in ITradeAddress'
  + ' - The property %s is Read-Only',[QuotedStr(PropName)]))
  else begin
    with TTradeEventData(oEventData) do begin
      Authorised := FALSE;

      Case FWhichAddress of
        waTransaction : begin
          Case PropertyIdx Of
            pIdxAssignAddress, pIdxStreet1, pIdxStreet2, pIdxTown, pIdxCounty, pIdxPostcode : begin
              Authorised := HookIsTXHeadCustom1 or HookIsTXHeadCustom2 or HookIsExitCustCodeAfterVal;
            end;
          end;{Case}
        end;
      end;{case}

      If (Not Authorised) Then
        // Raise exception to notify the user that the Plug-In has been naughty
        Raise ERightsError.Create (Format('Customisation Error in ITradeAddress for Event %d.%d - The property %s is Read-Only',
                                          [FWindowId, FHandlerId, QuotedStr(PropName)]));
    end;{with}
  end;{if}
End; { AuthoriseProperty }

procedure TTradeAddress.AssignAddress(const Address: ITradeAddress);
var
  iPos : integer;
begin
  // Check this property can be written to for this event
  AuthoriseProperty (pIdxAssignAddress, 'AssignAddress');

  For iPos := 1 to 5 do ptrAddress^[iPos] := Address[iPos];
end;

function TTradeAddress.Get_County: WideString;
begin
  Result := ptrAddress^[4];
end;

function TTradeAddress.Get_Lines(Index: Integer): WideString;
begin
  Result := ptrAddress^[Index];
end;

function TTradeAddress.Get_PostCode: WideString;
begin
  Result := ptrAddress^[5];
end;

function TTradeAddress.Get_Street1: WideString;
begin
  Result := ptrAddress^[1];
end;

function TTradeAddress.Get_Street2: WideString;
begin
  Result := ptrAddress^[2];
end;

function TTradeAddress.Get_Town: WideString;
begin
  Result := ptrAddress^[3];
end;

//////////////////////////////// Sets //////////////////////////////////////////

procedure TTradeAddress.Set_County(const Value: WideString);
begin
  // Check this property can be written to for this event
  AuthoriseProperty (pIdxCounty, 'County');

  // Set String Value
  ptrAddress^[4] := CustomSetString(ptrAddress^[4], Value, FDataChanged);
end;

procedure TTradeAddress.Set_Lines(Index: Integer; const Value: WideString);
begin
  case Index of
    1 : Set_Street1(Value);
    2 : Set_Street2(Value);
    3 : Set_Town(Value);
    4 : Set_County(Value);
    5 : Set_PostCode(Value);
  end;{case}
end;

procedure TTradeAddress.Set_PostCode(const Value: WideString);
begin
  // Check this property can be written to for this event
  AuthoriseProperty (pIdxPostcode, 'Postcode');

  // Set String Value
  ptrAddress^[5] := CustomSetString(ptrAddress^[5], Value, FDataChanged);
end;

procedure TTradeAddress.Set_Street1(const Value: WideString);
begin
  // Check this property can be written to for this event
  AuthoriseProperty (pIdxCounty, 'Street1');

  // Set String Value
  ptrAddress^[1] := CustomSetString(ptrAddress^[1], Value, FDataChanged);
end;

procedure TTradeAddress.Set_Street2(const Value: WideString);
begin
  // Check this property can be written to for this event
  AuthoriseProperty (pIdxCounty, 'Street2');

  // Set String Value
  ptrAddress^[2] := CustomSetString(ptrAddress^[2], Value, FDataChanged);
end;

procedure TTradeAddress.Set_Town(const Value: WideString);
begin
  // Check this property can be written to for this event
  AuthoriseProperty (pIdxCounty, 'Town');

  // Set String Value
  ptrAddress^[3] := CustomSetString(ptrAddress^[3], Value, FDataChanged);
end;

end.

