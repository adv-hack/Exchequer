unit Main;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs
  , StdCtrls, ComCtrls, StrUtil, {Inifiles,} AddEdit, Menus, Test, CopyComp
  , ExtCtrls, AddGLCod, APIUtil, MiscUtil, {NeilProc,} FileUtil, BTFile
  , BTConst, BTUtil, CTKUtil, Enterprise01_TLB, uExDatasets, uBtrieveDataset
  , uSettings, uMultiList, uDBMultiList, import;

{$I x:\ENTRPRSE\DLLTK\EXCHDLL.INC}   {* for linking with Enterprise - DLL Record Structure *}
{$I x:\ENTRPRSE\DLLTK\ExDLLBt.Inc}   {*       "            "        - DLL Btrieve Commands *}


type
  TfrmMain = class(TForm)
    pcCombinations: TPageControl;
    tsValid: TTabSheet;
    tsInvalid: TTabSheet;
    btnAdd: TButton;
    btnEdit: TButton;
    btnDelete: TButton;
    btnTest: TButton;
    btnClose: TButton;
    cmbCompany: TComboBox;
    lCompany: TLabel;
    btnCopy: TButton;
    RightClickMenu: TPopupMenu;
    Add1: TMenuItem;
    Edit1: TMenuItem;
    Delete1: TMenuItem;
    MainMenu1: TMainMenu;
    File1: TMenuItem;
    Exit1: TMenuItem;
    Help1: TMenuItem;
    About1: TMenuItem;
    Bevel1: TBevel;
    Bevel2: TBevel;
    Label3: TLabel;
    rbSame: TRadioButton;
    rbDifferent: TRadioButton;
    CopyBtnMenu: TPopupMenu;
    CopyToCompany: TMenuItem;
    CopytoGL: TMenuItem;
    lGLCode: TLabel;
    cmbGLCode: TComboBox;
    btnAddCode: TButton;
    mlValid: TDBMultiList;
    mlInvalid: TDBMultiList;
    bdsValid: TBtrieveDataset;
    bdsInvalid: TBtrieveDataset;
    Options1: TMenuItem;
    ValidateVAT1: TMenuItem;
    Import1: TMenuItem;
    N1: TMenuItem;
    RebuildDatafile1: TMenuItem;
    Export1: TMenuItem;
    SaveDialog1: TSaveDialog;
    procedure btnCloseClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure cmbCompanyChange(Sender: TObject);
    procedure btnAddEditClick(Sender: TObject);
    procedure btnDeleteClick(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure btnTestClick(Sender: TObject);
    procedure Exit1Click(Sender: TObject);
    procedure About1Click(Sender: TObject);
    procedure rbClick(Sender: TObject);
    procedure cmbGLCodeChange(Sender: TObject);
    procedure btnAddCodeClick(Sender: TObject);
    procedure btnCopyMouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure btnCopyCompany(Sender: TObject);
    procedure btnCopyGL(Sender: TObject);
    procedure bdsGetFieldValue(Sender: TObject; PData: Pointer;
      FieldName: String; var FieldValue: String);
    procedure mlRowDblClick(Sender: TObject; RowIndex: Integer);
    procedure pcCombinationsChange(Sender: TObject);
    procedure ValidateVAT1Click(Sender: TObject);
    procedure Import1Click(Sender: TObject);
    procedure CopyBtnMenuPopup(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure RebuildDatafile1Click(Sender: TObject);
    procedure Export1Click(Sender: TObject);
  private
//    bFormOpening : boolean;
    bCompanyChanging : boolean;
    iCurrentGLCode, iCompItemIndex : integer;
    sCurrentCompanyPath, sPrevGLCode : string;

    CCList : TStrings;
    DeptList : TStrings;

    procedure FillLists;
//    procedure SaveChanges(sGLCode : string);
    procedure CheckGL;
//    function GetGLCode : string;
//    function GetOppGLCode : string;
    procedure FillCCDeptLists; // Added 03/06/2003
    procedure EnableDisable;
    procedure ChangeVAT;
    procedure SaveGLCodestatus;
    function ReadGLCodeStatus : boolean;
  public
    { Public declarations }
  end;

  procedure FillCompanyList(cmbComp : TComboBox);

var
  frmMain: TfrmMain;

implementation

{$R *.DFM}

uses
//  UseDllU, // Exchequer code
  ETStrU, Inifiles, SystemSetup, CCDeptU, CopyGL, ExchequerRelease;

type
  TCompanyType = Record
    CompCode : string[6];
    CompName : string[45];
    CompPath : string[100];
    CompSpare : array [1..100] of char;
  end;

  TCompanies = Array[1..200] of TCompanyType;
  PCompanies = ^TCompanies;

  function EX_GETCOMPANY(COMPDIR : PCHAR; PARRAY : POINTER; VAR PARRAYSIZE : LONGINT) : SMALLINT; stdCall; external 'EntComp.dll';


procedure TfrmMain.btnCloseClick(Sender: TObject);
begin
  Close;
end;

procedure TfrmMain.FormCreate(Sender: TObject);
var
  iPos : integer;
//siTKRes : SmallInt;
begin
  bCompanyChanging := TRUE;
//  siTKRes := Ex_InitDLL;
  oToolkit := nil;

//  bFormOpening := TRUE;

  CCList := TStringList.Create;
  DeptList := TStringList.Create;

  FillCompanyList(cmbCompany);
  if (cmbCompany.Items.Count = 0) then
  begin
    MessageDlg('No company data was found',mtError,[mbOK],0);
    Close;
  end else
  begin
//    rbSame.Checked := TRUE;
    cmbCompanyChange(cmbCompany);

    if oToolkit.Enterprise.enRunning then
    begin
      For iPos := 0 to cmbCompany.Items.Count-1 do
      begin
        if (uppercase(Trim((TCompanyInfo(cmbCompany.Items.Objects[iPos]).Path)))
        = (uppercase(Trim(oToolkit.Enterprise.enCompanyPath)))) then
        begin
          cmbCompany.ItemIndex := iPos;
          cmbCompanyChange(cmbCompany);
          break;
        end;{if}
      end;{for}
    end;{if}

//    CheckGL;
//    FillLists;
  end; // if cmbCompany.Items.Count = 0 then

  iCompItemIndex := cmbCompany.ItemIndex;

  pcCombinations.ActivePage := tsValid;
//  bFormOpening := FALSE;
  EnableDisable;
  bCompanyChanging := FALSE;
end;

procedure TfrmMain.FormDestroy(Sender: TObject);
//var
//  siTKRes : SmallInt;
begin
  while (CCList.Count > 0) do
    CCList.Delete(0);
  CCList.Free;

  while (DeptList.Count > 0) do
    DeptList.Delete(0);
  DeptList.Free;

  ClearList(cmbCompany.Items);

//  siTKRes := Ex_CloseDLL;

  CloseFiles;
  if Assigned(oToolkit) then oToolkit.CloseToolkit;
  oToolkit := nil;
end;

procedure FillCompanyList(cmbComp : TComboBox);
var
  CompDir : array[0..255] of char;
  CompArray : PCompanies;
  iArrayItems, iPos : longint;
  iStatus : smallint;
  CompanyInfo : TCompanyInfo;
begin
  new(CompArray);
//  StrPCopy(CompDir, ExtractFilePath(Application.ExeName));
  StrPCopy(CompDir, GetEnterpriseDirectory);
  iArrayItems := SizeOf(CompArray^);
  iStatus := EX_GETCOMPANY(CompDir, CompArray, iArrayItems);
  if (iStatus = 0) then
  begin
    for iPos := 1 to iArrayItems do
    begin
      with CompArray^[iPos] do
      begin
        CompanyInfo := TCompanyInfo.Create;
        with CompanyInfo do
        begin
          Name := CompName;
          Code := CompCode;
          Path := CompPath;
        end; // with CompanyInfo do...
        cmbComp.Items.AddObject(CompName, CompanyInfo);

        ConvertDataFile(Trim(CompPath));

      end; // with CompArray^[iPos] do...
     end; // for iPos := 1 to iArrayItems do...

    if (cmbComp.Items.Count <> 0) then
    begin
      cmbComp.ItemIndex := 0;
      cmbComp.Enabled := cmbComp.Items.Count > 1;
    end;
  end
  else
  begin
    ShowMessage('Error ' + IntToStr(iStatus) + ' occured whilst reading the company list');
  end; // if (iStatus = 0) then
  Dispose(CompArray);
end;

procedure TfrmMain.FillCCDeptLists; // Added 03/06/2003
var
  siCCDeptRes : SmallInt;
begin
  // FillCCDeptLists will assume that this list is to filled with fresh items...
  // ...OIOW, remove all current items first then fill it up.
  while CCList.Count > 0 do
    CCList.Delete(0);
  while DeptList.Count> 0 do
    DeptList.Delete(0);

  // fill Cost Centre List
  CCList.Add(CCDEPT_WILDCARD);
  oToolkit.CostCentre.Index := cdIdxCode;
  siCCDeptRes := oToolkit.CostCentre.GetFirst;
  while (siCCDeptRes = 0) do
  begin
    CCList.Add(oToolkit.CostCentre.cdCode);
    siCCDeptRes := oToolkit.CostCentre.GetNext;
  end; // while (siCCDeptRes = 0) do...

  // fill Department List
  DeptList.Add(CCDEPT_WILDCARD);
  siCCDeptRes := oToolkit.Department.GetFirst;
  while (siCCDeptRes = 0) do
  begin
    DeptList.Add(oToolkit.Department.cdCode);
    siCCDeptRes := oToolkit.Department.GetNext;
  end; // while (siCCDeptRes = 0) do...
end;

procedure TfrmMain.cmbCompanyChange(Sender: TObject);
//var
//  sPath : string;
begin
{  if bEdited then begin
{    if MessageDlg('You have not saved the changes that you made to the previous company.'
    + #13 + #13 + 'Do you wish to save these changes now ?', mtConfirmation, [mbYes, mbNo], 0) = mrYes then SaveChanges(GetGLCode);}
{  end;{if}

  bCompanyChanging := TRUE;
  Screen.Cursor := crHourglass;

  if sCurrentCompanyPath <> '' then SaveGLCodestatus;

  // Close Stuff
  mlValid.Active := FALSE;
  mlInvalid.Active := FALSE;
  if Assigned(oToolkit) then oToolkit.CloseToolkit;
  CloseFiles;

  // Open Stuff
  sCurrentCompanyPath := Trim(TCompanyInfo(cmbCompany.Items.Objects[cmbCompany.ItemIndex]).Path);

  // v6.30.145 - ABSPLUG-77 - Fixes Error 3 and 11 in settings.dat
  sMiscDirLocation := sCurrentCompanyPath;

  if not OpenFiles(sCurrentCompanyPath, FALSE, FALSE) then
  begin
    MsgBox('The call to OpenFiles(' + sCurrentCompanyPath
    + ') in CCCustom.Dll Failed.', mtError, [mbOK], mbOK, 'CCCustom.Dll error');
  end;{if}
  oToolkit := OpenToolkit(sCurrentCompanyPath, TRUE);
  bdsValid.FileName := aFileName[CCDeptF];
  bdsInvalid.FileName := bdsValid.FileName;

  if FileExists(sCurrentCompanyPath + CCDEPTINI) then RunConversion(sCurrentCompanyPath);

  FillCCDeptLists;
  CheckGL;
  FillLists;
  iCompItemIndex := cmbCompany.ItemIndex;
//  bEdited := FALSE;
  sPrevGLCode := cmbGLCode.Text;

  ChangeVAT;

  EnableDisable;

  Screen.Cursor := crDefault;
  bCompanyChanging := FALSE;
end;

procedure TfrmMain.FillLists;
//var
//  CCIni : TInifile;
//  Inclusions, Exclusions : TStrings;
//  iPos : integer;
//  iCommaPos : byte;
//  sGLCode : string;
begin
  mlValid.Active := FALSE;
  mlInvalid.Active := FALSE;
  if rbSame.Checked then
  begin
    iCurrentGLCode := iNO_GL;
  end else
  begin
    if (cmbGLCode.Items[cmbGLCode.ItemIndex] = sGL_WILDCARD)
    then iCurrentGLCode := iGL_WILDCARD
    else iCurrentGLCode := StrToIntDef(cmbGLCode.Items[cmbGLCode.ItemIndex], iNO_GL);
  end;{if}

  bdsValid.SearchKey := CD_VALID + BTFullNomKey(iCurrentGLCode);
  bdsInvalid.SearchKey := CD_INVALID + BTFullNomKey(iCurrentGLCode);

  mlValid.Active := TRUE;
  mlValid.RefreshDB;
  mlInvalid.Active := TRUE;
  mlInvalid.RefreshDB;

(*lvValid.Items.Clear;
  lvInvalid.Items.Clear;

  {initialise variables}
  CCIni := TInifile.create(IncludeTrailingBackslash(Trim(TCompanyInfo(cmbCompany.Items.Objects
  [cmbCompany.ItemIndex]).Path)) + CCDEPTINI);
  Inclusions := TStringList.Create;
  Exclusions := TStringList.Create;
  sGLCode := GetGLCode;

  {Read values from ini file}
  with CCIni do
  begin
    UpdateFile;
    ReadSectionValues(sGLCode + '-Valid Combinations', Inclusions);
    ReadSectionValues(sGLCode + '-Invalid Combinations', Exclusions);
    Free;
  end;{with}

  {fill Valid list from string list}
  For iPos := 0 to Inclusions.Count - 1 do begin
    iCommaPos := Pos(',',Inclusions[iPos]);
    with lvValid.Items.Add do begin
      Caption := Copy(Inclusions[iPos], iCommaPos - 3,3);
      SubItems.Add(Copy(Inclusions[iPos], iCommaPos + 1,3));
    end;{with}
  end;{for}

  {allow for scroll bar width}
  if lvValid.Items.Count > 12 then lvValid.Columns[1].Width := 91
  else lvValid.Columns[1].Width := 107;

  {select 1st item}
  if lvValid.Items.Count <> 0 then lvValid.Selected := lvValid.Items[0];


  {fill Invalid list from string list}
  For iPos := 0 to Exclusions.Count - 1 do begin
    iCommaPos := Pos(',',Exclusions[iPos]);
    with lvInvalid.Items.Add do begin
      Caption := Copy(Exclusions[iPos], iCommaPos - 3,3);
      SubItems.Add(Copy(Exclusions[iPos], iCommaPos + 1,3));
    end;{with}
  end;{for}

  {allow for scroll bar width}
  if lvInvalid.Items.Count > 12 then lvInvalid.Columns[1].Width := 91
  else lvInvalid.Columns[1].Width := 107;

  {select 1st item}
  if lvInvalid.Items.Count <> 0 then lvInvalid.Selected := lvInvalid.Items[0];

  GreyInOut;*)

end;

procedure TfrmMain.btnAddEditClick(Sender: TObject);
var
  frmAddEdit: TfrmAddEdit;
  mlCombinations : TDBMultiList;
  bdsCombinations : TBtrieveDataset;
  CCDeptRec : TCCDeptRec;
  cType : Char;
  BTRec : TBTRec;

begin
  frmAddEdit := TfrmAddEdit.Create(Self);
  try
    with frmAddEdit do
    begin
      FormMode := TFormMode(TButton(Sender).Tag);

      if pcCombinations.ActivePage = tsValid then
      begin
        ValidMode := vmValid;
        mlCombinations := mlValid;
        bdsCombinations := bdsValid;
        cType := CD_VALID;
      end else
      begin
        ValidMode := vmInvalid;
        mlCombinations := mlInvalid;
        bdsCombinations := bdsInvalid;
        cType := CD_INVALID;
      end;{if}

      edCC.Items := CCList;
      edDept.Items := DeptList;

      {populate edit boxes}
      if FormMode = fmEdit then
      begin
        CCDeptRec := TCCDeptRec(bdsCombinations.GetRecord^);
        edCC.ItemIndex := edCC.Items.IndexOf(CCDeptRec.cdCostCentre);
        edDept.ItemIndex := edDept.Items.IndexOf(CCDeptRec.cdDepartment);
        SelectVATCode(cmbVAT, CCDeptRec.cdVATCode);
      end;{if}

      if (ShowModal = mrOK) then
      begin
//        bEdited := TRUE;
        case FormMode of
          fmAdd : begin
            FillChar(CCDeptRec, SizeOf(TCCDeptRec), #0);
            with CCDeptRec do
            begin
              cdType := cType;
              cdGLCode := iCurrentGLCode;
              cdCostCentre := edCC.Text;
              cdDepartment := edDept.Text;
              if bUseVAT then cdVATCode := GetVATCode(cmbVAT);
              cdDummyChar := IDX_DUMMY_CHAR;
              BTRec.Status := BTAddRecord(aFileVar[CCDeptF], CCDeptRec, aBufferSize[CCDeptF], idxGetCombinations);
              if BTRec.Status = 0 then
              begin
                // added OK
              end else
              begin
                if BTRec.Status = 5 then
                begin
                  MsgBox('You already have an entry in the database for this combination.'#13#13
                  + 'Your new entry will not be added.', mtWarning, [mbOK], mbOK, 'Duplicate Entry');
                end else
                begin
                  BTShowError(BTRec.Status, 'BTAddRecord', aFileName[CCDeptF]);
                end;
              end;
            end;{with}
          end; // fmAdd

          fmEdit : begin
            BTRec.KeyS := CCDeptRec.cdType + BTFullNomKey(CCDeptRec.cdGLCode)
            + CCDeptRec.cdCostCentre + CCDeptRec.cdDepartment + CCDeptRec.cdVATCode;

{            BTRec.KeyS := CCDeptRec.cdType + BTFullNomKey(CCDeptRec.cdGLCode)
            + PadString(psRight, CCDeptRec.cdCostCentre, ' ', 3)
            + PadString(psRight, CCDeptRec.cdDepartment, ' ', 3)
            + CCDeptRec.cdVATCode;}

            BTRec.Status := BTFindRecord(BT_GetEqual, aFileVar[CCDeptF], CCDeptRec
            , aBufferSize[CCDeptF], idxGetCombinations, BTRec.KeyS);

            if BTRec.Status = 0 then
            begin
              with CCDeptRec do
              begin
                cdCostCentre := edCC.Text;
                cdDepartment := edDept.Text;
                if bUseVAT then cdVATCode := GetVATCode(cmbVAT);
                BTRec.Status := BTUpdateRecord(aFileVar[CCDeptF], CCDeptRec
                , aBufferSize[CCDeptF], idxGetCombinations, BTRec.KeyS);
                if BTRec.Status = 0 then
                begin
                  // updated OK
                end
                else
                begin
                  if BTRec.Status = 5 then
                  begin
                    MsgBox('You already have an entry in the database for this combination.'#13#13
                    + 'This entry will not be edited.', mtWarning, [mbOK], mbOK, 'Duplicate Entry');
                  end
                  else
                  begin
                    BTShowError(BTRec.Status, 'BTUpdateRecord', aFileName[CCDeptF]);
                  end;{if}
                end;
              end;{with}
            end;{if}
          end; // fmEdit
        end; // case FormMode of
        mlCombinations.RefreshDB;
        EnableDisable;
      end;{if}
    end; // with frmAddEdit do
  finally
    frmAddEdit.Release;
  end;{try}
//  btnSave.Enabled := bEdited = TRUE;

//  SaveChanges(GetGLCode);
//  SaveChanges(cmbGLCode.Text);

end;

procedure TfrmMain.btnDeleteClick(Sender: TObject);
var
  CCDeptRec : TCCDeptRec;
  bdsCombinations : TBtrieveDataset;
  mlCombinations : TDBMultiList;
  BTRec : TBTRec;
begin
  if MessageDlg('Are you sure you wish to delete this combination ?'
  , mtConfirmation, [mbYes, mbNo], 0) = mrYes then
  begin
    if pcCombinations.ActivePage = tsValid then
    begin
      mlCombinations := mlValid;
      bdsCombinations := bdsValid;
    end else
    begin
      mlCombinations := mlInvalid;
      bdsCombinations := bdsInvalid;
    end;{if}

    CCDeptRec := TCCDeptRec(bdsCombinations.GetRecord^);

    BTRec.KeyS := CCDeptRec.cdType + BTFullNomKey(CCDeptRec.cdGLCode)
    + CCDeptRec.cdCostCentre + CCDeptRec.cdDepartment + CCDeptRec.cdVATCode;

//    BTRec.KeyS := CCDeptRec.cdType + BTFullNomKey(CCDeptRec.cdGLCode)
//    + PadString(psRight, CCDeptRec.cdCostCentre, #0, 3)
//    + PadString(psRight, CCDeptRec.cdDepartment, #0, 3)
//    + CCDeptRec.cdVATCode;

    BTRec.Status := BTFindRecord(BT_GetEqual, aFileVar[CCDeptF], CCDeptRec
    , aBufferSize[CCDeptF], idxGetCombinations, BTRec.KeyS);

    if BTRec.Status = 0 then
    begin
      BTRec.Status := BTDeleteRecord(aFileVar[CCDeptF], CCDeptRec, aBufferSize[CCDeptF], idxGetCombinations);
      if BTRec.Status = 0 then
      begin
        // deleted OK
        mlCombinations.RefreshDB;
      end else
      begin
        BTShowError(BTRec.Status, 'BTDeleteRecord', aFileName[CCDeptF]);
      end;{if}
    end else
    begin
      BTShowError(BTRec.Status, 'BTFindRecord', aFileName[CCDeptF]);
    end;{if}

//    bEdited := TRUE;
    EnableDisable;
  end;{if}


//  btnSave.Enabled := bEdited = TRUE;

//  SaveChanges(cmbGLCode.Text);
end;

procedure TfrmMain.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
begin
{  if bEdited then begin
    if MessageDlg('You have not saved the changes that you made.'
    + #13 + #13 + 'Do you wish to save these changes now ?', mtConfirmation, [mbYes, mbNo], 0) = mrYes then SaveChanges(GetGLCode);}
{  end;{if}
end;

procedure TfrmMain.btnTestClick(Sender: TObject);
var
  frmTest : TfrmTest;
//  bSaved : boolean;
begin
//  bSaved := FALSE;
{  if bEdited then begin
    if MessageDlg('To test your new configuration, you must first save the changes that you have made.'
    + #13 + #13 + 'Do you wish to continue, and save these changes now ?', mtConfirmation, [mbYes, mbNo], 0) = mrYes then begin
      SaveChanges(GetGLCode);
      bSaved := TRUE;
    end;{if}
{  end;{if}

//  if (not bEdited) or bSaved then begin
    frmTest := TfrmTest.Create(Self);
    try
      frmTest.sDataPath := IncludeTrailingBackslash(Trim(TCompanyInfo(cmbCompany.Items.Objects
      [cmbCompany.ItemIndex]).Path));
      frmTest.edGLCode.Text := cmbGLCode.Text;
      frmTest.ShowModal;
    finally
      frmTest.Release;
    end;{try}
//  end;{if}
end;

procedure TfrmMain.btnCopyMouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  if (Button = mbLeft) then
  begin
    CopyBtnMenu.Items[0].Enabled := (cmbCompany.Items.Count > 1);
    CopyBtnMenu.Popup( X + TForm(TButton(Sender).Owner).Left + TButton(Sender).Left - TButton(Sender).Width,
                       Y + TForm(TButton(Sender).Owner).Top + TButton(Sender).Top + TButton(Sender).Height );
  end;
end;

procedure TfrmMain.btnCopyCompany(Sender: TObject);
var
  frmCopy : TfrmCopy;
begin
  frmCopy := TfrmCopy.Create(Self);
  try
    FillCompanyList(frmCopy.cmbSource);
    FillCompanyList(frmCopy.cmbDestination);
    frmCopy.cmbSource.ItemIndex := cmbCompany.ItemIndex;

    if frmCopy.ShowModal = mrOK then
    begin
      FillLists;
      iCompItemIndex := cmbCompany.ItemIndex;
    end;
  finally
    frmCopy.Release;
  end;{try}
end;

procedure TfrmMain.btnCopyGL(Sender: TObject);
var
  frmCopyGLCode: TfrmCopyGLCode;
begin
  frmCopyGLCode := TfrmCopyGLCode.Create(Self);
  try
    with frmCopyGLCode do
    begin
      with cmbGLCode do
      begin
        cbSourceGL.Items := Items;
        cbSourceGL.ItemIndex := ItemIndex;
        cbDestinationGL.Items := Items;
        cbDestinationGL.ItemIndex := ItemIndex;
      end;
//      CopyGLIni := TInifile.create(IncludeTrailingBackslash(Trim(TCompanyInfo(cmbCompany.Items.Objects
//        [iCompItemIndex]).Path)) + CCDEPTINI);
      ShowModal;
    end;
  finally
//    frmCopyGLCode.CopyGLIni.Free;
    frmCopyGLCode.Release;
  end; // try...finally*)
end;

procedure TfrmMain.Exit1Click(Sender: TObject);
begin
  Close;
end;

procedure TfrmMain.About1Click(Sender: TObject);
begin
  MessageDlg(sPlugInName + ' Configuration.' + #13#13 +
             ExchequerModuleVersion (emGenericPlugIn, sVersionNo) + #13#13 +
             DoubleAmpers(GetCopyrightMessage) + #13, mtInformation,[mbOK],0);
end;

procedure TfrmMain.rbClick(Sender: TObject);
begin
//  if not bFormOpening then begin
  if not bCompanyChanging then begin
    if CombinationsAreStored then
    begin
      if MessageDlg('If you change the way in which the CC/Dept combinations are defined,'#13
      + 'all your current settings will be deleted from this company.'#13#13
      + 'Are you sure you want to delete all your current settings for this company ?'
      , mtWarning, [mbYes, mbNo], 0) = mrYes then
      begin
        DeleteAllCombinations;
        cmbGLCode.Items.Clear;
        EnableDisable;
      end else
      begin
  //      bFormOpening := TRUE;
        bCompanyChanging := TRUE;
        if rbSame.Checked then
        begin
          rbDifferent.Checked := TRUE;
          rbDifferent.SetFocus;
        end else
        begin
          rbSame.Checked := TRUE;
          rbSame.SetFocus;
        end;
        bCompanyChanging := FALSE;
  //      bFormOpening := FALSE;
      end;{if}
    end;{if}
  end;{if}

  FillLists;
  EnableDisable;

  bUseGLs := rbDifferent.Checked;
  
//  if not bFormOpening then bRBEdited := TRUE;
end;

procedure TfrmMain.CheckGL;
var
//  CCIni : TInifile;
//  iPos : integer;
//  iDashPos : byte;
//  Sections : TStrings;
//  sCode : string;
  BTRec : TBTRec;
  CCDeptRec : TCCDeptRec;
begin
  // first record
  BTRec.Status := BTFindRecord(BT_GetFirst, aFileVar[CCDeptF], CCDeptRec
  , aBufferSize[CCDeptF], idxGetCombinations, BTRec.KeyS);

  if (BTRec.Status = 0) and (CCDeptRec.cdGLCode <> iNO_GL) then
  begin
    rbDifferent.Checked := TRUE;
    bUseGLs := TRUE;
    cmbGLCode.Items.Clear;
    ReadGLCodeStatus;
  end else
  begin
    bUseGLs := FALSE;
    cmbGLCode.Items.Clear;

    // Can't find any records with GLs in, but what does the ini file say ?
    bUseGLs := ReadGLCodeStatus;

    if bUseGLs then rbDifferent.Checked := TRUE
    else rbSame.Checked := TRUE;
  end;{if}

  if bUseGLs then
  begin
    while (BTRec.Status = 0) do
    begin

      if (CCDeptRec.cdGLCode = iGL_WILDCARD)
      and (cmbGLCode.Items.IndexOf(sGL_WILDCARD) = -1) then
      begin
        cmbGLCode.Items.Add(sGL_WILDCARD)
      end else
      begin
        if (cmbGLCode.Items.IndexOf(IntToStr(CCDeptRec.cdGLCode)) = -1)
        and (CCDeptRec.cdGLCode >= 0) then
        begin
          cmbGLCode.Items.Add(IntToStr(CCDeptRec.cdGLCode));
        end;{if}
      end;{if}

      // next record
      BTRec.Status := BTFindRecord(BT_GetNext, aFileVar[CCDeptF], CCDeptRec
      , aBufferSize[CCDeptF], idxGetCombinations, BTRec.KeyS);

    end;{while}

    if cmbGLCode.Items.Count > 0 then
    begin
      cmbGLCode.ItemIndex := 0;
      FillLists;
    end;
  end;{if}

(*
  {initialise variables}
  CCIni := TInifile.create(IncludeTrailingBackslash(Trim(TCompanyInfo(cmbCompany.Items.Objects
  [cmbCompany.ItemIndex]).Path)) + CCDEPTINI);

//  ClearList(cmbGLCode.Items);

  {Read values from ini file}
  with CCIni do begin
    UpdateFile;

    rbSame.Checked := TRUE;
    rbDifferent.Checked := (UpperCase(ReadString('Options', 'ByGLCode', 'FALSE')) = 'TRUE');

    Sections := TStringList.Create;
    ReadSections(Sections);

    For iPos := 0 to Sections.Count - 1 do begin
      iDashPos := Pos('-',Sections[iPos]);
      if (iDashPos > 1) then begin
        sCode := copy(Sections[iPos], 1, iDashPos -1);
        if cmbGLCode.Items.IndexOf(sCode) = -1 then cmbGLCode.Items.Add(sCode);
      end;{if}
    end;{for}
    if cmbGLCode.Items.Count > 0 then cmbGLCode.ItemIndex := 0;
    Sections.Free;
  end;{with}*)
end;
(*
function TfrmMain.GetGLCode : string;
begin
  if rbSame.Checked then Result := ''
  else begin
    if cmbGLCode.Text = ''
    then Result := '**NOCODE**'
    else Result := cmbGLCode.Text;
  end;{if}
end;
*)
procedure TfrmMain.cmbGLCodeChange(Sender: TObject);
begin
{  if bEdited then begin
    if MessageDlg('You have not saved the changes that you made to the previous GL Code.'
    + #13 + #13 + 'Do you wish to save these changes now ?', mtConfirmation, [mbYes, mbNo], 0) = mrYes then SaveChanges(sPrevGLCode);
    bEdited := FALSE;
  end;{if}
  sPrevGLCode := cmbGLCode.Text;
  FillLists;
  EnableDisable;
end;
(*
function TfrmMain.GetOppGLCode : string;
begin
  if not rbSame.Checked then Result := ''
  else begin
    if cmbGLCode.Text = ''
    then Result := '**NOCODE**'
    else Result := cmbGLCode.Text;
  end;{if}
end;
*)

procedure TfrmMain.btnAddCodeClick(Sender: TObject);
var
  FrmAddGLCode : TFrmAddGLCode;
begin
  FrmAddGLCode := TFrmAddGLCode.Create(Self);
  try
    if FrmAddGLCode.ShowModal = mrOK then begin
      if cmbGLCode.Items.IndexOf(FrmAddGLCode.edGLCode.Text) = -1 then
        begin
          cmbGLCode.Items.Add(FrmAddGLCode.edGLCode.Text);
          cmbGLCode.ItemIndex := cmbGLCode.Items.IndexOf(FrmAddGLCode.edGLCode.Text);
          cmbGLCodeChange(self);
        end
      else begin
        MsgBox('The GL Code : ' + FrmAddGLCode.edGLCode.Text + ' Already exists',mtError,[mbOK],mbOK,'Duplicate GL Code');
      end;{if}
    end;{if}
  finally
    FrmAddGLCode.Release;
  end;{try}
end;


procedure TfrmMain.bdsGetFieldValue(Sender: TObject; PData: Pointer;
  FieldName: String; var FieldValue: String);
begin
  with TCCDeptRec(PData^) do begin
    case FieldName[1] of
      'C' : FieldValue := cdCostCentre;
      'D' : FieldValue := cdDepartment;
      'V' : FieldValue := cdVATCode;
    end;{case}
  end;{with}
end;

procedure TfrmMain.EnableDisable;
begin
  lGLCode.Enabled := rbDifferent.Checked;
  cmbGLCode.Enabled := rbDifferent.Checked;
  btnAddCode.Enabled := rbDifferent.Checked;

  if pcCombinations.ActivePage = tsValid then
  begin
    btnEdit.Enabled := mlValid.Selected >= 0;
  end else
  begin
    btnEdit.Enabled := mlInvalid.Selected >= 0;
  end;{if}

  btnAdd.enabled := rbSame.Checked or (Trim(cmbGLCode.text) <> '');
  btnDelete.Enabled := btnEdit.Enabled;

  Add1.enabled := btnAdd.enabled;
  Edit1.Enabled := btnEdit.Enabled;
  Delete1.Enabled := btnDelete.Enabled;

  btnCopy.Enabled := mlValid.ItemsCount + mlInvalid.ItemsCount > 0;

end;

procedure TfrmMain.mlRowDblClick(Sender: TObject;
  RowIndex: Integer);
begin
  btnAddEditClick(btnEdit);
end;

procedure TfrmMain.pcCombinationsChange(Sender: TObject);
begin
  EnableDisable;
end;

procedure TfrmMain.ValidateVAT1Click(Sender: TObject);
var
  frmSystemSetup : TfrmSystemSetup;
begin
  frmSystemSetup := tfrmSystemSetup.Create(self);
  try
    frmSystemSetup.sDataPath := IncludeTrailingBackslash(Trim(TCompanyInfo(cmbCompany.Items.Objects
    [cmbCompany.ItemIndex]).Path));
    if frmSystemSetup.ShowModal = mrOK then
    begin
      mlValid.RefreshDB;
      mlInvalid.RefreshDB;
    end;{if}
  finally
    frmSystemSetup.Release;
  end;{try}
  ChangeVAT;
end;

procedure TfrmMain.ChangeVAT;
begin
  with TInifile.Create(Trim(TCompanyInfo(cmbCompany.Items.Objects[cmbCompany.ItemIndex]).Path)
  + INI_FILENAME) do
  begin
     bUseVAT := ReadBool('Settings','UseVAT', FALSE);
     Free;
  end;{with}

  if bUseVAT then
  begin
    mlValid.DesignColumns[0].Width := 80;
  end else
  begin
    mlValid.DesignColumns[0].Width := 110;
  end;

  mlValid.DesignColumns[2].Visible := bUseVAT;
  mlValid.DesignColumns[1].Width := mlValid.DesignColumns[0].Width;

  mlInValid.DesignColumns[2].Visible := bUseVAT;
  mlInValid.DesignColumns[0].Width := mlValid.DesignColumns[0].Width;
  mlInValid.DesignColumns[1].Width := mlValid.DesignColumns[1].Width;
end;

procedure TfrmMain.Import1Click(Sender: TObject);
begin
  SaveGLCodestatus;
  with TfrmImport.Create(self) do
  begin
    lCompany.Caption := cmbCompany.Text;
    try
      ShowModal;
      cmbCompanyChange(nil);
//      mlValid.RefreshDB;
//      mlInvalid.RefreshDB;
    finally
      release;
    end;{try}
  end;{with}
end;

procedure TfrmMain.CopyBtnMenuPopup(Sender: TObject);
begin
  CopytoGL.enabled := rbDifferent.Checked;
end;

procedure TfrmMain.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  SaveGLCodestatus;
end;

procedure TfrmMain.SaveGLCodestatus;
var
  iPos : integer;
begin
  with TInifile.Create(sCurrentCompanyPath + INI_FILENAME) do
  begin
     WriteBool('Settings','UseGLs', rbDifferent.Checked);

     EraseSection('GLCodes');

     if rbDifferent.Checked then
     begin
       For iPos := 0 to cmbGLCode.Items.Count-1 do
       begin
         WriteString('GLCodes',IntToStr(iPos), cmbGLCode.Items[iPos]);
       end;{for}
     end;{if}
     Free;
  end;{with}
end;

function TfrmMain.ReadGLCodeStatus : boolean;
var
  iPos : integer;
  slGLCodes : TStringList;
  sGL : string;
begin
  with TInifile.Create(sCurrentCompanyPath + INI_FILENAME) do
  begin
     Result := ReadBool('Settings','UseGLs', FALSE);

     if Result then
     begin
       // Add GL Codes from the ini file
       slGLCodes := TStringList.Create;
       ReadSection('GLCodes', slGLCodes);

       For iPos := 0 to slGLCodes.Count-1 do
       begin
         // is it already in the list ?
         sGL := ReadString('GLCodes',slGLCodes[iPos],'XXX');
         if (sGL <> 'XXX') and (cmbGLCode.Items.IndexOf(sGL) = -1) then
         begin
           // Add GL
           cmbGLCode.Items.Add(sGL);
         end;{if}
       end;{for}

       slGLCodes.Free;
     end;{if}

     Free;
  end;{with}
end;


procedure TfrmMain.RebuildDatafile1Click(Sender: TObject);
var
  BTRec : TBTRec;
  CCDeptRec : TCCDeptRec;
  iRecPos : integer;
begin
  if MessageDlg('Are you sure you wish to rebuild your datafile ?'
  , mtConfirmation, [mbYes, mbNo], 0) = mrYes then
  begin
    FillChar(BTRec.KeyS, SizeOf(BTRec.KeyS), #0);
    BTRec.Status := BTFindRecord(BT_StepFirst, aFileVar[CCDeptF], CCDeptRec
    , aBufferSize[CCDeptF], 0, BTRec.KeyS);

    while (BTRec.Status = 0) do
    begin
      // Save Current File Position
      if BTGetPosition(aFileVar[CCDeptF], CCDeptF, SizeOf(CCDeptRec), iRecPos) = 0 then
      begin
        // Fix Padding on CC/Depts
        CCDeptRec.cdCostCentre := PadString(psRight, CCDeptRec.cdCostCentre, ' ', 3);
        CCDeptRec.cdDepartment := PadString(psRight, CCDeptRec.cdDepartment, ' ', 3);

        // Save Updated Record
        BTRec.Status := BTUpdateRecord(aFileVar[CCDeptF], CCDeptRec, aBufferSize[CCDeptF], 0, BTRec.KeyS);
        if BTRec.Status = 0 then
        begin
          // updated OK
        end else
        begin
          BTShowError(BTRec.Status, 'BTUpdateRecord', aFileName[CCDeptF]);
        end;{if}

        // Go back to original file Position
        BTRestorePosition(aFileVar[CCDeptF], CCDeptF, CCDeptRec, SizeOf(CCDeptRec), 0, 0, iRecPos);
      end;{if}

      // next record
      BTRec.Status := BTFindRecord(BT_StepNext, aFileVar[CCDeptF], CCDeptRec
      , aBufferSize[CCDeptF], 0, BTRec.KeyS);
    end;{while}

    MsgBox('Datafile rebuild complete.', mtInformation, [mbOK], mbOK, 'Finished');
  end;{if}
end;

// v6.30.142
procedure TfrmMain.Export1Click(Sender: TObject);

  function GetCCDeptDesc(sCCDept : string3; bCC : boolean) : string;
  var
    oCCDept : ICCDept;
    iStatus : integer;
  begin{GetCCDeptDesc}
    Result := '';
    if bCC then oCCDept := oToolkit.CostCentre
    else oCCDept := oToolkit.Department;

    oCCDept.Index := cdIdxCode;
    iStatus := oCCDept.GetEqual(oCCDept.BuildCodeIndex(sCCDept));
    if iStatus = 0 then Result := oCCDept.cdName;
  end;{GetCCDeptDesc}

  function GetGLCodeDesc(iGLCode : integer) : string;
  var
    iStatus : integer;
  begin{GetCCDeptDesc}
    Result := '';
    oToolkit.GeneralLedger.Index := glIdxCode;
    iStatus := oToolkit.GeneralLedger.GetEqual(oToolkit.GeneralLedger.BuildCodeIndex(iGLCode));
    if iStatus = 0 then Result := oToolkit.GeneralLedger.glName;
  end;{GetCCDeptDesc}

var
  BTRec : TBTRec;
  CCDeptRec : TCCDeptRec;
  iLine, iNoOfRecords : integer;
  sFilename, sLine : string;
  slLines : TStringList;
begin
  if SaveDialog1.Execute then
  begin
    sFilename := SaveDialog1.FileName;
    iNoOfRecords := 0;
    FillChar(BTRec.KeyS, SizeOf(BTRec.KeyS), #0);

    {$IFDEF BROOKSBY}
      ////////////////////////////////////////////////
      // Bespoke Export for Brooksby Melton College //
      ////////////////////////////////////////////////

      slLines := TStringList.Create;

      // Read Records
      BTRec.Status := BTFindRecord(BT_StepFirst, aFileVar[CCDeptF], CCDeptRec
      , aBufferSize[CCDeptF], 0, BTRec.KeyS);

      while (BTRec.Status = 0) do
      begin
        // only export valid combinations
        if CCDeptRec.cdType = CD_VALID then
        begin
          // Create Line

          // NF: 22/03/2010 - ABSPLUG-86
          // Use Double quotes
//           sLine := CCDeptRec.cdCostCentre
//           + ',' + GetCCDeptDesc(CCDeptRec.cdCostCentre, TRUE)
//           + ',' + CCDeptRec.cdDepartment
//           + ',' + GetCCDeptDesc(CCDeptRec.cdDepartment, FALSE)
//           + ',' + IntToStr(CCDeptRec.cdGLCode)
//           + ',' + GetGLCodeDesc(CCDeptRec.cdGLCode);
           sLine := AnsiQuotedStr(CCDeptRec.cdCostCentre, '"')
           + ',' + AnsiQuotedStr(GetCCDeptDesc(CCDeptRec.cdCostCentre, TRUE), '"')
           + ',' + AnsiQuotedStr(CCDeptRec.cdDepartment, '"')
           + ',' + AnsiQuotedStr(GetCCDeptDesc(CCDeptRec.cdDepartment, FALSE), '"')
           + ',' + IntToStr(CCDeptRec.cdGLCode)
           + ',' + AnsiQuotedStr(GetGLCodeDesc(CCDeptRec.cdGLCode), '"');

           slLines.Add(PadString(psLeft, CCDeptRec.cdCostCentre, ' ', 3) + sLine);

          inc(iNoOfRecords);
        end;{if}

        // next record
        BTRec.Status := BTFindRecord(BT_StepNext, aFileVar[CCDeptF], CCDeptRec
        , aBufferSize[CCDeptF], 0, BTRec.KeyS);
      end;{while}

      // Sort and Export
      slLines.Sort;
      For iLine := 0 to slLines.Count-1 do
      begin
        // Export Line
        sLine := Copy(slLines[iLine], 4, 1000);
        AddLineToFile(sLine, sFilename, TRUE);
      end;{for}


      //Clear up
      slLines.Free;

    {$ELSE}

      /////////////////////
      // Standard Export //
      /////////////////////

      BTRec.Status := BTFindRecord(BT_StepFirst, aFileVar[CCDeptF], CCDeptRec
      , aBufferSize[CCDeptF], 0, BTRec.KeyS);

      while (BTRec.Status = 0) do
      begin
        // Add CC/Dept
        sLine := CCDeptRec.cdCostCentre + ',' + CCDeptRec.cdDepartment;

        // Add GL Code
        if rbSame.Checked then
        begin
          // Same GL Codes for Each combination
          sLine := sLine + ',0';
        end
        else
        begin
          // Different GL Codes for Each combination
          sLine := sLine + ',' + IntToStr(CCDeptRec.cdGLCode);
        end;{if}

        // Add VAT Code
        if bUseVAT then
        begin
          // Different VAT Codes for Each combination.
          sLine := sLine + ',' + CCDeptRec.cdVATCode;
        end
        else
        begin
          // Sames VAT Codes for Each combination.
          sLine := sLine + ',0';
        end;{if}

        // Add Type - V/I
        sLine := sLine + ',' + CCDeptRec.cdType;

        // Export Line
        AddLineToFile(sLine, sFilename, TRUE);

        inc(iNoOfRecords);

        // next record
        BTRec.Status := BTFindRecord(BT_StepNext, aFileVar[CCDeptF], CCDeptRec
        , aBufferSize[CCDeptF], 0, BTRec.KeyS);
      end;{while}

    {$ENDIF}

    MsgBox('Export complete.'#13#13 + IntToStr(iNoOfRecords) + ' Records Exported.'
    , mtInformation, [mbOK], mbOK, 'Finished');
  end;{if}
end;

end.
