unit IniRecMaint;

{******************************************************************************}
{     The main Importer settings file contains sections which conform to       }
{     a TFieldDef record. This form displays the contents of one such record   }
{     as a line of text, straight out of the settings file, allows the text    }
{     to be edited but only written back to the settings file if the amended   }
{     line still conforms to a TFieldDef record layout.                        }
{******************************************************************************}

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, uMultiList, Menus;

type
  TfrmIniRecMaint = class(TForm)
    GroupBox1: TGroupBox;
    edtIniRecord: TEdit;
    GroupBox2: TGroupBox;
    lblRecordSize: TLabel;
    lblRecordDefinition: TLabel;
    mlIniRecord: TMultiList;
    lblDelphiDef: TStaticText;
    btnSaveClose: TButton;
    btnCancel: TButton;
    btnApplyEdits: TButton;
    btnSetDefault: TButton;
    btnSetComment: TButton;
    lblTemplate: TLabel;
    GroupBox3: TGroupBox;
    lblOVRINS: TLabel;
    btnSaveNext: TButton;
    PopupMenu1: TPopupMenu;
    mniProperties: TMenuItem;
    mniSaveCoordinates: TMenuItem;
    btnSaveAdd: TButton;
    GroupBox4: TGroupBox;
    lblNum: TLabel;
    lblFieldDesc: TLabel;
    lblPrompt: TLabel;      // v.064
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure btnCancelClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure btnApplyEditsClick(Sender: TObject);
    procedure edtIniRecordKeyPress(Sender: TObject; var Key: Char);
    procedure btnSetDefaultClick(Sender: TObject);
    procedure btnSetCommentClick(Sender: TObject);
    procedure FormKeyUp(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure btnSaveCloseClick(Sender: TObject);
    procedure btnSaveNextClick(Sender: TObject);
    procedure edtIniRecordKeyUp(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure edtIniRecordChange(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure mniPropertiesClick(Sender: TObject);
    procedure mniSaveCoordinatesClick(Sender: TObject);
    procedure btnSaveAddClick(Sender: TObject);
  protected
    constructor createEx(ValueName: string);
  private
{* internal fields *}
    FBlankOK: boolean;
    FExchOrIAO: boolean;
    FFieldType: boolean;
    FIniRecord: string;
    FValueName: string;
    FNumLock: boolean;
    FRecordNo: integer;
    FFirstCall: boolean;
    FPosFieldDesc: integer; // v.064
    FLenFieldDesc: integer; // v.064
    FSpace: boolean;
    FUsage: boolean;
{* procedural methods *}
    procedure ApplyEdits;
    procedure CancelAndClose;
    procedure CheckCaretPos(AutoInsert: boolean);
    procedure GetInsertKeyStatus;
    procedure InsertStorageLength;
    procedure LoadRecord;
    procedure SaveAndAdd;     // v.064
    procedure SaveAndClose;
    procedure SaveAndNext;
    procedure SetComment;
    procedure SetDefault;
    procedure SetInitialCaretPos;
{* Message Handlers *}
    procedure WMMoving(var msg: TMessage); message WM_MOVING;
  public
    class procedure Show(ValueName: string);
  end;

implementation

uses TIniClass, IniMaint, GlobalTypes, Utils, EntLicence, StrUtils;

{$R *.dfm}

const
  FieldTypeCaretPos  = 38; // where caret is when you type the Field Type character in edtIniRecord
  InsertPos          = 39; // position to automatically insert the field width info based on the Field Type
  NewCaretPos        = 44; // where the caret needs to be positioned after the auto-insert
   Space1Pos         = 28;
  OffsetPos          = 29; // where the caret needs to be positioned for entering the Offset
   Space2Pos         = 33;
  OccursPos          = 34;
   Space3Pos         = 36;
  TypePos            = 37;
   Space4Pos         = 38;
  WidthPos           = 39;
   Space5Pos         = 43;
  UsagePos           = 44;
   Space6Pos         = 45;
  ExchOrIAOPos       = 46;
   Space7Pos         = 47;
  FieldDescPos       = 48;
  AfterRTDotPos      = 02; // where the caret needs to be positioned when just the RT and the dot are present

var
  frmIniRecMaint: TfrmIniRecMaint;

{ TfrmIniRecMaint }

class procedure TfrmIniRecMaint.Show(ValueName: string);
begin
  if not assigned(frmIniRecMaint) then
    frmIniRecMaint := TfrmIniRecMaint.CreateEx(ValueName);

// inherited Show
  frmIniRecMaint.visible := true;
  frmIniRecMaint.BringToFront;
  frmIniRecMaint.FormActivate(nil);
//  frmIniRecMaint.ShowModal;
end;

constructor TfrmIniRecMaint.createEx(ValueName: string);
var
  tmpIniRecord: TFieldDef;
begin
  inherited create(application);

  if EnterpriseLicence.IsLITE then begin
    caption := 'Edit IRIS Accounts Office Field Definition';
    lblRecordDefinition.Caption := 'IRIS Accounts Office Field Definition';
  end;

  FormLoadSettings(Self, nil);
  MLLoadSettings(mlIniRecord, Self);

  FValueName := ValueName;
  FRecordNo := IniFile.CurrentSectionValues.IndexOfName(ValueName);

  edtIniRecord.MaxLength := SizeOf(TFieldDef)  - SizeOf(tmpIniRecord.FieldDefType)
                                               - SizeOf(tmpIniRecord.FieldNo)
                                               - SizeOf(tmpIniRecord.equals);

  FFirstCall := true;

  LoadRecord;

  FPosFieldDesc := integer(@tmpIniRecord.FieldDesc) - integer(@tmpIniRecord.RecordType) + 1;      // v.064
  FLenFieldDesc := integer(@tmpIniRecord.DefaultEquals) - integer(@tmpIniRecord.FieldDesc) - 1;   // v.064

  lblPrompt.Caption    := '';
  lblFieldDesc.Caption := '';

//  SetConstraints(Constraints, height, width);
end;

{* Procedural Methods *}

procedure TfrmIniRecMaint.ApplyEdits;
begin
  IniFile.CurrentSectionValue[FValueName] := trim(edtIniRecord.Text);
  LoadRecord; // repopulate the ML's columns with the new values
end;

procedure TfrmIniRecMaint.CancelAndClose;
// restore TIni's pre-modified copy of the Field Def and close this form
begin
  IniFile.FieldDefCancelUpdate;
  close;
end;

procedure TfrmIniRecMaint.CheckCaretPos(AutoInsert: boolean);  // v.064
// Display various prompts to the user or perform various AutoInserts
// depending on where the caret is in the text box.
// AutoInsert is set to false by the caller if the user is moving back and forth
// through the edit box using the left and right arrow keys or if they press the
// insert key to toggle INS/OVR mode. Failure to do this would result in
// the field offset and field width being inserted multiple times.
// Auto-insert is therefore limited to when the user arrives at a caret position
// during normal typing.
const
  LeftMargin = 192;
var
  SS: integer;
  IniRecord: string;
begin
  FNumLock   := false;
  FBlankOK   := false;
  FFieldType := false;
  FUsage     := false;
  FExchOrIAO := false;
  FSpace     := false;

  lblPrompt.Caption := '';
  SS := edtIniRecord.SelStart; // position of caret

  if (SS = Space1Pos) or (SS = Space2Pos) or (SS = Space3Pos) or
     (SS = Space4Pos) or (SS = Space5Pos) or (SS = Space6Pos) or (SS = Space7Pos) then begin
      lblPrompt.caption := DupeString(' ', SS) + '^'#13#10 + DupeString(' ', SS) + 'Mandatory space';
      FSpace := true;
      if AutoInsert then begin
        IniRecord := edtIniRecord.Text;
        Insert(' ', IniRecord, SS + 1); // caret sits before the character position
        edtIniRecord.text := IniRecord;
        edtIniRecord.SelStart := SS + 1;
        CheckCaretPos(AutoInsert);
      end;
  end

  else

  if (SS = OffsetPos) and AutoInsert then begin
    edtIniRecord.PasteFromClipboard;
    edtIniRecord.SelStart := TypePos;
    CheckCaretPos(AutoInsert);
  end

  else

  if (SS >= OffsetPos) and (SS < OccursPos - 1) then begin
    lblPrompt.caption := DupeString(' ', OffsetPos) + '^^^^'#13#10 + DupeString(' ', OffsetPos) + 'Field Offset';
    FNumLock := true;
  end

  else

  if (SS >= OccursPos) and (SS < TypePos - 1) then begin
    lblPrompt.caption := DupeString(' ', OccursPos) + '^^'#13#10 + DupeString(' ', OccursPos) + 'Occurs n times. For one, leave blank.';
    FNumLock := true;
    FBlankOk := true;
  end

  else

  if (SS >= TypePos) and (SS < WidthPos - 1) then begin
    lblPrompt.caption := DupeString(' ', TypePos) + '^'#13#10 + DupeString(' ', TypePos) + 'Field Type: S, C, B, I, D, W, L, b';
    FFieldType := true;
  end

  else

  if (SS >= WidthPos) and (SS < UsagePos - 1) then begin
    lblPrompt.caption := DupeString(' ', WidthPos) + '^^^^'#13#10 + DupeString(' ', WidthPos) + 'Field Width';
    FNumLock := true;
  end

  else

  if (SS >= UsagePos) and (SS < ExchOrIAOPos - 1) then begin
    lblPrompt.caption := DupeString(' ', UsagePos) + '^'#13#10 + DupeString(' ', UsagePos) + 'Usage: F, M, O, R, N';
    FUsage := true;
  end

  else

  if (SS >= ExchOrIAOPos) and (SS < FieldDescPos - 1) then begin
    lblPrompt.caption := DupeString(' ', ExchOrIAOPos) + '^'#13#10 + DupeString(' ', ExchOrIAOPos) + 'eX-chequer only, I-AO only or blank';
    FExchOrIAO := true;
  end;

  if FNumLock then
    lblNum.Font.Color := clBlack
  else
    lblNum.Font.Color := clInactiveCaptionText;
end;

procedure TfrmIniRecMaint.GetInsertKeyStatus;
// is the Insert key toggled on or off ?
var
  Overtype: boolean;
begin
  OverType := not Odd(GetKeyState(VK_INSERT));
  if OverType then
    lblOVRINS.caption := 'OVR'
  else
    lblOVRINS.Caption := 'INS';
end;

procedure TfrmIniRecMaint.InsertStorageLength;
// automatically fills in the storage length for Doubles, SmallInts, Longints, WordBools and booleans
// if the user types D, I, L, W or b in the correct place
var
  IniRecord: string;
  FieldLength: string;
begin
  if (edtIniRecord.text[FieldTypeCaretPos] = 'D') then begin
   IniRecord := edtIniRecord.Text;
   FieldLength := format(' %.4d ', [SizeOf(Double)]);
   Insert(FieldLength, IniRecord, InsertPos);
   edtIniRecord.text := IniRecord;
   edtIniRecord.SelStart := NewCaretPos;
  end else
  if (edtIniRecord.text[FieldTypeCaretPos] = 'I') then begin
   IniRecord := edtIniRecord.Text;
   FieldLength := format(' %.4d ', [SizeOf(SmallInt)]);
   Insert(FieldLength, IniRecord, InsertPos);
   edtIniRecord.text := IniRecord;
   edtIniRecord.SelStart := NewCaretPos;
  end else
  if (edtIniRecord.text[FieldTypeCaretPos] = 'L') then begin
   IniRecord := edtIniRecord.Text;
   FieldLength := format(' %.4d ', [SizeOf(LongInt)]);
   Insert(FieldLength, IniRecord, InsertPos);
   edtIniRecord.text := IniRecord;
   edtIniRecord.SelStart := NewCaretPos;
  end else
  if (edtIniRecord.text[FieldTypeCaretPos] = 'W') then begin
   IniRecord := edtIniRecord.Text;
   FieldLength := format(' %.4d ', [SizeOf(WordBool)]);
   Insert(FieldLength, IniRecord, InsertPos);
   edtIniRecord.text := IniRecord;
   edtIniRecord.SelStart := NewCaretPos;
  end else
  if (edtIniRecord.text[FieldTypeCaretPos] = 'b') then begin
   IniRecord := edtIniRecord.Text;
   FieldLength := format(' %.4d ', [SizeOf(boolean)]);
   Insert(FieldLength, IniRecord, InsertPos);
   edtIniRecord.text := IniRecord;
   edtIniRecord.SelStart := NewCaretPos;
  end;
end;

procedure TfrmIniRecMaint.LoadRecord;
// Loads a TFieldDef record from TIni and populates the ML columns
begin
  FIniRecord := IniFile.CurrentSectionValue[FValueName]; // get the TFieldDef line from the main settings file

  edtIniRecord.Text := trim(FIniRecord);

  if FFirstCall then begin
    IniFile.LoadRecord(FRecordNo); // Get TIni to load this record into its internal Field Def area
    FFirstCall := false;           // so we can amend it using the IniFile.fdxxxxx properties
  end;

  mlIniRecord.ClearItems;
  IniFile.ReturnFieldDefInML(mlIniRecord); // populate the ML's columns from the TFieldDef record
  mlIniRecord.Selected := 0;

  if (IniFile.ValidFieldDef(IniFile.FieldDef))
  or (IniFile.fdFieldNo = '000') then begin             // if the line conforms to a TFieldDef record layout
    mlIniRecord.HighlightFont.Color := clWhite;         // display the line in white.....
    btnSaveNext.Enabled             := true;
    btnSaveClose.Enabled            := true;
    btnSaveAdd.Enabled              := true;            // v.064
  end
  else begin
    mlIniRecord.HighlightFont.Color := clRed;           // otherwise highlight it in red
    btnSaveNext.Enabled             := false;
    btnSaveClose.Enabled            := false;
    btnSaveAdd.Enabled              := false;           // v.064
  end;

  lblDelphiDef.Caption := IniFile.fdDelphiDef;         // get the Delphi definition of the Field Def
  lblRecordSize.caption := format('(Record Size = %d bytes)', [IniFile.RecordSize]); // and the overall size of the record defined in the current [section]
end;

procedure TfrmIniRecMaint.SaveAndClose;
begin
  IniFile.WriteFieldDef(FRecordNo, true);      // write the record to the .ini file
  close;                                       // close this form
  TfrmIniMaint.RefreshRecord(FRecordNo, false); // Refresh the record in TIniMaint - don't redisplay this form
end;

procedure TfrmIniRecMaint.SaveAndNext;
begin
  IniFile.WriteFieldDef(FRecordNo, true);     // write the record to the .ini file
  close;                                      // close this form
  TfrmIniMaint.RefreshRecord(FRecordNo, true); // Refresh the record in TIniMaint - redisplay this form with the next record
end;

procedure TfrmIniRecMaint.btnSaveAddClick(Sender: TObject);
begin
  SaveAndAdd;
end;

procedure TfrmIniRecMaint.SaveAndAdd; // v.064
begin
  IniFile.WriteFieldDef(FRecordNo, true);       // write the record to the .ini file
  close;                                        // close this form
  TfrmIniMaint.RefreshRecord(FRecordNo, false); // Refresh the record in TIniMaint, don't redisplay with the next record
  TfrmIniMaint.AddNewRecord;                    // add a new record and re-display this form
end;

procedure TfrmIniRecMaint.SetComment;
// Set the "comment=" part of the record in the correct place
begin
  IniFile.CurrentSectionValue[FValueName] := trim(edtIniRecord.Text); // set =value part so we don't lose other edits prior to the user clicking the button
  IniFile.fdCommentEquals := 'comment=';
  LoadRecord; // repopulate the ML's columns with the new values
end;

procedure TfrmIniRecMaint.SetDefault;
// Set the "default=" part of the record in the correct place
begin
  IniFile.CurrentSectionValue[FValueName] := trim(edtIniRecord.Text); // set =value part so we don't lose other edits prior to the user clicking the button
  IniFile.fdDefaultEquals := 'default=';
  LoadRecord; // repopulate the ML's columns with the new values
end;

procedure TfrmIniRecMaint.SetInitialCaretPos;
begin
   edtIniRecord.SetFocus;
   edtIniRecord.SelLength := 0;
   if length(edtIniRecord.Text) = 2 then begin            // v.064, if the record only contains a record type,
     edtIniRecord.Text := edtIniRecord.Text + '.';        // v.064, add the required dot,
     edtIniRecord.SelStart := AfterRTDotPos;              // v.064, and position the caret after it
   end                                                    // v.064
   else                                                   // v.064
     edtIniRecord.SelStart := OffsetPos - 1;              // otherwise position at the Offset field

   CheckCaretPos(false); // cause the prompt to be displayed
end;

{* Event Procedures *}

procedure TfrmIniRecMaint.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  if mniSaveCoordinates.Checked then
    FormSaveSettings(Self, nil);
  action := caFree;
  frmIniRecMaint := nil;
end;

procedure TfrmIniRecMaint.btnCancelClick(Sender: TObject);
begin
  CancelAndClose;
end;

procedure TfrmIniRecMaint.FormShow(Sender: TObject);
begin
  btnApplyEdits.SetFocus;
  GetInsertKeyStatus;
end;

procedure TfrmIniRecMaint.btnApplyEditsClick(Sender: TObject);
var
  FieldDesc: string;
  IniSection: string;
begin
  ApplyEdits;

  if length(edtIniRecord.Text) > (FPosFieldDesc + FLenFieldDesc) then begin     // v.064
    FieldDesc := trim(copy(edtIniRecord.Text, FPosFieldDesc, FLenFieldDesc));   // v.064, get the field description
    IniSection := IniFile.FindFieldDesc(FieldDesc);                             // v.064, has it already been used
    if IniSection <> '' then                                                    // v.064
      lblFieldDesc.Caption := 'N.B. ' + IniSection + ' already has a field called "' + FieldDesc + '"'    // v.064
    else
      lblFieldDesc.Caption := '';
  end;
  lblFieldDesc.Visible := true;

  if btnSaveAdd.Enabled then
    btnSaveAdd.SetFocus;
end;

procedure TfrmIniRecMaint.edtIniRecordKeyPress(Sender: TObject; var Key: Char);
// allows a TEdit to emulate the insert/overwrite mode when the user presses the insert key
// If the insert key is off (overwrite) set SelLength to 1 to overwrite the character after the caret.
// Event sequence is OnKeyPress, OnChange, OnKeyUp.
// Blocks certain characters depending on where CheckCaretPos determined the caret was.
begin
//  if TCustomEdit(edtIniRecord).SelStart < 3 then begin
//    TCustomEdit(edtIniRecord).SelStart := 3; // don't let them edit the RT. part
//    key := #0;
//    exit;
//  end;

  if key = #13 then begin
    btnApplyEdits.SetFocus;
    exit;
  end;

  if key in [#8, #127] then exit; // Backspace and Del

  if FNumLock and (key = #32) and FBlankOK then // occurs field can be blank if only 1 occurrence of the field.
    exit;

  if FSpace and (key <> #32) then begin // at a mandatory space position
    key := #32; // force it to be a space
    exit;
  end;

  if FFieldType and not (key in ['S', 'C', 'B', 'I', 'D', 'W', 'L', 'b']) then begin  // Scooby Doolb !?
    key := #0;
    exit;
  end;

  if FUsage and not (key in ['F', 'M', 'O', 'R', 'N']) then begin
    key := #0;
    exit;
  end;

  if FExchOrIAO and not (key in ['X', 'I', ' ']) then begin
    key := #0;
    exit;
  end;

  if FNumLock and not (key in ['0'..'9']) then begin
    key := #0;
    exit;
  end;

  if (Sender is TCustomEdit) and not Odd(GetKeyState(VK_INSERT)) then
    with TCustomEdit(Sender) do // SelLength is not available at TEdit descendant level
      if SelLength = 0 Then // i.e. the user hasn't manually highlighted any characters to overtype
      case Key of #32..#126, #128..#255: // all printable ascii characters. #127 is DEL
        SelLength := 1;
      end;

  CheckCaretPos(false);
end;

procedure TfrmIniRecMaint.edtIniRecordKeyUp(Sender: TObject; var Key: Word; Shift: TShiftState);
var
  LeftRightIns: boolean;
begin
  LeftRightIns := (key = VK_LEFT) or (key = VK_RIGHT) or (key = VK_INSERT);
  if (edtIniRecord.SelStart = FieldTypeCaretPos) and not LeftRightIns then
    InsertStorageLength;
  CheckCaretPos(not LeftRightIns); // don't do auto inserts if the user is dobbing around using the left and right keys or presses the insert key
end;

procedure TfrmIniRecMaint.btnSetDefaultClick(Sender: TObject);
begin
  SetDefault;
end;

procedure TfrmIniRecMaint.btnSetCommentClick(Sender: TObject);
begin
  SetComment;
end;

procedure TfrmIniRecMaint.FormKeyUp(Sender: TObject; var Key: Word; Shift: TShiftState);
// if the user presses the insert key, check whether its now on or off and change the OVR/INS caption.
begin
  if key = VK_INSERT then
    GetInsertKeyStatus;
end;

procedure TfrmIniRecMaint.btnSaveCloseClick(Sender: TObject);
begin
  SaveAndClose;
end;

procedure TfrmIniRecMaint.btnSaveNextClick(Sender: TObject);
begin
  SaveAndNext;
end;

procedure TfrmIniRecMaint.edtIniRecordChange(Sender: TObject);
begin
  btnSaveNext.Enabled  := false;
  btnSaveClose.Enabled := false;
end;

procedure TfrmIniRecMaint.FormActivate(Sender: TObject);
begin
  SetInitialCaretPos;
end;

procedure TfrmIniRecMaint.mniPropertiesClick(Sender: TObject);
begin
  MLEditProperties(mlIniRecord, Self, nil);
end;

procedure TfrmIniRecMaint.mniSaveCoordinatesClick(Sender: TObject);
begin
  mniSaveCoordinates.Checked := not mniSaveCoordinates.Checked;
end;

{* Message Handlers *}

procedure TfrmIniRecMaint.WMMoving(var msg: TMessage);
begin
  WindowMoving(msg, height, width);
end;

initialization
  frmIniRecMaint := nil;

end.
