unit IntrastatXML;

{
  Implementation of a singleton object for handling Intrastat settings.
  Note that the settings are readonly.

  Usage:
    Use the singleton interface to access the exposed interface properties
       IntrastatSettings
    For example,
       dtCount := IntrastatSettings.DeliveryTermsCount;

    DeliveryTermsCount               Returns the number of Delivery Terms entries
    NatureOfTransactionCodesCount    Returns the number of Nature of Transaction entries
    ModesOfTransportCount            Returns the number of ModesOf Transport entries

    DeliveryTerms[index]             Returns the DeliveryTerms record at the specified index
    NatureOfTransactionCodes[index]  Returns the Nature of Transaction record at the specified index
    ModesOfTransport[index]          Returns the Mode of Transport record at the specified index

    IndexOf(SettingType, IndexField, FieldValue)   Returns the index of the specified setting

    A Country property has been added, which should be set to the Exchequer country code
    (eg 044 for UK, 353 for Eire) - NOT the ISO codes.
    This determines which part of the XML file to read, as it has been extended to
    support different sets of codes.
}

interface

uses
  Classes, Forms, SysUtils, FileUtil, GlobVar;

const
  IIntrastatSettingsXMLFileName = 'IntrastatFields.xml';

type
  enumSettingType     = (stDeliveryTerms, stNatureOfTransaction, stModeOfTransport); /// Setting types
  enumIndexFieldType = (ifCode, ifDescription); /// Field Types

  /// Interface for Delivery Terms settings
  IDeliveryTerms = interface
    ['{93D8C163-8555-4F44-91B1-F4C11F005B5C}']
    // --- Internal Methods to implement Public Properties ---
    Function GetDeliveryTermsCode : string; /// Accessor function for Delivery Terms code
    Function GetDeliveryTermsDescription : string; /// Accessor function for Delivery Terms description
    // ------------------ Public Properties ------------------
    Property Code        : string Read GetDeliveryTermsCode; /// Public property for the Delivery Terms code
    Property Description : string Read GetDeliveryTermsDescription; /// Public property for the Delivery Terms description
  end;

  /// Interface for Nature of Transaction Code settings
  INatureOfTransactionCode = interface
    ['{1ECB6C71-4889-4F53-A659-ACE689990BD4}']
    // --- Internal Methods to implement Public Properties ---
    Function GetNatureOfTransactionCode : string;  /// Accessor function for Nature of Transaction code
    Function GetNatureOfTransactionDescription : string;  /// Accessor function for Nature of Transaction description
    // ------------------ Public Properties ------------------
    Property Code        : string Read GetNatureOfTransactionCode; /// Public property for the Nature of Transaction code
    Property Description : string Read GetNatureOfTransactionDescription; /// Public property for the Nature of Transaction description
  end;

  /// Interface for Modes Of Transport settings
  IModeOfTransport = interface
    ['{93D8C163-8555-4F44-91B1-F4C11F005B5C}']
    // --- Internal Methods to implement Public Properties ---
    Function GetModeOfTransportCode : string;  /// Accessor function for Mode of Transport code
    Function GetModeOfTransportDescription : string;  /// Accessor function for Mode of Transport Description
    // ------------------ Public Properties ------------------
    Property Code        : string Read GetModeOfTransportCode; /// Public property for the Mode of Transport code
    Property Description : string Read GetModeOfTransportDescription; /// Public property for the Mode of Transport description
  end;

  // The Root Intrastat XML interface
  IIntrastatSettings = interface
    ['{006B803C-21DD-42ED-B7DB-787953329D53}']

    Function GetDeliveryTermsCount : Integer;  /// Returns the number of Delivery Terms entries
    Function GetNatureOfTransactionCount : Integer;  /// Returns the number of Nature of Transaction entries
    Function GetModesOfTransportCount : Integer;  /// Returns the number of Modes of Transport entries

    Function GetDeliveryTerms(Index : Integer) : IDeliveryTerms;  /// Returns the Delivery Terms item at the specified index
    function GetNatureOfTransactionCode(Index : Integer) : INatureOfTransactionCode;  /// Returns the Nature of Transaction item at the specified index
    function GetModeOfTransport(Index : Integer) : IModeOfTransport;  /// Returns the Mode of Transport item at the specified index

    // PKR. 20/01/2016. ABSEXCH-17171. Include support for Irish Intrastat codes.
    function GetCountry : string;               /// Gets the country code currently in use
    property Country : string read GetCountry;

    // Public properties
    property DeliveryTermsCount : integer read GetDeliveryTermsCount; /// Public property for the number of Delivery Terms entries
    property NatureOfTransactionCodesCount : Integer read GetNatureOfTransactionCount; /// Public property for the number of Nature of Transaction entries
    property ModesOfTransportCount : Integer read GetModesOfTransportCount; /// Public property for the number of ModesOf Transport entries

    property DeliveryTerms[index: integer] : IDeliveryTerms read GetDeliveryTerms; /// Public property for the Delivery Terms at the specified index
    property NatureOfTransactionCodes[index : integer] : INatureOfTransactionCode read GetNatureOfTransactionCode; /// Public property for the Nature of Transaction at the specified index
    property ModesOfTransport[index : integer] : IModeOfTransport read GetModeOfTransport; /// Public property for the Mode of Transport at the specified index

    Function IndexOf (Const SettingType: enumSettingType;
                      Const IndexField : enumIndexFieldType;
                      Const FieldValue : String) : Integer; /// Returns the index of the specified setting
    Procedure ReadXML(aCountry : string);
  end; // IIntrastatSettings

