unit DefaultSettings;

{******************************************************************************}
{* Allows the editing of some of the sections of Importer's main settings file*}
{* This unit was copied from Wizard.pas. To allow for future expansion, some  *}
{* small items of code have been left in which are redundant here but may be  *}
{* useful later. An example of this is in the DoSettings procedure which      *}
{* checks for items in column zero of the MultiList having the value "DEF"    *}
{* when that's all it could have.                                             *}
{* 9/11/2005: if in AdminMode, all the sections from the settings file will   *}
{* be loaded. If a setting is removed, column zero is flagged as "DEL" which  *}
{* will delete the setting from the settings file if the section is saved.    *}
{* With the introduction of AdminMode, this form provides full editing        *}
{* capability of the main settings file - in theory it shouldn't be necessary *}
{* to edit in notepad anymore....                                             *}
{* 12/2005 ...which is handy coz the file is now encrypted.                   *}
{*                                                                            *}
{* N.B. By replacing calls to the TIni object with a standard TIniFile this   *}
{* form would provide a generic Ini file editor.                              *}
{******************************************************************************}

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ComCtrls, StdCtrls, TCustom, ExtCtrls, Menus, psvDialogs,
  uMultiList, IniFiles, GlobalTypes;

type

  TfrmDefaultSettings = class(TForm)
    PageControl: TPageControl;
    tsSettings: TTabSheet;
    pnlSections: TPanel;
    GroupBox1: TGroupBox;
    lbSections: TListBox;
    OpenJobDialog: TpsvOpenDialog;
    BrowseFolderDialog: TpsvBrowseFolderDialog;
    PopupMenu1: TPopupMenu;
    mnuSelectFolder: TMenuItem;
    mnuSelectFiles: TMenuItem;
    Edit2: TEdit;
    SaveJobDialog: TpsvSaveDialog;
    OpenFileDialog: TpsvOpenDialog;
    OpenMapFileDialog: TOpenDialog;
    btnMoveSettingUp: TButton;
    btnMoveSettingDown: TButton;
    mlSettings: TMultiList;
    btnAddSetting: TButton;
    btnEditSetting: TButton;
    btnRemoveSetting: TButton;
    btnRemoveAllSettings: TButton;
    btnReloadSettings: TButton;
    gbSections: TGroupBox;
    btnAdminReload: TButton;
    btnAdminAddSection: TButton;
    btnAdminRemoveSection: TButton;
    btnPrev: TButton;
    btnNext: TButton;
    btnSave: TButton;
    btnClose: TButton;
    lblPage: TLabel;
    PopupMenu2: TPopupMenu;
    mniEditSetting: TMenuItem;
    mniRemoveSetting: TMenuItem;
    PopupMenu3: TPopupMenu;
    mniAdminReload: TMenuItem;
    mniAdminAddSection: TMenuItem;
    mniAdminRemoveSection: TMenuItem;
    mniAddSetting: TMenuItem;
    mniReloadSettings: TMenuItem;
    mniRemoveAllSettings: TMenuItem;
    N1: TMenuItem;
    mniProperties: TMenuItem;
    mniSaveCoordinates: TMenuItem;
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure btnCloseClick(Sender: TObject);
    procedure lbSectionsDblClick(Sender: TObject);
    procedure mlSettingsRowDblClick(Sender: TObject; RowIndex: Integer);
    procedure btnEditSettingClick(Sender: TObject);
    procedure mlSettingsChangeSelection(Sender: TObject);
    procedure btnSaveClick(Sender: TObject);
    procedure FormKeyPress(Sender: TObject; var Key: Char);
    procedure btnAdminReloadClick(Sender: TObject);
    procedure btnMoveSettingUpClick(Sender: TObject);
    procedure btnMoveSettingDownClick(Sender: TObject);
    procedure btnReloadSettingsClick(Sender: TObject);
    procedure btnRemoveSettingClick(Sender: TObject);
    procedure btnRemoveAllSettingsClick(Sender: TObject);
    procedure btnAddSettingClick(Sender: TObject);
    procedure btnAdminAddSectionClick(Sender: TObject);
    procedure btnAdminRemoveSectionClick(Sender: TObject);
    procedure lbSectionsClick(Sender: TObject);
    procedure btnPrevClick(Sender: TObject);
    procedure btnNextClick(Sender: TObject);
    procedure FormKeyUp(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure mniPropertiesClick(Sender: TObject);
    procedure mniSaveCoordinatesClick(Sender: TObject);
  protected
    constructor create(AOwner: TComponent); override;
  private
{* internal fields *}
    FDoubleClicking: boolean;
    FFixedList: boolean;
    FHelping: boolean;
    FIniSection: string;
    FIniSections: TStringList;
    FIsDirty: boolean;
    FSettingType: TSettingType;
{* property fields *}
{* procedural methods *}
    procedure AddSection;
    procedure AddSetting;
    procedure ChangeCaption;
    procedure ChangeSection(AIniSection: string);
    procedure ChangePageLabel;
    procedure CheckColour;
    procedure CheckIfDirty;
    procedure DeleteSection;
    procedure DoSettings(SaveLoad: TSaveLoad; AIniSection: string);
    procedure EditSetting;
    procedure EnableDisableEtc;
    procedure HideTabs;
    procedure HighlightSection;
    procedure InitDialogs;
    procedure IsDirty;
    procedure RemoveAllSettings;
    procedure SaveSetting(NewValue: string);
    procedure SelectionChanged;
    procedure SetupSectionHeadings;
    procedure Shutdown;
    procedure Startup;
{* Message Handlers *}
    procedure WMMoving(var msg: TMessage); message WM_MOVING;
  public
    class procedure Show(SettingsSection: string);
  end;


implementation

uses utils, GlobalConsts, TIniClass, MapMaint, IniMaint, LoginF, EditBox;

const
  COL_DEFJOB    = 0;
  COL_SETTING   = 1;
  COL_VALUE     = 2;

var
  frmDefaultSettings: TfrmDefaultSettings;

{$R *.dfm}

{ TfrmDefaultSettings }

class procedure TfrmDefaultSettings.Show(SettingsSection: string);
// overrides the inherited Show method.
// Callers must call "TrmDefaultSettings.Show" to display this form.
// This method takes care of creating an instance if necessary or reuses
// the existing one.
begin
  if not assigned(frmDefaultSettings) then
    frmDefaultSettings := TfrmDefaultSettings.Create(nil);

  if SettingsSection <> '' then
    frmDefaultSettings.ChangeSection(SettingsSection);

// inherited show
  frmDefaultSettings.WindowState := wsNormal;
  frmDefaultSettings.visible := true; // irrelevant since can't set MDIChild.visible to false
  frmDefaultSettings.BringToFront;

  frmDefaultSettings.EnableDisableEtc;
end;

constructor TfrmDefaultSettings.create(AOwner: TComponent);
// Reduced visibility to discourage creation of more than one instance.
// Accepted method of displaying this form is to call "TfrmDefaultSettings.show"
// which creates an instance if one doesn't already exist.
begin
  inherited create(AOwner);

//  SetConstraints(Constraints, height, width);
end;

{* Procedural Methods *}

procedure TfrmDefaultSettings.AddSection;
// can't create an ini section without providing a key, so we create the
// ubiquitous "Type" key for their convenience. They can always delete it if
// its not appropriate.
var
  NewSection: string;
begin
  NewSection := InputBox('Enter new section name', '', '');
  if NewSection = '' then
    exit
  else begin
    IniFile.WriteString(NewSection, 'Type', '');
    SetupSectionHeadings;
    ChangeSection(NewSection);
  end;
end;

procedure TfrmDefaultSettings.AddSetting;
// add a new entry to the ML, position on it, initiate editing.
var
  NewSetting: string;
begin
  NewSetting := InputBox('Enter new setting name', '', '');
  if NewSetting = '' then
    exit
  else begin
    mlSettings.DesignColumns[COL_DEFJOB].Items.Add('DEF');            // add new entry to ML
    mlSettings.DesignColumns[COL_SETTING].Items.add(NewSetting);
    mlSettings.DesignColumns[COL_VALUE].Items.add('<New Value>');
    MLSelectLast(mlSettings);                                        // select it
    EditSetting;                                                     // edit it
  end;
  IsDirty;
end;

procedure TfrmDefaultSettings.ChangeCaption;
// FIsDirty will only be true in AdminMode.
var
  s: string;
begin
  if FIsDirty then s := '*';
  Caption := format('Default Settings - [<Importer>]%s', [s]);

  if InAdminMode then
    Caption := Caption + '^';

  if FIsDirty then
    btnClose.Caption := 'Cancel'
  else
    btnClose.Caption := 'Close';
end;

procedure TfrmDefaultSettings.ChangePageLabel;
begin
  lblPage.Caption := format('Page %d of %d', [lbSections.ItemIndex + 1, lbSections.items.count]);
end;

procedure TfrmDefaultSettings.ChangeSection(AIniSection: string);
begin
  if AIniSection = FIniSection then exit; // user clicked the same section twice
  CheckIfDirty; // save any changes made to the previously displayed section
  FIniSection     := AIniSection;
  tsSettings.Caption := FIniSection;
  HelpContext := 2 + lbSections.Items.IndexOf(AIniSection);
  if not InAdminMode then
    tsSettings.Caption := 'Default ' + tsSettings.Caption;
  DoSettings(slLoad, FIniSection); // load the ini section into the ML
  if lbSections.Items[lbSections.ItemIndex] <> AIniSection then // Selecting the section isn't the only way of displaying it so
    lbSections.Selected[lbSections.Items.IndexOf(AIniSection)] := true; // make sure selected section is displayed section
end;

procedure TfrmDefaultSettings.CheckColour;
// if a row in the ML has been flagged for deletion we highlight it in red
// otherwise we highlight a row in white.
begin
  if mlSettings.Selected = -1 then exit;
  if mlSettings.DesignColumns[COL_DEFJOB].Items[mlSettings.Selected] = 'DEL' then
    mlSettings.HighlightFont.Color := clRed
  else
    mlSettings.HighlightFont.Color := clWhite;
end;

procedure TfrmDefaultSettings.CheckIfDirty;
// If any of the settings in the current section been edited we ask the user
// to Save them before we change sections, otherwise they'll lose their edits
// when we load the ML with the new section.
begin
  if FIsDirty then
    if (MessageDlg('Do you want to save your changes ?', mtConfirmation, [mbYes, mbNo], 0) = mrYes) then
      DoSettings(slSave, FIniSection);
end;

procedure TfrmDefaultSettings.DeleteSection;
// Delete a section from the main settings file. This option is only available
// in Admin Mode.
begin
  if lbSections.ItemIndex = -1 then exit;
  if (MessageDlg(format('N.B. This action cannot be undone !'#13#10#13#10'Are you sure you want to delete the [%s] section ?', [lbSections.Items[lbSections.ItemIndex]]), mtConfirmation, [mbYes, mbNo], 0) = mrYes) then begin
    IniFile.EraseSection(lbSections.Items[lbSections.ItemIndex]); // erase from the settings file
    lbSections.Items.Delete(lbSections.ItemIndex);                // remove it from the list box
    mlSettings.ClearItems;                                        // clear the displayed items from the section
    FIsDirty := false;                                            // immediate undoable action
    EnableDisableEtc;
  end;
end;

procedure TfrmDefaultSettings.DoSettings(SaveLoad: TSaveLoad; AIniSection: string);
// Save: all settings are written back to the settings file unless they've been
//       flagged for deletion in which case they get deleted.
// Load: read the default settings from Importer's settings file (IniFile).
var
  DefSettings: TStringList;
  i: integer;
begin
  case SaveLoad of
    slSave: begin
              for i := 0 to mlSettings.ItemsCount - 1 do
                if mlSettings.DesignColumns[COL_DEFJOB].Items[i] = 'DEL' then // set by btnRemoveSetting
                  IniFile.DeleteKey(AIniSection, mlSettings.DesignColumns[COL_SETTING].Items[i])
                else
                  IniFile.WriteString(AIniSection, mlSettings.DesignColumns[COL_SETTING].Items[i], mlSettings.DesignColumns[COL_VALUE].Items[i]);
            end;
    slLoad: begin
              mlSettings.ClearItems;
              DefSettings := TStringList.create;
              try
                IniFile.ReturnValuesInList(AIniSection, DefSettings); // read the entire section
                for i := 0 to DefSettings.Count - 1 do begin
                  if not SettingTF(IniFile.ReadString(DefSettings.Names[i], 'Hidden', 'No')) or InAdminMode then begin // won't display the UserName and Password entries etc if Hidden=Yes in Importer.dat
                    mlSettings.DesignColumns[COL_DEFJOB].items.add('DEF'); // remember where we got the setting from
                    mlSettings.DesignColumns[COL_SETTING].Items.add(DefSettings.Names[i]); // the name= part
                    mlSettings.DesignColumns[COL_VALUE].Items.add(DefSettings.Values[DefSettings.Names[i]]); // the =value part
                  end;
                end;
                MLSelectFirst(mlSettings);
                mlSettings.SortColumn(1, true);
              finally
                DefSettings.free;
              end;
            end;
  end;
  FIsDirty := false; // all clean and fresh again
  EnableDisableEtc;
  ChangeCaption;
end;

procedure TfrmDefaultSettings.EditSetting;
// Importer's main settings file specifies what type of value the setting can be
// set to, e.g. fixed list, file name, folder name, free text.
// This Show procedure in EditBox.pas reacts to the type of setting and displays either a drop down
// list or an edit box as appropriate. It also enables the Select button to
// allow the user to browse for a file or folder if appropriate.
// If a setting has a fixed set of possible values, these will have been defined in the main
// Importer settings file in a section named the same as the setting.
// If this procedure finds there is such a section, the drop down list is populated with the
// possible values and the ItemIndex is set to the current value.
// Otherwise, the setting is a free-format value and the edit box is displayed.
var
  NewValue: string;
begin
  if mlSettings.Selected = -1 then exit;

  if TfrmEditBox.Show(FIniSection,                                                      {Ini Section}
                      mlSettings.DesignColumns[COL_SETTING].items[mlSettings.selected], {Setting Name}
                      ' ',                                                              {Data Type}
                      0,                                                                {max length}
                      '',                                                               {DataType Caption}
                      '',                                                               {Caption}
                      '',                                                               {msg/prompt/hint}
                      mlSettings.DesignColumns[COL_VALUE].Items[mlSettings.selected],   {Current Value}
                      OpenFileDialog, BrowseFolderDialog, nil, true,
                      NewValue) then
      SaveSetting(NewValue); // "save" the amended setting back into the ML
end;

procedure TfrmDefaultSettings.EnableDisableEtc;
// change what's enabled/disabled depending on which tabsheet is being viewed.
begin
  btnSave.Visible     := InAdminMode;
  btnSave.Enabled     := FIsDirty;

  if InAdminMode then begin // create space to show the Sections panel
    width := 752;
    PageControl.Left := pnlSections.Width + 8;
    left := 229 - 93; // position centrally (752 - 566) / 2 = 93
  end
  else begin
    width := 566;
    PageControl.Left := 6;
    left := 229;
  end;

  if PageControl.ActivePage = tsSettings then begin // there were originally more tabs on this PageControl
    btnEditSetting.Enabled       := mlSettings.ItemsCount <> 0;
    btnReloadSettings.Visible    := InAdminMode;
    btnRemoveSetting.Enabled     := mlSettings.ItemsCount <> 0;
    btnRemoveAllSettings.Enabled := mlSettings.ItemsCount <> 0;
    btnMoveSettingUp.Enabled     := mlSettings.ItemsCount <> 0;
    btnMoveSettingDown.Enabled   := mlSettings.ItemsCount <> 0;
  end;

  btnPrev.Enabled                := lbSections.ItemIndex <> 0;
  btnNext.Enabled                := lbSections.ItemIndex <> lbSections.Count - 1;

  btnAddSetting.visible          := InAdminMode;
  btnRemoveSetting.Visible       := InAdminMode;
  btnRemoveAllSettings.Visible   := InAdminMode;
  btnRemoveSetting.Enabled       := InAdminMode and (mlSettings.Selected <> -1);
  btnRemoveAllSettings.Enabled   := InAdminMode;

  pnlSections.Visible            := InAdminMode;
  gbSections.Visible             := InAdminMode;
  btnAdminReload.Visible         := InAdminMode;
  btnAdminAddSection.Visible     := InAdminMode;
  btnAdminRemoveSection.Visible  := InAdminMode;
  btnAdminRemoveSection.enabled  := InAdminMode and (lbSections.ItemIndex <> -1);

  mniEditSetting.Enabled         := btnEditSetting.Enabled; // PopupMenu2
  mniAddSetting.Visible          := btnAddSetting.Visible;
  mniReloadSettings.Visible      := btnReloadSettings.Visible;
  mniRemoveSetting.Visible       := btnRemoveSetting.Visible;
  mniRemoveSetting.Enabled       := btnRemoveSetting.Enabled;
  mniRemoveAllSettings.Visible   := btnRemoveAllSettings.Visible;
  mniRemoveAllSettings.Enabled   := btnRemoveAllSettings.Enabled;

  mniAdminReload.Visible         := btnAdminReload.Visible; // PopupMenu3
  mniAdminAddSection.Visible     := btnAdminAddSection.Visible;
  mniAdminRemoveSection.Visible  := btnAdminRemoveSection.Visible;
end;

procedure TfrmDefaultSettings.HideTabs;
// hide the tabs of all the TabSheets and set the first page active
var
  i: integer;
begin
  for i := 0 to PageControl.PageCount - 1 do
    PageControl.Pages[i].TabVisible := false;

  PageControl.Pages[0].TabVisible := true;
  PageControl.ActivePage := PageControl.Pages[0];
  ChangePageLabel;
end;

procedure TfrmDefaultSettings.HighlightSection;
// gets called when a TabSheet is displayed to highlight the first line of
// the MultiList. This saves the user from having to click a line of the
// multilist before any of the buttons have a line to work with.
begin
//  lbSections.Selected[lbSections.Items.IndexOf(PageControl.Pages[PageControl.ActivePageIndex].Caption)] := true;
  MLSelectFirst(mlSettings);
end;

procedure TfrmDefaultSettings.InitDialogs;
// set up filters, initial directories etc of the various OpenDialog and BrowseForFolder dialogs
// OpenJobDialog is the only one which insists that the file exists.
// All the others allow the user to set up a job prior to files existing on their system.
var
  DefaultImportExt: string;
  DefaultImportFolder: string;
  DefaultJobExt: string;
  DefaultJobFolder: string;
  DefaultMapFolder: string;
  DefaultMapExt: string;
  DefaultUserDefExt: string;
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
  DefaultImportExt             := IniFile.ReadString(SYSTEM_SETTINGS, 'Std Import Ext', 'IMP');
  OpenFileDialog.Filter        := format('User Defined Files (*.%s)|*.%0:s|Std Import Files (*.%s)|*.%1:s|All Files (*.*)|*.*', [DefaultUserDefExt, DefaultImportExt]);
  OpenFileDialog.InitialDir    := DefaultImportFolder;
  DefaultMapFolder             := IniFile.ReadString(SYSTEM_SETTINGS, 'MAP Folder', '');
  DefaultMAPExt                := IniFile.ReadString(SYSTEM_SETTINGS, 'MAP Ext', 'MAP');
  OpenMapFileDialog.Filter     := format('Map Files (*.%s)|*.%0:s|All Files (*.*)|*.*', [DefaultMapExt]);
  OpenMapFileDialog.InitialDir := DefaultMapFolder;
end;

procedure TfrmDefaultSettings.IsDirty;
// the job has been altered.
// If we're not in AdminMode we save the change immediately as the user doesn't
// get to see the Save button.
// If we are in AdminMode, the user gets the full range of buttons which means
// they can also cancel all their changes so we set FIsDirty to true and the
// caption changes to show that they've made alterations.
begin
  if 	InAdminMode then begin
    FIsDirty := true;
    ChangeCaption;
  end
  else
    DoSettings(slSave, FIniSection);
  EnableDisableEtc;
end;

procedure TfrmDefaultSettings.RemoveAllSettings;
// marks all settings for deletion
var
  i: integer;
begin
  for i := 0 to mlSettings.ItemsCount - 1 do
    mlSettings.DesignColumns[COL_DEFJOB].Items[i] := 'DEL';
  CheckColour; // change the colour of the selected row
  IsDirty;
end;

procedure tfrmDefaultSettings.SaveSetting(NewValue: string);
// save the amended job setting back into the multilist
begin
  if mlSettings.Selected = -1 then exit;

//  if mlSettings.DesignColumns[COL_SETTING].Items[mlSettings.Selected] <> edtSettingName.Text then
//    mlSettings.DesignColumns[COL_SETTING].Items[mlSettings.Selected] := edtSettingName.Text; // only amend if its changed

  mlSettings.DesignColumns[COL_VALUE].Items[mlSettings.Selected] := NewValue;

  mlSettings.SetFocus;
  IsDirty;
end;

procedure TfrmDefaultSettings.SelectionChanged;
// the user clicked or double-clicked in the listbox.
// Change which section is being viewed and if the section is for an Exchequer
// record definition display it using the IniMaint form.
// Record Definitions are listed in the FIELD_DEFS section of the main settings
// file.
begin
  ChangeSection(lbSections.items[lbSections.ItemIndex]);
  EnableDisableEtc;
  if InAdminMode then
    if IniFile.ReadString(FIELD_DEFS, lbSections.items[lbSections.ItemIndex], 'NO') <> 'NO' then // is this section listed in the [FieldDefs] section ?
      TfrmIniMaint.Show(lbSections.items[lbSections.ItemIndex]);
end;

procedure TfrmDefaultSettings.SetupSectionHeadings;
// Reads through the list of sections in the main settings file.
// If a section is listed in the [User Sections] section then the user is
// allowed to edit it and it gets added to the list box.
// If we're in AdminMode, all sections get added.
var
  i: integer;
begin
  FIniSections.Clear;
  lbSections.Clear;

  if InAdminMode then
    FIniSections.AddStrings(IniFile.IniSections)
  else
    for i := 0 to IniFile.IniSections.Count -1 do
      if IniFile.ReadString(USER_SECTIONS, IniFile.IniSections[i], 'NO') <> 'NO' then
        FIniSections.Add(IniFile.IniSections[i]);

  if InAdminMode then
    FIniSections.Sorted := true; // else they'll be in the order they're listed in the settings file
  lbSections.Items.AddStrings(FIniSections);

  lbSections.ItemIndex := 0;
  tsSettings.Caption := lbSections.Items[0];
  if not InAdminMode then
    tsSettings.Caption := 'Default ' + tsSettings.Caption;
  FIniSection := lbSections.Items[0];
end;

procedure TfrmDefaultSettings.Shutdown;
begin
  FreeObjects([FIniSections]);
end;

procedure TfrmDefaultSettings.Startup;
begin
//  MLInit(mlSettings);
  FormLoadSettings(Self, nil);
  MLLoadSettings(mlSettings, Self);
  FIniSections := TStringList.create;
//  HideTabs; // only one tab at the moment and it's already hidden
  SetupSectionHeadings;
  HighlightSection;
  ChangePageLabel;
  EnableDisableEtc;
  InitDialogs;
//  LBInit(lbSections);
  DoSettings(slLoad, lbSections.Items[lbSections.ItemIndex]);
end;

{* Event Procedures *}

procedure TfrmDefaultSettings.FormCreate(Sender: TObject);
begin
  Startup;
end;

procedure TfrmDefaultSettings.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  CheckIfDirty;
  if mniSaveCoordinates.Checked then
    FormSaveSettings(Self, nil);
  action := caFree;
  frmDefaultSettings := nil;
end;

procedure TfrmDefaultSettings.btnCloseClick(Sender: TObject);
begin
  close;
end;

procedure TfrmDefaultSettings.lbSectionsDblClick(Sender: TObject);
begin
  SelectionChanged;
end;

procedure TfrmDefaultSettings.mlSettingsRowDblClick(Sender: TObject; RowIndex: Integer);
begin
  FDoubleClicking := true;
  EditSetting;
end;

procedure TfrmDefaultSettings.btnEditSettingClick(Sender: TObject);
begin
  EditSetting;
end;

procedure TfrmDefaultSettings.mlSettingsChangeSelection(Sender: TObject);
begin
  if not FDoubleClicking then
    EnableDisableEtc;

  CheckColour;

  FDoubleClicking := false;
end;

procedure TfrmDefaultSettings.btnSaveClick(Sender: TObject);
begin
  DoSettings(slSave, FIniSection);
end;

procedure TfrmDefaultSettings.FormKeyPress(Sender: TObject; var Key: Char);
begin
  if AdminModeChanged(key) then // entering the key a second time turns off AdminMode
    ChangeCaption;
end;

procedure TfrmDefaultSettings.btnAdminReloadClick(Sender: TObject);
begin
  CheckIfDirty;
  SetupSectionHeadings;
  ChangeSection(lbSections.items[lbSections.ItemIndex]);
  ChangePageLabel;
end;

procedure TfrmDefaultSettings.btnMoveSettingUpClick(Sender: TObject);
// obsolete
begin
  MLMoveSelectedRowUp(mlSettings);
  IsDirty;
end;

procedure TfrmDefaultSettings.btnMoveSettingDownClick(Sender: TObject);
// obsolete
begin
  MLMoveSelectedRowDown(mlSettings);
  IsDirty;
end;

procedure TfrmDefaultSettings.btnReloadSettingsClick(Sender: TObject);
begin
  DoSettings(slLoad, lbSections.Items[lbSections.ItemIndex]);
end;

procedure TfrmDefaultSettings.btnRemoveSettingClick(Sender: TObject);
begin
  if mlSettings.Selected = -1 then exit;

  mlSettings.DesignColumns[COL_DEFJOB].Items[mlSettings.Selected] := 'DEL';
  CheckColour;
  IsDirty;
end;

procedure TfrmDefaultSettings.btnRemoveAllSettingsClick(Sender: TObject);
begin
  RemoveAllSettings;
end;

procedure TfrmDefaultSettings.btnAddSettingClick(Sender: TObject);
begin
  AddSetting;
end;

procedure TfrmDefaultSettings.btnAdminAddSectionClick(Sender: TObject);
begin
  CheckIfDirty;
  AddSection;
end;

procedure TfrmDefaultSettings.btnAdminRemoveSectionClick(Sender: TObject);
begin
  DeleteSection;
end;

procedure TfrmDefaultSettings.lbSectionsClick(Sender: TObject);
begin
  SelectionChanged;
end;

procedure TfrmDefaultSettings.btnPrevClick(Sender: TObject);
begin
  ChangeSection(lbSections.Items[lbSections.ItemIndex - 1]); // change to previous section in the list
  EnableDisableEtc;
  ChangePageLabel;
end;

procedure TfrmDefaultSettings.btnNextClick(Sender: TObject);
begin
  ChangeSection(lbSections.Items[lbSections.ItemIndex + 1]); // change to the next section in the list
  EnableDisableEtc;
  ChangePageLabel;
end;

{* Message Handlers *}

procedure TfrmDefaultSettings.WMMoving(var msg: TMessage);
begin
  WindowMoving(msg, height, width);
end;

procedure TfrmDefaultSettings.FormKeyUp(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  if key = VK_ESCAPE then close;
end;

procedure TfrmDefaultSettings.mniPropertiesClick(Sender: TObject);
begin
  MLEditProperties(mlSettings, Self, nil);
end;

procedure TfrmDefaultSettings.mniSaveCoordinatesClick(Sender: TObject);
begin
  mniSaveCoordinates.Checked := not mniSaveCoordinates.Checked;
end;

initialization
  frmDefaultSettings := nil;

end.
