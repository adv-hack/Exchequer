unit oIRISLicence;

interface

Uses
  Contnrs, SysUtils,
  ELITE_COM_TLB,        // IRIS Licencing Type Library
  GmXML;                // XML Parsing component

Const
  // Component Names
  coCore = 'Exchequer LITE Core Module';
  coStock = 'Exchequer LITE Stock Module';
  coSPOP = 'Exchequer LITE SPOP Module';
  coMultiCurrency = 'Exchequer LITE Multi-Currency Module';

  // Initial Restriction Names
  IRDemo = 'Demo Or Live';

  // Licence Restriction Names
  LRLITEVersion = 'IAO Version';

  LRCompanyName = 'Company Name';
  LRTheme = 'Theme';

  LRCountryCode = 'Country Code';
  LRLITEType = 'Installation Type';

  LRUserCount = 'User Count';
  LRCompanyCount = 'Client Count';

  //LRPervasiveVersion = 'Pervasive Version';
  LRPervasiveKey = 'Pervasive CD Key';


Type
  {$Warnings Off}
  // Setup a local alias without warnings to get rid of all the platform warnings you
  // get by referencing IEliteCOM directly
  IIRISLicencing = IEliteCOM;
  {$Warnings On}

  //------------------------------

  TIRISLicence = Class;

  //------------------------------

  TIRISComponent = Class(TObject)
  Private
    FComponentId : LongInt;
    FComponentName : ShortString;
  Public
    Property ComponentId : LongInt Read FComponentId;
    Property ComponentName : ShortString Read FComponentName;

    Constructor Create;
    Function LoadFromXML(Const oComponentNode : TGmXMLNode) : Boolean;
  End; // TIRISComponent

  //------------------------------

  TIRISComponentList = Class(TObject)
  Private
    // The list of TIRISComponent objects for the current CD-Key
    FComponents : TObjectList;

    Function GetCount : SmallInt;
    Function GetComponents (Index : SmallInt) : TIRISComponent;

    Procedure Add (NewComponent : TIRISComponent);
    Procedure Clear;
  Public
    Property Count : SmallInt Read GetCount;
    Property Component [Index : SmallInt] : TIRISComponent Read GetComponents; Default;

    Constructor Create;
    Destructor Destroy; Override;

    Function IndexOf (ComponentName : ShortString) : SmallInt;
  End; // TIRISComponentList

  //-------------------------------------------------------------------------

  TIRISInitialRestriction = Class(TObject)
  Private
    FRestrictionId : LongInt;
    FRestrictionName : ShortString;
  Public
    Property RestrictionId : LongInt Read FRestrictionId;
    Property RestrictionName : ShortString Read FRestrictionName;

    Constructor Create;
    Function LoadFromXML(Const oRestrictionNode : TGmXMLNode) : Boolean;
  End; // TIRISInitialRestriction

  //------------------------------

  TIRISInitialRestrictionList = Class(TObject)
  Private
    // The list of TIRISInitialRestriction objects for the current CD-Key
    FRestrictions : TObjectList;

    Function GetCount : SmallInt;
    Function GetRestrictions (Index : SmallInt) : TIRISInitialRestriction;

    Procedure Add (NewRestriction : TIRISInitialRestriction);
    Procedure Clear;
  Public
    Property Count : SmallInt Read GetCount;
    Property Restriction [Index : SmallInt] : TIRISInitialRestriction Read GetRestrictions; Default;

    Constructor Create;
    Destructor Destroy; Override;

    Function IndexOf (RestrictionName : ShortString) : SmallInt;
  End; // TIRISInitialRestrictionList

  //-------------------------------------------------------------------------

  TIRISLicenceCode = Class(TObject)
  Private
    // Reference to Root Object needed to access the COM Object and other properties
    FIRISLicence : TIRISLicence;

    FLicenceCode : ShortString;

    Procedure DecodeLicence;
  Public
    Property LicenceCode : ShortString Read FLicenceCode;

    Constructor Create (Const IRISLicence : TIRISLicence; Const LicenceCode : ShortString);
    Destructor Destroy; Override;

    // Calls the ValidateLicence method on the IRIS Licencing COM Object
    Function Validate : Boolean;
  End; // TIRISLicenceCode

  //------------------------------

  TIRISLicenceCodeList = Class(TObject)
  Private
    // Reference to Root Object needed to access the COM Object and other properties
    FIRISLicence : TIRISLicence;

    // The list of TIRISLicenceCode objects for the current CD-Key
    FLicenceCodes : TObjectList;

    Function GetCount : SmallInt;
    Function GetLicenceCodes (Index : SmallInt) : TIRISLicenceCode;
  Public
    Property Count : SmallInt Read GetCount;
    Property LicenceCode [Index : SmallInt] : TIRISLicenceCode Read GetLicenceCodes; Default;

    Constructor Create (Const IRISLicence : TIRISLicence);
    Destructor Destroy; Override;

    Function Add (Const NewLicenceCode : ShortString) : TIRISLicenceCode;
    Procedure Clear;
    Procedure Delete(Const Index : SmallInt);
  End; // TIRISLicenceCodeList

  //-------------------------------------------------------------------------

  TIRISLicenceRestriction = Class(TObject)
  Private
    // Reference to Root Object needed to access the COM Object and other properties
    FIRISLicence : TIRISLicence;

    FParentLicence : TIRISLicenceCode;
    FRestrictionDesc : ShortString;
    FRestrictionId : LongInt;
    FValueId : LongInt;
    FValueString : ShortString;

    Function GetValueAsInt : LongInt;
    Procedure SetValueString(Value : ShortString);
  Public
    Property ParentLicence : TIRISLicenceCode Read FParentLicence;
    Property RestrictionDesc : ShortString Read FRestrictionDesc;
    Property RestrictionId : LongInt Read FRestrictionId;
    Property ValueId : LongInt Read FValueId;
    Property Value : ShortString Read FValueString Write SetValueString;
    Property ValueAsInt : LongInt Read GetValueAsInt;

    Constructor Create (Const IRISLicence : TIRISLicence; Const ParentLicence : TIRISLicenceCode);
    Destructor Destroy; Override;

    Function LoadFromXML(Const oRestrictionNode : TGmXMLNode) : Boolean;
  End; // TIRISLicenceRestriction

  //------------------------------

  TIRISLicenceRestrictionList = Class(TObject)
  Private
    // Reference to Root Object needed to access the COM Object and other properties
    FIRISLicence : TIRISLicence;

    // The list of TIRISLicenceRestriction objects for the current CD-Key
    FRestrictions : TObjectList;

    Function GetCount : SmallInt;
    Function GetRestrictions (Index : SmallInt) : TIRISLicenceRestriction;

    Procedure Add (NewRestriction : TIRISLicenceRestriction);
    Procedure Clear;

    // Deletes any LicenceRestriction objects with the specified ParentLicence
    Procedure DeleteLicenceCode(Const ParentLicence : TIRISLicenceCode);
  Public
    Property Count : SmallInt Read GetCount;
    Property Restriction [Index : SmallInt] : TIRISLicenceRestriction Read GetRestrictions; Default;

    Constructor Create (Const IRISLicence : TIRISLicence);
    Destructor Destroy; Override;

    Function IndexOf (Const RestrictionId, ValueId : LongInt) : SmallInt; Overload;
    Function IndexOf (RestrictionDesc : ShortString) : SmallInt; Overload;
  End; // TIRISLicenceRestrictionList

  //-------------------------------------------------------------------------

  TIRISLicence = Class(TObject)
  Private
    // Reference to the IRIS Licencing COM Object
    FLicencingInterface: IIRISLicencing;

    // The current CD-Key
    FCDKey : ShortString;
    // The current Customer Number
    FCustomerNumber : ShortString;

    FActivationKey : ShortString;
    FActivationDate : TDateTime;

    FComponents : TIRISComponentList;
    FInitialRestrictions : TIRISInitialRestrictionList;
    FLicenceCodes : TIRISLicenceCodeList;
    FLicenceRestrictions : TIRISLicenceRestrictionList;

    Procedure SetCDKey (Value : ShortString);

    Function ParseActivation (Const sXMLResult : ANsIString; Var sError : ANsIString) : Boolean;

    // Parses the <Components> section of the DecodeCDKey results to extract
    // the <CDKeyComponents> sections
    Procedure ParseComponents (oNode : TGmXmlNode);

    // Parses the <InitialRestrictions> section of the DecodeCDKey results to extract
    // the <CDKeyInitialRestrictions> sections
    Procedure ParseInitialRestrictions (oNode : TGmXmlNode);

    // Parses the <ArrayOfRestrictionValues> element returned from GetLicenceRestrictionsWS
    // and updates the appropriate TIRISLicenceRestriction objects
    Procedure ParseLicenceRestrictions (Const XMLRestrict : ANSIString);

    Property IRISLicencing : IIRISLicencing Read FLicencingInterface;
  Public
    Property ActivationDate : TDateTime Read FActivationDate;
    Property ActivationKey : ShortString Read FActivationKey;
    Property CDKey : ShortString Read FCDKey Write SetCDKey;
    Property Components : TIRISComponentList Read FComponents;
    Property CustomerNumber : ShortString Read FCustomerNumber;
    Property LicenceCodes : TIRISLicenceCodeList Read FLicenceCodes;
    Property LicenceRestrictions : TIRISLicenceRestrictionList Read FLicenceRestrictions;
    Property InitialRestrictions : TIRISInitialRestrictionList Read FInitialRestrictions;

    Constructor Create;
    Destructor Destroy; Override;

    // Removes any previously specified Licence Limits from the COM Object
    Procedure ClearLicenceLimits;

    // Validates and decodes the supplied Activation Key
    Function DecodeActivationKey(Const ActivationKey : ShortString; Var ErrString : ANSIString) : Boolean;

    // Contacts the Web-Service and downloads the Activation Key for the current CD-Key
    Function GetActivationKey (Var ErrString : ANSIString) : Boolean;

    // Contacts the Web-Service and downloads the Licence Info for the current CD-Key including
    // Licence Codes and the Restriction Limits for each Licence Code
    Function GetLicenceCodes (Var ErrString : ANSIString) : Boolean;
  End; // TIRISLicence