// Method to create/publish the IntrastatSettings Singleton
Function IntrastatSettings : IIntrastatSettings; overload;
// PKR. 21/01/2016. Alternative accessor to the Intrastat settings that specifies the country
Function IntrastatSettings(aCountry : string) : IIntrastatSettings; overload;

implementation

Uses
  GmXML;

type
  TDeliveryTerms = class(TInterfacedObject, IDeliveryTerms)
    fCode        : string; /// Delivery Terms code
    fDescription : string; /// Delivery Terms description

    Function GetDeliveryTermsCode : string;
    Function GetDeliveryTermsDescription : string;
  public
    Constructor Create(Const aCode, aDescription : string);
  end;

  TNatureOfTransactionCode = class(TInterfacedObject, INatureOfTransactionCode)
    fCode        : string; /// Nature of Transaction code
    fDescription : string; /// Nature of Transaction description

    Function GetNatureOfTransactionCode : string;
    Function GetNatureOfTransactionDescription : string;
  public
    Constructor Create(Const aCode, aDescription : string);
  end;

  TModeOfTransport = class(TInterfacedObject, IModeOfTransport)
    fCode        : string; /// Mode of Transport code
    fDescription : string; /// Mode of transport description

    Function GetModeOfTransportCode : string;
    Function GetModeOfTransportDescription : string;
  public
    Constructor Create(Const aCode, aDescription : string);
  end;


  //----------------------------------------------------------------------------
  { TIntrastatXML - the top level class}
  TIntrastatXML = class(TInterfacedObject, IIntrastatSettings)
  private
    FDeliveryTerms            : TInterfaceList;
    FNatureOfTransactionCodes : TInterfaceList;
    FModesOfTransport         : TInterfaceList;
    // PKR. 20/01/2016. ABSEXCH-17171. Include support for Irish Intrastat codes.
    FCurrentCountry           : string;
  protected
    Function GetDeliveryTerms(Index : Integer) : IDeliveryTerms;
    function GetNatureOfTransactionCode(Index : Integer) : INatureOfTransactionCode;
    function GetModeOfTransport(Index : Integer) : IModeOfTransport;

    // Interface methods
    Function GetDeliveryTermsCount : Integer;
    Function GetNatureOfTransactionCount : Integer;
    Function GetModesOfTransportCount : Integer;

    // PKR. 20/01/2016. ABSEXCH-17171. Include support for Irish Intrastat codes.
    function  GetCountry : string;               /// Gets the country code currently in use
    procedure ClearDeliveryTerms;
    procedure ClearNatureOfTransactions;
    procedure ClearModesOfTransport;

    Procedure ReadXML(aCountry : string);
  public
    Constructor Create;
    Destructor Destroy; Override;
    Function IndexOf (Const SettingType: enumSettingType; Const IndexField : enumIndexFieldType; Const FieldValue : String) : Integer;
  end;


