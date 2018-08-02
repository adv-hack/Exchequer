unit oFTKLic;

interface

Uses Classes, DateUtils, Dialogs, Forms, SysUtils, Windows;

Const
  FlgIdxSpare1 = 1;
  FlgIdxPerpetualLicence = 2;        // Licence Never Expires - expiry date ignored
  FlgIdxDemoLicence = 3;             // Print Forms in Demo Mode
  FlgIdxSpare4 = 4;
  FlgIdxSpare5 = 5;
  FlgIdxSpare6 = 6;
  FlgIdxSpare7 = 7;
  FlgIdxSpare8 = 8;
  FlgIdxSpare9 = 9;
  FlgIdxSpare10 = 10;
  FlgIdxSpare11 = 11;
  FlgIdxSpare12 = 12;
  FlgIdxSpare13 = 13;
  FlgIdxSpare14 = 14;
  FlgIdxSpare15 = 15;
  FlgIdxSpare16 = 16;
  FlgIdxSpare17 = 17;
  FlgIdxSpare18 = 18;
  FlgIdxSpare19 = 19;
  FlgIdxSpare20 = 20;
  FlgIdxSpare21 = 21;
  FlgIdxSpare22 = 22;
  FlgIdxSpare23 = 23;
  FlgIdxSpare24 = 24;
  FlgIdxSpare25 = 25;
  FlgIdxSpare26 = 26;
  FlgIdxSpare27 = 27;
  FlgIdxSpare28 = 28;
  FlgIdxSpare29 = 29;
  FlgIdxSpare30 = 30;

Type
  TString2 = String[2];
  TString3 = String[3];
  TString4 = String[4];
  TString8 = String[8];

  TFormsTKLicence = Class (TObject)
  Private
    FExpiryDate   : TDateTime;
    FLicenceFlags : LongInt;
    FLicenceNo    : ShortString;
    FShortDesc    : TString8;
    FProductName  : ShortString;
    FVersion      : Byte;
  Protected
    // Property methods
    procedure SetShortDesc(const Value: TString8);
    procedure SetLicenceNo(const Value: ShortString);
    function GetLicenceFlags(Index: Integer): Boolean;
    procedure SetLicenceFlags(Index: Integer; const Value: Boolean);
    procedure SetExpiryDate(const Value: TDateTime);
    procedure SetProductName(const Value: ShortString);

    // Internal methods
    Function  CalcCheckSumS2(ChkStr : ShortString) : TString2;
    procedure CalcLicence;
    procedure DecodeLicence;
    function  TwoToThe (Const Power:Byte): LongInt;
  Public
    Constructor Create;

    Property ExpiryDate : TDateTime Read FExpiryDate Write SetExpiryDate;
    Property LicenceFlags [Index : Integer] : Boolean Read GetLicenceFlags Write SetLicenceFlags;
    Property LicenceNo : ShortString Read FLicenceNo Write SetLicenceNo;
    Property ProductName : ShortString Read FProductName Write SetProductName;
    Property ProductShortDesc : TString8 Read FShortDesc Write SetShortDesc;
    Property Version : Byte Read FVersion;
  End; { TFormsTKLicence }

implementation

Uses Base34;

//------------------------------------------------------------------------

Constructor TFormsTKLicence.Create;
Begin { Create }
  Inherited;

  // Initialise all the licencing fields
  FLicenceFlags := 0;
  FShortDesc := '';
  FExpiryDate := Now;
  FLicenceNo := '';
  FProductName := '';
  FVersion := 1;

  // Calculate the Licence Number
  CalcLicence;
End; { Create }

//------------------------------------------------------------------------