implementation

Uses {$IFDEF LICDEBUG}TestF,{$ENDIF} Dialogs, StrUtils;

Const
  // Name of the <Components> section in the DecodeCDKey results
  sComponents = 'Components';
  // Name of the <CDKeyComponents> sections within the <Components> section
  sCDKeyComponent = 'CDKeyComponents';
  // Name of the <CustomerNumber> leaf
  sCustomerNumber = 'CustomerNumber';
  // Name of the <InitialRestrictions> sections within the <Components> section
  sInitialRestrictions = 'InitialRestrictions';
  // Name of the <CDKeyInitialRestrictions> leaves within each <InitialRestrictions> section
  sCDKeyInitialRestrictions = 'CDKeyInitialRestrictions';

//=========================================================================

Constructor TIRISComponent.Create;
Begin // Create
  Inherited Create;

  FComponentId := -1;
  FComponentName := '';
End; // Create

//-------------------------------------------------------------------------

Function TIRISComponent.LoadFromXML(Const oComponentNode : TGmXMLNode) : Boolean;
Var
  oNode : TGmXMLNode;
Begin // LoadFromXML
  oNode := oComponentNode.Children.NodeByName['ComponentID'];
  If Assigned(oNode) Then
  Begin
    FComponentId := oNode.AsInteger;
  End; // If Assigned(oNode)

  oNode := oComponentNode.Children.NodeByName['ComponentsName'];
  If Assigned(oNode) Then
  Begin
    FComponentName := Trim(oNode.AsString);
  End; // If Assigned(oNode)

  Result := (FComponentId <> -1) And (FComponentName <> '');
