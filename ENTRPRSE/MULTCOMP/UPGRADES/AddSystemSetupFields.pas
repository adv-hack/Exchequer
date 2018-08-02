Unit AddSystemSetupFields;

Interface

const
  //PR: 09/06/2015 Constants for data version no
  // MH 16/09/2015 2015-R1 ABSEXCH-16862: Corrected version number after v7.0.14 was cancelled
  V_2015R1 = 1;

  // MH 14/10/2015 2016-R1: Updated for 2016-R1
  V_2016R1 = 2;

  // MH 03/03/2016 2016-R2: Updated for 2016-R2
  V_2016R2 = 3;

  // MH 10/06/2016 2016-R3: Updated for 2016-R3
  V_2016R3 = 4;

  // MH 16/01/2017 2017-R1 ABSEXCH-18133: Updated for 2017 R1
  V_2017R1 = 5;

  // MH 28/04/2017 2017-R2: Updated for 2017-R2
  V_2017R2 = 6;

  //RB 25/10/2017 2018-R1 ABSEXCH-19335: GEUpgrade changes for User Profile PII Fields
  V_2018R1 = 7;

  // MH 02/03/2018 2018-R2: Updating version numbers for 2018-R1.1
  V_2018R11 = 8;

  // MH 14/10/2015 2016-R1: Added V_CURRENTVERSION so we don't need to keep changing HandlerU so much
  V_CURRENTVERSION = V_2018R11;


Function CheckSystemSetup (Const CompanyDir : ShortString) : Integer;

//PR: 09/06/2014 v7.0.14 functions for reading and writing data version no
function GetDataVersion(Const CompanyDir : ShortString) : Integer;
function SetDataVersion(Const CompanyDir : ShortString; Value : Integer) : integer;

Implementation

Uses oSystemSetup, oSystemSetupBtrieveFile, oBtrieveFile, SysUtils;

Type
  DefaultSystemSetupFieldRecType = Record
    Name : ShortString;
    Descr : ShortString;
    DefaultValue : ShortString;
    DataType : ShortString;
  End; // DefaultSystemSetupFieldRecType