Var
  IntrastatFieldsPath : String;
  IntrastatSettingsInf  : IIntrastatSettings;

// Method to create/publish the IntrastatFields Singleton
Function IntrastatSettings : IIntrastatSettings;
Var
  oIntrastatSettings : TIntrastatXML;
Begin
  If (Not Assigned(IntrastatSettingsInf)) Then
  Begin
    oIntrastatSettings := TIntrastatXML.Create;
    IntrastatSettingsInf := oIntrastatSettings;
  End;
  Result := IntrastatSettingsInf;

  // PKR. 20/01/2016. ABSEXCH-17171. Include support for Irish Intrastat codes.
  // If the current country has changed, then reload it.
  if (IntrastatSettingsInf.Country <> CurrentCountry) then
    IntrastatSettingsInf.ReadXML(CurrentCountry);
End;

// PKR. 21/01/2016. Alternative method to create/publish the IntrastatFields Singleton
Function IntrastatSettings(aCountry : string) : IIntrastatSettings;
Var
  oIntrastatSettings : TIntrastatXML;
Begin
  If (Not Assigned(IntrastatSettingsInf)) Then
  Begin
    oIntrastatSettings := TIntrastatXML.Create;
    IntrastatSettingsInf := oIntrastatSettings;
  End;
  Result := IntrastatSettingsInf;

  // PKR. 20/01/2016. ABSEXCH-17171. Include support for Irish Intrastat codes.
  // If the current country has changed, then reload it.
  if (IntrastatSettingsInf.Country <> aCountry) then
    IntrastatSettingsInf.ReadXML(aCountry);
End;

//==============================================================================
Constructor TIntrastatXML.Create;
Begin
  Inherited Create;

  FDeliveryTerms            := TInterfaceList.Create;
  FNatureOfTransactionCodes := TInterfaceList.Create;
  FModesOfTransport         := TInterfaceList.Create;

  // PKR. 20/01/2016. ABSEXCH-17171. Include support for Irish Intrastat codes.
  FCurrentCountry           := '';
End;

//------------------------------------------------------------------------------
Destructor TIntrastatXML.Destroy;
Begin
  FDeliveryTerms.Free;
  FNatureOfTransactionCodes.Free;
  FModesOfTransport.Free;

  Inherited Destroy;
End;

//------------------------------------------------------------------------------
Procedure TIntrastatXML.ReadXML(aCountry : string);
Var
  FXML : TGmXML;
  oIntrastratNode : TGmXMLNode;
  oSection        : TGmXMLNode;
  iSection        : integer;
  iCountryIndex   : integer;
  oLeafNode       : TGmXMLNode;
  iLeaf           : integer;
  cNode           : TGmXMLNode;

  OrigXMLAllowAttributeSpaces : Boolean;