End; // LoadFromXML

//=========================================================================

Constructor TIRISComponentList.Create;
Begin // Create
  Inherited Create;
  FComponents := TObjectList.Create;
End; // Create

//------------------------------

Destructor TIRISComponentList.Destroy;
Begin // Destroy
  FreeAndNIL(FComponents);
  Inherited Destroy;
End; // Destroy

//-------------------------------------------------------------------------

Function TIRISComponentList.GetCount : SmallInt;
Begin // GetCount
  Result := FComponents.Count;
End; // GetCount

//------------------------------

Function TIRISComponentList.GetComponents (Index : SmallInt) : TIRISComponent;
Begin // GetComponents
  If (Index >= 0) And (Index < FComponents.Count) Then
    Result := TIRISComponent(FComponents.Items[Index])
  Else
    Raise Exception.Create ('TIRISComponentList.GetComponents: Invalid Component Index');
End; // GetComponents

//-------------------------------------------------------------------------

Procedure TIRISComponentList.Add (NewComponent : TIRISComponent);
Begin // Add
  FComponents.Add(NewComponent);
End; // Add

//-------------------------------------------------------------------------

Procedure TIRISComponentList.Clear;
Begin // Clear
  FComponents.Clear;
End; // Clear

//-------------------------------------------------------------------------

//Function TIRISComponentList.IndexOf (ComponentId : LongInt) : SmallInt;
//Var
//  I : SmallInt;
//Begin // IndexOf
//  Result := -1;
//
//  If (FComponents.Count > 0) Then
//  Begin
//    For I := 0 To (FComponents.Count - 1) Do
//    Begin
//      If (GetComponents (I).ComponentId = ComponentId) Then
//      Begin
//        Result := I;
//        Break;
//      End; // If (GetComponents (I).ComponentId = ComponentId)
//    End; // For I
//  End; // If (FComponents.Count > 0)
//End; // IndexOf

//------------------------------

Function TIRISComponentList.IndexOf (ComponentName : ShortString) : SmallInt;
Var
  I : SmallInt;
Begin // IndexOf
  Result := -1;

  ComponentName := UpperCase(Trim(ComponentName));

  If (FComponents.Count > 0) Then
  Begin
    For I := 0 To (FComponents.Count - 1) Do
    Begin
      If (UpperCase(GetComponents (I).ComponentName) = ComponentName) Then
      Begin
        Result := I;
        Break;
      End; // If (UpperCase(GetComponents (I).ComponentName) = ComponentName)
    End; // For I
  End; // If (FComponents.Count > 0)
End; // IndexOf

//=========================================================================

Constructor TIRISInitialRestriction.Create;
Begin // Create
  Inherited Create;

  FRestrictionId := -1;
  FRestrictionName := '';
End; // Create

//-------------------------------------------------------------------------

Function TIRISInitialRestriction.LoadFromXML(Const oRestrictionNode : TGmXMLNode) : Boolean;
Var
  oNode : TGmXMLNode;
Begin // LoadFromXML
  oNode := oRestrictionNode.Children.NodeByName['InitialRestrictionID'];
  If Assigned(oNode) Then
  Begin
    FRestrictionId := oNode.AsInteger;
  End; // If Assigned(oNode)

  oNode := oRestrictionNode.Children.NodeByName['InitialRestrictionName'];
  If Assigned(oNode) Then
  Begin
    FRestrictionName :=Trim(oNode.AsString);
  End; // If Assigned(oNode)

  Result := (FRestrictionId <> -1) And (FRestrictionName <> '');
End; // LoadFromXML

//=========================================================================

Constructor TIRISInitialRestrictionList.Create;
Begin // Create
  Inherited Create;
  FRestrictions := TObjectList.Create;
End; // Create

//------------------------------

Destructor TIRISInitialRestrictionList.Destroy;
Begin // Destroy
  FreeAndNIL(FRestrictions);
  Inherited Destroy;
End; // Destroy

//-------------------------------------------------------------------------

Function TIRISInitialRestrictionList.GetCount : SmallInt;
Begin // GetCount
  Result := FRestrictions.Count;
End; // GetCount

//------------------------------

Function TIRISInitialRestrictionList.GetRestrictions (Index : SmallInt) : TIRISInitialRestriction;
Begin // GetRestrictions
  If (Index >= 0) And (Index < FRestrictions.Count) Then
    Result := TIRISInitialRestriction(FRestrictions.Items[Index])
  Else
    Raise Exception.Create ('TIRISInitialRestrictionList.GetRestrictions: Invalid Restriction Index');
End; // GetRestrictions

//-------------------------------------------------------------------------

Procedure TIRISInitialRestrictionList.Add (NewRestriction : TIRISInitialRestriction);
Begin // Add
  FRestrictions.Add(NewRestriction);
End; // Add

//-------------------------------------------------------------------------

Procedure TIRISInitialRestrictionList.Clear;
Begin // Clear
  FRestrictions.Clear;
End; // Clear

//-------------------------------------------------------------------------

Function TIRISInitialRestrictionList.IndexOf (RestrictionName : ShortString) : SmallInt;
Var
  oRestrict : TIRISInitialRestriction;
  I : SmallInt;
Begin // IndexOf
  Result := -1;

  RestrictionName := UpperCase(Trim(RestrictionName));

  For I := 0 To (FRestrictions.Count - 1) Do
  Begin
    oRestrict := TIRISInitialRestriction(FRestrictions.Items[I]);

    If (UpperCase(oRestrict.RestrictionName) = RestrictionName) Then
    Begin
      Result := I;
      Break;
    End; // If (UpperCase(oRestrict.RestrictionName) = RestrictionName)
  End; // For I
End; // IndexOf

