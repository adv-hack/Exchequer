unit SQLPostingPromptF;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls;

type
  TfrmSQLPostingPromptDisplayMode = (dmManual=0, dmAuto=1);

  TfrmSQLPostingPrompt = class(TForm)
    btnRunCheckNow: TButton;
    btnAskLater: TButton;
    btnHide: TButton;
    Label2: TLabel;
    Label1: TLabel;
    Label3: TLabel;
    btnMoreInfo: TButton;
    procedure btnRunCheckNowClick(Sender: TObject);
    procedure btnAskLaterClick(Sender: TObject);
    procedure btnHideClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormCreate(Sender: TObject);
    procedure btnMoreInfoClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    Constructor Create (AOwner : TComponent; Const Mode : TfrmSQLPostingPromptDisplayMode); Reintroduce;
  end;

// Returns TRUE if the User has rights to post Purchase, Sales or Nominal and
// we should check the SQL Posting Status and display the dialog/menu option
Function CheckSQLPostingStatus : Boolean;

// Display the Prompt dialog encouraging the user to run the checks to enable SQL Posting
Procedure DisplaySQLPostingPrompt (Const Mode : TfrmSQLPostingPromptDisplayMode);

implementation

{$R *.dfm}

Uses GlobVar, SQLUtils, PWarnU, SQLRep_Config, VAOUtil, APIUtil;

//=========================================================================

// Executes the SQL Check Application.
Procedure RunSQLCheckApp;
Begin // RunSQLCheckApp
  RunFile(VAOInfo.vaoCompanyDir + 'ExchDVT.Exe', SQLUtils.GetCompanyCode(SetDrive));
End; // RunSQLCheckApp

//-------------------------------------------------------------------------

// Returns TRUE if the User has rights to post Purchase, Sales or Nominal and
// we should check the SQL Posting Status and display the dialog/menu option
Function CheckSQLPostingStatus : Boolean;
Begin // CheckSQLPostingStatus
  // SQL Posting only available in SQL Edition
  // Check users can enter Sales, Purchase or Nominal Daybook and run Daybook Posting
  Result := SQLUtils.UsingSQL And
            // 'Sales - Access to Daybook' and 'Sales - Daybook Post'
            (ChkAllowed_In(001) And ChkAllowed_In(008)) Or
            // 'Purchase - Access to Daybook' and 'Purchase - Daybook Post'
	    (ChkAllowed_In(010) And ChkAllowed_In(017)) Or
            // 'Nominal Transfers - Access to Daybook' and 'Nominal Transfers - Daybook Post'
	    (ChkAllowed_In(024) And ChkAllowed_In(029)) Or
            // 'Utilities - Access to Posting Menu' and 'Utilities - Post All DayBooks' - actually off Procedures Menu!
            (ChkAllowed_In(078) And ChkAllowed_In(079));
End; // CheckSQLPostingStatus

//-------------------------------------------------------------------------

// Display the Prompt dialog encouraging the user to run the checks to enable SQL Posting
Procedure DisplaySQLPostingPrompt (Const Mode : TfrmSQLPostingPromptDisplayMode);
Var
  CreateNew : Boolean;
  I : Integer;
Begin // DisplaySQLPostingPrompt
  // Check to see if it already exists
  CreateNew := True;
  For I := 0 To (Application.MainForm.MDIChildCount - 1) Do
  Begin
    If (Application.MainForm.MDIChildren[I] Is TfrmSQLPostingPrompt) Then
    Begin
      // Activate the existing window
      Application.MainForm.MDIChildren[I].Show;
      CreateNew := False;
      Break;
    End; // If (Screen.Forms[I] Is TfrmSQLPostingPrompt)
  End; // For I

  If CreateNew Then
    TfrmSQLPostingPrompt.Create(Application.MainForm, Mode);
End; // DisplaySQLPostingPrompt

//=========================================================================

Constructor TfrmSQLPostingPrompt.Create (AOwner : TComponent; Const Mode : TfrmSQLPostingPromptDisplayMode);
begin
  Inherited Create(AOwner);

  // Only show the Hide button if the SQL Posting check is Pending and the dialog has been shown automatically
  If (SQLReportsConfiguration.SQLPostingStatus[SQLUtils.GetCompanyCode(SetDrive)] <> psPending) or (Mode = dmManual) Then
  Begin
    btnHide.Visible := False;

    btnAskLater.Caption := 'Close';
    btnAskLater.Cancel := True;

    // Recentre buttons
    btnAskLater.Left := (ClientWidth Div 2) - (btnAskLater.Width Div 2);
    btnRunCheckNow.Left := btnAskLater.Left - btnRunCheckNow.Width - 10;
    btnMoreInfo.Left := btnAskLater.Left + btnAskLater.Width + 10;
  End; // If (SQLReportsConfiguration.SQLPostingStatus[SQLUtils.GetCompanyCode(SetDrive)] <> psPending) or (Mode = dmManual)
end;

//-----------------------------------

procedure TfrmSQLPostingPrompt.FormCreate(Sender: TObject);
Begin
  // Do Not Use
End;

//-----------------------------------

procedure TfrmSQLPostingPrompt.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Action := caFree;
end;

//-------------------------------------------------------------------------

procedure TfrmSQLPostingPrompt.btnRunCheckNowClick(Sender: TObject);
begin
  // Run the SQL Check App and then close the dialog
  RunSQLCheckApp;
  Close;
end;

//-------------------------------------------------------------------------

procedure TfrmSQLPostingPrompt.btnAskLaterClick(Sender: TObject);
begin
  // Close the dialog leaving the SQL Posting Status unchanged so the user gets asked again later
  Close;
end;

//-------------------------------------------------------------------------

procedure TfrmSQLPostingPrompt.btnHideClick(Sender: TObject);
begin
  // Set the SQL Posting Status to FAILED so that this dialog is not shown again, but the
  // menu option is available should they want to run it in the future
  SQLReportsConfiguration.SetSQLPostingStatus(SQLUtils.GetCompanyCode(SetDrive), psFailed);
  Close;
end;

//-------------------------------------------------------------------------

procedure TfrmSQLPostingPrompt.btnMoreInfoClick(Sender: TObject);
begin
  // Open the help file to the More Information page
  Application.HelpCommand(HELP_CONTEXT,Self.HelpContext);
end;

//-------------------------------------------------------------------------

end.
