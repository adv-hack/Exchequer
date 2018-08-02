unit StockLevelsU;

{
  CJS 30/06/2010

  Heavily-amended copy of StkWarnU. Called from AdjLineU via
  InvCtSuU.Check_StockCtrl
}

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ExtCtrls, TEditVal, SBSPanel, ComCtrls, Buttons, GlobVar, VarConst,
  VarRec2U, ExWrap1U, bkgroup, BTSupU1, Saltxl2u, Grids, SBSOutl;

type
  TSelectAlternateStockProc = procedure (AltStockCode: Str20) of object;
  TStockLevelsFrm = class(TForm)
    PageControl1: TPageControl;
    StkLevelsPage: TTabSheet;
    AgeingPage: TTabSheet;
    Id4QOF: TCurrencyEdit;
    Id4QAF: TCurrencyEdit;
    Id4QAWF: TCurrencyEdit;
    Id4QOSF: TCurrencyEdit;
    Id4QNF: TCurrencyEdit;
    OkCP1Btn: TButton;
    Panel1: TPanel;
    A1F: TCurrencyEdit;
    A2F: TCurrencyEdit;
    A3F: TCurrencyEdit;
    A4F: TCurrencyEdit;
    A5F: TCurrencyEdit;
    O1F: TCurrencyEdit;
    O2F: TCurrencyEdit;
    O3F: TCurrencyEdit;
    O4F: TCurrencyEdit;
    O5F: TCurrencyEdit;
    A1Lab: TLabel;
    A2Lab: TLabel;
    A4Lab: TLabel;
    A5Lab: TLabel;
    A6Lab: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    AgeLab: TLabel;
    Bevel1: TBevel;
    Pan1: TSBSBackGroup;
    Label831: Label8;
    Label833: Label8;
    Label834: Label8;
    Pan2: TSBSBackGroup;
    Label835: Label8;
    Label81: Label8;
    Id4QPF: TCurrencyEdit;
    PickLab: Label8;
    Label82: Label8;
    Id4QIWF: TCurrencyEdit;
    Label83: Label8;
    Id4QFF: TCurrencyEdit;
    Label84: Label8;
    Id4QPWF: TCurrencyEdit;
    Label1: TLabel;
    W1F: TCurrencyEdit;
    W2F: TCurrencyEdit;
    W3F: TCurrencyEdit;
    W4F: TCurrencyEdit;
    W5F: TCurrencyEdit;
    BinPage: TTabSheet;
    BinTree: TSBSOutlineB;
    EquivPage: TTabSheet;
    EquivalentsTree: TSBSOutlineB;
    StockListPnl: TPanel;
    LowStockList: TListBox;
    RequiredLbl: Label8;
    edtRequired: TCurrencyEdit;
    Label2: TLabel;
    procedure FormCreate(Sender: TObject);
    procedure FormKeyPress(Sender: TObject; var Key: Char);
    procedure PageControl1Change(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormDestroy(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure Id4QOFDblClick(Sender: TObject);
    procedure BinTreeExpand(Sender: TObject; Index: Integer);
    procedure FormResize(Sender: TObject);
    procedure EquivalentsTreeClick(Sender: TObject);
    procedure LowStockListClick(Sender: TObject);
    procedure EquivalentsTreeDblClick(Sender: TObject);
  private
    { Private declarations }
    fNeedToRestore: Boolean;
    GotCoord : Boolean;
    NewPage  : Boolean;
    StockDisplay  : TFStkDisplay;
    AllocNum : Array[0..2] of AgedTyp;
    ExLocal  : ^TdMTExLocal;
    MLocListPtr : Pointer;
    FullStockList: TStringList;
    {$IFDEF SOP}
    AltIdxPos : Array[0..4] of LongInt;
    InEquivReset: Boolean;
    SupressOpo : Boolean;
    {$ENDIF}
    FOnSelectAlternateStock: TSelectAlternateStockProc;

    OriginalIdRec: Idetail;
    StockRecAddr: LongInt;
    InvRecAddr: LongInt;
    IdRecAddr: LongInt;
    IdKey: Str255;
    HasMoreLines: Boolean;
    WindowHandle: HWND;
    procedure AddStock(StockCode: string; QtyAvailable, QtyRequired: Double; Location: string);
    procedure AddLowStock(StockCode: string; Location: string);
    procedure RemoveLowStock(StockCode: string; Location: string);
    function SavePositions: LongInt;
    procedure FindFirstLine(Folio: Integer);
    procedure FindNextLine;
    function CheckComponents(IdR: Idetail; QtyRequired: Double; Mode: Integer): Boolean;
    function CheckStock(IdR: Idetail; QtyRequired: Double; Mode: Integer): Boolean;
    function RestorePositions: LongInt;
    procedure Clear;
    function QuantityRequested(ForStockCode: Str20; ForLocation: string): Double;
    procedure UpdateQuantityRequested(ForStockCode: Str20; ForLocation: string; QtyRequired: Double);
    function FindStockEntry(ForStockCode: Str20; ForLocation: string): Integer;
    function FindLowStockEntry(ForStockCode: Str20; ForLocation: string): Integer;

    procedure ChangePage(NewPage: Integer);
    function Current_Page: Integer;
    procedure SetAgingPeriodLabel(Mode: Byte);
    procedure SetAllocationAgingValues(Mode: Byte);
    function AgingRange(PCode: Str20; ToDate: LongDate): Byte;
    function Compare_Dates(ToDate, DlDate: Str8; DrvMode: Byte): LongInt;
    procedure Get_StockAged(var  StockPos  :  AgedTyp;
                                 Idr       :  IDetail;
                                 ChkDate   :  LongDate;
                                 DrvMode   :  Byte);
    procedure View_Allocation(PCode     :  Str20;
                              AllocQty,
                              OnOrdQty  :  Real);
    procedure WMCustGetRec(var Message: TMessage); Message WM_CustGetRec;

    procedure Link2Stk(StkViewFilter: Byte);
    procedure DestroyNodes;
    procedure BuildOBins(Idx: Integer);
    procedure BuildObjectDrill;
    {$IFDEF SOP}
    procedure DestroyNodes2;
    procedure BuildOEquivStk(Idx: Integer);
    procedure BuildObjectEquiv;
    {$ENDIF}
    procedure ShowStock;
    function FindStock(StockCode: Str20): LongInt;

    function IsBuildingBOM(IdR: Idetail): Boolean;
    procedure AddStockItem(IdR: Idetail);
    procedure AddSubcomponents(IdR: Idetail);
    function FindNextBOMItem(var KeyS: Str255; KeyChk: Str255): LongInt;
    function FindBOMStock: LongInt;
    function StoreBOMRecordPosition(var RecAddr: LongInt): LongInt;
    function RestoreBOMRecordPosition(RecAddr: LongInt): LongInt;
    function CalculateAvailable(Location: string): Double;

  public
    fCustCode,
    fLocFilt:  Str10;
    fPCode  :  Str20;
    fQAL,
    fQOO    :  Double;
    fpOSCode  :  Str20;
    fpOSQty   :  Double;
    fpSetQty  :  Boolean;
    fpSetCurr :  Byte;
    property OnSelectAlternateStock: TSelectAlternateStockProc
      read FOnSelectAlternateStock write FOnSelectAlternateStock;
    procedure ShowAged;
    {$IFDEF SOP}
    function ReturnObjectEquiv: Boolean;
    function ReturnObjectMLoc: MLocRec;
    {$ENDIF}
    function Check(IdR: Idetail; StockMovement: Double; Mode: Integer;
                   WindowHandle: HWND; Edit: Boolean): Boolean;
  end;

implementation

uses
  ETStrU,
  ETMiscU,
  ETDateU,
  BtrvU2,
  ExtGetU,
  BTSupU2,
  CmpCtrlU,
  BTKeys1U,
  SOPCt2U,
  {$IFDEF SOP}
  MLoc0U,
  InvLst3U,
  AltCRe2U,
  //PR: 20/04/2009
  MultiBuyFuncs,
  MultiBuyVar,
  {$ENDIF}
  Saltxl1U,
  InvListU,
  SQLUtils,
  SysU2;

{$R *.DFM}

type
  ODDType = record
    NKeypath : Integer;
    NLKeypath: Integer;
    NLFnum   : Integer;
    NFnum    : Integer;
    NLKey    : Str255;
    NKey     : Str255;
    NCustSupp: Char;
    NOQty    : Boolean;
    NNeedData: Boolean;
    NOCurr   : Byte;
    NMiscMode: Byte;
    NOurRef  : Str10;
    NValue   : Double;
  end;

  {
    The TStockLevel class is used when checking for insufficient stock levels,
    and holds details of the stock items which are currently being checked.

    The QtyAvailable field holds the number of items in Stock, and the
    QtyRequired field holds the total number of items required, including any
    BoM components found on other lines of the Transaction (non-component items
    do not need to be checked, as they will have already been taken out of Stock
    -- component items are not taken from Stock until the entire Transaction is
    stored.
  }
  TStockLevel = class
  private
    StockCode: Str20;
    Location: string;
    QtyRequired: Double;
    QtyAvailable: Double;
  public
    constructor Create(StockCode: Str20; QtyAvailable, QtyRequired: Double; Location: string);
  end;

// =============================================================================
// TStockLevelsFrm
// =============================================================================
procedure TStockLevelsFrm.FormResize(Sender: TObject);
begin
{
  CJS 14/02/2011 - Moved the positioning code to FormCreate.
}
{
  if (GotCoord) and ((BinPage.TabVisible) or (EquivPage.TabVisible)) then
  begin
    BinTree.Width          := BinPage.ClientWidth - 2;
    BinTree.Height         := BinPage.ClientHeight - 31;
    EquivalentsTree.Width  := BinTree.Width;
    EquivalentsTree.Height := BinTree.Height
  end;
}  
end;

// -----------------------------------------------------------------------------

procedure TStockLevelsFrm.FormCreate(Sender: TObject);
var
  n: Integer;
  HideWOR: Boolean;
begin
  GotCoord := False;

  FullStockList := TStringList.Create;

  PageControl1.ActivePage := StkLevelsPage;

  for n := 0 to Pred(ComponentCount) do
    if (Components[n] is TCurrencyEdit) then
      TCurrencyEdit(Components[n]).DecPlaces := Syss.NoQtyDec;

  // ???
  NewPage := True;

  {$IFNDEF SOP}
  AgeingPage.TabVisible := False;
  {$ENDIF}

  {$IFDEF LTE}
  BinPage.TabVisible   := False;
  EquivPage.TabVisible := False;
  {$ENDIF}

  fNeedToRestore := False;
  HideWOR := not VarConst.WOPOn;
  StockDisplay := nil;

  {$IFDEF SOP}
  InEquivReset := False;
  {$ENDIF}

  New(ExLocal, Create(700));
  ExLocal^.Open_System (InvF, IdetailF);
  ExLocal^.Open_System (StockF, StockF);
  ExLocal^.Open_System (MLocF, MLocF);
  ExLocal^.Open_System (PWrdF, PWrdF);

//  ClientHeight := 207;
//  ClientWidth  := 400;

  if (HideWOR) then
  begin
    ClientHeight     := 210;
    Label834.Visible := BOff;
    Label82.Visible  := BOff;
    Id4QAWF.Visible  := BOff;
    Id4QIWF.Visible  := BOff;
    Label83.Top      := Label834.Top;
    Id4QFF.Top       := Id4QAWF.Top;
    Label84.Visible  := BOff;
    Id4QPWF.Visible  := BOff;

    {
      CJS 14/02/2011 - Corrected the positioning.
    }
    Pan1.Height      := Id4QPF.Top + Id4QPF.Height + 4; // 102;
    Pan2.Height      := Pan1.Height; // 102;
    OkCp1Btn.Top     := ClientHeight - (OkCp1Btn.Height + 6);
    Label2.Top       := Pan2.Top + Pan2.Height + 4;

    Panel1.Height    := 75;
    Label1.Visible   := BOff;
    W1F.Visible      := BOff;
    W2F.Visible      := BOff;
    W3F.Visible      := BOff;
    W4F.Visible      := BOff;
    W5F.Visible      := BOff;
  end;

  {
    CJS 14/02/2011 - Corrected the positioning.
  }
  BinTree.Width          := BinPage.ClientWidth - 2;
  BinTree.Height         := BinPage.ClientHeight - (OkCp1Btn.Height + 4);
  EquivalentsTree.Width  := BinTree.Width;
  EquivalentsTree.Height := BinTree.Height;

  {$IF Defined(SOP) and Not Defined(LTE)}
  EquivPage.TabVisible := True; {v5.61.001 was being hidden if WOP not enabled for some reason...}
  SupressOpo           := False;
  {$IFEND}

  GotCoord := True;

end;

// -----------------------------------------------------------------------------

procedure TStockLevelsFrm.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Action := caFree;
  DestroyNodes;
  {$IFDEF SOP}
  DestroyNodes2;
  {$ENDIF}
end;

// -----------------------------------------------------------------------------

procedure TStockLevelsFrm.FormDestroy(Sender: TObject);
begin
  ExLocal^.Close_Files;
  Dispose(ExLocal, Destroy);
end;

// -----------------------------------------------------------------------------

procedure TStockLevelsFrm.FormKeyPress(Sender: TObject; var Key: Char);
begin
  if (Key = Esc) then
    ModalResult := mrCancel;
  GlobFormKeyPress(Sender, Key, ActiveControl, Handle);
end;

// -----------------------------------------------------------------------------

procedure TStockLevelsFrm.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
var
  LastAHK: Boolean;
begin
  LastAHK := AllowHotKey;
  AllowHotKey := ((Key in [VK_Prior, VK_Next, VK_Home, VK_End]) and
                  (ssCtrl in Shift));
  GlobFormKeyDown(Sender, Key, Shift, ActiveControl, Handle);
  AllowHotKey := LastAHK;
end;

// -----------------------------------------------------------------------------

function TStockLevelsFrm.Current_Page: Integer;
begin
  Result := pcLivePage(PageControl1);
end;

// -----------------------------------------------------------------------------

procedure TStockLevelsFrm.WMCustGetRec(var Message: TMessage);
begin
  with Message do
  begin
    case WParam of
       18: StockDisplay:=nil;
      175: with PageControl1 do
             ChangePage(FindNextPage(ActivePage,(LParam=0),BOn).PageIndex);
     {$IFDEF SOP}
     1129: SupressOpo := BOn;
     {$ENDIF}
    end;
  end;
  inherited;
end;

// -----------------------------------------------------------------------------

procedure TStockLevelsFrm.ChangePage(NewPage: Integer);
begin
  if (Current_Page <> NewPage) then
  with PageControl1 do
  begin
    LockWindowUpdate(self.Handle);
    ActivePage := Pages[NewPage];
    PageControl1Change(PageControl1);
    LockWindowUpdate(0);
  end;
end;

// -----------------------------------------------------------------------------

procedure TStockLevelsFrm.SetAgingPeriodLabel(Mode: Byte);
var
  AgeStr: string;
begin
  case Mode of
    1: AgeStr := 'Days  ';
    2: AgeStr := 'Weeks ';
  else
    AgeStr := 'Months';
  end;
  AgeLab.Caption := AgeStr;
end;

// -----------------------------------------------------------------------------

procedure TStockLevelsFrm.SetAllocationAgingValues(Mode: Byte);
begin
  A1F.Value := AllocNum[0, 1];
  A2F.Value := AllocNum[0, 2];
  A3F.Value := AllocNum[0, 3];
  A4F.Value := AllocNum[0, 4];
  A5F.Value := AllocNum[0, 5];

  O1F.Value := AllocNum[1, 1];
  O2F.Value := AllocNum[1, 2];
  O3F.Value := AllocNum[1, 3];
  O4F.Value := AllocNum[1, 4];
  O5F.Value := AllocNum[1, 5];

  W1F.Value := AllocNum[2, 1];
  W2F.Value := AllocNum[2, 2];
  W3F.Value := AllocNum[2, 3];
  W4F.Value := AllocNum[2, 4];
  W5F.Value := AllocNum[2, 5];
end;

// -----------------------------------------------------------------------------

function TStockLevelsFrm.AgingRange(PCode: Str20; ToDate: LongDate): Byte;
const
  LTAry: array[0..2] of DocTypes = (SOR, POR, WOR);
var
  KeyS    : Str255;
  KeyChk  : Str255;
  FoundOk : Boolean;
  Loop    : Byte;
  NextAL  : LongInt;
begin
  Result  := 1;
  Loop    := 0;
  {* Check First Matching SOR, if none, then POR *}
  repeat
    KeyChk  := FullIdType(StkLineType[LTAry[Loop]], PCode);
    FoundOk := CheckRecExsists(KeyChk, IDetailF, IdAnalK);
    Inc(Loop);
  until (Loop > 1 + Ord(VarConst.WOPOn)) or (FoundOk);

  if (FoundOk) then
  begin
    NextAL := NoDays(ToDate, Id.Pdate);
    if (NextAL > 29) then
      Result := 3
    else if (NextAL > 5) then
      Result := 2;
  end;
end; {Func..}

// -----------------------------------------------------------------------------

function TStockLevelsFrm.Compare_Dates(ToDate,DlDate  :  Str8;
                                DrvMode        :  Byte)  :  LongInt;
Begin
  case DrvMode of
    1: Result := NoDays(Todate, DlDate);
    2: Result := Round(DivwChk(NoDays(ToDate, DlDate), 7));
  else
    Result := MonthDiff(ToDate,DlDate);
  end;
  if (Result < 0) then
    Result := 0;
end;

// -----------------------------------------------------------------------------

procedure TStockLevelsFrm.Get_StockAged(var  StockPos  :  AgedTyp;
                                      Idr       :  IDetail;
                                      ChkDate   :  LongDate;
                                      DrvMode   :  Byte);
var
  Anal    :  Integer;
  TotQty  :  Real;
begin
  with Idr do
  begin
    Anal := Compare_Dates(ChkDate, PDate, DrvMode);

    If (IdDocHed <> WOR) then
      TotQty := CaseQty(Stock, DeductQty)
    else
      TotQty := Qty_OS(IdR);

    Case Anal of
      0..1: StockPos[1]    := StockPos[1] + TotQty;
      2..4: StockPos[Anal] := StockPos[Anal] + TotQty;
    else
      StockPos[5] := StockPos[5] + TotQty;
    end;

  end;
end;

// -----------------------------------------------------------------------------

procedure TStockLevelsFrm.View_Allocation(PCode: Str20; AllocQty, OnOrdQty: Real);
const
  Fnum    = IDetailF;
  Keypath = IdAnalK;
  LTAry: array[0..2] of DocTypes = (SOR,POR,WOR);
var
  TmpKPath,
  TmpStat  :  Integer;
  TmpRecAddr:  LongInt;
  KeyS,
  KeyChk   :  Str255;
  Loop     :  Byte;
  Mode     :  Byte;
begin
  Blank(AllocNum,Sizeof(AllocNum));

  Loop := 0;

  TmpKPath := GetPosKey;

  TmpStat := ExLocal^.LPresrv_BTPos(Fnum, TmpKPath, F[Fnum], TmpRecAddr, False, False);

  Mode := 3;

  If ((AllocQty + OnOrdQty) <> 0) then
  Begin

    Mode := AgingRange(PCode, Today);

    SetAgingPeriodLabel(Mode);

    Repeat

      KeyChk := FullIdType(StkLineType[LTAry[Loop]], PCode);

      KeyS := KeyChk;

      ExLocal^.LStatus := ExLocal^.LFind_Rec(B_GetGEq, Fnum, KeyPath, KeyS);

      While (ExLocal^.LStatusOk) and
            (CheckKey(KeyChk, KeyS, Length(KeyChk), BOn)) and
            (ModalResult = mrNone) do
      With ExLocal^.LId do
      Begin
        If (CheckKey(fLocFilt, MLocStk, Length(fLocFilt), BOff)) and
           ((IdDocHed <> WOR) or (ABSLineNo = 1)) then
          Get_StockAged(AllocNum[Loop], ExLocal^.LId, Today, Mode);

        SetAllocationAgingValues(Mode);

        ExLocal^.LStatus := ExLocal^.LFind_Rec(B_GetNext, Fnum, KeyPath, KeyS);

        Application.ProcessMessages;

      end;

      Inc(Loop)

    Until (Loop > 1 + Ord(VarConst.WOPOn));

  end
  else
    SetAllocationAgingValues(Mode);

  TmpStat := ExLocal^.LPresrv_BTPos(Fnum, TmpKPath, F[Fnum], TmpRecAddr, True, True);
  //HV and R Jha 06/01/2016, JIRA-2526, Stock - Bin Availability / Equivalents blank via 'AGE' button on stock lisl and telesales screen.
  //NewPage := False;

end;

// -----------------------------------------------------------------------------

procedure TStockLevelsFrm.PageControl1Change(Sender: TObject);
var
  NewIndex  :  Integer;
begin
  if (Sender is TPageControl) then
    with Sender as TPageControl do
    begin
      NewIndex := pcLivePage(Sender);
      case NewIndex of
        {$IFDEF SOP}
        0: begin
             { If the Stock Enquiry dialog is open, and has previously
               been updated to show the details for an Equivalent item,
               we now need to restore it to show the current item. }
             if (fNeedToRestore) then
             begin
               fNeedToRestore := False;
               SendToObjectStkEnq(fPCode, fCustCode, fLocFilt, -1, -1, 0);
             end;
           end;
        {$ENDIF}
        1: if (NewPage) then
             View_Allocation(fPCode,fQAL,fQOO);
        2: if (NewPage) then
             BuildObjectDrill;
        {$IFDEF SOP}
        3: if (NewPage) then
             BuildObjectEquiv;
        {$ENDIF}
      end;
    end;
end;

// -----------------------------------------------------------------------------

procedure TStockLevelsFrm.Link2Stk(StkViewFilter: Byte);
begin
  if (StockDisplay = nil) then
    StockDisplay := TFStkDisplay.Create(Self);
  try
    StockDisplay.Display_Account(StkViewFilter);
  except
    StockDisplay.Free;
    StockDisplay := nil;
  end;
end;

// -----------------------------------------------------------------------------

procedure TStockLevelsFrm.ShowAged;
var
  LocationTitle: Str80;
begin
  LocationTitle := '';
  with ExLocal^, LStock do
  begin
    AssignFromGlobal(StockF);
    {$IFDEF SOP}
    if (not EmptyKey(fLocFilt,LocKeyLen)) then
      LocationTitle := ' - Locn : ' + fLocFilt;
    {$ENDIF}
    Caption := 'Supply/Demand : ' + LocationTitle + dbFormatName(StockCode, Desc[1]);
    View_Allocation(StockCode, AllocStock(LStock), QtyOnOrder);
  end;
end;

// -----------------------------------------------------------------------------

procedure TStockLevelsFrm.Id4QOFDblClick(Sender: TObject);
var
  S: Byte;
begin
  S := 0;
  if (Sender = Id4QAF) then
    S := 41
  else if (Sender = Id4QPF) then
    S := 44
  else if (Sender = Id4QOSF) then
  begin
    if (VarConst.WOPOn) and (ExLocal.LStock.StockType = StkBillCode) then {Chances are its on a works order}
      S := 57
    else
      S := 42;
  end
  else
    if (Sender = Id4QAWF) or (Sender = Id4QIWF) then
      S := 57
    else
      S := 54;
  Link2Stk(S);
end;

// -----------------------------------------------------------------------------

procedure TStockLevelsFrm.DestroyNodes;
var
  n      : Integer;
  ONomRec: ^ODDType;
begin
  with BinTree do {* Tidy up attached objects *}
  begin
    for n := 1 to ItemCount do
    begin
      ONomRec := Items[n].Data;
      If (ONomRec <> nil) then
        Dispose(ONomRec);
    end;
  end; {With..}
end;

// -----------------------------------------------------------------------------

procedure TStockLevelsFrm.BuildOBins(Idx: Integer);
const
  Fnum = MLocF;
var
  n,nIdx,ACnst,
  TmpStat,
  TmpKPath,
  Keypath:  Integer;
  Idx2,
  TmpRecAddr
            :  LongInt;
  ODDRec    :  ^ODDType;
  KeyS,KeyChk
            :  Str255;
  Ok2Add    :  Boolean;
  LastLoc   :  Str10;
  OLine     :  Str255;
begin
  OKCP1Btn.Enabled := BOff;

  with BinTree, ExLocal^, LStock do
  begin
    Keypath  := MLSecK;
    LastLoc  := '';
    Idx2     := Idx;
    TmpKPAth := GetPosKey;

    TmpStat := LPresrv_BTPos(Fnum,TmpKPath,F[Fnum],TmpRecAddr,BOff,BOff);

    If (fLocFilt<>'') then
      KeyChk := FullQDKey(brRecCode, MSernSub, FullNomKey(LStock.StockFolio) +
                          Full_MLocKey(fLocFilt) + Chr(0))
    else
      KeyChk := FullQDKey(brRecCode, MSernSub, FullNomKey(LStock.StockFolio));

    KeyS := KeyChk;

    LStatus := LFind_Rec(B_GetGEq, Fnum, KeyPath, KeyS);

    while (LStatusOK) and (CheckKey(KeyChk, KeyS, Length(KeyChk), BOff)) do
    with LMLocCtrl^.brBinRec do
    begin
      if (not brSold) and (not brBatchChild) then
      begin
        New(ODDRec);

        FillChar(ODDRec^, Sizeof(ODDRec^), 0);

        Ok2Add := BOn;

        if (brInMLoc<>LastLoc) then
        begin
          LastLoc := brInMLoc;
          Idx2    := AddChildObject(Idx, 'Loc: ' + LastLoc, nil);
        end;

        ODDRec^.NFnum    := MLocF;
        ODDRec^.NKeypath := MLSecK;
        ODDRec^.NKey     := FullQDKey(brRecCode,MSernSub,brCode2);
        ODDRec^.NLKey    := brCode2;
        OLine            := Trim(BrBincode1) + '.  ' +
                            Bin_AQty(brBuyQty, brQtyUsed, brBinCap, brBatchChild);
        n                := AddChildObject(Idx2, ' ' + OLine, ODDRec);
      end;

      LStatus := LFind_Rec(B_GetNext, Fnum, KeyPath, KeyS);

    end; {While..}

    TmpStat := LPresrv_BTPos(Fnum, TmpKPath, F[Fnum], TmpRecAddr, BOn, BOff);

  end; {With..}

  OKCp1Btn.Enabled:=BOn;

end;

// -----------------------------------------------------------------------------

procedure TStockLevelsFrm.BuildObjectDrill;
var
  n,Tmpn    :  Integer;
  ODDRec    :  ^ODDType;
  GenStr    :  Str255;
begin
  with BinTree, ExLocal^, LStock do
  begin
    DestroyNodes;
    Clear;
    if (MultiBinMode) then
    begin
      New(ODDRec);
      FillChar(ODDRec^,Sizeof(ODDRec^),0);
      ODDRec^.NFnum    := StockF;
      ODDRec^.NKeypath := StkCodeK;
      ODDRec^.NKey     := StockCode;
      ODDRec^.NOurRef  := StockCode;
      n := AddChildObject(0, dbFormatName(StockCode, Desc[1]), ODDRec);
      BuildOBins(n);
    end;
    FullExpand;
  end;
end;

// -----------------------------------------------------------------------------

procedure TStockLevelsFrm.BinTreeExpand(Sender: TObject; Index: Integer);
var
  ODDRec: ^ODDType;
begin
  ODDRec := BinTree.Items[Index].Data;
  with BinTree do
  if (not Items[Index].HasItems) and (Assigned(ODDRec)) then
    Control_FindBin(self, ODDRec^.NLKey, ODDRec^.NKeypath);
end;

// -----------------------------------------------------------------------------

{$IFDEF SOP}
procedure TStockLevelsFrm.DestroyNodes2;
var
  n       : Integer;
  ONomRec : ^ODDType;
begin
  with EquivalentsTree do
  begin
    for n := 1 to ItemCount do
    begin
      ONomRec := Items[n].Data;
      if (ONomRec <> nil) then
        Dispose(ONomRec);
    end;
  end;
end;

// -----------------------------------------------------------------------------

procedure TStockLevelsFrm.BuildOEquivStk(Idx: Integer);
const
  Fnum = MLocF;
var
  n,nIdx,ACnst,
  TmpStat,
  TmpKPath,
  Keypath
            :  Integer;
  Idx2,
  TmpRecAddr
            :  LongInt;
  ODDRec    :  ^ODDType;
  GenStr,KeyStk,
  KeyS,KeyChk
            :  Str255;
  SetHed,
  GotHed,
  Ok2Add    :  Boolean;
  LastLoc   :  Str10;
  OLine     :  Str255;
  TmpStk    :  StockRec;
begin
  OKCP1Btn.Enabled := BOff;

  SupressOpo := BOff;

  if (OpoLineHandle <> 0) then {* Query if opo should be shown *}
    SendMessage(OpoLineHandle, WM_CustGetRec, 1129, LongInt(self.Handle));

  with EquivalentsTree, ExLocal^, LStock do
  begin
    Keypath  := MLSuppK;
    LastLoc  := '';
    Idx2     := Idx;
    SetHed   := False;
    TmpKPath := GetPosKey;

    TmpStat := LPresrv_BTPos(Fnum, TmpKPath, F[Fnum], TmpRecAddr, False, False);

    for n := Low(AltSPFix) to High(AltSPFix) do
    begin
      GotHed := False;
      case n of
        0            : Keypath := MLSecK;
        SuperSdPageNo: Keypath := MLK;
      else
        Keypath := MLSuppK;
      end;

      if (n <> SuperSdPageNo) then
        KeyChk := PartCCKey(NoteTCode, AltSPfix[n]) + FullNomKey(ExLocal^.LStock.StockFolio)
      else
        KeyChk := PartCCKey(NoteTCode,AltSPfix[n])+ExLocal^.LStock.StockCode;

      KeyS := KeyChk;

      LStatus := LFind_Rec(B_GetGEq, Fnum, KeyPath, KeyS);

      while (LStatusOK) and (CheckKey(KeyChk, KeyS, Length(KeyChk), False)) and
            ((n<>OppoPageNo) or (Not SupressOpo)) do
      with LMLocCtrl^, sdbStkRec do
      begin
        if (CheckKey(fCustCode, sdSuppCode, Length(fCustCode), False)) or
           (Trim(sdSuppCode) = '') then
        begin
          if (not GotHed) then
          begin
            GotHed := True;
            Idx2   := AddChildObject(Idx, AltRecCaption[n], nil);
            SetHed := True;
          end;

          New(ODDRec);

          FillChar(ODDRec^, Sizeof(ODDRec^), 0);

          Ok2Add := True;

          ODDRec^.NFnum    := MLocF;
          ODDRec^.NKeypath := MLK;
          ODDRec^.NKey     := PartCCKey(RecPFix,SubType)+sdCode1;
          ODDRec^.NLKey    := sdCode1;

          if (n = AltPageNo) then
          begin
            ODDRec^.NValue := sdROPrice;
            ODDRec^.nOQty  := sdOverRO;
            ODDRec^.NOCurr := sdROCurrency;
          end
          else
          begin
            ODDRec^.NValue := sdLineQty;
            ODDRec^.nOQty  := sdOVerLineQty;
          end;

          ODDRec^.NMiscMode := n;

          if (n <> SuperSdPageNo) then
          begin
            if (sdOverLineQty) then
              GenStr := FormatBFloat(GenQtyMask, sdLineQty, True) + ' x ' + sdCode1
            else
              case n of
                AltPageNo: begin
                             if (sdOverRO) then
                               GenStr := FormatCurFloat(GenRealMask, sdROPrice, True, sdROCurrency) + '. '
                             else
                               GenStr := '';

                             If (sdOverMinEcc) then
                               GenStr := GenStr + FormatBFloat(GenQtyMask, sdMinEccQty, True) + ' x ';

                             GenStr := GenStr + sdCode1;
                           end;
              else
                GenStr := sdCode1;
              end;

            OLine := dbFormatName(GenStr, sdDesc);
          end
          else
          begin
            TmpStk := LStock;
            KeyStk := FullNomKey(sdStkFolio);

            LStatus := LFind_Rec(B_GetEq, StockF, StkFolioK, KeyStk);

            If (LStatusOk) then
              OLine := dbFormatName(LStock.StockCode, LStock.Desc[1])
            else
              OLine := 'Stock Record not found.';

            LStock := TmpStk;
          end;

          nIdx := AddChildObject(Idx2, ' ' + OLine, ODDRec);

          if (SetHed) then
          begin
            AltIdxPos[n] := nIdx;
            SetHed       := False;
          end;

        end;

        LStatus := LFind_Rec(B_GetNext, Fnum, KeyPath, KeyS);

      end;
    end;

    TmpStat := LPresrv_BTPos(Fnum, TmpKPath, F[Fnum], TmpRecAddr, True, False);

  end; {With..}

  OKCp1Btn.Enabled := True;

end;

// -----------------------------------------------------------------------------

procedure TStockLevelsFrm.BuildObjectEquiv;
var
  n,Tmpn    :  Integer;
  GenStr    :  Str255;
begin
  with EquivalentsTree,ExLocal^,LStock do
  begin
    InEquivReset := BOn;
    try
      DestroyNodes2;
      Clear;
      BuildOEQuivStk(0);
      FullExpand;
    finally
      InEquivReset:=BOff;
    end;
  end;
end;

// -----------------------------------------------------------------------------

Function TStockLevelsFrm.ReturnObjectEquiv  :  Boolean;
var
  n,Tmpn    :  Integer;
  ODDRec    :  ^ODDType;
Begin
  With EquivalentsTree do
  If (SelectedItem >= 0) then
  Begin
    ODDRec    := EquivalentsTree.Items[SelectedItem].Data;
    fpOSCode  := ODDRec^.NLKey;
    fpOSQty   := ODDRec^.NValue;
    fpSetQty  := ODDRec^.NOQty;
    fpSetCurr := ODDRec^.NOCurr;
    Result    := BOn;
  end
  else
    Result:=BOff;
end;

// -----------------------------------------------------------------------------

Function TStockLevelsFrm.ReturnObjectMLoc  :  MLocRec;
Var
  n,Tmpn    :  Integer;
  ODDRec    :  ^ODDType;
  KeyChk    :  Str255;
Begin
  FillChar(Result,Sizeof(Result),#0);
  With EquivalentsTree do
  If (SelectedItem>=0) then
  Begin
    ODDRec := EquivalentsTree.Items[SelectedItem].Data;
    With ExLocal^, ODDRec^ do
    Begin
      KeyChk:=NKey;
      LStatus := LFind_Rec(B_GetGEq, NFnum, NKeyPath, KeyChk);
      If (LStatusOk) then
        Result:=LMLocCtrl^;
    end;
  end;
end;
{$ENDIF}

// -----------------------------------------------------------------------------

procedure TStockLevelsFrm.EquivalentsTreeClick(Sender: TObject);
{ If the Stock Enquiry dialog is open, update it if the user clicks a Stock
  Item in the Equivalent Stock Items list. }
var
  ODDRec: ^ODDType;
begin
  {$IFDEF SOP}
  with EquivalentsTree do
  if (SelectedItem>=0) then
  begin
    ODDRec := EquivalentsTree.Items[SelectedItem].Data;
    with EquivalentsTree do
    if (not Items[SelectedItem].HasItems) and
       (Assigned(ODDRec)) and
       (ODDRec^.NMiscMode > AltPageNo) then
    begin
      SendToObjectStkEnq(ODDRec^.NLKey, fCustCode, fLocFilt,-1,-1,0);
      fNeedToRestore := BOn;
    end;
  end;
  {$ENDIF}
end;

// -----------------------------------------------------------------------------

procedure TStockLevelsFrm.AddStock(StockCode: string; QtyAvailable,
  QtyRequired: Double; Location: string);
{ Adds a new entry to the internal list of all the stock items found on the
  current transaction. }
begin
  if (FindStockEntry(StockCode, Location) = -1) then
    FullStockList.AddObject(StockCode, TStockLevel.Create(StockCode, QtyAvailable, QtyRequired, Location));
end;

// -----------------------------------------------------------------------------

procedure TStockLevelsFrm.AddLowStock(StockCode: string; Location: string);
{ Adds a new entry to the internal list of all the stock items that we might not
  have sufficient quantities of. }
begin
  if (FindLowStockEntry(StockCode, Location) = -1) then
    LowStockList.Items.AddObject(StockCode, TStockLevel.Create(StockCode, 0, 0, Location));
end;

// -----------------------------------------------------------------------------

procedure TStockLevelsFrm.RemoveLowStock(StockCode, Location: string);
{ Removes an entry from the internal list of stock items. }
var
  i: Integer;
begin
  i := FindLowStockEntry(StockCode, Location);
  if (i <> -1) then
  begin
    LowStockList.Items.Objects[i].Free;
    LowStockList.Items.Delete(i);
  end;
end;

// -----------------------------------------------------------------------------

function TStockLevelsFrm.Check(IdR: Idetail; StockMovement: Double;
  Mode: Integer; WindowHandle: HWND; Edit: Boolean): Boolean;
{ Main checking routine to determine whether there are sufficient items in stock
  of the stock item on the supplied line to fulfil the transaction. This
  attempts to take into account any other stock movement of this item on the
  same transaction, and also checks sub-components of BoMs. }
var
  StockCode: str20;
  OriginalRecAddr: LongInt;
  CurrentRecAddr: LongInt;
  QtyRequired: Double;
  FuncRes: LongInt;
  AlreadyStored: Boolean;
begin
  self.WindowHandle := WindowHandle;
  if (CheckNegStk) then
  begin
    OriginalIdRec := IdR;
    AddStockItem(IdR);
    SavePositions;
    AlreadyStored := Edit;
    // Find the first line on the Transaction.
    FindFirstLine(IdR.FolioRef);
    // For each Transaction Line
    while HasMoreLines do
    begin
      // Locate the Stock record
      StockCode := ExLocal^.LId.StockCode;
      if (FindStock(StockCode) = 0) then
      begin
        QtyRequired := ExLocal^.LId.Qty * -1.0;
        // If the Transaction Line being checked has already been stored...
        if AlreadyStored then
        begin
          // ...and we are on that Transaction Line...
//          ExLocal^.LGetPos(IdetailF, CurrentRecAddr);
//          if (CurrentRecAddr = OriginalRecAddr) then
          if IdR.StockCode = ExLocal^.LId.StockCode then
          begin
            // ...use the new quantity, not the stored quantity.
            QtyRequired := StockMovement;
            // Make sure we use the correct 'Build BOM' values.
            ExLocal^.LId.KitLink := IdR.KitLink;
            ExLocal^.LId.Qty     := IdR.Qty;
          end;
        end;
        // For Bill of Material items, check the sub-components
        if (ExLocal^.LStock.StockType = StkBillCode) and
           (ExLocal^.LId.KitLink = 1) and
           (ExLocal^.LId.Qty > 0) then
        begin
          CheckComponents(ExLocal^.LId, QtyRequired * -1.0, Mode);
          EquivPage.TabVisible := False;
        end
        else
          // Otherwise, just check the item itself
          CheckStock(ExLocal^.LId, QtyRequired, Mode);
      end;
      FindNextLine;
    end;
    // If the Transaction Line has not been stored yet, it will not have been
    // found amongst the existing lines, so we need to check it using the
    // supplied IDetail record.
    if not AlreadyStored then
    begin
      QtyRequired := StockMovement;
      // Locate the Stock record
      StockCode := IdR.StockCode;
      if (FindStock(StockCode) = 0) then
      begin
        // For Bill of Material items, check the sub-components
        if ((ExLocal^.LStock.StockType = StkBillCode) and
            ((Syss.DeadBOM) or (Mode = 3)) and
            ((QtyRequired < 0) or (Mode <> 3))) then
        begin
          CheckComponents(IdR, QtyRequired * -1.0, Mode);
          EquivPage.TabVisible := False;
        end
        else
          // Otherwise, just check the item itself
          CheckStock(IdR, QtyRequired, Mode);
      end;
    end;
    RestorePositions;
    // Return True if enough stock was found, otherwise False
    Result := (LowStockList.Items.Count = 0);
    if not Result then
    begin
      LowStockList.ItemIndex := 0;
      ShowStock;
    end;
  end
  else
    Result := True;
end;

// -----------------------------------------------------------------------------

function TStockLevelsFrm.CheckComponents(IdR: Idetail; QtyRequired: Double;
  Mode: Integer): Boolean;
const
  Fnum     =  PWrdF;
  Keypath  =  PwK;
  Fnum2    =  StockF;
  Keypath2 =  StkFolioK;
var
  KeyS,
  KeyChk,
  KeyStk   :  Str255;
  RecAddr  :  LongInt;
  StkRecAddr: LongInt;
  FuncRes: LongInt;
  WasMode3,
  EnoughStock :  Boolean;
  QtyShort,
  QtyAvailable     :  Real;
  IsBuildingBOM: Boolean;
begin
  Addch := ResetKey;

  KeyS   := '';
  KeyChk := '';
  KeyStk := '';

  RecAddr := 0;

  WasMode3 := (Mode = 3);
  QtyShort := 0;

  {$IFDEF SOP}
    // Copy the Location stock values to the Stock record (if multiple locations
    // are being used).
    Stock_LocSubst(ExLocal^.LStock, IdR.MLocStk);
  {$ENDIF}

  case Mode of
    2, 3:
      QtyAvailable := (ExLocal^.LStock.QtyInStock - ExLocal^.LStock.QtyPicked);  {* Do not base check on Free Stock *}
    else
      QtyAvailable := FreeStock(ExLocal^.LStock);
  end;

    QtyShort := QtyRequired;

    if (Mode = 3) then
      Mode := 2;

    // Locate the Bill of Material records for this Stock item
    KeyChk := Strip('R', [#32], FullMatchKey(BillMatTCode, BillMatSCode, FullNomKey(ExLocal^.LStock.StockFolio)));
    KeyS   := KeyChk;
    ExLocal^.LStatus := ExLocal^.LFind_Rec(B_GetGEq, Fnum, Keypath, KeyS);
    // For each Bill of Material record...
    while (ExLocal^.LStatusOk) and
          (CheckKey(KeyChk, KeyS, Length(KeyChk), BOn)) and
          (Addch <> Esc) do
    with ExLocal^.LPassword.BillMatRec do
    begin
      ExLocal^.LStatus := ExLocal^.LGetPos(Fnum, RecAddr);

      // ...locate the actual Stock record for this sub-component
      KeyStk := BillLink;
      ExLocal^.LStatus := ExLocal^.LFind_Rec(B_GetEq, Fnum2, Keypath2, KeyStk);
      if (ExLocal^.LStatusOk) then
      begin
        // If it is a Bill of Material item...
        if (ExLocal^.LStock.StockType = StkBillCode) then
        begin
          // CJS 2011-10-03 v6.9 - ABSEXCH-11644 - Sub-BoM check. Reorganised
          // this to check for built BoMs first, and then to check for
          // sub-components if necessary.

          Result := False;

          // Check the BoM itself.
//          if (WasMode3) then
          begin
            Result := CheckStock(IdR, (QtyShort * QtyUsed), Mode);

            // Relocate the original Stock record (CheckStock might have
            // changed our position in the file).
            KeyStk := BillLink;
            ExLocal^.LStatus := ExLocal^.LFind_Rec(B_GetEq, Fnum2, Keypath2, KeyStk);
          end;

          if Syss.DeadBOM and not Result then
          begin
            // ...check the sub-components.
            Result := CheckComponents(IdR, QtyShort * QtyUsed, Mode);
          end;

          SetDataRecOfs(Fnum, RecAddr);
          ExLocal^.LStatus := ExLocal^.LGetDirect(Fnum, KeyPath, 0);
        end
        else
          // ...otherwise, check the item itself.
          CheckStock(IdR, (QtyShort * QtyUsed), Mode);
      end;

      ExLocal^.LStatus := ExLocal^.LFind_Rec(B_GetNext, Fnum, Keypath, KeyS);

    end;

//  end;
  Result := (LowStockList.Items.Count = 0);
end;

// -----------------------------------------------------------------------------

function TStockLevelsFrm.CheckStock(IdR: Idetail; QtyRequired: Double;
  Mode: Integer): Boolean;
var
  PrevHState,
  EnoughStock :  Boolean;
  QtyAvailable: Double;
  LocStr   :  Str20;
  lOldQtyReq : Double;
Begin
  Result := True;

  EnoughStock := BOff;

  LocStr := '';

  if (FindStockEntry(ExLocal^.LStock.StockCode, IdR.MLocStk) <> -1) then
  with ExLocal^.LStock do
  begin

    {$IFDEF SOP}
      // Copy the Location stock values to the Stock record (if multiple
      // locations are being used).
      Stock_LocSubst(ExLocal^.LStock, IdR.MLocStk);
    {$ENDIF}

    case Mode of
      2,3:  QtyAvailable := Round_Up(QtyInStock - QtyPicked - QtyPickWOR, Syss.NoQtyDec);
      else  QtyAvailable := FreeStock(ExLocal^.LStock);
    end;

    {SS 04/07/2016 2016-R3
  	 ABSEXCH-14333:Negative stock - once the transaction is added then edited later the negative warning does not show.
     -Backup and restore QtyRequired so that it can calculate requirement of stock properly.}
    lOldQtyReq := QtyRequired;

    QtyRequired := QtyRequired + QuantityRequested(StockCode, IdR.MLocStk);
    UpdateQuantityRequested(StockCode, IdR.MLocStk, QtyRequired);

    QtyRequired := lOldQtyReq;

    {
      CJS 14/02/2011 - ABSEXCH-10886 - Insufficient Warning was being triggered
      erroneously on some occasions.

      Because of floating-point issues, the QtyAvailable - QtyRequired
      calculation was sometimes returning a small but non-zero value when the
      two values were actually equal. Corrected this by rounding the result.
    }
//    EnoughStock := (((QtyAvailable - QtyRequired) >=0) or (StockType In [StkGrpCode, StkDescCode]));
    EnoughStock := ((Round_Up(QtyAvailable - QtyRequired, Syss.NoQtyDec) >=0) or (StockType In [StkGrpCode, StkDescCode]));

    if (not EnoughStock) then
    begin
      Result := False;
        AddLowStock(StockCode, IdR.MLocStk);
    end
    else
    begin
      RemoveLowStock(StockCode, IdR.MLocStk);
    end;

  end;

end;

// -----------------------------------------------------------------------------

procedure TStockLevelsFrm.Clear;
var
  i: Integer;
begin
  for i := 0 to LowStockList.Items.Count - 1 do
  begin
    if (LowStockList.Items.Objects[i] <> nil) then
    begin
      LowStockList.Items.Objects[i].Free;
      LowStockList.Items.Objects[i] := nil;
    end;
  end;
  LowStockList.Items.Clear;
  for i := 0 to FullStockList.Count - 1 do
  begin
    if (FullStockList.Objects[i] <> nil) then
    begin
      FullStockList.Objects[i].Free;
      FullStockList.Objects[i] := nil;
    end;
  end;
  FullStockList.Clear;
end;

// -----------------------------------------------------------------------------

procedure TStockLevelsFrm.FindFirstLine(Folio: Integer);
var
  FuncRes: LongInt;
begin
  IdKey := FullNomKey(Folio);
  FuncRes := ExLocal^.LFind_Rec(B_GetGEq, IdetailF, 0, IdKey);
  HasMoreLines := ((FuncRes = 0) and (ExLocal^.LId.FolioRef = OriginalIdRec.FolioRef));
end;

// -----------------------------------------------------------------------------

function TStockLevelsFrm.FindStockEntry(ForStockCode: Str20;
  ForLocation: string): Integer;
var
  i: Integer;
begin
  Result := -1;
  for i := 0 to FullStockList.Count - 1 do
  begin
    if (FullStockList[i] = ForStockCode) and
       ((FullStockList.Objects[i] as TStockLevel).Location = ForLocation) then
    begin
      Result := i;
      break;
    end;
  end;
end;

// -----------------------------------------------------------------------------

function TStockLevelsFrm.FindLowStockEntry(ForStockCode: Str20;
  ForLocation: string): Integer;
var
  i: Integer;
begin
  Result := -1;
  for i := 0 to LowStockList.Items.Count - 1 do
  begin
    if (LowStockList.Items[i] = ForStockCode) and
       ((LowStockList.Items.Objects[i] as TStockLevel).Location = ForLocation) then
    begin
      Result := i;
      break;
    end;
  end;
end;

// -----------------------------------------------------------------------------

procedure TStockLevelsFrm.FindNextLine;
var
  FuncRes: LongInt;
begin
  FuncRes := ExLocal^.LFind_Rec(B_GetNext, IdetailF, 0, IdKey);
  if (FuncRes = 0) and (ExLocal^.LId.FolioRef = OriginalIdRec.FolioRef) then
    HasMoreLines := True
  else
    HasMoreLines := False;
end;

// -----------------------------------------------------------------------------

function TStockLevelsFrm.QuantityRequested(ForStockCode: Str20;
  ForLocation: string): Double;
var
  i: Integer;
begin
  i := FindStockEntry(ForStockCode, ForLocation);
  if (i <> -1) then
  begin
    with FullStockList.Objects[i] as TStockLevel do
      Result := QtyRequired;
  end
  else
    Result := 0.0;
end;

// -----------------------------------------------------------------------------

function TStockLevelsFrm.RestorePositions: LongInt;
var
  KeyPath: Integer;
begin
  KeyPath := 0;
  // Restore Stock record & position
  Result := ExLocal^.LPresrv_BTPos(IdetailF, KeyPath, ExLocal^.LocalF^[IdetailF], IdRecAddr, True, True);
  if (Result = 0) then
  begin
    // Restore Transaction record & position
    Result := ExLocal^.LPresrv_BTPos (InvF, KeyPath, ExLocal^.LocalF^[InvF], InvRecAddr, True, True);
    if (Result = 0) then
    begin
      // Restore Transaction Line record & position
      Result := ExLocal^.LPresrv_BTPos (IdetailF, KeyPath, ExLocal^.LocalF^[IdetailF], IdRecAddr, True, True);
    end;
  end;
end;

// -----------------------------------------------------------------------------

function TStockLevelsFrm.SavePositions: LongInt;
var
  KeyPath: Integer;
begin
  KeyPath := 0;
  // Save Stock record & position
  Result := ExLocal^.LPresrv_BTPos(StockF, KeyPath, ExLocal^.LocalF^[StockF], StockRecAddr, False, False);
  if (Result = 0) then
  begin
    // Save Transaction record & position
    Result := ExLocal^.LPresrv_BTPos(InvF, KeyPath, ExLocal^.LocalF^[InvF], InvRecAddr, False, False);
    if (Result = 0) then
    begin
      // Save Transaction Line record & position
      Result := ExLocal^.LPresrv_BTPos(IdetailF, KeyPath, ExLocal^.LocalF^[IdetailF], IdRecAddr, False, False);
    end;
  end;
end;

// -----------------------------------------------------------------------------

procedure TStockLevelsFrm.UpdateQuantityRequested(ForStockCode: Str20;
  ForLocation: string; QtyRequired: Double);
var
  i: Integer;
begin
  i := FindStockEntry(ForStockCode, ForLocation);
  if (i <> -1) then
    (FullStockList.Objects[i] as TStockLevel).QtyRequired := QtyRequired;
end;

// -----------------------------------------------------------------------------

procedure TStockLevelsFrm.ShowStock;
var
  LocStr: string;
  RNum: Real;
  Level: TStockLevel;
  Entry: Integer;
  StockCode: Str20;
  Location: string;
begin
  SavePositions;
  try
    { Get the Stock Code and Location of the selected item. }
    Level := TStockLevel(LowStockList.Items.Objects[LowStockList.ItemIndex]);
    StockCode := LowStockList.Items[LowStockList.ItemIndex];
    Location  := Level.Location;
    { Read the details from the full list of stock items for this Transaction }
    Entry := FindStockEntry(StockCode, Location);
    Level := TStockLevel(FullStockList.Objects[Entry]);
    if (FindStock(StockCode) = 0) then
    begin
      {$IFDEF SOP}
      // Copy the Location stock values to the Stock record (if multiple
      // locations are being used).
      Stock_LocSubst(ExLocal^.LStock, Level.Location);
      {$ENDIF}
      If (not EmptyKey(Level.Location, MLocKeyLen)) and (Syss.UseMLoc) then
      begin
        fLocFilt := Level.Location;
        LocStr:='At Location : '+ Level.Location;
      end;

      Caption := 'Warning - Insufficient Stock: ' + dbFormatName(StockCode, ExLocal^.LStock.Desc[1]);
      Pan1.Caption:=LocStr;
      Pan2.Caption:=LocStr;

      Rnum := Round_Up(ExLocal^.LStock.QtyInStock - ExLocal^.LStock.QtyPicked - ExLocal^.LStock.QtyPickWOR, Syss.NoQtyDec);

      {$IFDEF SOP}
        fPCode:=StockCode;
        fQAL:=CaseQty(ExLocal^.LStock,AllocStock(Stock));
        fQOO:=CaseQty(ExLocal^.LStock,ExLocal^.LStock.QtyOnOrder);

        Id4QPF.Visible:=BOn;
        PickLab.Visible:=BOn;
        Id4QPF.Value:=CaseQty(ExLocal^.LStock,ExLocal^.LStock.QtyPicked);

        Id4QOF.Value:=CaseQty(ExLocal^.LStock,ExLocal^.LStock.QtyInStock);
        Id4QAF.Value:=CaseQty(ExLocal^.LStock,AllocStock(ExLocal^.LStock));

        edtRequired.Value := CaseQty(ExLocal^.LStock, Level.QtyRequired);
        Id4QFF.Value:=CaseQty(ExLocal^.LStock,Rnum);
        Id4QNF.Value:=CaseQty(ExLocal^.LStock, Level.QtyRequired - Level.QtyAvailable);
        Id4QOSF.Value:=CaseQty(ExLocal^.LStock,ExLocal^.LStock.QtyOnOrder);
        Id4QPWF.Value:=CaseQty(ExLocal^.LStock,ExLocal^.LStock.QtyPickWOR);
        Id4QAWF.Value:=CaseQty(ExLocal^.LStock,WOPAllocStock(ExLocal^.LStock));
        Id4QIWF.Value:=CaseQty(ExLocal^.LStock,ExLocal^.LStock.QtyIssueWOR);

      {$ELSE}
        edtRequired.Value := CaseQty(ExLocal^.LStock, Level.QtyRequired);
        Id4QOF.Value:=CaseQty(ExLocal^.LStock,ExLocal^.LStock.QtyInStock);
        Id4QAF.Value:=CaseQty(ExLocal^.LStock,AllocStock(ExLocal^.LStock));
        Id4QFF.Value:=CaseQty(ExLocal^.LStock,Rnum);
        Id4QNF.Value:=CaseQty(ExLocal^.LStock,Level.QtyRequired - Level.QtyAvailable);
        Id4QOSF.Value:=CaseQty(ExLocal^.LStock,ExLocal^.LStock.QtyOnOrder);
        Id4QPWF.Value:=CaseQty(ExLocal^.LStock,ExLocal^.LStock.QtyPickWOR);
        Id4QAWF.Value:=CaseQty(ExLocal^.LStock,WOPAllocStock(ExLocal^.LStock));
        Id4QIWF.Value:=CaseQty(ExLocal^.LStock,ExLocal^.LStock.QtyIssueWOR);
      {$ENDIF}

    end;
    if (PageControl1.ActivePage <> StkLevelsPage) then
      PageControl1Change(PageControl1);
  finally
    RestorePositions;
  end;
end;

// -----------------------------------------------------------------------------

procedure TStockLevelsFrm.LowStockListClick(Sender: TObject);
begin
  if (LowStockList.ItemIndex <> -1) then
    ShowStock;
end;

// -----------------------------------------------------------------------------

function TStockLevelsFrm.FindStock(StockCode: Str20): LongInt;
var
  Key: Str255;
begin
  Key := FullStockCode(StockCode);
  Result := ExLocal^.LFind_Rec(B_GetEq, StockF, StkCodeK, Key);
end;

// -----------------------------------------------------------------------------

procedure TStockLevelsFrm.EquivalentsTreeDblClick(Sender: TObject);
var
  ODDRec: ^ODDType;
  Index: Integer;
begin
  {$IFDEF SOP}
  Index := EquivalentsTree.SelectedItem;
  if (Index > -1) then
  begin
    ODDRec := EquivalentsTree.Items[Index].Data;
    if (Assigned(ODDRec) and Assigned(FOnSelectAlternateStock)) then
      OnSelectAlternateStock(ODDRec^.NLKey);
  end;
  {$ENDIF}
end;

// -----------------------------------------------------------------------------

function TStockLevelsFrm.IsBuildingBOM(IdR: Idetail): Boolean;
begin
  Result := (ExLocal^.LStock.StockType = StkBillCode) and
            (IdR.KitLink = 1);
end;

// -----------------------------------------------------------------------------

procedure TStockLevelsFrm.AddStockItem(IdR: Idetail);
{ Adds the stock item from the supplied transaction line to the internal list
  of items, including the number of items available and the location. }
var
  Res: LongInt;
  Available: Double;
begin
  // Exit straight away if the stock item is already recorded.
  Res := FindStock(IdR.StockCode);
  if (Res <> 0) then
  begin
    Exit;
  end;
  // If the item is a Bill of Materials item, add all the components as well,
  // so that we can correctly calculate the stock item totals where the required
  // components on the transaction are in BoM items (and therefore not directly
  // visible in the line records).
  if (IsBuildingBOM(IdR)) then
    AddSubcomponents(IdR)
  else
  begin
    // Calculate the number of items in stock and store this along with the
    // identifying details of the Stock item.
    Available := CalculateAvailable(IdR.MLocStk);
    AddStock(ExLocal^.LStock.StockCode, Available, 0.0, IdR.MLocStk);
  end;
end;

// -----------------------------------------------------------------------------

procedure TStockLevelsFrm.AddSubcomponents(IdR: Idetail);
{ Only called if IdR holds a BoM Stock item. Locates all the components of the
  item, recursively including any sub-BoMs, and stores the details. }
var
  Res: LongInt;
  Available: Double;
  Key: Str255;
  KeyChk: Str255;
  Location: string;
  RecAddr: LongInt;
  StockCode: Str20;
  HasPosition: Boolean;
begin
  Location := IdR.MLocStk;
  Res := StoreBOMRecordPosition(RecAddr);
  HasPosition := (Res = 0);
  // Find first component item for this BOM Stock item.
  KeyChk := Strip('R', [#32], FullMatchKey(BillMatTCode, BillMatSCode, FullNomKey(ExLocal^.LStock.StockFolio)));
  Key    := KeyChk;
  Res    := ExLocal^.LFind_Rec(B_GetGEq, PWrdF, PwK, Key);
  // For every component on the BoM:
  while (Res = 0) do
  begin
    // Re-locate and read the Stock record for the BoM.
    FindBOMStock;
    // Locate and read the Stock record for the actual component.
    StockCode := ExLocal^.LPassword.BillMatRec.FullStkCode;
    Res := FindStock(StockCode);
    if (Res <> 0) then
    begin
      Exit;
    end;
    // Calculate the number of items in stock and store this along with the
    // identifying details of the Stock item.
    Available := CalculateAvailable(IdR.MLocStk);
    // CJS 2011-10-03 v6.9 - ABSEXCH-11644 - Sub-BoM check.
    // Amended to add the actual BoM as well as the components.
    if (IsBuildingBOM(IdR)) then
      AddSubcomponents(IdR);
//    else
      AddStock(StockCode, Available, 0.0, Location);
    Res := FindNextBOMItem(Key, KeyChk);
  end;
  if (HasPosition) then
    Res := RestoreBOMRecordPosition(RecAddr);
end;

// -----------------------------------------------------------------------------

function TStockLevelsFrm.FindNextBOMItem(var KeyS: Str255; KeyChk: Str255): LongInt;
begin
  Result := ExLocal^.LFind_Rec(B_GetNext, PWrdF, PwK, KeyS);
  if not (CheckKey(KeyChk, KeyS, Length(KeyChk), BOn)) then
    Result := 9;
end;

// -----------------------------------------------------------------------------

function TStockLevelsFrm.FindBOMStock: LongInt;
var
  Key: Str255;
begin
  Key    := ExLocal^.LPassword.BillMatRec.BillLink;
  Result := ExLocal^.LFind_Rec(B_GetEq, StockF, StkFolioK, Key);
end;

// -----------------------------------------------------------------------------

function TStockLevelsFrm.StoreBOMRecordPosition(var RecAddr: LongInt): LongInt;
begin
  Result := ExLocal^.LGetPos(PWrdF, RecAddr);
end;

// -----------------------------------------------------------------------------

function TStockLevelsFrm.RestoreBOMRecordPosition(RecAddr: LongInt): LongInt;
begin
  // CJS 2011-12-23: ABSEXCH-12346 - Adding BoM lines to ADJ
  ExLocal^.LSetDataRecOfs(PWrdF, RecAddr);
  Result := ExLocal^.LGetDirect(PWrdF, 0, 0);
end;

// -----------------------------------------------------------------------------

function TStockLevelsFrm.CalculateAvailable(Location: string): Double;
{ Calculates and returns the number of items available at the specified location
  for the Stock item which is currently in ExLocal^.LStock. }
begin
{$IFDEF SOP}
  // Copy the Location stock values to the Stock record (if multiple
  // locations are being used).
  Stock_LocSubst(ExLocal^.LStock, Location);
{$ENDIF}
  Result := Round_Up(ExLocal^.LStock.QtyInStock -
                     ExLocal^.LStock.QtyPicked -
                     ExLocal^.LStock.QtyPickWOR, Syss.NoQtyDec);
end;

// -----------------------------------------------------------------------------

// =============================================================================
// TStockLevel
// =============================================================================
constructor TStockLevel.Create(StockCode: Str20; QtyAvailable,
  QtyRequired: Double; Location: string);
begin
  inherited Create;
  self.StockCode    := StockCode;
  self.QtyAvailable := QtyAvailable;
  self.QtyRequired  := QtyRequired;
  self.Location     := Location;
end;

// -----------------------------------------------------------------------------

end.
