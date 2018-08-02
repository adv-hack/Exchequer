unit TransLst;

{$I DEFOVR.Inc}

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, TCustom, uMultiList, uDBMultiList, ComCtrls, ExtCtrls,
  SBSPanel, TEditVal, Menus, Enterprise01_TLB, uExDatasets, uComTKDataset,
  BankList, TranFile, uBtrieveDataset, ExBtTh1U, Tranl1U, VarConst, ExWrap1U,
  BtSupU1, Varrec2u, StatForm, uSettings,
  ReconObj, EnterToTab, PostingU, csvp;



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
    pnlButtons: TPanel;
    ScrollBox1: TScrollBox;
    btnOK: TSBSButton;
    btnClear: TSBSButton;
    btnUnclear: TSBSButton;
    btnTag: TSBSButton;
    btnFind: TSBSButton;
    btnProcess: TSBSButton;
    btnCancel: TSBSButton;
    btnStatement: TSBSButton;
    btnEBank: TSBSButton;
    PopupMenu1: TPopupMenu;
    EBank1: TMenuItem;
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
    btnView: TSBSButton;
    btnAdjustment: TSBSButton;
    btnFilter: TSBSButton;
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
    NominalJournal1: TMenuItem;
    PurchasePayment1: TMenuItem;
    PurchasePaymentwithInvoice1: TMenuItem;
    SalesReceipt1: TMenuItem;
    SalesReceiptwithInvoice1: TMenuItem;
    btnCheck: TSBSButton;
    RemoveFilter1: TMenuItem;
    mnuDocType: TMenuItem;
    mnuAcCode: TMenuItem;
    mnuRef: TMenuItem;
    mnuAmount: TMenuItem;
    mnuStatus: TMenuItem;
    mnuDate: TMenuItem;
    ag1: TMenuItem;
    EnterToTab1: TEnterToTab;
    Button1: TButton;
    fp1: TCsvFileParser;
    Button2: TButton;
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
    procedure PurchasePaymentwithInvoice1Click(Sender: TObject);
    procedure SalesReceiptwithInvoice1Click(Sender: TObject);
    procedure PurchasePayment1Click(Sender: TObject);
    procedure SalesReceipt1Click(Sender: TObject);
    procedure btnAdjustmentClick(Sender: TObject);
    procedure NominalJournal1Click(Sender: TObject);
    procedure mlTransMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure mlTransEndDrag(Sender, Target: TObject; X, Y: Integer);
    procedure btnCheckClick(Sender: TObject);
    procedure mnuDocTypeClick(Sender: TObject);
    procedure Properties1Click(Sender: TObject);
    procedure mlTransMultiSelect(Sender: TObject);
    procedure btnProcessClick(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure fp1ReadLine(LineNo: Integer; AList: TStrings);
    procedure Button2Click(Sender: TObject);
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
  public
    { Public declarations }
    oGL : IGeneralLedger;
    ListSettings : TRecListSettings;
    oToolkit : IToolkit3;
    Procedure WMSysCommand(Var Message  :  TMessage); Message WM_SysCommand;
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
    procedure ShowBalances;
    function Reconcile(const oStat : IBankStatement) : Boolean;
    procedure ImportHistory;
  end;

  {Object to add into thread controller - this runs through Details file building up the
   temporary btrieve file which the list uses}
  TBankScan = Object(TThreadQueue)
    public
      Currency : Byte;
      GLCode : longint;
      CallBackWindow : THandle;
      ListSettings : TRecListSettings;
      RecCount : longint;
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
      CompletedAmount : Double;
      Constructor Create(AOwner  :  TObject);

      Destructor  Destroy; Virtual;
      function UpdateReconcileLine(const s : string) : Integer;
      function UpdateGroupReconcileLine(const PayInRef : string; LineRec : TTempTransDetails) : Integer;
      Procedure Process; Virtual;
      Procedure Finish;  Virtual;

      Function Start  :  Boolean;

      procedure SetReconcileStatus(RStatus : Byte);

  end;



  procedure AddBankScan2Thread(AOwner : TObject; Curr : Byte; GLC : Integer; CallBack : THandle;
                               Settings : TRecListSettings; Reload : Boolean = False);
  procedure AddReconcile2Thread(AOwner : TObject; CallBack : THandle; AList : TList; GLC : Integer;
                                 ARef, RRef : string; ADate, RDate : string);

  procedure AddFinalise2Thread(AOwner : TObject; CallBack : THandle);

  procedure CreateTempFile;

var
  frmTransList: TfrmTransList;
  oRecToolkit : IToolkit3;
  CurrentStatement : IBankStatement;
  TotalRecCount : longint;

implementation

{$R *.dfm}

uses
  EtDateU, BtrvU2, GlobVar, BtKeys1U, ExThrd2U,  CurrncyU,
  RecFind, BankDetl, EtStrU, GrpView, Filter, AllcWizU, PWarnU, ApiUtil,
  ComnU2, SysU1;

const
  StartPeriod = 105000;

procedure TfrmTransList.ImportHistory;
var
  Res : Integer;
begin
  ResetRec(NHistF);
  fp1.FileName := 'c:\history.txt';
  fp1.Execute;
  ShowMessage('Import Finished');
end;

  function HexChar(c: Char): Byte;
  begin
    case c of
      '0'..'9':  Result := Byte(c) - Byte('0');
      'a'..'f':  Result := (Byte(c) - Byte('a')) + 10;
      'A'..'F':  Result := (Byte(c) - Byte('A')) + 10;
    else
      Result := 0;
    end;
  end;

  function HexByte(s : ShortString): Char;
  begin
    Result := Char((HexChar(s[1]) shl 4) + HexChar(s[2]));
  end;

function HexStrToString(const s : string) : string;
var
  i : integer;
begin
  Result := '';
  i := 1;
  while i < Length(s) do
  begin
    Result := Result + HexByte(Copy(s, i, 2));

    i := i + 2;
  end;
end;

procedure ExportHistory;
var
  Res : Integer;
  AList : TStringList;
  KeyS : Str255;

  CurrentCode : Str20;
  CurrentCurr : Byte;
  GotYTD : Boolean;

  function StringToHexString(const s : str20) : string;
  var
    i : longint;
  begin
    Result := '';
    for i := 1 to Length(s) do
    begin
      Result := Result + IntToHex(Ord(s[i]), 2);
    end;
  end;

  function WantThisHistoryRecord : Boolean;
  var
    YearPeriodCheck : longint;
  begin
    //P&L and Ctrl Recs - all including and after a certain period - probably the start of the current financial year
    //(Set the period/year as Year * 1000 + Period)
    //Balance Sheet Recs - As P&L/Ctrl + Last YTD for each GL/Currency
    //Header Recs - As P&L/Ctrl + All YTDs?
    YearPeriodCheck := (Integer(NHist.Yr) * 1000) + NHist.Pr;
    Result := (NHist.ExCLass in [PLNHCode, BankNHCode,CtrlNHCode, NomHedCode]) and
              ((YearPeriodCheck >= StartPeriod) or
               ((NHist.ExCLass in [BankNHCode, NomHedCode]) and (NHist.Pr in [254,255])));

    if Result then
    begin
    //Have we started a new Code or Currency?
      if (NHist.Code <> CurrentCode) or (NHist.Cr <> CurrentCurr) then
      begin
        //Reset
        CurrentCode := NHist.Code;
        CurrentCurr := NHist.Cr;
        GotYTD := False;
      end;

      Result := not GotYTD;

      if (NHist.Pr = 255) and (NHist.ExCLass = BankNHCode) then
        GotYTD := True; //After this one, we don't want any more until Code or Currency changes
    end;
  end;

begin
  AList := TStringList.Create;

  CurrentCurr := 255;
  CurrentCode := '';
  GotYTD := False;

  Res := Find_Rec(B_GetLast, F[NHistF], NHistF, NHist, 0, KeyS);

  while Res = 0 do
  begin
    if WantThisHistoryRecord then
    AList.Add(Format('%s,%d,%d,%d,%d,%8.2f,%8.2f,%8.2f,%8.2f,%8.2f,%8.2f,%8.2f,%8.2f',
                       [StringToHexString(NHist.Code),
                        Ord(NHist.ExClass),
                        NHist.Cr,
                        NHist.Yr,
                        NHist.Pr,
                        NHist.Sales,
                        NHist.Purchases,
                        NHist.Budget,
                        NHist.Cleared,
                        NHist.Budget2,
                        NHist.Value1,
                        NHist.Value2,
                        NHist.Value3]));

    Res := Find_Rec(B_GetPrev, F[NHistF], NHistF, NHist, 0, KeyS);

  end;

  AList.SaveToFile('c:\history.txt');
  AList.Free;
end;



function FormatOurRef(const s : string) : string;
begin
  Result := s;
  while Length(Result) < 9 do
    Insert('0', Result, 4);
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
  end;
  if not bRestore then SaveAllSettings;
  Action := caFree;
  if Assigned(frmBankDetails) and (frmBankDetails.ParentHandle = Self.Handle) then
    frmBankDetails.btnCloseClick(frmbankdetails);
  if Assigned(frmGroupView) then
    frmGroupView.btnCloseClick(frmGroupView);
  mlTrans.Active := False;

end;

procedure TfrmTransList.FormCreate(Sender: TObject);
begin
  oSettings.EXEName := ExtractFilename(GetModuleName(HInstance));
  oSettings.UserName := Trim(UserProfile.Login);
  bRestore := False;
  bOK := False;
  StatementButtonClicked := False;

  Height := 361;
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
  ShowBalances;
end;

procedure TfrmTransList.btnCancelClick(Sender: TObject);
begin
  Close;
end;

procedure TfrmTransList.btnOKClick(Sender: TObject);
begin
  if Assigned(FCurrentStatement) and (ReconcileObj.bnkHeader.brStatus <> bssComplete) then
  begin
    ReconcileObj.bnkHeader.brStatDate := FCurrentStatement.bsDate;
    ReconcileObj.bnkHeader.brStatFolio := FCurrentStatement.bsFolio;
    ReconcileObj.bnkHeader.brStatRef := FCurrentStatement.bsReference;
    if Trim(ReconcileObj.bnkHeader.brReconRef) = '' then
      ReconcileObj.bnkHeader.brReconRef := FCurrentStatement.bsReference;
    ReconcileObj.UpdateHeader;
  end;
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
  pnlButtons.Left := Panel1.Width - 4 - pnlButtons.Width;
  TabControl1.Width := pnlButtons.Left - 2;
  mlTrans.Width := TabControl1.Width - 12;

  Panel1.Height := ClientHeight - 2;
  pnlButtons.Height := Panel1.Height - pnlButtons.Top -  8;

  TabControl1.Height := Panel1.Height - 8;
  mlHeight := Panel3.Height - 104;

  mlTrans.Height := mlHeight;

  ScrollBox1.Height := pnlButtons.Height - ScrollBox1.Top - 2;
end;

procedure TfrmTransList.WMSysCommand(var Message: TMessage);
begin
  With Message do
    Case WParam of

      SC_MAXIMIZE  :  Begin
                        Self.Height:=InitSize.Y;
                        Self.Width:=InitSize.X;

                       { Self.ClientHeight:=InitSize.Y;
                        Self.ClientWidth:=InitSize.X;}

                        WParam:=0;
                      end;

    end; {Case..}

  Inherited;
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
  ceStatBalance.Value := ListSettings.StatBalance;

  btData.FileName := IncludeTrailingBackslash(SetDrive) + TmpFilename;
  Case ReconcileObj.bnkHeader.brInitSeq of
    0 : mlTrans.SortColIndex := isDate;
    1 : mlTrans.SortColIndex := isRef;
    2 : mlTrans.SortColIndex := isAmount;
  end;

  mlTrans.Options.MultiSelection := ListSettings.MultiSelect;
  btnTag.Enabled := not ListSettings.MultiSelect;
  mlTrans.Active := True;
  FormResize(Self);
  if ListSettings.AutoReconcile then
    Reconcile(FCurrentStatement);
//  ActiveControl := mlTrans;
end;

procedure TfrmTransList.FormDestroy(Sender: TObject);
var
  Res : Integer;
begin
  Res := Close_File(TmpFile);
  //Need to stop the list using the temp file before we can delete it
  //Delete all temp files
  DeleteFile(FullTmpFileName);
  DeleteFile(ChangeFileExt(FullTmpFileName, '.tmp'));
  DeleteFile(ChangeFileExt(FullTmpFileName, '.lck'));
  frmTransList := nil;
  CurrentStatement := nil;
end;

function CreateTempFileName : string;
var
  TempPath : AnsiString;
  FName : PChar;
  Res : longint;
begin
  FName := StrAlloc(MAX_PATH + 1);
  TempPath := IncludeTrailingBackslash(SetDrive) + 'SWAP\';
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
  FullTmpFileName := IncludeTrailingBackslash(SetDrive) + TmpFileName;
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
  Res := Find_Rec(B_GetFirst, Tmpfile, RecTempF, TempDetailRec, 0, KeyS);

  while Res = 0 do
  begin
    Res := Delete_Rec(TmpFile, RecTempF, 0);

    if Res <> 0 then
      raise Exception.Create('Unable to delete record. Btrieve error: ' + IntToStr(Res));

    Res := Find_Rec(B_GetFirst, Tmpfile, RecTempF, TempDetailRec, 0, KeyS);
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
               if (btdStatus <> 1) and ((ReconcileObj.FindLine(btdLineKey, 1) = 0) or
                   ((btdDocType <> 'RUN') and ReconcileObj.FindGroupMatch(btdPayInRef))) then
                 FieldValue := StatusString(ReconcileObj.bnkDetail.brLineStatus,
                                            ReconcileObj.bnkDetail.brStatLine)
               else
                 FieldValue := StatusString(btdStatus);
             end;
      'T'  : if TabControl1.TabIndex = 0 then
                FieldValue := POutDate(btdDate);
      'O'  : FieldValue := Trim(btdOurRef);
      'L'  : FieldValue := Trim(btdDesc);
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

{ TBankScan }

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
  PostMessage(CallBackWindow,WM_CustGetRec,55,0);
  Dispose(MTExLocal, Destroy);
end;

procedure TBankScan.Process;
var
  Res, Res1 : Integer;
  KeyS, RecKeyS : Str255;
  c : integer;
  LocalTempDetailRec : TTempTransDetails;
  GroupCount, UpCount : longint;
  dTmp : Double;
  function ConvertValue(IDFrom : IDetail) : Double;
  begin
    Result := Conv_TCurr(IDFrom.NetValue,
                        IDFrom.CXRate[(Syss.TotalConv=XDayCode)], IDFrom.Currency, 0, False);
  end;
begin
  c := 0;
  InMainThread:=BOn;
  GroupCount := 0;
  Inherited Process;

  ShowStatus(0,'Building bank transaction list');
  KeyS := FullNomKey(GLCode) + #0 + Char(Currency);

  With MTExLocal^ do
  Begin
    Res := LFind_Rec(B_GetGEq, IDetailF, 2, KeyS);
    InitProgress(100);
    UpdateProgress(0);
    while (Res = 0) and (LID.NomCode  = GLCode) do
    begin
      inc(c);
      if ((LID.Currency > 0) or (Currency = 0)) and
         (not ListSettings.UnclearedOnly or (LID.Reconcile <> 1))  then
      begin
        dTmp := c;
        ShowStatus(1,Format('Processed so far: %d of %d',[c, RecCount]));
        UpCount := Trunc((dTmp/RecCount) * 100);
        UpdateProgress(UpCount);
        FillChar(TempDetailRec, SizeOf(TempDetailRec), 0);
        with TempDetailRec do
        begin
          btdDocType := DocCodes[LID.IDDocHed];
          btdYear    := LID.PYr;
          btdPeriod  := LID.PPr;
          btdAcCode  := Trim(LID.CustCode);
          btdDesc    := LID.Desc;
          if Currency > 0 then
            btdAmount := LID.NetValue * DocCnst[LID.IdDocHed]
          else
            btdAmount  := ConvertValue(LID) * DocCnst[LID.IdDocHed];
          btdStatus  := LID.Reconcile;
{          RecKeyS := FullNomKey(LID.FolioRef) + FullNomKey(LID.LineNo);
          if ReconcileObj.FindLine(RecKeyS, 1) = 0 then
            btdStatus := 1;}
          btdDate    := LID.PDate;
          btdPayInRef := LJVar(Extract_PayRef2(LID.StockCode), 16);
          btdOurRef := LID.DocPRef;
          btdLineKey := FullRunNoKey(LID.FolioRef, {LID.AbsLineNo}c);
          LGetRecAddr(IDetailF);
          btdLineAddr := LastRecAddr[IDetailF];
          btdFolioRef := LID.FolioRef;
          btdLineNo := {LID.AbsLineNo}c;
          btdPostedRun := LID.PostedRun;
          btdIdDocHed := LID.IdDocHed;

          if (ReconcileObj.FindLine(btdLineKey, 1) = 0) and
             (ReconcileObj.bnkDetail.brLineStatus = 1) then
          begin
             btdStatus := 1;
             ReconcileObj.ReconciledAmount := ReconcileObj.ReconciledAmount + btdAmount;
          end;

          Res1 := Add_Rec(TmpFile, RecTempF, TempDetailRec, 9);

          KeyS := 'RU' + LJVar(btdPayInRef, 16);

        end;
      end;



      //Check if we already have a group record for this PayInRef - if so update it,
      //otherwise add it
      Res1 := Find_Rec(B_GetGEq, TmpFile, RecTempF, LocalTempDetailRec, 9, KeyS);
      if (Res1 = 0) and (LocalTempDetailRec.btdDocType = 'RUN') and
          (Trim(TempDetailRec.btdPayInRef) = Trim(LocalTempDetailRec.btdPayInRef)) and
          (Trim(TempDetailRec.btdPayInRef) <> '') then
      begin
        LocalTempDetailRec.btdAmount := LocalTempDetailRec.btdAmount +  TempDetailRec.btdAmount;
        Inc(LocalTempDetailRec.btdNoOfItems);
        //Only maintain status if all items have the same status
        if TempDetailRec.btdStatus <> LocalTempDetailRec.btdStatus then
          LocalTempDetailRec.btdStatus := 0;
        Put_Rec(TmpFile, RecTempF, LocalTempDetailRec, 9);
      end
      else
      begin
        Inc(GroupCount);
        TempDetailRec.btdDocType := 'RUN';
        TempDetailRec.btdAcCode := '';
        TempDetailRec.btdOurRef := 'RUN';
        TempDetailRec.btdNoOfItems := 1;
        TempDetailRec.btdFolioRef := MaxInt;
        TempDetailRec.btdLineNo := GroupCount;
        TempDetailRec.btdLineKey := FullNomKey(MaxInt) + FullNomKey(GroupCount);
        Add_Rec(TmpFile, RecTempF, TempDetailRec, 9);
      end;
      Res := LFind_Rec(B_GetNext, IDetailF, 2, KeyS);
    end;
  end;
  UpdateProgress(100);

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
              ClearTempFile
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


function TBankScan.Start: Boolean;
Var
  mbRet  :  Word;
  KeyS   :  Str255;
  Res : Integer;
Begin
  Result:=BOn;
  RecCount := 0;
  If (Not Assigned(MTExLocal)) then { Open up files here }
  Begin
    New(MTExLocal,Create(cidBankRec1));

    try
      With MTExLocal^ do
      Begin
        Open_System(IDetailF, IDetailF);
        KeyS := FullNomKey(GLCode) + #0 + Char(Currency);

        Res := LFind_Rec(B_GetGEq, IDetailF, 2, KeyS);

        while (Res = 0) and (LID.NomCode  = GLCode) do
        begin
          inc(RecCount);
          Res := LFind_Rec(B_GetNext, IDetailF, 2, KeyS);
        end;
      end;

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

procedure AddFinalise2Thread(AOwner : TObject; CallBack : THandle);
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
begin
  mlTrans.RefreshDB;
  ShowTaggedValue;
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
  KeyS : Str255;
  OK : Boolean;
  ColNo : Integer;

  function FullDoubleKey(const Value : Double) : Str255;
  var
    dTemp : Double;
  begin
    dTemp := Value;
    Move(dTemp, Result[1], SizeOf(dTemp));
    Result[0] := Char(SizeOf(dTemp));
  end;

begin

  with TfrmRecFind.Create(Application.MainForm) do
  Try
    cbFindByChange(Self);
    ShowModal;
    if ModalResult = mrOK then
    begin
      Case cbFindBy.ItemIndex of
        0  : begin
               KeyS := FormatOurRef(edtDocNo.Text);
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
               ColNo := 6; //Date
             end;
        4  : begin
               KeyS := edtDocNo.Text;
               ColNo := 8; //Line description
             end;
      end;
      mlTrans.SearchColumn(ColNo, True, KeyS);

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
  if DetailRec.btdStatus <> 1 then
  with DetailRec do
  begin
    btdStatus := btdStatus xor iTag; //Tag or untag
    if btdStatus and iTag = iTag then //We've just tagged it
    begin
      TagTotal[TabControl1.TabIndex] :=
          TagTotal[TabControl1.TabIndex] + btdAmount;
      Inc(TagCount[TabControl1.TabIndex]);
    end
    else
    begin
      TagTotal[TabControl1.TabIndex] :=
          TagTotal[TabControl1.TabIndex] - btdAmount;
      Dec(TagCount[TabControl1.TabIndex]);
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

  if Res = 0 then
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
  if DetailRec.btdStatus and iTag <> iTag then
  begin
    with DetailRec do
    begin
      if btdStatus and 3 <> 1 then
        ReconcileObj.ReconciledAmount := ReconcileObj.ReconciledAmount + btdAmount;
      btdStatus := btdStatus or 1;
      ReconcileObj.AddClearedRec(DetailRec);
    end;
    WriteRec(DetailRec);
    ShowBalances;
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
  if Sender = Unclear2 then
    Stat := 0
  else
  if Sender = Cancel1 then
    Stat := 2
  else
    Stat := 3;

  if DetailRec.btdStatus and iTag <> iTag then
  begin
    with DetailRec do
    begin
      if btdStatus and 3 = 1 then
        ReconcileObj.ReconciledAmount := ReconcileObj.ReconciledAmount - btdAmount;
      btdStatus := Stat;
      ReconcileObj.RemoveClearedRec(DetailRec);
    end;
    WriteRec(DetailRec);
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
  if Assigned(FCurrentStatement) then
    Res := msgBox('This will remove any changes you have made. Do you wish to continue?', mtWarning,
                    [mbYes, mbNo], mbYes, 'Load Bank Statement')
  else
    Res := mrYes;

  if Res = mrYes then
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
    StatementButtonClicked := True;
    btnStatementClick(Self);
  end;
end;

procedure TfrmTransList.btnViewClick(Sender: TObject);
begin
  ShowDetails;
end;

procedure TfrmTransList.btnStatementClick(Sender: TObject);
begin
  if Assigned(FCurrentStatement) then
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
     55 : mlTrans.RefreshDB;
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
          end;
     57 : begin
            SetStatementComplete;
            ReconcileObj.DeleteAllGroupLines;
            mlTrans.RefreshDB;
            ShowBalances;
          end;
    201 : if Assigned(frmBankDetails) then
          begin
             FCurrentStatement := frmBankDetails.ctkStatements.GetRecord as IBankStatement;
             if Assigned(FCurrentStatement) then
             begin
               ReconcileObj.bnkHeader.brStatRef := FCurrentStatement.bsReference;
               ReconcileObj.bnkHeader.brStatDate := FCurrentStatement.bsDate;
               ReconcileObj.bnkHeader.brStatFolio := FCurrentStatement.bsFolio;
               ReconcileObj.bnkHeader.brStatBal := FCurrentStatement.bsBalance;
               if Trim(ReconcileObj.bnkHeader.brReconRef) = '' then
                  ReconcileObj.bnkHeader.brReconRef := FCurrentStatement.bsReference;
               ReconcileObj.UpdateHeader;
             end;
             SetCaption;
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
    DisplayTrans(99, PTempTransDetails(btData.GetRecord)^)
  else
    ShowGroupList(PTempTransDetails(btData.GetRecord)^.btdPayInRef, GroupViewClosed);

end;

procedure TfrmTransList.GroupViewClosed(Sender: TObject);
begin
  frmGroupView := nil;
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
                        FilterOn := AmountTo <> 0;
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
    Result := (UpperCase(Details.btdPayInRef) >= RefFrom) and
                   (UpperCase(Trim(Details.btdPayInRef))<= RefTo);
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

procedure TfrmTransList.PurchasePaymentwithInvoice1Click(Sender: TObject);
begin
  AddTrans(1, PPI);
end;

procedure TfrmTransList.SalesReceiptwithInvoice1Click(Sender: TObject);
begin
  AddTrans(1, SRI);
end;

procedure TfrmTransList.PurchasePayment1Click(Sender: TObject);
begin
{  if PChkAllowed_In(413) then
    ShowReceiptWizard(True)
  else}
    AddTrans(1, PPY);
end;

procedure TfrmTransList.SalesReceipt1Click(Sender: TObject);
begin
{  if PChkAllowed_In(410) then
    ShowReceiptWizard(False)
  else}
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

procedure TfrmTransList.NominalJournal1Click(Sender: TObject);
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
end;

function TfrmTransList.AddLine: Integer;
begin
end;

function TfrmTransList.UpdateHead: Integer;
begin

end;

function TfrmTransList.UpdateLine: Integer;
begin

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
     (FStatementForm.mlStatements.Selected >= 0) then
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
  if not Assigned(FStatementForm) then
    FStatementForm := TfrmStatement.Create(Self);

  with FStatementForm do
  begin
    oStatement := FCurrentStatement;
    oToolkit := oRecToolkit;
    ParentHandle := Self.Handle;
    edtDate.Text := POutDate(oStatement.bsDate);
    edtRef.Text := oStatement.bsReference;
    ctkData.ToolkitObject := oStatement.bsStatementLine as IBtrieveFunctions2;
    mlStatements.Active := True;
    mlStatements.RefreshDB;
  end;

  FStatementForm.BringToFront;
end;


procedure TfrmTransList.mlTransEndDrag(Sender, Target: TObject; X,
  Y: Integer);
begin
  if Assigned(Target) and ((Target as TDBMPanel).Parent.Parent = FStatementForm.mlStatements) then
  begin
    FStatementForm.Match(FStatementForm.ctkData.GetRecord as IBankStatementLine);
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
  TagCount[0] := 0;
  TagCount[1] := 0;

  TagTotal[0] := 0;
  TagTotal[1] := 0;

  ShowTaggedValue;
  if Assigned(FStatementForm) then
    FStatementForm.mlStatements.RefreshDB;
end;

procedure TfrmTransList.btnCheckClick(Sender: TObject);
begin
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
    ceStatBalance.Value := ReconcileObj.bnkHeader.brStatBal;
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
  Screen.Cursor := crHourglass;
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
  with ReconcileObj.bnkHeader do
    AddReconcile2Thread(Self, Self.Handle, FList, brGLCode, brStatRef, brReconRef,
                                  brStatDate, brReconDate);
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
  PostMessage(CallBackWindow,WM_CustGetRec,56,0);
end;

procedure TReconcile.Process;
var
  Res, Res1 : Integer;
  KeyS : Str255;
  Found : Boolean;
  i : integer;
  StatLine : PStatementLineRec;
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
    Found := False;
    KeyS := StatLine.slDate;
    Res1 := Find_Rec(B_GetGEq, Tmpfile, RecTempF, TempDetailRec, idxDate, KeyS);

    While (Res1 = 0) and not Found and (KeyS = StatLine.slDate) do
    begin
      Found := (Trim(TempDetailRec.btdPayInRef) = Trim(StatLine.slPayRef)) and
               (Abs(TempDetailRec.btdAmount - StatLine.slValue) < 0.001) and
               (ReconcileObj.FindLine(TempDetailRec.btdLineKey, 1) <> 0);

      if Found then
      begin  //Add reconciliation line rec
        TempDetailRec.btdStatus := iMatch;
        TempDetailRec.btdStatLine := StatLine.slLineNo;
        ReconcileObj.AddMatch(StatLine^, TempDetailRec);
      end
      else
        Res1 := Find_Rec(B_GetNext, Tmpfile, RecTempF, TempDetailRec, idxDate, KeyS);

    end;
    SleepEx(500, True);
  end;//for i

  //Group match
  ShowStatus(0,'Checking grouped transaction lines');

  for i := 0 to StatList.Count - 1 do
  begin
    ShowStatus(1,Format('Line %d of %d', [Succ(i), StatList.Count]));
    StatLine := PStatementLineRec(StatList[i]);
    if (ReconcileObj.FindLine(FullNomKey(MaxInt) + FullNomKey(StatLine.slLineNo), 2) <> 0) then
    //This line hasn't been matched yet
    begin
      Found := False;
      KeyS := 'RUN';

      Res1 := Find_Rec(B_GetGEq, Tmpfile, RecTempF, TempDetailRec, idxDocType, KeyS);

      While (Res1 = 0) and not Found and (KeyS = 'RUN') do
      begin
        Found := (Trim(TempDetailRec.btdPayInRef) = Trim(StatLine.slPayRef)) and
                 (Abs(TempDetailRec.btdAmount - StatLine.slValue) < 0.001) and
                 not ReconcileObj.FindGroupMatch(TempDetailRec.btdPayInRef);

        if Found then
        begin
          TempDetailRec.btdStatus := iMatch;
          ReconcileObj.AddMatch(StatLine^, TempDetailRec);
        end
        else
          Res1 := Find_Rec(B_GetNext, Tmpfile, RecTempF, TempDetailRec, idxDocType, KeyS);
      end;
        SleepEx(500, True);
    end;
  end; //for i
end;

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
  Screen.Cursor := crHourGlass;
  UpdateStatuses;
  AddFinalise2Thread(Self, Self.Handle);
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
      MTExLocal^.UnLockMLock(IDetailF,MTExLocal^.LastRecAddr[IDetailF]);
    end;
  end;
end;

procedure TFinaliseReconciliation.Finish;
begin
  inherited;
  ReconcileObj.bnkHeader.brStatus := bssComplete;
  ReconcileObj.UpdateHeader;
  PostMessage(CallBackWindow,WM_CustGetRec,57,0);
  if Assigned(MTExLocal) then
    Dispose(MTExLocal, Destroy);
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
begin
  InMainThread:=BOn;
  Inherited Process;
  c := 0;
  ShowStatus(0,'Finalising bank reconciliation');

  Status:=GetPos(F[IDetailF],IDetailF,RecAddr);  {* Preserve Posn of Invoice Line *}

  With MTExLocal^ do
  Begin

    Res := Find_Rec(B_GetFirst, TmpFile, RecTempF, LocalTempDetailRec, 0, RecKeyS);
    InitProgress(100);
    UpdateProgress(0);
    while Res = 0 do
    begin
      if LocalTempDetailRec.btdDocType <> 'RUN' then
      begin
{        LastRecAddr[IDetailF] := LocalTempDetailRec.btdLineAddr;

        Res1 := LGetDirectRec(IDetailF, IdFolioK);}

        SetDataRecOfs(IDetailF,LocalTempDetailRec.btdLineAddr);

        Res1:=GetDirect(F[IDetailF],IDetailF,RecPtr[IDetailF]^,IdFolioK,0);

        if (Res1 = 0) and ((ID.Reconcile <> (LocalTempDetailRec.btdStatus and 3)) or
           (LocalTempDetailRec.btdStatus = iComplete)) then
        begin
          //Lock Id and update
          if GetMultiRec(B_GetDirect,B_MultLock,KeyS,IdFolioK,IDetailF,BOff,bLocked) and bLocked then
          begin
            if LocalTempDetailRec.btdStatus = iComplete then
              NewReconcile := ReconC
            else
              NewReconcile := LocalTempDetailRec.btdStatus and 3;
            SetReconcileStatus(NewReconcile);

            //Set status to complete in TempFile
            UpdateReconcileLine(LocalTempDetailRec.btdLineKey);
            UpdateGroupReconcileLine(LocalTempDetailRec.btdPayInRef, LocalTempDetailRec);
          end;
        end;
        inc(c);
        dTmp := c;
        UpCount := Trunc((dTmp/RecCount) * 100);
        UpdateProgress(UpCount);
        ShowStatus(1,Format('Processed so far: %d of %d',[c, RecCount]));
      end;
      Res := Find_Rec(B_GetNext, TmpFile, RecTempF, LocalTempDetailRec, 0, RecKeyS);
    end;
  end;
  UpdateProgress(100);
  //Restore position in detail file
  SetDataRecOfs(IDetailF,RecAddr);

  Status:=GetDirect(F[IDetailF],IDetailF,RecPtr[IDetailF]^,IdFolioK,0);

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
    New(MTExLocal,Create(cidBankRec1));

    try
      With MTExLocal^ do
      Begin
        Open_System(IDetailF, IDetailF);
        Open_System(MLocF, MLocF);
        Open_System(NomF, NomF);
        Open_System(NHistF, NHistF);
      end;

    except
      Dispose(MTExLocal,Destroy);
      MTExLocal:=nil;

    end; {Except}

    Result:=Assigned(MTExLocal);
  end;
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

    With Id do
    Begin
//      RStatus:=LNHCtrl.NBMode-ReconN;

      Cnst:=0;  LVal:=0;  PBal:=0;  TNCode:=0;

      Locked:=BOff;

   {   If (Not Assigned(MTPost)) then
        InitMTExLocal;}

      If (RStatus<>Reconcile) then
      Begin
        Ok:=GetMultiRecAddr(B_GetDirect,B_MultLock,KeyF,KeyPath,ScanFileNum,BOff,Locked,LAddr);

        If (Ok) and (Locked) then
        Begin
          If (Reconcile=ReconC) then
            Cnst:=-1
          else
            If (Reconcile In NotClearedSet) and (RStatus = ReconC) then
              Cnst:=1;

          If (Cnst<>0) then
          Begin
            LVal:=DetLTotal(Id,Not Syss.SepDiscounts,BOff,0.0)*Cnst;

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

          If (Reconcile=ReconC) then
            ReconDate:=Today
          else
            ReconDate:=MaxUntilDate;

          Status:=Put_Rec(F[ScanFileNum],ScanFileNum,RecPtr[ScanFileNum]^,Keypath);

          Report_BError(ScanFileNum,Status);
        end;

        Status:=UnLockMultiSing(F[ScanFileNum],ScanFileNum,LAddr);
      end; {If locked..}
    end; {With..}
  end;
  {$ENDIF}
end; {Proc..}


procedure TfrmTransList.UpdateStatuses;
var
  Res : Integer;
  DetailRec : TTempTransDetails;
  KeyS : Str255;
begin
  Res := Find_Rec(B_GetFirst, TmpFile, RecTempF, DetailRec, 0, KeyS);

  while Res = 0 do
  begin
    if (ReconcileObj.FindLine(DetailRec.btdLineKey, 1) = 0) or
       ReconcileObj.FindGroupMatch(DetailRec.btdPayInRef) then
    begin
      DetailRec.btdStatus := iComplete;
      ReconcileObj.ReconciledAmount := ReconcileObj.ReconciledAmount + DetailRec.btdAmount;
      Put_Rec(TmpFile, RecTempF, DetailRec, 0);
    end;

    Res := Find_Rec(B_GetNext, TmpFile, RecTempF, DetailRec, 0, KeyS);
  end;
  ShowBalances;
end;

procedure TfrmTransList.ShowBalances;
var
  OpenB : Double;
  Purch, Sales, Cleared : Double;
begin
  OpenB := Profit_To_Date('B',CalcCCKeyHistP(ReconcileObj.bnkHeader.brGLCode,False,''),
                           ReconcileObj.bnkHeader.brCurrency,CurrentPeriod.CYr,CurrentPeriod.CPr,Purch,Sales,Cleared,BOn);
  ReconcileObj.bnkHeader.brOpenBal := 0; //check with KH for this
  ceCurrent.Value := Currency_Txlate(OpenB, ReconcileObj.bnkHeader.brCurrency, 0);;
//  ceReconciled.Value := Currency_Txlate(Cleared, ReconcileObj.bnkHeader.brCurrency, 0);
  ceDifference.Value := ceStatBalance.Value - ceReconciled.Value;
  ceReconciled.Value := ReconcileObj.ReconciledAmount;
end;

procedure TfrmTransList.SetStatementComplete;
var
  KeyS : String;
  Res : Integer;
  oStat : IBankStatement;
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
        oStat := BankAccount.baStatement.Update;

        if Assigned(oStat) then
        begin
          oStat.bsStatus := bssComplete;
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

  AList.SaveToFile('c:\reconcile.txt');
  AList.Free;
end;

function TFinaliseReconciliation.UpdateGroupReconcileLine(
  const PayInRef: string; LineRec : TTempTransDetails): Integer;
var
  KeyS, KeyChk : Str255;
  Res : Integer;
  bLocked, Found : Boolean;
  DetailRec : BnkRDRecType;
begin
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
       (Trim(MTExLocal^.LMLocCtrl^.BnkRDRec.brPayRef) = Trim(PayInRef));

    if not Found then
      Res := MTExLocal^.LFind_Rec(B_GetNext, MLocF, 1, KeyS);

  end;

  if Found then
  begin
    if MTExLocal^.LGetMultiRec(B_GetDirect,B_MultLock,KeyS,2,MLocF,BOff,bLocked) and bLocked then
    begin
      MTExLocal^.LMLocCtrl^.BnkRDRec.brLineStatus := iComplete;
      MTExLocal^.LPut_Rec(MLocF, 1);
      MTExLocal^.UnLockMLock(IDetailF,MTExLocal^.LastRecAddr[IDetailF]);


      MTExLocal^.LMLocCtrl.BnkRDRec.brMatchRef := LineRec.btdOurRef;
      MTExLocal^.LMLocCtrl.BnkRDRec.brValue := LineRec.btdAmount;
      MTExLocal^.LMLocCtrl.BnkRDRec.brLineNo := LineRec.btdLineNo;
      MTExLocal^.LMLocCtrl.BnkRDRec.brCustCode := LineRec.btdAcCode;
      MTExLocal^.LMLocCtrl.BnkRDRec.brLineNo := LineRec.btdLineNo;
      MTExLocal^.LMLocCtrl.BnkRDRec.brBnkDCode1 := BuildLineIndex(bnkHeader.brUserId, bnkHeader.brGLCode,
                                            bnkHeader.brIntRef, LineRec.btdLineNo);
      MTExLocal^.LMLocCtrl.BnkRDRec.brBnkDCode2 := BuildTransLineIndex(bnkHeader.brUserId, bnkHeader.brGLCode, bnkHeader.brIntRef,
                                                LineRec.btdFolioRef, LineRec.btdLineNo);
      MTExLocal^.LAdd_Rec(MLocF, 1);
    end;
    Result := 0;
  end;
end;

procedure TfrmTransList.Button1Click(Sender: TObject);
begin
  ExportHistory;
end;

procedure TfrmTransList.fp1ReadLine(LineNo: Integer; AList: TStrings);
var
  i, Res : integer;
begin
  Label2.Caption := IntToStr(LineNo);
  Label2.Refresh;
  Application.ProcessMessages;
  for i := 0 to AList.Count - 1 do
  begin
    Case i of
      0  :  NHist.Code := HexStrToString(AList[i]);
      1  :  NHist.ExCLass := Char(StrToInt(AList[i]));
      2  :  NHist.Cr := StrToInt(Trim(AList[i]));
      3  :  NHist.Yr := StrToInt(Trim(AList[i]));
      4  :  NHist.Pr := StrToInt(Trim(AList[i]));
      5  :  NHist.Sales := StrToFloat(Trim(AList[i]));
      6  :  NHist.Purchases := StrToFloat(Trim(AList[i]));
      7  :  NHist.Budget := StrToFloat(Trim(AList[i]));
      8  :  NHist.Cleared := StrToFloat(Trim(AList[i]));
      9  :  NHist.Budget2 := StrToFloat(Trim(AList[i]));
     10  :  NHist.Value1 := StrToFloat(Trim(AList[i]));
     11  :  NHist.Value2 := StrToFloat(Trim(AList[i]));
     12  :  begin
              NHist.Value3 := StrToFloat(Trim(AList[i]));
              Res := Add_Rec(F[NHistF], NHistF, NHist, 0);
              ResetRec(NHistF);
            end;
    end;
  end;
end;

procedure TfrmTransList.Button2Click(Sender: TObject);
begin
  ImportHistory;
end;

Initialization
  frmTransList := nil;
  CurrentStatement := nil;
  DefineBankRecTemp;

end.
