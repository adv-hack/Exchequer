unit HandlerU;

{ markd6 17:09 06/11/2001: Disabled Byte Alignment in Delphi 6.0 }
{$ALIGN 1}  { Variable Alignment Disabled }

{
  NOTE: If new Custom Fields are added, the SQL script for creating the Custom
  Fields table must also be updated to add the new fields:

    \ExchSQL\SQLEmulator\Schemas\Upgrade Scripts\6.9\CustomFieldsCreator.sql  
}

interface

Uses
  Dialogs,
  SysUtils,
  CommonU;


Function RunUpgrade(UpNo      :  Integer;
                    Verbose   :  Boolean;
                    IntParam  :  Integer;
                    StrParam  :  String)  :  Integer;  STDCall;


Function ControlUpgrade(VerNo     :  String;
                        CompDir   :  String;
                    Var RErrStr   :  String;
                        ForceRun  :  Boolean)  :  Integer; STDCALL;

{~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~}

Implementation

{~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~}

Uses
  ComCtrls,
  Forms,
  GlobVar,
  ETStrU,
  ProgU,
  PWUpG1U,
  PWUpG2U,
  PWUpG3U,
  PWUpG4U,
  PWUpG5U,
  PWUpG6U,
  PWUpG7U,
  PwUpgrade,
  AddIndex,

  //PR: 22/02/2012 ABSEXCH-9795
  QBConvertF,

  //PR: 24/02/2012 ABSEXCH-12128
  QtyBreakConverter,
  JobAppsCustomFields,

  //PR: 23/07/2012 ABSEXCH-12956 v7.0
  CurrencyHist,

  //PR: 20/08/2013 MRD
  SepaUpgradeClass,

  //PR: 26/08/2013 MRD
  InitFieldsFuncs, InitFieldsIntf, IdxObj, BtrvU2, VarConst,

  UpgradeContactRoles,

  // MH 10/11/2014 Order Payments: Added custom fields for rebadging Ac Credit Card Fields
  ACCreditCardCustomFields,

  // MH 17/12/2014 v7.1 ABSEXCH-15855: Added custom fields for Addresses
  AddressCustomFields,

  // MH 05/05/2015 v7.0.14: Added new SystemSetup table
  AddSystemSetupFields,

  // MH 09/07/2015 v7.0.14 ABSEXCH-15920: Check the document numbers and warn if >= 3 million
  CheckDocumentNumbers,

  // PKR. 06/04/2016. Add Tax Region custom fields.
  TaxRegionCustomFields,

  // MH 25/05/2016 2016-R2: Add new TH User Defined Fields
  AddTHCustomFields,

  oSystemSetup,

  //PR: 10/10/2016 v2017-R1 ABSEXCH-17457 Expire Authoris-e
  oExpire,

  //HV 03/07/2017 2017-R2 ABSEXCH-18820: 2.2.1 User Management - Permissions.
  UpgradeUserPermissions,

  //PR: 04/07/2017 ABSEXCH-12358 v2017 R2 Change the KeyString (bnkCode3) in the BankReconcilation header
  UpdateBankRecKey,

  //RB 22/08/2017 2018-R1 ABSEXCH-19335: GEUpgrade changes for User Profile PII Fields
  UpdateGDPRFields,

  //RB 08/02/2018 2018-R1 ABSEXCH-19243: Enhancement to remove the ability to extract SQL admin passwords
  RewriteLoginFile,

  //Rahul
  CopyData;



{ == Generic routines to control the calling of various upgrades == }



Function RunUpgrade(UpNo      :  Integer;
                    Verbose   :  Boolean;
                    IntParam  :  Integer;
                    StrParam  :  String)  :  Integer;  STDCall;
Var
  Ptr  :  TProgressBar;
