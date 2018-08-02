unit oIrishIntrastat;

interface

Uses Classes, SysUtils, IniFiles, GlobVar;

Type
  ixiAddressIndex = 1..3;

  Str6  = String[6];
  Str35 = String[35];
  Str60 = String[60];

  //------------------------------

  // Iris Intrastat XML Interface - Party Element
  IIXIParty = Interface
    ['{B37AC294-A1E6-403E-85D6-A3F71D88E43C}']
    // --- Internal Methods to implement Public Properties ---
    Function GetPartyType : Str3;
    Function GetVATNumber : Str30;
    Procedure SetVATNumber (Value : Str30);
    Function GetName : Str35;
    Procedure SetName (Value : Str35);
    Function GetAddress (Index : ixiAddressIndex) : Str35;
    Procedure SetAddress (Index : ixiAddressIndex; Value : Str35);
    Function GetContact : Str15;
    Procedure SetContact (Value : Str15);
    Function GetPhone : Str15;
    Procedure SetPhone (Value : Str15);
    Function GetEmail : Str60;
    Procedure SetEmail (Value : Str60);

    Function GetArrivals : Byte;
    Procedure SetArrivals (Value : Byte);
    Function GetDispatch : Byte;
    Procedure SetDispatch (Value : Byte);

    // MH 04/04/2012 v6.10.1 ABSEXCH-12549: Added statsValueRequired attribute
    Function GetStatsValueRequired  : Boolean;
    Procedure SetStatsValueRequired (Value : Boolean);

    // ------------------ Public Properties ------------------
    Property PartyType : Str3 Read GetPartyType;  // 'PSI'/'TPI' - Read-Only
    Property VATNumber : Str30 Read GetVATNumber Write SetVATNumber;
    Property Name : Str35 Read GetName Write SetName;
    Property Address [Index : ixiAddressIndex] : Str35 Read GetAddress Write SetAddress;
    Property Contact : Str15 Read GetContact Write SetContact;
    Property Phone : Str15 Read GetPhone Write SetPhone;
    Property Email : Str60 Read GetEmail Write SetEmail;

    Property Arrivals : Byte Read GetArrivals Write SetArrivals;
    Property Dispatch : Byte Read GetDispatch Write SetDispatch;

    // MH 04/04/2012 v6.10.1 ABSEXCH-12549: Added statsValueRequired attribute
    Property StatsValueRequired : Boolean Read GetStatsValueRequired Write SetStatsValueRequired;

    // ------------------- Public Methods --------------------
  End; // IIXIParty

  //------------------------------

  // Iris Intrastat XML Interface - Item Element
  IIXIItem = Interface
    ['{444A3FBD-249D-480F-8BC4-AC27E4E4FFA6}']
    // --- Internal Methods to implement Public Properties ---
    // ItemDetails Element
    Function GetCtryConsignDestn : Str3;
    Procedure SetCtryConsignDestn (Value : Str3);
    Function GetCtryOrigin : Str3;
    Procedure SetCtryOrigin (Value : Str3);
    Function GetNatureOfTransaction : Byte;
    Procedure SetNatureOfTransaction (Value : Byte);
    Function GetModeOfTransport : Byte;
    Procedure SetModeOfTransport (Value : Byte);
    Function GetTermsOfDelivery : ShortString;
    Procedure SetTermsOfDelivery (Value : ShortString);

    // CN8 Element
    Function GetCode : Str8;
    Procedure SetCode (Value : Str8);
    Function GetNetMass : Double;
    Procedure SetNetMass (Value : Double);
    Function GetNetMassOpt : Char;
    Procedure SetNetMassOpt (Value : Char);
    Function GetsuCode : ShortString;
    Procedure SetsuCode (Value : ShortString);
    Function GetsuQuantity : Double;
    Procedure SetsuQuantity (Value : Double);

    // ItemValues Element
    Function GetinvEuroValue : Double;
    Procedure SetinvEuroValue (Value : Double);
    // MH 04/04/2012 v6.10.1 ABSEXCH-12583: Added statEuroValue attribute
    Function GetstatEuroValue : Double;
    Procedure SetstatEuroValue (Value : Double);

    // ------------------ Public Properties ------------------
    // ItemDetails Element
    Property CtryConsignDestn : Str3 Read GetCtryConsignDestn Write SetCtryConsignDestn;
    Property CtryOrigin : Str3 Read GetCtryOrigin Write SetCtryOrigin;
    Property NatureOfTransaction : Byte Read GetNatureOfTransaction Write SetNatureOfTransaction; // 1..9
    Property ModeOfTransport : Byte Read GetModeOfTransport Write SetModeOfTransport; // 1..5 or 7..9
    Property TermsOfDelivery : ShortString Read GetTermsOfDelivery Write SetTermsOfDelivery;

    // CN8 Element
    Property Code : Str8 Read GetCode Write SetCode;
    Property NetMass : Double Read GetNetMass Write SetNetMass;
    Property NetMassOpt : Char Read GetNetMassOpt Write SetNetMassOpt;  // 'O'=Net Mass Optional, 'M'=Net Mass Mandatory
    Property suCode : ShortString Read GetsuCode Write SetsuCode;   // Type of supplementary unit
    Property suQuantity : Double Read GetsuQuantity Write SetsuQuantity;

    // ItemValues Element
    Property invEuroValue : Double Read GetinvEuroValue Write SetinvEuroValue;
    // MH 04/04/2012 v6.10.1 ABSEXCH-12583: Added statEuroValue attribute
    Property statEuroValue : Double Read GetstatEuroValue Write SetstatEuroValue;

    // ------------------- Public Methods --------------------

    // Used to save a new item into the Items array once the fields are set
    Procedure Save;
  End; // IIXIItem

  //------------------------------

  // Iris Intrastat XML Interface - IStat Element (Root)
  IIrishXMLIntrastat = Interface
    ['{9B7D1FA3-6637-4540-87CB-82FB6C8EF494}']
    // --- Internal Methods to implement Public Properties ---
    // IStat Attributes
    Function GetFormVersion : Char;
    Procedure SetFormVersion (Value : Char);
    Function GetLanguage : Char;
    Procedure SetLanguage (Value : Char);
    Function GetPeriodStart : LongDate;
    Procedure SetPeriodStart (Value : LongDate);
    Function GetPeriodEnd : LongDate;
    Procedure SetPeriodEnd (Value : LongDate);

    // Return Element
    Function GetReturnType : Byte;
    Procedure SetReturnType (Value : Byte);
    Function GetFlow : Char;
    Procedure SetFlow (Value : Char);
    Function GetStatPeriod : Str6;
    Procedure SetStatPeriod (Value : Str6);

    // Party Elements
    Function GetPSIParty : IIXIParty;
    Function GetTPIParty : IIXIParty;

    // Item Element Array
    Function GetItemCount : LongInt;
    Function GetItems (Index : LongInt) : IIXIItem;

    // Error message generated by SaveToFile
    Function GetLastError : ShortString;

    // ------------------ Public Properties ------------------
    // IStat Attributes
    Property FormVersion : Char Read GetFormVersion Write SetFormVersion;  // Default = '1'
    Property Language : Char Read GetLanguage Write SetLanguage;   // Default = 'E'
    Property PeriodStart : LongDate Read GetPeriodStart Write SetPeriodStart;  // YYYYMMDD
    Property PeriodEnd : LongDate Read GetPeriodEnd Write SetPeriodEnd; // YYYYMMDD

    // Return Element
    Property ReturnType : Byte Read GetReturnType Write SetReturnType; // 0=NIL, 1=Not NIL
    Property Flow : Char Read GetFlow Write SetFlow;  // 'A'=Arrivals, 'D'=Dispatch
    Property StatPeriod : Str6 Read GetStatPeriod Write SetStatPeriod;  // MMYYYY

    // Party Elements
    Property PSIParty : IIXIParty Read GetPSIParty;  // Mandatory
    Property TPIParty : IIXIParty Read GetTPIParty;  // Optional: Only exported if name <> ''

    // Item Element Array
    Property ItemCount : LongInt Read GetItemCount;
    Property Items [Index : LongInt] : IIXIItem Read GetItems;

    // Error message generated by SaveToFile
    Property LastError : ShortString Read GetLastError;

    // ------------------- Public Methods --------------------
    // Returns a new IIXIItem for population and saving
    Function NewItem : IIXIItem;

    // Save to XML file - 0 = AOK, anything else is BAD
    Function SaveToFile (Const Filename : ShortString) : LongInt;
  End; // IIrishXMLIntrastat