Const
  // CJS 2015-12-17 - ABSEXCH-17082 - Intrastat - Add new System Setup entries
  //SS:12/05/2017 2017-R2:ABSEXCH-18573:Add Currency Tolerance Editable field under system set-up.
  //TG 28-06-2017 2017 R2: ABSEXCH- 18840 User Authentication Configuration - Database Changes (2.5)
  //HV 14-11-2017 2018 R1, ABSEXCH-19344: GDPR - New SystemSetup Rows Database Changes from 34 to 54
  DefaultSystemSetupFields : Array[TSystemSetupFieldIds] Of DefaultSystemSetupFieldRecType =
    (
      ( {Id: siDataVersionNo}
         Name: 'DataVersionNo';
         Descr: 'Data Version Number';
         DefaultValue: '0';
         DataType: 'varchar(20)'
      ),
      ( {Id: siSettlementWriteOffCtrlGL}
         Name: 'ssSettlementWriteOffCtrlGL';
         Descr: 'Settlement Write-Off GL Control Code';
         DefaultValue: '0';
         DataType: 'int'
      ),
      ( {Id: siPPDRedDays}
         Name: 'PPDRedDays';
         Descr: 'PPD Expiry - Upper Limit of days for ''Red'' category';
         DefaultValue: '5';
         DataType: 'int'
      ),
      ( {Id: siPPDAmberDays}
         Name: 'PPDAmberDays';
         Descr: 'PPD Expiry - Upper Limit of days for ''Amber'' category';
         DefaultValue: '15';
         DataType: 'int'
      ),
      ( {Id: siPPDExpiredBackgroundColour}
         Name: 'PPDExpiredBackgroundColour';
         Descr: 'PPD Expiry - Expired Background Colour';
         DefaultValue: '12632256';
         DataType: 'int'
      ),
      ( {Id: siPPDExpiredFontColour}
         Name: 'PPDExpiredFontColour';
         Descr: 'PPD Expiry - Expired Font Colour';
         DefaultValue: '0';
         DataType: 'int'
      ),
      ( {Id: siPPDExpiredFontStyle}
         Name: 'PPDExpiredFontStyle';
         Descr: 'PPD Expiry - Expired Font Style (1=Bold / 2=Underline / 4=Italic / 8=Strikeout)';
         DefaultValue: '4';
         DataType: 'int'
      ),
      ( {Id: siPPDRedBackgroundColour}
         Name: 'PPDRedBackgroundColour';
         Descr: 'PPD Expiry - ''Red'' Background Colour';
         DefaultValue: '255';
         DataType: 'int'
      ),
      ( {Id: siPPDRedFontColour}
         Name: 'PPDRedFontColour';
         Descr: 'PPD Expiry - ''Red'' Font Colour';
         DefaultValue: '16777215';
         DataType: 'int'
      ),
      ( {Id: siPPDRedFontStyle}
         Name: 'PPDRedFontStyle';
         Descr: 'PPD Expiry - ''Red'' Font Style (1=Bold / 2=Underline / 4=Italic / 8=Strikeout)';
         DefaultValue: '1';
         DataType: 'int'
      ),
      ( {Id: siPPDAmberBackgroundColour =}
         Name: 'PPDAmberBackgroundColour';
         Descr: 'PPD Expiry - ''Amber'' Background Colour';
         DefaultValue: '8454143';
         DataType: 'int'
      ),
      ( {Id: siPPDAmberFontColour =}
         Name: 'PPDAmberFontColour';
         Descr: 'PPD Expiry - ''Amber'' Font Colour';
         DefaultValue: '0';
         DataType: 'int'
      ),
      ( {Id: siPPDAmberFontStyle =}
         Name: 'PPDAmberFontStyle';
         Descr: 'PPD Expiry - ''Amber'' Font Style (1=Bold / 2=Underline / 4=Italic / 8=Strikeout)';
         DefaultValue: '0';
         DataType: 'int'
      ),
      ( {Id: siPPDGreenBackgroundColour =}
         Name: 'PPDGreenBackgroundColour';
         Descr: 'PPD Expiry - ''Green'' Background Colour';
         DefaultValue: '8454016';
         DataType: 'int'
      ),
      ( {Id: siPPDGreenFontColour =}
         Name: 'PPDGreenFontColour';
         Descr: 'PPD Expiry - ''Green'' Font Colour';
         DefaultValue: '0';
         DataType: 'int'
      ),
      ( {Id: siPPDGreenFontStyle}
         Name: 'PPDGreenFontStyle';
         Descr: 'PPD Expiry - ''Green'' Font Style (1=Bold / 2=Underline / 4=Italic / 8=Strikeout)';
         DefaultValue: '0';
         DataType: 'int'
      ),
      ( {Id: siShowDeliveryTerms}
         Name: 'isShowDeliveryTerms';
         Descr: 'Show Delivery Terms';
         DefaultValue: '1';
         DataType: 'int'
      ),
      ( {Id: siShowModeOfTransport}
         Name: 'isShowModeOfTransport';
         Descr: 'Show Mode of Transport';
         DefaultValue: '1';
         DataType: 'int'
      ),
      ( {Id: siLastClosedIntrastatArrivalsDate}
         Name: 'isLastClosedArrivalsDate';
         Descr: 'Last Closed Intrastat Arrivals Date';
         DefaultValue: '';
         DataType: 'varchar(8)'
      ),
      ( {Id: siLastClosedIntrastatDispatchesDate}
         Name: 'isLastClosedDispatchesDate';
         Descr: 'Last Closed Intrastat Dispatches Date';
         DefaultValue: '';
         DataType: 'varchar(8)'
      ),
      ( {Id: siLastIntrastatReportPeriodYear}
         Name: 'isLastReportPeriodYear';
         Descr: 'Last Intrastat Report Period Year';
         DefaultValue: '';
         DataType: 'varchar(4)'
      ),
      ( {Id: siLastIntrastatReportFromDate}
         Name: 'isLastReportFromDate';
         Descr: 'Last Intrastat Report From Date';
         DefaultValue: '';
         DataType: 'varchar(8)'
      ),
      ( {Id: siLastIntrastatReportToDate}
         Name: 'isLastReportToDate';
         Descr: 'Last Intrastat Report To Date';
         DefaultValue: '';
         DataType: 'varchar(8)'
      ),
      ( {Id: siLastIntrastatReportMode}
         Name: 'isLastReportMode';
         Descr: 'Last Intrastat Report Mode';
         DefaultValue: '0';
         DataType: 'int'
      ),
      ( {Id: siTaxHomeRegion}
         Name: 'isTaxHomeRegion';
         Descr: 'Tax - Home Region ID';
         DefaultValue: '0';
         DataType: 'int'
      ),
      ( {Id: siCurrImportTol}
         Name: 'ssCurrImportTol';
         Descr: 'Currency Import Tolerance';
         DefaultValue: '0';
         DataType: 'float'
      ),
      (  {Id: siAuthenticationMode}
         Name: 'AuthenticationMode';
         Descr: 'AuthenticationMode';
         DefaultValue: 'Exchequer';
         DataType: 'Varchar(20)'
      ),
      (  {Id: siMinimumPasswordLength }
         Name: 'MinimumPasswordLength';
         Descr: 'Minimum Password Length';
         DefaultValue: '0';
         DataType: 'Int'
      ),
      (  {Id: siRequireUppercase }
         Name: 'RequireUppercase';
         Descr: 'Require Uppercase';
         DefaultValue: '0';
         DataType: 'Bit'
      ),
       (  {Id: siRequireLowercase }
         Name: 'RequireLowercase';
         Descr: 'Require Lowercase';
         DefaultValue: '0';
         DataType: 'Bit'
      ),
       (  {Id: siRequireNumeric }
         Name: 'RequireNumeric';
         Descr: 'Require Numeric';
         DefaultValue: '0';
         DataType: 'Bit'
      ),
       (  {Id: siRequireSymbol }
         Name: 'RequireSymbol';
         Descr: 'Require Symbol';
         DefaultValue: '0';
         DataType: 'Bit'
      ),
       (  {Id: siSuspendUsersAfterLoginFailures }
         Name: 'SuspendUsersAfterLoginFailures';
         Descr: 'Suspend Users After Login Failures';
         DefaultValue: '0';
         DataType: 'Bit'
      ),
        (  {Id: siSuspendUsersLoginFailureCount }
         Name: 'SuspendUsersLoginFailureCount';
         Descr: 'Suspend Users Login Failure Count';
         DefaultValue: '3';
         DataType: 'Int'
      ),
      (  {Id: siAnonymised -34}
         Name: 'Anonymised';
         Descr: 'Data has been Anonymised';
         DefaultValue: '0';
         DataType: 'Bit'
      ),
      (  {Id: siAnonymisedDate -35}
         Name: 'AnonymisedDate';
         Descr: 'Anonymisation Date (YYYYMMDD)';
         DefaultValue: '';
         DataType: 'Varchar(8)'
      ),
      (  {Id: siAnonymisedTime -36}
         Name: 'AnonymisedTime';
         Descr: 'Anonymisation Time (HHMMSS)';
         DefaultValue: '';
         DataType: 'Varchar(6)'
      ),
      (  {Id: siGDPRTraderRetentionPeriod -37}
         Name: 'GDPRTraderRetentionPeriod';
         Descr: 'GDPR - Trader - Retention Period (Years)';
         DefaultValue: '6';
         DataType: 'Int'
      ),
      (  {Id: siGDPRTraderDisplayPIITree -38}
         Name: 'GDPRTraderDisplayPIITree';
         Descr: 'GDPR - Trader - Display PII Tree on Close';
         DefaultValue: '0';
         DataType: 'Bit'
      ),
      (  {Id: siGDPRTraderAnonNotesOption -39}
         Name: 'GDPRTraderAnonNotesOption';
         Descr: 'GDPR - Trader - Anonymisation - Notes Option';
         DefaultValue: '2';
         DataType: 'Int'
      ),
      (  {Id: siGDPRTraderAnonLettersOption -40}
         Name: 'GDPRTraderAnonLettersOption';
         Descr: 'GDPR - Trader - Anonymisation - Letters Option';
         DefaultValue: '3';
         DataType: 'Int'
      ),
      (  {Id: siGDPRTraderAnonLinksOption -41}
         Name: 'GDPRTraderAnonLinksOption';
         Descr: 'GDPR - Trader - Anonymisation - Links Option';
         DefaultValue: '2';
         DataType: 'Int'
      ),
      (  {Id: siGDPREmployeeRetentionPeriod -42}
         Name: 'GDPREmployeeRetentionPeriod';
         Descr: 'GDPR - Employee - Retention Period (Years)';
         DefaultValue: '6';
         DataType: 'Int'
      ),
      (  {Id: siGDPREmployeeDisplayPIITree -43}
         Name: 'GDPREmployeeDisplayPIITree';
         Descr: 'GDPR - Employee - Display PII Tree on Close';
         DefaultValue: '0';
         DataType: 'Bit'
      ),
      (  {Id: siGDPREmployeeAnonNotesOption -44}
         Name: 'GDPREmployeeAnonNotesOption';
         Descr: 'GDPR - Employee - Anonymisation - Notes Option';
         DefaultValue: '2';
         DataType: 'Int'
      ),
      (  {Id: siGDPREmployeeAnonLettersOption -45}
         Name: 'GDPREmployeeAnonLettersOption';
         Descr: 'GDPR - Employee - Anonymisation - Letters Option';
         DefaultValue: '3';
         DataType: 'Int'
      ),
      (  {Id: siGDPREmployeeAnonLinksOption -46}
         Name: 'GDPREmployeeAnonLinksOption';
         Descr: 'GDPR - Employee - Anonymisation - Links Option';
         DefaultValue: '2';
         DataType: 'Int'
      ),
      (  {Id: siNotificationWarningColour -47}
         Name: 'NotificationWarningColour';
         Descr: 'Warning Notification Colour';
         DefaultValue: '43506';
         DataType: 'Int'
      ),
      (  {Id: siNotificationWarningFontColour -48}
         Name: 'NotificationWarningFontColour';
         Descr: 'Warning Notification Font Colour';
         DefaultValue: '16777215';
         DataType: 'Int'
      ),
      (  {Id: siGDPRCompanyAnonLocations -49}
         Name: 'GDPRCompanyAnonLocations';
         Descr: 'GDPR - Company - Locations contain PII Data';
         DefaultValue: '0';
         DataType: 'Bit'
      ),
      (  {Id: siGDPRCompanyAnonCostCentres -50}
         Name: 'GDPRCompanyAnonCostCentres';
         Descr: 'GDPR - Company - Cost Centres contain PII Data';
         DefaultValue: '0';
         DataType: 'Bit'
      ),
      (  {Id: siGDPRCompanyAnonDepartment -51}
         Name: 'GDPRCompanyAnonDepartment';
         Descr: 'GDPR - Company - Departments contain PII Data';
         DefaultValue: '0';
         DataType: 'Bit'
      ),
      (  {Id: siGDPRCompanyNotesOption -52}
         Name: 'GDPRCompanyNotesOption';
         Descr: 'GDPR - Company - Anonymisation - Notes Option';
         DefaultValue: '2';
         DataType: 'Int'
      ),
      (  {Id: siGDPRCompanyLettersOption -53}
         Name: 'GDPRCompanyLettersOption';
         Descr: 'GDPR - Company - Anonymisation - Letters Option';
         DefaultValue: '3';
         DataType: 'Int'
      ),
      (  {Id: siGDPRCompanyLinksOption -54}
         Name: 'GDPRCompanyLinksOption';
         Descr: 'GDPR - Company - Anonymisation - Links Option';
         DefaultValue: '2';
         DataType: 'Int'
      )
    );

