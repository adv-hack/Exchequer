unit SurveyF;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, IniFiles, ExtCtrls, StdCtrls, ComCtrls, EnterToTab, BaseF,
  SurveyBaseFrame;

Type
  // NOTE: Enumeration deliberately starts at 1 so that the FMode variable which gets initialised
  // to zero automatically when the class is created doesn't match any potential value.  This
  // 'feature' means that SetMode works
  TSurveyMode = (smCompanyDetails=1, smMarketing=2, smOperatingSystems=3, smOfficeVersions=4);

Const
  FirstSurveyDialog = smCompanyDetails;
  LastSurveyDialog = smOfficeVersions;

Type
  TfrmCustSurvey = class(TSetupTemplate)
    EnterToTab1: TEnterToTab;
    procedure FormCreate(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure NextBtnClick(Sender: TObject);
    procedure BackBtnClick(Sender: TObject);
  private
    { Private declarations }
    FMode : TSurveyMode;
    FActiveFrame : TSurveyFrameBase;
    FModeFrames : Array [TSurveyMode] of TSurveyFrameBase;

    Procedure SetMode (Value : TSurveyMode);
  public
    { Public declarations }
    Property Mode : TSurveyMode Read FMode Write SetMode;
  end;

var
  frmCustSurvey: TfrmCustSurvey;

implementation

{$R *.dfm}

Uses SendResultsF, oSurveyStore, SurveyContactFrame, SurveyMarketingFrame, SurveyOSFrame, SurveyOfficeFrame;

//--------------------------------------------------------------------------

procedure TfrmCustSurvey.FormCreate(Sender: TObject);
Var
  oIni  : TIniFile;
  sList : TStringList;
  I     : SmallInt;
  iModeFrame : TSurveyMode;
begin
  inherited;

  Caption := Application.Title;
  ExitMsg := 255;

  FActiveFrame := NIL;

  FModeFrames[smCompanyDetails] := TSurveyFrameContactDetails.Create(Self);
  FModeFrames[smMarketing] := TSurveyFrameMarketing.Create(Self);
  FModeFrames[smOperatingSystems] := TSurveyFrameOperatingSystems.Create(Self);
  FModeFrames[smOfficeVersions] := TSurveyFrameOfficeVersions.Create(Self);

  oIni  := TIniFile.Create (ChangeFileExt(Application.ExeName, '.DAT'));
  Try
    // Initialise all the frames
    For iModeFrame := Low(TSurveyMode) To High(TSurveyMode) Do
    Begin
      If Assigned(FModeFrames[iModeFrame]) Then
      Begin
        // Load pre-defined data from the survey resource file (ExSurvey.Dat)
        FModeFrames[iModeFrame].InitialiseFromIni(oIni);

        // Load and previously specified data from the global oSurveyInfo singleton
        FModeFrames[iModeFrame].LoadPreviousData;
      End // If Assigned(FModeFrames[iModeFrame])
      Else
        Raise Exception.Create('Unassigned Frame for mode ' + IntToStr(Ord(iModeFrame)));
    End; // For iModeFrame
  Finally
    FreeAndNIL(oIni);
  End; // Try..Finally

  Mode := smCompanyDetails;
end;

//--------------------------------------------------------------------------

procedure TfrmCustSurvey.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
begin
  inherited;

  If CanClose And (ExitCode = '?') Then Application.MainForm.Close;
end;

//--------------------------------------------------------------------------

procedure TfrmCustSurvey.FormClose(Sender: TObject; var Action: TCloseAction);
Var
  iModeFrame : TSurveyMode;
begin
  inherited;

  For iModeFrame := Low(TSurveyMode) To High(TSurveyMode) Do
  Begin
    FreeAndNIL(FModeFrames[iModeFrame]);
  End; // For iModeFrame

  Action := caFree;
end;

//--------------------------------------------------------------------------

Procedure TfrmCustSurvey.SetMode (Value : TSurveyMode);
Begin // SetMode
  If (Value <> FMode) Then
  Begin
    FMode := Value;

    If Assigned(FActiveFrame) Then
      FActiveFrame.Visible := False;

    FActiveFrame := FModeFrames[FMode];
    With FActiveFrame Do
    Begin
      Parent := Self;
      Top := 74;
      Left := 162;
      Visible := True;
    End; // With FActiveFrame

    BackBtn.Visible := (FMode <> smCompanyDetails);
  End; // If (Value <> FMode)
End; // SetMode

//-------------------------------------------------------------------------

procedure TfrmCustSurvey.BackBtnClick(Sender: TObject);
begin
  If (FMode <> FirstSurveyDialog) Then
    Mode := TSurveyMode(Ord(FMode) - 1);
end;

//------------------------------

procedure TfrmCustSurvey.NextBtnClick(Sender: TObject);
Var
  iModeFrame : TSurveyMode;
  OK : Boolean;
  sDesc : ShortString;
begin
  If FModeFrames[FMode].Validate Then
  Begin
    If (FMode = LastSurveyDialog) Then
    Begin
      // Save
      For iModeFrame := Low(TSurveyMode) To High(TSurveyMode) Do
      Begin
        FModeFrames[iModeFrame].SaveData;
      End; // For iModeFrame

      // Update Setup.Usr for next time the app is used
      oSurveyInfo.UpdateSetupUSR;

      // Close form and move to Results dialog
      Hide;
      TfrmResults.Create(Application.MainForm).Show;

      ExitCode := 'N';
      PostMessage (Self.Handle, WM_Close, 0, 0);
    End // If (FMode = LastSurveyDialog)
    Else
      Mode := TSurveyMode(Ord(FMode) + 1);
  End; // If FModeFrames[FMode].Validate
end;

//--------------------------------------------------------------------------

end.
