unit oImpDefs;

{ markd6 15:34 01/11/2001: Disabled Byte Alignment in Delphi 6.0 }
{$ALIGN 1}  { Variable Alignment Disabled }

interface

Uses Classes, Dialogs, Forms, SysUtils, Windows, ComObj, ActiveX,
     EnterpriseForms_TLB,
     oFormDet;              // Form Details Object (TEFPrintFormDetails)

type
  TEFImportDefaults = class(TAutoIntfObject, IEFImportDefaults)
  private
    // Base Forms Toolkit object
    FPrintToolkit   : TObject;

    // Form Details sub-object
    FormDetsO       : TEFPrintFormDetails;
    FormDetsI       : IEFPrintFormDetails;

    FAcCode         : ShortString;
    FDataType       : TEFImportDefaultsType;
  protected
    // IEFImportDefaults
    function Get_idType: TEFImportDefaultsType; safecall;
    procedure Set_idType(Value: TEFImportDefaultsType); safecall;
    function Get_idAcCode: WideString; safecall;
    procedure Set_idAcCode(const Value: WideString); safecall;
    function Get_idMainFileNo: Integer; safecall;
    procedure Set_idMainFileNo(Value: Integer); safecall;
    function Get_idMainIndexNo: Integer; safecall;
    procedure Set_idMainIndexNo(Value: Integer); safecall;
    function Get_idMainKeyString: WideString; safecall;
    procedure Set_idMainKeyString(const Value: WideString); safecall;
    function Get_idTableFileNo: Integer; safecall;
    procedure Set_idTableFileNo(Value: Integer); safecall;
    function Get_idTableIndexNo: Integer; safecall;
    procedure Set_idTableIndexNo(Value: Integer); safecall;
    function Get_idTableKeyString: WideString; safecall;
    procedure Set_idTableKeyString(const Value: WideString); safecall;
    procedure ImportDefaults; safecall;
    procedure AddLabels; safecall;

    // Local Methods
    procedure AddIdLabels;
    procedure AddLineSerialLabels;
    procedure AddSerialLabels;
    procedure AddStocklabels;
    Function  GetMsgText(Var MsgText : ANSIString; FName : ShortString) : Boolean;
  public
    Constructor Create (Const PrintToolkit : TObject);
    Destructor Destroy; override;
  End; { TEFImportDefaults }

implementation

uses ComServ,
     GlobVar,          // Exchequer Global Types/Const/Var
     VarConst,         // Exchequer Global Types/Const/Var
     VarRec2U,         // Additional Exchequer Global Types/Const/Var
     GlobType,         // Form Designer global Types and Var's
     BtrvU2,           // Btrieve routines
     BTSupU1,          // Exchequer Btrieve support Routines
     BTKeys1U,         // Exchequer Key building routines
     SysU2,            // Exchequer Misc Routines
     ETStrU,           // Exchequer String functions
     ETMiscU,          // Exchequer Misc functions
     Register,         // FormDes routines for accessing EFD Files
     MiscFunc,         // Forms Toolkit misc Const/Type/Var/Functions
     oFormInf,         // Form Info Object  (TEFFormDefInfo)
     oMain,            // Main Form Toolkit Object
     // MH 24/01/2014 v7.0.9 ABSEXCH-14974: Added Ledger Multi-Contacts support
     AccountContactRoleUtil,
     // MH 17/02/2014 v7.0.9 ABSEXCH-14980: Added MadExcept Logging
     MadExcept,
     LogUtil;

Const
  {$I FilePath.Inc}

//-----------------------------------------------------------------------------

Constructor TEFImportDefaults.Create (Const PrintToolkit : TObject);
Begin { Create }
  Inherited Create (ComServer.TypeLib, IEFImportDefaults);

  FPrintToolkit := PrintToolkit;

  // Form Details sub-object
  FormDetsO := TEFPrintFormDetails.Create (imAdd, (FPrintToolkit As TEFPrintingToolkit).PrintJobO.FormsListO);
  FormDetsI := FormDetsO;

  // HM 15/01/03: Set form mode - otherwise never gets set
  FormDetsI.fdMode := (FPrintToolkit As TEFPrintingToolkit).PrintJobO.FDefPrintMode;
End; { Create }

//----------------------------------------

Destructor TEFImportDefaults.Destroy;
Begin { Destroy }
  FormDetsO := NIL;
  FormDetsI := NIL;

  FPrintToolkit := NIL;

  inherited Destroy;
End; { Destroy }

//-----------------------------------------------------------------------------

function TEFImportDefaults.Get_idType: TEFImportDefaultsType;
begin
  Result := FDataType
end;

procedure TEFImportDefaults.Set_idType(Value: TEFImportDefaultsType);
begin
  FDataType := Value;
end;

//----------------------------------------

function TEFImportDefaults.Get_idAcCode: WideString;
begin
  Result := FAcCode;
end;

procedure TEFImportDefaults.Set_idAcCode(const Value: WideString);
begin
  FAcCode := Value;
end;

//----------------------------------------

function TEFImportDefaults.Get_idMainFileNo: Integer;
begin
  Result := FormDetsI.fdMainFileNo;
end;

procedure TEFImportDefaults.Set_idMainFileNo(Value: Integer);
begin
  FormDetsI.fdMainFileNo := Value;
end;

//----------------------------------------

function TEFImportDefaults.Get_idMainIndexNo: Integer;
begin
  Result := FormDetsI.fdMainIndexNo;
end;

procedure TEFImportDefaults.Set_idMainIndexNo(Value: Integer);
begin
  FormDetsI.fdMainIndexNo := Value;
