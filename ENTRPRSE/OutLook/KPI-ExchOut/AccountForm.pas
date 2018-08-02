unit AccountForm;

interface

uses
  SysUtils, Windows, Messages, Classes, Graphics, Controls, Forms, Dialogs,
  ComCtrls, StdCtrls, Mask, TEditVal, ExtCtrls, SBSPanel, Buttons,
  BorBtns, Menus, Enterprise01_TLB, TCustom, KPICommon;

type
  TfrmAccount = class(TForm)
    PageControl: TPageControl;
    TabSheet2: TTabSheet;
    TabSheet1: TTabSheet;
    TabSheet3: TTabSheet;
    TCNScrollBox: TScrollBox;
    TNHedPanel: TSBSPanel;
    NDateLab: TSBSPanel;
    NDescLab: TSBSPanel;
    NUserLab: TSBSPanel;
    NDatePanel: TSBSPanel;
    NDescPanel: TSBSPanel;
    NUserPanel: TSBSPanel;
    TabSheet4: TTabSheet;
    CDSBox: TScrollBox;
    CDHedPanel: TSBSPanel;
    CDSLab: TSBSPanel;
    CDTLab: TSBSPanel;
    CDULab: TSBSPanel;
    CDBLab: TSBSPanel;
    CDDLab: TSBSPanel;
    CDVLab: TSBSPanel;
    CDMLab: TSBSPanel;
    CDMPanel: TSBSPanel;
    TabSheet5: TTabSheet;
    CLSBox: TScrollBox;
    CLHedPanel: TSBSPanel;
    CLORefLab: TSBSPanel;
    CLDateLab: TSBSPanel;
    CLAmtLab: TSBSPanel;
    CLOSLab: TSBSPanel;
    CLTotLab: TSBSPanel;
    CLYRefLab: TSBSPanel;
    CLDueLab: TSBSPanel;
    CLORefPanel: TSBSPanel;
    CLDatePanel: TSBSPanel;
    CLAMTPanel: TSBSPanel;
    CLOSPAnel: TSBSPanel;
    CLTotPanel: TSBSPanel;
    CLYRefPanel: TSBSPanel;
    CLDuePanel: TSBSPanel;
    CListBtnPanel: TSBSPanel;
    CDListBtnPanel: TSBSPanel;
    TCNListBtnPanel: TSBSPanel;
    SBSPanel1: TSBSPanel;
    TCMScrollBox: TScrollBox;
    SBSPanel2: TSBSPanel;
    Label86: Label8;
    Label87: Label8;
    Label88: Label8;
    ContactF: Text8Pt;
    Addr1F: Text8Pt;
    Addr2F: Text8Pt;
    Addr3F: Text8Pt;
    Addr4F: Text8Pt;
    Addr5F: Text8Pt;
    PhoneF: Text8Pt;
    FaxF: Text8Pt;
    MobileF: Text8Pt;
    SBSPanel3: TSBSPanel;
    Label82: Label8;
    Label83: Label8;
    Label84: Label8;
    Label89: Label8;
    Label810: Label8;
    Label811: Label8;
    Label812: Label8;
    Label813: Label8;
    Label814: Label8;
    Label815: Label8;
    Label816: Label8;
    Label818: Label8;
    Label819: Label8;
    Label841: Label8;
    PayTF: TCurrencyEdit;
    CredStatF: TCurrencyEdit;
    TPrTO: TCurrencyEdit;
    TYTDTO: TCurrencyEdit;
    LYTDTO: TCurrencyEdit;
    CurrBalF: TCurrencyEdit;
    CrLimitF: TCurrencyEdit;
    CommitLF: TCurrencyEdit;
    CredAvailF: TCurrencyEdit;
    StatusF: Text8Pt;
    SBSPanel8: TSBSPanel;
    Label81: Label8;
    Label85: Label8;
    CompF: Text8Pt;
    ACCodeF: Text8Pt;
    SBSPanel4: TSBSPanel;
    TCDScrollBox: TScrollBox;
    SBSPanel5: TSBSPanel;
    Label820: Label8;
    Label821: Label8;
    Comp2F: Text8Pt;
    AcCode2F: Text8Pt;
    SBSPanel6: TSBSPanel;
    Label822: Label8;
    Label823: Label8;
    Label824: Label8;
    DAddr1F: Text8Pt;
    DAddr2F: Text8Pt;
    DAddr3F: Text8Pt;
    DAddr4F: Text8Pt;
    DAddr5F: Text8Pt;
    TOurF: Text8Pt;
    InvTF: Text8Pt;
    SBSPanel7: TSBSPanel;
    Label827: Label8;
    Label829: Label8;
    Label831: Label8;
    Label832: Label8;
    CDRCurrLab: Label8;
    CDRCCLab: Label8;
    Label842: Label8;
    DiscF: Text8Pt;
    CCF: Text8Pt;
    DNomF: Text8Pt;
    AreaF: Text8Pt;
    DepF: Text8Pt;
    DCNomF: Text8Pt;
    CurrF: TSBSComboBox;
    Bevel1: TBevel;
    RepF: Text8Pt;
    Orders: TTabSheet;
    CLOrigPanel: TSBSPanel;
    CLOrigLab: TSBSPanel;
    COSBox: TScrollBox;
    COHedPanel: TSBSPanel;
    COORefLab: TSBSPanel;
    CODateLab: TSBSPanel;
    COAMTLab: TSBSPanel;
    COCosLab: TSBSPanel;
    CODisLab: TSBSPanel;
    COMarLab: TSBSPanel;
    COGPLab: TSBSPanel;
    COORefPanel: TSBSPanel;
    CODatePanel: TSBSPanel;
    COAmtPanel: TSBSPanel;
    COCosPanel: TSBSPanel;
    CODisPanel: TSBSPanel;
    COMarPanel: TSBSPanel;
    COGPPanel: TSBSPanel;
    COListBtnPanel: TSBSPanel;
    TCMPanel: TSBSPanel;
    ClsCP1Btn: TButton;
    CDSPanel: TSBSPanel;
    CDTPanel: TSBSPanel;
    CDUPanel: TSBSPanel;
    CDBPanel: TSBSPanel;
    CDDPanel: TSBSPanel;
    CDVPanel: TSBSPanel;
    CLBotPanel: TSBSPanel;
    TotValPanel: TSBSPanel;
    Label817: Label8;
    TotLab: Label8;
    SBSPanel11: TSBSPanel;
    DueTit: Label8;
    DueLab: Label8;
    SBSPanel13: TSBSPanel;
    StatusTit: Label8;
    StatusLab: Label8;
    AllocPanel: TSBSPanel;
    TotTit: Label8;
    UnalLab: Label8;
    Label834: Label8;
    DMDCNomF: Text8Pt;
    CLStatPanel: TSBSPanel;
    CLStatLab: TSBSPanel;
    Label835: Label8;
    SDDayF: TCurrencyEdit;
    SDDiscF: TCurrencyEdit;
    Def2Page: TTabSheet;
    TabSheet6: TTabSheet;
    Label852: Label8;
    AltCodeF: Text8Pt;
    Label844: Label8;
    EMailF: Text8Pt;
    Label836: Label8;
    PostCF: Text8Pt;
    Bevel4: TBevel;
    Bevel3: TBevel;
    Bevel2: TBevel;
    ConsFLab: TLabel;
    ConsolOrd: TSBSComboBox;
    SBSPanel10: TSBSPanel;
    Label843: Label8;
    emWebPWrdF: Text8Pt;
    emSendRF: TBorCheck;
    emEbF: TBorCheck;
    SBSPanel9: TSBSPanel;
    Label838: Label8;
    Label839: Label8;
    Label840: Label8;
    Label833: Label8;
    BankAF: Text8Pt;
    BankSF: Text8Pt;
    BankRF: Text8Pt;
    RPayF: TSBSComboBox;
    DDModeF: TSBSComboBox;
    SBSPanel12: TSBSPanel;
    VATRNoF: Label8;
    VATNoF: Text8Pt;
    ECMF: TBorCheck;
    VATRF: Label8;
    DefVATF: TSBSComboBox;
    PStaF: TBorCheck;
    Label825: Label8;
    StaF: Text8Pt;
    DCLocnF: Text8Pt;
    Label826: Label8;
    AWOF: TBorCheck;
    FrmDefF: TCurrencyEdit;
    FSetNamF: Text8Pt;
    DefUdF: TSBSUpDown;
    Label828: Label8;
    Label849: Label8;
    AltCode2F: Text8Pt;
    SBSPanel14: TSBSPanel;
    Label850: Label8;
    Label851: Label8;
    Label853: Label8;
    Comp3F: Text8Pt;
    ACCode3F: Text8Pt;
    AltCode3F: Text8Pt;
    SBSPanel15: TSBSPanel;
    Label854: Label8;
    Label855: Label8;
    Label856: Label8;
    Label857: Label8;
    Label858: Label8;
    CCDNameF: Text8Pt;
    CCDCardNoF: Text8Pt;
    CCDIssF: Text8Pt;
    CCDSDateF: TEditDate;
    CCDEDateF: TEditDate;
    cbSendSta: TSBSComboBox;
    cbSendInv: TSBSComboBox;
    Label860: Label8;
    emSendHF: TBorCheck;
    Label861: Label8;
    Label862: Label8;
    Label863: Label8;
    Label865: Label8;
    Bevel5: TBevel;
    VATRegCLab: Label8;
    VATCntryF: TSBSComboBox;
    VATDTF: Text8Pt;
    VATDTLab: Label8;
    VATTMLab: Label8;
    VATTMF: TCurrencyEdit;
    SBSPanel16: TSBSPanel;
    User1F: Text8Pt;
    User2F: Text8Pt;
    User3F: Text8Pt;
    User4F: Text8Pt;
    CTrad1F: Text8Pt;
    CTrad2F: Text8Pt;
    User1Lab: Label8;
    User2Lab: Label8;
    User3Lab: Label8;
    User4Lab: Label8;
    Label830: Label8;
    HOACF: TBorCheck;
    emZipF: TComboBox;
    TagNF: TCurrencyEdit;
    WOrders: TTabSheet;
    JApps: TTabSheet;
    CDEFFPanel: TSBSPanel;
    CDEFFLab: TSBSPanel;
    RetPage: TTabSheet;
    Label1: TLabel;
    lblNoteText: TLabel;
    StatusBtn: TButton;
    StatusPm: TPopupMenu;
    SeeNotes1: TMenuItem;
    OnHold1: TMenuItem;
    Closed1: TMenuItem;
    N1: TMenuItem;
    Open1: TMenuItem;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure ClsCP1BtnClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure StatusBtnClick(Sender: TObject);
    procedure StatusMenuClick(Sender: TObject);
    procedure TCMScrollBoxDblClick(Sender: TObject);
  private
    FAccount:     IAccount;
    FAccountCode: WideString;
    FDataPath:    WideString;
    FIsCust:      boolean;
    FMode:        WideString; // "Customer" or "Supplier"
    FToolkit:     IToolkit2;
    FToolkitOpen: boolean;
    FCurrency: integer;
    FNoteText: WideString;
    FUserID: WideString;
    procedure ChangeCaption;
    function  FindAccount: boolean;
    procedure HideTabs;
    function  OpenCOMToolkit: boolean;
    procedure SetAccountStatus(AStatus: integer);
    procedure SetCurrency(const Value: integer);
  public
    procedure PopulateMainTab;
    property AccountCode: WideString read FAccountCode write FAccountCode;
    property Currency: integer read FCurrency write SetCurrency;
    property DataPath: WideString read FDataPath write FDataPath;
    property Mode: WideString read FMode write FMode;
    property NoteText: WideString read FNoteText write FNoteText;
    property UserID: WideString read FUserID write FUserID;
  end;

