unit Main;

{$ALIGN 1}  { Variable Alignment Disabled }

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs
  , StdCtrls, ComCtrls, StrUtil, Inifiles, Menus, Enterprise01_TLB, ExtCtrls
  , uSettings, uExDatasets, APIUtil, MiscUtil, {NeilProc,} FileUtil, EnterToTab, TKPickList;

{$I x:\ENTRPRSE\DLLTK\EXCHDLL.INC}   {* for linking with Enterprise - DLL Record Structure *}
{$I x:\ENTRPRSE\DLLTK\ExDLLBt.Inc}   {*       "            "        - DLL Btrieve Commands *}

const
  sPlugInName = 'Clear GL Utility';
  {$IFDEF EX600}
    sVersionNo = 'v6.20.005';
  {$ELSE}
    sVersionNo = 'v5.71.005';
  {$ENDIF}


type
  THeaderRec = Record
    sDate : string8;
    sOurRef : string9;
  end;

  THeaderInfo = class
    HeaderRec : THeaderRec;
  end;

//  TBigBatchLinesRec  =  Array[1..5000] of TBatchTLRec; {* Memory array of entire transaction lines *}

  TCompanyInfo = Class
    Name : string[45];
    Code : string[6];
    Path : string[100];
  end;{with}

  TfrmMain = class(TForm)
    cmbCompany: TComboBox;
    lCompany: TLabel;
    btnRun: TButton;
    Bevel1: TBevel;
    btnCancel: TButton;
    EnterToTab1: TEnterToTab;
    edGLCode: TEdit;
    btnFindGLCode: TButton;
    lGLName: TLabel;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    edDateFrom: TDateTimePicker;
    edDateTo: TDateTimePicker;
    Bevel2: TBevel;
    procedure btnCloseClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure cmbCompanyChange(Sender: TObject);
    procedure btnRunClick(Sender: TObject);
    procedure btnCancelClick(Sender: TObject);
    procedure edGLCodeChange(Sender: TObject);
    procedure btnFindGLCodeClick(Sender: TObject);
  private
    oToolkit : IToolkit;
//    iCompItemIndex : smallint;
    bGLCodeOK : boolean;
    TKStockLocation : TBatchMLocRec;
    procedure EnableDisable;
//    procedure ReplaceSLs;
//    procedure UpperCaseSLs;
    procedure StartToolkit(sDataPath : string);
    procedure ClearLines;
    procedure FillCompanyList(cmbComp : TComboBox);
  public
  end;


var
  frmMain: TfrmMain;

implementation

{$R *.DFM}

uses
  SecCodes, COMObj, PISecure, Progress, UseDllU;


type
  TCompanyType = Record
    CompCode : string[6];
    CompName : string[45];
    CompPath : string[100];
    CompSpare : array [1..100] of char;
  end;

  TCompanies = Array[1..200] of TCompanyType;
  PCompanies = ^TCompanies;

  function EX_GETCOMPANY(COMPDIR : PCHAR; PARRAY : POINTER; VAR PARRAYSIZE : LONGINT) : SMALLINT; stdCall; external 'EntComp.dll';
{
  FUNCTION EX_RESETADJNOMFLAGS(Const TransRef   : PChar) : SMALLINT; STDCALL; EXTERNAL 'EntDLL32.dll';
  FUNCTION EX_SETLINEGLCODE(Const iTXFolioNo : LongInt; Const iABSLineNo : LongInt; Const iNewGLCode : LongInt) : SMALLINT; STDCALL; EXTERNAL 'EntDLL32.dll';
  FUNCTION EX_GMGRESETSTOCKGLS(DOCREFNO    :  PCHAR) :  SMALLINT; STDCALL; EXTERNAL 'EntDLL32.dll';
}
FUNCTION EX_UPDATETXFIELD(Const pTransRef   : PChar;
                          Const iAbsLineNo  : LongInt;
                          Const iFieldNo  : LongInt;
                          Const pNewFieldValue    : PChar) : SmallInt;
                          STDCALL; EXTERNAL 'EntDLL32.dll';

PROCEDURE EX_INCLUDEHIDDENLINES(const bInclude : WordBool); STDCALL; EXTERNAL 'EntDLL32.dll';

FUNCTION EX_UPPERCASESTOCKLOCATIONS(Const pTransRef : PChar) : SmallInt; STDCALL; EXTERNAL 'EntDLL32.dll';

FUNCTION EX_SETSTOCKLOCATIONS(Const pTransRef : PChar; Const pLocation : PChar) : SmallInt; STDCALL; EXTERNAL 'EntDLL32.dll';

