unit oAuthenticationState;

interface

Uses Contnrs, SysUtils;

Type
  // Class to code and decode the Enterprise Authentication Requirements string
  TEnterpriseAuthenticationRequirements = Class(TObject)
  Private
    FCompany : ShortString;
    Function GetRequirements : WideString;
    Procedure SetRequirements(Value : WideString);
  Public
    Property Company : ShortString Read FCompany Write FCompany;
    Property Requirements : WideString Read GetRequirements Write SetRequirements;

    Constructor Create (Const AuthReq : WideString = '');
  End; // TEnterpriseAuthenticationRequirements

  //------------------------------

  TString10 = String[10];

  TCompanyAuthentication = Class(TObject)
  Private
    FCompany : TString10;
    FUser    : TString10;
    Function GetAuthentication : WideString;
    Procedure SetAuthentication(Value : WideString);
  Public
    Property Company : TString10 Read FCompany Write FCompany;
    Property User : TString10 Read FUser Write FUser;
    Property Authentication : WideString Read GetAuthentication Write SetAuthentication;

    Constructor Create (Const CompanyState : WideString = '');

    // Returns the size of the encrypted company state string
    Class Function CompanyStateSize : SmallInt;
  End; // TCompanyAuthentication

  //------------------------------

  TEnterpriseAuthenticationState = Class(TObject)
  Private
    FAuthenticationList : TObjectList;

    Function GetAuthenticationData (Company : ShortString) : WideString;
    Function GetState : WideString;
    Procedure SetState (Value : WideString);
  Public
    Property AuthenticationData [Company : ShortString] : WideString Read GetAuthenticationData;
    Property State : WideString Read GetState Write SetState;

    Constructor Create (Const State : WideString = '');
    Destructor Destroy; Override;

    Procedure AddAuthentication(Const Company, User : ShortString);
  End; // TEnterpriseAuthenticationState

implementation

Uses Crypto;

//=========================================================================

Constructor TEnterpriseAuthenticationRequirements.Create (Const AuthReq : WideString = '');
Begin // Create
  Inherited Create;
  FCompany := '';
  If (AuthReq <> '') Then SetRequirements(AuthReq);
End; // Create

//-------------------------------------------------------------------------

Function TEnterpriseAuthenticationRequirements.GetRequirements : WideString;
Begin // GetRequirements
  Result := EncodeKey (17283, FCompany);
End; // GetRequirements
Procedure TEnterpriseAuthenticationRequirements.SetRequirements(Value : WideString);
Begin // SetRequirements
  FCompany := DecodeKey (17283, Value);
End; // SetRequirements

//=========================================================================

Constructor TCompanyAuthentication.Create (Const CompanyState : WideString = '');
Begin // Create
  Inherited Create;
  FCompany := StringOfChar(' ', 10);
  FUser := StringOfChar(' ', 10);
  If (CompanyState <> '') Then SetAuthentication(CompanyState);
End; // Create

//-------------------------------------------------------------------------

Class Function TCompanyAuthentication.CompanyStateSize : SmallInt;
Begin // CompanyStateSize
  // Return size of encrypted string
  Result := 20;
End; // CompanyStateSize

//-------------------------------------------------------------------------

Function TCompanyAuthentication.GetAuthentication : WideString;
Begin // GetAuthentication
  Result := EncodeKey (17283, FCompany + FUser);
End; // GetAuthentication
Procedure TCompanyAuthentication.SetAuthentication(Value : WideString);
Var
  sDecode : ShortString;
Begin // SetAuthentication
  sDecode := DecodeKey (17283, Value);
  FCompany := Copy (sDecode, 1, 10);
  FUser :=  Copy (sDecode, 11, 10);
End; // SetAuthentication

//=========================================================================

Constructor TEnterpriseAuthenticationState.Create (Const State : WideString = '');
Begin // Create
  Inherited Create;

  FAuthenticationList := TObjectList.Create;

  SetState (State);
End; // Create

//------------------------------

Destructor TEnterpriseAuthenticationState.Destroy;
Begin // Destroy
  FAuthenticationList.Free;

  Inherited Destroy;
End; // Destroy

//-------------------------------------------------------------------------

Function TEnterpriseAuthenticationState.GetAuthenticationData (Company : ShortString) : WideString;
Var
  oCompanyAuthentication : TCompanyAuthentication;
  I : SmallInt;
Begin // GetAuthenticationData
  Result := '';
  If (FAuthenticationList.Count > 0) Then
  Begin
    Company := Copy(UpperCase(Trim(Company)) + StringOfChar(' ', 10), 1, 10);
    For I := 0 To (FAuthenticationList.Count - 1) Do
    Begin
      oCompanyAuthentication := TCompanyAuthentication(FAuthenticationList.Items[I]);
      If (oCompanyAuthentication.Company = Company) Then
      Begin
        Result := oCompanyAuthentication.Authentication;
        Break;
      End; // If (oCompanyAuthentication.Company = Company)
    End; // For I
  End; // If (FAuthenticationList.Count > 0)
End; // GetAuthenticationData

//------------------------------

Function TEnterpriseAuthenticationState.GetState : WideString;
Var
  I : SmallInt;
Begin // GetState
  // Encode the state information
  Result := '';
  If (FAuthenticationList.Count > 0) Then
  Begin
    For I := 0 To (FAuthenticationList.Count - 1) Do
    Begin
      Result := Result + TCompanyAuthentication(FAuthenticationList.Items[I]).Authentication;
    End; // For I
  End; // If (FAuthenticationList.Count > 0)
End; // GetState
Procedure TEnterpriseAuthenticationState.SetState (Value : WideString);
Var
  S : ShortString;
  I : SmallInt;
Begin // SetState
  If (Value <> '') And ((Length(Value) Mod TCompanyAuthentication.CompanyStateSize) = 0) Then
  Begin
    // Decode the state information
    I := 1;
    While (I < Length(Value)) Do
    Begin
      // Extract a Company State block from the encrypted string and reposition for the next block
      S := Copy (Value, I, TCompanyAuthentication.CompanyStateSize);
      I := I + TCompanyAuthentication.CompanyStateSize;
      FAuthenticationList.Add(TCompanyAuthentication.Create (S));
    End; // While (I < Length(Value))
  End; // If (Value <> '')
End; // SetState

//-------------------------------------------------------------------------

Procedure TEnterpriseAuthenticationState.AddAuthentication(Const Company, User : ShortString);
Var
  oCompanyAuthentication : TCompanyAuthentication;
Begin // AddAuthentication
  oCompanyAuthentication := TCompanyAuthentication.Create;
  oCompanyAuthentication.Company := UpperCase(Trim(Company)) + StringOfChar(' ', 10);  // Pad with spaces
  oCompanyAuthentication.User := UpperCase(Trim(User)) + StringOfChar(' ', 10);  // pad with spaces
  FAuthenticationList.Add(oCompanyAuthentication);
End; // AddAuthentication

//-------------------------------------------------------------------------

end.