procedure ShowAccountForm(ADataPath: WideString; AnAccountCode: WideString; AMode: WideString; ACurrency: integer; ANoteText: WideString;
          AUserID: WideString);

Implementation

uses CTKUtil;

Const
  TAB_MAIN        =  0;
  TAB_DEFAULTS    =  1;
  TAB_ECOMM       =  2;
  TAB_NOTES       =  3;
  TAB_DISCOUNTS   =  4;
  TAB_LEDGER      =  5;
  TAB_ORDERS      =  6;
  TAB_WORKSORDERS =  7;
  TAB_JOBAPPS     =  8;
  TAB_RETURNS     =  9;

var
  frmAccount: TfrmAccount;

{$R *.DFM}

{$R WINXPMAN.RES}

procedure ShowAccountForm(ADataPath: WideString; AnAccountCode: WideString; AMode: WideString; ACurrency: integer; ANoteText: WideString;
                          AUserID: WideString);
begin
  if not assigned(frmAccount) then
    frmAccount := TfrmAccount.Create(application);

  with frmAccount do begin
    DataPath    := ADataPath;
    AccountCode := AnAccountCode;
    Mode        := AMode;
    Currency    := ACurrency;
    NoteText    := ANoteText;
    UserID      := AUserID;
    PopulateMainTab;
    Show;
  end;
