unit AddTHCustomFields;

interface


function AddNewTHCustomFields(var ErrString : string) : Integer;

implementation

uses
  Dialogs, VarConst, GlobVar, CustomFieldsVar, CustomFieldsIntf, BTConst, BTUtil, SysUtils;

// Copied from JobAppsCustomFields.pas

function AddNewTHCustomFields(var ErrString : string) : Integer;
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

begin // AddNewTHCustomFields
  //Open file - can't go through EL's standard funcs as CustomFields isn't included in File arrays
  Result := BTOpenFile(CustomFieldFile, SetDrive + CustomFieldSettingsFilename, 0, NIL, ExBTOWNER);
  if Result = 0 then
  Try
    FillChar(CustomFieldSettings, SizeOf(CustomFieldSettings), 0);

    //Set fields that don't change
    CustomFieldSettings.cfStopChar := '!';
    CustomFieldSettings.cfSupportsEnablement := True;
    CustomFieldSettings.cfEnabled := True;

    // MH 25/05/2016 2016-R2: Add 2 new TH User Defined Fields
    // cfSINHeader = 4;
    AddCustomField (4011, 'User Def 11');
    AddCustomField (4012, 'User Def 12');
    // cfSRCHeader = 6;
    AddCustomField (6011, 'User Def 11');
    AddCustomField (6012, 'User Def 12');
    // cfSQUHeader = 8;
    AddCustomField (8011, 'User Def 11');
    AddCustomField (8012, 'User Def 12');
    // cfSORHeader = 10;
    AddCustomField (10011, 'User Def 11');
    AddCustomField (10012, 'User Def 12');
    // cfPINHeader = 12;
    AddCustomField (12011, 'User Def 11');
    AddCustomField (12012, 'User Def 12');
    // cfPPYHeader = 14;
    AddCustomField (14011, 'User Def 11');
    AddCustomField (14012, 'User Def 12');
    // cfPQUHeader = 16;
    AddCustomField (16011, 'User Def 11');
    AddCustomField (16012, 'User Def 12');
    // cfPORHeader = 18;
    AddCustomField (18011, 'User Def 11');
    AddCustomField (18012, 'User Def 12');
    // cfNOMHeader = 20;
    AddCustomField (20011, 'User Def 11');
    AddCustomField (20012, 'User Def 12');
    // cfADJHeader = 23;
    AddCustomField (23011, 'User Def 11');
    AddCustomField (23012, 'User Def 12');
    // cfWORHeader = 25;
    AddCustomField (25011, 'User Def 11');
    AddCustomField (25012, 'User Def 12');
    // cfTSHHeader = 29;
    AddCustomField (29011, 'User Def 11');
    AddCustomField (29012, 'User Def 12');
    // cfSRNHeader = 31;
    AddCustomField (31011, 'User Def 11');
    AddCustomField (31012, 'User Def 12');
    // cfPRNHeader = 33;
    AddCustomField (33011, 'User Def 11');
    AddCustomField (33012, 'User Def 12');
    // cfJCTHeader = 35;
    AddCustomField (35011, 'User Def 11');
    AddCustomField (35012, 'User Def 12');
    // cfJPTHeader = 37;
    AddCustomField (37011, 'User Def 11');
    AddCustomField (37012, 'User Def 12');
    // cfJSTHeader = 39;
    AddCustomField (39011, 'User Def 11');
    AddCustomField (39012, 'User Def 12');
    // cfJPAHeader = 41;
    AddCustomField (41011, 'User Def 11');
    AddCustomField (41012, 'User Def 12');
    // cfJSAHeader = 43;
    AddCustomField (43011, 'User Def 11');
    AddCustomField (43012, 'User Def 12');
  Finally
    BTCloseFile(CustomFieldFile);
  End
  else
    ErrString := 'Error ' + IntToStr(Result) + ' occurred trying to open file ' + SetDrive + CustomFieldSettingsFilename;
end; // AddNewTHCustomFields

end.
