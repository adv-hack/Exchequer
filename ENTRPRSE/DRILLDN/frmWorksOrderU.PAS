unit frmWorksOrderU;

{$I DEFOVR.Inc}

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ExtCtrls, SBSPanel, TEditVal, Mask, ComCtrls,
  Menus, Gauges, TCustom,
  GlobVar,
  VarConst,
  SupListU,
  ExWrap1U,
  BTSupU1,
  SBSComp2,
  frmWorksOrderEntryU;

type
  { Works Order Details mode }
  TwdMode = (wdCreate, wdUpdate);

  { Works Order Btrieve List }
  TWORMList  =  Class(TGenList)
  public
    CtrlBOM: IDetail;
    function SetCheckKey:  Str255; Override;
    function SetFilter:  Str255; Override;
    function CheckRowEmph:  Byte; Override;
    function OutLine(Col: Byte):  Str255; Override;
  end;

  TfrmWorksOrder = class(TForm)
    PageControl: TPageControl;
    AdjustPage: TTabSheet;
    BtListBox: TScrollBox;
    A1HedPanel: TSBSPanel;
    A1CLab: TSBSPanel;
    A1GLab: TSBSPanel;
    A1OLab: TSBSPanel;
    A1DLab: TSBSPanel;
    A1ILab: TSBSPanel;
    A1CCLab: TSBSPanel;
    A1DpLab: TSBSPanel;
    A1CPanel: TSBSPanel;
    A1IPanel: TSBSPanel;
    A1GPanel: TSBSPanel;
    A1DPanel: TSBSPanel;
    A1OPanel: TSBSPanel;
    A1CCPanel: TSBSPanel;
    A1DpPanel: TSBSPanel;
    A1BtmPanel: TSBSPanel;
    CCPanel: TSBSPanel;
    CCTit: Label8;
    DepTit: Label8;
    CCLab: Label8;
    CostPanel: TSBSPanel;
    DrReqdTit: Label8;
    IssuePanel: TSBSPanel;
    CrReqdTit: Label8;
    BtListBtnPanel: TSBSPanel;
    A1BPanel: TSBSPanel;
    A1BLab: TSBSPanel;
    A1UPanel: TSBSPanel;
    A1ULab: TSBSPanel;
    DepLab: Label8;
    CostLab: Label8;
    A1FPanel: TSBSPanel;
    Label817: Label8;
    Label84: Label8;
    Label88: Label8;
    A1OrefF: Text8Pt;
    A1OpoF: Text8Pt;
    A1TDateF: TEditDate;
    A1TPerF: TEditPeriod;
    A1CompF: Text8Pt;
    A1LocPanel: TSBSPanel;
    A1LocLab: TSBSPanel;
    A1LocTxF: Text8Pt;
    LTxfrLab: Label8;
    I1AccF: Text8Pt;
    Label89: Label8;
    A1CDateF: TEditDate;
    Label811: Label8;
    Bevel1: TBevel;
    TransExtForm1: TSBSExtendedForm;
    I1YrRefL: Label8;
    I1YrRef2L: Label8;
    UDF1L: Label8;
    UDF3L: Label8;
    UDF2L: Label8;
    UDF4L: Label8;
    THUD1F: Text8Pt;
    THUD3F: Text8Pt;
    THUD4F: Text8Pt;
    THUD2F: Text8Pt;
    A1YRefF: Text8Pt;
    I1YrRef2F: Text8Pt;
    Label87: Label8;
    IssuedLab: Label8;
    A1UOPanel: TSBSPanel;
    A1UOLab: TSBSPanel;
    A1OSPanel: TSBSPanel;
    A1OSLab: TSBSPanel;
    A1BUPanel: TSBSPanel;
    A1BULab: TSBSPanel;
    A1IssPanel: TSBSPanel;
    A1IssLab: TSBSPanel;
    TabSheet1: TTabSheet;
    TabSheet2: TTabSheet;
    TabSheet3: TTabSheet;
    Label810: Label8;
    LocLab: Label8;
    PopupMenu: TPopupMenu;
    N2: TMenuItem;
    PropFlg: TMenuItem;
    N1: TMenuItem;
    StoreCoordFlg: TMenuItem;
    FinPanel: TSBSPanel;
    Label812: Label8;
    IssLab: Label8;
    Label813: Label8;
    Gauge1: TGauge;
    Gauge2: TGauge;
    Label814: Label8;
    Label815: Label8;
    A1BldF: TCurrencyEdit;
    Label816: Label8;
    Label818: Label8;
    A1IssF: TCurrencyEdit;
    WorksOrder1: TMenuItem;
    BtnPanel: TSBSPanel;
    lblStatus: Label8;
    I1BSBox: TScrollBox;
    btnViewLine: TButton;
    btnClose: TButton;
    ResetCoordinates1: TMenuItem;
    UDF5L: Label8;
    UDF6L: Label8;
    UDF8L: Label8;
    UDF7L: Label8;
    UDF9L: Label8;
    UDF10L: Label8;
    THUD5F: Text8Pt;
    THUD6F: Text8Pt;
    THUD8F: Text8Pt;
    THUD7F: Text8Pt;
    THUD9F: Text8Pt;
    THUD10F: Text8Pt;
    procedure A1CLabMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure A1CLabMouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure A1CPanelMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    function A1TPerFConvDate(Sender: TObject; const IDate: string;
      const Date2Pr: Boolean): string;
    function A1TPerFShowPeriod(Sender: TObject; const EPr: Byte): string;
    procedure btnCloseClick(Sender: TObject);
    procedure btnViewLineClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure FormKeyPress(Sender: TObject; var Key: Char);
    procedure FormResize(Sender: TObject);
    procedure PageControlChange(Sender: TObject);
    procedure PopupMenuPopup(Sender: TObject);
    procedure StoreCoordFlgClick(Sender: TObject);
    procedure WMWindowPosChanged(var Msg : TMessage); Message WM_WindowPosChanged;
    procedure ResetCoordinates1Click(Sender: TObject);
  private
    JustCreated,
    InvStored,
    ReCalcTot,
    StoreCoord,
    LastCoord,
    SetDefault,
    fNeedCUpdate,
    BalDone,
    fFrmClosing,
    fDoingClose,
    fRecordLocked,
    CouldIssue,
    GotCoord: Boolean;
    SKeypath,
    MinHeight,
    MinWidth     :  Integer;
    IdLine       :  TfrmWorksOrderEntry;
    IdLineActive :  Boolean;
    BOMId        :  IDetail;
    DocHed       :  DocTypes;
    PagePoint    :  array[0..2] of TPoint;
    StartSize,
    InitSize     :  TPoint;
    DoneUserFieldFormatting : Boolean;

    procedure DisplayDetails(Mode: TwdMode);
    procedure Find_FormCoord;
    procedure Link2Nom;
    procedure SetFieldProperties;
    procedure SetFormProperties(SetList  :  Boolean);
    procedure SetNeedCUpdate(const Value: Boolean);
    procedure ShowRightMenu(X,Y,Mode  :  Integer);
    procedure Store_FormCoord(UpMode  :  Boolean);
    procedure WMCustGetRec(var Msg: TMessage); message WM_CustGetRec;

    property NeedCUpDate :  Boolean Read fNeedCUpDate Write SetNeedCUpdate;
  public
    { Public declarations }
    fForceStore:  Boolean;
    ExLocal    :  TdExLocal;
    ListOffSet :  Integer;
    BtList     :  TWORMList;

    procedure BuildDesign;
    procedure DisplayTrans(const TheTrans: InvRec; const TheCust: CustRec);
    procedure FormDesign;
    function Current_BarPos(PageNo  :  Byte)  :  Integer;
    procedure HidePanels(PageNo    :  Byte);
    procedure HideListColumns(PageNo  :  Integer);
    procedure RefreshList(ShowLines, IgMsg: Boolean);
    procedure FormBuildList(ShowLines  :  Boolean);
    function Current_Page  :  Integer;
    procedure ShowLink(ShowLines: Boolean);
    procedure FormSetOffSet;
    procedure ChangePage(NewPage  :  Integer);
    procedure SetNTxfrFields;
    procedure OutNTxfr;
    procedure OutNTxfrTotals;
    procedure SetFieldFocus;

  end;

