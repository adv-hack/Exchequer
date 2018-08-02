unit Criteria;

{ nfrewer440 17:10 08/12/2003: Disabled Byte Alignment in Delphi 6.0 }
{$ALIGN 1}  { Variable Alignment Disabled }


interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms
  , Dialogs, StdCtrls, uExDatasets, uBtrieveDataset, ExtCtrls, uMultiList
  , Math, uDBMultiList, Menus, StrUtil, uSettings, Enterprise01_TLB, APIUtil
  , ComCtrls, TEditVal, EnterToTab, RVProc, Reports, Spin;

const
  sPlugInName = 'Reverse Charge VAT - Report/CSV Utility';
  {$IFDEF EX600}
    sVersionNo = '007';
  {$ELSE}
    sVersionNo = 'v5.71.006';
  {$ENDIF}

type
  TfrmCriteria = class(TForm)
    btnCancel: TButton;
    cmbCompany: TComboBox;
    Label1: TLabel;
    MainMenu1: TMainMenu;
    File1: TMenuItem;
    Help1: TMenuItem;
    About1: TMenuItem;
    Exit1: TMenuItem;
    EnterToTab1: TEnterToTab;
    btnOK: TButton;
    Bevel5: TBevel;
    Bevel1: TBevel;
    Label3: TLabel;
    rbMonthly: TRadioButton;
    rbQuarterly: TRadioButton;
    rbAnnual: TRadioButton;
    panPrint: TPanel;
    Label2: TLabel;
    Bevel2: TBevel;
    rbPrinter: TRadioButton;
    rbCSV: TRadioButton;
    Bevel3: TBevel;
    Label4: TLabel;
    Label5: TLabel;
    cmbMonth: TComboBox;
    seYear: TSpinEdit;
    dlgSave: TSaveDialog;
    procedure FormCreate(Sender: TObject);
    procedure btnCancelClick(Sender: TObject);
    procedure cmbCompanyChange(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure About1Click(Sender: TObject);
    procedure Exit1Click(Sender: TObject);
    procedure btnOKClick(Sender: TObject);
  private
    sCurrentVATPeriod : string;
    procedure EnableDisable;
    procedure FillMonthCombo;
  public
  end;

var
  Parameters : TParameters;
  frmCriteria: TfrmCriteria;

implementation
uses
  DateUtils, MiscUtil, Progress, Inifiles, CTKUtil, PIUtils, TKPickList, BrwseDir
  , FileUtil, PISecure, SecCodes, ComObj, ETStrU, ExchequerRelease;

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
    If Assigned(oToolkit) Then Begin

      EncodeOpCode(97, a, b, c);
      oToolkit.Configuration.SetDebugMode(a, b, c);
      oToolkit.Configuration.AutoSetTransCurrencyRates := TRUE;

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

        if ((uppercase(CompanyInfo.CompanyRec.Path)) = (uppercase(Trim(sDataDirectory))))
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
  , ptStandaloneEXE, ExtractFileName(Application.EXEName)) then
  begin
    GetCLParams;
    InitToolkit;

    Parameters := GetParameters(CompanyRec.Path);
    sCurrentVATPeriod := (oToolkit.SystemSetup as ISystemSetup6).ssCurrentVATPeriod;

    case (oToolkit.SystemSetup as ISystemSetup6).ssVATReturnInterval of
      1 : rbMonthly.Checked := TRUE;
      3 : rbQuarterly.Checked := TRUE;
      12 : rbAnnual.Checked := TRUE;
    end;{case}

    FillMonthCombo;
    seYear.Value := StrToIntDef(Copy(sCurrentVATPeriod, 1, 4), 0);

    EnableDisable;

  end;{if}

end;

procedure TfrmCriteria.EnableDisable;
begin
  btnOK.Enabled := cmbCompany.ItemIndex >= 0;
end;

procedure TfrmCriteria.btnCancelClick(Sender: TObject);
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
      Parameters := GetParameters(CompanyRec.Path);
      sCurrentVATPeriod := (oToolkit.SystemSetup as ISystemSetup6).ssCurrentVATPeriod;

      case (oToolkit.SystemSetup as ISystemSetup6).ssVATReturnInterval of
        1 : rbMonthly.Checked := TRUE;
        3 : rbQuarterly.Checked := TRUE;
        12 : rbAnnual.Checked := TRUE;
      end;{case}

      FillMonthCombo;
      seYear.Value := StrToIntDef(Copy(sCurrentVATPeriod, 1, 4), 0);
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


procedure TfrmCriteria.btnOKClick(Sender: TObject);
var
  FrmProgress : TFrmProgress;
  iEndYear : integer;
  iEndMonth, iNoOfColumns{, iReportType} : byte;
  slLines : TStringList;
  sFilename, sVATDate : string;

