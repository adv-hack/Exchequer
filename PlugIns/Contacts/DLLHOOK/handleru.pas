unit HandlerU;

{ nfrewer440 16:07 13/11/2001: Disabled Byte Alignment in Delphi 6.0 }
{$ALIGN 1}  { Variable Alignment Disabled }


{ Hook Customisation Unit - Allows standard Enterprise behaviour to }
{                           be modified by calling code in the DLL  }

interface

Uses
  ETStrU, BtrvU2, VarConst, GlobVar, CustWinU, CustAbsU, Forms, Controls
  , SQLUtils, uSettingsSQL, PickAcc, FileUtil, DataModule, TEditVal;

Const
//  OPEN_INITIAL_COMPANY = 10;
//  OPEN_NEW_COMPANY = 9;
  CLOSE_COMPANY = 8;

var
  iCustBtnId : byte = 0;
  iSuppBtnId : byte = 0;

{ Following functions required to be Exported by Enterprise }
Procedure InitCustomHandler(Var CustomOn : Boolean; CustomHandlers : TAbsCustomHandlers); Export;
Procedure TermCustomHandler; Export;
Procedure ExecCustomHandler(Const EventData : TAbsEnterpriseSystem09); Export;


implementation

Uses
  Dialogs, SysUtils, ChainU, ContSel, Company, StrUtil, APIUtil, ContProc
  ,Classes, PISecure, PIMisc, EntLicence, ExchequerRelease;

var
  bHookEnabled : boolean;
  iCustHookId : byte = 0;
  iSuppHookId : byte = 0;

Const
  sPlugInName = 'Exchequer Extended Contacts Plug-In';
  {$IFDEF EX600}
    // CA 25/04/2013 v7.0.3  ABSEXGENERIC-317: Version Number updated
    // CA 25/04/2013 v7.0.5  ABSEXGENERIC-317: Version Number updated
    // CJS 2013-10-21 v7.0.7 MRD2.5.25 - Postcode on Delivery Address
    // CJS 2013-11-27 - MRD 1.1.48 - Extend Contacts plugin to exclude Consumers
    // CJS 2014-01-24 - MRD 2.4.30 - Rebadged 'Extended Contacts'
     sVersionNo = '047';
//    sVersionNo = 'v7.0.3.042';
//    sVersionNo = 'v6.30.042';
  {$ELSE}
    sVersionNo = 'v5.71.042';
  {$ENDIF}
  EventDisabled = 0;
  EventEnabled  = 1;
  // NF: 19/04/06 - Expanded to include extra transaction types
//  ValidSalesAccTypes = [CUSIN, CUSCR, CUSRF, CUSOR, CUSDN, CUSRI, CUSQU];
//  ValidPurchAccTypes = [CUPIN, CUPCR, CUPRF, CUPOR, CUPDN, CUPPI, CUPQU];
  ValidSalesAccTypes = [CUSIN, CUSCR, CUSRF, CUSOR, CUSDN, CUSRI, CUSQU, CUSJI, CUSJC];
  ValidPurchAccTypes = [CUPIN, CUPCR, CUPRF, CUPOR, CUPDN, CUPPI, CUPQU, CUPJI, CUPJC];

  SM_ADD_EMAIL = 2;


Procedure InitCustomHandler(Var CustomOn : Boolean; CustomHandlers : TAbsCustomHandlers);
{ Called by Enterprise to initialise the Customisation }
var
  slAboutText : TStringList;
  iPos : integer;
