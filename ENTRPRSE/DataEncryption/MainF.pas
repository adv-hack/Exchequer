unit MainF;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ComCtrls, VirtualTrees, StdCtrls, oBtrieveFile, oDocument, TCustom, GmXML,
  EncryptionThread, ProgressF, EnterToTab, ExtCtrls;

type
  //Indicates what the node represents
  TCompNodeType = (ntRoot, ntCompany, ntFile);

  //Data record to be stored for each node
  PVTNodeData = ^TVTNodeData;
  TVTNodeData = Record
    CompNodeType : TCompNodeType;
    Filename : string;
    CompanyPath : string;
    Description : string;
    GDPR : Boolean;
    IsEncrypted : Boolean;
    GlobalFile : Boolean; //True if this is a global rather than company file

    //Following integer values declared as doubles for use in calculation
    EstimatedSeconds : Double; //EstTimeInSecs
    EstimatedRecords : Double;
    ActualRecords    : Double;

    //Calculated estimate in seconds
    Estimate : Double;

    //Index in FileList
    Idx : Integer;
  end;

  TfrmMain = class(TForm)
    CompanyTree: TVirtualStringTree;
    chkGDPROnly: TCheckBox;
    btnClose: TSBSButton;
    btnEncrypt: TSBSButton;
    EnterToTab1: TEnterToTab;
    pnlMessages: TPanel;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label5: TLabel;
    lblEstimate: TLabel;
    Label4: TLabel;
    Label6: TLabel;
    Label8: TLabel;
    procedure FormCreate(Sender: TObject);
    procedure CompanyTreeGetText(Sender: TBaseVirtualTree;
      Node: PVirtualNode; Column: TColumnIndex; TextType: TVSTTextType;
      var CellText: WideString);
    procedure CompanyTreeInitNode(Sender: TBaseVirtualTree; ParentNode,
      Node: PVirtualNode; var InitialStates: TVirtualNodeInitStates);
    procedure chkGDPROnlyClick(Sender: TObject);
    procedure btnEncryptClick(Sender: TObject);
    procedure btnCloseClick(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure FormResize(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure CompanyTreeFocusChanged(Sender: TBaseVirtualTree;
      Node: PVirtualNode; Column: TColumnIndex);
  private
    { Private declarations }
    RootNode : PVirtualNode;
    FileList : TList; //List of PVirtualNodes to hold file info from scan of system

    FileStatusChecker : TBaseBtrieveFile;
    FEncryptionThread : TEncryptionThread;
    FProgressForm : TfrmEncryptProgress;
    FCurrentFilename : string;
    FXML : TGmXML;
    InstallationName : string;

    //File object for accessing ExchqSS.dat
    oSSFile : TBaseBtrieveFile;

    //Logging variables
    WindowsID : string;
    WorkstationID : string;
    LogPath : string;
    StartTime : TDateTime;
    EndTime : TDateTime;

    //Seconds to read 1000 transaction header records
    OurInitialReadSeconds    : Double; //from xml file
    TheirInitialReadSeconds  : Double;

    //Estimate variables
    LocalPerformanceModifier : Double;
    ReadRatio : Double;

    //Store estimated time and actual time for the file being encrypted
    CurrentEstimatedSeconds : Double;
    CurrentActualSeconds : Double;

    //Counts of GDPR and Unencrypted files
    UnencryptedFileCount : Integer;
    GDPRFileCount : Integer;

    //Reads 1000 headers from Document.Dat and returns elapsed time in seconds
    function InitialRead(const CompanyPath : string) : Double;

    procedure WriteLog(const Filename : string; const Status : String;
      EstimateOrTime : Double);

    procedure LoadData;
    procedure LoadTree;

    //Returns user-friendly time string as HLD 2.2.1.4
    function EstimateText(EstTime : Double) : string;
    function GetStatusDescription(const NodeData : PVTNodeData): string;

    //Gets encrypted status and record count for a file
    procedure GetFileDetails(const Filename : string; var IsEncrypted : Boolean; var RecordCount : Double);

    //Function to check that no-one else is using the company - tries to
    //get exclusive access to ExchqSS.dat
    function GotCompanyExclusive(const CompanyPath : string) : Boolean;

    procedure StartProgress;
    procedure EndProgress(EncryptionFailed : Boolean);

    //Calculates and returns the estimated time in seconds to encrypt a file (HLD 2.2.1.2)
    function CalculateEstimate(const pData : PVTNodeData) : Double;

    //Recalculate the Local Performance Modifier after an encryption
    procedure RecalculateLPM(NodeData : PVTNodeData; EstimatedSeconds : Double; ActualSeconds : Double);
    procedure RecalculateEstimates;

    //Display confirmation/warning form
    function GetConfirmation(const Company : string;
                             const Filename : string;
                             const Estimate : string) : Boolean;

    //Handler for message posted by Encryption Thread on completion
    procedure WMEncryptionThreadFinished(var Message : TMessage); message WM_ENCRYPTION_THREAD_FINISHED;
    procedure WMGetMinMaxInfo(Var Message  :  TWMGetMinMaxInfo); Message WM_GetMinMaxInfo;
  public
    { Public declarations }
  end;

  procedure EncryptFiles(AParent : TForm);

var
  frmMain: TfrmMain;

implementation

uses
  oCompanyFile, FileUtil, ConfirmF, APIUtil, StrUtil, StrUtils, DateUtils,
  EtMiscU, LicRec, EntLic, Varconst;

{$R *.dfm}

const
  S_CONFIG_FILE = 'EncryptFiles.xml';
  S_LOG_FILE = 'Logs\DataEncryption.log';
  S_COMPANY_SS_FILE = 'EXCHQSS.DAT';

  INITIAL_READ_RECORDS = 10000;
  EXCLUSIVE_MODE = -4;
  LPM_RECORDS_THRESHOLD = 10000;
  LPM_MSECS_THRESHOLD = 60000;



procedure EncryptFiles(AParent : TForm);
begin
  //Show progress form as a splash screen while we scan the files in the system.
  //Use global progress form so it can be released at end of LoadData before
  //showing the main form modally (frmEncryptProgress is in ProgressF.pas)
  frmEncryptProgress := TfrmEncryptProgress.Create(Application);
  frmEncryptProgress.StartNonModal('Exchequer Data Encryption',
                            'Please wait...scanning installation');

  //Filescan is done in FormCreate method
  frmMain := TfrmMain.Create(AParent);
end;

procedure TfrmMain.LoadTree;
var
  Res : Integer;
  CurrentFolder : string;
  oComp : TCompanyBtrieveFile;
  CompDet : ^CompanyDetRec;
  ParentNode: PVirtualNode;
  Data,
  ParentData: PVTNodeData;

  xmlFile, xmlFiles : TGmXMLNode;
  sFilename : string;

  NodeCounter : Integer;

  procedure LoadFiles(ANode : PVirtualNode);
  var
    i : integer;
    Node : PVirtualNode;
    LocalData : PVTNodeData;
  begin
    while (NodeCounter < FileList.Count) and
          (PVTNodeData(FileList[NodeCounter])^.CompNodeType = ntFile) do
    begin
      LocalData := PVTNodeData(FileList[NodeCounter]);
      if not LocalData.IsEncrypted and
        (LocalData.GDPR or not chkGDPROnly.Checked) then
      begin
        Node := CompanyTree.AddChild(ANode);
        Data := CompanyTree.GetNodeData(Node);
        Data^ := LocalData^;
      end;
      inc(NodeCounter);
    end;
  end;

begin
    NodeCounter := 0;
    
    //Add global files
    LoadFiles(RootNode);

    //Add companies
    while NodeCounter < FileList.Count do
    begin
      ParentNode := CompanyTree.AddChild(RootNode);
      Data := CompanyTree.GetNodeData(ParentNode);

      Data^ := PVTNodeData(FileList[NodeCounter])^;
      inc(NodeCounter);
      LoadFiles(ParentNode);

    end; //wile Res = 0

    CompanyTree.FullExpand(nil);
end;

procedure TfrmMain.FormCreate(Sender: TObject);
var
  LicenceRec : EntLicenceRecType;
begin
  WindowsID := WinGetUserName;
  WorkstationID := WinGetComputerName;

  FileStatusChecker := TBaseBtrieveFile.Create;
  FileStatusChecker.BypassOpenCompany := True;

  CompanyTree.RootNodeCount := 1;
  CompanyTree.NodeDataSize := SizeOf(TVTNodeData);

  FileList := TList.Create;

  FProgressForm := TfrmEncryptProgress.Create(Application);

  FXML := TGmXML.Create(NIL);

  //Need to set caption here as it is too long for design-time editor
  lblEstimate.Caption := 'The estimated time shown against each file is an ' +
    'estimate - it cannot take account of local conditions, and the process may ' +
    'take more time or less depending on network and server performance. ' +
    'For safety you should assume it will take longer and plan accordingly.';

  //Get the company name for the installation
  if ReadEntLic(GetEnterpriseDirectory + EntLicFName, LicenceRec) then
    InstallationName := Trim(LicenceRec.licCompany)
  else
    InstallationName := '';

  LoadData;
end;

procedure TfrmMain.CompanyTreeGetText(Sender: TBaseVirtualTree;
  Node: PVirtualNode; Column: TColumnIndex; TextType: TVSTTextType;
  var CellText: WideString);
var
  Data : PVTNodeData;
begin
  CellText := '';

  Data := Sender.GetNodeData(Node);
  Case Column of
    0 : if Data.CompNodeType = ntFile then
          CellText := Data.Filename
        else
          CellText := Data.Description;
    1 : if Data.CompNodeType = ntFile then
          CellText := GetStatusDescription(Data);
    2 : if Data.CompNodeType = ntFile then
          CellText := EstimateText(Data.Estimate);
  end;
end;

//Returns user-friendly time string as HLD 2.2.1.4
function TfrmMain.EstimateText(EstTime: Double): string;
var
  days, hours, mins : integer;
  EstTimeInSecs : Integer;

  //function to put value into string, leaving blank if 0 and
  //adding 's' if > 1
  function ResultSection(TimeValue : Integer; TimeString : string) : string;
  begin
    if TimeValue > 0 then
    begin
      Result := IntToStr(TimeValue) + ' ' + TimeString;
      if TimeValue > 1 then
        Result := Result + 's';

      Result := Result + ' ';
    end
    else
      Result := '';
  end;

begin
  if EstTime < 1.000 then
    EstTime := 1.000;

  EstTimeInSecs := Trunc(EstTime);

  mins := 0;
  hours := 0;
  days := 0;

  //Convert seconds to minutes, rounding up to nearest minute
  mins := EstTimeInSecs div 60;
  if EstTimeInSecs mod 60 > 0 then
    inc(mins);

  if mins = 0 then
    mins := 1;


  if mins > 60 then
  begin
    //convert minutes to hours and minutes
    hours := mins div 60;
    mins := mins mod 60;
  end;

  if hours > 24 then
  begin
    //Convert hours and minutes to days and hours
    days := hours div 24;
    hours := hours mod 24;

    //Drop minutes, rounding up to next hour
    if mins > 0 then
    begin
      mins := 0;
      inc(hours);

      //Check if rounding up has gone to 24 hours, in
      //which case convert to days
      if hours > 23 then
      begin
        inc(days);
        Hours := 0;
      end;
    end;
  end;

  //Build user-friendly result string
  Result := ResultSection(days,  'day') +
            ResultSection(hours, 'hour') +
            ResultSection(mins,  'minute');

  if Length(Result) > 0 then
    Delete(Result, Length(Result), 1);

end;

function TfrmMain.GetStatusDescription(
  const NodeData: PVTNodeData): string;
begin
  if NodeData.IsEncrypted then
    Result := 'Encrypted' else
  if NodeData.GDPR then
    Result := 'Not Encrypted - Encryption recommended for GDPR compliance'
  else
    Result := 'Not Encrypted';
end;

procedure TfrmMain.CompanyTreeInitNode(Sender: TBaseVirtualTree;
  ParentNode, Node: PVirtualNode;
  var InitialStates: TVirtualNodeInitStates);
var
  Data : PVTNodeData;
begin
  if ParentNode = nil then
  begin
    RootNode := Node;
    Data := CompanyTree.GetNodeData(RootNode);
    Data.Description := 'Exchequer Installation - ' + InstallationName;
    Data.CompNodeType := ntRoot;
    LoadTree;
  end;
end;

//Checks whether a file is encrypted and the number of records it has
procedure TfrmMain.GetFileDetails(const Filename : string; var IsEncrypted : Boolean; var RecordCount : Double);
var
  Res : integer;
  FileInfo : TStatExtFileInfo;
begin
  FileStatusChecker.FilePath := Filename;
  Res := FileStatusChecker.OpenFile;
  if Res = 0 then
  Try
    Res := FileStatusChecker.StatExtendedFileInfo(FileInfo);
    if Res = 0 then
    begin
      IsEncrypted := (FileInfo.Flags and $100) = $100;
      RecordCount := FileStatusChecker.GetRecordCount;
    end
    else
      raise Exception.Create('Error ' + IntToStr(Res) + ' accessing info from ' + Filename);
  Finally
    FileStatusChecker.CloseFile;
  End
  else
    raise Exception.Create('Error ' + IntToStr(Res) + ' opening ' + Filename);
end;

procedure TfrmMain.chkGDPROnlyClick(Sender: TObject);
begin
  //Clear the tree and reload it
  CompanyTree.Clear;
  CompanyTree.RootNodeCount := 1;
  CompanyTree.NodeDataSize := SizeOf(TVTNodeData);

  //Call refresh to reload the tree
  CompanyTree.Refresh;
  Application.ProcessMessages;
end;

//Handler for message posted by Encryption Thread on completion
procedure TfrmMain.WMEncryptionThreadFinished(var Message: TMessage);
var
  EncryptionResult : Integer;
  NodeData : PVTNodeData;
  StatusString : string;
  MSecsTaken : Cardinal;
  Filestring : string;
begin
  EndTime := Now;
  EndProgress(Message.LParam <> 0);
  CurrentActualSeconds := MilliSecondsBetween(EndTime, StartTime);

  CurrentActualSeconds := CurrentActualSeconds / 1000;

  //Safety check to avoid zero in calculations
  if CurrentActualSeconds < 0.001 then
    CurrentActualSeconds := 0.001;

  //Set
  EncryptionResult := Message.LParam;
  NodeData := CompanyTree.GetNodeData(CompanyTree.FocusedNode);
  FileString := NodeData.CompanyPath + NodeData.Filename;
  if EncryptionResult = 0 then
  begin
    NodeData.IsEncrypted := True;
    PVTNodeData(FileList[NodeData.Idx])^.IsEncrypted := True;
    StatusString := 'Encryption Complete';

    //Recalculate the LPM
    RecalculateLPM(NodeData, CurrentEstimatedSeconds, CurrentActualSeconds);
    NodeData.Estimate := 0;

    Application.ProcessMessages;
  end
  else
    StatusString := 'Encryption failed with error ' + IntToStr(EncryptionResult);

  //Write to log
  WriteLog(Filestring, StatusString,
            CurrentActualSeconds);

  //If this was a company file then we kept ExchqSS.dat open for the duration,
  //so close it now and free the file object
  if Assigned(oSSFile) then
  begin
    oSSFile.CloseFile;
    FreeAndNil(oSSFile);
  end;

  //Tell user that this encryption failed
  if EncryptionResult <> 0 then
    msgBox(StatusString, mtError, [mbOK], mbOK, 'Encryption failed');

end;

procedure TfrmMain.btnEncryptClick(Sender: TObject);
var
  FileName : string;
  oFile    : TBaseBtrieveFile;
  Res      : Integer;
  ParentData,
  NodeData : PVTNodeData;
  CompanyString : string;
begin
  if Assigned(CompanyTree.FocusedNode) then
  begin
    //Get data for selected item
    NodeData := CompanyTree.GetNodeData(CompanyTree.FocusedNode);

    //If it's not a file then don't do anything
    if NodeData.CompNodeType <> ntFile then
      EXIT;

    //Get the data for the Company
    ParentData := CompanyTree.GetNodeData(CompanyTree.FocusedNode.Parent);

    //Create a pervasive file access object. (It's destroyed by the Encryption thread)
    oFile := TBaseBtrieveFile.Create;

    oFile.BypassOpenCompany := True;
    oFile.FilePath := NodeData.CompanyPath + NodeData.Filename;

    //If the file is a company file then call GotCompanyExclusive to check
    //that we have exclusive access to Exchqss.dat
    //Don't call GotCompanyExclusive if we're processing ExchqSS.Dat as that
    //causes problems
    if NodeData.GlobalFile or
       ((UpperCase(NodeData.Filename) = S_COMPANY_SS_FILE) or
         GotCompanyExclusive(ExtractFilePath(NOdeData.CompanyPath))) then
    begin
      //Open in exclusive mode
      Res := oFile.OpenFile('', False, v600Owner, EXCLUSIVE_MODE);
      if Res = 0 then
      begin

        //Opened OK. If it's a global file we don't want the confirmation
        //form labels referencing companies, so set the string accordingly
        if NodeData.GlobalFile then
          CompanyString := S_SYSTEM
        else
          CompanyString := ParentData.Description;

        btnEncrypt.Enabled := False;

        //Display warning dialog
        if GetConfirmation(CompanyString, NodeData.Filename,
                            EstimateText(NodeData.Estimate)) then
        begin
          //Store the estimate for calculating the LPM at the end of the process
          CurrentEstimatedSeconds := NodeData.Estimate;
          FCurrentFileName := NodeData.Filename;

          //OK to continue. Spawn a background thread to do the work, and
          //show the prograss form
          FEncryptionThread := TEncryptionThread.Create(True);
          FEncryptionThread.BtrieveFile := oFile;
          FEncryptionThread.OwnerHandle := Self.Handle;
          FEncryptionThread.FreeOnTerminate := True;
          StartTime := Now;

          //Moved WriteLog call to here to avoid misleading starttime on log
          WriteLog(oFile.FilePath, 'Encryption Started', NodeData.Estimate);

          FEncryptionThread.Resume;
          StartProgress;
        end
        else
        begin
          //File opened but processing cancelled, so close files and free objects
          oFile.CloseFile;
          FreeAndNil(oFile);
          if Assigned(oSSFile) then
          begin
            oSSFile.CloseFile;
            FreeAndNil(oSSFile);
          end;
        end;
      end
      else
      if Res = 88 then
      begin
        ShowMessage('Unable to get exclusive access to ' + oFile.FilePath + '.'#10 +
                    'Please ensure that no-one is using this file');
      end
      else
        ShowMessage('Unable to open file: ' + oFile.FilePath + '. Error ' + IntToStr(Res));
    end  //Get exclusive access to Exchqss.dat
    else
    begin
      ShowMessage('Unable to get exclusive access to company ' + ParentData.Description + '.'#10 +
                  'Please ensure that no-one is using this file');
    end;
  end; //Assigned(CompanyTree.FocusedNode)

end;

procedure TfrmMain.EndProgress(EncryptionFailed : Boolean);
begin
  //Close the progress from and re-enable the buttons
  FProgressForm.Stop;
  btnClose.Enabled := True;
  if EncryptionFailed then
    btnEncrypt.Enabled := True;
end;

//Display confirmation/warning form
function TfrmMain.GetConfirmation(const Company : string;
                                  const Filename : string;
                                  const Estimate : string) : Boolean;
begin
  with TfrmConfirmation.Create(Self) do
  Try
    SetInfo(Company, Filename, Estimate);
    ShowModal;
    Result := ModalResult = mrYes;
  Finally
    Free;
  End;
end;

procedure TfrmMain.StartProgress;
begin
  btnClose.Enabled := False;
  btnEncrypt.Enabled := False;
  FProgressForm.Start('Pervasive Data Encryption',
                      'Please wait. Encrypting file ' +
                      FCurrentFilename);
end;

procedure TfrmMain.btnCloseClick(Sender: TObject);
begin
  Close;
end;

procedure TfrmMain.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
begin
  //Don't allow program to be closed while the encryption thread is running.
  //Close button is disabled while the thread is running.
  CanClose := btnClose.Enabled;
end;


//Function to check that no-one else is using the company - tries to
//get exclusive access to ExchqSS.dat. If successful the file is held
//open until the encryption thread completes
function TfrmMain.GotCompanyExclusive(const CompanyPath : string) : Boolean;
var
  Res   : Integer;
begin
  Result := False;
  if not Assigned(oSSFile) then
  begin
    oSSFile := TBaseBtrieveFile.Create;
    Try
      oSSFile.BypassOpenCompany := True;
      oSSFile.FilePath := CompanyPath + S_COMPANY_SS_FILE;
      Res := oSSFile.OpenFile('', False, v600Owner, EXCLUSIVE_MODE);
      Result := Res = 0;
    Finally
      //Couldn't open so free the object
      if not Result then
        FreeAndNil(oSSFile);
    End;
  end; //if not Assigned(oSSFile) then
end;

procedure TfrmMain.WriteLog(const Filename : string; const Status : String;
                            EstimateOrTime : Double);
var
  LogF : TextFile;
begin
  AssignFile(LogF, LogPath);
  if FileExists(LogPath) then
    Append(LogF)
  else
  begin
    //Create file and write header
    Rewrite(LogF);
    WriteLn(LogF, ArrayOfStringToString(['Windows User ID',
                                         'Workstation Name',
                                         'Date/Time',
                                         'File',
                                         'Status',
                                         'Estimate/Time taken (Seconds)']
                                         ));
  end;
  Try
    WriteLn(LogF, ArrayOfStringToString([WindowsID,
                                         WorkstationID,
                                         FormatDateTime('c', Now),
                                         Filename,
                                         Status,
                                         Format('%11.3f', [EstimateOrTime])]
                                         ));
  Finally
    CloseFile(LogF);
  End;

end;

//Reads 1000 headers from Document.Dat and returns elapsed time in seconds
function TfrmMain.InitialRead(const CompanyPath : string) : Double;
var
  oFile : TDocumentFile;
  Res, RecordsRead   : Integer;
  LStartTime : TDateTime;
  LEndTime : TDateTime;
begin
  Result := 0;
  oFile := TDocumentFile.Create;
  Try
    oFile.BypassOpenCompany := True;
    oFile.FilePath := CompanyPath + 'TRANS\DOCUMENT.DAT';
    Res := oFile.OpenFile('', False, v600Owner, 0);
    if Res = 0 then
    begin
      Res := oFile.GetFirst;
      RecordsRead := 0;
      LStartTime := Now;

      //Read up to INITIAL_READ_RECORDS from the file
      while (Res = 0) and (RecordsRead < INITIAL_READ_RECORDS) do
      begin
        Res := oFile.GetNext;
        if Res = 0 then
          inc(RecordsRead);
      end;
      LEndTime := Now;
      Result := MilliSecondsBetween(LEndTime, LStartTime);

      Result := Result / 1000;

      //If we didn't read as many as INITIAL_READ_RECORDS then
      //calculate how long it would have taken
      if (Result > 0) and (RecordsRead < INITIAL_READ_RECORDS) then
      begin
        Result := Result * (INITIAL_READ_RECORDS / RecordsRead);
      end;

      {$IFDEF DEBUG}
      ShowMessage(Format('%d : %8.3f', [RecordsRead, Result]));
      {$ENDIF}
    end;
  Finally
    oFile.CloseFile;
    oFile.Free;
  End;
end;


//Calculates and returns the estimated time in seconds to encrypt a file (HLD 2.2.1.2)
function TfrmMain.CalculateEstimate(const pData: PVTNodeData): Double;
begin
  with pData^ do
  begin
    //Belt and braces to avoid div by zero
    if EstimatedRecords < 1 then
            EstimatedRecords := 1;
    if ActualRecords < 1 then
            ActualRecords := 1;
    Result := EstimatedSeconds * ReadRatio *
             (ActualRecords / EstimatedRecords) * LocalPerformanceModifier;
  end;

  //Safety check to avoid zero in calculations
  if Result < 0.001 then
    Result := 0.001;
end;

//Recalculate the Local Performance Modifier after an encryption
procedure TfrmMain.RecalculateLPM(NodeData : PVTNodeData; EstimatedSeconds : Double; ActualSeconds : Double);
var
  xmlNode : TGmXMLNode;
  PreviousLPM : Double;
begin
  //Check if it's worth recalculating - estimated time over 1 minute;
  if (Trunc(NodeData.Estimate) * 1000 < LPM_MSECS_THRESHOLD) then
       EXIT;

  //Store original
  PreviousLPM := LocalPerformanceModifier;
  //Recalculate
  LocalPerformanceModifier := Round_Up(ActualSeconds / EstimatedSeconds, 3);

  //Sanity check to avoid zero
  if LocalPerformanceModifier < 0.001 then
    LocalPerformanceModifier := 0.001;

  //If LPM has changed , write it back to the xml file
  if Abs(LocalPerformanceModifier - PreviousLPM) > 0.01 then
  begin
    xmlNode := FXML.Nodes.NodeByName['Estimation'];
    if Assigned(xmlNode) then
    begin
      xmlNode.Attributes.ElementByName['LPM'].Value :=
           FloatToStr(LocalPerformanceModifier);
      FXML.SaveToFile(GetEnterpriseDirectory + S_CONFIG_FILE);
    end;
    RecalculateEstimates;
  end
  else
    LocalPerformanceModifier := PreviousLPM;
end;

procedure TfrmMain.LoadData;
var
  Res : Integer;
  CurrentFolder : string;
  oComp : TCompanyBtrieveFile;
  CompDet : ^CompanyDetRec;
  ParentNode: PVirtualNode;
  Data,
  ParentData: PVTNodeData;

  xmlFile, xmlFiles : TGmXMLNode;
  sFilename : string;

  //Load filenames listed in XML file. xmlFile node will be loaded with
  //either GlobalFiles or CompanyFiles - ANode is the parent in the tree
  procedure LoadFiles(GlobalFiles : Boolean);
  var
    i : integer;
    Node : PVirtualNode;
  begin
    if Assigned(xmlFiles) then
    begin
      for i := 0 to xmlFiles.Children.Count - 1 do
      begin
        xmlFile := xmlFiles.Children[i];
        sFileName := xmlFile.Attributes.ElementByName['Name'].Value;

        //If this file is optional then check if it exists
        if ((xmlFile.Attributes.ElementByName['Optional'].Value = 'N') or
            FileExists(CurrentFolder + sFilename)) then
        begin
          Data := New(PVTNOdeData);
          FillChar(Data^, SizeOf(Data^), 0);
          FileList.Add(Data);
          Data.CompNodeType := ntFile;
          Data.FileName := sFilename;
          Data.CompanyPath := CurrentFolder;
          Data.GDPR := xmlFile.Attributes.ElementByName['GDPR'].Value = 'Y';

          GetFileDetails(CurrentFolder + Data.FileName, Data.IsEncrypted, Data.ActualRecords);

          Data.GlobalFile := GlobalFiles;

          Data.EstimatedSeconds := Round_Up(StrToFloat(xmlFile.Attributes.ElementByName['EstimateSeconds'].Value)
                                             / 1000, 3);
          Data.EstimatedRecords :=
                   StrToInt(xmlFile.Attributes.ElementByName['EstimateRecords'].Value);
          Data.Estimate := CalculateEstimate(Data);
          Data.Idx := FileList.Count - 1;

          //Update Counts
          if not Data.IsEncrypted then
          begin
            inc(UnencryptedFileCount);
            if Data.GDPR then
              inc(GDPRFileCount);
          end;
        end; //if not optional
      end;

    end;
  end;
begin
  UnencryptedFileCount := 0;
  GDPRFileCount := 0;

  CurrentFolder := IncludeTrailingBackslash(GetEnterpriseDirectory);
  LogPath := CurrentFolder + S_LOG_FILE;

  //Load xml config file
  FXML.LoadFromFile(CurrentFolder + S_CONFIG_FILE);

  //Read Estimate variables
  xmlFile := FXML.Nodes.NodeByName['Estimation'];

  OurInitialReadSeconds := StrToFloatDef(xmlFile.Attributes.ElementByName['THSeconds'].Value, 0.1);
  LocalPerformanceModifier := StrToFloatDef(xmlFile.Attributes.ElementByName['LPM'].Value, 1.0);

  //Time a read of 1000 records from Document.dat and calculate the ratio
  //between that and the same read on our system
  TheirInitialReadSeconds := InitialRead(CurrentFolder);
  if TheirInitialReadSeconds < 0.001 then
    TheirInitialReadSeconds := 0.001;
  ReadRatio := TheirInitialReadSeconds / OurInitialReadSeconds;

  //Create object to read company.dat
  oComp := TCompanyBtrieveFile.Create;

  oComp.FilePath := CurrentFolder +
                       'COMPANY.DAT';
  oComp.BypassOpenCompany := True;

  Res := oComp.OpenFile;

  if Res = 0 then
  Try
    //Add global files
    xmlFiles := FXML.Nodes.NodeByName['GlobalFiles'];
    LoadFiles(True);

    //Add companies
    Res := oComp.GetGreaterThan(cmCompDet);

    while (Res = 0) and (oComp.SearchKey[1] = cmCompDet) do
    begin
      CurrentFolder := Trim(oComp.CompanyDetails.CompPath);
      CurrentFolder := IncludeTrailingBackslash(CurrentFolder);
      Data := New(PVTNodeData);
      FillChar(Data^, SizeOf(Data^), 0);
      FileList.Add(Data);

      Data.Description := Trim(oComp.CompanyDetails.CompCode) + ' - ' +
                           Trim(oComp.CompanyDetails.CompName);
      Data.CompNodeType := ntCompany;


      xmlFiles := FXML.Nodes.NodeByName['CompanyFiles'];
      LoadFiles(False);


      Res := oComp.GetNext;
    end; //wile Res = 0
  Finally
    oComp.CloseFile;
    oComp.Free;
  End;

  //Close progress window
  frmEncryptProgress.Stop;
  FreeAndNil(frmEncryptProgress);

  if UnencryptedFileCount = 0 then
  begin
    ShowMessage('All files in this installation are encrypted');
    PostMessage(Self.Handle, WM_CLOSE, 0, 0);
  end
  else
  begin
    if chkGDPROnly.Checked and (GDPRFileCount = 0) then
    begin
      chkGDPROnly.Checked := False;
    end;
    ShowModal;
  end;
end;

procedure TfrmMain.FormResize(Sender: TObject);
const
  SPACER = 5;
begin
  chkGDPROnly.Top := ClientHeight - chkGDPROnly.Height - SPACER;
  btnClose.Left := ClientWidth - btnClose.Width - SPACER;
  btnEncrypt.Left := btnClose.Left;


  CompanyTree.Top := pnlMessages.Height + SPACER;
  CompanyTree.Width := ClientWidth - CompanyTree.Left - (ClientWidth - btnClose.Left) - SPACER;
  CompanyTree.Height := ClientHeight - CompanyTree.Top - (chkGDPROnly.Height) - (SPACER * 2);
end;

procedure TfrmMain.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Action := caFree;
end;

procedure TfrmMain.WMGetMinMaxInfo(var Message: TWMGetMinMaxInfo);
begin
  With Message.MinMaxInfo^ do
  Begin
    ptMinTrackSize.X:= 808;
    ptMinTrackSize.Y:= 300;
  end;

  Message.Result:=0;

  Inherited;

end;

procedure TfrmMain.CompanyTreeFocusChanged(Sender: TBaseVirtualTree;
  Node: PVirtualNode; Column: TColumnIndex);
var
  Data : PVTNodeData;
begin
  //Only enable encrypt button if a file is selected
  Data := Sender.GetNodeData(Node);
  btnEncrypt.Enabled := (Data.CompNodeType = ntFile) and not Data.IsEncrypted;
end;

procedure TfrmMain.RecalculateEstimates;
var
  i : Integer;
  Data: PVTNodeData;
begin
  for i := 0 to FileList.Count - 1 do
  begin
    Data := FileList.Items[i];
    Data.Estimate := CalculateEstimate(Data);
  end;
  chkGDPROnlyClick(nil);
end;

end.
