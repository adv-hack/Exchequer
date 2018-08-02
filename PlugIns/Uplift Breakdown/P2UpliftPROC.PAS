unit P2UpliftPROC;

{ nfrewer440 17:10 08/12/2003: Disabled Byte Alignment in Delphi 6.0 }
{$ALIGN 1}  { Variable Alignment Disabled }


interface
uses
  StrUtil, CustABSU, Enterprise01_TLB, {TFile,}Classes, StdCtrls;

const
  GL_FIRSTCODE = 1;
  GL_COMMISSION = 1;
  GL_IMPORTDUTY = 2;
  GL_FREIGHT = 3;
  GL_TICKETING = 4;
  GL_PROCESSING = 5;
  GL_ROUNDING = 6;
  GL_LASTCODE = 6;

  aNotes : array[GL_COMMISSION..GL_PROCESSING] of string = ('COMMISSION=', 'IMPORT='
  , 'FREIGHT=', 'TICKET=', 'PROCESS=');
  aDescs : array[GL_COMMISSION..GL_PROCESSING] of string = ('Commission', 'Import Duty'
  , 'Freight', 'Ticketing', 'Processing');
  sApportioned = 'Apportioned: See Matching Information';

type
  TCompanyRec = Record
    Name : string[45];
    Code : string[6];
    Path : string[100];
  end;

  TSetupRec = Record
    GLCodes : Array[GL_FIRSTCODE..GL_LASTCODE] of longint;
    sCostCentre : string3;
    sDepartment : string3;
  end;

  TCompanyInfo = Class
    CompanyRec : TCompanyRec;
    bCurrentCompany : boolean;
  end;{with}

  TCurrencyInfo = Class
    CurrencyNo : integer;
  end;{with}

  procedure StartToolkit(LEventData : TAbsEnterpriseSystem);
  procedure FillCurrencyCombo(cmbCurrency : TComboBox; iDefaultCcy : integer);
  function GetCustNameFromCode(sCustCode : string) : string;
  function GetProdNameFromCode(sStockCode : string) : string;
  procedure InitToolkit(cmbCompany : TComboBox);
  function ConvertCurrency(rValue : real; iFromCcy, iToCcy : integer) : real;

var
  oToolkit : IToolkit;
  CompanyRec : TCompanyRec;
  SetupRec : TSetupRec;

implementation
uses
  MathUtil, MiscUtil, SecCodes, Dialogs, BTConst, SysUtils, BTUtil, APIUtil, COMObj;