//=========================================================================

Constructor TIRISLicenceCode.Create (Const IRISLicence : TIRISLicence; Const LicenceCode : ShortString);
Begin // Create
  Inherited Create;

  FIRISLicence := IRISLicence;

  FLicenceCode := LicenceCode;
  DecodeLicence;
End; // Create

//------------------------------

Destructor TIRISLicenceCode.Destroy;
Begin // Destroy
  // Remove any Licence Restrictions for this Licence Code
  FIRISLicence.LicenceRestrictions.DeleteLicenceCode(Self);

  FIRISLicence := NIL;

  Inherited Destroy;
End; // Destroy

//-------------------------------------------------------------------------

// Retrieves and parses the Restriction XML string returned from DecodeLicenceCode and adds
// the restrictions into the Restrictions List
Procedure TIRISLicenceCode.DecodeLicence;
Var
  sResult          : ANSIString;
  oXML             : TGmXML;
  oXMLRestrictNode, oXMLDecoded, oRestrictionLimitsNode : TGmXMLNode;
  oIRISRestriction : TIRISLicenceRestriction;
  I, J             : SmallInt;
Begin // DecodeLicence
  // Get an restrictions associated with the Licence Code and add them into
  // the Restrictions List
  sResult := FIRISLicence.IRISLicencing.DecodeLicenceCode(FIRISLicence.CDKey, FLicenceCode);

{$IFDEF LICDEBUG}
  AddXMLToLog (sResult);
{$ENDIF}

  oXML := TGmXML.Create(NIL);
  Try
    oXML.Text := sResult;

    // Run through the <DecodedRestriction> elements within each <Restrictions> elements and
    // extract the <DecodedRestrictionValue> elements:-
    //
    //    <DecodedLicenceCodes xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema">
    //      <LicenceKeyText>KEQWBAWZRTEY5XA</LicenceKeyText>
    //      <ComponentID>28</ComponentID>
    //      <ComponentName>Exchequer LITE Core Module</ComponentName>
    //      <Restrictions>
    //        <DecodedRestriction>
    //          <RestrictionID>1</RestrictionID>
    //          <RestrictionType>String</RestrictionType>
    //          <RestrictionDateRule>
    //            ...
    //          </RestrictionDateRule>
    //          <RestrictionBusinessRule>
    //            ...
    //          </RestrictionBusinessRule>
    //          <RestrictionLimits>
    //            <DecodedRestrictionValue>
    //              ...
    //            </DecodedRestrictionValue>
    //            <DecodedRestrictionValue>
    //              ...
    //            </DecodedRestrictionValue>
    //          </RestrictionLimits>
    //        </DecodedRestriction>
    //        <DecodedRestriction>
    //          ...
    //        </DecodedRestriction>
    //      </Restrictions>
    //    </DecodedLicenceCodes>

    // Find the <Restrictions> element
    oXMLRestrictNode := oXML.Nodes.NodeByName['Restrictions'];
    If Assigned(oXMLRestrictNode) Then
    Begin
      If (oXMLRestrictNode.Children.Count > 0) Then
      Begin
        // Run through the <DecodedRestriction> elements
        For I := 0 To (oXMLRestrictNode.Children.Count - 1) Do
        Begin
          oXMLDecoded := oXMLRestrictNode.Children.Node[I];

          // Find the <RestrictionLimits> element
          oRestrictionLimitsNode := oXMLDecoded.Children.NodeByName['RestrictionLimits'];
          If Assigned(oRestrictionLimitsNode) Then
          Begin
            // Run through the <DecodedRestrictionValue> elements creating the LicenceRestriction objects
            If (oRestrictionLimitsNode.Children.Count > 0) Then
            Begin
              For J := 0 To (oRestrictionLimitsNode.Children.Count - 1) Do
              Begin
                // Build up the LicenceRestriction object and store it in the LicenceRestrictions list
                oIRISRestriction := TIRISLicenceRestriction.Create(FIRISLicence, Self);
                If oIRISRestriction.LoadFromXML(oRestrictionLimitsNode.Children.Node[J]) Then
                  FIRISLicence.LicenceRestrictions.Add(oIRISRestriction)
                Else
                  oIRISRestriction.Free;
              End; // For J
            End; // If (oRestrictionLimitsNode.Children.Count > 0)
          End; // If Assigned(oRestrictionLimitsNode)
        End; // For I
      End; // (oXMLRestrictNode.Children.Count > 0)
    End; // If Assigned(oXMLRestrictNode)
  Finally
    oXML.Free;
  End; // Try..Finally
End; // DecodeLicence

//-------------------------------------------------------------------------

// Calls the ValidateLicence method on the IRIS Licencing COM Object
Function TIRISLicenceCode.Validate : Boolean;
Begin // Validate
  Result := FIRISLicence.FLicencingInterface.ValidateLicence(FIRISLicence.CDKey, FLicenceCode)
End; // Validate

//=========================================================================

Constructor TIRISLicenceCodeList.Create;
Begin // Create
  Inherited Create;
  FIRISLicence := IRISLicence;
  FLicenceCodes := TObjectList.Create;
End; // Create

//------------------------------

Destructor TIRISLicenceCodeList.Destroy;
Begin // Destroy
  FreeAndNIL(FLicenceCodes);
  FIRISLicence := NIL;
  Inherited Destroy;
End; // Destroy

//-------------------------------------------------------------------------

Function TIRISLicenceCodeList.GetCount : SmallInt;
Begin // GetCount
  Result := FLicenceCodes.Count;
End; // GetCount

//------------------------------

Function TIRISLicenceCodeList.GetLicenceCodes (Index : SmallInt) : TIRISLicenceCode;
Begin // GetLicenceCodes
  If (Index >= 0) And (Index < FLicenceCodes.Count) Then
    Result := TIRISLicenceCode(FLicenceCodes.Items[Index])
  Else
    Raise Exception.Create ('TIRISLicenceCodeList.GetLicenceCodes: Invalid LicenceCode Index');