end;

function GetScreenPoint(AControl: TControl): TPoint;
// translates the Control's idea of where (0,0) is into screen co-ordinates.
// As Popup requires screen coordinates, this allows me to position a popup
// menu exactly over the top-left pixel of a button.
begin
  result := point(0,0);
  result := AControl.ClientToScreen(result);
end;

procedure MenuPopup(APopupMenu: TPopupMenu; AControl: TControl);
// popup a menu positioned exactly on the top-left pixel of the Control.
// Popup requires screen coordinates so we call GetScreenPoint to get
// the position of the control.
begin
  APopupMenu.PopUp(GetScreenPoint(AControl).x, GetScreenPoint(AControl).y);
end;


procedure TfrmAccount.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  action   := caFree;
  frmAccount := nil;
end;

procedure TfrmAccount.ClsCP1BtnClick(Sender: TObject);
begin
  close;
end;

procedure TfrmAccount.FormCreate(Sender: TObject);
begin
  HideTabs;
end;

procedure TfrmAccount.HideTabs;
var
  i: integer;
begin
  for i := 0 to PageControl.PageCount - 1 do
    PageControl.Pages[i].TabVisible := false;

  PageControl.Pages[TAB_MAIN].TabVisible := true;
end;

procedure TfrmAccount.ChangeCaption;
begin
  caption := format('%s Record - %s, %s', [FMode, FAccount.acCode, trim(FAccount.acCompany)]);