function EX_UPDATERECONCILEFLAG(const RecordAddress : longint; const NewValue : SmallInt) : SmallInt; STDCALL; EXTERNAL 'EntDLL32.dll';


procedure TfrmMain.btnCloseClick(Sender: TObject);
begin
  Close;
end;

procedure TfrmMain.FormCreate(Sender: TObject);
var
  iTKRes : SmallInt;
begin
  oToolkit := nil;

  //Check Plug-In Security
  if PICheckSecurity('EXCHDDATGL000087', 'o8w3vn64ieurjhd3', sPlugInName, sVersionNo
  + ' (EXE)', stSystemOnly, ptStandaloneEXE, ExtractFileName(Application.EXEName)) then
  begin
    Caption := sPlugInName + ' ' + sVersionNo;

    iTKRes := Ex_InitDLL;

    oToolkit := CreateOLEObject('Enterprise01.Toolkit') as IToolkit;

    FillCompanyList(cmbCompany);
    if (cmbCompany.Items.Count = 0) then
    begin
      MessageDlg('No company data was found',mtError,[mbOK],0);
      Close;
    end else
    begin
    end; // if cmbCompany.Items.Count = 0 then

//    iCompItemIndex := cmbCompany.ItemIndex;
    cmbCompanyChange(cmbCompany);

    edDateFrom.Date := Date;
    edDateTo.Date := Date;

    bGLCodeOK := FALSE;
    EnableDisable;
  end;{if}
end;

procedure TfrmMain.FormDestroy(Sender: TObject);
var
  iTKRes : SmallInt;
begin
  ClearList(cmbCompany.Items);
  iTKRes := Ex_CloseDLL;
end;

procedure TfrmMain.FillCompanyList(cmbComp : TComboBox);
var
  CompDir : array[0..255] of char;
  CompArray : PCompanies;
  iArrayItems, iPos : longint;
  iSelect, iStatus : smallint;
  CompanyInfo : TCompanyInfo;
begin
  iSelect := 0;
  new(CompArray);
  StrPCopy(CompDir, GetEnterpriseDirectory);
  iArrayItems := SizeOf(CompArray^);
  iStatus := EX_GETCOMPANY(CompDir, CompArray, iArrayItems);
  if (iStatus = 0) then
  begin
    for iPos := 1 to iArrayItems do
    begin
      with CompArray^[iPos] do
      begin
        CompanyInfo := TCompanyInfo.Create;
        with CompanyInfo do
        begin
          Name := CompName;
          Code := CompCode;
          Path := CompPath;
        end; // with CompanyInfo do...
        cmbComp.Items.AddObject(CompName, CompanyInfo);

        if WinGetShortPathName(UpperCase(Trim(oToolkit.Enterprise.enCompanyPath)))
        = WinGetShortPathName(UpperCase(Trim(CompanyInfo.Path)))
        then iSelect := cmbComp.Items.Count-1;

      end; // with CompArray^[iPos] do...
    end; // for iPos := 1 to iArrayItems do...

    if (cmbComp.Items.Count <> 0) then
    begin
      cmbComp.ItemIndex := iSelect;
      cmbComp.Enabled := cmbComp.Items.Count > 1;
    end;
  end
  else
  begin
    ShowMessage('Error ' + IntToStr(iStatus) + ' occurred whilst reading the company list');
  end; // if (iStatus = 0) then
  Dispose(CompArray);
end;

procedure TfrmMain.cmbCompanyChange(Sender: TObject);
var
  iTKRes : SmallInt;
  sPath : string;
  pPath : PChar;
  iCompItemIndex : smallint;
begin
  edGLCode.Text := '';

  iTKRes := Ex_CloseData;
  iCompItemIndex := cmbCompany.ItemIndex;

  if Assigned(oToolkit) then oToolkit.CloseToolkit;
  oToolkit := nil;

  pPath := StrAlloc(255);
  sPath := Trim(TCompanyInfo(cmbCompany.Items.Objects[iCompItemIndex]).Path);
  StrPCopy(pPath, sPath);
  iTKRes := EX_InitDLLpath(pPath, TRUE);
  if iTKRes <> 0 then Showmessage('DLL Toolkit Error ' + inttostr(iTKRes) + ' in EX_InitDLLpath')
  else begin
    iTKRes := Ex_InitDLL;
    if iTKRes <> 0 then Showmessage('DLL Toolkit Error ' + inttostr(iTKRes) + ' in EX_InitDLL');
  end;{if}
  StrDispose(pPath);

  StartToolkit(sPath);
  sMiscDirLocation := sPath;
