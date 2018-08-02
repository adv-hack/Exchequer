unit CustomFieldsVar;
{$ALIGN 1}
interface

uses
  BtrvU2;


const
  CustomFieldSettingsFilename = 'Misc\CustomFields.Dat';
  CustomFieldNoOfIndexes  = 1;
  CustomFieldNoOfSegments = 2;

type

  TCustomFieldSettings = Record
    cfFieldID     : Longint;
    cfStopChar    : Char;
    cfSupportsEnablement : Boolean;
    cfEnabled     : Boolean;
    cfCaption     : String[30];
    cfDescription : String[255];

    //RB 16/2017 2018-R1 ABSEXCH-19282: GDPR -Extending UDF fields for PII flag
    // Display the PII Option in System Setup - User Defined Fields
    cfDisplayPIIOption : Boolean;
    // User has specified this is a PII Field
    cfContainsPIIData : Boolean;

    Spare : Array[1..98] of Byte;
  end;

  TCustomFieldSettingsFileDef =
  record
    RecLen,
    PageSize,
    NumIndex  :  SmallInt;
    NotUsed   :  LongInt;
    Variable  :  SmallInt;
    Reserved  :  array[1..4] of char;
    KeyBuff   :  array[1..CustomFieldNoOfSegments] of KeySpec;
    AltColt   :  AltColtSeq;
  end;


  {$IFDEF MAKEFILE}
  //These functions are only needed to create and populate the Custom Fields data file, so shouldn't be compiled into the release exe.
  procedure FillCustomFieldFile(const Datapath : string);
  procedure CreateCustomFieldFile(const Datapath : string);
  {$ENDIF}

implementation

Uses
  BTUtil, BTConst, SysUtils, Dialogs{$IFDEF MAKEFILE}, CustomFieldsIntf{$ENDIF};

const
  Segment = 16;

var
  CustomFieldSettings : TCustomFieldSettings;
  CustomFieldSettingsFile : TCustomFieldSettingsFileDef;

procedure DefineCustomFieldSettings;
begin
  FillChar(CustomFieldSettingsFile, SizeOf(CustomFieldSettingsFile), 0);
  with CustomFieldSettingsFile do
  begin
    RecLen := Sizeof(TCustomFieldSettings);
    PageSize := 2048; //DefPageSize * 2;
    NumIndex := CustomFieldNoOfIndexes;
    Variable := B_Variable+B_Compress+B_BTrunc; {* Used for max compression *}

    FillChar(KeyBuff, SizeOf(KeyBuff), 0);

    //Key 0 - cfFieldID + cfStopChar ('!')
    KeyBuff[1].KeyPos     := BtKeyPos(@CustomFieldSettings.cfFieldID, @CustomFieldSettings);
    KeyBuff[1].KeyLen     := SizeOf(CustomFieldSettings.cfFieldId);
    KeyBuff[1].KeyFlags   := Segment + ExtType;
    KeyBuff[1].ExtTypeVal := BInteger;

    KeyBuff[2].KeyPos     := BtKeyPos(@CustomFieldSettings.cfStopChar, @CustomFieldSettings);
    KeyBuff[2].KeyLen     := SizeOf(CustomFieldSettings.cfStopChar);
  end;

end;

{$IFDEF MAKEFILE}
const
  AlwaysEnabledSet = [cfCustomer, cfSupplier, cfStock, cfJob, cfEmployee]; //Can't disable so cfSupportsEnablement is always false.

//Procedure to fill a custom field file with default records.
procedure FillCustomFieldFile(const Datapath : string);
const
  LineTypeNames : Array[1..4] of string[9] = ('Labour', 'Materials', 'Freight', 'Discount');
  AddressNames  : array[1..5] of string = ('Address 1', 'Address 2', 'Address 3', 'Town', 'County');
var
  FV : TFileVar;
  Res, UDCat, UDNo : Integer;
  CustomFieldRec : TCustomFieldSettings;
  upperBound : integer;
begin
  Res := BTOpenFile(FV, DataPath + CustomFieldSettingsFileName, 0);
  if Res = 0 then
  begin
    // Loop through all of the categories.  Update this range if new categories
    //  are added to CustomFieldsIntf.pas
    for UDCat := cfCustomer to cfTaxRegion do
    begin
      // PKR. 05/04/2016. We now have several different category sizes, so set the
      // upper bound of the loop dynamically.
      upperBound := 10; // Default to keep the compiler happy.
      if UDCat in Cat4Set         then upperBound :=  4;
      if UDCat in CatTraderSet    then upperBound := 15;
      if UDCat in CatHeaderSet    then upperBound := 12;
      if UDCat in CatLineSet      then upperBound := 10;
      if UDCat in CatAddressSet   then upperBound :=  5;
      if UDCat in CatTaxRegionSet then upperBound :=  2;

      for UDNo := 1 to upperBound do
      begin
        FillChar(CustomFieldRec, SizeOf(CustomFieldRec), 0);
{        if (UDCat = cfLineTypes) and (UDNo > 4) then
          BREAK; //Only 4 line types so break out of inner loop.}
        CustomFieldRec.cfFieldId := (1000 * UDCat) + UDNo;
        CustomFieldRec.cfStopChar := '!';
        CustomFieldRec.cfEnabled := True;

        // Line Types
        if UDCat = cfLineTypes then
        begin
          CustomFieldRec.cfCaption := LineTypeNames[UDNo]
        end;

        // User Defined Fields
        if (UDCat in CatUDFSet) or (UDCat in cfTaxRegionSet) then
        begin
          CustomFieldRec.cfCaption := 'User Def ' + IntToStr(UDNo);
        end;

        // Address Fields
        if UDCat in CatAddressSet then
        begin
          CustomFieldRec.cfCaption := AddressNames[UDNo];
        end;

        CustomFieldRec.cfSupportsEnablement := not (UDCat in AlwaysEnabledSet);

        Res := BTAddRecord(FV, CustomFieldRec, SizeOf(CustomFieldRec), 0);

        if Res <> 0 then
          raise Exception.CreateFmt('Unable to add record %d. Btrieve error: %d', [CustomFieldRec.cfFieldId, Res]);
      end; //For UDNo
    end; //For UDCat
  end
  else
    raise Exception.CreateFmt('Unable to open file %s. Btrieve error: %d', [DataPath + CustomFieldSettingsFileName, Res]);
end;


procedure CreateCustomFieldFile(const Datapath : string);
var
  FV : TFileVar;
  Res : Integer;
begin
  DefineCustomFieldSettings;

  Res := BTMakeFile(FV, DataPath + CustomFieldSettingsFileName, CustomFieldSettingsFile,
                     SizeOf(TCustomFieldSettings));
  ShowMessage(CustomFieldSettingsFileName + ': ' + IntTosTr(Res));

end;
{$ENDIF MAKEFILE}
end.