end;

function TfrmAccount.OpenCOMToolkit: boolean;
begin
  FToolkit := OpenToolkit(FDataPath, true) as IToolkit2; // use backdoor
  result := assigned(FToolkit);
end;

function AccStatus(AStatus: integer): string;
const
  AccStat: array[0..3] of string = ('', '* see notes', '* On Hold!', '* Closed! *');
begin
  result := AccStat[AStatus];
end;

procedure TfrmAccount.PopulateMainTab;
var
  res: integer;

  function Convert(Value: double): double;
  begin
    if FCurrency = 0 then begin
      result := Value;
      EXIT;
    end;

    with FToolkit.Functions do
      result := entConvertAmount(Value, 0, FCurrency, 0);
  end;
begin
  if not OpenCOMToolkit then exit;
  if not FindAccount then exit;
  FIsCust := FMode = 'Customer';

  ChangeCaption;
  lblNoteText.caption := FNoteText;

  try
    with FAccount, FToolkit do begin
      AcCodeF.Text    := acCode;
      AltCodeF.Text   := acAltCode;
      CompF.Text      := acCompany;
      ContactF.Text   := acContact;
      Addr1F.Text     := acAddress[1];
      Addr2F.Text     := acAddress[2];
      Addr3F.Text     := acAddress[3];
      Addr4F.Text     := acAddress[4];
      Addr5F.Text     := acAddress[5];
      PostCF.Text     := acPostCode;
      EMailF.Text     := acEmailAddr;
      PhoneF.Text     := acPhone;
      FaxF.Text       := acFax;
      MobileF.Text    := acPhone2;
      StatusF.Text    := AccStatus(Ord(acAccStatus));
      PayTF.Value     := acPayTerms;
      CredStatF.Value := acCreditStatus;

      // Sales for current F6 period
      acHistory.acPeriod := 0;
      acHistory.acYear := 0;
      case FIsCust of
        true:  TPrTO.Text := Format ('%0.2n', [convert(acHistory.acSales)]);
        false: TPrTo.Text := Format ('%0.2n', [convert(acHistory.acCosts)]);
      end;

      // Total Sales for the F6 Year up to the F6 Period
      acHistory.acPeriod := 100 + SystemSetup.ssCurrentPeriod;
      acHistory.acYear := 0;
      case FIsCust of
        true:  TYTDTO.Text := Format ('%0.2n', [convert(acHistory.acSales)]);
        false: TYTDTO.Text := Format ('%0.2n', [convert(acHistory.acCosts)]);
      end;

      // Total Sales for the previous Year
      acHistory.acPeriod := -99;
      acHistory.acYear := -1;
      case FIsCust of
        true:  LYTDTO.Text := Format ('%0.2n', [convert(acHistory.acSales)]);
        false: LYTDTO.Text := Format ('%0.2n', [convert(acHistory.acCosts)]);
      end;

      CrLimitF.Text := Format ('%0.2n', [convert(acCreditLimit)]);

      // Committed Balance for Current F6 Period
      acHistory.acPeriod := 0;
      acHistory.acYear := 0;
      CommitLF.Text := Format ('%0.2n', [convert(acHistory.acCommitted)]);

      // YTD Balance for Current F6 Period/Year
      acHistory.acPeriod := 100 + SystemSetup.ssCurrentPeriod;
      acHistory.acYear := 0;
      case FIsCust of
        true:  CurrBalF.Text := Format ('%0.2n', [convert(acHistory.acBalance)]);
        false: CurrBalF.Text := Format ('%0.2n', [convert(-acHistory.acBalance)]);
      end;

      // Credit Available - Credit Limit - Balance - Committed
      case FIsCust of
        true:  CredAvailF.Text := Format ('%0.2n', [convert(acCreditLimit - acHistory.acBalance - acHistory.acCommitted)]);
        false: CredAvailF.Text := Format ('%0.2n', [convert(acCreditLimit + acHistory.acBalance + acHistory.acCommitted)]);
      end;

      StatusBtn.Enabled := false;
      with UserProfile do begin
        Index := usIdxLogin;
        res := GetEqual(BuildUserIDIndex(FUserId));
        if res = 0 then
            case FMode[1] of
              'C': StatusBtn.Enabled := upSecurityFlags[142] = srAccess; // can change customer status
              'S': StatusBtn.Enabled := upSecurityFlags[181] = srAccess; // can change supplier status
            end;
      end;
    end;
  finally
    FToolkit.CloseToolkit;
    FAccount := nil;
    FToolkit := nil;
  end;
