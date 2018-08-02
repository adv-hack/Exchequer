unit CCDeptU;

interface
uses
  DataModule, BTFile, APIUtil, StrUtils, StdCtrls;

const
  sPlugInName = 'Exchequer CC/Dept Validation Plug-In';
  {$IFDEF EX600}
    {$IFDEF BROOKSBY}
      sVersionNo = '147b';
    {$ELSE}
      sVersionNo = '147';
    {$ENDIF}
  {$ELSE}
    sVersionNo = 'v5.71.146';
  {$ENDIF}
  NoOfVATCodes = 21;
  VATCodeList : Array [1..NoOfVATCodes] of Char = ('S','E','Z','1','2','3','4','5','6','7','8','9','T','X','B','C','F','G','R','W','Y');

type
  TCCDeptInfo = Class
    Details : TCCDeptRec;
  end;

  TVATInfo = class
    rRate : real;
    cCode : string;
    constructor create(Rate : real; Code : string);
  end;

  TEntMessageDlg = procedure(const sMessage : string);

  function CCDeptValid(sCC, sDept : ShortString; cVATCode : char; const iGLCode : integer; const sDataPath : string; iLineNo : integer; entMessageDlg : TEntMessageDlg; bUseSQL : boolean): boolean;
  procedure RunConversion(sCompPath : string);
  procedure FillVATCombo(cmbVATRate : TComboBox);
  procedure SelectVATCode(cmbVATRate : TComboBox; cVATCode : char);
  function GetVATCode(cmbVATRate : TComboBox) : char;
  function ValidVatCode(cVATCode : char) : boolean;
  procedure ConvertDataFile(sCompPath : string);
  function CombinationsAreStored : boolean;
  procedure DeleteAllCombinations;

var
  bSQL : boolean;
  
implementation
uses
  MiscUtil, BTUtil, StrUtil, BTConst, Inifiles, Classes, Dialogs, SysUtils, Forms, Windows;

constructor TVATInfo.Create(Rate : real; Code : string);
begin
  inherited create;
  rRate := Rate;
  cCode := Code;
end;

function CCDeptValid(sCC, sDept : ShortString;
                     cVATCode : char;
                     const iGLCode : integer;
                     const sDataPath : string;
                     iLineNo : integer;
                     entMessageDlg : TEntMessageDlg;
                     bUseSQL : boolean): boolean;
var
//  SQLDataModule : TSQLDataModule;
//  CCIni : TInifile;
  Exclusions, Inclusions : TStringList;
  sCheck : string[9];
//  sByGLString : string[5];
  sMessage, {sGLCode,} sCCDept : string;
  BTRec : TBTRec;
  bByGLCode : boolean;
  iFindGL : integer;

  function CheckExact(Combinations : TStrings) : boolean;
  var
    iCommaPos, iSlashPos, iPos : integer;
  begin{CheckExact}
    Result := FALSE;
    for iPos := 0 to Combinations.Count - 1 do
    begin
//      sCheck := Copy(Combinations[iPos], (Pos('=', Combinations[iPos]) + 1), 255);
      sCheck := Combinations[iPos];

      iCommaPos := Pos(',',sCheck);
      iSlashPos := Pos('/',sCheck);

//      sCheck := Trim(UpperCase(Copy(sCheck,1,iCommaPos - 1))) + ',' + Trim(UpperCase(Copy(sCheck,iCommaPos + 1,255)))
//      + '/' + Copy(sCheck, iSlashPos+1, 1);

      sCheck := UpperCase(Copy(sCheck,1,iCommaPos - 1)) + ',' + Trim(UpperCase(Copy(sCheck,iCommaPos + 1,255)))
      + '/' + Copy(sCheck, iSlashPos+1, 1);

      // Compensate for having a #0 as the VAT Code, for some reason, you get 2 slashes....?
      if Copy(sCheck, length(sCheck)-1, 2) = '//'
      then sCheck := Copy(sCheck, 1, length(sCheck)-1) + #0;

      if sCheck = sCCDept then
      begin
        Result := TRUE;
        exit;
      end;{if}
    end;{for}
  end;{CheckExact}

  function CheckRange(Combinations : TStrings) : boolean;
  var
    iPos : integer;
    sLCC, sLDept : string;
    cLVAT : char;
  begin{CheckRange}
    Result := FALSE;
    for iPos := 0 to Combinations.Count - 1 do
    begin