//
// Licence No
// ==========
//
//    "aaaaaaaa-bbcccc-dddeff"
//
//   aaaaaaaa      Short Description of product/licencee
//   bb            Checksum on Product Name
//
//   cccc          Boolean Flags section - 20 flags - see constants at top of module for more details
//
//   ddd           Expiry Date (Number of Days from 01/01/2002)
//
//   e             Licence Version No - change to add additional sections to licence no or to
//                 expire all previous licences :-)
//
//   ff            CheckSum on entire Licence No
//
procedure TFormsTKLicence.CalcLicence;

  Function GetShortDesc : TString8;
  Begin { GetShortDesc }
    Result := Copy (Trim(FShortDesc) + StringOfChar('0', 8), 1, 8);
  End; { GetShortDesc }

  //-----------------------

  Function CalcLicenceFlags : TString4;
  Var
    B34Str : ShortString;
  Begin { CalcLicenceFlags }
    // Encode LongInt - Not flags to enable most flags and then remove anything over bit 20
    If Encode34LI ((NOT FLicenceFlags) And 1048575, B34Str) Then
      Result := B34Str
    Else
      Raise Exception.Create ('Error Encoding Licencing Flags');
  End; { CalcLicenceFlags }

  //-----------------------

  Function EncodeExpiryDate : TString3;
  Var
    B34Str  : ShortString;
    TmpDate : TDateTime;
    NoDays  : LongInt;
  Begin { EncodeExpiryDate }
    If TryEncodeDate (2002, 1, 1, TmpDate) Then Begin
      // Calculate number
      NoDays := DaysBetween (FExpiryDate, TmpDate);
      If (NoDays >= 0) And (NoDays < 39300) Then
        If Encode34LI (NoDays, B34Str) Then
          Result := Copy (B34Str, 2, 3)
        Else
          Raise Exception.Create ('Error Encoding BaseDate in EncodeExpiryDate')
      Else
        Raise Exception.Create ('Date Difference out of valid range in EncodeExpiryDate');
    End { If TryEncodeDate}
    Else
      Raise Exception.Create('Error generating BaseDate in EncodeExpiryDate');
  End; { EncodeExpiryDate }

  //-----------------------

  Function CalcLicVer : Char;
  Var
    B34Str : ShortString;
  Begin { CalcLicVer }
    // Encode the Version - max version = 34
    If Encode34B (FVersion, B34Str) Then
      Result := B34Str[1]
    Else
      Raise Exception.Create ('Error Encoding Version in CalcLicVer')
  End; { CalcLicVer }

  //-----------------------

Begin { CalcLicence }
  FLicenceNo :=              GetShortDesc +                    //   aaaaaaaa      Short Description of product/licencee
                             '-' +                             //   -
                             CalcCheckSumS2(FProductName) +    //   bb            Checksum on Product Name
                             CalcLicenceFlags +                //   cccc          Boolean Flags section
                             '-' +                             //   -
                             EncodeExpiryDate +                //   ddd           Expiry Date (Number of Days from 01/01/2002)
                             CalcLicVer;                       //   e             Licence Version No
  FLicenceNo := FLicenceNo + CalcCheckSumS2(FLicenceNo);       //   ff            CheckSum on entire Licence No
End; { CalcLicence }

//------------------------------------------------------------------------

procedure TFormsTKLicence.DecodeLicence;
Var
  NoDays : LongInt;
Begin { DecodeLicence }
  // Check length
  If (Length(FLicenceNo) = 22) Then Begin
    // Check structure
    If (FLicenceNo [9] = '-') And (FLicenceNo [16] = '-') Then Begin
      // Extract and test main checksum on Licence No string
      If (CalcCheckSumS2(Copy (FLicenceNo, 1, 20)) <> Copy (FLicenceNo, 21, 2)) Then
        Raise Exception.Create ('(E007) CheckSum Mismatch');

      // Extract Short Description
      FShortDesc := Copy (FLicenceNo, 1, 8);

      // Extract and test checksum on product name
      If (CalcCheckSumS2(FProductName) <> Copy (FLicenceNo, 10, 2)) Then
        Raise Exception.Create ('(E021) CheckSum Mismatch');

      // Extract Boolean Flags
      If Decode34LI (Copy (FLicenceNo, 12, 4), FLicenceFlags) Then
        FLicenceFlags := Not FLicenceFlags
      Else
        Raise Exception.Create ('(E023) Error extracting Licence Flags');

      // Extract Expiry Date
      If Decode34LI ('0' + Copy (FLicenceNo, 17, 3), NoDays) Then
        // Setup basedate
        If TryEncodeDate (2002, 1, 1, FExpiryDate) Then Begin
          FExpiryDate := FExpiryDate + NoDays;
        End { If TryEncodeDate }
        Else
          Raise Exception.Create ('(E056) Error establishing Base Licencing Date')
      Else
        Raise Exception.Create ('(E024) Error extracting Licence Flags');

      // Version
      If Not Decode34B (Copy (FLicenceNo, 20, 1), FVersion) Then
        Raise Exception.Create ('(E028) Error extracting Licence Version');
    End { If }
    Else
      Raise Exception.Create ('(E013) Invalid Licence Number');
  End { If }
  Else
    Raise Exception.Create ('(E012) Invalid Licence Number');
