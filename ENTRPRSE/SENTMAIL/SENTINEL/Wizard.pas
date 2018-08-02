unit Wizard;

{ prutherford440 09:40 30/10/2001: Disabled Byte Alignment in Delphi 6.0 }
{$ALIGN 1}  { Variable Alignment Disabled }


interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ExtCtrls, ComCtrls, TEditVal, ElVar, ElObjs, RwOpenF, Grids,
  Enterprise01_TLB, Buttons, Spin, ImgList, ShellCtrls, RepTreeIF;

const
//Notebook pages
  pgDescription   = 0;
  pgType          = 1;
  pgPriority      = 2;
  pgPushPull      = 3;
  pgEvent         = 4;
  pgDatafile      = 5;
  pgConditions    = 6;
  pgFrequency     = 7;
  pgTransmission  = 8;
  pgEmailAdd      = 9;
  pgEmailMsg      = 10;
  pgSMSNos        = 11;
  pgSMSMsg        = 12;
  pgReport        = 13;
  pgReportParams  = 14;
  pgCSVFTP        = 15;
  pgDay           = 16;
  pgTime          = 17;
  pgExpiry        = 18;
  pgActive        = 19;
  pgRepEmailAdd   = 20;
  pgRepEmailMsg   = 21;
  pgRepFaxAdd     = 22;
  pgRepFaxOpts    = 23;
  pgCSVFolder     = 24;
  pgNotify        = 25;
  pgRemote        = 26;

  IDWiz = 1;

  bmpMain         = 8;
  bmpRecipient    = 6;
  bmpEmail        = 3;
  bmpFinish       = 11;
  bmpTime         = 1;
  bmpPhone2       = 4;
 //bmpTime2        = 6;
  bmpCalender     = 0;
  bmpLogic        = 2;
  bmpReport       = 7;
  bmpType         = 9;
  bmpPriority     = 5;
  bmpRepOpts      = 10;
  bmpDataFile     = 12;
  bmpFax          = 13;
  bmpEvent        = 15;

  FileExcludeSet = [9, 13, 15, 16, 28..32];

 CSVNames : Array[0..4] of string[9] = ('CSV', 'DBF', 'HTML', 'Excel','PDF');
 CSVExts  : Array[0..4] of string[5] = ('.csv', '.dbf', '.htm', '.xlsx', '.pdf');

