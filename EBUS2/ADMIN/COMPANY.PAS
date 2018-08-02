unit Company;

{ prutherford440 09:44 30/10/2001: Disabled Byte Alignment in Delphi 6.0 }
{$ALIGN 1}  { Variable Alignment Disabled }


interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, TEditVal, Mask, ExtCtrls, SBSPanel, EBusVar, BorBtns,
  ComCtrls, BtSupU1, {DirSel,} EBusCnst, EBusUtil, AdmnUtil,
  EBusBtrv;

type
  TfrmOneCompany = class(TForm)
    btnOK: TButton;
    btnCancel: TButton;
    pgcCompany: TPageControl;
    tabEnterprise: TTabSheet;
    tabXML: TTabSheet;
    cbxCompany: TSBSComboBox;
    Label87: Label8;
    grpDefaults: TSBSGroup;
    Label84: Label8;
    Label85: Label8;
    Label86: Label8;
    edtLocation: Text8Pt;
    edtDept: Text8Pt;
    edtCostCentre: Text8Pt;
    tabDragNet: TTabSheet;
    grpNumbering: TSBSGroup;
    Label82: Label8;
    Label83: Label8;
    edtOrderPrefix: Text8Pt;
    chkUseAsOurRef: TBorCheck;
    edtStartsAt: TMaskEdit;
    chkUseCatalogues: TBorCheck;
    edtDragNetCode: Text8Pt;
    Label81: Label8;
    grpXMLDirs: TGroupBox;
    Label810: Label8;
    Label812: Label8;
    Label88: Label8;
    edtXMLSearchDir: Text8Pt;
    btnArchiveDir: TButton;
    btnSearchDir: TButton;
    edtXMLArchiveDir: Text8Pt;
    btnFailDir: TButton;
    edtXMLFailDir: Text8Pt;
    tabLogs: TTabSheet;
    GroupBox1: TGroupBox;
    Label811: Label8;
    edtImportLogDir: Text8Pt;
    btnImportLogDir: TButton;
    btnPostingLogDir: TButton;
    edtPostLogDir: Text8Pt;
    Label813: Label8;
    grpEmailAccount: TGroupBox;
    Label818: Label8;
    Label89: Label8;
    edtEmailAccount: Text8Pt;
    edtEmailPassword: Text8Pt;
    chkKeepTransNo: TBorCheck;
    Label814: Label8;
    Label815: Label8;
    edtCustomer: Text8Pt;
    edtSupplier: Text8Pt;
    edtSalesNom: Text8Pt;
    Label816: Label8;
    Label817: Label8;
    edtPurchNom: Text8Pt;
    Label819: Label8;
    cbxPeriod: TSBSComboBox;
    pnlPeriodInfo: TPanel;
    edtPeriod: TEditPeriod;
    lblPeriodsPerYear: Label8;
    Label820: Label8;
    grpAdmin: TGroupBox;
    Label821: Label8;
    edtAdminEmail: Text8Pt;
    cbxNotifyAdmin: TSBSComboBox;
    Label822: Label8;
    Label823: Label8;
    cbxVATCodes: TSBSComboBox;
    tabPosting: TTabSheet;
    grpHoldOptions: TGroupBox;
    chkWarningPersists: TBorCheck;
    chkHoldPersists: TBorCheck;
    btnDefaultDirs: TButton;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormDestroy(Sender: TObject);
    procedure btnOKClick(Sender: TObject);
    procedure btnCancelClick(Sender: TObject);
    procedure cbxCompanyChange(Sender: TObject);
    procedure ControlsKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure ControlsKeyPress(Sender: TObject; var Key: Char);
    procedure edtCostCentreExit(Sender: TObject);
    procedure edtLocationExit(Sender: TObject);
    procedure edtDeptExit(Sender: TObject);
    procedure btnSearchClick(Sender: TObject);
    procedure edtCustSuppCodeExit(Sender: TObject);
    procedure edtNomCodeExit(Sender: TObject);
    procedure cbxPeriodChange(Sender: TObject);
    procedure pgcCompanyChange(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure btnDefaultDirsClick(Sender: TObject);
  private
  //  frmDirSel : TfrmDirectorySelect;
    fActivate : TFormActivate;
    fLockPos : longint;
    fBtrieveCompany : TEBusBtrieveCompany;
    fCurCompPath : ansistring;
    Companies : PCompanies;
    NoCompanies : integer;      // Total number of companies within Multi-Company Manager
    OriginalDragNetCode : char;
    function  OKToSave : boolean;
    procedure SetCompanySpecificData;
    procedure SetPeriodsPerYear;
    procedure SetVATCodes;
    procedure PopulateScreen;
    function  PopulateCompanies : integer;
    procedure ActivateFields(CanEdit : boolean);
    procedure PopulateFields;
    function  AllDirsOK : boolean;
    function  NomCodeOK(IsPurchNom : boolean) : boolean;
    procedure SetInitialFieldDefaults;
    procedure DoAfterCompanySelected;
  public
    procedure Display(FormActivate : TFormActivate; Btrieve : TEBusBtrieveCompany;
      LockPos : longint);
    procedure WMCustGetRec(var Message : TMessage); message WM_CustGetRec;
    constructor Create(AOwner: TComponent); override;
end;

var
  frmOneCompany: TfrmOneCompany;

implementation

{$R *.DFM}

uses
  UseDLLU, GlobVar, BtrvU2, ColCtrlU, EntUtil, BTSupU2,
  FileCtrl, StrUtil, UseTKit{, XMLConst, EBusMain};

const
  SEARCH_DIR = 1;
  ARCHIVE_DIR = 2;
  FAIL_DIR = 3;
  LOG_DIR = 4;
  POST_DIR = 5;

//-----------------------------------------------------------------------

procedure TfrmOneCompany.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Action := caFree;
  if fActivate = actEdit then
    fBtrieveCompany.UnlockRecord(fLockPos);
  SendMessage((Owner as TForm).Handle, WM_CustGetRec, EBUS_FORM_CLOSE, 0);
(*  Ex_CloseData;
  SetToolkitPath(EBusParams.CurCompPath);
  Ex_InitDLL; *)
end;

//-----------------------------------------------------------------------

procedure TfrmOneCompany.FormDestroy(Sender: TObject);
begin
  dispose(Companies);
end;

//-----------------------------------------------------------------------

function TfrmOneCompany.OKToSave : boolean;
var
  Msg : string;

  function DragNetCodeInUse(SelectedDragNetCode : char) : boolean;
  var
    Status : integer;
    KeyS : str255;
  begin
    Result := false;
    if (fActivate = actEdit) and (SelectedDragNetCode = OriginalDragNetCode) then exit;

    with TEBusBtrieveDragNetCompany.Create(true) do
    try
      if OpenFile = 0 then
      begin
        Status := FindRecord(B_GetFirst);
        while (Status = 0) and not Result do
        begin
          Result := SelectedDragNetCode = DragNetCompanySettings.DNetCompanyCode;
          Status := FindRecord(B_GetNext);
        end;
        CloseFile;
      end;
    finally
      Free;
    end;
  end; // DragNetCodeInUse

begin // TfrmOneCompany.OKToSave
  Result := true;

  if (fActivate = actAdd) and (cbxCompany.ItemIndex = -1) then
  begin
    Msg := 'You must select a company';
    Result := false;
  end;

  if ThirdPartyAvailable(tptDragNet) then
  begin
    if Result and (Trim(edtDragNetCode.Text) = '') then
    begin
      Msg := 'You must supply a Dr@gNet code';
      Result := false;
    end;

    if Result and (DragNetCodeInUse(edtDragNetCode.Text[1])) then
    begin
      Msg := 'This Dr@gNet code is already in use.';
      Result := false;
    end;
  end;

  if not Result then
   MessageDlg(Msg, mtWarning, [mbOK], 0);

  if Result then
    Result := NomCodeOK(true);

  if Result then
    Result := NomCodeOK(false);

  if Result then
    Result := AllDirsOK;

  if ThirdPartyAvailable(tptDragNet) then
    if Result and (chkUseAsOurRef.Checked) and
      (Trim(UpperCase(edtOrderPrefix.Text)) <> 'SOR') then
      if MessageDlg('To use an external transaction number as an Our Ref the prefix must be ''SOR''' +
       #13#10 + 'Do you wish to change?', mtWarning, [mbYes, mbNo], 0) = mrYes then
         edtOrderPrefix.Text := 'SOR'
       else
         Result := false;
end; // TfrmOneCompany.OKToSave

//-----------------------------------------------------------------------

procedure TfrmOneCompany.btnOKClick(Sender: TObject);
var
  Status : integer;
  DragNetDetails : TEBusDragNetCompany;
begin
  if (fActivate in [actAdd, actEdit]) and OKToSave then
  begin
    with fBtrieveCompany do
    begin
      PopulateFields(@DragNetDetails);
      with cbxCompany do
        if ItemIndex = -1 then
          CompanyCode := Text
        else
          CompanyCode := copy(cbxCompany.Items[cbxCompany.ItemIndex], 1, 6);

      if fActivate = actAdd then
        Status := AddRecord
      else
        Status := UpdateRecord;
      if Status <> 0 then
        MessageDlg(Format('Could not save company details. Status = %d', [Status]),
          mtError, [mbOK], 0)
      else
        // Update the combo box on the main Toolbar
        // frmEBusinessMain.PopulateCompanyList;
    end;
    SendMessage((Owner as TForm).Handle, WM_CustGetRec, 200, 0);
    Close;
  end;
  
  if fActivate = actShow then
    Close;
end; // TfrmOneCompany.btnOKClick

//-----------------------------------------------------------------------

procedure TfrmOneCompany.btnCancelClick(Sender: TObject);
begin
  Close;
end;

//-----------------------------------------------------------------------

procedure TfrmOneCompany.SetInitialFieldDefaults;
begin
  if cbxPeriod.ItemIndex = -1 then
    cbxPeriod.ItemIndex := 0;
  if cbxVATCodes.ItemIndex = -1 then
    cbxVATCodes.ItemIndex := 0;
end;

//-----------------------------------------------------------------------

procedure TfrmOneCompany.DoAfterCompanySelected;
begin
  with cbxCompany do
    if (ItemIndex <> -1) and (fActivate = actAdd) then
    begin
      ActivateFields(true);
      fCurCompPath := GetCompanyPath(copy(cbxCompany.Items[cbxCompany.ItemIndex], 1, 6),
        Companies);
      SetCompanySpecificData;
      SetInitialFieldDefaults;
    end;
end;

//-----------------------------------------------------------------------

procedure TfrmOneCompany.ActivateFields(CanEdit : boolean);
var
  i : integer;
begin
  for i := 0 to ComponentCount - 1 do
  begin
    if (Components[i] is TSBSComboBox) then
      (Components[i] as TSBSComboBox).ReadOnly := not CanEdit;
    if (Components[i] is TMaskEdit) then
      (Components[i] as TMaskEdit).ReadOnly := not CanEdit;
    if (Components[i] is TButton) and (Components[i] <> btnOK) and
      (Components[i] <> btnCancel) then
      (Components[i] as TButton).Enabled := CanEdit;
    if (Components[i] is TBorCheck) then
      (Components[i] as TBorCheck).Enabled := CanEdit;
  end;
end; // TfrmOneCompany.ActivateFields

//-----------------------------------------------------------------------

procedure TfrmOneCompany.SetCompanySpecificData;
var
  Status : integer;
begin
(*
  Status := Ex_CloseData;
  Status := SetToolkitPath(fCurCompPath);
  Status := Ex_InitDLL;
*)
  SetPeriodsPerYear;
  SetVATCodes;
end;

//-----------------------------------------------------------------------

procedure TfrmOneCompany.SetPeriodsPerYear;
var
  CompParams : ^TBatchSysRec;
begin
  new(CompParams);
  Status := Ex_GetSysData(CompParams, SizeOf(CompParams^));
  lblPeriodsPerYear.Caption := Format('(%d per yr)', [CompParams^.PeriodsPerYr]);
  dispose(CompParams);
end;

//-----------------------------------------------------------------------

procedure TfrmOneCompany.SetVATCodes;
var
  i : byte;
  VATRec : ^TBatchVATRec;
  Status : integer;
begin
  new(VATRec);
  for i := Low(VAT_CODES) to High(VAT_CODES) do
  begin
    VATRec^.VATCode := VAT_CODES[i];
    Status := Ex_GetVATRate(VATRec, SizeOf(VATRec^));
    if Status = 0 then
      cbxVATCodes.Items.AddObject(Format('%s - %s', [VATRec^.VATCode, VATRec^.VATDesc]),
        TObject(VATRec^.VATCode));
  end;
  dispose(VATRec); 
end;

//-----------------------------------------------------------------------

procedure TfrmOneCompany.Display(FormActivate : TFormActivate;
            Btrieve : TEBusBtrieveCompany; LockPos : longint);
begin
  fActivate := FormActivate;
  fLockPos := LockPos;
  fBtrieveCompany := Btrieve;

  case fActivate of
    actShow :
      begin
        ActivateFields(false);
        PopulateScreen;
      end; // actShow
     actEdit :
       begin
         Caption := Caption + ' - Edit record';
//         fCurCompPath := Trim(GetCompanyPath(EBusRec.EBusCode1, Companies));
         SetCompanySpecificData;
         PopulateScreen;
         cbxCompany.ReadOnly := true;
       end;
     actAdd :
       begin
         if PopulateCompanies > 0 then
         begin
           ActivateFields(false);
           cbxCompany.ReadOnly := false;
           Caption := Caption + ' - Add record';
         end;
       end;
  end; // case
  Show;
end; // TfrmOneCompany.Display

//-----------------------------------------------------------------------

function TfrmOneCompany.PopulateCompanies : integer;
// Action : Fills Companies array and populates Company combo box with companies that are
//          available to add
// Post   : Returns number of companies added to list box
var
  i : longint;
begin
  for i := 1 to NoCompanies do
    with cbxCompany, Companies^[i] do
      if not CompanyBeenSetUp(CompCode) then
        Items.Add(CompCode + ' - ' + CompName);

  Result := cbxCompany.Items.Count; 
end; // TfrmOneCompany.PopulateCompanies

//-----------------------------------------------------------------------

procedure TfrmOneCompany.PopulateScreen;

  function GetVATIndex(VATCode : char) : integer;
  var
    i : integer;
  begin
    Result := -1;
(*    for i := Low(VAT_CODES) to High(VAT_CODES) do
      if VATCode = VAT_CODES[i] then
        Result := i; *)
  end;

begin
  with fBtrieveCompany, CompanySettings do
  begin
    cbxCompany.Text := CompanyCode;
    edtCostCentre.Text := CompDefCostCentre;
    edtDept.Text := CompDefDept;
    edtLocation.Text := CompDefLocation;
    edtCustomer.Text := CompDefCustomer;
    edtSupplier.Text := CompDefSupplier;
    edtSalesNom.Text := IntToStr(CompDefPurchNom);
    edtPurchNom.Text := IntToStr(CompDefSalesNom);
    cbxPeriod.ItemIndex := CompSetPeriodMethod;
    pnlPeriodInfo.Visible := CompSetPeriodMethod = 2;
    edtPeriod.EPeriod := CompPeriod;
    edtPeriod.EYear := CompYear;
    cbxVATCodes.ItemIndex := GetVATIndex(CompDefVATCode);
//    edtEmailAccount.Text := EntCompXMLEmailUserName;
//    edtEmailPassword.Text := EntCompXMLEmailPassword;
//    edtImportLogDir.Text := EntImportLogDir;
//    edtPostLogDir.Text := EntPostingLogDir;
//    chkKeepTransNo.Checked := EntKeepTransNo > 0;
    chkHoldPersists.Checked := CompPostHoldFlag and POST_HOLD_HOLD = POST_HOLD_HOLD;
    chkWarningPersists.Checked := CompPostHoldFlag and POST_HOLD_WARN = POST_HOLD_WARN;
  end;
end; // TfrmDragNetOneCompany.PopulateScreen

//-----------------------------------------------------------------------

procedure TfrmOneCompany.PopulateFields;

  function SafeGetItemIndex(ComboBox : TComboBox) : integer;
  begin
    if ComboBox.ItemIndex = -1 then
      Result := 0
    else
      Result := ComboBox.ItemIndex;
  end;

begin
  with fBtrieveCompany, CompanySettings do
  begin
    // BlankRecord ???
 //   DNetCompanyCode := edtDragnetCode.Text[1];
 //   DNetOrderPrefix := edtOrderPrefix.Text;
 {   try
      DNetOrderNoStart := StrToInt(edtStartsAt.Text);
    except
      on EConvertError do
        DNetOrderNoStart := 1;
    end; }
  //  DNetUseExternalRef := chkUseAsOurRef.Checked;
  //  DNetUseCatalogues := chkUseCatalogues.Checked;
    CompDefCostCentre := edtCostCentre.Text;
    CompDefDept := edtDept.Text;
    CompDefLocation := edtLocation.Text;
    CompDefCustomer := edtCustomer.Text;
    CompDefSupplier := edtSupplier.Text;
    CompDefVATCode := char(cbxVATCodes.Items.Objects[SafeGetItemIndex(cbxVATCodes)]);
    CompDefPurchNom := StrToInt(edtSalesNom.Text);
    CompDefSalesNom := StrToInt(edtPurchNom.Text);
//    CompXMLSearchDir := edtXMLSearchDir.Text;
    CompSetPeriodMethod := SafeGetItemIndex(cbxPeriod);
    CompPeriod := edtPeriod.EPeriod;
//    CompNotifyAdmin := SafeGetItemIndex(cbxNotifyAdmin);
//    CompAdminEmail := edtAdminEmail.Text;
    CompYear := edtPeriod.EYear;
//    CompXMLArchiveDir := edtXMLArchiveDir.Text;
//    CompXMLFailDir := edtXMLFailDir.Text;
//    CompXMLEmailUserName := edtEmailAccount.Text;
//    CompXMLEmailPassword := edtEmailPassword.Text;
//    ImportLogDir := edtImportLogDir.Text;
//    PostingLogDir := edtPostLogDir.Text;
    if chkKeepTransNo.Checked then
      CompKeepTransNo := 1
    else
      CompKeepTransNo := 0; 
    if chkHoldPersists.Checked then
      CompPostHoldFlag := CompPostHoldFlag or POST_HOLD_HOLD;
    if chkWarningPersists.Checked then
      CompPostHoldFlag := CompPostHoldFlag or POST_HOLD_WARN;
  end; // with      *)
end; // TfrmDragNetOneCompany.PopulateFields

//-----------------------------------------------------------------------

procedure TfrmOneCompany.cbxCompanyChange(Sender: TObject);
begin
  edtCostCentre.Text := '';
  edtDept.Text := '';
  edtLocation.Text := '';
  edtCustomer.Text := '';
  edtSupplier.Text := '';
  edtSalesNom.Text := '';
  edtPurchNom.Text := '';
  DoAfterCompanySelected;
end;

//-----------------------------------------------------------------------

procedure TfrmOneCompany.ControlsKeyDown(Sender: TObject;
  var Key: Word; Shift: TShiftState);
begin
//  GlobFormKeyDown(Sender, Key, Shift, Sender as TWinControl, Self.Handle);
  GlobFormKeyDown(Sender, Key, Shift, ActiveControl, Handle);
end;

//-----------------------------------------------------------------------

procedure TfrmOneCompany.ControlsKeyPress(Sender: TObject; var Key: Char);
begin
  GlobFormKeyPress(Sender, Key, ActiveControl, Handle);
  // GlobFormKeyPress(Sender, Key, Sender as TWinControl);
end;

//-----------------------------------------------------------------------

procedure TfrmOneCompany.edtCostCentreExit(Sender: TObject);
var
  CCCode : str20;
begin
  if ActiveControl <> btnCancel then
  begin
    CCCode := Trim(edtCostCentre.Text);
    if SelectCCDep(self, fCurCompPath, CCCode, CCCode, true) = 0 then
      edtCostCentre.Text := CCCode;
  end;
end; // TfrmOneCompany.edtCostCentreExit

//-----------------------------------------------------------------------

procedure TfrmOneCompany.edtDeptExit(Sender: TObject);
var
  DepCode : str20;
begin
  if ActiveControl <> btnCancel then
  begin
    DepCode := Trim(edtDept.Text);
    if SelectCCDep(self, fCurCompPath, DepCode, DepCode, false) = 0 then
      edtDept.Text := DepCode;
  end;
end; // TfrmOneCompany.edtDeptExit

//-----------------------------------------------------------------------

procedure TfrmOneCompany.edtLocationExit(Sender: TObject);
var
  LocCode : str10;
begin
  if ActiveControl <> btnCancel then
  begin
    LocCode := Trim(edtLocation.Text);
    if SelectMultiLoc(self, fCurCompPath, LocCode, LocCode) = 0 then
      edtLocation.Text := LocCode;
  end;      
end;

//-----------------------------------------------------------------------

procedure TfrmOneCompany.edtCustSuppCodeExit(Sender: TObject);
var
  CustSuppCode : str20;
  IsCust : boolean;
begin
  if ActiveControl <> btnCancel then
  begin
    if Sender = edtCustomer then
    begin
      CustSuppCode := Trim(edtCustomer.Text);
      IsCust := true;
    end
    else
    begin
      CustSuppCode := Trim(edtSupplier.Text);
      IsCust := false;
    end;

    if SelectCustSuppCode(self, fCurCompPath, CustSuppCode, CustSuppCode, IsCust) = 0 then
      if Sender = edtCustomer then
        edtCustomer.Text := CustSuppCode
      else
        edtSupplier.Text := CustSuppCode;
  end;
end;

//-----------------------------------------------------------------------

procedure TfrmOneCompany.edtNomCodeExit(Sender: TObject);
var
  NomCode : str20;
  intNomCode : longint;
begin
  if ActiveControl <> btnCancel then
  begin
    NomCode := Trim((Sender as Text8Pt).Text);

    if SelectNomCode(self, fCurCompPath, NomCode, intNomCode) = 0 then
      if Sender = edtPurchNom then
        edtPurchNom.Text := IntToStr(intNomCode)
      else
        edtSalesNom.Text := IntToStr(intNomCode);
  end;
end;         

//-----------------------------------------------------------------------

procedure TfrmOneCompany.btnSearchClick(Sender: TObject);
begin
(*
  // Ensure only one instance of the directory selection form
  if not Assigned(frmDirSel) then
  begin
    frmDirSel := TfrmDirectorySelect.Create(self);
    with frmDirSel do
    begin
      if Sender = btnSearchDir then
      begin
        DirTag := SEARCH_DIR;
        Caption := 'Choose XML search directory ...';
        if not Blank(edtXMLSearchDir.Text) and (DirectoryExists(edtXMLSearchDir.Text)) then
          lstDirectories.Directory := edtXMLSearchDir.Text
      end;

      if Sender = btnArchiveDir then
      begin
        DirTag := ARCHIVE_DIR;
        Caption := 'Choose XML archive directory ...';
        if not Blank(edtXMLArchiveDir.Text) and (DirectoryExists(edtXMLArchiveDir.Text)) then
          lstDirectories.Directory := edtXMLArchiveDir.Text;
      end;

      if Sender = btnFailDir then
      begin
        DirTag := FAIL_DIR;
        Caption := 'Choose XML fail directory ...';
        if not Blank(edtXMLFailDir.Text) and (DirectoryExists(edtXMLFailDir.Text)) then
          lstDirectories.Directory := edtXMLFailDir.Text;
      end;

      if Sender = btnImportLogDir then
      begin
        DirTag := LOG_DIR;
        Caption := 'Choose Import log directory ...';
        if not Blank(edtImportLogDir.Text) and (DirectoryExists(edtImportLogDir.Text)) then
          lstDirectories.Directory := edtImportLogDir.Text;
      end;

      if Sender = btnPostingLogDir then
      begin
        DirTag := POST_DIR;
        Caption := 'Choose Posting log directory ...';
        if not Blank(edtPostLogDir.Text) and (DirectoryExists(edtPostLogDir.Text)) then
          lstDirectories.Directory := edtPostLogDir.Text;
      end;

      Show;
    end; // with
  end; // one form instance only *)
end; // TfrmOneCompany.btnSearchClick

//-----------------------------------------------------------------------

procedure TfrmOneCompany.WMCustGetRec(var Message : TMessage);
begin                      (*
  if Message.WParam = EBUS_FORM_CLOSE then
  begin
    case Message.LParam of
      SEARCH_DIR  : edtXMLSearchDir.Text := frmDirSel.lstDirectories.Directory;
      ARCHIVE_DIR : edtXMLArchiveDir.Text := frmDirSel.lstDirectories.Directory;
      FAIL_DIR    : edtXMLFailDir.Text := frmDirSel.lstDirectories.Directory;
      LOG_DIR     : edtImportLogDir.Text := frmDirSel.lstDirectories.Directory;
      POST_DIR    : edtPostLogDir.Text := frmDirSel.lstDirectories.Directory;
    end; // case
    frmDirSel.Release;
    frmDirSel := nil;
  end;                       *)
end; // TfrmOneCompany.WMCustGetRec

//-----------------------------------------------------------------------

function TfrmOneCompany.AllDirsOK : boolean;
begin                          (*
  Result := true;

  if not (Blank(edtXMLSearchDir.Text) or DirectoryExists(edtXMLSearchDir.Text)) then
  begin
    MessageDlg('Invalid XML search directory', mtWarning, [mbOK], 0);
    Result := false;
  end;

  if not (Blank(edtXMLArchiveDir.Text) or DirectoryExists(edtXMLArchiveDir.Text)) then
  begin
    MessageDlg('Invalid XML archive directory', mtWarning, [mbOK], 0);
    Result := false;
  end;

  if not (Blank(edtXMLFailDir.Text) or DirectoryExists(edtXMLFailDir.Text)) then
  begin
    MessageDlg('Invalid XML fail directory', mtWarning, [mbOK], 0);
    Result := false;
  end;

  if not (Blank(edtImportLogDir.Text) or DirectoryExists(edtImportLogDir.Text)) then
  begin
    MessageDlg('Invalid import log directory', mtWarning, [mbOK], 0);
    Result := false;
  end;

  if not (Blank(edtPostLogDir.Text) or DirectoryExists(edtPostLogDir.Text)) then
  begin
    MessageDlg('Invalid Posting log directory', mtWarning, [mbOK], 0);
    Result := false;
  end;                           *)
end; // TfrmOneCompany.ExportDirectoryOK : boolean;

//-----------------------------------------------------------------------

function TfrmOneCompany.NomCodeOK(IsPurchNom : boolean) : boolean;
var
 NomCode : string;
begin
  if IsPurchNom then
    NomCode := edtPurchNom.Text
  else
    NomCode := edtSalesNom.Text;

  try
    StrToInt(NomCode);
    Result := true;
  except
    on EConvertError do
    begin
      if IsPurchNom then
        MessageDlg('Invalid Purchase Nominal Code', mtWarning, [mbOK], 0)
      else
        MessageDlg('Invalid Sales Nominal Code', mtWarning, [mbOK], 0);
      Result := false;
    end;
  end;
end;

//-----------------------------------------------------------------------

constructor TfrmOneCompany.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  if not ThirdPartyAvailable(tptDragNet) then
    tabDragNet.TabVisible := false;
end;

//-----------------------------------------------------------------------

procedure TfrmOneCompany.cbxPeriodChange(Sender: TObject);
begin
  pnlPeriodInfo.Visible := cbxPeriod.ItemIndex = 2;
end;

//-----------------------------------------------------------------------

procedure TfrmOneCompany.pgcCompanyChange(Sender: TObject);
begin
  case pgcCompany.ActivePageIndex of
    0: ClientHeight := 233;
    1: ClientHeight := 299;
    2: ClientHeight := 160;
    3: ClientHeight := 118;
    4: ClientHeight := 118;
  end;
end;

//-----------------------------------------------------------------------

procedure TfrmOneCompany.FormCreate(Sender: TObject);
begin
  pgcCompany.ActivePage := tabEnterprise;
  pgcCompanyChange(self);

  new(Companies);
  Status := InitialiseCompaniesRec(Companies, NoCompanies, true);
end;

//-----------------------------------------------------------------------

function MakeDirectoryPath(const Path : string; SubDirs : array of string) : string;
// Pre  : Root = path to the root directory
//        SubDirs = sub directories from the root in order
// Post : Returns Path:\SubDir[0]\SubDir[1]\SubDir[2] etc.
var
  i : integer;
begin                     (*
  Result := Path;
  for i := 0 to Length(SubDirs) -1 do
    Result := AddBackSlash(Result) + SubDirs[i]; *)
end;

procedure TfrmOneCompany.btnDefaultDirsClick(Sender: TObject);
var
  XMLSearchDir,
  XMLArchiveDir,
  XMLFailDir,
  LogImportDir,
  LogPostDir    : string;
begin    (*
  if MessageDlg('Do you wish to create and assign default directories for XML and log files?',
    mtConfirmation, [mbYes, mbNo], 0) = mrYes then
  begin
    XMLSearchDir := MakeDirectoryPath(fCurCompPath, [EBUS_DIR, EBUS_XML_DIR, XML_SEARCH_DIR]);
    XMLArchiveDir := MakeDirectoryPath(fCurCompPath, [EBUS_DIR, EBUS_XML_DIR,  XML_ARCHIVE_DIR]);
    XMLFailDir := MakeDirectoryPath(fCurCompPath, [EBUS_DIR, EBUS_XML_DIR, XML_FAIL_DIR]);
    LogImportDir := MakeDirectoryPath(fCurCompPath, [EBUS_DIR, EBUS_LOGS_DIR, LOG_DIR_POSTED]);
    LogPostDir := MakeDirectoryPath(fCurCompPath, [EBUS_DIR, EBUS_LOGS_DIR, LOG_DIR_IMPORT]);

    if MessageDlg('The following directories will be created (if necessary) and assigned.' + CRLF +
      'XML Search directory : ' + XMLSearchDir + CRLF +
      'XML Archive directory : ' + XMLArchiveDir + CRLF +
      'XML Fail directory : ' + XMLFailDir + CRLF +
      'Import logs directory : ' + LogImportDir + CRLF +
      'Posting logs directory : ' + LogPostDir,
        mtConfirmation, [mbOK, mbCancel], 0) = mrOK then
      begin
        if ForceDirectories(XMLSearchDir) then
          edtXMLSearchDir.Text := XMLSearchDir;
        if ForceDirectories(XMLArchiveDir) then
          edtXMLArchiveDir.Text := XMLArchiveDir;
        if ForceDirectories(XMLFailDir) then
          edtXMLFailDir.Text := XMLFailDir;
        if ForceDirectories(LogImportDir) then
          edtImportLogDir.Text := LogImportDir;
        if ForceDirectories(LogPostDir) then
          edtPostLogDir.Text := LogPostDir;
       end;
  end; *)
end;

//-----------------------------------------------------------------------

end.
