unit MenuManager;

interface

Uses
  Classes, Dialogs, Menus, SysUtils, Windows, EntMenuU, IncludeCustMenu;

Type
  TRWMenuManager = Class(TObject)
  Private
    FDataPath : ShortString;
    FMainMenu : TMainMenu;
    FNewMenuFunc : NewMenuFunc;            // Function to create new menu option
//    FRunsRW : Boolean;                     // Indicates whether the logged in user has rights to run the RW
    FRWLicenced, FVRWLicenced, FVRWAvailable : Boolean;                     // Indicates whether the logged in user has rights to run the RW
    FUserId : ShortString;

    FEntReportsMenu : TMenuItem;  // Handle to the Enterprise Reports menu option
    FEntReportWriterMenuOpt : TMenuItem;   // Handle to the standard Report Writer menu option
    FRepWrtSubMenu : TMenuItem;   // Handle to the Report Writer sub-menu created by this plug-in
    FVisualRWMenuOpt : TMenuItem;   // Handle to the Preview RW menu-option created by this plug-in

    procedure SetNewMenuFunc (Value : NewMenuFunc);
    procedure ReportsMenuOnClick(Sender: TObject);
  Public
    procedure MoveReportWriterOptions;
//    bLicenced : boolean;
    Property mmDataPath : ShortString Read FDataPath Write FDataPath;
    Property mmMainMenu : TMainMenu Read FMainMenu write FMainMenu;
    Property mmNewMenuFunc : NewMenuFunc Read FNewMenuFunc write SetNewMenuFunc;
    Property mmVRWAvailable : Boolean Read FVRWAvailable Write FVRWAvailable;
    Property mmVRWLicenced : Boolean Read FVRWLicenced Write FVRWLicenced;
    Property mmRWLicenced : Boolean Read FRWLicenced Write FRWLicenced;
    Property mmUserId : ShortString Read FUserId Write FUserId;

//    Property mmReportWriterMI : TMenuItem Read FEntRepWrtMenu;

    Constructor Create;
    Destructor Destroy; Override;

    // Called when Enterprise is opened and when the new dataset is being opened in
    // a File-Open Company operation
    Procedure SetupMenus;

    // Called when the current dataset is being closed in a File-Open Company operation
    Procedure RemoveMenus;

    // OnClick event handler for the Preview Report Writer menu option
    procedure MenuOpt_OpenPreviewRWClick(Sender: TObject);
  End; // TRWMenuManager


// Access function for a global TRWMenuManager object which is
// automatically created by the routine the first time it is called.
Function RWMenuManager : TRWMenuManager;

implementation

Uses
  ShellAPI, Forms, ChainU, EntLicence;

Var
  oRWMenuManager : TRWMenuManager;

//=========================================================================

Function RWMenuManager : TRWMenuManager;
Begin // RWMenuManager
  If (Not Assigned(oRWMenuManager)) Then
    oRWMenuManager := TRWMenuManager.Create;

  Result := oRWMenuManager;
End; // RWMenuManager

//=========================================================================

Constructor TRWMenuManager.Create;
Begin // Create
  Inherited Create;
  FVRWLicenced := FALSE;
//  bLicenced := FALSE;

  // Create list for storing the custom menu options
End; // Create

//------------------------------

Destructor TRWMenuManager.Destroy;
Begin // Destroy
                          
  Inherited Destroy;
End; // Destroy

//-------------------------------------------------------------------------

Procedure TRWMenuManager.SetNewMenuFunc (Value : NewMenuFunc);
Begin // SetNewMenuFunc
  FNewMenuFunc := Value;

//  bLicenced := FALSE;
//  FEntReportsMenu := nil;
//  FEntRepWrtMenu := nil;

