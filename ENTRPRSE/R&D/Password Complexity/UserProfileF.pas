unit UserProfileF;

interface

{$I DEFOVR.Inc}

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, AdvToolBar, AdvToolBarStylers, Menus, StdCtrls, SBSPanel, ExtCtrls,
  AdvGlowButton, Grids, SBSOutl, BorBtns, TEditVal, Mask, bkgroup, ComCtrls,
  CheckBoxEx,GlobVar, VarConst, UA_Const, oUserIntf, PWarnU, VarRec2U, ETDateU,
  PasswordComplexityConst, InvListU, ExWrap1U, EnterToTab, BtSupu2, oSystemSetup;

type
  TfrmUserProfile = class(TForm)
    PageControl1: TPageControl;
    tabUserProfile: TTabSheet;
    tabAccessSettings: TTabSheet;
    tabSignatures: TTabSheet;
    PopupMenu1: TPopupMenu;
    mnuInteractive: TMenuItem;
    mnuFind: TMenuItem;
    mnuExpandLevel: TMenuItem;
    mnuCollapseLevel: TMenuItem;
    mnuSetYes: TMenuItem;
    mnuSetNo: TMenuItem;
    AdvToolBarOfficeStyler1: TAdvToolBarOfficeStyler;
    NLOLine: TSBSOutlineB;
    AdvToolBar1: TAdvToolBar;
    FullExBtn: TAdvGlowButton;
    FullColBtn: TAdvGlowButton;
    pnlProfileCont: TPanel;
    pnlMainStatus: TPanel;
    lblUserName: Label8;
    lblFullName: Label8;
    lblUserWinID: Label8;
    lblUserEmail: Label8;
    lblDomain: Label8;
    lblUserStatus: Label8;
    edtUserName: Text8Pt;
    edtUserFullName: Text8Pt;
    edtWinUserID: Text8Pt;
    edtUserEmail: Text8Pt;
    cboUserStatus: TSBSComboBox;
    pnlSecurityCont: TPanel;
    pnlPwdExp: TPanel;
    lblDays: Label8;
    lblPwdExp: Label8;
    edtPwdExpDate: TEditDate;
    cboPasswordExpiry: TSBSComboBox;
    edtPwdExpDays: TCurrencyEdit;
    pnlSecurityQuestion: TPanel;
    lblSecQuestion: Label8;
    lblSecAnswer: Label8;
    cboSecurityQuestion: TSBSComboBox;
    edtSecurityAnswer: Text8Pt;
    lblSecurityHeading: TLabel;
    bvlSecurity: TBevel;
    tabUserDefaults: TTabSheet;
    pnlDefaultsCont: TPanel;
    pnlTraders: TPanel;
    lblCustSRICap: Label8;
    lblSuppPPICap: Label8;
    lblTraders: TLabel;
    bvlTraders: TBevel;
    lblCustSRI: Label8;
    lblSuppPPI: Label8;
    txtCustomerList: Text8Pt;
    txtSupplierList: Text8Pt;
    pnlAuthorisation: TPanel;
    lblMaxSales: Label8;
    lblMaxPurch: Label8;
    lblAuthLevel: TLabel;
    bvlAuthLevel: TBevel;
    edtMaxSales: TCurrencyEdit;
    edtMaxPurch: TCurrencyEdit;
    pnlBankGLCode: TPanel;
    lblSales: Label8;
    lblPurch: Label8;
    lblBankGL: TLabel;
    bvlBankGL: TBevel;
    lblSalesGL: Label8;
    lblPurchGL: Label8;
    edtBankGLSales: Text8Pt;
    edtBankGLPurch: Text8Pt;
    pnlCCDept: TPanel;
    lblCCDef: Label8;
    lblCCDepRules: Label8;
    lblCCDepSec: TLabel;
    bvlCCDepSec: TBevel;
    lblDepDef: Label8;
    lblCCDec: Label8;
    lblDepDes: Label8;
    txtDefaultCC: Text8Pt;
    txtDefaultDept: Text8Pt;
    cboSelRuleCCDept: TSBSComboBox;
    pnlLocations: TPanel;
    lblDefLocation: Label8;
    lblLocRules: Label8;
    lblLocationSec: TLabel;
    bvlLocationSec: TBevel;
    lblLocationDes: Label8;
    txtDefaultLoc: Text8Pt;
    cboSelRuleLoc: TSBSComboBox;
    pnlUserPref: TPanel;
    pnlPrinter: TPanel;
    lblReportPrinter: Label8;
    lblFormPrinter: Label8;
    cboReportPrinter: TSBSComboBox;
    cboFormPrinter: TSBSComboBox;
    pnlGLTree: TPanel;
    chkShowGLCode: TCheckBoxEx;
    pnlStockTree: TPanel;
    chkShowStockCodes: TCheckBoxEx;
    chkShowProdTypes: TCheckBoxEx;
    pnlUserPrefHeading: TPanel;
    lblTaxCodeTitle: TLabel;
    bvlUserPref: TBevel;
    pnlRandomPwd: TPanel;
    lblPwd: Label8;
    rbGenRandom: TRadioButton;
    rbGenManual: TRadioButton;
    pnlAutoLock: TPanel;
    lblAfter: Label8;
    lblMinInactivity: Label8;
    edtPwdInactiveTime: TCurrencyEdit;
    udUserInactivityDuration: TUpDown;
    pnlButton: TPanel;
    btnOK: TButton;
    btnCancel: TButton;
    pnlAccessSettingBtn: TPanel;
    btnInteractive: TButton;
    btnExpandlevel: TButton;
    btnCollapsLevel: TButton;
    btnSetLevelYes: TButton;
    btnSetLevelNo: TButton;
    btnFind: TButton;
    pnlMainSig: TPanel;
    pnlRightSig: TPanel;
    pnlEmailSig: TPanel;
    pnlFaxSig: TPanel;
    pnlFaxSigCaption: TPanel;
    lblFaxSignature: TLabel;
    bvlFaxSignature: TBevel;
    pnlEmailSigCaption: TPanel;
    lblEmailSignature: TLabel;
    bvlEmailSig: TBevel;
    memFaxSig: TMemo;
    memEmailSig: TMemo;
    pnlRightAccessSettings: TPanel;
    pnlMainAccessSettings: TPanel;
    pnlImageHolder: TPanel;
    Image5: TImage;
    Label826: Label8;
    pnlAdvToolBar: TPanel;
    N1: TMenuItem;
    N2: TMenuItem;
    Label81: Label8;
    pnlGDPR: TPanel;
    chkHighlightPIIFields: TCheckBoxEx;
    btnEditColour: TButton;
    spGDPR: TShape;
    ColorDialog: TColorDialog;
    chkAutoLock: TCheckBoxEx;
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormResize(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure btnCancelClick(Sender: TObject);
    procedure txtCustomerListExit(Sender: TObject);
    procedure edtBankGLSalesExit(Sender: TObject);
    procedure txtDefaultCCExit(Sender: TObject);
    procedure txtDefaultLocExit(Sender: TObject);
    procedure PageControl1Change(Sender: TObject);
    procedure cboPasswordExpiryChange(Sender: TObject);
    procedure btnOKClick(Sender: TObject);
    //Valiation Field
    procedure edtUserNameExit(Sender: TObject);
    procedure edtUserEmailExit(Sender: TObject);
    procedure edtPwdExpDaysExit(Sender: TObject);
    procedure edtWinUserIDExit(Sender: TObject);
    procedure edtSecurityAnswerExit(Sender: TObject);
    procedure chkAutoLockClick(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure FormKeyPress(Sender: TObject; var Key: Char);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    //User Profile - Access Settings Tab
    procedure NLOLineExpand(Sender: TObject; Index: Integer);
    procedure NLOLineUpdateNode(Sender: TObject; var Node: TSBSOutLNode; Row: Integer);
    procedure NLOLineNodeChkHotSpot(Sender: TObject; var Node: TSBSOutLNode; Row: Integer);
    procedure btnSetLevelYesClick(Sender: TObject);
    procedure btnSetLevelNoClick(Sender: TObject);
    procedure btnExpandlevelClick(Sender: TObject);
    procedure btnCollapsLevelClick(Sender: TObject);
    procedure btnInteractiveClick(Sender: TObject);
    procedure btnFindClick(Sender: TObject);
    procedure FullExBtnClick(Sender: TObject);
    procedure FullColBtnClick(Sender: TObject);
    procedure edtPwdInactiveTimeExit(Sender: TObject);
    procedure edtPwdExpDateExit(Sender: TObject);
    procedure btnEditColourClick(Sender: TObject);
    procedure chkHighlightPIIFieldsClick(Sender: TObject);
  private
    { Private declarations }
    ExLocal: TdExlocal;
    FIsAdminUser: Boolean;
    FAuthenticationMode: String;
    FUserActionMode: TUserObjectMode;
    FUserDetailsIntf: IUserDetails;
    FXYDifference:  Array[0..1] of TPoint;
    FIsResizingON: Boolean;
    FInAddEdit: Boolean;
    FFiles: array [1..2] of String; //Array for storing Signature filename
    FEntryRec: EntryRecType; //User Profile - Access Settings Tab
    FCurrent_User,
    FLastFind: String;
    PWTreeGrpAry: tPWTreeGrpAry;
    FInterMode,
    FModifiedAccessSettings: Boolean;
    procedure Init;
    procedure SetPanelSize(aPanel: TPanel);
    procedure SetFormSize;
    procedure SetCaption;
    procedure InitProfileTab;
    procedure InitDefaultTab;
    procedure InitAccessSettingTab;
    procedure InitSignatureTab;
    function ConfirmQuit: Boolean;
    function CheckNeedStore: Boolean;
    procedure LoadSecurityQuestion;
    // Signature related methods
    procedure StoreSignature;
    procedure PopulateSign(const AIdx: Byte; AFileName1, AFileName2: ShortString; AMemo: TMemo);
    // Populate the fields on the window from FUserDetailsIntf
    procedure DisplayFields;
    procedure StoreUserDetail;
    //User Profile - Access Settings Tab
    function AddTreeNode(AParentIdx: LongInt;
                         ALineText: String;
                         AGrpAry, ALevel: LongInt;
                         APWNo: SmallInt;
                         AMode: Byte): Integer;
    procedure BuildTreeGroups(var AGrpAry: LongInt;
                                  AParentIdx: LongInt;
                                  ALevel: LongInt);
    procedure GetMoreLinks(AIndex: Integer);
    procedure UpdateArrayPosition(AIndex, AMode: Integer);
    procedure OpenThisNode(AIndex, AMode: Integer);
    procedure SetThisNode(AIndex, AMode, ALevel: Integer);
    Procedure Send_UpdateList(AMode: Integer);
  public
    { Public declarations }
    constructor Create(AOwner: TComponent;
                       const AMode: TUserObjectMode;
                       AUserDetailsIntf: IUserDetails;
                       APermission: Boolean = False); Reintroduce;
  end;

implementation

{$R *.dfm}

uses BtrvU2, {$IFDEF FRM} PrintFrm, RpDevice, {$ENDIF} ETStrU, ComnUnit,
     PasswordUtil, BtKeys1U, ChangePasswordF, oUserDetail, Sysu2, Btsupu1;

//------------------------------------------------------------------------------

procedure TfrmUserProfile.FormCreate(Sender: TObject);
begin
  // Automatically expand everything so (a) it looks good for screenshot and (b) its easy to see how well the text is shown
  NLOLine.FullExpand;
  FInterMode:= False;
  FCurrent_User := EntryRec^.Login;
end;

//------------------------------------------------------------------------------

procedure TfrmUserProfile.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  if (EntryRec^.Login <> FCurrent_User) and FInterMode then
  begin
    GetLoginRec(FCurrent_User);
    Send_UpdateList(102);
  end;
  Action := caFree;
end;

//------------------------------------------------------------------------------

procedure TfrmUserProfile.FormResize(Sender: TObject);
begin
  if FIsResizingON then
  begin
    PageControl1.Width := ClientWidth - FXYDifference[0].X;
    PageControl1.Height := ClientHeight - FXYDifference[0].Y;
  end;
  pnlButton.Left := PageControl1.Width - (pnlButton.Width);
  pnlEmailSig.Height := Round((pnlMainSig.Height)/2) - 5;
end;   

//------------------------------------------------------------------------------
// initialize Profie Tab  
procedure TfrmUserProfile.InitProfileTab;
begin
  edtPwdExpDate.Text := '';
  // for Admin user automatically lock option will be visible only
  if FIsAdminUser then
  begin
    // for windows authentication security section should be invisible
    if (FAuthenticationMode=AuthMode_Windows) then
    begin
      pnlRandomPwd.Visible := BOff;
      pnlPwdExp.Visible := BOff;
      pnlSecurityQuestion.Visible := BOff;
    end
    else
    begin   //AuthMode_Exchequer
      if (FUserActionMode in [umInsert, umCopy]) then   //Add, Copy
      begin
        pnlSecurityQuestion.Visible := BOff;
        rbGenRandom.Enabled := BOff;
        rbGenManual.Checked := BOn;
      end
      else if (FUserActionMode = umUpdate) then           //Edit
      begin
        pnlRandomPwd.Visible := BOff;

        if FIsAdminUser and (Trim(FUserDetailsIntf.udUserName) <> trim(EntryRec^.Login))  then   //if admin is editing other user
          pnlSecurityQuestion.Visible := BOff;
      end;
    end;
    //Logged in Users - Status Drop down should be disabled.
    if (Trim(FUserDetailsIntf.udUserName) = trim(EntryRec^.Login)) then   //
      cboUserStatus.Enabled := False;
  end
  else
  begin
    { for non Admin User Security Question/Answer and User Preferences section
      will be available, the other fields will be read-only }
    pnlMainStatus.Enabled := BOff;
    pnlRandomPwd.Visible := BOff;
    pnlAutoLock.Enabled := BOff;
    pnlPwdExp.Enabled := BOff;
    if (FAuthenticationMode = AuthMode_Windows) then
    begin
      pnlPwdExp.Visible := BOff;
      pnlSecurityQuestion.Visible := BOff;
    end;
  end;  {if FIsAdminUser}

  {HV 17/10/2017 2017 R2 ABSEXCH-19284: User Profile Highlight PII fields flag}
  pnlGDPR.Visible := GDPROn; //ToDo Visible Based on GDPR Pack is licensed.

  // Default Printers are only available if the Enhanced Security feature is licensed
  if not EnSecurity then
    pnlPrinter.Visible := BOff;      // Form Printer/Report Printer

  // the Stock Tree fields will not be shown in non-Stock versions
  {$IFDEF STK}
    pnlStockTree.Visible := BOn;
  {$ENDIF}

  if pnlSecurityCont.Visible then
    SetPanelSize(pnlSecurityCont);
    
  LoadSecurityQuestion;
  edtUserName.Enabled := FUserActionMode in [umInsert, umCopy];
  SetPanelSize(pnlUserPref);
  SetPanelSize(pnlProfileCont);
end;

//------------------------------------------------------------------------------

procedure TfrmUserProfile.btnCancelClick(Sender: TObject);
begin
  Close;
end;

//------------------------------------------------------------------------------
// Stores the signature of the company
procedure TfrmUserProfile.StoreSignature;
begin
  if PageControl1.Pages[3].TabVisible then
  begin
    if edtUserName.Text <> EmptyStr then
    begin
      FFiles[1]:= SetDrive + SignDirectoryPath + trim(edtUserName.Text) + '.TXT';
      FFiles[2]:= SetDrive + SignDirectoryPath + trim(edtUserName.Text) + '.TX2';
    end;
    memEmailSig.Lines.SaveToFile(FFiles[1]);
    memFaxSig.Lines.SaveToFile(FFiles[2]);
  end;
end;

//------------------------------------------------------------------------------
//Sets the file path and memo according to the mode (Add/Edit) 
procedure TfrmUserProfile.InitSignatureTab;
var
  lFileName: String;
begin
  if not PageControl1.Pages[3].TabVisible then Exit;
  FFiles[1] := '';
  FFiles[2] := '';
  lFileName := '';
  memEmailSig.Clear;
  memFaxSig.Clear;

  if FUserActionMode = umUpdate then
    lFileName := Uppercase(Trim(FUserDetailsIntf.udUserName))
  else if FUserActionMode = umCopy then
    lFileName := Uppercase(Trim(FUserDetailsIntf.udCopyUserName));

  FFiles[1] := lFileName + '.TXT';
  FFiles[2] := lFileName + '.TX2';
  // set signature file path
  PopulateSign(1, FFiles[1], CompanyEmailFile, memEmailSig);
  PopulateSign(2, FFiles[2], CompanyFaxFile, memFaxSig);
end;

//------------------------------------------------------------------------------
// Sets the path of the file in DOCMASTR\ directory
procedure TfrmUserProfile.PopulateSign(const AIdx: Byte;
                                       AFileName1, AFileName2: ShortString;
                                       AMemo: TMemo);
begin
  AFileName1 := SetDrive + SignDirectoryPath + AFileName1;
  FFiles[AIdx] := AFileName1;

  if not FileExists(AFileName1) then
    AFileName1 := SetDrive + SignDirectoryPath + AFileName2;
  AMemo.clear;
  // Populates the Tmemo with the data in their respective text files
  if FileExists(AFileName1) then
    AMemo.Lines.LoadFromFile(AFileName1);
end;

//------------------------------------------------------------------------------

procedure TfrmUserProfile.InitDefaultTab;
var
  lShowLoc:  Boolean;
  lRule: String;
  I:  Integer;
begin
  if not PageControl1.Pages[1].TabVisible then
    Exit;
  {$IFNDEF SOP}
     lShowLoc := BOff;
  {$ELSE}
     lShowLoc := Syss.UseMLoc;
  {$ENDIF}
  pnlLocations.Visible := lShowLoc;
  pnlCCDept.Visible := Syss.UseCCDep;
  SetPanelSize(pnlDefaultsCont);

  if pnlCCDept.Visible and JBCostOn then
  begin
    for I := 0 to cboSelRuleCCDept.Items.Count - 1 do
    begin
      lRule := cboSelRuleCCDept.Items[I];
      lRule := lRule + ', Job';
      cboSelRuleCCDept.Items[I] := lRule;
    end;
  end;
  {$IFDEF SOP}
    if pnlLocations.Visible then
      cboSelRuleLoc.ItemsL.Assign(cboSelRuleLoc.Items);
  {$ENDIF}
end;

//------------------------------------------------------------------------------

procedure TfrmUserProfile.txtCustomerListExit(Sender: TObject);
var
  lFoundCode: Str20;
  lFoundOk,
  lAltMod:  Boolean;
begin
  if (Sender is Text8pt) then
  begin
    with (Sender as Text8pt) do
    begin
      lAltMod := Modified;
      lFoundCode := Strip('B', [#32], Text);
      if (lAltMod) and ((lFoundCode <> '') and (OrigValue <> Text))  and (ActiveControl <> btnCancel) then
      begin
        StillEdit := BOn;
        lFoundOk := (GetCust(Self, lFoundCode, lFoundCode, (Sender = txtCustomerList), 0));
        if lFoundOk then
        begin
          StillEdit := BOff;
          Text := lFoundCode;
          if Sender = txtCustomerList then
            lblCustSRI.Caption := Cust.Company
          else
            lblSuppPPI.Caption := Cust.Company
        end
        else
          SetFocus;
      end;
    end; {with (Sender as Text8pt) do}
  end; {if (Sender is Text8pt) then}
end;

//------------------------------------------------------------------------------

procedure TfrmUserProfile.edtBankGLSalesExit(Sender: TObject);
var
  lFoundCode: Str20;
  lFoundOk,
  lAltMod: Boolean;
  lFoundLong: LongInt;
begin
  if (Sender is Text8pt) then
  begin
    with (Sender as Text8pt) do
    begin
      lAltMod := Modified;
      lFoundCode := Strip('B', [#32], Text);
      if ((lAltMod) and (lFoundCode<>'')) and (ActiveControl<>btnCancel) then
      begin
        StillEdit:=BOn;
        lFoundOk:=(GetNom(Self.Owner, lFoundCode, lFoundLong, 2));
        if lFoundOk then
        begin
          with ExLocal do
          begin
            AssignFromGlobal(NomF);
          end;
          Text := Form_Int(lFoundLong, 0);
          if (Sender = edtBankGLSales) then
            lblSalesGL.Caption := Nom.Desc
          else
            lblPurchGL.Caption := Nom.Desc;
        end
        else
          SetFocus;
      end;
    end; {with (Sender as Text8pt) do}
  end; {if (Sender is Text8pt) then}
end;

//------------------------------------------------------------------------------

procedure TfrmUserProfile.txtDefaultCCExit(Sender: TObject);
var
  lFoundCode: Str20;
  lFoundOk,
  lAltMod: Boolean;
  lIsCC: Boolean;
begin
  {$IFDEF PF_On}
    if (Sender is Text8pt) then
    begin
      with (Sender as Text8pt) do
      begin
        lFoundCode := Name;
        lIsCC := Match_Glob(Sizeof(lFoundCode), 'CC', lFoundCode, lFoundOk);
        lAltMod := Modified;
        lFoundCode := Strip('B', [#32], Text);
        if ((lAltMod) and (lFoundCode<>'')) and (ActiveControl <> btnCancel) and (Syss.UseCCDep) then
        begin
          StillEdit := BOn;
          lFoundOk:=(GetCCDep(Self.Owner, lFoundCode, lFoundCode, lIsCC, 2));
          if lFoundOk then
          begin
            StillEdit := BOff;
            Text := lFoundCode;
            if Sender = txtDefaultCC then
              lblCCDec.Caption := Password.CostCtrRec.CCDesc
            else
              lblDepDes.Caption := Password.CostCtrRec.CCDesc;
          end
          else
            SetFocus;
        end;
      end; {with..}
    end;
  {$ENDIF}
end;

//------------------------------------------------------------------------------

procedure TfrmUserProfile.txtDefaultLocExit(Sender: TObject);
var
  lFoundCode: Str10;
  lFoundOk,
  lAltMod:  Boolean;
begin
  {$IFDEF SOP}
    if (Sender is Text8pt) then
    begin
      with (Sender as Text8pt) do
      begin
        lAltMod := Modified;
        lFoundCode := Strip('B', [#32], Text);
        if (lAltMod) and  (lFoundCode <> '') and (OrigValue <> Text) and (Syss.UseMLoc) and (ActiveControl <> btnCancel) then
        begin
          StillEdit := BOn;
          lFoundOk := (GetMLoc(Self, lFoundCode, lFoundCode, '', 0));
          if lFoundOk then
          begin
            StillEdit := BOff;
            Text := lFoundCode;
            lblLocationDes.Caption := MLocCtrl^.MLocLoc.loName;
          end
          else
            SetFocus;
        end;
      end;
    end;
  {$ENDIF}
end;

//------------------------------------------------------------------------------

procedure TfrmUserProfile.SetPanelSize(aPanel: TPanel);
var
  lContHgt,
  I, K: Integer;
begin
  lContHgt := 0;
  K := 0;
  for I := 0 to aPanel.ControlCount-1  do
  begin
    if aPanel.Controls[I] is TPanel then
    begin
      if aPanel.Controls[I].Visible then
      begin
        lContHgt := lContHgt + aPanel.Controls[I].Height;
        Inc(K);
      end;
    end;
  end;
  aPanel.Height := lContHgt + K;
end;

//------------------------------------------------------------------------------

procedure TfrmUserProfile.SetFormSize;
var
  lHeight: integer;
begin
  // make both panel of same size for convenience
  if (PageControl1.Pages[1].TabVisible) and (pnlDefaultsCont.Height > pnlProfileCont.Height) then
  begin
    lHeight := pnlDefaultsCont.Height;
    pnlProfileCont.Height := pnlDefaultsCont.Height;
  end
  else
  begin
    lHeight := pnlProfileCont.Height;
    pnlDefaultsCont.Height := pnlProfileCont.Height;
  end;

  PageControl1.Height := lHeight + FXYDifference[1].Y;
  Self.ClientHeight := PageControl1.Height + FXYDifference[0].Y;
  pnlEmailSig.Height := Round((pnlMainSig.Height)/2) - 5;
  Self.Constraints.MinHeight := self.ClientHeight + 34;
end;

//------------------------------------------------------------------------------

constructor TfrmUserProfile.Create(AOwner: TComponent;
                                   const AMode: TUserObjectMode;
                                   AUserDetailsIntf: IUserDetails;
                                   APermission: Boolean = False);
begin
  FUserDetailsIntf := AUserDetailsIntf;
  FUserActionMode := AMode;
  inherited Create(AOwner);
  Init;
  SetCaption;
  FInAddEdit := Bon;
  if (FUserActionMode = umInsert) and (APermission) then
    FUserDetailsIntf.SetAccessSettingsYes(True);
  DisplayFields;
end;

//------------------------------------------------------------------------------

procedure TfrmUserProfile.DisplayFields;
var
  lFoundInt: LongInt;
  lFoundCode: Str20;
  lLocCode: Str10;
begin
  if not Assigned(FUserDetailsIntf) then Exit;
  with FUserDetailsIntf do
  begin
    // Profile TAB
    if (udUserStatus = usActive) then     // SSK 17/08/2017 2017-R2 ABSEXCH-19141: change needed to save Suspended status
      cboUserStatus.ItemIndex := 0
    else
      cboUserStatus.ItemIndex := 1;

    edtUserName.Text := Strip('R',[#32], udUserName);
    edtUserFullName.Text := udFullName;
    edtWinUserID.Text := udWindowUserId;
    edtUserEmail.Text := udEmailAddr;

    if (udPwdExpMode In [0..2]) then
      cboPasswordExpiry.ItemIndex:=udPwdExpMode
    else
      cboPasswordExpiry.ItemIndex:=0;

    cboPasswordExpiryChange(cboPasswordExpiry);
    edtPwdExpDays.Value :=  udPwdExpDays;
    edtPwdExpDate.DateValue := udPwdExpDate;
    chkAutoLock.Checked := udPwdTimeOut > 0;
    udUserInactivityDuration.Position := udPwdTimeOut;
    edtPwdInactiveTime.Text := IntToStr(udPwdTimeOut);
    if udSecurityQuesId > 0 then
      cboSecurityQuestion.ItemIndex := udSecurityQuesId-1
    else
      cboSecurityQuestion.ItemIndex := 0;
    edtSecurityAnswer.Text := udSecurityQuesAns;

    {$IFDEF Frm}
      pfSet_NDPDefaultPrinter(cboReportPrinter, udRepPrint, 2);
      If cboReportPrinter.ItemIndex < 0 then
        cboReportPrinter.ItemIndex := 0;
      if udRepPrint <> '' then
        cboReportPrinter.Text := udRepPrint;

      pfSet_NDPDefaultPrinter(cboFormPrinter, udFormPrint, 2);
      if cboFormPrinter.ItemIndex < 0 then
        cboFormPrinter.ItemIndex := 0;
      if udFormPrint <> ''then
        cboFormPrinter.Text := udFormPrint;
    {$ENDIF}

    chkShowGLCode.Checked := udShowGlCodes;
    {$IFDEF STK}
      chkShowStockCodes.Checked := udShowStockCodes;
      chkShowProdTypes.Checked := udShowProductType;
    {$ENDIF}

    {HV 16/10/2017 2017 R2 ABSEXCH-19284: User Profile Highlight PII fields flag}
    if pnlGDPR.Visible then
    begin
      chkHighlightPIIFields.Checked := udHighlightPIIFields;
      if udHighlightPIIColour <> 0 then
        spGDPR.Brush.Color := udHighlightPIIColour;
      //AP 13/11/2017 2018-R1: ABSEXCH-19439:CR: UI and functional changes related to User Profile
      btnEditColour.Enabled := udHighlightPIIFields;
    end;

    // Default TAB
    if tabUserDefaults.TabVisible then
    begin
      txtCustomerList.Text := Trim(udDirCust);
      if txtCustomerList.Text <> EmptyStr then
      begin
        lFoundCode := Strip('B',[#32],txtCustomerList.Text);
        if GetCust(Self, lFoundCode, lFoundCode, True, 0) then
          lblCustSRI.Caption := Cust.Company;
      end
      else
        lblCustSRI.Caption := '';

      txtSupplierList.Text := Trim(udDirSupp);
      if txtSupplierList.Text <> EmptyStr then
      begin
        lFoundCode:=Strip('B',[#32],txtSupplierList.Text);
        if GetCust(Self, lFoundCode, lFoundCode, False, 0) then
          lblSuppPPI.Caption := Cust.Company;
      end
      else
        lblSuppPPI.Caption := '';

      edtMaxSales.Value := udMaxSalesAuth;
      edtMaxPurch.Value := udMaxPurchAuth;

      edtBankGLSales.Text := Form_BInt(udSalesBank, 0);
      if udSalesBank <> 0 then
      begin
        if GetNom(Self, edtBankGLSales.Text, lFoundInt, -1) then
          lblSalesGL.Caption:=Nom.Desc;
      end
      else
        lblSalesGL.Caption := '';

      edtBankGLPurch.Text:=Form_BInt(udPurchBank,0);
      if udPurchBank <> 0 then
      begin
        if GetNom(Self, edtBankGLPurch.Text, lFoundInt, -1) then
          lblPurchGL.Caption := Nom.Desc;
      end
      else
        lblPurchGL.Caption := '';

      txtDefaultCC.Text := Trim(udCCDep[Bon]);
      if txtDefaultCC.Text <> '' then
      begin
        lFoundCode := Strip('B', [#32], txtDefaultCC.Text);
        if GetCCDep(Self.Owner, lFoundCode, lFoundCode, True, -1) then
          lblCCDec.Caption := Password.CostCtrRec.CCDesc
        else
          lblCCDec.Caption := EmptyStr;
      end
      else
        lblCCDec.Caption := '';

      txtDefaultDept.Text := Trim(udCCDep[BOff]);
      if txtDefaultDept.Text <> EmptyStr then
      begin
        lFoundCode := Strip('B',[#32], txtDefaultDept.Text);
        if GetCCDep(txtDefaultDept, lFoundCode, lFoundCode, False, -1) then
          lblDepDes.Caption := Password.CostCtrRec.CCDesc
        else
          lblDepDes.Caption := EmptyStr;
      end
      else
        lblDepDes.Caption := '';

      if (udCCDepRules in [0..3]) then
        cboSelRuleCCDept.ITemIndex := udCCDepRules
      else
        cboSelRuleCCDept.ITemIndex := 0;

      {$IFDEF SOP}
        lblLocationDes.Caption := '';
        txtDefaultLoc.Text := Trim(udLocation);
        if (txtDefaultLoc.Text <> EmptyStr) and pnlLocations.Visible then
        begin
          lLocCode:=Strip('B',[#32], txtDefaultLoc.Text);
          if GetMLoc(Self, lLocCode, lLocCode, '', 0) then
            lblLocationDes.Caption := MLocCtrl^.MLocLoc.loName;
        end;
        if (udLocRules In [0..3]) then
          cboSelRuleLoc.ItemIndex := udLocRules
        else
          cboSelRuleLoc.ItemIndex:=0;
      {$ENDIF}

      FEntryRec := FUserDetailsIntf.udUserAccessRec;
    end; //if tabUserDefaults.TabVisible then
  end;
end;

//------------------------------------------------------------------------------

procedure TfrmUserProfile.edtPwdExpDaysExit(Sender: TObject);
begin
  if (cboPasswordExpiry.ItemIndex = 1) and (Self.ActiveControl <> btnCancel) then
  begin
    with edtPwdExpDays do
      edtPwdExpDate.DateValue := CalcDueDatexDays(Today, Round(Value));   //SSK 13/10/2017 2018-R1 ABSEXCH-19379 : function changed to calculate Expiry Date ignoring special(900) codes
  end;
end;

//------------------------------------------------------------------------------
procedure TfrmUserProfile.edtPwdExpDateExit(Sender: TObject);
var
  lRes: Integer;
begin
  if (Self.ActiveControl <> btnCancel) then
  begin
    FUserDetailsIntf.udPwdExpDate := edtPwdExpDate.DateValue;
    FUserDetailsIntf.udPwdExpMode := cboPasswordExpiry.ItemIndex;
    lRes := FUserDetailsIntf.Validate(Self, [udfPwdExpiryDate]);
    if lRes <> 0 then
    begin
      MessageDlg(FUserDetailsIntf.ValidationErrorDescription(lRes), mtError, [mbOk], 0);
      edtPwdExpDate.DateValue := '00/00/0000';
      edtPwdExpDate.SetFocus;
    end
    else
    begin
      //calculate no. of days
      edtPwdExpDays.Value := NoDays(today, edtPwdExpDate.DateValue);
    end;

  end;
end;

procedure TfrmUserProfile.SetCaption;
begin
  if not Assigned(FUserDetailsIntf) then
    Exit;

  if FUserActionMode in [umInsert, umCopy] then
    Self.Caption := 'New User Profile';
  if FUserActionMode = umUpdate then
  begin
    if Trim(FUserDetailsIntf.udFullName) = EmptyStr then
      Self.Caption := 'Edit User Profile - ' + Trim(FUserDetailsIntf.udUserName)
    else
      Self.Caption := 'Edit User Profile - ' + Trim(FUserDetailsIntf.udUserName) + ', ' + Trim(FUserDetailsIntf.udFullName);
  end;
end;

//------------------------------------------------------------------------------

procedure TfrmUserProfile.cboPasswordExpiryChange(Sender: TObject);
begin
  edtPwdExpDate.Enabled := cboPasswordExpiry.ItemIndex = 1;
  edtPwdExpDays.Enabled := edtPwdExpDate.Enabled;
end;

//------------------------------------------------------------------------------

procedure TfrmUserProfile.btnOKClick(Sender: TObject);
var
  lRes: Integer;
begin
  // Set focus to OK button to ensure any OnExit events have kicked off
  btnOK.SetFocus;
  Screen.Cursor := crHourGlass;
	if FInterMode then
    GetLogInRec(FCurrent_User);
  try
    // Check focus hasn't been moved back to an invalid control
    if ActiveControl = btnOK then
    begin
    	StoreUserDetail;
      // Validate All Fields on the User Details entity
      lRes := FUserDetailsIntf.Validate(self, []);  // [] = All fields
      if lRes = 0 then
      begin
        // Update Password Manual
        if (FUserDetailsIntf.udMode = umInsert) and (pnlRandomPwd.Visible) then
        begin
          if rbGenManual.Checked then
            lRes :=  DisplayChangePasswordDlg(Self, FUserDetailsIntf, True)
          else if rbGenRandom.Checked then //Send Password Email to User and Update into Database
          begin
            lRes := FUserDetailsIntf.ResetPassword(True, False);
            if lRes = 0 then
              MessageDlg(Format(msgEmailSent, [Trim(FUserDetailsIntf.udUserName)]), mtInformation, [mbOK], 0)
            else
              MessageDlg(FUserDetailsIntf.ResetPasswordErrorDescription(lRes), mtError, [mbOk], 0);
          end;
        end;
      end
      else
      begin
        MessageDlg(FUserDetailsIntf.ValidationErrorDescription(lRes), mtError, [mbOk], 0);
        // Intelligently set the focus depending on the error
        case lRes of
          1001, 1002  : if edtUserName.CanFocus then edtUserName.SetFocus;
          1003, 1005  : if edtWinUserID.CanFocus then edtWinUserID.SetFocus;
          1004        : if edtUserEmail.CanFocus then edtUserEmail.SetFocus;
          1006        : if edtSecurityAnswer.CanFocus then edtSecurityAnswer.SetFocus;
          1009        : begin
                          edtPwdExpDate.DateValue := '00/00/0000';
                          if edtPwdExpDate.canfocus then edtPwdExpDate.SetFocus;
                        end;
          1010        : if PageControl1.ActivePage <> tabUserDefaults then
                        begin
                          PageControl1.ActivePage := tabUserDefaults;
                          if txtDefaultCC.CanFocus then txtDefaultCC.SetFocus;
                        end;
          1011        : if PageControl1.ActivePage <> tabUserDefaults then
                        begin
                          PageControl1.ActivePage := tabUserDefaults;
                          if txtDefaultDept.CanFocus then txtDefaultDept.SetFocus;
                        end;
        end;
      end;              

      // Start Save Data in to Database
      if lRes = 0 then
      begin
        lRes := FUserDetailsIntf.Save; //Save User Details into Database
        if lRes = 0 then
        begin
          //HV 09/11/2017 2018-R1: Highlighting PII Fields flag for GDPR
          if (FCurrent_User = FUserDetailsIntf.udUserName) and GDPROn then
          begin
            UserProfile^ := FUserDetailsIntf.udUserPassDetailRec;
            GDPRColor := UserProfile.HighlightPIIColour;
            IsGDPROn := GDPROn and UserProfile.HighlightPIIFields;
          end;
          FInAddEdit := False;
          StoreSignature;
          SendMessage((Owner as TForm).Handle, WM_REFRESH, 0, 1); // Referesh User Managment List
          Close;
        end
        else
          MessageDlg(FUserDetailsIntf.SaveErrorDescription(lRes), mtError, [mbOk], 0);
      end;
    end;
  finally
    Screen.Cursor := crDefault;
  end;
end;

//------------------------------------------------------------------------------

procedure TfrmUserProfile.PageControl1Change(Sender: TObject);
begin
  pnlAccessSettingBtn.Visible := PageControl1.ActivePage = tabAccessSettings;
  FLastFind := EmptyStr;
  //Access settings and Signature details not Copied in new user
  if (not NLOLine.TreeReady) and (PageControl1.ActivePage = tabAccessSettings) then
    InitAccessSettingTab;
end;

//------------------------------------------------------------------------------

procedure TfrmUserProfile.edtUserNameExit(Sender: TObject);
var
  lRes: Integer;
begin
  FUserDetailsIntf.udUserName := trim(edtUserName.Text);
  if Self.ActiveControl <> btnCancel then
  begin
    lRes := FUserDetailsIntf.Validate(Self, [udfUserName]);
    if lRes <> 0 then
    begin
      MessageDlg(FUserDetailsIntf.ValidationErrorDescription(lRes), mtError, [mbOk], 0);
      if edtUserName.CanFocus then
        edtUserName.SetFocus;
    end;
  end;
end;

//------------------------------------------------------------------------------

procedure TfrmUserProfile.edtWinUserIDExit(Sender: TObject);
var
  lRes: Integer;
begin
  FUserDetailsIntf.udWindowUserId:= edtWinUserID.Text;
  if Self.ActiveControl <> btnCancel then
  begin
    lRes := FUserDetailsIntf.Validate(Self, [udfWindowUserId]);
    if lRes <> 0 then
    begin
      MessageDlg(FUserDetailsIntf.ValidationErrorDescription(lRes), mtError, [mbOk], 0);
      if edtWinUserID.CanFocus then
        edtWinUserID.SetFocus;
    end;
  end;
end;

//------------------------------------------------------------------------------

procedure TfrmUserProfile.edtUserEmailExit(Sender: TObject);
var
  lRes: Integer;
begin
  // Update business object with the current value, but don't validate if the focus has moved to the Cancel button
  FUserDetailsIntf.udEmailAddr := trim(edtUserEmail.Text);
  lRes := 0;
  if (Self.ActiveControl <> btnCancel) then
  begin
    lRes := FUserDetailsIntf.Validate(Self, [udfEmailAddr]);
    if lRes <> 0 then
    begin
      MessageDlg(FUserDetailsIntf.ValidationErrorDescription(lRes), mtError, [mbOk], 0);
      if edtUserEmail.CanFocus then
        edtUserEmail.SetFocus;
    end;
  end;

  //Generate Random password field should be enabled only when a valid email address is entered
  if (trim(edtUserEmail.Text) = EmptyStr) or (lRes <> 0) then
  begin
    rbGenRandom.Enabled := False;
    rbGenManual.Checked := True;
  end
  else
    rbGenRandom.Enabled := True;
end;

//------------------------------------------------------------------------------

procedure TfrmUserProfile.edtSecurityAnswerExit(Sender: TObject);
begin
  // Update business object with the current value, but don't validate if the focus has moved to the Cancel button
  FUserDetailsIntf.udSecurityQuesAns := edtSecurityAnswer.Text;
end;

//------------------------------------------------------------------------------

procedure TfrmUserProfile.Init;
begin
  //ABSEXCH-20289: When amending screen size to medium, new password security and GDPR screens are distorted (125% Resolution Issue)
  if Screen.PixelsPerInch > 96 then
  begin
    chkAutoLock.Width := chkAutoLock.Width + 3;
    lblAfter.Left := lblAfter.Left + 2;
    spGDPR.Left := spGDPR.Left + 4;
    btnEditColour.Left := btnEditColour.Left + 3;
  end;

  FIsResizingON := BOff;
  // set initial Height/Width of the Form
  Self.ClientHeight := 489;
  Self.ClientWidth :=  572;
  FModifiedAccessSettings := False;
  //get relative size of the form
  FXYDifference[0].X := ClientWidth - PageControl1.Width;
  FXYDifference[0].Y := 10;
  FXYDifference[1].X := PageControl1.Width - pnlProfileCont.Width;
  FXYDifference[1].Y := PageControl1.Height - pnlProfileCont.Height;

  FAuthenticationMode := SystemSetup.PasswordAuthentication.AuthenticationMode;
  FIsAdminUser := ChkAllowed_In(92);

  { for non Admin user only Profile tab will be visible; Security Question and User Preferences will be accessible;
    Other fields in Profile tab will be visible but readonly; EnSecurity true means Enhanced Security feature is licensed. }
  // Default Tab
  PageControl1.Pages[1].TabVisible := (FIsAdminUser and EnSecurity);
  // Access Tab
  PageControl1.Pages[2].TabVisible := FIsAdminUser;
  //Signatures Tab
  PageControl1.Pages[3].TabVisible := FIsAdminUser and eCommsModule;

  // initialize the values related to Profile tab
  InitProfileTab;
  // initialize values related to Default tab
  InitDefaultTab;
  //Method to initialize the values related to signature tab
  InitSignatureTab;

  SetFormSize;
  FIsResizingON := True;
  // made Profile Tab as Active Page
  PageControl1.ActivePage := PageControl1.Pages[0];
  pnlAccessSettingBtn.Visible := PageControl1.ActivePage = tabAccessSettings;
end;

//------------------------------------------------------------------------------

procedure TfrmUserProfile.FormDestroy(Sender: TObject);
begin
  FUserDetailsIntf := nil; 
end;

//------------------------------------------------------------------------------

procedure TfrmUserProfile.StoreUserDetail;
var
  lCcDep: CCDepType;
begin
  if not Assigned(FUserDetailsIntf) then
    Exit;
  with FUserDetailsIntf do
  begin
    // Profile TAB
    if cboUserStatus.ItemIndex <> -1 then
      udUserStatus := TUserStatus(cboUserStatus.ItemIndex);

    udUserName := edtUserName.Text;
    udFullName := edtUserFullName.Text;
    udWindowUserId := edtWinUserID.Text;
    udEmailAddr := edtUserEmail.Text;
    udPwdExpMode := cboPasswordExpiry.ItemIndex;

    if edtPwdExpDays.Enabled then
      udPwdExpDays := Round(edtPwdExpDays.Value);

    if edtPwdExpDate.Enabled then
      udPwdExpDate := edtPwdExpDate.DateValue;

    if chkAutoLock.Checked then
      udPwdTimeOut := udUserInactivityDuration.Position
    else
      udPwdTimeOut := 0;

    if edtSecurityAnswer.Text <> '' then
    begin
      udSecurityQuesId := cboSecurityQuestion.ItemIndex+1;
      udSecurityQuesAns := edtSecurityAnswer.Text;
    end;
    {$IFDEF Frm}
      udRepPrint := cboReportPrinter.Text;
      udFormPrint := cboFormPrinter.Text;
    {$ENDIF}

    udShowGlCodes := chkShowGLCode.Checked;
    {$IFDEF STK}
      udShowStockCodes := chkShowStockCodes.Checked;
      udShowProductType := chkShowProdTypes.Checked;
    {$ENDIF}

    {HV 16/10/2017 2017 R2 ABSEXCH-19284: User Profile Highlight PII fields flag}
    if pnlGDPR.Visible then
    begin
      udHighlightPIIFields := chkHighlightPIIFields.Checked;
      udHighlightPIIColour := spGDPR.Brush.Color;
    end;

    // Default TAB
    if tabUserDefaults.TabVisible then
    begin
      udDirCust := Trim(txtCustomerList.Text);
      udDirSupp := Trim(txtSupplierList.Text);

      udMaxSalesAuth := edtMaxSales.Value;
      udMaxPurchAuth := edtMaxPurch.Value;

      if (edtBankGLSales.Text <> '') then
        udSalesBank := StrToInt(edtBankGLSales.Text)
      else
        udSalesBank := 0;

      if (edtBankGLPurch.Text <> '') then
        udPurchBank := StrToInt(edtBankGLPurch.Text)
      else
        udPurchBank := 0;

      if (txtDefaultCC.Text <> '') then
        lCcDep[Bon]:= FullCCDepKey(Trim(txtDefaultCC.Text));

      if (txtDefaultDept.Text <> '') then
        lCcDep[BOff]:= FullCCDepKey(Trim(txtDefaultDept.Text));

      udCCDep := lCcDep;
      udCCDepRules := cboSelRuleCCDept.ITemIndex;
      {$IFDEF SOP}
        udLocation := txtDefaultLoc.Text;
        udLocRules := cboSelRuleLoc.ItemIndex;
      {$ENDIF}

      FUserDetailsIntf.udUserAccessRec := FEntryRec;
    end;
  end;
end;

//------------------------------------------------------------------------------

procedure TfrmUserProfile.chkAutoLockClick(Sender: TObject);
begin
  udUserInactivityDuration.Enabled := chkAutoLock.Checked;
  edtPwdInactiveTime.Enabled := chkAutoLock.Checked;

  if not chkAutoLock.Checked then
    udUserInactivityDuration.Position := 0;
end;

//------------------------------------------------------------------------------

procedure TfrmUserProfile.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if Sender <> memEmailSig then
    GlobFormKeyDown(Sender, Key, Shift, ActiveControl, Handle);
end;

//------------------------------------------------------------------------------

procedure TfrmUserProfile.FormKeyPress(Sender: TObject; var Key: Char);
begin
  if Sender <> memEmailSig then
    GlobFormKeyPress(Sender, Key, ActiveControl, Handle);
end;

//------------------------------------------------------------------------------

function TfrmUserProfile.ConfirmQuit: Boolean;
var
  lmbRet:  Word;
  lTmpBool:  Boolean;
begin
  lTmpBool := False;
  if (FInAddEdit) and (CheckNeedStore) and (Not ExLocal.LViewOnly) then
    lmbRet := MessageDlg(Format(msgConfirmQuitUserProfile, [edtUserName.Text]), mtConfirmation, [mbYes,mbNo,mbCancel], 0)
  else
    lmbRet := mrNo;

  case lmbRet of
    mrYes     : begin
                  btnOKClick(btnOK);
                  lTmpBool := BOn and (not FInAddEdit);
                end;
    mrNo      : begin
                  GetLoginRec(FCurrent_User);
                  lTmpBool := BOn;
                end;
    mrCancel  : begin
                  lTmpBool := BOff;
                end;
  end; {Case..}
  ConfirmQuit := lTmpBool;
end;

//------------------------------------------------------------------------------

function TfrmUserProfile.CheckNeedStore: Boolean;
var
  i: Integer;
begin
  Result := BOff;
  i := 0;
  while (i <= Pred(ComponentCount)) and (not Result) do
  begin
    if (Components[i] is TMaskEdit) then
    begin
      with TMaskEdit(Components[i]) do
        Result := (Tag = 1) and Modified;
      if Result then
        TMaskEdit(Components[i]).Modified := BOff;
    end
    else If (Components[i] is TCurrencyEdit) then
    begin
      with TCurrencyEdit(Components[i]) do
        Result := (Tag = 1) and (FloatModified);
      if Result then
        TCurrencyEdit(Components[i]).FloatModified := BOff;
    end
    else if (Components[i] is TCheckBoxEx) then
    begin
      with TCheckBoxEx(Components[i]) do
        Result := (Tag = 1) and Modified;
      If Result then
        TCheckBoxEx(Components[i]).Modified:=BOff;
    end
    else
    if (Components[i] is TSBSComboBox) then
    begin
      with TSBSComboBox(Components[i]) do
        Result:=(Tag=1) and Modified;
      if Result then
        TSBSComboBox(Components[i]).Modified := BOff;
    end;
    if (Components[i] is TMemo) then
    begin
      with TMemo(Components[i]) do
        Result := Modified;
      if Result then
        TMemo(Components[i]).Modified := False;
    end;
    Inc(i);
  end; {While..}
  Result := Result or FModifiedAccessSettings;
end;

//------------------------------------------------------------------------------

procedure TfrmUserProfile.FormCloseQuery(Sender: TObject;
  var CanClose: Boolean);
begin
  {$B-}
    CanClose := (not FInAddEdit) or ConfirmQuit;
  {$B+}
end;

//------------------------------------------------------------------------------
// User Profile - Access Settings Tab
procedure TfrmUserProfile.NLOLineExpand(Sender: TObject; Index: Integer);
var
  lONomRec: ^OutNomType;
begin
  with (Sender as TSBSOutLineB) do
  begin
    lONomRec := Items[Index].Data;
    if lONomRec <> nil then
    begin
      with lONomRec^ do
      begin
        if ITems[Index].HasItems then
        begin
          if MoreLink then
            GetMoreLinks(Index);
        end
        else If LastPR > 0 then
          UpdateArrayPosition(LastPr,2);
      end;
    end;
  end; {With..}
end;

//------------------------------------------------------------------------------

procedure TfrmUserProfile.NLOLineUpdateNode(Sender: TObject;
  var Node: TSBSOutLNode; Row: Integer);
var
  lONomRec: ^OutNomType;
begin
  with Node do
  begin
    lONomRec:= Data;
    if lONomRec <> nil then
    begin
      with lONomRec^ do
      begin
        if LastPr > 0 then
        begin
          CheckBoxChecked:= (FEntryRec.Access[LastPr]=1);
          if CheckBoxChecked then
            UseLeafX := obLeaf2
          else
            UseLeafX := obLeaf;
        end;
      end;
    end;
  end;
end;

//------------------------------------------------------------------------------

procedure TfrmUserProfile.NLOLineNodeChkHotSpot(Sender: TObject;
  var Node: TSBSOutLNode; Row: Integer);
var
  lONomRec: ^OutNomType;
begin
  with (Sender as TSBSOutLineB) do
  begin
    with Node do
    begin
      lONomRec:= Data;
      if lONomRec <> nil then
      begin
        with lONomRec^ do
        begin
          if LastPR > 0 then
          begin
            if (FEntryRec.Login <> EmptyStr) or (True) then
            begin
              UpdateArrayPosition(LastPr, 2);
              NLOLine.Update;
            end;
          end; {if LastPR > 0 then}
        end; {With..lONomRec^} 
      end; {if lONomRec <> nil then}
    end; {With.. Node}
  end; {With..Sender as TSBSOutLineB}
end;

//------------------------------------------------------------------------------

procedure TfrmUserProfile.btnSetLevelYesClick(Sender: TObject);
begin
  if NLOLine.SelectedItem >= 0 then
  begin
    SetThisNode(NLOLine.SelectedItem, 1, 0);
    if (FEntryRec.Login=EntryRec^.Login) or (FInterMode) then {* Show effect immedieatley *}
      Send_UpdateList(102);
  end;
end;

//------------------------------------------------------------------------------

procedure TfrmUserProfile.btnSetLevelNoClick(Sender: TObject);
begin
  if NLOLine.SelectedItem >= 0 then
  begin
    SetThisNode(NLOLine.SelectedItem, 0, 0);
    if (FEntryRec.Login=EntryRec^.Login) or (FInterMode) then {* Show effect immedieatley *}
      Send_UpdateList(102);
  end;
end;

//------------------------------------------------------------------------------

procedure TfrmUserProfile.btnExpandlevelClick(Sender: TObject);
begin
  if NLOLine.SelectedItem >= 0 then
    OpenThisNode(NLOLine.SelectedItem, 1);
end;

//------------------------------------------------------------------------------

procedure TfrmUserProfile.btnCollapsLevelClick(Sender: TObject);
begin
  if NLOLine.SelectedItem >= 0 then
    OpenThisNode(NLOLine.SelectedItem, 0);
end;

//------------------------------------------------------------------------------

procedure TfrmUserProfile.btnInteractiveClick(Sender: TObject);
const
  lInterTit: Array[False..True] of Str20 = ('&Interactive','&Normal');
begin
  FInterMode := not FInterMode;
  btnInteractive.Caption := lInterTit[FInterMode];
  mnuInteractive.Caption := btnInteractive.Caption;
  if not FInterMode then
    GetLoginRec(FCurrent_User);
  if FInterMode then
    EntryRec^ := FEntryRec;

  Send_UpdateList(102);
end;

//------------------------------------------------------------------------------

procedure TfrmUserProfile.btnFindClick(Sender: TObject);
var
  lInpOk,
  lFoundOk: Boolean;
  n,
  lStartNode: Integer;
  lSCode,
  lSearchStr: String;
begin
  lSCode := FLastFind;
  lFoundOk := BOff;

  lInpOk := InputQuery('Find Password Setting', 'Please enter the text code you wish to find', lSCode);

  if lInpOk then
  begin
    with NLOLine do
    begin
      FullExpand;
      if SelectedItem < 0 then
        lStartNode := 0
      else
        lStartNode := SelectedItem;
      lSearchStr := Items[lStartNode].Text;

      if Match_Glob(Succ(Length(lSearchStr)), Copy(lSCode,1,30), lSearchStr,lInpOk) then {Jump past the one we are on}
        lStartNode := lStartNode+1;

      FLastFind:=lSCode;

      for n:= lStartNode to ItemCount-1 do
      begin
        Blank(lSearchStr, Sizeof(lSearchStr));
        lSearchStr := Items[n].Text;
        lFoundOk := Match_Glob(Succ(Length(lSearchStr)),Copy(lSCode,1,30),lSearchStr,lInpOk);
        if lFoundOk then
          Break;
      end;

      if lFoundOk then
        SelectedItem := n
      else
        ShowMessage('Unable to locate '+lSCode);
    end;
  end;// if lInpOk then
end;

//------------------------------------------------------------------------------

procedure TfrmUserProfile.FullExBtnClick(Sender: TObject);
begin
  NLOLine.FullExpand;
end;

//------------------------------------------------------------------------------

procedure TfrmUserProfile.FullColBtnClick(Sender: TObject);
begin
  NLOLine.FullCollapse;
end;

//------------------------------------------------------------------------------

function TfrmUserProfile.AddTreeNode(AParentIdx: LongInt;
                                     ALineText: String;
                                     AGrpAry, ALevel: LongInt;
                                     APWNo: SmallInt;
                                     AMode: Byte): Integer;
var
  lONomRec: ^OutNomType;
begin
  Result := -1;
  if ALineText <> 'XNANX' then {* Exclude those which cannot be found *}
  begin
    with NLOLine do
    begin
      New(lONomRec);
      FillChar(lONomRec^,Sizeof(lONomRec^),0);
      with lONomRec^ do
      begin
        OutNomCode := AGrpAry;
        OutDepth := ALevel;
        LastPr := APWNo;
        MoreLink := (AMode=0);
      end;
      Result := AddChildObject(AParentIdx, ALineText, lONomRec);
      if Result >-1 then
      with Items[Result] do
      ShowCheckBox := (APWNo>0);
    end; {With..}
  end;
end;

//------------------------------------------------------------------------------

procedure TfrmUserProfile.BuildTreeGroups(var AGrpAry: LongInt;
                                              AParentIdx: LongInt;
                                              ALevel: LongInt);
var
  lLastIdx: LongInt;
  lPNo: SmallInt;
  lLineText: Str255;
begin
  lLastIdx := AParentIdx;
  while (AGrpAry <= High(PWTreeGrpAry)) do
  begin
    with PWTreeGrpAry[AGrpAry] do
    begin
      if (not Exclude) and (tCaption<>'') then
      begin
        if IsChild = ALevel then
        begin
          lLastIdx := AddTreeNode(AParentIdx, tCaption, AGrpAry, ALevel, 0, 0);

          if WordCnt(PWLink)>0 then
          begin
            if PWLink[1] <> 'X' then
            begin
              lLineText := GetPWText(ExtractWords(1,1,PWLink), lPNo);
              AddTreeNode(lLastIdx, lLineText, 0, ALevel, lPNo, 1);
            end;
          end;
          Inc(AGrpAry);
        end
        else
        begin
          if IsChild > ALevel then {Drop it down a level based on last parent added}
            BuildTreeGroups(AGrpAry, lLastIdx, ALevel+1)
          else//if (not Exclude) and (tCaption<>'') then
            Exit;
        end;
      end
      else
        Inc(AGrpAry);
    end; //with PWTreeGrpAry[AGrpAry] do
  end; {While..}
  NLOLine.TreeReady := BOn;
end; {Proc..}

//------------------------------------------------------------------------------

procedure TfrmUserProfile.GetMoreLinks(AIndex: Integer);
var
  lONomRec: ^OutNomType;
  n,
  lPNo: SmallInt;
  lPWText: Str255;
begin
  with NLOLine do
  begin
    lONomRec := Items[AIndex].Data;
    if lONomRec <> nil then
    begin
      with lONomRec^ do
      begin
        if OutNomCode <> 0 then
        begin
          MoreLink := False;
          with PWTreeGrpAry[OutNomCode] do
          begin
            if (WordCnt(PWLink)>1) then
            begin
              for n:=2 to WordCnt(PWLink) do
              begin
                lPWText := GetPWText(ExtractWords(n,1,PWLink), lPNo);
                AddTreeNode(AIndex, lPWText, 0, OutDepth, lPNo, 1);
              end;
            end;
          end;//with PWTreeGrpAry[OutNomCode] do
        end; //if OutNomCode <> 0 then
      end; //with lONomRec^ do
    end; //if lONomRec <> nil then
  end; {With..}
end;

//------------------------------------------------------------------------------

procedure TfrmUserProfile.UpdateArrayPosition(AIndex, AMode: Integer);
var
  lState: Boolean;
begin
  case AMode of
    0 : FEntryRec.Access[AIndex]:=0;
    1 : FEntryRec.Access[AIndex]:=1;
    2 : begin
            lState := (FEntryRec.Access[AIndex]>0);
            lState := not lState;
            FEntryRec.Access[AIndex] := Ord(lState);
        end;
  end;
  if (FEntryRec.Login = EntryRec^.Login) or (FInterMode) then {* Show effect immedieatley *}
    EntryRec.Access[AIndex]:= FEntryRec.Access[AIndex];

  FModifiedAccessSettings := True;
end;

//------------------------------------------------------------------------------

procedure TfrmUserProfile.OpenThisNode(AIndex, AMode: Integer);
var
  lONomRec: ^OutNomType;
begin
  with NLOLine do
  begin
    if AIndex >= 0 then
    begin
      lONomRec := Items[AIndex].Data;
      if (lONomRec<>nil) then
      with lONomRec^ do
      begin
        if (Items[AIndex].HasItems) then
        begin
          case AMode of
            0  :  Items[AIndex].Collapse;
            1  :  Items[AIndex].Expand;
          end; {Case..}
        end;
      end;{With..}
    end;
  end;{With..}
end;{Proc..}

//------------------------------------------------------------------------------

procedure TfrmUserProfile.SetThisNode(AIndex, AMode, ALevel: Integer);
var
  lONomRec: ^OutNomType;
  lDrawIdxCode: LongInt;
  lFoundOk: Boolean;
begin
  lFoundOk := False;
  with NLOLine do
  begin
    if AIndex>=0 then
    begin
      lONomRec := Items[AIndex].Data;
      if (lONomRec <> nil) then
      with lONomRec^ do
      begin
        if (Items[AIndex].HasItems) then
        begin
          Items[AIndex].Expand;
          lDrawIdxCode:=Items[AIndex].GetFirstChild;
          while (lDrawIdxCode>=0) do
          begin
            if (Items[lDrawIdxCode].HasItems) then
              SetThisNode(lDrawIdxCode, AMode, ALevel+1)
            else
            begin
              lONomRec:=Items[lDrawIdxCode].Data;
              if (lONomRec<>nil) then
              with lONomRec^ do
              begin
                if LastPr > 0 then
                  UpdateArrayPosition(LastPr, AMode);

                if not lFoundOk then
                  lFoundOk := (LastPr>0);
              end;
            end;
            lDrawIdxCode := Items[AIndex].GetNextChild(lDrawIdxCode);
          end; {While..}
        end
        else if LastPr > 0 then
        begin
          if ALevel = 0 then
          begin
            UpdateArrayPosition(LastPr, AMode);
            if (SelectedItem>1) then
              SelectedItem := Pred(SelectedItem)
            else
              SelectedItem := 0;
            SelectedItem := AIndex;
          end
          else
            UpdateArrayPosition(LastPr, AMode);
        end;
      end;{With..}
      Refresh;
    end;
  end;{With..}
end;{Proc..}

//------------------------------------------------------------------------------

procedure TfrmUserProfile.InitAccessSettingTab;
var
  lGrpAry: Integer;
begin
  lGrpAry := 1;
  PrimeTreeGroups(PWTreeGrpAry);
  BuildTreeGroups(lGrpAry, 0, 0);
  FInterMode := False;
end;

//------------------------------------------------------------------------------

procedure TfrmUserProfile.LoadSecurityQuestion;
var
  i: Integer;
begin
  if not pnlSecurityQuestion.Visible then
    Exit;

  cboSecurityQuestion.Clear;
  for i:=Low(SecurityQuestionList) to high(SecurityQuestionList) do
    cboSecurityQuestion.Items.Add(SecurityQuestionList[i]);
end;

//------------------------------------------------------------------------------

procedure TfrmUserProfile.Send_UpdateList(AMode: Integer);
var
  lMessage1: TMessage;
begin
  FillChar(lMessage1, Sizeof(lMessage1), 0);
  with lMessage1 do
  begin
    MSg := WM_FormCloseMsg;
    WParam := AMode;
    LParam := 0;
  end;

  with lMessage1 do
    SendMessage(Application.MainForm.Handle, Msg, WParam, LParam);
end;

//------------------------------------------------------------------------------

procedure TfrmUserProfile.edtPwdInactiveTimeExit(Sender: TObject);
begin
  if (edtPwdInactiveTime.Value >= 0) and (edtPwdInactiveTime.Value <= 999) then
    udUserInactivityDuration.Position := round(edtPwdInactiveTime.Value);
end;

//------------------------------------------------------------------------------

procedure TfrmUserProfile.btnEditColourClick(Sender: TObject);
begin
  ColorDialog.Color := spGDPR.Brush.Color;
  if ColorDialog.Execute then
    spGDPR.Brush.Color := ColorDialog.Color;
end;

//------------------------------------------------------------------------------

//AP 13/11/2017 2018-R1: ABSEXCH-19439:CR: UI and functional changes related to User Profile
procedure TfrmUserProfile.chkHighlightPIIFieldsClick(Sender: TObject);
begin
  btnEditColour.Enabled := chkHighlightPIIFields.Checked;
end;

end.