// Call this function to get a new instance of an IIrishXMLIntrastat object
Function NewIrisXMLIntrastatIntf : IIrishXMLIntrastat;


implementation

Uses StrUtils,GmXML;

Type
  TIrishXMLIntrastat = Class;

  //------------------------------

  // Generic interface for objects which implement a specific import type
  IIXIItemInternal = Interface
    ['{43AB473C-6DE9-4A73-84BF-7C0B6081DCAE}']
    // --- Internal Methods to implement Public Properties ---
    // ------------------ Public Properties ------------------
    // ------------------- Public Methods --------------------
    // MH 04/04/2012 v6.10.1 ABSEXCH-12583: Added StatsValueRequired parameter to control writing of statEuroValue attribute
    Procedure WriteItemElement (Const oIStatNode : TGmXmlNode; Const StatsValueRequired : Boolean);
  End; // IIXIItemInternal

  //------------------------------

  TIrishXMLItem = Class(TInterfacedObject, IIXIItem, IIXIItemInternal)
  Private
    FIrishXMLIntrastat : TIrishXMLIntrastat;

    FCtryConsignDestn : Str3;
    FCtryOrigin : Str3;
    FNatureOfTransaction : Byte;
    FModeOfTransport : Byte;
    FTermsOfDelivery : ShortString;
    FCode : Str8;
    FNetMass : Double;
    FNetMassOpt : Char;
    FsuCode : ShortString;
    FsuQuantity : Double;
    FinvEuroValue : Double;
    // MH 04/04/2012 v6.10.1 ABSEXCH-12583: Added statEuroValue attribute
    FstatEuroValue : Double;

    // ItemDetails Element
    Function GetCtryConsignDestn : Str3;
    Procedure SetCtryConsignDestn (Value : Str3);
    Function GetCtryOrigin : Str3;
    Procedure SetCtryOrigin (Value : Str3);
    Function GetNatureOfTransaction : Byte;
    Procedure SetNatureOfTransaction (Value : Byte);
    Function GetModeOfTransport : Byte;
    Procedure SetModeOfTransport (Value : Byte);
    Function GetTermsOfDelivery : ShortString;
    Procedure SetTermsOfDelivery (Value : ShortString);

    // CN8 Element
    Function GetCode : Str8;
    Procedure SetCode (Value : Str8);
    Function GetNetMass : Double;
    Procedure SetNetMass (Value : Double);
    Function GetNetMassOpt : Char;
    Procedure SetNetMassOpt (Value : Char);
    Function GetsuCode : ShortString;
    Procedure SetsuCode (Value : ShortString);
    Function GetsuQuantity : Double;
    Procedure SetsuQuantity (Value : Double);

    // ItemValues Element
    Function GetinvEuroValue : Double;
    Procedure SetinvEuroValue (Value : Double);
    // MH 04/04/2012 v6.10.1 ABSEXCH-12583: Added statEuroValue attribute
    Function GetstatEuroValue : Double;
    Procedure SetstatEuroValue (Value : Double);

    // MH 04/04/2012 v6.10.1 ABSEXCH-12583: Added StatsValueRequired parameter to control writing of statEuroValue attribute
    Procedure WriteItemElement (Const oIStatNode : TGmXmlNode; Const StatsValueRequired : Boolean);

    // Used to save a new item into the Items array once the fields are set
    Procedure Save;
  Public
    Constructor Create (Const IrishXMLIntrastat : TIrishXMLIntrastat);
    Destructor Destroy; Override;
  End; // TIrishXMLItem

  //------------------------------

  TIrishXMLParty = Class(TInterfacedObject, IIXIParty)
  Private
    FPartyType : Str3;
    FVATNumber : Str30;
    FName : Str35;
    FAddress : Array [ixiAddressIndex] of Str35;
    FContact : Str15;
    FPhone : Str15;
    FEmail : Str60;

    FArrivals : Byte;
    FDispatch : Byte;

    // MH 04/04/2012 v6.10.1 ABSEXCH-12549: Added statsValueRequired attribute
    FStatsValueRequired : Boolean;

    // Party Element
    Function GetPartyType : Str3;
    Function GetVATNumber : Str30;
    Procedure SetVATNumber (Value : Str30);
    Function GetName : Str35;
    Procedure SetName (Value : Str35);
    Function GetAddress (Index : ixiAddressIndex) : Str35;
    Procedure SetAddress (Index : ixiAddressIndex; Value : Str35);
    Function GetContact : Str15;
    Procedure SetContact (Value : Str15);
    Function GetPhone : Str15;
    Procedure SetPhone (Value : Str15);
    Function GetEmail : Str60;
    Procedure SetEmail (Value : Str60);

    Function GetArrivals : Byte;
    Procedure SetArrivals (Value : Byte);
    Function GetDispatch : Byte;
    Procedure SetDispatch (Value : Byte);

    // MH 04/04/2012 v6.10.1 ABSEXCH-12549: Added statsValueRequired attribute
    Function GetStatsValueRequired  : Boolean;
    Procedure SetStatsValueRequired (Value : Boolean);
  Public
    Constructor Create (Const PartyType : Str3);
    Destructor Destroy; Override;

    Procedure WritePartyElement (Const oIStatNode : TGmXmlNode);
  End; // TIrishXMLParty

  //------------------------------

  TIrishXMLIntrastat = Class(TInterfacedObject, IIrishXMLIntrastat)
  Private
    FFormVersion : Char;
    FLanguage : Char;
    FPeriodStart : LongDate;
    FPeriodEnd : LongDate;
    FReturnType : Byte;
    FFlow : Char;
    FStatPeriod : Str6;
    FPSIPartyO : TIrishXMLParty;
    FPSIPartyI : IIXIParty;
    FTPIPartyO : TIrishXMLParty;
    FTPIPartyI : IIXIParty;
    FItems : TInterfaceList;
    FLastError : ShortString;

    // IStat Attributes
    Function GetFormVersion : Char;
    Procedure SetFormVersion (Value : Char);
    Function GetLanguage : Char;
    Procedure SetLanguage (Value : Char);
    Function GetPeriodStart : LongDate;
    Procedure SetPeriodStart (Value : LongDate);
    Function GetPeriodEnd : LongDate;
    Procedure SetPeriodEnd (Value : LongDate);

    // Return Element
    Function GetReturnType : Byte;
    Procedure SetReturnType (Value : Byte);
    Function GetFlow : Char;
    Procedure SetFlow (Value : Char);
    Function GetStatPeriod : Str6;
    Procedure SetStatPeriod (Value : Str6);

    // Party Elements
    Function GetPSIParty : IIXIParty;
    Function GetTPIParty : IIXIParty;

    // Item Element Array
    Function GetItemCount : LongInt;
    Function GetItems (Index : LongInt) : IIXIItem;

    // Error message generated by SaveToFile
    Function GetLastError : ShortString;

    // Returns a new IIXIItem for population and saving
    Function NewItem : IIXIItem;

    // Save to XML file - 0 = AOK, anything else is BAD
    Function SaveToFile (Const Filename : ShortString) : LongInt;

    // Internal methods for writing to XML
    Procedure WriteIStatAtts (Const oIStatNode : TGmXmlNode);
    Procedure WriteReturnElement (Const oIStatNode : TGmXmlNode);
  Public
    Constructor Create;
    Destructor Destroy; Override;

    // Called from IIXIItem.Save to add itself into the items list
    Procedure SaveItem (Const Item : TIrishXMLItem);
  End; // TIrishXMLIntrastat