implementation

uses
  ETStrU,
  ETMiscU,
  BtrvU2,
  BTSupU2,
  BTKeys1U,
  CmpCtrlU,
  ColCtrlU,
  ComnU2,
  SBSComp,
  InvListU,
  SysU2,
  PWarnU,
  Event1U,
  EntData,
  DrillUtils,
  CustomFieldsIntf,
  TransactionOriginator;

{$R *.DFM}

const
  MainPage  =  0;
  AnalPage  =  1;

//=============================================================================
// TWORMList - Btrieve list
//=============================================================================
function TWORMList.SetCheckKey  :  Str255;
var
  DumStr: Str255;
  TmpLNo: LongInt;
begin
  FillChar(DumStr,Sizeof(DumStr),0);

  with Id do
  begin
    if (UseSet4End) and (CalcEndKey) then  // If a special end key calculation is needed
      TmpLNo := MaxLInt
    else
      TmpLNo := LineNo;

    DumStr := FullIdKey(FolioRef, TmpLNo);
  end;

  Result := DumStr;
end;

//-----------------------------------------------------------------------------

function TWORMList.SetFilter  :  Str255;
begin
  Result := Id.Payment;
end;

//-----------------------------------------------------------------------------

function TWORMList.CheckRowEmph: Byte;
begin
  with Id do
  begin
    if (Stock.StockCode <> StockCode) then
      Global_GetMainRec(StockF, StockCode);

    Result := Ord(Stock.StockType = StkBillCode);

    if (Result = 1) then
      Result := Result + Ord(LineNo = 1);
  end;
end;

//-----------------------------------------------------------------------------

function TWORMList.OutLine(Col  :  Byte)  :  Str255;
var
  Dnum: Double;
begin
  Result := '';
  with Id do
  begin
    case Col of
      0: Result := StockCode;
      1: begin
           if (Stock.StockCode <> StockCode) then
             Global_GetMainRec(StockF, StockCode);
           if (LineNo = 1) then
             Result := Desc
           else
             Result := Stock.Desc[1];
         end;
      2: Result := FormatFloat(GenQtyMask, QtyMul);
      3: Result := FormatFloat(GenQtyMask, WORReqQty(Id));
      4: Result := FormatBFloat(GenQtyMask, QtyPWOff, (QtyPWOff = 0.0));
      5: Result := FormatBFloat(GenQtyMask, QtyDel,(QtyDel = 0.0) and (LineNo <> 1));
      6: begin
           if (LineNo = 1) then
             Result := FormatBFloat(GenQtyMask, BuildQty_OS(Id), (BuildQty_OS(Id) = 0.0))
           else
             Result := FormatBFloat(GenQtyMask, Qty_OS(Id), (Qty_OS(Id) = 0.0));
         end;
      7: Result := FormatBFloat(GenQtyMask, QtyPick, (QtyPick = 0.0));
      8: begin
           if (CtrlBOM.QtyWOff <> 0) or (LineNo = 1) then
             Result := FormatBFloat(GenQtyMask, QtyWOff, (QtyWOff = 0.0))
           else
           begin
             Dnum := FreeStock(Stock);
             if (not Syss.UseWIss4All) then
               Dnum := Dnum + Qty_OS(Id)
             else
               Dnum := Dnum + QtyPick;
             Result := FormatBFloat(GenQtyMask, Dnum, (Qty_OS(Id) = 0.0))
           end;
         end;
      9: Result := FormatFloat(GenUnitMask[BOff], CostPrice);
     10: Result := MLocStk;
     11: Result := Form_Int(NomCode, 0);
     12, 13: begin
               {$IFDEF PF_On}
               if (Syss.UseCCDep) then
                 Result := CCDep[(Col = 12)]
               else
                 Result := '';
               {$ELSE}
               Result:='';
               {$ENDIF}
             end;
    else
      Result := '';
    end; { case Col of...}
  end; { with..}
