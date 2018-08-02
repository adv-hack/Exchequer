unit testmain;

{ prutherford440 09:55 04/12/2001: Disabled Byte Alignment in Delphi 6.0 }
{$ALIGN 1}  { Variable Alignment Disabled }


interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  SETUPBAS, StdCtrls, BorBtns, ComCtrls, ExtCtrls, Grids, ImgList, TestCons,
  TestIni, Buttons, TestTk, testTk04, TestSys, TestLog, StrUtils, Menus, ShellAPI;

const
  DefaultTests = 8;


type

  TfrmComTestForm = class(TSetupTemplate)
    PageControl1: TPageControl;
    tabDiag: TTabSheet;
    tabConfig: TTabSheet;
    Panel2: TPanel;
    InfoLabel: TLabel;
    lvConfig: TListView;
    ImageList1: TImageList;
    ComboBox1: TComboBox;
    Edit1: TEdit;
    Edit2: TEdit;
    BitBtn1: TBitBtn;
    memDiag: TRichEdit;
    Panel3: TPanel;
    Button1: TButton;
    Button2: TButton;
    OpenDialog1: TOpenDialog;
    SaveDialog1: TSaveDialog;
    Button3: TButton;
    ProgressBar1: TProgressBar;
    Label1: TLabel;
    SaveDialog2: TSaveDialog;
    chkValidate: TCheckBox;
    Label2: TLabel;
    Panel4: TPanel;
    NextBtn2: TButton;
    BackBtn2: TButton;
    PopupMenu1: TPopupMenu;
    mnuOptSetupBtrvSQLTKFile: TMenuItem;
    procedure FormCreate(Sender: TObject);
    procedure lvConfigMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure FormDestroy(Sender: TObject);
    procedure ComboBox1Exit(Sender: TObject);
    procedure Edit1Exit(Sender: TObject);
    procedure Edit2Exit(Sender: TObject);
    procedure lvConfigCustomDraw(Sender: TCustomListView;
      const ARect: TRect; var DefaultDraw: Boolean);
    procedure BitBtn1Click(Sender: TObject);
    procedure lvConfigKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure FormActivate(Sender: TObject);
    procedure NextBtnClick(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure BackBtnClick(Sender: TObject);
    procedure PageControl1Change(Sender: TObject);
    procedure chkValidateClick(Sender: TObject);
    procedure Image1DblClick(Sender: TObject);
    procedure Button4Click(Sender: TObject);
    procedure mnuOptSetupBtrvSQLTKFileClick(Sender: TObject);
  private
    { Private declarations }
    FConfigChanged : Boolean;
    FIniFile : TDllIni;
    CurrentItem : TListItem;
    OldTop : integer;
    EditShowing : Boolean;
    FirstTime : Boolean;
    FTestTk : TTestToolkit;
    FTestExeTk : TTestExeToolkit;
    FSysTest : TSystemTest;
    FTestLog : TRichLog;
    FProgressStep, FProgressCount : Double;
    FUseProgressStep : Boolean;
    EntDir : string;
    ActiveCanExit : Boolean;
    WasSelected : TListItem;
    Testing : Boolean;
    //Config functions
    procedure UpdateCaption;
    procedure ShowBranch(const TheItem : TListItem);
    procedure HideBranch(const TheItem : TListItem);
    procedure ShowEditor(TheItem : TListItem);
    procedure ShowDropDown(TheItem : TListItem; Which : Byte);
    procedure ShowEdit(TheItem : TListItem);
    procedure ShowPathEdit(TheItem : TListItem);
    procedure ShowEditor2(TheItem : TListItem);
    function FindListIndex(TheItem : TListItem) : integer;
    procedure SetConfigChanged(Value : Boolean);
    //Diagnostic functions
    procedure StartTKTests;
    procedure AdvancedTests;
    procedure StartProgress(NumberOfTests, NumberOfCompanies : integer);
    procedure Progress;
    procedure EndProgress(const Msg : string);
    procedure RunTests;
    procedure RunAdvancedTests;
    function FindPath : string;
    function ValidEntDir(const s : string) : Boolean;
    procedure ValidateControlExit(Sender : TWinControl; var ExitText : String);
    procedure InitComboBox(WhichList : Byte); //0 = Boolean, 1 = Vat codes
    procedure ShowAllBranches;

    Procedure AddCompanyUNCDetails (Const coCode, coName, coDrivePath, coUNCPath : ANSIString; Const FlagFileFound : Boolean);
  public
    { Public declarations }
    property ConfigChanged : Boolean read FConfigChanged write SetConfigChanged;
  end;

var
  frmComTestForm: TfrmComTestForm;

implementation

{$R *.DFM}

uses
  ShlObj, FileCtrl, FileUtil, UNCCache;

//------------------------------------------------------------------------------------
//   Form functions
//------------------------------------------------------------------------------------


procedure TfrmComTestForm.UpdateCaption;
begin
  Caption := FIniFile.Filename + ' - ' +
       'Exchequer COM Toolkit Diagnostic & Configuration Utility';
end;


procedure TfrmComTestForm.FormCreate(Sender: TObject);
var
  CTKError : Boolean;
begin
  inherited;
  CTKError := False;
  Label2.Caption := TestCOMVersion;
  ActiveCanExit := True;
  Testing := False;
  Screen.Cursor := crHourGlass;

  FTestLog := nil;
  FTestTk := nil;
  FSysTest := nil;
  FINiFile := nil;

  //Logging object
  FTestLog := TRichLog.Create(Self);
  FTestLog.RichEdit := memDiag;

  memDiag.Paragraph.Alignment := taCenter;
  FTestLog.ReportBoldU('Exchequer COM Toolkit Diagnostics');
  FTestLog.Line;
  memDiag.Paragraph.Alignment := taLeftJustify;



  //Toolkit testing object
  Try
    FTestTk := TTestToolkit.Create;

    FTestLog.Report(' Toolkit version (DLL):               ' + FTestTk.ToolkitVersion);

  Except
    on E: Exception do
    begin
      FTestLog.ReportError('Create Toolkit failed with error: ' + #13+ '   ' +
                           QuotedStr(E.Message));
      if FTestTk.ErrorString <> '' then
        FTestLog.ReportError(FTestTk.ErrorString);
      CTKError := True;
    end;
  End;

  Try
    FTestExeTk := TTestExeToolkit.Create;

    FTestLog.Report(' Toolkit version (Exe):               ' + FTestExeTk.ToolkitVersion);

  Except
    on E: Exception do
    begin
      FTestLog.ReportError('Create Toolkit failed with error: ' + #13+ '   ' +
                           QuotedStr(E.Message));
      if FTestTk.ErrorString <> '' then
        FTestLog.ReportError(FTestTk.ErrorString);
      CTKError := True;
    end;
  End;

  Try
    FTestTk.InitFormTk;
    FTestLog.Report(' Form Printing Toolkit version:       ' + FTestTk.PrintToolkitVersion);
    if FTestTk.ErrorString <> '' then
      FTestLog.ReportError(FTestTk.ErrorString);

  Except
    on E: Exception do
    begin
      FTestLog.ReportError('Create Printing Toolkit failed with error: ' + #13+ '   ' +
                           QuotedStr(E.Message));
    end;
  End;
  FTestLog.Report(' TestCom version:                     ' + TestCOMVersion);

  if CTKError then
    if Assigned(FTestTk) then
      FreeAndNil(FTestTk);

  if Assigned(FTestTk) then
    FTestTk.Report := FTestLog;

  EntDir := FindPath;
  FTestLog.DetailsLog := EntDir + DetailLogFileName;

  //System test object
  FSysTest := TSystemTest.Create;
  FSysTest.RichLog := FTestLog;
  FSysTest.SysFilePath := EntDir;

  //Object to deal with ExchDll.ini
  FIniFile := TDllIni.Create;
  FIniFile.FileName := EntDir + 'ExchDll.ini';

  FirstTime := True;
  PageControl1.ActivePage := tabDiag;
  NextBtn2.Caption := '&Continue';


  //Look for ini file in application directory.  If not found look in
  //com toolkit path
  if not FIniFile.Load then
  begin
    if Assigned(FSysTest) then
    begin
      FIniFile.FileName := FSysTest.ToolkitDir + 'ExchDll.ini';
      if not FIniFile.Load then
        FIniFile.Filename := ''
    end
  end;

  if FIniFile.FileName <> '' then
    if Assigned(FTestTk) then
      FTestTk.DataPath := FIniFile.ReadIniValue('Exchequer_Path');

  UpdateCaption;

  //Set top level branches for config tree
  with lvConfig.Items.Add do
  begin
    Caption := 'Paths';
    ImageIndex := 0;
    Data := Pointer(0);
  end;

  with lvConfig.Items.Add do
  begin
    Caption := 'Switches';
    ImageIndex := 0;
    Data := Pointer(1);
  end;

  with lvConfig.Items.Add do
  begin
    Caption := 'Defaults';
    ImageIndex := 0;
    Data := Pointer(2);
  end;

  ConfigChanged := False;

  ShowAllBranches;
end;

procedure TfrmComTestForm.FormDestroy(Sender: TObject);
begin
  inherited;
  if Assigned(FIniFile) then
    FIniFile.Free;

  if Assigned(FSysTest) then
    FSysTest.Free;

  if Assigned(FTestLog) then
    FTestLog.Free;

  if Assigned(FTestExeTk) then
    FTestTk.Free;

  if Assigned(FTestExeTk) then
    FTestExeTk.Free;

end;

procedure TfrmComTestForm.PageControl1Change(Sender: TObject);
begin
  if Testing then
    PageControl1.ActivePage := tabDiag
  else
  begin
    if PageControl1.ActivePage = tabDiag then
    begin
      TitleLbl.Caption := 'Diagnostics';
    end
    else
    begin
      TitleLbl.Caption := 'Configuration';
    end;
  end;
end;



//------------------------------------------------------------------------------------
//   Config functions
//------------------------------------------------------------------------------------


procedure TfrmComTestForm.lvConfigMouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
var
  TheItem : TListItem;
begin
  if FIniFile.FileName = '' then
    EXIT;

  if Button = mbLeft then
   with lvConfig do
   begin

   if ActiveCanExit then
   begin
     TheItem := GetItemAt(X,Y);
     if TheItem <> nil then
     begin
       if htOnIcon in GetHitTestInfoAt(X,Y) then
       begin
         if TheItem.ImageIndex = 0 then
           ShowBranch(TheItem)
         else
         if TheItem.ImageIndex = 1 then
           HideBranch(TheItem);
       end;
       CurrentItem := TheItem;

     end
     else
     begin
       if (X > Columns[0].Width + 1) and (x < Columns[0].Width + Columns[1].Width) then
       begin
         TheItem := GetItemAt((2 * SmallImages.Width ) + 10, Y);
         if (Assigned(TheItem)) and (TheItem.SubItems.Count > 0) then
         begin
           CurrentItem := TheItem;
           ShowEditor(TheItem);
         end
       end
       else
       if (X > Columns[0].Width + Columns[1].Width + 1) and
          (x < Columns[0].Width + Columns[1].Width + Columns[2].Width) then
       begin
         TheItem := GetItemAt((2 * SmallImages.Width ) + 10, Y);
         if Assigned(TheItem) and (TheItem.SubItems.Count > 1) then
           begin
             CurrentItem := TheItem;
             ShowEditor2(TheItem);
           end;
       end;


     end;
     if Assigned(TheItem) then
     begin
       InfoLabel.Caption := HelpString(FindListIndex(TheItem));
       lvConfig.Selected := TheItem;
     end;

   end;{if ActiveCanExit}
  end; {with lvConfig}
end;

procedure TfrmComTestForm.ShowBranch(const TheItem : TListItem);
var
  i : integer;
  s, s1, s2 : string;

  procedure SplitLine(const s : string; var st1, st2 : string);
  var
    j : integer;
  begin
    j := Pos(' ', s);
    st1 := Copy(s, 1, j-1);
    st2 := Trim(Copy(s, j, Length(s)));
  end;

begin
  for i := MaxConfigItems downto 1 do
    if FIniFile.ConfigItems[i].Parent = Integer(TheItem.Data) then
      with lvConfig.Items.Insert(TheItem.Index + 1) do
      begin
        Caption := FIniFile.ConfigItems[i].Name;
        Indent := TheItem.Indent + 1;
        ImageIndex := -1;
        s := FIniFile.ConfigItems[i].Value;
        if FIniFile.ConfigItems[i].ValType <> 5 then
          SubItems.Add(s)
        else
        begin
          SplitLine(FIniFile.ConfigItems[i].Value, s1, s2);
          SubItems.Add(s1);
          SubItems.Add(s2);
        end;
        Data := Pointer(FIniFile.ConfigItems[i].ValType);

      end;

  TheItem.ImageIndex := 1;
end;

procedure TfrmComTestForm.HideBranch(const TheItem : TListItem);
var
  i : integer;
begin
  i := TheItem.Index + 1;

  while (lvConfig.Items.Item[i] <> nil) and (lvConfig.Items.Item[i].Indent > TheItem.Indent) do
  begin
    lvConfig.Items.Delete(i);
  end;
  TheItem.ImageIndex := 0;
end;

procedure TfrmComTestForm.ShowEditor(TheItem : TListItem);
var
  ValueType : Byte;
begin
  if Assigned(TheItem) then
  begin
    ValueType := Byte(TheItem.Data);
    Case ValueType of
      0, 5, 6    :  ShowDropDown(TheItem, ValueType);
      1,2,4   :  ShowEdit(TheItem);
      3       :  ShowPathEdit(TheItem);
    end;
  end;
end;

procedure TfrmComTestForm.ShowDropDown(TheItem : TListItem; Which : Byte);
var
  i : integer;
begin
  InitComboBox(Which);

  with ComboBox1  do
  begin

    Left   := lvConfig.Columns[0].Width + 1;
    Width  := lvConfig.Columns[1].Width + 1;

    Top := (TheItem.Index - lvConfig.TopItem.Index) * 17 + 16;

    if TheItem.Caption = 'Multi_Currency' then
    begin
      Items[0] := 'ON  (Euro/Global)';
      Items[1] := 'OFF (Professional)';
      Text := Items[ItemIndex];
    end;

    if Items.Count = 2 then
      ItemIndex := Items.IndexOf(TheItem.SubItems[0])
    else
    begin
      for i := 0 to Items.Count - 1 do
        if TheItem.SubItems[0] = Items[i][1] then
          ItemIndex := i;
    end;

    Parent := lvConfig;


    Visible := True;
  end;
  ActiveControl := ComboBox1;
end;

procedure TfrmComTestForm.ShowEdit(TheItem : TListItem);
begin
  with Edit1  do
  begin
    Left   := lvConfig.Columns[0].Width + 1;
    Width  := lvConfig.Columns[1].Width + 1;
    Top := (TheItem.Index - lvConfig.TopItem.Index)  * 17 + 16;
    Text := TheItem.SubItems[0];

    SelStart := 0;
    SelLength := Length(Text);

    Parent := lvConfig;
    Visible := True;
    ActiveControl := Edit1;
  end;
end;




procedure TfrmComTestForm.ComboBox1Exit(Sender: TObject);
var
  s : string;
begin
  if ComboBox1.Visible then
  begin
    ComboBox1.visible := False;
    if Assigned(CurrentItem) then
    begin
      if ComboBox1.Items.Count = 2 then
        s := ComboBox1.Text
      else
        s := ComboBox1.Text[1];

      if CurrentItem.SubItems[0] <> s then
      begin
        CurrentItem.SubItems[0] := s;
        ConfigChanged := True;
      end;
    end;
  end;
end;

procedure TfrmComTestForm.Edit1Exit(Sender: TObject);
var
  s : string;
begin
  if Edit1.Visible then
  begin
    if ActiveControl <> BitBtn1 then
    begin
      if BitBtn1.Visible then //path wanted
        Edit1.Text := IncludeTrailingBackSlash(Edit1.Text);

      s := Edit1.Text;
      ValidateControlExit(Edit1, s);
      if ActiveCanExit then
      begin
        if BitBtn1.Visible then
          if Assigned(FTestTk) then
            FTestTk.DataPath := Edit1.Text;
        Edit1.visible := False;
        BitBtn1.Visible := False;
        if Assigned(CurrentItem) then
        begin
          if CurrentItem.SubItems[0] <> Edit1.Text then
          begin
            CurrentItem.SubItems[0] := Edit1.Text;
            ConfigChanged := True;
          end;
        end;
      end;
    end;
  end;
end;

procedure TfrmComTestForm.ShowEditor2(TheItem : TListItem);
begin
  if (Assigned(TheItem)) and (TheItem.SubItems[0] = 'ON') then
  with Edit2  do
  begin
    Left   := lvConfig.Columns[0].Width + 1 + lvConfig.Columns[1].Width + 1;
    Width  := lvConfig.Columns[2].Width + 1;
    Top := (TheItem.Index - lvConfig.TopItem.Index)  * 17 + 16;
    Text := TheItem.SubItems[1];

    SelStart := 0;
    SelLength := Length(Text);

    Parent := lvConfig;
    Visible := True;
    ActiveControl := Edit2;
  end;
end;


procedure TfrmComTestForm.Edit2Exit(Sender: TObject);
begin
  if Edit2.Visible then
  begin
    Edit2.Visible := False;
    if Assigned(CurrentItem) then
    begin
      if CurrentItem.SubItems[1] <> Edit2.Text then
      begin
        CurrentItem.SubItems[1] := Edit2.Text;
        ConfigChanged := True;
      end;
    end;
  end;

end;

function TfrmComTestForm.FindListIndex(TheItem : TListItem) : integer;
var
  i : integer;
begin
  Result := 0;
  if Assigned(TheItem) then
  for i := 1 to MaxConfigItems do
  begin
    if TheItem.Caption = FIniFile.ConfigItems[i].Name then
    begin
      Result := i;
      Break;
    end;
  end;
end;

procedure TfrmComTestForm.lvConfigCustomDraw(Sender: TCustomListView;
  const ARect: TRect; var DefaultDraw: Boolean);
begin
  //Need to move controls when listview is scrolled
  if lvConfig.TopItem.Index <> OldTop then
  begin
    if Edit1.Visible then
      ShowEdit(CurrentItem)
    else
    if Edit2.Visible then
      ShowEditor2(CurrentItem)
    else
    if ComboBox1.Visible then
     if ComboBox1.Items.Count = 2 then
      ShowDropDown(CurrentItem, 0)
     else
       ShowDropDown(CurrentItem, 1);

    OldTop := lvConfig.TopItem.Index;
  end;
  DefaultDraw := True;
end;

procedure TfrmComTestForm.ShowPathEdit(TheItem : TListItem);
begin
  with Edit1  do
  begin
    Left   := lvConfig.Columns[0].Width + 1;
    Width  := lvConfig.Columns[1].Width + 1;
    Top := (TheItem.Index - lvConfig.TopItem.Index)  * 17 + 16;
    Text := TheItem.SubItems[0];

    SelStart := 0;
    SelLength := Length(Text);

    Parent := lvConfig;
    Visible := True;
    ActiveControl := Edit1;

  end;

    with BitBtn1 do
    begin
      Top := Edit1.Top;
      Height := Edit1.Height;
      Width := Edit1.Height;
      Left := Edit1.Left + Edit1.Width - Edit1.Height;
      Visible := True;
      Parent := lvConfig;
    end;

end;

procedure TfrmComTestForm.BitBtn1Click(Sender: TObject);
var bi : TBrowseInfoA;
    a  : array[0..MAX_PATH] of Char;
    b : PChar;
    idl : PItemIDList;
    FFolder, FTitle : string;
begin
  FTitle := '';
  FFolder := Edit1.Text;
  b:=StrAlloc(Length(FTitle)+1);
  try
    StrPCopy(b,FTitle);
    bi.hwndOwner:=Self.Handle;
    bi.pszDisplayName:=@a[0];
    bi.lpszTitle:=b;
    bi.ulFlags:= BIF_RETURNONLYFSDIRS;

    bi.lpfn:=nil;
    bi.lParam:=0;
    bi.pidlRoot:=nil;
    idl:=SHBrowseForFolder(bi);
    if idl<>nil then
    begin
      SHGetPathFromIDList(idl,a);
      FFolder:=StrPas(a);
    end;//if idl<>nil
    ShowPathEdit(CurrentItem);
    Edit1.Text := IncludeTrailingBackSlash(FFolder);
  finally
    StrDispose(b);
  end;//finally
end;

procedure TfrmComTestForm.lvConfigKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin

  if Key in [VK_UP, VK_DOWN] then
  begin
     if ComboBox1.Visible then
     begin
       ComboBox1Exit(Self);
       EditShowing := True;
     end
     else
     if Edit1.Visible then
     begin
       Edit1Exit(Self);
       EditShowing := True;
     end
     else
     if Edit2.Visible then
     begin
       Edit2Exit(Self);
       EditShowing := True;
     end;

  end;

end;

procedure TfrmComTestForm.Button1Click(Sender: TObject);
var
  MR  : Word;
begin
  MR := mrNo;
  if OpenDialog1.Execute then
   if UpperCase(ExtractFileName(OpenDialog1.Filename)) = 'EXCHDLL.INI' then
   begin
     if ConfigChanged then
     begin
        MR := MessageDlg('Configuration has changed.  Do you wish to save the changes?',
                         mtConfirmation, mbYesNoCancel, 0);
        if MR = mrYes then
        begin
         FIniFile.Save;
         ConfigChanged := False;
        end
        else
        if MR = mrNo then
         ConfigChanged := False;
     end;


     if MR <> mrCancel then
     begin
       FIniFile.Filename := OpenDialog1.FileName;
       FIniFile.Load;
       HideBranch(lvConfig.Items[0]);
       HideBranch(lvConfig.Items[1]);
       UpdateCaption;
     end;
   end
   else
     ShowMessage('Not the correct ini file');
end;

procedure TfrmComTestForm.Button2Click(Sender: TObject);
begin
  FIniFile.Save;
  FConfigChanged := False;
end;

procedure TfrmComTestForm.Button3Click(Sender: TObject);
begin
  if SaveDialog1.Execute then
  begin
    if UpperCase(ExtractFileName(SaveDialog1.Filename)) = 'EXCHDLL.INI' then
    begin
      FIniFile.FileName := SaveDialog1.Filename;
      FIniFile.Save;
      FConfigChanged := False;
      UpdateCaption;
    end;
  end;
end;


procedure TfrmComTestForm.SetConfigChanged(Value : Boolean);
var
  AName, AValue1, AValue2 : string;
begin
  if Assigned(CurrentItem) then
  begin
    if CurrentItem.SubItems.Count > 0 then
    begin
       AName := CurrentItem.Caption;
       AValue1 := CurrentItem.SubItems[0];
       if CurrentItem.SubItems.Count = 2 then
         AValue2 := CurrentItem.SubItems[1]
       else
         AValue2 := '';
       FIniFile.UpdateConfigItem(AName, AValue1, AValue2);
    end;
    FConfigChanged := Value;
  end;
end;


procedure TfrmComTestForm.FormCloseQuery(Sender: TObject;
  var CanClose: Boolean);
var
  MR : Word;
  i : integer;
begin
  //Count through the components and call OnExit procs for each.
  //Given that we only have three relevant components it would be
  //easier to call them directly but this is future-proof
  for i := 0 to ComponentCount - 1 do
  begin
    if Components[i] is TEdit then
    begin
      if Assigned(TEdit(Components[i]).OnExit) then
        TEdit(Components[i]).OnExit(Self);
    end
    else
    if Components[i] is TComboBox then
    begin
      if Assigned(TComboBox(Components[i]).OnExit) then
        TComboBox(Components[i]).OnExit(Self);
    end;
  end;



  if ActiveCanExit then
  begin
    if ConfigChanged then
    begin
      MR := MessageDlg('Configuration has changed.  Do you wish to save the changes?',
                        mtConfirmation, mbYesNoCancel, 0);
      if MR = mrYes then
      begin
        FIniFile.Save;
        CanClose := True;
      end
      else
      if MR = mrNo then
        CanClose := True
      else //Cancel
        CanClose := False;
    end;//if config changed
  end //if activecanexit
  else
   CanClose := False;
end;


//------------------------------------------------------------------------------------
//   Diagnostic functions
//------------------------------------------------------------------------------------

Procedure TfrmComTestForm.AddCompanyUNCDetails (Const coCode, coName, coDrivePath, coUNCPath : ANSIString; Const FlagFileFound : Boolean);
Begin // AddCompanyUNCDetails
  FTestLog.Report('Company: ' + coCode + IfThen (coName <> '', ' - ' + coName, ''));
  FTestLog.Report('Path: ' + coDrivePath);
  FTestLog.Report('UNC Equiv: ' + IfThen (FlagFileFound, '', '[INVALID] ') + coUNCPath);
  FTestLog.Line;
End; // AddCompanyUNCDetails

//-------------------------------------------------------------------------

procedure TfrmComTestForm.FormActivate(Sender: TObject);
var
  s  : string;
begin
  inherited;

  if FirstTime then
  begin
    FirstTime := False;
    FSysTest.GetSysInfo;
    FSysTest.ShowSystemFiles;

    // Display the Company UNC Pathing info if defined
    If CompanyUNCFileExists (ExtractFilePath(Application.ExeName)) Then
    Begin
      FTestLog.ReportBoldU('Company Path Information');
      LoadCompanyUNCFile (ExtractFilePath(Application.ExeName), AddCompanyUNCDetails);
    End; // If CompanyUNCFileExists (ExtractFilePath(Application.ExeName))

    if FileExists(FIniFile.Filename) then
    begin
      FTestLog.ReportBoldU('Settings in ExchDll.Ini');
      FTestLog.ReportBold('(' + ExtractFilePath(FIniFile.Filename) + ')');
    end
    else
      FTestLog.ReportError('Can''t load ExchDll.Ini from ' + ExtractFilePath(FIniFile.Filename));
    FTestLog.Line;
    FTestLog.AddStrings(FIniFile.GetText);
    FTestLog.Line;
    if Assigned(FTestTK) then
     if FTestTk.IsClientServer then
     begin
      s := FSysTest.NetworkDir(EntDir);
      if Pos('Invalid Exchequer Path', s) = 0 then
        if Pos('File not found',s) = 0 then
          FTestLog.Report('Network path from EntWRepl.ini: ' + s + ' - Valid Exchequer Path')
        else
          FTestLog.Report(s)
      else
        FTestLog.ReportError('Network path from EntWRepl.ini: ' + s);
     end;

    FTestLog.Line;
    FTestLog.ShowErrorCount('System tests');
    Screen.Cursor := crDefault;
  end;
end;

procedure TfrmComTestForm.NextBtnClick(Sender: TObject);
begin
 PostMessage(memDiag.Handle, EM_SCROLLCARET, 0, 0);//Scroll to end then start autoscroll
 FTestLog.AutoScroll := True;
 if NextBtn2.Caption = '&Continue' then
 begin
   Testing := True;
   StartTKTests;
   Testing := False;
 end
 else
 if NextBtn2.Caption = '&Advanced' then
 begin
   Testing := True;
   AdvancedTests;
   Testing := False;
 end;
end;

procedure TfrmComTestForm.StartTKTests;
var
  CoCount, i : integer;
begin
    //Create object for testing com toolkit
    Screen.Cursor := crHourGlass;
    BackBtn2.Enabled := False;
    NextBtn2.Enabled := False;
    if Assigned (FTestTk) then
    with FTestTK do
    begin
     Report := FTestLog;
     Try
      Try
        if Open = 0 then
        begin
//          Btrieve;
          EntSettings;
          Progress;
          CoCount := AvailableCompanies;
          if CoCount > 0 then
          begin
            StartProgress(DefaultTests, CoCount);
            FTestLog.ReportBold('Available companies: ' + IntToStr(CoCount));
            BlankLine;

            for i := 1 to CoCount do
            begin
              if CheckDataPath(i) then
              begin
                if ChangeCompany(i) then
                begin
                  if i = 1 then
                   if Assigned(FTestTk) then
                    FTestTk.LoadBaseLicences;
                  RunTests;
                end;
              end
              else
                FTestLog.ReportError('Invalid path for Company ' + IntToStr(i) +
                                    ': ' + GetDataPath(i));
            end;
          end
          else
          begin //no companies found
            BlankLine;
            FTestLog.Report('Reading data directory from ExchDll.ini');
            FTestLog.Report('Running tests on data in ' + FIniFile.ReadIniValue('Exchequer_Path'));
            BlankLine;
            RunTests; //on company in exchdll.ini Exchequer_Path key
          end;
        end;

      Except
      End;
     Finally
      EndProgress('Diagnostics complete'#13#13 +
                  FTestLog.ShowErrorCount('Toolkit tests'));
      Close;
      Screen.Cursor := crDefault;
      BackBtn2.Enabled := True;
      NextBtn2.Caption := '&Advanced';
      NextBtn2.Enabled := True;
     End;
    end
    else
    begin
      FTestLog.ReportError('Unable to create instance of COM Toolkit');
      Screen.Cursor := crDefault;
      BackBtn2.Enabled := True;
    end;
end;

procedure TfrmComTestForm.StartProgress(NumberOfTests, NumberOfCompanies : integer);
begin
  FProgressStep := 100 / (NumberOfCompanies * NumberOfTests);
  if FProgressStep >= 1 then
  begin
    ProgressBar1.Step := Trunc(FProgressStep);
    FUseProgressStep := False;
  end
  else
  begin
    ProgressBar1.Step := 1;
    FProgressCount := 0;
    FUseProgressStep := True;
  end;
  PageControl1.Height := 393;
  ProgressBar1.Position := 0;
  ProgressBar1.Visible := True;
  TitleLbl.Caption := 'Running tests. Please wait...';
end;

procedure TfrmComTestForm.Progress;
begin
  if FUseProgressStep then
  begin
    FProgressCount := FProgressCount + FProgressStep;
    if FProgressCount >= 1 then
    begin
      FProgressCount := 0;
      ProgressBar1.StepIt;
    end;
  end
  else
    ProgressBar1.StepIt;
end;

procedure TfrmComTestForm.EndProgress(const Msg : string);
begin
  ProgressBar1.Position := 100;
  Application.ProcessMessages;
  ShowMessage(Msg);
  TitleLbl.Caption := 'Diagnostics';
  ProgressBar1.Visible := False;
  PageControl1.Height := 425;
end;


procedure TfrmComTestForm.BackBtnClick(Sender: TObject);
begin
{  inherited;}
 if SaveDialog2.Execute then
   memDiag.Lines.SaveToFile(SaveDialog2.FileName);
end;

procedure TfrmComTestForm.AdvancedTests;
var
  CoCount, i : integer;
begin
    Screen.Cursor := crHourGlass;
    BackBtn2.Enabled := False;
    NextBtn2.Enabled := False;
    if Assigned (FTestTk) then
    with FTestTK do
    begin
     Report := FTestLog;
      Try
        if Open = 0 then
        begin
          CoCount := AvailableCompanies;
          FTestLog.ReportBoldU('Running Advanced diagnostics');
          FTestLog.Line;
          if CoCount > 0 then
          begin
            StartProgress(1, CoCount);
            FTestLog.ReportBold('Available companies: ' + IntToStr(CoCount));
            BlankLine;

            for i := 1 to CoCount do
            begin
              if CheckDataPath(i) then
              begin
                ChangeCompany(i);
                RunAdvancedTests;
                Progress;
              end
              else
                FTestLog.ReportError('Invalid path for Company ' + IntToStr(i) +
                                    ': ' + GetDataPath(i));
            end;
          end//cocount > 0
          else
          begin //no companies found
            BlankLine;
            FTestLog.Report('Reading data directory from ExchDll.ini');
            FTestLog.Report('Running tests on data in ' + FIniFile.ReadIniValue('Exchequer_Path'));
            BlankLine;
            RunAdvancedTests; //on company in exchdll.ini Exchequer_Path key
          end;
        end
        else
          FTestLog.ReportError('Can''t open Toolkit');
      Finally

        Close;
        EndProgress('Advanced diagnostics complete'#13#13 +
                    FTestLog.ShowErrorCount('Advanced tests'));
        BackBtn2.Enabled := True;
        Screen.Cursor := crDefault;
      End;
    end;
end;


procedure TfrmComTestForm.RunTests;
begin
  if Assigned(FTestTk) then
  with FTestTk do
  begin
    ShowLicences;
    TestCustomersOrSuppliers(True);
    Progress;
    TestCustomersOrSuppliers(False);
    Progress;
    if CCs then
    begin
      TestCCDeps(True);
      TestCCDeps(False);
    end
    else
    begin
      FTestLog.ReportBold('Cost Centres and Departments not used');
      FTestLog.Line;
    end;
    Progress;

    TestGeneralLedger;
    Progress;

    if Locations then
      TestLocations
    else
    begin
      FTestLog.ReportBold('Stock Locations not used');
      FTestLog.Line;
    end;

    TestStock;
    Progress;
    TestTransactions;
    Progress;

    if JobCostingLicenced then
    begin
      TestEmployees;
      TestJobs;
      TestJobAnalysis;
      TestJobTypes;
      TestTimeRates;
    end
    else
    begin
      FTestLog.ReportBold('Job Costing not Licenced');
      FTestLog.Line;
    end;
    Progress;
    FTestLog.WriteDetailLog;
  end;
end;

procedure TfrmComTestForm.RunAdvancedTests;
begin
  if Assigned(FTestTk) then
  with FTestTk do
  begin
    BtrieveFiles;
    BlankLine;
    FTestLog.WriteDetailLog;
  end;
end;

function TfrmComTestForm.FindPath : string;
var
  s : string;
begin
{  if Assigned(FTestTk) then
    s := FTestTk.EnterprisePath
  else
    s := '';}

  s := GetEnterpriseDirectory;


  Result := ExtractFilePath(ParamStr(0));

  if not ValidEntDir(Result) then
    {do what?} ;
  FTestLog.Line;
  if s <> '' then //Com tk tests dir & sets it to '' if invalid
    FTestLog.Report('  Exchequer path: ' + s)
  else
    FTestLog.ReportError('Invalid Exchequer Path');
  FTestLog.Report('Application path: ' + Result);
  FTestLog.Line;
  if Result <> '' then
    Result := IncludeTrailingBackSlash(Result);//just to be on the safe side

end;

function TfrmComTestForm.ValidEntDir(const s : string) : Boolean;
begin
  if not FileExists(IncludeTrailingBackSlash(s) + 'Enter1.exe') then
  begin
    Result := False;
    FTestLog.ReportError(s + ' is not a valid Exchequer directory');
  end
  else
    Result := True;
end;


procedure TfrmComTestForm.ValidateControlExit(Sender : TWinControl;
                                      var ExitText : string);
var
  s : string;
  v : byte;
begin
  ActiveCanExit := False;
  v := vaUnknown;
  begin
    if Assigned(CurrentItem) then
    begin
      s := LowerCase(CurrentItem.Caption);
      if s = 'exchequer_path' then
        v := vaPath
      else
      if s = 'default_nominal' then
        v := vaNominal
      else
      if s = 'default_cost_centre' then
        v := vaCC
      else
      if s = 'default_department' then
        v := vaDept
      else
      if s = 'default_vat_code' then
        v := vaVAT
      else
      if s = 'default_currency' then
        v := vaCurrency
      else
        v := vaUnknown;
    end;
  end;

  if Assigned(FTestTK) and (ActiveControl <> chkValidate) then
  begin
    if FTestTK.ValidateExit(ExitText, v) then
    begin
      ActiveCanExit := True;
      TEdit(Sender).Text := ExitText;
    end
    else
      ActiveControl := Sender;
  end
  else
    ActiveCanExit := True;
end;


procedure TfrmComTestForm.chkValidateClick(Sender: TObject);
begin
  if Assigned(FTestTk) then
    FTestTk.ValidateData := chkValidate.Checked;
end;

procedure TfrmComTestForm.InitComboBox(WhichList : Byte);
var
  i : integer;
begin
  ComboBox1.Items.Clear;
  if WhichList in [0, 5] then
  begin
    ComboBox1.Items.Add('ON');
    ComboBox1.Items.Add('OFF');
  end
  else
  begin
    ComboBox1.Items.Add('S - Standard');
    ComboBox1.Items.Add('E - Exempt');
    ComboBox1.Items.Add('Z - Zero-rated');
    for i := 0 to 9 do
      ComboBox1.Items.Add(IntToStr(i) + ' - Rate ' + IntToStr(i));
    ComboBox1.Items.Add('T - Rate T');
    ComboBox1.Items.Add('X - Rate X');
    ComboBox1.Items.Add('B - Rate B');
    ComboBox1.Items.Add('C - Rate C');
    ComboBox1.Items.Add('F - Rate F');
    ComboBox1.Items.Add('G - Rate G');
    ComboBox1.Items.Add('R - Rate R');
    ComboBox1.Items.Add('W - Rate W');
    ComboBox1.Items.Add('Y - Rate Y');
    ComboBox1.Items.Add('I - Inclusive');
    ComboBox1.Items.Add('M - Manual');
    ComboBox1.Items.Add('A - Acquisition');
    ComboBox1.Items.Add('D - Despatch');
  end;
end;



procedure TfrmComTestForm.Image1DblClick(Sender: TObject);
begin
  if Assigned(FTestTk) then
    FTestTk.Browse;
end;

procedure TfrmComTestForm.ShowAllBranches;
var
  i : integer;
begin
  for i := lvConfig.Items.Count - 1 downto 0 do
    ShowBranch(lvConfig.Items[i]);
end;

procedure TfrmComTestForm.Button4Click(Sender: TObject);
begin
  inherited;
  ShowAllBranches;
end;

procedure TfrmComTestForm.mnuOptSetupBtrvSQLTKFileClick(Sender: TObject);
Var
  CompanyDetails : Array Of TCompanyUNCDetailsRecType;
  I : Integer;

  //------------------------------

  {+------------------------------------------------------------
  | Function GetLongFilename
  |
  | Parameters:
  |  shortname: filename or path to convert. This can be a
  |             fully qualified filename or a path relative
  |             to the current directory. It can contain long
  |             and/or short forms for the names.
  | Returns:
  |  fully qualified filename using the long names for all elements
  |  of the path.
  | Description:
  |  Recursively uses FindFirst to find the long names for
  |  the path elements.
  | Error Conditions:
  |  Will raise an exception if any part of the path was not found.
  |
  |Created: 15.01.98 14:09:26 by P. Below
  +------------------------------------------------------------}
  Function GetLongFilename(shortname: String ):String;

    Function GetL( shortname: String ):String;
    Var
      srec: TSearchRec;
    Begin
      { Lob off the last element of the passed name. If we received
        only a root name, e.g. c:\, ExtractFileDir returns the
        path unchanged. }
      Result := ExtractFileDir( shortname );
      If (Result <> shortname) Then Begin
        { We still have an unconverted path element. So convert
          the last one in the current shortname and combine the
          resulting long name with what we get by calling ourselves
          recursively with the rest of the path. }
        If FindFirst( shortname, faAnyfile, srec ) = 0 Then
        try
          Result := GetL( Result )+'\'+srec.Name;
        finally
          FindClose( srec );
        end
        Else
          raise Exception.CreateFmt('Path %s does not exist!', [shortname]);
      End
      Else
        { Only the root remains. Remove the backslash since the
          caller will add it back anyway. }
        Delete(Result, length(result),1);
    End;

  Begin
    { Create fully qualified path and pass it to the converter. }
    Result := GetL( ExpandFilename( shortname ));
  End;

  //------------------------------

begin
  If Assigned(FTestTK) Then
  Begin
    // Populate a dynamic array with the company details from the MCM to pass into
    // to common Write function in UNCCache.pas
    For I := 1 To FTestTK.Toolkit.Company.cmCount Do
    Begin
      // Check the company is configured correctly - mapped drive must exist
      // and the .company file must be present
      If DirectoryExists(Trim(FTestTK.Toolkit.Company.cmCompany[I].coPath)) Then
      Begin
        If FileExists(IncludeTrailingPathDelimiter(Trim(FTestTK.Toolkit.Company.cmCompany[I].coPath)) +
                      Trim(FTestTK.Toolkit.Company.cmCompany[I].coCode) + '.Company') Then
        Begin
          SetLength(CompanyDetails, Length(CompanyDetails) + 1);
          With CompanyDetails[High(CompanyDetails)] Do
          Begin
            coCode      := Trim(FTestTK.Toolkit.Company.cmCompany[I].coCode);
            coName      := Trim(FTestTK.Toolkit.Company.cmCompany[I].coName);
            coDrivePath := Trim(FTestTK.Toolkit.Company.cmCompany[I].coPath);
            coUNCPath   := ExpandUNCFileName(GetLongFileName(ExcludeTrailingPathDelimiter(Trim(FTestTK.Toolkit.Company.cmCompany[I].coPath))));
          End; // With CompanyDetails[High(CompanyDetails)]
        End // If FileExists(...
        Else
          MessageDlg ('Company ' + Trim(FTestTK.Toolkit.Company.cmCompany[I].coCode) + ' is not configured for BtrvSQLTK', mtWarning, [mbOK], 0);
      End // If DirectoryExists(Trim(FTestTK.Toolkit.Company.cmCompany[I].coPath))
      Else
        MessageDlg ('Company ' + Trim(FTestTK.Toolkit.Company.cmCompany[I].coCode) + ' has an invalid directory', mtWarning, [mbOK], 0);
    End; // For I

    If (Length(CompanyDetails) > 0) Then
      WriteCompanyUNCFile (ExtractFilePath(Application.ExeName), CompanyDetails);

    SetLength(CompanyDetails, 0);
  End; // If Assigned(FTestTK)
end;

end.