//=========================================================================

// Call this function to get a new instance of an IIrishXMLIntrastat object
Function NewIrisXMLIntrastatIntf : IIrishXMLIntrastat;
Begin // NewIrisXMLIntrastatIntf
  Result := TIrishXMLIntrastat.Create;
End; // NewIrisXMLIntrastatIntf

//=========================================================================

Constructor TIrishXMLItem.Create (Const IrishXMLIntrastat : TIrishXMLIntrastat);
Begin // Create
  Inherited Create;

  FIrishXMLIntrastat := IrishXMLIntrastat;

  FCtryConsignDestn := '';
  FCtryOrigin := '';
  FNatureOfTransaction := 1;
  FModeOfTransport := 1;
  FTermsOfDelivery := '';
  FCode := '';
  FNetMass := 0.0;
  FNetMassOpt := ' ';
  FsuCode := '';
  FsuQuantity := 0.0;
  FinvEuroValue := 0.0;
  // MH 04/04/2012 v6.10.1 ABSEXCH-12583: Added statEuroValue attribute
  FstatEuroValue := 0.0;
End; // Create

//------------------------------

Destructor TIrishXMLItem.Destroy;
Begin // Destroy
  FIrishXMLIntrastat := NIL;
  Inherited Destroy;
End; // Destroy