end;

//-----------------------------------------------------------------------------

//=============================================================================
// TfrmWorksOrder
//=============================================================================

procedure TfrmWorksOrder.DisplayTrans(const TheTrans: InvRec; const TheCust: CustRec);
begin
  // Get static data from database
  ExLocal.LInv  := TheTrans;
  ExLocal.LCust := TheCust;

  // Update Form Caption
  Caption := Trim(EnterpriseData.edCompanyCode) + ', ' + ExLocal.LInv.OurRef;

  // Update form layout for licencing and document type
  BuildDesign;

  // Setup Currencies, Decimals, etc...
  FormDesign;

  // Populate the list
  ReFreshList (True, True);
end;

//-----------------------------------------------------------------------------

procedure  TfrmWorksOrder.SetNeedCUpdate(const Value: Boolean);
begin
  if (not fNeedCUpdate) then
    fNeedCUpdate := Value;
end;

//-----------------------------------------------------------------------------

procedure TfrmWorksOrder.Find_FormCoord;
var
  ThisForm: TForm;
  VisibleRect: TRect;
  GlobComp: TGlobCompRec;
begin
  New(GlobComp,Create(BOn));

  ThisForm := Self;

  with GlobComp^ do
  begin
    GetValues := BOn;
    PrimeKey  := DocCodes[DocHed][1];

    if (GetbtControlCsm(ThisForm)) then
    begin
      StoreCoord := BOff;
      HasCoord   := (HLite = 1);
      LastCoord  := HasCoord;

      if (HasCoord) then
        SetPosition(ThisForm);
    end;

    GetbtControlCsm(PageControl);
    GetbtControlCsm(BtListBox);
    GetbtControlCsm(BtListBtnPanel);

    If GetbtControlCsm(A1YrefF) then
      SetFieldProperties;

    BtList.Find_ListCoord(GlobComp);

  end; { with GlobComp^... }

  Dispose(GlobComp,Destroy);

  { Check that the form is within the current visible range }
  with TForm(Owner) do
    VisibleRect := Rect(0, 0, ClientWidth, ClientHeight);

  if (not PtInRect(VisibleRect, Point(Left,Top))) then
  begin
    Left := 0;
    Top  := 0;
  end;

  StartSize.X := Width;
  StartSize.Y := Height;

end;

//-----------------------------------------------------------------------------

procedure TfrmWorksOrder.Store_FormCoord(UpMode  :  Boolean);
var
  GlobComp: TGlobCompRec;
begin
  New(GlobComp,Create(BOff));

  with GlobComp^ do
  begin
    GetValues := UpMode;
    PrimeKey  := DocCodes[DocHed][1];
    ColOrd    := Ord(StoreCoord);
    HLite     := Ord(LastCoord);

    SaveCoord := StoreCoord;

    if (not LastCoord) then
      HLite := ColOrd;

    StorebtControlCsm(Self);
    StorebtControlCsm(PageControl);
    StorebtControlCsm(BtListBox);
    StorebtControlCsm(BtListBtnPanel);
    StorebtControlCsm(A1YrefF);
    BtList.Store_ListCoord(GlobComp);

  end; { with GlobComp^... }

  Dispose(GlobComp,Destroy);

end;

//-----------------------------------------------------------------------------

function TfrmWorksOrder.Current_Page: Integer;
begin
  Result := pcLivePage(PageControl);
end;

//-----------------------------------------------------------------------------

procedure TfrmWorksOrder.Link2Nom;
var
  FoundStk: Str20;
begin
  with Id do
  begin
    LocLab.Caption := MLocStk;

    if (Syss.UseCCDep) then
    begin
      CCLab.Caption  := CCDep[BOn];
      DepLab.Caption := CCDep[BOff];
    end;

    with ExLocal do
    if (Is_FullStkCode(StockCode)) and (LStock.StockCode <> StockCode) then
    begin
      GetStock(self, StockCode, FoundStk, -1);
      AssignFromGlobal(StockF);
      SendToObjectStkEnq(StockCode, MLocStk, '', -1, -1, 0);
    end;
  end;
end;

//-----------------------------------------------------------------------------

procedure TfrmWorksOrder.WMCustGetRec(var Msg: TMessage);
begin
  with Msg do
  begin
    case WParam of
       { The user double-clicked an entry line. Create and display the Works
         Order Entry form for the current record. }
       0, 169: begin
                 if (WParam = 169) then
                   BtList.GetSelRec(BOff);
                 DisplayDetails(wdCreate);
                 IdLine.Show;
                 // CJS 2011-11-17: ABSEXCH-12037 - OLE Drill-Down UDFields
                 // Added call to update display of header details.
                 ShowLink(False);
               end;

       { The user moved to a different entry line. Update the display, and
         update the Works Order Entry form if it is visible. }
       1: begin
            Link2Nom;
            DisplayDetails(wdUpdate);
            // CJS 2011-11-17: ABSEXCH-12037 - OLE Drill-Down UDFields
            // Added call to update display of header details.
            ShowLink(False);
          end;

       { The user right-clicked on an entry line. Pop up the context menu. }
       2: ShowRightMenu(LParamLo, LParamHi, 1);

      17: begin {* Force reset of form *}
               GotCoord:=BOff;
               SetDefault:=BOn;
               Close;
             end;

      25:  NeedCUpdate:=BOn;

     131: with BtList do
          begin
            if (PageKeys^[0] <> 0) then
            begin
              PageUpDn(0, BOn);
            end;
            { Sometimes a ghost line 1 exists which PageUpDn will reset, so we have another go }
            if (PageKeys^[0] = 0) then
              InitPage;
            if (IdLine <> nil) then
            with ExLocal do
            begin
              LInv := IdLine.ExLocal.LInv;
              OutNTxfrTotals;
              ReCalcTot:=BOn;
            end;
          end;

     175: with PageControl do
            ChangePage(FindNextPage(ActivePage, (LParam=0), BOn).PageIndex);

     176: if (Assigned(BtList)) then
            BtList.SetListFocus;

     { The Works Order Entry form has been closed. Clear the reference to it. }
     200: begin
            IdLine := nil;
            IdLineActive := BOff;
            BtList.SetListFocus;
          end;

    end; { case WParam of... }
  end;
  inherited;
