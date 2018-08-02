unit AddressCustomFields;

interface

  function AddAddressCustomFields(var ErrString : string) : Integer;

implementation

uses
  Dialogs, VarConst, GlobVar, CustomFieldsVar, CustomFieldsIntf, BTConst, BTUtil, SysUtils;

// Copied from ACCreditCardCustomFields.pas

function AddAddressCustomFields(var ErrString : string) : Integer;
var
  iCFNo, iIndex : integer;
  CustomFieldSettings : TCustomFieldSettings;
  Res : Integer;
  CustomFieldFile : TFileVar;

  //------------------------------

  Procedure AddCustomField (Const FieldId : Integer; Const FieldDesc : ShortString);
  Var
    TempRec : TCustomFieldSettings;
    sKey : Str255;
    iStatus : Integer;
  Begin // AddCustomField
    If (Result = 0) Then
    Begin
      CustomFieldSettings.cfFieldId := FieldId;
      CustomFieldSettings.cfCaption := FieldDesc;

      // MH 17/12/2014 v7.1 ABSEXCH-15952: Check for existing record - the MS SQL version
      // incorrectly allows duplicates so we need to manually check
      sKey := BTFullNomKey(CustomFieldSettings.cfFieldId) + CustomFieldSettings.cfStopChar;
      iStatus := BTFindRecord(B_GetEq, CustomFieldFile, TempRec, SizeOf(TempRec), 0, sKey);
      If (iStatus = 4) Then
      Begin
        Result := BTAddRecord(CustomFieldFile, CustomFieldSettings, SizeOf(CustomFieldSettings), 0);

        if Result <> 0 then
        begin
          ErrString := 'Error ' + IntToStr(Result) + ' occurred when adding record ' +
                         IntToStr(CustomFieldSettings.cfFieldId) + ' to Custom Fields file.';
        end;
      End; // If (iStatus = 4)
    End; // If (Result = 0)
  End; // AddCustomField

  //------------------------------

begin
  //Open file - can't go through EL's standard funcs as CustomFields isn't included in File arrays
  Result := BTOpenFile(CustomFieldFile, SetDrive + CustomFieldSettingsFilename, 0, NIL, ExBTOWNER);
  if Result = 0 then
  Try
    FillChar(CustomFieldSettings, SizeOf(CustomFieldSettings), 0);

    //Set fields that don't change
    CustomFieldSettings.cfStopChar := '!';
    CustomFieldSettings.cfSupportsEnablement := False;
    CustomFieldSettings.cfEnabled := True;

    // Customer ------------------------------------------
    AddCustomField (45001, 'Line 1');  // Credit Card Number : Str30
    AddCustomField (45002, 'Line 2');  // Credit Card Valid From : LongDate
    AddCustomField (45003, 'Line 3');  // Credit Card Expiry : LongDate
    AddCustomField (45004, 'Town');  // Credit Card Name : Str50
    AddCustomField (45005, 'County');  // Credit Card Issue Number : Str4
  Finally
    BTCloseFile(CustomFieldFile);
  End
  else
    ErrString := 'Error ' + IntToStr(Result) + ' occurred trying to open file ' + SetDrive + CustomFieldSettingsFilename;
end;

end.