//-------------------------------------------------------------------------

Function TIrishXMLItem.GetCtryConsignDestn : Str3;
Begin // GetCtryConsignDestn
  Result := FCtryConsignDestn;
End; // GetCtryConsignDestn

Procedure TIrishXMLItem.SetCtryConsignDestn (Value : Str3);
Begin // SetCtryConsignDestn
  FCtryConsignDestn := Value;
End; // SetCtryConsignDestn

//------------------------------

Function TIrishXMLItem.GetCtryOrigin : Str3;
Begin // GetCtryOrigin
  Result := FCtryOrigin;
End; // GetCtryOrigin

Procedure TIrishXMLItem.SetCtryOrigin (Value : Str3);
Begin // SetCtryOrigin
  FCtryOrigin := Value;
End; // SetCtryOrigin

//------------------------------

Function TIrishXMLItem.GetNatureOfTransaction : Byte;
Begin // GetNatureOfTransaction
  Result := FNatureOfTransaction;
End; // GetNatureOfTransaction

Procedure TIrishXMLItem.SetNatureOfTransaction (Value : Byte);
Begin // SetNatureOfTransaction
  FNatureOfTransaction := Value;
End; // SetNatureOfTransaction

//------------------------------

Function TIrishXMLItem.GetModeOfTransport : Byte;
Begin // GetModeOfTransport
  Result := FModeOfTransport;
End; // GetModeOfTransport

Procedure TIrishXMLItem.SetModeOfTransport (Value : Byte);
Begin // SetModeOfTransport
  FModeOfTransport := Value;
End; // SetModeOfTransport

//------------------------------

Function TIrishXMLItem.GetTermsOfDelivery : ShortString;
Begin // GetTermsOfDelivery
  Result := FTermsOfDelivery;
End; // GetTermsOfDelivery

Procedure TIrishXMLItem.SetTermsOfDelivery (Value : ShortString);
Begin // SetTermsOfDelivery
  FTermsOfDelivery := Value;
End; // SetTermsOfDelivery

//------------------------------

Function TIrishXMLItem.GetCode : Str8;
Begin // GetCode
  Result := FCode;
End; // GetCode

Procedure TIrishXMLItem.SetCode (Value : Str8);
Begin // SetCode
  FCode := Value;
End; // SetCode

//------------------------------

