unit frmTimeSheetU;

{$I DEFOVR.Inc}

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ExtCtrls, SBSPanel, TEditVal, BorBtns, Mask, ComCtrls,
  GlobVar,
  VarConst,
  frmTimeSheetEntryU,
  ExWrap1U,
  BTSupU1,
  SupListU,
  SBSComp2,
  Menus;

type
  // Extended Btrieve List
  TSheetMList = class(TGenList)
    function OutLine(Col: Byte): Str255; override;
    function SetCheckKey: Str255; override;
    function SetFilter: Str255; override;
  end;

  // Timesheet Details mode (for displaying the Time Sheet Entry Form).
  TtdMode = (tdCreate, tdUpdate);

  TfrmTimeSheet = class(TForm)
    PageControl: TPageControl;
    RecepPage: TTabSheet;
    BtListBox: TScrollBox;
    N1HedPanel: TSBSPanel;
    N1DLab: TSBSPanel;
    N1NomLab: TSBSPanel;
    N1CrLab: TSBSPanel;
    N1DrLab: TSBSPanel;
    N1TCLab: TSBSPanel;
    N1CCLab: TSBSPanel;
    N1DepLab: TSBSPanel;
    N1DPanel: TSBSPanel;
    N1DrPanel: TSBSPanel;
    N1NomPanel: TSBSPanel;
    N1CrPanel: TSBSPanel;
    N1CCPanel: TSBSPanel;
    N1DepPanel: TSBSPanel;
    PopupMenu: TPopupMenu;
    PropFlg: TMenuItem;
    N1: TMenuItem;
    StoreCoordFlg: TMenuItem;
    N1BtmPanel: TSBSPanel;
    SBSPanel5: TSBSPanel;
    DrReqdTit: Label8;
    PayDescF: Label8;
    BtListBtnPanel: TSBSPanel;
    SBSPanel1: TSBSPanel;
    Label83: Label8;
    CrReqdLab: Label8;
    N1APanel: TSBSPanel;
    N1ALab: TSBSPanel;
    N1TCPanel: TSBSPanel;
    SBSPanel2: TSBSPanel;
    Label86: Label8;
    DrReqdLab: Label8;
    BtnPanel: TSBSPanel;
    lblStatus: Label8;
    I1BSBox: TScrollBox;
    btnViewLine: TButton;
    btnClose: TButton;
    N1FPanel: TSBSPanel;
    Label817: Label8;
    Label84: Label8;
    Label81: Label8;
    Label82: Label8;
    N1OrefF: Text8Pt;
    N1OpoF: Text8Pt;
    N1TDateF: TEditDate;
    EmpAc: Text8Pt;
    N1TSWkF: TCurrencyEdit;
    TransExtForm1: TSBSExtendedForm;
    UDF1L: Label8;
    UDF3L: Label8;
    UDF2L: Label8;
    UDF4L: Label8;
    Label87: Label8;
    Label88: Label8;
    THUD1F: Text8Pt;
    THUD3F: Text8Pt;
    THUD4F: Text8Pt;
    THUD2F: Text8Pt;
    N1YRefF: Text8Pt;
    N1TPerF: TEditPeriod;
    N2: TMenuItem;
    ViewTransaction1: TMenuItem;
    ResetCoordinates1: TMenuItem;
    UDF5L: Label8;
    THUD5F: Text8Pt;
    UDF6L: Label8;
    THUD6F: Text8Pt;
    THUD8F: Text8Pt;
    UDF8L: Label8;
    THUD7F: Text8Pt;
    UDF7L: Label8;
    UDF9L: Label8;
    THUD9F: Text8Pt;
    UDF10L: Label8;
    THUD10F: Text8Pt;
    procedure btnCloseClick(Sender: TObject);
    procedure btnViewLineClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure FormKeyPress(Sender: TObject; var Key: Char);
    procedure FormResize(Sender: TObject);
    procedure N1DLabMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure N1DLabMouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure N1DPanelMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    function N1TPerFConvDate(Sender: TObject; const IDate: string;
      const Date2Pr: Boolean): string;
    function N1TPerFShowPeriod(Sender: TObject; const EPr: Byte): string;
    procedure PopupMenuPopup(Sender: TObject);
    procedure StoreCoordFlgClick(Sender: TObject);
    procedure WMCustGetRec(var Msg: TMessage); message WM_CustGetRec;
    procedure WMWindowPosChanged(var Msg : TMessage); Message WM_WindowPosChanged;
    procedure ViewTransaction1Click(Sender: TObject);
    procedure ResetCoordinates1Click(Sender: TObject);
  private
    JustCreated,
    InvStored,
    StopPageChange,
    fNeedCUpdate,
    fFrmClosing,
    LastCoord,
    SetDefault,
    GotCoord,
    fRecordLocked: Boolean;
    SKeypath: Integer;
    DetailFrm: TfrmTimeSheetEntry;
    DetailFrmActive:  Boolean;
    DocHed:  DocTypes;
    PagePoint:  Array[0..2] of TPoint;
    StartSize,
    InitSize:  TPoint;
    DoneUserFieldFormatting : Boolean;

    procedure DisplayDetails(Mode: TtdMode);
    procedure FindFormCoord;
    procedure Link2Nom;
    procedure OutNTxfrTotals;
    procedure SetFieldProperties;
    procedure SetFormProperties(SetList  :  Boolean);
    procedure SetNeedCUpdate(const Value: Boolean);
    procedure ShowRightMenu(X,Y,Mode  :  Integer);
    procedure StoreFormCoord(UpMode  :  Boolean);

  protected
    property NeedCUpDate: Boolean read fNeedCUpDate write SetNeedCUpdate;

  public
    ExLocal   :  TdExLocal;
    ListOffSet:  Integer;
    BtList    :  TSheetMList;

    procedure DisplayTrans(const TheTrans: InvRec; const TheCust: CustRec);
    procedure BuildDesign;
    procedure FormDesign;
    procedure HidePanels;
    procedure RefreshList(ShowLines, IgMsg: Boolean);
    procedure FormBuildList(ShowLines  :  Boolean);
    procedure ShowLink(ShowLines: Boolean);
    procedure FormSetOffset;
    procedure SetNTxfrFields;
    procedure OutNTxfr;
  end;

