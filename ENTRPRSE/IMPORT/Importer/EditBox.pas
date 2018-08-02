unit EditBox;

{******************************************************************************}
{  EditBox displays an item for the user to edit.                              }
{  Numerous parameters can be passed to the Show method to control what options}
{  and prompts are displayed to the user and to validate the data they enter.  }
{  Originally, each section of the Wizard, Default Settings and MapMaint forms }
{  had their own edit boxes permanently on display. These were replaced by this}
{  generic "popup" edit window which is why the Show function tries to be      }
{  "all things to all forms".                                                  }
{******************************************************************************}
interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, GlobalTypes, StdCtrls, psvDialogs, Menus, ComCtrls, BorBtns, ExtCtrls;

type
  TfrmEditBox = class(TForm)
    btnOK: TButton;
    btnCancel: TButton;
    btnPresets: TButton;
    edtMsg: TEdit;
    PopupMenu1: TPopupMenu;
    SelectFile: TMenuItem;
    SelectFolder: TMenuItem;
    pc: TPageControl;
    tsValue: TTabSheet;
    edtValue: TEdit;
    cbValue: TComboBox;
    btnSelectElipsis: TButton;
    tsAutoInc: TTabSheet;
    Label1: TLabel;
    cbAutoInc: TComboBox;
    Label2: TLabel;
    cbAutoIncReset: TComboBox;
    lblMaxLen: TLabel;
    lblDataType: TLabel;
    lblSettingName: TLabel;
    lblSettingName2: TLabel;
    cbIncludeField: TBorCheckEx;
    lblMoreInfo: TLabel;
    pumPresets: TPopupMenu;
    SystemDate1: TMenuItem;
    lblIncludeField: TLabel;
    procedure btnOKClick(Sender: TObject);
    procedure cbValueChange(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure btnSelectClick(Sender: TObject);
    procedure edtValueKeyPress(Sender: TObject; var Key: Char);
    procedure edtValueChange(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FormKeyPress(Sender: TObject; var Key: Char);
    procedure SelectFileClick(Sender: TObject);
    procedure SelectFolderClick(Sender: TObject);
    procedure btnClearClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure cbAutoIncChange(Sender: TObject);
    procedure cbAutoIncResetChange(Sender: TObject);
    procedure FormKeyUp(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure btnCancelClick(Sender: TObject);
    procedure cbIncludeFieldClick(Sender: TObject);
    procedure lblMoreInfoMouseEnter(Sender: TObject);
    procedure lblMoreInfoMouseLeave(Sender: TObject);
    procedure SystemDate1Click(Sender: TObject);
    procedure btnPresetsClick(Sender: TObject);
  protected
    constructor create(AOwner: TComponent); override;
  private
{* Internal Fields *}
    FEditType: char;
    FNewValue: string;
    FSettingType: TSettingType;
    FSettingUp: boolean;
    FValues: TStringList;
    FWarning: string;
{* Property Fields *}
    FDataType: char;
    FMaxLength: integer;
    FIniSection: string;
    FIniSetting: boolean;
    FSettingName: string;
    FCurrentValue: string;
    FDataTypeCaption: string;
    FMsg: string;
    FCaption: string;
    FOpenDialog: TOpenDialog;
    FBrowseFolderDialog: TpsvBrowseFolderDialog;
{* Procedural Methods *}
    procedure ChangeOfValue;
    procedure DisplayWarning;
    procedure SelectItem(ASettingType: TSettingType);
    procedure SetAutoIncReset(ART: string);
    function  ShowEditBox(var AValue: string): boolean;
    procedure DoCaptions;
    procedure DoDisplay;
    procedure DoIncludeField;
    procedure DoSelectElipsis;
    procedure DoSettingEditTypes;
    procedure DoDisplayTab;
    procedure DoSizeEditBox;
{* Getters and Setters *}
    procedure SetBrowseFolderDialog(const Value: TpsvBrowseFolderDialog);
    procedure SetCaption(const Value: string);
    procedure SetCurrentValue(const Value: string);
    procedure SetDataType(const Value: char);
    procedure SetDataTypeCaption(const Value: string);
    procedure SetIniSection(const Value: string);
    procedure SetMaxLength(const Value: integer);
    procedure SetMsg(const Value: string);
    procedure SetOpenDialog(const Value: TOpenDialog);
    procedure SetSettingName(const Value: string);
    procedure SetIniSetting(const Value: boolean);
    procedure TestRelPaths;
  public
    class function Show(const AIniSection: string;
                        const ASettingName: string;
                        ADataType: char;
                        AMaxLength: integer;
                        const ADataTypeCaption: string;
                        const ACaption: string;
                        const AMsg: string;
                        const ACurrentValue: string;
                        OpenDialog: TOpenDialog;
                        BrowseFolderDialog: TpsvBrowseFolderDialog;
                        RecordTypes: TStrings;
                        IniSetting: boolean;
                        var AValue: string): boolean;
    property IniSection: string read FIniSection write SetIniSection;
    property IniSetting: boolean read FIniSetting write SetIniSetting;
    property SettingName: string read FSettingName write SetSettingName;
    property DataType: char read FDataType write SetDataType;
    property MaxLength: integer read FMaxLength write SetMaxLength;
    property DataTypeCaption: string read FDataTypeCaption write SetDataTypeCaption;
    property Caption: string read FCaption write SetCaption;
    property Msg: string read FMsg write SetMsg;
    property CurrentValue: string read FCurrentValue write SetCurrentValue;
    property OpenDialog: TOpenDialog read FOpenDialog write SetOpenDialog;
    property BrowseFolderDialog: TpsvBrowseFolderDialog read FBrowseFolderDialog write SetBrowseFolderDialog;
  end;


implementation

uses TIniClass, Utils, LoginF, FileUtil;

var
  frmEditBox: TfrmEditBox;

{$R *.dfm}

class function TfrmEditBox.Show(const AIniSection: string;
                                const ASettingName: string;
                                ADataType: char;
                                AMaxLength: integer;
                                const ADataTypeCaption: string;
                                const ACaption: string;
                                const AMsg: string;
                                const ACurrentValue: string;
                                OpenDialog: TOpenDialog;
                                BrowseFolderDialog: TpsvBrowseFolderDialog;
                                RecordTypes: TStrings;
                                IniSetting: boolean;
                                var AValue: string): boolean;
begin
  if not assigned(frmEditBox) then
    frmEditBox := TfrmEditBox.create(nil);

  frmEditBox.IniSection         := AIniSection;        // The [section] in IniFile which contains the item being edited
  frmEditBox.SettingName        := ASettingName;       // the Name= part of the ini value in the above [section] or the User-Friendly field name of an Exchequer record
  frmEditBox.DataType           := ADataType;          // S = String, L = Longint, etc.
  frmEditBox.MaxLength          := AMaxLength;         // the maximum number of permissible characters
  frmEditBox.DataTypeCaption    := ADataTypeCaption;   // A user-friendly text description of the above data type
  frmEditBox.Caption            := ACaption;           // used to label the edit box when SettingName is inappropriate
  frmEditBox.Msg                := AMsg;               // edMsg.text := Msg; will usually be the comment field of a TFieldDef
  frmEditBox.CurrentValue       := ACurrentValue;      // The current value of the ini file setting or field default.
  frmEditBox.OpenDialog         := OpenDialog;         // an existing TOpenDialog instance.
  frmEditBox.BrowseFolderDialog := BrowseFolderDialog; // an existing TpsvBrowseFolderDialog instance
  frmEditBox.IniSetting         := IniSetting;         // Is this an IniFile setting or a FieldDef ? cbIncludeField only relevant for FieldDefs
  if assigned(RecordTypes) then begin
    frmEditBox.cbAutoIncReset.Items.Assign(RecordTypes); // list of possible 2-char Record Types. User can select which Record Type in the CSV file causes the counter to be reset to zero.
    frmEditBox.cbAutoIncReset.Items.Insert(0, '');       // allow them to have a <none> option.
  end;

  result := frmEditBox.ShowEditBox(AValue);
end;

constructor TfrmEditBox.create(AOwner: TComponent);
begin
  inherited
end;

{* Procedural Methods *}

procedure TfrmEditBox.ChangeOfValue;
begin
  if FSettingUp then exit;

  btnOK.Enabled    := true;
end;

procedure TfrmEditBox.TestRelPaths;
// Not Used: Relative Paths didn't get implemented in Importer.
// The code below (plus functions in Utils, especially) will expand a relative path
// into a true path. I've left it here for future reference.
var
  sr: TSearchRec;
  rc: integer;
  ED: string;
  FN: string;
begin
  if not SetCurrentDir('x:\') then ShowMessage('can''t'); // my contribution to thedailywtf
  edtMsg.Text           := 'RelPath: ' + FCurrentValue;
  ED := ExcludeTrailingPathDelimiter(GetEnterpriseDirectory);
  rc := FindFirst(ED, faDirectory, sr);
  ED := ExtractFilePath(ED);
  if rc = 0 then begin
    FN := sr.Name;
//    btnSelectElipsis.Hint := 'FullPath: ' + MyExpandFileName(ED + FN, FCurrentValue);
    btnSelectElipsis.Hint := 'FullPath: ' + ExpandFileName(FCurrentValue); // calls utils not SysUtils.
    lblDataType.Caption   := 'CurrDir: ' + GetCurrentDir;
    lblMaxLen.caption     := 'BasePath: ' + ED + FN;
  end;
  FindClose(sr);
end;

function TfrmEditBox.ShowEditBox(var AValue: string): boolean;
// Importer's main settings file specifies what type of value the setting can be
// set to, e.g. fixed list, file name, folder name, free text.
// This function reacts to the type of setting and displays either a drop down
// list or an edit box as appropriate. It also enables the Select button to
// allow the user to browse for a file or folder.
// If a setting has a fixed set of possible values, these will have been defined in the main
// Importer settings file in a section named the same as the setting.
// If this procedure finds there is such a section, the drop down list is populated with the
// possible values and the ItemIndex is set to the current value.
// Otherwise, the setting is a free-format value and the edit box is displayed.
begin
  FSettingUp:= true; // prevent OnChange events from changing enabled buttons while we're still setting up

  FValues := TStringList.create;
  try
    DoSettingEditTypes; // v.061 - swapped with DoCaptions

    DoCaptions;

    DoIncludeField;

    DoDisplay;

    DoSelectElipsis;

    DoDisplayTab;

    DoSizeEditBox;
  finally
    FValues.Free;
  end;

  btnOK.Enabled           := false;
  cbIncludeField.visible  := not IniSetting;
  lblIncludeField.Visible := cbIncludeField.Visible;

  btnPresets.Enabled      := edtValue.visible;


//*** TEST
//  TestRelPaths;

  FSettingUp             := false; // finished setting up - OnChange events are ok to fire now

  if ShowModal = mrOK then begin
    AValue := FNewValue; // set returned value
    result := true;
  end
  else
    result := false;
end;

procedure TFrmEditBox.DoCaptions;
begin
  if FCaption <> '' then
    lblSettingName.Caption := trim(FCaption)
  else
    lblSettingName.Caption := trim(FSettingName);

  lblSettingName2.Caption  := lblSettingName.Caption;
  lblDataType.Caption    := FDataTypeCaption;
  if FMaxLength = 0 then
    lblMaxLen.Caption      := ''
  else
    lblMaxLen.Caption    := 'Maximum length = ' + IntToStr(FMaxLength);
  edtValue.MaxLength     := FMaxLength;
  edtMsg.Text            := FMsg;

  if lblDataType.Caption <> '' then begin                           // position MaxLen and DataType labels side by side.
    lblDataType.Left     := lblMaxLen.Left;                         // These two labels have changed since their original design
    lblDataType.Caption  := lblDataType.Caption + ',';              // when only one or maybe both had captions at display time.
    lblMaxLen.Left       := lblMaxLen.Left + lblDataType.Width + 5; // Some of the original code has been removed from this block
  end;                                                              // Which is why it probably seems odd to now swap them round.
end;

procedure TfrmEditBox.DoDisplay;
// Setup what's displayed to the user depending on the SettingType
var
  i: integer;
begin
    case FSettingType of
        stFixedList: begin  // if its a fixed list then load the possible values
                          cbValue.Clear;
                          lblMaxLen.Caption := ''; // irrelevant
                          for i := 0 to FValues.Count - 1 do
                            if (FValues.Names[i] <> 'Type') and (FValues.Names[i] <> 'Warning') then // ignore the Type and Warning directives
                              cbValue.Items.Add(FValues.Names[i]);
//                          cbValue.Items.Add(' ');
                          cbValue.Sorted      := true;
                          cbValue.ItemIndex   := cbValue.Items.IndexOf(FCurrentValue);
                          cbValue.Visible     := true;
                          edtValue.Visible    := false;
                          lblMaxLen.Caption   := '';
                          lblDataType.Caption := '';
                     end;
        stWordBool, stBoolean: begin
                                 cbValue.Clear;
                                 lblMaxLen.Caption := ''; // irrelevant
                                 if FCurrentValue = '' then begin // if no current value then user selects from Yes or No
                                   cbValue.Items.Add('Yes');
                                   cbValue.Items.Add('No');
                                 end else begin                   // otherwise we match their possible choices to the current value
                                   case FCurrentValue[1] of
                                   'n', 'N', 'y', 'Y': begin
                                                         cbValue.Items.Add('Yes');
                                                         cbValue.Items.Add('No');
                                                       end;
                                   '1', '0':           begin
                                                         cbValue.Items.Add('1');
                                                         cbValue.Items.Add('0');
                                                       end;
                                   'f', 'F', 't', 'T': begin
                                                         cbValue.Items.Add('True');
                                                         cbValue.Items.Add('False');
                                                       end;
                                   end;
                                   case FCurrentValue[1] of
                                     '1', 'y', 'Y', 't', 'T': cbValue.ItemIndex := 0; // set dropdown to display current value
                                     '0', 'n', 'N', 'f', 'F': cbValue.ItemIndex := 1;
                                   end;
                                 end;
                                 cbValue.Visible   := true;
                                 edtValue.Visible  := false;
                               end;
        stDataPath: begin // no longer used now that user doesn't manually set which company data path gets imported into
                      if trim(edtValue.Text) = '' then begin
                        edtValue.Text := LoginCompany;
                        btnOK.Enabled := true;
                      end;
                    end;
        else begin
          edtValue.Text     := FCurrentValue;
          edtValue.Visible  := true;  // display the edit box
          cbValue.Visible   := false; // hide the combo box
          edtValue.Enabled  := true;
        end;
    end;
end;

procedure TfrmEditBox.DoDisplayTab;
// Display the AutoInc tab or the edit box tab ?
var
  Counter: string;
begin
  tsAutoInc.TabVisible := cbAutoIncReset.Items.Count <> 0; // only display if Record Types supplied (by MapMaint)
  if (length(FCurrentValue) > 0) and AutoIncCounter(FCurrentValue) then begin  // is the current value an AutoInc counter ?
    Counter             := copy(FCurrentValue, 2, 8); // strip out [ and ]RT from [AutoIncx]RT
    cbAutoInc.ItemIndex := cbAutoInc.Items.IndexOf(Counter);
    if length(FCurrentValue) > 10 then // was there an RT attached ?
      SetAutoIncReset(copy(FCurrentValue, 11, 2)) // yes, display in the drop down
    else
      cbAutoIncReset.ItemIndex := -1;             // no, display nothing in the drop down
    pc.ActivePage       := tsAutoInc;
  end
  else
    pc.ActivePage       := tsValue;
end;

procedure TfrmEditBox.DoIncludeField;
begin
  cbIncludeField.Checked := IncludeField(FCurrentValue);
  if cbIncludeField.Checked then
    FCurrentValue := copy(FCurrentValue, 4, length(FCurrentValue) - 3); // remove the [I] prefix from the default value
end;

procedure TfrmEditBox.DoSelectElipsis;
// Should the SelectElipsis button be visible ?
begin
  case FSettingType of
    stFolder,
    stFile,
    stFileorPathWithMask: begin
                            btnSelectElipsis.Visible := true;
                            btnSelectElipsis.Enabled := true;
                          end;
  else
    btnSelectElipsis.Visible := false; // No
  end;
end;

procedure TfrmEditBox.DoSettingEditTypes;
// Find SettingType and EditType: SettingType determines what kind of field is
// being edited; EditType determines what characters can be typed.
// Firstly, check whether the SettingName has its own section in the main
// settings file: for job settings, this will be the name of the setting, for
// field maps this will be the user-friendly field name.
// If the section is found, the field type is determined from the settings
// file, otherwise we use the data type supplied by the caller.
var
  SectionFound: boolean;
  MaxLen: integer;
begin
  SectionFound := false;

  if FSettingName <> '' then begin
    IniFile.ReturnValuesInList(FSettingName, FValues);
    SectionFound := FValues.Count <> 0;
    if SectionFound then begin                    // what type of setting is it ?
      FSettingType := SettingTypeFromString(FValues.Values['Type']);
      FEditType    := DataTypeFromSettingType(FSettingType);
      FWarning     := FValues.Values['Warning'];
      FDataTypeCaption := DataTypeDescription(FEditType);
      try MaxLen   := StrToInt(FValues.Values['MaxLen']); except MaxLen := 0; end;
      FMaxLength   := FieldWidth(FEditType, MaxLen);
    end;
  end;

  if not SectionFound then begin
    if FDataType <> ' ' then begin
      FEditType    := FDataType;
      FSettingType := SettingTypeFromDataType(FDataType);
    end
    else begin
      FSettingType := stFreeText;
      FEditType := DataTypeFromSettingType(FSettingType);
    end;
  end;
end;

procedure TfrmEditBox.DoSizeEditBox;
// Try to resize the EditBox if there is a maximum length set for the value.
// Calculate a rough average width per character in pixels depending on
// whether the value is numeric or alphanumeric.
// As this is a rough and ready calculation we add a bit, e.g. 25%
// However, for really long and really short lengths the more inappropriate a stock +25% looks.
// So, for lengths greater then 10 characters we only add 10%, for 5-10 we add
// 25% and for small fields we add 30%.
// If the resultant width of the lblSettingName caption and the edit box means
// they can now sit side by side where the edit box is at design-time then we
// shift them coz they look silly positioned vertically especially if the
// edit box is really small.
var
  AvgWidth: integer;
  OldWidth: integer;
  NewWidth: integer;
begin
  if FMaxLength = 0 then exit; // if there's no maximum length then leave edit box at it's current size
  if cbValue.Visible then exit; // if we're displaying the dropdown list leave it as is

  case FSettingType of
    stDouble, stSmallInt, stLongint, stByte:
      AvgWidth := lblMaxLen.Canvas.TextWidth('1234567890') div 10;
  else
    AvgWidth := lblMaxLen.Canvas.TextWidth('ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789') div 62;
  end;

  NewWidth := (FMaxLength + 1) * AvgWidth; // calculate a preliminary new width for the edit box
  if FMaxLength > 10 then                  // adjust this width according to the maximum length of the field
    NewWidth := NewWidth + round(NewWidth * 0.1)
  else
    if FMaxLength > 5 then
      NewWidth := NewWidth + round(NewWidth * 0.25)
    else
      NewWidth := NewWidth + round(NewWidth * 0.3);

  if NewWidth > edtValue.Width then exit; // if its wider than edit box is at design time then leave as is

  OldWidth       := edtValue.Width;       // remember the design-time width
  edtValue.Width := NewWidth;             // change the run-time width

  if lblSettingName.Width + edtValue.Width + 10 <= OldWidth then begin // is there room to place the label and the edit next to each other ?
    edtValue.left := edtValue.Left + lblSettingName.Width + 10; // move edtValue right far enough to move label down next to it
    lblSettingName.Top := edtValue.Top + 5;                     // move label down and line up neatly with edit box
  end;
end;

procedure TfrmEditBox.SetAutoIncReset(ART: string);
// Displays the entry in cbAutoIncReset that corresponds to the supplied Record Type
var
  i: integer;
begin
  for i := 0 to cbAutoIncReset.Items.Count - 1 do
    if copy(cbAutoIncReset.Items[i], length(cbAutoIncReset.Items[i]) - 2, 2) = ART then begin
      cbAutoIncReset.ItemIndex := i;
      break;
    end;
end;

{* Event Procedures *}

procedure TfrmEditBox.btnOKClick(Sender: TObject);
// if the user selects an AutoInc counter with a reset record type the value
// is returned as [AutoIncx]RT with the counter enclosed in square brackets
// and the two-char record type immediately following the closing square bracket.
begin
  FNewValue := '';

  if cbAutoInc.ItemIndex <> -1 then begin
    if cbAutoInc.ItemIndex > 0 then begin // was an AutoInc counter selected ? n.b. [0] = ''
      FNewValue := '[' + cbAutoInc.Text + ']'; // enclose in []
      if cbAutoIncReset.ItemIndex > 0 then // something other than blank was selected
        FNewValue := FNewValue + copy(cbAutoIncReset.Text, length(cbAutoIncReset.Text) - 2, 2); // append 2-char record type
    end;
    exit;
  end;

  case FSettingType of
    stFolder:    if edtValue.Text <> '' then
                   FNewValue := IncludeTrailingPathDelimiter(edtValue.Text);
    stFixedList: FNewValue := cbValue.Text;
    stWordBool,
    stBoolean:   if cbValue.ItemIndex <> -1 then
                   FNewValue := cbValue.Text[1]; // just return the T of True or the Y of Yes etc.
  else
    FNewValue := edtValue.Text;
  end;

  if cbIncludeField.Checked then
    FNewValue := '[I]' + FNewValue;
end;

procedure TfrmEditBox.cbValueChange(Sender: TObject);
begin
  ChangeOfValue;
end;

procedure TfrmEditBox.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  action := caFree;
  frmEditBox := nil;
end;

procedure TfrmEditBox.btnSelectClick(Sender: TObject);
begin
  if FSettingType = stFileorPathWithMask then
    MenuPopup(PopupMenu1, btnSelectElipsis)
  else
    SelectItem(FSettingType);
end;

procedure TfrmEditBox.edtValueKeyPress(Sender: TObject; var Key: Char);
begin
  Key := ValidKeyPress(Key, FEditType, pos('.', edtValue.text));
end;

procedure TfrmEditBox.edtValueChange(Sender: TObject);
begin
  ChangeOfValue;
end;

procedure TfrmEditBox.FormShow(Sender: TObject);
begin
  if pc.ActivePage = tsValue then begin
    ShiftFocus(handle, edtValue); // whichever is enabled will get the focus
    ShiftFocus(handle, cbValue);
  end;
  if FWarning <> '' then
    DisplayWarning;
end;

procedure TfrmEditBox.FormKeyPress(Sender: TObject; var Key: Char);
// translate the Enter key into a tab key
begin
  if key = #13 then begin
    SendMessage(Handle, WM_NEXTDLGCTL, 0, 0);
    key := #0;
  end;
end;

procedure TfrmEditBox.SelectItem(ASettingType: TSettingType);
// display the appropriate dialog box for the user to select an item.
begin
  case ASettingType of
    stFile:     begin
                  if FOpenDialog.Execute then begin
//                    edtValue.Text := RelativePath(FOpenDialog.FileName) + ExtractFileName(FOpenDialog.FileName);
                    edtValue.Text := FOpenDialog.FileName;
                    btnOK.Enabled := true;
                  end;
                end;
    stFolder:   begin
                  if FBrowseFolderDialog.Execute then begin
//                    edtValue.Text := RelativePath(IncludeTrailingPathDelimiter(FBrowseFolderDialog.FolderName));
                    edtValue.Text := IncludeTrailingPathDelimiter(FBrowseFolderDialog.FolderName);
                    btnOK.Enabled := true;
                  end;
                end;
    stDataPath: begin
                    edtValue.Text := LoginCompany;
                    btnOK.Enabled := true;
                end;
  end;
  if btnOK.Enabled and (ASettingType = stFolder) and (FSettingType = stFileOrPathWithMask) then
    edtValue.Text := edtValue.Text + '*.*';
end;

procedure TfrmEditBox.SelectFileClick(Sender: TObject);
begin
  SelectItem(stFile);
end;

procedure TfrmEditBox.SelectFolderClick(Sender: TObject);
begin
  SelectItem(stFolder);
end;

procedure TfrmEditBox.btnClearClick(Sender: TObject);
// no longer used
begin
  cbValue.ItemIndex        := -1;
  edtValue.Text            := '';
  cbAutoInc.ItemIndex      := -1;
  cbAutoIncReset.ItemIndex := -1;
  btnOK.Enabled            := true;
//  btnClear.Enabled         := false;
end;

procedure TfrmEditBox.FormCreate(Sender: TObject);
begin
  btnSelectElipsis.Height := edtValue.Height - 2;
  btnSelectElipsis.Top    := edtValue.Top + 1;
  btnSelectElipsis.Left   := (edtValue.Left + edtValue.Width) - btnSelectElipsis.Width - 1;
end;

procedure TfrmEditBox.FormKeyUp(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  if key = VK_ESCAPE then close;
end;

procedure TfrmEditBox.cbAutoIncChange(Sender: TObject);
begin
  ChangeOfValue;
end;

procedure TfrmEditBox.cbAutoIncResetChange(Sender: TObject);
begin
  ChangeOfValue;
end;

procedure TfrmEditBox.lblMoreInfoMouseEnter(Sender: TObject);
begin
  with lblMoreInfo.Font do
    Style := Style + [fsUnderline];
  Screen.Cursor := crHandPoint;
end;

procedure TfrmEditBox.lblMoreInfoMouseLeave(Sender: TObject);
begin
  with lblMoreInfo.Font do
    Style := Style - [fsUnderline];
  Screen.Cursor := crDefault;
end;

{* Getters and Setters *}

procedure TfrmEditBox.SetBrowseFolderDialog(const Value: TpsvBrowseFolderDialog);
begin
  FBrowseFolderDialog := Value;
end;

procedure TfrmEditBox.SetCaption(const Value: string);
begin
  FCaption := Value;
end;

procedure TfrmEditBox.SetCurrentValue(const Value: string);
begin
  FCurrentValue := Value;
end;

procedure TfrmEditBox.SetDataType(const Value: char);
begin
  FDataType := Value;
end;

procedure TfrmEditBox.SetDataTypeCaption(const Value: string);
begin
  FDataTypeCaption := Value;
end;

procedure TfrmEditBox.SetIniSection(const Value: string);
begin
  FIniSection := Value;
end;

procedure TfrmEditBox.SetMaxLength(const Value: integer);
begin
  FMaxLength := Value;
end;

procedure TfrmEditBox.SetMsg(const Value: string);
begin
  FMsg := Value;
end;

procedure TfrmEditBox.SetOpenDialog(const Value: TOpenDialog);
begin
  FOpenDialog := Value;
end;

procedure TfrmEditBox.SetSettingName(const Value: string);
begin
  FSettingName := Value;
end;

procedure TfrmEditBox.btnCancelClick(Sender: TObject);
begin
  close;
end;

procedure TfrmEditBox.cbIncludeFieldClick(Sender: TObject);
begin
  ChangeOfValue;
end;

procedure TfrmEditBox.SetIniSetting(const Value: boolean);
begin
  FIniSetting := Value;
end;

procedure TfrmEditBox.DisplayWarning;
var
  PosBackSlash: integer;
begin
//  StringReplace(FWarning, '\', #13#10, [rfReplaceAll]); didn't do anything !
  PosBackSlash := pos('\', FWarning);
  while PosBackSlash <> 0 do begin
    Delete(FWarning, PosBackSlash, 1);
    Insert(#13#10, FWarning, PosBackSlash);
    PosBackSlash := pos('\', FWarning);
  end;
  MessageDlg(FWarning, mtWarning, [mbOK], 0);
end;

procedure TfrmEditBox.SystemDate1Click(Sender: TObject);
begin
  edtValue.Text := '%sysdate%';
end;

procedure TfrmEditBox.btnPresetsClick(Sender: TObject);
begin
  MenuPopup(pumPresets, btnPresets);
end;

initialization
  frmEditBox := nil;
end.