Function TIrishXMLItem.GetNetMass : Double;
Begin // GetNetMass
  Result := FNetMass;
End; // GetNetMass

Procedure TIrishXMLItem.SetNetMass (Value : Double);
Begin // SetNetMass
  FNetMass := Value;
End; // SetNetMass

//------------------------------

Function TIrishXMLItem.GetNetMassOpt : Char;
Begin // GetNetMassOpt
  Result := FNetMassOpt;
End; // GetNetMassOpt

Procedure TIrishXMLItem.SetNetMassOpt (Value : Char);
Begin // SetNetMassOpt
  FNetMassOpt := Value;
End; // SetNetMassOpt

//------------------------------

Function TIrishXMLItem.GetsuCode : ShortString;
Begin // GetsuCode
  Result := FsuCode;
End; // GetsuCode

Procedure TIrishXMLItem.SetsuCode (Value : ShortString);
Begin // SetsuCode
  FsuCode := Value;
End; // SetsuCode

//------------------------------

Function TIrishXMLItem.GetsuQuantity : Double;
Begin // GetsuQuantity
  Result := FsuQuantity;
End; // GetsuQuantity

Procedure TIrishXMLItem.SetsuQuantity (Value : Double);
Begin // SetsuQuantity
  FsuQuantity := Value;
End; // SetsuQuantity

//------------------------------

Function TIrishXMLItem.GetinvEuroValue : Double;
Begin // GetinvEuroValue
  Result := FinvEuroValue;
End; // GetinvEuroValue

Procedure TIrishXMLItem.SetinvEuroValue (Value : Double);
Begin // SetinvEuroValue
  FinvEuroValue := Value;
End; // SetinvEuroValue

//------------------------------

// MH 04/04/2012 v6.10.1 ABSEXCH-12583: Added statEuroValue attribute
Function TIrishXMLItem.GetstatEuroValue : Double;
Begin // GetstatEuroValue
  Result := FstatEuroValue;
End; // GetstatEuroValue

Procedure TIrishXMLItem.SetstatEuroValue (Value : Double);
Begin // SetstatEuroValue
  FstatEuroValue := Value;
End; // SetstatEuroValue

//-------------------------------------------------------------------------

// Used to save a new item into the Items array once the fields are set
Procedure TIrishXMLItem.Save;
Begin // Save
  FIrishXMLIntrastat.SaveItem (Self);
End; // Save

//-------------------------------------------------------------------------

// MH 04/04/2012 v6.10.1 ABSEXCH-12583: Added StatsValueRequired parameter to control writing of statEuroValue attribute
Procedure TIrishXMLItem.WriteItemElement (Const oIStatNode : TGmXmlNode; Const StatsValueRequired : Boolean);
Begin // WriteItemElement
  With oIStatNode.Children.AddOpenTag('Item') Do
  Begin
    // Item Details
    With oIStatNode.Children.AddOpenTag('ItemDetails') Do
    Begin
      Attributes.AddAttribute ('ctryConsignDestn', FCtryConsignDestn);
      If (Trim(FCtryOrigin) <> '') Then
        Attributes.AddAttribute ('ctryOrigin', FCtryOrigin);
      Attributes.AddAttribute ('delivery', FTermsOfDelivery);
      Attributes.AddAttribute ('transaction', IntToStr(FNatureOfTransaction));
      Attributes.AddAttribute ('transport', IntToStr(FModeOfTransport))
    End; // With oIStatNode.Children.AddOpenTag('ItemDetails')
    oIStatNode.Children.AddCloseTag;

    // CN8 Element
    With oIStatNode.Children.AddOpenTag('CN8') Do
    Begin
      Attributes.AddAttribute ('code', FCode);
      Attributes.AddAttribute ('netMass', Format('%0.2f', [FNetMass]));
      Attributes.AddAttribute ('netMassOpt', FNetMassOpt);
      Attributes.AddAttribute ('suCode', FsuCode);
      Attributes.AddAttribute ('suQuanity', Format('%0.2f', [FsuQuantity]))   // NOTE: Typo in attribute name is deliberate
    End; // With oIStatNode.Children.AddOpenTag('CN8')
    oIStatNode.Children.AddCloseTag;

    // ItemValues Element
    With oIStatNode.Children.AddOpenTag('ItemValues') Do
    Begin
      Attributes.AddAttribute ('invEuroValue', Format('%0.2f', [FinvEuroValue]));
      // MH 04/04/2012 v6.10.1 ABSEXCH-12583: Added statEuroValue attribute
      If StatsValueRequired Then
      Begin
        Attributes.AddAttribute ('statEuroValue', Format('%0.2f', [FstatEuroValue]))
      End; // If FStatsValueRequired
    End; // With oIStatNode.Children.AddOpenTag('ItemValues')
    oIStatNode.Children.AddCloseTag;
  End; // With oIStatNode.Children.AddOpenTag('Party')
  oIStatNode.Children.AddCloseTag;
End; // WriteItemElement