implementation

uses
  ETStrU,
  BtrvU2,
  BTSupU2,
  BTKeys1U,
  CmpCtrlU,
  ColCtrlU,
  SBSComp,
  ComnU2,
  InvListU,
  SysU2,
  JobSup1U,
  Event1U,
  EntData,
  DrillUtils,
  CustomFieldsIntf,
  TransactionOriginator
;

{$R *.DFM}

//=============================================================================
// TSheetMList
//=============================================================================

function TSheetMList.OutLine(Col: Byte): Str255;
var
  Dnum: Double;
begin
  with Id do
  begin
    case Col of
      0  :  Result := JobCode;
      1  :  Result := StockCode;
      2  :  Result := AnalCode;
      3,4:  begin
             if (Syss.UseCCDep) then
               Result := CCDep[(Col = 3)]
             else
               Result := '';
           end;
      5  :  Result := FormatBFloat(GenQtyMask, Qty, BOff);
      6  :  Result := FormatCurFloat(GenUnitMask[BOff], NetValue, BOff, Currency);
      7  :  begin
             Dnum   := DetLTotal(Id, BOn, BOff, 0.0);
             Result := FormatCurFloat(GenRealMask, Dnum, BOff, Currency);
           end;
    else
      Result := '';
    end; { case Col of... }
  end; { with Id do... }
end;

//-----------------------------------------------------------------------------

function TSheetMList.SetCheckKey: Str255;
begin
  FillChar(Result, Sizeof(Result), 0);
  Result := FullIdKey(Id.FolioRef, Id.LineNo);
end;

//-----------------------------------------------------------------------------

function TSheetMList.SetFilter  :  Str255;
begin
  Result := Id.Payment;
end;

//=============================================================================
// TfrmTimeSheet
//=============================================================================

procedure TfrmTimeSheet.btnCloseClick(Sender: TObject);
begin
  Close;
end;