//      sCheck := Copy(Combinations[iPos], (Pos('=', Combinations[iPos]) + 1), 255);
      sCheck := Combinations[iPos];
{      if ((copy(sCheck,1,3) = CCDEPT_WILDCARD) and (Trim(UpperCase(copy(sCheck,5,3))) = Trim(UpperCase(sDept))))
      or ((copy(sCheck,5,3) = CCDEPT_WILDCARD) and (Trim(UpperCase(copy(sCheck,1,3))) = Trim(UpperCase(sCC))))
      or ((copy(sCheck,5,3) = CCDEPT_WILDCARD) and (copy(sCheck,1,3) = CCDEPT_WILDCARD)) then Result := TRUE;}

      sLCC := UpperCase(copy(sCheck,1,3));
      sLDept := UpperCase(copy(sCheck,5,3));
      cLVAT := UpperCase(copy(sCheck,9,1))[1];
      sCC := UpperCase(sCC);
      sDept := UpperCase(sDept);
      cVATCode := UpperCase(cVATCode)[1];

      if ((sLCC = CCDEPT_WILDCARD) and (sLDept = sDept) and (cLVAT = VAT_WILDCARD))
      or ((sLCC = CCDEPT_WILDCARD) and (sLDept = sDept) and (cLVAT = cVATCode))
      or ((sLCC = sCC) and (sLDept = CCDEPT_WILDCARD) and (cLVAT = VAT_WILDCARD))
      or ((sLCC = sCC) and (sLDept = CCDEPT_WILDCARD) and (cLVAT = cVATCode))
      or ((sLCC = sCC)  and (sLDept = sDept) and (cLVAT = VAT_WILDCARD))
      or ((sLCC = CCDEPT_WILDCARD) and (sLDept = CCDEPT_WILDCARD) and (cLVAT = cVATCode))
      or ((sLCC = CCDEPT_WILDCARD) and (sLDept = CCDEPT_WILDCARD) and (cLVAT = VAT_WILDCARD))
      then begin
        Result := TRUE;
        exit;
      end;{if}
    end;{for}
  end;{CheckRange}

  procedure ReadCombinations(iGL : integer; cType : char; Combinations : TStringList);

    procedure ReadCombinationsSQL;
    begin{ReadCombinationsSQL}
      // add combinations into list
      SQLDataModule.SQLFillSLWithCombinations(cType, iGL, Combinations);
    end;{ReadCombinationsSQL}

    procedure ReadCombinationsPervasive;
    var
      CCDeptRec : TCCDeptRec;
    begin{ReadCombinationsPervasive}
      // add combinations into list
      BTRec.KeyS := cType + BTFullNomKey(iGL);
      BTRec.Status := BTFindRecord(BT_GetGreaterOrEqual, aFileVar[CCDeptF], CCDeptRec
      , aBufferSize[CCDeptF], idxGetCombinations, BTRec.KeyS);

      while (BTRec.Status = 0) and (CCDeptRec.cdType = cType)
      and (CCDeptRec.cdGLCode = iGL) do
      begin
        Combinations.Add(CCDeptRec.cdCostCentre + ',' + CCDeptRec.cdDepartment + '/' + CCDeptRec.cdVATCode);

  // NF: 26/03/2009 - Possible fix for non-padded CC/Depts in Database which are < 3 chars - not used
  //      Combinations.Add(PadString(psRight, CCDeptRec.cdCostCentre, ' ', 3)
  //      + ',' + PadString(psRight, CCDeptRec.cdDepartment, ' ', 3) + '/' + CCDeptRec.cdVATCode);

        // next record
        BTRec.Status := BTFindRecord(BT_GetNext, aFileVar[CCDeptF], CCDeptRec
        , aBufferSize[CCDeptF], idxGetCombinations, BTRec.KeyS);
      end;{while}
    end;{ReadCombinationsPervasive}

  begin{ReadCombinations}
    if bUseSQL then ReadCombinationsSQL
    else ReadCombinationsPervasive;
  end;{ReadCombinations}

  function UsingGLCodes : boolean;
  var
    CCDeptRec : TCCDeptRec;
  begin{UsingGLCodes}
    if bUseSQL then
    begin
      Result := SQLDataModule.SQLUsingGLCodes;
    end
    else
    begin
      BTRec.Status := BTFindRecord(BT_GetFirst, aFileVar[CCDeptF], CCDeptRec
      , aBufferSize[CCDeptF], idxGetCombinations, BTRec.KeyS);
      Result := (BTRec.Status = 0) and (CCDeptRec.cdGLCode <> iNO_GL);
    end;{if}
  end;{UsingGLCodes}

  function UsingVATCodes : boolean;
  var
    CCDeptRec : TCCDeptRec;
  begin{UsingVATCodes}
    if bUseSQL then
    begin
      Result := SQLDataModule.SQLUsingVATCodes;
    end
    else
    begin
      BTRec.Status := BTFindRecord(BT_GetFirst, aFileVar[CCDeptF], CCDeptRec
      , aBufferSize[CCDeptF], idxGetCombinations, BTRec.KeyS);
      Result := (BTRec.Status = 0) and (CCDeptRec.cdVATCode <> #0);
    end;{if}
  end;{UsingVATCodes}

begin
  {initialise variables}

//  CCIni := TInifile.create(IncludeTrailingBackslash(Trim(sDataPath)) + CCDEPTINI);
  Exclusions := TStringList.Create;
  Inclusions := TStringList.Create;

  sCC := PadString(psRight, Trim(UpperCase(sCC)),' ',3);
  sDept := PadString(psRight, Trim(UpperCase(sDept)),' ',3);

//  sCCDept := Trim(UpperCase(sCC)) + ',' + Trim(UpperCase(sDept)) + '/' + cVATCode;
  sCCDept := PadString(psRight, Trim(UpperCase(sCC)),' ',3) + ','
  + PadString(psRight, Trim(UpperCase(sDept)),' ',3) + '/' + cVATCode;


  if bSQL then
  begin
    // v6.30.141 - ABSEXCH-9495
//    SQLDataModule := TSQLDataModule.Create(nil);
//    SQLDataModule.Connect(asCompanyPath);
    if not Assigned(SQLDataModule) then
    begin
      SQLDataModule := TSQLDataModule.Create(nil);
      SQLDataModule.Connect(asCompanyPath);
    end;{if}
  end
  else
  begin
    SQLDataModule := nil;
  end;

  {Read values from ini file}
//  with CCIni do
//  begin
//    UpdateFile;

  // first record
{  BTRec.Status := BTFindRecord(BT_GetFirst, aFileVar[CCDeptF], CCDeptRec
  , aBufferSize[CCDeptF], idxGetCombinations, BTRec.KeyS);

  if (BTRec.Status = 0) and (CCDeptRec.cdGLCode <> iNO_GL) then}
  if UsingGLCodes then
  begin
    bByGLCode := TRUE;
    iFindGL := iGLCode;
  end else
  begin
    bByGLCode := FALSE;
    iFindGL := iNO_GL;
  end;{if}

  if not UsingVATCodes then
  begin
    cVATCode := #0;
    sCCDept := Copy(sCCDept, 1, 8) + #0;
  end;{if}

  {read Exclusions / Inclusions for the GLCode}
  ReadCombinations(iFindGL, CD_INVALID, Exclusions);
  ReadCombinations(iFindGL, CD_VALID, Inclusions);
//  ReadSectionValues(sGLCode + '-Invalid Combinations', Exclusions);
//  ReadSectionValues(sGLCode + '-Valid Combinations', Inclusions);

  {Use the GL Wild-Card if there are no settings for the specific GL Code}
  if (Exclusions.Count = 0) and (Inclusions.Count = 0) and (bByGLCode) then
  begin
    ReadCombinations(iGL_WILDCARD, CD_INVALID, Exclusions);
    ReadCombinations(iGL_WILDCARD, CD_VALID, Inclusions);
//    ReadSectionValues(sGL_WILDCARD + '-Invalid Combinations', Exclusions);
//    ReadSectionValues(sGL_WILDCARD + '-Valid Combinations', Inclusions);
  end;{if}

  {Check Validity}
  if (Exclusions.Count = 0) and (Inclusions.Count = 0) then
    Result := FALSE
  else
  begin
    if CheckExact(Exclusions) then
      Result := FALSE
    else
    begin
      if CheckRange(Exclusions) then
      begin
        if CheckExact(Inclusions) then
          Result := TRUE
        else
          Result := FALSE;
      end
      else
      begin
        if CheckExact(Inclusions) then
          Result := TRUE
        else
        begin
          if CheckRange(Inclusions) then
            Result := TRUE
          else
            Result := FALSE;
        end; // if CheckExact(Inclusions) then...
      end; // if CheckRange(Exclusions) then...
    end; // if CheckExact(Exclusions) then...
  end; // if (Exclusions.Count = 0) and (Inclusions.Count = 0) then...

  {Show Error Message}
  if not Result then
  begin
    if cVATCode = #0 then sCCDept := RemoveAllChars(sCCDept, '/');
    if bByGLCode = TRUE then sCCDept := sCCDept + ',' + IntToStr(iGLCode);
    sCCDept := RemoveAllChars(sCCDept, #0);

    sMessage := 'The Cost Centre and Department combination (' + sCCDept
    + ') that you have entered on line ' + IntToStr(iLineNo) + ' is invalid.'
    + CHR(13) + CHR(13) + 'Please enter a valid combination';

    entMessageDlg(sMessage);
  end;{if}

  {Tidy Up}
  Inclusions.Free;
  Exclusions.Free;

  // v6.30.141 - ABSEXCH-9495
{  if bSQL then
  begin
    SQLDataModule.Disconnect;
    SQLDataModule.Free;
  end;{if}

end;

procedure RunConversion(sCompPath : string);
var
  CCNewIni, CCIni : TInifile;
  slSections, slCombinations : TStringList;
  iNextGLID, iPos : integer;
  iDashPos, iCommaPos : byte;
  sGLCode : string;

  procedure AddRecords(cType : char; sGLCode : string; slCombinations : TStringList);
  var
    CCDeptRec : TCCDeptRec;
    iStatus, iPos : integer;
  begin{AddRecords}
    {fill Valid list from string list}
    For iPos := 0 to slCombinations.Count - 1 do begin
      iCommaPos := Pos(',',slCombinations[iPos]);

      FillChar(CCDeptRec, SizeOf(TCCDeptRec), #0);
      with CCDeptRec do
      begin
        cdType := cType;

        if sGLCode = sGL_WILDCARD then cdGLCode := iGL_WILDCARD
        else cdGLCode := StrToIntDef(sGLCode, iNO_GL);

        cdCostCentre := Copy(slCombinations[iPos], iCommaPos - 3,3);

        // v6.30.143 - ABSEXCH-9637 - Should fix conversopnm problems from .ini to .dat, when you have <3 char departments
//        cdDepartment := Copy(slCombinations[iPos], iCommaPos + 1,3);
        cdDepartment := PadString(psRight, Copy(slCombinations[iPos], iCommaPos + 1,3), ' ', 3);

        cdDummyChar := IDX_DUMMY_CHAR;
        iStatus := BTAddRecord(aFileVar[CCDeptF], CCDeptRec, aBufferSize[CCDeptF], idxGetCombinations);
        if iStatus = 0 then
        begin
          // added OK
        end else
        begin
          if iStatus = 5 then  // ignore duplicates
          else BTShowError(iStatus, 'BTAddRecord', aFileName[CCDeptF]);
        end;
      end;{with}
    end;{for}

  end;{AddRecords}

begin
  {initialise variables}
  CCIni := TInifile.create(sCompPath + CCDEPTINI);
  CCNewIni := TInifile.create(sCompPath + INI_FILENAME);
  slCombinations := TStringList.Create;


  {Read values from ini file}
  with CCIni do
  begin
    UpdateFile;

    if (UpperCase(ReadString('Options', 'ByGLCode', 'FALSE')) = 'TRUE') then
    begin

      //Update New IniFile
      CCNewIni.WriteString('Settings', 'UseGLs', '1');
      CCNewIni.WriteString('Settings', 'UseVAT', '0');

      slSections := TStringList.Create;
      ReadSections(slSections);

      iNextGLID := 0;
      For iPos := 0 to slSections.Count - 1 do begin
        iDashPos := Pos('-',slSections[iPos]);
        if (iDashPos > 1) then begin

          ReadSectionValues(slSections[iPos], slCombinations);

          sGLCode := copy(slSections[iPos], 1, iDashPos-1);

          if copy(slSections[iPos], iDashPos, 255) = '-Valid Combinations'
          then AddRecords(CD_VALID, sGLCode, slCombinations);

          if copy(slSections[iPos], iDashPos, 255) = '-Invalid Combinations'
          then AddRecords(CD_INVALID, sGLCode, slCombinations);

          //Update New IniFile
          CCNewIni.WriteString('GLCodes', IntToStr(iNextGLID), sGLCode);
          Inc(iNextGLID);

        end;{if}
      end;{for}
      slSections.Free;
    end else
    begin
      //Update New IniFile
      CCNewIni.WriteString('Settings', 'UseGLs', '0');
      CCNewIni.WriteString('Settings', 'UseVAT', '0');

      sGLCode := '**NOCODE**';
      ReadSectionValues(sGLCode + '-Valid Combinations', slCombinations);
      AddRecords(CD_VALID, IntToStr(iNO_GL), slCombinations);
      slCombinations.Clear;
      ReadSectionValues(sGLCode + '-Invalid Combinations', slCombinations);
      AddRecords(CD_INVALID, IntToStr(iNO_GL), slCombinations);
    end;{if}

    Free;
  end;{with}

  slCombinations.Free;
  CCNewIni.Free;

  RenameFile(sCompPath + CCDEPTINI, sCompPath + 'CCDept.ono');
end;

procedure FillVATCombo(cmbVATRate : TComboBox);
var
  iPos : smallint;
  sPos : string;
//  TKVATRec : TBatchVATRec;
begin
  cmbVATRate.Items.AddObject('* - Wildcard',TVATInfo.Create(0, '*'));

  For iPos := Low(VATCodeList) To High(VATCodeList) Do begin
    sPos := VATCodeList[iPos];
    cmbVATRate.Items.AddObject(oToolkit.SystemSetup.ssVATRates[sPos].svDesc + ' ('
    + oToolkit.SystemSetup.ssVATRates[sPos].svCode + ')'
    ,TVATInfo.Create(oToolkit.SystemSetup.ssVATRates[sPos].svRate
    , oToolkit.SystemSetup.ssVATRates[sPos].svCode));
  end;{for}

  cmbVATRate.Items.AddObject('Dispatches (D)'
  ,TVATInfo.Create(oToolkit.SystemSetup.ssVATRates['D'].svRate, 'D'));

//  if cmbVATRate.Items.Count > 0 then cmbVATRate.ItemIndex := 0;
end;

procedure SelectVATCode(cmbVATRate : TComboBox; cVATCode : char);
var
  iPos : integer;
begin{SelectVATCode}
  if cVATCode = '*' then
  begin
    cmbVATRate.ItemIndex := 0;
  end else
  begin
    For iPos := 0 to cmbVATRate.Items.Count -1 do
    begin
      if TVATInfo(cmbVATRate.Items.Objects[iPos]).cCode = cVATCode
      then cmbVATRate.ItemIndex := iPos;
    end;{for}
  end;{if}
end;{SelectVATCode}

function GetVATCode(cmbVATRate : TComboBox) : char;
begin{SelectVATCode}
  if (cmbVATRate.ItemIndex = 0) and (cmbVATRate.Items[0][1] = '*') then
  begin
    Result := '*'
  end else
  begin
    Result := #0;
    if cmbVATRate.ItemIndex >= 0 then
    begin
      Result := TVATInfo(cmbVATRate.Items.Objects[cmbVATRate.ItemIndex]).cCode[1];
    end;{if}
  end;{if}
end;{SelectVATCode}

function ValidVatCode(cVATCode : char) : boolean;
var
  iPos : integer;
begin
  Result := FALSE;
  For iPos := 1 to NoOfVATCodes do
  begin
    if cVATCode = VATCodeList[iPos] then
    begin
      Result := TRUE;
      exit;
    end;{if}
  end;{for}
end;

procedure ConvertDataFile(sCompPath : string);
var
  CCDeptInfo : TCCDeptInfo;
  CCDeptRec : TCCDeptRec;
  BTRec : TBTRec;
  lRecords : TList;
  iPos : integer;
begin
  if FileExists(sCompPath + CCDEPT_DAT) then
  begin
    // Read Records from Old file
    InitialiseArrays(TRUE);
    if not OpenFiles(sCompPath, TRUE, FALSE) then
    begin
      MsgBox('The call to OpenFiles(' + sCompPath + ') in CCCustom.Dll Failed.'
      , mtError, [mbOK], mbOK, 'CCCustom.Dll error');
    end else
    begin
      lRecords := TList.Create;

      // add valid combinations into list
      FillChar(BTRec.KeyS, SizeOf(BTRec.KeyS), #0);
      BTRec.Status := BTFindRecord(BT_GetFirst, aFileVar[CCDeptF], CCDeptRec
      , aBufferSize[CCDeptF], idxGetCombinations, BTRec.KeyS);

      while BTRec.status = 0 do
      begin
        // Add to list
        CCDeptInfo := TCCDeptInfo.Create;
        CCDeptInfo.Details := CCDeptRec;
        lRecords.Add(CCDeptInfo);

        // Get Next
        BTRec.Status := BTFindRecord(BT_GetNext, aFileVar[CCDeptF], CCDeptRec
        , aBufferSize[CCDeptF], idxGetCombinations, BTRec.KeyS);
      end;

      CloseFiles;

      // rename old file
      RenameFile(sCompPath + CCDEPT_DAT, sCompPath + CCDEPT_DAT + '.old');


      // Write records to new file.
      InitialiseArrays(FALSE);
      if not OpenFiles(sCompPath, FALSE, FALSE) then
      begin
        MsgBox('The call to OpenFiles(' + sCompPath + ') in CCCustom.Dll Failed.'
        , mtError, [mbOK], mbOK, 'CCCustom.Dll error');
      end else
      begin
        For iPos := 0 to lRecords.Count-1 do
        begin
          CCDeptRec := TCCDeptInfo(lRecords[iPos]).Details;
          BTRec.Status := BTAddRecord(aFileVar[CCDeptF], CCDeptRec
          , aBufferSize[CCDeptF], idxGetCombinations);
          BTShowError(BTRec.Status, 'BTAddRecord', aFileName[CCDeptF]);
        end;{if}
//        CloseFiles;  shouldn't we close the files ?
      end;{if}

      ClearList(lRecords);
    end;{if}
  end;{if}
end;

function CombinationsAreStored : boolean;
var
  LCCDeptRec : TCCDeptRec;
  BTRec : TBTRec;
begin
  BTRec.Status := BTFindRecord(BT_GetFirst, aFileVar[CCDeptF], LCCDeptRec
  , aBufferSize[CCDeptF], idxGetCombinations, BTRec.KeyS);
  Result := BTRec.Status = 0;
end;

procedure DeleteAllCombinations;
var
  CCDeptRec : TCCDeptRec;
  BTRec :TBTRec;
begin{DeleteAllCombinations}

  Repeat
    BTRec.Status := BTFindRecord(BT_GetFirst, aFileVar[CCDeptF], CCDeptRec
    , aBufferSize[CCDeptF], idxGetCombinations, BTRec.KeyS);

    if BTRec.Status = 0 then
    begin
      BTRec.Status := BTDeleteRecord(aFileVar[CCDeptF], CCDeptRec, aBufferSize[CCDeptF], idxGetCombinations);
      if BTRec.Status = 0 then
      begin
        // deleted OK
      end else
      begin
        BTShowError(BTRec.Status, 'BTDeleteRecord', aFileName[CCDeptF]);
      end;{if}
    end;{if}
  Until BTRec.Status <> 0;

end;{DeleteAllCombinations}

end.