end;

//-----------------------------------------------------------------------------

procedure TfrmWorksOrder.ShowLink(ShowLines: Boolean);
begin
  ExLocal.AssignFromGlobal(InvF);
  ExLocal.LGetRecAddr(InvF);

  with ExLocal,LInv do
  begin
    Caption := DocNames[InvDocHed] + ' Record - ' + Pr_OurRef(LInv);

    {$B-}
    if (CheckRecExsists(FullIdKey(LInv.FolioNum,1), IDetailF, IdFOlioK)) then
      BOMId := Id;
    {$B+}

  end;

  OutNTxfr;

  ReFreshList(ShowLines,Not JustCreated);

  JustCreated := BOff;

end;

//-----------------------------------------------------------------------------

procedure TfrmWorksOrder.FormSetOffSet;
begin
  PagePoint[0].X := Width  - (PageControl.Width);
  PagePoint[0].Y := Height - (PageControl.Height);

  PagePoint[1].X := PageControl.Width  - (BtListBox.Width);
  PagePoint[1].Y := PageControl.Height - (BtListBox.Height);

  PagePoint[2].X := PageControl.Width  - (BtListBtnPanel.Left);
  PagePoint[2].Y := PageControl.Height - (BtListBtnPanel.Height);

  GotCoord := BOn;
end;

//-----------------------------------------------------------------------------

procedure TfrmWorksOrder.BuildDesign;
var
  HideCC: Boolean;
  HideLoc:  Boolean;
begin
  lblStatus.Caption := 'STATUS:'#13'View Only';
  A1YRefF.MaxLength := DocYRef2Len;
  HideCC            := not Syss.UseCCDep;
  A1BldF.Visible    := not Is_StdWOP;
  Label814.Visible  := A1BldF.Visible;
  Label815.Visible  := A1BldF.Visible;

  if (not A1BldF.Visible) then
  begin
    Label818.Caption := 'build';
  end;

  A1IssF.DecPlaces := Syss.NoQtyDec;
  A1BldF.DecPlaces := Syss.NoQtyDec;
  HideLoc          := not Syss.UseMLoc;

  if (HideLoc) then
  begin
    A1LocTxF.Visible := BOff;
    LTxFrLab.Visible := BOff;
    Label810.Visible := BOff;
    LocLab.Visible   := BOff;
  end;

  if (HideCC and HideLoc) then
    CCPanel.Visible := BOff
  else if HideCC then
  begin
    CCTit.Visible  := BOff;
    CCLab.Visible  := BOff;
    DepTit.Visible := BOff;
    DepLab.Visible := BOff;
    Label810.Left  := CCTit.Left;
    LocLab.Left    := CCLab.Left;
  end;

  CostPanel.Visible  := PChkAllowed_In(143);
  IssuePanel.Visible := CostPanel.Visible;

  // CJS 2011-11-17: ABSEXCH-12037 - OLE Drill-Down UDFields
  // Need to only execute this once, otherwise fields go missing and weird drop-down thingie resizes incorrectly
  If (Not DoneUserFieldFormatting) Then
  Begin
    DoneUserFieldFormatting := True;

    // MH 17/10/2011 ABSEXCH-12037: Added additional user defined fields
    EnableUDFs([UDF1L, UDF2L, UDF3L, UDF4L, UDF5L, UDF6L, UDF7L, UDF8L, UDF9L, UDF10L],
               [THUD1F, THUD2F, THUD3F, THUD4F, THUD5F, THUD6F, THUD7F, THUD8F, THUD9F, THUD10F],
               cfWORHeader);

    // Reset original expanded height of weirdo drop-down thingie as this routine is called multiple times - not sure why!
    ResizeUDFParentContainer(NumberOfVisibleUDFs([THUD1F, THUD2F, THUD3F, THUD4F, THUD5F, THUD6F, THUD7F, THUD8F, THUD9F, THUD10F]),
                             2, //UDFs laid out on the UI as 2 columns, 5 rows
                             TransExtForm1);
  End; // If (Not DoneUserFieldFormatting)

{
  UDF1L.Caption := Get_CustmFieldCaption(2,9);
  UDF1L.Visible := not Get_CustmFieldHide(2,9);

  THUD1F.Visible := UDF1L.Visible;

  UDF2L.Caption := Get_CustmFieldCaption(2,10);
  UDF2L.Visible := not Get_CustmFieldHide(2,10);

  THUD2F.Visible := UDF2L.Visible;

  UDF3L.Caption := Get_CustmFieldCaption(2,11);
  UDF3L.Visible := not Get_CustmFieldHide(2,11);

  THUD3F.Visible := UDF3L.Visible;


  UDF4L.Caption := Get_CustmFieldCaption(2,12);
  UDF4L.Visible := not Get_CustmFieldHide(2,12);

  THUD4F.Visible := UDF4L.Visible;

  TransExtform1.ReAssignFocusLast;

  if (not THUD1F.Visible) or (not THUD2F.Visible) or
     (not THUD3F.Visible) or (not THUD4F.Visible) then
  with TransExtForm1 do
  begin
    if ((not THUD1F.Visible) and (not THUD2F.Visible) and
        (not THUD3F.Visible) and (not THUD4F.Visible)) then
      ExpandedHeight := Height;
  end;
}
end;