//-----------------------------------------------------------------------------

procedure TfrmTimeSheet.btnViewLineClick(Sender: TObject);
begin
  DisplayDetails(tdCreate);
end;

//-----------------------------------------------------------------------------

procedure TfrmTimeSheet.BuildDesign;
begin
  lblStatus.Caption := 'STATUS:'#13'View Only';

  // Need to only execute this once, otherwise fields go missing and weird drop-down thingie resizes incorrectly
  If (Not DoneUserFieldFormatting) Then
  Begin
    DoneUserFieldFormatting := True;

    // MH 17/10/2011 ABSEXCH-12037: Added additional user defined fields
    EnableUDFs([UDF1L, UDF2L, UDF3L, UDF4L, UDF5L, UDF6L, UDF7L, UDF8L, UDF9L, UDF10L],
               [THUD1F, THUD2F, THUD3F, THUD4F, THUD5F, THUD6F, THUD7F, THUD8F, THUD9F, THUD10F],
               cfTSHHeader);

    // Reset original expanded height of weirdo drop-down thingie as this routine is called multiple times - not sure why!
    ResizeUDFParentContainer(NumberOfVisibleUDFs([THUD1F, THUD2F, THUD3F, THUD4F, THUD5F, THUD6F, THUD7F, THUD8F, THUD9F, THUD10F]),
                             2, //UDFs laid out on the UI as 2 columns, 5 rows
                             TransExtForm1);
  End; // If (Not DoneUserFieldFormatting)
  (*
  UDF1L.Caption := Get_CustmFieldCaption(2,17);
  UDF1L.Visible := not Get_CustmFieldHide(2,17);

  THUD1F.Visible := UDF1L.Visible;

  UDF2L.Caption := Get_CustmFieldCaption(2,18);
  UDF2L.Visible := not Get_CustmFieldHide(2,18);

  THUD2F.Visible := UDF2L.Visible;

  UDF3L.Caption := Get_CustmFieldCaption(2,19);
  UDF3L.Visible := not Get_CustmFieldHide(2,19);

  THUD3F.Visible := UDF3L.Visible;

  UDF4L.Caption := Get_CustmFieldCaption(2,20);
  UDF4L.Visible := not Get_CustmFieldHide(2,20);

  THUD4F.Visible := UDF4L.Visible;

  TransExtform1.ReAssignFocusLast;

  if (not THUD1F.Visible) or (not THUD2F.Visible) or (not THUD3F.Visible) or (not THUD4F.Visible) then
  with TransExtForm1 do
  begin
    If ((not THUD1F.Visible) and (not THUD2F.Visible) and (not THUD3F.Visible) and (not THUD4F.Visible)) then
      ExpandedHeight := Height;
  end;
  *)
end;

//-----------------------------------------------------------------------------

procedure TfrmTimeSheet.DisplayDetails(Mode: TtdMode);
begin
  if (DetailFrm = nil) and (Mode = tdCreate) then
    DetailFrm := TfrmTimeSheetEntry.Create(Self);

  if (DetailFrm <> nil) then
  try
    with DetailFrm do
    begin
      WindowState := wsNormal;

      ShowLink(self.ExLocal.LInv, self.ExLocal.LJobMisc^);
    end;
    DetailFrmActive := BOn;
  except
    DetailFrmActive := BOff;
    DetailFrm.Free;
    DetailFrm := nil;
  end;
end;

//-----------------------------------------------------------------------------

procedure TfrmTimeSheet.DisplayTrans(const TheTrans: InvRec; const TheCust: CustRec);
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

procedure TfrmTimeSheet.FindFormCoord;
var
  ThisForm: TForm;
  VisibleRect: TRect;
  GlobComp: TGlobCompRec;
