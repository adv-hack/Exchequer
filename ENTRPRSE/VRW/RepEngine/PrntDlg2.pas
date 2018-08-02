unit Prntdlg2;

{ prutherford440 14:10 30/10/2001: Disabled Byte Alignment in Delphi 6.0 }
{$ALIGN 1}  { Variable Alignment Disabled }


{ I DEFOVR.Inc}

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, TEditVal, BorBtns, Mask, Menus, sbsprint, RpDefine, RpDevice,
  ExtCtrls, ComCtrls,
  {GlobType, }VarConst, BTSupU1, EmlDetsF, SBSPanel, TCustom,
  //  FileCtrl,
  ExWrap1U, bkgroup;

type
  TPrintDlg = class(TForm)
    OpenDialog: TOpenDialog;
    FontDialog1: TFontDialog;
    PageControl1: TPageControl;
    tabshPrinter: TTabSheet;
    tabshFax: TTabSheet;
    tabshEmail: TTabSheet;
    Label81: Label8;
    Radio_Printer: TBorRadio;
    Radio_Preview: TBorRadio;
    Combo_Printers: TSBSComboBox;
    btnSetupPrinter: TButton;
    Button_OK: TButton;
    Button_Cancel: TButton;
    CopiesF: Text8Pt;
    Label84: Label8;
    lstFaxPrinter: TSBSComboBox;
    btnFaxSetupPrinter: TButton;
    btnFaxOK: TButton;
    btnFaxCancel: TButton;
    SBSBackGroup1: TSBSBackGroup;
    SBSBackGroup2: TSBSBackGroup;
    Label88: Label8;
    edtFaxFromName: Text8Pt;
    edtFaxToName: Text8Pt;
    Label89: Label8;
    edtFaxFromNo: Text8Pt;
    Label810: Label8;
    edtFaxToNo: Text8Pt;
    Label811: Label8;
    Label812: Label8;
    memFaxMessage: TMemo;
    SBSBackGroup3: TSBSBackGroup;
    SBSBackGroup4: TSBSBackGroup;
    btnEmlOK: TButton;
    btnEmlCancel: TButton;
    SBSBackGroup5: TSBSBackGroup;
    chkEmlReader: TCheckBox;
    SBSBackGroup9: TSBSBackGroup;
    radFaxPrinter: TBorRadio;
    radFaxPreview: TBorRadio;
    raadEmlPrinter: TBorRadio;
    radEmlPreview: TBorRadio;
    Popup_Forms: TPopupMenu;
    Popup_Forms_Clear: TMenuItem;
    Popup_Forms_SepBar1: TMenuItem;
    Popup_Forms_Browse: TMenuItem;
    Popup_Forms_SepBar2: TMenuItem;
    Popup_Forms_1: TMenuItem;
    Popup_Forms_2: TMenuItem;
    Popup_Forms_3: TMenuItem;
    Popup_Forms_4: TMenuItem;
    Popup_Forms_6: TMenuItem;
    Popup_Forms_7: TMenuItem;
    Popup_Forms_8: TMenuItem;
    Popup_Forms_9: TMenuItem;
    Popup_Forms_10: TMenuItem;
    Popup_Forms_5: TMenuItem;
    Label85: Label8;
    lstFaxPriority: TSBSComboBox;
    grpEmailDets: TSBSGroup;
    Label816: Label8;
    Label817: Label8;
    Label818: Label8;
    Label819: Label8;
    Label820: Label8;
    Label82: Label8;
    edtEmlSendName: Text8Pt;
    edtEmlSubject: Text8Pt;
    edtEmlSendAddr: Text8Pt;
    memEmlMessage: TMemo;
    lvRecips: TListView;
    lstEmlPriority: TSBSComboBox;
    btnEmlAdd: TButton;
    btnEmlEdit: TButton;
    btnEmlDelete: TButton;
    Label814: Label8;
    edtEmlAttach: Text8Pt;
    btnAttachList: TButton;
    SBSBackGroup6: TSBSBackGroup;
    SBSBackGroup7: TSBSBackGroup;
    SBSBackGroup8: TSBSBackGroup;
    chkFaxCover: TBorCheck;
    lstEmlCompress: TComboBox;
    tabshExcel: TTabSheet;
    SBSBackGroup10: TSBSBackGroup;
    Label815: Label8;
    lstExcelPrinter: TSBSComboBox;
    Label821: Label8;
    edtExcelFont: Text8Pt;
    btnExcelFont: TButton;
    btnExcelSetupPrinter: TButton;
    SBSBackGroup12: TSBSBackGroup;
    radExcelFile: TBorRadio;
    radExcelPreview: TBorRadio;
    SBSBackGroup14: TSBSBackGroup;
    edtExcelPath: Text8Pt;
    Label822: Label8;
    btnExcelSetPath: TSBSButton;
    chkExcelOpenXLS: TBorCheckEx;
    SBSBackGroup13: TSBSBackGroup;
    btnExcelOK: TButton;
    btnExcelCancel: TButton;
    tabshHTML: TTabSheet;
    SBSBackGroup15: TSBSBackGroup;
    Label823: Label8;
    lstHTMLPrinter: TSBSComboBox;
    Label824: Label8;
    edtHTMLFont: Text8Pt;
    btnHTMLSetupPrinter: TButton;
    btnHTMLFont: TButton;
    SBSBackGroup16: TSBSBackGroup;
    radHTMLFile: TBorRadio;
    radHTMLPreview: TBorRadio;
    SBSBackGroup17: TSBSBackGroup;
    edtHTMLPath: Text8Pt;
    Label825: Label8;
    btnHTMLSetPath: TSBSButton;
    SBSBackGroup18: TSBSBackGroup;
    chkHTMLOpenHTML: TBorCheckEx;
    btnHTMLOK: TButton;
    btnHTMLCancel: TButton;
    SaveDialog1: TSaveDialog;
    tabshDBFFile: TTabSheet;
    SBSBackGroup11: TSBSBackGroup;
    DBFOutputGroup: TSBSBackGroup;
    SBSBackGroup20: TSBSBackGroup;
    SBSBackGroup21: TSBSBackGroup;
    btnDBFCancel: TButton;
    btnDBFOK: TButton;
    Label83: Label8;
    lstDBFPrinter: TSBSComboBox;
    btnDBFSetupPrinter: TButton;
    btnDBFFont: TButton;
    ext8Pt1: Text8Pt;
    Label86: Label8;
    radDBFFile: TBorRadio;
    radDBFPreview: TBorRadio;
    edtDBFPath: Text8Pt;
    Label87: Label8;
    btnDBFSetPath: TSBSButton;
    chkDBFOpenDBF: TBorCheckEx;
    tabshCSVFile: TTabSheet;
    SBSBackGroup22: TSBSBackGroup;
    Label813: Label8;
    lstCSVPrinter: TSBSComboBox;
    Label826: Label8;
    ext8Pt2: Text8Pt;
    btnCSVSetupPrinter: TButton;
    btnCSVFont: TButton;
    CSVOutputGroup: TSBSBackGroup;
    radCSVFile: TBorRadio;
    radCSVPreview: TBorRadio;
    SBSBackGroup24: TSBSBackGroup;
    Label827: Label8;
    edtCSVPath: Text8Pt;
    btnCSVSetPath: TSBSButton;
    SBSBackGroup25: TSBSBackGroup;
    chkCSVOpenCSV: TBorCheckEx;
    btnCSVOK: TButton;
    btnCSVCancel: TButton;
    chkXLIncludeReportHeader: TBorCheckEx;
    chkXLIncludePageHeader: TBorCheckEx;
    chkXLIncludeSectionHeader: TBorCheckEx;
    chkXLIncludeReportLines: TBorCheckEx;
    chkXLIncludeSectionFooter: TBorCheckEx;
    chkXLIncludePageFooter: TBorCheckEx;
    chkXLIncludeReportFooter: TBorCheckEx;
    Label1: TLabel;
    chkCSVIncludeSectionHeaders: TBorCheckEx;
    procedure FormCreate(Sender: TObject);
    procedure Button_OKClick(Sender: TObject);
    procedure Button_CancelClick(Sender: TObject);
    procedure btnSetupPrinterClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormDestroy(Sender: TObject);
    procedure CopiesFChange(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure FormKeyPress(Sender: TObject; var Key: Char);
    procedure Combo_PrintersClick(Sender: TObject);
    procedure PageControl1Change(Sender: TObject);
    procedure btnFaxOKClick(Sender: TObject);
    procedure btnEmlOKClick(Sender: TObject);
    procedure PageControl1Changing(Sender: TObject;
      var AllowChange: Boolean);
    procedure lvRecipsEditing(Sender: TObject; Item: TListItem;
      var AllowEdit: Boolean);
    procedure lvRecipsClick(Sender: TObject);
    procedure btnEmlEditClick(Sender: TObject);
    procedure btnEmlAddClick(Sender: TObject);
    procedure btnEmlDeleteClick(Sender: TObject);
    procedure Popup_Forms_ClearClick(Sender: TObject);
    procedure Popup_Forms_CacheClick(Sender: TObject);
    procedure btnAttachListClick(Sender: TObject);
    procedure edtFaxToNameDblClick(Sender: TObject);
    procedure lstFaxPrinterClick(Sender: TObject);
    procedure btnFaxSetupPrinterClick(Sender: TObject);
    procedure Label819DblClick(Sender: TObject);
    procedure btnFontClick(Sender: TObject);
    procedure btnSetPathClick(Sender: TObject);
    procedure btnCSVOKClick(Sender : TObject);
    procedure btnDBFOKClick(Sender : TObject);
    procedure btnExcelOKClick(Sender: TObject);
    procedure btnHTMLOKClick(Sender: TObject);
  private
    { Private declarations }
    OkPressed  : Boolean;
    lPrnInfo   : TSBSPrintSetupInfo;

    // Internal Property used to store the Report Font for Reports
    FReportFont : TFont;

    // Internal property used to indicate if we have checked if Excel is available to open .XLS files
    FXLSCheck : Boolean;

    // Internal property used to indicate if we have checked if anything is available to open .HTML files
    FHTMLCheck : Boolean;

    // Internal property used to indicate if we have checked if Excel is avaliable to open .DBF files.
    FDBFCheck : Boolean;

    // Internal property used to indicate if we have checked if Excel is avaliable to open .CSV files.
    FCSVCheck : Boolean;

    procedure CheckForMAPI;
    procedure SetListItem (ListObj  : TEmailDetsObjType;
                           ListItem : TListItem);

    function Current_Page  :  Integer;

    procedure ChangePage(NewPage  :  Integer);

    procedure WMCustGetRec(var message  :  TMessage); message WM_CustGetRec;

    procedure OutPrnInfoDetails;
    procedure SetFont(const Value: TFont);

  public
    { Public declarations }
    DefSuggPrinter{,
    SuggestPrinter}   : Integer;
    ShowForm         : Boolean;
    UseAutoMode      : Boolean;
    Automode         : Byte;
    NeedLabel        : Boolean;
    //UseForm          : ShortString;
    ThisOrient       : TOrientation;
    PrnSetup         : TSBSPrintSetupInfo;

    property ReportFont : TFont read FReportFont write SetFont;

    function  Execute(FormName : ShortString;var PrnInfo : TSBSPrintSetupInfo; DefPrinter : ShortString) : Boolean;
  end;

  PHWND = ^HWND;

var
  PrintDlg: TPrintDlg;
  PrintToQueue,
  PrintToPrinter: Boolean;
  PrintShowForm : Boolean;

procedure SetEcommsFromCust(const LCust    :  CustRec;
                            var   PrnInfo  :  TSBSPrintSetupInfo;
                                  ExLocal  :  TdMTExLocalPtr;
                                  Update   :  Boolean);

function EnumWndProc_FaxClnt (Hwnd: THandle; FoundWnd: PHWND): Bool; export; stdcall;

function SelectPrinter(var PrnInfo : TSBSPrintSetupInfo) : Boolean;
function SelectCDFFile (var LastPath : ShortString) : Boolean;
function SelectDBFFile (var LastPath : ShortString) : Boolean;

procedure InitEmailText (var PrnInfo : TSBSPrintSetupInfo);

 {~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~}

  implementation


 {~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~}

{$R *.DFM}

uses
  ETStrU, BTSupU2, BtrvU2, {$IFDEF FRM} DLLInt, {$ENDIF} // Exchequer
  GlobVar, CmpCtrlU, CommsInt, {FormUtil,} // Exchequer
  InvListU, CompUtil, EmlAttch, // Exchequer
//  PWarnU, <-- was here for PChkAllowed_In(). Currently a temporary local function.
  ExThrd2U, BTSFrmU1, PrintFrm, FileUtil, // Exchequer
  Registry, // Delphi
  GlobalTypes; // my own

const
  {$I FilePath.Inc}

var
  GotMAPI, TestedMAPI, GlobFaxCover : Boolean;
  // Remembered Excel Options
  LastExcelPath       : ShortString;
//  PrintOpenExcel      : Boolean;
//  PrintExcelPages     : Boolean;
//  PrintExcelTotals    : Boolean;
  // Remembered HTML Options
  LastHTMLPath        : ShortString;
  PrintOpenHTML       : Boolean;
  // Remembered DBF Options
  LastDBFPath : ShortString;
  PrintOpenDBF : Boolean;
  // CSV Options
  LastCSVPath : ShortString;
  PrintOpenCSV : Boolean;

{---------------------------------------------------------------------------}

function PChkAllowed_In(const FValue : LongInt) : Boolean;
begin
  Result := TRUE;
end;

{ Callback function to identify the form designer window }
function EnumWndProc_FaxClnt (Hwnd: THandle; FoundWnd: PHWND): Bool; export; stdcall;
var
  ClassName : string;
  Tag       : THandle;
begin { EnumWndProc_FaxClnt }
  Result := True;
  SetLength (ClassName, 100);
  GetClassName (Hwnd, PChar (ClassName), Length (ClassName));
  ClassName := PChar (UpperCase(Trim(ClassName)));

  if (AnsiCompareText (ClassName, 'TFRMFAXCLIENT') = 0) then
  begin
    Tag := GetWindowLong (Hwnd, GWL_USERDATA);
    if (Tag = 1010) then
    begin
      FoundWnd^ := Hwnd;
      Result := False;
    end;
  end;
end; { EnumWndProc_FaxClnt }

{---------------------------------------------------------------------------}

function GetReaderText : ANSIString;
var
  SigFile : TStrings;
  FName   : ShortString;
begin { GetReaderText }
  Result := '';

  FName := IncludeTrailingBackSlash(SetDrive) + PathMaster + 'reader.txt';
  if FileExists (FName) then
  begin
    // Load File into stringlist
    SigFile := TStringList.Create;
    try
      SigFile.LoadFromFile(FName);

      Result := SigFile.Text;
    finally
      SigFile.Destroy;
    end;
  end; 
end; { GetReaderText;

{-----------------------------------------------------------------------------}

procedure InitEmailText (var PrnInfo : TSBSPrintSetupInfo);
var
  SigFile : TStrings;
  GotFile : Boolean;
  FName   : ShortString;
begin { InitEmailText }
  // Initialise the message
  //PrnInfo.feEmailMsg := ''; not necessary as otherewise any auto messages will be lost

  // Check the 'Send Reader' flag
  if PrnInfo.feEmailReader then
    PrnInfo.feEmailMsg := GetReaderText + PrnInfo.feEmailMsg;

  // Check for logged in user's email signature file
  FName := IncludeTrailingBackSlash(SetDrive) + PathMaster + Trim(Copy(EntryRec^.Login, 1, 8)) + '.txt';
  GotFile := FileExists (FName);

  if (not GotFile) then
  begin
    // Check for generic Company email signature
    FName := IncludeTrailingBackSlash(SetDrive) + PathMaster + 'company.txt';
    GotFile := FileExists (FName);
  end; 

  if GotFile then
  begin
    // Load File into stringlist
    SigFile := TStringList.Create;
    try
      SigFile.LoadFromFile(FName);

      PrnInfo.feEmailMsg := PrnInfo.feEmailMsg + SigFile.Text;

    finally
      SigFile.Destroy;
    end;
  end; 

  // Check for logged in user's fax signature file
  FName := IncludeTrailingBackSlash(SetDrive) + PathMaster + Trim(Copy(EntryRec^.Login, 1, 8)) + '.tx2';
  GotFile := FileExists (FName);

  if (not GotFile) then
  begin
    // Check for generic Company fax signature
    FName := IncludeTrailingBackSlash(SetDrive) + PathMaster + 'company.tx2';
    GotFile := FileExists (FName);
  end; 

  if GotFile then
  begin
    // Load File into stringlist
    SigFile := TStringList.Create;
    try
      SigFile.LoadFromFile(FName);

      PrnInfo.feFaxMsg := PrnInfo.feFaxMsg + SigFile.Text;
    finally
      SigFile.Destroy;
    end;
  end; 
end; { InitEmailText }

{-----------------------------------------------------------------------------}

{ Public version }
procedure SetEcommsFromCust(const LCust    :  CustRec;
                            var   PrnInfo  :  TSBSPrintSetupInfo;
                                  ExLocal  :  TdMTExLocalPtr;
                                  Update   :  Boolean);
begin
end;

{ internal version }
procedure SetEcommsFromCust2(const LCust    :  CustRec;
                             var   PrnInfo  :  TSBSPrintSetupInfo);
begin
  with PrnInfo, LCust do
  begin
    feFaxTo := Trim(Company);

    if (Trim(Contact)<>'') then
      feFaxTo := feFaxTo+', '+Trim(Contact);

    feEmailTo := feFaxTo;
    feFaxToNo := Fax;

    feEmailToAddr := EmailAddr;

    feEmailReader := EmlSndRdr;
    feEmailZip := Ord(EmlZipAtc);
  end; 
end;

{---------------------------------------------------------------------------}

function SelectPrinter(var PrnInfo : TSBSPrintSetupInfo) : Boolean;
var
  PrnSel  : TPrintDlg;
begin
  Result := False;

  Set_BackThreadMVisible(BOn);
  Set_BackThreadSuspend (BOn);

  PrnSel := TPrintDlg.Create(Application.MainForm);
  with PrnInfo do
    try
      InitEmailText (PrnInfo);

      PrnSel.PrnSetup := PrnInfo;
      PrnSel.CopiesF.Text := IntToStr(NoCopies);

      if PrnSel.Execute('',PrnInfo,'') then
      begin
        //PrnInfo := PrnSel.PrnSetup;
        Result := True;
      end;
    finally
      PrnSel.Free;
    end;

  Set_BackThreadSuspend (BOff);
  Set_BackThreadMVisible(BOff);
end;

{---------------------------------------------------------------------------}

function SelectCDFFile (var LastPath : ShortString) : Boolean;
var
  SaveDialog1: TSaveDialog;
begin
  Set_BackThreadMVisible(BOn);
  Set_BackThreadSuspend (BOn);

  SaveDialog1 := TSaveDialog.Create(Application.MainForm);
  try
    with SaveDialog1 do
    begin
      DefaultExt := 'CSV';
      FileName := LastPath;
      Filter := 'CSV Files|*.CSV|All Files|*.*';
      FilterIndex := 1;
      Options := [ofOverwritePrompt, ofPathMustExist];
      Title := 'Print CSV report to';
    end; 

    Result := SaveDialog1.Execute;

    if Result then
    begin
      { filename & path selected }
      LastPath := SaveDialog1.FileName;
    end; 
  finally
    SaveDialog1.Free;
  end;

  Set_BackThreadSuspend (BOff);
  Set_BackThreadMVisible(BOff);
end;

{---------------------------------------------------------------------------}

function SelectDBFFile (var LastPath : ShortString) : Boolean;
var
  SaveDialog1: TSaveDialog;
begin
  Set_BackThreadMVisible(BOn);
  Set_BackThreadSuspend (BOn);

  SaveDialog1 := TSaveDialog.Create(Application.MainForm);
  try
    with SaveDialog1 do
    begin
      DefaultExt := 'DBF';
      FileName := LastPath;
      Filter := 'DBF Files|*.DBF|All Files|*.*';
      FilterIndex := 1;
      Options := [ofOverwritePrompt, ofPathMustExist];
      Title := 'Save DBF File to';
    end; 

    Result := SaveDialog1.Execute;

    if Result then
    begin
      { filename & path selected }
      LastPath := SaveDialog1.FileName;
    end; 
  finally
    SaveDialog1.Free;
  end;

  Set_BackThreadSuspend (BOff);
  Set_BackThreadMVisible(BOff);
end;

{---------------------------------------------------------------------------}

procedure TPrintDlg.FormCreate(Sender: TObject);
var
  OldHWnd : HWnd;
  I       : Integer;
//  Locked  : Boolean;
begin
  { Default To Printer tab and resize form }
  PageControl1.ActivePage := tabshPrinter;
  PageControl1Change(Sender);

  { Init local variables }
  OkPressed := False;
  NeedLabel := False;
  FXLSCheck := False;
  FHTMLCheck := False;
  FDBFCheck := FALSE;
  FCSVCheck := FALSE;

//  Locked := FALSE;
//  GetMultiSys(FALSE, Locked, EDI2R);

  ShowForm := PrintShowForm;

  { Check to see if MAPI is available }
  {GotMapi := MAPIAvailable;}

  {FNF.Visible := ShowForm;
  FNLab.Visible := FNF.Visible;}

  with lvRecips,Columns do {* Set Column widths and captions here *}
  begin
    Items[0].Width := 22;
    Items[1].Width := 108;
    Items[2].Width := 200;
    Items[1].Caption := 'Name';
    Items[2].Caption := 'Email address';
  end;

  {* Create dummy font *}

  FReportFont := TFont.Create;
  try
    FReportFont.Assign(Self.Font);
  except
    FReportFont.Free;
    FReportFont := nil;
  end;

  ThisOrient := RpDev.Orientation;

  { load printers }
  with RpDev do
  begin
    if (Printers.Count > 0) then
    begin
      for I := 0 To Pred(Printers.Count) do
      begin
        Combo_Printers.Items.Add (Printers[I]);
      end; 

      if (RpDev.DeviceIndex <= Pred(Combo_Printers.Items.Count)) then
        Combo_Printers.ItemIndex := RpDev.DeviceIndex
      else
        Combo_Printers.ItemIndex := 0;

      lstFaxPrinter.Items.Assign(Combo_Printers.Items);
      lstFaxPrinter.ItemIndex := Combo_Printers.ItemIndex;

      // *EN552XL Load printers into Excel Printers List
      lstExcelPrinter.Items.Assign(Combo_Printers.Items);
      lstExcelPrinter.ItemIndex := Combo_Printers.ItemIndex;

      // *EN560HTML Load printers into HTML Printers List
      lstHTMLPrinter.Items.Assign(Combo_Printers.Items);
      lstHTMLPrinter.ItemIndex := Combo_Printers.ItemIndex;

      lstDBFPrinter.Items.Assign(Combo_Printers.Items);
      lstDBFPrinter.ItemIndex := Combo_Printers.ItemIndex;

      lstCSVPrinter.Items.Assign(Combo_Printers.Items);
      lstCSVPrinter.ItemIndex := Combo_Printers.ItemIndex;
    end;
  end; 

  DefSuggPrinter := -1;

  { Default to global flag }
  if PrintToPrinter then
    ActiveControl := Radio_Printer
  else
    ActiveControl := Radio_Preview;

  if eCommsModule then
  begin
    tabshFax.TabVisible := PChkAllowed_In(267);
    tabshEmail.TabVisible := PChkAllowed_In(266);
  end;

  { if Faxing by Enterprise - check the client is running }
  if eCommsModule and (SyssEDI2^.EDI2Value.FxUseMAPI=0) then
  begin
    OldHwnd := 0;
    EnumWindows (@EnumWndProc_FaxClnt, Longint(@OldHwnd));

    if (OldHwnd = 0) or (not PChkAllowed_In(267)) then
    begin
      { Wot No Fax Client - Disable Fax tab }
      tabshFax.TabVisible := False;
    end;
  end;

  // Show Excel Tab for reports but not forms
  tabshExcel.TabVisible := Not ShowForm;

  If (tabshExcel.TabVisible) then
  Begin
//    chkExcelOpenXLS.Checked := PrintOpenExcel;
//    chkExcelIncludePageHeaders.Checked := PrintExcelPages;
//    chkExcelIncludeTotals.Checked := PrintExcelTotals;
  end;

  // Show HTML Tab for reports but not forms
  tabshHTML.TabVisible := Not ShowForm;

  radDBFFile.Checked := True;
  radDBFFile.Enabled := False;
  radDBFPreview.Enabled := False;
  radCSVFile.Checked := True;
  radCSVFile.Enabled := False;
  radCSVPreview.Enabled := False;
  
end;

{ == procedure to set from prninfo record outputs == }

procedure TPrintDlg.OutPrnInfoDetails;

var
  {NewItem  : TlistItem;}
  ListObj  : TEmailDetsObjType;
begin
  edtFaxToName.Text := lPrnInfo.feFaxTo;
  edtFaxToNo.Text := lPrnInfo.feFaxToNo;

  if (lPrnInfo.feEmailToAddr<>'') then
  begin
    lvRecips.Items.Clear;

    ListObj := TEmailDetsObjType.Create;
    try
      with ListObj do
      begin
        edType     := 0;
        edName     := lPrnInfo.feEmailTo;
        edAddress  := lPrnInfo.feEmailToAddr;
      end;

      { Details specified - add to list }
      SetListItem (ListObj, lvRecips.Items.Add);
    except
      ListObj.Destroy;
    end;
  end; 

  lstEmlCompress.ItemIndex := lPrnInfo.feEmailZip;
  ChkEmlReader.Checked := lPrnInfo.feEmailReader;
end;

function TPrintDlg.Current_Page  :  Integer;


begin


  Result := pcLivePage(PAgeControl1);

end;


procedure TPrintDlg.ChangePage(NewPage  :  Integer);


begin

  if (Current_Page<>NewPage) then
  with PageControl1 do
  if (Pages[NewPage].TabVisible) then
  begin
    ActivePage := Pages[NewPage];

    PageControl1Change(PageControl1);
  end;
end; 

procedure TPrintDlg.WMCustGetRec(var message  :  TMessage);



begin


  with message do
  begin

    {if (Debug) then
      DebugForm.Add('Mesage Flg'+IntToStr(WParam));}

    Case WParam of
      175
         :  with PageControl1 do
              ChangePage(FindNextPage(ActivePage,(LParam=0),BOn).PageIndex);
              {ChangePage(GetNewTabIdx(PageControl1,LParam));}

    end;
  end;
end; 


function TPrintDlg.Execute(    FormName   : ShortString;
                           var PrnInfo    : TSBSPrintSetupInfo;
                               DefPrinter : ShortString ) : Boolean;

var
  {NewItem  : TlistItem;}
  ListObj  : TEmailDetsObjType;
begin
  Combo_Printers.ItemIndex := pfFind_DefaultPrinter(DefPrinter);
  If (Combo_Printers.ItemIndex = -1) Then
    Combo_Printers.ItemIndex := pfFind_DefaultPrinter(SyssVAT.VATRates.ReportPrnN);

  {if (PrnInfo.DevIdx>-1) and (PrnInfo.DevIdx <= Pred(Combo_Printers.Items.Count)) then
    lstFaxPrinter.ItemIndex := PrnInfo.DevIdx;}
  lstFaxPrinter.ItemIndex := pfFind_DefaultPrinter(SyssEDI2^.EDI2Value.FaxPrnN);

  lPrnInfo := PrnInfo;
  Combo_PrintersClick(Self);        { load lPrnInfo with current printer details }

  if (not eCommsModule) then {* if module not enabled, then hide extra tabs *}
  begin
    tabshFax.TabVisible := False;
    tabshEmail.TabVisible := False;
  end
  else
  begin
    // HM 08/03/00: Done in FormCreate with checks on client - this just breaks it!
    //tabshFax.TabVisible := PChkAllowed_In(267);
    tabshEmail.TabVisible := PChkAllowed_In(266);

    {* Check feTypes to hide extra tabs on specific modes *}
    with PrnInfo do
    begin
      if ((feTypes and 2) = 2) then
        tabshFax.TabVisible := FALSE;

      if ((feTypes and 4) = 4) then
        tabshEmail.TabVisible := FALSE;

      if ((feTypes and 16) = 16) then
        tabshExcel.TabVisible := FALSE;

      if ((feTypes and 32) = 32) then
        tabshHTML.TabVisible := FALSE;
    end;
  end;

  { Setup Fax dialog }
  if (SyssEDI2^.EDI2Value.FxUseMAPI = 1) then
  begin
    if TestedMAPI and (not GotMAPI) then
    begin
      { MAPI not available - disable faxing }
      tabshFax.TabVisible := False;
    end; 

    { Priority only available for Enterprise faxing }
    lstFaxPriority.Enabled := False;
  end 
  else
  begin
    if (SyssEDI2^.EDI2Value.FxUseMAPI = 2) then
    begin
      { 3rd party faxing software }
      //lstFaxPrinter.ItemIndex := pfFind_DefaultPrinter(SyssEDI2^.EDI2Value.FaxPrnN);
      lstFaxPrinter.Enabled := False;
    end 
    else
    begin
      { non-MAPI faxing - always using Async driver }
      //lstFaxPrinter.ItemIndex := pfFind_DefaultPrinter(SyssEDI2^.EDI2Value.FaxPrnN);
      lstFaxPrinter.Enabled := False;
      btnFaxSetupPrinter.Enabled := BOff;
    end;
  end;

  edtFaxFromName.Text := Syss.UserName;
  edtFaxFromNo.Text := Syss.DetailFax;
  lstFaxPriority.ItemIndex := 1;  // Normal
  chkFaxCover.Checked := GlobFaxCover;

  { Setup Email dialog }
  if SyssEDI2^.EDI2Value.EmUseMAPI and TestedMAPI and (not GotMAPI) then
  begin
    { MAPI not available - disable emailing }
    tabshEmail.TabVisible := False;
  end; 

  //edtEmlForm.Text := UseForm;
  //edtEmlCover.Text := SyssForms^.FormDefs.PrimaryForm[43];
  edtEmlSendName.Text := SyssEDI2^.EDI2Value.EmName;
  edtEmlSendAddr.Text := SyssEDI2^.EDI2Value.EmAddress;
  lstEmlPriority.ItemIndex := SyssEDI2^.EDI2Value.EmPriority;

  edtExcelPath.Text := LastExcelPath;

  edtHTMLPath.Text := ChangeFileExt(PrnInfo.feXMLFileDir,'.HTML');
  LastHTMLPath := PrnInfo.feXMLFileDir;

  edtDBFPath.Text := ChangeFileExt(PrnInfo.feXMLFileDir,'.DBF');
  LastDBFPath := PrnInfo.feXMLFileDir;

  edtCSVPath.Text := ChangeFileExt(PrnInfo.feXMLFileDir,'.CSV');
  LastCSVPath := PrnInfo.feXMLFileDir;

  OutPrnInfoDetails;

  edtEmlSubject.Text := PrnInfo.feEmailSubj;
  memEmlMessage.Text := PrnInfo.feEmailMsg;
  memFaxMessage.Text := PrnInfo.feFaxMsg;

  chkExcelOpenXLS.Checked := PrnInfo.feMiscOptions[Integer(XLS_AUTO_OPEN)]; // 1 = Open XLS automatically

  chkXLIncludeReportHeader.Checked  := PrnInfo.feMiscOptions[Integer(XLS_SHOW_REPORT_HEADER)];
  chkXLIncludePageHeader.Checked    := PrnInfo.feMiscOptions[Integer(XLS_SHOW_PAGE_HEADER)];
  chkXLIncludeSectionHeader.Checked := PrnInfo.feMiscOptions[Integer(XLS_SHOW_SECTION_HEADER)];
  chkXLIncludeReportLines.Checked   := PrnInfo.feMiscOptions[Integer(XLS_SHOW_REPORT_LINES)];
  chkXLIncludeSectionFooter.Checked := PrnInfo.feMiscOptions[Integer(XLS_SHOW_SECTION_FOOTER)];
  chkXLIncludePageFooter.Checked    := PrnInfo.feMiscOptions[Integer(XLS_SHOW_PAGE_FOOTER)];
  chkXLIncludeReportFooter.Checked  := PrnInfo.feMiscOptions[Integer(XLS_SHOW_REPORT_FOOTER)];

  // CJS 2014-07-09 - ABSEXCH-15307 - CSV headers on export from VRW
  chkCSVIncludeSectionHeaders.Checked := PrnInfo.feMiscOptions[Integer(CSV_SHOW_SECTION_HEADER)];

  chkHTMLOpenHTML.Checked := PrnInfo.feMiscOptions[Integer(HTML_AUTO_OPEN)]; // 1 = Open HTML automatically

  chkDBFOpenDBF.Checked := PrnInfo.feMiscOptions[Integer(DBF_AUTO_OPEN)]; // 1 = Open DBF automatically

  chkCSVOpenCSV.Checked := PrnInfo.feMiscOptions[Integer(CSV_AUTO_OPEN)]; // 1 = Open CSV automatically

  // HM 24/05/00: Added defaulting of tab
  if (PrnInfo.fePrintMethod = 0) and tabshPrinter.TabVisible then
    // Printer
    PageControl1.ActivePage := tabshPrinter
  else if (PrnInfo.fePrintMethod = 1) and tabshFax.TabVisible then
    // Fax
    PageControl1.ActivePage := tabshFax
  else if (PrnInfo.fePrintMethod = 2) and tabshEmail.TabVisible then
    // Email
    PageControl1.ActivePage := tabshEmail
  else if (PrnInfo.fePrintMethod = 4) and tabshDBFFile.TabVisible then
    // DBF
    PageControl1.ActivePage := tabshDBFFile
  else if (PrnInfo.fePrintMethod = 5) and tabshExcel.TabVisible then
    // Excel
    PageControl1.ActivePage := tabshExcel
  else if (PrnInfo.fePrintMethod = 6) and tabshCSVFile.TabVisible then
    // CSV
    PageControl1.ActivePage := tabshCSVFile
  else if (PrnInfo.fePrintMethod = 7) and tabshHTML.TabVisible then
    // HTML
    PageControl1.ActivePage := tabshHTML
  else if tabshPrinter.TabVisible then
    // Who Knows - Default to printer
    PageControl1.ActivePage := tabshPrinter;
    
  PageControl1Change(Self);

  { Display Form }
  ShowModal;
  PrnInfo := lPrnInfo;

  Result := OkPressed;

  if Result then
  begin
    { Copy details from form back into record }
    with PrnInfo do
    begin
      case fePrintMethod of
        0 : begin // Printer
              feCoverSheet := '';
              Preview := Radio_Preview.Checked;
              NoCopies := StrToInt(Trim(CopiesF.Text));
            end;
        1 : begin // Fax
              Preview := radFaxPreview.Checked;
              NoCopies := 1;

              GlobFaxCover := chkFaxCover.Checked;
              if GlobFaxCover then
                feCoverSheet := 'AAAAAAAA'
              else
                feCoverSheet := '';

              //UseForm := edtFaxForm.Text;

              if (SyssEDI2^.EDI2Value.FxUseMAPI<>1) then
              begin
                { Set printer to Async Pro Fax Driver }
                DevIdx := pfFind_DefaultPrinter(SyssEDI2^.EDI2Value.FaxPrnN);
                FormNo := 0;
                FormName := '';
                BinNo := 0;
                BinName := '';
              end;
            end;
        2 : begin { Email }
              Preview := radEmlPreview.Checked;
              NoCopies := 1;

              //UseForm := edtEmlForm.Text;

              { Set printer to Adobe PDF Writer }
              DevIdx := pfFind_DefaultPrinter(SyssEDI2^.EDI2Value.EmailPrnN);
              FormNo := 0;
              FormName := '';
              BinNo := 0;
              BinName := '';
            end;
        4 : begin // DBF file
              Preview := radDBFPreview.Checked;

              feXMLFileDir := edtDBFPath.Text;
              LastDBFPath := edtDBFPath.Text;

              // Set the new option fields
              feMiscOptions[Integer(DBF_AUTO_OPEN)] := chkDBFOpenDBF.Checked; // 1 = Open DBF automatically
              PrintOpenDBF := chkDBFOpenDBF.Checked;
            end;
        5 : begin
              // Update print info structure
              Preview := radExcelPreview.Checked;

              feXMLFileDir := edtExcelPath.Text;
              LastExcelPath := edtExcelPath.Text;

              // Set the new option fields
              feMiscOptions[Integer(XLS_AUTO_OPEN)] := chkExcelOpenXLS.Checked; // 1 = Open XLS automatically

              feMiscOptions[Integer(XLS_SHOW_REPORT_HEADER)]  := chkXLIncludeReportHeader.Checked;
              feMiscOptions[Integer(XLS_SHOW_PAGE_HEADER)]    := chkXLIncludePageHeader.Checked;
              feMiscOptions[Integer(XLS_SHOW_SECTION_HEADER)] := chkXLIncludeSectionHeader.Checked;
              feMiscOptions[Integer(XLS_SHOW_REPORT_LINES)]   := chkXLIncludeReportLines.Checked;
              feMiscOptions[Integer(XLS_SHOW_SECTION_FOOTER)] := chkXLIncludeSectionFooter.Checked;
              feMiscOptions[Integer(XLS_SHOW_PAGE_FOOTER)]    := chkXLIncludeReportFooter.Checked;
              feMiscOptions[Integer(XLS_SHOW_REPORT_FOOTER)]  := chkXLIncludeReportFooter.Checked;

//              PrintOpenExcel := chkExcelOpenXLS.Checked;
//              PrintExcelPages := chkExcelIncludePageHeaders.Checked;
//              PrintExcelTotals := chkExcelIncludeTotals.Checked;
            end; // Excel
        6 : begin
              Preview := radCSVPreview.Checked;

              feXMLFileDir := edtCSVPath.Text;
              LastCSVPath := edtCSVPath.Text;

              // Set the new option fields
              feMiscOptions[Integer(CSV_AUTO_OPEN)] := chkCSVOpenCSV.Checked; // 1 = Open CSV automatically

              // CJS 2014-07-09 - ABSEXCH-15307 - CSV headers on export from VRW
              feMiscOptions[Integer(CSV_SHOW_SECTION_HEADER)] := chkCSVIncludeSectionHeaders.Checked;

              PrintOpenCSV := chkCSVOpenCSV.Checked;
            end; // CSV
        7 : begin
              // Update print info structure
              Preview := radHTMLPreview.Checked;

              feXMLFileDir := edtHTMLPath.Text;
              LastHTMLPath := edtHTMLPath.Text;

              // Set the new option fields
              feMiscOptions[Integer(HTML_AUTO_OPEN)] := chkHTMLOpenHTML.Checked; // 1 = Open HTML automatically
              PrintOpenHTML := chkHTMLOpenHTML.Checked;
            end; // HTML
      end; // case fePrintMethod of...

      feFaxMethod     := SyssEDI2^.EDI2Value.FxUseMAPI;
      feFaxFrom       := edtFaxFromName.Text;
      feFaxFromNo     := edtFaxFromNo.Text;
      feFaxTo         := edtFaxToName.Text;
      feFaxToNo       := edtFaxToNo.Text;
      feFaxMsg        := memFaxMessage.Text;
      feFaxPriority   := lstFaxPriority.ItemIndex;

      feEmailMAPI     := SyssEDI2^.EDI2Value.EmUseMAPI;
      feEmailFrom     := edtEmlSendName.Text;
      feEmailFromAd   := edtEmlSendAddr.Text;
      feEmailSubj     := edtEmlSubject.Text;
      feEmailMsg      := memEmlMessage.Text;
      feEmailAttach   := edtEmlAttach.Text;    { not available in this version }
      feEmailPriority := lstEmlPriority.ItemIndex;
      feEmailReader   := chkEmlReader.Checked;
      feEmailZIP      := lstEmlCompress.ItemIndex;
      feEmailAtType   := SyssEDI2^.EDI2Value.emAttchMode;

      feEmailTo       := '';
      feEmailCc       := '';
      feEmailBcc      := '';    { not available in this version, but coded anyway! }

      { De-allocate objects in email recipients list whilst building recipient list }
      while (lvRecips.Items.Count > 0) do
      begin
        ListObj := lvRecips.Items.Item[0].Data;

        lvRecips.Items.Delete(0);

        if (fePrintMethod In [2, 3]) then {*en431 XML}
          ListObj.UpdateEmStrings(feEmailTo, feEmailCc, feEmailBcc);

        ListObj.Free;
      end;
    end;
  end;
end;

procedure TPrintDlg.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  { Set global default flag }
  PrintToPrinter := Radio_Printer.Checked;
end;

procedure TPrintDlg.FormDestroy(Sender: TObject);
begin
  if (Assigned(FReportFont)) then
    FReportFont.Free;
end;

procedure TPrintDlg.Button_OKClick(Sender: TObject);
var
  Device, Driver, Port : array [0..79] of Char;
  DeviceMode : THandle;
begin
  lPrnInfo.fePrintMethod := 0;

  if (Combo_Printers.ItemIndex >= 0)  then
  begin
    OkPressed := True;
    ModalResult := mrOk;
  end;
end;

procedure TPrintDlg.Button_CancelClick(Sender: TObject);
begin
  OkPressed := False;
  ModalResult := mrCancel;
end;

procedure TPrintDlg.btnSetupPrinterClick(Sender: TObject);
var
  oPrnInfo : TSBSPrintSetupInfo;
  oOrient  : TOrientation;
begin
  { save current print setup }
  oPrnInfo := RpDev.SBSSetupInfo;
  oOrient  := RpDev.Orientation;

  { Load PrnInfo with printer setup info }
  RpDev.SetPrnSetup(lPrnInfo);
  RpDev.Orientation := ThisOrient;
  if RpDev.PrinterSetUpDialog then
  begin
    lPrnInfo := RpDev.SBSSetupInfo;

    if (Sender = btnSetupPrinter) then
      // Printer
      Combo_Printers.ItemIndex := RpDev.DeviceIndex
    else if (Sender = btnFaxSetupPrinter) then
      // Fax
      lstFaxPrinter.ItemIndex := RpDev.DeviceIndex
    else if ((Sender = btnExcelSetupPrinter) or
             (Sender = lstExcelPrinter)) then
      // Excel
      lstExcelPrinter.ItemIndex := RpDev.DeviceIndex
    else if ((Sender = btnHTMLSetupPrinter) or
             (Sender = lstHTMLPrinter)) then
      // HTML
      lstHTMLPrinter.ItemIndex := RpDev.DeviceIndex
    else if ((Sender = btnDBFOK) or
             (Sender = lstDBFPrinter)) then
      // DBF
      lstDBFPrinter.ItemIndex := RpDev.DeviceIndex
    else if ((Sender = btnCSVOK) or
             (Sender = lstCSVPrinter)) then
      // CSV 
      lstCSVPrinter.ItemIndex := RpDev.DeviceIndex
    else
      raise Exception.Create ('Error in TPrintDlg.SetupPrinter - "Unhandled Sender" - Please notify your Technical Support');

    ThisOrient := RpDev.Orientation;
  end; 

  { restore previous print setup }
  RpDev.SetPrnSetup(oPrnInfo);
  RpDev.Orientation := oOrient;
end;

procedure TPrintDlg.CopiesFChange(Sender: TObject);
begin
  with CopiesF do
    if (ActiveControl<>Button_Cancel) then
    begin
      if (not (StrToInt(Trim(Text)) In [1..99])) then
      begin
        ShowMessage('The number of copies must be between 1-99');
        Text := '1';
        SetFocus;
      end;
    end;
end;

procedure TPrintDlg.FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  BTSupU2.GlobFormKeyDown(Sender,Key,Shift,ActiveControl,Handle);
end;

procedure TPrintDlg.FormKeyPress(Sender: TObject; var Key: Char);
begin
  BTSupU2.GlobFormKeyPress(Sender,Key,ActiveControl,Handle);
end;

procedure TPrintDlg.Combo_PrintersClick(Sender: TObject);
var
  oPrnInfo : TSBSPrintSetupInfo;
  oOrient  : TOrientation;
begin
  { save current print setup }
  oPrnInfo := RpDev.SBSSetupInfo;
  oOrient  := RpDev.Orientation;

  RpDev.SetPrnSetup(lPrnInfo);

  { Load PrnInfo with printer setup info }
  RpDev.DeviceIndex := Combo_Printers.ItemIndex;
  //lPrnInfo := RpDev.SBSSetupInfo;           {*en431 XML}
  {ThisOrient := RpDev.Orientation;}
  lPrnInfo := RpDev.SBSSetupInfo2(lPrnInfo);  {*en431 XML}

  { restore previous print setup }
  RpDev.SetPrnSetup(oPrnInfo);
  RpDev.Orientation := oOrient;
end;

procedure TPrintDlg.PageControl1Changing(Sender: TObject; var AllowChange: Boolean);
begin
  if (AllowChange) then
  begin
    Release_PageHandle(Sender);
    LockWindowUpDate(Handle);
  end;
end;


procedure TPrintDlg.PageControl1Change(Sender: TObject);
var
  TmpIdx : LongInt;
begin
  self.HelpContext := PageControl1.ActivePage.HelpContext;
  { reformat screen }
  if (PageControl1.ActivePage = tabshPrinter) then
  begin
    { Print To Printer/Preview }
    Caption := 'Print Setup - Printer';

    Self.ClientHeight := 170;
    Self.ClientWidth := 407;
    PageControl1.Height := 161;
    PageControl1.Width := 397;

    { Setup printer details for selected printer }
    Combo_PrintersClick(Combo_Printers);
  end
  else if (PageControl1.ActivePage = tabshFax) then
  begin
    { Print To Fax }
    Caption := 'Print Setup - Fax';

    Self.ClientHeight := 346;
    Self.ClientWidth := 407;
    PageControl1.Height := 337;
    PageControl1.Width := 397;

    { Setup printer details for selected printer }
    Combo_PrintersClick(lstFaxPrinter);

    if (not TestedMAPI) and (SyssEDI2^.EDI2Value.FxUseMAPI = 1) then
      CheckForMAPI;
  end
  else if (PageControl1.ActivePage = tabshEmail) then
  begin
    { Print To Email }
    Caption := 'Print Setup - Email';

    Self.ClientHeight := 383;
    Self.ClientWidth := 489;
    PageControl1.Height := 374;
    PageControl1.Width := 479;

    { Move Email Details to Email page } {*en431 XML}
    if (grpEmailDets.Parent <> tabshEmail) then
    begin
      TmpIdx := lstEmlPriority.ItemIndex;
      grpEmailDets.Parent := tabshEmail;
      grpEmailDets.Top := 77;
      grpEmailDets.Left := 3;
      grpEmailDets.Visible := True;
      grpEmailDets.TabOrder := btnEmlOK.TabOrder;
      lstEmlPriority.ItemIndex := TmpIdx;
    end;

    if (not TestedMAPI) and (SyssEDI2^.EDI2Value.EmUseMAPI) then
      CheckForMAPI;
  end
  else if (PageControl1.ActivePage = tabshExcel) then
  begin
    // Print To Excel
    Caption := 'Print Setup - Excel';

//    Self.ClientHeight := 280;
    Self.ClientHeight := 330;
    Self.ClientWidth := 489;
//    PageControl1.Height := 271;
    PageControl1.Height := 321;
    PageControl1.Width := 479;

    { Setup printer details for selected printer }
    Combo_PrintersClick(lstExcelPrinter);

    if (not FXLSCheck) then
    begin
      // Check for Excel availability
      FXLSCheck := True;

      // Lookup .XLS in HKEY_CLASSES_ROOT
      with TRegistry.Create do
        try
          Access := KEY_READ;
          RootKey := HKEY_CLASSES_ROOT;

          // Only enable the auto-open if there is an app to open XLS files
          chkExcelOpenXLS.Enabled := KeyExists('.XLSX');
        finally
          Free;
        end;
    end; // If (Not FXLSCheck)

    if (Trim(LastExcelPath) = '') then
    begin
      // Get My Documents path from registry and use as default path
      with TRegistry.Create do
        try
          Access := KEY_READ;
          RootKey := HKEY_CURRENT_USER;

          // Look for default path
          if KeyExists('Software\Microsoft\Windows\CurrentVersion\Explorer\Shell Folders') then
            if OpenKey('Software\Microsoft\Windows\CurrentVersion\Explorer\Shell Folders', False) then
              if ValueExists('Personal') then
                LastExcelPath := ReadString('Personal');
        finally
          Free;
        end;

      if (Trim(LastExcelPath) <> '') and DirectoryExists (LastExcelPath) then
        edtExcelPath.Text := IncludeTrailingPathDelimiter(LastExcelPath);
    end; // If (Trim(LastExcelPath) = '')
  end // If (PageControl1.ActivePage = tabshExcel)
  else if (PageControl1.ActivePage = tabshHTML) then
  begin
    // Print To HTML
    Caption := 'Print Setup - HTML';

    Self.ClientHeight := 238; //280;
    Self.ClientWidth := 489;
    PageControl1.Height := 229; //271;
    PageControl1.Width := 479;

    { Setup printer details for selected printer }
    Combo_PrintersClick(lstHTMLPrinter);

    if (not FHTMLCheck) then
    begin
      // Check for HTML Viewer availability
      FHTMLCheck := True;

      // Lookup .XLS in HKEY_CLASSES_ROOT
      with TRegistry.Create do
        try
          Access := KEY_READ;
          RootKey := HKEY_CLASSES_ROOT;

          // Only enable the auto-open if there is an app to open XLS files
          chkHTMLOpenHTML.Enabled := KeyExists('.HTML');
        finally
          Free;
        end;
    end; // If (Not FHTMLCheck)

    if (Trim(LastHTMLPath) = '') then
    begin
      // Get My Documents path from registry and use as default path
      with TRegistry.Create do
        try
          Access := KEY_READ;
          RootKey := HKEY_CURRENT_USER;

          // Look for default path
          if KeyExists('Software\Microsoft\Windows\CurrentVersion\Explorer\Shell Folders') then
            if OpenKey('Software\Microsoft\Windows\CurrentVersion\Explorer\Shell Folders', False) then
              if ValueExists('Personal') then
                LastHTMLPath := ReadString('Personal');
        finally
          Free;
        end;

      if (Trim(LastHTMLPath) <> '') and DirectoryExists(LastHTMLPath) then
        edtHTMLPath.Text := IncludeTrailingPathDelimiter(LastHTMLPath);
    end; // If (Trim(LastHTMLPath) = '')
  end // If (PageControl1.ActivePage = tabshHTML)
  else if (PageControl1.ActivePage = tabshDBFFile) then
  begin
    // Print To DBF
    Caption := 'Print Setup - DBF';

    Self.ClientHeight := 238;
    Self.ClientWidth := 489;
    PageControl1.Height := 229;
    PageControl1.Width := 479;

    { Setup printer details for selected printer }
    Combo_PrintersClick(lstDBFPrinter);

    if (not FDBFCheck) then
    begin
      // Check for Excel (DBF) availability
      FDBFCheck := True;

      // Lookup .DBF in HKEY_CLASSES_ROOT
      with TRegistry.Create do
        try
          Access := KEY_READ;
          RootKey := HKEY_CLASSES_ROOT;

          // Only enable the auto-open if there is an app to open DBF files
          chkDBFOpenDBF.Enabled := KeyExists('.DBF');
        finally
          Free;
        end;
    end; // If (Not FDBFCheck)
    
    if (Trim(LastDBFPath) = '') then
    begin
      // Get My Documents path from registry and use as default path
      with TRegistry.Create do
        try
          Access := KEY_READ;
          RootKey := HKEY_CURRENT_USER;

          // Look for default path
          if KeyExists('Software\Microsoft\Windows\CurrentVersion\Explorer\Shell Folders') then
            if OpenKey('Software\Microsoft\Windows\CurrentVersion\Explorer\Shell Folders', False) then
              if ValueExists('Personal') then
                LastExcelPath := ReadString('Personal');
        finally
          Free;
        end;

      if (Trim(LastDBFPath) <> '') and DirectoryExists(LastDBFPath) then
        edtDBFPath.Text := IncludeTrailingPathDelimiter(LastDBFPath);
    end; // If (Trim(LastDBFPath) = '')
    
  end // else if (PageControl1.ActivePage = tabshDBFFile) then
  else if (PageControl1.ActivePage = tabshCSVFile) then
  begin
    // Print To CSV
    Caption := 'Print Setup - CSV';

    Self.ClientHeight := tabshCSVFile.Top + btnCSVOk.Top + btnCSVOk.Height + 16; // 238;
    Self.ClientWidth := 489;
    PageControl1.Height := tabshCSVFile.Top + btnCSVOk.Top + btnCSVOk.Height + 8; // 229;
    PageControl1.Width := 479;

    { Setup printer details for selected printer }
    Combo_PrintersClick(lstCSVPrinter);

    if (not FCSVCheck) then
    begin
      // Check for Excel (CSV) availability
      FCSVCheck := True;

      // Lookup .DBF in HKEY_CLASSES_ROOT
      with TRegistry.Create do
        try
          Access := KEY_READ;
          RootKey := HKEY_CLASSES_ROOT;

          // Only enable the auto-open if there is an app to open CSV files
          chkCSVOpenCSV.Enabled := KeyExists('.CSV');
        finally
          Free;
        end;
    end; // If (Not FCSVCheck)

    if (Trim(LastCSVPath) = '') then
    begin
      // Get My Documents path from registry and use as default path
      with TRegistry.Create do
        try
          Access := KEY_READ;
          RootKey := HKEY_CURRENT_USER;

          // Look for default path
          if KeyExists('Software\Microsoft\Windows\CurrentVersion\Explorer\Shell Folders') then
            if OpenKey('Software\Microsoft\Windows\CurrentVersion\Explorer\Shell Folders', False) then
              if ValueExists('Personal') then
                LastExcelPath := ReadString('Personal');
        finally
          Free;
        end;

      if (Trim(LastCSVPath) <> '') and DirectoryExists(LastCSVPath) then
        edtCSVPath.Text := IncludeTrailingPathDelimiter(LastCSVPath);
    end; // If (Trim(LastCSVPath) = '')

  end; // else if (PageControl1.ActivePage = tabshCSVFile) then

  LockWindowUpDate(0);
end;

procedure TPrintDlg.btnFaxOKClick(Sender: TObject);
const
  NumSet = [' ', '0'..'9'];
var
  TmpStr : ShortString;
  I : Byte;
  OK : Boolean;
begin
  btnFaxOK.SetFocus;

  lPrnInfo.fePrintMethod := 1;

  { Check a printer is specified }
  if (lstFaxPrinter.ItemIndex >= 0) then
  begin
    { Check To details are set }
    if (Trim(edtFaxToName.Text) <> '') and (Trim(edtFaxToNo.Text) <> '') then
    begin
      { Check number consists of valid characters }
      OK := True;
      TmpStr := edtFaxToNo.Text;
      for I := 1 to Length(TmpStr) do
      begin
        if not (TmpStr[I] in NumSet) then
        begin
          { Invalid character }
          MessageDlg ('The To Number is invalid', mtWarning, [mbOk], 0);
          OK := False;
          Break;
        end;
      end;

      if OK then
      begin
        { AOK - Send fax }
        OkPressed := True;
        ModalResult := mrOk;
      end;
    end
    else
    begin
      { Either To Name or To Number is invalid }
      MessageDlg ('The To Name and Number must be specified', mtWarning, [mbOk], 0);
    end;
  end 
  else
  begin
    { Printer not selected }
    MessageDlg ('A printer must be selected', mtWarning, [mbOk], 0);
  end; 
end;

procedure TPrintDlg.btnEmlOKClick(Sender: TObject);
var
  OK : Boolean;
begin
  lPrnInfo.fePrintMethod := 2;

  { Validation ??? }
  if (lvRecips.Items.Count > 0) then
  begin
    { AOK - Send Email }
    OkPressed := True;
    ModalResult := mrOk;
  end
  else
  begin
    { no recipients specified }
    MessageDlg ('At least one recipient must be specified', mtWarning, [mbOk], 0);
    if btnEmlAdd.CanFocus then btnEmlAdd.SetFocus;
  end;
end;

procedure TPrintDlg.CheckForMAPI;
begin { CheckForMAPI }
  { Check to see if MAPI is available }
  GotMapi := MAPIAvailable;
  TestedMAPI := True;

  if (not GotMAPI) then
  begin
    ShowMessage ('Fax and Email services through MAPI are not available');
    btnFaxOK.Enabled := False;
    btnEmlOK.Enabled := False;
  end; 
end; { CheckForMAPI }

procedure TPrintDlg.lvRecipsEditing(Sender: TObject; Item: TListItem;
  var AllowEdit: Boolean);
begin
  AllowEdit := False;
end;

procedure TPrintDlg.lvRecipsClick(Sender: TObject);
var
  CurPos  : TPoint;
  Tmp     : TListItem;
begin
  if (not Assigned(lvRecips.Selected)) and (lvRecips.ViewStyle = vsReport) then
  begin
    { try to highlight a match }
    GetCursorPos (CurPos);
    CurPos := lvRecips.ScreenToClient(CurPos);
    CurPos.X := 10;
    Tmp := lvRecips.GetItemAt(CurPos.X, CurPos.Y);
    if Assigned (Tmp) then
    begin
      lvRecips.Selected := Tmp;
      lvRecips.ItemFocused := Tmp;
    end;
  end;
end;


procedure TPrintDlg.SetListItem (ListObj  : TEmailDetsObjType;
                                 ListItem : TListItem);
begin { SetListItem }
  with ListItem do
  begin
    Caption := ListObj.ToStr;
    SubItems.Clear;
    SubItems.Add(ListObj.edName);
    SubItems.Add(ListObj.edAddress);

    Data := ListObj;
  end; 
end; { SetListItem }


procedure TPrintDlg.btnEmlAddClick(Sender: TObject);
var
  ListObj : TEmailDetsObjType;
begin
  ListObj := TEmailDetsObjType.Create;
  try
    if EditEmailDets (ListObj, self) then
    begin
      { Details specified - add to list }
      SetListItem (ListObj, lvRecips.Items.Add);
    end
    else
    begin
      { Add cancelled - destroy object }
      ListObj.Destroy;
    end; 
  except
    ListObj.Destroy;
  end;
end;

procedure TPrintDlg.btnEmlEditClick(Sender: TObject);
var
  ListObj : TEmailDetsObjType;
begin
  { Get object from list }
  if not Assigned (lvRecips.Selected) then
  begin
    { This causes the line to be selected if they click in a column other than the first }
    lvRecipsClick(Sender);
  end; 

  if Assigned (lvRecips.Selected) then
  begin
    ListObj := lvRecips.Selected.Data;

    if EditEmailDets (ListObj, self) then
    begin
      { Details specified - add to list }
      SetListItem (ListObj, lvRecips.Selected);
    end;
  end; 
end;

procedure TPrintDlg.btnEmlDeleteClick(Sender: TObject);
var
  ListObj : TEmailDetsObjType;
begin
  { Get object from list }
  if Assigned (lvRecips.Selected) then
  begin
    { Delete from list and ifoptions list }
    ListObj := lvRecips.Selected.Data;
    ListObj.Free;
    lvRecips.Selected.Delete;
  end; 
end;


procedure TPrintDlg.Popup_Forms_ClearClick(Sender: TObject);
begin
  with Popup_Forms do
  begin
    if PopupComponent is Text8Pt then
      with PopupComponent as Text8Pt do
      begin
        Text := '';
      end; 
  end;
end;

procedure TPrintDlg.Popup_Forms_CacheClick(Sender: TObject);
begin
  with Popup_Forms do
  begin
    if Sender Is TMenuItem then
      with Sender As TMenuItem do
      begin
        if PopupComponent Is Text8Pt then
          with PopupComponent As Text8Pt do
          begin
            Text := Caption;
          end; { with PopupComponent As Text8Pt }
      end; { with Sender As TMenuItem }
  end; { with Popup_Forms }
end;

procedure TPrintDlg.btnAttachListClick(Sender: TObject);
var
  frmEmailAttachs : TfrmEmailAttachs;
  CurDir          : String;
begin
  CurDir := GetCurrentDir;

  frmEmailAttachs := TfrmEmailAttachs.Create(Self);
  try
    with frmEmailAttachs do
    begin
      BuildAttachList(edtEmlAttach.Text);

      ShowModal;

      if OK then
      begin
        edtEmlAttach.Text := GetAttachList;
      end; 
    end; { with frmEmailAttachs }
  finally
    frmEmailAttachs.Free;
  end;

  SetCurrentDir (CurDir);
end;


procedure TPrintDlg.edtFaxToNameDblClick(Sender: TObject);
var
  FoundCode           :  Str20;
  FoundOk, AltMod     :  Boolean;
begin
  if (Sender is Text8pt) then
    with (Sender as Text8pt) do
    begin
      AltMod:=Modified;

      FoundCode:=Strip('B',[#32],Text);

      if (ActiveControl<>BtnFaxCancel) then
      begin
        with Cust do
        begin
          if (CheckKey(Trim(Company),Text,Length(Trim(Company)),BOff)) then
            FoundCode:=Cust.CustCode;

          FoundOk:=(GetCust(Self,FoundCode,FoundCode,BOn,99));

          if FoundOk then
          begin
            SetEcommsFromCust2(Cust,lprnInfo);

            OutPrnInfoDetails;
          end
          else
            SetFocus;
        end;
      end;
    end;
end;

procedure TPrintDlg.lstFaxPrinterClick(Sender: TObject);
var
  oPrnInfo : TSBSPrintSetupInfo;
  oOrient  : TOrientation;
begin
  { save current print setup }
  oPrnInfo := RpDev.SBSSetupInfo;
  oOrient  := RpDev.Orientation;

  RpDev.SetPrnSetup(lPrnInfo);

  { Load PrnInfo with printer setup info }
  RpDev.DeviceIndex := lstFaxPrinter.ItemIndex;
  //lPrnInfo := RpDev.SBSSetupInfo;           {*en431 XML}
  {ThisOrient := RpDev.Orientation;}
  lPrnInfo := RpDev.SBSSetupInfo2(lPrnInfo);  {*en431 XML}

  { restore previous print setup }
  RpDev.SetPrnSetup(oPrnInfo);
  RpDev.Orientation := oOrient;
end;

procedure TPrintDlg.btnFaxSetupPrinterClick(Sender: TObject);
var
  oPrnInfo : TSBSPrintSetupInfo;
  oOrient  : TOrientation;
begin
  { save current print setup }
  oPrnInfo := RpDev.SBSSetupInfo;
  oOrient  := RpDev.Orientation;

  { Load PrnInfo with printer setup info }
  RpDev.SetPrnSetup(lPrnInfo);
  RpDev.Orientation := ThisOrient;
  if RpDev.PrinterSetUpDialog then
  begin
    lPrnInfo := RpDev.SBSSetupInfo;
    //Combo_Printers.ItemIndex := RpDev.DeviceIndex;
    lstFaxPrinter.ItemIndex := RpDev.DeviceIndex;

    ThisOrient:=RpDev.Orientation;
  end; 

  { restore previous print setup }
  RpDev.SetPrnSetup(oPrnInfo);
  RpDev.Orientation := oOrient;
end;

procedure TPrintDlg.Label819DblClick(Sender: TObject);
var
  ListObj : TEmailDetsObjType;
begin
  ListObj := TEmailDetsObjType.Create;
  try
    with ListObj do
    begin
      edType    := 0;
      edName    := edtEmlSendName.Text;
      edAddress := edtEmlSendAddr.Text;
    end; 

    SetListItem (ListObj, lvRecips.Items.Add);
  except
    ListObj.Destroy;
  end;
end;

procedure TPrintDlg.btnFontClick(Sender: TObject);
begin
  FontDialog1.Font.Assign(FReportFont);
  if FontDialog1.Execute then
    // Set ReportFont using property so the property set method updates the form correctly
    ReportFont := FontDialog1.Font;
end;

procedure TPrintDlg.SetFont(const Value: TFont);
begin
  FReportFont.Assign(Value);

  if tabshExcel.TabVisible then
    // Update Font field on Excel Tab if visible
    edtExcelFont.Text := Value.Name + ' ' + IntToStr(Value.Size) + 'pt';

  if tabshHTML.TabVisible then
    // Update Font field on Excel Tab if visible
    edtHTMLFont.Text := Value.Name + ' ' + IntToStr(Value.Size) + 'pt';
end;

procedure TPrintDlg.btnSetPathClick(Sender: TObject);
type
  DlgModeType = (dmExcelPath, dmHTMLPath, dmDBFPath, dmCSVPath);
var
  OrigDir, DirPath : string;
  DlgMode : DlgModeType;
begin
  // Save current directory
  OrigDir := GetCurrentDir;
  try
    // Determine the mode to use
    if (Sender is TMenuItem) then
    begin
      if ((Sender as TMenuItem).Tag > 10) then
        DlgMode := dmHTMLPath
      else
        DlgMode := dmExcelPath;
    end 
    else if ((Sender = btnExcelSetPath) or (Sender = edtExcelPath)) then
      DlgMode := dmExcelPath
    else if ((Sender = btnHTMLSetPath) or (Sender = edtHTMLPath)) then
      DlgMode := dmHTMLPath
    else if ((Sender = btnDBFSetPath) or (Sender = edtDBFPath)) then
      DlgMode := dmDBFPath
    else if ((Sender = btnCSVSetPath) or (Sender = edtCSVPath)) then
      DlgMode := dmCSVPath;

    // Configure the dialog for the approriate details
    case DlgMode of
      dmExcelPath :
        begin
           SaveDialog1.DefaultExt := 'XLSX';
           SaveDialog1.Filter := 'Excel Files|*.XLSX';
           SaveDialog1.InitialDir := ExtractFilePath(edtExcelPath.Text);
           SaveDialog1.FileName := ExtractFileName(edtExcelPath.Text);
        end; // dmExcelPath
      dmHTMLPath  :
        begin
          SaveDialog1.DefaultExt := 'HTML';
          SaveDialog1.Filter := 'HTML Files|*.HTML';
          SaveDialog1.InitialDir := ExtractFilePath(edtHTMLPath.Text);
          SaveDialog1.FileName := ExtractFileName(edtHTMLPath.Text);
        end; // dmHTMLPath
      dmDBFPath :
        begin
          SaveDialog1.DefaultExt := 'DBF';
          SaveDialog1.Filter := 'DBF Files|*.DBF';
          SaveDialog1.InitialDir := ExtractFilePath(edtDBFPath.Text);
          SaveDialog1.FileName := ExtractFileName(edtDBFPath.Text);
        end;
      dmCSVPath :
        begin
          SaveDialog1.DefaultExt := 'CSV';
          SaveDialog1.Filter := 'CSV Files|*.CSV';
          SaveDialog1.InitialDir := ExtractFilePath(edtCSVPath.Text);
          SaveDialog1.FileName := ExtractFileName(edtCSVPath.Text);
        end;
      else
        raise Exception.Create('btnSetPathClick: Unhandled Mode - contact your technical support');
    end; // case DlgMode of... 

    if SaveDialog1.Execute Then
      case DlgMode of
        dmExcelPath : edtExcelPath.Text := SaveDialog1.FileName;
        dmHTMLPath  : edtHTMLPath.Text := SaveDialog1.FileName;
        dmDBFPath : edtDBFPath.Text := SaveDialog1.FileName;
        dmCSVPath : edtCSVPath.Text := SaveDialog1.FileName;
      end;

  finally
    // Restore original current directory
    SetCurrentDir(OrigDir);
  end; // Try..Finally
end;

procedure TPrintDlg.btnCSVOKClick(Sender : TObject);
var
  CSVDir, CSVName, FullPath : ShortString;
  bOK : Boolean;
begin
  lPrnInfo.fePrintMethod := 6; // Print to CSV

  // Check a printer is selected
  bOK := (lstCSVPrinter.ItemIndex >= 0);

  if bOK then
  begin
    // Check filename is valid - first check for blank
    CSVDir  := UpperCase(ExtractFilePath(edtCSVPath.Text));
    if (Trim(CSVDir) = '') then
      // Default to Company Data dir
      CSVDir := IncludeTrailingPathDelimiter(SetDrive);

    CSVName := UpperCase(ExtractFileName(edtCSVPath.Text));

    // Check they are both set
    bOK := (Trim(CSVDir) <> '') And (Trim(CSVName) <> '');

    if bOK then
    begin
      // Check the name is valid - must be in format x.CSV
      bOK := (Pos('.CSV', CSVName) = (Length(CSVName) - 3)) And (Length(CSVName) > 4);

      if bOK then
      begin
        // Got filename in format x.CSV - check directory is valid
        try
          bOK := ForceDirectories(CSVDir);
        except
          on E:Exception do
            bOK := False;
        end;

        if (not bOK) then
        begin
          if edtCSVPath.CanFocus then edtCSVPath.SetFocus;
          MessageDlg ('The file path is invalid', mtError, [mbOk], 0);
        end;
      end
      else
      begin
        if edtCSVPath.CanFocus then edtCSVPath.SetFocus;
        MessageDlg ('The filename specified for the report is not a supported format, the filename should be specified in the format x.CSV', mtError, [mbOk], 0);
      end;
    end
    else
    begin
      if edtCSVPath.CanFocus then edtCSVPath.SetFocus;
      MessageDlg ('The filename specified for the report is invalid', mtError, [mbOk], 0);
    end;
  end
  else
  begin
    if edtCSVPath.CanFocus then edtCSVPath.SetFocus;
    MessageDlg ('The filename specified for the report is invalid', mtError, [mbOk], 0);
  end;

  if bOK then
  begin
    FullPath := IncludeTrailingPathDelimiter(CSVDir) + CSVName;

    if FileExists(FullPath) then
    begin
      // Check to see if the file is in use
      if FileIsOpen(FullPath) then
      begin
        // File in use - get user to confirm whether to
        Application.MessageBox('The specified CSV file already exists and is being used by another application.'#13#13 +
                               'To continue you must either close the file or change the filename that you want ' +
                               'to print to.', 'Error: File In Use');

        bOK := False;
      end // if FileIsOpen (FullPath) then...
    end; // if FileExists(FullPath) then...
  end; 

  if bOK then
  begin
    // all OK, so finish dialog
    OkPressed := True;
    ModalResult := mrOk;
  end;
end;

procedure TPrintDlg.btnDBFOKClick(Sender : TObject);
var
  DBFDir, DBFName, FullPath : ShortString;
  bOK : Boolean;
begin
  lPrnInfo.fePrintMethod := 4; // Print to DBF

  // Check a printer is selected
  bOK := (lstDBFPrinter.ItemIndex >= 0);

  if bOK then
  begin
    // Check filename is valid - first check for blank
    DBFDir  := UpperCase(ExtractFilePath(edtDBFPath.Text));
    if (Trim(DBFDir) = '') then
      // Default to Company Data dir
      DBFDir := IncludeTrailingPathDelimiter(SetDrive);

    DBFName := UpperCase(ExtractFileName(edtDBFPath.Text));

    // Check they are both set
    bOK := (Trim(DBFDir) <> '') And (Trim(DBFName) <> '');

    if bOK then
    begin
      // Check the name is valid - must be in format x.DBF
      bOK := (Pos('.DBF', DBFName) = (Length(DBFName) - 3)) And (Length(DBFName) > 4);

      if bOK then
      begin
        // Got filename in format x.DBF - check directory is valid
        try
          bOK := ForceDirectories(DBFDir);
        except
          on E:Exception do
            bOK := False;
        end;

        if (not bOK) then
        begin
          if edtDBFPath.CanFocus then edtDBFPath.SetFocus;
          MessageDlg ('The file path is invalid', mtError, [mbOk], 0);
        end;
      end
      else
      begin
        if edtDBFPath.CanFocus then edtDBFPath.SetFocus;
        MessageDlg ('The filename specified for the report is not a supported format, the filename should be specified in the format x.DBF', mtError, [mbOk], 0);
      end;
    end
    else
    begin
      if edtDBFPath.CanFocus then edtDBFPath.SetFocus;
      MessageDlg ('The filename specified for the report is invalid', mtError, [mbOk], 0);
    end;
  end
  else
  begin
    if edtDBFPath.CanFocus then edtDBFPath.SetFocus;
    MessageDlg ('The filename specified for the report is invalid', mtError, [mbOk], 0);
  end;

  if bOK then
  begin
    FullPath := IncludeTrailingPathDelimiter(DBFDir) + DBFName;

    if FileExists(FullPath) then
    begin
      // Check to see if the file is in use
      if FileIsOpen(FullPath) then
      begin
        // File in use - get user to confirm whether to
        Application.MessageBox('The specified DBF file already exists and is being used by another application.'#13#13 +
                               'To continue you must either close the file or change the filename that you want ' +
                               'to print to.', 'Error: File In Use');

        bOK := False;
      end // if FileIsOpen (FullPath) then...
    end; // if FileExists(FullPath) then...
  end; 

  if bOK then
  begin
    // all OK, so finish dialog
    OkPressed := True;
    ModalResult := mrOk;
  end;
end;

procedure TPrintDlg.btnExcelOKClick(Sender: TObject);
Var
  XLDir, XLName, FullPath : ShortString;
  PrinterSelected : Boolean;
  bOK : Boolean; // used is several places. Set to FALSE if an error.
begin
  lPrnInfo.fePrintMethod := 5; // Print to Excel

//  lPrnInfo.feMiscOptions[Integer(XLS_AUTO_OPEN)]     := chkExcelOpenXLS.Checked; // 1 = Open XLS automatically
//  lPrnInfo.feMiscOptions[Integer(XLS_SHOW_PAGE_HEADER)] := chkExcelIncludePageHeaders.Checked; // 2 = Show Page Headers/Footers
//  lPrnInfo.feMiscOptions[Integer(XLS_SHOW_REPORT_FOOTER)]   := chkExcelIncludeTotals.Checked; // 3 = Show Totals

  // Check a printer is selected
  bOK := (lstExcelPrinter.ItemIndex >= 0);

  if bOK then
  begin
    // Check filename is valid - first check for blank
    XLDir  := UpperCase(ExtractFilePath(edtExcelPath.Text));
    if (Trim(XLDir) = '') then
      // Default to Company Data dir
      XLDir := IncludeTrailingPathDelimiter(SetDrive);
      
    XLName := UpperCase(ExtractFileName(edtExcelPath.Text));

    // Check they are both set
    bOK := (Trim(XLDir) <> '') And (Trim(XLName) <> '');

    if bOK then
    begin
      // Check the name is valid - must be in format x.XLS
      bOK := (Pos('.XLSX', XLName) = (Length(XLName) - 4)) And (Length(XLName) > 5);

      if bOK then
      begin
        // Got filename in format x.XLS - check directory is valid
        try
          bOK := ForceDirectories(XLDir);
        except
          on E:Exception do
            bOK := False;
        end;

        if (not bOK) then
        begin
          if edtExcelPath.CanFocus then edtExcelPath.SetFocus;
          MessageDlg ('The file path is invalid', mtError, [mbOk], 0);
        end;
      end
      else
      begin
        if edtExcelPath.CanFocus then edtExcelPath.SetFocus;
        MessageDlg ('The filename specified for the report is not a supported format, the filename should be specified in the format x.XLS', mtError, [mbOk], 0);
      end;
    end
    else
    begin
      if edtExcelPath.CanFocus then edtExcelPath.SetFocus;
      MessageDlg ('The filename specified for the report is invalid', mtError, [mbOk], 0);
    end;
  end
  else
  begin
    if edtExcelPath.CanFocus then edtExcelPath.SetFocus;
    MessageDlg ('The filename specified for the report is invalid', mtError, [mbOk], 0);
  end;

  if bOK then
  begin
    FullPath := IncludeTrailingPathDelimiter(XLDir) + XLName;

    if FileExists(FullPath) then
    begin
      // Check to see if the file is in use
      if FileIsOpen(FullPath) then
      begin
        // File in use - get user to confirm whether to
        Application.MessageBox('The specified XLS file already exists and is being used by another application.'#13#13 +
                               'To continue you must either close the file or change the filename that you want ' +
                               'to print to.', 'Error: File In Use');

        bOK := False;
      end // if FileIsOpen (FullPath) then...
    end; // if FileExists(FullPath) then...
  end; 

  if bOK then
  begin
    // all OK, so finish dialog
    OkPressed := True;
    ModalResult := mrOk;
  end;

end;

procedure TPrintDlg.btnHTMLOKClick(Sender: TObject);
var
  HTMLDir, HTMLName, FullPath : ShortString;
  bOK : Boolean;
begin
  lPrnInfo.fePrintMethod := 7; // Print to HTML

  // Check a printer is selected
  bOK := (lstHTMLPrinter.ItemIndex >= 0);

  if bOK then
  begin
    // Check filename is valid - first check for blank
    HTMLDir  := UpperCase(ExtractFilePath(edtHTMLPath.Text));
    if (Trim(HTMLDir) = '') then
      // Default to Company Data dir
      HTMLDir := IncludeTrailingPathDelimiter(SetDrive);
      
    HTMLName := UpperCase(ExtractFileName(edtHTMLPath.Text));

    // Check they are both set
    bOK := ((Trim(HTMLDir) <> '') and (Trim(HTMLName) <> ''));

    if bOK then
    begin
      // Check the name is valid - must be in format x.HTML
      bOK := ((Pos('.HTML', HTMLName) = (Length(HTMLName) - 4))) and (Length(HTMLName) > 4);

      if bOK then
      begin
        // Got filename in format x.HTML - check directory is valid
        try
          bOK := ForceDirectories(HTMLDir);
        except
          on E:Exception do
            bOK := False;
        end;

        if (not bOK) then
        begin
          if edtHTMLPath.CanFocus then edtHTMLPath.SetFocus;
          MessageDlg ('The file path is invalid', mtError, [mbOk], 0);
        end;
      end
      else
      begin
        if edtHTMLPath.CanFocus then edtHTMLPath.SetFocus;
        MessageDlg ('The filename specified for the report is not a supported format, the filename should be specified in the format x.HTML', mtError, [mbOk], 0);
      end;
    end
    else
    begin
      if edtHTMLPath.CanFocus then edtHTMLPath.SetFocus;
      MessageDlg ('The filename specified for the report is invalid', mtError, [mbOk], 0);
    end;
  end
  else
  begin
    if edtHTMLPath.CanFocus then edtHTMLPath.SetFocus;
    MessageDlg ('The filename specified for the report is invalid', mtError, [mbOk], 0);
  end; 

  if bOK then
  begin
    FullPath := IncludeTrailingPathDelimiter(HTMLDir) + HTMLName;

    if FileExists(FullPath) then
    begin
      // Check to see if the file is in use
      if FileIsOpen(FullPath) then
      begin
        // File in use - get user to confirm whether to
        Application.MessageBox('The specified HTML file already exists and is being used by another application.'#13#13 +
                               'To continue you must either close the file or change the filename that you want ' +
                               'to print to.', 'Error: File In Use');

        bOK := False;
      end;
    end;
  end;

  if bOK then
  begin
    // all OK, so finish dialog
    OkPressed := True;
    ModalResult := mrOk;
  end; 
end;

initialization
  PrintToPrinter := True;
  PrintToQueue := False;

  GotMAPI := False;
  TestedMAPI := False;

  LastExcelPath := '';
  LastHTMLPath := '';

  PrintOpenHTML := False;

  GlobFaxCover := False;
end.
