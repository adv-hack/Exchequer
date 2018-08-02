{$A+,B-,C+,D+,E-,F-,G+,H+,I+,J+,K-,L+,M-,N+,O-,P+,Q-,R-,S-,T-,U-,V+,W-,X+,Y+,Z1}
{$MINSTACKSIZE $00004000}
{$MAXSTACKSIZE $00100000}
{$IMAGEBASE $00400000}
{$APPTYPE GUI}
unit admnform;

{ prutherford440 09:36 30/10/2001: Disabled Byte Alignment in Delphi 6.0 }
{$ALIGN 1}  { Variable Alignment Disabled }


interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ComCtrls, StdCtrls, ExtCtrls, Menus, ImgList, AuthObjs, OleServer,
  Enterprise04_TLB, Buttons, TreeSet, vcombo, Spin, Mask, TEditVal;

const
  SendOpts : Array[0..1] of Char = ('A','B');
  WANT_VIRTUAL_REQUESTS = True;

type

  TfrmAuthAdmin = class(TForm)
    Panel2: TPanel;
    btnOK: TButton;
    btnCancel: TButton;
    btnAdd: TButton;
    btnRemove: TButton;
    ImageList1: TImageList;
    mnuAdd: TPopupMenu;
    Company1: TMenuItem;
    User1: TMenuItem;
    Authorizer1: TMenuItem;
    Notebook1: TNotebook;
    PageControl1: TPageControl;
    tabUserSet: TTabSheet;
    Panel1: TPanel;
    edtUserId: TEdit;
    edtUserName: TEdit;
    edtUserEmail: TEdit;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Panel3: TPanel;
    Label5: TLabel;
    Label6: TLabel;
    edtFloorLimit: TEdit;
    edtAuthAmount: TEdit;
    grpEmailType: TRadioGroup;
    btnEdit: TButton;
    PageControl2: TPageControl;
    tabGlobal1: TTabSheet;
    Label1: TLabel;
    pgcAuth: TPageControl;
    tabAuthDet: TTabSheet;
    tabPermissions: TTabSheet;
    GroupBox1: TGroupBox;
    edtAuthName: TEdit;
    edtAuthEmail: TEdit;
    Label7: TLabel;
    Label8: TLabel;
    GroupBox2: TGroupBox;
    edtAuthCode: TEdit;
    Label9: TLabel;
    Label10: TLabel;
    edtAuthMax: TEdit;
    GroupBox3: TGroupBox;
    chkSQU: TCheckBox;
    chkPQU: TCheckBox;
    chkPOR: TCheckBox;
    chkPIN: TCheckBox;
    tabDefaults: TTabSheet;
    GroupBox5: TGroupBox;
    edtAdminEmail: TEdit;
    Label11: TLabel;
    GroupBox6: TGroupBox;
    edtFrequency: TEdit;
    edtTimeOut: TEdit;
    Label12: TLabel;
    Label14: TLabel;
    GroupBox7: TGroupBox;
    Label15: TLabel;
    edtOffStart: TEdit;
    Label16: TLabel;
    edtOffFinish: TEdit;
    PageControl3: TPageControl;
    tabRequest: TTabSheet;
    GroupBox8: TGroupBox;
    edtEARID: TEdit;
    edtEarOurRef: TEdit;
    edtEarUserID: TEdit;
    edtEarValue: TEdit;
    edtEarTime: TEdit;
    Label17: TLabel;
    Label18: TLabel;
    Label19: TLabel;
    Label20: TLabel;
    Label21: TLabel;
    PageControl4: TPageControl;
    tabCoDefaults: TTabSheet;
    tabCoForms: TTabSheet;
    GroupBox9: TGroupBox;
    edtSQUForm: TEdit;
    edtPQUForm: TEdit;
    edtPORForm: TEdit;
    edtPINForm: TEdit;
    Label22: TLabel;
    Label23: TLabel;
    Label24: TLabel;
    Label25: TLabel;
    GroupBox10: TGroupBox;
    chkCoSQU: TCheckBox;
    chkCoPQU: TCheckBox;
    chkCoPOR: TCheckBox;
    chkCoPIN: TCheckBox;
    btnClose: TButton;
    panelTree: TPanel;
    tvAdmin: TTreeView;
    OpenDialog1: TOpenDialog;
    chkActive: TCheckBox;
    tabMsg: TTabSheet;
    GroupBox11: TGroupBox;
    memMsg: TMemo;
    tabSecurity: TTabSheet;
    Panel4: TPanel;
    Label26: TLabel;
    edtAdminPword: TEdit;
    GroupBox12: TGroupBox;
    rbAuthOnlyA: TRadioButton;
    rbAuthOnlyM: TRadioButton;
    rbAuthAndApprove: TRadioButton;
    chkApprovalOnly: TCheckBox;
    edtEARAuth: TEdit;
    edtEarStatus: TEdit;
    Label27: TLabel;
    Label28: TLabel;
    GroupBox13: TGroupBox;
    memAppMsg: TMemo;
    edtEARApp: TEdit;
    Label29: TLabel;
    tabPrinting: TTabSheet;
    GroupBox14: TGroupBox;
    chkAllowPrint: TCheckBox;
    Timer1: TTimer;
    PopupMenu1: TPopupMenu;
    Add1: TMenuItem;
    Remove1: TMenuItem;
    Edit1: TMenuItem;
    Company2: TMenuItem;
    Authoriser1: TMenuItem;
    User2: TMenuItem;
    chkPinFloor: TCheckBox;
    MainMenu1: TMainMenu;
    tabUserDef: TTabSheet;
    Panel5: TPanel;
    lblDefaultApprover: TLabel;
    lblDefaultAuthoriser: TLabel;
    cbDefaultApprover: TComboBox;
    cbDefaultAuthoriser: TComboBox;
    TabSheet1: TTabSheet;
    GroupBox15: TGroupBox;
    chkCompressAttachments: TCheckBox;
    N1: TMenuItem;
    Help1: TMenuItem;
    AboutAuthorise1: TMenuItem;
    Panel6: TPanel;
    Label31: TLabel;
    cbAuthDefaultAuth: TComboBox;
    Label32: TLabel;
    Label33: TLabel;
    vcbRequest: TVirtualComboBox;
    btnFindRequest: TButton;
    PageControl5: TPageControl;
    TabSheet3: TTabSheet;
    GroupBox4: TGroupBox;
    Name: TLabel;
    Password: TLabel;
    Label13: TLabel;
    Label30: TLabel;
    edtSysName: TEdit;
    edtSysPWord: TEdit;
    edtSysEmail: TEdit;
    edtSysServer: TEdit;
    chkUseMapi: TCheckBox;
    TabSheet4: TTabSheet;
    GroupBox16: TGroupBox;
    Label34: TLabel;
    Label35: TLabel;
    Label36: TLabel;
    Label37: TLabel;
    edtSysNameOut: TEdit;
    edtSysPWordOut: TEdit;
    edtSysEmailOut: TEdit;
    edtSysServerOut: TEdit;
    chkUseMapiOut: TCheckBox;
    Panel7: TPanel;
    lblAltAuth: TLabel;
    cbAlternate: TComboBox;
    spAlt: TSpinEdit;
    Label39: TLabel;
    Label40: TLabel;
    cbAltHoursDays: TComboBox;
    Label38: TLabel;
    chkAuthOnConvert: TCheckBox;
    Label41: TLabel;
    Label42: TLabel;
    edtPINInterval: TCurrencyEdit;
    udPINInterval: TUpDown;
    edtPINTolerance: TCurrencyEdit;
    Button1: TButton;
    Button2: TButton;
    Button3: TButton;
    Button4: TButton;
    btnExport: TButton;
    dlgExport: TSaveDialog;
    procedure btnAddMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure tvAdminChange(Sender: TObject; Node: TTreeNode);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure User1Click(Sender: TObject);
    procedure btnEditClick(Sender: TObject);
    procedure btnOKClick(Sender: TObject);
    procedure btnCancelClick(Sender: TObject);
    procedure btnCloseClick(Sender: TObject);
    procedure Authorizer1Click(Sender: TObject);
    procedure btnRemoveClick(Sender: TObject);
    procedure Company1Click(Sender: TObject);
    procedure SpeedButton1Click(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure edtAuthCodeEnter(Sender: TObject);
    procedure edtAuthCodeExit(Sender: TObject);
    procedure Notebook1MouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure FormActivate(Sender: TObject);
    procedure chkApprovalOnlyClick(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure FormKeyPress(Sender: TObject; var Key: Char);
    procedure Timer1Timer(Sender: TObject);
    procedure tvAdminExpanded(Sender: TObject; Node: TTreeNode);
    procedure tvAdminCollapsed(Sender: TObject; Node: TTreeNode);
    procedure tvAdminKeyUp(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure Notebook1PageChanged(Sender: TObject);
    procedure PageControl1Change(Sender: TObject);
    procedure Help1Click(Sender: TObject);
    procedure AboutAuthorise1Click(Sender: TObject);
    function vcbRequestGetFirst(Sender: TObject; AList: TStrings;
      DCount: Integer): Boolean;
    function vcbRequestGetLast(Sender: TObject; AList: TStrings;
      DCount: Integer): Boolean;
    function vcbRequestGetNextPage(Sender: TObject; AList: TStrings;
      DCount: Integer): Boolean;
    function vcbRequestGetPrevPage(Sender: TObject; AList: TStrings;
      DCount: Integer): Boolean;
    function vcbRequestGetNext(Sender: TObject;
      var DataString: String): Boolean;
    function vcbRequestGetPrev(Sender: TObject;
      var DataString: String): Boolean;
    function vcbRequestShow(Sender: TObject; AList: TStrings;
      DCount: Integer; const FindString: String): Boolean;
    procedure vcbRequestChange(Sender: TObject);
    procedure tvAdminMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure tvAdminAdvancedCustomDrawItem(Sender: TCustomTreeView;
      Node: TTreeNode; State: TCustomDrawState; Stage: TCustomDrawStage;
      var PaintImages, DefaultDraw: Boolean);
    procedure tvAdminCustomDraw(Sender: TCustomTreeView;
      const ARect: TRect; var DefaultDraw: Boolean);
    procedure vcbRequestEnter(Sender: TObject);
    procedure btnFindRequestClick(Sender: TObject);
    procedure edtPINToleranceExit(Sender: TObject);
    procedure FormDblClick(Sender: TObject);
    procedure btnExportClick(Sender: TObject);
  private
    { Private declarations }
    AdminObject : TPaEARGenerator;
    CurrentSearchString : string;
    WasSelected, WasCurrentRequest : integer;
    FCurrentCompany, FReqCompany : string;
    DataChanged : Boolean;
    PasswordOK : Boolean;
    WantLock : Boolean;
    Settings : TTreeSettings;
    FirstLoad : Boolean;

    VirtualRequests : Boolean;
    CurrentRequestParent, CurrentRequestNode, CurrentCoNode, PrevRequestNode : TTreeNode;
    ReqList : TStringList;
    MaxRequestsBeforeVirtual : SmallInt;
    CurrentEAR, VisibleEar : String;
    RequestsExpanded : Boolean;
    ScrollRect : TRect;
    OldReqTop : integer;
    PaintCount : integer;
    procedure FillTree;
    procedure FormToUser;
    procedure UserToForm;
    procedure LoadUsers(const WhichComp : string; CompNode : TTreeNode);

    procedure FormToAuth;
    procedure AuthToForm;
    procedure LoadAuthorizers(const WhichComp : string; CompNode : TTreeNode);

    procedure FormToSys;
    procedure SysToForm;

    procedure FormToSysOut;
    procedure SysOutToForm;

    procedure FormToRequest;
    procedure RequestToForm;
    procedure LoadRequests(const WhichComp : string; CompNode : TTreeNode);
    procedure ExpandRequests(const WhichComp : string; CompNode : TTreeNode);

    procedure FormToCompany;
    procedure CompanyToForm;

    procedure SelectGlobal;
    procedure SelectCompany;
    procedure SelectAuth;
    procedure SelectUser;
    procedure SelectRequest;
    procedure SelectRequestFromCombo(WantToDelete : Boolean = False);

    procedure SetCurrentCompany(Node : TTreeNode);
    procedure SetCurrentCompanyString(const s : string);

    procedure DisableControls;
    procedure EnableControls;

    procedure SystemDefaults;
    function PickCompany : Boolean;

    procedure InsertNode(WhichType : integer; const Name : string);

    function CurrentTypeString : ShortString;
    function PickUser(IsAuthoriser : Boolean = False) : ShortString;
    procedure DoCancel;

    procedure SetAuthAmountBox(Enable : Boolean);
    procedure SaveState(Node : TTreeNode; State : Boolean);
    procedure LoadAuthNames(WhichCompany, DefName : string; AList : TComboBox;
                                      AllowApprovers : Boolean; IsAuth : Boolean = False);
    procedure DoHelp;
    function GetHelpContext : integer;
    function AuthCodeExists : Boolean;
    procedure SetComboPos;
    procedure FindRequest(const WhichRequest : string);
  public
    { Public declarations }
    property CurrentCompany : string read FCurrentCompany write SetCurrentCompanyString;
  end;

var
  frmAuthAdmin: TfrmAuthAdmin;

  procedure ShowAuthAdmin; export;

implementation

uses
  AuthVar, AddComp, pword, KeyPress, about, FindReq, StrUtil, Crypto, FileUtil, APIUtil;



{$R *.DFM}

procedure ShowAuthAdmin;
begin
  with TfrmAuthAdmin.Create(nil) do
  begin
    Try
      if PasswordOK then
        ShowModal;
    Finally
      Free;
    End;
  end;
end;

procedure TfrmAuthAdmin.btnAddMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
var
  P : TPoint;
begin
{Mouse down on the add button - show the popup menu to let the user select
what to add}

  //If no companies yet then can only add a company
  User1.Enabled := tvAdmin.Items.Count > 1;
  Authorizer1.Enabled := User1.Enabled;

  //Find position for popup
  P.x := btnAdd.Left;
  P.y := btnAdd.Top;
  P := ClientToScreen(P);
  mnuAdd.Popup(P.x + 1, P.y + 1);
end;

procedure TfrmAuthAdmin.tvAdminChange(Sender: TObject; Node: TTreeNode);
var
  i : integer;
begin
  {Called when a different item is selected in the tree view - we need
   to display the appropriate details for the item that is selected}
  if Assigned(Node) then
  begin
    WasSelected := Node.AbsoluteIndex;
    i := Integer(Node.Data);
    if (i >= 0) and (i < 5) then
      Notebook1.PageIndex := i
    else
      Notebook1.PageIndex := 5;



    if Node.Level <> 1 then
      Label1.Caption := CurrentTypeString + Node.Text
    else
      Label1.Caption := '';

    //Enable buttons as appropriate
    btnRemove.Enabled := btnAdd.Enabled and ((Node.Level = 2) or
                          (VirtualRequests and (Node.Text = 'Requests')) or
                         ((Node.Level = 0) and (Node.Text <> 'Global Settings')));

    if not WantLock then
      btnEdit.Enabled := NoteBook1.PageIndex in [PaTypeGlob, PaTypeComp, PaTypeAuth, PaTypeUser];

    SetCurrentCompany(Node);

    //Load and display details for appropriate item
    Case i of
      PaTypeGlob    : SelectGlobal;
      PaTypeComp    : SelectCompany;
      PaTypeAuth    : SelectAuth;
      PaTypeUser    : SelectUser;
      PaTypeRequest : SelectRequest;
    end; //case
  end;
  tvAdmin.Invalidate;
  tvAdmin.HelpContext := GetHelpContext;
end;

procedure TfrmAuthAdmin.FillTree;
var
  RootNode : TTreeNode;
  Comp : string[6];
  Res : SmallInt;
  TreeSet : TCoTreeObject;
begin
//Called on startup to load the treeview
  Timer1.Enabled := False;
  if Assigned(CurrentRequestNode) then
    WasCurrentRequest := CurrentRequestNode.AbsoluteIndex
  else
    WasCurrentRequest := 0;
  with tvAdmin do
  begin
    Items.BeginUpdate;
    Items.Clear;

    RootNode := tvAdmin.Items.Add(nil, 'Authorisation System Settings');
    RootNode.ImageIndex := 0;
    RootNode.Data := Pointer(PaTypeGlob);

    Res := AdminObject.CompanyParams.GetFirst;

    while Res = 0 do
    begin
      Comp := AdminObject.CompanyParams.Company;

      RootNode := tvAdmin.Items.Add(nil, Comp);
      if FirstLoad then
      begin
        TreeSet := TCoTreeObject.Create;

        Settings.Add(Comp);
      end
      else
        Settings.Company := Comp;


      RootNode.ImageIndex := 1;
      RootNode.SelectedIndex := 1;
      RootNode.Data := Pointer(PaTypeComp);

      LoadAuthorizers(Comp, RootNode);
      LoadUsers(Comp, RootNode);
      LoadRequests(Comp, RootNode);

      if not FirstLoad then
        if Settings.CoExpanded then
          RootNode.Expand(False);

      Res := AdminObject.CompanyParams.GetNext;
    end;
    Items.EndUpdate;
  end;//with tvAdmin

  ActiveControl := tvAdmin;
  tvAdmin.Selected := tvAdmin.Items[WasSelected];
  if WasCurrentRequest > 0 then
    CurrentRequestNode := tvAdmin.Items[WasCurrentRequest];
  SetCurrentCompany(tvAdmin.Selected);
  Timer1.Enabled := False;
end;


procedure TfrmAuthAdmin.FormCreate(Sender: TObject);
begin
  if GetWindowsVersion >= wvVista then
  begin
    Constraints.MaxWidth := 700;
    Constraints.MaxHeight := 406;
    Constraints.MinWidth := 700;
    Constraints.MinHeight := 406;
    Width :=  700;
    Height := 406;
  end;
  PaintCount := 0;
//  vcbRequest.Height := 18;
  CurrentRequestParent := nil;
  CurrentRequestNode := nil;
  CurrentCoNode := nil;
  RequestsExpanded := False;
  MaxRequestsBeforeVirtual := 10;
  ReqList := TStringList.Create;
  Settings := TTreeSettings.Create;
  StartToolkit;
  PasswordOK := True;
  AdminObject := TPaEARGenerator.Create;
  AdminObject.OpenFiles;
  SystemDefaults;
  PasswordOK := CheckPassword(UpperCase(AdminObject.GlobalParams.AdminPassword));

  if PasswordOK then
  begin
    WasSelected := 0;
    FirstLoad := True;
    FillTree;
    FirstLoad := False;
    if tvAdmin.Items.Count > 1 then
      if tvAdmin.Items[1].Data = Pointer(PaTypeComp) then
        CurrentCompany := tvAdmin.Items[1].Text;
    DisableControls;
    Caption := 'Exchequer Authoris-e Administration ' + AdminObject.Version;
    WantLock := False;
    edtPINTolerance.DisplayFormat := '###,###,##0.00';
    Timer1.Enabled := True;
    ChangeCryptoKey(19701115);
  end
  else
    Close;


//  edtPINInterval.DisplayFormat := '###0';

end;

procedure TfrmAuthAdmin.FormDestroy(Sender: TObject);
begin
  if Assigned(AdminObject) then
  begin
    AdminObject.CloseFiles;
    AdminObject.Free;
  end;
  EndToolkit;
  if Assigned(Settings) then
  begin
    Settings.Free;
  end;
  if Assigned(ReqList) then
    ReqList.Free;
end;

procedure TfrmAuthAdmin.User1Click(Sender: TObject);
var
  NewUser : string;
  EmAddress : string;
  FullName : String;
  Res : SmallInt;
begin
  if CurrentCompany <> '' then
  begin
    NewUser := PickUser;
    if NewUser <> '' then
    begin
      AdminObject.CompanyCode := CurrentCompany;
      NewUser := AdminObject.AddUser(CurrentCompany, NewUser);
      EmAddress := AdminObject.EntUserEmail(NewUser);
      FullName := AdminObject.EntUserFullName(NewUser);
      if (EmAddress <> '') or (FullName <> '') then
      begin
        Res := AdminObject.User.GetEqual(NewUser, True);
        if Res = 0 then
        begin
          if EmAddress <> '' then
            AdminObject.User.UserEmail := EmAddress;
          if FullName <> '' then
            AdminObject.User.UserName := FullName;
          AdminObject.User.Save;
        end;
      end;

      Res := AdminObject.User.GetEqual(NewUser, True);
      if Res = 0 then
      begin
        Res := AdminObject.Authorizer.GetEqual(NewUser, False);
        if Res = 0 then
          AdminObject.User.AuthAmount := AdminObject.Authorizer.MaxAuthAmount;
        AdminObject.User.Save;
      end;

      InsertNode(PaTypeUser, NewUser);
      btnEditClick(Self);
      PageControl1.ActivePage := tabUserSet;
      if Trim(edtUserName.Text) = '' then
        ActiveControl := edtUserName
      else
      if Trim(edtUserEmail.Text) = '' then
        ActiveControl := edtUserEmail
      else
        ActiveControl := edtFloorLimit;
    end;

  end;
end;

procedure TfrmAuthAdmin.btnEditClick(Sender: TObject);
begin
  EnableControls;
  WantLock := True;
{  if (Integer(tvAdmin.Selected.Data) <> paTypeRequest) or not VirtualRequests then
    tvAdminChange(tvAdmin, tvAdmin.Selected);}
end;

procedure TfrmAuthAdmin.FormToUser;
var
  Res : SmallInt;
begin
  with AdminObject.User do
  begin
    UserID := edtUserID.Text;
    UserName := edtUserName.Text;
    UserEmail := edtUserEmail.Text;

    FloorLimit := StrTofloat(edtFloorLimit.Text);
    AuthAmount := StrTofloat(edtAuthAmount.Text);

    if FloorLimit < AuthAmount then
      raise Exception.Create('Authorisation amount cannot be higher than floor limit');

    SendOptions := SendOpts[grpEmailType.ItemIndex];

    DefaultApprover := cbDefaultApprover.Text;
    if DefaultApprover = defNone then
      DefaultApprover := '';
    DefaultAuthoriser := cbDefaultAuthoriser.Text;
    if DefaultAuthoriser = defNone then
      DefaultAuthoriser := '';

  end;
end;

procedure TfrmAuthAdmin.UserToForm;
var
  Res : SmallInt;
begin
  SelectCompany; //we need to make sure we have the current company settings;
  with AdminObject.User do
  begin
    edtUserID.Text := UserID;
    edtUserName.Text := UserName;
    edtUserEmail.Text := UserEmail;

    edtFloorLimit.Text := Format('%9.2f', [FloorLimit]);
    edtAuthAmount.Text := Format('%9.2f', [AuthAmount]);

    if SendOptions = 'A' then
      grpEmailType.ItemIndex := 0
    else
      grpEmailType.ItemIndex := 1;


    LoadAuthNames(Company, DefaultApprover, cbDefaultApprover, True);
    LoadAuthNames(Company, DefaultAuthoriser, cbDefaultAuthoriser, False);

    if not rbAuthAndApprove.checked then
    begin
      cbDefaultApprover.Visible := False;
      lblDefaultApprover.Visible := False;
      cbDefaultAuthoriser.Top := 37;
      lblDefaultAuthoriser.Top := cbDefaultAuthoriser.Top + 4;
    end
    else
    begin
      cbDefaultApprover.Visible := True;
      lblDefaultApprover.Visible := True;
      cbDefaultAuthoriser.Top := 52;
      lblDefaultAuthoriser.Top := cbDefaultAuthoriser.Top + 4;
    end;

    Res := AdminObject.Authorizer.GetEqual(UserID);
    if Res = 0 then
    begin
      edtAuthAmount.Enabled := False;
      edtAuthAmount.Color := clBtnFace;
    end
    else
    begin
      edtAuthAmount.Color := clWindow;
      edtAuthAmount.Enabled := True;
    end;

  end;
end;

procedure TfrmAuthAdmin.FormToAuth;
var
  Res : SmallInt;
begin

  with AdminObject.Authorizer do
  begin
    Name := edtAuthName.Text;
    DisplayEmail := edtAuthEmail.Text;
    Email := LowerCase(edtAuthEmail.Text);
    AuthCode := edtAuthCode.Text;

    MaxAuthAmount := StrToFloat(edtAuthMax.Text);

    AuthSQU := chkSQU.Checked;
    AuthPQU := chkPQU.Checked;
    AuthPOR := chkPOR.Checked;
    AuthPIN := chkPIN.Checked;
    Active := chkActive.Checked;

    Alternate := cbAlternate.Items[cbAlternate.ItemIndex];

    Case cbAltHoursDays.ItemIndex of
      0 : AltAfter := spAlt.Value;
      1 : AltAfter := spAlt.Value * 24;
    end;

    AltHours := cbAltHoursDays.ItemIndex = 0;

    if (Trim(AuthCode) = '') and Active then
    begin
      ShowMessage('Authoriser cannot be active until a code has been set');
      Active := False;
      chkActive.Checked := False;
    end;
    ApprovalOnly := chkApprovalOnly.Checked;

    Res := AdminObject.User.GetEqual(Trim(Name), True);
    if Res = 0 then
    begin
      AdminObject.User.AuthAmount := MaxAuthAmount;
      if AdminObject.User.AuthAmount > AdminObject.User.FloorLimit then
      begin
        ShowMessage('The floor limit for user ' + Trim(Name) + ' has been adjusted'#10 +
                     'so that it is not less than the authorisation amount.');
        AdminObject.User.FloorLimit := AdminObject.User.AuthAmount;
      end;

      AdminObject.User.Save;
    end;

    DefaultAuthoriser := cbAuthDefaultAuth.Text;
    if DefaultAuthoriser = defNone then
      DefaultAuthoriser := '';

     CompressAttachments := chkCompressAttachments.Checked;
  end;

  if chkActive.Checked then
  begin
    tvAdmin.Selected.ImageIndex := PaTypeAuth;
    tvAdmin.Selected.SelectedIndex := PaTypeAuth;
  end
  else
  begin
    tvAdmin.Selected.ImageIndex := PaTypeAuthInactive;
    tvAdmin.Selected.SelectedIndex := PaTypeAuthInactive;
  end


end;

procedure TfrmAuthAdmin.AuthToForm;
begin
  SelectCompany;
  with AdminObject.Authorizer do
  begin
    edtAuthName.Text := Name;
    if Trim(DisplayEmail) <> '' then
      edtAuthEmail.Text := DisplayEmail
    else
      edtAuthEmail.Text := Email;
    edtAuthCode.Text := AuthCode;
    edtAuthMax.Text := Format('%9.2f', [MaxAuthAmount]);

    chkSQU.Checked := AuthSQU;
    chkPQU.Checked := AuthPQU;
    chkPOR.Checked := AuthPOR;
    chkPIN.Checked := AuthPIN;

    chkApprovalOnly.Checked := ApprovalOnly;

    SetAuthAmountBox(not ApprovalOnly);

    chkActive.Checked := Active;

    chkCompressAttachments.Checked := CompressAttachments;


    Panel6.Visible := rbAuthAndApprove.checked;
    if Panel6.Visible then
      lblAltAuth.Caption := 'Alternate Authoriser/Approver'
    else
      lblAltAuth.Caption := 'Alternate Authoriser';


    if AltHours then
    begin
      cbAltHoursDays.ItemIndex := 0;
      spAlt.Value := AltAfter;
    end
    else
    begin
      cbAltHoursDays.ItemIndex := 1;
      spAlt.Value := AltAfter div 24;
    end;
    LoadAuthNames(Company, DefaultAuthoriser, cbAuthDefaultAuth, False, True);
    LoadAuthNames(Company, Alternate, cbAlternate, False, True);
    GetEqual(edtAuthName.Text);
  end;
end;

procedure TfrmAuthAdmin.LoadUsers(const WhichComp : string; CompNode : TTreeNode);
var
  ChildNode : TTreeNode;
  Res : SmallInt;
begin
  if Assigned(AdminObject) then
  with AdminObject.User do
  begin
    Index := 0;
    Company := WhichComp;
    Res := GetFirst;
    ChildNode := tvAdmin.Items.AddChild(CompNode, 'Users');
    ChildNode.Data := Pointer(-1);
    ChildNode.ImageIndex := PaTypeUser;
    ChildNode.SelectedIndex := PaTypeUser;
    while Res = 0 do
    begin
      with tvAdmin.Items.AddChild(ChildNode, UserID) do
      begin
        Data := Pointer(PaTypeUser);
        //Set images
        ImageIndex := PaTypeUser;
        SelectedIndex := PaTypeUser;
      end;
      Res := GetNext;
    end;
    if not FirstLoad then
      if Settings.UsersExpanded then
         ChildNode.Expand(False);
  end;
end;

procedure TfrmAuthAdmin.LoadAuthorizers(const WhichComp : string; CompNode : TTreeNode);
var
  ChildNode : TTreeNode;
  Res : SmallInt;
begin
  if Assigned(AdminObject) then
  with AdminObject.Authorizer do
  begin
    Index := 0;
    Company := WhichComp;
    Res := GetFirst;
    ChildNode := tvAdmin.Items.AddChild(CompNode, 'Authorisers');
    ChildNode.Data := Pointer(-1);
    ChildNode.ImageIndex := PaTypeAuth;
    ChildNode.SelectedIndex := PaTypeAuth;
    while Res = 0 do
    begin
      with tvAdmin.Items.AddChild(ChildNode, Name) do
      begin
        Data := Pointer(PaTypeAuth);
        //Set images
        if Active then
        begin
          ImageIndex := PaTypeAuth;
          SelectedIndex := PaTypeAuth;
        end
        else
        begin
          ImageIndex := PaTypeAuthInactive;
          SelectedIndex := PaTypeAuthInactive;
        end;

      end;
      Res := GetNext;
    end;
    if not FirstLoad then
      if Settings.AuthExpanded then
         ChildNode.Expand(False);

  end;
end;


procedure TfrmAuthAdmin.FormToSys;
begin
  with AdminObject.GlobalParams do
  begin
    AccountName := edtSysName.Text;
    AccountPassword := edtSysPWord.Text;
    Email := edtSysEmail.Text;
    Server := edtSysServer.Text;
    UseMapi := chkUseMapi.Checked;

    AdminEmail := edtAdminEmail.Text;

    Frequency := StrToInt(edtFrequency.Text);
    EARTimeOut := StrToInt(edtTimeOut.Text);

    OfflineStart := StrToTime(edtOffStart.Text);
    OfflineFinish := StrToTime(edtOffFinish.Text);

    AdminPassword := edtAdminPWord.Text;
  end;

  Try
    memMsg.Lines.SaveToFile(GetEnterpriseDirectory + PaMessageFile);
    memAppMsg.Lines.SaveToFile(GetEnterpriseDirectory  + PaAppMsgFile);
  Except
  End;

end;

procedure TfrmAuthAdmin.SysToForm;
begin
  with AdminObject.GlobalParams do
  begin
   // if WantLock then UnlockRecord;
    edtSysName.Text := AccountName;
    edtSysPWord.Text := AccountPassword;
    edtSysEmail.Text := Email;
    edtSysServer.Text := Server;

    chkUseMapi.Checked := UseMapi;

    edtAdminEmail.Text := AdminEmail;

    edtFrequency.Text := IntToStr(Frequency);
    edtTimeOut.Text := IntToStr(EARTimeout);

    edtOffStart.Text := FormatDateTime('hh:mm', OfflineStart);
    edtOffFinish.Text := FormatDateTime('hh:mm', OfflineFinish);

    edtAdminPWord.Text := AdminPassword;
  end;

  Try
    memMsg.Lines.LoadFromFile(GetEnterpriseDirectory + PaMessageFile);
  Except
    memMsg.Lines.Clear;
    memMsg.Lines.Add('Replace this text with the text to be sent in');
    memMsg.Lines.Add('authorisation request emails.  The text should');
    memMsg.Lines.Add('tell the authoriser how to respond to authorisation requests');
  End;


  Try
    memAppMsg.Lines.LoadFromFile(GetEnterpriseDirectory + PaAppMsgFile);
  Except
    memAppMsg.Lines.Clear;
    memAppMsg.Lines.Add('Replace this text with the text to be sent in');
    memAppMsg.Lines.Add('approval request emails.  The text should');
    memAppMsg.Lines.Add('tell the authoriser how to respond to approval requests');
  End;

end;

procedure TfrmAuthAdmin.FormToRequest;
begin //Why did I write this??!!
  with AdminObject.Request do
  begin
    EAR := edtEarID.Text;
    OurRef := edtEarOurRef.Text;
    UserID := edtEarUserID.Text;

    TotalValue := StrToFloat(edtEarValue.Text);
    TimeStamp := StrToDateTime(edtEarTime.Text);
  end;
end;

procedure TfrmAuthAdmin.RequestToForm;
begin
  with AdminObject.Request do
  begin
    edtEarID.Text := EAR;
    edtEarOurRef.Text := OurRef;
    edtEarUserID.Text := UserID;

    edtEarValue.Text := Format('%9.2f', [TotalValue]);
    edtEarTime.Text := FormatDatetime('dd/mm/yy hh:nn', TimeStamp);

    edtEarStatus.Text := StatusString;

    edtEarApp.Text := ApprovedBy;
    edtEarAuth.Text := Authoriser;
  end;
end;

procedure TfrmAuthAdmin.LoadRequests(const WhichComp : string; CompNode : TTreeNode);
var
  ChildNode : TTreeNode;
  Res : SmallInt;
begin
  if Assigned(AdminObject) then
  with AdminObject.Request do
  begin
    Index := 0;
    Company := WhichComp;
    Res := GetFirst;
    ChildNode := tvAdmin.Items.AddChild(CompNode, 'Requests');
    ChildNode.Data := Pointer(-1);
    ChildNode.ImageIndex := PaTypeRequest;
    ChildNode.SelectedIndex := PaTypeRequest;
    if Res = 0 then
    begin
      with tvAdmin.Items.AddChild(ChildNode, ' ') do
      begin
        ImageIndex := PaTypeRequest;
        SelectedIndex := PaTypeRequest;
          Data := Pointer(PaTypeRequest);
      end;

      if not FirstLoad then
      begin
        if Settings.ReqsExpanded then
           ChildNode.Expand(false);
      end;

    end;

  end;
end;

procedure TfrmAuthAdmin.FormToCompany;


begin
  with AdminObject.CompanyParams do
  begin
    AuthSQU := chkCoSQU.Checked;
    AuthPQU := chkCoPQU.Checked;
    AuthPOR := chkCoPOR.Checked;
    AuthPIN := chkCoPIN.Checked;

    FloorOnPins := chkPinFloor.Checked;

    SQUForm := edtSQUForm.Text;
    PQUForm := edtPQUForm.Text;
    PORForm := edtPORForm.Text;
    PINForm := edtPINForm.Text;

    if rbAuthOnlyA.Checked then
      AuthMode := auAuthOnlyAuto
    else
    if rbAuthOnlyM.Checked then
      AuthMode := auAuthOnlyMan
    else
    if rbAuthAndApprove.Checked then
      AuthMode := auApproveAndAuth;

    AllowPrint := chkAllowPrint.Checked;

    AuthOnConvert := chkAuthOnConvert.Checked;
    PINTolerance := edtPINTolerance.Value;
    PINCheckInterval := Trunc(edtPINInterval.Value);
  end;
end;

procedure TfrmAuthAdmin.CompanyToForm;
begin
  with AdminObject.CompanyParams do
  begin
    chkCoSQU.Checked := AuthSQU;
    chkCoPQU.Checked := AuthPQU;
    chkCoPOR.Checked := AuthPOR;
    chkCoPIN.Checked := AuthPIN;

    chkPinFloor.Checked := FloorOnPins;

    edtSQUForm.Text := SQUForm;
    edtPQUForm.Text := PQUForm;
    edtPORForm.Text := PORForm;
    edtPINForm.Text := PINForm;

    Case  AuthMode of
      auAuthOnlyAuto   : rbAuthOnlyA.Checked := True;
      auAuthOnlyMan    : rbAuthOnlyM.Checked := True;
      auApproveAndAuth : rbAuthAndApprove.Checked := True;
    end;

    chkAllowPrint.Checked := AllowPrint;
    chkAuthOnConvert.Checked := AuthOnConvert;
    edtPINTolerance.Value := PINTolerance;
    udPINInterval.Position := PINCheckInterval;
    edtPINInterval.Value := PINCheckInterval;
  end;
end;

procedure TfrmAuthAdmin.SelectGlobal;
begin
  with AdminObject.GlobalParams do
  begin
    Company := '';
    if GetFirst(WantLock) = 0 then
    begin
      SysToForm;
      GetLast;
      SysOutToForm;
      GetFirst;
    end
    else
      DoCancel;
  end;
end;

procedure TfrmAuthAdmin.SelectCompany;
begin
  with AdminObject.CompanyParams do
  begin
    Company := CurrentCompany;
    if GetEqual(CurrentCompany, WantLock) = 0 then
      CompanyToForm
    else
      DoCancel;
  end;
end;

procedure TfrmAuthAdmin.SelectAuth;
begin
  with AdminObject.Authorizer do
  begin
     Company := CurrentCompany;
     if GetEqual(CurrentSearchString, WantLock) = 0 then
       AuthToForm
     else
       DoCancel;
  end;
end;

procedure TfrmAuthAdmin.SelectUser;
begin
  with AdminObject.User do
  begin
     Company := CurrentCompany;
     if GetEqual(CurrentSearchString, WantLock) = 0 then
       UserToForm
     else
       DoCancel;
  end;
end;

procedure TfrmAuthAdmin.SelectRequest;
begin
  with AdminObject.Request do
  begin
     Company := CurrentCompany;
     GetEqual(CurrentSearchString);
     RequestToForm;
  end;
end;

procedure TfrmAuthAdmin.SetCurrentCompany(Node : TTreeNode);
begin
  if Assigned(Node) then
  begin
    if Integer(Node.Data) = PaTypeComp then
    begin
      CurrentCompany := Node.Text;
      CurrentCoNode := Node;
    end
    else
    begin
      if Node.Level = 2 then
        CurrentSearchString := Node.Text;
      SetCurrentCompany(Node.Parent);
    end;
  end;
end;


procedure TfrmAuthAdmin.btnOKClick(Sender: TObject);
var
  NodeText : string;
  OK : Boolean;
begin
  with AdminObject do
  begin
    OK := True;
    Case NoteBook1.PageIndex of
      PaTypeGlob     : begin
                         FormToSys;
                         GlobalParams.Save;
                         GlobalParams.GetLast;
                         FormToSysOut;
                         GlobalParams.Save;
                       end;
      PaTypeComp     : begin
                         FormToCompany;
                         CompanyParams.Save;
                       end;
      PaTypeAuth     : begin
                         AdminObject.Authorizer.GetEqual(edtAuthName.Text);

                         if not AuthCodeExists then
                         begin
                           FormToAuth;
                           Authorizer.Save;
                           NodeText := Authorizer.Name;
                         end
                         else
                         begin
                           OK := False;
                           ActiveControl := edtAuthCode;
                           edtAuthCode.SelStart := 0;
                           edtAuthCode.SelLength := Length(edtAuthCode.Text);
                         end;
                       end;
      PaTypeUser     : begin
                         FormToUser;
                         User.Save;
                         NodeText := User.UserID;
                       end;
      PaTypeRequest  : begin
                         FormToRequest;
                         Request.Save;
                       end;
    end;{case}
  end;{with}
  if OK then
  begin
    DisableControls;
    if NoteBook1.PageIndex in [PaTypeAuth, PaTypeUser] then
    begin
      tvAdmin.Selected.Text := NodeText;
      Label1.Caption := CurrentTypeString + NodeText;
    end;
    ActiveControl := tvAdmin;
  end;
end;

procedure TfrmAuthAdmin.DisableControls;
var
  i : integer;
begin
  btnOK.Enabled := False;
  btnCancel.Enabled := False;
  btnEdit.Enabled := True;
  panelTree.Enabled := True;
  btnAdd.Enabled := True;
  btnRemove.Enabled := True;
  btnExport.Enabled := True;


  for i := ComponentCount - 1 downto 0 do
    if Components[i] is TTabSheet then
      if Components[i] <> tabRequest then
        TTabSheet(Components[i]).Enabled := False;

  WantLock := False;
  Timer1.Enabled := False;
end;

procedure TfrmAuthAdmin.EnableControls;
var
  i : integer;
begin
  Timer1.Enabled := False;
  btnOK.Enabled := True;
  btnCancel.Enabled := True;
  btnEdit.Enabled := False;
  panelTree.Enabled := False;
  tabUserSet.Enabled := True;

  btnAdd.Enabled := False;
  btnRemove.Enabled := False;
  btnExport.Enabled := False;

  for i := ComponentCount - 1 downto 0 do
    if Components[i] is TTabSheet then
      TTabSheet(Components[i]).Enabled := True;

end;


procedure TfrmAuthAdmin.btnCancelClick(Sender: TObject);
begin
  //Cancel changes so re-read the record
  Case Notebook1.PageIndex of
    PaTypeGlob : begin
                   if WantLock then
                     AdminObject.GlobalParams.Cancel;
                   AdminObject.GlobalParams.GetFirst;
                   SysToForm;
                   AdminObject.GlobalParams.GetLast;
                   SysOutToForm;
                   AdminObject.GlobalParams.GetFirst;
                 end;
    PaTypeComp : begin
                   if WantLock then
                     AdminObject.CompanyParams.Cancel;
                   CompanyToForm;
                 end;
    PaTypeAuth : begin
                   if WantLock then
                   begin
                     AdminObject.Authorizer.GetEqual(edtAuthName.Text);
                     AdminObject.Authorizer.Cancel;
                   end;
                   AuthToForm;
                 end;
    PaTypeUser : begin
                   if WantLock then
                     AdminObject.User.Cancel;
                   UserToForm;
                 end;
  end;
  WantLock := False;

  DisableControls;
end;

procedure TfrmAuthAdmin.btnCloseClick(Sender: TObject);
begin
  Close;
end;

procedure TfrmAuthAdmin.SystemDefaults;
//Called on startup - check if we have a record in the Global Params file.
//If not create one and set any defaults (none at the moment)
var
  OldFmt : string;
  Res : SmallInt;
begin
  with AdminObject.GlobalParams do
  begin
    Res := GetFirst;
    if Res <> 0 then
    begin
      OldFmt := ShortTimeFormat;
      ShortTimeFormat := 'hh:mm';
      OfflineStart := StrToTime('21:00');
      OfflineFinish := StrToTime('06:00');
      ShortTimeFormat := OldFmt;

      Res := Add;
    end;

    //11/3/03 Added new page to globalparams for Outgoing email settings
    GetFirst;
    Res := GetNext;
    if Res in [4, 9] then //New page doesn't exist yet so add
    begin
      GetFirst; //This will load current settings
      Res := Add;
    end;

  end;
end;

procedure TfrmAuthAdmin.Authorizer1Click(Sender: TObject);
var
  NewAuth : string;
  Res : SmallInt;
  EmAddress : String;
begin
  if CurrentCompany <> '' then
  begin
    NewAuth := PickUser(True);
    if NewAuth <> '' then
    begin
      AdminObject.CompanyCode := CurrentCompany;
      NewAuth := AdminObject.AddAuthorizer(CurrentCompany, NewAuth);
      AdminObject.CompanyParams.Company := CurrentCompany;
      AdminObject.CompanyParams.GetEqual(CurrentCompany);
      FToolkit.OpenToolkit;
      Res := AdminObject.Authorizer.GetEqual(NewAuth, True);
      AdminObject.Authorizer.Active := True;
      AdminObject.Authorizer.CompressAttachments :=
         FToolkit.SystemSetup.ssPaperless.ssAttachMethod = 0;
      AdminObject.Authorizer.AuthSQU := AdminObject.CompanyParams.AuthSQU;
      AdminObject.Authorizer.AuthPQU := AdminObject.CompanyParams.AuthPQU;
      AdminObject.Authorizer.AuthPIN := AdminObject.CompanyParams.AuthPIN;
      AdminObject.Authorizer.AuthPOR := AdminObject.CompanyParams.AuthPOR;
      AdminObject.Authorizer.Save;
      FToolkit.CloseToolkit;
      AdminObject.User.Company := CurrentCompany;
      Res := AdminObject.User.GetEqual(NewAuth);
      if Res = 0 then
      begin
        AdminObject.Authorizer.Company := CurrentCompany;
        Res := AdminObject.Authorizer.GetEqual(NewAuth, True);
        AdminObject.Authorizer.Email := AdminObject.User.UserEmail;
        AdminObject.Authorizer.MaxAuthAmount := AdminObject.User.AuthAmount;
        AdminObject.Authorizer.Save;
      end
      else
      begin
        EmAddress := AdminObject.EntUserEmail(NewAuth);
        if EmAddress <> '' then
        begin
          Res := AdminObject.Authorizer.GetEqual(NewAuth, True);
          if Res = 0 then
          begin
            AdminObject.Authorizer.Email := EmAddress;
            AdminObject.Authorizer.Save;
          end;
        end;
      end;

      InsertNode(PaTypeAuth, NewAuth);
      btnEditClick(Self);
      pgcAuth.ActivePage := tabAuthDet;
      if Trim(edtAuthEmail.text) = '' then
        ActiveControl := edtAuthEmail
      else
        ActiveControl := edtAuthCode;
    end;
  end;

end;

procedure TfrmAuthAdmin.btnRemoveClick(Sender: TObject);
var
  s : string;
  Res : SmallInt;
begin
   //What are we trying to delete? Check which details are showing
   Case NoteBook1.PageIndex of
    PaTypeComp     :  s := 'Company';
    PaTypeAuth     :  s := 'Authoriser';
    PaTypeUser     :  s := 'User';
    PaTypeRequest  :  s := 'Request';
  end;

  //Confirm with user
  Res := MessageDlg('Are you sure you wish to remove this ' + s + '?',
                     mtConfirmation, [mbYes, mbNo], 0);

  if Res = mrYes then
  begin
    //Delete from database
    Case NoteBook1.PageIndex of
      PaTypeComp     :  AdminObject.DeleteCompany;
      PaTypeAuth     :  AdminObject.Authorizer.Delete;
      PaTypeUser     :  AdminObject.User.Delete;
      PaTypeRequest  :  if VirtualRequests then
                          SelectRequestFromCombo(True)
                        else
                          AdminObject.Request.Delete;
    end;

    {Once the item is deleted from the database, delete it from the
     treeview and select the next item}
    if (NoteBook1.PageIndex <> PaTypeRequest) or not VirtualRequests then
      tvAdmin.Items.Delete(tvAdmin.Selected);
    ActiveControl := tvAdmin;
    if WasSelected < tvAdmin.Items.Count then
      tvAdmin.Selected := tvAdmin.Items[WasSelected]
    else
      tvAdmin.Selected := tvAdmin.Items[tvAdmin.Items.Count - 1];

  end;
end;

function TfrmAuthAdmin.PickCompany : Boolean;
var
  i : integer;
  s : string;
begin
  with TfrmAddCompany.Create(Application) do
  begin
    Try
      for i := 1 to FToolkit.Company.cmCount do
      begin
        s := FToolkit.Company.cmCompany[i].coCode;
        if AdminObject.CompanyParams.GetEqual(s) <> 0 then
          cmbCompanies.Items.Add(FToolkit.Company.cmCompany[i].coName +
                            '(' + s + ')');
      end;//for i

      ShowModal;
      if ModalResult = mrOK then
      begin
        s := cmbCompanies.Text;
        s := Copy(s, Length(s) - 6, 6);
        CurrentCompany := s;
        Result := True;
      end
      else
        Result  := False;
    Finally
      Free;
    End;
  end;
end;

function TfrmAuthAdmin.PickUser(IsAuthoriser : Boolean = False) : ShortString;
var
  i : integer;
  s : string;
  T : TStringList;
begin
  with TfrmAddCompany.Create(Application) do
  begin
    Try
      Auth := IsAuthoriser;
      T := TStringList.Create;
      Try
        with T do
        begin
          CommaText := AdminObject.UserList(CurrentCompany);
          for i := 0 to Count - 1 do
          begin
            s := Strings[i];
            if IsAuthoriser then
            begin
              if AdminObject.Authorizer.GetEqual(s) <> 0 then
                cmbCompanies.Items.Add(s);
            end
            else
              if AdminObject.User.GetEqual(s) <> 0 then
                cmbCompanies.Items.Add(s);

          end;
        end
      Finally
        T.Free;
      End;
      if IsAuthoriser then
      begin

        cmbCompanies.ItemIndex := -1;
        Caption := 'Add Authoriser';
        Label1.Caption := 'Please type in the Authoriser''s name or, if the Authoriser' +
                          ' is an existing Exchequer user, select from the drop-down list';
        cmbCompanies.Style := csDropDown;

      end
      else
      begin
        Caption := 'Add User';
        Label1.Caption := 'Please select the User you wish to add for company ' + CurrentCompany;
      end;
      ShowModal;
      if ModalResult = mrOK then
      begin
        Result := cmbCompanies.Text; //cmbCompanies.Items[cmbCompanies.ItemIndex];
      end
      else
        Result  := '';
    Finally
      Free;
    End;
  end;
end;


procedure TfrmAuthAdmin.Company1Click(Sender: TObject);
var
  Node : TTreeNode;
begin
   if PickCompany then
   begin
     AdminObject.AddCompany(CurrentCompany);
     Node := tvAdmin.Items.Add(nil, CurrentCompany);
     with Node do
     begin
       Data := Pointer(PaTypeComp);
       ImageIndex := PaTypeComp;
       SelectedIndex := PaTypeComp;
     end;
     LoadAuthorizers(CurrentCompany, Node);
     LoadUsers(CurrentCompany, Node);
     LoadRequests(CurrentCompany, Node);
     ActiveControl := tvAdmin;
     tvAdmin.Selected := Node;
     btnEditClick(Self);
   end;
end;

procedure TfrmAuthAdmin.InsertNode(WhichType : Integer; const Name : string);
var
  i : integer;
  NodeType : string;
  Node, ChildNode : TTreeNode;

begin
  Node := nil;
  Case WhichType of
    PaTypeAuth : NodeType := 'Authorisers';
    PaTypeUser : NodeType := 'Users';
  end;

  for i := 0 to tvAdmin.Items.Count -1 do
  begin
    if tvAdmin.Items[i].Level = 1 then
    with tvAdmin.Items[i] do
    begin
      if (Parent.Text = CurrentCompany) and
         (Text = NodeType) then
         begin
           Node :=tvAdmin.Items[i];
           Break;
         end;
    end;
  end;

  if Assigned(Node) then
  begin
    ChildNode := tvAdmin.Items.AddChildFirst(Node, Name);
    with ChildNode do
    begin
      Data := Pointer(WhichType);
      ImageIndex := WhichType;
      SelectedIndex := WhichType;
    end;
    ActiveControl := tvAdmin;
    tvAdmin.Selected := ChildNode;
    Node.Expand(False);
  end;

end;

procedure TfrmAuthAdmin.SpeedButton1Click(Sender: TObject);

  function FileOnlyNoExt(FName : string) : string;
  var
    i : Integer;
  begin
    i := length(FName);
    while (i > 0) and (FName[i] <> '.') do dec(i);

    Delete(FName, i, Length(FName));

    while (i > 0) and (FName[i] <> '\') do dec(i);

    Result := Copy(FName, i + 1, Length(FName));
  end;

var
  s : ShortString;
  CompDir : ShortString;
  i : SmallInt;
begin
  with FToolkit.Company do
    for i := 1 to cmCount do
      if cmCompany[i].coCode = FcurrentCompany then
      begin
        CompDir := IncludeTrailingBackSlash(Trim(cmCompany[i].coPath));
        Break;
      end;

  with OpenDialog1 do
  begin


    InitialDir := CompDir + 'Forms';
    if Execute then
    begin
      s := FileOnlyNoExt(Filename);
      Case  TSpeedButton(Sender).Tag of
        1   :  edtSQUForm.Text := s;
        2   :  edtPQUForm.Text := s;
        3   :  edtPORForm.Text := s;
        4   :  edtPINForm.Text := s;
      end;
    end;
  end;
end;

procedure TfrmAuthAdmin.SetCurrentCompanyString(const s : string);
begin
  FCurrentCompany := s;
  Caption := 'Enterprise Authoris-e Administration ' +  AdminObject.Version +
                 ' (' + s + ')';
  with AdminObject do
  begin
    Authorizer.Company := FCurrentCompany;
    User.Company := FCurrentCompany;
    Request.Company := FCurrentCompany;
  end;
end;

procedure TfrmAuthAdmin.FormCloseQuery(Sender: TObject;
  var CanClose: Boolean);
var
  Res : Smallint;
begin
  CanClose := True;
  if btnOK.Enabled then
  begin
    Res := MessageDlg('Do you want to save any changes you have made',mtConfirmation,
                      mbYesNoCancel, 0);
    if Res = mrCancel then
      CanClose := False
    else
    if Res = mrYes then
      btnOkClick(Self);
  end;
end;

function TfrmAuthAdmin.CurrentTypeString : ShortString;
begin
    Case NoteBook1.PageIndex of
      1  : Result := 'Company: ';
      2  : Result := 'Authoriser: ';
      3  : Result := 'User: ';
      4  : Result := 'Request: ';
      else
        Result := '';
    end;
end;

procedure TfrmAuthAdmin.edtAuthCodeEnter(Sender: TObject);
begin
  if Sender is TEdit then
    TEdit(Sender).PasswordChar := #0;
end;

procedure TfrmAuthAdmin.edtAuthCodeExit(Sender: TObject);
begin
  if Sender is TEdit then
    TEdit(Sender).PasswordChar := '*';
end;

procedure TfrmAuthAdmin.Notebook1MouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
{  if not btnOk.Enabled then
    btnEditClick(Self);}
end;

procedure TfrmAuthAdmin.FormActivate(Sender: TObject);
begin
  if tvAdmin.Items.Count = 0 then //couldn't open data files
    Close;
end;

procedure TfrmAuthAdmin.DoCancel;
begin
  if WantLock then
  begin
    btnCancelClick(Self);
    ShowMessage('Record is locked by another workstation');
  end;
end;

procedure TfrmAuthAdmin.SetAuthAmountBox(Enable : Boolean);
begin
  edtAuthMax.Enabled := Enable;

  if Enable then
    edtAuthMax.Color := clWindow
  else
    edtAuthMax.Color := clBtnFace;
end;



procedure TfrmAuthAdmin.chkApprovalOnlyClick(Sender: TObject);
begin
  SetAuthAmountBox(not chkApprovalOnly.Checked);
end;

procedure TfrmAuthAdmin.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  GlobFormKeyDown(Sender, Key, Shift, ActiveControl, Handle);
end;

procedure TfrmAuthAdmin.FormKeyPress(Sender: TObject; var Key: Char);
begin
  GlobFormKeyPress(Sender, Key, ActiveControl);
end;

procedure TfrmAuthAdmin.Timer1Timer(Sender: TObject);
begin
  FillTree;
end;



procedure TfrmAuthAdmin.SaveState(Node : TTreeNode; State : Boolean);
var
  s : string;
  i, j : integer;

begin
  j := Integer(Node.Data);
  if j = -1 then
  begin
    if Node.Text = 'Authorisers' then
      j := PaTypeAuth
    else
    if Node.Text = 'Users' then
      J := PaTypeUser
    else
    if Node.text = 'Requests' then
      j := PaTypeRequest;
  end;
  SetCurrentCompany(Node);
  Settings.Company := CurrentCompany;

  Case j of
    PaTypeComp     : Settings.CoExpanded := State;
    PaTypeAuth     : Settings.AuthExpanded := State;
    PaTypeUser     : Settings.UsersExpanded := State;
    PaTypeRequest  : Settings.ReqsExpanded := State;
  end;
end;


procedure TfrmAuthAdmin.tvAdminExpanded(Sender: TObject; Node: TTreeNode);
var
  p  : TRect;
  p1 : TPoint;
begin
  SaveState(Node, True);
  if Node.text = 'Requests' then
  begin
    PrevRequestNode := CurrentRequestNode;
    CurrentRequestParent := Node;
    CurrentRequestNode := Node.GetFirstChild;
    SetCurrentCompany(Node);
    ExpandRequests(CurrentCompany, nil);
  end;
end;

procedure TfrmAuthAdmin.tvAdminCollapsed(Sender: TObject; Node: TTreeNode);
var
  i : integer;
  OldCo : string;
begin
  OldCo := FCurrentCompany;
  SaveState(Node, False);
  FCurrentCompany := OldCo;
  if Node.Text = 'Requests' then
  begin
    vcbRequest.Visible := False;
    RequestsExpanded := False;
    Screen.Cursor := crHourglass;
    Application.ProcessMessages;
    VisibleEar := '';
    Screen.Cursor := crDefault;
    Application.ProcessMessages;

  end;
end;

procedure TfrmAuthAdmin.tvAdminKeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if Key = VK_F5 then
    FillTree;
end;

procedure TfrmAuthAdmin.LoadAuthNames(WhichCompany, DefName : string; AList : TComboBox;
                                      AllowApprovers : Boolean; IsAuth : Boolean = False);
var
  Res : integer;
  i : integer;
  ThisAuth : string;
begin
  if Assigned(AdminObject) then
  with AdminObject.Authorizer do
  begin
    ThisAuth := AdminObject.Authorizer.Name;
    AList.Items.Clear;
    AList.Items.Add(defNone);
    Index := 0;
    Company := WhichCompany;
    Res := GetFirst;

    while Res = 0 do
    begin
      if AllowApprovers or not ApprovalOnly then
        AList.Items.Add(AdminObject.Authorizer.Name);

      Res := GetNext;
    end;

    if IsAuth and (DefName = '') then
     if AdminObject.User.GetEqual(ThisAuth) = 0 then
         DefName :=  AdminObject.User.DefaultAuthoriser;

    i := AList.Items.IndexOf(DefName);
    if i < 0 then
      i := 0;

    AList.ItemIndex := i;

    If IsAuth then
      GetEqual(ThisAuth);
  end;


end;

procedure TfrmAuthAdmin.DoHelp;
var
  HC : integer;
begin
  HC := GetHelpContext;
  Application.HelpContext(HC);
end;


function TfrmAuthAdmin.GetHelpContext : integer;
begin
  Case Notebook1.PageIndex of
    PaTypeGlob  :  Result := 30 + PageControl2.TabIndex;
    PaTypeComp  :  Result := 35 + PageControl4.TabIndex;
    PaTypeAuth  :  begin
                     Result := 38 + pgcAuth.TabIndex;
                     if Result = 40 then
                       Result := 101;
                   end;
    PaTypeUser  :  begin
                     Result := 41 + PageControl1.TabIndex;
                     if Result = 42 then
                       Result := 100;
                   end;
    PaTypeRequest : Result := 47;
  end;
end;

procedure TfrmAuthAdmin.Notebook1PageChanged(Sender: TObject);
begin
  Notebook1.HelpContext := GetHelpContext;
  btnFindRequest.Visible := VirtualRequests and (Notebook1.PageIndex = paTypeRequest);
end;

procedure TfrmAuthAdmin.PageControl1Change(Sender: TObject);
begin
  if Sender is TPageControl then
  begin
    TPageControl(Sender).HelpContext := GetHelpContext;
    tvAdmin.HelpContext := TPageControl(Sender).HelpContext;
  end;
end;

procedure TfrmAuthAdmin.Help1Click(Sender: TObject);
begin
  DoHelp;
end;

procedure TfrmAuthAdmin.AboutAuthorise1Click(Sender: TObject);
var
  AVersion : string;
begin
  with TPaObject.Create do
  Try
    AVersion := GetVersion;
  Finally
    Free;
  End;

  with TfrmAbout.Create(Self) do
  Try
    Caption := 'About Exchequer Authoris-e';
    lblTitle.Caption := 'Exchequer Authoris-e';
    lblVersion.Caption := 'Version: ' + AVersion;
    ShowModal;
  Finally
    Free;
  End;

end;

function TfrmAuthAdmin.AuthCodeExists : Boolean;
var
  Res : SmallInt;
  ThisAuth : string;
begin
  ThisAuth := AdminObject.Authorizer.Name;
  with AdminObject.Authorizer do
  begin
    Index := AuthCodeIdx;
    Res := GetEqual(edtAuthCode.Text);
    if (Res = 0) and (AdminObject.Authorizer.Name <> ThisAuth) then
      ShowMessage('This code is already in use by another authoriser')
    else
      Res := 1;
    Index := AuthNameIdx;
    GetEqual(edtAuthName.Text);
  end;
  Result := Res = 0;
end;

procedure TfrmAuthAdmin.ExpandRequests(const WhichComp : string; CompNode : TTreeNode);
var
  Res : SmallInt;
  i, y : integer;
  OldIdx : Integer;
begin
  Screen.Cursor := crHourglass;
  Application.ProcessMessages;
  if Assigned(AdminObject) then
  with AdminObject.Request do
  begin
   if FirstLoad or (FReqCompany <> FCurrentCompany) then
   begin
    if Assigned(PrevRequestNode) and vcbRequest.Visible then
      PrevRequestNode.Parent.Collapse(True);
    vcbRequest.Text := '';
    ReqList.Clear;
    Index := 0;
    Company := WhichComp;
    Res := GetFirst;
    while (Res = 0) and ((ReqList.Count < MaxRequestsBeforeVirtual) or not WANT_VIRTUAL_REQUESTS) do
    begin
      ReqList.Add(EAR);
      Res := GetNext;
    end;
    VirtualRequests :=  Res = 0;
    FReqCompany := FCurrentCompany;
    CurrentEar := ReqList[ReqList.count - 1];
   end;


    if VirtualRequests then
    begin
      if Trim(vcbRequest.Text) = '' then
      begin
        Res := AdminObject.Request.GetFirst;

        if Res = 0 then
          vcbRequest.Text := AdminObject.Request.EAR;
      end;

{      y := CurrentRequestNode.DisplayRect(True).Bottom;
      if y > tvAdmin.Height then
        tvAdmin.ScrollBy(0, - vcbRequest.Height * 2);}
      vcbRequest.Visible := True;
      //tvAdmin.HideSelection := True;
      tvAdmin.Selected := CurrentRequestNode;
      CurrentRequestNode.ImageIndex := 6;
      CurrentRequestNode.SelectedIndex := 6;
      RequestsExpanded := True;
      vcbRequestChange(Self);
    end
    else
    begin
      if CurrentRequestParent.Count = 1 then
      begin
        CurrentRequestParent.Item[0].text := ReqList[0];
        for i := 1 to ReqList.Count - 1 do
        begin
          with tvAdmin.Items.AddChild(CurrentRequestParent, ReqList[i]) do
          begin
            Data := Pointer(PaTypeRequest);
         //Set images
            ImageIndex := PaTypeRequest;
            SelectedIndex := PaTypeRequest;
          end;
        end;
      end;

    end;



  end;
  Screen.Cursor := crDefault;
  Application.ProcessMessages;
end;

procedure TfrmAuthAdmin.SetComboPos;
var
  p : TRect;
  p1 : TPoint;
  LastNode : TTreeNode;
begin
(*  if Assigned(CurrentRequestNode) then
  begin
    p := CurrentRequestNode.DisplayRect(True);
    p1 := tvAdmin.ClientToParent(Point(p.left, p.top));
    vcbRequest.Left := p1.X - 8 - tvAdmin.Images.Width;;
    vcbRequest.Top := p1.Y - 4;
    vcbRequest.Visible := CurrentRequestParent.Expanded and CurrentCoNode.Expanded;{ and
                 (p1.Y + vcbRequest.Height < tvAdmin.Top + tvAdmin.Height);}
    Application.ProcessMessages;
    if vcbRequest.Top <> OldReqTop then
    begin
      OldReqTop := vcbRequest.top;
      tvAdmin.Repaint;
      Application.ProcessMessages;
{      tvAdmin.Update;
      Application.ProcessMessages;
//      Label34.caption := 'Repaint';}
    end;
{  if ActiveControl is TComponent then
   Label32.Caption := IntToStr(TComponent(ActiveControl).Tag);}
//   ShowScrollBar(tvAdmin.Handle, SB_VERT, True);

  end;

{  LastNode := tvAdmin.Items[tvAdmin.Items.Count - 1];
  if Assigned(LastNode) then
  begin
    p := LastNode.DisplayRect(True);
    sbAdmin.Visible := p.Top > tvAdmin.ClientHeight;
  end;
 }
*)
end;

procedure TfrmAuthAdmin.SelectRequestFromCombo(WantToDelete : Boolean = False);
var
  s, oldEar, OldCo : string;
  Res : SmallInt;
begin
  with AdminObject.Request do
  begin
     oldCo := Company;
     oldEar := CurrentEAR;
     Company := CurrentCompany;
     s := vcbRequest.Text;
     VisibleEar := s;
     Res := GetEqual(s);
     if WantToDelete then
     begin
       if Res = 0 then
       begin
         AdminObject.Request.Delete;

         Res := AdminObject.Request.GetGreaterThanOrEqual(s);

         if Res <> 0 then
           Res := AdminObject.Request.GetLessThan(s);

         if Res = 0 then
           vcbRequest.Text := AdminObject.Request.EAR
         else
           vcbRequest.Text := '';
         vcbRequestChange(Self);
       end;
     end
     else
     begin
       NoteBook1.PageIndex := paTypeRequest;
       RequestToForm;
     end;
     btnEdit.Enabled := False;
     Company := oldCo;
     GetEqual(oldEAR);
  end;
end;


function TfrmAuthAdmin.vcbRequestGetFirst(Sender: TObject; AList: TStrings;
  DCount: Integer): Boolean;
var
  Res : SmallInt;
begin
  with AdminObject do
  begin
    Res := Request.GetFirst;

    while (Res  = 0) and (AList.Count < DCount) do
    begin
      AList.Add(Request.EAR);

      if AList.Count < DCount then
        Res := Request.GetNext;
    end;
    Res := Request.GetFirst;//re-establish position
  end;
  Result := AList.Count > 0;
end;

function TfrmAuthAdmin.vcbRequestGetLast(Sender: TObject; AList: TStrings;
  DCount: Integer): Boolean;
var
  Res : SmallInt;
  BList : TStringlist;
begin
  BList := TStringlist.Create;
  Try
    with AdminObject do
    begin
      Res := Request.GetLast;

      while (Res  = 0) and (BList.Count < DCount) do
      begin
        BList.Add(Request.EAR);

        if BList.Count < DCount then
          Res := Request.GetPrevious;
      end;

      Res := Request.GetLast; //re-establish position
    end;

    for Res := BList.Count - 1 downto 0 do
      AList.Add(BList[Res]);
  Finally
    Result := AList.Count > 0;
    BList.Free;
  End;
end;

function TfrmAuthAdmin.vcbRequestGetNextPage(Sender: TObject;
  AList: TStrings; DCount: Integer): Boolean;
var
  Res : Smallint;
  KeyStr : string;
begin
  with AdminObject do
  begin
    Res := Request.GetNext;

    if Res = 0 then
      KeyStr := Request.EAR;

    while (Res  = 0) and (AList.Count < DCount) do
    begin
      AList.Add(Request.EAR);

      if AList.Count < DCount then
        Res := Request.GetNext;
    end;
  end;

  Result := AList.Count > 0;
end;

function TfrmAuthAdmin.vcbRequestGetPrevPage(Sender: TObject;
  AList: TStrings; DCount: Integer): Boolean;
var
  Res : integer;
  BList : TStringlist;
begin
  BList := TStringlist.Create;
  Try
    with AdminObject do
    begin
      Res := Request.GetPrevious;

      while (Res  = 0) and (BList.Count < DCount) do
      begin
        BList.Add(Request.EAR);

        if (BList.Count < DCount) then
          Res := Request.GetPrevious;
      end;
    end;

    for Res := BList.Count - 1 downto 0 do
      AList.Add(BList[Res]);
  Finally
    Result := AList.Count > 0;
    BList.Free;
  End;
end;

function TfrmAuthAdmin.vcbRequestGetNext(Sender: TObject;
  var DataString: String): Boolean;
var
  Res : SmallInt;
begin
  with AdminObject do
  begin
    Res := Request.GetNext;

    if Res = 0 then
      DataString := Request.EAR
    else
      DataString := '';
  end;

  Result := Res = 0;
end;

function TfrmAuthAdmin.vcbRequestGetPrev(Sender: TObject;
  var DataString: String): Boolean;
var
  Res : SmallInt;
begin
  with AdminObject do
  begin
    Res := Request.GetPrevious;

    if Res = 0 then
      DataString := Request.EAR
    else
      DataString := '';
  end;

  Result := Res = 0;
end;

function TfrmAuthAdmin.vcbRequestShow(Sender: TObject; AList: TStrings;
  DCount: Integer; const FindString: String): Boolean;
var
  Res : SmallInt;
  BList : TStringList;

  procedure SetPos;
  begin
    if Trim(FindString) <> '' then
      Res := AdminObject.Request.GetGreaterThanOrEqual(Trim(FindString))
    else
      Res := AdminObject.Request.GetFirst;
  end;

begin
  with AdminObject do
  begin
    Request.Company := FCurrentCompany;
    SetPos;

    while (Res  = 0) and (AList.Count < DCount) do
    begin
      AList.Add(Request.EAR);

      Res := Request.GetNext;
    end;

    if AList.Count < DCount then
    begin
      BList := TStringList.Create;
      Try
        SetPos;

        for Res := AList.Count - 1 downto 0 do
          BList.Add(AList[Res]);

        AList.Clear;
        Res := 0;

        while (Res = 0) and (BList.Count < DCount) do
        begin
          Res := Request.GetPrevious;

          BList.Add(Request.EAR);
        end;

        for Res := BList.Count - 1 downto 0 do
          AList.Add(BList[Res]);
      Finally
        BList.Free;
      End;
    end;

    SetPos;
  end;
  Result := AList.Count > 0;
end;

procedure TfrmAuthAdmin.vcbRequestChange(Sender: TObject);
begin
  if Assigned(CurrentRequestNode) then
    CurrentRequestNode.Text := vcbRequest.Text;
  SetCurrentCompany(CurrentRequestNode.Parent);
  SelectRequestFromCombo;
end;

procedure TfrmAuthAdmin.tvAdminMouseUp(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  if RequestsExpanded then
  begin
//    ActiveControl := vcbRequest;
    RequestsExpanded := false;
  end;
end;

procedure TfrmAuthAdmin.tvAdminAdvancedCustomDrawItem(
  Sender: TCustomTreeView; Node: TTreeNode; State: TCustomDrawState;
  Stage: TCustomDrawStage; var PaintImages, DefaultDraw: Boolean);
begin
{  if not VirtualRequests then
  begin
    EXIT;
  end;

  if Stage = cdPostPaint then
  begin
    begin
     Try
        SetComboPos;
        Application.ProcessMessages;
     Except
     End;
    end;
  end;}
end;

procedure TfrmAuthAdmin.tvAdminCustomDraw(Sender: TCustomTreeView;
  const ARect: TRect; var DefaultDraw: Boolean);
var
  pScrInfo : ScrollInfo;
  BRes : Boolean;
begin
(*  if not VirtualRequests then
  begin
    EXIT;
  end;

  {  if Stage = cdPostPaint then}
  begin
{    FillChar(pScrInfo, SizeOf(pScrInfo), #0);}
    begin
{     pScrInfo.fMask := SIF_POS;}
       Try
          SetComboPos;
          DefaultDraw := True;
//          ShowScrollBar(tvAdmin.Handle, SB_VERT, False);
{          GetScrollInfo(tvAdmin.Handle, SB_VERT, pScrInfo);
          pScrInfo.fMask := SIF_POS;
          SetScrollInfo(tvAdmin.Handle, SB_VERT, pScrInfo, True);
          Application.ProcessMessages;}
       Except
       End;
    end;
  end; *)
end;

procedure TfrmAuthAdmin.vcbRequestEnter(Sender: TObject);
begin
  SetCurrentCompany(CurrentRequestParent);
end;

procedure TfrmAuthAdmin.btnFindRequestClick(Sender: TObject);
begin
  with TfrmFindReq.Create(Application) do
  Try;
    ShowModal;
    if ModalResult = mrOK then
      FindRequest(edtReq2Find.Text);
  Finally
    Free;
  End;

end;

procedure TfrmAuthAdmin.FindRequest(const WhichRequest : string);
var
  Res : SmallInt;
  s : string;

  function FullTransNo(const r : string) : string;
  begin
    Result := r;
    while Length(Result) < 9 do Insert('0', Result, 4);
  end;

begin
  s := FullTransNo(WhichRequest);
  with AdminObject do
  begin
    Request.Index := ReqOurRefIdx;
    Res := Request.GetEqual(s);
    Request.Index := 0;
    if Res = 0 then
      vcbRequest.Text := Request.EAR
    else
      ShowMessage('Unable to find a request for transaction ' + s);
  end;
end;


procedure TfrmAuthAdmin.FormToSysOut;
begin
  with AdminObject.GlobalParams do
  begin
    AccountName := edtSysNameOut.Text;
    AccountPassword := edtSysPWordOut.Text;
    Email := edtSysEmailOUt.Text;
    Server := edtSysServerOut.Text;
    UseMapi := chkUseMapiOut.Checked;

    AdminEmail := edtAdminEmail.Text;

    Frequency := StrToInt(edtFrequency.Text);
    EARTimeOut := StrToInt(edtTimeOut.Text);

    OfflineStart := StrToTime(edtOffStart.Text);
    OfflineFinish := StrToTime(edtOffFinish.Text);

    AdminPassword := edtAdminPWord.Text;
  end;

end;

procedure TfrmAuthAdmin.SysOutToForm;
begin
  with AdminObject.GlobalParams do
  begin
   // if WantLock then UnlockRecord;
    edtSysNameOut.Text := AccountName;
    edtSysPWordOut.Text := AccountPassword;
    edtSysEmailOut.Text := Email;
    edtSysServerOut.Text := Server;

    chkUseMapiOut.Checked := UseMapi;

    edtAdminEmail.Text := AdminEmail;

    edtFrequency.Text := IntToStr(Frequency);
    edtTimeOut.Text := IntToStr(EARTimeout);

    edtOffStart.Text := FormatDateTime('hh:mm', OfflineStart);
    edtOffFinish.Text := FormatDateTime('hh:mm', OfflineFinish);

    edtAdminPWord.Text := AdminPassword;
  end;

end;


procedure TfrmAuthAdmin.edtPINToleranceExit(Sender: TObject);
begin
  edtPINTolerance.Text := Format('%8.2f', [StrToFloat(edtPINTolerance.Text)]);
end;

procedure TfrmAuthAdmin.FormDblClick(Sender: TObject);
begin
  ShowMessage(Format('%d : %d : %d : %d', [Width, Height, ClientWidth, ClientHeight]));
end;

procedure TfrmAuthAdmin.btnExportClick(Sender: TObject);
var
  F : TextFile;
  Res, Res1 : Integer;
  ThisCompany : string;

  function YN(Value : Boolean) : string;
  begin
    Result := BooleanToYN(Value)[1];
  end; // YN

  procedure WriteAuthoriser;
  var
    s : string;
  begin
    with AdminObject.Authorizer do
    begin
      s := ArrayOfStringToString([Company, 'A', Trim(Name), Trim(Email), Trim(DisplayEmail),
                                  FloatToStr(MaxAuthAmount), YN(AuthSQU),
                                  YN(AuthPQU), YN(AuthPOR), YN(AuthPIN),
                                  YN(Active), YN(ApprovalOnly), YN(CompressAttachments),
                                  Trim(DefaultAuthoriser), Trim(Alternate), IntToStr(AltAfter),
                                  YN(AltHours)], False, ',');
      WriteLn(F, s);
    end; // with AdminObject.Authorizer do
  end; // WriteUser

  procedure WriteUser;
  var
    s : string;
  begin
    with AdminObject.User do
    begin
      s := ArrayOfStringToString([Company, 'U', Trim(UserId), Trim(UserName), Trim(UserEmail),
                                  FloatToStr(FloorLimit), FloatToStr(AuthAmount), '' + SendOptions,
                                  Trim(DefaultAuthoriser), Trim(DefaultApprover)], False, ',');

      WriteLn(F, s);
    end; // with AdminObject.User do
  end; // WriteUser
begin
  if dlgExport.Execute then
  begin
    AssignFile(F, dlgExport.Filename);
    Rewrite(F);

    Res := AdminObject.CompanyParams.GetFirst;

    while Res = 0 do
    begin
      //Authorisers
      AdminObject.Authorizer.Company := AdminObject.CompanyParams.Company;

      Res1 := AdminObject.Authorizer.GetFirst;

      while (Res1 = 0) do
      begin
        WriteAuthoriser;

        Res1 := AdminObject.Authorizer.GetNext;
      end;

      //Users
      AdminObject.User.Company := AdminObject.CompanyParams.Company;

      Res1 := AdminObject.User.GetFirst;

      while (Res1 = 0) do
      begin
        WriteUser;

        Res1 := AdminObject.User.GetNext;
      end;


      Res := AdminObject.CompanyParams.GetNext;


    end; // while res = 0

    CloseFile(F);
    ShowMessage('Data written to ' + dlgExport.Filename);
  end;  // if dlgExport.Execute
end;

end.