begin
  ThisForm := self;

  New(GlobComp,Create(BOn));
  with GlobComp^ do
  begin
    GetValues := BOn;
    PrimeKey  := DocCodes[DocHed][1];

    if (GetbtControlCsm(ThisForm)) then
    begin
      StoreCoordFlg.Checked := BOff;
      HasCoord   := (HLite = 1);
      LastCoord  := HasCoord;

      if (HasCoord) then // Get position, as would not have been set initially
        SetPosition(ThisForm);
    end;

    GetbtControlCsm(PageControl);
    GetbtControlCsm(BtListBox);
    GetbtControlCsm(BtListBtnPanel);

    if GetbtControlCsm(N1YrefF) then
      SetFieldProperties;

    BtList.Find_ListCoord(GlobComp);

  end; { with GlobComp^ do... }

  Dispose(GlobComp, Destroy);

  { Check form is within current visible range }
  with TForm(Owner) do
    VisibleRect := Rect(0, 0, ClientWidth, ClientHeight);

  if (not PtInRect(VisibleRect, Point(Left, Top))) then
  begin
    Left := 0;
    Top  := 0;
  end;

  StartSize.X := Width;
  StartSize.Y := Height;
end;

//-----------------------------------------------------------------------------

procedure TfrmTimeSheet.FormBuildList(ShowLines  :  Boolean);
var
  StartPanel: TSBSPanel;
  n         : Byte;
begin
  BtList     := TSheetMList.Create(Self);
  try
    with BtList do
    begin
      try
        with VisiList do
        begin
          AddVisiRec(N1DPanel,N1DLab);
          AddVisiRec(N1NomPanel,N1NomLab);
          AddVisiRec(N1APanel,N1ALab);
          AddVisiRec(N1CCPanel,N1CCLab);
          AddVisiRec(N1DepPanel,N1DepLab);
          AddVisiRec(N1DrPanel,N1DrLab);
          AddVisiRec(N1TCPanel,N1TCLab);
          AddVisiRec(N1CrPanel,N1CrLab);

          VisiRec    := List[0];
          StartPanel := (VisiRec^.PanelObj as TSBSPanel);

          HidePanels;

          LabHedPanel := N1HedPanel;
          SetHedPanel(ListOffSet);
        end;
      except
        VisiList.Free;
        raise;
      end;

      FindFormCoord;

      TabOrder      := -1;
      TabStop       := BOff;
      Visible       := BOff;
      BevelOuter    := bvNone;
      ParentColor   := False;
      Color         := StartPanel.Color;
      MUTotCols     := 7;
      Font          := StartPanel.Font;
      LinkOtherDisp := BOn;
      WM_ListGetRec := WM_CustGetRec;
      Parent        := StartPanel.Parent;
      MessHandle    := self.Handle;

      for n := 0 to MUTotCols do
      with ColAppear^[n] do
      begin
        AltDefault := BOn;
        DispFormat := SGText;
        if (n in [5..7]) then
        begin
          DispFormat := SGFloat;
          case n of
            5: NoDecPlaces := Syss.NoQtyDec;
            6: NoDecPlaces := Syss.NoCOSDec;
          else
            NoDecPlaces := 2;
          end;
        end;
      end;

      ListLocal := @ExLocal;

      ListCreate;

      NoUpCaseCheck := BOn;

      Set_Buttons(BtListBtnPanel);
      ReFreshList(ShowLines,BOff);

    end; { with BtList do... }
  except
    BtList.Free;
    BtList := nil;
  end;

  FormSetOffset;
  FormReSize(Self);
end;

//-----------------------------------------------------------------------------

procedure TfrmTimeSheet.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  if (DetailFrm <> nil) then
  begin
    FreeAndNil(DetailFrm);
    DetailFrmActive := BOff;
  end;
  Action := caFree;
end;

//-----------------------------------------------------------------------------

procedure TfrmTimeSheet.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
var
  n: Integer;
begin
  if (not fFrmClosing) then
  begin
    fFrmClosing := BOn;
    try
      GenCanClose(Self,Sender,CanClose,BOn);

      if (CanClose) then
        CanClose := GenCheck_InPrint;

      if (CanClose) then
      begin
        for n := 0 to Pred(ComponentCount) do
        begin
          if (Components[n] is TScrollBox) then
          begin
            with TScrollBox(Components[n]) do
            begin
              VertScrollBar.Position := 0;
              HorzScrollBar.Position := 0;
            end;
          end;
        end;
        if (NeedCUpdate or StoreCoordFlg.Checked or SetDefault) then
          StoreFormCoord(not SetDefault);

        SendMessage((Owner as TForm).Handle, WM_CustGetRec, 100, 5);
      end;
    finally
      fFrmClosing := BOff;
    end;
  end
  else
    CanClose := BOff;