//-----------------------------------------------------------------------------

procedure TfrmWorksOrder.FormDesign;
begin
  BuildDesign;
end;

procedure TfrmWorksOrder.HidePanels(PageNo    :  Byte);
var
  TmpBo: Boolean;
  n    : Integer;
begin
  with BtList, VisiList do
  begin
    fBarOfSet := Current_BarPos(PageNo);
    case PageNo of
      MainPage: begin
                  for n := 2 to 13 do
                    SetHidePanel(FindxColOrder(n), (n >= 9), (n = 13));
                end;
      AnalPage: begin
                  for n := 2 to 13 do
                    SetHidePanel(FindxColOrder(n),(((n<9) and (n>3)) or (n=2)),BOff);

                  TmpBo := not Syss.UseCCDep;

                  SetHidePanel(FindxColOrder( 9), not PChkAllowed_In(143), BOff);
                  SetHidePanel(FindxColOrder(10), not Syss.UseMLoc, BOff);
                  SetHidePanel(FindxColOrder(12), TmpBo, BOff);
                  SetHidePanel(FindxColOrder(13), TmpBo, BOn);

                end;
    end; { case PageNo... }
  end; { with BtList... }
end;

//-----------------------------------------------------------------------------

function TfrmWorksOrder.Current_BarPos(PageNo: Byte): Integer;
begin
  case PageNo of
    MainPage: Result := BtListBox.HorzScrollBar.Position;
  else
    Result := 0;
  end; { case PageNo... }
end;

//-----------------------------------------------------------------------------

procedure TfrmWorksOrder.RefreshList(ShowLines, IgMsg: Boolean);
var
  KeyStart: Str255;
begin
  KeyStart := FullIdkey(ExLocal.LInv.FolioNum, 1);
  with BtList do
  begin
    CtrlBOM   := BOMId;
    IgnoreMsg := IgMsg;

    StartList(IdetailF, IdFolioK, KeyStart, '', '', 4, (not ShowLines));

    IgnoreMsg:=BOff;
  end;
end;

//-----------------------------------------------------------------------------

procedure TfrmWorksOrder.FormBuildList(ShowLines: Boolean);
var
  StartPanel: TSBSPanel;
  n         : Byte;
begin
  BtList := TWORMList.Create(Self);
  StartPanel := nil;
  try
    with BtList do
    begin
      try
        with VisiList do
        begin
          {00} AddVisiRec(A1CPanel,A1CLab);
          {01} AddVisiRec(A1DPanel,A1DLab);
          {02} AddVisiRec(A1IPanel,A1ILab);
          {03} AddVisiRec(A1OPanel,A1OLab);
          {04} AddVisiRec(A1BPanel,A1BLab);
          {05} AddVisiRec(A1UOPanel,A1UOLab);
          {06} AddVisiRec(A1OSPanel,A1OSLab);
          {07} AddVisiRec(A1BUPanel,A1BULab);
          {08} AddVisiRec(A1IssPanel,A1IssLab);
          {09} AddVisiRec(A1UPanel,A1ULab);
          {10} AddVisiRec(A1LocPanel,A1LocLab);
          {11} AddVisiRec(A1GPanel,A1GLab);
          {12} AddVisiRec(A1CCPanel,A1CCLab);
          {13} AddVisiRec(A1DpPanel,A1DpLab);

          VisiRec := List[0];

          StartPanel := (VisiRec^.PanelObj as TSBSPanel);

          HidePanels(MainPage);

          LabHedPanel := A1HedPanel;

          SetHedPanel(ListOffSet);

        end; { with VisiList... }
      except
        VisiList.Free;
      end;

      Find_FormCoord;

      TabOrder      := -1;
      TabStop       := BOff;
      Visible       := BOff;
      BevelOuter    := bvNone;
      ParentColor   := False;
      Color         := StartPanel.Color;
      MUTotCols     := 13;
      Font          := StartPanel.Font;
      LinkOtherDisp := BOn;
      WM_ListGetRec := WM_CustGetRec;
      Parent        := StartPanel.Parent;
      MessHandle    := Self.Handle;

      for n := 0 to MUTotCols do
      with ColAppear^[n] do
      begin
        AltDefault:=BOn;

        if (n in [2..9]) then
        begin
          DispFormat:=SGFloat;

          case n of
            2..8:  NoDecPlaces := Syss.NoQtyDec;
               9:  NoDecPlaces := Syss.NoCosDec;
          else
            NoDecPlaces := 0;
          end; { case n of... }
        end;
      end;

      ListLocal := @ExLocal;

      ListCreate;

      UseSet4End    := BOn;
      NoUpCaseCheck := BOn;

      Set_Buttons(BtListBtnPanel);

      HighLiteStyle[1] := [fsBold];
      HighLiteStyle[2] := [fsUnderline,fsBold];

    end { with BtList... }

  except
    BtList.Free;
    BtList := nil;
  end;

  FormSetOffSet;
  FormReSize(Self);

end;

//-----------------------------------------------------------------------------

procedure TfrmWorksOrder.OutNTxfrTotals;
begin
  with ExLocal,LInv do
  begin

    CostLab.Caption:=FormatFloat(GenRealMask,TotalCost);
    IssuedLab.Caption:=FormatFloat(GenRealMask,TotalInvoiced);

    Gauge1.Progress:=Round(DivWChk(Round_Up(TotalInvoiced,2),Round_Up(TotalCost,2))*100);
    Gauge2.Progress:=Round(DivWChk(Round_Up(TotalReserved,2),Round_Up(TotalCost,2))*100);

  end; {With..}