type
  // MH 16/09/2015 2015-R1 ABSEXCH-16862: Added 2015-R1 after v7.0.14 was cancelled - v7.0.14 needs
  //                                      to stay as Chamberlain Music are already running a Beta live
  //                                      and may incorrectly have a version of 'v7014'
  TDataVersionNoType = (dv2015R1, dv7014, dv2016R1, dv2016R2, dv2016R3, dv2017R1, dv2017R2, dv2018R1, dv2018R2);

  TVersionNoRecord = Record
    VersionNumber : Integer;
    VersionString : String;
  end;

const
  VersionNos : Array[TDataVersionNoType] of
                  TVersionNoRecord = (
                                       // MH 16/09/2015 2015-R1 ABSEXCH-16862: Corrected version number after v7.0.14 was cancelled and duplicated
                                       //                                      the obsolete v7014 as Chamberlain are already running a beta live
                                       (VersionNumber : V_2015R1; VersionString : '2015R1'),
                                       // MH 16/09/2015 2015-R1 ABSEXCH-16862: Duplicated the obsolete v7014 as Chamberlain are already running a
                                       //                                      beta version live and may incorrectly have a version of 'v7014'.
                                       //                                      v7014 needs to be second so that VersionNumberToString returns '2015R1'.
                                       (VersionNumber : V_2015R1; VersionString : 'v7014'),
                                       // MH 14/10/2015 2016-R1: Updated for 2016-R1
                                       (VersionNumber : V_2016R1; VersionString : '2016R1'),
                                       // MH 03/03/2016 2016-R2: Updated for 2016-R2
                                       (VersionNumber : V_2016R2; VersionString : '2016R2'),
                                       // MH 10/06/2016 2016-R3: Updated for 2016-R3
                                       (VersionNumber : V_2016R3; VersionString : '2016R3'),
                                       // MH 16/01/2017 2017-R1 ABSEXCH-18133: Updated for 2017 R1
                                       (VersionNumber : V_2017R1; VersionString : '2017R1'),
                                       // MH 28/04/2017 2017-R2: Updated for 2017 R2
                                       (VersionNumber : V_2017R2; VersionString : '2017R2'),
                                       //RB 25/10/2017 2018-R1 ABSEXCH-19335: GEUpgrade changes for User Profile PII Fields
                                       (VersionNumber : V_2018R1; VersionString : '2018R1'),
                                       // MH 02/03/2018 2018-R2: Updating version numbers for 2018-R2
                                       (VersionNumber : V_2018R11; VersionString : '2018R1.1')
                                     );

