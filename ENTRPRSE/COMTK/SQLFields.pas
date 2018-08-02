unit SQLFields;

interface

function GetAllCcdeptvFields : string;
function GetAllCommssnFields : string;
function GetAllCompanyDetRecFields : string;
function GetAllCompanyOptionsFields : string;
function GetAllUserCountXRefTypeUFields : string;
function GetAllUserCountXRefTypeTFields : string;
function GetAllUserCountXRefTypeRFields : string;
function GetAllHookSecurityRecTypeFields : string;
function GetAllAccessControlTypeFields : string;
function GetAllContactFields : string;
function GetAllCustsuppFields : string;
function GetAllDetailsFields : string;
function GetAllDataVarTypeFields : string;
function GetAllDataXRefTypeFields : string;
function GetAllDocumentFields : string;
function GetAllTebusParamsFields : string;
function GetAllTebusDragNetFields : string;
function GetAllTebusCompanyFields : string;
function GetAllTebusFileCountersFields : string;
function GetAllTebusImportFields : string;
function GetAllTebusExportFields : string;
function GetAllTebusCatalogueFields : string;
function GetAllTebusFTPFields : string;
function GetAllTebusEmailFields : string;
function GetAllTebusFileFields : string;
function GetAllTebusDragNetCompanyFields : string;
function GetAllTebusDragNetCountryFields : string;
function GetAllTPreserveDocFieldsFields : string;
function GetAllTPreserveLineFieldsFields : string;
function GetAllTLookupGenericCFields : string;
function GetAllTLookupGenericVFields : string;
function GetAllTFields : string;
function GetAllNotesTypeNDFields : string;
function GetAllEmppayFields : string;
function GetAllPassEntryTypeFields : string;
function GetAllPassListTypeFields : string;
function GetAllNotesTypeNAFields : string;
function GetAllMatchPayTypeTPFields : string;
function GetAllBillMatTypeFields : string;
function GetAllBacsCtypeFields : string;
function GetAllBankCtypeFields : string;
function GetAllAllocFileTypeFields : string;
function GetAllCostCtrTypeFields : string;
function GetAllMoveNomTypeFields : string;
function GetAllMoveStkTypeFields : string;
function GetAllVSecureTypeFields : string;
function GetAllBacsUtypeFields : string;
function GetAllMoveCtrlTypeFields : string;
function GetAllExchqnumFields : string;
function GetAllSysRecFields : string;
function GetAllVATRecFields : string;
function GetAllCurr1PTypeFields : string;
function GetAllDEFRecFields : string;
function GetAllJobSRecFields : string;
function GetAllFormDefsTypeFields : string;
function GetAllModuleRelTypeFields : string;
function GetAllGCur1PTypeFields : string;
function GetAllEDI1TypeFields : string;
function GetAllEDI2TypeFields : string;
function GetAllEDI3TypeFields : string;
function GetAllCustomFTypeFields : string;
function GetAllCISCRecFields : string;
function GetAllCIS340RecFields : string;
function GetAllCustDiscTypeFields : string;
function GetAllMultiLocTypeFields : string;
function GetAllFiFoTypeFields : string;
function GetAllIrishVATSOPInpDefTypeFields : string;
function GetAllQtyDiscTypeFields : string;
function GetAllBacsSTypeFields : string;
function GetAllSerialTypeFields : string;
function GetAllBankMTypeFields : string;
function GetAllBtCustomTypeFields : string;
function GetAllBtLetterLinkTypeFields : string;
function GetAllAllocSTypeFields : string;
function GetAllRtLReasonTypeFields : string;
function GetAllB2BInpRecFields : string;
function GetAllB2BLineRecFields : string;
function GetAllFaxesFields : string;
function GetAllFormsFields : string;
function GetAllGroupcmpFields : string;
function GetAllGroupsFields : string;
function GetAllGroupusrFields : string;
function GetAllHistoryFields : string;
function GetAllImportjobFields : string;
function GetAllJobBudgJBFields : string;
function GetAllJobBudgJMFields : string;
function GetAllJobBudgJSFields : string;
function GetAllEmplPayJEFields : string;
function GetAllEmplPayJRFields : string;
function GetAllJobActualFields : string;
function GetAllJobRetenFields : string;
function GetAllJobCISVFields : string;
function GetAllJobheadFields : string;
function GetAllEmplRecFields : string;
function GetAllJobTypeRecFields : string;
function GetAllJobAnalRecFields : string;
function GetAllLbinFields : string;
function GetAllLheaderFields : string;
function GetAllLlinesFields : string;
function GetAllLserialFields : string;
function GetAllMCPAYFields : string;
function GetAllMLocLocFields : string;
function GetAllMStkLocFields : string;
function GetAllSdbStkRecFields : string;
function GetAllCuStkRecFields : string;
function GetAllTeleSRecFields : string;
function GetAllEMUCnvRecFields : string;
function GetAllPassDefRecFields : string;
function GetAllAllocCRecFields : string;
function GetAllbrBinRecFields : string;
function GetAllBnkRHRecFields : string;
function GetAllBnkRDRecFields : string;
function GetAllBACSDbRecFields : string;
function GetAlleBankHRecFields : string;
function GetAlleBankLRecFields : string;
function GetAllNominalFields : string;
function GetAllNomViewTypeFields : string;
function GetAllViewCtrlTypeFields : string;
function GetAllPAAUTHFields : string;
function GetAllPACOMPFields : string;
function GetAllPAEARFields : string;
function GetAllPAGLOBALFields : string;
function GetAllPapersizeFields : string;
function GetAllPAUSERFields : string;
function GetAllPPCUSTFields : string;
function GetAllPPDEBTFields : string;
function GetAllPPSETUPFields : string;
function GetAllReportsFields : string;
function GetAllSALECODEFields : string;
function GetAllSCHEDCFGFields : string;
function GetAllSCHEDULEFields : string;
function GetAllSCTYPEFields : string;
function GetAllSentFields : string;
function GetAllSentLineFields : string;
function GetAllSettingsFields : string;
function GetAllStockFields : string;
function GetAllTillnameFields : string;
function GetAllMenuItemFields : string;
function GetAllUserXRefFields : string;
function GetAllSysSetupFields : string;
function GetAllCompanyXRefFields : string;
function GetAllUDENTITYFields : string;
function GetAllUDFIELDFields : string;
function GetAllUDITEMFields : string;
function GetAllVATOPTFields : string;
function GetAllVATPRDFields : string;
function GetAllVRWSECFields : string;
function GetAllVRWTREEFields : string;
 
implementation
 
uses SQLUtils;
 
function GetAllCcdeptvFields : string;
begin
  Result := GetDBColumnName('Ccdeptv.dat', 'cdtype', '') + ',' + 
            GetDBColumnName('Ccdeptv.dat', 'cdglcode', '') + ',' + 
            GetDBColumnName('Ccdeptv.dat', 'cdcostcentre', '') + ',' + 
            GetDBColumnName('Ccdeptv.dat', 'cddepartment', '') + ',' + 
            GetDBColumnName('Ccdeptv.dat', 'cddummychar', '') + ',' + 
            GetDBColumnName('Ccdeptv.dat', 'cdvatcode', '') ;
end;
  
function GetAllCommssnFields : string;
begin
  Result := GetDBColumnName('Commssn.dat', 'cmFolioNo', '') + ',' + 
            GetDBColumnName('Commssn.dat', 'cmSalesCodeFolioNo', '') + ',' + 
            GetDBColumnName('Commssn.dat', 'cmBy', '') + ',' + 
            GetDBColumnName('Commssn.dat', 'cmCustCode', '') + ',' + 
            GetDBColumnName('Commssn.dat', 'cmProductCode', '') + ',' + 
            GetDBColumnName('Commssn.dat', 'cmPGroupCode', '') + ',' + 
            GetDBColumnName('Commssn.dat', 'cmByQty', '') + ',' + 
            GetDBColumnName('Commssn.dat', 'cmQtyFrom', '') + ',' + 
            GetDBColumnName('Commssn.dat', 'cmQtyTo', '') + ',' + 
            GetDBColumnName('Commssn.dat', 'cmByCurrency', '') + ',' + 
            GetDBColumnName('Commssn.dat', 'cmCurrency', '') + ',' + 
            GetDBColumnName('Commssn.dat', 'cmByDate', '') + ',' + 
            GetDBColumnName('Commssn.dat', 'cmStartDate', '') + ',' + 
            GetDBColumnName('Commssn.dat', 'cmEndDate', '') + ',' + 
            GetDBColumnName('Commssn.dat', 'cmCommissionBasis', '') + ',' + 
            GetDBColumnName('Commssn.dat', 'cmCommission', '') + ',' + 
            GetDBColumnName('Commssn.dat', 'cmCommissionType', '') + ',' + 
            GetDBColumnName('Commssn.dat', 'cmDummyChar', '') ;
end;
  
function GetAllCompanyDetRecFields : string;
begin
  Result := GetDBColumnName('Company.dat', 'RecPFix', '') + ',' + 
            GetDBColumnName('Company.dat', 'Company_code1', '') + ',' + 
            GetDBColumnName('Company.dat', 'Company_code2', '') + ',' + 
            GetDBColumnName('Company.dat', 'Company_code3', '') + ',' + 
            GetDBColumnName('Company.dat', 'CompId', 'C') + ',' + 
            GetDBColumnName('Company.dat', 'CompDemoData', 'C') + ',' + 
            GetDBColumnName('Company.dat', 'CompSpare', 'C') + ',' + 
            GetDBColumnName('Company.dat', 'CompDemoSys', 'C') + ',' + 
            GetDBColumnName('Company.dat', 'CompTKUCount', 'C') + ',' + 
            GetDBColumnName('Company.dat', 'CompTrdUCount', 'C') + ',' + 
            GetDBColumnName('Company.dat', 'CompSysESN', 'C') + ',' + 
            GetDBColumnName('Company.dat', 'CompModId', 'C') + ',' + 
            GetDBColumnName('Company.dat', 'CompModSynch', 'C') + ',' + 
            GetDBColumnName('Company.dat', 'CompUCount', 'C') + ',' + 
            GetDBColumnName('Company.dat', 'CompAnal', 'C') ;
end;
  
function GetAllCompanyOptionsFields : string;
begin
  Result := GetDBColumnName('Company.dat', 'RecPFix', '') + ',' + 
            GetDBColumnName('Company.dat', 'Company_code1', '') + ',' + 
            GetDBColumnName('Company.dat', 'Company_code2', '') + ',' + 
            GetDBColumnName('Company.dat', 'Company_code3', '') + ',' + 
            GetDBColumnName('Company.dat', 'OptPWord', 'S') + ',' + 
            GetDBColumnName('Company.dat', 'OptBackup', 'S') + ',' + 
            GetDBColumnName('Company.dat', 'OptRestore', 'S') + ',' + 
            GetDBColumnName('Company.dat', 'OptHidePath', 'S') + ',' + 
            GetDBColumnName('Company.dat', 'OptHideBackup', 'S') + ',' + 
            GetDBColumnName('Company.dat', 'OptWin9xCmd', 'S') + ',' + 
            GetDBColumnName('Company.dat', 'OptWinNTCmd', 'S') + ',' + 
            GetDBColumnName('Company.dat', 'OptShowCheckUsr', 'S') + ',' + 
            GetDBColumnName('Company.dat', 'optSystemESN', 'S') + ',' + 
            GetDBColumnName('Company.dat', 'OptSecurity', 'S') + ',' + 
            GetDBColumnName('Company.dat', 'OptShowExch', 'S') + ',' + 
            GetDBColumnName('Company.dat', 'OptBureauModule', 'S') + ',' + 
            GetDBColumnName('Company.dat', 'OptBureauAdminPWord', 'S') + ',' + 
            GetDBColumnName('Company.dat', 'OptShowViewCompany', 'S') ;
end;
  
function GetAllUserCountXRefTypeUFields : string;
begin
  Result := GetDBColumnName('Company.dat', 'RecPFix', '') + ',' + 
            GetDBColumnName('Company.dat', 'Company_code1', '') + ',' + 
            GetDBColumnName('Company.dat', 'Company_code2', '') + ',' + 
            GetDBColumnName('Company.dat', 'Company_code3', '') + ',' + 
            GetDBColumnName('Company.dat', 'ucCompanyId', 'U') + ',' + 
            GetDBColumnName('Company.dat', 'ucWStationId', 'U') + ',' + 
            GetDBColumnName('Company.dat', 'ucUserId', 'U') + ',' + 
            GetDBColumnName('Company.dat', 'ucRefCount', 'U') ;
end;
  
function GetAllUserCountXRefTypeTFields : string;
begin
  Result := GetDBColumnName('Company.dat', 'RecPFix', '') + ',' + 
            GetDBColumnName('Company.dat', 'Company_code1', '') + ',' + 
            GetDBColumnName('Company.dat', 'Company_code2', '') + ',' + 
            GetDBColumnName('Company.dat', 'Company_code3', '') + ',' + 
            GetDBColumnName('Company.dat', 'ucCompanyId', 'T') + ',' + 
            GetDBColumnName('Company.dat', 'ucWStationId', 'T') + ',' + 
            GetDBColumnName('Company.dat', 'ucUserId', 'T') + ',' + 
            GetDBColumnName('Company.dat', 'ucRefCount', 'T') ;
end;
  
function GetAllUserCountXRefTypeRFields : string;
begin
  Result := GetDBColumnName('Company.dat', 'RecPFix', '') + ',' + 
            GetDBColumnName('Company.dat', 'Company_code1', '') + ',' + 
            GetDBColumnName('Company.dat', 'Company_code2', '') + ',' + 
            GetDBColumnName('Company.dat', 'Company_code3', '') + ',' + 
            GetDBColumnName('Company.dat', 'ucCompanyId', 'R') + ',' + 
            GetDBColumnName('Company.dat', 'ucWStationId', 'R') + ',' + 
            GetDBColumnName('Company.dat', 'ucUserId', 'R') + ',' + 
            GetDBColumnName('Company.dat', 'ucRefCount', 'R') ;
end;
  
function GetAllHookSecurityRecTypeFields : string;
begin
  Result := GetDBColumnName('Company.dat', 'RecPFix', '') + ',' + 
            GetDBColumnName('Company.dat', 'Company_code1', '') + ',' + 
            GetDBColumnName('Company.dat', 'Company_code2', '') + ',' + 
            GetDBColumnName('Company.dat', 'Company_code3', '') + ',' + 
            GetDBColumnName('Company.dat', 'hkId', 'H') + ',' + 
            GetDBColumnName('Company.dat', 'hkSecCode', 'H') + ',' + 
            GetDBColumnName('Company.dat', 'hkDesc', 'H') + ',' + 
            GetDBColumnName('Company.dat', 'hkStuff', 'H') + ',' + 
            GetDBColumnName('Company.dat', 'hkMessage', 'H') + ',' +
            GetDBColumnName('Company.dat', 'hkVersion', 'H') + ',' +
            GetDBColumnName('Company.dat', 'hkEncryptedCode', 'H');
end;
  
function GetAllAccessControlTypeFields : string;
begin
  Result := GetDBColumnName('Company.dat', 'RecPFix', '') + ',' + 
            GetDBColumnName('Company.dat', 'Company_code1', '') + ',' + 
            GetDBColumnName('Company.dat', 'Company_code2', '') + ',' + 
            GetDBColumnName('Company.dat', 'Company_code3', '') + ',' + 
            GetDBColumnName('Company.dat', 'acSystemId', 'A') ;
end;
  
function GetAllContactFields : string;
begin
  Result := GetDBColumnName('Contact.dat', 'coCompany', '') + ',' + 
            GetDBColumnName('Contact.dat', 'coAccount', '') + ',' + 
            GetDBColumnName('Contact.dat', 'coCode', '') + ',' + 
            GetDBColumnName('Contact.dat', 'coTitle', '') + ',' + 
            GetDBColumnName('Contact.dat', 'coFirstName', '') + ',' + 
            GetDBColumnName('Contact.dat', 'coSurname', '') + ',' + 
            GetDBColumnName('Contact.dat', 'coPosition', '') + ',' + 
            GetDBColumnName('Contact.dat', 'coSalutation', '') + ',' + 
            GetDBColumnName('Contact.dat', 'coContactNo', '') + ',' + 
            GetDBColumnName('Contact.dat', 'coDate', '') + ',' + 
            GetDBColumnName('Contact.dat', 'coFaxNumber', '') + ',' + 
            GetDBColumnName('Contact.dat', 'coEmailAddr', '') + ',' + 
            GetDBColumnName('Contact.dat', 'coAddress1', '') + ',' + 
            GetDBColumnName('Contact.dat', 'coAddress2', '') + ',' + 
            GetDBColumnName('Contact.dat', 'coAddress3', '') + ',' + 
            GetDBColumnName('Contact.dat', 'coAddress4', '') + ',' + 
            GetDBColumnName('Contact.dat', 'coPostCode', '') ;
end;
  
function GetAllCustsuppFields : string;
begin
  Result := GetDBColumnName('Custsupp.dat', 'f_cust_code', '') + ',' +
            GetDBColumnName('Custsupp.dat', 'f_cust_supp', '') + ',' + 
            GetDBColumnName('Custsupp.dat', 'f_company', '') + ',' + 
            GetDBColumnName('Custsupp.dat', 'f_area_code', '') + ',' + 
            GetDBColumnName('Custsupp.dat', 'f_rep_code', '') + ',' + 
            GetDBColumnName('Custsupp.dat', 'f_remit_code', '') + ',' + 
            GetDBColumnName('Custsupp.dat', 'f_vat_reg_no', '') + ',' + 
            GetDBColumnName('Custsupp.dat', 'f_address_line1', '') + ',' + 
            GetDBColumnName('Custsupp.dat', 'f_address_line2', '') + ',' + 
            GetDBColumnName('Custsupp.dat', 'f_address_line3', '') + ',' + 
            GetDBColumnName('Custsupp.dat', 'f_address_line4', '') + ',' + 
            GetDBColumnName('Custsupp.dat', 'f_address_line5', '') + ',' + 
            GetDBColumnName('Custsupp.dat', 'f_desp_addr', '') + ',' + 
            GetDBColumnName('Custsupp.dat', 'f_desp_address_line1', '') + ',' + 
            GetDBColumnName('Custsupp.dat', 'f_desp_address_line2', '') + ',' + 
            GetDBColumnName('Custsupp.dat', 'f_desp_address_line3', '') + ',' + 
            GetDBColumnName('Custsupp.dat', 'f_desp_address_line4', '') + ',' + 
            GetDBColumnName('Custsupp.dat', 'f_desp_address_line5', '') + ',' + 
            GetDBColumnName('Custsupp.dat', 'f_contact', '') + ',' + 
            GetDBColumnName('Custsupp.dat', 'f_phone', '') + ',' + 
            GetDBColumnName('Custsupp.dat', 'f_fax', '') + ',' + 
            GetDBColumnName('Custsupp.dat', 'f_ref_no', '') + ',' + 
            GetDBColumnName('Custsupp.dat', 'f_trad_term', '') + ',' + 
            GetDBColumnName('Custsupp.dat', 'f_sterms1', '') + ',' + 
            GetDBColumnName('Custsupp.dat', 'f_sterms2', '') + ',' + 
            GetDBColumnName('Custsupp.dat', 'f_currency', '') + ',' + 
            GetDBColumnName('Custsupp.dat', 'f_vat_code', '') + ',' + 
            GetDBColumnName('Custsupp.dat', 'f_pay_terms', '') + ',' + 
            GetDBColumnName('Custsupp.dat', 'f_credit_limit', '') + ',' + 
            GetDBColumnName('Custsupp.dat', 'f_discount', '') + ',' + 
            GetDBColumnName('Custsupp.dat', 'f_credit_status', '') + ',' + 
            GetDBColumnName('Custsupp.dat', 'f_cust_cc', '') + ',' + 
            GetDBColumnName('Custsupp.dat', 'f_c_disc_ch', '') + ',' + 
            GetDBColumnName('Custsupp.dat', 'f_ord_cons_mode', '') + ',' + 
            GetDBColumnName('Custsupp.dat', 'f_def_set_d_days', '') + ',' + 
            GetDBColumnName('Custsupp.dat', 'f_spare5', '') + ',' + 
            GetDBColumnName('Custsupp.dat', 'f_balance', '') + ',' + 
            GetDBColumnName('Custsupp.dat', 'f_cust_dep', '') + ',' + 
            GetDBColumnName('Custsupp.dat', 'f_eec_member', '') + ',' + 
            GetDBColumnName('Custsupp.dat', 'f_n_line_count', '') + ',' + 
            GetDBColumnName('Custsupp.dat', 'f_inc_stat', '') + ',' + 
            GetDBColumnName('Custsupp.dat', 'f_def_nom_code', '') + ',' + 
            GetDBColumnName('Custsupp.dat', 'f_def_mloc_stk', '') + ',' + 
            GetDBColumnName('Custsupp.dat', 'f_acc_status', '') + ',' + 
            GetDBColumnName('Custsupp.dat', 'f_pay_type', '') + ',' + 
            GetDBColumnName('Custsupp.dat', 'f_bank_sort', '') + ',' + 
            GetDBColumnName('Custsupp.dat', 'f_bank_acc', '') + ',' + 
            GetDBColumnName('Custsupp.dat', 'f_bank_ref', '') + ',' + 
            GetDBColumnName('Custsupp.dat', 'f_ave_pay', '') + ',' +
            GetDBColumnName('Custsupp.dat', 'f_phone2', '') + ',' + 
            GetDBColumnName('Custsupp.dat', 'f_def_cos_nom', '') + ',' + 
            GetDBColumnName('Custsupp.dat', 'f_def_ctrl_nom', '') + ',' + 
            GetDBColumnName('Custsupp.dat', 'f_last_used', '') + ',' + 
            GetDBColumnName('Custsupp.dat', 'f_user_def1', '') + ',' + 
            GetDBColumnName('Custsupp.dat', 'f_user_def2', '') + ',' + 
            GetDBColumnName('Custsupp.dat', 'f_sop_inv_code', '') + ',' + 
            GetDBColumnName('Custsupp.dat', 'f_sop_auto_w_off', '') + ',' + 
            GetDBColumnName('Custsupp.dat', 'f_f_def_page_no', '') + ',' + 
            GetDBColumnName('Custsupp.dat', 'f_b_ord_val', '') + ',' + 
            GetDBColumnName('Custsupp.dat', 'f_dir_deb', '') + ',' + 
            GetDBColumnName('Custsupp.dat', 'f_ccds_date', '') + ',' + 
            GetDBColumnName('Custsupp.dat', 'f_ccde_date', '') + ',' + 
            GetDBColumnName('Custsupp.dat', 'f_ccd_name', '') + ',' + 
            GetDBColumnName('Custsupp.dat', 'f_ccd_card_no', '') + ',' + 
            GetDBColumnName('Custsupp.dat', 'f_ccdsa_ref', '') + ',' + 
            GetDBColumnName('Custsupp.dat', 'f_def_set_disc', '') + ',' + 
            GetDBColumnName('Custsupp.dat', 'f_stat_d_mode', '') + ',' + 
            GetDBColumnName('Custsupp.dat', 'f_spare2', '') + ',' + 
            GetDBColumnName('Custsupp.dat', 'f_eml_snd_rdr', '') + ',' + 
            GetDBColumnName('Custsupp.dat', 'f_ebus_pwrd', '') + ',' + 
            GetDBColumnName('Custsupp.dat', 'f_post_code', '') + ',' + 
            GetDBColumnName('Custsupp.dat', 'f_cust_code2', '') + ',' + 
            GetDBColumnName('Custsupp.dat', 'f_allow_web', '') + ',' + 
            GetDBColumnName('Custsupp.dat', 'f_eml_zip_atc', '') + ',' + 
            GetDBColumnName('Custsupp.dat', 'f_user_def3', '') + ',' + 
            GetDBColumnName('Custsupp.dat', 'f_user_def4', '') + ',' + 
            GetDBColumnName('Custsupp.dat', 'f_web_live_cat', '') + ',' + 
            GetDBColumnName('Custsupp.dat', 'f_web_prev_cat', '') + ',' + 
            GetDBColumnName('Custsupp.dat', 'f_time_change', '') + ',' + 
            GetDBColumnName('Custsupp.dat', 'f_vat_ret_regc', '') + ',' + 
            GetDBColumnName('Custsupp.dat', 'f_ssd_del_terms', '') + ',' + 
            GetDBColumnName('Custsupp.dat', 'f_cvat_inc_flg', '') + ',' + 
            GetDBColumnName('Custsupp.dat', 'f_ssd_mode_tr', '') + ',' + 
            GetDBColumnName('Custsupp.dat', 'f_private_rec', '') + ',' + 
            GetDBColumnName('Custsupp.dat', 'f_last_opo', '') + ',' + 
            GetDBColumnName('Custsupp.dat', 'f_inv_d_mode', '') + ',' + 
            GetDBColumnName('Custsupp.dat', 'f_eml_snd_html', '') + ',' + 
            GetDBColumnName('Custsupp.dat', 'f_email_addr', '') + ',' + 
            GetDBColumnName('Custsupp.dat', 'f_sop_cons_ho', '') + ',' + 
            GetDBColumnName('Custsupp.dat', 'f_def_tag_no', '') + ',' +
            GetDBColumnName('Custsupp.dat', 'f_user_def5', '') + ',' +
            GetDBColumnName('Custsupp.dat', 'f_user_def6', '') + ',' +
            GetDBColumnName('Custsupp.dat', 'f_user_def7', '') + ',' +
            GetDBColumnName('Custsupp.dat', 'f_user_def8', '') + ',' +
            GetDBColumnName('Custsupp.dat', 'f_user_def9', '') + ',' +
            GetDBColumnName('Custsupp.dat', 'f_user_def10', '') + ',' +
            GetDBColumnName('Custsupp.dat', 'f_bank_sort_code', '') + ',' +
            GetDBColumnName('Custsupp.dat', 'f_bank_account_code', '') + ',' +
            GetDBColumnName('Custsupp.dat', 'f_mandate_id', '') + ',' +
            GetDBColumnName('Custsupp.dat', 'f_mandate_date', '') + ',' +
            GetDBColumnName('Custsupp.dat', 'f_delivery_postcode', '') + ',' +
            GetDBColumnName('Custsupp.dat', 'f_subtype', '') + ',' +
            GetDBColumnName('Custsupp.dat', 'f_long_accode', '') + ',' +
            GetDBColumnName('Custsupp.dat', 'f_allow_order_payments', '') + ',' +
            GetDBColumnName('Custsupp.dat', 'f_order_payments_glcode', '') + ',' +
            GetDBColumnName('Custsupp.dat', 'f_country', '') + ',' +
            GetDBColumnName('Custsupp.dat', 'f_delivery_country', '') + ',' +
            GetDBColumnName('Custsupp.dat', 'f_ppd_mode', '') + ',' +
            GetDBColumnName('Custsupp.dat', 'f_default_to_QR', '') + ',' +
            GetDBColumnName('Custsupp.dat', 'f_tax_region', '') + ',' +
            GetDBColumnName('Custsupp.dat', 'f_anonymisation_status', '') + ',' +
            GetDBColumnName('Custsupp.dat', 'f_anonymised_date', '') + ',' +
            GetDBColumnName('Custsupp.dat', 'f_anonymised_time', '');
end;
  
function GetAllDetailsFields : string;
begin
  Result := GetDBColumnName('Details.dat', 'f_folio_ref', '') + ',' + 
            GetDBColumnName('Details.dat', 'f_line_no', '') + ',' + 
            GetDBColumnName('Details.dat', 'f_posted_run', '') + ',' +
            GetDBColumnName('Details.dat', 'f_nom_code', '') + ',' + 
            GetDBColumnName('Details.dat', 'f_nom_mode', '') + ',' + 
            GetDBColumnName('Details.dat', 'f_currency', '') + ',' + 
            GetDBColumnName('Details.dat', 'f_p_yr', '') + ',' + 
            GetDBColumnName('Details.dat', 'f_p_pr', '') + ',' + 
            GetDBColumnName('Details.dat', 'f_department', '') + ',' + 
            GetDBColumnName('Details.dat', 'f_cost_centre', '') + ',' + 
            GetDBColumnName('Details.dat', 'f_stock_code', '') + ',' + 
            GetDBColumnName('Details.dat', 'f_abs_line_no', '') + ',' + 
            GetDBColumnName('Details.dat', 'f_line_type', '') + ',' + 
            GetDBColumnName('Details.dat', 'f_id_doc_hed', '') + ',' + 
            GetDBColumnName('Details.dat', 'f_dll_update', '') + ',' + 
            GetDBColumnName('Details.dat', 'f_old_ser_qty', '') + ',' + 
            GetDBColumnName('Details.dat', 'f_qty', '') + ',' + 
            GetDBColumnName('Details.dat', 'f_qty_mul', '') + ',' + 
            GetDBColumnName('Details.dat', 'f_net_value', '') + ',' + 
            GetDBColumnName('Details.dat', 'f_discount', '') + ',' + 
            GetDBColumnName('Details.dat', 'f_vat_code', '') + ',' + 
            GetDBColumnName('Details.dat', 'f_vat', '') + ',' + 
            GetDBColumnName('Details.dat', 'f_payment', '') + ',' + 
            GetDBColumnName('Details.dat', 'f_old_p_bal', '') + ',' + 
            GetDBColumnName('Details.dat', 'f_reconcile', '') + ',' + 
            GetDBColumnName('Details.dat', 'f_discount_chr', '') + ',' + 
            GetDBColumnName('Details.dat', 'f_qty_woff', '') + ',' + 
            GetDBColumnName('Details.dat', 'f_qty_del', '') + ',' + 
            GetDBColumnName('Details.dat', 'f_cost_price', '') + ',' + 
            GetDBColumnName('Details.dat', 'f_cust_code', '') + ',' + 
            GetDBColumnName('Details.dat', 'f_p_date', '') + ',' + 
            GetDBColumnName('Details.dat', 'f_item', '') + ',' + 
            GetDBColumnName('Details.dat', 'f_description', '') + ',' + 
            GetDBColumnName('Details.dat', 'f_job_code', '') + ',' + 
            GetDBColumnName('Details.dat', 'f_anal_code', '') + ',' + 
            GetDBColumnName('Details.dat', 'f_cx_rate1', '') + ',' + 
            GetDBColumnName('Details.dat', 'f_cx_rate2', '') + ',' + 
            GetDBColumnName('Details.dat', 'f_l_weight', '') + ',' + 
            GetDBColumnName('Details.dat', 'f_deduct_qty', '') + ',' + 
            GetDBColumnName('Details.dat', 'f_kit_link', '') + ',' + 
            GetDBColumnName('Details.dat', 'f_sop_link', '') + ',' + 
            GetDBColumnName('Details.dat', 'f_sop_line_no', '') + ',' + 
            GetDBColumnName('Details.dat', 'f_m_loc_stk', '') + ',' + 
            GetDBColumnName('Details.dat', 'f_qty_pick', '') + ',' + 
            GetDBColumnName('Details.dat', 'f_qty_pw_off', '') + ',' + 
            GetDBColumnName('Details.dat', 'f_use_pack', '') + ',' + 
            GetDBColumnName('Details.dat', 'f_serial_qty', '') + ',' + 
            GetDBColumnName('Details.dat', 'f_cos_nom_code', '') + ',' + 
            GetDBColumnName('Details.dat', 'f_doc_p_ref', '') + ',' + 
            GetDBColumnName('Details.dat', 'f_doc_lt_link', '') + ',' + 
            GetDBColumnName('Details.dat', 'f_prx_pack', '') + ',' +
            GetDBColumnName('Details.dat', 'f_qty_pack', '') + ',' + 
            GetDBColumnName('Details.dat', 'f_recon_date', '') + ',' + 
            GetDBColumnName('Details.dat', 'f_show_case', '') + ',' + 
            GetDBColumnName('Details.dat', 'f_sdb_folio', '') + ',' + 
            GetDBColumnName('Details.dat', 'f_o_base_equiv', '') + ',' + 
            GetDBColumnName('Details.dat', 'f_use_o_rate', '') + ',' + 
            GetDBColumnName('Details.dat', 'f_line_user1', '') + ',' + 
            GetDBColumnName('Details.dat', 'f_line_user2', '') + ',' + 
            GetDBColumnName('Details.dat', 'f_line_user3', '') + ',' + 
            GetDBColumnName('Details.dat', 'f_line_user4', '') + ',' + 
            GetDBColumnName('Details.dat', 'f_ssd_uplift', '') + ',' + 
            GetDBColumnName('Details.dat', 'f_ssd_country', '') + ',' + 
            GetDBColumnName('Details.dat', 'f_vat_inc_flg', '') + ',' + 
            GetDBColumnName('Details.dat', 'f_ssd_commod', '') + ',' + 
            GetDBColumnName('Details.dat', 'f_ssdsp_unit', '') + ',' + 
            GetDBColumnName('Details.dat', 'f_price_mulx', '') + ',' + 
            GetDBColumnName('Details.dat', 'f_b2b_link', '') + ',' + 
            GetDBColumnName('Details.dat', 'f_b2b_line_no', '') + ',' + 
            GetDBColumnName('Details.dat', 'f_tri_rates', '') + ',' + 
            GetDBColumnName('Details.dat', 'f_tri_euro', '') + ',' + 
            GetDBColumnName('Details.dat', 'f_tri_invert', '') + ',' + 
            GetDBColumnName('Details.dat', 'f_tri_float', '') + ',' + 
            GetDBColumnName('Details.dat', 'f_spare1', '') + ',' + 
            GetDBColumnName('Details.dat', 'f_ssd_use_line', '') + ',' + 
            GetDBColumnName('Details.dat', 'f_previous_bal', '') + ',' + 
            GetDBColumnName('Details.dat', 'f_live_uplift', '') + ',' + 
            GetDBColumnName('Details.dat', 'f_cos_conv_rate', '') + ',' + 
            GetDBColumnName('Details.dat', 'f_inc_net_value', '') + ',' + 
            GetDBColumnName('Details.dat', 'f_auto_line_type', '') + ',' + 
            GetDBColumnName('Details.dat', 'f_cis_rate_code', '') + ',' + 
            GetDBColumnName('Details.dat', 'f_cis_rate', '') + ',' + 
            GetDBColumnName('Details.dat', 'f_cost_apport', '') + ',' + 
            GetDBColumnName('Details.dat', 'f_nomio_flg', '') + ',' + 
            GetDBColumnName('Details.dat', 'f_bin_qty', '') + ',' + 
            GetDBColumnName('Details.dat', 'f_cis_adjust', '') + ',' + 
            GetDBColumnName('Details.dat', 'f_jap_ded_type', '') + ',' + 
            GetDBColumnName('Details.dat', 'f_serial_ret_qty', '') + ',' + 
            GetDBColumnName('Details.dat', 'f_bin_ret_qty', '') + ',' +
            GetDBColumnName('Details.dat', 'f_discount2', '') + ',' +
            GetDBColumnName('Details.dat', 'f_discount2_chr', '') + ',' +
            GetDBColumnName('Details.dat', 'f_discount3', '') + ',' +
            GetDBColumnName('Details.dat', 'f_discount3_chr', '') + ',' +
            GetDBColumnName('Details.dat', 'f_discount3_type', '') + ',' +
            GetDBColumnName('Details.dat', 'f_ecservice', '') + ',' +
            GetDBColumnName('Details.dat', 'f_service_start_date', '') + ',' +
            GetDBColumnName('Details.dat', 'f_service_end_date', '') + ',' +
            GetDBColumnName('Details.dat', 'f_ecsales_tax_reported', '') + ',' +
            GetDBColumnName('Details.dat', 'f_purchase_service_tax', '') + ',' +
            GetDBColumnName('Details.dat', 'f_reference', '') + ',' +
            GetDBColumnName('Details.dat', 'f_receipt_no', '') + ',' +
            GetDBColumnName('Details.dat', 'f_from_postcode', '') + ',' +
            GetDBColumnName('Details.dat', 'f_to_postcode', '') + ',' +
            GetDBColumnName('Details.dat', 'f_line_user5', '') + ',' +
            GetDBColumnName('Details.dat', 'f_line_user6', '') + ',' +
            GetDBColumnName('Details.dat', 'f_line_user7', '') + ',' +
            GetDBColumnName('Details.dat', 'f_line_user8', '') + ',' +
            GetDBColumnName('Details.dat', 'f_line_user9', '') + ',' +
            GetDBColumnName('Details.dat', 'f_line_user10', '') + ',' +
            GetDBColumnName('Details.dat', 'f_threshold_code', '') + ',' +
            GetDBColumnName('Details.dat', 'f_materials_only_retention', '') + ',' +
            GetDBColumnName('Details.dat', 'f_intrastat_notc', '') + ',' +
            GetDBColumnName('Details.dat', 'f_tax_region', '');
end;
  
function GetAllDataVarTypeFields : string;
begin
  Result := GetDBColumnName('Dictionary.dat', 'rec_pfix', '') + ',' + 
            GetDBColumnName('Dictionary.dat', 'sub_type', '') + ',' + 
            GetDBColumnName('Dictionary.dat', 'var_name_key', '') + ',' + 
            GetDBColumnName('Dictionary.dat', 'var_pad_name', '') + ',' + 
            GetDBColumnName('Dictionary.dat', 'var_desc', 'DV') + ',' + 
            GetDBColumnName('Dictionary.dat', 'var_no', 'DV') + ',' + 
            GetDBColumnName('Dictionary.dat', 'rep_desc', 'DV') + ',' + 
            GetDBColumnName('Dictionary.dat', 'avail_file', 'DV') + ',' + 
            GetDBColumnName('Dictionary.dat', 'avail_ver', 'DV') + ',' + 
            GetDBColumnName('Dictionary.dat', 'pr_sel', 'DV') + ',' + 
            GetDBColumnName('Dictionary.dat', 'var_type', 'DV') + ',' + 
            GetDBColumnName('Dictionary.dat', 'var_len', 'DV') + ',' + 
            GetDBColumnName('Dictionary.dat', 'var_no_dec', 'DV') + ',' + 
            GetDBColumnName('Dictionary.dat', 'var_dec', 'DV') + ',' + 
            GetDBColumnName('Dictionary.dat', 'var_dec_type', 'DV') + ',' + 
            GetDBColumnName('Dictionary.dat', 'format', 'DV') + ',' + 
            GetDBColumnName('Dictionary.dat', 'n_line_count', 'DV') + ',' + 
            GetDBColumnName('Dictionary.dat', 'input_type', 'DV') + ',' + 
            GetDBColumnName('Dictionary.dat', 'avail_file2', 'DV') ;
end;
  
function GetAllDataXRefTypeFields : string;
begin
  Result := GetDBColumnName('Dictionary.dat', 'rec_pfix', '') + ',' + 
            GetDBColumnName('Dictionary.dat', 'sub_type', '') + ',' + 
            GetDBColumnName('Dictionary.dat', 'var_name_key', '') + ',' + 
            GetDBColumnName('Dictionary.dat', 'var_pad_name', '') + ',' + 
            GetDBColumnName('Dictionary.dat', 'spare', 'DX') + ',' + 
            GetDBColumnName('Dictionary.dat', 'var_file_no', 'DX') + ',' + 
            GetDBColumnName('Dictionary.dat', 'var_ex_vers', 'DX') ;
end;
  
function GetAllDocumentFields : string;
begin
  Result := GetDBColumnName('Document.dat', 'f_run_no', '') + ',' + 
            GetDBColumnName('Document.dat', 'f_cust_code', '') + ',' + 
            GetDBColumnName('Document.dat', 'f_nom_auto', '') + ',' + 
            GetDBColumnName('Document.dat', 'f_our_ref', '') + ',' + 
            GetDBColumnName('Document.dat', 'f_folio_num', '') + ',' + 
            GetDBColumnName('Document.dat', 'f_currency', '') + ',' + 
            GetDBColumnName('Document.dat', 'f_ac_yr', '') + ',' + 
            GetDBColumnName('Document.dat', 'f_ac_pr', '') + ',' + 
            GetDBColumnName('Document.dat', 'f_due_date', '') + ',' + 
            GetDBColumnName('Document.dat', 'f_vat_post_date', '') + ',' + 
            GetDBColumnName('Document.dat', 'f_trans_date', '') + ',' + 
            GetDBColumnName('Document.dat', 'f_cust_supp', '') + ',' + 
            GetDBColumnName('Document.dat', 'f_cx_rate_co', '') + ',' + 
            GetDBColumnName('Document.dat', 'f_cx_rate_vat', '') + ',' + 
            GetDBColumnName('Document.dat', 'f_old_your_ref', '') + ',' + 
            GetDBColumnName('Document.dat', 'f_batch_link', '') + ',' + 
            GetDBColumnName('Document.dat', 'f_alloc_stat', '') + ',' + 
            GetDBColumnName('Document.dat', 'f_i_line_count', '') + ',' + 
            GetDBColumnName('Document.dat', 'f_n_line_count', '') + ',' + 
            GetDBColumnName('Document.dat', 'f_inv_doc_hed', '') + ',' + 
            GetDBColumnName('Document.dat', 'f_inv_vat_anal1', '') + ',' + 
            GetDBColumnName('Document.dat', 'f_inv_vat_anal2', '') + ',' + 
            GetDBColumnName('Document.dat', 'f_inv_vat_anal3', '') + ',' + 
            GetDBColumnName('Document.dat', 'f_inv_vat_anal4', '') + ',' + 
            GetDBColumnName('Document.dat', 'f_inv_vat_anal5', '') + ',' + 
            GetDBColumnName('Document.dat', 'f_inv_vat_anal6', '') + ',' + 
            GetDBColumnName('Document.dat', 'f_inv_vat_anal7', '') + ',' + 
            GetDBColumnName('Document.dat', 'f_inv_vat_anal8', '') + ',' + 
            GetDBColumnName('Document.dat', 'f_inv_vat_anal9', '') + ',' + 
            GetDBColumnName('Document.dat', 'f_inv_vat_anal10', '') + ',' + 
            GetDBColumnName('Document.dat', 'f_inv_vat_anal11', '') + ',' + 
            GetDBColumnName('Document.dat', 'f_inv_vat_anal12', '') + ',' + 
            GetDBColumnName('Document.dat', 'f_inv_vat_anal13', '') + ',' + 
            GetDBColumnName('Document.dat', 'f_inv_vat_anal14', '') + ',' + 
            GetDBColumnName('Document.dat', 'f_inv_vat_anal15', '') + ',' + 
            GetDBColumnName('Document.dat', 'f_inv_vat_anal16', '') + ',' + 
            GetDBColumnName('Document.dat', 'f_inv_vat_anal17', '') + ',' + 
            GetDBColumnName('Document.dat', 'f_inv_vat_anal18', '') + ',' + 
            GetDBColumnName('Document.dat', 'f_inv_vat_anal19', '') + ',' + 
            GetDBColumnName('Document.dat', 'f_inv_vat_anal20', '') + ',' + 
            GetDBColumnName('Document.dat', 'f_inv_vat_anal21', '') + ',' + 
            GetDBColumnName('Document.dat', 'f_inv_vat_anal22', '') + ',' + 
            GetDBColumnName('Document.dat', 'f_inv_vat_anal23', '') + ',' + 
            GetDBColumnName('Document.dat', 'f_inv_vat_anal24', '') + ',' + 
            GetDBColumnName('Document.dat', 'f_inv_net_val', '') + ',' + 
            GetDBColumnName('Document.dat', 'f_inv_vat', '') + ',' + 
            GetDBColumnName('Document.dat', 'f_disc_setl', '') + ',' + 
            GetDBColumnName('Document.dat', 'f_disc_set_am', '') + ',' + 
            GetDBColumnName('Document.dat', 'f_disc_amount', '') + ',' + 
            GetDBColumnName('Document.dat', 'f_disc_days', '') + ',' + 
            GetDBColumnName('Document.dat', 'f_disc_taken', '') + ',' + 
            GetDBColumnName('Document.dat', 'f_settled', '') + ',' + 
            GetDBColumnName('Document.dat', 'f_auto_inc', '') + ',' + 
            GetDBColumnName('Document.dat', 'f_un_yr', '') + ',' + 
            GetDBColumnName('Document.dat', 'f_un_pr', '') + ',' + 
            GetDBColumnName('Document.dat', 'f_trans_nat', '') + ',' + 
            GetDBColumnName('Document.dat', 'f_trans_mode', '') + ',' + 
            GetDBColumnName('Document.dat', 'f_remit_no', '') + ',' + 
            GetDBColumnName('Document.dat', 'f_auto_inc_by', '') + ',' + 
            GetDBColumnName('Document.dat', 'f_hold_flg', '') + ',' + 
            GetDBColumnName('Document.dat', 'f_audit_flg', '') + ',' + 
            GetDBColumnName('Document.dat', 'f_total_weight', '') + ',' + 
            GetDBColumnName('Document.dat', 'f_delivery_addr1', '') + ',' + 
            GetDBColumnName('Document.dat', 'f_delivery_addr2', '') + ',' + 
            GetDBColumnName('Document.dat', 'f_delivery_addr3', '') + ',' + 
            GetDBColumnName('Document.dat', 'f_delivery_addr4', '') + ',' + 
            GetDBColumnName('Document.dat', 'f_delivery_addr5', '') + ',' + 
            GetDBColumnName('Document.dat', 'f_variance', '') + ',' + 
            GetDBColumnName('Document.dat', 'f_total_ordered', '') + ',' + 
            GetDBColumnName('Document.dat', 'f_total_reserved', '') + ',' + 
            GetDBColumnName('Document.dat', 'f_total_cost', '') + ',' + 
            GetDBColumnName('Document.dat', 'f_total_invoiced', '') + ',' + 
            GetDBColumnName('Document.dat', 'f_trans_desc', '') + ',' + 
            GetDBColumnName('Document.dat', 'f_until_date', '') + ',' + 
            GetDBColumnName('Document.dat', 'f_nomvatio', '') + ',' + 
            GetDBColumnName('Document.dat', 'f_external_doc', '') + ',' + 
            GetDBColumnName('Document.dat', 'f_printed_doc', '') + ',' + 
            GetDBColumnName('Document.dat', 'f_re_value_adj', '') + ',' + 
            GetDBColumnName('Document.dat', 'f_curr_settled', '') + ',' + 
            GetDBColumnName('Document.dat', 'f_settled_vat', '') + ',' + 
            GetDBColumnName('Document.dat', 'f_vat_claimed', '') + ',' + 
            GetDBColumnName('Document.dat', 'f_batch_nom', '') + ',' + 
            GetDBColumnName('Document.dat', 'f_auto_post', '') + ',' + 
            GetDBColumnName('Document.dat', 'f_man_vat', '') + ',' + 
            GetDBColumnName('Document.dat', 'f_del_terms', '') + ',' + 
            GetDBColumnName('Document.dat', 'f_on_pick_run', '') + ',' + 
            GetDBColumnName('Document.dat', 'f_op_name', '') + ',' + 
            GetDBColumnName('Document.dat', 'f_no_labels', '') + ',' + 
            GetDBColumnName('Document.dat', 'f_tagged', '') + ',' + 
            GetDBColumnName('Document.dat', 'f_pick_run_no', '') + ',' + 
            GetDBColumnName('Document.dat', 'f_ord_match', '') + ',' + 
            GetDBColumnName('Document.dat', 'f_deliver_ref', '') + ',' + 
            GetDBColumnName('Document.dat', 'f_exch_cal_co_rate', '') + ',' + 
            GetDBColumnName('Document.dat', 'f_exch_cal_vat_rate', '') + ',' + 
            GetDBColumnName('Document.dat', 'f_orig_co_rate', '') + ',' + 
            GetDBColumnName('Document.dat', 'f_orig_vat_rate', '') + ',' + 
            GetDBColumnName('Document.dat', 'f_post_disc_am', '') + ',' + 
            GetDBColumnName('Document.dat', 'f_fr_nom_code', '') + ',' + 
            GetDBColumnName('Document.dat', 'f_p_disc_taken', '') + ',' + 
            GetDBColumnName('Document.dat', 'f_ctrl_nom', '') + ',' + 
            GetDBColumnName('Document.dat', 'f_d_job_code', '') + ',' + 
            GetDBColumnName('Document.dat', 'f_d_job_anal', '') + ',' + 
            GetDBColumnName('Document.dat', 'f_tot_ord_os', '') + ',' + 
            GetDBColumnName('Document.dat', 'f_fr_department', '') + ',' + 
            GetDBColumnName('Document.dat', 'f_fr_cost_centre', '') + ',' + 
            GetDBColumnName('Document.dat', 'f_doc_user1', '') + ',' + 
            GetDBColumnName('Document.dat', 'f_doc_user2', '') + ',' + 
            GetDBColumnName('Document.dat', 'f_doc_l_split1', '') + ',' + 
            GetDBColumnName('Document.dat', 'f_doc_l_split2', '') + ',' + 
            GetDBColumnName('Document.dat', 'f_doc_l_split3', '') + ',' + 
            GetDBColumnName('Document.dat', 'f_doc_l_split4', '') + ',' + 
            GetDBColumnName('Document.dat', 'f_doc_l_split5', '') + ',' + 
            GetDBColumnName('Document.dat', 'f_doc_l_split6', '') + ',' + 
            GetDBColumnName('Document.dat', 'f_last_letter', '') + ',' + 
            GetDBColumnName('Document.dat', 'f_batch_now', '') + ',' + 
            GetDBColumnName('Document.dat', 'f_batch_then', '') + ',' + 
            GetDBColumnName('Document.dat', 'f_un_tagged', '') + ',' + 
            GetDBColumnName('Document.dat', 'f_o_base_equiv', '') + ',' + 
            GetDBColumnName('Document.dat', 'f_use_o_rate', '') + ',' + 
            GetDBColumnName('Document.dat', 'f_old_co_rate', '') + ',' + 
            GetDBColumnName('Document.dat', 'f_old_vat_rate', '') + ',' + 
            GetDBColumnName('Document.dat', 'f_sop_keep_rate', '') + ',' + 
            GetDBColumnName('Document.dat', 'f_doc_user3', '') + ',' + 
            GetDBColumnName('Document.dat', 'f_doc_user4', '') + ',' + 
            GetDBColumnName('Document.dat', 'f_ssd_process', '') + ',' + 
            GetDBColumnName('Document.dat', 'f_ext_source', '') + ',' + 
            GetDBColumnName('Document.dat', 'f_curr_tri_rate', '') + ',' + 
            GetDBColumnName('Document.dat', 'f_curr_tri_euro', '') + ',' + 
            GetDBColumnName('Document.dat', 'f_curr_tri_invert', '') + ',' + 
            GetDBColumnName('Document.dat', 'f_curr_tri_float', '') + ',' + 
            GetDBColumnName('Document.dat', 'f_curr_tri_spare', '') + ',' + 
            GetDBColumnName('Document.dat', 'f_vat_tri_rate', '') + ',' + 
            GetDBColumnName('Document.dat', 'f_vat_tri_euro', '') + ',' + 
            GetDBColumnName('Document.dat', 'f_vat_tri_invert', '') + ',' + 
            GetDBColumnName('Document.dat', 'f_vat_tri_float', '') + ',' + 
            GetDBColumnName('Document.dat', 'f_vat_tri_spare', '') + ',' + 
            GetDBColumnName('Document.dat', 'f_orig_tri_rate', '') + ',' + 
            GetDBColumnName('Document.dat', 'f_orig_tri_euro', '') + ',' + 
            GetDBColumnName('Document.dat', 'f_orig_tri_invert', '') + ',' + 
            GetDBColumnName('Document.dat', 'f_orig_tri_float', '') + ',' + 
            GetDBColumnName('Document.dat', 'f_orig_tri_spare', '') + ',' + 
            GetDBColumnName('Document.dat', 'f_old_or_tri_rate', '') + ',' + 
            GetDBColumnName('Document.dat', 'f_old_or_tri_euro', '') + ',' + 
            GetDBColumnName('Document.dat', 'f_old_or_tri_invert', '') + ',' + 
            GetDBColumnName('Document.dat', 'f_old_or_tri_float', '') + ',' + 
            GetDBColumnName('Document.dat', 'f_old_or_tri_spare', '') + ',' + 
            GetDBColumnName('Document.dat', 'f_post_date', '') + ',' + 
            GetDBColumnName('Document.dat', 'f_por_pick_sor', '') + ',' + 
            GetDBColumnName('Document.dat', 'f_b_discount', '') + ',' + 
            GetDBColumnName('Document.dat', 'f_pre_post_flg', '') + ',' + 
            GetDBColumnName('Document.dat', 'f_auth_amnt', '') + ',' + 
            GetDBColumnName('Document.dat', 'f_time_change', '') + ',' + 
            GetDBColumnName('Document.dat', 'f_time_create', '') + ',' + 
            GetDBColumnName('Document.dat', 'f_cis_tax', '') + ',' + 
            GetDBColumnName('Document.dat', 'f_cis_declared', '') + ',' + 
            GetDBColumnName('Document.dat', 'f_cis_manual_tax', '') + ',' + 
            GetDBColumnName('Document.dat', 'f_cis_date', '') + ',' + 
            GetDBColumnName('Document.dat', 'f_total_cost2', '') + ',' + 
            GetDBColumnName('Document.dat', 'f_cis_empl', '') + ',' + 
            GetDBColumnName('Document.dat', 'f_cis_gross', '') + ',' + 
            GetDBColumnName('Document.dat', 'f_cis_holder', '') + ',' + 
            GetDBColumnName('Document.dat', 'f_h_exported_flag', '') + ',' + 
            GetDBColumnName('Document.dat', 'f_cisg_exclude', '') + ',' + 
            GetDBColumnName('Document.dat', 'f_spare5', '') + ',' +
            GetDBColumnName('Document.dat', 'f_your_ref', '') + ',' +
            GetDBColumnName('Document.dat', 'f_doc_user5', '') + ',' +
            GetDBColumnName('Document.dat', 'f_doc_user6', '') + ',' +
            GetDBColumnName('Document.dat', 'f_doc_user7', '') + ',' +
            GetDBColumnName('Document.dat', 'f_doc_user8', '') + ',' +
            GetDBColumnName('Document.dat', 'f_doc_user9', '') + ',' +
            GetDBColumnName('Document.dat', 'f_doc_user10', '')+ ',' +
            GetDBColumnName('Document.dat', 'f_delivery_postcode', '') + ',' +
            GetDBColumnName('Document.dat', 'f_originator', '') + ',' +
            GetDBColumnName('Document.dat', 'f_creation_time', '') + ',' +
            GetDBColumnName('Document.dat', 'f_creation_date', '') + ',' +
            GetDBColumnName('Document.dat', 'f_order_payment_order_ref', '') + ',' +
            GetDBColumnName('Document.dat', 'f_order_payment_element', '') + ',' +
            GetDBColumnName('Document.dat', 'f_order_payment_flags', '') + ',' +
            GetDBColumnName('Document.dat', 'f_credit_card_type', '') + ',' +
            GetDBColumnName('Document.dat', 'f_credit_card_number', '') + ',' +
            GetDBColumnName('Document.dat', 'f_credit_card_expiry', '') + ',' +
            GetDBColumnName('Document.dat', 'f_credit_card_authorisation_no', '') + ',' +
            GetDBColumnName('Document.dat', 'f_credit_card_reference_no', '') + ',' +
            GetDBColumnName('Document.dat', 'f_custom_data1', '') + ',' +
            GetDBColumnName('Document.dat', 'f_delivery_country', '') + ',' +
            GetDBColumnName('Document.dat', 'f_ppd_percentage', '') + ',' +
            GetDBColumnName('Document.dat', 'f_ppd_days', '') + ',' +
            GetDBColumnName('Document.dat', 'f_ppd_goods_value', '') + ',' +
            GetDBColumnName('Document.dat', 'f_ppd_vat_value', '') + ',' +
            GetDBColumnName('Document.dat', 'f_ppd_taken', '') + ',' +
            GetDBColumnName('Document.dat', 'f_ppd_credit_note', '') + ',' +
            GetDBColumnName('Document.dat', 'f_batch_pay_ppd_status', '') + ',' +
            GetDBColumnName('Document.dat', 'f_intrastat_out_of_period', '') + ',' +
            GetDBColumnName('Document.dat', 'f_doc_user11', '') + ',' +
            GetDBColumnName('Document.dat', 'f_doc_user12', '') + ',' +
            GetDBColumnName('Document.dat', 'f_tax_region', '');
end;
  
function GetAllTebusParamsFields : string;
begin
  Result := GetDBColumnName('Ebus.dat', 'rec_pfix', '') + ',' + 
            GetDBColumnName('Ebus.dat', 'sub_type', '') + ',' + 
            GetDBColumnName('Ebus.dat', 'ebus_code1', '') + ',' + 
            GetDBColumnName('Ebus.dat', 'ebus_code2', '') + ',' + 
            GetDBColumnName('Ebus.dat', 'ent_default_company', 'EG') + ',' + 
            GetDBColumnName('Ebus.dat', 'ent_csv_map_file_dir', 'EG') + ',' + 
            GetDBColumnName('Ebus.dat', 'ent_text_file_dir', 'EG') + ',' + 
            GetDBColumnName('Ebus.dat', 'ent_poll_freq', 'EG') + ',' + 
            GetDBColumnName('Ebus.dat', 'ent_setup_password', 'EG') ;
end;
  
function GetAllTebusDragNetFields : string;
begin
  Result := GetDBColumnName('Ebus.dat', 'rec_pfix', '') + ',' + 
            GetDBColumnName('Ebus.dat', 'sub_type', '') + ',' + 
            GetDBColumnName('Ebus.dat', 'ebus_code1', '') + ',' + 
            GetDBColumnName('Ebus.dat', 'ebus_code2', '') + ',' + 
            GetDBColumnName('Ebus.dat', 'dnet_publisher_code', 'DG') + ',' + 
            GetDBColumnName('Ebus.dat', 'dnet_publisher_password', 'DG') ;
end;
  
function GetAllTebusCompanyFields : string;
begin
  Result := GetDBColumnName('Ebus.dat', 'rec_pfix', '') + ',' + 
            GetDBColumnName('Ebus.dat', 'sub_type', '') + ',' + 
            GetDBColumnName('Ebus.dat', 'ebus_code1', '') + ',' + 
            GetDBColumnName('Ebus.dat', 'ebus_code2', '') + ',' + 
            GetDBColumnName('Ebus.dat', 'comp_posting_log_dir', 'EC') + ',' + 
            GetDBColumnName('Ebus.dat', 'comp_def_cost_centre', 'EC') + ',' + 
            GetDBColumnName('Ebus.dat', 'comp_def_dept', 'EC') + ',' + 
            GetDBColumnName('Ebus.dat', 'comp_def_location', 'EC') + ',' + 
            GetDBColumnName('Ebus.dat', 'comp_def_customer', 'EC') + ',' + 
            GetDBColumnName('Ebus.dat', 'comp_def_supplier', 'EC') + ',' + 
            GetDBColumnName('Ebus.dat', 'comp_def_purch_nom', 'EC') + ',' + 
            GetDBColumnName('Ebus.dat', 'comp_def_sales_nom', 'EC') + ',' + 
            GetDBColumnName('Ebus.dat', 'comp_def_vat_code', 'EC') + ',' + 
            GetDBColumnName('Ebus.dat', 'comp_set_period_method', 'EC') + ',' + 
            GetDBColumnName('Ebus.dat', 'comp_period', 'EC') + ',' + 
            GetDBColumnName('Ebus.dat', 'comp_year', 'EC') + ',' + 
            GetDBColumnName('Ebus.dat', 'comp_keep_trans_no', 'EC') + ',' + 
            GetDBColumnName('Ebus.dat', 'comp_post_hold_flag', 'EC') + ',' + 
            GetDBColumnName('Ebus.dat', 'comp_trans_text_dir', 'EC') + ',' + 
            GetDBColumnName('Ebus.dat', 'comp_ord_ok_text_file', 'EC') + ',' + 
            GetDBColumnName('Ebus.dat', 'comp_ord_fail_text_file', 'EC') + ',' + 
            GetDBColumnName('Ebus.dat', 'comp_inv_ok_text_file', 'EC') + ',' + 
            GetDBColumnName('Ebus.dat', 'comp_inv_fail_text_file', 'EC') + ',' + 
            GetDBColumnName('Ebus.dat', 'comp_xml_after_process', 'EC') + ',' + 
            GetDBColumnName('Ebus.dat', 'comp_csv_delimiter', 'EC') + ',' + 
            GetDBColumnName('Ebus.dat', 'comp_csv_separator', 'EC') + ',' + 
            GetDBColumnName('Ebus.dat', 'comp_csv_inc_header_row', 'EC') + ',' + 
            GetDBColumnName('Ebus.dat', 'comp_freight_line', 'EC') + ',' + 
            GetDBColumnName('Ebus.dat', 'comp_misc_line', 'EC') + ',' + 
            GetDBColumnName('Ebus.dat', 'comp_discount', 'EC') + ',' + 
            GetDBColumnName('Ebus.dat', 'comp_cust_lock_file', 'EC') + ',' + 
            GetDBColumnName('Ebus.dat', 'comp_stock_lock_file', 'EC') + ',' + 
            GetDBColumnName('Ebus.dat', 'comp_stock_grp_lock_file', 'EC') + ',' + 
            GetDBColumnName('Ebus.dat', 'comp_trans_lock_file', 'EC') + ',' + 
            GetDBColumnName('Ebus.dat', 'comp_cust_lock_ext', 'EC') + ',' + 
            GetDBColumnName('Ebus.dat', 'comp_stock_lock_ext', 'EC') + ',' + 
            GetDBColumnName('Ebus.dat', 'comp_stock_grp_lock_ext', 'EC') + ',' + 
            GetDBColumnName('Ebus.dat', 'comp_trans_lock_ext', 'EC') + ',' + 
            GetDBColumnName('Ebus.dat', 'comp_cust_lock_method', 'EC') + ',' + 
            GetDBColumnName('Ebus.dat', 'comp_stock_lock_method', 'EC') + ',' + 
            GetDBColumnName('Ebus.dat', 'comp_stock_grp_method', 'EC') + ',' + 
            GetDBColumnName('Ebus.dat', 'comp_trans_lock_method', 'EC') + ',' + 
            GetDBColumnName('Ebus.dat', 'comp_use_stock_for_charges', 'EC') + ',' + 
            GetDBColumnName('Ebus.dat', 'comp_freight_stock_code', 'EC') + ',' + 
            GetDBColumnName('Ebus.dat', 'comp_misc_stock_code', 'EC') + ',' + 
            GetDBColumnName('Ebus.dat', 'comp_disc_stock_code', 'EC') + ',' + 
            GetDBColumnName('Ebus.dat', 'comp_freight_desc', 'EC') + ',' + 
            GetDBColumnName('Ebus.dat', 'comp_misc_desc', 'EC') + ',' + 
            GetDBColumnName('Ebus.dat', 'comp_disc_desc', 'EC') + ',' + 
            GetDBColumnName('Ebus.dat', 'comp_reapply_pricing', 'EC') + ',' + 
            GetDBColumnName('Ebus.dat', 'comp_your_ref_to_alt_ref', 'EC') + ',' + 
            GetDBColumnName('Ebus.dat', 'comp_use_matching', 'EC') + ',' + 
            GetDBColumnName('Ebus.dat', 'comp_sentimail_event', 'EC') + ',' + 
            GetDBColumnName('Ebus.dat', 'comp_location_origin', 'EC') + ',' + 
            GetDBColumnName('Ebus.dat', 'comp_import_udf1', 'EC') + ',' + 
            GetDBColumnName('Ebus.dat', 'comp_general_notes', 'EC') + ',' + 
            GetDBColumnName('Ebus.dat', 'comp_cc_dep_from_xml', 'EC') ;
end;
  
function GetAllTebusFileCountersFields : string;
begin
  Result := GetDBColumnName('Ebus.dat', 'rec_pfix', '') + ',' + 
            GetDBColumnName('Ebus.dat', 'sub_type', '') + ',' + 
            GetDBColumnName('Ebus.dat', 'ebus_code1', '') + ',' + 
            GetDBColumnName('Ebus.dat', 'ebus_code2', '') + ',' + 
            GetDBColumnName('Ebus.dat', 'stockcounter', 'EN') + ',' + 
            GetDBColumnName('Ebus.dat', 'stockgrpcounter', 'EN') + ',' + 
            GetDBColumnName('Ebus.dat', 'transactioncounter', 'EN') + ',' + 
            GetDBColumnName('Ebus.dat', 'CustomerCounter', 'EN') + ',' + 
            GetDBColumnName('Ebus.dat', 'emailcounter', 'EN') + ',' + 
            GetDBColumnName('Ebus.dat', 'exportlogcounter', 'EN') ;
end;
  
function GetAllTebusImportFields : string;
begin
  Result := GetDBColumnName('Ebus.dat', 'rec_pfix', '') + ',' + 
            GetDBColumnName('Ebus.dat', 'sub_type', '') + ',' + 
            GetDBColumnName('Ebus.dat', 'ebus_code1', '') + ',' + 
            GetDBColumnName('Ebus.dat', 'ebus_code2', '') + ',' + 
            GetDBColumnName('Ebus.dat', 'import_search_dir', 'EI') + ',' + 
            GetDBColumnName('Ebus.dat', 'import_archive_dir', 'EI') + ',' + 
            GetDBColumnName('Ebus.dat', 'import_fail_dir', 'EI') + ',' + 
            GetDBColumnName('Ebus.dat', 'import_log_dir', 'EI') ;
end;
  
function GetAllTebusExportFields : string;
begin
  Result := GetDBColumnName('Ebus.dat', 'rec_pfix', '') + ',' + 
            GetDBColumnName('Ebus.dat', 'sub_type', '') + ',' + 
            GetDBColumnName('Ebus.dat', 'ebus_code1', '') + ',' + 
            GetDBColumnName('Ebus.dat', 'ebus_code2', '') + ',' + 
            GetDBColumnName('Ebus.dat', 'expt_description', 'EX') + ',' + 
            GetDBColumnName('Ebus.dat', 'expt_stock', 'EX') + ',' + 
            GetDBColumnName('Ebus.dat', 'expt_stock_groups', 'EX') + ',' + 
            GetDBColumnName('Ebus.dat', 'expt_customers', 'EX') + ',' + 
            GetDBColumnName('Ebus.dat', 'expt_inc_cur_sales_trans', 'EX') + ',' + 
            GetDBColumnName('Ebus.dat', 'expt_inc_cur_sales_orders', 'EX') + ',' + 
            GetDBColumnName('Ebus.dat', 'expt_inc_cur_purch_trans', 'EX') + ',' + 
            GetDBColumnName('Ebus.dat', 'expt_inc_cur_purch_orders', 'EX') + ',' + 
            GetDBColumnName('Ebus.dat', 'expt_inc_com_pricing', 'EX') + ',' + 
            GetDBColumnName('Ebus.dat', 'expt_ignore_cust_web_inc', 'EX') + ',' + 
            GetDBColumnName('Ebus.dat', 'expt_ignore_stock_web_inc', 'EX') + ',' + 
            GetDBColumnName('Ebus.dat', 'expt_ignore_stock_grp_web_inc', 'EX') + ',' + 
            GetDBColumnName('Ebus.dat', 'expt_cust_file_name', 'EX') + ',' + 
            GetDBColumnName('Ebus.dat', 'expt_stock_file_name', 'EX') + ',' + 
            GetDBColumnName('Ebus.dat', 'expt_stock_loc_file_name', 'EX') + ',' + 
            GetDBColumnName('Ebus.dat', 'expt_stock_group_file_name', 'EX') + ',' + 
            GetDBColumnName('Ebus.dat', 'expt_trans_file_name', 'EX') + ',' + 
            GetDBColumnName('Ebus.dat', 'expt_trans_lines_file_name', 'EX') + ',' + 
            GetDBColumnName('Ebus.dat', 'expt_zip_files', 'EX') + ',' + 
            GetDBColumnName('Ebus.dat', 'expt_transport_type', 'EX') + ',' + 
            GetDBColumnName('Ebus.dat', 'expt_data_type', 'EX') + ',' + 
            GetDBColumnName('Ebus.dat', 'expt_active', 'EX') + ',' + 
            GetDBColumnName('Ebus.dat', 'expt_time_type', 'EX') + ',' + 
            GetDBColumnName('Ebus.dat', 'expt_frequency', 'EX') + ',' + 
            GetDBColumnName('Ebus.dat', 'expt_time1', 'EX') + ',' + 
            GetDBColumnName('Ebus.dat', 'expt_time2', 'EX') + ',' + 
            GetDBColumnName('Ebus.dat', 'expt_days_of_week', 'EX') + ',' + 
            GetDBColumnName('Ebus.dat', 'expt_catalogues', 'EX') + ',' + 
            GetDBColumnName('Ebus.dat', 'expt_csv_cust_map_file', 'EX') + ',' + 
            GetDBColumnName('Ebus.dat', 'expt_csv_stock_map_file', 'EX') + ',' + 
            GetDBColumnName('Ebus.dat', 'expt_csv_stock_grp_map_file', 'EX') + ',' + 
            GetDBColumnName('Ebus.dat', 'expt_csv_trans_map_file', 'EX') + ',' + 
            GetDBColumnName('Ebus.dat', 'expt_last_export_at', 'EX') + ',' + 
            GetDBColumnName('Ebus.dat', 'expt_cust_lock_file', 'EX') + ',' + 
            GetDBColumnName('Ebus.dat', 'expt_stock_lock_file', 'EX') + ',' + 
            GetDBColumnName('Ebus.dat', 'expt_stock_grp_lock_file', 'EX') + ',' + 
            GetDBColumnName('Ebus.dat', 'expt_trans_lock_file', 'EX') + ',' + 
            GetDBColumnName('Ebus.dat', 'expt_cust_lock_ext', 'EX') + ',' + 
            GetDBColumnName('Ebus.dat', 'expt_stock_lock_ext', 'EX') + ',' + 
            GetDBColumnName('Ebus.dat', 'expt_stock_grp_lock_ext', 'EX') + ',' + 
            GetDBColumnName('Ebus.dat', 'expt_trans_lock_ext', 'EX') + ',' + 
            GetDBColumnName('Ebus.dat', 'expt_cust_lock_method', 'EX') + ',' + 
            GetDBColumnName('Ebus.dat', 'expt_stock_lock_method', 'EX') + ',' + 
            GetDBColumnName('Ebus.dat', 'expt_stock_grp_method', 'EX') + ',' + 
            GetDBColumnName('Ebus.dat', 'expt_trans_lock_method', 'EX') + ',' + 
            GetDBColumnName('Ebus.dat', 'expt_stock_filter', 'EX') + ',' + 
            GetDBColumnName('Ebus.dat', 'expt_ignore_com_cust_inc', 'EX') + ',' + 
            GetDBColumnName('Ebus.dat', 'expt_ignore_com_stock_inc', 'EX') + ',' + 
            GetDBColumnName('Ebus.dat', 'expt_command_line', 'EX') + ',' + 
            GetDBColumnName('Ebus.dat', 'expt_cust_acc_type_filter', 'EX') + ',' + 
            GetDBColumnName('Ebus.dat', 'expt_cust_acc_type_filter_flag', 'EX') + ',' + 
            GetDBColumnName('Ebus.dat', 'expt_stock_web_filter', 'EX') + ',' + 
            GetDBColumnName('Ebus.dat', 'expt_stock_web_filter_flag', 'EX') ;
end;
  
function GetAllTebusCatalogueFields : string;
begin
  Result := GetDBColumnName('Ebus.dat', 'rec_pfix', '') + ',' + 
            GetDBColumnName('Ebus.dat', 'sub_type', '') + ',' + 
            GetDBColumnName('Ebus.dat', 'ebus_code1', '') + ',' + 
            GetDBColumnName('Ebus.dat', 'ebus_code2', '') + ',' + 
            GetDBColumnName('Ebus.dat', 'cat_title', 'EA') + ',' + 
            GetDBColumnName('Ebus.dat', 'cat_credit_limit_applies', 'EA') + ',' + 
            GetDBColumnName('Ebus.dat', 'cat_on_hold_applies', 'EA') ;
end;
  
function GetAllTebusFTPFields : string;
begin
  Result := GetDBColumnName('Ebus.dat', 'rec_pfix', '') + ',' + 
            GetDBColumnName('Ebus.dat', 'sub_type', '') + ',' + 
            GetDBColumnName('Ebus.dat', 'ebus_code1', '') + ',' + 
            GetDBColumnName('Ebus.dat', 'ebus_code2', '') + ',' + 
            GetDBColumnName('Ebus.dat', 'ftp_site_port', 'EF') + ',' + 
            GetDBColumnName('Ebus.dat', 'ftp_site_address', 'EF') + ',' + 
            GetDBColumnName('Ebus.dat', 'ftp_user_name', 'EF') + ',' + 
            GetDBColumnName('Ebus.dat', 'ftp_password', 'EF') + ',' + 
            GetDBColumnName('Ebus.dat', 'ftp_request_timeout', 'EF') + ',' + 
            GetDBColumnName('Ebus.dat', 'ftp_proxy_port', 'EF') + ',' + 
            GetDBColumnName('Ebus.dat', 'ftp_proxy_address', 'EF') + ',' + 
            GetDBColumnName('Ebus.dat', 'ftp_passive_mode', 'EF') + ',' + 
            GetDBColumnName('Ebus.dat', 'ftp_root_dir', 'EF') + ',' + 
            GetDBColumnName('Ebus.dat', 'ftp_customer_dir', 'EF') + ',' + 
            GetDBColumnName('Ebus.dat', 'ftp_stock_dir', 'EF') + ',' + 
            GetDBColumnName('Ebus.dat', 'ftpcom_price_dir', 'EF') + ',' + 
            GetDBColumnName('Ebus.dat', 'ftp_transaction_dir', 'EF') ;
end;
  
function GetAllTebusEmailFields : string;
begin
  Result := GetDBColumnName('Ebus.dat', 'rec_pfix', '') + ',' + 
            GetDBColumnName('Ebus.dat', 'sub_type', '') + ',' + 
            GetDBColumnName('Ebus.dat', 'ebus_code1', '') + ',' + 
            GetDBColumnName('Ebus.dat', 'ebus_code2', '') + ',' + 
            GetDBColumnName('Ebus.dat', 'email_enabled', 'EE') + ',' + 
            GetDBColumnName('Ebus.dat', 'email_admin_address', 'EE') + ',' + 
            GetDBColumnName('Ebus.dat', 'email_notify_admin', 'EE') + ',' + 
            GetDBColumnName('Ebus.dat', 'email_type', 'EE') + ',' + 
            GetDBColumnName('Ebus.dat', 'email_server_name', 'EE') + ',' + 
            GetDBColumnName('Ebus.dat', 'email_account_name', 'EE') + ',' + 
            GetDBColumnName('Ebus.dat', 'email_account_password', 'EE') + ',' + 
            GetDBColumnName('Ebus.dat', 'email_notify_sender', 'EE') + ',' + 
            GetDBColumnName('Ebus.dat', 'email_confirm_processing', 'EE') + ',' + 
            GetDBColumnName('Ebus.dat', 'email_customer_addr', 'EE') + ',' + 
            GetDBColumnName('Ebus.dat', 'email_stock_addr', 'EE') + ',' + 
            GetDBColumnName('Ebus.dat', 'email_com_price_addr', 'EE') + ',' + 
            GetDBColumnName('Ebus.dat', 'email_transaction_addr', 'EE') ;
end;
  
function GetAllTebusFileFields : string;
begin
  Result := GetDBColumnName('Ebus.dat', 'rec_pfix', '') + ',' + 
            GetDBColumnName('Ebus.dat', 'sub_type', '') + ',' + 
            GetDBColumnName('Ebus.dat', 'ebus_code1', '') + ',' + 
            GetDBColumnName('Ebus.dat', 'ebus_code2', '') + ',' + 
            GetDBColumnName('Ebus.dat', 'file_customer_dir', 'ED') + ',' + 
            GetDBColumnName('Ebus.dat', 'file_stock_dir', 'ED') + ',' + 
            GetDBColumnName('Ebus.dat', 'file_stock_group_dir', 'ED') + ',' + 
            GetDBColumnName('Ebus.dat', 'file_trans_dir', 'ED') + ',' + 
            GetDBColumnName('Ebus.dat', 'file_com_price_dir', 'ED') ;
end;
  
function GetAllTebusDragNetCompanyFields : string;
begin
  Result := GetDBColumnName('Ebus.dat', 'rec_pfix', '') + ',' + 
            GetDBColumnName('Ebus.dat', 'sub_type', '') + ',' + 
            GetDBColumnName('Ebus.dat', 'ebus_code1', '') + ',' + 
            GetDBColumnName('Ebus.dat', 'ebus_code2', '') + ',' + 
            GetDBColumnName('Ebus.dat', 'dnet_company_code', 'DC') + ',' + 
            GetDBColumnName('Ebus.dat', 'dnet_order_no_start', 'DC') + ',' + 
            GetDBColumnName('Ebus.dat', 'dnet_order_prefix', 'DC') + ',' + 
            GetDBColumnName('Ebus.dat', 'dnet_cust_exported_at', 'DC') + ',' + 
            GetDBColumnName('Ebus.dat', 'dnet_stock_exported_at', 'DC') + ',' + 
            GetDBColumnName('Ebus.dat', 'dnet_last_order_file', 'DC') + ',' + 
            GetDBColumnName('Ebus.dat', 'dnet_use_external_ref', 'DC') + ',' + 
            GetDBColumnName('Ebus.dat', 'dnet_use_catalogues', 'DC') ;
end;
  
function GetAllTebusDragNetCountryFields : string;
begin
  Result := GetDBColumnName('Ebus.dat', 'rec_pfix', '') + ',' + 
            GetDBColumnName('Ebus.dat', 'sub_type', '') + ',' + 
            GetDBColumnName('Ebus.dat', 'ebus_code1', '') + ',' + 
            GetDBColumnName('Ebus.dat', 'ebus_code2', '') + ',' + 
            GetDBColumnName('Ebus.dat', 'dnet_ctry_code', 'DY') + ',' + 
            GetDBColumnName('Ebus.dat', 'dnet_ctry_name', 'DY') + ',' + 
            GetDBColumnName('Ebus.dat', 'dnet_ctry_tax_code', 'DY') + ',' + 
            GetDBColumnName('Ebus.dat', 'dnet_ctry_ecmember', 'DY') + ',' + 
            GetDBColumnName('Ebus.dat', 'dnet_ctry_home_country', 'DY') ;
end;
  
function GetAllTPreserveDocFieldsFields : string;
begin
  Result := GetDBColumnName('Ebus.dat', 'rec_pfix', '') + ',' + 
            GetDBColumnName('Ebus.dat', 'sub_type', '') + ',' + 
            GetDBColumnName('Ebus.dat', 'ebus_code1', '') + ',' + 
            GetDBColumnName('Ebus.dat', 'ebus_code2', '') + ',' + 
            GetDBColumnName('Ebus.dat', 'inv_order_no', 'EP') + ',' + 
            GetDBColumnName('Ebus.dat', 'inv_buyers_order', 'EP') + ',' + 
            GetDBColumnName('Ebus.dat', 'inv_project_code', 'EP') + ',' + 
            GetDBColumnName('Ebus.dat', 'inv_analysis_code', 'EP') + ',' + 
            GetDBColumnName('Ebus.dat', 'inv_supp_invoice', 'EP') + ',' + 
            GetDBColumnName('Ebus.dat', 'inv_buyers_delivery', 'EP') + ',' + 
            GetDBColumnName('Ebus.dat', 'inv_folio', 'EP') + ',' + 
            GetDBColumnName('Ebus.dat', 'inv_posted', 'EP') + ',' + 
            GetDBColumnName('Ebus.dat', 'inv_posted_date', 'EP') ;
end;
  
function GetAllTPreserveLineFieldsFields : string;
begin
  Result := GetDBColumnName('Ebus.dat', 'rec_pfix', '') + ',' + 
            GetDBColumnName('Ebus.dat', 'sub_type', '') + ',' + 
            GetDBColumnName('Ebus.dat', 'ebus_code1', '') + ',' + 
            GetDBColumnName('Ebus.dat', 'ebus_code2', '') + ',' + 
            GetDBColumnName('Ebus.dat', 'id_abs_line_no', 'EQ') + ',' + 
            GetDBColumnName('Ebus.dat', 'id_line_no', 'EQ') + ',' + 
            GetDBColumnName('Ebus.dat', 'id_folio', 'EQ') + ',' + 
            GetDBColumnName('Ebus.dat', 'id_project_code', 'EQ') + ',' + 
            GetDBColumnName('Ebus.dat', 'id_analysis_code', 'EQ') + ',' + 
            GetDBColumnName('Ebus.dat', 'id_buyers_order', 'EQ') + ',' + 
            GetDBColumnName('Ebus.dat', 'id_buyers_line_ref', 'EQ') + ',' + 
            GetDBColumnName('Ebus.dat', 'id_order_no', 'EQ') + ',' + 
            GetDBColumnName('Ebus.dat', 'id_pdn_no', 'EQ') + ',' + 
            GetDBColumnName('Ebus.dat', 'id_pdn_line_no', 'EQ') + ',' + 
            GetDBColumnName('Ebus.dat', 'id_value', 'EQ') + ',' + 
            GetDBColumnName('Ebus.dat', 'id_qty', 'EQ') + ',' + 
            GetDBColumnName('Ebus.dat', 'id_order_line_no', 'EQ') + ',' + 
            GetDBColumnName('Ebus.dat', 'id_stock_code', 'EQ') + ',' + 
            GetDBColumnName('Ebus.dat', 'id_description', 'EQ') + ',' + 
            GetDBColumnName('Ebus.dat', 'id_disc_amount', 'EQ') + ',' + 
            GetDBColumnName('Ebus.dat', 'id_disc_char', 'EQ') ;
end;
  
function GetAllTLookupGenericCFields : string;
begin
  Result := GetDBColumnName('EBUSLKUP.dat', 'rec_pfix', '') + ',' + 
            GetDBColumnName('EBUSLKUP.dat', 'sub_type', '') + ',' + 
            GetDBColumnName('EBUSLKUP.dat', 'ourtradercode', '') + ',' + 
            GetDBColumnName('EBUSLKUP.dat', 'ouritemcode', '') + ',' + 
            GetDBColumnName('EBUSLKUP.dat', 'theiritemcode', '') + ',' + 
            GetDBColumnName('EBUSLKUP.dat', 'description', 'C') + ',' + 
            GetDBColumnName('EBUSLKUP.dat', 'tag', 'C') ;
end;
  
function GetAllTLookupGenericVFields : string;
begin
  Result := GetDBColumnName('EBUSLKUP.dat', 'rec_pfix', '') + ',' + 
            GetDBColumnName('EBUSLKUP.dat', 'sub_type', '') + ',' + 
            GetDBColumnName('EBUSLKUP.dat', 'ourtradercode', '') + ',' + 
            GetDBColumnName('EBUSLKUP.dat', 'ouritemcode', '') + ',' + 
            GetDBColumnName('EBUSLKUP.dat', 'theiritemcode', '') + ',' + 
            GetDBColumnName('EBUSLKUP.dat', 'description', 'V') + ',' + 
            GetDBColumnName('EBUSLKUP.dat', 'tag', 'V') ;
end;
  
function GetAllTFields : string;
begin
  Result := GetDBColumnName('EBUSLKUP.dat', 'rec_pfix', '') + ',' + 
            GetDBColumnName('EBUSLKUP.dat', 'sub_type', '') + ',' + 
            GetDBColumnName('EBUSLKUP.dat', 'ourtradercode', '') + ',' + 
            GetDBColumnName('EBUSLKUP.dat', 'ouritemcode', '') + ',' + 
            GetDBColumnName('EBUSLKUP.dat', 'theiritemcode', '') + ',' + 
            GetDBColumnName('EBUSLKUP.dat', 'lookuptrader', 'T') ;
end;
  
function GetAllNotesTypeNDFields : string;
begin
  Result := GetDBColumnName('EBUSNOTE.dat', 'rec_pfix', '') + ',' + 
            GetDBColumnName('EBUSNOTE.dat', 'sub_type', '') + ',' + 
            GetDBColumnName('EBUSNOTE.dat', 'note_no', '') + ',' + 
            GetDBColumnName('EBUSNOTE.dat', 'note_date', '') + ',' + 
            GetDBColumnName('EBUSNOTE.dat', 'spare3', '') + ',' + 
            GetDBColumnName('EBUSNOTE.dat', 'ebusnote_code1', '') + ',' + 
            GetDBColumnName('EBUSNOTE.dat', 'note_folio', 'ND') + ',' + 
            GetDBColumnName('EBUSNOTE.dat', 'n_type', 'ND') + ',' + 
            GetDBColumnName('EBUSNOTE.dat', 'spare1', 'ND') + ',' + 
            GetDBColumnName('EBUSNOTE.dat', 'line_no', 'ND') + ',' + 
            GetDBColumnName('EBUSNOTE.dat', 'note_line', 'ND') + ',' + 
            GetDBColumnName('EBUSNOTE.dat', 'note_user', 'ND') + ',' + 
            GetDBColumnName('EBUSNOTE.dat', 'tmp_imp_code', 'ND') + ',' + 
            GetDBColumnName('EBUSNOTE.dat', 'show_date', 'ND') + ',' + 
            GetDBColumnName('EBUSNOTE.dat', 'repeat_no', 'ND') + ',' + 
            GetDBColumnName('EBUSNOTE.dat', 'note_for', 'ND') ;
end;
  
function GetAllEmppayFields : string;
begin
  Result := GetDBColumnName('Emppay.dat', 'CoCode', '') + ',' + 
            GetDBColumnName('Emppay.dat', 'EmpCode', '') + ',' + 
            GetDBColumnName('Emppay.dat', 'AcGroup', '') + ',' + 
            GetDBColumnName('Emppay.dat', 'EmpName', '') ;
end;
  
function GetAllPassEntryTypeFields : string;
begin
  Result := GetDBColumnName('Exchqchk.dat', 'rec_pfix', '') + ',' + 
            GetDBColumnName('Exchqchk.dat', 'sub_type', '') + ',' + 
            GetDBColumnName('Exchqchk.dat', 'exchqchk_code1', '') + ',' + 
            GetDBColumnName('Exchqchk.dat', 'exchqchk_code2', '') + ',' + 
            GetDBColumnName('Exchqchk.dat', 'exchqchk_code3', '') + ',' + 
            GetDBColumnName('Exchqchk.dat', 'access', 'P*') + ',' + 
            GetDBColumnName('Exchqchk.dat', 'last_pno', 'P*') ;
end;
  
function GetAllPassListTypeFields : string;
begin
  Result := GetDBColumnName('Exchqchk.dat', 'rec_pfix', '') + ',' + 
            GetDBColumnName('Exchqchk.dat', 'sub_type', '') + ',' + 
            GetDBColumnName('Exchqchk.dat', 'exchqchk_code1', '') + ',' + 
            GetDBColumnName('Exchqchk.dat', 'exchqchk_code2', '') + ',' + 
            GetDBColumnName('Exchqchk.dat', 'exchqchk_code3', '') + ',' + 
            GetDBColumnName('Exchqchk.dat', 'pass_desc', 'L*') + ',' + 
            GetDBColumnName('Exchqchk.dat', 'pass_page', 'L*') + ',' + 
            GetDBColumnName('Exchqchk.dat', 'pass_lno', 'L*') ;
end;
  
function GetAllNotesTypeNAFields : string;
begin
  Result := GetDBColumnName('Exchqchk.dat', 'rec_pfix', '') + ',' + 
            GetDBColumnName('Exchqchk.dat', 'sub_type', '') + ',' + 
            GetDBColumnName('Exchqchk.dat', 'exchqchk_code1', '') + ',' + 
            GetDBColumnName('Exchqchk.dat', 'exchqchk_code2', '') + ',' + 
            GetDBColumnName('Exchqchk.dat', 'exchqchk_code3', '') + ',' + 
            GetDBColumnName('Exchqchk.dat', 'note_folio', 'N*') + ',' + 
            GetDBColumnName('Exchqchk.dat', 'n_type', 'N*') + ',' + 
            GetDBColumnName('Exchqchk.dat', 'spare1', 'N*') + ',' + 
            GetDBColumnName('Exchqchk.dat', 'line_no', 'N*') + ',' + 
            GetDBColumnName('Exchqchk.dat', 'note_line', 'N*') + ',' + 
            GetDBColumnName('Exchqchk.dat', 'note_user', 'N*') + ',' + 
            GetDBColumnName('Exchqchk.dat', 'tmp_imp_code', 'N*') + ',' + 
            GetDBColumnName('Exchqchk.dat', 'show_date', 'N*') + ',' + 
            GetDBColumnName('Exchqchk.dat', 'repeat_no', 'N*') + ',' + 
            GetDBColumnName('Exchqchk.dat', 'note_for', 'N*') ;
end;
  
function GetAllMatchPayTypeTPFields : string;
begin
  Result := GetDBColumnName('Exchqchk.dat', 'rec_pfix', '') + ',' + 
            GetDBColumnName('Exchqchk.dat', 'sub_type', '') + ',' + 
            GetDBColumnName('Exchqchk.dat', 'exchqchk_code1', '') + ',' + 
            GetDBColumnName('Exchqchk.dat', 'exchqchk_code2', '') + ',' + 
            GetDBColumnName('Exchqchk.dat', 'exchqchk_code3', '') + ',' + 
            GetDBColumnName('Exchqchk.dat', 'settled_val', 'T*') + ',' + 
            GetDBColumnName('Exchqchk.dat', 'own_c_val', 'T*') + ',' + 
            GetDBColumnName('Exchqchk.dat', 'm_currency', 'T*') + ',' + 
            GetDBColumnName('Exchqchk.dat', 'match_type', 'T*') + ',' + 
            GetDBColumnName('Exchqchk.dat', 'old_alt_ref', 'T*') + ',' + 
            GetDBColumnName('Exchqchk.dat', 'r_currency', 'T*') + ',' + 
            GetDBColumnName('Exchqchk.dat', 'rec_own_c_val', 'T*') + ',' + 
            GetDBColumnName('Exchqchk.dat', 'alt_ref', 'T*') ;
end;
  
function GetAllBillMatTypeFields : string;
begin
  Result := GetDBColumnName('Exchqchk.dat', 'rec_pfix', '') + ',' + 
            GetDBColumnName('Exchqchk.dat', 'sub_type', '') + ',' + 
            GetDBColumnName('Exchqchk.dat', 'exchqchk_code1', '') + ',' + 
            GetDBColumnName('Exchqchk.dat', 'exchqchk_code2', '') + ',' + 
            GetDBColumnName('Exchqchk.dat', 'exchqchk_code3', '') + ',' + 
            GetDBColumnName('Exchqchk.dat', 'qty_used', 'BM') + ',' + 
            GetDBColumnName('Exchqchk.dat', 'qty_cost', 'BM') + ',' + 
            GetDBColumnName('Exchqchk.dat', 'q_currency', 'BM') + ',' + 
            GetDBColumnName('Exchqchk.dat', 'full_stk_code', 'BM') + ',' + 
            GetDBColumnName('Exchqchk.dat', 'free_issue', 'BM') + ',' + 
            GetDBColumnName('Exchqchk.dat', 'qty_time', 'BM') ;
end;
  
function GetAllBacsCtypeFields : string;
begin
  Result := GetDBColumnName('Exchqchk.dat', 'rec_pfix', '') + ',' + 
            GetDBColumnName('Exchqchk.dat', 'sub_type', '') + ',' + 
            GetDBColumnName('Exchqchk.dat', 'exchqchk_code1', '') + ',' + 
            GetDBColumnName('Exchqchk.dat', 'exchqchk_code2', '') + ',' + 
            GetDBColumnName('Exchqchk.dat', 'exchqchk_code3', '') + ',' + 
            GetDBColumnName('Exchqchk.dat', 'bacs_tag_run_no', 'XC') + ',' + 
            GetDBColumnName('Exchqchk.dat', 'pay_type', 'XC') + ',' + 
            GetDBColumnName('Exchqchk.dat', 'bacs_bank_nom', 'XC') + ',' + 
            GetDBColumnName('Exchqchk.dat', 'pay_curr', 'XC') + ',' + 
            GetDBColumnName('Exchqchk.dat', 'inv_curr', 'XC') + ',' + 
            GetDBColumnName('Exchqchk.dat', 'cq_start', 'XC') + ',' + 
            GetDBColumnName('Exchqchk.dat', 'age_type', 'XC') + ',' + 
            GetDBColumnName('Exchqchk.dat', 'age_int', 'XC') + ',' + 
            GetDBColumnName('Exchqchk.dat', 'tag_status', 'XC') + ',' + 
            GetDBColumnName('Exchqchk.dat', 'total_tag0', 'XC') + ',' + 
            GetDBColumnName('Exchqchk.dat', 'total_tag1', 'XC') + ',' + 
            GetDBColumnName('Exchqchk.dat', 'total_tag2', 'XC') + ',' + 
            GetDBColumnName('Exchqchk.dat', 'total_tag3', 'XC') + ',' + 
            GetDBColumnName('Exchqchk.dat', 'total_tag4', 'XC') + ',' + 
            GetDBColumnName('Exchqchk.dat', 'tag_as_date', 'XC') + ',' + 
            GetDBColumnName('Exchqchk.dat', 'tag_count', 'XC') + ',' + 
            GetDBColumnName('Exchqchk.dat', 'tag_cc_dep1', 'XC') + ',' + 
            GetDBColumnName('Exchqchk.dat', 'tag_cc_dep2', 'XC') + ',' + 
            GetDBColumnName('Exchqchk.dat', 'tag_run_date', 'XC') + ',' + 
            GetDBColumnName('Exchqchk.dat', 'tag_run_yr', 'XC') + ',' + 
            GetDBColumnName('Exchqchk.dat', 'tag_run_pr', 'XC') + ',' + 
            GetDBColumnName('Exchqchk.dat', 'sales_mode', 'XC') + ',' + 
            GetDBColumnName('Exchqchk.dat', 'last_inv', 'XC') + ',' + 
            GetDBColumnName('Exchqchk.dat', 'srcpi_ref', 'XC') + ',' + 
            GetDBColumnName('Exchqchk.dat', 'last_tag_run_no', 'XC') + ',' + 
            GetDBColumnName('Exchqchk.dat', 'tag_ctrl_code', 'XC') + ',' + 
            GetDBColumnName('Exchqchk.dat', 'use_ac_cc', 'XC') + ',' + 
            GetDBColumnName('Exchqchk.dat', 'set_c_qatp', 'XC') + ',' + 
            GetDBColumnName('Exchqchk.dat', 'inc_s_disc', 'XC') + ',' + 
            GetDBColumnName('Exchqchk.dat', 'sd_days_over', 'XC') + ',' + 
            GetDBColumnName('Exchqchk.dat', 'show_log', 'XC') + ',' + 
            GetDBColumnName('Exchqchk.dat', 'use_os_ndx', 'XC') + ',' + 
            GetDBColumnName('Exchqchk.dat', 'bacsc_liu_count', 'XC') ;
end;
  
function GetAllBankCtypeFields : string;
begin
  Result := GetDBColumnName('Exchqchk.dat', 'rec_pfix', '') + ',' + 
            GetDBColumnName('Exchqchk.dat', 'sub_type', '') + ',' + 
            GetDBColumnName('Exchqchk.dat', 'exchqchk_code1', '') + ',' + 
            GetDBColumnName('Exchqchk.dat', 'exchqchk_code2', '') + ',' + 
            GetDBColumnName('Exchqchk.dat', 'exchqchk_code3', '') + ',' + 
            GetDBColumnName('Exchqchk.dat', 'tag_run_no', 'MT') + ',' + 
            GetDBColumnName('Exchqchk.dat', 'bank_nom', 'MT') + ',' + 
            GetDBColumnName('Exchqchk.dat', 'bank_cr', 'MT') + ',' + 
            GetDBColumnName('Exchqchk.dat', 'recon_opo', 'MT') + ',' + 
            GetDBColumnName('Exchqchk.dat', 'entry_tot_dr', 'MT') + ',' + 
            GetDBColumnName('Exchqchk.dat', 'entry_tot_cr', 'MT') + ',' + 
            GetDBColumnName('Exchqchk.dat', 'entry_date', 'MT') + ',' + 
            GetDBColumnName('Exchqchk.dat', 'nom_ent_typ', 'MT') + ',' + 
            GetDBColumnName('Exchqchk.dat', 'all_match_ok', 'MT') + ',' + 
            GetDBColumnName('Exchqchk.dat', 'match_count', 'MT') + ',' + 
            GetDBColumnName('Exchqchk.dat', 'match_o_bal', 'MT') + ',' + 
            GetDBColumnName('Exchqchk.dat', 'man_tot_dr', 'MT') + ',' + 
            GetDBColumnName('Exchqchk.dat', 'man_tot_cr', 'MT') + ',' + 
            GetDBColumnName('Exchqchk.dat', 'man_run_no', 'MT') + ',' + 
            GetDBColumnName('Exchqchk.dat', 'man_change', 'MT') + ',' + 
            GetDBColumnName('Exchqchk.dat', 'man_count', 'MT') ;
end;
  
function GetAllAllocFileTypeFields : string;
begin
  Result := GetDBColumnName('Exchqchk.dat', 'rec_pfix', '') + ',' +
            GetDBColumnName('Exchqchk.dat', 'sub_type', '') + ',' + 
            GetDBColumnName('Exchqchk.dat', 'exchqchk_code1', '') + ',' + 
            GetDBColumnName('Exchqchk.dat', 'exchqchk_code2', '') + ',' + 
            GetDBColumnName('Exchqchk.dat', 'exchqchk_code3', '') + ',' + 
            GetDBColumnName('Exchqchk.dat', 'alloc_sf', 'A*') ;
end;
  
function GetAllCostCtrTypeFields : string;
begin
  Result := GetDBColumnName('Exchqchk.dat', 'rec_pfix', '') + ',' + 
            GetDBColumnName('Exchqchk.dat', 'sub_type', '') + ',' + 
            GetDBColumnName('Exchqchk.dat', 'exchqchk_code1', '') + ',' + 
            GetDBColumnName('Exchqchk.dat', 'exchqchk_code2', '') + ',' + 
            GetDBColumnName('Exchqchk.dat', 'exchqchk_code3', '') + ',' + 
            GetDBColumnName('Exchqchk.dat', 'cc_desc', 'C*') + ',' + 
            GetDBColumnName('Exchqchk.dat', 'cc_tag', 'C*') + ',' + 
            GetDBColumnName('Exchqchk.dat', 'last_access', 'C*') + ',' + 
            GetDBColumnName('Exchqchk.dat', 'n_line_count', 'C*') + ',' + 
            GetDBColumnName('Exchqchk.dat', 'hide_ac', 'C*') ;
end;
  
function GetAllMoveNomTypeFields : string;
begin
  Result := GetDBColumnName('Exchqchk.dat', 'rec_pfix', '') + ',' + 
            GetDBColumnName('Exchqchk.dat', 'sub_type', '') + ',' + 
            GetDBColumnName('Exchqchk.dat', 'exchqchk_code1', '') + ',' + 
            GetDBColumnName('Exchqchk.dat', 'exchqchk_code2', '') + ',' + 
            GetDBColumnName('Exchqchk.dat', 'exchqchk_code3', '') + ',' + 
            GetDBColumnName('Exchqchk.dat', 'mn_move_code', 'MN') + ',' + 
            GetDBColumnName('Exchqchk.dat', 'mn_move_from', 'MN') + ',' + 
            GetDBColumnName('Exchqchk.dat', 'mn_move_to', 'MN') + ',' + 
            GetDBColumnName('Exchqchk.dat', 'mn_move_type', 'MN') ;
end;
  
function GetAllMoveStkTypeFields : string;
begin
  Result := GetDBColumnName('Exchqchk.dat', 'rec_pfix', '') + ',' + 
            GetDBColumnName('Exchqchk.dat', 'sub_type', '') + ',' + 
            GetDBColumnName('Exchqchk.dat', 'exchqchk_code1', '') + ',' + 
            GetDBColumnName('Exchqchk.dat', 'exchqchk_code2', '') + ',' + 
            GetDBColumnName('Exchqchk.dat', 'exchqchk_code3', '') + ',' + 
            GetDBColumnName('Exchqchk.dat', 'move_code', 'MS') + ',' + 
            GetDBColumnName('Exchqchk.dat', 'm_from_code', 'MS') + ',' + 
            GetDBColumnName('Exchqchk.dat', 'm_to_code', 'MS') + ',' + 
            GetDBColumnName('Exchqchk.dat', 'new_stk_code', 'MS') ;
end;
  
function GetAllVSecureTypeFields : string;
begin
  Result := GetDBColumnName('Exchqchk.dat', 'rec_pfix', '') + ',' + 
            GetDBColumnName('Exchqchk.dat', 'sub_type', '') + ',' + 
            GetDBColumnName('Exchqchk.dat', 'exchqchk_code1', '') + ',' + 
            GetDBColumnName('Exchqchk.dat', 'exchqchk_code2', '') + ',' + 
            GetDBColumnName('Exchqchk.dat', 'exchqchk_code3', '') + ',' + 
            GetDBColumnName('Exchqchk.dat', 'stuff', 'LV') ;
end;
  
function GetAllBacsUtypeFields : string;
begin
  Result := GetDBColumnName('Exchqchk.dat', 'rec_pfix', '') + ',' + 
            GetDBColumnName('Exchqchk.dat', 'sub_type', '') + ',' + 
            GetDBColumnName('Exchqchk.dat', 'exchqchk_code1', '') + ',' + 
            GetDBColumnName('Exchqchk.dat', 'exchqchk_code2', '') + ',' + 
            GetDBColumnName('Exchqchk.dat', 'exchqchk_code3', '') + ',' + 
            GetDBColumnName('Exchqchk.dat', 'opo_name', 'XU') + ',' + 
            GetDBColumnName('Exchqchk.dat', 'start_date', 'XU') + ',' + 
            GetDBColumnName('Exchqchk.dat', 'start_time', 'XU') + ',' + 
            GetDBColumnName('Exchqchk.dat', 'win_log_name', 'XU') + ',' + 
            GetDBColumnName('Exchqchk.dat', 'win_cpu_name', 'XU') + ',' + 
            GetDBColumnName('Exchqchk.dat', 'bacsu_liu_count', 'XU') ;
end;
  
function GetAllMoveCtrlTypeFields : string;
begin
  Result := GetDBColumnName('Exchqchk.dat', 'rec_pfix', '') + ',' + 
            GetDBColumnName('Exchqchk.dat', 'sub_type', '') + ',' + 
            GetDBColumnName('Exchqchk.dat', 'exchqchk_code1', '') + ',' + 
            GetDBColumnName('Exchqchk.dat', 'exchqchk_code2', '') + ',' + 
            GetDBColumnName('Exchqchk.dat', 'exchqchk_code3', '') + ',' + 
            GetDBColumnName('Exchqchk.dat', 's_code_old', 'LM') + ',' + 
            GetDBColumnName('Exchqchk.dat', 's_code_new', 'LM') + ',' + 
            GetDBColumnName('Exchqchk.dat', 'move_stage', 'LM') + ',' + 
            GetDBColumnName('Exchqchk.dat', 'old_n_code', 'LM') + ',' + 
            GetDBColumnName('Exchqchk.dat', 'new_n_code', 'LM') + ',' + 
            GetDBColumnName('Exchqchk.dat', 'n_typ_old', 'LM') + ',' + 
            GetDBColumnName('Exchqchk.dat', 'n_typ_new', 'LM') + ',' + 
            GetDBColumnName('Exchqchk.dat', 'move_key1', 'LM') + ',' + 
            GetDBColumnName('Exchqchk.dat', 'move_key2', 'LM') + ',' + 
            GetDBColumnName('Exchqchk.dat', 'was_mode', 'LM') + ',' + 
            GetDBColumnName('Exchqchk.dat', 's_grp_new', 'LM') + ',' + 
            GetDBColumnName('Exchqchk.dat', 's_user', 'LM') + ',' + 
            GetDBColumnName('Exchqchk.dat', 'fin_stage', 'LM') + ',' + 
            GetDBColumnName('Exchqchk.dat', 'prog_counter', 'LM') + ',' + 
            GetDBColumnName('Exchqchk.dat', 'mis_cust', 'LM') + ',' + 
            GetDBColumnName('Exchqchk.dat', 'mlist_rec_addr', 'LM') ;
end;
  
function GetAllExchqnumFields : string;
begin
  Result := GetDBColumnName('Exchqnum.dat', 'f_count_type', '') + ',' + 
            GetDBColumnName('Exchqnum.dat', 'f_next_count_size', '') + ',' + 
            GetDBColumnName('Exchqnum.dat', 'f_next_count', '') + ',' + 
            GetDBColumnName('Exchqnum.dat', 'f_last_value', '') ;
end;
  
function GetAllSysRecFields : string;
begin
  Result := GetDBColumnName('ExchqSS.dat', 'id_code', '') + ',' + 
            GetDBColumnName('ExchqSS.dat', 'opt', 'SYS') + ',' + 
            GetDBColumnName('ExchqSS.dat', 'o_mon_wk1', 'SYS') + ',' + 
            GetDBColumnName('ExchqSS.dat', 'prin_yr', 'SYS') + ',' + 
            GetDBColumnName('ExchqSS.dat', 'filt_sno_bin_loc', 'SYS') + ',' + 
            GetDBColumnName('ExchqSS.dat', 'keep_bin_hist', 'SYS') + ',' + 
            GetDBColumnName('ExchqSS.dat', 'use_bk_theme', 'SYS') + ',' + 
            GetDBColumnName('ExchqSS.dat', 'user_name', 'SYS') + ',' + 
            GetDBColumnName('ExchqSS.dat', 'audit_yr', 'SYS') + ',' + 
            GetDBColumnName('ExchqSS.dat', 'audit_pr', 'SYS') + ',' + 
            GetDBColumnName('ExchqSS.dat', 'spare6', 'SYS') + ',' + 
            GetDBColumnName('ExchqSS.dat', 'man_rocp', 'SYS') + ',' + 
            GetDBColumnName('ExchqSS.dat', 'vat_curr', 'SYS') + ',' + 
            GetDBColumnName('ExchqSS.dat', 'no_cos_dec', 'SYS') + ',' + 
            GetDBColumnName('ExchqSS.dat', 'curr_base', 'SYS') + ',' + 
            GetDBColumnName('ExchqSS.dat', 'mute_beep', 'SYS') + ',' + 
            GetDBColumnName('ExchqSS.dat', 'show_stk_gp', 'SYS') + ',' + 
            GetDBColumnName('ExchqSS.dat', 'auto_val_stk', 'SYS') + ',' + 
            GetDBColumnName('ExchqSS.dat', 'del_pick_only', 'SYS') + ',' + 
            GetDBColumnName('ExchqSS.dat', 'use_m_loc', 'SYS') + ',' + 
            GetDBColumnName('ExchqSS.dat', 'edit_sin_ser', 'SYS') + ',' + 
            GetDBColumnName('ExchqSS.dat', 'warn_y_ref', 'SYS') + ',' + 
            GetDBColumnName('ExchqSS.dat', 'use_loc_del', 'SYS') + ',' + 
            GetDBColumnName('ExchqSS.dat', 'post_cc_nom', 'SYS') + ',' + 
            GetDBColumnName('ExchqSS.dat', 'al_tol_val', 'SYS') + ',' + 
            GetDBColumnName('ExchqSS.dat', 'al_tol_mode', 'SYS') + ',' + 
            GetDBColumnName('ExchqSS.dat', 'debt_l_mode', 'SYS') + ',' + 
            GetDBColumnName('ExchqSS.dat', 'auto_gen_var', 'SYS') + ',' + 
            GetDBColumnName('ExchqSS.dat', 'auto_gen_disc', 'SYS') + ',' + 
            GetDBColumnName('ExchqSS.dat', 'use_module_sec', 'SYS') + ',' + 
            GetDBColumnName('ExchqSS.dat', 'protect_post', 'SYS') + ',' + 
            GetDBColumnName('ExchqSS.dat', 'use_pick4_all', 'SYS') + ',' + 
            GetDBColumnName('ExchqSS.dat', 'big_stk_tree', 'SYS') + ',' + 
            GetDBColumnName('ExchqSS.dat', 'big_job_tree', 'SYS') + ',' + 
            GetDBColumnName('ExchqSS.dat', 'show_qty_stree', 'SYS') + ',' + 
            GetDBColumnName('ExchqSS.dat', 'protect_y_ref', 'SYS') + ',' + 
            GetDBColumnName('ExchqSS.dat', 'purch_ui_date', 'SYS') + ',' +
            GetDBColumnName('ExchqSS.dat', 'use_uplift_nc', 'SYS') + ',' + 
            GetDBColumnName('ExchqSS.dat', 'use_wiss4_all', 'SYS') + ',' + 
            GetDBColumnName('ExchqSS.dat', 'use_stdwop', 'SYS') + ',' + 
            GetDBColumnName('ExchqSS.dat', 'use_sales_anal', 'SYS') + ',' + 
            GetDBColumnName('ExchqSS.dat', 'post_ccd_combo', 'SYS') + ',' + 
            GetDBColumnName('ExchqSS.dat', 'use_class_toolb', 'SYS') + ',' + 
            GetDBColumnName('ExchqSS.dat', 'wop_stk_cop_mode', 'SYS') + ',' + 
            GetDBColumnName('ExchqSS.dat', 'usr_cntry_code', 'SYS') + ',' + 
            GetDBColumnName('ExchqSS.dat', 'no_net_dec', 'SYS') + ',' + 
            GetDBColumnName('ExchqSS.dat', 'deb_trig', 'SYS') + ',' + 
            GetDBColumnName('ExchqSS.dat', 'bk_theme_no', 'SYS') + ',' + 
            GetDBColumnName('ExchqSS.dat', 'use_gl_class', 'SYS') + ',' + 
            GetDBColumnName('ExchqSS.dat', 'spare4', 'SYS') + ',' + 
            GetDBColumnName('ExchqSS.dat', 'no_inv_lines', 'SYS') + ',' + 
            GetDBColumnName('ExchqSS.dat', 'wks_o_due', 'SYS') + ',' + 
            GetDBColumnName('ExchqSS.dat', 'c_pr', 'SYS') + ',' + 
            GetDBColumnName('ExchqSS.dat', 'c_yr', 'SYS') + ',' + 
            GetDBColumnName('ExchqSS.dat', 'o_audit_date', 'SYS') + ',' + 
            GetDBColumnName('ExchqSS.dat', 'trade_term', 'SYS') + ',' + 
            GetDBColumnName('ExchqSS.dat', 'sta_sep_cr', 'SYS') + ',' + 
            GetDBColumnName('ExchqSS.dat', 'sta_age_mthd', 'SYS') + ',' + 
            GetDBColumnName('ExchqSS.dat', 'sta_ui_date', 'SYS') + ',' + 
            GetDBColumnName('ExchqSS.dat', 'sep_run_post', 'SYS') + ',' + 
            GetDBColumnName('ExchqSS.dat', 'qu_alloc_flg', 'SYS') + ',' + 
            GetDBColumnName('ExchqSS.dat', 'dead_bom', 'SYS') + ',' + 
            GetDBColumnName('ExchqSS.dat', 'auth_mode', 'SYS') + ',' + 
            GetDBColumnName('ExchqSS.dat', 'intra_stat', 'SYS') + ',' + 
            GetDBColumnName('ExchqSS.dat', 'anal_stk_desc', 'SYS') + ',' + 
            GetDBColumnName('ExchqSS.dat', 'auto_stk_val', 'SYS') + ',' + 
            GetDBColumnName('ExchqSS.dat', 'auto_bill_up', 'SYS') + ',' + 
            GetDBColumnName('ExchqSS.dat', 'auto_cq_no', 'SYS') + ',' + 
            GetDBColumnName('ExchqSS.dat', 'inc_not_due', 'SYS') + ',' + 
            GetDBColumnName('ExchqSS.dat', 'use_batch_tot', 'SYS') + ',' + 
            GetDBColumnName('ExchqSS.dat', 'use_stock', 'SYS') + ',' + 
            GetDBColumnName('ExchqSS.dat', 'auto_notes', 'SYS') + ',' + 
            GetDBColumnName('ExchqSS.dat', 'hide_menu_opt', 'SYS') + ',' + 
            GetDBColumnName('ExchqSS.dat', 'use_cc_dep', 'SYS') + ',' + 
            GetDBColumnName('ExchqSS.dat', 'no_hold_disc', 'SYS') + ',' + 
            GetDBColumnName('ExchqSS.dat', 'auto_pr_calc', 'SYS') + ',' + 
            GetDBColumnName('ExchqSS.dat', 'stop_bad_dr', 'SYS') + ',' + 
            GetDBColumnName('ExchqSS.dat', 'use_pay_in', 'SYS') + ',' + 
            GetDBColumnName('ExchqSS.dat', 'use_passwords', 'SYS') + ',' + 
            GetDBColumnName('ExchqSS.dat', 'print_reciept', 'SYS') + ',' + 
            GetDBColumnName('ExchqSS.dat', 'extern_cust', 'SYS') + ',' + 
            GetDBColumnName('ExchqSS.dat', 'no_qty_dec', 'SYS') + ',' + 
            GetDBColumnName('ExchqSS.dat', 'extern_sin', 'SYS') + ',' + 
            GetDBColumnName('ExchqSS.dat', 'prev_pr_off', 'SYS') + ',' + 
            GetDBColumnName('ExchqSS.dat', 'def_pc_disc', 'SYS') + ',' +
            GetDBColumnName('ExchqSS.dat', 'trad_code_num', 'SYS') + ',' + 
            GetDBColumnName('ExchqSS.dat', 'up_bal_on_post', 'SYS') + ',' + 
            GetDBColumnName('ExchqSS.dat', 'show_inv_disc', 'SYS') + ',' + 
            GetDBColumnName('ExchqSS.dat', 'sep_discounts', 'SYS') + ',' + 
            GetDBColumnName('ExchqSS.dat', 'use_credit_chk', 'SYS') + ',' + 
            GetDBColumnName('ExchqSS.dat', 'use_cr_limit_chk', 'SYS') + ',' + 
            GetDBColumnName('ExchqSS.dat', 'auto_clear_pay', 'SYS') + ',' + 
            GetDBColumnName('ExchqSS.dat', 'total_conv', 'SYS') + ',' + 
            GetDBColumnName('ExchqSS.dat', 'disp_pr_as_months', 'SYS') + ',' + 
            GetDBColumnName('ExchqSS.dat', 'nom_ctrl_in_vat', 'SYS') + ',' + 
            GetDBColumnName('ExchqSS.dat', 'nom_ctrl_out_vat', 'SYS') + ',' + 
            GetDBColumnName('ExchqSS.dat', 'nom_ctrl_debtors', 'SYS') + ',' + 
            GetDBColumnName('ExchqSS.dat', 'nom_ctrl_creditors', 'SYS') + ',' + 
            GetDBColumnName('ExchqSS.dat', 'nom_ctrl_discount_given', 'SYS') + ',' + 
            GetDBColumnName('ExchqSS.dat', 'nom_ctrl_discount_taken', 'SYS') + ',' + 
            GetDBColumnName('ExchqSS.dat', 'nom_ctrl_ldisc_given', 'SYS') + ',' + 
            GetDBColumnName('ExchqSS.dat', 'nom_ctrl_ldisc_taken', 'SYS') + ',' + 
            GetDBColumnName('ExchqSS.dat', 'nom_ctrl_profit_bf', 'SYS') + ',' + 
            GetDBColumnName('ExchqSS.dat', 'nom_ctrl_curr_var', 'SYS') + ',' + 
            GetDBColumnName('ExchqSS.dat', 'nom_ctrl_unrcurr_var', 'SYS') + ',' + 
            GetDBColumnName('ExchqSS.dat', 'nom_ctrl_pl_start', 'SYS') + ',' + 
            GetDBColumnName('ExchqSS.dat', 'nom_ctrl_pl_end', 'SYS') + ',' + 
            GetDBColumnName('ExchqSS.dat', 'nom_ctrl_freight_nc', 'SYS') + ',' + 
            GetDBColumnName('ExchqSS.dat', 'nom_ctrl_sales_comm', 'SYS') + ',' + 
            GetDBColumnName('ExchqSS.dat', 'nom_ctrl_purch_comm', 'SYS') + ',' + 
            GetDBColumnName('ExchqSS.dat', 'nom_ctrl_ret_surcharge', 'SYS') + ',' + 
            GetDBColumnName('ExchqSS.dat', 'nom_ctrl_spare8', 'SYS') + ',' + 
            GetDBColumnName('ExchqSS.dat', 'nom_ctrl_spare9', 'SYS') + ',' + 
            GetDBColumnName('ExchqSS.dat', 'nom_ctrl_spare10', 'SYS') + ',' + 
            GetDBColumnName('ExchqSS.dat', 'nom_ctrl_spare11', 'SYS') + ',' + 
            GetDBColumnName('ExchqSS.dat', 'nom_ctrl_spare12', 'SYS') + ',' + 
            GetDBColumnName('ExchqSS.dat', 'nom_ctrl_spare13', 'SYS') + ',' + 
            GetDBColumnName('ExchqSS.dat', 'nom_ctrl_spare14', 'SYS') + ',' + 
            GetDBColumnName('ExchqSS.dat', 'detail_addr1', 'SYS') + ',' + 
            GetDBColumnName('ExchqSS.dat', 'detail_addr2', 'SYS') + ',' + 
            GetDBColumnName('ExchqSS.dat', 'detail_addr3', 'SYS') + ',' + 
            GetDBColumnName('ExchqSS.dat', 'detail_addr4', 'SYS') + ',' + 
            GetDBColumnName('ExchqSS.dat', 'detail_addr5', 'SYS') + ',' + 
            GetDBColumnName('ExchqSS.dat', 'direct_cust', 'SYS') + ',' + 
            GetDBColumnName('ExchqSS.dat', 'direct_supp', 'SYS') + ',' + 
            GetDBColumnName('ExchqSS.dat', 'termsof_trade1', 'SYS') + ',' + 
            GetDBColumnName('ExchqSS.dat', 'termsof_trade2', 'SYS') + ',' + 
            GetDBColumnName('ExchqSS.dat', 'nom_pay_from', 'SYS') + ',' + 
            GetDBColumnName('ExchqSS.dat', 'nom_pay_too', 'SYS') + ',' + 
            GetDBColumnName('ExchqSS.dat', 'settle_disc', 'SYS') + ',' + 
            GetDBColumnName('ExchqSS.dat', 'settle_days', 'SYS') + ',' + 
            GetDBColumnName('ExchqSS.dat', 'need_bm_up', 'SYS') + ',' + 
            GetDBColumnName('ExchqSS.dat', 'ignore_bdpw', 'SYS') + ',' +
            GetDBColumnName('ExchqSS.dat', 'inp_pack', 'SYS') + ',' + 
            GetDBColumnName('ExchqSS.dat', 'spare32', 'SYS') + ',' + 
            GetDBColumnName('ExchqSS.dat', 'vat_code', 'SYS') + ',' + 
            GetDBColumnName('ExchqSS.dat', 'pay_terms', 'SYS') + ',' + 
            GetDBColumnName('ExchqSS.dat', 'o_trig_date', 'SYS') + ',' + 
            GetDBColumnName('ExchqSS.dat', 'sta_age_int', 'SYS') + ',' + 
            GetDBColumnName('ExchqSS.dat', 'quo_own_date', 'SYS') + ',' + 
            GetDBColumnName('ExchqSS.dat', 'free_ex_all', 'SYS') + ',' + 
            GetDBColumnName('ExchqSS.dat', 'dir_own_count', 'SYS') + ',' + 
            GetDBColumnName('ExchqSS.dat', 'sta_show_os', 'SYS') + ',' + 
            GetDBColumnName('ExchqSS.dat', 'live_cred_s', 'SYS') + ',' + 
            GetDBColumnName('ExchqSS.dat', 'batch_ppy', 'SYS') + ',' + 
            GetDBColumnName('ExchqSS.dat', 'warn_jc', 'SYS') + ',' + 
            GetDBColumnName('ExchqSS.dat', 'tx_late_cr', 'SYS') + ',' + 
            GetDBColumnName('ExchqSS.dat', 'consv_mem', 'SYS') + ',' + 
            GetDBColumnName('ExchqSS.dat', 'def_bank_nom', 'SYS') + ',' + 
            GetDBColumnName('ExchqSS.dat', 'use_def_bank', 'SYS') + ',' + 
            GetDBColumnName('ExchqSS.dat', 'hide_ex_logo', 'SYS') + ',' + 
            GetDBColumnName('ExchqSS.dat', 'amm_thread', 'SYS') + ',' + 
            GetDBColumnName('ExchqSS.dat', 'amm_preview1', 'SYS') + ',' + 
            GetDBColumnName('ExchqSS.dat', 'amm_preview2', 'SYS') + ',' + 
            GetDBColumnName('ExchqSS.dat', 'ent_u_log_count', 'SYS') + ',' + 
            GetDBColumnName('ExchqSS.dat', 'def_src_bank_nom', 'SYS') + ',' + 
            GetDBColumnName('ExchqSS.dat', 'sdn_own_date', 'SYS') + ',' + 
            GetDBColumnName('ExchqSS.dat', 'exisn', 'SYS') + ',' + 
            GetDBColumnName('ExchqSS.dat', 'ex_demo_ver', 'SYS') + ',' + 
            GetDBColumnName('ExchqSS.dat', 'dupli_v_sec', 'SYS') + ',' + 
            GetDBColumnName('ExchqSS.dat', 'last_daily', 'SYS') + ',' + 
            GetDBColumnName('ExchqSS.dat', 'user_sort', 'SYS') + ',' + 
            GetDBColumnName('ExchqSS.dat', 'user_acc', 'SYS') + ',' + 
            GetDBColumnName('ExchqSS.dat', 'user_ref', 'SYS') + ',' + 
            GetDBColumnName('ExchqSS.dat', 'spare_bits', 'SYS') + ',' + 
            GetDBColumnName('ExchqSS.dat', 'grace_period', 'SYS') + ',' + 
            GetDBColumnName('ExchqSS.dat', 'mon_wk1', 'SYS') + ',' + 
            GetDBColumnName('ExchqSS.dat', 'audit_date', 'SYS') + ',' + 
            GetDBColumnName('ExchqSS.dat', 'trig_date', 'SYS') + ',' + 
            GetDBColumnName('ExchqSS.dat', 'ex_usr_sec', 'SYS') + ',' + 
            GetDBColumnName('ExchqSS.dat', 'usr_log_count', 'SYS') + ',' + 
            GetDBColumnName('ExchqSS.dat', 'bin_mask', 'SYS') + ',' + 
            GetDBColumnName('ExchqSS.dat', 'spare5a', 'SYS') + ',' + 
            GetDBColumnName('ExchqSS.dat', 'spare6a', 'SYS') + ',' + 
            GetDBColumnName('ExchqSS.dat', 'user_bank', 'SYS') + ',' + 
            GetDBColumnName('ExchqSS.dat', 'ex_sec', 'SYS') + ',' + 
            GetDBColumnName('ExchqSS.dat', 'last_exp_folio', 'SYS') + ',' + 
            GetDBColumnName('ExchqSS.dat', 'detail_tel', 'SYS') + ',' + 
            GetDBColumnName('ExchqSS.dat', 'detail_fax', 'SYS') + ',' + 
            GetDBColumnName('ExchqSS.dat', 'user_vat_reg', 'SYS') ;
end;
  
function GetAllVATRecFields : string;
begin
  Result := GetDBColumnName('ExchqSS.dat', 'id_code', '') + ',' +
            GetDBColumnName('ExchqSS.dat', 'VATStandardCode', 'VAT') + ',' + 
            GetDBColumnName('ExchqSS.dat', 'VATStandardDesc', 'VAT') + ',' + 
            GetDBColumnName('ExchqSS.dat', 'VATStandardRate', 'VAT') + ',' + 
            GetDBColumnName('ExchqSS.dat', 'VATStandardSpare', 'VAT') + ',' + 
            GetDBColumnName('ExchqSS.dat', 'VATStandardInclude', 'VAT') + ',' + 
            GetDBColumnName('ExchqSS.dat', 'VATStandardSpare2', 'VAT') + ',' + 
            GetDBColumnName('ExchqSS.dat', 'VATExemptCode', 'VAT') + ',' + 
            GetDBColumnName('ExchqSS.dat', 'VATExemptDesc', 'VAT') + ',' + 
            GetDBColumnName('ExchqSS.dat', 'VATExemptRate', 'VAT') + ',' + 
            GetDBColumnName('ExchqSS.dat', 'VATExemptSpare', 'VAT') + ',' + 
            GetDBColumnName('ExchqSS.dat', 'VATExemptInclude', 'VAT') + ',' + 
            GetDBColumnName('ExchqSS.dat', 'VATExemptSpare2', 'VAT') + ',' + 
            GetDBColumnName('ExchqSS.dat', 'VATZeroCode', 'VAT') + ',' + 
            GetDBColumnName('ExchqSS.dat', 'VATZeroDesc', 'VAT') + ',' + 
            GetDBColumnName('ExchqSS.dat', 'VATZeroRate', 'VAT') + ',' + 
            GetDBColumnName('ExchqSS.dat', 'VATZeroSpare', 'VAT') + ',' + 
            GetDBColumnName('ExchqSS.dat', 'VATZeroInclude', 'VAT') + ',' + 
            GetDBColumnName('ExchqSS.dat', 'VATZeroSpare2', 'VAT') + ',' + 
            GetDBColumnName('ExchqSS.dat', 'VATRate1Code', 'VAT') + ',' + 
            GetDBColumnName('ExchqSS.dat', 'VATRate1Desc', 'VAT') + ',' + 
            GetDBColumnName('ExchqSS.dat', 'VATRate1Rate', 'VAT') + ',' + 
            GetDBColumnName('ExchqSS.dat', 'VATRate1Spare', 'VAT') + ',' + 
            GetDBColumnName('ExchqSS.dat', 'VATRate1Include', 'VAT') + ',' + 
            GetDBColumnName('ExchqSS.dat', 'VATRate1Spare2', 'VAT') + ',' + 
            GetDBColumnName('ExchqSS.dat', 'VATRate2Code', 'VAT') + ',' + 
            GetDBColumnName('ExchqSS.dat', 'VATRate2Desc', 'VAT') + ',' + 
            GetDBColumnName('ExchqSS.dat', 'VATRate2Rate', 'VAT') + ',' + 
            GetDBColumnName('ExchqSS.dat', 'VATRate2Spare', 'VAT') + ',' + 
            GetDBColumnName('ExchqSS.dat', 'VATRate2Include', 'VAT') + ',' + 
            GetDBColumnName('ExchqSS.dat', 'VATRate2Spare2', 'VAT') + ',' + 
            GetDBColumnName('ExchqSS.dat', 'VATRate3Code', 'VAT') + ',' + 
            GetDBColumnName('ExchqSS.dat', 'VATRate3Desc', 'VAT') + ',' + 
            GetDBColumnName('ExchqSS.dat', 'VATRate3Rate', 'VAT') + ',' + 
            GetDBColumnName('ExchqSS.dat', 'VATRate3Spare', 'VAT') + ',' + 
            GetDBColumnName('ExchqSS.dat', 'VATRate3Include', 'VAT') + ',' + 
            GetDBColumnName('ExchqSS.dat', 'VATRate3Spare2', 'VAT') + ',' + 
            GetDBColumnName('ExchqSS.dat', 'VATRate4Code', 'VAT') + ',' + 
            GetDBColumnName('ExchqSS.dat', 'VATRate4Desc', 'VAT') + ',' + 
            GetDBColumnName('ExchqSS.dat', 'VATRate4Rate', 'VAT') + ',' + 
            GetDBColumnName('ExchqSS.dat', 'VATRate4Spare', 'VAT') + ',' + 
            GetDBColumnName('ExchqSS.dat', 'VATRate4Include', 'VAT') + ',' + 
            GetDBColumnName('ExchqSS.dat', 'VATRate4Spare2', 'VAT') + ',' + 
            GetDBColumnName('ExchqSS.dat', 'VATRate5Code', 'VAT') + ',' + 
            GetDBColumnName('ExchqSS.dat', 'VATRate5Desc', 'VAT') + ',' +
            GetDBColumnName('ExchqSS.dat', 'VATRate5Rate', 'VAT') + ',' + 
            GetDBColumnName('ExchqSS.dat', 'VATRate5Spare', 'VAT') + ',' + 
            GetDBColumnName('ExchqSS.dat', 'VATRate5Include', 'VAT') + ',' + 
            GetDBColumnName('ExchqSS.dat', 'VATRate5Spare2', 'VAT') + ',' +
            GetDBColumnName('ExchqSS.dat', 'VATRate6Code', 'VAT') + ',' + 
            GetDBColumnName('ExchqSS.dat', 'VATRate6Desc', 'VAT') + ',' + 
            GetDBColumnName('ExchqSS.dat', 'VATRate6Rate', 'VAT') + ',' + 
            GetDBColumnName('ExchqSS.dat', 'VATRate6Spare', 'VAT') + ',' + 
            GetDBColumnName('ExchqSS.dat', 'VATRate6Include', 'VAT') + ',' + 
            GetDBColumnName('ExchqSS.dat', 'VATRate6Spare2', 'VAT') + ',' + 
            GetDBColumnName('ExchqSS.dat', 'VATRate7Code', 'VAT') + ',' + 
            GetDBColumnName('ExchqSS.dat', 'VATRate7Desc', 'VAT') + ',' + 
            GetDBColumnName('ExchqSS.dat', 'VATRate7Rate', 'VAT') + ',' + 
            GetDBColumnName('ExchqSS.dat', 'VATRate7Spare', 'VAT') + ',' + 
            GetDBColumnName('ExchqSS.dat', 'VATRate7Include', 'VAT') + ',' + 
            GetDBColumnName('ExchqSS.dat', 'VATRate7Spare2', 'VAT') + ',' + 
            GetDBColumnName('ExchqSS.dat', 'VATRate8Code', 'VAT') + ',' + 
            GetDBColumnName('ExchqSS.dat', 'VATRate8Desc', 'VAT') + ',' + 
            GetDBColumnName('ExchqSS.dat', 'VATRate8Rate', 'VAT') + ',' + 
            GetDBColumnName('ExchqSS.dat', 'VATRate8Spare', 'VAT') + ',' + 
            GetDBColumnName('ExchqSS.dat', 'VATRate8Include', 'VAT') + ',' + 
            GetDBColumnName('ExchqSS.dat', 'VATRate8Spare2', 'VAT') + ',' + 
            GetDBColumnName('ExchqSS.dat', 'VATRate9Code', 'VAT') + ',' + 
            GetDBColumnName('ExchqSS.dat', 'VATRate9Desc', 'VAT') + ',' + 
            GetDBColumnName('ExchqSS.dat', 'VATRate9Rate', 'VAT') + ',' + 
            GetDBColumnName('ExchqSS.dat', 'VATRate9Spare', 'VAT') + ',' + 
            GetDBColumnName('ExchqSS.dat', 'VATRate9Include', 'VAT') + ',' + 
            GetDBColumnName('ExchqSS.dat', 'VATRate9Spare2', 'VAT') + ',' + 
            GetDBColumnName('ExchqSS.dat', 'VATRate10Code', 'VAT') + ',' + 
            GetDBColumnName('ExchqSS.dat', 'VATRate10Desc', 'VAT') + ',' + 
            GetDBColumnName('ExchqSS.dat', 'VATRate10Rate', 'VAT') + ',' + 
            GetDBColumnName('ExchqSS.dat', 'VATRate10Spare', 'VAT') + ',' + 
            GetDBColumnName('ExchqSS.dat', 'VATRate10Include', 'VAT') + ',' + 
            GetDBColumnName('ExchqSS.dat', 'VATRate10Spare2', 'VAT') + ',' + 
            GetDBColumnName('ExchqSS.dat', 'VATRate11Code', 'VAT') + ',' + 
            GetDBColumnName('ExchqSS.dat', 'VATRate11Desc', 'VAT') + ',' + 
            GetDBColumnName('ExchqSS.dat', 'VATRate11Rate', 'VAT') + ',' + 
            GetDBColumnName('ExchqSS.dat', 'VATRate11Spare', 'VAT') + ',' + 
            GetDBColumnName('ExchqSS.dat', 'VATRate11Include', 'VAT') + ',' + 
            GetDBColumnName('ExchqSS.dat', 'VATRate11Spare2', 'VAT') + ',' + 
            GetDBColumnName('ExchqSS.dat', 'VATRate12Code', 'VAT') + ',' + 
            GetDBColumnName('ExchqSS.dat', 'VATRate12Desc', 'VAT') + ',' + 
            GetDBColumnName('ExchqSS.dat', 'VATRate12Rate', 'VAT') + ',' + 
            GetDBColumnName('ExchqSS.dat', 'VATRate12Spare', 'VAT') + ',' + 
            GetDBColumnName('ExchqSS.dat', 'VATRate12Include', 'VAT') + ',' + 
            GetDBColumnName('ExchqSS.dat', 'VATRate12Spare2', 'VAT') + ',' + 
            GetDBColumnName('ExchqSS.dat', 'VATRate13Code', 'VAT') + ',' + 
            GetDBColumnName('ExchqSS.dat', 'VATRate13Desc', 'VAT') + ',' +
            GetDBColumnName('ExchqSS.dat', 'VATRate13Rate', 'VAT') + ',' + 
            GetDBColumnName('ExchqSS.dat', 'VATRate13Spare', 'VAT') + ',' + 
            GetDBColumnName('ExchqSS.dat', 'VATRate13Include', 'VAT') + ',' + 
            GetDBColumnName('ExchqSS.dat', 'VATRate13Spare2', 'VAT') + ',' +
            GetDBColumnName('ExchqSS.dat', 'VATRate14Code', 'VAT') + ',' + 
            GetDBColumnName('ExchqSS.dat', 'VATRate14Desc', 'VAT') + ',' + 
            GetDBColumnName('ExchqSS.dat', 'VATRate14Rate', 'VAT') + ',' + 
            GetDBColumnName('ExchqSS.dat', 'VATRate14Spare', 'VAT') + ',' + 
            GetDBColumnName('ExchqSS.dat', 'VATRate14Include', 'VAT') + ',' + 
            GetDBColumnName('ExchqSS.dat', 'VATRate14Spare2', 'VAT') + ',' + 
            GetDBColumnName('ExchqSS.dat', 'VATRate15Code', 'VAT') + ',' + 
            GetDBColumnName('ExchqSS.dat', 'VATRate15Desc', 'VAT') + ',' + 
            GetDBColumnName('ExchqSS.dat', 'VATRate15Rate', 'VAT') + ',' + 
            GetDBColumnName('ExchqSS.dat', 'VATRate15Spare', 'VAT') + ',' + 
            GetDBColumnName('ExchqSS.dat', 'VATRate15Include', 'VAT') + ',' + 
            GetDBColumnName('ExchqSS.dat', 'VATRate15Spare2', 'VAT') + ',' + 
            GetDBColumnName('ExchqSS.dat', 'VATRate16Code', 'VAT') + ',' + 
            GetDBColumnName('ExchqSS.dat', 'VATRate16Desc', 'VAT') + ',' + 
            GetDBColumnName('ExchqSS.dat', 'VATRate16Rate', 'VAT') + ',' + 
            GetDBColumnName('ExchqSS.dat', 'VATRate16Spare', 'VAT') + ',' + 
            GetDBColumnName('ExchqSS.dat', 'VATRate16Include', 'VAT') + ',' + 
            GetDBColumnName('ExchqSS.dat', 'VATRate16Spare2', 'VAT') + ',' + 
            GetDBColumnName('ExchqSS.dat', 'VATRate17Code', 'VAT') + ',' + 
            GetDBColumnName('ExchqSS.dat', 'VATRate17Desc', 'VAT') + ',' + 
            GetDBColumnName('ExchqSS.dat', 'VATRate17Rate', 'VAT') + ',' + 
            GetDBColumnName('ExchqSS.dat', 'VATRate17Spare', 'VAT') + ',' + 
            GetDBColumnName('ExchqSS.dat', 'VATRate17Include', 'VAT') + ',' + 
            GetDBColumnName('ExchqSS.dat', 'VATRate17Spare2', 'VAT') + ',' + 
            GetDBColumnName('ExchqSS.dat', 'VATRate18Code', 'VAT') + ',' + 
            GetDBColumnName('ExchqSS.dat', 'VATRate18Desc', 'VAT') + ',' + 
            GetDBColumnName('ExchqSS.dat', 'VATRate18Rate', 'VAT') + ',' + 
            GetDBColumnName('ExchqSS.dat', 'VATRate18Spare', 'VAT') + ',' + 
            GetDBColumnName('ExchqSS.dat', 'VATRate18Include', 'VAT') + ',' + 
            GetDBColumnName('ExchqSS.dat', 'VATRate18Spare2', 'VAT') + ',' + 
            GetDBColumnName('ExchqSS.dat', 'VATIAdjCode', 'VAT') + ',' + 
            GetDBColumnName('ExchqSS.dat', 'VATIAdjDesc', 'VAT') + ',' + 
            GetDBColumnName('ExchqSS.dat', 'VATIAdjRate', 'VAT') + ',' + 
            GetDBColumnName('ExchqSS.dat', 'VATIAdjSpare', 'VAT') + ',' + 
            GetDBColumnName('ExchqSS.dat', 'VATIAdjInclude', 'VAT') + ',' + 
            GetDBColumnName('ExchqSS.dat', 'VATIAdjSpare2', 'VAT') + ',' + 
            GetDBColumnName('ExchqSS.dat', 'VATOAdjCode', 'VAT') + ',' + 
            GetDBColumnName('ExchqSS.dat', 'VATOAdjDesc', 'VAT') + ',' + 
            GetDBColumnName('ExchqSS.dat', 'VATOAdjRate', 'VAT') + ',' + 
            GetDBColumnName('ExchqSS.dat', 'VATOAdjSpare', 'VAT') + ',' + 
            GetDBColumnName('ExchqSS.dat', 'VATOAdjInclude', 'VAT') + ',' + 
            GetDBColumnName('ExchqSS.dat', 'VATOAdjSpare2', 'VAT') + ',' + 
            GetDBColumnName('ExchqSS.dat', 'VATSpare8Code', 'VAT') + ',' + 
            GetDBColumnName('ExchqSS.dat', 'VATSpare8Desc', 'VAT') + ',' +
            GetDBColumnName('ExchqSS.dat', 'VATSpare8Rate', 'VAT') + ',' + 
            GetDBColumnName('ExchqSS.dat', 'VATSpare8Spare', 'VAT') + ',' + 
            GetDBColumnName('ExchqSS.dat', 'VATSpare8Include', 'VAT') + ',' + 
            GetDBColumnName('ExchqSS.dat', 'VATSpare8Spare2', 'VAT') + ',' +
            GetDBColumnName('ExchqSS.dat', 'hide_ud_f7', 'VAT') + ',' +
            GetDBColumnName('ExchqSS.dat', 'hide_ud_f8', 'VAT') + ',' +
            GetDBColumnName('ExchqSS.dat', 'hide_ud_f9', 'VAT') + ',' +
            GetDBColumnName('ExchqSS.dat', 'hide_ud_f10', 'VAT') + ',' +
            GetDBColumnName('ExchqSS.dat', 'hide_ud_f11', 'VAT') + ',' +
            GetDBColumnName('ExchqSS.dat', 'spare2', 'VAT') + ',' +
            GetDBColumnName('ExchqSS.dat', 'vat_interval', 'VAT') + ',' +
            GetDBColumnName('ExchqSS.dat', 'spare3', 'VAT') + ',' +
            GetDBColumnName('ExchqSS.dat', 'vat_scheme', 'VAT') + ',' +
            GetDBColumnName('ExchqSS.dat', 'olast_ec_sales_date', 'VAT') + ',' +
            GetDBColumnName('ExchqSS.dat', 'vat_return_date', 'VAT') + ',' +
            GetDBColumnName('ExchqSS.dat', 'last_ec_sales_date', 'VAT') + ',' +
            GetDBColumnName('ExchqSS.dat', 'curr_period', 'VAT') + ',' +
            GetDBColumnName('ExchqSS.dat', 'udf_caption1', 'VAT') + ',' +
            GetDBColumnName('ExchqSS.dat', 'udf_caption2', 'VAT') + ',' +
            GetDBColumnName('ExchqSS.dat', 'udf_caption3', 'VAT') + ',' +
            GetDBColumnName('ExchqSS.dat', 'udf_caption4', 'VAT') + ',' +
            GetDBColumnName('ExchqSS.dat', 'udf_caption5', 'VAT') + ',' +
            GetDBColumnName('ExchqSS.dat', 'udf_caption6', 'VAT') + ',' +
            GetDBColumnName('ExchqSS.dat', 'udf_caption7', 'VAT') + ',' +
            GetDBColumnName('ExchqSS.dat', 'udf_caption8', 'VAT') + ',' +
            GetDBColumnName('ExchqSS.dat', 'udf_caption9', 'VAT') + ',' +
            GetDBColumnName('ExchqSS.dat', 'udf_caption10', 'VAT') + ',' +
            GetDBColumnName('ExchqSS.dat', 'udf_caption11', 'VAT') + ',' +
            GetDBColumnName('ExchqSS.dat', 'udf_caption12', 'VAT') + ',' +
            GetDBColumnName('ExchqSS.dat', 'udf_caption13', 'VAT') + ',' +
            GetDBColumnName('ExchqSS.dat', 'udf_caption14', 'VAT') + ',' +
            GetDBColumnName('ExchqSS.dat', 'udf_caption15', 'VAT') + ',' +
            GetDBColumnName('ExchqSS.dat', 'udf_caption16', 'VAT') + ',' +
            GetDBColumnName('ExchqSS.dat', 'udf_caption17', 'VAT') + ',' +
            GetDBColumnName('ExchqSS.dat', 'udf_caption18', 'VAT') + ',' +
            GetDBColumnName('ExchqSS.dat', 'udf_caption19', 'VAT') + ',' +
            GetDBColumnName('ExchqSS.dat', 'udf_caption20', 'VAT') + ',' +
            GetDBColumnName('ExchqSS.dat', 'udf_caption21', 'VAT') + ',' +
            GetDBColumnName('ExchqSS.dat', 'udf_caption22', 'VAT') + ',' +
            GetDBColumnName('ExchqSS.dat', 'hide_l_type0', 'VAT') + ',' +
            GetDBColumnName('ExchqSS.dat', 'hide_l_type1', 'VAT') + ',' +
            GetDBColumnName('ExchqSS.dat', 'hide_l_type2', 'VAT') + ',' +
            GetDBColumnName('ExchqSS.dat', 'hide_l_type3', 'VAT') + ',' +
            GetDBColumnName('ExchqSS.dat', 'hide_l_type4', 'VAT') + ',' +
            GetDBColumnName('ExchqSS.dat', 'hide_l_type5', 'VAT') + ',' +
            GetDBColumnName('ExchqSS.dat', 'hide_l_type6', 'VAT') + ',' +
            GetDBColumnName('ExchqSS.dat', 'report_prnn', 'VAT') + ',' +
            GetDBColumnName('ExchqSS.dat', 'forms_prnn', 'VAT') + ',' +
            GetDBColumnName('ExchqSS.dat', 'enable_ecservices', 'VAT') + ',' +
            GetDBColumnName('ExchqSS.dat', 'ecsales_threshold', 'VAT') ;
end;
  
function GetAllCurr1PTypeFields : string;
begin
  Result := GetDBColumnName('ExchqSS.dat', 'id_code', '') + ',' + 
            GetDBColumnName('ExchqSS.dat', 'MainCurrency00ScreenSymbol', 'Cur') + ',' + 
            GetDBColumnName('ExchqSS.dat', 'MainCurrency00Desc', 'Cur') + ',' + 
            GetDBColumnName('ExchqSS.dat', 'MainCurrency00CompanyRate', 'Cur') + ',' + 
            GetDBColumnName('ExchqSS.dat', 'MainCurrency00DailyRate', 'Cur') + ',' + 
            GetDBColumnName('ExchqSS.dat', 'MainCurrency00PrintSymbol', 'Cur') + ',' + 
            GetDBColumnName('ExchqSS.dat', 'MainCurrency01ScreenSymbol', 'Cur') + ',' + 
            GetDBColumnName('ExchqSS.dat', 'MainCurrency01Desc', 'Cur') + ',' + 
            GetDBColumnName('ExchqSS.dat', 'MainCurrency01CompanyRate', 'Cur') + ',' + 
            GetDBColumnName('ExchqSS.dat', 'MainCurrency01DailyRate', 'Cur') + ',' + 
            GetDBColumnName('ExchqSS.dat', 'MainCurrency01PrintSymbol', 'Cur') + ',' + 
            GetDBColumnName('ExchqSS.dat', 'MainCurrency02ScreenSymbol', 'Cur') + ',' + 
            GetDBColumnName('ExchqSS.dat', 'MainCurrency02Desc', 'Cur') + ',' + 
            GetDBColumnName('ExchqSS.dat', 'MainCurrency02CompanyRate', 'Cur') + ',' + 
            GetDBColumnName('ExchqSS.dat', 'MainCurrency02DailyRate', 'Cur') + ',' + 
            GetDBColumnName('ExchqSS.dat', 'MainCurrency02PrintSymbol', 'Cur') + ',' + 
            GetDBColumnName('ExchqSS.dat', 'MainCurrency03ScreenSymbol', 'Cur') + ',' + 
            GetDBColumnName('ExchqSS.dat', 'MainCurrency03Desc', 'Cur') + ',' + 
            GetDBColumnName('ExchqSS.dat', 'MainCurrency03CompanyRate', 'Cur') + ',' + 
            GetDBColumnName('ExchqSS.dat', 'MainCurrency03DailyRate', 'Cur') + ',' + 
            GetDBColumnName('ExchqSS.dat', 'MainCurrency03PrintSymbol', 'Cur') + ',' + 
            GetDBColumnName('ExchqSS.dat', 'MainCurrency04ScreenSymbol', 'Cur') + ',' + 
            GetDBColumnName('ExchqSS.dat', 'MainCurrency04Desc', 'Cur') + ',' + 
            GetDBColumnName('ExchqSS.dat', 'MainCurrency04CompanyRate', 'Cur') + ',' + 
            GetDBColumnName('ExchqSS.dat', 'MainCurrency04DailyRate', 'Cur') + ',' + 
            GetDBColumnName('ExchqSS.dat', 'MainCurrency04PrintSymbol', 'Cur') + ',' + 
            GetDBColumnName('ExchqSS.dat', 'MainCurrency05ScreenSymbol', 'Cur') + ',' + 
            GetDBColumnName('ExchqSS.dat', 'MainCurrency05Desc', 'Cur') + ',' + 
            GetDBColumnName('ExchqSS.dat', 'MainCurrency05CompanyRate', 'Cur') + ',' + 
            GetDBColumnName('ExchqSS.dat', 'MainCurrency05DailyRate', 'Cur') + ',' + 
            GetDBColumnName('ExchqSS.dat', 'MainCurrency05PrintSymbol', 'Cur') + ',' + 
            GetDBColumnName('ExchqSS.dat', 'MainCurrency06ScreenSymbol', 'Cur') + ',' + 
            GetDBColumnName('ExchqSS.dat', 'MainCurrency06Desc', 'Cur') + ',' + 
            GetDBColumnName('ExchqSS.dat', 'MainCurrency06CompanyRate', 'Cur') + ',' + 
            GetDBColumnName('ExchqSS.dat', 'MainCurrency06DailyRate', 'Cur') + ',' + 
            GetDBColumnName('ExchqSS.dat', 'MainCurrency06PrintSymbol', 'Cur') + ',' + 
            GetDBColumnName('ExchqSS.dat', 'MainCurrency07ScreenSymbol', 'Cur') + ',' + 
            GetDBColumnName('ExchqSS.dat', 'MainCurrency07Desc', 'Cur') + ',' + 
            GetDBColumnName('ExchqSS.dat', 'MainCurrency07CompanyRate', 'Cur') + ',' + 
            GetDBColumnName('ExchqSS.dat', 'MainCurrency07DailyRate', 'Cur') + ',' + 
            GetDBColumnName('ExchqSS.dat', 'MainCurrency07PrintSymbol', 'Cur') + ',' + 
            GetDBColumnName('ExchqSS.dat', 'MainCurrency08ScreenSymbol', 'Cur') + ',' + 
            GetDBColumnName('ExchqSS.dat', 'MainCurrency08Desc', 'Cur') + ',' + 
            GetDBColumnName('ExchqSS.dat', 'MainCurrency08CompanyRate', 'Cur') + ',' + 
            GetDBColumnName('ExchqSS.dat', 'MainCurrency08DailyRate', 'Cur') + ',' + 
            GetDBColumnName('ExchqSS.dat', 'MainCurrency08PrintSymbol', 'Cur') + ',' + 
            GetDBColumnName('ExchqSS.dat', 'MainCurrency09ScreenSymbol', 'Cur') + ',' + 
            GetDBColumnName('ExchqSS.dat', 'MainCurrency09Desc', 'Cur') + ',' + 
            GetDBColumnName('ExchqSS.dat', 'MainCurrency09CompanyRate', 'Cur') + ',' + 
            GetDBColumnName('ExchqSS.dat', 'MainCurrency09DailyRate', 'Cur') + ',' + 
            GetDBColumnName('ExchqSS.dat', 'MainCurrency09PrintSymbol', 'Cur') + ',' + 
            GetDBColumnName('ExchqSS.dat', 'MainCurrency10ScreenSymbol', 'Cur') + ',' + 
            GetDBColumnName('ExchqSS.dat', 'MainCurrency10Desc', 'Cur') + ',' + 
            GetDBColumnName('ExchqSS.dat', 'MainCurrency10CompanyRate', 'Cur') + ',' + 
            GetDBColumnName('ExchqSS.dat', 'MainCurrency10DailyRate', 'Cur') + ',' + 
            GetDBColumnName('ExchqSS.dat', 'MainCurrency10PrintSymbol', 'Cur') + ',' + 
            GetDBColumnName('ExchqSS.dat', 'MainCurrency11ScreenSymbol', 'Cur') + ',' + 
            GetDBColumnName('ExchqSS.dat', 'MainCurrency11Desc', 'Cur') + ',' + 
            GetDBColumnName('ExchqSS.dat', 'MainCurrency11CompanyRate', 'Cur') + ',' + 
            GetDBColumnName('ExchqSS.dat', 'MainCurrency11DailyRate', 'Cur') + ',' + 
            GetDBColumnName('ExchqSS.dat', 'MainCurrency11PrintSymbol', 'Cur') + ',' + 
            GetDBColumnName('ExchqSS.dat', 'MainCurrency12ScreenSymbol', 'Cur') + ',' + 
            GetDBColumnName('ExchqSS.dat', 'MainCurrency12Desc', 'Cur') + ',' + 
            GetDBColumnName('ExchqSS.dat', 'MainCurrency12CompanyRate', 'Cur') + ',' + 
            GetDBColumnName('ExchqSS.dat', 'MainCurrency12DailyRate', 'Cur') + ',' + 
            GetDBColumnName('ExchqSS.dat', 'MainCurrency12PrintSymbol', 'Cur') + ',' + 
            GetDBColumnName('ExchqSS.dat', 'MainCurrency13ScreenSymbol', 'Cur') + ',' + 
            GetDBColumnName('ExchqSS.dat', 'MainCurrency13Desc', 'Cur') + ',' + 
            GetDBColumnName('ExchqSS.dat', 'MainCurrency13CompanyRate', 'Cur') + ',' + 
            GetDBColumnName('ExchqSS.dat', 'MainCurrency13DailyRate', 'Cur') + ',' + 
            GetDBColumnName('ExchqSS.dat', 'MainCurrency13PrintSymbol', 'Cur') + ',' + 
            GetDBColumnName('ExchqSS.dat', 'MainCurrency14ScreenSymbol', 'Cur') + ',' + 
            GetDBColumnName('ExchqSS.dat', 'MainCurrency14Desc', 'Cur') + ',' + 
            GetDBColumnName('ExchqSS.dat', 'MainCurrency14CompanyRate', 'Cur') + ',' + 
            GetDBColumnName('ExchqSS.dat', 'MainCurrency14DailyRate', 'Cur') + ',' + 
            GetDBColumnName('ExchqSS.dat', 'MainCurrency14PrintSymbol', 'Cur') + ',' + 
            GetDBColumnName('ExchqSS.dat', 'MainCurrency15ScreenSymbol', 'Cur') + ',' + 
            GetDBColumnName('ExchqSS.dat', 'MainCurrency15Desc', 'Cur') + ',' + 
            GetDBColumnName('ExchqSS.dat', 'MainCurrency15CompanyRate', 'Cur') + ',' + 
            GetDBColumnName('ExchqSS.dat', 'MainCurrency15DailyRate', 'Cur') + ',' + 
            GetDBColumnName('ExchqSS.dat', 'MainCurrency15PrintSymbol', 'Cur') + ',' + 
            GetDBColumnName('ExchqSS.dat', 'MainCurrency16ScreenSymbol', 'Cur') + ',' + 
            GetDBColumnName('ExchqSS.dat', 'MainCurrency16Desc', 'Cur') + ',' + 
            GetDBColumnName('ExchqSS.dat', 'MainCurrency16CompanyRate', 'Cur') + ',' + 
            GetDBColumnName('ExchqSS.dat', 'MainCurrency16DailyRate', 'Cur') + ',' + 
            GetDBColumnName('ExchqSS.dat', 'MainCurrency16PrintSymbol', 'Cur') + ',' + 
            GetDBColumnName('ExchqSS.dat', 'MainCurrency17ScreenSymbol', 'Cur') + ',' + 
            GetDBColumnName('ExchqSS.dat', 'MainCurrency17Desc', 'Cur') + ',' + 
            GetDBColumnName('ExchqSS.dat', 'MainCurrency17CompanyRate', 'Cur') + ',' + 
            GetDBColumnName('ExchqSS.dat', 'MainCurrency17DailyRate', 'Cur') + ',' + 
            GetDBColumnName('ExchqSS.dat', 'MainCurrency17PrintSymbol', 'Cur') + ',' + 
            GetDBColumnName('ExchqSS.dat', 'MainCurrency18ScreenSymbol', 'Cur') + ',' + 
            GetDBColumnName('ExchqSS.dat', 'MainCurrency18Desc', 'Cur') + ',' + 
            GetDBColumnName('ExchqSS.dat', 'MainCurrency18CompanyRate', 'Cur') + ',' + 
            GetDBColumnName('ExchqSS.dat', 'MainCurrency18DailyRate', 'Cur') + ',' + 
            GetDBColumnName('ExchqSS.dat', 'MainCurrency18PrintSymbol', 'Cur') + ',' + 
            GetDBColumnName('ExchqSS.dat', 'MainCurrency19ScreenSymbol', 'Cur') + ',' + 
            GetDBColumnName('ExchqSS.dat', 'MainCurrency19Desc', 'Cur') + ',' + 
            GetDBColumnName('ExchqSS.dat', 'MainCurrency19CompanyRate', 'Cur') + ',' + 
            GetDBColumnName('ExchqSS.dat', 'MainCurrency19DailyRate', 'Cur') + ',' + 
            GetDBColumnName('ExchqSS.dat', 'MainCurrency19PrintSymbol', 'Cur') + ',' + 
            GetDBColumnName('ExchqSS.dat', 'MainCurrency20ScreenSymbol', 'Cur') + ',' + 
            GetDBColumnName('ExchqSS.dat', 'MainCurrency20Desc', 'Cur') + ',' + 
            GetDBColumnName('ExchqSS.dat', 'MainCurrency20CompanyRate', 'Cur') + ',' + 
            GetDBColumnName('ExchqSS.dat', 'MainCurrency20DailyRate', 'Cur') + ',' + 
            GetDBColumnName('ExchqSS.dat', 'MainCurrency20PrintSymbol', 'Cur') + ',' + 
            GetDBColumnName('ExchqSS.dat', 'MainCurrency21ScreenSymbol', 'Cur') + ',' + 
            GetDBColumnName('ExchqSS.dat', 'MainCurrency21Desc', 'Cur') + ',' + 
            GetDBColumnName('ExchqSS.dat', 'MainCurrency21CompanyRate', 'Cur') + ',' + 
            GetDBColumnName('ExchqSS.dat', 'MainCurrency21DailyRate', 'Cur') + ',' + 
            GetDBColumnName('ExchqSS.dat', 'MainCurrency21PrintSymbol', 'Cur') + ',' + 
            GetDBColumnName('ExchqSS.dat', 'MainCurrency22ScreenSymbol', 'Cur') + ',' + 
            GetDBColumnName('ExchqSS.dat', 'MainCurrency22Desc', 'Cur') + ',' + 
            GetDBColumnName('ExchqSS.dat', 'MainCurrency22CompanyRate', 'Cur') + ',' + 
            GetDBColumnName('ExchqSS.dat', 'MainCurrency22DailyRate', 'Cur') + ',' + 
            GetDBColumnName('ExchqSS.dat', 'MainCurrency22PrintSymbol', 'Cur') + ',' + 
            GetDBColumnName('ExchqSS.dat', 'MainCurrency23ScreenSymbol', 'Cur') + ',' + 
            GetDBColumnName('ExchqSS.dat', 'MainCurrency23Desc', 'Cur') + ',' + 
            GetDBColumnName('ExchqSS.dat', 'MainCurrency23CompanyRate', 'Cur') + ',' + 
            GetDBColumnName('ExchqSS.dat', 'MainCurrency23DailyRate', 'Cur') + ',' + 
            GetDBColumnName('ExchqSS.dat', 'MainCurrency23PrintSymbol', 'Cur') + ',' + 
            GetDBColumnName('ExchqSS.dat', 'MainCurrency24ScreenSymbol', 'Cur') + ',' + 
            GetDBColumnName('ExchqSS.dat', 'MainCurrency24Desc', 'Cur') + ',' + 
            GetDBColumnName('ExchqSS.dat', 'MainCurrency24CompanyRate', 'Cur') + ',' + 
            GetDBColumnName('ExchqSS.dat', 'MainCurrency24DailyRate', 'Cur') + ',' + 
            GetDBColumnName('ExchqSS.dat', 'MainCurrency24PrintSymbol', 'Cur') + ',' + 
            GetDBColumnName('ExchqSS.dat', 'MainCurrency25ScreenSymbol', 'Cur') + ',' + 
            GetDBColumnName('ExchqSS.dat', 'MainCurrency25Desc', 'Cur') + ',' + 
            GetDBColumnName('ExchqSS.dat', 'MainCurrency25CompanyRate', 'Cur') + ',' + 
            GetDBColumnName('ExchqSS.dat', 'MainCurrency25DailyRate', 'Cur') + ',' + 
            GetDBColumnName('ExchqSS.dat', 'MainCurrency25PrintSymbol', 'Cur') + ',' + 
            GetDBColumnName('ExchqSS.dat', 'MainCurrency26ScreenSymbol', 'Cur') + ',' + 
            GetDBColumnName('ExchqSS.dat', 'MainCurrency26Desc', 'Cur') + ',' + 
            GetDBColumnName('ExchqSS.dat', 'MainCurrency26CompanyRate', 'Cur') + ',' + 
            GetDBColumnName('ExchqSS.dat', 'MainCurrency26DailyRate', 'Cur') + ',' + 
            GetDBColumnName('ExchqSS.dat', 'MainCurrency26PrintSymbol', 'Cur') + ',' + 
            GetDBColumnName('ExchqSS.dat', 'MainCurrency27ScreenSymbol', 'Cur') + ',' + 
            GetDBColumnName('ExchqSS.dat', 'MainCurrency27Desc', 'Cur') + ',' + 
            GetDBColumnName('ExchqSS.dat', 'MainCurrency27CompanyRate', 'Cur') + ',' + 
            GetDBColumnName('ExchqSS.dat', 'MainCurrency27DailyRate', 'Cur') + ',' + 
            GetDBColumnName('ExchqSS.dat', 'MainCurrency27PrintSymbol', 'Cur') + ',' + 
            GetDBColumnName('ExchqSS.dat', 'MainCurrency28ScreenSymbol', 'Cur') + ',' + 
            GetDBColumnName('ExchqSS.dat', 'MainCurrency28Desc', 'Cur') + ',' + 
            GetDBColumnName('ExchqSS.dat', 'MainCurrency28CompanyRate', 'Cur') + ',' + 
            GetDBColumnName('ExchqSS.dat', 'MainCurrency28DailyRate', 'Cur') + ',' + 
            GetDBColumnName('ExchqSS.dat', 'MainCurrency28PrintSymbol', 'Cur') + ',' + 
            GetDBColumnName('ExchqSS.dat', 'MainCurrency29ScreenSymbol', 'Cur') + ',' + 
            GetDBColumnName('ExchqSS.dat', 'MainCurrency29Desc', 'Cur') + ',' + 
            GetDBColumnName('ExchqSS.dat', 'MainCurrency29CompanyRate', 'Cur') + ',' + 
            GetDBColumnName('ExchqSS.dat', 'MainCurrency29DailyRate', 'Cur') + ',' + 
            GetDBColumnName('ExchqSS.dat', 'MainCurrency29PrintSymbol', 'Cur') + ',' + 
            GetDBColumnName('ExchqSS.dat', 'MainCurrency30ScreenSymbol', 'Cur') + ',' + 
            GetDBColumnName('ExchqSS.dat', 'MainCurrency30Desc', 'Cur') + ',' + 
            GetDBColumnName('ExchqSS.dat', 'MainCurrency30CompanyRate', 'Cur') + ',' + 
            GetDBColumnName('ExchqSS.dat', 'MainCurrency30DailyRate', 'Cur') + ',' + 
            GetDBColumnName('ExchqSS.dat', 'MainCurrency30PrintSymbol', 'Cur') ;
end;
  
function GetAllDEFRecFields : string;
begin
  Result := GetDBColumnName('ExchqSS.dat', 'id_code', '') + ',' + 
            GetDBColumnName('ExchqSS.dat', 'names', 'DEF') ;
end;
  
function GetAllJobSRecFields : string;
begin
  Result := GetDBColumnName('ExchqSS.dat', 'id_code', '') + ',' + 
            GetDBColumnName('ExchqSS.dat', 'OverheadGL', 'JOB') + ',' + 
            GetDBColumnName('ExchqSS.dat', 'OverheadSpare', 'JOB') + ',' + 
            GetDBColumnName('ExchqSS.dat', 'ProductionGL', 'JOB') + ',' + 
            GetDBColumnName('ExchqSS.dat', 'ProductionSpare', 'JOB') + ',' + 
            GetDBColumnName('ExchqSS.dat', 'SubContractGL', 'JOB') + ',' + 
            GetDBColumnName('ExchqSS.dat', 'SubContractSpare', 'JOB') + ',' + 
            GetDBColumnName('ExchqSS.dat', 'SpareGL1a', 'JOB') + ',' + 
            GetDBColumnName('ExchqSS.dat', 'SpareGL1b', 'JOB') + ',' + 
            GetDBColumnName('ExchqSS.dat', 'SpareGL2a', 'JOB') + ',' + 
            GetDBColumnName('ExchqSS.dat', 'SpareGL2b', 'JOB') + ',' + 
            GetDBColumnName('ExchqSS.dat', 'SpareGL3a', 'JOB') + ',' + 
            GetDBColumnName('ExchqSS.dat', 'SpareGL3b', 'JOB') + ',' + 
            GetDBColumnName('ExchqSS.dat', 'gen_ppi', 'JOB') + ',' + 
            GetDBColumnName('ExchqSS.dat', 'ppi_ac_code', 'JOB') + ',' + 
            GetDBColumnName('ExchqSS.dat', 'SummDesc00', 'JOB') + ',' + 
            GetDBColumnName('ExchqSS.dat', 'SummDesc01', 'JOB') + ',' + 
            GetDBColumnName('ExchqSS.dat', 'SummDesc02', 'JOB') + ',' + 
            GetDBColumnName('ExchqSS.dat', 'SummDesc03', 'JOB') + ',' + 
            GetDBColumnName('ExchqSS.dat', 'SummDesc04', 'JOB') + ',' + 
            GetDBColumnName('ExchqSS.dat', 'SummDesc05', 'JOB') + ',' + 
            GetDBColumnName('ExchqSS.dat', 'SummDesc06', 'JOB') + ',' + 
            GetDBColumnName('ExchqSS.dat', 'SummDesc07', 'JOB') + ',' + 
            GetDBColumnName('ExchqSS.dat', 'SummDesc08', 'JOB') + ',' + 
            GetDBColumnName('ExchqSS.dat', 'SummDesc09', 'JOB') + ',' + 
            GetDBColumnName('ExchqSS.dat', 'SummDesc10', 'JOB') + ',' + 
            GetDBColumnName('ExchqSS.dat', 'SummDesc11', 'JOB') + ',' + 
            GetDBColumnName('ExchqSS.dat', 'SummDesc12', 'JOB') + ',' + 
            GetDBColumnName('ExchqSS.dat', 'SummDesc13', 'JOB') + ',' + 
            GetDBColumnName('ExchqSS.dat', 'SummDesc14', 'JOB') + ',' + 
            GetDBColumnName('ExchqSS.dat', 'SummDesc15', 'JOB') + ',' + 
            GetDBColumnName('ExchqSS.dat', 'SummDesc16', 'JOB') + ',' + 
            GetDBColumnName('ExchqSS.dat', 'SummDesc17', 'JOB') + ',' + 
            GetDBColumnName('ExchqSS.dat', 'SummDesc18', 'JOB') + ',' + 
            GetDBColumnName('ExchqSS.dat', 'SummDesc19', 'JOB') + ',' + 
            GetDBColumnName('ExchqSS.dat', 'SummDesc20', 'JOB') + ',' + 
            GetDBColumnName('ExchqSS.dat', 'period_bud', 'JOB') + ',' + 
            GetDBColumnName('ExchqSS.dat', 'jc_chk_acode1', 'JOB') + ',' + 
            GetDBColumnName('ExchqSS.dat', 'jc_chk_acode2', 'JOB') + ',' + 
            GetDBColumnName('ExchqSS.dat', 'jc_chk_acode3', 'JOB') + ',' + 
            GetDBColumnName('ExchqSS.dat', 'jc_chk_acode4', 'JOB') + ',' + 
            GetDBColumnName('ExchqSS.dat', 'jc_chk_acode5', 'JOB') + ',' + 
            GetDBColumnName('ExchqSS.dat', 'jwk_mth_no', 'JOB') + ',' + 
            GetDBColumnName('ExchqSS.dat', 'jtsh_nof', 'JOB') + ',' + 
            GetDBColumnName('ExchqSS.dat', 'jtsh_not', 'JOB') + ',' + 
            GetDBColumnName('ExchqSS.dat', 'jf_name', 'JOB') + ',' + 
            GetDBColumnName('ExchqSS.dat', 'jc_commit_pin', 'JOB') + ',' + 
            GetDBColumnName('ExchqSS.dat', 'ja_inv_date', 'JOB') + ',' + 
            GetDBColumnName('ExchqSS.dat', 'ja_delay_cert', 'JOB') ;
end;
  
function GetAllFormDefsTypeFields : string;
begin
  Result := GetDBColumnName('ExchqSS.dat', 'id_code', '') + ',' + 
            GetDBColumnName('ExchqSS.dat', 'PrimaryForm001', 'FR*') + ',' + 
            GetDBColumnName('ExchqSS.dat', 'PrimaryForm002', 'FR*') + ',' + 
            GetDBColumnName('ExchqSS.dat', 'PrimaryForm003', 'FR*') + ',' + 
            GetDBColumnName('ExchqSS.dat', 'PrimaryForm004', 'FR*') + ',' + 
            GetDBColumnName('ExchqSS.dat', 'PrimaryForm005', 'FR*') + ',' + 
            GetDBColumnName('ExchqSS.dat', 'PrimaryForm006', 'FR*') + ',' + 
            GetDBColumnName('ExchqSS.dat', 'PrimaryForm007', 'FR*') + ',' + 
            GetDBColumnName('ExchqSS.dat', 'PrimaryForm008', 'FR*') + ',' + 
            GetDBColumnName('ExchqSS.dat', 'PrimaryForm009', 'FR*') + ',' + 
            GetDBColumnName('ExchqSS.dat', 'PrimaryForm010', 'FR*') + ',' + 
            GetDBColumnName('ExchqSS.dat', 'PrimaryForm011', 'FR*') + ',' + 
            GetDBColumnName('ExchqSS.dat', 'PrimaryForm012', 'FR*') + ',' + 
            GetDBColumnName('ExchqSS.dat', 'PrimaryForm013', 'FR*') + ',' + 
            GetDBColumnName('ExchqSS.dat', 'PrimaryForm014', 'FR*') + ',' + 
            GetDBColumnName('ExchqSS.dat', 'PrimaryForm015', 'FR*') + ',' + 
            GetDBColumnName('ExchqSS.dat', 'PrimaryForm016', 'FR*') + ',' + 
            GetDBColumnName('ExchqSS.dat', 'PrimaryForm017', 'FR*') + ',' + 
            GetDBColumnName('ExchqSS.dat', 'PrimaryForm018', 'FR*') + ',' + 
            GetDBColumnName('ExchqSS.dat', 'PrimaryForm019', 'FR*') + ',' + 
            GetDBColumnName('ExchqSS.dat', 'PrimaryForm020', 'FR*') + ',' + 
            GetDBColumnName('ExchqSS.dat', 'PrimaryForm021', 'FR*') + ',' + 
            GetDBColumnName('ExchqSS.dat', 'PrimaryForm022', 'FR*') + ',' + 
            GetDBColumnName('ExchqSS.dat', 'PrimaryForm023', 'FR*') + ',' + 
            GetDBColumnName('ExchqSS.dat', 'PrimaryForm024', 'FR*') + ',' + 
            GetDBColumnName('ExchqSS.dat', 'PrimaryForm025', 'FR*') + ',' + 
            GetDBColumnName('ExchqSS.dat', 'PrimaryForm026', 'FR*') + ',' + 
            GetDBColumnName('ExchqSS.dat', 'PrimaryForm027', 'FR*') + ',' + 
            GetDBColumnName('ExchqSS.dat', 'PrimaryForm028', 'FR*') + ',' + 
            GetDBColumnName('ExchqSS.dat', 'PrimaryForm029', 'FR*') + ',' + 
            GetDBColumnName('ExchqSS.dat', 'PrimaryForm030', 'FR*') + ',' + 
            GetDBColumnName('ExchqSS.dat', 'PrimaryForm031', 'FR*') + ',' + 
            GetDBColumnName('ExchqSS.dat', 'PrimaryForm032', 'FR*') + ',' + 
            GetDBColumnName('ExchqSS.dat', 'PrimaryForm033', 'FR*') + ',' + 
            GetDBColumnName('ExchqSS.dat', 'PrimaryForm034', 'FR*') + ',' + 
            GetDBColumnName('ExchqSS.dat', 'PrimaryForm035', 'FR*') + ',' + 
            GetDBColumnName('ExchqSS.dat', 'PrimaryForm036', 'FR*') + ',' + 
            GetDBColumnName('ExchqSS.dat', 'PrimaryForm037', 'FR*') + ',' + 
            GetDBColumnName('ExchqSS.dat', 'PrimaryForm038', 'FR*') + ',' + 
            GetDBColumnName('ExchqSS.dat', 'PrimaryForm039', 'FR*') + ',' + 
            GetDBColumnName('ExchqSS.dat', 'PrimaryForm040', 'FR*') + ',' + 
            GetDBColumnName('ExchqSS.dat', 'PrimaryForm041', 'FR*') + ',' + 
            GetDBColumnName('ExchqSS.dat', 'PrimaryForm042', 'FR*') + ',' + 
            GetDBColumnName('ExchqSS.dat', 'PrimaryForm043', 'FR*') + ',' + 
            GetDBColumnName('ExchqSS.dat', 'PrimaryForm044', 'FR*') + ',' + 
            GetDBColumnName('ExchqSS.dat', 'PrimaryForm045', 'FR*') + ',' + 
            GetDBColumnName('ExchqSS.dat', 'PrimaryForm046', 'FR*') + ',' + 
            GetDBColumnName('ExchqSS.dat', 'PrimaryForm047', 'FR*') + ',' + 
            GetDBColumnName('ExchqSS.dat', 'PrimaryForm048', 'FR*') + ',' + 
            GetDBColumnName('ExchqSS.dat', 'PrimaryForm049', 'FR*') + ',' + 
            GetDBColumnName('ExchqSS.dat', 'PrimaryForm050', 'FR*') + ',' + 
            GetDBColumnName('ExchqSS.dat', 'PrimaryForm051', 'FR*') + ',' + 
            GetDBColumnName('ExchqSS.dat', 'PrimaryForm052', 'FR*') + ',' + 
            GetDBColumnName('ExchqSS.dat', 'PrimaryForm053', 'FR*') + ',' + 
            GetDBColumnName('ExchqSS.dat', 'PrimaryForm054', 'FR*') + ',' + 
            GetDBColumnName('ExchqSS.dat', 'PrimaryForm055', 'FR*') + ',' + 
            GetDBColumnName('ExchqSS.dat', 'PrimaryForm056', 'FR*') + ',' + 
            GetDBColumnName('ExchqSS.dat', 'PrimaryForm057', 'FR*') + ',' + 
            GetDBColumnName('ExchqSS.dat', 'PrimaryForm058', 'FR*') + ',' + 
            GetDBColumnName('ExchqSS.dat', 'PrimaryForm059', 'FR*') + ',' + 
            GetDBColumnName('ExchqSS.dat', 'PrimaryForm060', 'FR*') + ',' + 
            GetDBColumnName('ExchqSS.dat', 'PrimaryForm061', 'FR*') + ',' + 
            GetDBColumnName('ExchqSS.dat', 'PrimaryForm062', 'FR*') + ',' + 
            GetDBColumnName('ExchqSS.dat', 'PrimaryForm063', 'FR*') + ',' + 
            GetDBColumnName('ExchqSS.dat', 'PrimaryForm064', 'FR*') + ',' + 
            GetDBColumnName('ExchqSS.dat', 'PrimaryForm065', 'FR*') + ',' + 
            GetDBColumnName('ExchqSS.dat', 'PrimaryForm066', 'FR*') + ',' + 
            GetDBColumnName('ExchqSS.dat', 'PrimaryForm067', 'FR*') + ',' + 
            GetDBColumnName('ExchqSS.dat', 'PrimaryForm068', 'FR*') + ',' + 
            GetDBColumnName('ExchqSS.dat', 'PrimaryForm069', 'FR*') + ',' + 
            GetDBColumnName('ExchqSS.dat', 'PrimaryForm070', 'FR*') + ',' + 
            GetDBColumnName('ExchqSS.dat', 'PrimaryForm071', 'FR*') + ',' + 
            GetDBColumnName('ExchqSS.dat', 'PrimaryForm072', 'FR*') + ',' + 
            GetDBColumnName('ExchqSS.dat', 'PrimaryForm073', 'FR*') + ',' + 
            GetDBColumnName('ExchqSS.dat', 'PrimaryForm074', 'FR*') + ',' + 
            GetDBColumnName('ExchqSS.dat', 'PrimaryForm075', 'FR*') + ',' + 
            GetDBColumnName('ExchqSS.dat', 'PrimaryForm076', 'FR*') + ',' + 
            GetDBColumnName('ExchqSS.dat', 'PrimaryForm077', 'FR*') + ',' + 
            GetDBColumnName('ExchqSS.dat', 'PrimaryForm078', 'FR*') + ',' + 
            GetDBColumnName('ExchqSS.dat', 'PrimaryForm079', 'FR*') + ',' + 
            GetDBColumnName('ExchqSS.dat', 'PrimaryForm080', 'FR*') + ',' + 
            GetDBColumnName('ExchqSS.dat', 'PrimaryForm081', 'FR*') + ',' + 
            GetDBColumnName('ExchqSS.dat', 'PrimaryForm082', 'FR*') + ',' + 
            GetDBColumnName('ExchqSS.dat', 'PrimaryForm083', 'FR*') + ',' + 
            GetDBColumnName('ExchqSS.dat', 'PrimaryForm084', 'FR*') + ',' + 
            GetDBColumnName('ExchqSS.dat', 'PrimaryForm085', 'FR*') + ',' + 
            GetDBColumnName('ExchqSS.dat', 'PrimaryForm086', 'FR*') + ',' + 
            GetDBColumnName('ExchqSS.dat', 'PrimaryForm087', 'FR*') + ',' + 
            GetDBColumnName('ExchqSS.dat', 'PrimaryForm088', 'FR*') + ',' + 
            GetDBColumnName('ExchqSS.dat', 'PrimaryForm089', 'FR*') + ',' + 
            GetDBColumnName('ExchqSS.dat', 'PrimaryForm090', 'FR*') + ',' + 
            GetDBColumnName('ExchqSS.dat', 'PrimaryForm091', 'FR*') + ',' + 
            GetDBColumnName('ExchqSS.dat', 'PrimaryForm092', 'FR*') + ',' + 
            GetDBColumnName('ExchqSS.dat', 'PrimaryForm093', 'FR*') + ',' + 
            GetDBColumnName('ExchqSS.dat', 'PrimaryForm094', 'FR*') + ',' + 
            GetDBColumnName('ExchqSS.dat', 'PrimaryForm095', 'FR*') + ',' + 
            GetDBColumnName('ExchqSS.dat', 'PrimaryForm096', 'FR*') + ',' + 
            GetDBColumnName('ExchqSS.dat', 'PrimaryForm097', 'FR*') + ',' + 
            GetDBColumnName('ExchqSS.dat', 'PrimaryForm098', 'FR*') + ',' + 
            GetDBColumnName('ExchqSS.dat', 'PrimaryForm099', 'FR*') + ',' + 
            GetDBColumnName('ExchqSS.dat', 'PrimaryForm100', 'FR*') + ',' + 
            GetDBColumnName('ExchqSS.dat', 'PrimaryForm101', 'FR*') + ',' + 
            GetDBColumnName('ExchqSS.dat', 'PrimaryForm102', 'FR*') + ',' + 
            GetDBColumnName('ExchqSS.dat', 'PrimaryForm103', 'FR*') + ',' + 
            GetDBColumnName('ExchqSS.dat', 'PrimaryForm104', 'FR*') + ',' + 
            GetDBColumnName('ExchqSS.dat', 'PrimaryForm105', 'FR*') + ',' + 
            GetDBColumnName('ExchqSS.dat', 'PrimaryForm106', 'FR*') + ',' + 
            GetDBColumnName('ExchqSS.dat', 'PrimaryForm107', 'FR*') + ',' + 
            GetDBColumnName('ExchqSS.dat', 'PrimaryForm108', 'FR*') + ',' + 
            GetDBColumnName('ExchqSS.dat', 'PrimaryForm109', 'FR*') + ',' + 
            GetDBColumnName('ExchqSS.dat', 'PrimaryForm110', 'FR*') + ',' + 
            GetDBColumnName('ExchqSS.dat', 'PrimaryForm111', 'FR*') + ',' + 
            GetDBColumnName('ExchqSS.dat', 'PrimaryForm112', 'FR*') + ',' + 
            GetDBColumnName('ExchqSS.dat', 'PrimaryForm113', 'FR*') + ',' + 
            GetDBColumnName('ExchqSS.dat', 'PrimaryForm114', 'FR*') + ',' + 
            GetDBColumnName('ExchqSS.dat', 'PrimaryForm115', 'FR*') + ',' + 
            GetDBColumnName('ExchqSS.dat', 'PrimaryForm116', 'FR*') + ',' + 
            GetDBColumnName('ExchqSS.dat', 'PrimaryForm117', 'FR*') + ',' + 
            GetDBColumnName('ExchqSS.dat', 'PrimaryForm118', 'FR*') + ',' + 
            GetDBColumnName('ExchqSS.dat', 'PrimaryForm119', 'FR*') + ',' + 
            GetDBColumnName('ExchqSS.dat', 'PrimaryForm120', 'FR*') + ',' + 
            GetDBColumnName('ExchqSS.dat', 'descr', 'FR*') ;
end;
  
function GetAllModuleRelTypeFields : string;
begin
  Result := GetDBColumnName('ExchqSS.dat', 'id_code', '') + ',' + 
            GetDBColumnName('ExchqSS.dat', 'module_sec', 'MOD') ;
end;
  
function GetAllGCur1PTypeFields : string;
begin
  Result := GetDBColumnName('ExchqSS.dat', 'id_code', '') + ',' + 
            GetDBColumnName('ExchqSS.dat', 'GCR_tri_rates', 'GC*') + ',' + 
            GetDBColumnName('ExchqSS.dat', 'GCR_tri_euro', 'GC*') + ',' + 
            GetDBColumnName('ExchqSS.dat', 'GCR_tri_invert', 'GC*') + ',' + 
            GetDBColumnName('ExchqSS.dat', 'GCR_tri_float', 'GC*') ;
end;
  
function GetAllEDI1TypeFields : string;
begin
  Result := GetDBColumnName('ExchqSS.dat', 'id_code', '') + ',' + 
            GetDBColumnName('ExchqSS.dat', 'vedi_method', 'ED1') + ',' + 
            GetDBColumnName('ExchqSS.dat', 'v_van_mode', 'ED1') + ',' + 
            GetDBColumnName('ExchqSS.dat', 'vedifact', 'ED1') + ',' + 
            GetDBColumnName('ExchqSS.dat', 'vvance_id', 'ED1') + ',' + 
            GetDBColumnName('ExchqSS.dat', 'vvanu_id', 'ED1') + ',' + 
            GetDBColumnName('ExchqSS.dat', 'v_use_crlf', 'ED1') + ',' + 
            GetDBColumnName('ExchqSS.dat', 'v_test_mode', 'ED1') + ',' + 
            GetDBColumnName('ExchqSS.dat', 'v_dir_path', 'ED1') + ',' + 
            GetDBColumnName('ExchqSS.dat', 'v_compress', 'ED1') + ',' + 
            GetDBColumnName('ExchqSS.dat', 'vce_email', 'ED1') + ',' + 
            GetDBColumnName('ExchqSS.dat', 'vu_email', 'ED1') + ',' + 
            GetDBColumnName('ExchqSS.dat', 've_priority', 'ED1') + ',' + 
            GetDBColumnName('ExchqSS.dat', 've_subject', 'ED1') + ',' + 
            GetDBColumnName('ExchqSS.dat', 'v_send_email', 'ED1') + ',' + 
            GetDBColumnName('ExchqSS.dat', 'vieecslp', 'ED1') ;
end;
  
function GetAllEDI2TypeFields : string;
begin
  Result := GetDBColumnName('ExchqSS.dat', 'id_code', '') + ',' + 
            GetDBColumnName('ExchqSS.dat', 'em_name', 'ED2') + ',' + 
            GetDBColumnName('ExchqSS.dat', 'em_address', 'ED2') + ',' + 
            GetDBColumnName('ExchqSS.dat', 'em_smtp', 'ED2') + ',' + 
            GetDBColumnName('ExchqSS.dat', 'em_priority', 'ED2') + ',' + 
            GetDBColumnName('ExchqSS.dat', 'em_use_mapi', 'ED2') + ',' + 
            GetDBColumnName('ExchqSS.dat', 'fx_use_mapi', 'ED2') + ',' + 
            GetDBColumnName('ExchqSS.dat', 'fax_prnn', 'ED2') + ',' + 
            GetDBColumnName('ExchqSS.dat', 'email_prnn', 'ED2') + ',' + 
            GetDBColumnName('ExchqSS.dat', 'fx_name', 'ED2') + ',' + 
            GetDBColumnName('ExchqSS.dat', 'fx_phone', 'ED2') + ',' + 
            GetDBColumnName('ExchqSS.dat', 'em_attch_mode', 'ED2') + ',' + 
            GetDBColumnName('ExchqSS.dat', 'fax_dll_path', 'ED2') ;
end;
  
function GetAllEDI3TypeFields : string;
begin
  Result := GetDBColumnName('ExchqSS.dat', 'id_code', '') + ',' + 
            GetDBColumnName('ExchqSS.dat', 'spare', 'ED3') ;
end;
  
function GetAllCustomFTypeFields : string;
begin
  Result := GetDBColumnName('ExchqSS.dat', 'id_code', '') + ',' + 
            GetDBColumnName('ExchqSS.dat', 'f_captions', 'CT*') + ',' + 
            GetDBColumnName('ExchqSS.dat', 'f_hide', 'CT*') ;
end;
  
function GetAllCISCRecFields : string;
begin
  Result := GetDBColumnName('ExchqSS.dat', 'id_code', '') + ',' + 
            GetDBColumnName('ExchqSS.dat', 'CISConstructCode', 'CIS') + ',' + 
            GetDBColumnName('ExchqSS.dat', 'CISConstructDesc', 'CIS') + ',' + 
            GetDBColumnName('ExchqSS.dat', 'CISConstructRate', 'CIS') + ',' + 
            GetDBColumnName('ExchqSS.dat', 'CISConstructGLCode', 'CIS') + ',' + 
            GetDBColumnName('ExchqSS.dat', 'CISConstructDepartment', 'CIS') + ',' + 
            GetDBColumnName('ExchqSS.dat', 'CISConstructCostCentre', 'CIS') + ',' + 
            GetDBColumnName('ExchqSS.dat', 'CISConstructSpare', 'CIS') + ',' + 
            GetDBColumnName('ExchqSS.dat', 'CISTechnicalCode', 'CIS') + ',' + 
            GetDBColumnName('ExchqSS.dat', 'CISTechnicalDesc', 'CIS') + ',' + 
            GetDBColumnName('ExchqSS.dat', 'CISTechnicalRate', 'CIS') + ',' + 
            GetDBColumnName('ExchqSS.dat', 'CISTechnicalGLCode', 'CIS') + ',' + 
            GetDBColumnName('ExchqSS.dat', 'CISTechnicalDepartment', 'CIS') + ',' + 
            GetDBColumnName('ExchqSS.dat', 'CISTechnicalCostCentre', 'CIS') + ',' + 
            GetDBColumnName('ExchqSS.dat', 'CISTechnicalSpare', 'CIS') + ',' + 
            GetDBColumnName('ExchqSS.dat', 'CISRate1Code', 'CIS') + ',' + 
            GetDBColumnName('ExchqSS.dat', 'CISRate1Desc', 'CIS') + ',' + 
            GetDBColumnName('ExchqSS.dat', 'CISRate1Rate', 'CIS') + ',' + 
            GetDBColumnName('ExchqSS.dat', 'CISRate1GLCode', 'CIS') + ',' + 
            GetDBColumnName('ExchqSS.dat', 'CISRate1Department', 'CIS') + ',' + 
            GetDBColumnName('ExchqSS.dat', 'CISRate1CostCentre', 'CIS') + ',' + 
            GetDBColumnName('ExchqSS.dat', 'CISRate1Spare', 'CIS') + ',' + 
            GetDBColumnName('ExchqSS.dat', 'CISRate2Code', 'CIS') + ',' + 
            GetDBColumnName('ExchqSS.dat', 'CISRate2Desc', 'CIS') + ',' + 
            GetDBColumnName('ExchqSS.dat', 'CISRate2Rate', 'CIS') + ',' + 
            GetDBColumnName('ExchqSS.dat', 'CISRate2GLCode', 'CIS') + ',' + 
            GetDBColumnName('ExchqSS.dat', 'CISRate2Department', 'CIS') + ',' + 
            GetDBColumnName('ExchqSS.dat', 'CISRate2CostCentre', 'CIS') + ',' + 
            GetDBColumnName('ExchqSS.dat', 'CISRate2Spare', 'CIS') + ',' + 
            GetDBColumnName('ExchqSS.dat', 'CISRate3Code', 'CIS') + ',' + 
            GetDBColumnName('ExchqSS.dat', 'CISRate3Desc', 'CIS') + ',' + 
            GetDBColumnName('ExchqSS.dat', 'CISRate3Rate', 'CIS') + ',' + 
            GetDBColumnName('ExchqSS.dat', 'CISRate3GLCode', 'CIS') + ',' + 
            GetDBColumnName('ExchqSS.dat', 'CISRate3Department', 'CIS') + ',' + 
            GetDBColumnName('ExchqSS.dat', 'CISRate3CostCentre', 'CIS') + ',' + 
            GetDBColumnName('ExchqSS.dat', 'CISRate3Spare', 'CIS') + ',' + 
            GetDBColumnName('ExchqSS.dat', 'CISRate4Code', 'CIS') + ',' + 
            GetDBColumnName('ExchqSS.dat', 'CISRate4Desc', 'CIS') + ',' + 
            GetDBColumnName('ExchqSS.dat', 'CISRate4Rate', 'CIS') + ',' + 
            GetDBColumnName('ExchqSS.dat', 'CISRate4GLCode', 'CIS') + ',' + 
            GetDBColumnName('ExchqSS.dat', 'CISRate4Department', 'CIS') + ',' + 
            GetDBColumnName('ExchqSS.dat', 'CISRate4CostCentre', 'CIS') + ',' + 
            GetDBColumnName('ExchqSS.dat', 'CISRate4Spare', 'CIS') + ',' + 
            GetDBColumnName('ExchqSS.dat', 'CISRate5Code', 'CIS') + ',' + 
            GetDBColumnName('ExchqSS.dat', 'CISRate5Desc', 'CIS') + ',' + 
            GetDBColumnName('ExchqSS.dat', 'CISRate5Rate', 'CIS') + ',' + 
            GetDBColumnName('ExchqSS.dat', 'CISRate5GLCode', 'CIS') + ',' + 
            GetDBColumnName('ExchqSS.dat', 'CISRate5Department', 'CIS') + ',' + 
            GetDBColumnName('ExchqSS.dat', 'CISRate5CostCentre', 'CIS') + ',' + 
            GetDBColumnName('ExchqSS.dat', 'CISRate5Spare', 'CIS') + ',' + 
            GetDBColumnName('ExchqSS.dat', 'CISRate6Code', 'CIS') + ',' + 
            GetDBColumnName('ExchqSS.dat', 'CISRate6Desc', 'CIS') + ',' + 
            GetDBColumnName('ExchqSS.dat', 'CISRate6Rate', 'CIS') + ',' + 
            GetDBColumnName('ExchqSS.dat', 'CISRate6GLCode', 'CIS') + ',' + 
            GetDBColumnName('ExchqSS.dat', 'CISRate6Department', 'CIS') + ',' + 
            GetDBColumnName('ExchqSS.dat', 'CISRate6CostCentre', 'CIS') + ',' + 
            GetDBColumnName('ExchqSS.dat', 'CISRate6Spare', 'CIS') + ',' + 
            GetDBColumnName('ExchqSS.dat', 'CISRate7Code', 'CIS') + ',' + 
            GetDBColumnName('ExchqSS.dat', 'CISRate7Desc', 'CIS') + ',' + 
            GetDBColumnName('ExchqSS.dat', 'CISRate7Rate', 'CIS') + ',' + 
            GetDBColumnName('ExchqSS.dat', 'CISRate7GLCode', 'CIS') + ',' + 
            GetDBColumnName('ExchqSS.dat', 'CISRate7Department', 'CIS') + ',' + 
            GetDBColumnName('ExchqSS.dat', 'CISRate7CostCentre', 'CIS') + ',' + 
            GetDBColumnName('ExchqSS.dat', 'CISRate7Spare', 'CIS') + ',' + 
            GetDBColumnName('ExchqSS.dat', 'CISRate8Code', 'CIS') + ',' + 
            GetDBColumnName('ExchqSS.dat', 'CISRate8Desc', 'CIS') + ',' + 
            GetDBColumnName('ExchqSS.dat', 'CISRate8Rate', 'CIS') + ',' + 
            GetDBColumnName('ExchqSS.dat', 'CISRate8GLCode', 'CIS') + ',' + 
            GetDBColumnName('ExchqSS.dat', 'CISRate8Department', 'CIS') + ',' + 
            GetDBColumnName('ExchqSS.dat', 'CISRate8CostCentre', 'CIS') + ',' + 
            GetDBColumnName('ExchqSS.dat', 'CISRate8Spare', 'CIS') + ',' + 
            GetDBColumnName('ExchqSS.dat', 'CISRate9Code', 'CIS') + ',' + 
            GetDBColumnName('ExchqSS.dat', 'CISRate9Desc', 'CIS') + ',' + 
            GetDBColumnName('ExchqSS.dat', 'CISRate9Rate', 'CIS') + ',' + 
            GetDBColumnName('ExchqSS.dat', 'CISRate9GLCode', 'CIS') + ',' + 
            GetDBColumnName('ExchqSS.dat', 'CISRate9Department', 'CIS') + ',' + 
            GetDBColumnName('ExchqSS.dat', 'CISRate9CostCentre', 'CIS') + ',' + 
            GetDBColumnName('ExchqSS.dat', 'CISRate9Spare', 'CIS') + ',' + 
            GetDBColumnName('ExchqSS.dat', 'cis_interval', 'CIS') + ',' + 
            GetDBColumnName('ExchqSS.dat', 'cis_auto_set_pr', 'CIS') + ',' + 
            GetDBColumnName('ExchqSS.dat', 'cisvat_code', 'CIS') + ',' + 
            GetDBColumnName('ExchqSS.dat', 'cis_spare3', 'CIS') + ',' + 
            GetDBColumnName('ExchqSS.dat', 'cis_scheme', 'CIS') + ',' + 
            GetDBColumnName('ExchqSS.dat', 'cis_return_date', 'CIS') + ',' + 
            GetDBColumnName('ExchqSS.dat', 'cis_curr_period', 'CIS') + ',' + 
            GetDBColumnName('ExchqSS.dat', 'cis_loaded', 'CIS') + ',' + 
            GetDBColumnName('ExchqSS.dat', 'cis_tax_ref', 'CIS') + ',' + 
            GetDBColumnName('ExchqSS.dat', 'cis_agg_mode', 'CIS') + ',' + 
            GetDBColumnName('ExchqSS.dat', 'cis_sort_mode', 'CIS') + ',' + 
            GetDBColumnName('ExchqSS.dat', 'cisv_folio', 'CIS') + ',' + 
            GetDBColumnName('ExchqSS.dat', 'cis_vouchers', 'CIS') + ',' + 
            GetDBColumnName('ExchqSS.dat', 'ivan_mode', 'CIS') + ',' + 
            GetDBColumnName('ExchqSS.dat', 'ivanir_id', 'CIS') + ',' + 
            GetDBColumnName('ExchqSS.dat', 'ivanu_id', 'CIS') + ',' + 
            GetDBColumnName('ExchqSS.dat', 'ivan_pw', 'CIS') + ',' + 
            GetDBColumnName('ExchqSS.dat', 'iiredi_ref', 'CIS') + ',' + 
            GetDBColumnName('ExchqSS.dat', 'i_use_crlf', 'CIS') + ',' + 
            GetDBColumnName('ExchqSS.dat', 'i_test_mode', 'CIS') + ',' + 
            GetDBColumnName('ExchqSS.dat', 'i_dir_path', 'CIS') + ',' + 
            GetDBColumnName('ExchqSS.dat', 'iedi_method', 'CIS') + ',' + 
            GetDBColumnName('ExchqSS.dat', 'i_send_email', 'CIS') + ',' + 
            GetDBColumnName('ExchqSS.dat', 'ie_priority', 'CIS') + ',' + 
            GetDBColumnName('ExchqSS.dat', 'j_cert_no', 'CIS') + ',' + 
            GetDBColumnName('ExchqSS.dat', 'j_cert_expiry', 'CIS') + ',' + 
            GetDBColumnName('ExchqSS.dat', 'jcis_type', 'CIS') ;
end;
  
function GetAllCIS340RecFields : string;
begin
  Result := GetDBColumnName('ExchqSS.dat', 'id_code', '') + ',' + 
            GetDBColumnName('ExchqSS.dat', 'CISCNINO', 'CI2') + ',' + 
            GetDBColumnName('ExchqSS.dat', 'CISCUTR', 'CI2') + ',' + 
            GetDBColumnName('ExchqSS.dat', 'CISACCONo', 'CI2') + ',' + 
            GetDBColumnName('ExchqSS.dat', 'IGWIRId', 'CI2') + ',' + 
            GetDBColumnName('ExchqSS.dat', 'IGWUId', 'CI2') + ',' + 
            GetDBColumnName('ExchqSS.dat', 'IGWTO', 'CI2') + ',' + 
            GetDBColumnName('ExchqSS.dat', 'IGWIRef', 'CI2') + ',' + 
            GetDBColumnName('ExchqSS.dat', 'IXMLDirPath', 'CI2') + ',' + 
            GetDBColumnName('ExchqSS.dat', 'IXTestMode', 'CI2') + ',' + 
            GetDBColumnName('ExchqSS.dat', 'IXConfEmp', 'CI2') + ',' + 
            GetDBColumnName('ExchqSS.dat', 'IXVerSub', 'CI2') + ',' + 
            GetDBColumnName('ExchqSS.dat', 'IXNoPay', 'CI2') + ',' + 
            GetDBColumnName('ExchqSS.dat', 'IGWTR', 'CI2') + ',' + 
            GetDBColumnName('ExchqSS.dat', 'IGSubType', 'CI2') ;
end;
  
function GetAllCustDiscTypeFields : string;
begin
  Result := GetDBColumnName('EXSTKCHK.dat', 'rec_mfix', '') + ',' + 
            GetDBColumnName('EXSTKCHK.dat', 'sub_type', '') + ',' + 
            GetDBColumnName('EXSTKCHK.dat', 'exstchk_var1', '') + ',' + 
            GetDBColumnName('EXSTKCHK.dat', 'exstchk_var2', '') + ',' + 
            GetDBColumnName('EXSTKCHK.dat', 'exstchk_var3', '') + ',' + 
            GetDBColumnName('EXSTKCHK.dat', 'dc_code', 'C*') + ',' + 
            GetDBColumnName('EXSTKCHK.dat', 'cust_qb_type', 'C*') + ',' + 
            GetDBColumnName('EXSTKCHK.dat', 'cust_qb_curr', 'C*') + ',' + 
            GetDBColumnName('EXSTKCHK.dat', 'cust_qs_price', 'C*') + ',' + 
            GetDBColumnName('EXSTKCHK.dat', 'cust_q_band', 'C*') + ',' + 
            GetDBColumnName('EXSTKCHK.dat', 'cust_qdisc_p', 'C*') + ',' + 
            GetDBColumnName('EXSTKCHK.dat', 'cust_qdisc_a', 'C*') + ',' + 
            GetDBColumnName('EXSTKCHK.dat', 'cust_qmumg', 'C*') + ',' + 
            GetDBColumnName('EXSTKCHK.dat', 'cuse_dates', 'C*') + ',' + 
            GetDBColumnName('EXSTKCHK.dat', 'cstart_d', 'C*') + ',' + 
            GetDBColumnName('EXSTKCHK.dat', 'cend_d', 'C*') ;
end;
  
function GetAllMultiLocTypeFields : string;
begin
  Result := GetDBColumnName('EXSTKCHK.dat', 'rec_mfix', '') + ',' + 
            GetDBColumnName('EXSTKCHK.dat', 'sub_type', '') + ',' + 
            GetDBColumnName('EXSTKCHK.dat', 'exstchk_var1', '') + ',' + 
            GetDBColumnName('EXSTKCHK.dat', 'exstchk_var2', '') + ',' + 
            GetDBColumnName('EXSTKCHK.dat', 'exstchk_var3', '') + ',' + 
            GetDBColumnName('EXSTKCHK.dat', 'loc_tag', 'PL') + ',' + 
            GetDBColumnName('EXSTKCHK.dat', 'loc_f_desc', 'PL') + ',' + 
            GetDBColumnName('EXSTKCHK.dat', 'loc_run_no', 'PL') ;
end;
  
function GetAllFiFoTypeFields : string;
begin
  Result := GetDBColumnName('EXSTKCHK.dat', 'rec_mfix', '') + ',' + 
            GetDBColumnName('EXSTKCHK.dat', 'sub_type', '') + ',' + 
            GetDBColumnName('EXSTKCHK.dat', 'exstchk_var1', '') + ',' + 
            GetDBColumnName('EXSTKCHK.dat', 'exstchk_var2', '') + ',' + 
            GetDBColumnName('EXSTKCHK.dat', 'exstchk_var3', '') + ',' + 
            GetDBColumnName('EXSTKCHK.dat', 'fifo_stk_folio', 'FS') + ',' + 
            GetDBColumnName('EXSTKCHK.dat', 'doc_abs_no', 'FS') + ',' + 
            GetDBColumnName('EXSTKCHK.dat', 'fifo_date', 'FS') + ',' + 
            GetDBColumnName('EXSTKCHK.dat', 'qty_left', 'FS') + ',' + 
            GetDBColumnName('EXSTKCHK.dat', 'doc_ref', 'FS') + ',' + 
            GetDBColumnName('EXSTKCHK.dat', 'fifo_qty', 'FS') + ',' + 
            GetDBColumnName('EXSTKCHK.dat', 'fifo_cost', 'FS') + ',' + 
            GetDBColumnName('EXSTKCHK.dat', 'fifo_curr', 'FS') + ',' + 
            GetDBColumnName('EXSTKCHK.dat', 'fifo_cust', 'FS') + ',' + 
            GetDBColumnName('EXSTKCHK.dat', 'fifomloc', 'FS') + ',' + 
            GetDBColumnName('EXSTKCHK.dat', 'fifoc_rates1', 'FS') + ',' + 
            GetDBColumnName('EXSTKCHK.dat', 'fifoc_rates2', 'FS') + ',' + 
            GetDBColumnName('EXSTKCHK.dat', 'fuse_o_rate', 'FS') + ',' + 
            GetDBColumnName('EXSTKCHK.dat', 'FIFOtri_rates', 'FS') + ',' + 
            GetDBColumnName('EXSTKCHK.dat', 'FIFOtri_euro', 'FS') + ',' + 
            GetDBColumnName('EXSTKCHK.dat', 'FIFOtri_invert', 'FS') + ',' + 
            GetDBColumnName('EXSTKCHK.dat', 'FIFOtri_float', 'FS') + ',' + 
            GetDBColumnName('EXSTKCHK.dat', 'FIFOTtrispare', 'FS') ;
end;
  
function GetAllIrishVATSOPInpDefTypeFields : string;
begin
  Result := GetDBColumnName('EXSTKCHK.dat', 'rec_mfix', '') + ',' + 
            GetDBColumnName('EXSTKCHK.dat', 'sub_type', '') + ',' + 
            GetDBColumnName('EXSTKCHK.dat', 'exstchk_var1', '') + ',' + 
            GetDBColumnName('EXSTKCHK.dat', 'exstchk_var2', '') + ',' + 
            GetDBColumnName('EXSTKCHK.dat', 'exstchk_var3', '') + ',' + 
            GetDBColumnName('EXSTKCHK.dat', 'IrishSOPData', 'AB') ;
end;
  
function GetAllQtyDiscTypeFields : string;
begin
  Result := GetDBColumnName('EXSTKCHK.dat', 'rec_mfix', '') + ',' + 
            GetDBColumnName('EXSTKCHK.dat', 'sub_type', '') + ',' + 
            GetDBColumnName('EXSTKCHK.dat', 'exstchk_var1', '') + ',' + 
            GetDBColumnName('EXSTKCHK.dat', 'exstchk_var2', '') + ',' + 
            GetDBColumnName('EXSTKCHK.dat', 'exstchk_var3', '') + ',' + 
            GetDBColumnName('EXSTKCHK.dat', 'fqb', 'D*') + ',' + 
            GetDBColumnName('EXSTKCHK.dat', 'tqb', 'D*') + ',' + 
            GetDBColumnName('EXSTKCHK.dat', 'qb_type', 'D*') + ',' + 
            GetDBColumnName('EXSTKCHK.dat', 'qb_curr', 'D*') + ',' + 
            GetDBColumnName('EXSTKCHK.dat', 'qs_price', 'D*') + ',' + 
            GetDBColumnName('EXSTKCHK.dat', 'q_band', 'D*') + ',' + 
            GetDBColumnName('EXSTKCHK.dat', 'qdisc_p', 'D*') + ',' + 
            GetDBColumnName('EXSTKCHK.dat', 'qdisc_a', 'D*') + ',' + 
            GetDBColumnName('EXSTKCHK.dat', 'qmumg', 'D*') + ',' + 
            GetDBColumnName('EXSTKCHK.dat', 'q_stk_folio', 'D*') + ',' + 
            GetDBColumnName('EXSTKCHK.dat', 'qc_code', 'D*') + ',' + 
            GetDBColumnName('EXSTKCHK.dat', 'spare1', 'D*') + ',' + 
            GetDBColumnName('EXSTKCHK.dat', 'quse_dates', 'D*') + ',' + 
            GetDBColumnName('EXSTKCHK.dat', 'qstart_d', 'D*') + ',' + 
            GetDBColumnName('EXSTKCHK.dat', 'qend_d', 'D*') ;
end;
  
function GetAllBacsSTypeFields : string;
begin
  Result := GetDBColumnName('EXSTKCHK.dat', 'rec_mfix', '') + ',' + 
            GetDBColumnName('EXSTKCHK.dat', 'sub_type', '') + ',' + 
            GetDBColumnName('EXSTKCHK.dat', 'exstchk_var1', '') + ',' + 
            GetDBColumnName('EXSTKCHK.dat', 'exstchk_var2', '') + ',' + 
            GetDBColumnName('EXSTKCHK.dat', 'exstchk_var3', '') + ',' + 
            GetDBColumnName('EXSTKCHK.dat', 'tag_run_no', 'XS') + ',' + 
            GetDBColumnName('EXSTKCHK.dat', 'tag_cust_code', 'XS') + ',' + 
            GetDBColumnName('EXSTKCHK.dat', 'total_os1', 'XS') + ',' + 
            GetDBColumnName('EXSTKCHK.dat', 'total_os2', 'XS') + ',' + 
            GetDBColumnName('EXSTKCHK.dat', 'total_os3', 'XS') + ',' + 
            GetDBColumnName('EXSTKCHK.dat', 'total_os4', 'XS') + ',' + 
            GetDBColumnName('EXSTKCHK.dat', 'total_os5', 'XS') + ',' + 
            GetDBColumnName('EXSTKCHK.dat', 'total_tagged1', 'XS') + ',' + 
            GetDBColumnName('EXSTKCHK.dat', 'total_tagged2', 'XS') + ',' + 
            GetDBColumnName('EXSTKCHK.dat', 'total_tagged3', 'XS') + ',' + 
            GetDBColumnName('EXSTKCHK.dat', 'total_tagged4', 'XS') + ',' + 
            GetDBColumnName('EXSTKCHK.dat', 'total_tagged5', 'XS') + ',' + 
            GetDBColumnName('EXSTKCHK.dat', 'has_tagged1', 'XS') + ',' + 
            GetDBColumnName('EXSTKCHK.dat', 'has_tagged2', 'XS') + ',' + 
            GetDBColumnName('EXSTKCHK.dat', 'has_tagged3', 'XS') + ',' + 
            GetDBColumnName('EXSTKCHK.dat', 'has_tagged4', 'XS') + ',' + 
            GetDBColumnName('EXSTKCHK.dat', 'has_tagged5', 'XS') + ',' + 
            GetDBColumnName('EXSTKCHK.dat', 'tag_bal', 'XS') + ',' + 
            GetDBColumnName('EXSTKCHK.dat', 'sales_cust', 'XS') + ',' + 
            GetDBColumnName('EXSTKCHK.dat', 'total_ex1', 'XS') + ',' + 
            GetDBColumnName('EXSTKCHK.dat', 'total_ex2', 'XS') + ',' + 
            GetDBColumnName('EXSTKCHK.dat', 'total_ex3', 'XS') + ',' + 
            GetDBColumnName('EXSTKCHK.dat', 'total_ex4', 'XS') + ',' + 
            GetDBColumnName('EXSTKCHK.dat', 'total_ex5', 'XS') ;
end;
  
function GetAllSerialTypeFields : string;
begin
  Result := GetDBColumnName('EXSTKCHK.dat', 'rec_mfix', '') + ',' + 
            GetDBColumnName('EXSTKCHK.dat', 'sub_type', '') + ',' + 
            GetDBColumnName('EXSTKCHK.dat', 'exstchk_var1', '') + ',' + 
            GetDBColumnName('EXSTKCHK.dat', 'exstchk_var2', '') + ',' + 
            GetDBColumnName('EXSTKCHK.dat', 'exstchk_var3', '') + ',' + 
            GetDBColumnName('EXSTKCHK.dat', 'in_doc', 'FR') + ',' + 
            GetDBColumnName('EXSTKCHK.dat', 'out_doc', 'FR') + ',' + 
            GetDBColumnName('EXSTKCHK.dat', 'sold', 'FR') + ',' + 
            GetDBColumnName('EXSTKCHK.dat', 'date_in', 'FR') + ',' + 
            GetDBColumnName('EXSTKCHK.dat', 'ser_cost', 'FR') + ',' + 
            GetDBColumnName('EXSTKCHK.dat', 'ser_sell', 'FR') + ',' + 
            GetDBColumnName('EXSTKCHK.dat', 'stk_folio', 'FR') + ',' + 
            GetDBColumnName('EXSTKCHK.dat', 'date_out', 'FR') + ',' + 
            GetDBColumnName('EXSTKCHK.dat', 'sold_line', 'FR') + ',' + 
            GetDBColumnName('EXSTKCHK.dat', 'cur_cost', 'FR') + ',' + 
            GetDBColumnName('EXSTKCHK.dat', 'cur_sell', 'FR') + ',' + 
            GetDBColumnName('EXSTKCHK.dat', 'buy_line', 'FR') + ',' + 
            GetDBColumnName('EXSTKCHK.dat', 'batch_rec', 'FR') + ',' + 
            GetDBColumnName('EXSTKCHK.dat', 'buy_qty', 'FR') + ',' + 
            GetDBColumnName('EXSTKCHK.dat', 'qty_used', 'FR') + ',' + 
            GetDBColumnName('EXSTKCHK.dat', 'batch_child', 'FR') + ',' + 
            GetDBColumnName('EXSTKCHK.dat', 'in_mloc', 'FR') + ',' + 
            GetDBColumnName('EXSTKCHK.dat', 'out_mloc', 'FR') + ',' + 
            GetDBColumnName('EXSTKCHK.dat', 'ser_c_rates1', 'FR') + ',' + 
            GetDBColumnName('EXSTKCHK.dat', 'ser_c_rates2', 'FR') + ',' + 
            GetDBColumnName('EXSTKCHK.dat', 'in_ord_doc', 'FR') + ',' + 
            GetDBColumnName('EXSTKCHK.dat', 'out_ord_doc', 'FR') + ',' + 
            GetDBColumnName('EXSTKCHK.dat', 'in_ord_line', 'FR') + ',' + 
            GetDBColumnName('EXSTKCHK.dat', 'out_ord_line', 'FR') + ',' + 
            GetDBColumnName('EXSTKCHK.dat', 'n_line_count', 'FR') + ',' + 
            GetDBColumnName('EXSTKCHK.dat', 'note_folio', 'FR') + ',' + 
            GetDBColumnName('EXSTKCHK.dat', 'date_use_x', 'FR') + ',' + 
            GetDBColumnName('EXSTKCHK.dat', 'suse_o_rate', 'FR') + ',' + 
            GetDBColumnName('EXSTKCHK.dat', 'tri_rates', 'FR') + ',' + 
            GetDBColumnName('EXSTKCHK.dat', 'tri_euro', 'FR') + ',' + 
            GetDBColumnName('EXSTKCHK.dat', 'tri_invert', 'FR') + ',' + 
            GetDBColumnName('EXSTKCHK.dat', 'tri_float', 'FR') + ',' + 
            GetDBColumnName('EXSTKCHK.dat', 'spare2', 'FR') + ',' + 
            GetDBColumnName('EXSTKCHK.dat', 'child_n_folio', 'FR') + ',' + 
            GetDBColumnName('EXSTKCHK.dat', 'in_bin_code', 'FR') + ',' + 
            GetDBColumnName('EXSTKCHK.dat', 'return_sno', 'FR') + ',' + 
            GetDBColumnName('EXSTKCHK.dat', 'batch_ret_qty', 'FR') + ',' + 
            GetDBColumnName('EXSTKCHK.dat', 'ret_doc', 'FR') + ',' + 
            GetDBColumnName('EXSTKCHK.dat', 'ret_doc_line', 'FR') ;
end;
  
function GetAllBankMTypeFields : string;
begin
  Result := GetDBColumnName('EXSTKCHK.dat', 'rec_mfix', '') + ',' + 
            GetDBColumnName('EXSTKCHK.dat', 'sub_type', '') + ',' + 
            GetDBColumnName('EXSTKCHK.dat', 'exstchk_var1', '') + ',' + 
            GetDBColumnName('EXSTKCHK.dat', 'exstchk_var2', '') + ',' + 
            GetDBColumnName('EXSTKCHK.dat', 'exstchk_var3', '') + ',' + 
            GetDBColumnName('EXSTKCHK.dat', 'bank_ref', 'ME') + ',' + 
            GetDBColumnName('EXSTKCHK.dat', 'bank_value', 'ME') + ',' + 
            GetDBColumnName('EXSTKCHK.dat', 'match_doc', 'ME') + ',' + 
            GetDBColumnName('EXSTKCHK.dat', 'match_folio', 'ME') + ',' + 
            GetDBColumnName('EXSTKCHK.dat', 'match_line', 'ME') + ',' + 
            GetDBColumnName('EXSTKCHK.dat', 'bank_nom', 'ME') + ',' + 
            GetDBColumnName('EXSTKCHK.dat', 'bank_cr', 'ME') + ',' + 
            GetDBColumnName('EXSTKCHK.dat', 'entry_opo', 'ME') + ',' + 
            GetDBColumnName('EXSTKCHK.dat', 'entry_date', 'ME') + ',' + 
            GetDBColumnName('EXSTKCHK.dat', 'entry_stat', 'ME') + ',' + 
            GetDBColumnName('EXSTKCHK.dat', 'use_pay_in', 'ME') + ',' + 
            GetDBColumnName('EXSTKCHK.dat', 'match_addr', 'ME') + ',' + 
            GetDBColumnName('EXSTKCHK.dat', 'match_run_no', 'ME') + ',' + 
            GetDBColumnName('EXSTKCHK.dat', 'tagged', 'ME') + ',' + 
            GetDBColumnName('EXSTKCHK.dat', 'match_date', 'ME') + ',' + 
            GetDBColumnName('EXSTKCHK.dat', 'match_abs_line', 'ME') ;
end;
  
function GetAllBtCustomTypeFields : string;
begin
  Result := GetDBColumnName('EXSTKCHK.dat', 'rec_mfix', '') + ',' + 
            GetDBColumnName('EXSTKCHK.dat', 'sub_type', '') + ',' + 
            GetDBColumnName('EXSTKCHK.dat', 'exstchk_var1', '') + ',' + 
            GetDBColumnName('EXSTKCHK.dat', 'exstchk_var2', '') + ',' + 
            GetDBColumnName('EXSTKCHK.dat', 'exstchk_var3', '') + ',' + 
            GetDBColumnName('EXSTKCHK.dat', 'bkg_color', 'UC') + ',' + 
            GetDBColumnName('EXSTKCHK.dat', 'font_name', 'UC') + ',' + 
            GetDBColumnName('EXSTKCHK.dat', 'font_size', 'UC') + ',' + 
            GetDBColumnName('EXSTKCHK.dat', 'font_color', 'UC') + ',' + 
            GetDBColumnName('EXSTKCHK.dat', 'font_style', 'UC') + ',' + 
            GetDBColumnName('EXSTKCHK.dat', 'font_pitch', 'UC') + ',' + 
            GetDBColumnName('EXSTKCHK.dat', 'font_height', 'UC') + ',' + 
            GetDBColumnName('EXSTKCHK.dat', 'last_col_order', 'UC') + ',' + 
            GetDBColumnName('EXSTKCHK.dat', 'position', 'UC') + ',' + 
            GetDBColumnName('EXSTKCHK.dat', 'comp_name', 'UC') + ',' + 
            GetDBColumnName('EXSTKCHK.dat', 'user_name', 'UC') + ',' + 
            GetDBColumnName('EXSTKCHK.dat', 'high_light', 'UC') + ',' + 
            GetDBColumnName('EXSTKCHK.dat', 'high_text', 'UC') ;
end;
  
function GetAllBtLetterLinkTypeFields : string;
begin
  Result := GetDBColumnName('EXSTKCHK.dat', 'rec_mfix', '') + ',' + 
            GetDBColumnName('EXSTKCHK.dat', 'sub_type', '') + ',' + 
            GetDBColumnName('EXSTKCHK.dat', 'exstchk_var1', '') + ',' + 
            GetDBColumnName('EXSTKCHK.dat', 'exstchk_var2', '') + ',' + 
            GetDBColumnName('EXSTKCHK.dat', 'exstchk_var3', '') + ',' + 
            GetDBColumnName('EXSTKCHK.dat', 'acc_code', 'W*') + ',' + 
            GetDBColumnName('EXSTKCHK.dat', 'letterlinkdata1', 'W*') + ',' + 
            GetDBColumnName('EXSTKCHK.dat', 'version', 'W*') + ',' + 
            GetDBColumnName('EXSTKCHK.dat', 'letterlinkdata2', 'W*') + ',' + 
            GetDBColumnName('EXSTKCHK.dat', 'letterlinkspare', 'W*') ;
end;
  
function GetAllAllocSTypeFields : string;
begin
  Result := GetDBColumnName('EXSTKCHK.dat', 'rec_mfix', '') + ',' + 
            GetDBColumnName('EXSTKCHK.dat', 'sub_type', '') + ',' + 
            GetDBColumnName('EXSTKCHK.dat', 'exstchk_var1', '') + ',' + 
            GetDBColumnName('EXSTKCHK.dat', 'exstchk_var2', '') + ',' + 
            GetDBColumnName('EXSTKCHK.dat', 'exstchk_var3', '') + ',' + 
            GetDBColumnName('EXSTKCHK.dat', 'ari_cust_code', 'XA') + ',' + 
            GetDBColumnName('EXSTKCHK.dat', 'ari_cust_supp', 'XA') + ',' + 
            GetDBColumnName('EXSTKCHK.dat', 'ari_our_ref', 'XA') + ',' + 
            GetDBColumnName('EXSTKCHK.dat', 'ari_old_your_ref', 'XA') + ',' + 
            GetDBColumnName('EXSTKCHK.dat', 'ari_due_date', 'XA') + ',' + 
            GetDBColumnName('EXSTKCHK.dat', 'ari_trans_date', 'XA') + ',' + 
            GetDBColumnName('EXSTKCHK.dat', 'ari_orig_val', 'XA') + ',' + 
            GetDBColumnName('EXSTKCHK.dat', 'ari_orig_curr', 'XA') + ',' + 
            GetDBColumnName('EXSTKCHK.dat', 'ari_base_equiv', 'XA') + ',' + 
            GetDBColumnName('EXSTKCHK.dat', 'ari_orig_settle', 'XA') + ',' + 
            GetDBColumnName('EXSTKCHK.dat', 'ari_orig_oc_settle', 'XA') + ',' + 
            GetDBColumnName('EXSTKCHK.dat', 'ari_settle', 'XA') + ',' + 
            GetDBColumnName('EXSTKCHK.dat', 'ari_cx_rate1', 'XA') + ',' + 
            GetDBColumnName('EXSTKCHK.dat', 'ari_cx_rate2', 'XA') + ',' + 
            GetDBColumnName('EXSTKCHK.dat', 'ari_set_disc', 'XA') + ',' + 
            GetDBColumnName('EXSTKCHK.dat', 'ari_variance', 'XA') + ',' + 
            GetDBColumnName('EXSTKCHK.dat', 'ari_orig_set_disc', 'XA') + ',' + 
            GetDBColumnName('EXSTKCHK.dat', 'ari_outstanding', 'XA') + ',' + 
            GetDBColumnName('EXSTKCHK.dat', 'ari_curr_os', 'XA') + ',' + 
            GetDBColumnName('EXSTKCHK.dat', 'ari_settle_own', 'XA') + ',' + 
            GetDBColumnName('EXSTKCHK.dat', 'ari_base_os', 'XA') + ',' + 
            GetDBColumnName('EXSTKCHK.dat', 'ari_disc_or', 'XA') + ',' + 
            GetDBColumnName('EXSTKCHK.dat', 'ari_own_disc_or', 'XA') + ',' + 
            GetDBColumnName('EXSTKCHK.dat', 'ari_doc_type', 'XA') + ',' + 
            GetDBColumnName('EXSTKCHK.dat', 'ari_tag_mode', 'XA') + ',' + 
            GetDBColumnName('EXSTKCHK.dat', 'ari_reval_adj', 'XA') + ',' + 
            GetDBColumnName('EXSTKCHK.dat', 'ari_orig_reval_adj', 'XA') + ',' + 
            GetDBColumnName('EXSTKCHK.dat', 'spare3', 'XA') + ',' + 
            GetDBColumnName('EXSTKCHK.dat', 'ari_your_ref', 'XA') ;
end;
  
function GetAllRtLReasonTypeFields : string;
begin
  Result := GetDBColumnName('EXSTKCHK.dat', 'rec_mfix', '') + ',' + 
            GetDBColumnName('EXSTKCHK.dat', 'sub_type', '') + ',' + 
            GetDBColumnName('EXSTKCHK.dat', 'exstchk_var1', '') + ',' + 
            GetDBColumnName('EXSTKCHK.dat', 'exstchk_var2', '') + ',' + 
            GetDBColumnName('EXSTKCHK.dat', 'exstchk_var3', '') + ',' + 
            GetDBColumnName('EXSTKCHK.dat', 'reason_desc', 'R1') + ',' + 
            GetDBColumnName('EXSTKCHK.dat', 'reason_count', 'R1') ;
end;
  
function GetAllB2BInpRecFields : string;
begin
  Result := GetDBColumnName('EXSTKCHK.dat', 'rec_mfix', '') + ',' + 
            GetDBColumnName('EXSTKCHK.dat', 'sub_type', '') + ',' + 
            GetDBColumnName('EXSTKCHK.dat', 'exstchk_var1', '') + ',' + 
            GetDBColumnName('EXSTKCHK.dat', 'exstchk_var2', '') + ',' + 
            GetDBColumnName('EXSTKCHK.dat', 'exstchk_var3', '') + ',' + 
            GetDBColumnName('EXSTKCHK.dat', 'spare4', 'A2') + ',' + 
            GetDBColumnName('EXSTKCHK.dat', 'MultiMode', 'A2') + ',' + 
            GetDBColumnName('EXSTKCHK.dat', 'ExcludeBOM', 'A2') + ',' + 
            GetDBColumnName('EXSTKCHK.dat', 'UseOnOrder', 'A2') + ',' + 
            GetDBColumnName('EXSTKCHK.dat', 'IncludeLT', 'A2') + ',' + 
            GetDBColumnName('EXSTKCHK.dat', 'ExcludeLT', 'A2') + ',' + 
            GetDBColumnName('EXSTKCHK.dat', 'QtyMode', 'A2') + ',' + 
            GetDBColumnName('EXSTKCHK.dat', 'SuppCode', 'A2') + ',' + 
            GetDBColumnName('EXSTKCHK.dat', 'LocOR', 'A2') + ',' + 
            GetDBColumnName('EXSTKCHK.dat', 'AutoPick', 'A2') + ',' + 
            GetDBColumnName('EXSTKCHK.dat', 'GenOrder', 'A2') + ',' + 
            GetDBColumnName('EXSTKCHK.dat', 'PORBOMMode', 'A2') + ',' + 
            GetDBColumnName('EXSTKCHK.dat', 'WORBOMCode', 'A2') + ',' + 
            GetDBColumnName('EXSTKCHK.dat', 'WORRef', 'A2') + ',' + 
            GetDBColumnName('EXSTKCHK.dat', 'LocIR', 'A2') + ',' + 
            GetDBColumnName('EXSTKCHK.dat', 'BuildQty', 'A2') + ',' + 
            GetDBColumnName('EXSTKCHK.dat', 'BWOQty', 'A2') + ',' + 
            GetDBColumnName('EXSTKCHK.dat', 'LessFStk', 'A2') + ',' + 
            GetDBColumnName('EXSTKCHK.dat', 'AutoSetChild', 'A2') + ',' + 
            GetDBColumnName('EXSTKCHK.dat', 'ShowDoc', 'A2') + ',' + 
            GetDBColumnName('EXSTKCHK.dat', 'CopyStkNote', 'A2') + ',' + 
            GetDBColumnName('EXSTKCHK.dat', 'UseDefLoc', 'A2') + ',' + 
            GetDBColumnName('EXSTKCHK.dat', 'UseDefCCDep', 'A2') + ',' + 
            GetDBColumnName('EXSTKCHK.dat', 'WORTagNo', 'A2') + ',' + 
            GetDBColumnName('EXSTKCHK.dat', 'DefCCDep1', 'A2') + ',' + 
            GetDBColumnName('EXSTKCHK.dat', 'DefCCDep2', 'A2') + ',' + 
            GetDBColumnName('EXSTKCHK.dat', 'WCompDate', 'A2') + ',' + 
            GetDBColumnName('EXSTKCHK.dat', 'WStartDate', 'A2') + ',' + 
            GetDBColumnName('EXSTKCHK.dat', 'KeepLDates', 'A2') + ',' + 
            GetDBColumnName('EXSTKCHK.dat', 'CopySORUDF', 'A2') + ',' + 
            GetDBColumnName('EXSTKCHK.dat', 'LessA2WOR', 'A2') + ',' + 
            GetDBColumnName('EXSTKCHK.dat', 'spare5', 'A2') + ',' + 
            GetDBColumnName('EXSTKCHK.dat', 'inp_loaded', 'A2') ;
end;
  
function GetAllB2BLineRecFields : string;
begin
  Result := GetDBColumnName('EXSTKCHK.dat', 'rec_mfix', '') + ',' + 
            GetDBColumnName('EXSTKCHK.dat', 'sub_type', '') + ',' + 
            GetDBColumnName('EXSTKCHK.dat', 'exstchk_var1', '') + ',' + 
            GetDBColumnName('EXSTKCHK.dat', 'exstchk_var2', '') + ',' + 
            GetDBColumnName('EXSTKCHK.dat', 'exstchk_var3', '') + ',' + 
            GetDBColumnName('EXSTKCHK.dat', 'spare6', 'AL') + ',' + 
            GetDBColumnName('EXSTKCHK.dat', 'OrderFolio', 'AL') + ',' + 
            GetDBColumnName('EXSTKCHK.dat', 'OrderLineNo', 'AL') + ',' + 
            GetDBColumnName('EXSTKCHK.dat', 'LineSCode', 'AL') + ',' + 
            GetDBColumnName('EXSTKCHK.dat', 'DelLineAfter', 'AL') + ',' + 
            GetDBColumnName('EXSTKCHK.dat', 'UseKPath', 'AL') + ',' + 
            GetDBColumnName('EXSTKCHK.dat', 'OrderLinePos', 'AL') + ',' + 
            GetDBColumnName('EXSTKCHK.dat', 'OrderABSLine', 'AL') + ',' + 
            GetDBColumnName('EXSTKCHK.dat', 'OrderLineAddr', 'AL') + ',' + 
            GetDBColumnName('EXSTKCHK.dat', 'spare7', 'AL') + ',' + 
            GetDBColumnName('EXSTKCHK.dat', 'line_loaded', 'AL') ;
end;
  
function GetAllFaxesFields : string;
begin
  Result := GetDBColumnName('Faxes.dat', 'f_prefix', '') + ',' + 
            GetDBColumnName('Faxes.dat', 'f_code1', '') + ',' + 
            GetDBColumnName('Faxes.dat', 'f_code2', '') + ',' + 
            GetDBColumnName('Faxes.dat', 'f_code3', '') ;
end;
  
function GetAllFormsFields : string;
begin
  Result := GetDBColumnName('Forms.dat', 'f_field_1', '') + ',' + 
            GetDBColumnName('Forms.dat', 'f_field_2', '') ;
end;
  
function GetAllGroupcmpFields : string;
begin
  Result := GetDBColumnName('Groupcmp.dat', 'f_gc_group_code', '') + ',' + 
            GetDBColumnName('Groupcmp.dat', 'f_gc_company_code', '') ;
end;
  
function GetAllGroupsFields : string;
begin
  Result := GetDBColumnName('Groups.dat', 'f_gr_group_code', '') + ',' + 
            GetDBColumnName('Groups.dat', 'f_gr_group_name', '') ;
end;
  
function GetAllGroupusrFields : string;
begin
  Result := GetDBColumnName('Groupusr.dat', 'f_gu_group_code', '') + ',' + 
            GetDBColumnName('Groupusr.dat', 'f_gu_user_code', '') + ',' + 
            GetDBColumnName('Groupusr.dat', 'f_gu_user_name', '') + ',' + 
            GetDBColumnName('Groupusr.dat', 'f_gu_password', '') + ',' + 
            GetDBColumnName('Groupusr.dat', 'f_gu_permissions', '') ;
end;
  
function GetAllHistoryFields : string;
begin
  Result := GetDBColumnName('History.dat', 'f_code', '') + ',' + 
            GetDBColumnName('History.dat', 'f_ex_class', '') + ',' + 
            GetDBColumnName('History.dat', 'f_cr', '') + ',' + 
            GetDBColumnName('History.dat', 'f_yr', '') + ',' + 
            GetDBColumnName('History.dat', 'f_pr', '') + ',' + 
            GetDBColumnName('History.dat', 'f_sales', '') + ',' + 
            GetDBColumnName('History.dat', 'f_purchases', '') + ',' + 
            GetDBColumnName('History.dat', 'f_budget', '') + ',' + 
            GetDBColumnName('History.dat', 'f_cleared', '') + ',' + 
            GetDBColumnName('History.dat', 'f_budget2', '') + ',' + 
            GetDBColumnName('History.dat', 'f_value1', '') + ',' + 
            GetDBColumnName('History.dat', 'f_value2', '') + ',' + 
            GetDBColumnName('History.dat', 'f_value3', '') + ',' + 
            GetDBColumnName('History.dat', 'f_spare_v1', '') + ',' + 
            GetDBColumnName('History.dat', 'f_spare_v2', '') + ',' + 
            GetDBColumnName('History.dat', 'f_spare_v3', '') + ',' + 
            GetDBColumnName('History.dat', 'f_spare_v4', '') + ',' + 
            GetDBColumnName('History.dat', 'f_spare_v5', '') ;
end;
  
function GetAllImportjobFields : string;
begin
  Result := GetDBColumnName('Importjob.dat', 'f_field_1', '') + ',' + 
            GetDBColumnName('Importjob.dat', 'f_field_2', '') ;
end;
  
function GetAllJobBudgJBFields : string;
begin
  Result := GetDBColumnName('Jobctrl.dat', 'rec_pfix', '') + ',' + 
            GetDBColumnName('Jobctrl.dat', 'sub_type', '') + ',' + 
            GetDBColumnName('Jobctrl.dat', 'var_code1', '') + ',' + 
            GetDBColumnName('Jobctrl.dat', 'spare', '') + ',' + 
            GetDBColumnName('Jobctrl.dat', 'var_code2', '') + ',' + 
            GetDBColumnName('Jobctrl.dat', 'anal_code', 'JB') + ',' + 
            GetDBColumnName('Jobctrl.dat', 'hist_folio', 'JB') + ',' + 
            GetDBColumnName('Jobctrl.dat', 'job_code', 'JB') + ',' + 
            GetDBColumnName('Jobctrl.dat', 'stock_code', 'JB') + ',' + 
            GetDBColumnName('Jobctrl.dat', 'b_type', 'JB') + ',' + 
            GetDBColumnName('Jobctrl.dat', 're_charge', 'JB') + ',' + 
            GetDBColumnName('Jobctrl.dat', 'over_cost', 'JB') + ',' + 
            GetDBColumnName('Jobctrl.dat', 'unit_price', 'JB') + ',' + 
            GetDBColumnName('Jobctrl.dat', 'bo_qty', 'JB') + ',' + 
            GetDBColumnName('Jobctrl.dat', 'br_qty', 'JB') + ',' + 
            GetDBColumnName('Jobctrl.dat', 'bo_value', 'JB') + ',' + 
            GetDBColumnName('Jobctrl.dat', 'br_value', 'JB') + ',' + 
            GetDBColumnName('Jobctrl.dat', 'curr_budg', 'JB') + ',' + 
            GetDBColumnName('Jobctrl.dat', 'pay_r_mode', 'JB') + ',' + 
            GetDBColumnName('Jobctrl.dat', 'curr_p_type', 'JB') + ',' + 
            GetDBColumnName('Jobctrl.dat', 'anal_hed', 'JB') + ',' + 
            GetDBColumnName('Jobctrl.dat', 'orig_valuation', 'JB') + ',' + 
            GetDBColumnName('Jobctrl.dat', 'rev_valuation', 'JB') + ',' + 
            GetDBColumnName('Jobctrl.dat', 'jb_uplift_p', 'JB') + ',' + 
            GetDBColumnName('Jobctrl.dat', 'ja_pcnt_app', 'JB') + ',' + 
            GetDBColumnName('Jobctrl.dat', 'ja_b_basis', 'JB') + ',' + 
            GetDBColumnName('Jobctrl.dat', 'jbudget_curr', 'JB') ;
end;
  
function GetAllJobBudgJMFields : string;
begin
  Result := GetDBColumnName('Jobctrl.dat', 'rec_pfix', '') + ',' + 
            GetDBColumnName('Jobctrl.dat', 'sub_type', '') + ',' + 
            GetDBColumnName('Jobctrl.dat', 'var_code1', '') + ',' + 
            GetDBColumnName('Jobctrl.dat', 'spare', '') + ',' + 
            GetDBColumnName('Jobctrl.dat', 'var_code2', '') + ',' + 
            GetDBColumnName('Jobctrl.dat', 'anal_code', 'JM') + ',' + 
            GetDBColumnName('Jobctrl.dat', 'hist_folio', 'JM') + ',' + 
            GetDBColumnName('Jobctrl.dat', 'job_code', 'JM') + ',' + 
            GetDBColumnName('Jobctrl.dat', 'stock_code', 'JM') + ',' + 
            GetDBColumnName('Jobctrl.dat', 'b_type', 'JM') + ',' + 
            GetDBColumnName('Jobctrl.dat', 're_charge', 'JM') + ',' + 
            GetDBColumnName('Jobctrl.dat', 'over_cost', 'JM') + ',' + 
            GetDBColumnName('Jobctrl.dat', 'unit_price', 'JM') + ',' + 
            GetDBColumnName('Jobctrl.dat', 'bo_qty', 'JM') + ',' + 
            GetDBColumnName('Jobctrl.dat', 'br_qty', 'JM') + ',' + 
            GetDBColumnName('Jobctrl.dat', 'bo_value', 'JM') + ',' + 
            GetDBColumnName('Jobctrl.dat', 'br_value', 'JM') + ',' + 
            GetDBColumnName('Jobctrl.dat', 'curr_budg', 'JM') + ',' + 
            GetDBColumnName('Jobctrl.dat', 'pay_r_mode', 'JM') + ',' + 
            GetDBColumnName('Jobctrl.dat', 'curr_p_type', 'JM') + ',' + 
            GetDBColumnName('Jobctrl.dat', 'anal_hed', 'JM') + ',' + 
            GetDBColumnName('Jobctrl.dat', 'orig_valuation', 'JM') + ',' + 
            GetDBColumnName('Jobctrl.dat', 'rev_valuation', 'JM') + ',' + 
            GetDBColumnName('Jobctrl.dat', 'jb_uplift_p', 'JM') + ',' + 
            GetDBColumnName('Jobctrl.dat', 'ja_pcnt_app', 'JM') + ',' + 
            GetDBColumnName('Jobctrl.dat', 'ja_b_basis', 'JM') + ',' + 
            GetDBColumnName('Jobctrl.dat', 'jbudget_curr', 'JM') ;
end;
  
function GetAllJobBudgJSFields : string;
begin
  Result := GetDBColumnName('Jobctrl.dat', 'rec_pfix', '') + ',' + 
            GetDBColumnName('Jobctrl.dat', 'sub_type', '') + ',' + 
            GetDBColumnName('Jobctrl.dat', 'var_code1', '') + ',' + 
            GetDBColumnName('Jobctrl.dat', 'spare', '') + ',' + 
            GetDBColumnName('Jobctrl.dat', 'var_code2', '') + ',' + 
            GetDBColumnName('Jobctrl.dat', 'anal_code', 'JS') + ',' + 
            GetDBColumnName('Jobctrl.dat', 'hist_folio', 'JS') + ',' + 
            GetDBColumnName('Jobctrl.dat', 'job_code', 'JS') + ',' + 
            GetDBColumnName('Jobctrl.dat', 'stock_code', 'JS') + ',' + 
            GetDBColumnName('Jobctrl.dat', 'b_type', 'JS') + ',' + 
            GetDBColumnName('Jobctrl.dat', 're_charge', 'JS') + ',' + 
            GetDBColumnName('Jobctrl.dat', 'over_cost', 'JS') + ',' + 
            GetDBColumnName('Jobctrl.dat', 'unit_price', 'JS') + ',' + 
            GetDBColumnName('Jobctrl.dat', 'bo_qty', 'JS') + ',' + 
            GetDBColumnName('Jobctrl.dat', 'br_qty', 'JS') + ',' + 
            GetDBColumnName('Jobctrl.dat', 'bo_value', 'JS') + ',' + 
            GetDBColumnName('Jobctrl.dat', 'br_value', 'JS') + ',' + 
            GetDBColumnName('Jobctrl.dat', 'curr_budg', 'JS') + ',' + 
            GetDBColumnName('Jobctrl.dat', 'pay_r_mode', 'JS') + ',' + 
            GetDBColumnName('Jobctrl.dat', 'curr_p_type', 'JS') + ',' + 
            GetDBColumnName('Jobctrl.dat', 'anal_hed', 'JS') + ',' + 
            GetDBColumnName('Jobctrl.dat', 'orig_valuation', 'JS') + ',' + 
            GetDBColumnName('Jobctrl.dat', 'rev_valuation', 'JS') + ',' + 
            GetDBColumnName('Jobctrl.dat', 'jb_uplift_p', 'JS') + ',' + 
            GetDBColumnName('Jobctrl.dat', 'ja_pcnt_app', 'JS') + ',' + 
            GetDBColumnName('Jobctrl.dat', 'ja_b_basis', 'JS') + ',' + 
            GetDBColumnName('Jobctrl.dat', 'jbudget_curr', 'JS') ;
end;
  
function GetAllEmplPayJEFields : string;
begin
  Result := GetDBColumnName('Jobctrl.dat', 'rec_pfix', '') + ',' + 
            GetDBColumnName('Jobctrl.dat', 'sub_type', '') + ',' + 
            GetDBColumnName('Jobctrl.dat', 'var_code1', '') + ',' + 
            GetDBColumnName('Jobctrl.dat', 'spare', '') + ',' + 
            GetDBColumnName('Jobctrl.dat', 'var_code2', '') + ',' + 
            GetDBColumnName('Jobctrl.dat', 'e_anal_code', 'JE') + ',' + 
            GetDBColumnName('Jobctrl.dat', 'emp_code', 'JE') + ',' + 
            GetDBColumnName('Jobctrl.dat', 'e_stock_code', 'JE') + ',' + 
            GetDBColumnName('Jobctrl.dat', 'pay_r_desc', 'JE') + ',' + 
            GetDBColumnName('Jobctrl.dat', 'cost', 'JE') + ',' + 
            GetDBColumnName('Jobctrl.dat', 'charge_out', 'JE') + ',' + 
            GetDBColumnName('Jobctrl.dat', 'cost_curr', 'JE') + ',' + 
            GetDBColumnName('Jobctrl.dat', 'charge_curr', 'JE') + ',' + 
            GetDBColumnName('Jobctrl.dat', 'pay_r_fact', 'JE') + ',' + 
            GetDBColumnName('Jobctrl.dat', 'pay_r_rate', 'JE') ;
end;
  
function GetAllEmplPayJRFields : string;
begin
  Result := GetDBColumnName('Jobctrl.dat', 'rec_pfix', '') + ',' + 
            GetDBColumnName('Jobctrl.dat', 'sub_type', '') + ',' + 
            GetDBColumnName('Jobctrl.dat', 'var_code1', '') + ',' + 
            GetDBColumnName('Jobctrl.dat', 'spare', '') + ',' + 
            GetDBColumnName('Jobctrl.dat', 'var_code2', '') + ',' + 
            GetDBColumnName('Jobctrl.dat', 'e_anal_code', 'JR') + ',' + 
            GetDBColumnName('Jobctrl.dat', 'emp_code', 'JR') + ',' + 
            GetDBColumnName('Jobctrl.dat', 'e_stock_code', 'JR') + ',' + 
            GetDBColumnName('Jobctrl.dat', 'pay_r_desc', 'JR') + ',' + 
            GetDBColumnName('Jobctrl.dat', 'cost', 'JR') + ',' + 
            GetDBColumnName('Jobctrl.dat', 'charge_out', 'JR') + ',' + 
            GetDBColumnName('Jobctrl.dat', 'cost_curr', 'JR') + ',' + 
            GetDBColumnName('Jobctrl.dat', 'charge_curr', 'JR') + ',' + 
            GetDBColumnName('Jobctrl.dat', 'pay_r_fact', 'JR') + ',' + 
            GetDBColumnName('Jobctrl.dat', 'pay_r_rate', 'JR') ;
end;
  
function GetAllJobActualFields : string;
begin
  Result := GetDBColumnName('JobDet.dat', 'rec_pfix', '') + ',' + 
            GetDBColumnName('JobDet.dat', 'sub_type', '') + ',' + 
            GetDBColumnName('JobDet.dat', 'var_code1', '') + ',' + 
            GetDBColumnName('JobDet.dat', 'var_code2', '') + ',' + 
            GetDBColumnName('JobDet.dat', 'var_code3', '') + ',' + 
            GetDBColumnName('JobDet.dat', 'var_code4', '') + ',' + 
            GetDBColumnName('JobDet.dat', 'var_code5', '') + ',' + 
            GetDBColumnName('JobDet.dat', 'var_code6', '') + ',' + 
            GetDBColumnName('JobDet.dat', 'var_code7', '') + ',' + 
            GetDBColumnName('JobDet.dat', 'var_code8', '') + ',' + 
            GetDBColumnName('JobDet.dat', 'var_code9', '') + ',' + 
            GetDBColumnName('JobDet.dat', 'var_code10', '') + ',' + 
            GetDBColumnName('JobDet.dat', 'posted', 'JE') + ',' + 
            GetDBColumnName('JobDet.dat', 'line_folio', 'JE') + ',' + 
            GetDBColumnName('JobDet.dat', 'line_no', 'JE') + ',' + 
            GetDBColumnName('JobDet.dat', 'line_o_ref', 'JE') + ',' + 
            GetDBColumnName('JobDet.dat', 'job_code', 'JE') + ',' + 
            GetDBColumnName('JobDet.dat', 'stock_code', 'JE') + ',' + 
            GetDBColumnName('JobDet.dat', 'j_date', 'JE') + ',' + 
            GetDBColumnName('JobDet.dat', 'qty', 'JE') + ',' + 
            GetDBColumnName('JobDet.dat', 'cost', 'JE') + ',' + 
            GetDBColumnName('JobDet.dat', 'charge', 'JE') + ',' + 
            GetDBColumnName('JobDet.dat', 'invoiced', 'JE') + ',' + 
            GetDBColumnName('JobDet.dat', 'inv_ref', 'JE') + ',' + 
            GetDBColumnName('JobDet.dat', 'empl_code', 'JE') + ',' + 
            GetDBColumnName('JobDet.dat', 'ja_type', 'JE') + ',' + 
            GetDBColumnName('JobDet.dat', 'posted_run', 'JE') + ',' + 
            GetDBColumnName('JobDet.dat', 'reverse', 'JE') + ',' + 
            GetDBColumnName('JobDet.dat', 'recon_ts', 'JE') + ',' + 
            GetDBColumnName('JobDet.dat', 'reversed', 'JE') + ',' + 
            GetDBColumnName('JobDet.dat', 'jddt', 'JE') + ',' + 
            GetDBColumnName('JobDet.dat', 'curr_charge', 'JE') + ',' + 
            GetDBColumnName('JobDet.dat', 'act_c_code', 'JE') + ',' + 
            GetDBColumnName('JobDet.dat', 'hold_flg', 'JE') + ',' + 
            GetDBColumnName('JobDet.dat', 'post2_stk', 'JE') + ',' + 
            GetDBColumnName('JobDet.dat', 'pc_rates1', 'JE') + ',' + 
            GetDBColumnName('JobDet.dat', 'pc_rates2', 'JE') + ',' + 
            GetDBColumnName('JobDet.dat', 'tagged', 'JE') + ',' + 
            GetDBColumnName('JobDet.dat', 'orig_n_code', 'JE') + ',' + 
            GetDBColumnName('JobDet.dat', 'j_use_o_rate', 'JE') + ',' + 
            GetDBColumnName('JobDet.dat', 'PC_tri_rates', 'JE') + ',' + 
            GetDBColumnName('JobDet.dat', 'PC_tri_euro', 'JE') + ',' + 
            GetDBColumnName('JobDet.dat', 'PC_tri_invert', 'JE') + ',' + 
            GetDBColumnName('JobDet.dat', 'PC_tri_float', 'JE') + ',' + 
            GetDBColumnName('JobDet.dat', 'PC_tri_spare', 'JE') + ',' + 
            GetDBColumnName('JobDet.dat', 'j_price_mulx', 'JE') + ',' + 
            GetDBColumnName('JobDet.dat', 'uplift_total', 'JE') + ',' + 
            GetDBColumnName('JobDet.dat', 'uplift_gl', 'JE') ;
end;
  
function GetAllJobRetenFields : string;
begin
  Result := GetDBColumnName('JobDet.dat', 'rec_pfix', '') + ',' + 
            GetDBColumnName('JobDet.dat', 'sub_type', '') + ',' + 
            GetDBColumnName('JobDet.dat', 'var_code1', '') + ',' + 
            GetDBColumnName('JobDet.dat', 'var_code2', '') + ',' + 
            GetDBColumnName('JobDet.dat', 'var_code3', '') + ',' + 
            GetDBColumnName('JobDet.dat', 'var_code4', '') + ',' + 
            GetDBColumnName('JobDet.dat', 'var_code5', '') + ',' + 
            GetDBColumnName('JobDet.dat', 'var_code6', '') + ',' + 
            GetDBColumnName('JobDet.dat', 'var_code7', '') + ',' + 
            GetDBColumnName('JobDet.dat', 'var_code8', '') + ',' + 
            GetDBColumnName('JobDet.dat', 'var_code9', '') + ',' + 
            GetDBColumnName('JobDet.dat', 'var_code10', '') + ',' + 
            GetDBColumnName('JobDet.dat', 'posted', 'JR') + ',' + 
            GetDBColumnName('JobDet.dat', 'ret_disc', 'JR') + ',' + 
            GetDBColumnName('JobDet.dat', 'ret_curr', 'JR') + ',' + 
            GetDBColumnName('JobDet.dat', 'ret_value', 'JR') + ',' + 
            GetDBColumnName('JobDet.dat', 'job_code', 'JR') + ',' + 
            GetDBColumnName('JobDet.dat', 'ret_cr_doc', 'JR') + ',' + 
            GetDBColumnName('JobDet.dat', 'ret_date', 'JR') + ',' + 
            GetDBColumnName('JobDet.dat', 'ret_doc', 'JR') + ',' + 
            GetDBColumnName('JobDet.dat', 'invoiced', 'JR') + ',' + 
            GetDBColumnName('JobDet.dat', 'ret_cust_code', 'JR') + ',' + 
            GetDBColumnName('JobDet.dat', 'orig_date', 'JR') + ',' + 
            GetDBColumnName('JobDet.dat', 'ret_cc_dep1', 'JR') + ',' + 
            GetDBColumnName('JobDet.dat', 'ret_cc_dep2', 'JR') + ',' + 
            GetDBColumnName('JobDet.dat', 'acc_type', 'JR') + ',' + 
            GetDBColumnName('JobDet.dat', 'def_vat_code', 'JR') + ',' + 
            GetDBColumnName('JobDet.dat', 'ret_cis_tax', 'JR') + ',' + 
            GetDBColumnName('JobDet.dat', 'ret_cis_gross', 'JR') + ',' + 
            GetDBColumnName('JobDet.dat', 'ret_cis_empl', 'JR') + ',' + 
            GetDBColumnName('JobDet.dat', 'ret_app_mode', 'JR') ;
end;
  
function GetAllJobCISVFields : string;
begin
  Result := GetDBColumnName('JobDet.dat', 'rec_pfix', '') + ',' + 
            GetDBColumnName('JobDet.dat', 'sub_type', '') + ',' + 
            GetDBColumnName('JobDet.dat', 'var_code1', '') + ',' + 
            GetDBColumnName('JobDet.dat', 'var_code2', '') + ',' + 
            GetDBColumnName('JobDet.dat', 'var_code3', '') + ',' + 
            GetDBColumnName('JobDet.dat', 'var_code4', '') + ',' + 
            GetDBColumnName('JobDet.dat', 'var_code5', '') + ',' + 
            GetDBColumnName('JobDet.dat', 'var_code6', '') + ',' + 
            GetDBColumnName('JobDet.dat', 'var_code7', '') + ',' + 
            GetDBColumnName('JobDet.dat', 'var_code8', '') + ',' + 
            GetDBColumnName('JobDet.dat', 'var_code9', '') + ',' + 
            GetDBColumnName('JobDet.dat', 'var_code10', '') + ',' + 
            GetDBColumnName('JobDet.dat', 'spare3', 'TS') + ',' + 
            GetDBColumnName('JobDet.dat', 'cisv_gross_total', 'TS') + ',' + 
            GetDBColumnName('JobDet.dat', 'cisv_manual_tax', 'TS') + ',' + 
            GetDBColumnName('JobDet.dat', 'cisv_auto_total_tax', 'TS') + ',' + 
            GetDBColumnName('JobDet.dat', 'cis_taxable_total', 'TS') + ',' + 
            GetDBColumnName('JobDet.dat', 'cisc_type', 'TS') + ',' + 
            GetDBColumnName('JobDet.dat', 'cis_curr', 'TS') + ',' + 
            GetDBColumnName('JobDet.dat', 'spare1', 'TS') + ',' + 
            GetDBColumnName('JobDet.dat', 'cisv_nline_count', 'TS') + ',' + 
            GetDBColumnName('JobDet.dat', 'cis_addr1', 'TS') + ',' + 
            GetDBColumnName('JobDet.dat', 'cis_addr2', 'TS') + ',' + 
            GetDBColumnName('JobDet.dat', 'cis_addr3', 'TS') + ',' + 
            GetDBColumnName('JobDet.dat', 'cis_addr4', 'TS') + ',' + 
            GetDBColumnName('JobDet.dat', 'cis_addr5', 'TS') + ',' + 
            GetDBColumnName('JobDet.dat', 'cis_behalf', 'TS') + ',' + 
            GetDBColumnName('JobDet.dat', 'cis_correct', 'TS') + ',' + 
            GetDBColumnName('JobDet.dat', 'cisv_tax_due', 'TS') + ',' + 
            GetDBColumnName('JobDet.dat', 'cis_verno', 'TS') + ',' + 
            GetDBColumnName('JobDet.dat', 'cis_htax', 'TS') ;
end;
  
function GetAllJobheadFields : string;
begin
  Result := GetDBColumnName('Jobhead.dat', 'job_code', '') + ',' + 
            GetDBColumnName('Jobhead.dat', 'job_desc', '') + ',' + 
            GetDBColumnName('Jobhead.dat', 'job_folio', '') + ',' + 
            GetDBColumnName('Jobhead.dat', 'cust_code', '') + ',' + 
            GetDBColumnName('Jobhead.dat', 'job_cat', '') + ',' + 
            GetDBColumnName('Jobhead.dat', 'job_alt_code', '') + ',' + 
            GetDBColumnName('Jobhead.dat', 'completed', '') + ',' + 
            GetDBColumnName('Jobhead.dat', 'contact', '') + ',' + 
            GetDBColumnName('Jobhead.dat', 'job_man', '') + ',' + 
            GetDBColumnName('Jobhead.dat', 'charge_type', '') + ',' + 
            GetDBColumnName('Jobhead.dat', 'spare', '') + ',' + 
            GetDBColumnName('Jobhead.dat', 'quote_price', '') + ',' + 
            GetDBColumnName('Jobhead.dat', 'curr_price', '') + ',' + 
            GetDBColumnName('Jobhead.dat', 'start_date', '') + ',' + 
            GetDBColumnName('Jobhead.dat', 'end_date', '') + ',' + 
            GetDBColumnName('Jobhead.dat', 'rev_e_date', '') + ',' + 
            GetDBColumnName('Jobhead.dat', 'sor_ref', '') + ',' + 
            GetDBColumnName('Jobhead.dat', 'n_line_count', '') + ',' + 
            GetDBColumnName('Jobhead.dat', 'a_line_count', '') + ',' + 
            GetDBColumnName('Jobhead.dat', 'spare3', '') + ',' + 
            GetDBColumnName('Jobhead.dat', 'vat_code', '') + ',' + 
            GetDBColumnName('Jobhead.dat', 'cc_dep_type1', '') + ',' + 
            GetDBColumnName('Jobhead.dat', 'cc_dep_type2', '') + ',' + 
            GetDBColumnName('Jobhead.dat', 'job_anal', '') + ',' + 
            GetDBColumnName('Jobhead.dat', 'job_type', '') + ',' + 
            GetDBColumnName('Jobhead.dat', 'job_stat', '') + ',' + 
            GetDBColumnName('Jobhead.dat', 'user_def1', '') + ',' + 
            GetDBColumnName('Jobhead.dat', 'user_def2', '') + ',' + 
            GetDBColumnName('Jobhead.dat', 'user_def3', '') + ',' + 
            GetDBColumnName('Jobhead.dat', 'user_def4', '') + ',' + 
            GetDBColumnName('Jobhead.dat', 'def_ret_curr', '') + ',' + 
            GetDBColumnName('Jobhead.dat', 'jpt_our_ref', '') + ',' + 
            GetDBColumnName('Jobhead.dat', 'jst_our_ref', '') + ',' + 
            GetDBColumnName('Jobhead.dat', 'jqs_code', '') ;
end;
  
function GetAllEmplRecFields : string;
begin
  Result := GetDBColumnName('JobMisc.dat', 'rec_pfix', '') + ',' + 
            GetDBColumnName('JobMisc.dat', 'sub_type', '') + ',' + 
            GetDBColumnName('JobMisc.dat', 'var_code1', '') + ',' + 
            GetDBColumnName('JobMisc.dat', 'var_code2', '') + ',' + 
            GetDBColumnName('JobMisc.dat', 'var_code3', '') + ',' + 
            GetDBColumnName('JobMisc.dat', 'var_code4', '') + ',' + 
            GetDBColumnName('JobMisc.dat', 'emp_name', 'JE') + ',' + 
            GetDBColumnName('JobMisc.dat', 'addr1', 'JE') + ',' + 
            GetDBColumnName('JobMisc.dat', 'addr2', 'JE') + ',' + 
            GetDBColumnName('JobMisc.dat', 'addr3', 'JE') + ',' + 
            GetDBColumnName('JobMisc.dat', 'addr4', 'JE') + ',' + 
            GetDBColumnName('JobMisc.dat', 'addr5', 'JE') + ',' + 
            GetDBColumnName('JobMisc.dat', 'phone', 'JE') + ',' + 
            GetDBColumnName('JobMisc.dat', 'fax', 'JE') + ',' + 
            GetDBColumnName('JobMisc.dat', 'phone2', 'JE') + ',' + 
            GetDBColumnName('JobMisc.dat', 'e_type', 'JE') + ',' + 
            GetDBColumnName('JobMisc.dat', 'time_dr1', 'JE') + ',' + 
            GetDBColumnName('JobMisc.dat', 'time_dr2', 'JE') + ',' + 
            GetDBColumnName('JobMisc.dat', 'cc_dep1', 'JE') + ',' + 
            GetDBColumnName('JobMisc.dat', 'cc_dep2', 'JE') + ',' + 
            GetDBColumnName('JobMisc.dat', 'pay_no', 'JE') + ',' + 
            GetDBColumnName('JobMisc.dat', 'cert_no', 'JE') + ',' + 
            GetDBColumnName('JobMisc.dat', 'cert_expiry', 'JE') + ',' + 
            GetDBColumnName('JobMisc.dat', 'je_tag', 'JE') + ',' + 
            GetDBColumnName('JobMisc.dat', 'use_o_rate', 'JE') + ',' + 
            GetDBColumnName('JobMisc.dat', 'user_def1', 'JE') + ',' + 
            GetDBColumnName('JobMisc.dat', 'user_def2', 'JE') + ',' + 
            GetDBColumnName('JobMisc.dat', 'n_line_count', 'JE') + ',' + 
            GetDBColumnName('JobMisc.dat', 'g_self_bill', 'JE') + ',' + 
            GetDBColumnName('JobMisc.dat', 'group_cert', 'JE') + ',' + 
            GetDBColumnName('JobMisc.dat', 'cis_type', 'JE') + ',' + 
            GetDBColumnName('JobMisc.dat', 'user_def3', 'JE') + ',' + 
            GetDBColumnName('JobMisc.dat', 'user_def4', 'JE') + ',' + 
            GetDBColumnName('JobMisc.dat', 'eni_no', 'JE') + ',' + 
            GetDBColumnName('JobMisc.dat', 'lab_pl_only', 'JE') + ',' + 
            GetDBColumnName('JobMisc.dat', 'utr_code', 'JE') + ',' + 
            GetDBColumnName('JobMisc.dat', 'verify_no', 'JE') + ',' + 
            GetDBColumnName('JobMisc.dat', 'tagged', 'JE') + ',' + 
            GetDBColumnName('JobMisc.dat', 'cis_subtype', 'JE') ;
end;
  
function GetAllJobTypeRecFields : string;
begin
  Result := GetDBColumnName('JobMisc.dat', 'rec_pfix', '') + ',' + 
            GetDBColumnName('JobMisc.dat', 'sub_type', '') + ',' + 
            GetDBColumnName('JobMisc.dat', 'var_code1', '') + ',' + 
            GetDBColumnName('JobMisc.dat', 'var_code2', '') + ',' + 
            GetDBColumnName('JobMisc.dat', 'var_code3', '') + ',' + 
            GetDBColumnName('JobMisc.dat', 'var_code4', '') + ',' + 
            GetDBColumnName('JobMisc.dat', 'jt_name', 'JT') + ',' + 
            GetDBColumnName('JobMisc.dat', 'jt_tag', 'JT') ;
end;
  
function GetAllJobAnalRecFields : string;
begin
  Result := GetDBColumnName('JobMisc.dat', 'rec_pfix', '') + ',' + 
            GetDBColumnName('JobMisc.dat', 'sub_type', '') + ',' + 
            GetDBColumnName('JobMisc.dat', 'var_code1', '') + ',' + 
            GetDBColumnName('JobMisc.dat', 'var_code2', '') + ',' + 
            GetDBColumnName('JobMisc.dat', 'var_code3', '') + ',' + 
            GetDBColumnName('JobMisc.dat', 'var_code4', '') + ',' + 
            GetDBColumnName('JobMisc.dat', 'ja_name', 'JA') + ',' + 
            GetDBColumnName('JobMisc.dat', 'ja_type', 'JA') + ',' + 
            GetDBColumnName('JobMisc.dat', 'wip_nom1', 'JA') + ',' + 
            GetDBColumnName('JobMisc.dat', 'wip_nom2', 'JA') + ',' + 
            GetDBColumnName('JobMisc.dat', 'anal_hed', 'JA') + ',' + 
            GetDBColumnName('JobMisc.dat', 'ja_tag', 'JA') + ',' + 
            GetDBColumnName('JobMisc.dat', 'j_link_lt', 'JA') + ',' + 
            GetDBColumnName('JobMisc.dat', 'cis_tax_rate', 'JA') + ',' + 
            GetDBColumnName('JobMisc.dat', 'uplift_p', 'JA') + ',' + 
            GetDBColumnName('JobMisc.dat', 'uplift_gl', 'JA') + ',' + 
            GetDBColumnName('JobMisc.dat', 'revenue_type', 'JA') + ',' + 
            GetDBColumnName('JobMisc.dat', 'ja_det_type', 'JA') + ',' + 
            GetDBColumnName('JobMisc.dat', 'ja_calc_b4_ret', 'JA') + ',' + 
            GetDBColumnName('JobMisc.dat', 'ja_deduct', 'JA') + ',' + 
            GetDBColumnName('JobMisc.dat', 'ja_ded_apply', 'JA') + ',' + 
            GetDBColumnName('JobMisc.dat', 'ja_ret_type', 'JA') + ',' + 
            GetDBColumnName('JobMisc.dat', 'ja_ret_value', 'JA') + ',' + 
            GetDBColumnName('JobMisc.dat', 'ja_ret_exp', 'JA') + ',' + 
            GetDBColumnName('JobMisc.dat', 'ja_ret_exp_int', 'JA') + ',' + 
            GetDBColumnName('JobMisc.dat', 'ja_ret_pres', 'JA') + ',' + 
            GetDBColumnName('JobMisc.dat', 'ja_ded_comp', 'JA') + ',' + 
            GetDBColumnName('JobMisc.dat', 'ja_pay_code', 'JA') ;
end;
  
function GetAllLbinFields : string;
begin
  Result := GetDBColumnName('Lbin.dat', 'lbHeaderNo', '') + ',' + 
            GetDBColumnName('Lbin.dat', 'lbLineNo', '') + ',' + 
            GetDBColumnName('Lbin.dat', 'lbBinCode', '') + ',' + 
            GetDBColumnName('Lbin.dat', 'lbUsedInBatch', '') + ',' + 
            GetDBColumnName('Lbin.dat', 'lbUsedInThisLine', '') + ',' + 
            GetDBColumnName('Lbin.dat', 'lbUsedElsewhere', '') + ',' + 
            GetDBColumnName('Lbin.dat', 'lbDummyChar', '') ;
end;
  
function GetAllLheaderFields : string;
begin
  Result := GetDBColumnName('Lheader.dat', 'lhFolioNo', '') + ',' + 
            GetDBColumnName('Lheader.dat', 'lhUserName', '') + ',' + 
            GetDBColumnName('Lheader.dat', 'lhAccountCode', '') + ',' + 
            GetDBColumnName('Lheader.dat', 'lhAccountName', '') + ',' + 
            GetDBColumnName('Lheader.dat', 'lhCustomerName', '') + ',' + 
            GetDBColumnName('Lheader.dat', 'lhOrderNo', '') + ',' + 
            GetDBColumnName('Lheader.dat', 'lhAddress1', '') + ',' + 
            GetDBColumnName('Lheader.dat', 'lhAddress2', '') + ',' + 
            GetDBColumnName('Lheader.dat', 'lhAddress3', '') + ',' + 
            GetDBColumnName('Lheader.dat', 'lhAddress4', '') + ',' + 
            GetDBColumnName('Lheader.dat', 'lhAddress5', '') + ',' + 
            GetDBColumnName('Lheader.dat', 'lhItemsDesc', '') + ',' + 
            GetDBColumnName('Lheader.dat', 'lhSettDisc', '') + ',' + 
            GetDBColumnName('Lheader.dat', 'lhSettDiscDays', '') + ',' + 
            GetDBColumnName('Lheader.dat', 'lhDepositToTake', '') + ',' + 
            GetDBColumnName('Lheader.dat', 'lhDate', '') + ',' + 
            GetDBColumnName('Lheader.dat', 'lhTime', '') + ',' + 
            GetDBColumnName('Lheader.dat', 'lhTillNo', '') + ',' + 
            GetDBColumnName('Lheader.dat', 'lhValue', '') + ',' + 
            GetDBColumnName('Lheader.dat', 'lhCostCentre', '') + ',' + 
            GetDBColumnName('Lheader.dat', 'lhDepartment', '') + ',' + 
            GetDBColumnName('Lheader.dat', 'lhDummyChar', '') + ',' + 
            GetDBColumnName('Lheader.dat', 'RunNo', '') + ',' + 
            GetDBColumnName('Lheader.dat', 'CustCode', '') + ',' + 
            GetDBColumnName('Lheader.dat', 'OurRef', '') + ',' + 
            GetDBColumnName('Lheader.dat', 'PadChar1', '') + ',' + 
            GetDBColumnName('Lheader.dat', 'FolioNum', '') + ',' + 
            GetDBColumnName('Lheader.dat', 'Currency', '') + ',' + 
            GetDBColumnName('Lheader.dat', 'AcYr', '') + ',' + 
            GetDBColumnName('Lheader.dat', 'AcPr', '') + ',' + 
            GetDBColumnName('Lheader.dat', 'DueDate', '') + ',' + 
            GetDBColumnName('Lheader.dat', 'TransDate', '') + ',' + 
            GetDBColumnName('Lheader.dat', 'CoRate', '') + ',' + 
            GetDBColumnName('Lheader.dat', 'VATRate', '') + ',' + 
            GetDBColumnName('Lheader.dat', 'OldYourRef', '') + ',' + 
            GetDBColumnName('Lheader.dat', 'LongYrRef', '') + ',' + 
            GetDBColumnName('Lheader.dat', 'LineCount', '') + ',' + 
            GetDBColumnName('Lheader.dat', 'TransDocHed', '') + ',' + 
            GetDBColumnName('Lheader.dat', 'InvVatAnal1', '') + ',' + 
            GetDBColumnName('Lheader.dat', 'InvVatAnal2', '') + ',' + 
            GetDBColumnName('Lheader.dat', 'InvVatAnal3', '') + ',' + 
            GetDBColumnName('Lheader.dat', 'InvVatAnal4', '') + ',' + 
            GetDBColumnName('Lheader.dat', 'InvVatAnal5', '') + ',' + 
            GetDBColumnName('Lheader.dat', 'InvVatAnal6', '') + ',' + 
            GetDBColumnName('Lheader.dat', 'InvVatAnal7', '') + ',' + 
            GetDBColumnName('Lheader.dat', 'InvVatAnal8', '') + ',' + 
            GetDBColumnName('Lheader.dat', 'InvVatAnal9', '') + ',' + 
            GetDBColumnName('Lheader.dat', 'InvVatAnal10', '') + ',' + 
            GetDBColumnName('Lheader.dat', 'InvVatAnal11', '') + ',' + 
            GetDBColumnName('Lheader.dat', 'InvVatAnal12', '') + ',' + 
            GetDBColumnName('Lheader.dat', 'InvVatAnal13', '') + ',' + 
            GetDBColumnName('Lheader.dat', 'InvVatAnal14', '') + ',' + 
            GetDBColumnName('Lheader.dat', 'InvVatAnal15', '') + ',' + 
            GetDBColumnName('Lheader.dat', 'InvVatAnal16', '') + ',' + 
            GetDBColumnName('Lheader.dat', 'InvVatAnal17', '') + ',' + 
            GetDBColumnName('Lheader.dat', 'InvVatAnal18', '') + ',' + 
            GetDBColumnName('Lheader.dat', 'InvVatAnal19', '') + ',' + 
            GetDBColumnName('Lheader.dat', 'InvVatAnal20', '') + ',' + 
            GetDBColumnName('Lheader.dat', 'InvVatAnal21', '') + ',' + 
            GetDBColumnName('Lheader.dat', 'InvNetVal', '') + ',' + 
            GetDBColumnName('Lheader.dat', 'InvVat', '') + ',' + 
            GetDBColumnName('Lheader.dat', 'DiscSetl', '') + ',' + 
            GetDBColumnName('Lheader.dat', 'DiscSetAm', '') + ',' + 
            GetDBColumnName('Lheader.dat', 'DiscAmount', '') + ',' + 
            GetDBColumnName('Lheader.dat', 'DiscDays', '') + ',' + 
            GetDBColumnName('Lheader.dat', 'DiscTaken', '') + ',' + 
            GetDBColumnName('Lheader.dat', 'Settled', '') + ',' + 
            GetDBColumnName('Lheader.dat', 'TransNat', '') + ',' + 
            GetDBColumnName('Lheader.dat', 'TransMode', '') + ',' + 
            GetDBColumnName('Lheader.dat', 'HoldFlg', '') + ',' + 
            GetDBColumnName('Lheader.dat', 'PadChar2', '') + ',' + 
            GetDBColumnName('Lheader.dat', 'TotalWeight', '') + ',' + 
            GetDBColumnName('Lheader.dat', 'DAddr1', '') + ',' + 
            GetDBColumnName('Lheader.dat', 'DAddr2', '') + ',' + 
            GetDBColumnName('Lheader.dat', 'DAddr3', '') + ',' + 
            GetDBColumnName('Lheader.dat', 'DAddr4', '') + ',' + 
            GetDBColumnName('Lheader.dat', 'DAddr5', '') + ',' + 
            GetDBColumnName('Lheader.dat', 'PadChar3', '') + ',' + 
            GetDBColumnName('Lheader.dat', 'TotalCost', '') + ',' + 
            GetDBColumnName('Lheader.dat', 'PrintedDoc', '') + ',' + 
            GetDBColumnName('Lheader.dat', 'ManVAT', '') + ',' + 
            GetDBColumnName('Lheader.dat', 'DelTerms', '') + ',' + 
            GetDBColumnName('Lheader.dat', 'OpName', '') + ',' + 
            GetDBColumnName('Lheader.dat', 'DJobCode', '') + ',' + 
            GetDBColumnName('Lheader.dat', 'DJobAnal', '') + ',' + 
            GetDBColumnName('Lheader.dat', 'PadChar4', '') + ',' + 
            GetDBColumnName('Lheader.dat', 'TotOrdOS', '') + ',' + 
            GetDBColumnName('Lheader.dat', 'DocUser1', '') + ',' + 
            GetDBColumnName('Lheader.dat', 'DocUser2', '') + ',' + 
            GetDBColumnName('Lheader.dat', 'EmpCode', '') + ',' + 
            GetDBColumnName('Lheader.dat', 'PadChar5', '') + ',' + 
            GetDBColumnName('Lheader.dat', 'Tagged', '') + ',' + 
            GetDBColumnName('Lheader.dat', 'thNoLabels', '') + ',' + 
            GetDBColumnName('Lheader.dat', 'PadChar6', '') + ',' + 
            GetDBColumnName('Lheader.dat', 'CtrlNom', '') + ',' + 
            GetDBColumnName('Lheader.dat', 'DocUser3', '') + ',' + 
            GetDBColumnName('Lheader.dat', 'DocUser4', '') + ',' + 
            GetDBColumnName('Lheader.dat', 'SSDProcess', '') + ',' + 
            GetDBColumnName('Lheader.dat', 'PadChar7', '') + ',' + 
            GetDBColumnName('Lheader.dat', 'ExtSource', '') + ',' + 
            GetDBColumnName('Lheader.dat', 'PostDate', '') + ',' + 
            GetDBColumnName('Lheader.dat', 'PadChar8', '') + ',' + 
            GetDBColumnName('Lheader.dat', 'PORPickSOR', '') + ',' + 
            GetDBColumnName('Lheader.dat', 'PadChar9', '') + ',' + 
            GetDBColumnName('Lheader.dat', 'BDiscount', '') + ',' + 
            GetDBColumnName('Lheader.dat', 'PrePostFlg', '') + ',' + 
            GetDBColumnName('Lheader.dat', 'AllocStat', '') + ',' + 
            GetDBColumnName('Lheader.dat', 'PadChar10', '') + ',' + 
            GetDBColumnName('Lheader.dat', 'SOPKeepRate', '') + ',' + 
            GetDBColumnName('Lheader.dat', 'TimeCreate', '') + ',' + 
            GetDBColumnName('Lheader.dat', 'TimeChange', '') + ',' + 
            GetDBColumnName('Lheader.dat', 'CISTax', '') + ',' + 
            GetDBColumnName('Lheader.dat', 'CISDeclared', '') + ',' + 
            GetDBColumnName('Lheader.dat', 'CISManualTax', '') + ',' + 
            GetDBColumnName('Lheader.dat', 'CISDate', '') + ',' + 
            GetDBColumnName('Lheader.dat', 'PadChar11', '') + ',' + 
            GetDBColumnName('Lheader.dat', 'TotalCost2', '') + ',' + 
            GetDBColumnName('Lheader.dat', 'CISEmpl', '') + ',' + 
            GetDBColumnName('Lheader.dat', 'PadChar12', '') + ',' + 
            GetDBColumnName('Lheader.dat', 'CISGross', '') + ',' + 
            GetDBColumnName('Lheader.dat', 'CISHolder', '') + ',' + 
            GetDBColumnName('Lheader.dat', 'NOMVatIO', '') + ',' + 
            GetDBColumnName('Lheader.dat', 'AutoInc', '') + ',' + 
            GetDBColumnName('Lheader.dat', 'AutoIncBy', '') + ',' + 
            GetDBColumnName('Lheader.dat', 'AutoEndDate', '') + ',' + 
            GetDBColumnName('Lheader.dat', 'AutoEndPr', '') + ',' + 
            GetDBColumnName('Lheader.dat', 'AutoEndYr', '') + ',' + 
            GetDBColumnName('Lheader.dat', 'AutoPost', '') + ',' + 
            GetDBColumnName('Lheader.dat', 'thAutoTransaction', '') + ',' + 
            GetDBColumnName('Lheader.dat', 'PadChar13', '') + ',' + 
            GetDBColumnName('Lheader.dat', 'thDeliveryRunNo', '') + ',' + 
            GetDBColumnName('Lheader.dat', 'thExternal', '') + ',' + 
            GetDBColumnName('Lheader.dat', 'thSettledVAT', '') + ',' + 
            GetDBColumnName('Lheader.dat', 'thVATClaimed', '') + ',' + 
            GetDBColumnName('Lheader.dat', 'thPickingRunNo', '') + ',' + 
            GetDBColumnName('Lheader.dat', 'PadChar15', '') + ',' + 
            GetDBColumnName('Lheader.dat', 'thDeliveryNoteRef', '') + ',' + 
            GetDBColumnName('Lheader.dat', 'thVATCompanyRate', '') + ',' + 
            GetDBColumnName('Lheader.dat', 'thVATDailyRate', '') + ',' + 
            GetDBColumnName('Lheader.dat', 'thPostCompanyRate', '') + ',' + 
            GetDBColumnName('Lheader.dat', 'thPostDailyRate', '') + ',' + 
            GetDBColumnName('Lheader.dat', 'thPostDiscAmount', '') + ',' + 
            GetDBColumnName('Lheader.dat', 'PadChar16', '') + ',' + 
            GetDBColumnName('Lheader.dat', 'thPostDiscTaken', '') + ',' + 
            GetDBColumnName('Lheader.dat', 'thLastDebtChaseLetter', '') + ',' + 
            GetDBColumnName('Lheader.dat', 'thRevaluationAdjustment', '') + ',' + 
            GetDBColumnName('Lheader.dat', 'YourRef', '') + ',' + 
            GetDBColumnName('Lheader.dat', 'Spare', '') + ',' + 
            GetDBColumnName('Lheader.dat', 'LastChar', '') ;
end;
  
function GetAllLlinesFields : string;
begin
  Result := GetDBColumnName('Llines.dat', 'llheaderno', '') + ',' + 
            GetDBColumnName('Llines.dat', 'lllineno', '') + ',' + 
            GetDBColumnName('Llines.dat', 'llstockcode', '') + ',' + 
            GetDBColumnName('Llines.dat', 'lldescription1', '') + ',' + 
            GetDBColumnName('Llines.dat', 'lldescription2', '') + ',' + 
            GetDBColumnName('Llines.dat', 'lldescription3', '') + ',' + 
            GetDBColumnName('Llines.dat', 'lldescription4', '') + ',' + 
            GetDBColumnName('Llines.dat', 'lldescription5', '') + ',' + 
            GetDBColumnName('Llines.dat', 'lldescription6', '') + ',' + 
            GetDBColumnName('Llines.dat', 'llprice', '') + ',' + 
            GetDBColumnName('Llines.dat', 'llvatinclusive', '') + ',' + 
            GetDBColumnName('Llines.dat', 'llvatrate', '') + ',' + 
            GetDBColumnName('Llines.dat', 'lldisctype', '') + ',' + 
            GetDBColumnName('Llines.dat', 'lldiscount', '') + ',' + 
            GetDBColumnName('Llines.dat', 'lldiscamount', '') + ',' + 
            GetDBColumnName('Llines.dat', 'lldiscdesc', '') + ',' + 
            GetDBColumnName('Llines.dat', 'llquantity', '') + ',' + 
            GetDBColumnName('Llines.dat', 'llserialitem', '') + ',' + 
            GetDBColumnName('Llines.dat', 'lldummychar', '') + ',' + 
            GetDBColumnName('Llines.dat', 'lllistfoliono', '') + ',' + 
            GetDBColumnName('Llines.dat', 'llbomparentfoliono', '') + ',' + 
            GetDBColumnName('Llines.dat', 'llbomqtyused', '') + ',' + 
            GetDBColumnName('Llines.dat', 'llbom', '') + ',' + 
            GetDBColumnName('Llines.dat', 'llkitlink', '') + ',' + 
            GetDBColumnName('Llines.dat', 'transrefno', '') + ',' + 
            GetDBColumnName('Llines.dat', 'padchar1', '') + ',' + 
            GetDBColumnName('Llines.dat', 'lineno', '') + ',' + 
            GetDBColumnName('Llines.dat', 'nomcode', '') + ',' + 
            GetDBColumnName('Llines.dat', 'currency', '') + ',' + 
            GetDBColumnName('Llines.dat', 'padchar2', '') + ',' + 
            GetDBColumnName('Llines.dat', 'corate', '') + ',' + 
            GetDBColumnName('Llines.dat', 'vatrate', '') + ',' + 
            GetDBColumnName('Llines.dat', 'cc', '') + ',' + 
            GetDBColumnName('Llines.dat', 'dep', '') + ',' + 
            GetDBColumnName('Llines.dat', 'stockcode', '') + ',' + 
            GetDBColumnName('Llines.dat', 'padchar3', '') + ',' + 
            GetDBColumnName('Llines.dat', 'qty', '') + ',' + 
            GetDBColumnName('Llines.dat', 'qtymul', '') + ',' + 
            GetDBColumnName('Llines.dat', 'netvalue', '') + ',' + 
            GetDBColumnName('Llines.dat', 'discount', '') + ',' + 
            GetDBColumnName('Llines.dat', 'vatcode', '') + ',' + 
            GetDBColumnName('Llines.dat', 'padchar4', '') + ',' + 
            GetDBColumnName('Llines.dat', 'vat', '') + ',' + 
            GetDBColumnName('Llines.dat', 'payment', '') + ',' + 
            GetDBColumnName('Llines.dat', 'discountchr', '') + ',' + 
            GetDBColumnName('Llines.dat', 'padchar5', '') + ',' + 
            GetDBColumnName('Llines.dat', 'qtywoff', '') + ',' + 
            GetDBColumnName('Llines.dat', 'qtydel', '') + ',' + 
            GetDBColumnName('Llines.dat', 'costprice', '') + ',' + 
            GetDBColumnName('Llines.dat', 'custcode', '') + ',' + 
            GetDBColumnName('Llines.dat', 'linedate', '') + ',' + 
            GetDBColumnName('Llines.dat', 'item', '') + ',' + 
            GetDBColumnName('Llines.dat', 'desc', '') + ',' + 
            GetDBColumnName('Llines.dat', 'weight', '') + ',' + 
            GetDBColumnName('Llines.dat', 'mlocstk', '') + ',' + 
            GetDBColumnName('Llines.dat', 'jobcode', '') + ',' + 
            GetDBColumnName('Llines.dat', 'analcode', '') + ',' + 
            GetDBColumnName('Llines.dat', 'tshccurr', '') + ',' + 
            GetDBColumnName('Llines.dat', 'docltlink', '') + ',' + 
            GetDBColumnName('Llines.dat', 'spare3', '') + ',' + 
            GetDBColumnName('Llines.dat', 'kitlink', '') + ',' + 
            GetDBColumnName('Llines.dat', 'folionum', '') + ',' + 
            GetDBColumnName('Llines.dat', 'linetype', '') + ',' + 
            GetDBColumnName('Llines.dat', 'reconcile', '') + ',' + 
            GetDBColumnName('Llines.dat', 'padchar6', '') + ',' + 
            GetDBColumnName('Llines.dat', 'soplink', '') + ',' + 
            GetDBColumnName('Llines.dat', 'soplineno', '') + ',' + 
            GetDBColumnName('Llines.dat', 'abslineno', '') + ',' + 
            GetDBColumnName('Llines.dat', 'lineuser1', '') + ',' + 
            GetDBColumnName('Llines.dat', 'lineuser2', '') + ',' + 
            GetDBColumnName('Llines.dat', 'lineuser3', '') + ',' + 
            GetDBColumnName('Llines.dat', 'lineuser4', '') + ',' + 
            GetDBColumnName('Llines.dat', 'ssduplift', '') + ',' + 
            GetDBColumnName('Llines.dat', 'ssdcommod', '') + ',' + 
            GetDBColumnName('Llines.dat', 'padchar7', '') + ',' + 
            GetDBColumnName('Llines.dat', 'ssdspunit', '') + ',' + 
            GetDBColumnName('Llines.dat', 'ssduseline', '') + ',' + 
            GetDBColumnName('Llines.dat', 'padchar8', '') + ',' + 
            GetDBColumnName('Llines.dat', 'pricemulx', '') + ',' + 
            GetDBColumnName('Llines.dat', 'qtypick', '') + ',' + 
            GetDBColumnName('Llines.dat', 'vatincflg', '') + ',' + 
            GetDBColumnName('Llines.dat', 'padchar9', '') + ',' + 
            GetDBColumnName('Llines.dat', 'qtypwoff', '') + ',' + 
            GetDBColumnName('Llines.dat', 'padchar10', '') + ',' + 
            GetDBColumnName('Llines.dat', 'rtnerrcode', '') + ',' + 
            GetDBColumnName('Llines.dat', 'ssdcountry', '') + ',' + 
            GetDBColumnName('Llines.dat', 'padchar11', '') + ',' + 
            GetDBColumnName('Llines.dat', 'incnetvalue', '') + ',' + 
            GetDBColumnName('Llines.dat', 'autolinetype', '') + ',' + 
            GetDBColumnName('Llines.dat', 'cisratecode', '') + ',' + 
            GetDBColumnName('Llines.dat', 'padchar12', '') + ',' + 
            GetDBColumnName('Llines.dat', 'cisrate', '') + ',' + 
            GetDBColumnName('Llines.dat', 'costapport', '') + ',' + 
            GetDBColumnName('Llines.dat', 'nomvattype', '') + ',' + 
            GetDBColumnName('Llines.dat', 'padchar13', '') + ',' + 
            GetDBColumnName('Llines.dat', 'binqty', '') + ',' + 
            GetDBColumnName('Llines.dat', 'tlaltstockfolio', '') + ',' + 
            GetDBColumnName('Llines.dat', 'tlrunno', '') + ',' + 
            GetDBColumnName('Llines.dat', 'tlstockdeductqty', '') + ',' + 
            GetDBColumnName('Llines.dat', 'padchar16', '') + ',' + 
            GetDBColumnName('Llines.dat', 'tluseqtymul', '') + ',' + 
            GetDBColumnName('Llines.dat', 'tlserialqty', '') + ',' + 
            GetDBColumnName('Llines.dat', 'padchar17', '') + ',' + 
            GetDBColumnName('Llines.dat', 'tlpricebypack', '') + ',' + 
            GetDBColumnName('Llines.dat', 'padchar18', '') + ',' + 
            GetDBColumnName('Llines.dat', 'tlreconciliationdate', '') + ',' + 
            GetDBColumnName('Llines.dat', 'tlb2blinkfolio', '') + ',' + 
            GetDBColumnName('Llines.dat', 'tlb2blineno', '') + ',' + 
            GetDBColumnName('Llines.dat', 'tlcosdailyrate', '') + ',' + 
            GetDBColumnName('Llines.dat', 'tlqtypack', '') + ',' + 
            GetDBColumnName('Llines.dat', 'spare', '') + ',' + 
            GetDBColumnName('Llines.dat', 'spare2', '') + ',' + 
            GetDBColumnName('Llines.dat', 'lastchar', '') + ',' + 
            GetDBColumnName('Llines.dat', 'llbomcomponent', '') ;
end;
  
function GetAllLserialFields : string;
begin
  Result := GetDBColumnName('Lserial.dat', 'lsHeaderNo', '') + ',' + 
            GetDBColumnName('Lserial.dat', 'lsLineNo', '') + ',' + 
            GetDBColumnName('Lserial.dat', 'lsBatch', '') + ',' + 
            GetDBColumnName('Lserial.dat', 'lsSerialNo', '') + ',' + 
            GetDBColumnName('Lserial.dat', 'lsBatchNo', '') + ',' + 
            GetDBColumnName('Lserial.dat', 'XlsUsedInBatch', '') + ',' + 
            GetDBColumnName('Lserial.dat', 'XlsUsedInThisLine', '') + ',' + 
            GetDBColumnName('Lserial.dat', 'XlsUsedElsewhere', '') + ',' + 
            GetDBColumnName('Lserial.dat', 'lsDummyChar', '') + ',' + 
            GetDBColumnName('Lserial.dat', 'lsUsedInBatch', '') + ',' + 
            GetDBColumnName('Lserial.dat', 'lsUsedInThisLine', '') + ',' + 
            GetDBColumnName('Lserial.dat', 'lsUsedElsewhere', '') ;
end;
  
function GetAllMCPAYFields : string;
begin
  Result := GetDBColumnName('MCPAY.dat', 'CoCode', '') + ',' + 
            GetDBColumnName('MCPAY.dat', 'PayID', '') + ',' + 
            GetDBColumnName('MCPAY.dat', 'CoName', '') + ',' + 
            GetDBColumnName('MCPAY.dat', 'FileName', '') ;
end;
  
function GetAllMLocLocFields : string;
begin
  Result := GetDBColumnName('Mlocstk.dat', 'rec_pfix', '') + ',' + 
            GetDBColumnName('Mlocstk.dat', 'sub_type', '') + ',' + 
            GetDBColumnName('Mlocstk.dat', 'var_code1', '') + ',' + 
            GetDBColumnName('Mlocstk.dat', 'var_code2', '') + ',' + 
            GetDBColumnName('Mlocstk.dat', 'var_code3', '') + ',' + 
            GetDBColumnName('Mlocstk.dat', 'lo_addr1', 'CC') + ',' + 
            GetDBColumnName('Mlocstk.dat', 'lo_addr2', 'CC') + ',' + 
            GetDBColumnName('Mlocstk.dat', 'lo_addr3', 'CC') + ',' + 
            GetDBColumnName('Mlocstk.dat', 'lo_addr4', 'CC') + ',' + 
            GetDBColumnName('Mlocstk.dat', 'lo_addr5', 'CC') + ',' + 
            GetDBColumnName('Mlocstk.dat', 'lo_tel', 'CC') + ',' + 
            GetDBColumnName('Mlocstk.dat', 'lo_fax', 'CC') + ',' + 
            GetDBColumnName('Mlocstk.dat', 'lo_email', 'CC') + ',' + 
            GetDBColumnName('Mlocstk.dat', 'lo_modem', 'CC') + ',' + 
            GetDBColumnName('Mlocstk.dat', 'lo_contact', 'CC') + ',' + 
            GetDBColumnName('Mlocstk.dat', 'lo_currency', 'CC') + ',' + 
            GetDBColumnName('Mlocstk.dat', 'lo_area', 'CC') + ',' + 
            GetDBColumnName('Mlocstk.dat', 'lo_rep', 'CC') + ',' + 
            GetDBColumnName('Mlocstk.dat', 'lo_tag', 'CC') + ',' + 
            GetDBColumnName('Mlocstk.dat', 'lo_nominal1', 'CC') + ',' + 
            GetDBColumnName('Mlocstk.dat', 'lo_nominal2', 'CC') + ',' + 
            GetDBColumnName('Mlocstk.dat', 'lo_nominal3', 'CC') + ',' + 
            GetDBColumnName('Mlocstk.dat', 'lo_nominal4', 'CC') + ',' + 
            GetDBColumnName('Mlocstk.dat', 'lo_nominal5', 'CC') + ',' + 
            GetDBColumnName('Mlocstk.dat', 'lo_nominal6', 'CC') + ',' + 
            GetDBColumnName('Mlocstk.dat', 'lo_nominal7', 'CC') + ',' + 
            GetDBColumnName('Mlocstk.dat', 'lo_nominal8', 'CC') + ',' + 
            GetDBColumnName('Mlocstk.dat', 'lo_nominal9', 'CC') + ',' + 
            GetDBColumnName('Mlocstk.dat', 'lo_nominal10', 'CC') + ',' + 
            GetDBColumnName('Mlocstk.dat', 'lo_cc_dep1', 'CC') + ',' + 
            GetDBColumnName('Mlocstk.dat', 'lo_cc_dep2', 'CC') + ',' + 
            GetDBColumnName('Mlocstk.dat', 'lo_use_price', 'CC') + ',' + 
            GetDBColumnName('Mlocstk.dat', 'lo_use_nom', 'CC') + ',' + 
            GetDBColumnName('Mlocstk.dat', 'lo_use_cc_dep', 'CC') + ',' + 
            GetDBColumnName('Mlocstk.dat', 'lo_use_supp', 'CC') + ',' + 
            GetDBColumnName('Mlocstk.dat', 'lo_use_bin_loc', 'CC') + ',' + 
            GetDBColumnName('Mlocstk.dat', 'lo_n_line_count', 'CC') + ',' + 
            GetDBColumnName('Mlocstk.dat', 'lo_use_c_price', 'CC') + ',' + 
            GetDBColumnName('Mlocstk.dat', 'lo_use_r_price', 'CC') + ',' + 
            GetDBColumnName('Mlocstk.dat', 'lo_wopwipgl', 'CC') + ',' + 
            GetDBColumnName('Mlocstk.dat', 'lo_return_gl', 'CC') + ',' + 
            GetDBColumnName('Mlocstk.dat', 'lo_p_return_gl', 'CC') ;
end;
  
function GetAllMStkLocFields : string;
begin
  Result := GetDBColumnName('Mlocstk.dat', 'rec_pfix', '') + ',' + 
            GetDBColumnName('Mlocstk.dat', 'sub_type', '') + ',' + 
            GetDBColumnName('Mlocstk.dat', 'var_code1', '') + ',' + 
            GetDBColumnName('Mlocstk.dat', 'var_code2', '') + ',' + 
            GetDBColumnName('Mlocstk.dat', 'var_code3', '') + ',' + 
            GetDBColumnName('Mlocstk.dat', 'ls_stk_code', 'CD') + ',' + 
            GetDBColumnName('Mlocstk.dat', 'ls_stk_folio', 'CD') + ',' + 
            GetDBColumnName('Mlocstk.dat', 'ls_loc_code', 'CD') + ',' + 
            GetDBColumnName('Mlocstk.dat', 'ls_qty_in_stock', 'CD') + ',' + 
            GetDBColumnName('Mlocstk.dat', 'ls_qty_on_order', 'CD') + ',' + 
            GetDBColumnName('Mlocstk.dat', 'ls_qty_alloc', 'CD') + ',' + 
            GetDBColumnName('Mlocstk.dat', 'ls_qty_picked', 'CD') + ',' + 
            GetDBColumnName('Mlocstk.dat', 'ls_qty_min', 'CD') + ',' + 
            GetDBColumnName('Mlocstk.dat', 'ls_qty_max', 'CD') + ',' + 
            GetDBColumnName('Mlocstk.dat', 'ls_qty_freeze', 'CD') + ',' + 
            GetDBColumnName('Mlocstk.dat', 'ls_ro_qty', 'CD') + ',' + 
            GetDBColumnName('Mlocstk.dat', 'ls_ro_date', 'CD') + ',' + 
            GetDBColumnName('Mlocstk.dat', 'ls_ro_cc_dep1', 'CD') + ',' + 
            GetDBColumnName('Mlocstk.dat', 'ls_ro_cc_dep2', 'CD') + ',' + 
            GetDBColumnName('Mlocstk.dat', 'ls_cc_dep1', 'CD') + ',' + 
            GetDBColumnName('Mlocstk.dat', 'ls_cc_dep2', 'CD') + ',' + 
            GetDBColumnName('Mlocstk.dat', 'ls_bin_loc', 'CD') + ',' + 
            GetDBColumnName('Mlocstk.dat', 'currency1', 'CD') + ',' + 
            GetDBColumnName('Mlocstk.dat', 'sales_price1', 'CD') + ',' + 
            GetDBColumnName('Mlocstk.dat', 'currency2', 'CD') + ',' + 
            GetDBColumnName('Mlocstk.dat', 'sales_price2', 'CD') + ',' + 
            GetDBColumnName('Mlocstk.dat', 'currency3', 'CD') + ',' + 
            GetDBColumnName('Mlocstk.dat', 'sales_price3', 'CD') + ',' + 
            GetDBColumnName('Mlocstk.dat', 'currency4', 'CD') + ',' + 
            GetDBColumnName('Mlocstk.dat', 'sales_price4', 'CD') + ',' + 
            GetDBColumnName('Mlocstk.dat', 'currency5', 'CD') + ',' + 
            GetDBColumnName('Mlocstk.dat', 'sales_price5', 'CD') + ',' + 
            GetDBColumnName('Mlocstk.dat', 'currency6', 'CD') + ',' + 
            GetDBColumnName('Mlocstk.dat', 'sales_price6', 'CD') + ',' + 
            GetDBColumnName('Mlocstk.dat', 'currency7', 'CD') + ',' + 
            GetDBColumnName('Mlocstk.dat', 'sales_price7', 'CD') + ',' + 
            GetDBColumnName('Mlocstk.dat', 'currency8', 'CD') + ',' + 
            GetDBColumnName('Mlocstk.dat', 'sales_price8', 'CD') + ',' + 
            GetDBColumnName('Mlocstk.dat', 'currency9', 'CD') + ',' + 
            GetDBColumnName('Mlocstk.dat', 'sales_price9', 'CD') + ',' + 
            GetDBColumnName('Mlocstk.dat', 'currency10', 'CD') + ',' + 
            GetDBColumnName('Mlocstk.dat', 'sales_price10', 'CD') + ',' + 
            GetDBColumnName('Mlocstk.dat', 'ls_ro_price', 'CD') + ',' + 
            GetDBColumnName('Mlocstk.dat', 'ls_ro_currency', 'CD') + ',' + 
            GetDBColumnName('Mlocstk.dat', 'ls_cost_price', 'CD') + ',' + 
            GetDBColumnName('Mlocstk.dat', 'ls_p_currency', 'CD') + ',' + 
            GetDBColumnName('Mlocstk.dat', 'ls_def_nom1', 'CD') + ',' + 
            GetDBColumnName('Mlocstk.dat', 'ls_def_nom2', 'CD') + ',' + 
            GetDBColumnName('Mlocstk.dat', 'ls_def_nom3', 'CD') + ',' + 
            GetDBColumnName('Mlocstk.dat', 'ls_def_nom4', 'CD') + ',' + 
            GetDBColumnName('Mlocstk.dat', 'ls_def_nom5', 'CD') + ',' + 
            GetDBColumnName('Mlocstk.dat', 'ls_def_nom6', 'CD') + ',' + 
            GetDBColumnName('Mlocstk.dat', 'ls_def_nom7', 'CD') + ',' + 
            GetDBColumnName('Mlocstk.dat', 'ls_def_nom8', 'CD') + ',' + 
            GetDBColumnName('Mlocstk.dat', 'ls_def_nom9', 'CD') + ',' + 
            GetDBColumnName('Mlocstk.dat', 'ls_def_nom10', 'CD') + ',' + 
            GetDBColumnName('Mlocstk.dat', 'ls_stk_flg', 'CD') + ',' + 
            GetDBColumnName('Mlocstk.dat', 'ls_min_flg', 'CD') + ',' + 
            GetDBColumnName('Mlocstk.dat', 'ls_temp_supp', 'CD') + ',' + 
            GetDBColumnName('Mlocstk.dat', 'ls_supplier', 'CD') + ',' + 
            GetDBColumnName('Mlocstk.dat', 'ls_last_used', 'CD') + ',' + 
            GetDBColumnName('Mlocstk.dat', 'ls_qty_posted', 'CD') + ',' + 
            GetDBColumnName('Mlocstk.dat', 'ls_qty_take', 'CD') + ',' + 
            GetDBColumnName('Mlocstk.dat', 'ls_ro_flg', 'CD') + ',' + 
            GetDBColumnName('Mlocstk.dat', 'ls_last_time', 'CD') + ',' + 
            GetDBColumnName('Mlocstk.dat', 'ls_qty_alloc_wor', 'CD') + ',' + 
            GetDBColumnName('Mlocstk.dat', 'ls_qty_issue_wor', 'CD') + ',' + 
            GetDBColumnName('Mlocstk.dat', 'ls_qty_pick_wor', 'CD') + ',' + 
            GetDBColumnName('Mlocstk.dat', 'ls_wopwipgl', 'CD') + ',' + 
            GetDBColumnName('Mlocstk.dat', 'ls_s_warranty', 'CD') + ',' + 
            GetDBColumnName('Mlocstk.dat', 'ls_s_warranty_type', 'CD') + ',' + 
            GetDBColumnName('Mlocstk.dat', 'ls_m_warranty', 'CD') + ',' + 
            GetDBColumnName('Mlocstk.dat', 'ls_m_warranty_type', 'CD') + ',' + 
            GetDBColumnName('Mlocstk.dat', 'ls_qty_p_return', 'CD') + ',' + 
            GetDBColumnName('Mlocstk.dat', 'ls_return_gl', 'CD') + ',' + 
            GetDBColumnName('Mlocstk.dat', 'ls_re_stock_pcnt', 'CD') + ',' + 
            GetDBColumnName('Mlocstk.dat', 'ls_re_stock_gl', 'CD') + ',' + 
            GetDBColumnName('Mlocstk.dat', 'ls_bom_ded_comp', 'CD') + ',' + 
            GetDBColumnName('Mlocstk.dat', 'ls_qty_return', 'CD') + ',' + 
            GetDBColumnName('Mlocstk.dat', 'ls_p_return_gl', 'CD') ;
end;
  
function GetAllSdbStkRecFields : string;
begin
  Result := GetDBColumnName('Mlocstk.dat', 'rec_pfix', '') + ',' + 
            GetDBColumnName('Mlocstk.dat', 'sub_type', '') + ',' + 
            GetDBColumnName('Mlocstk.dat', 'var_code1', '') + ',' + 
            GetDBColumnName('Mlocstk.dat', 'var_code2', '') + ',' + 
            GetDBColumnName('Mlocstk.dat', 'var_code3', '') + ',' + 
            GetDBColumnName('Mlocstk.dat', 'sd_stk_folio', 'N*') + ',' + 
            GetDBColumnName('Mlocstk.dat', 'sd_folio', 'N*') + ',' + 
            GetDBColumnName('Mlocstk.dat', 'sd_supp_code', 'N*') + ',' + 
            GetDBColumnName('Mlocstk.dat', 'sd_alt_code', 'N*') + ',' + 
            GetDBColumnName('Mlocstk.dat', 'sd_ro_currency', 'N*') + ',' + 
            GetDBColumnName('Mlocstk.dat', 'sd_ro_price', 'N*') + ',' + 
            GetDBColumnName('Mlocstk.dat', 'sd_n_line_count', 'N*') + ',' + 
            GetDBColumnName('Mlocstk.dat', 'sd_last_used', 'N*') + ',' + 
            GetDBColumnName('Mlocstk.dat', 'sd_over_ro', 'N*') + ',' + 
            GetDBColumnName('Mlocstk.dat', 'sd_desc', 'N*') + ',' + 
            GetDBColumnName('Mlocstk.dat', 'sd_last_time', 'N*') + ',' + 
            GetDBColumnName('Mlocstk.dat', 'sd_over_min_ecc', 'N*') + ',' + 
            GetDBColumnName('Mlocstk.dat', 'sd_min_ecc_qty', 'N*') + ',' + 
            GetDBColumnName('Mlocstk.dat', 'sd_over_line_qty', 'N*') + ',' + 
            GetDBColumnName('Mlocstk.dat', 'sd_line_qty', 'N*') + ',' + 
            GetDBColumnName('Mlocstk.dat', 'sd_line_no', 'N*') ;
end;
  
function GetAllCuStkRecFields : string;
begin
  Result := GetDBColumnName('CustomerStockAnalysis.dat', 'rec_pfix', '') + ',' +
            GetDBColumnName('CustomerStockAnalysis.dat', 'sub_type', '') + ',' +
            GetDBColumnName('CustomerStockAnalysis.dat', 'var_code1', '') + ',' +
            GetDBColumnName('CustomerStockAnalysis.dat', 'var_code2', '') + ',' +
            GetDBColumnName('CustomerStockAnalysis.dat', 'var_code3', '') + ',' +
            GetDBColumnName('CustomerStockAnalysis.dat', 'cs_cust_code', '') + ',' +
            GetDBColumnName('CustomerStockAnalysis.dat', 'cs_stock_code', '') + ',' +
            GetDBColumnName('CustomerStockAnalysis.dat', 'cs_stk_folio', '') + ',' +
            GetDBColumnName('CustomerStockAnalysis.dat', 'cs_so_qty', '') + ',' +
            GetDBColumnName('CustomerStockAnalysis.dat', 'cs_last_date', '') + ',' +
            GetDBColumnName('CustomerStockAnalysis.dat', 'cs_line_no', '') + ',' +
            GetDBColumnName('CustomerStockAnalysis.dat', 'cs_last_price', '') + ',' +
            GetDBColumnName('CustomerStockAnalysis.dat', 'cs_lp_curr', '') + ',' +
            GetDBColumnName('CustomerStockAnalysis.dat', 'cs_job_code', '') + ',' +
            GetDBColumnName('CustomerStockAnalysis.dat', 'cs_ja_code', '') + ',' +
            GetDBColumnName('CustomerStockAnalysis.dat', 'cs_loc_code', '') + ',' +
            GetDBColumnName('CustomerStockAnalysis.dat', 'cs_nom_code', '') + ',' +
            GetDBColumnName('CustomerStockAnalysis.dat', 'cs_cc_dep1', '') + ',' +
            GetDBColumnName('CustomerStockAnalysis.dat', 'cs_cc_dep2', '') + ',' +
            GetDBColumnName('CustomerStockAnalysis.dat', 'cs_qty', '') + ',' +
            GetDBColumnName('CustomerStockAnalysis.dat', 'cs_net_value', '') + ',' +
            GetDBColumnName('CustomerStockAnalysis.dat', 'csdiscount', '') + ',' +
            GetDBColumnName('CustomerStockAnalysis.dat', 'cs_vat_code', '') + ',' +
            GetDBColumnName('CustomerStockAnalysis.dat', 'cs_cost', '') + ',' +
            GetDBColumnName('CustomerStockAnalysis.dat', 'cs_desc1', '') + ',' +
            GetDBColumnName('CustomerStockAnalysis.dat', 'cs_desc2', '') + ',' +
            GetDBColumnName('CustomerStockAnalysis.dat', 'cs_desc3', '') + ',' +
            GetDBColumnName('CustomerStockAnalysis.dat', 'cs_desc4', '') + ',' +
            GetDBColumnName('CustomerStockAnalysis.dat', 'cs_desc5', '') + ',' +
            GetDBColumnName('CustomerStockAnalysis.dat', 'cs_desc6', '') + ',' +
            GetDBColumnName('CustomerStockAnalysis.dat', 'cs_vat', '') + ',' +
            GetDBColumnName('CustomerStockAnalysis.dat', 'cs_prx_pack', '') + ',' +
            GetDBColumnName('CustomerStockAnalysis.dat', 'cs_qty_pack', '') + ',' +
            GetDBColumnName('CustomerStockAnalysis.dat', 'cs_qty_mul', '') + ',' +
            GetDBColumnName('CustomerStockAnalysis.dat', 'cs_disc_ch', '') + ',' +
            GetDBColumnName('CustomerStockAnalysis.dat', 'cs_entered', '') + ',' +
            GetDBColumnName('CustomerStockAnalysis.dat', 'cs_use_pack', '') + ',' +
            GetDBColumnName('CustomerStockAnalysis.dat', 'cs_show_case', '') + ',' +
            GetDBColumnName('CustomerStockAnalysis.dat', 'cs_line_type', '') + ',' +
            GetDBColumnName('CustomerStockAnalysis.dat', 'cs_price_mul_x', '') + ',' +
            GetDBColumnName('CustomerStockAnalysis.dat', 'cs_vat_inc_flg', '') ;
end;

function GetAllTeleSRecFields : string;
begin
  Result := GetDBColumnName('Mlocstk.dat', 'rec_pfix', '') + ',' +
            GetDBColumnName('Mlocstk.dat', 'sub_type', '') + ',' + 
            GetDBColumnName('Mlocstk.dat', 'var_code1', '') + ',' + 
            GetDBColumnName('Mlocstk.dat', 'var_code2', '') + ',' + 
            GetDBColumnName('Mlocstk.dat', 'var_code3', '') + ',' + 
            GetDBColumnName('Mlocstk.dat', 'tc_cust_code', 'TK') + ',' + 
            GetDBColumnName('Mlocstk.dat', 'tc_doc_type', 'TK') + ',' + 
            GetDBColumnName('Mlocstk.dat', 'tc_curr', 'TK') + ',' + 
            GetDBColumnName('Mlocstk.dat', 'tc_cx_rate1', 'TK') + ',' + 
            GetDBColumnName('Mlocstk.dat', 'tc_cx_rate2', 'TK') + ',' + 
            GetDBColumnName('Mlocstk.dat', 'tc_old_your_ref', 'TK') + ',' + 
            GetDBColumnName('Mlocstk.dat', 'tc_ly_ref', 'TK') + ',' + 
            GetDBColumnName('Mlocstk.dat', 'tc_cc_dep1', 'TK') + ',' + 
            GetDBColumnName('Mlocstk.dat', 'tc_cc_dep2', 'TK') + ',' + 
            GetDBColumnName('Mlocstk.dat', 'tc_loc_code', 'TK') + ',' + 
            GetDBColumnName('Mlocstk.dat', 'tc_job_code', 'TK') + ',' + 
            GetDBColumnName('Mlocstk.dat', 'tc_ja_code', 'TK') + ',' + 
            GetDBColumnName('Mlocstk.dat', 'tc_d_addr1', 'TK') + ',' + 
            GetDBColumnName('Mlocstk.dat', 'tc_d_addr2', 'TK') + ',' + 
            GetDBColumnName('Mlocstk.dat', 'tc_d_addr3', 'TK') + ',' + 
            GetDBColumnName('Mlocstk.dat', 'tc_d_addr4', 'TK') + ',' + 
            GetDBColumnName('Mlocstk.dat', 'tc_d_addr5', 'TK') + ',' + 
            GetDBColumnName('Mlocstk.dat', 'tc_t_date', 'TK') + ',' + 
            GetDBColumnName('Mlocstk.dat', 'tc_del_date', 'TK') + ',' + 
            GetDBColumnName('Mlocstk.dat', 'tc_net_total', 'TK') + ',' + 
            GetDBColumnName('Mlocstk.dat', 'tc_vat_total', 'TK') + ',' + 
            GetDBColumnName('Mlocstk.dat', 'tc_disc_total', 'TK') + ',' + 
            GetDBColumnName('Mlocstk.dat', 'tc_last_opo', 'TK') + ',' + 
            GetDBColumnName('Mlocstk.dat', 'tc_in_prog', 'TK') + ',' + 
            GetDBColumnName('Mlocstk.dat', 'tc_trans_nat', 'TK') + ',' + 
            GetDBColumnName('Mlocstk.dat', 'tc_trans_mode', 'TK') + ',' + 
            GetDBColumnName('Mlocstk.dat', 'tc_del_terms', 'TK') + ',' + 
            GetDBColumnName('Mlocstk.dat', 'tc_ctrl_code', 'TK') + ',' + 
            GetDBColumnName('Mlocstk.dat', 'tc_vat_code', 'TK') + ',' + 
            GetDBColumnName('Mlocstk.dat', 'tc_ord_mode', 'TK') + ',' + 
            GetDBColumnName('Mlocstk.dat', 'tc_scale_mode', 'TK') + ',' + 
            GetDBColumnName('Mlocstk.dat', 'tc_line_count', 'TK') + ',' + 
            GetDBColumnName('Mlocstk.dat', 'tc_was_new', 'TK') + ',' + 
            GetDBColumnName('Mlocstk.dat', 'tc_use_o_rate', 'TK') + ',' + 
            GetDBColumnName('Mlocstk.dat', 'tc_def_nom_code', 'TK') + ',' + 
            GetDBColumnName('Mlocstk.dat', 'tc_vat_inc_flg', 'TK') + ',' + 
            GetDBColumnName('Mlocstk.dat', 'tc_set_disc', 'TK') + ',' + 
            GetDBColumnName('Mlocstk.dat', 'tc_gen_mode', 'TK') + ',' + 
            GetDBColumnName('Mlocstk.dat', 'tc_tag_no', 'TK') + ',' + 
            GetDBColumnName('Mlocstk.dat', 'tc_lock_addr', 'TK') + ',' + 
            GetDBColumnName('Mlocstk.dat', 'spare2', 'TK') + ',' + 
            GetDBColumnName('Mlocstk.dat', 'tc_your_ref', 'TK') ;
end;
  
function GetAllEMUCnvRecFields : string;
begin
  Result := GetDBColumnName('Mlocstk.dat', 'rec_pfix', '') + ',' + 
            GetDBColumnName('Mlocstk.dat', 'sub_type', '') + ',' + 
            GetDBColumnName('Mlocstk.dat', 'var_code1', '') + ',' + 
            GetDBColumnName('Mlocstk.dat', 'var_code2', '') + ',' + 
            GetDBColumnName('Mlocstk.dat', 'var_code3', '') + ',' + 
            GetDBColumnName('Mlocstk.dat', 'em_was_curr', 'ED') + ',' + 
            GetDBColumnName('Mlocstk.dat', 'em_was_cx_rate1', 'ED') + ',' + 
            GetDBColumnName('Mlocstk.dat', 'em_was_cx_rate2', 'ED') + ',' + 
            GetDBColumnName('Mlocstk.dat', 'em_now_rate1', 'ED') + ',' + 
            GetDBColumnName('Mlocstk.dat', 'em_now_rate2', 'ED') + ',' + 
            GetDBColumnName('Mlocstk.dat', 'em_doc_ref', 'ED') + ',' + 
            GetDBColumnName('Mlocstk.dat', 'em_nom_code', 'ED') + ',' + 
            GetDBColumnName('Mlocstk.dat', 'em_orig_value', 'ED') ;
end;
  
function GetAllPassDefRecFields : string;
begin
  Result := GetDBColumnName('Mlocstk.dat', 'rec_pfix', '') + ',' + 
            GetDBColumnName('Mlocstk.dat', 'sub_type', '') + ',' + 
            GetDBColumnName('Mlocstk.dat', 'var_code1', '') + ',' + 
            GetDBColumnName('Mlocstk.dat', 'var_code2', '') + ',' + 
            GetDBColumnName('Mlocstk.dat', 'var_code3', '') + ',' + 
            GetDBColumnName('Mlocstk.dat', 'pw_exp_mode', 'PD') + ',' + 
            GetDBColumnName('Mlocstk.dat', 'pw_exp_days', 'PD') + ',' + 
            GetDBColumnName('Mlocstk.dat', 'pw_exp_date', 'PD') + ',' + 
            GetDBColumnName('Mlocstk.dat', 'dir_cust', 'PD') + ',' + 
            GetDBColumnName('Mlocstk.dat', 'dir_supp', 'PD') + ',' + 
            GetDBColumnName('Mlocstk.dat', 'max_sales_a', 'PD') + ',' + 
            GetDBColumnName('Mlocstk.dat', 'max_purch_a', 'PD') + ',' + 
            GetDBColumnName('Mlocstk.dat', 'cc_dep1', 'PD') + ',' + 
            GetDBColumnName('Mlocstk.dat', 'cc_dep2', 'PD') + ',' + 
            GetDBColumnName('Mlocstk.dat', 'loc', 'PD') + ',' + 
            GetDBColumnName('Mlocstk.dat', 'sales_bank', 'PD') + ',' + 
            GetDBColumnName('Mlocstk.dat', 'purch_bank', 'PD') + ',' + 
            GetDBColumnName('Mlocstk.dat', 'report_prn', 'PD') + ',' + 
            GetDBColumnName('Mlocstk.dat', 'form_prn', 'PD') + ',' + 
            GetDBColumnName('Mlocstk.dat', 'or_prns1', 'PD') + ',' + 
            GetDBColumnName('Mlocstk.dat', 'or_prns2', 'PD') + ',' + 
            GetDBColumnName('Mlocstk.dat', 'cc_dep_rule', 'PD') + ',' + 
            GetDBColumnName('Mlocstk.dat', 'loc_rule', 'PD') + ',' + 
            GetDBColumnName('Mlocstk.dat', 'email_addr', 'PD') + ',' + 
            GetDBColumnName('Mlocstk.dat', 'pw_time_out', 'PD') + ',' + 
            GetDBColumnName('Mlocstk.dat', 'loaded', 'PD') + ',' + 
            GetDBColumnName('Mlocstk.dat', 'user_name', 'PD') + ',' + 
            GetDBColumnName('Mlocstk.dat', 'uc_pr', 'PD') + ',' + 
            GetDBColumnName('Mlocstk.dat', 'uc_yr', 'PD') + ',' + 
            GetDBColumnName('Mlocstk.dat', 'udisp_pr_mnth', 'PD') ;
end;
  
function GetAllAllocCRecFields : string;
begin
  Result := GetDBColumnName('Mlocstk.dat', 'rec_pfix', '') + ',' + 
            GetDBColumnName('Mlocstk.dat', 'sub_type', '') + ',' + 
            GetDBColumnName('Mlocstk.dat', 'var_code1', '') + ',' + 
            GetDBColumnName('Mlocstk.dat', 'var_code2', '') + ',' + 
            GetDBColumnName('Mlocstk.dat', 'var_code3', '') + ',' + 
            GetDBColumnName('Mlocstk.dat', 'arc_bank_nom', 'XC') + ',' + 
            GetDBColumnName('Mlocstk.dat', 'arc_ctrl_nom', 'XC') + ',' + 
            GetDBColumnName('Mlocstk.dat', 'arc_pay_curr', 'XC') + ',' + 
            GetDBColumnName('Mlocstk.dat', 'arc_inv_curr', 'XC') + ',' + 
            GetDBColumnName('Mlocstk.dat', 'spare1', 'XC') + ',' + 
            GetDBColumnName('Mlocstk.dat', 'arc_cc_dep1', 'XC') + ',' + 
            GetDBColumnName('Mlocstk.dat', 'arc_cc_dep2', 'XC') + ',' + 
            GetDBColumnName('Mlocstk.dat', 'arc_sort_by', 'XC') + ',' + 
            GetDBColumnName('Mlocstk.dat', 'arc_auto_total', 'XC') + ',' + 
            GetDBColumnName('Mlocstk.dat', 'arc_sd_days_over', 'XC') + ',' + 
            GetDBColumnName('Mlocstk.dat', 'arc_from_trans', 'XC') + ',' + 
            GetDBColumnName('Mlocstk.dat', 'arc_old_your_ref', 'XC') + ',' + 
            GetDBColumnName('Mlocstk.dat', 'arc_cheque_no2', 'XC') + ',' + 
            GetDBColumnName('Mlocstk.dat', 'spare3', 'XC') + ',' + 
            GetDBColumnName('Mlocstk.dat', 'arc_force_new', 'XC') + ',' + 
            GetDBColumnName('Mlocstk.dat', 'arc_sort2_by', 'XC') + ',' + 
            GetDBColumnName('Mlocstk.dat', 'arc_total_own', 'XC') + ',' + 
            GetDBColumnName('Mlocstk.dat', 'arc_trans_value', 'XC') + ',' + 
            GetDBColumnName('Mlocstk.dat', 'arc_tag_count', 'XC') + ',' + 
            GetDBColumnName('Mlocstk.dat', 'arc_tag_run_date', 'XC') + ',' + 
            GetDBColumnName('Mlocstk.dat', 'arc_tag_run_yr', 'XC') + ',' + 
            GetDBColumnName('Mlocstk.dat', 'arc_tag_run_pr', 'XC') + ',' + 
            GetDBColumnName('Mlocstk.dat', 'arc_srcpi_ref', 'XC') + ',' + 
            GetDBColumnName('Mlocstk.dat', 'arc_inc_sdisc', 'XC') + ',' + 
            GetDBColumnName('Mlocstk.dat', 'arc_total', 'XC') + ',' + 
            GetDBColumnName('Mlocstk.dat', 'arc_variance', 'XC') + ',' + 
            GetDBColumnName('Mlocstk.dat', 'arc_settle_d', 'XC') + ',' + 
            GetDBColumnName('Mlocstk.dat', 'arc_trans_date', 'XC') + ',' + 
            GetDBColumnName('Mlocstk.dat', 'arc_ud1', 'XC') + ',' + 
            GetDBColumnName('Mlocstk.dat', 'arc_ud2', 'XC') + ',' + 
            GetDBColumnName('Mlocstk.dat', 'arc_ud3', 'XC') + ',' + 
            GetDBColumnName('Mlocstk.dat', 'arc_ud4', 'XC') + ',' + 
            GetDBColumnName('Mlocstk.dat', 'arc_job_code', 'XC') + ',' + 
            GetDBColumnName('Mlocstk.dat', 'arc_anal_code', 'XC') + ',' + 
            GetDBColumnName('Mlocstk.dat', 'arc_del_addr1', 'XC') + ',' + 
            GetDBColumnName('Mlocstk.dat', 'arc_del_addr2', 'XC') + ',' + 
            GetDBColumnName('Mlocstk.dat', 'arc_del_addr3', 'XC') + ',' + 
            GetDBColumnName('Mlocstk.dat', 'arc_del_addr4', 'XC') + ',' + 
            GetDBColumnName('Mlocstk.dat', 'arc_del_addr5', 'XC') + ',' + 
            GetDBColumnName('Mlocstk.dat', 'arc_inc_var', 'XC') + ',' + 
            GetDBColumnName('Mlocstk.dat', 'arc_our_ref', 'XC') + ',' + 
            GetDBColumnName('Mlocstk.dat', 'arc_cx_rate1', 'XC') + ',' + 
            GetDBColumnName('Mlocstk.dat', 'arc_cx_rate2', 'XC') + ',' + 
            GetDBColumnName('Mlocstk.dat', 'arc_opo_name', 'XC') + ',' + 
            GetDBColumnName('Mlocstk.dat', 'arc_start_date', 'XC') + ',' + 
            GetDBColumnName('Mlocstk.dat', 'arc_start_time', 'XC') + ',' + 
            GetDBColumnName('Mlocstk.dat', 'arc_win_log_in', 'XC') + ',' + 
            GetDBColumnName('Mlocstk.dat', 'arc_locked', 'XC') + ',' + 
            GetDBColumnName('Mlocstk.dat', 'arc_sales_mode', 'XC') + ',' + 
            GetDBColumnName('Mlocstk.dat', 'arc_cust_code', 'XC') + ',' + 
            GetDBColumnName('Mlocstk.dat', 'arc_use_os_ndx', 'XC') + ',' + 
            GetDBColumnName('Mlocstk.dat', 'arc_own_trans_value', 'XC') + ',' + 
            GetDBColumnName('Mlocstk.dat', 'arc_own_settle_d', 'XC') + ',' + 
            GetDBColumnName('Mlocstk.dat', 'arc_fin_var', 'XC') + ',' + 
            GetDBColumnName('Mlocstk.dat', 'arc_fin_set_d', 'XC') + ',' + 
            GetDBColumnName('Mlocstk.dat', 'arc_sort_d', 'XC') + ',' + 
            GetDBColumnName('Mlocstk.dat', 'spare4', 'XC') + ',' + 
            GetDBColumnName('Mlocstk.dat', 'arc_alloc_full', 'XC') + ',' + 
            GetDBColumnName('Mlocstk.dat', 'arc_check_fail', 'XC') + ',' + 
            GetDBColumnName('Mlocstk.dat', 'arc_charge1_gl', 'XC') + ',' + 
            GetDBColumnName('Mlocstk.dat', 'arc_charge2_gl', 'XC') + ',' + 
            GetDBColumnName('Mlocstk.dat', 'arc_charge1_amt', 'XC') + ',' + 
            GetDBColumnName('Mlocstk.dat', 'arc_charge2_amt', 'XC') + ',' + 
            GetDBColumnName('Mlocstk.dat', 'spare', 'XC') + ',' + 
            GetDBColumnName('Mlocstk.dat', 'arc_your_ref', 'XC') ;
end;
  
function GetAllbrBinRecFields : string;
begin
  Result := GetDBColumnName('Mlocstk.dat', 'rec_pfix', '') + ',' + 
            GetDBColumnName('Mlocstk.dat', 'sub_type', '') + ',' + 
            GetDBColumnName('Mlocstk.dat', 'var_code1', '') + ',' + 
            GetDBColumnName('Mlocstk.dat', 'var_code2', '') + ',' + 
            GetDBColumnName('Mlocstk.dat', 'var_code3', '') + ',' + 
            GetDBColumnName('Mlocstk.dat', 'br_in_doc', 'IR') + ',' + 
            GetDBColumnName('Mlocstk.dat', 'br_out_doc', 'IR') + ',' + 
            GetDBColumnName('Mlocstk.dat', 'br_sold', 'IR') + ',' + 
            GetDBColumnName('Mlocstk.dat', 'br_date_in', 'IR') + ',' + 
            GetDBColumnName('Mlocstk.dat', 'br_bin_cost', 'IR') + ',' + 
            GetDBColumnName('Mlocstk.dat', 'br_bin_cap', 'IR') + ',' + 
            GetDBColumnName('Mlocstk.dat', 'spare5', 'IR') + ',' + 
            GetDBColumnName('Mlocstk.dat', 'br_stk_folio', 'IR') + ',' + 
            GetDBColumnName('Mlocstk.dat', 'br_date_out', 'IR') + ',' + 
            GetDBColumnName('Mlocstk.dat', 'br_sold_line', 'IR') + ',' + 
            GetDBColumnName('Mlocstk.dat', 'br_buy_line', 'IR') + ',' + 
            GetDBColumnName('Mlocstk.dat', 'br_batch_rec', 'IR') + ',' + 
            GetDBColumnName('Mlocstk.dat', 'br_buy_qty', 'IR') + ',' + 
            GetDBColumnName('Mlocstk.dat', 'br_qty_used', 'IR') + ',' + 
            GetDBColumnName('Mlocstk.dat', 'br_batch_child', 'IR') + ',' + 
            GetDBColumnName('Mlocstk.dat', 'br_in_mloc', 'IR') + ',' + 
            GetDBColumnName('Mlocstk.dat', 'br_out_mloc', 'IR') + ',' + 
            GetDBColumnName('Mlocstk.dat', 'br_out_ord_doc', 'IR') + ',' + 
            GetDBColumnName('Mlocstk.dat', 'br_in_ord_doc', 'IR') + ',' + 
            GetDBColumnName('Mlocstk.dat', 'br_in_ord_line', 'IR') + ',' + 
            GetDBColumnName('Mlocstk.dat', 'br_out_ord_line', 'IR') + ',' + 
            GetDBColumnName('Mlocstk.dat', 'br_cur_cost', 'IR') + ',' + 
            GetDBColumnName('Mlocstk.dat', 'br_priority', 'IR') + ',' + 
            GetDBColumnName('Mlocstk.dat', 'br_bin_sell', 'IR') + ',' + 
            GetDBColumnName('Mlocstk.dat', 'br_Ser_CRates1', 'IR') + ',' + 
            GetDBColumnName('Mlocstk.dat', 'br_Ser_CRates2', 'IR') + ',' + 
            GetDBColumnName('Mlocstk.dat', 'br_suse_o_rate', 'IR') + ',' + 
            GetDBColumnName('Mlocstk.dat', 'brSer_TriRates', 'IR') + ',' + 
            GetDBColumnName('Mlocstk.dat', 'brSer_TriEuro', 'IR') + ',' + 
            GetDBColumnName('Mlocstk.dat', 'brSer_TriInvert', 'IR') + ',' + 
            GetDBColumnName('Mlocstk.dat', 'brSer_TriFloat', 'IR') + ',' + 
            GetDBColumnName('Mlocstk.dat', 'brSer_Spare', 'IR') + ',' + 
            GetDBColumnName('Mlocstk.dat', 'br_date_use_x', 'IR') + ',' + 
            GetDBColumnName('Mlocstk.dat', 'br_cur_sell', 'IR') + ',' + 
            GetDBColumnName('Mlocstk.dat', 'br_uom', 'IR') + ',' + 
            GetDBColumnName('Mlocstk.dat', 'br_hold_flg', 'IR') + ',' + 
            GetDBColumnName('Mlocstk.dat', 'br_tag_no', 'IR') + ',' + 
            GetDBColumnName('Mlocstk.dat', 'br_return_bin', 'IR') ;
end;
  
function GetAllBnkRHRecFields : string;
begin
  Result := GetDBColumnName('Mlocstk.dat', 'rec_pfix', '') + ',' + 
            GetDBColumnName('Mlocstk.dat', 'sub_type', '') + ',' + 
            GetDBColumnName('Mlocstk.dat', 'var_code1', '') + ',' + 
            GetDBColumnName('Mlocstk.dat', 'var_code2', '') + ',' + 
            GetDBColumnName('Mlocstk.dat', 'var_code3', '') + ',' + 
            GetDBColumnName('Mlocstk.dat', 'br_stat_date', 'K1') + ',' + 
            GetDBColumnName('Mlocstk.dat', 'br_stat_ref', 'K1') + ',' + 
            GetDBColumnName('Mlocstk.dat', 'br_bank_acc', 'K1') + ',' + 
            GetDBColumnName('Mlocstk.dat', 'br_bank_currency', 'K1') + ',' + 
            GetDBColumnName('Mlocstk.dat', 'br_bank_user_id', 'K1') + ',' + 
            GetDBColumnName('Mlocstk.dat', 'br_create_date', 'K1') + ',' + 
            GetDBColumnName('Mlocstk.dat', 'br_create_time', 'K1') + ',' + 
            GetDBColumnName('Mlocstk.dat', 'br_stat_bal', 'K1') + ',' + 
            GetDBColumnName('Mlocstk.dat', 'br_open_bal', 'K1') + ',' + 
            GetDBColumnName('Mlocstk.dat', 'br_close_bal', 'K1') + ',' + 
            GetDBColumnName('Mlocstk.dat', 'br_status', 'K1') + ',' + 
            GetDBColumnName('Mlocstk.dat', 'br_int_ref', 'K1') + ',' + 
            GetDBColumnName('Mlocstk.dat', 'br_glcode', 'K1') + ',' + 
            GetDBColumnName('Mlocstk.dat', 'br_stat_folio', 'K1') + ',' + 
            GetDBColumnName('Mlocstk.dat', 'br_recon_date', 'K1') + ',' + 
            GetDBColumnName('Mlocstk.dat', 'br_recon_ref', 'K1') + ',' + 
            GetDBColumnName('Mlocstk.dat', 'br_init_seq', 'K1') ;
end;
  
function GetAllBnkRDRecFields : string;
begin
  Result := GetDBColumnName('Mlocstk.dat', 'rec_pfix', '') + ',' + 
            GetDBColumnName('Mlocstk.dat', 'sub_type', '') + ',' + 
            GetDBColumnName('Mlocstk.dat', 'var_code1', '') + ',' + 
            GetDBColumnName('Mlocstk.dat', 'var_code2', '') + ',' + 
            GetDBColumnName('Mlocstk.dat', 'var_code3', '') + ',' + 
            GetDBColumnName('Mlocstk.dat', 'br_pay_ref', 'K2') + ',' + 
            GetDBColumnName('Mlocstk.dat', 'br_line_date', 'K2') + ',' + 
            GetDBColumnName('Mlocstk.dat', 'br_match_ref', 'K2') + ',' + 
            GetDBColumnName('Mlocstk.dat', 'br_value', 'K2') + ',' + 
            GetDBColumnName('Mlocstk.dat', 'br_line_no', 'K2') + ',' + 
            GetDBColumnName('Mlocstk.dat', 'br_stat_id', 'K2') + ',' + 
            GetDBColumnName('Mlocstk.dat', 'br_stat_line', 'K2') + ',' + 
            GetDBColumnName('Mlocstk.dat', 'br_cust_code', 'K2') + ',' + 
            GetDBColumnName('Mlocstk.dat', 'br_period', 'K2') + ',' + 
            GetDBColumnName('Mlocstk.dat', 'br_year', 'K2') + ',' + 
            GetDBColumnName('Mlocstk.dat', 'br_CX_Rate1', 'K2') + ',' + 
            GetDBColumnName('Mlocstk.dat', 'br_CX_Rate2', 'K2') + ',' + 
            GetDBColumnName('Mlocstk.dat', 'br_l_use_o_rate', 'K2') + ',' + 
            GetDBColumnName('Mlocstk.dat', 'brCur_TriRate', 'K2') + ',' + 
            GetDBColumnName('Mlocstk.dat', 'brCur_TriEuro', 'K2') + ',' + 
            GetDBColumnName('Mlocstk.dat', 'brCur_TriInvert', 'K2') + ',' + 
            GetDBColumnName('Mlocstk.dat', 'brCur_TriFloat', 'K2') + ',' + 
            GetDBColumnName('Mlocstk.dat', 'brCur_Spare', 'K2') + ',' + 
            GetDBColumnName('Mlocstk.dat', 'br_old_your_ref', 'K2') + ',' + 
            GetDBColumnName('Mlocstk.dat', 'br_trans_value', 'K2') + ',' + 
            GetDBColumnName('Mlocstk.dat', 'br_cc_dep1', 'K2') + ',' + 
            GetDBColumnName('Mlocstk.dat', 'br_cc_dep2', 'K2') + ',' + 
            GetDBColumnName('Mlocstk.dat', 'br_nom_code', 'K2') + ',' + 
            GetDBColumnName('Mlocstk.dat', 'br_sri_nom_code', 'K2') + ',' + 
            GetDBColumnName('Mlocstk.dat', 'br_folio_link', 'K2') + ',' + 
            GetDBColumnName('Mlocstk.dat', 'br_vat_code', 'K2') + ',' + 
            GetDBColumnName('Mlocstk.dat', 'br_vat_amount', 'K2') + ',' + 
            GetDBColumnName('Mlocstk.dat', 'br_trans_date', 'K2') + ',' + 
            GetDBColumnName('Mlocstk.dat', 'br_is_new_trans', 'K2') + ',' + 
            GetDBColumnName('Mlocstk.dat', 'br_line_status', 'K2') + ',' + 
            GetDBColumnName('Mlocstk.dat', 'spare6', 'K2') + ',' + 
            GetDBColumnName('Mlocstk.dat', 'br_your_ref', 'K2') ;
end;
  
function GetAllBACSDbRecFields : string;
begin
  Result := GetDBColumnName('Mlocstk.dat', 'rec_pfix', '') + ',' + 
            GetDBColumnName('Mlocstk.dat', 'sub_type', '') + ',' + 
            GetDBColumnName('Mlocstk.dat', 'var_code1', '') + ',' + 
            GetDBColumnName('Mlocstk.dat', 'var_code2', '') + ',' + 
            GetDBColumnName('Mlocstk.dat', 'var_code3', '') + ',' + 
            GetDBColumnName('Mlocstk.dat', 'br_acc_nom', 'K3') + ',' + 
            GetDBColumnName('Mlocstk.dat', 'br_bank_prod', 'K3') + ',' + 
            GetDBColumnName('Mlocstk.dat', 'br_pay_path', 'K3') + ',' + 
            GetDBColumnName('Mlocstk.dat', 'br_pay_file_name', 'K3') + ',' + 
            GetDBColumnName('Mlocstk.dat', 'br_rec_file_name', 'K3') + ',' + 
            GetDBColumnName('Mlocstk.dat', 'br_stat_path', 'K3') + ',' + 
            GetDBColumnName('Mlocstk.dat', 'br_swift_ref1', 'K3') + ',' + 
            GetDBColumnName('Mlocstk.dat', 'br_swift_ref2', 'K3') + ',' + 
            GetDBColumnName('Mlocstk.dat', 'br_swift_ref3', 'K3') + ',' + 
            GetDBColumnName('Mlocstk.dat', 'br_swift_bic', 'K3') + ',' + 
            GetDBColumnName('Mlocstk.dat', 'br_route_code', 'K3') + ',' + 
            GetDBColumnName('Mlocstk.dat', 'br_charge_inst', 'K3') + ',' + 
            GetDBColumnName('Mlocstk.dat', 'br_route_method', 'K3') + ',' + 
            GetDBColumnName('Mlocstk.dat', 'br_last_use_date', 'K3') + ',' + 
            GetDBColumnName('Mlocstk.dat', 'br_sort_code', 'K3') + ',' + 
            GetDBColumnName('Mlocstk.dat', 'br_account_code', 'K3') + ',' + 
            GetDBColumnName('Mlocstk.dat', 'br_bank_ref', 'K3') + ',' + 
            GetDBColumnName('Mlocstk.dat', 'br_bacs_user_id', 'K3') + ',' + 
            GetDBColumnName('Mlocstk.dat', 'br_bacs_currency', 'K3') + ',' + 
            GetDBColumnName('Mlocstk.dat', 'br_user_id2', 'K3') + ',' +
            GetDBColumnName('Mlocstk.dat', 'br_sort_code_ex', 'K3') + ',' +
            GetDBColumnName('Mlocstk.dat', 'br_account_code_ex', 'K3') ;
end;
  
function GetAlleBankHRecFields : string;
begin
  Result := GetDBColumnName('Mlocstk.dat', 'rec_pfix', '') + ',' + 
            GetDBColumnName('Mlocstk.dat', 'sub_type', '') + ',' + 
            GetDBColumnName('Mlocstk.dat', 'var_code1', '') + ',' + 
            GetDBColumnName('Mlocstk.dat', 'var_code2', '') + ',' + 
            GetDBColumnName('Mlocstk.dat', 'var_code3', '') + ',' + 
            GetDBColumnName('Mlocstk.dat', 'eb_acc_nom', 'K4') + ',' + 
            GetDBColumnName('Mlocstk.dat', 'eb_stat_ref', 'K4') + ',' + 
            GetDBColumnName('Mlocstk.dat', 'eb_stat_ind', 'K4') + ',' + 
            GetDBColumnName('Mlocstk.dat', 'eb_source_file', 'K4') + ',' + 
            GetDBColumnName('Mlocstk.dat', 'eb_int_ref', 'K4') + ',' + 
            GetDBColumnName('Mlocstk.dat', 'eb_stat_date', 'K4') ;
end;
  
function GetAlleBankLRecFields : string;
begin
  Result := GetDBColumnName('Mlocstk.dat', 'rec_pfix', '') + ',' + 
            GetDBColumnName('Mlocstk.dat', 'sub_type', '') + ',' + 
            GetDBColumnName('Mlocstk.dat', 'var_code1', '') + ',' + 
            GetDBColumnName('Mlocstk.dat', 'var_code2', '') + ',' + 
            GetDBColumnName('Mlocstk.dat', 'var_code3', '') + ',' + 
            GetDBColumnName('Mlocstk.dat', 'eb_line_no', 'K5') + ',' + 
            GetDBColumnName('Mlocstk.dat', 'eb_line_date', 'K5') + ',' + 
            GetDBColumnName('Mlocstk.dat', 'eb_line_ref', 'K5') + ',' + 
            GetDBColumnName('Mlocstk.dat', 'eb_line_value', 'K5') + ',' + 
            GetDBColumnName('Mlocstk.dat', 'eb_line_int_ref', 'K5') + ',' + 
            GetDBColumnName('Mlocstk.dat', 'eb_match_str', 'K5') + ',' + 
            GetDBColumnName('Mlocstk.dat', 'eb_glcode', 'K5') + ',' + 
            GetDBColumnName('Mlocstk.dat', 'eb_line_ref2', 'K5') + ',' + 
            GetDBColumnName('Mlocstk.dat', 'eb_line_status', 'K5') ;
end;
  
function GetAllNominalFields : string;
begin
  Result := GetDBColumnName('Nominal.dat', 'f_nom_code', '') + ',' + 
            GetDBColumnName('Nominal.dat', 'f_description', '') + ',' + 
            GetDBColumnName('Nominal.dat', 'f_category', '') + ',' + 
            GetDBColumnName('Nominal.dat', 'f_nom_type', '') + ',' + 
            GetDBColumnName('Nominal.dat', 'f_nom_page', '') + ',' + 
            GetDBColumnName('Nominal.dat', 'f_sub_type', '') + ',' + 
            GetDBColumnName('Nominal.dat', 'f_total', '') + ',' + 
            GetDBColumnName('Nominal.dat', 'f_carry_f', '') + ',' + 
            GetDBColumnName('Nominal.dat', 'f_re_value', '') + ',' + 
            GetDBColumnName('Nominal.dat', 'f_alt_code', '') + ',' + 
            GetDBColumnName('Nominal.dat', 'f_private_rec', '') + ',' + 
            GetDBColumnName('Nominal.dat', 'f_def_curr', '') + ',' + 
            GetDBColumnName('Nominal.dat', 'f_force_jc', '') + ',' + 
            GetDBColumnName('Nominal.dat', 'f_hide_ac', '') + ',' + 
            GetDBColumnName('Nominal.dat', 'f_nom_class', '') + ',' + 
            GetDBColumnName('Nominal.dat', 'f_spare', '') + ',' + 
            GetDBColumnName('Nominal.dat', 'f_nom_str', '') ;
end;
  
function GetAllNomViewTypeFields : string;
begin
  Result := GetDBColumnName('Nomview.dat', 'rec_pfix', '') + ',' + 
            GetDBColumnName('Nomview.dat', 'sub_type', '') + ',' + 
            GetDBColumnName('Nomview.dat', 'nvc_code1', '') + ',' + 
            GetDBColumnName('Nomview.dat', 'nvc_code2', '') + ',' + 
            GetDBColumnName('Nomview.dat', 'nvc_code3', '') + ',' + 
            GetDBColumnName('Nomview.dat', 'nvc_code4', '') + ',' + 
            GetDBColumnName('Nomview.dat', 'nom_view_no_index_lint', '') + ',' + 
            GetDBColumnName('Nomview.dat', 'nvc_code5', '') + ',' + 
            GetDBColumnName('Nomview.dat', 'view_code', 'NV') + ',' + 
            GetDBColumnName('Nomview.dat', 'view_idx', 'NV') + ',' + 
            GetDBColumnName('Nomview.dat', 'view_cat', 'NV') + ',' + 
            GetDBColumnName('Nomview.dat', 'view_type', 'NV') + ',' + 
            GetDBColumnName('Nomview.dat', 'carry_f', 'NV') + ',' + 
            GetDBColumnName('Nomview.dat', 'alt_code', 'NV') + ',' + 
            GetDBColumnName('Nomview.dat', 'link_view', 'NV') + ',' + 
            GetDBColumnName('Nomview.dat', 'link_gl', 'NV') + ',' + 
            GetDBColumnName('Nomview.dat', 'link_cc_dep1', 'NV') + ',' + 
            GetDBColumnName('Nomview.dat', 'link_cc_dep2', 'NV') + ',' + 
            GetDBColumnName('Nomview.dat', 'inc_budget', 'NV') + ',' + 
            GetDBColumnName('Nomview.dat', 'inc_commit', 'NV') + ',' + 
            GetDBColumnName('Nomview.dat', 'inc_unposted', 'NV') + ',' + 
            GetDBColumnName('Nomview.dat', 'auto_desc', 'NV') + ',' + 
            GetDBColumnName('Nomview.dat', 'link_type', 'NV') + ',' + 
            GetDBColumnName('Nomview.dat', 'abs_view_idx', 'NV') ;
end;
  
function GetAllViewCtrlTypeFields : string;
begin
  Result := GetDBColumnName('Nomview.dat', 'rec_pfix', '') + ',' + 
            GetDBColumnName('Nomview.dat', 'sub_type', '') + ',' + 
            GetDBColumnName('Nomview.dat', 'nvc_code1', '') + ',' + 
            GetDBColumnName('Nomview.dat', 'nvc_code2', '') + ',' + 
            GetDBColumnName('Nomview.dat', 'nvc_code3', '') + ',' + 
            GetDBColumnName('Nomview.dat', 'nvc_code4', '') + ',' + 
            GetDBColumnName('Nomview.dat', 'nom_view_no_index_lint', '') + ',' + 
            GetDBColumnName('Nomview.dat', 'nvc_code5', '') + ',' + 
            GetDBColumnName('Nomview.dat', 'def_curr', 'NC') + ',' + 
            GetDBColumnName('Nomview.dat', 'def_period', 'NC') + ',' + 
            GetDBColumnName('Nomview.dat', 'def_period_to', 'NC') + ',' + 
            GetDBColumnName('Nomview.dat', 'def_year', 'NC') + ',' + 
            GetDBColumnName('Nomview.dat', 'view_ctrl_no', 'NC') + ',' + 
            GetDBColumnName('Nomview.dat', 'last_period', 'NC') + ',' + 
            GetDBColumnName('Nomview.dat', 'last_year', 'NC') + ',' + 
            GetDBColumnName('Nomview.dat', 'ctrl_cc_dep1', 'NC') + ',' + 
            GetDBColumnName('Nomview.dat', 'ctrl_cc_dep2', 'NC') + ',' + 
            GetDBColumnName('Nomview.dat', 'ctrl_budget', 'NC') + ',' + 
            GetDBColumnName('Nomview.dat', 'ctrl_commit', 'NC') + ',' + 
            GetDBColumnName('Nomview.dat', 'ctrl_unposted', 'NC') + ',' + 
            GetDBColumnName('Nomview.dat', 'auto_struct', 'NC') + ',' + 
            GetDBColumnName('Nomview.dat', 'last_prun_no', 'NC') + ',' + 
            GetDBColumnName('Nomview.dat', 'spare_pad', 'NC') + ',' + 
            GetDBColumnName('Nomview.dat', 'last_update', 'NC') + ',' + 
            GetDBColumnName('Nomview.dat', 'last_opo', 'NC') + ',' + 
            GetDBColumnName('Nomview.dat', 'in_active', 'NC') + ',' + 
            GetDBColumnName('Nomview.dat', 'def_curr_tx', 'NC') + ',' + 
            GetDBColumnName('Nomview.dat', 'def_ytd', 'NC') + ',' + 
            GetDBColumnName('Nomview.dat', 'def_use_f6', 'NC') + ',' + 
            GetDBColumnName('Nomview.dat', 'loaded_ok', 'NC') ;
end;
  
function GetAllPAAUTHFields : string;
begin
  Result := GetDBColumnName('PAAUTH.dat', 'Company', '') + ',' + 
            GetDBColumnName('PAAUTH.dat', 'auName', '') + ',' + 
            GetDBColumnName('PAAUTH.dat', 'auMaxAuthAmount', '') + ',' + 
            GetDBColumnName('PAAUTH.dat', 'auEndAmountchar', '') + ',' + 
            GetDBColumnName('PAAUTH.dat', 'auEMail', '') + ',' + 
            GetDBColumnName('PAAUTH.dat', 'auAuthCode', '') + ',' + 
            GetDBColumnName('PAAUTH.dat', 'auAuthSQU', '') + ',' + 
            GetDBColumnName('PAAUTH.dat', 'auAuthPQU', '') + ',' + 
            GetDBColumnName('PAAUTH.dat', 'auAuthPOR', '') + ',' + 
            GetDBColumnName('PAAUTH.dat', 'auAuthPIN', '') + ',' + 
            GetDBColumnName('PAAUTH.dat', 'Active', '') + ',' + 
            GetDBColumnName('PAAUTH.dat', 'auApprovalOnly', '') + ',' + 
            GetDBColumnName('PAAUTH.dat', 'auCompressAttachments', '') + ',' + 
            GetDBColumnName('PAAUTH.dat', 'auDefaultAuth', '') + ',' + 
            GetDBColumnName('PAAUTH.dat', 'auAlternate', '') + ',' + 
            GetDBColumnName('PAAUTH.dat', 'auAltAfter', '') + ',' + 
            GetDBColumnName('PAAUTH.dat', 'auAltHours', '') + ',' + 
            GetDBColumnName('PAAUTH.dat', 'auDisplayEmail', '') ;
end;
  
function GetAllPACOMPFields : string;
begin
  Result := GetDBColumnName('PACOMP.dat', 'company', '') + ',' + 
            GetDBColumnName('PACOMP.dat', 'spauthsqu', '') + ',' + 
            GetDBColumnName('PACOMP.dat', 'spauthpqu', '') + ',' + 
            GetDBColumnName('PACOMP.dat', 'spauthpor', '') + ',' + 
            GetDBColumnName('PACOMP.dat', 'spauthpin', '') + ',' + 
            GetDBColumnName('PACOMP.dat', 'spsquform', '') + ',' + 
            GetDBColumnName('PACOMP.dat', 'sppquform', '') + ',' + 
            GetDBColumnName('PACOMP.dat', 'spporform', '') + ',' + 
            GetDBColumnName('PACOMP.dat', 'sppinform', '') + ',' + 
            GetDBColumnName('PACOMP.dat', 'spauthmode', '') + ',' + 
            GetDBColumnName('PACOMP.dat', 'spallowprint', '') + ',' + 
            GetDBColumnName('PACOMP.dat', 'spflooronpins', '') + ',' + 
            GetDBColumnName('PACOMP.dat', 'spauthonconvert', '') + ',' + 
            GetDBColumnName('PACOMP.dat', 'sppintolerance', '') + ',' + 
            GetDBColumnName('PACOMP.dat', 'splastpincheck', '') + ',' + 
            GetDBColumnName('PACOMP.dat', 'sppincheckinterval', '') ;
end;
  
function GetAllPAEARFields : string;
begin
  Result := GetDBColumnName('PAEAR.dat', 'Company', '') + ',' + 
            GetDBColumnName('PAEAR.dat', 'reEAR', '') + ',' + 
            GetDBColumnName('PAEAR.dat', 'reOurRef', '') + ',' + 
            GetDBColumnName('PAEAR.dat', 'reUserID', '') + ',' + 
            GetDBColumnName('PAEAR.dat', 'reTimeStamp', '') + ',' + 
            GetDBColumnName('PAEAR.dat', 'reTotalValue', '') + ',' + 
            GetDBColumnName('PAEAR.dat', 'reStatus', '') + ',' + 
            GetDBColumnName('PAEAR.dat', 'reApprovedBy', '') + ',' + 
            GetDBColumnName('PAEAR.dat', 'reAuthoriser', '') + ',' + 
            GetDBColumnName('PAEAR.dat', 'reFolio', '') + ',' + 
            GetDBColumnName('PAEAR.dat', 'reDocType', '') + ',' + 
            GetDBColumnName('PAEAR.dat', 'reSupplier', '') + ',' + 
            GetDBColumnName('PAEAR.dat', 'reLineCount', '') + ',' + 
            GetDBColumnName('PAEAR.dat', 'reCheckSum', '') + ',' + 
            GetDBColumnName('PAEAR.dat', 'reApprovalDateTime', '') + ',' + 
            GetDBColumnName('PAEAR.dat', 'reAdminNotified', '') + ',' + 
            GetDBColumnName('PAEAR.dat', 'reAlreadySent', '') + ',' + 
            GetDBColumnName('PAEAR.dat', 'rePrevDate', '') ;
end;
  
function GetAllPAGLOBALFields : string;
begin
  Result := GetDBColumnName('PAGLOBAL.dat', 'spCompany', '') + ',' + 
            GetDBColumnName('PAGLOBAL.dat', 'spFrequency', '') + ',' + 
            GetDBColumnName('PAGLOBAL.dat', 'spAccountName', '') + ',' + 
            GetDBColumnName('PAGLOBAL.dat', 'spAccountPWord', '') + ',' + 
            GetDBColumnName('PAGLOBAL.dat', 'spEMail', '') + ',' + 
            GetDBColumnName('PAGLOBAL.dat', 'spAdminEMail', '') + ',' + 
            GetDBColumnName('PAGLOBAL.dat', 'spOfflineStart', '') + ',' + 
            GetDBColumnName('PAGLOBAL.dat', 'spOfflineFinish', '') + ',' + 
            GetDBColumnName('PAGLOBAL.dat', 'spEARTimeOut', '') + ',' + 
            GetDBColumnName('PAGLOBAL.dat', 'spPassword', '') + ',' + 
            GetDBColumnName('PAGLOBAL.dat', 'spServer', '') + ',' + 
            GetDBColumnName('PAGLOBAL.dat', 'spUseMapi', '') ;
end;
  
function GetAllPapersizeFields : string;
begin
  Result := GetDBColumnName('Papersize.dat', 'f_ps_user', '') + ',' + 
            GetDBColumnName('Papersize.dat', 'f_ps_descr', '') + ',' + 
            GetDBColumnName('Papersize.dat', 'f_ps_height', '') + ',' + 
            GetDBColumnName('Papersize.dat', 'f_ps_width', '') + ',' + 
            GetDBColumnName('Papersize.dat', 'f_ps_top_waste', '') + ',' + 
            GetDBColumnName('Papersize.dat', 'f_ps_bottom_waste', '') + ',' + 
            GetDBColumnName('Papersize.dat', 'f_ps_left_waste', '') + ',' + 
            GetDBColumnName('Papersize.dat', 'f_ps_right_waste', '') ;
end;
  
function GetAllPAUSERFields : string;
begin
  Result := GetDBColumnName('PAUSER.dat', 'usCompany', '') + ',' + 
            GetDBColumnName('PAUSER.dat', 'usUserID', '') + ',' + 
            GetDBColumnName('PAUSER.dat', 'usUserName', '') + ',' + 
            GetDBColumnName('PAUSER.dat', 'usEMail', '') + ',' + 
            GetDBColumnName('PAUSER.dat', 'usFloorLimit', '') + ',' + 
            GetDBColumnName('PAUSER.dat', 'usAuthAmount', '') + ',' + 
            GetDBColumnName('PAUSER.dat', 'usSendOptions', '') + ',' + 
            GetDBColumnName('PAUSER.dat', 'usDefaultApprover', '') + ',' + 
            GetDBColumnName('PAUSER.dat', 'usDefaultAuthoriser', '') ;
end;
  
function GetAllPPCUSTFields : string;
begin
  Result := GetDBColumnName('PPCUST.dat', 'ppcCustCode', '') + ',' + 
            GetDBColumnName('PPCUST.dat', 'ppcDefaultRate', '') + ',' + 
            GetDBColumnName('PPCUST.dat', 'ppcInterestVariance', '') + ',' + 
            GetDBColumnName('PPCUST.dat', 'ppcCreditDaysOffset', '') + ',' + 
            GetDBColumnName('PPCUST.dat', 'ppcMinInvoiceValue', '') + ',' + 
            GetDBColumnName('PPCUST.dat', 'ppcInterestGLCode', '') + ',' + 
            GetDBColumnName('PPCUST.dat', 'ppcDebtChargeGLCode', '') + ',' + 
            GetDBColumnName('PPCUST.dat', 'ppcCostCentre', '') + ',' + 
            GetDBColumnName('PPCUST.dat', 'ppcDepartment', '') + ',' + 
            GetDBColumnName('PPCUST.dat', 'ppcDebitChargeBasis', '') + ',' + 
            GetDBColumnName('PPCUST.dat', 'ppcActive', '') + ',' + 
            GetDBColumnName('PPCUST.dat', 'ppcSyncGLCodes', '') + ',' + 
            GetDBColumnName('PPCUST.dat', 'ppcDummyChar', '') ;
end;
  
function GetAllPPDEBTFields : string;
begin
  Result := GetDBColumnName('PPDEBT.dat', 'ppdFolioNo', '') + ',' + 
            GetDBColumnName('PPDEBT.dat', 'ppdCustCode', '') + ',' + 
            GetDBColumnName('PPDEBT.dat', 'ppdValueFrom', '') + ',' + 
            GetDBColumnName('PPDEBT.dat', 'ppdValueTo', '') + ',' + 
            GetDBColumnName('PPDEBT.dat', 'ppdCharge', '') + ',' + 
            GetDBColumnName('PPDEBT.dat', 'ppdDummyChar', '') + ',' + 
            GetDBColumnName('PPDEBT.dat', 'ppdSpare', '') ;
end;
  
function GetAllPPSETUPFields : string;
begin
  Result := GetDBColumnName('PPSETUP.dat', 'ppsfoliono', '') + ',' + 
            GetDBColumnName('PPSETUP.dat', 'ppsdaysfield', '') + ',' + 
            GetDBColumnName('PPSETUP.dat', 'ppsholdflagfield', '') + ',' + 
            GetDBColumnName('PPSETUP.dat', 'ppsdummychar', '') + ',' + 
            GetDBColumnName('PPSETUP.dat', 'ppsbaseinterestonduedate', '') ;
end;
  
function GetAllReportsFields : string;
begin
  Result := GetDBColumnName('Reports.dat', 'f_field_1', '') + ',' + 
            GetDBColumnName('Reports.dat', 'f_field_3', '') + ',' + 
            GetDBColumnName('Reports.dat', 'f_field_4', '') + ',' + 
            GetDBColumnName('Reports.dat', 'f_field_24', '') + ',' + 
            GetDBColumnName('Reports.dat', 'f_field_51', '') ;
end;
  
function GetAllSALECODEFields : string;
begin
  Result := GetDBColumnName('SALECODE.dat', 'scFolioNo', '') + ',' + 
            GetDBColumnName('SALECODE.dat', 'scSalesCode', '') + ',' + 
            GetDBColumnName('SALECODE.dat', 'scDescription', '') + ',' + 
            GetDBColumnName('SALECODE.dat', 'scSalesCodeType', '') + ',' + 
            GetDBColumnName('SALECODE.dat', 'scDefCommissionBasis', '') + ',' + 
            GetDBColumnName('SALECODE.dat', 'scStatus', '') + ',' + 
            GetDBColumnName('SALECODE.dat', 'scEntSupplierCode', '') + ',' + 
            GetDBColumnName('SALECODE.dat', 'scEntGLCode', '') + ',' + 
            GetDBColumnName('SALECODE.dat', 'scEntCostCentre', '') + ',' + 
            GetDBColumnName('SALECODE.dat', 'scEntDepartment', '') + ',' + 
            GetDBColumnName('SALECODE.dat', 'scEntInvCurrency', '') + ',' + 
            GetDBColumnName('SALECODE.dat', 'scDefCommission', '') + ',' + 
            GetDBColumnName('SALECODE.dat', 'scDefCommissionType', '') + ',' + 
            GetDBColumnName('SALECODE.dat', 'scDummyChar', '') ;
end;
  
function GetAllSCHEDCFGFields : string;
begin
  Result := GetDBColumnName('SCHEDCFG.dat', 'scid', '') + ',' + 
            GetDBColumnName('SCHEDCFG.dat', 'scofflinestart', '') + ',' + 
            GetDBColumnName('SCHEDCFG.dat', 'scofflineend', '') + ',' + 
            GetDBColumnName('SCHEDCFG.dat', 'scdefaultemail', '') ;
end;
  
function GetAllSCHEDULEFields : string;
begin
  Result := GetDBColumnName('SCHEDULE.dat', 'sttasktype', '') + ',' + 
            GetDBColumnName('SCHEDULE.dat', 'sttaskname', '') + ',' + 
            GetDBColumnName('SCHEDULE.dat', 'stnextrundue', '') + ',' + 
            GetDBColumnName('SCHEDULE.dat', 'sttaskid', '') + ',' + 
            GetDBColumnName('SCHEDULE.dat', 'stscheduletype', '') + ',' + 
            GetDBColumnName('SCHEDULE.dat', 'stdaynumber', '') + ',' + 
            GetDBColumnName('SCHEDULE.dat', 'sttimeofday', '') + ',' + 
            GetDBColumnName('SCHEDULE.dat', 'stinterval', '') + ',' + 
            GetDBColumnName('SCHEDULE.dat', 'ststarttime', '') + ',' + 
            GetDBColumnName('SCHEDULE.dat', 'stendtime', '') + ',' + 
            GetDBColumnName('SCHEDULE.dat', 'ststatus', '') + ',' + 
            GetDBColumnName('SCHEDULE.dat', 'stemailaddress', '') + ',' + 
            GetDBColumnName('SCHEDULE.dat', 'stlastrun', '') + ',' + 
            GetDBColumnName('SCHEDULE.dat', 'stlastupdated', '') + ',' + 
            GetDBColumnName('SCHEDULE.dat', 'stlastupdatedby', '') + ',' + 
            GetDBColumnName('SCHEDULE.dat', 'sttimetype', '') + ',' + 
            GetDBColumnName('SCHEDULE.dat', 'stincludeinPost', '') + ',' + 
            GetDBColumnName('SCHEDULE.dat', 'stpostprotected', '') + ',' + 
            GetDBColumnName('SCHEDULE.dat', 'stpostseparated', '') + ',' + 
            GetDBColumnName('SCHEDULE.dat', 'stcustomclassName', '') ;
end;
  
function GetAllSCTYPEFields : string;
begin
  Result := GetDBColumnName('SCTYPE.dat', 'sctFolioNo', '') + ',' + 
            GetDBColumnName('SCTYPE.dat', 'sctDescription', '') + ',' + 
            GetDBColumnName('SCTYPE.dat', 'sctDummyChar', '') ;
end;
  
function GetAllSentFields : string;
begin
  Result := GetDBColumnName('Sent.dat', 'f_not_used', '') + ',' + 
            GetDBColumnName('Sent.dat', 'f_el_user_id', '') + ',' + 
            GetDBColumnName('Sent.dat', 'f_el_elert_name', '') + ',' + 
            GetDBColumnName('Sent.dat', 'f_f_el_type', '') + ',' + 
            GetDBColumnName('Sent.dat', 'f_f_el_priority', '') + ',' + 
            GetDBColumnName('Sent.dat', 'f_el_window_id', '') + ',' + 
            GetDBColumnName('Sent.dat', 'f_el_handler_id', '') + ',' + 
            GetDBColumnName('Sent.dat', 'f_el_term_char', '') + ',' + 
            GetDBColumnName('Sent.dat', 'f_el_description', '') + ',' + 
            GetDBColumnName('Sent.dat', 'f_el_active', '') + ',' + 
            GetDBColumnName('Sent.dat', 'f_el_time_type', '') + ',' + 
            GetDBColumnName('Sent.dat', 'f_el_frequency', '') + ',' + 
            GetDBColumnName('Sent.dat', 'f_el_time1', '') + ',' + 
            GetDBColumnName('Sent.dat', 'f_el_time2', '') + ',' + 
            GetDBColumnName('Sent.dat', 'f_el_days_of_week', '') + ',' + 
            GetDBColumnName('Sent.dat', 'f_el_fileno', '') + ',' + 
            GetDBColumnName('Sent.dat', 'f_el_index_no', '') + ',' + 
            GetDBColumnName('Sent.dat', 'f_range_start_eg_type', '') + ',' + 
            GetDBColumnName('Sent.dat', 'f_range_start_eg_string', '') + ',' + 
            GetDBColumnName('Sent.dat', 'f_range_start_eg_int', '') + ',' + 
            GetDBColumnName('Sent.dat', 'f_range_start_eg_offset', '') + ',' + 
            GetDBColumnName('Sent.dat', 'f_range_start_eg_input', '') + ',' + 
            GetDBColumnName('Sent.dat', 'f_range_start_spare', '') + ',' + 
            GetDBColumnName('Sent.dat', 'f_range_end_eg_type', '') + ',' + 
            GetDBColumnName('Sent.dat', 'f_range_end_eg_string', '') + ',' + 
            GetDBColumnName('Sent.dat', 'f_range_end_eg_int', '') + ',' + 
            GetDBColumnName('Sent.dat', 'f_range_end_eg_offset', '') + ',' + 
            GetDBColumnName('Sent.dat', 'f_range_end_eg_input', '') + ',' + 
            GetDBColumnName('Sent.dat', 'f_range_end_spare', '') + ',' + 
            GetDBColumnName('Sent.dat', 'f_ea_email', '') + ',' + 
            GetDBColumnName('Sent.dat', 'f_ea_sms', '') + ',' + 
            GetDBColumnName('Sent.dat', 'f_ea_report', '') + ',' + 
            GetDBColumnName('Sent.dat', 'f_ea_csv', '') + ',' + 
            GetDBColumnName('Sent.dat', 'f_ea_rep_email', '') + ',' + 
            GetDBColumnName('Sent.dat', 'f_ea_rep_fax', '') + ',' + 
            GetDBColumnName('Sent.dat', 'f_ea_rep_printer', '') + ',' + 
            GetDBColumnName('Sent.dat', 'f_spare', '') + ',' + 
            GetDBColumnName('Sent.dat', 'f_el_expiration', '') + ',' + 
            GetDBColumnName('Sent.dat', 'f_el_expiration_date', '') + ',' + 
            GetDBColumnName('Sent.dat', 'f_el_repeat_period', '') + ',' + 
            GetDBColumnName('Sent.dat', 'f_el_repeat_data', '') + ',' + 
            GetDBColumnName('Sent.dat', 'f_el_email_report', '') + ',' + 
            GetDBColumnName('Sent.dat', 'f_el_last_date_run', '') + ',' + 
            GetDBColumnName('Sent.dat', 'f_el_next_run_due', '') + ',' + 
            GetDBColumnName('Sent.dat', 'f_el_report_name', '') + ',' + 
            GetDBColumnName('Sent.dat', 'f_el_event_index', '') + ',' + 
            GetDBColumnName('Sent.dat', 'f_el_run_on_startup', '') + ',' + 
            GetDBColumnName('Sent.dat', 'f_el_email_csv', '') + ',' + 
            GetDBColumnName('Sent.dat', 'f_el_status', '') + ',' + 
            GetDBColumnName('Sent.dat', 'f_el_parent', '') + ',' + 
            GetDBColumnName('Sent.dat', 'f_el_start_date', '') + ',' + 
            GetDBColumnName('Sent.dat', 'f_el_delete_on_expiry', '') + ',' + 
            GetDBColumnName('Sent.dat', 'f_el_periodic', '') + ',' + 
            GetDBColumnName('Sent.dat', 'f_el_trigger_count', '') + ',' + 
            GetDBColumnName('Sent.dat', 'f_el_days_between', '') + ',' + 
            GetDBColumnName('Sent.dat', 'f_el_expired', '') + ',' + 
            GetDBColumnName('Sent.dat', 'f_el_run_now', '') + ',' + 
            GetDBColumnName('Sent.dat', 'f_el_instance', '') + ',' + 
            GetDBColumnName('Sent.dat', 'f_el_msg_instance', '') + ',' + 
            GetDBColumnName('Sent.dat', 'f_el_single_email', '') + ',' + 
            GetDBColumnName('Sent.dat', 'f_el_prev_status', '') + ',' + 
            GetDBColumnName('Sent.dat', 'f_el_single_sms', '') + ',' + 
            GetDBColumnName('Sent.dat', 'f_el_triggered', '') + ',' + 
            GetDBColumnName('Sent.dat', 'f_el_sms_tries', '') + ',' + 
            GetDBColumnName('Sent.dat', 'f_el_email_tries', '') + ',' + 
            GetDBColumnName('Sent.dat', 'f_el_send_doc', '') + ',' + 
            GetDBColumnName('Sent.dat', 'f_el_doc_name', '') + ',' + 
            GetDBColumnName('Sent.dat', 'f_el_sms_retries_notified', '') + ',' + 
            GetDBColumnName('Sent.dat', 'f_el_email_retries_notified', '') + ',' + 
            GetDBColumnName('Sent.dat', 'f_el_email_error_no', '') + ',' + 
            GetDBColumnName('Sent.dat', 'f_el_sms_error_no', '') + ',' + 
            GetDBColumnName('Sent.dat', 'f_el_rep_file', '') + ',' + 
            GetDBColumnName('Sent.dat', 'f_el_fax_cover', '') + ',' + 
            GetDBColumnName('Sent.dat', 'f_el_fax_tries', '') + ',' + 
            GetDBColumnName('Sent.dat', 'f_el_print_tries', '') + ',' + 
            GetDBColumnName('Sent.dat', 'f_el_fax_priority', '') + ',' + 
            GetDBColumnName('Sent.dat', 'f_el_has_conditions', '') + ',' + 
            GetDBColumnName('Sent.dat', 'f_el_rep_folder', '') + ',' + 
            GetDBColumnName('Sent.dat', 'f_el_ftp_site', '') + ',' + 
            GetDBColumnName('Sent.dat', 'f_el_ftp_user_name', '') + ',' + 
            GetDBColumnName('Sent.dat', 'f_el_ftp_password', '') + ',' + 
            GetDBColumnName('Sent.dat', 'f_el_ftp_port', '') + ',' + 
            GetDBColumnName('Sent.dat', 'f_el_csv_by_email', '') + ',' + 
            GetDBColumnName('Sent.dat', 'f_el_csv_by_ftp', '') + ',' + 
            GetDBColumnName('Sent.dat', 'f_el_csv_to_folder', '') + ',' + 
            GetDBColumnName('Sent.dat', 'f_el_upload_dir', '') + ',' + 
            GetDBColumnName('Sent.dat', 'f_el_csv_file_name', '') + ',' + 
            GetDBColumnName('Sent.dat', 'f_el_ftp_tries', '') + ',' + 
            GetDBColumnName('Sent.dat', 'f_el_ftp_timeout', '') + ',' + 
            GetDBColumnName('Sent.dat', 'f_el_csv_file_renamed', '') + ',' + 
            GetDBColumnName('Sent.dat', 'f_el_ftp_retries_notified', '') + ',' + 
            GetDBColumnName('Sent.dat', 'f_el_fax_retries_notified', '') + ',' + 
            GetDBColumnName('Sent.dat', 'f_el_compress_report', '') + ',' + 
            GetDBColumnName('Sent.dat', 'f_el_rp_attach_method', '') + ',' + 
            GetDBColumnName('Sent.dat', 'f_el_work_station', '') + ',' + 
            GetDBColumnName('Sent.dat', 'f_el_word_wrap', '') + ',' + 
            GetDBColumnName('Sent.dat', 'f_el_sys_message', '') + ',' + 
            GetDBColumnName('Sent.dat', 'f_el_dbf', '') + ',' + 
            GetDBColumnName('Sent.dat', 'f_el_queue_counter', '') + ',' + 
            GetDBColumnName('Sent.dat', 'f_el_hours_before_notify', '') + ',' + 
            GetDBColumnName('Sent.dat', 'f_el_query_start', '') + ',' + 
            GetDBColumnName('Sent.dat', 'f_el_ex_rep_format', '') + ',' + 
            GetDBColumnName('Sent.dat', 'f_el_recip_no', '') + ',' + 
            GetDBColumnName('Sent.dat', 'f_el_new_report', '') + ',' + 
            GetDBColumnName('Sent.dat', 'f_el_new_report_name', '') ;
end;
  
function GetAllSentLineFields : string;
begin
  Result := GetDBColumnName('SentLine.dat', 'Prefix', '') + ',' + 
            GetDBColumnName('SentLine.dat', 'UserId', '') + ',' + 
            GetDBColumnName('SentLine.dat', 'Name', '') + ',' + 
            GetDBColumnName('SentLine.dat', 'Instance', '') + ',' + 
            GetDBColumnName('SentLine.dat', 'OutputType', '') + ',' + 
            GetDBColumnName('SentLine.dat', 'LineNumber', '') + ',' + 
            GetDBColumnName('SentLine.dat', 'DummyLineNumber', '') + ',' + 
            GetDBColumnName('SentLine.dat', 'TermChar', '') + ',' + 
            GetDBColumnName('SentLine.dat', 'ID', '') + ',' + 
            GetDBColumnName('SentLine.dat', 'OutputLines', '') + ',' + 
            GetDBColumnName('SentLine.dat', 'MsgInstance', '') ;
end;
  
function GetAllSettingsFields : string;
begin
  Result := GetDBColumnName('Settings.dat', 'f_field_1', '') + ',' + 
            GetDBColumnName('Settings.dat', 'f_field_2', '') ;
end;
  
function GetAllStockFields : string;
begin
  Result := GetDBColumnName('Stock.dat', 'f_stock_code', '') + ',' + 
            GetDBColumnName('Stock.dat', 'f_desc_line1', '') + ',' + 
            GetDBColumnName('Stock.dat', 'f_desc_line2', '') + ',' + 
            GetDBColumnName('Stock.dat', 'f_desc_line3', '') + ',' + 
            GetDBColumnName('Stock.dat', 'f_desc_line4', '') + ',' + 
            GetDBColumnName('Stock.dat', 'f_desc_line5', '') + ',' + 
            GetDBColumnName('Stock.dat', 'f_desc_line6', '') + ',' + 
            GetDBColumnName('Stock.dat', 'f_alt_code', '') + ',' + 
            GetDBColumnName('Stock.dat', 'f_supp_temp', '') + ',' + 
            GetDBColumnName('Stock.dat', 'f_nom_code1', '') + ',' + 
            GetDBColumnName('Stock.dat', 'f_nom_code2', '') + ',' + 
            GetDBColumnName('Stock.dat', 'f_nom_code3', '') + ',' + 
            GetDBColumnName('Stock.dat', 'f_nom_code4', '') + ',' + 
            GetDBColumnName('Stock.dat', 'f_nom_code5', '') + ',' + 
            GetDBColumnName('Stock.dat', 'f_ro_flg', '') + ',' + 
            GetDBColumnName('Stock.dat', 'f_min_flg', '') + ',' + 
            GetDBColumnName('Stock.dat', 'f_stock_folio', '') + ',' + 
            GetDBColumnName('Stock.dat', 'f_stock_cat', '') + ',' + 
            GetDBColumnName('Stock.dat', 'f_stock_type', '') + ',' + 
            GetDBColumnName('Stock.dat', 'f_unit_k', '') + ',' + 
            GetDBColumnName('Stock.dat', 'f_unit_s', '') + ',' + 
            GetDBColumnName('Stock.dat', 'f_unit_p', '') + ',' + 
            GetDBColumnName('Stock.dat', 'f_p_currency', '') + ',' + 
            GetDBColumnName('Stock.dat', 'f_cost_price', '') + ',' + 
            GetDBColumnName('Stock.dat', 'f_sale_band1_currency', '') + ',' + 
            GetDBColumnName('Stock.dat', 'f_sale_band1_price', '') + ',' + 
            GetDBColumnName('Stock.dat', 'f_sale_band2_currency', '') + ',' + 
            GetDBColumnName('Stock.dat', 'f_sale_band2_price', '') + ',' + 
            GetDBColumnName('Stock.dat', 'f_sale_band3_currency', '') + ',' + 
            GetDBColumnName('Stock.dat', 'f_sale_band3_price', '') + ',' + 
            GetDBColumnName('Stock.dat', 'f_sale_band4_currency', '') + ',' + 
            GetDBColumnName('Stock.dat', 'f_sale_band4_price', '') + ',' + 
            GetDBColumnName('Stock.dat', 'f_sale_band5_currency', '') + ',' + 
            GetDBColumnName('Stock.dat', 'f_sale_band5_price', '') + ',' + 
            GetDBColumnName('Stock.dat', 'f_sale_band6_currency', '') + ',' + 
            GetDBColumnName('Stock.dat', 'f_sale_band6_price', '') + ',' + 
            GetDBColumnName('Stock.dat', 'f_sale_band7_currency', '') + ',' + 
            GetDBColumnName('Stock.dat', 'f_sale_band7_price', '') + ',' + 
            GetDBColumnName('Stock.dat', 'f_sale_band8_currency', '') + ',' + 
            GetDBColumnName('Stock.dat', 'f_sale_band8_price', '') + ',' + 
            GetDBColumnName('Stock.dat', 'f_sale_band9_currency', '') + ',' + 
            GetDBColumnName('Stock.dat', 'f_sale_band9_price', '') + ',' + 
            GetDBColumnName('Stock.dat', 'f_sale_band10_currency', '') + ',' + 
            GetDBColumnName('Stock.dat', 'f_sale_band10_price', '') + ',' + 
            GetDBColumnName('Stock.dat', 'f_sell_unit', '') + ',' + 
            GetDBColumnName('Stock.dat', 'f_buy_unit', '') + ',' + 
            GetDBColumnName('Stock.dat', 'f_spare1', '') + ',' + 
            GetDBColumnName('Stock.dat', 'f_vat_code', '') + ',' + 
            GetDBColumnName('Stock.dat', 'f_department', '') + ',' + 
            GetDBColumnName('Stock.dat', 'f_cost_centre', '') + ',' + 
            GetDBColumnName('Stock.dat', 'f_qty_in_stock', '') + ',' + 
            GetDBColumnName('Stock.dat', 'f_qty_posted', '') + ',' + 
            GetDBColumnName('Stock.dat', 'f_qty_allocated', '') + ',' + 
            GetDBColumnName('Stock.dat', 'f_qty_on_order', '') + ',' + 
            GetDBColumnName('Stock.dat', 'f_qty_min', '') + ',' + 
            GetDBColumnName('Stock.dat', 'f_qty_max', '') + ',' + 
            GetDBColumnName('Stock.dat', 'f_ro_qty', '') + ',' + 
            GetDBColumnName('Stock.dat', 'f_n_line_count', '') + ',' + 
            GetDBColumnName('Stock.dat', 'f_sub_assy_flg', '') + ',' + 
            GetDBColumnName('Stock.dat', 'f_showas_kit', '') + ',' + 
            GetDBColumnName('Stock.dat', 'f_b_line_count', '') + ',' + 
            GetDBColumnName('Stock.dat', 'f_commod_code', '') + ',' + 
            GetDBColumnName('Stock.dat', 'f_s_weight', '') + ',' + 
            GetDBColumnName('Stock.dat', 'f_p_weight', '') + ',' + 
            GetDBColumnName('Stock.dat', 'f_unit_supp', '') + ',' + 
            GetDBColumnName('Stock.dat', 'f_supp_s_unit', '') + ',' + 
            GetDBColumnName('Stock.dat', 'f_bin_loc', '') + ',' + 
            GetDBColumnName('Stock.dat', 'f_stk_flg', '') + ',' + 
            GetDBColumnName('Stock.dat', 'f_cov_pr', '') + ',' + 
            GetDBColumnName('Stock.dat', 'f_cov_pr_unit', '') + ',' + 
            GetDBColumnName('Stock.dat', 'f_cov_min_pr', '') + ',' + 
            GetDBColumnName('Stock.dat', 'f_cov_min_unit', '') + ',' + 
            GetDBColumnName('Stock.dat', 'f_supplier', '') + ',' + 
            GetDBColumnName('Stock.dat', 'f_qty_freeze', '') + ',' + 
            GetDBColumnName('Stock.dat', 'f_cov_sold', '') + ',' + 
            GetDBColumnName('Stock.dat', 'f_use_cover', '') + ',' + 
            GetDBColumnName('Stock.dat', 'f_cov_max_pr', '') + ',' + 
            GetDBColumnName('Stock.dat', 'f_cov_max_unit', '') + ',' + 
            GetDBColumnName('Stock.dat', 'f_ro_currency', '') + ',' + 
            GetDBColumnName('Stock.dat', 'f_roc_price', '') + ',' + 
            GetDBColumnName('Stock.dat', 'f_ro_date', '') + ',' + 
            GetDBColumnName('Stock.dat', 'f_qty_take', '') + ',' + 
            GetDBColumnName('Stock.dat', 'f_stk_val_type', '') + ',' + 
            GetDBColumnName('Stock.dat', 'f_has_ser_no', '') + ',' + 
            GetDBColumnName('Stock.dat', 'f_qty_picked', '') + ',' + 
            GetDBColumnName('Stock.dat', 'f_last_used', '') + ',' + 
            GetDBColumnName('Stock.dat', 'f_calc_pack', '') + ',' + 
            GetDBColumnName('Stock.dat', 'f_j_anal_code', '') + ',' + 
            GetDBColumnName('Stock.dat', 'f_stk_user1', '') + ',' + 
            GetDBColumnName('Stock.dat', 'f_stk_user2', '') + ',' + 
            GetDBColumnName('Stock.dat', 'f_bar_code', '') + ',' + 
            GetDBColumnName('Stock.dat', 'f_ro_department', '') + ',' + 
            GetDBColumnName('Stock.dat', 'f_ro_cost_centre', '') + ',' + 
            GetDBColumnName('Stock.dat', 'f_def_m_loc', '') + ',' + 
            GetDBColumnName('Stock.dat', 'f_price_pack', '') + ',' + 
            GetDBColumnName('Stock.dat', 'f_d_pack_qty', '') + ',' + 
            GetDBColumnName('Stock.dat', 'f_kit_price', '') + ',' + 
            GetDBColumnName('Stock.dat', 'f_kit_on_purch', '') + ',' + 
            GetDBColumnName('Stock.dat', 'f_stk_link_lt', '') + ',' + 
            GetDBColumnName('Stock.dat', 'f_qty_return', '') + ',' + 
            GetDBColumnName('Stock.dat', 'f_qty_alloc_wor', '') + ',' + 
            GetDBColumnName('Stock.dat', 'f_qty_issue_wor', '') + ',' + 
            GetDBColumnName('Stock.dat', 'f_web_include', '') + ',' + 
            GetDBColumnName('Stock.dat', 'f_web_live_cat', '') + ',' + 
            GetDBColumnName('Stock.dat', 'f_web_prev_cat', '') + ',' + 
            GetDBColumnName('Stock.dat', 'f_stk_user3', '') + ',' + 
            GetDBColumnName('Stock.dat', 'f_stk_user4', '') + ',' + 
            GetDBColumnName('Stock.dat', 'f_ser_no_wavg', '') + ',' + 
            GetDBColumnName('Stock.dat', 'f_stk_size_col', '') + ',' + 
            GetDBColumnName('Stock.dat', 'f_ssdd_uplift', '') + ',' + 
            GetDBColumnName('Stock.dat', 'f_ssd_country', '') + ',' + 
            GetDBColumnName('Stock.dat', 'f_time_change', '') + ',' + 
            GetDBColumnName('Stock.dat', 'f_svat_inc_flg', '') + ',' + 
            GetDBColumnName('Stock.dat', 'f_ssda_uplift', '') + ',' + 
            GetDBColumnName('Stock.dat', 'f_private_rec', '') + ',' + 
            GetDBColumnName('Stock.dat', 'f_last_opo', '') + ',' + 
            GetDBColumnName('Stock.dat', 'f_image_file', '') + ',' + 
            GetDBColumnName('Stock.dat', 'f_temp_bloc', '') + ',' + 
            GetDBColumnName('Stock.dat', 'f_qty_pick_wor', '') + ',' + 
            GetDBColumnName('Stock.dat', 'f_wopwipgl', '') + ',' + 
            GetDBColumnName('Stock.dat', 'f_prod_time', '') + ',' + 
            GetDBColumnName('Stock.dat', 'f_leadtime', '') + ',' + 
            GetDBColumnName('Stock.dat', 'f_calc_prod_time', '') + ',' + 
            GetDBColumnName('Stock.dat', 'f_bom_prod_time', '') + ',' + 
            GetDBColumnName('Stock.dat', 'f_min_ecc_qty', '') + ',' + 
            GetDBColumnName('Stock.dat', 'f_multi_bin_mode', '') + ',' + 
            GetDBColumnName('Stock.dat', 'f_s_warranty', '') + ',' + 
            GetDBColumnName('Stock.dat', 'f_s_warranty_type', '') + ',' + 
            GetDBColumnName('Stock.dat', 'f_m_warranty', '') + ',' + 
            GetDBColumnName('Stock.dat', 'f_m_warranty_type', '') + ',' + 
            GetDBColumnName('Stock.dat', 'f_qty_p_return', '') + ',' + 
            GetDBColumnName('Stock.dat', 'f_return_gl', '') + ',' + 
            GetDBColumnName('Stock.dat', 'f_re_stock_pcnt', '') + ',' + 
            GetDBColumnName('Stock.dat', 'f_re_stock_gl', '') + ',' + 
            GetDBColumnName('Stock.dat', 'f_bom_ded_comp', '') + ',' + 
            GetDBColumnName('Stock.dat', 'f_p_return_gl', '') + ',' + 
            GetDBColumnName('Stock.dat', 'f_re_stock_pchr', '') + ',' + 
            GetDBColumnName('Stock.dat', 'f_last_stock_type', '') ;
end;
  
function GetAllTillnameFields : string;
begin
  Result := GetDBColumnName('Tillname.dat', 'f_field_1', '') + ',' + 
            GetDBColumnName('Tillname.dat', 'f_field_2', '') ;
end;
  
function GetAllMenuItemFields : string;
begin
  Result := GetDBColumnName('Tools.dat', 'recordtype', '') + ',' + 
            GetDBColumnName('Tools.dat', 'tools_code1', '') + ',' + 
            GetDBColumnName('Tools.dat', 'tools_code2', '') + ',' + 
            GetDBColumnName('Tools.dat', 'tools_code3', '') + ',' + 
            GetDBColumnName('Tools.dat', 'mifoliono', 'M') + ',' + 
            GetDBColumnName('Tools.dat', 'miavailability', 'M') + ',' + 
            GetDBColumnName('Tools.dat', 'micompany', 'M') + ',' + 
            GetDBColumnName('Tools.dat', 'miitemtype', 'M') + ',' + 
            GetDBColumnName('Tools.dat', 'midescription', 'M') + ',' + 
            GetDBColumnName('Tools.dat', 'mifilename', 'M') + ',' + 
            GetDBColumnName('Tools.dat', 'mistartdir', 'M') + ',' + 
            GetDBColumnName('Tools.dat', 'miparameters', 'M') + ',' + 
            GetDBColumnName('Tools.dat', 'mihelptext', 'M') + ',' + 
            GetDBColumnName('Tools.dat', 'miallusers', 'M') + ',' + 
            GetDBColumnName('Tools.dat', 'miallcompanies', 'M') + ',' + 
            GetDBColumnName('Tools.dat', 'micomponentname', 'M') + ',' + 
            GetDBColumnName('Tools.dat', 'miparentcomponentname', 'M') + ',' + 
            GetDBColumnName('Tools.dat', 'miposition', 'M') ;
end;
  
function GetAllUserXRefFields : string;
begin
  Result := GetDBColumnName('Tools.dat', 'recordtype', '') + ',' + 
            GetDBColumnName('Tools.dat', 'tools_code1', '') + ',' + 
            GetDBColumnName('Tools.dat', 'tools_code2', '') + ',' + 
            GetDBColumnName('Tools.dat', 'tools_code3', '') + ',' + 
            GetDBColumnName('Tools.dat', 'uxitemfolio', 'U') + ',' + 
            GetDBColumnName('Tools.dat', 'uxusername', 'U') ;
end;
  
function GetAllSysSetupFields : string;
begin
  Result := GetDBColumnName('Tools.dat', 'recordtype', '') + ',' + 
            GetDBColumnName('Tools.dat', 'tools_code1', '') + ',' + 
            GetDBColumnName('Tools.dat', 'tools_code2', '') + ',' + 
            GetDBColumnName('Tools.dat', 'tools_code3', '') + ',' + 
            GetDBColumnName('Tools.dat', 'ssusepassword', 'S') + ',' + 
            GetDBColumnName('Tools.dat', 'sspassword', 'S') ;
end;
  
function GetAllCompanyXRefFields : string;
begin
  Result := GetDBColumnName('Tools.dat', 'recordtype', '') + ',' + 
            GetDBColumnName('Tools.dat', 'tools_code1', '') + ',' + 
            GetDBColumnName('Tools.dat', 'tools_code2', '') + ',' + 
            GetDBColumnName('Tools.dat', 'tools_code3', '') + ',' + 
            GetDBColumnName('Tools.dat', 'cxitemfolio', 'C') + ',' + 
            GetDBColumnName('Tools.dat', 'cxcompanycode', 'C') ;
end;
  
function GetAllUDENTITYFields : string;
begin
  Result := GetDBColumnName('UDENTITY.dat', 'etFolioNo', '') + ',' + 
            GetDBColumnName('UDENTITY.dat', 'etDescription', '') + ',' + 
            GetDBColumnName('UDENTITY.dat', 'etType', '') + ',' + 
            GetDBColumnName('UDENTITY.dat', 'etFormat', '') + ',' + 
            GetDBColumnName('UDENTITY.dat', 'etDummyChar', '') ;
end;
  
function GetAllUDFIELDFields : string;
begin
  Result := GetDBColumnName('UDFIELD.dat', 'fiFolioNo', '') + ',' + 
            GetDBColumnName('UDFIELD.dat', 'fiEntityFolio', '') + ',' + 
            GetDBColumnName('UDFIELD.dat', 'fiLineNo', '') + ',' + 
            GetDBColumnName('UDFIELD.dat', 'fiDescription', '') + ',' + 
            GetDBColumnName('UDFIELD.dat', 'fiValidationMode', '') + ',' + 
            GetDBColumnName('UDFIELD.dat', 'fiWindowCaption', '') + ',' + 
            GetDBColumnName('UDFIELD.dat', 'fiLookupRef', '') + ',' + 
            GetDBColumnName('UDFIELD.dat', 'fiDummyChar', '') ;
end;
  
function GetAllUDITEMFields : string;
begin
  Result := GetDBColumnName('UDITEM.dat', 'liFieldFolio', '') + ',' + 
            GetDBColumnName('UDITEM.dat', 'liLineNo', '') + ',' + 
            GetDBColumnName('UDITEM.dat', 'liDescription', '') + ',' + 
            GetDBColumnName('UDITEM.dat', 'liDummyChar', '') ;
end;
  
function GetAllVATOPTFields : string;
begin
  Result := GetDBColumnName('VATOPT.dat', 'Year', '') + ',' + 
            GetDBColumnName('VATOPT.dat', 'Period', '') + ',' + 
            GetDBColumnName('VATOPT.dat', 'EndDate', '') + ',' + 
            GetDBColumnName('VATOPT.dat', 'StartDate', '') + ',' + 
            GetDBColumnName('VATOPT.dat', 'OptNoOfPeriods', '') + ',' + 
            GetDBColumnName('VATOPT.dat', 'OptUseAuto', '') + ',' + 
            GetDBColumnName('VATOPT.dat', 'BackColor', '') + ',' + 
            GetDBColumnName('VATOPT.dat', 'TextColor', '') + ',' + 
            GetDBColumnName('VATOPT.dat', 'CurrColor', '') ;
end;
  
function GetAllVATPRDFields : string;
begin
  Result := GetDBColumnName('VATPRD.dat', 'Year', '') + ',' + 
            GetDBColumnName('VATPRD.dat', 'Period', '') + ',' + 
            GetDBColumnName('VATPRD.dat', 'EndDate', '') + ',' + 
            GetDBColumnName('VATPRD.dat', 'StartDate', '') ;
end;
  
function GetAllVRWSECFields : string;
begin
  Result := GetDBColumnName('VRWSEC.dat', 'rtstreecode', '') + ',' + 
            GetDBColumnName('VRWSEC.dat', 'rtsusercode', '') + ',' + 
            GetDBColumnName('VRWSEC.dat', 'rtssecurity', '') ;
end;
  
function GetAllVRWTREEFields : string;
begin
  Result := GetDBColumnName('VRWTREE.dat', 'rtnodetype', '') + ',' + 
            GetDBColumnName('VRWTREE.dat', 'rtrepname', '') + ',' + 
            GetDBColumnName('VRWTREE.dat', 'rtrepdesc', '') + ',' + 
            GetDBColumnName('VRWTREE.dat', 'rtparentname', '') + ',' + 
            GetDBColumnName('VRWTREE.dat', 'rtfilename', '') + ',' + 
            GetDBColumnName('VRWTREE.dat', 'rtlastrun', '') + ',' + 
            GetDBColumnName('VRWTREE.dat', 'rtlastrunuser', '') + ',' + 
            GetDBColumnName('VRWTREE.dat', 'rtpositionnumber', '') + ',' + 
            GetDBColumnName('VRWTREE.dat', 'rtindexfix', '') + ',' + 
            GetDBColumnName('VRWTREE.dat', 'rtallowedit', '') + ',' + 
            GetDBColumnName('VRWTREE.dat', 'rtfileexists', '') ;
end;
  
 
end.