end;

function TfrmAccount.FindAccount: boolean;
var
  res: integer;
begin
  FAccount := nil;

  if FMode = 'Customer' then
    FAccount := FToolkit.Customer
  else
    FAccount := FToolkit.Supplier;

  with FAccount do begin
    Index := acIdxCode;
    res := GetEqual(BuildCodeIndex(FAccountCode));
    if res <> 0 then begin
      ShowMessage(format('Unable to access account record for %s', [FAccountCode]));
      result := false;
    end
    else
      result := true;
  end;
end;

procedure TfrmAccount.SetCurrency(const Value: integer);
begin
  FCurrency := Value;
end;

procedure TfrmAccount.StatusBtnClick(Sender: TObject);
begin
  MenuPopup(StatusPm, StatusBtn);
end;

procedure TfrmAccount.StatusMenuClick(Sender: TObject);
begin
  SetAccountStatus(TMenuItem(Sender).ImageIndex);
end;

procedure TfrmAccount.SetAccountStatus(AStatus: integer);
var
  res: integer;
begin
  if not OpenCOMToolkit then exit;
  if not FindAccount then exit;
  try
    with FAccount.Update do begin
      acAccStatus := TAccountStatus(AStatus);
      res := Save;
      if res <> 0 then
        ShowMessage(format('Unable to update account "%s"', [trim(acCode)]))
      else
        StatusF.Text := AccStatus(AStatus);
    end;
  finally
    FToolkit.CloseToolkit;
    FAccount := nil;
    FToolkit := nil;
  end;
end;

procedure TfrmAccount.TCMScrollBoxDblClick(Sender: TObject);
begin
  TCMScrollBox.Height := TCMScrollBox.Height + 10;
  PageControl.Height  := PageControl.Height + 10;
  Height              := Height + 10;
  ShowDLLDetails(Sender, TCMScrollBox.Color, true);
  if lblNoteText.Caption <> '' then lblNoteText.Visible := false;
end;

initialization
  frmAccount := nil;

end.



