unit Prntdlg2;

{$I DEFOVR.Inc}

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, TEditVal, BorBtns, Mask, Menus, sbsprint, RpDefine, RpDevice,
  GlobType, ComCtrls, bkgroup, VarConst, BTSupU1, EmlDetsF, ExtCtrls,
  SBSPanel, TCustom,
// PKR. 11/02/2016. Code cleaning.  Remove the platform-specific warning that
// the FileCtrl unit generates.
{$WARN UNIT_PLATFORM OFF}
  FileCtrl,
{$WARN UNIT_PLATFORM ON}
  ExWrap1U, Buttons, Registry,
  SpellCheck4Modal;

type
  TPrintDlg = class(TForm)
    OpenDialog: TOpenDialog;
    FontDialog1: TFontDialog;
    PageControl1: TPageControl;
    tabshPrinter: TTabSheet;
    tabshFax: TTabSheet;
    tabshEmail: TTabSheet;
    Label81: Label8;
    FNLab: Label8;
    Label83: Label8;
    Radio_Printer: TBorRadio;
    Radio_Preview: TBorRadio;
    Combo_Printers: TSBSComboBox;
    btnSetupPrinter: TButton;
    Button_OK: TButton;
    Button_Cancel: TButton;
    FNBtn: TButton;
    FNF: Text8Pt;
    CopiesF: Text8Pt;
    Radio_Test: TBorCheck;
    Label84: Label8;
    Label86: Label8;
    lstFaxPrinter: TSBSComboBox;
    btnFaxSetupPrinter: TButton;
    btnFaxOK: TButton;
    btnFaxCancel: TButton;
    btnFaxBrowseForm: TButton;
    edtFaxForm: Text8Pt;
    SBSBackGroup1: TSBSBackGroup;
    lblFaxCover: Label8;
    edtFaxCover: Text8Pt;
    btnFaxBrowseCover: TButton;
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
    bgrpTest: TSBSBackGroup;
    Label813: Label8;
    btnEmlOK: TButton;
    btnEmlCancel: TButton;
    btnEmlBrowseForm: TButton;
    edtEmlForm: Text8Pt;
    SBSBackGroup6: TSBSBackGroup;
    lblEmailCover: Label8;
    edtEmlCover: Text8Pt;
    btnEmlBrowseCover: TButton;
    SBSBackGroup5: TSBSBackGroup;
    chkEmlReader: TCheckBox;
    SBSBackGroup8: TSBSBackGroup;
    SBSBackGroup9: TSBSBackGroup;
    radFaxPrinter: TBorRadio;
    radFaxPreview: TBorRadio;
    SBSBackGroup10: TSBSBackGroup;
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
    tabshXML: TTabSheet;
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
    lstEmlPriority: TSBSComboBox;
    btnEmlAdd: TButton;
    btnEmlEdit: TButton;
    btnEmlDelete: TButton;
    btnXMLOK: TButton;
    btnXMLCancel: TButton;
    radXMLFile: TBorRadio;
    SBSBackGroup11: TSBSBackGroup;
    radXMLEmail: TBorRadio;
    grpXMLFile: TSBSGroup;
    Label87: Label8;
    edXMLPath: Text8Pt;
    btnXMLSetDir: TSBSButton;
    grpXMLOptions: TSBSBackGroup;
    chkXLMHTML: TBorCheck;
    Label814: Label8;
    edtEmlAttach: Text8Pt;
    btnBigEdit: TButton;
    btnAttachList: TBitBtn;
    lstEmlCompress: TComboBox;
    panRecips: TPanel;
    lstRecips: TListBox;
    hdrRecips: THeaderControl;
    Shape1: TShape;
    tabshExcel: TTabSheet;
    SBSBackGroup7: TSBSBackGroup;
    Label815: Label8;
    lstExcelPrinter: TSBSComboBox;
    btnExcelSetupPrinter: TButton;
    Label821: Label8;
    edtExcelFont: Text8Pt;
    btnExcelFont: TButton;
    btnExcelOK: TButton;
    btnExcelCancel: TButton;
    SaveDialog1: TSaveDialog;
    SBSBackGroup13: TSBSBackGroup;
    chkExcelOpenXLS: TBorCheckEx;
    chkExcelIncludePageHeaders: TBorCheckEx;
    chkExcelIncludeTotals: TBorCheckEx;
    SBSBackGroup14: TSBSBackGroup;
    Label822: Label8;
    edtExcelPath: Text8Pt;
    btnExcelSetPath: TSBSButton;
    tabshHTML: TTabSheet;
    SBSBackGroup15: TSBSBackGroup;
    Label823: Label8;
    lstHTMLPrinter: TSBSComboBox;
    Label824: Label8;
    edtHTMLFont: Text8Pt;
    btnHTMLFont: TButton;
    btnHTMLSetupPrinter: TButton;
    SBSBackGroup16: TSBSBackGroup;
    radHTMLFile: TBorRadio;
    radHTMLPreview: TBorRadio;
    SBSBackGroup17: TSBSBackGroup;
    Label825: Label8;
    edtHTMLPath: Text8Pt;
    btnHTMLSetPath: TSBSButton;
    btnHTMLOK: TButton;
    btnHTMLCancel: TButton;
    SBSBackGroup18: TSBSBackGroup;
    chkHTMLOpenHTML: TBorCheckEx;
    SpellCheck4Modal1: TSpellCheck4Modal;
    procedure FormCreate(Sender: TObject);
    procedure Button_OKClick(Sender: TObject);
    procedure Button_CancelClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure SelectFormOrFont(Sender: TObject);
    procedure FNFChange(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure CopiesFChange(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure FormKeyPress(Sender: TObject; var Key: Char);
    procedure Combo_PrintersClick(Sender: TObject);
    procedure PageControl1Change(Sender: TObject);
    procedure btnFaxBrowseFormClick(Sender: TObject);
    procedure btnFaxBrowseCoverClick(Sender: TObject);
    procedure btnEmlBrowseFormClick(Sender: TObject);
    procedure btnEmlBrowseCoverClick(Sender: TObject);
    procedure btnFaxOKClick(Sender: TObject);
    procedure edtFaxFormChange(Sender: TObject);
    procedure edtFaxCoverChange(Sender: TObject);
    procedure btnEmlOKClick(Sender: TObject);
    procedure PageControl1Changing(Sender: TObject;
      var AllowChange: Boolean);
    procedure lvRecipsEditing(Sender: TObject; Item: TListItem;
      var AllowEdit: Boolean);
    procedure btnEmlEditClick(Sender: TObject);
    procedure btnEmlAddClick(Sender: TObject);
    procedure btnEmlDeleteClick(Sender: TObject);
    procedure edtFaxToNameDblClick(Sender: TObject);
    procedure edtFaxToNameExit(Sender: TObject);
    procedure Popup_Forms_ClearClick(Sender: TObject);
    procedure Popup_FormsPopup(Sender: TObject);
    procedure Popup_Forms_CacheClick(Sender: TObject);
    procedure btnXMLOKClick(Sender: TObject);
    procedure radXMLClick(Sender: TObject);
    procedure btnXMLSetDirClick(Sender: TObject);
    procedure Label87Click(Sender: TObject);
    procedure btnAttachListClick(Sender: TObject);
    procedure SelectPrinter(Sender: TObject);
    procedure SetupPrinter(Sender: TObject);
    procedure chkEmlReaderClick(Sender: TObject);
    procedure btnBigEditClick(Sender: TObject);
    procedure Label819DblClick(Sender: TObject);
    procedure lstRecipsMeasureItem(Control: TWinControl; Index: Integer;
      var Height: Integer);
    procedure lstRecipsDrawItem(Control: TWinControl; Index: Integer;
      Rect: TRect; State: TOwnerDrawState);
    procedure hdrRecipsSectionResize(HeaderControl: THeaderControl;
      Section: THeaderSection);
    Procedure BrowseForFont(Sender: TObject);
    procedure btnSetPathClick(Sender: TObject);
    procedure btnExcelOKClick(Sender: TObject);
    procedure btnHTMLOKClick(Sender: TObject);
    procedure SetHelpContextIDs; // NF: 11/05/06
  private
    { Private declarations }
    OkPressed  : Boolean;
    lPrnInfo   : TSBSPrintSetupInfo;
    ChkInsertReader : Boolean;

    // PKR. 25/11/2015. ABSEXCH-15333.  Email PORs to relevant suppliers.
    // Underlying field for the UseEmailList property.
    FUseEmailList : Boolean;
    // PKR. 11/02/2016. ABSEXCH-17279. Re-introduce print-to-screen option for Re-order list when sending to printer only.
    FAllowPrintPreview : Boolean;

    // Internal Property used to store the Report Font for Reports
    FReportFont : TFont;

    // Internal property used to indicate if we have checked if Excel is available to open .XLS files
    FXLSCheck : Boolean;

    // Internal property used to indicate if we have checked if anything is available to open .HTML files
    FHTMLCheck : Boolean;

    Procedure BrowseForForm(Const TheEdit : Text8Pt;Const Mode, MruIdx : Byte);
    procedure CheckForMAPI;

    Function Current_Page  :  Integer;

    Procedure ChangePage(NewPage  :  Integer);

    Procedure WMCustGetRec(Var Message  :  TMessage); Message WM_CustGetRec;

    Procedure OutPrnInfoDetails;
    procedure SetFont(const Value: TFont);

    Function ExecuteCustom(WID,EID : Integer) : Boolean;

    // Updates the TSBSPrintSetupInfo containing the printing info from the form
    procedure Form2PrnInfo (Var PrnInfo  : TSBSPrintSetupInfo; Const DestroyObjects : Boolean = True);

    Procedure ClearRecipList;

    // PKR. 25/11/2015. ABSEXCH-15333. Email PORs to relevant suppliers.
    // Procedure to set the fUseEmailList flag (via the UseEmailList property. 
    procedure SetUseEmailList(useState : Boolean = true);
    // PKR. 11/02/2016. ABSEXCH-17279. Re-introduce print-to-screen option for Re-order list when sending to printer only.
    procedure SetAllowPrintPreview(bAllow : Boolean = true);
  public
    { Public declarations }
    DefSuggPrinter{,
    SuggestPrinter}   : Integer;
    ShowForm         : Boolean;
    UseAutoMode      : Boolean;
    Automode         : Byte;
    NeedLabel        : Boolean;
    UseForm          : ShortString;
    ThisOrient       : TOrientation;

    Property ReportFont : TFont Read FReportFont Write SetFont;

    // PKR. 25/11/2015. ABSEXCH-15333. Email PORs to relevant suppliers.
    // Determines whether the email address list and its associated controls should be enabled or disabled
    Property UseEmailList : Boolean Read FUseEmailList Write SetUseEmailList;
    // PKR. 11/02/2016. ABSEXCH-17279. Re-introduce print-to-screen option for Re-order list when sending to printer only.
    property AllowPrintPreview : Boolean read FAllowPrintPreview write SetAllowPrintPreview;

    Function  Execute(FormName : ShortString;Var PrnInfo : TSBSPrintSetupInfo) : Boolean;
    procedure FormPrnInfo(fmInfo : FormInfoType;Var PrnInfo : TSBSPrintSetupInfo);
  end;

  PHWND = ^HWND;

var
  PrintDlg: TPrintDlg;
  PrintToQueue,
  PrintToPrinter: Boolean;
  PrintShowForm : Boolean;




Procedure SetEcommsFromCust(Const LCust    :  CustRec;
                            Var   PrnInfo  :  TSBSPrintSetupInfo;
                                  ExLocal  :  TdMTExLocalPtr;
                                  Update   :  Boolean);

// MH 11/10/2013 v7.X MRD2.4.19: Added support for importing an Account Contact Role's details into the print job
Procedure SetEcommsFromCust_WithRole(Const LCust    : CustRec;
                                      Var   PrnInfo : TSBSPrintSetupInfo;
                                            ExLocal : TdMTExLocalPtr;
                                            Update  : Boolean;
                                      Const RoleId  : Integer);

// MH 11/10/2013 v7.X MRD2.4.19: Added support for identifying a contact role for a transaction print job
Procedure SetEcommsFromCust_TransRole(Const LCust     : CustRec;
                                      Var   PrnInfo   : TSBSPrintSetupInfo;
                                            ExLocal   : TdMTExLocalPtr;
                                            Update    : Boolean;
                                      Const RoleTrans : InvRec);

function EnumWndProc_FaxClnt (Hwnd: THandle; FoundWnd: PHWND): Bool; export; stdcall;

Procedure InitEmailText (Var PrnInfo : TSBSPrintSetupInfo);

 {~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~}

  Implementation


 {~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~}

{$R *.DFM}

Uses
     ETStrU,
     BTSupU2,
     BtrvU2,
     {$IFDEF FRM}
       DLLInt,
     {$ENDIF}

     GlobVar,

     CmpCtrlU,
     CommsInt,

     FormUtil,
     InvListU,
     Mru,
     CompUtil,
     EmlAttch,
     PWarnU,
     BrwseDir,

     {$IFDEF CU} {*EN570*}
       CustIntU,
       CustWinU,
       Event1U,
       oPaper,
     {$ENDIF}

    {$IFDEF EXSQL}
      SQLUtils,
    {$ENDIF}

     // MH 11/10/2013 v7.X MRD2.4.19: Added support for identifying a contact role for a transaction print job
     AccountContactRoleUtil,

     BTSFrmU1,
     PrintFrm,
     EmlMessg,
     FileUtil,
     VAOUtil,
     DupRpDev;


Const
  {$I FilePath.Inc}

Var
  GotMAPI, TestedMAPI : Boolean;
  MruFrm              : TFormsMRU;
  lRpDev              : TDuplicateRpDev;
  // Remembered XML Options
  LastXMLDir          : ShortString; {*en431 XML}
  LastHTMLFlag        : Boolean;
  // Remembered Excel Options
  LastExcelPath       : ShortString;
  PrintOpenExcel      : Boolean;
  PrintExcelPages     : Boolean;
  PrintExcelTotals    : Boolean;
  // Remembered HTML Options
  LastHTMLPath        : ShortString;
  PrintOpenHTML       : Boolean;

{-----------------------------------------------------------------------------}

{ Callback function to identify the form designer window }
function EnumWndProc_FaxClnt (Hwnd: THandle; FoundWnd: PHWND): Bool; export; stdcall;
var
  ClassName : string;
  Tag       : THandle;
Begin { EnumWndProc_FaxClnt }
  Result := True;
  SetLength (ClassName, 100);
  GetClassName (Hwnd, PChar (ClassName), Length (ClassName));
  ClassName := PChar (UpperCase(Trim(ClassName)));

  If (AnsiCompareText (ClassName, 'TFRMFAXCLIENT') = 0) then begin
    Tag := GetWindowLong (Hwnd, GWL_USERDATA);
    If (Tag = 1010) Then Begin
      FoundWnd^ := Hwnd;
      Result := False;
    End; { If }
  End; { If }
End; { EnumWndProc_FaxClnt }

{-----------------------------------------------------------------------------}

// HM 24/010/02: Duplicated in x:\entrprse\formtk\oImpDefs.Pas
Function GetReaderText : ANSIString;
Var
  SigFile : TStrings;
  FName   : ShortString;
Begin { GetReaderText }
  Result := '';

  FName := IncludeTrailingBackSlash(SetDrive) + PathMaster + 'reader.txt';
  If FileExists (FName) Then Begin
    // Load File into stringlist
    SigFile := TStringList.Create;
    Try
      SigFile.LoadFromFile(FName);

      Result := SigFile.Text;
    Finally
      SigFile.Destroy;
    End;
  End; { If GotFile }
End; { GetReaderText }

{-----------------------------------------------------------------------------}

// NOTE: Elements of this are duplicated in the Toolkit DLL in DLLPFrm1.Pas
// HM 24/010/02: Duplicated in x:\entrprse\formtk\oImpDefs.Pas
Procedure InitEmailText (Var PrnInfo : TSBSPrintSetupInfo);
Var
  SigFile : TStrings;
  GotFile : Boolean;
  FName   : ShortString;
Begin { InitEmailText }
  // Initialise the message
  //PrnInfo.feEmailMsg := ''; Not necessary as otherewise any auto messages will be lost

  // Check the 'Send Reader' flag
  If PrnInfo.feEmailReader Then
    PrnInfo.feEmailMsg := GetReaderText + PrnInfo.feEmailMsg;

  // Check for logged in user's email signature file
  FName := IncludeTrailingBackSlash(SetDrive) + PathMaster + Trim(Copy(EntryRec^.Login, 1, 8)) + '.txt';
  GotFile := FileExists (FName);

  If (Not GotFile) Then Begin
    // Check for generic Company email signature
    FName := IncludeTrailingBackSlash(SetDrive) + PathMaster + 'company.txt';
    GotFile := FileExists (FName);
  End; { If (Not GotFile) }

  If GotFile Then Begin
    // Load File into stringlist
    SigFile := TStringList.Create;
    Try
      SigFile.LoadFromFile(FName);

      PrnInfo.feEmailMsg := PrnInfo.feEmailMsg + SigFile.Text;

    Finally
      SigFile.Destroy;
    End;
  End; { If GotFile }

  // Check for logged in user's fax signature file
  FName := IncludeTrailingBackSlash(SetDrive) + PathMaster + Trim(Copy(EntryRec^.Login, 1, 8)) + '.tx2';
  GotFile := FileExists (FName);

  If (Not GotFile) Then Begin
    // Check for generic Company fax signature
    FName := IncludeTrailingBackSlash(SetDrive) + PathMaster + 'company.tx2';
    GotFile := FileExists (FName);
  End; { If (Not GotFile) }

  If GotFile Then Begin
    // Load File into stringlist
    SigFile := TStringList.Create;
    Try
      SigFile.LoadFromFile(FName);

      PrnInfo.feFaxMsg := PrnInfo.feFaxMsg + SigFile.Text;
    Finally
      SigFile.Destroy;
    End;
  End; { If GotFile }
End; { InitEmailText }

{-----------------------------------------------------------------------------}

// HM 24/010/02: Duplicated in x:\entrprse\formtk\oImpDefs.Pas
Procedure SetEcommsFromCust(Const LCust    :  CustRec;
                            Var   PrnInfo  :  TSBSPrintSetupInfo;
                                  ExLocal  :  TdMTExLocalPtr;
                                  Update   :  Boolean);
Var
  LStat     :  Integer;
  KeyS      :  Str255;
  LRecAddr  :  LongInt;
  TmpCust   :  CustRec;
  CoverMode :  Byte;

Begin

  With PrnInfo,LCust do
  Begin
    feFaxTo:=Trim(Company);

    If (Trim(Contact)<>'') then
      feFaxTo:=feFaxTo+', '+Trim(Contact);

    // MH 04/02/2014 v7.0.9 ABSEXCH-15013: Modified setting of email addresses for Ledger Multi-Contacts changes
    //feEmailTo:=feFaxTo;
    feFaxToNo:=Fax;

    // MH 25/07/07: Added Trim because some customer accounts have a load of spaces on the end which
    // breaks Outlook
    //feEmailToAddr:=EmailAddr;
    // MH 04/02/2014 v7.0.9 ABSEXCH-15013: Modified setting of email addresses for Ledger Multi-Contacts changes
    //feEmailToAddr:=Trim(EmailAddr);

    // MH 04/02/2014 v7.0.9 ABSEXCH-15013: Modified setting of email addresses for Ledger Multi-Contacts changes

    //PR: 19/05/2014 ABSEXCH-15327 All names and addresses should now be in feEmailTo
    //PrnInfo.feEmailTo := '';
    PrnInfo.feEmailTo := feFaxTo + ';' + Trim(EmailAddr) + ';';

    feEmailReader:=EmlSndRdr;
    feEmailZip:=Ord(EmlZipAtc);

    If (EmlSndRdr) and (Not Preview) and (Update) then {* Attempt to reset send reader *}
    Begin

      {* See if we can lock the record first *}

      KeyS:=CustCode;

      If (Assigned(ExLocal)) then
      With ExLocal^,LCust do
      Begin
        LStat:=LTry_Lock(B_GetEq,B_SingNWLock+B_MultLock,KeyS,0,CustF,LRecPtr[CustF]);

        If (LStat=0) then {* We have the record so update it *}
        Begin

          LStat:=LGetPos(CustF,LRecAddr);

          EmlSndRdr:=BOff;

          LStat:=LPut_Rec(CustF,0);

          LStat:=UnLockMLock(CustF,LRecAddr);

        end;


      end
      else
      With Cust do
      Begin
        TmpCust:=Cust;
        LStat:=Try_Lock(B_GetEq,B_SingNWLock+B_MultLock,KeyS,0,CustF,RecPtr[CustF]);

        If (LStat=0) then {* We have the record so update it *}
        Begin

          LStat:=GetPos(F[CustF],CustF,LRecAddr);

          EmlSndRdr:=BOff;

          LStat:=Put_Rec(F[CustF],CustF,RecPtr[CustF]^,0);

          LStat:=UnLockMultiSing(F[CustF],CustF,LRecAddr);

          Cust:=TmpCust;
        end;
      end;
    end;

    If (feInvMode) then
      CoverMode:=InvDMode
    else
      CoverMode:=StatDMode;

    If (CoverMode In [1..4]) then
    begin
      {$IFDEF EXSQL}
       if SQLUtils.UsingSQL and Assigned(ExLocal)then
         feCoverSheet:=ExLocal^.LGetMultiFrmDefs(LCust.FDefPageNo).FormDefs.PrimaryForm[43+Ord(CoverMode In [1,3])]
       else
      {$ENDIF}
        feCoverSheet:=pfGetMultiFrmDefs(LCust.FDefPageNo).FormDefs.PrimaryForm[43+Ord(CoverMode In [1,3])];
    end;
  end;

  InitEmailText (PrnInfo);
end;

//------------------------------

// MH 11/10/2013 v7.X MRD2.4.19: Added support for importing an Account Contact Role's details into the print job
Procedure SetEcommsFromCust_WithRole(Const  LCust    : CustRec;
                                      Var   PrnInfo : TSBSPrintSetupInfo;
                                            ExLocal : TdMTExLocalPtr;
                                            Update  : Boolean;
                                      Const RoleId  : Integer);
Var
  // PKR. 31/01/2014. ABSEXCH-14999.
  // Changed to AnsiString to allow for multiple email addresses.
  sContactEmailAddr : AnsiString;
  sContactName, sContactFaxNumber : ShortString;
Begin // SetEcommsFromCust_WithRole
  // Call basic routine to bring in defaults from Customer/Consumer/Supplier records
  SetEcommsFromCust (LCust, PrnInfo, ExLocal, Update);

  // Check for an applicable Account Contact Role to import details from
  If (RoleId <> -1) Then
  Begin
    // Look for the required Account Contact Role
    sContactName := '';
    sContactFaxNumber := '';
    sContactEmailAddr := '';

    If FindAccountContactRole (LCust.CustCode, RoleId, sContactName, sContactFaxNumber, sContactEmailAddr) Then
    Begin
      // Copy the details into PrnInfo overwriting the defaults from SetEcommsFromCust

      // Faxing
      PrnInfo.feFaxTo := Trim(LCust.Company);
      If (Trim(sContactName) <> '') then
        PrnInfo.feFaxTo := PrnInfo.feFaxTo + ', ' + Trim(sContactName);
      PrnInfo.feFaxToNo := sContactFaxNumber;

      // Email
      // MH 28/01/2014 v7.0.9 ABSEXCH-14974: Modified so name and email address are both passed to print dialog thorugh the feEmailToAddr field as a series of name;address; elements
      //PR: 19/05/2014 ABSEXCH-15327 All names and addresses should now be in feEmailTo
      //PrnInfo.feEmailTo := '';
      PrnInfo.feEmailTo := Trim(sContactEmailAddr);
    End; // If FindAccountContactRole (LCust.CustCode, RoleId)
  End; // If (RoleId <> -1)
End; // SetEcommsFromCust_WithRole

//------------------------------

// MH 11/10/2013 v7.X MRD2.4.19: Added support for identifying a contact role for a transaction print job
Procedure SetEcommsFromCust_TransRole(Const LCust     : CustRec;
                                      Var   PrnInfo   : TSBSPrintSetupInfo;
                                            ExLocal   : TdMTExLocalPtr;
                                            Update    : Boolean;
                                      Const RoleTrans : InvRec);
Var
  RoleId : Integer;
Begin // SetEcommsFromCust_TransRole
  // Check for an applicable Account Contact Role
  RoleId := -1;
  If (RoleTrans.InvDocHed In [SQU, PQU]) Then
    RoleId := riSendQuote
  Else If (RoleTrans.InvDocHed In [SOR, POR]) Then
    RoleId := riSendOrders
  Else If (RoleTrans.InvDocHed In [SDN, PDN]) Then
    RoleId := riSendDeliveryNotes
  Else If (RoleTrans.InvDocHed In [SIN, PIN]) Then
    RoleId := riSendInvoices
  Else If (RoleTrans.InvDocHed = SRC) Then
    RoleId := riSendReceipt
  Else If (RoleTrans.InvDocHed = PPY) Then
    RoleId := riSendRemittance
  Else If (RoleTrans.InvDocHed In [SCR, PCR]) Then     // PS - 19-10-2015 - ABSEXCH-15530
    RoleId := riSendCreditNote
  Else If (RoleTrans.InvDocHed = SRI) Then             // PS - 20-10-2015 - ABSEXCH-16501
    RoleId := riSendSaleReceiptWithInvoice
  Else If (RoleTrans.InvDocHed = PPI) Then             // PS - 20-10-2015 - ABSEXCH-16501
    RoleId := riSendPurchasePaymentWithInvoice
  Else If (RoleTrans.InvDocHed In [SJI, PJI]) Then     // PS - 20-10-2015 - ABSEXCH-16500
    RoleId := riSendJournalInvoice
  Else If (RoleTrans.InvDocHed In [SJC, PJC]) Then     // PS - 20-10-2015 - ABSEXCH-16500
    RoleId := riSendJournalCredit
  Else If (RoleTrans.InvDocHed In [SRF, PRF]) Then     // PS - 20-10-2015 - ABSEXCH-16502
    RoleId := riSendCreditWithRefund
  Else If (RoleTrans.InvDocHed In [SRN, PRN]) Then     // PS - 20-10-2015 - ABSEXCH-16503
    RoleId := riSendReturn
  Else If (RoleTrans.InvDocHed In (SalesSplit + PurchSplit + [SRN, PRN])) Then
    RoleId := riGeneralContact;

  // Call the common routine to apply the default behaviour + role details
  SetEcommsFromCust_WithRole (LCust, PrnInfo, ExLocal, Update, RoleId);
End; // SetEcommsFromCust_TransRole

{-----------------------------------------------------------------------------}

procedure TPrintDlg.FormCreate(Sender: TObject);
Var
  OldHWnd : HWnd;
  I       : Integer;
begin
  { Default To Printer tab and resize form }
  PageControl1.ActivePage := tabshPrinter;
  PageControl1Change(Sender);

  { Init local variables }
  OkPressed := False;
  NeedLabel:=False;
  ChkInsertReader := FileExists(IncludeTrailingBackSlash(SetDrive) + PathMaster + 'reader.txt');
  FXLSCheck := False;
  FHTMLCheck := False;

  ShowForm:=PrintShowForm;

  { Check to see if MAPI is available }
  {GotMapi := MAPIAvailable;}

  {FNF.Visible:=ShowForm;
  FNLab.Visible:=FNF.Visible;}

  If (Not ShowForm) Then
  Begin
    { Doing Report - Hide Form details and display as font instead }
    FNBtn.Caption:='&Font';
    FNLab.Caption:='Report Font';

    Label86.Visible:=BOff;
    edtFaxForm.Visible:=BOff;
    btnFaxBrowseForm.visible:=BOff;
    Label813.Visible:=BOff;
    edtEmlForm.Visible:=BOff;
    btnEmlBrowseForm.Visible:=BOff;
  End { If }
  else
  Begin
    FNF.ReadOnly:=Not PChkAllowed_In(349); {Protect form}
    FNF.Enabled:=Not FNF.ReadOnly;

    edtFaxForm.ReadOnly:=FNF.ReadOnly;
    edtemlForm.ReadOnly:=FNF.ReadOnly;
    edtFaxForm.Enabled:=FNF.Enabled;
    edtemlForm.Enabled:=FNF.Enabled;

    FNBtn.Visible:=Not FNF.ReadOnly;
    btnFaxBrowseForm.Visible:=FNBtn.Visible;
    btnEmlBrowseForm.Visible:=FNBtn.Visible;

  end;

  (* HM 01/10/01: Moved to owner-draw Listbox as ListView crashes with AV under Windows XP
  With lvRecips,Columns do {* Set Column widths and captions here *}
  Begin
    Items[0].Width:=22;
    Items[1].Width:=108;
    Items[2].Width:=200;
    Items[1].Caption:='Name';
    Items[2].Caption:='Email address';
  end;
  *)
  With LstRecips.Canvas Do Begin
    Font.Name := LstRecips.Font.Name;
    Font.Size := LstRecips.Font.Size;
    LstRecips.ItemHeight := TextHeight('Wg') + 2; // measure ascenders and descenders
  End; { With Canvas }


  // Create internal font for ReportFont property and load default font
  FReportFont := TFont.Create;
  FReportFont.Assign(Self.Font);

  ThisOrient:=lRpDev.Orientation;

  { load printers }
  With lRpDev Do Begin
    If (Printers.Count > 0) Then Begin
      For I := 0 To Pred(Printers.Count) Do Begin
        Combo_Printers.Items.Add (Printers[I]);
      End; { For }

      If (lRpDev.DeviceIndex <= Pred(Combo_Printers.Items.Count)) Then
        Combo_Printers.ItemIndex := lRpDev.DeviceIndex
      Else
        Combo_Printers.ItemIndex := 0;

      lstFaxPrinter.Items.Assign(Combo_Printers.Items);
      lstFaxPrinter.ItemIndex := Combo_Printers.ItemIndex;

      // *EN552XL Load printers into Excel Printers List
      lstExcelPrinter.Items.Assign(Combo_Printers.Items);
      lstExcelPrinter.ItemIndex := Combo_Printers.ItemIndex;

      // *EN560HTML Load printers into HTML Printers List
      lstHTMLPrinter.Items.Assign(Combo_Printers.Items);
      lstHTMLPrinter.ItemIndex := Combo_Printers.ItemIndex;
    End; { If }
  End; { With }

  DefSuggPrinter:=-1;

  { Default to global flag }
  If PrintToPrinter Then
    ActiveControl:=Radio_Printer
  Else
    ActiveControl:=Radio_Preview;

  If eCommsModule then
  Begin
    tabshFax.TabVisible := PChkAllowed_In(267);
    tabshEmail.TabVisible :=PChkAllowed_In(266);
    //tabshXML.TabVisible :=PChkAllowed_In(266);
  end;

  { If Faxing by Enterprise - check the client is running }
  If eCommsModule And (SyssEDI2^.EDI2Value.FxUseMAPI=0) Then
  Begin
    OldHwnd := 0;
    EnumWindows (@EnumWndProc_FaxClnt, Longint(@OldHwnd));

    If (OldHwnd = 0) or (Not PChkAllowed_In(267)) Then
    Begin
      { Wot No Fax Client - Disable Fax tab }
      tabshFax.TabVisible := False;
    End; { If }
  End; { If }

  // Show Excel Tab for reports but not forms
  tabshExcel.TabVisible := Not ShowForm;

  If (tabshExcel.TabVisible) then
  Begin
    chkExcelOpenXLS.Checked:=PrintOpenExcel;
    chkExcelIncludePageHeaders.Checked:=PrintExcelPages;
    chkExcelIncludeTotals.Checked:=PrintExcelTotals;
  end;

  // Show HTML Tab for reports but not forms
  tabshHTML.TabVisible := Not ShowForm;

  { Setup Mru list link }
  MruFrm.SepBar := Popup_Forms_SepBar2;
  MruFrm.Items[1] := Popup_Forms_1;
  MruFrm.Items[2] := Popup_Forms_2;
  MruFrm.Items[3] := Popup_Forms_3;
  MruFrm.Items[4] := Popup_Forms_4;
  MruFrm.Items[5] := Popup_Forms_5;
  MruFrm.Items[6] := Popup_Forms_6;
  MruFrm.Items[7] := Popup_Forms_7;
  MruFrm.Items[8] := Popup_Forms_8;
  MruFrm.Items[9] := Popup_Forms_9;
  MruFrm.Items[10] := Popup_Forms_10;

  SetHelpContextIDs; // NF: 11/05/06 Fix for incorrect Context IDs

  // PKR. 25/11/2015. ABSEXCH-15333. Email PORs to relevant suppliers.
  SetUseEmailList(true);  // Default to enabled.  This can be changed using the UseEmailList property.
end;

{ == Procedure to set from prninfo record outputs == }

Procedure TPrintDlg.OutPrnInfoDetails;

Var
  {NewItem  : TlistItem;}
  ListObj  : TEmailDetsObjType;
  sStr, sName, sEmail : ANSIString;
  iColPos : Integer;
Begin
  edtFaxToName.Text:=lPrnInfo.feFaxTo;
  edtFaxToNo.Text:=lPrnInfo.feFaxToNo;

  //PR: 19/05/2014 ABSEXCH-15327 All names and addresses should now be in feEmailTo rather than feEmailAddr
  If (lPrnInfo.feEmailTo<>'') then
  Begin
(*
    lstRecips.Items.Clear;

    ListObj := TEmailDetsObjType.Create;
    With ListObj Do Begin
      edType     := 0;
      edName     := lPrnInfo.feEmailTo;
      edAddress  := lPrnInfo.feEmailToAddr;
    End; { With ListObj }
    lstRecips.Items.AddObject ('', ListObj);
(* *)

(* *)
    lstRecips.Items.Clear;

    //
    // Reformat the details to support the differing methods that we can receive the default email details in so we can handle them all in one way, by the end of
    // the reformatting sStr should be in the Ledger Multi-Contacts feEmailToAddr format for processing:-
    //
    //   Default format: feEmailTo = Recipient1 Name and feEmailToAddr = Recipient1 Email Address
    //
    //     feEmailTo      'Mark Higginson'
    //     feEmailToAddr  'Mark.Higginson@AdvancedComputerSoftware.com'
    //
    //   Extended format: feEmailTo = Recipient1 Name and feEmailToAddr = Recipient1 Email Address + an optional series of Name + Email Addresses separated by semi-colons
    //
    //     feEmailTo      'Mark Higginson'
    //     feEmailToAddr  'Mark.Higginson@AdvancedComputerSoftware.com;Paul Rutherford;Paul.Rutherford@AdvancedComputerSoftware.com'
    //
    //   Ledger Multi-Contacts: feEmailTo is not used and feEmailToAddr contains a series of Name + Email address combinations separated by semi-colons
    //
    //     feEmailTo      ''
    //     feEmailToAddr  'Mark Higginson;Mark.Higginson@AdvancedComputerSoftware.com;Paul Rutherford;Paul.Rutherford@AdvancedComputerSoftware.com;'
    //
{    sStr := Trim(lPrnInfo.feEmailTo);
    If (sStr <> '') And (sStr[Length(sStr)] <> ';') Then
      sStr := sStr + ';';}

    //PR: 19/05/2014 ABSEXCH-15327 All names and addresses should now be in feEmailTo
    sStr := sStr + Trim(lPrnInfo.feEmailTo);
    If (sStr <> '') And (sStr[Length(sStr)] <> ';') Then
      sStr := sStr + ';';

    // Run through the Recipient Details adding them into the list, the string should contain a series of <Name>;<EmailAddress>; fields
    iColPos := Pos (';', sStr);
    While (iColPos > 0) Do
    Begin
      // Extract name from recipients string
      sName := Copy (sStr, 1, Pred(iColPos));
      Delete (sStr, 1, iColPos);

      // Look for email address
      iColPos := Pos (';', sStr);
      If (iColPos > 0) Then
      Begin
        sEmail := Copy (sStr, 1, Pred(iColPos));
        Delete (sStr, 1, iColPos);

        // If we have some details then add them into the list
        If (sName <> '') Or (sEmail <> '') Then
        Begin
          ListObj := TEmailDetsObjType.Create;
          With ListObj Do
          Begin
            edType     := 0;
            edName     := sName;
            edAddress  := sEmail;
          End; { With ListObj }
          lstRecips.Items.AddObject ('', ListObj);
        End; // If (sName <> '') Or (sEmail <> '')

        iColPos := Pos (';', sStr);
      End; // If (iColPos > 0)
    End; // While (iColPos > 0)
  End; { If }

  lstEmlCompress.ItemIndex := lPrnInfo.feEmailZip;
  ChkEmlReader.Checked:=lPrnInfo.feEmailReader;


end;

Function TPrintDlg.Current_Page  :  Integer;


Begin


  Result:=pcLivePage(PAgeControl1);

end;


Procedure TPrintDlg.ChangePage(NewPage  :  Integer);


Begin

  If (Current_Page<>NewPage) then
  With PageControl1 do
  If (Pages[NewPage].TabVisible) then
  Begin
    ActivePage:=Pages[NewPage];

    PageControl1Change(PageControl1);
  end; {With..}
end; {Proc..}

Procedure TPrintDlg.WMCustGetRec(Var Message  :  TMessage);



Begin


  With Message do
  Begin

    {If (Debug) then
      DebugForm.Add('Mesage Flg'+IntToStr(WParam));}

    Case WParam of
      175
         :  With PageControl1 do
              ChangePage(FindNextPage(ActivePage,(LParam=0),BOn).PageIndex);
              {ChangePage(GetNewTabIdx(PageControl1,LParam));}

    end;
  end; {With..}
end; {Proc..}


Function TPrintDlg.Execute(    FormName : ShortString;
                           Var PrnInfo  : TSBSPrintSetupInfo) : Boolean;

Var
  {NewItem  : TlistItem;}
  ListObj  : TEmailDetsObjType;
Begin
  If (PrnInfo.DevIdx>-1) and (PrnInfo.DevIdx <= Pred(Combo_Printers.Items.Count)) then
    Combo_Printers.ItemIndex := PrnInfo.DevIdx;

  {If (PrnInfo.DevIdx>-1) and (PrnInfo.DevIdx <= Pred(Combo_Printers.Items.Count)) then
    lstFaxPrinter.ItemIndex := PrnInfo.DevIdx;}
  lstFaxPrinter.ItemIndex := pfFind_DefaultPrinter(SyssEDI2^.EDI2Value.FaxPrnN);

  lPrnInfo := PrnInfo;
  Combo_PrintersClick(Self);        { load lPrnInfo with current printer details }

  If ShowForm Then Begin
    { Form dialog }
    UseForm:=FormName;
    FNF.Text:=UseForm;
  End { If }
  Else
  Begin
    { Report Dialog }

    { Disable Cover Pages }
    SBSBackGroup8.Visible := False;
    lblFaxCover.Visible := False;
    edtFaxCover.Visible := False;
    btnFaxBrowseCover.Visible := False;

    SBSBackGroup6.Visible := False;
    lblEmailCover.Visible := False;
    edtEmlCover.Visible := False;
    btnEmlBrowseCover.Visible := False;
    //tabshXML.TabVisible:=BOff;
  End; { Else }


  If (Not eCommsModule) then {* If module not enabled, then hide extra tabs *}
  Begin
    tabshFax.TabVisible := False;
    tabshEmail.TabVisible := False;
    //tabshXML.TabVisible:=BOff;
  end
  else
  Begin
    // HM 08/03/00: Done in FormCreate with checks on client - this just breaks it!
    //tabshFax.TabVisible := PChkAllowed_In(267);
    tabshEmail.TabVisible :=PChkAllowed_In(266);
    {If (ShowForm) then
      tabshXML.TabVisible :=PChkAllowed_In(266);}


    {* Check feTypes to hide extra tabs on specific modes *}
    With PrnInfo do
    Begin
      If ((feTypes AND 2) =2) then
        tabshFax.TabVisible := FALSE;

      If ((feTypes AND 4) =4) then
        tabshEmail.TabVisible := FALSE;

      {If ((feTypes AND 8) =8) then
        tabshXML.TabVisible := FALSE;}

      If ((feTypes AND 16) = 16) then
        tabshExcel.TabVisible := FALSE;

      If ((feTypes AND 32) = 32) then
        tabshHTML.TabVisible := FALSE;
    end;

    If (PrnInfo.feBatch) then {* Disable To options, as batch controls this *}
    Begin
      lstRecips.Enabled:=BOn;
      btnEmlAdd.Enabled:=BOff;
      btnEmlEdit.Enabled:=BOff;
      btnEmlDelete.Enabled:=BOff;
      Label89.Visible:=BOff;
      edtFaxtoName.Visible:=BOff;
      Label812.Visible:=BOff;
      edtFaxtoNo.Visible:=BOff;

      radFaxPrinter.Enabled:=BOff;
      radFaxPreview.Enabled:=BOff;
      raadEmlPrinter.Enabled:=BOff;
      radEmlPreview.Enabled:=BOff;

    end;
  end;

  // HM 26/06/00: Separated out XML Tab and added EBusModule checking
  If EBusModule Then Begin
    { eBusiness Module available }
    If ShowForm Then Begin
      { Printing Form }
      tabshXML.TabVisible := PChkAllowed_In(266);

      { Check XML not specifically disabled for this form }
      If ((PrnInfo.feTypes AND 8) =8) then
        tabshXML.TabVisible := FALSE;
    End { If ShowForm }
    Else
      { Printing Report }
      tabshXML.TabVisible := False;
  End { If }
  Else
    { No eBusiness Module }
    tabshXML.TabVisible:=BOff;

  { Setup Fax dialog }
  If (SyssEDI2^.EDI2Value.FxUseMAPI=1) Then
  Begin
    If TestedMAPI And (Not GotMAPI) Then
    Begin
      { MAPI not available - disable faxing }
      tabshFax.TabVisible := False;
    End; { If }

    { Priority only available for Enterprise faxing }
    lstFaxPriority.Enabled := False;
  End { If }
  Else Begin
    If (SyssEDI2^.EDI2Value.FxUseMAPI=2) Then Begin
      { 3rd party faxing software }
      lstFaxPrinter.ItemIndex := pfFind_DefaultPrinter(SyssEDI2^.EDI2Value.FaxPrnN);
      lstFaxPrinter.Enabled := False;
    End { If }
    Else Begin
      { non-MAPI faxing - always using Async driver }
      lstFaxPrinter.ItemIndex := pfFind_DefaultPrinter(SyssEDI2^.EDI2Value.FaxPrnN);
      lstFaxPrinter.Enabled := False;
      btnFaxSetupPrinter.Enabled:=BOff;
    End; { Else }
  End; { Else }

  edtFaxForm.Text := UseForm;

  edtFaxCover.Text := SyssForms^.FormDefs.PrimaryForm[44];

  {$B-}
    With prnInfo do
    If (feMiscOptions[10]) and (Cust.FDefPageNo>0) then
      edtFaxCover.Text := pfGetMultiFrmDefs(Cust.FDefPageNo).FormDefs.PrimaryForm[44];
  {$B+}

  If (UserProfile^.UserName='') or (Not UserProfile^.Loaded) then
  Begin
    If (SyssEDI2^.EDI2Value.FxName<>'') then
      edtFaxFromName.Text := SyssEDI2^.EDI2Value.FxName
    else
      edtFaxFromName.Text := Syss.UserName;
  end
  else
    edtFaxFromName.Text := UserProfile^.UserName;


  If (SyssEDI2^.EDI2Value.FxPhone<>'') then
    edtFaxFromNo.Text := SyssEDI2^.EDI2Value.FxPhone
  else
    edtFaxFromNo.Text := Syss.DetailFax;


  lstFaxPriority.ItemIndex := 1;  // Normal

  { Setup Email dialog }
  If SyssEDI2^.EDI2Value.EmUseMAPI And TestedMAPI And (Not GotMAPI) Then
  Begin
    { MAPI not available - disable emailing }
    tabshEmail.TabVisible := False;

    { MAPI not available - XML To File only }
    //tabshXML.TabVisible := False;
    radXMLFile.Checked := True;
    radXMLFile.Enabled := False;
    radXMLEmail.Enabled := False;
    radXMLClick(Self);
  End; { If }

  edtEmlForm.Text := UseForm;
  edtEmlCover.Text := SyssForms^.FormDefs.PrimaryForm[43];

  {$B-}
    With prnInfo do
    If (feMiscOptions[10]) and (Cust.FDefPageNo>0) then
      edtEmlCover.Text := pfGetMultiFrmDefs(Cust.FDefPageNo).FormDefs.PrimaryForm[43];
  {$B+}


  If (UserProfile^.UserName='') or (Not UserProfile^.Loaded) then
    edtEmlSendName.Text := SyssEDI2^.EDI2Value.EmName
  else
    edtEmlSendName.Text := UserProfile^.UserName;

  If (UserProfile^.EmailAddr='') or (Not UserProfile^.Loaded) then
    edtEmlSendAddr.Text := SyssEDI2^.EDI2Value.EmAddress
  else
    edtEmlSendAddr.Text := UserProfile^.EmailAddr;

  lstEmlPriority.ItemIndex := SyssEDI2^.EDI2Value.EmPriority;

  edXMLPath.Text := LastXMLDir; {*en431 XML}
  chkXLMHTML.Checked := LastHTMLFlag;

  edtExcelPath.Text := LastExcelPath;
  edtHTMLPath.Text := LastHTMLPath;

  OutPrnInfoDetails;

  memEmlMessage.Text := PrnInfo.feEmailMsg;
  memFaxMessage.Text := PrnInfo.feFaxMsg;

  { Display test mode button }
  Radio_Test.Visible:=ShowForm;
  bgrpTest.Visible:=ShowForm;

  // HM 24/05/00: Added defaulting of tab
  If (PrnInfo.fePrintMethod = 0) And tabshPrinter.TabVisible Then
    { Printer }
    PageControl1.ActivePage := tabshPrinter
  Else
    If (PrnInfo.fePrintMethod = 1) And tabshFax.TabVisible Then
      { Fax }
      PageControl1.ActivePage := tabshFax
    Else
      If (PrnInfo.fePrintMethod = 2) And tabshEmail.TabVisible Then
        { Email }
        PageControl1.ActivePage := tabshEmail
      Else
        If (PrnInfo.fePrintMethod = 3) And tabshXML.TabVisible Then
          { XML }
          PageControl1.ActivePage := tabshXML
        Else
          If (PrnInfo.fePrintMethod = 5) And tabshExcel.TabVisible Then
            { Excel }
            PageControl1.ActivePage := tabshExcel
          Else
            If (PrnInfo.fePrintMethod = 7) And tabshHTML.TabVisible Then
              { Excel }
              PageControl1.ActivePage := tabshHTML
            Else
              If tabshPrinter.TabVisible Then
                { Who Knows - Default to printer }
                PageControl1.ActivePage := tabshPrinter;
  PageControl1Change(Self);

  { Display Form }
  ShowModal;
  PrnInfo := lPrnInfo;

  Result := OkPressed;

  If Result Then
  Begin
    { Copy details from form back into record }
    Form2PrnInfo(PrnInfo);
  End { If }
  Else Begin
    // Cancelled - tidy up recipient list
    While (lstRecips.Items.Count > 0) Do Begin
      ListObj := TEmailDetsObjType(lstRecips.Items.Objects[0]);
      lstRecips.Items.Delete(0);
      ListObj.Free;
    End; { If }
  End; { Else }
End;

//-------------------------------------------------------------------------

// Updates the TSBSPrintSetupInfo containing the printing info from the form
procedure TPrintDlg.Form2PrnInfo (Var PrnInfo  : TSBSPrintSetupInfo; Const DestroyObjects : Boolean = True);
Var
  I       : SmallInt;
Begin // Form2PrnInfo
  With PrnInfo Do
  Begin
    // Set the print method - needed for customisation
    If (PageControl1.ActivePage = tabshPrinter) Then
      PrnInfo.fePrintMethod := 0
    Else If (PageControl1.ActivePage = tabshFax) Then
      PrnInfo.fePrintMethod := 1
    Else If (PageControl1.ActivePage = tabshEmail) Then
      PrnInfo.fePrintMethod := 2
    Else If (PageControl1.ActivePage = tabshXML) Then
      PrnInfo.fePrintMethod := 3
    Else If (PageControl1.ActivePage = tabshExcel) Then
      PrnInfo.fePrintMethod := 5
    Else If (PageControl1.ActivePage = tabshHTML) Then
      PrnInfo.fePrintMethod := 7;

    Case fePrintMethod Of
      0 : Begin { Printer }
            feCoverSheet := '';
            Preview := Radio_Preview.Checked;
            NoCopies := StrToIntDef(Trim(CopiesF.Text), 1);

            UseForm := FNF.Text;
          End;
      1 : Begin { Fax }
            feCoverSheet := edtFaxCover.Text;
            Preview := radFaxPreview.Checked;
            NoCopies := 1;

            UseForm := edtFaxForm.Text;

            If (SyssEDI2^.EDI2Value.FxUseMAPI<>1) Then
            Begin
              { Set printer to Async Pro Fax Driver }
              DevIdx := pfFind_DefaultPrinter(SyssEDI2^.EDI2Value.FaxPrnN);
              FormNo := 0;
              FormName := '';
              BinNo := 0;
              BinName := '';
            End; { If }
          End;
      2 : Begin { Email }
            feCoverSheet := edtEmlCover.Text;
            Preview := radEmlPreview.Checked;
            NoCopies := 1;

            UseForm := edtEmlForm.Text;

            { Set printer to Adobe PDF Writer }
            DevIdx := pfFind_DefaultPrinter(SyssEDI2^.EDI2Value.EmailPrnN);
            FormNo := 0;
            FormName := '';
            BinNo := 0;
            BinName := '';
          End;
      3 : Begin { XML } {*en431 XML}
            If radXMLFile.Checked Then
              feXMLType := 0   { XML Method: 0=File }
            Else
              feXMLType := 1;  { XML Method: 1=Email }

            feXMLCreateHTML := chkXLMHTML.Checked;      { XML: Also create HTML file }
            LastHTMLFlag := chkXLMHTML.Checked;

            // MH 13/11/07: Must have a trailing '\' otherwise the last part of the path is lost
            feXMLFileDir := IncludeTrailingPathDelimiter(edXMLPath.Text);
            LastXMLDir := feXMLFileDir; {*en431 XML}
          End;
      5 : Begin { Excel }
            // Update print info structure
			// MH 07/01/2016 2016-R1 ABSEXCH-10720: Removed the Print to File/Preview options
            Preview := False;

            feXMLFileDir := edtExcelPath.Text;
            LastExcelPath := edtExcelPath.Text;

            // Set the new option fields
            feMiscOptions[1] := chkExcelOpenXLS.Checked;                 // 1 = Open XLS automatically
            feMiscOptions[2] := chkExcelIncludePageHeaders.Checked;  // 2 = Show Page Headers/Footers
            feMiscOptions[3] := chkExcelIncludeTotals.Checked;       // 3 = Show Totals

            PrintOpenExcel:=chkExcelOpenXLS.Checked;
            PrintExcelPages:=chkExcelIncludePageHeaders.Checked;
            PrintExcelTotals:=chkExcelIncludeTotals.Checked;
          End;
      7 : Begin // HTML
            // Update print info structure
            Preview := radHTMLPreview.Checked;

            feXMLFileDir := edtHTMLPath.Text;
            LastHTMLPath := edtHTMLPath.Text;

            // Set the new option fields
            feMiscOptions[1] := chkHTMLOpenHTML.Checked;                 // 1 = Open XLS automatically
            PrintOpenHTML:=chkHTMLOpenHTML.Checked;
          End; // HTML
    End; { Case }

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
    feEmailAttach   := edtEmlAttach.Text;    { Not available in this version }
    feEmailPriority := lstEmlPriority.ItemIndex;
    feEmailReader   := chkEmlReader.Checked;
    feEmailZIP      := lstEmlCompress.ItemIndex;
    feEmailAtType   := SyssEDI2^.EDI2Value.emAttchMode;

    feEmailTo       := '';
    feEmailCc       := '';
    feEmailBcc      := '';    { Not available in this version, but coded anyway! }

    If (lstRecips.Items.Count > 0) Then
    Begin
      If (fePrintMethod In [2, 3]) Then
      Begin
        // Update email dets with recipients
        For I := 0 To (lstRecips.Items.Count - 1) Do
        Begin
          TEmailDetsObjType(lstRecips.Items.Objects[I]).UpdateEmStrings(feEmailTo, feEmailCc, feEmailBcc);
        End; // For I
      End; // If (fePrintMethod In [2, 3])

      If DestroyObjects Then ClearRecipList;
    End; // If (lstRecips.Items.Count > 0)
  End; { With }
End; // Form2PrnInfo

//------------------------------

Procedure TPrintDlg.ClearRecipList;
Var
  ListObj : TEmailDetsObjType;
Begin // ClearRecipList
  // Destroy the list objects
  While (lstRecips.Items.Count > 0) Do
  Begin
    ListObj := TEmailDetsObjType(lstRecips.Items.Objects[0]);
    ListObj.Free;
    lstRecips.Items.Delete(0);
  End; // While (lstRecips.Items.Count > 0)
End; // ClearRecipList

//-------------------------------------------------------------------------
// PKR. 25/11/2015. ABSEXCH-15333. Email PORs to relevant suppliers.
/// Enables or disables all the controls relevant to using the email list.
procedure TPrintDlg.SetUseEmailList(useState : Boolean = true);
begin
  // Set the flag
  FUseEmailList := useState;

  // Enable or disable the UI controls accordingly
  lstRecips.Enabled := useState;
  btnEmlAdd.Enabled := useState;
  btnEmlEdit.Enabled := useState;
  btnEmlDelete.Enabled := useState;
  Label820.Enabled := useState;
  // For some unknown reason, THeaderControl doesn't actually grey-out when it
  // is disabled.  Simple solutions to this issue welcome. (not owner-draw!)
  // Tried setting the controls' font colour to clGrayText (colour of dimmed text)
  // but it doesn't work.
  // Setting the font colour to the same as that of a greyed-out control doesn't work
  //  either, because disabling a control doesn't actually change its Font.Color property.
  // PKR. 16/12/2015.  This is all academic now.  The Email tab is no longer used for Stock Re-order
  hdrRecips.Enabled := useState;
end;

//-------------------------------------------------------------------------
// PKR. 11/02/2016. ABSEXCH-17279. Re-introduce print=to=screen option for "Create PORs & print to printer" option.
procedure TPrintDlg.SetAllowPrintPreview(bAllow : Boolean = true);
begin
  FAllowPrintPreview := bAllow;

  SBSBackGroup4.Visible := FAllowPrintPreview;
  Radio_Printer.Visible := FAllowPrintPreview;
  Radio_Preview.Visible := FAllowPrintPreview;
  // If the Printer radio button is hidden, make sure it is selected.
  if not Radio_Printer.Visible then
  begin
    Radio_Printer.Checked := true;
    // Move the Test Mode group box over to fill the space
    bgrpTest.Left := 3;
  end
  else
  begin
    // The Test Mode group box goes in its normal position
    bgrpTest.Left := 162;
  end;
  // Move the Test Mode radio button into its group box, wherever it is.
  Radio_Test.Left := bgrpTest.Left + 9;
end;
//-------------------------------------------------------------------------

procedure TPrintDlg.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  { Set global default flag }
  PrintToPrinter:= Radio_Printer.Checked;
end;


procedure TPrintDlg.FormDestroy(Sender: TObject);
begin
  FreeAndNIL(FReportFont);
end;

procedure TPrintDlg.Button_OKClick(Sender: TObject);
Var
  Device, Driver, Port : Array [0..79] Of Char;
  DeviceMode           : THandle;
begin
  lPrnInfo.fePrintMethod := 0;

  If (Combo_Printers.ItemIndex >= 0)  Then
  Begin
    { Set printer }
    {If (ShowForm) then
      lRpDev.DeviceIndex := Combo_Printers.ItemIndex;}
    {With Printer Do
    Begin
      PrinterIndex := Combo_Printers.ItemIndex;
      GetPrinter (Device, Driver, Port, DeviceMode);
      SetPrinter (Device, Driver, Port, DeviceMode);
    End; { With }

    OkPressed := True;
    ModalResult:=mrOk;
  End; { If }
end;

procedure TPrintDlg.Button_CancelClick(Sender: TObject);
begin
  OkPressed := False;
  ModalResult:=mrCancel;
end;

// HM 30/07/03: Consolidated three Setup Printer buttons into one event handler
//procedure TPrintDlg.btnSetupPrinterClick(Sender: TObject);
//Var
//  oPrnInfo : TSBSPrintSetupInfo;
//  oOrient  : TOrientation;
//begin
//  { save current print setup }
//  oPrnInfo := lRpDev.SBSSetupInfo;
//  oOrient  := lRpDev.Orientation;
//
//  { Load PrnInfo with printer setup info }
//  lRpDev.SetPrnSetup(lPrnInfo);
//  lRpDev.Orientation := ThisOrient;
//  If lRpDev.PrinterSetUpDialog Then Begin
//    lPrnInfo := lRpDev.SBSSetupInfo;
//    Combo_Printers.ItemIndex := lRpDev.DeviceIndex;
//    //lstFaxPrinter.ItemIndex := lRpDev.DeviceIndex;
//
//    ThisOrient:=lRpDev.Orientation;
//  End; { If }
//
//  { restore previous print setup }
//  lRpDev.SetPrnSetup(oPrnInfo);
//  lRpDev.Orientation := oOrient;
//end;

{ Copies form printer setup info into the printer setup info }
procedure TPrintDlg.FormPrnInfo(fmInfo : FormInfoType;Var PrnInfo : TSBSPrintSetupInfo);
Var
  oPrnInfo  : TSBSPrintSetupInfo;
  oOrient   : TOrientation;
Begin
  { save current print setup }
  oPrnInfo := lRpDev.SBSSetupInfo;
  oOrient  := lRpDev.Orientation;

  { Load lPrnInfo with printer setup info }
  lRpDev.DeviceIndex := fmInfo.PrinterNo;
  With PrnInfo Do Begin
    DevIdx   := fmInfo.PrinterNo;
    FormNo   := fmInfo.PaperNo;
    //FormName := lRpDev.WalkList(lRpDev.Papers, FormNo);
    FormName := lRpDev.WalkList(RpDevStrPapers, FormNo);
    BinNo    := fmInfo.BinNo;
    //BinName  := lRpDev.WalkList(lRpDev.Bins, BinNo);
    BinName  := lRpDev.WalkList(RpDevStrBins, BinNo);
  End; { With }

  { restore previous print setup }
  lRpDev.SetPrnSetup(oPrnInfo);
  lRpDev.Orientation := oOrient;
End;

//-------------------------------------------------------------------------

procedure TPrintDlg.SelectFormOrFont(Sender: TObject);
Begin
  If ShowForm Then
    // Printing Form - Select Form
    BrowseForForm (FNF, 0, 1)
  Else
    // Printing Report - Select Font
    BrowseForFont(Sender);
End;

//-------------------------------------------------------------------------

Procedure TPrintDlg.BrowseForForm(Const TheEdit      : Text8Pt;
                                  Const Mode, MruIdx : Byte);
Var
  FileInfo  :  SplitFNameType;
  SFile     :  ShortString;
  CurDirStr :  String;
  fmInfo    :  FormInfoType;
begin
  CurDirStr:=GetCurrentDir;

  OpenDialog.FileName  := TheEdit.Text;
  OpenDialog.InitialDir := SystemInfo.ExDataPath+FormsPath;

  Radio_Preview.Enabled:=BOff;
  Radio_Printer.Enabled:=BOff;
  Radio_Test.Enabled:=BOff;

  If (OpenDialog.Execute) then
  Begin
    SetCurrentDir(CurDirStr);

    SFile:=Trim(PathtoShort(OpenDialog.FileName));

    If (SFile<>'') then
    Begin
      FileInfo:=SplitFileName(SFile);

      If (FileInfo.Extension='') then
        FileInfo.Extension:=DefExtension;

      If (ValidFormDef(FileInfo,True)) then
      Begin
        If (Mode = 0) Then
          UseForm:=FileInfo.Name;
        TheEdit.Text:=FileInfo.Name;

        { reload printer info from form def }
        fmInfo:=GetFormInfo(FileInfo.Name);
        FormPrnInfo(fmInfo, lPrnInfo);

        If (lPrnInfo.DevIdx=-1) then
          lPrnInfo.DevIdx:=DefSuggPrinter;

        If (lPrnInfo.DevIdx>-1) and (lPrnInfo.DevIdx <= Pred(Combo_Printers.Items.Count)) then
          Combo_Printers.ItemIndex := lPrnInfo.DevIdx;

        MruFrm.AddMruEntry (MruIdx, FileInfo.Name);
      end;
    end; {If Not empty file name }
  end
  else
    SetCurrentDir(CurDirStr);

  Radio_Preview.Enabled:=BOn;
  Radio_Printer.Enabled:=BOn;
  Radio_Test.Enabled:=BOn;
End;

//-------------------------------------------------------------------------

// HM 31/07/03: Changed to use ReportFont property which maps onto a common
// font get/set system supporting Printer and Excel tabs and split out from
// the BrowseForForm function
Procedure TPrintDlg.BrowseForFont(Sender: TObject);
Begin
  FontDialog1.Font.Assign(FReportFont);
  If FontDialog1.Execute Then
    // Set ReportFont using property so the property set method updates the
    // form correctly
    ReportFont := FontDialog1.Font;
end;

//-------------------------------------------------------------------------

procedure TPrintDlg.FNFChange(Sender: TObject);

Var
  GotLabel  :  Boolean;
  fmInfo    :  FormInfoType;

begin
  GotLabel:=True;

  If (FNF.Text<>'') and (ShowForm) and (ActiveControl<>Button_Cancel) then
  Begin
    fmInfo:=GetFormInfo(FNF.Text);

    CopiesF.Text:=Form_Int(fmInfo.FormHeader.fhCopies,0);

    If (NeedLabel) then
    Begin
      GotLabel:=(fmInfo.FormHeader.fhFormtype=ftLabel);

      If (Not GotLabel) then
      Begin
        ShowMessage('A label form is required.'+#13+#13+'Please choose again.');
        SetFocus;
      end;
    end;

  end;

  Button_Ok.Enabled:=((FNF.Text<>'') and (GotLabel));

end;


procedure TPrintDlg.CopiesFChange(Sender: TObject);
begin
  With CopiesF do
  If (ActiveControl<>Button_Cancel) then
  Begin
    If (Not (StrToIntDef(Trim(Text), 0) In [1..99])) then
    Begin
      ShowMessage('The number of copies must be between 1-99');
      Text:='1';
      SetFocus;
    end;
  end;
end;

procedure TPrintDlg.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  BTSupU2.GlobFormKeyDown(Sender,Key,Shift,ActiveControl,Handle);
end;

procedure TPrintDlg.FormKeyPress(Sender: TObject; var Key: Char);
begin
  BTSupU2.GlobFormKeyPress(Sender,Key,ActiveControl,Handle);
end;

procedure TPrintDlg.edtFaxToNameDblClick(Sender: TObject);
Var
  FoundCode  :  Str20;

  FoundOk,
  AltMod     :  Boolean;


begin
  Inherited;

  If (Sender is Text8pt) then
  With (Sender as Text8pt) do
  Begin
    AltMod:=Modified;

    FoundCode:=Strip('B',[#32],Text);

    If (ActiveControl<>BtnFaxCancel)   then
    Begin
      With Cust do
        If (CheckKey(Trim(Company),Text,Length(Trim(Company)),BOff)) then
          FoundCode:=Cust.CustCode;

      FoundOk:=(GetCust(Self,FoundCode,FoundCode,BOn,99));


      If (FoundOk) then
      Begin
        SetEcommsFromCust(Cust,lprnInfo,Nil,BOff);

        OutPrnInfoDetails;
      end
      else
      Begin

        SetFocus;
      end; {If not found..}
    end;

  end; {with..}
end;


procedure TPrintDlg.edtFaxToNameExit(Sender: TObject);
begin
  If (Sender is Text8pt) then
  With (Sender as Text8pt) do
  Begin
    If (ViaSBtn) then
      edtFaxToNameDblClick(Sender);

  end;
end;




procedure TPrintDlg.Combo_PrintersClick(Sender: TObject);
Var
  oPrnInfo : TSBSPrintSetupInfo;
  oOrient  : TOrientation;
begin
  { save current print setup }
  oPrnInfo := lRpDev.SBSSetupInfo;
  oOrient  := lRpDev.Orientation;

  lRpDev.SetPrnSetup(lPrnInfo);

  { Load PrnInfo with printer setup info }
  lRpDev.DeviceIndex := Combo_Printers.ItemIndex;
  //lPrnInfo := lRpDev.SBSSetupInfo;           {*en431 XML}
  {ThisOrient := lRpDev.Orientation;}
  lPrnInfo := TSBSPrintSetupInfo(lRpDev.SBSSetupInfo2(lPrnInfo));  {*en431 XML}

  { restore previous print setup }
  lRpDev.SetPrnSetup(oPrnInfo);
  lRpDev.Orientation := oOrient;
end;

procedure TPrintDlg.PageControl1Changing(Sender: TObject;
  var AllowChange: Boolean);
begin
  If (AllowChange) then
  Begin
    Release_PageHandle(Sender);
    LockWindowUpDate(Handle);
  end;
end;


procedure TPrintDlg.PageControl1Change(Sender: TObject);
Var
  TmpIdx : LongInt;
begin
  { reformat screen }
  If (PageControl1.ActivePage = tabshPrinter) Then Begin
    { Print To Printer/Preview }
    Caption := 'Print Setup - Printer';

    Self.ClientHeight := {223} 195; {*en431 XML}
    Self.ClientWidth := 407;
    PageControl1.Height := 186;
    PageControl1.Width := 397;

    { Setup printer details for selected printer }
    SelectPrinter(Combo_Printers);
  End { If }
  Else If (PageControl1.ActivePage = tabshFax) Then Begin
    { Print To Fax }
    Caption := 'Print Setup - Fax';

    Self.ClientHeight := {369} 368; {*en431 XML}
    Self.ClientWidth := 407;
    PageControl1.Height := 359;
    PageControl1.Width := 397;

    { Setup printer details for selected printer }
    SelectPrinter(lstFaxPrinter);

    If (Not TestedMAPI) And (SyssEDI2^.EDI2Value.FxUseMAPI=1) Then
      CheckForMAPI;
  End { If }
  Else If (PageControl1.ActivePage = tabshEmail) Then Begin
    { Print To Email }
    Caption := 'Print Setup - Email';

    Self.ClientHeight := 407; {380;}  {*en431 XML}
    Self.ClientWidth := 489;
    PageControl1.Height := 398; {371;}
    PageControl1.Width := 479;

    { Move Email Details to Email page } {*en431 XML}
    If (grpEmailDets.Parent <> tabshEmail) Then Begin
      TmpIdx := lstEmlPriority.ItemIndex;
      grpEmailDets.Parent := tabshEmail;
      grpEmailDets.Top := 77;
      grpEmailDets.Left := 3;
      grpEmailDets.Visible := True;
      grpEmailDets.TabOrder := btnEmlOK.TabOrder;
      lstEmlPriority.ItemIndex := TmpIdx;
    End; { If }

    If (Not TestedMAPI) And (SyssEDI2^.EDI2Value.EmUseMAPI) Then
      CheckForMAPI;
  End { If }
  Else If (PageControl1.ActivePage = tabshXML) Then
  Begin
    { XML }  {*en431 XML}
    Caption := 'Print Setup - XML';

    { Resize window for XML Details }
    Self.ClientHeight := 376; {349;}
    Self.ClientWidth := 489;
    PageControl1.Height := 367;{340;}
    PageControl1.Width := 479;

    // HM 26/06/00: Corrected check to use Email Mapi flag not Fax Mapi flag!
    //If (Not TestedMAPI) And (SyssEDI2^.EDI2Value.FxUseMAPI=1) Then
    If (Not TestedMAPI) And SyssEDI2^.EDI2Value.EmUseMAPI Then
      CheckForMAPI;

    { Move Email Details to XML page }
    If (grpEmailDets.Parent <> tabshXML) Then Begin
      TmpIdx := lstEmlPriority.ItemIndex;
      grpEmailDets.Parent := tabshXML;
      grpEmailDets.Top := grpXMLFile.Top;
      grpEmailDets.Left := grpXMLFile.Left;
      grpEmailDets.TabOrder := btnXMLOK.TabOrder;
      lstEmlPriority.ItemIndex := TmpIdx;

      radXMLClick(Sender);
    End // If (PageControl1.ActivePage = tabshXML)
  End // If (PageControl1.ActivePage = tabshXML)
  Else If (PageControl1.ActivePage = tabshExcel) Then
  Begin
    // Print To Excel
    Caption := 'Print Setup - Excel';

    Self.ClientHeight := 280;
    Self.ClientWidth := 489;
    PageControl1.Height := 271;
    PageControl1.Width := 479;

    { Setup printer details for selected printer }
    SelectPrinter(lstExcelPrinter);

    If (Not FXLSCheck) Then
    Begin
      // Check for Excel availability
      FXLSCheck := True;

      // Lookup .XLS in HKEY_CLASSES_ROOT
      With TRegistry.Create Do
        Try
          Access := KEY_READ;
          RootKey := HKEY_CLASSES_ROOT;

          // Only enable the auto-open if there is an app to open XLS files
          chkExcelOpenXLS.Enabled := KeyExists ('.XLS');
        Finally
          Free;
        End;
    End; // If (Not FXLSCheck)

    If (Trim(LastExcelPath) = '') Then
    Begin
      // Get My Documents path from registry and use as default path
      With TRegistry.Create Do
        Try
          Access := KEY_READ;
          RootKey := HKEY_CURRENT_USER;

          // Look for default path
          If KeyExists('Software\Microsoft\Windows\CurrentVersion\Explorer\Shell Folders') Then
            If OpenKey('Software\Microsoft\Windows\CurrentVersion\Explorer\Shell Folders', False) Then
              If ValueExists('Personal') Then
                LastExcelPath := ReadString('Personal');
        Finally
          Free;
        End;

      If (Trim(LastExcelPath) <> '') And DirectoryExists (LastExcelPath) Then
        edtExcelPath.Text := IncludeTrailingPathDelimiter(LastExcelPath);
    End; // If (Trim(LastExcelPath) = '')
  End // If (PageControl1.ActivePage = tabshExcel)
  Else If (PageControl1.ActivePage = tabshHTML) Then
  Begin
    // Print To Excel
    Caption := 'Print Setup - HTML';

    Self.ClientHeight := 238; //280;
    Self.ClientWidth := 489;
    PageControl1.Height := 229; //271;
    PageControl1.Width := 479;

    { Setup printer details for selected printer }
    SelectPrinter(lstHTMLPrinter);

    If (Not FHTMLCheck) Then
    Begin
      // Check for HTML Viewer availability
      FHTMLCheck := True;

      // Lookup .XLS in HKEY_CLASSES_ROOT
      With TRegistry.Create Do
        Try
          Access := KEY_READ;
          RootKey := HKEY_CLASSES_ROOT;

          // Only enable the auto-open if there is an app to open XLS files
          chkExcelOpenXLS.Enabled := KeyExists ('.HTML');
        Finally
          Free;
        End;
    End; // If (Not FHTMLCheck)

    If (Trim(LastHTMLPath) = '') Then
    Begin
      // Get My Documents path from registry and use as default path
      With TRegistry.Create Do
        Try
          Access := KEY_READ;
          RootKey := HKEY_CURRENT_USER;

          // Look for default path
          If KeyExists('Software\Microsoft\Windows\CurrentVersion\Explorer\Shell Folders') Then
            If OpenKey('Software\Microsoft\Windows\CurrentVersion\Explorer\Shell Folders', False) Then
              If ValueExists('Personal') Then
                LastHTMLPath := ReadString('Personal');
        Finally
          Free;
        End;

      If (Trim(LastHTMLPath) <> '') And DirectoryExists (LastHTMLPath) Then
        edtHTMLPath.Text := IncludeTrailingPathDelimiter(LastHTMLPath);
    End; // If (Trim(LastHTMLPath) = '')
  End; // If (PageControl1.ActivePage = tabshHTML)

  LockWindowUpDate(0);
end;

procedure TPrintDlg.btnFaxBrowseFormClick(Sender: TObject);
begin
  BrowseForForm (edtFaxForm, 0, 1);
end;

procedure TPrintDlg.btnFaxBrowseCoverClick(Sender: TObject);
begin
  BrowseForForm (edtFaxCover, 1, 2);
end;

procedure TPrintDlg.btnEmlBrowseFormClick(Sender: TObject);
begin
  BrowseForForm (edtEmlForm, 0, 1);
end;

procedure TPrintDlg.btnEmlBrowseCoverClick(Sender: TObject);
begin
  BrowseForForm (edtEmlCover, 1, 2);
end;

procedure TPrintDlg.btnFaxOKClick(Sender: TObject);
Const
  NumSet = [' ', '0'..'9'];
Var
  TmpStr : ShortString;
  I : Byte;
  OK : Boolean;
  fmInfo, fmInfo2 : FormInfoType;
begin
  btnFaxOK.SetFocus;

  lPrnInfo.fePrintMethod := 1;

  { Check a printer is specified }
  If (lstFaxPrinter.ItemIndex >= 0) Then Begin
    { Check form is set }
    If ((Trim(edtFaxForm.Text) <> '') or (Not PrintShowForm)) Then Begin
      { Check To details are set }
      If (Trim(edtFaxToName.Text) <> '') And (Trim(edtFaxToNo.Text) <> '') Then Begin
        { Check number consists of valid characters }
        OK := True;
        TmpStr := edtFaxToNo.Text;
        For I := 1 To Length(TmpStr) Do Begin
          If Not (TmpStr[I] In NumSet) Then Begin
            { Invalid character }
            MessageDlg ('The To Number is invalid', mtWarning, [mbOk], 0);
            OK := False;
            Break;
          End; { If }
        End; { For }

        If OK And btnFaxBrowseCover.Visible And (Trim(edtFaxCover.Text) <> '') Then Begin
          { Check fax cover page is same type as main form }
          OK := (GetFormType (Trim(edtFaxCover.Text)) = GetFormType (Trim(edtFaxForm.Text)));
          If (Not OK) Then Begin
            MessageDlg ('The Cover Form must be the same type as the Main Form', mtWarning, [mbOk], 0);
            If btnFaxBrowseCover.CanFocus Then btnFaxBrowseCover.SetFocus;
          End; { If }
        End; { If }

        If OK Then Begin
          { AOK - Send fax }
          OkPressed := True;
          ModalResult:=mrOk;
        End; { If }
      End { If }
      Else Begin
        { Either To Name or To Number is invalid }
        MessageDlg ('The To Name and Number must be specified', mtWarning, [mbOk], 0);
      End; { If }
    End { If }
    Else Begin
      { Form must be set }
      MessageDlg ('A form must be selected', mtWarning, [mbOk], 0);
    End; { If }
  End { If }
  Else Begin
    { Printer not selected }
    MessageDlg ('A printer must be selected', mtWarning, [mbOk], 0);
  End; { Else }
end;

procedure TPrintDlg.edtFaxFormChange(Sender: TObject);
Var
  GotLabel  : Boolean;
  fmInfo    : FormInfoType;
begin
  GotLabel:=True;

  If (Trim(edtFaxForm.Text) <> '') and ShowForm and (ActiveControl <> btnFaxCancel) Then Begin
    fmInfo:=GetFormInfo(edtFaxForm.Text);

    If (NeedLabel) then
    Begin
      GotLabel:=(fmInfo.FormHeader.fhFormtype=ftLabel);

      If (Not GotLabel) then
      Begin
        ShowMessage('A label form is required.'+#13+#13+'Please choose again.');
        SetFocus;
      end;
    end;
  End; { If }

  btnFaxOK.Enabled:=((edtFaxForm.Text<>'') and (GotLabel));
end;

procedure TPrintDlg.edtFaxCoverChange(Sender: TObject);
Var
  fmInfo    : FormInfoType;
begin
  If (Trim(edtFaxCover.Text) <> '') And (ActiveControl <> btnFaxCancel) Then Begin
    fmInfo := GetFormInfo(edtFaxCover.Text);

    If (fmInfo.FormHeader.fhFormtype = ftLabel) Then Begin
      edtFaxCover.Text := '';
      ShowMessage('The Fax Cover Sheet cannot be a label.'+#13+#13+'Please choose again.');
      SetFocus;
    End; { If }
  End; { If }
end;

procedure TPrintDlg.btnEmlOKClick(Sender: TObject);
Var
  OK : Boolean;
begin
  lPrnInfo.fePrintMethod := 2;

  { Set printer to Adobe Acrobat PDF Writer }
  lPrnInfo.DevIdx := pfFind_DefaultPrinter(SyssEDI2^.EDI2Value.EmailPrnN);

  { Validation ??? }
  // PKR. 25/11/2015. ABSEXCH-15333. Email PORs to relevant suppliers.
  // If UseEmailList is set to false, the email list can be empty, but we still
  //  might want to continue with the other validation.
  If (lstRecips.Items.Count > 0) or (not UseEmailList) Then
  Begin
    If ((Trim(edtEmlForm.Text) <> '') or (Not PrintShowForm)) Then
    Begin
      If btnEmlBrowseForm.Visible And (Trim(edtEmlCover.Text) <> '') Then
      Begin
        { Check fax cover page is same type as main form }
        OK := (GetFormType (Trim(edtEmlCover.Text)) = GetFormType (Trim(edtEmlForm.Text)));
        If (Not OK) Then
        Begin
          MessageDlg ('The Cover Form must be the same type as the Main Form', mtWarning, [mbOk], 0);
          If btnEmlBrowseCover.CanFocus Then btnEmlBrowseCover.SetFocus;
        End; { If }
      End { If }
      Else
        OK := True;

      If OK Then
      Begin
        { AOK - Send Email }
        OkPressed := True;
        ModalResult:=mrOk;
      End; { If }
    End { If }
    Else
    Begin
      { Form must be set }
      MessageDlg ('A form must be selected', mtWarning, [mbOk], 0);
      If btnEmlBrowseForm.CanFocus Then btnEmlBrowseForm.SetFocus;
    End; { If }
  End { If }
  Else
  Begin
    { no recipients specified }
    MessageDlg ('At least one recipient must be specified', mtWarning, [mbOk], 0);
    If btnEmlAdd.CanFocus Then btnEmlAdd.SetFocus;
  End; { Else }
end;

procedure TPrintDlg.CheckForMAPI;
Begin { CheckForMAPI }
  { Check to see if MAPI is available }
  GotMapi := MAPIAvailable(VAOInfo.vaoMode <> smVAO);
  TestedMAPI := True;

  If (Not GotMAPI) Then Begin
    ShowMessage ('Fax and Email services through MAPI are not available');

    If (SyssEDI2^.EDI2Value.FxUseMAPI=1) Then Begin
      { No MAPI Faxing available }
      btnFaxOK.Enabled := False;
    End; { If }

    If SyssEDI2^.EDI2Value.EmUseMAPI Then Begin
      { No MAPI Emailing available }
      btnEmlOK.Enabled := False;

      { No email - XML is limited to file only }
      radXMLFile.Checked := True;
      radXMLFile.Enabled := False;
      radXMLEmail.Enabled := False;
    End; { If }
  End; { If }
End; { CheckForMAPI }

procedure TPrintDlg.lvRecipsEditing(Sender: TObject; Item: TListItem;
  var AllowEdit: Boolean);
begin
  AllowEdit := False;
end;


{*EN570*}
Function TPrintDlg.ExecuteCustom(WID,EID : Integer)  :  Boolean;

{$IFDEF CU}

  Var
    n           : Byte;
    CustomEvent : TCustomEvent;
    ExLocal     : TdExLocal;
    PrnInfo     : TSBSPrintSetupInfo;

    Procedure ReLoadFromString(Const AddrType : Byte; TheString : ANSIString);
    Var
      ListObj  : TEmailDetsObjType;
      sName : ShortString;
      iPos  : SmallInt;
    Begin // LoadFromString
      iPos := Pos(';', TheString);
      While (iPos > 0) Do
      Begin
        // Extract Name
        sName := Copy(TheString, 1, iPos-1);
        System.Delete (TheString, 1, iPos);

        iPos := Pos(';', TheString);
        If (iPos > 0) Then
        Begin
          // Extract Address and add into the list
          ListObj := TEmailDetsObjType.Create;
          ListObj.edType := AddrType;
          ListObj.edName := sName;
          ListObj.edAddress := Copy(TheString, 1, iPos-1);
          lstRecips.Items.AddObject('', ListObj);

          System.Delete (TheString, 1, iPos);

          iPos := Pos(';', TheString);
        End; // If (iPos > 0)
      End; // While (iPos > 0) Do
    End; // LoadFromString

  Begin
    Result:=BOn;

    CustomEvent:=TCustomEvent.Create(EnterpriseBase+WID,EID);

    Try
      With CustomEvent do
      Begin
        If (GotEvent) then
        Begin
          // Create dummy ExLocal for the Build event
          ExLocal.Create;
          Try
            BuildEvent(ExLocal);

            // Build an up to date TSBSPrintSetupInfo
            PrnInfo := lPrnInfo;
            Form2PrnInfo(PrnInfo, False);  // Don't destroy objects

            // update the Paperless object within the Event Data
            Case ((WId * 1000) + EId) Of
              90003001 : Begin // Add
                           TPaperless(EntSysObj.Paperless).oEmail.PrintInfo := PrnInfo;
                         End; // Add
            End; // Case ((WId * 1000) + EId)

            Execute;

            // Set PrnInfo from returned customisation structure
            Case ((WId * 1000) + EId) Of
              90003001 : Begin // Add
                           Result := EntSysObj.BoResult;
                           If Result Then
                           Begin
                             ClearRecipList;
                             ReLoadFromString(0, TPaperless(EntSysObj.Paperless).oEmail.PrintInfo.feEmailTo);
                             ReLoadFromString(1, TPaperless(EntSysObj.Paperless).oEmail.PrintInfo.feEmailCC);
                             ReLoadFromString(2, TPaperless(EntSysObj.Paperless).oEmail.PrintInfo.feEmailBCC);
                           End; // If Result
                         End; // Add
            End; // Case ((WId * 1000) + EId)
          Finally
            ExLocal.Destroy;
          end;
        end;
      end; {With..}
    finally
      CustomEvent.Free;
    end;

{$ELSE}
  begin
    Result:=BOff;
{$ENDIF}

  end;



procedure TPrintDlg.btnEmlAddClick(Sender: TObject);
Var
  ListObj : TEmailDetsObjType;
begin
  {$IFDEF CU}{* EN570 *}
  {* Initialise PrnInfo *}
  If (EnableCustBtns(MiscBase+3,01)) then {* Is the paperless hook enabled *}
  Begin
    If (ExecuteCustom(MiscBase+3,01)) then {* It executed and we got a result rather than cancel *}
    Begin
      {* Set lists here *}
    end;
  end
  else
  {$ENDIF}
  Begin
    ListObj := TEmailDetsObjType.Create;
    Try
      If EditEmailDets (ListObj, Self) Then Begin
        { Details specified - add to list }
        lstRecips.Items.AddObject ('', ListObj);
      End { If }
      Else
        { Add cancelled - destroy object }
        ListObj.Destroy;
    Except
      ListObj.Destroy;
    End;
  end;
end;

procedure TPrintDlg.btnEmlEditClick(Sender: TObject);
Var
  ListObj : TEmailDetsObjType;
begin
  If (lstRecips.ItemIndex >= 0) Then Begin
    { Get object from list }
    ListObj := TEmailDetsObjType(lstRecips.Items.Objects[lstRecips.ItemIndex]);

    EditEmailDets (ListObj, Self);

    lstRecips.Invalidate;
  End; { If }
end;

procedure TPrintDlg.btnEmlDeleteClick(Sender: TObject);
Var
  ListObj : TEmailDetsObjType;
begin
  If (lstRecips.ItemIndex >= 0) Then Begin
    { Delete from list list }
    ListObj := TEmailDetsObjType(lstRecips.Items.Objects[lstRecips.ItemIndex]);
    ListObj.Free;

    lstRecips.Items.Delete (lstRecips.ItemIndex);
  End; { If }
end;


procedure TPrintDlg.Popup_FormsPopup(Sender: TObject);
begin
  With Popup_Forms Do Begin
    { Reformat menu depending on where it popped up }
    Tag := 0;
    If (PopupComponent = FNF) Then Begin
      { Printer - main form }
      If ShowForm Then
        Tag := 1   // Forms
      Else
        Tag := 3;  // Fonts
      Popup_Forms_Browse.OnClick := SelectFormOrFont;
    End { If }
    Else If (PopupComponent = edtFaxForm) Then Begin
      { fax - main form }
      Tag := 1;
      Popup_Forms_Browse.OnClick := btnFaxBrowseFormClick;
    End { If }
    Else If (PopupComponent = edtFaxCover) Then Begin
      { fax - cover sheet }
      Tag := 2;
      Popup_Forms_Browse.OnClick := btnFaxBrowseCoverClick;
    End { If }
    Else If (PopupComponent = edtEmlForm) Then Begin
      { email - main form }
      Tag := 1;
      Popup_Forms_Browse.OnClick := btnEmlBrowseFormClick;
    End { If }
    Else If (PopupComponent = edtEmlCover) Then Begin
      { email - cover sheet }
      Tag := 2;
      Popup_Forms_Browse.OnClick := btnEmlBrowseCoverClick;
    End { If }
    Else If (PopupComponent = edtExcelFont) Or (PopupComponent = edtHTMLFont) Then
    Begin
      // Excel (3) / HTML (13) Report Font
      Popup_Forms_Browse.Tag := 3 + (10 * Ord(PopupComponent = edtHTMLFont));
      Popup_Forms_Browse.OnClick := BrowseForFont;
    End // If (PopupComponent = edtExcelFont) Or (PopupComponent = edtHTMLFont)
    Else If (PopupComponent = edtExcelPath) Or (PopupComponent = edtHTMLPath) Then
    Begin
      // Excel (4) / HTML (14) Report Path
      Popup_Forms_Browse.Tag := 4 + (10 * Ord(PopupComponent = edtHTMLPath));
      Popup_Forms_Browse.OnClick := btnSetPathClick;
    End; // If (PopupComponent = edtExcelPath) Or (PopupComponent = edtHTMLPath)

    { Hide clear option if not a cover sheet }
    Popup_Forms_Clear.Visible := (Tag = 2);
    Popup_Forms_SepBar1.Visible := Popup_Forms_Clear.Visible;

    { Add previously selected options }
    MruFrm.BuildCacheList (Tag);
  End; { With }
end;

//-------------------------------------------------------------------------

procedure TPrintDlg.Popup_Forms_ClearClick(Sender: TObject);
begin
  With Popup_Forms Do
    If PopupComponent Is Text8Pt Then
      (PopupComponent As Text8Pt).Text := '';
end;

//-------------------------------------------------------------------------

procedure TPrintDlg.Popup_Forms_CacheClick(Sender: TObject);
begin
  // Check this is being called from a menu item and that the popup menu is on an edit box
  If (Sender Is TMenuItem) And (Popup_Forms.PopupComponent Is Text8Pt) Then
    // Copy the caption from the menu item into the edit box
    (Popup_Forms.PopupComponent As Text8Pt).Text := (Sender As TMenuItem).Caption;
end;

//-------------------------------------------------------------------------

{*en431 XML}
procedure TPrintDlg.btnXMLOKClick(Sender: TObject);
begin {*en431 XML}
  lPrnInfo.fePrintMethod := 3;

  If radXMLFile.Checked Then
  Begin
    { File - Validate directory }
    If (Trim(edXMLPath.Text) <> '') And DirectoryExists (edXMLPath.Text) Then
    Begin
      OkPressed := True;
      ModalResult:=mrOk;
    End { If }
    Else
    Begin
      { Blank or invalid directory }
      MessageDlg ('A valid directory must be specified to save the XML file in', mtWarning, [mbOk], 0);
      If btnXMLSetDir.CanFocus Then
        btnXMLSetDir.SetFocus;
    End; { Else }
  End { If }
  Else
  Begin
    { Email - check got recipients, etc... }
    // PKR. 25/11/2015. ABSEXCH-15333. Email PORs to relevant suppliers.
    // If UseEmailList is set to false, the email list can be empty.
    If (lstRecips.Items.Count > 0) or (not UseEmailList) Then
    Begin
      OkPressed := True;
      ModalResult:=mrOk;
    End { If }
    Else
    Begin
      { no recipients specified }
      MessageDlg ('At least one recipient must be specified', mtWarning, [mbOk], 0);
      If btnEmlAdd.CanFocus Then
        btnEmlAdd.SetFocus;
    End; { Else }
  End; { If grpEmailDets.Visible }
end;

procedure TPrintDlg.radXMLClick(Sender: TObject);
begin {*en431 XML}
  grpXMLFile.Visible := radXMLFile.Checked;
  grpEmailDets.Visible := Not grpXMLFile.Visible;
end;

procedure TPrintDlg.btnXMLSetDirClick(Sender: TObject);
Var
  OrigDir, DirPath  :  String;
begin {*en431 XML}
  { Save current directory }
  OrigDir := GetCurrentDir;

  (* HM 14/09/00: Modified to use Ebus directory selection dialog
  DirPath := edXMLPath.Text;

  If SelectDirectory (DirPath, [sdAllowCreate, sdPerformCreate, sdPrompt], edXMLPath.HelpContext) then
    edXMLPath.Text := DirPath;
  *)

  With TFrmDirBrowse.Create(Self) Do
    Try
      // default directory on dialog to currently selected path
      lbDirectory.Directory := edXMLPath.Text;

      If (ShowModal = mrOk) Then Begin
        edXMLPath.Text := lbDirectory.Directory;
      End; { If (ShowModal = mrOk) }
    Finally
      Free;
    End;

  { Restore original current directory }
  SetCurrentDir(OrigDir);
end;

procedure TPrintDlg.Label87Click(Sender: TObject);
begin
  ShowMessage ('Current Directory: ' + GetCurrentDir);
end;

procedure TPrintDlg.btnAttachListClick(Sender: TObject);
Var
  frmEmailAttachs : TfrmEmailAttachs;
  CurDir          : String;
begin
  CurDir := GetCurrentDir;

  frmEmailAttachs := TfrmEmailAttachs.Create(Self);
  Try
    With frmEmailAttachs Do Begin
      BuildAttachList(edtEmlAttach.Text);

      ShowModal;

      If OK Then Begin
        edtEmlAttach.Text := GetAttachList;
      End; { If }
    End; { With frmEmailAttachs }
  Finally
    frmEmailAttachs.Free;
  End;

  SetCurrentDir (CurDir);
end;

//-------------------------------------------------------------------------

procedure TPrintDlg.SelectPrinter(Sender: TObject);
Var
  oPrnInfo : TSBSPrintSetupInfo;
  oOrient  : TOrientation;
begin
  { save current print setup }
  oPrnInfo := lRpDev.SBSSetupInfo;
  oOrient  := lRpDev.Orientation;

  lRpDev.SetPrnSetup(lPrnInfo);

  // Load PrnInfo with printer setup info using Sender to identify the source
  If (Sender = Combo_Printers) Then
    // Printer
    lRpDev.DeviceIndex := Combo_Printers.ItemIndex
  Else If (Sender = lstFaxPrinter) Then
    // Fax
    lRpDev.DeviceIndex := lstFaxPrinter.ItemIndex
  Else If (Sender = lstExcelPrinter) Then
    // Excel
    lRpDev.DeviceIndex := lstExcelPrinter.ItemIndex
  Else If (Sender = lstHTMLPrinter) Then
    // Excel
    lRpDev.DeviceIndex := lstHTMLPrinter.ItemIndex
  Else
    Raise Exception.Create ('Error in TPrintDlg.SelectPrinter - "Unhandled Sender" - Please notify your Technical Support');

  lPrnInfo := lRpDev.SBSSetupInfo2(lPrnInfo);  {*en431 XML}

  { restore previous print setup }
  lRpDev.SetPrnSetup(oPrnInfo);
  lRpDev.Orientation := oOrient;
end;

//-------------------------------------------------------------------------

procedure TPrintDlg.SetupPrinter(Sender: TObject);
Var
  oPrnInfo : TSBSPrintSetupInfo;
  oOrient  : TOrientation;
begin
  { save current print setup }
  oPrnInfo := lRpDev.SBSSetupInfo;
  oOrient  := lRpDev.Orientation;

  { Load PrnInfo with printer setup info }
  lRpDev.SetPrnSetup(lPrnInfo);
  lRpDev.Orientation := ThisOrient;
  If lRpDev.PrinterSetUpDialog Then Begin
    // Extract changes from local RpDev object
    lPrnInfo := lRpDev.SBSSetupInfo;

    // Update form with changes using Sender to identify what to change
    If (Sender = btnSetupPrinter) Then
      // Printer
      Combo_Printers.ItemIndex := lRpDev.DeviceIndex
    Else If (Sender = btnFaxSetupPrinter) Then
      // Fax
      lstFaxPrinter.ItemIndex := lRpDev.DeviceIndex
    Else If (Sender = btnExcelSetupPrinter) Then
      // Excel
      lstExcelPrinter.ItemIndex := lRpDev.DeviceIndex
    Else If (Sender = btnHTMLSetupPrinter) Then
      // HTML
      lstHTMLPrinter.ItemIndex := lRpDev.DeviceIndex
    Else
      Raise Exception.Create ('Error in TPrintDlg.SetupPrinter - "Unhandled Sender" - Please notify your Technical Support');

    ThisOrient:=lRpDev.Orientation;
  End; { If }

  { restore previous print setup }
  lRpDev.SetPrnSetup(oPrnInfo);
  lRpDev.Orientation := oOrient;
end;

//-------------------------------------------------------------------------

procedure TPrintDlg.chkEmlReaderClick(Sender: TObject);
begin
  If Self.Visible And chkEmlReader.Checked And ChkInsertReader Then Begin
    If (MessageDlg ('Do you want to insert the standard ''Sending Reader'' text into the message', mtConfirmation, [mbYes, mbNo], 0) = mrYes) Then Begin
      memEmlMessage.Text := GetReaderText + memEmlMessage.Text;
    End; { If }

    ChkInsertReader := False;
  End; { If chkEmlReader.Checked And (Not ChkInsertReader) }
end;

//-------------------------------------------------------------------------

procedure TPrintDlg.btnBigEditClick(Sender: TObject);
begin
  // ??
  With TfrmEmailDetails.Create(Self) Do
    Try
      // Size and position dialog
      Height := Self.Height;
      Left := Self.Left + 20;
      Top := Self.Top + 20;

      // Copy across fields
      edtSubject.Text := edtEmlSubject.Text;
      memMessage.Text := memEmlMessage.Text;

      If (ShowModal = mrOk) Then Begin
        // Update dialog with changes
        edtEmlSubject.Text := edtSubject.Text;
        memEmlMessage.Text := memMessage.Text;
      End; { If (ShowModal = mrOk) }
    Finally
      Free;
    End;
end;

procedure TPrintDlg.Label819DblClick(Sender: TObject);
Var
  ListObj : TEmailDetsObjType;
begin
  ListObj := TEmailDetsObjType.Create;
  With ListObj Do Begin
    edType    := 0;
    edName    := edtEmlSendName.Text;
    edAddress := edtEmlSendAddr.Text;
  End; { With ListObj }
  lstRecips.Items.AddObject ('', ListObj);
end;

procedure TPrintDlg.lstRecipsMeasureItem(Control: TWinControl;
  Index: Integer; var Height: Integer);
begin
  Height := lstRecips.ItemHeight;
end;

procedure TPrintDlg.lstRecipsDrawItem(Control: TWinControl; Index: Integer;
  Rect: TRect; State: TOwnerDrawState);
Var
  oRecip  : TEmailDetsObjType;
  sTxt    : ANSIString;
  lRect   : TRect;
begin
  oRecip := TEmailDetsObjType(lstRecips.Items.Objects[Index]);

  With lstRecips.Canvas, oRecip Do Begin
    // To/CC/BCC
    With hdrRecips.Sections[0] Do Begin
      // Clear out background
      FillRect(Rect);

      // Paint in the text for this column
      sTxt := ToStr;
      lRect := Classes.Rect(Left, Rect.Top, Right, Rect.Bottom);
      DrawTextEx (Handle,                       // handle of device context
                  PCHAR(sTxt),                  // address of string to draw
                  Length(sTxt),                 // length of string to draw
                  lRect,                        // address of rectangle coordinates
                  DT_Left Or DT_MODIFYSTRING Or DT_END_ELLIPSIS,   // formatting options
                  NIL);	                        // address of structure for more options
    End; { With hdrRecips.Sections[0] }

    // Name
    With hdrRecips.Sections[1] Do Begin
      // Clear out text that made it into this section
      lRect := Classes.Rect(Left, Rect.Top, Right, Rect.Bottom);
      FillRect(lRect);

      // Paint in the text for this column
      sTxt := edName;
      DrawTextEx (Handle,                       // handle of device context
                  PCHAR(sTxt),                  // address of string to draw
                  Length(sTxt),                 // length of string to draw
                  lRect,                        // address of rectangle coordinates
                  DT_Left Or DT_MODIFYSTRING Or DT_END_ELLIPSIS,   // formatting options
                  NIL);	                        // address of structure for more options
    End; { With hdrRecips.Sections[0] }

    // Address
    With hdrRecips.Sections[2] Do Begin
      // Clear out text that made it into this section
      lRect := Classes.Rect(Left, Rect.Top, Right, Rect.Bottom);
      FillRect(lRect);

      // Paint in the text for this column
      sTxt := edAddress;
      DrawTextEx (Handle,                       // handle of device context
                  PCHAR(sTxt),                  // address of string to draw
                  Length(sTxt),                 // length of string to draw
                  lRect,                        // address of rectangle coordinates
                  DT_Left Or DT_MODIFYSTRING Or DT_END_ELLIPSIS,   // formatting options
                  NIL);	                        // address of structure for more options
    End; { With hdrRecips.Sections[0] }
  End; { With lstRecips.Canvas, oRecip  }
end;

procedure TPrintDlg.hdrRecipsSectionResize(HeaderControl: THeaderControl;
  Section: THeaderSection);
begin
  lstRecips.Invalidate;
end;

//-------------------------------------------------------------------------

procedure TPrintDlg.SetFont(const Value: TFont);
begin
  FReportFont.Assign(Value);

  If (Not ShowForm) Then
    // Update Font field on Printer Tab if doing report
    FNF.Text := Value.Name + ' ' + IntToStr(Value.Size) + 'pt';

  If tabshExcel.TabVisible Then
    // Update Font field on Excel Tab if visible
    edtExcelFont.Text := Value.Name + ' ' + IntToStr(Value.Size) + 'pt';

  If tabshHTML.TabVisible Then
    // Update Font field on Excel Tab if visible
    edtHTMLFont.Text := Value.Name + ' ' + IntToStr(Value.Size) + 'pt';
end;

//-------------------------------------------------------------------------

procedure TPrintDlg.btnSetPathClick(Sender: TObject);
Type
  DlgModeType = (dmExcelPath, dmHTMLPath);
Var
  OrigDir, DirPath  :  String;
  DlgMode : DlgModeType;
begin
  // Save current directory
  OrigDir := GetCurrentDir;
  Try
    // Determine the mode to use
    If (Sender is TMenuItem) Then
    Begin
      If ((Sender As TMenuItem).Tag > 10) Then
      Begin
        DlgMode := dmHTMLPath;
      End // If ((Sender As TMenuItem).Tag > 10)
      Else
      Begin
        DlgMode := dmExcelPath;
      End; // Else
    End // If (Sender is TMenuItem)
    Else If (Sender = btnExcelSetPath) Or (Sender = edtExcelPath) Then
    Begin
      DlgMode := dmExcelPath;
    End // If (Sender = btnExcelSetPath) Or (Sender = edtExcelPath)
    Else If (Sender = btnHTMLSetPath) Or (Sender = edtHTMLPath) Then
    Begin
      DlgMode := dmHTMLPath;
    End; // If (Sender = btnHTMLSetPath)

    // Configure the dialog for the approriate details
    Case DlgMode Of
      dmExcelPath : Begin // Excel
                      SaveDialog1.DefaultExt := 'XLSX';
                      SaveDialog1.Filter := 'Excel Files|*.XLSX';
                      SaveDialog1.InitialDir := ExtractFilePath(edtExcelPath.Text);
                      SaveDialog1.FileName := ExtractFileName(edtExcelPath.Text);
                    End; // Excel
      dmHTMLPath  : Begin // HTML
                      SaveDialog1.DefaultExt := 'HTML';
                      SaveDialog1.Filter := 'HTML Files|*.HTML';
                      SaveDialog1.InitialDir := ExtractFilePath(edtHTMLPath.Text);
                      SaveDialog1.FileName := ExtractFileName(edtHTMLPath.Text);
                    End; // HTML
    Else
      Raise Exception.Create ('btnSetPathClick: Unhandled Mode - contact your technical support');
    End; // Case }

    If SaveDialog1.Execute Then
    Begin
      Case DlgMode Of
        dmExcelPath : edtExcelPath.Text := SaveDialog1.FileName;
        dmHTMLPath  : edtHTMLPath.Text := SaveDialog1.FileName;
      End; // Case DlgMode
    End; // If SaveDialog1.Execute

  //    // default dialog to currently selected path
  //    InitialDir := ExtractFilePath(edtExcelPath.Text);
  //    FileName := ExtractFileName(edtExcelPath.Text);
  //
  //    If Execute Then
  //      edtExcelPath.Text := FileName;
  Finally
    // Restore original current directory
    SetCurrentDir(OrigDir);
  End; // Try..Finally
end;

//-------------------------------------------------------------------------

procedure TPrintDlg.btnExcelOKClick(Sender: TObject);
Var
  XLDir, XLName, FullPath : ShortString;
begin
  lPrnInfo.fePrintMethod := 5;    // Print to Excel

  // Check a printer is selected
  OK := (lstExcelPrinter.ItemIndex >= 0);

  If OK Then
  Begin
    // Check filename is valid - first check for blank
    XLDir  := UpperCase(ExtractFilePath(edtExcelPath.Text));
    If (Trim(XLDir) = '') Then
      // Default to Company DAta dir
      XLDir := IncludeTrailingPathDelimiter(SetDrive);
    XLName := UpperCase(ExtractFileName(edtExcelPath.Text));

    // Check they are both set
    OK := (Trim(XLDir) <> '') And (Trim(XLName) <> '');

    If OK Then
    Begin
      // Check the name is valid - must be in format x.XLS
      OK := (Pos('.XLSX', XLName) = (Length(XLName) - 4)) And (Length(XLName) > 5);

      If OK Then
      begin
        // Got filename in format x.XLS - check directory is valid
        Try
          OK := ForceDirectories(XLDir);
        Except
          On E:Exception Do
            OK := False;
        End;

        If (Not OK) Then
        Begin
          If edtExcelPath.CanFocus Then edtExcelPath.SetFocus;
          MessageDlg ('The file path is invalid', mtError, [mbOk], 0);
        End; // If (Not OK)
      End // If (Pos('.XLS', XLName) = (Length(XLName) - 3)
      Else Begin
        If edtExcelPath.CanFocus Then edtExcelPath.SetFocus;
        MessageDlg ('The filename specified for the report is not a supported format, the filename should be specified in the format x.XLS', mtError, [mbOk], 0);
      End; // Else
    End // If OK
    Else Begin
      If edtExcelPath.CanFocus Then edtExcelPath.SetFocus;
      MessageDlg ('The filename specified for the report is invalid', mtError, [mbOk], 0);
    End; // Else
  End // If OK
  Else Begin
    If edtExcelPath.CanFocus Then edtExcelPath.SetFocus;
    MessageDlg ('The filename specified for the report is invalid', mtError, [mbOk], 0);
  End; // Else

  If OK Then
  Begin
    FullPath := IncludeTrailingPathDelimiter(XLDir) + XLName;

    If FileExists(FullPath) Then
    Begin
      // Check to see if the file is in use
      If FileIsOpen (FullPath) Then
      Begin
        // File in use - get user to confirm whether to
        Application.MessageBox('The specified XLS file already exists and is being used by another application.'#13#13 +
                               'To continue you must either close the file or change the filename that you want ' +
                               'to print to.', 'Error: File In Use');

        OK := False;
      End // If FileIsOpen (FullPath)
    End; // If FileExists(FullPath)
  End; // If OK

  If OK Then
  Begin
    // AOK - finish dialog
    OkPressed := True;
    ModalResult:=mrOk;
  End; // If (lstExcelPrinter.ItemIndex >= 0)
end;

//-------------------------------------------------------------------------

procedure TPrintDlg.btnHTMLOKClick(Sender: TObject);
Var
  HTMLDir, HTMLName, FullPath : ShortString;
begin
  lPrnInfo.fePrintMethod := 7;    // Print to Excel

  // Check a printer is selected
  OK := (lstHTMLPrinter.ItemIndex >= 0);

  If OK Then
  Begin
    // Check filename is valid - first check for blank
    HTMLDir  := UpperCase(ExtractFilePath(edtHTMLPath.Text));
    If (Trim(HTMLDir) = '') Then
      // Default to Company DAta dir
      HTMLDir := IncludeTrailingPathDelimiter(SetDrive);
    HTMLName := UpperCase(ExtractFileName(edtHTMLPath.Text));

    // Check they are both set
    OK := (Trim(HTMLDir) <> '') And (Trim(HTMLName) <> '');

    If OK Then
    Begin
      // Check the name is valid - must be in format x.HTML
      OK := (Pos('.HTML', HTMLName) = (Length(HTMLName) - 4)) And (Length(HTMLName) > 4);

      If OK Then
      begin
        // Got filename in format x.HTML - check directory is valid
        Try
          OK := ForceDirectories(HTMLDir);
        Except
          On E:Exception Do
            OK := False;
        End;

        If (Not OK) Then
        Begin
          If edtHTMLPath.CanFocus Then edtHTMLPath.SetFocus;
          MessageDlg ('The file path is invalid', mtError, [mbOk], 0);
        End; // If (Not OK)
      End // If OK
      Else Begin
        If edtHTMLPath.CanFocus Then edtHTMLPath.SetFocus;
        MessageDlg ('The filename specified for the report is not a supported format, the filename should be specified in the format x.HTML', mtError, [mbOk], 0);
      End; // Else
    End // If OK
    Else Begin
      If edtHTMLPath.CanFocus Then edtHTMLPath.SetFocus;
      MessageDlg ('The filename specified for the report is invalid', mtError, [mbOk], 0);
    End; // Else
  End // If OK
  Else Begin
    If edtHTMLPath.CanFocus Then edtHTMLPath.SetFocus;
    MessageDlg ('The filename specified for the report is invalid', mtError, [mbOk], 0);
  End; // Else

  If OK Then
  Begin
    FullPath := IncludeTrailingPathDelimiter(HTMLDir) + HTMLName;

    If FileExists(FullPath) Then
    Begin
      // Check to see if the file is in use
      If FileIsOpen (FullPath) Then
      Begin
        // File in use - get user to confirm whether to
        Application.MessageBox('The specified HTML file already exists and is being used by another application.'#13#13 +
                               'To continue you must either close the file or change the filename that you want ' +
                               'to print to.', 'Error: File In Use');

        OK := False;
      End // If FileIsOpen (FullPath)
    End; // If FileExists(FullPath)
  End; // If OK

  If OK Then
  Begin
    // AOK - finish dialog
    OkPressed := True;
    ModalResult:=mrOk;
  End; // If OK
end;

// NF: 11/05/06 Fix for incorrect Context IDs
procedure TPrintDlg.SetHelpContextIDs;
begin
  Radio_Printer.HelpContext := 299;
  lstEmlPriority.HelpContext := 1725;
  CopiesF.HelpContext := 1749;
end;

//-------------------------------------------------------------------------

Initialization
//ShowMessage('TSBSPrintSetupInfo: ' + IntToStr(SizeOf(TSBSPrintSetupInfo)));

  PrintToPrinter := True;
  PrintToQueue:=False;

  PrintOpenExcel:=False;
  PrintExcelPages:=False;
  PrintExcelTotals:=True;


  GotMAPI := False;
  TestedMAPI := False;

  MruFrm := TFormsMRU.Create;

  LastXMLDir := PathToShort (ExtractFilePath(Application.ExeName));          {*en431 XML}
  LastHtmlFlag := False;

  LastExcelPath := '';

  LastHTMLPath := '';
  PrintOpenHTML := False;

  // Create duplicate RpDev object for the printer dialog
  lRpDev := TDuplicateRpDev.Create('ENTPRINT');
Finalization
  MruFrm.Destroy;
  FreeAndNil(lRpDev);
end.
