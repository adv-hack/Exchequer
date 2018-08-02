unit JobAppsCustomFields;

interface


  function AddJobAppsCustomFields(var ErrString : string) : Integer; STDCALL;

implementation

uses
  VarConst, GlobVar, CustomFieldsVar, CustomFieldsIntf, BTConst, BTUtil, SysUtils;


function AddJobAppsCustomFields(var ErrString : string) : Integer;
var
  iCFNo, iIndex : integer;
  CustomFieldSettings : TCustomFieldSettings;
  Res : Integer;
  CustomFieldFile : TFileVar;
begin
  //Open file - can't go through EL's standard funcs as CustomFields isn't included in File arrays
  Result := BTOpenFile(CustomFieldFile, SetDrive + CustomFieldSettingsFilename, 0, NIL, ExBTOWNER);
  if Result = 0 then
  Try
    FillChar(CustomFieldSettings, SizeOf(CustomFieldSettings), 0);

    //Set fields that don't change
    CustomFieldSettings.cfStopChar := '!';
    CustomFieldSettings.cfSupportsEnablement := True;
    CustomFieldSettings.cfEnabled := True;

    for iCFNo := cfJCTHeader to cfJSALine do
    begin
      for iIndex := 1 to 10 do
      begin
        CustomFieldSettings.cfFieldId := (iCFNo * 1000) + iIndex;
        CustomFieldSettings.cfCaption := 'User Def ' + IntToStr(iIndex);

        Result := BTAddRecord(CustomFieldFile, CustomFieldSettings, SizeOf(CustomFieldSettings), 0);

        //PR: 28/03/2012 Change to allow error 5 (duplicate record, since we don't care if it's already there.
        if Result = 5 then
          Result := 0;

        if Result <> 0 then
        begin
          ErrString := 'Error ' + IntToStr(Result) + ' occurred when adding record ' +
                       IntToStr(CustomFieldSettings.cfFieldId) + ' to Custom Fields file.';
          //Break out of loop if we have an error
          Break;
        end;
      end;
    end;
  Finally
    BTCloseFile(CustomFieldFile);
  End
  else
    ErrString := 'Error ' + IntToStr(Result) + ' occurred trying to open file ' + SetDrive + CustomFieldSettingsFilename;
end;

end.