end;

//-----------------------------------------------------------------------------

procedure TfrmWorksOrder.SetNTxfrFields;
begin
  with ExLocal, LInv do
  begin
    A1ORefF.Text := Pr_OurRef(LInv);
    A1OpoF.Text  := OpName;

    { CJS - 2013-10-28 - ABSEXCH-14705 - MRD2.6 - Transaction Originator }
    if (Trim(thOriginator) <> '') then
      A1OpoF.Hint := GetOriginatorHint(LInv)
    else
      A1OpoF.Hint := '';

    A1TPerF.InitPeriod(AcPr,AcYr,BOn,BOn);

    A1TDateF.DateValue := TransDate;
    A1CDateF.DateValue := DueDate;

    I1AccF.Text := CustCode;

    if Global_GetMainRec(CustF,CustCode) then
      A1CompF.Text := Cust.Company;

    A1YRefF.Text   := YourRef;
    I1YrRef2F.Text := TransDesc;

    {$IFDEF SOP}
      A1LocTxF.Text := Trim(DelTerms);
    {$ENDIF}

    THUd1F.Text := DocUser1;
    THUd2F.Text := DocUser2;
    THUd3F.Text := DocUser3;
    THUd4F.Text := DocUser4;

    // CJS 17/11/2011 ABSEXCH-12037: Added additional user defined fields
    THUd5F.Text := DocUser5;
    THUd6F.Text := DocUser6;
    THUd7F.Text := DocUser7;
    THUd8F.Text := DocUser8;
    THUd9F.Text := DocUser9;
    THUd10F.Text := DocUser10;
  end; { with ExLocal... }
end;

//-----------------------------------------------------------------------------

procedure TfrmWorksOrder.OutNTxfr;
begin
  OutNTxfrTotals;
  SetNTxfrFields;
end;

//-----------------------------------------------------------------------------

procedure TfrmWorksOrder.SetFieldFocus;
begin
  if I1AccF.CanFocus then
    I1AccF.SetFocus;
end;

//-----------------------------------------------------------------------------

procedure TfrmWorksOrder.ChangePage(NewPage: Integer);
begin
  if (Current_Page <> NewPage) then
  with PageControl do
  begin
    ActivePage := Pages[NewPage];
    PageControlChange(PageControl);
  end; { with PageControl do... }
end;

//-----------------------------------------------------------------------------

procedure TfrmWorksOrder.HideListColumns(PageNo: Integer);
begin
  if (Assigned(BtList)) then
    with BtList, VisiList do
    begin
      HidePanels(PageNo);
      ReAssignCols;
      PageUpDn(0, BOn);
      SetHedPanel(ListOffSet);
    end; { with BtList... }
end;

//-----------------------------------------------------------------------------

procedure TfrmWorksOrder.PageControlChange(Sender: TObject);
var
  NewIndex: Integer;
begin
  if (Sender is TPageControl) then
    with Sender as TPageControl do
    begin
      NewIndex := pcLivePage(Sender);

      HideListColumns(NewIndex);

      BtListBox.Parent         := ActivePage;
      BtListBtnPanel.Parent := ActivePage;
      A1BtmPanel.Parent     := ActivePage;

      MDI_UpdateParentStat;

    end; {With..}
end;

//-----------------------------------------------------------------------------

procedure TfrmWorksOrder.FormCreate(Sender: TObject);
var
  n: Integer;
begin
  fFrmClosing := BOff;
  fDoingClose := BOff;

  ExLocal.Create;

  LastCoord     := BOff;
  ReCalcTot     := BOn;
  NeedCUpdate   := BOff;
  BalDone       := BOff;
  InvStored     := BOff;
  CouldIssue    := BOff;
  JustCreated   := BOn;
  fRecordLocked := BOff;

  Blank(BOMId, sizeof(BOMId));

  SKeypath := 0;

  // CJS 2011-11-17: ABSEXCH-12037 - OLE Drill-Down UDFields
  // Amended height and width to accommodate new fields
  self.ClientHeight := 360;
  self.ClientWidth  := 630;
  InitSize.Y := Self.Height;
  InitSize.X := Self.Width;

  self.Height := InitSize.Y;
  self.Width  := InitSize.X;

  Constraints.MinHeight  := InitSize.Y - 1;
  Constraints.MinWidth   := InitSize.X - 1;

  DoneUserFieldFormatting := False;

  PageControl.ActivePage := AdjustPage;

  with TForm(Owner) do
  begin
    self.Left := 0;
    self.Top  := 0;
  end;

  DocHed := WOR;

  Caption := DocNames[DocHed];

  for n := 0 to Pred(ComponentCount) do
    if (Components[n] is TScrollBox) then
    with TScrollBox(Components[n]) do
    begin
      VertScrollBar.Position:=0;
      HorzScrollBar.Position:=0;
    end;

  ListOffSet := 0;

  FormDesign;
  FormBuildList(BOff);

end;

//-----------------------------------------------------------------------------

procedure TfrmWorksOrder.FormDestroy(Sender: TObject);
begin
  ExLocal.Destroy;
end;

//-----------------------------------------------------------------------------

procedure TfrmWorksOrder.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
var
  n: Integer;
begin
  if (not fFrmClosing) then
  begin
    fFrmClosing := BOn;
    try
      GenCanClose(Self,Sender,CanClose,BOn);
      if (CanClose) then
      begin
        for n := 0 to Pred(ComponentCount) do
        begin
          if (Components[n] is TScrollBox) then
          with TScrollBox(Components[n]) do
          begin
            VertScrollBar.Position := 0;
            HorzScrollBar.Position := 0;
          end;
        end;

        if (NeedCUpdate or SetDefault) then
          Store_FormCoord(not SetDefault);

        SendMessage((Owner as TForm).Handle, WM_CustGetRec, 100, 6);

      end;
    finally
      fFrmClosing := BOff;
    end;
  end
  else
    CanClose := BOff;