End; // GetLicenceCodes

//-------------------------------------------------------------------------

Function TIRISLicenceCodeList.Add (Const NewLicenceCode : ShortString) : TIRISLicenceCode;
Begin // Add
  Result := TIRISLicenceCode.Create(FIRISLicence, NewLicenceCode);
  FLicenceCodes.Add(Result);
End; // Add

//-------------------------------------------------------------------------

Procedure TIRISLicenceCodeList.Clear;
Begin // Clear
  FLicenceCodes.Clear;
End; // Clear

//-------------------------------------------------------------------------

// Deletes the specified licence code
Procedure TIRISLicenceCodeList.Delete(Const Index : SmallInt);
Begin // Delete
  If (Index >= 0) And (Index < FLicenceCodes.Count) Then
  Begin
    FLicenceCodes.Delete(Index);
  End; // If (Index >= 0) And (Index < FLicenceCodes.Count)
End; // Delete

//=========================================================================

Constructor TIRISLicenceRestriction.Create (Const IRISLicence : TIRISLicence; Const ParentLicence : TIRISLicenceCode);
Begin // Create
  Inherited Create;

  FIRISLicence := IRISLicence;

  FParentLicence := ParentLicence;
  FRestrictionDesc := '';
  FRestrictionId := -1;
  FValueId := -1;
  FValueString := '';
End; // Create

//------------------------------

Destructor TIRISLicenceRestriction.Destroy;
Begin // Destroy
  FParentLicence := NIL;
  FIRISLicence := NIL;
  Inherited Destroy;
End; // Destroy

//-------------------------------------------------------------------------

Function TIRISLicenceRestriction.GetValueAsInt : LongInt;
Begin // GetValueAsInt
  Result := StrToIntDef(FValueString, -1);
End; // GetValueAsInt

//------------------------------

Procedure TIRISLicenceRestriction.SetValueString(Value : ShortString);
Begin // SetValueString
  If (Value <> FValueString) Then
  Begin
    FValueString := Value;

    If FIRISLicence.FLicencingInterface.AddLicenceLimit(FRestrictionId, FValueId, FValueString) Then
      //ShowMessage ('Computer says Yes for ' + FValueString)
    Else
      ; //ShowMessage ('Computer says No for ' + FValueString);
  End; // If (Value <> FValueString)
End; // SetValueString

//-------------------------------------------------------------------------

// Extract the Licence Restriction details from the XML, returns TRUE if all set correctly
//
//  <DecodedRestrictionValue>
//    <RestrictionID>12</RestrictionID>
//    <ValueID>5</ValueID>
//    <FormatString>CCCCC-CCCCC-CCCCC-CCCCC-CCCCC</FormatString>
//    <Value ></Value >
//    <Description>Pervasive Key</Description>
//  </DecodedRestrictionValue>
//
// Or it extracts the value from the <RestrictionValues> element
//
//  <RestrictionValues>
//    <RestrictionValueID xmlns="http://tempuri.org/">3026</RestrictionValueID>
//    <LicenceKeyID xmlns="http://tempuri.org/">858</LicenceKeyID>
//    <RestrictionID xmlns="http://tempuri.org/">12</RestrictionID>
//    <Value xmlns="http://tempuri.org/">AHSH7-AHDH4-73735-ASH56-TYSHJ</Value>
//    <ResValueID xmlns="http://tempuri.org/">5</ResValueID>
//  </RestrictionValues>
//
Function TIRISLicenceRestriction.LoadFromXML(Const oRestrictionNode : TGmXMLNode) : Boolean;
Var
  oNode : TGmXMLNode;
Begin // LoadFromXML
  If (oRestrictionNode.Name = 'DecodedRestrictionValue') Then
  Begin
    oNode := oRestrictionNode.Children.NodeByName['Description'];
    If Assigned(oNode) Then
    Begin
      FRestrictionDesc := Trim(oNode.AsString);
    End; // If Assigned(oNode)

    oNode := oRestrictionNode.Children.NodeByName['RestrictionID'];
    If Assigned(oNode) Then
    Begin
      FRestrictionId := oNode.AsInteger;
    End; // If Assigned(oNode)

    oNode := oRestrictionNode.Children.NodeByName['ValueID'];
    If Assigned(oNode) Then
    Begin
      FValueId := oNode.AsInteger;
    End; // If Assigned(oNode)

    oNode := oRestrictionNode.Children.NodeByName['Value'];
    If Assigned(oNode) Then
    Begin
      FValueString := Trim(oNode.AsDisplayString);
    End; // If Assigned(oNode)

    Result := (FRestrictionDesc <> '') And (FRestrictionId <> -1) And (FValueId <> -1);
  End // If (oRestrictionNode.Name = 'DecodedRestrictionValue')
(*
  Else If (oRestrictionNode.Name = 'RestrictionValues') Then
  Begin
    oNode := oRestrictionNode.Children.NodeByName['Value'];
    If Assigned(oNode) Then
    Begin
      FValueString := Trim(oNode.AsString);
    End; // If Assigned(oNode)

    Result := (FValueString <> '');
  End // If (oRestrictionNode.Name = 'RestrictionValues')
*)
  Else
    // Unknown element
    Result := False;
End; // LoadFromXML

//=========================================================================

Constructor TIRISLicenceRestrictionList.Create (Const IRISLicence : TIRISLicence);
Begin // Create
  Inherited Create;
  FIRISLicence := IRISLicence;
  FRestrictions := TObjectList.Create;
End; // Create

//------------------------------

Destructor TIRISLicenceRestrictionList.Destroy;
Begin // Destroy
  FreeAndNIL(FRestrictions);
  FIRISLicence := NIL;
  Inherited Destroy;
End; // Destroy

//-------------------------------------------------------------------------

