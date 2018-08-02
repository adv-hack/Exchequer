// Implementation of the "teCardDetails" COM Object
unit oCardDet;

interface

{$IFNDEF TCCU}  // Trade Counter Customisation
   This module should not be included within the application being compiled
{$ENDIF}

uses
  ComCtrls, ComObj, ActiveX, EnterpriseTrade_TLB, StdVcl, SysUtils
  , EPOSProc, VarConst, CustomP, oAddr, DLLInc, EPOSCnst;


type

  TCardDetPropertyIndex = (pIdxNeverAuthorise, pIdxcdAuthorisationCode, pIdxcdCardName
  , pIdxcdCardNumber, pIdxcdCardType, pIdxcdExpiryDate);

  TCardDetFunctionIndex = (fIdxUnknownfunction);

  TTradeCardDetails = class(TAutoIntfObject, ITradeCardDetails)
  private
    // Records changes to properties of this object
    FDataChanged : Boolean;

    oEventData : TObject;

  protected
    function Get_cdCardType: Integer; safecall;
    procedure Set_cdCardType(Value: Integer); safecall;
    function Get_cdCardNumber: WideString; safecall;
    procedure Set_cdCardNumber(const Value: WideString); safecall;
    function Get_cdCardName: WideString; safecall;
    procedure Set_cdCardName(const Value: WideString); safecall;
    function Get_cdExpiryDate: WideString; safecall;
    procedure Set_cdExpiryDate(const Value: WideString); safecall;
    function Get_cdAuthorisationCode: WideString; safecall;
    procedure Set_cdAuthorisationCode(const Value: WideString); safecall;

    // Local Methods
    Procedure AuthoriseProperty (Const PropertyIdx : TCardDetPropertyIndex; const PropName : ShortString);
    Procedure AuthoriseFunction (Const FunctionIdx : TCardDetFunctionIndex; const FuncName : ShortString);
  public
    // DataChanged flag indicates whether Plug-Ins made any changes to
    // properties of this object OR any sub-objects
    Property DataChanged : Boolean Read FDataChanged;

    Constructor Create;
    Destructor Destroy; override;

    Procedure Assign (EventData : TObject);

  End; { TTradeCardDetails }

implementation

uses
  oEvent, ComServ;

//---------------------------------------------------------------------------

Constructor TTradeCardDetails.Create;
Begin { Create }
  Inherited Create (ComServer.TypeLib, ITradeEventTransaction);

  FDataChanged := False;
End; { Create }

//---------------------------------------------------------------------------

Destructor TTradeCardDetails.Destroy;
Begin { Destroy }

  Inherited;
End; { Destroy }

//---------------------------------------------------------------------------

Procedure TTradeCardDetails.Assign (EventData : TObject);
begin { Assign }
  // Reset Datachanged flag for new event
  FDataChanged := False;
  oEventData := EventData;
end; { Assign }

//---------------------------------------------------------------------------

Procedure TTradeCardDetails.AuthoriseProperty (Const PropertyIdx : TCardDetPropertyIndex; const PropName : ShortString);
Var
  Authorised : Boolean;
Begin

  // Check for specific enablement of fields
  with TTradeEventData(oEventData) do begin
    Authorised := FALSE;
    Case PropertyIdx Of
      pIdxcdAuthorisationCode, pIdxcdCardName, pIdxcdCardNumber, pIdxcdCardType, pIdxcdExpiryDate : begin
        Authorised := HookIsCreditCardCustom1 or HookIsCreditCardCustom2 or HookIsCreditCardBeforeShow;
      end;
    End; { Case }

    if (not Authorised) then begin
      // Raise exception to notify the user that the Plug-In has been naughty
      raise ERightsError.Create (Format('Customisation Error in ITradeCardDetails for Event %d.%d - The property %s is Read-Only'
      , [FWindowId, FHandlerId, QuotedStr(PropName)]));
    end;{if}
  end;{with}