End; { DecodeLicence}

//------------------------------------------------------------------------

procedure TFormsTKLicence.SetShortDesc(const Value: TString8);
begin
  If (FShortDesc <> Value) Then Begin
    FShortDesc := Value;
    CalcLicence;
  End; { If (FShortDesc <> Value) }
end;

//-----------------------------------

procedure TFormsTKLicence.SetLicenceNo(const Value: ShortString);
begin
  If (FLicenceNo <> Value) Then Begin
    FLicenceNo := Value;
    DecodeLicence;
  End; { If (FLicenceNo <> Value) }
end;

//-----------------------------------

function TFormsTKLicence.TwoToThe (Const Power:Byte): LongInt;
Var
  I : Byte;
Begin { TwoToThe }
  Result := 1;

  If (Power>1) Then
    For I := 2 To Power Do
      Result := Result * 2;
End; { TwoToThe }

function TFormsTKLicence.GetLicenceFlags(Index: Integer): Boolean;
Var
  FlagVal : LongInt;
begin
  If (Index >= 1) And (Index <= 20) Then Begin
    FlagVal := TwoToThe(Index);
    Result := (FLicenceFlags And FlagVal) = FlagVal;
  End { If (Index >= 1) And (Index <= 20) }
  Else
    Raise Exception.Create ('Invalid Flag Index (' + IntToStr(Index) + ')');
end;

procedure TFormsTKLicence.SetLicenceFlags(Index: Integer; const Value: Boolean);
begin
  If (Index >= 1) And (Index <= 20) Then Begin
    // Check for changes required
    If Value And (Not GetLicenceFlags(Index)) Then Begin
      // Need to Add it into the Flags
      FLicenceFlags := FLicenceFlags + TwoToThe(Index);
      CalcLicence;
    End { If Value And (Not GetLicenceFlags(Index)) }
    Else
      If (Not Value) And GetLicenceFlags(Index) Then Begin
        // Remove from Licence Flags
        FLicenceFlags := FLicenceFlags - TwoToThe(Index);
        CalcLicence;
      End; { If (Not Value) And GetLicenceFlags(Index) }
  End { If (Index >= 1) And (Index <= 20) }
  Else
    Raise Exception.Create ('Invalid Flag Index (' + IntToStr(Index) + ')');
end;

//-----------------------------------

procedure TFormsTKLicence.SetExpiryDate(const Value: TDateTime);
begin
  If (Value <> FExpiryDate) Then Begin
    FExpiryDate := Value;
    CalcLicence;
  End { If (Value <> FExpiryDate) }
end;

//-----------------------------------

procedure TFormsTKLicence.SetProductName(const Value: ShortString);
begin
  If (Value <> FProductName) Then Begin
    FProductName := Value;
    CalcLicence;
  End { If (Value <> FProductName) }
end;

//------------------------------------------------------------------------

Function TFormsTKLicence.CalcCheckSumS2(ChkStr : ShortString) : TString2;
Var
  ChkSumTot : LongInt;
  ChkSum, I : Integer;
  B34Str    : ShortString;
Begin { CalcCheckSumS2 }
  ChkStr := UpperCase(ChkStr);

  // Calculate the total
  ChkSumTot := 0;
  If (Length(ChkStr) > 0) Then
    For I := 1 To Length(ChkStr) Do
      Inc (ChkSumTot, Ord(ChkStr[I]));

  // calculate the Checksum
  ChkSum := ChkSumTot Mod 255;

  // Encode it
  If Encode34I (ChkSum, B34Str) Then
    Result := B34Str
  Else
    Raise Exception.Create ('Error Encoding CheckSum in CalcCheckSumS2')
End; { CalcCheckSumS2 }

//-----------------------


end.
