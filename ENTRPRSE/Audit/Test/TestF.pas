unit TestF;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, AuditLog, StdCtrls, ExtCtrls, AuditFindClass, ComCtrls;

type
  TForm1 = class(TForm)
    btnWriteAudit: TButton;
    btnReadAudit: TButton;
    btnClear: TButton;
    Label1: TLabel;
    cmbCompanyDir: TComboBox;
    btnFind: TButton;
    FindDialog1: TFindDialog;
    btnFindNext: TButton;
    Memo1: TMemo;
    procedure btnWriteAuditClick(Sender: TObject);
    procedure btnReadAuditClick(Sender: TObject);
    procedure btnClearClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure btnFindClick(Sender: TObject);
    procedure btnFindNextClick(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FindDialog1Find(Sender: TObject);
  private
    { Private declarations }
    FAuditFind : TAuditFind;
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.dfm}

//=========================================================================

procedure TForm1.FormCreate(Sender: TObject);
begin
  //FAuditFind := TAuditFind.Create(Memo1);

  btnClearClick(Sender);
  btnReadAuditClick(Sender);
end;

//------------------------------

procedure TForm1.FormDestroy(Sender: TObject);
begin
  FreeAndNIL(FAuditFind);
end;

//-------------------------------------------------------------------------

procedure TForm1.btnWriteAuditClick(Sender: TObject);
Var
  I : LongInt;
begin
  With TAuditLogReaderWriter.Create (IncludeTrailingPathDelimiter(cmbCompanyDir.Text) + '\Audit\LIVE.EAF') Do
  Begin
    Try
      I := ReadAuditLog;
      If (I = 0) Then
      Begin
//ShowMessage ('Locked');
        //Archive;

        For I := 0 To (Memo1.Lines.Count - 1) Do
          AuditStrings.Add (Memo1.Lines[I]);

        I := WriteAuditLog;
        If (I <> 0) Then
          ShowMessage ('WriteAuditLog: ' + IntToStr(I));
      End // If (I = 0)
      Else
        ShowMessage ('ReadAuditLog: ' + IntToStr(I));
    Finally
      Free;
    End; // Try..Finally
  End; // With TAuditLogReaderWriter.Create
end;

//-------------------------------------------------------------------------

procedure TForm1.btnReadAuditClick(Sender: TObject);
Var
  I : LongInt;
begin
  btnClearClick(Sender);
  With TAuditLogReader.Create (IncludeTrailingPathDelimiter(cmbCompanyDir.Text) + '\Audit\LIVE.EAF') Do
  Begin
    Try
//Caption := 'ReadStart:' + FormatDateTime('hh:nn.ss.zzz', Now);
      I := ReadAuditLog;
//Caption := Caption + ' ReadFinish:' + FormatDateTime('hh:nn.ss.zzz', Now);
      If (I = 0) Then
      Begin
//        For I := 0 To (AuditStrings.Count - 1) Do
//          Memo1.Lines.Add (AuditStrings[I]);

        // Assign is significantly quicker as it uses BeginUpdate/EndUpdate to prevent refreshes
        Memo1.Lines.Assign (AuditStrings);
//Caption := Caption + ' LinesLoaded:' + FormatDateTime('hh:nn.ss.zzz', Now);
      End // If (I = 0)
      Else
        ShowMessage ('ReadAuditLog: ' + IntToStr(I));
    Finally
      Free;
    End; // Try..Finally
  End; // With TAuditLogReader.Create
end;

//-------------------------------------------------------------------------

procedure TForm1.btnClearClick(Sender: TObject);
begin
  Memo1.Lines.Clear;
end;

//-------------------------------------------------------------------------

procedure TForm1.btnFindClick(Sender: TObject);

begin
//  I := Pos(Edit1.Text, Memo1.Text);
//  If (I > 0) Then
//  Begin
//    Memo1.SelStart := I - 1;
//    Memo1.SelLength := Length(Edit1.Text);
//    Memo1.SetFocus;
//  End // If (I > -1)
//  Else
//    ShowMessage ('Not found');

  FindDialog1.Execute;
end;

//------------------------------

procedure TForm1.btnFindNextClick(Sender: TObject);
begin
end;

//-------------------------------------------------------------------------

procedure TForm1.FindDialog1Find(Sender: TObject);
var
  FoundAt: LongInt;
  SearchStart : LongInt;
  SearchText : ANSIString;
begin
  With Memo1 Do
  Begin
    // Determine starting position
    If (SelLength > 0) Then
      // Start after selection
      SearchStart := SelStart + SelLength
    Else
      // Start at cursor
      SearchStart := SelStart;

    // Extract text to search and convert to uppercase for a case-insensitive comparison
    SearchText := UpperCase(Text);
    If (SearchStart > 0) And (SearchStart < Length(SearchText)) Then
    Begin
      // Delete leading characters that we have no interest in
      Delete (SearchText, 1, SearchStart);
    End; // If (SearchStart > 0) And (SearchStart < Length(SearchText))

    // Search for matching text
    FoundAt := Pos(FindDialog1.FindText, SearchText);
    If (FoundAt > 0) Then
    Begin
      SelStart := SearchStart + FoundAt - 1;
      SelLength := Length(FindDialog1.FindText);
      If CanFocus Then
        SetFocus
    End; // If (FoundAt > 0)
  End; // With Memo1
end;

end.