//=========================================================================

Constructor TIrishXMLParty.Create (Const PartyType : Str3);
Var
  oIni : TIniFile;
Begin // Create
  Inherited Create;

  FPartyType := PartyType;
  FVATNumber := '';
  FName := '';
  FAddress[1] := '';
  FAddress[2] := '';
  FAddress[3] := '';
  FContact := '';
  FPhone := '';
  FEmail := '';

  // MH 04/04/2012 v6.10.1 ABSEXCH-12549: Added statsValueRequired attribute
  FStatsValueRequired := False;

  If FileExists(IncludeTrailingPathDelimiter(SetDrive) + 'EIREIntr.Ini') Then
  Begin
    oIni := TIniFile.Create(IncludeTrailingPathDelimiter(SetDrive) + 'EIREIntr.Ini');
    Try
      FArrivals := oIni.ReadInteger('ISTAT', Trim(PartyType)+'Arrivals', 1);
      FDispatch := oIni.ReadInteger('ISTAT', Trim(PartyType)+'Dispatch', 1);
    Finally
      oIni.Free;
    End; // Try..Finally
  End // If FileExists(IncludeTrailingPathDelimeter(SetDrive) + 'EIREIntr.Ini')
  Else
  Begin
    FArrivals := 1;
    FDispatch := 1;
  End; // Else
End; // Create

//------------------------------

Destructor TIrishXMLParty.Destroy;
Begin // Destroy

  Inherited Destroy;
End; // Destroy

//-------------------------------------------------------------------------

Function TIrishXMLParty.GetPartyType : Str3;
Begin // PartyType
  Result := FPartyType;
End; // PartyType

//------------------------------

Function TIrishXMLParty.GetVATNumber : Str30;
Begin // VATNumber
  Result := FVATNumber;
End; // VATNumber
Procedure TIrishXMLParty.SetVATNumber (Value : Str30);
Begin // SetVATNumber
  FVATNumber := Value;
End; // SetVATNumber

//------------------------------

Function TIrishXMLParty.GetName : Str35;
Begin // Name
  Result := FName;
End; // Name
Procedure TIrishXMLParty.SetName (Value : Str35);
Begin // SetName
  FName := Value;
End; // SetName

//------------------------------

Function TIrishXMLParty.GetAddress (Index : ixiAddressIndex) : Str35;
Begin // Address
  Result := FAddress[Index];
End; // Address

Procedure TIrishXMLParty.SetAddress (Index : ixiAddressIndex; Value : Str35);
Begin // SetAddress
  FAddress[Index] := Value;
End; // SetAddress

//------------------------------

Function TIrishXMLParty.GetContact : Str15;
Begin // Contact
  Result := FContact;
End; // Contact

Procedure TIrishXMLParty.SetContact (Value : Str15);
Begin // SetContact
  FContact := Value;
End; // SetContact

//------------------------------

Function TIrishXMLParty.GetPhone : Str15;
Begin // Phone
  Result := FPhone;
End; // Phone

Procedure TIrishXMLParty.SetPhone (Value : Str15);
Begin // SetPhone
  FPhone := Value;
End; // SetPhone

//------------------------------

Function TIrishXMLParty.GetEmail : Str60;
Begin // Email
  Result := FEmail;
End; // Email

Procedure TIrishXMLParty.SetEmail (Value : Str60);
Begin // SetEmail
  FEmail := Value;
End; // SetEmail

//------------------------------

Function TIrishXMLParty.GetArrivals : Byte;
Begin // GetArrivals
  Result := FArrivals;
End; // GetArrivals

Procedure TIrishXMLParty.SetArrivals (Value : Byte);
Begin // SetArrivals
  FArrivals := Value;
End; // SetArrivals

//------------------------------

Function TIrishXMLParty.GetDispatch : Byte;
Begin // GetDispatch
  Result := FDispatch;
End; // GetDispatch

Procedure TIrishXMLParty.SetDispatch (Value : Byte);
Begin // SetDispatch
  FDispatch := Value;
End; // SetDispatch

// MH 04/04/2012 v6.10.1 ABSEXCH-12549: Added statsValueRequired attribute
Function TIrishXMLParty.GetStatsValueRequired  : Boolean;
Begin // GetStatsValueRequired
  Result := FStatsValueRequired;
End; // GetStatsValueRequired

Procedure TIrishXMLParty.SetStatsValueRequired (Value : Boolean);
Begin // SetStatsValueRequired
  FStatsValueRequired := Value;
End; // SetStatsValueRequired

//-------------------------------------------------------------------------

