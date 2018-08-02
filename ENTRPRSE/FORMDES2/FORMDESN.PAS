Unit FormDesn;

{ markd6 15:57 29/10/2001: Disabled Byte Alignment in Delphi 6.0 }
{$ALIGN 1}  { Variable Alignment Disabled }


interface

uses
  ShareMem, SysUtils, Windows, Messages, Classes, Graphics, Controls, Forms, Dialogs,
  ExtCtrls, StdCtrls, Menus, ComCtrls, Buttons, SbsScrll, PageComp,
  SBSDrag, DllInt, SBSList, GlobType, RpDevice, IniFiles, MRU, ToolWin,
  ImgList, AdvToolBar, AdvGlowButton, AdvToolBarStylers;

Const
  WM_ActivateFormDes = WM_USER + $100;

  { I VerModU.Pas}

type
  TForm_Designer = class(TForm)
    StatusBar1: TStatusBar;
    MainMenu: TMainMenu;
    Menu_File: TMenuItem;
    Menu_File_Exit: TMenuItem;
    Panel_Page: TPanel;
    Popup_Page: TPopupMenu;
    Popup_Page_Options: TMenuItem;
    Popup_Page_SepBar: TMenuItem;
    Popup_Page_Text: TMenuItem;
    Menu_File_New: TMenuItem;
    Menu_File_SaveAs: TMenuItem;
    Menu_File_Save: TMenuItem;
    Menu_File_Open: TMenuItem;
    Menu_Help: TMenuItem;
    Menu_Help_About: TMenuItem;
    Menu_Help_SepBar1: TMenuItem;
    Menu_Help_Contents: TMenuItem;
    Menu_Edit: TMenuItem;
    Menu_Edit_Paste: TMenuItem;
    Menu_Edit_Copy: TMenuItem;
    Menu_Edit_Cut: TMenuItem;
    Popup_Text: TPopupMenu;
    Popup_Text_Options: TMenuItem;
    Popup_Page_Order: TMenuItem;
    Popup_Text_SepBar2: TMenuItem;
    Popup_Text_Front: TMenuItem;
    Popup_Text_Back: TMenuItem;
    Popup_Text_Align: TMenuItem;
    Popup_Page_SepBar2: TMenuItem;
    Popup_Page_Line: TMenuItem;
    Popup_Page_Bitmap: TMenuItem;
    Popup_Bitmap: TPopupMenu;
    Popup_Bitmap_Align: TMenuItem;
    Popup_Bitmap_Front: TMenuItem;
    Popup_Bitmap_Back: TMenuItem;
    Popup_Bitmap_SepBar1: TMenuItem;
    Popup_Bitmap_Options: TMenuItem;
    Popup_Page_Box: TMenuItem;
    Popup_Page_Database: TMenuItem;
    Popup_Page_Table: TMenuItem;
    Popup_Page_Field: TMenuItem;
    Popup_Page_PageNo: TMenuItem;
    Popup_Page_Formula: TMenuItem;
    Menu_File_SepBar2: TMenuItem;
    Menu_File_Print: TMenuItem;
    Menu_File_Preview: TMenuItem;
    Popup_Bitmap_SepBar2: TMenuItem;
    Popup_Bitmap_Edit: TMenuItem;
    Menu_Options: TMenuItem;
    Menu_Options_PaperSizes: TMenuItem;
    Menu_Options_Page: TMenuItem;
    Menu_Options_SepBar1: TMenuItem;
    Menu_Options_Grid: TMenuItem;
    FormController: TSBSController;
    SBSPage1: TSBSPage;
    Menu_File_SepBar3: TMenuItem;
    Menu_File_Delete: TMenuItem;
    OpenDialog: TOpenDialog;
    Menu_Options_FormDefs: TMenuItem;
    Menu_Options_SepBar2: TMenuItem;
    SaveDialog: TSaveDialog;
    Menu_Controls: TMenuItem;
    Menu_Ctrl_Text: TMenuItem;
    Menu_Ctrl_Bitmap: TMenuItem;
    Menu_Ctrl_Box: TMenuItem;
    Menu_Ctrl_Line: TMenuItem;
    Menu_Ctrl_Database: TMenuItem;
    Menu_Ctrl_DB_Formula: TMenuItem;
    Menu_Ctrl_DB_Table: TMenuItem;
    Menu_Ctrl_DB_Field: TMenuItem;
    Menu_Ctrl_PageNo: TMenuItem;
    Menu_Ctrl_SepBar1: TMenuItem;
    Menu_Ctrl_Order: TMenuItem;
    Menu_Options_SepBar3: TMenuItem;
    Menu_Options_Toolbar: TMenuItem;
    Menu_Options_StatusLine: TMenuItem;
    Popup_Bitmap_SepBar3: TMenuItem;
    Popup_Bitmap_If: TMenuItem;
    Popup_Group: TPopupMenu;
    Popup_Group_Align: TMenuItem;
    Popup_Group_Front: TMenuItem;
    Popup_Group_Back: TMenuItem;
    Popup_Group_SepBar2: TMenuItem;
    Popup_Group_If: TMenuItem;
    Popup_Group_SepBar1: TMenuItem;
    Popup_Group_NewRow: TMenuItem;
    Popup_Group_DeleteRow: TMenuItem;
    Menu_Ctrl_Group: TMenuItem;
    Popup_Page_Group: TMenuItem;
    Menu_Ctrl_SepBar2: TMenuItem;
    Menu_Ctrl_DelCtrl: TMenuItem;
    Menu_Help_SepBar2: TMenuItem;
    Menu_Help_TechSuppRep: TMenuItem;
    Menu_File_Form: TMenuItem;
    Menu_File_Label: TMenuItem;
    Popup_Box: TPopupMenu;
    MenuItem1: TMenuItem;
    MenuItem2: TMenuItem;
    MenuItem3: TMenuItem;
    MenuItem4: TMenuItem;
    MenuItem5: TMenuItem;
    Popup_Text_Font: TMenuItem;
    Popup_Text_If: TMenuItem;
    Popup_Box_If: TMenuItem;
    Menu_Options_PrnCodes: TMenuItem;
    Menu_Options_PCCDefs: TMenuItem;
    Menu_File_Reopen: TMenuItem;
    Menu_File_SepBar: TMenuItem;
    N01: TMenuItem;
    N11: TMenuItem;
    N21: TMenuItem;
    N31: TMenuItem;
    N41: TMenuItem;
    N51: TMenuItem;
    N61: TMenuItem;
    N71: TMenuItem;
    N81: TMenuItem;
    N91: TMenuItem;
    Menu_Help_DictRep: TMenuItem;
    Menu_Options_Signatures: TMenuItem;
    AdvDockPanel: TAdvDockPanel;
    AdvToolBar: TAdvToolBar;
    Btn_Preview: TAdvGlowButton;
    Btn_Print: TAdvGlowButton;
    Btn_Save: TAdvGlowButton;
    Btn_Line: TAdvGlowButton;
    AdvToolBarSeparator1: TAdvToolBarSeparator;
    Btn_Open: TAdvGlowButton;
    Btn_NewLabel: TAdvGlowButton;
    AdvToolBarSeparator2: TAdvToolBarSeparator;
    Btn_NewForm: TAdvGlowButton;
    Btn_DefFont: TAdvGlowButton;
    AdvToolBarSeparator3: TAdvToolBarSeparator;
    Btn_Box: TAdvGlowButton;
    btn_Bitmap: TAdvGlowButton;
    Btn_Text: TAdvGlowButton;
    AdvToolBarSeparator4: TAdvToolBarSeparator;
    Btn_Group: TAdvGlowButton;
    Btn_Page: TAdvGlowButton;
    Btn_Formula: TAdvGlowButton;
    btn_DbTable: TAdvGlowButton;
    Btn_DbField: TAdvGlowButton;
    AdvToolBarSeparator5: TAdvToolBarSeparator;
    Btn_Close: TAdvGlowButton;
    Btn_Help: TAdvGlowButton;
    AdvStyler: TAdvToolBarOfficeStyler;
    AdvGlowMenuButton1: TAdvGlowMenuButton;
    PopupMenu1: TPopupMenu;
    bsOffice2003Blue1: TMenuItem;
    bsOffice2003Classic1: TMenuItem;
    bsOffice2003Olive1: TMenuItem;
    bsOffice2003Silver1: TMenuItem;
    bsOffice2007Luna1: TMenuItem;
    bsOffice2007Obsidian1: TMenuItem;
    bsOffice2007Silver1: TMenuItem;
    bsOfficeXP1: TMenuItem;
    bsWhidbeyStyle1: TMenuItem;
    bsWindowsXP1: TMenuItem;
    procedure Menu_File_ExitClick(Sender: TObject);
    procedure Popup_Page_OptionsClick(Sender: TObject);
    procedure Popup_Text_OptionsClick(Sender: TObject);
    procedure Popup_Page_OrderClick(Sender: TObject);
    procedure Popup_Text_FrontClick(Sender: TObject);
    procedure Popup_Text_BackClick(Sender: TObject);
    procedure Popup_Box_(Sender: TObject);
    procedure Popup_Page_TextClick(Sender: TObject);
    procedure Popup_Page_BitmapClick(Sender: TObject);
    procedure Popup_Page_BoxClick(Sender: TObject);
    procedure Popup_Page_LineClick(Sender: TObject);
    procedure Popup_Page_FieldClick(Sender: TObject);
    procedure Popup_Page_TableClick(Sender: TObject);
    procedure Popup_Page_FormulaClick(Sender: TObject);
    procedure Popup_Page_PageNoClick(Sender: TObject);
    procedure Menu_File_NewClick(Sender: TObject);
    procedure Menu_File_OpenClick(Sender: TObject);
    procedure Menu_File_SaveClick(Sender: TObject);
    procedure Menu_File_SaveAsClick(Sender: TObject);
    procedure Menu_File_PrintClick(Sender: TObject);
    procedure Menu_File_PreviewClick(Sender: TObject);
    procedure Popup_Bitmap_EditClick(Sender: TObject);
    procedure SBSPage1Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure Menu_File_DeleteClick(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FormControllerFieldOptions(Sender: TObject);
    procedure FormControllerBitmapOptions(Sender: TObject);
    procedure FormControllerBoxOptions(Sender: TObject);
    procedure FormControllerFormulaOptions(Sender: TObject);
    procedure FormControllerLineOptions(Sender: TObject);
    procedure FormControllerPageNoOptions(Sender: TObject);
    procedure FormControllerTableOptions(Sender: TObject);
    procedure FormControllerTextOptions(Sender: TObject);
    procedure Menu_Options_GridClick(Sender: TObject);
    procedure Menu_Help_AboutClick(Sender: TObject);
    procedure Menu_Options_FormDefsClick(Sender: TObject);
    procedure Menu_Options_PaperSizesClick(Sender: TObject);
    procedure SBSPage1Message(Sender: TObject; Idx: Integer; Msg: string);
    procedure OnApplHint(Sender: TObject);
    procedure Menu_Options_ToolbarClick(Sender: TObject);
    procedure Menu_Options_StatusLineClick(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure Popup_Bitmap_IfClick(Sender: TObject);
    procedure FormControllerIf(Sender: TObject; IfLabel: TObject);
    procedure Menu_Edit_CopyClick(Sender: TObject);
    procedure Menu_Edit_CutClick(Sender: TObject);
    procedure Menu_Edit_PasteClick(Sender: TObject);
    procedure Popup_Group_NewRowClick(Sender: TObject);
    procedure Popup_Group_DeleteRowClick(Sender: TObject);
    procedure SpButt_GroupClick(Sender: TObject);
    procedure FormControllerGroupOptions(Sender: TObject);
    procedure Menu_Ctrl_DelCtrlClick(Sender: TObject);
    procedure FormControllerZOrder(Sender: TObject);
    procedure Menu_Help_TechSuppRepClick(Sender: TObject);
    procedure SuppQFBtnClick(Sender: TObject);
    procedure Menu_Help_ContentsClick(Sender: TObject);
    procedure Menu_OptionsClick(Sender: TObject);
    procedure spButt_DefFontClick(Sender: TObject);
    procedure Popup_Text_FontClick(Sender: TObject);
    procedure Menu_Options_PrnCodesClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure Menu_Options_PCCDefsClick(Sender: TObject);
    procedure ReopenClick(Sender: TObject);
    procedure Menu_Help_DictRepClick(Sender: TObject);
    procedure Menu_Options_SignaturesClick(Sender: TObject);
    procedure bsOffice2003Blue1Click(Sender: TObject);
  private
    { Private declarations }
    OrigCaption  : String;
    WantShutdown : Boolean;
    FormMRU      : TMRU;
    CompanyName  : ShortString;
    LoadedFName  : ShortString;
    procedure ActivateApp(var Msg: TMessage); message WM_ActivateFormDes;
    Procedure ClearDetailsList (Var TheList : TSBSList);
    procedure GetDetailsList (Var TheList : TSBSList);
    procedure OpenForm (FormName : ShortString);
    procedure PrintDef (Const WantPreview : Boolean;Const PrnSetup : TSBSPrintSetupInfo);
    procedure PrintProgress(var Msg: TMessage); message WM_PrintProgress;
    procedure Shutdown;

    procedure ApplicationActive(Sender : TObject);
    procedure EntDeActivate(Sender : TObject);
  public
    { Public declarations }
    Procedure SetCaption (Const FName : String);
  end;

var
  Form_Designer: TForm_Designer;
  FormDetailsList: TSBSList;

implementation

{$R *.DFM}
{$R WinXPMan.Res}

Uses GlobVar, FormUtil, PageOptn, TextOpt, BoxOpt,
     LineOpt, PagNoOpt, GridOpt, Restore, Zorder2,
     Techsupp, GfxUtil, EntLicence,
     History;  // Form Designer History & Version

Const
  RunNorm = '/RUNNORM';
  DbgOpen = '/DBGOPEN';

procedure TForm_Designer.FormCreate(Sender: TObject);
Var
  PrevCur             : TCursor;
  I, ErrCode, PLen    : Integer;
  Path1, Path2, Tmp1  : String;
  LI                  : LongInt;

  Function ConstStr (Const TheChar : Char; It : Byte) : String;
  Var
    I : LongInt;
  Begin
    Result := '';
    If (I > 0) Then
      For I := 1 To It Do
        Result := Result + TheChar;
  End;

begin
//ShowMessage ('TForm_Designer.FormCreate');
  CursorToHourglass (PrevCur);

  // MH 08/02/06: Mods to hide 'Exchequer'
  If (EnterpriseLicence.elProductType In [ptLITECust, ptLITEAcct]) Then
  Begin
    Caption := 'Form Designer';
    Menu_Options_FormDefs.Caption := 'System Setup - Default Forms';
    Menu_Options_Signatures.Caption := 'System Setup - Email Signatures';
  End; // If (EnterpriseLicence.elProductType In [ptLITECust, ptLITEAcct])

  { take copy of caption to use as basis of filename captions }
  OrigCaption := Caption;

  { Set Tag to 1010, so window can be ID'd uniquely }
  SetWindowLong (Handle, GWL_USERDATA, 1010);

  { redirect help file to full path }
  Application.HelpFile := ExtractFilePath(Application.ExeName) + Application.HelpFile;

  { Initialise to bog-standard El-Cheapo package }
  SystemInfo.ExVersionNo := 1;
  SystemInfo.ExDataPath  := PathToShort (SplitFileName(Application.EXEName).Path);
  SystemInfo.FormDesVer  := FormDesVer;
  SystemInfo.DebugOpen   := False;

  { Decode command line params }
  If (ParamCount > 0) Then
    For I := 1 To ParamCount Do Begin
      { Check for Exch Version flag }
      If (Copy (ParamStr(I), 1, Length(VerParamStr)) = VerParamStr) Then
        With SystemInfo Do Begin
          { Got Exchequer version value }
          Tmp1 := Copy (ParamStr(I), (Length(VerParamStr) + 1), (Length(ParamStr(I)) - Length(VerParamStr)));
          Val (Tmp1, ExVersionNo, ErrCode);
        End; { If }

      If (Copy (ParamStr(I), 1, Length(PathParamStr)) = PathParamStr) And (I < ParamCount) Then
        With SystemInfo Do Begin
          { Got Exchequer Data Path value }
          ExDataPath := ParamStr(I + 1);
          If (ExDataPath[Length(ExDataPath)] <> '\') Then ExDataPath := ExDataPath + '\';
        End; { If }

      If (Copy (ParamStr(I), 1, Length(RunNorm)) = RunNorm) Then
        WindowState := wsNormal;

      If (Copy (ParamStr(I), 1, Length(DbgOpen)) = DbgOpen) Then
        SystemInfo.DebugOpen := True;

      If (UpperCase(ParamStr(I)) = '/DBG') Then Begin
        Menu_Help_DictRep.Visible := True;
      End; { If }
    End; { For }

  { Load DLL and Initialise }
  SystemInfo.MainForm := Self;
  SystemInfo.AppHandle := Application;
  SystemInfo.ControllerHandle := FormController;
  If (Not sbsForm_Initialise2 (SystemInfo, TxLateCR, ClassicTB)) Then
    Application.Terminate
  Else
    WantShutdown := True;

  // MH 07/06/07: Added to try and workaround problems with HTML Help and the
  // form being made inactive/sent to back
  sbsForm_ShareScreen (Screen);

  { Initialise new form def }
  FormController.FormDetails.InitDefaultForm;

  {remove the drag option from the toolbar}
  AdvStyler.DragGripStyle := dsNone;


  Application.OnHint := OnApplHint;

  CursorToPointer;

  { Disable print buttons if no printers available }
  {SpButt_Print.Enabled := (RpDev.Printers.Count > 0);
  SpButt_Preview.Enabled := SpButt_Print.Enabled;}
  Btn_Print.Enabled := (RpDev.Printers.Count > 0);
  Btn_Preview.Enabled := Btn_Print.Enabled;


  {Menu_File_Print.Enabled := SpButt_Print.Enabled;
  Menu_File_Preview.Enabled := SpButt_Print.Enabled;}
  Menu_File_Print.Enabled := Btn_Print.Enabled;
  Menu_File_Preview.Enabled := Btn_Print.Enabled;


  { Setup Most Recently Used List }
  FormMRU := TMRU.Create('FormDes.Opt',Menu_File_Reopen,Menu_File_SepBar);

  // HM 31/01/02: Added code to switch application title
  CompanyName := GetCompanyName;
  SetCaption ('');

  Application.OnActivate   := ApplicationActive;
  Application.OnDeactivate := EntDeActivate;
  Application.OnMinimize   := EntDeActivate;
  Application.OnRestore    := ApplicationActive;
end;

procedure TForm_Designer.Shutdown;
Var
  MRUIni : TIniFile;
Begin
  If WantShutdown Then Begin
    { Write MRU List to .INI File }
    FormMRU.UpdateList;
    FormMRU.Destroy;

    Application.OnHint := Nil;
    Application.OnActivate   := Nil;
    Application.OnDeactivate := Nil;
    Application.OnMinimize   := Nil;
    Application.OnRestore    := Nil;

    sbsForm_DeInitialise;
    WantShutdown := False;
  End; { If }
End;

procedure TForm_Designer.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  Shutdown;
end;

procedure TForm_Designer.FormDestroy(Sender: TObject);
begin
  { shutdown DLL }
  Shutdown;
end;

{ Hint event for TApplication }
procedure TForm_Designer.OnApplHint(Sender: TObject);
begin
  StatusBar1.Panels[msgidx_ApplHints].Text := Application.Hint;
end;

{ Check to see if any changes made }
procedure TForm_Designer.FormCloseQuery(Sender: TObject;
  var CanClose: Boolean);
Var
  mbRet : Word;
begin
  { check for changes }
  If FormController.FormDetails.ChangesMade Then Begin
    { Changes have been made - ask if they want to abandon }
    mbRet := MessageDlg('Changes have been made, do you want to save them?',
                        mtWarning,
                        mbYesNoCancel,
                        0);

    If (mbRet = mrYes) Then
      { Save current and open specified }
      Menu_File_SaveClick(Sender);

    CanClose := (mbRet <> mrCancel);
  End { If }
  Else
    CanClose := True;
end;

procedure TForm_Designer.SBSPage1Message(Sender: TObject; Idx: Integer;
  Msg: string);
begin
  If (Idx In [0..(StatusBar1.Panels.Count-1)]) Then
    StatusBar1.Panels[Idx].Text := Msg;
end;

procedure TForm_Designer.Menu_File_ExitClick(Sender: TObject);
begin
  Close;
end;

procedure TForm_Designer.Popup_Page_OptionsClick(Sender: TObject);
Var
  PrevCur  : TCursor;
begin
  CursorToHourglass (PrevCur);

  Try
    Form_PageOptions := TForm_PageOptions.Create (Self);

    Form_PageOptions.SetControls (FormController, True);

    CursorForDialog;
    Form_PageOptions.ShowModal;
    CursorFromDialog;

    If Form_PageOptions.Ok Then Begin
      { Ok pressed }
      FormController.ChangeMade;
    End; { If }
  Finally
    Form_PageOptions.Release;
  End;

  RestoreCursor (PrevCur);
end;

{ Sets the order of the controls drawing }
procedure TForm_Designer.Popup_Page_OrderClick(Sender: TObject);
begin
  FormController.ChangeZOrder;
end;

procedure TForm_Designer.Popup_Text_OptionsClick(Sender: TObject);
begin
  { text options dialog }
  FormController.ControlOptions;
end;

procedure TForm_Designer.Popup_Text_FrontClick(Sender: TObject);
begin
  FormController.ControlToFront;
end;

procedure TForm_Designer.Popup_Text_BackClick(Sender: TObject);
begin
  FormController.ControlToBack;
end;

procedure TForm_Designer.Popup_Box_(Sender: TObject);
begin
  FormController.AlignControl;
end;

procedure TForm_Designer.Popup_Group_DeleteRowClick(Sender: TObject);
begin
  FormController.Control2;
end;

procedure TForm_Designer.Popup_Group_NewRowClick(Sender: TObject);
begin
  FormController.Control1;
end;

procedure TForm_Designer.Popup_Page_TextClick(Sender: TObject);
begin
  FormController.CreateNewControl (ctText);
end;

procedure TForm_Designer.Popup_Page_BitmapClick(Sender: TObject);
begin
  FormController.CreateNewControl (ctBitmap);
end;

procedure TForm_Designer.Popup_Page_BoxClick(Sender: TObject);
begin
  FormController.CreateNewControl (ctBox);
end;

procedure TForm_Designer.Popup_Page_LineClick(Sender: TObject);
begin
  FormController.CreateNewControl (ctLine);
end;

procedure TForm_Designer.Popup_Page_FieldClick(Sender: TObject);
begin
  FormController.CreateNewControl (ctDbField);
end;

procedure TForm_Designer.Popup_Page_TableClick(Sender: TObject);
Var
  TheControl : TSBSDragControl;
  I          : Integer;
  GotOne     : Boolean;
begin
  { Check its a form, not a label }
  If (FormController.FormDetails.ftFormType = ftForm) Then Begin
    { need to check they don't already have a table, as only one }
    { table control can be placed on a form                      }
    GotOne := False;

    If (FormController.ControlList.Count > 0) Then
      For I := 0 To (FormController.ControlList.Count - 1) Do Begin
        { Get a local copy of the control }
        TheControl := TSBSDragControl(FormController.ControlList.Items[I]);

        If (Not GotOne) Then
          GotOne := (TheControl.GetDefRec.fdFieldClass = fdcTable);
      End; { For }

    If (Not GotOne) Then
      FormController.CreateNewControl (ctDbTable)
    Else Begin
      MessageDlg('A Database Table already exists on this form',
                 mtInformation,
                 [mbOk],
                 0);

      { Go to control ? }
    End; { Else }
  End { If }
  Else Begin
    { Not a form }
    MessageDlg('Database Tables can only be used with forms.',
               mtInformation,
               [mbOk],
               0);
  End; { Else }
end;

procedure TForm_Designer.Popup_Page_FormulaClick(Sender: TObject);
begin
  FormController.CreateNewControl (ctDbFormula);
end;

procedure TForm_Designer.Popup_Page_PageNoClick(Sender: TObject);
begin
  FormController.CreateNewControl (ctPage);
end;

{ New Form }
procedure TForm_Designer.Menu_File_NewClick(Sender: TObject);
Var
  PrevCur  : TCursor;
  mbRet    : Word;
begin
  CursorToHourglass (PrevCur);

  { Check existing form for changes }
  If FormController.FormDetails.ChangesMade Then Begin
    { Changes have been made - ask if they want to abandon }
    mbRet := MessageDlg('Changes have been made, do you want to save them?',
                        mtWarning,
                        mbYesNoCancel,
                        0);

    If (mbRet = mrYes) Then
      { Save current and open specified }
      Menu_File_SaveClick(Sender);
  End { If }
  Else
    { Open new definition }
    mbRet := mrYes;

  If (mbRet = mrYes) Or (mbRet = mrNo) Then Begin
    { Initialise variables for a new form }
    LockWindowUpdate(Handle);          { disable window painting }
    SetCaption ('');

    {If (Sender = Menu_File_Form) Or (Sender = SpButt_NewForm) Then}
    if (Sender = Menu_File_Form) Or (Sender = Btn_NewForm) Then
      FormController.FormDetails.InitDefaultForm
    Else
      FormController.FormDetails.InitDefaultLabel;

    FormController.FormDetails.ChangesMade := False;
    LockWindowUpdate(0);               { enable window painting }
    Refresh;

    { display the options dialog }
    Popup_Page_OptionsClick(Sender);
  End; { If }

  RestoreCursor (PrevCur);
end;

{ open form/label/report }
procedure TForm_Designer.Menu_File_OpenClick(Sender: TObject);
Var
  PrevCur   : TCursor;
  CurDirStr : String;
begin
  CursorToHourglass (PrevCur);

  CurDirStr := GetCurrentDir;

  OpenDialog.InitialDir := SystemInfo.ExDataPath + FormsPath;

  If OpenDialog.Execute Then Begin
    SetCurrentDir(CurDirStr);

    { Open Form }
    OpenForm (OpenDialog.FileName);
  End { If }
  Else Begin
    SetCurrentDir(CurDirStr);
  End; { Else }

  RestoreCursor (PrevCur);
End;

procedure TForm_Designer.OpenForm (FormName : ShortString);
Var
  HedRec    : fdHeaderRecType;
  StrRec    : fdFormStringsType;
  ListObj   : TFormDefListObjType;
  Continue  : Boolean;
  mbRet, I  : Word;
  FName     : String;
  FileInfo  : SplitFNameType;
Begin { OpenForm }
  If (Trim(FormName) <> '') Then Begin
    FileInfo := SplitFileName(Trim(FormName));
    If (FileInfo.Extension = '') Then FileInfo.Extension := DefExtension;

    If ValidFormDef (FileInfo, True) Then Begin
      { check current def for changes }
      If FormController.FormDetails.ChangesMade Then Begin
        { Changes have been made - ask if they want to abandon }
        mbRet := MessageDlg('Changes have been made, do you want to save them?',
                            mtWarning,
                            mbYesNoCancel,
                            0);

        If (mbRet = mrYes) Then
          { Save current and open specified }
          Menu_File_SaveClick(Self);
      End { If }
      Else
        { Open new definition }
        mbRet := mrYes;

      If (mbRet = mrYes) Or (mbRet = mrNo) Then Begin
        { Clear out any current controls }
        LockWindowUpdate(Handle);          { disable window painting }
        FormController.ClearSelectList;
        FormController.ClearControlList;
        FormController.ClearHistoryList;
        LockWindowUpdate(0);               { enable window painting }

        FormController.FormDetails.ftFormPath := FileInfo.PathName;

        { Create the list for the control details }
        FormDetailsList := TSBSList.CreateList('Open');
        Try
          { Get form definition details }
          If OpenFormDef (FormController.FormDetails.ftFormPath, HedRec, StrRec, FormDetailsList) Then Begin
            SetCaption (FileInfo.FileName);

            { stop any updating of this window while new controls load }
            LockWindowUpdate(Handle);

            { Copy register record into form details }
            FormController.FormDetails.HedRecToDetails (HedRec);
            FormController.FormDetails.StrRecToDetails (StrRec);

            While (FormDetailsList.Count > 0) Do Begin
              ListObj := TFormDefListObjType(FormDetailsList.Items[0]);
              FormDetailsList.Delete (0);
              FormController.CreateControl (ListObj.FormDef, False);
              ListObj.Free;
            End; { While }

            FormController.FormDetails.ChangesMade := False;

            { Move to top-left }
            SBSPage1.VertScrollBar.Position := 0;
            SBSPage1.HorzScrollBar.Position := 0;

            FormMRU.AddToMRU(FileInfo.Name);

            { restore updating of window }
            LockWindowUpdate(0);
          End { If }
          Else
            MessageDlg('The definition cannot be opened.', mtError, [mbOk], 0);
        Finally
          FormDetailsList.Free;
        End;
      End; { If }
    End; { If }
  End; { If }
end; { OpenForm }

{ save current form/label/report }
procedure TForm_Designer.Menu_File_SaveClick(Sender: TObject);
Var
  HedRec     : fdHeaderRecType;
  StrRec     : fdFormStringsType;
  DefObj     : TFormDefListObjType;
  TheControl : TSBSDragControl;
  PrevCur    : TCursor;
  I          : Integer;
begin
  CursorToHourglass (PrevCur);

  { Check we have a valid name }
  If (Not FormController.FormDetails.ValidatePath) Then Begin
    { Not a valid name, do Save As }
    Menu_File_SaveAsClick(Sender);
  End { If }
  Else
    With FormController.FormDetails do Begin
      { Got a valid name, save details }
      FormController.FormDetails.DetailsToHedRec (HedRec);
      FormController.FormDetails.DetailsToStrRec (StrRec);

      FormDetailsList := TSBSList.CreateList('Save');
      Try
        { Get a list of the control definitions }
        GetDetailsList (FormDetailsList);

        { Save details }
        SaveFormDef (FormController.FormDetails.ftFormPath, HedRec, StrRec, FormDetailsList);

        FormController.FormDetails.ChangesMade := False;
      Finally
        { Free objects in list and then the list }
        ClearDetailsList (FormDetailsList);
        FormDetailsList.Free;
      End;
    End; { With }

  RestoreCursor (PrevCur);
end;

{ save the current form/label/report under a new name }
procedure TForm_Designer.Menu_File_SaveAsClick(Sender: TObject);
Var
  PrevCur : TCursor;
  FName   : String;
  AOK     : Boolean;
begin
  CursorToHourglass (PrevCur);

  With FormController.FormDetails Do
    If (Pos ('.', ftFormPath) > 1) Then
      FName := Copy (ftFormPath, 1, Pos ('.', ftFormPath) - 1)
    Else
      FName := '';

  SaveDialog.FileName := FName;
  SaveDialog.InitialDir := SystemInfo.ExDataPath + FormsPath;

  Repeat
    AOK := SaveDialog.Execute;

    If AOK Then Begin
      { reformat filename and add extension if necessary }
      FName := UpperCase(Trim(SaveDialog.FileName));
      If (Pos (DefDotExtension, FName) = 0) Then
        FName := FName + DefDotExtension;

      If (Length(Fname) > 0) And (SplitFileName(FName).FileName[1] <> '.') Then Begin
        If (Trim(SplitFileName(FName).FileName) <> '') Then Begin
          { Check file doesn't exist }
          If (FName <> FormController.FormDetails.ftFormPath) Then
            If FileExists(FName) Then
              AOK := (MessageDlg (FName + #10#13#10#13 +
                                  'This file already exists.' + #10#13#10#13 +
                                  'Replace existing file?', mtWarning, [mbYes, mbNo], 20100) = mrYes);
        End { If }
        Else
          { invalid name }
          AOK := False;
      End { If }
      Else
        { invalid name }
        AOK := False;
    End { If }
    Else Begin
      { Save Dialog was cancelled }
      AOK := False;
      Break;
    End; { If }
  Until AOK;

  If AOK Then Begin
    FormController.FormDetails.ftFormPath := FName;
    SetCaption (SplitFileName(FName).FileName);

    FormMRU.AddToMRU(ChangeFileExt(ExtractFileName(FormController.FormDetails.ftFormPath), ''));

    Menu_File_SaveClick(Sender);
  End; { If }

  RestoreCursor (PrevCur);
end;

procedure TForm_Designer.Menu_File_DeleteClick(Sender: TObject);
Var
  PrevCur : TCursor;
  TmpStr  : Str10;
begin
  CursorToHourglass (PrevCur);

  If (FormController.FormDetails.ftFormPath <> '') Then Begin
    Case FormController.FormDetails.ftFormType Of
      ftForm   : TmpStr := 'Form';
      ftLabel  : TmpStr := 'Label';
      ftReport : TmpStr := 'Report';
    End; { Case }

    If (MessageDlg('Are you sure you want to delete this ' + TmpStr + '?',
                   mtWarning,
                   [mbYes, mbNo],
                   0) = mrYes) Then Begin
      If DeleteFormDef (FormController.FormDetails.ftFormPath) Then Begin
        { Change to new form }
        FormMRU.DeleteMRUItem(ChangeFileExt(ExtractFileName(FormController.FormDetails.ftFormPath), ''));
        SetCaption ('');
        FormController.FormDetails.InitDefaultForm;
      End { If }
      Else Begin
        { Display error message? }
      End; { Else }
    End; { If }
  End; { If }

  RestoreCursor (PrevCur);
end;

{ Print the current form }
procedure TForm_Designer.PrintDef(Const WantPreview : Boolean;Const PrnSetup : TSBSPrintSetupInfo);
Var
  HedRec     : fdHeaderRecType;
  StrRec     : fdFormStringsType;
  PrevCur    : TCursor;
begin
  CursorToHourglass (PrevCur);

  With FormController.FormDetails do Begin
    { Got a valid name, save details }
    FillChar (HedRec, SizeOf (HedRec), #0);
    With FormController.FormDetails Do Begin
      DetailsToHedRec (HedRec);
      DetailsToStrRec (StrRec);
    End; { With }

    FormDetailsList := TSBSList.CreateList('Print');
    Try
      { Get a list of the control definitions }
      GetDetailsList (FormDetailsList);

      { Save details }
      PrintFormDef (HedRec, StrRec, FormDetailsList, WantPreview, PrnSetup);
    Finally
      { Free objects in list and then the list }
      ClearDetailsList (FormDetailsList);
      FormDetailsList.Free;
    End;
  End; { With }

  RestoreCursor (PrevCur);
end;

{ Print the current form }
procedure TForm_Designer.Menu_File_PrintClick(Sender: TObject);
Var
  PrnSetupInfo : TSBSPrintSetupInfo;
begin
  If (Sender Is TMenuItem) Then Begin
    { Select Printer to Print to }
    {$OPTIMIZATION OFF}
    RPDev.DeviceIndex := RPDev.DeviceIndex;
    {$OPTIMIZATION ON}

    If RpDev.PrinterSetupDialog Then
      PrintDef (False, RpDev.SBSSetupInfo);
  End { If }
  Else Begin
    FillChar (PrnSetupInfo, SizeOf (PrnSetupInfo), #0);
    PrnSetupInfo.DevIdx := -1;
    PrintDef (False, PrnSetupInfo);

    {PrintDef (False, 0); ShowMessage ('1');}
    {PrintDef (False, 2); ShowMessage ('1');
    PrintDef (False, 1); ShowMessage ('1');}
    {PrintDef (False, 6);}
  End; { Else }
end;

{ Prints the form in print preview mode }
procedure TForm_Designer.Menu_File_PreviewClick(Sender: TObject);
Var
  PrnSetupInfo : TSBSPrintSetupInfo;
begin
  {If (RpDev <> Nil) Then }Begin
    If (Sender Is TMenuItem) Then Begin
      { Select Printer to Print to }

      {$OPTIMIZATION OFF}
      RPDev.DeviceIndex := RPDev.DeviceIndex;
      {$OPTIMIZATION ON}

      If RpDev.PrinterSetupDialog Then
        PrintDef (True, RpDev.SBSSetupInfo);
    End { If }
    Else Begin
      { Print to Default Printer }
      FillChar (PrnSetupInfo, SizeOf (PrnSetupInfo), #0);
      PrnSetupInfo.DevIdx := -1;
      PrintDef (True, PrnSetupInfo);
    End; { Else }
  End; { With }
end;

procedure TForm_Designer.Menu_Options_FormDefsClick(Sender: TObject);
begin
  SetupFormDefinitions;
end;

procedure TForm_Designer.Menu_Options_PaperSizesClick(Sender: TObject);
begin
  MaintainPaperSizes;
end;

procedure TForm_Designer.Popup_Bitmap_EditClick(Sender: TObject);
begin
  If FormController.CurrControl is TSBSDragBitmap Then
    TSBSDragBitmap(FormController.CurrControl).ShellEditor;
end;

procedure TForm_Designer.SBSPage1Click(Sender: TObject);
begin
  SBSPage1.SetFocus;
end;

Procedure TForm_Designer.ClearDetailsList (Var TheList : TSBSList);
Var
  ListObj : TFormDefListObjType;
  I       : Integer;
begin
  While (TheList.Count > 0) Do Begin
    { Take copy of object }
    ListObj := TFormDefListObjType(TheList.Items[0]);

    { Remove object from list }
    TheList.Delete (0);

    { Deallocate object }
    ListObj.Free;
  End; { While }
end;

procedure TForm_Designer.GetDetailsList (Var TheList : TSBSList);
Var
  DefObj     : TFormDefListObjType;
  TheControl : TSBSDragControl;
  TheTable   : TSBSDragDbTable;
  PrevCur    : TCursor;
  I, J       : Integer;
begin
  CursorToHourglass (PrevCur);

  TheList.Clear;

  { Save Controls }
  If (FormController.ControlList.Count > 0) Then
    For I := 0 To (FormController.ControlList.Count - 1) Do Begin
      { Get a local copy of the control }
      TheControl := TSBSDragControl(FormController.ControlList.Items[I]);

      { Create an object to put in the list }
      DefObj := TFormDefListObjType.Create;

      { Generate a form definition record for the control }
      DefObj.FormDef := TheControl.GetDefRec;
      With DefObj.FormDef Do Begin
        fdRepClass   := FormController.FormDetails.GetRepClass (TheControl);
        fdFieldOrder := I;
        fdGroup      := FormController.GetGroup (TheControl);
      End; { With }
      TheList.Add (DefObj);

      { Check for a table }
      If (DefObj.FormDef.fdFieldClass = fdcTable) Then Begin
        { process columns }
        TheTable := TSBSDragDbTable(FormController.ControlList.Items[I]);

        If (TheTable.Columns.Count > 0) Then
          For J := 0 To (TheTable.Columns.Count - 1) Do Begin
            DefObj := TheTable.GetColumnDefRec (J);
            With DefObj.FormDef Do Begin
              fdRepClass   := fdrColumn;
              fdFieldOrder := J;
            End; { With }
            TheList.Add (DefObj);
          End; { For }
      End; { If }
    End; { For }

  RestoreCursor (PrevCur);
end;

procedure TForm_Designer.FormControllerFieldOptions(Sender: TObject);
Var
  ControlDef : ^FormDefRecType;
begin
  If Sender Is TSBSDragDbField Then
    With Sender As TSBSDragDbField Do Begin
      GetMem (ControlDef, SizeOf (ControlDef^));
      Try
        ControlDef^ := GetDefRec;       

        FormDetailsList := TSBSList.CreateList('If');
        Try
          { Get a list of the control definitions }
          GetDetailsList (FormDetailsList);

          { Do the options thing }
          OptionsOk := DbFieldOptions (ControlDef^, FormDetailsList);
          If OptionsOk Then
            InitByDefRec (ControlDef^);
        Finally
          { Free objects in list and then the list }
          ClearDetailsList (FormDetailsList);
          FormDetailsList.Free;
        End;
      Finally
        FreeMem (ControlDef, SizeOf (ControlDef^));
      End;
    End; { With }
end;

procedure TForm_Designer.FormControllerBitmapOptions(Sender: TObject);
begin
  { Not Used }
end;

procedure TForm_Designer.FormControllerBoxOptions(Sender: TObject);
begin
  If Sender Is TSBSDragBox Then
    With Sender As TSBSDragBox Do Begin
      { Create options dialog }
      Form_BoxOptions := TForm_BoxOptions.Create (Self);
      Try
        Form_BoxOptions.CcyEdit_Width.Value  := PenWidth;
        Form_BoxOptions.Panel_Colour.Color   := PenColor;
        Form_BoxOptions.Check_Fill.Checked   := Fill;
        Form_BoxOptions.Check_Left.Checked   := LeftBorder;
        Form_BoxOptions.Check_Right.Checked  := RightBorder;
        Form_BoxOptions.Check_Top.Checked    := TopBorder;
        Form_BoxOptions.Check_Bottom.Checked := BottomBorder;

        Form_BoxOptions.Label_If.Caption := IfDescr (FPrintIf);
        Form_BoxOptions.DragCont := TSBSDragControl(Sender);
        Form_BoxOptions.FOnIf := FormController.OnIf;

        Form_BoxOptions.ShowModal;

        If Form_BoxOptions.Ok Then Begin
          PenWidth := Round(Form_BoxOptions.CcyEdit_Width.Value);
          PenColor := Form_BoxOptions.Panel_Colour.Color;
          LeftBorder  := Form_BoxOptions.Check_Left.Checked;
          RightBorder := Form_BoxOptions.Check_Right.Checked;
          TopBorder   := Form_BoxOptions.Check_Top.Checked;
          BottomBorder:= Form_BoxOptions.Check_Bottom.Checked;
          Fill := Form_BoxOptions.Check_Fill.Checked;

          If (Parent <> Nil) Then Paint;
        End; { If }

        OptionsOk := Form_BoxOptions.Ok;
      Finally
        Form_BoxOptions.Release;
      End;
    End; { With }
end;

procedure TForm_Designer.FormControllerFormulaOptions(Sender: TObject);
Var
  ControlDef : FormDefRecType;
begin
  If Sender Is TSBSDragFormula Then
    With Sender As TSBSDragFormula Do Begin
      FormDetailsList := TSBSList.CreateList('Formula');
      Try
        { Get a list of the control definitions }
        GetDetailsList (FormDetailsList);

        { Do the options thing }
        ControlDef := GetDefRec;
        OptionsOk := FormulaOptions (ControlDef, FormDetailsList);
        If OptionsOk Then
          InitByDefRec (ControlDef);
      Finally
        { Free objects in list and then the list }
        ClearDetailsList (FormDetailsList);
        FormDetailsList.Free;
      End;
    End; { With }
end;

procedure TForm_Designer.FormControllerGroupOptions(Sender: TObject);
begin
  If Sender Is TSBSDragGroup Then
    With Sender As TSBSDragGroup Do
      OptionsOk := True;
end;

procedure TForm_Designer.FormControllerLineOptions(Sender: TObject);
begin
  If Sender Is TSBSDragLine Then
    With Sender As TSBSDragLine Do Begin
      { Create options dialog }
      Form_LineOptions := TForm_LineOptions.Create (Self);
      Try
        Form_LineOptions.CcyEdit_Width.Value := PenWidth;
        Form_LineOptions.Panel_Colour.Color  := PenColor;

        Form_LineOptions.SpButt_Horz.Down := (LineType = lnHorizontal);
        Form_LineOptions.SpButt_Vert.Down := (LineType = lnVertical);
        Form_LineOptions.SpButt_TLBR.Down := (LineType = lnTLToBR);
        Form_LineOptions.SpButt_BLTR.Down := (LineType = lnBLToTR);

        Form_LineOptions.Label_If.Caption := IfDescr (FPrintIf);
        Form_LineOptions.DragCont := TSBSDragControl(Sender);
        Form_LineOptions.FOnIf := FormController.OnIf;

        Form_LineOptions.ShowModal;

        If Form_LineOptions.Ok Then Begin
          PenWidth := Round(Form_LineOptions.CcyEdit_Width.Value);
          PenColor := Form_LineOptions.Panel_Colour.Color;

          If Form_LineOptions.SpButt_Horz.Down Then LineType := lnHorizontal;
          If Form_LineOptions.SpButt_Vert.Down Then LineType := lnVertical;
          If Form_LineOptions.SpButt_TLBR.Down Then LineType := lnTLToBR;
          If Form_LineOptions.SpButt_BLTR.Down Then LineType := lnBLToTR;
        End; { If }

        OptionsOk := Form_LineOptions.Ok;
      Finally
        Form_LineOptions.Release;
      End;
    End; { With }
end;

procedure TForm_Designer.FormControllerPageNoOptions(Sender: TObject);
begin
  If Sender Is TSBSDragPage Then
    With Sender As TSBSDragPage Do Begin
      { Create options dialog }
      Form_PageNoOptions := TForm_PageNoOptions.Create (Self);
      Try
        Form_PageNoOptions.Edit_Leading.Text := LeadingText;
        Form_PageNoOptions.Edit_Trailing.Text := TrailingText;
        Form_PageNoOptions.SetAlign(Alignment);
        Form_PageNoOptions.FontDialog1.Font.Assign(Font);
        Form_PageNoOptions.Label_Font.Font.Assign(Font);

        Form_PageNoOptions.ShowModal;

        If Form_PageNoOptions.Ok Then Begin
          LeadingText  := Form_PageNoOptions.Edit_Leading.Text;
          TrailingText := Form_PageNoOptions.Edit_Trailing.Text;
          Alignment    := Form_PageNoOptions.GetAlign;
          Font.Assign(Form_PageNoOptions.Label_Font.Font);
        End; { If }

        OptionsOk := Form_PageNoOptions.Ok;
      Finally
        Form_PageNoOptions.Release;
      End;
    End; { With }
end;

procedure TForm_Designer.FormControllerTableOptions(Sender: TObject);
Var
  ListObj     : TFormDefListObjType;
  ControlDef  : FormDefRecType;
  TempColumns : TSBSList;
  I           : Integer;
begin
  If Sender Is TSBSDragDbTable Then
    With Sender As TSBSDragDbTable Do Begin
      TempColumns := TSBSList.CreateList('TempCols');
      Try
        ControlDef := GetDefRec;

        { Get columns }
        If (Columns.Count > 0) Then
          For I := 0 To (Columns.Count - 1) Do Begin
            ListObj := TFormDefListObjType.Create;
            ListObj.FormDef := TFormDefListObjType(Columns.Items[I]).FormDef;
            TempColumns.Add (ListObj);
          End; { For }

        FormDetailsList := TSBSList.CreateList('Table');
        Try
          { Get a list of the control definitions }
          GetDetailsList (FormDetailsList);

          { Do the options thing }
          OptionsOk := DbTableOptions (ControlDef, TempColumns, FormDetailsList);
        Finally
          { Free objects in list and then the list }
          ClearDetailsList (FormDetailsList);
          FormDetailsList.Free;
        End;

        If OptionsOk Then Begin
          { Update Table control }
          InitByDefRec (ControlDef);

          { Update columns }
          ClearColumns;
        End; { If }

        While (TempColumns.Count > 0) Do Begin
          { Take copy of object, remove from list, and deallocate }
          ListObj := TFormDefListObjType(TempColumns.Items[0]);
          TempColumns.Delete (0);
          If OptionsOk Then InitColumnByDefRec (ListObj.FormDef);
          ListObj.Free;
        End; { While }
      Finally
        TempColumns.Free;
      End;
    End; { With }
end;

procedure TForm_Designer.FormControllerTextOptions(Sender: TObject);
begin
  If Sender Is TSBSDragText Then
    With Sender As TSBSDragText Do Begin
      { Create options dialog }
      Form_TextOptions := TForm_TextOptions.Create (Self);
      Try
        Form_TextOptions.Memo_Text.Text := Text;
        Form_TextOptions.Label_Font.Font.Assign(Font);
        Form_TextOptions.SetAlign (TextAlign);

        // HM 13/11/00: Added support for Symvbol Fonts
        Form_TextOptions.chkSymbolFont.Checked := IsSymbolFont;

        Form_TextOptions.Label_If.Caption := IfDescr (FPrintIf);
        Form_TextOptions.DragCont := TSBSDragControl(Sender);
        Form_TextOptions.FOnIf := FormController.OnIf;

        Form_TextOptions.ShowModal;

        If Form_TextOptions.Ok Then Begin
          Text := Form_TextOptions.Memo_Text.Text;
          {Font.Assign(Form_TextOptions.Label_Font.Font);}
          Font.Assign(Form_TextOptions.Label_Font.Font);
          TextAlign := Form_TextOptions.GetAlign;

          // HM 13/11/00: Added support for Symvbol Fonts
          IsSymbolFont := Form_TextOptions.chkSymbolFont.Checked;
        End; { If }

        OptionsOk := Form_TextOptions.Ok;
      Finally
        Form_TextOptions.Release;
      End;
    End; { With }
End;

procedure TForm_Designer.Menu_Options_GridClick(Sender: TObject);
Var
  PrevCur  : TCursor;
begin
  CursorToHourglass (PrevCur);

  Form_GridOptions := TForm_GridOptions.Create (Self);
  Try
    Form_GridOptions.Setup (FormController);

    CursorForDialog;
    Form_GridOptions.ShowModal;
    CursorFromDialog;

    Application.ProcessMessages;
    
    { need to redraw the visible area }
    FormController.RedrawVisible;
  Finally
    Form_GridOptions.Release;
  End;

  RestoreCursor (PrevCur);
end;


procedure TForm_Designer.Menu_Help_AboutClick(Sender: TObject);
Var
  PrevCur  : TCursor;
begin
  CursorToHourglass (PrevCur);

  DisplayAbout;

  CursorToPointer;
end;

procedure TForm_Designer.ActivateApp(var Msg: TMessage);
begin
  Application.Restore;
  {If (WindowState = wsMinimized) Then WindowState := wsNormal;
  SetForeGroundWindow (Handle);}
end;

procedure TForm_Designer.PrintProgress(var Msg: TMessage);
begin
  With Msg Do Begin
    { Mode passes in WParam }
    Case WParam Of
      { Clear Progress }
      0 : { N/A };

      { Set Progress percentage }
      1 : { N/A };

      { Set HWnd }
      2 : { N/A };

      { Set InPrint Flag }
      3 : { N/A };

      { Check InPrint Flag }
      4 : SendMessage(LParam,WM_InPrint,Ord(False),0);
    End; { Case }
  End; { With }
end;

{ Toggle toolbar On and Off }
procedure TForm_Designer.Menu_Options_ToolbarClick(Sender: TObject);
begin
  Menu_Options_Toolbar.Checked := Not Menu_Options_Toolbar.Checked;

  //  Panel_Toolbar.Visible := Menu_Options_Toolbar.Checked;
  //CoolBar1.Visible := Menu_Options_Toolbar.Checked;
  AdvDockPanel.Visible := Menu_Options_Toolbar.Checked;
end;

{ Toggle status line On and Off }
procedure TForm_Designer.Menu_Options_StatusLineClick(Sender: TObject);
begin
  Menu_Options_StatusLine.Checked := Not Menu_Options_StatusLine.Checked;
  StatusBar1.Visible := Menu_Options_StatusLine.Checked;
end;

procedure TForm_Designer.Popup_Bitmap_IfClick(Sender: TObject);
begin
  FormController.EditIf;
end;

{ Executes the If dialog for any drag control - only used by bitmaps }
procedure TForm_Designer.FormControllerIf(Sender: TObject; IfLabel: TObject);
Var
  PrevCur : TCursor;
begin
  CursorToHourglass (PrevCur);

  With Sender As TSBSDragControl Do Begin
    FormDetailsList := TSBSList.CreateList('If');
    Try
      { Get a list of the control definitions }
      GetDetailsList (FormDetailsList);

      { Do the options thing }
      IfDialog (FPrintIf, ControlId, FormDetailsList);

      FormController.ChangeMade;
      
      If Assigned (IfLabel) Then
        With IfLabel As TLabel Do
          Caption := IfDescr (FPrintIf);
    Finally
      { Free objects in list and then the list }
      ClearDetailsList (FormDetailsList);
      FormDetailsList.Free;
    End;
  End; { With }

  RestoreCursor (PrevCur);
end;

procedure TForm_Designer.Menu_Edit_CopyClick(Sender: TObject);
begin
  FormController.EditCopy;
end;

procedure TForm_Designer.Menu_Edit_CutClick(Sender: TObject);
begin
  FormController.EditCut;
end;

procedure TForm_Designer.Menu_Edit_PasteClick(Sender: TObject);
begin
  FormController.EditPaste;
end;

procedure TForm_Designer.SpButt_GroupClick(Sender: TObject);
begin
  FormController.CreateNewControl (ctGroup);
end;

procedure TForm_Designer.Menu_Ctrl_DelCtrlClick(Sender: TObject);
Var
  PrevCur : TCursor;
begin
  CursorToHourglass (PrevCur);

  Form_Restore := TForm_Restore.Create(Self);
  Try
    CursorForDialog;
    Form_Restore.ShowModal;
    CursorFromDialog;
  Finally
    Form_Restore.Free;
  End;

  RestoreCursor (PrevCur);
end;

procedure TForm_Designer.FormControllerZOrder(Sender: TObject);
Var
  PrevCur : TCursor;
begin
  CursorToHourglass (PrevCur);

  Form_ZOrder := TForm_ZOrder.Create(Self);
  Try
    CursorForDialog;
    Form_ZOrder.ShowModal;
    CursorFromDialog;

    FormController.SetZOrders;

    If SBSPage1.CanFocus Then SBSPage1.SetFocus;
  Finally
    Form_ZOrder.Release;
  End;

  RestoreCursor (PrevCur);
end;

procedure TForm_Designer.Menu_Help_TechSuppRepClick(Sender: TObject);
Var
  RepFName, TempDir : ShortString;
  FVar     : SmallInt;
begin
  Form_TechSupp := TForm_TechSupp.Create(Self);
  Try
    If RpDev.PrinterSetupDialog Then Begin
      GetTempFilePath (TempDir);

      { generate filename }
      FVar := 0;
      Repeat
        RepFName := TempDir + '!REP' + IntToStr(FVar) + '.SWP';
        Inc (FVar);
      Until (Not FileExists (RepFName)) Or (FVar > 9999);

      If (FVar <= 9999) Then Begin
        { got a name }
        Form_TechSupp.ReportFiler1.FileName := RepFName;
        Form_TechSupp.ReportFiler1.PrinterIndex := RpDev.DeviceIndex;

        { print to file }
        Form_TechSupp.ReportFiler1.Execute;

        { preview the file }
        PreviewPrintFile (RpDev.SBSSetupInfo, RepFName, '');
      End { If }
      Else
        MessageDlg ('Cannot find unique filename', mtError, [mbOk], 0);
    End; { If }
  Finally
    Form_TechSupp.Free;
  End;
end;

procedure TForm_Designer.SuppQFBtnClick(Sender: TObject);
begin
  PostMessage(Self.Handle,WM_SysCommand,SC_CONTEXTHELP,0);
end;

procedure TForm_Designer.Menu_Help_ContentsClick(Sender: TObject);
begin
  Application.HelpCommand(HELP_Finder,0);
end;

Procedure TForm_Designer.SetCaption (Const FName : String);
begin
  LoadedFName := FName;
  If (Trim(FName) <> '') Then
    Caption := OrigCaption + ' - ' + FName
  Else
    Caption := OrigCaption;

  Caption := Caption  + ' - ' +CompanyName;

  ApplicationActive(Self);
end;

procedure TForm_Designer.Menu_OptionsClick(Sender: TObject);
begin
  Case FormController.FormDetails.ftFormType Of
    ftForm  : Menu_Options_Page.Caption := 'Form Options';
    ftLabel : Menu_Options_Page.Caption := 'Label Options';
  End; { Case }
end;

{ Builds and prints a test batch of labels }
{ Display a dialog to allow editing of default font }
procedure TForm_Designer.spButt_DefFontClick(Sender: TObject);
Var
  FontDialog : TFontDialog;
begin
  FontDialog := TFontDialog.Create(Self);
  Try
    FontDialog.Font.Assign(FormController.FormDetails.ftDefaultFont);

    If FontDialog.Execute Then Begin
      FormController.FormDetails.ftDefaultFont.Assign(FontDialog.Font);
      FormController.ChangeMade;
    End; { If }
  Finally
    FontDialog.Free;
  End;
end;

procedure TForm_Designer.Popup_Text_FontClick(Sender: TObject);
begin
  FormController.ControlFont;
end;

procedure TForm_Designer.Menu_Options_PrnCodesClick(Sender: TObject);
begin
  PrinterControlCodes;
end;

procedure TForm_Designer.Menu_Options_PCCDefsClick(Sender: TObject);
begin
  PCCDefaulDlg;
end;

procedure TForm_Designer.ReopenClick(Sender: TObject);
Var
  PrevCur : TCursor;
  TmpStr  : String;
begin
  CursorToHourglass (PrevCur);

  With Sender As TMenuItem Do Begin
    { Open Form }
    TmpStr := SystemInfo.ExDataPath + FormsPath + Caption + DefDotExtension;
    If FileExists(TmpStr) Then Begin
      OpenForm (TmpStr);
    End { If }
    Else
      FormMRU.DeleteMRUItem(Caption);
  End; { With }

  RestoreCursor (PrevCur);
end;

procedure TForm_Designer.Menu_Help_DictRepClick(Sender: TObject);
begin
  PrintDDReport;
end;

procedure TForm_Designer.Menu_Options_SignaturesClick(Sender: TObject);
begin
  MaintainSignatures;
end;


procedure TForm_Designer.ApplicationActive(Sender : TObject);
Var
  {Message  :  TMessage;}
  sProd : ShortString;
Begin
  (* Exchequer background redrawing code - not applicable to FormDes
  FillChar(Message,Sizeof(Message),0);
  ResetPalette(Message);
  MDI_ForceParentBKGnd(BOn);
  *)

  // MH 08/02/06: Mods to hide 'Exchequer'
  If (EnterpriseLicence.elProductType In [ptLITECust, ptLITEAcct]) Then
    sProd := ''
  Else
    sProd := ' - Exchequer';

  If (Trim(LoadedFName) <> '') Then
    Application.Title := 'Form Designer' + sProd + ' - ' + Trim(LoadedFName) + ' - ' + CompanyName
  Else
    Application.Title := 'Form Designer' + sProd + ' - ' + CompanyName;
end;

procedure TForm_Designer.EntDeActivate(Sender : TObject);
Var
  sProd : ShortString;
Begin
  // MH 08/02/06: Mods to hide 'Exchequer'
  If (EnterpriseLicence.elProductType In [ptLITECust, ptLITEAcct]) Then
    sProd := ''
  Else
    sProd := ' - Exchequer';

  If (Trim(LoadedFName) <> '') Then
    Application.Title := CompanyName+' - ' + Trim(LoadedFName) + ' - Form Designer' + sProd
  Else
    Application.Title := CompanyName+' - Form Designer' + sProd;
end;

procedure TForm_Designer.bsOffice2003Blue1Click(Sender: TObject);
begin
  AdvStyler.Style := ttoolbarstyle((Sender as TMenuItem).Tag);

  //bsOffice2003Blue,  0
  //bsOffice2003Silver, 1
  //bsOffice2003Olive,  2
  //bsOffice2003Classic, 3
  //bsOffice2007Luna,  4
  //bsOffice2007Obsidian, 5
  //bsWindowsXP,         6
  //bsWhidbeyStyle,      7
  //bsCustom,            8
  //bsOffice2007Silver,  9
  //bsOfficeXP           10
end;

end.
