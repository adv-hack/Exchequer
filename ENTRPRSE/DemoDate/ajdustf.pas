unit ajdustf;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Enterprise01_TLB, ComObj, ExtCtrls, StdCtrls, TCustom;

{$I ExchDll.inc}

type
  TfrmDateAdjust = class(TForm)
    cbCompanies: TComboBox;
    btnGo: TSBSButton;
    btnClose: TSBSButton;
    Panel1: TPanel;
    SaveDialog1: TSaveDialog;
    Label1: TLabel;
    Label2: TLabel;
    lblTotalRecs: TLabel;
    Label4: TLabel;
    lblProcessedRecs: TLabel;
    Label3: TLabel;
    Label5: TLabel;
    lblNotesRecs: TLabel;
    procedure FormCreate(Sender: TObject);
    procedure btnGoClick(Sender: TObject);
    procedure btnCloseClick(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
  private
    { Private declarations }
    oToolkit : IToolkit;
    TotalRecs, ProcessedRecs, NoteRecs : longint;
    LogMessage : string;
    LogF : TextFile;
    LogName : string;
    AnyErrors : Boolean;
    function SelectedCompanyPath : string;
    function OpenTheToolkit : Boolean;
    procedure EnableButtons(TurnOn : Boolean);
    procedure AdjustDates;
    function AdjustNotes(const oNotes : INotes; const NewDate : string) : Integer;
    function AdjustLine(const OurRef, NewDate : string; LineNo : longint) : Integer;
    procedure CreateLog;
    procedure LogIt(const s : string);
    procedure EndLog;
  public
    { Public declarations }
    procedure ShowProgress;
  end;

var
  frmDateAdjust: TfrmDateAdjust;

implementation

{$R *.dfm}
uses
  CtkUtil, UseDllU, ApiUtil, EtDateU;

const
  LineDays = 0;
  NoteDays = 30;
procedure TfrmDateAdjust.FormCreate(Sender: TObject);
var
  i : integer;
begin
  ProcessedRecs := 0;
  TotalRecs := 0;
  oToolkit := CreateToolkitWithBackDoor;
  if Assigned(oToolkit) then
  with oToolkit.Company do
  begin
    for i := 1 to cmCount do
      cbCompanies.Items.Add(cmCompany[i].coCode + ' - ' + Trim(cmCompany[i].coName));
    cbCompanies.ItemIndex := 0;
  end
  else
    raise Exception.Create('Unable to create COM Toolkit');
end;


function TfrmDateAdjust.SelectedCompanyPath: string;
var
  i : integer;
begin
  //Take Company Code from Code - Name string, then find Company Path from Code
  Result := cbCompanies.Items[cbCompanies.ItemIndex];
  i := Pos(' - ', Result);
  Result := Trim(CompanyPathFromCode(oToolkit, Copy(Result, 1, i-1)));
end;

procedure TfrmDateAdjust.ShowProgress;
begin
  Inc(TotalRecs);
  lblTotalRecs.Caption := IntToStr(TotalRecs);
  lblProcessedRecs.Caption := IntToStr(ProcessedRecs);
  lblNotesRecs.Caption := IntToStr(NoteRecs);
  Panel1.Refresh;
  Application.ProcessMessages;
end;

function TfrmDateAdjust.OpenTheToolkit: Boolean;
var
  Res : Integer;
  pPath : PChar;
  sPath : AnsiString;
  MC : WordBool;
begin
  Result := False;
  pPath := StrAlloc(255);
  Try
    sPath := SelectedCompanyPath;
    LogName := sPath + 'LOGS\ADJUST.LOG';
    CreateLog;
    StrPCopy(pPath, sPath);
    MC := oToolkit.Enterprise.enCurrencyVersion <> enProfessional;
    Res := Ex_InitDllPath(pPath, MC);
    if Res = 0 then
    begin
      Res := Ex_InitDll;
      if Res = 0 then
      begin
        Res := oToolkit.OpenToolkit;
        if Res = 0 then
        begin
          Result := True;
//          LogMessage := 'Please check ' + sPath + 'LOGS\MATCHFIX.LOG for details.';
        end
        else ShowMessage('Unable to open the COM toolkit. Error: ' +IntToStr(Res));
      end
      else
        ShowMessage('Unable to open the dll toolkit. Error: ' +IntToStr(Res));
    end
    else
      ShowMessage('Unable to set toolkit path. Error: ' +IntToStr(Res));

  Finally
    StrDispose(pPath);
  End;
end;

procedure TfrmDateAdjust.btnGoClick(Sender: TObject);
var
  Res : Integer;
  s : string;
begin
  AnyErrors := False;

  NoteRecs := 0;
  EnableButtons(False);
  Screen.Cursor := crHourGlass;
  Label1.Caption := 'Please wait. Processing...';
  if OpenTheToolkit then
  begin
    AdjustDates;
    EndLog;
    oToolkit.CloseToolkit;
    Ex_CloseData;
    s := 'Processing complete.';
    if AnyErrors then
      s := s + ' There were errors. Please check ' + LogName + ' for details.';
    ShowMessage(s);
  end;
  Label1.Caption := 'Processing Complete';
  Screen.Cursor := crDefault;
  EnableButtons(True);
end;

procedure TfrmDateAdjust.btnCloseClick(Sender: TObject);
begin
  Close;
end;

procedure TfrmDateAdjust.FormDestroy(Sender: TObject);
begin
//  oToolkit.CloseToolkit;
  oToolkit := nil;
end;

procedure TfrmDateAdjust.EnableButtons(TurnOn: Boolean);
begin
  btnGo.Enabled := TurnOn;
  btnClose.Enabled := TurnOn;
  cbCompanies.Enabled := TurnOn;
end;



{ TfrmMatchFix }

procedure TfrmDateAdjust.AdjustDates;
var
  Res, Res1, i : Integer;
begin
  with oToolkit.Transaction do
  begin
    Res := StepFirst;
    Application.ProcessMessages;
    while Res = 0 do
    begin
      if (Copy(thOurRef, 1, 1) <> 'J') then
      begin
      for i := 1 to thLines.thLineCount do
        if (Trim(thTransDate) <> '') and (Abs(NoDays(thLines[i].tlLineDate,thTransDate)) > LineDays) then
          AdjustLine(thOurRef, thTransDate, thLines[i].tlABSLineNo);
      Application.ProcessMessages;
      Res1 := thNotes.GetFirst;
      while Res1 = 0 do
      begin
        if (thNotes.ntType = ntTypeDated) and (Abs(NoDays(thNotes.ntDate,thTransDate)) > NoteDays)then
          AdjustNotes(thNotes, thTransDate);

        Res1 := thNotes.GetNext;
      end;
      end;

      Res := StepNext;
      Inc(TotalRecs);
      ShowProgress;
    end;
  end;
end;

function TfrmDateAdjust.AdjustLine(const OurRef, NewDate : string; LineNo : longint) : Integer;
var
  pOurRef,
  pNewDate : PChar;
  s : string;
begin
  inc(ProcessedRecs);
  pOurRef := StrAlloc(255);
  pnewDate := StrAlloc(255);
  Try
    StrPCopy(pOurRef, OurRef);
    StrPCopy(pNewDate, NewDate);
    Result := Ex_UpdateLineDate(pOurRef, LineNo, pNewDate);
    s := Format('Adjust LineDate for %s %d', [OurRef, LineNo]);
    if Result <> 0 then
    begin
      s := s + ' *** Error ' + IntToStr(Result);
      AnyErrors := True;
      LogIt(s);
    end;
  Finally
    StrDispose(pOurRef);
  End;
end;

function TfrmDateAdjust.AdjustNotes(const oNotes : INotes; const NewDate : string) : Integer;
var
  NotesU : INotes;
  s : string;
begin
  Result := 1;
  if Trim(NewDate) <> '' then
  begin
    NotesU := oNotes.Update;
    if Assigned(NotesU) then
    begin
      Try
        NotesU.ntDate := NewDate;
        Result := NotesU.Save;
        s := 'Adjust Note date for ' + oToolkit.Transaction.thOurRef;
        if Result <> 0 then
        begin
          s := s + ' *** Error: ' + oToolkit.LastErrorString;
          AnyErrors := True;
          LogIt(s);
        end;
        Inc(NoteRecs);
      Finally
        NotesU := nil;
      End;
    end
    else
      Result := 2;
  end;
end;

procedure TfrmDateAdjust.CreateLog;
begin
  AssignFile(LogF, LogName);
  Rewrite(LogF);
end;

procedure TfrmDateAdjust.LogIt(const s : string);
begin
  WriteLn(LogF, s);
end;

procedure TfrmDateAdjust.EndLog;
begin
  CloseFile(LogF);
end;




end.
