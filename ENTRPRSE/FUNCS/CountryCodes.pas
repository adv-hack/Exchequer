Unit CountryCodes;

Interface

Uses Classes, Forms, SysUtils;

Const
  ISO3166XMLFileName = 'ISO3166-COUNTRIES.XML';

Type
  // PKR. 11/12/2015. Added ec-member field for Intrastat
  enumIndexFieldType = (ifCountry2, ifCountry3, ifCountryNumber, ifECMember, ifIntrastatCountry);

  //------------------------------

  // Generic interface for objects which implement a specific import type
  IISO3166CountryDetails = Interface
    ['{87518403-DE0A-4888-8FEA-F7237291FF1D}']
    // --- Internal Methods to implement Public Properties ---
    Function GetCountryCode2 : string;
    Function GetCountryCode3 : string;
    Function GetCountryCodeNumeric : string;
    Function GetCountryName : string;
    Function GetECMembership : boolean;
    // PKR. 28/01/2016. ABSEXCH-17214. Add Intrastat Country Code
    Function GetIntrastatCountry : string;

    // ------------------ Public Properties ------------------
    Property cdCountryCode2 : string Read GetCountryCode2;
    Property cdCountryCode3 : string Read GetCountryCode3;
    Property cdCountryCodeNumeric : string Read GetCountryCodeNumeric;
    Property cdCountryName : string Read GetCountryName;
    // PKR. 11/12/2015. Added ec-member field for Intrastat
    Property cdECMembership : boolean Read GetECMembership;
    // PKR. 28/01/2016. ABSEXCH-17214. Add Intrastat Country Code
    Property cdIntrastatCountry : string Read GetIntrastatCountry;

    // ------------------- Public Methods --------------------

  End; // IISO3166CountryDetails

  //------------------------------

  // Generic interface for objects which implement a specific import type
  IISO3166CountryCodes = Interface
    ['{3666B7AA-1B39-48BC-A255-F96EA12F8D89}']
    // --- Internal Methods to implement Public Properties ---
    Function GetCount : Integer;
    Function GetCountryDetails(Index : Integer) : IISO3166CountryDetails;

    // ------------------ Public Properties ------------------
    Property ccCount : Integer Read GetCount;
    Property ccCountryDetails[Index : Integer] : IISO3166CountryDetails Read GetCountryDetails;

    // ------------------- Public Methods --------------------
    Function IndexOf (Const IndexField : enumIndexFieldType; Const FieldValue : String) : Integer;
  End; // IISO3166CountryCodes

Var
  ISO3166XMLPath : String;

// Method to create/publish the ISO-3166 Country Codes Singleton
Function ISO3166CountryCodes : IISO3166CountryCodes;

Implementation

Uses GlobVar, CountryCodeUtils, GmXML;

Type
  TISO3166Country = Class(TInterfacedObject, IISO3166CountryDetails)
  Private
    FCountryCode2 : string;
    FCountryCode3 : string;
    FCountryCodeNumeric : string;
    FCountryName  : string;
    FIsECMember   : boolean;
    // PKR. 28/01/2016. ABSEXCH-17214. Add Intrastat Country Code
    FIntrastatCountry : string;

    // IISO3166CountryDetails
    Function GetCountryCode2 : string;
    Function GetCountryCode3 : string;
    Function GetCountryCodeNumeric : string;
    Function GetCountryName : string;
    // PKR. 11/12/2015. Added ec-member field for Intrastat
    Function GetECMembership : boolean;
    // PKR. 28/01/2016. ABSEXCH-17214. Add Intrastat Country Code
    Function GetIntrastatCountry : string;
  Public
    // PKR. 11/12/2015. Added ec-member field for Intrastat
    // PKR. 28/01/2016. ABSEXCH-17214. Add Intrastat Country Code
    Constructor Create (Const CountryCode2, CountryCode3, CountryCodeNumeric, CountryName : string; ECMember : boolean; IntrastatCountry : string);
  End; // TISO3166Country

  //------------------------------

  TISO3166CountryCodes = Class(TInterfacedObject, IISO3166CountryCodes)
  Private
    FCountryCodes : TInterfaceList;

    // IISO3166CountryCodes
    Function GetCount : Integer;
    Function GetCountryDetails(Index : Integer) : IISO3166CountryDetails;
    Function IndexOf (Const IndexField : enumIndexFieldType; Const FieldValue : String) : Integer;

    Procedure ReadXML;
  Public
    Constructor Create;
    Destructor Destroy; Override;
  End; // TISO3166CountryCodes

