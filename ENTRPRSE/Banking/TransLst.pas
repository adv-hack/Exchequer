unit TransLst;

{$I DEFOVR.Inc}

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, TCustom, uMultiList, uDBMultiList, ComCtrls, ExtCtrls,
  SBSPanel, TEditVal, Menus, Enterprise04_TLB, uExDatasets, uComTKDataset,
  BankList, TranFile, uBtrieveDataset, ExBtTh1U, Tranl1U, VarConst, ExWrap1U,
  BtSupU1, Varrec2u, StatForm, uSettings, BtrvU2,
  ReconObj, EnterToTab, PostingU, EnterpriseBeta_TLB;

{PR: 10/4/2008 - To improve performance under SQL, I've made changes to the way the temp file is built. Previously, for each line added we were
 looking for a status or tag line in MLocStk.dat regardless of whether there was an incomplete reconciliation. Two changes have been made:

 1. If we are not restoring an existing reconciliation then we don't bother looking, since there will be no relevant status lines.
 2. If we are restoring an existing reconciliation then the ReconcileObject will begin by loading all status and tag lines for this reconciliation into
    a stringlist. The process which builds the temp file can then find the lines from the string list, avoiding GetEqual calls to MLocStk. This should
    enhance performance under SQL since we are replacing two GetEqual calls for each transaction line with a total of one GetGEq call for the whole
    process followed by one GetNext call for each stored status/tag line plus 1.}


{ PR: 09/11/2009 To improve performance properly under SQL, I've converted building the temporary table to use sql to go
  directly to the database.

image_0 in Temp Table
    btdIdDocHed : DocTypes; 1 - 1
    btdPostedRun : longint;  2 - 5
    btdFolioRef   : longint;  6 - 9
    btdNoOfItems : longint;  10 - 13
    btdNumberCleared : longint; 14 - 17
    btdNumberMatched : longint; 19 - 21
    btdLineNo : longint;  22 - 25
    btdStatLine : longint; 26 - 29
    btdLineAddr : longint; 30 - 33
    btdReconDate : String[8]; 34 - 43
}


const
  isDate   = 5;
  isRef    = 2;
  isAmount = 3;

  //Filter type bits
  ftDocType = 1;
  ftAcCode  = 2;
  ftRef     = 4;
  ftAmount  = 8;
  ftStatus  = 16;
  ftDate    = 32;

  hcList : Array [0..1] of Integer = (1919, 1948);