Function TIRISLicenceRestrictionList.GetCount : SmallInt;
Begin // GetCount
  Result := FRestrictions.Count;
End; // GetCount

//------------------------------

Function TIRISLicenceRestrictionList.GetRestrictions (Index : SmallInt) : TIRISLicenceRestriction;
Begin // GetRestrictions
  If (Index >= 0) And (Index < FRestrictions.Count) Then
    Result := TIRISLicenceRestriction(FRestrictions.Items[Index])
  Else
    Raise Exception.Create ('TIRISLicenceRestrictionList.GetRestrictions: Invalid Restriction Index');
End; // GetRestrictions

//-------------------------------------------------------------------------

Procedure TIRISLicenceRestrictionList.Add (NewRestriction : TIRISLicenceRestriction);
Begin // Add
  FRestrictions.Add(NewRestriction);
End; // Add

//-------------------------------------------------------------------------

Procedure TIRISLicenceRestrictionList.Clear;
Begin // Clear
  FRestrictions.Clear;
End; // Clear

//-------------------------------------------------------------------------

// Deletes any LicenceRestriction objects with the specified ParentLicence
Procedure TIRISLicenceRestrictionList.DeleteLicenceCode(Const ParentLicence : TIRISLicenceCode);
Var
  I : SmallInt;
Begin // DeleteLicenceCode
  I := 0;
  While (I < FRestrictions.Count) Do
  Begin
    If (TIRISLicenceRestriction(FRestrictions.Items[I]).ParentLicence = ParentLicence) Then
      FRestrictions.Delete(I)
    Else
      Inc(I);
  End; // While (I < FRestrictions.Count)
End; // DeleteLicenceCode

//-------------------------------------------------------------------------

Function TIRISLicenceRestrictionList.IndexOf (Const RestrictionId, ValueId : LongInt) : SmallInt;
Var
  oRestrict : TIRISLicenceRestriction;
  I : SmallInt;
Begin // IndexOf
  Result := -1;

  For I := 0 To (FRestrictions.Count - 1) Do
  Begin
    oRestrict := TIRISLicenceRestriction(FRestrictions.Items[I]);

    If (oRestrict.RestrictionId = RestrictionId) And (oRestrict.ValueId = ValueId) Then
    Begin
      Result := I;
      Break;
    End; // If (oRestrict.RestrictionId = RestrictionId) And (oRestrict.ValueId = ValueId)
  End; // For I
End; // IndexOf

//------------------------------

Function TIRISLicenceRestrictionList.IndexOf (RestrictionDesc : ShortString) : SmallInt;
Var
  oRestrict : TIRISLicenceRestriction;
  I : SmallInt;
Begin // IndexOf
  Result := -1;

  RestrictionDesc := UpperCase(Trim(RestrictionDesc));

  For I := 0 To (FRestrictions.Count - 1) Do
  Begin
    oRestrict := TIRISLicenceRestriction(FRestrictions.Items[I]);

    If (UpperCase(oRestrict.RestrictionDesc) = RestrictionDesc) Then
    Begin
      Result := I;
      Break;
    End; // If (oRestrict.RestrictionDesc = RestrictionDesc)
  End; // For I
End; // IndexOf

//=========================================================================

Constructor TIRISLicence.Create;
Begin // Create
  Inherited Create;

  // Create IRIS Licencing COM OBject (wrapper of .NET class)
  FLicencingInterface := CoLicensingInterface.Create;

  If (Not FLicencingInterface.InitialiseLocalDatabase) Then
  Begin
    Raise Exception.Create('TIRISLicence.CheckInit: Error Initialising Local Database');
  End; // If (Not FLicencingInterface.InitialiseLocalDatabase)

  FCDKey := '';
  FCustomerNumber := '';

  FActivationDate := Now - 1; // Yesterday
  FActivationKey := '';

  FComponents := TIRISComponentList.Create;
  FLicenceCodes := TIRISLicenceCodeList.Create(Self);
  FLicenceRestrictions := TIRISLicenceRestrictionList.Create(Self);
  FInitialRestrictions := TIRISInitialRestrictionList.Create;
End; // Create

//------------------------------

Destructor TIRISLicence.Destroy;
Begin // Destroy
  FreeAndNIL(FComponents);
  FreeAndNIL(FLicenceCodes);
  FreeAndNIL(FLicenceRestrictions);
  FreeAndNIL(FInitialRestrictions);

  // Release reference to IRIS Licencing COM OBject
  FLicencingInterface := NIL;

  Inherited Destroy;
End; // Destroy

//-------------------------------------------------------------------------

Procedure TIRISLicence.SetCDKey (Value : ShortString);
Var
  sResult : ANSIString;
  oXML    : TGmXML;
  oNode   : TGmXmlNode;
Begin // SetCDKey
  If (Value <> FCDKey) Then
  Begin
    // Record the new CD-Key for reference
    FCDKey := Value;

    // Remove any details for the previous CD-Key
    FComponents.Clear;
    FInitialRestrictions.Clear;
    FLicenceCodes.Clear;
    FLicenceRestrictions.Clear;

    FLicencingInterface.ClearLicenceLimits;

    // Decode the CD-Key
    sResult := FLicencingInterface.DecodeCDKey(FCDKey);

{$IFDEF LICDEBUG}
  AddXMLToLog (sResult);
{$ENDIF}

    If(sResult <> '') Then
    Begin
      oXML := TGmXML.Create(NIL);
      Try
        oXML.Text := sResult;

        // Extract the Customer Number and check for errors
        oNode := oXML.Nodes.NodeByName[sCustomerNumber];
        If Assigned(oNode) Then
        Begin
          FCustomerNumber := oNode.AsString;

          If (oNode.AsInteger > 0) Then
          Begin
            // Extract the CD-Key Component details
            oNode := oXML.Nodes.NodeByName[sComponents];
            If Assigned(oNode) Then
            Begin
              ParseComponents (oNode);
            End; // If Assigned(oNode)

            oNode := oXML.Nodes.NodeByName[sInitialRestrictions];
            If Assigned(oNode) Then
            Begin
              ParseInitialRestrictions (oNode);
            End; // If Assigned(oNode)
          End; // If (oNode.AsInteger > 0)
        End; // If Assigned(oNode)
      Finally
        oXML.Free;
      End; // Try..Finally
    End; // If(sResult <> '')
  End; // If (Value <> FCDKey)
