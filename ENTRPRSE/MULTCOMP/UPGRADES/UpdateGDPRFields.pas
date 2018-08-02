unit UpdateGDPRFields;

interface

  function InitialisePIIHighlighColor(var aErrStr : string) : Integer;

  //RB 16/11/2017 2018-R1 ABSEXCH-19282: GDPR -Extending UDF fields for PII flag
  function InitialisePIIFlags(var aErrStr: String): Integer;

implementation

uses
  GlobVar,
  Windows,
  VarRec2U,
  BtrvU2,
  VarConst,
  SysUtils,
  BTConst,
  CustomFieldsVar,
  CustomFieldsIntf,
  BTUtil;

function InitialisePIIHighlighColor(var aErrStr : string) : Integer;
var
  lRes : Integer;
  lKeyS : Str255;
begin
  Result := 0;
  Open_System(MLocF, MLocF);
  try
    lKeyS := 'PD';

    lRes := Find_Rec(B_GetGEq, F[MLocF], MLocF, RecPtr[MLocF]^, MLK, lKeyS);
    while (lRes = 0) and (MLocCtrl^.RecPFix = 'P') and (MLocCtrl^.Subtype = 'D') do
    begin
      //Update default color value.
      if MLocCtrl.PassDefRec.HighlightPIIColour = 0 then
      begin
        MLocCtrl.PassDefRec.HighlightPIIColour := RGB(237, 139, 0);
        lRes := Put_Rec(F[MLocF], MLocF, RecPtr[MLocF]^, 0);
      end;

      if lRes <> 0 then
      begin
        aErrStr := 'Error ' + IntToStr(lRes) + ' occurred updating PII Highlight Color';
        Result := -1;
      end
      else
        lRes := Find_Rec(B_GetNext, F[MLocF], MLocF, RecPtr[MLocF]^, 0, lKeyS);
    end;
  except
    on E:Exception do
    begin
      aErrStr := E.Message;
      Result := -1;
    end;
  End;
  Close_Files(True);
end;

//------------------------------------------------------------------------------

function InitialisePIIFlags(var aErrStr: String): Integer;
var
  lCustomFieldSettings : TCustomFieldSettings;
  lTempRec: TCustomFieldSettings;
  lRes : Integer;
  lCustomFieldFile : TFileVar;
  lKeyS: Str255;
begin
  Result := 0;
  //Open file - can't go through EL's standard funcs as CustomFields isn't included in File arrays
  Result := BTOpenFile(lCustomFieldFile, SetDrive + CustomFieldSettingsFilename, 0, NIL, ExBTOWNER);

  if (Result = 0) then
  begin
    try
      FillChar(lCustomFieldSettings, SizeOf(lCustomFieldSettings), 0);
      lKeyS := '';
      lRes := BTFindRecord(B_GetFirst, lCustomFieldFile, lCustomFieldSettings, SizeOf(lCustomFieldSettings), 0, lKeyS);

      //loop through every record in CUSTOMFIELDS and initialise PII flags
      while (lRes = 0) and (lRes <> 9) do
      begin
        with lCustomFieldSettings do
        begin
          cfContainsPIIData := False;          
          //Set cfDisplayPIIOption only for UDFs which are within PII scope.
          //Below is the list of fields which are outside PII scope
          if ((cfFieldID >= 3001) and (cfFieldID <= 3004)) or
             ((cfFieldID >= 20001) and (cfFieldID <= 20012)) or
             ((cfFieldID >= 21001) and (cfFieldID <= 21010)) or
             ((cfFieldID >= 22001) and (cfFieldID <= 22010)) or
             ((cfFieldID >= 23001) and (cfFieldID <= 23012)) or
             ((cfFieldID >= 24001) and (cfFieldID <= 24010)) or
             ((cfFieldID >= 25001) and (cfFieldID <= 25012)) or
             ((cfFieldID >= 26001) and (cfFieldID <= 26010)) or
             ((cfFieldID >= 37001) and (cfFieldID <= 37012)) or
             ((cfFieldID >= 38001) and (cfFieldID <= 38010)) or
             ((cfFieldID >= 45001) and (cfFieldID <= 45005)) or
             ((cfFieldID >= 46001) and (cfFieldID <= 46002)) then
            cfDisplayPIIOption := False
          else
            cfDisplayPIIOption := True;
        end;

        lRes := BTUpdateRecord(lCustomFieldFile, lCustomFieldSettings, SizeOf(lCustomFieldSettings), 0, lKeyS);
        if (lRes = 0) then
          lRes := BTFindRecord(B_GetNext, lCustomFieldFile, lCustomFieldSettings, SizeOf(lCustomFieldSettings), 0, lKeyS)
        else
          Result := -1;
      end;
    finally
      BTCloseFile(lCustomFieldFile);
    end;
  end
  else
    aErrStr := 'Error ' + IntToStr(Result) + ' occured trying to open file ' + SetDrive + CustomFieldSettingsFileName;
end;

end.
