unit SendResultsF;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, BaseF, ExtCtrls, StdCtrls, ComCtrls, ClipBrd, IniFiles,
  EnterToTab, Menus;

type
  TfrmResults = class(TSetupTemplate)
    SaveDialog1: TSaveDialog;
    Label1: TLabel;
    memSurveyOutput: TMemo;
    btnSaveAs: TButton;
    EnterToTab1: TEnterToTab;
    Label2: TLabel;
    RichEdit1: TRichEdit;
    PopupMenu1: TPopupMenu;
    menuOptCopy: TMenuItem;
    procedure FormCreate(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure NextBtnClick(Sender: TObject);
    procedure btnSaveAsClick(Sender: TObject);
    procedure BackBtnClick(Sender: TObject);
    procedure menuOptCopyClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

implementation

{$R *.dfm}

Uses oSurveyStore, SurveyF{, ContKey};

//--------------------------------------------------------------------------

procedure TfrmResults.FormCreate(Sender: TObject);
Var
  DistEmail : ShortString;
  EmPos     : SmallInt;

  Procedure ToBullet (Const StartPos : Integer);
  Begin // ToBullet
    RichEdit1.SelStart := StartPos;
    RichEdit1.SelLength := 1;
    RichEdit1.SelAttributes.Name := 'Wingdings';
    RichEdit1.SelAttributes.Size := 6;
  End; // ToBullet

  Procedure HighLight (Const StartPos, Length : Integer);
  Begin // HighLight
    RichEdit1.SelStart := StartPos;
    RichEdit1.SelLength := Length;
    RichEdit1.SelAttributes.Color := clBlue;
    RichEdit1.SelAttributes.Style := RichEdit1.SelAttributes.Style + [fsBold];
  End; // HighLight

begin
  inherited;

  Caption := Application.Title;
  ExitMsg := 255;

  // Import Distributor Email Address from Ini File
  With TIniFile.Create (ChangeFileExt(Application.ExeName, '.DAT')) Do
    Try
      DistEmail := ReadString ('Defaults', 'DistributorEmail', 'ExchequerSurvey@AdvancedComputerSoftware.com');
    Finally
      Free;
    End;

  RichEdit1.Text := RichEdit1.Text + 'l  Click the Save As button to save the results to your preferred location' + #10#10;
  RichEdit1.Text := RichEdit1.Text + 'l  In your Email application create a new email and set the recipient address to ' + DistEmail + #10#10;
  RichEdit1.Text := RichEdit1.Text + 'l  Set the subject on the email to Survey Results followed by your Company Name' + #10#10;
  RichEdit1.Text := RichEdit1.Text + 'l  Attach the saved survey results to the email and then send it';
  ToBullet (0);
  ToBullet (76);
  HighLight (157, Length(DistEmail));
  ToBullet (159 + Length(DistEmail));
  HighLight (194 + Length(DistEmail), 14);
  ToBullet (240 + Length(DistEmail));

  // Generate report and display in memo control
  oSurveyInfo.BuildReport;
  memSurveyOutput.Lines.Assign (oSurveyInfo.SurveyResults);

  // Display Message if any warnings were generated
  If (oSurveyInfo.WarningCount > 0) Then
    MessageDlg(IntToStr(oSurveyInfo.WarningCount) + ' warnings were generated during the analysis of ' +
               'your Company Data Sets, further details can be found at the end of the Survey Results.',
               mtWarning, [mbOK], 0);
end;

//--------------------------------------------------------------------------

procedure TfrmResults.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
begin
  inherited;

  If CanClose And (ExitCode = '?') Then Application.MainForm.Close;
end;

//--------------------------------------------------------------------------

procedure TfrmResults.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  inherited;

  Action := caFree;
end;

//--------------------------------------------------------------------------

procedure TfrmResults.NextBtnClick(Sender: TObject);
begin
  // Close form and move to Send dialog
  inherited;
  Application.MainForm.Close;
end;

//--------------------------------------------------------------------------

procedure TfrmResults.btnSaveAsClick(Sender: TObject);
begin
  //inherited;
  If SaveDialog1.Execute Then
    memSurveyOutput.Lines.SaveToFile(SaveDialog1.FileName);
end;

procedure TfrmResults.BackBtnClick(Sender: TObject);
begin
  // Close form and move back to Survey dialog
  //inherited;
  Hide;

  With TfrmCustSurvey.Create(Application.MainForm) Do
  Begin
    Mode := LastSurveyDialog;
    Show;
  End; // With TfrmCustSurvey.Create(Application.MainForm)

  ExitCode := 'B';
  PostMessage (Self.Handle, WM_Close, 0, 0);
end;

procedure TfrmResults.menuOptCopyClick(Sender: TObject);
begin
  ClipBoard.AsText := RichEdit1.SelText;
end;

end.