End; // SetCDKey

//-------------------------------------------------------------------------

// Parses the <Components> section of the DecodeCDKey results to extract
// the <CDKeyComponents> sections
Procedure TIRISLicence.ParseComponents (oNode : TGmXmlNode);
Var
  oXMLComponent : TGmXmlNode;
  oIRISComponent : TIRISComponent;
  I : SmallInt;
Begin // ParseComponents
  If (oNode.Children.Count > 0) Then
  Begin
    For I := 0 To (oNode.Children.Count - 1) Do
    Begin
      oXMLComponent := oNode.Children.Node[I];
      If (oXMLComponent.Name = sCDKeyComponent) Then
      Begin
        oIRISComponent := TIRISComponent.Create;
        If oIRISComponent.LoadFromXML(oXMLComponent) Then
          FComponents.Add(oIRISComponent)
        Else
          oIRISComponent.Free;
      End; // If (oXMLComponent.Name = sCDKeyComponent)
    End; // For I
  End; // If (oNode.Children.Count > 0)
End; // ParseComponents

//-------------------------------------------------------------------------

// Parses the <InitialRestrictions> section of the DecodeCDKey results to extract
// the <CDKeyInitialRestrictions> sections
Procedure TIRISLicence.ParseInitialRestrictions (oNode : TGmXmlNode);
Var
  oXMLRestriction : TGmXmlNode;
  oIRISRestriction : TIRISInitialRestriction;
  I : SmallInt;
Begin // ParseInitialRestrictions
  If (oNode.Children.Count > 0) Then
  Begin
    For I := 0 To (oNode.Children.Count - 1) Do
    Begin
      oXMLRestriction := oNode.Children.Node[I];
      If (oXMLRestriction.Name = sCDKeyInitialRestrictions) Then
      Begin
        oIRISRestriction := TIRISInitialRestriction.Create;
        If oIRISRestriction.LoadFromXML(oXMLRestriction) Then
          FInitialRestrictions.Add(oIRISRestriction)
        Else
          oIRISRestriction.Free;
      End; // If (oXMLRestriction.Name = sCDKeyInitialRestrictions)
    End; // For I
  End; // If (oNode.Children.Count > 0)
End; // ParseInitialRestrictions

//-------------------------------------------------------------------------

// Parses the <ArrayOfDecodedRestrictionValue> element returned from GetLicenceRestrictionsWS
// and updates the appropriate TIRISLicenceRestriction objects
Procedure TIRISLicence.ParseLicenceRestrictions (Const XMLRestrict : ANSIString);
Var
  oXML    : TGmXML;
  oXMLArray, oXMLRestrictValue, oXMLNode : TGmXMLNode;
  I, Idx       : SmallInt;
  ResId, ValId : LongInt;
Begin // ParseLicenceRestrictions
{$IFDEF LICDEBUG}
  AddXMLToLog (XMLRestrict);
{$ENDIF}

  oXML := TGmXML.Create(NIL);
  Try
    oXML.Text := XMLRestrict;

    oXMLArray := oXML.Nodes.NodeByName['ArrayOfDecodedRestrictionValue'];
    If Assigned(oXMLArray) Then
    Begin
      For I := 0 To (oXMLArray.Children.Count - 1) Do
      Begin
        // Extract the RestrictionId and ValueId to allow the TIRISLicenceRestriction to
        // be looked up
        oXMLRestrictValue := oXMLArray.Children.Node[I];

        oXMLNode := oXMLRestrictValue.Children.NodeByName['RestrictionID'];
        If Assigned(oXMLNode) Then
          ResId := oXMLNode.AsInteger
        Else
          ResId := -1;

        oXMLNode := oXMLRestrictValue.Children.NodeByName['ValueID'];
        If Assigned(oXMLNode) Then
          ValId := oXMLNode.AsInteger
        Else
          ValId := -1;

        // Get the <Value> element to be loaded into the Licence Restriction object
        oXMLNode := oXMLRestrictValue.Children.NodeByName['Value'];

        // Lookup the ResId/ValId in the Licence Restriction objects list
        Idx := FLicenceRestrictions.IndexOf(ResId, ValId);
        If (Idx > -1) And Assigned(oXMLNode) Then
        Begin
          FLicenceRestrictions.Restriction[Idx].LoadFromXML(oXMLRestrictValue);
        End; // If (oXMLRestriction.Name = sCDKeyInitialRestrictions)
      End; // For I
    End; // If Assigned(oXMLArray)
  Finally
    oXML.Free;
  End; // Try..Finally
End; // ParseLicenceRestrictions

//-------------------------------------------------------------------------

// Contacts the Web-Service and downloads the Licence Info for the current CD-Key including
// Licence Codes and the Restriction Limits for each Licence Code
Function TIRISLicence.GetLicenceCodes (Var ErrString : ANSIString) : Boolean;
Var
  sResult : ANSIString;
  oXML    : TGmXML;
  oArrayNode, oStringNode : TGmXmlNode;
  oIRISLicenceCode : TIRISLicenceCode;
  I       : SmallInt;
Begin // GetLicenceCodes
  // Remove any previously downloaded Licence Codes
  FLicenceCodes.Clear;
  FLicenceRestrictions.Clear;

  // Contact the Web-Service and download the codes for the current CD-Key
  sResult := FLicencingInterface.GetLicenceCodes(FCDKey);

