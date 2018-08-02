unit Admin;

{ nfrewer440 16:57 09/07/2003: Disabled Byte Alignment in Delphi 6.0 }
{$ALIGN 1}  { Variable Alignment Disabled }


interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms
  , Dialogs, StdCtrls, ComCtrls, ExtCtrls, Menus, uMultiList, uDBMultiList
  , ImgList, uExDatasets, uBtrieveDataset, FileUtil, APIUtil, StrUtil
  , PPayProc, MiscUtil, COMObj, Enterprise01_TLB, TEditVal, uSettings
  , BTUtil, BTFile, BTConst, CustDet, Reports, Debt, SysSetup;

const
  {$IFDEF EX600}
    //sVersionNo = 'v6.00.019';
    sVersionNo = '020';
  {$ELSE}
    sVersionNo = 'v5.71.019';
  {$ENDIF}

type
  TCompanyInfo = Class
    CompanyRec : TCompanyRec;
  end;{with}

  TFrmAdmin = class(TForm)
    btnAdd: TButton;
    btnEdit: TButton;
    btnDelete: TButton;
    btnFind: TButton;
    btnClose: TButton;
    MainMenu1: TMainMenu;
    File1: TMenuItem;
    Exit1: TMenuItem;
    mlPPCust: TDBMultiList;
    ilSmallScroll: TImageList;
    bdsPPCust: TBtrieveDataset;
    pmMain: TPopupMenu;
    Add1: TMenuItem;
    Edit1: TMenuItem;
    Delete1: TMenuItem;
    Find1: TMenuItem;
    cmbCompany: TComboBox;
    N2: TMenuItem;
    Properties1: TMenuItem;
    SaveCoordinates1: TMenuItem;
    Help1: TMenuItem;
    About1: TMenuItem;
    Utilties1: TMenuItem;
    ExportDatabase1: TMenuItem;
    PPCustDAT1: TMenuItem;
    Label1: TLabel;
    btnPrint: TButton;
    btnDebt: TButton;
    SystemSetup1: TMenuItem;
    N1: TMenuItem;
    pmFind: TPopupMenu;
    byCustomerCode1: TMenuItem;
    byCustomerName1: TMenuItem;
    Debt1: TMenuItem;
    PPDebtDAT1: TMenuItem;
    procedure btnCloseClick(Sender: TObject);
    procedure bdsPPCustGetFieldValue(Sender: TObject; PData: Pointer;
      FieldName: String; var FieldValue: String);
    procedure bdsPPCustSelectRecord(Sender: TObject;
      SelectType: TSelectType; Address: Integer; PData: Pointer);
    procedure mlPPCustRowDblClick(Sender: TObject; RowIndex: Integer);
    procedure FormDestroy(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure mlCommissionAfterLoad(Sender: TObject);
    procedure mlPPCustAfterLoad(Sender: TObject);
    procedure cmbCompanyChange(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure Properties1Click(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure About1Click(Sender: TObject);
    procedure AddEdit(Sender: TObject);
    procedure PPCustDAT1Click(Sender: TObject);
    procedure mlPPCustBeforeLoad(Sender: TObject; var Allow: Boolean);
    procedure Exit1Click(Sender: TObject);
    procedure pmMainPopup(Sender: TObject);
    procedure btnDeleteClick(Sender: TObject);
    procedure Delete1Click(Sender: TObject);
    procedure mlPPCustCellPaint(Sender: TObject; ColumnIndex,
      RowIndex: Integer; var OwnerText: String; var TextFont: TFont;
      var TextBrush: TBrush; var TextAlign: TAlignment);
    procedure btnFindClick(Sender: TObject);
    procedure byCustomerCode1Click(Sender: TObject);
    procedure byCustomerName1Click(Sender: TObject);
    procedure btnPrintClick(Sender: TObject);
    procedure btnDebtClick(Sender: TObject);
    procedure Debt1Click(Sender: TObject);
    procedure PPDebtDAT1Click(Sender: TObject);
    procedure SystemSetup1Click(Sender: TObject);
    procedure FormResize(Sender: TObject);
  private
    iDefRowIndex, iCopy : integer;
    bRestore : boolean;
    PPDefaultCustRec : TPPCustRec;
    procedure EnableDisable;
    Procedure WMGetMinMaxInfo (Var Message : TWMGetMinMaxInfo); Message WM_GetMinMaxInfo;
    procedure SaveAllSettings;
    procedure LoadAllSettings;
    procedure FindCustCode(sCode : string);
  public
    { Public declarations }
  end;

var
  FrmAdmin: TFrmAdmin;

implementation
uses
  ETStrU, SQLUtils, SecCodes, PISecure, ExchequerRelease;

{$R *.dfm}

procedure TFrmAdmin.btnCloseClick(Sender: TObject);
begin
  Close;
end;

procedure TFrmAdmin.EnableDisable;
begin
  btnEdit.Enabled := (mlPPCust.ItemsCount > 0) and (mlPPCust.Selected >= 0);
  if btnDelete.Enabled  then begin
    if (mlPPCust.ItemsCount = 0) or (mlPPCust.Selected < 0)
    then btnDelete.Enabled  := FALSE;
  end;{if}
  btnDebt.Enabled := btnEdit.Enabled;
  btnFind.Enabled := (mlPPCust.ItemsCount > 0);
  btnPrint.Enabled := btnDebt.Enabled;
end;

procedure TFrmAdmin.bdsPPCustGetFieldValue(Sender: TObject;
  PData: Pointer; FieldName: String; var FieldValue: String);

  function GetBasisFrom(iBasis : Byte) : string;
  begin
    case iBasis of
      0 : Result := 'not applicable';
      1 : Result := 'per transaction';
      2 : Result := 'per process';
    end;{case}
  end;

begin
  with TPPCustRec(PData^) do begin
    case FieldName[1] of
      'A' : begin
        if ppcCustCode = PPC_DEFAULT_RECORD
        then FieldValue := 'Default'
        else FieldValue := Trim(ppcCustCode);
      end;

      'E' : begin
        if ppcCustCode = PPC_DEFAULT_RECORD then FieldValue := MoneyToStr(ppcDefaultRate)
        else FieldValue := MoneyToStr(ppcInterestVariance + PPDefaultCustRec.ppcDefaultRate);
      end;

      'M' : FieldValue := MoneyToStr(ppcMinInvoiceValue, oToolkit.SystemSetup.ssSalesDecimals);
      'I' : FieldValue := IntToStr(ppcInterestGLCode);
      'C' : FieldValue := Trim(ppcCostCentre);
      'D' : FieldValue := Trim(ppcDepartment);
      'T' : FieldValue := IntToStr(ppcDebtChargeGLCode);
      'B' : FieldValue := GetBasisFrom(ppcDebitChargeBasis);
    end;
  end;
end;

procedure TFrmAdmin.bdsPPCustSelectRecord(Sender: TObject;
  SelectType: TSelectType; Address: Integer; PData: Pointer);
begin
  btnDelete.enabled := (mlPPCust.ItemsCount > 0) and (mlPPCust.Selected >= 0)
  and (TPPCustRec(PData^).ppcCustCode <> PPC_DEFAULT_RECORD);
  Delete1.Enabled := btnDelete.enabled
end;

procedure TFrmAdmin.mlPPCustRowDblClick(Sender: TObject;
  RowIndex: Integer);
begin
  AddEdit(btnEdit);
end;

procedure TFrmAdmin.FormDestroy(Sender: TObject);
begin
  If Assigned(oToolkit) Then Begin
    // Close COM Toolkit and remove reference
    oToolkit.CloseToolkit;
    oToolkit := NIL;
  End; { If Assigned(oToolkit) }
end;

procedure TFrmAdmin.FormCreate(Sender: TObject);

  procedure InitToolkit;
  var
    a, b, c : LongInt;
    iPos : integer;
    CompanyInfo : TCompanyInfo;
  begin{InitToolkit}
    // Create COM Toolkit object
    oToolkit := CreateOLEObject('Enterprise01.Toolkit') as IToolkit;

    // Check it created OK
    If Assigned(oToolkit) Then Begin

      EncodeOpCode(97, a, b, c);
      oToolkit.Configuration.SetDebugMode(a, b, c);

      oToolkit.Configuration.AutoSetTransCurrencyRates := TRUE;
      For iPos := 1 to oToolkit.Company.cmCount do begin
        CompanyInfo := TCompanyInfo.Create;
        CompanyInfo.CompanyRec.Path := Trim(oToolkit.Company.cmCompany[iPos].coPath);
        CompanyInfo.CompanyRec.Name := Trim(oToolkit.Company.cmCompany[iPos].coName);
        CompanyInfo.CompanyRec.Code := Trim(oToolkit.Company.cmCompany[iPos].coCode);
        cmbCompany.Items.AddObject(oToolkit.Company.cmCompany[iPos].coName, CompanyInfo);
      end;{for}

      cmbCompany.ItemIndex := 0;
      cmbCompanyChange(cmbCompany);

    End { If Assigned(oToolkit) }
    Else
      // Failed to create COM Object
      ShowMessage ('Cannot create COM Toolkit instance');
  end;{InitToolkit}

const
  sPlugInName = 'Exchequer Late Payment Penalty Plug-In';
begin{FormCreate}

  LoadAllSettings;

  bRestore := FALSE;
  iCopy := 0;
  oToolkit := nil;

  //Check Plug-In Security
  if PICheckSecurity('EXCHPROPAY000018', '~$ggkj-Q-d36@6fa', sPlugInName, '', stSystemOnly, ptStandaloneEXE, ExtractFileName(Application.EXEName))
  then InitToolkit;
end;

procedure TFrmAdmin.mlCommissionAfterLoad(Sender: TObject);
begin
  EnableDisable;
end;

procedure TFrmAdmin.mlPPCustAfterLoad(Sender: TObject);
begin
  EnableDisable;
end;

procedure TFrmAdmin.cmbCompanyChange(Sender: TObject);
var
  FuncRes : integer;
begin
  Screen.Cursor := crHourglass;
  if (oToolkit.Status = tkOpen) Then begin
    // Close all
    oToolkit.CloseToolkit;
    CloseFiles;
    mlPPCust.Active := FALSE;
  end;{if}

  with oToolkit do
  begin
    // Open Default Company
    CompanyRec := TCompanyInfo(cmbCompany.Items.Objects[cmbCompany.ItemIndex]).CompanyRec;

    // Open Btrieve Files
    OpenFiles;

    // OpenToolkit
    oToolkit.Configuration.DataDirectory := CompanyRec.Path;
    FuncRes := OpenToolkit;

    // Check it opened OK
    if (FuncRes = 0) then
    begin
//      edCommission.displayformat := '######0.' + StringOfChar('#', oToolkit.SystemSetup.ssSalesDecimals);
//      sMiscDirLocation := CompanyRec.Path;

//      OpenFiles;

//      oSettings.ReopenFile;

      // Set datapaths, reopen lists
      bdsPPCust.FileName := CompanyRec.Path + ppFileName[ppCustF];
      mlPPCust.Active := TRUE;

    end
    else begin
      // Error opening Toolkit - display error
      ShowMessage ('The following error occured opening the Toolkit:-'#13#13
      + QuotedStr(oToolkit.LastErrorString));
    end;{if}

  end; { With OToolkit }
  Screen.Cursor := crDefault;
end;

procedure TFrmAdmin.FormActivate(Sender: TObject);
begin
  if oToolkit = nil then close;
end;

procedure TFrmAdmin.WMGetMinMaxInfo(var Message: TWMGetMinMaxInfo);
begin
  With Message.MinMaxInfo^ Do Begin
    ptMinTrackSize.X:=350;
    ptMinTrackSize.Y:=270;
  End; { With Message }
end;

procedure TFrmAdmin.Properties1Click(Sender: TObject);
begin
  case oSettings.Edit(mlPPCust, Self.Name, cmbCompany) of
    mrOK : oSettings.ColorFieldsFrom(cmbCompany, Self);
    mrRestoreDefaults : begin
      oSettings.RestoreParentDefaults(Self, Self.Name);
      oSettings.RestoreFormDefaults(Self.Name);
      oSettings.RestoreListDefaults(mlPPCust, Self.Name);
      bRestore := TRUE;
    end;
  end;{case}
end;

procedure TFrmAdmin.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  if not bRestore then SaveAllSettings;
end;

procedure TFrmAdmin.SaveAllSettings;
begin
  oSettings.SaveParentFromControl(cmbCompany, Self.Name);
  oSettings.SaveList(mlPPCust, Self.Name);
  if SaveCoordinates1.Checked then oSettings.SaveForm(Self);
end;

procedure TFrmAdmin.LoadAllSettings;
begin
  sMiscDirLocation := GetEnterpriseDirectory;
  oSettings.LoadForm(Self);
  oSettings.LoadParentToControl(Self.Name, Self.Name, cmbCompany);
  oSettings.ColorFieldsFrom(cmbCompany, Self);
  oSettings.LoadList(mlPPCust, Self.Name);
end;

procedure TFrmAdmin.About1Click(Sender: TObject);
begin
  MessageDlg('Exchequer Late Payment Penalty Configuration'+ #13#13 +
             ExchequerModuleVersion (emGenericPlugIn, sVersionNo) + #13#13 +
             DoubleAmpers(GetCopyrightMessage) + #13 +
             'All rights reserved.', mtInformation, [mbOk], 0);
end;

procedure TFrmAdmin.AddEdit(Sender: TObject);
var
  PPCustRec : TPPCustRec;
  frmCustDetails : TfrmCustDetails;
  iStatus : integer;
  KeyS : TStr255;
  pRecord : Pointer;
begin
  frmCustDetails := TfrmCustDetails.Create(Application) ;
  with frmCustDetails do begin
    bAdd := TWinControl(sender).Tag = 0;

    KeyS := PPC_DEFAULT_RECORD;
    iStatus := BTFindRecord(B_GetEq, ppFileVar[ppCustF], PPDefaultCustRec, ppBufferSize[ppCustF]
    , ppcCustIdx, KeyS);

    if bAdd then
    begin
      bDefault := iStatus in [4,9];

      if bDefault then
      begin
        MsgBox('You are about to add the default Record, from which all subsequent records will be based upon.'
        , mtInformation, [mbOK], mbOK, 'Adding Default Record');
        rDefaultRate := 0;
      end else
      begin
        rDefaultRate := PPDefaultCustRec.ppcDefaultRate;
        LPPCustRec := PPDefaultCustRec;
      end;

    end else
    begin
      pRecord := bdsPPCust.GetRecord;
      if pRecord <> nil then LPPCustRec := TPPCustRec(pRecord^);

      bDefault := (LPPCustRec.ppcCustCode = PPDefaultCustRec.ppcCustCode);
      if bDefault then
      begin
        MsgBox('You are about to edit the default Record, which all other records are be based upon.'
        + #13#13 + 'Changes to this record may affect all other records.'
        , mtWarning, [mbOK], mbOK, 'Editing Default Record');
      end;

      rDefaultRate := PPDefaultCustRec.ppcDefaultRate;
    end;{if}

    if ShowModal = mrOK then begin
      if bAdd then
      begin
        // Add
        BTShowError(BTAddRecord(ppFileVar[ppCustF], LPPCustRec, ppBufferSize[ppCustF], ppcCustIdx)
        , 'BTAddRecord', CompanyRec.Path + ppFileName[ppCustF]);
      end else
      begin
        // Edit
        KeyS := PadString(psRight, LPPCustRec.ppcCustCode, ' ', 6);
        iStatus := BTFindRecord(B_GetEq, ppFileVar[ppCustF], PPCustRec, ppBufferSize[ppCustF]
        , ppcCustIdx, KeyS);
        BTShowError(iStatus, 'BTFindRecord', CompanyRec.Path + ppFileName[ppCustF]);
        if iStatus = 0 then begin
          iStatus := BTUpdateRecord(ppFileVar[ppCustF], LPPCustRec, ppBufferSize[ppCustF], ppcCustIdx, KeyS);
          BTShowError(iStatus, 'BTUpdateRecord', CompanyRec.Path + ppFileName[ppCustF]);
        end;{if}
      end;{if}
      mlPPCust.RefreshDB;
    end;{if}
    Release;
  end;{with}
  EnableDisable;
end;

procedure TFrmAdmin.PPCustDAT1Click(Sender: TObject);
var
  KeyS : Tstr255;
  PPCustRec  : TPPCustRec;
  i, iStatus : integer;
  sKey : string;
const
  sFileName = 'PromPay\PPCust.TXT';
begin
  DeleteFile(sFileName);
  FillChar(KeyS, SizeOf(KeyS), #0);
  iStatus := BTFindRecord(B_GetFirst, ppFileVar[ppCustF], PPCustRec, ppBufferSize[ppCustF]
  , TWinControl(Sender).Tag, KeyS);
  while iStatus = 0 do begin
    sKey := '';
    For i := 1 to Length(KeyS) do sKey := sKey + '#'+IntToStr(Ord(KeyS[i]));

    with PPCustRec do begin
      AddLineToFile(KeyS + ' ' + ppcCustCode, sFileName);
    end;{with}

    iStatus := BTFindRecord(B_GetNext, ppFileVar[ppCustF], PPCustRec, ppBufferSize[ppCustF]
    , TWinControl(Sender).Tag, KeyS);
  end;{while}
  ShowMessage('File Export Completed (' + sFileName + ')');
end;

procedure TFrmAdmin.mlPPCustBeforeLoad(Sender: TObject; var Allow: Boolean);
var
  KeyS : TStr255;
  iStatus : integer;
begin
  FillChar(KeyS, SizeOf(KeyS),#0);
  KeyS := PPC_DEFAULT_RECORD;
  iStatus := BTFindRecord(B_GetEq, ppFileVar[ppCustF], PPDefaultCustRec, ppBufferSize[ppCustF], ppcCustIdx, KeyS);
  if iStatus <> 0 then FillChar(PPDefaultCustRec, SizeOf(PPDefaultCustRec),#0);
  iDefRowIndex := -1;
end;

procedure TFrmAdmin.Exit1Click(Sender: TObject);
begin
  Close;
end;

procedure TFrmAdmin.pmMainPopup(Sender: TObject);
begin
  Edit1.Enabled := (mlPPCust.ItemsCount > 0) and (mlPPCust.Selected >= 0);
//  Delete1.Enabled := Edit1.Enabled;

  if Delete1.Enabled  then begin
    if (mlPPCust.ItemsCount = 0) or (mlPPCust.Selected < 0)
    then Delete1.Enabled  := FALSE;
  end;{if}

  Debt1.Enabled := Edit1.Enabled;
  Find1.Enabled := (mlPPCust.ItemsCount > 0);
end;

procedure TFrmAdmin.btnDeleteClick(Sender: TObject);
var
  iStatus : integer;
  KeyS : TStr255;
  pRecord : pointer;
  PPCustRec : TPPCustRec;
  PPDebtRec : TPPDebtRec;
begin
  pRecord := bdsPPCust.GetRecord;
  if TPPCustRec(pRecord^).ppcCustCode <> PPC_DEFAULT_RECORD then begin
    if pRecord <> nil then
    begin
      if MsgBox('Are you sure you want to delete this record ?'
      ,mtConfirmation, [mbYes, mbNo], mbNo, 'Delete Record') = mrYes then
      begin
        // delete debt records
        if UsingSQL then
        begin
          // SQL Only
          repeat
            KeyS := TPPCustRec(pRecord^).ppcCustCode;
            iStatus := BTFindRecord(BT_GetGreater, ppFileVar[ppDebtF], PPDebtRec, ppBufferSize[ppDebtF]
            , ppdValueFrom4SQLIdx, KeyS);
            if (iStatus = 0) and (PPDebtRec.ppdCustCode = TPPCustRec(pRecord^).ppcCustCode)
            then begin
              iStatus := BTDeleteRecord(ppFileVar[ppDebtF], PPDebtRec, ppBufferSize[ppDebtF], ppdValueFrom4SQLIdx);
              BTShowError(iStatus, 'BTDeleteRecord', CompanyRec.Path + ppFileName[ppDebtF]);
            end;{if}
          until (iStatus <> 0) or (PPDebtRec.ppdCustCode <> TPPCustRec(pRecord^).ppcCustCode);
        end
        else
        begin
          // Btrieve Only
          repeat
            KeyS := TPPCustRec(pRecord^).ppcCustCode + BT_MinDoubleKey;
            iStatus := BTFindRecord(BT_GetGreater, ppFileVar[ppDebtF], PPDebtRec, ppBufferSize[ppDebtF]
            , ppdValueFromIdx, KeyS);
            if (iStatus = 0) and (PPDebtRec.ppdCustCode = TPPCustRec(pRecord^).ppcCustCode)
            then begin
              iStatus := BTDeleteRecord(ppFileVar[ppDebtF], PPDebtRec, ppBufferSize[ppDebtF], ppdValueFromIdx);
              BTShowError(iStatus, 'BTDeleteRecord', CompanyRec.Path + ppFileName[ppDebtF]);
            end;{if}
          until (iStatus <> 0) or (PPDebtRec.ppdCustCode <> TPPCustRec(pRecord^).ppcCustCode);
        end;

        // delete main record
        FillChar(KeyS,SizeOf(KeyS),#0);
        KeyS := PadString(psRight, TPPCustRec(pRecord^).ppcCustCode, ' ', 6);
        iStatus := BTFindRecord(B_GetEq, ppFileVar[ppCustF], PPCustRec, ppBufferSize[ppCustF], ppcCustIdx, KeyS);
        if iStatus = 0 then begin
          iStatus := BTDeleteRecord(ppFileVar[ppCustF], PPCustRec, ppBufferSize[ppCustF], ppcCustIdx);
          BTShowError(iStatus, 'BTDeleteRecord', CompanyRec.Path + ppFileName[ppCustF]);
          mlPPCust.RefreshDB;
          EnableDisable;
        end;{if}
      end;{if}
    end;{if}
  end;{if}
end;

procedure TFrmAdmin.Delete1Click(Sender: TObject);
begin
  btnDeleteClick(btnDelete);
end;

procedure TFrmAdmin.mlPPCustCellPaint(Sender: TObject; ColumnIndex,
  RowIndex: Integer; var OwnerText: String; var TextFont: TFont;
  var TextBrush: TBrush; var TextAlign: TAlignment);
begin
  if OwnerText = 'Default' then iDefRowIndex := RowIndex;
  if RowIndex = iDefRowIndex then TextFont.Style := TextFont.Style + [fsBold];
end;

procedure TFrmAdmin.btnFindClick(Sender: TObject);
begin
  pmFind.Popup(Round(Left + btnFind.Left + (btnFind.Width / 2)), Top + Round(btnFind.Top + (btnFind.Height / 2)));
end;

procedure TFrmAdmin.byCustomerCode1Click(Sender: TObject);
var
  sFind : string;
begin
  if InputQuery('Find by Customer Code','Customer Code : ', sFind)
  then FindCustCode(Uppercase(PadString(psRight, sFind, ' ', 6)));
end;

procedure TFrmAdmin.FindCustCode(sCode : string);
var
  PPCustRec : TPPCustRec;
  pRecord : pointer;
begin
  mlPPCust.SearchColumn(0, TRUE, sCode);
  pRecord := bdsPPCust.GetRecord;
  if pRecord <> nil then PPCustRec := TPPCustRec(pRecord^);
  if Trim(PPCustRec.ppcCustCode) <> Trim(sCode)
  then MsgBox('Could not find the required record', mtInformation, [mbOK], mbOK, 'Find Record');
end;

procedure TFrmAdmin.byCustomerName1Click(Sender: TObject);
var
  sFind : string;
begin
  if InputQuery('Find by Customer Name','Customer Name : ', sFind)
  then begin
    oToolkit.Customer.Index := acIdxName;
    oToolkit.Customer.GetGreaterThanOrEqual(oToolkit.Customer.BuildNameIndex(sFind));
    if Uppercase(Copy(oToolkit.Customer.acCompany,1,Length(sFind))) = UpperCase(sFind)
    then FindCustCode(Uppercase(PadString(psRight, oToolkit.Customer.acCode, ' ', 6)))
    else MsgBox('Could not find the required record', mtInformation, [mbOK], mbOK, 'Find Record');
  end;{if}
end;

procedure TFrmAdmin.btnPrintClick(Sender: TObject);
begin
  ModReports.PrintRecords;
end;

procedure TFrmAdmin.btnDebtClick(Sender: TObject);
var
  pRecord : Pointer;
begin
  pRecord := bdsPPCust.GetRecord;
  if pRecord <> nil then begin
    with TfrmDebt.Create(application) do begin
      sCustCode := TPPCustRec(pRecord^).ppcCustCode;

      if sCustCode = PPC_DEFAULT_RECORD then
      begin
        lCustomer.Caption := 'Default Record';
      end else
      begin
        with oToolkit.Customer do begin
          Index := acIdxCode;
          if GetEqual(BuildCodeIndex(sCustCode)) = 0
          then lCustomer.Caption := sCustCode + ' : ' + acCompany;
        end;{with}
      end;{if}

      showmodal;
      Release;
    end;{with}
  end;{if}
end;

procedure TFrmAdmin.Debt1Click(Sender: TObject);
begin
  btnDebtClick(btnDebt);
end;

procedure TFrmAdmin.PPDebtDAT1Click(Sender: TObject);
var
  KeyS : Tstr255;
  PPDebtRec  : TPPDebtRec;
  iStatus : integer;
  sKey : string;
const
  sFileName = 'PromPay\PPDebt.TXT';
begin
  DeleteFile(sFileName);
  FillChar(KeyS, SizeOf(KeyS), #0);
  iStatus := BTFindRecord(B_GetFirst, ppFileVar[ppDebtF], PPDebtRec, ppBufferSize[ppDebtF]
  , TWinControl(Sender).Tag, KeyS);
  while iStatus = 0 do begin
//    sKey := '';
//    For i := 1 to Length(KeyS) do sKey := sKey + '#'+IntToStr(Ord(KeyS[i]));
    sKey := StringToCodes(KeyS);

    with PPDebtRec do begin
      AddLineToFile(sKey, sFileName);
//      AddLineToFile(KeyS + ' ' + ppcDebtCode, sFileName);
    end;{with}

    iStatus := BTFindRecord(B_GetNext, ppFileVar[ppDebtF], PPDebtRec, ppBufferSize[ppDebtF]
    , TWinControl(Sender).Tag, KeyS);
  end;{while}
  ShowMessage('File Export Completed (' + sFileName + ')');
end;

procedure TFrmAdmin.SystemSetup1Click(Sender: TObject);
begin
  with TfrmSystemSetup.Create(application) do begin
    showmodal;
    Release;
  end;{with}
end;

procedure TFrmAdmin.FormResize(Sender: TObject);
begin
  cmbCompany.Width := ClientWidth - 72;

  btnClose.Top := ClientHeight - 29;
  btnClose.Left := ClientWidth - 89;

  btnAdd.Left := btnClose.Left;
  btnEdit.Left := btnClose.Left;
  btnDelete.Left := btnClose.Left;
  btnDebt.Left := btnClose.Left;
  btnFind.Left := btnClose.Left;
  btnPrint.Left := btnClose.Left;

  mlPPCust.Width := ClientWidth - 104;
  mlPPCust.Height := ClientHeight - 48;
end;

end.