Begin // ReadXML
  // A bug in the XML parser removes the embedded spaces in the country name unless we override
  // the following setting
  OrigXMLAllowAttributeSpaces := gmXMLAllowAttributeSpaces;
  gmXMLAllowAttributeSpaces := True;
  Try
    FXML := TGmXML.Create(NIL);

    // PKR. 20/01/2016. ABSEXCH-17171. Include support for Irish Intrastat codes.
    // We could be reloading, so we need to empty the lists
    ClearDeliveryTerms;
    ClearNatureOfTransactions;
    ClearModesOfTransport;

    Try
      FXML.LoadFromFile(IncludeTrailingPathDelimiter(IntrastatFieldsPath) + IIntrastatSettingsXMLFileName);

      // NOTE: XML Parser is case sensitive
      oIntrastratNode := FXML.Nodes.NodeByName['IntrastatSettings'];

      If Assigned(oIntrastratNode) Then
      Begin
        // PKR. 20/01/2016. ABSEXCH-17171. Include support for Irish Intrastat codes.
        // We found the root node, so look for the dataset that is for the current country.
        For iCountryIndex := 0 To (oIntrastratNode.Children.Count - 1) do
        begin
          cNode := oIntrastratNode.Children.Node[iCountryIndex];
          // See if this node contains the required data
          if cNode.Attributes.ElementByName['Code'].Value = aCountry then
          begin
            // Found the country, so set the value in the Intrastat Settings singleton
            FCurrentCountry := aCountry;
            // Found the node for the current country, so load the data
            // Look for and read the DeliveryTerms, NatureOfTransactionCodes and ModesOfTransport
            For iSection := 0 To (cNode.Children.Count - 1) Do
            Begin
              oSection := cNode.Children.Node[iSection];
              if Assigned(oSection) then
              begin
                // Determine the section.  This allows them to be processed in any order.
                if oSection.Name = 'DeliveryTerms' then
                begin
                  if oSection.Children.Count > 0 then
                  begin
                    for iLeaf := 0 to (oSection.Children.Count-1) do
                    begin
                      oLeafNode := oSection.Children.Node[iLeaf];
                      // MH 06/06/2016 2016-R2 ABSEXCH-17336: Called new AsDisplayString method which expands escaped characters
                      FDeliveryTerms.Add(TDeliveryTerms.Create(oLeafNode.Attributes.ElementByName['Code'].AsDisplayString, //Value,
                                                               oLeafNode.Attributes.ElementByName['Description'].AsDisplayString)); //Value));
                    end;
                  end;
                end;  // section is DeliveryTerms

                if oSection.Name = 'NatureOfTransactionCodes' then
                begin
                  if oSection.Children.Count > 0 then
                  begin
                    for iLeaf := 0 to (oSection.Children.Count-1) do
                    begin
                      oLeafNode := oSection.Children.Node[iLeaf];
                      // MH 06/06/2016 2016-R2 ABSEXCH-17336: Called new AsDisplayString method which expands escaped characters
                      FNatureOfTransactionCodes.Add(TNatureOfTransactionCode.Create(oLeafNode.Attributes.ElementByName['Code'].AsDisplayString, //Value,
                                                                oLeafNode.Attributes.ElementByName['Description'].AsDisplayString)); //Value));
                    end;
                  end;
                end;  // section is NatureOfTransactionCodes

                if oSection.Name = 'ModesOfTransport' then
                begin
                  if oSection.Children.Count > 0 then
                  begin
                    for iLeaf := 0 to (oSection.Children.Count-1) do
                    begin
                      oLeafNode := oSection.Children.Node[iLeaf];
                      // MH 06/06/2016 2016-R2 ABSEXCH-17336: Called new AsDisplayString method which expands escaped characters
                      FModesOfTransport.Add(TModeOfTransport.Create(oLeafNode.Attributes.ElementByName['Code'].AsDisplayString, //Value,
                                                               oLeafNode.Attributes.ElementByName['Description'].AsDisplayString)); //Value));
                    end;
                  end;
                end; // Section is ModeOfTransport
              end; // if assigned(oSection)
            end;  // for each child node

            break;
          end;  // if the country we're looking for
        End; // For iSection
      end; // if Assigned (oIntrastatNode)
    Finally
      FreeAndNIL(FXML);
    End; // Try..Finally
  Finally
    gmXMLAllowAttributeSpaces := OrigXMLAllowAttributeSpaces;
  End; // Try..Finally
