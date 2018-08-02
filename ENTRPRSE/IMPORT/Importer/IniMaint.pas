unit IniMaint;

{******************************************************************************}
{ Provides a form for maintaining the FieldDef sections of Importer's standard }
{ settings file, i.e. those sections which describe Exchequer records in       }
{ TFieldDef format (see TIni).                                                 }
{******************************************************************************}

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, uMultiList, TIniClass, ComCtrls, StdCtrls, Menus, Clipbrd;

type
  TfrmIniMaint = class(TForm)
    GroupBox3: TGroupBox;
    btnEdit: TButton;
    btnRecSizes: TButton;
    GroupBox2: TGroupBox;
    mlIniRecords: TMultiList;
    lblRecordDefinition: TLabel;
    edtStatusBar: TEdit;
    PopupMenu1: TPopupMenu;
    mniEdit: TMenuItem;
    N1: TMenuItem;
    mniProperties: TMenuItem;
    mniSaveCoordinates: TMenuItem;
    btnClose: TButton;
    btnAdd: TButton;       // v.064
    btnDelete: TButton; // v.064
    mniDelete: TMenuItem;  // v.064
    mniAdd: TMenuItem;
    btnClipboard: TButton;
    Panel1: TPanel;
    lblRecordSize: TLabel;
    lblImportRecordSize: TLabel;
    lblOffset: TLabel;
    lblAdd: TLabel;
    rbSType: TRadioButton;
    rbFType: TRadioButton;
    lblDelphiDef: TStaticText;
    Panel2: TPanel;
    Panel3: TPanel;
    Panel4: TPanel;     // v.064
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure mlIniRecordsChangeSelection(Sender: TObject);
    procedure btnCloseClick(Sender: TObject);
    procedure btnRecSizesClick(Sender: TObject);
    procedure mlIniRecordsRowDblClick(Sender: TObject; RowIndex: Integer);
    procedure btnEditClick(Sender: TObject);
    procedure btnReloadClick(Sender: TObject);
    procedure FormKeyUp(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure mniPropertiesClick(Sender: TObject);
    procedure mniSaveCoordinatesClick(Sender: TObject);
    procedure btnAddClick(Sender: TObject);
    procedure btnDeleteClick(Sender: TObject);
    procedure btnClipboardClick(Sender: TObject);
    procedure FormActivate(Sender: TObject);
  private
{* internal fields *}
    FIniSection: string;
    FMaximised: boolean;  // v.064
    FNextFieldNo: string; // v.064
{* property fields *}
{* procedural methods *}
    procedure AddRecord;  // v.064
    procedure CopyToClipboard;
    procedure EditRecord; // v.064
    function  GetFieldID(RowIndex: integer): string;
    function  GetFieldNo(RowIndex: integer): integer;
    procedure LoadFieldDefs;
    procedure LoadSection(ASection: string);
    procedure RefreshRec(RecordNo: integer; ShowNext: boolean);
    procedure ShowRecord(RowIndex: integer);
    procedure Startup;
    function  ValidFieldNo(RowIndex: integer): boolean;
    function  ValidOffset(RowIndex: integer): boolean;
{* getters and setters *}
{* Message Handlers *}
    procedure WMMoving(var msg: TMessage); message WM_MOVING;
    procedure WMSysCommand(var msg: TWMSysCommand); message WM_SYSCOMMAND;
  public
    class procedure AddNewRecord; // v.064
    class procedure RefreshRecord(RecordNo: integer; ShowNext: boolean);
    class procedure Show(AIniSection: string);
  end;


implementation

uses Utils, IniRecMaint, RecordSizes, GlobalConsts, EntLicence;

{$R *.dfm}

const
  COL_FIELDNO    = 0; // v.064
  COL_RECORDTYPE = 1; // v.064
  COL_OFFSET     = 3;
  COL_OCCURS     = 4;
  COL_TYPE       = 5;
  COL_WIDTH      = 6;

var
  frmIniMaint: TfrmIniMaint;

{ TfrmIniMaint }

class procedure TfrmIniMaint.AddNewRecord; // v.064
begin
  frmIniMaint.AddRecord;
  frmIniMaint.EditRecord;
end;

class procedure TfrmIniMaint.Show(AIniSection: string);
begin
  if not assigned(frmIniMaint) then
    frmIniMaint := TfrmIniMaint.Create(application);

  if AIniSection <> '' then
    frmIniMaint.LoadSection(AIniSection);

// inherited Show
  frmIniMaint.visible := true;
  frmIniMaint.BringToFront;
end;

class procedure TfrmIniMaint.RefreshRecord(RecordNo: integer; ShowNext: boolean);
begin
  frmIniMaint.RefreshRec(RecordNo, ShowNext);
end;

{* Procedural Methods *}

procedure TfrmIniMaint.AddRecord;
// add a new record to the end of the displayed list based on the current last
// record in the list.
var
  ix: integer;
  RT: string;
begin
  if mlIniRecords.DesignColumns[COL_RECORDTYPE].Items.Count > 0 then
    RT := mlIniRecords.DesignColumns[COL_RECORDTYPE].Items[0] // copy the current Record Type
  else
    RT := '';

  ix := mlIniRecords.DesignColumns[COL_FIELDNO].Items.Add('F999'); // add a dummy FieldNo to get the new row number in ix

  ValidFieldNo(ix); // has the side effect of setting FNextFieldNo;
  if rbSType.Checked then
    FNextFieldNo[1] := 'S'; // change to an S-Type Field Def

  IniFile.WriteString(IniFile.CurrentSection, FNextFieldNo, RT);
  IniFile.LoadIniSectionValues(IniFile.CurrentSection); // reload this section to pick up the new name=value pair

  mlIniRecords.DesignColumns[COL_FIELDNO].Items[ix] := FNextFieldNo;
  mlIniRecords.DesignColumns[COL_RECORDTYPE].Items.Add(RT); // copy the previous RT if there is one
  mlIniRecords.DesignColumns[COL_OFFSET].Items.Add('0000'); // dummy but well-formed offset value for OnChangeSelection event

  mlIniRecords.Selected := ix; // triggers OnChangeSelection event and sets up EditRecord with the correct row.

  EditRecord;
end;

procedure TfrmIniMaint.CopyToClipboard;
var
  i: integer;
  text: string;
begin
  for i := 0 to mlIniRecords.DesignColumns[COL_FIELDNO].Items.Count - 1 do begin
    IniFile.LoadRecord(i);
    text := text + '    ' + IniFile.fdDelphiDef + #13#10;
  end;
  Clipboard.SetTextBuf(pchar(text)); // IniRecMaint automatically positions at the Offset position - so the user can just ctrl-v to paste in the correct offset
  edtStatusBar.text := 'Delphi record definition copied to clipboard';
end;

procedure TfrmIniMaint.EditRecord;
begin
  if mlIniRecords.Selected = -1 then exit;
  ShowRecord(mlIniRecords.Selected);
end;

function TfrmIniMaint.GetFieldNo(RowIndex: integer): integer;
var
  FieldID: string;
begin
  result := 0;
  FieldID := GetFieldID(RowIndex);
  if length(FieldID) > 1 then
    try
      result := StrToInt(copy(FieldID, 2, 3));
    except on EConvertError do
      result := -1;
    end;
end;

function TfrmIniMaint.GetFieldID(RowIndex: integer): string;
// Field ID will be "F000" to "F999" or the "F" might be an "S" or an "A"
begin
  result := mlIniRecords.DesignColumns[COL_FIELDNO].items[RowIndex]; // v.064, changed to use constant
end;

procedure TfrmIniMaint.LoadFieldDefs;
// for each record in the section, load it into TIni's record buffer and read each field
var
  i: integer;
begin
  for i := 0 to IniFile.CurrentSectionValuesCount - 1 do begin
    IniFile.LoadRecord(i);
    IniFile.ReturnFieldDefInML(mlIniRecords);
  end;

  lblRecordSize.caption := format('(Record Size = %d bytes)', [IniFile.RecordSize]);
  lblRecordSize.Enabled := true;
end;

procedure TfrmIniMaint.LoadSection(ASection: string);
var
  i: integer;
  FieldDefs: string;
begin
  FIniSection := ASection;
  IniFile.LoadIniSectionValues(ASection);                    // read all the name=value pairs in the section
  FieldDefs   := IniFile.ReadString(FIELD_DEFS, ASection, 'NO'); // is this section listed in the [Field Defs] section ?

  lblRecordDefinition.Enabled := FieldDefs <> 'NO';
  lblRecordDefinition.Caption := 'Exchequer Record Definition - [' + ASection + ']';

  lblDelphiDef.caption  := '';
  lblRecordSize.Caption := '';
  lblImportRecordSize.Caption := '';
  lblOffset.Caption := '';

  mlIniRecords.ClearItems;

  if FieldDefs = 'NO' then // sections which don't define an Exchequer Record definition aren't listed in [Field Defs]
    exit                   // in which case its a standard name=value ini section
  else
    LoadFieldDefs;         // otherwise each line in the section conforms to a TIniRecord (in TIniU.pas)
end;

procedure TfrmIniMaint.RefreshRec(RecordNo: integer; ShowNext: boolean);
// called from IniRecMaint when the record has been changed
begin
  mlIniRecords.DeleteRow(RecordNo);            // delete the original row
  IniFile.LoadRecord(RecordNo);                // reload it into the TIniRecord structure
  IniFile.ReturnFieldDefInML(mlIniRecords);    // populate the ML's columns with the current record
  mlIniRecords.MoveRow(mlIniRecords.ItemsCount - 1, RecordNo); // put the row back in the correct place in the ML
  if RecordNo < (mlIniRecords.ItemsCount - 1) then // select the next row if there is one
    mlIniRecords.Selected := RecordNo + 1
  else
    mlIniRecords.Selected := RecordNo;
//  mlIniRecords.SetFocus;                       // doesn't work - nice thought though
  if ShowNext and (RecordNo <> mlIniRecords.ItemsCount - 1) then // user wants to immediately edit the next record ?
    ShowRecord(mlIniRecords.Selected);         // re-open frmIniRecMaint
end;

function TfrmIniMaint.ValidFieldNo(RowIndex: integer): boolean;
// Field No's are 1-based, the rows in which they are displayed are 0-based.
// So any Field No. should equal its RowIndex + 1;
// However this doesn't apply to field defs in an AutoGen section as the field
// numbers will be all over the place: 08/12/2005 - All AutoGen sections now
// only appear in .map files not in the main settings file.
begin
  if (GetFieldID(RowIndex)[1] <> 'A')      // should always be true since 8/12 mod
  and (GetFieldNo(RowIndex) <> (RowIndex + 1))
  {and (GetFieldNo(RowIndex) <> 000)} then begin  {ignored fields didn't get implemented like this}
    FNextFieldNo := format('%s%.3d', [GetFieldID(RowIndex)[1], RowIndex + 1]); // v.064, store formatted value
    edtStatusBar.Text := format('Field No should be %s', [FNextFieldNo]);      // v.064, use FNextFieldNo
    result := false;
  end else begin
//    edtStatusBar.Text := '';
    result := true;
  end;
end;

function TfrmIniMaint.ValidOffset(RowIndex: integer): boolean;
// Checks that the specified offset for a field in the record definition
// is correct based on the size of all the fields that precede it.
var
  i : integer;
  Offset: integer;
  sOffset: string;
  Occurs: integer;
begin
  result := false;
  Offset := 1;
  for i := 0 to RowIndex - 1 do begin
    Occurs := 1;
    if trim(mlIniRecords.DesignColumns[COL_OCCURS].Items[i]) <> '' then
      Occurs := StrToInt(mlIniRecords.DesignColumns[COL_OCCURS].Items[i]);
    try
      Offset := Offset + Occurs * StorageSize(mlIniRecords.DesignColumns[COL_TYPE].Items[i][1], StrToInt(mlIniRecords.DesignColumns[COL_WIDTH].Items[i]));
    except
      Offset := -1;
    end;
  end;

  sOffset := format('%.4d', [Offset]);
  Clipboard.SetTextBuf(pchar(sOffset + '    ')); // IniRecMaint automatically positions at the Offset position - so the user can just ctrl-v to paste in the correct offset
  lblOffset.Caption := 'Offset = ' + sOffset;
  if (mlIniRecords.DesignColumns[COL_OFFSET].Items[RowIndex] <> sOffset) then
    edtStatusBar.Text := format('Offset should be %s', [sOffset])
  else
    result := true;
end;

procedure TfrmIniMaint.ShowRecord(RowIndex: integer);
begin
  TfrmIniRecMaint.Show(GetFieldID(RowIndex)); // display the row in the editing window
end;

procedure TfrmIniMaint.Startup;
begin
  if EnterpriseLicence.IsLITE then begin
    caption := 'IRIS Accounts Office Record Definition';
    lblRecordDefinition.Caption := 'IRIS Accounts Office Record Definition';
  end;

  lblDelphiDef.Caption        := '';
  lblRecordSize.Caption       := '';
  lblImportRecordSize.Caption := '';
  lblOffset.Caption           := '';

  FormLoadSettings(Self, nil);
  MLLoadSettings(mlIniRecords, Self);

  MLInit(mlIniRecords);

//  SetConstraints(Constraints, height, width);
end;

{* Event Procedures *}

procedure TfrmIniMaint.FormActivate(Sender: TObject);
begin
  if FMaximised then
    ShowWindow(self.Handle, SW_MAXIMIZE);
end;

procedure TfrmIniMaint.FormCreate(Sender: TObject);
begin
  Startup;
end;

procedure TfrmIniMaint.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  if mniSaveCoordinates.Checked then
    FormSaveSettings(Self, nil);
  action := caFree;
  frmIniMaint := nil;
end;

procedure TfrmIniMaint.mlIniRecordsChangeSelection(Sender: TObject);
// 1. Do a quick-and-dirty validation of the selected record to see if the columns are in the correct places.
// 2. Display the Delphi Definition of the selected record
// 3. Display the Record Size of the entire record definition
// 4. Check whether the FieldID corresponds to the row its in
// 5. Check whether the Offset corresponds with all the fields that precede it.
var
  selected: integer;
begin
  selected := mlIniRecords.Selected;
  if selected = -1 then exit;

  IniFile.LoadRecord(selected); // load ini file record into the TIniRecord structure

  if (IniFile.ValidFieldDef(IniFile.FieldDef)) or (IniFile.fdFieldNo = '000') then
    mlIniRecords.HighlightFont.Color := clWhite
  else
    mlIniRecords.HighlightFont.Color := clRed;

  lblDelphiDef.Caption := IniFile.fdDelphiDef;

  if ValidFieldNo(mlIniRecords.Selected) and ValidOffset(mlIniRecords.Selected) then //strictly in this order
    edtStatusBar.Text := '';

  lblRecordSize.caption := format('(Record Size = %d bytes)', [IniFile.RecordSize]);
  lblImportRecordSize.caption := format('(Import Record Size = %d bytes)', [IniFile.ImportRecordSize]); // irrelevant, so visible=false
  lblRecordSize.Enabled := true;
end;

{* Event Procedures *}

procedure TfrmIniMaint.btnCloseClick(Sender: TObject);
begin
  close;
end;

procedure TfrmIniMaint.btnRecSizesClick(Sender: TObject);
begin
  TfrmRecordSizes.Show;
end;

procedure TfrmIniMaint.mlIniRecordsRowDblClick(Sender: TObject; RowIndex: Integer);
begin
//  if ValidFieldNo(RowIndex) then
    ShowRecord(RowIndex);
end;

procedure TfrmIniMaint.btnEditClick(Sender: TObject);
begin
  EditRecord;
end;

procedure TfrmIniMaint.btnReloadClick(Sender: TObject);
begin
  LoadSection(FIniSection);
end;

procedure TfrmIniMaint.FormKeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if key = VK_ESCAPE then close;
end;

procedure TfrmIniMaint.mniPropertiesClick(Sender: TObject);
begin
  MLEditProperties(mlIniRecords, Self, nil);
end;

procedure TfrmIniMaint.mniSaveCoordinatesClick(Sender: TObject);
begin
  mniSaveCoordinates.Checked := not mniSaveCoordinates.Checked;
end;

procedure TfrmIniMaint.btnAddClick(Sender: TObject); // v.064
begin
  AddRecord;
end;

procedure TfrmIniMaint.btnDeleteClick(Sender: TObject); // v.064
var
  FieldID: string;
begin
  FieldID := GetFieldID(mlIniRecords.Selected);
  if MessageDlg('Are you sure you want to delete the ' + FieldID + ' field definition ?', mtConfirmation, [mbYes, mbNo], 0) = mrYes then begin
    IniFile.DeleteKey(IniFile.CurrentSection, FieldID);
    MLDeleteSelectedRow(mlIniRecords);
  end;
end;

procedure TfrmIniMaint.btnClipboardClick(Sender: TObject);
begin
  CopyToClipboard;
end;

{* Message Handlers *}

procedure TfrmIniMaint.WMMoving(var msg: TMessage);
begin
  WindowMoving(msg, height, width);
end;

procedure TfrmIniMaint.WMSysCommand(var msg: TWMSysCommand);
begin
  case msg.CmdType of
    SC_MINIMIZE,
    SC_RESTORE:  FMaximised := false;
    SC_MAXIMIZE: FMaximised := true;
  end;
  DefaultHandler(msg);
end;

initialization
  frmIniMaint := nil;

end.
