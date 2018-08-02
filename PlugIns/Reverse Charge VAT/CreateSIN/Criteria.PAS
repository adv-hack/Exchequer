unit Criteria;

{ nfrewer440 17:10 08/12/2003: Disabled Byte Alignment in Delphi 6.0 }
{$ALIGN 1}  { Variable Alignment Disabled }


interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms
  , Dialogs, StdCtrls, uExDatasets, uBtrieveDataset, ExtCtrls, uMultiList
  , Math, uDBMultiList, Menus, StrUtil, uSettings, Enterprise01_TLB, APIUtil
  , ComCtrls, TEditVal, EnterToTab, RVProc;

const
  sPlugInName = 'Reverse Charge VAT - Generation';
  {$IFDEF EX600}
    sVersionNo = '007';
  {$ELSE}
    sVersionNo = 'v5.71.006';
  {$ENDIF}

type
  TfrmCriteria = class(TForm)
    btnClose: TButton;
    cmbCompany: TComboBox;
    Label1: TLabel;
    MainMenu1: TMainMenu;
    File1: TMenuItem;
    Help1: TMenuItem;
    About1: TMenuItem;
    Exit1: TMenuItem;
    EnterToTab1: TEnterToTab;
    btnCreate: TButton;
    Bevel5: TBevel;
    procedure FormCreate(Sender: TObject);
    procedure btnCloseClick(Sender: TObject);
    procedure cmbCompanyChange(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure About1Click(Sender: TObject);
    procedure Exit1Click(Sender: TObject);
    procedure btnCreateClick(Sender: TObject);
  private
    procedure EnableDisable;
  public
    sCustCode : string;
  end;

var
  Parameters : TParameters;
  frmCriteria: TfrmCriteria;

implementation
uses
  Progress, Inifiles, CTKUtil, PIUtils, TKPickList, BrwseDir, FileUtil, PISecure
  , SecCodes, ComObj, MathUtil, ETStrU, ExchequerRelease;

{$R *.dfm}

procedure TfrmCriteria.FormCreate(Sender: TObject);

  procedure InitToolkit;
  var
    a, b, c : LongInt;
    iSelectIndex, iPos : integer;
    CompanyInfo : TCompanyInfo;
  begin{InitToolkit}
    // Create COM Toolkit object
    oToolkit := CreateOLEObject('Enterprise01.Toolkit') as IToolkit;

    // Check it created OK
    If Assigned(oToolkit) then
    begin

      EncodeOpCode(97, a, b, c);
      oToolkit.Configuration.SetDebugMode(a, b, c);
      oToolkit.Configuration.AutoSetTransCurrencyRates := TRUE;

      iSelectIndex := 0;
      For iPos := 1 to oToolkit.Company.cmCount do
      begin
        CompanyInfo := TCompanyInfo.Create;
        CompanyInfo.CompanyRec.Path := Trim(oToolkit.Company.cmCompany[iPos].coPath);
        CompanyInfo.CompanyRec.Name := Trim(oToolkit.Company.cmCompany[iPos].coName);
        CompanyInfo.CompanyRec.Code := Trim(oToolkit.Company.cmCompany[iPos].coCode);
        cmbCompany.Items.AddObject(oToolkit.Company.cmCompany[iPos].coName, CompanyInfo);

        if oToolkit.Enterprise.enRunning
        and ((uppercase(CompanyInfo.CompanyRec.Path)) = (uppercase(Trim(oToolkit.Enterprise.enCompanyPath))))
        then iSelectIndex := iPos -1;
      end;{for}

      cmbCompany.ItemIndex := iSelectIndex;
      cmbCompanyChange(cmbCompany);

    End { If Assigned(oToolkit) }
    Else
      // Failed to create COM Object
      ShowMessage ('Cannot create COM Toolkit instance');
  end;{InitToolkit}

begin{FormCreate}

  Caption := sPlugInName;
//  sDataPath := IncludeTrailingBackslash(ParamStr(1));

  oToolkit := nil;

  //Check Plug-In Security
  if PICheckSecurity(sSystemCode, sSecurityCode, sGlobalBespokeName, '', stSystemOnly
  , ptStandaloneEXE, ExtractFileName(Application.EXEName))
  then InitToolkit;

  Parameters := GetParameters(CompanyRec.Path);

  EnableDisable;
end;

procedure TfrmCriteria.EnableDisable;
begin
  btnCreate.Enabled := cmbCompany.ItemIndex >= 0;
end;

procedure TfrmCriteria.btnCloseClick(Sender: TObject);
begin
  Close;
end;

procedure TfrmCriteria.cmbCompanyChange(Sender: TObject);
var
  FuncRes : integer;
begin
  Screen.Cursor := crHourglass;
  if (oToolkit.Status = tkOpen) Then begin
    // Close all
    oToolkit.CloseToolkit;
  end;{if}

  With oToolkit Do Begin
    // Open Default Company
    CompanyRec := TCompanyInfo(cmbCompany.Items.Objects[cmbCompany.ItemIndex]).CompanyRec;
    oToolkit.Configuration.DataDirectory := CompanyRec.Path;

    FuncRes := OpenToolkit;

    // Check it opened OK
    If (FuncRes = 0) then
    begin
      //
    end
    else begin
      // Error opening Toolkit - display error
      ShowMessage ('The following error occurred opening the Toolkit:-'#13#13
      + QuotedStr(oToolkit.LastErrorString));
    end;{if}

  End; { With OToolkit }
  Screen.Cursor := crDefault;
end;


procedure TfrmCriteria.FormDestroy(Sender: TObject);
begin
  If Assigned(oToolkit) Then Begin
    // Close COM Toolkit and remove reference
    oToolkit.CloseToolkit;
    oToolkit := NIL;
  End; { If Assigned(oToolkit) }
end;

procedure TfrmCriteria.FormActivate(Sender: TObject);
begin
  if oToolkit = nil then close;
end;

procedure TfrmCriteria.About1Click(Sender: TObject);
begin
  MessageDlg(sPlugInName + #13#13 +
             ExchequerModuleVersion (emGenericPlugIn, sVersionNo) + #13#13 +
             DoubleAmpers(GetCopyrightMessage) + #13 +
             'All rights reserved.', mtInformation, [mbOk], 0);
end;

procedure TfrmCriteria.Exit1Click(Sender: TObject);
begin
  Close;
end;


procedure TfrmCriteria.btnCreateClick(Sender: TObject);
var
  FrmProgress : TFrmProgress;
  iResult, iStatus : integer;
  sFirst, sCurrentVATPeriod : String8;
  rTotal : real;
  oPPI, oSRI : ITransaction;
  oLine : ITransactionLine;
  bFound, bSRICreated : boolean;
const
  SalesTXs = [dtSIN,dtSCR,dtSJI,dtSJC,dtSRF,dtSRI];
  PurchaseTXs = [dtPIN,dtPCR,dtPJI,dtPJC,dtPRF,dtPPI];

  function SRIAlreadyExists : boolean;
  begin{SINAlreadyExists}
    FrmProgress.UpdateLine1('Searching for existing SRI....');
    Result := FALSE;

    with oToolkit, Transaction do
    begin

      Index := thIdxOurRef;
      iStatus := GetGreaterThanOrEqual(BuildOurRefIndex('SRI'));
      while (iStatus = 0) and (Copy(thOurRef, 1, 3) = 'SRI') do
      begin
        FrmProgress.UpdateLine2('Transaction : ' + thOurRef);

        if thUserField1 = sCurrentVATPeriod then
        begin
          Result := TRUE;
          Exit;
        end;{if}

        iStatus := GetNext;
      end;{while}
    end;{with}

  end;{SRIAlreadyExists}

begin
  if MsgBox('Are you sure you want to create your Reverse Charge VAT Transactions ?'
  , mtConfirmation, [mbYes, mbNo], mbNo, 'Are you sure ?') = mrYes then
  begin
    Screen.Cursor := crDefault;
    FrmProgress := TFrmProgress.Create(self);
    FrmProgress.Show;
    FrmProgress.UpdateLine1('Scanning Purchase Transactions, Please Wait....');

    sCurrentVATPeriod := (oToolkit.SystemSetup as ISystemSetup6).ssCurrentVATPeriod;
    rTotal := 0;
    bSRICreated := FALSE;

    with oToolkit, Transaction do
    begin

      Index := thIdxPostedDate;
      sFirst := BuildPostedDateIndex(sCurrentVATPeriod, '');
      iStatus := GetGreaterThanOrEqual(sFirst);
      bFound := FALSE;

      while (iStatus = 0) and ((Transaction as ITransaction5).thVatPostDate = sCurrentVATPeriod) do
      begin
        FrmProgress.UpdateLine2('Transaction : ' + thOurRef);

{        if thDocType in PurchaseTXs then
        begin
          if Transaction.thVATAnalysis[Parameters.sVATReturn] > 0 then
          begin
            rTotal := rTotal + Functions.entConvertAmountWithRates(GetReverseTotal(Transaction, Parameters)
            , TRUE, thCurrency, thCompanyRate, thDailyRate);
          end;{if}
{        end;{if}

        {.002}
        if thDocType in [dtPIN,dtPJI,dtPPI] then
        begin
          rTotal := rTotal + Transaction.thGoodsAnalysis[Parameters.sVATReturn];
        end;{if}

        if thDocType in [dtPCR,dtPJC,dtPRF] then
        begin
          // Must take these away, as the figures are stored as positive.
          rTotal := rTotal - Transaction.thGoodsAnalysis[Parameters.sVATReturn];
        end;{if}

        if not ZeroFloat(rTotal) then bFound := TRUE; // this allows for the situation where you have positive transactions that cancel out negative transactions.

        iStatus := GetNext;
      end;{while}

      if bFound then
      begin
        if SRIAlreadyExists then
        begin
          MsgBox('Process already completed for Current VAT Period.', mtInformation, [mbOK], mbOK, 'No Transactions Created');
        end else
        begin
          FrmProgress.UpdateLine1('Creating new SRI....');
          FrmProgress.UpdateLine2('');

          rTotal := rTotal * (SystemSetup.ssVATRates['S'].svRate);
          rTotal := StrToFloatDef(MoneyToStr(rTotal), 0);  // rounds it to 2 DP

          // Add Transaction (SRI)
          oSRI := Add(dtSRI);

          if oSRI = nil then
          begin
            MsgBox('An error occurred when attempting to create a new SRI', mtError, [mbOK], mbOK, 'oSRI = nil');
          end else
          begin
            // Get Customer Record
            oToolkit.Customer.Index := acIdxCode;
            iStatus := oToolkit.Customer.GetEqual(oToolkit.Customer.BuildCodeIndex(Trim(Parameters.sCustomer)));
            if iStatus = 0 then
            begin
              if oToolkit.Customer.acSalesGL <> 0 then
              begin

                // Populate SRI
                oSRI.thAcCode := Parameters.sCustomer;
                oSRI.ImportDefaults;
                oSRI.thPeriod := SystemSetup.ssCurrentPeriod;
                oSRI.thYear := SystemSetup.ssCurrentYear;
                oSRI.thTransDate := DateToStr8(Date);
                oSRI.thManualVAT := TRUE;
                oSRI.thTotalVAT := rTotal;
                oSRI.thVATAnalysis[Parameters.sVATReturn] := rTotal;
                oSRI.thUserField1 := sCurrentVATPeriod;

                // Add Invoice Line
                oLine := oSRI.thLines.Add;
                if oLine = nil then
                begin
                  MsgBox('An error occurred when attempting to create a new SRI Line'
                  , mtError, [mbOK], mbOK, 'oLine = nil');
                end else
                begin
                  // Populate Invoice Line
                  oLine.ImportDefaults;
                  oLine.tlDiscount := 0;
                  oLine.tlQty := 1;
                  oLine.tlDescr := 'Manufactured reverse charge VAT adjustment';
                  oLine.tlVATCode := Parameters.sVATReturn;
                  oLine.tlNetValue := 0;
                  oLine.tlCostCentre := Parameters.sCC;
                  oLine.tlDepartment := Parameters.sDept;
                  oLine.tlGLCode := oToolkit.Customer.acSalesGL;
                  oLine.tlPayment := FALSE;
                  oLine.Save;

                  // Add Payment Line
                  oLine := nil;
                  oLine := oSRI.thLines.Add;
                  if oLine = nil then
                  begin
                    MsgBox('An error occurred when attempting to create a new SRI Line'
                    , mtError, [mbOK], mbOK, 'oLine = nil');
                  end else
                  begin
                    // Populate Payment Line
                    oLine.ImportDefaults;
                    oLine.tlDiscount := 0;
                    oLine.tlQty := 1;
                    oLine.tlDescr := 'Manufactured reverse charge VAT adjustment';
  //                  oLine.tlVATCode := Parameters.sVATReturn;
  //                  oLine.tlVATCode := 'Z';
                    oLine.tlNetValue := rTotal;
  //                  oLine.tlNetValue := 0;
                    oLine.tlCostCentre := Parameters.sCC;
                    oLine.tlDepartment := Parameters.sDept;
                    oLine.tlGLCode := oToolkit.Customer.acSalesGL;
                    oLine.tlPayment := TRUE;
                    oLine.Save;

                    // Save SRI
                    iResult := oSRI.Save(TRUE);
                    if iResult = 0 then
                    begin
                      bSRICreated := TRUE;
                    end else
                    begin
                      MsgBox('An error occurred when trying to save your SRI :'#13#13
                      + LastErrorString, mtInformation, [mbOK], mbOK, 'Error : ' + IntToStr(iResult));
                    end;{if}
                  end;{if}
                end;{if}
              end else
              begin
                MsgBox('The customer (' + oToolkit.Customer.acCode + ') has no Sales GL Code set.'
                , mtError, [mbOK], mbOK, 'Customer Sales GL Error');
              end;{if}
            end else
            begin
              MsgBox('An error occurred when trying to find the customer record for : ' + Parameters.sCustomer
              , mtError, [mbOK], mbOK, 'Error Finding Customer');
            end;{if}
          end;{if}

          if bSRICreated then
          begin

            // Add Transaction (PPI)
            FrmProgress.UpdateLine1('Creating new PPI....');
            FrmProgress.UpdateLine2('');

            oPPI := Add(dtPPI);

            if oPPI = nil then
            begin
              MsgBox('An error occurred when attempting to create a new PPI', mtError, [mbOK], mbOK, 'oPPI = nil');
            end else
            begin
              // Get Supplier Record
              oToolkit.Supplier.Index := acIdxCode;
              iStatus := oToolkit.Supplier.GetEqual(oToolkit.Supplier.BuildCodeIndex(Trim(Parameters.sSupplier)));
              if iStatus = 0 then
              begin
                if oToolkit.Supplier.acSalesGL <> 0 then
                begin
                  // Populate PPI
                  oPPI.thAcCode := Parameters.sSupplier;
                  oPPI.ImportDefaults;
                  oPPI.thPeriod := SystemSetup.ssCurrentPeriod;
                  oPPI.thYear := SystemSetup.ssCurrentYear;
                  oPPI.thTransDate := DateToStr8(Date);
                  oPPI.thManualVAT := TRUE;
                  oPPI.thTotalVAT := rTotal;
                  oPPI.thVATAnalysis[Parameters.sVATReturn] := rTotal;
                  oPPI.thUserField1 := sCurrentVATPeriod;

                  // Add Invoice Line
                  oLine := oPPI.thLines.Add;
                  if oLine = nil then
                  begin
                    MsgBox('An error occurred when attempting to create a new PPI Line'
                    , mtError, [mbOK], mbOK, 'oLine = nil');
                  end else
                  begin
                    // Populate Invoice Line
                    oLine.ImportDefaults;
                    oLine.tlDiscount := 0;
                    oLine.tlQty := 1;
                    oLine.tlDescr := 'Manufactured reverse charge VAT adjustment';
                    oLine.tlVATCode := Parameters.sVATReturn;
                    oLine.tlNetValue := 0;
                    oLine.tlCostCentre := Parameters.sCC;
                    oLine.tlDepartment := Parameters.sDept;
                    oLine.tlGLCode := oToolkit.Supplier.acSalesGL;
                    oLine.tlPayment := FALSE;
                    oLine.Save;

                    // Add Payment Line
                    oLine := nil;
                    oLine := oPPI.thLines.Add;
                    if oLine = nil then
                    begin
                      MsgBox('An error occurred when attempting to create a new PPI Line'
                      , mtError, [mbOK], mbOK, 'oLine = nil');
                    end else
                    begin
                      // Populate Payment Line
                      oLine.ImportDefaults;
                      oLine.tlDiscount := 0;
                      oLine.tlQty := 1;
                      oLine.tlDescr := 'Manufactured reverse charge VAT adjustment';
    //                  oLine.tlVATCode := Parameters.sVATReturn;
    //                  oLine.tlVATCode := 'Z';
                      oLine.tlNetValue := rTotal;
    //                  oLine.tlNetValue := 0;
                      oLine.tlCostCentre := Parameters.sCC;
                      oLine.tlDepartment := Parameters.sDept;
                      oLine.tlGLCode := oToolkit.Supplier.acSalesGL;
                      oLine.tlPayment := TRUE;
                      oLine.Save;

                      // Save PPI
                      iResult := oPPI.Save(TRUE);
                      if iResult = 0 then
                      begin
                        MsgBox('Your Reverse Charge VAT Transactions have been created.', mtInformation
                        , [mbOK], mbOK, 'Process Completed Successfully');
                      end else
                      begin
                        MsgBox('An error occurred when trying to save your PPI :'#13#13
                        + LastErrorString, mtInformation, [mbOK], mbOK, 'Error : ' + IntToStr(iResult));
                      end;{if}
                    end;{if}
                  end;{if}
                end else
                begin
                  MsgBox('The supplier (' + oToolkit.Supplier.acCode + ') has no Cost of Sales GL Code set.'
                  , mtError, [mbOK], mbOK, 'Supplier COS GL Error');
                end;{if}
              end else
              begin
                MsgBox('An error occurred when trying to find the supplier record for : ' + Parameters.sSupplier
                , mtError, [mbOK], mbOK, 'Error Finding Supplier');
              end;{if}
            end;{if}
          end;{if}
        end;{if}
      end else
      begin
        MsgBox('No purchase transactions were found with a value against the reverse charge VAT code.'#13#13
        + 'No Transactions will therefore be created.', mtInformation, [mbOK], mbOK, 'No TXs Created');
      end;{if}
    end;{with}

    FrmProgress.Hide;
    FrmProgress.Release;
    Screen.Cursor := crDefault;
    Close;
  end;{if}
end;

end.
