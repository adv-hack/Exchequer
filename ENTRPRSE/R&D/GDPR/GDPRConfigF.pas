unit GDPRConfigF;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, CheckLst, ComCtrls, Mask, TEditVal, ExtCtrls, AuditIntf, GDPRConst;

type
  TfrmGDPRConfiguration = class(TForm)
    PageControl1: TPageControl;
    tabTraderSettings: TTabSheet;
    btnOK: TButton;
    btnCancel: TButton;
    lblTraderRetPer: TLabel;
    udTraderRetPer: TUpDown;
    lblTraderYear: TLabel;
    lblTraderRetPeriod: Label8;
    bvlTS1: TBevel;
    lblTraderDesc: TLabel;
    chkTraderDispPIIInfoWin: TCheckBox;
    tabCompanyAno: TTabSheet;
    lblCompAddDesc: TLabel;
    lblTraderAnoSett: Label8;
    bvlTS2: TBevel;
    lblTraderAno: TLabel;
    tabNotification: TTabSheet;
    lblNotifiAnoStatus: Label8;
    lblNotifiDesc: TLabel;
    lblAnonStatus: TLabel;
    btnBackColor: TButton;
    btnFontColor: TButton;
    bvlNotifi: TBevel;
    shpNotifiStatus: TShape;
    lblCompAddAnonEnt: Label8;
    bvlComp2: TBevel;
    tabEmpSettings: TTabSheet;
    lblTraderNotes: TLabel;
    cmbTraderNotes: TComboBox;
    lblTraderLetters: TLabel;
    cmbTraderLetters: TComboBox;
    lblTraderLinks: TLabel;
    cmbTraderLinks: TComboBox;
    lblTraderMiscSett: Label8;
    bvlTS3: TBevel;
    lblCompAnonSett: Label8;
    bvlComp1: TBevel;
    lblCompDesc: TLabel;
    lblCompNotes: TLabel;
    lblCompLetters: TLabel;
    lblCompLinks: TLabel;
    cmbCompNotes: TComboBox;
    cmbCompLetters: TComboBox;
    cmbCompLinks: TComboBox;
    lblEmployeeRetPer: TLabel;
    lblEmployeeYear: TLabel;
    lblEmployeeRetPeriod: Label8;
    bvlEmp1: TBevel;
    lblEmployeeDesc: TLabel;
    lblEmployeeAnoSett: Label8;
    bvlEmp2: TBevel;
    lblEmployeeAno: TLabel;
    lblEmployeeNotes: TLabel;
    lblEmployeeLetters: TLabel;
    lblEmployeeLinks: TLabel;
    lblEmployeeMiscSett: Label8;
    bvlEmp3: TBevel;
    udEmployeeRetPer: TUpDown;
    chkEmployeeDispPIIInfoWin: TCheckBox;
    cmbEmployeeNotes: TComboBox;
    cmbEmployeeLetters: TComboBox;
    cmbEmployeeLinks: TComboBox;
    ColorDialog: TColorDialog;
    chkCompAnonCostCentre: TCheckBox;
    chkCompAnonDepartments: TCheckBox;
    chkCompAnonLocations: TCheckBox;
    edtTraderRetPer: TCurrencyEdit;
    edtEmployeeRetPer: TCurrencyEdit;
    procedure FormCreate(Sender: TObject);
    procedure btnBackColorClick(Sender: TObject);
    procedure btnFontColorClick(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure FormKeyPress(Sender: TObject; var Key: Char);
    procedure btnOKClick(Sender: TObject);
    procedure btnCancelClick(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure edtTraderRetPerExit(Sender: TObject);
    procedure edtEmployeeRetPerExit(Sender: TObject);
  private
    { Private declarations }
    //RB 24/11/2017 2018-R1 ABSEXCH-19467: GDPR Configuration window - Auditing
    FGDPRConfigAudit: IBaseAudit;
    procedure LoadDropdownOptions;
    procedure PopulateGDPRSettings;
    procedure StoreGDPRSettings;
  public
    { Public declarations }
  end;

implementation

uses oSystemSetup, BtSupu2, VarConst;

{$R *.dfm}
//------------------------------------------------------------------------------

procedure TfrmGDPRConfiguration.FormCreate(Sender: TObject);
begin //FormCreate
  //RB 24/11/2017 2018-R1 ABSEXCH-19467: GDPR Configuration window - Auditing
  FGDPRConfigAudit := NIL;
  FGDPRConfigAudit := NewAuditInterface(atGDPRConfig);
  FGDPRConfigAudit.BeforeData := SystemSetup(True).AuditData;
  tabEmpSettings.TabVisible := JBCostOn;
  PageControl1.ActivePage := tabTraderSettings;
  lblAnonStatus.Caption := 'Anonymised '+ DateToStr(SysUtils.Date);
  //Load Dropdown options at runtime
  LoadDropdownOptions;
  //Display Value from Database
  PopulateGDPRSettings;
end; //FormCreate

//------------------------------------------------------------------------------

procedure TfrmGDPRConfiguration.btnBackColorClick(Sender: TObject);
begin //btnBackColorClick
  ColorDialog.Color := shpNotifiStatus.Brush.Color;
  if ColorDialog.Execute then
  begin
    shpNotifiStatus.Brush.Color := ColorDialog.Color;
    shpNotifiStatus.Pen.Color := shpNotifiStatus.Brush.Color;
  end;
end; //btnBackColorClick

//------------------------------------------------------------------------------

procedure TfrmGDPRConfiguration.LoadDropdownOptions;
var
  i: Integer;
begin //LoadDropdownOptions
  //Notes - controls the behaviour relating to Notes
  cmbTraderNotes.Clear;
  cmbEmployeeNotes.Clear;
  cmbCompNotes.Clear;
  for i:=Low(NotesAnonymisationControlCentreList) to high(NotesAnonymisationControlCentreList) do
  begin
    cmbTraderNotes.Items.Add(NotesAnonymisationControlCentreList[i]);
    cmbEmployeeNotes.Items.Add(NotesAnonymisationControlCentreList[i]);
    cmbCompNotes.Items.Add(NotesAnonymisationControlCentreList[i]);
  end;

  //Letters - controls the behaviour relating to Letters
  cmbTraderLetters.Clear;
  cmbEmployeeLetters.Clear;
  cmbCompLetters.Clear;
  for i:=Low(LettersAnonymisationControlCentreList) to high(LettersAnonymisationControlCentreList) do
  begin
    cmbTraderLetters.Items.Add(LettersAnonymisationControlCentreList[i]);
    cmbEmployeeLetters.Items.Add(LettersAnonymisationControlCentreList[i]);
    cmbCompLetters.Items.Add(LettersAnonymisationControlCentreList[i]);
  end;

  //Links - controls the behaviour relating to Links
  cmbTraderLinks.Clear;
  cmbEmployeeLinks.Clear;
  cmbCompLinks.Clear;
  for i:=Low(LinksAnonymisationControlCentreList) to high(LinksAnonymisationControlCentreList) do
  begin
    cmbTraderLinks.Items.Add(LinksAnonymisationControlCentreList[i]);
    cmbEmployeeLinks.Items.Add(LinksAnonymisationControlCentreList[i]);
    cmbCompLinks.Items.Add(LinksAnonymisationControlCentreList[i]);
  end;
end; //LoadDropdownOptions

//------------------------------------------------------------------------------
//populates data in controls from the DB
procedure TfrmGDPRConfiguration.PopulateGDPRSettings;
  //-----------------------------------------------------------------------
  procedure SetComboBoxValue(AControl: TComboBox; AValue: Integer);
  begin
    if AValue > 0 then
      AControl.ItemIndex := AValue - 1
    else
      AControl.ItemIndex := 0;
  end;
  //-----------------------------------------------------------------------
begin //PopulateGDPRSettings
  with SystemSetup(True).GDPR do // Refresh the SystemSetup settings
  begin
    // Set Trader Settings
    edtTraderRetPer.Value := GDPRTraderRetentionPeriod;
    udTraderRetPer.Position := GDPRTraderRetentionPeriod;
    SetComboBoxValue(cmbTraderNotes, GDPRTraderAnonNotesOption);
    SetComboBoxValue(cmbTraderLetters, GDPRTraderAnonLettersOption);
    SetComboBoxValue(cmbTraderLinks, GDPRTraderAnonLinksOption);
    chkTraderDispPIIInfoWin.Checked := GDPRTraderDisplayPIITree;

    // Set Employee  Settings
    edtEmployeeRetPer.Value := GDPREmployeeRetentionPeriod;
    udEmployeeRetPer.Position := GDPREmployeeRetentionPeriod;
    SetComboBoxValue(cmbEmployeeNotes, GDPREmployeeAnonNotesOption);
    SetComboBoxValue(cmbEmployeeLetters, GDPREmployeeAnonLettersOption);
    SetComboBoxValue(cmbEmployeeLinks, GDPREmployeeAnonLinksOption);
    chkEmployeeDispPIIInfoWin.Checked := GDPREmployeeDisplayPIITree;

    //Notification Settings
    shpNotifiStatus.Brush.Color := NotificationWarningColour;
    shpNotifiStatus.Pen.Color := shpNotifiStatus.Brush.Color;
    lblAnonStatus.Font.Color := NotificationWarningFontColour;

    //Company Anonymisation Settings
    SetComboBoxValue(cmbCompNotes, GDPRCompanyNotesOption);
    SetComboBoxValue(cmbCompLetters, GDPRCompanyLettersOption);
    SetComboBoxValue(cmbCompLinks, GDPRCompanyLinksOption);
    chkCompAnonCostCentre.Checked := GDPRCompanyAnonCostCentres;
    chkCompAnonDepartments.Checked := GDPRCompanyAnonDepartment;
    chkCompAnonLocations.Checked := GDPRCompanyAnonLocations;
  end;
end; //PopulateGDPRSettings

//------------------------------------------------------------------------------

procedure TfrmGDPRConfiguration.btnFontColorClick(Sender: TObject);
begin //btnFontColorClick
  ColorDialog.Color := lblAnonStatus.Font.Color;
  if ColorDialog.Execute then
    lblAnonStatus.Font.Color := ColorDialog.Color;
end; //btnFontColorClick

//------------------------------------------------------------------------------

procedure TfrmGDPRConfiguration.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin //FormKeyDown
  GlobFormKeyDown(Sender, Key, Shift, ActiveControl, Handle);
end; //FormKeyDown

//------------------------------------------------------------------------------

procedure TfrmGDPRConfiguration.FormKeyPress(Sender: TObject;
  var Key: Char);
begin //FormKeyPress
  GlobFormKeyPress(Sender, Key, ActiveControl, Handle);
end; //FormKeyPress

//------------------------------------------------------------------------------

procedure TfrmGDPRConfiguration.btnOKClick(Sender: TObject);
begin //btnOKClick
  StoreGDPRSettings;
  //RB 24/11/2017 2018-R1 ABSEXCH-19467: GDPR Configuration window - Auditing
  if Assigned(FGDPRConfigAudit) Then
  begin
    // Audit
    FGDPRConfigAudit.AfterData := SystemSetup.AuditData;
    FGDPRConfigAudit.WriteAuditEntry;
    FGDPRConfigAudit := NIL;
  end;
end; //btnOKClick

//------------------------------------------------------------------------------

//this will save GDPR setting values into DB table
procedure TfrmGDPRConfiguration.StoreGDPRSettings;
var
  lRes: Integer;
  //-----------------------------------------------------------------------
  procedure UpdateSystemSetupValue(var aRes: Integer;
                                   const aFieldIdx : TSystemSetupFieldIds;
                                   const aBeforeValue, aAfterValue: String;
                                   const aErrorDesc: String = '');
  begin
    if (aRes = 0) and (aBeforeValue <> aAfterValue) Then
    begin
      with SystemSetup(True) do
        aRes := UpdateValue(aFieldIdx, aBeforeValue, aAfterValue);
        
      if aRes = 2 then
        MessageDlg ('Error - another user has already changed the ' + aErrorDesc + ', please re-open the window and try again', mtError, [mbOK], 0)
      else if aRes > 0 then
        MessageDlg ('An error ' + IntToStr(aRes) + ' occurred updating the ' + aErrorDesc, mtWarning, [mbOK], 0);
    end;
  end;
  //-----------------------------------------------------------------------
  function BooleanToStr(aValue: Boolean): String;
  begin
    Result := IntToStr(ord(aValue));
  end;
  //-----------------------------------------------------------------------
begin
  lRes := 0;
  with SystemSetup(True).GDPR do
  begin
    //Trader Settings Tab
    //RB 02/01/2017 ABSEXCH-19594: GDPR Configuration window > Trader/Employee Retention Period > Value is not saving if Value changed through increment / decrement button.
    UpdateSystemSetupValue(lRes, siGDPRTraderRetentionPeriod, IntToStr(GDPRTraderRetentionPeriod), Trim(edtTraderRetPer.Text), '');
    UpdateSystemSetupValue(lRes, siGDPRTraderDisplayPIITree, BooleanToStr(GDPRTraderDisplayPIITree), BooleanToStr(chkTraderDispPIIInfoWin.Checked), '');
    UpdateSystemSetupValue(lRes, siGDPRTraderAnonNotesOption, IntToStr(GDPRTraderAnonNotesOption), IntToStr(cmbTraderNotes.ItemIndex+1), '');
    UpdateSystemSetupValue(lRes, siGDPRTraderAnonLettersOption, IntToStr(GDPRTraderAnonLettersOption), IntToStr(cmbTraderLetters.ItemIndex+1), '');
    UpdateSystemSetupValue(lRes, siGDPRTraderAnonLinksOption, IntToStr(GDPRTraderAnonLinksOption), IntToStr(cmbTraderLinks.ItemIndex+1), '');
    //Employee  Settings Tab
    //RB 02/01/2017 ABSEXCH-19594: GDPR Configuration window > Trader/Employee Retention Period > Value is not saving if Value changed through increment / decrement button.
    UpdateSystemSetupValue(lRes, siGDPREmployeeRetentionPeriod, IntToStr(GDPREmployeeRetentionPeriod), Trim(edtEmployeeRetPer.Text), '');
    UpdateSystemSetupValue(lRes, siGDPREmployeeDisplayPIITree, BooleanToStr(GDPREmployeeDisplayPIITree), BooleanToStr(chkEmployeeDispPIIInfoWin.Checked), '');
    UpdateSystemSetupValue(lRes, siGDPREmployeeAnonNotesOption, IntToStr(GDPREmployeeAnonNotesOption), IntToStr(cmbEmployeeNotes.ItemIndex+1), '');
    UpdateSystemSetupValue(lRes, siGDPREmployeeAnonLettersOption, IntToStr(GDPREmployeeAnonLettersOption), IntToStr(cmbEmployeeLetters.ItemIndex+1), '');
    UpdateSystemSetupValue(lRes, siGDPREmployeeAnonLinksOption, IntToStr(GDPREmployeeAnonLinksOption), IntToStr(cmbEmployeeLinks.ItemIndex+1), '');
    //Notification Tab
    UpdateSystemSetupValue(lRes, siNotificationWarningColour, IntToStr(NotificationWarningColour), IntToStr(shpNotifiStatus.Brush.Color), '');
    UpdateSystemSetupValue(lRes, siNotificationWarningFontColour, IntToStr(NotificationWarningFontColour), IntToStr(lblAnonStatus.Font.Color), '');
    //Company Anonymisation Tab
    UpdateSystemSetupValue(lRes, siGDPRCompanyNotesOption, IntToStr(GDPRCompanyNotesOption), IntToStr(cmbCompNotes.ItemIndex+1), '');
    UpdateSystemSetupValue(lRes, siGDPRCompanyLettersOption, IntToStr(GDPRCompanyLettersOption), IntToStr(cmbCompLetters.ItemIndex+1), '');
    UpdateSystemSetupValue(lRes, siGDPRCompanyLinksOption, IntToStr(GDPRCompanyLinksOption), IntToStr(cmbCompLinks.ItemIndex+1), '');
    UpdateSystemSetupValue(lRes, siGDPRCompanyAnonCostCentres, BooleanToStr(GDPRCompanyAnonCostCentres), BooleanToStr(chkCompAnonCostCentre.Checked), '');
    UpdateSystemSetupValue(lRes, siGDPRCompanyAnonDepartment, BooleanToStr(GDPRCompanyAnonDepartment), BooleanToStr(chkCompAnonDepartments.Checked), '');
    UpdateSystemSetupValue(lRes, siGDPRCompanyAnonLocations, BooleanToStr(GDPRCompanyAnonLocations), BooleanToStr(chkCompAnonLocations.Checked), '');

  end;
  if lRes = 0 then
    Close;
end;

//------------------------------------------------------------------------------

procedure TfrmGDPRConfiguration.btnCancelClick(Sender: TObject);
begin
  Close;
end;

//------------------------------------------------------------------------------

procedure TfrmGDPRConfiguration.FormDestroy(Sender: TObject);
begin
  //RB 24/11/2017 2018-R1 ABSEXCH-19467: GDPR Configuration window - Auditing
  FGDPRConfigAudit := NIL;
end;

procedure TfrmGDPRConfiguration.edtTraderRetPerExit(Sender: TObject);
begin
  if edtTraderRetPer.Value > 30 then
    edtTraderRetPer.Value := 30;

  if edtTraderRetPer.Value <= 0 then
    edtTraderRetPer.Value := 1;

  udTraderRetPer.Position := Round(edtTraderRetPer.Value);
end;

procedure TfrmGDPRConfiguration.edtEmployeeRetPerExit(Sender: TObject);
begin
  if edtEmployeeRetPer.Value > 30 then
    edtEmployeeRetPer.Value := 30;

  if edtEmployeeRetPer.Value <= 0 then
    edtEmployeeRetPer.Value := 1;
  udEmployeeRetPer.Position := Round(edtEmployeeRetPer.Value);
end;

end.