Var
  lISO3166CountryCodes : IISO3166CountryCodes;

//=========================================================================

// Method to create/publish the ISO-3166 Country Codes Singleton
Function ISO3166CountryCodes : IISO3166CountryCodes;
Var
  oISO3166CountryCodes : TISO3166CountryCodes;
Begin // ISO3166CountryCodes
  If (Not Assigned(lISO3166CountryCodes)) Then
  Begin
    oISO3166CountryCodes := TISO3166CountryCodes.Create;
    oISO3166CountryCodes.ReadXML;
    lISO3166CountryCodes := oISO3166CountryCodes;
  End; // If (Not Assigned(lISO3166CountryCodes))
  Result := lISO3166CountryCodes;
End; // ISO3166CountryCodes

//=========================================================================

// PKR. 28/01/2016. ABSEXCH-17214. Add Intrastat Country Code
Constructor TISO3166Country.Create (Const CountryCode2, CountryCode3, CountryCodeNumeric, CountryName : string; ECMember : boolean; IntrastatCountry : string);
Begin // Create
  Inherited Create;

  FCountryCode2 := CountryCode2;
  FCountryCode3 := CountryCode3;
  FCountryCodeNumeric := CountryCodeNumeric;
  FCountryName := CountryName;
  // PKR. 11/12/2015. Added ec-member field for Intrastat
  FIsECMember  := ECMember;
  // PKR. 28/01/2016. ABSEXCH-17214. Add Intrastat Country Code
  FIntrastatCountry := IntrastatCountry;
End; // Create

//-------------------------------------------------------------------------

Function TISO3166Country.GetCountryCode2 : string;
Begin // GetCountryCode2
  Result := FCountryCode2
End; // GetCountryCode2

Function TISO3166Country.GetCountryCode3 : string;
Begin // GetCountryCode3
  Result := FCountryCode3
End; // GetCountryCode3

Function TISO3166Country.GetCountryCodeNumeric : string;
Begin // GetCountryCodeNumeric
  Result := FCountryCodeNumeric
End; // GetCountryCodeNumeric

Function TISO3166Country.GetCountryName : string;
Begin // GetCountryName
  Result := FCountryName
End; // GetCountryName

// PKR. 11/12/2015. Added ec-member field for Intrastat
Function TISO3166Country.GetECMembership : boolean;
Begin // IsECMember
  Result := FIsECMember;
End; // IsECMember

// PKR. 28/01/2016. ABSEXCH-17214. Add Intrastat Country Code
Function TISO3166Country.GetIntrastatCountry : string;
Begin // GetIntrastatCountry
  Result := FIntrastatCountry;
End; // GetIntrastatCountry

//=========================================================================

Constructor TISO3166CountryCodes.Create;
Begin // Create
  Inherited Create;
  FCountryCodes := TInterfaceList.Create;
End; // Create

//------------------------------

Destructor TISO3166CountryCodes.Destroy;
Begin // Destroy
  FreeAndNIL(FCountryCodes);
  Inherited Destroy;
End; // Destroy

//-------------------------------------------------------------------------

Procedure TISO3166CountryCodes.ReadXML;
Var
  FXML : TGmXML;
  oCountryCodes, oCountry : TGmXMLNode;
  iCountry : Integer;
  OrigXMLAllowAttributeSpaces : Boolean;
  intrastatCountry : string;
  lDefaultCountry: String;
  lECMember: Boolean;