end;

procedure TfrmMain.btnRunClick(Sender: TObject);
begin
  if MsgBox('Are you sure you want to Clear your transaction lines ?'
  ,mtConfirmation, [mbYes, mbNo], mbNo, 'Are you sure ?') = mrYes then
  begin
    ClearLines;
    // close COM toolkit - we will be using the DLL Toolkit for the update
//    oToolkit.CloseToolkit;
//    oToolkit := nil;
  end;{if}
end;

procedure TfrmMain.btnCancelClick(Sender: TObject);
begin
  Close;
end;

procedure TfrmMain.EnableDisable;
begin
  btnRun.Enabled := (cmbCompany.ItemIndex >= 0) and bGLCodeOK and (StrToIntDef(edGLCode.Text, 0) <> 0);
end;
(*
procedure TfrmMain.ReplaceSLs;
var
  TKTXHeader : TBatchTHRec;
//  TKTXLines : TBigBatchLinesRec;
//  TKTXLines : ^TBigBatchLinesRec;
  pKey, pOurRef : PChar;
  iNoOfLinesProcessed, iNoOfLinesUpdated, iRecAddress, iPos, iStatus : longint;
  asStockLocation : ANSIString;
  sLogFilename : string;
//  FrmProgress : TFrmProgress;
//  KeyS : Str255;

  function TXTypeOK(sTXType : string) : boolean;
  begin{TXTypeOK}
    Result := (Copy(sTXType,1,1) = 'S') or (Copy(sTXType,1,1) = 'P')
    or (sTXType = 'WOR') or (sTXType = 'ADJ');

    if (sTXType = 'SRC') or (sTXType = 'PPY') then Result := FALSE;  // ignore these as they cannot have locations
  end;{TXTypeOK}

begin
  iNoOfLinesUpdated := 0;
  iNoOfLinesProcessed := 0;
  FillChar(TKTXHeader, SizeOf(TKTXHeader), #0);
  pOurRef := StrAlloc(255);
  pKey := StrAlloc(255);

  FrmProgress := TFrmProgress.Create(application);
  FrmProgress.Show;

  sLogFilename := ExtractFilePath(Application.exename) + 'AVStockLocationUtil.log';
  AddLineToFile(' ', sLogFilename);
  AddLineToFile(' ', sLogFilename);
  AddLineToFile('REPLACE STOCK LOCATIONS', sLogFilename);

  EX_INCLUDEHIDDENLINES(TRUE);


//  GetMem(TKTXLines, SizeOf(TBigBatchLinesRec));

  // Get First TX
  iStatus := EX_GETTRANS(@TKTXHeader, TKTXLines, SizeOf(TKTXHeader)
  , SizeOf(TBigBatchLinesRec), pKey, 0, B_GetFirst, FALSE);

  // go through ALL TXs
  while (iStatus = 0) do
  begin

    FrmProgress.UpdateStatus(TKTXHeader.OurRef);

//      AddLineToFile(TKTXHeader.OurRef, 'c:\tx.txt');

    // Check TX Type
    if TXTypeOK(TKTXHeader.TransDocHed) then
    begin

      StrPCopy(pOurRef, TKTXHeader.OurRef);
//      asStockLocation := UpperCase(Trim(edStockLocation.Text));
      istatus := EX_SETSTOCKLOCATIONS(pOurRef, PChar(asStockLocation));

      // Go Through Lines
(*      For iPos := 1 to TKTXHeader.LineCount do
      begin
        inc(iNoOfLinesProcessed);

        // Check Stock Location on Line
        if (Trim(TKTXLines[iPos].StockCode) <> '') // Ignore non-stock lines
        and ((not TKTXLines[iPos].Payment) or (TKTXHeader.TransDocHed = 'ADJ')) // Ignore Payment Lines (apparently all ADJ Lines are Payment lines......????)
        and (not StockLocationOK(TKTXLines[iPos].MLocStk)) then
        begin
          // Update Stock Location
          StrPCopy(pOurRef, TKTXHeader.OurRef);
          asStockLocation := UpperCase(Trim(edStockLocation.Text));
          istatus := EX_UPDATETXFIELD(pOurRef, TKTXLines[iPos].ABSLineNo, 1, PChar(asStockLocation));
          if istatus = 0 then
          begin
            inc(iNoOfLinesUpdated);

            // Log change
            AddLineToFile(TKTXHeader.OurRef
            + ' TKLineNo:' + IntToStr(iPos)
            + ' LineNo:' + IntToStr(TKTXLines[iPos].LineNo)
            + ' ABSLineNo:' + IntToStr(TKTXLines[iPos].ABSLineNo)
            + ' OldLocation:' + Trim(TKTXLines[iPos].MLocStk)
            + ' NewLocation:' + Trim(asStockLocation)
            , sLogFilename);
          end else
          begin
            ShowMessage('EX_UPDATETXFIELD error ' + IntToStr(istatus));
          end;{if}
        end;{if}

        Application.ProcessMessages;

      end;{for}
    end;{if}

    Application.ProcessMessages;

    // Next TX
    iStatus := EX_GETTRANS(@TKTXHeader, TKTXLines, SizeOf(TKTXHeader)
    , SizeOf(TBigBatchLinesRec), pKey, 0, B_GetNext, FALSE);

  end;{while}

  if not (iStatus in [9,4]) then Showmessage('EX_GETTRANS Error : ' + IntToStr(iStatus));

  StrDispose(pOurRef);
  StrDispose(pKey);

  FrmProgress.Hide;
  FrmProgress.Release;

  EX_INCLUDEHIDDENLINES(FALSE);

  FreeMem(TKTXLines, SizeOf(TBigBatchLinesRec));


  MsgBox('Finished updating stock locations.'//#13#13
//  + 'No of Lines Processed : ' + IntToStr(iNoOfLinesProcessed) + #13#13
//  + 'No of Lines Updated : ' + IntToStr(iNoOfLinesUpdated)
  , mtInformation, [mbOK], mbOK, 'Finished');
end;

procedure TfrmMain.UpperCaseSLs;
var
  TKTXHeader : TBatchTHRec;
//  TKTXLines : TBigBatchLinesRec;
  TKTXLines : ^TBigBatchLinesRec;
  pKey, pOurRef : PChar;
  iNoOfLinesProcessed, iNoOfLinesUpdated, iRecAddress, iPos, iStatus : longint;
  asStockLocation : ANSIString;
  sLogFilename : string;
//  KeyS : Str255;

  function TXTypeOK(sTXType : string) : boolean;
  begin{TXTypeOK}
    Result := (Copy(sTXType,1,1) = 'S') or (Copy(sTXType,1,1) = 'P')
    or {(sTXType = 'WOR') or} (sTXType = 'ADJ');

    if (sTXType = 'SRC') or (sTXType = 'PPY') then Result := FALSE;  // ignore these as they cannot have locations
  end;{TXTypeOK}

(*  function GetNewStockLocation(var asCode : ANSIstring) : boolean;
  var
    pCode : PChar;
    iStatus : integer;
  begin{GetNewStockLocation}
    if UpperCase(asCode) = asCode then
    begin
      // already uppercase
      if StockLocationOK(asCode) then
      begin
        Result := FALSE;
      end else
      begin
        if Trim(asCode) = '' then
        begin
          // Don;t bother updating blank codes with blank codes.
          Result := FALSE;
        end else
        begin
          // updating bad locations with blank codes.
          Result := TRUE;
          asCode := '';
        end;{if}
      end;{if}
    end else
    begin
      // not uppercased
      Result := TRUE;
      if StockLocationOK(UpperCase(asCode)) then
      begin
        // Uppercase the location
        asCode := UpperCase(asCode);
      end else
      begin
        // even the Uppercase location is invalid, so blank it
        asCode := '';
      end;{if}
    end;{if}
  end;{GetNewStockLocation}

begin
  iNoOfLinesUpdated := 0;
  iNoOfLinesProcessed := 0;
  FillChar(TKTXHeader, SizeOf(TKTXHeader), #0);
  pOurRef := StrAlloc(255);
  pKey := StrAlloc(255);

  FrmProgress := TFrmProgress.Create(application);
  FrmProgress.Show;

  sLogFilename := ExtractFilePath(Application.exename) + 'AVStockLocationUtil.log';
  AddLineToFile(' ', sLogFilename);
  AddLineToFile(' ', sLogFilename);
  AddLineToFile('UPPER CASE STOCK LOCATIONS', sLogFilename);

  EX_INCLUDEHIDDENLINES(TRUE);

  GetMem(TKTXLines, SizeOf(TBigBatchLinesRec));

  // Get First TX
  iStatus := EX_GETTRANS(@TKTXHeader, TKTXLines, SizeOf(TKTXHeader)
  , SizeOf(TBigBatchLinesRec), pKey, 0, B_GetFirst, FALSE);

  // go through ALL TXs
  while (iStatus = 0) do
  begin

    FrmProgress.UpdateStatus(TKTXHeader.OurRef);

//      AddLineToFile(TKTXHeader.OurRef, 'c:\tx.txt');

    // Check TX Type
    if TXTypeOK(TKTXHeader.TransDocHed) then
    begin

      StrPCopy(pOurRef, TKTXHeader.OurRef);
      istatus := EX_UPPERCASESTOCKLOCATIONS(pOurRef);

      // Go Through Lines
(*      For iPos := 1 to TKTXHeader.LineCount do
      begin
        inc(iNoOfLinesProcessed);

        asStockLocation := TKTXLines[iPos].MLocStk;

        // Check Stock Location on Line
        if (Trim(TKTXLines[iPos].StockCode) <> '') // Ignore non-stock lines
        and ((not TKTXLines[iPos].Payment) or (TKTXHeader.TransDocHed = 'ADJ')) // Ignore Payment Lines (apparently all ADJ Lines are Payment lines......????)
        and GetNewStockLocation(asStockLocation) then
        begin
          // Update Stock Location
          StrPCopy(pOurRef, TKTXHeader.OurRef);
          istatus := EX_UPDATETXFIELD(pOurRef, TKTXLines[iPos].ABSLineNo, 1, PChar(asStockLocation));
          if istatus = 0 then
          begin
            inc(iNoOfLinesUpdated);

            // Log change
            AddLineToFile(TKTXHeader.OurRef
            + ' TKLineNo:' + IntToStr(iPos)
            + ' LineNo:' + IntToStr(TKTXLines[iPos].LineNo)
            + ' ABSLineNo:' + IntToStr(TKTXLines[iPos].ABSLineNo)
            + ' OldLocation:' + Trim(TKTXLines[iPos].MLocStk)
            + ' NewLocation:' + Trim(asStockLocation)
            , sLogFilename);
          end else
          begin
            ShowMessage('EX_UPDATETXFIELD error ' + IntToStr(istatus));
          end;{if}
        end;{if}

        Application.ProcessMessages;

      end;{for}
    end;{if}

    Application.ProcessMessages;

    // Next TX
    iStatus := EX_GETTRANS(@TKTXHeader, TKTXLines, SizeOf(TKTXHeader)
    , SizeOf(TBigBatchLinesRec), pKey, 0, B_GetNext, FALSE);

  end;{while}

  if not (iStatus in [9,4]) then Showmessage('EX_GETTRANS Error : ' + IntToStr(iStatus));

  StrDispose(pOurRef);
  StrDispose(pKey);

  FrmProgress.Hide;
  FrmProgress.Release;

  EX_INCLUDEHIDDENLINES(FALSE);

  FreeMem(TKTXLines, SizeOf(TBigBatchLinesRec));

  MsgBox('Finished updating stock locations.'//#13#13
//  + 'No of Lines Processed : ' + IntToStr(iNoOfLinesProcessed) //+ #13#13
//  + 'No of Lines Updated : ' + IntToStr(iNoOfLinesUpdated)
  , mtInformation, [mbOK], mbOK, 'Finished');
end;
*)

procedure TfrmMain.edGLCodeChange(Sender: TObject);
begin
  with oToolkit.GeneralLedger do begin
    Index := glIdxCode;
    if (GetEqual(BuildCodeIndex(StrToIntDef(edGLCode.text, 0))) = 0)
    and (glType in [glTypeProfitLoss, glTypeBalanceSheet]) then
    begin
      lGLName.Caption := glName;
      bGLCodeOK := TRUE;
    end else
    begin
      lGLName.Caption := '';
      bGLCodeOK := FALSE;
    end;
    EnableDisable;
  end;{with}
end;

procedure TfrmMain.btnFindGLCodeClick(Sender: TObject);
var
  oGLCode : IGeneralLedger;
  iGLCode : integer;
begin
  with TfrmTKPickList.CreateWith(self, oToolkit) do
  begin
    mlList.Columns[0].DataType := dtInteger;
    plType := plGLCode;
    iGLCode := StrToIntDef(edGLCode.Text,0);

    if (iGLCode = 0) and (edGLCode.Text <> '0') then
      begin
        sFind := edGLCode.Text;
        iSearchCol := 1;
      end
    else begin
      sFind := mlList.FullNomKey(iGLCode);
      iSearchCol := 0;
    end;{if}
    mlList.Columns[1].IndexNo := 1;

//    sFind := edGLCode.Text;
    if showmodal = mrOK then begin
      oGLCode := ctkDataSet.GetRecord as IGeneralLedger;
      edGLCode.Text := IntToStr(oGLCode.glCode);
    end;
    release;
  end;{with}
end;

procedure TfrmMain.StartToolkit(sDataPath : string);
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
        oToolkit.Configuration.DataDirectory := sDataPath;
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

procedure TfrmMain.ClearLines;
var
  TKTXHeader : TBatchTHRec;
  TKTXLine : TBatchTLRec;
//  TKTXLines : TBigBatchLinesRec;
//  TKTXLines : ^TBigBatchLinesRec;
  pKey, pOurRef : PChar;
  iRecAddress, iGLCode, iNoOfLinesProcessed, iNoOfLinesUpdated, iPos, iStatus : longint;
  asStockLocation : ANSIString;
  sCSVFilename, sLogFilename : string;
//  sDate : string8;
  slTXHeaders : TStringList;
//  KeyS : Str255;
  SystemSetupRec : TBatchSysRec;

  function BuildSLKey(iFolio : integer): string;
  begin
    Result := PadString(psLeft, IntToStr(iFolio), '0', 25);
  end;

  procedure ShowError(sFunc : string; iStatus : integer);
  begin{ShowError}
//    MsgBox(, mtError, [mbOK], mbOK, 'DLL Toolkit Error');
    AddLineToFile(' ', sLogFilename);
    AddLineToFile('*** ''An error occurred calling a DLL function. Function : '
    + sFunc + ' / ' + 'Error : ' + IntToStr(iStatus), sLogFilename);
  end;{ShowError}
(*
  function GetHeaderDate(iFolioNo : integer) : String8;
  var
    iPos : integer;
    DateInfo : TDateInfo;
  begin
    iPos := slTXHeaders.IndexOf(BuildSLKey(iFolioNo));
    if iPos >= 0 then
    begin
      // Get Date from StringList;
      Result := TDateInfo(slTXHeaders.Objects[iPos]).sDate;
    end else
    begin
      // Get Date from TX Header
      StrPCopy(pKey, EX_CONVERTFOLIO(iFolioNo));
      iStatus := EX_GETTRANSHED(@TKTXHeader, SizeOf(TKTXHeader)
      , pKey, 1, B_GetEq, FALSE);
      if iStatus = 0 then
      begin
        Result := TKTXHeader.TransDate;

        // Store Date in StringList
        DateInfo := TDateInfo.Create;
        DateInfo.sDate := TKTXHeader.TransDate;
        slTXHeaders.AddObject(BuildSLKey(iFolioNo), DateInfo);
      end else
      begin
        if iStatus = 4 then
        begin
          AddLineToFile(' ', sLogFilename);
          AddLineToFile('*** ERROR FINDING TRANSACTION HEADER ***', sLogFilename);
          AddLineToFile('Line Folio : ' + IntToStr(iFolioNo), sLogFilename);
          AddLineToFile('Line OurRef : ' + TKTXLine.TransRefNo, sLogFilename);
          AddLineToFile('Line StockCode : ' + TKTXLine.StockCode, sLogFilename);
          AddLineToFile('Line CustCode : ' + TKTXLine.CustCode, sLogFilename);
          AddLineToFile('Line LineDate : ' + TKTXLine.LineDate, sLogFilename);
          AddLineToFile('Line Desc : ' + TKTXLine.Desc, sLogFilename);
          AddLineToFile('Line LineNo : ' + IntToStr(TKTXLine.LineNo), sLogFilename);
          AddLineToFile('Line ABSLineNo : ' + IntToStr(TKTXLine.ABSLineNo), sLogFilename);
        end else
        begin
          ShowError('EX_GETTRANSHED', iStatus);
        end;{if}

        Result := DateToStr8(edDateFrom.Date - 100); //set date to a date previous to the start date, so it will NOT be included
      end;{if}
    end;
  end;{GetHeaderDate}
*)
  function GetHeaderRec(iFolioNo : integer) : THeaderRec;
  var
    iPos : integer;
    HeaderInfo : THeaderInfo;
  begin
    iPos := slTXHeaders.IndexOf(BuildSLKey(iFolioNo));
    if iPos >= 0 then
    begin
      // Get Header Info from StringList;
      Result := THeaderInfo(slTXHeaders.Objects[iPos]).HeaderRec;
    end else
    begin
      // Get Date / OurRef from TX Header
      StrPCopy(pKey, EX_CONVERTFOLIO(iFolioNo));
      iStatus := EX_GETTRANSHED(@TKTXHeader, SizeOf(TKTXHeader)
      , pKey, 1, B_GetEq, FALSE);
      if iStatus = 0 then
      begin
        // Store Date in StringList
        HeaderInfo := THeaderInfo.Create;
        HeaderInfo.HeaderRec.sDate := TKTXHeader.TransDate;
        HeaderInfo.HeaderRec.sOurRef := TKTXHeader.OurRef;
        slTXHeaders.AddObject(BuildSLKey(iFolioNo), HeaderInfo);

        Result := HeaderInfo.HeaderRec;
      end else
      begin
        if iStatus = 4 then
        begin
          AddLineToFile(' ', sLogFilename);
          AddLineToFile('*** ERROR FINDING TRANSACTION HEADER ***', sLogFilename);
          AddLineToFile('Line Folio : ' + IntToStr(iFolioNo), sLogFilename);
          AddLineToFile('Line OurRef : ' + TKTXLine.TransRefNo, sLogFilename);
          AddLineToFile('Line StockCode : ' + TKTXLine.StockCode, sLogFilename);
          AddLineToFile('Line CustCode : ' + TKTXLine.CustCode, sLogFilename);
          AddLineToFile('Line LineDate : ' + TKTXLine.LineDate, sLogFilename);
          AddLineToFile('Line Desc : ' + TKTXLine.Desc, sLogFilename);
          AddLineToFile('Line LineNo : ' + IntToStr(TKTXLine.LineNo), sLogFilename);
          AddLineToFile('Line ABSLineNo : ' + IntToStr(TKTXLine.ABSLineNo), sLogFilename);
        end else
        begin
          ShowError('EX_GETTRANSHED', iStatus);
        end;{if}

        Result.sDate := DateToStr8(edDateFrom.Date - 100); //set date to a date previous to the start date, so it will NOT be included
//        Result := DateToStr8(edDateFrom.Date - 100); //set date to a date previous to the start date, so it will NOT be included
      end;{if}
    end;
  end;{GetHeaderDate}

  procedure LogLineToCSV(HeaderRec : THeaderRec; TKTXLine : TBatchTLRec);

    function GetNoOfDecsForTX(sOurRef : string9) : integer;
    begin{GetNoOfDecsForTX}
      Result := 2;
      if Length(sOurRef) <> 9 then
      begin
        Result := 2;
      end
      else
      begin
        Case sOurRef[1] of
          'S' : Result := SystemSetupRec.PriceDP;
          'P' : Result := SystemSetupRec.CostDP;
          'N' : Result := 2;
        end;{case}
      end;{if}
    end;{GetNoOfDecsForTX}

  var
    iNoOfDecs : integer;
  begin{LogLineToCSV}
    iNoOfDecs := GetNoOfDecsForTX(HeaderRec.sOurRef);
    AddLineToFile(Copy(HeaderRec.sDate, 7, 2) + '/' + Copy(HeaderRec.sDate, 5, 2) + '/' + Copy(HeaderRec.sDate, 1, 4)
    + ',' + HeaderRec.sOurRef + ',' + MoneyToStr(TKTXLine.NetValue, iNoOfDecs), sCSVFilename);
  end;{LogLineToCSV}

  function GetCSVFilename : string;
  var
    ClearGLINI : TIniFile;
    sDate, sTime : string;
  begin{GetCSVFilename}
    ClearGLINI := TIniFile.Create(IncludeTrailingPathDelimiter(ExtractFilePath(Application.ExeName))+'ClearGL.INI');
    if UpperCase(Trim(ClearGLINI.ReadString('Settings', 'CreateCSV', 'FALSE'))) = 'TRUE' then
    begin
      Result := ClearGLINI.ReadString('Settings', 'CSVDir', '');
      if Trim(Result) = '' then Result := IncludeTrailingPathDelimiter(ExtractFilePath(Application.ExeName))
      else Result := IncludeTrailingPathDelimiter(Result);
      Result := Result + 'ClearGL_' + DateToStr8(Date) + '_' + TimeToStr6(Time) + '.CSV';
    end
    else
    begin
      Result := '';
    end;{if}
    ClearGLINI.Free;
  end;{GetCSVFilename}

var
  HeaderRec : THeaderRec;

begin
  screen.cursor := crHourglass;
  slTXHeaders := TStringList.Create;
  iNoOfLinesUpdated := 0;
  iNoOfLinesProcessed := 0;
  FillChar(TKTXHeader, SizeOf(TKTXHeader), #0);
  FillChar(TKTXLine, SizeOf(TKTXLine), #0);
//  pOurRef := StrAlloc(255);
  pKey := StrAlloc(255);

  FrmProgress := TFrmProgress.Create(application);
  FrmProgress.Show;

  iGLCode := StrToIntDef(edGLCode.Text, 0);

  sLogFilename := ExtractFilePath(Application.exename) + 'CLEARGL.log';
  AddLineToFile(' ', sLogFilename);
  AddLineToFile(' ', sLogFilename);
  AddLineToFile(sPlugInName +  ' run on ' + DateToScreenDate(Date)
  + ' ' + TimeToScreenTime(Time), sLogFilename);
  AddLineToFile('Company : ' + Trim(cmbCompany.Items[cmbCompany.Itemindex]), sLogFilename);
  AddLineToFile('GL Code : ' + IntToStr(iGLCode), sLogFilename);
  AddLineToFile('Date From : ' + DateToScreenDate(edDateFrom.Date), sLogFilename);
  AddLineToFile('Date To : ' + DateToScreenDate(edDateTo.Date), sLogFilename);

//  EX_INCLUDEHIDDENLINES(TRUE);

//  GetMem(TKTXLines, SizeOf(TBigBatchLinesRec));


  // Get First TX
//  iStatus := EX_GETTRANS(@TKTXHeader, TKTXLines, SizeOf(TKTXHeader)
//  , SizeOf(TBigBatchLinesRec), pKey, 0, B_GetFirst, FALSE);

  sCSVFilename := GetCSVFilename;

  // Get System Setup for Decimal Places;
  iStatus := Ex_GetSysData(@SystemSetupRec, SizeOf(SystemSetupRec));
  if iStatus <> 0 then
  begin
    ShowError('EX_GETRECORDADDRESS', iStatus);
    SystemSetupRec.PriceDP := 2;
    SystemSetupRec.CostDP := 2;
  end;{if}

  StrPCopy(pKey, EX_CONVERTFOLIO(iGLCode));
  iStatus := EX_GETTRANSLINE(@TKTXLine, SizeOf(TKTXLine), pKey, 2, B_GetGEq, FALSE);

  // go through ALL TX Line for the nominal code given
  while (iStatus = 0) and (TKTXLine.NomCode = iGLCode) do
  begin
    FrmProgress.UpdateStatus(TKTXLine.TransRefNo);
    inc(iNoOfLinesProcessed);

    if (TKTXLine.FolioNum <> 0) // Ignore Lines with FolioNo of Zero, as they are dodgy lines - something to do with posting, apparently....
    and (TKTXLine.Reconcile = 0) then // Only do lines that are not reconciled
    begin

      HeaderRec := GetHeaderRec(TKTXLine.FolioNum);
//      sDate := GetHeaderDate(TKTXLine.FolioNum);

      // is TXLine in date range ?
      if (Trunc(Str8ToDate(HeaderRec.sDate)) >= Trunc(edDateFrom.Date))
      and (Trunc(Str8ToDate(HeaderRec.sDate)) <= Trunc(edDateTo.Date)) then
      begin
        // Line in date range
        iStatus := EX_GETRECORDADDRESS(3, iRecAddress);
        if iStatus = 0 then
        begin
          iStatus := EX_UPDATERECONCILEFLAG(iRecAddress, 1);
          if iStatus = 0 then
          begin
            inc(iNoOfLinesUpdated);
            if sCSVFilename <> '' then LogLineToCSV(HeaderRec, TKTXLine);
          end
          else
          begin
            ShowError('EX_UPDATERECONCILEFLAG', iStatus);
          end;{if}
        end else
        begin
          ShowError('EX_GETRECORDADDRESS', iStatus);
        end;{if}
      end;{if}
    end;{if}

    // Next Record
    iStatus := EX_GETTRANSLINE(@TKTXLine, SizeOf(TKTXLine), pKey, 2, B_GetNext, FALSE);
    application.processmessages;
  end;{while}

  if not (iStatus in [0,4,9]) then ShowError('EX_GETTRANSLINE', iStatus);

//  StrDispose(pOurRef);
  StrDispose(pKey);
  FrmProgress.Hide;
  FrmProgress.Release;
  ClearList(slTXHeaders);
  slTXHeaders.Free;
  screen.cursor := crDefault;

//  EX_INCLUDEHIDDENLINES(FALSE);

//  FreeMem(TKTXLines, SizeOf(TBigBatchLinesRec));

  MsgBox('Finished clearing transaction lines.'#13#13
  + 'No of Lines Processed : ' + IntToStr(iNoOfLinesProcessed) + #13#13
  + 'No of Lines Updated : ' + IntToStr(iNoOfLinesUpdated)
  , mtInformation, [mbOK], mbOK, 'Finished');
end;



end.