type
  TRecListSettings = Record
    StatDate : String[8]; //Date of the statement, shown on criteria screen
    Ref  : String[55];
    UnclearedOnly : Boolean;
    InitialSequence : Byte;
    WantedCurrency : Byte;
    StatBalance : Double;
    OpenBalance : Double;
    CurrName : String;
    MultiSelect : Boolean;
    AutoReconcile : Boolean;
    ExistingReconcile : Boolean;
    //PR: 12/03/2009 Added reconciliation date fields
    UseReconDate : Boolean;
    ReconDate : string[8];
    IsCheck : Boolean;

    //PR: 14/10/2011 v6.9
    lsGroupBy : TGroupBy;
  end;


  TRecListFilter = Class
  private
    DocTo, DocFrom,
    AcTo, AcFrom,
    RefTo, RefFrom,
    DateTo, DateFrom : string;
    AmountTo, AmountFrom : Double;
    StatusTo, StatusFrom : Byte;
  public
    FilterBy : Byte;
    function WantThisRecord(Details : TTempTransDetails) :  Boolean;
    procedure ShowFilterForm;
    function FilterString : string;
  end;

  TfrmTransList = class(TForm)
    Panel1: TPanel;
    PopupMenu1: TPopupMenu;
    Clear1: TMenuItem;
    Unclear1: TMenuItem;
    Find1: TMenuItem;
    Process1: TMenuItem;
    Statement1: TMenuItem;
    N1: TMenuItem;
    Properties1: TMenuItem;
    N2: TMenuItem;
    SaveCoordinates1: TMenuItem;
    btData: TBtrieveDataset;
    PopupMenu2: TPopupMenu;
    Unclear2: TMenuItem;
    Cancel1: TMenuItem;
    Return1: TMenuItem;
    TabControl1: TTabControl;
    Panel3: TPanel;
    mlTrans: TDBMultiList;
    pnlItemTop: TPanel;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    ceStatBalance: TCurrencyEdit;
    ceDifference: TCurrencyEdit;
    ceOpenBalance: TCurrencyEdit;
    pnlItemBottom: TPanel;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    ceCurrent: TCurrencyEdit;
    ceReconciled: TCurrencyEdit;
    ceTagged: TCurrencyEdit;
    RemoveAllFilters1: TMenuItem;
    lblFilters: TLabel;
    mnuFilters: TPopupMenu;
    AddFilter1: TMenuItem;
    RemoveAllFilters2: TMenuItem;
    mnuAdjust: TPopupMenu;
    mnuNom: TMenuItem;
    mnuPPY: TMenuItem;
    mnuPPI: TMenuItem;
    mnuSRC: TMenuItem;
    mnuSRI: TMenuItem;
    RemoveFilter1: TMenuItem;
    mnuDocType: TMenuItem;
    mnuAcCode: TMenuItem;
    mnuRef: TMenuItem;
    mnuAmount: TMenuItem;
    mnuStatus: TMenuItem;
    mnuDate: TMenuItem;
    ag1: TMenuItem;
    EnterToTab1: TEnterToTab;
    pnlButtons: TPanel;
    ScrollBox1: TScrollBox;
    btnClear: TSBSButton;
    btnUnclear: TSBSButton;
    btnTag: TSBSButton;
    btnFind: TSBSButton;
    btnProcess: TSBSButton;
    btnStatement: TSBSButton;
    btnView: TSBSButton;
    btnAdjustment: TSBSButton;
    btnFilter: TSBSButton;
    btnCheck: TSBSButton;
    btnOK: TSBSButton;
    btnCancel: TSBSButton;
    Cancel2: TMenuItem;
    Suspend1: TMenuItem;
    Unclear3: TMenuItem;
    btnMatch: TSBSButton;
    Match1: TMenuItem;
    btnClearAll: TSBSButton;

    { CS: 14/07/2008 - Amendments for Form Resize routines }
    procedure FormStartResize(var Msg: TMsg); message WM_ENTERSIZEMOVE;
    procedure FormEndResize(var Msg: TMsg); message WM_EXITSIZEMOVE;

    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormCreate(Sender: TObject);
    procedure btnCancelClick(Sender: TObject);
    procedure btnOKClick(Sender: TObject);
    procedure FormResize(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure btDataGetFieldValue(Sender: TObject; PData: Pointer;
      FieldName: String; var FieldValue: String);
    procedure TabControl1Change(Sender: TObject);
    procedure btnFindClick(Sender: TObject);
    procedure mlTransRowDblClick(Sender: TObject; RowIndex: Integer);
    procedure btnTagClick(Sender: TObject);
    procedure btnClearClick(Sender: TObject);
    procedure btnUnclearClick(Sender: TObject);
    procedure Unclear2Click(Sender: TObject);
    procedure btnEBankClick(Sender: TObject);
    procedure btnViewClick(Sender: TObject);
    procedure btnStatementClick(Sender: TObject);
    procedure btDataFilterRecord(Sender: TObject; PData: Pointer;
      var Include: Boolean);
    procedure btnFilterClick(Sender: TObject);
    procedure RemoveAllFilters1Click(Sender: TObject);
    procedure AddFilter1Click(Sender: TObject);
    procedure mlTransBeforeLoad(Sender: TObject; var Allow: Boolean);
    procedure mlTransChangeSelection(Sender: TObject);
    procedure mnuPPIClick(Sender: TObject);
    procedure mnuSRIClick(Sender: TObject);
    procedure mnuPPYClick(Sender: TObject);
    procedure mnuSRCClick(Sender: TObject);
    procedure btnAdjustmentClick(Sender: TObject);
    procedure mnuNomClick(Sender: TObject);
    procedure mlTransMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure mlTransEndDrag(Sender, Target: TObject; X, Y: Integer);
    procedure btnCheckClick(Sender: TObject);
    procedure mnuDocTypeClick(Sender: TObject);
    procedure Properties1Click(Sender: TObject);
    procedure mlTransMultiSelect(Sender: TObject);
    procedure btnProcessClick(Sender: TObject);
    procedure btnMatchClick(Sender: TObject);
    procedure mlTransColumnClick(Sender: TObject; ColIndex: Integer;
      Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure btnClearAllClick(Sender: TObject);
    procedure TabControl1Changing(Sender: TObject;
      var AllowChange: Boolean);
  private
    { Private declarations }
    InitSize : TPoint;
    FCurrentStatement : IBankStatement;
    DispTrans    :  TFInvDisplay;
    ListFilter : TRecListFilter;
    TagCount : Array[0..1] of Integer;
    TagTotal : Array[0..1] of Double;
    FStatementForm : TfrmStatement;
    bRestore, StatementButtonClicked : Boolean;
    bOK : Boolean; //Indicates that ok button was used to close
    FHeader : BnkRHRecType;
    FExistingList : TList;
    CurrentPeriod : tLocalPeriod;
    DifferenceFolio,
    DifferenceLineNo : longint;

    { CS: 14/07/2008 - Amendments for Form Resize routines }
    IsResizing: Boolean;
    SelectedRec : Array[0..1] of Variant;
    procedure LoadList;
    procedure SetCurrencySymbol;
    procedure SetEdits(TopParent, BottomParent : TPanel);
    procedure LoadGroupList;
    function StatusString(Stat : Word; Line : Integer = 0) : string;
    procedure DisplayTrans(Mode : Byte; DetailRec : TTempTransDetails);
    procedure AddTrans(Mode : Byte; TransType : DocTypes);
    procedure WriteRec(DetailRec : TTempTransDetails);
    procedure ShowDetails;
    procedure ShowFilterString(ALabel : TLabel);
    procedure ShowReceiptWizard(IsSales : Boolean);
    function ScanMode : Boolean;
    function AddHead : Integer;
    function AddLine : Integer;
    function UpdateHead : Integer;
    function UpdateLine : Integer;
    procedure FindExistingReconcile;
    procedure ShowStatementForm;
    procedure ShowTaggedValue;
    procedure RemoveOneFilter(WhichOne : Byte);
    procedure SetFilterMenu;
    procedure SaveAllSettings;
    procedure LoadAllSettings;
    function GetRecordFromAddress(RecAddress : longint) : TTempTransDetails;
    function MultiSelectTotal : Double;
    procedure SetStatementComplete;
    procedure ShowMLoc;
    procedure SetTaggedValues;
    procedure SaveTags;
    function CreateDifferenceJournal : Boolean;
    procedure RemoveAllTags;
    procedure SetHelpContexts;
    procedure SetClearAllCaption(SetToClear : Boolean);
    procedure ClearOrUnclearAll(SetToClear : Boolean);
    procedure EnableButtons(SetOn : Boolean);
  public
    { Public declarations }
    oGL : IGeneralLedger;
    ListSettings : TRecListSettings;
    oToolkit : IToolkit3;
    procedure WMCustGetRec(Var Message  :  TMessage); Message WM_CustGetRec;
    procedure DoList;
    function GetMultiSelectRecord(WhichOne : longint) : TTempTransDetails;
    procedure GroupViewClosed(Sender : TObject);
    procedure DetailFormClosed(Sender : TObject);
    procedure StatementFormClosed(Sender : TObject);
    function TaggedValue : Double;
    procedure RefreshList;
    procedure SetCaption;
    procedure UpdateStatuses;
    procedure UpdateReconcile(bStoreRec : Boolean = True);
    procedure ShowBalances;
    procedure RunReconcileReport;
    function Reconcile(const oStat : IBankStatement) : Boolean;
    function CurrentDetailsRecord : TTempTransDetails;
  end;

  TBankScan = Object(TThreadQueue)
    public
      Currency : Byte;
      GLCode : longint;
      CallBackWindow : THandle;
      ListSettings : TRecListSettings;
      RecCount, IncludeCount : longint;
      LTmpFile      : FileVar;
      Constructor Create(AOwner  :  TObject);

      Destructor  Destroy; Virtual;

      Procedure Process; Virtual;
      Procedure Finish;  Virtual;

      Function Start  :  Boolean;
  end;


  {Object to add into thread controller - this runs through Details file building up the
   temporary btrieve file which the list uses}
  TBankScanSQL = Object(TThreadQueue)
    public
      Currency : Byte;
      GLCode : longint;
      CallBackWindow : THandle;
      ListSettings : TRecListSettings;
      RecCount, IncludeCount : longint;
      LTmpFile      : FileVar;
      SQLInsert : TStringList;
      GroupList : TList;
      FCompanyCode : String;
      sTempTable : string; //Temporay table name without path or .dat extension
      WhereClause : string;
      procedure InsertRecordsIntoTempTable(const TableName : string);
      procedure ProcessOneRecord(const TableName : string; const rDetails : TTempTransDetails);
      function GroupRecordExists(const rDetails: TTempTransDetails; var GroupDetails : TTempTransDetails) : Integer;
      function FindGroupRecord(const rDetails: TTempTransDetails) : Integer;
      procedure AddOrUpdateGroupRecord(const rDetails: TTempTransDetails);
      procedure AddGroupRecordsToQuery;
      procedure InsertReconcileRecords;
//      function GetReconciledAmountSQL : Double;
      function GetOpeningBalanceSQL : Double;
      function GetSQLRecordCount : Integer;

      Constructor Create(AOwner  :  TObject);

      Destructor  Destroy; Virtual;

      Procedure Process; Virtual;
      Procedure Finish;  Virtual;

      Function Start  :  Boolean;


  end;

  //Runs from Reconcile button on Statement or Bank Details form and tries to match lines in the transaction
  //list with lines in the statement
  TReconcile = Object(TThreadQueue)
    public
      CallBackWindow : THandle;
      StatList : TList;
      GLCode : Integer;
      LDate, LRef : string;
      ReconDate, ReconRef : string;

      FReconObj : TBankReconciliation;
      LTmpFile      : FileVar;
      Constructor Create(AOwner  :  TObject);

      Destructor  Destroy; Virtual;

      Procedure Process; Virtual;
      Procedure Finish;  Virtual;

      Function Start  :  Boolean;

  end;

  TReconcileSQL = Object(TThreadQueue)
    public
      CallBackWindow : THandle;
      StatList : TList;
      GLCode : Integer;
      LDate, LRef : string;
      ReconDate, ReconRef : string;

      FReconObj : TBankReconciliation;
      LTmpFile      : FileVar;
      Constructor Create(AOwner  :  TObject);

      Destructor  Destroy; Virtual;

      Procedure Process; Virtual;
      Procedure Finish;  Virtual;

      Function Start  :  Boolean;

  end;



  TFinaliseReconciliation = Object(TThreadQueue) //Called from process button - runs through and commits changes
    public
      CallBackWindow : THandle;
      StatList : TList;
      GLCode : Integer;
      LDate, LRef : string;
      RecCount : longint;
      bnkHeader : BnkRHRecType;
      FReconObj : TBankReconciliation;
      MTPost : ^TEntPost;
      DifferenceFolio, DifferenceLineNo : longint;
      CompletedAmount : Double;
      LTmpFile      : FileVar;
      ReconcileDate : string[8]; //PR: 20/03/2009  Added to allow Reconciliation Date on line to be set to Statement Date
      bUseReconcileDate : Boolean;
      function GetSQLRecordCount : Integer;
      Constructor Create(AOwner  :  TObject);

      Destructor  Destroy; Virtual;
      function UpdateReconcileLine(const s : string) : Integer;
      function UpdateGroupReconcileLine(const PayInRef : string; LineRec : TTempTransDetails) : Integer;
      Procedure Process; Virtual;
      Procedure Finish;  Virtual;

      Function Start  :  Boolean;

      procedure SetReconcileStatus(RStatus : Byte);

  end;


  procedure AddBankScanSQL2Thread(AOwner : TObject; Curr : Byte; GLC : Integer; CallBack : THandle;
                               Settings : TRecListSettings; Reload : Boolean = False);

  procedure AddBankScan2Thread(AOwner : TObject; Curr : Byte; GLC : Integer; CallBack : THandle;
                               Settings : TRecListSettings; Reload : Boolean = False);
  procedure AddReconcile2Thread(AOwner : TObject; CallBack : THandle; AList : TList; GLC : Integer;
                                 ARef, RRef : string; ADate, RDate : string);

  procedure AddReconcileSQL2Thread(AOwner : TObject; CallBack : THandle; AList : TList; GLC : Integer;
                                 ARef, RRef : string; ADate, RDate : string);

  //PR: 20/03/2009 Changed to pass Statement Date through - this will be used to set Reconciliation Date (R0009)
  procedure AddFinalise2Thread(AOwner : TObject; CallBack : THandle; DiffFolio, DiffLine : longint; const StatementDate : string;
                                UseReconDate : Boolean);

  procedure CreateTempFile;

  procedure UpdateGroupCleared(const PayInRef: string;   const sDate : string; Status : Byte;
    Increase: Boolean = True);

  procedure UpdateGroupMatched(const PayInRef: string;  const sDate : string;
    Increase: Boolean = True; StatLine : Integer = 0);

  procedure UpdateGroupLines(const PayInRef, LineKey : string;  const sDate : string; Status : Byte; StatLine : Integer);


var
  frmTransList: TfrmTransList;
  CurrentStatement : IBankStatement;
  TotalRecCount : longint;
  iGLCode : longint;

implementation

{$R *.dfm}

uses
  EtDateU, GlobVar, BtKeys1U, ExThrd2U,  CurrncyU,
  RecFind, BankDetl, EtStrU, GrpView, Filter, AllcWizU, PWarnU, ApiUtil, SQLCallerU,
  {$IFDEF ADDNOMWIZARD}
    AddNomWizard,
  {$ENDIF}
  ComnU2, SysU1, RecReprt, NomDefs, EtMiscU, MathUtil, SQLUtils, CtkUtil04, StrUtils, SQLQueries, AuditNotes, Math,
  oProcessLock;

  Function ColName(Const ColumnName : ShortString) : ShortString;
  Begin // ColName
    Result := GetDBColumnName('Details.Dat', ColumnName, '');
  End; // ColName




function BuildIndexPrefix : string;
begin
  Result := FullNomKey(ReconcileObj.bnkHeader.brGLCode) + LJVar(ReconcileObj.bnkHeader.brUserId, 10) +
     FullNomKey(ReconcileObj.bnkHeader.brIntRef);
end;

function BuildSQLIndex1: string;
var
  s : Str255;
begin
  s := BuildIndexPrefix;

  Result := VarBin(@s, Length(s) + 6) +
            ' + CAST(SUBSTRING(image_0, 22, 4) AS VARBINARY(4))' +
            ' + 0x21';
end;

function BuildSQLIndex2: string;
var
  s : Str255;
begin
  s := BuildIndexPrefix;

  Result := VarBin(@s, Length(s) + 10) +
            ' + CAST(SUBSTRING(image_0, 6, 4) AS VARBINARY(4))' +
            ' + CAST(SUBSTRING(image_0, 22, 4) AS VARBINARY(4))' +
            ' + 0x21';
end;

function BuildSQLIndex3: string;
var
  s : Str255;
begin
  s := BuildIndexPrefix;

  Result := VarBin(@s, Length(s) + 6) +
            ' + CAST(SUBSTRING(image_0, 26, 4) AS VARBINARY(4))' +
            ' + 0x21';
end;




procedure UpdateGroupLines(const PayInRef, LineKey : string;  const sDate : string; Status : Byte; StatLine : Integer);
var
  Res1 : Integer;
  KeyS : Str255;
  LocalTempDetailRec : TTempTransDetails;
  Idx, BFunc : Integer;
  sRef : string;
begin
//  ReconcileObj.NoUpdate := True;
  if (Trim(PayInRef) <> '') then
  begin
    //Find on PayInRef
    KeyS := LJVar(PayInRef, 16);
    Idx := 5;
    BFunc := B_GetGEq;
  end
  else
  begin
    //Find on LineKey
    KeyS := LineKey;
    Idx := 6;
    BFunc := B_GetEq;
  end;

  sRef := KeyS;
  Res1 := Find_Rec(B_GetGEq, TmpFile, RecTempF, LocalTempDetailRec, Idx, KeyS);

  while (Res1 = 0) and
    (Trim(sRef) = Trim(KeyS)) do
  begin
    if (LocalTempDetailRec.btdDocType <> 'RUN') and ReconcileObj.GroupDateMatches(LocalTempDetailRec.btdDate, sDate) then
    begin
      LocalTempDetailRec.btdStatus := Status;
      LocalTempDetailRec.btdStatLine := StatLine;
      Put_Rec(TmpFile, RecTempF, LocalTempDetailRec, 5);
      ReconcileObj.SetClearedRec(LocalTempDetailRec);
    end;

    if Idx = 6 then
      Res1 := 9 //we only want one record for groups without a PayInRef
    else
      Res1 := Find_Rec(B_GetNext, TmpFile, RecTempF, LocalTempDetailRec, Idx, KeyS);
  end;
//  ReconcileObj.NoUpdate := False;
end;

function TmpTableName(const sFullFileName: string): string;
var
  i : Integer;
begin
  Result := ExtractFilename(sFullFileName);
  i := Pos('.', Result);
  if i > 0 then
    Delete(Result, i, Length(result));
end;


procedure RemoveClearedRecsForGroup(const PayInRef : string);
var
  Res1 : Integer;
  KeyS : Str255;
  LocalTempDetailRec : TTempTransDetails;
begin
  if (Trim(PayInRef) = '') then
    Exit;

  KeyS := LJVar(PayInRef, 16);
  Res1 := Find_Rec(B_GetGEq, TmpFile, RecTempF, LocalTempDetailRec, 5, KeyS);

  while (Res1 = 0) and
    (Trim(PayInRef) = Trim(LocalTempDetailRec.btdPayInRef)) do
  begin
    if (LocalTempDetailRec.btdDocType <> 'RUN') then
      ReconcileObj.SetClearedRec(LocalTempDetailRec);
    Res1 := Find_Rec(B_GetNext, TmpFile, RecTempF, LocalTempDetailRec, 5, KeyS);
  end;

end;



procedure UpdateGroupValue(const PayInRef: string; const sDate : string; Cleared : Boolean; Status : Byte;
   Increase: Boolean = True; StatLine : Integer = 0);
var
  Res1, Res : Integer;
  KeyS, KeyChk : Str255;
  LocalTempDetailRec : TTempTransDetails;
  Found : Boolean;
  RecAddr : longint;
begin

  //PR: 16/07/2009 Modified to deal correctly with records with no PayInRef
  Found := False;
  KeyS := 'RUN' + LJVar(PayInRef, 16);
  KeyChk := KeyS;
  Res1 := Find_Rec(B_GetGEq, TmpFile, RecTempF, LocalTempDetailRec, 9, KeyS);

  while not Found and (LocalTempDetailRec.btdDocType = 'RUN') and
    (Trim(PayInRef) = Trim(LocalTempDetailRec.btdPayInRef)) do
  begin
    Found := (Res1 = 0) and (LocalTempDetailRec.btdDocType = 'RUN') and ReconcileObj.GroupDateMatches(sDate, LocalTempDetailRec.btdDate) and
      (Trim(PayInRef) = Trim(LocalTempDetailRec.btdPayInRef));

    if not Found then
      Res1 := Find_Rec(B_GetNext, TmpFile, RecTempF, LocalTempDetailRec, 9, KeyS);
  end;

  if not Found then //No reference, so PayInRef holds LineKey of Itemised Rec which will be in FullPayInRef of Group Rec
  begin
    KeyS := 'RUN';
    Res1 := Find_Rec(B_GetGEq, TmpFile, RecTempF, LocalTempDetailRec, 9, KeyS);
    while (Res1 = 0) and (LocalTempDetailRec.btdDocType = 'RUN') and not Found do
    begin
      Found := (PayInRef = LocalTempDetailRec.btdFullPayInRef) and ReconcileObj.GroupDateMatches(sDate, LocalTempDetailRec.btdDate);

      if not Found then
        Res1 := Find_Rec(B_GetNext, TmpFile, RecTempF, LocalTempDetailRec, 9, KeyS);
    end;
  end;

  if Found then
  begin
    if Cleared then
    begin
      if Increase then
      begin
        Inc(LocalTempDetailRec.btdNumberCleared);
        if LocalTempDetailRec.btdNumberCleared = LocalTempDetailRec.btdNoOfItems then
        begin
          LocalTempDetailRec.btdStatus := 1;
          LocalTempDetailRec.btdReconDate := frmTransList.ListSettings.ReconDate;
          ReconcileObj.SetClearedRec(LocalTempDetailRec);
        end;
      end
      else
      begin
        Dec(LocalTempDetailRec.btdNumberCleared);
        if LocalTempDetailRec.btdNoOfItems = 1 then
           LocalTempDetailRec.btdStatus := Status
        else
          LocalTempDetailRec.btdStatus := 0;
        LocalTempDetailRec.btdReconDate := '        ';
        ReconcileObj.SetClearedRec(LocalTempDetailRec);
      end;
    end
    else
    begin //Matched
      if Increase then
      begin
        Inc(LocalTempDetailRec.btdNumberMatched);
        if LocalTempDetailRec.btdNumberMatched = LocalTempDetailRec.btdNoOfItems then
          LocalTempDetailRec.btdStatus := iMatch;
        LocalTempDetailRec.btdStatLine := StatLine;
      end
      else
//        Dec(LocalTempDetailRec.btdNumberMatched);
      begin
        LocalTempDetailRec.btdNumberMatched := 0;
        LocalTempDetailRec.btdStatus := 0;
        LocalTempDetailRec.btdStatLine := 0;
      end;
    end;

    Put_Rec(TmpFile, RecTempF, LocalTempDetailRec, 9);
  end;
end;

procedure UpdateGroupCleared(const PayInRef: string; const sDate : string;  Status : Byte;
  Increase: Boolean = True);
begin
//  ReconcileObj.NoUpdate := True;
  UpdateGroupValue(PayInRef, sDate, True, Status, Increase);
// ReconcileObj.NoUpdate := False;
end;

procedure UpdateGroupMatched(const PayInRef: string; const sDate : string;
  Increase: Boolean = True; StatLine : Integer = 0);
begin
//  ReconcileObj.NoUpdate := True;
  UpdateGroupValue(PayInRef, sDate, False, 0, Increase, StatLine);
//  ReconcileObj.NoUpdate := False;
end;

function FormatOurRef(const s : string) : string;
begin
  Result := s;
  while Length(Result) < 9 do
    Insert('0', Result, 4);
end;

function GetReconciledAmountSQL: Double;
var
  V : Variant;
  Res : Integer;
  sQuery : String;
begin
  sQuery := Format(SQL_SUM_RECONCILED_QUERY, [TmpTableName(FullTmpFileName)]);
  Res := SQLUtils.SQLFetch(sQuery, 'RecAmount', SetDrive, V);
  if Res = 0 then
    Result := V
  else
    Result := 0;
end;


procedure TfrmTransList.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  if not bOK and (ReconcileObj.bnkHeader.brStatus <> bssComplete) then
  begin
    ReconcileObj.Delete; //get rid of any reconciliation records added
    if ReconcileObj.WasExistingReconcile then
    begin //We started from an existing reconcile so restore to that state
      ReconcileObj.bnkHeader := FHeader;
      ReconcileObj.AddHeader;
      ReconcileObj.LoadFromList(FExistingList);
    end;
  end
  else
  if bOK then
     SaveTags;

  if not bRestore then SaveAllSettings;
  Action := caFree;
  if Assigned(frmBankDetails) and (frmBankDetails.ParentHandle = Self.Handle) then
    frmBankDetails.btnCloseClick(frmbankdetails);
  if Assigned(frmGroupView) then
    frmGroupView.btnCloseClick(frmGroupView);
  mlTrans.Active := False;
end;

procedure TfrmTransList.FormCreate(Sender: TObject);

  procedure MoveUp(AButton : TSBSButton);
  begin
    AButton.Top := AButton.Top - 24;
  end;
begin
  IsResizing := False;
  FCurrentStatement := nil;
  sMiscDirLocation := SetDrive;
  oSettings.EXEName := ExtractFilename(GetModuleName(HInstance));
  oSettings.UserName := GetUserID;
  bRestore := False;
  bOK := False;
  StatementButtonClicked := False;

  Height := 365;
  Width := 554;
  Left := 1;
  Top := 1;
  InitSize.X := Width;
  InitSize.Y := Height;

  TagCount[0] := 0;
  TagCount[1] := 0;

  TagTotal[0] := 0;
  TagTotal[1] := 0;

  FCurrentStatement := CurrentStatement;

  LoadAllSettings;

  CurrentPeriod := GetLocalPr(0);

  //Check passwords
  btnProcess.Enabled := ChkAllowed_In(196);
  btnClear.Enabled := btnProcess.Enabled;
  btnUnclear.Enabled := btnProcess.Enabled;
  btnTag.Enabled := btnProcess.Enabled;
  btnMatch.Enabled := btnProcess.Enabled;
  btnAdjustment.Enabled := ChkAllowed_In(356) or ChkAllowed_In(361) or ChkAllowed_In(365) or
                            ChkAllowed_In(370) or ChkAllowed_In(25);
  mnuNom.Enabled := ChkAllowed_In(25);
  mnuPPY.Enabled := ChkAllowed_In(365);
  mnuPPI.Enabled := ChkAllowed_In(370);
  mnuSRC.Enabled := ChkAllowed_In(356);
  mnuSRI.Enabled := ChkAllowed_In(361);

  {$IFNDEF LTE}
  if not EBankOn then
  begin
    btnStatement.Visible := False;
    MoveUp(btnView);
    MoveUp(btnAdjustment);
    MoveUp(btnFilter);
    MoveUp(btnCheck);
  end;
  {$ENDIF}
  SelectedRec[0] := NULL;
  SelectedRec[1] := NULL;
//  ReconcileObj.DeleteAllTags;
end;

procedure TfrmTransList.btnCancelClick(Sender: TObject);
begin
  Close;
end;

procedure TfrmTransList.btnOKClick(Sender: TObject);
begin
  UpdateReconcile;
  bOK := True;
  Close;
end;

procedure TfrmTransList.FormResize(Sender: TObject);
const
  mlTop = 48;
var
  mlHeight : Integer;
begin
  Panel1.Width := ClientWidth - 4;
  pnlButtons.Left := Panel1.Width - 6 - pnlButtons.Width;
//  TabControl1.Width := pnlButtons.Left - 2;
  Panel3.Width := TabControl1.Width - pnlButtons.Width - 4;
  mlTrans.Width := Panel3.Width - 12;

  Panel1.Height := ClientHeight - 2;
  pnlButtons.Height := Panel1.Height - pnlButtons.Top -  8;

//  TabControl1.Height := Panel1.Height - 8;
  mlHeight := Panel3.Height - 104;

  { CS: 14/04/2008 - Amendments for Form Resize routines. Only updates
    the height of the list when the user stops resizing the form. This is to
    prevent the columns being constantly recalculated as the user sizes a
    form. }
  if not IsResizing then
    mlTrans.Height := mlHeight;

  Panel3.Height := TabControl1.Height - 31;

  ScrollBox1.Height := pnlButtons.Height - ScrollBox1.Top - 2;
end;

procedure TfrmTransList.DoList;
begin
  if ReconcileObj.WasExistingReconcile then
  begin
    FHeader := ReconcileObj.bnkHeader;
    FExistingList := ReconcileObj.SaveToList;
  end;
  SetCurrencySymbol;
  SetCaption;
//  ceStatBalance.Value := ListSettings.StatBalance;

  // PKR. 29/03/2016. ABSEXCH-17390. Remove Warnings
  btData.FileName := IncludeTrailingPathDelimiter(SetDrive) + TmpFilename;
//  Case ReconcileObj.bnkHeader.brInitSeq of
  Case ListSettings.InitialSequence of
    0 : mlTrans.SortColIndex := isDate;
    1 : mlTrans.SortColIndex := isRef;
    2 : mlTrans.SortColIndex := isAmount;
  end;
  btnClearAll.Visible := ListSettings.UseReconDate;
  mlTrans.Options.MultiSelection := ListSettings.MultiSelect;
//  btnTag.Enabled := not ListSettings.MultiSelect;
  mlTrans.Active := True;
  FormResize(Self);
  if ListSettings.StatBalance <> 0.00 then
    ReconcileObj.bnkHeader.brStatBal := ListSettings.StatBalance
  else
  if Assigned(FCurrentStatement) then
    ReconcileObj.bnkHeader.brStatBal := OpeningBalance + FCurrentStatement.bsBalance;
  if ListSettings.AutoReconcile then
    Reconcile(FCurrentStatement)
  else
  if Assigned(FCurrentStatement) then
  begin
    ShowStatementForm;
  end;
  ShowBalances;
  SetTaggedValues;
  ShowTaggedValue;
//  ActiveControl := mlTrans;
end;

procedure TfrmTransList.FormDestroy(Sender: TObject);
var
  Res : Integer;
begin
  Res := Close_File(TmpFile);
  //Need to stop the list using the temp file before we can delete it
  //Delete all temp files
  DeleteTable(FullTmpFileName);

  DeleteFile(ChangeFileExt(FullTmpFileName, '.tmp'));
  DeleteFile(ChangeFileExt(FullTmpFileName, '.lck'));
  frmTransList := nil;
  CurrentStatement := nil;
  FreeReconcileObj;
end;

function CreateTempFileName : string;
var
  TempPath : AnsiString;
  FName : PChar;
  Res : longint;
begin
  FName := StrAlloc(MAX_PATH + 1);
  TempPath := IncludeTrailingPathDelimiter(SetDrive) + 'SWAP\';
  Try
    Res := GetTempFileName(Pchar(TempPath), 'REC', 0, FName);
    Result := StrPas(FName);
  Finally
    StrDispose(FName);
  End;
end;

procedure CreateTempFile;
var
  Res, ErrMode : Integer;
  FName, ErrS : string;
begin
  ErrMode := 0;
  TmpFileName := 'SWAP\' + ExtractFileName(ChangeFileExt(CreateTempFileName, '.dat'));
  FullTmpFileName := IncludeTrailingPathDelimiter(SetDrive) + TmpFileName;
{  ShowMessage('Tmpfile: ' + QuotedStr(TmpFileName) + #10 +
              'SetDrive: ' + QuotedStr(SetDrive) + #10 +
              'FullTmpFileName: ' + QuotedStr(FullTmpFileName));}

  Res :=  Make_File(Tmpfile, FullTmpFileName, TmpFileSpecOfS^, TmpFileSpecLen);

  if Res <> 0 then
    ErrMode := 2
  else
  begin
    Res := Open_file(TmpFile, FullTmpFileName, 0);

    if Res <> 0 then
      ErrMode := 3;
  end;

  if ErrMode > 0 then
  begin
    Case ErrMode of
      2 : ErrS := 'create';
      3 : ErrS := 'open';
    end;

    ShowMessage('Unable to ' + ErrS + ' temporary file ' + FName + #10#10 +
                'Error Code: ' + IntToStr(Res));
  end;

end;

procedure ClearTempFile;
var
  Res : Integer;
  KeyS : Str255;
begin
  if SQLUtils.UsingSQL then
  begin
    SQLUtils.DeleteRows(CompanyCodeFromPath(oRecToolkit as IToolkit, SetDrive), TmpFileName, '1 = 1');
  end
  else
  begin
    Res := Find_Rec(B_GetFirst, Tmpfile, RecTempF, TempDetailRec, 0, KeyS);

    while Res = 0 do
    begin
      Res := Delete_Rec(TmpFile, RecTempF, 0);

      if Res <> 0 then
        raise Exception.Create('Unable to delete record. Btrieve error: ' + IntToStr(Res));

      Res := Find_Rec(B_GetFirst, Tmpfile, RecTempF, TempDetailRec, 0, KeyS);
    end;
  end;
end;

procedure TfrmTransList.LoadList;
begin
end;

function TfrmTransList.StatusString(Stat : Word; Line : Integer = 0) : string;
begin
  Case Stat of
    0 : Result := '';
    1 : Result := 'Cleared';
    2 : Result := 'Cancelled';
    3 : Result := 'Returned';
  end; //Case
  if Stat and iTag = iTag then
    Result := 'Tagged';
  if Stat and iMatch = iMatch then
    Result := Format('Matched (%d)', [Line]);
  if Stat and iComplete = iComplete then
    Result := 'Complete';
end;



procedure TfrmTransList.btDataGetFieldValue(Sender: TObject;
  PData: Pointer; FieldName: String; var FieldValue: String);
var
  TransDetails : PTempTransDetails;

  function ItemString(const Ref : string; NoOfItems : integer) : string;
  begin
    if Trim(Ref) = '' then
      Result := ''
    else
    begin
      if NoOfItems > 1 then
        Result := Format('%s %d Items', [Ref, NoOfItems])
      else
        Result := Format('%s %d Item', [Ref, NoOfItems]);
    end;
  end;

  function GroupStatusString(Items, Cleared, Matched : Integer) : string;
  begin
    if Matched > 0 then
    begin
      if Matched = Items then
        Result := 'Matched'
      else
        Result := Format('%d of %d Matched', [Matched, Items]);
    end
    else
    if Cleared = Items then
      Result := 'Cleared'
    else
      Result := 'Part Clrd';
  end;

begin
  TransDetails := PData;
  with TransDetails^ do
  begin
    Case FieldName[1] of
      'D'  : FieldValue := btdDocType;
      'P'  : FieldValue := PPR_OutPr(btdPeriod, btdYear);
      'A'  : if TabControl1.TabIndex = 0 then
                FieldValue := Trim(btdAcCode);
      'N'  : if TabControl1.TabIndex = 0 then
                FieldValue := Trim(btdPayInRef)
             else
                FieldValue := ItemString(Trim(btdPayInRef), btdNoOfItems);
      'M'  : FieldValue := ProcessValue(btdAmount);
      'S'  : begin
               if (TabControl1.TabIndex = 0) and {(btdStatus <> 1) and} ((ReconcileObj.FindLine(btdLineKey, 1) = 0) {or
                   ({(btdDocType = 'RUN') and ReconcileObj.FindGroupMatch(btdPayInRef, btdLineKey)}) then
                 FieldValue := StatusString(ReconcileObj.bnkDetail.brLineStatus,
                                            ReconcileObj.bnkDetail.brStatLine)
               else
               if (btdDocType = 'RUN') and ((btdNumberCleared > 0) or (btdNumberMatched > 0)) then
                 FieldValue := GroupStatusString(btdNoOfItems, btdNumberCleared, btdNumberMatched)
               else
                 FieldValue := StatusString(btdStatus);
             end;
      'T'  : //if TabControl1.TabIndex = 0 then
                FieldValue := POutDate(btdDate);
      'O'  : FieldValue := Trim(btdOurRef);
      'L'  : FieldValue := Trim(btdDesc);
      //PR: 20/03/2009 Added Reconciliation Date
      'R'  : if ValidDate(btdReconDate) and (btdReconDate < MaxUntilDate) then
               FieldValue := POutDate(btdReconDate)
             else
               FieldValue := '';

    end;
  end;
end;

procedure TfrmTransList.SetCurrencySymbol;
var
  i : integer;
begin
  CurrencySymbol := Trim(oRecToolkit.SystemSetup.ssCurrency[ListSettings.WantedCurrency].scSymbol);
  for i := 1 to Length(CurrencySymbol) do
    if CurrencySymbol[i] = #156 then
      CurrencySymbol[i] := '£';
end;

{ TBankScanSQL }

function TBankScanSQL.GroupRecordExists(const rDetails: TTempTransDetails; var GroupDetails : TTempTransDetails) : Integer;
var
  i : integer;
begin
  Result := 4;
  i := FindGroupRecord(rDetails);
  if i > -1 then
  begin
    Result := 0;
    GroupDetails := PTempTransDetails(GroupList[i])^;
  end;
end;

constructor TBankScanSQL.Create(AOwner: TObject);
begin
    Inherited Create(AOwner);

    fTQNo:=3;
    fCanAbort:=BOn;

//    IsParentTo:=BOn;

    fOwnMT:=BOn; {* This must be set if MTExLocal is created/destroyed by thread *}

    MTExLocal:=nil;
end;

destructor TBankScanSQL.Destroy;
begin
  inherited;
end;

procedure TBankScanSQL.Finish;
begin
  inherited;
  TotalRecCount := RecCount;
  ReconcileObj.CloseSession;
  PostMessage(CallBackWindow,WM_CustGetRec,55,RecCount);
//  Dispose(MTExLocal, Destroy);
end;

procedure TBankScanSQL.InsertRecordsIntoTempTable(const TableName: string);
const
  XRateNames : Array[False..True] of String[13] = ('tlCompanyRate', 'tlDailyRate');
var
  Res : Integer;
  i : Integer;
  sSQLQuery : String;
  sXRate : string;
  sGroupDate : string;
begin
  ShowStatus(1,'Inserting records');
  sSQLQuery := Format(SQL_INSERT_FIELDS, [FCompanyCode, TableName, FCompanyCode, GLCode]);
  if Currency <> 0 then
    sSQLQuery := sSQLQuery + Format(SQL_CURRENCY,[Currency]);
  if ListSettings.UnclearedOnly then
    sSQLQuery := sSQLQuery + SQL_UNCLEARED_ONLY
  else
  if ListSettings.UseReconDate then
    sSQLQuery := sSQLQuery + Format(SQL_USE_RECONCILE_DATE, [ListSettings.ReconDate]);

  Try
    //Insert item records
    Res := SQLUtils.ExecSQLEx(sSQLQuery, SetDrive, I_TIMEOUT);
    if Res <> 0 then
      raise Exception.Create(SQLUtils.LastSQLError);
    UpdateProgress(25);

    RecCount := GetSQLRecordCount;

    //Update to correct sign (+ve/-ve) according to docType
    sSQLQuery := Format(SQL_UPDATE_AMOUNTS, [FCompanyCode, TableName]);
    Res := SQLUtils.ExecSQLEx(sSQLQuery, SetDrive, I_TIMEOUT);
    if Res <> 0 then
      raise Exception.Create(SQLUtils.LastSQLError);
    UpdateProgress(50);

    {SS 27/04/2016 2016-R2
    ABSEXCH-15137 : Bank Rec wizard PPI Issue in SQL version showing both invoice and payment line amounts as negatives.
    -Update reconcile amount for the PPI and SRI.}
    sSQLQuery := Format(SQL_UPDATE_NETVALUE, [FCompanyCode, TableName,FCompanyCode,GLCode]);
    Res := SQLUtils.ExecSQLEx(sSQLQuery, SetDrive, I_TIMEOUT);
    if Res <> 0 then
      raise Exception.Create(SQLUtils.LastSQLError);
    UpdateProgress(50);

    if Currency = 0 then
    begin
      //Convert values to base
      sXRate := XRateNames[UseCoDayRate];
      sSQLQuery := Format(SQL_CONVERT_TO_BASE, [TableName, sXRate, sXRate]);
      Res := SQLUtils.ExecSQLEx(sSQLQuery, SetDrive, I_TIMEOUT);
      if Res <> 0 then
        raise Exception.Create(SQLUtils.LastSQLError);
    end;

    //PR: 20/01/2010 Added check for running check
    if ReconcileObj.WasExistingReconcile or ListSettings.IsCheck then
    begin
      //GS: 29/02/2012 ABSEXCH-11785 : added formatting checks to certain string arguments
      //(to check for quote chars that could break SQLs interpretation)
      //user IDs can potentially contain ['] chars; so preform a format check
      sSQLQuery := Format(SQL_UPDATE_STORED_STATUSES, [sTempTable,
                                             LJVar(TSQLCaller.CompatibilityFormat(ReconcileObj.bnkHeader.brUserId), 10),
                                             ReconcileObj.bnkHeader.brIntRef]);
      Res := SQLUtils.ExecSQLEx(sSQLQuery, SetDrive, I_TIMEOUT);
      if Res <> 0 then
        raise Exception.Create(SQLUtils.LastSQLError);

    end;

    if ListSettings.lsGroupBy = gbRefAndDate then
      sGroupDate := 'btdDate'
    else
      sGroupDate := '''''';


    sSQLQuery := Format(SQL_GROUP_QUERY, [FCompanyCode, TableName, sGroupDate, FCompanyCode, TableName]);

    //PR: 17/10/2010 Added option to group by ref and date or just ref
    if ListSettings.lsGroupBy = gbRefAndDate then
      sSQLQuery := sSQLQuery + SQL_GROUP_CLAUSE_DATE
    else
      sSQLQuery := sSQLQuery + SQL_GROUP_CLAUSE_NODATE;

    Res := SQLUtils.ExecSQLEx(sSQLQuery, SetDrive, I_TIMEOUT);
    if Res <> 0 then
      raise Exception.Create(SQLUtils.LastSQLError);
    UpdateProgress(75);

    sSQLQuery := Format(SQL_GROUP_QUERY_2, [FCompanyCode, TableName, FCompanyCode, TableName]);
    Res := SQLUtils.ExecSQLEx(sSQLQuery, SetDrive, I_TIMEOUT);
    if Res <> 0 then
      raise Exception.Create(SQLUtils.LastSQLError);

    //PR: 20/01/2010 Added check for running check
    if not ListSettings.UnclearedOnly or ReconcileObj.WasExistingReconcile or ListSettings.IsCheck then
    begin
      //PR: 17/10/2010 Added option to group by ref and date or just ref
      if ListSettings.lsGroupBy = gbRefAndDate then
        sSQLQuery := Format(SQL_GROUP_QUERY_3, [TableName, TableName])
      else
        sSQLQuery := Format(SQL_GROUP_QUERY_3_NODATE, [TableName, TableName]);

      Res := SQLUtils.ExecSQLEx(sSQLQuery, SetDrive, I_TIMEOUT);
      if Res <> 0 then
        raise Exception.Create(SQLUtils.LastSQLError);

      {Not sure yet if we need this...  }
      sSQLQuery := Format(SQL_GROUP_QUERY_4, [TableName]);
      Res := SQLUtils.ExecSQLEx(sSQLQuery, SetDrive, I_TIMEOUT);
      if Res <> 0 then
        raise Exception.Create(SQLUtils.LastSQLError);

      //PR: 20/01/2010 Added queries for setting Group Matching statuses

      //PR: 17/10/2010 Added option to group by ref and date or just ref
      if ListSettings.lsGroupBy = gbRefAndDate then
        sSQLQuery := Format(SQL_GROUP_QUERY_5, [TableName, TableName])
      else
        sSQLQuery := Format(SQL_GROUP_QUERY_5_NODATE, [TableName, TableName]);

      Res := SQLUtils.ExecSQLEx(sSQLQuery, SetDrive, I_TIMEOUT);
      if Res <> 0 then
        raise Exception.Create(SQLUtils.LastSQLError);

      {Not sure yet if we need this...  }
      sSQLQuery := Format(SQL_GROUP_QUERY_6, [TableName]);
      Res := SQLUtils.ExecSQLEx(sSQLQuery, SetDrive, I_TIMEOUT);
      if Res <> 0 then
        raise Exception.Create(SQLUtils.LastSQLError);
    end;


    sSQLQuery := Format(SQL_UPDATE_GROUP_LINEKEYS, [FCompanyCode, TableName]);
    Res := SQLUtils.ExecSQLEx(sSQLQuery, SetDrive, I_TIMEOUT);
    if Res <> 0 then
      raise Exception.Create(SQLUtils.LastSQLError);

    sSQLQuery := Format(SQL_UPDATE_GROUP_LINEKEYS2, [FCompanyCode, TableName]);
    Res := SQLUtils.ExecSQLEx(sSQLQuery, SetDrive, I_TIMEOUT);
    if Res <> 0 then
      raise Exception.Create(SQLUtils.LastSQLError);

    if not ListSettings.UnclearedOnly and not ReconcileObj.WasExistingReconcile then
      InsertReconcileRecords;

    if ReconcileObj.WasExistingReconcile then
    begin
      //GS: 29/02/2012 ABSEXCH-11785 : added formatting checks to certain string arguments
      //(to check for quote chars that could break SQLs interpretation)
      //user IDs can potentially contain ['] chars; so preform a format check
      sSQLQuery := Format(SQL_UPDATE_TAGS, [TableName, iTag, LJVar(TSQLCaller.CompatibilityFormat(ReconcileObj.bnkHeader.brUserId), 10),
                                             ReconcileObj.bnkHeader.brIntRef]);
      Res := SQLUtils.ExecSQLEx(sSQLQuery, SetDrive, I_TIMEOUT);
      if Res <> 0 then
        raise Exception.Create(SQLUtils.LastSQLError);
    end;

  Except
    On E:Exception do
    begin
    {$IFDEF PR_DEBUG}
      with TStringList.Create do
      Try
        Add(E.Message);
        Add(sSQLQuery);
      Finally
//        SaveToFile('c:\TransList_sqlerror.txt');
        Free;
      End;
    {$ELSE}
      RaiseSQLError('TBankScanSQL.InsertRecords',E.Message, sSQLQuery);
    {$ENDIF}
    end;
  End;
end;

procedure TBankScanSQL.Process;
var
  Res, Res1 : Integer;
  KeyS, KeyChk, RecKeyS, KeyS1 : Str255;
  c : integer;
  LocalTempDetailRec : TTempTransDetails;
  GroupCount, UpCount : longint;
  dTmp, ThisAmount : Double;
  tmpStat : Integer;
  StatusSet : Boolean;
  StartTime, Duration : Cardinal;
  //PR:
  CacheID, SQLRes : longint;
  Columns : AnsiString;

  function ConvertValue(Val : Double; XRate : CurrTypes; Curr : Byte) : Double;
  begin
    Result := Conv_TCurr(Val,
                         XRate[(Syss.TotalConv=XDayCode)], Curr, 0, False);
  end;


begin
  sTempTable := TmpTableName(FullTmpFileName);
  SQLInsert := TSTringList.Create;
  GroupList := TList.Create;
  StartTime := GetTickCount;
  c := 0;
  IncludeCount := 0;
  //PR: 06/08/2013 ABSEXCH-13949 Opening balance is now set in ShowBalances below.
//  OpeningBalance := GetOpeningBalanceSQL;
  OpenUncleared := 0;
  InMainThread:=BOn;
  GroupCount := 0;
  Inherited Process;
  Res := Open_fileCID(LTmpFile, FullTmpFileName, 0, MTExLocal^.ExClientID);
  ShowStatus(0,'Building bank transaction list');
  KeyS := FullNomKey(GLCode) + #0 + Char(Currency);
  KeyChk := KeyS;

{  if SQLUtils.UsingSQL then
  begin
    ReconcileObj.CompanyCode := FCompanyCode;
    ReconcileObj.CacheAdds := True;
    Columns := '';
    SQLRes := CreateCustomPrefillCache(SetDrive + Filenames[IDetailF],
                             WhereClause, Columns, CacheID, MTExLocal^.ExClientID);
  end;}

  With MTExLocal^ do
  Try
    if SQLUtils.UsingSQL {and (SQLInsert.Count > 0)} then
    begin
      InsertRecordsIntoTempTable(sTempTable);
      ReconcileObj.CacheAdds := False;
    end;
    Duration := GetTickCount - StartTime;
    {$IFDEF PRDEBUG}
    with TStringList.Create do
    Try
      Add(IntToStr(Duration));
//      SaveToFile('c:\duration.txt');
    Finally
      Free;
    End;
    {$ENDIF}
  Finally
    CloseClientIDSession(MTExLocal^.ExClientId);
    UpdateProgress(100);
    MTExLocal^.Close_Files;
    if Assigned(SQLInsert) then
      SQLInsert.Free;
    if Assigned(GroupList) then
      GroupList.Free;
  End;

end;

  procedure AddBankScan2Thread(AOwner : TObject; Curr : Byte; GLC : Integer; CallBack : THandle;
                               Settings : TRecListSettings; Reload : Boolean = False);
  Var
    LScan :  ^TBankScan;

  Begin

    If (Create_BackThread) then
    Begin
      New(LScan,Create(AOwner));

      try
        With LScan^ do
        Begin
          Currency := Curr;
          GLCode := GLC;
          CallBackWindow := CallBack;
          ListSettings := Settings;
          If (Start) and (Create_BackThread) then
          Begin
            if Reload then
            begin
              ClearTempFile;
              ListSettings.ExistingReconcile := True;
              ListSettings.IsCheck := Reload;
              ReconcileObj.LoadReconciledAmount;
            end
            else
              CreateTempFile;
            With BackThread do
              AddTask(LScan,'Reconcile Bank Account ' + IntToStr(GLC));
          end
          else
          Begin
            Set_BackThreadFlip(BOff);
            Dispose(LScan,Destroy);
          end;
        end; {with..}

      except
        Dispose(LScan,Destroy);

      end; {try..}
    end; {If process got ok..}
  end;

  procedure AddBankScanSQL2Thread(AOwner : TObject; Curr : Byte; GLC : Integer; CallBack : THandle;
                               Settings : TRecListSettings; Reload : Boolean = False);
  Var
    LScan :  ^TBankScanSQL;

  Begin

    If (Create_BackThread) then
    Begin
      New(LScan,Create(AOwner));

      try
        With LScan^ do
        Begin
          Currency := Curr;
          GLCode := GLC;
          CallBackWindow := CallBack;
          ListSettings := Settings;
          If (Start) and (Create_BackThread) then
          Begin
            if Reload then
            begin
              ClearTempFile;
              ListSettings.ExistingReconcile := True;
              ListSettings.IsCheck := Reload;
              ReconcileObj.LoadReconciledAmount;
            end
            else
              CreateTempFile;
            With BackThread do
              AddTask(LScan,'Reconcile Bank Account ' + IntToStr(GLC));
          end
          else
          Begin
            Set_BackThreadFlip(BOff);
            Dispose(LScan,Destroy);
          end;
        end; {with..}

      except
        Dispose(LScan,Destroy);

      end; {try..}
    end; {If process got ok..}
  end;



procedure TBankScanSQL.ProcessOneRecord(const TableName : string; const rDetails : TTempTransDetails);
//Adds one record into the TempDetails SQL stringlist
var
  s : string;

  function RemoveDodgyChars(const sDesc : string) : string;
  begin
    if Pos(S_QUOTE, sDesc) > 0 then
      Result :=AnsiReplaceStr(sDesc, S_QUOTE, '')
    else
      Result := sDesc;
  end;

begin
  with rDetails do
  //GS 28/02/2012 ABSEXCH-11785: perform a format check on the account code;
  //deals with any single quotes in the acoount code
  s := Format(SQL_INSERT_FIELDS, [FCompanyCode, TableName, btdDocType, btdYear, btdPeriod, TSQLCaller.CompatibilityFormat(btdAcCode), RemoveDodgyChars(btdDesc),
                                  btdAmount, btdStatus, btdDate, VarBin(@btdLineKey[0], Length(btdLineKey) + 1),
                                  VarBin(@btdPayInRef[0], Length(btdPayInRef) + 1), btdOurRef,
                                  VarBin(@btdFullPayInRef[0], Length(btdFullPayInRef) + 1),
                                  VarBin(@btdIdDocHed, SizeOf(DocTypes) + (SizeOf(longint) * 8) + 9)]);
  SQLInsert.Add(s);
end;

function TBankScanSQL.Start: Boolean;
Var
  mbRet  :  Word;
  KeyS   :  Str255;
  KeyChk :  Str255;
  Res : Integer;
  SQLREs, CacheId : Integer;
  Columns : string;
Begin
  FCompanyCode := CompanyCodeFromPath(oRecToolkit as IToolkit, SetDrive);
  OutputDebugString(PChar('Main Thread = ' + IntToStr(GetCurrentThreadID)));
  Result:=BOn;
  RecCount := 0;
  ReconcileObj.bnkHeader.brReconRef := ListSettings.Ref;
  If (Not Assigned(MTExLocal)) then { Open up files here }
  Begin
    New(MTExLocal,Create(cidBankRec1));

    try
      With MTExLocal^ do
      Try
        Open_System(IDetailF, IDetailF);
     Finally
        if UsingSQL then
        begin
          CloseClientIDSession(MTExLocal^.ExClientId);
        end;

      End;
    except
      Dispose(MTExLocal,Destroy);
      MTExLocal:=nil;

    end; {Except}

    Result:=Assigned(MTExLocal);
  end;
end;


//===================================================================================================================
procedure AddReconcile2Thread(AOwner : TObject; CallBack : THandle; AList : TList; GLC : Integer;
                                 ARef, RRef : string; ADate, RDate : string);
  Var
    LReconcile :  ^TReconcile;

  Begin

    If (Create_BackThread) then
    Begin
      New(LReconcile,Create(AOwner));

      try
        With LReconcile^ do
        Begin
          StatList := AList;
          GLCode := GLC;
          LDate := ADate;
          LRef := ARef;
          ReconDate := RDate;
          ReconRef := RRef;
          CallBackWindow := CallBack;
          If (Start) and (Create_BackThread) then
          Begin
            With BackThread do
              AddTask(LReconcile,'Reconcile Statement');
          end
          else
          Begin
            Set_BackThreadFlip(BOff);
            Dispose(LReconcile,Destroy);
          end;
        end; {with..}

      except
        Dispose(LReconcile,Destroy);

      end; {try..}
    end; {If process got ok..}
  end;

//===================================================================================================================
procedure AddReconcileSQL2Thread(AOwner : TObject; CallBack : THandle; AList : TList; GLC : Integer;
                                 ARef, RRef : string; ADate, RDate : string);
  Var
    LReconcile :  ^TReconcileSQL;

  Begin

    If (Create_BackThread) then
    Begin
      New(LReconcile,Create(AOwner));

      try
        With LReconcile^ do
        Begin
          StatList := AList;
          GLCode := GLC;
          LDate := ADate;
          LRef := ARef;
          ReconDate := RDate;
          ReconRef := RRef;
          CallBackWindow := CallBack;
          If (Start) and (Create_BackThread) then
          Begin
            With BackThread do
              AddTask(LReconcile,'Reconcile Statement');
          end
          else
          Begin
            Set_BackThreadFlip(BOff);
            Dispose(LReconcile,Destroy);
          end;
        end; {with..}

      except
        Dispose(LReconcile,Destroy);

      end; {try..}
    end; {If process got ok..}
  end;


procedure AddFinalise2Thread(AOwner : TObject; CallBack : THandle; DiffFolio, DiffLine : longint; const StatementDate : string;
                             UseReconDate : Boolean);
  Var
    LReconcile :  ^TFinaliseReconciliation;

  Begin

    If (Create_BackThread) then
    Begin
      New(LReconcile,Create(AOwner));

      try
        With LReconcile^ do
        Begin
{          StatList := AList;
          GLCode := GLC;
          LDate := ADate;
          LRef := ARef;}
          CallBackWindow := CallBack;
          DifferenceFolio := DiffFolio;
          DifferenceLineNo := DiffLine;
          bUseReconcileDate := UseReconDate;
          //PR: 20/03/2009 Changed to use Statement Date as Reconciliation Date
          if ValidDate(StatementDate) then
            ReconcileDate := StatementDate
          else
            ReconcileDate := Today;
          If (Start) and (Create_BackThread) then
          Begin
            With BackThread do
              AddTask(LReconcile,'Finalise bank reconciliation');
          end
          else
          Begin
            Set_BackThreadFlip(BOff);
            Dispose(LReconcile,Destroy);
          end;
        end; {with..}

      except
        Dispose(LReconcile,Destroy);

      end; {try..}
    end; {If process got ok..}
  end;






procedure TfrmTransList.TabControl1Change(Sender: TObject);
var
  ShowDateCols : Boolean;
begin
  if not VarIsNull(SelectedRec[TabControl1.TabIndex]) then
    mlTrans.Position := SelectedRec[TabControl1.TabIndex];
  mlTrans.RefreshDB;
  ShowTaggedValue;
  SetHelpContexts;

  ShowDateCols := (TabControl1.TabIndex = 0) or (ListSettings.lsGroupBy = gbRefAndDate);

  mlTrans.DesignColumns[5].Visible := ShowDateCols;
  mlTrans.DesignColumns[6].Visible := ShowDateCols;

//  ActiveControl := mlTrans;
end;

procedure TfrmTransList.SetEdits(TopParent, BottomParent: TPanel);
begin
  Label1.Parent := TopParent;
  Label2.Parent := TopParent;
  Label3.Parent := TopParent;

  Label4.Parent := BottomParent;
  Label5.Parent := BottomParent;
  Label6.Parent := BottomParent;

  ceStatBalance.Parent := TopParent;
  ceDifference.Parent  := TopParent;
  ceOpenBalance.Parent := TopParent;

  ceCurrent.Parent    := BottomParent;
  ceReconciled.Parent := BottomParent;
  ceTagged.Parent     := BottomParent;
end;

procedure TfrmTransList.LoadGroupList;
var
  Res : longint;
  CurrentRef, CurrentAC, CurrentDate : string;
  CurrentVal : Double;
  iCount : Integer;
  KeyS : Str255;
  CurrentPeriod, CurrentYear : Byte;

  function ItemString(const Ref : string; NoOfItems : integer) : string;
  begin
    if Trim(Ref) = '' then
      Result := ''
    else
    begin
      if NoOfItems > 1 then
        Result := Format('%s %d Items', [Ref, NoOfItems])
      else
        Result := Format('%s %d Item', [Ref, NoOfItems]);
    end;
  end;

  procedure AddDetails;
  begin
    //Add details to list
{    with mlGroupTrans do
    begin
      DesignColumns[0].Items.Add('RUN');
      DesignColumns[1].Items.Add(SOutPeriod(CurrentPeriod, CurrentYear));
      if Trim(CurrentRef) = '' then
        DesignColumns[2].Items.Add(CurrentAc);
      DesignColumns[3].Items.Add(ItemString(CurrentRef, iCount));
      DesignColumns[4].Items.Add(ProcessValue(CurrentVal));

      if iCount = 1 then
        DesignColumns[6].Items.Add(POutDate(CurrentDate))
      else
        DesignColumns[6].Items.Add('');
    end; }
  end;

begin
  CurrentRef := '';
  iCount := 0;
  CurrentVal := 0;

  Res := Find_Rec(B_GetFirst, TmpFile, RecTempF, TmpRecPtr^, 5, KeyS);

      CurrentRef := TempDetailRec.btdPayInRef;
      CurrentAC := TempDetailRec.btdAcCode;
      CurrentPeriod := TempDetailRec.btdPeriod;
      CurrentYear := TempDetailRec.btdYear;
      CurrentDate := TempDetailRec.btdDate;

  while Res = 0 do
  begin
    if TempDetailRec.btdDocType <> 'NOM' then
    begin
      if (CurrentRef <> TempDetailRec.btdPayInRef) or (Trim(TempDetailRec.btdPayInRef) = '') then
      begin
        if iCount > 0 then
        begin
          AddDetails;
          CurrentVal := TempDetailRec.btdAmount;
        end;
        iCount := 0;
        CurrentRef := TempDetailRec.btdPayInRef;
        CurrentAC := TempDetailRec.btdAcCode;
        CurrentPeriod := TempDetailRec.btdPeriod;
        CurrentYear := TempDetailRec.btdYear;
        CurrentDate := TempDetailRec.btdDate;
      end
      else
        CurrentVal := CurrentVal + TempDetailRec.btdAmount;

      inc(iCount);
    end;
    Res := Find_Rec(B_GetNext, TmpFile, RecTempF, TmpRecPtr^, 5, KeyS);
  end;

  if iCount > 0 then
    AddDetails;
end;

procedure TfrmTransList.btnFindClick(Sender: TObject);
var
  Res : longint;
  KeyS, MatchS : Str255;
  OK : Boolean;
  ColNo, iPos, iRefCol : Integer;
  pDetails : PTempTransDetails;

  function FullDoubleKey(const Value : Double) : Str255;
  var
    dTemp : Double;
  begin
    FillChar(Result, SizeOf(Result), 0);
    dTemp := Value;
    Move(dTemp, Result[1], SizeOf(dTemp));
    Result[0] := Char(SizeOf(dTemp));
  end;

begin

  with TfrmRecFind.Create(Application.MainForm) do
  Try
    // PKR. 29/03/2016. ABSEXCH-17390. Remove Warnings.
    ColNo := 7;
    
    cbFindByChange(Self);
    ShowModal;
    if ModalResult = mrOK then
    begin
      Case cbFindBy.ItemIndex of
        0  : begin
               KeyS := edtDocNo.Text;
               ColNo := 7;  //Document our ref
             end;
        1  : begin
               KeyS := edtDocNo.Text;
               ColNo := 1;  //Account code
             end;
        2  : begin
               KeyS := FullDoubleKey(ceAmount.Value);
               ColNo := 3; //Amount
             end;
        3  : begin
               KeyS := edtDate.DateValue;
               ColNo := 5; //Date
             end;
        4  : begin
               KeyS := UpperCase(edtDocNo.Text);
               ColNo := 8; //Line description
             end;
        5  : begin
               KeyS := edtDocNo.Text;
               ColNo := 2; //Reference
             end;
      end;

      // PKR. 29/03/2016. ABSEXCH-17390. Remove compiler Warnings
      iRefCol := 0;
      For iPos := 0 to mlTrans.Columns.Count -1 do begin
        if mlTrans.Columns[iPos].DesignColPos = ColNo then iRefCol := iPos
      end;

      mlTrans.SearchColumn(iRefCol, True, KeyS);

      pDetails := btData.GetRecord;

      Case cbFindBy.ItemIndex of
        0  :   MatchS := pDetails.btdOurRef;
        1  :   MatchS := pDetails.btdAcCode;
        2  :   MatchS := FullDoubleKey(pDetails.btdAmount);
        3  :   MatchS := pDetails.btdDate;
        4  :   MatchS := pDetails.btdDesc;
        5  :   MatchS := pDetails.btdPayInRef;
      end;

      if UpperCase(KeyS) <> UpperCase(Copy(MatchS, 1, Length(KeyS))) then
        msgBox('No matching record found', mtInformation, [mbOK], mbOK, 'Bank Reconciliation');

    end;
  Finally
    Free;
  End;


end;

procedure TfrmTransList.DisplayTrans(Mode: Byte; DetailRec : TTempTransDetails);
begin
  If (DispTrans=nil) then
    DispTrans:=TFInvDisplay.Create(Self);

    try


      With DispTrans do
      Begin
        LastDocHed:=DetailRec.btdIdDocHed;
        DocRunRef:=DetailRec.btdOurRef;
        DocHistRunNo:=DetailRec.btdPostedRun;

        {$IFDEF SOP}
          DocHistCommPurch:=(DocHistRunNo=CommitOrdRunNo) and (oGL.glCode=Syss.NomCtrlCodes[PurchComm]);

        {$ENDIF}

        If ((LastFolio<>DetailRec.btdFolioRef) or (Mode<>100)) {and (InHBeen)} then
          Display_Trans(Mode,DetailRec.btdFolioRef,BOn,(Mode<>100));

      end; {with..}

    except

      DispTrans.Free;

    end;
end;

procedure TfrmTransList.mlTransRowDblClick(Sender: TObject;
  RowIndex: Integer);
begin
  ShowDetails;
end;

procedure TfrmTransList.btnTagClick(Sender: TObject);
var
  DetailRec : TTempTransDetails;
begin
  DetailRec := PTempTransDetails(btData.GetRecord)^;
//  ShowMessage(IntToStr(DetailRec.btdFolioRef));
  if not (DetailRec.btdStatus in [1..3]) and (DetailRec.btdStatus <> iMatch) and
  not ReconcileObj.FindGroupMatch(DetailRec.btdPayInRef, DetailRec.btdDate, DetailRec.btdLineKey) then
  with DetailRec do
  begin
    btdStatus := btdStatus xor iTag; //Tag or untag
    if btdStatus and iTag = iTag then //We've just tagged it
    begin
      TagTotal[TabControl1.TabIndex] :=
          TagTotal[TabControl1.TabIndex] + btdAmount;
      Inc(TagCount[TabControl1.TabIndex]);
//      ReconcileObj.AddTag(DetailRec);
    end
    else
    begin
      TagTotal[TabControl1.TabIndex] :=
          TagTotal[TabControl1.TabIndex] - btdAmount;
      Dec(TagCount[TabControl1.TabIndex]);
//      ReconcileObj.DeleteTag(DetailRec);
    end;
    WriteRec(DetailRec);
  end;
  ShowTaggedValue;
end;

procedure TfrmTransList.WriteRec(DetailRec: TTempTransDetails);
var
  Res : Integer;
  KeyS : Str255;
begin
  KeyS := DetailRec.btdLineKey;

  Res := Find_Rec(B_GetEq, Tmpfile, RecTempF, TmpRecPtr^, 6, KeyS);

  if (Res = 0) then
  begin
    Res := Put_Rec(TmpFile, RecTempF, DetailRec, 6);

    if Res = 0 then
      mlTrans.RefreshDB;
  end;
end;

procedure TfrmTransList.btnClearClick(Sender: TObject);
var
  DetailRec : TTempTransDetails;
begin
  DetailRec := PTempTransDetails(btData.GetRecord)^;
  if ((DetailRec.btdStatus and (iTag or iMatch)) < iMatch) and
      not ReconcileObj.FindGroupMatch(DetailRec.btdPayInRef, DetailRec.btdDate, DetailRec.btdLineKey) then
  begin
    with DetailRec do
    begin
      if btdStatus and 3 <> 1 then
      begin
//        ReconcileObj.ReconciledAmount := ReconcileObj.ReconciledAmount + btdAmount;
        btdStatus := (btdStatus and not 3) or 1;
        ReconcileObj.SetClearedRec(DetailRec);
        if TabControl1.TabIndex = 1 then
          DetailRec.btdNumberCleared := DetailRec.btdNoOfItems;
        WriteRec(DetailRec);
        if TabControl1.TabIndex = 0 then
        begin
          if Trim(DetailRec.btdPayInRef) <> '' then
            UpdateGroupCleared(DetailRec.btdPayInRef, DetailRec.btdDate, DetailRec.btdStatus)
          else
            UpdateGroupCleared(DetailRec.btdLineKey, DetailRec.btdDate, DetailRec.btdStatus);
        end
        else
          UpdateGroupLines(DetailRec.btdPayInRef, DetailRec.btdFullPayInRef, DetailRec.btdDate, btdStatus, DetailRec.btdStatLine);  //For group recs with no PayInRef, btdFullPayInRef contains
                                                                                          //the LineKey for the corresponding single record
        mlTrans.RefreshDB;
        ShowBalances;
      end;
    end;
  end;
end;

procedure TfrmTransList.btnUnclearClick(Sender: TObject);
var
  ListPoint : TPoint;
begin
  ListPoint.X:=1;
  ListPoint.Y:=1;

  ListPoint:=btnUnclear.ClientToScreen(ListPoint);

  PopUpMenu2.Popup(ListPoint.X, ListPoint.Y);
end;

procedure TfrmTransList.Unclear2Click(Sender: TObject);
var
  DetailRec : TTempTransDetails;
  Stat : Byte;
begin
  DetailRec := PTempTransDetails(btData.GetRecord)^;
  
  // PKR. 29/03/2016. ABSEXCH-17390. Remove compiler warnings.
  Stat := 0;
  
  if Sender is TMenuItem then
    with Sender as TMenuItem do
      Stat := Tag;

  if (DetailRec.btdStatus < 5) and
  not ReconcileObj.FindGroupMatch(DetailRec.btdPayInRef, DetailRec.btdDate, DetailRec.btdLineKey) then
  begin
    with DetailRec do
    begin
      btdStatus := Stat;

      if TabControl1.TabIndex = 1 then
        btdNumberCleared := 0;

      ReconcileObj.SetClearedRec(DetailRec);

    end;
    WriteRec(DetailRec);
        if TabControl1.TabIndex = 0 then
        begin
          if Trim(DetailRec.btdPayInRef) <> '' then
            UpdateGroupCleared(DetailRec.btdPayInRef, DetailRec.btdDate, DetailRec.btdStatus, False)
          else
            UpdateGroupCleared(DetailRec.btdLineKey, DetailRec.btdDate,DetailRec.btdStatus,  False);
        end
        else
          UpdateGroupLines(DetailRec.btdPayInRef,  DetailRec.btdFullPayInRef, DetailRec.btdDate, DetailRec.btdStatus, DetailRec.btdStatLine);
    mlTrans.RefreshDB;
    ShowBalances;
  end;

end;

procedure TfrmTransList.btnEBankClick(Sender: TObject);
var
  oBankAccount : IBankAccount;
  Res : Integer;
  StatFolio : longint;
  StatDate : string;
begin
{  if Assigned(FCurrentStatement) then
    Res := msgBox('This will remove any changes you have made. Do you wish to continue?', mtWarning,
                    [mbYes, mbNo], mbYes, 'Load Bank Statement')
  else
    Res := mrYes;

  if Res = mrYes then}
  begin
    if Assigned(FStatementForm) then
      FStatementForm.Close;

    with oRecToolkit.Banking do
      Res := BankAccount.GetEqual(BankAccount.BuildGLCodeIndex(oGL.glCode));

      if Res = 0 then
      begin
        if Assigned(FCurrentStatement) then
        begin
          StatFolio := FCurrentStatement.bsFolio;
          StatDate := FCurrentStatement.bsDate;
        end
        else
        begin
          StatFolio := 0;
          StatDate := '';
        end;
        ShowBankDetails(oRecToolkit.Banking.BankAccount, bdmStatementsOnly,
                      DetailFormClosed, Self.Handle, oRecToolkit, StatFolio, StatDate);
      end;
  end;
end;

procedure TfrmTransList.DetailFormClosed(Sender: TObject);
begin
  frmbankdetails := nil;
  if StatementButtonClicked then
  begin
    //Statement button was clicked when we had no statement selected. Now we have a statement
    //so click it again.
{    StatementButtonClicked := True;
    btnStatementClick(Self);}
    ShowStatementForm;
  end;
end;

procedure TfrmTransList.btnViewClick(Sender: TObject);
begin
  ShowDetails;
end;

procedure TfrmTransList.btnStatementClick(Sender: TObject);
var
  Res : Integer;
begin
  Res := mrNo;
  if Assigned(FCurrentStatement) then
    Res := msgBox('Do you want to select a different statement?', mtWarning, [mbYes, mbNo], mbYes, 'Bank Reconciliation')
  else
    Res := mrYes;

  if (Res = mrNo) then
    ShowStatementForm
  else
  begin
    StatementButtonClicked := True;
    btnEBankClick(Self);
  end;

end;

procedure TfrmTransList.WMCustGetRec(var Message: TMessage);
begin
  Case Message.WParam of
     55 : begin
//            mlTrans.RefreshDB;
            //PR: 20/01/2010 After Check function, RefreshDB was showing some spurious duplicate records -
            //changed to turn list off and on again. (BFI approach.)
            mlTrans.Active := False;
            mlTrans.Active := True;

            ShowBalances;
            EnableButtons(True); //PR 22/01/2010 Added to avoid crash if user clicks buttons while Check is running
          end;
     56 : begin
            mlTrans.RefreshDB;
            if Assigned(FStatementForm) then
            begin
               FStatementForm.mlStatements.RefreshDb;
               FStatementForm.btnAuto.Enabled := True;
            end;
            if Assigned(frmBankDetails) then
              frmBankDetails.btnReconcile.Enabled := True;
            Screen.Cursor := crDefault;
            ShowBalances;
          end;
     57 : begin
            //Called after process
            if Assigned(FCurrentStatement) then
              SetStatementComplete;
            if Assigned(FStatementForm) then
               FStatementForm.mlStatements.RefreshDb;
            if Assigned(frmBankDetails) then
               frmBankDetails.mlStatements.RefreshDB;
            ReconcileObj.DeleteAllGroupLines;
            mlTrans.RefreshDB;
            ShowBalances;
//            RunReconcileReport;
            Close;
          end;
     58 : begin
            //Called after a match to remove tagged statuses
            RemoveAllTags;
            RefreshList;
          end;
    201 : if Assigned(frmBankDetails) then
          begin
             FCurrentStatement := frmBankDetails.ctkStatements.GetRecord as IBankStatement;
             if Assigned(FCurrentStatement) then
             begin
               if Trim(ReconcileObj.bnkHeader.brReconRef) = '' then
                 ReconcileObj.bnkHeader.brReconRef := FCurrentStatement.bsReference;
               ReconcileObj.bnkHeader.brStatRef := FCurrentStatement.bsReference;
               ReconcileObj.bnkHeader.brStatDate := FCurrentStatement.bsDate;
               ReconcileObj.bnkHeader.brStatFolio := FCurrentStatement.bsFolio;
               if ListSettings.StatBalance = 0.00 then
                 ReconcileObj.bnkHeader.brStatBal := {OpeningBalance +} FCurrentStatement.bsBalance
               else
                 ReconcileObj.bnkHeader.brStatBal := ListSettings.StatBalance;
               if Trim(ReconcileObj.bnkHeader.brReconRef) = '' then
                  ReconcileObj.bnkHeader.brReconRef := FCurrentStatement.bsReference;
               ReconcileObj.UpdateHeader;
             end;
             ShowBalances;
             SetCaption;
          end;

  30000 : begin //PR 24/07/2009 This message is posted by the AddNomWizard when a standard nominal entry is selected
            AddTrans(2, NMT);
          end; 
  end;
end;

procedure TfrmTransList.btDataFilterRecord(Sender: TObject; PData: Pointer;
  var Include: Boolean);
begin
  with PTempTransDetails(PData)^ do
    Include := (TabControl1.TabIndex = 0) xor (btdDocType = 'RUN');

  if Assigned(ListFilter) then
    Include := Include and ListFilter.WantThisRecord(PTempTransDetails(PData)^);
end;

procedure TfrmTransList.ShowDetails;
begin
  if TabControl1.TabIndex = 0 then
    DisplayTrans(2, PTempTransDetails(btData.GetRecord)^)
  else
  begin
    ShowGroupList(PTempTransDetails(btData.GetRecord), GroupViewClosed, ListSettings.lsGroupBy);
  end;

end;

procedure TfrmTransList.GroupViewClosed(Sender: TObject);
begin
  frmGroupView := nil;
end;



function TBankScanSQL.FindGroupRecord(
  const rDetails: TTempTransDetails): Integer;
var
  i : integer;
  Found : Boolean;
begin
  i := 0;
  Found := False;
  while not Found and (i < GroupList.Count) do
  begin
    if Assigned(GroupList[i]) then
      Found := Trim(PTempTransDetails(GroupList[i])^.btdPayInRef) = Trim(rDetails.btdPayInRef);

    if not Found then
      inc(i);
  end;
  if Found then
    Result := i
  else
    Result := -1;
end;

procedure TBankScanSQL.AddOrUpdateGroupRecord(
  const rDetails: TTempTransDetails);
var
  i : Integer;
  pDetails : PTempTransDetails;
begin
  i := FindGroupRecord(rDetails);
  if i > -1 then
    PTempTransDetails(GroupList[i])^ := rDetails
  else
  begin
    New(pDetails);
    pDetails^ := rDetails;
    GroupList.Add(pDetails);
  end;;
end;

procedure TBankScanSQL.AddGroupRecordsToQuery;
begin
  while GroupList.Count > 0 do
  begin
    ProcessOneRecord(sTempTable, PTempTransDetails(GroupList[0])^);
    Dispose(GroupList[0]);
    GroupList.Delete(0);
  end;
end;


procedure TBankScanSQL.InsertReconcileRecords;
//CompanyCode, VarCode1, VarCode2, VarCode3, BankRecHeaderFolio, CompanyCode, TempTableName
var
  Res : Integer;
  sSQLQuery : String;
begin
  Try
    iGLCode := GLCode;
    sSQLQuery := Format(SQL_INSERT_RECONCILED_LINES, [FCompanyCode,
                                                     BuildSQLIndex1,
                                                     BuildSQLIndex2,
                                                     BuildSQLIndex3,
                                                     ReconcileObj.bnkHeader.brIntRef,
                                                     FCompanyCode,
                                                     sTempTable,
                                                     ReconcileObj.bnkHeader.brIntRef]);
    Res := SQLUtils.ExecSQLEx(sSQLQuery, SetDrive, I_TIMEOUT);
    if Res <> 0 then
      raise Exception.Create(SQLUtils.LastSQLError);

//    if not ReconcileObj.WasExistingReconcile then
    ReconcileObj.ReconciledAmount := GetReconciledAmountSQL;
  Except
    On E:Exception do
    begin
    {$IFDEF PRDEBUG}
      with TStringList.Create do
      Try
        Add(E.Message);
        Add(sSQLQuery);
      Finally
//        SaveToFile('c:\MLocStk_sqlerror.txt');
        Free;
      End;
    {$ELSE}
     RaiseSQLError('TBankScanSQL.InsertReconcileRecords',E.Message, sSQLQuery);    {$ENDIF}
    end;
  End;

end;


function TBankScanSQL.GetOpeningBalanceSQL: Double;
const
  XRateNames : Array[False..True] of String[13] = ('tlCompanyRate', 'tlDailyRate');
var
  V : Variant;
  Res : Integer;
  sQuery : String;
  d1, d2 : Double;
  {$IFDEF MC_On}
  sXRate: String;
  {$ENDIF}
begin

  // CS 2011-08-17 ABSEXCH-11231 - Opening Balance on Bank Rec
  // Check for Consolidated currency on G/L Account, and use the alternative
  // SQL query if found.
  {$IFDEF MC_On}
  sXRate := XRateNames[UseCoDayRate];
  if (ListSettings.WantedCurrency = 0) then
    sQuery := Format(SQL_CONSOLIDATED_OPEN_BALANCE, [sXRate, sXRate, ReconcileObj.bnkHeader.brGLCode])
  else
  {$ENDIF}
    sQuery := Format(SQL_OPEN_BALANCE, [ReconcileObj.bnkHeader.brGLCode]);

  Res := SQLUtils.SQLFetch(sQuery + SQL_POSITIVE_SET, 'OpenBalance', SetDrive, V);
  if Res = 0 then
  begin
    d1 := V;
    Res := SQLUtils.SQLFetch(sQuery + SQL_NEGATIVE_SET, 'OpenBalance', SetDrive, V);
    if Res = 0 then
    begin
      d2 := V;
      Result := d1 - d2;
    end
    else
      Result := 0;
  end
  else
    Result := 0;
end;

function TBankScanSQL.GetSQLRecordCount: Integer;
var
  V : Variant;
  Res : Integer;
  sQuery : String;
begin
  sQuery := Format(SQL_COUNT_QUERY, [TmpTableName(FullTmpFileName)]);
  Res := SQLUtils.SQLFetch(sQuery, 'RecCount', SetDrive, V);
  if Res = 0 then
    Result := V
  else
    Result := 0;
end;

{ TRecListFilter }

function TRecListFilter.FilterString: string;
var
  i : TFilterBy;
  Mask : Byte;
begin
  Result := 'Filters: ';
  for i := fbDocType to fbDate do
  begin
    Mask := 1 shl Ord(i);
    if (FilterBy and Mask = Mask) then
      Case i of
        fbDocType  :  Result := Result + 'Doc Type, ';
        fbAccount  :  Result := Result + 'Account Code, ';
        fbRef      :  Result := Result + 'Reference, ';
        fbAmount   :  Result := Result + 'Amount, ';
        fbStatus   :  Result := Result + 'Status, ';
        fbDate     :  Result := Result + 'Date, ';
      end;
  end;
  if Result <> 'Filters: ' then
    Delete(Result, Length(Result) - 1, 2)
  else
    Result := 'Filters: None';
end;

procedure TRecListFilter.ShowFilterForm;
var
  Mask : Byte;
  FilterOn : Boolean;
begin

    with TfrmFilterInput.Create(nil) do
    Try
      SetEdits;
      lblFormFilters.Caption := FilterString;

      ShowModal;
      if ModalResult = mrOK then
      begin
        // PKR. 29/03/2016. ABSEXCH-17390. Remove compiler warnings.
        FilterOn := false;
        
        Mask := 1 shl Byte(FilterWanted);
        Case FilterWanted of
          fbDocType : begin
                        DocFrom := cbTypeFrom.Text;
                        DocTo := cbTypeTo.Text;
                        FilterOn := not ((DocFrom = 'NOM') and (DocTo = 'SRI'));
                      end;
          fbAccount : begin
                        AcFrom := edtFrom.Text;
                        AcTo := edtTo.Text;
                        FilterOn := (Trim(AcTo) <> '')
                      end;
          fbRef     : begin
                        RefFrom := edtFrom.Text;
                        RefTo := edtTo.Text;
                        FilterOn := (Trim(RefTo) <> '')
                      end;
          fbAmount  : begin
                        AmountFrom := ceFrom.Value;
                        AmountTo := ceTo.Value;
                        FilterOn := (AmountTo <> 0) or (AmountFrom <> 0);
                      end;
          fbStatus  : begin
                        StatusFrom := cbFrom.ItemIndex;
                        StatusTo := StatusFrom;
                        FilterOn := StatusTo <> 5;
                      end;
          fbDate    : begin
                        DateFrom := edDateFrom.DateValue;
                        DateTo := edDateTo.DateValue;
                        FilterOn := (Trim(DateTo) <> '')
                      end;

        end;
        if FilterOn then
          FilterBy := FilterBy or Mask
        else
          FilterBy := FilterBy and not Mask;
      end;
    Finally
      Free;
    End;
end;

function TRecListFilter.WantThisRecord(Details: TTempTransDetails): Boolean;
begin
  Result := True;

  if FilterBy and 1 = 1 then  //DocType
    Result := (Details.btdDocType >= DocFrom) and (Details.btdDocType <= DocTo);

  if Result and (FilterBy and 2 = 2) then //Account Code
  begin
    Result := (Details.btdAcCode >= AcFrom) and (Trim(Details.btdAcCode) <= AcTo);
  end;

  if Result and (FilterBy and 4 = 4) then  //Reference
  begin
    Result := (UpperCase(Trim(Details.btdPayInRef)) >= UpperCase(RefFrom)) and
                   (UpperCase(Trim(Details.btdPayInRef))<= UpperCase(RefTo));
  end;

  if Result and (FilterBy and 8 = 8) then //Amount
  begin
    Result := (Details.btdAmount >= AmountFrom) and (Details.btdAmount <= AmountTo);
  end;

  if Result and (FilterBy and 16 = 16) then //Status
  begin
    Result := (Details.btdStatus = StatusFrom) or ((Details.btdStatus <> 1) and (StatusFrom = 4));
  end;

  if Result and (FilterBy and 32 = 32) then //Date
  begin
    Result := (Details.btdDate >= DateFrom) and (Details.btdDate <= DateTo);
  end;

end;


procedure TfrmTransList.btnFilterClick(Sender: TObject);
var
  ListPoint : TPoint;
begin
  ListPoint.X:=1;
  ListPoint.Y:=1;

  ListPoint:=btnFilter.ClientToScreen(ListPoint);

  SetFilterMenu;
  mnuFilters.Popup(ListPoint.X, ListPoint.Y);
end;

procedure TfrmTransList.RemoveAllFilters1Click(Sender: TObject);
begin
  if Assigned(ListFilter) then
  begin
    if ListFilter.FilterBy > 0 then
    begin
      ListFilter.FilterBy := 0;
      mlTrans.RefreshDB;
    end;
  end;
end;


procedure TfrmTransList.AddFilter1Click(Sender: TObject);
begin
  if not Assigned(ListFilter) then
  begin
    ListFilter := TRecListFilter.Create;
    ListFilter.FilterBy := 0;
  end;
  ListFilter.ShowFilterForm;
  mlTrans.RefreshDB;
end;

procedure TfrmTransList.ShowFilterString(ALabel: TLabel);
begin
  if Assigned(ListFilter) then
    ALabel.Caption := ListFilter.FilterString
  else
    ALabel.Caption := 'Filters: None';
end;

procedure TfrmTransList.mlTransBeforeLoad(Sender: TObject;
  var Allow: Boolean);
begin
  ShowFilterString(lblFilters);
end;

procedure TfrmTransList.mlTransChangeSelection(Sender: TObject);
begin
  if ((TabControl1.TabIndex = 0) and Assigned(DispTrans) and ScanMode) or
     ((TabControl1.TabIndex = 1) and Assigned(frmGroupView)) then
    ShowDetails;
end;

procedure TfrmTransList.AddTrans(Mode: Byte; TransType : DocTypes);
var
  DoNormal : Boolean;
begin
  {$IFDEF AddNomWizard}
    DoNormal := (TransType <> NMT) or
                (ChkAllowed_In(572)) or
                (Mode <> 1);
    if not DoNormal then //Use AddNomWizard
      ShowAddNomWizard(Self.Handle);
      
  {SS 09/05/2016 2016-R2 	
  ABSEXCH-12504:Adding a Nominal Journal via the Bank Rec Wizard Screen with
  the standard journal creation password setting unticked results in NOM Header fields being incorrect.
  - Set Mode to 1 for the new nominal when the standard journal creation password setting unticked.}
  if (TransType = NMT) and (not ChkAllowed_In(572)) and (Mode <> 1) then
  begin
    Mode := 1;
  end;
  
  {$ELSE}
    DoNormal := True;
  {$ENDIF}

  if DoNormal then
  begin
    If (DispTrans=nil) then
      DispTrans:=TFInvDisplay.Create(Self);

    try

      With DispTrans do
      Begin
        If (Not TransActive[LastActive]) then
          LastDocHed:=TransType;

        Display_Trans(Mode,0,BOff,BOn);

      end; {with..}

    except

      DispTrans.Free;

    end;
  end;
end;

procedure TfrmTransList.mnuPPIClick(Sender: TObject);
begin
  AddTrans(1, PPI);
end;

procedure TfrmTransList.mnuSRIClick(Sender: TObject);
begin
  AddTrans(1, SRI);
end;

procedure TfrmTransList.mnuPPYClick(Sender: TObject);
begin
  if PChkAllowed_In(413) then
    ShowReceiptWizard(False)
  else
    AddTrans(1, PPY);
end;

procedure TfrmTransList.mnuSRCClick(Sender: TObject);
begin
  if PChkAllowed_In(410) then
    ShowReceiptWizard(True)
  else
    AddTrans(1, SRC);
end;

procedure TfrmTransList.ShowReceiptWizard(IsSales: Boolean);
begin
  Set_alSales(IsSales,False);


  With TAllocateWiz.Create(Self) do
  Try

  except
    Free;

  end; {try..}
end;

procedure TfrmTransList.btnAdjustmentClick(Sender: TObject);
var
  ListPoint : TPoint;
begin
  ListPoint.X:=1;
  ListPoint.Y:=1;

  ListPoint:=btnAdjustment.ClientToScreen(ListPoint);

  mnuAdjust.Popup(ListPoint.X, ListPoint.Y);
end;

procedure TfrmTransList.mnuNomClick(Sender: TObject);
begin
  AddTrans(1, NMT);
end;

function TfrmTransList.ScanMode: Boolean;
Var
  n  :  Byte;

Begin
  If (Assigned(DispTrans)) then
  With DispTrans do
  Begin
    For n:=Low(TransActive) to High(TransActive) do
    Begin
      Result:=TransActive[n];

      If (Result) then
        break;
    end;
  end
  else
    Result:=BOff;
end;

function TfrmTransList.AddHead: Integer;
begin
  // PKR. 29/03/2016. ABSEXCH-17390. Remove compiler warnings
  Result := 0;
end;

function TfrmTransList.AddLine: Integer;
begin
  // PKR. 29/03/2016. ABSEXCH-17390. Remove compiler warnings
  Result := 0;
end;

function TfrmTransList.UpdateHead: Integer;
begin
  // PKR. 29/03/2016. ABSEXCH-17390. Remove compiler warnings
  Result := 0;
end;

function TfrmTransList.UpdateLine: Integer;
begin
  // PKR. 29/03/2016. ABSEXCH-17390. Remove compiler warnings
  Result := 0;
end;

procedure TfrmTransList.FindExistingReconcile;
begin
{  ReconcileObj.bnkHeader.brGLCode := oGL.glCode;
  ReconcileObj.bnkHeader.brStatDate := ListSettings.StatDate;
  ReconcileObj.bnkHeader.brStatRef := ListSettings.Ref;
  if not ReconcileObj.FindExisting then
  begin
    ReconcileObj.bnkHeader.brGLCode := oGL.glCode;
    ReconcileObj.bnkHeader.brStatDate := ListSettings.StatDate;
    ReconcileObj.bnkHeader.brStatRef := ListSettings.Ref;
    ReconcileObj.GetNextFolio;
    Res := ReconcileObj.AddHeader;
    if Res <> 0 then
      ShowMessage(IntToStr(Res));
  end;}
end;

procedure TfrmTransList.mlTransMouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);

  function TaggedCount : longint;
  begin
    if ListSettings.MultiSelect then
      Result := mlTrans.MultiSelected.Count
    else
      Result := TagCount[TabControl1.TabIndex];
  end;
begin
  if (Button = mbLeft) and Assigned(FStatementForm) and (TaggedCount > 0) and
     (FStatementForm.mlStatements.Selected >= 0) and ChkAllowed_In(196) then
  begin
    if TaggedCount = 1 then
      mlTrans.DragCursor := crDrag
    else
      mlTrans.DragCursor := crMultiDrag;
    mlTrans.BeginDrag(False, 100);
  end;
end;

procedure TfrmTransList.ShowStatementForm;
begin
  if Assigned(FCurrentStatement) then
  begin
    if not Assigned(FStatementForm) then
      FStatementForm := TfrmStatement.Create(Self);

    with FStatementForm do
    begin
      oStatement := FCurrentStatement;
      oToolkit := oRecToolkit;
      ParentHandle := Self.Handle;
      edtDate.Text := POutDate(oStatement.bsDate);
      edtRef.Text := oStatement.bsReference;
      ctkData.ToolkitObject := oStatement.bsStatementLine as IDatabaseFunctions;
      mlStatements.Active := True;
      mlStatements.RefreshDB;
    end;

    FStatementForm.BringToFront;
  end;
end;


procedure TfrmTransList.mlTransEndDrag(Sender, Target: TObject; X,
  Y: Integer);
begin
  if Assigned(Target) and Assigned(FStatementForm) and
   ((Target as TDBMPanel).Parent.Parent = FStatementForm.mlStatements) then
  begin
    FStatementForm.Match(FStatementForm.ctkData.GetRecord as IBankStatementLine);
    ShowBalances;
  end;
end;

procedure TfrmTransList.StatementFormClosed(Sender: TObject);
begin
  FStatementForm := nil;
end;

function TfrmTransList.TaggedValue: Double;
begin
  Result := TagTotal[TabControl1.TabIndex];
end;

procedure TfrmTransList.RefreshList;
begin
  mlTrans.RefreshDB;
  SetTaggedValues;

  ShowTaggedValue;
  if Assigned(FStatementForm) then
    FStatementForm.mlStatements.RefreshDB;
end;

procedure TfrmTransList.btnCheckClick(Sender: TObject);
begin
//PR 22/01/2010 Set buttons off to avoid crash if user clicks buttons while Check is running
  EnableButtons(False);
  UpdateReconcile(False);
  if SQLUtils.UsingSQL then
    AddBankScanSQL2Thread(Application.MainForm, ListSettings.WantedCurrency, oGl.glCode, Handle,
                     ListSettings, True)
  else
    AddBankScan2Thread(Application.MainForm, ListSettings.WantedCurrency, oGl.glCode, Handle,
                     ListSettings, True);

end;

procedure TfrmTransList.ShowTaggedValue;
begin
  ceTagged.Value := TaggedValue;
end;

procedure TfrmTransList.RemoveOneFilter(WhichOne : Byte);
begin
  if Assigned(ListFilter) then
  begin
    ListFilter.FilterBy := ListFilter.FilterBy and not WhichOne;
    mlTrans.RefreshDB;
  end;
end;

procedure TfrmTransList.SetFilterMenu;
var
  bFilters : Byte;

  function CheckFilter(WhichOne : Byte) : Boolean;
  begin
    Result := bFilters and WhichOne = WhichOne;
  end;
begin
  if Assigned(ListFilter) then
    bFilters := ListFilter.FilterBy
  else
    bFilters := 0;

  mnuDocType.Enabled := CheckFilter(ftDocType);
  mnuAcCode.Enabled := CheckFilter(ftAcCode);
  mnuRef.Enabled := CheckFilter(ftRef);
  mnuAmount.Enabled := CheckFilter(ftAmount);
  mnuStatus.Enabled := CheckFilter(ftStatus);
  mnuDate.Enabled := CheckFilter(ftDate);
end;

procedure TfrmTransList.mnuDocTypeClick(Sender: TObject);
begin
  if Sender is TMenuItem then
    with Sender as TMenuItem do
      RemoveOneFilter(Tag);
end;

procedure TfrmTransList.SetCaption;
var

  s : string;
begin
  if Assigned(FCurrentStatement) then
  begin
    s := ' (Statement ';
    if Trim(FCurrentStatement.bsReference) <> '' then
      s := s  + Trim(FCurrentStatement.bsReference) + ' ';

    s := s + POutDate(FCurrentStatement.bsDate) + ')';
//    ceStatBalance.Value := ReconcileObj.bnkHeader.brStatBal;
    ShowBalances;
  end
  else
    s := '';



  Caption := Format('%d, %s: %s %s Reconciliation%s', [oGL.glCode, Trim(oGL.glName),
                                                     ListSettings.CurrName, CurrencySymbol, s]);

end;

procedure TfrmTransList.Properties1Click(Sender: TObject);
begin
  case oSettings.Edit(mlTrans, Self.Name, nil) of
{    mrOK : oSettings.ColorFieldsFrom(cmbCompany, Self);}
    mrRestoreDefaults : begin
      oSettings.RestoreParentDefaults(Self, Self.Name);
      oSettings.RestoreFormDefaults(Self.Name);
      oSettings.RestoreListDefaults(mlTrans, Self.Name);
      bRestore := TRUE;
    end;
  end;{case}

end;

procedure TfrmTransList.LoadAllSettings;
begin
  oSettings.LoadForm(Self);
  oSettings.LoadList(mlTrans, Self.Name);
  FormResize(Self);
end;

procedure TfrmTransList.SaveAllSettings;
begin
  oSettings.SaveList(mlTrans, Self.Name);
  if SaveCoordinates1.Checked then oSettings.SaveForm(Self);
end;

function TfrmTransList.Reconcile(const oStat: IBankStatement): Boolean;
var
  FList : TList;
  ARec : PStatementLineRec;
  Res : Integer;
begin
  // PKR. 29/03/2016. ABSEXCH-17390. Remove compiler warnings
  Result := true;
  
  Screen.Cursor := crHourglass;
  FCurrentStatement := oStat;
  ListSettings.ReconDate := oStat.bsDate;
  FList := TList.Create;
  Res := oStat.bsStatementLine.GetFirst;

  while Res = 0 do
  begin
    New(ARec);
    ARec.slDate := oStat.bsStatementLine.bslLineDate;
    ARec.slPayRef := oStat.bsStatementLine.bslReference;
    ARec.slValue := oStat.bsStatementLine.bslValue;
    ARec.slLineNo := oStat.bsStatementLine.bslLineNo;
    ARec.slStatFolio := oStat.bsFolio;
    FList.Add(ARec);

    Res := oStat.bsStatementLine.GetNext;
  end;
  if ReconcileObj.bnkHeader.brStatBal = 0 then
    ReconcileObj.bnkHeader.brStatBal := oStat.bsBalance;
  ShowBalances;
  with ReconcileObj.bnkHeader do
  begin
{    if SQLUtils.UsingSQL then
      AddReconcileSQL2Thread(Self, Self.Handle, FList, brGLCode, brStatRef, brReconRef,
                                  brStatDate, brReconDate)
    else}
      AddReconcile2Thread(Self, Self.Handle, FList, brGLCode, brStatRef, brReconRef,
                                  brStatDate, brReconDate);
  end;
end;

{ TReconcile }

constructor TReconcile.Create(AOwner: TObject);
begin
    Inherited Create(AOwner);

    fTQNo:=3;
    fCanAbort:=BOn;

//    IsParentTo:=BOn;

    fOwnMT:=BOn; {* This must be set if MTExLocal is created/destroyed by thread *}

    MTExLocal:=nil;
end;

destructor TReconcile.Destroy;
begin
  if Assigned(StatList) then
    StatList.Free;

  inherited;
end;

procedure TReconcile.Finish;
begin
  inherited;
  ReconcileObj.CloseSession;
  PostMessage(CallBackWindow,WM_CustGetRec,56,0);
end;

procedure TReconcile.Process;
var
  Res, Res1 : Integer;
  KeyS, KeyS1 : Str255;
  Found : Boolean;
  i : integer;
  StatLine : PStatementLineRec;
  LocalDetailRec : TTempTransDetails;
  CacheID : longint;
  WhereClause, Columns : AnsiString;
  UpCount : Longint;
  sPayRef : ShortString;
  RecAddr, GroupCount, GroupTotal : longint;
begin

  Inherited Process;
{  FReconObj.bnkHeader.brGLCode := GLCode;
  FReconObj.bnkHeader.brReconDate := LDate;
  FReconObj.bnkHeader.brStatRef := LRef;
  FReconObj.FindExisting(False);

  FReconObj.bnkHeader.brGLCode := GLCode;
  FReconObj.bnkHeader.brStatDate := LDate;
  FReconObj.bnkHeader.brStatRef := LRef;
  FReconObj.bnkHeader.brReconDate := ReconDate;
  FReconObj.bnkHeader.brReconRef := ReconRef;
  FReconObj.GetNextFolio;
  if StatList.Count > 0 then
  begin
    StatLine := PStatementLineRec(StatList[i]);
    FReconObj.bnkHeader.brStatFolio := StatLine.slStatFolio;
  end;
  FReconObj.AddHeader;}

  ShowStatus(0,'Checking individual transaction lines');

  for i := 0 to StatList.Count - 1 do
  begin
    ShowStatus(1,Format('Line %d of %d', [Succ(i), StatList.Count]));
    UpCount := Trunc(SafeDiv(i * 100, StatList.Count));
    UpdateProgress(UpCount);

    StatLine := PStatementLineRec(StatList[i]);
    if (Trim(StatLine.slPayRef) <> '') then
    begin
      Found := False;
      KeyS := StatLine.slDate;
      sPayRef := Trim(UpperCase(StatLine.slPayRef));

      if UsingSQL then
      begin
        WhereClause := 'btdDocType <> ''RUN'' AND btdStatus <> ' + IntToStr(iMatch) +
                       ' AND (UPPER(SUBSTRING(btdPayInRef, 2, ' + IntToStr(Length(sPayRef)) + ')) = ' + QuotedStr(sPayRef) +
                       ' OR  UPPER(SUBSTRING(btdDesc, 1, ' + IntToStr(Length(sPayRef)) + ')) = ' + QuotedStr(sPayRef) + //PR: 20/01/2010 - was checking btdPayRef twice rather than btdDesc
                       ') AND ABS(btdAmount) - Abs(' + FloatToStr(StatLine.slValue) + ') < 0.001';
        // PKR. 29/03/2016. ABSEXCH-17390. Remove compiler warnings.
        CreateCustomPrefillCache(IncludeTrailingPathDelimiter(SetDrive) + TmpFilename,
                                 WhereClause, Columns, CacheID);
        UseCustomPrefillCache(CacheID);
      end;

      //PR 19/03/07 Changed to no longer use date for matching
//      Res1 := Find_Rec(B_GetGEq, Tmpfile, RecTempF, TempDetailRec, idxDate, KeyS);
      Res1 := Find_Rec(B_GetFirst, Tmpfile, RecTempF, TempDetailRec, idxDocType, KeyS);

      While (Res1 = 0) and not Found do
      begin
        if not (TempDetailRec.btdStatus in [iCleared, iMatch]) and  (TempDetailRec.btdDocType <> 'RUN') and
                 (
                  (Trim(UpperCase(Copy(TempDetailRec.btdPayInRef, 1, Length(sPayRef)))) = sPayRef) or
                  (Trim(UpperCase(Copy(TempDetailRec.btdDesc, 1, Length(sPayRef)))) = sPayRef)
                 )
                 and
                 (Abs(TempDetailRec.btdAmount) - Abs(StatLine.slValue) < 0.001) and (Sign(TempDetailRec.btdAmount) = Sign(StatLine.slValue)) and
                 (ReconcileObj.FindLine(TempDetailRec.btdLineKey, 1) <> 0) then
        begin
          LocalDetailRec := TempDetailRec;
          //HV&RJ 20/04/2016 2016-R2 ABSEXCH-15931: Matching Bank Statement to GL where multiple transactions share date and reference
          if (StatLine.slDate = TempDetailRec.btdDate) or (frmTransList.ListSettings.lsGroupBy = gbRefOnly) then
          begin
          Found := True;
          LocalDetailRec.btdStatus := iMatch;
          LocalDetailRec.btdStatLine := StatLine.slLineNo;
          ReconcileObj.AddMatch(StatLine^, LocalDetailRec);
          //Store position
          if UsingSQL then
            UseCustomPrefillCache(CacheID);
          Res := GetPos(TmpFile, RecTempF, RecAddr);

          UpdateGroupMatched(TempDetailRec.btdPayInRef, TempDetailRec.btdDate, True, StatLine.slLineNo);

          //Restore position
          Move(RecAddr, TempDetailRec, SizeOf(RecAddr));
          if UsingSQL then
            UseCustomPrefillCache(CacheID);
          Res := GetDirect(TmpFile, RecTempF, TempDetailRec, idxDocType, 0);

          if UsingSQL then
            UseCustomPrefillCache(CacheID);
          Put_Rec(Tmpfile, RecTempF, LocalDetailRec, idxDocType);
        end;
          end;

        if not Found then
        begin
          if UsingSQL then
            UseCustomPrefillCache(CacheID);
          Res1 := Find_Rec(B_GetNext, Tmpfile, RecTempF, TempDetailRec, idxDocType, KeyS);

          while (Res1 = 0) and (TempDetailRec.btdDocType = 'RUN') do
          begin
            if UsingSQL then
              UseCustomPrefillCache(CacheID);
             Res1 := Find_Rec(B_GetNext, Tmpfile, RecTempF, TempDetailRec, idxDocType, KeyS);
          end;
        end;

      end;

{      if Found = 1 then //we only match if there is one match only
      begin
        //Add reconciliation line rec
        LocalDetailRec.btdStatus := iMatch;
        LocalDetailRec.btdStatLine := StatLine.slLineNo;
        ReconcileObj.AddMatch(StatLine^, LocalDetailRec);
      end;}
      if not SQLUtils.UsingSQL then
        SleepEx(500, True);

      if UsingSQL then
        DropCustomPrefillCache(CacheID);
    end;
  end;//for i
  UpdateProgress(100);
  //Group match
  ShowStatus(0,'Checking grouped transaction lines');

  for i := 0 to StatList.Count - 1 do
  begin
    ShowStatus(1,Format('Line %d of %d', [Succ(i), StatList.Count]));
    UpCount := Trunc(SafeDiv(i * 100, StatList.Count));
    UpdateProgress(UpCount);
    StatLine := PStatementLineRec(StatList[i]);
    if (Trim(StatLine.slPayRef) <> '') and
       (ReconcileObj.FindLine(FullNomKey(MaxInt) + FullNomKey(StatLine.slLineNo), 2) <> 0) then
    //This line hasn't been matched yet
    begin
//      Found := 0;
      sPayRef := Trim(UpperCase(StatLine.slPayRef));

      if UsingSQL then
      begin
        WhereClause := 'btdDocType = ''RUN'' AND btdStatus <> ' + IntToStr(iMatch) +
                       ' AND (UPPER(SUBSTRING(btdPayInRef, 2, ' + IntToStr(Length(sPayRef)) + ')) = ' + QuotedStr(sPayRef) +
                       ' OR  UPPER(SUBSTRING(btdDesc, 1, ' + IntToStr(Length(sPayRef)) + ')) = ' + QuotedStr(sPayRef) + //PR: 20/01/2010 - was checking btdPayRef twice rather than btdDesc
                       ') AND ABS(btdAmount) - ' + FloatToStr(StatLine.slValue) + ' < 0.001';
        // PKR. 29/03/2016. ABSEXCH-17390. Remove compiler warnings.
        CreateCustomPrefillCache(IncludeTrailingPathDelimiter(SetDrive) + TmpFilename,
                                 WhereClause, Columns, CacheID);
      end;

      Found := False;
      KeyS := 'RUN';

      if UsingSQL then
        UseCustomPrefillCache(CacheID);
      Res1 := Find_Rec(B_GetGEq, Tmpfile, RecTempF, TempDetailRec, idxDocType, KeyS);

      While (Res1 = 0) and not Found and (KeyS = 'RUN') do
      begin
        if not (TempDetailRec.btdStatus in [iCleared, iMatch]) and (TempDetailRec.btdNoOfItems > 1) and
                 (
                  (Trim(UpperCase(Copy(TempDetailRec.btdPayInRef, 1, Length(sPayRef)))) = sPayRef) or
                  (Trim(UpperCase(Copy(TempDetailRec.btdDesc, 1, Length(sPayRef)))) = sPayRef)
                 ) and
           (Abs(TempDetailRec.btdAmount) - Abs(StatLine.slValue) < 0.001) and (Sign(TempDetailRec.btdAmount) = Sign(StatLine.slValue)) and
            not ReconcileObj.FindGroupMatch(TempDetailRec.btdPayInRef, TempDetailRec.btdDate, TempDetailRec.btdLineKey)
        then
        begin
          //PR: 02/04/2009 group rec was recognised in statement, process wasn't adding matches for indidual lines, hence not reconciling.
          Found := True;
          if UsingSQL then
            UseCustomPrefillCache(CacheID);
          Res := GetPos(TmpFile, RecTempF, RecAddr);

          KeyS1 := TempDetailRec.btdPayInRef;
          LocalDetailRec := TempDetailRec;

          GroupCount := 0;
          Res1 :=  Find_Rec(B_GetGEq, Tmpfile, RecTempF, TempDetailRec, idxPayInRef, KeyS1);
          while (Res1 = 0) and (Trim(TempDetailRec.btdPayInRef) = Trim(LocalDetailRec.btdPayInRef) ) do
          begin
            //HV&RJ 20/04/2016 2016-R2 ABSEXCH-15931: Matching Bank Statement to GL where multiple transactions share date and reference
            if (StatLine.slDate = TempDetailRec.btdDate) or (frmTransList.ListSettings.lsGroupBy = gbRefOnly) then
            begin
            TempDetailRec.btdStatus := iMatch;
            TempDetailRec.btdStatLine := StatLine.slLineNo;
            if TempDetailRec.btdDocType = 'RUN' then
            begin
				//HV&RJ 20/04/2016 2016-R2 ABSEXCH-15931: Matching Bank Statement to GL where multiple transactions share date and reference
                Res := GetPos(TmpFile, RecTempF, RecAddr);
//              TempDetailRec.btdStatLine := StatLine.slLineNo; PR: moved above so it applies to group and single items.
              ReconcileObj.NoUpdate := True;
              ReconcileObj.AddMatch(StatLine^, TempDetailRec);
              ReconcileObj.NoUpdate := False;
            end
            else
              ReconcileObj.AddMatch(StatLine^, TempDetailRec);
            if TempDetailRec.btdDocType <> 'RUN' then
              inc(GroupCount);
              {if UsingSQL then
            UseCustomPrefillCache(CacheID);}
            Put_Rec(TmpFile, RecTempF, TempDetailRec, idxPayInRef);
              {if UsingSQL then
            UseCustomPrefillCache(CacheID);}
            end;
           Res1 :=  Find_Rec(B_GetNext, Tmpfile, RecTempF, TempDetailRec, idxPayInRef, KeyS1);
          end;

          //Restore Position
         Move(RecAddr, TempDetailRec, SizeOf(RecAddr));
         Res := GetDirect(TmpFile, RecTempF, TempDetailRec, idxDocType, 0);
         TempDetailRec.btdNumberMatched := GroupCount;
         TempDetailRec.btdStatLine := StatLine.slLineNo;
         Put_Rec(TmpFile, RecTempF, TempDetailRec, idxDocType);
        end;

        if UsingSQL then
          UseCustomPrefillCache(CacheID);
        Res1 := Find_Rec(B_GetNext, Tmpfile, RecTempF, TempDetailRec, idxDocType, KeyS);

      end;

      if not SQLUtils.UsingSQL then
        SleepEx(500, True);

{      if Found then
      begin
        LocalDetailRec.btdStatus := iMatch;
        ReconcileObj.AddMatch(StatLine^, LocalDetailRec);
      end}
        if UsingSQL then
          DropCustomPrefillCache(CacheID);
    end;


  end; //for i
  UpdateProgress(100);
end;

(*
procedure TReconcile.Process;
var
  Res, Res1 : Integer;
  KeyS : Str255;
  Found : Boolean;
  i : integer;
  StatLine : PStatementLineRec;
  LocalDetailRec : TTempTransDetails;
begin

  Inherited Process;
{  FReconObj.bnkHeader.brGLCode := GLCode;
  FReconObj.bnkHeader.brReconDate := LDate;
  FReconObj.bnkHeader.brStatRef := LRef;
  FReconObj.FindExisting(False);

  FReconObj.bnkHeader.brGLCode := GLCode;
  FReconObj.bnkHeader.brStatDate := LDate;
  FReconObj.bnkHeader.brStatRef := LRef;
  FReconObj.bnkHeader.brReconDate := ReconDate;
  FReconObj.bnkHeader.brReconRef := ReconRef;
  FReconObj.GetNextFolio;
  if StatList.Count > 0 then
  begin
    StatLine := PStatementLineRec(StatList[i]);
    FReconObj.bnkHeader.brStatFolio := StatLine.slStatFolio;
  end;
  FReconObj.AddHeader;}

  ShowStatus(0,'Checking individual transaction lines');

  for i := 0 to StatList.Count - 1 do
  begin
    ShowStatus(1,Format('Line %d of %d', [Succ(i), StatList.Count]));
    StatLine := PStatementLineRec(StatList[i]);
    if (Trim(StatLine.slPayRef) <> '') then
    begin
      Found := False;
      KeyS := StatLine.slDate;
      //PR 19/03/07 Changed to no longer use date for matching
//      Res1 := Find_Rec(B_GetGEq, Tmpfile, RecTempF, TempDetailRec, idxDate, KeyS);
      Res1 := Find_Rec(B_GetFirst, Tmpfile, RecTempF, TempDetailRec, idxDocType, KeyS);

      While (Res1 = 0) and not Found do
      begin
        if (TempDetailRec.btdStatus <> iMatch) and  (TempDetailRec.btdDocType <> 'RUN') and
                 (
                  (Trim(UpperCase(TempDetailRec.btdPayInRef)) = Trim(UpperCase(StatLine.slPayRef))) or
                  (Trim(UpperCase(TempDetailRec.btdDesc)) = Trim(UpperCase(StatLine.slPayRef)))
                 )
                 and
                 (Abs(TempDetailRec.btdAmount - StatLine.slValue) < 0.001) and
                 (ReconcileObj.FindLine(TempDetailRec.btdLineKey, 1) <> 0) then
        begin
          LocalDetailRec := TempDetailRec;
          Found := True;
          LocalDetailRec.btdStatus := iMatch;
          LocalDetailRec.btdStatLine := StatLine.slLineNo;
          ReconcileObj.AddMatch(StatLine^, LocalDetailRec);
          UpdateGroupMatched(TempDetailRec.btdPayInRef);
        end;

        if not Found then
        begin
          Res1 := Find_Rec(B_GetNext, Tmpfile, RecTempF, TempDetailRec, idxDate, KeyS);

          while (Res1 = 0) and (TempDetailRec.btdDocType = 'RUN') do
             Res1 := Find_Rec(B_GetNext, Tmpfile, RecTempF, TempDetailRec, idxDate, KeyS);
        end;

      end;

{      if Found = 1 then //we only match if there is one match only
      begin
        //Add reconciliation line rec
        LocalDetailRec.btdStatus := iMatch;
        LocalDetailRec.btdStatLine := StatLine.slLineNo;
        ReconcileObj.AddMatch(StatLine^, LocalDetailRec);
      end;}
      if not SQLUtils.UsingSQL then
        SleepEx(500, True);
    end;
  end;//for i

  //Group match
  ShowStatus(0,'Checking grouped transaction lines');

  for i := 0 to StatList.Count - 1 do
  begin
    ShowStatus(1,Format('Line %d of %d', [Succ(i), StatList.Count]));
    StatLine := PStatementLineRec(StatList[i]);
    if (Trim(StatLine.slPayRef) <> '') and
       (ReconcileObj.FindLine(FullNomKey(MaxInt) + FullNomKey(StatLine.slLineNo), 2) <> 0) then
    //This line hasn't been matched yet
    begin
//      Found := 0;
      Found := False;
      KeyS := 'RUN';

      Res1 := Find_Rec(B_GetGEq, Tmpfile, RecTempF, TempDetailRec, idxDocType, KeyS);

      While (Res1 = 0) and not Found and (KeyS = 'RUN') do
      begin
        if (TempDetailRec.btdStatus <> iMatch) and
           (Trim(TempDetailRec.btdPayInRef) = Trim(StatLine.slPayRef)) and
           (Abs(TempDetailRec.btdAmount - StatLine.slValue) < 0.001) and
            not ReconcileObj.FindGroupMatch(TempDetailRec.btdPayInRef)
        then
        begin
          LocalDetailRec := TempDetailRec;
          Found := True;
          LocalDetailRec.btdStatus := iMatch;
          ReconcileObj.AddMatch(StatLine^, LocalDetailRec);
        end;

        Res1 := Find_Rec(B_GetNext, Tmpfile, RecTempF, TempDetailRec, idxDocType, KeyS);
      end;

      if not SQLUtils.UsingSQL then
        SleepEx(500, True);

{      if Found then
      begin
        LocalDetailRec.btdStatus := iMatch;
        ReconcileObj.AddMatch(StatLine^, LocalDetailRec);
      end}
    end;


  end; //for i
end;
*)

function TReconcile.Start: Boolean;
begin
  Result:=BOn;
  FReconObj := TBankReconciliation.Create(cidBankRec2);
end;

procedure TfrmTransList.mlTransMultiSelect(Sender: TObject);
begin
  TagTotal[TabControl1.TabIndex] := MultiSelectTotal;
  ShowTaggedValue;
end;

function TfrmTransList.GetMultiSelectRecord(
  WhichOne: Integer): TTempTransDetails;
var
  Res : Integer;
  RecAddr : longint;
begin
  FillChar(Result, SizeOf(Result), 0);
  if mlTrans.MultiSelected.Count > 0 then
  begin
    Val(mlTrans.MultiSelected[WhichOne], RecAddr, Res);
    if Res = 0 then
      Result := GetRecordFromAddress(RecAddr);
  end;
end;

procedure TfrmTransList.btnProcessClick(Sender: TObject);
begin
  DifferenceFolio := 0;
  DifferenceLineNo := 0;
  if CreateDifferenceJournal then
  begin
    Screen.Cursor := crHourGlass;
    //PR: 17/08/2009 Disable buttons to avoid them being clicked again before thread kicks off

    ScrollBox1.Enabled := False;
    btnOK.Enabled := False;
    btnCancel.Enabled := False;
    UpdateReconcile;
    UpdateStatuses;
    AddFinalise2Thread(Self, Self.Handle, DifferenceFolio, DifferenceLineNo, ListSettings.StatDate, ListSettings.UseReconDate);
  end;
end;

function TfrmTransList.GetRecordFromAddress(
  RecAddress: Integer): TTempTransDetails;
var
  Res : Integer;
begin
  Move(RecAddress, Result, SizeOf(RecAddress));
  Res:=GetDirect(TmpFile,RecTempF,Result,0,0);
end;

function TfrmTransList.MultiSelectTotal: Double;
var
  i, c : integer;
  RecAddr : longint;
begin
  Result := 0;
  for i := 0 to mlTrans.MultiSelected.Count - 1 do
  begin
    Val(mlTrans.MultiSelected[i], RecAddr, c);
    if c = 0 then
      Result := Result + GetRecordFromAddress(RecAddr).btdAmount;
  end;

end;

{ TFinaliseReconciliation }

constructor TFinaliseReconciliation.Create(AOwner: TObject);
begin
    Inherited Create(AOwner);

    fTQNo:=3;
    fCanAbort:=BOn;

//    IsParentTo:=BOn;

    fOwnMT:=BOn; {* This must be set if MTExLocal is created/destroyed by thread *}

    MTExLocal:=nil;
    bnkHeader := ReconcileObj.bnkHeader;
end;

destructor TFinaliseReconciliation.Destroy;
begin
  //PR: 15/05/2017 ABSEXCH-18683 v2017 R1 Release process lock
  if Assigned(Application.Mainform) then
    SendMessage(Application.MainForm.Handle, WM_LOCKEDPROCESSFINISHED, Ord(plBankReconciliation), 0);

  inherited;
end;

function TFinaliseReconciliation.UpdateReconcileLine(
  const s: string): Integer;
var
  KeyS, KeyChk : Str255;
  Res : Integer;
  bLocked : Boolean;
begin
  KeyS := LteBankRCode + BankRecLineKey + FullNomKey(ReconcileObj.bnkHeader.brGLCode) +
                 LJVar(ReconcileObj.bnkHeader.brUserId, 10) +
             FullNomKey(ReconcileObj.bnkHeader.brIntRef) +  s + '!';
  KeyChk := KeyS;
  Result := MTExLocal^.LFind_Rec(B_GetEq, MLocF, 1, KeyS);
  if (Result = 0) and (KeyS = KeyChk) then
  begin
    if MTExLocal^.LGetMultiRec(B_GetDirect,B_MultLock,KeyS,1,MLocF,BOff,bLocked) and bLocked then
    begin
      MTExLocal^.LMLocCtrl^.BnkRDRec.brLineStatus := iComplete;
      MTExLocal^.LPut_Rec(MLocF, 1);
      MTExLocal^.UnLockMLock(MLocF, 0); //PR: 12/08/2009 Was unlocking IDetailF rather than MLocF - D'oh!
    end;
  end;
end;

procedure TFinaliseReconciliation.Finish;
begin
  inherited;
  ReconcileObj.ExLocal := MtExLocal;
  ReconcileObj.bnkHeader.brStatus := bssComplete;
  ReconcileObj.UpdateHeader;
  ReconcileObj.CloseSession;
  ReconcileObj.RestoreExLocal;
  PostMessage(CallBackWindow,WM_CustGetRec,57,0);
{  if Assigned(MTExLocal) then
    Dispose(MTExLocal, Destroy);}
  if Assigned(MTPost) then
    Dispose(MTPost, Destroy);
end;

procedure TFinaliseReconciliation.Process;
var
  Res, Res1 : Integer;
  KeyS, RecKeyS : Str255;
  c : integer;
  LocalTempDetailRec : TTempTransDetails;
  GroupCount, UpCount : longint;
  dTmp : Double;
  bLocked : Boolean;
  RecAddr, RecAddr2 : longint;
  NewReconcile : Byte;
  StartTime, EndTime : Cardinal;

  procedure SetDifferenceLineCleared;
  begin
    if (DifferenceFolio <> 0) and (DifferenceLineNo <> 0) then
    begin
      KeyS := FullIdKey(DifferenceFolio, DifferenceLineNo);

      Res := MTExLocal^.LFind_Rec(B_GetEq, IDetailF, IdLinkK, KeyS);

      if Res = 0 then
      begin
        MTExLocal^.LId.Reconcile := ReconC;

        Res := MTExLocal^.LPut_Rec(IDetailF, IdLinkK);
      end;
    end;
  end;

  function CheckStatus : Boolean;
  begin
    with MTExLocal^ do
    begin
      Result := (LID.Reconcile <> (LocalTempDetailRec.btdStatus and 3));// or ReconcileObj.FindGroupMatch(LocalTempDetailRec.btdPayInRef,
                                                                        //                                LocalTempDetailRec.btdDate,
                                                                        //                                    LocalTempDetailRec.btdLineKey);
    end;
  end;

begin
  InMainThread:=BOn;
  Inherited Process;
  StartTime := GetTickCount;
  c := 0;
  ShowStatus(0,'Finalising bank reconciliation');
  if SQLUtils.UsingSQL then
    RecCount := GetSQLRecordCount;


//  Status:=GetPos(F[IDetailF],IDetailF,RecAddr);  {* Preserve Posn of Invoice Line *}

  With MTExLocal^ do
  Begin
    Res := Open_fileCID(LTmpFile, FullTmpFileName, 0, MTExLocal^.ExClientID);
    Res := Find_RecCID(B_GetFirst, LTmpFile, RecTempF, LocalTempDetailRec, 0, RecKeyS, MTExLocal^.ExClientID);
    InitProgress(100);
    UpdateProgress(0);
    while Res = 0 do
    begin
      if LocalTempDetailRec.btdDocType <> 'RUN' then
      begin

        if not SQLUtils.UsingSQL then
        begin
          LSetDataRecOfs(IDetailF,LocalTempDetailRec.btdLineAddr);

          Res1:=LGetDirect(IDetailF,IdFolioK,0);


          if (Res1 = 0) and ((CheckStatus) or
             (LocalTempDetailRec.btdStatus in [iMatch, iComplete])) then
          begin
            if (LocalTempDetailRec.btdStatus = iMatch) then
               LocalTempDetailRec.btdStatus := iComplete;
            //Lock Id and update
            if LGetMultiRec(B_GetDirect,B_MultLock,KeyS,IdFolioK,IDetailF,BOff,bLocked) and bLocked then
            begin
              if (LocalTempDetailRec.btdStatus = iComplete) or ReconcileObj.FindGroupMatch(LocalTempDetailRec.btdPayInRef, LocalTempDetailRec.btdDate,
                                                                                                        LocalTempDetailRec.btdLineKey)
              then
                NewReconcile := ReconC
              else
                NewReconcile := LocalTempDetailRec.btdStatus and 3;
              SetReconcileStatus(NewReconcile);

              //Set status to complete in TempFile
              UpdateReconcileLine(LocalTempDetailRec.btdLineKey);
              UpdateGroupReconcileLine(LocalTempDetailRec.btdPayInRef, LocalTempDetailRec);
              MTExLocal^.UnLockMLock(IDetailF,0);
            end;
          end;
        end
        else
        begin //SQL version
          LSetDataRecOfs(IDetailF,LocalTempDetailRec.btdLineAddr);

          Res1:=LGetDirect(IDetailF,IdFolioK,0);


          if (Res1 = 0) and ((CheckStatus) or
             (LocalTempDetailRec.btdStatus in [iMatch, iComplete])) then
          begin
            if (LocalTempDetailRec.btdStatus in [iMatch, iComplete]) then
              NewReconcile := ReconC
            else
              NewReconcile := LocalTempDetailRec.btdStatus and 3;

            SetReconcileStatus(NewReconcile);
          end;
        end;

        inc(c);
        dTmp := c;
        // PKR. 29/03/2016. ABSEXCH-17390. Remove compiler warnings.
        UpCount := 0;
        if RecCount > 0 then
          UpCount := Trunc((dTmp/RecCount) * 100);
        UpdateProgress(UpCount);
        ShowStatus(1,Format('Processed so far: %d of %d',[c, RecCount]));
      end;
      Res := Find_RecCID(B_GetNext, LTmpFile, RecTempF, LocalTempDetailRec, 0, RecKeyS, MTExLocal^.ExClientID);
    end;
    SetDifferenceLineCleared;
  end;
  UpdateProgress(100);
  EndTime := GetTickCount;
  {$IFDEF PRDEBUG}
  with TStringList.Create do
  Try
    Add(IntToStr(EndTime - StartTime));
//    SaveToFile('c:\FinaliseDuration.txt');
  Finally
    Free;
  End;
  {$ENDIF}
  //Restore position in detail file
//  SetDataRecOfs(IDetailF,RecAddr);

//  Status:=GetDirect(F[IDetailF],IDetailF,RecPtr[IDetailF]^,IdFolioK,0);

end;

function TFinaliseReconciliation.Start: Boolean;
Var
  mbRet  :  Word;
  KeyS   :  Str255;
  Res : Integer;
Begin
  Result:=BOn;
  RecCount := TotalRecCount;
  If (Not Assigned(MTExLocal)) then { Open up files here }
  Begin
    {$IFDEF EXSQL}
    if SQLUtils.UsingSQL then
    begin
      // CJS - 18/04/2008: Thread-safe SQL Version (using unique ClientIDs)
      if (not Assigned(LPostLocal)) then
        Result := Create_LocalThreadFiles;

      If (Result) then
        MTExLocal := LPostLocal;

    end
    else
    {$ENDIF}
      New(MTExLocal,Create(cidBankRec1));

    try
      try
        With MTExLocal^ do
        Begin
          Open_System(IDetailF, IDetailF);
          Open_System(MLocF, MLocF);
          Open_System(NomF, NomF);
          Open_System(NHistF, NHistF);
        end;
      finally
        Reset_LocalThreadFiles;
      end;
    except
      Dispose(MTExLocal,Destroy);
      MTExLocal:=nil;

    end; {Except}

    Result:=Assigned(MTExLocal);

  end;
  if Result then
    Result := GetProcessLock(plBankReconciliation);
end;

Procedure TFinaliseReconciliation.SetReconcileStatus(RStatus : Byte);
const
  KeyPath = IdFolioK;
  ScanFileNum = IDetailF;
Var
  Cnst    :  Integer;

  LAddr,
  TNCode  :  LongInt;


  LVal
          :  Real;

  PBal    :  Double;



  Loop    :  Boolean;

  Locked  :  Boolean;

Begin
  {$IFDEF POST}
  if not Assigned(MTPost) then
  begin
    New(MTPost,Create(Application.MainForm));

    try
      MTPost.MTExLocal := MTExLocal;


    except
      Dispose(MTPost,Destroy);
      MTPost:=nil;
    end;
  end;

  if Assigned(MTPost) then
  begin
    Loop:=BOff;

    With MTExLocal^.LId do
    Begin
//      RStatus:=LNHCtrl.NBMode-ReconN;

      Cnst:=0;  LVal:=0;  PBal:=0;  TNCode:=0;

      Locked:=BOff;

   {   If (Not Assigned(MTPost)) then
        InitMTExLocal;}

      //Allow reconcile date to be changed
      //PR: 25/08/2009 Only change reconciliation date if clearing the line or Reconciliation Date was used to load the lines.
      If (RStatus<>Reconcile) or (bUseReconcileDate and (RStatus = ReconC) and (ReconDate <> ReconcileDate)) then
      Begin
{        Ok:=MTExLocal^.LGetMultiRecAddr(B_GetDirect,B_MultLock,KeyF,KeyPath,ScanFileNum,BOff,Locked,LAddr);

        If (Ok) and (Locked) then}
        Begin
          If (Reconcile=ReconC) then
            Cnst:=-1
          else
            If (Reconcile In NotClearedSet) and (RStatus = ReconC) then
              Cnst:=1;

          If (Cnst<>0) then
          Begin
            LVal:=DetLTotal(MTExLocal^.LId,Not Syss.SepDiscounts,BOff,0.0)*Cnst;

            {$IFDEF Post}

              If (Assigned(MTPost)) then
              Begin
                MTPost.LPost_To_Nominal(FullNomKey(NomCode),0,0,LVal,Currency,PYr,PPr,1,BOff,BOn,BOff,CXrate,PBal,TNCode,UseORate);

                {$IFDEF PF_On}
                  If (Syss.PostCCNom) and (Syss.UseCCDep) then
                  Begin
                    Repeat
                      If (Not EmptyKeyS(CCDep[Loop],ccKeyLen,BOff)) then
                      Begin
                        MTPost.LPost_To_CCNominal(FullNomKey(NomCode),0,0,LVal,Currency,PYr,PPr,1,BOff,BOn,BOff,
                                          CXRate,PostCCKey(Loop,CCDep[Loop]),UseORate);


                        If (Syss.PostCCDCombo) then {* Post to combination *}
                          MTPost.LPost_To_CCNominal(FullNomKey(NomCode),0,0,LVal,Currency,PYr,PPr,1,BOff,BOn,BOff,
                                            CXRate,PostCCKey(Loop,CalcCCDepKey(Loop,CCDep)),UseORate);

                      end;
                      Loop:=Not Loop;

                    Until (Not Loop);
                  end;

                {$ENDIF}

              end;

            {$ENDIF}

          end;

          Reconcile:=RStatus;

         //PR: 20/03/2009 Changed to use Statement Date for Reconciliation Date (R0009)
          If (Reconcile=ReconC) then
            ReconDate:=ReconcileDate
          else
            ReconDate:=MaxUntilDate;

          Status:=MTExLocal^.LPut_Rec(IDetailF,Keypath);

          Report_BError(ScanFileNum,Status);
        end;

//        Status:=UnLockMultiSing(F[ScanFileNum],ScanFileNum,LAddr);
      end; {If locked..}
    end; {With..}
  end;
  {$ENDIF}
end; {Proc..}


procedure TfrmTransList.UpdateStatuses;
var
  Res, Res1, i : Integer;
  DetailRec : TTempTransDetails;
  KeyS : Str255;
  sSQLUpdate : string;
  FCompanyCode : string;
  sTempTable : string;
  s : ShortString;
begin
  if not SQLUtils.UsingSQL then
  begin
    Res := ReconcileObj.GetFirstLine;

    while Res = 0 do
    begin
      KeyS := ReconcileObj.LineRef;
      Res1 := Find_Rec(B_GetEq, TmpFile, RecTempF, DetailRec, 6, KeyS);

      if (Res1 = 0) then
      begin
        DetailRec.btdStatus := ReconcileObj.bnkDetail.brLineStatus;
        Put_Rec(TmpFile, RecTempF, DetailRec, 0);
      end;

      Res := ReconcileObj.GetNextLine;
    end;
  end
  else
  begin
  (* Don't think we need this
    FCompanyCode := CompanyCodeFromPath(oRecToolkit as IToolkit, SetDrive);
    sTempTable := ExtractFilename(btData.Filename);
    i := Pos('.', sTempTable);
    if i > 0 then
      Delete(sTempTable, i, 4);
    sSQLUpdate := Format(S_UPDATE_STATUSES, [FCompanyCode, sTempTable, FCompanyCode,
                                             LJVar(ReconcileObj.bnkHeader.brUserId, 10),
                                             ReconcileObj.bnkHeader.brGLCode,
                                             ReconcileObj.bnkHeader.brIntRef]);
    Try
      Res := SQLUtils.ExecSQL(sSQLUpdate, SetDrive);
      if Res <> 0 then
        raise Exception.Create(SQLUtils.LastSQLError);
    Except
      On E:Exception do
      begin
        with TStringList.Create do
        Try
          Add(E.Message);
          Add(sSQLUpdate);
        Finally
          SaveToFile('c:\UpdateStatuses_sqlerror.txt');
          Free;
        End;
      end;
    End;
    *)
    FCompanyCode := CompanyCodeFromPath(oRecToolkit as IToolkit, SetDrive);
    sTempTable := ExtractFilename(btData.Filename);
    i := Pos('.', sTempTable);
    if i > 0 then
      Delete(sTempTable, i, 4);


    sSQLUpdate := Format(SQL_DELETE_GROUP_RECS, [FCompanyCode, sTempTable]);
    Try
      Res := SQLUtils.ExecSQLEx(sSQLUpdate, SetDrive, I_TIMEOUT);
      if Res <> 0 then
        raise Exception.Create(SQLUtils.LastSQLError);


      sSQLUpdate := Format(SQL_DELETE_UNUSED_RECS, [FCompanyCode, sTempTable, FCompanyCode,
                                                    FCompanyCode, sTempTable]);

      Res := SQLUtils.ExecSQLEx(sSQLUpdate, SetDrive, I_TIMEOUT);
      if Res <> 0 then
        raise Exception.Create(SQLUtils.LastSQLError);


      s := FullNomKey(ReconcileObj.bnkHeader.brGLCode);
      //GS: 29/02/2012 ABSEXCH-11785 : added formatting checks to certain string arguments
      //(to check for quote chars that could break SQLs interpretation)
      //user IDs can potentially contain ['] chars; so preform a format check
      sSQLUpdate := Format(SQL_DELETE_RECONCILED_GROUP_RECS, [FCompanyCode, ReconcileObj.bnkHeader.brGLCode,
                                                         TSQLCaller.CompatibilityFormat(ReconcileObj.bnkHeader.brUserId),
                                                         ReconcileObj.bnkHeader.brIntRef]);

      Res := SQLUtils.ExecSQLEx(sSQLUpdate, SetDrive, I_TIMEOUT);
      if Res <> 0 then
        raise Exception.Create(SQLUtils.LastSQLError);

      //GS: 29/02/2012 ABSEXCH-11785 : added formatting checks to certain string arguments
      //(to check for quote chars that could break SQLs interpretation)
      //user IDs can potentially contain ['] chars; so preform a format check
      s := FullNomKey(ReconcileObj.bnkHeader.brGLCode);
      sSQLUpdate := Format(SQL_UPDATE_RECONCILED_LINES, [FCompanyCode, ReconcileObj.bnkHeader.brGLCode,
                                                         TSQLCaller.CompatibilityFormat(ReconcileObj.bnkHeader.brUserId),
                                                         ReconcileObj.bnkHeader.brIntRef]);
      Res := SQLUtils.ExecSQLEx(sSQLUpdate, SetDrive, I_TIMEOUT);
      if Res <> 0 then
        raise Exception.Create(SQLUtils.LastSQLError);

    Except
      On E:Exception do
      begin
      {$IFDEF PRDEBUG}
        with TStringList.Create do
        Try
          Add(E.Message);
          Add(sSQLUpdate);
        Finally
//          SaveToFile('c:\UpdateStatuses_sqlerror.txt');
          Free;
        End;
      {$ELSE}
        RaiseSQLError('TransList.UpdateStatuses',E.Message, sSQLUpdate);
      {$ENDIF}
      end;
    End;
  end;
//  ShowBalances;
end;

procedure TfrmTransList.ShowBalances;
var
  CurrentBalance : Double;
  Purch, Sales, Cleared : Double;
begin
  if SQLUtils.UsingSQL then
    ReconcileObj.ReconciledAmount := GetReconciledAmountSQL;
  ceStatBalance.Value := ReconcileObj.bnkHeader.brStatBal;
  ceReconciled.Value := ReconcileObj.ReconciledAmount;

  CurrentBalance := Profit_To_Date('B',CalcCCKeyHistP(ReconcileObj.bnkHeader.brGLCode,False,''),
                           ReconcileObj.bnkHeader.brCurrency,CurrentPeriod.CYr,CurrentPeriod.CPr,Purch,Sales,Cleared,BOn);

  //PR: 06/08/2013 ABSEXCH-13949 Amend to use Profit_To_Date figures for both ledger and opening balance - avoid calculating opening
  //                             balance manually.
  ceCurrent.Value := CurrentBalance;
  OpeningBalance := Cleared;
  ceOpenBalance.Value := {ceCurrent.Value - ceStatBalance.Value}OpeningBalance;
  if ListSettings.UnclearedOnly then
    ceDifference.Value := ceStatBalance.Value - ceOpenBalance.Value - ceReconciled.Value
  else
    ceDifference.Value := ceStatBalance.Value - ceReconciled.Value;
end;

procedure TfrmTransList.SetStatementComplete;
var
  KeyS : String;
  Res, Res2 : Integer;
  oStat : IBankStatement;
  oStatLine : IBankStatementLine;
  StatementBalance, CurrentTotal : Double;
begin
  with oRecToolkit.Banking do
  begin
    Res := BankAccount.GetEqual(BankAccount.BuildGLCodeIndex(oGL.glCode));
    if Res = 0 then
    begin
      Res := BankAccount.baStatement.GetEqual(BankAccount.baStatement.BuildDateAndFolioIndex(FCurrentStatement.bsDate,
                    FCurrentStatement.bsFolio));
      if Res = 0 then
      begin
        CurrentTotal := 0;
        StatementBalance := BankAccount.baStatement.bsBalance;
        with BankAccount.baStatement do
        begin
          Res2 := bsStatementLine.GetFirst;
          while Res2 = 0 do
          begin
            if bsStatementLine.bslStatus = bslsComplete then
              CurrentTotal := CurrentTotal + bsStatementLine.bslValue;
            Res := ReconcileObj.FindLine(FullNomKey(MaxInt) + FullNomKey(bsStatementLine.bslLineNo), 2);

            if Res = 0 then
            begin
              if (ReconcileObj.bnkDetail.brLineStatus = iComplete) and (bsStatementLine.bslStatus <> bslsComplete) then
              begin
                oStatLine := bsStatementLine.Update;
                oStatLine.bslStatus := bslsComplete;
                CurrentTotal := CurrentTotal + oStatLine.bslValue;
                Res := oStatLine.Save;
                oStatLine := nil;
              end;
            end;

            Res2 := bsStatementLine.GetNext;
          end;
        end;

        oStat := BankAccount.baStatement.Update;

        if Assigned(oStat) then
        begin
          if Abs(StatementBalance - CurrentTotal) < 0.001 then
            oStat.bsStatus := bssComplete
          else
            oStat.bsStatus := bssInProgress;
          Res := oStat.Save;
        end;
      end;
    end;
  end;
end;

procedure TfrmTransList.ShowMLoc;
var
  Res : Integer;
  KeyS : Str255;
  AList : TStringList;
  DataRec : MLocRec;
begin
  AList := TStringList.Create;

  KeyS := LteBankRCode + BankRecLineKey;
  Res := Find_Rec(B_GetGEq, F[MLocF], MLocF, DataRec, 0, KeyS);

  while (Res = 0) and (Pos(LteBankRCode + BankRecLineKey, KeyS) = 1) do
  begin
    AList.Add(DataRec.bnkRDRec.brMatchRef + ' : ' + IntToStr(DataRec.bnkRDRec.brStatLine));

    Res := Find_Rec(B_GetNext, F[MLocF], MLocF, DataRec, 0, KeyS);
  end;

{  AList.SaveToFile('c:\reconcile.txt');}
  AList.Free;
end;

function TFinaliseReconciliation.UpdateGroupReconcileLine(
  const PayInRef: string; LineRec : TTempTransDetails): Integer;
var
  KeyS, KeyChk : Str255;
  Res, Res1 : Integer;
  bLocked, Found : Boolean;
  DetailRec : BnkRDRecType;
  sRef : string;
  RefLen : Integer;
begin
  if Trim(PayInRef) <> '' then
  begin
    sRef := PayInRef;
    RefLen := 10;
  end
  else
  begin
    sRef := LineRec.btdLineKey;
    RefLen := 8;
  end;
  FillChar(DetailRec, SizeOf(DetailRec), 0);
  Result := 4;
  Found := False;
  KeyS := LteBankRCode + BankRecLineKey + FullNomKey(ReconcileObj.bnkHeader.brGLCode) +
                 LJVar(ReconcileObj.bnkHeader.brUserId, 10) +
             FullNomKey(ReconcileObj.bnkHeader.brIntRef) + FullNomKey(MaxInt) + FullNomKey(0) + '!';
  KeyChk := KeyS;
  Res := MTExLocal^.LFind_Rec(B_GetGEq, MLocF, 1, KeyS);

  while (Res = 0) and CheckKey(KeyS, KeyChk, 24, True) and not Found do
  begin
    Found := (Res = 0) and CheckKey(KeyS, KeyChk, 24, True) and
       CheckKey(MTExLocal^.LMLocCtrl^.BnkRDRec.brPayRef, sRef, RefLen, True) and
       ReconcileObj.GroupDateMatches(MTExLocal^.LMLocCtrl^.BnkRDRec.brLineDate, LineRec.btdDate);

    if not Found then
      Res := MTExLocal^.LFind_Rec(B_GetNext, MLocF, 1, KeyS);

  end;

  if Found then
  begin
    if MTExLocal^.LGetMultiRec(B_GetDirect,B_MultLock,KeyS,2,MLocF,BOff,bLocked) and bLocked then
    begin
      MTExLocal^.LMLocCtrl^.BnkRDRec.brLineStatus := iComplete;
      MTExLocal^.LPut_Rec(MLocF, 1);

      //PR: 14/07/2009 Was passing wrong address to Unlock - use 0 to force GetPos
      Res1 := MTExLocal^.UnLockMLock(MLocF,0);

      //PR: 28/01/2011 ABSEXCH-10262 I have no idea what these lines were intended to do! What they
      //actually do is create a duplicate line in the reconciliation for each line without a payinref.
{      MTExLocal^.LMLocCtrl.BnkRDRec.brMatchRef := LineRec.btdOurRef;
      MTExLocal^.LMLocCtrl.BnkRDRec.brValue := LineRec.btdAmount;
      MTExLocal^.LMLocCtrl.BnkRDRec.brLineNo := LineRec.btdLineNo;
      MTExLocal^.LMLocCtrl.BnkRDRec.brCustCode := LineRec.btdAcCode;
      MTExLocal^.LMLocCtrl.BnkRDRec.brLineNo := LineRec.btdLineNo;
      MTExLocal^.LMLocCtrl.BnkRDRec.brBnkDCode1 := BuildLineIndex(bnkHeader.brUserId, bnkHeader.brGLCode,
                                            bnkHeader.brIntRef, LineRec.btdLineNo);
      MTExLocal^.LMLocCtrl.BnkRDRec.brBnkDCode2 := BuildTransLineIndex(bnkHeader.brUserId, bnkHeader.brGLCode, bnkHeader.brIntRef,
                                                LineRec.btdFolioRef, LineRec.btdLineNo);
      MTExLocal^.LAdd_Rec(MLocF, 1);}
    end;
    Result := 0;
  end;
end;

procedure TfrmTransList.SetTaggedValues;
var
  Res : Integer;
  LTempDetailRec : TTempTransDetails;
  ThisRecType : Byte;
  KeyS : Str255;
begin

  TagCount[0] := 0;
  TagCount[1] := 0;

  TagTotal[0] := 0;
  TagTotal[1] := 0;

  Res := Find_Rec(B_GetFirst, Tmpfile, RecTempF, LTempDetailRec, 0, KeyS);

  while Res = 0 do
  begin
    ThisRecType := 2;
    if LTempDetailRec.btdStatus and iTag = iTag then
    begin
      if LTempDetailRec.btdDocType = 'RUN' then
      begin
        if not ReconcileObj.FindGroupMatch(LTempDetailRec.btdPayInRef, LTempDetailRec.btdLineKey) then
          ThisRecType := 1;
      end
      else
      if ReconcileObj.FindLine(LTempDetailRec.btdLineKey, 1) <> 0 then
        ThisRecType := 0;

      if ThisRecType < 2 then
      begin
        TagCount[ThisRecType] := TagCount[ThisRecType] + 1;
        TagTotal[ThisRecType] := TagTotal[ThisRecType] + LTempDetailRec.btdAmount;
      end;
    end;

    Res := Find_Rec(B_GetNext, Tmpfile, RecTempF, LTempDetailRec, 0, KeyS);
  end;
end;

procedure TfrmTransList.SaveTags;
var
  Res : Integer;
  LTempDetailRec : TTempTransDetails;
  ThisRecType : Byte;
  KeyS : Str255;
begin

  Res := Find_Rec(B_GetFirst, Tmpfile, RecTempF, LTempDetailRec, 0, KeyS);

  while Res = 0 do
  begin
    ThisRecType := 2;
    if LTempDetailRec.btdStatus and iTag = iTag then
    begin
      ReconcileObj.AddTag(LTempDetailRec);
{      if LTempDetailRec.btdDocType = 'RUN' then
      begin
        if not ReconcileObj.FindGroupMatch(LTempDetailRec.btdPayInRef) then
          ThisRecType := 1;
      end
      else
      if ReconcileObj.FindLine(LTempDetailRec.btdLineKey, 1) <> 0 then
        ThisRecType := 0;

      if ThisRecType < 2 then
      begin
        TagCount[ThisRecType] := TagCount[ThisRecType] + 1;
        TagTotal[ThisRecType] := TagTotal[ThisRecType] + LTempDetailRec.btdAmount;
      end;}
    end;

    Res := Find_Rec(B_GetNext, Tmpfile, RecTempF, LTempDetailRec, 0, KeyS);
  end;
end;

procedure TfrmTransList.btnMatchClick(Sender: TObject);
begin
  if Assigned(FStatementForm) then
  begin
//    FStatementForm.Match(FStatementForm.ctkData.GetRecord as IBankStatementLine);
    FStatementForm.btnTagClick(FStatementForm);

    ShowBalances;
  end;
end;

procedure TfrmTransList.UpdateReconcile(bStoreRec : Boolean = True);
begin
  if Assigned(FCurrentStatement) {and (ReconcileObj.bnkHeader.brStatus <> bssComplete)} then
  begin
    ReconcileObj.bnkHeader.brStatDate := FCurrentStatement.bsDate;
    ReconcileObj.bnkHeader.brStatFolio := FCurrentStatement.bsFolio;
    ReconcileObj.bnkHeader.brStatRef := FCurrentStatement.bsReference;
    if Trim(ReconcileObj.bnkHeader.brReconRef) = '' then
      ReconcileObj.bnkHeader.brReconRef := FCurrentStatement.bsReference;
  end;
  ReconcileObj.bnkHeader.brOpenBal := ceOpenBalance.Value;
  ReconcileObj.bnkHeader.brCloseBal := ceCurrent.Value{ - ceDifference.Value};
  ReconcileObj.bnkHeader.brStatus := 0;
  ReconcileObj.UpdateHeader(bStoreRec);

end;

procedure TfrmTransList.RunReconcileReport;
var
  Params : TReconRepParams;
begin
    Params.GLCode := oGL.glCode;
    Params.GLDesc := Trim(oGL.glName);
    Params.UserID := GetUserID;
    Params.ReconFolio := ReconcileObj.bnkHeader.brIntRef;
    Params.SortOrder := 0;
    Params.GroupItems := False;

    AddBankReconcileRep2Thread(0, Params, Application.MainForm);
end;

function TfrmTransList.CreateDifferenceJournal : Boolean;
var
  NomDefaults : TNomDefaults;
  oNom : ITransaction4;
  oLine : ITransactionLine3;
  Res : Integer;
  Diff : Double;
  DlgResult : Byte;
  ExLocal: TdExLocal;
  NOMKey: Integer;
  KeyS: Str255;
  PwrdPosition: LongInt;
  InvPosition: LongInt;
  iStatus : Integer;

  procedure SetCCDept;
  begin
    if Syss.UseCCDep then
    begin
      oLine.tlCostCentre := NomDefaults.ndCC;
      oLine.tlDepartment := NomDefaults.ndDep;
    end;
  end;

  procedure SetStaticDefaults;
  begin
    oLine.tlQty := 1;

    //PR: 17/08/2009 Daily & Company Rates weren't being set.
    oLine.tlDailyRate := oRecToolkit.SystemSetup.ssCurrency[ListSettings.WantedCurrency].scDailyRate;
    oLine.tlCompanyRate := oRecToolkit.SystemSetup.ssCurrency[ListSettings.WantedCurrency].scCompanyRate;
    oLine.tlCurrency := ListSettings.WantedCurrency;
  end;

  function OutputFloat(Value : Double) : string;
  begin
    Result := Trim(FormatFloat('###,###,###.00', Diff));
    if Result[1] = '-' then
      Result := Copy(Result, 2, Length(Result)) + '-';
    Result := CurrencySymbol + Result;
  end;

(*  procedure SetStatementLines;
  var
    LRes : Integer;
    LocalTempDetailRec : TTempTransDetails;
    RecKeyS : Str255;
  begin
    if Assigned(FCurrentStatement) then
    with FCurrentStatement do
    begin
      LRes := bsStatementLine.GetFirst;

      while LRes = 0 do
      begin
        if ((ReconcileObj.FindLine(FullNomKey(MaxInt) + FullNomKey(bsStatementLine.bslLineNo), 2) <> 0) and not
           ReconcileObj.FindGroupMatch(bsStatementLine.bslReference, )) then
        begin
          ReconcileObj.AddMatch(bsStatementLine, oNom);
          with bsStatementLine.Update do
          begin
            bslStatus := bssComplete;
            LRes := Save;
            if LRes <> 0 then
              ShowMessage('Unable to store statement line. Error ' + IntToStr(LRes));
          end;
        end;
        LRes := bsStatementLine.GetNext;
      end;
    end
    else
    begin
    //Set all transaction lines to complete
      LRes := Find_Rec(B_StepFirst, TmpFile, RecTempF, LocalTempDetailRec, 0, RecKeyS);

      while LRes = 0 do
      begin
        LocalTempDetailRec.btdStatus := iComplete;
        LRes := Put_Rec(TmpFile, RecTempF, LocalTempDetailRec, 0);

        LRes := Find_Rec(B_StepNext, TmpFile, RecTempF, LocalTempDetailRec, 0, RecKeyS);
      end;

    end;
  end; *)

begin
  Result := True;
  Diff := Round_Up(ceDifference.Value, 2);

  if Diff <> 0.00 then
  begin
    DlgResult := msgBox('There is an amount of ' + OutputFloat(Diff) +
                        ' outstanding on this statement'#10'Do you wish to create a nominal journal for this amount?'
                           , mtConfirmation, mbYesNoCancel,
                         mbYes, 'Bank Reconciliation');
    if DlgResult = mrYes then
    begin
      Result := False;
      if GetJournalDefaults(oRecToolkit, NomDefaults, Syss.UseCCDep, Self) then
      begin
       //PR: 20/12/2011 Set toolkit user id, so that the audit note added when the transaction is created in the toolkit looks
       //exactly like those created in Exchequer.
       with oRecToolkit.Configuration as IBetaConfig do
         UserID := EntryRec^.Login;

        oNom := oRecToolkit.Transaction.Add(dtNMT) as ITransaction4;
        with oNom do
        begin
          thTransDate := Today;
          //Bank line
          oLine := thLines.Add as ITransactionLine3;

          oLine.tlGLCode := oGL.glCode;
          oLine.tlNetValue := Diff;
          SetCCDept;
          oLine.tlDescr := 'Bank rec adjustment ';
          if Assigned(FCurrentStatement) then
            oLine.tlDescr := oLine.tlDescr + FCurrentStatement.bsReference;
          SetStaticDefaults;
          oLine.Save;

          //balancing line
          oLine := thLines.Add as ITransactionLine3;

          oLine.tlGLCode := NomDefaults.ndGLCode;
          if not (NomDefaults.ndVatCode in ['N', 'Z']) then
          begin
            thManualVat := True;
            ((oLine as ITransactionLine3).tlAsNOM as ITransactionLineAsNom2).tlnNomVatType := nlvManual;
            oLine.tlVATCode := NomDefaults.ndVatCode;
            oLine.tlVATAmount := -NomDefaults.ndVatAmount;
            if NomDefaults.ndVatCode = 'I' then
            begin
              oLine.tlInclusiveVATCode := NomDefaults.ndIncVat;
              (oLine as ITransactionLine3).tlVATIncValue := -Diff;
            end;
            thNetValue := -oLine.tlVATAmount;
            thTotalVat := oLine.tlVatAmount;
            thVatAnalysis[NomDefaults.ndVatCode] := thTotalVat;

            with oNom.thAsNOM as ITransactionAsNom2 do
              if Diff > 0 then //vat is -ve
                tnVatIO := vioOutput
              else
                tnVatIO := vioInput;

{            if NomDefaults.ndVatCode = 'I' then
              oLine.tlNetValue := -Diff
            else}
              oLine.tlNetValue := -(Diff - NomDefaults.ndVatAmount);
          end
          else
            oLine.tlNetValue := -Diff;
          SetCCDept;
          oLine.tlQty := 1;
          oLine.tlDescr := NomDefaults.ndDescription;
          SetStaticDefaults;

          oLine.Save;

          Res := Save(True);

          //PR: 20/12/2011 he transaction is added in the toolkit, so removed Gareth's code below to avoid getting two audit notes.

          //GS add an audit note to the newly created nominal tx header
{          if Res = 0 then
          begin
            try
              //create local record obj
              ExLocal.Create;
              //store the position of global files that we will be using
              GetPos(F[InvF], InvF, InvPosition);
              GetPos(F[PwrdF], PwrdF, PwrdPosition);

              //search for the TX record we have just created; store it in the local object
              KeyS := FullNomKey(oNom.thFolioNum);
              iStatus := Find_Rec (B_GetEq, F[InvF], InvF, ExLocal.LRecPtr[InvF]^, InvFolioK, KeyS);

              //if found, add the audit note
              if iStatus = 0 then
              begin
                TAuditNote.WriteAuditNote(anTransaction, anCreate, ExLocal);
              end;

              //restore the positions of the files that we have interacted with
              SetDataRecOfs(InvF, InvPosition);
              SetDataRecOfs(PwrdF, PwrdPosition);
              GetDirect(F[InvF], InvF, RecPtr[InvF]^, InvCustK , 0);
              GetDirect(F[PwrdF], PwrdF, RecPtr[PwrdF]^, PWK , 0);
            finally
                //cleanup local record object
                ExLocal.Destroy;
            end;
          end;}

          if Res = 0 then
          begin
            Result := True;
            DifferenceFolio := thFolioNum;
            DifferenceLineNo := thLines[1].tlABSLineNo;
//            SetStatementLines;
          end
          else
            msgBox('Unable to create Nominal Journal'#10#10'Error: ' + QuotedStr(oRecToolkit.LastErrorString),
                    mtError, [mbOK], mbOK, 'Bank Reconciliation');

        end;
      end;
    end
    else
      Result := DlgResult = mrNo;
  end;
end;

procedure TfrmTransList.RemoveAllTags;
var
  Res, i : Integer;
  LDetailRec : TTempTransDetails;
  KeyS : Str255;
begin
  Res := Find_Rec(B_GetLast, TmpFile, RecTempF, LDetailRec, 2, KeyS);

  while (Res = 0) and (LDetailRec.btdStatus and iTag = iTag) do
  begin
    LDetailRec.btdStatus := LDetailRec.btdStatus and not iTag;
    Put_Rec(TmpFile, RecTempF, LDetailRec, 2);
    Res := Find_Rec(B_GetLast, TmpFile, RecTempF, LDetailRec, 2, KeyS);
  end;
end;

procedure TfrmTransList.mlTransColumnClick(Sender: TObject;
  ColIndex: Integer; Button: TMouseButton; Shift: TShiftState; X,
  Y: Integer);
begin
  Case ColIndex of
    0 : mlTrans.HelpContext := 1920;
    1 : mlTrans.HelpContext := 1921;
    2 : mlTrans.HelpContext := 1922;
    3 : mlTrans.HelpContext := 1923;
    4 : mlTrans.HelpContext := 1928;
    5 : mlTrans.HelpContext := 1924;
    6 : mlTrans.HelpContext := 1925;
    7 : mlTrans.HelpContext := 1926;
    8 : mlTrans.HelpContext := 1927;
  end;
end;

procedure TfrmTransList.SetHelpContexts;
begin
  //Called from TabControl change to set Help Contexts for form, list & panels
  HelpContext := hcList[TabControl1.TabIndex];
  mlTrans.HelpContext := hcList[TabControl1.TabIndex];
  TabControl1.HelpContext := hcList[TabControl1.TabIndex];
  pnlButtons.HelpContext := hcList[TabControl1.TabIndex];
  pnlItemTop.HelpContext := hcList[TabControl1.TabIndex];
  pnlItemBottom.HelpContext := hcList[TabControl1.TabIndex];
end;

{ CS: 14/07/2008 - Amendments for Form Resize routines }
procedure TfrmTransList.FormEndResize(var Msg: TMsg);
begin
  { Finished resizing the form. Force a complete refresh of the list columns. }
  IsResizing := False;
  Screen.Cursor := crAppStart;
  try
    FormResize(self);
  finally
    Screen.Cursor := crDefault;
  end;
end;

{ CS: 14/07/2008 - Amendments for Form Resize routines }
procedure TfrmTransList.FormStartResize(var Msg: TMsg);
begin
  { User is starting to resize the form. Suppress the update of the list
    columns until the resize finishes. }
  IsResizing := True;
end;

procedure TfrmTransList.SetClearAllCaption(SetToClear: Boolean);
begin
  if SetToClear then
    btnClearAll.Caption := 'Unclear All'
  else
    btnClearAll.Caption := 'Clear All';
end;

procedure TfrmTransList.btnClearAllClick(Sender: TObject);
var
  bClearAll : Boolean;
begin
  bClearAll := btnClearAll.Caption[1] = 'C';
  btnClearAll.Enabled := False;
  Screen.Cursor := crHourGlass;
  SetClearAllCaption(bClearAll);
  ClearOrUnclearAll(bClearAll);
  Screen.Cursor := crDefault;
  btnClearAll.Enabled := True;
end;

procedure TfrmTransList.ClearOrUnclearAll(SetToClear: Boolean);
var
  Res : Integer;
  TempDetailRec : TTempTransDetails;
  KeyS : Str255;
  RecAddr : longint;
begin
  Res := Find_Rec(B_GetFirst, Tmpfile, RecTempF, TempDetailRec, idxDocType, KeyS);
  while Res = 0 do
  begin
    if TempDetailRec.btdDocType <> 'RUN' then
    begin
      //Store position
      Res := GetPos(TmpFile, RecTempF, RecAddr);

      if SetToClear then
      begin
        TempDetailRec.btdStatus := (TempDetailRec.btdStatus and not 3) or 1;
        TempDetailRec.btdReconDate := ListSettings.ReconDate;
        ReconcileObj.AddClearedRec(TempDetailRec);
        WriteRec(TempDetailRec);
          if Trim(TempDetailRec.btdPayInRef) <> '' then
            UpdateGroupCleared(TempDetailRec.btdPayInRef, TempDetailRec.btdDate, TempDetailRec.btdStatus)
          else
            UpdateGroupCleared(TempDetailRec.btdLineKey, TempDetailRec.btdDate, TempDetailRec.btdStatus);
//        UpdateGroupCleared(TempDetailRec.btdPayInRef, TempDetailRec.btdStatus); //PR: 31/03/2009 Changed from UpdateClearedLines which was the wrong function
      end
      else
      begin
        with TempDetailRec do
        begin
          btdStatus := btdStatus and not 3;
          ReconcileObj.SetClearedRec(TempDetailRec);
          TempDetailRec.btdReconDate := '        ';
        end; //with DetailRec

       WriteRec(TempDetailRec);
          if Trim(TempDetailRec.btdPayInRef) <> '' then
            UpdateGroupCleared(TempDetailRec.btdPayInRef, TempDetailRec.btdDate, TempDetailRec.btdStatus, False)
          else
            UpdateGroupCleared(TempDetailRec.btdLineKey, TempDetailRec.btdDate, TempDetailRec.btdStatus, False);
//       UpdateGroupCleared(TempDetailRec.btdPayInRef, TempDetailRec.btdStatus, False); //PR: 31/03/2009 Changed from UpdateClearedLines which was the wrong function
      end; // else

      //Restore Position
      Move(RecAddr, TempDetailRec, SizeOf(RecAddr));
      Res := GetDirect(TmpFile, RecTempF, TempDetailRec, idxDocType, 0);
    end; //not RUN

    Res := Find_Rec(B_GetNext, Tmpfile, RecTempF, TempDetailRec, idxDocType, KeyS);
  end;
  mlTrans.RefreshDB;
  ShowBalances;
end;

function TfrmTransList.CurrentDetailsRecord: TTempTransDetails;
var
  pDetails : PTempTransDetails;
begin
  pDetails := btData.GetRecord;
  Result := pDetails^;
end;

//=====================

constructor TBankScan.Create(AOwner: TObject);
begin
    Inherited Create(AOwner);

    fTQNo:=3;
    fCanAbort:=BOn;

//    IsParentTo:=BOn;

    fOwnMT:=BOn; {* This must be set if MTExLocal is created/destroyed by thread *}

    MTExLocal:=nil;
end;

destructor TBankScan.Destroy;
begin
  inherited;
end;

procedure TBankScan.Finish;
begin
  inherited;
  TotalRecCount := RecCount;
  ReconcileObj.CloseSession;
  PostMessage(CallBackWindow,WM_CustGetRec,55,IncludeCount);
//  Dispose(MTExLocal, Destroy);
end;

procedure TBankScan.Process;
var
  Res, Res1 : Integer;
  KeyS, KeyChk, RecKeyS, KeyS1 : Str255;
  c : integer;
  LocalTempDetailRec : TTempTransDetails;
  GroupCount, UpCount : longint;
  dTmp, ThisAmount : Double;
  tmpStat : Integer;
  StatusSet : Boolean;

  function ConvertValue(Val : Double; XRate : CurrTypes; Curr : Byte) : Double;
  begin
    Result := Conv_TCurr(Val,
                         XRate[(Syss.TotalConv=XDayCode)], Curr, 0, False);
  end;

  //PR: 14/10/2011 As we now need to make this check twice, I've moved it into a function
  function GroupRecordFound : Boolean;
  begin
    Result := (Trim(TempDetailRec.btdPayInRef) = Trim(LocalTempDetailRec.btdPayInRef)) and
              (Trim(TempDetailRec.btdPayInRef) <> '') and
              //PR: 14/10/2011 Added group by functionality to allow ref and date or ref only. ABSEXCH-10076
              (
                ReconcileObj.GroupDateMatches(TempDetailRec.btdDate, LocalTempDetailRec.btdDate)
              );

  end;
begin
  c := 0;
  IncludeCount := 0;
  OpeningBalance := 0;
  OpenUncleared := 0;
  InMainThread:=BOn;
  GroupCount := 0;
  Inherited Process;
  Res := Open_fileCID(LTmpFile, FullTmpFileName, 0, MTExLocal^.ExClientID);
  ShowStatus(0,'Building bank transaction list');
  KeyS := FullNomKey(GLCode) + #0 + Char(Currency);
  KeyChk := KeyS;
  With MTExLocal^ do
  Try
    Res := LFind_Rec(B_GetGEq, IDetailF, 2, KeyS);
    InitProgress(100);
    UpdateProgress(0);
    //PR: 31/03/2009 changed to check nom mode & currency
    while (Res = 0) and
    ((Copy(KeyS, 1, 6) = Copy(KeyChk, 1, 6)) or {consolidated}((Currency = 0) and (LID.NomCode  = GLCode))) do
//    while (Res = 0) and (LID.NomCode  = GLCode) do
    begin
      inc(c);
      ShowStatus(1,Format('Processing record %d of %d',[c, RecCount]));
      //PR: 12/03/2009 Added handling for specific Reconciliation Date only
      if (not ListSettings.UseReconDate or (LID.ReconDate = ListSettings.ReconDate)) then
      begin
        Inc(IncludeCount);
        if Currency > 0 then
          ThisAmount := DetLTotal(LId,Not Syss.SepDiscounts,BOff,0.0)
        else
          ThisAmount  := ConvertValue(DetLTotal(LId,Not Syss.SepDiscounts,BOff,0.0), LID.CXrate, LID.Currency);

        if (LID.Reconcile = 1) then
          OpeningBalance := OpeningBalance + ThisAmount
        else
          OpenUncleared := OpenUncleared + ThisAmount;

        if ((LID.Currency > 0) or (Currency = 0)) and
           //PR: 07/09/2009 Remove Cancelled & Returned from uncleared list
           (not ListSettings.UnclearedOnly or not (LID.Reconcile in [1..3])) then
        begin
          dTmp := c;
          ShowStatus(2,Format('Found so far: %d of %d',[c, RecCount]));
          UpCount := Trunc(SafeDiv(dTmp, RecCount) * 100);
          UpdateProgress(UpCount);
          FillChar(TempDetailRec, SizeOf(TempDetailRec), 0);
          with TempDetailRec do
          begin
            btdDocType := DocCodes[LID.IDDocHed];
            btdYear    := LID.PYr;
            btdPeriod  := LID.PPr;
            btdAcCode  := Trim(LID.CustCode);
            btdDesc    := LID.Desc;
  {          if Currency > 0 then
              btdAmount := LID.NetValue * DocCnst[LID.IdDocHed]
            else
              btdAmount  := ConvertValue(LID) * DocCnst[LID.IdDocHed];}
            if Currency > 0 then
              btdAmount := DetLTotal(LId,Not Syss.SepDiscounts,BOff,0.0)
            else
              btdAmount  := ConvertValue(DetLTotal(LId,Not Syss.SepDiscounts,BOff,0.0), LID.CXrate, LID.Currency);
            btdStatus  := LID.Reconcile;
  {          RecKeyS := FullNomKey(LID.FolioRef) + FullNomKey(LID.LineNo);
            if ReconcileObj.FindLine(RecKeyS, 1) = 0 then
              btdStatus := 1;}
            btdDate    := LID.PDate;
            if Length(LID.StockCode) > 0 then
            begin
              if LID.StockCode[1] = #1 then
              begin
                btdPayInRef := LJVar(Extract_PayRef2(LID.StockCode), 16);
                if Trim(btdPayInRef) = '' then
                  btdPayInRef := LJVar(LID.Desc, 16);
              end
              else //If we don't have a PayInRef then use the line desc which, on Payment lines, will contain Cheque Nos
                btdPayInRef := LJVar(LID.Desc, 16); //PR: 21/09/2016 ABSEXCH-12513 Was using stock code rather than desc
            end;

            btdOurRef := LID.DocPRef;
            btdLineKey := FullRunNoKey(LID.FolioRef, {LID.AbsLineNo}c);
  {          if btdLineKey[8] = #0 then
              btdLineKey[8] := '!';}
            LGetRecAddr(IDetailF);
            btdLineAddr := LastRecAddr[IDetailF];
            btdFolioRef := LID.FolioRef;
            btdLineNo := {LID.AbsLineNo}c;
            btdPostedRun := LID.PostedRun;
            btdIdDocHed := LID.IdDocHed;

            if (LID.Reconcile = 1) then
            begin
//              ReconcileObj.ReconciledAmount := ReconcileObj.ReconciledAmount + btdAmount;
              btdStatus := 1;
              btdReconDate := LID.ReconDate;
            end;

            if (ListSettings.ExistingReconcile) then
            begin
              TmpStat := ReconcileObj.FindStatusFromList(btdLineKey);
              if TmpStat >= 0 then
                btdStatus := (TmpStat and 255);
              btdStatLine := ReconcileObj.FindStatLineFromList(btdLineKey);
               { (ReconcileObj.FindLine(btdLineKey, 1) = 0)) then
                   btdStatus := ReconcileObj.bnkDetail.brLineStatus;}
            end;

            if (ListSettings.ExistingReconcile) and ReconcileObj.FindTagFromList(TempDetailRec) then
            begin
              TempDetailRec.btdStatus := {TempDetailRec.btdStatus or} iTag;
              ReconcileObj.DeleteTag(TempDetailRec);
            end;

            StatusSet := (LID.Reconcile in [1..3]) or (btdStatus in [1..3]);
            if StatusSet then
              ReconcileObj.SetClearedRec(TempDetailRec);

            Res1 := Add_RecCID(LTmpFile, RecTempF, TempDetailRec, 9, MTExLocal^.ExClientID);

            KeyS1 := 'RUN' + LJVar(btdPayInRef, 16);



          end;


          ReconcileObj.NoUpdate := True;
          //Check if we already have a group record for this PayInRef - if so update it,
          //otherwise add it
          Res1 := Find_RecCID(B_GetGEq, LTmpFile, RecTempF, LocalTempDetailRec, 9, KeyS1, MTExLocal^.ExClientID);

          //PR: 14/10/2011 We need to check through all group records for this PayInRef to ensure that we've got the correct one. ABSEXCH-10076
          while (Res1 = 0) and (LocalTempDetailRec.btdDocType = 'RUN') and not GroupRecordFound do
             Res1 := Find_RecCID(B_GetNext, LTmpFile, RecTempF, LocalTempDetailRec, 9, KeyS1, MTExLocal^.ExClientID);


          if (Res1 = 0) and (LocalTempDetailRec.btdDocType = 'RUN') and GroupRecordFound then
          begin
            if (ListSettings.ExistingReconcile) and
               (ReconcileObj.FindStatusFromList(TempDetailRec.btdLineKey) = iMatch) then
                 inc(LocalTempDetailRec.btdNumberMatched);
            LocalTempDetailRec.btdAmount := LocalTempDetailRec.btdAmount +  TempDetailRec.btdAmount;
            Inc(LocalTempDetailRec.btdNoOfItems);
            if TempDetailRec.btdStatus = 1 then
              Inc(LocalTempDetailRec.btdNumberCleared);

            //Only maintain status if all items have the same status
            if (TempDetailRec.btdStatus <> LocalTempDetailRec.btdStatus) then
              LocalTempDetailRec.btdStatus := 0;
            Put_RecCID(LTmpFile, RecTempF, LocalTempDetailRec, 9, MTExLocal^.ExClientID);
            if StatusSet then
              ReconcileObj.SetClearedRec(TempDetailRec);
          end
          else
          begin
            Inc(GroupCount);
            TempDetailRec.btdDocType := 'RUN';
            TempDetailRec.btdAcCode := '';
            TempDetailRec.btdOurRef := 'RUN';
            TempDetailRec.btdNoOfItems := 1;
            //PR: 01/06/2009 If no PayInRef then we can't get back from group to single - so set FullPayInRef as key
            if (TempDetailRec.btdPayInRef = '') then
              TempDetailRec.btdFullPayInRef := TempDetailRec.btdLineKey;
            TempDetailRec.btdFolioRef := MaxInt;
            TempDetailRec.btdLineNo := GroupCount;
            TempDetailRec.btdLineKey := FullNomKey(MaxInt) + FullNomKey(GroupCount);
(*            if (ListSettings.ExistingReconcile) and
              { (ReconcileObj.FindLine(TempDetailRec.btdLineKey, 1) = 0) and
               (ReconcileObj.bnkDetail.brLineStatus = iMatch)}
               (ReconcileObj.FindStatusFromList(TempDetailRec.btdLineKey) = iMatch) then
                 inc(LocalTempDetailRec.btdNumberMatched); *)
            if TempDetailRec.btdStatus = 1 then
              TempDetailRec.btdNumberCleared := 1
            else
            if TempDetailRec.btdStatus = iMatch then
              TempDetailRec.btdNumberMatched := 1;
            if (ListSettings.ExistingReconcile) and ReconcileObj.FindTagFromList(TempDetailRec) then
            begin
              TempDetailRec.btdStatus := iTag;
              ReconcileObj.DeleteTag(TempDetailRec);
            end;
  {          else
              TempDetailRec.btdStatus := 0;}
            Add_RecCID(LTmpFile, RecTempF, TempDetailRec, 9, MTExLocal^.ExClientID);
            if StatusSet then
              ReconcileObj.SetClearedRec(TempDetailRec);
          end;
          ReconcileObj.NoUpdate := False;
        end;
      end; //if (not ListSettings.UseReconDate or (LID.ReconDate = ListSettings.ReconDate))

      Res := LFind_Rec(B_GetNext, IDetailF, 2, KeyS);
    end;
  Finally;
    if UsingSQL then
      CloseClientIDSession(MTExLocal^.ExClientId);
    UpdateProgress(100);
    MTExLocal^.Close_Files;
  End;

end;

function TBankScan.Start: Boolean;
Var
  mbRet  :  Word;
  KeyS   :  Str255;
  KeyChk :  Str255;
  Res : Integer;
Begin
  OutputDebugString(PChar('Main Thread = ' + IntToStr(GetCurrentThreadID)));
  Result:=BOn;
  RecCount := 0;
  ReconcileObj.bnkHeader.brReconRef := ListSettings.Ref;
  If (Not Assigned(MTExLocal)) then { Open up files here }
  Begin
    New(MTExLocal,Create(cidBankRec1));

    try
      With MTExLocal^ do
      Try
        Open_System(IDetailF, IDetailF);
        KeyS := FullNomKey(GLCode) + #0 + Char(Currency);
        KeyChk := KeyS;
        //PR: 31/03/2009 Removed KeyOnly, as it ignores duplicate keys - hence gives an inaccurate count.
        Res := LFind_Rec(B_GetGEq{+B_KeyOnly}, IDetailF, 2, KeyS);

        while (Res = 0) and
        ((Copy(KeyS, 1, 6) = Copy(KeyChk, 1, 6)) or {consolidated}((Currency = 0) and (LID.NomCode  = GLCode))) do
        begin
          inc(RecCount);
          Res := LFind_Rec(B_GetNext{+B_KeyOnly}, IDetailF, 2, KeyS);
        end;
      Finally
        if UsingSQL then
          CloseClientIDSession(MTExLocal^.ExClientId);
      End;
    except
      Dispose(MTExLocal,Destroy);
      MTExLocal:=nil;

    end; {Except}

    Result:=Assigned(MTExLocal);
  end;
end;



procedure TfrmTransList.TabControl1Changing(Sender: TObject;
  var AllowChange: Boolean);
begin
  SelectedRec[TabControl1.TabIndex] := mlTrans.Position;
end;

function TFinaliseReconciliation.GetSQLRecordCount: Integer;
var
  V : Variant;
  Res : Integer;
  sQuery : String;
begin
  sQuery := Format(SQL_COUNT_QUERY, [TmpTableName(FullTmpFileName)]);
  Res := SQLUtils.SQLFetch(sQuery, 'RecCount', SetDrive, V);
  if Res = 0 then
    Result := V
  else
    Result := 0;
end;

{ TReconcileSQL }

constructor TReconcileSQL.Create(AOwner: TObject);
begin
    Inherited Create(AOwner);

    fTQNo:=3;
    fCanAbort:=BOn;

//    IsParentTo:=BOn;

    fOwnMT:=BOn; {* This must be set if MTExLocal is created/destroyed by thread *}

    MTExLocal:=nil;
end;

destructor TReconcileSQL.Destroy;
begin
  if Assigned(StatList) then
    StatList.Free;

  inherited;
end;

procedure TReconcileSQL.Finish;
begin
  inherited;
  ReconcileObj.CloseSession;
  PostMessage(CallBackWindow,WM_CustGetRec,56,0);
end;

procedure TReconcileSQL.Process;
var
  sSQLQuery, sTable : String;
  Res : Integer;
begin

  Inherited Process;
  sTable := TmpTableName(FullTmpFileName);

  ShowStatus(0,'Checking individual transaction lines');

    sSQLQuery := Format(SQL_MATCH_ITEMS, [sTable, ReconcileObj.bnkHeader.brIntRef]);
    Res := SQLUtils.ExecSQLEx(sSQLQuery, SetDrive, I_TIMEOUT);
    if Res <> 0 then
      raise Exception.Create(SQLUtils.LastSQLError);
    UpdateProgress(50);

    iGLCode := GLCode;
    sSQLQuery := Format(SQL_INSERT_MATCHED_LINES, [BuildSQLIndex1,
                                                   BuildSQLIndex2,
                                                   BuildSQLIndex3,
                                                   ReconcileObj.bnkHeader.brGLCode,
                                                   ReconcileObj.bnkHeader.brIntRef,
                                                   sTable]);
    Res := SQLUtils.ExecSQLEx(sSQLQuery, SetDrive, I_TIMEOUT);
    if Res <> 0 then
      raise Exception.Create(SQLUtils.LastSQLError);



//  ShowStatus(0,'Checking grouped transaction lines');



  UpdateProgress(100);
end;

function TReconcileSQL.Start: Boolean;
begin
  Result:=BOn;
  FReconObj := TBankReconciliation.Create(cidBankRec2);
end;

procedure TfrmTransList.EnableButtons(SetOn: Boolean);
var
  i : Integer;
begin
  for i := 0 to ComponentCount - 1 do
    if Components[i] is TButton then
       with Components[i] as TButton do
         if Visible then
           Enabled := SetOn;
end;

Initialization
  frmTransList := nil;
  CurrentStatement := nil;
  DefineBankRecTemp;

end.
