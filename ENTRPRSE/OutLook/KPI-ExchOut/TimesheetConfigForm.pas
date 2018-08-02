unit TimesheetConfigForm;

{******************************************************************************}
{* The following change has been made to the TMS Components to draw a box     *}
{* around a flat TColumnComboBox:-                                            *}
{* In AdvCombo.pas, procedure TAdvCustomCombo.DrawControlBorder(DC: HDC);

    if FFlat and (FFlatLineColor <> clNone) then
    begin
      OldPen := SelectObject(DC,CreatePen( PS_SOLID,1,ColorToRGB(FFlatLineColor)));
      MovetoEx(DC,ARect.Left - 2,Height - 1,nil);
      LineTo(DC,ARect.Right - 18 ,Height - 1);
      LineTo(DC,ARect.Right - 18, 0);            // ***BJH***
      LineTo(DC, 0, 0);                          // ***BJH***
      LineTo(DC, 0, Height - 1);                 // ***BJH***
      DeleteObject(SelectObject(DC,OldPen));
    end;


{******************************************************************************}

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ComCtrls, StdCtrls, ExtCtrls, AdvMenus,
  AdvMenuStylers, GradientLabel, AdvGlowButton, AdvSpin, htmlbtns, Mask,
  AdvOfficePager, AdvPanel, AdvOfficePagerStylers, AdvCombo, ColCombo,
  rtflabel, Enterprise01_TLB, ComObj, ActiveX, AdvEdit, KPICommon, TTimesheetIniClass,
  ImgList, TEmployeeRateClass;

type

  TPopType = (ptNone, ptAll, ptCC, ptDept, ptCurr, ptJobs, ptRate, ptAnalysis, ptEmp, ptUser, ptAssUser, ptTsStatus, ptNoteGen, ptUDFs);

  TfrmConfigureTimesheets = class(TForm)
    advPanel: TAdvPanel;
    btnSave: TAdvGlowButton;
    btnCloseCancel: TAdvGlowButton;
    ofConfig: TAdvOfficePager;
    ofpCustSupp: TAdvOfficePage;
    gbDefaults: TGroupBox;
    pnlInfo: TPanel;
    lblInfo: TLabel;
    ccbCostCentre: TColumnComboBox;
    lblCostCentre: TLabel;
    lblDepartment: TLabel;
    ccbDepartment: TColumnComboBox;
    edtNoteText: TAdvEdit;
    pnlRounded: TPanel;
    pgStyler: TAdvOfficePagerOfficeStyler;
    Label9: TLabel;
    ccbCurrency: TColumnComboBox;
    gbCompany: TGroupBox;
    lblCompany: TLabel;
    ccbCompany: TColumnComboBox;
    gbUserDefs: TGroupBox;
    gbMisc: TGroupBox;
    Label2: TLabel;
    cbTHUDF1: TCheckBox;
    cbTHUDF2: TCheckBox;
    cbTHUDF3: TCheckBox;
    cbTHUDF4: TCheckBox;
    cbTLUDF1: TCheckBox;
    cbTLUDF2: TCheckBox;
    Label4: TLabel;
    btnReset: TAdvGlowButton;
    Label6: TLabel;
    cbChargeOutRate: TCheckBox;
    cbCostPerHour: TCheckBox;
    cbCostCentre: TCheckBox;
    cbDepartment: TCheckBox;
    cbRateCode: TCheckBox;
    cbAnalysisCode: TCheckBox;
    ccbNoteGen: TColumnComboBox;
    Label7: TLabel;
    ccbTimesheetStatus: TColumnComboBox;
    Label8: TLabel;
    lblRateCode: TLabel;
    ccbRateCode: TColumnComboBox;
    Label11: TLabel;
    ccbAnalysisCode: TColumnComboBox;
    Label12: TLabel;
    ccbUserProfile: TColumnComboBox;
    cbAdministrator: TCheckBox;
    Label13: TLabel;
    ccbAssociatedUserProfile: TColumnComboBox;
    lblUserName: TLabel;
    lblPassword: TLabel;
    btnLogin: TAdvGlowButton;
    Bevel1: TBevel;
    edtPassword: TEdit;
    edtUsername: TEdit;
    lblEmployeeID: TLabel;
    ccbEmployeeID: TColumnComboBox;
    lblLoggingIn: TLabel;
    btnSetODDInfo: TAdvGlowButton;
    ImageList: TImageList;
    Bevel2: TBevel;
    Bevel3: TBevel;
    gbShowWhat: TGroupBox;
    rbShowTotalHours: TRadioButton;
    rbShowTotalCharge: TRadioButton;
    btnUnhookUserEmp: TAdvGlowButton;
    lblJobCode: TLabel;
    ccbJobCode: TColumnComboBox;
    lblLocked: TLabel;
    rbShowTotalCost: TRadioButton;
    lblUnhookUserEmp: TLabel;
    cbTHUDF5: TCheckBox;
    cbTHUDF6: TCheckBox;
    cbTHUDF7: TCheckBox;
    cbTHUDF8: TCheckBox;
    cbTHUDF9: TCheckBox;
    cbTHUDF10: TCheckBox;
    cbTLUDF6: TCheckBox;
    cbTLUDF5: TCheckBox;
    cbTLUDF7: TCheckBox;
    cbTLUDF8: TCheckBox;
    cbTLUDF9: TCheckBox;
    cbTLUDF10: TCheckBox;
    procedure advPanelDblClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormKeyPress(Sender: TObject; var Key: Char);
    procedure FormActivate(Sender: TObject);
    procedure pnlInfoMouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure edtUserDef1Enter(Sender: TObject);
    procedure ccbCompanyChange(Sender: TObject);
    procedure ccbCurrencyChange(Sender: TObject);
    procedure btnCloseCancelClick(Sender: TObject);
    procedure btnLoginClick(Sender: TObject);
    procedure btnResetClick(Sender: TObject);
    procedure btnSaveClick(Sender: TObject);
    procedure btnSetODDInfoClick(Sender: TObject);
    procedure btnUnhookUserEmpClick(Sender: TObject);
    procedure ccbEmployeeIDChange(Sender: TObject);
    procedure ccbJobCodeChange(Sender: TObject);
    procedure ccbRateCodeChange(Sender: TObject);
    procedure ccbUserProfileChange(Sender: TObject);
    procedure ControlChanged(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure rbShowTotalChargeClick(Sender: TObject);
    procedure rbShowTotalCostClick(Sender: TObject);
    procedure rbShowTotalHoursClick(Sender: TObject);
  private
    FCanClose: boolean;
    FCompany: ShortString;
    FCurrency: Integer;
    FDataPath: WideString;
    FNetworkName: WideString;
    FCurrSymb: WideString;
    FLoggedIn: boolean;
    FIsDirty: boolean;
    FUserID: string;
    FEmployeeID: string;
    FUserName: WideString;
    FEmployeeName: string;
    FDefaultEmpCC: string;
    FDefaultEmpDD: string;
    FEmTimeRateRules: TTimeRateRulesType;
    procedure CullEmployees;
    procedure EnableDisableEtc(LoggedIn: boolean);
    Function  GetCompany : ShortString;
    procedure HighlightViewableEmployees;
    Procedure SetCompany (Value : ShortString);
    Procedure SetHost (Value : HWND);
    procedure PopulateLists;
    procedure PopulateCompanyList;
    procedure PopulateCCDeptCurrListsEtc(LoggedIn: boolean; PopWhat: TPopType);
    procedure MakeRounded(Control: TWinControl);
    procedure LoadDLL;
    procedure SaveSettings;
    procedure IsClean;
    procedure IsDirty(AffectsSettingsFile: boolean);
    procedure LoadSettings;
    procedure MimicLogin;
    procedure RebuildRateCodeList;
    procedure SetEmployeeID(const Value: string);   // This is the EmployeeID of the timesheet displayed in the ODD
    procedure SetUserName(const Value: WideString);
    procedure ResetUDFs;
    procedure RetrieveEmployeeDefaults;
  public
    constructor create(DataPath: WideString);
    procedure Startup;
    property Company :   ShortString Read GetCompany Write SetCompany;
    property ConfigCurrency: Integer read FCurrency write FCurrency;
    property ConfigCurrSymb: WideString read FCurrSymb write FCurrSymb;
    property EmployeeID: string read FEmployeeID write SetEmployeeID;
    property EmployeeName: string read FEmployeeName write FEmployeeName;
    Property Host :      HWND Write SetHost;
    property UserName: WideString read FUserName write SetUserName;
  protected
  end;

implementation

uses CTKUtil;

{$R *.dfm}

type
  TWinPos = Record
    wpLeft, wpTop, wpWidth, wpHeight : LongInt;
  End;

  TExecutePlugin = function(sUserDefField, sField, sFieldName, sDataPath, sUserName : string; WinPos : TWinPos;
                       var bResult, bShown : boolean; bValidate : boolean = FALSE): string; stdcall;
  TOpenFiles     = function(asPath : ANSIString) : boolean; stdcall;
  TCloseFiles    = procedure; stdcall;

var
  FDLLHandle:    THandle;
  ExecutePlugin: TExecutePlugin;
  OpenFiles:     TOpenFiles;
  CloseFiles:    TCloseFiles;


//{EXTERNAL FUNCTIONS LOCATED IN USRFDLG.DLL}
//function ExecutePlugIn(sUserDefField, sField, sFieldName, sDataPath, sUserName : string; WinPos : TWinPos;
//                       var bResult, bShown : boolean; bValidate : boolean = FALSE): string; stdCall; external 'USRFDLG.DLL';

//=========================================================================

procedure TfrmConfigureTimesheets.FormCreate(Sender: TObject);
var
  buffer: array[0..20] of char;
  buflen: cardinal;
begin
  // Centre - can't use poScreenCentre because of Host property not working
  Self.Top := (Screen.Height - - Self.Height) Div 2;
  Self.Left := (Screen.Width - Self.Width) Div 2;
  MakeRounded(self);
  MakeRounded(pnlRounded);
  MakeRounded(advPanel);
  buflen := 20;
  GetUserName(buffer, buflen);
  FNetworkName := string(buffer);
  FLoggedIn := false;
  EnableDisableEtc(false);
end;

//-------------------------------------------------------------------------

function TfrmConfigureTimesheets.GetCompany: ShortString;
begin
  Result := ccbCompany.ColumnItems[ccbCompany.ItemIndex, 0];
end;
procedure TfrmConfigureTimesheets.SetCompany(Value: ShortString);
begin
  FCompany := Value;
end;

//------------------------------

Procedure TfrmConfigureTimesheets.SetHost (Value : HWND);
Var
  lpRect: TRect;
Begin // SetHost
  If (Value <> 0) Then
  Begin
    // Get the host window position and centre the login dialog over it
    If GetWindowRect(Value, lpRect) Then
    Begin
      // Top = Top of Host + (0.5 * Host Height) - (0.5 * Self Height)
      Self.Top := lpRect.Top + ((lpRect.Bottom - lpRect.Top - Self.Height) Div 2);

      // Left = Left of Host + (0.5 * Host Width) - (0.5 * Self Width)
      Self.Left := lpRect.Left + ((lpRect.Right - lpRect.Left - Self.Width) Div 2);

      // Make sure it is still fully on the screen
      If (Self.Top < 0) Then Self.Top := 0;
      If ((Self.Top + Self.Height) > Screen.Height) Then Self.Top := Screen.Height - Self.Height;
      If (Self.Left < 0) Then Self.Left := 0;
      If ((Self.Left + Self.Width) > Screen.Width) Then Self.Left := Screen.Width - Self.Width;
    End; // If GetWindowRect(Value, lpRect)
  End; // If (Value <> 0)
End; // SetHost

constructor TfrmConfigureTimesheets.create(DataPath: WideString);
begin
  inherited create(nil);
  DataPath  := trim(DataPath);
  FDataPath := DataPath;
  TimesheetSettings.Free; // v13 recreate the object so that it picks up changes made by someone else
  TimesheetSettings(FDataPath);
end;

procedure TfrmConfigureTimesheets.advPanelDblClick(Sender: TObject);
begin
  ShowDLLDetails(Sender, 0, false);
end;

procedure TfrmConfigureTimesheets.Startup;
begin
  FCurrency := 1; // *** not multi-currency yet then ?
  FCurrSymb := '£';
  lblInfo.Caption := self.Caption;
  PopulateLists;
end;

procedure TfrmConfigureTimesheets.PopulateLists;
begin
  PopulateCompanyList;
end;

procedure TfrmConfigureTimesheets.PopulateCompanyList;
var
  toolkit: IToolkit;
  i : SmallInt;
begin
  toolkit := CoToolkit.Create;
  if assigned(toolkit) then
  try
    if (Toolkit.Company.cmCount > 0) then
      with Toolkit.Company do
        for i := 1 to cmCount do
          if DirectoryExists(cmCompany[i].coPath) then
             with ccbCompany.ComboItems.Add do begin
                strings.Add(trim(cmCompany[i].coCode));
                strings.Add(trim(cmCompany[i].coName));
                strings.Add(trim(cmCompany[i].coPath));
             end;
    ccbCompany.ItemIndex := ccbCompany.ComboItems.IndexInColumnOf(0, FCompany);
  finally
    toolkit := nil;
  end;
  if ccbCompany.ItemIndex <> -1 then begin
    ccbCompanyChange(nil);
    IsClean;
  end;
end;

procedure TfrmConfigureTimesheets.PopulateCCDeptCurrListsEtc(LoggedIn: boolean; PopWhat: TPopType);
var
  toolkit: IToolkit2;
  i : SmallInt;
  CCDept: ICCDept;
  res: integer;
  JobAnalysis: IJobAnalysis;
  TimeRates: ITimeRates;
  Employee: IEmployee3;
  UserProfile: IUserProfile;
  SavedEmpIx: integer;
  Job: IJob;

  function CheckCurrSymb(ACurrSymb: WideString): WideString;
  begin
    if ACurrSymb = '' then
      result := '-' else
    if trim(ACurrSymb) = #156 then
      result := '£'
    else
      result := ACurrSymb;
  end;

begin
  if FDataPath = '' then EXIT;

  toolkit := OpenToolkit(FDataPath, true) as IToolkit2;
  try
    if LoggedIn then
      with toolkit.SystemSetup do begin
        lblCostCentre.Visible := ssUseCCDept;
        ccbCostCentre.Visible := ssUseCCDept;
        lblDepartment.Visible := ssUseCCDept;
        ccbDepartment.Visible := ssUseCCDept;
        cbCostCentre.Visible  := ssUseCCDept;
        cbDepartment.Visible  := ssUseCCDept;
      end;

    if (PopWhat in [ptAll, ptCC]) then begin
      ccbCostCentre.ComboItems.Clear;
      if LoggedIn then
      if toolkit.SystemSetup.ssUseCCDept then begin
        CCDept := Toolkit.CostCentre;
        if assigned(CCDept) then
        try
          with CCDept do begin
            index := cdIdxCode;
            res := GetFirst;
            while res = 0 do begin
              with ccbCostCentre.ComboItems.Add do begin
                strings.Add(trim(cdCode));
                strings.Add(trim(cdName));
              end;
              res := GetNext;
            end;
          end;
          ccbCostCentre.ItemIndex := ccbCostCentre.ComboItems.IndexInColumnOf(0, TimesheetSettings.DefaultCostCentre);
          if (ccbCostCentre.ItemIndex = -1) and (ccbCostCentre.ComboItems.Count > 0) then ccbCostCentre.ItemIndex := 0;
        finally
          CCDept := nil;
        end;
      end;
    end;

    if (PopWhat in [ptAll, ptDept]) then begin
      ccbDepartment.ComboItems.Clear;
      if LoggedIn then
      if toolkit.SystemSetup.ssUseCCDept then begin
        CCDept := Toolkit.Department;
        if assigned(CCDept) then
        try
          with CCDept do begin
            index := cdIdxCode;
            res := GetFirst;
            while res = 0 do begin
              with ccbDepartment.ComboItems.Add do begin
                strings.Add(trim(cdCode));
                strings.Add(trim(cdName));
              end;
              res := GetNext;
            end;
          end;
          ccbDepartment.ItemIndex := ccbDepartment.ComboItems.IndexInColumnOf(0, TimesheetSettings.DefaultDepartment);
          if (ccbDepartment.ItemIndex = -1) and (ccbDepartment.ComboItems.Count > 0) then ccbDepartment.ItemIndex := 0;
        finally
          CCDept := nil;
        end;
      end;
    end;

    if (PopWhat in [ptAll, ptCurr]) then begin
      ccbCurrency.ComboItems.Clear;
      if LoggedIn then begin
        with Toolkit.SystemSetup do
          for i := 0 to ssMaxCurrency do
            with ssCurrency[i] do
              if scSymbol <> '' then
                with ccbCurrency.ComboItems.Add do begin
                  strings.Add(CheckCurrSymb(scSymbol));
                  strings.Add(scDesc);
                  strings.Add(IntToStr(i));
                  if i = TimesheetSettings.DefaultCurrency then begin
                    ccbCurrency.ItemIndex := ccbCurrency.ComboItems.Count - 1; // select latest addition
                    FCurrSymb := CheckCurrSymb(scSymbol);
                  end;
                end;
        if (ccbCurrency.ItemIndex = -1) and (ccbCurrency.ComboItems.Count > 0) then ccbCurrency.ItemIndex := FCurrency;
      end;
    end;

    if (PopWhat in [ptAll, ptJobs]) then begin
      ccbJobCode.ComboItems.Clear;
      if LoggedIn then begin
        Job := Toolkit.JobCosting.Job;
        if assigned(Job) then
        try
          with Job do begin
            index := jrIdxCode;
            res   := GetFirst;
            while res = 0 do begin
              if (jrStatus = jStatusActive) and (jrType = JTypeJob) then
                with ccbJobCode.ComboItems.Add do begin
                  strings.Add(trim(jrCode));
                  strings.Add(trim(jrDesc));
                end;
              res := GetNext;
            end;
          end;
          ccbJobCode.ItemIndex := ccbJobCode.ComboItems.IndexInColumnOf(0, TimesheetSettings.DefaultJobCode);
          if (ccbJobCode.ItemIndex = -1) and (ccbJobCode.ComboItems.Count > 0) then ccbJobCode.ItemIndex := 0;
        finally
          Job := nil;
        end;
      end;
    end;

    if (PopWhat in [ptAll, ptRate]) then begin
      ccbRateCode.ComboItems.Clear;
      if LoggedIn then begin
        TimeRates := Toolkit.JobCosting.TimeRates;
        if assigned(TimeRates) then
        try
          with TimeRates do begin
            res := GetFirst;
            while res = 0 do begin
              with ccbRateCode.ComboItems.Add do begin
                strings.Add(trim(trRateCode));
                strings.Add(trim(trDescription));
                strings.Add(trim(trAnalysisCode));
              end;
              res := GetNext;
            end;
            ccbRateCode.ItemIndex := ccbRateCode.ComboItems.IndexInColumnOf(0, TimesheetSettings.DefaultRateCode);
            if (ccbRateCode.ItemIndex = -1) and (ccbRateCode.ComboItems.Count > 0) then ccbRateCode.ItemIndex := 0;
          end;
        finally
          TimeRates := nil;
        end;
      end;
    end;

    if (PopWhat in [ptAll, ptAnalysis]) then begin
      ccbAnalysisCode.ComboItems.Clear;
      if LoggedIn then begin
        JobAnalysis := Toolkit.JobCosting.JobAnalysis;
        if assigned(JobAnalysis) then
        try
          with JobAnalysis do begin
            index := anIdxCode;
            res   := GetFirst;
            while res = 0 do begin
              with ccbAnalysisCode.ComboItems.Add do begin
                strings.Add(trim(anCode));
                strings.Add(trim(anDescription));
              end;
              res := GetNext;
            end;
            ccbAnalysisCode.ItemIndex := ccbAnalysisCode.ComboItems.IndexInColumnOf(0, TimesheetSettings.DefaultAnalysisCode);
            if (ccbAnalysisCode.ItemIndex = -1) and (ccbAnalysisCode.ComboItems.Count > 0) then ccbAnalysisCode.ItemIndex := 0;
          end;
        finally
          JobAnalysis := nil;
        end;
      end;
    end;

    if (PopWhat in [ptAll, ptUser]) then begin
      ccbUserProfile.ComboItems.Clear;
      if LoggedIn then begin
        UserProfile := Toolkit.UserProfile;
        if assigned(UserProfile) then
        try
          with UserProfile do begin
            index := usIdxLogin;
            res   := GetFirst;
            while res = 0 do begin
              with ccbUserProfile.ComboItems.Add do begin
                strings.Add(trim(upUserID));
                strings.Add(trim(upName));
              end;
              res := GetNext;
            end;
          end;
          ccbUserProfile.ItemIndex := ccbUserProfile.ComboItems.IndexInColumnOf(0, FUserID);
        finally
          UserProfile := nil;
        end;
      end;
      if (ccbUserProfile.ItemIndex = -1) and (ccbUserProfile.ComboItems.Count > 0) then ccbUserProfile.ItemIndex := 0;
      cbAdministrator.Checked := TimesheetSettings.IsAdministrator[ccbUserProfile.ColumnItems[ccbUserProfile.ItemIndex, 0]];
      cbAdministrator.Enabled := TimesheetSettings.IsAdministrator[FUserID];
    end;

    if (PopWhat in [ptAll, ptEmp]) then begin
      SavedEmpIx := ccbEmployeeID.ItemIndex;
      ccbEmployeeID.ComboItems.Clear;
      if FLoggedIn then begin // important to use the global FLoggedIn when not an administrator - ccbEmployeeID always populated
        Employee := Toolkit.JobCosting.Employee as IEmployee3;
        if assigned(Employee) then
        try
          with Employee do begin
            Index := emIdxCode;
            res   := GetFirst;
            while res = 0 do begin
              if not ((emType = emTypeSubContract) and emLabourViaPL) then // v15
                with ccbEmployeeID.ComboItems.Add do begin
                  strings.Add(trim(emCode));
                  strings.Add(trim(emName));
                  if TimesheetSettings.CanView(ccbUserProfile.ColumnItems[ccbUserProfile.ItemIndex, 0], trim(emCode)) then // v18
                    ImageIndex := 0
                  else
                    ImageIndex := -1;
                end;
              res := GetNext;
            end;
            with ccbEmployeeID.ComboItems.Add do begin
              strings.Add(''); strings.Add(''); ImageIndex := -1; // final image doesn't display correctly so add dummy employee to take the flak
            end;
          end;
          CullEmployees; // remove the Employees that the logged-in user can't view
          if PopWhat = ptEmp then
            ccbEmployeeID.ItemIndex := SavedEmpIx
          else begin
            ccbEmployeeID.ItemIndex := ccbEmployeeID.ComboItems.IndexInColumnOf(1, FEmployeeID);
            if (ccbEmployeeID.ItemIndex = -1) and (ccbEmployeeID.ComboItems.Count > 0) then ccbEmployeeID.ItemIndex := 0;
          end;
          btnUnhookUserEmp.Enabled := TimesheetSettings.CanView(ccbUserProfile.ColumnItems[ccbUserProfile.ItemIndex, 0], ccbEmployeeID.ColumnItems[ccbEmployeeID.ItemIndex, 1]);
          lblUnhookUserEmp.Enabled := btnUnhookUserEmp.Enabled; // v14
        finally
          Employee := nil;
        end;
      end;
    end;

    if (PopWhat in [ptAll, ptAssUser]) then begin
      ccbAssociatedUserProfile.ComboItems.Clear;
      if LoggedIn then begin
        ccbAssociatedUserProfile.ComboItems.Assign(ccbUserProfile.ComboItems);
        ccbAssociatedUserProfile.ItemIndex := ccbAssociatedUserProfile.ComboItems.IndexInColumnOf(0, TimesheetSettings.AssociatedUserID[ccbUserProfile.ColumnItems[ccbUserProfile.ItemIndex, 0]]);
      end;
    end;


    if (PopWhat in [ptAll, ptTsStatus]) then begin
      ccbTimesheetStatus.ComboItems.Clear;
      if LoggedIn then begin
        ccbTimesheetStatus.ComboItems.Add.Strings.Add('Not Held');
        ccbTimesheetStatus.ComboItems.Add.Strings.Add('Hold for Query');
        ccbTimesheetStatus.ItemIndex := 0;
      end;
    end;

    if (PopWhat in [ptAll, ptNoteGen]) then begin
      ccbNoteGen.ComboItems.Clear;
      if LoggedIn then begin
        ccbNoteGen.ComboItems.Add.Strings.Add('Never Generate Note');
        ccbNoteGen.ComboItems.Add.Strings.Add('Generate for ALL Timesheets');
        ccbNoteGen.ComboItems.Add.Strings.Add('Generate for Timesheets on Query');
        ccbNoteGen.ComboItems.Add.Strings.Add('Generate for Timesheets NOT on Query');
        ccbNoteGen.ItemIndex := 0;
      end;
    end;

    if (PopWhat in [ptAll, ptUDFs]) then begin
      if LoggedIn then
      with toolkit.SystemSetup.ssUserFields as ISystemSetupUserFields2 do begin
          cbTHUDF1.Checked := ufTSHEnabled[1];
          cbTHUDF1.Enabled := ufTSHEnabled[1];
          cbTHUDF2.Checked := ufTSHEnabled[2];
          cbTHUDF2.Enabled := ufTSHEnabled[2];
          cbTHUDF3.Checked := ufTSHEnabled[3];
          cbTHUDF3.Enabled := ufTSHEnabled[3];
          cbTHUDF4.Checked := ufTSHEnabled[4];
          cbTHUDF4.Enabled := ufTSHEnabled[4];

          cbTLUDF1.Checked := ufTSHLineEnabled[1];
          cbTLUDF1.Enabled := ufTSHLineEnabled[1];
          cbTLUDF2.Checked := ufTSHLineEnabled[2];
          cbTLUDF2.Enabled := ufTSHLineEnabled[2];

          cbTHUDF1.Caption := ufTSHDesc[1];
          cbTHUDF2.Caption := ufTSHDesc[2];
          cbTHUDF3.Caption := ufTSHDesc[3];
          cbTHUDF4.Caption := ufTSHDesc[4];
          cbTLUDF1.Caption := ufTSHLineDesc[1];
          cbTLUDF2.Caption := ufTSHLineDesc[2];

          { CJS 2012-08-29 - ABSEXCH-12450 - ODD support for UDFs 5-10 }
          cbTHUDF5.Caption  := ufTSHDesc[5];
          cbTHUDF5.Checked  := ufTSHEnabled[5];
          cbTHUDF5.Enabled  := ufTSHEnabled[5];
          cbTHUDF6.Caption  := ufTSHDesc[6];
          cbTHUDF6.Checked  := ufTSHEnabled[6];
          cbTHUDF6.Enabled  := ufTSHEnabled[6];
          cbTHUDF7.Caption  := ufTSHDesc[7];
          cbTHUDF7.Checked  := ufTSHEnabled[7];
          cbTHUDF7.Enabled  := ufTSHEnabled[7];
          cbTHUDF8.Caption  := ufTSHDesc[8];
          cbTHUDF8.Checked  := ufTSHEnabled[8];
          cbTHUDF8.Enabled  := ufTSHEnabled[8];
          cbTHUDF9.Caption  := ufTSHDesc[9];
          cbTHUDF9.Checked  := ufTSHEnabled[9];
          cbTHUDF9.Enabled  := ufTSHEnabled[9];
          cbTHUDF10.Caption := ufTSHDesc[10];
          cbTHUDF10.Checked := ufTSHEnabled[10];
          cbTHUDF10.Enabled := ufTSHEnabled[10];

          cbTLUDF5.Caption  := ufTSHLineDesc[5];
          cbTLUDF5.Checked  := ufTSHLineEnabled[5];
          cbTLUDF5.Enabled  := ufTSHLineEnabled[5];
          cbTLUDF6.Caption  := ufTSHLineDesc[6];
          cbTLUDF6.Checked  := ufTSHLineEnabled[6];
          cbTLUDF6.Enabled  := ufTSHLineEnabled[6];
          cbTLUDF7.Caption  := ufTSHLineDesc[7];
          cbTLUDF7.Checked  := ufTSHLineEnabled[7];
          cbTLUDF7.Enabled  := ufTSHLineEnabled[7];
          cbTLUDF8.Caption  := ufTSHLineDesc[8];
          cbTLUDF8.Checked  := ufTSHLineEnabled[8];
          cbTLUDF8.Enabled  := ufTSHLineEnabled[8];
          cbTLUDF9.Caption  := ufTSHLineDesc[9];
          cbTLUDF9.Checked  := ufTSHLineEnabled[9];
          cbTLUDF9.Enabled  := ufTSHLineEnabled[9];
          cbTLUDF10.Caption := ufTSHLineDesc[10];
          cbTLUDF10.Checked := ufTSHLineEnabled[10];
          cbTLUDF10.Enabled := ufTSHLineEnabled[10];

        end;
    end;

  finally
    toolkit := nil;
  end;

  // do this now that we've closed the toolkit otherwise it'll give a 32762 error.
//  if PopWhat in [ptAll, ptEmp] then
//    if (ccbEmployeeID.ItemIndex = 0) and (ccbEmployeeID.ComboItems.Count = 2) then ccbEmployeeIDChange(nil); // v15 - allow for only one emp in list

//  btnSave.enabled := true;
end;

procedure TfrmConfigureTimesheets.FormKeyPress(Sender: TObject; var Key: Char);
begin
  if key = #13 then begin
    SendMessage(Handle, WM_NEXTDLGCTL, 0, 0);
    key := #0;
  end;
end;

procedure TfrmConfigureTimesheets.FormActivate(Sender: TObject);
begin
  edtUsername.SetFocus;
end;

procedure TfrmConfigureTimesheets.pnlInfoMouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
const
  SC_DRAGMOVE = SC_MOVE + HTCAPTION; // = $F012
begin
  if Button = mbLeft then begin
    ReleaseCapture;
    Perform(WM_SYSCOMMAND, SC_DRAGMOVE, 0);
  end;
end;

procedure TfrmConfigureTimesheets.MakeRounded(Control: TWinControl);
var
  R: TRect;
  Rgn: HRGN;
begin
  with Control do
  begin
    R := ClientRect;
    rgn := CreateRoundRectRgn(R.Left, R.Top, R.Right, R.Bottom, 20, 20);
    Perform(EM_GETRECT, 0, lParam(@r));
    InflateRect(r, -5, -5);
    Perform(EM_SETRECTNP, 0, lParam(@r));
    SetWindowRgn(Handle, rgn, True);
    Invalidate;
  end;
end;

procedure TfrmConfigureTimesheets.edtUserDef1Enter(Sender: TObject);
// this event has been detached from the user-def field edit boxes
// until the Sharemem issue has been resolved.
var
  WinPos: TWinPos;
  res: boolean;
  shown: boolean;
  CSuser: string;
  BoxCaption: string;
begin
  LoadDLL;
  WinPos.wpLeft   := self.Left + 20;
  WinPos.wpTop    := self.Top  + 20;
  WinPos.wpWidth  := 200;
  WinPos.wpHeight := 200;
  with TAdvEdit(Sender) do begin
//    case tag of
//      1: BoxCaption := lblUserDef1.Caption;
//      2: BoxCaption := lblUserDef2.Caption;
//      3: BoxCaption := lblUserDef3.Caption;
//      4: BoxCaption := lblUserDef4.Caption;
//    end;
    CSuser := CSuser + IntToStr(Tag); // e.g. CustUser1
    Text := ExecutePlugin(CSuser, Text, BoxCaption, FDataPath, FUserName, WinPos, res, shown, false);
  end;
end;

procedure TfrmConfigureTimesheets.SetUserName(const Value: WideString);
begin
  FUserName := Value;
end;

procedure TfrmConfigureTimesheets.LoadDLL;
// the user-def field plug-in functionality is currently disabled because
// it uses Sharemem which causes Outlook to crash on Exit.
// As a result, the LoadLibrary command below has been left in its original
// test state.
begin
  if FDLLhandle = 0 then begin
    FDLLHandle := LoadLibrary('c:\ent571\usrfdlg.dll');
    if FDLLHandle = 0 then
      ShowMessage('Cannot load UserDef library')
    else begin
       OpenFiles     := GetProcAddress(FDLLHandle, 'OpenFiles');
       ExecutePlugin := GetProcAddress(FDLLHandle, 'ExecutePlugIn');
       CloseFiles    := GetProcAddress(FDLLHandle, 'CloseFiles');
       OpenFiles(FDataPath);
    end;
  end;
end;

procedure TfrmConfigureTimesheets.ccbCompanyChange(Sender: TObject);
begin
  btnSetODDInfo.Enabled := true;
  FDataPath := ccbCompany.ColumnItems[ccbCompany.ItemIndex, 2];
  FLoggedIn := false;
  FUserID   := '';
  TimesheetSettings.Free; // v13 - next statement will pick up a different Timesheet.dat file so force the object to be recreated
  TimesheetSettings(FDataPath);
  EnableDisableEtc(False);
  IsDirty(false);
end;

procedure TfrmConfigureTimesheets.ccbCurrencyChange(Sender: TObject);
begin
  FCurrency := StrToInt(ccbCurrency.ColumnItems[ccbCurrency.ItemIndex, 2]);
  FCurrSymb := ccbCurrency.ColumnItems[ccbCurrency.ItemIndex, 0];
  IsDirty(true);
end;

procedure TfrmConfigureTimesheets.btnCloseCancelClick(Sender: TObject);
begin
  if btnCloseCancel.Caption = '&Close' then
    FCanClose := true
  else
    FCanClose := MessageDlg('Are you sure you want to cancel your changes ?', mtConfirmation, [mbYes, mbNo], 0) = mrYes;
end;

procedure TfrmConfigureTimesheets.btnLoginClick(Sender: TObject);
begin
  MimicLogin;
end;

procedure TfrmConfigureTimesheets.btnResetClick(Sender: TObject);
begin
  ResetUDFs;
  ControlChanged(nil);
  IsDirty(true);
end;

procedure TfrmConfigureTimesheets.btnSaveClick(Sender: TObject);
begin
  SaveSettings;
end;

procedure TfrmConfigureTimesheets.btnSetODDInfoClick(Sender: TObject);
begin
  btnSetODDInfo.Enabled := false;
  FEmployeeID := ccbEmployeeID.ColumnItems[ccbEmployeeID.ItemIndex, 1];
  FEmployeeName := ccbEmployeeID.ColumnItems[ccbEmployeeID.ItemIndex, 2];
end;

procedure TfrmConfigureTimesheets.btnUnhookUserEmpClick(Sender: TObject); // v13
begin
  TimesheetSettings.SetCanView(ccbUserProfile.ColumnItems[ccbUserProfile.ItemIndex, 0], ccbEmployeeID.ColumnItems[ccbEmployeeID.ItemIndex, 1], False);
  HighlightViewableEmployees;
  IsDirty(true);
end;

procedure TfrmConfigureTimesheets.ccbEmployeeIDChange(Sender: TObject);
begin
  if ccbEmployeeID.ItemIndex = ccbEmployeeID.ComboItems.Count - 1 then
    ccbEmployeeID.ItemIndex := ccbEmployeeID.ItemIndex - 1; // fudge to prevent them selecting the final dummy employee (see PopulateCCDep...)
  RebuildRateCodeList;
  LoadSettings;
  RetrieveEmployeeDefaults;
  btnSetODDInfo.Enabled := true;
  if not TimesheetSettings.CanView(ccbUserProfile.ColumnItems[ccbUserProfile.ItemIndex, 0], ccbEmployeeID.ColumnItems[ccbEmployeeID.ItemIndex, 1]) then begin
    TimesheetSettings.SetCanView(ccbUserProfile.ColumnItems[ccbUserProfile.ItemIndex, 0], ccbEmployeeID.ColumnItems[ccbEmployeeID.ItemIndex, 1], True); // v13
    IsDirty(True); // we have a new combination that can be saved
  end
  else
    btnUnhookUserEmp.Enabled := true; // v13
end;

procedure TfrmConfigureTimesheets.ccbJobCodeChange(Sender: TObject);
begin
  RebuildRateCodeList;
  ControlChanged(nil);
end;

procedure TfrmConfigureTimesheets.ccbRateCodeChange(Sender: TObject);
begin
  if ccbRateCode.ColumnItems[ccbRateCode.ItemIndex, 2] <> '' then
    ccbAnalysisCode.ItemIndex := ccbAnalysisCode.ComboItems.IndexInColumnOf(0, ccbRateCode.ColumnItems[ccbRateCode.ItemIndex, 2]);
  ControlChanged(nil);
end;

procedure TfrmConfigureTimesheets.ccbUserProfileChange(Sender: TObject);
begin
  cbAdministrator.Checked := TimesheetSettings.IsAdministrator[ccbUserProfile.ColumnItems[ccbUserProfile.ItemIndex, 0]];
  ccbAssociatedUserProfile.ItemIndex := ccbAssociatedUserProfile.ComboItems.IndexInColumnOf(0, TimesheetSettings.AssociatedUserID[ccbUserProfile.ColumnItems[ccbUserProfile.ItemIndex, 0]]);
  HighlightViewableEmployees;
  IsDirty(true);
end;

procedure TfrmConfigureTimesheets.ControlChanged(Sender: TObject);
begin
  IsDirty(true);
end;

procedure TfrmConfigureTimesheets.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  if FCanClose then
    action := caFree
  else
    action := caNone;
  TimesheetSettings.UnlockSettingsFile;
end;

procedure TfrmConfigureTimesheets.LoadSettings;
begin
  TimesheetSettings(trim(FDataPath)).EmpCode := ccbEmployeeID.ColumnItems[ccbEmployeeID.ItemIndex, 1];
  if TimesheetSettings.DefaultsSet[ccbEmployeeID.ColumnItems[ccbEmployeeID.ItemIndex, 1]] then begin
    ccbCostCentre.ItemIndex      := ccbCostCentre.ComboItems.IndexInColumnOf(0, TimesheetSettings.DefaultCostCentre);
    ccbDepartment.ItemIndex      := ccbDepartment.ComboItems.IndexInColumnOf(0, TimesheetSettings.DefaultDepartment);
    ccbJobCode.ItemIndex         := ccbJobCode.ComboItems.IndexInColumnOf(0, TimesheetSettings.DefaultJobCode);
    ccbRateCode.ItemIndex        := ccbRateCode.ComboItems.IndexInColumnOf(0, TimesheetSettings.DefaultRateCode);
    ccbAnalysisCode.ItemIndex    := ccbAnalysisCode.ComboItems.IndexInColumnOf(0, TimesheetSettings.DefaultAnalysisCode);
    ccbTimesheetStatus.ItemIndex := ccbTimesheetStatus.ComboItems.IndexInColumnOf(0, TimesheetSettings.DefaultTimesheetStatus);
    ccbNoteGen.ItemIndex         := ccbNoteGen.ComboItems.IndexInColumnOf(0, TimesheetSettings.AutoGenNoteStatus);
    edtNoteText.Text             := TimesheetSettings.AutoGenNoteText;
    ccbCurrency.ItemIndex        := TimesheetSettings.DefaultCurrency;

    if cbTHUDF1.Enabled then cbTHUDF1.Checked := TimesheetSettings.ShowTHUDF1; // can only select if enabled in Exchequer
    if cbTHUDF2.Enabled then cbTHUDF2.Checked := TimesheetSettings.ShowTHUDF2; // if Exchequer subsequently disables a previously enabled
    if cbTHUDF3.Enabled then cbTHUDF3.Checked := TimesheetSettings.ShowTHUDF3; // UDF, the previous setting will be ignored.
    if cbTHUDF4.Enabled then cbTHUDF4.Checked := TimesheetSettings.ShowTHUDF4;

    cbTLUDF1.Checked := TimesheetSettings.ShowTLUDF1;
    cbTLUDF2.Checked := TimesheetSettings.ShowTLUDF2;

    { CJS 2012-08-29 - ABSEXCH-12450 - ODD support for UDFs 5-10 }
    if cbTHUDF5.Enabled  then cbTHUDF5.Checked  := TimesheetSettings.ShowTHUDF5;
    if cbTHUDF6.Enabled  then cbTHUDF6.Checked  := TimesheetSettings.ShowTHUDF6;
    if cbTHUDF7.Enabled  then cbTHUDF7.Checked  := TimesheetSettings.ShowTHUDF7;
    if cbTHUDF8.Enabled  then cbTHUDF8.Checked  := TimesheetSettings.ShowTHUDF8;
    if cbTHUDF9.Enabled  then cbTHUDF9.Checked  := TimesheetSettings.ShowTHUDF9;
    if cbTHUDF10.Enabled then cbTHUDF10.Checked := TimesheetSettings.ShowTHUDF10;
    cbTLUDF5.Checked  := TimesheetSettings.ShowTLUDF5;
    cbTLUDF6.Checked  := TimesheetSettings.ShowTLUDF6;
    cbTLUDF7.Checked  := TimesheetSettings.ShowTLUDF7;
    cbTLUDF8.Checked  := TimesheetSettings.ShowTLUDF8;
    cbTLUDF9.Checked  := TimesheetSettings.ShowTLUDF9;
    cbTLUDF10.Checked := TimesheetSettings.ShowTLUDF10;

    cbChargeOutRate.Checked := TimesheetSettings.ShowChargeOutRate;
    cbCostPerHour.Checked   := TimesheetSettings.ShowCostPerHour;
    cbCostCentre.Checked    := TimesheetSettings.ShowCostCentre;
    cbDepartment.Checked    := TimesheetSettings.ShowDepartment;
    cbRateCode.Checked      := TimesheetSettings.ShowRateCode;
    cbAnalysisCode.Checked  := TimesheetSettings.ShowAnalysisCode;

    rbShowTotalHours.Checked  := TimesheetSettings.ShowTotalHours;
    rbShowTotalCharge.Checked := TimesheetSettings.ShowTotalCharge;
    rbShowTotalCost.Checked   := TimesheetSettings.ShowTotalCost;
  end
  else begin
    ccbCostCentre.ItemIndex      := -1; // get from employee record in RetrieveEmployeeDefaults
    ccbDepartment.ItemIndex      := -1; // get from employee record in RetrieveEmployeeDefaults
    ccbRateCode.ItemIndex        := 0;
    ccbAnalysisCode.ItemIndex    := 0;
    ccbTimesheetStatus.ItemIndex := 0;
    ccbNoteGen.ItemIndex         := 0;
    edtNoteText.Text             := '';
    ccbCurrency.ItemIndex        := 0;
  end;

  IsClean;
end;

procedure TfrmConfigureTimesheets.SaveSettings;
begin
//  TimesheetSettings.SetCanView(ccbUserProfile.ColumnItems[ccbUserProfile.ItemIndex, 0], ccbEmployeeID.ColumnItems[ccbEmployeeID.ItemIndex, 1], True); // v13 taken out
  TimesheetSettings.AssociatedUserID[ccbUserProfile.ColumnItems[ccbUserProfile.ItemIndex, 0]] := ccbAssociatedUserProfile.ColumnItems[ccbAssociatedUserProfile.ItemIndex, 0];
  TimesheetSettings.IsAdministrator[ccbUserProfile.ColumnItems[ccbUserProfile.ItemIndex, 0]] := cbAdministrator.Checked;

  TimesheetSettings.EmpCode                := ccbEmployeeID.ColumnItems[ccbEmployeeID.ItemIndex, 1];
  TimesheetSettings.DefaultCostCentre      := ccbCostCentre.ColumnItems[ccbCostCentre.ItemIndex, 0];
  TimesheetSettings.DefaultDepartment      := ccbDepartment.ColumnItems[ccbDepartment.ItemIndex, 0];
  TimesheetSettings.DefaultJobCode         := ccbJobCode.ColumnItems[ccbJobCode.ItemIndex, 0];
  TimesheetSettings.DefaultRateCode        := ccbRateCode.ColumnItems[ccbRateCode.ItemIndex, 0];
  TimesheetSettings.DefaultAnalysisCode    := ccbAnalysisCode.ColumnItems[ccbAnalysisCode.ItemIndex, 0];
  TimesheetSettings.DefaultTimesheetStatus := ccbTimesheetStatus.ColumnItems[ccbTimesheetStatus.ItemIndex, 0];
  TimesheetSettings.AutoGenNoteStatus      := ccbNoteGen.ColumnItems[ccbNoteGen.ItemIndex, 0];
  TimesheetSettings.AutoGenNoteText        := edtNoteText.Text;
  TimesheetSettings.DefaultCurrency        := ccbCurrency.ItemIndex;

  TimesheetSettings.ShowTHUDF1             := cbTHUDF1.Checked;
  TimesheetSettings.ShowTHUDF2             := cbTHUDF2.Checked;
  TimesheetSettings.ShowTHUDF3             := cbTHUDF3.Checked;
  TimesheetSettings.ShowTHUDF4             := cbTHUDF4.Checked;

  TimesheetSettings.ShowTLUDF1             := cbTLUDF1.Checked;
  TimesheetSettings.ShowTLUDF2             := cbTLUDF2.Checked;

  { CJS 2012-08-29 - ABSEXCH-12450 - ODD support for UDFs 5-10 }
  TimesheetSettings.ShowTHUDF5             := cbTHUDF5.Checked;
  TimesheetSettings.ShowTHUDF6             := cbTHUDF6.Checked;
  TimesheetSettings.ShowTHUDF7             := cbTHUDF7.Checked;
  TimesheetSettings.ShowTHUDF8             := cbTHUDF8.Checked;
  TimesheetSettings.ShowTHUDF9             := cbTHUDF9.Checked;
  TimesheetSettings.ShowTHUDF10            := cbTHUDF10.Checked;
  TimesheetSettings.ShowTLUDF5             := cbTLUDF5.Checked;
  TimesheetSettings.ShowTLUDF6             := cbTLUDF6.Checked;
  TimesheetSettings.ShowTLUDF7             := cbTLUDF7.Checked;
  TimesheetSettings.ShowTLUDF8             := cbTLUDF8.Checked;
  TimesheetSettings.ShowTLUDF9             := cbTLUDF9.Checked;
  TimesheetSettings.ShowTLUDF10            := cbTLUDF10.Checked;

  TimesheetSettings.ShowChargeOutRate      := cbChargeOutRate.Checked;
  TimesheetSettings.ShowCostPerHour        := cbCostPerHour.Checked;
  TimesheetSettings.ShowCostCentre         := cbCostCentre.Checked;
  TimesheetSettings.ShowDepartment         := cbDepartment.Checked;
  TimesheetSettings.ShowRateCode           := cbRateCode.Checked;
  TimesheetSettings.ShowAnalysisCode       := cbAnalysisCode.Checked;

  TimesheetSettings.ShowTotalHours         := rbShowTotalHours.Checked;
  TimesheetSettings.ShowTotalCharge        := rbShowTotalCharge.Checked;
  TimesheetSettings.ShowTotalCost          := rbShowTotalCost.Checked;

  TimesheetSettings.UpdateFile;
  IsClean;
  HighlightViewableEmployees;
end;

procedure TfrmConfigureTimesheets.MimicLogin;
begin
  lblLoggingIn.Visible := true;
  application.ProcessMessages;
  try
    FUserID := edtUserName.Text;
    FLoggedIn := ValidLogin(ccbCompany.ColumnItems[ccbCompany.ItemIndex, 2], edtUserName.Text, edtPassword.Text);
    if FLoggedIn and TimesheetSettings.IsAdministrator[FUserID] then begin
        EnableDisableEtc(True);
        PopulateCCDeptCurrListsEtc(True, ptAll);
        LoadSettings;
        ccbEmployeeID.SetFocus;
    end
    else begin
      EnableDisableEtc(False);  // not an administrator so disable everything...
      PopulateCCDeptCurrListsEtc(False, ptAll);
      if not FLoggedIn then begin
        ShowMessage('Invalid user name or password');
        FUserID := '';
        edtUsername.SetFocus;
      end
      else begin
        lblEmployeeID.Enabled := true;
        ccbEmployeeID.Enabled := true; // ... except the EmployeeID they choose to display in Outlook
        ccbEmployeeID.SetFocus;
      end;
    end;
  finally
    lblLoggingIn.Visible := false;
  end;
end;

procedure TfrmConfigureTimesheets.EnableDisableEtc(LoggedIn: boolean);
  procedure EnableDisableControls(AWinControl: TWinControl; Enable: boolean);
  var
    i: integer;
  begin
    for i := 0 to AWinControl.ControlCount - 1 do
      AWinControl.Controls[i].Enabled := Enable;
  end;
begin
  EnableDisableControls(gbUserDefs, LoggedIn);
  EnableDisableControls(gbMisc, LoggedIn);
  EnableDisableControls(gbDefaults, LoggedIn);
  EnableDisableControls(gbCompany, LoggedIn);
  EnableDisableControls(gbShowWhat, LoggedIn);
  ccbCompany.Enabled    := true;
  edtUsername.Enabled   := true;
  edtPassword.Enabled   := true;
  lblCompany.Enabled    := true;
  lblUserName.Enabled   := true;
  lblPassword.Enabled   := true;
  btnLogin.Enabled      := true;
  if LoggedIn then
    edtNoteText.Color := clWindow
  else
    edtNoteText.Color := $00FAF1E9;

  ccbCurrency.Enabled := false; // v13 keep disabled until multi-currency is supported
end;

procedure TfrmConfigureTimesheets.IsDirty(AffectsSettingsFile: boolean);
begin
  if AffectsSettingsFile and TimesheetSettings.Locked then begin
    lblLocked.Visible := true;
    EXIT;
  end;

  lblLocked.Visible := false;

  if FLoggedIn and TimesheetSettings.IsAdministrator[FUserID] then begin
    if AffectsSettingsFile and not TimesheetSettings.LockSettingsFile then begin
      ShowMessage('Unable to lock settings file');
      EXIT;
    end;
    FIsDirty               := true;
    btnSave.Enabled        := true;
    btnCloseCancel.Caption := 'Ca&ncel';
  end;
end;

procedure TfrmConfigureTimesheets.IsClean;
begin
  FIsDirty               := false;
  btnSave.Enabled        := false;
  btnCloseCancel.Caption := '&Close';
  TimesheetSettings.UnlockSettingsFile;
end;

procedure TfrmConfigureTimesheets.CullEmployees;
var
  i: integer;
begin
  for i := ccbEmployeeID.ComboItems.Count - 2 downto 0 do
    if not TimesheetSettings.CanView(FUserID, ccbEmployeeID.ColumnItems[i, 1]) then
      ccbEmployeeID.ComboItems.Delete(i);

  if ccbEmployeeID.ComboItems.Count = 0 then
    ShowMessage('This user name cannot view any timesheets. Please contact your administrator.');
end;

procedure TfrmConfigureTimesheets.SetEmployeeID(const Value: string);
begin
  FEmployeeID := Value;
end;

procedure TfrmConfigureTimesheets.HighlightViewableEmployees;
var
  i: integer;
begin
  PopulateCCDeptCurrListsEtc(true, ptEmp);
  EXIT;

  // Bug in TMS component: Setting the ImageIndex only works if you completely repopulate the list.
  // So this has been moved to PopulateCCDeptCurrListsEtc and we don't use the code below until TMS fix the bug.

  for i := 0 to ccbEmployeeID.ComboItems.Count - 1 do
    if TimesheetSettings.CanView(ccbUserProfile.ColumnItems[ccbUserProfile.ItemIndex, 0], ccbEmployeeID.ColumnItems[i, 1]) then
      ccbEmployeeID.ComboItems[i].ImageIndex := 0
    else
      ccbEmployeeID.ComboItems[i].ImageIndex := -1;

  ccbEmployeeID.Repaint;
end;

procedure TfrmConfigureTimesheets.rbShowTotalChargeClick(Sender: TObject);
begin
  rbShowTotalHours.Checked := false;
  rbShowTotalCost.Checked  := false;
  ControlChanged(nil);
end;

procedure TfrmConfigureTimesheets.rbShowTotalCostClick(Sender: TObject);
begin
  rbShowTotalCharge.Checked := false;
  rbShowTotalHours.Checked  := false;
  ControlChanged(nil);
end;

procedure TfrmConfigureTimesheets.rbShowTotalHoursClick(Sender: TObject);
begin
  rbShowTotalCharge.Checked := false;
  rbShowTotalCost.Checked   := false;
  ControlChanged(nil);
end;

procedure TfrmConfigureTimesheets.RebuildRateCodeList;
var
  i: integer;
begin
  ccbRateCode.ComboItems.Clear;                                // v16
  if not TimesheetSettings.IsAdministrator[FUserID] then EXIT; // v16
  with TEmployeeRate.Create do begin
    DataPath := FDataPath;
    FindRates(ccbEmployeeID.ColumnItems[ccbEmployeeID.ItemIndex, 0], ccbJobCode.ColumnItems[ccbJobCode.ItemIndex, 0], ccbRateCode.ColumnItems[ccbRateCode.ItemIndex, 0]);
    ccbRateCode.ComboItems.Clear;
    for i := 0 to RateCodes.Count - 1 do
      with TRateCode(RateCodes[i]) do
        with ccbRateCode.ComboItems.Add do begin
          strings.Add(trim(rcRateCode));
          strings.Add(trim(rcDesc));
          strings.Add(trim(rcAnalysisCode));
        end;

  end;
  if ccbRateCode.ComboItems.Count > 0 then
    lblRateCode.Caption := 'Rate Code'
  else
    lblRateCode.Caption := 'No rates set for this job / employee';
end;

procedure TfrmConfigureTimesheets.ResetUDFs;
begin
  PopulateCCDeptCurrListsEtc(true, ptUDFs);
end;

procedure TfrmConfigureTimesheets.RetrieveEmployeeDefaults;
var
  Toolkit: IToolkit;
  res: integer;
begin
  if (ccbCostCentre.ItemIndex <> -1) and (ccbDepartment.ItemIndex <> -1) then EXIT;
  Toolkit := OpenToolkit(FDataPath, true);
  FDefaultEmpCC := '';
  FDefaultEmpDD := '';
  try
    with Toolkit.JobCosting.Employee as IEmployee4 do begin
      index := emIdxCode;
      res := GetEqual(BuildCodeIndex(ccbEmployeeID.ColumnItems[ccbEmployeeID.ItemIndex, 1]));
      if res = 0 then begin
        FDefaultEmpCC    := trim(emCostCentre);
        FDefaultEmpDD    := trim(emDepartment);
        FEmTimeRateRules := emTimeRateRules;
      end;
    end;
  finally
    Toolkit := nil;
  end;
  if ccbCostCentre.ItemIndex = -1 then ccbCostCentre.ItemIndex := ccbCostCentre.ComboItems.IndexInColumnOf(0, FDefaultEmpCC);
  if ccbDepartment.ItemIndex = -1 then ccbDepartment.ItemIndex := ccbDepartment.ComboItems.IndexInColumnOf(0, FDefaultEmpDD);
end;

initialization
  FDLLHandle := 0;

finalization
  if FDLLHandle <> 0 then begin
    CloseFiles;
    FreeLibrary(FDLLHandle);
  end;
end.
