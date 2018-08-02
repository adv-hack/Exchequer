unit zPaper;

interface

uses
  ComObj, ActiveX, AxCtrls, Classes, Dialogs, StdVcl, SysUtils,
  Enterprise_TLB, CustTypU, CustAbsU;

Type
  TCOMPaperlessEmailAddress = Class(TAutoIntfObject, ICOMPaperlessEmailAddress)
  private
    FAddress : TAbsPaperlessEmailAddress;
  Protected
    function Get_eaName: WideString; safecall;
    procedure Set_eaName(const Value: WideString); safecall;
    function Get_eaAddress: WideString; safecall;
    procedure Set_eaAddress(const Value: WideString); safecall;
  public
    Constructor Create(Address : TAbsPaperlessEmailAddress);
  End; // TCOMPaperlessEmailAddress

  //------------------------------

  TCOMPaperlessEmailAddressArray = Class(TAutoIntfObject, ICOMPaperlessEmailAddressArray)
  private
    FAddrArray : TAbsPaperlessEmailAddressArray;
  Protected
    function Get_adCount: Integer; safecall;
    function Get_adItems(Index: Integer): ICOMPaperlessEmailAddress; safecall;
    procedure AddAddress(const Name: WideString; const Address: WideString); safecall;
    procedure Clear; safecall;
    procedure Delete(Index: Integer); safecall;
  Public
    Constructor Create(AddressArray : TAbsPaperlessEmailAddressArray);
  End;

  //------------------------------

  TCOMPaperlessEmailAttachments = Class(TAutoIntfObject, ICOMPaperlessEmailAttachments)
  Private
    FAttachArray : TAbsPaperlessEmailAttachments;
  Protected
    function Get_atItems(Index: Integer): WideString; safecall;
    procedure Set_atItems(Index: Integer; const Value: WideString); safecall;
    function Get_atCount: Integer; safecall;
    procedure Add(const Filename: WideString); safecall;
    procedure Clear; safecall;
    procedure Delete(Index: Integer); safecall;
  Public
    Constructor Create;
    Destructor Destroy; Override;

    procedure InitEmailAttach(AttachArray : TAbsPaperlessEmailAttachments);
  End; // TCOMPaperlessEmailAttachments

  //------------------------------

  TCOMPaperlessEmail = Class(TAutoIntfObject, ICOMPaperlessEmail)
  private
    FEntSysObj : TEnterpriseSystem;
    FEmail : TAbsPaperlessEmail;

    FToRecipsO : TCOMPaperlessEmailAddressArray;
    FToRecipsI : ICOMPaperlessEmailAddressArray;

    FCCRecipsO : TCOMPaperlessEmailAddressArray;
    FCCRecipsI : ICOMPaperlessEmailAddressArray;

    FBCCRecipsO : TCOMPaperlessEmailAddressArray;
    FBCCRecipsI : ICOMPaperlessEmailAddressArray;

    FAttachmentsO : TCOMPaperlessEmailAttachments;
    FAttachmentsI : ICOMPaperlessEmailAttachments;
  protected
    function Get_emSenderName: WideString; safecall;
    procedure Set_emSenderName(const Value: WideString); safecall;
    function Get_emSenderAddress: WideString; safecall;
    procedure Set_emSenderAddress(const Value: WideString); safecall;
    function Get_emToRecipients: ICOMPaperlessEmailAddressArray; safecall;
    function Get_emCCRecipients: ICOMPaperlessEmailAddressArray; safecall;
    function Get_emBCCRecipients: ICOMPaperlessEmailAddressArray; safecall;
    function Get_emSubject: WideString; safecall;
    procedure Set_emSubject(const Value: WideString); safecall;
    function Get_emMessageText: WideString; safecall;
    procedure Set_emMessageText(const Value: WideString); safecall;
    function Get_emAttachments: ICOMPaperlessEmailAttachments; safecall;
    function Get_emPriority: Enterprise_TLB.TEmailPriority; safecall;
    procedure Set_emPriority(Value: Enterprise_TLB.TEmailPriority); safecall;
    function Get_emCoverSheet: WideString; safecall;
    procedure Set_emCoverSheet(const Value: WideString); safecall;
    function Get_emSendReader: WordBool; safecall;
    procedure Set_emSendReader(Value: WordBool); safecall;
  public
    Constructor Create;
    Destructor Destroy; Override;

    procedure InitEmail(EntSysObj: TEnterpriseSystem);
  End; // TCOMPaperlessEmail

  //------------------------------

  TCOMPaperless = class(TAutoIntfObject, ICOMPaperless)
  private
    FEntSysObj : TEnterpriseSystem;

    FEmailO : TCOMPaperlessEmail;
    FEmailI : ICOMPaperlessEmail;
  protected
    { Property methods }
    function Get_Email: ICOMPaperlessEmail; safecall;
  public
    Constructor Create;
    Destructor Destroy; Override;

    procedure InitPaperless(EntSysObj: TEnterpriseSystem);
  End; // TCOMPaperless