function VersionNumberToString(Value : Integer) : string;
var
  vn : TDataVersionNoType;
begin
  Result := '';
  for vn := Low(TDataVersionNoType) to High(TDataVersionNoType) do
    if VersionNos[vn].VersionNumber = Value then
    begin
      Result := VersionNos[vn].VersionString;
      Break;
    end;
end;

function VersionStringToNumber(const Value : string) : Integer;
var
  vn : TDataVersionNoType;
begin
  Result := -1;
  for vn := Low(TDataVersionNoType) to High(TDataVersionNoType) do
    if VersionNos[vn].VersionString = Value then
    begin
      Result := VersionNos[vn].VersionNumber;
      Break;
    end;
end;

//=========================================================================

Function CheckSystemSetup (Const CompanyDir : ShortString) : Integer;
Var
  oSystemSetupBtrFile : TSystemSetupBtrieveFile;

  //------------------------------

  Function CheckForSetting (Const FieldID : TSystemSetupFieldIds) : Integer;
  Begin // CheckForSetting
    // Check to see if the row for FieldId already exists
    Result := oSystemSetupBtrFile.GetEqual(oSystemSetupBtrFile.BuildIDKey(Ord(FieldID)));
    If (Result <> 0) Then
    Begin
      oSystemSetupBtrFile.InitialiseRecord;

      // Note: Have to use With construct as the Get/Set methods are on the record not the
      // individual properties
      With oSystemSetupBtrFile.SystemSetup Do
      Begin
        sysId          := Ord(FieldId);
        sysName        := DefaultSystemSetupFields[FieldId].Name;
        sysDescription := DefaultSystemSetupFields[FieldId].Descr;
        sysValue       := DefaultSystemSetupFields[FieldId].DefaultValue;
        sysType        := DefaultSystemSetupFields[FieldId].DataType;
      End; // With oSystemSetupBtrFile.SystemSetup

      Result := oSystemSetupBtrFile.Insert;
    End; // If (Result <> 0)
  End; // CheckForSetting

  //------------------------------