Begin

  CustomOn := True;

  if EnterpriseLicence.elProductType in [ptLITECust, ptLITEAcct] then
  begin
    // Always Enabled for Lite
    bHookEnabled := TRUE;
  end
  else
  begin
    // Check Security for Exchequer (non-lite)
    bHookEnabled := PICheckSecurity('EXCHCNTACT000004', 'DhjEXjDZMKDyhFhN', sPlugInName
    , '', stSystemOnly, ptDLL, DLLChain.ModuleName);
  end;{if}

  if bHookEnabled then begin

    { Enable Hooks and Set About Message here }
    with TAbsCustomHandlers01(CustomHandlers) do
    begin

      if not (EnterpriseLicence.elProductType in [ptLITECust, ptLITEAcct])  then
      begin
        { Set About Message }
        slAboutText := TStringList.Create;
        PIMakeAboutText(sPlugInName, ExchequerModuleVersion (emGenericPlugIn, sVersionNo) + ' (DLL)', slAboutText);
        for iPos := 0 to slAboutText.Count - 1 do AddAboutString(slAboutText[iPos]);
        slAboutText.Free;
      end;{if}

      // Popup "Select contact" after selecting Account Code
      SetHandlerStatus(wiTransaction, 9, EventEnabled); // Set Deliver Address Hook on TX Header
      SetHandlerStatus(wiAccount, 109, EventEnabled); // Telesales Hook

      // Allow users to select contacts for email addresses
      if ClassVersion > '5.70' then SetHandlerStatus(wiPrint, 1, EventEnabled); // select email contact hook

      // Detect if Custom button1 is already in use (Customer)
      if (not HookPointEnabled(wiAccount, 11)) then
      begin
        // Use Custom button #1
        iCustHookId := 11;
        iCustBtnId := 1;
      end
      else
        if (not HookPointEnabled(wiAccount, 12)) then
        begin
          // Use Custom button #2
          iCustHookId := 12;
          iCustBtnId := 2;
        end{if}
        else
          // CA 25/04/2013 v7.0.3  ABSEXGENERIC-317: Code to deal with the extra custom buttons
          if (not HookPointEnabled(wiAccount, 141)) then
          begin
            // Use Custom button #3
            iCustHookId := 141;
            iCustBtnId := 141;
          end{if}
          else
            if (not HookPointEnabled(wiAccount, 142)) then
            begin
              // Use Custom button #4
              iCustHookId := 142;
              iCustBtnId := 142;
            end{if}
            else
              if (not HookPointEnabled(wiAccount, 143)) then
              begin
                // Use Custom button #5
                iCustHookId := 143;
                iCustBtnId := 143;
              end{if}
              else
              begin
                if (not HookPointEnabled (wiAccount, 144)) then
                begin
                  // Use Custom button #6
                  iCustHookId := 144;
                  iCustBtnId := 144;
                end;{if}
              end;{if}

      // Detect if Custom button1 is already in use (Supplier)
      if (not HookPointEnabled (wiAccount, 21)) then
      begin
        // Use Custom button #1
        iSuppHookId := 21;
        iSuppBtnId := 3;
      end
      else
        if (not HookPointEnabled (wiAccount, 22)) then
        begin
          // Use Custom button #2
          iSuppHookId := 22;
          iSuppBtnId := 4;
        end{if}
        else
          // CA 25/04/2013 v7.0.3  ABSEXGENERIC-317: Code to deal with the extra custom buttons
          if (not HookPointEnabled (wiAccount, 151)) then
          begin
            // Use Custom button #3
            iSuppHookId := 151;
            iSuppBtnId := 151;
          end{if}
          else
            if (not HookPointEnabled (wiAccount, 152)) then
            begin
              // Use Custom button #4
              iSuppHookId := 152;
              iSuppBtnId := 152;
            end{if}
            else
              if (not HookPointEnabled (wiAccount, 153)) then
              begin
                // Use Custom button #5
                iSuppHookId := 153;
                iSuppBtnId := 153;
              end{if}
                else
                begin
                  if (not HookPointEnabled (wiAccount, 154)) then
                  begin
                    // Use Custom button #6
                    iSuppHookId := 154;
                    iSuppBtnId := 154;
                  end;{if}
                end;{if}

      // Enable Custom Button Hooks
      SetHandlerStatus(wiAccount, iCustHookId, EventEnabled);
      SetHandlerStatus(wiAccount, iSuppHookId, EventEnabled);

      // Enable Change Account Code Hook
      if Copy(classversion,1,4) >= '5.52'
      then SetHandlerStatus(wiAccount, 111, EventEnabled);

      // Enable Delete Account Hook
      SetHandlerStatus(wiAccount, 4, EventEnabled);

      // open close company hooks