End;{AuthoriseProperty}

//---------------------------------------------------------------------------

// Returns True if the specified function/procedure can be called by the Plug-In during the current event
Procedure TTradeCardDetails.AuthoriseFunction (Const FunctionIdx : TCardDetFunctionIndex; const FuncName : ShortString);
begin

  //
  // This section needs to be coded once some functions are added in
  //
  Raise Exception.Create ('TTradeCardDetails.AuthoriseFunction Not Implemented - Please notify your technical support');

  { TODO -cDO : TTradeCardDetails.AuthoriseFunction Not Implemented }

end;


function TTradeCardDetails.Get_cdAuthorisationCode: WideString;
begin
  Result := TTradeEventData(oEventData).LTXRec.asCardDetails[4];
end;

procedure TTradeCardDetails.Set_cdAuthorisationCode(const Value: WideString);
begin
  // Check this property can be written to for this event
  AuthoriseProperty (pIdxcdAuthorisationCode, 'cdAuthorisationCode');
  TTradeEventData(oEventData).LTXRec.asCardDetails[4]
  := CustomSetString(TTradeEventData(oEventData).LTXRec.asCardDetails[4], Value, FDataChanged);
end;


function TTradeCardDetails.Get_cdCardName: WideString;
begin
  Result := TTradeEventData(oEventData).LTXRec.asCardDetails[2];
end;

procedure TTradeCardDetails.Set_cdCardName(const Value: WideString);
begin
  // Check this property can be written to for this event
  AuthoriseProperty (pIdxcdCardName, 'cdCardName');
  TTradeEventData(oEventData).LTXRec.asCardDetails[2]
  := CustomSetString(TTradeEventData(oEventData).LTXRec.asCardDetails[2], Value, FDataChanged);
end;


function TTradeCardDetails.Get_cdCardNumber: WideString;
begin
  Result := TTradeEventData(oEventData).LTXRec.asCardDetails[1];
end;

procedure TTradeCardDetails.Set_cdCardNumber(const Value: WideString);
begin
  // Check this property can be written to for this event
  AuthoriseProperty (pIdxcdCardNumber, 'cdCardNumber');
  TTradeEventData(oEventData).LTXRec.asCardDetails[1]
  := CustomSetString(TTradeEventData(oEventData).LTXRec.asCardDetails[1], Value, FDataChanged);
end;


function TTradeCardDetails.Get_cdCardType: Integer;
begin
  Result := TTradeEventData(oEventData).LTXRec.iCardType;
end;

procedure TTradeCardDetails.Set_cdCardType(Value: Integer);
begin
  // Check this property can be written to for this event
  AuthoriseProperty (pIdxcdCardType, 'cdCardType');

  if Value > 20 then
    begin
      raise ERangeError.Create('Card Type out of range : ' + IntToStr(Value) + #13 + #13
      + 'The Tag Number must be from 0 to 20')
    end
  else begin
    if SetupRecord.CreditCards[Value - 1].Desc = '' then
      begin
        raise ERangeError.Create('Card Type not yet defined : ' + IntToStr(Value));
      end
    else begin
      TTradeEventData(oEventData).LTXRec.iCardType
      := CustomSetInteger(TTradeEventData(oEventData).LTXRec.iCardType, Value, FDataChanged);
    end;{if}
  end;{if}
end;


function TTradeCardDetails.Get_cdExpiryDate: WideString;
begin
  Result := TTradeEventData(oEventData).LTXRec.asCardDetails[3];
end;

procedure TTradeCardDetails.Set_cdExpiryDate(const Value: WideString);
begin
  // Check this property can be written to for this event
  AuthoriseProperty (pIdxcdExpiryDate, 'cdExpiryDate');
  TTradeEventData(oEventData).LTXRec.asCardDetails[3]
  := CustomSetString(TTradeEventData(oEventData).LTXRec.asCardDetails[3], Value, FDataChanged);
end;


end.