Begin
  Ptr:=nil;
  Result := 0; // Initialised to prevent compiler warning
  Case UpNo of
    1  :  Result:=SetPWord_v432(Verbose,Ptr);
    2  :  Result:=SetPWord_v440(Verbose,Ptr);
    3  :  Result:=SetPWord_v550(Verbose,Ptr);
    4  :  Result:=SetPWord_v552(Verbose,Ptr);
    5  :  Result:=SetPWord_v560(Verbose,Ptr);
    6  :  Result:=SetPWord_v570(Verbose,Ptr);
    7  :  Result:=SetPWord_vLTE(Verbose,Ptr);
    else  //PR 23/01/2009 Add generic function for 6.01 and later (in PwUpgrade.pas)
      SetPermissions(UpNo, Verbose, Ptr);
  end; {case..}
end;


Function ControlUpgrade(VerNo     :  String;
                        CompDir   :  String;
                    Var RErrStr   :  String;
                        ForceRun  :  Boolean)  :  Integer;
Var
  n       :  Integer;
  GotOne  :  Boolean;
  ShowProg:  TGenProg;
  NeedToInitialiseConsumerFields : Boolean;
  DataVersion : Integer;

  function CheckNeedToInitialiseConsumerFields : Boolean;
  var
    addIndex : TAddIndex;
  begin
    addIndex := TAddIndex.Create;
    Try
      addIndex.Filename := CompDir + Filenames[1];
      addIndex.IndexNumber := 12;
      addIndex.FileNumber := CustF;

      Result := not addIndex.IndexExists;
    Finally
      addIndex.Free;
    End;
  end;