Procedure TIrishXMLParty.WritePartyElement (Const oIStatNode : TGmXmlNode);
Begin // WritePartyElement
  With oIStatNode.Children.AddOpenTag('Party') Do
  Begin
    Attributes.AddAttribute ('address1', FAddress[1]);
    Attributes.AddAttribute ('address2', FAddress[2]);
    Attributes.AddAttribute ('address3', FAddress[3]);
    Attributes.AddAttribute ('contact', FContact);
    Attributes.AddAttribute ('email', FEmail);
    Attributes.AddAttribute ('name', FName);
    Attributes.AddAttribute ('partyType', FPartyType);
    Attributes.AddAttribute ('phone', FPhone);
    Attributes.AddAttribute ('vatNum', FVATNumber);

    If (FPartyType = 'PSI') Then
    Begin
      // The following 'optional' fields are mandatory for PSI
      Attributes.AddAttribute ('arrivals', IntToStr(FArrivals));
      Attributes.AddAttribute ('dispatch', IntToStr(FDispatch));

      // MH 04/04/2012 v6.10.1 ABSEXCH-12549: Added product attribute
      Attributes.AddAttribute ('statsValueRequired', IfThen(FStatsValueRequired, 'Y', 'N'));
    End; // If (FPartyType = 'PSI')
  End; // With oIStatNode.Children.AddOpenTag('Party')

  oIStatNode.Children.AddCloseTag;
End; // WritePartyElement

//=========================================================================

Constructor TIrishXMLIntrastat.Create;
Begin // Create
  Inherited Create;

  FFormVersion := '1';
  FLanguage := 'E';
  FPeriodStart := '';
  FPeriodEnd := '';
  FReturnType := 0;
  FFlow := ' ';
  FStatPeriod := '';
  FPSIPartyO := TIrishXMLParty.Create('PSI');
  FPSIPartyI := FPSIPartyO;
  FTPIPartyO := TIrishXMLParty.Create('TPD');
  FTPIPartyI := FTPIPartyO;
  FItems := TInterfaceList.Create;
  FLastError := '';
End; // Create

//------------------------------

Destructor TIrishXMLIntrastat.Destroy;
Begin // Destroy
  FItems.Clear;
  FItems.Free;

  // NOTE: Do not destroy FPSIPartyO/FTPIPartyO as the reference counting mechanism will do that
  FPSIPartyI := NIL;
  FTPIPartyI := NIL;

  Inherited Destroy;
End; // Destroy

//-------------------------------------------------------------------------

Function TIrishXMLIntrastat.GetFormVersion : Char;
Begin // GetFormVersion
  Result := FFormVersion;
End; // GetFormVersion
Procedure TIrishXMLIntrastat.SetFormVersion (Value : Char);
Begin // SetFormVersion
  FFormVersion := Value;
End; // SetFormVersion

//------------------------------

Function TIrishXMLIntrastat.GetLanguage : Char;
Begin // GetLanguage
  Result := FLanguage;
End; // GetLanguage
Procedure TIrishXMLIntrastat.SetLanguage (Value : Char);
Begin // SetLanguage
  FLanguage := Value;
End; // SetLanguage

//------------------------------

Function TIrishXMLIntrastat.GetPeriodStart : LongDate;
Begin // GetPeriodStart
  Result := FPeriodStart;
End; // GetPeriodStart
Procedure TIrishXMLIntrastat.SetPeriodStart (Value : LongDate);
Begin // SetPeriodStart
  FPeriodStart := Value;
End; // SetPeriodStart

//------------------------------

Function TIrishXMLIntrastat.GetPeriodEnd : LongDate;
Begin // GetPeriodEnd
  Result := FPeriodEnd;
End; // GetPeriodEnd
Procedure TIrishXMLIntrastat.SetPeriodEnd (Value : LongDate);
Begin // SetPeriodEnd
  FPeriodEnd := Value;
End; // SetPeriodEnd

//------------------------------

// Return Element
Function TIrishXMLIntrastat.GetReturnType : Byte;
Begin // GetReturnType
  Result := FReturnType;
End; // GetReturnType
Procedure TIrishXMLIntrastat.SetReturnType (Value : Byte);
Begin // SetReturnTyp
  FReturnType := Value;
End; // SetReturnTyp

//------------------------------

Function TIrishXMLIntrastat.GetFlow : Char;
Begin // GetFlow
  Result := FFlow;
End; // GetFlow
Procedure TIrishXMLIntrastat.SetFlow (Value : Char);
Begin // SetFlow
  FFlow := Value;
End; // SetFlow

//------------------------------

Function TIrishXMLIntrastat.GetStatPeriod : Str6;
Begin // GetStatPeriod
  Result := FStatPeriod;
End; // GetStatPeriod
Procedure TIrishXMLIntrastat.SetStatPeriod (Value : Str6);
Begin // SetStatPeriod
  FStatPeriod := Value;
End; // SetStatPeriod

//------------------------------

Function TIrishXMLIntrastat.GetPSIParty : IIXIParty;
Begin // GetPSIParty
  Result := FPSIPartyI;
End; // GetPSIParty

//------------------------------

Function TIrishXMLIntrastat.GetTPIParty : IIXIParty;
Begin // GetTPIParty
  Result := FTPIPartyI;
End; // GetTPIParty

//------------------------------