//      SetHandlerStatus (EnterpriseBase + MiscBase + 2, OPEN_INITIAL_COMPANY, EventEnabled);
//      SetHandlerStatus (EnterpriseBase + MiscBase + 2, OPEN_NEW_COMPANY, EventEnabled);
      SetHandlerStatus (EnterpriseBase + MiscBase + 2, CLOSE_COMPANY, EventEnabled);
    end;{with}
  end;{if}

  bSQL := UsingSQL;
  SQLDataModule := nil;

  { Call other Hook DLL's to get their customisation }
  DLLChain.InitCustomHandler(CustomOn, CustomHandlers);
End;

Procedure TermCustomHandler;
{ Called by Enterprise to End the Customisation }
Begin
  { Notify other Hook DLL's to Terminate }
  DLLChain.TermCustomHandler;

  oSettings.DisconnectADO;

  { Put Shutdown Code Here }
End;

Procedure ExecCustomHandler(Const EventData : TAbsEnterpriseSystem09);
{ Called by Enterprise whenever a Customised Event happens }

  procedure GetCompanyCodeFromCustomisation;
  var
    bV63 : boolean;
  begin{GetCompanyCodeFromCustomisation}
    // v6.30.040 - In v6.3 we have access to the company code in the customisation object model
    bV63 := EventData.ClassVersion >= '6.3.048';
    if bV63
    then asCompanyCode := TAbsSetup7(EventData.Setup).ssCompanyCode
    else asCompanyCode := '';
  end;{GetCompanyCodeFromCustomisation}

  function ShowContactSelect({const ACompanyCode, }AnAccountCode
  , AnAccountName : shortString; var iResult : byte; iMode : byte) : shortstring;
  var
    iLine : integer;
    FormMode : TContFormMode;
  begin
    Result := '';

    if iMode = SM_ADD_EMAIL then FormMode := fmSelectEmail
    else FormMode := fmSelect;

    // v6.30.040
    GetCompanyCodeFromCustomisation;

    if bSQL then
    begin
      // MS-SQL
      SQLDataModule := TSQLDataModule.Create(nil);
      SQLDataModule.Connect;
    end
    else
    begin
      // Pervasive
      asCompanyCode := GetCompanyCode_PVSV(asCompanyPath);
    end;{if}

    frmSelectContact := TfrmSelectContact.CreateWithMode(Application, FormMode);

    with frmSelectContact do
    begin
      Try
//        CompanyCode := ACompanyCode;
        AccountCode := AnAccountCode;
        AccountName := AnAccountName;
        if LoadContacts > 0 then
        begin
          iResult := ShowModal;
          with EventData, Transaction do
          begin
            case iMode of
              0 :
              begin
                // normal TX
                case iResult of
                  {Contact Address selected}
                  mrOK  :
                  begin
//                    if Assigned(lvContacts.Selected) then begin
                    if mlContacts.Selected >= 0 then
                    begin
//                      Result := TContactInfo(lvContacts.Selected.Data).ContactRec.coCode;
                      Result := TContactInfo(mlContacts.DesignColumns[0].items.Objects[mlContacts.Selected]).ContactRec.coCode;
                      with TContactInfo(mlContacts.DesignColumns[0].items.Objects[mlContacts.Selected]).ContactRec do
                      begin
                        thDelAddr[1] := Trim(GetFirstAddressLine(TContactInfo(mlContacts.DesignColumns[0].items.Objects[mlContacts.Selected]).ContactRec));
                        thDelAddr[2] := Trim(Copy(coAddress1,1,30));
                        thDelAddr[3] := Trim(Copy(coAddress2,1,30));
                        thDelAddr[4] := Trim(Copy(coAddress3,1,30));
                        { CJS 2013-10-21 MRD2.5.25 - Postcode on Delivery Address }
                        thDelAddr[5] := Trim(Copy(coAddress4,1,30));
                        TAbsInvoice9(Transaction).thDeliveryPostCode := Trim(coPostCode);
                      end;{with}
                    end;{if}
                  end;

                  {restore customer address}
                  mrRetry :
                  begin
                    if thInvDocHed in [CUPIN,CUPPY,CUPCR,CUPJI,CUPJC,CUPRF,CUPPI,CUPQU,CUPOR,CUPDN,CUPBT] then
                    begin
                      For iLine := 1 to 5 do thDelAddr[iLine] := Supplier.acDelAddress[iLine];
                    end
                    else
                    begin
                      For iLine := 1 to 5 do thDelAddr[iLine] := Customer.acDelAddress[iLine];
                    end;{if}
                  end;
                end;{case}
              end;

              1 :
              begin
                // Telesales TX
                case iResult of
                  {Contact Address selected}
                  mrOK  :
                  begin
                    if mlContacts.Selected >= 0 then
                    begin
                      Result := TContactInfo(mlContacts.DesignColumns[0].items.Objects[mlContacts.Selected]).ContactRec.coCode;
                      with TContactInfo(mlContacts.DesignColumns[0].items.Objects[mlContacts.Selected]).ContactRec do
                      begin
                        Customer.acDelAddress[1] := Trim(GetFirstAddressLine(TContactInfo(mlContacts.DesignColumns[0].items.Objects[mlContacts.Selected]).ContactRec));
                        Customer.acDelAddress[2] := Trim(Copy(coAddress1,1,30));
                        Customer.acDelAddress[3] := Trim(Copy(coAddress2,1,30));
                        Customer.acDelAddress[4] := Trim(Copy(coAddress3,1,30));
                        { CJS 2013-10-21 MRD2.5.25 - Postcode on Delivery Address }
                        Customer.acDelAddress[5] := Trim(Copy(coAddress4,1,30));
                        TAbsCustomer5(Customer).acDeliveryPostCode := Trim(coPostCode);
                      end;{with}
                    end;{if}
                  end;

                  {restore customer address}
                  mrRetry :
                  begin
                    if thInvDocHed in [CUPIN,CUPPY,CUPCR,CUPJI,CUPJC,CUPRF,CUPPI,CUPQU,CUPOR,CUPDN,CUPBT] then
                    begin
                      For iLine := 1 to 5 do Customer.acDelAddress[iLine] := Supplier.acDelAddress[iLine];
                    end
                    else
                    begin
                      For iLine := 1 to 5 do Customer.acDelAddress[iLine] := Customer.acDelAddress[iLine];
                    end;{if}
                  end;
                end;{case}
              end;

              SM_ADD_EMAIL :
              begin
                // Add Email address
                case iResult of
                  mrOK  :
                  begin
                    if mlContacts.Selected >= 0 then
                    begin
//                      Result := TContactInfo(mlContacts.DesignColumns[0].items.Objects[mlContacts.Selected]).ContactRec.coCode;
                      with TContactInfo(mlContacts.DesignColumns[0].items.Objects[mlContacts.Selected]).ContactRec do
                      begin
                        Paperless.Email.emToRecipients.AddAddress(Trim(coFirstName)
                        + ' ' + Trim(coSurname), coEmailAddr);
                        boResult := TRUE;
                      end;{with}
                    end;{if}
                  end;
                end;{case}
              end;
            end;{case}
          end;{with}
        end
        else
        begin
          if iMode = SM_ADD_EMAIL then MsgBox('There are currently no contacts available to select from.'
          ,mtInformation,[mbOK], mbOK, 'No Contacts');
        end;{if}
      Finally
        Free;
      End;{try}
    end;{with}

    if Assigned(SQLDataModule) then
    begin
      SQLDataModule.Disconnect;
      SQLDataModule := nil;
    end;{if}
  end;{ShowContactSelect}

  procedure ChangeAccCode(Company, OldCode, NewCode : string);
  var
    LStatus : smallint;
    KeyS : Str255;
    Stat : smallint;
  begin{ChangeAccCode}

    // v6.30.040
    GetCompanyCodeFromCustomisation;

    if bSQL then
    begin
      // MS-SQL
      SQLDataModule := TSQLDataModule.Create(nil);
      SQLDataModule.Connect;
      SQLDataModule.SQLChangeAccountCode(OldCode, NewCode);
      SQLDataModule.Disconnect;
      SQLDataModule := nil;
    end
    else
    begin
      // Pervasive
      LStatus := Open_File(F[ContactF], FileNames[ContactF], 0);
      while LStatus = 0 do
      begin
        KeyS := BuildCodeIndex(Company, OldCode, '');
        LStatus := Find_Rec(B_GetGEq, F[ContactF],ContactF,RecPtr[ContactF]^,CoCodeIdx, KeyS);
        if CheckIndex(ContactRec.coCompany, Company)
        and CheckIndex(ContactRec.coAccount, OldCode) then
        begin
          ContactRec.coAccount := LJVar(NewCode, 10);
          LStatus := Put_Rec(F[ContactF],ContactF,RecPtr[ContactF]^,CoCodeIdx);
          if LStatus <> 0 then ShowMessage('Put_Rec Error: ' + IntToStr(LStatus))
        end
        else
        begin
          LStatus := 9;
        end;{if}
      end;{while}
      Close_File(F[ContactF]);
    end;{if}
  end;{ChangeAccCode}

  procedure DeleteAccCode(Company, AccCode : string);
  var
    LStatus : smallint;
    KeyS : Str255;
    Stat : smallint;
  begin{DeleteAccCode}

    // v6.30.040
    GetCompanyCodeFromCustomisation;

    if bSQL then
    begin
      // MS-SQL
      SQLDataModule := TSQLDataModule.Create(nil);
      SQLDataModule.Connect;
      SQLDataModule.SQLDeleteAccountCode(AccCode);
      SQLDataModule.Disconnect;
      SQLDataModule := nil;
    end
    else
    begin
      // Pervasive
      LStatus := Open_File(F[ContactF], FileNames[ContactF], 0);
      while LStatus = 0 do
      begin
        KeyS := BuildCodeIndex(Company, AccCode, '');
        LStatus := Find_Rec(B_GetGEq, F[ContactF],ContactF,RecPtr[ContactF]^,CoCodeIdx, KeyS);
        if CheckIndex(ContactRec.coCompany, Company)
        and CheckIndex(ContactRec.coAccount, AccCode) then
        begin
          LStatus := Delete_rec(F[ContactF],ContactF,CoCodeIdx);
          if LStatus <> 0 then ShowMessage('Delete_Rec Error: ' + IntToStr(LStatus))
        end
        else
        begin
          LStatus := 9;
        end;{if}
      end;{while}
      Close_File(F[ContactF]);
    end;{if}
  end;{DeleteAccCode}

var
  CompanyCode : string;
  iResult : byte;

  procedure SelectContact;
  begin{SelectContact}
    with EventData do begin
      {is this a valid transaction type ?}
      if (Transaction.thInvDocHed in ValidSalesAccTypes + ValidPurchAccTypes) then
      begin
        if Transaction.thInvDocHed in ValidSalesAccTypes then
        begin
          {sales transactions}
          ShowContactSelect(Customer.acCode, Customer.acCompany, iResult, Ord(HandlerID = 109));
        end
        else
        begin
          {Purchase transactions}
          ShowContactSelect(Supplier.acCode, Supplier.acCompany, iResult, Ord(HandlerID = 109));
        end;{if}
      end;{if}
    end;{with}
  end;{SelectContact}

Begin
  { Handle Hook Events here }

  if bHookEnabled then begin
    with EventData do begin

      asCompanyPath := EventData.Setup3.ssDataPath;
//      sDataPath := Setup.ssDataPath;
      sMiscDirLocation := asCompanyPath;

      oSettings.EXEName := ExtractFilename(GetModuleName(HInstance));
      
      //HV 09/02/2018 2017R1 ABSEXCH-19407: Extended UserProfile and GDPR License support in Plug-in.
      if Assigned(UserProfile5) then
      begin
        GDPRColor := UserProfile5.upHighlightPIIColour;
        IsGDPROn := GDPROnLicense and UserProfile5.upHighlightPIIFields;
      end;

      case WinID of
        wiAccount : {1000}
        begin
          case HandlerID of
            4 :
            begin
              // Account Has Been Deleted. We must update our database.
              if Supplier.AccessRights = NotAvailable
              then DeleteAccCode(GetCompanyCode_PVSV(Setup.ssDataPath), Customer.acCode) // Customer Deleted
              else DeleteAccCode(GetCompanyCode_PVSV(Setup.ssDataPath), Supplier.acCode); // Supplier Deleted
            end;

            // Telesales - Set Delivery Address
            109 : SelectContact;

            111 :
            begin
              // Account Code Has Changed. We must update our database.
              if Supplier.AccessRights = NotAvailable
              then ChangeAccCode(GetCompanyCode_PVSV(Setup.ssDataPath), Customer.acCode, StrResult) // Customer Code Change
              else ChangeAccCode(GetCompanyCode_PVSV(Setup.ssDataPath), Supplier.acCode, StrResult); // SupplierCode Change
            end;

            else
            begin
              // "Contacts" Button Clicked ?
              if HandlerID = iCustHookId then
              begin
                // Customer Contacts
                // CJS 2013-11-06 - MRD 1.1.48 - Extend Contacts plugin to exclude Consumers
                if (TAbsCustomer6(Customer).acSubType = 'C') then
                begin
                  GetCompanyCodeFromCustomisation;
                  ShowContactAdmin({GetCompanyCode_PVSV(asCompanyPath),} Customer.acCode, Customer.acCompany);
                end;
              end
              else
              begin
                // Supplier Contacts
                if HandlerID = iSuppHookId then
                begin
                  GetCompanyCodeFromCustomisation;
                  ShowContactAdmin({GetCompanyCode_PVSV(asCompanyPath),} Supplier.acCode, Supplier.acCompany)
                end;{if}
              end;{if}
            end;
          end;{case}
        end;

        wiTransaction : {2000}
        begin
          // Account Code selected
          if (HandlerID = 9) then SelectContact;
        end;

        wiPrint : {90003}
        begin
          // Add Email Recipient Hook
          if (HandlerID = 1) then ShowContactSelect('', '', iResult, SM_ADD_EMAIL);
        end;

        EnterpriseBase + MiscBase + 2 :
        begin
          case EventData.HandlerId of
            CLOSE_COMPANY :
            begin
              oSettings.Free;
              asCompanyCode := ''; // v6.30.040
            end;
          end;{case}
        end;
      end;{case}
    end;{with}
  end;{if}

  { Pass onto other Hook DLL's }
  DLLChain.ExecCustomHandler(EventData);
end;

end.