type
  TfrmElWizard = class(TForm)
    Panel1: TPanel;
    Panel2: TPanel;
    btnNext: TButton;
    btnPrev: TButton;
    btnCancel: TButton;
    Notebook1: TNotebook;
    Label1: TLabel;
    Label2: TLabel;
    rbTimer: TRadioButton;
    rbEvent: TRadioButton;
    Label3: TLabel;
    Label4: TLabel;
    chkEmail: TCheckBox;
    chkSMS: TCheckBox;
    chkCSV: TCheckBox;
    Label5: TLabel;
    Label6: TLabel;
    btnSMSAdd: TButton;
    Label7: TLabel;
    Label10: TLabel;
    Label11: TLabel;
    memSMSMsg: TMemo;
    btnSMSInsertDB: TButton;
    Label12: TLabel;
    Label13: TLabel;
    btnEmailInsertDb: TButton;
    Label14: TLabel;
    Label15: TLabel;
    btnEmailAdd: TButton;
    Label18: TLabel;
    Label19: TLabel;
    Label20: TLabel;
    cbDatafile: TComboBox;
    Label21: TLabel;
    Label25: TLabel;
    Label26: TLabel;
    Label27: TLabel;
    rbMinsBetween: TRadioButton;
    Label28: TLabel;
    dtBetweenStart: TDateTimePicker;
    dtBetweenEnd: TDateTimePicker;
    Label29: TLabel;
    dtSpecific: TDateTimePicker;
    rbSpecific: TRadioButton;
    Label30: TLabel;
    Label31: TLabel;
    Label32: TLabel;
    Label33: TLabel;
    Label34: TLabel;
    Label35: TLabel;
    cbEventDesc: TComboBox;
    Label36: TLabel;
    Label39: TLabel;
    Label40: TLabel;
    rbNeverExpire: TRadioButton;
    rbDateExpire: TRadioButton;
    rbExpireOneRun: TRadioButton;
    dtDateExpire: TDateTimePicker;
    Label41: TLabel;
    Label42: TLabel;
    chkActive: TCheckBox;
    Label43: TLabel;
    Label44: TLabel;
    edtDays: TEdit;
    cbFrequency: TComboBox;
    memConditions: TMemo;
    rbMins: TRadioButton;
    Label46: TLabel;
    lvEmailRecip: TListView;
    btnContacts: TButton;
    lvSMSRecip: TListView;
    btnSMSContacts: TButton;
    Label9: TLabel;
    tvReports: TTreeView;
    Label50: TLabel;
    Label51: TLabel;
    Label52: TLabel;
    edtDescription: TEdit;
    Label53: TLabel;
    lblReport: TLabel;
    Label54: TLabel;
    Label37: TLabel;
    Label38: TLabel;
    edtWindowID: TEdit;
    edtHandlerID: TEdit;
    Label55: TLabel;
    edtEmSubject: TEdit;
    rbFreqAlways: TRadioButton;
    rbFreqRepeat: TRadioButton;
    btnEditParams: TButton;
    Label45: TLabel;
    Image1: TImage;
    edtName: TEdit;
    Label57: TLabel;
    Label58: TLabel;
    btnSave: TButton;
    Label59: TLabel;
    Label60: TLabel;
    chkAttachReport: TCheckBox;
    edMins: TEdit;
    edMinsBetween: TEdit;
    chkAttachCSV: TCheckBox;
    btnEmAddDelete: TButton;
    btnEmAddEdit: TButton;
    btnSMSDelete: TButton;
    btnSMSNoEdit: TButton;
    btnLogicEdit: TButton;
    pgcEmailMsg: TPageControl;
    pgEmailHeader: TTabSheet;
    pgEmailLines: TTabSheet;
    pgEmailTrailer: TTabSheet;
    lblEmailMsg: TLabel;
    memEmailHeader: TMemo;
    lblEmailHeader: TLabel;
    lblEmailLines: TLabel;
    memEmailLines: TMemo;
    Label47: TLabel;
    memEmailTrailer: TMemo;
    grpDays: TGroupBox;
    GroupBox2: TGroupBox;
    chkMonday: TCheckBox;
    chkTuesday: TCheckBox;
    chkWednesday: TCheckBox;
    chkThursday: TCheckBox;
    chkFriday: TCheckBox;
    chkSaturday: TCheckBox;
    chkSunday: TCheckBox;
    dtStartDate: TDateTimePicker;
    grpPeriod: TGroupBox;
    Label48: TLabel;
    Label49: TLabel;
    spnDaysBetween: TSpinEdit;
    GroupBox1: TGroupBox;
    rbDaily: TRadioButton;
    rbPeriod: TRadioButton;
    rbFreqNever: TRadioButton;
    spnTriggerCount: TSpinEdit;
    Label56: TLabel;
    Bevel1: TBevel;
    chkDeleteAfterExpiry: TCheckBox;
    rbHigh: TRadioButton;
    rbLow: TRadioButton;
    gbEmailType: TGroupBox;
    rbSingleEmail: TRadioButton;
    rbMultEmail: TRadioButton;
    Label8: TLabel;
    lblCharsRemaining: TLabel;
    lvParams: TListView;
    Label16: TLabel;
    Label17: TLabel;
    edtRepEmailSub: TEdit;
    Label62: TLabel;
    memRepEmailMsg: TMemo;
    Label63: TLabel;
    Label64: TLabel;
    Label68: TLabel;
    Label69: TLabel;
    lvRepEmailAdd: TListView;
    Label70: TLabel;
    btnRepContacts: TButton;
    Button2: TButton;
    Button3: TButton;
    Button4: TButton;
    Label66: TLabel;
    Label67: TLabel;
    Label65: TLabel;
    Label71: TLabel;
    lvRepFaxAdd: TListView;
    Button5: TButton;
    Button6: TButton;
    Button7: TButton;
    Button8: TButton;
    Label72: TLabel;
    GroupBox3: TGroupBox;
    GroupBox4: TGroupBox;
    edtRepFaxName: TEdit;
    edtRepFaxNo: TEdit;
    Label73: TLabel;
    Label74: TLabel;
    edtFaxCover: TEdit;
    Label75: TLabel;
    spFaxCover: TSpeedButton;
    memFaxNote: TMemo;
    Label76: TLabel;
    OpenDialog1: TOpenDialog;
    cbFaxPriority: TComboBox;
    Label77: TLabel;
    lblReportWarn: TLabel;
    gbRepOutput: TGroupBox;
    chkRepEmail: TCheckBox;
    chkRepFax: TCheckBox;
    pgForm: TTabSheet;
    pnlPaperless: TPanel;
    Label78: TLabel;
    spTransForm: TSpeedButton;
    edtTransForm: TEdit;
    chkSendDoc: TCheckBox;
    Panel3: TPanel;
    Label61: TLabel;
    Label79: TLabel;
    rbAlert: TRadioButton;
    rbReport: TRadioButton;
    Label80: TLabel;
    edtFind: TEdit;
    btnFind: TButton;
    pnlIdx: TPanel;
    lblIndex: TLabel;
    cbIndex: TComboBox;
    Label23: TLabel;
    cbRangeStart: TComboBox;
    spnOffStart: TSpinEdit;
    lblOffStart: TLabel;
    lblOffEnd: TLabel;
    spnOffEnd: TSpinEdit;
    Label24: TLabel;
    cbRangeEnd: TComboBox;
    chkRepConditions: TCheckBox;
    Panel4: TPanel;
    lblTrigger: TLabel;
    Button9: TButton;
    chkRepAsCSV: TCheckBox;
    gbCSVOutput: TGroupBox;
    chkCSVEmail: TCheckBox;
    chkCSVFtp: TCheckBox;
    chkCSVFolder: TCheckBox;
    Label81: TLabel;
    lblCSVFolder: TLabel;
    Label84: TLabel;
    edtFTPSite: TEdit;
    edtFTPUser: TEdit;
    edtFTPPassword: TEdit;
    edtFTPPort: TEdit;
    edtFTPDir: TEdit;
    Label85: TLabel;
    Label86: TLabel;
    Label87: TLabel;
    Label88: TLabel;
    Label89: TLabel;
    Bevel2: TBevel;
    lblCSVName: TLabel;
    edtCSVName: TEdit;
    tvFolder: TTreeView;
    ImageList1: TImageList;
    edtTimeout: TEdit;
    Label82: TLabel;
    Button10: TButton;
    Label83: TLabel;
    lblEntFolder: TLabel;
    btnEmFuncs: TButton;
    btnSMSFunc: TButton;
    chkWordWrap: TCheckBox;
    cbCSVType: TComboBox;
    bvContEmploy: TBevel;
    lblContEmploy: TLabel;
    Label22: TLabel;
    Label90: TLabel;
    Label91: TLabel;
    spNotifyHours: TSpinEdit;
    Label92: TLabel;
    Label93: TLabel;
    chkMarkExisting: TCheckBox;
    rgAcType: TRadioGroup;
    Panel5: TPanel;
    Label94: TLabel;
    Label95: TLabel;
    Label96: TLabel;
    lvRemoteAdd: TListView;
    Button11: TButton;
    Button12: TButton;
    Button13: TButton;
    btnRemoteContacts: TButton;
    rbNewRep: TRadioButton;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure btnNextClick(Sender: TObject);
    procedure btnPrevClick(Sender: TObject);
    procedure cbFrequencyChange(Sender: TObject);
    procedure btnContactsClick(Sender: TObject);
    procedure btnSMSContactsClick(Sender: TObject);
    procedure tvReportsChange(Sender: TObject; Node: TTreeNode);
    procedure cbDatafileChange(Sender: TObject);
    procedure cbEventDescChange(Sender: TObject);
    procedure rbDateExpireClick(Sender: TObject);
    procedure rbMinsClick(Sender: TObject);
    procedure btnEmailAddClick(Sender: TObject);
    procedure btnSMSAddClick(Sender: TObject);
    procedure chkEmailClick(Sender: TObject);
    procedure lvEmailRecipInsert(Sender: TObject; Item: TListItem);
    procedure memEmailMsgChange(Sender: TObject);
    procedure lvSMSRecipInsert(Sender: TObject; Item: TListItem);
    procedure memSMSMsgChange(Sender: TObject);
    procedure rbFreqRepeatClick(Sender: TObject);
    procedure edtNameChange(Sender: TObject);
    procedure btnSaveClick(Sender: TObject);
    procedure btnEmailInsertDbClick(Sender: TObject);
    procedure btnSMSInsertDBClick(Sender: TObject);
    procedure btnEmAddDeleteClick(Sender: TObject);
    procedure btnSMSDeleteClick(Sender: TObject);
    procedure btnLogicEditClick(Sender: TObject);
    procedure cbIndexChange(Sender: TObject);
    procedure btnSMSNoEditClick(Sender: TObject);
    procedure btnEmAddEditClick(Sender: TObject);
    procedure rbDailyClick(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure FormKeyPress(Sender: TObject; var Key: Char);
    procedure lvEmailRecipKeyUp(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure lvSMSRecipKeyUp(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure btnEditParamsClick(Sender: TObject);
    procedure chkRepEmailClick(Sender: TObject);
    procedure spFaxCoverClick(Sender: TObject);
    procedure cbRangeStartExit(Sender: TObject);
    procedure cbRangeStartChange(Sender: TObject);
    procedure btnFindClick(Sender: TObject);
    procedure edtFindChange(Sender: TObject);
    procedure cbRangeStartDblClick(Sender: TObject);
    procedure rbEventClick(Sender: TObject);
    procedure rbReportClick(Sender: TObject);
    procedure Button9Click(Sender: TObject);
    procedure chkCSVEmailClick(Sender: TObject);
    procedure chkRepAsCSVClick(Sender: TObject);
    procedure edtCSVNameChange(Sender: TObject);
    procedure tvFolderExpanded(Sender: TObject; Node: TTreeNode);
    procedure tvFolderCollapsed(Sender: TObject; Node: TTreeNode);
    procedure tvFolderKeyUp(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure tvFolderMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure edtFTPPortExit(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure edtFTPPasswordEnter(Sender: TObject);
    procedure edtFTPPasswordExit(Sender: TObject);
    procedure Button10Click(Sender: TObject);
    procedure btnEmFuncsClick(Sender: TObject);
    procedure btnSMSFuncClick(Sender: TObject);
    procedure edtEmSubjectEnter(Sender: TObject);
    procedure edtEmSubjectExit(Sender: TObject);
    procedure pgcEmailMsgChange(Sender: TObject);
    procedure chkWordWrapClick(Sender: TObject);
    procedure memEmailLinesExit(Sender: TObject);
    procedure chkSendDocClick(Sender: TObject);
    procedure tvReportsExpanding(Sender: TObject; Node: TTreeNode;
      var AllowExpansion: Boolean);
    procedure edtNameExit(Sender: TObject);
    procedure cbCSVTypeClick(Sender: TObject);
    procedure chkMarkExistingClick(Sender: TObject);
    procedure tvReportsCollapsing(Sender: TObject; Node: TTreeNode;
      var AllowCollapse: Boolean);
  private
    { Private declarations }
    ThisElert : TElertObject;
    ThisAddress : TAddress;
    ThisRemoteAddress : TRemoteAddress;
    ThisSMS   : TSMS;
    ThisOutput : TOutput;
    ThisReport : TReportNameRec;
    FToolkit   : IToolkit;
    FIsEdit     : Boolean;
    SMSCharCount : Word;
    SMSFields : TStringList;
    DateChanged : Boolean;
    ParamsChanged : Boolean;
    OldReportName : String;
    FDlgCaption : String[3];
    AllowClose : Boolean;
    InEmailSubject : Boolean;
    DefFaxName, DefFaxNo : string;
    FCurrencyList : TStringList;
    JC : Boolean;
    RepTreeLoaded : Boolean;
    oReportTree : IReportTree_Interface;
//    RepType  : Integer;

    TreeNodeType, TreeNodeName, TreeNodeDesc,
    TreeNodeParent, TreeNodeChild, FileName, LastRun : ShortString;
    AllowEdit : Boolean;
//    RepType : Byte;
    function EnableNext : Boolean;
    function EnablePrev : Boolean;
    procedure SetPage(WhichPage : Byte);
    procedure SaveForm;
    procedure FillReportTree(const EekGrp : ShortString; Node : TTreeNode);
    procedure FillNewReportTree(const ParentID : ShortString; Node : TTreeNode);
    function SelectDBField : ShortString;
    procedure PutDBField(AMemo : TMemo);
    procedure SetDataFileEdits(Allow : Boolean);
    function RemoveSpaces(const s : ShortString) : ShortString;
    procedure ReportParams(const ReportName : ShortString);
    procedure SetElert(const AnElert : ShortString);
    procedure SetUserID(const AUserID : ShortString);
    procedure SetActive(WhichPage : Byte);
    procedure ShowReportSelection;
    procedure SetIsEdit(Value : Boolean);

    procedure SaveAddresses;
    procedure LoadAddresses;
    procedure DeleteAddresses;

    procedure SaveRemoteAddresses;
    procedure LoadRemoteAddresses;
    procedure DeleteRemoteAddresses;

    procedure SaveSMSNos;
    procedure LoadSMSNos;
    procedure DeleteSMSNos;

    procedure SaveSMSOutput;
    procedure LoadSMSOutput;

    procedure SaveEmailOutput;
    procedure LoadEmailOutput;

    procedure SaveReportParams;
    procedure LoadReportParams;

    procedure SaveConditions;
    procedure LoadConditions;

    procedure SaveRepEmailOutput;
    procedure LoadRepEmailOutput;

    procedure SaveRepEmailAddresses;
    procedure LoadRepEmailAddresses;
    procedure SaveRepFaxNos;
    procedure LoadRepFaxNos;

    procedure SaveFaxOptions;
    procedure LoadFaxOptions;

    procedure DeleteOutputs(Which : TOutputLineType);

    procedure SetReportOutputControls;

    procedure DataDict(AList : TStrings; Prefix : ShortString);

    procedure GetReportDelivery(AList : TListBox; Edit : Boolean);
    function RemoveType(const s : AnsiString) : AnsiString;
    function AddType(const s : ShortString; Index : Integer) : AnsiString;
    procedure DeleteListViewItem(WhichOne : TListView);

    procedure SetEmailMsgType;
    procedure FocusFirstLine(const lv : TListView);

    function GetValueType(FNo, IndexNo : SmallInt) : TElertRangeValType;

    procedure SetDbPage;
    function FieldLength(const s : ShortString) : Byte;
    function CheckMsgLength(const Msg : AnsiString) : SmallInt;
    procedure CopyEmailToSMS;
    function EmailRecipType(const s : ShortString) : TEmailRecipType;
    procedure SetImage(WhichPage : Byte);
    procedure SetOutputButtons;
    function SetListView : TListView;
    procedure LoadEmail(EType : TOutputLineType; Mem : TMemo);

    function Param2Text(const s : ShortString; OffSet : SmallInt; EntParamType : Byte) : ShortString;
    procedure Text2Param(var s : ShortString; var OffSet : SmallInt; EntParamType : Byte;
                             Store : Boolean = False);
    function IsReport : Boolean;
    function IsCSV : Boolean;
    function IsTransaction : Boolean;
    function RemoveDateSep(const s : string) : String;
    function DataType : Byte;
    function FindNextReport(const s : String) : Boolean;
    procedure UpdateTriggerCaption;
    function DeleteQuery(const s : string) : Boolean;

    procedure AddFolder(s : String; PNode : TTreeNode);
    function GetSelectedCSVFolder : string;
    procedure SetCSVPath(const s : string);
    function NeedNewNextRun : Boolean;
    procedure ReadFaxDefaults;
    procedure FormatList(AList : TStrings);
    procedure SetToolkit(Value : IToolkit);
    procedure SetVAOComponents;
    procedure MoveRepControl(WhichControl : TControl);
  public
    { Public declarations }
    procedure LoadFolderTree;
    procedure LoadForm;
    function GetFileNo : SmallInt;
    property UserID : ShortString write SetUserID;
    property Toolkit : IToolkit read FToolkit write SetToolkit;
    property Elert : TElertObject read ThisElert write ThisElert;
    property IsEdit : Boolean read FIsEdit write SetIsEdit;
  end;

var
  frmElWizard: TfrmElWizard;

implementation

{$R *.DFM}
uses
  EmAdd, SMSAdd, BtrvU2, RpCommon, VarFPosU, ElEvDefs, selfld2, ElRepDel, frmLacol,
  smsEdit, EmailEd, DataDict, BTSupU2, ParamF, EtDateU, DatePick,
  ApiUtil, NewFold, IniFiles, Reppass, VarConst, SysU2, RptEngDll, GlobVar, NewParam,
  VaoUtil, SQLUtils, Math,

  //PR: 08/07/2013 ABSEXCH-14438 Rebranding
  Brand;

const
  tagEmailHeader = 1;
  tagEmailLine = 2;
  tagEmailTrailer = 3;


procedure TfrmElWizard.FormCreate(Sender: TObject);
var
  i : integer;
  WantF : Boolean;
begin
  SetVAOComponents;
  RepTreeLoaded := False;
    {$IFDEF PALL}
    WriteToPalladiumLog('Wizard.FormCreate');
    {$ENDIF}
  InEmailSubject := False;
  Notebook1.PageIndex := 0;
{  ThisElert := TElertObject.Create;} //Created in main form
  DateChanged := False;
  ThisOutput := TOutput.Create;
    {$IFDEF PALL}
    WriteToPalladiumLog('Back from TOutput.Create');
    {$ENDIF}
  ThisAddress := TAddress.Create;
  ThisRemoteAddress := TRemoteAddress.Create;
    {$IFDEF PALL}
    WriteToPalladiumLog('Back from TAddress.Create');
    {$ENDIF}
  ThisSMS := TSMS.Create;
    {$IFDEF PALL}
    WriteToPalladiumLog('Back from TSMS.Create');
    {$ENDIF}

    {$IFDEF PALL}
    WriteToPalladiumLog('About to call FillReportTree');
    {$ENDIF}
//  FillReportTree('', nil);
    {$IFDEF PALL}
    WriteToPalladiumLog('After FillReportTree');
    {$ENDIF}

  SMSFields := TStringList.Create;


  ExVersionNo := Which_ExVerNo;
    {$IFDEF PALL}
    WriteToPalladiumLog('Got ExVersionNo');
    {$ENDIF}

{$IFDEF EN550CIS}
  For i := 1 To High(DataFilesL^) Do Begin
    Case i Of
      { Stock File }
      6       : WantF := (ExVersionNo In [2,4,5,6,8,9,11]);

      { Cost Centre and Departments }
      7, 8    : WantF := (ExVersionNo >= 3);

      { Not Used or Form Designer Only }
      9,
      12,
      13      : WantF := False;

      { Bill Of Materials }
      10      : WantF := (ExVersionNo In [2,4,5,6,8,9,11]);

      { Discount Matrix }
      14      : WantF := (ExVersionNo In [2,4,5,6,8,9,11]);

      { Serial Number DB }
      16      : WantF := (ExVersionNo In [5, 6, 9, 11]);

      { Job Costing files - Job Costing versions only }
      11, 15,
      17..19,
      21..25
        : WantF := (ExVersionNo In [6,11]);


      { FIFO }
      20      : WantF := (ExVersionNo In [2,4,5,6,8,9,11]);

      { Stock location files - SPOP versions only }
      26, 27  : WantF := (ExVersionNo In [5,6,9,11]);

      { Matched Payments }
      28      : WantF := True;

      { Stock Notes }
      31      : WantF := (ExVersionNo In [2,4,5,6,8,9,11]);
      //PR: 20/03/01 CIS Vouchers
      {$IFDEF EN550CIS}
      33      : WantF := (ExVersionNo In [6,11]) and CISOn;
      {$ENDIF}

      //PR: 22/07/2009 AltStockCode - SPOP Only
      35      : WantF := (ExVersionNo In [5,6,9,11]);

      36      : WantF := False; //Until we add Multi-Buy discounts in.

    Else
      WantF := True;
    End; { Case }

    If WantF Then
      cbDataFile.Items.AddObject(DataFilesL^[i], TObject(i));
  end;
{$ELSE}
  for i := 1 to 14 do
    cbDataFile.Items.AddObject(DataFilesL^[i], TObject(i));
{$ENDIF}
    {$IFDEF PALL}
    WriteToPalladiumLog('After add data files');
    {$ENDIF}

  Case ExVersionNo of
    1  : cbDataFile.ItemIndex := 0;
    2  : cbDataFile.ItemIndex := 1;
    4  : cbDataFile.ItemIndex := 2;
    6,11 : cbDataFile.ItemIndex := 3;
    else
      cbDataFile.ItemIndex := 3;
{  else
    cbDataFile.ItemIndex := 0;}
  end;
  for i := 1 to MaxEvents do
    cbEventDesc.Items.Add(Events[i].evDescription);
    {$IFDEF PALL}
    WriteToPalladiumLog('After add events');
    {$ENDIF}
  cbEventDesc.ItemIndex := 0;
  cbEventDescChange(Self);



  rbMinsClick(Self);
  rbDateExpireClick(Self);
  rbFreqRepeatClick(Self);
  cbFrequencyChange(Self);

  SetPage(pgDescription);
    {$IFDEF PALL}
    WriteToPalladiumLog('After SetPage');
    {$ENDIF}

  if not IsEdit then
  begin
    dtStartDate.DateTime := Now;
    chkRepEmail.Checked := True;
    chkEmail.Checked := True;
  end;

  SMSCharCount := 0;

    {$IFDEF PALL}
    WriteToPalladiumLog('About to load dd fields');
    {$ENDIF}
  if Assigned(Form_SelectField2) then
    Form_SelectField2.LoadFields;
    {$IFDEF PALL}
    WriteToPalladiumLog('Back from load dd fields');
    {$ENDIF}

  ParamsChanged := False;

  SetPage(pgDescription);

  FCurrencyList := TStringList.Create;

  rbReport.Visible := not UsingSQL;
  if not rbReport.Visible then
  begin
    MoveRepControl(rbNewRep);
    MoveRepControl(chkRepConditions);
    MoveRepControl(chkRepAsCSV);
    MoveRepControl(cbCSVType);
    MoveRepControl(lblCSVName);
    MoveRepControl(edtCSVName);
  end;
end;

procedure TfrmElWizard.FormDestroy(Sender: TObject);
var
  i : integer;
begin
{  if Assigned(ThisElert) then
    ThisElert.Free;}
  if Assigned(ThisOutput) then
    ThisOutput.Free;
  if Assigned(ThisAddress) then
    ThisAddress.Free;
  if Assigned(ThisSMS) then
    ThisSMS.Free;

  for i := 0 to tvReports.Items.Count - 1 do
    FreeMem(tvReports.Items[i].Data, SizeOf(TReportNameRec));

  if Assigned(SMSFields) then
    SMSFields.Free;

  if Assigned(FCurrencyList) then
    FCurrencyList.Free;

end;

function TfrmElWizard.EnableNext : Boolean;
begin
  Result := True;
end;

function TfrmElWizard.EnablePrev : Boolean;
begin
  Result := Notebook1.PageIndex > 0;
end;


procedure TfrmElWizard.btnNextClick(Sender: TObject);
var
  s : ShortString;

  procedure AfterReportOrParams;
  begin
    if chkRepEmail.Checked or chkCSVEmail.Checked then
      SetPage(pgRepEmailAdd)
    else
    if chkRepFax.Checked then
      SetPage(pgRepFaxAdd)
    else
    if chkCSVFtp.Checked then
      SetPage(pgCSVFTP)
    else
    if chkCSVFolder.Checked then
      SetPage(pgCSVFolder)
    else
    if rbTimer.Checked then
      SetPage(pgDay)
    else
      SetPage(pgExpiry);
  end;

begin
  Case Notebook1.PageIndex of
    pgDescription      :  {$IFNDEF EN551p}if ReportsAvailable or VisualReportsAvailable then {$ENDIF}
                            SetPage(pgType) {$IFNDEF EN551p}
                          else
                            SetPage(pgPriority){$ENDIF};
    pgType             :  SetPage(pgPriority);
    pgPriority         : // SetPage(pgTransmission);
                           if (not IsReport or chkRepConditions.Checked) then
                             SetPage(pgPushPull)
                           else
                             SetPage(pgTransmission);
    pgPushPull         :  begin
                            SetPage(pgTransmission);
    {                         if rbTimer.Checked then
                               SetPage(pgDataFile)
                             else
                               SetPage(pgEvent);}
                          end;
    pgTransmission     :  begin
                            if (not IsReport or chkRepConditions.Checked) then
                            begin
                              if rbTimer.Checked then
                               SetPage(pgDataFile)
                             else
                               SetPage(pgEvent);
                            end
                            else
                              SetPage(pgReport);

{                            if rbTimer.Checked then
                            begin
                              if (not IsReport or chkRepConditions.Checked) then
                                SetPage(pgDataFile)
                              else
{                            if not IsReport or chkRepConditions.Checked then
                              SetPage(pgConditions)
                            else
                             if chkEmail.Checked then
                               SetPage(pgEmailAdd)
                             else
                             if chkSMS.Checked then
                               SetPage(pgSMSNos)
                             else
                               SetPage(pgReport);
                            end
                            else
                              SetPage(pgEvent); }

                          end;
    pgDataFile         :  begin
                             SetPage(pgConditions);
                          end;
    pgFrequency       :  begin
                            { SetPage(pgFrequency);}
                            if not IsReport then
                            begin
                              if chkEmail.Checked then
                                SetPage(pgEmailAdd)
                              else
                              if chkSMS.Checked then
                                SetPage(pgSMSNos);
                            end
                            else
                              SetPage(pgReport);
                          end;
    pgConditions        :  begin
                            SetPage(pgFrequency);
                          end;

    pgEmailAdd         :  begin
                            SetPage(pgEmailMsg);
                          end;

    pgEmailMsg         :  begin
                            if pgForm.TabVisible and chkSendDoc.Checked and (Trim(edtTransForm.Text) = '') then
                            begin
                              ShowMessage('Please select a form to send');
                              SetPage(pgEmailMsg);
                            end
                            else
                            if chkSMS.Checked then
                              SetPage(pgSMSNos)
                            else
{                            if chkReport.Checked or chkCSV.Checked then
                              SetPage(pgReport)
                            else}
                            begin
                              if rbTimer.Checked then
                                SetPage(pgDay)
                              else
                                SetPage(pgExpiry);
                            end;
                          end;

    pgSMSNos           :  begin

                            SetPage(pgSMSMsg);
                          end;

    pgSMSMsg           :  begin
{                            if chkReport.Checked or chkCSV.Checked then
                              SetPage(pgReport)
                            else}
                            begin
                              if rbTimer.Checked then
                                SetPage(pgDay)
                              else
                                SetPage(pgExpiry);
                            end;
                          end;
    pgReport            : begin
                            if Trim(ThisReport.RepName) <>
                                Trim(OldReportName) then
                                  ParamsChanged := False;
                            if rbReport.Checked and (ThisReport.NoOfParams > 0) then
                            begin
                              SetPage(pgReportParams);
                              //need this to get round bug in report writer
                              //where number of params is inaccurate
                              if lvParams.Items.Count = 0 then
                                btnNext.Click;
                            end
                            else
                            if rbNewRep.Checked then
                            begin
                              ThisReport.NoOfParams :=
                                      LoadNewReportParams(ThisReport.RepName, ThisElert.UserID, SetDrive,
                                                          lvParams, FCurrencyList, FToolkit);
                              if ThisReport.NoOfParams > 0 then
                                SetPage(pgReportParams)
                              else
                                AfterReportOrParams;
                            end
                            else
                            begin
                              AfterReportOrParams;
                            end;
                          end;
    pgReportParams      : begin
                            AfterReportOrParams;
                          end;

    pgDay               : begin
                            SetPage(pgTime);
                          end;

    pgTime              : begin
                            SetPage(pgExpiry);
                          end;

    pgEvent             : begin
                            if (not IsReport or chkRepConditions.Checked) then
                              SetPage(pgConditions)
                            else
                              SetPage(pgReport);

                          end;

    pgExpiry            : begin
                            {$IFDEF EN551p}
                            SetPage(pgNotify);
                            {$ELSE}
                            SetPage(pgActive);
                            {$ENDIF}
                          end;

    pgNotify            : begin
                          {$IFDEF REMOTE}
                            if rbTimer.Checked and (VAOInfo.vaoMode <> smVAO) then
                              SetPage(pgRemote)
                            else
                          {$ENDIF}
                              SetPage(pgActive);
                          end;

    pgRemote            :  SetPage(pgActive);

    pgActive            : begin
                            //Finish
                            SaveForm;
                          end;
    pgRepEmailAdd       : begin
                            SetPage(pgRepEmailMsg);
                          end;
    pgRepEmailMsg       : begin
                            if chkRepFax.Checked then
                              SetPage(pgRepFaxAdd)
                            else
                            if chkCSVFtp.Checked then
                              SetPage(pgCSVFTP)
                            else
                            if chkCSVFolder.Checked then
                              SetPage(pgCSVFolder)
                            else
                            if rbTimer.Checked then
                              SetPage(pgDay)
                            else
                              SetPage(pgExpiry);
                          end;
    pgRepFaxAdd         : begin
                            SetPage(pgRepFaxOpts);
                          end;

    pgRepFaxOpts        : begin
                            if rbTimer.Checked then
                              SetPage(pgDay)
                            else
                              SetPage(pgExpiry);
                          end;
   pgCSVFTP      : begin
                            if chkCSVFolder.Checked then
                              SetPage(pgCSVFolder)
                            else
                            if rbTimer.Checked then
                              SetPage(pgDay)
                            else
                              SetPage(pgExpiry);
                          end;
    pgCSVFolder         : begin
                            if rbTimer.Checked then
                              SetPage(pgDay)
                            else
                              SetPage(pgExpiry);
                          end;

  end; //case
end;

procedure TfrmElWizard.SetPage(WhichPage : Byte);
var
  DType : Byte;
begin
  if (WhichPage >= 0) and (WhichPage < Notebook1.Pages.Count) then
    Notebook1.PageIndex := WhichPage;

  btnPrev.Enabled := WhichPage > 0;
  if WhichPage = pgActive then
  begin
    btnNext.Caption := '&Finish';
    btnNext.ModalResult := mrOK;
  end
  else
  begin
    btnNext.Caption := '&Next  >>';
    btnNext.ModalResult := mrNone;
  end;

  Case WhichPage of
    pgType          : begin
                        {$IFDEF EN551p}
                        rbReport.Enabled := ReportsAvailable;
                        rbNewRep.Enabled := VisualReportsAvailable;
                        {$ENDIF}
                        btnNext.Enabled := True;
                        rbReportClick(Self);
                      end;
    pgDescription   : edtNameChange(Self);
    pgPriority      : begin
                        btnNext.Enabled := True;
                        rbEventClick(Self);
                      end;
    pgPushPull      : begin
                        btnNext.Enabled := True;
                        rbEventClick(Self);
                      end;
    pgDatafile      : begin
                        btnNext.Enabled := True;
{                        cbDataFileChange(Self);
                        cbIndexChange(Self);}
                        DType := DataType;
                        SetLabel(cbRangeStart, lblOffStart, DType);
                        SetLabel(cbRangeEnd, lblOffEnd, DType);

                      end;
    pgConditions    : begin
                        btnNext.Enabled := True;
                        SetDbPage;
{                        lblReportWarn.Visible := chkReport.Checked;}
                      end;
    pgTransmission  : begin
                        chkEmail.Visible := not IsReport;
                        chkSMS.Visible := not IsReport;
                        gbEmailType.Visible := not IsReport;
                        gbRepOutput.Visible := IsReport and not IsCSV;
                        gbCSVOutput.Visible := IsCSV;
{I don't know what these 2 lines were doing here - I'll remove them for now & see
if it causes a problem.
                        chkRepConditions.Visible := IsReport;
                        chkRepAsCSV.Visible := IsReport;}
                        if not IsReport then
                          chkEmailClick(Self)
                        else
                        if IsCSV then
                          chkCSVEmailClick(Self)
                        else
                          chkRepEmailClick(Self);
                      end;
    pgFrequency     : btnNext.Enabled := True;
    pgEmailAdd      : begin
                        btnContacts.Visible := (VAOInfo.vaoMode <> smVAO);
                        lvEmailRecipInsert(lvEmailRecip, nil);
                        FocusFirstLine(lvEmailRecip);
                      end;
    pgEmailMsg      : begin
                        SetEmailMsgType;
{                        chkAttachReport.Enabled := chkReport.Checked;
                        chkAttachCSV.Enabled    := chkCSV.Checked;}
                        memEmailMsgChange(Self);
                      end;
    pgSMSNos        : begin
                        lvSMSRecipInsert(lvSMSRecip, nil);
                        FocusFirstLine(lvSMSRecip);
                      end;
    pgSMSMsg        : begin
                         if chkEmail.Checked then
                           CopyEmailToSMS;
                         memSMSMsgChange(Self);
                      end;
    pgReport        : begin
                        if not RepTreeLoaded then
                        begin
                          if rbNewRep.Checked then
                            FillNewReportTree('0', nil)
                          else
                            FillReportTree('', nil);
                          RepTreeLoaded := True;
                        end;
                        if (ThisReport.RepName = '')  then
                          lblReport.Caption := 'None'
                        else
                          ShowReportSelection;

                        btnNext.Enabled := lblReport.Caption <> 'None';
                        OldReportName := ThisReport.RepName;
                      end;
    pgReportParams  : begin
                        if rbReport.Checked then
                          ReportParams(ThisReport.RepName)
                        else //New report
                          if IsEdit and (Trim(ThisElert.NewReportName) = Trim(ThisReport.RepName)) then
                             LoadReportParams;
                        btnNext.Enabled := True;
                      end;
    pgDay           : begin
                        btnNext.Enabled := True;
                        if {ThisElert.Periodic}rbPeriod.Checked then
                          rbDailyClick(rbPeriod)
                        else
                          rbDailyClick(rbDaily);
                      end;
    pgTime          : begin
                        btnNext.Enabled := True;
                        if not IsEdit then
                          if rbPeriod.Checked then
                            rbSpecific.Checked := True;
                      end;
    pgEvent         : btnNext.Enabled := True;
    pgExpiry        : btnNext.Enabled := True;
    pgActive        : btnNext.Enabled := True;
    pgRepEmailAdd   : begin
                        btnRepContacts.Visible := (VAOInfo.vaoMode <> smVAO);
                        lvEmailRecipInsert(lvRepEmailAdd, nil);
                        FocusFirstLine(lvRepEmailAdd);
                      end;
    pgRepEmailMsg   : begin
                        btnNext.Enabled := True;
                        if not IsEdit then
                          edtRepEmailSub.Text := {'Enterprise Report - ' + }lblReport.Caption;
                      end;
    pgRepFaxAdd     : begin
                        lvSMSRecipInsert(lvRepFaxAdd, nil);
                        FocusFirstLine(lvRepFaxAdd);
                      end;
    pgRepFaxOpts    : begin
                        btnNext.Enabled := True;
                        if not IsEdit then
                        begin
                          ReadFaxDefaults;
                          edtRepFaxName.Text := DefFaxName;
                          edtRepFaxNo.Text := DefFaxNo;
                        end;
                      end;
    pgCSVFolder     : begin
                        btnNext.Enabled := Trim(edtCSVName.Text) <> '';
                        lblEntFolder.Caption := 'Exchequer Folder: ' +
                           FToolkit.Configuration.EnterpriseDirectory;
                        ActiveControl := tvFolder;
                      end;
    pgRemote        : btnRemoteContacts.Visible := (VAOInfo.vaoMode <> smVAO);
  end; //case

  SetActive(WhichPage);
  SetImage(WhichPage);

end;

procedure TfrmElWizard.btnPrevClick(Sender: TObject);
begin
  Case Notebook1.PageIndex of
     pgActive          :  {$IFDEF REMOTE}
                          if rbTimer.Checked and (VAOInfo.vaoMode <> smVAO) then
                             SetPage(pgRemote)
                          else
                          {$ENDIF}
                             SetPage(pgNotify);
     pgRemote          :  SetPage(pgNotify);
     pgNotify          :  SetPage(pgExpiry);
     pgExpiry          :  if rbTimer.Checked then
                            SetPage(pgTime)
                          else
                          if IsReport then
                          begin
                            if IsCSV then
                            begin
                              if chkCSVFolder.Checked then
                                SetPage(pgCSVFolder)
                              else
                              if chkCSVFtp.Checked then
                                SetPage(pgCSVFTP)
                              else
                                SetPage(pgRepEmailMsg);
                            end
                            else
                            begin
                              if chkRepFax.Checked then
                                  SetPage(pgRepFaxOpts)
                              else
                              if chkRepEmail.Checked then
                                 SetPage(pgRepEmailMsg);
                            end;
                          end
                          else
                          if chkSMS.Checked then
                             SetPage(pgSMSMsg)
                          else
                            SetPage(pgEMailMsg);

     pgTime            :  SetPage(pgDay);
     pgDay             :  if IsReport then
                          begin
                            if IsCSV then
                            begin
                              if chkCSVFolder.Checked then
                                SetPage(pgCSVFolder)
                              else
                              if chkCSVFtp.Checked then
                                SetPage(pgCSVFTP)
                              else
                                SetPage(pgRepEmailMsg);
                            end
                            else
                            begin
                              if chkRepFax.Checked then
                                  SetPage(pgRepFaxOpts)
                              else
                              if chkRepEmail.Checked then
                                 SetPage(pgRepEmailMsg);
                            end;
{                            if chkRepFax.Checked then
                                SetPage(pgRepFaxOpts)
                            else
                            if chkRepEmail.Checked then
                               SetPage(pgRepEmailMsg)
                            else
                            if ThisReport.NoOfParams > 0 then
                            begin
                              SetPage(pgReportParams);
                              if lvParams.Items.Count = 0 then
                                btnPrev.Click;
                            end
                            else
                              SetPage(pgReport);}

                          end //IsReport
                          else
                          if chkSMS.Checked then
                             SetPage(pgSMSMsg)
                          else
                            SetPage(pgEMailMsg);
     pgReportParams    :  SetPage(pgReport);
     pgReport          :  if chkRepConditions.Checked then
                            SetPage(pgFrequency)
                          else
                            SetPage(pgTransmission);
     pgSMSMsg          :  SetPage(pgSMSNos);
     pgSMSNos          :  if chkEmail.Checked then
                            SetPage(pgEmailMsg)
                          else
                            SetPage(pgFrequency);

     pgEmailMsg        :  SetPage(pgEmailAdd);
     pgEmailAdd        :  SetPage(pgFrequency);
     pgTransmission    :  if (not IsReport or chkRepConditions.Checked) then
                          begin
                              SetPage(pgPushPull)
                          end
                          else
                            SetPage(pgPriority);
     pgFrequency       :  begin
                            //SetPage(pgTransmission);
                              SetPage(pgConditions)
                          end;
     pgConditions      :  if rbTimer.Checked then
                             SetPage(pgDataFile)
                          else
                             SetPage(pgEvent);
     pgDatafile        :  SetPage(pgTransmission);
     pgEvent           :  SetPage(pgTransmission);
     pgPushPull        :  SetPage(pgPriority);
     pgPriority        :  {$IFNDEF EN551p}if ReportsAvailable  or
                                             VisualReportsAvailable then{$ENDIF}
                            SetPage(pgType){$IFNDEF EN551p}
                          else
                            SetPage(pgDescription){$ENDIF};
     pgType            :  SetPage(pgDescription);
     pgRepEmailMsg     :  SetPage(pgRepEmailAdd);
     pgRepEmailAdd     :  if ThisReport.NoOfParams > 0 then
                          begin
                            SetPage(pgReportParams);
                            if lvParams.Items.Count = 0 then
                              btnPrev.Click;
                          end
                          else
                              SetPage(pgReport);

     pgRepFaxOpts      :  SetPage(pgRepFaxAdd);
     pgRepFaxAdd       :  begin
                            if chkRepEmail.Checked then
                                SetPage(pgRepEmailMsg)
                            else
                            if ThisReport.NoOfParams > 0 then
                            begin
                              SetPage(pgReportParams);
                              if lvParams.Items.Count = 0 then
                                btnPrev.Click;
                            end
                            else
                              SetPage(pgReport);
                          end;
     pgCSVFolder       :  begin
                            if chkCSVFtp.Checked then
                              SetPage(pgCSVFTP)
                            else
                            if chkCSVEmail.Checked then
                              SetPage(pgRepEmailMsg)
                            else
                            if ThisReport.NoOfParams > 0 then
                            begin
                              SetPage(pgReportParams);
                              if lvParams.Items.Count = 0 then
                                btnPrev.Click;
                            end
                            else
                              SetPage(pgReport);
                          end;
    pgCSVFTP           :  begin
                            if chkCSVEmail.Checked then
                              SetPage(pgRepEmailMsg)
                            else
                            if ThisReport.NoOfParams > 0 then
                            begin
                              SetPage(pgReportParams);
                              if lvParams.Items.Count = 0 then
                                btnPrev.Click;
                            end
                            else
                              SetPage(pgReport);
                        end;
  end; //case

end;




procedure TfrmElWizard.LoadForm;
var
  Res : SmallInt;
  s : String;
  i : integer;
begin
  with ThisElert do
  begin
    //Description
    edtName.Text := ElertName;
    edtDescription.Text := Description;

//     rgPriority.ItemIndex := Ord(Priority);

    if Priority = elpHigh then rbHigh.Checked := TRUE
    else rbLow.Checked := TRUE;

    spNotifyHours.Value := HoursToNotify;

    //Push/pull
    if ElertType = etTimer then
      rbTimer.Checked := True
    else
      rbEvent.Checked := True;

    //Datafile
    for i := 0 to cbDataFile.Items.Count - 1 do
      if Integer(cbDataFile.Items.Objects[i]) = FileNumber then
        cbDataFile.ItemIndex := i;
    cbDatafileChange(Self);


    for i := 0 to cbIndex.Items.Count - 1 do
      if Integer(cbIndex.Items.Objects[i]) = IndexNumber then
        cbIndex.ItemIndex := i;
    cbIndexChange(Self);

    with RangeStart do
    begin
      Case egType of
        evString,
        evPeriod  : cbRangeStart.Text := egString;
        evDate    : cbRangeStart.Text := Param2Text(egString, 0, 1);
        evInt     : cbRangeStart.Text := IntToStr(egInt);
      end;
      spnOffStart.Value := egOffset;
    end;

    with RangeEnd do
    begin
      Case egType of
        evString,
        evPeriod  : cbRangeEnd.Text := egString;
        evDate    : cbRangeEnd.Text := Param2Text(egString, 0, 1);
        evInt     : cbRangeEnd.Text := IntToStr(egInt);
      end;
      spnOffEnd.Value := egOffset;
    end;

    //Conditions
    LoadConditions;

    chkEmail.Checked  := ActionEmail;
    chkSMS.Checked    := ActionSMS;
    rbReport.Checked := ActionReport and not NewReport;
    rbNewRep.Checked := ActionReport and NewReport;
    chkRepAsCSV.Checked  := ActionCSV;

    cbCSVType.Visible := ActionCSV;
    if DBF then
      cbCSVType.ItemIndex := 1
    else
      cbCSVType.ItemIndex := ExRepFormat;
      
    chkRepEmail.Checked := ActionRepEmail;
    chkRepFax.Checked := ActionRepFax;

    chkCSVEmail.Checked := CSVByEmail;
    chkCSVFtp.Checked := CSVByFTP;
    chkCSVFolder.Checked := CSVToFolder;
    chkRepConditions.Checked := HasConditions;

    chkSendDoc.Checked := SendDoc;
    edtTransForm.Text := DocName;
    chkEmailClick(Self);

    if SingleEmail then
      rbSingleEmail.Checked := True
    else
      rbMultEmail.Checked := True;


    chkAttachReport.Checked := EmailReport;

    if RepeatPeriod = epNever then
      rbFreqNever.Checked := True
    else
    if RepeatPeriod = epAlways then
      rbFreqAlways.Checked := True
    else
      rbFreqRepeat.Checked := True;

    edtDays.Text := IntToStr(RepeatData);
    cbFrequency.ItemIndex := Ord(RepeatPeriod);

    //Moved to SetPage
{    if ((ReportName = '') and (NewReportName = '')) or not ActionReport then
      lblReport.Caption := 'None'
    else
      ShowReportSelection;}

    if Periodic then
    begin
      rbPeriod.Checked := True;
      rbDailyClick(rbPeriod);
    end
    else
    begin
      rbDaily.Checked := True;
      rbDailyClick(rbDaily);
    end;

     spnDaysBetween.Value := DaysBetween;

     chkMonday.Checked := DaysOfWeek and 1 = 1;
     chkTuesday.Checked := DaysOfWeek and 2 = 2;
     chkWednesday.Checked := DaysOfWeek and 4 = 4;
     chkThursday.Checked := DaysOfWeek and 8 = 8;
     chkFriday.Checked := DaysOfWeek and 16 = 16;
     chkSaturday.Checked := DaysOfWeek and 32 = 32;
     chkSunday.Checked := DaysOfWeek and 64 = 64;

     if IsEdit then
       dtStartDate.Date := StartDate
     else
       dtStartDate.Date := SysUtils.Date;

     Case TimeType of
        ettFrequency         : begin
                                 rbMins.Checked := True;
                                 edMins.Text := IntToStr(Frequency);
                               end;
        ettTimeOneOnly       : begin
                                 rbSpecific.Checked := True;
                                 dtSpecific.Time := Time1;
                               end;
        ettFrequencyInPeriod : begin
                                 rbMinsBetween.Checked := True;
                                 dtBetweenStart.Time := Time1;
                                 dtBetweenEnd.Time := Time2;
                                 edMinsBetween.Text := IntToStr(Frequency);
                               end;
     end; //case

//     chkRunOnStartup.Checked := RunOnStartup;

     if ElertType = etEvent then
     begin
        edtWindowID.Text := IntToStr(WindowID);
        edtHandlerID.Text := IntToStr(HandlerID);
        cbEventDesc.ItemIndex := EventIndex;
     end;
    Case Expiration of
      eetNever    : rbNeverExpire.Checked := True;
      eetDate     : begin
                      rbDateExpire.Checked := True;
                      dtDateExpire.Date := ExpirationDate;
                    end;
      eetAfterTriggers : rbExpireOneRun.Checked := True;
    end;

    spnTriggerCount.Value := TriggerCount;
    UpdateTriggerCaption;

    chkDeleteAfterExpiry.Checked := DeleteAfterExpiry;

    edtFTPSite.Text := FTPSite;
    edtFTPUser.Text := FTPUserName;
    edtFTPPassword.Text := FTPPassword;
    edtFTPDir.Text := UploadDir;
    edtFTPPort.Text := IntToStr(FTPPort);
    if FTPTimeout > 0 then
      edtTimeOut.Text := IntToStr(FTPTimeOut)
    else
      edtTimeOut.Text := '10';

    edtCSVName.Text := CSVFilename;
    //PR: 24/10/2016 v2017 R1 ABSEXCH-17766 If Excel format and we haven't already changed to xlsx, or
    //                                      filename is already 12 chars, then add x to end
    if (Pos('.xls', CSVFileName) > 0) and (Pos('.xlsx', CSVFileName) = 0) then
      edtCSVName.Text := edtCSVName.Text + 'x';



    if ReportFolder <> '' then
      SetCSVPath(ReportFolder);

    chkWordWrap.Checked := WordWrap;

    LoadAddresses;
    LoadSMSNos;

    LoadSMSOutput;
    LoadEmailOutput;
//    LoadReportParams;

    LoadRepEmailOutput;
    LoadRepFaxNos;
    LoadRepEmailAddresses;
    LoadFaxOptions;

    LoadRemoteAddresses;

    chkActive.Checked := Active;

    if NewReport then
      ThisReport.RepName := NewReportName
    else
      ThisReport.RepName := ReportName;

    if IsReport then
    begin
      if NewReport then
        ThisReport.NoOfParams := LoadNewReportParams(ThisReport.RepName, ThisElert.UserID, SetDrive, lvParams, FCurrencyList,
                                                      FToolkit);
      LoadReportParams;
    end;

    //PR: 27/09/2012 ABSEXCH-13194 Need to re-initialise ParamsChanged for each edit, otherwise
    //the parameter list doesn't get reloaded.
    ParamsChanged := False;
  end; //with
  SetPage(pgDescription);
end;

procedure TfrmElWizard.SaveForm;
var
  TempRec : TElertRangeRec;
  Res : SmallInt;
  i : integer;
  NewName : Boolean;
  OldName, ChangedName : String[30];
  VType : TElertRangeValType;
  ResetNextRunDate : Boolean;
  StartDateChanged : Boolean;
  iDaysOfWeek : Byte;
begin
  NewName := False;
  if IsEdit then
  begin
    if ThisElert.elertName <> Trim(edtName.Text) then
    begin
      NewName := True;
      ChangedName := Trim(edtName.Text);
      OldName := ThisElert.ElertName;
    end;
  end;
{  if IsEdit then
    ThisElert.Delete;}

  with ThisElert do
  begin
    DateTimeChanged := False;
    if not NewName then
      ElertName := edtName.Text;
    Description := edtDescription.Text;

//    Priority := TElertPriority(rgPriority.ItemIndex);


    if rbHigh.Checked then Priority := elpHigh
    else Priority := elpLow;

    HoursToNotify := spNotifyHours.Value;

    if HoursToNotify < 0 then
      HoursToNotify := 0;

    if rbTimer.Checked then
      ElertType := etTimer
    else
      ElertType := etEvent;

    if ElertType = etEvent then
      FileNumber := 0
    else
      FileNumber := Integer(cbDataFile.Items.Objects[cbDatafile.ItemIndex]);

    if FileNumber in [3, 4] then
    begin
      if cbIndex.ItemIndex >= 0 then
        IndexNumber := Integer(cbIndex.Items.Objects[cbIndex.ItemIndex]);
    end
    else
      IndexNumber := 0;


    VType := GetValueType(FileNumber, IndexNumber);
    TempRec := RangeStart;
    SetRange(TempRec, cbRangeStart.Text, spnOffStart.Value, VType);
    RangeStart := TempRec;
    TempRec := RangeEnd;
    SetRange(TempRec, cbRangeEnd.Text, spnOffend.Value, VType);
    RangeEnd := TempRec;

    SaveConditions;
    HasConditions := memConditions.Lines.Count > 0;

    RunNow := False;

    //Frequency
    if rbFreqNever.Checked then
      RepeatPeriod := epNever
    else
    if rbFreqAlways.Checked then
    begin
      RepeatPeriod := epAlways;
      DeleteTempRecs(pxElRecsSent);
    end
    else
      RepeatPeriod := TElertRepeatPeriod(cbFrequency.ItemIndex);

    RepeatData := StrToInt(edtDays.Text);

    //Transmission
    ActionEmail  := chkEmail.checked;
    ActionSMS    := chkSMS.Checked;
    ActionReport := rbReport.Checked or rbNewRep.Checked;
    NewReport := rbNewRep.Checked;
    ActionCSV    := IsCSV;
    ActionRepEmail   := chkRepEmail.Checked;
    ActionRepFax     := chkRepFax.Checked;

    HasConditions := chkRepConditions.Checked;


    CSVByEmail := chkCSVEmail.Checked;
    CSVByFTP := chkCSVFtp.Checked;
    CSVToFolder := chkCSVFolder.Checked;

    SingleEmail := rbSingleEmail.Checked;

    SendDoc := chkSendDoc.Checked and (not SingleEmail or rbEvent.Checked) and IsTransaction;
    DocName := edtTransForm.Text;


    //PR: 05/04/2011 ABSEXCH-2878
    //Days of week
    iDaysOfWeek := 0;
    if chkMonday.Checked then iDaysOfWeek := iDaysOfWeek or 1;
    if chkTuesday.Checked then iDaysOfWeek := iDaysOfWeek or 2;
    if chkWednesday.Checked then iDaysOfWeek := iDaysOfWeek or 4;
    if chkThursday.Checked then iDaysOfWeek := iDaysOfWeek or 8;
    if chkFriday.Checked then iDaysOfWeek := iDaysOfWeek or 16;
    if chkSaturday.Checked then iDaysOfWeek := iDaysOfWeek or 32;
    if chkSunday.Checked then iDaysOfWeek := iDaysOfWeek or 64;

    DaysOfWeek := iDaysOfWeek;

    StartDateChanged := (Trunc(StartDate) <> Trunc(dtStartDate.Date))
                        or (Trunc(spnDaysBetween.Value) <> DaysBetween);



    Periodic := rbPeriod.Checked;

    DaysBetween := spnDaysBetween.Value;


    //Time
    if rbMins.Checked then
    begin
      TimeType := ettFrequency;
      Try
        Frequency := StrToInt(Trim(edMins.Text));
      Except
        Frequency := 60;
      End;
    end
    else
    if rbSpecific.Checked then
    begin
      Time1 := dtSpecific.Time;
      TimeType := ettTimeOneOnly;
    end
    else
    if rbMinsBetween.Checked then
    begin
      Time1 := dtBetweenStart.Time;
      Time2 := dtBetweenEnd.Time;
      TimeType := ettFrequencyInPeriod;
      Try
        Frequency := StrToInt(Trim(edMinsBetween.Text));
      Except
        Frequency := 60;
      End;

    end;

//    RunOnStartup := chkRunOnStartup.Checked;
    //PR: 05/04/2011 ABSEXCH-2878
    //Only reset next run date if we've added this elert or we've changed the start date
    ResetNextRunDate := StartDateChanged or DateTimeChanged or NeedNewNextRun;


    //event details
    if rbEvent.Checked then
    begin
      WindowID := StrToInt(edtWindowID.Text);
      HandlerID := StrToInt(edtHandlerID.Text);
      EventIndex := cbEventDesc.ItemIndex;
    end;


    //Report name
//    if lblReport.Caption = 'None' then
    if Trim(ThisReport.RepName) = '' then
    begin
      ReportName := '';
      NewReportName := '';
    end
    else
    begin
      if rbNewRep.Checked then
        NewReportName := ThisReport.RepName
      else
        ReportName := ThisReport.RepName;
    end;

    DBF := chkRepAsCSV.Visible and chkRepAsCSV.Checked and (cbCSVType.ItemIndex = 1);
    if not DBF then
      ExRepFormat := cbCSVType.ItemIndex;

    if rbNeverExpire.Checked then
      Expiration := eetNever
    else
    if rbDateExpire.Checked then
    begin
      Expiration := eetDate;
      ExpirationDate := dtDateExpire.Date;
    end
    else
    if rbExpireOneRun.Checked then
      Expiration := eetAfterTriggers;

    DeleteAfterExpiry := chkDeleteAfterExpiry.Checked;

    TriggerCount := spnTriggerCount.Value;

    Active := chkActive.Checked;
    Status := esIdle;

    EmailReport := (chkAttachReport.Enabled and chkAttachReport.Checked);


    StartDate := Trunc(dtStartDate.Date);

    NextRunDue := GetNextRunDue(False, not ResetNextRunDate, StartDateChanged);



{    ActionEmail  := chkEmail.checked;
    ActionSMS    := chkSMS.Checked;
    ActionReport := rbReport.Checked;}

    FTPSite := edtFTPSite.Text;
    FTPUserName := edtFTPUser.Text;
    FTPPassword := edtFTPPassword.Text;
    UploadDir := edtFTPDir.Text;
    FTPPort := StrToInt(edtFTPPort.Text);
    FTPTimeOut := StrToInt(edtTimeout.Text);

    CSVFilename := edtCSVName.Text;

    ReportFolder := System.Copy(lblCSVFolder.Caption, 13, Length(lblCSVFolder.Caption));


    if ActionEmail then
    begin
      SaveAddresses;
      SaveEmailOutput;
    end;

    if ActionSMS then
    begin
      SaveSMSNos;
      SaveSMSOutput;
    end;

    if ActionReport then
    begin
      SaveReportParams;
      SaveRepEmailOutput;
      SaveRepEmailAddresses;
      SaveRepFaxNos;
      SaveFaxOptions;
    end;

    SaveRemoteAddresses;

    TermChar := '!';

    Expired := False;

    WordWrap := chkWordWrap.Checked;

    if IsEdit {and not NewName} then
      Res := Save
    else
      Res := Add;

    if Res <> 0 then
      ShowMessage('Unable to add record.  Error: ' + IntToStr(Res))
    else
    begin
{      if chkMarkExisting.Checked then
        AddExistingRecs(FToolkit);}
    end;

  end;//with

  if IsEdit and NewName then
  begin
    ThisElert.Copy(ChangedName, ThisElert.UserID, True);
//    ThisElert.ElertName := OldName;
    Res := ThisElert.GetEqual(OldName);
    if Res = 0 then
      ThisElert.Delete;
  end;

end;


procedure TfrmElWizard.cbFrequencyChange(Sender: TObject);
begin
  cbFrequency.ItemIndex := cbFrequency.Items.IndexOf(cbFrequency.Text);
end;

procedure TfrmElWizard.btnContactsClick(Sender: TObject);
var
  LV : TListView;
begin
  LV := SetListView;
  with TfrmEmailAddForm.Create(nil) do
  Try
    if LV.Items.Count = 0 then
      cbType.ItemIndex := 0
    else
      cbType.ItemIndex := 1;
    LoadContacts;
    ShowModal;
    if ModalResult = mrOK then
    begin
      with LV.Items.Add do
      begin
        Caption := cbType.Text;
        SubItems.Add(ContactName);
        SubItems.Add(ContactAddress);
      end;
    end;
  Finally
    Free;
  End;
  LV.Selected := LV.Items[LV.Items.Count - 1];
  ActiveControl := LV;
end;

procedure TfrmElWizard.btnSMSContactsClick(Sender: TObject);
var
  LV : TListView;
  IsSMS : Boolean;
begin
  LV := SetListView;
  IsSMS := LV = lvSMSRecip;
  with TfrmSMSAdd.Create(nil) do
  Try
    LoadContacts(IsSMS);
    ShowModal;
    if ModalResult = mrOK then
    begin
      //do something
      with LV.Items.Add do
      begin
        Caption := ContactName;
{        SubItems.Add(ContactCountry);
        SubItems.Add(ContactCode);}
        SubItems.Add(ContactNumber);
      end;
    end;
  Finally
    Free;
  End;
  LV.Selected := LV.Items[LV.Items.Count - 1];
  ActiveControl := LV;
end;

procedure TfrmElWizard.FillReportTree(const EekGrp : ShortString; Node : TTreeNode);
var
  Res : SmallInt;
  KeyS, KeyChk : String[255];
  i : integer;
  ThisGroup : ShortString;
  LKeyPos : longint;
  ThisNode : TTreeNode;
  RepRec : ^TReportNameRec;
begin
  i := GetPosKey;
  KeyChk:=FullRepKey_RGK (ReportGenCode, RepGroupCode, EekGrp);
  KeyS:=KeyChk;
  ThisGroup := EekGrp;
  Res := Find_Rec(B_GetGEq,F[RepGenF],RepGenF,RecPtr[RepGenF]^,RGK,KeyS);

  while (Res = 0) and (Trim(RepGenRecs^.ReportHed.RepGroup) = ThisGroup) do
  begin
    if (RepGenRecs^.RecPFix = 'R') and (RepGenRecs^.SubType = 'H') then
    begin

      ThisNode := tvReports.Items.AddChild(Node, RepGenRecs^.ReportHed.RepDesc);
      GetMem(RepRec, SizeOf(RepRec^));
      RepRec.RepGroup := RepGenRecs^.ReportHed.RepGroup;
      RepRec.RepName := RepGenRecs^.ReportHed.RepName;
      RepRec.NoOfParams := RepGenRecs^.ReportHed.ILineCount - 1;
      RepRec.GrpPWord := RepGenRecs^.ReportHed.PWord;
      ThisNode.Data := RepRec;

      if RepGenRecs^.ReportHed.RepType = 'H' then
      begin
        ThisNode.ImageIndex := 2;
        ThisNode.SelectedIndex := 2;
        Presrv_BTPos(RepGenF,i, F[RepGenF], LKeyPos, False, False);
        FillReportTree(Trim(RepGenRecs^.ReportHed.RepName), ThisNode);
        Presrv_BTPos(RepGenF,i, F[RepGenF], LKeyPos, True, False);
      end
      else
      begin
        ThisNode.ImageIndex := 4;
        ThisNode.SelectedIndex := 4;
      end;
    end;

    Res := Find_Rec(B_GetNext,F[RepGenF],RepGenF,RecPtr[RepGenF]^,RGK,KeyS);
  end; //While
end;

procedure TfrmElWizard.FillNewReportTree(const ParentID : ShortString; Node : TTreeNode);
var
  Res, Res1 : SmallInt;
  i : integer;
  ThisGroup : ShortString;
  FilePos : longint;
  ThisNode : TTreeNode;
  RepRec : ^TReportNameRec;
  LocalParentID : ShortString;
  NodeWasNil : Boolean;
begin
  if Node = nil then
  begin
    oReportTree := GetReportTree as IReportTree_Interface;
    oReportTree.CompanyDataSetPath := SetDrive;
    oReportTree.ReportTreeSecurity := ThisElert.UserID;

    Res := oReportTree.GetFirstReport(TreeNodeType, TreeNodeName, TreeNodeDesc,
                    TreeNodeParent, TreeNodeChild, FileName, LastRun, AllowEdit);
    Node := tvReports.Items.AddChild(nil, 'Reports');
    NodeWasNil := True;
  end
  else
  begin
    Res := 0;
    NodeWasNil := False;
  end;


  if Res = 0 then
  begin
    LocalParentID := ParentID;
    AllowEdit := False;
    Res := oReportTree.GetGEqual(LocalParentID, TreeNodeType, TreeNodeName, TreeNodeDesc,
                        TreeNodeParent, TreeNodeChild, FileName, LastRun, AllowEdit);
    while (Res = 0) and (Trim(LocalParentID) = Trim(TreeNodeParent)) do
    begin
        if Trim(TreeNodeDesc) <> '' then
          ThisNode := tvReports.Items.AddChild(Node,TreeNodeName + ' - ' + TreeNodeDesc)
        else
          ThisNode := tvReports.Items.AddChild(Node,TreeNodeName);

        GetMem(RepRec, SizeOf(RepRec^));
        RepRec.RepName := TreeNodeName;
        RepRec.NewRepFileName := FileName;

        ThisNode.Data := RepRec;

        if TreeNodeType = 'H' then
        begin
          ThisNode.ImageIndex := 2;
          ThisNode.SelectedIndex := 2;
          Res1 := oReportTree.SavePosition(FilePos);
          FillNewReportTree(TreeNodeChild, ThisNode);
          Res1 := oReportTree.RestorePosition(FilePos);
        end
        else
        begin
          ThisNode.ImageIndex := 4;
          ThisNode.SelectedIndex := 4;
        end;

        Res := oReportTree.GetNext(TreeNodeType, TreeNodeName, TreeNodeDesc,
                        TreeNodeParent, TreeNodeChild, FileName, LastRun, AllowEdit);
    end;

    if NodeWasNil then
    begin
      oReportTree := nil;
      Node.Expand(False);
    end;
  end;
end;


function TfrmElWizard.SelectDBField : ShortString;
begin
//  Result := '{DB Field}';
  with Form_SelectField2 do
  begin
    Try
{      ShortCode := 'AC';
      PageControl1Change(nil);}
      SetShortCode (SC, 1);
      ShowModal;
      if OK then
        Result := 'DBF[' + Trim(ShortCode) + ']'
      else
        Result := '';
    Finally
    End;
  end;
end;

procedure TfrmElWizard.PutDBField(AMemo : TMemo);
var
  s : ShortString;
  p : PChar;
begin
  s := SelectDBField;
  if s <> '' then
  begin
    p := StrAlloc(Length(s) + 1);
    FillChar(p^, Length(s) + 1, #0);
    StrPCopy(p, s);

    AMemo.SetSelTextBuf(p);
  end;
  ActiveControl := AMemo;
end;

procedure TfrmElWizard.tvReportsChange(Sender: TObject; Node: TTreeNode);
begin
  if Node <> nil then
    if not Node.HasChildren then
    begin
     FillChar(ThisReport, SizeOf(ThisReport), #0);
     lblReport.Caption := Node.Text;
     Move(Node.Data^, ThisReport, SizeOf(ThisReport));
     btnNext.Enabled := True;
     if rbNewRep.Checked then
       ThisElert.NewReportName := ThisReport.RepName
     else
       ThisElert.ReportName := ThisReport.RepName;
    end
    else
    begin
      lblReport.Caption := 'None';
      btnNext.Enabled := False;
    end;


end;

procedure TfrmElWizard.SetDataFileEdits(Allow : Boolean);
begin
{.$IFDEF EN550CIS}
  cbIndex.Visible := Allow and not JC;
  cbIndex.Enabled := Allow and not JC;
  lblIndex.Visible := cbIndex.Visible;
{.$ELSE}
//  cbIndex.Enabled := Allow;
{.$ENDIF}
  cbRangeStart.Enabled := Allow;
  cbRangeEnd.Enabled := Allow;
  pnlIdx.Visible := Allow;
end;


procedure TfrmElWizard.cbDatafileChange(Sender: TObject);
var
  i : integer;
  p : longint;
begin
{$IFDEF EN550CIS}
  JC := Pos('Employees', cbDataFile.Text) = 1;
{$ELSE}
  JC := False;
{$ENDIF}
  bvContEmploy.Visible := JC;
  lblContEmploy.Visible := JC;
  cbIndex.Items.Clear;
  cbIndex.Text := '';
  if (Pos('Document', cbDataFile.Text) = 1) or JC then
  begin
    SetDataFileEdits(True);
    if Pos('Head', cbDataFile.Text) > 0 then
    begin
      for i := 0 to 14 do
      begin
        if i = 0 then
          p := 0
        else
          p := FastNDXOrdL^[3,i];
        cbIndex.Items.AddObject(FastNDXHedL^[3, i], TObject(i));
      end;
    end
    else if Pos('Details', cbDataFile.Text) > 0 then
    begin
      for i := 0 to 18 do
      begin
        if i = 0 then
          p := 0
        else
          p := FastNDXOrdL^[4,i];
        cbIndex.Items.Addobject(FastNDXHedL^[4, i], TObject(i));
      end;
    end;
    cbIndex.ItemIndex := 0;
  end
  else
    SetDataFileEdits(False);

  cbIndexChange(Self);
end;

procedure TfrmElWizard.cbEventDescChange(Sender: TObject);
var
  i : integer;
begin
  i := cbEventDesc.ItemIndex + 1;
  edtWindowID.Text := IntToStr(Events[i].evWinID);
  edtHandlerID.Text := IntToStr(Events[i].evHandID);
end;

procedure TfrmElWizard.rbDateExpireClick(Sender: TObject);
begin
  dtDateExpire.Enabled := rbDateExpire.Checked;
  spnTriggerCount.Enabled := rbExpireOneRun.Checked;
  if rbNeverExpire.Checked then
  begin
    chkDeleteAfterExpiry.Checked := False;
    chkDeleteAfterExpiry.Enabled := False;
  end
  else
    chkDeleteAfterExpiry.Enabled := True;
end;

procedure TfrmElWizard.rbMinsClick(Sender: TObject);
begin
  edMins.Enabled := rbMins.Checked;
  edMinsBetween.Enabled := rbMinsBetween.Checked;
  dtBetweenStart.Enabled := rbMinsBetween.Checked;
  dtBetweenEnd.Enabled := rbMinsBetween.Checked;
  dtSpecific.Enabled := rbSpecific.Checked;
end;

procedure TfrmElWizard.btnEmailAddClick(Sender: TObject);
var
  LV : TListView;
  IsRemote : Boolean;

  function GetNextRecipNo : SmallInt;
  var
    i, m, n : integer;
  begin
    if LV.Items.Count = 0 then
      Result := 1
    else
    begin
      m := 0;
      for i := 0 to LV.Items.Count - 1 do
      begin
        Try
          n := StrToInt(LV.Items[i].SubItems[2]);
        Except
          n := 0;
        End;

        if n > m then
          m := n;
      end;
      Result := m + 1;
    end;
  end;
  
begin
  LV := SetListView;
  IsRemote := LV = lvRemoteAdd;
  with TfrmEmailEdit.Create(nil) do
  Try
    BtnDBF.Visible := rbMultEmail.Checked and not IsRemote;
    if IsRemote then
    begin
      cbEmType.Text := 'From';
      cbEmType.Enabled := False;
      Caption := 'Email Address Details';
      Label1.Visible := False;
      Label17.Caption := 'Name (for information only)';
    end
    else
      cbEmType.ItemIndex := 0;
    ShowModal;
    if ModalResult = mrOK then
    begin
      with LV.Items.Add do
      begin
        if IsRemote then
          Caption := ''
        else
          Caption := cbEmType.Text;
        SubItems.Add(edtEmailName.Text);
        SubItems.Add(edtEmailAddress.Text);
        if IsRemote then
          SubItems.Add(IntToStr(GetNextRecipNo));
      end;
    end;
  Finally
    Free;
  End;
  LV.Selected := LV.Items[LV.Items.Count - 1];
  ActiveControl := LV;
end;

function TfrmElWizard.RemoveSpaces(const s : ShortString) : ShortString;
var
  i : integer;
begin
  i := 1;
  Result := s;
  while i < Length(Result) do
    if Result[i] = ' ' then
      Delete(Result, i, 1)
    else
      inc(i);
end;



procedure TfrmElWizard.btnSMSAddClick(Sender: TObject);
var
  LV : TListView;
begin
  LV := SetListView;
  with TfrmEditSMS.Create(nil) do
  Try
    btnDBField.Visible := LV = lvSMSRecip;
    PutCaption(FDlgCaption + ' Recipient Details');
    ShowModal;
    if ModalResult = mrOK then
    with LV.Items.Add do
    begin
      Caption := edtSMSName.Text;
{      SubItems.Add(RemoveSpaces(edtSMSCountry.Text));
      SubItems.Add(RemoveSpaces(edtSMSCode.Text));}
      SubItems.Add(RemoveSpaces(edtSMSNumber.Text));
    end;
  Finally
    Free;
  End;
  LV.Selected := LV.Items[LV.Items.Count - 1];
  ActiveControl := LV;
end;

procedure TfrmElWizard.chkEmailClick(Sender: TObject);
begin
  if Notebook1.PageIndex = pgTransmission then
  begin
    btnNext.Enabled := chkEmail.Checked or
                       chkSMS.Checked;

    gbEmailType.Visible := chkEmail.Checked and not IsReport and rbTimer.Checked;

  end;

end;

procedure TfrmElWizard.lvEmailRecipInsert(Sender: TObject;
  Item: TListItem);
begin
  if Sender is TListView then
    btnNext.Enabled := TListView(Sender).Items.Count > 0;
end;

procedure TfrmElWizard.memEmailMsgChange(Sender: TObject);
begin
  btnNext.Enabled := (edtEmSubject.Text <> '') or
                     (memEmailHeader.Lines.Count > 0) or
                     (memEmailLines.Lines.Count > 0) or
                     (memEmailTrailer.Lines.Count > 0) or IsReport;{ or
                     (chkReport.Enabled and chkReport.Checked)};

end;

procedure TfrmElWizard.lvSMSRecipInsert(Sender: TObject; Item: TListItem);
var
  LV : TListView;
begin
  LV := SetListView;
  btnNext.Enabled := LV.Items.Count > 0;
end;

procedure TfrmElWizard.memSMSMsgChange(Sender: TObject);
var
  Len, i, j : SmallInt;
begin
  btnNext.Enabled := memSMSMsg.Lines.Count > 0;
  LblCharsRemaining.Caption := IntToSTr(160 - CheckMsgLength(memSMSMsg.Lines.Text));
end;

procedure TfrmElWizard.rbFreqRepeatClick(Sender: TObject);
begin
  edtDays.Enabled := rbFreqRepeat.Checked;
  cbFrequency.Enabled := rbFreqRepeat.Checked;
  cbFrequencyChange(Self);
  chkMarkExisting.Visible := rbFreqNever.Checked and not IsReport and not rbTimer.Checked;
end;

procedure TfrmElWizard.ReportParams(const ReportName : ShortString);
var
  Res : SmallInt;
  KeyS, KeyChk : String[255];
  i : integer;
  ThisGroup : ShortString;
  LKeyPos : longint;
  ThisNode : TTreeNode;
  RepRec : ^TReportNameRec;
  s1 : string;
begin
  if not ParamsChanged and {(chkReport.Checked or chkCSV.Checked)}IsReport then
  with lvParams do
  begin
    Items.Clear;
    KeyChk:=FullRepKey_RGK(ReportGenCode, 'L', ReportName);
    KeyS:=KeyChk;

    Res := Find_Rec(B_GetGEq,F[RepGenF],RepGenF,RecPtr[RepGenF]^,RGK,KeyS);
    i := 1;
    while (Res = 0) and (RepGenRecs^.ReportDet.RepName = ReportName) do
    begin
      if (RepGenRecs^.RecPFix = 'R') and (RepGenRecs^.SubType = 'L')  and
         (RepGenRecs^.ReportDet.VarType = 'I') then
      begin
        with Items.Add do
        begin
          Caption := IntToStr(i);
          SubItems.Add(RepGenRecs^.ReportDet.RepLDesc);
          Case RepGenRecs^.ReportDet.RepLIType of
            1  : begin
                    SubItems.Add(POutDate(RepGenRecs^.ReportDet.DRange[1]));
                    SubItems.Add(POutDate(RepGenRecs^.ReportDet.DRange[2]));
                 end;

            2  : begin
                    SubItems.Add(IntToStr(RepGenRecs^.ReportDet.PrRange[1, 1]) + '/' +
                                     IntToStr(RepGenRecs^.ReportDet.PrRange[1, 2] + 1900));
                    SubItems.Add(IntToStr(RepGenRecs^.ReportDet.PrRange[2, 1]) + '/' +
                                     IntToStr(RepGenRecs^.ReportDet.PrRange[2, 2] + 1900));
                 end;
            3  : begin
                    SubItems.Add(Format('%f', [RepGenRecs^.ReportDet.VRange[1]]));
                    SubItems.Add(Format('%f', [RepGenRecs^.ReportDet.VRange[2]]));
                 end;

            4, 6, 7  : begin
                         SubItems.Add(RepGenRecs^.ReportDet.AscStr[1]);
                         SubItems.Add(RepGenRecs^.ReportDet.AscStr[2]);
                       end;
            5  : begin
                   //Currency
                   if FCurrencyList.Count = 0 then
                   begin
                     FToolkit.OpenToolkit;
                     for i := 0 to 89 do
                     begin
                      s1 := Trim(FToolkit.SystemSetup.ssCurrency[i].scSymbol);
                      if (Length(s1) > 0) and (s1[1] = #156) then
                        s1 := '£';
                      FCurrencyList.Add( s1 +
                                      ' - ' +  Trim(FToolkit.SystemSetup.ssCurrency[i].scDesc));
                     end;
                     FToolkit.CloseToolkit;
                   end;

                   SubItems.Add(FCurrencyList[RepGenRecs^.ReportDet.CrRange[1]]);
                   SubItems.Add(FCurrencyList[RepGenRecs^.ReportDet.CrRange[2]]);
                 end;
            else
            begin
              SubItems.Add(RepGenRecs^.ReportDet.AscStr[1]);
              SubItems.Add(RepGenRecs^.ReportDet.AscStr[2]);
            end;
          end;//case
          SubItems.Add(IntToStr(RepGenRecs^.ReportDet.RepLIType));

        end;

      end;
      inc(i);
      Res := Find_Rec(B_GetNext,F[RepGenF],RepGenF,RecPtr[RepGenF]^,RGK,KeyS);
    end;
    if IsEdit and (Trim(ThisElert.ReportName) = Trim(ThisReport.RepName)) then
      LoadReportParams;
  end;

end;



procedure TfrmElWizard.SetElert(const AnElert : ShortString);
begin
  if Assigned(ThisElert) then
    ThisElert.ElertName := AnElert;
end;


procedure TfrmElWizard.edtNameChange(Sender: TObject);
begin
  btnNext.Enabled := Trim(edtName.Text) <> '';
end;

procedure TfrmElWizard.SetActive(WhichPage : Byte);
begin
  Case WhichPage of
    pgDescription    : ActiveControl := edtName;
    pgDataFile       : ActiveControl := cbDataFile;
    pgConditions     : ActiveControl := btnLogicEdit;
    pgEmailAdd       : ActiveControl := {btnEmailAdd}lvEmailRecip;
    pgEmailMsg       : ActiveControl := edtEmSubject;
    pgSMSNos         : ActiveControl := {btnSMSAdd}lvSMSRecip;
    pgSMSMsg         : ActiveControl := memSMSMsg;
    pgReport         : ActiveControl := tvReports;
    pgReportParams   : if lvParams.Items.count > 0 then ActiveControl := lvParams;
    pgEvent          : ActiveControl := cbEventDesc;
    pgRepEmailAdd    : ActiveControl := lvRepEmailAdd;
    pgRepEmailMsg    : ActiveControl := edtRepEmailSub;
    pgRepFaxAdd      : ActiveControl := lvRepFaxAdd;
    pgRepFaxOpts     : ActiveControl := edtRepFaxName;
    pgNotify         : ActiveControl := spNotifyHours;
  end;
end;

procedure TfrmElWizard.SetUserID(const AUserID : ShortString);
begin
  if Assigned(ThisElert) then
    ThisElert.UserID := AUserID;
end;


procedure TfrmElWizard.ShowReportSelection;
var
  i : integer;
  s : ShortString;
  RepName : ShortString;
begin
  for i := 1 to tvReports.Items.Count - 1 do
  begin
    s := PReportNameRec(tvReports.Items[i].Data)^.RepName;

    if rbNewRep.Checked then
      RepName := ThisElert.NewReportName
    else
      RepName := ThisElert.ReportName;

    if Trim(s) = Trim(RepName) then
    begin
      Move(tvReports.Items[i].Data^, ThisReport, SizeOf(ThisReport));
      lblReport.Caption := tvReports.Items[i].Text;
      tvReports.Selected := tvReports.Items[i];
      tvReports.Items[i].MakeVisible;
      if ThisReport.NoOfParams > 0 then
        LoadReportParams;
      Break;
    end;

  end;
end;


procedure TfrmElWizard.btnSaveClick(Sender: TObject);
begin
  SaveForm;
end;

procedure TfrmElWizard.SetIsEdit(Value : Boolean);
begin
  btnSave.Visible := Value;
  FIsEdit := Value;
end;

procedure TfrmElWizard.SaveAddresses;
var
  Res, i : SmallInt;
begin
  DeleteAddresses;
  ThisAddress.Index := ellIdxLineType;
  for i := 0 to lvEmailRecip.Items.Count - 1 do
  begin
    with ThisAddress do
    begin
      UserID := ThisElert.UserID;
      ElertName := ThisElert.ElertName;
      RecipientType := EmailRecipType(lvEmailRecip.Items[i].Caption);
      Name := lvEmailRecip.Items[i].SubItems[0];
      Address := lvEmailRecip.Items[i].SubItems[1];
      Res := Add;

      if Res <> 0 then
        raise Exception.Create('Unable to add address: ' + #10 +
                               Name + ';' + Address + #10 +
                               'Error: ' + IntToStr(Res));
    end;
  end;
  ThisAddress.Index := ellIdxOutputType;
end;

procedure TfrmElWizard.SaveRemoteAddresses;
var
  Res, i : SmallInt;
begin
  DeleteRemoteAddresses;
  ThisAddress.Index := ellIdxLineType;
  for i := 0 to lvRemoteAdd.Items.Count - 1 do
  begin
    with ThisRemoteAddress do
    begin
      UserID := ThisElert.UserID;
      ElertName := ThisElert.ElertName;
      RecipientType := EmailRecipType(lvRemoteAdd.Items[i].Caption);
      Name := lvRemoteAdd.Items[i].SubItems[0];
      Address := lvRemoteAdd.Items[i].SubItems[1];
      Try
        RecipNo := StrToInt(lvRemoteAdd.Items[i].SubItems[2]);
      Except
        RecipNo := 0;
      End;
      Res := Add;

      if Res <> 0 then
        raise Exception.Create('Unable to add address: ' + #10 +
                               Name + ';' + Address + #10 +
                               'Error: ' + IntToStr(Res));
    end;
  end;
  ThisRemoteAddress.Index := ellIdxOutputType;
end;


procedure TfrmElWizard.LoadAddresses;
var
  Res : SmallInt;
begin
  lvEmailRecip.Items.Clear;
  with ThisAddress do
  begin
    Index := ellIdxLineType;
    UserID := ThisElert.UserID;
    ElertName := ThisElert.ElertName;

    Res := GetFirst;

    while Res = 0 do
    begin
      with  lvEmailRecip.Items.Add do
      begin
        Caption := EmailTypes[Ord(RecipientType)];
        SubItems.Add(ThisAddress.Name);
        SubItems.Add(Address);
      end;

      Res := GetNext;
    end;
    Index := ellIdxOutputType;
  end;

end;

procedure TfrmElWizard.LoadRemoteAddresses;
var
  Res : SmallInt;
begin
  lvRemoteAdd.Items.Clear;
  with ThisRemoteAddress do
  begin
    Index := ellIdxLineType;
    UserID := ThisElert.UserID;
    ElertName := ThisElert.ElertName;

    Res := GetFirst;

    while Res = 0 do
    begin
      with  lvRemoteAdd.Items.Add do
      begin
        Caption := '';
        SubItems.Add(ThisRemoteAddress.Name);
        SubItems.Add(Address);
        SubItems.Add(IntToStr(RecipNo));
      end;

      Res := GetNext;
    end;
    Index := ellIdxOutputType;
  end;

end;


procedure TfrmElWizard.DeleteAddresses;
var
  Res : SmallInt;
begin
  with ThisAddress do
  begin
    UserID := ThisElert.UserID;
    ElertName := ThisElert.ElertName;

    Res := GetFirst;

    while (Res = 0) do
    begin

      Delete;

      Res := GetNext;
    end;
  end;
end;

procedure TfrmElWizard.DeleteRemoteAddresses;
var
  Res : SmallInt;
begin
  with ThisRemoteAddress do
  begin
    UserID := ThisElert.UserID;
    ElertName := ThisElert.ElertName;

    Res := GetFirst;

    while (Res = 0) do
    begin

      Delete;

      Res := GetNext;
    end;
  end;
end;


procedure TfrmElWizard.SaveSMSNos;
var
  Res, i : SmallInt;
begin
  DeleteSMSNos;
  for i := 0 to lvSMSRecip.Items.Count - 1 do
  begin
    with ThisSMS do
    begin
      UserID := ThisElert.UserID;
      ElertName := ThisElert.ElertName;
      Name := lvSMSRecip.Items[i].Caption;
{      Country := lvSMSRecip.Items[i].SubItems[0];
      Code := lvSMSRecip.Items[i].SubItems[1];}
      Number := lvSMSRecip.Items[i].SubItems[0];
      if Pos('DBF[', Number) = 1 then
        ThisElert.SingleSMS := False;
      Res := Add;

      if Res <> 0 then
        raise Exception.Create('Unable to add SMS Number: ' + #10 +
                               Name + ' - ' + FullNumber + #10 +
                               'Error: ' + IntToStr(Res));
    end;
  end;
end;

procedure TfrmElWizard.LoadSMSNos;
var
  Res : SmallInt;
begin
  lvSMSRecip.Items.Clear;
  with ThisSMS do
  begin
    UserID := ThisElert.UserID;
    ElertName := ThisElert.ElertName;

    Res := GetFirst;

    while Res = 0 do
    begin
      with  lvSMSRecip.Items.Add do
      begin
        Caption := ThisSMS.Name;
{        SubItems.Add(Country);
        SubItems.Add(Code);  }
        SubItems.Add(Number);
      end;

      Res := GetNext;
    end;
  end;
end;

procedure TfrmElWizard.DeleteSMSNos;
var
  Res : SmallInt;
begin
  with ThisSMS do
  begin
    UserID := ThisElert.UserID;
    ElertName := ThisElert.ElertName;

    Res := GetFirst;

    while (Res = 0)  do
    begin

      Delete;

      Res := GetNext;
    end;
  end;
end;


procedure TfrmElWizard.SaveSMSOutput;
var
  Res : SmallInt;
  i   : integer;
begin
  DeleteOutputs(eolSMS);
  for i := 0 to memSMSMsg.Lines.Count - 1 do
  begin
    with ThisOutput do
    begin
      UserID := ThisElert.UserID;
      ElertName := ThisElert.ElertName;
      LineNo := i + 1;
      Line1 := memSMSMsg.Lines[i];
      OutputType := eolSMS;

      Res := Add;
    end;
  end;
end;


procedure TfrmElWizard.LoadSMSOutput;
var
  Res : SmallInt;
begin
  memSMSMsg.Lines.Clear;
  with ThisOutput do
  begin
    UserID := ThisElert.UserID;
    ElertName := ThisElert.ElertName;

    OutputType := eolSMS;

    Res := GetFirst;

    while (Res = 0)  do
    begin

      if OutputType = eolSMS then
        memSMSMsg.Lines.Add(Line1);

      Res := GetNext;
    end;
  end;
end;



procedure TfrmElWizard.SaveEmailOutput;
var
  Res : SmallInt;
  i   : integer;
begin
  DeleteOutputs(eolEmailSubject);
  DeleteOutputs(eolEmailHeader);
  DeleteOutputs(eolEmailLine);
  DeleteOutputs(eolEmailTrailer);
  if edtEmSubject.Text <> '' then
  begin
    with ThisOutput do
    begin
      UserID := ThisElert.UserID;
      ElertName := ThisElert.ElertName;
      LineNo := 1;
      Line1 := edtEmSubject.Text;
      Line2 := '';
      OutputType := eolEmailSubject;

      Res := Add;
    end;
  end;

  for i := 0 to memEmailHeader.Lines.Count - 1 do
  begin
    with ThisOutput do
    begin
      UserID := ThisElert.UserID;
      ElertName := ThisElert.ElertName;
      LineNo := i + 1;
      Line1 := memEmailHeader.Lines[i];
      Line2 := '';
      OutputType := eolEmailHeader;

      Res := Add;
    end;
  end;

  for i := 0 to memEmailLines.Lines.Count - 1 do
  begin
    with ThisOutput do
    begin
      UserID := ThisElert.UserID;
      ElertName := ThisElert.ElertName;
      LineNo := i + 1;
      Line1 := memEmailLines.Lines[i];
      Line2 := '';
      OutputType := eolEmailLine;

      Res := Add;
    end;
  end;

  for i := 0 to memEmailTrailer.Lines.Count - 1 do
  begin
    with ThisOutput do
    begin
      UserID := ThisElert.UserID;
      ElertName := ThisElert.ElertName;
      LineNo := i + 1;
      Line1 := memEmailTrailer.Lines[i];
      Line2 := '';
      OutputType := eolEmailTrailer;

      Res := Add;
    end;
  end;

end;

procedure TfrmElWizard.LoadEmail(EType : TOutputLineType; Mem : TMemo);
var
  Res : SmallInt;
begin
  Mem.Lines.Clear;
  with ThisOutput do
  begin
    UserID := ThisElert.UserID;
    ElertName := ThisElert.ElertName;

    OutputType := EType;

    Res := GetFirst;

    while (Res = 0) and (OutputType = EType) do
    begin
      Mem.Lines.Add(Line1);

      Res := GetNext;
    end;
  end;
end;



procedure TfrmElWizard.LoadEmailOutput;
var
  Res : SmallInt;


begin
  with ThisOutput do
  begin
    UserID := ThisElert.UserID;
    ElertName := ThisElert.ElertName;

    OutputType := eolEmailSubject;

    Res := GetFirst;

    if Res = 0 then
      if OutputType = eolEmailSubject then
      edtEmSubject.Text := Line1;

    LoadEmail(eolEmailHeader, memEmailHeader);
    LoadEmail(eolEmailLine, memEmailLines);
    LoadEmail(eolEmailTrailer, memEmailTrailer);

  end;
end;

procedure TfrmElWizard.DeleteOutputs(Which : TOutputLineType);
var
  Res : SmallInt;
begin
  with ThisOutput do
  begin
    UserID := ThisElert.UserID;
    ElertName := ThisElert.ElertName;
    OutputType := Which;
    Res := GetFirst;

    while (Res = 0) and (OutputType = Which) do
    begin

      if OutputType = Which then
        Delete;

      Res := GetNext;
    end;
    MsgInstance := 0;
  end;
end;


procedure TfrmElWizard.LoadReportParams;
var
  Res, i : SmallInt;
begin
  with ThisOutput do
  begin
    UserID := ThisElert.UserID;
    ElertName := ThisElert.ElertName;

    OutputType := eolParams;

    i := 0;

    Res := GetFirst;


    while (Res = 0)  do
    begin

      if OutputType = eolParams then
      begin
        if i < lvParams.Items.Count then
        begin
          lvParams.Items[i].SubItems[1] := Param2Text(Line1, OffStart, EntParamType);
          lvParams.Items[i].SubItems[2] := Param2Text(Line2, OffEnd, EntParamType);
        end;

        inc(i);
      end;
      Res := GetNext;

    end;
  end;
end;

procedure TfrmElWizard.SaveReportParams;
var
  Res : SmallInt;
  i   : integer;
  s1, s2 : ShortString;
  o1, o2 : SmallInt;
begin
  DeleteOutputs(eolParams);
  for i := 0 to lvParams.Items.Count - 1 do
  begin
    with ThisOutput do
    begin
      UserID := ThisElert.UserID;
      ElertName := ThisElert.ElertName;
      LineNo := i;
      s1 := lvParams.Items[i].SubItems[1];
      s2 := lvParams.Items[i].SubItems[2];
      EntParamType := StrToInt(lvParams.Items[i].SubItems[3]);
      Text2Param(s1, o1, EntParamType, True);
      Text2Param(s2, o2, EntParamType, True);
      Line1 := s1;
      Line2 := s2;
      OffStart := o1;
      OffEnd := o2;
      OutputType := eolParams;
      if lvParams.Items[i].SubItems.Count > 4 then
        RFName := lvParams.Items[i].SubItems[4];

      Res := Add;
    end;
  end;
end;




procedure TfrmElWizard.btnEmailInsertDbClick(Sender: TObject);
var
  TempMemo : TMemo;
begin
  if InEmailSubject then
  begin
   Try
    TempMemo := TMemo.Create(Self);
    TempMemo.Parent := Self;
    TempMemo.Text := edtEmSubject.Text;
    PutDBField(TempMemo);
    edtEmSubject.Text := TempMemo.Text;
   Finally
    TempMemo.Free;
   End;
  end
  else
  Case pgcEmailMsg.ActivePage.Tag of
     tagEmailHeader  : PutDBField(memEmailHeader);
     tagEmailLine   : PutDBField(memEmailLines);
     tagEmailTrailer : PutDBField(memEmailTrailer);
  end; //case
end;

procedure TfrmElWizard.btnSMSInsertDBClick(Sender: TObject);
begin
  PutDBField(memSMSMsg);
end;

procedure TfrmElWizard.SetReportOutputControls;
begin
end;

procedure TfrmElWizard.DataDict(AList : TStrings; Prefix : ShortString);
Const
  FNum    = DictF;
  KeyPath = DIK;
var
  Res : SmallInt;
  KeyS : String[255];
  DataRec  : DataDictRec;
begin
  KeyS := 'DV';
  Res := Find_Rec (B_GetGEq, F[Fnum], Fnum, RecPtr[Fnum]^, Keypath, KeyS);
  while (Res = 0) and (KeyS[1] = 'D') and (KeyS[2] = 'V') and
        (KeyS[3] = Prefix[1]) and (KeyS[4] = Prefix[2]) do
  begin
    With DictRec^, DataVarRec Do
    begin
      AList.Add(VarName + #9 + Trim(VarDesc));
    end;

    Res := Find_Rec (B_GetNext, F[Fnum], Fnum, RecPtr[Fnum]^, Keypath, KeyS);
  end;
end;

procedure TfrmElWizard.GetReportDelivery(AList : TListBox; Edit : Boolean);
var
  i : longint;
  SType, STemp : ShortString;

begin
  with TfrmRepDelivery.create(nil) do
  Try
    if Edit then
    begin
      rgType.ItemIndex := longint(AList.Items.Objects[AList.ItemIndex]);
      edtDelivery.Text := RemoveType(AList.Items[AList.ItemIndex]);
    end
    else
      rgType.ItemIndex := 0;
    ShowModal;
    if ModalResult = mrOK then
    begin
      i := rgType.ItemIndex;
      STemp := AddType(edtDelivery.Text, i);

      if Edit then
      begin
        AList.Items[AList.ItemIndex] := STemp;
        AList.Items.Objects[AList.ItemIndex] := TObject(i);
      end
      else
        AList.Items.AddObject(STemp, TObject(i));
    end;
  Finally
    Free;
  End;
end;

function TfrmElWizard.RemoveType(const s : AnsiString) : AnsiString;
var
  j : integer;
begin
  Result := s;
  j := 1;
  while (j < Length(Result)) and (Result[j] <> ']') do inc(j);
  if j < Length(Result) then
    Delete(Result, 1, j + 1);
end;

function TfrmElWizard.AddType(const s : ShortString; Index : Integer) : AnsiString;
begin
   Case Index of
     0  : Result := 'EMAIL';
     1  : Result := 'URL';
     2  : Result := 'PRINTER';
     3  : Result := 'FILE';
     4  : Result := 'FAX';
   end;
   Result := '[' + Result + '] ' + s;
end;

procedure TfrmElWizard.btnEmAddDeleteClick(Sender: TObject);
var
  L : TListView;
begin
  L := SetListView;
  if DeleteQuery('Email address') then
    DeleteListViewItem(SetListView);
  ActiveControl := L;
end;

procedure TfrmElWizard.SaveConditions;
var
  Res : SmallInt;
  i   : integer;
begin
  DeleteOutputs(eolLogic);
  for i := 0 to memConditions.Lines.Count - 1 do
  begin
    with ThisOutput do
    begin
      UserID := ThisElert.UserID;
      ElertName := ThisElert.ElertName;
      LineNo := i + 1;
      Line1 := memConditions.Lines[i];
      OutputType := eolLogic;

      Res := Add;
    end;
  end;
end;


procedure TfrmElWizard.LoadConditions;
var
  Res : SmallInt;
begin
  memConditions.Lines.Clear;
  with ThisOutput do
  begin
    UserID := ThisElert.UserID;
    ElertName := ThisElert.ElertName;

    OutputType := eolLogic;

    Res := GetFirst;

    while (Res = 0)  do
    begin

      if OutputType = eolLogic then
        memConditions.Lines.Add(Line1);

      Res := GetNext;
    end;
  end;
end;

procedure TfrmElWizard.DeleteListViewItem(WhichOne : TListView);
var
  i : integer;
begin
  if Assigned(WhichOne) and Assigned(WhichOne.selected) then
    with WhichOne, Items do
    begin
      i := IndexOf(Selected);
      Delete(i);
      if i < Count - 1 then
        Selected := Items[i]
      else
        Selected := Items[Count - 1];
      ActiveControl := WhichOne;
    end;

end;


procedure TfrmElWizard.btnSMSDeleteClick(Sender: TObject);
var
  L : TListView;
begin
  L := SetListView;
  if DeleteQuery('Number') then
    DeleteListViewItem(L);
  ActiveControl := L;
end;

procedure TfrmElWizard.btnLogicEditClick(Sender: TObject);
var
  AMemo : TMemo;

begin
  if Sender is TMemo then
  begin
    AMemo := TMemo(Sender);

  end
  else
  begin
    AMemo := memConditions;

  end;

  with TForm_AddFormulaCol.Create(nil) do
  Try
    Memo_Formula.Text := AMemo.Text;
    FileNumber := GetFileNo;
    SetForm(AMemo = memConditions);
    ShowModal;
    if OK then
      AMemo.text := Memo_Formula.Text;
  Finally
    Free;
  End;
end;

procedure TfrmElWizard.cbIndexChange(Sender: TObject);
var
  DType : Byte;
begin
  if cbIndex.ItemIndex = 0 then
    pnlIdx.Height := 62
  else
    pnlIdx.Height := 169;
  spnOffStart.Visible := ((Integer(cbDataFile.Items.Objects[cbDataFile.ItemIndex]) = 3) and (cbIndex.ItemIndex in [12,13])) or
                        ((Integer(cbDataFile.Items.Objects[cbDataFile.ItemIndex])= 4) and (cbIndex.ItemIndex in [17,18])) or JC;
{  spnOffStart.Visible := ((cbDataFile.ItemIndex = 8) and (cbIndex.ItemIndex in [12,13])) or
                        ((cbDataFile.ItemIndex = 7) and (cbIndex.ItemIndex in [17,18])) or JC;}
  spnOffEnd.Visible := spnOffStart.Visible;
  lblOffStart.Visible := spnOffStart.Visible;
  lblOffEnd.Visible := spnOffStart.Visible;


  DType := DataType;

  if DType in [1, 2] then
    AddDropDown(cbRangeStart, DType)
  else
    cbRangeStart.Items.Clear;

  cbRangeEnd.Items := cbRangeStart.Items;
  SetLabel(cbRangeStart, lblOffStart, DType);
  SetLabel(cbRangeEnd, lblOffEnd, DType);
{  if cbRangeStart.Items[0] = 'Today' then
  begin
    lblOffStart.Caption := 'Offset (Days)';
    lblOffEnd.Caption := 'Offset (Days)';
  end
  else
  begin
    lblOffStart.Caption := 'Offset';
    lblOffEnd.Caption := 'Offset';
  end;}
end;

procedure TfrmElWizard.btnSMSNoEditClick(Sender: TObject);
var
  LV : TListView;
begin
  LV := SetListView;
  if Assigned(LV.Selected) then
  with LV.Selected do
  begin
    with TfrmEditSMS.Create(nil) do
    Try
      edtSMSNumber.Text := SubItems[0];
      edtSMSName.Text := LV.Selected.Caption;
      if LV <> lvSMSRecip then
      begin
        btnDBField.Visible := False;
        Caption := 'Fax Recipient Details';
      end;
      ShowModal;
      if ModalResult = mrOK then
      begin
        LV.Selected.Caption := edtSMSName.Text;
        LV.Selected.SubItems[0] := edtSMSNumber.Text;
      end;
    Finally
      Free;
    End;
  end;
  ActiveControl := LV;

end;

procedure TfrmElWizard.btnEmAddEditClick(Sender: TObject);
var
  LV : TListView;
  IsRemote : Boolean;
begin
  LV := SetListView;
  IsRemote := LV = lvRemoteAdd;
  if Assigned(LV.Selected) then
  with TfrmEmailEdit.Create(nil) do
  Try
    edtEmailName.Text := LV.Selected.SubItems[0];
    edtEmailAddress.Text := LV.Selected.SubItems[1];
    BtnDBF.Visible := rbMultEmail.Checked and not IsRemote;

    if IsRemote then
    begin
      cbEmType.Text := 'From';
      cbEmType.Enabled := False;
      Caption := 'Email Address Details';
      Label1.Visible := False;
      Label17.Caption := 'Name (for information only)';
    end
    else
      cbEmType.ItemIndex := cbEmType.Items.IndexOf(LV.Selected.Caption);
    ShowModal;
    if ModalResult = mrOK then
    begin
      with LV.Selected do
      begin
        if IsRemote then
          Caption := ''
        else
          Caption := cbEmType.Text;
        SubItems[0] := edtEmailName.Text;
        SubItems[1] := edtEmailAddress.Text;
      end;
    end;
  Finally
    Free;
  End;
  ActiveControl := LV;
end;

procedure TfrmElWizard.rbDailyClick(Sender: TObject);
begin
  grpPeriod.Visible := Sender = rbPeriod;
  grpDays.Visible := Sender = rbDaily;

end;

procedure TfrmElWizard.SetEmailMsgType;
var
  SingleEmail : Boolean;
begin
  SingleEmail := rbSingleEmail.Checked;
  pgEmailHeader.TabVisible := SingleEmail;
  pgEmailTrailer.TabVisible := SingleEmail;
  pgForm.TabVisible := (not SingleEmail or rbEvent.Checked) and IsTransaction;
  lblEmailLines.Visible := SingleEmail;
  lblEmailMsg.Visible := SingleEmail;

  //PR 24/07/09 Change to ensure that the correct page is made active
  if SingleEmail then
  begin
    pgEmailLines.Caption := 'Lines';
    pgcEmailMsg.ActivePage := pgEmailHeader;
  end
  else
  begin
    pgEmailLines.Caption := 'Message';
    pgcEmailMsg.ActivePage := pgEmailLines;
  end;
end;

function TfrmElWizard.GetFileNo : SmallInt;
begin
  Result := Integer(cbDataFile.Items.Objects[cbDatafile.ItemIndex]);
end;

procedure TfrmElWizard.FocusFirstLine(const lv : TListView);
begin
  if lv.Items.Count > 0 then
    lv.selected := lv.Items[0];
  ActiveControl := lv;
end;

function TfrmElWizard.GetValueType(FNo, IndexNo : SmallInt) : TElertRangeValType;
begin
  Result := evString;
  Case Fno of
    3  :  begin {doc file}
            Case IndexNo of
                9 : Result := evInt;
               12 : Result := evDate;
               13 : Result := evPeriod;
            end; //case
          end;
    4  :  begin  {details file}
            Case IndexNo of
                1 : Result := evInt;
               17 : Result := evDate;
               18 : Result := evPeriod;
            end; //case
          end;
{$IFDEF EN550CIS}
   11  :  Result := evDate;
{$ENDIF}
  end; //case
end;

procedure TfrmElWizard.SetDbPage;
var
  s : ShortString;
  i : integer;
begin
  if rbTimer.Checked then
  begin
    i := Integer(cbDataFile.Items.Objects[cbDataFile.ItemIndex]);
    Case i of
      1, 2  :  s := 'AC';
      3     :  s := 'TH';
      4     :  s := 'TL';
      5     :  s := 'NM';
      6     :  s := 'ST';
      7,8   :  s := 'CC';
     11     :  s := 'JC';
     12     :  s := 'ML';
{$IFDEF EN550CIS}
     13     :  s := 'SYS';
     17     :  s := 'AN';
     18     :  s := 'JT';
     19     :  s := 'TR';
     20     :  s := 'FI';
     21     :  s := 'EM';
     22     :  s := 'JR';
     23     :  s := 'JA';
     24     :  s := 'JE';
     25     :  s := 'JB';
     33     :  s := 'JV';
{$ENDIF}
     else
       s := 'SYS';
    end;
  end
  else
  begin
    i := StrToInt(edtWindowID.Text);
    Case  i of
      AccWindow   :  s := 'AC';
      TransWindow :  s := 'TH';
      StockWindow :  s := 'ST';
      JobWindow   :  s := 'JC';
    end;
  end;

  Form_SelectField2.SC := s;
end;

function TfrmElWizard.FieldLength(const s : ShortString) : Byte;
var
  Res : SmallInt;
  DRec : DataDictRec;
begin
  if GetDDField(s, DRec) then
    Result := DRec.DataVarRec.VarLen
  else
    Result := Length(s);

end;

function TfrmElWizard.CheckMsgLength(const Msg : AnsiString) : SmallInt;
var
  s : AnsiString;
  Len, i, j : SmallInt;
begin

  s := Msg;
  Len := 0;

  i := Pos('DBF[', s);

  while i > 0 do
  begin
    Delete(s, 1, i - 1);
    Len := Len + i - 1;

    j := Pos(']', s);

    if (j <= 13) and (j > 0) then
    begin
      Len := Len + FieldLength(Copy(s, 5, j - 5));
      Delete(s, 1, j);
      i := Pos('DBF[', s);
    end
    else
      i := 0;
  end;

  Len := Len + Length(s);

  Result := Len;
end;

procedure TfrmElWizard.CopyEmailToSMS;
var
  i : SmallInt;
  s : AnsiString;
begin
  s := memEmailLines.Lines.Text;
  i := CheckMsgLength(s);

  if (i <= 160) and (memSMSMsg.Lines.Count = 0) then
    memSMSMsg.Lines.Text := s;
end;


procedure TfrmElWizard.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  GlobFormKeyDown(Sender, Key, Shift, ActiveControl, Handle);
end;

procedure TfrmElWizard.FormKeyPress(Sender: TObject; var Key: Char);
begin
  GlobFormKeyPress(Sender, Key, ActiveControl, Handle);
end;

procedure TfrmElWizard.lvEmailRecipKeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if Key = VK_DELETE then
     btnEmAddDeleteClick(Self);
end;

procedure TfrmElWizard.lvSMSRecipKeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if Key = VK_DELETE then
    btnSMSDeleteClick(Self);
end;

function TfrmElWizard.EmailRecipType(const s : ShortString) : TEmailRecipType;
begin
  if s = 'CC' then
    Result := ertCC
  else
  if s = 'BCC' then
    Result := ertBCC
  else
    Result := ertTo;
end;

procedure TfrmElWizard.SetImage(WhichPage : Byte);

  //PR: 08/07/2013 ABSEXCH-14438 Rebranding. New function to get bitmap name from index
  function GetPicName(WhichPic : Byte) : string;
  begin
    Case WhichPic of
      bmpMain         : Result := 'WStart';
      bmpRecipient    : Result := 'WEmail';
      bmpEmail        : Result := 'WEmail';
      bmpFinish       : Result := 'Finish';
      bmpTime         : Result := 'WClock';
      bmpPhone2       : Result := 'WMobile';
      bmpCalender     : Result := 'WCalend';
      bmpLogic        : Result := 'WCond';
      bmpReport       : Result := 'WRep';
      bmpType         : Result := 'WType';
      bmpPriority     : Result := 'WPriorty';
      bmpRepOpts      : Result := 'WRepOpt';
      bmpDataFile     : Result := 'DataFile';
      bmpFax          : Result := 'Fax';
      bmpEvent        : Result := 'Event';
    end;
  end;

  procedure SetPicture(WhichPic : Byte);
  begin
    //PR: 08/07/2013 ABSEXCH-14438 Rebranding. Load bitmap from branding file rather than resource.
    with Branding do
    begin
      if BrandingFileExists('Sentimail') then
      begin
        BrandingFile('Sentimail').ExtractImage(Image1, GetPicName(WhichPic));
        Image1.Repaint;
        Application.ProcessMessages;
      end;
    end;
  end;

begin
  Case WhichPage of
    pgDescription      : SetPicture(bmpMain);
    pgType             : SetPicture(bmpType);
    pgPriority         : SetPicture(bmpPriority);
    pgPushPull         : SetPicture(bmpTime);
    pgEvent            : SetPicture(bmpEvent);
    pgDatafile         : SetPicture(bmpDataFile);
    pgReport,
    pgReportParams,
   pgCSVFTP     : SetPicture(bmpReport);
    pgTransmission,
    pgEmailMsg,
    pgRepEmailAdd,
    pgRepEmailMsg      : SetPicture(bmpEmail);
    pgEmailAdd         : SetPicture(bmpRecipient);

    pgSMSNos,
    pgSMSMsg           : SetPicture(bmpPhone2);
    pgDay,
    pgTime,
    pgNotify           : SetPicture(bmpTime);
    pgFrequency,
    pgExpiry           : SetPicture(bmpCalender);
    pgActive           : SetPicture(bmpFinish);
    pgConditions       : SetPicture(bmpLogic);
    pgRepFaxAdd,
    pgRepFaxOpts       : SetPicture(bmpFax);

  end;
end;

procedure TfrmElWizard.SetOutputButtons;
begin
end;

procedure TfrmElWizard.btnEditParamsClick(Sender: TObject);
var
  s1, s2 : ShortString;
  o1, o2 : SmallInt;
  WasSelected : SmallInt;
begin
  with lvParams do
  begin
    if Assigned(Selected) then
    with TfrmParams.Create(nil) do
    Try
      WasSelected := Selected.Index;
      DataType := StrToInt(Selected.SubItems[3]);
      oToolkit := FToolkit;
      DataPath := FToolkit.configuration.DataDirectory;
      lblParam.Caption := 'Parameter No. ' + Selected.Caption +
                            ': ' + Selected.SubItems[0];
      FromString := Selected.SubItems[1];
      ToString := Selected.SubItems[2];
      Text2Param(FromString, o1, DataType);
      Text2Param(ToString, o2, DataType);
      spnOffStart.Value := o1;
      spnOffEnd.Value := o2;
      CurrencyList := FCurrencyList;
      SetControls;
      ShowModal;
      if ModalResult = mrOK then
      begin
        Selected.SubItems[1] := Param2Text(FromString, Trunc(spnOffStart.Value), DataType);
        Selected.SubItems[2] := Param2Text(ToString, Trunc(spnOffEnd.Value), DataType);
        ParamsChanged := True;
      end;
    Finally

      Free;
    End;
    Selected := Items[WasSelected];
    Update;
  end;
end;

procedure TfrmElWizard.SaveRepEmailOutput;
var
  Res : SmallInt;
  i   : integer;
begin
  DeleteOutputs(eolRepEmailSubject);
  DeleteOutputs(eolRepEmailLine);
  if edtRepEmailSub.Text <> '' then
  begin
    with ThisOutput do
    begin
      UserID := ThisElert.UserID;
      ElertName := ThisElert.ElertName;
      LineNo := 1;
      Line1 := edtRepEmailSub.Text;
      Line2 := '';
      OutputType := eolRepEmailSubject;

      Res := Add;
    end;
  end;

  for i := 0 to memRepEmailMsg.Lines.Count - 1 do
  begin
    with ThisOutput do
    begin
      UserID := ThisElert.UserID;
      ElertName := ThisElert.ElertName;
      LineNo := i + 1;
      Line1 := memRepEmailMsg.Lines[i];
      Line2 := '';
      OutputType := eolRepEmailLine;

      Res := Add;
    end;
  end;

end;


function TfrmElWizard.SetListView : TListView;
begin
  Result := lvEmailRecip;
  Case Notebook1.PageIndex of
     pgRepEmailAdd : Result := lvRepEmailAdd;
     pgSMSNos      : begin
                       Result := lvSMSRecip;
                       FDlgCaption := 'SMS';
                     end;
     pgRepFaxAdd   : begin
                       Result := lvRepFaxAdd;
                       FDlgCaption := 'Fax';
                     end;
     pgRemote      : Result := lvRemoteAdd;
  end;
end;



procedure TfrmElWizard.chkRepEmailClick(Sender: TObject);
begin
   btnNext.Enabled := chkRepEmail.Checked or chkRepFax.Checked;
end;

procedure TfrmElWizard.spFaxCoverClick(Sender: TObject);
  function RemoveExt(const s : string) : string;
  var
    i : integer;
  begin
    i := Length(s);
    while (i > 0) and (s[i] <> '.') do dec(i);
    Result := Copy(s, 1, i - 1);
  end;
  
begin
  with OpenDialog1 do
  begin
    InitialDir := IncludeTrailingBackSlash(FToolkit.Configuration.DataDirectory) + 'FORMS';
    if Execute then
      if Sender = spFaxCover then
        edtFaxCover.Text := RemoveExt(ExtractShortPathName(ExtractFileName(FileName)))
      else
      begin
        edtTransForm.Text := RemoveExt(ExtractShortPathName(ExtractFileName(FileName)));
        chkEmailClick(Self);
      end;
  end;
end;

procedure TfrmElWizard.LoadRepEmailOutput;
var
  Res : SmallInt;
begin
  with ThisOutput do
  begin
    UserID := ThisElert.UserID;
    ElertName := ThisElert.ElertName;

    OutputType := eolRepEmailSubject;

    Res := GetFirst;

    if Res = 0 then
      if OutputType = eolRepEmailSubject then
      edtRepEmailSub.Text := Line1;

    LoadEmail(eolRepEmailLine, memRepEmailMsg);

  end;
end;

procedure TfrmElWizard.SaveRepEmailAddresses;
var
  Res : SmallInt;
  i   : integer;
begin
  DeleteOutputs(eolRepEmailAdd);
  for i := 0 to lvRepEmailAdd.Items.Count - 1 do
  begin
    with ThisOutput do
    begin
      UserID := ThisElert.UserID;
      ElertName := ThisElert.ElertName;
      LineNo := i + 1;
      Line1 := lvRepEmailAdd.Items[i].SubItems[0];
      Line2 := lvRepEmailAdd.Items[i].SubItems[1];
      RecipType := EmailRecipType(lvRepEmailAdd.Items[i].Caption);
      OutputType := eolRepEmailAdd;

      Res := Add;
    end;
  end;
end;


procedure TfrmElWizard.LoadRepEmailAddresses;
var
  Res : SmallInt;
begin
  lvRepEmailAdd.Items.Clear;
  with ThisOutput do
  begin
    UserID := ThisElert.UserID;
    ElertName := ThisElert.ElertName;

    OutputType := eolRepEmailAdd;

    Res := GetFirst;

    while (Res = 0) and (OutputType = eolRepEmailAdd) do
    begin

      if OutputType = eolRepEmailAdd then
      with  lvRepEmailAdd.Items.Add do
      begin
        Caption := EmailTypes[Ord(RecipType)];
        SubItems.Add(Line1);
        SubItems.Add(Line2);
      end;

      Res := GetNext;
    end;
  end;
end;

procedure TfrmElWizard.SaveRepFaxNos;
var
  Res : SmallInt;
  i   : integer;
begin
  DeleteOutputs(eolFaxNo);
  for i := 0 to lvRepFaxAdd.Items.Count - 1 do
  begin
    with ThisOutput do
    begin
      UserID := ThisElert.UserID;
      ElertName := ThisElert.ElertName;
      LineNo := i + 1;
      Line1 := lvRepFaxAdd.Items[i].Caption;
      Line2 := lvRepFaxAdd.Items[i].SubItems[0];
      OutputType := eolFaxNo;

      Res := Add;
    end;
  end;
end;


procedure TfrmElWizard.LoadRepFaxNos;
var
  Res : SmallInt;
begin
  lvRepFaxAdd.Items.Clear;
  with ThisOutput do
  begin
    UserID := ThisElert.UserID;
    ElertName := ThisElert.ElertName;

    OutputType := eolFaxNo;

    Res := GetFirst;

    while (Res = 0) and (OutputType = eolFaxNo) do
    begin

      if OutputType = eolFaxNo then
      with  lvRepFaxAdd.Items.Add do
      begin
        Caption := Line1;
        SubItems.Add(Line2);
      end;

      Res := GetNext;
    end;
  end;
end;

procedure TfrmElWizard.SaveFaxOptions;
var
  Res : SmallInt;
  i   : integer;
begin
  DeleteOutputs(eolFaxFrom);
  DeleteOutputs(eolFaxNoteLine);
  if (edtRepFaxName.Text <> '') or (edtRepFaxNo.Text <> '') then
  begin
    with ThisOutput do
    begin
      UserID := ThisElert.UserID;
      ElertName := ThisElert.ElertName;
      LineNo := 1;
      Line1 := edtRepFaxName.Text;
      Line2 := edtRepFaxNo.Text;
      OutputType := eolFaxFrom;

      Res := Add;
    end;
  end;

  for i := 0 to memFaxNote.Lines.Count - 1 do
  begin
    with ThisOutput do
    begin
      UserID := ThisElert.UserID;
      ElertName := ThisElert.ElertName;
      LineNo := i + 1;
      Line1 := memFaxNote.Lines[i];
      Line2 := '';
      OutputType := eolFaxNoteLine;

      Res := Add;
    end;
  end;

  ThisElert.CoverPage := edtFaxCover.Text;
  ThisElert.FaxPriority := cbFaxPriority.ItemIndex;
end;

procedure TfrmElWizard.LoadFaxOptions;
var
  Res : SmallInt;
begin
  with ThisOutput do
  begin
    UserID := ThisElert.UserID;
    ElertName := ThisElert.ElertName;

    OutputType := eolFaxFrom;

    Res := GetFirst;

    if Res = 0 then
    begin
      if OutputType = eolFaxFrom then
      begin
        edtRepFaxName.Text := Line1;
        edtRepFaxNo.Text := Line2;
      end;
    end;

    LoadEmail(eolFaxNoteLine, memFaxNote);

  end;

  edtFaxCover.Text := ThisElert.CoverPage;
  cbFaxPriority.ItemIndex := ThisElert.FaxPriority;
end;

function TfrmElWizard.Param2Text(const s : ShortString;
                                 OffSet : SmallInt; EntParamType : Byte) : ShortString;
var
 i : integer;
 s1 : string;
begin
  Result := s;
  Case EntParamType of
    1  :  begin
            if s[1] <> 'T' then
              Result := POutDate(s);
          end;
    2  :  begin
            if s[1] = 'C' then
              Result := s
            else
            if Pos('/', s) > 0 then
              Result := s
            else
              Result := Copy(s, 4, 2) + '/' + IntToStr(StrToInt(Copy(s, 1, 3)) + 1900);
          end;
      5 : begin //currency  //PR: 05/04/2011 ABSEXCH-2702 Was displaying currency number rather than name.
            if FCurrencyList.Count = 0 then
            begin
              FToolkit.OpenToolkit;
              for i := 0 to 89 do
              begin
                s1 := Trim(FToolkit.SystemSetup.ssCurrency[i].scSymbol);
                if (Length(s1) > 0) and (s1[1] = #156) then
                  s1 := '£';
                FCurrencyList.Add( s1 +
                               ' - ' +  Trim(FToolkit.SystemSetup.ssCurrency[i].scDesc));
              end;
              FToolkit.CloseToolkit;
            end;
            Try
              Result := Trim(FCurrencyList[StrToInt(s)]);
            Except
              Result := s;
            End;
          end;
  end;
  if EntParamType in [1, 2] then
  begin
    if OffSet <> 0 then
    begin
      if OffSet > 0 then
        Result := Result + ' +' + IntToStr(OffSet)
      else
        Result := Result + ' ' + IntToStr(OffSet);
    end;
  end;

end;

procedure TfrmElWizard.Text2Param(var s : ShortString; var OffSet : SmallInt; EntParamType : Byte;
                                  Store : Boolean = False);
var
  i : SmallInt;
  s1 : ShortString;
begin
  Case EntParamType of
    1  : begin
           if s[1] = 'T' then
           begin
              s1 := Copy(s, 7, Length(s));
              Try
                i := StrToInt(s1);
              Except
                i := 0;
              End;
              s := Copy(s, 1, 5);
              OffSet := i;
           end
           else
           begin
              i := Length(s);
              while (i > 0) and not (s[i] in ['+','-']) do
                dec(i);
              if i > 0 then
              begin
                s1 := Copy(s, i, Length(s));
                s := Copy(s, 1, i - 2);
              end
              else
                s1 := '';

              Try
                i := StrToInt(s1);
              Except
                i := 0;
              End;
             if Store then
               s := Date2Store(RemoveDateSep(s));
             Offset := i;
           end;
         end;
    2  : begin
           if s[1] = 'C' then
           begin
              s1 := Copy(s, 16, Length(s));
              Try
                i := StrToInt(s1);
              Except
                i := 0;
              End;
              s := Copy(s, 1, 14);
              OffSet := i;
           end
           else
           begin
              i := Length(s);
              while (i > 0) and not (s[i] in ['+','-']) do
                dec(i);
              if i > 0 then
              begin
                s1 := Copy(s, i, Length(s));
                s := Copy(s, 1, i - 2);
              end
              else
                s1 := '';

              Try
                i := StrToInt(s1);
              Except
                i := 0;
              End;
              s := Copy(s, 1, 7);
              if s[Length(s)] = ' ' then Delete(s, Length(s), 1);
              OffSet := i;
           end;
         end;
      5 : begin //currency
            if FCurrencyList.Count = 0 then
            begin
              FToolkit.OpenToolkit;
              for i := 0 to 89 do
              begin
                s1 := Trim(FToolkit.SystemSetup.ssCurrency[i].scSymbol);
                if (Length(s1) > 0) and (s1[1] = #156) then
                  s1 := '£';
                FCurrencyList.Add( s1 +
                               ' - ' +  Trim(FToolkit.SystemSetup.ssCurrency[i].scDesc));
              end;
              FToolkit.CloseToolkit;
            end;
            Offset := FCurrencyList.IndexOf(s);
            s := IntToStr(Offset);
          end;

    end; //case
end;

function TfrmElWizard.IsReport : Boolean;
begin
  Result := rbReport.Checked or rbNewRep.Checked;
end;

function TfrmElWizard.IsTransaction : Boolean;
begin
  Result := (rbTimer.Checked and (Pos('Document', cbDataFile.Text) = 1)) or
            (rbEvent.Checked and (edtWindowID.Text = '102000'));
end;

function TfrmElWizard.RemoveDateSep(const s : string) : String;
var
  i : integer;
begin
  i := 1;
  Result := s;
  while i < Length(Result) do
    if Result[i] = DateSeparator then
      Delete(Result, i, 1)
    else
      inc(i);
end;

function TfrmElWizard.DataType : Byte;
begin
  Result := 0;

  if Integer(cbDataFile.Items.Objects[cbDataFile.ItemIndex]) = 3 then
  begin
    Case cbIndex.ItemIndex of
      12   :  Result := 1;
      13   :  Result := 2;
    end;
  end
  else
  if Integer(cbDataFile.Items.Objects[cbDataFile.ItemIndex]) = 4 then
  begin
    Case cbIndex.ItemIndex of
      17   :  Result := 1;
      18   :  Result := 2;
    end;
  end
  else
  if JC then Result := 1;


end;





procedure TfrmElWizard.cbRangeStartExit(Sender: TObject);
begin
  if (ActiveControl <> btnCancel) and
     (ActiveControl <> cbIndex) and
     (ActiveControl <> cbDataFile) then
    if not ValidateComboExit(TComboBox(Sender), DataType) then
    begin
      ActiveControl := TWinControl(Sender);
      Notebook1.PageIndex := pgDataFile;
    end;

end;

procedure TfrmElWizard.cbRangeStartChange(Sender: TObject);
begin
  if Sender = cbRangeStart then
    SetLabel(cbRangeStart, lblOffStart, DataType)
  else
  if Sender = cbRangeEnd then
    SetLabel(cbRangeEnd, lblOffEnd, DataType);

end;

function TfrmElWizard.FindNextReport(const s : String) : Boolean;
var
  i : integer;
  Found : Boolean;
begin
  with tvReports do
  begin
    if Assigned(Selected) then
    begin
      Found := False;
      i := Selected.AbsoluteIndex;
      while not Found and (i <= Items.Count - 2) do
      begin
        inc(i);
        if Pos(UpperCase(s), UpperCase(Items[i].Text)) > 0 then
        begin
          Found := True;
          Selected := Items[i];
        end;
      end;
    end;
  end;
  Result := Found;
end;


procedure TfrmElWizard.btnFindClick(Sender: TObject);
begin
  if not FindNextReport(edtFind.Text) then
    ShowMessage(QuotedStr(edtFind.Text) + ' not found');

  ActiveControl := tvReports;

end;

procedure TfrmElWizard.edtFindChange(Sender: TObject);
begin
  btnFind.Enabled := edtFind.Text <> '';
end;

procedure TfrmElWizard.cbRangeStartDblClick(Sender: TObject);
begin
  if DataType = 1 then
    if Sender is TComboBox then
      with Sender as TComboBox do
        Text := SelectDate(Text);
end;

procedure TfrmElWizard.rbEventClick(Sender: TObject);
begin
  if rbEvent.Checked then
    rbMultEmail.Checked := True;
end;

procedure TfrmElWizard.rbReportClick(Sender: TObject);
begin
  //PR: 27/09/2012 ABSEXCH-13194 In some cases, clearing the items was causing onChange to execute,
  //changing the selected report, so take it away until we've run clear.
  tvReports.OnChange := nil;
  tvReports.Items.Clear;
  //PR: 27/09/2012 ABSEXCH-13194 Restore OnChange eventhandler
  tvReports.OnChange := tvReportsChange;
  RepTreeLoaded := False;
  chkRepConditions.Visible := rbReport.Checked or rbNewRep.Checked;
  chkRepAsCSV.Visible := chkRepConditions.Visible;
  edtCSVName.Visible := chkRepAsCSV.Visible and chkRepAsCsv.Checked;
  lblCSVName.Visible := edtCSVName.Visible;
  if not chkRepAsCSV.Visible then
    chkRepAsCSV.Checked := False;

  cbCSVType.Visible := chkRepAsCSV.Visible;
  cbCSVTypeClick(Self);
  btnNext.Enabled := not IsCSV or (edtCSVName.Text <> '');

end;

procedure TfrmElWizard.Button9Click(Sender: TObject);
begin
  ThisElert.Triggered := 0;
  ShowMessage('Successful trigger count reset to zero');
  UpdateTriggerCaption;
end;

procedure TfrmElWizard.UpdateTriggerCaption;
var
  t : string;
begin
  if ThisElert.Triggered = 1 then
    t := ' time.'
  else
    t := ' times.';
  lblTrigger.Caption := 'This Sentinel has been successfully triggered ' +
                        IntToStr(ThisElert.Triggered) + t;
end;

function TfrmElWizard.DeleteQuery(const s : string) : Boolean;
begin
  Result := MsgBox('Are you sure you want to delete this ' + s + '?',
  mtConfirmation,[mbYes,mbNo],mbNo,'Delete ' + s) = mrYes;
end;

function TfrmElWizard.IsCSV : Boolean;
begin
//  Result := rbReport.Checked and chkRepAsCSV.Checked;
  Result := IsReport and chkRepAsCSV.Checked;
end;

procedure TfrmElWizard.chkCSVEmailClick(Sender: TObject);
begin
  btnNext.Enabled := chkCSVEmail.Checked or chkCSVFtp.Checked or
                     chkCSVFolder.Checked;
end;

procedure TfrmElWizard.chkRepAsCSVClick(Sender: TObject);
begin
  if chkRepAsCSV.checked then
  begin
    chkRepEmail.Checked := False;
    chkRepFax.Checked := False;
  end
  else
  begin
    chkCSVEmail.Checked := False;
    chkCSVFtp.Checked := False;
    chkCSVFolder.Checked := False;
  end;
  btnNext.Enabled := not IsCSV or (edtCSVName.Text <> '');

  lblCSVName.Visible := chkRepAsCSV.Checked;
  edtCSVName.Visible := lblCSVName.Visible;

end;

procedure TfrmElWizard.edtCSVNameChange(Sender: TObject);
begin
  btnNext.Enabled := Trim(edtCSVName.Text) <> '';
end;

procedure TfrmElWizard.LoadFolderTree;
begin
  tvFolder.Items.Clear;
  AddFolder(FToolkit.Configuration.EnterpriseDirectory, nil);
end;

procedure TfrmElWizard.AddFolder(s : String; PNode : TTreeNode);
var
  SearchRec : TSearchRec;
  Res : Integer;
  ThisNode : TTreeNode;
begin

  s := IncludeTrailingBackSlash(s);
  Res := FindFirst(s + '*.*', faDirectory, SearchRec);

  while Res = 0 do
  begin
    if (SearchRec.Name <> '.') and (SearchRec.Name <> '..') and
       ((SearchRec.Attr and faDirectory) = faDirectory) then
    begin
      ThisNode := tvFolder.Items.AddChild(PNode, SearchRec.Name);
      ThisNode.ImageIndex := 0;

      AddFolder(s + SearchRec.Name, ThisNode);
    end;
    Res := FindNext(SearchRec);
  end;

  FindClose(SearchRec);
end;

procedure TfrmElWizard.tvFolderExpanded(Sender: TObject; Node: TTreeNode);
begin
  if Assigned(Node) then
    Node.ImageIndex := 1;
end;

procedure TfrmElWizard.tvFolderCollapsed(Sender: TObject; Node: TTreeNode);
begin
  if Assigned(Node) then
    Node.ImageIndex := 0;
end;

function TfrmElWizard.GetSelectedCSVFolder : string;
var
  ThisNode : TTreeNode;
begin
  Result := '';
  ThisNode := tvFolder.Selected;
  while Assigned(ThisNode) do
  begin
    Result := '\' + ThisNode.Text + Result;

    ThisNode := ThisNode.Parent;
  end;
  if Result[1] = '\' then Delete(Result, 1, 1);
end;

procedure TfrmElWizard.tvFolderKeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  lblCSVFolder.Caption := 'Sub-Folder: ' + GetSelectedCSVFolder;
end;

procedure TfrmElWizard.tvFolderMouseUp(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  lblCSVFolder.Caption := 'Sub-Folder: ' + GetSelectedCSVFolder;
end;

procedure TfrmElWizard.SetCSVPath(const s : string);
var
  i : integer;
  s1 : string;
  Found : Boolean;
begin
  i := Length(s);

  while (i > 0) and (s[i] <> '\') do dec(i);

  if i = 0 then
    s1 := s
  else
    s1 := Copy(s, i + 1, Length(s));

  i := 0;
  Found := False;

  while (i < tvFolder.Items.Count - 1) and not Found do
  begin
    if s1 = tvFolder.Items[i].Text then
    begin
      tvFolder.Selected := tvFolder.Items[i];
      if GetSelectedCSVFolder = s1 then
        Found := True;
    end;
    inc(i);
  end;

  lblCSVFolder.Caption := 'Sub-Folder: ' + s;
end;


procedure TfrmElWizard.edtFTPPortExit(Sender: TObject);
var
  i : integer;
  Edt : TEdit;
begin
  Edt := Sender as TEdit;
  Try
    i := StrToInt(edt.Text);
  Except
    if IsCSV and chkCSVFtp.Checked and (ActiveControl <> btnCancel) then
    begin
      SetPage(pgCSVFTP);
      ShowMessage(QuotedStr(edt.Text) + ' is not a valid number');
      ActiveControl := edt;
      AllowClose := False;
    end;
  End;
end;

procedure TfrmElWizard.FormCloseQuery(Sender: TObject;
  var CanClose: Boolean);
begin
  AllowClose := True;
  if ModalResult = mrOK then
  begin
    edtFTPPortExit(edtFTPPort);
    edtFTPPortExit(edtTimeout);
  end;

  CanClose := AllowClose;

end;

procedure TfrmElWizard.edtFTPPasswordEnter(Sender: TObject);
begin
  edtFTPPassword.PasswordChar := #0;
end;

procedure TfrmElWizard.edtFTPPasswordExit(Sender: TObject);
begin
  edtFTPPassword.PasswordChar := '*';
end;

procedure TfrmElWizard.Button10Click(Sender: TObject);
var
  s, s1 : AnsiString;
  Res : integer;
begin
  s1 := IncludeTrailingBackSlash(GetSelectedCSVFolder);
  s := FToolkit.Configuration.EnterpriseDirectory + s1;
  with TfrmNewFolder.Create(self) do
  Try
    ActiveControl := edtFolder;
    ShowModal;
    if ModalResult = mrOK then
    begin
      s := s + Trim(edtFolder.Text);
{$I-}
      MkDir(s);
      Res := IOResult;
{$I+}
      if Res <> 0 then
          MessageDlg('Unable to create folder ' + QuotedStr(s), mtWarning, [mbOK], 0)
      else
      begin
        LoadFolderTree;
        SetCSVPath(s1 + Trim(edtFolder.Text));
        Self.ActiveControl := tvFolder;
      end;
    end;
  Finally
    Free;
  end;


end;

function TfrmElWizard.NeedNewNextRun : Boolean;
begin
  with ThisElert do
  begin
    Result := not IsEdit
              or (rbMins.Checked and ((TimeType <> ettFrequency) or (StrToInt(edMins.Text) <> Frequency) ) )
              or (rbMinsBetween.Checked and ((TimeType <> ettFrequencyInPeriod) or (StrToInt(edMinsBetween.Text) <> Frequency)))
              or (rbSpecific.Checked and (TimeType <> ettTimeOneOnly))
              or (rbPeriod.Checked xor Periodic);

  end;


end;

procedure TfrmElWizard.ReadFaxDefaults;
begin
//  FToolkit.Configuration.DataDirectory := SetDrive;
  FToolkit.OpenToolkit;
  DefFaxName := FToolkit.SystemSetup.ssPaperless.ssFaxFromName;
  DefFaxNo := FToolkit.SystemSetup.ssPaperless.ssFaxFromTelNo;
  FToolkit.CloseToolkit;
end;


procedure TfrmElWizard.btnEmFuncsClick(Sender: TObject);
var
  TempMemo : TMemo;
begin
  if InEmailSubject then
  begin
   Try
    TempMemo := TMemo.Create(Self);
    TempMemo.Parent := Self;
    TempMemo.Text := edtEmSubject.Text;
    btnLogicEditClick(TempMemo);
    edtEmSubject.Text := TempMemo.Text;
   Finally
    TempMemo.Free;
   End;
  end
  else
  Case pgcEmailMsg.ActivePage.Tag of
     tagEmailHeader  : btnLogicEditClick(memEmailHeader);
     tagEmailLine   : btnLogicEditClick(memEmailLines);
     tagEmailTrailer : btnLogicEditClick(memEmailTrailer);
  end; //case
end;

procedure TfrmElWizard.btnSMSFuncClick(Sender: TObject);
begin
  btnLogicEditClick(memSMSMsg);
end;

procedure TfrmElWizard.edtEmSubjectEnter(Sender: TObject);
begin
  InEmailSubject := True;
end;

procedure TfrmElWizard.edtEmSubjectExit(Sender: TObject);
begin
  if not (ActiveControl is TButton) or (TButton(ActiveControl).Tag <> 255) then
    InEmailSubject := False;
end;

procedure TfrmElWizard.pgcEmailMsgChange(Sender: TObject);
begin
  chkWordWrap.Visible := pgcEmailMsg.ActivePage = pgEmailLines;
  if pgcEmailMsg.ActivePage = pgForm then
    chkSendDocClick(Self);
end;

procedure TfrmElWizard.chkWordWrapClick(Sender: TObject);
begin
  if chkWordWrap.Checked then
  begin
    memEmailLines.WordWrap := True;
    memEmailLines.ScrollBars := ssNone;
  end
  else
  begin
    memEmailLines.WordWrap := False;
    memEmailLines.ScrollBars := ssHorizontal;
  end;
end;

procedure TfrmElWizard.FormatList(AList : TStrings);
var
  BList : TStringList;
  s : Ansistring;
  i, j : integer;
begin
  BList := TStringList.create;
  Try
    for i := 0 to AList.Count - 1 do
    begin
      s := AList[i];
      while Length(s) > 0 do
      begin
        j := 255;
        if Length(s) > 255 then
          while (j > 0) and not (s[j] in [' ']) do dec(j);
        if j = 0 then j := 255;
        BList.Add(Copy(s, 1, j));
        Delete(s, 1, j);
      end;
    end;

    AList.Clear;
    AList.AddStrings(BList);
  Finally
    BList.Free;
  End;

end;


procedure TfrmElWizard.memEmailLinesExit(Sender: TObject);
var
  i : integer;
  NeedFormat : Boolean;
begin
  if not chkWordWrap.Checked and (ActiveControl <> chkWordWrap) and
                                 (ActiveControl <> btnCancel) and
                                 (ActiveControl <> btnEmailInsertDb) and
                                 (ActiveControl <> btnEmFuncs) then
  begin
    NeedFormat := False;
    for i := 0 to memEmailLines.Lines.Count - 1 do
      if Length(memEmailLines.Lines[i]) > 255 then
        NeedFormat := True;

    if NeedFormat then
    begin
      memEmailLines.Lines.BeginUpdate;
      ShowMessage('The maximum length for lines in the email message is 255 characters. Lines longer than this will be wrapped around to a new line');
      FormatList(memEmailLines.Lines);
      memEmailLines.Lines.EndUpdate;
      if ActiveControl is TButton then
        TButton(ActiveControl).OnClick(self);
    end;
  end;

end;

procedure TfrmElWizard.SetToolkit(Value : IToolkit);
begin
  Ftoolkit := Value;
  if Assigned(FToolkit) then
    LoadFolderTree;
end;

procedure TfrmElWizard.chkSendDocClick(Sender: TObject);
begin
    spTransForm.Enabled := chkSendDoc.Checked;
end;

procedure TfrmElWizard.tvReportsExpanding(Sender: TObject; Node: TTreeNode;
  var AllowExpansion: Boolean);
begin
  if Node <> nil then
  begin
    Node.ImageIndex := 3;
    Node.SelectedIndex := 3;
  end;
  if not rbNewRep.Checked then
  begin
    FillChar(ThisReport, SizeOf(ThisReport), #0);
    Move(Node.Data^, ThisReport, SizeOf(ThisReport));
    if (Trim(ThisReport.GrpPWord) <> '') and (RepPasswordList.IndexOf(ThisReport.repName) < 0) then
    begin
      AllowExpansion := GetReportPassword(Node.Text, ThisReport.GrpPWord);
      if AllowExpansion then
      begin
        RepPasswordList.Add(ThisReport.RepName);
      end;
    end;
  end;
end;

procedure TfrmElWizard.edtNameExit(Sender: TObject);
begin
  if not IsEdit and Assigned(ThisElert) and (ThisElert.GetEqual(Trim(edtName.text)) = 0) then
  begin
    ShowMessage('Sentinel ' + Trim(edtName.Text) + ' already exists');
    btnNext.Enabled := False;
    ActiveControl := edtName;
  end;
end;

procedure TfrmElWizard.cbCSVTypeClick(Sender: TObject);
const
  Capt2 = ' Filename (Max %d chars including extension)';
begin
  gbCSVOutput.Caption :=  'Send ' + Trim(CSVNames[cbCSVType.ItemIndex]) + ' file by';
  edtCSVName.Text := ChangeFileExt(edtCSVName.Text, CSVExts[cbCSVType.ItemIndex]);
  chkRepAsCSVClick(Self);
end;


procedure TfrmElWizard.chkMarkExistingClick(Sender: TObject);
begin
  rgAcType.Visible := chkMarkExisting.Checked and (edtWindowId.Text = '101000'); 
end;

procedure TfrmElWizard.tvReportsCollapsing(Sender: TObject;
  Node: TTreeNode; var AllowCollapse: Boolean);
begin
  if Node <> nil then
  begin
    Node.ImageIndex := 2;
    Node.SelectedIndex := 2;
  end;
end;

procedure TfrmElWizard.SetVAOComponents;
var
  VAOOff : Boolean;
begin
  VAOOff := VAOInfo.vaoMode <> smVAO;

  chkCSVFTP.Enabled := VAOOff;
  chkCSVFolder.Enabled := VAOOff;
  chkSMS.Enabled := VAOOff;
  chkRepFax.Enabled := VAOOff;

end;


procedure TfrmElWizard.MoveRepControl(WhichControl : TControl);
begin
  WhichControl.Top := WhichControl.Top - 41;
end;

end.
