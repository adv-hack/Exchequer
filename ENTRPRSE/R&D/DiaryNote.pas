unit DiaryNote;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, TEditVal, BorBtns, Buttons, Mask, ExtCtrls,
  SpellCheck4Modal,
  VarRec2U;

type
  TDiaryNoteMode = (dnUnknown, dnAdd, dnEdit);
  TDiaryNoteFrm = class(TForm)
    MainPnl: TPanel;
    NoteLineTxt: Text8Pt;
    NotePnl: TPanel;
    NotesLbl: Label8;
    ToLbl: Label8;
    RepeatLbl: Label8;
    DaysLbl: Label8;
    NoteAlarmChk: TBorCheck;
    NoteAlarmTxt: TEditDate;
    NoteForTxt: Text8Pt;
    NoteRepeatTxt: TCurrencyEdit;
    DatePnl: TPanel;
    DateChk: TBorCheck;
    NoteDateTxt: TEditDate;
    SpellCheck4Modal1: TSpellCheck4Modal;
    OkBtn: TButton;
    CancelBtn: TButton;
    procedure FormCreate(Sender: TObject);
    procedure NoteAlarmChkClick(Sender: TObject);
    procedure NoteForTxtExit(Sender: TObject);
    procedure EnterKeyPressHandler(Sender: TObject; var Key: Char);
    procedure EnterKeyDownHandler(Sender: TObject; var Key: Word; Shift: TShiftState);
  private
    FMode: TDiaryNoteMode;
    procedure OnAlarmStateChange;
    procedure SetMode(const Value: TDiaryNoteMode);
  public
    procedure Initialise(FromRec: NotesType);
    procedure WriteRecord(var ToNote: NotesType);
    property Mode: TDiaryNoteMode read FMode write SetMode;
  end;

var
  DiaryNoteFrm: TDiaryNoteFrm;

implementation

{$R *.dfm}

uses GlobVar, BtSupU2, ETDateU, InvListU;

{
  CJS 01/11/2010 - I have disabled the Alarm checkbox so that the user cannot
  change the state (it is always ticked). This is because this dialog is
  currently only used for adding/editing notes from the Workflow Diary, which
  only displays alarmed notes. I have left the code for handling changes to this
  checkbox in case it needs to be reverted, or in case this dialog is eventually
  used for adding/editing notes for other situations.
}

// =============================================================================
// TDiaryNoteFrm
// =============================================================================

procedure TDiaryNoteFrm.EnterKeyDownHandler(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  GlobFormKeyDown(Sender,Key,Shift,ActiveControl,Handle);
end;

// -----------------------------------------------------------------------------

procedure TDiaryNoteFrm.EnterKeyPressHandler(Sender: TObject;
  var Key: Char);
begin
  // CJS 21/03/2011 ABSEXCH-11089
  if (Key = '-') then
    Key := #0
  else
    GlobFormKeyPress(Sender,Key,ActiveControl,Handle);
end;

// -----------------------------------------------------------------------------

procedure TDiaryNoteFrm.FormCreate(Sender: TObject);
begin
  ClientHeight := 58;
  ClientWidth  := 587;
  NoteAlarmTxt.Enabled := False;
  NoteRepeatTxt.Enabled := False;
  OnAlarmStateChange;
end;

// -----------------------------------------------------------------------------

procedure TDiaryNoteFrm.Initialise(FromRec: NotesType);
begin
  DateChk.Checked := FromRec.ShowDate;
  NoteForTxt.Text := FromRec.NoteFor;
  NoteAlarmTxt.DateValue := FromRec.NoteAlarm;
  NoteAlarmChk.Checked := (Trim(FromRec.NoteAlarm) <> '');
  if NoteAlarmChk.Checked then
  begin
    NoteAlarmTxt.Enabled := True;
    NoteAlarmTxt.Color := NoteLineTxt.Color;
    NoteRepeatTxt.Enabled := True;
    NoteRepeatTxt.Color := NoteLineTxt.Color;
  end
  else
  begin
    NoteAlarmChk.Checked := True;
    NoteAlarmTxt.DateValue := Today;
  end;
  OnAlarmStateChange;
  NoteRepeatTxt.Value := FromRec.RepeatNo;
  NoteDateTxt.DateValue := FromRec.NoteDate;
  NoteLineTxt.Text := FromRec.NoteLine;
end;

// -----------------------------------------------------------------------------

procedure TDiaryNoteFrm.NoteAlarmChkClick(Sender: TObject);
begin
  OnAlarmStateChange;
end;

// -----------------------------------------------------------------------------

procedure TDiaryNoteFrm.NoteForTxtExit(Sender: TObject);
var
  FoundCode: Str20;
  FoundOk: Boolean;
  AltMod: Boolean;
begin
  {$IFDEF PF_On}
  If (Sender is Text8pt) then
  With (Sender as Text8pt) do
  Begin
    AltMod := Modified;
    FoundCode := Text;
    if (AltMod) and (FoundCode <> '') and (OrigValue <> Text) and
       (ActiveControl<>CancelBtn) then
    begin
      StillEdit := BOn;
      FoundOk := (GetUser(TForm(self.Owner), FoundCode, FoundCode, 0));
      if (FoundOk) then
        Text := FoundCode
      else
        SetFocus;
    end;
  end;
  {$ENDIF}
end;

// -----------------------------------------------------------------------------

procedure TDiaryNoteFrm.OnAlarmStateChange;
begin
  if (NoteAlarmChk.Checked) then
  begin
    NoteAlarmTxt.Enabled := True;
    NoteAlarmTxt.Color := NoteLineTxt.Color;
    NoteRepeatTxt.Enabled := True;
    NoteRepeatTxt.Color := NoteLineTxt.Color;
  end
  else
  begin
    NoteAlarmTxt.Enabled := False;
    NoteAlarmTxt.Color := clBtnFace;
    NoteRepeatTxt.Enabled := False;
    NoteRepeatTxt.Color := clBtnFace;
  end;
  NoteAlarmTxt.Visible := False; NoteAlarmTxt.Visible := True;
  NoteRepeatTxt.Visible := False; NoteRepeatTxt.Visible := True;
end;

// -----------------------------------------------------------------------------

procedure TDiaryNoteFrm.SetMode(const Value: TDiaryNoteMode);
begin
  FMode := Value;
end;

// -----------------------------------------------------------------------------

procedure TDiaryNoteFrm.WriteRecord(var ToNote: NotesType);
begin
  ToNote.ShowDate := DateChk.Checked;
  ToNote.NoteDate := NoteDateTxt.DateValue;
  ToNote.NoteLine := NoteLineTxt.Text;
  ToNote.NoteFor  := NoteForTxt.Text;
  if NoteAlarmChk.Checked then
    ToNote.NoteAlarm := NoteAlarmTxt.DateValue
  else
    ToNote.NoteAlarm := '';
  ToNote.RepeatNo := Trunc(NoteRepeatTxt.Value);
end;

// -----------------------------------------------------------------------------

end.