end;

//-----------------------------------------------------------------------------

procedure TfrmTimeSheet.FormCreate(Sender: TObject);
var
  n: Integer;
begin
  ExLocal.Create;

  fFrmClosing    := BOff;
  LastCoord      := BOff;
  Visible        := BOff;
  InvStored      := BOff;
  JustCreated    := BOn;
  NeedCUpdate    := BOff;
  StopPageChange := BOff;
  fRecordLocked  := BOff;
  SKeypath       := 0;

  self.ClientHeight := 338;
  self.ClientWidth  := 629;
  InitSize.Y := Self.Height;
  InitSize.X := Self.Width;

  DoneUserFieldFormatting := False;

  Constraints.MinHeight  := InitSize.Y - 1;

  Constraints.MaxWidth   := InitSize.X;
  Constraints.MinWidth   := 445;

  with TForm(Owner) do
  begin
    self.Left := 0;
    self.Top  := 0;
  end;

  for n := 0 to Pred(ComponentCount) do
    if (Components[n] is TScrollBox) then
    with TScrollBox(Components[n]) do
    begin
      VertScrollBar.Position := 0;
      HorzScrollBar.Position := 0;
    end;

  ListOffSet := 0;

  FormDesign;
  FormBuildList(BOff);

end;

//-----------------------------------------------------------------------------

procedure TfrmTimeSheet.FormDesign;
begin
  BuildDesign;
end;

//-----------------------------------------------------------------------------

procedure TfrmTimeSheet.FormDestroy(Sender: TObject);
begin
  ExLocal.Destroy;
  if (BtList <> nil) then
  begin
    try
      BtList.Destroy;
    finally
      BtList := nil;
    end;
  end;
end;

//-----------------------------------------------------------------------------

procedure TfrmTimeSheet.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  GlobFormKeyDown(Sender, Key, Shift, ActiveControl, Handle);
end;

//-----------------------------------------------------------------------------

procedure TfrmTimeSheet.FormKeyPress(Sender: TObject; var Key: Char);
begin
  GlobFormKeyPress(Sender, Key, ActiveControl, Handle);
end;

//-----------------------------------------------------------------------------

procedure TfrmTimeSheet.FormResize(Sender: TObject);
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

procedure TfrmTimeSheet.FormSetOffset;
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

procedure TfrmTimeSheet.HidePanels;
var
  TmpBo: Boolean;
begin
  with BtList, VisiList do
  begin
    fBarOfSet := BtListBox.HorzScrollBar.Position;

    TmpBo := not Syss.UseCCDep;
    SetHidePanel(3, TmpBo, BOff);
    SetHidePanel(4, TmpBo, BOn);
  end;
end;

//-----------------------------------------------------------------------------

procedure TfrmTimeSheet.Link2Nom;
begin
  with Id do
    PayDescF.Caption := Get_StdPRDesc(StockCode, JCtrlF, JCK, -1);
end;

//-----------------------------------------------------------------------------

procedure TfrmTimeSheet.N1DLabMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
var
  ListPoint: TPoint;
begin
  if (Sender is TSBSPanel) then
  begin
    with (Sender as TSBSPanel) do
    begin
      if (not ReadyToDrag) and (Button = mbLeft) then
      begin
        if (BtList <> nil) then
          BtList.VisiList.PrimeMove(Sender);

        NeedCUpdate:=BOn;
      end
      else if (Button = mbRight) then
      begin
        ListPoint := ClientToScreen(Point(X, Y));

        ShowRightMenu(ListPoint.X, ListPoint.Y, 0);
      end;
    end; { with (Sender as TSBSPanel) do... }
  end; { if (Sender is TSBSPanel) then... }
end;

//-----------------------------------------------------------------------------