(*
function GetToValue(sLCustCode : string; rFromValue : real; bIncludeTo : boolean
;bFirst : boolean = FALSE) : string;
var
  VProductRec : TVProductRec;
  KeyS : TStr255;
  iStatus : integer;
begin{GetToValue}
  Result := 'Upwards';
  if not bFirst then begin
    KeyS := sLCustCode + BT_MinDoubleKey;
    iStatus := BTFindRecord(BT_GetGreater, ppFileVar[VProductF], VProductRec, ppBufferSize[VProductF]
    , ppdValueFromIdx, KeyS);
    while (iStatus = 0) and (sLCustCode = VProductRec.ppdCustCode) do begin
      if VProductRec.ppdValueFrom > rFromValue then
      begin
        if bIncludeTo then Result := 'to : ' + MoneyToStr(VProductRec.ppdValueFrom)
        else Result := MoneyToStr(VProductRec.ppdValueFrom);
        iStatus := 4;
      end else
      begin
        iStatus := BTFindRecord(BT_GetNext, ppFileVar[VProductF], VProductRec, ppBufferSize[VProductF]
        , ppdValueFromIdx, KeyS);
      end;{if}
    end;{while}
  end;{if}
end;{GetToValue}

function GetNextFolioNo(iFileNo : integer) : integer;
var
  KeyS : TStr255;
//  VContractRec : TVContractRec;
  VNumRec : TVNumRec;
  VProductRec : TVProductRec;
  VUserRec : TVUserRec;
  VLinksRec : TVLinksRec;
  iStatus, iNextFolio : LongInt;
begin
  // get original record
  FillChar(KeyS, SizeOf(KeyS), #0);
  iNextFolio := 1;
  case iFileNo of
    VContractF : begin
      KeyS := 'C';
      iStatus := BTFindRecord(BT_GetEqual, FileVar[VNumF], VNumRec, BufferSize[VNumF]
      , vcIdxByFolioNo, KeyS);

      if iStatus = 0 then
      begin
        iNextFolio := VNumRec.vmNextNumber;
        inc(VNumRec.vmNextNumber);
        iStatus := BTUpdateRecord(FileVar[VNumF], VNumRec, BufferSize[VNumF], vmIdxByType, KeyS);
        if iStatus <> 0 then BTShowError(iStatus, 'BTUpdateRecord', vcFileName[VNumF]);
      end else
      begin
        // show error
        if iStatus in [4,9] then
        begin
          iNextFolio := 1;

          FillChar(VNumRec,SizeOf(VNumRec),#0);
          VNumRec.vmType := 'C';
          VNumRec.vmNextNumber := 2;
          iStatus := BTAddRecord(FileVar[VNumF], VNumRec, BufferSize[VNumF], vmIdxByType);
          if iStatus <> 0 then BTShowError(iStatus, 'BTAddRecord', vcFileName[VNumF]);
        end else
        begin
          BTShowError(iStatus, 'BTFindRecord', vcFileName[VNumF]);
        end;
      end;{if}

    end;

    VProductF : begin
      iStatus := BTFindRecord(BT_GetLast, FileVar[VProductF], VProductRec, BufferSize[VProductF]
      , vcIdxByFolioNo, KeyS);
      if iStatus = 0 then iNextFolio := VProductRec.vpFolioNo + 1;

      // show error
      if not (iStatus in [0,4,9])
      then BTShowError(iStatus, 'BTFindRecord', vcFileName[VProductF]);
    end;

    VUserF : begin
      iStatus := BTFindRecord(BT_GetLast, FileVar[VUserF], VUserRec, BufferSize[VUserF]
      , vcIdxByFolioNo, KeyS);
      if iStatus = 0 then iNextFolio := VUserRec.vuFolioNo + 1;

      // show error
      if not (iStatus in [0,4,9])
      then BTShowError(iStatus, 'BTFindRecord', vcFileName[VUserF]);
    end;

    VLinksF : begin
      iStatus := BTFindRecord(BT_GetLast, FileVar[VLinksF], VLinksRec, BufferSize[VLinksF]
      , vcIdxByFolioNo, KeyS);
      if iStatus = 0 then iNextFolio := VLinksRec.vlFolioNo + 1;

      // show error
      if not (iStatus in [0,4,9])
      then BTShowError(iStatus, 'BTFindRecord', vcFileName[VLinksF]);
    end;

    else begin
      ShowMessage('GetNextFolioNo does not support file number ' + IntToStr(iFileNo));
    end;
  end;{case}

  Result := iNextFolio;

end;
*)
procedure StartToolkit(LEventData : TAbsEnterpriseSystem);
var
  a, b, c : LongInt;
  FuncRes : integer;

begin{StartToolkit}
  if oToolkit = nil then
  begin
    // Create COM Toolkit object
    oToolkit := CreateOLEObject('Enterprise01.Toolkit') as IToolkit;

    // Check it created OK
    If Assigned(oToolkit) Then Begin
      With oToolkit Do Begin
        EncodeOpCode(97, a, b, c);
        oToolkit.Configuration.SetDebugMode(a, b, c);

        oToolkit.Configuration.OverwriteTransactionNumbers := TRUE;

  //      oToolkit.Configuration.AutoSetTransCurrencyRates := TRUE;
        oToolkit.Configuration.AutoSetTransCurrencyRates := FALSE;

        // Open Default Company
        oToolkit.Configuration.DataDirectory := LEventData.Setup.ssDataPath;
        FuncRes := OpenToolkit;

        // Check it opened OK
        If (FuncRes = 0) then {DoUpdates}
        else begin
          // Error opening Toolkit - display error
          ShowMessage ('The following error occurred opening the Toolkit:-'#13#13
          + QuotedStr(oToolkit.LastErrorString));
        end;{if}

      End; { With OToolkit }

    End { If Assigned(oToolkit) }
    Else
      // Failed to create COM Object
      ShowMessage ('Cannot create COM Toolkit instance');
  end;{if}
end;{StartToolkit}

procedure FillCurrencyCombo(cmbCurrency : TComboBox; iDefaultCcy : integer);
var
  iSelected, iPos : integer;
  sCurrChar : string;
  CurrencyInfo : TCurrencyInfo;
begin
  ClearList(cmbCurrency.Items);
  iSelected := 0;
//  cmbCurrency.Items.Add('(no currency selected)');
  For iPos := 1 to oToolkit.SystemSetup.ssMaxCurrency do begin
    if Trim(oToolkit.SystemSetup.ssCurrency[iPos].scDesc) <> '' then begin
      // get correct currency char
      sCurrChar := oToolkit.SystemSetup.ssCurrency[iPos].scSymbol;
      if sCurrChar = #156 then sCurrChar := '£';

      CurrencyInfo := TCurrencyInfo.Create;
      CurrencyInfo.CurrencyNo := iPos;
      cmbCurrency.Items.AddObject(IntToStr(iPos) + ' - ' + oToolkit.SystemSetup.ssCurrency[iPos].scDesc
      + ' (' + sCurrChar + ')', CurrencyInfo);

      if iPos = iDefaultCcy then iSelected := cmbCurrency.Items.count -1;
    end;
  end;{for}

  if cmbCurrency.Items.Count > 0 then cmbCurrency.Itemindex := iSelected;
end;

function GetCustNameFromCode(sCustCode : string) : string;
begin
  with oToolkit.Customer do begin
    Index := acIdxCode;
    if GetEqual(BuildCodeIndex(sCustCode)) = 0
    then Result := acCompany
    else Result := '';
  end;{with}
end;

function GetProdNameFromCode(sStockCode : string) : string;
begin
  Result := '';
  with oToolkit.Stock do begin
    Index := stIdxCode;
    if GetEqual(BuildCodeIndex(sStockCode)) = 0
    then begin
      if (stType in [stTypeProduct, stTypeDescription, stTypeBillOfMaterials])
      then begin
        Result := stDesc[1];
      end;
    end;{if}
  end;{with}
end;

procedure InitToolkit(cmbCompany : TComboBox);
var
  iSelectIndex, iPos : integer;
  CompanyInfo : TCompanyInfo;
  a, b, c : LongInt;
begin{InitToolkit}
  // Create COM Toolkit object
  oToolkit := CreateOLEObject('Enterprise01.Toolkit') as IToolkit;

  // Check it created OK
  If Assigned(oToolkit) Then Begin

    EncodeOpCode(97, a, b, c);
    oToolkit.Configuration.SetDebugMode(a, b, c);
    oToolkit.Configuration.AutoSetTransCurrencyRates := TRUE;

    if (cmbCompany <> nil) then
    begin
      iSelectIndex := 0;
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

      // select current or first company
      cmbCompany.ItemIndex := iSelectIndex;
  //    cmbCompanyChange(cmbCompany);
      cmbCompany.OnChange(cmbCompany);;
    end;{if}

  End { If Assigned(oToolkit) }
  Else
    // Failed to create COM Object
    ShowMessage ('Cannot create COM Toolkit instance');
end;{InitToolkit}

function ConvertCurrency(rValue : real; iFromCcy, iToCcy : integer) : real;
begin
  if iFromCcy = iToCcy then
  begin
    Result := rValue;
  end else
  begin
    Result := oToolkit.Functions.entConvertAmount(rValue
    ,iFromCcy, iToCcy, oToolkit.SystemSetup.ssCurrencyRateType);
  end;{if}
end;


initialization
  oToolkit := nil;

finalization

end.
