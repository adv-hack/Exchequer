unit ProgressTreeF;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, VirtualTrees, ImgList, ThemeMgr, ComCtrls, Menus,
  BaseF, EnterToTab, oConvertOptions, oReadThread, psAPI;

type
  TfrmConversionProgress = class(TfrmCommonBase)
    btnAbort: TButton;
    vtvConversionTasks: TVirtualStringTree;
    ImageList1: TImageList;
    Timer1: TTimer;
    ThemeManager1: TThemeManager;
    Label2: TLabel;
    Label13: TLabel;
    Label14: TLabel;
    lblWarningInfo: TLabel;
    procedure FormCreate(Sender: TObject);
    procedure vtvConversionTasksGetText(Sender: TBaseVirtualTree;
      Node: PVirtualNode; Column: TColumnIndex; TextType: TVSTTextType;
      var CellText: WideString);
    procedure vtvConversionTasksGetImageIndex(Sender: TBaseVirtualTree;
      Node: PVirtualNode; Kind: TVTImageKind; Column: TColumnIndex;
      var Ghosted: Boolean; var ImageIndex: Integer);
    procedure btnAbortClick(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure FormResize(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure vtvConversionTasksFreeNode(Sender: TBaseVirtualTree;
      Node: PVirtualNode);
  private
    { Private declarations }
    FPopulating : Boolean;
    FNeedUpdate : Boolean;
    LastCompletedNode : PVirtualNode;
    FLowMemoryFlag : Boolean;

    // Thread Objects
    FBtrieveReadThread : TBtrieveReadThread;

    // Minimum form sizes to be set in the WM_GetMinMaxInfo message handler
    MinSizeX : LongInt;
    MinSizeY : LongInt;

    procedure LoadCompanies;
    // Runs through the tree updating the company node objects from the DB to update the display details
    Procedure UpdateTree;

    // Sent by the Read Thread on completion of the data copy phase of the conversion
    Procedure WMDataConversionFinished(Var Message  :  TMessage); Message WM_DataConversionFinished;
    // Sent by the Write Thread Pool when a low memory situation is detected
    Procedure WMLowMemoryWarning(Var Message  :  TMessage); Message WM_LowMemoryWarning;

    // Control the minimum size that the form can resize to - works better than constraints
    Procedure WMGetMinMaxInfo (Var Message : TWMGetMinMaxInfo); Message WM_GetMinMaxInfo;

    // MH 13/02/2013 v7.0.2 ABSEXCH-13360: Rebuild indexes to improve read/write performance on the converted system
    Function EnableAndRebuildIndexes (Var RebuildTime : TDateTime) : Boolean;

    // CJS 2014-04-02 - ABSEXCH-15244 - Disable Foreign Key constraints to prevent import errors
    // CJS 2014-07-16 - ABSEXCH-15525 - Copied forward from v7.0.9
    Function EnableForeignKeys: Boolean;

  public
    { Public declarations }
  end;

implementation

{$R *.dfm}

Uses ADODB, DateUtils, GlobVar, BtrvU2, Math, StrUtil, StrUtils, DataConversionWarnings, ProgressF, LoggingUtils;

Type
  TNodeType = (ntCompany, ntTask);

  // Base class for node information
  TTreeNodeInfo = Class(TObject)
  Private
    FNodeType : TNodeType;
    Function GetStatusText : ShortString; Virtual; Abstract;
  Public
    Property NodeType : TNodeType Read FNodeType;
    Property StatusText : ShortString Read GetStatusText;
  End; // TTreeNodeInfo
  pTreeNodeInfo = ^TTreeNodeInfo;

  //------------------------------

  TCompanyHeader = Class(TTreeNodeInfo)
  Private
    FCompanyDets : TConversionCompany;
    FAutoContracted : Boolean;
    Function GetCode : ShortString;
    Function GetStatusText : ShortString; Override;
  Public
    Property Code : ShortString Read GetCode;
    Property CompanyDetails : TConversionCompany Read FCompanyDets;
    Property AutoContracted : Boolean Read FAutoContracted Write FAutoContracted;

    Constructor Create (Const CompanyDets : TConversionCompany);
    Destructor Destroy; Override;
  End; // TCompanyHeader

  //------------------------------

  TTaskDetail = Class(TTreeNodeInfo)
  Private
    FCompanyDets : TConversionCompany;
    FTaskDets : IDataConversionTask;
    Function GetStatusText : ShortString; Override;
  Public
    Property CompanyDetails : TConversionCompany Read FCompanyDets;
    Property TaskDetails : IDataConversionTask Read FTaskDets;

    Constructor Create (Const CompanyDets : TConversionCompany; Const TaskDets : IDataConversionTask);
    Destructor Destroy; Override;
  End; // TTaskDetail

//=========================================================================

Constructor TCompanyHeader.Create (Const CompanyDets : TConversionCompany);
Begin // Create
  Inherited Create;

  FNodeType := ntCompany;
  FCompanyDets := CompanyDets;
  FAutoContracted := False;
End; // Create

//------------------------------

Destructor TCompanyHeader.Destroy;
Begin // Destroy
  FCompanyDets := NIL;
  Inherited Destroy;
End; // Destroy

//-------------------------------------------------------------------------

Function TCompanyHeader.GetCode : ShortString;
Begin // GetCode
  Result := Trim(FCompanyDets.ccCompanyCode);
End; // GetCode

//-------------------------------------------------------------------------

Function TCompanyHeader.GetStatusText : ShortString;
Begin // GetStatusText
  Case FCompanyDets.ccConversionStatus Of
    ccsNotStarted : Result := 'Not Started';
    ccsInProgress : Result := 'In Progress';
    ccsComplete   : Result := 'Complete ' + FormatDateTime('hh:nn:ss.zzz', FCompanyDets.ccConversionFinishTime - FCompanyDets.ccConversionStartTime);
  End; // Case FCompanyDets.ccdStatus
End; // GetStatusText

//=========================================================================

Constructor TTaskDetail.Create (Const CompanyDets : TConversionCompany; Const TaskDets : IDataConversionTask);
Begin // Create
  Inherited Create;

  FNodeType := ntTask;
  FCompanyDets := CompanyDets;
  FTaskDets := TaskDets;
End; // Create

//------------------------------

Destructor TTaskDetail.Destroy;
Begin // Destroy
  FTaskDets := NIL;
  FCompanyDets := NIL;
  Inherited Destroy;
End; // Destroy

//-------------------------------------------------------------------------

Function TTaskDetail.GetStatusText : ShortString;
Var
  PercRead, PercWritten, TotalRecs : Double;
Begin // GetStatusText
  Case FTaskDets.dctStatus Of
    ctsNotStarted : Result := 'Not Started';

    ctsInProgress : Begin
                      If (FTaskDets.dctTotalRecords > 0) Then
                      Begin
                        PercRead := RoundTo((FTaskDets.dctTotalRead / FTaskDets.dctTotalRecords) * 100, -2);
                        PercWritten := RoundTo((FTaskDets.dctTotalWritten / FTaskDets.dctTotalRecords) * 100, -2);
                      End // If (FTaskDets.dctTotalRecords > 0);
                      Else
                      Begin
                        PercRead := 100;
                        PercWritten := 100;
                      End; // Else

                      TotalRecs := FTaskDets.dctTotalRecords;
                      Result := Format('In Progress - Total Records %0.0n - %0.2f%s Read / %0.2f%s Written',
                                       [TotalRecs, PercRead, '%', PercWritten, '%']);
                    End; // ctsInProgress

    ctsComplete   : Result := 'Complete';
  End; // Case FTaskDets.dctStatus
End; // GetStatusText

//=========================================================================

procedure TfrmConversionProgress.FormCreate(Sender: TObject);
Begin // FormCreate
  inherited;

  Caption := Application.Title;

  ClientHeight := 346;
  ClientWidth := 724;

  MinSizeY := (Height - ClientHeight) + 306;      // take captions/border into account
  MinSizeX := (Width - ClientWidth) + 720;

  FPopulating := False;
  FNeedUpdate := False;
  FBtrieveReadThread := NIL;
  FLowMemoryFlag := False;

  vtvConversionTasks.NodeDataSize := SizeOf(Pointer);
  LastCompletedNode := NIL;

  // Set the window handle so a completion message can be posted back
  ConversionOptions.hProgressTree := Self.Handle;

  LoadCompanies;
End; // FormCreate

//------------------------------

procedure TfrmConversionProgress.FormDestroy(Sender: TObject);
begin
  If Assigned(FBtrieveReadThread) Then
    FreeAndNIL(FBtrieveReadThread);

  inherited;
end;

//-------------------------------------------------------------------------

procedure TfrmConversionProgress.FormActivate(Sender: TObject);
begin
  If (Not Assigned(FBtrieveReadThread)) Then
  Begin
    // Create the Btrieve Read Thread
    FBtrieveReadThread := TBtrieveReadThread.Create;

    // Start the Btrieve Read Thread - this will create and activate the SQL Write Threads on demand
    FBtrieveReadThread.Resume;

    // Start the timer which triggers the events for updating the progress info
    Timer1.Enabled := True;
  End; // If (Not Assigned(FBtrieveReadThread))
end;

//------------------------------

procedure TfrmConversionProgress.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
begin
  inherited;

  // If the thread is still running and the user manually closed the window then
  // tell them where to stick it
  If Assigned(FBtrieveReadThread) And (modalResult = mrCancel) Then
  Begin
    MessageDlg ('The Data Conversion Program cannot be closed whilst the data conversion threads are running', mtError, [mbOk], 0);
    CanClose := False;
  End; // If Assigned(FBtrieveReadThread) And (modalResult = mrCancel) 
end;

//------------------------------

procedure TfrmConversionProgress.FormResize(Sender: TObject);
Const
  BaseGap = 8;
begin
  inherited;

  lblWarningInfo.Top := ClientHeight - lblWarningInfo.Height;

  vtvConversionTasks.Left := BaseGap;
  vtvConversionTasks.Width := Self.ClientWidth - (2 * vtvConversionTasks.Left);
  vtvConversionTasks.Height := lblWarningInfo.Top - vtvConversionTasks.Top - 3;
end;

//-------------------------------------------------------------------------

Procedure TfrmConversionProgress.WMGetMinMaxInfo(Var Message  :  TWMGetMinMaxInfo);
Begin // WMGetMinMaxInfo
  If (MinSizeX <> 0) Then
    with message.MinMaxInfo^ do
    begin
      ptMinTrackSize.X := MinSizeX;  // Use maxsize to disable horizontal resizing
      ptMinTrackSize.Y := MinSizeY;
    end; // with message.MinMaxInfo^

  message.Result:=0;

  Inherited;
End; // WMGetMinMaxInfo

//-------------------------------------------------------------------------

procedure TfrmConversionProgress.LoadCompanies;
Var
  RootNode, ChildNode: PVirtualNode;
  NodeData : pTreeNodeInfo;
  oCompany : TConversionCompany;
  oTask : IDataConversionTask;
  iCompany, iTask : Integer;
Begin // LoadCompanies
  FPopulating := True;
  Try
    vtvConversionTasks.BeginUpdate;
    try
      vtvConversionTasks.Clear;

      // Run through the list of companies adding them into the Progress Tree
      For iCompany := 0 To (ConversionOptions.coCompanyCount - 1) Do
      Begin
        oCompany := ConversionOptions.coCompanies[iCompany];
        Try
          // Add Company Header into tree
          RootNode := vtvConversionTasks.AddChild(nil);
          NodeData := vtvConversionTasks.GetNodeData(RootNode);
          NodeData^ := TCompanyHeader.Create(oCompany);

          // Run through Company's Conversion Tasks adding them into the tree as children
          For iTask := 0 To (oCompany.ccConversionTaskCount - 1) Do
          Begin
            oTask := oCompany.ccConversionTasks[iTask];
            Try
              ChildNode := vtvConversionTasks.AddChild(RootNode);
              NodeData := vtvConversionTasks.GetNodeData(ChildNode);
              NodeData^ := TTaskDetail.Create (oCompany, oTask);
            Finally
              oTask := NIL;
            End; // Try..Finally
          End; // For iTask

          // Automatically open the company nodes
          vtvConversionTasks.FullExpand(RootNode);
        Finally
          oCompany := NIL;
        End; // Try..Finally
      End; // For I
    Finally
      FPopulating := False;
    End; // Try..Finally
  finally
    vtvConversionTasks.EndUpdate;
  end;
End; // LoadCompanies

//-------------------------------------------------------------------------

procedure TfrmConversionProgress.vtvConversionTasksFreeNode(Sender: TBaseVirtualTree; Node: PVirtualNode);
Var
  NodeData : pTreeNodeInfo;
begin
  // Free the TCompanyHeader/TTaskDetail object contained in the NodeData
  NodeData := Sender.GetNodeData(Node);
  NodeData^.Free;
end;

//-------------------------------------------------------------------------

procedure TfrmConversionProgress.vtvConversionTasksGetText(Sender: TBaseVirtualTree; Node: PVirtualNode; Column: TColumnIndex;
                                                           TextType: TVSTTextType; var CellText: WideString);
Var
  NodeData : pTreeNodeInfo;
  oCompany : TCompanyHeader;
  oTask : TTaskDetail;
begin
  NodeData := Sender.GetNodeData(Node);
  If (NodeData^.NodeType = ntCompany) Then
  Begin
    oCompany := TCompanyHeader(NodeData^);
    Case Column Of
      // Company Code & Name
      0 : CellText := Trim(oCompany.CompanyDetails.ccCompanyCode) + ' - ' + oCompany.CompanyDetails.ccCompanyName;
      // Progress summary
      1 : CellText := oCompany.StatusText;
    End; // Case

    // Automatically contract companies on completion to reduce cruft on screen
    If (oCompany.CompanyDetails.ccConversionStatus = ccsComplete) And (Not oCompany.AutoContracted) Then
    Begin
      oCompany.AutoContracted := True;
      Sender.Expanded[Node] := False;
    End; // If (oCompany.CompanyDetails.ccConversionStatus = ccsComplete) And (Not oCompany.AutoContracted)
  End // If (NodeData^.NodeType = ntCompany)
  Else If (NodeData^.NodeType = ntTask) Then
  Begin
    oTask := TTaskDetail(NodeData^);
    Case Column Of
      // Conversion Task Description
      0 : CellText := oTask.TaskDetails.dctTaskDescription;
      // Progress summary
      1 : CellText := oTask.StatusText;
    End; // Case
  End // If (NodeData^.NodeType = ntTask)
  Else
    CellText := '???';
end;

//-------------------------------------------------------------------------

procedure TfrmConversionProgress.vtvConversionTasksGetImageIndex(Sender: TBaseVirtualTree; Node: PVirtualNode; Kind: TVTImageKind;
                      Column: TColumnIndex; var Ghosted: Boolean; var ImageIndex: Integer);
Var
  NodeData : pTreeNodeInfo;
begin
  If (Column = 0) Then
  Begin
    NodeData := Sender.GetNodeData(Node);
    If (NodeData^.NodeType = ntCompany) Then
      ImageIndex := 0
    Else If (NodeData^.NodeType = ntTask) Then
      ImageIndex := 1;
  End; // If (Column = 0)
end;

//-------------------------------------------------------------------------

procedure TfrmConversionProgress.btnAbortClick(Sender: TObject);
begin
  If (MessageDlg ('Are you sure you want to Abort the conversion process?', mtconfirmation, [mbYes, mbNo], 0) = mrYes) Then
  Begin
    ConversionOptions.Abort('Aborted by user');
  End; // If (MessageDlg ('Are you sure you want to Abort the conversion process?', mtconfirmation, [mbYes, mbNo], 0) = mrYes)
end;

//-------------------------------------------------------------------------

// Runs through the tree updating the company node objects from the DB to update the display details
Procedure TfrmConversionProgress.UpdateTree;
Begin // UpdateTree
  FNeedUpdate := False;

  FPopulating := True;
  Try
    vtvConversionTasks.BeginUpdate;
    Try
      // Causes the tree to refresh
    finally
      vtvConversionTasks.EndUpdate;
    end;
  Finally
    FPopulating := False;
  End; // Try..Finally
End; // UpdateTree

//-------------------------------------------------------------------------

// MH 13/02/2013 v7.0.2 ABSEXCH-13360: Rebuild indexes to improve read/write performance on the converted system
Function TfrmConversionProgress.EnableAndRebuildIndexes (Var RebuildTime : TDateTime) : Boolean;
Var
  ADOConnection : TADOConnection;
  ADOStoredProc : TADOStoredProc;
  StartTime : TDateTime;
Begin // EnableAndRebuildIndexes
  Result := True;

  Try
    ProgressDialog.StartStage ('Rebuilding Indexes');
    Try
      // Create SQL Query object to use for executing the stored procedure which disables the indexes
      ADOConnection := TADOConnection.Create(nil);
      ADOStoredProc := TADOStoredProc.Create(Nil);
      Try
        ADOConnection.ConnectionString := ConversionOptions.coCommonConnectionString;
        // MH 22/03/2013 ABSEXCH-14167 v7.0.2: Extended timeout to 4 hours from 2 hours
        ADOConnection.CommandTimeout := (60 * 60 * 4);  // 4 hours - data can take a long time to rebuild

        ADOStoredProc.Connection := ADOConnection;
        // MH 1009/2013 ABSEXCH-14557 v7.0.6: Command timing out as ADOStoredProc doesn't seem to pickup the connection timeout from the Connection
        ADOStoredProc.CommandTimeout := ADOConnection.CommandTimeout;
        ADOStoredProc.ProcedureName := 'common.isp_RI_NonClustered';
        ADOStoredProc.Parameters.Refresh;
        ADOStoredProc.Parameters.ParamByName('@Rebuild').Value := 1;
        ADOStoredProc.Prepared := True;

        StartTime := Now;
        ADOStoredProc.ExecProc;
        RebuildTime := Now - StartTime;
      Finally
        ADOStoredProc.Free;
        ADOConnection.Free;
      End; // Try..Finally
    Finally
      ProgressDialog.FinishStage;
    End; // Try..Finally
  Except
    On E:Exception Do
    Begin
      // MH 22/03/2013 ABSEXCH-14167 v7.0.2: Modified to a warning rather than an error because of
      //                                     timeouts where it is valid to continue
      //Result := False;
      Logging.Exception ('TfrmPasswordEntry.DisableIndexes', 'Disabling Indexes', E.Message);
      MessageDlg ('The following error occured whilst disabling the indexes:-'#13#13 +
                  E.Message + #13#13'Please notify your technical support', mtError, [mbOK], 0);
    End; // On E:Exception
  End; // Try..Except
End; // EnableAndRebuildIndexes

//-------------------------------------------------------------------------

// CJS 2014-04-02 - ABSEXCH-15244 - Disable Foreign Key constraints to prevent import errors
// CJS 2014-07-16 - ABSEXCH-15525 - Copied forward from v7.0.9 
Function TfrmConversionProgress.EnableForeignKeys: Boolean;
Var
  ADOConnection : TADOConnection;
  ADOStoredProc : TADOStoredProc;
  StartTime : TDateTime;
Begin // EnableForeignKeys
  Result := True;

  Try
    ProgressDialog.StartStage ('Re-enabling Foreign Keys');
    Try
      // Create SQL Query object to use for executing the stored procedure
      ADOConnection := TADOConnection.Create(nil);
      ADOStoredProc := TADOStoredProc.Create(Nil);
      Try
        ADOConnection.ConnectionString := ConversionOptions.coCommonConnectionString;
        ADOConnection.CommandTimeout := 300;  // 5 minutes - should only take seconds

        ADOStoredProc.Connection := ADOConnection;
        ADOStoredProc.CommandTimeout := ADOConnection.CommandTimeout;
        ADOStoredProc.ProcedureName := 'common.isp_Enable_Foreign_Keys';
        ADOStoredProc.Parameters.Refresh;
        ADOStoredProc.Parameters.ParamByName('@enable').Value := 1; // 1 = enable
        ADOStoredProc.Prepared := True;

        ADOStoredProc.ExecProc;
      Finally
        ADOStoredProc.Free;
        ADOConnection.Free;
      End; // Try..Finally
    Finally
      ProgressDialog.FinishStage;
    End; // Try..Finally
  Except
    On E:Exception Do
    Begin
      Logging.Exception ('TfrmConversionProgress.EnableForeignKeys', 'Re-enabling Foreign Keys', E.Message);
      MessageDlg ('The following error occured whilst re-enabling the foreign keys:-'#13#13 +
                  E.Message + #13#13'Please notify your technical support', mtError, [mbOK], 0);
    End; // On E:Exception
  End; // Try..Except
End;

// -----------------------------------------------------------------------------

Procedure TfrmConversionProgress.WMDataConversionFinished(Var Message : TMessage);
Var
  RebuildTime : TDateTime;
Begin // WMDataConversionFinished
  // Check for an error condition
  If ConversionOptions.GlobalAbort Then
  Begin
    // Use mrAbort to close the dialog as if you close the window manually using Alt-F4 or the Close button
    // if will return an mrCancel so this allows use to trap manual closes in the FormCloseQuery
    //ModalResult := mrCancel;
    ModalResult := mrAbort;
  End // If ConversionOptions.GlobalAbort
  Else
  Begin
    // MH 13/02/2013 v7.0.2 ABSEXCH-13360: Rebuild indexes to improve read/write performance on the converted system
    If EnableAndRebuildIndexes(RebuildTime) Then
    Begin
      // CJS 2014-07-16 - ABSEXCH-15525 - Copied forward from v7.0.9 and switched order with EnableAndRebuildIndexes
      If EnableForeignKeys then
      begin
        If FindCmdLineSwitch('Yahoo', ['/', '\', '-'], True) Then
            ShowMessage ('Yahoo - Data Copying Finished - ' + IntToStr(Trunc(ConversionOptions.ElapsedDataConversionTime + RebuildTime)) + ' days, ' +
                         FormatDateTime ('h', ConversionOptions.ElapsedDataConversionTime + RebuildTime) + ' hours, ' +
                         FormatDateTime ('n', ConversionOptions.ElapsedDataConversionTime + RebuildTime) + ' minutes, ' +
                         FormatDateTime ('s.zzz', ConversionOptions.ElapsedDataConversionTime + RebuildTime) + ' seconds');

        ModalResult := mrOK;
      End // If EnableForeignKeys
      Else
        ModalResult := mrAbort;
    End // If EnableAndRebuildIndexes
    Else
      ModalResult := mrAbort;
  End; // Else
End; // WMDataConversionFinished

//-------------------------------------------------------------------------

// Sent by the Write Thread Pool when a low memory situation is detected
Procedure TfrmConversionProgress.WMLowMemoryWarning(Var Message  :  TMessage);
Begin // WMLowMemoryWarning
  FLowMemoryFlag := True;
End; // WMLowMemoryWarning

//-------------------------------------------------------------------------

procedure TfrmConversionProgress.Timer1Timer(Sender: TObject);
begin
  Timer1.Enabled := False;
  Try
    // Check the global error flag
    If ConversionOptions.GlobalAbort Then
      MessageDlg (ConversionOptions.GlobalAbortReason, mtError, [mbOK], 0)
    Else
    Begin
      // Update UI
      UpdateTree;

      If (ConversionWarnings.Count > 0) Then
        lblWarningInfo.Caption := IntToStr(ConversionWarnings.TotalWarningsLogged) + ' warnings logged for manual review'
      Else
        lblWarningInfo.Caption := 'No warnings logged';

      If FLowMemoryFlag Then
      Begin
        // Display warning message and reset the flag once the user has OK'd it - this is
        // displayed in the UI thread so it won't prevent the Read/Write threads executing
        MessageDlg ('This workstation is low on memory which could cause problems for the SQL Data ' +
                    'Migration and will reduce its performance.  Please close any applications you ' +
                    'can to maximise the available memory whilst the SQL Data Migration is running.', mtWarning, [mbOK], 0);
        FLowMemoryFlag := False;
      End; // If FLowMemoryFlag
    End; // Else
  Finally
    Timer1.Enabled := Not ConversionOptions.GlobalAbort;
  End; // Try..Finally
end;

//=========================================================================

end.