end;

//-----------------------------------------------------------------------------

procedure TfrmWorksOrder.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  if (not fDoingClose) then
  begin
    fDoingClose := BOn;

    if (BtList <> nil) then
    begin
      try
        BtList.Destroy;
      finally
        BtList := nil;
      end;
    end;

    Action := caFree;
  end;
end;

//-----------------------------------------------------------------------------

procedure TfrmWorksOrder.FormResize(Sender: TObject);
var
  NewVal      :  Integer;
begin
  if (GotCoord) and (not fFrmClosing) then
  begin
    BtList.LinkOtherDisp := BOff;

    self.HorzScrollBar.Position := 0;
    self.VertScrollBar.Position := 0;

    PageControl.Width := Width - PagePoint[0].X;
    PageControl.Height := Height - PagePoint[0].Y;

    BtListBox.Width  := PageControl.Width  - PagePoint[1].X;
    BtListBox.Height := PageControl.Height - PagePoint[1].Y;

    BtListBtnPanel.Left   := PageControl.Width  - PagePoint[2].X;
    BtListBtnPanel.Height := PageControl.Height - PagePoint[2].Y;

    BtnPanel.Left := PageControl.Width - (BtnPanel.Width + 4);
    
    if (BtList <> nil) then
    begin
      LockWindowUpDate(Handle);

      with BtList, VisiList do
      begin
        VisiRec := List[0];

        With (VisiRec^.PanelObj as TSBSPanel) do
          Height := BtListBtnPanel.Height;

        RefreshAllCols;
      end;

      BtList.ReFresh_Buttons;

      LockWindowUpDate(0);
    end;{Loop..}

    BtList.LinkOtherDisp:=BOn;

    NeedCUpdate:= ((StartSize.X <> Width) or (StartSize.Y <> Height));

  end;
end;

//-----------------------------------------------------------------------------

procedure TfrmWorksOrder.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  GlobFormKeyDown(Sender,Key,Shift,ActiveControl,Handle);

  If (Key=$5A) and (Shift = ([ssAlt,ssCtrl,ssShift])) and (Not ExLocal.LViewOnly) then
  Begin
    Re_SetDoc(ExLocal.LInv);
    OutNtxfr;
    BtList.PageUpDn(0,BOn);
  end;

end;

//-----------------------------------------------------------------------------

procedure TfrmWorksOrder.FormKeyPress(Sender: TObject; var Key: Char);
begin
  GlobFormKeyPress(Sender,Key,ActiveControl,Handle);
end;

//-----------------------------------------------------------------------------

function TfrmWorksOrder.A1TPerFConvDate(Sender: TObject; const IDate: string;
  const Date2Pr: Boolean): string;
begin
  Result := ConvInpPr(IDate, Date2Pr, @ExLocal);
end;

//-----------------------------------------------------------------------------

procedure TfrmWorksOrder.A1CPanelMouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
var
  BarPos: Integer;
  PanRSized: Boolean;
begin
  if (Sender is TSBSPanel) then
    with (Sender as TSBSPanel) do
    begin
      PanRSized := ReSized;
      BarPos    := Current_BarPos(Current_Page);

      if (PanRsized) then
        BtList.ResizeAllCols(BtList.VisiList.FindxHandle(Sender),BarPos);

      BtList.FinishColMove(BarPos+(ListOffSet*Ord(PanRSized)),PanRsized);

      NeedCUpdate := (BtList.VisiList.MovingLab or PanRSized);
    end; { with (Sender as TSBSPanel) do... }
end;

//-----------------------------------------------------------------------------

procedure TfrmWorksOrder.A1CLabMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
var
  ListPoint: TPoint;
begin
  if (Sender is TSBSPanel) then
  with (Sender as TSBSPanel) do
  begin
    if (not ReadyToDrag) and (Button = mbLeft) then
    begin
      if (BtList <> nil) then
        BtList.VisiList.PrimeMove(Sender);
      NeedCUpdate := BOn;
    end
    else if (Button = mbRight) then
    begin
      ListPoint := ClientToScreen(Point(X,Y));
      ShowRightMenu(ListPoint.X,ListPoint.Y,0);
    end;
  end; { with (Sender as TSBSPanel) do... }
end;

//-----------------------------------------------------------------------------

procedure TfrmWorksOrder.A1CLabMouseMove(Sender: TObject; Shift: TShiftState;
  X, Y: Integer);
begin
  if (Sender is TSBSPanel) then
    with (Sender as TSBSPanel) do
    begin
      if (BtList <> nil) then
        BtList.VisiList.MoveLabel(X, Y);
      NeedCUpdate := BtList.VisiList.MovingLab;
    end; { with (Sender as TSBSPanel) do... }
end;

//-----------------------------------------------------------------------------

procedure TfrmWorksOrder.ShowRightMenu(X, Y, Mode: Integer);
begin
  with PopUpMenu do
    PopUp(X, Y);
end;

//-----------------------------------------------------------------------------

procedure TfrmWorksOrder.PopupMenuPopup(Sender: TObject);
begin
  StoreCoordFlg.Checked := StoreCoord;
end;

//-----------------------------------------------------------------------------

function TfrmWorksOrder.A1TPerFShowPeriod(Sender: TObject; const EPr: Byte): string;
begin
  Result := PPr_Pr(EPr);
end;

//-----------------------------------------------------------------------------