procedure TfrmTimeSheet.N1DLabMouseMove(Sender: TObject; Shift: TShiftState;
  X, Y: Integer);
begin
  if (Sender is TSBSPanel) then
  begin
    with (Sender as TSBSPanel) do
    begin
      If (BtList <> nil) then
        BtList.VisiList.MoveLabel(X, Y);

      NeedCUpdate := BtList.VisiList.MovingLab;
    end; { with (Sender as TSBSPanel) do... }
  end; { if (Sender is TSBSPanel) then... }
end;

//-----------------------------------------------------------------------------

procedure TfrmTimeSheet.N1DPanelMouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
var
  BarPos: Integer;
  PanRSized: Boolean;
begin
  if (Sender is TSBSPanel) then
  begin
    with (Sender as TSBSPanel) do
    begin
      PanRSized := ReSized;
      BarPos    := BtListBox.HorzScrollBar.Position;;
      if (PanRsized) then
        BtList.ResizeAllCols(BtList.VisiList.FindxHandle(Sender), BarPos);

      BtList.FinishColMove(BarPos + (ListOffset * Ord(PanRSized)), PanRsized);

      NeedCUpdate := (BtList.VisiList.MovingLab or PanRSized);
    end; { with Sender as TSBSPanel) do... }
  end; { if (Sender is TSBSPanel) then... }
end;

//-----------------------------------------------------------------------------

function TfrmTimeSheet.N1TPerFConvDate(Sender: TObject; const IDate: string;
  const Date2Pr: Boolean): string;
begin
  Result := ConvInpPr(IDate, Date2Pr, @ExLocal);
end;

//-----------------------------------------------------------------------------

function TfrmTimeSheet.N1TPerFShowPeriod(Sender: TObject; const EPr: Byte): string;
begin
  Result := PPr_Pr(EPr);
end;

//-----------------------------------------------------------------------------

procedure TfrmTimeSheet.OutNTxfr;
begin
  with ExLocal,LInv do
  begin
    SetNTxfrFields;
    OutNTxfrTotals;
  end; { With ExLocal... }
end;

//-----------------------------------------------------------------------------

procedure TfrmTimeSheet.OutNTxfrTotals;
begin
  with ExLocal,LInv do
  begin
    DrReqdLab.Caption := FormatFloat(GenQtyMask, TotalInvoiced);
    CrReqdLab.Caption := FormatCurFloat(GenRealMask, InvNetVal, BOff, Currency);
  end; { With ExLocal... }
end;

//-----------------------------------------------------------------------------

procedure TfrmTimeSheet.PopupMenuPopup(Sender: TObject);
begin

end;

//-----------------------------------------------------------------------------

procedure TfrmTimeSheet.RefreshList(ShowLines, IgMsg: Boolean);
var
  KeyStart: Str255;
begin
  KeyStart := FullIdkey(ExLocal.LInv.FolioNum, 0);
  with BtList do
  begin
    IgnoreMsg := IgMsg;

    StartList(IdetailF, IdFolioK, KeyStart, '', '', 4, (not ShowLines));

    IgnoreMsg := BOff;
  end;
end;

//-----------------------------------------------------------------------------

procedure TfrmTimeSheet.ResetCoordinates1Click(Sender: TObject);
begin
  if (ResetCoordinates1.Checked) then
  begin
    StoreCoordFlg.Checked := False;
    SetDefault := True;
  end;
end;

//-----------------------------------------------------------------------------

procedure TfrmTimeSheet.SetFieldProperties;
var
  n: Integer;