(*  If Not Assigned(FEntReportsMenu) Then
  Begin
    // Find Reports Menu off main window in Enterprise
    FEntReportsMenu := FMainMenu.Items.Find('Reports');

    If Assigned(FEntReportsMenu) Then
    Begin
      // Get a handle to the pre-existing Report Writer menu option
      FEntRepWrtMenu := FEntReportsMenu.Find('Report Writer');
//      bLicenced := FEntRepWrtMenu <> nil;
    End; // If Assigned(FEntReportsMenu)
  End; // If Not Assigned(FEntReportsMenu)

  If Assigned(FEntReportsMenu) And Assigned(FEntRepWrtMenu) Then
  Begin
    // Check to see if the user is allowed to run the Report Writer
    If  FVRWAvailable {Not Assigned(FRepWrtSubMenu)} Then
    Begin
      // Create new sub-menu to contain the current and preview report writers
      FRepWrtSubMenu := FNewMenuFunc('Report Writers', DLLChain.ModuleName + '_ReportWriters');
      FRepWrtSubMenu.AutoHotKeys := maManual;
      FRepWrtSubMenu.AutoLineReduction := maManual;
      FRepWrtSubMenu.Hint := 'Enterprise Reporting Utilities';
      FEntReportsMenu.Add (FRepWrtSubMenu);

      // Move the standard Report Writer menu option into the sub-group
      FEntReportsMenu.Delete(FEntRepWrtMenu.MenuIndex);
      FRepWrtSubMenu.Add (FEntRepWrtMenu);

      // Create a menu option for the Preview Report Writer
      FPreviewRWMenu := FNewMenuFunc('Visual Report Writer', DLLChain.ModuleName + '_PreviewRW');
      FPreviewRWMenu.AutoHotKeys := maManual;
      FPreviewRWMenu.AutoLineReduction := maManual;
      FPreviewRWMenu.Hint := 'Visual Report Writer';
      FPreviewRWMenu.OnClick := MenuOpt_OpenPreviewRWClick;
      FRepWrtSubMenu.Add (FPreviewRWMenu);
    End; // If Not Assigned(FRepWrtSubMenu)
  End; // If Assigned(FEntReportsMenu)*)
End; // SetNewMenuFunc

//-------------------------------------------------------------------------

// Called when Enterprise is opened and when the new dataset is being opened in
// a File-Open Company operation.  Will lookup the users custom menu options for
// the dataset and create the appropriate menu options.
Procedure TRWMenuManager.SetupMenus;
Begin // SetupMenus
  // Check we have a valid user id before continuing - due to an 'Enterprise Feature'
  // we won't have a User Id if they haven't edited the user profile since the
  // Enhanced Security was added
//  bLicenced := FVRWAvailable;

(*** MH 17/09/07: Removed RW/VRW menu manipulation as is handled by Enter1.Exe for v6.00
{$IFNDEF REMOVE_VRW}
  If (Trim(FUserId) <> '') Then
  Begin
    If Assigned(FRepWrtSubMenu) Then
    Begin
      // Show the Report Writer sub-menu if the standard Report Writer menu option is available to the user
      FVisualRWMenuOpt.Visible := FVRWAvailable;
    End; // If Assigned(FRepWrtSubMenu)

    // Now we need to lookup the details of the custom report menu options for this
    // user and dataset and add them into Enterprise

//    ShowMessage ('Setup custom RW menus for:-'#13'User: '+FUserId+#13'Dataset: '+FDataPath);
  End; // If (Trim(FUserId) <> '')
{$ENDIF}
***)
End; // SetupMenus

//-------------------------------------------------------------------------

// Called when the current dataset is being closed in a File-Open Company operation,
// needs to remove the menu options added in SetupMenus, if any, ready for when the
// new company dataset is opened which will have different menu mods to be applied
Procedure TRWMenuManager.RemoveMenus;
Begin // RemoveMenus
(*** MH 17/09/07: Removed RW/VRW menu manipulation as is handled by Enter1.Exe for v6.00
{$IFNDEF REMOVE_VRW}
  if (EnterpriseLicence.elProductType in [ptLITECust, ptLITEAcct]) then
  begin
    // IAO - Just remove option
    if Assigned(FEntReportsMenu) and Assigned(FVisualRWMenuOpt) then
    begin
      FEntReportsMenu.Delete(FVisualRWMenuOpt.MenuIndex);
      Freeandnil(FVisualRWMenuOpt);
    end;{if}
  end else
  begin
    if Assigned(FRepWrtSubMenu) then
    begin
      // NOTE: To simplify things we can just hide the RW submenu and re-show it if applicable
      // for the new dataset
  //    FRepWrtSubMenu.Visible := False;

      if Assigned(FEntReportWriterMenuOpt)
      then FRepWrtSubMenu.Delete(FEntReportWriterMenuOpt.MenuIndex);

      if Assigned(FVisualRWMenuOpt)
      then FRepWrtSubMenu.Delete(FVisualRWMenuOpt.MenuIndex);

      if Assigned(FEntReportsMenu)
      then FEntReportsMenu.Delete(FRepWrtSubMenu.MenuIndex);

      FEntReportsMenu.Add(FEntReportWriterMenuOpt);

      Freeandnil(FRepWrtSubMenu);
      Freeandnil(FVisualRWMenuOpt);
  //    FEntReportWriterMenuOpt := nil;
    end; // If Assigned(FRepWrtSubMenu)
  end;{if}
  // Now we need to remove and free any custom menus added for the currently open
  // dataset otherwise they will still be intact for the new dataset

//  ShowMessage ('Remove custom RW menus');
{$ENDIF}
***)
End; // RemoveMenus

//-------------------------------------------------------------------------

// OnClick event handler for the Preview Report Writer menu option
procedure TRWMenuManager.MenuOpt_OpenPreviewRWClick(Sender: TObject);
var
  CmdStr : array[0..255] of char;
  ssExePath : ShortString;
  cmdFile, cmdPath, cmdParams : PChar;
  Flags : SmallInt;
begin
(*** MH 17/09/07: Removed RW/VRW menu manipulation as is handled by Enter1.Exe for v6.00
//  ShowMessage ('Open Preview RW');
{  ssExePath := ExtractFilePath(Application.ExeName);
  FillChar (CmdStr, SizeOf(CmdStr), #0);
  StrPCopy(CmdStr,  ssExePath + 'ENTRW.EXE /DIR: '+FDataPath+' /USER: '+FUserId+' /JLHABB');
  WinExec(CmdStr, SW_SHOWNORMAL);}


  cmdFile   := StrAlloc(255);
  cmdPath   := StrAlloc(255);
  cmdParams := StrAlloc(255);

  StrPCopy (cmdFile, ExtractFilePath(Application.ExeName) + 'ENTRW.EXE');
  StrPCopy (cmdParams, '/DIR: '+FDataPath+' /USER: '+FUserId+' /JLHABB');
  StrPCopy (cmdPath, ExtractFilePath(Application.ExeName));

  Flags := SW_SHOWNORMAL;
  ShellExecute(Application.MainForm.Handle, NIL, cmdFile, cmdParams, cmdPath, Flags);

  StrDispose(cmdFile);
  StrDispose(cmdPath);
  StrDispose(cmdParams);
***)
end;

//=========================================================================

procedure TRWMenuManager.MoveReportWriterOptions;
begin
(*** MH 17/09/07: Removed RW/VRW menu manipulation as is handled by Enter1.Exe for v6.00
{$IFNDEF REMOVE_VRW}
  If Not Assigned(FEntReportsMenu) Then
  Begin
    // Find Reports Menu off main window in Enterprise
    FEntReportsMenu := FMainMenu.Items.Find('Reports');

    If Assigned(FEntReportsMenu) Then
    Begin
      FEntReportsMenu.OnClick := ReportsMenuOnClick;
      // Get a handle to the pre-existing Report Writer menu option
      FEntReportWriterMenuOpt := FEntReportsMenu.Find('Report Writer');
//      bLicenced := FEntRepWrtMenu <> nil;
    End; // If Assigned(FEntReportsMenu)
  End; // If Not Assigned(FEntReportsMenu)

  If Assigned(FEntReportsMenu) Then
  Begin
    // Check to see if the user is allowed to run the Report Writer
{    If  FVRWAvailable {Not Assigned(FRepWrtSubMenu) Then
    Begin}

      if not (EnterpriseLicence.elProductType in [ptLITECust, ptLITEAcct]) then
      begin
        // Create new sub-menu to contain the current and preview report writers
        FRepWrtSubMenu := FNewMenuFunc('Report Writers', DLLChain.ModuleName + '_ReportWriters');
        FRepWrtSubMenu.AutoHotKeys := maManual;
        FRepWrtSubMenu.AutoLineReduction := maManual;
        FRepWrtSubMenu.Hint := 'Exchequer Reporting Utilities';
        FEntReportsMenu.Add (FRepWrtSubMenu);

        // Move the standard Report Writer menu option into the sub-menu
        If Assigned(FEntReportWriterMenuOpt) Then
        begin
          FEntReportsMenu.Delete(FEntReportWriterMenuOpt.MenuIndex);
          FRepWrtSubMenu.Add(FEntReportWriterMenuOpt);
        end;{if}
      end;{if}

      // Create a menu option for the Visual Report Writer
      FVisualRWMenuOpt := FNewMenuFunc('Visual Report Writer', DLLChain.ModuleName + '_PreviewRW');
      FVisualRWMenuOpt.AutoHotKeys := maManual;
      FVisualRWMenuOpt.AutoLineReduction := maManual;
      FVisualRWMenuOpt.Hint := 'Visual Report Writer';
      FVisualRWMenuOpt.OnClick := MenuOpt_OpenPreviewRWClick;

      if EnterpriseLicence.elProductType in [ptLITECust, ptLITEAcct]
      then FEntReportsMenu.Add (FVisualRWMenuOpt)  // Add VRW Option into then main "Reports" Menu
      else FRepWrtSubMenu.Add (FVisualRWMenuOpt);  // Add VRW Option into the "Report Writers" Submenu

//    End; // If Not Assigned(FRepWrtSubMenu)
  End; // If Assigned(FEntReportsMenu)
{$ENDIF}
***)
end;

procedure TRWMenuManager.ReportsMenuOnClick(Sender: TObject);
begin
(*** MH 17/09/07: Removed RW/VRW menu manipulation as is handled by Enter1.Exe for v6.00
//  showmessage('ReportsMenuOnClick');
//  FVisualRWMenuOpt.Caption := 'xxxxx';

{  if (FVisualRWMenuOpt = nil) and FEntReportWriterMenuOpt.Visible and FVRWLicenced then
  begin
    RemoveMenus;
    MoveReportWriterOptions;
    SetupMenus;
  end;{if}

  // make the VRW option the same visibility as the RW option
{  if Assigned(FVisualRWMenuOpt) and Assigned(FEntReportWriterMenuOpt) then
  begin
    if FVRWLicenced then FVisualRWMenuOpt.Visible := FEntReportWriterMenuOpt.Visible;
  end;{if}

  // remove "Report Writers" Menu if no options are in it
{  if ((FVisualRWMenuOpt = nil) or (FVisualRWMenuOpt.Visible = FALSE))
  and ((FEntReportWriterMenuOpt = nil) or (FEntReportWriterMenuOpt.Visible = FALSE))
  and Assigned(FEntReportsMenu) and Assigned(FRepWrtSubMenu)
  and (FRepWrtSubMenu.MenuIndex <> -1)
  then FEntReportsMenu.Delete(FRepWrtSubMenu.MenuIndex);}

  try
    if Assigned(FEntReportsMenu) and Assigned(FRepWrtSubMenu)
    and Assigned(FEntReportWriterMenuOpt) and Assigned(FVisualRWMenuOpt) then
    begin
      // make the VRW option the same visibility as the RW option
      if FVRWLicenced and FRWLicenced
      then FVisualRWMenuOpt.Visible := {FVRWLicenced and} FEntReportWriterMenuOpt.Visible;

      // remove "Report Writers" Menu if no options are in it
      FRepWrtSubMenu.Visible := FVisualRWMenuOpt.Visible or FEntReportWriterMenuOpt.Visible;
    end;{if}
  except
    // just in case some nasty error occurs - not that it should, but you never know....
  end;{try}

  // make the VRW option the same visibility as the RW option
{  if Assigned(FVisualRWMenuOpt) and Assigned(FEntReportWriterMenuOpt) then
  begin
    if FVRWLicenced then FVisualRWMenuOpt.Visible := FEntReportWriterMenuOpt.Visible;
  end;{if}

  // remove "Report Writers" Menu if no options are in it
{  if ((FVisualRWMenuOpt = nil) or (FVisualRWMenuOpt.Visible = FALSE))
  and ((FEntReportWriterMenuOpt = nil) or (FEntReportWriterMenuOpt.Visible = FALSE))
  and Assigned(FEntReportsMenu) and Assigned(FRepWrtSubMenu)
  and (FRepWrtSubMenu.MenuIndex <> -1)
  then FEntReportsMenu.Visible := FALSE;}

{            RWMenuManager.RemoveMenus;

            InitToolkit(Setup.ssDataPath);
            RWMenuManager.mmVRWAvailable
            := ((oToolkit.SystemSetup.ssReleaseCodes as ISystemSetupReleaseCodes2).rcVisualReportWriter = rcEnabled) // VRW released
            and (UserProfile.upSecurityFlags[193] <> 0);  // User level Access to Report Writer
            RWMenuManager.MoveReportWriterOptions;
            RWMenuManager.SetupMenus;

            If Assigned (oToolkit) then oToolkit.CloseToolkit;
            oToolkit := NIL;}

//  inherited;
***)
end;

Initialization
  oRWMenuManager := NIL;
Finalization
  FreeAndNIL(oRWMenuManager);
end.
