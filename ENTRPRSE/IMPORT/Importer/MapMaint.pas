unit MapMaint;

{******************************************************************************}
{*  MapMaint creates and edits Map files. A map file contains a list of which *}
{*  fields are present in a user-defined import file, in the order they appear*}
{*  in the user's import record.                                              *}
{*  MapMaint relies heavily on information stored within hidden columns in the*}
{*  multilists, the most important of which is the COL_FieldDef column which  *}
{*  contains the full field definition from Importer's main settings file,    *}
{*  from which all the other columns are populated.                           *}
{*  A command-line parameter of DEBUG can be useful when debugging MapMaint as*}
{*  it will make all columns in the MultiLists visible.                       *}
{*  12/2005: cbImportFileType and it's label are not visible. It is possible  *]
{*  to allow users to specify default values for selected fields of a standard*}
{*  import file. However, these types of files are considered to be legacy    *}
{*  and only backward support is currently implemented. If this changes, the  *}
{*  necessary code is already written here.                                   *}
{******************************************************************************}

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, uMultiList, ComCtrls, psvDialogs, BorBtns,
  Menus, SBSPanel;

type
  TfrmMapMaint = class(TForm)
    OpenDialog: TpsvOpenDialog;
    SaveDialog: TpsvSaveDialog;
    SaveCSVDialog: TpsvSaveDialog;
    Label1: TLabel;
    cbFieldDef: TComboBox;
    gbAvailableFields: TGroupBox;
    mlAvailableFields: TMultiList;
    GroupBox4: TGroupBox;
    pcFieldMap: TPageControl;
    tsSType: TTabSheet;
    mlSType: TMultiList;
    tsAType: TTabSheet;
    mlAType: TMultiList;
    tsFType: TTabSheet;
    mlFType: TMultiList;
    btnMoveFieldDefUp: TButton;
    btnMoveFieldDefDown: TButton;
    btnEditDefault: TButton;
    btnRemoveFieldDef: TButton;
    btnRemoveAllFieldDefs: TButton;
    btnSaveMapFile: TButton;
    btnSaveMapFileAs: TButton;
    btnClose: TButton;
    edtMsg: TEdit;
    btnSelectFieldDef: TButton;
    btnCreateUserDefFile: TButton;
    chbShowMandatory: TBorCheckEx;
    btnSelectAllFieldDefs: TButton;
    cbImportFileType: TComboBox;
    Label2: TLabel;
    AvailableFieldsPopupMenu: TPopupMenu;
    mniSelectFieldDef: TMenuItem;
    mniSelectAllFieldDefs: TMenuItem;
    FieldMapPopupMenu: TPopupMenu;
    mniEditDefault: TMenuItem;
    mniMoveFieldDefUp: TMenuItem;
    mniMoveFieldDefDown: TMenuItem;
    mniRemoveFieldDef: TMenuItem;
    mniRemoveAllFieldDefs: TMenuItem;
    mniCreateUserDefFile: TMenuItem;
    lblRTDescription: TLabel;
    N1: TMenuItem;
    mniProperties1: TMenuItem;
    mniSaveCoordinates1: TMenuItem;
    N2: TMenuItem;
    mniProperties2: TMenuItem;
    mniSaveCoordinates2: TMenuItem;
    GroupBox3: TGroupBox;
    lblOVRINS: TLabel;
    procedure FormCreate(Sender: TObject);
    procedure mlAvailableFieldsChangeSelection(Sender: TObject);
    procedure mlAvailableFieldsRowDblClick(Sender: TObject; RowIndex: Integer);
    procedure mlFTypeRowDblClick(Sender: TObject; RowIndex: Integer);
    procedure mlFTypeChangeSelection(Sender: TObject);
    procedure btnMoveFieldDefUpClick(Sender: TObject);
    procedure btnMoveFieldDefDownClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure btnLoadMapFileClick(Sender: TObject);
    procedure cbFieldDefChange(Sender: TObject);
    procedure xcbRecordTypeChange(Sender: TObject);
    procedure pcFieldMapChange(Sender: TObject);
    procedure btnDeSelectFieldDefClick(Sender: TObject);
    procedure btnSelectFieldDefClick(Sender: TObject);
    procedure mlATypeRowDblClick(Sender: TObject; RowIndex: Integer);
    procedure mlATypeChangeSelection(Sender: TObject);
    procedure mlSTypeChangeSelection(Sender: TObject);
    procedure btnEditDefaultClick(Sender: TObject);
    procedure btnSaveMapFileAsClick(Sender: TObject);
    procedure btnSaveMapFileClick(Sender: TObject);
    procedure btnRemoveFieldDefClick(Sender: TObject);
    procedure btnRemoveAllFieldDefsClick(Sender: TObject);
    procedure btnNewMapFileClick(Sender: TObject);
    procedure btnCreateUserDefFileClick(Sender: TObject);
    procedure btnCloseClick(Sender: TObject);
    procedure chbShowMandatoryClick(Sender: TObject);
    procedure FormKeyUp(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure btnSelectAllFieldDefsClick(Sender: TObject);
    procedure cbImportFileTypeChange(Sender: TObject);
    procedure mniProperties1Click(Sender: TObject);
    procedure mniSaveCoordinatesClick(Sender: TObject);
    procedure mniProperties2Click(Sender: TObject);
    procedure mlFTypeCellPaint(Sender: TObject; ColumnIndex,
      RowIndex: Integer; var OwnerText: String; var TextFont: TFont;
      var TextBrush: TBrush; var TextAlign: TAlignment);
    procedure mlATypeCellPaint(Sender: TObject; ColumnIndex,
      RowIndex: Integer; var OwnerText: String; var TextFont: TFont;
      var TextBrush: TBrush; var TextAlign: TAlignment);
    procedure mlSTypeCellPaint(Sender: TObject; ColumnIndex,
      RowIndex: Integer; var OwnerText: String; var TextFont: TFont;
      var TextBrush: TBrush; var TextAlign: TAlignment);
    procedure FormShow(Sender: TObject);
  protected
    constructor create(AOwner: TComponent); override;
  private
{* internal fields *}
    FAutoIncReset: array[1..9] of string[2];
    FComma: char;
    FCurrentAutoIncCounter: integer;
    FCurrentAutoIncResetRT: string;
    FDoubleClicking: boolean;
    FDataType: char;
    FDescriptions: TStringList;
    FFieldDef: string;
    FHelping: boolean;
    FIsDirty: boolean; // has the field map been changed ?
    FMainRecordType: string;
    FMapFile: string;
    FMapLoaded: boolean; // are we working on a previously-saved field map ?
    FAddFields: boolean;
    FRecordType: string;
    FFieldDefs: TStringList;
    FRecordTypes: TStringList;
    FHeaderRecs: TStringList;
    FDetailRecs: TStringList;
    FSaveCoordinates: boolean;
{* property fields *}
{* procedural methods *}
    procedure AddIgnoredField;
    procedure CalculateOffsets;
    procedure ChangeAvailableFields;
    procedure ChangeCaption;
    procedure ChangeHint(ML: TMultilist; edtMsg: TEdit);
    procedure ChangeOfFieldDef;
    procedure ChangeOfFileType;
    function  CheckAutoInc(ACurrentValue: string; Encode: boolean): string;
    procedure CheckForHeader;
    procedure CheckIfDirty;
    procedure DeSelectAllFieldDefs;
    procedure DeSelectFieldDef;
    procedure EditDefault;
    procedure EnableDisableEtc;
    function  FieldDefFromRT(ARecordType: string): string;
    function  FixedField(ML: TMultiList): boolean;
    procedure GetInsertKeyStatus;
    procedure InitDialogs;
    procedure LoadSTypes(ARecordType: string);
    procedure IsDirty;
    procedure LoadFieldDefs(ARecordType: string);
    procedure LoadMapFile(AMapFile: string);
    function  MandatoryField(ML: TMultiList): boolean;
    procedure MapStatus(AStatusMsg: string);
    procedure NewMapFile;
    procedure PopulateAutoIncReset(AAutoIncReset: TStringList);
    procedure PopulateFieldDefs;
    procedure PopulateRecordTypes;
    procedure ProcessFieldDefs(ML: TMultiList);
    procedure RemoveReadOnlyEtc;
    procedure RemoveUsedFields(mlAvailable, mlUsed: TMultiList);
    procedure ResortAvailableFields;
    procedure ResortSelectedFields;
    function  RTfromFDRT(FDRT: string): string;
    procedure SaveDefault(NewValue: string);
    procedure SaveMapFile(FileName: string);
    procedure SaveMapFileAs;
    procedure SaveUserDefFile(FileName: string);
    procedure SelectAllFieldDefs;
    procedure SelectDefaultFieldDefs(IncludeSelected: boolean);
    procedure SelectFieldDef;
    procedure SetSaveCoordinates(Checked: boolean);
    procedure ShowFieldDef(AFieldDef: string);
    procedure Startup;
    procedure SwitchFDList;
    function  UserDefFile: boolean;
{* Message Handlers *}
    procedure WMMoving(var msg: TMessage); message WM_MOVING;
  public
    destructor destroy; override;
    class procedure Show(ARecordType: string; AMapFile: string; OpenFieldMap: boolean);
  end;

implementation

uses uDBMColumns, GlobVar, Utils, TIniClass, GlobalConsts, GlobalTypes, EditBox, EntLicence;

const
  COL_FieldNo      = 0; // this column is hidden in all ML's
  COL_FieldDesc    = 1; // The user-friendly field name displayed to the user
  COL_FieldDefault = 2; // this column is hidden in mlAvailableFields and visible in mlSType, mlAType and mlFType
  COL_FieldDef     = 3; // this column is hidden in all ML's
  COL_FieldComment = 4; // this column is visible in all ML's
  COL_FieldUsage   = 5; // this column is hidden in all ML's

  SType_Page = 0;
  AType_Page = 1;
  FType_Page = 2;

var
  frmMapMaint: TfrmMapMaint;

{$R *.dfm}

class procedure TfrmMapMaint.Show(ARecordType: string; AMapFile: string; OpenFieldMap: boolean);
// Shows the MapMaint form.
// Can preload a given map file or the field defs of a given record type.
// If OpenFieldMap is true then an open dialog will be presented for the user
// to select an existing field map to work with.
// If a MapFile has been passed this will be loaded which also results in the
// FieldDefs being loaded (assuming the map file contains anything), so we only
// need to do one or the other.
// If both are blank, we preconfigure MapMaint to be editing a new map file.
begin
  if frmMapMaint = nil then
    frmMapMaint := TfrmMapMaint.Create(nil);

  if OpenFieldMap then
    if frmMapMaint.OpenDialog.Execute then
      frmMapmaint.LoadMapFile(frmMapMaint.OpenDialog.FileName)
    else begin
      frmMapMaint.Free;
      frmMapMaint := nil;
      exit;
    end
  else
    if AMapFile <> '' then
      frmMapMaint.LoadMapFile(AMapFile)
    else
      if ARecordType <> '' then begin
        FillChar(frmMapMaint.FAutoIncReset, length(frmMapMaint.FAutoIncReset), #0);
        frmMapMaint.LoadFieldDefs(ARecordType);
        frmMapMaint.ShowFieldDef(frmMapMaint.FieldDefFromRT(ARecordType) + ' (' + ARecordType + ')');
        frmMapMaint.CheckForHeader;
        frmMapMaint.SelectDefaultFieldDefs(true);
      end
      else
        frmMapMaint.NewMapFile;

//  frmMapMaint.Top := 25;
  frmMapMaint.WindowState := wsNormal;

// inherited Show
  frmMapMaint.visible := true;
  frmMapMaint.BringToFront;
end;

constructor TfrmMapMaint.create(AOwner: TComponent);
begin
  inherited;

//  SetConstraints(Constraints, height, width);
end;

destructor TfrmMapMaint.destroy;
begin
  if FSaveCoordinates then
    FormSaveSettings(Self, nil);
  FreeObjects([FFieldDefs, FRecordTypes, FHeaderRecs, FDetailRecs, FDescriptions]);
  inherited destroy;
end;

{* Procedural Methods *}

procedure TfrmMapMaint.AddIgnoredField;
// add an F000 "ignored field" entry to the list of available fields
// this field can be used multiple times by the user
var
  FD: TFieldDef;
  FieldDefInString: string;
begin
  if mlAvailableFields.ItemsCount = 0 then exit; // shouldn't ever happen

  FieldDefInString    := mlAvailableFields.DesignColumns[COL_FieldDef].Items[0]; // use the first FieldDef as a template
  IniFile.ReturnDataInFieldDef(FieldDefInString, FD); // convert to a TFieldDef

  FD.FieldNo    := '000'; // alter the Field Def
  FillChar(FD.FieldName, SizeOf(FD.FieldName), #32);
  move('Ignored Field', FD.FieldName[1], 13);
  FillChar(FD.Offset, SizeOf(FD.Offset), #32);
  FillChar(FD.Occurs, SizeOf(FD.Occurs), #32);
  FillChar(FD.FieldType, SizeOf(FD.FieldType), #32);
  FillChar(FD.FieldUsage, SizeOf(FD.FieldUsage), #32);
  FillChar(FD.FieldWidth, SizeOf(FD.FieldWidth), #32);
  FillChar(FD.FieldDesc, SizeOf(FD.FieldDesc), #32);
  move('Ignored Field', FD.FieldDesc[1], 13);
  FillChar(FD.FieldDefault, SizeOf(FD.FieldDefault), #32);
  FillChar(FD.FieldComment, SizeOf(FD.FieldComment), #32);
  move('Any data in this field will be ignored', FD.FieldComment[1], 38);

  mlAvailableFields.DesignColumns[COL_FieldDef].Items.Add(IniFile.ReturnFieldDefInString(FD));// Add the amended Field Def
  mlAvailableFields.DesignColumns[COL_FieldNo].items.add(FD.FieldDefType + FD.FieldNo);
  mlAvailableFields.DesignColumns[COL_FieldDefault].Items.Add(FD.FieldDefault);
  mlAvailableFields.DesignColumns[COL_FieldComment].Items.Add(FD.FieldComment);
  mlAvailableFields.DesignColumns[COL_FieldDesc].Items.add(FD.FieldDesc);
  mlAvailableFields.DesignColumns[COL_FieldUsage].Items.add('X');
end;

procedure TfrmMapMaint.ChangeAvailableFields;
// changes which Exchequer record is displayed in mlAvailableFields.
// This depends on what is being displayed in the Field Map area.
//
// We don't change anything if the user is looking at the SType fields as these
// are fixed. Strictly speaking, we could/should clear the Available Fields
// and deselect anything show in the Field Def drop down list - but this could
// be annoying if they've just selected their desired record type and had a quick
// shufty at the system fields on the Mandatory tab.
var
  FieldDef: TFieldDef;
  RT: string;
begin
  if cbFieldDef.ItemIndex = -1 then
    mlAvailableFields.ClearItems; // this can happen when we switch to the header tab
                                  // and the tsAType contains no selected fields. We can
                                  // end up with the detail record fields still displayed.

  case pcFieldMap.ActivePageIndex of
    FType_Page: begin
                  if mlFType.ItemsCount = 0 then exit; // no FTypes so exit
                  IniFile.ReturnDataInFieldDef(mlFType.DesignColumns[COL_FieldDef].Items[0], FieldDef); // get Record Type from first line
                  RT := FieldDef.RecordType;
                  LoadFieldDefs(RT);  // display all the fields in the Exchequer record
                  RemoveUsedFields(mlAvailableFields, mlFType); // remove what's already been used
                  ShowFieldDef(tsFType.Caption); // change the drop down list to match the Record Type
                end;
    AType_Page: begin
                  if mlAType.ItemsCount = 0 then exit; // no FTypes so exit
                  IniFile.ReturnDataInFieldDef(mlAType.DesignColumns[COL_FieldDef].Items[0], FieldDef); // get Record Type from first line
                  RT := FieldDef.RecordType;
                  LoadFieldDefs(RT); // display all the fields in the Exchequer record
                  RemoveUsedFields(mlAvailableFields, mlAType); // remove what's already been used
                  ShowFieldDef(tsAType.Caption); // change the drop down list to match the Record Type
                end;
  end;
end;

procedure TfrmMapMaint.ChangeOfFieldDef;
// change cbRecordType to show the Record Type of the selected Field Def
// We only do this if we're looking at the F-Type fields. For Auto Gen
// fields the user can select any combination.
// Load the Field Defs of the selected Exchequer record
var
  RT: string;
  FD: string;
begin
  try
    cbFieldDef.Enabled := false; // stop EPOD from flicking his mouse-wheel while we're still populating mlAvailable fields.
    RT := copy(cbFieldDef.Text, pos(' (', cbFieldDef.Text) + 2, 2);
    FD := copy(cbFieldDef.Text, 1, pos(' (', cbFieldDef.Text) - 1);
    lblRTDescription.caption := FDescriptions.Values[RT]; // select the description for the RT
  //  if pcFieldMap.ActivePage = tsFType then
  //    if cbRecordType.Enabled then
  //      ShowRecordType(RT); // only change if the user can
  //  LoadFieldDefs(FFieldDefs.Values[cbFieldDef.Text]);
    LoadFieldDefs(FFieldDefs.Values[FD]); // don't use RT, we want the std record type here:- see [Field Defs] in main settings file.
    CheckForHeader;
  finally
    cbFieldDef.Enabled := true;
  end;
  EnableDisableEtc; // *** NEW
end;

procedure TfrmMapMaint.ChangeCaption;
var
  s: string;
begin
  if FIsDirty then s := '*';
  Caption := format('Field Maps - [%s]%s', [ExtractFileName(FMapFile), s]);

  if InAdminMode then
    Caption := Caption + '^';

  if FIsDirty then
    btnClose.Caption := 'Cancel'
  else
    btnClose.Caption := 'Close';
end;

procedure TfrmMapMaint.ChangeHint(ML: TMultilist; edtMsg: TEdit);
// Originally, FieldComment was displayed in edtMsg when they changed selection
// in an ML. FieldComment is now permanently on display in each ML.
// So at the moment all this section does is ensure that edtMsg gets cleared
// when its contents are out of date.
begin
  edtMsg.Text := '';
//  if ML.selected = -1 then exit;
//  if ML.ItemsCount = 0 then exit;

//  edtMsg.Text := ML.DesignColumns[COL_FieldComment].Items[ML.Selected];
//  ML.Hint     := ML.DesignColumns[COL_FieldComment].Items[ML.Selected];
end;

procedure TfrmMapMaint.ChangeOfFileType;
// Changing the type of file that the map is being generated for has all sorts
// of implications (ok, two) about the order of the field defs in the resultant
// map file and which buttons get enabled.
// If the user tries to change file types after they've already selected fields
// they get asked if they want to clear their current selections.
// If we don't do this they can start moving fields around for Std Import
// files. Hmmm, actually this would only have been a problem for the old Import
// Module.........discuss.
var
  MsgTxt: string;
begin

{* Leave as is for now pending discussion *}
  EnableDisableEtc;
  EXIT;


  if (mlAType.ItemsCount > 0) or (mlAType.ItemsCount > 0) then begin
  MsgTxt := 'You have already selected some fields.'#13#10'Changing the type of file for this field map '#13#10'will result in your selections being cleared.'#13#10#13#10'Is it OK to do this ?';
  if MessageDlg(MsgTxt, mtWarning, [mbYes, mbNo], 0) = mrYes then begin
  // deselect all the fields from mlAType and mlFType
  end
  else
  // set the combo box back to what it was before they changed it.
  end;
end;

function TfrmMapMaint.CheckAutoInc(ACurrentValue: string; Encode: boolean): string;
// when editing [AutoIncx] values, the current value gets passed to EditBox as
// [AutoIncx]RT where RT is the Record Type which resets counter x (see AutoInc.pas)
// If Encode parameter is true a value ready to be passed to EditBox is created,
// otherwise we're separating out a value returned from EditBox.
var
  Counter: integer;
begin
  result := ACurrentValue;
  if length(ACurrentValue) = 0 then exit;
  if not AutoIncCounter(ACurrentValue) then exit; // it's not an AutoInc counter

  Counter := StrToInt(copy(ACurrentValue, 9, 1));// get the counter digit which precedes the closing bracket

  if Encode then begin
    FCurrentAutoIncCounter := Counter;
    FCurrentAutoIncResetRT := FAutoIncReset[Counter]; // remember the current reset Record Type for this counter
    result := result + FCurrentAutoIncResetRT;               // append the record type
  end
  else begin
    FAutoIncReset[Counter] := copy(ACurrentValue, 11, 2); // set the autoinc array for the record type, sets to '' if no RT attached
    result := copy(ACurrentValue, 1, 10);                        // strip off the RT from [AutoIncx]RT
  end;
end;

procedure TfrmMapMaint.CheckForHeader;
// Checks whether the selected detail record type has an associated header
// record type. If it does then the tsAType tabsheet can be displayed.
// The main settings file contains a [Headers] section which at the time of
// writing contains one entry: OL=TH. This means that the OL detail record type
// which is a special type of TL record
// has an associated header record type of TH, meaning they can define a TH
// record and an OL record on the same import record. This keeps the relationship
// between transaction lines and headers out of the code and in the settings file.
// Future amendments to the meta-data might allow employees and timesheets to be
// created in one import record, or Job Costing and Job Analysis records etc.
var
  RT: string;
begin
  case pcFieldMap.ActivePageIndex of
    FType_Page: begin
                  RT := RTfromFDRT(cbFieldDef.Text);
                  tsAType.TabVisible := IniFile.ReadString(HEADERS, RT, '') <> '';
                end;
  end;
end;

procedure TfrmMapMaint.CheckIfDirty;
// has the Field Map been amended ?
begin
  if FIsDirty then
    if (MessageDlg('Do you want to save your changes ?', mtConfirmation, [mbYes, mbNo], 0) = mrYes) then
      if FMapLoaded then
        SaveMapFile(FMapFile)
      else
        SaveMapFileAs;
end;

procedure TfrmMapMaint.DeSelectAllFieldDefs;
// move all selected fields from the visible ML back into the list of
// available fields.
var
  ML: TMultiList;
  col, row: integer;
begin
  ML := nil;
  case pcFieldMap.ActivePageIndex of
    SType_Page:  exit; // can't alter SType field Defs
    AType_Page:  ML := mlAType;
    FType_Page:  ML := mlFType;
  end;
  for row := ML.ItemsCount - 1 downto 0 do begin // do it backwards coz we're deleting rows as we go
    if ML.DesignColumns[COL_FieldNo].Items[row] <> 'F000' then // Ignored Field doesn't get removed from mlAvailableFields
      for col := 0 to mlAvailableFields.Columns.Count - 1 do
        mlAvailableFields.DesignColumns[col].Items.Add(ML.DesignColumns[col].Items[row]);
    MLDeleteRow(ML, row);
  end;
  ResortAvailableFields;
  IsDirty;
end;

procedure TfrmMapMaint.DeSelectFieldDef;
// move a row from SelectedFields to AvailableFields
// If they've edited the default value, this will also get copied back and
// will still be set if they reselect the field.
var
  ML: TMultiList;
  i: integer;
begin
  ML := nil;
  case pcFieldMap.ActivePageIndex of
    SType_Page:  exit; // can't alter SType field Defs
    AType_Page:  begin
                   ML := mlAType;
                 end;
    FType_Page:  begin
                   ML := mlFType;
                 end;
  end;
  if ML.Selected = -1 then exit;
  if ML.DesignColumns[COL_FieldNo].Items[ML.Selected] <> 'F000' then // only want one copy of F000 in Available Fields
    for i := 0 to mlAvailableFields.Columns.Count - 1 do
      mlAvailableFields.DesignColumns[i].Items.Add(ML.DesignColumns[i].Items[ML.Selected]);
  MLDeleteSelectedRow(ML);
  ChangeHint(ML, edtMsg);
  ResortAvailableFields;
  IsDirty;
end;

procedure TfrmMapMaint.EditDefault;
// Pass the current default value, if any, to TfrmEditBox together with all
// sorts of details about what type of value is being edited etc and display
// the EditBox form.
// The amended value is returned in NewValue
var
  FieldDef: TFieldDef;
  NewValue: string;
  RTs: TStrings;
  CurrentValue: string;
begin
  case pcFieldMap.ActivePageIndex of
    AType_Page:  begin
                    if mlAType.Selected = -1 then exit;
                    if mlAType.DesignColumns[COL_FieldNo].Items[mlAType.Selected] = 'F000' then begin
                      edtMsg.Text := 'You cannot edit the default value of an ignored field';
                      exit;
                    end;
                    if FixedField(mlAType) then begin
                      edtMsg.Text := 'You cannot edit the default value of a fixed field';
                      exit;
                    end;
                    IniFile.ReturnDataInFieldDef(mlAType.DesignColumns[COL_FieldDef].Items[mlAType.Selected], FieldDef);
                    FDataType := FieldDef.FieldType;
                    if (FDataType = 'L') or (FDataType = 'I') or (FDataType = 'D') then // if editing a numeric field supply AutoInc tab with Record Types
                      RTs := cbFieldDef.Items
                    else
                      RTs := nil;
                    CurrentValue := CheckAutoInc(trim(mlAType.DesignColumns[COL_FieldDefault].Items[mlAType.Selected]), true);
                    if TfrmEditBox.Show('',                                                      {Ini Section}
                                        mlAType.DesignColumns[COL_FieldDesc].Items[mlAType.Selected], {Setting Name}
                                        FDataType,                                                        {DataType}
                                        FieldWidth(FieldDef.FieldType, StrToInt(FieldDef.FieldWidth)),    {max length}
                                        DataTypeDescription(FDataType),                                   {DataType Caption}
                                        '',                                                               {Caption}
                                        trim(mlAType.DesignColumns[COL_FieldComment].Items[mlAType.Selected]), {msg/prompt/hint}
                                        CurrentValue,   {Current Value}
                                        nil, nil, RTs, false,
                                        NewValue) then
                      SaveDefault(NewValue);
                 end;
    FType_Page:  begin
                    if mlFType.Selected = -1 then exit;
                    if mlFType.DesignColumns[COL_FieldNo].Items[mlFType.Selected] = 'F000' then  begin
                      edtMsg.Text := 'You cannot edit the default value of an ignored field';
                      exit;
                    end;
                    if FixedField(mlFType) then begin
                      edtMsg.Text := 'You cannot edit the default value of a fixed field';
                      exit;
                    end;
                    IniFile.ReturnDataInFieldDef(mlFType.DesignColumns[COL_FieldDef].Items[mlFType.Selected], FieldDef);
                    FDataType := FieldDef.FieldType;
                    if (FDataType = 'L') or (FDataType = 'I') or (FDataType = 'D') then // if editing a numeric field supply AutoInc tab with Record Types
                      RTs := cbFieldDef.Items
                    else
                      RTs := nil;
                    CurrentValue := CheckAutoInc(trim(mlFType.DesignColumns[COL_FieldDefault].Items[mlFType.Selected]), true);
                    if TfrmEditBox.Show('',                                                           {Ini Section}
                                        mlFType.DesignColumns[COL_FieldDesc].Items[mlFType.Selected], {Setting Name}
                                        FDataType,                                                        {Data Type}
                                        FieldWidth(FieldDef.FieldType, StrToInt(FieldDef.FieldWidth)),    {max length}
                                        DataTypeDescription(FDataType),                                   {DataType Caption}
                                        '',                                                               {Caption}
                                        trim(mlFType.DesignColumns[COL_FieldComment].Items[mlFType.Selected]), {msg/prompt/hint}
                                        CurrentValue,   {Current Value}
                                        nil, nil, RTs, false,
                                        NewValue) then
                      SaveDefault(NewValue);
                 end;
  end;
end;

procedure TfrmMapMaint.EnableDisableEtc;
// determine which controls are enabled and disabled depending on what's changed
begin
  tsSType.TabVisible := chbShowMandatory.Checked;

  case pcFieldMap.ActivePageIndex of
    SType_Page:  begin
                    btnRemoveFieldDef.Enabled     := false;
                    btnRemoveAllFieldDefs.Enabled := false;
                    btnEditDefault.Enabled        := false;
                    btnSelectFieldDef.Enabled     := false;
                    btnMoveFieldDefUp.Enabled     := false;
                    btnMoveFieldDefDown.Enabled   := false;
                    cbFieldDef.Enabled            := false;
                 end;
    AType_Page:  begin

{* once they've committed themselves to a Record Type, they can't change it without deleting all the
   selected fields. This prevents them from selecting fields from multiple record types *}
                   cbFieldDef.Enabled            := mlAType.ItemsCount = 0;
                   btnEditDefault.Enabled        := (mlAType.ItemsCount <> 0) and not FixedField(mlAType);
                   btnMoveFieldDefUp.Enabled     := (mlAType.ItemsCount <> 0) and (mlAType.Selected > 0) and UserDefFile;
                   btnMoveFieldDefDown.Enabled   := (mlAType.ItemsCount <> 0) and (mlAType.Selected <> -1) and (mlAType.Selected <> mlAType.ItemsCount - 1) and UserDefFile;
                   btnRemoveFieldDef.Enabled     := (mlAType.ItemsCount <> 0) and not MandatoryField(mlAType) and UserDefFile;
                   btnRemoveAllFieldDefs.Enabled := mlAType.ItemsCount <> 0;
                   if mlAType.ItemsCount = 0 then
                     pcFieldMap.ActivePage.Caption := 'Header Record';
                 end;
    FType_Page:  begin

{* once they've committed themselves to a Record Type, they can't change it without deleting all the
   selected fields. This prevents them from selecting fields from multiple record types *}
                   cbFieldDef.Enabled            := mlFType.ItemsCount = 0;
                   btnEditDefault.Enabled        := (mlFType.ItemsCount <> 0) and not FixedField(mlFType);
                   btnMoveFieldDefUp.Enabled     := (mlFType.ItemsCount <> 0) and (mlFType.Selected > 0) and UserDefFile;
                   btnMoveFieldDefDown.Enabled   := (mlFType.ItemsCount <> 0) and (mlFType.Selected <> -1) and (mlFType.Selected <> mlFType.ItemsCount - 1) and UserDefFile;
                   btnRemoveFieldDef.Enabled     := (mlFType.ItemsCount <> 0) and not MandatoryField(mlFType) and UserDefFile;
                   btnRemoveAllFieldDefs.Enabled := mlFType.ItemsCount <> 0;
                   if mlFType.ItemsCount = 0 then
                     pcFieldMap.ActivePage.Caption := 'Detail Record';
                 end;
  end;

  btnCreateUserDefFile.Enabled  := (mlSType.ItemsCount <> 0) or (mlAType.ItemsCount <> 0) or (mlFType.ItemsCount <> 0);
  btnSelectFieldDef.Enabled     := (pcFieldMap.ActivePageIndex <> SType_Page) and  (mlAvailableFields.ItemsCount <> 0) and (mlAvailableFields.Selected <> -1) and UserDefFile;
  btnSelectAllFieldDefs.Enabled := (pcFieldMap.ActivePageIndex <> SType_Page) and  (mlAvailableFields.ItemsCount > 1);
  btnSaveMapFile.Enabled        := FIsDirty and FMapLoaded;
  btnSaveMapFileAs.Enabled      := FIsDirty;

  mniSelectFieldDef.Enabled     := btnSelectFieldDef.Enabled; // AvailableFieldsPopupMenu
  mniSelectAllFieldDefs.Enabled := btnSelectAllFieldDefs.Enabled;

  mniRemoveFieldDef.Enabled     := btnRemoveFieldDef.Enabled; // FieldMapPopupMenu
  mniRemoveAllFieldDefs.Enabled := btnRemoveAllFieldDefs.Enabled;
  mniEditDefault.Enabled        := btnEditDefault.Enabled;
  mniMoveFieldDefUp.Enabled     := btnMoveFieldDefUp.Enabled;
  mniMoveFieldDefDown.Enabled   := btnMoveFieldDefDown.Enabled;
  mniCreateUserDefFile.Enabled  := btnCreateUserDefFile.Enabled;

  chbShowMandatory.Enabled      := (mlAType.ItemsCount <> 0) or (mlFType.ItemsCount <> 0);
  chbShowMandatory.Invalidate;
end;

function TfrmMapMaint.FieldDefFromRT(ARecordType: string): string;
// Returns the name of the Exchequer record Field Def from the 2-char Record Type
// e.g. CU returns Customer
begin
  result := FRecordTypes.Values[ARecordType];
end;

function TfrmMapMaint.FixedField(ML: TMultiList): boolean;
// determines whether the selected row in a TMultiList contains a Fixed Field Def,
// which means the default value cannot be altered.
var
  FieldDef: TFieldDef;
begin
  result := false;
  if ML.Selected = -1 then exit;

  IniFile.ReturnDataInFieldDef(ML.DesignColumns[COL_FieldDef].Items[ML.Selected], FieldDef);
  result := (FieldDef.FieldUsage = 'F');
end;

procedure TfrmMapMaint.GetInsertKeyStatus;
// is the Insert key toggled on or off ?
begin
  FAddFields := not Odd(GetKeyState(VK_INSERT));
  if FAddFields then
    lblOVRINS.caption := 'ADD'
  else
    lblOVRINS.Caption := 'INS';
end;

procedure TfrmMapMaint.LoadFieldDefs(ARecordType: string);
// Loads the field descriptions (the user-friendly field names) of the required Exchequer record
// into the ML of Available Fields
// For any repeating field, e.g. "Address Line [*]", the field is added multiple (i.e. "occurs") times
// with the [asterisk] replaced by the occurrence. E.g. "Address Line [1]", "Address Line [2]" etc.
// If the brackets don't contain an asterisk then they contain the name of an INI section which contains
// the label for each occurrence. For example, "VAT Analysis Rate [VATAC]" states that instead of
// displaying "VAT Analysis Rate [1]" to "VAT Analysis Rate [21]", the VATAC ini file section contains
// 21 values (ie. 'S', 'E', 'Z' etc) so that "VAT Analysis Rate [S]", "VAT Analysis Rate [E]" will be displayed.
var
  i, j: integer;
  occurs: integer;
  PosLBracket: integer;
  PosRBracket: integer;
  IniSection: string;
  FieldDesc: string;
  FieldDescPlus: string;
  NewFieldDesc: string;
  RecordDefs:     TStringList;
  SectionValues:  TStringList;
  FD: TFieldDef;
begin
  FRecordType := ARecordType; // save the 2-char Record Type
  ARecordType := FieldDefFromRT(ARecordType); // change it to the full Exchequer record name
  FFieldDef   := ARecordType;
  mlAvailableFields.ClearItems;
  if ARecordType = '' then exit;
  RecordDefs     := TStringList.create;
  try
  IniFile.ReturnValuesInList(ARecordType, RecordDefs); // Read the whole section
  for i := 0 to RecordDefs.Count - 1 do begin
    IniFile.ReturnDataInFieldDef(RecordDefs[i], FD);                   // Load into the TIniRecord structure
//   if IniFile.fdNotUsed or IniFile.fdReadOnly then continue;// don't display to the user - DO IT LATER
    if trim(FD.Occurs) = '' then           // determine how many occurrences
      occurs := 1                           // blank means 1 occurrence
    else
      occurs := StrToInt(FD.Occurs);
    if occurs = 1 then begin                       // for one occurrence...
      mlAvailableFields.DesignColumns[COL_FieldNo].items.add(FD.FieldDefType + FD.FieldNo); // Add the field no. to the ML
      mlAvailableFields.DesignColumns[COL_FieldDefault].Items.Add(FD.FieldDefault);       // Add the default value to the ML
      mlAvailableFields.DesignColumns[COL_FieldComment].Items.Add(FD.FieldComment);       // Add the comment to the ML
      mlAvailableFields.DesignColumns[COL_FieldDef].Items.Add(IniFile.ReturnFieldDefInString(FD));  // Add the full Field Def
      mlAvailableFields.DesignColumns[COL_FieldDesc].Items.add(FD.FieldDesc); // just add the Field Desc to the ML asis.
      mlAvailableFields.DesignColumns[COL_FieldUsage].Items.add(FD.FieldUsage);
    end
    else begin                               // if there's more than one occurrence...
      FD.Occurs := '  ';              // don't want this in the map file
      FieldDesc   := FD.FieldDesc;    // take a copy of the field desc
      PosLBracket := pos('[', FieldDesc);    // find the [
      PosRBracket := pos(']', FieldDesc);    // find the ]
      IniSection  := copy(FieldDesc, PosLBracket + 1, (PosRBracket - PosLBracket) - 1); // what's in between them ?
      Delete(FieldDesc, PosLBracket, (length(FieldDesc) - PosLBracket) + 1); // delete from [ to the end
      SectionValues := nil;
      if IniSection <> '*' then begin
        SectionValues := TStringList.create;
        IniFile.ReturnValuesInList(IniSection, SectionValues);
      end;
      for j := 1 to occurs do begin      // for each occurrence...
        mlAvailableFields.DesignColumns[COL_FieldNo].items.add(FD.FieldDefType + FD.FieldNo); // Add the field no. to the ML
        mlAvailableFields.DesignColumns[COL_FieldDefault].Items.Add(FD.FieldDefault);       // Add the default value to the ML
        mlAvailableFields.DesignColumns[COL_FieldComment].Items.Add(FD.FieldComment);       // Add the comment to the ML
        mlAvailableFields.DesignColumns[COL_FieldUsage].Items.Add(FD.FieldUsage);
        if IniSection = '*' then
          FieldDescPlus := FieldDesc + '[' + IntToStr(j) + ']' // replace the * with the occurrence number...
        else
          FieldDescPlus := FieldDesc + '[' + SectionValues.Values[IntToStr(j)] + ']'; // or the occurrence label
//        NewFieldDesc := FieldDesc + '[' + IntToStr(j) + ']';
        NewFieldDesc := FieldDescPlus;
        FillChar(FD.FieldDesc[1], SizeOf(FD.FieldDesc), #32);
        Move(NewFieldDesc[1], FD.FieldDesc[1], Length(NewFieldDesc));  // modify the TFieldDef in memory
        mlAvailableFields.DesignColumns[COL_FieldDef].Items.Add(IniFile.ReturnFieldDefInString(FD));  // Add the full Field Def
        mlAvailableFields.DesignColumns[COL_FieldDesc].Items.add(FieldDescPlus); // add the Field Desc to the ML
      end;
      FreeObjects([SectionValues]);
    end;
  end;
  finally
    RecordDefs.Free;
  end;

  AddIgnoredField;

  if mlAvailableFields.ItemsCount > 0 then
    mlAvailableFields.Selected := 0;

  gbAvailableFields.Caption := 'Available Fields for ' + ARecordType;

  CalculateOffsets; // Must be done before we start removing lines
  RemoveReadOnlyEtc;
  ResortAvailableFields;
  EnableDisableEtc;
end;

procedure TfrmMapMaint.LoadSTypes(ARecordType: string);
// populate mlSType with the field defs from the main settings file for the
// given Record Type
var
  STypes: TStringList;
begin
  STypes := TStringList.Create;
  mlSType.ClearItems;
  try
    IniFile.ReturnValuesInList(ARecordType, STypes);        // get the S-Type fields for RT from main settings file
    mlSType.DesignColumns[COL_FieldDef].Items.AddStrings(STypes);
  finally
    STypes.free;
  end;
  ProcessFieldDefs(mlSType); // populate the other columns from the field defs
end;

procedure TfrmMapMaint.InitDialogs;
// setup the various open and save dialogs with appropriate filters, initial
// folders and default file extensions etc.
var
  DefMapExt: string;
  DefUserDefExt: string;
begin
  OpenDialog.InitialDir := IniFile.ReadString(SYSTEM_SETTINGS, 'MAP Folder', '');
  SaveDialog.InitialDir := OpenDialog.InitialDir;
  DefMapExt             := IniFile.ReadString(SYSTEM_SETTINGS, 'MAP Ext', 'MAP');
  OpenDialog.DefaultExt := DefMapExt;
  SaveDialog.DefaultExt := DefMapExt;
  OpenDialog.Filter     := format('Field Maps (*.%s)|*.%0:s|All Files (*.*)|*.*', [DefMapExt]);
  SaveDialog.Filter     := OpenDialog.Filter;

  SaveCSVDialog.InitialDir := IniFile.ReadString(SYSTEM_SETTINGS, 'Import Folder', '');
  DefUserDefExt            := IniFile.ReadString(SYSTEM_SETTINGS, 'UserDef Ext', 'CSV');
  SaveCSVDialog.Filter     := format('User Defined Files (*.%s)|*.%0:s|All Files (*.*)|*.*', [DefUserDefExt]);
  SaveCSVDialog.DefaultExt := DefUserDefExt;
end;

procedure TfrmMapMaint.IsDirty;
// the map has been altered.
begin
  FIsDirty := true;
  ChangeCaption;
  EnableDisableEtc;
end;

procedure TfrmMapMaint.LoadMapFile(AMapFile: string);
// Load the contents of the map file into the three ML's: mlSType, mlAType, mlFType.
// The map file is in TIniFile format but may contain duplicate key names.
// Because of this we can't read it using the standard API which would always return
// the first duplicate key.
// We therefore need to read the whole file into a StringList.
var
  MapFile: TStringList;
  STypes: TStringList;
  AutoGenSection: TStringList;
  FieldDef: TFieldDef;
  AutoIncResetSection: TStringList;
  MS: TMemoryStream;
  SwappedFields: boolean;
begin
  if not FileExists(AMapFile) then begin
    MapStatus(format('Map File "%s" does not exist', [AMapFile]));
    EnableDisableEtc;
    exit;
  end;

  FMapFile       := AMapFile;  // for the form caption in ChangeCaption
  MapFile        := TStringList.Create;
  AutoGenSection := TStringList.Create;
  STypes         := TStringList.create;
  AutoIncResetSection := TStringList.create;

  FillChar(frmMapMaint.FAutoIncReset, length(frmMapMaint.FAutoIncReset), #0);

  try
    MS := IniFile.DecryptIniFile(AMapFile, true); // decrypt the file to the stream
    if MS <> nil then begin
      MapFile.LoadFromStream(MS); MS.free; end;
    if MapFile.Count = 0 then begin
      MapStatus(format('Map File "%s" is empty', [AMapFile]));
      exit;
    end;
    FMainRecordType := copy(MapFile[0], 2, 2);                  // first record should always be [RT]
    AutoGenSection.Assign(MapFile);                             // take a copy of all the lines in MapFile
    AutoIncResetSection.Assign(MapFile);                        // ditto
    IsolateIniSection(MapFile, FMainRecordType);                // remove everything except the [RT] section's lines
    IsolateIniSection(AutoGenSection, 'Auto' + FMainRecordType);// remove everything except the [AutoRT] section's lines
    IsolateIniSection(AutoIncResetSection, 'AutoIncReset');     // remove everything except the [AutoIncReset] section's lines
    IniFile.ReturnValuesInList(FMainRecordType, STypes);        // get the S-Type fields for RT from main settings file

     // v.075 swap old fields for their new replacements
    SwappedFields := SwapFields(STypes) or SwapFields(MapFile) or SwapFields(AutoGenSection); // v.076

    mlSType.ClearItems;
    mlAType.ClearItems;
    mlFType.ClearItems;
    mlSType.DesignColumns[COL_FieldDef].Items.AddStrings(STypes);
    mlAType.DesignColumns[COL_FieldDef].Items.AddStrings(AutoGenSection);
    mlFType.DesignColumns[COL_FieldDef].Items.AddStrings(MapFile);
    PopulateAutoIncReset(AutoIncResetSection);
  finally
    MapFile.free;
    AutoGenSection.free;
    STypes.Free;
    AutoIncResetSection.Free;
  end;
  ProcessFieldDefs(mlSType);
  ProcessFieldDefs(mlAType);
  ProcessFieldDefs(mlFType);
  ChangeAvailableFields;
  ShowFieldDef(FieldDefFromRT(FMainRecordType) + ' (' + FMainRecordType + ')');
  CheckForHeader;

  if mlAType.ItemsCount <> 0 then begin // display the Exchequer record type in the tab captions
    IniFile.ReturnDataInFieldDef(mlAType.DesignColumns[COL_FieldDef].Items[0], FieldDef);
    tsAType.Caption := FieldDefFromRT(FieldDef.RecordType) + ' (' + FieldDef.RecordType + ')';
  end;
  if mlFType.ItemsCount <> 0 then begin
// 07/12/2005
//    IniFile.ReturnDataInFieldDef(mlFType.DesignColumns[COL_FieldDef].Items[0], FieldDef);
//    tsFType.Caption := FieldDefFromRT(FieldDef.RecordType) + ' (' + FieldDef.RecordType + ')';
    tsFType.Caption := FieldDefFromRT(FMainRecordType) + ' (' + FMainRecordType + ')';
  end;

  FIsDirty   := SwappedFields; // v.075
  FMapLoaded := true;
  EnableDisableEtc;
  ChangeCaption;
end;

function TfrmMapMaint.MandatoryField(ML: TMultiList): boolean;
// determines whether the selected row in a TMultiList contains a mandatory Field Def.
// Such Field Defs will either be [F]ixed, [M]andatory or a sort field (0-9)
var
  FieldDef: TFieldDef;
begin
  result := false;
  if ML.Selected = -1 then exit;

  IniFile.ReturnDataInFieldDef(ML.DesignColumns[COL_FieldDef].Items[ML.Selected], FieldDef);
  result := FieldDef.FieldUsage in ['F', 'M', '0'..'9'];
end;

procedure TfrmMapMaint.MapStatus(AStatusMsg: string);
// display the status message in the read-only edit box
begin
  edtMsg.Text := AStatusMsg;
//  case pcFieldMap.ActivePageIndex of
//    SType_Page:  edtSTypeMsg.Text := AStatusMsg;
//    AType_Page:  edtATypeMsg.Text := AStatusMsg;
//    FType_Page:  edtFTypeMsg.Text := AStatusMsg;
//  end;
end;

procedure TfrmMapMaint.NewMapFile;
// setup for a brand-new field map
begin
  FMapFile := '<New Field Map>';
  mlAvailableFields.ClearItems;
  mlSType.ClearItems;
  mlAType.ClearItems;
  mlFType.ClearItems;
  FillChar(FAutoIncReset, length(FAutoIncReset), #0);
//  cbRecordType.ItemIndex := -1;
  cbFieldDef.ItemIndex   := -1;
  FIsDirty   := false;
  FMapLoaded := false;
  ChangeCaption;
  EnableDisableEtc;
end;

procedure TfrmMapMaint.PopulateAutoIncReset(AAutoIncReset: TStringList);
// The stringlist contains all the AutoIncx=RT values from the [AutoIncReset]
// section of the map file.
// This procedure reads the value and populates the FAutoIncReset array.
var
  counter: integer;
  i: integer;
begin
  for i := 0 to AAutoIncReset.Count - 1 do begin
    counter := StrToInt(copy(AAutoIncReset[i], 8, 1)); // find which counter this item is for
    FAutoIncReset[counter] := AAutoIncReset.Values[AAutoIncReset.Names[i]]; // set the record type for this counter
  end;
end;

procedure TfrmMapMaint.PopulateFieldDefs;
// populate the drop down list of Exchequer Records, e.g. Customer.
// It doesn't now: it just gets the list from the main settings file.
// The drop down is now populated in PopulateRecordTypes.
//var
//  i: integer;
//  PosSC: integer;
begin
  IniFile.ReturnValuesInList(FIELD_DEFS, FFieldDefs);
//  cbFieldDef.Clear;
//  for i := 0 to FFieldDefs.Count - 1 do begin
//    PosSC := pos(';', FFieldDefs[i]); // any comment present ?
//    if PosSC > 0 then
//      FFieldDefs[i] := trim(copy(FFieldDefs[i], 1, PosSC - 1));  // chop off any comment
//    if pos('=Yes', FFieldDefs[i]) = 0 then // ignore entries which don't point back to an Exchequer record type
//      cbFieldDef.Items.Add(FFieldDefs.Names[i]);

//  end;
  FFieldDefs.sorted := true;
//  cbFieldDef.Sorted := true;
end;

procedure TfrmMapMaint.PopulateRecordTypes;
// populate the drop down list of Record Types, e.g. TH, TL
// The [RecordTypes] section in the main settings file contains RT=Record Type
// combinations. We keep this list as it's useful for translating between the
// two elsewhere.
// Also now populates cbFieldDef.
// 2006/07/17: inclusion of a record type in the drop down is now dependent on
// whether we're running in an Exchequer or LITE (IOA) environment.
// If LITE, then we lookup up each record type in the [IAO Recs] section to see
// if we should include it.
var
  i: integer;
  PosSC: integer;
begin
  IniFile.ReturnValuesInList(RECORD_TYPES, FRecordTypes);

  for i := 0 to FRecordTypes.Count - 1 do begin
    PosSC := pos(';', FRecordTypes[i]);
    if PosSC > 0 then
      FRecordTypes[i] := trim(copy(FRecordTypes[i], 1, PosSC - 1)); // chop off any comment

    if EnterpriseLicence.IsLITE and
      (IniFile.ReadString(IAO_RECS, FRecordTypes.Values[FRecordTypes.Names[i]], 'No') = 'No') then
        continue; // ignore any non-IAO recs if this

{* Find out which Record Types can be used as Header Records and which are Detail Records *}
    if IniFile.ReadString(HEADER_RECS, FRecordTypes.Names[i], '') <> '' then
      FHeaderRecs.Add(FRecordTypes.Values[FRecordTypes.Names[i]] + ' (' + FRecordTypes.Names[i] + ')');
    if IniFile.ReadString(DETAIL_RECS, FRecordTypes.Names[i], '') <> '' then
      FDetailRecs.add(FRecordTypes.Values[FRecordTypes.Names[i]] + ' (' + FRecordTypes.Names[i] + ')');
  end;

  FHeaderRecs.Sorted   := true;
  FDetailRecs.Sorted   := true;
  FRecordTypes.Sorted  := true;

{* Change "CU=Customer  ;Customer Records" into "CU=Customer Records" *}  
  IniFile.ReturnValuesInList(RECORD_TYPES, FDescriptions);
  for i := 0 to FDescriptions.Count - 1 do begin
    PosSC := pos(';', FDescriptions[i]);
    if PosSC > 0 then
      FDescriptions[i] := copy(FDescriptions[i], 1, 3) + copy(FDescriptions[i], PosSC + 1, length(FDescriptions[i]) - PosSC); // keep only the comment part
  end;

  cbFieldDef.Clear;
  cbFieldDef.Items.AddStrings(FDetailRecs);
  cbFieldDef.Sorted   := true;
  if cbFieldDef.Items.Count = 1 then begin // only one Header Rec at time of writing so select it
    cbFieldDef.ItemIndex := 0;
    ChangeOfFieldDef; // mimic user selecting this field def
  end;
end;

procedure TfrmMapMaint.ProcessFieldDefs(ML: TMultiList);
// reads thru the FieldDef column of the ML, passes the full FieldDef to TIni
// which populates the TFieldDef record so that we can read the individual
// fields and populate the columns with the bits of the FieldDef that we need to
// refer to in the code, or we want the user to see.
// With AutoGen fields we change the FieldNo from A123 to F123 so that they will
// match the list in mlAvailableFields - then we can later remove the used ones
// from the full list of available fields by matching on FieldNo.
// Because we only have data in hidden columns at the moment, ML.ItemsCount = 0
// so we use the items.count of a hidden column in the "for" statement.
var
  i: integer;
  FieldDef: TFieldDef;
  NewFieldDef: string;
begin
  for i := 0 to ML.DesignColumns[COL_FieldDef].Items.Count - 1 do begin
    NewFieldDef := CheckForOldFieldDef(ML.DesignColumns[COL_FieldDef].Items[i]);
    if NewFieldDef <> '' then
      ML.DesignColumns[COL_FieldDef].Items[i] := NewFieldDef;
    IniFile.ReturnDataInFieldDef(ML.DesignColumns[COL_FieldDef].Items[i], FieldDef);
    if FieldDef.FieldDefType = 'A' then
      ML.DesignColumns[COL_FieldNo].Items.Add('F' + FieldDef.FieldNo)
    else
      ML.DesignColumns[COL_FieldNo].Items.Add(FieldDef.FieldDefType + FieldDef.FieldNo);
    ML.DesignColumns[COL_FieldDesc].Items.Add(trim(FieldDef.FieldDesc)); // trim so that it matches with IniFile.fdFieldDesc
    ML.DesignColumns[COL_FieldDefault].Items.Add(FieldDef.FieldDefault);
    ML.DesignColumns[COL_FieldComment].Items.Add(FieldDef.FieldComment);
    ML.DesignColumns[COL_FieldUsage].Items.Add(FieldDef.FieldUsage);
  end;
  MLSelectFirst(ML);
end;

procedure TfrmMapMaint.CalculateOffsets;
// Cycle through all the field defs in mlAvailableFields and recalcute each field's
// offset based on it's datatype and length.
// This corrects array fields with multiple occurrences which have been copied
// from the same source record in the settings file.
var
  i: integer;
  FieldDef: TFieldDef;
  Offset, StgWidth: integer; // stg = storage (the number of bytes required to store a field of this type and size)
begin
  Offset    := 1;
  StgWidth  := 0;
  for i := 0 to mlAvailableFields.DesignColumns[COL_FieldDef].Items.Count - 1 do begin
    IniFile.ReturnDataInFieldDef(mlAvailableFields.DesignColumns[COL_FieldDef].Items[i], FieldDef); // get Field Def;
    if FieldDef.FieldNo = '000' then continue; // Ignored Field

    Offset := Offset + StgWidth; // plus the width of the previous field gives us the offset of this one.
                                 // For the first field def, Offset := 1 + 0, which is correct.

    Move(format('%.*d', [SizeOf(FieldDef.Offset), Offset])[1], FieldDef.Offset[1], SizeOf(FieldDef.Offset)); // replace the original offset value

    mlAvailableFields.DesignColumns[COL_FieldDef].Items[i] := IniFile.ReturnFieldDefInString(FieldDef);// replace with the amended Field Def

{* calculate the width of this field so it can be used in the calculation in the next iteration of the loop *}
    StgWidth  := StorageSize(FieldDef.FieldType, StrToInt(FieldDef.FieldWidth));
  end;
end;

procedure TfrmMapMaint.RemoveReadOnlyEtc;
var
  i: integer;
  FieldDef: TFieldDef;
begin
  for i := mlAvailableFields.DesignColumns[COL_FieldDef].Items.Count - 1 downto 0 do begin
    IniFile.ReturnDataInFieldDef(mlAvailableFields.DesignColumns[COL_FieldDef].Items[i], FieldDef); // get Field Def;
    if (FieldDef.FieldUsage = 'N') or (FieldDef.FieldUsage = 'R')
      or ((FieldDef.FieldSys = 'X') and (EnterpriseLicence.IsLITE)) then // Exchequer-only field and this a LITE installation
        MLDeleteRow(mlAvailableFields, i);
  end;
end;

procedure TfrmMapMaint.RemoveUsedFields(mlAvailable, mlUsed: TMultiList);
// remove the used fields in mlUsed from the full list of available fields in
// mlAvailable.
// Better to match using field no coz it's almost unique (yeah i know) and short.
// However, repeating fields, e.g. Address Line [5] will have the same field no
// as Address Line [1] and the wrong one would be removed. So we match on the
// field name instead if it contains a [
var
  i: integer;
  ix: integer;
begin
  for i := 0 to mlUsed.ItemsCount - 1 do begin
    if mlUsed.DesignColumns[COL_FieldNo].Items[i] <> 'F000' then begin
      if pos('[', mlUsed.DesignColumns[COL_FieldDesc].Items[i]) <> 0 then // if it's a repeating field, can't match on field no coz it'll be the same
        ix := mlAvailable.DesignColumns[COL_FieldDesc].Items.IndexOf(mlUsed.DesignColumns[COL_FieldDesc].Items[i])
      else
        ix :=  mlAvailable.DesignColumns[COL_FieldNo].Items.IndexOf(mlUsed.DesignColumns[COL_FieldNo].Items[i]);
      if ix <> -1 then
        MLDeleteRow(mlAvailable, ix);
    end;
  end;
end;

procedure TfrmMapMaint.ResortAvailableFields;
// usually we'd sort in alphabetical order as it's more useful to the user.
// If we're debugging its usually more useful in order of Field No. coz that
// matches the contents of the settings file.
begin
  if DebugIt then
    MLSortColumn(mlAvailableFields, COL_FieldNo, true)
  else
    MLSortColumn(mlAvailableFields, COL_FieldDesc, true);
end;

procedure TfrmMapMaint.ResortSelectedFields;
// For user-defined files (i.e. CSV) we leave the selected field defs in the
// order that they're in in MLAvailableFields.
// However, for Std Import Files they need to be in field number order when
// they get written to the field map file so we resort here when they
// SelectAllFieldDefs and the move-up and move-down buttons get disabled.
var
  ML: TMultiList;
begin
  if cbImportFileType.ItemIndex = ord(ftStdImport) then begin
    case pcFieldMap.ActivePageIndex of
      AType_Page: ML := mlAType;
      FType_Page: ML := mlFType;
    else
      exit;
    end;
    MLSortColumn(ML, COL_FIELDNO, true);
  end;
end;

function TfrmMapMaint.RTfromFDRT(FDRT: string): string;
// Extracts the RecordType from a combined "FieldDef = RecordType" string as
// displayed in cbFieldDef
begin
  result := copy(FDRT, pos(' (', FDRT) + 2, 2);
end;

procedure TfrmMapMaint.SaveDefault(NewValue: string);
// saves the amended default back into the multilist and into it's correct
// column in the FieldDef.
// ReturnDataInFieldDef passes the fixed column string to TIni and receives
// a populated TFieldDef record. The .FieldDefault field is updated and
// the result of TIni's ReturnFieldDefInString can replace the original
// COL_FieldDef value in the multilist.
var
  FieldDef: TFieldDef;
begin
  NewValue := CheckAutoInc(NewValue, false); // needs modifying if it's an autoinc counter
  case pcFieldMap.ActivePageIndex of
    AType_Page:  begin
                   mlAType.DesignColumns[COL_FieldDefault].Items[mlAType.Selected] := NewValue; // put the value in the ML's Default column
                   IniFile.ReturnDataInFieldDef(mlAType.DesignColumns[COL_FieldDef].Items[mlAType.Selected], FieldDef); // get the FieldDef column into the TFieldDef
                   FillChar(FieldDef.FieldDefault, SizeOf(FieldDef.FieldDefault), #32);
                   move(NewValue[1], FieldDef.FieldDefault[1], length(NewValue)); // change the FieldDef
                   mlAType.DesignColumns[COL_FieldDef].Items[mlAType.Selected]
                     := IniFile.ReturnFieldDefInString(FieldDef); // put the string version of the FieldDef back into the ML
                 end;
    FType_Page:  begin
                   mlFType.DesignColumns[COL_FieldDefault].Items[mlFType.Selected] := NewValue; // put the value in the ML's Default column
                   IniFile.ReturnDataInFieldDef(mlFType.DesignColumns[COL_FieldDef].Items[mlFType.Selected], FieldDef); // get the FieldDef column into the TFieldDef
                   FillChar(FieldDef.FieldDefault, SizeOf(FieldDef.FieldDefault), #32);
                   move(NewValue[1], FieldDef.FieldDefault[1], length(NewValue)); // change the FieldDef
                   mlFType.DesignColumns[COL_FieldDef].Items[mlFType.Selected]
                     := IniFile.ReturnFieldDefInString(FieldDef); // put the string version of the FieldDef back into the ML
                 end;
  end;
  IsDirty;
end;

procedure TfrmMapMaint.SaveMapFile(FileName: string);
// saves the contents of mlAType and mlFType to the map file, together with
// any required [AutoIncReset] section.
// The FType fields are preceded by an [RT] section header which contains the
// detail record type.
// The AType fields are preceded by an [AUTORT] section header where RT is the
// record type of the Header Record
// Although map files are in ini file format, some rows will have duplicate
// keys. So we have to generate the ini file structure manually rather than
// use a TIniFile-type object.
// 10/01/2006: Added a [Toolkit] section to indicate which toolkit the field map applies to
var
  i: integer;
  IniLines: TStringList;
  RT: string;
  AutoIncResetSection: boolean;
begin
  FMapFile := FileName; // for the form caption in ChangeCaption
  IniLines := TStringList.Create;
  try
    if mlFType.ItemsCount > 0 then begin
      RT := RTfromFDRT(tsFType.Caption);//     was   cbRecordType.Text; 07/12/2005
      IniLines.Add('[' + RT + ']'); // add a section header
      for i := 0 to mlFType.ItemsCount - 1 do // write out the FType FieldDefs
        IniLines.Add(mlFType.DesignColumns[COL_FieldDef].Items[i]);
    end;
    if mlAType.ItemsCount > 0 then begin
      IniLines.Add('[Auto' + RT + ']'); // add a section header
      for i := 0 to mlAType.ItemsCount - 1 do // write out the AType FieldDefs
        IniLines.Add(mlAType.DesignColumns[COL_FieldDef].Items[i]);
    end;
    AutoIncResetSection := false;
    for i := 1 to 9 do // do we need an [AutoIncReset] section
      if FAutoIncReset[i] <> '' then
        AutoIncResetSection := true;
    if AutoIncResetSection then
      IniLines.Add('[AutoIncReset]');
    for i := 1 to 9 do // write out the AutoIncx=RT parts of the [AutoIncReset] Section
      if FAutoIncReset[i] <> '' then
        IniLines.Add(format('AutoInc%d=%s', [i, FAutoIncReset[i]]));

    IniLines.SaveToFile(FileName);
    if not PlainOut then
      IniFile.EncryptIniFile(FileName);
  finally
    IniLines.free;
  end;

  FIsDirty   := false; // all clean and fresh again.
  FMapLoaded := true;
  EnableDisableEtc;
  ChangeCaption;
end;

procedure TfrmMapMaint.SaveMapFileAs;
begin
  if SaveDialog.Execute then
    SaveMapFile(SaveDialog.FileName);
end;

procedure TfrmMapMaint.SaveUserDefFile(FileName: string);
// creates a file with just the CSV column headings in it
// We also output the record type before the first field of each section so the user
// can see where each section/record type starts.
var
  i: integer;
  UserDefRec: string;
  OneLine: TStringList;
  FieldDef: TFieldDef;
  DefaultValue: string;
begin
  if mlSType.ItemsCount > 0 then  // output "[RT]Record Type,"
    UserDefRec := UserDefRec + '[' + RTfromFDRT(cbFieldDef.Text) + ']'
                               + mlSType.DesignColumns[COL_FieldDesc].Items[0] + ',';
  for i := 1 to mlSType.ItemsCount - 1 do begin// output rest of system "Field Name,"s
    DefaultValue := trim(mlSType.DesignColumns[COL_FieldDefault].Items[i]);
    if (length(DefaultValue) > 0) and (DefaultValue[1] = '[') then continue; // ignore AutoInc and Include fields, they don't appear in the import file
    UserDefRec := UserDefRec + trim(mlSType.DesignColumns[COL_FieldDesc].Items[i]); // output friendly field name
    if DefaultValue <> '' then // add the default value in ()
      UserDefRec := UserDefRec + '(' + DefaultValue + ')';
    UserDefRec := UserDefRec + ',';
  end;

  if mlAType.ItemsCount > 0 then begin // output ",[RT]"
    IniFile.ReturnDataInFieldDef(mlAType.DesignColumns[COL_FieldDef].Items[0], FieldDef);
    UserDefRec := UserDefRec + '[' + FieldDef.RecordType + ']';
  end;
  for i := 0 to mlAType.ItemsCount - 1 do begin // output Autogen "Field Name,"
    DefaultValue := trim(mlAType.DesignColumns[COL_FieldDefault].Items[i]);
    if (length(DefaultValue) > 0) and (DefaultValue[1] = '[') then continue; // ignore AutoInc andInclude fields, they don't appear in the import file
    UserDefRec := UserDefRec + trim(mlAType.DesignColumns[COL_FieldDesc].Items[i]); // output friendly field name
    if DefaultValue <> '' then // add the default value in ()
      UserDefRec := UserDefRec + '(' + DefaultValue + ')';
    UserDefRec := UserDefRec + ',';
  end;

  if mlFType.ItemsCount > 0 then begin // output ",[RT]"
    IniFile.ReturnDataInFieldDef(mlFType.DesignColumns[COL_FieldDef].Items[0], FieldDef);
    UserDefRec := UserDefRec + '[' + FieldDef.RecordType + ']';
  end;
  for i := 0 to mlFType.ItemsCount - 1 do begin // output FType "FieldName,"
    DefaultValue := trim(mlFType.DesignColumns[COL_FieldDefault].Items[i]);
    if (length(DefaultValue) > 0) and (DefaultValue[1] = '[') then continue; // ignore AutoInc and Include fields, they don't appear in the import file
    UserDefRec := UserDefRec + trim(mlFType.DesignColumns[COL_FieldDesc].Items[i]); // output friendly field name
    if DefaultValue <> '' then // add the default value in ()
      UserDefRec := UserDefRec + '(' + DefaultValue + ')';
    UserDefRec := UserDefRec + ',';
  end;

                                             // don't want the last comma
  FComma := UserDefRec[length(UserDefRec)];  // save it in case we need one later (waste not, want not)
  UserDefRec[length(UserDefRec)] := ' ';     // Typex over it

  OneLine := TStringList.Create;
  try
    OneLine.Add(UserDefRec);
    OneLine.SaveToFile(FileName);
  finally
    OneLine.free;
  end;
end;

procedure TfrmMapMaint.SelectAllFieldDefs;
// Selects each field def from mlAvailableFields in turn and performs a
// SelectFieldDef on it.
// As this removes row zero we keep selecting row zero and move it out of mlAvailableFields.
// When we get to the "Ignored Field" entry (field no F000) we skip over it
// and start selecting row 1 instead.
var
  i: integer;
  Selected: integer;
begin
  SelectDefaultFieldDefs(true);
  Selected := 0; // initially keep selecting and moving row zero
  for i := 0 to mlAvailableFields.ItemsCount - 1 do begin
    if mlAvailableFields.DesignColumns[COL_FIELDNO].Items[Selected] = 'F000' then begin
      Selected := 1; // now, keep selecting and moving row 1
      continue;
    end;
    mlAvailableFields.Selected := Selected;
    SelectFieldDef;
  end;
  ResortSelectedFields;
end;

procedure TfrmMapMaint.SelectDefaultFieldDefs(IncludeSelected: boolean);
// if no other field defs have yet been selected by the user, cycle thru all
// the available fields and select the mandatory fields for them.
var
  ML: TMultiList;
  SelectedRow: integer;
  i: integer;
  FieldDef: TFieldDef;
begin
  ML := nil;
  case pcFieldMap.ActivePageIndex of
    SType_Page:  exit; // can't alter SType field Defs
    AType_Page:  ML := mlAType;
    FType_Page:  begin
                   ML := mlFType;
                   LoadSTypes(RTfromFDRT(cbFieldDef.Text)); // load the SType fields for the detail record type
                 end;
  end;

  if ML.ItemsCount <> 0 then exit; // we've already done this once

  pcFieldMap.ActivePage.Caption := cbFieldDef.Text; // set the tab caption to the Exchequer record type

  SelectedRow := mlAvailableFields.Selected; // remember the row the user was selecting

  for i := mlAvailableFields.ItemsCount - 1 downto 0  do // do it backwards coz we'll be removing lines
    if IncludeSelected or (i <> SelectedRow) then begin  // ignore the one the user selected ?
      IniFile.ReturnDataInFieldDef(mlAvailableFields.DesignColumns[COL_FieldDef].Items[i], FieldDef);
      if (FieldDef.FieldUsage = 'F') or (FieldDef.FieldUsage = 'M') then begin // Fixed or Mandatory field ?
        mlAvailableFields.Selected := i;                                       // select the row
        SelectFieldDef;
        if i < SelectedRow then
          dec(SelectedRow); // coz we've just removed a line in SelectFieldDef which has moved our original
      end;
    end;

  if IncludeSelected then
    MLSelectFirst(mlAvailableFields)
  else
    mlAvailableFields.Selected := SelectedRow; // reselect the original row

  MLSortColumn(ML, COL_FieldDesc, true);
  if ML.ItemsCount > 1 then
    edtMsg.Text := 'Mandatory fields have been automatically selected for you';
end;

procedure TfrmMapMaint.SelectFieldDef;
// move a row from AvailableFields to SelectedFields
// if we're moving the field to the AutoGen section then we need to amend the
// FieldDef to change the FieldNo from Fxxx to Axxx
var
  ML: TMultiList;
  i: integer;
  FieldDef: TFieldDef;
  FieldDefInString: string;
  AType: boolean;
  ix: integer;
begin
  ix := 0;
  ML := nil;
  AType := False;
  case pcFieldMap.ActivePageIndex of
    SType_Page:  exit; // can't alter SType field Defs
    AType_Page:  begin
                   ML := mlAType;
                   AType := true;
                 end;
    FType_Page:  begin
                   ML := mlFType;
                   AType := false;
                 end;
  end;

  for i := 0 to mlAvailableFields.Columns.Count - 1 do  // copy all the columns across
     if FAddFields then
       ix := ML.DesignColumns[i].Items.Add(mlAvailableFields.DesignColumns[i].Items[mlAvailableFields.selected])
     else begin
         if ML.Selected = -1 then
           ix := 0
         else
           ix := ML.Selected;
         ML.DesignColumns[i].Items.insert(ix, mlAvailableFields.DesignColumns[i].Items[mlAvailableFields.selected]);
     end;

  if AType then begin // need to change the FieldType from 'F' to 'A'
    IniFile.ReturnDataInFieldDef(ML.DesignColumns[COL_FieldDef].Items[ix], FieldDef); // get the field def into a record
    FieldDef.FieldDefType := 'A';                                                                    // change it
    FieldDefInString := IniFile.ReturnFieldDefInString(FieldDef);                                    // put it back
    ML.DesignColumns[COL_FieldDef].Items[ix] := FieldDefInString;
  end;

  if mlAvailableFields.DesignColumns[COL_FieldNo].Items[mlAvailableFields.Selected] <> 'F000' then begin // we don't remove the Ignored Field entry
    MLDeleteSelectedRow(mlAvailableFields);                                                              // as it can be used as many times as needed
    ML.Selected := ML.ItemsCount - 1;
  end;

  if FAddFields then
    MLSelectRow(ML, ix)
  else
    MLSelectRow(ML, ix + 1); // keep the original row selected
//  MLSelectLast(ML);
  IsDirty;
end;

procedure TfrmMapMaint.ShowFieldDef(AFieldDef: string);
// change the drop down to display the required entry
var
  RT: string;
begin
  cbFieldDef.ItemIndex := cbFieldDef.Items.IndexOf(AFieldDef);
  RT := copy(cbFieldDef.Text, pos(' (', cbFieldDef.Text) + 2, 2);
  lblRTDescription.caption := FDescriptions.Values[RT]; // select the description for the RT
end;

procedure TfrmMapMaint.Startup;
var
  i: integer;
begin
  MLInit(mlAvailableFields); // setup default fonts and colours
  MLInit(mlFType);
  MLInit(mlAType);
  MLInit(mlSType);
  InitDialogs;

  FormLoadSettings(Self, nil);
  MLLoadSettings(mlAvailableFields, Self);
  MLLoadSettings(mlSType, Self);
  MLLoadSettings(mlAType, Self);
  MLLoadSettings(mlFType, Self);

  FFieldDefs    := TStringList.create;
  FRecordTypes  := TStringList.create;
  FHeaderRecs   := TStringList.create;
  FDetailRecs   := TStringList.create;
  FDescriptions := TStringList.create;
  PopulateRecordTypes;
  PopulateFieldDefs;
  mlAvailableFields.ShowHint := true;
  mlSType.ShowHint           := true;
  mlAType.ShowHint           := true;
  mlFType.ShowHint           := true;
  pcFieldMap.ActivePage      := tsFType;
  tsAType.TabVisible         := false;

  edtMsg.Width := pcFieldMap.Width - 2;
  edtMsg.Left  := pcFieldMap.left;

  lblRTDescription.Caption := '';

  if debugit then begin
    mlSType.Font.Name := 'Courier New';  // so the columns of the FieldDef column line up.
    mlAType.Font.Name := mlSType.Font.Name;
    mlFType.Font.Name := mlSType.Font.Name;
    mlAvailableFields.Font.Name := mlSType.Font.Name;
    mlSType.HighlightFont.Name := mlSType.Font.Name;
    mlAType.HighlightFont.Name := mlSType.Font.Name;
    mlFType.HighlightFont.Name := mlSType.Font.Name;
    mlAvailableFields.HighlightFont.Name := mlSType.Font.Name;
    for i := 0 to mlAvailableFields.Columns.Count - 1 do begin // all four ML's have the same number of columns
      mlAvailableFields.DesignColumns[i].Visible := true;
      mlSType.DesignColumns[i].Visible := true;
      mlAType.DesignColumns[i].Visible := true;
      mlFType.DesignColumns[i].Visible := true;
    end;
  end;
end;

procedure TfrmMapMaint.SwitchFDList;
// change what's displayed in the top half of the form to reflect the fact
// that the user has changed which tab is being viewed in the bottom half.
begin
  case pcFieldMap.ActivePageIndex of
    SType_Page:  exit; // can't alter SType field Defs
    AType_Page:  begin
                   cbFieldDef.Clear;
                   cbFieldDef.Items.AddStrings(FHeaderRecs);
                   if cbFieldDef.Items.Count = 1 then begin // only one Header Rec at time of writing so select it
                     cbFieldDef.ItemIndex := 0;
                     ChangeOfFieldDef; // mimic user selecting this field def
                   end;
                 end;
    FType_Page:  begin
                   cbFieldDef.Clear;
                   cbFieldDef.Items.AddStrings(FDetailRecs);
                 end;
  end;
end;

function TfrmMapMaint.UserDefFile: boolean;
begin
  result := cbImportFileType.ItemIndex = ord(ftUserDef);
end;

{* Event Procedures *}

procedure TfrmMapMaint.FormCreate(Sender: TObject);
begin
  Startup;
end;

procedure TfrmMapMaint.mlAvailableFieldsChangeSelection(Sender: TObject);
begin
  ChangeHint(mlAvailableFields, edtMsg);
end;

procedure TfrmMapMaint.mlAvailableFieldsRowDblClick(Sender: TObject; RowIndex: Integer);
begin
  SelectDefaultFieldDefs(false);
//  if GetAsyncKeyState(VK_SHIFT) <  0 then
  SelectFieldDef;
end;

procedure TfrmMapMaint.mlFTypeRowDblClick(Sender: TObject; RowIndex: Integer);
begin
  FDoubleClicking := true;
  EditDefault;
end;

procedure TfrmMapMaint.mlFTypeChangeSelection(Sender: TObject);
// a double-click also generates an OnChangeSelection event even if it hasn't.
// We only reset what's enabled/disabled on a true change of selection.
begin
  if not FDoubleClicking then begin
    ChangeHint(mlFType, edtMsg);
    EnableDisableEtc;
  end;
  FDoubleClicking := false;
end;

procedure TfrmMapMaint.btnMoveFieldDefUpClick(Sender: TObject);
// move the selected field def up one row
begin
  case pcFieldMap.ActivePageIndex of
    SType_Page:  begin
                   exit;
                 end;
    AType_Page:  begin
                   MLMoveSelectedRowUp(mlAType);
                   IsDirty;
                 end;
    FType_Page:  begin
                   MLMoveSelectedRowUp(mlFType);
                   IsDirty;
                 end;
  end;
end;

procedure TfrmMapMaint.btnMoveFieldDefDownClick(Sender: TObject);
// move the selected field def down one row
begin
  case pcFieldMap.ActivePageIndex of
    SType_Page:  begin
                   exit;
                 end;
    AType_Page:  begin
                   MLMoveSelectedRowDown(mlAType);
                   IsDirty;
                 end;
    FType_Page:  begin
                   MLMoveSelectedRowDown(mlFType);
                   IsDirty;
                 end;
  end;
end;

procedure TfrmMapMaint.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  CheckIfDirty;
  action := caFree;
  frmMapMaint := nil;
end;

procedure TfrmMapMaint.btnLoadMapFileClick(Sender: TObject);
begin
  if OpenDialog.Execute then
    LoadMapFile(OpenDialog.FileName);
end;

procedure TfrmMapMaint.cbFieldDefChange(Sender: TObject);
begin
  ChangeOfFieldDef;
  SelectDefaultFieldDefs(true);
end;

procedure TfrmMapMaint.xcbRecordTypeChange(Sender: TObject);
// change cbFieldDef to show the Field Def of the selected Record Type
// We only do this if we're looking at the F-Type fields. For Auto Gen
// fields the user can select any combination.
// *** no longer used ***
begin
//  FMainRecordType := xcbRecordType.Text;

//  if pcFieldMap.ActivePage = tsFType then begin
//    ShowFieldDef(FRecordTypes.Values[xcbRecordType.Text]);
//    LoadFieldDefs(xcbRecordType.Text);
//  end;

{* if cbRecordType isn't disabled then they've been allowed to change the
   record type, so load the SType fields from the main settings file. *}
//  LoadSTypes(xcbRecordType.text);
end;

procedure TfrmMapMaint.pcFieldMapChange(Sender: TObject);
begin
  pcFieldMap.Enabled := false;
  lblRTDescription.Caption := '';
  try
    SwitchFDList;
    ChangeAvailableFields;
    SelectDefaultFieldDefs(true); 
  finally
    pcFieldMap.Enabled := true;
  end;

  EnableDisableEtc;
end;

procedure TfrmMapMaint.btnDeSelectFieldDefClick(Sender: TObject);
begin
  DeSelectFieldDef;
end;

procedure TfrmMapMaint.btnSelectFieldDefClick(Sender: TObject);
begin
  SelectDefaultFieldDefs(false);
  SelectFieldDef;
end;

procedure TfrmMapMaint.mlATypeRowDblClick(Sender: TObject; RowIndex: Integer);
begin
  FDoubleClicking := true;
  EditDefault;
end;

procedure TfrmMapMaint.mlATypeChangeSelection(Sender: TObject);
// a double-click also generates an OnChangeSelection event even if it hasn't.
// We only reset what's enabled/disabled on a true change of selection.
begin
  if not FDoubleClicking then begin
    ChangeHint(mlAType, edtMsg);
    EnableDisableEtc;
  end;
  FDoubleClicking := false;
end;

procedure TfrmMapMaint.mlSTypeChangeSelection(Sender: TObject);
begin
  ChangeHint(mlSType, edtMsg);
end;

procedure TfrmMapMaint.btnEditDefaultClick(Sender: TObject);
begin
  EditDefault;
end;

procedure TfrmMapMaint.btnSaveMapFileAsClick(Sender: TObject);
begin
  SaveMapFileAs;
end;

procedure TfrmMapMaint.btnSaveMapFileClick(Sender: TObject);
begin
  SaveMapFile(FMapFile);
end;

procedure TfrmMapMaint.btnRemoveFieldDefClick(Sender: TObject);
begin
  DeSelectFieldDef;
end;

procedure TfrmMapMaint.btnRemoveAllFieldDefsClick(Sender: TObject);
begin
  if (MessageDlg('Are you sure you want to de-select all fields ?', mtConfirmation, [mbYes, mbNo], 0) = mrNo) then exit;
  DeSelectAllFieldDefs;
end;

procedure TfrmMapMaint.btnNewMapFileClick(Sender: TObject);
begin
  CheckIfDirty;
  NewMapFile;
end;

procedure TfrmMapMaint.btnCreateUserDefFileClick(Sender: TObject);
begin
  if SaveCSVDialog.Execute then
    SaveUserDefFile(SaveCSVDialog.FileName);
end;

procedure TfrmMapMaint.btnCloseClick(Sender: TObject);
begin
  close;
end;

procedure TfrmMapMaint.chbShowMandatoryClick(Sender: TObject);
begin
  if chbShowMandatory.Checked then
    pcFieldMap.ActivePage := tsSType;

  EnableDisableEtc;
end;

procedure TfrmMapMaint.WMMoving(var msg: TMessage);
begin
  WindowMoving(msg, height, width);
end;

procedure TfrmMapMaint.FormKeyUp(Sender: TObject; var Key: Word; Shift: TShiftState);
// if the user presses the insert key, check whether its now on or off and change the OVR/INS caption.
begin
  if key = VK_ESCAPE then close;

  if key = VK_INSERT then
    GetInsertKeyStatus;
end;

procedure TfrmMapMaint.btnSelectAllFieldDefsClick(Sender: TObject);
begin
  SelectAllFieldDefs;
end;

procedure TfrmMapMaint.cbImportFileTypeChange(Sender: TObject);
begin
  ChangeOfFileType;
end;

procedure TfrmMapMaint.mniSaveCoordinatesClick(Sender: TObject);
begin
  with Sender as TMenuItem do begin
    Checked := not Checked;
    SetSaveCoordinates(Checked);
  end;
end;

procedure TfrmMapMaint.mniProperties1Click(Sender: TObject);
begin
  MLEditProperties(mlAvailableFields, Self, nil);
end;

procedure TfrmMapMaint.SetSaveCoordinates(Checked: boolean);
// duplicate the setting of one menu item in all of them
begin
  mniSaveCoordinates1.Checked      := Checked;
  mniSaveCoordinates2.Checked      := Checked;

  FSaveCoordinates                 := Checked;
end;

procedure TfrmMapMaint.mniProperties2Click(Sender: TObject);
var
  ML: TMultiList;
begin
  ML := nil;
  case pcFieldMap.ActivePageIndex of
    SType_Page:  ML := mlSType;
    AType_Page:  ML := mlAType;
    FType_Page:  ML := mlFType;
  end;
  MLEditProperties(ML, Self, nil);
end;

procedure TfrmMapMaint.mlFTypeCellPaint(Sender: TObject; ColumnIndex,
  RowIndex: Integer; var OwnerText: String; var TextFont: TFont;
  var TextBrush: TBrush; var TextAlign: TAlignment);
// Fixed fields are displayed in italics.
// Fields in bold must appear in the user's import file. So that's every field
// which isn't Fixed or an "[I"nclude field.
var
  owner: TComponent;
  ML: TMultiList;
begin
try
  if ColumnIndex <> COL_FieldDesc then exit;

  owner := TComponent(sender).Owner;
  while not (owner is TMultiList) do
    owner := TComponent(owner).Owner; // back-up the heirarchy til we get to a TMultiList

  ML := TMultiList(owner);

  if ML.DesignColumns[COL_FieldUsage].Items[RowIndex] = 'F' then begin
//    TextFont.Color := clInactiveCaptionText;
    TextFont.Style := TextFont.Style + [fsItalic];
  end
  else
  if pos('[I', ML.DesignColumns[COL_FieldDefault].Items[RowIndex]) <> 1 then
    TextFont.Style := TextFont.Style + [fsBold];
except
  ShowMessage('error in FTypeCellPaint');
end;
end;

procedure TfrmMapMaint.mlATypeCellPaint(Sender: TObject; ColumnIndex,
  RowIndex: Integer; var OwnerText: String; var TextFont: TFont;
  var TextBrush: TBrush; var TextAlign: TAlignment);
// Fixed fields are displayed in italics.
// Fields in bold must appear in the user's import file. So that's every field
// which isn't Fixed or an "[I"nclude field.
var
  owner: TComponent;
  ML: TMultiList;
begin
try
  if ColumnIndex <> COL_FieldDesc then exit;

  owner := TComponent(sender).Owner;
  while not (owner is TMultiList) do
    owner := TComponent(owner).Owner; // back-up the heirarchy til we get to a TMultiList

  ML := TMultiList(owner);

  if ML.DesignColumns[COL_FieldUsage].Items[RowIndex] = 'F' then begin
//    TextFont.Color := clInactiveCaptionText;
    TextFont.Style := TextFont.Style + [fsItalic];
  end
  else
  if pos('[I', ML.DesignColumns[COL_FieldDefault].Items[RowIndex]) <> 1 then
    TextFont.Style := TextFont.Style + [fsBold];
except
  ShowMessage('error in ATypeCellPaint');
end;
end;

procedure TfrmMapMaint.mlSTypeCellPaint(Sender: TObject; ColumnIndex,
  RowIndex: Integer; var OwnerText: String; var TextFont: TFont;
  var TextBrush: TBrush; var TextAlign: TAlignment);
// Fields in bold must appear in the user's import file
// For System fields, that currently means any field without [AutoInc0] etc.
// in the default column, such as LinkRef.
var
  owner: TComponent;
  ML: TMultiList;
begin
try
  if ColumnIndex <> COL_FieldDesc then exit;

  owner := TComponent(sender).Owner;
  while not (owner is TMultiList) do
    owner := TComponent(owner).Owner; // back-up the heirarchy til we get to a TMultiList

  ML := TMultiList(owner);

  if pos('[', ML.DesignColumns[COL_FieldDefault].Items[RowIndex]) <> 1 then
    TextFont.Style := TextFont.Style + [fsBold];
except
  ShowMessage('error in STypeCellPaint');
end;
end;

procedure TfrmMapMaint.FormShow(Sender: TObject);
begin
  GetInsertKeyStatus;
end;

initialization
  frmMapMaint := nil;

end.