Begin
  N1BtmPanel.Color := N1FPanel.Color;

  for n := 0 to Pred(ComponentCount) do
  begin
    if (Components[n] is TMaskEdit) or (Components[n] is TComboBox) or
       (Components[n] is TCurrencyEdit) and (Components[n] <> N1YrefF) then
    with TGlobControl(Components[n]) do
    begin
      if (Tag > 0) then
      begin
        Font.Assign(N1YrefF.Font);
        Color := N1YrefF.Color;
      end;
    end; { with TGlobControl... }

    if (Components[n] is TBorCheck) then
    with (Components[n] as TBorCheck) do
    begin
      Color := N1FPanel.Color;
    end; { with (Components[n]... }

  end; { for n := 0 to Pred(ComponentCount) do... }
end;

//-----------------------------------------------------------------------------

procedure TfrmTimeSheet.SetFormProperties(SetList: Boolean);
const
  PropTit:  Array[BOff..BOn] of Str5 = ('Form', 'List');
var
  TmpPanel    :  Array[1..3] of TPanel;
  n           :  Byte;
  ResetDefaults,
  BeenChange  :  Boolean;
  ColourCtrl  :  TCtrlColor;
Begin
  ResetDefaults := BOff;

  for n := 1 to 3 do
    TmpPanel[n] := TPanel.Create(Self);

  try
    if (SetList) then
    begin
      with BtList.VisiList do
      begin
        VisiRec := List[0];

        TmpPanel[1].Font  := (VisiRec^.PanelObj as TSBSPanel).Font;
        TmpPanel[1].Color := (VisiRec^.PanelObj as TSBSPanel).Color;

        TmpPanel[2].Font  := (VisiRec^.LabelObj as TSBSPanel).Font;
        TmpPanel[2].Color := (VisiRec^.LabelObj as TSBSPanel).Color;

        TmpPanel[3].Color := BtList.ColAppear^[0].HBKColor;
      end;

      TmpPanel[3].Font.Assign(TmpPanel[1].Font);

      TmpPanel[3].Font.Color := BtList.ColAppear^[0].HTextColor;
    end
    else
    Begin
      TmpPanel[1].Font  := N1YrefF.Font;
      TmpPanel[1].Color := N1YrefF.Color;

      TmpPanel[2].Font  := N1FPanel.Font;
      TmpPanel[2].Color := N1FPanel.Color;
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
            for n := 1 to 3 do
              with TmpPanel[n] do
                case n of
                  1,2: BtList.ReColorCol(Font,Color, (n = 2));
                  3  : BtList.ReColorBar(Font,Color);
                end;
            BtList.VisiList.LabHedPanel.Color := TmpPanel[2].Color;
          end
          else
          begin
            N1FPanel.Font.Assign(TmpPanel[2].Font);
            N1FPanel.Color := TmpPanel[2].Color;

            N1YrefF.Font.Assign(TmpPanel[1].Font);
            N1YrefF.Color := TmpPanel[1].Color;

            SetFieldProperties;
          end; { if (SetList)... }
        end; { if (BeenChange)... }
      end; { with ColourCtrl do... }

    finally
      ColourCtrl.Free;
    end;

  finally
    for n := 1 to 3 do
      TmpPanel[n].Free;
  end;

  if (ResetDefaults) then
  begin
    SetDefault := BOn;
    Close;
  end;

end;

//-----------------------------------------------------------------------------

procedure TfrmTimeSheet.SetNeedCUpdate(const Value: Boolean);
begin
  { Once the position or size of the form or the Btrieve list has been changed,
    do not allow the NeedCUpdate property to revert to False. }
  if (not fNeedCUpdate) then
    fNeedCUpdate := Value;
end;

//-----------------------------------------------------------------------------

procedure TfrmTimeSheet.SetNTxfrFields;
var
  FoundCode: Str20;
begin
  with ExLocal,LInv do
  begin
    N1ORefF.Text := Pr_OurRef(LInv);
    N1OpoF.Text  := OpName;

    { CJS - 2013-10-28 - ABSEXCH-14705 - MRD2.6 - Transaction Originator }
    if (Trim(thOriginator) <> '') then
      N1OpoF.Hint := GetOriginatorHint(LInv)
    else
      N1OpoF.Hint := '';

    N1TPerF.InitPeriod(AcPr, AcYr, BOn, BOn);

    N1TDateF.DateValue := TransDate;
    N1YRefF.Text       := TransDesc;
    N1TSWkF.Value      := DiscDays;
    EmpAc.Text         := BatchLink;

    if (JobMisc^.EmplRec.EmpCode <> BatchLink) then
      GetJobMisc(self, BatchLink, FoundCode, 3, -1);

    AssignFromGlobal(JMiscF);

    THUd1F.Text := DocUser1;
    THUd2F.Text := DocUser2;
    THUd3F.Text := DocUser3;
    THUd4F.Text := DocUser4;

    // MH 17/10/2011 ABSEXCH-12037: Added additional user defined fields
    THUd5F.Text := DocUser5;
    THUd6F.Text := DocUser6;
    THUd7F.Text := DocUser7;
    THUd8F.Text := DocUser8;
    THUd9F.Text := DocUser9;
    THUd10F.Text := DocUser10;
  end; {With ExLocal...}
end;

//-----------------------------------------------------------------------------

procedure TfrmTimeSheet.ShowLink(ShowLines:  Boolean);
begin
  ExLocal.AssignFromGlobal(InvF);
  ExLocal.LGetRecAddr(InvF);

  with ExLocal do
  Caption := DocNames[LInv.InvDocHed] + ' Record - ' + Pr_OurRef(LInv);

  OutNTxfr;

  ReFreshList(ShowLines, not JustCreated);

  JustCreated := BOff;
end;

//-----------------------------------------------------------------------------

procedure TfrmTimeSheet.ShowRightMenu(X, Y, Mode: Integer);
begin
  with PopUpMenu do
    PopUp(X, Y);
end;

//-----------------------------------------------------------------------------

procedure TfrmTimeSheet.StoreCoordFlgClick(Sender: TObject);
begin
  if (StoreCoordFlg.Checked) then
    ResetCoordinates1.Checked := False;
  NeedCUpdate := BOn;
end;

//-----------------------------------------------------------------------------

procedure TfrmTimeSheet.StoreFormCoord(UpMode: Boolean);
var
  GlobComp:  TGlobCompRec;
begin
  New(GlobComp, Create(BOff));
  with GlobComp^ do
  begin
    GetValues := UpMode;
    PrimeKey  := DocCodes[DocHed][1];
    ColOrd    := Ord(StoreCoordFlg.Checked);
    HLite     := Ord(LastCoord);
    SaveCoord := StoreCoordFlg.Checked;

    if (not LastCoord) then // Attempt to store last coord
      HLite := ColOrd;

    StorebtControlCsm(Self);
    StorebtControlCsm(PageControl);
    StorebtControlCsm(BtListBox);
    StorebtControlCsm(BtListBtnPanel);
    StorebtControlCsm(N1YrefF);

    BtList.Store_ListCoord(GlobComp);

  end; { With GlobComp^ do... }
  Dispose(GlobComp, Destroy);
end;

//-----------------------------------------------------------------------------

procedure TfrmTimeSheet.ViewTransaction1Click(Sender: TObject);
begin
  DisplayDetails(tdCreate);
end;

//-----------------------------------------------------------------------------

procedure TfrmTimeSheet.WMCustGetRec(var Msg: TMessage);
begin
  with Msg do
  begin
    case WParam of
        0, 169 : begin
                   if (WParam = 169) then
                   begin
                     BtList.GetSelRec(BOff);
                     WParam := 0;
                   end;
                   DisplayDetails(tdCreate);
                   DetailFrm.Show;
                   ShowLink(False);
                 end;
             1 : begin
                   {* Show nominal/cc dep data *}
                   Link2Nom;
                   DisplayDetails(tdUpdate);
                   ShowLink(False);
                 end;
             2 : ShowRightMenu(LParamLo, LParamHi, 1);
            17 : begin {* Force reset of form *}
                   GotCoord   := BOff;
                   SetDefault := BOn;
                   Close;
                 end;
            25 : NeedCUpdate := BOn;
           176 : if (Assigned(BtList)) then
                   BtList.SetListFocus;
           100 : begin
                   DetailFrm := nil;
                   DetailFrmActive := BOff;
                   BtList.SetListFocus;
                 end;
    end; { case WParam of... }
  end;
  inherited;
end;

//-----------------------------------------------------------------------------

procedure TfrmTimeSheet.WMWindowPosChanged(var Msg: TMessage);
var
  TopWindow : TWinControl;
Begin
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

//-----------------------------------------------------------------------------

end.
