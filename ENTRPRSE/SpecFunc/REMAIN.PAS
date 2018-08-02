unit REMain;

interface

uses
  SysUtils, WinTypes, WinProcs, Messages, Classes, Graphics, Controls,
  Forms, Dialogs, StdCtrls, Buttons, ExtCtrls, Menus, ComCtrls, ClipBrd,
  GlobVar, Gauges, SBSPanel, CheckLst, BorBtns, Mask,

  SFManagerU,
  SFPasswordU,
  SFHeaderU,
  UnTils,
  TEditVal;

  Const
    WM_ActivateFormDes = WM_USER + $100;

type
  TSFMode = (smNotSet, smSpecialFunctions, smRebuildDataFiles,
             smPurgeOrders, smPurgeAccountsData, smPervasiveFileInformation,
             smBtrieveEngineInformation, smSQLInformation, smConfigInformation);

  TMainForm = class(TForm)
    OpenDialog: TOpenDialog;
    SaveDialog: TSaveDialog;
    PrintDialog: TPrintDialog;
    FontDialog1: TFontDialog;
    MainPnl: TPanel;
    PageControl: TPageControl;
    SelectOptionPage: TTabSheet;
    SelectFunctionPage: TTabSheet;
    Panel1: TPanel;
    Label1: TLabel;
    SelectFilesPage: TTabSheet;
    FileList: TCheckListBox;
    ProcessPage: TTabSheet;
    ReadyToProcessLbl: TLabel;
    FunctionLbl: TLabel;
    InfoLbl: Label8;
    ProgressBar: TProgressBar;
    ReportPage: TTabSheet;
    RichEdit1: TRichEdit;
    Panel2: TPanel;
    PageTitleLbl: TLabel;
    ButtonPnl: TPanel;
    NavButtonPnl: TPanel;
    BackBtn: TButton;
    NextBtn: TButton;
    CancelBtn: TButton;
    ImagePnl: TPanel;
    Image1: TImage;
    PurgeAccountsPage: TTabSheet;
    Label82: Label8;
    PAShrinkChk: TBorCheck;
    PARemoveCustomersChk: TBorCheck;
    PARemoveSuppliersChk: TBorCheck;
    PARemoveStockChk: TBorCheck;
    PARemoveLocationsChk: TBorCheck;
    PARemoveSerialChk: TBorCheck;
    PAYearSpin: TUpDown;
    PurgeOrdersPage: TTabSheet;
    Label83: Label8;
    Label84: Label8;
    Label85: Label8;
    Label86: Label8;
    Label87: Label8;
    edtPOYear: TEditPeriod;
    edtPOIncludeAcct: Text8Pt;
    edtPOExcludeAcct: Text8Pt;
    edtPOIncludeType: Text8Pt;
    edtPOExcludeType: Text8Pt;
    POShrinkChk: TBorCheck;
    Label4: TLabel;
    PAErrorTxt: TStaticText;
    edtPAYear: TMaskEdit;
    FunctionMsgLbl: TLabel;
    edtFuncNo: TEdit;
    PasswordPage: TTabSheet;
    edtResponse: TMaskEdit;
    lblPassword: TLabel;
    FuncsPageControl: TPageControl;
    FuncsPage: TTabSheet;
    CustomFuncsPage: TTabSheet;
    FuncsList: TListBox;
    CustomFuncsList: TListBox;
    lblPasswordRequired: TLabel;
    SaveBtn: TButton;
    lblDebugResponse: TLabel;
    lblSecurityCode: TLabel;
    lblChallenge: TStaticText;
    lblPhonetic: TLabel;
    Panel3: TPanel;
    AllFilesBtn: TButton;
    NoFilesBtn: TButton;
    OptionGroup: TRadioGroup;
    InfoPage: TTabSheet;
    edtInfo: TRichEdit;
    lblVersion: TLabel;
    Label2: TLabel;
    procedure FormCreate(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure FormDestroy(Sender: TObject);
    procedure Debug1Click(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure ABortBM1Click(Sender: TObject);
    procedure CheckPervasive1Click(Sender: TObject);
    procedure BackBtnClick(Sender: TObject);
    procedure NextBtnClick(Sender: TObject);
    procedure CancelBtnClick(Sender: TObject);
    procedure FuncsListDblClick(Sender: TObject);
    procedure FuncsListClick(Sender: TObject);
    procedure FileListClick(Sender: TObject);
    procedure edtPOIncludeAcctExit(Sender: TObject);
    procedure edtPAYearExit(Sender: TObject);
    procedure edtPAYearChange(Sender: TObject);
    procedure FuncsListDrawItem(Control: TWinControl; Index: Integer;
      Rect: TRect; State: TOwnerDrawState);
    procedure edtFuncNoChange(Sender: TObject);
    procedure FuncsPageControlChange(Sender: TObject);
    procedure SaveBtnClick(Sender: TObject);
    procedure edtResponseChange(Sender: TObject);
    procedure AllFilesBtnClick(Sender: TObject);
    procedure NoFilesBtnClick(Sender: TObject);
  private
    FFileName: String;
    FUpdating: Boolean;
    FDragOfs: Integer;
    BeenOn,
    FDragging: Boolean;

    fDriveNo: Integer;
    fDiskSize,
    fDiskFree         : Int64;

    FClientInstance,
    FPrevClientProc   : TFarProc;

    IsProcessing: Boolean;

    ONCMetrics,
    NCMetrics         : PNonClientMetrics;

    // HM 11/08/03: Added flag to control whether the scrollbar size gets reset - causes
    //              tray icon corruption under Windows XP - AOK on all other OS's
    SetXPScrollSize : Boolean;

    Manager: TSFManager;
    ProgBar: TSFProgressBar;
    PasswordGenerator: TSFPassword;
    Mode: TSFMode;
    DLLFnCount: Integer;
    PAFilesAreOpen: Boolean;

    OptionList: TList;

    //PR: 14/03/2013 ABSEXCH-12118 Add flag to allow single spaced messages.
    FSingleSpacing : Boolean;

    procedure LaunchSpecialFunction(Params: TSFParams);

    procedure ActivateApp(var Msg: TMessage);

    procedure GetDriveSpace;

    Procedure Update_DriveResource;

    Procedure WriteMemoryInfo;

    procedure OpenFile(FileName  :  String);

    Procedure WMCustGetRec(Var Message  :  TMessage); Message WM_CustGetRec;

    function CurrText: TTextAttributes;
    procedure SetFileName(const FileName: String);
    procedure CheckFileSave;
    procedure FileSave(Sender: TObject);
    procedure FileSaveAs(Sender: TObject);

    Procedure ReadWriteFile(FName,FDesc  :  String);

    procedure GotoREEnd;

    procedure ReportOnBtrieve;

    procedure DetermineMode;

    procedure NextPage;
    procedure PreviousPage;
    procedure CancelProcessing;
    procedure StartProcessing;
    procedure UpdatePageDisplay;
    function SelectedFileCount: Integer;
    function SelectedFunction: TSpecialFunction;

    procedure UpdateFunctionDisplay;

    function OnProgress(MaxTotal, Position: Integer): Boolean;
    procedure OnOutput(OutputMsg: ShortString; Style: TOutputStyle);

    procedure PurgeData;
    procedure RebuildDataFiles;
    procedure PervasiveFileInformation;
    procedure SQLInformation;
    procedure ConfigInformation;

    procedure SavePurgeOrderDetails;
    procedure LoadPurgeOrderDetails;

    function PurgeYear: Integer;
    procedure OpenPurgeAccountsFiles;
    procedure ClosePurgeAccountsFiles;
    procedure SavePurgeAccountsDetails;
    procedure LoadPurgeAccountsDetails;
    procedure ValidatePurgeAccountsYear(ShowMessage: Boolean);

  Public
    Procedure SetOutputEffect(pSize  :  Integer;
                          pColor :  TColor;
                          pStyle :  TFontStyles;
                          pAlign :  TAlignment);

    procedure SetOutputStyle(Style: TOutputStyle);

    Procedure WriteToOutput(fText  :  String;
                        SwlOn  :  Boolean);
  end;

var
  MainForm: TMainForm;

implementation

{$R *.DFM}

uses
  VarConst,
  ChildWin,
  ETMiscU,
  ETStrU,
  StrUtil,
  VarFPosU,
  BtrvU2,
  PathUtil,
  LocalVar,
  IniFiles,
  ProgU,
  SpeF3U,
  {$IFDEF WCBuild}
  Login,
  {$ENDIF}
  ReBuildU,
  ReBuld1U,
  ReBuld2U,
  Purge1U,
  PurgeOU,
  ETDateU,
  {$IFDEF EXSQL}
  SQLUtils,
  {$ENDIF}
  Phonetic,
  History,
  APiUtil;

const
  OPT_FUNCTIONS        = 'Special functions';
  OPT_REBUILD          = 'Rebuild data files';
  OPT_PURGE_ORDERS     = 'Purge orders';
  OPT_PURGE_ACCOUNTS   = 'Purge accounts';
  OPT_PERVASIVE_REPORT = 'Pervasive files report';
  OPT_BTRIEVE_REPORT   = 'Btrieve engine report';
  OPT_CONFIG_REPORT    = 'Windows configuration files report';
  OPT_SQL_REPORT       = 'Windows System report';

  SFReportSet: set of TSFMode = [smPervasiveFileInformation, smBtrieveEngineInformation, smSQLInformation, smConfigInformation];

// =============================================================================
// TMainForm
// =============================================================================
function TMainForm.CurrText: TTextAttributes;
begin
  if RichEdit1.SelLength > 0 then
    Result := RichEdit1.SelAttributes
  else
    Result := RichEdit1.DefAttributes;
end;

// -----------------------------------------------------------------------------

procedure TMainForm.SetFileName(const FileName: String);
begin
  FFileName := FileName;
  if (FFileName <> 'Untitled') then
    Caption := Format('%s - %s', ['Special Functions - For ' + sAppName, ExtractFileName(FileName)])
  else
    Caption := 'Special Functions - For ' + sAppName;
end;

// -----------------------------------------------------------------------------

procedure TMainForm.CheckFileSave;
var
  SaveResp: Integer;
begin
  if not RichEdit1.Modified then Exit;

  If (FFileName='Untitled') then
    SetFileName(SetDrive+'LOGS\SpecFunc.RTF');

  FileSave(Self);
end;

// -----------------------------------------------------------------------------

Procedure TMainForm.WMCustGetRec(Var Message  :  TMessage);
Begin
  Update_DriveResource;

  With Message do
  Begin

    Case WParam of

      0    :  ;  {Dummy sent by update stats}

      100  :  Begin
                // ConForm:=nil;

                If (CompSysInfo^.ExPathStr<>SetDrive) then
                Begin
                  SetDrive:=IncludeTrailingPathDelimiter(CompSysInfo^.ExPathStr);
                  GetDriveSpace;

                  UpDate_DriveResource;

                  WriteToOutput(sAppName + ' free disk space - '+SetDrive+ConstStr(#9,1)+Format('%.2f',[fDiskfree/1E6])+'mb',BOn);

                  SetOutputStyle(osInfo);

                end;
              end;

      500,
      501  : RichEdit1.PlainText:=(WParam=501);

      //PR: 14/03/2013 ABSEXCH-12118 Turn single spacing on or off.
      SINGLE_SPACING_ON
            : FSingleSpacing := True;

      SINGLE_SPACING_OFF
            : FSingleSpacing := False;

    end; {Case..}

  end;
  Inherited;
end;

// -----------------------------------------------------------------------------

procedure TMainForm.ActivateApp(var Msg: TMessage);
begin
  Application.Restore;
end;

// -----------------------------------------------------------------------------

procedure TMainForm.GetDriveSpace;
Var
  CDir  :  Str255;

Begin
  if (SetDrive='') then
  Begin
    GetDir(0,Cdir);

  end
  else
    Cdir:=SetDrive;

  fDriveNo:=Ord(UPCase(CDir[1]))-64;

  fDiskSize:=DiskSize(fDriveNo);


  If (fDiskSize<-1) then
    fDiskSize:=MaxLongInt+fDiskSize;
end;

// -----------------------------------------------------------------------------

procedure TMainForm.FormCreate(Sender: TObject);

  procedure BuildOptionList;
  begin

{$IFDEF WCBuild}
    OptionGroup.Items.Add(OPT_FUNCTIONS);
{$ELSE}
    if GotDailyPW then
      OptionGroup.Items.Add(OPT_FUNCTIONS);
{$ENDIF}

{$IFDEF EXSQL}
    if not SQLUtils.UsingSQL then
    begin
      OptionGroup.Items.Add(OPT_REBUILD);
    end
    else
    begin
      POShrinkChk.Visible := False;
      PAShrinkChk.Visible := False;
    end;
{$ELSE}
    OptionGroup.Items.Add(OPT_REBUILD);
{$ENDIF}
    if (rPurgeMode = 1) then
      OptionGroup.Items.Add(OPT_PURGE_ACCOUNTS);
    if (rPurgeMode = 2) then
      OptionGroup.Items.Add(OPT_PURGE_ORDERS);

{$IFDEF EXSQL}
    if SQLUtils.UsingSQL then
      OptionGroup.Items.Add(OPT_SQL_REPORT)
    else
    begin
      OptionGroup.Items.Add(OPT_PERVASIVE_REPORT);
      OptionGroup.Items.Add(OPT_BTRIEVE_REPORT);
    end;
{$ELSE}
    OptionGroup.Items.Add(OPT_PERVASIVE_REPORT);
    OptionGroup.Items.Add(OPT_BTRIEVE_REPORT);
{$ENDIF}
//    OptionGroup.Items.Add(OPT_CONFIG_REPORT);

    OptionGroup.ItemIndex := 0;
  end;

var
  i: Integer;
  Status: Integer;
  SysOK: Boolean;
begin
  Mode := smNotSet;

  ProcessPage.DoubleBuffered := True;

  PAFilesAreOpen := False;

  ProgBar := TSFProgressBar.Create;
  ProgBar.InfoLbl := InfoLbl;
  ProgBar.ProgressBar1 := ProgressBar;
  ProgBar.ProgLab := InfoLbl;

  {$IFDEF WCBuild}
//    sAppName := 'Wincard';
    SetDrive := IncludeTrailingPathDelimiter(ExtractFilePath(Application.ExeName));
  {$ELSE}

  IsProcessing := False;

//    sAppName := 'Enterprise';
  {$ENDIF}

  { Create the Function Manager }
  Manager := TSFManager.Create;
  { Load any Special Functions found in DLLs }
  Manager.LoadFunctions(SetDrive + 'plugins\');
  DLLFnCount := Manager.Count;
  { Assign any hard-coded Special Functions }
  for i := 1 to TotSFFunc do
  begin
    if (i in SFEntInclude) then
      Manager.Add(i, Get_SFMode(i), LaunchSpecialFunction);
  end;

  BuildOptionList;

  { Display the list of functions }
  Manager.PopulateList(FuncsList.Items, [fnHardCoded]);
  if (FuncsList.Count > 0) then
    FuncsList.ItemIndex := 0;
  Manager.PopulateList(CustomFuncsList.Items, [fnDLL, fnScript]);
  if (CustomFuncsList.Count > 0) then
    CustomFuncsList.ItemIndex := 0;

  PasswordGenerator := TSFPassword.Create;

  Application.Title := sAppName + ' - Special Functions';

  OpenDialog.InitialDir := ExtractFilePath(ParamStr(0));
  SaveDialog.InitialDir := OpenDialog.InitialDir;
  SetFileName('Untitled');

  PasswordGenerator.DataPath := OpenDialog.InitialDir;

  // HM 11/08/03: Added flag to control whether the scrollbar size gets reset - causes
  //              tray icon corruption under Windows XP - AOK on all other OS's
  If (GetWindowsVersion In wvXPStyle) Then
    SetXPScrollSize := FindCmdLineSwitch('XPSCROLL', ['-', '/', '\'], True) Or
                       FindCmdLineSwitch('XPSCROLL:', ['-', '/', '\'], True)
  Else
    SetXPScrollSize := True;

  Application.Hintpause:=1200;

  Application.UpdateFormatSettings:=BOff;

  GetDriveSpace;

  MasterAborted:=BOff;

  UpDate_DriveResource;

  lblVersion.Caption := SFVersion;

  With RichEdit1.Paragraph do
  Begin
    Tab[0]:=50;
    Tab[1]:=80;
    Tab[2]:=110;
  end;
  RichEdit1.Modified := False;

  WriteMemoryInfo;

  For i := 1 to TotFiles do
  With FileList do
  Begin
    Items.Add(FileNames[i]);
  end;

  Status := Open_File(F[SysF], SetDrive + FileNames[SysF], 0);
  SysOk := False;
  GetMultiSys(BOff,SysOk,SysR);

  BeenOn:=BOff;
  Mode := smSpecialFunctions;

  PageControl.ActivePage := SelectOptionPage;
  FuncsPageControl.ActivePage := FuncsPage;

  //PR: 14/03/2013 ABSEXCH-12118 Add flag to allow single spaced messages. Default to false.
  FSingleSpacing := False;
end;

// -----------------------------------------------------------------------------

Procedure TMainForm.WriteMemoryInfo;

Var
  MemInfo  :  TMemoryStatus;
  WL       :  Integer;

  VSN,
  Vers,VN  :  String;

Begin
  WriteToOutput(sAppName + ' Data Recovery and Maintenance Utility',BOn);

  SetOutputStyle(osHeader);

  WriteToOutput(GetCopyRightMessage + ConstStr(#9,5) + DateTimeToStr(Now), BOn);
  SetOutputStyle(osCopyright);

  WriteToOutput('System Details', BOn);
  SetOutputStyle(osSubHeader);

  MemInfo.dwLength:=Sizeof(MemInfo);
  GLobalMemoryStatus(MemInfo);

  With MemInfo do
  Begin
    WL:=Length(RichEdit1.Text);


    WriteToOutput('Total physical memory'+ConstStr(#9,3)+Format('%.2f',[(dwtotalphys/1E6)])+'mb',BOff);
    WriteToOutput('Total available physical memory'+ConstStr(#9,2)+Format('%.2f',[(dwAvailphys/1E6)])+'mb',BOff);
    WriteToOutput('Total virtual memory'+ConstStr(#9,3)+Format('%.2f',[dwtotalVirtual/1E6])+'mb',BOff);
    WriteToOutput('Total available virtual memory'+ConstStr(#9,3)+Format('%.2f',[(dwAvailVirtual/1E6)])+'mb',BOff);
    WriteToOutput('Total resource memory'+ConstStr(#9,3)+Format('%d',[Get_FreeResources])+'%',BOff);
    WriteToOutput('Total free disk space'+ConstStr(#9,3)+Format('%.2f',[fDiskfree/1E6])+'mb',BOff);
    WriteToOutput('',BOff);

    (*
    With Get_OS_Vers do
    Begin
      If (dwPlatformId=VER_PLATFORM_WIN32_NT) then
      Begin
        If (dwMajorVersion = 5) And (dwMinorVersion = 0) Then
          WriteToOutput('Operating system : '+ConstStr(#9,1)+'Windows 2000 '+Format('Build %d',[dwBuildNumber])+' '+szCSDVersion,BOff)
        Else If (dwMajorVersion = 5) And (dwMinorVersion = 1) Then
          WriteToOutput('Operating system : '+ConstStr(#9,1)+'Windows XP '+Format('Build %d',[dwBuildNumber])+' '+szCSDVersion,BOff)
        Else If (dwMajorVersion = 5) And (dwMinorVersion = 2) Then
          WriteToOutput('Operating system : '+ConstStr(#9,1)+'Windows 2003 '+Format('Build %d',[dwBuildNumber])+' '+szCSDVersion,BOff)
        else if (dwMajorVersion = 6) then
          WriteToOutput('Operating system : '+ConstStr(#9,1)+'Windows Vista '+Format('Build %d',[dwBuildNumber])+' '+szCSDVersion,BOff)
        Else
          WriteToOutput('Operating system : '+ConstStr(#9,1)+'Windows NT v'+Format('%d.%d Build %d',[dwMajorVersion,dwMinorVersion,dwBuildNumber])+' '+szCSDVersion,BOff);


      end
      else
      Begin
        WriteToOutput('Operating system : '+ConstStr(#9,1)+'Windows Chicago v'+Format('%d.%d Build %d',[dwMajorVersion,dwMinorVersion,dwBuildNumber])+' '+szCSDVersion,BOff);

        GetWin95RegVers(VSN,Vers,VN);

        WriteToOutput('O/S Ver from Registry: '+ConstStr(#9,1)+Vers+' v'+VN+VSN,BOff);

      end;
    end;
    *)

    WriteToOutput('Operating system : ' + ConstStr(#9, 1) + APIUtil.GetWindowsVersionString, BOff);

    With RichEdit1 do
    Begin
      SelStart:=WL;
      SelLength:=(Length(Text)-WL)+1;
    end;

    SetOutputStyle(osNormal);


  end; {With..}

end;

// -----------------------------------------------------------------------------

Procedure TMainForm.Update_DriveResource;
Begin
  fDiskFree:=DiskFree(fdriveNo);

  If (fDiskFree<-1) then
    fDiskFree:=MaxLongInt+fDiskFree;

end;

// -----------------------------------------------------------------------------

procedure TMainForm.FormDestroy(Sender: TObject);
begin
  PasswordGenerator.Free;
  ProgBar.Free;
  Manager.Free;
end;

// -----------------------------------------------------------------------------

procedure TMainForm.OpenFile(FileName  :  String);
Begin
  edtInfo.Lines.LoadFromFile(FileName);
  SetFileName(FileName);

  If (edtInfo.CanFocus) then
    edtInfo.SetFocus;

  edtInfo.Modified := False;
  edtInfo.ReadOnly := True;
end;

// -----------------------------------------------------------------------------

procedure TMainForm.FileSave(Sender: TObject);
begin
  if FFileName = 'Untitled' then
    FileSaveAs(Sender)
  else
  begin
    RichEdit1.Lines.SaveToFile(FFileName);

    {WriteIni(ExtractFileDir(FFileName)+'\'+ExtractOnlyFileName(FFileName)+'.ini');}

    RichEdit1.Modified := False;
  end;
end;

// -----------------------------------------------------------------------------

procedure TMainForm.FileSaveAs(Sender: TObject);
begin
  if SaveDialog.Execute then
  begin
    if FileExists(SaveDialog.FileName) then
      if MessageDlg(Format('OK to overwrite %s', [SaveDialog.FileName]),
        mtConfirmation, mbYesNoCancel, 0) <> idYes then Exit;

    SetFileName(ExtractOnlyFileName(SaveDialog.FileName)+'.RTF');

    RichEdit1.Lines.SaveToFile(FFileName);

    {With SaveDialog do
      WriteIni(ExtractFileDir(FileName)+'\'+ExtractOnlyFileName(FileName)+'.ini');}

    RichEdit1.Modified := False;
  end;
end;

// -----------------------------------------------------------------------------

procedure TMainForm.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
begin
  try
    CheckFileSave;
  except
    on E:Exception do
    begin
      ShowMessage(E.message);
      CanClose := False;
    end;
  end;
end;

// -----------------------------------------------------------------------------

Procedure TMainForm.SetOutputEffect(pSize  :  Integer;
                                pColor :  TColor;
                                pStyle :  TFontStyles;
                                pAlign :  TAlignment);
Begin
  With RichEdit1, CurrText, Paragraph do
  Begin
    Color:=PColor;
    Style:=pStyle;
    Size:=pSize;
    Alignment:=pAlign;

    SelLength:=0;

    Cursor:=Length(Text);
    //PR: 14/03/2013 ABSEXCH-12118 Add flag to allow single spaced messages.
    if not FSingleSpacing then
      Lines.Add(' ');

    Application.ProcessMessages;
  end;
end;

// -----------------------------------------------------------------------------

Procedure TMainForm.WriteToOutput(fText  :  String;
                              SwlOn  :  Boolean);

Var
  WasL:  Integer;

Begin
  With RichEdit1,Lines do
  Begin
    fText:=Strip('R',[#0],fText);

    WasL:=Length(Text);

    Application.ProcessMessages;

    Add(fText);

    If (SwlOn) then
    Begin
      SelStart:=WasL;
      SelLength:=Length(fText);
    end;

    Application.ProcessMessages;
  end;
end;

// -----------------------------------------------------------------------------

procedure TMainForm.Debug1Click(Sender: TObject);
begin
    {ShowMessage('H '+IntToStr(Height)+' x '+IntToStr(Width));}

    {With RichEdit1.VertScrollBar do
      ShowMessage('R '+IntToStr(Range)+' x '+IntToStr(Position));}
end;

// -----------------------------------------------------------------------------

Procedure TMainForm.ReadWriteFile(FName,
                                  FDesc  :  String);


Var
  F       :  TextFile;
  ChkIO,WL
          :  Integer;

  FileOk  :  Boolean;
  ThisLine:  String;
  BlankCount: Integer;


Begin
  {$I-}

  System.Assign(F,FName);
  System.Reset(F);

  ChkIO:=IOResult;

  ThisLine:='';
  BlankCount := 0;

  If (ChkIO=0) then
  With RichEdit1 do
  Begin
    System.ReadLn(F,ThisLine);

    ChkIO:=IOResult;

    FileOk:=BOn;

    WriteToOutput('',BOff);
    WriteToOutput('',BOff);

    WriteToOutput(FDesc,BOn);

    SetOutputStyle(osSubHeader);

    WL:=Length(RichEdit1.Text);


    While FileOk do
    Begin
      FileOk:=(Not EOF(F)) and (ChkIO=0);

      // If there are multiple blank lines, only output one.
      if (Trim(ThisLine) = '') then
        BlankCount := BlankCount + 1
      else
      begin
        if (BlankCount > 0) then
          WriteToOutput('', BOff);
        BlankCount := 0;
      end;

      If (Trim(ThisLine) <> '') and (UpCaseStr(Copy(ThisLine,1,3)) <> 'REM') then
        WriteToOutput(ThisLine,BOff);

      System.ReadLn(F,ThisLine);

      ChkIO:=IOResult;

    end;

    System.Close(F);

    With RichEdit1 do
    Begin
      SelStart:=WL;
      SelLength:=(Length(Text)-WL)+1;
      SetOutputStyle(osNormal);
      GotoREEnd;
    end;

  end
  else
  Begin
    WriteToOutput('',BOff);

    WriteToOutput('The file '+FName+' Could not be found.',BOn);

    SetOutputStyle(osWarning);
  end;

  {$I-}
end;

// -----------------------------------------------------------------------------

procedure TMainForm.ConfigInformation;
Var
  WinFile  :  String;

begin
  With CompSysInfo^ do
  Begin
    If WS_IsNT(WSOSVal) then
    Begin
      WinFile:=GetWinSystemPath(BOn)+'\System32\Config.NT';

      ReadWriteFile(WinFile,'Extract of '+WinFile);

    end
    else
    Begin
      WinFile:='C:\CONFIG.SYS';

      ReadWriteFile(WinFile,'Extract of '+WinFile);

      WinFile:='C:\AUTOEXEC.BAT';

      ReadWriteFile(WinFile,'Extract of '+WinFile);
    end;
  end;
end;

// -----------------------------------------------------------------------------

procedure TMainForm.GotoREEnd;

Begin
  With RichEdit1 do
  If (Visible) then
  Begin

    SetFocus;
    SendMessage(RichEdit1.Handle,WM_KeyDown,VK_End,0);

  end;
end;

// -----------------------------------------------------------------------------

procedure TMainForm.RebuildDataFiles;
var
  Ok2Cont: Boolean;
  n: Integer;
  HasSome: Boolean;
begin
  Ok2Cont:=Not WarnOnce;

  If (WarnOnce) then
    Ok2Cont:=Warn_Backup;

  WarnOnce:=Not Ok2Cont;

  If (Ok2Cont) then
  Begin
    {$IFDEF WCBuild}
      Ok2Cont:=CheckFile_Open(GroupF);
    {$ELSE}
      Ok2Cont:=CheckFile_Open(JMiscF);
    {$ENDIF}

    If (Not Ok2Cont) then
      ShowMessage('Some of the files are still open.'+#13+
                  'This is either due to users remaining in the system,'+#13+
                  'or a previous crash leaving the files open.'+#13+#13+
                  'Ensure all users are logged out of ' + sAppName + ', or'+#13+
                  'reset the P.SQL engine.');
  end;

  If (Ok2Cont) then
  Begin

    HasSome:=BOff;

    With FileList do
    Begin
      For n:=0 to Pred(Items.Count) do
      Begin
        FixFile[n+1].ReBuild:=Checked[n];

        If (Not HasSome) then
          HasSome:=Checked[n];
      end;

    end;

    if HasSome then
      Rebuild_Files(False, False, ProgBar);

  end;
end;

// -----------------------------------------------------------------------------

procedure TMainForm.ReportOnBtrieve;
Type
  VerRec   =  Record
                Ver,Rel  :  Integer;
                Typ      :  Char;

              end;
Var
  HasCS   :  Boolean;

  n       :  SmallInt;

  ConRec  :  Array[1..3] of VerRec;

  ServeMake
          :  Str20;

  ActBTVal,
  RecBTVal:  Integer;

  WinFile,
  SMes    :  String;

  WL      :  Integer;

  FileB   :  FileVar;

  DumLen,DumKeyNum  :  Integer;
  DumKey                 :  Str255;
  TmpCh                  :  Char;
  ShowAcc                :  String[2];

   DumRec                 :  Record
    LVer                  :  SmallInt;
    LRev                  :  SmallInt;
    LTyp                  :  Char;
    RVer                  :  SmallInt;
    RRev                  :  SmallInt;
    RTyp                  :  Char;
    SVer                  :  SmallInt;
    SRev                  :  SmallInt;
    STyp                  :  Char;
  end;

Begin
  WriteToOutput('',BOff);
  WriteToOutput('',BOff);

  FillChar(ConRec,Sizeof(ConRec),0);

  WriteToOutput('Btrieve database information',BOn);

  SetOutputStyle(osSubHeader);


  WinFile:=ExtractFileDir(ParamStr(0));

  With CompSysInfo^ do
  If (FileExists(PathToShort(SetDrive)+'\EXCHQSS.DAT')) then
  Begin

    Status:=Open_File(FileB,PathToShort(SetDrive)+'\EXCHQSS.DAT',0);

    HasCS:=BOff;


    If (Status<>0) then
    Begin
      SMes:='Unable to find the Btrieve engine due to reported error '+Form_Int(Status,0)+', '+Set_StatMes(Status);

      If (MUVal=1) then {*Its client server*}
      Begin



        If (Srv_IsNovell(SRVOSVal)) then
          ReadWriteFile(WinFile+'\CMP1Err.Txt',SMes)
        else
          ReadWriteFile(WinFile+'\CMP2Err.Txt',SMes);

        If (Not FileExists(PathToShort(SetDrive)+'\W32BTICM.DLL')) then
        Begin
          WriteToOutput('',BOff);

          WriteToOutput('The requester file W32BTICM.DLL is missing from the Exchequer Directory',BOn);

          SetOutputStyle(osWarning);
        end;




      end
      else
        ReadWriteFile(WinFile+'\CMP3Err.Txt',SMes)

    end
    else
    With RichEdit1 do
    Begin

      For n:=1 to 3 do
        With ConRec[n] do
          GetBtrvVer(FileB,Ver,Rel,Typ,n);

      With ConRec[3] do
        If (Typ=BCSType) or (Typ=BNTCSType) then
        Begin
          If (Typ=BCSType) then
            ServeMake:='Novell'
          else
            If (Typ=BNTCSType) then
              ServeMake:='Windows NT';


          WriteToOutput('Client Server connection on '+ServeMake,BOn);

          HasCS:=BOn;
        end
        else
        Begin

          If (MUVal=1) then
          Begin
            WL:=Length(RichEdit1.Text);

            WriteToOutput('Only a Local connection has been found.',BOff);
            WriteToOutput('Make sure the Interface section of Btrieve has Requester set to ON',BOff);
            WriteToOutput('You can verify this via the configuration option.',BOff);

            SelStart:=WL;
            SelLength:=(Length(Text)-WL)+1;

            SetOutputStyle(osWarning);

            WriteToOutput('',BOn);
          end
          else
            WriteToOutput('Local connection',BOn);

        end;

      SetOutputStyle(osInfo);


      If (Srv_IsNovell(SRVOSVal)) and (Not NovellBSPX(BOff,TRing,NovSrvPath))  and (MUVal=1) then
      Begin
        WriteToOutput('',BOff);

        If (NovSrvPath<>'') then
          WriteToOutput('The -r parameter is missing from BSTART.NCF. Use the Network option to set it.',BOn)
        else
          WriteToOutput('Please specify the path to BSTART.NCF via the configuration option, so it may be checked.',BOn);

        SetOutputStyle(osWarning);
      end;


      If (WS_IsNT(WSOSVal)) and (Srv_IsNT(SRVOSVal)) and (MUVal=1) then
      Begin
        If (IPXVirtualNo(BOff,WSOSVal,0)=0) then
        Begin
          ReadWriteFile(WinFile+'\CMP4Err.Txt','The IPX Internal Network Number is not Set.');
        end;

        If (IPXMaxPktSize(BOff,WSOSVal,0,NWADPKey)=0) and (IPXVirtualNo(BOff,WSOSVal,0)<>0) then
        Begin
          ReadWriteFile(WinFile+'\CMP5Err.Txt','The IPX Max Packet Size is not Set.');

        end;
      end;

      If (Not BTServer) then {* Compare Local Settings *}
      Begin
        For n:=Low(BTDefs) to High(BTDefs) do
        Begin
          If (MUVal=2) then
            RecBTVal:=BTSUDefs[n]
          else
            RecBTVal:=BTDefs[n];

          ActBTVal:=GetBTRegSettings(BOff,BOff,n,0);

          If (RecBTVal<>ActBTVal) then
          Begin
            WriteToOutput('The Btrieve setting '+BTRegKeys[n]+' ('+Form_Int(ActBTVal,0)+') does not match the recommended setting. ('+Form_Int(RecBTVal,0)+')',BOn);

            SetOutputStyle(osWarning);
          end;
        end; {Loop..}
      end;

      WL:=Length(RichEdit1.Text);

      WriteToOutput('Btrieve Engine versions:-',BOff);

      WriteToOutput('',BOff);

      With ConRec[1] do
        WriteToOutput('MKDB  :  '+#9+#9+IntToStr(Ver)+'.'+IntToStr(Rel)+Typ,BOff);

      If (MUVal=1) and (HasCS) then
      Begin
        With ConRec[2] do
          WriteToOutput('Requester  :  '+#9+#9+IntToStr(Ver)+'.'+IntToStr(Rel)+Typ,BOff);

        With ConRec[3] do
        Begin

          WriteToOutput('Server  :  '+#9+#9+IntToStr(Ver)+'.'+IntToStr(Rel)+Typ,BOff);

        end;
      end;

      GotoREEnd;

      SelStart:=WL;
      SelLength:=(Length(Text)-WL)+1;
      SetOutputStyle(osNormal);


      Close_File(FileB);
    end
  end
  else
    Begin
      WriteToOutput('',BOff);

      WriteToOutput('The path '+SetDrive+' does not contain an Exchequer system.',BOn);

      SetOutputStyle(osWarning);

    end;

end;

// -----------------------------------------------------------------------------

procedure TMainForm.CheckPervasive1Click(Sender: TObject);
begin
  ReportOnBtrieve;
end;

// -----------------------------------------------------------------------------

procedure TMainForm.FormActivate(Sender: TObject);
  {$IFDEF WCBuild}
    function LoginOK : boolean;
    begin
      with TfrmLogin.create(application) do begin
        try
          Result := ShowModal = mrOK;
        finally
          release;
        end;{try}
      end;{with}
    end;{LoginOK}
  {$ENDIF}
begin{FormActivate}
  If (Not BeenOn) then
  Begin
    BeenOn:=BOn;
    {$IFDEF WCBuild}
      if (not LoginOK) then SendMessage(Self.Handle,WM_Close,1,0);
    {$ELSE}
      If (RunPurge) then
      Begin
        OpenFile(ExtractFilePath(Application.EXEName)+'PURGEENT.RTF');
        SetFileName('Untitled');
        PageControl.ActivePage := InfoPage;
        if (edtInfo.CanFocus) then
          edtInfo.SetFocus;
        if (rPurgeMode = 2) then
        begin
          Mode := smPurgeOrders;
          Caption := 'Purge Orders - For ' + sAppName;
        end
        else if (rPurgeMode = 1) then
        begin
          Mode := smPurgeAccountsData;
          Caption := 'Purge Accounts Data - For ' + sAppName;
        end;
        UpdatePageDisplay;
      end
      else
    {$ENDIF}
  end;
end;

// -----------------------------------------------------------------------------

procedure TMainForm.ABortBM1Click(Sender: TObject);
begin
  MasterAborted:=BOn;
end;

// -----------------------------------------------------------------------------

procedure TMainForm.PurgeData;
var
  Ok2Cont  :  Boolean;
begin
  {$IFNDEF WCBuild}

    Ok2Cont:=Not WarnOnce;

    If (WarnOnce) then
      Ok2Cont:=Warn_Backup;


    WarnOnce:=Not Ok2Cont;

    If (Ok2Cont) then
    Begin
{$IFDEF EXSQL}
      if SQLUtils.UsingSQL then
        Ok2Cont := SQLUtils.ExclusiveAccess(SetDrive)
      else
{$ENDIF}
      Ok2Cont:=CheckFile_Open(JMiscF);

      If (Not Ok2Cont) then
{$IFDEF EXSQL}
        if SQLUtils.UsingSQL then
          ShowMessage('Some of the files are still open, due to users ' + #13 +
                      'remaining in the system. Ensure all users are '  + #13 +
                      'logged out of ' + sAppName + '.')
        else
{$ENDIF}
        ShowMessage('Some of the files are still open.'+#13+
                    'This is either due to users remaining in the system,'+#13+
                    'or a previous crash leaving the files open.'+#13+#13+
                    'Ensure all users are logged out of ' + sAppName + ', or'+#13+
                    'reset the P.SQL engine.');
    end;

    If (Ok2Cont) then
      Purge_Control(ProgBar)
  {$ENDIF}
end;

// -----------------------------------------------------------------------------

procedure TMainForm.CancelProcessing;
var
  DoCancel: Boolean;
begin
  if not IsProcessing then
    Close
  else
  begin
    DoCancel := True;
    if (Mode in [smPurgeOrders, smPurgeAccountsData]) then
    begin
      if MessageDlg('If you cancel the purge process you must restore your ' +
                    'data from back-up before using Exchequer again.' +
                    #13#10#13#10 +
                    'Are you sure you want to cancel?',
                    mtWarning, [mbYes, mbNo], 0) = mrNo then
        DoCancel := False;
    end;
    if DoCancel then
    begin
      ProgBar.Aborted := True;
      UpdatePageDisplay;
    end;
  end;
end;

// -----------------------------------------------------------------------------

procedure TMainForm.NextPage;
var
  Fn: TSpecialFunction;
  OldCursor: TCursor;
begin
  Fn := SelectedFunction;
  if (PageControl.ActivePage = SelectOptionPage) then
  begin
    DetermineMode;
    if Mode in SFReportSet then
      PageControl.ActivePage := ReportPage
    else if Mode = smSpecialFunctions then
      PageControl.ActivePage := SelectFunctionPage
    else if Mode = smRebuildDataFiles then
      PageControl.ActivePage := SelectFilesPage
    else if Mode = smPurgeOrders then
      PageControl.ActivePage := InfoPage
    else if Mode = smPurgeAccountsData then
      PageControl.ActivePage := InfoPage;
  end
  else if (PageControl.ActivePage = InfoPage) then
  begin
    if Mode = smPurgeOrders then
      PageControl.ActivePage := PurgeOrdersPage
    else if Mode = smPurgeAccountsData then
      PageControl.ActivePage := PurgeAccountsPage;
  end
  else if (PageControl.ActivePage = SelectFunctionPage) then
  begin
    if (Fn <> nil) and (Fn.Config.IsPassworded) then
      PageControl.ActivePage := PasswordPage
    else
      PageControl.ActivePage := ProcessPage;
  end
  else if (PageControl.ActivePage = PasswordPage) then
    PageControl.ActivePage := ProcessPage
  else if (PageControl.ActivePage = SelectFilesPage) then
    PageControl.ActivePage := ProcessPage
  else if (PageControl.ActivePage = PurgeOrdersPage) then
    PageControl.ActivePage := ProcessPage
  else if (PageControl.ActivePage = PurgeAccountsPage) then
    PageControl.ActivePage := ProcessPage
  else
    PageControl.ActivePage := ReportPage;
  UpdatePageDisplay;
  if (PageControl.ActivePage = ReportPage) then
  begin
    OldCursor := Screen.Cursor;
    Screen.Cursor := crHourGlass;
    try
      case Mode of
        smPervasiveFileInformation: PervasiveFileInformation;
        smBtrieveEngineInformation: ReportOnBtrieve;
        smSQLInformation:           SQLInformation;
        smConfigInformation:        ConfigInformation;
      end;
      GotoREEnd;
    finally
      Screen.Cursor := OldCursor;
    end;
  end;
end;

// -----------------------------------------------------------------------------

procedure TMainForm.PreviousPage;
begin
  if (PageControl.ActivePage = ReportPage) then
  begin
    if Mode in SFReportSet then
      PageControl.ActivePage := SelectOptionPage
    else if Mode = smSpecialFunctions then
      PageControl.ActivePage := SelectFunctionPage
    else if Mode = smRebuildDataFiles then
      PageControl.ActivePage := SelectFilesPage
    else if Mode = smPurgeOrders then
      PageControl.ActivePage := PurgeOrdersPage
    else if Mode = smPurgeAccountsData then
      PageControl.ActivePage := PurgeAccountsPage;
  end
  else if (PageControl.ActivePage = PasswordPage) then
  begin
    if Mode = smSpecialFunctions then
      PageControl.ActivePage := SelectFunctionPage
    else
      PageControl.ActivePage := SelectOptionPage;
  end
  else if (PageControl.ActivePage = ProcessPage) then
  begin
    if Mode = smSpecialFunctions then
      PageControl.ActivePage := SelectFunctionPage
    else if Mode = smRebuildDataFiles then
      PageControl.ActivePage := SelectFilesPage
    else if Mode = smPurgeOrders then
      PageControl.ActivePage := PurgeOrdersPage
    else if Mode = smPurgeAccountsData then
      PageControl.ActivePage := PurgeAccountsPage;
  end
  else if (PageControl.ActivePage = InfoPage) then
    PageControl.ActivePage := SelectOptionPage
  else if (PageControl.ActivePage = SelectFunctionPage) then
    PageControl.ActivePage := SelectOptionPage
  else if (PageControl.ActivePage = SelectFilesPage) then
    PageControl.ActivePage := SelectOptionPage
  else if (PageControl.ActivePage = PurgeOrdersPage) then
    PageControl.ActivePage := InfoPage
  else if (PageControl.ActivePage = PurgeAccountsPage) then
    PageControl.ActivePage := InfoPage;
  UpdatePageDisplay;
end;

// -----------------------------------------------------------------------------

procedure TMainForm.StartProcessing;
var
  Fn: TSpecialFunction;
  Params: TSFParams;
  Aborted: Boolean;
  PrevCursor: TCursor;
begin
  CancelBtn.Caption := '&Cancel';
  BackBtn.Enabled := False;
  NextBtn.Enabled := False;
  IsProcessing := True;
  Aborted := False;
  PrevCursor := Screen.Cursor;
  Screen.Cursor := crHourGlass;
  try
    PageTitleLbl.Caption := 'Processing. Please wait.';
    ReadyToProcessLbl.Caption := '';
    case Mode of
      smSpecialFunctions:
        begin
          Fn := SelectedFunction;
          Params := TSFParams.Create;
          Params.Mode             := Fn.Config.ID;
          Params.ProgressCallback := OnProgress;
          Params.OutputCallback   := OnOutput;
          try
            case Fn.Config.FunctionType of
              fnDLL, fnScript:
                begin
                  if not Fn.Execute(Params) then
                    Aborted := True;
                  NextPage;
                end;
              fnHardCoded:
                begin
                  Special_Function(Params.Mode, ProgBar);
                  NextPage;
                end;
            end;
          finally
            Params.Free;
          end;
        end;
      smRebuildDataFiles:
        begin
          RebuildDataFiles;
          NextPage;
        end;
      smPurgeOrders:
        begin
          SavePurgeOrderDetails;
          PurgeData;
          NextPage;
        end;
      smPurgeAccountsData:
        begin
          SavePurgeAccountsDetails;
          PurgeData;
          NextPage;
        end;
    end;
  finally
    if not Aborted then
      GotoREEnd;
    Screen.Cursor := PrevCursor;
    PageTitleLbl.Caption := 'Completed.';
    IsProcessing := False;
  end;
  UpdatePageDisplay;
  NextBtn.Enabled := False;
end;

// -----------------------------------------------------------------------------

procedure TMainForm.BackBtnClick(Sender: TObject);
begin
  PreviousPage;
end;

// -----------------------------------------------------------------------------

procedure TMainForm.NextBtnClick(Sender: TObject);
begin
  if (PageControl.ActivePage = ProcessPage) then
    StartProcessing
  else
    NextPage;
end;

// -----------------------------------------------------------------------------

procedure TMainForm.CancelBtnClick(Sender: TObject);
begin
  CancelProcessing;
end;

// -----------------------------------------------------------------------------

procedure TMainForm.FuncsListDblClick(Sender: TObject);
begin
  NextPage;
end;

// -----------------------------------------------------------------------------

procedure TMainForm.LaunchSpecialFunction(Params: TSFParams);
begin

end;

// -----------------------------------------------------------------------------

function TMainForm.OnProgress(MaxTotal, Position: Integer): Boolean;
begin
  ProgressBar.Max := MaxTotal;
  ProgressBar.Position := Position;
  Result := not ProgBar.Aborted;
end;

// -----------------------------------------------------------------------------

procedure TMainForm.FuncsListClick(Sender: TObject);
begin
  FUpdating := True;
  try
    edtFuncNo.Text := IntToStr(FuncsList.ItemIndex + 1);
    UpdateFunctionDisplay;
  finally
    FUpdating := False;
  end;
end;

// -----------------------------------------------------------------------------

procedure TMainForm.UpdatePageDisplay;
var
  i: Integer;
begin
  { Default settings }
  NextBtn.Caption := '&Next >';
  BackBtn.Enabled := True;
  CancelBtn.Caption := '&Close';
  SaveBtn.Visible := False;
  InfoLbl.Caption := '';
  if PAFilesAreOpen then
    ClosePurgeAccountsFiles;
  { Override default settings based on the currently selected page }
  if (PageControl.ActivePage = SelectOptionPage) then
  begin
    PageTitleLbl.Caption := 'Select option';
    { First page -- cannot go Back from here }
    BackBtn.Enabled := False;
    NextBtn.Enabled := True;
  end
  else if (PageControl.ActivePage = SelectFunctionPage) then
  begin
    PageTitleLbl.Caption := 'Select special function';
    NextBtn.Enabled := True;
  end
  else if (PageControl.ActivePage = SelectFilesPage) then
  begin
    PageTitleLbl.Caption := 'Select files to rebuild';
    { Only enable the Next button on the files page if the user has
      actually selected some files }
    NextBtn.Enabled := (SelectedFileCount > 0);
  end
  else if (PageControl.ActivePage = InfoPage) then
  begin
    PageTitleLbl.Caption := 'Please read carefully';
    if (RunPurge) then
      BackBtn.Enabled := False;
    NextBtn.Enabled := True;
  end
  else if (PageControl.ActivePage = PurgeAccountsPage) then
  begin
    PageTitleLbl.Caption := 'Purge Accounts';
    OpenPurgeAccountsFiles;
  end
  else if (PageControl.ActivePage = PurgeOrdersPage) then
  begin
    PageTitleLbl.Caption := 'Purge Orders';
    LoadPurgeOrderDetails;
  end
  else if (PageControl.ActivePage = PasswordPage) then
  begin
    NextBtn.Enabled := False;
    PasswordGenerator.ID := SelectedFunction.Config.ID;
    lblChallenge.Caption := PasswordGenerator.Challenge;
    lblPhonetic.Caption  := '(' + Phonetic.StringToPhonetic(PasswordGenerator.Challenge) + ')';
    lblDebugResponse.Caption := PasswordGenerator.Response;
    PageTitleLbl.Caption := 'Password required';
    edtResponse.SetFocus;
  end
  else if (PageControl.ActivePage = ProcessPage) then
  begin
    case Mode of
      smSpecialFunctions:
        begin
          if SelectedFunction.Config.ID = 122 then
            ProgBar.ProgressBar1.Visible := False
          else
            ProgBar.ProgressBar1.Visible := True;
          PageTitleLbl.Caption := 'Ready to process special function';
          if (FuncsPageControl.ActivePage = FuncsPage) then
            FunctionLbl.Caption := FuncsList.Items[FuncsList.ItemIndex]
          else
            FunctionLbl.Caption := CustomFuncsList.Items[CustomFuncsList.ItemIndex];
          ReadyToProcessLbl.Caption := 'Click the start button to apply the special function';
        end;
      smRebuildDataFiles:
        begin
          PageTitleLbl.Caption := 'Ready to rebuild data files';
          FunctionLbl.Caption := 'Rebuild data files';
          for i := 0 to FileList.Count - 1 do
            if FileList.Checked[i] then
              InfoLbl.Caption := InfoLbl.Caption + FileList.Items[i] + #13#10;
          ReadyToProcessLbl.Caption := 'Click the start button to rebuild the data files';
        end;
      smPurgeOrders:
        begin
          PageTitleLbl.Caption := 'Ready to purge orders';
          FunctionLbl.Caption := 'Purge orders';
          InfoLbl.Caption :=
            'You are about to start a Purge process which will permanently destroy ' +
            'the selected data.' + #13#10#13#10 +
            'If you do not have a backup of your Exchequer system, please click ' +
            'the "Back" button and cancel this process.';
          ReadyToProcessLbl.Caption := 'Click the start button to purge';
        end;
      smPurgeAccountsData:
        begin
          PageTitleLbl.Caption := 'Ready to purge all accounts data';
          FunctionLbl.Caption := 'Purge accounts data';
          InfoLbl.Caption :=
            'You are about to start a Purge process which will permanently destroy ' +
            'the selected data.' + #13#10#13#10 +
            'If you do not have a backup of your Exchequer system, please click ' +
            'the "Back" button and cancel this process.';
          ReadyToProcessLbl.Caption := 'Click the start button to purge';
        end;
      smPervasiveFileInformation:
        begin
          PageTitleLbl.Caption := 'Pervasive File information';
          FunctionLbl.Caption := '';
          ReadyToProcessLbl.Caption := '';
        end;
      smBtrieveEngineInformation:
        begin
          PageTitleLbl.Caption := 'Btrieve Engine information';
          FunctionLbl.Caption := '';
          ReadyToProcessLbl.Caption := '';
        end;
      smSQLInformation:
        begin
          PageTitleLbl.Caption := 'MS SQL Server information';
          FunctionLbl.Caption := '';
          ReadyToProcessLbl.Caption := '';
        end;
    end;
    { Last page. Change Next to Start }
    NextBtn.Caption := '&Start';
    NextBtn.Enabled := True;
  end
  else if (PageControl.ActivePage = ReportPage) then
  begin
    PageTitleLbl.Caption := 'Report';
    FunctionLbl.Caption := '';
    NextBtn.Caption := 'Done';
    NextBtn.Enabled := False;
    BackBtn.Enabled := True;
    SaveBtn.Visible := True;
  end;
end;

// -----------------------------------------------------------------------------

procedure TMainForm.PervasiveFileInformation;
var
  n,fv,Lowv  :  SmallInt;
  ThisVer    :  Integer;

  function Txlate_FVer: Byte;
  begin
    case ThisVer of
      $50..$59  :  Result:=5;
      $60..$69  :  Result:=6;
      $70..$79  :  Result:=7;
      $80..$89  :  Result:=8;
      $90..$99  :  Result:=9;
    else
      Result:=0;
    end;
  end;

begin
  Lowv:=255;

  For n:=1 to TotFiles do
    FixFile[n].Rebuild:=BOn;

  Open_RepairFiles(1,TotFiles,BOff,BOn,Nil);

  Try
    Write_FixMsgFmt('Pervasive P.SQL ' + sAppName + ' file version check.', 2);

    For n:=1 to TotFiles do
    If FixFile[n].Rebuild then
    Begin
      ThisVer:=File_VerCId(F[n],n,Nil);

      fv:=Txlate_FVer;

      If (fv<Lowv) then
        Lowv:=fv;

      If (fv>=6) then
        Write_FixMsgFmt(SetDrive+Filenames[n]+': v'+IntToStr(fv)+' format: OK',3)
      else
        If (fv=5) then
          Write_FixMsgFmt(SetDrive+Filenames[n]+': v'+IntToStr(fv)+' format. This file should be rebuilt to v6 format.',3)
        else
          Write_FixMsgFmt(setDrive+Filenames[n]+' Pre v5 data format, this file must be rebuilt before using Exchequer.',4);

      FixFile[n].Rebuild:=BOff;

    end;

    if (Lowv<6) then
    begin
      Write_FixMsgFmt('One or more of the files has been in created in a format which will prevent protected mode posting',4);
      Write_FixMsgFmt('Rebuild these files before using Exchequer',4);
    end;

  finally

    Close_Files(BOn);

  end;

end;

// -----------------------------------------------------------------------------

function TMainForm.SelectedFileCount: Integer;
var
  i: Integer;
begin
  Result := 0;
  for i := 0 to FileList.Count - 1 do
    if FileList.Checked[i] then
      Result := Result + 1;
end;

// -----------------------------------------------------------------------------

procedure TMainForm.FileListClick(Sender: TObject);
begin
  NextBtn.Enabled := (SelectedFileCount > 0);
end;

// -----------------------------------------------------------------------------

procedure TMainForm.SetOutputStyle(Style: TOutputStyle);
begin
  case Style of
    osHeader:    SetOutputEffect(12, clBlack, [fsBold, fsUnderline], taLeftJustify);
    osSubHeader: SetOutputEffect(10, clBlack, [fsBold, fsItalic, fsUnderline], taLeftJustify);
    osCopyright: SetOutputEffect( 8, clBlack, [fsItalic], taLeftJustify);
    osInfo:      SetOutputEffect( 8, clBlue,  [], taLeftJustify);
    osWarning:   SetOutputEffect( 8, clRed,   [], taLeftJustify);
    osList:      SetOutputEffect(10, clBlack, [fsBold], taLeftJustify);
  else
    // rsNormal style
    SetOutputEffect( 8, clBlack, [], taLeftJustify);
  end;
end;

// -----------------------------------------------------------------------------

procedure TMainForm.LoadPurgeOrderDetails;
begin
  with Purge_OrdRec^ do
  begin
    edtPOYear.InitPeriod(PurgePr,PurgeYr,BOn,BOn);
    edtPOIncludeAcct.Text   := IncCust;
    edtPOExcludeAcct.Text   := ExcCust;
    edtPOIncludeType.Text   := IncType;
    edtPOExcludeType.Text   := ExcType;
{$IFDEF EXSQL}
    if SQLUtils.UsingSQL then
      POShrinkChk.Checked := BOff
    else
{$ENDIF}
    POShrinkChk.Checked := BOn;
    OrderMode           := BOn;
  end;
end;

// -----------------------------------------------------------------------------

procedure TMainForm.SavePurgeOrderDetails;
begin
  with Purge_OrdRec^ do
  begin
    edtPOYear.InitPeriod(PurgePr, PurgeYr, BOff, BOff);

    if (Trim(edtPOIncludeAcct.Text) <> '') then
      IncCust := FullCustCode(edtPOIncludeAcct.Text)
    else
      IncCust := '';

    if (Trim(edtPOExcludeAcct.Text)<>'') then
      ExcCust := FullCustCode(edtPOExcludeAcct.Text)
    else
      ExcCust := '';

    IncType   := edtPOIncludeType.Text;
    ExcType   := edtPOExcludeType.Text;
    RunRBuild := POShrinkChk.Checked;
  end;
end;

// -----------------------------------------------------------------------------

procedure TMainForm.edtPOIncludeAcctExit(Sender: TObject);
var
  FoundCode  :  Str20;
  KeyS       :  Str255;
  FoundOk,
  AltMod     :  Boolean;
begin
  if (Sender is Text8pt) then
    with (Sender as Text8pt) do
    begin
      FoundCode := Name;
      AltMod    := Modified;
      FoundCode := Trim(Text);

      if (AltMod) and (ActiveControl <> CancelBtn)  and (FoundCode<>'') then
      begin

        FixFile[CustF].Rebuild := BOn;

        Open_RepairFiles(CustF, CustF, BOn, BOff, ProgBar); {* Open all files and check for a Rebuild header *}

        StillEdit:=BOn;

        KeyS := UpperCase(FullCustCode(FoundCode));

        Status := Find_Rec(B_GetEq,F[CustF],CustF,RecPtr[CustF]^,0,KeyS);

        FoundOk := StatusOk;

        Close_Files(BOn);

        FixFile[CustF].Rebuild:=BOff;

        if (FoundOk) then
        begin

          StillEdit:=BOff;

          Text := Cust.CustCode;

        end
        else
        begin
          ShowMessage(FoundCode+' is not a valid account code. Please re-enter the complete code.');
          SetFocus;
        end;
      end;

    end; {with..}
end;

// -----------------------------------------------------------------------------

procedure TMainForm.ClosePurgeAccountsFiles;
begin
  Close_Files(BOn);
  FixFile[SysF].Rebuild := BOff;
  PAFilesAreOpen := False;
end;

// -----------------------------------------------------------------------------

procedure TMainForm.LoadPurgeAccountsDetails;
var
  SuggYear: Word;
begin
  with Purge_OrdRec^ do
  begin
    { CJS 2012-10-30 - ABSEXCH-13639 - Audit Date and Purge Year }
    SuggYear := PurgeYear + 1;
    edtPAYear.Text := IntToStr(ConvTxYrVal(SuggYear, False));
    PAYearSpin.Position := StrToInt(edtPAYear.Text);
    PARemoveCustomersChk.Checked := DelCust;
    PARemoveSuppliersChk.Checked := DelSupp;
    PARemoveStockChk.Checked     := DelStk;
    PARemoveLocationsChk.Checked := DelML;
    PARemoveSerialChk.Checked    := DelSN;
{$IFDEF EXSQL}
    if SQLUtils.UsingSQL then
      PAShrinkChk.Checked        := BOff
    else
{$ENDIF}
    PAShrinkChk.Checked          := BOn;
  end; {With..}
end;

// -----------------------------------------------------------------------------

procedure TMainForm.OpenPurgeAccountsFiles;
var
  n      : Integer;
  SLocked: Boolean;
begin
  SLocked := BOff;

  FixFile[SysF].Rebuild := BOn;

  Open_RepairFiles(SysF, SysF, BOn, BOff, ProgBar); {* Open all files and check for a Rebuild header *}

  GetMultiSys(BOn, SLocked, SysR);

  LoadPurgeAccountsDetails;

  PAFilesAreOpen := True;
end;

// -----------------------------------------------------------------------------

procedure TMainForm.SavePurgeAccountsDetails;
begin
  with Purge_OrdRec^ do
  begin
    PurgeYr := TxlateYrVal(StrToInt(edtPAYear.Text), BOn);
    DelCust := PARemoveCustomersChk.Checked;
    DelSupp := PARemoveSuppliersChk.Checked;
    DelStk  := PARemoveStockChk.Checked;
    DelML   := PARemoveLocationsChk.Checked;
    DelSN   := PARemoveSerialChk.Checked;

    RunRBuild := PAShrinkChk.Checked;
  end; {With..}
end;

// -----------------------------------------------------------------------------

procedure TMainForm.ValidatePurgeAccountsYear(ShowMessage: Boolean);
var
  Yr: Integer;
  MaxYr: Integer;
  LastPurgeYr, MaxPurgeYr, SelectedPurgeYr: Integer;
  d, m, y: Word;
begin
  { You can only purge up to the end of the year before the previous year,
    so subtract two years from the current year to get the maximum year that
    can be purged to. }
  MaxPurgeYr := AdjYr(Syss.CYr, BOff);
  MaxPurgeYr := AdjYr(MaxPurgeYr, BOff);

  { Convert to a full 4-digit year. }
  MaxPurgeYr := ConvTxYrVal(MaxPurgeYr, False);

  { Get the last purge year. Convert it to a full 4-digit year. }
  LastPurgeYr := ConvTxYrVal(PurgeYear, False);

  { Get the selected year from the edit box. If no year has been entered yet,
    default it to a year before LastPurgeYr, so that an error message will be
    displayed showing the available year range. }
  if (Trim(edtPAYear.Text) <> '') then
    SelectedPurgeYr := StrToInt(Trim(edtPAYear.Text))
  else
    SelectedPurgeYr := LastPurgeYr - 1;

  { Get the year of the last Audit Date }
  { CJS 2012-10-30 - ABSEXCH-13639 - Audit Date and Purge Year - Removed change
                     to LastPurgeYr based on AuditDate }
  DateStr(Syss.AuditDate, d, m, y);

  { Check for a valid purge year. }
  if (SelectedPurgeYr > y) then
  begin
    PAErrorTxt.Caption :=
      'The purge year must be before the last audit year of ' + POutDate(Syss.AuditDate);
    NextBtn.Enabled := False;
  end
  else if not ((SelectedPurgeYr > LastPurgeYr) and (SelectedPurgeYr <= MaxPurgeYr)) then
  begin
    PAErrorTxt.Caption :=
      'The purge year must be after the last purge year of ' + IntToStr(LastPurgeYr) +
      ' and before ' + IntToStr(MaxPurgeYr + 1);
    NextBtn.Enabled := False;
  end
  else
  begin
    PAErrorTxt.Caption := '';
    NextBtn.Enabled := True;
  end;
end;

// -----------------------------------------------------------------------------

procedure TMainForm.edtPAYearExit(Sender: TObject);
begin
  ValidatePurgeAccountsYear(True);
end;

// -----------------------------------------------------------------------------

procedure TMainForm.edtPAYearChange(Sender: TObject);
begin
  ValidatePurgeAccountsYear(False);
end;

// -----------------------------------------------------------------------------

procedure TMainForm.SQLInformation;
begin
  { TODO: SQLInformation }
end;

// -----------------------------------------------------------------------------

procedure TMainForm.OnOutput(OutputMsg: ShortString; Style: TOutputStyle);
begin
  WriteToOutput(OutputMsg, BOn);
  if (Style <> osNormal) then
    SetOutputStyle(Style);
end;

// -----------------------------------------------------------------------------

procedure TMainForm.FuncsListDrawItem(Control: TWinControl; Index: Integer;
  Rect: TRect; State: TOwnerDrawState);
var
  Fn: TSpecialFunction;
	Offset: Integer;
begin
	with (Control as TListBox).Canvas do
	begin
  	FillRect(Rect);
	  Offset := 2;
    Fn := TSpecialFunction((Control as TListBox).Items.Objects[Index]);
    if (Fn <> nil) and (Fn.HasExpired) then
    begin
      Font.Color := clGrayText;
    end;
  	TextOut(Rect.Left + Offset, Rect.Top, (Control as TListBox).Items[Index])
	end;
end;

// -----------------------------------------------------------------------------

procedure TMainForm.edtFuncNoChange(Sender: TObject);
var
  FuncNo: Integer;
  List: TListBox;
  Fn: TSpecialFunction;
  i: Integer;
begin
  if not FUpdating then
  begin
    FuncNo := StrToIntDef(edtFuncNo.Text, 0);
    if (FuncsPageControl.ActivePage = FuncsPage) then
      List := FuncsList
    else
      List := CustomFuncsList;
    for i := 0 to List.Count - 1 do
    begin
      Fn := TSpecialFunction(List.Items.Objects[i]);
      if (Fn <> nil) and (Fn.Config.ID = FuncNo) then
      begin
        List.ItemIndex := i;
        UpdateFunctionDisplay;
        Break;
      end;
    end;
  end;
end;

// -----------------------------------------------------------------------------

procedure TMainForm.UpdateFunctionDisplay;
var
  Fn: TSpecialFunction;
  FuncNo: Integer;
  List: TListBox;
begin
  FUpdating := True;
  try
    FunctionMsgLbl.Caption := '';
    NextBtn.Enabled := False;
    Fn := SelectedFunction;
    if (Fn <> nil) then
    begin
      edtFuncNo.Text := IntToStr(Fn.Config.ID);
      if (Fn.HasExpired) then
        FunctionMsgLbl.Caption := 'Expired';
      NextBtn.Enabled := True;
    end;
  finally
    FUpdating := False;
  end;
end;

// -----------------------------------------------------------------------------

procedure TMainForm.FuncsPageControlChange(Sender: TObject);
begin
  UpdateFunctionDisplay;
end;

// -----------------------------------------------------------------------------

function TMainForm.SelectedFunction: TSpecialFunction;
var
  List: TListBox;
begin
  Result := nil;
  if (FuncsPageControl.ActivePage = FuncsPage) then
    List := FuncsList
  else
    List := CustomFuncsList;
  if (List.ItemIndex > -1) then
    Result := TSpecialFunction(List.Items.Objects[List.ItemIndex]);
end;

// -----------------------------------------------------------------------------

procedure TMainForm.SaveBtnClick(Sender: TObject);
begin
  if (SaveDialog.FileName = '') then
    SaveDialog.FileName := 'SpecialFunctionLog_' + FormatDateTime('yyyy-nn-dd', Now);
  FileSave(Sender);
end;

// -----------------------------------------------------------------------------

procedure TMainForm.edtResponseChange(Sender: TObject);
begin
  NextBtn.Enabled := (edtResponse.Text = PasswordGenerator.Response);
end;

// -----------------------------------------------------------------------------

procedure TMainForm.AllFilesBtnClick(Sender: TObject);
var
  i: Integer;
begin
  for i := 0 to FileList.Items.Count - 1 do
    FileList.Checked[i] := True;
  NextBtn.Enabled := True;
end;

// -----------------------------------------------------------------------------

procedure TMainForm.NoFilesBtnClick(Sender: TObject);
var
  i: Integer;
begin
  for i := 0 to FileList.Items.Count - 1 do
    FileList.Checked[i] := False;
  NextBtn.Enabled := False;
end;

// -----------------------------------------------------------------------------

procedure TMainForm.DetermineMode;
var
  Option: string;
begin
  if (OptionGroup.ItemIndex > -1) then
    Option := OptionGroup.Items[OptionGroup.ItemIndex]
  else
    Option := '';

  if (Option = OPT_FUNCTIONS) then
    Mode := smSpecialFunctions
  else if (Option = OPT_REBUILD) then
    Mode := smRebuildDataFiles
  else if (Option = OPT_PURGE_ORDERS) then
    Mode := smPurgeOrders
  else if (Option = OPT_PURGE_ACCOUNTS) then
    Mode := smPurgeAccountsData
  else if (Option = OPT_PERVASIVE_REPORT) then
    Mode := smPervasiveFileInformation
  else if (Option = OPT_BTRIEVE_REPORT) then
    Mode := smBtrieveEngineInformation
  else if (Option = OPT_SQL_REPORT) then
    Mode := smSQLInformation
  else if (Option = OPT_CONFIG_REPORT) then
    Mode := smConfigInformation
  else
    Mode := smNotSet;

end;

// -----------------------------------------------------------------------------

function TMainForm.PurgeYear: Integer;
{ Returns the 'compact' form of the last purge year. }
begin
  Result := Syss.AuditYr; // Syss.AuditYr is actually Purge Year (!)
  if (Result < 50) then
  begin
    Result := 80;
(*
    { You can only purge up to the end of the year before the previous year,
      so subtract two years from the current year to get the default purge
      year. }
    Result := AdjYr(Syss.CYr, BOff);
    Result := AdjYr(Result, BOff);
*)
  end;
end;

// -----------------------------------------------------------------------------

end.