implementation

uses ComServ, CustIntU, ZUtils;

//=========================================================================

Constructor TCOMPaperlessEmailAddress.Create(Address : TAbsPaperlessEmailAddress);
Begin // Create
  Inherited Create (ComServer.TypeLib, ICOMPaperlessEmailAddress);
  FAddress := Address;
End; // Create

//-------------------------------------------------------------------------

function TCOMPaperlessEmailAddress.Get_eaName: WideString;
Begin // Get_eaName
  Result := FAddress.eaName;
End; // Get_eaName
procedure TCOMPaperlessEmailAddress.Set_eaName(const Value: WideString);
Begin // Set_eaName
  FAddress.eaName := Value;
End; // Set_eaName

//------------------------------

function TCOMPaperlessEmailAddress.Get_eaAddress: WideString;
Begin // Get_eaAddress
  Result := FAddress.eaAddress;
End; // Get_eaAddress
procedure TCOMPaperlessEmailAddress.Set_eaAddress(const Value: WideString);
Begin // Set_eaAddress
  FAddress.eaAddress := Value;
End; // Set_eaAddress

//=========================================================================

Constructor TCOMPaperlessEmailAddressArray.Create(AddressArray : TAbsPaperlessEmailAddressArray);
Begin // Create
  Inherited Create (ComServer.TypeLib, ICOMPaperlessEmailAddressArray);
  FAddrArray := AddressArray;
End; // Create

//-------------------------------------------------------------------------

function TCOMPaperlessEmailAddressArray.Get_adCount: Integer;
Begin // Get_adCount
  Result := FAddrArray.adCount;
End; // Get_adCount

//------------------------------

function TCOMPaperlessEmailAddressArray.Get_adItems(Index: Integer): ICOMPaperlessEmailAddress;
Begin // Get_adItems
  Result := TCOMPaperlessEmailAddress.Create(FAddrArray.adItems[Index]);
End; // Get_adItems

//-------------------------------------------------------------------------

procedure TCOMPaperlessEmailAddressArray.AddAddress(const Name: WideString; const Address: WideString);
Begin // AddAddress
  FAddrArray.AddAddress(Name, Address)
End; // AddAddress

//-------------------------------------------------------------------------

procedure TCOMPaperlessEmailAddressArray.Clear;
Begin // Clear
  FAddrArray.Clear;
End; // Clear

//-------------------------------------------------------------------------

procedure TCOMPaperlessEmailAddressArray.Delete(Index: Integer);
Begin // Delete
  FAddrArray.Delete(Index);
End; // Delete

//=========================================================================

Constructor TCOMPaperlessEmailAttachments.Create;
Begin
  Inherited Create (ComServer.TypeLib, ICOMPaperlessEmailAttachments);
  FAttachArray := Nil;
End; { Create }

//------------------------------

Destructor TCOMPaperlessEmailAttachments.Destroy;
begin
  FAttachArray := NIL;
  inherited;
end;

//-------------------------------------------------------------------------

procedure TCOMPaperlessEmailAttachments.InitEmailAttach(AttachArray : TAbsPaperlessEmailAttachments);
Begin // InitEmailAttach
  FAttachArray := AttachArray;