// Item Element Array
Function TIrishXMLIntrastat.GetItemCount : LongInt;
Begin // GetItemCount
  Result := FItems.Count;
End; // GetItemCount
Function TIrishXMLIntrastat.GetItems (Index : LongInt) : IIXIItem;
Begin // GetItems
  If (Index >= 0) And (Index < FItems.Count) Then
    Result := FItems.Items[Index] As IIXIItem
  Else
    Raise Exception.Create ('TIrishXMLIntrastat.GetItems: Invalid Index (' + IntToStr(Index) + ')');
End; // GetItems

//------------------------------

// Error message generated by SaveToFile
Function TIrishXMLIntrastat.GetLastError : ShortString;
Begin // GetLastError
  Result := FLastError;
End; // GetLastError

//-------------------------------------------------------------------------

// Returns a new IIXIItem for population and saving
Function TIrishXMLIntrastat.NewItem : IIXIItem;
Begin // NewItem
  Result := TIrishXMLItem.Create (Self);
End; // NewItem

//-------------------------------------------------------------------------

// Called from IIXIItem.Save to add itself into the items list
Procedure TIrishXMLIntrastat.SaveItem (Const Item : TIrishXMLItem);
Begin // SaveItem
  FItems.Add(Item);
End; // SaveItem

//-------------------------------------------------------------------------

Procedure TIrishXMLIntrastat.WriteIStatAtts (Const oIStatNode : TGmXmlNode);

  // Reformats InDate (YYYYMMDD) to DD/MM/YYYY
  Function FormatDate (Const InDate : LongDate) : ShortString;
  Begin // FormatDate
    If (InDate <> '') Then
      Result := Copy(InDate, 7, 2) + '/' + Copy(InDate, 5, 2) + '/' + Copy(InDate, 1, 4)
    Else
      Result := '';
  End; // FormatDate

Begin // WriteIStatAtts
  oIStatNode.Attributes.AddAttribute ('formversion', FFormVersion);
  oIStatNode.Attributes.AddAttribute ('language', FLanguage);
  oIStatNode.Attributes.AddAttribute ('periodend', FormatDate (FPeriodEnd));
  oIStatNode.Attributes.AddAttribute ('periodstart', FormatDate (FPeriodStart));
  // MH 04/04/2012 v6.10.1 ABSEXCH-12549: Added product attribute
  oIStatNode.Attributes.AddAttribute ('product', 'Exchequer');
End; // WriteIStatAtts

//------------------------------

Procedure TIrishXMLIntrastat.WriteReturnElement (Const oIStatNode : TGmXmlNode);
Begin // WriteReturnElement
  With oIStatNode.Children.AddOpenTag('Return') Do
  Begin
    Attributes.AddAttribute ('flow', FFlow);
    Attributes.AddAttribute ('returnType', IntToStr(FReturnType));
    Attributes.AddAttribute ('statPeriod', FStatPeriod);
  End; // With oIStatNode.Children.AddOpenTag('Return')

  oIStatNode.Children.AddCloseTag;
End; // WriteReturnElement

//------------------------------

// Save to XML file - 0 = AOK, anything else is BAD
//
//  -1   Unhandled Exception - see LastError
//   0   AOK
//   1   File already exists
//
Function TIrishXMLIntrastat.SaveToFile (Const Filename : ShortString) : LongInt;
Var
  oXML : TGmXML;
  oIStat : TGmXmlNode;
  iItem : SmallInt;
Begin // SaveToFile
  Try
    If (Not FileExists(Filename)) Then
    Begin
      oXML := TGmXML.Create(nil);
      Try
        oXML.Encoding := 'UTF-8';

        // IStat Attributes
        oIStat := oXML.Nodes.AddOpenTag('Istat');
        WriteIStatAtts (oIStat);

        // Return Element
        WriteReturnElement (oIStat);

        // Party Elements
        FPSIPartyO.WritePartyElement (oIStat);
        If (FTPIPartyI.Name <> '') Then
          FTPIPartyO.WritePartyElement (oIStat);

        // MH 04/04/2012 v6.10.1 ABSEXCH-12583: Pass statsValueRequired setting through to control whether statEuroValue is written out
        // Items
        For iItem := 0 To (FItems.Count - 1) Do
          (FItems[iItem] As IIXIItemInternal).WriteItemElement(oIStat, FPSIPartyI.StatsValueRequired);

        // Close IStat element
        oXML.Nodes.AddCloseTag;

        oXML.SaveToFile(FileName);

        Result := 0;
        FLastError := '';
      Finally
        oXML.Free;
      End; // Try..Finally
    End // If (Not FileExists(Filename))
    Else
    Begin
      Result := 1;
      FLastError := 'Destination File ' + QuotedStr(FileName) + ' already exists';
    End; // Else
  Except
    On E:Exception Do
    Begin
      FLastError := 'Unhandled Exception - ' + E.Message;
      Result := -1;
    End;
  End; // Try..Except
End; // SaveToFile

//=========================================================================

end.