End; // ReadXML


//------------------------------------------------------------------------------
function TIntrastatXML.GetDeliveryTermsCount : integer;
begin
  Result := FDeliveryTerms.Count;
end;

function TIntrastatXML.GetNatureOfTransactionCount : integer;
begin
  Result := FNatureOfTransactionCodes.Count;
end;

function TIntrastatXML.GetModesOfTransportCount : integer;
begin
  Result := FModesOfTransport.Count;
end;

//------------------------------------------------------------------------------
// PKR. 20/01/2016. ABSEXCH-17171. Include support for Irish Intrastat codes.
function TIntrastatXML.GetCountry : string;
begin
  Result := FCurrentCountry;
end;

//------------------------------------------------------------------------------
// PKR. 20/01/2016. ABSEXCH-17171. Include support for Irish Intrastat codes.
procedure TIntrastatXML.ClearDeliveryTerms;
begin
  FDeliveryTerms.Clear;
end;

procedure TIntrastatXML.ClearNatureOfTransactions;
begin
  FNatureOfTransactionCodes.Clear;
end;

procedure TIntrastatXML.ClearModesOfTransport;
begin
  FModesOfTransport.Clear;
end;

//------------------------------------------------------------------------------
Function TIntrastatXML.IndexOf(Const SettingType: enumSettingType; Const IndexField : enumIndexFieldType; Const FieldValue : String) : Integer;
var
  iDetail : integer;
begin  // IndexOf
  Result := -1;

  case SettingType of
    stDeliveryTerms:
      begin
        for iDetail := 0 to (FDeliveryTerms.Count-1) do
        begin
          with GetDeliveryTerms(iDetail) do
          begin
            case IndexField of
              ifCode        : if (Lowercase(FieldValue) = Lowercase(Code)) then Result := iDetail;
              ifDescription : if (Lowercase(FieldValue) = Lowercase(Description)) then Result := iDetail;
            else
              raise Exception.Create('TIntrastatXML.IndexOf: Unhandled IndexField(' + IntToStr(Ord(IndexField)) + ')');
            end; // case
          end; // with

        if (Result <> -1) then
          break;
        end; // for
      end;

    stNatureOfTransaction:
      begin
        for iDetail := 0 to (FNatureOfTransactionCodes.Count-1) do
        begin
          with GetNatureOfTransactionCode(iDetail) do
          begin
            case IndexField of
              ifCode        : if (Lowercase(FieldValue) = Lowercase(Code)) then Result := iDetail;
              ifDescription : if (Lowercase(FieldValue) = Lowercase(Description)) then Result := iDetail;
            else
              raise Exception.Create('TIntrastatXML.IndexOf: Unhandled IndexField(' + IntToStr(Ord(IndexField)) + ')');
            end; // case
          end; // with

        if (Result <> -1) then
          break;
        end; // for
      end;

    stModeOfTransport:
      begin
        for iDetail := 0 to (FModesOfTransport.Count-1) do
        begin
          with GetModeOfTransport(iDetail) do
          begin
            case IndexField of
              ifCode        : if (Lowercase(FieldValue) = Lowercase(Code)) then Result := iDetail;
              ifDescription : if (Lowercase(FieldValue) = Lowercase(Description)) then Result := iDetail;
            else
              raise Exception.Create('TIntrastatXML.IndexOf: Unhandled IndexField(' + IntToStr(Ord(IndexField)) + ')');
            end; // case
          end; // with

        if (Result <> -1) then
          break;
        end; // for
      end;
    else
      raise Exception.Create('TIntrastatXML.IndexOf: Unhandled SettingType(' + IntToStr(Ord(SettingType)) + ')');
  end;
end;  // IndexOf

