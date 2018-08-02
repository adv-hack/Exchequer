unit ResultsF;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, SETUPBAS, ExtCtrls, StdCtrls, ComCtrls, ClipBrd, IniFiles;

type
  TfrmResults = class(TSetupTemplate)
    SaveDialog1: TSaveDialog;
    PageControl1: TPageControl;
    tabshEmail: TTabSheet;
    TabSheet2: TTabSheet;
    TabSheet3: TTabSheet;
    Label1: TLabel;
    Label2: TLabel;
    Label5: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    lblSendEmailTo: TLabel;
    Label7: TLabel;
    Label10: TLabel;
    Label11: TLabel;
    Label8: TLabel;
    Label9: TLabel;
    Label12: TLabel;
    Label13: TLabel;
    Label14: TLabel;
    Label15: TLabel;
    Label16: TLabel;
    Label17: TLabel;
    Label18: TLabel;
    Label19: TLabel;
    Label20: TLabel;
    Label21: TLabel;
    memSurveyOutput: TMemo;
    btnCopy: TButton;
    btnSaveAs: TButton;
    procedure FormCreate(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure NextBtnClick(Sender: TObject);
    procedure btnCopyClick(Sender: TObject);
    procedure btnSaveAsClick(Sender: TObject);
    procedure BackBtnClick(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure FormKeyPress(Sender: TObject; var Key: Char);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

implementation

{$R *.dfm}

Uses oEntList, SurveyF, ContKey;

//--------------------------------------------------------------------------

procedure TfrmResults.FormCreate(Sender: TObject);
Var
  DistEmail : ShortString;
  EmPos     : SmallInt;
begin
  inherited;

  Caption := Application.Title;
  ExitMsg := 255;

  // Import Distributor Email Address from Ini File
  With TIniFile.Create (ChangeFileExt(Application.ExeName, '.DAT')) Do
    Try
      DistEmail := ReadString ('Defaults', 'DistributorEmail', 'Survey@Exchequer.Com');

      // Replace '@@@' place holder on the form
      EmPos := Pos ('@@@', lblSendEmailTo.Caption);
      If (EmPos > 0) Then
        lblSendEmailTo.Caption := Copy (lblSendEmailTo.Caption, 1, EmPos - 1) +
                                  DistEmail +
                                  Copy (lblSendEmailTo.Caption, EmPos + 3, 999);
    Finally
      Free;
    End;

  // Always default to Email
  PageControl1.ActivePage := tabshEmail;

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

procedure TfrmResults.btnCopyClick(Sender: TObject);
begin
  //inherited;

  Clipboard.AsText := memSurveyOutput.Text;
end;

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
  TfrmCustSurvey.Create(Application.MainForm).ShowLast;

  ExitCode := 'B';
  PostMessage (Self.Handle, WM_Close, 0, 0);
end;

procedure TfrmResults.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  //inherited;
  GlobFormKeyDown(Sender, Key, Shift, ActiveControl, Self.Handle);
end;

procedure TfrmResults.FormKeyPress(Sender: TObject; var Key: Char);
begin
  //inherited;
  GlobFormKeyPress(Sender, Key, ActiveControl, Self.Handle);
end;

end.
