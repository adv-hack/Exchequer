unit TkToSQLFields;
 
interface
 
type
 
  TFieldName = Record
    SQLName : string[30];
    TKName  : string[35];
  end;
 
function TranslateCcdeptvField(const Value : string) : string;
function TranslateCommssnField(const Value : string) : string;
function TranslateCompanyDetRecField(const Value : string) : string;
function TranslateCompanyOptionsField(const Value : string) : string;
function TranslateUserCountXRefTypeUField(const Value : string) : string;
function TranslateUserCountXRefTypeTField(const Value : string) : string;
function TranslateUserCountXRefTypeRField(const Value : string) : string;
function TranslateHookSecurityRecTypeField(const Value : string) : string;
function TranslateAccessControlTypeField(const Value : string) : string;
function TranslateContactField(const Value : string) : string;
function TranslateCustsuppField(const Value : string) : string;
function TranslateDetailsField(const Value : string) : string;
function TranslateDataVarTypeField(const Value : string) : string;
function TranslateDataXRefTypeField(const Value : string) : string;
function TranslateDocumentField(const Value : string) : string;
function TranslateTebusParamsField(const Value : string) : string;
function TranslateTebusDragNetField(const Value : string) : string;
function TranslateTebusCompanyField(const Value : string) : string;
function TranslateTebusFileCountersField(const Value : string) : string;
function TranslateTebusImportField(const Value : string) : string;
function TranslateTebusExportField(const Value : string) : string;
function TranslateTebusCatalogueField(const Value : string) : string;
function TranslateTebusFTPField(const Value : string) : string;
function TranslateTebusEmailField(const Value : string) : string;
function TranslateTebusFileField(const Value : string) : string;
function TranslateTebusDragNetCompanyField(const Value : string) : string;
function TranslateTebusDragNetCountryField(const Value : string) : string;
function TranslateTPreserveDocFieldsField(const Value : string) : string;
function TranslateTPreserveLineFieldsField(const Value : string) : string;
function TranslateTLookupGenericCField(const Value : string) : string;
function TranslateTLookupGenericVField(const Value : string) : string;
function TranslateTField(const Value : string) : string;
function TranslateNotesTypeNDField(const Value : string) : string;
function TranslateEmppayField(const Value : string) : string;
function TranslatePassEntryTypeField(const Value : string) : string;
function TranslatePassListTypeField(const Value : string) : string;
function TranslateNotesTypeNAField(const Value : string) : string;
//PR: 22/02/2010 Added new function for redirected notes fields
function TranslateNotesTypeNAFieldEx(const Value : string) : string;
function TranslateMatchPayTypeTPField(const Value : string) : string;
function TranslateBillMatTypeField(const Value : string) : string;
function TranslateBacsCtypeField(const Value : string) : string;
function TranslateBankCtypeField(const Value : string) : string;
function TranslateAllocFileTypeField(const Value : string) : string;
function TranslateCostCtrTypeField(const Value : string) : string;
function TranslateMoveNomTypeField(const Value : string) : string;
function TranslateMoveStkTypeField(const Value : string) : string;
function TranslateVSecureTypeField(const Value : string) : string;
function TranslateBacsUtypeField(const Value : string) : string;
function TranslateMoveCtrlTypeField(const Value : string) : string;
function TranslateExchqnumField(const Value : string) : string;
function TranslateSysRecField(const Value : string) : string;
function TranslateVATRecField(const Value : string) : string;
function TranslateCurr1PTypeField(const Value : string) : string;
function TranslateDEFRecField(const Value : string) : string;
function TranslateJobSRecField(const Value : string) : string;
function TranslateFormDefsTypeField(const Value : string) : string;
function TranslateModuleRelTypeField(const Value : string) : string;
function TranslateGCur1PTypeField(const Value : string) : string;
function TranslateEDI1TypeField(const Value : string) : string;
function TranslateEDI2TypeField(const Value : string) : string;
function TranslateEDI3TypeField(const Value : string) : string;
function TranslateCustomFTypeField(const Value : string) : string;
function TranslateCISCRecField(const Value : string) : string;
function TranslateCIS340RecField(const Value : string) : string;
function TranslateCustDiscTypeField(const Value : string) : string;
function TranslateMultiLocTypeField(const Value : string) : string;
function TranslateFiFoTypeField(const Value : string) : string;
function TranslateIrishVATSOPInpDefTypeField(const Value : string) : string;
function TranslateQtyDiscTypeField(const Value : string) : string;
function TranslateBacsSTypeField(const Value : string) : string;
function TranslateSerialTypeField(const Value : string) : string;
function TranslateBankMTypeField(const Value : string) : string;
function TranslateBtCustomTypeField(const Value : string) : string;
function TranslateBtLetterLinkTypeField(const Value : string) : string;
function TranslateAllocSTypeField(const Value : string) : string;
function TranslateRtLReasonTypeField(const Value : string) : string;
function TranslateB2BInpRecField(const Value : string) : string;
function TranslateB2BLineRecField(const Value : string) : string;
function TranslateFaxesField(const Value : string) : string;
function TranslateFormsField(const Value : string) : string;
function TranslateGroupcmpField(const Value : string) : string;
function TranslateGroupsField(const Value : string) : string;
function TranslateGroupusrField(const Value : string) : string;
function TranslateHistoryField(const Value : string) : string;
function TranslateImportjobField(const Value : string) : string;
function TranslateJobBudgJBField(const Value : string) : string;
function TranslateJobBudgJMField(const Value : string) : string;
function TranslateJobBudgJSField(const Value : string) : string;
function TranslateEmplPayJEField(const Value : string) : string;
function TranslateEmplPayJRField(const Value : string) : string;
function TranslateJobActualField(const Value : string) : string;
function TranslateJobRetenField(const Value : string) : string;
function TranslateJobCISVField(const Value : string) : string;
function TranslateJobheadField(const Value : string) : string;
function TranslateEmplRecField(const Value : string) : string;
function TranslateJobTypeRecField(const Value : string) : string;
function TranslateJobAnalRecField(const Value : string) : string;
function TranslateLbinField(const Value : string) : string;
function TranslateLheaderField(const Value : string) : string;
function TranslateLlinesField(const Value : string) : string;
function TranslateLserialField(const Value : string) : string;
function TranslateMCPAYField(const Value : string) : string;
function TranslateMLocLocField(const Value : string) : string;
function TranslateMStkLocField(const Value : string) : string;
function TranslateSdbStkRecField(const Value : string) : string;
function TranslateCuStkRecField(const Value : string) : string;
function TranslateTeleSRecField(const Value : string) : string;
function TranslateEMUCnvRecField(const Value : string) : string;
function TranslatePassDefRecField(const Value : string) : string;
function TranslateAllocCRecField(const Value : string) : string;
function TranslatebrBinRecField(const Value : string) : string;
function TranslateBnkRHRecField(const Value : string) : string;
function TranslateBnkRDRecField(const Value : string) : string;
function TranslateBACSDbRecField(const Value : string) : string;
function TranslateeBankHRecField(const Value : string) : string;
function TranslateeBankLRecField(const Value : string) : string;
function TranslateNominalField(const Value : string) : string;
function TranslateNomViewTypeField(const Value : string) : string;
function TranslateViewCtrlTypeField(const Value : string) : string;
function TranslatePAAUTHField(const Value : string) : string;
function TranslatePACOMPField(const Value : string) : string;
function TranslatePAEARField(const Value : string) : string;
function TranslatePAGLOBALField(const Value : string) : string;
function TranslatePapersizeField(const Value : string) : string;
function TranslatePAUSERField(const Value : string) : string;
function TranslatePPCUSTField(const Value : string) : string;
function TranslatePPDEBTField(const Value : string) : string;
function TranslatePPSETUPField(const Value : string) : string;
function TranslateReportsField(const Value : string) : string;
function TranslateSALECODEField(const Value : string) : string;
function TranslateSCHEDCFGField(const Value : string) : string;
function TranslateSCHEDULEField(const Value : string) : string;
function TranslateSCTYPEField(const Value : string) : string;
function TranslateSentField(const Value : string) : string;
function TranslateSentLineField(const Value : string) : string;
function TranslateSettingsField(const Value : string) : string;
function TranslateStockField(const Value : string) : string;
function TranslateTillnameField(const Value : string) : string;
function TranslateMenuItemField(const Value : string) : string;
function TranslateUserXRefField(const Value : string) : string;
function TranslateSysSetupField(const Value : string) : string;
function TranslateCompanyXRefField(const Value : string) : string;
function TranslateUDENTITYField(const Value : string) : string;
function TranslateUDFIELDField(const Value : string) : string;
function TranslateUDITEMField(const Value : string) : string;
function TranslateVATOPTField(const Value : string) : string;
function TranslateVATPRDField(const Value : string) : string;
function TranslateVRWSECField(const Value : string) : string;
function TranslateVRWTREEField(const Value : string) : string;
 
implementation
 
uses SQLUtils, SysUtils;
 
function TranslateCcdeptvField(const Value : string) : string;
const
  NumberOfFields = 6;
  FieldNames : Array[1..NumberOfFields] of TFieldName = (
                                                         (SQLName:'cdtype';TKName:'cdtype'),
                                                         (SQLName:'cdglcode';TKName:'cdglcode'),
                                                         (SQLName:'cdcostcentre';TKName:'cdcostcentre'),
                                                         (SQLName:'cddepartment';TKName:'cddepartment'),
                                                         (SQLName:'cddummychar';TKName:'cddummychar'),
                                                         (SQLName:'cdvatcode';TKName:'cdvatcode')
                                                        );
var
  i : integer;
begin
  for i := 1 to NumberOfFields do
  begin
    if Trim(UpperCase(Value)) = Trim(UpperCase(FieldNames[i].TkName)) then
    begin
      Result := GetDBColumnName('Ccdeptv.dat', FieldNames[i].SQLName, '');
      Break;
    end;
  end;
end;

function TranslateCommssnField(const Value : string) : string;
const
  NumberOfFields = 18;
  FieldNames : Array[1..NumberOfFields] of TFieldName = (
                                                         (SQLName:'cmFolioNo';TKName:'cmFolioNo'),
                                                         (SQLName:'cmSalesCodeFolioNo';TKName:'cmSalesCodeFolioNo'),
                                                         (SQLName:'cmBy';TKName:'cmBy'),
                                                         (SQLName:'cmCustCode';TKName:'cmCustCode'),
                                                         (SQLName:'cmProductCode';TKName:'cmProductCode'),
                                                         (SQLName:'cmPGroupCode';TKName:'cmPGroupCode'),
                                                         (SQLName:'cmByQty';TKName:'cmByQty'),
                                                         (SQLName:'cmQtyFrom';TKName:'cmQtyFrom'),
                                                         (SQLName:'cmQtyTo';TKName:'cmQtyTo'),
                                                         (SQLName:'cmByCurrency';TKName:'cmByCurrency'),
                                                         (SQLName:'cmCurrency';TKName:'cmCurrency'),
                                                         (SQLName:'cmByDate';TKName:'cmByDate'),
                                                         (SQLName:'cmStartDate';TKName:'cmStartDate'),
                                                         (SQLName:'cmEndDate';TKName:'cmEndDate'),
                                                         (SQLName:'cmCommissionBasis';TKName:'cmCommissionBasis'),
                                                         (SQLName:'cmCommission';TKName:'cmCommission'),
                                                         (SQLName:'cmCommissionType';TKName:'cmCommissionType'),
                                                         (SQLName:'cmDummyChar';TKName:'cmDummyChar')
                                                        );
var
  i : integer;
begin
  for i := 1 to NumberOfFields do
  begin
    if Trim(UpperCase(Value)) = Trim(UpperCase(FieldNames[i].TkName)) then
    begin
      Result := GetDBColumnName('Commssn.dat', FieldNames[i].SQLName, '');
      Break;
    end;
  end;
end;

function TranslateCompanyDetRecField(const Value : string) : string;
const
  NumberOfFields = 15;
  NumberOfFixedFields = 4;
  FieldNames : Array[1..NumberOfFields] of TFieldName = (
                                                         (SQLName:'RecPFix';TKName:'RecPfix'),
                                                         (SQLName:'Company_code1';TKName:'CompanyCode1'),
                                                         (SQLName:'Company_code2';TKName:'Company_code2'),
                                                         (SQLName:'Company_code3';TKName:'Company_code3'),
                                                         (SQLName:'CompId';TKName:'CompId'),
                                                         (SQLName:'CompDemoData';TKName:'CompDemoData'),
                                                         (SQLName:'CompSpare';TKName:'CompSpare'),
                                                         (SQLName:'CompDemoSys';TKName:'CompDemoSys'),
                                                         (SQLName:'CompTKUCount';TKName:'CompTKUCount'),
                                                         (SQLName:'CompTrdUCount';TKName:'CompTrdUCount'),
                                                         (SQLName:'CompSysESN';TKName:'CompSysESN'),
                                                         (SQLName:'CompModId';TKName:'CompModId'),
                                                         (SQLName:'CompModSynch';TKName:'CompModSynch'),
                                                         (SQLName:'CompUCount';TKName:'CompUCount'),
                                                         (SQLName:'CompAnal';TKName:'CompAnal')
                                                        );
var
  i : integer;
  CurrentPrefix : String;
begin
  for i := 1 to NumberOfFields do
  begin
    if Trim(UpperCase(Value)) = Trim(UpperCase(FieldNames[i].TkName)) then
    begin
      if i > NumberOfFixedFields then
        CurrentPrefix := 'C'
      else
        CurrentPrefix := '';
      Result := GetDBColumnName('Company.dat', FieldNames[i].SQLName, CurrentPrefix);
      Break;
    end;
  end;
end;

function TranslateCompanyOptionsField(const Value : string) : string;
const
  NumberOfFields = 18;
  NumberOfFixedFields = 4;
  FieldNames : Array[1..NumberOfFields] of TFieldName = (
                                                         (SQLName:'RecPFix';TKName:'RecPfix'),
                                                         (SQLName:'Company_code1';TKName:'CompanyCode1'),
                                                         (SQLName:'Company_code2';TKName:'Company_code2'),
                                                         (SQLName:'Company_code3';TKName:'Company_code3'),
                                                         (SQLName:'OptPWord';TKName:'OptPWord'),
                                                         (SQLName:'OptBackup';TKName:'OptBackup'),
                                                         (SQLName:'OptRestore';TKName:'OptRestore'),
                                                         (SQLName:'OptHidePath';TKName:'OptHidePath'),
                                                         (SQLName:'OptHideBackup';TKName:'OptHideBackup'),
                                                         (SQLName:'OptWin9xCmd';TKName:'OptWin9xCmd'),
                                                         (SQLName:'OptWinNTCmd';TKName:'OptWinNTCmd'),
                                                         (SQLName:'OptShowCheckUsr';TKName:'OptShowCheckUsr'),
                                                         (SQLName:'optSystemESN';TKName:'optSystemESN'),
                                                         (SQLName:'OptSecurity';TKName:'OptSecurity'),
                                                         (SQLName:'OptShowExch';TKName:'OptShowExch'),
                                                         (SQLName:'OptBureauModule';TKName:'OptBureauModule'),
                                                         (SQLName:'OptBureauAdminPWord';TKName:'OptBureauAdminPWord'),
                                                         (SQLName:'OptShowViewCompany';TKName:'OptShowViewCompany')
                                                        );
var
  i : integer;
  CurrentPrefix : String;
begin
  for i := 1 to NumberOfFields do
  begin
    if Trim(UpperCase(Value)) = Trim(UpperCase(FieldNames[i].TkName)) then
    begin
      if i > NumberOfFixedFields then
        CurrentPrefix := 'S'
      else
        CurrentPrefix := '';
      Result := GetDBColumnName('Company.dat', FieldNames[i].SQLName, CurrentPrefix);
      Break;
    end;
  end;
end;

function TranslateUserCountXRefTypeUField(const Value : string) : string;
const
  NumberOfFields = 8;
  NumberOfFixedFields = 4;
  FieldNames : Array[1..NumberOfFields] of TFieldName = (
                                                         (SQLName:'RecPFix';TKName:'RecPfix'),
                                                         (SQLName:'Company_code1';TKName:'CompanyCode1'),
                                                         (SQLName:'Company_code2';TKName:'Company_code2'),
                                                         (SQLName:'Company_code3';TKName:'Company_code3'),
                                                         (SQLName:'ucCompanyId';TKName:'ucCompanyId'),
                                                         (SQLName:'ucWStationId';TKName:'ucWStationId'),
                                                         (SQLName:'ucUserId';TKName:'ucUserId'),
                                                         (SQLName:'ucRefCount';TKName:'ucRefCount')
                                                        );
var
  i : integer;
  CurrentPrefix : String;
begin
  for i := 1 to NumberOfFields do
  begin
    if Trim(UpperCase(Value)) = Trim(UpperCase(FieldNames[i].TkName)) then
    begin
      if i > NumberOfFixedFields then
        CurrentPrefix := 'U'
      else
        CurrentPrefix := '';
      Result := GetDBColumnName('Company.dat', FieldNames[i].SQLName, CurrentPrefix);
      Break;
    end;
  end;
end;

function TranslateUserCountXRefTypeTField(const Value : string) : string;
const
  NumberOfFields = 8;
  NumberOfFixedFields = 4;
  FieldNames : Array[1..NumberOfFields] of TFieldName = (
                                                         (SQLName:'RecPFix';TKName:'RecPfix'),
                                                         (SQLName:'Company_code1';TKName:'CompanyCode1'),
                                                         (SQLName:'Company_code2';TKName:'Company_code2'),
                                                         (SQLName:'Company_code3';TKName:'Company_code3'),
                                                         (SQLName:'ucCompanyId';TKName:'ucCompanyId'),
                                                         (SQLName:'ucWStationId';TKName:'ucWStationId'),
                                                         (SQLName:'ucUserId';TKName:'ucUserId'),
                                                         (SQLName:'ucRefCount';TKName:'ucRefCount')
                                                        );
var
  i : integer;
  CurrentPrefix : String;
begin
  for i := 1 to NumberOfFields do
  begin
    if Trim(UpperCase(Value)) = Trim(UpperCase(FieldNames[i].TkName)) then
    begin
      if i > NumberOfFixedFields then
        CurrentPrefix := 'T'
      else
        CurrentPrefix := '';
      Result := GetDBColumnName('Company.dat', FieldNames[i].SQLName, CurrentPrefix);
      Break;
    end;
  end;
end;

function TranslateUserCountXRefTypeRField(const Value : string) : string;
const
  NumberOfFields = 8;
  NumberOfFixedFields = 4;
  FieldNames : Array[1..NumberOfFields] of TFieldName = (
                                                         (SQLName:'RecPFix';TKName:'RecPfix'),
                                                         (SQLName:'Company_code1';TKName:'CompanyCode1'),
                                                         (SQLName:'Company_code2';TKName:'Company_code2'),
                                                         (SQLName:'Company_code3';TKName:'Company_code3'),
                                                         (SQLName:'ucCompanyId';TKName:'ucCompanyId'),
                                                         (SQLName:'ucWStationId';TKName:'ucWStationId'),
                                                         (SQLName:'ucUserId';TKName:'ucUserId'),
                                                         (SQLName:'ucRefCount';TKName:'ucRefCount')
                                                        );
var
  i : integer;
  CurrentPrefix : String;
begin
  for i := 1 to NumberOfFields do
  begin
    if Trim(UpperCase(Value)) = Trim(UpperCase(FieldNames[i].TkName)) then
    begin
      if i > NumberOfFixedFields then
        CurrentPrefix := 'R'
      else
        CurrentPrefix := '';
      Result := GetDBColumnName('Company.dat', FieldNames[i].SQLName, CurrentPrefix);
      Break;
    end;
  end;
end;
 
function TranslateHookSecurityRecTypeField(const Value : string) : string;
const
  NumberOfFields = 9;
  NumberOfFixedFields = 4;
  FieldNames : Array[1..NumberOfFields] of TFieldName = (
                                                         (SQLName:'RecPFix';TKName:'RecPfix'),
                                                         (SQLName:'Company_code1';TKName:'CompanyCode1'),
                                                         (SQLName:'Company_code2';TKName:'Company_code2'),
                                                         (SQLName:'Company_code3';TKName:'Company_code3'),
                                                         (SQLName:'hkId';TKName:'hkId'),
                                                         (SQLName:'hkSecCode';TKName:'hkSecCode'),
                                                         (SQLName:'hkDesc';TKName:'hkDesc'),
                                                         (SQLName:'hkStuff';TKName:'hkStuff'),
                                                         (SQLName:'hkMessage';TKName:'hkMessage')
                                                        );
var
  i : integer;
  CurrentPrefix : String;
begin
  for i := 1 to NumberOfFields do
  begin
    if Trim(UpperCase(Value)) = Trim(UpperCase(FieldNames[i].TkName)) then
    begin
      if i > NumberOfFixedFields then
        CurrentPrefix := 'H'
      else
        CurrentPrefix := '';
      Result := GetDBColumnName('Company.dat', FieldNames[i].SQLName, CurrentPrefix);
      Break;
    end;
  end;
end;

function TranslateAccessControlTypeField(const Value : string) : string;
const
  NumberOfFields = 5;
  NumberOfFixedFields = 4;
  FieldNames : Array[1..NumberOfFields] of TFieldName = (
                                                         (SQLName:'RecPFix';TKName:'RecPfix'),
                                                         (SQLName:'Company_code1';TKName:'CompanyCode1'),
                                                         (SQLName:'Company_code2';TKName:'Company_code2'),
                                                         (SQLName:'Company_code3';TKName:'Company_code3'),
                                                         (SQLName:'acSystemId';TKName:'acSystemId')
                                                        );
var
  i : integer;
  CurrentPrefix : String;
begin
  for i := 1 to NumberOfFields do
  begin
    if Trim(UpperCase(Value)) = Trim(UpperCase(FieldNames[i].TkName)) then
    begin
      if i > NumberOfFixedFields then
        CurrentPrefix := 'A'
      else
        CurrentPrefix := '';
      Result := GetDBColumnName('Company.dat', FieldNames[i].SQLName, CurrentPrefix);
      Break;
    end;
  end;
end;

function TranslateContactField(const Value : string) : string;
const
  NumberOfFields = 17;
  FieldNames : Array[1..NumberOfFields] of TFieldName = (
                                                         (SQLName:'coCompany';TKName:'coCompany'),
                                                         (SQLName:'coAccount';TKName:'coAccount'),
                                                         (SQLName:'coCode';TKName:'coCode'),
                                                         (SQLName:'coTitle';TKName:'coTitle'),
                                                         (SQLName:'coFirstName';TKName:'coFirstName'),
                                                         (SQLName:'coSurname';TKName:'coSurname'),
                                                         (SQLName:'coPosition';TKName:'coPosition'),
                                                         (SQLName:'coSalutation';TKName:'coSalutation'),
                                                         (SQLName:'coContactNo';TKName:'coContactNo'),
                                                         (SQLName:'coDate';TKName:'coDate'),
                                                         (SQLName:'coFaxNumber';TKName:'coFaxNumber'),
                                                         (SQLName:'coEmailAddr';TKName:'coEmailAddr'),
                                                         (SQLName:'coAddress1';TKName:'coAddress1'),
                                                         (SQLName:'coAddress2';TKName:'coAddress2'),
                                                         (SQLName:'coAddress3';TKName:'coAddress3'),
                                                         (SQLName:'coAddress4';TKName:'coAddress4'),
                                                         (SQLName:'coPostCode';TKName:'coPostCode')
                                                        );
var
  i : integer;
begin
  for i := 1 to NumberOfFields do
  begin
    if Trim(UpperCase(Value)) = Trim(UpperCase(FieldNames[i].TkName)) then
    begin
      Result := GetDBColumnName('Contact.dat', FieldNames[i].SQLName, '');
      Break;
    end;
  end;
end;

function TranslateCustsuppField(const Value : string) : string;
const
  NumberOfFields = 133;
  FieldNames : Array[1..NumberOfFields] of TFieldName = (
                                                         (SQLName:'f_cust_code';TKName:'acCode'),
                                                         (SQLName:'f_cust_supp';TKName:'acCustSupp'),  //Not used in COMTK
                                                         (SQLName:'f_company';TKName:'acCompany'),
                                                         (SQLName:'f_area_code';TKName:'acArea'),
                                                         (SQLName:'f_rep_code';TKName:'acAccType'),
                                                         (SQLName:'f_remit_code';TKName:'acStatementTo'),
                                                         (SQLName:'f_vat_reg_no';TKName:'acVATRegNo'),

                                                         (SQLName:'f_address_line1';TKName:'acAddress[1]'),
                                                         (SQLName:'f_address_line2';TKName:'acAddress[2]'),
                                                         (SQLName:'f_address_line3';TKName:'acAddress[3]'),
                                                         (SQLName:'f_address_line4';TKName:'acAddress[4]'),
                                                         (SQLName:'f_address_line5';TKName:'acAddress[5]'),

                                                         (SQLName:'f_address_line1';TKName:'acAddress.Lines[1]'),
                                                         (SQLName:'f_address_line2';TKName:'acAddress.Lines[2]'),
                                                         (SQLName:'f_address_line3';TKName:'acAddress.Lines[3]'),
                                                         (SQLName:'f_address_line4';TKName:'acAddress.Lines[4]'),
                                                         (SQLName:'f_address_line5';TKName:'acAddress.Lines[5]'),

                                                         (SQLName:'f_address_line1';TKName:'acAddress.Street1'),
                                                         (SQLName:'f_address_line2';TKName:'acAddress.Street2'),
                                                         (SQLName:'f_address_line3';TKName:'acAddress.Town'),
                                                         (SQLName:'f_address_line4';TKName:'acAddress.County'),
                                                         (SQLName:'f_address_line5';TKName:'acAddress.Postcard'),

                                                         (SQLName:'f_desp_addr';TKName:'acDespAddr'), //Not used in COMTK?

                                                         (SQLName:'f_desp_address_line1';TKName:'acDelAddress[1]'),
                                                         (SQLName:'f_desp_address_line2';TKName:'acDelAddress[2]'),
                                                         (SQLName:'f_desp_address_line3';TKName:'acDelAddress[3]'),
                                                         (SQLName:'f_desp_address_line4';TKName:'acDelAddress[4]'),
                                                         (SQLName:'f_desp_address_line5';TKName:'acDelAddress[5]'),

                                                         (SQLName:'f_desp_address_line1';TKName:'acDelAddress.Lines[1]'),
                                                         (SQLName:'f_desp_address_line2';TKName:'acDelAddress.Lines[2]'),
                                                         (SQLName:'f_desp_address_line3';TKName:'acDelAddress.Lines[3]'),
                                                         (SQLName:'f_desp_address_line4';TKName:'acDelAddress.Lines[4]'),
                                                         (SQLName:'f_desp_address_line5';TKName:'acDelAddress.Lines[5]'),

                                                         (SQLName:'f_desp_address_line1';TKName:'acDelAddress.Street1'),
                                                         (SQLName:'f_desp_address_line2';TKName:'acDelAddress.Street2'),
                                                         (SQLName:'f_desp_address_line3';TKName:'acDelAddress.Town'),
                                                         (SQLName:'f_desp_address_line4';TKName:'acDelAddress.County'),
                                                         (SQLName:'f_desp_address_line5';TKName:'acDelAddress.Postcard'),

                                                         (SQLName:'f_contact';TKName:'acContact'),
                                                         (SQLName:'f_phone';TKName:'acPhone'),
                                                         (SQLName:'f_fax';TKName:'acFax'),
                                                         (SQLName:'f_ref_no';TKName:'acTheirAcc'),
                                                         (SQLName:'f_trad_term';TKName:'acOwnTradTerm'),
                                                         (SQLName:'f_sterms1';TKName:'acTradeTerms[1]'),
                                                         (SQLName:'f_sterms2';TKName:'acTradeTerms[2]'),
                                                         (SQLName:'f_currency';TKName:'acCurrency'),
                                                         (SQLName:'f_vat_code';TKName:'acVATCode'),
                                                         (SQLName:'f_pay_terms';TKName:'acPayTerms'),
                                                         (SQLName:'f_credit_limit';TKName:'acCreditLimit'),
                                                         (SQLName:'f_discount';TKName:'acDiscount'),
                                                         (SQLName:'f_credit_status';TKName:'acCreditStatus'),
                                                         (SQLName:'f_cust_cc';TKName:'acCostCentre'),
                                                         (SQLName:'f_c_disc_ch';TKName:'acDiscountBand'),
                                                         (SQLName:'f_ord_cons_mode';TKName:'acOrderConsolidationMode'),
                                                         (SQLName:'f_def_set_d_days';TKName:'acDefSettleDays'),
                                                         (SQLName:'f_spare5';TKName:'acSpare5'),   //Not used
                                                         (SQLName:'f_balance';TKName:'acBalance'),     //????
                                                         (SQLName:'f_cust_dep';TKName:'acDepartment'),
                                                         (SQLName:'f_eec_member';TKName:'acECMember'),
                                                         (SQLName:'f_n_line_count';TKName:'acNLineCount'),   //Not used
                                                         (SQLName:'f_inc_stat';TKName:'acStatementTo'),
                                                         (SQLName:'f_def_nom_code';TKName:'acSalesGL'),
                                                         (SQLName:'f_def_mloc_stk';TKName:'acLocation'),
                                                         (SQLName:'f_acc_status';TKName:'acAccStatus'),
                                                         (SQLName:'f_pay_type';TKName:'acPayType'),
                                                         (SQLName:'f_bank_sort';TKName:'acBankSort'),
                                                         (SQLName:'f_bank_acc';TKName:'acBankAcc'),
                                                         (SQLName:'f_bank_ref';TKName:'acBankRef'),
                                                         (SQLName:'f_ave_pay';TKName:'acAvePay'),   //Not used in COMTK
                                                         (SQLName:'f_phone2';TKName:'acPhone2'),
                                                         (SQLName:'f_def_cos_nom';TKName:'acCOSGL'),
                                                         (SQLName:'f_def_ctrl_nom';TKName:'acDrCrGL'),
                                                         (SQLName:'f_last_used';TKName:'acLastUsed'),   //Not used in COMTK
                                                         (SQLName:'f_user_def1';TKName:'acUserDef1'),
                                                         (SQLName:'f_user_def2';TKName:'acUserDef2'),
                                                         (SQLName:'f_sop_inv_code';TKName:'acInvoiceTo'),
                                                         (SQLName:'f_sop_auto_w_off';TKName:'acSOPAutoWOff'),
                                                         (SQLName:'f_f_def_page_no';TKName:'acFormSet'),
                                                         (SQLName:'f_b_ord_val';TKName:'acBookOrdVal'),
                                                         (SQLName:'f_dir_deb';TKName:'acDirDebMode'),
                                                         (SQLName:'f_ccds_date';TKName:'acCCStart'),
                                                         (SQLName:'f_ccde_date';TKName:'acCCEnd'),
                                                         (SQLName:'f_ccd_name';TKName:'acCCName'),
                                                         (SQLName:'f_ccd_card_no';TKName:'acCCNumber'),
                                                         (SQLName:'f_ccdsa_ref';TKName:'acCCSwitch'),
                                                         (SQLName:'f_def_set_disc';TKName:'acDefSettleDisc'),
                                                         (SQLName:'f_stat_d_mode';TKName:'acStateDeliveryMode'),
                                                         (SQLName:'f_spare2';TKName:'acSpare2'), //Not Used
                                                         (SQLName:'f_eml_snd_rdr';TKName:'acSendReader'),
                                                         (SQLName:'f_ebus_pwrd';TKName:'acEBusPword'),
                                                         (SQLName:'f_post_code';TKName:'acPostCode'),
                                                         (SQLName:'f_cust_code2';TKName:'acAltCode'),
                                                         (SQLName:'f_allow_web';TKName:'acUseForEbus'),
                                                         (SQLName:'f_eml_zip_atc';TKName:'acZIPAttachments'),
                                                         (SQLName:'f_user_def3';TKName:'acUserDef3'),
                                                         (SQLName:'f_user_def4';TKName:'acUserDef4'),
                                                         (SQLName:'f_web_live_cat';TKName:'acWebLiveCatalog'),
                                                         (SQLName:'f_web_prev_cat';TKName:'acWebPrevCatalog'),
                                                         (SQLName:'f_time_change';TKName:'acTimeStamp'), //Not used in COM TK
                                                         (SQLName:'f_vat_ret_regc';TKName:'acVATCountryCode'),
                                                         (SQLName:'f_ssd_del_terms';TKName:'acSSDDeliveryTerms'),
                                                         (SQLName:'f_cvat_inc_flg';TKName:'acInclusiveVATCode'),
                                                         (SQLName:'f_ssd_mode_tr';TKName:'acSSDModeOfTransport'),
                                                         (SQLName:'f_private_rec';TKName:'acPrivateRec'), //Not used in COM TK
                                                         (SQLName:'f_last_opo';TKName:'acLastOperator'),
                                                         (SQLName:'f_inv_d_mode';TKName:'acDocDeliveryMode'),
                                                         (SQLName:'f_eml_snd_html';TKName:'acSendHTML'),
                                                         (SQLName:'f_email_addr';TKName:'acEmailAddr'),
                                                         (SQLName:'f_sop_cons_ho';TKName:'acOfficeType'),
                                                         (SQLName:'f_def_tag_no';TKName:'acDefTagNo'),
                                                         
                                                         (SQLName:'f_user_def5';TKName:'acUserDef5'),
                                                         (SQLName:'f_user_def6';TKName:'acUserDef6'),
                                                         (SQLName:'f_user_def7';TKName:'acUserDef7'),
                                                         (SQLName:'f_user_def8';TKName:'acUserDef8'),
                                                         (SQLName:'f_user_def9';TKName:'acUserDef9'),
                                                         (SQLName:'f_user_def10';TKName:'acUserDef10'),
                                                         (SQLName:'f_bank_sort_code';TKName:'acBankSortCode'),
                                                         (SQLName:'f_bank_account_code';TKName:'acBankAccountCode'),
                                                         (SQLName:'f_mandate_id';TKName:'acMandateID'),
                                                         (SQLName:'f_mandate_date';TKName:'acMandateDate'),
                                                         (SQLName:'f_delivery_postcode';TKName:'acDeliveryPostCode'),
                                                         (SQLName:'f_subtype';TKName:'acSubType'),
                                                         (SQLName:'f_long_accode';TKName:'acLongAcCode'),
                                                         (SQLName:'f_allow_order_payments';TKName:'acAllowOrderPayments'),
                                                         (SQLName:'f_order_payments_glcode';TKName:'acOrderPaymentsGLCode'),
                                                         (SQLName:'f_country';TKName:'acCountry'),
                                                         (SQLName:'f_delivery_country';TKName:'acDeliveryCountry'),
                                                         (SQLName:'f_ppd_mode';TKName:'acPPDMode'),
                                                         (SQLName:'f_default_to_QR';TKName:'acDefaultToQR'),
                                                         (SQLName:'f_tax_region';TKName:'acTaxRegion'),

                                                         (SQLName:'f_anonymisation_status';TKName:'acAnonymisationStatus'),
                                                         (SQLName:'f_anonymised_date';TKName:'acAnonymisedDate'),
                                                         (SQLName:'f_anonymised_time';TKName:'acAnonymisedTime'));
var
  i : integer;
begin
  for i := 1 to NumberOfFields do
  begin
    if Trim(UpperCase(Value)) = Trim(UpperCase(FieldNames[i].TkName)) then
    begin
      Result := GetDBColumnName('Custsupp.dat', FieldNames[i].SQLName, '');
      Break;
    end;
  end;
end;

function TranslateDetailsField(const Value : string) : string;
const
  NumberOfFields = 113;
  FieldNames : Array[1..NumberOfFields] of TFieldName = (
                                                         (SQLName:'f_folio_ref';TKName:'tlFolioNum'),
                                                         (SQLName:'f_line_no';TKName:'tlLineNo'),
                                                         (SQLName:'f_posted_run';TKName:'tlRunNo'),
                                                         (SQLName:'f_nom_code';TKName:'tlGLCode'),
                                                         (SQLName:'f_nom_mode';TKName:'tlNominalMode'),
                                                         (SQLName:'f_currency';TKName:'tlCurrency'),
                                                         (SQLName:'f_p_yr';TKName:'tlYear'),
                                                         (SQLName:'f_p_pr';TKName:'tlPeriod'),
                                                         (SQLName:'f_department';TKName:'tlDepartment'),
                                                         (SQLName:'f_cost_centre';TKName:'tlCostCentre'),
                                                         (SQLName:'f_stock_code';TKName:'tlStockCode'),
                                                         (SQLName:'f_abs_line_no';TKName:'tlABSLineNo'),
                                                         (SQLName:'f_line_type';TKName:'tlLineType'),
                                                         (SQLName:'f_id_doc_hed';TKName:'tlDocType'),
                                                         (SQLName:'f_dll_update';TKName:'tlDLLUpdate'),
                                                         (SQLName:'f_old_ser_qty';TKName:'tlOldSerialQty'),
                                                         (SQLName:'f_qty';TKName:'tlQty'),
                                                         (SQLName:'f_qty_mul';TKName:'tlQtyMul'),
                                                         (SQLName:'f_net_value';TKName:'tlNetValue'),
                                                         (SQLName:'f_discount';TKName:'tlDiscount'),
                                                         (SQLName:'f_vat_code';TKName:'tlVATCode'),
                                                         (SQLName:'f_vat';TKName:'tlVATAmount'),
                                                         (SQLName:'f_payment';TKName:'tlPaymentCode'),
                                                         (SQLName:'f_old_p_bal';TKName:'tlOldPBal'),
                                                         (SQLName:'f_reconcile';TKName:'tlRecStatus'),
                                                         (SQLName:'f_discount_chr';TKName:'tlDiscFlag'),
                                                         (SQLName:'f_qty_woff';TKName:'tlQtyWOFF'),
                                                         (SQLName:'f_qty_del';TKName:'tlQtyDel'),
                                                         (SQLName:'f_cost_price';TKName:'tlCost'),
                                                         (SQLName:'f_cust_code';TKName:'tlAcCode'),
                                                         (SQLName:'f_p_date';TKName:'tlLineDate'),
                                                         (SQLName:'f_item';TKName:'tlItemNo'),
                                                         (SQLName:'f_description';TKName:'tlDescription'),
                                                         (SQLName:'f_job_code';TKName:'tlJobCode'),
                                                         (SQLName:'f_anal_code';TKName:'tlAnalysisCode'),
                                                         (SQLName:'f_cx_rate1';TKName:'tlCompanyRate'),
                                                         (SQLName:'f_cx_rate2';TKName:'tlDailyRate'),
                                                         (SQLName:'f_l_weight';TKName:'tlUnitWeight'),
                                                         (SQLName:'f_deduct_qty';TKName:'tlStockDeductQty'),
                                                         (SQLName:'f_kit_link';TKName:'tlBOMKitLink'),
                                                         (SQLName:'f_sop_link';TKName:'tlSOPFolioNum'),
                                                         (SQLName:'f_sop_line_no';TKName:'tlSOPABSLineNo'),
                                                         (SQLName:'f_m_loc_stk';TKName:'tlLocation'),
                                                         (SQLName:'f_qty_pick';TKName:'tlQtyPicked'),
                                                         (SQLName:'f_qty_pw_off';TKName:'tlQtyPickedWO'),
                                                         (SQLName:'f_use_pack';TKName:'tlUsePack'),
                                                         (SQLName:'f_serial_qty';TKName:'tlSerialQty'),
                                                         (SQLName:'f_cos_nom_code';TKName:'tlCOSNomCode'),
                                                         (SQLName:'f_doc_p_ref';TKName:'tlOurRef'),
                                                         (SQLName:'f_doc_lt_link';TKName:'tlDocLTLink'),
                                                         (SQLName:'f_prx_pack';TKName:'tlPrxPack'),
                                                         (SQLName:'f_qty_pack';TKName:'tlQtyPack'),
                                                         (SQLName:'f_recon_date';TKName:'tlReconciliationDate'),
                                                         (SQLName:'f_show_case';TKName:'tlShowCase'),
                                                         (SQLName:'f_sdb_folio';TKName:'tlSdbFolio'),
                                                         (SQLName:'f_o_base_equiv';TKName:'tlOriginalBaseValue'),
                                                         (SQLName:'f_use_o_rate';TKName:'tlUseOriginalRates'),
                                                         (SQLName:'f_line_user1';TKName:'tlUserField1'),
                                                         (SQLName:'f_line_user2';TKName:'tlUserField2'),
                                                         (SQLName:'f_line_user3';TKName:'tlUserField3'),
                                                         (SQLName:'f_line_user4';TKName:'tlUserField4'),
                                                         (SQLName:'f_ssd_uplift';TKName:'tlSSDUpliftPerc'),
                                                         (SQLName:'f_ssd_country';TKName:'tlSSDCountry'),
                                                         (SQLName:'f_vat_inc_flg';TKName:'tlInclusiveVATCode'),
                                                         (SQLName:'f_ssd_commod';TKName:'tlSSDCommodCode'),
                                                         (SQLName:'f_ssdsp_unit';TKName:'tlSSDSalesUnit'),
                                                         (SQLName:'f_price_mulx';TKName:'tlPriceMultiplier'),
                                                         (SQLName:'f_b2b_link';TKName:'tlB2BLinkFolio'),
                                                         (SQLName:'f_b2b_line_no';TKName:'tlB2BLineNo'),
                                                         (SQLName:'f_tri_rates';TKName:'tlTriRates'),
                                                         (SQLName:'f_tri_euro';TKName:'tlTriEuro'),
                                                         (SQLName:'f_tri_invert';TKName:'tlTriInvert'),
                                                         (SQLName:'f_tri_float';TKName:'tlTriFloat'),
                                                         (SQLName:'f_spare1';TKName:'tlSpare1'),
                                                         (SQLName:'f_ssd_use_line';TKName:'tlSSDUseLineValues'),
                                                         (SQLName:'f_previous_bal';TKName:'tlPreviousBalance'),
                                                         (SQLName:'f_live_uplift';TKName:'tlLiveUplift'),
                                                         (SQLName:'f_cos_conv_rate';TKName:'tlCOSDailyRate'),
                                                         (SQLName:'f_inc_net_value';TKName:'tlVATIncValue'),
                                                         (SQLName:'f_auto_line_type';TKName:'tlLineSource'),
                                                         (SQLName:'f_cis_rate_code';TKName:'tlCISRateCode'),
                                                         (SQLName:'f_cis_rate';TKName:'tlCISRate'),
                                                         (SQLName:'f_cost_apport';TKName:'tlCostApport'),
                                                         (SQLName:'f_nomio_flg';TKName:'tlNOMIOFlag'),
                                                         (SQLName:'f_bin_qty';TKName:'tlBinQty'),
                                                         (SQLName:'f_cis_adjust';TKName:'tlCISAdjustment'),
                                                         (SQLName:'f_jap_ded_type';TKName:'tlDeductionType'),
                                                         (SQLName:'f_serial_ret_qty';TKName:'tlSerialReturnQty'),
                                                         (SQLName:'f_bin_ret_qty';TKName:'tlBinReturnQty'),

                                                         (SQLName:'f_discount2';TKName:'tlDiscount2'),
                                                         (SQLName:'f_discount2chr';TKName:'tlDiscount2Chr'),
                                                         (SQLName:'f_discount3';TKName:'tlDiscount3'),
                                                         (SQLName:'f_discount3chr';TKName:'tlDiscount3Chr'),
                                                         (SQLName:'f_discount3type';TKName:'tlDiscount3Type'),
                                                         (SQLName:'f_ecservice';TKName:'tlECService'),
                                                         (SQLName:'f_service_start_date';TKName:'tlServiceStartDate'),
                                                         (SQLName:'f_service_end_date';TKName:'tlServiceEndDate'),
                                                         (SQLName:'f_ecsales_tax_reported';TKName:'tlECSalesTaxReported'),
                                                         (SQLName:'f_purchase_service_tax';TKName:'tlPurchaseServiceTax'),
                                                         (SQLName:'f_reference';TKName:'tlReference'),
                                                         (SQLName:'f_receipt_no';TKName:'tlReceiptNo'),
                                                         (SQLName:'f_from_postcode';TKName:'tlFromPostCode'),
                                                         (SQLName:'f_to_postcode';TKName:'tlToPostCode'),
                                                         (SQLName:'f_line_user5';TKName:'tlUserField5'),
                                                         (SQLName:'f_line_user6';TKName:'tlUserField6'),
                                                         (SQLName:'f_line_user7';TKName:'tlUserField7'),
                                                         (SQLName:'f_line_user8';TKName:'tlUserField8'),
                                                         (SQLName:'f_line_user9';TKName:'tlUserField9'),
                                                         (SQLName:'f_line_user10';TKName:'tlUserField10'),
                                                         (SQLName:'f_threshold_code';TKName:'tlThresholdCode'),
                                                         (SQLName:'f_materials_only_retention';TKName:'tlMaterialsOnlyRetention'),
                                                         (SQLName:'f_intrastat_notc';TKName:'tlIntrastatNoTC'),
                                                         (SQLName:'f_tax_region';TKName:'tlTaxRegion')
                                                        );
var
  i : integer;
begin
  for i := 1 to NumberOfFields do
  begin
    if Trim(UpperCase(Value)) = Trim(UpperCase(FieldNames[i].TkName)) then
    begin
      Result := GetDBColumnName('Details.dat', FieldNames[i].SQLName, '');
      Break;
    end;
  end;
end;
 
function TranslateDataVarTypeField(const Value : string) : string;
const
  NumberOfFields = 19;
  NumberOfFixedFields = 4;
  FieldNames : Array[1..NumberOfFields] of TFieldName = (
                                                         (SQLName:'rec_pfix';TKName:'RecPfix'),
                                                         (SQLName:'sub_type';TKName:'SubType'),
                                                         (SQLName:'var_name_key';TKName:'VarKey'),
                                                         (SQLName:'var_pad_name';TKName:'VarName'),
                                                         (SQLName:'var_desc';TKName:'VarDesc'),
                                                         (SQLName:'var_no';TKName:'VarNo'),
                                                         (SQLName:'rep_desc';TKName:'RepDesc'),
                                                         (SQLName:'avail_file';TKName:'AvailFile'),
                                                         (SQLName:'avail_ver';TKName:'AvailVer'),
                                                         (SQLName:'pr_sel';TKName:'PrSel'),
                                                         (SQLName:'var_type';TKName:'VarType'),
                                                         (SQLName:'var_len';TKName:'VarLen'),
                                                         (SQLName:'var_no_dec';TKName:'VarNoDec'),
                                                         (SQLName:'var_dec';TKName:'VarDec'),
                                                         (SQLName:'var_dec_type';TKName:'VarDecType'),
                                                         (SQLName:'format';TKName:'Format'),
                                                         (SQLName:'n_line_count';TKName:'NLineCount'),
                                                         (SQLName:'input_type';TKName:'InputType'),
                                                         (SQLName:'avail_file2';TKName:'AvailFile2')
                                                        );
var
  i : integer;
  CurrentPrefix : String;
begin
  for i := 1 to NumberOfFields do
  begin
    if Trim(UpperCase(Value)) = Trim(UpperCase(FieldNames[i].TkName)) then
    begin
      if i > NumberOfFixedFields then
        CurrentPrefix := 'DV'
      else
        CurrentPrefix := '';
      Result := GetDBColumnName('Dictionary.dat', FieldNames[i].SQLName, CurrentPrefix);
      Break;
    end;
  end;
end;

function TranslateDataXRefTypeField(const Value : string) : string;
const
  NumberOfFields = 7;
  NumberOfFixedFields = 4;
  FieldNames : Array[1..NumberOfFields] of TFieldName = (
                                                         (SQLName:'rec_pfix';TKName:'RecPfix'),
                                                         (SQLName:'sub_type';TKName:'SubType'),
                                                         (SQLName:'var_name_key';TKName:'VarKey'),
                                                         (SQLName:'var_pad_name';TKName:'VarName'),
                                                         (SQLName:'spare';TKName:'Spare'),
                                                         (SQLName:'var_file_no';TKName:'VarFileNo'),
                                                         (SQLName:'var_ex_vers';TKName:'VarExVers')
                                                        );
var
  i : integer;
  CurrentPrefix : String;
begin
  for i := 1 to NumberOfFields do
  begin
    if Trim(UpperCase(Value)) = Trim(UpperCase(FieldNames[i].TkName)) then
    begin
      if i > NumberOfFixedFields then
        CurrentPrefix := 'DX'
      else
        CurrentPrefix := '';
      Result := GetDBColumnName('Dictionary.dat', FieldNames[i].SQLName, CurrentPrefix);
      Break;
    end;
  end;
end;

function TranslateDocumentField(const Value : string) : string;
const
  NumberOfFields = 206;
  FieldNames : Array[1..NumberOfFields] of TFieldName = (
                                                         (SQLName:'f_run_no';TKName:'thRunNo'),
                                                         (SQLName:'f_cust_code';TKName:'thAcCode'),
                                                         (SQLName:'f_nom_auto';TKName:'thNomAuto'),
                                                         (SQLName:'f_our_ref';TKName:'thOurRef'),
                                                         (SQLName:'f_folio_num';TKName:'thFolioNum'),
                                                         (SQLName:'f_currency';TKName:'thCurrency'),
                                                         (SQLName:'f_ac_yr';TKName:'thYear'),
                                                         (SQLName:'f_ac_pr';TKName:'thPeriod'),
                                                         (SQLName:'f_due_date';TKName:'thDueDate'),
                                                         (SQLName:'f_vat_post_date';TKName:'thVATPostDate'),
                                                         (SQLName:'f_trans_date';TKName:'thTransDate'),
                                                         (SQLName:'f_cust_supp';TKName:'thCustSupp'),
                                                         (SQLName:'f_cx_rate_co';TKName:'thCompanyRate'),
                                                         (SQLName:'f_cx_rate_vat';TKName:'thDailyRate'),
                                                         (SQLName:'f_old_your_ref';TKName:'thOldYourRef'),
                                                         (SQLName:'f_batch_link';TKName:'thBatchLink'),
                                                         (SQLName:'f_alloc_stat';TKName:'thOutstanding'),
                                                         (SQLName:'f_i_line_count';TKName:'thNextLineNumber'),
                                                         (SQLName:'f_n_line_count';TKName:'thNextNotesLineNumber'),
                                                         (SQLName:'f_inv_doc_hed';TKName:'thDocType'),
                                                         (SQLName:'f_inv_vat_anal1';TKName:'thVATAnalysis[''S'']'),
                                                         (SQLName:'f_inv_vat_anal2';TKName:'thVATAnalysis[''E'']'),
                                                         (SQLName:'f_inv_vat_anal3';TKName:'thVATAnalysis[''Z'']'),
                                                         (SQLName:'f_inv_vat_anal4';TKName:'thVATAnalysis[''1'']'),
                                                         (SQLName:'f_inv_vat_anal5';TKName:'thVATAnalysis[''2'']'),
                                                         (SQLName:'f_inv_vat_anal6';TKName:'thVATAnalysis[''3'']'),
                                                         (SQLName:'f_inv_vat_anal7';TKName:'thVATAnalysis[''4'']'),
                                                         (SQLName:'f_inv_vat_anal8';TKName:'thVATAnalysis[''5'']'),
                                                         (SQLName:'f_inv_vat_anal9';TKName:'thVATAnalysis[''6'']'),
                                                         (SQLName:'f_inv_vat_anal10';TKName:'thVATAnalysis[''7'']'),
                                                         (SQLName:'f_inv_vat_anal11';TKName:'thVATAnalysis[''8'']'),
                                                         (SQLName:'f_inv_vat_anal12';TKName:'thVATAnalysis[''9'']'),
                                                         (SQLName:'f_inv_vat_anal13';TKName:'thVATAnalysis[''T'']'),
                                                         (SQLName:'f_inv_vat_anal14';TKName:'thVATAnalysis[''X'']'),
                                                         (SQLName:'f_inv_vat_anal15';TKName:'thVATAnalysis[''B'']'),
                                                         (SQLName:'f_inv_vat_anal16';TKName:'thVATAnalysis[''C'']'),
                                                         (SQLName:'f_inv_vat_anal17';TKName:'thVATAnalysis[''F'']'),
                                                         (SQLName:'f_inv_vat_anal18';TKName:'thVATAnalysis[''G'']'),
                                                         (SQLName:'f_inv_vat_anal19';TKName:'thVATAnalysis[''R'']'),
                                                         (SQLName:'f_inv_vat_anal20';TKName:'thVATAnalysis[''W'']'),
                                                         (SQLName:'f_inv_vat_anal21';TKName:'thVATAnalysis[''Y'']'),
                                                         (SQLName:'f_inv_vat_anal22';TKName:'thVATAnalysisRateIAdj'),
                                                         (SQLName:'f_inv_vat_anal23';TKName:'thVATAnalysisRateOAdj'),
                                                         (SQLName:'f_inv_vat_anal24';TKName:'thVATAnalysisRateSpare'),
                                                         (SQLName:'f_inv_net_val';TKName:'thNetValue'),
                                                         (SQLName:'f_inv_vat';TKName:'thTotalVAT'),
                                                         (SQLName:'f_disc_setl';TKName:'thSettleDiscPerc'),
                                                         (SQLName:'f_disc_set_am';TKName:'thSettleDiscAmount'),
                                                         (SQLName:'f_disc_amount';TKName:'thTotalLineDiscount'),
                                                         (SQLName:'f_disc_days';TKName:'thSettleDiscDays'),
                                                         (SQLName:'f_disc_taken';TKName:'thSettleDiscTaken'),
                                                         (SQLName:'f_settled';TKName:'thAmountSettled'),
                                                         (SQLName:'f_auto_inc';TKName:'thAutoSettings.atIncrement'),
                                                         (SQLName:'f_un_yr';TKName:'thAutoSettings.atEndYear'),
                                                         (SQLName:'f_un_pr';TKName:'thAutoSettings.atEndPeriod'),
                                                         (SQLName:'f_trans_nat';TKName:'thTransportNature'),
                                                         (SQLName:'f_trans_mode';TKName:'thTransportMode'),
                                                         (SQLName:'f_remit_no';TKName:'thRemitNo'),
                                                         (SQLName:'f_auto_inc_by';TKName:'thAutoSettings.atIncrementType'),
                                                         (SQLName:'f_hold_flg';TKName:'thHoldFlag'),
                                                         (SQLName:'f_audit_flg';TKName:'thAuditFlag'),
                                                         (SQLName:'f_total_weight';TKName:'thTotalWeight'),

                                                         (SQLName:'f_delivery_addr1';TKName:'thDelAddress[1]'),
                                                         (SQLName:'f_delivery_addr2';TKName:'thDelAddress[2]'),
                                                         (SQLName:'f_delivery_addr3';TKName:'thDelAddress[3]'),
                                                         (SQLName:'f_delivery_addr4';TKName:'thDelAddress[4]'),
                                                         (SQLName:'f_delivery_addr5';TKName:'thDelAddress[5]'),

                                                         (SQLName:'f_delivery_addr1';TKName:'thDelAddress.Lines[1]'),
                                                         (SQLName:'f_delivery_addr2';TKName:'thDelAddress.Lines[2]'),
                                                         (SQLName:'f_delivery_addr3';TKName:'thDelAddress.Lines[3]'),
                                                         (SQLName:'f_delivery_addr4';TKName:'thDelAddress.Lines[4]'),
                                                         (SQLName:'f_delivery_addr5';TKName:'thDelAddress.Lines[5]'),

                                                         (SQLName:'f_delivery_addr1';TKName:'thDelAddress.Street1'),
                                                         (SQLName:'f_delivery_addr2';TKName:'thDelAddress.Street2'),
                                                         (SQLName:'f_delivery_addr3';TKName:'thDelAddress.Town'),
                                                         (SQLName:'f_delivery_addr4';TKName:'thDelAddress.County'),
                                                         (SQLName:'f_delivery_addr5';TKName:'thDelAddress.Postcard'),

                                                         (SQLName:'f_variance';TKName:'thVariance'),
                                                         (SQLName:'f_total_ordered';TKName:'thTotalOrdered'),
                                                         (SQLName:'f_total_reserved';TKName:'thTotalReserved'),
                                                         (SQLName:'f_total_cost';TKName:'thTotalCost'),
                                                         (SQLName:'f_total_invoiced';TKName:'thTotalInvoiced'),
                                                         (SQLName:'f_trans_desc';TKName:'thLongYourRef'),
                                                         (SQLName:'f_until_date';TKName:'thUntilDate'),
                                                         (SQLName:'f_nomvatio';TKName:'thNOMVATIO'),
                                                         (SQLName:'f_external_doc';TKName:'thExternal'),
                                                         (SQLName:'f_printed_doc';TKName:'thPrinted'),
                                                         (SQLName:'f_re_value_adj';TKName:'thRevalueAdj'),
                                                         (SQLName:'f_curr_settled';TKName:'thCurrSettled'),
                                                         (SQLName:'f_settled_vat';TKName:'thSettledVAT'),
                                                         (SQLName:'f_vat_claimed';TKName:'thVATClaimed'),
                                                         (SQLName:'f_batch_nom';TKName:'thBatchGL'),
                                                         (SQLName:'f_auto_post';TKName:'thAutoPost'),
                                                         (SQLName:'f_man_vat';TKName:'thManualVAT'),
                                                         (SQLName:'f_del_terms';TKName:'thDeliveryTerms'),
                                                         (SQLName:'f_on_pick_run';TKName:'thIncludeInPickingRun'),
                                                         (SQLName:'f_op_name';TKName:'thOperator'),
                                                         (SQLName:'f_no_labels';TKName:'thNoLabels'),
                                                         (SQLName:'f_tagged';TKName:'thTagged'),
                                                         (SQLName:'f_pick_run_no';TKName:'thPickingRunNo'),
                                                         (SQLName:'f_ord_match';TKName:'thOrdMatch'),
                                                         (SQLName:'f_deliver_ref';TKName:'thDeliveryNoteRef'),
                                                         (SQLName:'f_exch_cal_co_rate';TKName:'thVATCompanyRate'),
                                                         (SQLName:'f_exch_cal_vat_rate';TKName:'thVATDailyRate'),
                                                         (SQLName:'f_orig_co_rate';TKName:'thOriginalCompanyRate'),
                                                         (SQLName:'f_orig_vat_rate';TKName:'thOriginalDailyRate'),
                                                         (SQLName:'f_post_disc_am';TKName:'PostDiscAm'),
                                                         (SQLName:'f_fr_nom_code';TKName:'thSpareNomCode'),
                                                         (SQLName:'f_p_disc_taken';TKName:'thPostDiscTaken'),
                                                         (SQLName:'f_ctrl_nom';TKName:'thControlGL'),
                                                         (SQLName:'f_d_job_code';TKName:'thJobCode'),
                                                         (SQLName:'f_d_job_anal';TKName:'thAnalysisCode'),
                                                         (SQLName:'f_tot_ord_os';TKName:'thTotalOrderOS'),
                                                         (SQLName:'f_fr_department';TKName:'thAppDepartment'),
                                                         (SQLName:'f_fr_cost_centre';TKName:'thAppCostCentre'),
                                                         (SQLName:'f_doc_user1';TKName:'thUserField1'),
                                                         (SQLName:'f_doc_user2';TKName:'thUserField2'),
                                                         (SQLName:'f_doc_l_split1';TKName:'thLineTypeAnalysis[1]'),
                                                         (SQLName:'f_doc_l_split2';TKName:'thLineTypeAnalysis[2]'),
                                                         (SQLName:'f_doc_l_split3';TKName:'thLineTypeAnalysis[3]'),
                                                         (SQLName:'f_doc_l_split4';TKName:'thLineTypeAnalysis[4]'),
                                                         (SQLName:'f_doc_l_split5';TKName:'thLineTypeAnalysis[5]'),
                                                         (SQLName:'f_doc_l_split6';TKName:'thLineTypeAnalysis[6]'),
                                                         (SQLName:'f_last_letter';TKName:'thLastDebtChaseLetter'),
                                                         (SQLName:'f_batch_now';TKName:'thBatchNow'),
                                                         (SQLName:'f_batch_then';TKName:'thBatchThen'),
                                                         (SQLName:'f_un_tagged';TKName:'thUnTagged'),
                                                         (SQLName:'f_o_base_equiv';TKName:'thOriginalBaseValue'),
                                                         (SQLName:'f_use_o_rate';TKName:'thUseOriginalRates'),
                                                         (SQLName:'f_old_co_rate';TKName:'thOldCompanyRate'),
                                                         (SQLName:'f_old_vat_rate';TKName:'thOldDailyRate'),
                                                         (SQLName:'f_sop_keep_rate';TKName:'thFixedRate'),
                                                         (SQLName:'f_doc_user3';TKName:'thUserField3'),
                                                         (SQLName:'f_doc_user4';TKName:'thUserField4'),
                                                         (SQLName:'f_ssd_process';TKName:'thProcess'),
                                                         (SQLName:'f_ext_source';TKName:'thSource'),
                                                         (SQLName:'f_curr_tri_rate';TKName:'thCurrencyTriRate'),
                                                         (SQLName:'f_curr_tri_euro';TKName:'thCurrencyTriEuro'),
                                                         (SQLName:'f_curr_tri_invert';TKName:'thCurrencyTriInvert'),
                                                         (SQLName:'f_curr_tri_float';TKName:'thCurrencyTriFloat'),
                                                         (SQLName:'f_curr_tri_spare';TKName:'thCurrencyTriSpare'),
                                                         (SQLName:'f_vat_tri_rate';TKName:'thVATTriRate'),
                                                         (SQLName:'f_vat_tri_euro';TKName:'thVATTriEuro'),
                                                         (SQLName:'f_vat_tri_invert';TKName:'thVATTriInvert'),
                                                         (SQLName:'f_vat_tri_float';TKName:'thVATTriFloat'),
                                                         (SQLName:'f_vat_tri_spare';TKName:'thVATTriSpare'),
                                                         (SQLName:'f_orig_tri_rate';TKName:'thOriginalTriRate'),
                                                         (SQLName:'f_orig_tri_euro';TKName:'thOriginalTriEuro'),
                                                         (SQLName:'f_orig_tri_invert';TKName:'thOriginalTriInvert'),
                                                         (SQLName:'f_orig_tri_float';TKName:'thOriginalTriFloat'),
                                                         (SQLName:'f_orig_tri_spare';TKName:'thOriginalTriSpare'),
                                                         (SQLName:'f_old_or_tri_rate';TKName:'thOldOriginalTriRate'),
                                                         (SQLName:'f_old_or_tri_euro';TKName:'thOldOriginalTriEuro'),
                                                         (SQLName:'f_old_or_tri_invert';TKName:'thOldOriginalTriInvert'),
                                                         (SQLName:'f_old_or_tri_float';TKName:'thOldOriginalTriFloat'),
                                                         (SQLName:'f_old_or_tri_spare';TKName:'thOldOriginalTriSpare'),
                                                         (SQLName:'f_post_date';TKName:'thPostedDate'),
                                                         (SQLName:'f_por_pick_sor';TKName:'thPORPickSOR'),
                                                         (SQLName:'f_b_discount';TKName:'thBatchDiscAmount'),
                                                         (SQLName:'f_pre_post_flg';TKName:'thPrePost'),
                                                         (SQLName:'f_auth_amnt';TKName:'thAuthorisedAmnt'),
                                                         (SQLName:'f_time_change';TKName:'thTimeChanged'),
                                                         (SQLName:'f_time_create';TKName:'thTimeCreated'),
                                                         (SQLName:'f_cis_tax';TKName:'thCISTaxDue'),
                                                         (SQLName:'f_cis_declared';TKName:'thCISTaxDeclared'),
                                                         (SQLName:'f_cis_manual_tax';TKName:'thCISManualTax'),
                                                         (SQLName:'f_cis_date';TKName:'thCISDate'),
                                                         (SQLName:'f_total_cost2';TKName:'thTotalCostApportioned'),
                                                         (SQLName:'f_cis_empl';TKName:'thCISEmployee'),
                                                         (SQLName:'f_cis_gross';TKName:'thCISTotalGross'),
                                                         (SQLName:'f_cis_holder';TKName:'thCISSource'),
                                                         (SQLName:'f_h_exported_flag';TKName:'thTimesheetExported'),
                                                         (SQLName:'f_cisg_exclude';TKName:'thCISExcludedFromGross'),
                                                         (SQLName:'f_spare5';TKName:'thSpare5'),
                                                         (SQLName:'f_your_ref';TKName:'thYourRef'),

                                                         (SQLName:'f_doc_user5';TKName:'thUserField5'),
                                                         (SQLName:'f_doc_user6';TKName:'thUserField6'),
                                                         (SQLName:'f_doc_user7';TKName:'thUserField7'),
                                                         (SQLName:'f_doc_user8';TKName:'thUserField8'),
                                                         (SQLName:'f_doc_user9';TKName:'thUserField9'),
                                                         (SQLName:'f_doc_user10';TKName:'thUserField10'),
                                                         (SQLName:'f_delivery_postcode';TKName:'thDeliveryPostCode'),
                                                         (SQLName:'f_originator';TKName:'thOriginator'),
                                                         (SQLName:'f_creation_time';TKName:'thCreationTime'),
                                                         (SQLName:'f_creation_date';TKName:'thCreationDate'),
                                                         (SQLName:'f_order_payment_order_ref';TKName:'thOrderPaymentOrderRef'),
                                                         (SQLName:'f_order_payment_element';TKName:'thOrderPaymentElement'),
                                                         (SQLName:'f_order_payment_flags';TKName:'thOrderPaymentFlags'),
                                                         (SQLName:'f_credit_card_type';TKName:'thCreditCardType'),
                                                         (SQLName:'f_credit_card_number';TKName:'thCreditCardNumber'),
                                                         (SQLName:'f_credit_card_expiry';TKName:'thCreditCardExpiry'),
                                                         (SQLName:'f_credit_card_authorisation_no';TKName:'thCreditCardAuthorisationNo'),
                                                         (SQLName:'f_credit_card_reference_no';TKName:'thCreditCardReferenceNo'),
                                                         (SQLName:'f_custom_data1';TKName:'thCustomData1'),
                                                         (SQLName:'f_delivery_country';TKName:'thDeliveryCountry'),
                                                         (SQLName:'f_ppd_percentage';TKName:'thPPDPercentage'),
                                                         (SQLName:'f_ppd_days';TKName:'thPPDDays'),
                                                         (SQLName:'f_ppd_goods_value';TKName:'thPPDGoodsValue'),
                                                         (SQLName:'f_ppd_vat_value';TKName:'thPPDVATValue'),
                                                         (SQLName:'f_ppd_taken';TKName:'thPPDTaken'),
                                                         (SQLName:'f_ppd_credit_note';TKName:'thPPDCreditNote'),
                                                         (SQLName:'f_batch_pay_ppd_status';TKName:'thBatchPayPPDStatus'),
                                                         (SQLName:'f_intrastat_out_of_period';TKName:'thIntrastatOutOfPeriod'),
                                                         (SQLName:'f_doc_user11';TKName:'thUserField11'),
                                                         (SQLName:'f_doc_user12';TKName:'thUserField12'),
                                                         (SQLName:'f_tax_region';TKName:'thTaxRegion')
                                                        );
var
  i : integer;
begin
  for i := 1 to NumberOfFields do
  begin
    if Trim(UpperCase(Value)) = Trim(UpperCase(FieldNames[i].TkName)) then
    begin
      Result := GetDBColumnName('Document.dat', FieldNames[i].SQLName, '');
      Break;
    end;
  end;
end;

function TranslateTebusParamsField(const Value : string) : string;
const
  NumberOfFields = 9;
  NumberOfFixedFields = 4;
  FieldNames : Array[1..NumberOfFields] of TFieldName = (
                                                         (SQLName:'rec_pfix';TKName:'RecPfix'),
                                                         (SQLName:'sub_type';TKName:'SubType'),
                                                         (SQLName:'ebus_code1';TKName:'ebuscode1'),
                                                         (SQLName:'ebus_code2';TKName:'ebuscode2'),
                                                         (SQLName:'ent_default_company';TKName:'EntDefaultCompany'),
                                                         (SQLName:'ent_csv_map_file_dir';TKName:'EntCSVMapFileDir'),
                                                         (SQLName:'ent_text_file_dir';TKName:'EntTextFileDir'),
                                                         (SQLName:'ent_poll_freq';TKName:'EntPollFreq'),
                                                         (SQLName:'ent_setup_password';TKName:'EntSetupPassword')
                                                        );
var
  i : integer;
  CurrentPrefix : String;
begin
  for i := 1 to NumberOfFields do
  begin
    if Trim(UpperCase(Value)) = Trim(UpperCase(FieldNames[i].TkName)) then
    begin
      if i > NumberOfFixedFields then
        CurrentPrefix := 'EG'
      else
        CurrentPrefix := '';
      Result := GetDBColumnName('Ebus.dat', FieldNames[i].SQLName, CurrentPrefix);
      Break;
    end;
  end;
end;

function TranslateTebusDragNetField(const Value : string) : string;
const
  NumberOfFields = 6;
  NumberOfFixedFields = 4;
  FieldNames : Array[1..NumberOfFields] of TFieldName = (
                                                         (SQLName:'rec_pfix';TKName:'RecPfix'),
                                                         (SQLName:'sub_type';TKName:'SubType'),
                                                         (SQLName:'ebus_code1';TKName:'ebuscode1'),
                                                         (SQLName:'ebus_code2';TKName:'ebuscode2'),
                                                         (SQLName:'dnet_publisher_code';TKName:'DNetPublishercode'),
                                                         (SQLName:'dnet_publisher_password';TKName:'DNetPublisherPassword')
                                                        );
var
  i : integer;
  CurrentPrefix : String;
begin
  for i := 1 to NumberOfFields do
  begin
    if Trim(UpperCase(Value)) = Trim(UpperCase(FieldNames[i].TkName)) then
    begin
      if i > NumberOfFixedFields then
        CurrentPrefix := 'DG'
      else
        CurrentPrefix := '';
      Result := GetDBColumnName('Ebus.dat', FieldNames[i].SQLName, CurrentPrefix);
      Break;
    end;
  end;
end;

function TranslateTebusCompanyField(const Value : string) : string;
const
  NumberOfFields = 57;
  NumberOfFixedFields = 4;
  FieldNames : Array[1..NumberOfFields] of TFieldName = (
                                                         (SQLName:'rec_pfix';TKName:'RecPfix'),
                                                         (SQLName:'sub_type';TKName:'SubType'),
                                                         (SQLName:'ebus_code1';TKName:'ebuscode1'),
                                                         (SQLName:'ebus_code2';TKName:'ebuscode2'),
                                                         (SQLName:'comp_posting_log_dir';TKName:'CompPostingLogDir'),
                                                         (SQLName:'comp_def_cost_centre';TKName:'CompDefCostCentre'),
                                                         (SQLName:'comp_def_dept';TKName:'CompDefDept'),
                                                         (SQLName:'comp_def_location';TKName:'CompDefLocation'),
                                                         (SQLName:'comp_def_customer';TKName:'CompDefCustomer'),
                                                         (SQLName:'comp_def_supplier';TKName:'CompDefSupplier'),
                                                         (SQLName:'comp_def_purch_nom';TKName:'CompDefPurchNom'),
                                                         (SQLName:'comp_def_sales_nom';TKName:'CompDefSalesNom'),
                                                         (SQLName:'comp_def_vat_code';TKName:'CompDefVATcode'),
                                                         (SQLName:'comp_set_period_method';TKName:'CompSetPeriodMethod'),
                                                         (SQLName:'comp_period';TKName:'CompPeriod'),
                                                         (SQLName:'comp_year';TKName:'CompYear'),
                                                         (SQLName:'comp_keep_trans_no';TKName:'CompKeepTransNo'),
                                                         (SQLName:'comp_post_hold_flag';TKName:'CompPostHoldFlag'),
                                                         (SQLName:'comp_trans_text_dir';TKName:'CompTransTextDir'),
                                                         (SQLName:'comp_ord_ok_text_file';TKName:'CompOrdOKTextFile'),
                                                         (SQLName:'comp_ord_fail_text_file';TKName:'CompOrdFailTextFile'),
                                                         (SQLName:'comp_inv_ok_text_file';TKName:'CompInvOKTextFile'),
                                                         (SQLName:'comp_inv_fail_text_file';TKName:'CompInvFailTextFile'),
                                                         (SQLName:'comp_xml_after_process';TKName:'CompXMLAfterProcess'),
                                                         (SQLName:'comp_csv_delimiter';TKName:'CompCSVDelimiter'),
                                                         (SQLName:'comp_csv_separator';TKName:'CompCSVSeparator'),
                                                         (SQLName:'comp_csv_inc_header_row';TKName:'CompCSVIncHeaderRow'),
                                                         (SQLName:'comp_freight_line';TKName:'CompFreightLine'),
                                                         (SQLName:'comp_misc_line';TKName:'CompMiscLine'),
                                                         (SQLName:'comp_discount';TKName:'CompDiscount'),
                                                         (SQLName:'comp_cust_lock_file';TKName:'CompCustLockFile'),
                                                         (SQLName:'comp_stock_lock_file';TKName:'CompStockLockFile'),
                                                         (SQLName:'comp_stock_grp_lock_file';TKName:'CompStockGrpLockFile'),
                                                         (SQLName:'comp_trans_lock_file';TKName:'CompTransLockFile'),
                                                         (SQLName:'comp_cust_lock_ext';TKName:'CompCustLockExt'),
                                                         (SQLName:'comp_stock_lock_ext';TKName:'CompStockLockExt'),
                                                         (SQLName:'comp_stock_grp_lock_ext';TKName:'CompStockGrpLockExt'),
                                                         (SQLName:'comp_trans_lock_ext';TKName:'CompTransLockExt'),
                                                         (SQLName:'comp_cust_lock_method';TKName:'CompCustLockMethod'),
                                                         (SQLName:'comp_stock_lock_method';TKName:'CompStockLockMethod'),
                                                         (SQLName:'comp_stock_grp_method';TKName:'CompStockGrpMethod'),
                                                         (SQLName:'comp_trans_lock_method';TKName:'CompTransLockMethod'),
                                                         (SQLName:'comp_use_stock_for_charges';TKName:'CompUseStockForCharges'),
                                                         (SQLName:'comp_freight_stock_code';TKName:'CompFreightStockcode'),
                                                         (SQLName:'comp_misc_stock_code';TKName:'CompMiscStockcode'),
                                                         (SQLName:'comp_disc_stock_code';TKName:'CompDiscStockcode'),
                                                         (SQLName:'comp_freight_desc';TKName:'CompFreightDesc'),
                                                         (SQLName:'comp_misc_desc';TKName:'CompMiscDesc'),
                                                         (SQLName:'comp_disc_desc';TKName:'CompDiscDesc'),
                                                         (SQLName:'comp_reapply_pricing';TKName:'CompReapplyPricing'),
                                                         (SQLName:'comp_your_ref_to_alt_ref';TKName:'CompYourRefToAltRef'),
                                                         (SQLName:'comp_use_matching';TKName:'CompUseMatching'),
                                                         (SQLName:'comp_sentimail_event';TKName:'CompSentimailEvent'),
                                                         (SQLName:'comp_location_origin';TKName:'CompLocationOrigin'),
                                                         (SQLName:'comp_import_udf1';TKName:'CompImportUDF1'),
                                                         (SQLName:'comp_general_notes';TKName:'CompGeneralNotes'),
                                                         (SQLName:'comp_cc_dep_from_xml';TKName:'CompCCDepFromXML')
                                                        );
var
  i : integer;
  CurrentPrefix : String;
begin
  for i := 1 to NumberOfFields do
  begin
    if Trim(UpperCase(Value)) = Trim(UpperCase(FieldNames[i].TkName)) then
    begin
      if i > NumberOfFixedFields then
        CurrentPrefix := 'EC'
      else
        CurrentPrefix := '';
      Result := GetDBColumnName('Ebus.dat', FieldNames[i].SQLName, CurrentPrefix);
      Break;
    end;
  end;
end;
 
function TranslateTebusFileCountersField(const Value : string) : string;
const
  NumberOfFields = 10;
  NumberOfFixedFields = 4;
  FieldNames : Array[1..NumberOfFields] of TFieldName = (
                                                         (SQLName:'rec_pfix';TKName:'RecPfix'),
                                                         (SQLName:'sub_type';TKName:'SubType'),
                                                         (SQLName:'ebus_code1';TKName:'ebuscode1'),
                                                         (SQLName:'ebus_code2';TKName:'ebuscode2'),
                                                         (SQLName:'stockcounter';TKName:'stockcounter'),
                                                         (SQLName:'stockgrpcounter';TKName:'stockgrpcounter'),
                                                         (SQLName:'transactioncounter';TKName:'transactioncounter'),
                                                         (SQLName:'CustomerCounter';TKName:'CustomerCounter'),
                                                         (SQLName:'emailcounter';TKName:'emailcounter'),
                                                         (SQLName:'exportlogcounter';TKName:'exportlogcounter')
                                                        );
var
  i : integer;
  CurrentPrefix : String;
begin
  for i := 1 to NumberOfFields do
  begin
    if Trim(UpperCase(Value)) = Trim(UpperCase(FieldNames[i].TkName)) then
    begin
      if i > NumberOfFixedFields then
        CurrentPrefix := 'EN'
      else
        CurrentPrefix := '';
      Result := GetDBColumnName('Ebus.dat', FieldNames[i].SQLName, CurrentPrefix);
      Break;
    end;
  end;
end;

function TranslateTebusImportField(const Value : string) : string;
const
  NumberOfFields = 8;
  NumberOfFixedFields = 4;
  FieldNames : Array[1..NumberOfFields] of TFieldName = (
                                                         (SQLName:'rec_pfix';TKName:'RecPfix'),
                                                         (SQLName:'sub_type';TKName:'SubType'),
                                                         (SQLName:'ebus_code1';TKName:'ebuscode1'),
                                                         (SQLName:'ebus_code2';TKName:'ebuscode2'),
                                                         (SQLName:'import_search_dir';TKName:'ImportSearchDir'),
                                                         (SQLName:'import_archive_dir';TKName:'ImportArchiveDir'),
                                                         (SQLName:'import_fail_dir';TKName:'ImportFailDir'),
                                                         (SQLName:'import_log_dir';TKName:'ImportLogDir')
                                                        );
var
  i : integer;
  CurrentPrefix : String;
begin
  for i := 1 to NumberOfFields do
  begin
    if Trim(UpperCase(Value)) = Trim(UpperCase(FieldNames[i].TkName)) then
    begin
      if i > NumberOfFixedFields then
        CurrentPrefix := 'EI'
      else
        CurrentPrefix := '';
      Result := GetDBColumnName('Ebus.dat', FieldNames[i].SQLName, CurrentPrefix);
      Break;
    end;
  end;
end;

function TranslateTebusExportField(const Value : string) : string;
const
  NumberOfFields = 57;
  NumberOfFixedFields = 4;
  FieldNames : Array[1..NumberOfFields] of TFieldName = (
                                                         (SQLName:'rec_pfix';TKName:'RecPfix'),
                                                         (SQLName:'sub_type';TKName:'SubType'),
                                                         (SQLName:'ebus_code1';TKName:'ebuscode1'),
                                                         (SQLName:'ebus_code2';TKName:'ebuscode2'),
                                                         (SQLName:'expt_description';TKName:'ExptDescription'),
                                                         (SQLName:'expt_stock';TKName:'ExptStock'),
                                                         (SQLName:'expt_stock_groups';TKName:'ExptStockGroups'),
                                                         (SQLName:'expt_customers';TKName:'ExptCustomers'),
                                                         (SQLName:'expt_inc_cur_sales_trans';TKName:'ExptIncCurSalesTrans'),
                                                         (SQLName:'expt_inc_cur_sales_orders';TKName:'ExptIncCurSalesOrders'),
                                                         (SQLName:'expt_inc_cur_purch_trans';TKName:'ExptIncCurPurchTrans'),
                                                         (SQLName:'expt_inc_cur_purch_orders';TKName:'ExptIncCurPurchOrders'),
                                                         (SQLName:'expt_inc_com_pricing';TKName:'ExptIncCOMPricing'),
                                                         (SQLName:'expt_ignore_cust_web_inc';TKName:'ExptIgnoreCustWebInc'),
                                                         (SQLName:'expt_ignore_stock_web_inc';TKName:'ExptIgnoreStockWebInc'),
                                                         (SQLName:'expt_ignore_stock_grp_web_inc';TKName:'ExptIgnoreStockGrpWebInc'),
                                                         (SQLName:'expt_cust_file_name';TKName:'ExptCustFileName'),
                                                         (SQLName:'expt_stock_file_name';TKName:'ExptStockFileName'),
                                                         (SQLName:'expt_stock_loc_file_name';TKName:'ExptStockLocFileName'),
                                                         (SQLName:'expt_stock_group_file_name';TKName:'ExptStockGroupFileName'),
                                                         (SQLName:'expt_trans_file_name';TKName:'ExptTransFileName'),
                                                         (SQLName:'expt_trans_lines_file_name';TKName:'ExptTransLinesFileName'),
                                                         (SQLName:'expt_zip_files';TKName:'ExptZipFiles'),
                                                         (SQLName:'expt_transport_type';TKName:'ExptTransportType'),
                                                         (SQLName:'expt_data_type';TKName:'ExptDataType'),
                                                         (SQLName:'expt_active';TKName:'ExptActive'),
                                                         (SQLName:'expt_time_type';TKName:'ExptTimeType'),
                                                         (SQLName:'expt_frequency';TKName:'ExptFrequency'),
                                                         (SQLName:'expt_time1';TKName:'ExptTime1'),
                                                         (SQLName:'expt_time2';TKName:'ExptTime2'),
                                                         (SQLName:'expt_days_of_week';TKName:'ExptDaysOfWeek'),
                                                         (SQLName:'expt_catalogues';TKName:'ExptCatalogues'),
                                                         (SQLName:'expt_csv_cust_map_file';TKName:'ExptCSVCustMAPFile'),
                                                         (SQLName:'expt_csv_stock_map_file';TKName:'ExptCSVStockMAPFile'),
                                                         (SQLName:'expt_csv_stock_grp_map_file';TKName:'ExptCSVStockGrpMAPFile'),
                                                         (SQLName:'expt_csv_trans_map_file';TKName:'ExptCSVTransMAPFile'),
                                                         (SQLName:'expt_last_export_at';TKName:'ExptLastExportAt'),
                                                         (SQLName:'expt_cust_lock_file';TKName:'ExptCustLockFile'),
                                                         (SQLName:'expt_stock_lock_file';TKName:'ExptStockLockFile'),
                                                         (SQLName:'expt_stock_grp_lock_file';TKName:'ExptStockGrpLockFile'),
                                                         (SQLName:'expt_trans_lock_file';TKName:'ExptTransLockFile'),
                                                         (SQLName:'expt_cust_lock_ext';TKName:'ExptCustLockExt'),
                                                         (SQLName:'expt_stock_lock_ext';TKName:'ExptStockLockExt'),
                                                         (SQLName:'expt_stock_grp_lock_ext';TKName:'ExptStockGrpLockExt'),
                                                         (SQLName:'expt_trans_lock_ext';TKName:'ExptTransLockExt'),
                                                         (SQLName:'expt_cust_lock_method';TKName:'ExptCustLockMethod'),
                                                         (SQLName:'expt_stock_lock_method';TKName:'ExptStockLockMethod'),
                                                         (SQLName:'expt_stock_grp_method';TKName:'ExptStockGrpMethod'),
                                                         (SQLName:'expt_trans_lock_method';TKName:'ExptTransLockMethod'),
                                                         (SQLName:'expt_stock_filter';TKName:'ExptStockFilter'),
                                                         (SQLName:'expt_ignore_com_cust_inc';TKName:'ExptIgnoreCOMCustInc'),
                                                         (SQLName:'expt_ignore_com_stock_inc';TKName:'ExptIgnoreCOMStockInc'),
                                                         (SQLName:'expt_command_line';TKName:'ExptCommandLine'),
                                                         (SQLName:'expt_cust_acc_type_filter';TKName:'ExptCustAccTypeFilter'),
                                                         (SQLName:'expt_cust_acc_type_filter_flag';TKName:'ExptCustAccTypeFilterFlag'),
                                                         (SQLName:'expt_stock_web_filter';TKName:'ExptStockWebFilter'),
                                                         (SQLName:'expt_stock_web_filter_flag';TKName:'ExptStockWebFilterFlag')
                                                        );
var
  i : integer;
  CurrentPrefix : String;
begin
  for i := 1 to NumberOfFields do
  begin
    if Trim(UpperCase(Value)) = Trim(UpperCase(FieldNames[i].TkName)) then
    begin
      if i > NumberOfFixedFields then
        CurrentPrefix := 'EX'
      else
        CurrentPrefix := '';
      Result := GetDBColumnName('Ebus.dat', FieldNames[i].SQLName, CurrentPrefix);
      Break;
    end;
  end;
end;

function TranslateTebusCatalogueField(const Value : string) : string;
const
  NumberOfFields = 7;
  NumberOfFixedFields = 4;
  FieldNames : Array[1..NumberOfFields] of TFieldName = (
                                                         (SQLName:'rec_pfix';TKName:'RecPfix'),
                                                         (SQLName:'sub_type';TKName:'SubType'),
                                                         (SQLName:'ebus_code1';TKName:'ebuscode1'),
                                                         (SQLName:'ebus_code2';TKName:'ebuscode2'),
                                                         (SQLName:'cat_title';TKName:'CatTitle'),
                                                         (SQLName:'cat_credit_limit_applies';TKName:'CatCreditLimitApplies'),
                                                         (SQLName:'cat_on_hold_applies';TKName:'CatOnHoldApplies')
                                                        );
var
  i : integer;
  CurrentPrefix : String;
begin
  for i := 1 to NumberOfFields do
  begin
    if Trim(UpperCase(Value)) = Trim(UpperCase(FieldNames[i].TkName)) then
    begin
      if i > NumberOfFixedFields then
        CurrentPrefix := 'EA'
      else
        CurrentPrefix := '';
      Result := GetDBColumnName('Ebus.dat', FieldNames[i].SQLName, CurrentPrefix);
      Break;
    end;
  end;
end;

function TranslateTebusFTPField(const Value : string) : string;
const
  NumberOfFields = 17;
  NumberOfFixedFields = 4;
  FieldNames : Array[1..NumberOfFields] of TFieldName = (
                                                         (SQLName:'rec_pfix';TKName:'RecPfix'),
                                                         (SQLName:'sub_type';TKName:'SubType'),
                                                         (SQLName:'ebus_code1';TKName:'ebuscode1'),
                                                         (SQLName:'ebus_code2';TKName:'ebuscode2'),
                                                         (SQLName:'ftp_site_port';TKName:'FTPSitePort'),
                                                         (SQLName:'ftp_site_address';TKName:'FTPSiteAddress'),
                                                         (SQLName:'ftp_user_name';TKName:'FTPUserName'),
                                                         (SQLName:'ftp_password';TKName:'FTPPassword'),
                                                         (SQLName:'ftp_request_timeout';TKName:'FTPRequestTimeOut'),
                                                         (SQLName:'ftp_proxy_port';TKName:'FTPProxyPort'),
                                                         (SQLName:'ftp_proxy_address';TKName:'FTPProxyAddress'),
                                                         (SQLName:'ftp_passive_mode';TKName:'FTPPassiveMode'),
                                                         (SQLName:'ftp_root_dir';TKName:'FTPRootDir'),
                                                         (SQLName:'ftp_customer_dir';TKName:'FTPCustomerDir'),
                                                         (SQLName:'ftp_stock_dir';TKName:'FTPStockDir'),
                                                         (SQLName:'ftpcom_price_dir';TKName:'FTPCOMPriceDir'),
                                                         (SQLName:'ftp_transaction_dir';TKName:'FTPTransactionDir')
                                                        );
var
  i : integer;
  CurrentPrefix : String;
begin
  for i := 1 to NumberOfFields do
  begin
    if Trim(UpperCase(Value)) = Trim(UpperCase(FieldNames[i].TkName)) then
    begin
      if i > NumberOfFixedFields then
        CurrentPrefix := 'EF'
      else
        CurrentPrefix := '';
      Result := GetDBColumnName('Ebus.dat', FieldNames[i].SQLName, CurrentPrefix);
      Break;
    end;
  end;
end;

function TranslateTebusEmailField(const Value : string) : string;
const
  NumberOfFields = 17;
  NumberOfFixedFields = 4;
  FieldNames : Array[1..NumberOfFields] of TFieldName = (
                                                         (SQLName:'rec_pfix';TKName:'RecPfix'),
                                                         (SQLName:'sub_type';TKName:'SubType'),
                                                         (SQLName:'ebus_code1';TKName:'ebuscode1'),
                                                         (SQLName:'ebus_code2';TKName:'ebuscode2'),
                                                         (SQLName:'email_enabled';TKName:'EmailEnabled'),
                                                         (SQLName:'email_admin_address';TKName:'EmailAdminAddress'),
                                                         (SQLName:'email_notify_admin';TKName:'EmailNotifyAdmin'),
                                                         (SQLName:'email_type';TKName:'EmailType'),
                                                         (SQLName:'email_server_name';TKName:'EmailServerName'),
                                                         (SQLName:'email_account_name';TKName:'EmailAccountName'),
                                                         (SQLName:'email_account_password';TKName:'EmailAccountPassword'),
                                                         (SQLName:'email_notify_sender';TKName:'EmailNotifySender'),
                                                         (SQLName:'email_confirm_processing';TKName:'EmailConfirmProcessing'),
                                                         (SQLName:'email_customer_addr';TKName:'EmailCustomerAddr'),
                                                         (SQLName:'email_stock_addr';TKName:'EmailStockAddr'),
                                                         (SQLName:'email_com_price_addr';TKName:'EmailCOMPriceAddr'),
                                                         (SQLName:'email_transaction_addr';TKName:'EmailTransactionAddr')
                                                        );
var
  i : integer;
  CurrentPrefix : String;
begin
  for i := 1 to NumberOfFields do
  begin
    if Trim(UpperCase(Value)) = Trim(UpperCase(FieldNames[i].TkName)) then
    begin
      if i > NumberOfFixedFields then
        CurrentPrefix := 'EE'
      else
        CurrentPrefix := '';
      Result := GetDBColumnName('Ebus.dat', FieldNames[i].SQLName, CurrentPrefix);
      Break;
    end;
  end;
end;
 
function TranslateTebusFileField(const Value : string) : string;
const
  NumberOfFields = 9;
  NumberOfFixedFields = 4;
  FieldNames : Array[1..NumberOfFields] of TFieldName = (
                                                         (SQLName:'rec_pfix';TKName:'RecPfix'),
                                                         (SQLName:'sub_type';TKName:'SubType'),
                                                         (SQLName:'ebus_code1';TKName:'ebuscode1'),
                                                         (SQLName:'ebus_code2';TKName:'ebuscode2'),
                                                         (SQLName:'file_customer_dir';TKName:'FileCustomerDir'),
                                                         (SQLName:'file_stock_dir';TKName:'FileStockDir'),
                                                         (SQLName:'file_stock_group_dir';TKName:'FileStockGroupDir'),
                                                         (SQLName:'file_trans_dir';TKName:'FileTransDir'),
                                                         (SQLName:'file_com_price_dir';TKName:'FileCOMPriceDir')
                                                        );
var
  i : integer;
  CurrentPrefix : String;
begin
  for i := 1 to NumberOfFields do
  begin
    if Trim(UpperCase(Value)) = Trim(UpperCase(FieldNames[i].TkName)) then
    begin
      if i > NumberOfFixedFields then
        CurrentPrefix := 'ED'
      else
        CurrentPrefix := '';
      Result := GetDBColumnName('Ebus.dat', FieldNames[i].SQLName, CurrentPrefix);
      Break;
    end;
  end;
end;
 
function TranslateTebusDragNetCompanyField(const Value : string) : string;
const
  NumberOfFields = 12;
  NumberOfFixedFields = 4;
  FieldNames : Array[1..NumberOfFields] of TFieldName = (
                                                         (SQLName:'rec_pfix';TKName:'RecPfix'),
                                                         (SQLName:'sub_type';TKName:'SubType'),
                                                         (SQLName:'ebus_code1';TKName:'ebuscode1'),
                                                         (SQLName:'ebus_code2';TKName:'ebuscode2'),
                                                         (SQLName:'dnet_company_code';TKName:'DNetCompanycode'),
                                                         (SQLName:'dnet_order_no_start';TKName:'DNetOrderNoStart'),
                                                         (SQLName:'dnet_order_prefix';TKName:'DNetOrderPrefix'),
                                                         (SQLName:'dnet_cust_exported_at';TKName:'DNetCustExportedAt'),
                                                         (SQLName:'dnet_stock_exported_at';TKName:'DNetStockExportedAt'),
                                                         (SQLName:'dnet_last_order_file';TKName:'DNetLastOrderFile'),
                                                         (SQLName:'dnet_use_external_ref';TKName:'DNetUseExternalRef'),
                                                         (SQLName:'dnet_use_catalogues';TKName:'DNetUseCatalogues')
                                                        );
var
  i : integer;
  CurrentPrefix : String;
begin
  for i := 1 to NumberOfFields do
  begin
    if Trim(UpperCase(Value)) = Trim(UpperCase(FieldNames[i].TkName)) then
    begin
      if i > NumberOfFixedFields then
        CurrentPrefix := 'DC'
      else
        CurrentPrefix := '';
      Result := GetDBColumnName('Ebus.dat', FieldNames[i].SQLName, CurrentPrefix);
      Break;
    end;
  end;
end;
 
function TranslateTebusDragNetCountryField(const Value : string) : string;
const
  NumberOfFields = 9;
  NumberOfFixedFields = 4;
  FieldNames : Array[1..NumberOfFields] of TFieldName = (
                                                         (SQLName:'rec_pfix';TKName:'RecPfix'),
                                                         (SQLName:'sub_type';TKName:'SubType'),
                                                         (SQLName:'ebus_code1';TKName:'ebuscode1'),
                                                         (SQLName:'ebus_code2';TKName:'ebuscode2'),
                                                         (SQLName:'dnet_ctry_code';TKName:'DNetCtrycode'),
                                                         (SQLName:'dnet_ctry_name';TKName:'DNetCtryName'),
                                                         (SQLName:'dnet_ctry_tax_code';TKName:'DNetCtryTaxcode'),
                                                         (SQLName:'dnet_ctry_ecmember';TKName:'DNetCtryECMember'),
                                                         (SQLName:'dnet_ctry_home_country';TKName:'DNetCtryHomeCountry')
                                                        );
var
  i : integer;
  CurrentPrefix : String;
begin
  for i := 1 to NumberOfFields do
  begin
    if Trim(UpperCase(Value)) = Trim(UpperCase(FieldNames[i].TkName)) then
    begin
      if i > NumberOfFixedFields then
        CurrentPrefix := 'DY'
      else
        CurrentPrefix := '';
      Result := GetDBColumnName('Ebus.dat', FieldNames[i].SQLName, CurrentPrefix);
      Break;
    end;
  end;
end;
 
function TranslateTPreserveDocFieldsField(const Value : string) : string;
const
  NumberOfFields = 13;
  NumberOfFixedFields = 4;
  FieldNames : Array[1..NumberOfFields] of TFieldName = (
                                                         (SQLName:'rec_pfix';TKName:'RecPfix'),
                                                         (SQLName:'sub_type';TKName:'SubType'),
                                                         (SQLName:'ebus_code1';TKName:'ebuscode1'),
                                                         (SQLName:'ebus_code2';TKName:'ebuscode2'),
                                                         (SQLName:'inv_order_no';TKName:'InvOrderNo'),
                                                         (SQLName:'inv_buyers_order';TKName:'InvBuyersOrder'),
                                                         (SQLName:'inv_project_code';TKName:'InvProjectcode'),
                                                         (SQLName:'inv_analysis_code';TKName:'InvAnalysiscode'),
                                                         (SQLName:'inv_supp_invoice';TKName:'InvSuppInvoice'),
                                                         (SQLName:'inv_buyers_delivery';TKName:'InvBuyersDelivery'),
                                                         (SQLName:'inv_folio';TKName:'InvFolio'),
                                                         (SQLName:'inv_posted';TKName:'InvPosted'),
                                                         (SQLName:'inv_posted_date';TKName:'InvPostedDate')
                                                        );
var
  i : integer;
  CurrentPrefix : String;
begin
  for i := 1 to NumberOfFields do
  begin
    if Trim(UpperCase(Value)) = Trim(UpperCase(FieldNames[i].TkName)) then
    begin
      if i > NumberOfFixedFields then
        CurrentPrefix := 'EP'
      else
        CurrentPrefix := '';
      Result := GetDBColumnName('Ebus.dat', FieldNames[i].SQLName, CurrentPrefix);
      Break;
    end;
  end;
end;
 
function TranslateTPreserveLineFieldsField(const Value : string) : string;
const
  NumberOfFields = 21;
  NumberOfFixedFields = 4;
  FieldNames : Array[1..NumberOfFields] of TFieldName = (
                                                         (SQLName:'rec_pfix';TKName:'RecPfix'),
                                                         (SQLName:'sub_type';TKName:'SubType'),
                                                         (SQLName:'ebus_code1';TKName:'ebuscode1'),
                                                         (SQLName:'ebus_code2';TKName:'ebuscode2'),
                                                         (SQLName:'id_abs_line_no';TKName:'IdAbsLineNo'),
                                                         (SQLName:'id_line_no';TKName:'IdLineNo'),
                                                         (SQLName:'id_folio';TKName:'IdFolio'),
                                                         (SQLName:'id_project_code';TKName:'IdProjectcode'),
                                                         (SQLName:'id_analysis_code';TKName:'IdAnalysiscode'),
                                                         (SQLName:'id_buyers_order';TKName:'IdBuyersOrder'),
                                                         (SQLName:'id_buyers_line_ref';TKName:'IdBuyersLineRef'),
                                                         (SQLName:'id_order_no';TKName:'IdOrderNo'),
                                                         (SQLName:'id_pdn_no';TKName:'IdPDNNo'),
                                                         (SQLName:'id_pdn_line_no';TKName:'IdPDNLineNo'),
                                                         (SQLName:'id_value';TKName:'IdValue'),
                                                         (SQLName:'id_qty';TKName:'IDQty'),
                                                         (SQLName:'id_order_line_no';TKName:'IdOrderLineNo'),
                                                         (SQLName:'id_stock_code';TKName:'IdStockcode'),
                                                         (SQLName:'id_description';TKName:'IdDescription'),
                                                         (SQLName:'id_disc_amount';TKName:'IdDiscAmount'),
                                                         (SQLName:'id_disc_char';TKName:'IdDiscChar')
                                                        );
var
  i : integer;
  CurrentPrefix : String;
begin
  for i := 1 to NumberOfFields do
  begin
    if Trim(UpperCase(Value)) = Trim(UpperCase(FieldNames[i].TkName)) then
    begin
      if i > NumberOfFixedFields then
        CurrentPrefix := 'EQ'
      else
        CurrentPrefix := '';
      Result := GetDBColumnName('Ebus.dat', FieldNames[i].SQLName, CurrentPrefix);
      Break;
    end;
  end;
end;
 
function TranslateTLookupGenericCField(const Value : string) : string;
const
  NumberOfFields = 7;
  NumberOfFixedFields = 5;
  FieldNames : Array[1..NumberOfFields] of TFieldName = (
                                                         (SQLName:'rec_pfix';TKName:'RecPfix'),
                                                         (SQLName:'sub_type';TKName:'SubType'),
                                                         (SQLName:'ourtradercode';TKName:'ourtradercode'),
                                                         (SQLName:'ouritemcode';TKName:'ouritemcode'),
                                                         (SQLName:'theiritemcode';TKName:'theiritemcode'),
                                                         (SQLName:'description';TKName:'description'),
                                                         (SQLName:'tag';TKName:'tag')
                                                        );
var
  i : integer;
  CurrentPrefix : String;
begin
  for i := 1 to NumberOfFields do
  begin
    if Trim(UpperCase(Value)) = Trim(UpperCase(FieldNames[i].TkName)) then
    begin
      if i > NumberOfFixedFields then
        CurrentPrefix := 'C'
      else
        CurrentPrefix := '';
      Result := GetDBColumnName('EBUSLKUP.dat', FieldNames[i].SQLName, CurrentPrefix);
      Break;
    end;
  end;
end;
 
function TranslateTLookupGenericVField(const Value : string) : string;
const
  NumberOfFields = 7;
  NumberOfFixedFields = 5;
  FieldNames : Array[1..NumberOfFields] of TFieldName = (
                                                         (SQLName:'rec_pfix';TKName:'RecPfix'),
                                                         (SQLName:'sub_type';TKName:'SubType'),
                                                         (SQLName:'ourtradercode';TKName:'ourtradercode'),
                                                         (SQLName:'ouritemcode';TKName:'ouritemcode'),
                                                         (SQLName:'theiritemcode';TKName:'theiritemcode'),
                                                         (SQLName:'description';TKName:'description'),
                                                         (SQLName:'tag';TKName:'tag')
                                                        );
var
  i : integer;
  CurrentPrefix : String;
begin
  for i := 1 to NumberOfFields do
  begin
    if Trim(UpperCase(Value)) = Trim(UpperCase(FieldNames[i].TkName)) then
    begin
      if i > NumberOfFixedFields then
        CurrentPrefix := 'V'
      else
        CurrentPrefix := '';
      Result := GetDBColumnName('EBUSLKUP.dat', FieldNames[i].SQLName, CurrentPrefix);
      Break;
    end;
  end;
end;
 
function TranslateTField(const Value : string) : string;
const
  NumberOfFields = 6;
  NumberOfFixedFields = 5;
  FieldNames : Array[1..NumberOfFields] of TFieldName = (
                                                         (SQLName:'rec_pfix';TKName:'RecPfix'),
                                                         (SQLName:'sub_type';TKName:'SubType'),
                                                         (SQLName:'ourtradercode';TKName:'ourtradercode'),
                                                         (SQLName:'ouritemcode';TKName:'ouritemcode'),
                                                         (SQLName:'theiritemcode';TKName:'theiritemcode'),
                                                         (SQLName:'lookuptrader';TKName:'lookuptrader')
                                                        );
var
  i : integer;
  CurrentPrefix : String;
begin
  for i := 1 to NumberOfFields do
  begin
    if Trim(UpperCase(Value)) = Trim(UpperCase(FieldNames[i].TkName)) then
    begin
      if i > NumberOfFixedFields then
        CurrentPrefix := 'T'
      else
        CurrentPrefix := '';
      Result := GetDBColumnName('EBUSLKUP.dat', FieldNames[i].SQLName, CurrentPrefix);
      Break;
    end;
  end;
end;
 
function TranslateNotesTypeNDField(const Value : string) : string;
const
  NumberOfFields = 16;
  NumberOfFixedFields = 6;
  FieldNames : Array[1..NumberOfFields] of TFieldName = (
                                                         (SQLName:'rec_pfix';TKName:'RecPfix'),
                                                         (SQLName:'sub_type';TKName:'SubType'),
                                                         (SQLName:'note_no';TKName:'NoteNo'),
                                                         (SQLName:'note_date';TKName:'NoteDate'),
                                                         (SQLName:'spare3';TKName:'Spare3'),
                                                         (SQLName:'ebusnote_code1';TKName:'EbusNote_Code1'),
                                                         (SQLName:'note_folio';TKName:'NoteFolio'),
                                                         (SQLName:'n_type';TKName:'NType'),
                                                         (SQLName:'spare1';TKName:'Spare1'),
                                                         (SQLName:'line_no';TKName:'LineNumber'),
                                                         (SQLName:'note_line';TKName:'NoteLine'),
                                                         (SQLName:'note_user';TKName:'NoteUser'),
                                                         (SQLName:'tmp_imp_code';TKName:'TmpImpCode'),
                                                         (SQLName:'show_date';TKName:'ShowDate'),
                                                         (SQLName:'repeat_no';TKName:'RepeatNo'),
                                                         (SQLName:'note_for';TKName:'NoteFor')
                                                        );
var
  i : integer;
  CurrentPrefix : String;
begin
  for i := 1 to NumberOfFields do
  begin
    if Trim(UpperCase(Value)) = Trim(UpperCase(FieldNames[i].TkName)) then
    begin
      if i > NumberOfFixedFields then
        CurrentPrefix := 'ND'
      else
        CurrentPrefix := '';
      Result := GetDBColumnName('EBUSNOTE.dat', FieldNames[i].SQLName, CurrentPrefix);
      Break;
    end;
  end;
end;
 
function TranslateEmppayField(const Value : string) : string;
const
  NumberOfFields = 4;
  FieldNames : Array[1..NumberOfFields] of TFieldName = (
                                                         (SQLName:'CoCode';TKName:'CoCode'),
                                                         (SQLName:'EmpCode';TKName:'EmpCode'),
                                                         (SQLName:'AcGroup';TKName:'AcGroup'),
                                                         (SQLName:'EmpName';TKName:'EmpName')
                                                        );
var
  i : integer;
begin
  for i := 1 to NumberOfFields do
  begin
    if Trim(UpperCase(Value)) = Trim(UpperCase(FieldNames[i].TkName)) then
    begin
      Result := GetDBColumnName('Emppay.dat', FieldNames[i].SQLName, '');
      Break;
    end;
  end;
end;
 
function TranslatePassEntryTypeField(const Value : string) : string;
const
  NumberOfFields = 7;
  NumberOfFixedFields = 5;
  FieldNames : Array[1..NumberOfFields] of TFieldName = (
                                                         (SQLName:'rec_pfix';TKName:'RecPfix'),
                                                         (SQLName:'sub_type';TKName:'SubType'),
                                                         (SQLName:'exchqchk_code1';TKName:'EXCHQCHKcode1'),
                                                         (SQLName:'exchqchk_code2';TKName:'EXCHQCHKcode2'),
                                                         (SQLName:'exchqchk_code3';TKName:'EXCHQCHKcode3'),
                                                         (SQLName:'access';TKName:'Access'),
                                                         (SQLName:'last_pno';TKName:'LastPno')
                                                        );
var
  i : integer;
  CurrentPrefix : String;
begin
  for i := 1 to NumberOfFields do
  begin
    if Trim(UpperCase(Value)) = Trim(UpperCase(FieldNames[i].TkName)) then
    begin
      if i > NumberOfFixedFields then
        CurrentPrefix := 'P*'
      else
        CurrentPrefix := '';
      Result := GetDBColumnName('Exchqchk.dat', FieldNames[i].SQLName, CurrentPrefix);
      Break;
    end;
  end;
end;
 
function TranslatePassListTypeField(const Value : string) : string;
const
  NumberOfFields = 8;
  NumberOfFixedFields = 5;
  FieldNames : Array[1..NumberOfFields] of TFieldName = (
                                                         (SQLName:'rec_pfix';TKName:'RecPfix'),
                                                         (SQLName:'sub_type';TKName:'SubType'),
                                                         (SQLName:'exchqchk_code1';TKName:'EXCHQCHKcode1'),
                                                         (SQLName:'exchqchk_code2';TKName:'EXCHQCHKcode2'),
                                                         (SQLName:'exchqchk_code3';TKName:'EXCHQCHKcode3'),
                                                         (SQLName:'pass_desc';TKName:'PassDesc'),
                                                         (SQLName:'pass_page';TKName:'PassPage'),
                                                         (SQLName:'pass_lno';TKName:'PassLNo')
                                                        );
var
  i : integer;
  CurrentPrefix : String;
begin
  for i := 1 to NumberOfFields do
  begin
    if Trim(UpperCase(Value)) = Trim(UpperCase(FieldNames[i].TkName)) then
    begin
      if i > NumberOfFixedFields then
        CurrentPrefix := 'L*'
      else
        CurrentPrefix := '';
      Result := GetDBColumnName('Exchqchk.dat', FieldNames[i].SQLName, CurrentPrefix);
      Break;
    end;
  end;
end;
 
function TranslateNotesTypeNAField(const Value : string) : string;
const
  NumberOfFields = 15;
  NumberOfFixedFields = 5;
  FieldNames : Array[1..NumberOfFields] of TFieldName = (
                                                         (SQLName:'rec_pfix';TKName:'RecPfix'),
                                                         (SQLName:'sub_type';TKName:'SubType'),
                                                         (SQLName:'exchqchk_code1';TKName:'EXCHQCHKcode1'),
                                                         (SQLName:'exchqchk_code2';TKName:'EXCHQCHKcode2'),
                                                         (SQLName:'exchqchk_code3';TKName:'EXCHQCHKcode3'),
                                                         (SQLName:'note_folio';TKName:'NoteFolio'),
                                                         (SQLName:'n_type';TKName:'ntType'),
                                                         (SQLName:'spare1';TKName:'Spare1'),
                                                         (SQLName:'line_no';TKName:'ntLineNo'),
                                                         (SQLName:'note_line';TKName:'ntText'),
                                                         (SQLName:'note_user';TKName:'ntOperator'),
                                                         (SQLName:'tmp_imp_code';TKName:'TmpImpCode'),
                                                         (SQLName:'show_date';TKName:'ntAlarmDate'),
                                                         (SQLName:'repeat_no';TKName:'ntAlarmDays'),
                                                         (SQLName:'note_for';TKName:'ntAlarmUser')
                                                        );
var
  i : integer;
  CurrentPrefix : String;
begin
  for i := 1 to NumberOfFields do
  begin
    if Trim(UpperCase(Value)) = Trim(UpperCase(FieldNames[i].TkName)) then
    begin
      if i > NumberOfFixedFields then
        CurrentPrefix := 'N*'
      else
        CurrentPrefix := '';
      Result := GetDBColumnName('Exchqchk.dat', FieldNames[i].SQLName, CurrentPrefix);
      Break;
    end;
  end;
end;

function TranslateNotesTypeNAFieldEx(const Value : string) : string;
const
  NumberOfFields = 15;
  NumberOfFixedFields = 5;
  FieldNames : Array[1..NumberOfFields] of TFieldName = (
                                                         (SQLName:'RecPfix';TKName:'RecPfix'),
                                                         (SQLName:'Subtype';TKName:'SubType'),
                                                         (SQLName:'exchqchk_code1';TKName:'EXCHQCHKcode1'),
                                                         (SQLName:'exchqchk_code2';TKName:'EXCHQCHKcode2'),
                                                         (SQLName:'exchqchk_code3';TKName:'EXCHQCHKcode3'),
                                                         (SQLName:'NoteFolio';TKName:'NoteFolio'),
                                                         (SQLName:'NoteType';TKName:'ntType'),
                                                         (SQLName:'spare1';TKName:'Spare1'),
                                                         (SQLName:'LineNumber';TKName:'ntLineNo'),
                                                         (SQLName:'NoteLine';TKName:'ntText'),
                                                         (SQLName:'NoteUser';TKName:'ntOperator'),
                                                         (SQLName:'TmpImpCode';TKName:'TmpImpCode'),
                                                         (SQLName:'ShowDate';TKName:'ntAlarmDate'),
                                                         (SQLName:'RepeatNo';TKName:'ntAlarmDays'),
                                                         (SQLName:'NoteFor';TKName:'ntAlarmUser')
                                                        );
var
  i : integer;
  CurrentPrefix : String;
begin
  for i := 1 to NumberOfFields do
  begin
    if Trim(UpperCase(Value)) = Trim(UpperCase(FieldNames[i].TkName)) then
    begin
      Result := FieldNames[i].SQLName;
      Break;
    end;
  end;
end;

 
function TranslateMatchPayTypeTPField(const Value : string) : string;
const
  NumberOfFields = 13;
  NumberOfFixedFields = 5;
  FieldNames : Array[1..NumberOfFields] of TFieldName = (
                                                         (SQLName:'rec_pfix';TKName:'RecPfix'),
                                                         (SQLName:'sub_type';TKName:'SubType'),
                                                         (SQLName:'exchqchk_code1';TKName:'maDocRef'),
                                                         (SQLName:'exchqchk_code2';TKName:'EXCHQCHKcode2'),
                                                         (SQLName:'exchqchk_code3';TKName:'EXCHQCHKcode3'),
                                                         (SQLName:'settled_val';TKName:'maBaseValue'),
                                                         (SQLName:'own_c_val';TKName:'maDocValue'),
                                                         (SQLName:'m_currency';TKName:'maDocCurrency'),
                                                         (SQLName:'match_type';TKName:'maType'),
                                                         (SQLName:'old_alt_ref';TKName:'OldAltRef'),
                                                         (SQLName:'r_currency';TKName:'maPayCurrency'),
                                                         (SQLName:'rec_own_c_val';TKName:'maPayValue'),
                                                         (SQLName:'alt_ref';TKName:'maDocYourRef')
                                                        );
var
  i : integer;
  CurrentPrefix : String;
begin
  for i := 1 to NumberOfFields do
  begin
    if Trim(UpperCase(Value)) = Trim(UpperCase(FieldNames[i].TkName)) then
    begin
      if i > NumberOfFixedFields then
        CurrentPrefix := 'T*'
      else
        CurrentPrefix := '';
      Result := GetDBColumnName('Exchqchk.dat', FieldNames[i].SQLName, CurrentPrefix);
      Break;
    end;
  end;
end;
 
function TranslateBillMatTypeField(const Value : string) : string;
const
  NumberOfFields = 11;
  NumberOfFixedFields = 5;
  FieldNames : Array[1..NumberOfFields] of TFieldName = (
                                                         (SQLName:'rec_pfix';TKName:'RecPfix'),
                                                         (SQLName:'sub_type';TKName:'SubType'),
                                                         (SQLName:'exchqchk_code1';TKName:'EXCHQCHKcode1'),
                                                         (SQLName:'exchqchk_code2';TKName:'EXCHQCHKcode2'),
                                                         (SQLName:'exchqchk_code3';TKName:'EXCHQCHKcode3'),
                                                         (SQLName:'qty_used';TKName:'bmQuantityUsed'),
                                                         (SQLName:'qty_cost';TKName:'bmUnitCost'),
                                                         (SQLName:'q_currency';TKName:'bmUnitCostCurrency'),
                                                         (SQLName:'full_stk_code';TKName:'bmStockCode'),
                                                         (SQLName:'free_issue';TKName:'FreeIssue'),
                                                         (SQLName:'qty_time';TKName:'QtyTime')
                                                        );
var
  i : integer;
  CurrentPrefix : String;
begin
  for i := 1 to NumberOfFields do
  begin
    if Trim(UpperCase(Value)) = Trim(UpperCase(FieldNames[i].TkName)) then
    begin
      if i > NumberOfFixedFields then
        CurrentPrefix := 'BM'
      else
        CurrentPrefix := '';
      Result := GetDBColumnName('Exchqchk.dat', FieldNames[i].SQLName, CurrentPrefix);
      Break;
    end;
  end;
end;
 
function TranslateBacsCtypeField(const Value : string) : string;
const
  NumberOfFields = 38;
  NumberOfFixedFields = 5;
  FieldNames : Array[1..NumberOfFields] of TFieldName = (
                                                         (SQLName:'rec_pfix';TKName:'RecPfix'),
                                                         (SQLName:'sub_type';TKName:'SubType'),
                                                         (SQLName:'exchqchk_code1';TKName:'EXCHQCHKcode1'),
                                                         (SQLName:'exchqchk_code2';TKName:'EXCHQCHKcode2'),
                                                         (SQLName:'exchqchk_code3';TKName:'EXCHQCHKcode3'),
                                                         (SQLName:'bacs_tag_run_no';TKName:'BACSTagRunNo'),
                                                         (SQLName:'pay_type';TKName:'PayType'),
                                                         (SQLName:'bacs_bank_nom';TKName:'BACSBankNom'),
                                                         (SQLName:'pay_curr';TKName:'PayCurr'),
                                                         (SQLName:'inv_curr';TKName:'InvCurr'),
                                                         (SQLName:'cq_start';TKName:'CQStart'),
                                                         (SQLName:'age_type';TKName:'AgeType'),
                                                         (SQLName:'age_int';TKName:'AgeInt'),
                                                         (SQLName:'tag_status';TKName:'TagStatus'),
                                                         (SQLName:'total_tag0';TKName:'TotalTag0'),
                                                         (SQLName:'total_tag1';TKName:'TotalTag1'),
                                                         (SQLName:'total_tag2';TKName:'TotalTag2'),
                                                         (SQLName:'total_tag3';TKName:'TotalTag3'),
                                                         (SQLName:'total_tag4';TKName:'TotalTag4'),
                                                         (SQLName:'tag_as_date';TKName:'TagAsDate'),
                                                         (SQLName:'tag_count';TKName:'TagCount'),
                                                         (SQLName:'tag_cc_dep1';TKName:'TagDepartment'),
                                                         (SQLName:'tag_cc_dep2';TKName:'TagCostCentre'),
                                                         (SQLName:'tag_run_date';TKName:'TagRunDate'),
                                                         (SQLName:'tag_run_yr';TKName:'TagRunYr'),
                                                         (SQLName:'tag_run_pr';TKName:'TagRunPr'),
                                                         (SQLName:'sales_mode';TKName:'SalesMode'),
                                                         (SQLName:'last_inv';TKName:'LastInv'),
                                                         (SQLName:'srcpi_ref';TKName:'SRCPIRef'),
                                                         (SQLName:'last_tag_run_no';TKName:'LastTagRunNo'),
                                                         (SQLName:'tag_ctrl_code';TKName:'TagCtrlCode'),
                                                         (SQLName:'use_ac_cc';TKName:'UseAcCC'),
                                                         (SQLName:'set_c_qatp';TKName:'SetCQatP'),
                                                         (SQLName:'inc_s_disc';TKName:'IncSDisc'),
                                                         (SQLName:'sd_days_over';TKName:'SDDaysOver'),
                                                         (SQLName:'show_log';TKName:'ShowLog'),
                                                         (SQLName:'use_os_ndx';TKName:'UseOsNdx'),
                                                         (SQLName:'bacsc_liu_count';TKName:'BACSCLIUCount')
                                                        );
var
  i : integer;
  CurrentPrefix : String;
begin
  for i := 1 to NumberOfFields do
  begin
    if Trim(UpperCase(Value)) = Trim(UpperCase(FieldNames[i].TkName)) then
    begin
      if i > NumberOfFixedFields then
        CurrentPrefix := 'XC'
      else
        CurrentPrefix := '';
      Result := GetDBColumnName('Exchqchk.dat', FieldNames[i].SQLName, CurrentPrefix);
      Break;
    end;
  end;
end;
 
function TranslateBankCtypeField(const Value : string) : string;
const
  NumberOfFields = 21;
  NumberOfFixedFields = 5;
  FieldNames : Array[1..NumberOfFields] of TFieldName = (
                                                         (SQLName:'rec_pfix';TKName:'RecPfix'),
                                                         (SQLName:'sub_type';TKName:'SubType'),
                                                         (SQLName:'exchqchk_code1';TKName:'EXCHQCHKcode1'),
                                                         (SQLName:'exchqchk_code2';TKName:'EXCHQCHKcode2'),
                                                         (SQLName:'exchqchk_code3';TKName:'EXCHQCHKcode3'),
                                                         (SQLName:'tag_run_no';TKName:'TagRunNo'),
                                                         (SQLName:'bank_nom';TKName:'BankNom'),
                                                         (SQLName:'bank_cr';TKName:'BankCr'),
                                                         (SQLName:'recon_opo';TKName:'ReconOpo'),
                                                         (SQLName:'entry_tot_dr';TKName:'EntryTotDr'),
                                                         (SQLName:'entry_tot_cr';TKName:'EntryTotCr'),
                                                         (SQLName:'entry_date';TKName:'EntryDate'),
                                                         (SQLName:'nom_ent_typ';TKName:'NomEntTyp'),
                                                         (SQLName:'all_match_ok';TKName:'AllMatchOk'),
                                                         (SQLName:'match_count';TKName:'MatchCount'),
                                                         (SQLName:'match_o_bal';TKName:'MatchOBal'),
                                                         (SQLName:'man_tot_dr';TKName:'ManTotDr'),
                                                         (SQLName:'man_tot_cr';TKName:'ManTotCr'),
                                                         (SQLName:'man_run_no';TKName:'ManRunNo'),
                                                         (SQLName:'man_change';TKName:'ManChange'),
                                                         (SQLName:'man_count';TKName:'ManCount')
                                                        );
var
  i : integer;
  CurrentPrefix : String;
begin
  for i := 1 to NumberOfFields do
  begin
    if Trim(UpperCase(Value)) = Trim(UpperCase(FieldNames[i].TkName)) then
    begin
      if i > NumberOfFixedFields then
        CurrentPrefix := 'MT'
      else
        CurrentPrefix := '';
      Result := GetDBColumnName('Exchqchk.dat', FieldNames[i].SQLName, CurrentPrefix);
      Break;
    end;
  end;
end;
 
function TranslateAllocFileTypeField(const Value : string) : string;
const
  NumberOfFields = 6;
  NumberOfFixedFields = 5;
  FieldNames : Array[1..NumberOfFields] of TFieldName = (
                                                         (SQLName:'rec_pfix';TKName:'RecPfix'),
                                                         (SQLName:'sub_type';TKName:'SubType'),
                                                         (SQLName:'exchqchk_code1';TKName:'EXCHQCHKcode1'),
                                                         (SQLName:'exchqchk_code2';TKName:'EXCHQCHKcode2'),
                                                         (SQLName:'exchqchk_code3';TKName:'EXCHQCHKcode3'),
                                                         (SQLName:'alloc_sf';TKName:'AllocSF')
                                                        );
var
  i : integer;
  CurrentPrefix : String;
begin
  for i := 1 to NumberOfFields do
  begin
    if Trim(UpperCase(Value)) = Trim(UpperCase(FieldNames[i].TkName)) then
    begin
      if i > NumberOfFixedFields then
        CurrentPrefix := 'A*'
      else
        CurrentPrefix := '';
      Result := GetDBColumnName('Exchqchk.dat', FieldNames[i].SQLName, CurrentPrefix);
      Break;
    end;
  end;
end;
 
function TranslateCostCtrTypeField(const Value : string) : string;
const
  NumberOfFields = 10;
  NumberOfFixedFields = 5;
  FieldNames : Array[1..NumberOfFields] of TFieldName = (
                                                         (SQLName:'rec_pfix';TKName:'RecPfix'),
                                                         (SQLName:'sub_type';TKName:'SubType'),
                                                         (SQLName:'exchqchk_code1';TKName:'EXCHQCHKcode1'),
                                                         (SQLName:'exchqchk_code2';TKName:'EXCHQCHKcode2'),
                                                         (SQLName:'exchqchk_code3';TKName:'EXCHQCHKcode3'),
                                                         (SQLName:'cc_desc';TKName:'cdName'),
                                                         (SQLName:'cc_tag';TKName:'CCTag'),
                                                         (SQLName:'last_access';TKName:'LastAccess'),
                                                         (SQLName:'n_line_count';TKName:'NLineCount'),
                                                         (SQLName:'hide_ac';TKName:'cdInactive')
                                                        );
var
  i : integer;
  CurrentPrefix : String;
begin
  for i := 1 to NumberOfFields do
  begin
    if Trim(UpperCase(Value)) = Trim(UpperCase(FieldNames[i].TkName)) then
    begin
      if i > NumberOfFixedFields then
        CurrentPrefix := 'C*'
      else
        CurrentPrefix := '';
      Result := GetDBColumnName('Exchqchk.dat', FieldNames[i].SQLName, CurrentPrefix);
      Break;
    end;
  end;
end;
 
function TranslateMoveNomTypeField(const Value : string) : string;
const
  NumberOfFields = 9;
  NumberOfFixedFields = 5;
  FieldNames : Array[1..NumberOfFields] of TFieldName = (
                                                         (SQLName:'rec_pfix';TKName:'RecPfix'),
                                                         (SQLName:'sub_type';TKName:'SubType'),
                                                         (SQLName:'exchqchk_code1';TKName:'EXCHQCHKcode1'),
                                                         (SQLName:'exchqchk_code2';TKName:'EXCHQCHKcode2'),
                                                         (SQLName:'exchqchk_code3';TKName:'EXCHQCHKcode3'),
                                                         (SQLName:'mn_move_code';TKName:'MoveCodeNom'),
                                                         (SQLName:'mn_move_from';TKName:'MoveFromNom'),
                                                         (SQLName:'mn_move_to';TKName:'MoveToNom'),
                                                         (SQLName:'mn_move_type';TKName:'MoveTypeNom')
                                                        );
var
  i : integer;
  CurrentPrefix : String;
begin
  for i := 1 to NumberOfFields do
  begin
    if Trim(UpperCase(Value)) = Trim(UpperCase(FieldNames[i].TkName)) then
    begin
      if i > NumberOfFixedFields then
        CurrentPrefix := 'MN'
      else
        CurrentPrefix := '';
      Result := GetDBColumnName('Exchqchk.dat', FieldNames[i].SQLName, CurrentPrefix);
      Break;
    end;
  end;
end;
 
function TranslateMoveStkTypeField(const Value : string) : string;
const
  NumberOfFields = 9;
  NumberOfFixedFields = 5;
  FieldNames : Array[1..NumberOfFields] of TFieldName = (
                                                         (SQLName:'rec_pfix';TKName:'RecPfix'),
                                                         (SQLName:'sub_type';TKName:'SubType'),
                                                         (SQLName:'exchqchk_code1';TKName:'EXCHQCHKcode1'),
                                                         (SQLName:'exchqchk_code2';TKName:'EXCHQCHKcode2'),
                                                         (SQLName:'exchqchk_code3';TKName:'EXCHQCHKcode3'),
                                                         (SQLName:'move_code';TKName:'MoveCodeStk'),
                                                         (SQLName:'m_from_code';TKName:'MoveFromStk'),
                                                         (SQLName:'m_to_code';TKName:'MoveToStk'),
                                                         (SQLName:'new_stk_code';TKName:'NewStkCode')
                                                        );
var
  i : integer;
  CurrentPrefix : String;
begin
  for i := 1 to NumberOfFields do
  begin
    if Trim(UpperCase(Value)) = Trim(UpperCase(FieldNames[i].TkName)) then
    begin
      if i > NumberOfFixedFields then
        CurrentPrefix := 'MS'
      else
        CurrentPrefix := '';
      Result := GetDBColumnName('Exchqchk.dat', FieldNames[i].SQLName, CurrentPrefix);
      Break;
    end;
  end;
end;
 
function TranslateVSecureTypeField(const Value : string) : string;
const
  NumberOfFields = 6;
  NumberOfFixedFields = 5;
  FieldNames : Array[1..NumberOfFields] of TFieldName = (
                                                         (SQLName:'rec_pfix';TKName:'RecPfix'),
                                                         (SQLName:'sub_type';TKName:'SubType'),
                                                         (SQLName:'exchqchk_code1';TKName:'EXCHQCHKcode1'),
                                                         (SQLName:'exchqchk_code2';TKName:'EXCHQCHKcode2'),
                                                         (SQLName:'exchqchk_code3';TKName:'EXCHQCHKcode3'),
                                                         (SQLName:'stuff';TKName:'Stuff')
                                                        );
var
  i : integer;
  CurrentPrefix : String;
begin
  for i := 1 to NumberOfFields do
  begin
    if Trim(UpperCase(Value)) = Trim(UpperCase(FieldNames[i].TkName)) then
    begin
      if i > NumberOfFixedFields then
        CurrentPrefix := 'LV'
      else
        CurrentPrefix := '';
      Result := GetDBColumnName('Exchqchk.dat', FieldNames[i].SQLName, CurrentPrefix);
      Break;
    end;
  end;
end;
 
function TranslateBacsUtypeField(const Value : string) : string;
const
  NumberOfFields = 11;
  NumberOfFixedFields = 5;
  FieldNames : Array[1..NumberOfFields] of TFieldName = (
                                                         (SQLName:'rec_pfix';TKName:'RecPfix'),
                                                         (SQLName:'sub_type';TKName:'SubType'),
                                                         (SQLName:'exchqchk_code1';TKName:'EXCHQCHKcode1'),
                                                         (SQLName:'exchqchk_code2';TKName:'EXCHQCHKcode2'),
                                                         (SQLName:'exchqchk_code3';TKName:'EXCHQCHKcode3'),
                                                         (SQLName:'opo_name';TKName:'OpoName'),
                                                         (SQLName:'start_date';TKName:'StartDate'),
                                                         (SQLName:'start_time';TKName:'StartTime'),
                                                         (SQLName:'win_log_name';TKName:'WinLogName'),
                                                         (SQLName:'win_cpu_name';TKName:'WinCPUName'),
                                                         (SQLName:'bacsu_liu_count';TKName:'BACSULIUCount')
                                                        );
var
  i : integer;
  CurrentPrefix : String;
begin
  for i := 1 to NumberOfFields do
  begin
    if Trim(UpperCase(Value)) = Trim(UpperCase(FieldNames[i].TkName)) then
    begin
      if i > NumberOfFixedFields then
        CurrentPrefix := 'XU'
      else
        CurrentPrefix := '';
      Result := GetDBColumnName('Exchqchk.dat', FieldNames[i].SQLName, CurrentPrefix);
      Break;
    end;
  end;
end;
 
function TranslateMoveCtrlTypeField(const Value : string) : string;
const
  NumberOfFields = 21;
  NumberOfFixedFields = 5;
  FieldNames : Array[1..NumberOfFields] of TFieldName = (
                                                         (SQLName:'rec_pfix';TKName:'RecPfix'),
                                                         (SQLName:'sub_type';TKName:'SubType'),
                                                         (SQLName:'exchqchk_code1';TKName:'EXCHQCHKcode1'),
                                                         (SQLName:'exchqchk_code2';TKName:'EXCHQCHKcode2'),
                                                         (SQLName:'exchqchk_code3';TKName:'EXCHQCHKcode3'),
                                                         (SQLName:'s_code_old';TKName:'SCodeOld'),
                                                         (SQLName:'s_code_new';TKName:'SCodeNew'),
                                                         (SQLName:'move_stage';TKName:'MoveStage'),
                                                         (SQLName:'old_n_code';TKName:'OldNCode'),
                                                         (SQLName:'new_n_code';TKName:'NewNCode'),
                                                         (SQLName:'n_typ_old';TKName:'NTypOld'),
                                                         (SQLName:'n_typ_new';TKName:'NTypNew'),
                                                         (SQLName:'move_key1';TKName:'MoveKey1'),
                                                         (SQLName:'move_key2';TKName:'MoveKey2'),
                                                         (SQLName:'was_mode';TKName:'WasMode'),
                                                         (SQLName:'s_grp_new';TKName:'SGrpNew'),
                                                         (SQLName:'s_user';TKName:'SUser'),
                                                         (SQLName:'fin_stage';TKName:'FinStage'),
                                                         (SQLName:'prog_counter';TKName:'ProgCounter'),
                                                         (SQLName:'mis_cust';TKName:'MIsCust'),
                                                         (SQLName:'mlist_rec_addr';TKName:'MListRecAddr')
                                                        );
var
  i : integer;
  CurrentPrefix : String;
begin
  for i := 1 to NumberOfFields do
  begin
    if Trim(UpperCase(Value)) = Trim(UpperCase(FieldNames[i].TkName)) then
    begin
      if i > NumberOfFixedFields then
        CurrentPrefix := 'LM'
      else
        CurrentPrefix := '';
      Result := GetDBColumnName('Exchqchk.dat', FieldNames[i].SQLName, CurrentPrefix);
      Break;
    end;
  end;
end;
 
function TranslateExchqnumField(const Value : string) : string;
const
  NumberOfFields = 4;
  FieldNames : Array[1..NumberOfFields] of TFieldName = (
                                                         (SQLName:'f_count_type';TKName:'ssCountType'),
                                                         (SQLName:'f_next_count_size';TKName:'ssNextCount_size'),
                                                         (SQLName:'f_next_count';TKName:'ssNextCount'),
                                                         (SQLName:'f_last_value';TKName:'ssLastValue')
                                                        );
var
  i : integer;
begin
  for i := 1 to NumberOfFields do
  begin
    if Trim(UpperCase(Value)) = Trim(UpperCase(FieldNames[i].TkName)) then
    begin
      Result := GetDBColumnName('Exchqnum.dat', FieldNames[i].SQLName, '');
      Break;
    end;
  end;
end;
 
function TranslateSysRecField(const Value : string) : string;
const
  NumberOfFields = 180;
  NumberOfFixedFields = 1;
  FieldNames : Array[1..NumberOfFields] of TFieldName = (
                                                         (SQLName:'id_code';TKName:'IDCode'),
                                                         (SQLName:'opt';TKName:'Opt'),
                                                         (SQLName:'o_mon_wk1';TKName:'OMonWk1'),
                                                         (SQLName:'prin_yr';TKName:'PrinYr'),
                                                         (SQLName:'filt_sno_bin_loc';TKName:'FiltSNoBinLoc'),
                                                         (SQLName:'keep_bin_hist';TKName:'KeepBinHist'),
                                                         (SQLName:'use_bk_theme';TKName:'UseBKTheme'),
                                                         (SQLName:'user_name';TKName:'UserName'),
                                                         (SQLName:'audit_yr';TKName:'AuditYr'),
                                                         (SQLName:'audit_pr';TKName:'AuditPr'),
                                                         (SQLName:'spare6';TKName:'Spare6'),
                                                         (SQLName:'man_rocp';TKName:'ManROCP'),
                                                         (SQLName:'vat_curr';TKName:'VATCurr'),
                                                         (SQLName:'no_cos_dec';TKName:'NoCosDec'),
                                                         (SQLName:'curr_base';TKName:'CurrBase'),
                                                         (SQLName:'mute_beep';TKName:'MuteBeep'),
                                                         (SQLName:'show_stk_gp';TKName:'ShowStkGP'),
                                                         (SQLName:'auto_val_stk';TKName:'AutoValStk'),
                                                         (SQLName:'del_pick_only';TKName:'DelPickOnly'),
                                                         (SQLName:'use_m_loc';TKName:'UseMLoc'),
                                                         (SQLName:'edit_sin_ser';TKName:'EditSinSer'),
                                                         (SQLName:'warn_y_ref';TKName:'WarnYRef'),
                                                         (SQLName:'use_loc_del';TKName:'UseLocDel'),
                                                         (SQLName:'post_cc_nom';TKName:'PostCCNom'),
                                                         (SQLName:'al_tol_val';TKName:'AlTolVal'),
                                                         (SQLName:'al_tol_mode';TKName:'AlTolMode'),
                                                         (SQLName:'debt_l_mode';TKName:'DebtLMode'),
                                                         (SQLName:'auto_gen_var';TKName:'AutoGenVar'),
                                                         (SQLName:'auto_gen_disc';TKName:'AutoGenDisc'),
                                                         (SQLName:'use_module_sec';TKName:'UseModuleSec'),
                                                         (SQLName:'protect_post';TKName:'ProtectPost'),
                                                         (SQLName:'use_pick4_all';TKName:'UsePick4All'),
                                                         (SQLName:'big_stk_tree';TKName:'BigStkTree'),
                                                         (SQLName:'big_job_tree';TKName:'BigJobTree'),
                                                         (SQLName:'show_qty_stree';TKName:'ShowQtySTree'),
                                                         (SQLName:'protect_y_ref';TKName:'ProtectYRef'),
                                                         (SQLName:'purch_ui_date';TKName:'PurchUIDate'),
                                                         (SQLName:'use_uplift_nc';TKName:'UseUpliftNC'),
                                                         (SQLName:'use_wiss4_all';TKName:'UseWIss4All'),
                                                         (SQLName:'use_stdwop';TKName:'UseSTDWOP'),
                                                         (SQLName:'use_sales_anal';TKName:'UseSalesAnal'),
                                                         (SQLName:'post_ccd_combo';TKName:'PostCCDCombo'),
                                                         (SQLName:'use_class_toolb';TKName:'UseClassToolB'),
                                                         (SQLName:'wop_stk_cop_mode';TKName:'WOPStkCopMode'),
                                                         (SQLName:'usr_cntry_code';TKName:'USRCntryCode'),
                                                         (SQLName:'no_net_dec';TKName:'NoNetDec'),
                                                         (SQLName:'deb_trig';TKName:'DebTrig'),
                                                         (SQLName:'bk_theme_no';TKName:'BKThemeNo'),
                                                         (SQLName:'use_gl_class';TKName:'UseGLClass'),
                                                         (SQLName:'spare4';TKName:'Spare4'),
                                                         (SQLName:'no_inv_lines';TKName:'NoInvLines'),
                                                         (SQLName:'wks_o_due';TKName:'WksODue'),
                                                         (SQLName:'c_pr';TKName:'CPr'),
                                                         (SQLName:'c_yr';TKName:'CYr'),
                                                         (SQLName:'o_audit_date';TKName:'OAuditDate'),
                                                         (SQLName:'trade_term';TKName:'TradeTerm'),
                                                         (SQLName:'sta_sep_cr';TKName:'StaSepCr'),
                                                         (SQLName:'sta_age_mthd';TKName:'StaAgeMthd'),
                                                         (SQLName:'sta_ui_date';TKName:'StaUIDate'),
                                                         (SQLName:'sep_run_post';TKName:'SepRunPost'),
                                                         (SQLName:'qu_alloc_flg';TKName:'QUAllocFlg'),
                                                         (SQLName:'dead_bom';TKName:'DeadBOM'),
                                                         (SQLName:'auth_mode';TKName:'AuthMode'),
                                                         (SQLName:'intra_stat';TKName:'IntraStat'),
                                                         (SQLName:'anal_stk_desc';TKName:'AnalStkDesc'),
                                                         (SQLName:'auto_stk_val';TKName:'AutoStkVal'),
                                                         (SQLName:'auto_bill_up';TKName:'AutoBillUp'),
                                                         (SQLName:'auto_cq_no';TKName:'AutoCQNo'),
                                                         (SQLName:'inc_not_due';TKName:'IncNotDue'),
                                                         (SQLName:'use_batch_tot';TKName:'UseBatchTot'),
                                                         (SQLName:'use_stock';TKName:'UseStock'),
                                                         (SQLName:'auto_notes';TKName:'AutoNotes'),
                                                         (SQLName:'hide_menu_opt';TKName:'HideMenuOpt'),
                                                         (SQLName:'use_cc_dep';TKName:'UseCCDep'),
                                                         (SQLName:'no_hold_disc';TKName:'NoHoldDisc'),
                                                         (SQLName:'auto_pr_calc';TKName:'AutoPrCalc'),
                                                         (SQLName:'stop_bad_dr';TKName:'StopBadDr'),
                                                         (SQLName:'use_pay_in';TKName:'UsePayIn'),
                                                         (SQLName:'use_passwords';TKName:'UsePasswords'),
                                                         (SQLName:'print_reciept';TKName:'PrintReciept'),
                                                         (SQLName:'extern_cust';TKName:'ExternCust'),
                                                         (SQLName:'no_qty_dec';TKName:'NoQtyDec'),
                                                         (SQLName:'extern_sin';TKName:'ExternSIN'),
                                                         (SQLName:'prev_pr_off';TKName:'PrevPrOff'),
                                                         (SQLName:'def_pc_disc';TKName:'DefPcDisc'),
                                                         (SQLName:'trad_code_num';TKName:'TradCodeNum'),
                                                         (SQLName:'up_bal_on_post';TKName:'UpBalOnPost'),
                                                         (SQLName:'show_inv_disc';TKName:'ShowInvDisc'),
                                                         (SQLName:'sep_discounts';TKName:'SepDiscounts'),
                                                         (SQLName:'use_credit_chk';TKName:'UseCreditChk'),
                                                         (SQLName:'use_cr_limit_chk';TKName:'UseCRLimitChk'),
                                                         (SQLName:'auto_clear_pay';TKName:'AutoClearPay'),
                                                         (SQLName:'total_conv';TKName:'TotalConv'),
                                                         (SQLName:'disp_pr_as_months';TKName:'DispPrAsMonths'),
                                                         (SQLName:'nom_ctrl_in_vat';TKName:'NomCtrlInVAT'),
                                                         (SQLName:'nom_ctrl_out_vat';TKName:'NomCtrlOutVAT'),
                                                         (SQLName:'nom_ctrl_debtors';TKName:'NomCtrlDebtors'),
                                                         (SQLName:'nom_ctrl_creditors';TKName:'NomCtrlCreditors'),
                                                         (SQLName:'nom_ctrl_discount_given';TKName:'NomCtrlDiscountGiven'),
                                                         (SQLName:'nom_ctrl_discount_taken';TKName:'NomCtrlDiscountTaken'),
                                                         (SQLName:'nom_ctrl_ldisc_given';TKName:'NomCtrlLDiscGiven'),
                                                         (SQLName:'nom_ctrl_ldisc_taken';TKName:'NomCtrlLDiscTaken'),
                                                         (SQLName:'nom_ctrl_profit_bf';TKName:'NomCtrlProfitBF'),
                                                         (SQLName:'nom_ctrl_curr_var';TKName:'NomCtrlCurrVar'),
                                                         (SQLName:'nom_ctrl_unrcurr_var';TKName:'NomCtrlUnRCurrVar'),
                                                         (SQLName:'nom_ctrl_pl_start';TKName:'NomCtrlPLStart'),
                                                         (SQLName:'nom_ctrl_pl_end';TKName:'NomCtrlPLEnd'),
                                                         (SQLName:'nom_ctrl_freight_nc';TKName:'NomCtrlFreightNC'),
                                                         (SQLName:'nom_ctrl_sales_comm';TKName:'NomCtrlSalesComm'),
                                                         (SQLName:'nom_ctrl_purch_comm';TKName:'NomCtrlPurchComm'),
                                                         (SQLName:'nom_ctrl_ret_surcharge';TKName:'NomCtrlRetSurcharge'),
                                                         (SQLName:'nom_ctrl_spare8';TKName:'NomCtrlSpare8'),
                                                         (SQLName:'nom_ctrl_spare9';TKName:'NomCtrlSpare9'),
                                                         (SQLName:'nom_ctrl_spare10';TKName:'NomCtrlSpare10'),
                                                         (SQLName:'nom_ctrl_spare11';TKName:'NomCtrlSpare11'),
                                                         (SQLName:'nom_ctrl_spare12';TKName:'NomCtrlSpare12'),
                                                         (SQLName:'nom_ctrl_spare13';TKName:'NomCtrlSpare13'),
                                                         (SQLName:'nom_ctrl_spare14';TKName:'NomCtrlSpare14'),
                                                         (SQLName:'detail_addr1';TKName:'DetailAddr1'),
                                                         (SQLName:'detail_addr2';TKName:'DetailAddr2'),
                                                         (SQLName:'detail_addr3';TKName:'DetailAddr3'),
                                                         (SQLName:'detail_addr4';TKName:'DetailAddr4'),
                                                         (SQLName:'detail_addr5';TKName:'DetailAddr5'),
                                                         (SQLName:'direct_cust';TKName:'DirectCust'),
                                                         (SQLName:'direct_supp';TKName:'DirectSupp'),
                                                         (SQLName:'termsof_trade1';TKName:'TermsofTrade1'),
                                                         (SQLName:'termsof_trade2';TKName:'TermsofTrade2'),
                                                         (SQLName:'nom_pay_from';TKName:'NomPayFrom'),
                                                         (SQLName:'nom_pay_too';TKName:'NomPayToo'),
                                                         (SQLName:'settle_disc';TKName:'SettleDisc'),
                                                         (SQLName:'settle_days';TKName:'SettleDays'),
                                                         (SQLName:'need_bm_up';TKName:'NeedBMUp'),
                                                         (SQLName:'ignore_bdpw';TKName:'IgnoreBDPW'),
                                                         (SQLName:'inp_pack';TKName:'InpPack'),
                                                         (SQLName:'spare32';TKName:'Spare32'),
                                                         (SQLName:'vat_code';TKName:'VATCode'),
                                                         (SQLName:'pay_terms';TKName:'PayTerms'),
                                                         (SQLName:'o_trig_date';TKName:'OTrigDate'),
                                                         (SQLName:'sta_age_int';TKName:'StaAgeInt'),
                                                         (SQLName:'quo_own_date';TKName:'QuoOwnDate'),
                                                         (SQLName:'free_ex_all';TKName:'FreeExAll'),
                                                         (SQLName:'dir_own_count';TKName:'DirOwnCount'),
                                                         (SQLName:'sta_show_os';TKName:'StaShowOS'),
                                                         (SQLName:'live_cred_s';TKName:'LiveCredS'),
                                                         (SQLName:'batch_ppy';TKName:'BatchPPY'),
                                                         (SQLName:'warn_jc';TKName:'WarnJC'),
                                                         (SQLName:'tx_late_cr';TKName:'TxLateCR'),
                                                         (SQLName:'consv_mem';TKName:'ConsvMem'),
                                                         (SQLName:'def_bank_nom';TKName:'DefBankNom'),
                                                         (SQLName:'use_def_bank';TKName:'UseDefBank'),
                                                         (SQLName:'hide_ex_logo';TKName:'HideExLogo'),
                                                         (SQLName:'amm_thread';TKName:'AMMThread'),
                                                         (SQLName:'amm_preview1';TKName:'AMMPreview1'),
                                                         (SQLName:'amm_preview2';TKName:'AMMPreview2'),
                                                         (SQLName:'ent_u_log_count';TKName:'EntULogCount'),
                                                         (SQLName:'def_src_bank_nom';TKName:'DefSRCBankNom'),
                                                         (SQLName:'sdn_own_date';TKName:'SDNOwnDate'),
                                                         (SQLName:'exisn';TKName:'EXISN'),
                                                         (SQLName:'ex_demo_ver';TKName:'ExDemoVer'),
                                                         (SQLName:'dupli_v_sec';TKName:'DupliVSec'),
                                                         (SQLName:'last_daily';TKName:'LastDaily'),
                                                         (SQLName:'user_sort';TKName:'UserSort'),
                                                         (SQLName:'user_acc';TKName:'UserAcc'),
                                                         (SQLName:'user_ref';TKName:'UserRef'),
                                                         (SQLName:'spare_bits';TKName:'SpareBits'),
                                                         (SQLName:'grace_period';TKName:'GracePeriod'),
                                                         (SQLName:'mon_wk1';TKName:'MonWk1'),
                                                         (SQLName:'audit_date';TKName:'AuditDate'),
                                                         (SQLName:'trig_date';TKName:'TrigDate'),
                                                         (SQLName:'ex_usr_sec';TKName:'ExUsrSec'),
                                                         (SQLName:'usr_log_count';TKName:'UsrLogCount'),
                                                         (SQLName:'bin_mask';TKName:'BinMask'),
                                                         (SQLName:'spare5a';TKName:'Spare5a'),
                                                         (SQLName:'spare6a';TKName:'Spare6a'),
                                                         (SQLName:'user_bank';TKName:'UserBank'),
                                                         (SQLName:'ex_sec';TKName:'ExSec'),
                                                         (SQLName:'last_exp_folio';TKName:'LastExpFolio'),
                                                         (SQLName:'detail_tel';TKName:'DetailTel'),
                                                         (SQLName:'detail_fax';TKName:'DetailFax'),
                                                         (SQLName:'user_vat_reg';TKName:'UserVATReg')
                                                        );
var
  i : integer;
  CurrentPrefix : String;
begin
  for i := 1 to NumberOfFields do
  begin
    if Trim(UpperCase(Value)) = Trim(UpperCase(FieldNames[i].TkName)) then
    begin
      if i > NumberOfFixedFields then
        CurrentPrefix := 'SYS'
      else
        CurrentPrefix := '';
      Result := GetDBColumnName('ExchqSS.dat', FieldNames[i].SQLName, CurrentPrefix);
      Break;
    end;
  end;
end;
 
function TranslateVATRecField(const Value : string) : string;
const
  NumberOfFields = 189;
  NumberOfFixedFields = 1;
  FieldNames : Array[1..NumberOfFields] of TFieldName = (
                                                         (SQLName:'id_code';TKName:'IDCode'),
                                                         (SQLName:'VATStandardCode';TKName:'VATStandardCode'),
                                                         (SQLName:'VATStandardDesc';TKName:'VATStandardDesc'),
                                                         (SQLName:'VATStandardRate';TKName:'VATStandardRate'),
                                                         (SQLName:'VATStandardSpare';TKName:'VATStandardSpare'),
                                                         (SQLName:'VATStandardInclude';TKName:'VATStandardInclude'),
                                                         (SQLName:'VATStandardSpare2';TKName:'VATStandardSpare2'),
                                                         (SQLName:'VATExemptCode';TKName:'VATExemptCode'),
                                                         (SQLName:'VATExemptDesc';TKName:'VATExemptDesc'),
                                                         (SQLName:'VATExemptRate';TKName:'VATExemptRate'),
                                                         (SQLName:'VATExemptSpare';TKName:'VATExemptSpare'),
                                                         (SQLName:'VATExemptInclude';TKName:'VATExemptInclude'),
                                                         (SQLName:'VATExemptSpare2';TKName:'VATExemptSpare2'),
                                                         (SQLName:'VATZeroCode';TKName:'VATZeroCode'),
                                                         (SQLName:'VATZeroDesc';TKName:'VATZeroDesc'),
                                                         (SQLName:'VATZeroRate';TKName:'VATZeroRate'),
                                                         (SQLName:'VATZeroSpare';TKName:'VATZeroSpare'),
                                                         (SQLName:'VATZeroInclude';TKName:'VATZeroInclude'),
                                                         (SQLName:'VATZeroSpare2';TKName:'VATZeroSpare2'),
                                                         (SQLName:'VATRate1Code';TKName:'VATRate1Code'),
                                                         (SQLName:'VATRate1Desc';TKName:'VATRate1Desc'),
                                                         (SQLName:'VATRate1Rate';TKName:'VATRate1Rate'),
                                                         (SQLName:'VATRate1Spare';TKName:'VATRate1Spare'),
                                                         (SQLName:'VATRate1Include';TKName:'VATRate1Include'),
                                                         (SQLName:'VATRate1Spare2';TKName:'VATRate1Spare2'),
                                                         (SQLName:'VATRate2Code';TKName:'VATRate2Code'),
                                                         (SQLName:'VATRate2Desc';TKName:'VATRate2Desc'),
                                                         (SQLName:'VATRate2Rate';TKName:'VATRate2Rate'),
                                                         (SQLName:'VATRate2Spare';TKName:'VATRate2Spare'),
                                                         (SQLName:'VATRate2Include';TKName:'VATRate2Include'),
                                                         (SQLName:'VATRate2Spare2';TKName:'VATRate2Spare2'),
                                                         (SQLName:'VATRate3Code';TKName:'VATRate3Code'),
                                                         (SQLName:'VATRate3Desc';TKName:'VATRate3Desc'),
                                                         (SQLName:'VATRate3Rate';TKName:'VATRate3Rate'),
                                                         (SQLName:'VATRate3Spare';TKName:'VATRate3Spare'),
                                                         (SQLName:'VATRate3Include';TKName:'VATRate3Include'),
                                                         (SQLName:'VATRate3Spare2';TKName:'VATRate3Spare2'),
                                                         (SQLName:'VATRate4Code';TKName:'VATRate4Code'),
                                                         (SQLName:'VATRate4Desc';TKName:'VATRate4Desc'),
                                                         (SQLName:'VATRate4Rate';TKName:'VATRate4Rate'),
                                                         (SQLName:'VATRate4Spare';TKName:'VATRate4Spare'),
                                                         (SQLName:'VATRate4Include';TKName:'VATRate4Include'),
                                                         (SQLName:'VATRate4Spare2';TKName:'VATRate4Spare2'),
                                                         (SQLName:'VATRate5Code';TKName:'VATRate5Code'),
                                                         (SQLName:'VATRate5Desc';TKName:'VATRate5Desc'),
                                                         (SQLName:'VATRate5Rate';TKName:'VATRate5Rate'),
                                                         (SQLName:'VATRate5Spare';TKName:'VATRate5Spare'),
                                                         (SQLName:'VATRate5Include';TKName:'VATRate5Include'),
                                                         (SQLName:'VATRate5Spare2';TKName:'VATRate5Spare2'),
                                                         (SQLName:'VATRate6Code';TKName:'VATRate6Code'),
                                                         (SQLName:'VATRate6Desc';TKName:'VATRate6Desc'),
                                                         (SQLName:'VATRate6Rate';TKName:'VATRate6Rate'),
                                                         (SQLName:'VATRate6Spare';TKName:'VATRate6Spare'),
                                                         (SQLName:'VATRate6Include';TKName:'VATRate6Include'),
                                                         (SQLName:'VATRate6Spare2';TKName:'VATRate6Spare2'),
                                                         (SQLName:'VATRate7Code';TKName:'VATRate7Code'),
                                                         (SQLName:'VATRate7Desc';TKName:'VATRate7Desc'),
                                                         (SQLName:'VATRate7Rate';TKName:'VATRate7Rate'),
                                                         (SQLName:'VATRate7Spare';TKName:'VATRate7Spare'),
                                                         (SQLName:'VATRate7Include';TKName:'VATRate7Include'),
                                                         (SQLName:'VATRate7Spare2';TKName:'VATRate7Spare2'),
                                                         (SQLName:'VATRate8Code';TKName:'VATRate8Code'),
                                                         (SQLName:'VATRate8Desc';TKName:'VATRate8Desc'),
                                                         (SQLName:'VATRate8Rate';TKName:'VATRate8Rate'),
                                                         (SQLName:'VATRate8Spare';TKName:'VATRate8Spare'),
                                                         (SQLName:'VATRate8Include';TKName:'VATRate8Include'),
                                                         (SQLName:'VATRate8Spare2';TKName:'VATRate8Spare2'),
                                                         (SQLName:'VATRate9Code';TKName:'VATRate9Code'),
                                                         (SQLName:'VATRate9Desc';TKName:'VATRate9Desc'),
                                                         (SQLName:'VATRate9Rate';TKName:'VATRate9Rate'),
                                                         (SQLName:'VATRate9Spare';TKName:'VATRate9Spare'),
                                                         (SQLName:'VATRate9Include';TKName:'VATRate9Include'),
                                                         (SQLName:'VATRate9Spare2';TKName:'VATRate9Spare2'),
                                                         (SQLName:'VATRate10Code';TKName:'VATRate10Code'),
                                                         (SQLName:'VATRate10Desc';TKName:'VATRate10Desc'),
                                                         (SQLName:'VATRate10Rate';TKName:'VATRate10Rate'),
                                                         (SQLName:'VATRate10Spare';TKName:'VATRate10Spare'),
                                                         (SQLName:'VATRate10Include';TKName:'VATRate10Include'),
                                                         (SQLName:'VATRate10Spare2';TKName:'VATRate10Spare2'),
                                                         (SQLName:'VATRate11Code';TKName:'VATRate11Code'),
                                                         (SQLName:'VATRate11Desc';TKName:'VATRate11Desc'),
                                                         (SQLName:'VATRate11Rate';TKName:'VATRate11Rate'),
                                                         (SQLName:'VATRate11Spare';TKName:'VATRate11Spare'),
                                                         (SQLName:'VATRate11Include';TKName:'VATRate11Include'),
                                                         (SQLName:'VATRate11Spare2';TKName:'VATRate11Spare2'),
                                                         (SQLName:'VATRate12Code';TKName:'VATRate12Code'),
                                                         (SQLName:'VATRate12Desc';TKName:'VATRate12Desc'),
                                                         (SQLName:'VATRate12Rate';TKName:'VATRate12Rate'),
                                                         (SQLName:'VATRate12Spare';TKName:'VATRate12Spare'),
                                                         (SQLName:'VATRate12Include';TKName:'VATRate12Include'),
                                                         (SQLName:'VATRate12Spare2';TKName:'VATRate12Spare2'),
                                                         (SQLName:'VATRate13Code';TKName:'VATRate13Code'),
                                                         (SQLName:'VATRate13Desc';TKName:'VATRate13Desc'),
                                                         (SQLName:'VATRate13Rate';TKName:'VATRate13Rate'),
                                                         (SQLName:'VATRate13Spare';TKName:'VATRate13Spare'),
                                                         (SQLName:'VATRate13Include';TKName:'VATRate13Include'),
                                                         (SQLName:'VATRate13Spare2';TKName:'VATRate13Spare2'),
                                                         (SQLName:'VATRate14Code';TKName:'VATRate14Code'),
                                                         (SQLName:'VATRate14Desc';TKName:'VATRate14Desc'),
                                                         (SQLName:'VATRate14Rate';TKName:'VATRate14Rate'),
                                                         (SQLName:'VATRate14Spare';TKName:'VATRate14Spare'),
                                                         (SQLName:'VATRate14Include';TKName:'VATRate14Include'),
                                                         (SQLName:'VATRate14Spare2';TKName:'VATRate14Spare2'),
                                                         (SQLName:'VATRate15Code';TKName:'VATRate15Code'),
                                                         (SQLName:'VATRate15Desc';TKName:'VATRate15Desc'),
                                                         (SQLName:'VATRate15Rate';TKName:'VATRate15Rate'),
                                                         (SQLName:'VATRate15Spare';TKName:'VATRate15Spare'),
                                                         (SQLName:'VATRate15Include';TKName:'VATRate15Include'),
                                                         (SQLName:'VATRate15Spare2';TKName:'VATRate15Spare2'),
                                                         (SQLName:'VATRate16Code';TKName:'VATRate16Code'),
                                                         (SQLName:'VATRate16Desc';TKName:'VATRate16Desc'),
                                                         (SQLName:'VATRate16Rate';TKName:'VATRate16Rate'),
                                                         (SQLName:'VATRate16Spare';TKName:'VATRate16Spare'),
                                                         (SQLName:'VATRate16Include';TKName:'VATRate16Include'),
                                                         (SQLName:'VATRate16Spare2';TKName:'VATRate16Spare2'),
                                                         (SQLName:'VATRate17Code';TKName:'VATRate17Code'),
                                                         (SQLName:'VATRate17Desc';TKName:'VATRate17Desc'),
                                                         (SQLName:'VATRate17Rate';TKName:'VATRate17Rate'),
                                                         (SQLName:'VATRate17Spare';TKName:'VATRate17Spare'),
                                                         (SQLName:'VATRate17Include';TKName:'VATRate17Include'),
                                                         (SQLName:'VATRate17Spare2';TKName:'VATRate17Spare2'),
                                                         (SQLName:'VATRate18Code';TKName:'VATRate18Code'),
                                                         (SQLName:'VATRate18Desc';TKName:'VATRate18Desc'),
                                                         (SQLName:'VATRate18Rate';TKName:'VATRate18Rate'),
                                                         (SQLName:'VATRate18Spare';TKName:'VATRate18Spare'),
                                                         (SQLName:'VATRate18Include';TKName:'VATRate18Include'),
                                                         (SQLName:'VATRate18Spare2';TKName:'VATRate18Spare2'),
                                                         (SQLName:'VATIAdjCode';TKName:'VATIAdjCode'),
                                                         (SQLName:'VATIAdjDesc';TKName:'VATIAdjDesc'),
                                                         (SQLName:'VATIAdjRate';TKName:'VATIAdjRate'),
                                                         (SQLName:'VATIAdjSpare';TKName:'VATIAdjSpare'),
                                                         (SQLName:'VATIAdjInclude';TKName:'VATIAdjInclude'),
                                                         (SQLName:'VATIAdjSpare2';TKName:'VATIAdjSpare2'),
                                                         (SQLName:'VATOAdjCode';TKName:'VATOAdjCode'),
                                                         (SQLName:'VATOAdjDesc';TKName:'VATOAdjDesc'),
                                                         (SQLName:'VATOAdjRate';TKName:'VATOAdjRate'),
                                                         (SQLName:'VATOAdjSpare';TKName:'VATOAdjSpare'),
                                                         (SQLName:'VATOAdjInclude';TKName:'VATOAdjInclude'),
                                                         (SQLName:'VATOAdjSpare2';TKName:'VATOAdjSpare2'),
                                                         (SQLName:'VATSpare8Code';TKName:'VATSpare8Code'),
                                                         (SQLName:'VATSpare8Desc';TKName:'VATSpare8Desc'),
                                                         (SQLName:'VATSpare8Rate';TKName:'VATSpare8Rate'),
                                                         (SQLName:'VATSpare8Spare';TKName:'VATSpare8Spare'),
                                                         (SQLName:'VATSpare8Include';TKName:'VATSpare8Include'),
                                                         (SQLName:'VATSpare8Spare2';TKName:'VATSpare8Spare2'),
                                                         (SQLName:'hide_ud_f7';TKName:'HideUDF7'),
                                                         (SQLName:'hide_ud_f8';TKName:'HideUDF8'),
                                                         (SQLName:'hide_ud_f9';TKName:'HideUDF9'),
                                                         (SQLName:'hide_ud_f10';TKName:'HideUDF10'),
                                                         (SQLName:'hide_ud_f11';TKName:'HideUDF11'),
                                                         (SQLName:'spare2';TKName:'Spare2'),
                                                         (SQLName:'vat_interval';TKName:'VATInterval'),
                                                         (SQLName:'spare3';TKName:'Spare3'),
                                                         (SQLName:'vat_scheme';TKName:'VATScheme'),
                                                         (SQLName:'olast_ec_sales_date';TKName:'OLastECSalesDate'),
                                                         (SQLName:'vat_return_date';TKName:'VATReturnDate'),
                                                         (SQLName:'last_ec_sales_date';TKName:'LastECSalesDate'),
                                                         (SQLName:'curr_period';TKName:'CurrPeriod'),
                                                         (SQLName:'udf_caption1';TKName:'UDFCaption1'),
                                                         (SQLName:'udf_caption2';TKName:'UDFCaption2'),
                                                         (SQLName:'udf_caption3';TKName:'UDFCaption3'),
                                                         (SQLName:'udf_caption4';TKName:'UDFCaption4'),
                                                         (SQLName:'udf_caption5';TKName:'UDFCaption5'),
                                                         (SQLName:'udf_caption6';TKName:'UDFCaption6'),
                                                         (SQLName:'udf_caption7';TKName:'UDFCaption7'),
                                                         (SQLName:'udf_caption8';TKName:'UDFCaption8'),
                                                         (SQLName:'udf_caption9';TKName:'UDFCaption9'),
                                                         (SQLName:'udf_caption10';TKName:'UDFCaption10'),
                                                         (SQLName:'udf_caption11';TKName:'UDFCaption11'),
                                                         (SQLName:'udf_caption12';TKName:'UDFCaption12'),
                                                         (SQLName:'udf_caption13';TKName:'UDFCaption13'),
                                                         (SQLName:'udf_caption14';TKName:'UDFCaption14'),
                                                         (SQLName:'udf_caption15';TKName:'UDFCaption15'),
                                                         (SQLName:'udf_caption16';TKName:'UDFCaption16'),
                                                         (SQLName:'udf_caption17';TKName:'UDFCaption17'),
                                                         (SQLName:'udf_caption18';TKName:'UDFCaption18'),
                                                         (SQLName:'udf_caption19';TKName:'UDFCaption19'),
                                                         (SQLName:'udf_caption20';TKName:'UDFCaption20'),
                                                         (SQLName:'udf_caption21';TKName:'UDFCaption21'),
                                                         (SQLName:'udf_caption22';TKName:'UDFCaption22'),
                                                         (SQLName:'hide_l_type0';TKName:'HideLType0'),
                                                         (SQLName:'hide_l_type1';TKName:'HideLType1'),
                                                         (SQLName:'hide_l_type2';TKName:'HideLType2'),
                                                         (SQLName:'hide_l_type3';TKName:'HideLType3'),
                                                         (SQLName:'hide_l_type4';TKName:'HideLType4'),
                                                         (SQLName:'hide_l_type5';TKName:'HideLType5'),
                                                         (SQLName:'hide_l_type6';TKName:'HideLType6'),
                                                         (SQLName:'report_prnn';TKName:'ReportPrnN'),
                                                         (SQLName:'forms_prnn';TKName:'FormsPrnN')
                                                        );
var
  i : integer;
  CurrentPrefix : String;
begin
  for i := 1 to NumberOfFields do
  begin
    if Trim(UpperCase(Value)) = Trim(UpperCase(FieldNames[i].TkName)) then
    begin
      if i > NumberOfFixedFields then
        CurrentPrefix := 'VAT'
      else
        CurrentPrefix := '';
      Result := GetDBColumnName('ExchqSS.dat', FieldNames[i].SQLName, CurrentPrefix);
      Break;
    end;
  end;
end;
 
function TranslateCurr1PTypeField(const Value : string) : string;
const
  NumberOfFields = 156;
  NumberOfFixedFields = 1;
  FieldNames : Array[1..NumberOfFields] of TFieldName = (
                                                         (SQLName:'id_code';TKName:'IDCode'),
                                                         (SQLName:'MainCurrency00ScreenSymbol';TKName:'MainCurrency00ScreenSymbol'),
                                                         (SQLName:'MainCurrency00Desc';TKName:'MainCurrency00Desc'),
                                                         (SQLName:'MainCurrency00CompanyRate';TKName:'MainCurrency00CompanyRate'),
                                                         (SQLName:'MainCurrency00DailyRate';TKName:'MainCurrency00DailyRate'),
                                                         (SQLName:'MainCurrency00PrintSymbol';TKName:'MainCurrency00PrintSymbol'),
                                                         (SQLName:'MainCurrency01ScreenSymbol';TKName:'MainCurrency01ScreenSymbol'),
                                                         (SQLName:'MainCurrency01Desc';TKName:'MainCurrency01Desc'),
                                                         (SQLName:'MainCurrency01CompanyRate';TKName:'MainCurrency01CompanyRate'),
                                                         (SQLName:'MainCurrency01DailyRate';TKName:'MainCurrency01DailyRate'),
                                                         (SQLName:'MainCurrency01PrintSymbol';TKName:'MainCurrency01PrintSymbol'),
                                                         (SQLName:'MainCurrency02ScreenSymbol';TKName:'MainCurrency02ScreenSymbol'),
                                                         (SQLName:'MainCurrency02Desc';TKName:'MainCurrency02Desc'),
                                                         (SQLName:'MainCurrency02CompanyRate';TKName:'MainCurrency02CompanyRate'),
                                                         (SQLName:'MainCurrency02DailyRate';TKName:'MainCurrency02DailyRate'),
                                                         (SQLName:'MainCurrency02PrintSymbol';TKName:'MainCurrency02PrintSymbol'),
                                                         (SQLName:'MainCurrency03ScreenSymbol';TKName:'MainCurrency03ScreenSymbol'),
                                                         (SQLName:'MainCurrency03Desc';TKName:'MainCurrency03Desc'),
                                                         (SQLName:'MainCurrency03CompanyRate';TKName:'MainCurrency03CompanyRate'),
                                                         (SQLName:'MainCurrency03DailyRate';TKName:'MainCurrency03DailyRate'),
                                                         (SQLName:'MainCurrency03PrintSymbol';TKName:'MainCurrency03PrintSymbol'),
                                                         (SQLName:'MainCurrency04ScreenSymbol';TKName:'MainCurrency04ScreenSymbol'),
                                                         (SQLName:'MainCurrency04Desc';TKName:'MainCurrency04Desc'),
                                                         (SQLName:'MainCurrency04CompanyRate';TKName:'MainCurrency04CompanyRate'),
                                                         (SQLName:'MainCurrency04DailyRate';TKName:'MainCurrency04DailyRate'),
                                                         (SQLName:'MainCurrency04PrintSymbol';TKName:'MainCurrency04PrintSymbol'),
                                                         (SQLName:'MainCurrency05ScreenSymbol';TKName:'MainCurrency05ScreenSymbol'),
                                                         (SQLName:'MainCurrency05Desc';TKName:'MainCurrency05Desc'),
                                                         (SQLName:'MainCurrency05CompanyRate';TKName:'MainCurrency05CompanyRate'),
                                                         (SQLName:'MainCurrency05DailyRate';TKName:'MainCurrency05DailyRate'),
                                                         (SQLName:'MainCurrency05PrintSymbol';TKName:'MainCurrency05PrintSymbol'),
                                                         (SQLName:'MainCurrency06ScreenSymbol';TKName:'MainCurrency06ScreenSymbol'),
                                                         (SQLName:'MainCurrency06Desc';TKName:'MainCurrency06Desc'),
                                                         (SQLName:'MainCurrency06CompanyRate';TKName:'MainCurrency06CompanyRate'),
                                                         (SQLName:'MainCurrency06DailyRate';TKName:'MainCurrency06DailyRate'),
                                                         (SQLName:'MainCurrency06PrintSymbol';TKName:'MainCurrency06PrintSymbol'),
                                                         (SQLName:'MainCurrency07ScreenSymbol';TKName:'MainCurrency07ScreenSymbol'),
                                                         (SQLName:'MainCurrency07Desc';TKName:'MainCurrency07Desc'),
                                                         (SQLName:'MainCurrency07CompanyRate';TKName:'MainCurrency07CompanyRate'),
                                                         (SQLName:'MainCurrency07DailyRate';TKName:'MainCurrency07DailyRate'),
                                                         (SQLName:'MainCurrency07PrintSymbol';TKName:'MainCurrency07PrintSymbol'),
                                                         (SQLName:'MainCurrency08ScreenSymbol';TKName:'MainCurrency08ScreenSymbol'),
                                                         (SQLName:'MainCurrency08Desc';TKName:'MainCurrency08Desc'),
                                                         (SQLName:'MainCurrency08CompanyRate';TKName:'MainCurrency08CompanyRate'),
                                                         (SQLName:'MainCurrency08DailyRate';TKName:'MainCurrency08DailyRate'),
                                                         (SQLName:'MainCurrency08PrintSymbol';TKName:'MainCurrency08PrintSymbol'),
                                                         (SQLName:'MainCurrency09ScreenSymbol';TKName:'MainCurrency09ScreenSymbol'),
                                                         (SQLName:'MainCurrency09Desc';TKName:'MainCurrency09Desc'),
                                                         (SQLName:'MainCurrency09CompanyRate';TKName:'MainCurrency09CompanyRate'),
                                                         (SQLName:'MainCurrency09DailyRate';TKName:'MainCurrency09DailyRate'),
                                                         (SQLName:'MainCurrency09PrintSymbol';TKName:'MainCurrency09PrintSymbol'),
                                                         (SQLName:'MainCurrency10ScreenSymbol';TKName:'MainCurrency10ScreenSymbol'),
                                                         (SQLName:'MainCurrency10Desc';TKName:'MainCurrency10Desc'),
                                                         (SQLName:'MainCurrency10CompanyRate';TKName:'MainCurrency10CompanyRate'),
                                                         (SQLName:'MainCurrency10DailyRate';TKName:'MainCurrency10DailyRate'),
                                                         (SQLName:'MainCurrency10PrintSymbol';TKName:'MainCurrency10PrintSymbol'),
                                                         (SQLName:'MainCurrency11ScreenSymbol';TKName:'MainCurrency11ScreenSymbol'),
                                                         (SQLName:'MainCurrency11Desc';TKName:'MainCurrency11Desc'),
                                                         (SQLName:'MainCurrency11CompanyRate';TKName:'MainCurrency11CompanyRate'),
                                                         (SQLName:'MainCurrency11DailyRate';TKName:'MainCurrency11DailyRate'),
                                                         (SQLName:'MainCurrency11PrintSymbol';TKName:'MainCurrency11PrintSymbol'),
                                                         (SQLName:'MainCurrency12ScreenSymbol';TKName:'MainCurrency12ScreenSymbol'),
                                                         (SQLName:'MainCurrency12Desc';TKName:'MainCurrency12Desc'),
                                                         (SQLName:'MainCurrency12CompanyRate';TKName:'MainCurrency12CompanyRate'),
                                                         (SQLName:'MainCurrency12DailyRate';TKName:'MainCurrency12DailyRate'),
                                                         (SQLName:'MainCurrency12PrintSymbol';TKName:'MainCurrency12PrintSymbol'),
                                                         (SQLName:'MainCurrency13ScreenSymbol';TKName:'MainCurrency13ScreenSymbol'),
                                                         (SQLName:'MainCurrency13Desc';TKName:'MainCurrency13Desc'),
                                                         (SQLName:'MainCurrency13CompanyRate';TKName:'MainCurrency13CompanyRate'),
                                                         (SQLName:'MainCurrency13DailyRate';TKName:'MainCurrency13DailyRate'),
                                                         (SQLName:'MainCurrency13PrintSymbol';TKName:'MainCurrency13PrintSymbol'),
                                                         (SQLName:'MainCurrency14ScreenSymbol';TKName:'MainCurrency14ScreenSymbol'),
                                                         (SQLName:'MainCurrency14Desc';TKName:'MainCurrency14Desc'),
                                                         (SQLName:'MainCurrency14CompanyRate';TKName:'MainCurrency14CompanyRate'),
                                                         (SQLName:'MainCurrency14DailyRate';TKName:'MainCurrency14DailyRate'),
                                                         (SQLName:'MainCurrency14PrintSymbol';TKName:'MainCurrency14PrintSymbol'),
                                                         (SQLName:'MainCurrency15ScreenSymbol';TKName:'MainCurrency15ScreenSymbol'),
                                                         (SQLName:'MainCurrency15Desc';TKName:'MainCurrency15Desc'),
                                                         (SQLName:'MainCurrency15CompanyRate';TKName:'MainCurrency15CompanyRate'),
                                                         (SQLName:'MainCurrency15DailyRate';TKName:'MainCurrency15DailyRate'),
                                                         (SQLName:'MainCurrency15PrintSymbol';TKName:'MainCurrency15PrintSymbol'),
                                                         (SQLName:'MainCurrency16ScreenSymbol';TKName:'MainCurrency16ScreenSymbol'),
                                                         (SQLName:'MainCurrency16Desc';TKName:'MainCurrency16Desc'),
                                                         (SQLName:'MainCurrency16CompanyRate';TKName:'MainCurrency16CompanyRate'),
                                                         (SQLName:'MainCurrency16DailyRate';TKName:'MainCurrency16DailyRate'),
                                                         (SQLName:'MainCurrency16PrintSymbol';TKName:'MainCurrency16PrintSymbol'),
                                                         (SQLName:'MainCurrency17ScreenSymbol';TKName:'MainCurrency17ScreenSymbol'),
                                                         (SQLName:'MainCurrency17Desc';TKName:'MainCurrency17Desc'),
                                                         (SQLName:'MainCurrency17CompanyRate';TKName:'MainCurrency17CompanyRate'),
                                                         (SQLName:'MainCurrency17DailyRate';TKName:'MainCurrency17DailyRate'),
                                                         (SQLName:'MainCurrency17PrintSymbol';TKName:'MainCurrency17PrintSymbol'),
                                                         (SQLName:'MainCurrency18ScreenSymbol';TKName:'MainCurrency18ScreenSymbol'),
                                                         (SQLName:'MainCurrency18Desc';TKName:'MainCurrency18Desc'),
                                                         (SQLName:'MainCurrency18CompanyRate';TKName:'MainCurrency18CompanyRate'),
                                                         (SQLName:'MainCurrency18DailyRate';TKName:'MainCurrency18DailyRate'),
                                                         (SQLName:'MainCurrency18PrintSymbol';TKName:'MainCurrency18PrintSymbol'),
                                                         (SQLName:'MainCurrency19ScreenSymbol';TKName:'MainCurrency19ScreenSymbol'),
                                                         (SQLName:'MainCurrency19Desc';TKName:'MainCurrency19Desc'),
                                                         (SQLName:'MainCurrency19CompanyRate';TKName:'MainCurrency19CompanyRate'),
                                                         (SQLName:'MainCurrency19DailyRate';TKName:'MainCurrency19DailyRate'),
                                                         (SQLName:'MainCurrency19PrintSymbol';TKName:'MainCurrency19PrintSymbol'),
                                                         (SQLName:'MainCurrency20ScreenSymbol';TKName:'MainCurrency20ScreenSymbol'),
                                                         (SQLName:'MainCurrency20Desc';TKName:'MainCurrency20Desc'),
                                                         (SQLName:'MainCurrency20CompanyRate';TKName:'MainCurrency20CompanyRate'),
                                                         (SQLName:'MainCurrency20DailyRate';TKName:'MainCurrency20DailyRate'),
                                                         (SQLName:'MainCurrency20PrintSymbol';TKName:'MainCurrency20PrintSymbol'),
                                                         (SQLName:'MainCurrency21ScreenSymbol';TKName:'MainCurrency21ScreenSymbol'),
                                                         (SQLName:'MainCurrency21Desc';TKName:'MainCurrency21Desc'),
                                                         (SQLName:'MainCurrency21CompanyRate';TKName:'MainCurrency21CompanyRate'),
                                                         (SQLName:'MainCurrency21DailyRate';TKName:'MainCurrency21DailyRate'),
                                                         (SQLName:'MainCurrency21PrintSymbol';TKName:'MainCurrency21PrintSymbol'),
                                                         (SQLName:'MainCurrency22ScreenSymbol';TKName:'MainCurrency22ScreenSymbol'),
                                                         (SQLName:'MainCurrency22Desc';TKName:'MainCurrency22Desc'),
                                                         (SQLName:'MainCurrency22CompanyRate';TKName:'MainCurrency22CompanyRate'),
                                                         (SQLName:'MainCurrency22DailyRate';TKName:'MainCurrency22DailyRate'),
                                                         (SQLName:'MainCurrency22PrintSymbol';TKName:'MainCurrency22PrintSymbol'),
                                                         (SQLName:'MainCurrency23ScreenSymbol';TKName:'MainCurrency23ScreenSymbol'),
                                                         (SQLName:'MainCurrency23Desc';TKName:'MainCurrency23Desc'),
                                                         (SQLName:'MainCurrency23CompanyRate';TKName:'MainCurrency23CompanyRate'),
                                                         (SQLName:'MainCurrency23DailyRate';TKName:'MainCurrency23DailyRate'),
                                                         (SQLName:'MainCurrency23PrintSymbol';TKName:'MainCurrency23PrintSymbol'),
                                                         (SQLName:'MainCurrency24ScreenSymbol';TKName:'MainCurrency24ScreenSymbol'),
                                                         (SQLName:'MainCurrency24Desc';TKName:'MainCurrency24Desc'),
                                                         (SQLName:'MainCurrency24CompanyRate';TKName:'MainCurrency24CompanyRate'),
                                                         (SQLName:'MainCurrency24DailyRate';TKName:'MainCurrency24DailyRate'),
                                                         (SQLName:'MainCurrency24PrintSymbol';TKName:'MainCurrency24PrintSymbol'),
                                                         (SQLName:'MainCurrency25ScreenSymbol';TKName:'MainCurrency25ScreenSymbol'),
                                                         (SQLName:'MainCurrency25Desc';TKName:'MainCurrency25Desc'),
                                                         (SQLName:'MainCurrency25CompanyRate';TKName:'MainCurrency25CompanyRate'),
                                                         (SQLName:'MainCurrency25DailyRate';TKName:'MainCurrency25DailyRate'),
                                                         (SQLName:'MainCurrency25PrintSymbol';TKName:'MainCurrency25PrintSymbol'),
                                                         (SQLName:'MainCurrency26ScreenSymbol';TKName:'MainCurrency26ScreenSymbol'),
                                                         (SQLName:'MainCurrency26Desc';TKName:'MainCurrency26Desc'),
                                                         (SQLName:'MainCurrency26CompanyRate';TKName:'MainCurrency26CompanyRate'),
                                                         (SQLName:'MainCurrency26DailyRate';TKName:'MainCurrency26DailyRate'),
                                                         (SQLName:'MainCurrency26PrintSymbol';TKName:'MainCurrency26PrintSymbol'),
                                                         (SQLName:'MainCurrency27ScreenSymbol';TKName:'MainCurrency27ScreenSymbol'),
                                                         (SQLName:'MainCurrency27Desc';TKName:'MainCurrency27Desc'),
                                                         (SQLName:'MainCurrency27CompanyRate';TKName:'MainCurrency27CompanyRate'),
                                                         (SQLName:'MainCurrency27DailyRate';TKName:'MainCurrency27DailyRate'),
                                                         (SQLName:'MainCurrency27PrintSymbol';TKName:'MainCurrency27PrintSymbol'),
                                                         (SQLName:'MainCurrency28ScreenSymbol';TKName:'MainCurrency28ScreenSymbol'),
                                                         (SQLName:'MainCurrency28Desc';TKName:'MainCurrency28Desc'),
                                                         (SQLName:'MainCurrency28CompanyRate';TKName:'MainCurrency28CompanyRate'),
                                                         (SQLName:'MainCurrency28DailyRate';TKName:'MainCurrency28DailyRate'),
                                                         (SQLName:'MainCurrency28PrintSymbol';TKName:'MainCurrency28PrintSymbol'),
                                                         (SQLName:'MainCurrency29ScreenSymbol';TKName:'MainCurrency29ScreenSymbol'),
                                                         (SQLName:'MainCurrency29Desc';TKName:'MainCurrency29Desc'),
                                                         (SQLName:'MainCurrency29CompanyRate';TKName:'MainCurrency29CompanyRate'),
                                                         (SQLName:'MainCurrency29DailyRate';TKName:'MainCurrency29DailyRate'),
                                                         (SQLName:'MainCurrency29PrintSymbol';TKName:'MainCurrency29PrintSymbol'),
                                                         (SQLName:'MainCurrency30ScreenSymbol';TKName:'MainCurrency30ScreenSymbol'),
                                                         (SQLName:'MainCurrency30Desc';TKName:'MainCurrency30Desc'),
                                                         (SQLName:'MainCurrency30CompanyRate';TKName:'MainCurrency30CompanyRate'),
                                                         (SQLName:'MainCurrency30DailyRate';TKName:'MainCurrency30DailyRate'),
                                                         (SQLName:'MainCurrency30PrintSymbol';TKName:'MainCurrency30PrintSymbol')
                                                        );
var
  i : integer;
  CurrentPrefix : String;
begin
  for i := 1 to NumberOfFields do
  begin
    if Trim(UpperCase(Value)) = Trim(UpperCase(FieldNames[i].TkName)) then
    begin
      if i > NumberOfFixedFields then
        CurrentPrefix := 'Cur'
      else
        CurrentPrefix := '';
      Result := GetDBColumnName('ExchqSS.dat', FieldNames[i].SQLName, CurrentPrefix);
      Break;
    end;
  end;
end;
 
function TranslateDEFRecField(const Value : string) : string;
const
  NumberOfFields = 2;
  NumberOfFixedFields = 1;
  FieldNames : Array[1..NumberOfFields] of TFieldName = (
                                                         (SQLName:'id_code';TKName:'IDCode'),
                                                         (SQLName:'names';TKName:'Names')
                                                        );
var
  i : integer;
  CurrentPrefix : String;
begin
  for i := 1 to NumberOfFields do
  begin
    if Trim(UpperCase(Value)) = Trim(UpperCase(FieldNames[i].TkName)) then
    begin
      if i > NumberOfFixedFields then
        CurrentPrefix := 'DEF'
      else
        CurrentPrefix := '';
      Result := GetDBColumnName('ExchqSS.dat', FieldNames[i].SQLName, CurrentPrefix);
      Break;
    end;
  end;
end;
 
function TranslateJobSRecField(const Value : string) : string;
const
  NumberOfFields = 49;
  NumberOfFixedFields = 1;
  FieldNames : Array[1..NumberOfFields] of TFieldName = (
                                                         (SQLName:'id_code';TKName:'IDCode'),
                                                         (SQLName:'OverheadGL';TKName:'OverheadGL'),
                                                         (SQLName:'OverheadSpare';TKName:'OverheadSpare'),
                                                         (SQLName:'ProductionGL';TKName:'ProductionGL'),
                                                         (SQLName:'ProductionSpare';TKName:'ProductionSpare'),
                                                         (SQLName:'SubContractGL';TKName:'SubContractGL'),
                                                         (SQLName:'SubContractSpare';TKName:'SubContractSpare'),
                                                         (SQLName:'SpareGL1a';TKName:'SpareGL1a'),
                                                         (SQLName:'SpareGL1b';TKName:'SpareGL1b'),
                                                         (SQLName:'SpareGL2a';TKName:'SpareGL2a'),
                                                         (SQLName:'SpareGL2b';TKName:'SpareGL2b'),
                                                         (SQLName:'SpareGL3a';TKName:'SpareGL3a'),
                                                         (SQLName:'SpareGL3b';TKName:'SpareGL3b'),
                                                         (SQLName:'gen_ppi';TKName:'GenPPI'),
                                                         (SQLName:'ppi_ac_code';TKName:'PPIAcCode'),
                                                         (SQLName:'SummDesc00';TKName:'SummDesc00'),
                                                         (SQLName:'SummDesc01';TKName:'SummDesc01'),
                                                         (SQLName:'SummDesc02';TKName:'SummDesc02'),
                                                         (SQLName:'SummDesc03';TKName:'SummDesc03'),
                                                         (SQLName:'SummDesc04';TKName:'SummDesc04'),
                                                         (SQLName:'SummDesc05';TKName:'SummDesc05'),
                                                         (SQLName:'SummDesc06';TKName:'SummDesc06'),
                                                         (SQLName:'SummDesc07';TKName:'SummDesc07'),
                                                         (SQLName:'SummDesc08';TKName:'SummDesc08'),
                                                         (SQLName:'SummDesc09';TKName:'SummDesc09'),
                                                         (SQLName:'SummDesc10';TKName:'SummDesc10'),
                                                         (SQLName:'SummDesc11';TKName:'SummDesc11'),
                                                         (SQLName:'SummDesc12';TKName:'SummDesc12'),
                                                         (SQLName:'SummDesc13';TKName:'SummDesc13'),
                                                         (SQLName:'SummDesc14';TKName:'SummDesc14'),
                                                         (SQLName:'SummDesc15';TKName:'SummDesc15'),
                                                         (SQLName:'SummDesc16';TKName:'SummDesc16'),
                                                         (SQLName:'SummDesc17';TKName:'SummDesc17'),
                                                         (SQLName:'SummDesc18';TKName:'SummDesc18'),
                                                         (SQLName:'SummDesc19';TKName:'SummDesc19'),
                                                         (SQLName:'SummDesc20';TKName:'SummDesc20'),
                                                         (SQLName:'period_bud';TKName:'PeriodBud'),
                                                         (SQLName:'jc_chk_acode1';TKName:'JCChkACode1'),
                                                         (SQLName:'jc_chk_acode2';TKName:'JCChkACode2'),
                                                         (SQLName:'jc_chk_acode3';TKName:'JCChkACode3'),
                                                         (SQLName:'jc_chk_acode4';TKName:'JCChkACode4'),
                                                         (SQLName:'jc_chk_acode5';TKName:'JCChkACode5'),
                                                         (SQLName:'jwk_mth_no';TKName:'JWKMthNo'),
                                                         (SQLName:'jtsh_nof';TKName:'JTSHNoF'),
                                                         (SQLName:'jtsh_not';TKName:'JTSHNoT'),
                                                         (SQLName:'jf_name';TKName:'JFName'),
                                                         (SQLName:'jc_commit_pin';TKName:'JCCommitPin'),
                                                         (SQLName:'ja_inv_date';TKName:'JAInvDate'),
                                                         (SQLName:'ja_delay_cert';TKName:'JADelayCert')
                                                        );
var
  i : integer;
  CurrentPrefix : String;
begin
  for i := 1 to NumberOfFields do
  begin
    if Trim(UpperCase(Value)) = Trim(UpperCase(FieldNames[i].TkName)) then
    begin
      if i > NumberOfFixedFields then
        CurrentPrefix := 'JOB'
      else
        CurrentPrefix := '';
      Result := GetDBColumnName('ExchqSS.dat', FieldNames[i].SQLName, CurrentPrefix);
      Break;
    end;
  end;
end;
 
function TranslateFormDefsTypeField(const Value : string) : string;
const
  NumberOfFields = 122;
  NumberOfFixedFields = 1;
  FieldNames : Array[1..NumberOfFields] of TFieldName = (
                                                         (SQLName:'id_code';TKName:'IDCode'),
                                                         (SQLName:'PrimaryForm001';TKName:'PrimaryForm001'),
                                                         (SQLName:'PrimaryForm002';TKName:'PrimaryForm002'),
                                                         (SQLName:'PrimaryForm003';TKName:'PrimaryForm003'),
                                                         (SQLName:'PrimaryForm004';TKName:'PrimaryForm004'),
                                                         (SQLName:'PrimaryForm005';TKName:'PrimaryForm005'),
                                                         (SQLName:'PrimaryForm006';TKName:'PrimaryForm006'),
                                                         (SQLName:'PrimaryForm007';TKName:'PrimaryForm007'),
                                                         (SQLName:'PrimaryForm008';TKName:'PrimaryForm008'),
                                                         (SQLName:'PrimaryForm009';TKName:'PrimaryForm009'),
                                                         (SQLName:'PrimaryForm010';TKName:'PrimaryForm010'),
                                                         (SQLName:'PrimaryForm011';TKName:'PrimaryForm011'),
                                                         (SQLName:'PrimaryForm012';TKName:'PrimaryForm012'),
                                                         (SQLName:'PrimaryForm013';TKName:'PrimaryForm013'),
                                                         (SQLName:'PrimaryForm014';TKName:'PrimaryForm014'),
                                                         (SQLName:'PrimaryForm015';TKName:'PrimaryForm015'),
                                                         (SQLName:'PrimaryForm016';TKName:'PrimaryForm016'),
                                                         (SQLName:'PrimaryForm017';TKName:'PrimaryForm017'),
                                                         (SQLName:'PrimaryForm018';TKName:'PrimaryForm018'),
                                                         (SQLName:'PrimaryForm019';TKName:'PrimaryForm019'),
                                                         (SQLName:'PrimaryForm020';TKName:'PrimaryForm020'),
                                                         (SQLName:'PrimaryForm021';TKName:'PrimaryForm021'),
                                                         (SQLName:'PrimaryForm022';TKName:'PrimaryForm022'),
                                                         (SQLName:'PrimaryForm023';TKName:'PrimaryForm023'),
                                                         (SQLName:'PrimaryForm024';TKName:'PrimaryForm024'),
                                                         (SQLName:'PrimaryForm025';TKName:'PrimaryForm025'),
                                                         (SQLName:'PrimaryForm026';TKName:'PrimaryForm026'),
                                                         (SQLName:'PrimaryForm027';TKName:'PrimaryForm027'),
                                                         (SQLName:'PrimaryForm028';TKName:'PrimaryForm028'),
                                                         (SQLName:'PrimaryForm029';TKName:'PrimaryForm029'),
                                                         (SQLName:'PrimaryForm030';TKName:'PrimaryForm030'),
                                                         (SQLName:'PrimaryForm031';TKName:'PrimaryForm031'),
                                                         (SQLName:'PrimaryForm032';TKName:'PrimaryForm032'),
                                                         (SQLName:'PrimaryForm033';TKName:'PrimaryForm033'),
                                                         (SQLName:'PrimaryForm034';TKName:'PrimaryForm034'),
                                                         (SQLName:'PrimaryForm035';TKName:'PrimaryForm035'),
                                                         (SQLName:'PrimaryForm036';TKName:'PrimaryForm036'),
                                                         (SQLName:'PrimaryForm037';TKName:'PrimaryForm037'),
                                                         (SQLName:'PrimaryForm038';TKName:'PrimaryForm038'),
                                                         (SQLName:'PrimaryForm039';TKName:'PrimaryForm039'),
                                                         (SQLName:'PrimaryForm040';TKName:'PrimaryForm040'),
                                                         (SQLName:'PrimaryForm041';TKName:'PrimaryForm041'),
                                                         (SQLName:'PrimaryForm042';TKName:'PrimaryForm042'),
                                                         (SQLName:'PrimaryForm043';TKName:'PrimaryForm043'),
                                                         (SQLName:'PrimaryForm044';TKName:'PrimaryForm044'),
                                                         (SQLName:'PrimaryForm045';TKName:'PrimaryForm045'),
                                                         (SQLName:'PrimaryForm046';TKName:'PrimaryForm046'),
                                                         (SQLName:'PrimaryForm047';TKName:'PrimaryForm047'),
                                                         (SQLName:'PrimaryForm048';TKName:'PrimaryForm048'),
                                                         (SQLName:'PrimaryForm049';TKName:'PrimaryForm049'),
                                                         (SQLName:'PrimaryForm050';TKName:'PrimaryForm050'),
                                                         (SQLName:'PrimaryForm051';TKName:'PrimaryForm051'),
                                                         (SQLName:'PrimaryForm052';TKName:'PrimaryForm052'),
                                                         (SQLName:'PrimaryForm053';TKName:'PrimaryForm053'),
                                                         (SQLName:'PrimaryForm054';TKName:'PrimaryForm054'),
                                                         (SQLName:'PrimaryForm055';TKName:'PrimaryForm055'),
                                                         (SQLName:'PrimaryForm056';TKName:'PrimaryForm056'),
                                                         (SQLName:'PrimaryForm057';TKName:'PrimaryForm057'),
                                                         (SQLName:'PrimaryForm058';TKName:'PrimaryForm058'),
                                                         (SQLName:'PrimaryForm059';TKName:'PrimaryForm059'),
                                                         (SQLName:'PrimaryForm060';TKName:'PrimaryForm060'),
                                                         (SQLName:'PrimaryForm061';TKName:'PrimaryForm061'),
                                                         (SQLName:'PrimaryForm062';TKName:'PrimaryForm062'),
                                                         (SQLName:'PrimaryForm063';TKName:'PrimaryForm063'),
                                                         (SQLName:'PrimaryForm064';TKName:'PrimaryForm064'),
                                                         (SQLName:'PrimaryForm065';TKName:'PrimaryForm065'),
                                                         (SQLName:'PrimaryForm066';TKName:'PrimaryForm066'),
                                                         (SQLName:'PrimaryForm067';TKName:'PrimaryForm067'),
                                                         (SQLName:'PrimaryForm068';TKName:'PrimaryForm068'),
                                                         (SQLName:'PrimaryForm069';TKName:'PrimaryForm069'),
                                                         (SQLName:'PrimaryForm070';TKName:'PrimaryForm070'),
                                                         (SQLName:'PrimaryForm071';TKName:'PrimaryForm071'),
                                                         (SQLName:'PrimaryForm072';TKName:'PrimaryForm072'),
                                                         (SQLName:'PrimaryForm073';TKName:'PrimaryForm073'),
                                                         (SQLName:'PrimaryForm074';TKName:'PrimaryForm074'),
                                                         (SQLName:'PrimaryForm075';TKName:'PrimaryForm075'),
                                                         (SQLName:'PrimaryForm076';TKName:'PrimaryForm076'),
                                                         (SQLName:'PrimaryForm077';TKName:'PrimaryForm077'),
                                                         (SQLName:'PrimaryForm078';TKName:'PrimaryForm078'),
                                                         (SQLName:'PrimaryForm079';TKName:'PrimaryForm079'),
                                                         (SQLName:'PrimaryForm080';TKName:'PrimaryForm080'),
                                                         (SQLName:'PrimaryForm081';TKName:'PrimaryForm081'),
                                                         (SQLName:'PrimaryForm082';TKName:'PrimaryForm082'),
                                                         (SQLName:'PrimaryForm083';TKName:'PrimaryForm083'),
                                                         (SQLName:'PrimaryForm084';TKName:'PrimaryForm084'),
                                                         (SQLName:'PrimaryForm085';TKName:'PrimaryForm085'),
                                                         (SQLName:'PrimaryForm086';TKName:'PrimaryForm086'),
                                                         (SQLName:'PrimaryForm087';TKName:'PrimaryForm087'),
                                                         (SQLName:'PrimaryForm088';TKName:'PrimaryForm088'),
                                                         (SQLName:'PrimaryForm089';TKName:'PrimaryForm089'),
                                                         (SQLName:'PrimaryForm090';TKName:'PrimaryForm090'),
                                                         (SQLName:'PrimaryForm091';TKName:'PrimaryForm091'),
                                                         (SQLName:'PrimaryForm092';TKName:'PrimaryForm092'),
                                                         (SQLName:'PrimaryForm093';TKName:'PrimaryForm093'),
                                                         (SQLName:'PrimaryForm094';TKName:'PrimaryForm094'),
                                                         (SQLName:'PrimaryForm095';TKName:'PrimaryForm095'),
                                                         (SQLName:'PrimaryForm096';TKName:'PrimaryForm096'),
                                                         (SQLName:'PrimaryForm097';TKName:'PrimaryForm097'),
                                                         (SQLName:'PrimaryForm098';TKName:'PrimaryForm098'),
                                                         (SQLName:'PrimaryForm099';TKName:'PrimaryForm099'),
                                                         (SQLName:'PrimaryForm100';TKName:'PrimaryForm100'),
                                                         (SQLName:'PrimaryForm101';TKName:'PrimaryForm101'),
                                                         (SQLName:'PrimaryForm102';TKName:'PrimaryForm102'),
                                                         (SQLName:'PrimaryForm103';TKName:'PrimaryForm103'),
                                                         (SQLName:'PrimaryForm104';TKName:'PrimaryForm104'),
                                                         (SQLName:'PrimaryForm105';TKName:'PrimaryForm105'),
                                                         (SQLName:'PrimaryForm106';TKName:'PrimaryForm106'),
                                                         (SQLName:'PrimaryForm107';TKName:'PrimaryForm107'),
                                                         (SQLName:'PrimaryForm108';TKName:'PrimaryForm108'),
                                                         (SQLName:'PrimaryForm109';TKName:'PrimaryForm109'),
                                                         (SQLName:'PrimaryForm110';TKName:'PrimaryForm110'),
                                                         (SQLName:'PrimaryForm111';TKName:'PrimaryForm111'),
                                                         (SQLName:'PrimaryForm112';TKName:'PrimaryForm112'),
                                                         (SQLName:'PrimaryForm113';TKName:'PrimaryForm113'),
                                                         (SQLName:'PrimaryForm114';TKName:'PrimaryForm114'),
                                                         (SQLName:'PrimaryForm115';TKName:'PrimaryForm115'),
                                                         (SQLName:'PrimaryForm116';TKName:'PrimaryForm116'),
                                                         (SQLName:'PrimaryForm117';TKName:'PrimaryForm117'),
                                                         (SQLName:'PrimaryForm118';TKName:'PrimaryForm118'),
                                                         (SQLName:'PrimaryForm119';TKName:'PrimaryForm119'),
                                                         (SQLName:'PrimaryForm120';TKName:'PrimaryForm120'),
                                                         (SQLName:'descr';TKName:'Descr')
                                                        );
var
  i : integer;
  CurrentPrefix : String;
begin
  for i := 1 to NumberOfFields do
  begin
    if Trim(UpperCase(Value)) = Trim(UpperCase(FieldNames[i].TkName)) then
    begin
      if i > NumberOfFixedFields then
        CurrentPrefix := 'FR*'
      else
        CurrentPrefix := '';
      Result := GetDBColumnName('ExchqSS.dat', FieldNames[i].SQLName, CurrentPrefix);
      Break;
    end;
  end;
end;
 
function TranslateModuleRelTypeField(const Value : string) : string;
const
  NumberOfFields = 2;
  NumberOfFixedFields = 1;
  FieldNames : Array[1..NumberOfFields] of TFieldName = (
                                                         (SQLName:'id_code';TKName:'IDCode'),
                                                         (SQLName:'module_sec';TKName:'ModuleSec')
                                                        );
var
  i : integer;
  CurrentPrefix : String;
begin
  for i := 1 to NumberOfFields do
  begin
    if Trim(UpperCase(Value)) = Trim(UpperCase(FieldNames[i].TkName)) then
    begin
      if i > NumberOfFixedFields then
        CurrentPrefix := 'MOD'
      else
        CurrentPrefix := '';
      Result := GetDBColumnName('ExchqSS.dat', FieldNames[i].SQLName, CurrentPrefix);
      Break;
    end;
  end;
end;
 
function TranslateGCur1PTypeField(const Value : string) : string;
const
  NumberOfFields = 5;
  NumberOfFixedFields = 1;
  FieldNames : Array[1..NumberOfFields] of TFieldName = (
                                                         (SQLName:'id_code';TKName:'IDCode'),
                                                         (SQLName:'GCR_tri_rates';TKName:'GCR_triRates'),
                                                         (SQLName:'GCR_tri_euro';TKName:'GCR_triEuro'),
                                                         (SQLName:'GCR_tri_invert';TKName:'GCR_triInvert'),
                                                         (SQLName:'GCR_tri_float';TKName:'GCR_triFloat')
                                                        );
var
  i : integer;
  CurrentPrefix : String;
begin
  for i := 1 to NumberOfFields do
  begin
    if Trim(UpperCase(Value)) = Trim(UpperCase(FieldNames[i].TkName)) then
    begin
      if i > NumberOfFixedFields then
        CurrentPrefix := 'GC*'
      else
        CurrentPrefix := '';
      Result := GetDBColumnName('ExchqSS.dat', FieldNames[i].SQLName, CurrentPrefix);
      Break;
    end;
  end;
end;
 
function TranslateEDI1TypeField(const Value : string) : string;
const
  NumberOfFields = 16;
  NumberOfFixedFields = 1;
  FieldNames : Array[1..NumberOfFields] of TFieldName = (
                                                         (SQLName:'id_code';TKName:'IDCode'),
                                                         (SQLName:'vedi_method';TKName:'VEDIMethod'),
                                                         (SQLName:'v_van_mode';TKName:'VVanMode'),
                                                         (SQLName:'vedifact';TKName:'VEDIFACT'),
                                                         (SQLName:'vvance_id';TKName:'VVANCEId'),
                                                         (SQLName:'vvanu_id';TKName:'VVANUId'),
                                                         (SQLName:'v_use_crlf';TKName:'VUseCRLF'),
                                                         (SQLName:'v_test_mode';TKName:'VTestMode'),
                                                         (SQLName:'v_dir_path';TKName:'VDirPAth'),
                                                         (SQLName:'v_compress';TKName:'VCompress'),
                                                         (SQLName:'vce_email';TKName:'VCEEmail'),
                                                         (SQLName:'vu_email';TKName:'VUEmail'),
                                                         (SQLName:'ve_priority';TKName:'VEPriority'),
                                                         (SQLName:'ve_subject';TKName:'VESubject'),
                                                         (SQLName:'v_send_email';TKName:'VSendEmail'),
                                                         (SQLName:'vieecslp';TKName:'VIEECSLP')
                                                        );
var
  i : integer;
  CurrentPrefix : String;
begin
  for i := 1 to NumberOfFields do
  begin
    if Trim(UpperCase(Value)) = Trim(UpperCase(FieldNames[i].TkName)) then
    begin
      if i > NumberOfFixedFields then
        CurrentPrefix := 'ED1'
      else
        CurrentPrefix := '';
      Result := GetDBColumnName('ExchqSS.dat', FieldNames[i].SQLName, CurrentPrefix);
      Break;
    end;
  end;
end;
 
function TranslateEDI2TypeField(const Value : string) : string;
const
  NumberOfFields = 13;
  NumberOfFixedFields = 1;
  FieldNames : Array[1..NumberOfFields] of TFieldName = (
                                                         (SQLName:'id_code';TKName:'IDCode'),
                                                         (SQLName:'em_name';TKName:'EmName'),
                                                         (SQLName:'em_address';TKName:'EmAddress'),
                                                         (SQLName:'em_smtp';TKName:'EmSMTP'),
                                                         (SQLName:'em_priority';TKName:'EmPriority'),
                                                         (SQLName:'em_use_mapi';TKName:'EmUseMAPI'),
                                                         (SQLName:'fx_use_mapi';TKName:'FxUseMAPI'),
                                                         (SQLName:'fax_prnn';TKName:'FaxPrnN'),
                                                         (SQLName:'email_prnn';TKName:'EmailPrnN'),
                                                         (SQLName:'fx_name';TKName:'FxName'),
                                                         (SQLName:'fx_phone';TKName:'FxPhone'),
                                                         (SQLName:'em_attch_mode';TKName:'EmAttchMode'),
                                                         (SQLName:'fax_dll_path';TKName:'FaxDLLPath')
                                                        );
var
  i : integer;
  CurrentPrefix : String;
begin
  for i := 1 to NumberOfFields do
  begin
    if Trim(UpperCase(Value)) = Trim(UpperCase(FieldNames[i].TkName)) then
    begin
      if i > NumberOfFixedFields then
        CurrentPrefix := 'ED2'
      else
        CurrentPrefix := '';
      Result := GetDBColumnName('ExchqSS.dat', FieldNames[i].SQLName, CurrentPrefix);
      Break;
    end;
  end;
end;
 
function TranslateEDI3TypeField(const Value : string) : string;
const
  NumberOfFields = 2;
  NumberOfFixedFields = 1;
  FieldNames : Array[1..NumberOfFields] of TFieldName = (
                                                         (SQLName:'id_code';TKName:'IDCode'),
                                                         (SQLName:'spare';TKName:'Spare')
                                                        );
var
  i : integer;
  CurrentPrefix : String;
begin
  for i := 1 to NumberOfFields do
  begin
    if Trim(UpperCase(Value)) = Trim(UpperCase(FieldNames[i].TkName)) then
    begin
      if i > NumberOfFixedFields then
        CurrentPrefix := 'ED3'
      else
        CurrentPrefix := '';
      Result := GetDBColumnName('ExchqSS.dat', FieldNames[i].SQLName, CurrentPrefix);
      Break;
    end;
  end;
end;
 
function TranslateCustomFTypeField(const Value : string) : string;
const
  NumberOfFields = 3;
  NumberOfFixedFields = 1;
  FieldNames : Array[1..NumberOfFields] of TFieldName = (
                                                         (SQLName:'id_code';TKName:'IDCode'),
                                                         (SQLName:'f_captions';TKName:'FCaptions'),
                                                         (SQLName:'f_hide';TKName:'FHide')
                                                        );
var
  i : integer;
  CurrentPrefix : String;
begin
  for i := 1 to NumberOfFields do
  begin
    if Trim(UpperCase(Value)) = Trim(UpperCase(FieldNames[i].TkName)) then
    begin
      if i > NumberOfFixedFields then
        CurrentPrefix := 'CT*'
      else
        CurrentPrefix := '';
      Result := GetDBColumnName('ExchqSS.dat', FieldNames[i].SQLName, CurrentPrefix);
      Break;
    end;
  end;
end;
 
function TranslateCISCRecField(const Value : string) : string;
const
  NumberOfFields = 105;
  NumberOfFixedFields = 1;
  FieldNames : Array[1..NumberOfFields] of TFieldName = (
                                                         (SQLName:'id_code';TKName:'IDCode'),
                                                         (SQLName:'CISConstructCode';TKName:'CISConstructCode'),
                                                         (SQLName:'CISConstructDesc';TKName:'CISConstructDesc'),
                                                         (SQLName:'CISConstructRate';TKName:'CISConstructRate'),
                                                         (SQLName:'CISConstructGLCode';TKName:'CISConstructGLCode'),
                                                         (SQLName:'CISConstructDepartment';TKName:'CISConstructDepartment'),
                                                         (SQLName:'CISConstructCostCentre';TKName:'CISConstructCostCentre'),
                                                         (SQLName:'CISConstructSpare';TKName:'CISConstructSpare'),
                                                         (SQLName:'CISTechnicalCode';TKName:'CISTechnicalCode'),
                                                         (SQLName:'CISTechnicalDesc';TKName:'CISTechnicalDesc'),
                                                         (SQLName:'CISTechnicalRate';TKName:'CISTechnicalRate'),
                                                         (SQLName:'CISTechnicalGLCode';TKName:'CISTechnicalGLCode'),
                                                         (SQLName:'CISTechnicalDepartment';TKName:'CISTechnicalDepartment'),
                                                         (SQLName:'CISTechnicalCostCentre';TKName:'CISTechnicalCostCentre'),
                                                         (SQLName:'CISTechnicalSpare';TKName:'CISTechnicalSpare'),
                                                         (SQLName:'CISRate1Code';TKName:'CISRate1Code'),
                                                         (SQLName:'CISRate1Desc';TKName:'CISRate1Desc'),
                                                         (SQLName:'CISRate1Rate';TKName:'CISRate1Rate'),
                                                         (SQLName:'CISRate1GLCode';TKName:'CISRate1GLCode'),
                                                         (SQLName:'CISRate1Department';TKName:'CISRate1Department'),
                                                         (SQLName:'CISRate1CostCentre';TKName:'CISRate1CostCentre'),
                                                         (SQLName:'CISRate1Spare';TKName:'CISRate1Spare'),
                                                         (SQLName:'CISRate2Code';TKName:'CISRate2Code'),
                                                         (SQLName:'CISRate2Desc';TKName:'CISRate2Desc'),
                                                         (SQLName:'CISRate2Rate';TKName:'CISRate2Rate'),
                                                         (SQLName:'CISRate2GLCode';TKName:'CISRate2GLCode'),
                                                         (SQLName:'CISRate2Department';TKName:'CISRate2Department'),
                                                         (SQLName:'CISRate2CostCentre';TKName:'CISRate2CostCentre'),
                                                         (SQLName:'CISRate2Spare';TKName:'CISRate2Spare'),
                                                         (SQLName:'CISRate3Code';TKName:'CISRate3Code'),
                                                         (SQLName:'CISRate3Desc';TKName:'CISRate3Desc'),
                                                         (SQLName:'CISRate3Rate';TKName:'CISRate3Rate'),
                                                         (SQLName:'CISRate3GLCode';TKName:'CISRate3GLCode'),
                                                         (SQLName:'CISRate3Department';TKName:'CISRate3Department'),
                                                         (SQLName:'CISRate3CostCentre';TKName:'CISRate3CostCentre'),
                                                         (SQLName:'CISRate3Spare';TKName:'CISRate3Spare'),
                                                         (SQLName:'CISRate4Code';TKName:'CISRate4Code'),
                                                         (SQLName:'CISRate4Desc';TKName:'CISRate4Desc'),
                                                         (SQLName:'CISRate4Rate';TKName:'CISRate4Rate'),
                                                         (SQLName:'CISRate4GLCode';TKName:'CISRate4GLCode'),
                                                         (SQLName:'CISRate4Department';TKName:'CISRate4Department'),
                                                         (SQLName:'CISRate4CostCentre';TKName:'CISRate4CostCentre'),
                                                         (SQLName:'CISRate4Spare';TKName:'CISRate4Spare'),
                                                         (SQLName:'CISRate5Code';TKName:'CISRate5Code'),
                                                         (SQLName:'CISRate5Desc';TKName:'CISRate5Desc'),
                                                         (SQLName:'CISRate5Rate';TKName:'CISRate5Rate'),
                                                         (SQLName:'CISRate5GLCode';TKName:'CISRate5GLCode'),
                                                         (SQLName:'CISRate5Department';TKName:'CISRate5Department'),
                                                         (SQLName:'CISRate5CostCentre';TKName:'CISRate5CostCentre'),
                                                         (SQLName:'CISRate5Spare';TKName:'CISRate5Spare'),
                                                         (SQLName:'CISRate6Code';TKName:'CISRate6Code'),
                                                         (SQLName:'CISRate6Desc';TKName:'CISRate6Desc'),
                                                         (SQLName:'CISRate6Rate';TKName:'CISRate6Rate'),
                                                         (SQLName:'CISRate6GLCode';TKName:'CISRate6GLCode'),
                                                         (SQLName:'CISRate6Department';TKName:'CISRate6Department'),
                                                         (SQLName:'CISRate6CostCentre';TKName:'CISRate6CostCentre'),
                                                         (SQLName:'CISRate6Spare';TKName:'CISRate6Spare'),
                                                         (SQLName:'CISRate7Code';TKName:'CISRate7Code'),
                                                         (SQLName:'CISRate7Desc';TKName:'CISRate7Desc'),
                                                         (SQLName:'CISRate7Rate';TKName:'CISRate7Rate'),
                                                         (SQLName:'CISRate7GLCode';TKName:'CISRate7GLCode'),
                                                         (SQLName:'CISRate7Department';TKName:'CISRate7Department'),
                                                         (SQLName:'CISRate7CostCentre';TKName:'CISRate7CostCentre'),
                                                         (SQLName:'CISRate7Spare';TKName:'CISRate7Spare'),
                                                         (SQLName:'CISRate8Code';TKName:'CISRate8Code'),
                                                         (SQLName:'CISRate8Desc';TKName:'CISRate8Desc'),
                                                         (SQLName:'CISRate8Rate';TKName:'CISRate8Rate'),
                                                         (SQLName:'CISRate8GLCode';TKName:'CISRate8GLCode'),
                                                         (SQLName:'CISRate8Department';TKName:'CISRate8Department'),
                                                         (SQLName:'CISRate8CostCentre';TKName:'CISRate8CostCentre'),
                                                         (SQLName:'CISRate8Spare';TKName:'CISRate8Spare'),
                                                         (SQLName:'CISRate9Code';TKName:'CISRate9Code'),
                                                         (SQLName:'CISRate9Desc';TKName:'CISRate9Desc'),
                                                         (SQLName:'CISRate9Rate';TKName:'CISRate9Rate'),
                                                         (SQLName:'CISRate9GLCode';TKName:'CISRate9GLCode'),
                                                         (SQLName:'CISRate9Department';TKName:'CISRate9Department'),
                                                         (SQLName:'CISRate9CostCentre';TKName:'CISRate9CostCentre'),
                                                         (SQLName:'CISRate9Spare';TKName:'CISRate9Spare'),
                                                         (SQLName:'cis_interval';TKName:'CISInterval'),
                                                         (SQLName:'cis_auto_set_pr';TKName:'CISAutoSetPr'),
                                                         (SQLName:'cisvat_code';TKName:'CISVATCode'),
                                                         (SQLName:'cis_spare3';TKName:'CISSpare3'),
                                                         (SQLName:'cis_scheme';TKName:'CISScheme'),
                                                         (SQLName:'cis_return_date';TKName:'CISReturnDate'),
                                                         (SQLName:'cis_curr_period';TKName:'CISCurrPeriod'),
                                                         (SQLName:'cis_loaded';TKName:'CISLoaded'),
                                                         (SQLName:'cis_tax_ref';TKName:'CISTaxRef'),
                                                         (SQLName:'cis_agg_mode';TKName:'CISAggMode'),
                                                         (SQLName:'cis_sort_mode';TKName:'CISSortMode'),
                                                         (SQLName:'cisv_folio';TKName:'CISVFolio'),
                                                         (SQLName:'cis_vouchers';TKName:'CISVouchers'),
                                                         (SQLName:'ivan_mode';TKName:'IVANMode'),
                                                         (SQLName:'ivanir_id';TKName:'IVANIRId'),
                                                         (SQLName:'ivanu_id';TKName:'IVANUId'),
                                                         (SQLName:'ivan_pw';TKName:'IVANPw'),
                                                         (SQLName:'iiredi_ref';TKName:'IIREDIRef'),
                                                         (SQLName:'i_use_crlf';TKName:'IUseCRLF'),
                                                         (SQLName:'i_test_mode';TKName:'ITestMode'),
                                                         (SQLName:'i_dir_path';TKName:'IDirPath'),
                                                         (SQLName:'iedi_method';TKName:'IEDIMethod'),
                                                         (SQLName:'i_send_email';TKName:'ISendEmail'),
                                                         (SQLName:'ie_priority';TKName:'IEPriority'),
                                                         (SQLName:'j_cert_no';TKName:'JCertNo'),
                                                         (SQLName:'j_cert_expiry';TKName:'JCertExpiry'),
                                                         (SQLName:'jcis_type';TKName:'JCISType')
                                                        );
var
  i : integer;
  CurrentPrefix : String;
begin
  for i := 1 to NumberOfFields do
  begin
    if Trim(UpperCase(Value)) = Trim(UpperCase(FieldNames[i].TkName)) then
    begin
      if i > NumberOfFixedFields then
        CurrentPrefix := 'CIS'
      else
        CurrentPrefix := '';
      Result := GetDBColumnName('ExchqSS.dat', FieldNames[i].SQLName, CurrentPrefix);
      Break;
    end;
  end;
end;
 
function TranslateCIS340RecField(const Value : string) : string;
const
  NumberOfFields = 15;
  NumberOfFixedFields = 1;
  FieldNames : Array[1..NumberOfFields] of TFieldName = (
                                                         (SQLName:'id_code';TKName:'IDCode'),
                                                         (SQLName:'CISCNINO';TKName:'CISCNINO'),
                                                         (SQLName:'CISCUTR';TKName:'CISCUTR'),
                                                         (SQLName:'CISACCONo';TKName:'CISACCONo'),
                                                         (SQLName:'IGWIRId';TKName:'IGWIRId'),
                                                         (SQLName:'IGWUId';TKName:'IGWUId'),
                                                         (SQLName:'IGWTO';TKName:'IGWTO'),
                                                         (SQLName:'IGWIRef';TKName:'IGWIRef'),
                                                         (SQLName:'IXMLDirPath';TKName:'IXMLDirPath'),
                                                         (SQLName:'IXTestMode';TKName:'IXTestMode'),
                                                         (SQLName:'IXConfEmp';TKName:'IXConfEmp'),
                                                         (SQLName:'IXVerSub';TKName:'IXVerSub'),
                                                         (SQLName:'IXNoPay';TKName:'IXNoPay'),
                                                         (SQLName:'IGWTR';TKName:'IGWTR'),
                                                         (SQLName:'IGSubType';TKName:'IGSubType')
                                                        );
var
  i : integer;
  CurrentPrefix : String;
begin
  for i := 1 to NumberOfFields do
  begin
    if Trim(UpperCase(Value)) = Trim(UpperCase(FieldNames[i].TkName)) then
    begin
      if i > NumberOfFixedFields then
        CurrentPrefix := 'CI2'
      else
        CurrentPrefix := '';
      Result := GetDBColumnName('ExchqSS.dat', FieldNames[i].SQLName, CurrentPrefix);
      Break;
    end;
  end;
end;

{
function TranslateCustDiscTypeField(const Value : string) : string;
const
  NumberOfFields = 16;
  NumberOfFixedFields = 5;
  FieldNames : Array[1..NumberOfFields] of TFieldName = (
                                                         (SQLName:'rec_mfix';TKName:'RecMfix'),
                                                         (SQLName:'sub_type';TKName:'SubType'),
                                                         (SQLName:'exstchk_var1';TKName:'exstchkvar1'),
                                                         (SQLName:'exstchk_var2';TKName:'exstchkvar2'),
                                                         (SQLName:'exstchk_var3';TKName:'exstchkvar3'),
                                                         (SQLName:'dc_code';TKName:'DCCode'),
                                                         (SQLName:'cust_qb_type';TKName:'adType'),
                                                         (SQLName:'cust_qb_curr';TKName:'adCurrency'),
                                                         (SQLName:'cust_qs_price';TKName:'adPrice'),
                                                         (SQLName:'cust_q_band';TKName:'adPriceBand'),
                                                         (SQLName:'cust_qdisc_p';TKName:'adDiscPercent'),
                                                         (SQLName:'cust_qdisc_a';TKName:'adDiscValue'),
                                                         (SQLName:'cust_qmumg';TKName:'adMarkupMarginPercent'),
                                                         (SQLName:'cuse_dates';TKName:'adUseEffectiveDates'),
                                                         (SQLName:'cstart_d';TKName:'adDateEffectiveFrom'),
                                                         (SQLName:'cend_d';TKName:'adDateEffectiveTo')
                                                        );
var
  i : integer;
  CurrentPrefix : String;
begin
  for i := 1 to NumberOfFields do
  begin
    if Trim(UpperCase(Value)) = Trim(UpperCase(FieldNames[i].TkName)) then
    begin
      if i > NumberOfFixedFields then
        CurrentPrefix := 'C*'
      else
        CurrentPrefix := '';
      Result := GetDBColumnName('EXSTKCHK.dat', FieldNames[i].SQLName, CurrentPrefix);
      Break;
    end;
  end;
end;
}
function TranslateCustDiscTypeField(const Value : string) : string;
const
  NumberOfFields = 16;
  NumberOfFixedFields = 5;
  FieldNames : Array[1..NumberOfFields] of TFieldName = (
                                                         (SQLName:'rec_mfix';TKName:'RecMfix'),
                                                         (SQLName:'sub_type';TKName:'SubType'),
                                                         (SQLName:'exstchk_var1';TKName:'exstchkvar1'),
                                                         (SQLName:'exstchk_var2';TKName:'exstchkvar2'),
                                                         (SQLName:'exstchk_var3';TKName:'exstchkvar3'),
                                                         (SQLName:'StockCode';TKName:'adStockCode'),
                                                         (SQLName:'DiscountType';TKName:'adType'),
                                                         (SQLName:'Currency';TKName:'adCurrency'),
                                                         (SQLName:'Price';TKName:'adPrice'),
                                                         (SQLName:'Band';TKName:'adPriceBand'),
                                                         (SQLName:'DiscP';TKName:'adDiscPercent'),
                                                         (SQLName:'DiscA';TKName:'adDiscValue'),
                                                         (SQLName:'Markup';TKName:'adMarkupMarginPercent'),
                                                         (SQLName:'UseDates';TKName:'adUseEffectiveDates'),
                                                         (SQLName:'StartDate';TKName:'adDateEffectiveFrom'),
                                                         (SQLName:'EndDate';TKName:'adDateEffectiveTo')
                                                        );
var
  i : integer;
  CurrentPrefix : String;
begin
  for i := 1 to NumberOfFields do
  begin
    if Trim(UpperCase(Value)) = Trim(UpperCase(FieldNames[i].TkName)) then
    begin
      if i > NumberOfFixedFields then
        CurrentPrefix := 'C*'
      else
        CurrentPrefix := '';
      Result := FieldNames[i].SQLName;
      Break;
    end;
  end;
end;

 
function TranslateMultiLocTypeField(const Value : string) : string;
const
  NumberOfFields = 8;
  NumberOfFixedFields = 5;
  FieldNames : Array[1..NumberOfFields] of TFieldName = (
                                                         (SQLName:'rec_mfix';TKName:'RecMfix'),
                                                         (SQLName:'sub_type';TKName:'SubType'),
                                                         (SQLName:'exstchk_var1';TKName:'exstchkvar1'),
                                                         (SQLName:'exstchk_var2';TKName:'exstchkvar2'),
                                                         (SQLName:'exstchk_var3';TKName:'exstchkvar3'),
                                                         (SQLName:'loc_tag';TKName:'LocTag'),
                                                         (SQLName:'loc_f_desc';TKName:'LocFDesc'),
                                                         (SQLName:'loc_run_no';TKName:'LocRunNo')
                                                        );
var
  i : integer;
  CurrentPrefix : String;
begin
  for i := 1 to NumberOfFields do
  begin
    if Trim(UpperCase(Value)) = Trim(UpperCase(FieldNames[i].TkName)) then
    begin
      if i > NumberOfFixedFields then
        CurrentPrefix := 'PL'
      else
        CurrentPrefix := '';
      Result := GetDBColumnName('EXSTKCHK.dat', FieldNames[i].SQLName, CurrentPrefix);
      Break;
    end;
  end;
end;
 
function TranslateFiFoTypeField(const Value : string) : string;
const
  NumberOfFields = 23;
  NumberOfFixedFields = 5;
  FieldNames : Array[1..NumberOfFields] of TFieldName = (
                                                         (SQLName:'rec_mfix';TKName:'RecMfix'),
                                                         (SQLName:'sub_type';TKName:'SubType'),
                                                         (SQLName:'exstchk_var1';TKName:'exstchkvar1'),
                                                         (SQLName:'exstchk_var2';TKName:'exstchkvar2'),
                                                         (SQLName:'exstchk_var3';TKName:'exstchkvar3'),
                                                         (SQLName:'fifo_stk_folio';TKName:'FIFOStkFolio'),
                                                         (SQLName:'doc_abs_no';TKName:'DocABSNo'),
                                                         (SQLName:'fifo_date';TKName:'FIFODate'),
                                                         (SQLName:'qty_left';TKName:'QtyLeft'),
                                                         (SQLName:'doc_ref';TKName:'DocRef'),
                                                         (SQLName:'fifo_qty';TKName:'FIFOQty'),
                                                         (SQLName:'fifo_cost';TKName:'FIFOCost'),
                                                         (SQLName:'fifo_curr';TKName:'FIFOCurr'),
                                                         (SQLName:'fifo_cust';TKName:'FIFOCust'),
                                                         (SQLName:'fifomloc';TKName:'FIFOMLoc'),
                                                         (SQLName:'fifoc_rates1';TKName:'FIFOCompanyRate'),
                                                         (SQLName:'fifoc_rates2';TKName:'FIFODailyRate'),
                                                         (SQLName:'fuse_o_rate';TKName:'FUseORate'),
                                                         (SQLName:'FIFOtri_rates';TKName:'FIFOTriRates'),
                                                         (SQLName:'FIFOtri_euro';TKName:'FIFOTriEuro'),
                                                         (SQLName:'FIFOtri_invert';TKName:'FIFOTriInvert'),
                                                         (SQLName:'FIFOtri_float';TKName:'FIFOTriFloat'),
                                                         (SQLName:'FIFOTtrispare';TKName:'FIFOTtriSpare')
                                                        );
var
  i : integer;
  CurrentPrefix : String;
begin
  for i := 1 to NumberOfFields do
  begin
    if Trim(UpperCase(Value)) = Trim(UpperCase(FieldNames[i].TkName)) then
    begin
      if i > NumberOfFixedFields then
        CurrentPrefix := 'FS'
      else
        CurrentPrefix := '';
      Result := GetDBColumnName('EXSTKCHK.dat', FieldNames[i].SQLName, CurrentPrefix);
      Break;
    end;
  end;
end;
 
function TranslateIrishVATSOPInpDefTypeField(const Value : string) : string;
const
  NumberOfFields = 6;
  NumberOfFixedFields = 5;
  FieldNames : Array[1..NumberOfFields] of TFieldName = (
                                                         (SQLName:'rec_mfix';TKName:'RecMfix'),
                                                         (SQLName:'sub_type';TKName:'SubType'),
                                                         (SQLName:'exstchk_var1';TKName:'exstchkvar1'),
                                                         (SQLName:'exstchk_var2';TKName:'exstchkvar2'),
                                                         (SQLName:'exstchk_var3';TKName:'exstchkvar3'),
                                                         (SQLName:'IrishSOPData';TKName:'IrishSOPData')
                                                        );
var
  i : integer;
  CurrentPrefix : String;
begin
  for i := 1 to NumberOfFields do
  begin
    if Trim(UpperCase(Value)) = Trim(UpperCase(FieldNames[i].TkName)) then
    begin
      if i > NumberOfFixedFields then
        CurrentPrefix := 'AB'
      else
        CurrentPrefix := '';
      Result := GetDBColumnName('EXSTKCHK.dat', FieldNames[i].SQLName, CurrentPrefix);
      Break;
    end;
  end;
end;
 
function TranslateQtyDiscTypeField(const Value : string) : string;
const
  NumberOfFields = 20;
  NumberOfFixedFields = 5;
  FieldNames : Array[1..NumberOfFields] of TFieldName = (
                                                         (SQLName:'rec_mfix';TKName:'RecMfix'),
                                                         (SQLName:'sub_type';TKName:'SubType'),
                                                         (SQLName:'exstchk_var1';TKName:'exstchkvar1'),
                                                         (SQLName:'exstchk_var2';TKName:'exstchkvar2'),
                                                         (SQLName:'exstchk_var3';TKName:'exstchkvar3'),
                                                         (SQLName:'fqb';TKName:'FQB'),
                                                         (SQLName:'tqb';TKName:'TQB'),
                                                         (SQLName:'qb_type';TKName:'QBType'),
                                                         (SQLName:'qb_curr';TKName:'QBCurr'),
                                                         (SQLName:'qs_price';TKName:'QSPrice'),
                                                         (SQLName:'q_band';TKName:'QBand'),
                                                         (SQLName:'qdisc_p';TKName:'QDiscP'),
                                                         (SQLName:'qdisc_a';TKName:'QDiscA'),
                                                         (SQLName:'qmumg';TKName:'QMUMG'),
                                                         (SQLName:'q_stk_folio';TKName:'QStkFolio'),
                                                         (SQLName:'qc_code';TKName:'QCCode'),
                                                         (SQLName:'spare1';TKName:'Spare1'),
                                                         (SQLName:'quse_dates';TKName:'QUseDates'),
                                                         (SQLName:'qstart_d';TKName:'QStartD'),
                                                         (SQLName:'qend_d';TKName:'QEndD')
                                                        );
var
  i : integer;
  CurrentPrefix : String;
begin
  for i := 1 to NumberOfFields do
  begin
    if Trim(UpperCase(Value)) = Trim(UpperCase(FieldNames[i].TkName)) then
    begin
      if i > NumberOfFixedFields then
        CurrentPrefix := 'D*'
      else
        CurrentPrefix := '';
      Result := GetDBColumnName('EXSTKCHK.dat', FieldNames[i].SQLName, CurrentPrefix);
      Break;
    end;
  end;
end;
 
function TranslateBacsSTypeField(const Value : string) : string;
const
  NumberOfFields = 29;
  NumberOfFixedFields = 5;
  FieldNames : Array[1..NumberOfFields] of TFieldName = (
                                                         (SQLName:'rec_mfix';TKName:'RecMfix'),
                                                         (SQLName:'sub_type';TKName:'SubType'),
                                                         (SQLName:'exstchk_var1';TKName:'exstchkvar1'),
                                                         (SQLName:'exstchk_var2';TKName:'exstchkvar2'),
                                                         (SQLName:'exstchk_var3';TKName:'exstchkvar3'),
                                                         (SQLName:'tag_run_no';TKName:'TagRunNo'),
                                                         (SQLName:'tag_cust_code';TKName:'TagCustCode'),
                                                         (SQLName:'total_os1';TKName:'TotalOS1'),
                                                         (SQLName:'total_os2';TKName:'TotalOS2'),
                                                         (SQLName:'total_os3';TKName:'TotalOS3'),
                                                         (SQLName:'total_os4';TKName:'TotalOS4'),
                                                         (SQLName:'total_os5';TKName:'TotalOS5'),
                                                         (SQLName:'total_tagged1';TKName:'TotalTagged1'),
                                                         (SQLName:'total_tagged2';TKName:'TotalTagged2'),
                                                         (SQLName:'total_tagged3';TKName:'TotalTagged3'),
                                                         (SQLName:'total_tagged4';TKName:'TotalTagged4'),
                                                         (SQLName:'total_tagged5';TKName:'TotalTagged5'),
                                                         (SQLName:'has_tagged1';TKName:'HasTagged1'),
                                                         (SQLName:'has_tagged2';TKName:'HasTagged2'),
                                                         (SQLName:'has_tagged3';TKName:'HasTagged3'),
                                                         (SQLName:'has_tagged4';TKName:'HasTagged4'),
                                                         (SQLName:'has_tagged5';TKName:'HasTagged5'),
                                                         (SQLName:'tag_bal';TKName:'TagBal'),
                                                         (SQLName:'sales_cust';TKName:'SalesCust'),
                                                         (SQLName:'total_ex1';TKName:'TotalEx1'),
                                                         (SQLName:'total_ex2';TKName:'TotalEx2'),
                                                         (SQLName:'total_ex3';TKName:'TotalEx3'),
                                                         (SQLName:'total_ex4';TKName:'TotalEx4'),
                                                         (SQLName:'total_ex5';TKName:'TotalEx5')
                                                        );
var
  i : integer;
  CurrentPrefix : String;
begin
  for i := 1 to NumberOfFields do
  begin
    if Trim(UpperCase(Value)) = Trim(UpperCase(FieldNames[i].TkName)) then
    begin
      if i > NumberOfFixedFields then
        CurrentPrefix := 'XS'
      else
        CurrentPrefix := '';
      Result := GetDBColumnName('EXSTKCHK.dat', FieldNames[i].SQLName, CurrentPrefix);
      Break;
    end;
  end;
end;

function TranslateSerialTypeField(const Value : string) : string;
const
  NumberOfFields = 44;
  NumberOfFixedFields = 5;
  FieldNames : Array[1..NumberOfFields] of TFieldName = (
                                                         (SQLName:'rec_mfix';TKName:'RecMfix'),
                                                         (SQLName:'sub_type';TKName:'SubType'),
                                                         (SQLName:'exstchk_var1';TKName:'exstchkvar1'),
                                                         (SQLName:'serial_no';TKName:'snSerialNo'),
                                                         (SQLName:'batch_no';TKName:'snBatchNo'),
                                                         (SQLName:'in_doc';TKName:'snInDocRef'),
                                                         (SQLName:'out_doc';TKName:'snOutDocRef'),
                                                         (SQLName:'sold';TKName:'snSold'),
                                                         (SQLName:'date_in';TKName:'snInDate'),
                                                         (SQLName:'ser_cost';TKName:'snCostPrice'),
                                                         (SQLName:'ser_sell';TKName:'snSalesPrice'),
                                                         (SQLName:'stk_folio';TKName:'StkFolio'),
                                                         (SQLName:'date_out';TKName:'snOutDate'),
                                                         (SQLName:'sold_line';TKName:'snOutDocLine'),
                                                         (SQLName:'cur_cost';TKName:'snCostPriceCurrency'),
                                                         (SQLName:'cur_sell';TKName:'snSalesPriceCurrency'),
                                                         (SQLName:'buy_line';TKName:'snInDocLine'),
                                                         (SQLName:'batch_rec';TKName:'BatchRec'),
                                                         (SQLName:'buy_qty';TKName:'snBatchQuantity'),
                                                         (SQLName:'qty_used';TKName:'snBatchQuantitySold'),
                                                         (SQLName:'batch_child';TKName:'BatchChild'),
                                                         (SQLName:'in_mloc';TKName:'snInLocation'),
                                                         (SQLName:'out_mloc';TKName:'snOutLocation'),
                                                         (SQLName:'ser_c_rates1';TKName:'SerCompanyRate'),
                                                         (SQLName:'ser_c_rates2';TKName:'SerDailyRate'),
                                                         (SQLName:'in_ord_doc';TKName:'snInOrderRef'),
                                                         (SQLName:'out_ord_doc';TKName:'snOutOrderRef'),
                                                         (SQLName:'in_ord_line';TKName:'snInOrderLine'),
                                                         (SQLName:'out_ord_line';TKName:'snOutOrderLine'),
                                                         (SQLName:'n_line_count';TKName:'NLineCount'),
                                                         (SQLName:'note_folio';TKName:'NoteFolio'),
                                                         (SQLName:'date_use_x';TKName:'DateUseX'),
                                                         (SQLName:'suse_o_rate';TKName:'SUseORate'),
                                                         (SQLName:'tri_rates';TKName:'TriRates'),
                                                         (SQLName:'tri_euro';TKName:'TriEuro'),
                                                         (SQLName:'tri_invert';TKName:'TriInvert'),
                                                         (SQLName:'tri_float';TKName:'TriFloat'),
                                                         (SQLName:'spare2';TKName:'Spare2'),
                                                         (SQLName:'child_n_folio';TKName:'ChildNFolio'),
                                                         (SQLName:'in_bin_code';TKName:'snBinCode'),
                                                         (SQLName:'return_sno';TKName:'snReturned'),
                                                         (SQLName:'batch_ret_qty';TKName:'snBatchReturnedQty'),
                                                         (SQLName:'ret_doc';TKName:'snReturnOurRef'),
                                                         (SQLName:'ret_doc_line';TKName:'snReturnLineNo')
                                                        );
var
  i : integer;
  CurrentPrefix : String;
begin
  for i := 1 to NumberOfFields do
  begin
    if Trim(UpperCase(Value)) = Trim(UpperCase(FieldNames[i].TkName)) then
    begin
      CurrentPrefix := '';
      Result := GetDBColumnName('SerialBatch.dat', FieldNames[i].SQLName, CurrentPrefix);
      Break;
    end;
  end;
end;
 
function TranslateBankMTypeField(const Value : string) : string;
const
  NumberOfFields = 21;
  NumberOfFixedFields = 5;
  FieldNames : Array[1..NumberOfFields] of TFieldName = (
                                                         (SQLName:'rec_mfix';TKName:'RecMfix'),
                                                         (SQLName:'sub_type';TKName:'SubType'),
                                                         (SQLName:'exstchk_var1';TKName:'exstchkvar1'),
                                                         (SQLName:'exstchk_var2';TKName:'exstchkvar2'),
                                                         (SQLName:'exstchk_var3';TKName:'exstchkvar3'),
                                                         (SQLName:'bank_ref';TKName:'BankRef'),
                                                         (SQLName:'bank_value';TKName:'BankValue'),
                                                         (SQLName:'match_doc';TKName:'MatchDoc'),
                                                         (SQLName:'match_folio';TKName:'MatchFolio'),
                                                         (SQLName:'match_line';TKName:'MatchLine'),
                                                         (SQLName:'bank_nom';TKName:'BankNom'),
                                                         (SQLName:'bank_cr';TKName:'BankCr'),
                                                         (SQLName:'entry_opo';TKName:'EntryOpo'),
                                                         (SQLName:'entry_date';TKName:'EntryDate'),
                                                         (SQLName:'entry_stat';TKName:'EntryStat'),
                                                         (SQLName:'use_pay_in';TKName:'UsePayIn'),
                                                         (SQLName:'match_addr';TKName:'MatchAddr'),
                                                         (SQLName:'match_run_no';TKName:'MatchRunNo'),
                                                         (SQLName:'tagged';TKName:'Tagged'),
                                                         (SQLName:'match_date';TKName:'MatchDate'),
                                                         (SQLName:'match_abs_line';TKName:'MatchABSLine')
                                                        );
var
  i : integer;
  CurrentPrefix : String;
begin
  for i := 1 to NumberOfFields do
  begin
    if Trim(UpperCase(Value)) = Trim(UpperCase(FieldNames[i].TkName)) then
    begin
      if i > NumberOfFixedFields then
        CurrentPrefix := 'ME'
      else
        CurrentPrefix := '';
      Result := GetDBColumnName('EXSTKCHK.dat', FieldNames[i].SQLName, CurrentPrefix);
      Break;
    end;
  end;
end;
 
function TranslateBtCustomTypeField(const Value : string) : string;
const
  NumberOfFields = 18;
  NumberOfFixedFields = 5;
  FieldNames : Array[1..NumberOfFields] of TFieldName = (
                                                         (SQLName:'rec_mfix';TKName:'RecMfix'),
                                                         (SQLName:'sub_type';TKName:'SubType'),
                                                         (SQLName:'exstchk_var1';TKName:'exstchkvar1'),
                                                         (SQLName:'exstchk_var2';TKName:'exstchkvar2'),
                                                         (SQLName:'exstchk_var3';TKName:'exstchkvar3'),
                                                         (SQLName:'bkg_color';TKName:'BkgColor'),
                                                         (SQLName:'font_name';TKName:'FontName'),
                                                         (SQLName:'font_size';TKName:'FontSize'),
                                                         (SQLName:'font_color';TKName:'FontColor'),
                                                         (SQLName:'font_style';TKName:'FontStyle'),
                                                         (SQLName:'font_pitch';TKName:'FontPitch'),
                                                         (SQLName:'font_height';TKName:'FontHeight'),
                                                         (SQLName:'last_col_order';TKName:'LastColOrder'),
                                                         (SQLName:'position';TKName:'Position'),
                                                         (SQLName:'comp_name';TKName:'CompName'),
                                                         (SQLName:'user_name';TKName:'UserName'),
                                                         (SQLName:'high_light';TKName:'HighLight'),
                                                         (SQLName:'high_text';TKName:'HighText')
                                                        );
var
  i : integer;
  CurrentPrefix : String;
begin
  for i := 1 to NumberOfFields do
  begin
    if Trim(UpperCase(Value)) = Trim(UpperCase(FieldNames[i].TkName)) then
    begin
      if i > NumberOfFixedFields then
        CurrentPrefix := 'UC'
      else
        CurrentPrefix := '';
      Result := GetDBColumnName('EXSTKCHK.dat', FieldNames[i].SQLName, CurrentPrefix);
      Break;
    end;
  end;
end;
 
function TranslateBtLetterLinkTypeField(const Value : string) : string;
const
  NumberOfFields = 10;
  NumberOfFixedFields = 5;
  FieldNames : Array[1..NumberOfFields] of TFieldName = (
                                                         (SQLName:'rec_mfix';TKName:'RecMfix'),
                                                         (SQLName:'sub_type';TKName:'SubType'),
                                                         (SQLName:'exstchk_var1';TKName:'exstchkvar1'),
                                                         (SQLName:'exstchk_var2';TKName:'exstchkvar2'),
                                                         (SQLName:'exstchk_var3';TKName:'exstchkvar3'),
                                                         (SQLName:'acc_code';TKName:'AccCode'),
                                                         (SQLName:'letterlinkdata1';TKName:'LetterLinkData1'),
                                                         (SQLName:'version';TKName:'Version'),
                                                         (SQLName:'letterlinkdata2';TKName:'LetterLinkdata2'),
                                                         (SQLName:'letterlinkspare';TKName:'LetterLinkSpare')
                                                        );
var
  i : integer;
  CurrentPrefix : String;
begin
  for i := 1 to NumberOfFields do
  begin
    if Trim(UpperCase(Value)) = Trim(UpperCase(FieldNames[i].TkName)) then
    begin
      if i > NumberOfFixedFields then
        CurrentPrefix := 'W*'
      else
        CurrentPrefix := '';
      Result := GetDBColumnName('EXSTKCHK.dat', FieldNames[i].SQLName, CurrentPrefix);
      Break;
    end;
  end;
end;
 
function TranslateAllocSTypeField(const Value : string) : string;
const
  NumberOfFields = 34;
  NumberOfFixedFields = 5;
  FieldNames : Array[1..NumberOfFields] of TFieldName = (
                                                         (SQLName:'rec_mfix';TKName:'RecMfix'),
                                                         (SQLName:'sub_type';TKName:'SubType'),
                                                         (SQLName:'exstchk_var1';TKName:'exstchkvar1'),
                                                         (SQLName:'exstchk_var2';TKName:'exstchkvar2'),
                                                         (SQLName:'exstchk_var3';TKName:'exstchkvar3'),
                                                         (SQLName:'ari_cust_code';TKName:'AriCustCode'),
                                                         (SQLName:'ari_cust_supp';TKName:'AriCustSupp'),
                                                         (SQLName:'ari_our_ref';TKName:'AriOurRef'),
                                                         (SQLName:'ari_old_your_ref';TKName:'AriOldYourRef'),
                                                         (SQLName:'ari_due_date';TKName:'AriDueDate'),
                                                         (SQLName:'ari_trans_date';TKName:'AriTransDate'),
                                                         (SQLName:'ari_orig_val';TKName:'AriOrigVal'),
                                                         (SQLName:'ari_orig_curr';TKName:'AriOrigCurr'),
                                                         (SQLName:'ari_base_equiv';TKName:'AriBaseEquiv'),
                                                         (SQLName:'ari_orig_settle';TKName:'AriOrigSettle'),
                                                         (SQLName:'ari_orig_oc_settle';TKName:'AriOrigOCSettle'),
                                                         (SQLName:'ari_settle';TKName:'AriSettle'),
                                                         (SQLName:'ari_cx_rate1';TKName:'AriCompanyRate'),
                                                         (SQLName:'ari_cx_rate2';TKName:'AriDailyRate'),
                                                         (SQLName:'ari_set_disc';TKName:'AriSetDisc'),
                                                         (SQLName:'ari_variance';TKName:'AriVariance'),
                                                         (SQLName:'ari_orig_set_disc';TKName:'AriOrigSetDisc'),
                                                         (SQLName:'ari_outstanding';TKName:'AriOutstanding'),
                                                         (SQLName:'ari_curr_os';TKName:'AriCurrOS'),
                                                         (SQLName:'ari_settle_own';TKName:'AriSettleOwn'),
                                                         (SQLName:'ari_base_os';TKName:'AriBaseOS'),
                                                         (SQLName:'ari_disc_or';TKName:'AriDiscOR'),
                                                         (SQLName:'ari_own_disc_or';TKName:'AriOwnDiscOR'),
                                                         (SQLName:'ari_doc_type';TKName:'AriDocType'),
                                                         (SQLName:'ari_tag_mode';TKName:'AriTagMode'),
                                                         (SQLName:'ari_reval_adj';TKName:'AriReValAdj'),
                                                         (SQLName:'ari_orig_reval_adj';TKName:'AriOrigReValAdj'),
                                                         (SQLName:'spare3';TKName:'Spare3'),
                                                         (SQLName:'ari_your_ref';TKName:'AriYourRef')
                                                        );
var
  i : integer;
  CurrentPrefix : String;
begin
  for i := 1 to NumberOfFields do
  begin
    if Trim(UpperCase(Value)) = Trim(UpperCase(FieldNames[i].TkName)) then
    begin
      if i > NumberOfFixedFields then
        CurrentPrefix := 'XA'
      else
        CurrentPrefix := '';
      Result := GetDBColumnName('EXSTKCHK.dat', FieldNames[i].SQLName, CurrentPrefix);
      Break;
    end;
  end;
end;
 
function TranslateRtLReasonTypeField(const Value : string) : string;
const
  NumberOfFields = 7;
  NumberOfFixedFields = 5;
  FieldNames : Array[1..NumberOfFields] of TFieldName = (
                                                         (SQLName:'rec_mfix';TKName:'RecMfix'),
                                                         (SQLName:'sub_type';TKName:'SubType'),
                                                         (SQLName:'exstchk_var1';TKName:'exstchkvar1'),
                                                         (SQLName:'exstchk_var2';TKName:'exstchkvar2'),
                                                         (SQLName:'exstchk_var3';TKName:'exstchkvar3'),
                                                         (SQLName:'reason_desc';TKName:'ReasonDesc'),
                                                         (SQLName:'reason_count';TKName:'ReasonCount')
                                                        );
var
  i : integer;
  CurrentPrefix : String;
begin
  for i := 1 to NumberOfFields do
  begin
    if Trim(UpperCase(Value)) = Trim(UpperCase(FieldNames[i].TkName)) then
    begin
      if i > NumberOfFixedFields then
        CurrentPrefix := 'R1'
      else
        CurrentPrefix := '';
      Result := GetDBColumnName('EXSTKCHK.dat', FieldNames[i].SQLName, CurrentPrefix);
      Break;
    end;
  end;
end;
 
function TranslateB2BInpRecField(const Value : string) : string;
const
  NumberOfFields = 38;
  NumberOfFixedFields = 5;
  FieldNames : Array[1..NumberOfFields] of TFieldName = (
                                                         (SQLName:'rec_mfix';TKName:'RecMfix'),
                                                         (SQLName:'sub_type';TKName:'SubType'),
                                                         (SQLName:'exstchk_var1';TKName:'exstchkvar1'),
                                                         (SQLName:'exstchk_var2';TKName:'exstchkvar2'),
                                                         (SQLName:'exstchk_var3';TKName:'exstchkvar3'),
                                                         (SQLName:'spare4';TKName:'Spare4'),
                                                         (SQLName:'MultiMode';TKName:'MultiMode'),
                                                         (SQLName:'ExcludeBOM';TKName:'ExcludeBOM'),
                                                         (SQLName:'UseOnOrder';TKName:'UseOnOrder'),
                                                         (SQLName:'IncludeLT';TKName:'IncludeLT'),
                                                         (SQLName:'ExcludeLT';TKName:'ExcludeLT'),
                                                         (SQLName:'QtyMode';TKName:'QtyMode'),
                                                         (SQLName:'SuppCode';TKName:'SuppCode'),
                                                         (SQLName:'LocOR';TKName:'LocOR'),
                                                         (SQLName:'AutoPick';TKName:'AutoPick'),
                                                         (SQLName:'GenOrder';TKName:'GenOrder'),
                                                         (SQLName:'PORBOMMode';TKName:'PORBOMMode'),
                                                         (SQLName:'WORBOMCode';TKName:'WORBOMCode'),
                                                         (SQLName:'WORRef';TKName:'WORRef'),
                                                         (SQLName:'LocIR';TKName:'LocIR'),
                                                         (SQLName:'BuildQty';TKName:'BuildQty'),
                                                         (SQLName:'BWOQty';TKName:'BWOQty'),
                                                         (SQLName:'LessFStk';TKName:'LessFStk'),
                                                         (SQLName:'AutoSetChild';TKName:'AutoSetChild'),
                                                         (SQLName:'ShowDoc';TKName:'ShowDoc'),
                                                         (SQLName:'CopyStkNote';TKName:'CopyStkNote'),
                                                         (SQLName:'UseDefLoc';TKName:'UseDefLoc'),
                                                         (SQLName:'UseDefCCDep';TKName:'UseDefCCDep'),
                                                         (SQLName:'WORTagNo';TKName:'WORTagNo'),
                                                         (SQLName:'DefCCDep1';TKName:'DefDepartment'),
                                                         (SQLName:'DefCCDep2';TKName:'DefCostCentre'),
                                                         (SQLName:'WCompDate';TKName:'WCompDate'),
                                                         (SQLName:'WStartDate';TKName:'WStartDate'),
                                                         (SQLName:'KeepLDates';TKName:'KeepLDates'),
                                                         (SQLName:'CopySORUDF';TKName:'CopySORUDF'),
                                                         (SQLName:'LessA2WOR';TKName:'LessA2WOR'),
                                                         (SQLName:'spare5';TKName:'Spare5'),
                                                         (SQLName:'inp_loaded';TKName:'InpLoaded')
                                                        );
var
  i : integer;
  CurrentPrefix : String;
begin
  for i := 1 to NumberOfFields do
  begin
    if Trim(UpperCase(Value)) = Trim(UpperCase(FieldNames[i].TkName)) then
    begin
      if i > NumberOfFixedFields then
        CurrentPrefix := 'A2'
      else
        CurrentPrefix := '';
      Result := GetDBColumnName('EXSTKCHK.dat', FieldNames[i].SQLName, CurrentPrefix);
      Break;
    end;
  end;
end;
 
function TranslateB2BLineRecField(const Value : string) : string;
const
  NumberOfFields = 16;
  NumberOfFixedFields = 5;
  FieldNames : Array[1..NumberOfFields] of TFieldName = (
                                                         (SQLName:'rec_mfix';TKName:'RecMfix'),
                                                         (SQLName:'sub_type';TKName:'SubType'),
                                                         (SQLName:'exstchk_var1';TKName:'exstchkvar1'),
                                                         (SQLName:'exstchk_var2';TKName:'exstchkvar2'),
                                                         (SQLName:'exstchk_var3';TKName:'exstchkvar3'),
                                                         (SQLName:'spare6';TKName:'Spare6'),
                                                         (SQLName:'OrderFolio';TKName:'OrderFolio'),
                                                         (SQLName:'OrderLineNo';TKName:'OrderLineNo'),
                                                         (SQLName:'LineSCode';TKName:'LineSCode'),
                                                         (SQLName:'DelLineAfter';TKName:'DelLineAfter'),
                                                         (SQLName:'UseKPath';TKName:'UseKPath'),
                                                         (SQLName:'OrderLinePos';TKName:'OrderLinePos'),
                                                         (SQLName:'OrderABSLine';TKName:'OrderABSLine'),
                                                         (SQLName:'OrderLineAddr';TKName:'OrderLineAddr'),
                                                         (SQLName:'spare7';TKName:'Spare7'),
                                                         (SQLName:'line_loaded';TKName:'LineLoaded')
                                                        );
var
  i : integer;
  CurrentPrefix : String;
begin
  for i := 1 to NumberOfFields do
  begin
    if Trim(UpperCase(Value)) = Trim(UpperCase(FieldNames[i].TkName)) then
    begin
      if i > NumberOfFixedFields then
        CurrentPrefix := 'AL'
      else
        CurrentPrefix := '';
      Result := GetDBColumnName('EXSTKCHK.dat', FieldNames[i].SQLName, CurrentPrefix);
      Break;
    end;
  end;
end;
 
function TranslateFaxesField(const Value : string) : string;
const
  NumberOfFields = 4;
  FieldNames : Array[1..NumberOfFields] of TFieldName = (
                                                         (SQLName:'f_prefix';TKName:'Prefix'),
                                                         (SQLName:'f_code1';TKName:'FaxesCode1'),
                                                         (SQLName:'f_code2';TKName:'FaxesCode2'),
                                                         (SQLName:'f_code3';TKName:'FaxesCode3')
                                                        );
var
  i : integer;
begin
  for i := 1 to NumberOfFields do
  begin
    if Trim(UpperCase(Value)) = Trim(UpperCase(FieldNames[i].TkName)) then
    begin
      Result := GetDBColumnName('Faxes.dat', FieldNames[i].SQLName, '');
      Break;
    end;
  end;
end;
 
function TranslateFormsField(const Value : string) : string;
const
  NumberOfFields = 2;
  FieldNames : Array[1..NumberOfFields] of TFieldName = (
                                                         (SQLName:'f_field_1';TKName:'f_field_1'),
                                                         (SQLName:'f_field_2';TKName:'f_field_2')
                                                        );
var
  i : integer;
begin
  for i := 1 to NumberOfFields do
  begin
    if Trim(UpperCase(Value)) = Trim(UpperCase(FieldNames[i].TkName)) then
    begin
      Result := GetDBColumnName('Forms.dat', FieldNames[i].SQLName, '');
      Break;
    end;
  end;
end;
 
function TranslateGroupcmpField(const Value : string) : string;
const
  NumberOfFields = 2;
  FieldNames : Array[1..NumberOfFields] of TFieldName = (
                                                         (SQLName:'f_gc_group_code';TKName:'gcGroupCode'),
                                                         (SQLName:'f_gc_company_code';TKName:'gcCompanyCode')
                                                        );
var
  i : integer;
begin
  for i := 1 to NumberOfFields do
  begin
    if Trim(UpperCase(Value)) = Trim(UpperCase(FieldNames[i].TkName)) then
    begin
      Result := GetDBColumnName('Groupcmp.dat', FieldNames[i].SQLName, '');
      Break;
    end;
  end;
end;
 
function TranslateGroupsField(const Value : string) : string;
const
  NumberOfFields = 2;
  FieldNames : Array[1..NumberOfFields] of TFieldName = (
                                                         (SQLName:'f_gr_group_code';TKName:'grGroupCode'),
                                                         (SQLName:'f_gr_group_name';TKName:'grGroupName')
                                                        );
var
  i : integer;
begin
  for i := 1 to NumberOfFields do
  begin
    if Trim(UpperCase(Value)) = Trim(UpperCase(FieldNames[i].TkName)) then
    begin
      Result := GetDBColumnName('Groups.dat', FieldNames[i].SQLName, '');
      Break;
    end;
  end;
end;
 
function TranslateGroupusrField(const Value : string) : string;
const
  NumberOfFields = 5;
  FieldNames : Array[1..NumberOfFields] of TFieldName = (
                                                         (SQLName:'f_gu_group_code';TKName:'guGroupCode'),
                                                         (SQLName:'f_gu_user_code';TKName:'guUserCode'),
                                                         (SQLName:'f_gu_user_name';TKName:'guUserName'),
                                                         (SQLName:'f_gu_password';TKName:'guPassword'),
                                                         (SQLName:'f_gu_permissions';TKName:'guPermissions')
                                                        );
var
  i : integer;
begin
  for i := 1 to NumberOfFields do
  begin
    if Trim(UpperCase(Value)) = Trim(UpperCase(FieldNames[i].TkName)) then
    begin
      Result := GetDBColumnName('Groupusr.dat', FieldNames[i].SQLName, '');
      Break;
    end;
  end;
end;
 
function TranslateHistoryField(const Value : string) : string;
const
  NumberOfFields = 18;
  FieldNames : Array[1..NumberOfFields] of TFieldName = (
                                                         (SQLName:'f_code';TKName:'hiCode'),
                                                         (SQLName:'f_ex_class';TKName:'hiExCLass'),
                                                         (SQLName:'f_cr';TKName:'hiCurrency'),
                                                         (SQLName:'f_yr';TKName:'hiYear'),
                                                         (SQLName:'f_pr';TKName:'hiPeriod'),
                                                         (SQLName:'f_sales';TKName:'hiSales'),
                                                         (SQLName:'f_purchases';TKName:'hiPurchases'),
                                                         (SQLName:'f_budget';TKName:'hiBudget'),
                                                         (SQLName:'f_cleared';TKName:'hiCleared'),
                                                         (SQLName:'f_budget2';TKName:'hiBudget2'),
                                                         (SQLName:'f_value1';TKName:'hiValue1'),
                                                         (SQLName:'f_value2';TKName:'hiValue2'),
                                                         (SQLName:'f_value3';TKName:'hiValue3'),
                                                         (SQLName:'f_spare_v1';TKName:'hiSpareV1'),
                                                         (SQLName:'f_spare_v2';TKName:'hiSpareV2'),
                                                         (SQLName:'f_spare_v3';TKName:'hiSpareV3'),
                                                         (SQLName:'f_spare_v4';TKName:'hiSpareV4'),
                                                         (SQLName:'f_spare_v5';TKName:'hiSpareV5')
                                                        );
var
  i : integer;
begin
  for i := 1 to NumberOfFields do
  begin
    if Trim(UpperCase(Value)) = Trim(UpperCase(FieldNames[i].TkName)) then
    begin
      Result := GetDBColumnName('History.dat', FieldNames[i].SQLName, '');
      Break;
    end;
  end;
end;
 
function TranslateImportjobField(const Value : string) : string;
const
  NumberOfFields = 2;
  FieldNames : Array[1..NumberOfFields] of TFieldName = (
                                                         (SQLName:'f_field_1';TKName:'f_field_1'),
                                                         (SQLName:'f_field_2';TKName:'f_field_2')
                                                        );
var
  i : integer;
begin
  for i := 1 to NumberOfFields do
  begin
    if Trim(UpperCase(Value)) = Trim(UpperCase(FieldNames[i].TkName)) then
    begin
      Result := GetDBColumnName('Importjob.dat', FieldNames[i].SQLName, '');
      Break;
    end;
  end;
end;
 
function TranslateJobBudgJBField(const Value : string) : string;
const
  NumberOfFields = 27;
  NumberOfFixedFields = 5;
  FieldNames : Array[1..NumberOfFields] of TFieldName = (
                                                         (SQLName:'rec_pfix';TKName:'RecPfix'),
                                                         (SQLName:'sub_type';TKName:'SubType'),
                                                         (SQLName:'var_code1';TKName:'var_code1'),
                                                         (SQLName:'spare';TKName:'Spare'),
                                                         (SQLName:'var_code2';TKName:'var_code2'),
                                                         (SQLName:'anal_code';TKName:'AnalCode'),
                                                         (SQLName:'hist_folio';TKName:'HistFolio'),
                                                         (SQLName:'job_code';TKName:'JobCode'),
                                                         (SQLName:'stock_code';TKName:'StockCode'),
                                                         (SQLName:'b_type';TKName:'BType'),
                                                         (SQLName:'re_charge';TKName:'ReCharge'),
                                                         (SQLName:'over_cost';TKName:'OverCost'),
                                                         (SQLName:'unit_price';TKName:'UnitPrice'),
                                                         (SQLName:'bo_qty';TKName:'BoQty'),
                                                         (SQLName:'br_qty';TKName:'BRQty'),
                                                         (SQLName:'bo_value';TKName:'BoValue'),
                                                         (SQLName:'br_value';TKName:'BRValue'),
                                                         (SQLName:'curr_budg';TKName:'CurrBudg'),
                                                         (SQLName:'pay_r_mode';TKName:'PayRMode'),
                                                         (SQLName:'curr_p_type';TKName:'CurrPType'),
                                                         (SQLName:'anal_hed';TKName:'AnalHed'),
                                                         (SQLName:'orig_valuation';TKName:'OrigValuation'),
                                                         (SQLName:'rev_valuation';TKName:'RevValuation'),
                                                         (SQLName:'jb_uplift_p';TKName:'JBUpliftP'),
                                                         (SQLName:'ja_pcnt_app';TKName:'JAPcntApp'),
                                                         (SQLName:'ja_b_basis';TKName:'JABBasis'),
                                                         (SQLName:'jbudget_curr';TKName:'JBudgetCurr')
                                                        );
var
  i : integer;
  CurrentPrefix : String;
begin
  for i := 1 to NumberOfFields do
  begin
    if Trim(UpperCase(Value)) = Trim(UpperCase(FieldNames[i].TkName)) then
    begin
      if i > NumberOfFixedFields then
        CurrentPrefix := 'JB'
      else
        CurrentPrefix := '';
      Result := GetDBColumnName('Jobctrl.dat', FieldNames[i].SQLName, CurrentPrefix);
      Break;
    end;
  end;
end;
 
function TranslateJobBudgJMField(const Value : string) : string;
const
  NumberOfFields = 27;
  NumberOfFixedFields = 5;
  FieldNames : Array[1..NumberOfFields] of TFieldName = (
                                                         (SQLName:'rec_pfix';TKName:'RecPfix'),
                                                         (SQLName:'sub_type';TKName:'SubType'),
                                                         (SQLName:'var_code1';TKName:'var_code1'),
                                                         (SQLName:'spare';TKName:'Spare'),
                                                         (SQLName:'var_code2';TKName:'var_code2'),
                                                         (SQLName:'anal_code';TKName:'AnalCode'),
                                                         (SQLName:'hist_folio';TKName:'HistFolio'),
                                                         (SQLName:'job_code';TKName:'JobCode'),
                                                         (SQLName:'stock_code';TKName:'StockCode'),
                                                         (SQLName:'b_type';TKName:'BType'),
                                                         (SQLName:'re_charge';TKName:'ReCharge'),
                                                         (SQLName:'over_cost';TKName:'OverCost'),
                                                         (SQLName:'unit_price';TKName:'UnitPrice'),
                                                         (SQLName:'bo_qty';TKName:'BoQty'),
                                                         (SQLName:'br_qty';TKName:'BRQty'),
                                                         (SQLName:'bo_value';TKName:'BoValue'),
                                                         (SQLName:'br_value';TKName:'BRValue'),
                                                         (SQLName:'curr_budg';TKName:'CurrBudg'),
                                                         (SQLName:'pay_r_mode';TKName:'PayRMode'),
                                                         (SQLName:'curr_p_type';TKName:'CurrPType'),
                                                         (SQLName:'anal_hed';TKName:'AnalHed'),
                                                         (SQLName:'orig_valuation';TKName:'OrigValuation'),
                                                         (SQLName:'rev_valuation';TKName:'RevValuation'),
                                                         (SQLName:'jb_uplift_p';TKName:'JBUpliftP'),
                                                         (SQLName:'ja_pcnt_app';TKName:'JAPcntApp'),
                                                         (SQLName:'ja_b_basis';TKName:'JABBasis'),
                                                         (SQLName:'jbudget_curr';TKName:'JBudgetCurr')
                                                        );
var
  i : integer;
  CurrentPrefix : String;
begin
  for i := 1 to NumberOfFields do
  begin
    if Trim(UpperCase(Value)) = Trim(UpperCase(FieldNames[i].TkName)) then
    begin
      if i > NumberOfFixedFields then
        CurrentPrefix := 'JM'
      else
        CurrentPrefix := '';
      Result := GetDBColumnName('Jobctrl.dat', FieldNames[i].SQLName, CurrentPrefix);
      Break;
    end;
  end;
end;
 
function TranslateJobBudgJSField(const Value : string) : string;
const
  NumberOfFields = 27;
  NumberOfFixedFields = 5;
  FieldNames : Array[1..NumberOfFields] of TFieldName = (
                                                         (SQLName:'rec_pfix';TKName:'RecPfix'),
                                                         (SQLName:'sub_type';TKName:'SubType'),
                                                         (SQLName:'var_code1';TKName:'var_code1'),
                                                         (SQLName:'spare';TKName:'Spare'),
                                                         (SQLName:'var_code2';TKName:'var_code2'),
                                                         (SQLName:'anal_code';TKName:'AnalCode'),
                                                         (SQLName:'hist_folio';TKName:'HistFolio'),
                                                         (SQLName:'job_code';TKName:'JobCode'),
                                                         (SQLName:'stock_code';TKName:'StockCode'),
                                                         (SQLName:'b_type';TKName:'BType'),
                                                         (SQLName:'re_charge';TKName:'ReCharge'),
                                                         (SQLName:'over_cost';TKName:'OverCost'),
                                                         (SQLName:'unit_price';TKName:'UnitPrice'),
                                                         (SQLName:'bo_qty';TKName:'BoQty'),
                                                         (SQLName:'br_qty';TKName:'BRQty'),
                                                         (SQLName:'bo_value';TKName:'BoValue'),
                                                         (SQLName:'br_value';TKName:'BRValue'),
                                                         (SQLName:'curr_budg';TKName:'CurrBudg'),
                                                         (SQLName:'pay_r_mode';TKName:'PayRMode'),
                                                         (SQLName:'curr_p_type';TKName:'CurrPType'),
                                                         (SQLName:'anal_hed';TKName:'AnalHed'),
                                                         (SQLName:'orig_valuation';TKName:'OrigValuation'),
                                                         (SQLName:'rev_valuation';TKName:'RevValuation'),
                                                         (SQLName:'jb_uplift_p';TKName:'JBUpliftP'),
                                                         (SQLName:'ja_pcnt_app';TKName:'JAPcntApp'),
                                                         (SQLName:'ja_b_basis';TKName:'JABBasis'),
                                                         (SQLName:'jbudget_curr';TKName:'JBudgetCurr')
                                                        );
var
  i : integer;
  CurrentPrefix : String;
begin
  for i := 1 to NumberOfFields do
  begin
    if Trim(UpperCase(Value)) = Trim(UpperCase(FieldNames[i].TkName)) then
    begin
      if i > NumberOfFixedFields then
        CurrentPrefix := 'JS'
      else
        CurrentPrefix := '';
      Result := GetDBColumnName('Jobctrl.dat', FieldNames[i].SQLName, CurrentPrefix);
      Break;
    end;
  end;
end;
 
function TranslateEmplPayJEField(const Value : string) : string;
const
  NumberOfFields = 15;
  NumberOfFixedFields = 5;
  FieldNames : Array[1..NumberOfFields] of TFieldName = (
                                                         (SQLName:'rec_pfix';TKName:'RecPfix'),
                                                         (SQLName:'sub_type';TKName:'SubType'),
                                                         (SQLName:'var_code1';TKName:'var_code1'),
                                                         (SQLName:'spare';TKName:'Spare'),
                                                         (SQLName:'var_code2';TKName:'var_code2'),
                                                         (SQLName:'e_anal_code';TKName:'EAnalCode'),
                                                         (SQLName:'emp_code';TKName:'EmpCode'),
                                                         (SQLName:'e_stock_code';TKName:'EStockCode'),
                                                         (SQLName:'pay_r_desc';TKName:'PayRDesc'),
                                                         (SQLName:'cost';TKName:'Cost'),
                                                         (SQLName:'charge_out';TKName:'ChargeOut'),
                                                         (SQLName:'cost_curr';TKName:'CostCurr'),
                                                         (SQLName:'charge_curr';TKName:'ChargeCurr'),
                                                         (SQLName:'pay_r_fact';TKName:'PayRFact'),
                                                         (SQLName:'pay_r_rate';TKName:'PayRRate')
                                                        );
var
  i : integer;
  CurrentPrefix : String;
begin
  for i := 1 to NumberOfFields do
  begin
    if Trim(UpperCase(Value)) = Trim(UpperCase(FieldNames[i].TkName)) then
    begin
      if i > NumberOfFixedFields then
        CurrentPrefix := 'JE'
      else
        CurrentPrefix := '';
      Result := GetDBColumnName('Jobctrl.dat', FieldNames[i].SQLName, CurrentPrefix);
      Break;
    end;
  end;
end;
 
function TranslateEmplPayJRField(const Value : string) : string;
const
  NumberOfFields = 15;
  NumberOfFixedFields = 5;
  FieldNames : Array[1..NumberOfFields] of TFieldName = (
                                                         (SQLName:'rec_pfix';TKName:'RecPfix'),
                                                         (SQLName:'sub_type';TKName:'SubType'),
                                                         (SQLName:'var_code1';TKName:'var_code1'),
                                                         (SQLName:'spare';TKName:'Spare'),
                                                         (SQLName:'var_code2';TKName:'var_code2'),
                                                         (SQLName:'e_anal_code';TKName:'EAnalCode'),
                                                         (SQLName:'emp_code';TKName:'EmpCode'),
                                                         (SQLName:'e_stock_code';TKName:'EStockCode'),
                                                         (SQLName:'pay_r_desc';TKName:'PayRDesc'),
                                                         (SQLName:'cost';TKName:'Cost'),
                                                         (SQLName:'charge_out';TKName:'ChargeOut'),
                                                         (SQLName:'cost_curr';TKName:'CostCurr'),
                                                         (SQLName:'charge_curr';TKName:'ChargeCurr'),
                                                         (SQLName:'pay_r_fact';TKName:'PayRFact'),
                                                         (SQLName:'pay_r_rate';TKName:'PayRRate')
                                                        );
var
  i : integer;
  CurrentPrefix : String;
begin
  for i := 1 to NumberOfFields do
  begin
    if Trim(UpperCase(Value)) = Trim(UpperCase(FieldNames[i].TkName)) then
    begin
      if i > NumberOfFixedFields then
        CurrentPrefix := 'JR'
      else
        CurrentPrefix := '';
      Result := GetDBColumnName('Jobctrl.dat', FieldNames[i].SQLName, CurrentPrefix);
      Break;
    end;
  end;
end;
 
function TranslateJobActualField(const Value : string) : string;
const
  NumberOfFields = 48;
  NumberOfFixedFields = 12;
  FieldNames : Array[1..NumberOfFields] of TFieldName = (
                                                         (SQLName:'rec_pfix';TKName:'RecPfix'),
                                                         (SQLName:'sub_type';TKName:'SubType'),
                                                         (SQLName:'var_code1';TKName:'var_code1'),
                                                         (SQLName:'var_code2';TKName:'var_code2'),
                                                         (SQLName:'var_code3';TKName:'var_code3'),
                                                         (SQLName:'var_code4';TKName:'var_code4'),
                                                         (SQLName:'var_code5';TKName:'var_code5'),
                                                         (SQLName:'var_code6';TKName:'var_code6'),
                                                         (SQLName:'var_code7';TKName:'var_code7'),
                                                         (SQLName:'var_code8';TKName:'var_code8'),
                                                         (SQLName:'var_code9';TKName:'var_code9'),
                                                         (SQLName:'var_code10';TKName:'var_code10'),
                                                         (SQLName:'posted';TKName:'Posted'),
                                                         (SQLName:'line_folio';TKName:'LineFolio'),
                                                         (SQLName:'line_no';TKName:'LineNUmber'),
                                                         (SQLName:'line_o_ref';TKName:'LineORef'),
                                                         (SQLName:'job_code';TKName:'JobCode'),
                                                         (SQLName:'stock_code';TKName:'StockCode'),
                                                         (SQLName:'j_date';TKName:'JDate'),
                                                         (SQLName:'qty';TKName:'Qty'),
                                                         (SQLName:'cost';TKName:'Cost'),
                                                         (SQLName:'charge';TKName:'Charge'),
                                                         (SQLName:'invoiced';TKName:'Invoiced'),
                                                         (SQLName:'inv_ref';TKName:'InvRef'),
                                                         (SQLName:'empl_code';TKName:'EmplCode'),
                                                         (SQLName:'ja_type';TKName:'JAType'),
                                                         (SQLName:'posted_run';TKName:'PostedRun'),
                                                         (SQLName:'reverse';TKName:'Reverse'),
                                                         (SQLName:'recon_ts';TKName:'ReconTS'),
                                                         (SQLName:'reversed';TKName:'Reversed'),
                                                         (SQLName:'jddt';TKName:'JDDT'),
                                                         (SQLName:'curr_charge';TKName:'CurrCharge'),
                                                         (SQLName:'act_c_code';TKName:'ActCCode'),
                                                         (SQLName:'hold_flg';TKName:'HoldFlg'),
                                                         (SQLName:'post2_stk';TKName:'Post2Stk'),
                                                         (SQLName:'pc_rates1';TKName:'PCRates1'),
                                                         (SQLName:'pc_rates2';TKName:'PCRates2'),
                                                         (SQLName:'tagged';TKName:'Tagged'),
                                                         (SQLName:'orig_n_code';TKName:'OrigNCode'),
                                                         (SQLName:'j_use_o_rate';TKName:'JUseORate'),
                                                         (SQLName:'PC_tri_rates';TKName:'PCTriRates'),
                                                         (SQLName:'PC_tri_euro';TKName:'PCTriEuro'),
                                                         (SQLName:'PC_tri_invert';TKName:'PCTriInvert'),
                                                         (SQLName:'PC_tri_float';TKName:'PCTriFloat'),
                                                         (SQLName:'PC_tri_spare';TKName:'PC_tri_Spare'),
                                                         (SQLName:'j_price_mulx';TKName:'JPriceMulX'),
                                                         (SQLName:'uplift_total';TKName:'UpliftTotal'),
                                                         (SQLName:'uplift_gl';TKName:'UpliftGL')
                                                        );
var
  i : integer;
  CurrentPrefix : String;
begin
  for i := 1 to NumberOfFields do
  begin
    if Trim(UpperCase(Value)) = Trim(UpperCase(FieldNames[i].TkName)) then
    begin
      if i > NumberOfFixedFields then
        CurrentPrefix := 'JE'
      else
        CurrentPrefix := '';
      Result := GetDBColumnName('JobDet.dat', FieldNames[i].SQLName, CurrentPrefix);
      Break;
    end;
  end;
end;
 
function TranslateJobRetenField(const Value : string) : string;
const
  NumberOfFields = 31;
  NumberOfFixedFields = 12;
  FieldNames : Array[1..NumberOfFields] of TFieldName = (
                                                         (SQLName:'rec_pfix';TKName:'RecPfix'),
                                                         (SQLName:'sub_type';TKName:'SubType'),
                                                         (SQLName:'var_code1';TKName:'var_code1'),
                                                         (SQLName:'var_code2';TKName:'var_code2'),
                                                         (SQLName:'var_code3';TKName:'var_code3'),
                                                         (SQLName:'var_code4';TKName:'var_code4'),
                                                         (SQLName:'var_code5';TKName:'var_code5'),
                                                         (SQLName:'var_code6';TKName:'var_code6'),
                                                         (SQLName:'var_code7';TKName:'var_code7'),
                                                         (SQLName:'var_code8';TKName:'var_code8'),
                                                         (SQLName:'var_code9';TKName:'var_code9'),
                                                         (SQLName:'var_code10';TKName:'var_code10'),
                                                         (SQLName:'posted';TKName:'Posted'),
                                                         (SQLName:'ret_disc';TKName:'RetDisc'),
                                                         (SQLName:'ret_curr';TKName:'RetCurr'),
                                                         (SQLName:'ret_value';TKName:'RetValue'),
                                                         (SQLName:'job_code';TKName:'JobCode'),
                                                         (SQLName:'ret_cr_doc';TKName:'RetCrDoc'),
                                                         (SQLName:'ret_date';TKName:'RetDate'),
                                                         (SQLName:'ret_doc';TKName:'RetDoc'),
                                                         (SQLName:'invoiced';TKName:'Invoiced'),
                                                         (SQLName:'ret_cust_code';TKName:'RetCustCode'),
                                                         (SQLName:'orig_date';TKName:'OrigDate'),
                                                         (SQLName:'ret_cc_dep1';TKName:'RetDepartment'),
                                                         (SQLName:'ret_cc_dep2';TKName:'RetCostCentre'),
                                                         (SQLName:'acc_type';TKName:'AccType'),
                                                         (SQLName:'def_vat_code';TKName:'DefVATCode'),
                                                         (SQLName:'ret_cis_tax';TKName:'RetCISTax'),
                                                         (SQLName:'ret_cis_gross';TKName:'RetCISGross'),
                                                         (SQLName:'ret_cis_empl';TKName:'RetCISEmpl'),
                                                         (SQLName:'ret_app_mode';TKName:'RetAppMode')
                                                        );
var
  i : integer;
  CurrentPrefix : String;
begin
  for i := 1 to NumberOfFields do
  begin
    if Trim(UpperCase(Value)) = Trim(UpperCase(FieldNames[i].TkName)) then
    begin
      if i > NumberOfFixedFields then
        CurrentPrefix := 'JR'
      else
        CurrentPrefix := '';
      Result := GetDBColumnName('JobDet.dat', FieldNames[i].SQLName, CurrentPrefix);
      Break;
    end;
  end;
end;
 
function TranslateJobCISVField(const Value : string) : string;
const
  NumberOfFields = 31;
  NumberOfFixedFields = 12;
  FieldNames : Array[1..NumberOfFields] of TFieldName = (
                                                         (SQLName:'rec_pfix';TKName:'RecPfix'),
                                                         (SQLName:'sub_type';TKName:'SubType'),
                                                         (SQLName:'var_code1';TKName:'var_code1'),
                                                         (SQLName:'var_code2';TKName:'var_code2'),
                                                         (SQLName:'var_code3';TKName:'var_code3'),
                                                         (SQLName:'var_code4';TKName:'var_code4'),
                                                         (SQLName:'var_code5';TKName:'var_code5'),
                                                         (SQLName:'var_code6';TKName:'var_code6'),
                                                         (SQLName:'var_code7';TKName:'var_code7'),
                                                         (SQLName:'var_code8';TKName:'var_code8'),
                                                         (SQLName:'var_code9';TKName:'var_code9'),
                                                         (SQLName:'var_code10';TKName:'var_code10'),
                                                         (SQLName:'spare3';TKName:'Spare3'),
                                                         (SQLName:'cisv_gross_total';TKName:'CISvGrossTotal'),
                                                         (SQLName:'cisv_manual_tax';TKName:'CISvManualTax'),
                                                         (SQLName:'cisv_auto_total_tax';TKName:'CISvAutoTotalTax'),
                                                         (SQLName:'cis_taxable_total';TKName:'CISTaxableTotal'),
                                                         (SQLName:'cisc_type';TKName:'CISCType'),
                                                         (SQLName:'cis_curr';TKName:'CISCurr'),
                                                         (SQLName:'spare1';TKName:'Spare1'),
                                                         (SQLName:'cisv_nline_count';TKName:'CISvNlineCount'),
                                                         (SQLName:'cis_addr1';TKName:'CISAddr1'),
                                                         (SQLName:'cis_addr2';TKName:'CISAddr2'),
                                                         (SQLName:'cis_addr3';TKName:'CISAddr3'),
                                                         (SQLName:'cis_addr4';TKName:'CISAddr4'),
                                                         (SQLName:'cis_addr5';TKName:'CISAddr5'),
                                                         (SQLName:'cis_behalf';TKName:'CISBehalf'),
                                                         (SQLName:'cis_correct';TKName:'CISCorrect'),
                                                         (SQLName:'cisv_tax_due';TKName:'CISvTaxDue'),
                                                         (SQLName:'cis_verno';TKName:'CISVerNo'),
                                                         (SQLName:'cis_htax';TKName:'CISHTax')
                                                        );
var
  i : integer;
  CurrentPrefix : String;
begin
  for i := 1 to NumberOfFields do
  begin
    if Trim(UpperCase(Value)) = Trim(UpperCase(FieldNames[i].TkName)) then
    begin
      if i > NumberOfFixedFields then
        CurrentPrefix := 'TS'
      else
        CurrentPrefix := '';
      Result := GetDBColumnName('JobDet.dat', FieldNames[i].SQLName, CurrentPrefix);
      Break;
    end;
  end;
end;
 
function TranslateJobheadField(const Value : string) : string;
const
  NumberOfFields = 37;
  FieldNames : Array[1..NumberOfFields] of TFieldName = (
                                                         (SQLName:'job_code';TKName:'jrCode'),
                                                         (SQLName:'job_desc';TKName:'jrDesc'),
                                                         (SQLName:'job_folio';TKName:'jrFolio'),
                                                         (SQLName:'cust_code';TKName:'jrAcCode'),
                                                         (SQLName:'job_cat';TKName:'jrParent'),
                                                         (SQLName:'job_alt_code';TKName:'jrAltCode'),
                                                         (SQLName:'completed';TKName:'jrCompleted'),
                                                         (SQLName:'contact';TKName:'jrContact'),
                                                         (SQLName:'job_man';TKName:'jrManager'),
                                                         (SQLName:'charge_type';TKName:'jrChargeType'),
                                                         (SQLName:'spare';TKName:'Spare'),
                                                         (SQLName:'quote_price';TKName:'jrQuotePrice'),
                                                         (SQLName:'curr_price';TKName:'jrQuotePriceCurr'),
                                                         (SQLName:'start_date';TKName:'jrStartDate'),
                                                         (SQLName:'end_date';TKName:'jrEndDate'),
                                                         (SQLName:'rev_e_date';TKName:'jrRevisedEndDate'),
                                                         (SQLName:'sor_ref';TKName:'jrSORNumber'),
                                                         (SQLName:'n_line_count';TKName:'NLineCount'),
                                                         (SQLName:'a_line_count';TKName:'ALineCount'),
                                                         (SQLName:'spare3';TKName:'Spare3'),
                                                         (SQLName:'vat_code';TKName:'jrVATCode'),
                                                         (SQLName:'cc_dep_type1';TKName:'jrDepartment'),
                                                         (SQLName:'cc_dep_type2';TKName:'jrCostCentre'),
                                                         (SQLName:'job_anal';TKName:'jrJobType'),
                                                         (SQLName:'job_type';TKName:'jrType'),
                                                         (SQLName:'job_stat';TKName:'jrStatus'),
                                                         (SQLName:'user_def1';TKName:'jrUserField1'),
                                                         (SQLName:'user_def2';TKName:'jrUserField2'),
                                                         (SQLName:'user_def3';TKName:'jrUserField3'),
                                                         (SQLName:'user_def4';TKName:'jrUserField4'),
                                                         (SQLName:'def_ret_curr';TKName:'DefRetCurr'),
                                                         (SQLName:'jpt_our_ref';TKName:'JPTOurRef'),
                                                         (SQLName:'jst_our_ref';TKName:'JSTOurRef'),
                                                         (SQLName:'jqs_code';TKName:'JQSCode'),
                                                         (SQLName:'job_anonymised';TKName:'jrAnonymised'),
                                                         (SQLName:'job_anonymised_date';TKName:'jrAnonymisedDate'),
                                                         (SQLName:'job_anonymised_time';TKName:'jrAnonymisedTime')
                                                        );
var
  i : integer;
begin
  for i := 1 to NumberOfFields do
  begin
    if Trim(UpperCase(Value)) = Trim(UpperCase(FieldNames[i].TkName)) then
    begin
      Result := GetDBColumnName('Jobhead.dat', FieldNames[i].SQLName, '');
      Break;
    end;
  end;
end;
 
function TranslateEmplRecField(const Value : string) : string;
const
  NumberOfFields = 39;
  NumberOfFixedFields = 6;
  FieldNames : Array[1..NumberOfFields] of TFieldName = (
                                                         (SQLName:'rec_pfix';TKName:'RecPfix'),
                                                         (SQLName:'sub_type';TKName:'SubType'),
                                                         (SQLName:'var_code1';TKName:'var_code1'),
                                                         (SQLName:'var_code2';TKName:'var_code2'),
                                                         (SQLName:'var_code3';TKName:'var_code3'),
                                                         (SQLName:'var_code4';TKName:'var_code4'),
                                                         (SQLName:'emp_name';TKName:'EmpName'),
                                                         (SQLName:'addr1';TKName:'Addr1'),
                                                         (SQLName:'addr2';TKName:'Addr2'),
                                                         (SQLName:'addr3';TKName:'Addr3'),
                                                         (SQLName:'addr4';TKName:'Addr4'),
                                                         (SQLName:'addr5';TKName:'Addr5'),
                                                         (SQLName:'phone';TKName:'Phone'),
                                                         (SQLName:'fax';TKName:'Fax'),
                                                         (SQLName:'phone2';TKName:'Phone2'),
                                                         (SQLName:'e_type';TKName:'EType'),
                                                         (SQLName:'time_dr1';TKName:'TimeDR1'),
                                                         (SQLName:'time_dr2';TKName:'TimeDR2'),
                                                         (SQLName:'cc_dep1';TKName:'Department'),
                                                         (SQLName:'cc_dep2';TKName:'CostCentre'),
                                                         (SQLName:'pay_no';TKName:'PayNo'),
                                                         (SQLName:'cert_no';TKName:'CertNo'),
                                                         (SQLName:'cert_expiry';TKName:'CertExpiry'),
                                                         (SQLName:'je_tag';TKName:'JETag'),
                                                         (SQLName:'use_o_rate';TKName:'UseORate'),
                                                         (SQLName:'user_def1';TKName:'UserDef1'),
                                                         (SQLName:'user_def2';TKName:'UserDef2'),
                                                         (SQLName:'n_line_count';TKName:'NLineCount'),
                                                         (SQLName:'g_self_bill';TKName:'GSelfBill'),
                                                         (SQLName:'group_cert';TKName:'GroupCert'),
                                                         (SQLName:'cis_type';TKName:'CISType'),
                                                         (SQLName:'user_def3';TKName:'UserDef3'),
                                                         (SQLName:'user_def4';TKName:'UserDef4'),
                                                         (SQLName:'eni_no';TKName:'ENINo'),
                                                         (SQLName:'lab_pl_only';TKName:'LabPLOnly'),
                                                         (SQLName:'utr_code';TKName:'UTRCode'),
                                                         (SQLName:'verify_no';TKName:'HMRCVerifyNo'),
                                                         (SQLName:'tagged';TKName:'Tagged'),
                                                         (SQLName:'cis_subtype';TKName:'CISSubType')
                                                        );
var
  i : integer;
  CurrentPrefix : String;
begin
  for i := 1 to NumberOfFields do
  begin
    if Trim(UpperCase(Value)) = Trim(UpperCase(FieldNames[i].TkName)) then
    begin
      if i > NumberOfFixedFields then
        CurrentPrefix := 'JE'
      else
        CurrentPrefix := '';
      Result := GetDBColumnName('JobMisc.dat', FieldNames[i].SQLName, CurrentPrefix);
      Break;
    end;
  end;
end;
 
function TranslateJobTypeRecField(const Value : string) : string;
const
  NumberOfFields = 8;
  NumberOfFixedFields = 6;
  FieldNames : Array[1..NumberOfFields] of TFieldName = (
                                                         (SQLName:'rec_pfix';TKName:'RecPfix'),
                                                         (SQLName:'sub_type';TKName:'SubType'),
                                                         (SQLName:'var_code1';TKName:'var_code1'),
                                                         (SQLName:'var_code2';TKName:'var_code2'),
                                                         (SQLName:'var_code3';TKName:'var_code3'),
                                                         (SQLName:'var_code4';TKName:'var_code4'),
                                                         (SQLName:'jt_name';TKName:'JTypeName'),
                                                         (SQLName:'jt_tag';TKName:'JTTag')
                                                        );
var
  i : integer;
  CurrentPrefix : String;
begin
  for i := 1 to NumberOfFields do
  begin
    if Trim(UpperCase(Value)) = Trim(UpperCase(FieldNames[i].TkName)) then
    begin
      if i > NumberOfFixedFields then
        CurrentPrefix := 'JT'
      else
        CurrentPrefix := '';
      Result := GetDBColumnName('JobMisc.dat', FieldNames[i].SQLName, CurrentPrefix);
      Break;
    end;
  end;
end;
 
function TranslateJobAnalRecField(const Value : string) : string;
const
  NumberOfFields = 28;
  NumberOfFixedFields = 6;
  FieldNames : Array[1..NumberOfFields] of TFieldName = (
                                                         (SQLName:'rec_pfix';TKName:'RecPfix'),
                                                         (SQLName:'sub_type';TKName:'SubType'),
                                                         (SQLName:'var_code1';TKName:'var_code1'),
                                                         (SQLName:'var_code2';TKName:'var_code2'),
                                                         (SQLName:'var_code3';TKName:'var_code3'),
                                                         (SQLName:'var_code4';TKName:'var_code4'),
                                                         (SQLName:'ja_name';TKName:'JAName'),
                                                         (SQLName:'ja_type';TKName:'JAType'),
                                                         (SQLName:'wip_nom1';TKName:'WIPNom1'),
                                                         (SQLName:'wip_nom2';TKName:'WIPNom2'),
                                                         (SQLName:'anal_hed';TKName:'AnalHed'),
                                                         (SQLName:'ja_tag';TKName:'JATag'),
                                                         (SQLName:'j_link_lt';TKName:'JLinkLT'),
                                                         (SQLName:'cis_tax_rate';TKName:'CISTaxRate'),
                                                         (SQLName:'uplift_p';TKName:'UpliftP'),
                                                         (SQLName:'uplift_gl';TKName:'UpliftGL'),
                                                         (SQLName:'revenue_type';TKName:'RevenueType'),
                                                         (SQLName:'ja_det_type';TKName:'JADetType'),
                                                         (SQLName:'ja_calc_b4_ret';TKName:'JACalcB4Ret'),
                                                         (SQLName:'ja_deduct';TKName:'JADeduct'),
                                                         (SQLName:'ja_ded_apply';TKName:'JADedApply'),
                                                         (SQLName:'ja_ret_type';TKName:'JARetType'),
                                                         (SQLName:'ja_ret_value';TKName:'JARetValue'),
                                                         (SQLName:'ja_ret_exp';TKName:'JARetExp'),
                                                         (SQLName:'ja_ret_exp_int';TKName:'JARetExpInt'),
                                                         (SQLName:'ja_ret_pres';TKName:'JARetPres'),
                                                         (SQLName:'ja_ded_comp';TKName:'JADedComp'),
                                                         (SQLName:'ja_pay_code';TKName:'JAPayCode')
                                                        );
var
  i : integer;
  CurrentPrefix : String;
begin
  for i := 1 to NumberOfFields do
  begin
    if Trim(UpperCase(Value)) = Trim(UpperCase(FieldNames[i].TkName)) then
    begin
      if i > NumberOfFixedFields then
        CurrentPrefix := 'JA'
      else
        CurrentPrefix := '';
      Result := GetDBColumnName('JobMisc.dat', FieldNames[i].SQLName, CurrentPrefix);
      Break;
    end;
  end;
end;
 
function TranslateLbinField(const Value : string) : string;
const
  NumberOfFields = 7;
  FieldNames : Array[1..NumberOfFields] of TFieldName = (
                                                         (SQLName:'lbHeaderNo';TKName:'lbHeaderNo'),
                                                         (SQLName:'lbLineNo';TKName:'lbLineNo'),
                                                         (SQLName:'lbBinCode';TKName:'lbBinCode'),
                                                         (SQLName:'lbUsedInBatch';TKName:'lbUsedInBatch'),
                                                         (SQLName:'lbUsedInThisLine';TKName:'lbUsedInThisLine'),
                                                         (SQLName:'lbUsedElsewhere';TKName:'lbUsedElsewhere'),
                                                         (SQLName:'lbDummyChar';TKName:'lbDummyChar')
                                                        );
var
  i : integer;
begin
  for i := 1 to NumberOfFields do
  begin
    if Trim(UpperCase(Value)) = Trim(UpperCase(FieldNames[i].TkName)) then
    begin
      Result := GetDBColumnName('Lbin.dat', FieldNames[i].SQLName, '');
      Break;
    end;
  end;
end;
 
function TranslateLheaderField(const Value : string) : string;
const
  NumberOfFields = 149;
  FieldNames : Array[1..NumberOfFields] of TFieldName = (
                                                         (SQLName:'lhFolioNo';TKName:'lhFolioNo'),
                                                         (SQLName:'lhUserName';TKName:'lhUserName'),
                                                         (SQLName:'lhAccountCode';TKName:'lhAccountCode'),
                                                         (SQLName:'lhAccountName';TKName:'lhAccountName'),
                                                         (SQLName:'lhCustomerName';TKName:'lhCustomerName'),
                                                         (SQLName:'lhOrderNo';TKName:'lhOrderNo'),
                                                         (SQLName:'lhAddress1';TKName:'lhAddress1'),
                                                         (SQLName:'lhAddress2';TKName:'lhAddress2'),
                                                         (SQLName:'lhAddress3';TKName:'lhAddress3'),
                                                         (SQLName:'lhAddress4';TKName:'lhAddress4'),
                                                         (SQLName:'lhAddress5';TKName:'lhAddress5'),
                                                         (SQLName:'lhItemsDesc';TKName:'lhItemsDesc'),
                                                         (SQLName:'lhSettDisc';TKName:'lhSettDisc'),
                                                         (SQLName:'lhSettDiscDays';TKName:'lhSettDiscDays'),
                                                         (SQLName:'lhDepositToTake';TKName:'lhDepositToTake'),
                                                         (SQLName:'lhDate';TKName:'lhDate'),
                                                         (SQLName:'lhTime';TKName:'lhTime'),
                                                         (SQLName:'lhTillNo';TKName:'lhTillNo'),
                                                         (SQLName:'lhValue';TKName:'lhValue'),
                                                         (SQLName:'lhCostCentre';TKName:'lhCostCentre'),
                                                         (SQLName:'lhDepartment';TKName:'lhDepartment'),
                                                         (SQLName:'lhDummyChar';TKName:'lhDummyChar'),
                                                         (SQLName:'RunNo';TKName:'RunNo'),
                                                         (SQLName:'CustCode';TKName:'CustCode'),
                                                         (SQLName:'OurRef';TKName:'OurRef'),
                                                         (SQLName:'PadChar1';TKName:'PadChar1'),
                                                         (SQLName:'FolioNum';TKName:'FolioNum'),
                                                         (SQLName:'Currency';TKName:'Currency'),
                                                         (SQLName:'AcYr';TKName:'AcYr'),
                                                         (SQLName:'AcPr';TKName:'AcPr'),
                                                         (SQLName:'DueDate';TKName:'DueDate'),
                                                         (SQLName:'TransDate';TKName:'TransDate'),
                                                         (SQLName:'CoRate';TKName:'CoRate'),
                                                         (SQLName:'VATRate';TKName:'VATRate'),
                                                         (SQLName:'OldYourRef';TKName:'OldYourRef'),
                                                         (SQLName:'LongYrRef';TKName:'LongYrRef'),
                                                         (SQLName:'LineCount';TKName:'LineCount'),
                                                         (SQLName:'TransDocHed';TKName:'TransDocHed'),
                                                         (SQLName:'InvVatAnal1';TKName:'VATAnalysisStandard'),
                                                         (SQLName:'InvVatAnal2';TKName:'VATAnalysisExempt'),
                                                         (SQLName:'InvVatAnal3';TKName:'VATAnalysisZero'),
                                                         (SQLName:'InvVatAnal4';TKName:'VATAnalysisRate1'),
                                                         (SQLName:'InvVatAnal5';TKName:'VATAnalysisRate2'),
                                                         (SQLName:'InvVatAnal6';TKName:'VATAnalysisRate3'),
                                                         (SQLName:'InvVatAnal7';TKName:'VATAnalysisRate4'),
                                                         (SQLName:'InvVatAnal8';TKName:'VATAnalysisRate5'),
                                                         (SQLName:'InvVatAnal9';TKName:'VATAnalysisRate6'),
                                                         (SQLName:'InvVatAnal10';TKName:'VATAnalysisRate7'),
                                                         (SQLName:'InvVatAnal11';TKName:'VATAnalysisRate8'),
                                                         (SQLName:'InvVatAnal12';TKName:'VATAnalysisRate9'),
                                                         (SQLName:'InvVatAnal13';TKName:'VATAnalysisRateT'),
                                                         (SQLName:'InvVatAnal14';TKName:'VATAnalysisRateX'),
                                                         (SQLName:'InvVatAnal15';TKName:'VATAnalysisRateB'),
                                                         (SQLName:'InvVatAnal16';TKName:'VATAnalysisRateC'),
                                                         (SQLName:'InvVatAnal17';TKName:'VATAnalysisRateF'),
                                                         (SQLName:'InvVatAnal18';TKName:'VATAnalysisRateG'),
                                                         (SQLName:'InvVatAnal19';TKName:'VATAnalysisRateR'),
                                                         (SQLName:'InvVatAnal20';TKName:'VATAnalysisRateW'),
                                                         (SQLName:'InvVatAnal21';TKName:'VATAnalysisRateY'),
                                                         (SQLName:'InvNetVal';TKName:'InvNetVal'),
                                                         (SQLName:'InvVat';TKName:'InvVat'),
                                                         (SQLName:'DiscSetl';TKName:'DiscSetl'),
                                                         (SQLName:'DiscSetAm';TKName:'DiscSetAm'),
                                                         (SQLName:'DiscAmount';TKName:'DiscAmount'),
                                                         (SQLName:'DiscDays';TKName:'DiscDays'),
                                                         (SQLName:'DiscTaken';TKName:'DiscTaken'),
                                                         (SQLName:'Settled';TKName:'Settled'),
                                                         (SQLName:'TransNat';TKName:'TransNat'),
                                                         (SQLName:'TransMode';TKName:'TransMode'),
                                                         (SQLName:'HoldFlg';TKName:'HoldFlg'),
                                                         (SQLName:'PadChar2';TKName:'PadChar2'),
                                                         (SQLName:'TotalWeight';TKName:'TotalWeight'),
                                                         (SQLName:'DAddr1';TKName:'DAddr1'),
                                                         (SQLName:'DAddr2';TKName:'DAddr2'),
                                                         (SQLName:'DAddr3';TKName:'DAddr3'),
                                                         (SQLName:'DAddr4';TKName:'DAddr4'),
                                                         (SQLName:'DAddr5';TKName:'DAddr5'),
                                                         (SQLName:'PadChar3';TKName:'PadChar3'),
                                                         (SQLName:'TotalCost';TKName:'TotalCost'),
                                                         (SQLName:'PrintedDoc';TKName:'PrintedDoc'),
                                                         (SQLName:'ManVAT';TKName:'ManVAT'),
                                                         (SQLName:'DelTerms';TKName:'DelTerms'),
                                                         (SQLName:'OpName';TKName:'OpName'),
                                                         (SQLName:'DJobCode';TKName:'DJobCode'),
                                                         (SQLName:'DJobAnal';TKName:'DJobAnal'),
                                                         (SQLName:'PadChar4';TKName:'PadChar4'),
                                                         (SQLName:'TotOrdOS';TKName:'TotOrdOS'),
                                                         (SQLName:'DocUser1';TKName:'DocUser1'),
                                                         (SQLName:'DocUser2';TKName:'DocUser2'),
                                                         (SQLName:'EmpCode';TKName:'EmpCode'),
                                                         (SQLName:'PadChar5';TKName:'PadChar5'),
                                                         (SQLName:'Tagged';TKName:'Tagged'),
                                                         (SQLName:'thNoLabels';TKName:'thNoLabels'),
                                                         (SQLName:'PadChar6';TKName:'PadChar6'),
                                                         (SQLName:'CtrlNom';TKName:'CtrlNom'),
                                                         (SQLName:'DocUser3';TKName:'DocUser3'),
                                                         (SQLName:'DocUser4';TKName:'DocUser4'),
                                                         (SQLName:'SSDProcess';TKName:'SSDProcess'),
                                                         (SQLName:'PadChar7';TKName:'PadChar7'),
                                                         (SQLName:'ExtSource';TKName:'ExtSource'),
                                                         (SQLName:'PostDate';TKName:'PostDate'),
                                                         (SQLName:'PadChar8';TKName:'PadChar8'),
                                                         (SQLName:'PORPickSOR';TKName:'PORPickSOR'),
                                                         (SQLName:'PadChar9';TKName:'PadChar9'),
                                                         (SQLName:'BDiscount';TKName:'BDiscount'),
                                                         (SQLName:'PrePostFlg';TKName:'PrePostFlg'),
                                                         (SQLName:'AllocStat';TKName:'AllocStat'),
                                                         (SQLName:'PadChar10';TKName:'PadChar10'),
                                                         (SQLName:'SOPKeepRate';TKName:'SOPKeepRate'),
                                                         (SQLName:'TimeCreate';TKName:'TimeCreate'),
                                                         (SQLName:'TimeChange';TKName:'TimeChange'),
                                                         (SQLName:'CISTax';TKName:'CISTax'),
                                                         (SQLName:'CISDeclared';TKName:'CISDeclared'),
                                                         (SQLName:'CISManualTax';TKName:'CISManualTax'),
                                                         (SQLName:'CISDate';TKName:'CISDate'),
                                                         (SQLName:'PadChar11';TKName:'PadChar11'),
                                                         (SQLName:'TotalCost2';TKName:'TotalCost2'),
                                                         (SQLName:'CISEmpl';TKName:'CISEmpl'),
                                                         (SQLName:'PadChar12';TKName:'PadChar12'),
                                                         (SQLName:'CISGross';TKName:'CISGross'),
                                                         (SQLName:'CISHolder';TKName:'CISHolder'),
                                                         (SQLName:'NOMVatIO';TKName:'NOMVatIO'),
                                                         (SQLName:'AutoInc';TKName:'AutoInc'),
                                                         (SQLName:'AutoIncBy';TKName:'AutoIncBy'),
                                                         (SQLName:'AutoEndDate';TKName:'AutoEndDate'),
                                                         (SQLName:'AutoEndPr';TKName:'AutoEndPr'),
                                                         (SQLName:'AutoEndYr';TKName:'AutoEndYr'),
                                                         (SQLName:'AutoPost';TKName:'AutoPost'),
                                                         (SQLName:'thAutoTransaction';TKName:'thAutoTransaction'),
                                                         (SQLName:'PadChar13';TKName:'PadChar13'),
                                                         (SQLName:'thDeliveryRunNo';TKName:'thDeliveryRunNo'),
                                                         (SQLName:'thExternal';TKName:'thExternal'),
                                                         (SQLName:'thSettledVAT';TKName:'thSettledVAT'),
                                                         (SQLName:'thVATClaimed';TKName:'thVATClaimed'),
                                                         (SQLName:'thPickingRunNo';TKName:'thPickingRunNo'),
                                                         (SQLName:'PadChar15';TKName:'PadChar15'),
                                                         (SQLName:'thDeliveryNoteRef';TKName:'thDeliveryNoteRef'),
                                                         (SQLName:'thVATCompanyRate';TKName:'thVATCompanyRate'),
                                                         (SQLName:'thVATDailyRate';TKName:'thVATDailyRate'),
                                                         (SQLName:'thPostCompanyRate';TKName:'thPostCompanyRate'),
                                                         (SQLName:'thPostDailyRate';TKName:'thPostDailyRate'),
                                                         (SQLName:'thPostDiscAmount';TKName:'thPostDiscAmount'),
                                                         (SQLName:'PadChar16';TKName:'PadChar16'),
                                                         (SQLName:'thPostDiscTaken';TKName:'thPostDiscTaken'),
                                                         (SQLName:'thLastDebtChaseLetter';TKName:'thLastDebtChaseLetter'),
                                                         (SQLName:'thRevaluationAdjustment';TKName:'thRevaluationAdjustment'),
                                                         (SQLName:'YourRef';TKName:'YourRef'),
                                                         (SQLName:'Spare';TKName:'Spare'),
                                                         (SQLName:'LastChar';TKName:'LastChar')
                                                        );
var
  i : integer;
begin
  for i := 1 to NumberOfFields do
  begin
    if Trim(UpperCase(Value)) = Trim(UpperCase(FieldNames[i].TkName)) then
    begin
      Result := GetDBColumnName('Lheader.dat', FieldNames[i].SQLName, '');
      Break;
    end;
  end;
end;
 
function TranslateLlinesField(const Value : string) : string;
const
  NumberOfFields = 114;
  FieldNames : Array[1..NumberOfFields] of TFieldName = (
                                                         (SQLName:'llheaderno';TKName:'llheaderno'),
                                                         (SQLName:'lllineno';TKName:'lllineno'),
                                                         (SQLName:'llstockcode';TKName:'llstockcode'),
                                                         (SQLName:'lldescription1';TKName:'lldescription1'),
                                                         (SQLName:'lldescription2';TKName:'lldescription2'),
                                                         (SQLName:'lldescription3';TKName:'lldescription3'),
                                                         (SQLName:'lldescription4';TKName:'lldescription4'),
                                                         (SQLName:'lldescription5';TKName:'lldescription5'),
                                                         (SQLName:'lldescription6';TKName:'lldescription6'),
                                                         (SQLName:'llprice';TKName:'llprice'),
                                                         (SQLName:'llvatinclusive';TKName:'llvatinclusive'),
                                                         (SQLName:'llvatrate';TKName:'llvatrate'),
                                                         (SQLName:'lldisctype';TKName:'lldisctype'),
                                                         (SQLName:'lldiscount';TKName:'lldiscount'),
                                                         (SQLName:'lldiscamount';TKName:'lldiscamount'),
                                                         (SQLName:'lldiscdesc';TKName:'lldiscdesc'),
                                                         (SQLName:'llquantity';TKName:'llquantity'),
                                                         (SQLName:'llserialitem';TKName:'llserialitem'),
                                                         (SQLName:'lldummychar';TKName:'lldummychar'),
                                                         (SQLName:'lllistfoliono';TKName:'lllistfoliono'),
                                                         (SQLName:'llbomparentfoliono';TKName:'llbomparentfoliono'),
                                                         (SQLName:'llbomqtyused';TKName:'llbomqtyused'),
                                                         (SQLName:'llbom';TKName:'llbom'),
                                                         (SQLName:'llkitlink';TKName:'llkitlink'),
                                                         (SQLName:'transrefno';TKName:'transrefno'),
                                                         (SQLName:'padchar1';TKName:'padchar1'),
                                                         (SQLName:'lineno';TKName:'linenumber'),
                                                         (SQLName:'nomcode';TKName:'nomcode'),
                                                         (SQLName:'currency';TKName:'currency'),
                                                         (SQLName:'padchar2';TKName:'padchar2'),
                                                         (SQLName:'corate';TKName:'corate'),
                                                         (SQLName:'vatrate';TKName:'vatrate'),
                                                         (SQLName:'cc';TKName:'cc'),
                                                         (SQLName:'dep';TKName:'dep'),
                                                         (SQLName:'stockcode';TKName:'stockcode'),
                                                         (SQLName:'padchar3';TKName:'padchar3'),
                                                         (SQLName:'qty';TKName:'Qty'),
                                                         (SQLName:'qtymul';TKName:'qtymul'),
                                                         (SQLName:'netvalue';TKName:'netvalue'),
                                                         (SQLName:'discount';TKName:'discount'),
                                                         (SQLName:'vatcode';TKName:'vatcode'),
                                                         (SQLName:'padchar4';TKName:'padchar4'),
                                                         (SQLName:'vat';TKName:'Vat'),
                                                         (SQLName:'payment';TKName:'payment'),
                                                         (SQLName:'discountchr';TKName:'discountchr'),
                                                         (SQLName:'padchar5';TKName:'padchar5'),
                                                         (SQLName:'qtywoff';TKName:'qtywoff'),
                                                         (SQLName:'qtydel';TKName:'qtydel'),
                                                         (SQLName:'costprice';TKName:'costprice'),
                                                         (SQLName:'custcode';TKName:'custcode'),
                                                         (SQLName:'linedate';TKName:'linedate'),
                                                         (SQLName:'item';TKName:'item'),
                                                         (SQLName:'desc';TKName:'description'),
                                                         (SQLName:'weight';TKName:'weight'),
                                                         (SQLName:'mlocstk';TKName:'mlocstk'),
                                                         (SQLName:'jobcode';TKName:'jobcode'),
                                                         (SQLName:'analcode';TKName:'analcode'),
                                                         (SQLName:'tshccurr';TKName:'tshccurr'),
                                                         (SQLName:'docltlink';TKName:'docltlink'),
                                                         (SQLName:'spare3';TKName:'spare3'),
                                                         (SQLName:'kitlink';TKName:'kitlink'),
                                                         (SQLName:'folionum';TKName:'folionum'),
                                                         (SQLName:'linetype';TKName:'linetype'),
                                                         (SQLName:'reconcile';TKName:'reconcile'),
                                                         (SQLName:'padchar6';TKName:'padchar6'),
                                                         (SQLName:'soplink';TKName:'soplink'),
                                                         (SQLName:'soplineno';TKName:'soplineno'),
                                                         (SQLName:'abslineno';TKName:'abslineno'),
                                                         (SQLName:'lineuser1';TKName:'lineuser1'),
                                                         (SQLName:'lineuser2';TKName:'lineuser2'),
                                                         (SQLName:'lineuser3';TKName:'lineuser3'),
                                                         (SQLName:'lineuser4';TKName:'lineuser4'),
                                                         (SQLName:'ssduplift';TKName:'ssduplift'),
                                                         (SQLName:'ssdcommod';TKName:'ssdcommod'),
                                                         (SQLName:'padchar7';TKName:'padchar7'),
                                                         (SQLName:'ssdspunit';TKName:'ssdspunit'),
                                                         (SQLName:'ssduseline';TKName:'ssduseline'),
                                                         (SQLName:'padchar8';TKName:'padchar8'),
                                                         (SQLName:'pricemulx';TKName:'pricemulx'),
                                                         (SQLName:'qtypick';TKName:'qtypick'),
                                                         (SQLName:'vatincflg';TKName:'vatincflg'),
                                                         (SQLName:'padchar9';TKName:'padchar9'),
                                                         (SQLName:'qtypwoff';TKName:'qtypwoff'),
                                                         (SQLName:'padchar10';TKName:'padchar10'),
                                                         (SQLName:'rtnerrcode';TKName:'rtnerrcode'),
                                                         (SQLName:'ssdcountry';TKName:'ssdcountry'),
                                                         (SQLName:'padchar11';TKName:'padchar11'),
                                                         (SQLName:'incnetvalue';TKName:'incnetvalue'),
                                                         (SQLName:'autolinetype';TKName:'autolinetype'),
                                                         (SQLName:'cisratecode';TKName:'cisratecode'),
                                                         (SQLName:'padchar12';TKName:'padchar12'),
                                                         (SQLName:'cisrate';TKName:'cisrate'),
                                                         (SQLName:'costapport';TKName:'costapport'),
                                                         (SQLName:'nomvattype';TKName:'nomvattype'),
                                                         (SQLName:'padchar13';TKName:'padchar13'),
                                                         (SQLName:'binqty';TKName:'binqty'),
                                                         (SQLName:'tlaltstockfolio';TKName:'tlaltstockfolio'),
                                                         (SQLName:'tlrunno';TKName:'tlrunno'),
                                                         (SQLName:'tlstockdeductqty';TKName:'tlstockdeductqty'),
                                                         (SQLName:'padchar16';TKName:'padchar16'),
                                                         (SQLName:'tluseqtymul';TKName:'tluseqtymul'),
                                                         (SQLName:'tlserialqty';TKName:'tlserialqty'),
                                                         (SQLName:'padchar17';TKName:'padchar17'),
                                                         (SQLName:'tlpricebypack';TKName:'tlpricebypack'),
                                                         (SQLName:'padchar18';TKName:'padchar18'),
                                                         (SQLName:'tlreconciliationdate';TKName:'tlreconciliationdate'),
                                                         (SQLName:'tlb2blinkfolio';TKName:'tlb2blinkfolio'),
                                                         (SQLName:'tlb2blineno';TKName:'tlb2blineno'),
                                                         (SQLName:'tlcosdailyrate';TKName:'tlcosdailyrate'),
                                                         (SQLName:'tlqtypack';TKName:'tlqtypack'),
                                                         (SQLName:'spare';TKName:'spare'),
                                                         (SQLName:'spare2';TKName:'spare2'),
                                                         (SQLName:'lastchar';TKName:'lastchar'),
                                                         (SQLName:'llbomcomponent';TKName:'llbomcomponent')
                                                        );
var
  i : integer;
begin
  for i := 1 to NumberOfFields do
  begin
    if Trim(UpperCase(Value)) = Trim(UpperCase(FieldNames[i].TkName)) then
    begin
      Result := GetDBColumnName('Llines.dat', FieldNames[i].SQLName, '');
      Break;
    end;
  end;
end;
 
function TranslateLserialField(const Value : string) : string;
const
  NumberOfFields = 12;
  FieldNames : Array[1..NumberOfFields] of TFieldName = (
                                                         (SQLName:'lsHeaderNo';TKName:'lsHeaderNo'),
                                                         (SQLName:'lsLineNo';TKName:'lsLineNo'),
                                                         (SQLName:'lsBatch';TKName:'lsBatch'),
                                                         (SQLName:'lsSerialNo';TKName:'lsSerialNo'),
                                                         (SQLName:'lsBatchNo';TKName:'lsBatchNo'),
                                                         (SQLName:'XlsUsedInBatch';TKName:'XlsUsedInBatch'),
                                                         (SQLName:'XlsUsedInThisLine';TKName:'XlsUsedInThisLine'),
                                                         (SQLName:'XlsUsedElsewhere';TKName:'XlsUsedElsewhere'),
                                                         (SQLName:'lsDummyChar';TKName:'lsDummyChar'),
                                                         (SQLName:'lsUsedInBatch';TKName:'lsUsedInBatch'),
                                                         (SQLName:'lsUsedInThisLine';TKName:'lsUsedInThisLine'),
                                                         (SQLName:'lsUsedElsewhere';TKName:'lsUsedElsewhere')
                                                        );
var
  i : integer;
begin
  for i := 1 to NumberOfFields do
  begin
    if Trim(UpperCase(Value)) = Trim(UpperCase(FieldNames[i].TkName)) then
    begin
      Result := GetDBColumnName('Lserial.dat', FieldNames[i].SQLName, '');
      Break;
    end;
  end;
end;
 
function TranslateMCPAYField(const Value : string) : string;
const
  NumberOfFields = 4;
  FieldNames : Array[1..NumberOfFields] of TFieldName = (
                                                         (SQLName:'CoCode';TKName:'CoCode'),
                                                         (SQLName:'PayID';TKName:'PayID'),
                                                         (SQLName:'CoName';TKName:'CoName'),
                                                         (SQLName:'FileName';TKName:'FileName')
                                                        );
var
  i : integer;
begin
  for i := 1 to NumberOfFields do
  begin
    if Trim(UpperCase(Value)) = Trim(UpperCase(FieldNames[i].TkName)) then
    begin
      Result := GetDBColumnName('MCPAY.dat', FieldNames[i].SQLName, '');
      Break;
    end;
  end;
end;

function TranslateMLocLocField(const Value : string) : string;
const
  NumberOfFields = 42;
  NumberOfFixedFields = 5;
  FieldNames : Array[1..NumberOfFields] of TFieldName = (
                                                         (SQLName:'rec_pfix';TKName:'RecPfix'),
                                                         (SQLName:'sub_type';TKName:'SubType'),
                                                         (SQLName:'var_code1';TKName:'varCode1'),
                                                         (SQLName:'lo_code';TKName:'loCode'),
                                                         (SQLName:'lo_name';TKName:'loName'),
                                                         (SQLName:'lo_addr1';TKName:'loAddress[1]'),
                                                         (SQLName:'lo_addr2';TKName:'loAddress[2]'),
                                                         (SQLName:'lo_addr3';TKName:'loAddress[3]'),
                                                         (SQLName:'lo_addr4';TKName:'loAddress[4]'),
                                                         (SQLName:'lo_addr5';TKName:'loAddress[5]'),
                                                         (SQLName:'lo_tel';TKName:'loPhone'),
                                                         (SQLName:'lo_fax';TKName:'loFax'),
                                                         (SQLName:'lo_email';TKName:'loEmail'),
                                                         (SQLName:'lo_modem';TKName:'loModem'),
                                                         (SQLName:'lo_contact';TKName:'loContact'),
                                                         (SQLName:'lo_currency';TKName:'LoCurrency'),
                                                         (SQLName:'lo_area';TKName:'loArea'),
                                                         (SQLName:'lo_rep';TKName:'loRep'),
                                                         (SQLName:'lo_tag';TKName:'loTag'),
                                                         (SQLName:'lo_nominal1';TKName:'loSalesGL'),
                                                         (SQLName:'lo_nominal2';TKName:'loCostOfSalesGL'),
                                                         (SQLName:'lo_nominal3';TKName:'loPandLGL'),
                                                         (SQLName:'lo_nominal4';TKName:'loBalSheetGL'),
                                                         (SQLName:'lo_nominal5';TKName:'loWIPGL'),
                                                         (SQLName:'lo_nominal6';TKName:'loNominal6'),
                                                         (SQLName:'lo_nominal7';TKName:'loNominal7'),
                                                         (SQLName:'lo_nominal8';TKName:'loNominal8'),
                                                         (SQLName:'lo_nominal9';TKName:'loNominal9'),
                                                         (SQLName:'lo_nominal10';TKName:'loNominal10'),
                                                         (SQLName:'lo_cc_dep1';TKName:'loDepartment'),
                                                         (SQLName:'lo_cc_dep2';TKName:'loCostCentre'),
                                                         (SQLName:'lo_use_price';TKName:'loOverrideSalesPrice'),
                                                         (SQLName:'lo_use_nom';TKName:'loOverrideGLCodes'),
                                                         (SQLName:'lo_use_cc_dep';TKName:'loOverrideCCDept'),
                                                         (SQLName:'lo_use_supp';TKName:'loOverrideSupplier'),
                                                         (SQLName:'lo_use_bin_loc';TKName:'loOverrideBinLocation'),
                                                         (SQLName:'lo_n_line_count';TKName:'loNLineCount'),
                                                         (SQLName:'lo_use_c_price';TKName:'loOverrideCostPrice'),
                                                         (SQLName:'lo_use_r_price';TKName:'loOverrideReorderPrice'),
                                                         (SQLName:'lo_wopwipgl';TKName:'loWOPFinishedWIPGL'),
                                                         (SQLName:'lo_return_gl';TKName:'loSalesReturnGL'),
                                                         (SQLName:'lo_p_return_gl';TKName:'loPurchaseReturnGL')
                                                        );
var
  i : integer;
  CurrentPrefix : String;
begin
  for i := 1 to NumberOfFields do
  begin
    if Trim(UpperCase(Value)) = Trim(UpperCase(FieldNames[i].TkName)) then
    begin
{      if i > NumberOfFixedFields then
        CurrentPrefix := 'CC'
      else}
        CurrentPrefix := '';
//      Result := GetDBColumnName('Mlocstk.dat', FieldNames[i].SQLName, CurrentPrefix);
      Result := GetDBColumnName('Location.dat', FieldNames[i].SQLName, CurrentPrefix);
      Break;
    end;
  end;
end;

 
function TranslateMStkLocField(const Value : string) : string;
const
  NumberOfFields = 80;
  NumberOfFixedFields = 5;
  FieldNames : Array[1..NumberOfFields] of TFieldName = (
                                                         (SQLName:'rec_pfix';TKName:'RecPfix'),
                                                         (SQLName:'sub_type';TKName:'SubType'),
                                                         (SQLName:'var_code1';TKName:'varCode1'),
                                                         (SQLName:'var_code2';TKName:'varCode2'),
                                                         (SQLName:'var_code3';TKName:'varCode3'),
                                                         (SQLName:'ls_stk_code';TKName:'slStockCode'),
                                                         (SQLName:'ls_stk_folio';TKName:'slStockFolio'),
                                                         (SQLName:'ls_loc_code';TKName:'slLocationCode'),
                                                         (SQLName:'ls_qty_in_stock';TKName:'slQtyInStock'),
                                                         (SQLName:'ls_qty_on_order';TKName:'slQtyOnOrder'),
                                                         (SQLName:'ls_qty_alloc';TKName:'slQtyAlloc'),
                                                         (SQLName:'ls_qty_picked';TKName:'slQtyPicked'),
                                                         (SQLName:'ls_qty_min';TKName:'slQtyMin'),
                                                         (SQLName:'ls_qty_max';TKName:'slQtyMax'),
                                                         (SQLName:'ls_qty_freeze';TKName:'slQtyFreeze'),
                                                         (SQLName:'ls_ro_qty';TKName:'slReorderQty'),
                                                         (SQLName:'ls_ro_date';TKName:'slReorderDate'),
                                                         (SQLName:'ls_ro_cc_dep1';TKName:'slReorderDepartment'),
                                                         (SQLName:'ls_ro_cc_dep2';TKName:'slReorderCostCentre'),
                                                         (SQLName:'ls_cc_dep1';TKName:'slDepartment'),
                                                         (SQLName:'ls_cc_dep2';TKName:'slCostCentre'),
                                                         (SQLName:'ls_bin_loc';TKName:'slBinLocation'),
                                                         (SQLName:'currency1';TKName:'slSalesBand(''A'').Currency'),
                                                         (SQLName:'sales_price1';TKName:'slSalesBand(''A'').Price'),
                                                         (SQLName:'currency2';TKName:'slSalesBand(''B'').Currency'),
                                                         (SQLName:'sales_price2';TKName:'slSalesBand(''B'').Price'),
                                                         (SQLName:'currency3';TKName:'slSalesBand(''C'').Currency'),
                                                         (SQLName:'sales_price3';TKName:'slSalesBand(''C'').Price'),
                                                         (SQLName:'currency4';TKName:'slSalesBand(''D'').Currency'),
                                                         (SQLName:'sales_price4';TKName:'slSalesBand(''D'').Price'),
                                                         (SQLName:'currency5';TKName:'slSalesBand(''E'').Currency'),
                                                         (SQLName:'sales_price5';TKName:'slSalesBand(''E'').Price'),
                                                         (SQLName:'currency6';TKName:'slSalesBand(''F'').Currency'),
                                                         (SQLName:'sales_price6';TKName:'slSalesBand(''F'').Price'),
                                                         (SQLName:'currency7';TKName:'slSalesBand(''G'').Currency'),
                                                         (SQLName:'sales_price7';TKName:'slSalesBand(''G'').Price'),
                                                         (SQLName:'currency8';TKName:'slSalesBand(''H'').Currency'),
                                                         (SQLName:'sales_price8';TKName:'slSalesBand(''H'').Price'),
                                                         (SQLName:'currency9';TKName:'slCurrency9'),
                                                         (SQLName:'sales_price9';TKName:'slSalesPrice9'),
                                                         (SQLName:'currency10';TKName:'slCurrency10'),
                                                         (SQLName:'sales_price10';TKName:'slSalesPrice10'),
                                                         (SQLName:'ls_ro_price';TKName:'slReorderPrice'),
                                                         (SQLName:'ls_ro_currency';TKName:'slReorderCurrency'),
                                                         (SQLName:'ls_cost_price';TKName:'slCostPrice'),
                                                         (SQLName:'ls_p_currency';TKName:'slCostPriceCur'),
                                                         (SQLName:'ls_def_nom1';TKName:'slSalesGL'),
                                                         (SQLName:'ls_def_nom2';TKName:'slCostOfSalesGL'),
                                                         (SQLName:'ls_def_nom3';TKName:'slPandLGL'),
                                                         (SQLName:'ls_def_nom4';TKName:'slBalSheetGL'),
                                                         (SQLName:'ls_def_nom5';TKName:'slWIPGL'),
                                                         (SQLName:'ls_def_nom6';TKName:'slDefNom6'),
                                                         (SQLName:'ls_def_nom7';TKName:'slDefNom7'),
                                                         (SQLName:'ls_def_nom8';TKName:'slDefNom8'),
                                                         (SQLName:'ls_def_nom9';TKName:'slDefNom9'),
                                                         (SQLName:'ls_def_nom10';TKName:'slDefNom10'),
                                                         (SQLName:'ls_stk_flg';TKName:'slStkFlg'),
                                                         (SQLName:'ls_min_flg';TKName:'slMinFlg'),
                                                         (SQLName:'ls_temp_supp';TKName:'slTempSupp'),
                                                         (SQLName:'ls_supplier';TKName:'slSupplier'),
                                                         (SQLName:'ls_last_used';TKName:'slLastUsed'),
                                                         (SQLName:'ls_qty_posted';TKName:'slQtyPosted'),
                                                         (SQLName:'ls_qty_take';TKName:'slQtyTake'),
                                                         (SQLName:'ls_ro_flg';TKName:'slROFlg'),
                                                         (SQLName:'ls_last_time';TKName:'slLastTime'),
                                                         (SQLName:'ls_qty_alloc_wor';TKName:'slQtyAllocWOR'),
                                                         (SQLName:'ls_qty_issue_wor';TKName:'slQtyIssueWOR'),
                                                         (SQLName:'ls_qty_pick_wor';TKName:'slQtyPickWOR'),
                                                         (SQLName:'ls_wopwipgl';TKName:'slWOPWIPGL'),
                                                         (SQLName:'ls_s_warranty';TKName:'slSWarranty'),
                                                         (SQLName:'ls_s_warranty_type';TKName:'slSWarrantyType'),
                                                         (SQLName:'ls_m_warranty';TKName:'slManufacturerWarrantyLength'),
                                                         (SQLName:'ls_m_warranty_type';TKName:'slManufacturerWarrantyUnits'),
                                                         (SQLName:'ls_qty_p_return';TKName:'slPurchaseReturnQty'),
                                                         (SQLName:'ls_return_gl';TKName:'slSalesReturnGL'),
                                                         (SQLName:'ls_re_stock_pcnt';TKName:'slRestockCharge'),
                                                         (SQLName:'ls_re_stock_gl';TKName:'slReStockGL'),
                                                         (SQLName:'ls_bom_ded_comp';TKName:'slBOMDedComp'),
                                                         (SQLName:'ls_qty_return';TKName:'slSalesReturnQty'),
                                                         (SQLName:'ls_p_return_gl';TKName:'slPurchaseReturnGL')
                                                        );
var
  i : integer;
  CurrentPrefix : String;
begin
  for i := 1 to NumberOfFields do
  begin
    if Trim(UpperCase(Value)) = Trim(UpperCase(FieldNames[i].TkName)) then
    begin
{      if i > NumberOfFixedFields then
        CurrentPrefix := 'CD'
      else}
        CurrentPrefix := '';
      Result := GetDBColumnName('StockLocation.dat', FieldNames[i].SQLName, CurrentPrefix);
      Break;
    end;
  end;
end;
 
function TranslateSdbStkRecField(const Value : string) : string;
const
  NumberOfFields = 21;
  NumberOfFixedFields = 5;
  FieldNames : Array[1..NumberOfFields] of TFieldName = (
                                                         (SQLName:'rec_pfix';TKName:'RecPfix'),
                                                         (SQLName:'sub_type';TKName:'SubType'),
                                                         (SQLName:'var_code1';TKName:'varCode1'),
                                                         (SQLName:'var_code2';TKName:'varCode2'),
                                                         (SQLName:'var_code3';TKName:'varCode3'),
                                                         (SQLName:'sd_stk_folio';TKName:'SdStkFolio'),
                                                         (SQLName:'sd_folio';TKName:'SdFolio'),
                                                         (SQLName:'sd_supp_code';TKName:'ascAcCode'),
                                                         (SQLName:'sd_alt_code';TKName:'ascAltCode'),
                                                         (SQLName:'sd_ro_currency';TKName:'ascReorderCurrency'),
                                                         (SQLName:'sd_ro_price';TKName:'ascReorderPrice'),
                                                         (SQLName:'sd_n_line_count';TKName:'SdNLineCount'),
                                                         (SQLName:'sd_last_used';TKName:'ascLastDateUsed'),
                                                         (SQLName:'sd_over_ro';TKName:'ascUseReorderPrice'),
                                                         (SQLName:'sd_desc';TKName:'SdDesc'),
                                                         (SQLName:'sd_last_time';TKName:'ascLastTimeUsed'),
                                                         (SQLName:'sd_over_min_ecc';TKName:'ascUseReorderQty'),
                                                         (SQLName:'sd_min_ecc_qty';TKName:'ascReorderQty'),
                                                         (SQLName:'sd_over_line_qty';TKName:'ascUseReplacementQty'),
                                                         (SQLName:'sd_line_qty';TKName:'ascReplacementQty'),
                                                         (SQLName:'sd_line_no';TKName:'ascDisplayOrder')
                                                        );
var
  i : integer;
  CurrentPrefix : String;
begin
  for i := 1 to NumberOfFields do
  begin
    if Trim(UpperCase(Value)) = Trim(UpperCase(FieldNames[i].TkName)) then
    begin
      if i > NumberOfFixedFields then
        CurrentPrefix := 'N*'
      else
        CurrentPrefix := '';
      Result := GetDBColumnName('Mlocstk.dat', FieldNames[i].SQLName, CurrentPrefix);
      Break;
    end;
  end;
end;
 
function TranslateCuStkRecField(const Value : string) : string;
const
  NumberOfFields = 41;
  NumberOfFixedFields = 5;
  FieldNames : Array[1..NumberOfFields] of TFieldName = (
                                                         (SQLName:'rec_pfix';TKName:'RecPfix'),
                                                         (SQLName:'sub_type';TKName:'SubType'),
                                                         (SQLName:'var_code1';TKName:'varCode1'),
                                                         (SQLName:'var_code2';TKName:'varCode2'),
                                                         (SQLName:'var_code3';TKName:'varCode3'),
                                                         (SQLName:'cs_cust_code';TKName:'saAcCode'),
                                                         (SQLName:'cs_stock_code';TKName:'saStockCode'),
                                                         (SQLName:'cs_stk_folio';TKName:'saStockFolio'),
                                                         (SQLName:'cs_so_qty';TKName:'saReOrderQty'),
                                                         (SQLName:'cs_last_date';TKName:'saLastDate'),
                                                         (SQLName:'cs_line_no';TKName:'saDisplayOrder'),
                                                         (SQLName:'cs_last_price';TKName:'saLastPrice'),
                                                         (SQLName:'cs_lp_curr';TKName:'saLastPriceCurrency'),
                                                         (SQLName:'cs_job_code';TKName:'saJobCode'),
                                                         (SQLName:'cs_ja_code';TKName:'saJobAnalysis'),
                                                         (SQLName:'cs_loc_code';TKName:'saLocation'),
                                                         (SQLName:'cs_nom_code';TKName:'saGLCode'),
                                                         (SQLName:'cs_cc_dep1';TKName:'saDepartment'),
                                                         (SQLName:'cs_cc_dep2';TKName:'saCostCentre'),
                                                         (SQLName:'cs_qty';TKName:'saQty'),
                                                         (SQLName:'cs_net_value';TKName:'saNetValue'),
                                                         (SQLName:'csdiscount';TKName:'saDiscount'),
                                                         (SQLName:'cs_vat_code';TKName:'saVATCode'),
                                                         (SQLName:'cs_cost';TKName:'CsCost'),
                                                         (SQLName:'cs_desc1';TKName:'CsDesc1'),
                                                         (SQLName:'cs_desc2';TKName:'CsDesc2'),
                                                         (SQLName:'cs_desc3';TKName:'CsDesc3'),
                                                         (SQLName:'cs_desc4';TKName:'CsDesc4'),
                                                         (SQLName:'cs_desc5';TKName:'CsDesc5'),
                                                         (SQLName:'cs_desc6';TKName:'CsDesc6'),
                                                         (SQLName:'cs_vat';TKName:'CsVAT'),
                                                         (SQLName:'cs_prx_pack';TKName:'CsPrxPack'),
                                                         (SQLName:'cs_qty_pack';TKName:'saQtyPack'),
                                                         (SQLName:'cs_qty_mul';TKName:'saQtyMul'),
                                                         (SQLName:'cs_disc_ch';TKName:'saDiscFlag'),
                                                         (SQLName:'cs_entered';TKName:'CsEntered'),
                                                         (SQLName:'cs_use_pack';TKName:'CsUsePack'),
                                                         (SQLName:'cs_show_case';TKName:'CsShowCase'),
                                                         (SQLName:'cs_line_type';TKName:'saLineType'),
                                                         (SQLName:'cs_price_mul_x';TKName:'CsPriceMulX'),
                                                         (SQLName:'cs_vat_inc_flg';TKName:'saInclusiveVATCode')
                                                        );
var
  i : integer;
  CurrentPrefix : String;
begin
  for i := 1 to NumberOfFields do
  begin
    if Trim(UpperCase(Value)) = Trim(UpperCase(FieldNames[i].TkName)) then
    begin
{      if i > NumberOfFixedFields then
        CurrentPrefix := 'TP'
      else}
        CurrentPrefix := '';
      Result := GetDBColumnName('CustomerStockAnalysis.Dat', FieldNames[i].SQLName, CurrentPrefix);
      Break;
    end;
  end;
end;
 
function TranslateTeleSRecField(const Value : string) : string;
const
  NumberOfFields = 47;
  NumberOfFixedFields = 5;
  FieldNames : Array[1..NumberOfFields] of TFieldName = (
                                                         (SQLName:'rec_pfix';TKName:'RecPfix'),
                                                         (SQLName:'sub_type';TKName:'SubType'),
                                                         (SQLName:'var_code1';TKName:'varCode1'),
                                                         (SQLName:'var_code2';TKName:'varCode2'),
                                                         (SQLName:'var_code3';TKName:'varCode3'),
                                                         (SQLName:'tc_cust_code';TKName:'TcCustCode'),
                                                         (SQLName:'tc_doc_type';TKName:'TcDocType'),
                                                         (SQLName:'tc_curr';TKName:'TcCurr'),
                                                         (SQLName:'tc_cx_rate1';TKName:'TcCXCompanyRate'),
                                                         (SQLName:'tc_cx_rate2';TKName:'TcCXDailyRate'),
                                                         (SQLName:'tc_old_your_ref';TKName:'TcOldYourRef'),
                                                         (SQLName:'tc_ly_ref';TKName:'TcLYRef'),
                                                         (SQLName:'tc_cc_dep1';TKName:'TcDepartment'),
                                                         (SQLName:'tc_cc_dep2';TKName:'TcCostCentre'),
                                                         (SQLName:'tc_loc_code';TKName:'TcLocCode'),
                                                         (SQLName:'tc_job_code';TKName:'TcJobCode'),
                                                         (SQLName:'tc_ja_code';TKName:'TcJACode'),
                                                         (SQLName:'tc_d_addr1';TKName:'TcDAddr1'),
                                                         (SQLName:'tc_d_addr2';TKName:'TcDAddr2'),
                                                         (SQLName:'tc_d_addr3';TKName:'TcDAddr3'),
                                                         (SQLName:'tc_d_addr4';TKName:'TcDAddr4'),
                                                         (SQLName:'tc_d_addr5';TKName:'TcDAddr5'),
                                                         (SQLName:'tc_t_date';TKName:'TcTDate'),
                                                         (SQLName:'tc_del_date';TKName:'TcDelDate'),
                                                         (SQLName:'tc_net_total';TKName:'TcNetTotal'),
                                                         (SQLName:'tc_vat_total';TKName:'TcVATTotal'),
                                                         (SQLName:'tc_disc_total';TKName:'TcDiscTotal'),
                                                         (SQLName:'tc_last_opo';TKName:'TcLastOpo'),
                                                         (SQLName:'tc_in_prog';TKName:'TcInProg'),
                                                         (SQLName:'tc_trans_nat';TKName:'TcTransNat'),
                                                         (SQLName:'tc_trans_mode';TKName:'TcTransMode'),
                                                         (SQLName:'tc_del_terms';TKName:'TcDelTerms'),
                                                         (SQLName:'tc_ctrl_code';TKName:'TcCtrlCode'),
                                                         (SQLName:'tc_vat_code';TKName:'TcVATCode'),
                                                         (SQLName:'tc_ord_mode';TKName:'TcOrdMode'),
                                                         (SQLName:'tc_scale_mode';TKName:'TcScaleMode'),
                                                         (SQLName:'tc_line_count';TKName:'TcLineCount'),
                                                         (SQLName:'tc_was_new';TKName:'TcWasNew'),
                                                         (SQLName:'tc_use_o_rate';TKName:'TcUseORate'),
                                                         (SQLName:'tc_def_nom_code';TKName:'TcDefNomCode'),
                                                         (SQLName:'tc_vat_inc_flg';TKName:'TcVATIncFlg'),
                                                         (SQLName:'tc_set_disc';TKName:'TcSetDisc'),
                                                         (SQLName:'tc_gen_mode';TKName:'TcGenMode'),
                                                         (SQLName:'tc_tag_no';TKName:'TcTagNo'),
                                                         (SQLName:'tc_lock_addr';TKName:'TcLockAddr'),
                                                         (SQLName:'spare2';TKName:'Spare2'),
                                                         (SQLName:'tc_your_ref';TKName:'TcYourRef')
                                                        );
var
  i : integer;
  CurrentPrefix : String;
begin
  for i := 1 to NumberOfFields do
  begin
    if Trim(UpperCase(Value)) = Trim(UpperCase(FieldNames[i].TkName)) then
    begin
      if i > NumberOfFixedFields then
        CurrentPrefix := 'TK'
      else
        CurrentPrefix := '';
      Result := GetDBColumnName('Mlocstk.dat', FieldNames[i].SQLName, CurrentPrefix);
      Break;
    end;
  end;
end;
 
function TranslateEMUCnvRecField(const Value : string) : string;
const
  NumberOfFields = 13;
  NumberOfFixedFields = 5;
  FieldNames : Array[1..NumberOfFields] of TFieldName = (
                                                         (SQLName:'rec_pfix';TKName:'RecPfix'),
                                                         (SQLName:'sub_type';TKName:'SubType'),
                                                         (SQLName:'var_code1';TKName:'varCode1'),
                                                         (SQLName:'var_code2';TKName:'varCode2'),
                                                         (SQLName:'var_code3';TKName:'varCode3'),
                                                         (SQLName:'em_was_curr';TKName:'EmWasCurr'),
                                                         (SQLName:'em_was_cx_rate1';TKName:'EmWasCXRate1'),
                                                         (SQLName:'em_was_cx_rate2';TKName:'EmWasCXRate2'),
                                                         (SQLName:'em_now_rate1';TKName:'EmNowRate1'),
                                                         (SQLName:'em_now_rate2';TKName:'EmNowRate2'),
                                                         (SQLName:'em_doc_ref';TKName:'EmDocRef'),
                                                         (SQLName:'em_nom_code';TKName:'EmNomCode'),
                                                         (SQLName:'em_orig_value';TKName:'EmOrigValue')
                                                        );
var
  i : integer;
  CurrentPrefix : String;
begin
  for i := 1 to NumberOfFields do
  begin
    if Trim(UpperCase(Value)) = Trim(UpperCase(FieldNames[i].TkName)) then
    begin
      if i > NumberOfFixedFields then
        CurrentPrefix := 'ED'
      else
        CurrentPrefix := '';
      Result := GetDBColumnName('Mlocstk.dat', FieldNames[i].SQLName, CurrentPrefix);
      Break;
    end;
  end;
end;
 
function TranslatePassDefRecField(const Value : string) : string;
const
  NumberOfFields = 30;
  NumberOfFixedFields = 5;
  FieldNames : Array[1..NumberOfFields] of TFieldName = (
                                                         (SQLName:'rec_pfix';TKName:'RecPfix'),
                                                         (SQLName:'sub_type';TKName:'SubType'),
                                                         (SQLName:'var_code1';TKName:'varCode1'),
                                                         (SQLName:'var_code2';TKName:'varCode2'),
                                                         (SQLName:'var_code3';TKName:'varCode3'),
                                                         (SQLName:'pw_exp_mode';TKName:'PWExpMode'),
                                                         (SQLName:'pw_exp_days';TKName:'PWExPDays'),
                                                         (SQLName:'pw_exp_date';TKName:'PWExpDate'),
                                                         (SQLName:'dir_cust';TKName:'DirCust'),
                                                         (SQLName:'dir_supp';TKName:'DirSupp'),
                                                         (SQLName:'max_sales_a';TKName:'MaxSalesA'),
                                                         (SQLName:'max_purch_a';TKName:'MaxPurchA'),
                                                         (SQLName:'cc_dep1';TKName:'Department'),
                                                         (SQLName:'cc_dep2';TKName:'CostCentre'),
                                                         (SQLName:'loc';TKName:'Loc'),
                                                         (SQLName:'sales_bank';TKName:'SalesBank'),
                                                         (SQLName:'purch_bank';TKName:'PurchBank'),
                                                         (SQLName:'report_prn';TKName:'ReportPrn'),
                                                         (SQLName:'form_prn';TKName:'FormPrn'),
                                                         (SQLName:'or_prns1';TKName:'OrPrns1'),
                                                         (SQLName:'or_prns2';TKName:'OrPrns2'),
                                                         (SQLName:'cc_dep_rule';TKName:'CCDepRule'),
                                                         (SQLName:'loc_rule';TKName:'LocRule'),
                                                         (SQLName:'email_addr';TKName:'EmailAddr'),
                                                         (SQLName:'pw_time_out';TKName:'PWTimeOut'),
                                                         (SQLName:'loaded';TKName:'Loaded'),
                                                         (SQLName:'user_name';TKName:'UserName'),
                                                         (SQLName:'uc_pr';TKName:'UCPr'),
                                                         (SQLName:'uc_yr';TKName:'UCYr'),
                                                         (SQLName:'udisp_pr_mnth';TKName:'UDispPrMnth')
                                                        );
var
  i : integer;
  CurrentPrefix : String;
begin
  for i := 1 to NumberOfFields do
  begin
    if Trim(UpperCase(Value)) = Trim(UpperCase(FieldNames[i].TkName)) then
    begin
      if i > NumberOfFixedFields then
        CurrentPrefix := 'PD'
      else
        CurrentPrefix := '';
      Result := GetDBColumnName('Mlocstk.dat', FieldNames[i].SQLName, CurrentPrefix);
      Break;
    end;
  end;
end;
 
function TranslateAllocCRecField(const Value : string) : string;
const
  NumberOfFields = 70;
  NumberOfFixedFields = 5;
  FieldNames : Array[1..NumberOfFields] of TFieldName = (
                                                         (SQLName:'rec_pfix';TKName:'RecPfix'),
                                                         (SQLName:'sub_type';TKName:'SubType'),
                                                         (SQLName:'var_code1';TKName:'varCode1'),
                                                         (SQLName:'var_code2';TKName:'varCode2'),
                                                         (SQLName:'var_code3';TKName:'varCode3'),
                                                         (SQLName:'arc_bank_nom';TKName:'ArcBankNom'),
                                                         (SQLName:'arc_ctrl_nom';TKName:'ArcCtrlNom'),
                                                         (SQLName:'arc_pay_curr';TKName:'ArcPayCurr'),
                                                         (SQLName:'arc_inv_curr';TKName:'ArcInvCurr'),
                                                         (SQLName:'spare1';TKName:'Spare1'),
                                                         (SQLName:'arc_cc_dep1';TKName:'ArcDepartment'),
                                                         (SQLName:'arc_cc_dep2';TKName:'ArcCostCentre'),
                                                         (SQLName:'arc_sort_by';TKName:'ArcSortBy'),
                                                         (SQLName:'arc_auto_total';TKName:'ArcAutoTotal'),
                                                         (SQLName:'arc_sd_days_over';TKName:'ArcSDDaysOver'),
                                                         (SQLName:'arc_from_trans';TKName:'ArcFromTrans'),
                                                         (SQLName:'arc_old_your_ref';TKName:'ArcOldYourRef'),
                                                         (SQLName:'arc_cheque_no2';TKName:'ArcChequeNo2'),
                                                         (SQLName:'spare3';TKName:'Spare3'),
                                                         (SQLName:'arc_force_new';TKName:'ArcForceNew'),
                                                         (SQLName:'arc_sort2_by';TKName:'ArcSort2By'),
                                                         (SQLName:'arc_total_own';TKName:'ArcTotalOwn'),
                                                         (SQLName:'arc_trans_value';TKName:'ArcTransValue'),
                                                         (SQLName:'arc_tag_count';TKName:'ArcTagCount'),
                                                         (SQLName:'arc_tag_run_date';TKName:'ArcTagRunDate'),
                                                         (SQLName:'arc_tag_run_yr';TKName:'ArcTagRunYr'),
                                                         (SQLName:'arc_tag_run_pr';TKName:'ArcTagRunPr'),
                                                         (SQLName:'arc_srcpi_ref';TKName:'ArcSRCPIRef'),
                                                         (SQLName:'arc_inc_sdisc';TKName:'ArcIncSDisc'),
                                                         (SQLName:'arc_total';TKName:'ArcTotal'),
                                                         (SQLName:'arc_variance';TKName:'ArcVariance'),
                                                         (SQLName:'arc_settle_d';TKName:'ArcSettleD'),
                                                         (SQLName:'arc_trans_date';TKName:'ArcTransDate'),
                                                         (SQLName:'arc_ud1';TKName:'ArcUD1'),
                                                         (SQLName:'arc_ud2';TKName:'ArcUD2'),
                                                         (SQLName:'arc_ud3';TKName:'ArcUD3'),
                                                         (SQLName:'arc_ud4';TKName:'ArcUD4'),
                                                         (SQLName:'arc_job_code';TKName:'ArcJobCode'),
                                                         (SQLName:'arc_anal_code';TKName:'ArcAnalCode'),
                                                         (SQLName:'arc_del_addr1';TKName:'ArcDelAddr1'),
                                                         (SQLName:'arc_del_addr2';TKName:'ArcDelAddr2'),
                                                         (SQLName:'arc_del_addr3';TKName:'ArcDelAddr3'),
                                                         (SQLName:'arc_del_addr4';TKName:'ArcDelAddr4'),
                                                         (SQLName:'arc_del_addr5';TKName:'ArcDelAddr5'),
                                                         (SQLName:'arc_inc_var';TKName:'ArcIncVar'),
                                                         (SQLName:'arc_our_ref';TKName:'ArcOurRef'),
                                                         (SQLName:'arc_cx_rate1';TKName:'ArcCompanyRate'),
                                                         (SQLName:'arc_cx_rate2';TKName:'ArcDailyRate'),
                                                         (SQLName:'arc_opo_name';TKName:'ArcOpoName'),
                                                         (SQLName:'arc_start_date';TKName:'ArcStartDate'),
                                                         (SQLName:'arc_start_time';TKName:'ArcStartTime'),
                                                         (SQLName:'arc_win_log_in';TKName:'ArcWinLogIn'),
                                                         (SQLName:'arc_locked';TKName:'ArcLocked'),
                                                         (SQLName:'arc_sales_mode';TKName:'ArcSalesMode'),
                                                         (SQLName:'arc_cust_code';TKName:'ArcCustCode'),
                                                         (SQLName:'arc_use_os_ndx';TKName:'ArcUseOSNdx'),
                                                         (SQLName:'arc_own_trans_value';TKName:'ArcOwnTransValue'),
                                                         (SQLName:'arc_own_settle_d';TKName:'ArcOwnSettleD'),
                                                         (SQLName:'arc_fin_var';TKName:'ArcFinVar'),
                                                         (SQLName:'arc_fin_set_d';TKName:'ArcFinSetD'),
                                                         (SQLName:'arc_sort_d';TKName:'ArcSortD'),
                                                         (SQLName:'spare4';TKName:'Spare4'),
                                                         (SQLName:'arc_alloc_full';TKName:'ArcAllocFull'),
                                                         (SQLName:'arc_check_fail';TKName:'ArcCheckFail'),
                                                         (SQLName:'arc_charge1_gl';TKName:'ArcCharge1GL'),
                                                         (SQLName:'arc_charge2_gl';TKName:'ArcCharge2GL'),
                                                         (SQLName:'arc_charge1_amt';TKName:'ArcCharge1Amt'),
                                                         (SQLName:'arc_charge2_amt';TKName:'ArcCharge2Amt'),
                                                         (SQLName:'spare';TKName:'Spare'),
                                                         (SQLName:'arc_your_ref';TKName:'ArcYourRef')
                                                        );
var
  i : integer;
  CurrentPrefix : String;
begin
  for i := 1 to NumberOfFields do
  begin
    if Trim(UpperCase(Value)) = Trim(UpperCase(FieldNames[i].TkName)) then
    begin
      if i > NumberOfFixedFields then
        CurrentPrefix := 'XC'
      else
        CurrentPrefix := '';
      Result := GetDBColumnName('Mlocstk.dat', FieldNames[i].SQLName, CurrentPrefix);
      Break;
    end;
  end;
end;
 
function TranslatebrBinRecField(const Value : string) : string;
const
  NumberOfFields = 43;
  NumberOfFixedFields = 5;
  FieldNames : Array[1..NumberOfFields] of TFieldName = (
                                                         (SQLName:'rec_pfix';TKName:'RecPfix'),
                                                         (SQLName:'sub_type';TKName:'SubType'),
                                                         (SQLName:'var_code1';TKName:'varCode1'),
                                                         (SQLName:'var_code2';TKName:'varCode2'),
                                                         (SQLName:'var_code3';TKName:'varCode3'),
                                                         (SQLName:'br_in_doc';TKName:'mbInDocRef'),
                                                         (SQLName:'br_out_doc';TKName:'mbOutDocRef'),
                                                         (SQLName:'br_sold';TKName:'mbSold'),
                                                         (SQLName:'br_date_in';TKName:'mbInDate'),
                                                         (SQLName:'br_bin_cost';TKName:'mbCostPrice'),
                                                         (SQLName:'br_bin_cap';TKName:'mbCapacity'),
                                                         (SQLName:'spare5';TKName:'Spare5'),
                                                         (SQLName:'br_stk_folio';TKName:'mbStkFolio'),
                                                         (SQLName:'br_date_out';TKName:'mbOutDate'),
                                                         (SQLName:'br_sold_line';TKName:'mbOutDocLine'),
                                                         (SQLName:'br_buy_line';TKName:'mbInDocLine'),
                                                         (SQLName:'br_batch_rec';TKName:'mbBatchRec'),
                                                         (SQLName:'br_buy_qty';TKName:'mbQty'),
                                                         (SQLName:'br_qty_used';TKName:'mbQtyUsed'),
                                                         (SQLName:'br_batch_child';TKName:'mbBatchChild'),
                                                         (SQLName:'br_in_mloc';TKName:'mbInLocation'),
                                                         (SQLName:'br_out_mloc';TKName:'mbOutLocation'),
                                                         (SQLName:'br_out_ord_doc';TKName:'mbOutOrderRef'),
                                                         (SQLName:'br_in_ord_doc';TKName:'mbInOrderRef'),
                                                         (SQLName:'br_in_ord_line';TKName:'mbInOrderLine'),
                                                         (SQLName:'br_out_ord_line';TKName:'mbOutOrderLine'),
                                                         (SQLName:'br_cur_cost';TKName:'mbCostPriceCurrency'),
                                                         (SQLName:'br_priority';TKName:'mbPickingPriority'),
                                                         (SQLName:'br_bin_sell';TKName:'mbSalesPrice'),
                                                         (SQLName:'br_Ser_CRates1';TKName:'brSerCompanyRate'),
                                                         (SQLName:'br_Ser_CRates2';TKName:'brSerDailyRate'),
                                                         (SQLName:'br_suse_o_rate';TKName:'mbSUseORate'),
                                                         (SQLName:'brSer_TriRates';TKName:'brSerTriRates'),
                                                         (SQLName:'brSer_TriEuro';TKName:'brSerTriEuro'),
                                                         (SQLName:'brSer_TriInvert';TKName:'brSerTriInvert'),
                                                         (SQLName:'brSer_TriFloat';TKName:'brSerTriFloat'),
                                                         (SQLName:'brSer_Spare';TKName:'brSerSpare'),
                                                         (SQLName:'br_date_use_x';TKName:'mbDateUseX'),
                                                         (SQLName:'br_cur_sell';TKName:'mbSalesPriceCurrency'),
                                                         (SQLName:'br_uom';TKName:'mbUnitOfMeasurement'),
                                                         (SQLName:'br_hold_flg';TKName:'brAutoPickMode'),
                                                         (SQLName:'br_tag_no';TKName:'mbTagNo'),
                                                         (SQLName:'br_return_bin';TKName:'mbReturnBin')
                                                        );
var
  i : integer;
  CurrentPrefix : String;
begin
  for i := 1 to NumberOfFields do
  begin
    if Trim(UpperCase(Value)) = Trim(UpperCase(FieldNames[i].TkName)) then
    begin
      if i > NumberOfFixedFields then
        CurrentPrefix := 'IR'
      else
        CurrentPrefix := '';
      Result := GetDBColumnName('Mlocstk.dat', FieldNames[i].SQLName, CurrentPrefix);
      Break;
    end;
  end;
end;
 
function TranslateBnkRHRecField(const Value : string) : string;
const
  NumberOfFields = 22;
  NumberOfFixedFields = 5;
  FieldNames : Array[1..NumberOfFields] of TFieldName = (
                                                         (SQLName:'rec_pfix';TKName:'RecPfix'),
                                                         (SQLName:'sub_type';TKName:'SubType'),
                                                         (SQLName:'var_code1';TKName:'varCode1'),
                                                         (SQLName:'var_code2';TKName:'varCode2'),
                                                         (SQLName:'var_code3';TKName:'varCode3'),
                                                         (SQLName:'br_stat_date';TKName:'BrStatDate'),
                                                         (SQLName:'br_stat_ref';TKName:'BrStatRef'),
                                                         (SQLName:'br_bank_acc';TKName:'BrBankAcc'),
                                                         (SQLName:'br_bank_currency';TKName:'BrBankCurrency'),
                                                         (SQLName:'br_bank_user_id';TKName:'BrBankUserID'),
                                                         (SQLName:'br_create_date';TKName:'BrCreateDate'),
                                                         (SQLName:'br_create_time';TKName:'BrCreateTime'),
                                                         (SQLName:'br_stat_bal';TKName:'BrStatBal'),
                                                         (SQLName:'br_open_bal';TKName:'BrOpenBal'),
                                                         (SQLName:'br_close_bal';TKName:'BrCloseBal'),
                                                         (SQLName:'br_status';TKName:'BrStatus'),
                                                         (SQLName:'br_int_ref';TKName:'BrIntRef'),
                                                         (SQLName:'br_glcode';TKName:'BrGLCode'),
                                                         (SQLName:'br_stat_folio';TKName:'BrStatFolio'),
                                                         (SQLName:'br_recon_date';TKName:'BrReconDate'),
                                                         (SQLName:'br_recon_ref';TKName:'BrReconRef'),
                                                         (SQLName:'br_init_seq';TKName:'BrInitSeq')
                                                        );
var
  i : integer;
  CurrentPrefix : String;
begin
  for i := 1 to NumberOfFields do
  begin
    if Trim(UpperCase(Value)) = Trim(UpperCase(FieldNames[i].TkName)) then
    begin
      if i > NumberOfFixedFields then
        CurrentPrefix := 'K1'
      else
        CurrentPrefix := '';
      Result := GetDBColumnName('Mlocstk.dat', FieldNames[i].SQLName, CurrentPrefix);
      Break;
    end;
  end;
end;
 
function TranslateBnkRDRecField(const Value : string) : string;
const
  NumberOfFields = 37;
  NumberOfFixedFields = 5;
  FieldNames : Array[1..NumberOfFields] of TFieldName = (
                                                         (SQLName:'rec_pfix';TKName:'RecPfix'),
                                                         (SQLName:'sub_type';TKName:'SubType'),
                                                         (SQLName:'var_code1';TKName:'varCode1'),
                                                         (SQLName:'var_code2';TKName:'varCode2'),
                                                         (SQLName:'var_code3';TKName:'varCode3'),
                                                         (SQLName:'br_pay_ref';TKName:'BrPayRef'),
                                                         (SQLName:'br_line_date';TKName:'BrLineDate'),
                                                         (SQLName:'br_match_ref';TKName:'BrMatchRef'),
                                                         (SQLName:'br_value';TKName:'BrValue'),
                                                         (SQLName:'br_line_no';TKName:'BrLineNo'),
                                                         (SQLName:'br_stat_id';TKName:'BrStatId'),
                                                         (SQLName:'br_stat_line';TKName:'BrStatLine'),
                                                         (SQLName:'br_cust_code';TKName:'BrCustCode'),
                                                         (SQLName:'br_period';TKName:'BrPeriod'),
                                                         (SQLName:'br_year';TKName:'BrYear'),
                                                         (SQLName:'br_CX_Rate1';TKName:'brCompanyRate'),
                                                         (SQLName:'br_CX_Rate2';TKName:'brDailyRate'),
                                                         (SQLName:'br_l_use_o_rate';TKName:'BrLUseORate'),
                                                         (SQLName:'brCur_TriRate';TKName:'brCurTriRate'),
                                                         (SQLName:'brCur_TriEuro';TKName:'brCurTriEuro'),
                                                         (SQLName:'brCur_TriInvert';TKName:'brCurTriInvert'),
                                                         (SQLName:'brCur_TriFloat';TKName:'brCurTriFloat'),
                                                         (SQLName:'brCur_Spare';TKName:'brCurSpare'),
                                                         (SQLName:'br_old_your_ref';TKName:'BrOldYourRef'),
                                                         (SQLName:'br_trans_value';TKName:'BrTransValue'),
                                                         (SQLName:'br_cc_dep1';TKName:'BrDepartment'),
                                                         (SQLName:'br_cc_dep2';TKName:'BrCostCentre'),
                                                         (SQLName:'br_nom_code';TKName:'BrNomCode'),
                                                         (SQLName:'br_sri_nom_code';TKName:'BrSRINomCode'),
                                                         (SQLName:'br_folio_link';TKName:'BrFolioLink'),
                                                         (SQLName:'br_vat_code';TKName:'BrVATCode'),
                                                         (SQLName:'br_vat_amount';TKName:'BrVATAmount'),
                                                         (SQLName:'br_trans_date';TKName:'BrTransDate'),
                                                         (SQLName:'br_is_new_trans';TKName:'BrIsNewTrans'),
                                                         (SQLName:'br_line_status';TKName:'BrLineStatus'),
                                                         (SQLName:'spare6';TKName:'Spare6'),
                                                         (SQLName:'br_your_ref';TKName:'BrYourRef')
                                                        );
var
  i : integer;
  CurrentPrefix : String;
begin
  for i := 1 to NumberOfFields do
  begin
    if Trim(UpperCase(Value)) = Trim(UpperCase(FieldNames[i].TkName)) then
    begin
      if i > NumberOfFixedFields then
        CurrentPrefix := 'K2'
      else
        CurrentPrefix := '';
      Result := GetDBColumnName('Mlocstk.dat', FieldNames[i].SQLName, CurrentPrefix);
      Break;
    end;
  end;
end;
 
function TranslateBACSDbRecField(const Value : string) : string;
const
  NumberOfFields = 25;
  NumberOfFixedFields = 5;
  FieldNames : Array[1..NumberOfFields] of TFieldName = (
                                                         (SQLName:'rec_pfix';TKName:'RecPfix'),
                                                         (SQLName:'sub_type';TKName:'SubType'),
                                                         (SQLName:'var_code1';TKName:'varCode1'),
                                                         (SQLName:'var_code2';TKName:'varCode2'),
                                                         (SQLName:'var_code3';TKName:'varCode3'),
                                                         (SQLName:'br_acc_nom';TKName:'BrAccNOM'),
                                                         (SQLName:'br_bank_prod';TKName:'BrBankProd'),
                                                         (SQLName:'br_pay_path';TKName:'BrPayPath'),
                                                         (SQLName:'br_pay_file_name';TKName:'BrPayFileName'),
                                                         (SQLName:'br_rec_file_name';TKName:'BrRecFileName'),
                                                         (SQLName:'br_stat_path';TKName:'BrStatPath'),
                                                         (SQLName:'br_swift_ref1';TKName:'BrSwiftRef1'),
                                                         (SQLName:'br_swift_ref2';TKName:'BrSwiftRef2'),
                                                         (SQLName:'br_swift_ref3';TKName:'BrSwiftRef3'),
                                                         (SQLName:'br_swift_bic';TKName:'BrSwiftBIC'),
                                                         (SQLName:'br_route_code';TKName:'BrRouteCode'),
                                                         (SQLName:'br_charge_inst';TKName:'BrChargeInst'),
                                                         (SQLName:'br_route_method';TKName:'BrRouteMethod'),
                                                         (SQLName:'br_last_use_date';TKName:'BrLastUseDate'),
                                                         (SQLName:'br_sort_code';TKName:'BrSortCode'),
                                                         (SQLName:'br_account_code';TKName:'BrAccountCode'),
                                                         (SQLName:'br_bank_ref';TKName:'BrBankRef'),
                                                         (SQLName:'br_bacs_user_id';TKName:'BrBACSUserID'),
                                                         (SQLName:'br_bacs_currency';TKName:'BrBACSCurrency'),
                                                         (SQLName:'br_user_id2';TKName:'BrUserID2')
                                                        );
var
  i : integer;
  CurrentPrefix : String;
begin
  for i := 1 to NumberOfFields do
  begin
    if Trim(UpperCase(Value)) = Trim(UpperCase(FieldNames[i].TkName)) then
    begin
      if i > NumberOfFixedFields then
        CurrentPrefix := 'K3'
      else
        CurrentPrefix := '';
      Result := GetDBColumnName('Mlocstk.dat', FieldNames[i].SQLName, CurrentPrefix);
      Break;
    end;
  end;
end;
 
function TranslateeBankHRecField(const Value : string) : string;
const
  NumberOfFields = 11;
  NumberOfFixedFields = 5;
  FieldNames : Array[1..NumberOfFields] of TFieldName = (
                                                         (SQLName:'rec_pfix';TKName:'RecPfix'),
                                                         (SQLName:'sub_type';TKName:'SubType'),
                                                         (SQLName:'var_code1';TKName:'varCode1'),
                                                         (SQLName:'var_code2';TKName:'varCode2'),
                                                         (SQLName:'var_code3';TKName:'varCode3'),
                                                         (SQLName:'eb_acc_nom';TKName:'EbAccNOM'),
                                                         (SQLName:'eb_stat_ref';TKName:'EbStatRef'),
                                                         (SQLName:'eb_stat_ind';TKName:'EbStatInd'),
                                                         (SQLName:'eb_source_file';TKName:'EbSourceFile'),
                                                         (SQLName:'eb_int_ref';TKName:'EbIntRef'),
                                                         (SQLName:'eb_stat_date';TKName:'EbStatDate')
                                                        );
var
  i : integer;
  CurrentPrefix : String;
begin
  for i := 1 to NumberOfFields do
  begin
    if Trim(UpperCase(Value)) = Trim(UpperCase(FieldNames[i].TkName)) then
    begin
      if i > NumberOfFixedFields then
        CurrentPrefix := 'K4'
      else
        CurrentPrefix := '';
      Result := GetDBColumnName('Mlocstk.dat', FieldNames[i].SQLName, CurrentPrefix);
      Break;
    end;
  end;
end;
 
function TranslateeBankLRecField(const Value : string) : string;
const
  NumberOfFields = 14;
  NumberOfFixedFields = 5;
  FieldNames : Array[1..NumberOfFields] of TFieldName = (
                                                         (SQLName:'rec_pfix';TKName:'RecPfix'),
                                                         (SQLName:'sub_type';TKName:'SubType'),
                                                         (SQLName:'var_code1';TKName:'varCode1'),
                                                         (SQLName:'var_code2';TKName:'varCode2'),
                                                         (SQLName:'var_code3';TKName:'varCode3'),
                                                         (SQLName:'eb_line_no';TKName:'EbLineNo'),
                                                         (SQLName:'eb_line_date';TKName:'EbLineDate'),
                                                         (SQLName:'eb_line_ref';TKName:'EbLineRef'),
                                                         (SQLName:'eb_line_value';TKName:'EbLineValue'),
                                                         (SQLName:'eb_line_int_ref';TKName:'EbLineIntRef'),
                                                         (SQLName:'eb_match_str';TKName:'EbMatchStr'),
                                                         (SQLName:'eb_glcode';TKName:'EbGLCode'),
                                                         (SQLName:'eb_line_ref2';TKName:'EbLineRef2'),
                                                         (SQLName:'eb_line_status';TKName:'EbLineStatus')
                                                        );
var
  i : integer;
  CurrentPrefix : String;
begin
  for i := 1 to NumberOfFields do
  begin
    if Trim(UpperCase(Value)) = Trim(UpperCase(FieldNames[i].TkName)) then
    begin
      if i > NumberOfFixedFields then
        CurrentPrefix := 'K5'
      else
        CurrentPrefix := '';
      Result := GetDBColumnName('Mlocstk.dat', FieldNames[i].SQLName, CurrentPrefix);
      Break;
    end;
  end;
end;
 
function TranslateNominalField(const Value : string) : string;
const
  NumberOfFields = 17;
  FieldNames : Array[1..NumberOfFields] of TFieldName = (
                                                         (SQLName:'f_nom_code';TKName:'glCode'),
                                                         (SQLName:'f_description';TKName:'glName'),
                                                         (SQLName:'f_category';TKName:'glParent'),
                                                         (SQLName:'f_nom_type';TKName:'glType'),
                                                         (SQLName:'f_nom_page';TKName:'glPage'),
                                                         (SQLName:'f_sub_type';TKName:'glSubtotal'),
                                                         (SQLName:'f_total';TKName:'glTotal'),
                                                         (SQLName:'f_carry_f';TKName:'glCarryFwd'),
                                                         (SQLName:'f_re_value';TKName:'glRevalue'),
                                                         (SQLName:'f_alt_code';TKName:'glAltCode'),
                                                         (SQLName:'f_private_rec';TKName:'glPrivateRec'),
                                                         (SQLName:'f_def_curr';TKName:'glCurrency'),
                                                         (SQLName:'f_force_jc';TKName:'glForceJobCode'),
                                                         (SQLName:'f_hide_ac';TKName:'glInactive'),
                                                         (SQLName:'f_nom_class';TKName:'glClass'),
                                                         (SQLName:'f_spare';TKName:'glSpare'),
                                                         (SQLName:'f_nom_str';TKName:'glNomStr')
                                                        );
var
  i : integer;
begin
  for i := 1 to NumberOfFields do
  begin
    if Trim(UpperCase(Value)) = Trim(UpperCase(FieldNames[i].TkName)) then
    begin
      Result := GetDBColumnName('Nominal.dat', FieldNames[i].SQLName, '');
      Break;
    end;
  end;
end;
 
function TranslateNomViewTypeField(const Value : string) : string;
const
  NumberOfFields = 24;
  NumberOfFixedFields = 8;
  FieldNames : Array[1..NumberOfFields] of TFieldName = (
                                                         (SQLName:'rec_pfix';TKName:'RecPfix'),
                                                         (SQLName:'sub_type';TKName:'SubType'),
                                                         (SQLName:'nvc_code1';TKName:'VCCode1'),
                                                         (SQLName:'nvc_code2';TKName:'VCCode2'),
                                                         (SQLName:'nvc_code3';TKName:'VCCode3'),
                                                         (SQLName:'nvc_code4';TKName:'VCCode4'),
                                                         (SQLName:'nom_view_no_index_lint';TKName:'NomViewNo'),
                                                         (SQLName:'nvc_code5';TKName:'nvc_code5'),
                                                         (SQLName:'view_code';TKName:'ViewCode'),
                                                         (SQLName:'view_idx';TKName:'ViewIdx'),
                                                         (SQLName:'view_cat';TKName:'ViewCat'),
                                                         (SQLName:'view_type';TKName:'ViewType'),
                                                         (SQLName:'carry_f';TKName:'CarryF'),
                                                         (SQLName:'alt_code';TKName:'AltCode'),
                                                         (SQLName:'link_view';TKName:'LinkView'),
                                                         (SQLName:'link_gl';TKName:'LinkGL'),
                                                         (SQLName:'link_cc_dep1';TKName:'LinkDepartment'),
                                                         (SQLName:'link_cc_dep2';TKName:'LinkCostCentre'),
                                                         (SQLName:'inc_budget';TKName:'IncBudget'),
                                                         (SQLName:'inc_commit';TKName:'IncCommit'),
                                                         (SQLName:'inc_unposted';TKName:'IncUnposted'),
                                                         (SQLName:'auto_desc';TKName:'AutoDesc'),
                                                         (SQLName:'link_type';TKName:'LinkType'),
                                                         (SQLName:'abs_view_idx';TKName:'ABSViewIdx')
                                                        );
var
  i : integer;
  CurrentPrefix : String;
begin
  for i := 1 to NumberOfFields do
  begin
    if Trim(UpperCase(Value)) = Trim(UpperCase(FieldNames[i].TkName)) then
    begin
      if i > NumberOfFixedFields then
        CurrentPrefix := 'NV'
      else
        CurrentPrefix := '';
      Result := GetDBColumnName('Nomview.dat', FieldNames[i].SQLName, CurrentPrefix);
      Break;
    end;
  end;
end;
 
function TranslateViewCtrlTypeField(const Value : string) : string;
const
  NumberOfFields = 30;
  NumberOfFixedFields = 8;
  FieldNames : Array[1..NumberOfFields] of TFieldName = (
                                                         (SQLName:'rec_pfix';TKName:'RecPfix'),
                                                         (SQLName:'sub_type';TKName:'SubType'),
                                                         (SQLName:'nvc_code1';TKName:'VCCode1'),
                                                         (SQLName:'nvc_code2';TKName:'VCCode2'),
                                                         (SQLName:'nvc_code3';TKName:'VCCode3'),
                                                         (SQLName:'nvc_code4';TKName:'VCCode4'),
                                                         (SQLName:'nom_view_no_index_lint';TKName:'NomViewNo'),
                                                         (SQLName:'nvc_code5';TKName:'nvc_code5'),
                                                         (SQLName:'def_curr';TKName:'DefCurr'),
                                                         (SQLName:'def_period';TKName:'DefPeriod'),
                                                         (SQLName:'def_period_to';TKName:'DefPeriodTo'),
                                                         (SQLName:'def_year';TKName:'DefYear'),
                                                         (SQLName:'view_ctrl_no';TKName:'ViewCtrlNo'),
                                                         (SQLName:'last_period';TKName:'LastPeriod'),
                                                         (SQLName:'last_year';TKName:'LastYear'),
                                                         (SQLName:'ctrl_cc_dep1';TKName:'CtrlDepartment'),
                                                         (SQLName:'ctrl_cc_dep2';TKName:'CtrlCostCentre'),
                                                         (SQLName:'ctrl_budget';TKName:'CtrlBudget'),
                                                         (SQLName:'ctrl_commit';TKName:'CtrlCommit'),
                                                         (SQLName:'ctrl_unposted';TKName:'CtrlUnposted'),
                                                         (SQLName:'auto_struct';TKName:'AutoStruct'),
                                                         (SQLName:'last_prun_no';TKName:'LastPRunNo'),
                                                         (SQLName:'spare_pad';TKName:'SparePad'),
                                                         (SQLName:'last_update';TKName:'LastUpdate'),
                                                         (SQLName:'last_opo';TKName:'LastOpo'),
                                                         (SQLName:'in_active';TKName:'InActive'),
                                                         (SQLName:'def_curr_tx';TKName:'DefCurrTx'),
                                                         (SQLName:'def_ytd';TKName:'DefYTD'),
                                                         (SQLName:'def_use_f6';TKName:'DefUseF6'),
                                                         (SQLName:'loaded_ok';TKName:'LoadedOk')
                                                        );
var
  i : integer;
  CurrentPrefix : String;
begin
  for i := 1 to NumberOfFields do
  begin
    if Trim(UpperCase(Value)) = Trim(UpperCase(FieldNames[i].TkName)) then
    begin
      if i > NumberOfFixedFields then
        CurrentPrefix := 'NC'
      else
        CurrentPrefix := '';
      Result := GetDBColumnName('Nomview.dat', FieldNames[i].SQLName, CurrentPrefix);
      Break;
    end;
  end;
end;
 
function TranslatePAAUTHField(const Value : string) : string;
const
  NumberOfFields = 18;
  FieldNames : Array[1..NumberOfFields] of TFieldName = (
                                                         (SQLName:'Company';TKName:'Company'),
                                                         (SQLName:'auName';TKName:'auName'),
                                                         (SQLName:'auMaxAuthAmount';TKName:'auMaxAuthAmount'),
                                                         (SQLName:'auEndAmountchar';TKName:'auEndAmountchar'),
                                                         (SQLName:'auEMail';TKName:'auEMail'),
                                                         (SQLName:'auAuthCode';TKName:'auAuthCode'),
                                                         (SQLName:'auAuthSQU';TKName:'auAuthSQU'),
                                                         (SQLName:'auAuthPQU';TKName:'auAuthPQU'),
                                                         (SQLName:'auAuthPOR';TKName:'auAuthPOR'),
                                                         (SQLName:'auAuthPIN';TKName:'auAuthPIN'),
                                                         (SQLName:'Active';TKName:'Active'),
                                                         (SQLName:'auApprovalOnly';TKName:'auApprovalOnly'),
                                                         (SQLName:'auCompressAttachments';TKName:'auCompressAttachments'),
                                                         (SQLName:'auDefaultAuth';TKName:'auDefaultAuth'),
                                                         (SQLName:'auAlternate';TKName:'auAlternate'),
                                                         (SQLName:'auAltAfter';TKName:'auAltAfter'),
                                                         (SQLName:'auAltHours';TKName:'auAltHours'),
                                                         (SQLName:'auDisplayEmail';TKName:'auDisplayEmail')
                                                        );
var
  i : integer;
begin
  for i := 1 to NumberOfFields do
  begin
    if Trim(UpperCase(Value)) = Trim(UpperCase(FieldNames[i].TkName)) then
    begin
      Result := GetDBColumnName('PAAUTH.dat', FieldNames[i].SQLName, '');
      Break;
    end;
  end;
end;
 
function TranslatePACOMPField(const Value : string) : string;
const
  NumberOfFields = 16;
  FieldNames : Array[1..NumberOfFields] of TFieldName = (
                                                         (SQLName:'company';TKName:'company'),
                                                         (SQLName:'spauthsqu';TKName:'spauthsqu'),
                                                         (SQLName:'spauthpqu';TKName:'spauthpqu'),
                                                         (SQLName:'spauthpor';TKName:'spauthpor'),
                                                         (SQLName:'spauthpin';TKName:'spauthpin'),
                                                         (SQLName:'spsquform';TKName:'spsquform'),
                                                         (SQLName:'sppquform';TKName:'sppquform'),
                                                         (SQLName:'spporform';TKName:'spporform'),
                                                         (SQLName:'sppinform';TKName:'sppinform'),
                                                         (SQLName:'spauthmode';TKName:'spauthmode'),
                                                         (SQLName:'spallowprint';TKName:'spallowprint'),
                                                         (SQLName:'spflooronpins';TKName:'spflooronpins'),
                                                         (SQLName:'spauthonconvert';TKName:'spauthonconvert'),
                                                         (SQLName:'sppintolerance';TKName:'sppintolerance'),
                                                         (SQLName:'splastpincheck';TKName:'splastpincheck'),
                                                         (SQLName:'sppincheckinterval';TKName:'sppincheckinterval')
                                                        );
var
  i : integer;
begin
  for i := 1 to NumberOfFields do
  begin
    if Trim(UpperCase(Value)) = Trim(UpperCase(FieldNames[i].TkName)) then
    begin
      Result := GetDBColumnName('PACOMP.dat', FieldNames[i].SQLName, '');
      Break;
    end;
  end;
end;
 
function TranslatePAEARField(const Value : string) : string;
const
  NumberOfFields = 18;
  FieldNames : Array[1..NumberOfFields] of TFieldName = (
                                                         (SQLName:'Company';TKName:'Company'),
                                                         (SQLName:'reEAR';TKName:'reEAR'),
                                                         (SQLName:'reOurRef';TKName:'reOurRef'),
                                                         (SQLName:'reUserID';TKName:'reUserID'),
                                                         (SQLName:'reTimeStamp';TKName:'reTimeStamp'),
                                                         (SQLName:'reTotalValue';TKName:'reTotalValue'),
                                                         (SQLName:'reStatus';TKName:'reStatus'),
                                                         (SQLName:'reApprovedBy';TKName:'reApprovedBy'),
                                                         (SQLName:'reAuthoriser';TKName:'reAuthoriser'),
                                                         (SQLName:'reFolio';TKName:'reFolio'),
                                                         (SQLName:'reDocType';TKName:'reDocType'),
                                                         (SQLName:'reSupplier';TKName:'reSupplier'),
                                                         (SQLName:'reLineCount';TKName:'reLineCount'),
                                                         (SQLName:'reCheckSum';TKName:'reCheckSum'),
                                                         (SQLName:'reApprovalDateTime';TKName:'reApprovalDateTime'),
                                                         (SQLName:'reAdminNotified';TKName:'reAdminNotified'),
                                                         (SQLName:'reAlreadySent';TKName:'reAlreadySent'),
                                                         (SQLName:'rePrevDate';TKName:'rePrevDate')
                                                        );
var
  i : integer;
begin
  for i := 1 to NumberOfFields do
  begin
    if Trim(UpperCase(Value)) = Trim(UpperCase(FieldNames[i].TkName)) then
    begin
      Result := GetDBColumnName('PAEAR.dat', FieldNames[i].SQLName, '');
      Break;
    end;
  end;
end;
 
function TranslatePAGLOBALField(const Value : string) : string;
const
  NumberOfFields = 12;
  FieldNames : Array[1..NumberOfFields] of TFieldName = (
                                                         (SQLName:'spCompany';TKName:'spCompany'),
                                                         (SQLName:'spFrequency';TKName:'spFrequency'),
                                                         (SQLName:'spAccountName';TKName:'spAccountName'),
                                                         (SQLName:'spAccountPWord';TKName:'spAccountPWord'),
                                                         (SQLName:'spEMail';TKName:'spEMail'),
                                                         (SQLName:'spAdminEMail';TKName:'spAdminEMail'),
                                                         (SQLName:'spOfflineStart';TKName:'spOfflineStart'),
                                                         (SQLName:'spOfflineFinish';TKName:'spOfflineFinish'),
                                                         (SQLName:'spEARTimeOut';TKName:'spEARTimeOut'),
                                                         (SQLName:'spPassword';TKName:'spPassword'),
                                                         (SQLName:'spServer';TKName:'spServer'),
                                                         (SQLName:'spUseMapi';TKName:'spUseMapi')
                                                        );
var
  i : integer;
begin
  for i := 1 to NumberOfFields do
  begin
    if Trim(UpperCase(Value)) = Trim(UpperCase(FieldNames[i].TkName)) then
    begin
      Result := GetDBColumnName('PAGLOBAL.dat', FieldNames[i].SQLName, '');
      Break;
    end;
  end;
end;
 
function TranslatePapersizeField(const Value : string) : string;
const
  NumberOfFields = 8;
  FieldNames : Array[1..NumberOfFields] of TFieldName = (
                                                         (SQLName:'f_ps_user';TKName:'psUser'),
                                                         (SQLName:'f_ps_descr';TKName:'psDescr'),
                                                         (SQLName:'f_ps_height';TKName:'psHeight'),
                                                         (SQLName:'f_ps_width';TKName:'psWidth'),
                                                         (SQLName:'f_ps_top_waste';TKName:'psTopWaste'),
                                                         (SQLName:'f_ps_bottom_waste';TKName:'psBottomWaste'),
                                                         (SQLName:'f_ps_left_waste';TKName:'psLeftWaste'),
                                                         (SQLName:'f_ps_right_waste';TKName:'psRightWaste')
                                                        );
var
  i : integer;
begin
  for i := 1 to NumberOfFields do
  begin
    if Trim(UpperCase(Value)) = Trim(UpperCase(FieldNames[i].TkName)) then
    begin
      Result := GetDBColumnName('Papersize.dat', FieldNames[i].SQLName, '');
      Break;
    end;
  end;
end;
 
function TranslatePAUSERField(const Value : string) : string;
const
  NumberOfFields = 9;
  FieldNames : Array[1..NumberOfFields] of TFieldName = (
                                                         (SQLName:'usCompany';TKName:'usCompany'),
                                                         (SQLName:'usUserID';TKName:'usUserID'),
                                                         (SQLName:'usUserName';TKName:'usUserName'),
                                                         (SQLName:'usEMail';TKName:'usEMail'),
                                                         (SQLName:'usFloorLimit';TKName:'usFloorLimit'),
                                                         (SQLName:'usAuthAmount';TKName:'usAuthName'),
                                                         (SQLName:'usSendOptions';TKName:'usSendOptions'),
                                                         (SQLName:'usDefaultApprover';TKName:'usDefaultApprover'),
                                                         (SQLName:'usDefaultAuthoriser';TKName:'usDefaultAuthoriser')
                                                        );
var
  i : integer;
begin
  for i := 1 to NumberOfFields do
  begin
    if Trim(UpperCase(Value)) = Trim(UpperCase(FieldNames[i].TkName)) then
    begin
      Result := GetDBColumnName('PAUSER.dat', FieldNames[i].SQLName, '');
      Break;
    end;
  end;
end;
 
function TranslatePPCUSTField(const Value : string) : string;
const
  NumberOfFields = 13;
  FieldNames : Array[1..NumberOfFields] of TFieldName = (
                                                         (SQLName:'ppcCustCode';TKName:'ppcCustCode'),
                                                         (SQLName:'ppcDefaultRate';TKName:'ppcDefaultRate'),
                                                         (SQLName:'ppcInterestVariance';TKName:'ppcInterestVariance'),
                                                         (SQLName:'ppcCreditDaysOffset';TKName:'ppcCreditDaysOffset'),
                                                         (SQLName:'ppcMinInvoiceValue';TKName:'ppcMinInvoiceValue'),
                                                         (SQLName:'ppcInterestGLCode';TKName:'ppcInterestGLCode'),
                                                         (SQLName:'ppcDebtChargeGLCode';TKName:'ppcDebtChargeGLCode'),
                                                         (SQLName:'ppcCostCentre';TKName:'ppcCostCentre'),
                                                         (SQLName:'ppcDepartment';TKName:'ppcDepartment'),
                                                         (SQLName:'ppcDebitChargeBasis';TKName:'ppcDebitChargeBasis'),
                                                         (SQLName:'ppcActive';TKName:'ppcActive'),
                                                         (SQLName:'ppcSyncGLCodes';TKName:'ppcSyncGLCodes'),
                                                         (SQLName:'ppcDummyChar';TKName:'ppcDummyChar')
                                                        );
var
  i : integer;
begin
  for i := 1 to NumberOfFields do
  begin
    if Trim(UpperCase(Value)) = Trim(UpperCase(FieldNames[i].TkName)) then
    begin
      Result := GetDBColumnName('PPCUST.dat', FieldNames[i].SQLName, '');
      Break;
    end;
  end;
end;
 
function TranslatePPDEBTField(const Value : string) : string;
const
  NumberOfFields = 7;
  FieldNames : Array[1..NumberOfFields] of TFieldName = (
                                                         (SQLName:'ppdFolioNo';TKName:'ppdFolioNo'),
                                                         (SQLName:'ppdCustCode';TKName:'ppdCustCode'),
                                                         (SQLName:'ppdValueFrom';TKName:'ppdValueFrom'),
                                                         (SQLName:'ppdValueTo';TKName:'ppdValueTo'),
                                                         (SQLName:'ppdCharge';TKName:'ppdCharge'),
                                                         (SQLName:'ppdDummyChar';TKName:'ppdDummyChar'),
                                                         (SQLName:'ppdSpare';TKName:'ppdSpare')
                                                        );
var
  i : integer;
begin
  for i := 1 to NumberOfFields do
  begin
    if Trim(UpperCase(Value)) = Trim(UpperCase(FieldNames[i].TkName)) then
    begin
      Result := GetDBColumnName('PPDEBT.dat', FieldNames[i].SQLName, '');
      Break;
    end;
  end;
end;
 
function TranslatePPSETUPField(const Value : string) : string;
const
  NumberOfFields = 5;
  FieldNames : Array[1..NumberOfFields] of TFieldName = (
                                                         (SQLName:'ppsfoliono';TKName:'ppsfoliono'),
                                                         (SQLName:'ppsdaysfield';TKName:'ppsdaysfield'),
                                                         (SQLName:'ppsholdflagfield';TKName:'ppsholdflagfield'),
                                                         (SQLName:'ppsdummychar';TKName:'ppsdummychar'),
                                                         (SQLName:'ppsbaseinterestonduedate';TKName:'ppsbaseinterestonduedate')
                                                        );
var
  i : integer;
begin
  for i := 1 to NumberOfFields do
  begin
    if Trim(UpperCase(Value)) = Trim(UpperCase(FieldNames[i].TkName)) then
    begin
      Result := GetDBColumnName('PPSETUP.dat', FieldNames[i].SQLName, '');
      Break;
    end;
  end;
end;
 
function TranslateReportsField(const Value : string) : string;
const
  NumberOfFields = 5;
  FieldNames : Array[1..NumberOfFields] of TFieldName = (
                                                         (SQLName:'f_field_1';TKName:'f_field_1'),
                                                         (SQLName:'f_field_3';TKName:'f_field_3'),
                                                         (SQLName:'f_field_4';TKName:'f_field_4'),
                                                         (SQLName:'f_field_24';TKName:'f_field_24'),
                                                         (SQLName:'f_field_51';TKName:'f_field_51')
                                                        );
var
  i : integer;
begin
  for i := 1 to NumberOfFields do
  begin
    if Trim(UpperCase(Value)) = Trim(UpperCase(FieldNames[i].TkName)) then
    begin
      Result := GetDBColumnName('Reports.dat', FieldNames[i].SQLName, '');
      Break;
    end;
  end;
end;
 
function TranslateSALECODEField(const Value : string) : string;
const
  NumberOfFields = 14;
  FieldNames : Array[1..NumberOfFields] of TFieldName = (
                                                         (SQLName:'scFolioNo';TKName:'scFolioNo'),
                                                         (SQLName:'scSalesCode';TKName:'scSalesCode'),
                                                         (SQLName:'scDescription';TKName:'scDescription'),
                                                         (SQLName:'scSalesCodeType';TKName:'scSalesCodeType'),
                                                         (SQLName:'scDefCommissionBasis';TKName:'scDefCommissionBasis'),
                                                         (SQLName:'scStatus';TKName:'scStatus'),
                                                         (SQLName:'scEntSupplierCode';TKName:'scEntSupplierCode'),
                                                         (SQLName:'scEntGLCode';TKName:'scEntGLCode'),
                                                         (SQLName:'scEntCostCentre';TKName:'scEntCostCentre'),
                                                         (SQLName:'scEntDepartment';TKName:'scEntDepartment'),
                                                         (SQLName:'scEntInvCurrency';TKName:'scEntInvCurrency'),
                                                         (SQLName:'scDefCommission';TKName:'scDefCommission'),
                                                         (SQLName:'scDefCommissionType';TKName:'scDefCommissionType'),
                                                         (SQLName:'scDummyChar';TKName:'scDummyChar')
                                                        );
var
  i : integer;
begin
  for i := 1 to NumberOfFields do
  begin
    if Trim(UpperCase(Value)) = Trim(UpperCase(FieldNames[i].TkName)) then
    begin
      Result := GetDBColumnName('SALECODE.dat', FieldNames[i].SQLName, '');
      Break;
    end;
  end;
end;
 
function TranslateSCHEDCFGField(const Value : string) : string;
const
  NumberOfFields = 4;
  FieldNames : Array[1..NumberOfFields] of TFieldName = (
                                                         (SQLName:'scid';TKName:'scid'),
                                                         (SQLName:'scofflinestart';TKName:'scofflinestart'),
                                                         (SQLName:'scofflineend';TKName:'scofflineend'),
                                                         (SQLName:'scdefaultemail';TKName:'scdefaultemail')
                                                        );
var
  i : integer;
begin
  for i := 1 to NumberOfFields do
  begin
    if Trim(UpperCase(Value)) = Trim(UpperCase(FieldNames[i].TkName)) then
    begin
      Result := GetDBColumnName('SCHEDCFG.dat', FieldNames[i].SQLName, '');
      Break;
    end;
  end;
end;
 
function TranslateSCHEDULEField(const Value : string) : string;
const
  NumberOfFields = 20;
  FieldNames : Array[1..NumberOfFields] of TFieldName = (
                                                         (SQLName:'sttasktype';TKName:'sttasktype'),
                                                         (SQLName:'sttaskname';TKName:'sttaskname'),
                                                         (SQLName:'stnextrundue';TKName:'stnextrundue'),
                                                         (SQLName:'sttaskid';TKName:'sttaskid'),
                                                         (SQLName:'stscheduletype';TKName:'stscheduletype'),
                                                         (SQLName:'stdaynumber';TKName:'stdaynumber'),
                                                         (SQLName:'sttimeofday';TKName:'sttimeofday'),
                                                         (SQLName:'stinterval';TKName:'stinterval'),
                                                         (SQLName:'ststarttime';TKName:'ststarttime'),
                                                         (SQLName:'stendtime';TKName:'stendtime'),
                                                         (SQLName:'ststatus';TKName:'ststatus'),
                                                         (SQLName:'stemailaddress';TKName:'stemailaddress'),
                                                         (SQLName:'stlastrun';TKName:'stlastrun'),
                                                         (SQLName:'stlastupdated';TKName:'stlastupdated'),
                                                         (SQLName:'stlastupdatedby';TKName:'stlastupdatedby'),
                                                         (SQLName:'sttimetype';TKName:'sttimetype'),
                                                         (SQLName:'stincludeinPost';TKName:'stincludeinPost'),
                                                         (SQLName:'stpostprotected';TKName:'stpostprotected'),
                                                         (SQLName:'stpostseparated';TKName:'stpostseparated'),
                                                         (SQLName:'stcustomclassName';TKName:'stcustomclassName')
                                                        );
var
  i : integer;
begin
  for i := 1 to NumberOfFields do
  begin
    if Trim(UpperCase(Value)) = Trim(UpperCase(FieldNames[i].TkName)) then
    begin
      Result := GetDBColumnName('SCHEDULE.dat', FieldNames[i].SQLName, '');
      Break;
    end;
  end;
end;
 
function TranslateSCTYPEField(const Value : string) : string;
const
  NumberOfFields = 3;
  FieldNames : Array[1..NumberOfFields] of TFieldName = (
                                                         (SQLName:'sctFolioNo';TKName:'sctFolioNo'),
                                                         (SQLName:'sctDescription';TKName:'sctDescription'),
                                                         (SQLName:'sctDummyChar';TKName:'sctDummyChar')
                                                        );
var
  i : integer;
begin
  for i := 1 to NumberOfFields do
  begin
    if Trim(UpperCase(Value)) = Trim(UpperCase(FieldNames[i].TkName)) then
    begin
      Result := GetDBColumnName('SCTYPE.dat', FieldNames[i].SQLName, '');
      Break;
    end;
  end;
end;
 
function TranslateSentField(const Value : string) : string;
const
  NumberOfFields = 105;
  FieldNames : Array[1..NumberOfFields] of TFieldName = (
                                                         (SQLName:'f_not_used';TKName:'elNotUsed'),
                                                         (SQLName:'f_el_user_id';TKName:'elUserID'),
                                                         (SQLName:'f_el_elert_name';TKName:'elName'),
                                                         (SQLName:'f_f_el_type';TKName:'elType'),
                                                         (SQLName:'f_f_el_priority';TKName:'elPriority'),
                                                         (SQLName:'f_el_window_id';TKName:'elWindowID'),
                                                         (SQLName:'f_el_handler_id';TKName:'elHandlerID'),
                                                         (SQLName:'f_el_term_char';TKName:'elTermChar'),
                                                         (SQLName:'f_el_description';TKName:'elDescription'),
                                                         (SQLName:'f_el_active';TKName:'elActive'),
                                                         (SQLName:'f_el_time_type';TKName:'elTimeType'),
                                                         (SQLName:'f_el_frequency';TKName:'elFrequency'),
                                                         (SQLName:'f_el_time1';TKName:'elTime1'),
                                                         (SQLName:'f_el_time2';TKName:'elTime2'),
                                                         (SQLName:'f_el_days_of_week';TKName:'elDaysOfWeek'),
                                                         (SQLName:'f_el_fileno';TKName:'elFileno'),
                                                         (SQLName:'f_el_index_no';TKName:'elIndexNo'),
                                                         (SQLName:'f_range_start_eg_type';TKName:'elRangeStartEgType'),
                                                         (SQLName:'f_range_start_eg_string';TKName:'elRangeStartEgString'),
                                                         (SQLName:'f_range_start_eg_int';TKName:'elRangeStartEgInt'),
                                                         (SQLName:'f_range_start_eg_offset';TKName:'elRangeStartEgOffset'),
                                                         (SQLName:'f_range_start_eg_input';TKName:'elRangeStartEgInput'),
                                                         (SQLName:'f_range_start_spare';TKName:'elRangeStartSpare'),
                                                         (SQLName:'f_range_end_eg_type';TKName:'elRangeEndEgType'),
                                                         (SQLName:'f_range_end_eg_string';TKName:'elRangeEndEgString'),
                                                         (SQLName:'f_range_end_eg_int';TKName:'elRangeEndEgInt'),
                                                         (SQLName:'f_range_end_eg_offset';TKName:'elRangeEndEgOffset'),
                                                         (SQLName:'f_range_end_eg_input';TKName:'elRangeEndEgInput'),
                                                         (SQLName:'f_range_end_spare';TKName:'elRangeEndSpare'),
                                                         (SQLName:'f_ea_email';TKName:'elEmail'),
                                                         (SQLName:'f_ea_sms';TKName:'elSMS'),
                                                         (SQLName:'f_ea_report';TKName:'elReport'),
                                                         (SQLName:'f_ea_csv';TKName:'elCSV'),
                                                         (SQLName:'f_ea_rep_email';TKName:'elRepEmail'),
                                                         (SQLName:'f_ea_rep_fax';TKName:'elRepFax'),
                                                         (SQLName:'f_ea_rep_printer';TKName:'elRepPrinter'),
                                                         (SQLName:'f_spare';TKName:'elSpare'),
                                                         (SQLName:'f_el_expiration';TKName:'elExpiration'),
                                                         (SQLName:'f_el_expiration_date';TKName:'elExpirationDate'),
                                                         (SQLName:'f_el_repeat_period';TKName:'elRepeatPeriod'),
                                                         (SQLName:'f_el_repeat_data';TKName:'elRepeatData'),
                                                         (SQLName:'f_el_email_report';TKName:'elEmailReport'),
                                                         (SQLName:'f_el_last_date_run';TKName:'elLastDateRun'),
                                                         (SQLName:'f_el_next_run_due';TKName:'elNextRunDue'),
                                                         (SQLName:'f_el_report_name';TKName:'elReportName'),
                                                         (SQLName:'f_el_event_index';TKName:'elEventIndex'),
                                                         (SQLName:'f_el_run_on_startup';TKName:'elRunOnStartup'),
                                                         (SQLName:'f_el_email_csv';TKName:'elEmailCSV'),
                                                         (SQLName:'f_el_status';TKName:'elStatus'),
                                                         (SQLName:'f_el_parent';TKName:'elParent'),
                                                         (SQLName:'f_el_start_date';TKName:'elStartDate'),
                                                         (SQLName:'f_el_delete_on_expiry';TKName:'elDeleteOnExpiry'),
                                                         (SQLName:'f_el_periodic';TKName:'elPeriodic'),
                                                         (SQLName:'f_el_trigger_count';TKName:'elTriggerCount'),
                                                         (SQLName:'f_el_days_between';TKName:'elDaysBetween'),
                                                         (SQLName:'f_el_expired';TKName:'elExpired'),
                                                         (SQLName:'f_el_run_now';TKName:'elRunNow'),
                                                         (SQLName:'f_el_instance';TKName:'elInstance'),
                                                         (SQLName:'f_el_msg_instance';TKName:'elMsgInstance'),
                                                         (SQLName:'f_el_single_email';TKName:'elSingleEmail'),
                                                         (SQLName:'f_el_prev_status';TKName:'elPrevStatus'),
                                                         (SQLName:'f_el_single_sms';TKName:'elSingleSMS'),
                                                         (SQLName:'f_el_triggered';TKName:'elTriggered'),
                                                         (SQLName:'f_el_sms_tries';TKName:'elSMSTries'),
                                                         (SQLName:'f_el_email_tries';TKName:'elEmailTries'),
                                                         (SQLName:'f_el_send_doc';TKName:'elSendDoc'),
                                                         (SQLName:'f_el_doc_name';TKName:'elDocName'),
                                                         (SQLName:'f_el_sms_retries_notified';TKName:'elSMSRetriesNotified'),
                                                         (SQLName:'f_el_email_retries_notified';TKName:'elEmailRetriesNotified'),
                                                         (SQLName:'f_el_email_error_no';TKName:'elEmailErrorNo'),
                                                         (SQLName:'f_el_sms_error_no';TKName:'elSMSErrorNo'),
                                                         (SQLName:'f_el_rep_file';TKName:'elRepFile'),
                                                         (SQLName:'f_el_fax_cover';TKName:'elFaxCover'),
                                                         (SQLName:'f_el_fax_tries';TKName:'elFaxTries'),
                                                         (SQLName:'f_el_print_tries';TKName:'elPrintTries'),
                                                         (SQLName:'f_el_fax_priority';TKName:'elFaxPriority'),
                                                         (SQLName:'f_el_has_conditions';TKName:'elHasConditions'),
                                                         (SQLName:'f_el_rep_folder';TKName:'elRepFolder'),
                                                         (SQLName:'f_el_ftp_site';TKName:'elFTPSite'),
                                                         (SQLName:'f_el_ftp_user_name';TKName:'elFTPUserName'),
                                                         (SQLName:'f_el_ftp_password';TKName:'elFTPPassword'),
                                                         (SQLName:'f_el_ftp_port';TKName:'elFTPPort'),
                                                         (SQLName:'f_el_csv_by_email';TKName:'elCSVByEmail'),
                                                         (SQLName:'f_el_csv_by_ftp';TKName:'elCSVByFTP'),
                                                         (SQLName:'f_el_csv_to_folder';TKName:'elCSVToFolder'),
                                                         (SQLName:'f_el_upload_dir';TKName:'elUploadDir'),
                                                         (SQLName:'f_el_csv_file_name';TKName:'elCSVFileName'),
                                                         (SQLName:'f_el_ftp_tries';TKName:'elFTPTries'),
                                                         (SQLName:'f_el_ftp_timeout';TKName:'elFTPTimeout'),
                                                         (SQLName:'f_el_csv_file_renamed';TKName:'elCSVFileRenamed'),
                                                         (SQLName:'f_el_ftp_retries_notified';TKName:'elFTPRetriesNotified'),
                                                         (SQLName:'f_el_fax_retries_notified';TKName:'elFaxRetriesNotified'),
                                                         (SQLName:'f_el_compress_report';TKName:'elCompressReport'),
                                                         (SQLName:'f_el_rp_attach_method';TKName:'elRpAttachMethod'),
                                                         (SQLName:'f_el_work_station';TKName:'elWorkStation'),
                                                         (SQLName:'f_el_word_wrap';TKName:'elWordWrap'),
                                                         (SQLName:'f_el_sys_message';TKName:'elSysMessage'),
                                                         (SQLName:'f_el_dbf';TKName:'elDBF'),
                                                         (SQLName:'f_el_queue_counter';TKName:'elQueueCounter'),
                                                         (SQLName:'f_el_hours_before_notify';TKName:'elHoursBeforeNotify'),
                                                         (SQLName:'f_el_query_start';TKName:'elQueryStart'),
                                                         (SQLName:'f_el_ex_rep_format';TKName:'elExRepFormat'),
                                                         (SQLName:'f_el_recip_no';TKName:'elRecipNo'),
                                                         (SQLName:'f_el_new_report';TKName:'elNewReport'),
                                                         (SQLName:'f_el_new_report_name';TKName:'elNewReportName')
                                                        );
var
  i : integer;
begin
  for i := 1 to NumberOfFields do
  begin
    if Trim(UpperCase(Value)) = Trim(UpperCase(FieldNames[i].TkName)) then
    begin
      Result := GetDBColumnName('Sent.dat', FieldNames[i].SQLName, '');
      Break;
    end;
  end;
end;
 
function TranslateSentLineField(const Value : string) : string;
const
  NumberOfFields = 11;
  FieldNames : Array[1..NumberOfFields] of TFieldName = (
                                                         (SQLName:'Prefix';TKName:'Prefix'),
                                                         (SQLName:'UserId';TKName:'UserId'),
                                                         (SQLName:'Name';TKName:'Name'),
                                                         (SQLName:'Instance';TKName:'Instance'),
                                                         (SQLName:'OutputType';TKName:'OutputType'),
                                                         (SQLName:'LineNumber';TKName:'LineNumber'),
                                                         (SQLName:'DummyLineNumber';TKName:'DummyLineNumber'),
                                                         (SQLName:'TermChar';TKName:'TermChar'),
                                                         (SQLName:'ID';TKName:'ID'),
                                                         (SQLName:'OutputLines';TKName:'OutputLines'),
                                                         (SQLName:'MsgInstance';TKName:'MsgInstance')
                                                        );
var
  i : integer;
begin
  for i := 1 to NumberOfFields do
  begin
    if Trim(UpperCase(Value)) = Trim(UpperCase(FieldNames[i].TkName)) then
    begin
      Result := GetDBColumnName('SentLine.dat', FieldNames[i].SQLName, '');
      Break;
    end;
  end;
end;
 
function TranslateSettingsField(const Value : string) : string;
const
  NumberOfFields = 2;
  FieldNames : Array[1..NumberOfFields] of TFieldName = (
                                                         (SQLName:'f_field_1';TKName:'f_field_1'),
                                                         (SQLName:'f_field_2';TKName:'f_field_3')
                                                        );
var
  i : integer;
begin
  for i := 1 to NumberOfFields do
  begin
    if Trim(UpperCase(Value)) = Trim(UpperCase(FieldNames[i].TkName)) then
    begin
      Result := GetDBColumnName('Settings.dat', FieldNames[i].SQLName, '');
      Break;
    end;
  end;
end;

function TranslateStockField(const Value : string) : string;
const
  NumberOfFields = 140;
  FieldNames : Array[1..NumberOfFields] of TFieldName = (
                                                         (SQLName:'f_stock_code';TKName:'stCode'),
                                                         (SQLName:'f_desc_line1';TKName:'stDesc[1]'),
                                                         (SQLName:'f_desc_line2';TKName:'stDesc[2]'),
                                                         (SQLName:'f_desc_line3';TKName:'stDesc[3]'),
                                                         (SQLName:'f_desc_line4';TKName:'stDesc[4]'),
                                                         (SQLName:'f_desc_line5';TKName:'stDesc[5]'),
                                                         (SQLName:'f_desc_line6';TKName:'stDesc[6]'),
                                                         (SQLName:'f_alt_code';TKName:'stAltCode'),
                                                         (SQLName:'f_supp_temp';TKName:'stSuppTemp'),
                                                         (SQLName:'f_nom_code1';TKName:'stSalesGL'),
                                                         (SQLName:'f_nom_code2';TKName:'stCOSGL'),
                                                         (SQLName:'f_nom_code3';TKName:'stPandLGL'),
                                                         (SQLName:'f_nom_code4';TKName:'stBalSheetGL'),
                                                         (SQLName:'f_nom_code5';TKName:'stWIPGL'),
                                                         (SQLName:'f_ro_flg';TKName:'stReorderFlag'),
                                                         (SQLName:'f_min_flg';TKName:'stMinReorderFlag'),
                                                         (SQLName:'f_stock_folio';TKName:'stFolioNum'),
                                                         (SQLName:'f_stock_cat';TKName:'stParentCode'),
                                                         (SQLName:'f_stock_type';TKName:'stType'),
                                                         (SQLName:'f_unit_k';TKName:'stUnitOfStock'),
                                                         (SQLName:'f_unit_s';TKName:'stUnitOfSale'),
                                                         (SQLName:'f_unit_p';TKName:'stUnitOfPurch'),
                                                         (SQLName:'f_p_currency';TKName:'stCostPriceCurrency'),
                                                         (SQLName:'f_cost_price';TKName:'stCostPrice'),
                                                         (SQLName:'f_sale_band1_currency';TKName:'stSalesBand[''A''].stCurrency'),
                                                         (SQLName:'f_sale_band1_price';TKName:'stSalesBand[''A''].stPrice'),
                                                         (SQLName:'f_sale_band2_currency';TKName:'stSalesBand[''B''].stCurrency'),
                                                         (SQLName:'f_sale_band2_price';TKName:'stSalesBand[''B''].stPrice'),
                                                         (SQLName:'f_sale_band3_currency';TKName:'stSalesBand[''C''].stCurrency'),
                                                         (SQLName:'f_sale_band3_price';TKName:'stSalesBand[''C''].stPrice'),
                                                         (SQLName:'f_sale_band4_currency';TKName:'stSalesBand[''D''].stCurrency'),
                                                         (SQLName:'f_sale_band4_price';TKName:'stSalesBand[''D''].stPrice'),
                                                         (SQLName:'f_sale_band5_currency';TKName:'stSalesBand[''E''].stCurrency'),
                                                         (SQLName:'f_sale_band5_price';TKName:'stSalesBand[''E''].stPrice'),
                                                         (SQLName:'f_sale_band6_currency';TKName:'stSalesBand[''F''].stCurrency'),
                                                         (SQLName:'f_sale_band6_price';TKName:'stSalesBand[''F''].stPrice'),
                                                         (SQLName:'f_sale_band7_currency';TKName:'stSalesBand[''G''].stCurrency'),
                                                         (SQLName:'f_sale_band7_price';TKName:'stSalesBand[''G''].stPrice'),
                                                         (SQLName:'f_sale_band8_currency';TKName:'stSalesBand[''H''].stCurrency'),
                                                         (SQLName:'f_sale_band8_price';TKName:'stSalesBand[''H''].stPrice'),
                                                         (SQLName:'f_sale_band9_currency';TKName:'stSalesBand[''I''].stCurrency'),
                                                         (SQLName:'f_sale_band9_price';TKName:'stSalesBand[''I''].stPrice'),
                                                         (SQLName:'f_sale_band10_currency';TKName:'stSalesBand[''J''].stCurrency'),
                                                         (SQLName:'f_sale_band10_price';TKName:'stSalesBand[''J''].stPrice'),
                                                         (SQLName:'f_sell_unit';TKName:'stSalesUnits'),
                                                         (SQLName:'f_buy_unit';TKName:'stPurchaseUnits'),
                                                         (SQLName:'f_spare1';TKName:'stSpare1'),
                                                         (SQLName:'f_vat_code';TKName:'stVATCode'),
                                                         (SQLName:'f_department';TKName:'stDepartment'),
                                                         (SQLName:'f_cost_centre';TKName:'stCostCentre'),
                                                         (SQLName:'f_qty_in_stock';TKName:'stQtyInStock'),
                                                         (SQLName:'f_qty_posted';TKName:'stQtyPosted'),
                                                         (SQLName:'f_qty_allocated';TKName:'stQtyAllocated'),
                                                         (SQLName:'f_qty_on_order';TKName:'stQtyOnOrder'),
                                                         (SQLName:'f_qty_min';TKName:'stQtyMin'),
                                                         (SQLName:'f_qty_max';TKName:'stQtyMax'),
                                                         (SQLName:'f_ro_qty';TKName:'stReorder.stReOrderQty'),
                                                         (SQLName:'f_n_line_count';TKName:'stNLineCount'),
                                                         (SQLName:'f_sub_assy_flg';TKName:'stSubAssemblyFlag'),
                                                         (SQLName:'f_showas_kit';TKName:'stShowKitOnSales'),
                                                         (SQLName:'f_b_line_count';TKName:'stBLineCount'),
                                                         (SQLName:'f_commod_code';TKName:'stIntrastat.stSSDCommodityCode'),
                                                         (SQLName:'f_s_weight';TKName:'stIntrastat.stSSDSalesUnitWeight'),
                                                         (SQLName:'f_p_weight';TKName:'stIntrastat.stSSDPurchaseUnitWeight'),
                                                         (SQLName:'f_unit_supp';TKName:'stIntrastat.stSSDUnitDesc'),
                                                         (SQLName:'f_supp_s_unit';TKName:'stIntrastat.stSSDStockUnits'),
                                                         (SQLName:'f_bin_loc';TKName:'stBinLocation'),
                                                         (SQLName:'f_stk_flg';TKName:'stStockTakeFlag'),
                                                         (SQLName:'f_cov_pr';TKName:'stCover.stCoverPeriods'),
                                                         (SQLName:'f_cov_pr_unit';TKName:'stCover.stCoverPeriodUnits'),
                                                         (SQLName:'f_cov_min_pr';TKName:'stCover.stCoverMinPeriods'),
                                                         (SQLName:'f_cov_min_unit';TKName:'stCover.stCoverMinPeriodUnits'),
                                                         (SQLName:'f_supplier';TKName:'stSupplier'),
                                                         (SQLName:'f_qty_freeze';TKName:'stQtyFreeze'),
                                                         (SQLName:'f_cov_sold';TKName:'stCover.stCoverQtySold'),
                                                         (SQLName:'f_use_cover';TKName:'stCover.stUseCover'),
                                                         (SQLName:'f_cov_max_pr';TKName:'stCover.stCoverMaxPeriods'),
                                                         (SQLName:'f_cov_max_unit';TKName:'stCover.stCoverMaxPeriodUnits'),
                                                         (SQLName:'f_ro_currency';TKName:'stReorder.stReorderCurrency'),
                                                         (SQLName:'f_roc_price';TKName:'stReorder.stReorderPrice'),
                                                         (SQLName:'f_ro_date';TKName:'stReorder.stReorderDate'),
                                                         (SQLName:'f_qty_take';TKName:'stQtyStockTake'),
                                                         (SQLName:'f_stk_val_type';TKName:'stValuationMethod'),
                                                         (SQLName:'f_has_ser_no';TKName:'stHasSerialNo'),
                                                         (SQLName:'f_qty_picked';TKName:'stQtyPicked'),
                                                         (SQLName:'f_last_used';TKName:'stLastUsed'),
                                                         (SQLName:'f_calc_pack';TKName:'stCalcPack'),
                                                         (SQLName:'f_j_anal_code';TKName:'stAnalysisCode'),
                                                         (SQLName:'f_stk_user1';TKName:'stUserField1'),
                                                         (SQLName:'f_stk_user2';TKName:'stUserField2'),
                                                         (SQLName:'f_bar_code';TKName:'stBarCode'),
                                                         (SQLName:'f_ro_department';TKName:'stReorder.stReorderDepartment'),
                                                         (SQLName:'f_ro_cost_centre';TKName:'stReorder.stReorderCostCentre'),
                                                         (SQLName:'f_def_m_loc';TKName:'stLocation'),
                                                         (SQLName:'f_price_pack';TKName:'stPriceByPack'),
                                                         (SQLName:'f_d_pack_qty';TKName:'stShowQtyAsPacks'),
                                                         (SQLName:'f_kit_price';TKName:'stUseKitPrice'),
                                                         (SQLName:'f_kit_on_purch';TKName:'stShowKitOnPurchase'),
                                                         (SQLName:'f_stk_link_lt';TKName:'stDefaultLineType'),
                                                         (SQLName:'f_qty_return';TKName:'stSalesReturnQty'),
                                                         (SQLName:'f_qty_alloc_wor';TKName:'stQtyAllocWOR'),
                                                         (SQLName:'f_qty_issue_wor';TKName:'stQtyIssuedWOR'),
                                                         (SQLName:'f_web_include';TKName:'stUseForEbus'),
                                                         (SQLName:'f_web_live_cat';TKName:'stWebLiveCatalog'),
                                                         (SQLName:'f_web_prev_cat';TKName:'stWebPrevCatalog'),
                                                         (SQLName:'f_stk_user3';TKName:'stUserField3'),
                                                         (SQLName:'f_stk_user4';TKName:'stUserField4'),
                                                         (SQLName:'f_ser_no_wavg';TKName:'stSerNoWAvg'),
                                                         (SQLName:'f_stk_size_col';TKName:'stSizeCol'),
                                                         (SQLName:'f_ssdd_uplift';TKName:'stIntrastat.stSSDDespatchUplift'),
                                                         (SQLName:'f_ssd_country';TKName:'stIntrastat.stSSDCountry'),
                                                         (SQLName:'f_time_change';TKName:'stTimeChange'),
                                                         (SQLName:'f_svat_inc_flg';TKName:'stInclusiveVATCode'),
                                                         (SQLName:'f_ssda_uplift';TKName:'stIntrastat.stSSDArrivalUplift'),
                                                         (SQLName:'f_private_rec';TKName:'stPrivateRec'),
                                                         (SQLName:'f_last_opo';TKName:'stOperator'),
                                                         (SQLName:'f_image_file';TKName:'stImageFile'),
                                                         (SQLName:'f_temp_bloc';TKName:'stTempBLoc'),
                                                         (SQLName:'f_qty_pick_wor';TKName:'stQtyPickedWOR'),
                                                         (SQLName:'f_wopwipgl';TKName:'stWIPGL'),
                                                         (SQLName:'f_calc_prod_time';TKName:'stWOPAutoCalcTime'),
                                                         (SQLName:'f_leadtime';TKName:'stWOPRoLeadTime'),

                                                         (SQLName:'f_prod_time';TKName:'stWOPAssemblyDays'),
                                                         (SQLName:'f_prod_time';TKName:'stWOPAssemblyHours'),
                                                         (SQLName:'f_prod_time';TKName:'stWOPAssemblyMins'),

                                                         (SQLName:'f_bom_prod_time';TKName:'stBOMProductionTime'),
                                                         (SQLName:'f_min_ecc_qty';TKName:'stWOPMinEconBuild'),
                                                         (SQLName:'f_multi_bin_mode';TKName:'stMultiBinMode'),
                                                         (SQLName:'f_s_warranty';TKName:'stSalesWarrantyLength'),
                                                         (SQLName:'f_s_warranty_type';TKName:'stSalesWarrantyType'),
                                                         (SQLName:'f_m_warranty';TKName:'stManufacturerWarrantyLength'),
                                                         (SQLName:'f_m_warranty_type';TKName:'stManufacturerWarrantyType'),
                                                         (SQLName:'f_qty_p_return';TKName:'stPurchaseReturnQty'),
                                                         (SQLName:'f_return_gl';TKName:'stSalesReturnGL'),
                                                         (SQLName:'f_re_stock_pcnt';TKName:'stRestockPercent'),
                                                         (SQLName:'f_re_stock_gl';TKName:'stRestockGL'),
                                                         (SQLName:'f_bom_ded_comp';TKName:'BOMDedComp'),
                                                         (SQLName:'f_p_return_gl';TKName:'stPurchaseReturnGL'),
                                                         (SQLName:'f_re_stock_pchr';TKName:'stRestockPChr'),
                                                         (SQLName:'f_last_stock_type';TKName:'stLastStockType')
                                                        );
var
  i : integer;
begin
  for i := 1 to NumberOfFields do
  begin
    if Trim(UpperCase(Value)) = Trim(UpperCase(FieldNames[i].TkName)) then
    begin
      Result := GetDBColumnName('Stock.dat', FieldNames[i].SQLName, '');
      Break;
    end;
  end;
end;
 
function TranslateTillnameField(const Value : string) : string;
const
  NumberOfFields = 2;
  FieldNames : Array[1..NumberOfFields] of TFieldName = (
                                                         (SQLName:'f_field_1';TKName:'f_field_1'),
                                                         (SQLName:'f_field_2';TKName:'f_field_2')
                                                        );
var
  i : integer;
begin
  for i := 1 to NumberOfFields do
  begin
    if Trim(UpperCase(Value)) = Trim(UpperCase(FieldNames[i].TkName)) then
    begin
      Result := GetDBColumnName('Tillname.dat', FieldNames[i].SQLName, '');
      Break;
    end;
  end;
end;
 
function TranslateMenuItemField(const Value : string) : string;
const
  NumberOfFields = 18;
  NumberOfFixedFields = 4;
  FieldNames : Array[1..NumberOfFields] of TFieldName = (
                                                         (SQLName:'recordtype';TKName:'recordtype'),
                                                         (SQLName:'tools_code1';TKName:'Toolscode1'),
                                                         (SQLName:'tools_code2';TKName:'Toolscode2'),
                                                         (SQLName:'tools_code3';TKName:'Toolscode3'),
                                                         (SQLName:'mifoliono';TKName:'mifoliono'),
                                                         (SQLName:'miavailability';TKName:'miavailability'),
                                                         (SQLName:'micompany';TKName:'micompany'),
                                                         (SQLName:'miitemtype';TKName:'miitemtype'),
                                                         (SQLName:'midescription';TKName:'midescription'),
                                                         (SQLName:'mifilename';TKName:'mifilename'),
                                                         (SQLName:'mistartdir';TKName:'mistartdir'),
                                                         (SQLName:'miparameters';TKName:'miparameters'),
                                                         (SQLName:'mihelptext';TKName:'mihelptext'),
                                                         (SQLName:'miallusers';TKName:'miallusers'),
                                                         (SQLName:'miallcompanies';TKName:'miallcompanies'),
                                                         (SQLName:'micomponentname';TKName:'micomponentname'),
                                                         (SQLName:'miparentcomponentname';TKName:'miparentcomponentname'),
                                                         (SQLName:'miposition';TKName:'miposition')
                                                        );
var
  i : integer;
  CurrentPrefix : String;
begin
  for i := 1 to NumberOfFields do
  begin
    if Trim(UpperCase(Value)) = Trim(UpperCase(FieldNames[i].TkName)) then
    begin
      if i > NumberOfFixedFields then
        CurrentPrefix := 'M'
      else
        CurrentPrefix := '';
      Result := GetDBColumnName('Tools.dat', FieldNames[i].SQLName, CurrentPrefix);
      Break;
    end;
  end;
end;
 
function TranslateUserXRefField(const Value : string) : string;
const
  NumberOfFields = 6;
  NumberOfFixedFields = 4;
  FieldNames : Array[1..NumberOfFields] of TFieldName = (
                                                         (SQLName:'recordtype';TKName:'recordtype'),
                                                         (SQLName:'tools_code1';TKName:'Toolscode1'),
                                                         (SQLName:'tools_code2';TKName:'Toolscode2'),
                                                         (SQLName:'tools_code3';TKName:'Toolscode3'),
                                                         (SQLName:'uxitemfolio';TKName:'uxitemfolio'),
                                                         (SQLName:'uxusername';TKName:'uxusername')
                                                        );
var
  i : integer;
  CurrentPrefix : String;
begin
  for i := 1 to NumberOfFields do
  begin
    if Trim(UpperCase(Value)) = Trim(UpperCase(FieldNames[i].TkName)) then
    begin
      if i > NumberOfFixedFields then
        CurrentPrefix := 'U'
      else
        CurrentPrefix := '';
      Result := GetDBColumnName('Tools.dat', FieldNames[i].SQLName, CurrentPrefix);
      Break;
    end;
  end;
end;
 
function TranslateSysSetupField(const Value : string) : string;
const
  NumberOfFields = 6;
  NumberOfFixedFields = 4;
  FieldNames : Array[1..NumberOfFields] of TFieldName = (
                                                         (SQLName:'recordtype';TKName:'recordtype'),
                                                         (SQLName:'tools_code1';TKName:'Toolscode1'),
                                                         (SQLName:'tools_code2';TKName:'Toolscode2'),
                                                         (SQLName:'tools_code3';TKName:'Toolscode3'),
                                                         (SQLName:'ssusepassword';TKName:'ssusepassword'),
                                                         (SQLName:'sspassword';TKName:'sspassword')
                                                        );
var
  i : integer;
  CurrentPrefix : String;
begin
  for i := 1 to NumberOfFields do
  begin
    if Trim(UpperCase(Value)) = Trim(UpperCase(FieldNames[i].TkName)) then
    begin
      if i > NumberOfFixedFields then
        CurrentPrefix := 'S'
      else
        CurrentPrefix := '';
      Result := GetDBColumnName('Tools.dat', FieldNames[i].SQLName, CurrentPrefix);
      Break;
    end;
  end;
end;
 
function TranslateCompanyXRefField(const Value : string) : string;
const
  NumberOfFields = 6;
  NumberOfFixedFields = 4;
  FieldNames : Array[1..NumberOfFields] of TFieldName = (
                                                         (SQLName:'recordtype';TKName:'recordtype'),
                                                         (SQLName:'tools_code1';TKName:'Toolscode1'),
                                                         (SQLName:'tools_code2';TKName:'Toolscode2'),
                                                         (SQLName:'tools_code3';TKName:'Toolscode3'),
                                                         (SQLName:'cxitemfolio';TKName:'cxitemfolio'),
                                                         (SQLName:'cxcompanycode';TKName:'cxcompanycode')
                                                        );
var
  i : integer;
  CurrentPrefix : String;
begin
  for i := 1 to NumberOfFields do
  begin
    if Trim(UpperCase(Value)) = Trim(UpperCase(FieldNames[i].TkName)) then
    begin
      if i > NumberOfFixedFields then
        CurrentPrefix := 'C'
      else
        CurrentPrefix := '';
      Result := GetDBColumnName('Tools.dat', FieldNames[i].SQLName, CurrentPrefix);
      Break;
    end;
  end;
end;
 
function TranslateUDENTITYField(const Value : string) : string;
const
  NumberOfFields = 5;
  FieldNames : Array[1..NumberOfFields] of TFieldName = (
                                                         (SQLName:'etFolioNo';TKName:'etFolioNo'),
                                                         (SQLName:'etDescription';TKName:'etDescription'),
                                                         (SQLName:'etType';TKName:'etType'),
                                                         (SQLName:'etFormat';TKName:'etFormat'),
                                                         (SQLName:'etDummyChar';TKName:'etDummyChar')
                                                        );
var
  i : integer;
begin
  for i := 1 to NumberOfFields do
  begin
    if Trim(UpperCase(Value)) = Trim(UpperCase(FieldNames[i].TkName)) then
    begin
      Result := GetDBColumnName('UDENTITY.dat', FieldNames[i].SQLName, '');
      Break;
    end;
  end;
end;
 
function TranslateUDFIELDField(const Value : string) : string;
const
  NumberOfFields = 8;
  FieldNames : Array[1..NumberOfFields] of TFieldName = (
                                                         (SQLName:'fiFolioNo';TKName:'fiFolioNo'),
                                                         (SQLName:'fiEntityFolio';TKName:'fiEntityFolio'),
                                                         (SQLName:'fiLineNo';TKName:'fiLineNo'),
                                                         (SQLName:'fiDescription';TKName:'fiDescription'),
                                                         (SQLName:'fiValidationMode';TKName:'fiValidationMode'),
                                                         (SQLName:'fiWindowCaption';TKName:'fiWindowCaption'),
                                                         (SQLName:'fiLookupRef';TKName:'fiLookupRef'),
                                                         (SQLName:'fiDummyChar';TKName:'fiDummyChar')
                                                        );
var
  i : integer;
begin
  for i := 1 to NumberOfFields do
  begin
    if Trim(UpperCase(Value)) = Trim(UpperCase(FieldNames[i].TkName)) then
    begin
      Result := GetDBColumnName('UDFIELD.dat', FieldNames[i].SQLName, '');
      Break;
    end;
  end;
end;
 
function TranslateUDITEMField(const Value : string) : string;
const
  NumberOfFields = 4;
  FieldNames : Array[1..NumberOfFields] of TFieldName = (
                                                         (SQLName:'liFieldFolio';TKName:'liFieldFolio'),
                                                         (SQLName:'liLineNo';TKName:'liLineNo'),
                                                         (SQLName:'liDescription';TKName:'liDescription'),
                                                         (SQLName:'liDummyChar';TKName:'liDummyChar')
                                                        );
var
  i : integer;
begin
  for i := 1 to NumberOfFields do
  begin
    if Trim(UpperCase(Value)) = Trim(UpperCase(FieldNames[i].TkName)) then
    begin
      Result := GetDBColumnName('UDITEM.dat', FieldNames[i].SQLName, '');
      Break;
    end;
  end;
end;
 
function TranslateVATOPTField(const Value : string) : string;
const
  NumberOfFields = 9;
  FieldNames : Array[1..NumberOfFields] of TFieldName = (
                                                         (SQLName:'Year';TKName:'Year'),
                                                         (SQLName:'Period';TKName:'Period'),
                                                         (SQLName:'EndDate';TKName:'EndDate'),
                                                         (SQLName:'StartDate';TKName:'StartDate'),
                                                         (SQLName:'OptNoOfPeriods';TKName:'OptNoOfPeriods'),
                                                         (SQLName:'OptUseAuto';TKName:'OptUseAuto'),
                                                         (SQLName:'BackColor';TKName:'BackColor'),
                                                         (SQLName:'TextColor';TKName:'TextColor'),
                                                         (SQLName:'CurrColor';TKName:'CurrColor')
                                                        );
var
  i : integer;
begin
  for i := 1 to NumberOfFields do
  begin
    if Trim(UpperCase(Value)) = Trim(UpperCase(FieldNames[i].TkName)) then
    begin
      Result := GetDBColumnName('VATOPT.dat', FieldNames[i].SQLName, '');
      Break;
    end;
  end;
end;
 
function TranslateVATPRDField(const Value : string) : string;
const
  NumberOfFields = 4;
  FieldNames : Array[1..NumberOfFields] of TFieldName = (
                                                         (SQLName:'Year';TKName:'Year'),
                                                         (SQLName:'Period';TKName:'Period'),
                                                         (SQLName:'EndDate';TKName:'EndDate'),
                                                         (SQLName:'StartDate';TKName:'StartDate')
                                                        );
var
  i : integer;
begin
  for i := 1 to NumberOfFields do
  begin
    if Trim(UpperCase(Value)) = Trim(UpperCase(FieldNames[i].TkName)) then
    begin
      Result := GetDBColumnName('VATPRD.dat', FieldNames[i].SQLName, '');
      Break;
    end;
  end;
end;
 
function TranslateVRWSECField(const Value : string) : string;
const
  NumberOfFields = 3;
  FieldNames : Array[1..NumberOfFields] of TFieldName = (
                                                         (SQLName:'rtstreecode';TKName:'rtstreecode'),
                                                         (SQLName:'rtsusercode';TKName:'rtsusercode'),
                                                         (SQLName:'rtssecurity';TKName:'rtssecurity')
                                                        );
var
  i : integer;
begin
  for i := 1 to NumberOfFields do
  begin
    if Trim(UpperCase(Value)) = Trim(UpperCase(FieldNames[i].TkName)) then
    begin
      Result := GetDBColumnName('VRWSEC.dat', FieldNames[i].SQLName, '');
      Break;
    end;
  end;
end;
 
function TranslateVRWTREEField(const Value : string) : string;
const
  NumberOfFields = 11;
  FieldNames : Array[1..NumberOfFields] of TFieldName = (
                                                         (SQLName:'rtnodetype';TKName:'rtnodetype'),
                                                         (SQLName:'rtrepname';TKName:'rtrepname'),
                                                         (SQLName:'rtrepdesc';TKName:'rtrepdesc'),
                                                         (SQLName:'rtparentname';TKName:'rtparentname'),
                                                         (SQLName:'rtfilename';TKName:'rtfilename'),
                                                         (SQLName:'rtlastrun';TKName:'rtlastrun'),
                                                         (SQLName:'rtlastrunuser';TKName:'rtlastrunuser'),
                                                         (SQLName:'rtpositionnumber';TKName:'rtpositionnumber'),
                                                         (SQLName:'rtindexfix';TKName:'rtindexfix'),
                                                         (SQLName:'rtallowedit';TKName:'rtallowedit'),
                                                         (SQLName:'rtfileexists';TKName:'rtfileexists')
                                                        );
var
  i : integer;
begin
  for i := 1 to NumberOfFields do
  begin
    if Trim(UpperCase(Value)) = Trim(UpperCase(FieldNames[i].TkName)) then
    begin
      Result := GetDBColumnName('VRWTREE.dat', FieldNames[i].SQLName, '');
      Break;
    end;
  end;
end;
 
 
end.