procedure TfrmWorksOrder.DisplayDetails(Mode: TwdMode);
begin
  if (Mode = wdCreate) and (IdLine = nil) then
    IdLine := TfrmWorksOrderEntry.Create(Self);

  if (IdLine <> nil) then
  try
    with IdLine do
    begin
      WindowState := wsNormal;
      ShowLink(self.ExLocal.LInv);
      Show;
    end; { with IdLine... }

    IdLineActive := BOn;
  except
   IdLineActive := BOff;
   IdLine.Free;
   IdLine := nil;
  end;
end;

//-----------------------------------------------------------------------------

procedure TfrmWorksOrder.ResetCoordinates1Click(Sender: TObject);
begin
  if ResetCoordinates1.Checked then
  begin
    SetDefault := True;
    StoreCoord := False;
  end
  else
    SetDefault := False;
end;

//-----------------------------------------------------------------------------

procedure TfrmWorksOrder.SetFieldProperties;
var
  n: Integer;
begin
  A1BtmPanel.Color := A1FPanel.Color;
  for n := 0 to Pred(ComponentCount) do
  begin
    if (Components[n] is TMaskEdit) or (Components[n] is TComboBox) or
       (Components[n] is TCurrencyEdit) and (Components[n] <> A1YrefF) then
    with TGlobControl(Components[n]) do
      if (Tag > 0) then
      begin
        Font.Assign(A1YrefF.Font);
        Color := A1YrefF.Color;
      end;
  end; { for n := 0 to Pred(ComponentCount) do... }
end;

//-----------------------------------------------------------------------------

procedure TfrmWorksOrder.SetFormProperties(SetList  :  Boolean);
const
  PropTit: array[BOff..BOn] of Str5 = ('Form', 'List');
var
  TmpPanel     :  array[1..3] of TPanel;
  n            :  Byte;
  ResetDefaults: Boolean;
  BeenChange   :  Boolean;
  ColourCtrl   :  TCtrlColor;
begin
  ResetDefaults := BOff;

  for n := 1 to 3 do
    TmpPanel[n] := TPanel.Create(Self);

  try
    if (SetList) then
    begin
      with BtList.VisiList do
      begin
        VisiRec:=List[0];

        TmpPanel[1].Font  := (VisiRec^.PanelObj as TSBSPanel).Font;
        TmpPanel[1].Color := (VisiRec^.PanelObj as TSBSPanel).Color;

        TmpPanel[2].Font  := (VisiRec^.LabelObj as TSBSPanel).Font;
        TmpPanel[2].Color := (VisiRec^.LabelObj as TSBSPanel).Color;

        TmpPanel[3].Color := BtList.ColAppear^[0].HBKColor;
      end; { with BtList.VisiList do... }
      TmpPanel[3].Font.Assign(TmpPanel[1].Font);
      TmpPanel[3].Font.Color := BtList.ColAppear^[0].HTextColor;
    end
    else
    begin
      TmpPanel[1].Font  := A1YrefF.Font;
      TmpPanel[1].Color := A1YrefF.Color;
      TmpPanel[2].Font  := A1FPanel.Font;
      TmpPanel[2].Color := A1FPanel.Color;
    end;

    ColourCtrl:=TCtrlColor.Create(Self);

    try
      with ColourCtrl do
      begin
        SetProperties(TmpPanel[1], TmpPanel[2], TmpPanel[3], Ord(SetList),
                      self.Caption + ' ' + PropTit[SetList] + ' Properties',
                      BeenChange, ResetDefaults);

        NeedCUpdate := (BeenChange or ResetDefaults);

        if (BeenChange) and (not ResetDefaults) then
        begin
          if (SetList) then
          begin
            for n:=1 to 3 do
              with TmpPanel[n] do
                case n of
                  1, 2: BtList.ReColorCol(Font,Color,(n=2));
                  3   : BtList.ReColorBar(Font,Color);
                end; { case n of... }

            BtList.VisiList.LabHedPanel.Color:=TmpPanel[2].Color;
          end
          else
          Begin
            A1FPanel.Font.Assign(TmpPanel[2].Font);
            A1FPanel.Color:=TmpPanel[2].Color;

            A1YrefF.Font.Assign(TmpPanel[1].Font);
            A1YrefF.Color:=TmpPanel[1].Color;

            SetFieldProperties;
          end;
        end;

      end;

    finally

      ColourCtrl.Free;

    end;

  Finally

    For n:=1 to 3 do
      TmpPanel[n].Free;

  end;

  If (ResetDefaults) then
  Begin
    SetDefault:=BOn;
    Close;
  end;

end;

//-----------------------------------------------------------------------------

procedure TfrmWorksOrder.StoreCoordFlgClick(Sender: TObject);
begin
  if StoreCoordFlg.Checked then
  begin
    SetDefault := False;
    StoreCoord := True;
    ResetCoordinates1.Checked := False;
  end;
end;

//-----------------------------------------------------------------------------

procedure TfrmWorksOrder.btnCloseClick(Sender: TObject);
begin
  Close;
end;

//-----------------------------------------------------------------------------

procedure TfrmWorksOrder.btnViewLineClick(Sender: TObject);
begin
  DisplayDetails(wdCreate);
end;

//-----------------------------------------------------------------------------

procedure TfrmWorksOrder.WMWindowPosChanged(var Msg: TMessage);
var
  TopWindow : TWinControl;
begin
  // Do standard message processing
  inherited;
  // HM 22/10/03: Added Visible check as it hangs under win 98 otherwise
  if self.Visible then
  begin
    // Check to see if the TopMost window is a Drill-Down window
    TopWindow := FindControl(PWindowPos(Msg.LParam).hwndInsertAfter);
    if not Assigned(TopWindow) then
      // Restore TopMost back to window
      SetWindowPos(Handle, HWND_TOPMOST, 0, 0, 0, 0, SWP_NOSIZE or SWP_NOMOVE or SWP_NOACTIVATE);
  end; { if self.Visible... }
end;

end.