(*  function GetFirstDateInPY(iPeriod, iYear : integer) : string8;
  begin{GetFirstDateInPY}
    oToolkit.Functions.entFormatPeriodYear()
  end;{GetFirstDateInPY}

  function GetLastDateInPY(iPeriod, iYear : integer) : string8;
  begin{GetLastDateInPY}
  end;{GetLastDateInPY}

  function GetNoOfColumns(sFirstDate, sLastDate : string8) : integer;
  begin{GetNoOfColumns}
  end;{GetNoOfColumns}*)

  function GetColumn(sDate : string) : integer;
  var
    iEndMonthToDate, iCurrentMonthToDate, iMonth, iYear{, iYearDec} : integer;
  begin{GetColumn}
//    Result := 0;
//    iYearDec := 0;
    iMonth := StrToIntDef(Copy(sDate, 5, 2), 0);
    iYear := StrToIntDef(Copy(sDate, 1, 4), 0);
{    if iMonth > 0 then
    begin
      Result := iMonth + iEndMonth - iNoOfColumns;
      if Result < 0 then
      begin
        Result := Result + 12;  // this deals with the overlap from the previous year :  12 01 02 / Dec Jan Feb
        iYearDec := 1;
      end;
      if Result >= iNoOfColumns then Result := 0;  // This is for out of period transactions - they go in the first column
      if iYear <> (iEndYear - iYearDec) then Result := 0; // This is also for out of period transactions
    end;{if}
//    Result := Result + 1;

    iEndMonthToDate := (iEndYear * 12) + iEndMonth;
    iCurrentMonthToDate := (iYear * 12) + iMonth;
    Result := iCurrentMonthToDate - iEndMonthToDate + iNoOfColumns;
    if Result < 1 then Result := 1;  // if month is earlier than first month column, then it is out of period - so put it in thew first column;
    if Result > iNoOfColumns then Result := -1; // if the month is later than last month column, then it should be ignored
  end;{GetColumn}

  Procedure AddLineValue(sCustCode : string; rValue : real; iColumn : byte);
  var
    LineInfo : TLineInfo;
    iPos : integer;
  begin{AddLineValue}
    iPos := slLines.IndexOf(sCustCode);
    if iPos >= 0 then
    begin
      // Found existing entry
      LineInfo := TLineInfo(slLines.Objects[iPos]);
    end else
    begin
      // no existing entry found
      LineInfo := TLineInfo.CreateWith(iNoOfColumns);
      slLines.AddObject(sCustCode, LineInfo)
    end;{if}

    LineInfo.aValues[iColumn] := LineInfo.aValues[iColumn] + rValue;
  end;{AddLineValue}

  procedure PopulateVATNos;
  var
    iStatus, iPos : integer;
  begin{PopulateVATNos}
    oToolkit.Customer.Index := acIdxCode;
    For iPos := 0 to slLines.Count-1 do
    begin
      iStatus := oToolkit.Customer.GetEqual(oToolkit.Customer.BuildCodeIndex(Trim(slLines[iPos])));
      if iStatus = 0 then
      begin
        TLineInfo(slLines.Objects[iPos]).sVATNo := oToolkit.Customer.acVATRegNo;
      end;{if}
    end;{for}
  end;{PopulateVATNos}

  function ExportToCSV : boolean;
  var
    LineInfo : TLineInfo;
    iLine, iPos, iDays, iYear, iMonth : integer;
    sLine, sStartEndDate, sStartDate : string;
  const
    CSV_HEADER = 'HMRC_VAT_RCSL_BULK_SUBMISSION_FILE';
  begin{ExportToCSV}

    if dlgSave.Execute then
    begin
      result := TRUE;

      FrmProgress.UpdateLine1('Creating Export File, Please Wait....');

      sFilename := dlgSave.FileName;
      DeleteFile(sFilename);

      // work out how may days in the report period
      iDays := 0;
      iYear := iEndYear;
      iMonth := iEndMonth;
      For iPos := iNoOfColumns downto 1 do
      begin
        iDays := iDays + DaysInAMonth(iYear, iMonth);
        Dec(iMonth);

        if iMonth = 0 then  // go back to december of the previous year
        begin
          iMonth := 12;
          Dec(iYear);
        end;{if}
      end;{for}

      sStartDate := DateToStr8(Str8ToDate(sVATDate) - iDays + 1);
      sStartEndDate := Copy(sStartDate,7,2) + Copy(sStartDate,5,2) + Copy(sStartDate,1,4)
      + ',' + Copy(sVATDate,7,2) + Copy(sVATDate,5,2) + Copy(sVATDate,1,4);

      // Export Header
      AddLineToFile(CSV_HEADER, sFilename, TRUE);
      AddLineToFile(Trim(oToolkit.SystemSetup.ssCompanyVATRegNo) + ',' + sStartEndDate
      , sFilename, TRUE);

      slLines.Sort;

      // Export Lines
      For iLine := 0 to slLines.Count-1 do
      begin
        LineInfo := TLineInfo(slLines.Objects[iLine]);
        frmProgress.UpdateLine2('Exporting Details for ' + LineInfo.sVATNo);

        sLine := Trim(LineInfo.sVATNo);

        for iPos := 1 to length(LineInfo.aValues)-1 do
        begin
          sLine := sLine + ',' + MoneyToStr(LineInfo.aValues[iPos])
        end;{for}

        AddLineToFile(sLine, sFilename, TRUE);
        Application.ProcessMessages;
      end;{for}
    end else
    begin
      result := FALSE;
    end;

  end;{ExportToCSV}

var
  iColumn : integer;
  iStatus : integer;
  rReverseTotal : real;
  sTitle : string;
const
  SalesTXs = [dtSIN,dtSCR,dtSJI,dtSJC,dtSRF,dtSRI];
  PurchaseTXs = [dtPIN,dtPCR,dtPJI,dtPJC,dtPRF,dtPPI];
{  REP_MONTHLY = 1;
  REP_QUARTERLY = 2;
  REP_ANNUAL = 3;}
begin
  Screen.Cursor := crHourglass;
  FrmProgress := TFrmProgress.Create(self);
  FrmProgress.Show;
  FrmProgress.UpdateLine1('Scanning Transactions, Please Wait....');

  slLines := TStringList.Create;

  with oToolkit, Transaction do
  begin

    if rbMonthly.Checked then
    begin
//      iReportType := REP_MONTHLY;
      iNoOfColumns := 1;
      sTitle := 'RCSL Monthly Report';
    end;{if}

    if rbQuarterly.Checked then
    begin
//      iReportType := REP_QUARTERLY;
      iNoOfColumns := 3;
      sTitle := 'RCSL Quarterly Report';
    end;{if}

    if rbAnnual.Checked then
    begin
//      iReportType := REP_ANNUAL;
      iNoOfColumns := 12;
      sTitle := 'RCSL Annual Report';
    end;{if}

    iEndMonth := cmbMonth.itemindex + 1;
    iEndYear := seYear.Value;
    sVATDate := IntToStr(iEndYear) + PadString(psLeft, IntToStr(iEndMonth), '0', 2)
    + PadString(psLeft, IntToStr(DaysInAMonth(iEndYear, iEndMonth)), '0', 2);

{    Index := thIdxTransDate;
    iStatus := GetGreaterThanOrEqual(sFirstDate);}

    Index := thIdxPostedDate;
    iStatus := GetGreaterThanOrEqual(sVATDate);
    while (iStatus = 0) and ((Transaction as ITransaction5).thVatPostDate = sVATDate) do
    begin

{    while (iStatus = 0) and (thTransDate >= sFirstDate) and (thTransDate <= sLastDate) do
    begin}
      FrmProgress.UpdateLine2('Transaction : ' + thOurRef);
      Application.ProcessMessages;

      if thDocType in SalesTXs then
      begin
        rReverseTotal := Functions.entConvertAmountWithRates(GetReverseTotal(Transaction, Parameters)
        , TRUE, thCurrency, thCompanyRate, thDailyRate);

        if rReverseTotal >= Parameters.iValue then
        begin
          if Transaction.thDocType in [dtSCR, dtSJC, dtSRF]
          then rReverseTotal := -rReverseTotal;

          iColumn := GetColumn(Transaction.thTransDate);
//          rReverseTotal := rReverseTotal * (SystemSetup.ssVATRates['S'].svRate);
//          AddLineValue(Transaction.thAcCode, rReverseTotal, iColumn);
          if iColumn <> -1 then AddLineValue(Transaction.thAcCode, rReverseTotal, iColumn);
        end;{if}

      end;{if}

      iStatus := GetNext;
    end;{while}

    PopulateVATNos;

  end;{with}

  if rbPrinter.checked then
  begin
    if slLines.Count > 0 then
    begin
      ModReports.slLines := slLines;
      ModReports.frmProgress := frmProgress;
      ModReports.sTitle := sTitle;
      ModReports.iEndMonth := iEndMonth;
      ModReports.iEndYear := iEndYear;

      ModReports.PrintVATReport;

      Close;
    end else
    begin
      MsgBox('No Transactions were found for the report criteria defined.'
      , mtInformation, [mbOK], mbOK, 'No Transactions Found');
    end;{if}
  end else
  begin
    if ExportToCSV then
    begin
      MsgBox('CSV Export File (' + sFilename + ') created successfully.'
      , mtInformation, [mbOK], mbOK, 'Export Completed');
      Close;
    end;{if}
  end;{if}

  ClearList(slLines);
  slLines.Free;
  FrmProgress.Hide;
  FrmProgress.Release;
  Screen.Cursor := crDefault;
end;

procedure TfrmCriteria.FillMonthCombo;
var
  iSelected, iCurrentVATMonth, iPos : integer;
begin{FillMonthCombo}
  cmbMonth.Clear;
  iSelected := 0;
  iCurrentVATMonth := StrToIntDef(Copy(sCurrentVATPeriod, 5, 2), 0);
  For iPos := 1 to 12 do
  begin
    cmbMonth.Items.Add(LongMonthNames[iPos]);
    if iPos = iCurrentVATMonth then iSelected := iPos-1;
  end;{for}
  cmbMonth.ItemIndex := iSelected;
end;{FillMonthCombo}



end.