End; // InitEmailAttach

//-------------------------------------------------------------------------

function TCOMPaperlessEmailAttachments.Get_atItems(Index: Integer): WideString;
Begin // Get_atItems
  Result := FAttachArray.atItems[Index];
End; // Get_atItems
procedure TCOMPaperlessEmailAttachments.Set_atItems(Index: Integer; const Value: WideString);
Begin // Set_atItems
  FAttachArray.atItems[Index] := Value;
End; // Set_atItems

//-----------------------------------

function TCOMPaperlessEmailAttachments.Get_atCount: Integer;
Begin // Get_atCount:
  Result := FAttachArray.atCount;
End; // Get_atCount:

//-----------------------------------

procedure TCOMPaperlessEmailAttachments.Add(const Filename: WideString);
Begin // Add
  FAttachArray.Add(Filename);
End; // Add

//-----------------------------------

procedure TCOMPaperlessEmailAttachments.Clear;
Begin // Clear;
  FAttachArray.Clear;
End; // Clear;

//-----------------------------------

procedure TCOMPaperlessEmailAttachments.Delete(Index: Integer);
Begin // Delete
  FAttachArray.Delete(Index);
End; // Delete

//=========================================================================

Constructor TCOMPaperlessEmail.Create;
Begin
  Inherited Create (ComServer.TypeLib, ICOMPaperlessEmail);

  FEntSysObj := Nil;

  FToRecipsO := NIL;
  FToRecipsI := NIL;

  FCCRecipsO := NIL;
  FCCRecipsI := NIL;

  FBCCRecipsO := NIL;
  FBCCRecipsI := NIL;

  FAttachmentsO := NIL;
  FAttachmentsI := NIL;
End; { Create }

//------------------------------

Destructor TCOMPaperlessEmail.Destroy;
begin
  FToRecipsO := NIL;
  FToRecipsI := NIL;

  FCCRecipsO := NIL;
  FCCRecipsI := NIL;

  FBCCRecipsO := NIL;
  FBCCRecipsI := NIL;

  FAttachmentsO := NIL;
  FAttachmentsI := NIL;

  FEntSysObj := NIL;

  inherited;
end;

//-------------------------------------------------------------------------

procedure TCOMPaperlessEmail.InitEmail(EntSysObj: TEnterpriseSystem);
Begin // InitEmail
  FEntSysObj := EntSysObj;
  FEmail := FEntSysObj.Paperless.Email;
End; // InitEmail

//-------------------------------------------------------------------------

function TCOMPaperlessEmail.Get_emSenderName: WideString;
begin
  Result := FEmail.emSenderName;
end;
procedure TCOMPaperlessEmail.Set_emSenderName(const Value: WideString);
begin
  FEmail.emSenderName := Value;
end;

//-----------------------------------

function TCOMPaperlessEmail.Get_emSenderAddress: WideString;
begin
  Result := FEmail.emSenderAddress;
end;
procedure TCOMPaperlessEmail.Set_emSenderAddress(const Value: WideString);
begin
  FEmail.emSenderAddress := Value;
end;

//-----------------------------------

function TCOMPaperlessEmail.Get_emCCRecipients: ICOMPaperlessEmailAddressArray;
begin
  If (Not Assigned(FCCRecipsO)) Then
  Begin
    // Create and initialise Email Address Array sub-object
    FCCRecipsO := TCOMPaperlessEmailAddressArray.Create(FEmail.emCCRecipients);
    FCCRecipsI := FCCRecipsO;
  End; { If (Not Assigned(FCCRecipsO)) }

  Result := FCCRecipsI;
end;

//-----------------------------------

function TCOMPaperlessEmail.Get_emToRecipients: ICOMPaperlessEmailAddressArray;
begin
  If (Not Assigned(FToRecipsO)) Then
  Begin
    // Create and initialise Email Address Array sub-object
    FToRecipsO := TCOMPaperlessEmailAddressArray.Create(FEmail.emToRecipients);
    FToRecipsI := FToRecipsO;
  End; { If (Not Assigned(FToRecipsO)) }

  Result := FToRecipsI;