Var
  I : TSystemSetupFieldIds;
  Res : Integer;

Begin // CheckSystemSetup
  oSystemSetupBtrFile := TSystemSetupBtrieveFile.Create;
  Try
    Res := oSystemSetupBtrFile.OpenFile(CompanyDir + SystemSetupFileName);
    If (Res = 0) Then
    Begin
      oSystemSetupBtrFile.Index := ssIdxId;

      For I := Low(TSystemSetupFieldIds) To High(TSystemSetupFieldIds) Do
      Begin
        Res := CheckForSetting (I);
        If (Res <> 0) Then
          Break;
      End; // For I

      oSystemSetupBtrFile.CloseFile;
    End; // If (Res = 0)

    Result := Res;
  Finally
    oSystemSetupBtrFile.Free;
  End; // Try..Finally
End; // CheckSystemSetup

//=========================================================================

//PR: 09/06/2014 v7.0.14 function for reading data version no
function GetDataVersion(Const CompanyDir : ShortString) : Integer;
Var
  oSystemSetupBtrFile : TSystemSetupBtrieveFile;
  Res : Integer;
begin
  Result := -1;
  oSystemSetupBtrFile := TSystemSetupBtrieveFile.Create;
  Try
    Res := oSystemSetupBtrFile.OpenFile(CompanyDir + SystemSetupFileName);
    if (Res = 0) Then
    begin
      oSystemSetupBtrFile.Index := ssIdxId;
      Res := oSystemSetupBtrFile.GetEqual(oSystemSetupBtrFile.BuildIDKey(Ord(siDataVersionNo)));

      with oSystemSetupBtrFile.SystemSetup do
      begin
        if Res = 0 then
          Result := VersionStringToNumber(sysValue)
        else
          Result := -1;
      end;

    end;
  Finally
    oSystemSetupBtrFile.Free;
  End;
end;

//=========================================================================

//PR: 09/06/2014 v7.0.14 function for writing data version no
function SetDataVersion(Const CompanyDir : ShortString; Value : Integer) : integer;
Var
  oSystemSetupBtrFile : TSystemSetupBtrieveFile;
  sValue : string;
begin
  oSystemSetupBtrFile := TSystemSetupBtrieveFile.Create;
  Try
    Result := oSystemSetupBtrFile.OpenFile(CompanyDir + SystemSetupFileName);
    if (Result = 0) Then
    begin
      oSystemSetupBtrFile.Index := ssIdxId;
      Result := oSystemSetupBtrFile.GetEqual(oSystemSetupBtrFile.BuildIDKey(Ord(siDataVersionNo)));

      if Result = 0 then
      begin
        with oSystemSetupBtrFile.SystemSetup do
          sysValue := VersionNumberToString(Value);

        Result := oSystemSetupBtrFile.Update;
      end;
    end;
  Finally
    oSystemSetupBtrFile.Free;
  End;
end;


End.