end;

//----------------------------------------

function TEFImportDefaults.Get_idMainKeyString: WideString;
begin
  Result := FormDetsI.fdMainKeyString;
end;

procedure TEFImportDefaults.Set_idMainKeyString(const Value: WideString);
begin
  FormDetsI.fdMainKeyString := Value;
end;

//----------------------------------------

function TEFImportDefaults.Get_idTableFileNo: Integer;
begin
  Result := FormDetsI.fdTableFileNo;
end;

procedure TEFImportDefaults.Set_idTableFileNo(Value: Integer);
begin
  FormDetsI.fdTableFileNo := Value;
end;

//----------------------------------------

function TEFImportDefaults.Get_idTableIndexNo: Integer;
begin
  Result := FormDetsI.fdTableIndexNo;
end;

procedure TEFImportDefaults.Set_idTableIndexNo(Value: Integer);
begin
  FormDetsI.fdTableIndexNo := Value;
end;

//----------------------------------------

function TEFImportDefaults.Get_idTableKeyString: WideString;
begin
  Result := FormDetsI.fdTableKeyString;
end;

procedure TEFImportDefaults.Set_idTableKeyString(const Value: WideString);
begin
  FormDetsI.fdTableKeyString := Value;
end;

//-----------------------------------------------------------------------------

procedure TEFImportDefaults.ImportDefaults;
Var
  KeyS               : Str255;
  LStatus, PrnIdx    : SmallInt;
  UserId             : String[10];
  TempSys            : SysRec;
  FormDefSet         : FormDefsRecType;
  FormType, DefIdx   : Byte;
  MsgText            : ANSIString;
  FormDefI           : IEFFormDefInfo;
  // MH 24/01/2014 v7.0.9 ABSEXCH-14974: Added Ledger Multi-Contacts support
  RoleId             : Integer;
  sContactName, sContactFaxNumber : ShortString;
  sContactEmailAddr, sName, sEmail : ANSIString;
  iColPos : Integer;