end;

//-----------------------------------

function TCOMPaperlessEmail.Get_emBCCRecipients: ICOMPaperlessEmailAddressArray;
begin
  If (Not Assigned(FBCCRecipsO)) Then
  Begin
    // Create and initialise Email Address Array sub-object
    FBCCRecipsO := TCOMPaperlessEmailAddressArray.Create(FEmail.emBCCRecipients);
    FBCCRecipsI := FBCCRecipsO;
  End; { If (Not Assigned(FBCCRecipsO)) }

  Result := FBCCRecipsI;
end;

//-----------------------------------

function TCOMPaperlessEmail.Get_emSubject: WideString;
begin
  Result := FEmail.emSubject;
end;
procedure TCOMPaperlessEmail.Set_emSubject(const Value: WideString);
begin
  FEmail.emSubject := Value;
end;

//-----------------------------------

function TCOMPaperlessEmail.Get_emMessageText: WideString;
begin
  Result := FEmail.emMessageText;
end;
procedure TCOMPaperlessEmail.Set_emMessageText(const Value: WideString);
begin
  FEmail.emMessageText := Value;
end;

//-----------------------------------

function TCOMPaperlessEmail.Get_emAttachments: ICOMPaperlessEmailAttachments;
begin
  If (Not Assigned(FAttachmentsO)) Then
  Begin
    // Create and initialise Email Attachments sub-object
    FAttachmentsO := TCOMPaperlessEmailAttachments.Create;
    FAttachmentsO.InitEmailAttach(FEmail.emAttachments);

    FAttachmentsI := FAttachmentsO;
  End; { If (Not Assigned(FAttachmentsO)) }

  Result := FAttachmentsI;
end;

//------------------------------

function TCOMPaperlessEmail.Get_emPriority: Enterprise_TLB.TEmailPriority;
begin
  Result := Ord(FEmail.emPriority);
end;
procedure TCOMPaperlessEmail.Set_emPriority(Value: Enterprise_TLB.TEmailPriority);
begin
  FEmail.emPriority := CustAbsU.TEmailPriority(Value);
end;

//-----------------------------------

function TCOMPaperlessEmail.Get_emCoverSheet: WideString;
begin
  Result := FEmail.emCoverSheet;
end;
procedure TCOMPaperlessEmail.Set_emCoverSheet(const Value: WideString);
begin
  FEmail.emCoverSheet := Value;
end;

//-----------------------------------

function TCOMPaperlessEmail.Get_emSendReader: WordBool;
begin
  Result := FEmail.emSendReader;
end;
procedure TCOMPaperlessEmail.Set_emSendReader(Value: WordBool);
begin
  FEmail.emSendReader := Value;
end;

//=========================================================================

Constructor TCOMPaperless.Create;
Begin { Create }
  Inherited Create (ComServer.TypeLib, ICOMPaperless);

  FEntSysObj := Nil;

  // Create the objects when accessed
  FEmailO := NIL;
  FEmailI := NIL;
End; { Create }

//------------------------------

destructor TCOMPaperless.Destroy;
begin
  FEmailO := NIL;
  FEmailI := NIL;

  FEntSysObj := NIL;

  inherited;
end;

//-------------------------------------------------------------------------

procedure TCOMPaperless.InitPaperless(EntSysObj: TEnterpriseSystem);
begin
  FEntSysObj := EntSysObj;

  If Assigned(FEmailO) Then FEmailO.InitEmail(EntSysObj);
end;

//-------------------------------------------------------------------------

function TCOMPaperless.Get_Email: ICOMPaperlessEmail;
begin
  If (Not Assigned(FEmailO)) Then
  Begin
    // Create and initialise Email sub-object
    FEmailO := TCOMPaperlessEmail.Create;
    FEmailO.InitEmail(FEntSysObj);

    FEmailI := FEmailO;
  End; { If (Not Assigned(FEmailO)) }

  Result := FEmailI;
end;

//=========================================================================



end.
