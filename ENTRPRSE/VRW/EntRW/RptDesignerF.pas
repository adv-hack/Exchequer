unit RptDesignerF;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StrUtils,
  DesignerTypes, GlobalTypes,
  VRWReportIF, frmVRWRangeFiltersU, frmVRWReportPropertiesU,  // IVRWReport
  RptWizardTypes,
  RptEngDll, ImgList, Menus, ExtCtrls, ComCtrls, Buttons, ToolWin, ExtDlgs,
  StdCtrls, ThemeMgr, AdvToolBar, AdvToolBarStylers, AdvGlowButton
  ;

type
  TSaveReport = Procedure(Params: TReportWizardParams; ParentName, FileName: string; var FunctionResult: Integer) Of Object;

  //------------------------------

  TfrmReportDesigner = class(TForm)
    scRegionWindow: TScrollBox;
    RWMainMenu: TMainMenu;
    menuFile: TMenuItem;
    miCloseReport: TMenuItem;
    menuControls: TMenuItem;
    miAddText: TMenuItem;
    miAddFormula: TMenuItem;
    miAddDBField: TMenuItem;
    miAddBox: TMenuItem;
    miAddImage: TMenuItem;
    N2: TMenuItem;
    miRangeFilters: TMenuItem;
    menuReport: TMenuItem;
    miAddReportSection: TMenuItem;
    miReportProperties: TMenuItem;
    Help1: TMenuItem;
    Contents1: TMenuItem;
    SearchforHelpOn1: TMenuItem;
    HowtoUseHelp1: TMenuItem;
    N3: TMenuItem;
    About1: TMenuItem;
    ilRegionIcons: TImageList;
    miPrint: TMenuItem;
    miSaveReport: TMenuItem;
    N5: TMenuItem;
    N6: TMenuItem;
    miControlsTree: TMenuItem;
    N7: TMenuItem;
    N1: TMenuItem;
    menuEdit: TMenuItem;
    miPaste: TMenuItem;
    miCopy: TMenuItem;
    miCut: TMenuItem;
    N4: TMenuItem;
    miDelete: TMenuItem;
    StatusBar: TPanel;
    Panel3: TPanel;
    pnlCursorPos: TPanel;
    pnlSelectionCriteria: TPanel;
    pnlRangeFilter: TPanel;
    pnlControlPos: TPanel;
    pnlPrintIf: TPanel;
    pnlHint: TPanel;
    pnlProgress: TPanel;
    pbReportProgress: TProgressBar;
    pnlCancel: TPanel;
    btnCancelPrint: TButton;
    miCancelPrint: TMenuItem;
    miDefaultFont: TMenuItem;
    N8: TMenuItem;
    ThemeManager1: TThemeManager;
    miInputFields: TMenuItem;
    AdvDockPanel: TAdvDockPanel;
    AdvToolBar1: TAdvToolBar;
    AdvToolBar: TAdvToolBarOfficeStyler;
    tbSaveReport: TAdvGlowButton;
    AdvToolBarSeparator1: TAdvToolBarSeparator;
    tbReportText: TAdvGlowButton;
    tbReportImage: TAdvGlowButton;
    tbReportBox: TAdvGlowButton;
    tbReportDBField: TAdvGlowButton;
    AdvToolBarSeparator2: TAdvToolBarSeparator;
    tbReportFormula: TAdvGlowButton;
    tbRunReport: TAdvGlowButton;
    AdvToolBarSeparator3: TAdvToolBarSeparator;
    tbReportTree: TAdvGlowButton;
    tbCancelReport_SourceImages: TAdvGlowButton;
    tbRunReport_SourceImages: TAdvGlowButton;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FormMouseWheelDown(Sender: TObject; Shift: TShiftState;
      MousePos: TPoint; var Handled: Boolean);
    procedure FormMouseWheelUp(Sender: TObject; Shift: TShiftState;
      MousePos: TPoint; var Handled: Boolean);
    procedure sbSaveReportClick(Sender: TObject);
    procedure miPrintClick(Sender: TObject);
    procedure miCloseReportClick(Sender: TObject);
    procedure miControlsTreeClick(Sender: TObject);
    procedure miRangeFiltersClick(Sender: TObject);
    procedure miAddReportSectionClick(Sender: TObject);
    procedure miReportPropertiesClick(Sender: TObject);
    procedure Contents1Click(Sender: TObject);
    procedure SearchforHelpOn1Click(Sender: TObject);
    procedure HowtoUseHelp1Click(Sender: TObject);
    procedure About1Click(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure miCutClick(Sender: TObject);
    procedure miCopyClick(Sender: TObject);
    procedure miPasteClick(Sender: TObject);
    procedure menuEditClick(Sender: TObject);
    procedure miDeleteClick(Sender: TObject);
    procedure scRegionWindowMouseMove(Sender: TObject; Shift: TShiftState;
      X, Y: Integer);
    procedure btnCancelPrintClick(Sender: TObject);
    procedure miDefaultFontClick(Sender: TObject);
    procedure tbSaveReportClick(Sender: TObject);
    procedure tbReportTextClick(Sender: TObject);
    procedure tbReportImageClick(Sender: TObject);
    procedure tbReportBoxClick(Sender: TObject);
    procedure tbReportDBFieldClick(Sender: TObject);
    procedure tbReportFormulaClick(Sender: TObject);
    procedure tbRunReportClick(Sender: TObject);
    procedure tbReportTreeClick(Sender: TObject);
    procedure OnControlAdded(Added: Boolean);
    procedure miInputFieldsClick(Sender: TObject);
  private
    { Private declarations }
    // Interface reference to Region Manager object which integrates the separate
    // regions and provides a central contact point
    FRegionManager : IRegionManager;

    // Co-ords of previous mouse position which are cache'd to minimise painting
    PrevPos : TPoint;

    // Callback to Report Tree for saving the Report Details
    FOnSaveReport : TSaveReport;

    FAfterPrintReport: TReportDesignerPrintEvent;

    FTreeParent : ShortString;

    FCancelPrint: Boolean;

    FWasPrinted: Boolean;

    // Keeps track of the toolbutton that was clicked for adding a control
    // to the designer.
    //FButtonClicked: TToolButton;
    FButtonClicked: TAdvGlowButton;
    FUserID: ShortString;

    Function GetReportFileName : ShortString;
    Procedure SetReportFileName (Value : ShortString);
    Procedure SetOnSaveReport (Value : TSaveReport);
    Procedure SetTreeParent (Value : ShortString);

    // Handles the OnUpdateControlInfo event coming from the RegionManager object
    Procedure OnUpdateControlInfo(Const ControlPos, ControlRF, ControlSC, ControlIF, ControlDesc : ShortString);
    // Handles the OnUpdateCursorPosition event coming from the RegionManager object
    Procedure OnUpdateCursorPosition(Const X, Y : LongInt);

    { Callback routines from the report }
    procedure OnPrintRecord(Count, Total: integer; var Abort: Boolean);
    procedure OnFirstPass(Count, Total: integer; var Abort: Boolean);
    procedure OnSecondPass(Count, Total: integer; var Abort: Boolean);

    procedure BeforePrinting;
    procedure AfterPrinting;

    //procedure ToggleButton(Button: TToolbutton);
    procedure ToggleButton(Button: TAdvGlowButton);
  public
    { Public declarations }
    Property rdReportFileName : ShortString Read GetReportFileName Write SetReportFileName;
    Property rdTreeParent : ShortString Read FTreeParent Write SetTreeParent;

    Property OnSaveReport : TSaveReport Read FOnSaveReport Write SetOnSaveReport;
    property AfterPrintReport: TReportDesignerPrintEvent
      read FAfterPrintReport
      write FAfterPrintReport;
    property UserID: ShortString read FUserID write FUserID;

    // Called from the Report Tree to create a new report from the Add Report Wizard details
    Procedure CreateNewReport (Const NewReportDets : TReportWizardParams);

    // Called from the Report Tree when importing a report converted from the
    // old report writer.
    procedure AssignReport(Report: IVRWReport);
  end;

implementation

{$R *.dfm}

Uses RegionMgr, Region, RWOpenF, DesignerUtil, rpDefine, GlobVar, VarConst, AboutF;

//=========================================================================

procedure TfrmReportDesigner.FormCreate(Sender: TObject);
begin
  tbRunReport_SourceImages.Visible    := False;
  tbCancelReport_SourceImages.Visible := False;

  // Create a new Region Manager object and setup the links
  FRegionManager := NewRegionManager (Self, scRegionWindow, ilRegionIcons);
  FRegionManager.OnUpdateControlInfo := Self.OnUpdateControlInfo;
  FRegionManager.OnUpdateCursorPosition := Self.OnUpdateCursorPosition;
  FRegionManager.OnControlAdded := self.OnControlAdded;

  miCloseReport.ShortCut := TextToShortCut('Alt+F4');
end;

//------------------------------

procedure TfrmReportDesigner.FormDestroy(Sender: TObject);
begin
  FRegionManager := NIL;
end;

//-------------------------------------------------------------------------

procedure TfrmReportDesigner.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
begin
  if (btnCancelPrint.Enabled) then
  begin
    btnCancelPrintClick(nil);
    CanClose := FCancelPrint;
  end
  else if FRegionManager.rmChanged Then
  Begin
    Case MessageDlg('Do you want to save the changes you made to the Report?', mtWarning, [mbYes, mbNo, mbCancel], 0) Of
      mrYes     : Begin
                    // Save changes and close
                    tbSaveReportClick(Sender);
                    CanClose := True;
                  End; // mrYes
      mrNo      : Begin
                    // Close without saving changes
                    CanClose := True;
                  End; // mrNo
      mrCancel  : Begin
                    // Cancel the Close and return to the designer
                    CanClose := False;
                  End; // mrCancel
    Else
      Raise Exception.Create ('TfrmReportDesigner.FormCloseQuery: Unhandled Message result');
    End; // Case MessageDlg('Do you want to save the changes ...
  End; // If FRegionManager.rmChanged
end;

//-------------------------------------------------------------------------

procedure TfrmReportDesigner.FormMouseWheelDown(Sender: TObject; Shift: TShiftState; MousePos: TPoint; var Handled: Boolean);
begin
  scRegionWindow.VertScrollBar.Position := scRegionWindow.VertScrollBar.Position + scRegionWindow.VertScrollBar.Increment;
  Handled := True;
end;

//------------------------------

procedure TfrmReportDesigner.FormMouseWheelUp(Sender: TObject; Shift: TShiftState; MousePos: TPoint; var Handled: Boolean);
begin
  scRegionWindow.VertScrollBar.Position := scRegionWindow.VertScrollBar.Position - scRegionWindow.VertScrollBar.Increment;
  Handled := True;
end;

//-------------------------------------------------------------------------

Procedure TfrmReportDesigner.OnUpdateControlInfo(Const ControlPos, ControlRF, ControlSC, ControlIF, ControlDesc : ShortString);
Begin // OnUpdateControlInfo
  pnlControlPos.Caption := ControlPos;
  pnlRangeFilter.Caption := ControlRF;
  pnlSelectionCriteria.Caption := ControlSC;
  pnlPrintIf.Caption := ControlIF;
  pnlHint.Caption := ' ' + ControlDesc;
End; // OnUpdateControlInfo

//------------------------------

Procedure TfrmReportDesigner.OnUpdateCursorPosition(Const X, Y : LongInt);
Begin // OnUpdateCursorPosition
  If (PrevPos.X <> X) Or (PrevPos.Y <> Y) Then
  Begin
    If (X >= 0) And (Y >= 0) Then
      pnlCursorPos.Caption := Format('X: %dmm, Y: %dmm', [X, Y])
    Else
      pnlCursorPos.Caption := '';

    PrevPos.X := X;
    PrevPos.Y := Y;
  End; // If (PrevPos.X <> X) Or (PrevPos.Y <> Y)
End; // OnUpdateCursorPosition

//-------------------------------------------------------------------------

Function TfrmReportDesigner.GetReportFileName : ShortString;
Begin // GetReportFileName
  Result := FRegionManager.rmReport.vrFilename;
End; // GetReportFileName
Procedure TfrmReportDesigner.SetReportFileName (Value : ShortString);
Begin // SetReportFileName
  Screen.Cursor := crHourGlass;
  try
    FRegionManager.LoadReport(Value, True);
  finally
    Screen.Cursor := crDefault;
  end;
End; // SetReportFileName

//------------------------------

Procedure TfrmReportDesigner.SetOnSaveReport (Value : TSaveReport);
Begin // SetOnSaveReport
  FOnSaveReport := Value;
End; // SetOnSaveReport

//------------------------------

Procedure TfrmReportDesigner.SetTreeParent (Value : ShortString);
Begin // SetTreeParent
  FTreeParent := Value;
End; // SetTreeParent

//-------------------------------------------------------------------------

procedure TfrmReportDesigner.sbSaveReportClick(Sender: TObject);
Var
  Params         : TReportWizardParams;
  FunctionResult : Integer;
begin
  FRegionManager.SaveReport;

  If Assigned(FOnSaveReport) Then
  Begin
    Params := TReportWizardParams.Create;
    Params.wrReportName := FRegionManager.rmReport.vrName;
    Params.wrReportDesc := FRegionManager.rmReport.vrDescription;

    FOnSaveReport(Params, FTreeParent, ExtractFileName(FRegionManager.rmReport.vrFilename), FunctionResult);
    If (FunctionResult <> 0) Then
    Begin
      MessageDlg ('An error ' + IntToStr(FunctionResult) + ' occurred whilst saving the report',
                  mtError, [mbOK], 0);
    End; // If (FunctionResult <> 0)
  End; // If Assigned(FOnSaveReport)
end;

//-------------------------------------------------------------------------

procedure TfrmReportDesigner.miPrintClick(Sender: TObject);
var
  FuncRes: Integer;
begin
  if (btnCancelPrint.Enabled) then
  begin
    btnCancelPrintClick(nil);
  end
  else
  begin
    BeforePrinting;
    try
      (FRegionManager as IRegionManager2).rmUserID := FUserID;
      if FRegionManager.PrintReport then
      begin
        FWasPrinted := True;
        if Assigned(FAfterPrintReport) then
          AfterPrintReport('', FuncRes);
      end;
    finally
      AfterPrinting;
    end;
  end;
end;

//------------------------------

procedure TfrmReportDesigner.miCloseReportClick(Sender: TObject);
begin
  Close;
end;

//------------------------------

procedure TfrmReportDesigner.menuEditClick(Sender: TObject);
begin
  // Update Cut/Copy/Paste menu items depending on clipboard and control selection status
  if btnCancelPrint.Enabled then
  begin
    miCut.Enabled := False;
    miCopy.Enabled := False;
    miPaste.Enabled := False;
    miDelete.Enabled := False;
  end
  else
  begin
    // Cut - Disable if no controls selected in designer
    miCut.Enabled := (FRegionManager.rmSelectedControls.Count > 0);

    // Copy - Disable if no controls selected in designer
    miCopy.Enabled := (FRegionManager.rmSelectedControls.Count > 0);

    // Paste - Disable if no controls in clipboard
    miPaste.Enabled := FRegionManager.rmReport.CanPaste;

    // Delete - Disable if no controls selected in designer
    miDelete.Enabled := (FRegionManager.rmSelectedControls.Count > 0);
  end;
end;

//------------------------------

procedure TfrmReportDesigner.miCutClick(Sender: TObject);
begin
  FRegionManager.CutControls;
end;

//------------------------------

procedure TfrmReportDesigner.miCopyClick(Sender: TObject);
begin
  FRegionManager.CopyControls;
end;

//------------------------------

procedure TfrmReportDesigner.miPasteClick(Sender: TObject);
var
  Dummy: TPoint;
begin
//  ShowMessage ('TfrmReportDesigner.miPasteClick');
  FRegionManager.Paste(nil, Dummy);
end;

//------------------------------

procedure TfrmReportDesigner.miDeleteClick(Sender: TObject);
begin
  FRegionManager.DeleteControls;
end;

//------------------------------

procedure TfrmReportDesigner.miControlsTreeClick(Sender: TObject);
begin
  FRegionManager.ShowControlsTree;
end;

//------------------------------

procedure TfrmReportDesigner.miDefaultFontClick(Sender: TObject);
Var
  FontDialog : TFontDialog;
Begin // miDefaultFontClick
  FontDialog := TFontDialog.Create(Self);
  Try
    With FontDialog Do
    begin
      Font.Charset := DEFAULT_CHARSET;
      Font.Color := clWindowText;
      Font.Height := -11;
      Font.Name := 'MS Sans Serif';
      Font.Style := [];
      MinFontSize := 0;
      MaxFontSize := 0;
      Options := [fdEffects, fdForceFontExist];
    End; // With FontDialog

    CopyIFontToFont(FRegionManager.rmReport.vrFont, FontDialog.Font);

    If FontDialog.Execute Then
    Begin
      // Update The report
      CopyFontToIFont (FontDialog.Font, FRegionManager.rmReport.vrFont);
      FRegionManager.ChangeMade;
    End; // If FontDialog.Execute
  Finally
    FontDialog.Free;
  End; // Try..Finally
end; // miDefaultFontClick

//------------------------------

procedure TfrmReportDesigner.miRangeFiltersClick(Sender: TObject);
begin
//  ShowMessage ('Range Filters Not Coded');
  DisplayRangeFilters (FRegionManager.rmReport as IVRWReport3, rflmDesignTime); // IVRWReport
end;

//------------------------------

procedure TfrmReportDesigner.miInputFieldsClick(Sender: TObject);
begin
  DisplayRangeFilters (FRegionManager.rmReport as IVRWReport3, rflmDesignTime, rfdmInputFields); // IVRWReport
end;

//------------------------------

procedure TfrmReportDesigner.miAddReportSectionClick(Sender: TObject);
Var
  oRegion : TRegion;
  I, LastSection : SmallInt;
begin
  // Identify the next section number
  LastSection := 0;
  For I := 0 To (FRegionManager.rmRegions.Count - 1) Do
  Begin
    oRegion := TRegion(FRegionManager.rmRegions[I]);
    If (oRegion.reRegionDets.rgType = rtSectionHdr) And (oRegion.reRegionDets.rgSectionNumber > LastSection) Then
    Begin
      LastSection := oRegion.reRegionDets.rgSectionNumber;
    End; // If (oRegion.reRegionDets.rgType = rtSectionHdr) And (oRegion.reRegionDets.rgSectionNumber > LastSection)
  End; // For I

  If (MessageDlg('Are you sure you want to add Section ' + IntToStr(LastSection + 1) + ' into the report',
      mtConfirmation, [mbYes, mbNo], 0) = mrYes) Then
  Begin
    FRegionManager.AddNewSection(LastSection+1);
  End; // If (MessageDlg('Are you sure ...
end;

//------------------------------

procedure TfrmReportDesigner.miReportPropertiesClick(Sender: TObject);
var
  OldW, OldH: Integer;
begin
  if (FRegionManager.rmPaperOrientation = poLandscape) then
  begin
    OldW := FRegionManager.rmPaperSizeHeight;
    OldH := FRegionManager.rmPaperSizeWidth;
  end
  else
  begin
    OldW := FRegionManager.rmPaperSizeWidth;
    OldH := FRegionManager.rmPaperSizeHeight;
  end;
  If DisplayReportProperties(FRegionManager) Then
  Begin
    FRegionManager.UpdateDesignerCaption;
    FRegionManager.ChangeMade;
    { If a smaller paper size has been selected, make sure all the controls
      are moved to be inside the new dimensions }
    if ((FRegionManager.rmPaperOrientation = poLandscape) and
        (OldW > FRegionManager.rmPaperSizeHeight) or
        (OldH > FRegionManager.rmPaperSizeWidth)) or
       ((FRegionManager.rmPaperOrientation = poPortrait) and
        (OldW > FRegionManager.rmPaperSizeWidth) or
        (OldH > FRegionManager.rmPaperSizeHeight)) then
      FRegionManager.RealignControls;
  End; // if DisplayReportProperties(FRegionManager)
end;

//------------------------------

procedure TfrmReportDesigner.Contents1Click(Sender: TObject);
begin
//  Application.HelpCommand(HELP_Finder,0);
  Application.HelpCommand(15, 0);
end;

//------------------------------

procedure TfrmReportDesigner.SearchforHelpOn1Click(Sender: TObject);
const
  EmptyString: PChar = '';
begin
  Application.HelpCommand(HELP_PARTIALKEY, Longint(EmptyString));
end;

//------------------------------

procedure TfrmReportDesigner.HowtoUseHelp1Click(Sender: TObject);
begin
  Application.HelpCommand(HELP_HELPONHELP, 0);
end;

//------------------------------

procedure TfrmReportDesigner.About1Click(Sender: TObject);
begin
  TAboutFrm.Create(Application.MainForm).ShowModal;
end;

//-------------------------------------------------------------------------

// Called from the Report Tree to create a new report from the Add Report Wizard details
Procedure TfrmReportDesigner.CreateNewReport (Const NewReportDets : TReportWizardParams);
Var
  oRegion  : TRegionInfo;
  regTemp, regRepHdr, regPageHdr, regLines, regPageFtr, regRepFtr : IVRWRegion;
  regSecHdrArray, regSecFtrArray : Array Of IVRWRegion;
  DBFieldI : IVRWFieldControl;
  BoxI     : IVRWBoxControl;
  TextI    : IVRWTextControl;
  pDataRec : TDBFieldColumn;
  Fml      : IVRWFormulaControl;
  Dbf      : IVRWFieldControl;
  DBTotalI : IVRWFormulaControl;
  Control  : IVRWControl;
  I, J, NextLeft, NextTop, RightMost : SmallInt;
  Labels   : TInterfaceList;

  Function ToNextGridNodeX(Const XPos : LongInt) : LongInt;
  Begin // ToNextGridNodeX
    Result := (XPos Div FRegionManager.rmGridSizeXmm) * FRegionManager.rmGridSizeXmm;
    If ((XPos Mod FRegionManager.rmGridSizeXmm) <> 0) Then Result := Result + FRegionManager.rmGridSizeXmm;
  End; // ToNextGridNodeX

  Function ToNextGridNodeY(Const YPos : LongInt) : LongInt;
  Begin // ToNextGridNodeY
    Result := (YPos Div FRegionManager.rmGridSizeYmm) * FRegionManager.rmGridSizeYmm;
    If ((YPos Mod FRegionManager.rmGridSizeYmm) <> 0) Then Result := Result + FRegionManager.rmGridSizeYmm;
  End; // ToNextGridNodeY

Begin // CreateNewReport
  Labels := TInterfaceList.Create;
  With FRegionManager, rmReport Do
  Begin
    // Set the save flag
    ChangeMade;

    // Clear out any defaults
    Clear;

    vrName := NewReportDets.wrReportName;
    vrDescription := NewReportDets.wrReportDesc;
    vrFilename := SetDrive + 'REPORTS\' + Trim(vrName) + '.ERF';

    vrMainFile := NewReportDets.wrMainFileName;
    vrMainFileNum := NewReportDets.wrMainDbFile;
    vrIndexID := NewReportDets.wrIndex;

    vrTestModeParams.tmRefreshStart := True;
    vrTestModeParams.tmRefreshEnd   := True;

    vrPaperOrientation := Ord(poPortrait);
    FRegionManager.rmPaperOrientation := poPortrait;

    CopyFontToIFont (FRegionManager.rmReportFont, vrFont);

    // Setup arrays to store section header/footers
    SetLength(regSecHdrArray, NewReportDets.wrSortedFields.Count); // NOTE: 0 based array
    SetLength(regSecFtrArray, NewReportDets.wrSortedFields.Count); // NOTE: 0 based array

    // Create all the sections
    For I := 0 To (NewReportDets.wrSections.Count - 1) Do
    Begin
      oRegion := TRegionInfo(NewReportDets.wrSections[I]);

      regTemp := vrRegions.Add(rmReport, oRegion.RegionType, oRegion.SectionNo);
      regTemp.rgVisible := oRegion.RegionVisible;

      Case oRegion.RegionType Of
        rtRepHdr     : regRepHdr := regTemp;
        rtPageHdr    : regPageHdr := regTemp;
        rtSectionHdr : regSecHdrArray[oRegion.SectionNo - 1] := regTemp; // NOTE: 0 based array
        rtRepLines   : regLines := regTemp;
        rtSectionFtr : regSecFtrArray[oRegion.SectionNo - 1] := regTemp; // NOTE: 0 based array
        rtPageFtr    : regPageFtr := regTemp;
        rtRepFtr     : regRepFtr := regTemp;
      End; // Case oRegion.RegionType
    End; // For I

    // Create the controls in the Report Lines section and their titles in the Page Header section
    If Assigned(regPageHdr) And Assigned(regLines) And (NewReportDets.wrDBFieldList.Count > 0) Then
    Begin
{ TODO : The first control should really be positioned 1 mm after the left waste - if we knew what it was!}
      NextLeft := ToNextGridNodeX(1); // Start 1 mm in
      NextTop := 0; // Put controls right at the top to minimise wasted space
      RightMost := 0; // Keep track of right-hand edge for titles underline

      For I := 0 To (NewReportDets.wrDBFieldList.Count - 1) Do
      Begin
        pDataRec := NewReportDets.wrDBFieldList[I];

        If (pDataRec.SortIdx = 0) Then
        Begin
          // Create the DBField control in the Report Lines region
          DBFieldI := regLines.rgControls.Add(regLines.rgReport, ctField) As IVRWFieldControl;
          DBFieldI.vcLeft := NextLeft;
          DBFieldI.vcTop := NextTop;
          regTemp := regLines;
        End
        Else
        Begin
          // Create the DBField control in the appropriate Section Header region
          DBFieldI := regSecHdrArray[pDataRec.SortIdx - 1].rgControls.Add(regLines.rgReport, ctField) As IVRWFieldControl;
          DBFieldI.vcLeft := ToNextGridNodeX(1); // Start 1 mm in
          DBFieldI.vcTop := 0; // put at top of section header
          regTemp := regSecHdrArray[pDataRec.SortIdx - 1];
        End; // Else

        With DBFieldI Do
        Begin

          // Dimensions all specified in mm
          if pDataRec.DictRec.VarType in [2, 3] then
            AutoCalcControlSize (FRegionManager, DBFieldI, '999,999.99-')
          else
            AutoCalcControlSize (FRegionManager, DBFieldI, StringOfChar('M', pDataRec.DictRec.VarLen + 1));

          If (pDataRec.SortIdx = 0) And ((vcLeft + vcWidth) >= FRegionManager.rmPaperWidth) Then
          Begin
            // Off side of paper - try changing to landscape if not already using it
            If (FRegionManager.rmPaperOrientation = poPortrait) Then FRegionManager.rmPaperOrientation := poLandscape;

            // Now recheck whether it fits, if not move to next line
            If ((vcLeft + vcWidth) >= FRegionManager.rmPaperWidth) Then
            Begin
              NextLeft := ToNextGridNodeX(1); // Start 1 mm in
              NextTop := ToNextGridNodeY(vcTop + vcHeight); // snap to next vertical grid node
              vcTop := NextTop;
              vcLeft := NextLeft;
            End; // If ((vcLeft + vcWidth) >= FRegionManager.rmPaperWidth)
          End; // If ((vcLeft + vcWidth) >= FRegionManager.rmPaperWidth)

          // Set region height
          regTemp.rgHeight := vcTop + vcHeight;

          // Set DB Field properties
          vcFieldName := pDataRec.DictRec.VarName;
          vcVarNo := pDataRec.DictRec.VarNo;
          vcVarLen := pDataRec.DictRec.VarLen;
          vcVarDesc := pDataRec.DictRec.VarDesc;
          vcVarType := pDataRec.DictRec.VarType;
          If pDataRec.DictRec.VarDec Then
            Case pDataRec.DictRec.VarDecType of
              1 : vcVarNoDecs := Syss.NoCosDec;
              2 : vcVarNoDecs := Syss.NoNetDec;
              3 : vcVarNoDecs := Syss.NoQtyDec;
            End {Case..}
          Else
            vcVarNoDecs := pDataRec.DictRec.VarNoDec;

          If (pDataRec.DictRec.VarType In [2, 3, 6, 7]) Then
            // Float / Integer
            vcFieldFormat := 'R'
          Else
            vcFieldFormat := 'L';

          // Sorting
          If (pDataRec.SortIdx > 0) Then
          Begin
            vcSortOrder := IntToStr(pDataRec.SortIdx) + IfThen(pDataRec.SortAscending, 'A', 'D');
            vcPageBreak := pDataRec.PageBreak;
          End // If (pDataRec.SortIdx > 0)
          Else
          Begin
            vcSortOrder := '';
            vcPageBreak := False;
          End; // Else

          // Filter
          vcSelectCriteria := pDataRec.Filter;

          // Keep track of rightmost edge for the title underlining
          If ((vcLeft + vcWidth) > RightMost) Then RightMost := vcLeft + vcWidth;
        End; // With DBFieldI

        if pDataRec.SubTotal then
        begin
          // Add sub-totals in each section and in the report footer.
          for j := 0 To (NewReportDets.wrSections.Count - 1) Do
          Begin
            oRegion := TRegionInfo(NewReportDets.wrSections[j]);
            if oRegion.RegionType in [rtSectionFtr, rtRepFtr] then
            begin

              if (oRegion.RegionType = rtSectionFtr) then
              begin
                // Create the Total Field control in the appropriate Section Header region
                RegTemp := regSecFtrArray[oRegion.SectionNo - 1];
                DBTotalI := RegTemp.rgControls.Add(regLines.rgReport, ctFormula) As IVRWFormulaControl;
              end
              else
              begin
                RegTemp := regRepFtr;
                DBTotalI := RegTemp.rgControls.Add(regLines.rgReport, ctFormula) As IVRWFormulaControl;
              end;
              With DBTotalI Do
              Begin
                vcLeft := NextLeft; // Start 1 mm in
                vcTop := NextTop; // put at same offset as main field control
                vcWidth := DBFieldI.vcWidth;
                vcHeight := DBFieldI.vcHeight;

                // Set Total Field properties
                vcFormulaName := CreateUniqueFormulaName;
                // pDataRec.DictRec.VarName + 'Total' + IntToStr(oRegion.SectionNo);

                vcFormulaDefinition := 'TotalField(DBF[' + pDataRec.DictRec.VarName + '])';
                vcFieldFormat := 'R'
              End; // With DBTotalI

              // Add a line above the total
              BoxI := RegTemp.rgControls.Add(RegTemp.rgReport, VRWReportIF.ctBox) As IVRWBoxControl;
              With BoxI Do
              Begin
                vcTop := NextTop;
                vcLeft := ToNextGridNodeX(DBTotalI.vcLeft);
                vcWidth := DBTotalI.vcWidth;
                vcHeight := FRegionManager.rmMinControlHeight;

                vcFilled := False;
                With vcBoxLines[biTop] Do
                Begin
                  vcLineStyle := psSolid;
                  vcLineColor := clBlack;
                  vcLineWidth := 1;
                End; // With vcBoxLines[biTop]
                vcBoxLines[biLeft].vcLineStyle := psClear;
                vcBoxLines[biRight].vcLineStyle := psClear;
                vcBoxLines[biBottom].vcLineStyle := psClear;

                // Set region height
                regPageHdr.rgHeight := vcTop + vcHeight;
              End; // With BoxI
              BoxI := nil;

            end;
            oRegion := nil;
          End; // For I
        end;

        // Create the Text control to act as its title in the Page Header region
        If (pDataRec.SortIdx = 0) Then
        Begin
          If (Trim(pDataRec.Caption) <> '') Then
          Begin
            TextI := regPageHdr.rgControls.Add(regPageHdr.rgReport, VRWReportIF.ctText) As IVRWTextControl;
            Labels.Add(TextI);
            With TextI Do
            Begin
              // Dimensions all specified in mm
              vcTop := DBFieldI.vcTop;
              vcLeft := DBFieldI.vcLeft;
              vcWidth := DBFieldI.vcWidth;
              vcHeight := DBFieldI.vcHeight;

              // Set region height
              regPageHdr.rgHeight := vcTop + vcHeight;

              // Set Text properties
              vcCaption := Trim(pDataRec.Caption);
              vcFieldFormat := DBFieldI.vcFieldFormat;

              If (Pos('R', vcFieldFormat) > 0) And (DBFieldI.vcWidth > TextI.vcWidth) Then
              Begin
                // right-align
                vcLeft := DBFieldI.vcLeft + DBFieldI.vcWidth - TextI.vcWidth;
              End; // If (Pos('R', vcFieldFormat) > 0) And (DBFieldI.vcWidth > TextI.vcWidth)

              // Keep track of rightmost edge for the title underlining
              If ((vcLeft + vcWidth) > RightMost) Then RightMost := vcLeft + vcWidth;
            End; // With TextI

            // Work out where the next field should be placed
            If (DBFieldI.vcWidth >= TextI.vcWidth) Then
            Begin
              NextLeft := ToNextGridNodeX(NextLeft + DBFieldI.vcWidth + 1);
            End // If (DBFieldI.vcWidth >= TextI.vcWidth)
            Else
            Begin
              NextLeft := ToNextGridNodeX(NextLeft + TextI.vcWidth + 1);
            End; // Else
          End // If (Trim(pDataRec.Caption) <> '')
          Else
          Begin
            NextLeft := ToNextGridNodeX(NextLeft + DBFieldI.vcWidth + 1);
          End; // Else
        End; // If (pDataRec.SortIdx = 0)
      End; // For I

      If Assigned(TextI) Then
      Begin
        // Create a line below the titles
        BoxI := regPageHdr.rgControls.Add(regPageHdr.rgReport, VRWReportIF.ctBox) As IVRWBoxControl;
        With BoxI Do
        Begin
          Labels.Add(BoxI);
          vcTop := ToNextGridNodeY(TextI.vcTop + TextI.vcHeight); // snap to next vertical grid node
          vcLeft := ToNextGridNodeX(1);
          vcWidth := RightMost - vcLeft;
          vcHeight := FRegionManager.rmMinControlHeight;

          vcFilled := False;
          With vcBoxLines[biTop] Do
          Begin
            vcLineStyle := psSolid;
            vcLineColor := clBlack;
            vcLineWidth := 2;
          End; // With vcBoxLines[biTop]
          vcBoxLines[biLeft].vcLineStyle := psClear;
          vcBoxLines[biRight].vcLineStyle := psClear;
          vcBoxLines[biBottom].vcLineStyle := psClear;

          // Set region height
          regPageHdr.rgHeight := vcTop + vcHeight;
        End; // With BoxI
      End; // If Assigned(TextI)
    End; // If (NewReportDets.wrDBFields.Count > 0)

    // Create the controls in the Page Header section (do this after creating
    // all the other controls, because we need to know the paper orientation,
    // and the other controls might have changed it from the default of
    // portrait).
    NextLeft := ToNextGridNodeX(1);
    NextTop  := 0;
    // Company name
    Fml := regPageHdr.rgControls.Add(regPageHdr.rgReport, ctFormula) as IVRWFormulaControl;
    try
      Fml.vcFormulaDefinition := '"DBF[SYSUSER]';
      Fml.vcFormulaName := 'PrintCompanyName';
      Fml.vcFieldFormat := 'L';
      Fml.vcLeft := NextLeft;
      Fml.vcTop  := NextTop;
      // Calculate the control dimensions...
      AutoCalcControlSize (FRegionManager, Fml, StringOfChar('M', 20));
      Fml.vcFont.Style := [fsBold];
      // ...but override the width
      Fml.vcWidth := FRegionManager.rmPaperWidth div 2;
    finally
      Fml := nil;
    end;

    { SYSUSER }
    Dbf := regPageHdr.rgControls.Add(regPageHdr.rgReport, ctField, '') as IVRWFieldControl;
    try
      Dbf.vcFieldName := 'SYSUSER';
      Dbf.vcPrintField := False;
      Dbf.vcFieldFormat := 'L';
      Dbf.vcTop := NextTop;
      Dbf.vcLeft := (FRegionManager.rmPaperWidth div 2) + 4;
      // Calculate the control dimensions...
      AutoCalcControlSize (FRegionManager, Dbf, StringOfChar('M', 8));
      NextTop := ToNextGridNodeY(NextTop + Dbf.vcHeight);
    finally
      Dbf := nil;
    end;

    // Report description
    Fml := regPageHdr.rgControls.Add(regPageHdr.rgReport, ctFormula) as IVRWFormulaControl;
    try
      if FRegionManager.rmReport.vrDescription <> '' then
        Fml.vcFormulaDefinition := '"INFO[REPORTDESC]'
      else
        Fml.vcFormulaDefinition := '"INFO[REPORTNAME]';
      Fml.vcFormulaName := 'PrintReportName';
      Fml.vcFieldFormat := 'L';
      Fml.vcLeft := NextLeft;
      Fml.vcTop  := NextTop;
      // Calculate the control dimensions...
      AutoCalcControlSize (FRegionManager, Fml, StringOfChar('M', 20));
      // ...but override the width
      Fml.vcWidth := FRegionManager.rmPaperWidth div 2;
      Fml.vcFont.Style := [fsBold];
    finally
      Fml := nil;
    end;

    { SYSLUSER }
    Dbf := regPageHdr.rgControls.Add(regPageHdr.rgReport, ctField, '') as IVRWFieldControl;
    try
      Dbf.vcFieldName := 'SYSLUSER';
      Dbf.vcPrintField := False;
      Dbf.vcFieldFormat := 'L';
      Dbf.vcTop := NextTop;
      Dbf.vcLeft := (FRegionManager.rmPaperWidth div 2) + 4;
      // Calculate the control dimensions...
      AutoCalcControlSize (FRegionManager, Dbf, StringOfChar('M', 8));
    finally
      Dbf := nil;
    end;

    NextTop := 0;
    // Print date
    Fml := regPageHdr.rgControls.Add(regPageHdr.rgReport, ctFormula) as IVRWFormulaControl;
    try
      Fml.vcFormulaDefinition := '""Printed : " + INFO[DATE] + " - " + INFO[TIME]';
      Fml.vcFormulaName := 'PrintDate';
      Fml.vcFieldFormat := 'R';
      Fml.vcFont.Style := [];
      // Calculate the control dimensions
      AutoCalcControlSize (FRegionManager, Fml, 'Printed : 00/00/0000 - 00:00:00');
      Fml.vcLeft := (FRegionManager.rmPaperWidth - Fml.vcWidth) - 4;
      Fml.vcTop  := NextTop;
      NextTop := ToNextGridNodeY(NextTop + Fml.vcHeight);
    finally
      Fml := nil;
    end;

    // Page number
    Fml := regPageHdr.rgControls.Add(regPageHdr.rgReport, ctFormula) as IVRWFormulaControl;
    try
      Fml.vcFormulaDefinition :=
        '""User : " + DBF[SYSLUSER] + ". Page : " + INFO[CURRENTPAGE]';
      Fml.vcFormulaName := 'PageNumber';
      Fml.vcFieldFormat := 'R';
      Fml.vcFont.Style := [];
      // Calculate the control dimensions
      AutoCalcControlSize (FRegionManager, Fml, 'User : DEMODEMO Page : 0000');
      NextLeft := ToNextGridNodeX((FRegionManager.rmPaperWidth - Fml.vcWidth) - 4);
      Fml.vcLeft := NextLeft;
      Fml.vcTop  := NextTop;
      NextTop := ToNextGridNodeY(NextTop + Fml.vcHeight);
    finally
      Fml := nil;
    end;

    { Move all the column labels down below the company & user name labels }
    regPageHdr.rgHeight := regPageHdr.rgHeight + NextTop;
    for i := 0 to Labels.Count - 1 do
    begin
      Control := Labels[i] as IVRWControl;
      Control.vcTop := Control.vcTop + NextTop + 2;
      if (Control.vcTop + Control.vcHeight) > regPageHdr.rgHeight then
        Control.vcHeight := regPageHdr.rgHeight - Control.vcTop;
      Control := nil;
    end;

    // Deallocate memory for dynamic array
    regSecHdrArray := NIL;
    regSecFtrArray := NIL;
  End; // With FRegionManager.rmReport

  Labels.Free;

  FRegionManager.SetupDesigner(True);
End; // CreateNewReport

//-------------------------------------------------------------------------

procedure TfrmReportDesigner.AssignReport(Report: IVRWReport);
begin
  FRegionManager.rmReport := nil;
  FRegionManager.rmReport := Report;
  FRegionManager.SetupDesigner(True);
  // Force the user to save the newly-imported report.
  FRegionManager.ChangeMade;
end;

//-------------------------------------------------------------------------

procedure TfrmReportDesigner.scRegionWindowMouseMove(Sender: TObject; Shift: TShiftState; X, Y: Integer);
begin
  OnUpdateCursorPosition(0, 0);
  OnUpdateControlInfo('', '', '', '', '');
end;

//-------------------------------------------------------------------------

procedure TfrmReportDesigner.OnFirstPass(Count, Total: integer;
  var Abort: Boolean);
begin
  pnlProgress.Caption := ' Gathering data';
  Abort := FCancelPrint;
end;

procedure TfrmReportDesigner.OnPrintRecord(Count, Total: integer;
  var Abort: Boolean);
var
  Position: Integer;
  Units: Double;
begin
  if (Total > 0) then
  begin
    Units := 100.00 / Total;
    Position := Trunc(Units * Count);
  end
  else
    Position := 0;
  pbReportProgress.Position := Position;
  if FCancelPrint then
    Abort := True;
  Application.ProcessMessages;
end;

procedure TfrmReportDesigner.OnSecondPass(Count, Total: integer;
  var Abort: Boolean);
begin
  pnlProgress.Caption := ' Printing report';
  Abort := FCancelPrint;
end;

procedure TfrmReportDesigner.btnCancelPrintClick(Sender: TObject);
begin
  if (MessageDlg('Cancel this print?', mtWarning, [mbYes, mbNo], 0) = mrYes) then
    FCancelPrint := True;
end;

procedure TfrmReportDesigner.AfterPrinting;
begin
  { Hide the progress bar, and restore the control hint panel }
  pnlProgress.Caption := '';
  pnlProgress.Visible := False;
  pbReportProgress.Visible := False;
  pnlHint.BevelOuter := bvLowered;

  { Disable the 'cancel print' option, and re-enable report editing }
  btnCancelPrint.Enabled     := False;
  miCancelPrint.Visible      := False;

  tbRunReport.Picture.Assign(tbRunReport_SourceImages.Picture);
  tbRunReport.HotPicture.Assign(tbRunReport_SourceImages.HotPicture);
  tbRunReport.DisabledPicture.Assign(tbRunReport_SourceImages.DisabledPicture);

  tbRunReport.Hint := 'Run the report';

  scRegionWindow.Enabled     := True;
  miSaveReport.Enabled       := True;
  miPrint.Enabled            := True;
  miAddText.Enabled          := True;
  miAddFormula.Enabled       := True;
  miAddDBField.Enabled       := True;
  miAddBox.Enabled           := True;
  miAddImage.Enabled         := True;
  miRangeFilters.Enabled     := True;
  miAddReportSection.Enabled := True;
  miReportProperties.Enabled := True;
  miControlsTree.Enabled     := True;
  miCloseReport.Enabled      := True;
  miDefaultFont.Enabled      := True;

  tbSaveReport.Enabled       := True;
  tbReportText.Enabled       := True;
  tbReportFormula.Enabled    := True;
  tbReportDBField.Enabled    := True;
  tbReportBox.Enabled        := True;
  tbReportImage.Enabled      := True;
  tbReportTree.Enabled       := True;

end;

procedure TfrmReportDesigner.BeforePrinting;
begin
  { Show the progress bar instead of the control hint panel }
  pnlHint.BevelOuter := bvNone;
  pbReportProgress.Visible := True;
  pnlProgress.Visible := True;

  { Set up the 'cancel print' button }
  btnCancelPrint.Enabled := True;
  FCancelPrint           := False;
  miCancelPrint.Visible  := True;

  tbRunReport.Picture.Assign(tbCancelReport_SourceImages.Picture);
  tbRunReport.HotPicture.Assign(tbCancelReport_SourceImages.HotPicture);
  tbRunReport.DisabledPicture.Assign(tbCancelReport_SourceImages.DisabledPicture);

  tbRunReport.Hint := 'Cancel print';

  { Prevent any editing of the report }
  scRegionWindow.Enabled     := False;
  miSaveReport.Enabled       := False;
  miPrint.Enabled            := False;
  miAddText.Enabled          := False;
  miAddFormula.Enabled       := False;
  miAddDBField.Enabled       := False;
  miAddBox.Enabled           := False;
  miAddImage.Enabled         := False;
  miRangeFilters.Enabled     := False;
  miAddReportSection.Enabled := False;
  miReportProperties.Enabled := False;
  miControlsTree.Enabled     := False;
  miCloseReport.Enabled      := False;
  miDefaultFont.Enabled      := False;

  tbSaveReport.Enabled       := False;
  tbReportText.Enabled       := False;
  tbReportFormula.Enabled    := False;
  tbReportDBField.Enabled    := False;
  tbReportBox.Enabled        := False;
  tbReportImage.Enabled      := False;
  tbReportTree.Enabled       := False;

  { Install the print progress call-backs }
  FRegionManager.OnPrintRecord := OnPrintRecord;
  FRegionManager.OnFirstPass   := OnFirstPass;
  FRegionManager.OnSecondPass  := OnSecondPass;
end;


procedure TfrmReportDesigner.tbSaveReportClick(Sender: TObject);
Var
  Params         : TReportWizardParams;
  FunctionResult : Integer;
begin
  Screen.Cursor := crHourGlass;
  try
    FRegionManager.SaveReport;
    Screen.Cursor := crDefault;
    If Assigned(FOnSaveReport) Then
    Begin
        Params := TReportWizardParams.Create;
        Params.wrReportName := FRegionManager.rmReport.vrName;
        Params.wrReportDesc := FRegionManager.rmReport.vrDescription;
        Params.wrWasPrinted := FWasPrinted;

        FOnSaveReport(Params, FTreeParent, ExtractFileName(FRegionManager.rmReport.vrFilename), FunctionResult);
        If (FunctionResult <> 0) Then
        Begin
          MessageDlg ('An error ' + IntToStr(FunctionResult) + ' occurred whilst saving the report',
                      mtError, [mbOK], 0);
        End; // If (FunctionResult <> 0)
    End; // If Assigned(FOnSaveReport)
  finally
    Screen.Cursor := crDefault;
  end;
end;

procedure TfrmReportDesigner.tbReportTextClick(Sender: TObject);
begin
  ToggleButton(tbReportText);
  if FButtonClicked <> nil then
    FRegionManager.AddControl(dctText);
end;

procedure TfrmReportDesigner.tbReportImageClick(Sender: TObject);
begin
  ToggleButton(tbReportImage);
  if FButtonClicked <> nil then
    FRegionManager.AddControl(dctImage);
end;

procedure TfrmReportDesigner.tbReportBoxClick(Sender: TObject);
begin
  ToggleButton(tbReportBox);
  if FButtonClicked <> nil then
    FRegionManager.AddControl(dctBox);
end;

procedure TfrmReportDesigner.tbReportDBFieldClick(Sender: TObject);
begin
  ToggleButton(tbReportDBField);
  if FButtonClicked <> nil then
    FRegionManager.AddControl(dctDBField);
end;

procedure TfrmReportDesigner.tbReportFormulaClick(Sender: TObject);
begin
  ToggleButton(tbReportFormula);
  if FButtonClicked <> nil then
    FRegionManager.AddControl(dctFormula);
end;

procedure TfrmReportDesigner.tbRunReportClick(Sender: TObject);
begin
  miPrintClick(Sender);
end;

procedure TfrmReportDesigner.tbReportTreeClick(Sender: TObject);
begin
  Close;
end;

procedure TfrmReportDesigner.OnControlAdded(Added: Boolean);
begin
  ToggleButton(FButtonClicked);
end;

//procedure TfrmReportDesigner.ToggleButton(Button: TToolbutton);
procedure TfrmReportDesigner.ToggleButton(Button: TAdvGlowButton);
begin
  if (Button = nil) then
  begin
    if (FButtonClicked <> nil) then
      ToggleButton(FButtonClicked);
    FButtonClicked := nil;
  end
  else if FButtonClicked = Button then
  begin
    Button.ImageIndex := Button.ImageIndex - 8;
    FButtonClicked := nil;
    FRegionManager.AddControl(dctNone);
  end
  else
  begin
    if (FButtonClicked <> nil) then
      ToggleButton(FButtonClicked);
    Button.ImageIndex := Button.ImageIndex + 8;
    FButtonClicked := Button;
  end;
end;

end.