Begin
  SetCompanyDir(CompDir);

  CtrlUpgrade.VerNo:=VerNo;
  Result:=0;  GotOne:=False;  RErrStr:='';

  //PR: 28/08/2013 MRD Need to store result of check before adding consumer indexes
  NeedToInitialiseConsumerFields := CheckNeedToInitialiseConsumerFields;

  For n:=1 to High(UpgradeList) do
    With UpgradeList[n] do {Collect all the info including progress bar totals first}
    Begin
      RunIt:=NeedToRunUpgrade(n,VerNo,ErrStr,ForceRun);

      If (Not GotOne) then
        GotOne:=RunIt;
    end;

  If (GotOne) then {Create progress bar here}
  Begin
    UResult:=0;

    ShowProg:=TGenProg.Create(Application);

    Try
      ShowProg.ShowModal;
    finally;
      Result:=UResult;

      If (UCount>0) and (UCount<=High(UpgradeList)) then
        RErrStr:=UpgradeList[UCount].ErrStr;


      ShowProg.Free;

    end;
  end;

  if Result = 0 then
  begin
    Result := AddNewIndex(VerNo, CompDir, RErrStr);
  end;

  //PR: 24/02/2012  ABSEXCH-9795/ABSECH-12128
  if (Result = 0) and Need610Conversion then
  begin
    Result := AddJobAppsCustomFields(RErrStr);

    if Result = 0 then
      Result := ConvertQuantityBreaks(RErrStr);
  end;

  //PR: 23/07/2012 ABSEXCH-12956 v7.0
  if Result = 0 then
    Result := AddCurrentCurrencyRatesToHistory(RErrStr);

  { CJS 2013-09-09 - ABSEXCH-14598 - SEPA/IBAN - copy from MRD branch }
  if Result = 0 then
    Result := RunSepaUpgrade(RErrStr);

    //PR: 20/08/2013 MRD
  if (Result = 0) and NeedToInitialiseConsumerFields then
    Result := InitialiseFields(RErrStr, ifConsumers);

  if (Result = 0) then
    Result := InitialiseContacts(RErrStr);

  // MH 17/12/2014 v7.1 ABSEXCH-15855: Added custom fields for Addresses
  If (Result = 0) Then
    Result := AddAddressCustomFields(RErrStr);

  // PKR. 06/04/2016. Added Tax Region custom fields
  If (Result = 0) Then
    Result := AddTaxRegionCustomFields(RErrStr);

  // MH 10/11/2014 Order Payments: Added custom fields for rebadging Ac Credit Card Fields
  If (Result = 0) Then
    Result := AddACCreditCardFields(RErrStr);

  // MH 25/05/2016 2016-R2: Add new TH User Defined Fields
  If (Result = 0) Then
    Result := AddNewTHCustomFields(RErrStr);

  // MH 05/05/2015 v7.0.14: Added new SystemSetup table
  If (Result = 0) Then
    // Add any missing rows from SystemSetup.Dat into the current Company Dataset
    Result := CheckSystemSetup (CompDir);

  //HV 03/07/2017 2017-R2 ABSEXCH-18820: 2.2.1 User Management - Permissions.
  if (Result = 0) then
    Result := UpdateUserPermission(RErrStr);

  //PR: 09/06/2014 v7.0.14
  if Result = 0 then
  begin
    //check if we need to initialise the PPD fields on customers/suppliers
    // MH 16/09/2015 2015-R1 ABSEXCH-16862: Corrected version number after v7.0.14 was cancelled
    DataVersion := GetDataVersion(CompDir);

    // Check to see if we need to do the 2015-R1 initialisation processes
    If (DataVersion < V_2015R1) Then
    Begin
      // 2015 R1 - Initialise the PPD flags on Customers/Suppliers
      Result := InitialiseFields(RErrStr, ifPPDMode);
    End; // If (DataVersion < V_2015R1)

    //PR: 04/07/2017 ABSEXCH-12358 v2017 R2 Change the KeyString (bnkCode3) in the BankReconcilation header
    if (Result = 0) and (DataVersion < V_2017R2) then
    begin
      Result := UpdateBankReconcile(RErrStr);

      //PR: 07/09/2017 v2017 R2 ABSEXCH-18856 Initialise password complexity fields
      if Result = 0 then
        Result := InitialiseFields(RErrStr, ifPassword, True);
    end;

    //RB 25/10/2017 2018-R1 ABSEXCH-19335: GEUpgrade changes for User Profile PII Fields
    if (Result = 0) and (DataVersion < V_2018R1) then
    begin
      Result := InitialisePIIHighlighColor(RErrStr);
      
      //RB 16/11/2017 2018-R1 ABSEXCH-19282: GDPR -Extending UDF fields for PII flag
      if (Result = 0) then
        Result := InitialisePIIFlags(RErrStr);

      //RB 08/02/2018 2018-R1 ABSEXCH-19243: Enhancement to remove the ability to extract SQL admin passwords
      if (Result = 0) then
        Result := RewriteLoginXMLFile(RErrStr);
    end;

    //RB 31/07/2018 v12.0.0: ABSEXCH-19517: Called routine to copy data from elCSVFileNameOld -> elCSVFileName
    if (Result = 0 ) and (DataVersion < V_1200) then
    begin
      Result := CopyElCSVFileData(RErrStr);
    end;
    
    // MH 14/10/2015 2016-R1: Added V_CURRENTVERSION so we don't need to keep changing HandlerU so much
    // Update the data version number to the current version
    If (Result = 0) And (DataVersion < V_CURRENTVERSION) Then
      Result := SetDataVersion(CompDir, V_CURRENTVERSION);
  end;

  // MH 09/07/2015 v7.0.14 ABSEXCH-15920: Check the document numbers and warn if >= 2.5 million
  If (Result = 0) Then
  Begin
    CheckNextDocumentNos (CompDir);
  End; // If (Result = 0)

  //PR: 10/10/2016 v2017-R1 ABSEXCH-17457 Expire licence for Authoris-e plugin and remove it from EntCustm.ini
  if (Result = 0) then
  begin
    Result := ExpirePlugIn(VerNo, CompDir, S_AUTHORISE_ID, RErrStr);
  end;


  
//ShowMessage ('ControlUpgrade.End: ' + IntToStr(Result));
end;




end.
