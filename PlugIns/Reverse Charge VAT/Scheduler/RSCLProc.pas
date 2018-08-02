unit RSCLProc;

{$WARN SYMBOL_PLATFORM OFF}

interface
uses
  ComObj, Dialogs, Enterprise01_TLB, StdVcl;

type
  TUpdateProc = Procedure(sMessage : string) of Object;

  procedure UpdateRSCL(sCompanyPath : string; UpdateProgress : TUpdateProc; bShowMessages : boolean);

implementation

uses
  APIUtil, SysUtils, SecCodes, PIUtils, RVProc;

procedure UpdateRSCL(sCompanyPath : string; UpdateProgress : TUpdateProc; bShowMessages : boolean);
var
  Parameters : TParameters;

  procedure InitToolkit;
  var
    a, b, c : LongInt;
//    iSelectIndex, iPos : integer;
//    CompanyInfo : TCompanyInfo;
  begin{InitToolkit}
    // Create COM Toolkit object
//    Try
      oToolkit := CreateOLEObject('Enterprise01.Toolkit') as IToolkit;
//    Except
//      on E:Exception do
//        ShowMessage(E.Message);
//    End;

    // Check it created OK
    If Assigned(oToolkit) Then
    Begin

      EncodeOpCode(97, a, b, c);
      oToolkit.Configuration.SetDebugMode(a, b, c);
      oToolkit.Configuration.AutoSetTransCurrencyRates := TRUE;

{      iSelectIndex := 0;
      For iPos := 1 to oToolkit.Company.cmCount do begin
        CompanyInfo := TCompanyInfo.Create;
        CompanyInfo.CompanyRec.Path := Trim(oToolkit.Company.cmCompany[iPos].coPath);
        CompanyInfo.CompanyRec.Name := Trim(oToolkit.Company.cmCompany[iPos].coName);
        CompanyInfo.CompanyRec.Code := Trim(oToolkit.Company.cmCompany[iPos].coCode);
        cmbCompany.Items.AddObject(oToolkit.Company.cmCompany[iPos].coName, CompanyInfo);

        if oToolkit.Enterprise.enRunning
        and ((uppercase(CompanyInfo.CompanyRec.Path)) = (uppercase(Trim(oToolkit.Enterprise.enCompanyPath))))
        then iSelectIndex := iPos -1;
      end;{for}

{      cmbCompany.ItemIndex := iSelectIndex;
      cmbCompanyChange(cmbCompany);}

    End Else
    begin
      // Failed to create COM Object
      if bShowMessages then ShowMessage('Cannot create COM Toolkit instance');
    end;
  end;{InitToolkit}

  function UpdateTransaction(Transaction : ITransaction) : boolean;

    function RetailCustomer(Customer : IAccount) : boolean;
    begin{RetailCustomer}
      Result := FALSE;
      if Customer <> nil then
      begin
        case Parameters.CustomerMode of
          cmAccType : begin
            Result := Trim(UpperCase(Customer.acAccType)) = Trim(UpperCase(Parameters.sAccType));
          end;

          cmUDF : begin
            case Parameters.iCustUDF of
              1 : Result := Trim(UpperCase(Customer.acUserDef1)) = Trim(UpperCase(Parameters.sCustUDFValue));
              2 : Result := Trim(UpperCase(Customer.acUserDef2)) = Trim(UpperCase(Parameters.sCustUDFValue));
              3 : Result := Trim(UpperCase(Customer.acUserDef3)) = Trim(UpperCase(Parameters.sCustUDFValue));
              4 : Result := Trim(UpperCase(Customer.acUserDef4)) = Trim(UpperCase(Parameters.sCustUDFValue));
            end;{case}
          end;
        end;{case}
      end;{if}
    end;{RetailCustomer}

  begin{UpdateTransaction}
    Result := FALSE;
    if not RetailCustomer(Transaction.thAcCodeI) then
    begin
      Result := GetReverseTotal(Transaction, Parameters) >= Parameters.iValue;
    end;{if}
  end;{UpdateTransaction}

const
  SalesTXs = [dtSIN,dtSCR,dtSJI,dtSJC,dtSRF,dtSRI];
//  PurchaseTXs = [dtPIN,dtPCR,dtPJI,dtPJC,dtPRF,dtPPI];
var
  iUpdated, iStatus : integer;
  oUpdateTX : ITransaction;
begin
  sCompanyPath := IncludeTrailingPathDelimiter(sCompanyPath);
  if (sCompanyPath <> '\') and DirectoryExists(sCompanyPath) then
  begin
    InitToolkit;
    if oToolkit <> nil then
    begin

      oToolkit.Configuration.DataDirectory := sCompanyPath;
      iStatus := oToolkit.OpenToolkit;

      // Check it opened OK
      if (iStatus = 0) then
      begin
        Parameters := GetParameters(sCompanyPath);
        iUpdated := 0;

        with oToolkit, Transaction do
        begin

          Index := thIdxOurRef;
          iStatus := GetGreaterThanOrEqual('S');
          while (iStatus = 0) and (thOurRef[1] = 'S') do
          begin
  //          FEvents.OnProgress('Processing Transaction : ' + thOurRef,0);
            UpdateProgress('Processing Transaction : ' + thOurRef);

            if (thDocType in SalesTXs) and UpdateTransaction(Transaction) then
            begin
  //            FEvents.OnProgress('Updating Transaction : ' + thOurRef,0);
              UpdateProgress('Updating Transaction : ' + thOurRef);

              oUpdateTX := Transaction.Update;
              Case Parameters.iRCSLUDF of
                1 : oUpdateTX.thUserField1 := 'RCSL';
                2 : oUpdateTX.thUserField2 := 'RCSL';
                3 : oUpdateTX.thUserField3 := 'RCSL';
                4 : oUpdateTX.thUserField4 := 'RCSL';
              end;{case}
  //oUpdateTX.thUserField4 := '';
              iStatus := oUpdateTX.Save(FALSE);
              oUpdateTX := nil;
              inc(iUpdated);
            end;{if}

            iStatus := GetNext;
          end;{while}

          CloseToolkit;
          oToolkit := nil;
        end;{with}

        if bShowMessages then MsgBox('The process has completed successfully.'#13#13
        + 'Transactions Updated : ' + IntToStr(iUpdated), mtInformation, [mbOK], mbOK, 'Finished');

      end else
      begin
        if bShowMessages then ShowMessage('OpenToolkit failed with Error : ' +  IntToStr(iStatus));
      end;{if}
    end else
    begin
      if bShowMessages then ShowMessage('Toolkit = nil');
    end;{if}
  end else
  begin
    if bShowMessages then MsgBox('The Directory (' + sCompanyPath + ') does not exist.'
    , mtError, [mbOK], mbOK, 'Invalid Directory');
  end;{if}
end;

end.