begin
  // MH 17/02/2014 v7.0.9 ABSEXCH-14980: Added MadExcept Logging
  Try
    With (FPrintToolkit As TEFPrintingToolkit), PrintJobO, PrintJobI Do
    Begin
      // HM 11/04/03: Added global default sender name & Address
      If eCommsModule Then Begin
        // Fax Defaults -----------------------
        With pjFaxInfo Do Begin
          PrintJobSetupInfo.feFaxFrom := SyssEDI2^.EDI2Value.FxPhone;
        End; { With pjFaxInfo }

        // Email Defaults ---------------------
        With pjEmailInfo Do Begin
          PrintJobSetupInfo.feEmailFrom   := SyssEDI2^.EDI2Value.EmName;
          PrintJobSetupInfo.feEmailFromAd := SyssEDI2^.EDI2Value.EmAddress;
        End; { With pjEmailInfo }
      End; { If eCommsModule }

      With PrintersI Do Begin
        // Setup Default Printer from System Setup
        PrnIdx := 0;
        If (Trim(SyssVAT.VATRates.FormsPrnN) <> '') Then
          // Search for printer in printers list
          PrnIdx := IndexOf(SyssVAT.VATRates.FormsPrnN);

        If (PrnIdx = 0) Then
          // No printer found - Use Windows Default
          PrnIdx := prDefaultPrinter;

        If (PrnIdx > 0) Then Begin
          // Found - set Device Index to True RpDev index
          PrintJobSetupInfo.DevIdx := PrnIdx - 1;
          If prPrinters[PrnIdx].pdSupportsPapers Then pjPaperIndex := prPrinters[PrnIdx].pdDefaultPaper;
          If prPrinters[PrnIdx].pdSupportsBins Then pjBinIndex := prPrinters[PrnIdx].pdDefaultBin;
        End; { If (PrnIdx > 0) And (DevIdx <> PrnIdx - 1) }
      End; { With PrintersI  }

      // MH 24/01/2014 v7.0.9 ABSEXCH-14974: Added Ledger Multi-Contacts support
      RoleId := -1;

      // Identify the correct form for the DefaultsType passed in
      Case FDataType Of
        deftypeSalesInvoice               : Begin
                                              DefIdx := 6;
                                              RoleId := riSendInvoices;
                                            End;
        deftypeSalesInvoiceWithReceipt    : Begin
                                              DefIdx := 7;
                                              RoleId := riGeneralContact;
                                            End;
        deftypeSalesCreditNote            : Begin
                                              DefIdx := 8;
                                              RoleId := riGeneralContact;
                                            End;
        deftypeSalesRefund                : Begin
                                              DefIdx := 9;
                                              RoleId := riGeneralContact;
                                            End;
        deftypeSalesQuote                 : Begin
                                              DefIdx := 10;
                                              RoleId := riSendQuote;
                                            End;
        deftypeSalesOrder                 : Begin
                                              DefIdx := 11;
                                              RoleId := riSendOrders;
                                            End;
        deftypeSalesProForma              : Begin
                                              DefIdx := 12;
                                              RoleId := riSendQuote
                                            End;
        deftypeSalesDeliveryNote          : Begin
                                              DefIdx := 13;
                                              RoleId := riSendDeliveryNotes;
                                            End;
        deftypeSalesReceipt               : Begin
                                              DefIdx := 14;
                                              RoleId := riSendReceipt;
                                            End;
        deftypeSalesJournalInvoice        : Begin
                                              DefIdx := 15;
                                              RoleId := riGeneralContact;
                                            End;
        deftypeSalesJournalCredit         : Begin
                                              DefIdx := 16;
                                              RoleId := riGeneralContact;
                                            End;
        deftypeSalesReceiptDetails        : Begin
                                              DefIdx := 45;
                                              RoleId := riSendReceipt;
                                            End;
        deftypePurchaseInvoice            : Begin
                                              DefIdx := 22;
                                              RoleId := riSendInvoices;
                                            End;
        deftypePurchasePayment            : Begin
                                              DefIdx := 41;
                                              RoleId := riSendRemittance;
                                            End;
        deftypePurchaseCreditNote         : Begin
                                              DefIdx := 23;
                                              RoleId := riGeneralContact;
                                            End;
        deftypePurchaseQuotation          : Begin
                                              DefIdx := 24;
                                              RoleId := riSendQuote;
                                            End;
        deftypePurchaseOrder              : Begin
                                              DefIdx := 25;
                                              RoleId := riSendOrders;
                                            End;
        deftypePurchaseDeliveryNote       : Begin
                                              DefIdx := 42;
                                              RoleId := riSendDeliveryNotes;
                                            End;
        deftypePurchaseJournalInvoice     : Begin
                                              DefIdx := 26;
                                              RoleId := riGeneralContact;
                                            End;
        deftypePurchaseJournalCredit      : Begin
                                              DefIdx := 27;
                                              RoleId := riGeneralContact;
                                            End;
        deftypePurchasePaymentWithInvoice : Begin
                                              DefIdx := 28;
                                              RoleId := riGeneralContact;
                                            End;
        deftypePurchaseRefund             : Begin
                                              DefIdx := 29;
                                              RoleId := riGeneralContact;
                                            End;
        deftypePurchasePaymentDebitNote   : Begin
                                              DefIdx := 46;
                                              RoleId := riSendRemittance;
                                            End;
        deftypeTimesheet                  : DefIdx := 35;
        deftypeWorksIssueNote             : DefIdx := 48;
        deftypeWorksOrder                 : DefIdx := 49;
        deftypeNominalTransfer            : DefIdx := 33;
        deftypeBatch                      : Begin
                                              DefIdx := 34;
                                              RoleId := riGeneralContact;
                                            End;
        defTypeStockAdjustment            : DefIdx := 32;
        deftypeDeliveryLabel              : DefIdx := 20;
        defTypeProductLabel,
        defTypeStockLabel,
        defTypeTransSerialLabels,
        defTypeTransLineSerialLabels,
        defTypeTransProductLabels         : DefIdx := 21;
        defTypeConsignmentNote            : Begin
                                              DefIdx := 19;
                                              RoleId := riSendDeliveryNotes;
                                            End;
        defTypePickingList                : DefIdx := 18;
        defTypeConsolidatedPickingList    : DefIdx := 17;
        //defTypeTransNotes  - No Default Form
        defTypeJobWithNotes               : DefIdx := 37;
        defTypeJCBackingSheet             : DefIdx := 36;

        // HM 23/02/04: Added Stock Forms
        defTypeStockWithBOM               : DefIdx := 30;
        defTypeStockWithNotes             : DefIdx := 31;

        // HM 23/02/04: Added Account Forms
        defTypeAccountWithNotes           : Begin
                                              DefIdx := 1;
                                              RoleId := riGeneralContact;
                                            End;
        defTypeAccountStatement           : Begin
                                              DefIdx := 4;
                                              RoleId := riSendStatement;
                                            End;
        defTypeAccountTradingLedger       : Begin
                                              DefIdx := 2;
                                              RoleId := riGeneralContact;
                                            End;
        defTypeAccountLabel               : DefIdx := 3;

        // HM 09/03/04: Added Apps & Vals
        defTypeJobPurchaseTerms                : DefIdx := 55;
        defTypeJobSalesTerms                   : DefIdx := 56;
        defTypeJobContractTerms                : DefIdx := 57;
        defTypeJobPurchaseApplication          : DefIdx := 58;
        defTypeJobSalesApplication             : DefIdx := 59;
        defTypeJobPurchaseApplicationCertified : DefIdx := 60;
        defTypeJobSalesApplicationCertified    : DefIdx := 61;

        // MH 28/07/05: Added Return Notes
        defTypeSalesReturnNote            : Begin
                                              DefIdx := 62;
                                              RoleId := riGeneralContact;
                                            End;
        defTypeSRNAsRepairQuote           : Begin
                                              DefIdx := 63;
                                              RoleId := riGeneralContact;
                                            End;
        defTypePurchaseReturnNote         : Begin
                                              DefIdx := 64;
                                              RoleId := riGeneralContact;
                                            End;

        // MH 17/09/2014 Order Payments: Added support for printing SRC's as VAT Receipts
        defTypePaymentSRCAsVATReceipt     : Begin
                                              DefIdx := 65;
                                              RoleId := riSendReceipt;
                                            End;
        defTypeRefundSRCAsVATReceipt      : Begin
                                              DefIdx := 66;
                                              RoleId := riSendReceipt;
                                            End;
      Else
        DefIdx := 0;
      End; { Case FFormMode }

      // Default to global Form Definition Set
      FormDefSet := SyssForms^;

      // Load Customer and Import recipient details
      If (Trim(FAcCode) <> '') Then Begin
        KeyS := FullCustCode(FAcCode);
        LStatus := Find_Rec(B_GetEq, F[CustF], CustF, RecPtr[CustF]^, CustCodeK, KeyS);
        If (LStatus = 0) Then Begin
          // Check for Customer Specific Form Definition Set
          If (Cust.FDefPageNo > 0) Then Begin
            TempSys := Syss;

            // Load additional form definition set
            KeyS := Copy(SysNames[FormR], 1,2 ) + Chr(Cust.FDefPageNo+100);
            LStatus := Find_Rec(B_GetEq, F[SysF], SysF, RecPtr[SysF]^, 0, KeyS);
            If (LStatus = 0) Then
              // Found - overwrite local copy of FormDefs
              Move(Syss,FormDefSet,Sizeof(FormDefsRecType));

            Syss := TempSys;
          End; { If (Cust.FDefPageNo > 0) }

          If eCommsModule Then Begin
            // Fax Defaults -----------------------
            With pjFaxInfo Do Begin
              // Cover Sheet
              FormType := GetFormType (FormDefSet.FormDefs.PrimaryForm[44]);     // Fax Cover Sheet
              If (FormType <> 0) Then
                fxCoverSheet := FormDefSet.FormDefs.PrimaryForm[44];

              // Recipient Name
              fxRecipientName := Trim(Cust.Company);
              If (Trim(Cust.Contact) <> '') Then
                fxRecipientName := fxRecipientName + ', ' +  Trim(Cust.Contact);

              // Recipient Fax Number
              fxRecipientFaxNumber := Cust.Fax;
            End; { With pjFaxInfo }

            // Email Defaults ---------------------
            With pjEmailInfo Do Begin
              // Cover Sheet
              FormType := GetFormType (FormDefSet.FormDefs.PrimaryForm[43]);     // Email Cover Sheet
              If (FormType <> 0) Then
                emCoverSheet := FormDefSet.FormDefs.PrimaryForm[43];

              // Recipient Name & Email Address
              emToRecipients.AddAddress (pjFaxInfo.fxRecipientName, Cust.EmailAddr);

              // ZIP Attachments?
              Case Cust.EmlZipAtc Of
                0 : emFormCompression := fcNone;
                1 : emFormCompression := fcZIP;
                2 : emFormCompression := fcEDZ;
              End; { Case Cust.EmlZipAtc }

              // Send Reader
              emSendReader := Cust.EmlSndRdr;
  { TODO -cQUESTION : Reset Cust.EmlSndRdr flag here }

              // Reader Message
              If emSendReader And GetMsgText(MsgText, 'Reader.Txt') Then
                // Got User Signature
                emMessageText := MsgText
              Else
                emMessageText := '';
            End; { With pjEmailInfo }

            // MH 24/01/2014 v7.0.9 ABSEXCH-14974: Added Ledger Multi-Contacts support
  //ShowMessage ('RoleId: ' + IntToStr(RoleId));
            If (RoleId <> -1) Then
            Begin
              // Look for the required Account Contact Role
              sContactName := '';
              sContactFaxNumber := '';
              sContactEmailAddr := '';

  //ShowMessage ('Calling FindAccountContactRole (AcCode=' + Cust.CustCode + ', RoleId=' + IntToStr(RoleId) + ')');
              If FindAccountContactRole (Cust.CustCode, RoleId, sContactName, sContactFaxNumber, sContactEmailAddr) Then
              Begin
                // Copy the details in overwriting the defaults set above
  //ShowMessage ('FindAccountContactRole (sContactName=' + sContactName + ', sContactFaxNumber=' + sContactFaxNumber + ', sContactEmailAddr=' + sContactEmailAddr + ')');

                // Fax Defaults -----------------------
                // Recipient Name
                pjFaxInfo.fxRecipientName := Trim(Cust.Company);
                If (Trim(sContactName) <> '') Then
                  pjFaxInfo.fxRecipientName := pjFaxInfo.fxRecipientName + ', ' +  Trim(sContactName);

                // Recipient Fax Number
                pjFaxInfo.fxRecipientFaxNumber := sContactFaxNumber;

  // Fake the email name/address details as waiting on Phil to do something :-(
  //sContactEmailAddr := 'Mark Higginson;Mark.Higginson@AdvancedComputerSoftware.com;Paul Rutherford;Paul.Rutherford@AdvancedComputerSoftware.com;Chris Sandow;Chris.Sandow@AdvancedComputerSoftware.com;Philip Rogers;Philip.Rogers@AdvancedComputerSoftware.com;';

                // Email Defaults ---------------------
                If (sContactEmailAddr <> '') Then
                Begin
                  // Recipient Name & Email Address
                  pjEmailInfo.emToRecipients.Clear;

                  // Run through the Recipient Details adding them into the list, the string should contain a series of <Name>;<EmailAddress>; fields
                  iColPos := Pos (';', sContactEmailAddr);
                  While (iColPos > 0) Do
                  Begin
                    // Extract name from recipients string
                    sName := Copy (sContactEmailAddr, 1, Pred(iColPos));
                    Delete (sContactEmailAddr, 1, iColPos);

                    // Look for email address
                    iColPos := Pos (';', sContactEmailAddr);
                    If (iColPos > 0) Then
                    Begin
                      sEmail := Copy (sContactEmailAddr, 1, Pred(iColPos));
                      Delete (sContactEmailAddr, 1, iColPos);

                      // If we have some details then add them into the list
                      If (sName <> '') Or (sEmail <> '') Then
                      Begin
                        pjEmailInfo.emToRecipients.AddAddress (sName, sEmail);
                      End; // If (sName <> '') Or (sEmail <> '')

                      iColPos := Pos (';', sContactEmailAddr);
                    End; // If (iColPos > 0)
                  End; // While (iColPos > 0)
                End; // If (sContactEmailAddr <> '')
              End; // If FindAccountContactRole (LCust.CustCode, RoleId, sContactName, sContactFaxNumber, sContactEmailAddr)
            End; // If (RoleId <> -1)
          End; { If eCommsModule }
        End; { If (LStatus = 0) }
      End; { If (Trim(AcCode) <> '') }

      // Check for pre-existing forms - don't add default if already present
      If (pjForms.pfCount = 0) Then Begin
        // Check Form Index is valid and the form exists before addint into PrintJob
        If (DefIdx > 0) And (DefIdx <= High(FormDefSet.FormDefs.PrimaryForm)) Then Begin
          FormType := GetFormType (FormDefSet.FormDefs.PrimaryForm[DefIdx]);
          If (FormType <> 0) Then Begin
            // Setup form name from form definition set
            FormDetsI.fdFormName := FormDefSet.FormDefs.PrimaryForm[DefIdx];

            // Add form details into Print Job
            FormsListO.AddNewForm(FormDetsO);
          End; { If (FormType <> 0) }
        End; { If (DefIdx > 0) And (DefIdx < High(FormDefSet.FormDefs.PrimaryForm)) }
      End; { If (FFormsListI.pfCount = 0) }
  { TODO : Do we need this section? If so - where? }
  (***
      Else Begin
        // Check for non-standard print jobs
        If (FDataType = defTypeTransSerialLabels) Then Begin
          // Label Run - update all form details with correct default form
          FormType := GetFormType (FormDefSet.FormDefs.PrimaryForm[DefIdx]);
          If (FormType = 1) Then
            For I := 1 To pjForms.pfCount Do
              pjForms.pfForms[I].fdFormName := FormDefSet.FormDefs.PrimaryForm[DefIdx];
        End; { If (FDataType = defTypeProductLabelRun) }
      End; { Else }
  ***)

      // Check for a Form within the Print-Job
      If (pjForms.pfCount > 0) Then Begin
        // Load the defaults for the first form
        FormDefI := TEFFormDefInfo.Create (pjForms[1].fdFormName);
        With FormDefI Do
          Try
            // Default Number of Copies
            If (fiCopies > 0) Then
              pjCopies := fiCopies;

            // Printer Details
            If (fiPrinterIndex >= 1) And (fiPrinterIndex < PrintersI.prCount) Then
              pjPrinterIndex := fiPrinterIndex;
            If (fiBinIndex > 0) Then
              pjBinIndex := fiBinIndex;
            If (fiPaperIndex > 0) Then
              pjPaperIndex := fiPaperIndex;
          Finally
            FormDefI := NIL;
          End;
      End; { If (pjForms.pfCount > 0) }

      // Paperless - Import Fax and Email Signatures
      If eCommsModule Then Begin
        // Sending Fax Number
        pjFaxInfo.fxSenderFaxNumber := SyssEDI2^.EDI2Value.FxPhone;

        // Company/User Signature for Fax
        If GetMsgText(MsgText, Trim(pjUserId) + '.Tx2') Then
          // Got User Signature
          pjFaxInfo.fxMessageText := pjFaxInfo.fxMessageText + MsgText
        Else
          // Try for Company Signature
          If GetMsgText(MsgText, 'Company.Tx2') Then
            // Got Company Signature
            pjFaxInfo.fxMessageText := pjFaxInfo.fxMessageText + MsgText;

        // Company/User Signature for Email Message
        If GetMsgText(MsgText, Trim(pjUserId) + '.Txt') Then
          // Got User Signature
          pjEmailInfo.emMessageText := pjEmailInfo.emMessageText + MsgText
        Else
          // Try for Company Signature
          If GetMsgText(MsgText, 'Company.Txt') Then
            // Got Company Signature
            pjEmailInfo.emMessageText := pjEmailInfo.emMessageText + MsgText;
      End; { If eCommsModule }

      // Check for Enhanced Security - need to bring in User Profile defaults if available
      If EnSecurity Then
        // Load User Details if feUserId is set
        If (Trim(PrintJobSetupInfo.feUserId) <> '') Then Begin
          // Setup User Id with correct padding
          UserId := LJVar(Trim(PrintJobSetupInfo.feUserId),LoginKeyLen);

          // Check we don't already have it loaded
          If (Trim(UserId) <> Trim(UserProfile^.Login)) Then Begin
            // blank out the record incase the User Id is invalid
            FillChar (UserProfile^, SizeOf(UserProfile^), #0);

            KeyS := FullPWordKey(PassUCode,'D',UserId);
            LStatus := Find_Rec(B_GetEq,F[MLocF],MLocF,RecPtr[MLocF]^,MLK,KeyS);
            If (LStatus = 0) then
              UserProfile^ := MLocCtrl^.PassDefRec
            Else
              UserProfile^.Login := LJVar(UserId,LoginKeyLen);
          End; { If (Trim(UserId) <> Trim(UserProfile^.Login)) }

          // Copy defaults into PrintJob
          If (Trim(UserProfile^.UserName) <> '') Then Begin
            // User Name
            PrintJobSetupInfo.feEmailFrom := UserProfile^.UserName;
            PrintJobSetupInfo.feFaxFrom := UserProfile^.UserName;
          End; { If (Trim(UserProfile^.UserName) <> '') }

          If (Trim(UserProfile^.EmailAddr) <> '') Then
            // User Email Address
            PrintJobSetupInfo.feEmailFromAd := UserProfile^.EmailAddr;

          If (Trim(UserProfile^.FormPrn) <> '') Then Begin
            // Default Printer
            If (Pos ('Use Windows Default', UserProfile^.FormPrn) = 1) Then Begin
              // Change Printer to Windows Default Printer
              With (FPrintToolkit As TEFPrintingToolkit).PrintersI Do
                // Check for changes
                If (PrintJobSetupInfo.DevIdx <> prDefaultPrinter - 1) Then Begin
                  PrintJobSetupInfo.DevIdx := prDefaultPrinter - 1;
                  If prPrinters[PrnIdx].pdSupportsPapers Then Set_pjPaperIndex(prPrinters[prDefaultPrinter].pdDefaultPaper);
                  If prPrinters[PrnIdx].pdSupportsBins Then Set_pjBinIndex(prPrinters[prDefaultPrinter].pdDefaultBin);
                End; { If (PrnIdx <> prDefaultPrinter - 1) }
            End { If (Pos ('Use Windows Default', UserProfile^.FormPrn) = 1) }
            Else Begin
              If (Pos ('Use Enterprise Defau', UserProfile^.FormPrn) = 1) Then
                // No Action - Exchequer Default already setup
              Else
                // Change to specified printer
                With (FPrintToolkit As TEFPrintingToolkit).PrintersI Do Begin
                  // Search for printer in printers list
                  PrnIdx := IndexOf(UserProfile^.FormPrn);
                  If (PrnIdx > 0) And (PrintJobSetupInfo.DevIdx <> PrnIdx - 1) Then Begin
                    // Found - set Device Index to True RpDev index
                    PrintJobSetupInfo.DevIdx := PrnIdx - 1;
                    If prPrinters[PrnIdx].pdSupportsPapers Then Set_pjPaperIndex(prPrinters[PrnIdx].pdDefaultPaper);
                    If prPrinters[PrnIdx].pdSupportsBins Then Set_pjBinIndex(prPrinters[PrnIdx].pdDefaultBin);
                  End; { If (PrnIdx > 0) And (DevIdx <> PrnIdx - 1) }
               End; { With (FPrintToolkit As TEFPrintingToolkit).PrintersI }
            End; { Else }
          End; { If (Trim(UserProfile^.FormPrn) <> '') }
        End; { If (Trim(PrintJobSetupInfo.feUserId) <> '') }
    End; { With (FPrintToolkit As TEFPrintingToolkit) }
  Except
    // MH 17/02/2014 v7.0.9 ABSEXCH-14980: Added MadExcept Logging    
    // Log the exception to file and re-raise it so the exception is passed back to the calling app
    AutoSaveBugReport(CreateBugReport(etNormal));
    Raise;
  End;
end;

//----------------------------------------

Function TEFImportDefaults.GetMsgText(Var MsgText : ANSIString; FName : ShortString) : Boolean;
Begin { GetMsgText }
  // Build full path to potential file
  FName := IncludeTrailingPathDelimiter(SystemInfo.ExDataPath) + PathMaster + FName;

  // Check to see if signature exists
  Result := FileExists (FName);

  If Result Then
    // Load File into stringlist and return text
    With TStringList.Create Do
      Try
        LoadFromFile(FName);
        MsgText := Text;
      Finally
        Free;
      End
  Else
    MsgText := '';
End; { GetMsgText }

//-----------------------------------------------------------------------------

procedure TEFImportDefaults.AddLabels;
Begin { AddLabels }
  OutputDebug('TEFImportDefaults.AddLabels Start');
  // MH 17/02/2014 v7.0.9 ABSEXCH-14980: Added MadExcept Logging

  Try
    Case FDataType Of
      defTypeTransSerialLabels     : AddSerialLabels;
      defTypeTransProductLabels    : AddStocklabels;
      defTypeTransLineSerialLabels : AddLineSerialLabels;
    Else
      Raise EUnknownValue.Create (Format('Unknown Mode (%d) in IEFImportDefaults.AddLabels', [Ord(FDataType)]));
    End; { Case FDataType }
  Except
    // MH 17/02/2014 v7.0.9 ABSEXCH-14980: Added MadExcept Logging
    // Log the exception to file and re-raise it so the exception is passed back to the calling app
    AutoSaveBugReport(CreateBugReport(etNormal));
    Raise;
  End;
  OutputDebug('TEFImportDefaults.AddLabels End');
End; { AddLabels }

//-----------------------------------------------------------------------------

// Serial Number Labels - Runs through Serial Numbers for current transaction line (Id)
// adding into Batch where appropriate
procedure TEFImportDefaults.AddIdLabels;
Var
  SnoFormDetsO                    : TEFPrintFormDetails;
  SnoFormDetsI                    : IEFPrintFormDetails;
  KeyS, SKeyS, SKeyChk            : Str255;
  lStkStatus, lSnoStatus          : SmallInt;
  SerCount, SerGot                : Double;
  FoundAll, FoundOk, SalesDoc     : Boolean;
  RecAddr                         : LongInt;
Begin { AddIdLabels }
  OutputDebug('TEFImportDefaults.AddIDLabels Start');
  // Check for a valid Stock Code which uses Serial/Batch
  If (Trim(Id.StockCode) <> '') Then Begin
    // Load Stock Record
    KeyS := FullStockCode(Id.StockCode);
    lStkStatus := Find_Rec(B_GetGEq, F[StockF], StockF, RecPtr[StockF]^, StkCodeK, KeyS);
    If (lStkStatus = 0) Then
      // Check Stock Type
      If (Is_SerNo(Stock.StkValType)) And (Id.SerialQty <> 0.0) Then Begin
        // Process Serial No's for Line
        SerCount := 0.0;
        SerGot   := Id.SerialQty;

        // Determine whether to check In or Out Documents
        SalesDoc := (Id.IdDocHed In SalesSplit) or ((Id.IdDocHed In WOPSplit) and (Id.LineNo<>1));

        If (Id.IdDocHed In WOPSPlit) and (SerGot < 0) and (Id.LineNo <> 1) then
          SerGot := SerGot * DocNotCnst;

        If SalesDoc then
          SKeyChk := FullQDKey (MFIFOCode, MSERNSub, FullNomKey(Stock.StockFolio)+#1)
        Else
          SKeyChk := FullQDKey (MFIFOCode, MSERNSub, FullNomKey(Stock.StockFolio));
        SKeyS := SKeyChk + NdxWeight;

        // Look for Serial/Batch records for the stock item
        FoundAll := False;
        lSnoStatus := Find_Rec(B_GetLessEq, F[MiscF], MiscF, RecPtr[MiscF]^, MIK, SKeyS);
        While (lSnoStatus = 0) And (CheckKey(SKeyChk,SKeyS,Length(SKeyChk),BOn)) And (Not FoundAll) Do
          With MiscRecs^.SerialRec Do Begin
            If SalesDoc then
              // Sales Doc - check Out Documents
              FoundOk := (CheckKey(Id.DocPRef,OutDoc,Length(Id.DocPRef),BOff) and (SoldLine=Id.ABSLineNo)) Or
                         (CheckKey(Id.DocPRef,OutOrdDoc,Length(Id.DocPRef),BOff) and (OutOrdLine=Id.ABSLineNo))
            Else
              // Purchase Doc - Check In Documents
              FoundOk:= (CheckKey(Id.DocPRef,InDoc,Length(Id.DocPRef),BOff) and (BuyLine=Id.ABSLineNo)) or
                        (CheckKey(Id.DocPRef,InOrdDoc,Length(Id.DocPRef),BOff) and (InOrdLine=Id.ABSLineNo));

            If FoundOk Then Begin
              // Got Serial Record - Add into PrintJob
              SnoFormDetsO := TEFPrintFormDetails.Create (imAdd, (FPrintToolkit As TEFPrintingToolkit).PrintJobO.FormsListO);
              SnoFormDetsI := SnoFormDetsO;
              With SnoFormDetsO Do Begin
                With SnoFormDetsI Do Begin
                  // Setup type of print job
                  fdMode := EnterpriseForms_TLB.fmSerialLabel;

                  // Setup form name from form definition set
                  fdFormName := SyssForms^.FormDefs.PrimaryForm[21];

                  // Print 1 label per serial/batch record
                  fdLabelCopies := 1;

                  fdMainFileNo := IDetailF;
                  fdMainIndexNo := IDLinkK;
                  fdMainKeyString := FullNomKey(Id.FolioRef) + FullNomKey(ID.ABSLineNo);

                  fdTableFileNo := 0;
                  fdTableIndexNo := 0;
                  fdTableKeyString := '';
                End; { With SnoFormDetsI }

                // Serial No Labels require the Record Position of the Serial Record so that it can be loaded
                GetPos(F[MiscF], MiscF, RecAddr);
                SnoFormDetsI.fdSerialPos := RecAddr;
              End; { With SnoFormDetsO }

              If (SnoFormDetsI.fdLabelCopies > 0) Then
                // Add form details into Print Job
                (FPrintToolkit As TEFPrintingToolkit).PrintJobO.FormsListO.AddNewForm(SnoFormDetsO);

              // Adjust Count of found Serial Numbers
              If (Not BatchChild) Or SalesDoc Then Begin
                If BatchRec Then Begin
                  If (SalesDoc) then
                    SerCount:=SerCount+QtyUsed
                  else
                    SerCount:=SerCount+BuyQty;
                End { If BatchRec  }
                Else
                  SerCount:=SerCount+1.0;
              End; { If (Not BatchChild) Or SalesDoc  }
            End; { If FoundOk }

            FoundAll := (SerCount >= SerGot);
            If (Not FoundAll) then
              lSnoStatus := Find_Rec(B_GetPrev, F[MiscF], MiscF, RecPtr[MiscF]^, MIK, SKeyS);
          End; { With LMiscRecs^.SerialRec }
      End; { If (Is_SerNo(Stock.StkValType)) And (SerialQty <> 0.0) }
  End; { If (Trim(Id.StockCode) <> '') }
  OutputDebug('TEFImportDefaults.AddIDLabels End');
End; { AddIdLabels }

//-----------------------------------------------------------------------------

// Serial Number Labels - Run through transaction lines processing Serial Numbers
procedure TEFImportDefaults.AddSerialLabels;
Var
  KeyS       : Str255;
  lStatus    : SmallInt;
  FormType   : Byte;
begin { AddSerialLabels }
  // Check that there is a default form defined for Product Labels - can't add Serial
  // Labels without a vaid form - PCC Labels not currently supported
  If (Trim(SyssForms^.FormDefs.PrimaryForm[21]) <> '') Then
    FormType := GetFormType (SyssForms^.FormDefs.PrimaryForm[21])
  Else
    FormType := 0;

  If (FormType = 1) Then Begin
    // Got a valid EFD form
    With FormDetsI Do Begin
      // Load Transaction
      KeyS := fdMainKeyString;
      lStatus := Find_Rec(B_GetEq, F[fdMainFileNo], fdMainFileNo, RecPtr[fdMainFileNo]^, fdMainIndexNo, KeyS);
      If (lStatus = 0) Then Begin
        // Got Transaction - Run through lines
        KeyS := FullNomKey (Inv.FolioNum);
        lStatus := Find_Rec(B_GetGEq, F[IDetailF], IDetailF, RecPtr[IDetailF]^, IdLinkK, KeyS);
        While (lStatus = 0) And (Id.FolioRef = Inv.FolioNum) Do Begin
          // Add serial labels for current line (Id)
          AddIdLabels;

          lStatus := Find_Rec(B_GetNext, F[IDetailF], IDetailF, RecPtr[IDetailF]^, IdLinkK, KeyS);
        End; { While (lStatus = 0) And (Id.FolioRef = Inv.FolioNum) }
      End; { If (lStatus = 0) }
    End; { With FormDetsI }
  End; { If (FormType = 1) }
End; { AddSerialLabels }

//-----------------------------------------------------------------------------

procedure TEFImportDefaults.AddLineSerialLabels;
Var
  KeyS       : Str255;
  lStatus    : SmallInt;
  FormType   : Byte;
Begin { AddLineSerialLabels }
  // Check that there is a default form defined for Product Labels - can't add Serial
  // Labels without a vaid form - PCC Labels not currently supported
  If (Trim(SyssForms^.FormDefs.PrimaryForm[21]) <> '') Then
    FormType := GetFormType (SyssForms^.FormDefs.PrimaryForm[21])
  Else
    FormType := 0;

  If (FormType = 1) Then
    // Got a valid EFD form
    With FormDetsI Do Begin
      // Load Transaction Line
      KeyS := fdTableKeyString;
      lStatus := Find_Rec(B_GetGEq, F[IDetailF], IDetailF, RecPtr[IDetailF]^, IdLinkK, KeyS);
      If (lStatus = 0) And CheckKey(KeyS, fdTableKeyString, Length(KeyS), True) Then
        // Add serial labels for current line (Id)
        AddIdLabels;
    End; { With FormDetsI }
End; { AddLineSerialLabels }

//-----------------------------------------------------------------------------

// Serial Number Labels - Run through transaction lines processing Serial Numbers
procedure TEFImportDefaults.AddStocklabels;
Var
  StkFormDetsO                     : TEFPrintFormDetails;
  StkFormDetsI                     : IEFPrintFormDetails;
  KeyS                             : Str255;
  lStatus, lStkStatus              : SmallInt;
  FormType                         : Byte;
begin { AddStocklabels }
  // Check that there is a default form defined for Product Labels - can't add Serial
  // Labels without a vaid form - PCC Labels not currently supported
  If (Trim(SyssForms^.FormDefs.PrimaryForm[21]) <> '') Then
    FormType := GetFormType (SyssForms^.FormDefs.PrimaryForm[21])
  Else
    FormType := 0;

  If (FormType = 1) Then Begin
    // Got a valid EFD form
    With FormDetsI Do Begin
      // Load Transaction
      KeyS := fdMainKeyString;
      lStatus := Find_Rec(B_GetEq, F[fdMainFileNo], fdMainFileNo, RecPtr[fdMainFileNo]^, fdMainIndexNo, KeyS);
      If (lStatus = 0) Then Begin
        // Got Transaction - Run through lines
        KeyS := FullNomKey (Inv.FolioNum);
        lStatus := Find_Rec(B_GetGEq, F[IDetailF], IDetailF, RecPtr[IDetailF]^, IdLinkK, KeyS);
        While (lStatus = 0) And (Id.FolioRef = Inv.FolioNum) Do Begin
          // Check for a valid Stock Code which uses Serial/Batch
          If (Trim(Id.StockCode) <> '') Then Begin
            // Load Stock Record
            KeyS := FullStockCode(Id.StockCode);
            lStkStatus := Find_Rec(B_GetGEq, F[StockF], StockF, RecPtr[StockF]^, StkCodeK, KeyS);
            If (lStkStatus = 0) Then Begin
              // Got Serial Record - Add into PrintJob
              StkFormDetsO := TEFPrintFormDetails.Create (imAdd, (FPrintToolkit As TEFPrintingToolkit).PrintJobO.FormsListO);
              StkFormDetsI := StkFormDetsO;
              With StkFormDetsI Do Begin
                // Setup type of print job
                fdMode := EnterpriseForms_TLB.fmLabel;

                // Setup form name from form definition set
                fdFormName := SyssForms^.FormDefs.PrimaryForm[21];

                // Quote, Delivery Note or unpicked Order - Use Line Qty
                fdLabelCopies := Trunc(Round_Up(Id.Qty, 0));

                fdMainFileNo := IDetailF;
                fdMainIndexNo := IDLinkK;
                fdMainKeyString := FullNomKey(Inv.FolioNum) + FullNomKey(ID.ABSLineNo);

                fdTableFileNo := 0;
                fdTableIndexNo := 0;
                fdTableKeyString := '';
              End; { With StkFormDetsI }

              If (StkFormDetsI.fdLabelCopies > 0) Then
                // Add form details into Print Job
                (FPrintToolkit As TEFPrintingToolkit).PrintJobO.FormsListO.AddNewForm(StkFormDetsO);
            End; { If (lStkStatus = 0) }
          End; { If (Trim(Id.StockCode) <> '') }

          lStatus := Find_Rec(B_GetNext, F[IDetailF], IDetailF, RecPtr[IDetailF]^, IdLinkK, KeyS);
        End; { While (lStatus = 0) And (Id.FolioRef = Inv.FolioNum) }
      End; { If (lStatus = 0) }
    End; { With FormDetsI }
  End; { If (FormType = 1) }
End; { AddStocklabels }

//-----------------------------------------------------------------------------

End.
