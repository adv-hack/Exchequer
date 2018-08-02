unit Wizard;

{******************************************************************************}
{    The wizard provides a convenient way for Import Jobs (JOB files) to be    }
{    created and amended.                                                      }
{******************************************************************************}

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ComCtrls, StdCtrls, TCustom, ExtCtrls, Menus, psvDialogs,
  uMultiList, IniFiles, GlobalTypes, BorBtns, TScheduleClass, TPosterClass, uSettings,
  FileUtil;

type

  TWizardSection = (wsAll, wsImportList, wsJobSettings, wsImportSettings, wsMapFiles, wsSchedule);
  TJobType       = (jtNewJob, jtOldJob);

  TfrmWizard = class(TForm)
    PageControl: TPageControl;
    tsImportList: TTabSheet;
    tsJobSettings: TTabSheet;
    tsImportSettings: TTabSheet;
    OpenJobDialog: TpsvOpenDialog;
    BrowseFolderDialog: TpsvBrowseFolderDialog;
    PopupMenu1: TPopupMenu;
    mnuSelectFolder: TMenuItem;
    mnuSelectFiles: TMenuItem;
    SaveJobDialog: TpsvSaveDialog;
    OpenFileDialog: TpsvOpenDialog;
    tsFieldMaps: TTabSheet;
    OpenMapFileDialog: TOpenDialog;
    btnMoveImportListUp: TButton;
    btnMoveImportListDown: TButton;
    tsSchedule: TTabSheet;
    btnPrev: TButton;
    btnNext: TButton;
    btnSave: TButton;
    btnSaveAs: TButton;
    btnClose: TButton;
    btnAdd: TButton;
    btnEditItem: TButton;
    btnRemoveItem: TButton;
    btnRemoveAllItems: TButton;
    btnEditJobSetting: TButton;
    btnEditImportSetting: TButton;
    btnEditMapFile: TButton;
    btnCheckRecordTypes: TButton;
    btnEditMap: TButton;
    mlJobSettings: TMultiList;
    mlImportSettings: TMultiList;
    mlMapFiles: TMultiList;
    mlImportList: TMultiList;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    lblSpecifySchedule: TLabel;
    GroupBox1: TGroupBox;
    lblPage: TLabel;
    GroupBox2: TGroupBox;
    edtEvery: TEdit;
    Label7: TLabel;
    rbEvery: TBorRadio;
    rbEveryBetween: TBorRadio;
    rbOnce: TBorRadio;
    edtEveryBetween: TEdit;
    Label6: TLabel;
    dtpTimeFrom: TDateTimePicker;
    dtpTimeTo: TDateTimePicker;
    Label8: TLabel;
    dtpTimeAt: TDateTimePicker;
    pnlFirstLast: TPanel;
    cbFirst: TBorCheckEx;
    cbSecond: TBorCheckEx;
    cbThird: TBorCheckEx;
    cbFourth: TBorCheckEx;
    cbLast: TBorCheckEx;
    pnlDays: TPanel;
    cbMonday: TBorCheckEx;
    cbTuesday: TBorCheckEx;
    cbWednesday: TBorCheckEx;
    cbThursday: TBorCheckEx;
    cbFriday: TBorCheckEx;
    cbSaturday: TBorCheckEx;
    cbSunday: TBorCheckEx;
    Label9: TLabel;
    lblOfEachMonth: TLabel;
    cbDailyMonthly: TComboBox;
    cbEnabled: TBorCheckEx;
    cbISO8601: TBorCheckEx;
    GroupBox3: TGroupBox;
    lblNextRun: TLabel;
    ImportListPopupMenu: TPopupMenu;
    mniAdd: TMenuItem;
    mniEditItem: TMenuItem;
    mniMoveImportListUp: TMenuItem;
    mniMoveImportListDown: TMenuItem;
    mniRemoveItem: TMenuItem;
    mniRemoveAllItems: TMenuItem;
    JobSettingsPopupMenu: TPopupMenu;
    mniEditJobSetting: TMenuItem;
    ImportSettingsPopupMenu: TPopupMenu;
    mniEditImportSetting: TMenuItem;
    FieldMapsPopupMenu: TPopupMenu;
    mniEditMapFile: TMenuItem;
    EditMap1: TMenuItem;
    mniSelectFiles: TMenuItem;
    mniSelectFolder: TMenuItem;
    N1: TMenuItem;
    mniImportListProperties: TMenuItem;
    mniImportListSaveCoordinates: TMenuItem;
    N2: TMenuItem;
    mniJobSettingsProperties: TMenuItem;
    mniJobSettingsSavecoordinates: TMenuItem;
    N3: TMenuItem;
    mniImportSettingsProperties: TMenuItem;
    mniImportSettingsSavecoordinates: TMenuItem;
    N4: TMenuItem;
    mniFieldMapsProperties: TMenuItem;
    mniMapFilesSavecoordinates: TMenuItem;
    btnJobSettingsDefaults: TButton;
    btnImportSettingsDefaults: TButton;
    btnViewFile: TButton;
    procedure FormCreate(Sender: TObject);
    procedure btnCloseClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure btnPrevClick(Sender: TObject);
    procedure btnNextClick(Sender: TObject);
    procedure btnAddClick(Sender: TObject);
    procedure mnuSelectFilesClick(Sender: TObject);
    procedure mnuSelectFolderClick(Sender: TObject);
    procedure btnSaveClick(Sender: TObject);
    procedure btnSaveAsClick(Sender: TObject);
    procedure btnRemoveItemClick(Sender: TObject);
    procedure btnRemoveAllItemsClick(Sender: TObject);
    procedure btnEditItemClick(Sender: TObject);
    procedure mlImportListChangeSelection(Sender: TObject);
    procedure mlImportListRowDblClick(Sender: TObject; RowIndex: Integer);
    procedure btnEditJobSettingClick(Sender: TObject);
    procedure mlJobSettingsRowDblClick(Sender: TObject; RowIndex: Integer);
    procedure mlImportSettingsRowDblClick(Sender: TObject; RowIndex: Integer);
    procedure mlMapFilesRowDblClick(Sender: TObject; RowIndex: Integer);
    procedure btnEditMapFileClick(Sender: TObject);
    procedure btnMoveMapFileUpClick(Sender: TObject);
    procedure btnMoveMapFileDownClick(Sender: TObject);
    procedure btnMoveImportListUpClick(Sender: TObject);
    procedure btnMoveImportListDownClick(Sender: TObject);
    procedure btnEditMapClick(Sender: TObject);
    procedure mlJobSettingsChangeSelection(Sender: TObject);
    procedure mlImportSettingsChangeSelection(Sender: TObject);
    procedure mlMapFilesChangeSelection(Sender: TObject);
    procedure btnEditImportSettingClick(Sender: TObject);
    procedure btnMoveJobSettingUpClick(Sender: TObject);
    procedure btnMoveJobSettingDownClick(Sender: TObject);
    procedure btnMoveImportSettingUpClick(Sender: TObject);
    procedure btnReloadScheduleClick(Sender: TObject);
    procedure edtFolderKeyPress(Sender: TObject; var Key: Char);
    procedure edtMaskKeyPress(Sender: TObject; var Key: Char);
    procedure edtMapFileKeyPress(Sender: TObject; var Key: Char);
    procedure rbMonthlyClick(Sender: TObject);
    procedure edtEveryKeyPress(Sender: TObject; var Key: Char);
    procedure dtpTimeFromChange(Sender: TObject);
    procedure edtEveryChange(Sender: TObject);
    procedure FormKeyPress(Sender: TObject; var Key: Char);
    procedure cbDailyMonthlyChange(Sender: TObject);
    procedure btnNextRunClick(Sender: TObject);
    procedure FormKeyUp(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure mniImportListPropertiesClick(Sender: TObject);
    procedure mniSaveCoordinatesClick(Sender: TObject);
    procedure mniJobSettingsPropertiesClick(Sender: TObject);
    procedure mniImportSettingsPropertiesClick(Sender: TObject);
    procedure mniFieldMapsPropertiesClick(Sender: TObject);
    procedure btnJobSettingsDefaultsClick(Sender: TObject);
    procedure btnImportSettingsDefaultsClick(Sender: TObject);
    procedure btnViewFileClick(Sender: TObject);
    procedure mniEditImportSettingClick(Sender: TObject);
  protected
    constructor create(AOwner: TComponent); override;
  private
{* internal fields *}
    FDefaultsRestored: boolean;
    FDoubleClicking: boolean;
    FHelping: boolean;
    FImportJobFile: string;
    FIniFile: TMemIniFile;
    FIsDirty: boolean;
    FJobLoaded: boolean;
    FJobType: TJobType;
    FNewSetting: boolean;
    FSaveCoordinates: boolean;
{* property fields *}
    FPoster: TPoster;
{* procedural methods *}
    function  CalcNextRun: TDateTime;
    procedure ChangeCaption;
    procedure ChangePageLabel;
    procedure CheckIfDirty;
    function  CompanyMatches(AFileName: string): boolean;
    function  Daily: boolean;
    procedure DisplaySchedule;
    procedure DoImportJob(SaveLoad: TSaveLoad; JobType: TJobType; WizardSection: TWizardSection);
    procedure DoImportList(SaveLoad: TSaveLoad);
    procedure DoImportSettings(SaveLoad: TSaveLoad; DefaultsOnly: boolean);
    procedure DoJobSettings(SaveLoad: TSaveLoad; DefaultsOnly: boolean);
    procedure DoMapFiles(SaveLoad: TSaveLoad);
    procedure DoSchedule(SaveLoad: TSaveLoad);
    procedure EditItem;
    procedure EditImportSetting;
    procedure EditJobSetting;
    procedure EditMap;
    procedure EditMapFile;
    procedure EnableDisableEtc;
    procedure FormatNextRunLabel;
    procedure HideTabs;
    procedure InitDialogs;
    procedure IsDirty;
    function  Monthly: boolean;
    procedure NewJob;
    procedure NextTabSheet;
    function  OpenJob: boolean;
    procedure PrevTabSheet;
    procedure SaveImportSetting(NewValue: string);
    procedure SaveJobAs;
    procedure SaveJobSetting(NewValue: string);
    procedure SaveMapFile(NewValue: string);
    procedure SaveMask(NewValue: string);
    procedure ScheduleChanged;
    function  ScheduleValid: boolean;
    procedure SelectFiles;
    procedure SelectFolder;
    procedure SetSaveCoordinates(Checked: boolean);
    procedure SetupTabHeadings;
    procedure Shutdown;
    procedure Startup;
{* Getters and Setters *}
    procedure SetPoster(const Value: TPoster);
{* Message Handlers *}
    procedure WMMoving(var msg: TMessage); message WM_MOVING;
  public
    class procedure Show(OpenOldJob: boolean; AJobFile: string; ShowSchedule: boolean; hWND: HWND);
    property Poster: TPoster read FPoster write SetPoster;
  end;

implementation                                                                                    

uses utils, GlobalConsts, TIniClass, MapMaint, DefaultSettings, LoginF, EditBox,
     TJobQueueClass, DateUtils, Confirm, FileViewer, EntLicence, conHTMLHelp;

const
  COL_DEFJOB               = 0;
  COL_SETTING              = 1;
  COL_VALUE                = 2;

  COL_IMPORTLIST_PATH      = 0;
  COL_IMPORTLIST_FILEMASK  = 1;

  COL_MAPFILES_RT          = 1;
  COL_MAPFILES_RECORDTYPE  = 2;
  COL_MAPFILES_MAPFILE     = 3;
  COL_MAPFILES_DESCRIPTION = 4;
  COL_MAPFILES_REQD        = 5; // currently not used

var
  frmWizard: TfrmWizard;

{$R *.dfm}

class procedure TfrmWizard.Show(OpenOldJob: boolean; AJobFile: string; ShowSchedule: boolean; hWND: HWND);
// This class procedure hides the inherited Show method which only consists
// of the last two lines of this procedure anyway.
// This allows other units to call "TfrmWizard.show" and this method takes care
// of creating the single instance.
begin
  if not assigned(frmWizard) then
    frmWizard := TfrmWizard.Create(nil);

  frmWizard.Poster.RegisterWindow(hWND); // whichever window opened the wizard,
                                         // register it to receive wizard's messages.

//  frmWizard.top := 50;      // *** needs to go

  if (AJobFile <> '') and FileExists(AJobFile) then begin // open the supplied job file
    if frmWizard.CompanyMatches(AJobFile) then begin
      frmWizard.FImportJobFile := AJobFile;
      frmWizard.DoImportJob(slLoad, jtOldJob, wsAll);
    end
    else
      exit;
  end
  else
  if OpenOldJob then
    if frmWizard.OpenJob then // continue
    else begin
      frmWizard.Free;           // user cancelled the open file dialog
      frmWizard := nil;
      exit;
    end
  else
    frmWizard.NewJob; // startup as a brand new job file

  frmWizard.WindowState := wsNormal; // was wsMinimized while open dialog showing
  if ShowSchedule then  // are we editing due to the user double-clicking a job in the Scheduler ?
    frmWizard.DisplaySchedule;   // Yes, so go straight to the Schedule tab
// inherited show
  frmWizard.Visible := true;
  frmWizard.BringToFront;
end;

constructor TfrmWizard.create(AOwner: TComponent);
// The inherited constructor has been overridden and this constructor is Protected.
// The consequences of creating more than one instance of the Wizard have not
// been investigated so this discourages it by making the Create method unavailable
// in other units.
// The accepted method of displaying the wizard is to call "TfrmWizard.Show" which
// creates an instance if there isn't already one.
begin
  inherited create(AOwner);

  FPoster := TPoster.Create;

  dtpTimeAt.Format   := 'HH:mm';
  dtpTimeFrom.Format := 'HH:mm';
  dtpTimeTo.Format   := 'HH:mm';

//  SetConstraints(Constraints, height, width);
end;

{* Procedural Methods *}

function TfrmWizard.CalcNextRun: TDateTime;
begin
  JobScheduler.Monthly := Monthly;
  JobScheduler.Daily   := Daily;
  with JobScheduler do begin
    Monday           := cbMonday.Checked;
    Tuesday          := cbTuesday.Checked;
    Wednesday        := cbWednesday.Checked;
    Thursday         := cbThursday.Checked;
    Friday           := cbFriday.Checked;
    Saturday         := cbSaturday.Checked;
    Sunday           := cbSunday.Checked;
    Week1            := cbFirst.Checked;
    Week2            := cbSecond.Checked;
    Week3            := cbThird.Checked;
    Week4            := cbFourth.Checked;
    RunInLastWeek    := cbLast.Checked;
    Every            := rbEvery.Checked;
    EveryMins        := StrToInt(edtEvery.Text);
    EveryBetween     := rbEveryBetween.Checked;
    EveryBetweenMins := StrToInt(edtEveryBetween.Text);
    BetweenFrom      := dtpTimeFrom.Time - Trunc(dtpTimeFrom.Time); // dtp.time includes the date for some reason
    BetweenTo        := dtpTimeTo.Time - Trunc(dtpTimeTo.Time);     // ditto
    OnceAt           := rbOnce.Checked;
    OnceAtTime       := dtpTimeAt.Time - Trunc(dtpTimeAt.Time);     // likewise
    UseISO8601       := cbISO8601.Checked;
    BaseDateTime     := now;
  end;
  result := JobScheduler.NextRun;
end;

procedure TfrmWizard.ChangeCaption;
var
  star: string;
  BuildEdit: string;
begin
  if FIsDirty then star := '*';
  if FJobLoaded then
    BuildEdit := 'Edit'
  else
    BuildEdit := 'Build';
  Caption := format('%s Import Job - [%s]%s', [BuildEdit, ExtractFileName(FImportJobFile), star]);

  if InAdminMode then
    Caption := Caption + '^';
    
  if FIsDirty then
    btnClose.Caption := 'Cancel'
  else
    btnClose.Caption := 'Close';
end;

procedure TfrmWizard.ChangePageLabel;
begin
  lblPage.Caption := format('Page %d of %d', [PageControl.ActivePageIndex + 1, PageControl.PageCount]);
end;

procedure TfrmWizard.CheckIfDirty;
begin
  if (FIsDirty and ScheduleValid) then
    if (MessageDlg('Do you want to save your changes ?', mtConfirmation, [mbYes, mbNo], 0) = mrYes) then
      if FJobLoaded then
        DoImportJob(slSave, jtOldJob, wsAll)
      else
        SaveJobAs;
end;

function TfrmWizard.CompanyMatches(AFileName: string): boolean;
// Prevent the user from opening a job file for a different company other than
// the one they logged-in to, unless they choose to alter the company.
var
  IniF: TMemIniFile;
  JobCompany: string;
  frmConfirm: TfrmConfirm;
  rc: integer;
begin
  IniFile.DecryptIniFile(AFileName, false);
  IniF := TMemIniFile.Create(AFileName);
  if not PlainOut then
    IniFile.EncryptIniFile(AFileName);
  try
    JobCompany := IniF.ReadString(IMPORT_SETTINGS, 'Exchequer Company', '');
    result := (JobCompany = LoginCompany) or (Jobcompany = '');
    if not result then begin
      frmConfirm := TfrmConfirm.Create(nil);
      try
        frmConfirm.JobFile        := AFileName;
        frmConfirm.JobCompany     := JobCompany;
        frmConfirm.LoginCompany   := LoginCompany;
        frmConfirm.OptionsCaption := 'You can either:- '#13#10
            + '1. Change the company for this job,'#13#10
            + '2. Login again to edit the job in its correct company, or'#13#10
            + '3. Cancel the editing of this job.';
        rc := frmConfirm.ShowModal;
        if rc = mrIgnore then begin // ignore the difference and change the job to match the login
          WriteIniLogonInfo(IniF);
          result := true;
        end
        else
          if rc = mrRetry  then begin // re-login
            TfrmLogin.Show;
            result := LoginOk and (LoginCompany = JobCompany); // did they re-login to the correct company !?
          end;
      finally
        frmConfirm.Free;
      end;
    end;
  finally
    IniFile.DecryptIniFile(AFileName, false);
    IniF.UpdateFile;
    IniF.Free;
    if not PlainOut then
      IniFile.EncryptIniFile(AFileName);
  end;
end;

function TfrmWizard.Daily: boolean;
begin
  result := cbDailyMonthly.ItemIndex = 0;
end;

procedure TfrmWizard.DisplaySchedule;
begin
  while PageControl.ActivePage <> tsSchedule do
    NextTabSheet;
end;

procedure TfrmWizard.DoImportJob(SaveLoad: TSaveLoad; JobType: TJobType; WizardSection: TWizardSection);
// Either:-
// 1. Load all the job settings from the SAV file and Importer's main
// settings file and populate each page of the wizard.
// or 2. Save from each page of the wizard to the SAV file.
begin
  FJobType := JobType;

  if FJobType = jtOldJob then begin  // for saves, FJobType is always jtOldJob at this point
    if FileExists(FImportJobFile) then // for SaveAs, new file won't exist yet
      IniFile.DecryptIniFile(FImportJobFile, false);
    FIniFile := TMemIniFile.Create(FImportJobFile); // needed if we're reading from an existing job file
  end;

  FNewSetting := false;

  try
    if (WizardSection = wsAll) or (WizardSection = wsImportList) then
      DoImportList(SaveLoad);
    if (WizardSection = wsAll) or (WizardSection = wsJobSettings) then
      DoJobSettings(SaveLoad, false);
    if (WizardSection = wsAll) or (WizardSection = wsImportSettings) then
      DoImportSettings(SaveLoad, false);
    if (WizardSection = wsAll) or (WizardSection = wsMapFiles) then
      DoMapFiles(SaveLoad);
    if (WizardSection = wsAll) or (WizardSection = wsSchedule) then
      DoSchedule(SaveLoad);
  finally
    if FJobType = jtOldJob then begin
      WriteIniLogonInfo(FIniFile); // update the company login info in the job file
      FIniFile.UpdateFile;
      FIniFile.Free;
      FIniFile := nil;
      if not PlainOut then
        IniFile.EncryptIniFile(FImportJobFile);
    end;
  end;

  if (WizardSection = wsAll) and not FNewSetting then
    FIsDirty   := false; // all clean and fresh again
  if (FJobType = jtOldJob) or (SaveLoad = slSave) then begin
    FJobLoaded := true;
    FPoster.PostMsg(WM_REFRESHJOBFILES, 0, 0); // tell any interested windows that a job's just been amended
  end
  else
    FJobLoaded := false;

  EnableDisableEtc;

  ChangeCaption;
end;

procedure TfrmWizard.DoImportList(SaveLoad: TSaveLoad);
// Save/Load the list of Import items which can be a combination of specific
// files or folders with file masks.
// If we're loading a new job then we just clear the multilist.
var
  i: integer;
  SectionValues: TStringList;
begin
  case SaveLoad of
    slSave: begin
              FIniFile.EraseSection(IMPORT_LIST); // save the whole list to a new version of the ImportList section
              for i := 0 to mlImportList.ItemsCount - 1 do
                FIniFile.WriteString(IMPORT_LIST, IntToStr(i),
                IncludeTrailingPathDelimiter(mlImportList.DesignColumns[COL_IMPORTLIST_PATH].Items[i])
                + mlImportList.DesignColumns[COL_IMPORTLIST_FILEMASK].Items[i]);
            end;
    slLoad: begin
              mlImportList.ClearItems;
              if FJobType = jtOldJob then begin
                SectionValues := TStringList.create;
                try
                  FIniFile.ReadSectionValues(IMPORT_LIST, SectionValues);
                  for i := 0 to SectionValues.Count - 1 do begin // load the entire list
                    mlImportList.DesignColumns[COL_IMPORTLIST_PATH].Items.Add(ExtractFilePath(SectionValues.Values[IntToStr(i)]));
                    mlImportList.DesignColumns[COL_IMPORTLIST_FILEMASK].Items.Add(ExtractFileName(SectionValues.Values[IntToStr(i)]));
                  end;
                  MLSelectFirst(mlImportList);
                finally
                  SectionValues.free;
                end;
              end;
            end;
  end;
end;

procedure TfrmWizard.DoImportSettings(SaveLoad: TSaveLoad; DefaultsOnly: boolean);
// Save: save any setting where column zero is JOB meaning its overridden the
// usual DEF setting.
// 17/11/2005: Amended to now write all settings to the JOB file. This has the
// effect of copying all default settings to a new job file so that a change
// to a default setting doesn't unexpectedly alter an existing job.
// Load: read the default settings from Importer's settings file (IniFile).
// read the override job settings from the SAV file (FIniFile).
// Display all the job settings and any default settings that haven't been
// overridden.
var
  DefSettings: TStringList;
  ImportSettings: TStringList;
  i: integer;
begin
  case SaveLoad of
    slSave: begin
              FIniFile.EraseSection(IMPORT_SETTINGS);
              for i := 0 to mlImportSettings.ItemsCount - 1 do
//                if mlImportSettings.DesignColumns[COL_DEFJOB].Items[i] = 'JOB' then // only save settings that differ from the defaults
                  FIniFile.WriteString(IMPORT_SETTINGS, mlImportSettings.DesignColumns[COL_SETTING].Items[i], mlImportSettings.DesignColumns[COL_VALUE].Items[i]);
            end;
    slLoad: begin
              mlImportSettings.ClearItems;
              DefSettings := TStringList.create;
              ImportSettings := TStringList.create;
              try
                IniFile.ReturnValuesInList(IMPORT_SETTINGS, DefSettings);
                if not DefaultsOnly then begin
                  if FJobType = jtOldJob then
                    FIniFile.ReadSectionValues(IMPORT_SETTINGS, ImportSettings);
                  for i := 0 to ImportSettings.Count - 1 do
                    if not SettingTF(IniFile.ReadString(ImportSettings.Names[i], 'Hidden', 'No')) or InAdminMode then begin // won't display the UserName and Password entries etc.
                      mlImportSettings.DesignColumns[COL_DEFJOB].items.add('JOB');  // remember where we got the setting from
                      mlImportSettings.DesignColumns[COL_SETTING].Items.add(ImportSettings.Names[i]);
                      mlImportSettings.DesignColumns[COL_VALUE].Items.add(ImportSettings.Values[ImportSettings.Names[i]]);
                    end;
                end;
                for i := 0 to DefSettings.Count - 1 do
                  if DefaultsOnly or (FJobType = jtNewJob) or (not FIniFile.ValueExists(IMPORT_SETTINGS, DefSettings.Names[i])) then begin // it hasn't been overridden
                    mlImportSettings.DesignColumns[COL_DEFJOB].items.add('DEF'); // remember where we got the setting from
                    mlImportSettings.DesignColumns[COL_SETTING].Items.add(DefSettings.Names[i]);
                    mlImportSettings.DesignColumns[COL_VALUE].Items.add(DefSettings.Values[DefSettings.Names[i]]);
                    if (FJobType <> jtNewJob) then // must be new setting
                      FNewSetting := true; // after picking up new settings, let them save them.
                  end;
                MLSelectFirst(mlImportSettings);
                mlImportSettings.SortColumn(1, true);
              finally
                DefSettings.free;
                ImportSettings.free;
              end;
            end;
  end;
end;

procedure TfrmWizard.DoJobSettings(SaveLoad: TSaveLoad; DefaultsOnly: boolean);
// Save: save any setting where column zero is JOB meaning its overridden the
// usual DEF setting.
// 17/11/2005: Amended to now write all settings to the JOB file. This has the
// effect of copying all default settings to a new job file so that a change
// to a default setting doesn't unexpectedly alter an existing job.
// Load: read the default settings from Importer's settings file (IniFile).
// read the override job settings from the SAV file (FIniFile).
// Display all the job settings and any default settings that haven't been
// overridden.
// If its a new job we just load up the default values
var
  DefSettings: TStringList;
  JobSettings: TStringList;
  i: integer;
begin
  case SaveLoad of
    slSave: begin
              FIniFile.EraseSection(JOB_SETTINGS);
              for i := 0 to mlJobSettings.ItemsCount - 1 do
//                if mlJobSettings.DesignColumns[COL_DEFJOB].Items[i] = 'JOB' then
                  FIniFile.WriteString(JOB_SETTINGS, mlJobSettings.DesignColumns[COL_SETTING].Items[i], mlJobSettings.DesignColumns[COL_VALUE].Items[i]);
            end;
    slLoad: begin
              mlJobSettings.ClearItems;
              DefSettings := TStringList.create;
              JobSettings := TStringList.create;
              try
                IniFile.ReturnValuesInList(JOB_SETTINGS, DefSettings);
                if not DefaultsOnly then begin
                  if FJobType = jtOldJob then
                    FIniFile.ReadSectionValues(JOB_SETTINGS, JobSettings);
                  for i := 0 to JobSettings.Count - 1 do begin
                    mlJobSettings.DesignColumns[COL_DEFJOB].items.add('JOB'); // remember where we got the setting from
                    mlJobSettings.DesignColumns[COL_SETTING].Items.add(JobSettings.Names[i]);
                    mlJobSettings.DesignColumns[COL_VALUE].Items.add(JobSettings.Values[JobSettings.Names[i]]);
                  end;
                end;
                for i := 0 to DefSettings.Count - 1 do
                  if DefaultsOnly or (FJobType = jtNewJob) or (not FIniFile.ValueExists(JOB_SETTINGS, DefSettings.Names[i])) then begin // it hasn't been overridden
                    mlJobSettings.DesignColumns[COL_DEFJOB].items.add('DEF'); // remember where we got the setting from
                    mlJobSettings.DesignColumns[COL_SETTING].Items.add(DefSettings.Names[i]);
                    mlJobSettings.DesignColumns[COL_VALUE].Items.add(DefSettings.Values[DefSettings.Names[i]]);
                    if (FJobType <> jtNewJob) then // must be new setting
                      FNewSetting := true; // after picking up new settings, let them save them.
                  end;
                MLSelectFirst(mlJobSettings);
                mlJobSettings.SortColumn(1, true);
              finally
                DefSettings.free;
                JobSettings.free;
              end;
            end;
  end;
end;

procedure TfrmWizard.DoMapFiles(SaveLoad: TSaveLoad);
// Save: save any setting where column zero is JOB meaning its overridden the
// default setting.
// 17/11/2005: Amended to now write all settings to the JOB file. This has the
// effect of copying all default settings to a new job file so that a change
// to a default setting doesn't unexpectedly alter an existing job.
// Load: read the default settings from Importer's settings file (IniFile).
// read the override job settings from the SAV file (FIniFile).
// Display all the job settings and any default settings that haven't been
// overridden.
var
  i: integer;
  DefValues: TStringList;
  JobValues: TStringList;
  RecordTypes: TStringList;
begin
  case SaveLoad of
    slSave: begin
              FIniFile.EraseSection(FIELD_MAPS);
              for i := 0 to mlMapFiles.ItemsCount - 1 do
//                if mlMapFiles.DesignColumns[COL_DEFJOB].Items[i] = 'JOB' then
                  FIniFile.WriteString(FIELD_MAPS, mlMapFiles.DesignColumns[COL_MAPFILES_RT].Items[i],
                                               mlMapFiles.DesignColumns[COL_MAPFILES_MAPFILE].Items[i]);
            end;
    slLoad: begin
              mlMapFiles.ClearItems;
              JobValues := TStringList.create;
              DefValues := TStringList.create;
              try
                IniFile.ReturnValuesInList(FIELD_MAPS, DefValues); // pick up the defaults from the main settings file
                DefValues.Sorted := true;
                if EnterpriseLicence.IsLITE then
                  for i := DefValues.Count - 1 downto 0 do begin
                    if IniFile.ReadString(IAO_RECS, DefValues.Names[i], 'No') = 'No' then // remove  non-IAO record types
                      DefValues.Delete(i);
                  end;
                if FJobType = jtOldJob then begin                  // if there's an existing job file read it in
                  FIniFile.ReadSectionValues(FIELD_MAPS, JobValues);
                  JobValues.Sorted := true;
                  if EnterpriseLicence.IsLITE then
                    for i := JobValues.Count - 1 downto 0 do begin
                      if IniFile.ReadString(IAO_RECS, JobValues.Names[i], 'No') = 'No' then // remove  non-IAO record types
                        JobValues.Delete(i);
                    end;
                end;
                for i := 0 to JobValues.Count - 1 do begin // load all the job settings
                  mlMapFiles.DesignColumns[COL_DEFJOB].Items.Add('JOB'); // remember where the setting came from
                  mlMapFiles.DesignColumns[COL_MAPFILES_RT].Items.Add(JobValues.Names[i]);  // 2-char record type
                  mlMapFiles.DesignColumns[COL_MAPFILES_RECORDTYPE].Items.Add(IniFile.ReturnValue(RECORD_TYPES, JobValues.Names[i])); // full record type name from main settings file
                  mlMapFiles.DesignColumns[COL_MAPFILES_DESCRIPTION].Items.Add(IniFile.CurrentSectionValueComment); // populated by the call to ReturnValue
                  mlMapFiles.DesignColumns[COL_MAPFILES_MAPFILE].Items.Add(JobValues.Values[JobValues.Names[i]]);
                  mlMapFiles.DesignColumns[COL_MAPFILES_REQD].Items.Add(' ');
                end;
                for i := 0 to DefValues.Count - 1 do // load DEF settings if they haven't been overridden
                  if (FJobType = jtNewJob) or (not FIniFile.ValueExists(FIELD_MAPS, DefValues.Names[i])) then begin
                    mlMapFiles.DesignColumns[COL_DEFJOB].Items.Add('DEF'); // remember where the setting came from
                    mlMapFiles.DesignColumns[COL_MAPFILES_RT].Items.Add(DefValues.Names[i]); // 2-char record type
                    mlMapFiles.DesignColumns[COL_MAPFILES_RECORDTYPE].Items.Add(IniFile.ReturnValue(RECORD_TYPES, DefValues.Names[i])); // full record type name from main settings file
                    mlMapFiles.DesignColumns[COL_MAPFILES_DESCRIPTION].Items.Add(IniFile.CurrentSectionValueComment); // populated by the call to ReturnValue
                    mlMapFiles.DesignColumns[COL_MAPFILES_MAPFILE].Items.Add(DefValues.Values[DefValues.Names[i]]);
                    mlMapFiles.DesignColumns[COL_MAPFILES_REQD].Items.Add(' ');
                    if (FJobType <> jtNewJob) then // must be new setting
                      FNewSetting := true; // after picking up new settings, let them save them.
                  end;
                if mlMapFiles.DesignColumns[COL_MAPFILES_RECORDTYPE].Items.Count > 0 then
                  MLSortColumn(mlMapFiles, COL_MAPFILES_RECORDTYPE, true);
                MLSelectFirst(mlMapFiles);
              finally
                JobValues.free;
                DefValues.free;
              end;
            end;
  end;
end;

procedure TfrmWizard.DoSchedule(SaveLoad: TSaveLoad);
// Save/Load the list of Schedule items
begin
  case SaveLoad of
    slSave: begin
              FIniFile.WriteString(SCHEDULE, 'Monthly',   IntToStr(ord(Monthly)));
              FIniFile.WriteString(SCHEDULE, 'Daily',     IntToStr(ord(Daily)));
              FIniFile.WriteString(SCHEDULE, 'Monday',    IntToStr(ord(cbMonday.Checked)));
              FIniFile.WriteString(SCHEDULE, 'Tuesday',   IntToStr(ord(cbTuesday.Checked)));
              FIniFile.WriteString(SCHEDULE, 'Wednesday', IntToStr(ord(cbWednesday.Checked)));
              FIniFile.WriteString(SCHEDULE, 'Thursday',  IntToStr(ord(cbThursday.Checked)));
              FIniFile.WriteString(SCHEDULE, 'Friday',    IntToStr(ord(cbFriday.Checked)));
              FIniFile.WriteString(SCHEDULE, 'Saturday',  IntToStr(ord(cbSaturday.Checked)));
              FIniFile.WriteString(SCHEDULE, 'Sunday',    IntToStr(ord(cbSunday.Checked)));
              FIniFile.WriteString(SCHEDULE, 'Week1',     IntToStr(ord(cbFirst.Checked)));
              FIniFile.WriteString(SCHEDULE, 'Week2',     IntToStr(ord(cbSecond.Checked)));
              FIniFile.WriteString(SCHEDULE, 'Week3',     IntToStr(ord(cbThird.Checked)));
              FIniFile.WriteString(SCHEDULE, 'Week4',     IntToStr(ord(cbFourth.Checked)));
              FIniFile.WriteString(SCHEDULE, 'Weekx',     IntToStr(ord(cbLast.Checked)));
              FIniFile.WriteString(SCHEDULE, 'Enabled',   IntToStr(ord(cbEnabled.Checked)));
              FIniFile.WriteString(SCHEDULE, 'Every',     IntToStr(ord(rbEvery.Checked)));
              FIniFile.WriteString(SCHEDULE, 'EveryMins', edtEvery.Text);
              FIniFile.WriteString(SCHEDULE, 'EveryBetween', IntToStr(ord(rbEveryBetween.Checked)));
              FIniFile.WriteString(SCHEDULE, 'EveryBetweenMins', edtEveryBetween.Text);
              FIniFile.WriteString(SCHEDULE, 'BetweenFrom', FormatDateTime('hh:nn', dtpTimeFrom.Time));
              FIniFile.WriteString(SCHEDULE, 'BetweenTo', FormatDateTime('hh:nn', dtpTimeTo.Time));
              FIniFile.WriteString(SCHEDULE, 'OnceAt',    IntToStr(ord(rbOnce.Checked)));
              FIniFile.WriteString(SCHEDULE, 'OnceAtTime', FormatDateTime('hh:nn', dtpTimeAt.Time));
              FIniFile.WriteString(SCHEDULE, 'Enabled', IntToStr(ord(cbEnabled.Checked)));
              FIniFile.WriteString(SCHEDULE, 'ISO8601', IntToStr(Ord(cbISO8601.Checked)));
            end;
    slLoad: begin
              if FJobType = jtOldJob then begin
                cbDailyMonthly.ItemIndex   :=  ord(not (FIniFile.ReadString(SCHEDULE, 'Daily', '0') = '1')); // equates to 0 if Daily
                cbDailyMonthly.ItemIndex   :=  ord(FIniFile.ReadString(SCHEDULE, 'Monthly', '0') = '1');     // equates to 1 if Monthly
                cbMonday.Checked       :=  SettingTF(FIniFile.ReadString(SCHEDULE, 'Monday', '0'));
                cbTuesday.Checked      :=  SettingTF(FIniFile.ReadString(SCHEDULE, 'Tuesday', '0'));
                cbWednesday.Checked    :=  SettingTF(FIniFile.ReadString(SCHEDULE, 'Wednesday', '0'));
                cbThursday.Checked     :=  SettingTF(FIniFile.ReadString(SCHEDULE, 'Thursday', '0'));
                cbFriday.Checked       :=  SettingTF(FIniFile.ReadString(SCHEDULE, 'Friday', '0'));
                cbSaturday.Checked     :=  SettingTF(FIniFile.ReadString(SCHEDULE, 'Saturday', '0'));
                cbSunday.Checked       :=  SettingTF(FIniFile.ReadString(SCHEDULE, 'Sunday', '0'));
                cbFirst.Checked        :=  SettingTF(FIniFile.ReadString(SCHEDULE, 'Week1', '0'));
                cbSecond.Checked       :=  SettingTF(FIniFile.ReadString(SCHEDULE, 'Week2', '0'));
                cbThird.Checked        :=  SettingTF(FIniFile.ReadString(SCHEDULE, 'Week3', '0'));
                cbFourth.Checked       :=  SettingTF(FIniFile.ReadString(SCHEDULE, 'Week4', '0'));
                cbLast.Checked         :=  SettingTF(FIniFile.ReadString(SCHEDULE, 'Weekx', '0'));
                cbEnabled.Checked      :=  SettingTF(FIniFile.ReadString(SCHEDULE, 'Enabled', '0'));
                rbEvery.Checked        :=  SettingTF(FIniFile.ReadString(SCHEDULE, 'Every', '0'));
                if rbEvery.Checked then
                  edtEvery.Text        :=  FIniFile.ReadString(SCHEDULE, 'EveryMins', '');
                rbEveryBetween.Checked := SettingTF(FIniFile.ReadString(SCHEDULE, 'EveryBetween', '0'));
                if rbEveryBetween.Checked then begin
                  edtEveryBetween.Text := FIniFile.ReadString(SCHEDULE, 'EveryBetweenMins', '');
                  dtpTimeFrom.Time     := StrToDateTime(FIniFile.ReadString(SCHEDULE, 'BetweenFrom', ''));
                  dtpTimeTo.Time       := StrToDateTime(FIniFile.ReadString(SCHEDULE, 'BetweenTo', ''));
                end;
                rbOnce.Checked         := SettingTF(FIniFile.ReadString(SCHEDULE, 'OnceAt', '0'));
                if rbOnce.Checked then
                  dtpTimeAt.Time       := StrToDateTime(FIniFile.ReadString(SCHEDULE, 'OnceAtTime', ''));
                cbEnabled.Checked      := SettingTF(FIniFile.ReadString(SCHEDULE, 'Enabled', '0'));
                cbISO8601.Checked      := SettingTF(FIniFile.ReadString(SCHEDULE, 'ISO8601', '0'));
              end;
            end;
  end;
end;

procedure TfrmWizard.EditImportSetting;
// Importer's main settings file specifies what type of value the setting can be
// set to, e.g. fixed list, file name, folder name, free text.
// EditBox.show reacts to the type of setting and displays either a drop down
// list or an edit box as appropriate. It also enables the Select button to
// allow the user to browse for a file or folder.
// If a setting has a fixed set of possible values, these will have been defined in the main
// Importer settings file in a section named the same as the setting.
// If EditBox finds there is such a section, the drop down list is populated with the
// possible values and the ItemIndex is set to the current value.
// Otherwise, the setting is a free-format value and the edit box is displayed.
var
  NewValue: string;
begin
  if mlImportSettings.Selected = -1 then exit;

  if TfrmEditBox.Show(IMPORT_SETTINGS,                                              {Ini Section}
                      mlImportSettings.DesignColumns[COL_SETTING].items[mlImportSettings.selected], {Setting Name}
                      ' ',                                                                     {Data Type}
                      0,                                                                      {max length}
                      '',                                                                     {DataType Caption}
                      '',                                                                           {Caption}
                      '',                                                                        {msg/prompt/hint}
                      mlImportSettings.DesignColumns[COL_VALUE].Items[mlImportSettings.selected],   {Current Value}
                      OpenFileDialog, BrowseFolderDialog, nil, true,
                      NewValue) then
    SaveImportSetting(NewValue);
end;

procedure TfrmWizard.EditItem;
// Edit the selected Import Item
var
  NewValue: string;
begin
  if mlImportList.Selected = -1 then exit;

  if TfrmEditBox.Show(IMPORT_LIST,                                                              {Ini Section}
                      mlImportList.DesignColumns[COL_SETTING].items[mlImportList.selected], {Setting Name}
                      'M',                                                         {TSettingType}
                      0,                                                                      {max length}
                      '',                                                                     {DataType Caption}
                      'Import File or Folder',                                                      {Caption}
                      '',                                                                        {msg/prompt/hint}
                      mlImportList.DesignColumns[COL_IMPORTLIST_PATH].items[mlImportList.selected]
                       + mlImportList.DesignColumns[COL_IMPORTLIST_FILEMASK].Items[mlImportList.selected], {Current Value}
                      OpenFileDialog, BrowseFolderDialog, nil, true,
                      NewValue) then
    SaveMask(NewValue);
end;

procedure TfrmWizard.EditJobSetting;
// Importer's main settings file specifies what type of value the setting can be
// set to, e.g. fixed list, file name, folder name, free text.
// This procedure reacts to the type of setting and displays either a drop down
// list or an edit box as appropriate. It also enables the Select button to
// allow the user to browse for a file or folder.
// If a setting has a fixed set of possible values, these will have been defined in the main
// Importer settings file in a section named the same as the setting.
// If this procedure finds there is such a section, the drop down list is populated with the
// possible values and the ItemIndex is set to the current value.
// Otherwise, the setting is a free-format value and the edit box is displayed.
var
  NewValue: string;
begin
  if mlJobSettings.Selected = -1 then exit;

  if TfrmEditBox.Show(JOB_SETTINGS,                                                           {Ini Section}
                      mlJobSettings.DesignColumns[COL_SETTING].items[mlJobSettings.selected], {Setting Name}
                      ' ',                                                              {Data Type}
                      0,                                                                      {max length}
                      '',                                                                     {DataType Caption}
                      '',                                                                     {Caption}
                      '',                                                                     {msg/prompt/hint}
                      mlJobSettings.DesignColumns[COL_VALUE].Items[mlJobSettings.selected],   {Current Value}
                      OpenFileDialog, BrowseFolderDialog, nil, true,
                      NewValue) then
    SaveJobSetting(NewValue);
end;

procedure TfrmWizard.EditMap;
var
  RT: string;
  MapFile: string;
begin
  if mlMapFiles.Selected <> -1 then begin
    RT      := mlMapFiles.DesignColumns[COL_MAPFILES_RT].Items[mlMapFiles.Selected];
    MapFile := mlMapFiles.DesignColumns[COL_MAPFILES_MAPFILE].Items[mlMapFiles.Selected];
  end;
  TfrmMapMaint.Show(RT, MapFile, false);
end;

procedure TfrmWizard.EditMapFile;
var
  NewValue: string;
begin
  if mlMapFiles.Selected = -1 then exit;

//  if TfrmEditBox.Show(FIELD_MAPS,
//                      mlMapFiles.DesignColumns[COL_MAPFILES_RECORDTYPE].Items[mlMapFiles.Selected],
  if TfrmEditBox.Show('',                                                                     {IniSection}
                      '',                                                                     {Setting Name}
                      'F',                                                                    {Data Type}
                      0,                                                                      {max length}
                      '',                                                                     {DataType Caption}
                      'Map file for Record Type ' + mlMapFiles.DesignColumns[COL_MAPFILES_RT].Items[mlMapFiles.Selected],
                      '',                                                               {msg/prompt/hint}
                      mlMapFiles.DesignColumns[COL_MAPFILES_MAPFILE].Items[mlMapFiles.Selected],
                      OpenMapFileDialog, BrowseFolderDialog, nil, true,
                      newValue) then
    SaveMapFile(NewValue);
end;

procedure TfrmWizard.EnableDisableEtc;
// change what's enabled/disabled depending on which tabsheet is being viewed.
begin
  btnSave.Enabled     := FIsDirty and FJobLoaded and ScheduleValid;
  btnSaveAs.Enabled   := FIsDirty and ScheduleValid;

  HelpContext := 6 + PageControl.ActivePageIndex;

  if PageControl.ActivePage = tsImportList then begin
    btnEditItem.Enabled           := mlImportList.ItemsCount <> 0;
    btnRemoveItem.Enabled         := mlImportList.ItemsCount <> 0;
    btnRemoveAllItems.Enabled     := mlImportList.ItemsCount <> 0;
    btnMoveImportListUp.Enabled   := mlImportList.ItemsCount <> 0;
    btnMoveImportListDown.Enabled := mlImportList.ItemsCount <> 0;
    btnViewFile.Enabled           := (mlImportList.ItemsCount <> 0) and (mlImportList.Selected <> -1) and (pos('*', mlImportList.DesignColumns[COL_IMPORTLIST_FILEMASK].Items[mlImportList.Selected]) = 0);

    mniEditItem.Enabled           := btnEditItem.Enabled; // ImportListPopupMenu
    mniRemoveItem.Enabled         := btnRemoveItem.Enabled;
    mniRemoveAllItems.Enabled     := btnRemoveAllItems.Enabled;
    mniMoveImportListUp.Enabled   := btnMoveImportListUp.Enabled;
    mniMoveImportListDown.Enabled := btnMoveImportListDown.Enabled;
  end
  else
  if PageControl.ActivePage = tsJobSettings then begin // JobSettingsPopupMenu
    btnEditJobSetting.Enabled       := mlJobSettings.ItemsCount <> 0;
    mniEditJobSetting.Enabled       := btnEditJobSetting.Enabled;
  end
  else
  if PageControl.ActivePage = tsImportSettings then begin // ImportSettingsPopupMenu
    btnEditImportSetting.Enabled       := mlImportSettings.ItemsCount <> 0;
    mniEditImportSetting.Enabled       := btnEditImportSetting.Enabled;
  end
  else
  if PageControl.ActivePage = tsFieldMaps then begin  // FieldMapsPopupMenu
     btnCheckRecordTypes.Enabled  := mlImportList.ItemsCount <> 0;
     btnEditMapFile.Enabled       := mlMapFiles.ItemsCount <> 0;
     mniEditMapFile.Enabled       := btnEditmapFile.Enabled;
  end
  else
  if PageControl.ActivePage = tsSchedule then begin
    pnlFirstLast.Visible       := Monthly;
    lblOfEachMonth.Visible     := Monthly;
    edtEvery.Enabled           := rbEvery.Checked;
    edtEveryBetween.Enabled    := rbEveryBetween.Checked;
    dtpTimeFrom.Enabled        := rbEveryBetween.Checked;
    dtpTimeTo.Enabled          := rbEveryBetween.Checked;
    dtpTimeAt.Enabled          := rbOnce.Checked;
    GroupBox1.Visible          := cbEnabled.Checked;
    GroupBox2.Visible          := cbEnabled.Checked;
    GroupBox3.Visible          := cbEnabled.Checked;
    if cbEnabled.Checked then begin
      lblSpecifySchedule.Caption := 'Please specify when this import job should run';
      FormatNextRunLabel;
    end
    else
      lblSpecifySchedule.Caption := 'This job is not enabled and will not be run by the Scheduler';
  end;

  btnPrev.Enabled := PageControl.ActivePageIndex <> 0;
  btnNext.Enabled := (PageControl.ActivePageIndex <> PageControl.PageCount - 1)
                  and (mlImportList.ItemsCount <> 0);
end;

procedure TfrmWizard.FormatNextRunLabel;
var
  s: string;
begin
  s := '';
  if ScheduleValid then begin
    s := 'It is ' + FormatDateTime('dddd', date) + ' ' + DateToStr(date) +
                            ' at ' + FormatDateTime('HH:mm', time) + #13#10#13#10;
    s := s + 'With the current settings,'#13#10'this job will be next run'#13#10#13#10;
    s := s + FormatRunDateTime(CalcNextRun);
  end;

  lblNextRun.Caption := s;
end;

procedure TfrmWizard.HideTabs;
// hide the tabs of all the TabSheets and set the first page active
var
  i: integer;
begin
  for i := 0 to PageControl.PageCount - 1 do
    PageControl.Pages[i].TabVisible := false; // actually, they should already be hidden

  PageControl.Pages[0].TabVisible := true;
  PageControl.ActivePage := PageControl.Pages[0];

  ChangePageLabel;
end;

procedure TfrmWizard.InitDialogs;
// set up filters, initial directories etc of the various OpenDialog and BrowseForFolder dialogs
var
  DefaultImportExt:    string;
  DefaultImportFolder: string;
  DefaultJobExt:       string;
  DefaultJobFolder:    string;
  DefaultMapFolder:    string;
  DefaultMapExt:       string;
  DefaultUserDefExt:   string;
begin
  DefaultJobExt                := IniFile.ReadString(SYSTEM_SETTINGS, 'Job Ext', 'SAV');
  OpenJobDialog.DefaultExt     := DefaultJobExt;
  SaveJobDialog.DefaultExt     := DefaultJobExt;
  DefaultJobFolder             := IncludeTrailingPathDelimiter(IniFile.ReadString(SYSTEM_SETTINGS, 'Job Folder', ''));
  OpenJobDialog.InitialDir     := DefaultJobFolder;
  SaveJobDialog.InitialDir     := DefaultJobFolder;
  OpenJobDialog.Options        := OpenJobDialog.Options + [ofFileMustExist];
  OpenJobDialog.Filter         := format('Saved Import Jobs (*.%s)|*.%0:s|All Files (*.*)|*.*', [DefaultJobExt]);
  SaveJobDialog.Filter         := OpenJobDialog.Filter;
  OpenFileDialog.Options       := OpenFileDialog.Options + [ofAllowMultiSelect];
  DefaultImportFolder          := IncludeTrailingPathDelimiter(IniFile.ReadString(SYSTEM_SETTINGS, 'Import Folder', ''));
  DefaultUserDefExt            := IniFile.ReadString(SYSTEM_SETTINGS, 'UserDef Ext', 'CSV');
//  DefaultImportExt             := IniFile.ReadString(SYSTEM_SETTINGS, 'Std Import Ext', 'IMP'); // v.086 no more IMP files

  if pos('*', DefaultUserDefExt) > 0 then
    OpenFileDialog.Filter      := DefaultUserDefExt // power-users can specify their own filter
  else
    OpenFileDialog.Filter      := format('User-Defined Files (*.%s)|*.%0:s', [DefaultUserDefExt]);

{ v.086 Std Import files removed
  if pos('*', DefaultImportExt) > 0 then
    OpenFileDialog.Filter      := OpenFileDialog.Filter + '|' + DefaultImportExt // power-users can specify their own filter
  else
    OpenFileDialog.Filter      := OpenFileDialog.Filter + '|'
        + format('Std Import Files (*.%s)|*.%0:s', [DefaultImportExt]);}

  OpenFileDialog.Filter        := OpenFileDialog.Filter + '|All Files (*.*)|*.*';

  OpenFileDialog.InitialDir    := DefaultImportFolder;
  DefaultMapFolder             := IniFile.ReadString(SYSTEM_SETTINGS, 'MAP Folder', '');
  DefaultMAPExt                := IniFile.ReadString(SYSTEM_SETTINGS, 'MAP Ext', 'MAP');
  OpenMapFileDialog.Filter     := format('Field Maps (*.%s)|*.%0:s|All Files (*.*)|*.*', [DefaultMapExt]);
  OpenMapFileDialog.InitialDir := DefaultMapFolder;
end;

procedure TfrmWizard.IsDirty;
// the job has been altered.
begin
  FIsDirty := true;
  ChangeCaption;
  EnableDisableEtc;
end;

function TfrmWizard.Monthly: boolean;
begin
  result := cbDailyMonthly.ItemIndex = 1;
end;

procedure TfrmWizard.NewJob;
begin
  CheckIfDirty;

  FImportJobFile := '<New Job>'; // for the window caption only.
  DoImportJob(slLoad, jtNewJob, wsAll);
end;

procedure TfrmWizard.NextTabSheet;
// display the next tabsheet in sequence if there is one
var
  ix: integer;
begin
  if PageControl.ActivePageIndex = PageControl.PageCount - 1 then exit;

  ix := PageControl.ActivePageIndex;
  PageControl.Pages[ix].TabVisible := false;
  PageControl.Pages[ix + 1].TabVisible := true;
  ChangePageLabel;
  EnableDisableEtc;
end;

procedure TfrmWizard.PrevTabSheet;
// display the previous tabsheet in sequence if there is one.
var
  ix: integer;
begin
  if PageControl.ActivePageIndex = 0 then exit;

  ix := PageControl.ActivePageIndex;
  PageControl.Pages[ix].TabVisible := false;
  PageControl.Pages[ix - 1].TabVisible := true;
  ChangePageLabel;
  EnableDisableEtc;
end;

function TfrmWizard.OpenJob: boolean;
// Open a job (SAV) file and load the contents into the Wizard's pages.
// if the current settings need saving, check with the user first.
// Only allow a user to open a job file for the company they logged-into unless
// they choose to rewrite the company in the job file.
begin
  CheckIfDirty;

  result := OpenJobDialog.Execute;

  if result then begin
    if CompanyMatches(OpenJobDialog.FileName) then begin
      FImportJobFile := OpenJobDialog.FileName;
      DoImportJob(slLoad, jtOldJob, wsAll);
    end
    else
      result := false
  end;
end;

procedure TfrmWizard.SaveImportSetting(NewValue: string);
// save the edited Import Setting back into the multilist
begin
  if mlImportSettings.Selected = -1 then exit;

  mlImportSettings.DesignColumns[COL_DEFJOB].Items[mlImportSettings.Selected] := 'JOB'; // indicate that this is no longer the default setting
  mlImportSettings.DesignColumns[COL_VALUE].Items[mlImportSettings.Selected] := NewValue;

  mlImportSettings.SetFocus;
  IsDirty;
end;

procedure TfrmWizard.SaveJobAs;
// save the job as a new SAV file
begin
  if SaveJobDialog.Execute then begin
    if FileExists(SaveJobDialog.FileName) then
      if (MessageDlg('Are you sure you want to overwrite the selected file ?', mtConfirmation, [mbYes, mbNo], 0) = mrNo) then exit;
    FImportJobFile := SaveJobDialog.FileName;
    DoImportJob(slSave, jtOldJob, wsAll);
  end;
end;

procedure TfrmWizard.SaveJobSetting(NewValue: string);
// save the amended job setting back into the multilist
//var
//  NewValue: string;
begin
  if mlJobSettings.Selected = -1 then exit;

  mlJobSettings.DesignColumns[COL_DEFJOB].Items[mlJobSettings.Selected] := 'JOB'; // indicate that this is no longer the default setting
  mlJobSettings.DesignColumns[COL_VALUE].Items[mlJobSettings.Selected] := NewValue;

  mlJobSettings.SetFocus;
  IsDirty;
end;

procedure TfrmWizard.SaveMapFile(NewValue: string);
// save the amended map file back into the multilist
begin
  if mlMapFiles.Selected = -1 then exit;

  mlMapFiles.DesignColumns[COL_DEFJOB].Items[mlMapFiles.Selected] := 'JOB'; // we've overridden the default value
  mlMapFiles.DesignColumns[COL_MAPFILES_MAPFILE].Items[mlMapFiles.Selected] := NewValue;

  IsDirty;
end;

procedure TfrmWizard.SaveMask(NewValue: string);
// save the amended filename or mask back into the multilist.
begin
  if mlImportList.Selected = -1 then exit;

  mlImportList.DesignColumns[COL_IMPORTLIST_PATH].Items[mlImportList.Selected] := IncludeTrailingPathDelimiter(ExtractFilePath(NewValue));
  mlImportList.DesignColumns[COL_IMPORTLIST_FILEMASK].Items[mlImportList.Selected] := ExtractFileName(NewValue);

  mlImportList.SetFocus;
  IsDirty;
end;

procedure TfrmWizard.ScheduleChanged;
begin
  IsDirty;
  EnableDisableEtc;
end;

function TfrmWizard.ScheduleValid: boolean;
// Valid if:-
// not enabled
// or they've selected Daily and at least one day of the week
// or they've selected Montly and at least one week of the month and at least one day of the week.
// AND they've selected a time to be run
begin
  result := (not cbEnabled.Checked)
             or (                     (cbMonday.Checked
                                    or cbTuesday.Checked
                                    or cbWednesday.Checked
                                    or cbThursday.Checked
                                    or cbFriday.Checked
                                    or cbSaturday.Checked
                                    or cbSunday.Checked)
             and (Daily or (Monthly and (cbFirst.Checked
                                                          or cbSecond.Checked
                                                          or cbThird.Checked
                                                          or cbFourth.Checked
                                                          or cbLast.Checked)))
             and (rbEvery.Checked or rbEveryBetween.Checked or rbOnce.Checked)
                                                          );
end;

procedure TfrmWizard.SelectFiles;
// select a file/files and add it/them into the ImportList multilist
var
  i: integer;
begin
  if OpenFileDialog.Execute then begin
    for i := 0 to OpenFileDialog.Files.Count - 1 do begin
      mlImportList.DesignColumns[COL_IMPORTLIST_PATH].Items.Add(ExtractFilePath(OpenFileDialog.Files[i]));
      mlImportList.DesignColumns[COL_IMPORTLIST_FILEMASK].Items.add(ExtractFileName(OpenFileDialog.Files[i]));
      MLSelectLast(mlImportList);
      IsDirty;
    end;
  end;
end;

procedure TfrmWizard.SelectFolder;
// select a folder and add it into the ImportList multilist.
// The mask defaults to *.* which the user can change.
begin
  if BrowseFolderDialog.Execute then begin
    mlImportList.DesignColumns[COL_IMPORTLIST_PATH].Items.Add(IncludeTrailingPathDelimiter(BrowseFolderDialog.FolderName));
    mlImportList.DesignColumns[COL_IMPORTLIST_FILEMASK].Items.add('*.*');
    mlImportList.Selected := mlImportList.ItemsCount - 1;
    IsDirty;
  end;
end;

procedure TfrmWizard.SetSaveCoordinates(Checked: boolean);
// duplicate the setting of one menu item in all of them
begin
  mniImportListSaveCoordinates.Checked     := Checked;
  mniJobSettingsSavecoordinates.Checked    := Checked;
  mniImportSettingsSavecoordinates.Checked := Checked;
  mniMapFilesSavecoordinates.Checked       := Checked;

  FSaveCoordinates                         := Checked;
end;

procedure TfrmWizard.SetupTabHeadings;
// hmmm - "best laid plans" etc.
begin
end;

procedure TfrmWizard.Shutdown;
begin
  if FSaveCoordinates then
    FormSaveSettings(Self, nil);

  FreeObjects([FPoster]);
end;

procedure TfrmWizard.Startup;
var
  i: integer;
begin
  FIniFile := nil;
  MLInit(mlImportList);
  MLInit(mlJobSettings);
  MLInit(mlImportSettings);
  MLInit(mlMapFiles);
  HideTabs;
  SetupTabHeadings;
  EnableDisableEtc;
  InitDialogs;

// Load saved form settings
  FormLoadSettings(Self, nil);

// Load saved ML settings
  MLLoadSettings(mlImportList, Self);
  MLLoadSettings(mlJobSettings, Self);
  MLLoadSettings(mlImportSettings, Self);
  MLLoadSettings(mlMapFiles, Self);

  if debugit then begin // make all columns in ML's visible
    for i := 0 to mlMapFiles.Columns.Count - 1 do begin
//      mlImportList.DesignColumns[i].Visible     := true; // *** haven't got same no. of columns
//      mlJobSettings.DesignColumns[i].Visible    := true;
//      mlImportSettings.DesignColumns[i].Visible := true;
      mlMapFiles.DesignColumns[i].Visible       := true;
    end;
  end;

  Application.OnHelp := hhHelper.ApplicationHelp;
end;

{* Event Procedures *}

procedure TfrmWizard.FormCreate(Sender: TObject);
begin
  Startup;
end;

procedure TfrmWizard.btnCloseClick(Sender: TObject);
begin
  close;
end;

procedure TfrmWizard.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  CheckIfDirty;
  Shutdown;
  action := caFree;
  frmWizard := nil;
end;

procedure TfrmWizard.btnPrevClick(Sender: TObject);
begin
  PrevTabSheet;
end;

procedure TfrmWizard.btnNextClick(Sender: TObject);
begin
  NextTabSheet;
end;

procedure TfrmWizard.btnAddClick(Sender: TObject);
begin
  MenuPopup(PopupMenu1, btnAdd);
end;

procedure TfrmWizard.mnuSelectFilesClick(Sender: TObject);
begin
  SelectFiles;
end;

procedure TfrmWizard.mnuSelectFolderClick(Sender: TObject);
begin
  SelectFolder;
end;

procedure TfrmWizard.btnSaveClick(Sender: TObject);
begin
  DoImportJob(slSave, jtOldJob, wsAll);
end;

procedure TfrmWizard.btnSaveAsClick(Sender: TObject);
begin
  SaveJobAs;
end;

procedure TfrmWizard.btnRemoveItemClick(Sender: TObject);
begin
  MLDeleteSelectedRow(mlImportList);
  IsDirty;
end;

procedure TfrmWizard.btnRemoveAllItemsClick(Sender: TObject);
begin
  mlImportList.ClearItems;
  IsDirty;
end;

procedure TfrmWizard.btnEditItemClick(Sender: TObject);
begin
  EditItem;
end;

procedure TfrmWizard.mlImportListChangeSelection(Sender: TObject);
// a double-click also generates an OnChangeSelection event even if it hasn't.
// We only reset what's enabled/disabled on a true change of selection.
begin
  if not FDoubleClicking then
    EnableDisableEtc;
  FDoubleClicking := false;
end;

procedure TfrmWizard.mlImportListRowDblClick(Sender: TObject; RowIndex: Integer);
begin
  FDoubleClicking := true;
  EditItem;
end;

procedure TfrmWizard.btnEditJobSettingClick(Sender: TObject);
begin
  EditJobSetting;
end;

procedure TfrmWizard.mlJobSettingsRowDblClick(Sender: TObject; RowIndex: Integer);
begin
  FDoubleClicking := true;
  EditJobSetting;
end;

procedure TfrmWizard.mlImportSettingsRowDblClick(Sender: TObject; RowIndex: Integer);
begin
  FDoubleClicking := true;
  EditImportSetting;
end;

procedure TfrmWizard.mlMapFilesRowDblClick(Sender: TObject; RowIndex: Integer);
begin
  FDoubleClicking := true; // alters the behaviour of ml.OnChangeSelection
//  EditMapFile;
  EditMap; // v.081
end;

procedure TfrmWizard.btnEditMapFileClick(Sender: TObject);
begin
  EditMapFile;
end;

procedure TfrmWizard.btnMoveMapFileUpClick(Sender: TObject);
begin
  MLMoveSelectedRowUp(mlMapFiles);
  IsDirty;
end;

procedure TfrmWizard.btnMoveMapFileDownClick(Sender: TObject);
begin
  MLMoveSelectedRowDown(mlMapFiles);
  IsDirty;
end;

procedure TfrmWizard.btnMoveImportListUpClick(Sender: TObject);
begin
  MLMoveSelectedRowUp(mlImportList);
  IsDirty;
end;

procedure TfrmWizard.btnMoveImportListDownClick(Sender: TObject);
begin
  MLMoveSelectedRowDown(mlImportList);
  IsDirty;
end;

procedure TfrmWizard.btnEditMapClick(Sender: TObject);
begin
  EditMap;
end;

procedure TfrmWizard.mlJobSettingsChangeSelection(Sender: TObject);
// a double-click also generates an OnChangeSelection event even if it hasn't.
// We only reset what's enabled/disabled on a true change of selection.
begin
  if not FDoubleClicking then
    EnableDisableEtc;
  FDoubleClicking := false;
end;

procedure TfrmWizard.mlImportSettingsChangeSelection(Sender: TObject);
// a double-click also generates an OnChangeSelection event even if it hasn't.
// We only reset what's enabled/disabled on a true change of selection.
begin
  if not FDoubleClicking then
    EnableDisableEtc;
  FDoubleClicking := false;
end;

procedure TfrmWizard.mlMapFilesChangeSelection(Sender: TObject);
// a double-click also generates an OnChangeSelection event even if it hasn't.
// We only reset what's enabled/disabled on a true change of selection.
begin
  if not FDoubleClicking then
    EnableDisableEtc;
  FDoubleClicking := false;
end;

procedure TfrmWizard.btnEditImportSettingClick(Sender: TObject);
begin
  EditImportSetting;
end;

procedure TfrmWizard.btnMoveJobSettingUpClick(Sender: TObject);
begin
  MLMoveSelectedRowUp(mlJobSettings);
  IsDirty;
end;

procedure TfrmWizard.btnMoveJobSettingDownClick(Sender: TObject);
begin
  MLMoveSelectedRowDown(mlJobSettings);
  IsDirty;
end;

procedure TfrmWizard.btnMoveImportSettingUpClick(Sender: TObject);
begin
  MLMoveSelectedRowUp(mlImportSettings);
  IsDirty;
end;

procedure TfrmWizard.btnReloadScheduleClick(Sender: TObject);
begin
  DoImportJob(slLoad, FJobType, wsSchedule);
end;

procedure TfrmWizard.edtFolderKeyPress(Sender: TObject; var Key: Char);
begin
 Key := ValidKeyPress(Key, 'P', 0); // is this a valid key for a path name
end;

procedure TfrmWizard.edtMaskKeyPress(Sender: TObject; var Key: Char);
begin
  if Key <> '*' then
    Key := ValidKeyPress(Key, 'F', 0);
end;

procedure TfrmWizard.edtMapFileKeyPress(Sender: TObject; var Key: Char);
begin
  Key := ValidKeyPress(Key, 'P', 0);
end;

procedure TfrmWizard.rbMonthlyClick(Sender: TObject);
// all the OnClick methods of the Schedule tab radio buttons and check boxes point here
begin
  ScheduleChanged;
end;

procedure TfrmWizard.edtEveryKeyPress(Sender: TObject; var Key: Char);
begin
  Key := ValidKeyPress(Key, 'B', 0); // Byte DataType only allows digits
end;

procedure TfrmWizard.dtpTimeFromChange(Sender: TObject);
begin
//  with sender as TDateTimePicker do
//    Time := StrToDateTime(FormatDateTime('hh:nn', Time)); // always make the seconds :00 - no need, found dtp.format property !
  ScheduleChanged;
end;

procedure TfrmWizard.edtEveryChange(Sender: TObject);
begin
  with sender as TEdit do
    if (text = '') or (StrToInt(text) = 0) then
      text := '1'
    else
      if StrToInt(text) > 1440 then
        text := '1440'; // 24 hours
  ScheduleChanged;
end;

procedure TfrmWizard.FormKeyPress(Sender: TObject; var Key: Char);
begin
  Key := EnterToTab(Key, handle);
  if AdminModeChanged(key) then
    ChangeCaption;
end;

procedure TfrmWizard.cbDailyMonthlyChange(Sender: TObject);
begin
  ScheduleChanged;
end;

procedure TfrmWizard.btnNextRunClick(Sender: TObject);
begin
  FormatNextRunLabel;
end;

procedure TfrmWizard.FormKeyUp(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  if key = VK_ESCAPE then close;
end;

procedure TfrmWizard.mniImportListPropertiesClick(Sender: TObject);
begin
  MLEditProperties(mlImportList, Self, nil);
end;

procedure TfrmWizard.mniSaveCoordinatesClick(Sender: TObject);
begin
  with Sender as TMenuItem do begin
    Checked := not Checked;
    SetSaveCoordinates(Checked);
  end;
end;

procedure TfrmWizard.mniJobSettingsPropertiesClick(Sender: TObject);
begin
  MLEditProperties(mlJobSettings, Self, nil);
end;

procedure TfrmWizard.mniImportSettingsPropertiesClick(Sender: TObject);
begin
  MLEditProperties(mlImportSettings, Self, nil);
end;

procedure TfrmWizard.mniFieldMapsPropertiesClick(Sender: TObject);
begin
  MLEditProperties(mlMapFiles, Self, nil);
end;

{* Getters and Setters *}

procedure TfrmWizard.SetPoster(const Value: TPoster);
begin
  FPoster := Value;
end;

{* Message Handlers *}

procedure TfrmWizard.WMMoving(var msg: TMessage);
begin
  WindowMoving(msg, height, width);
end;

procedure TfrmWizard.btnJobSettingsDefaultsClick(Sender: TObject);
begin
  DoJobSettings(slLoad, true);
end;

procedure TfrmWizard.btnImportSettingsDefaultsClick(Sender: TObject);
begin
  DoImportSettings(slLoad, true);
end;

procedure TfrmWizard.btnViewFileClick(Sender: TObject);
begin
  TfrmFileViewer.Show(mlImportList.DesignColumns[COL_IMPORTLIST_PATH].items[mlImportList.selected]
                       + mlImportList.DesignColumns[COL_IMPORTLIST_FILEMASK].Items[mlImportList.selected], 1);
end;

procedure TfrmWizard.mniEditImportSettingClick(Sender: TObject);
begin
  EditImportSetting;
end;

initialization
  frmWizard := nil;

end.
