Unit CountryCodeUtils;

Interface

Uses SysUtils, CountryCodes, TEditVal;


// Returns the Country Code Name for the specified country if valid, else returns ''
Function CountryCodeName (Const IndexField : enumIndexFieldType; Const CountryCode : String) : String;

// Returns the default 2 character Country Code for new Customers/Suppliers for the current company's country code
Function DefaultCountryCode (Const ExchequerCompanyCountry : String; Const MustExist: Boolean = True) : String;

// Loads the short/long Country Code/Name into a TSBSComboBox
Procedure LoadCountryCodes (Var CountryCombo : TSBSComboBox);

// Returns TRUE if the supplied country code is valid
Function ValidCountryCode (Const IndexField : enumIndexFieldType; Const CountryCode : String) : Boolean;

// PKR. 11/12/2015. Added ec-member field for Intrastat
// Returns TRUE if the supplied country code represents an EC Member state.
Function IsECMember(Const CountryCode : String) : Boolean;

//PR: 28/01/2016 ABSEXCH-17214 v2016 R1 Added function to return the Intrastat Code from the ISO Country Code
Function IntrastatCountryCode(Const IndexField : enumIndexFieldType; Const CountryCode : String) : String;

function CountryCode2ToCountryCode3(Const CountryCode : string) : string;

function CountryCode3ToCountryCode2(Const CountryCode : string) : string;


Implementation

// Import Exchequer Country Codes - avoids referencing VarConst.pas to promote re-use of this unit
{$I ExchequerCountryCodes.inc}

//=========================================================================

// Returns the Country Code Name for the specified country if valid, else returns ''
Function CountryCodeName (Const IndexField : enumIndexFieldType; Const CountryCode : String) : String;
Var
  Idx : Integer;
Begin // CountryCodeName
  Result := '';

  If (Trim(CountryCode) <> '') Then
  Begin
    Idx := ISO3166CountryCodes.IndexOf(IndexField, CountryCode);
    If (Idx <> -1) Then
    Begin
      Result := ISO3166CountryCodes.ccCountryDetails[Idx].cdCountryName;
    End; // If (Idx <> -1)
  End; // If (Trim(CountryCode) <> '')
End; // CountryCodeName

//=========================================================================

// Returns the default 2 character Country Code for new Customers/Suppliers for the current company's country code
Function DefaultCountryCode (Const ExchequerCompanyCountry : String; Const MustExist: Boolean = True) : String;
Begin // DefaultCountryCode
  // HV : 01/02/2017 R1 ABSEXCH-18153- Trader record - Country codes for main and delivery address
  // '044' - UK Country code
  If ExchequerCompanyCountry = UKCCode Then
    Result := 'GB'
  // '065' - Singapore Country code
  Else If ExchequerCompanyCountry = SingCCode Then
    Result := 'SG'
  // '064' - New Zealand Country Code
  Else If ExchequerCompanyCountry = NZCCode Then
    Result := 'NZ'
  // '061' - Australia Country Code
  Else If ExchequerCompanyCountry = AUSCCode Then
    Result := 'AU'
  // '353' - Ireland Country code
  Else If ExchequerCompanyCountry = IECCode Then
    Result := 'IE'
    // '027' - South Africa Country code
  Else If ExchequerCompanyCountry = SACCode Then
    Result := 'ZA'
  Else
    Result := '';

  If MustExist And (Result <> '') And (ISO3166CountryCodes.IndexOf(ifCountry2, Result) < 0) Then
    Result := '';
End; // DefaultCountryCode

//=========================================================================

// Loads the short/long Country Code/Name into a TSBSComboBox
Procedure LoadCountryCodes (Var CountryCombo : TSBSComboBox);
Var
  iCountry : Integer;
Begin // LoadCountryCodes
  // CJS 2016-01-22 - ABSEXCH-17182 - Goods From/To List on Transaction lines duplicated
  CountryCombo.Items.Clear;
  CountryCombo.ItemsL.Clear;

  For iCountry := 0 To (ISO3166CountryCodes.ccCount - 1) Do
  Begin
    With ISO3166CountryCodes.ccCountryDetails[iCountry] Do
    Begin
      CountryCombo.Items.Add (cdCountryCode2);
      CountryCombo.ItemsL.Add (cdCountryName + ' (' + cdCountryCode2 + ')');
    End; // With ISO3166CountryCodes.ccCountryDetails[iCountry]
  End; // For iCountry
End; // LoadCountryCodes

//=========================================================================

// Returns TRUE if the supplied country code is valid
Function ValidCountryCode (Const IndexField : enumIndexFieldType; Const CountryCode : String) : Boolean;
Begin // ValidCountryCode
  Result := (Trim(CountryCode) <> '') And (ISO3166CountryCodes.IndexOf(IndexField, CountryCode) <> -1);
End; // ValidCountryCode

//=========================================================================

// PKR. 11/12/2015. Added ec-member field for Intrastat
// Returns TRUE if the supplied country code represents an EC Member state.
Function IsECMember(Const CountryCode : String) : Boolean;
var
  index : integer;
begin
  Result := false;
  if Trim(CountryCode) <> '' then
  begin
    // PKR. 13/01/2016. Corrected field type.
    index := ISO3166CountryCodes.IndexOf(ifCountry2, CountryCode);
    if index <> -1 then
    begin
      Result := ISO3166CountryCodes.ccCountryDetails[index].cdECMembership;
    end;
  end;
end;

//PR: 28/01/2016 ABSEXCH-17214 v2016 R1 Added function to return the Intrastat Code from the ISO Country Code
Function IntrastatCountryCode(Const IndexField : enumIndexFieldType; Const CountryCode : String) : String;
Var
  Idx : Integer;
Begin // CountryCodeName
  Result := '';

  If (Trim(CountryCode) <> '') Then
  Begin
    Idx := ISO3166CountryCodes.IndexOf(IndexField, CountryCode);
    If (Idx <> -1) Then
    Begin
      Result := ISO3166CountryCodes.ccCountryDetails[Idx].cdIntrastatCountry;
    End; // If (Idx <> -1)
  End; // If (Trim(CountryCode) <> '')
End; // CountryCodeName

function CountryCode2ToCountryCode3(Const CountryCode : string) : string;
var
  Idx : Integer;
begin // CountryCodeName
  Result := '';

  if (Trim(CountryCode) <> '') Then
  begin
    Idx := ISO3166CountryCodes.IndexOf(ifCountry2, CountryCode);
    if (Idx <> -1) Then
    begin
      Result := ISO3166CountryCodes.ccCountryDetails[Idx].cdCountryCode3;
    end; // If (Idx <> -1)
  end; // If (Trim(CountryCode) <> '')
end;

function CountryCode3ToCountryCode2(Const CountryCode : string) : string;
var
  Idx : Integer;
begin // CountryCodeName
  Result := '';

  if (Trim(CountryCode) <> '') Then
  begin
    Idx := ISO3166CountryCodes.IndexOf(ifCountry3, CountryCode);
    if (Idx <> -1) Then
    begin
      Result := ISO3166CountryCodes.ccCountryDetails[Idx].cdCountryCode2;
    end; // If (Idx <> -1)
  end; // If (Trim(CountryCode) <> '')
end;



End.
