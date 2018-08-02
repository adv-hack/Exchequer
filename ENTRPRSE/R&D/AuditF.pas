unit AuditF;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, EntWindowSettings, Menus, ExtCtrls, ComCtrls, Math,
  EnterToTab;

type
  TfrmAudit = class(TForm)
    cmbAvailableAuditFiles: TComboBox;
    Label1: TLabel;
    PopupMenu1: TPopupMenu;
    mnuArchive: TMenuItem;
    mnuFind: TMenuItem;
    mnuCopy: TMenuItem;
    N1: TMenuItem;
    StoreCoordFlg: TMenuItem;
    btnArchive: TButton;
    btnFind: TButton;
    btnCopy: TButton;
    btnSaveAs: TButton;
    btnSelectAll: TButton;
    btnClose: TButton;
    mnuSaveAs: TMenuItem;
    mnuSelectAll: TMenuItem;
    mnuProperties: TMenuItem;
    N2: TMenuItem;
    SaveDialog1: TSaveDialog;
    panMemoHost: TPanel;
    memAuditTrail: TMemo;
    FindDialog1: TFindDialog;
    panProgress: TPanel;
    ProgressBar1: TProgressBar;
    lblProgress: TLabel;
    EnterToTab1: TEnterToTab;
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure StoreCoordFlgClick(Sender: TObject);
    procedure PopupMenu1Popup(Sender: TObject);
    procedure FormResize(Sender: TObject);
    procedure btnArchiveClick(Sender: TObject);
    procedure btnFindClick(Sender: TObject);
    procedure btnCopyClick(Sender: TObject);
    procedure btnSaveAsClick(Sender: TObject);
    procedure btnSelectAllClick(Sender: TObject);
    procedure btnCloseClick(Sender: TObject);
    procedure cmbAvailableAuditFilesClick(Sender: TObject);
    procedure mnuPropertiesClick(Sender: TObject);
    procedure FindDialog1Find(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
  private
    FSettings : IWindowSettings;

    StartWidth, StartHeight : LongInt;
    StoreCoord, NeedCUpdate : Boolean;

    // Minimum form sizes to be set in the WM_GetMinMaxInfo message handler
    MinSizeX : LongInt;
    MinSizeY : LongInt;

    LoadingList : Boolean;  // Indicates that the audit trail is currently being loaded
    LoadInActivate : Boolean;

    Procedure ClearAuditsList;
    Procedure ScanForAudits;
    Procedure UpdateProgress (Const ProgressDesc : ShortString; Const LoadingState : Boolean; Const IsLiveLog : Boolean = False);

    // Control the minimum size that the form can resize to - works better than constraints
    Procedure WMGetMinMaxInfo(Var Message  :  TWMGetMinMaxInfo); Message WM_GetMinMaxInfo;
  public
    { Public declarations }
  end;


Procedure DisplayAuditTrail;

implementation

{$R *.dfm}

Uses AuditIntf, AuditLog;

Type
  TLogName = Class(TObject)
  Private
    FLogName : ShortString;
    Function GetLogDescription : ShortString;
    Function GetIsLIVE : Boolean;
  Public
    Property LogDescription : ShortString Read GetLogDescription;
    Property LogFilename : ShortString Read FLogName;
    Property IsLIVE : Boolean Read GetIsLIVE;

    Constructor Create (Const LogInfo : TSearchRec);
  End; // TLogName

//=========================================================================

Constructor TLogName.Create (Const LogInfo : TSearchRec);
Begin // Create
  Inherited Create;
  FLogName := LogInfo.Name;
  //FLogSize := IntToStr((LogInfo.Size Div 1024)) + 'k';
End; // Create

//-------------------------------------------------------------------------

Function TLogName.GetLogDescription : ShortString;
Const
  NumberSet = ['0'..'9'];
Var
  iYear, iMonth, iDay, iHour, iMinutes, iSeconds : LongInt;
Begin // GetLogDescription
  // Check for live audit trail
  If (UpperCase(FLogName) = LiveAuditFilename) Then
    Result := 'Live Audit Trail'
  // Check for live audit trail in YYYYMMDD-HHMMSS.EAF format
  Else If (Length(FLogName) = 19) And (FLogName[1] In NumberSet) And (FLogName[2] In NumberSet) And (FLogName[3] In NumberSet) And
                                      (FLogName[4] In NumberSet) And (FLogName[5] In NumberSet) And (FLogName[6] In NumberSet) And
                                      (FLogName[7] In NumberSet) And (FLogName[8] In NumberSet) And (FLogName[9] = '-') And
                                      (FLogName[10] In NumberSet) And (FLogName[11] In NumberSet) And (FLogName[12] In NumberSet) And
                                      (FLogName[13] In NumberSet) And (FLogName[14] In NumberSet) And (FLogName[15] In NumberSet) And
                                      (Copy (FLogName, 16, 4) = AuditFileExtension) Then
  Begin
    IYear := StrToIntDef(Copy (FLogName, 1, 4), 0);
    iMonth := StrToIntDef(Copy (FLogName, 5, 2), 0);
    iDay := StrToIntDef(Copy (FLogName, 7, 2), 0);

    iHour := StrToIntDef(Copy (FLogName, 10, 2), 0);
    iMinutes := StrToIntDef(Copy (FLogName, 12, 2), 0);
    iSeconds := StrToIntDef(Copy (FLogName, 14, 2), 0);

    Result := Format('Audit Trail archived at %0.2d:%0.2d on %0.2d/%0.2d/%0.4d', [iHour, iMinutes, iDay, iMonth, iYear]);
  End // If (Length(FLogName) = 19) And (FLogName[1] In NumberSet) And ...
  Else
    // Unknown
    Result := FLogName;
End; // GetLogDescription

//-------------------------------------------------------------------------

Function TLogName.GetIsLIVE : Boolean;
Begin // GetIsLIVE
  Result := (UpperCase(FLogName) = LiveAuditFilename);
End; // GetIsLIVE

//=========================================================================

Procedure DisplayAuditTrail;
var
  frmAudit: TfrmAudit;
Begin // DisplayAuditTrail
  //ShowMessage ('Unfortunately due to leaves on the line at Micheldever the Trader Bank/Card Audit is running late');
  TfrmAudit.Create(Application.MainForm);
End; // DisplayAuditTrail

//=========================================================================

procedure TfrmAudit.FormCreate(Sender: TObject);
Var
  I : LongInt;
begin
  StoreCoord := False;
  NeedCUpdate := False;

  // Set default size
  ClientWidth := 860;
  ClientHeight := 380;

  // Read  in any previously saved settings
  FSettings := GetWindowSettings(Self.Name);
  If Assigned(FSettings) Then
  Begin
    FSettings.LoadSettings;

    If (Not FSettings.UseDefaults) Then
    Begin
      FSettings.SettingsToWindow(Self);
      FSettings.SettingsToParent(panMemoHost);
      cmbAvailableAuditFiles.Color := memAuditTrail.Color;
    End; // If (Not FSettings.UseDefaults)
  End; // If Assigned(FSettings)

  // Minimum form sizes to be set in the WM_GetMinMaxInfo message handler
  MinSizeX := (Width - ClientWidth) + 590;        // take border sizing &
  MinSizeY := (Height - ClientHeight) + 195;      // captions into account

  StartWidth := Width;
  StartHeight := Height;
  FormResize(Self);

  UpdateProgress ('', False);

  // Load the combo with a list of the available audits
  LoadInActivate := False;
  ScanForAudits;
End;

//------------------------------

procedure TfrmAudit.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
begin
  CanClose := Not LoadingList;
end;

//------------------------------

procedure TfrmAudit.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  ClearAuditsList;

  // MH 14/12/2010 v6.6 ABSEXCH-10544: Changed to use new Window Positioning system
  If Assigned(FSettings) And NeedCUpdate Then
  Begin
    FSettings.ParentToSettings(panMemoHost, memAuditTrail);
    FSettings.WindowToSettings(Self);
    FSettings.SaveSettings(StoreCoord);
  End; // If Assigned(FSettings) And NeedCUpdate
  FSettings := nil;

  Action := caFree;
end;

//-------------------------------------------------------------------------

procedure TfrmAudit.FormActivate(Sender: TObject);
begin
  If LoadInActivate Then
  Begin
    LoadInActivate := False;
    cmbAvailableAuditFilesClick(Self);
  End; // If LoadInActivate
end;

//-------------------------------------------------------------------------

procedure TfrmAudit.FormResize(Sender: TObject);
begin
  btnClose.Left := ClientWidth - btnClose.Width - 5;
  btnArchive.Left := btnClose.Left;
  btnFind.Left := btnClose.Left;
  btnCopy.Left := btnClose.Left;
  btnSaveAs.Left := btnClose.Left;
  btnSelectAll.Left := btnClose.Left;

  panMemoHost.Width := btnClose.Left - 5 - panMemoHost.Left;
  panMemoHost.Height := ClientHeight - panMemoHost.Top - 5;

  panProgress.Left := (ClientWidth - panProgress.Width) Div 2;
  panProgress.Top := (ClientHeight - panProgress.Height) Div 2;

  NeedCUpdate := (StartWidth <> Width) or (StartHeight <> Height);

  //Caption := 'ClientWidth: ' + IntToStr(ClientWidth) + '  ClientHeight: ' + IntToStr(ClientHeight);
end;

//-------------------------------------------------------------------------

// Control the minimum size that the form can resize to - works better than constraints
Procedure TfrmAudit.WMGetMinMaxInfo(Var Message  :  TWMGetMinMaxInfo);
Begin // WMGetMinMaxInfo
  With Message.MinMaxInfo^ Do
  Begin
    ptMinTrackSize.X:=MinSizeX;
    ptMinTrackSize.Y:=MinSizeY;
  End; // With Message.MinMaxInfo^

  Message.Result:=0;

  Inherited;
End; // WMGetMinMaxInfo

//-------------------------------------------------------------------------

Procedure TfrmAudit.UpdateProgress (Const ProgressDesc : ShortString; Const LoadingState : Boolean; Const IsLiveLog : Boolean = False);
Begin // UpdateProgress
  LoadingList := LoadingState;

  // Disable popup menu whilst loading audits
  If LoadingList Then
    Self.PopupMenu := NIL
  Else
    Self.PopupMenu := PopupMenu1;

  // Set the cursor to hourglass for the form whilst loading
  Self.Cursor := IfThen(LoadingList, crHourglass, crDefault);
  memAuditTrail.Cursor := Self.Cursor;
  panMemoHost.Cursor := Self.Cursor;

  // Display/Hide the progress
  lblProgress.Caption := ProgressDesc;
  ProgressBar1.Position := 0;
  panProgress.Visible := LoadingList;

  // Disable the form controls whilst loading
  cmbAvailableAuditFiles.Enabled := Not LoadingList;
  memAuditTrail.Enabled := cmbAvailableAuditFiles.Enabled;
  btnClose.Enabled := cmbAvailableAuditFiles.Enabled;
  btnArchive.Enabled := cmbAvailableAuditFiles.Enabled And IsLIVELog;
  btnFind.Enabled := cmbAvailableAuditFiles.Enabled;
  btnCopy.Enabled := cmbAvailableAuditFiles.Enabled;
  btnSaveAs.Enabled := cmbAvailableAuditFiles.Enabled;
  btnSelectAll.Enabled := cmbAvailableAuditFiles.Enabled;

  // Need application.processmessages to pain the progress panel
  If panProgress.Visible Then
    Application.ProcessMessages;
End; // UpdateProgress

//-------------------------------------------------------------------------

Procedure TfrmAudit.ClearAuditsList;
Var
  I : SmallInt;
Begin // ClearAuditsList
  // Free up log objects from combo box
  For I := 0 To (cmbAvailableAuditFiles.Items.Count - 1) Do
  Begin
    cmbAvailableAuditFiles.Items.Objects[I].Free;
  End; // For I

  cmbAvailableAuditFiles.Clear;
End; // ClearAuditsList

//------------------------------

Procedure TfrmAudit.ScanForAudits;
Var
  oLog         : TLogName;
  FileList     : TStringList;
  FileInfo     : TSearchRec;
  FStatus, I   : SmallInt;
Begin // ScanForAudits
  ClearAuditsList;

  // Store the found files in a string list to allow them to be sorted - the order FindFirst/FindNext
  // returns the files in is not defined and differs depending on the format of the drive
  FileList := TStringList.Create;
  Try
    // Look in the Audit\ sub-directory of the company and list the available audit files
    FStatus := FindFirst(AuditDirectory + '*' + AuditFileExtension, faAnyFile, FileInfo);
    Try
      While (FStatus = 0) Do
      Begin
        If (FileInfo.Name <> '.') And (FileInfo.Name <> '..') Then
        Begin
          If (UpperCase(FileInfo.Name) = LiveAuditFilename) Then
          Begin
            // Live Audit Trail - Always add in the LIVE audit at the top
            oLog := TLogName.Create(FileInfo);
            cmbAvailableAuditFiles.Items.AddObject (oLog.LogDescription, oLog);
          End // If (UpperCase(FileInfo.Name) = LiveAuditFilename)
          Else
          Begin
            oLog := TLogName.Create(FileInfo);
            FileList.AddObject (FileInfo.Name, oLog);
          End; // Else
        End; // If (FileInfo.Name <> '.') And (FileInfo.Name <> '..')

        FStatus := FindNext(FileInfo);
      End; // While (FStatus = 0)
    Finally
      SysUtils.FindClose (FileInfo);
    End; // Try..Finally

    //------------------------------

    // Sort the Stringlist and add the archive logs into the list with newest first - descending date/time order
    FileList.Sorted := True;
    For I := (FileList.Count - 1) DownTo 0 Do
    Begin
      oLog := TLogName(FileList.Objects[I]);
      cmbAvailableAuditFiles.Items.AddObject (oLog.LogDescription, oLog);
    End; // For I

    //------------------------------

    // Auto-select the first audit and automatically load in form active - this prevents a blank screen
    // when massive autid trails are loaded
    cmbAvailableAuditFiles.ItemIndex := 0;
    LoadInActivate := True;
  Finally
    FileList.Free;
  End; // Try..Finally
End; // ScanForAudits

//-------------------------------------------------------------------------

Procedure TfrmAudit.btnCloseClick(Sender: TObject);
begin
  Close;
end;

//-------------------------------------------------------------------------

procedure TfrmAudit.btnArchiveClick(Sender: TObject);
begin
  If (MessageDlg('Are you sure you want to archive the Live Audit Trail now', mtConfirmation, [mbYes, mbNo], 0) = mrYes) Then
  Begin
    // The atArchive audit object will automatically create the archive file and clear down the live audit trail and an an archive audit item
    NewAuditInterface(atArchive).WriteAuditEntry;

    // Reload the combo
    ScanForAudits;
  End; // If (MessageDlg('...
end;

//-------------------------------------------------------------------------

procedure TfrmAudit.FindDialog1Find(Sender: TObject);
var
  FoundAt: LongInt;
  SearchStart : LongInt;
  SearchText : ANSIString;
begin
  // Determine starting position
  If (memAuditTrail.SelLength > 0) Then
    // Start after selection
    SearchStart := memAuditTrail.SelStart + memAuditTrail.SelLength
  Else
    // Start at cursor
    SearchStart := memAuditTrail.SelStart;

  // Extract text to search and convert to uppercase for a case-insensitive comparison
  SearchText := UpperCase(memAuditTrail.Text);
  If (SearchStart > 0) And (SearchStart < Length(SearchText)) Then
  Begin
    // Delete leading characters that we have no interest in
    Delete (SearchText, 1, SearchStart);
  End; // If (SearchStart > 0) And (SearchStart < Length(SearchText))

  // Search for matching text
  FoundAt := Pos(UpperCase(FindDialog1.FindText), SearchText);
  If (FoundAt > 0) Then
  Begin
    memAuditTrail.SelStart := SearchStart + FoundAt - 1;
    memAuditTrail.SelLength := Length(FindDialog1.FindText);
  End // If (FoundAt > 0)
  Else
    MessageDlg ('No matching text was found', mtInformation, [mbOK], 0); 
end;

//------------------------------

procedure TfrmAudit.btnFindClick(Sender: TObject);
begin
  FindDialog1.Execute;
end;

//-------------------------------------------------------------------------

procedure TfrmAudit.btnCopyClick(Sender: TObject);
begin
  If (Trim(memAuditTrail.SelText) <> '') Then
    memAuditTrail.CopyToClipboard
  Else
    MessageDlg('No text has been selected for copying to the clipboard', mtWarning, [mbOK], 0);
end;

//-------------------------------------------------------------------------

procedure TfrmAudit.btnSaveAsClick(Sender: TObject);
begin
  If SaveDialog1.Execute Then
  Begin
    memAuditTrail.Lines.SaveToFile(SaveDialog1.Filename);
  End; // If SaveDialog1.Execute
end;

//-------------------------------------------------------------------------

procedure TfrmAudit.btnSelectAllClick(Sender: TObject);
begin
  memAuditTrail.SelectAll;
  memAuditTrail.SetFocus;
end;

//-------------------------------------------------------------------------

procedure TfrmAudit.PopupMenu1Popup(Sender: TObject);
begin
  mnuArchive.Enabled := btnArchive.Enabled;
  mnuFind.Enabled := btnFind.Enabled;
  mnuCopy.Enabled := btnCopy.Enabled;
  mnuSaveAs.Enabled := btnSaveAs.Enabled;
  mnuSelectAll.Enabled := btnSelectAll.Enabled;

  StoreCoordFlg.Checked := StoreCoord;
end;

//------------------------------

procedure TfrmAudit.mnuPropertiesClick(Sender: TObject);
begin
  if Assigned(FSettings) then
    if FSettings.Edit(panMemoHost, memAuditTrail) = mrOK then
    Begin
      NeedCUpdate := True;
      cmbAvailableAuditFiles.Color := memAuditTrail.Color;
    End; // if FSettings.Edit(memAuditTrail, memAuditTrail) = mrOK
end;

//------------------------------

procedure TfrmAudit.StoreCoordFlgClick(Sender: TObject);
begin
  StoreCoord := Not StoreCoord;
  NeedCUpdate := True;
end;

//-------------------------------------------------------------------------

procedure TfrmAudit.cmbAvailableAuditFilesClick(Sender: TObject);
Var
  oLogName : TLogName;
  AuditPath : ShortString;
  I : SmallInt;
  LogLines : LongInt;
  ExistingActiveControl : TWinControl;
begin
  // Remove any existing log
  memAuditTrail.Lines.Clear;

  If (cmbAvailableAuditFiles.ItemIndex >= 0) Then
  Begin
    oLogName := TLogName(cmbAvailableAuditFiles.Items.Objects[cmbAvailableAuditFiles.ItemIndex]);
    If FileExists(AuditDirectory + oLogName.LogFilename) Then
    Begin
      // Save and restore the ActiveControl as the progress panel upsets it
      ExistingActiveControl := Self.ActiveControl;
      UpdateProgress ('Loading ' + oLogName.LogDescription + ', please wait...', True);
      Try
        { CJS ABSEXCH-14003 - extensions to Audit system }
        Caption := 'System Audit: ' + oLogName.LogDescription;
        SaveDialog1.FileName := ChangeFileExt (oLogName.LogFilename, '');

        With TAuditLogReader.Create (AuditDirectory + oLogName.LogFilename) Do
        Begin
          Try
            I := ReadAuditLog;
            If (I = 0) Then
            Begin
              If (AuditStrings.Count > 0) Then
              Begin
                memAuditTrail.Lines.BeginUpdate;
                Try
                  ProgressBar1.Min := 0;
                  ProgressBar1.Max := (AuditStrings.Count - 1);
                  ProgressBar1.Step := IfThen(AuditStrings.Count > 100, 100, AuditStrings.Count);
                  For LogLines := 0 To (AuditStrings.Count - 1) Do
                  Begin
                    memAuditTrail.Lines.Add (AuditStrings[LogLines]);
                    If ((LogLines Mod 100) = 0) Then
                    Begin
                      ProgressBar1.StepIt;
                      Application.ProcessMessages;
                    End; // If ((LogLines Mod 100) = 0)
                  End; // For I
                Finally
                  memAuditTrail.Lines.EndUpdate;
                End; // Try..Finally
                memAuditTrail.SelStart := 0;
              End; // If (AuditStrings.Count > 0)
            End // If (I = 0)
            Else
              ShowMessage ('ReadAuditLog: ' + IntToStr(I));
          Finally
            Free;
          End; // Try..Finally
        End; // With TAuditLogReader.Create (AuditDirectory + oLogName.LogFilename)
      Finally
        UpdateProgress('', False, oLogName.IsLIVE);
        Self.ActiveControl := ExistingActiveControl;
      End; // Try..Finally
    End; // If FileExists(AuditDirectory + oLogName.LogFilename)
  End; // If (cmbAvailableAuditFiles.ItemIndex >= 0)
end;

//-------------------------------------------------------------------------

end.