{$IFDEF LICDEBUG}
  AddXMLToLog (sResult);
{$ENDIF}

  // Clear any limits held by the COM Object
  FLicencingInterface.ClearLicenceLimits;

  oXML := TGmXML.Create(NIL);
  Try
    oXML.Text := sResult;

    // Run through the array of Licence Codes
    oArrayNode := oXML.Nodes.NodeByName['ArrayOfString'];
    If Assigned(oArrayNode) Then
    Begin
      If (oArrayNode.Children.Count > 0) Then
      Begin
        For I := 0 To (oArrayNode.Children.Count - 1) Do
        Begin
          oStringNode := oArrayNode.Children.Node[I];
          If (oStringNode.Name = 'string') Then
          Begin
            // Create a Licence Codes object and put it into the list, this will automatically
            // cause the Licence Restrictions to be retrieved from the local database
            oIRISLicenceCode := FLicenceCodes.Add(oStringNode.AsString);

            // Download the Licence Restriction Values from the web-service for this Licence Code
            sResult := FLicencingInterface.GetLicenceRestrictionsWS(FCDKey, oIRISLicenceCode.LicenceCode);

            // Split out the Licence Restriction Values and update the Licence Restriction objects
            ParseLicenceRestrictions (sResult);
          End; // If (oStringNode.Name = 'string')
        End; // For I
      End; // If (oArrayNode.Children.Count > 0)
    End; // If Assigned(oArrayNode)
  Finally
    oXML.Free;
  End; // Try..Finally

  Result := (FLicenceCodes.Count > 0);
  ErrString := IfThen (Result, '', sResult);
End; // GetLicenceCodes

//-------------------------------------------------------------------------

// Removes any previously specified Licence Limits from the COM Object
Procedure TIRISLicence.ClearLicenceLimits;
Var
  I : SmallInt;
Begin // ClearLicenceLimits
  // Removes any previously specified Licence Limits from the COM Object
  FLicencingInterface.ClearLicenceLimits;

  // Also need to clear out limits specified on the LicenceRestriction objects
  For I := 0 To (FLicenceRestrictions.Count - 1) Do
  Begin
    FLicenceRestrictions[I].Value := '';
  End; // For I
End; // ClearLicenceLimits

//-------------------------------------------------------------------------

Function TIRISLicence.ParseActivation (Const sXMLResult : ANsIString; Var sError : ANsIString) : Boolean;
Var
  oXML    : TGmXML;
  oDACNode, oActiveNode : TGmXmlNode;
  sActivateDate : ShortString;
Begin // ParseActivation
  // Should have something like this:-
  //
  //  <?xml version="1.0"?>
  //  <DecodedActivationCode xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema">
  //    <ActivationCode>QQTGJVAJJQBGQL4PTRQQ</ActivationCode>
  //    <ActivatedUntil>2006-03-20T00:00:00</ActivatedUntil>
  //  </DecodedActivationCode>

  oXML := TGmXML.Create(NIL);
  Try
    oXML.Text := sXMLResult;

    // Run through the array of Licence Codes
    oDACNode := oXML.Nodes.NodeByName['DecodedActivationCode'];
    If Assigned(oDACNode) Then
    Begin
      // Activation Code - QQTGJVAJJQBGQL4PTRQQ
      oActiveNode := oDACNode.Children.NodeByName['ActivationCode'];
      If Assigned(oActiveNode) Then
      Begin
        FActivationKey := oActiveNode.AsString;
      End; // If Assigned(oActiveNode)

      // Activation Date - 2006-03-20T00:00:00
      oActiveNode := oDACNode.Children.NodeByName['ActivatedUntil'];
      If Assigned(oActiveNode) Then
      Begin
        sActivateDate := oActiveNode.AsString;
        If (Length(sActivateDate) >= 10) Then
        Begin
          FActivationDate := EncodeDate(StrToInt(Copy(sActivateDate, 1, 4)), StrToInt(Copy(sActivateDate, 6, 2)), StrToInt(Copy(sActivateDate, 9, 2)));
        End; // If (Length(sActivateDate) >= 10)
      End; // If Assigned(oActiveNode)
    End; // If Assigned(oArrayNode)
  Finally
    oXML.Free;
  End; // Try..Finally

  Result := (Trim(FActivationKey) <> '') And (FActivationDate >= Now);
  sError := IfThen (Result, '', sXMLResult);
End; // ParseActivation

//------------------------------

// Validates and decodes the supplied Activation Key
Function TIRISLicence.DecodeActivationKey(Const ActivationKey : ShortString; Var ErrString : ANSIString) : Boolean;
Var
  sResult : ANSIString;
Begin // DecodeActivationKey
  FActivationDate := Now - 1; // Yesterday
  FActivationKey := ActivationKey;

  // Contact the Web-Service and download the Activation Code for the current CD-Key
  sResult := FLicencingInterface.ActivateCDKey(FCDKey, ActivationKey);

{$IFDEF LICDEBUG}
  AddXMLToLog (sResult);
{$ENDIF}

  Result := ParseActivation(sResult, ErrString);
End; // DecodeActivationKey

//------------------------------

// Contacts the Web-Service and downloads the Activation Key for the current CD-Key
Function TIRISLicence.GetActivationKey (Var ErrString : ANSIString) : Boolean;
Var
  sResult, sActDate : ANSIString;
Begin // GetActivationKey

  FActivationDate := Now - 1; // Yesterday
  FActivationKey := '';

  // Contact the Web-Service and download the Activation Code for the current CD-Key
  sActDate := '01/01/0001';
  sResult := FLicencingInterface.ActivateFromWS(FCDKey, True, sActDate);

{$IFDEF LICDEBUG}
  AddXMLToLog (sResult);
{$ENDIF}

  Result := ParseActivation(sResult, ErrString);
End; // GetActivationKey

//-------------------------------------------------------------------------

end.