//------------------------------------------------------------------------------
Function TIntrastatXML.GetDeliveryTerms(Index : Integer) : IDeliveryTerms;
Begin // GetDeliveryTerms
  If (Index >= 0) And (Index < FDeliveryTerms.Count) Then
    Result := FDeliveryTerms.Items[Index] As IDeliveryTerms
  Else
    Raise Exception.Create ('TIntrastatXML.GetDeliveryTerms: Invalid Index (' + IntToStr(Index) + '/' + IntToStr(FDeliveryTerms.Count) + ')');
End; // GetDeliveryTerms

//------------------------------------------------------------------------------
Function TIntrastatXML.GetNatureOfTransactionCode(Index : Integer) : INatureOfTransactionCode;
Begin // GetNatureOfTransactionCode
  If (Index >= 0) And (Index < FNatureOfTransactionCodes.Count) Then
    Result := FNatureOfTransactionCodes.Items[Index] As INatureOfTransactionCode
  Else
    Raise Exception.Create ('TIntrastatXML.GetNatureOfTransactionCode: Invalid Index (' + IntToStr(Index) + '/' + IntToStr(FNatureOfTransactionCodes.Count) + ')');
End; // GetNatureOfTransactionCode

//------------------------------------------------------------------------------
Function TIntrastatXML.GetModeOfTransport(Index : Integer) : IModeOfTransport;
Begin // GetModeOfTransport
  If (Index >= 0) And (Index < FModesOfTransport.Count) Then
    Result := FModesOfTransport.Items[Index] As IModeOfTransport
  Else
    Raise Exception.Create ('TIntrastatXML.GetModeOfTransport: Invalid Index (' + IntToStr(Index) + '/' + IntToStr(FModesOfTransport.Count) + ')');
End; // GetModeOfTransport


//==============================================================================
// DELIVERY TERMS
//==============================================================================
Constructor TDeliveryTerms.Create(Const aCode, aDescription : string);
Begin // Create
  Inherited Create;

  FCode := aCode;
  FDescription := aDescription;
End; // Create

Function TDeliveryTerms.GetDeliveryTermsCode : string;
Begin // GetDeliveryTermsCode
  Result := fCode;
End; // GetDeliveryTermsCode

Function TDeliveryTerms.GetDeliveryTermsDescription : string;
Begin // GetDeliveryTermsDescription
  Result := fDescription;
End; // GetDeliveryTermsDescription

//==============================================================================
// NATURE OF TRANSACTION
//==============================================================================
Constructor TNatureOfTransactionCode.Create(Const aCode, aDescription : string);
Begin // Create
  Inherited Create;

  FCode := aCode;
  FDescription := aDescription;
End; // Create

Function TNatureOfTransactionCode.GetNatureOfTransactionCode : string;
Begin // GetNoTCCode
  Result := fCode;
End; // GetNoTCCode

Function TNatureOfTransactionCode.GetNatureOfTransactionDescription : string;
Begin // NatureOfTransactionDescription
  Result := fDescription;
End; // NatureOfTransactionDescription


//==============================================================================
// MODE OF TRANSPORTATION
//==============================================================================
Constructor TModeOfTransport.Create(Const aCode, aDescription : string);
Begin // Create
  Inherited Create;

  FCode := aCode;
  FDescription := aDescription;
End; // Create

Function TModeOfTransport.GetModeOfTransportCode : string;
Begin // GetModeOfTransportCode
  Result := fCode;
End; // GetModeOfTransportCode

Function TModeOfTransport.GetModeOfTransportDescription : string;
Begin // GetModeOfTransportDescription
  Result := fDescription;
End; // GetModeOfTransportDescription



//==============================================================================

Initialization
  IntrastatSettingsInf := NIL;
  // PKR. 18/01/2016. ABSEXCH-17156. Pick up correct directory for location of
  // IntrastatFields.xml so that it works with toolkit apps (i.e. apps running
  // outside the Exchequer directory).
  IntrastatFieldsPath := GetEnterpriseDirectory;

Finalization
  IntrastatSettingsInf := NIL;

end.
