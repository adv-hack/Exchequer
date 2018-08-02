unit oEmlArr;

{ markd6 15:34 01/11/2001: Disabled Byte Alignment in Delphi 6.0 }
{$ALIGN 1}  { Variable Alignment Disabled }

interface

Uses Classes, Dialogs, Forms, SysUtils, Windows, ComObj, ActiveX,
     EnterpriseForms_TLB, RpDevice;

type
  // Email Address Array object
  TEFEmailAddress = class(TAutoIntfObject, IEFEmailAddress)
  private
    FName, FAddress : ShortString;
  protected
    // IEFEmailAddress
    function Get_emlName: WideString; safecall;
    procedure Set_emlName(const Value: WideString); safecall;
    function Get_emlAddress: WideString; safecall;
    procedure Set_emlAddress(const Value: WideString); safecall;
  public
  End; { TEFEmailAddress }

  //-------------------------------------------------

  // Email Address Array object
  TEFEmailAddressArray = class(TAutoIntfObject, IEFEmailAddressArray)
  private
    FAddressList : TList;
    FValidDesc   : ShortString;
  protected
    // IEmailAddressArray
    function Get_eaItems(Index: Integer): IEFEmailAddress; safecall;
    function Get_eaCount: Integer; safecall;
    function AddAddress(const Name: WideString; const Address: WideString): Integer; safecall;
    procedure Clear; safecall;
    procedure Delete(Index: Integer); safecall;

    // Local methods
  public
    Constructor Create (Const ValidDesc : ShortString);
    Destructor Destroy; override;

    Procedure Initialise;
    Function ExtractAddresses : String;
  End; { TEFEmailAddressArray }


implementation

Uses ComServ,
     StrUtil,          // Standard String Functions
     GlobType,         // Global FormDes Const/Type/Var
     MiscFunc;         // Miscellaneous Functions / Types / Constants for the Form TK

Type
  TEmailListItem = Record
    EmailDetsO : TEFEmailAddress;
    EmailDetsI : IEFEmailAddress;
  End; { TEmailListItem}
  pEmailListItem = ^TEmailListItem;

//-----------------------------------------------------------------------------

function TEFEmailAddress.Get_emlAddress: WideString;
begin
  Result := FAddress;
end;

procedure TEFEmailAddress.Set_emlAddress(const Value: WideString);
begin
  If (Value <> FAddress) Then Begin
    // Validate the email address
    If Not ValidateEmailAddress(Value) Then
      Raise EValidation.Create ('The specified email address (' + Value + ') is not valid');

    FAddress := Value;
  End; { If (Value <> FAddress) }
end;

//----------------------------------------

function TEFEmailAddress.Get_emlName: WideString;
begin
  Result := FName;
end;

procedure TEFEmailAddress.Set_emlName(const Value: WideString);
begin
  FName := Value;
end;

//-----------------------------------------------------------------------------

constructor TEFEmailAddressArray.Create (Const ValidDesc : ShortString);
begin
  Inherited Create (ComServer.TypeLib, IEFEmailAddressArray);

  FAddressList := TList.Create;
  FValidDesc := ValidDesc;
end;

//----------------------------------------

destructor TEFEmailAddressArray.Destroy;
begin
  Initialise;
  FreeAndNIL(FAddressList);

  inherited;
end;

//-----------------------------------------------------------------------------

Procedure TEFEmailAddressArray.Initialise;
begin
  While (FAddressList.Count > 0) Do
    // NOTE: Delete method is in the interface which supports 1 based lists
    Delete (1);
end;

//-----------------------------------------------------------------------------

Function TEFEmailAddressArray.ExtractAddresses : String;
Var
  oEmailItem : pEmailListItem;
  I          : SmallInt;
begin
  If (FAddressList.Count > 0) Then
    For I := 0 To Pred(FAddressList.Count) Do Begin
      // Extract Email item object from list
      oEmailItem := FAddressList[I];

      // remove references to destroy sub-objects
      With oEmailItem^.EmailDetsI Do
        Result := Result + Trim(emlName) + ';' + Trim(emlAddress) + ';'
    End; { For I }
end;

//-----------------------------------------------------------------------------

function TEFEmailAddressArray.AddAddress(const Name: WideString; const Address: WideString): Integer;
Var
  oEmailItem : pEmailListItem;
begin
  LastErDesc := '';

  // Validate the email address before continuing
  If Not ValidateEmailAddress(Address) Then Begin
    // Invalid Email Address
    Result := 1000;
    LastErDesc := 'Invalid Email Address';
  End { If Not ValidateEmailAddress(Address) }
  Else
    Result := 0;

  If (Result = 0) Then Begin
    // Create a record to store the details within the list
    New(oEmailItem);
    With oEmailItem^ Do Begin
      EmailDetsO := TEFEmailAddress.Create (ComServer.TypeLib, IEFEmailAddress);
      EmailDetsI := EmailDetsO;

      With EmailDetsI Do Begin
        emlName := Name;
        emlAddress := Address;
      End; { With EmailDetsI }
    End; { With oEmailItem^ }

    FAddressList.Add(oEmailItem);
  End; { If (Result = 0) }
end;

//----------------------------------------

procedure TEFEmailAddressArray.Delete(Index: Integer);
Var
  oEmailItem : pEmailListItem;
begin
  If (Index > 0) And (Index <= FAddressList.Count) Then Begin
    // Extract Email item object from list
    oEmailItem := FAddressList[Index - 1];

    // remove references to destroy sub-objects
    With oEmailItem^ Do Begin
      EmailDetsO := NIL;
      EmailDetsI := NIL;
    End; { With oEmailItem^ }

    // de-allocate memory for record
    Dispose(oEmailItem);

    // remove entry from list
    FAddressList.Delete(Index - 1);
  End { If (Index > 0) And (Index <= FAddressList.Count) }
  Else
    Raise EInvalidIndex.Create ('Invalid Index in IEmailAddressArray.Delete');
end;

//----------------------------------------

function TEFEmailAddressArray.Get_eaCount: Integer;
begin
  Result := FAddressList.Count;
end;

//----------------------------------------

function TEFEmailAddressArray.Get_eaItems(Index: Integer): IEFEmailAddress;
Var
  oEmailItem : pEmailListItem;
begin
  If (Index > 0) And (Index <= FAddressList.Count) Then Begin
    // Extract Email item object from list
    oEmailItem := FAddressList[Index - 1];

    // return reference to sub-objects interface
    Result := oEmailItem^.EmailDetsI;
  End { If (Index > 0) And (Index <= FAddressList.Count) }
  Else
    Raise EInvalidIndex.Create ('Invalid Index in IEmailAddressArray.eaItems');
end;

//-----------------------------------------------------------------------------

procedure TEFEmailAddressArray.Clear;
Begin { Clear }
  Initialise;
End; { Clear }

//-----------------------------------------------------------------------------

end.