Begin // ReadXML
  // A bug in the XML parser removes the embedded spaces in the country name unless we override
  // the following setting
  OrigXMLAllowAttributeSpaces := gmXMLAllowAttributeSpaces;
  gmXMLAllowAttributeSpaces := True;
  Try
    FXML := TGmXML.Create(NIL);
    Try
      FXML.LoadFromFile(IncludeTrailingPathDelimiter(ISO3166XMLPath) + ISO3166XMLFileName);

      // NOTE: XML Parser is case sensitive

      oCountryCodes := FXML.Nodes.NodeByName['country-codes'];
      If Assigned(oCountryCodes) Then
      Begin
        lDefaultCountry := DefaultCountryCode(CurrentCountry, False);
        For iCountry := 0 To (oCountryCodes.Children.Count - 1) Do
        Begin
          oCountry := oCountryCodes.Children.Node[iCountry];
          If Assigned(oCountry) Then
          Begin
            // PKR. 11/12/2015. Added ec-member field for Intrastat
            // PKR. 28/01/2016. ABSEXCH-17214. Add Intrastat Country Code
            // If no Intrastat Country isspecified, use the ISO code.
            If (oCountry.Attributes.ElementByName['intrastat-country'] <> nil) Then
              intrastatCountry := oCountry.Attributes.ElementByName['intrastat-country'].Value
            Else
              intrastatCountry := oCountry.Attributes.ElementByName['alpha-2-code'].Value;

            // HV : 01/02/2017 R1 ABSEXCH-18153- Trader record - Country codes for main and delivery address
            // Also optimized the code for EC member
            If oCountry.Attributes.ElementByName['ec-member'] <> nil Then
              lECMember := Lowercase(oCountry.Attributes.ElementByName['ec-member'].Value) = 'yes'
            Else
              lECMember := False;

            If  oCountry.Attributes.ElementByName['alpha-2-code'].Value = lDefaultCountry Then
            Begin
              FCountryCodes.Insert(0, TISO3166Country.Create(oCountry.Attributes.ElementByName['alpha-2-code'].Value,
                                                             oCountry.Attributes.ElementByName['alpha-3-code'].Value,
                                                             oCountry.Attributes.ElementByName['numeric-code'].Value,
                                                             oCountry.Attributes.ElementByName['name'].Value,
                                                             lECMember,
                                                             IntrastatCountry));
            End
            Else
            Begin
              FCountryCodes.Add (TISO3166Country.Create(oCountry.Attributes.ElementByName['alpha-2-code'].Value,
                                                        oCountry.Attributes.ElementByName['alpha-3-code'].Value,
                                                        oCountry.Attributes.ElementByName['numeric-code'].Value,
                                                        oCountry.Attributes.ElementByName['name'].Value,
                                                        lECMember,
                                                        IntrastatCountry));
            End;
          End; // If Assigned(oCountry)
        End; // For iCountry
      End; // If Assigned(oCountryCodes)
    Finally
      FreeAndNIL(FXML);
    End; // Try..Finally
  Finally
    gmXMLAllowAttributeSpaces := OrigXMLAllowAttributeSpaces;
  End; // Try..Finally
End; // ReadXML

//-------------------------------------------------------------------------

Function TISO3166CountryCodes.IndexOf (Const IndexField : enumIndexFieldType; Const FieldValue : String) : Integer;
Var
  iCountry : Integer;
Begin // IndexOf
  Result := -1;

  For iCountry := 0 To (FCountryCodes.Count - 1) Do
  Begin
    With GetCountryDetails(iCountry) Do
    Begin
      Case IndexField Of
        ifCountry2       : If (FieldValue = cdCountryCode2) Then
                             Result := iCountry;
        ifCountry3       : If (FieldValue = cdCountryCode3) Then
                             Result := iCountry;
        ifCountryNumber  : If (FieldValue = cdCountryCodeNumeric) Then
                             Result := iCountry;
        // PKR. 11/12/2015. Added ec-member field for Intrastat
        ifECMember       : If (Lowercase(FieldValue) = 'yes') Then
                             Result := iCountry;
        // PKR. 28/01/2016. ABSEXCH-17214. Add Intrastat Country Code
        ifIntrastatCountry : if (FieldValue = cdIntrastatCountry) then
                             Result := iCountry;
      Else
        Raise Exception.Create ('TISO3166CountryCodes.IndexOf: Unhandled IndexField (' + IntToStr(Ord(IndexField)) + ')');
      End; // Case IndexField
    End; // With GetCountryDetails(iCountry)

    // Break out as soon as we have a match
    If (Result <> -1) Then
      Break;
  End; // For iCountry
End; // IndexOf

//-------------------------------------------------------------------------

Function TISO3166CountryCodes.GetCount : Integer;
Begin // GetCount
  Result := FCountryCodes.Count
End; // GetCount

//------------------------------

Function TISO3166CountryCodes.GetCountryDetails(Index : Integer) : IISO3166CountryDetails;
Begin // GetCountryDetails
  If (Index >= 0) And (Index < FCountryCodes.Count) Then
    Result := FCountryCodes.Items[Index] As IISO3166CountryDetails
  Else
    Raise Exception.Create ('TISO3166CountryCodes.GetCountryDetails: Invalid Index (' + IntToStr(Index) + '/' + IntToStr(FCountryCodes.Count) + ')');
End; // GetCountryDetails

//=========================================================================

Initialization
  lISO3166CountryCodes := NIL;
  ISO3166XMLPath := ExtractFilePath(Application.ExeName);
Finalization
  lISO3166CountryCodes := NIL;
End.