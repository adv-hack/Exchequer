unit frmStkAdjU;

{$ALIGN 1}

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, TCustom, Menus, ExtCtrls, SBSPanel, StdCtrls, TEditVal,
  AccelLbl, Buttons, BorBtns, bkgroup, Mask, ComCtrls,
  GlobVar,       // Exchequer global const/type/var
  VarConst,      // Exchequer global const/type/var
  SBSComp,       // Btrieve List Routines
  SupListU,      // Btrieve List Classes (TGenList)
  SBSComp2,      // Routines for Loading/Saving Window Colours/Co-Ordinates
  ExWrap1U,      // Btrieve File Wrapper Object
  BTRVU2,
  PayLineU,      // Copy of Exchequer PayLineU - Payment Line window
  frmAdjLineU,   // Transaction Line form
  VATMatrx,      // VAT Matrix Class (Copied from SalTxl1U)
  BTSupU1;       // Custom Messages and Misc Btrieve Routines

type
  TStkAdjList  =  Class(TGenList)
  Public
    DayBkListMode      : Byte;
    Rnum, Rnum2        : Double;

    Function SetCheckKey : Str255; Override;
    Function SetFilter   : Str255; Override;
    Function OutLine(Col : Byte) : Str255; Override;
  End; { TStkAdjList }

  //------------------------------


  TfrmStkAdj = class(TForm)
    PageControl: TPageControl;
    MainPage: TTabSheet;
    I1ListBtnPanel: TSBSPanel;
    BtnPanel: TSBSPanel;
    I1BSBox: TScrollBox;
    PopupMenu: TPopupMenu;
    PropFlg: TMenuItem;
    N1: TMenuItem;
    StoreCoordFlg: TMenuItem;
    N3: TMenuItem;
    btnViewLine: TButton;
    btnClose: TButton;
    I1StatLab: Label8;
    View1: TMenuItem;
    A1FPanel: TSBSPanel;
    Label817: Label8;
    Label87: Label8;
    Label816: Label8;
    LTxfrLab: Label8;
    A1OrefF: Text8Pt;
    A1OpoF: Text8Pt;
    A1YRefF: Text8Pt;
    A1LocTxF: Text8Pt;
    TransExtForm1: TSBSExtendedForm;
    UDF1L: Label8;
    UDF3L: Label8;
    UDF2L: Label8;
    UDF4L: Label8;
    Label84: Label8;
    Label88: Label8;
    Label89: Label8;
    THUD1F: Text8Pt;
    THUD3F: Text8Pt;
    THUD4F: Text8Pt;
    THUD2F: Text8Pt;
    A1TDateF: TEditDate;
    A1TPerF: TEditPeriod;
    A1YRef2F: Text8Pt;
    A1BtmPanel: TSBSPanel;
    CCPanel: TSBSPanel;
    CCTit: Label8;
    DepTit: Label8;
    CCLab: Label8;
    DepLab: Label8;
    SBSPanel5: TSBSPanel;
    DrReqdTit: Label8;
    CostLab: Label8;
    SBSPanel4: TSBSPanel;
    CrReqdTit: Label8;
    GLLab: Label8;
    A1SBox: TScrollBox;
    A1HedPanel: TSBSPanel;
    A1CLab: TSBSPanel;
    A1GLab: TSBSPanel;
    A1OLab: TSBSPanel;
    A1DLab: TSBSPanel;
    A1ILab: TSBSPanel;
    A1CCLab: TSBSPanel;
    A1DpLab: TSBSPanel;
    A1BLab: TSBSPanel;
    A1ULab: TSBSPanel;
    A1LocLab: TSBSPanel;
    A1CPanel: TSBSPanel;
    A1IPanel: TSBSPanel;
    A1GPanel: TSBSPanel;
    A1DPanel: TSBSPanel;
    A1OPanel: TSBSPanel;
    A1CCPanel: TSBSPanel;
    A1DpPanel: TSBSPanel;
    A1BPanel: TSBSPanel;
    A1UPanel: TSBSPanel;
    A1LocPanel: TSBSPanel;
    ResetCoordinates1: TMenuItem;
    THUD5F: Text8Pt;
    THUD7F: Text8Pt;
    THUD9F: Text8Pt;
    THUD6F: Text8Pt;
    THUD8F: Text8Pt;
    THUD10F: Text8Pt;
    UDF5L: Label8;
    UDF7L: Label8;
    UDF9L: Label8;
    UDF6L: Label8;
    UDF8L: Label8;
    UDF10L: Label8;
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure FormDestroy(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure FormKeyPress(Sender: TObject; var Key: Char);
    procedure FormResize(Sender: TObject);
    procedure PropFlgClick(Sender: TObject);
    procedure StoreCoordFlgClick(Sender: TObject);
    procedure btnCloseClick(Sender: TObject);
    procedure btnViewLineClick(Sender: TObject);
    procedure ResetCoordinates1Click(Sender: TObject);
  private
    { Private declarations }
    ExLocal     : TdExLocal;

    BtList    : TStkAdjList;
    MULVisiList : Array[0..3] of TVisiList;

    IdLine      : TfrmAdjLine;     // Standard transaction Line form

    GotCoord    : Boolean;
    InitSize    : TPoint;
    LastCoord   : Boolean;
    ListOfSet   : Integer;
    NeedCUpdate : Boolean;
    PagePoint   : Array[0..6] of TPoint;
    ReCalcTot   : Boolean;
    SetDefault  : Boolean;
    StartSize   : TPoint;
    StoreCoord  : Boolean;
    VATMatrix   : TVATMatrix;

    procedure BuildDesign;
    procedure BuildList (ShowLines : Boolean);
    procedure DisplayTransactions(const TheId: IDetail; const DataChanged : Boolean);
    procedure Find_FormCoord;
    procedure FormSetOffSet;
    Procedure Link2Nom;
    procedure RefreshList (ShowLines, IgMsg : Boolean);
    Procedure SetColDec (PageNo : Byte);
    procedure SetFormProperties(SetList  :  Boolean);
    procedure SetUDFields(UDDocHed  :  DocTypes);
    procedure ShowDetails;
    procedure ShowRightMenu(X,Y,Mode  :  Integer);
    procedure Store_FormCoord (UpMode : Boolean);
    procedure Store_Page1Coord(UpMode  :  Boolean);
    procedure WMCustGetRec (var Msg: TMessage); message WM_CustGetRec;
    procedure WMWindowPosChanged(var Msg : TMessage); Message WM_WindowPosChanged;
  public
    { Public declarations }
    procedure DisplayTrans(const TheTrans: InvRec; const TheCust: CustRec);
  end;

var
  frmStkAdj: TfrmStkAdj;

implementation

{$R *.dfm}

Uses
  ETStrU,
  ETDateU,
  ETMiscU,
  CmpCtrlU,       // Misc Routines for loading/saving Colours & Positions
  ColCtrlU,       // Form Color/Font Properties Window
  DispDocF,       // Transaction Display Manager and some common routines
  EntData,        // Global Exchequer Data object
  EntLicence,     // Global Exchequer Licence object
  CurrncyU,       // Misc Exchequer Currency Routines
  ComnUnit,       // Misc Exchequer Period and Transaction Total Routines
  Comnu2,         // Misc Exchequer Routines
  IntStatU,       // Misc Intrastat
  InvFSu3U,       // Misc utility functions
  MiscU,          // Transaction Total Functions
  SysU2,
  InvListU,
  BTSupU2,        // Misc Exchequer Routines
  BTKeys1U,       // Exchequer Search Key utilities
  CustomFIeldsIntF,
  { CJS - 2013-10-28 - ABSEXCH-14705 - MRD2.6 - Transaction Originator }
  TransactionOriginator;

//=============================================================================
// TStkAdjList
//=============================================================================

function TStkAdjList.OutLine (Col : Byte) : Str255;

  function FormatBFloat(FMask: Str255; Value: Double; SBlnk: Boolean): Str255;
  { --- Copied from X:\Entrprse\R&D\SalTxl1U.pas and amended ----------------- }
  begin
    if (Value <> 0.0) or (not SBlnk) then
      Result := FormatFloat(Fmask, Value)
    else
      Result := '';
  end;

var
  GenStr:  Str255;
  CrDr: DrCrType;
  ExLocal: ^TdExLocal;
begin
  Result := '';
  ExLocal := ListLocal;
  with ExLocal^, Id do
  begin
    case Col of
      0  : Result := StockCode;
      1  : begin
             if (Stock.StockCode <> StockCode) then
               Global_GetMainRec(StockF, StockCode);
             Result := Stock.Desc[1];
           end;
      2,3: begin
             GenStr := '';
             ShowDrCr(Qty * QtyMul, CrDr);
             Result := FormatBFloat(GenQtyMask, Ea2Case(Id, LStock, CrDr[(Col = 3)]), (CrDr[(Col = 3)]=0.0));
           end;
      4  : Result := YesNoBo((KitLink=1));
      5  : Result := FormatFloat(GenUnitMask[BOff],CostPrice);
      6  : Result := MLocStk;
      7  : Result := Form_Int(NomCode,0);
      8,9: begin
             if (Syss.UseCCDep) then
               Result := CCDep[(Col=8)]
             else
               Result := '';
           end;
    else
      Result := '';
    end;
  end;
end;

//-----------------------------------------------------------------------------

function TStkAdjList.SetCheckKey: Str255;
var
  DumStr: Str255;
begin
  FillChar(DumStr,Sizeof(DumStr),0);
  with Id do
  begin
    DumStr := FullIdKey(FolioRef,LineNo);
    If (UseSet4End) and (CalcEndKey) then  {* If a special end key calculation is needed *}
      DumStr := DumStr + NdxWeight;
  end;
  Result := DumStr;
end;

//-----------------------------------------------------------------------------

function TStkAdjList.SetFilter: Str255;
begin
  Result := Id.Payment;
end;

//-----------------------------------------------------------------------------

//=============================================================================
// TfrmStkAdj
//=============================================================================

procedure TfrmStkAdj.btnCloseClick(Sender: TObject);
begin
  Close;
end;

//-----------------------------------------------------------------------------

procedure TfrmStkAdj.btnViewLineClick(Sender: TObject);
begin
  OK := BtList.ValidLine;
  if OK then
  begin
    BtList.RefreshLine(BtList.MUListBoxes[0].Row,BOff);
    DisplayTransactions(Id, False);
  end;
end;

//-----------------------------------------------------------------------------

procedure TfrmStkAdj.BuildDesign;
Var
  HideCC : Boolean;
begin
  with ExLocal, LInv, EnterpriseLicence do
  begin
    I1StatLab.Caption := 'STATUS:'#13'View Only';

    // Hide CostCentre/Department fields
    HideCC := not Syss.UseCCDep;

    CCTit.Visible  := not HideCC;
    CCLab.Visible  := not HideCC;
    DepTit.Visible := not HideCC;
    DepLab.Visible := not HideCC;
  end; { with ExLocal... }
end;

//-----------------------------------------------------------------------------

procedure TfrmStkAdj.BuildList (ShowLines : Boolean);
var
  StartPanel: TSBSPanel;
  n         : Integer;
begin
  StartPanel := nil;
  if not Assigned(BtList) Then
    BtList := TStkAdjList.Create(Self);

  try
    with BtList do
    begin
      try
        with VisiList do
        begin
          AddVisiRec(A1CPanel,A1CLab);
          AddVisiRec(A1DPanel,A1DLab);
          AddVisiRec(A1IPanel,A1ILab);
          AddVisiRec(A1OPanel,A1OLab);
          AddVisiRec(A1BPanel,A1BLab);
          AddVisiRec(A1UPanel,A1ULab);
          AddVisiRec(A1LocPanel,A1LocLab);
          AddVisiRec(A1GPanel,A1GLab);
          AddVisiRec(A1CCPanel,A1CCLab);
          AddVisiRec(A1DpPanel,A1DpLab);

          VisiRec := List[0];

          StartPanel := (VisiRec^.PanelObj as TSBSPanel);

          LabHedPanel := A1HedPanel;

          SetHedPanel(ListOfSet);
        end;
      except
        VisiList.Free;
      end;

      ListOfSet := 10;

      Find_FormCoord;

      TabOrder      := -1;
      TabStop       := BOff;
      Visible       := BOff;
      BevelOuter    := bvNone;
      ParentColor   := False;
      Color         := StartPanel.Color;
      MUTotCols     := 9;
      Font          := StartPanel.Font;
      LinkOtherDisp := BOn;
      WM_ListGetRec := WM_CustGetRec;
      Parent        := StartPanel.Parent;
      MessHandle    := self.Handle;

      SetColDec(0);

      for n := 0 to MUTotCols do
      with ColAppear^[n] do
      begin
        AltDefault := BOn;
        DispFormat := SGText;
        if (n in [2,3,5,7]) then
        begin
          DispFormat := SGFloat;
          case n of
            2, 3: NoDecPlaces := Syss.NoQtyDec;
               5: NoDecPlaces := Syss.NoCosDec;
          else
            NoDecPlaces := 0;
          end;
        end;
      end;

      ListLocal := @ExLocal;

      ListCreate;

      Filter[1,1]   := '1'; {* Exclude Receipt part *}
      UseSet4End    := BOn;
      NoUpCaseCheck := BOn;
      DayBkListMode := 0;

      Set_Buttons(I1ListBtnPanel);

      ReFreshList(ShowLines,BOff);

      MULVisiList[0] := VisiList;

    end { with BtList do... }

  except
    BtList.Free;
    BtList := Nil;
  end;

  FormSetOffSet;
  FormReSize(self);
end;

//-----------------------------------------------------------------------------

procedure TfrmStkAdj.DisplayTrans(const TheTrans: InvRec; const TheCust: CustRec);

  // Run through Transaction Lines accumulating the VAT
  procedure ProcessLines;
  var
    lStatus   : SmallInt;
    KeyS      : Str255;
    LineTotal : Double;
  begin
    with ExLocal do
    begin
      // Zero out the VAT totals
      Blank(LInvNetTrig,Sizeof(LInvNetTrig));

      // Run through the Transaction lines
      KeyS := FullIdKey(LInv.FolioNum, 1);
      lStatus := Find_Rec (B_GetGEq, F[IDetailF], IDetailF, LRecPtr[IDetailF]^, IDFolioK, KeyS);
      while (LStatus = 0) and (LInv.FolioNum = LID.FolioRef) do
      begin
        if (Id.LineNo <> RecieptCode) then
          with LID do
          begin
            // Update VAT Flag
            LInvNetTrig[GetVAtNo(VATcode,VATIncFlg)] := BOn; {* Show Rate is being used, Value independant *}

            // Update Goods Total
            LineTotal := Round_Up(InvLTotal(LId, BOn, (LInv.DiscSetl * Ord(LInv.DiscTaken))), 2);
            LInvNetAnal[GetVAtNo(VATcode,VATIncFlg)] := LInvNetAnal[GetVAtNo(VATcode,VATIncFlg)] + LineTotal;
          end; { with LID do... }

        // Get next line
        lStatus := Find_Rec(B_GetNext, F[IDetailF], IDetailF, LRecPtr[IDetailF]^, IDFolioK, KeyS);
      end; { while (LStatus = 0)... }
    end; { with ExLocal... }
  end;

begin
  // Get static data from database
  ExLocal.LInv := TheTrans;
  ExLocal.LCust := TheCust;
  ProcessLines;

  // Update Form Caption
  Caption := Trim(EnterpriseData.edCompanyCode) + ', ' + ExLocal.LInv.OurRef;

  // Update form layout for licencing and document type
  BuildDesign;

  // Update user defined field captions and availability
  SetUDFields(ExLocal.LInv.InvDocHed);

  ReFreshList (True, True);
end;

//-----------------------------------------------------------------------------

procedure TfrmStkAdj.DisplayTransactions(const TheId: IDetail; const DataChanged : Boolean);
begin
  ShowDetails;

  // Create form if required
  if (not Assigned(IdLine)) and (not DataChanged) then
    IDLine := TfrmAdjLine.Create(Self);

  if Assigned(IdLine) then
    // Display Transaction Line
    IdLine.ShowLink(ExLocal.LInv, True);

end;

//-----------------------------------------------------------------------------

procedure TfrmStkAdj.Find_FormCoord;
var
  ThisForm: TForm;
  GlobComp: TGlobCompRec;
begin
  New(GlobComp,Create(BOn));

  ThisForm := self;

  with GlobComp^ do
  begin
    GetValues := BOn;

    PrimeKey := LowerCase(DocCodes[ExLocal.LInv.InvDocHed])[1];

    if (GetbtControlCsm(ThisForm)) then
    begin
      HasCoord  := (HLite = 1);
      LastCoord := HasCoord;

      if (HasCoord) then {* Go get postion, as would not have been set initianly *}
        SetPosition(ThisForm);
    end;

    GetbtControlCsm(PageControl);

    GetbtControlCsm(I1BSBox);

    GetbtControlCsm(BtnPanel);

    GetbtControlCsm(I1ListBtnPanel);

    BtList.Find_ListCoord(GlobComp);
  end; { with GlobComp^ do... }

  Dispose(GlobComp,Destroy);

  StartSize.X := Width;
  StartSize.Y := Height;
end;

//-----------------------------------------------------------------------------

procedure TfrmStkAdj.FormClose(Sender: TObject; var Action: TCloseAction);
var
  n: SmallInt;
begin
  Action:=caFree;

  With BtList do
  Begin
    VisiList := MULVisiList[0];
  end;

  For n:=1 to High(MULVisiList) do
    If (MULVisiList[n]<>nil) then
      MULVisiList[n].Free;

  If (BtList<>nil) then
  Begin
    try
      BtList.Destroy;
    finally
      BtList:=nil;
    end;
  end;

  SendMessage ((Owner As TForm).Handle, WM_CustGetRec, 100, 4);
end;

//-----------------------------------------------------------------------------

procedure TfrmStkAdj.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
Var
  n : SmallInt;
begin
  For n:=0 to Pred(ComponentCount) do
    If (Components[n] is TScrollBox) then
      With TScrollBox(Components[n]) do
      Begin
        VertScrollBar.Position:=0;
        HorzScrollBar.Position:=0;
      end;

  If (NeedCUpdate or StoreCoordFlg.Checked or SetDefault) then
    Store_FormCoord(Not SetDefault);
end;

//-----------------------------------------------------------------------------

procedure TfrmStkAdj.FormCreate(Sender: TObject);
var
  n: Integer;
begin
  // Always display main tab first
  PageControl.ActivePage := MainPage;

  // Create data interface object for list
  ExLocal.Create;

  // Initialise scroll-bar positions
  for n := 0 to Pred(ComponentCount) do
    if (Components[n] is TScrollBox) then
      with TScrollBox(Components[n]) do
      begin
        VertScrollBar.Position := 0;
        HorzScrollBar.Position := 0;
      end; { with TScrollBox(Components[n]) do... }
  VertScrollBar.Position:=0;
  HorzScrollBar.Position:=0;

  // Initialise Form Sizes
  InitSize.Y := 354;  // ClientHeight
  InitSize.X := 627;  // ClientWidth
  Self.ClientHeight := InitSize.Y;
  Self.ClientWidth  := InitSize.X;
  Constraints.MinHeight := InitSize.Y - 1;
  Constraints.MinWidth  := InitSize.X - 1;

  // Setup misc internal variables
  LastCoord   := BOff;
  NeedCUpdate := BOff;
  ReCalcTot   := BOn;
  SetDefault  := BOff;
  StoreCoord  := BOff;

  // Setup VAT Matrix and decimals, etc...
  VATMatrix :=TVATMatrix.Create;

  // Initialise the Btrieve Lists
  BuildList (BOff);
end;

//-----------------------------------------------------------------------------

procedure TfrmStkAdj.FormDestroy(Sender: TObject);
begin
  VATMatrix.Free;

  If Assigned(IdLine) Then
    FreeAndNIL(IdLine);

  ExLocal.Destroy;
end;

//-----------------------------------------------------------------------------

procedure TfrmStkAdj.FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  GlobFormKeyDown(Sender,Key,Shift,ActiveControl,Handle);
end;

//-----------------------------------------------------------------------------

procedure TfrmStkAdj.FormKeyPress(Sender: TObject; var Key: Char);
begin
  GlobFormKeyPress(Sender,Key,ActiveControl,Handle);
end;

//-----------------------------------------------------------------------------

procedure TfrmStkAdj.FormResize(Sender: TObject);
begin

  if GotCoord then
  begin

    self.HorzScrollBar.Position := 0;
    self.VertScrollBar.Position := 0;

    PageControl.Width  := Width  - PagePoint[0].X;
    PageControl.Height := Height - PagePoint[0].Y;

    A1SBox.Width  := PageControl.Width  - PagePoint[1].X;
    A1SBox.Height := PageControl.Height - PagePoint[1].Y;

    A1FPanel.Width := PageControl.Width - 5;

    I1ListBtnPanel.Left   := PageControl.Width  - PagePoint[2].X;
    I1ListBtnPanel.Height := PageControl.Height - PagePoint[2].Y;

    BtnPanel.Left := PageControl.Width - (BtnPanel.Width + 4);

    if (BtList <> nil) then
    begin
      if (MULVisiList[0] <> nil) then
      begin
        BtList.VisiList := MULVisiList[0];
        with BtList, VisiList do
        begin
          VisiRec := List[0];
          with (VisiRec^.PanelObj as TSBSPanel) do
            Height := A1SBox.ClientHeight - PagePoint[3].Y;
          RefreshAllCols;
        end;
      end; { if (MULVisiList[0] <> nil) then... }

      BtList.ReFresh_Buttons;

    end; { if (BtList <> nil) then... }

    NeedCUpdate := ((StartSize.X <> Width) or (StartSize.Y <> Height));
  end;

end;

//-----------------------------------------------------------------------------

procedure TfrmStkAdj.FormSetOffSet;
Begin
  PagePoint[0].X := Width  - PageControl.Width;
  PagePoint[0].Y := Height - PageControl.Height;

  PagePoint[1].X := PageControl.Width  - A1SBox.Width;
  PagePoint[1].Y := PageControl.Height - A1SBox.Height;

  PagePoint[2].X := PageControl.Width  - BtnPanel.Left;
  PagePoint[2].Y := PageControl.Height - BtnPanel.Height;

  PagePoint[3].X := BtnPanel.Height - I1BSBox.Height;
  PagePoint[3].Y := A1SBox.ClientHeight - A1CPanel.Height;

  PagePoint[4].X := PageControl.Width  - I1ListBtnPanel.Left;
  PagePoint[4].Y := PageControl.Height - I1ListBtnPanel.Height;

  GotCoord:=BOn;
end;

//-----------------------------------------------------------------------------

procedure TfrmStkAdj.Link2Nom;
var
  FoundOk  : Boolean;
  FoundLong: LongInt;
  FoundStk : Str20;
begin
  with Id do
  begin
    CostLab.Caption := FormatFloat(GenUnitMask[BOff],CostPrice);

    if (Nom.NomCode <> NomCode) then
      FoundOk := GetNom(self, Form_Int(NomCode, 0), FoundLong, -1)
    else
      FoundOk := False;

    if FoundOk then
      GLLab.Caption := Nom.Desc;

    if (Syss.UseCCDep) then
    begin
      CCLab.Caption := CCDep[BOn];
      DepLab.Caption := CCDep[BOff];
    end;

    with ExLocal do
    if (Is_FullStkCode(StockCode)) and (LStock.StockCode <> StockCode) then
    begin
      GetStock(self, StockCode, FoundStk,-1);
      AssignFromGlobal(StockF);
    end;
  end;
end; {Proc..}

//-----------------------------------------------------------------------------

procedure TfrmStkAdj.PropFlgClick(Sender: TObject);
begin
  SetFormProperties((N3.Tag = 99));
  N3.Tag := 0;
end;

//-----------------------------------------------------------------------------

procedure TfrmStkAdj.RefreshList (ShowLines, IgMsg : Boolean);
var
  KeyStart: Str255;
begin
  KeyStart := FullIdkey(EXLocal.LInv.FolioNum, 1);
  with BtList do
  begin
    IgnoreMsg := IgMsg;
    StartList(IdetailF, IdFolioK, KeyStart, '', '', 4, (not ShowLines));
    IgnoreMsg := BOff;
  end;
end;

//-----------------------------------------------------------------------------

procedure TfrmStkAdj.ResetCoordinates1Click(Sender: TObject);
begin
  if ResetCoordinates1.Checked then
  begin
    StoreCoordFlg.Checked := False;
    SetDefault := True;
  end;
end;

//-----------------------------------------------------------------------------

procedure TfrmStkAdj.SetColDec (PageNo : Byte);
var
  n:  Byte;
begin
  with BtList do
  begin
    for n := 0 to MUTotCols do
      with ColAppear^[n], ExLocal.LInv do
      begin
        AltDefault := BOn;
        DispFormat := SGText;

        if ((n in [4, 6])          and (PageNo in [0, 3])) or
           ((n = 2)                and (PageNo = 0)) or
           ((n in [3, 6, 7, 8, 9]) and (PageNo = 1)) or
           ((n in [1..6])          and (PageNo = 2)) or
           ((n = 4)                and (PageNo = 3)) then
        begin
          DispFormat  := SGFloat;
          NoDecPlaces := 2;

          if (n = 6) and (PageNo in [0, 3]) then
          begin
            if (InvDocHed in SalesSplit) then
              NoDecPlaces := Syss.NoNetDec
            else
              NoDecPlaces := Syss.NoCosDec;
          end
          else if (n = 3) and (PageNo = 1) then
            NoDecPlaces:=0
          else if ((n in [1..6]) and (PageNo = 2)) or
                  ((n = 2) and (PageNo = 0)) then
            NoDecPlaces := Syss.NoQtyDec;
        end;
      end; { with ColAppear^[n], ExLocal.LInv do... }
  end; { with BtList do... }
end;

//-----------------------------------------------------------------------------

procedure TfrmStkAdj.SetFormProperties(SetList  :  Boolean);
Const
  PropTit     :  Array[BOff..BOn] of Str5 = ('Form','List');
Var
  TmpPanel    :  Array[1..3] of TPanel;
  n           :  Byte;
  ResetDefaults,
  BeenChange  :  Boolean;
  ColourCtrl  :  TCtrlColor;
Begin
  ResetDefaults:=BOff;

  For n:=1 to 3 do
  Begin
    TmpPanel[n]:=TPanel.Create(Self);
  end;

  try
    if (SetList) then
    begin
      With BtList.VisiList do
      Begin
        VisiRec:=List[0];

        TmpPanel[1].Font:=(VisiRec^.PanelObj as TSBSPanel).Font;
        TmpPanel[1].Color:=(VisiRec^.PanelObj as TSBSPanel).Color;

        TmpPanel[2].Font:=(VisiRec^.LabelObj as TSBSPanel).Font;
        TmpPanel[2].Color:=(VisiRec^.LabelObj as TSBSPanel).Color;


        TmpPanel[3].Color:=BtList.ColAppear^[0].HBKColor;
      end;

      TmpPanel[3].Font.Assign(TmpPanel[1].Font);

      TmpPanel[3].Font.Color:=BtList.ColAppear^[0].HTextColor;
    end;

    ColourCtrl:=TCtrlColor.Create(Self);

    try
      With ColourCtrl do
      Begin
        SetProperties(TmpPanel[1],TmpPanel[2],TmpPanel[3],Ord(SetList),Self.Caption+' '+PropTit[SetList]+' Properties',BeenChange,ResetDefaults);

        NeedCUpdate:=(BeenChange or ResetDefaults);

        If (BeenChange) and (not ResetDefaults) then
        Begin

          If (SetList) then
          Begin
            For n:=1 to 3 do
              With TmpPanel[n] do
                Case n of
                  1,2  :  BtList.ReColorCol(Font,Color,(n=2));

                  3    :  BtList.ReColorBar(Font,Color);
                end; {Case..}

            BtList.VisiList.LabHedPanel.Color:=TmpPanel[2].Color;
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

procedure TfrmStkAdj.SetUDFields(UDDocHed  :  DocTypes);
var
  PNo, n      : Byte;
  UDAry, HDAry: array[1..4] of Byte;
begin
  PNo := 1;

  case UDDocHed of
    SOR, SDN: begin
                for n := 1 to 4 do
                  UDAry[n] := 10 + n;
                HDAry := UDAry;
              end;
    POR, PDN: begin
                for n := 1 to 4 do
                  UDAry[n] := 34 + n;
                HDAry := UDAry;
              end;
    SQU     : begin
                PNo := 2;
                For n := 1 to 4 do
                  UDAry[n] := 24 + n;
                HDAry := UDAry;
              end;
    PQU     : begin
                PNo := 2;
                for n := 1 to 4 do
                  UDAry[n] := 32 + n;
                HDAry := UDAry;
              end;
  else
    if (UDDocHed in SalesSplit) then
    begin
      PNo := 0;
      UDAry[1] := 3;
      UDAry[2] := 4;
      UDAry[3] := 13;
      UDAry[4] := 14;

      HDAry[1] := 0;
      HDAry[2] := 5;
      HDAry[3] := 6;
      HDAry[4] := 7;
    end
    else
    begin
      for n := 1 to 4 do
        UDAry[n] := 18 + n;
      HDAry := UDAry;
    end;
  end; { case UDDocHed of... }

    //GS 17/11/2011 ABSEXCH-12037: modifed UDF settings code to use the new "CustomFieldsIntF" unit
  EnableUDFs([UDF1L, UDF2L, UDF3L, UDF4L, UDF5L, UDF6L, UDF7L, UDF8L, UDF9L, UDF10L],
             [THUD1F, THUD2F, THUD3F, THUD4F, THUD5F, THUD6F, THUD7F, THUD8F, THUD9F, THUD10F], cfADJHeader, True);

  ResizeUDFParentContainer(NumberOfVisibleUDFs([THUD1F, THUD2F, THUD3F, THUD4F, THUD5F, THUD6F, THUD7F, THUD8F, THUD9F, THUD10F]),
                           2,
                           TransExtForm1);

end;

//-----------------------------------------------------------------------------

procedure TfrmStkAdj.ShowDetails;
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

    A1YRefF.Text  := TransDesc;
    A1YRef2F.Text := YourRef;

    {$IFDEF SOP}
      A1LocTxF.Text := Trim(DelTerms);
    {$ENDIF}

    THUd1F.Text := DocUser1;
    THUd2F.Text := DocUser2;
    THUd3F.Text := DocUser3;
    THUd4F.Text := DocUser4;
    //GS 17/11/2011 ABSEXCH-12037: put customisation values into text boxes
    THUd5F.Text := DocUser5;
    THUd6F.Text := DocUser6;
    THUd7F.Text := DocUser7;
    THUd8F.Text := DocUser8;
    THUd9F.Text := DocUser9;
    THUd10F.Text := DocUser10;
  end; { with ExLocal, LInv do... }
end;

//-----------------------------------------------------------------------------

procedure TfrmStkAdj.ShowRightMenu(X,Y,Mode  :  Integer);
begin
  with PopUpMenu do
    PopUp(X,Y);
end;

//-----------------------------------------------------------------------------

procedure TfrmStkAdj.StoreCoordFlgClick(Sender: TObject);
begin
  if (StoreCoordFlg.Checked) then
    ResetCoordinates1.Checked := False;
  NeedCUpdate := StoreCoordFlg.Checked;
end;

//-----------------------------------------------------------------------------

procedure TfrmStkAdj.Store_FormCoord(UpMode: Boolean);
var
  GlobComp:  TGlobCompRec;
begin
  New(GlobComp,Create(BOff));

  with GlobComp^ do
  begin
    GetValues := UpMode;
    PrimeKey  := LowerCase(DocCodes[ExLocal.LInv.InvDocHed])[1];
    ColOrd    := Ord(StoreCoordFlg.Checked);
    HLite     := Ord(LastCoord);
    SaveCoord := StoreCoordFlg.Checked;

    If (Not LastCoord) then {* Attempt to store last coord *}
      HLite := ColOrd;

    StorebtControlCsm(self);

    StorebtControlCsm(PageControl);
    StorebtControlCsm(I1BSBox);
    StorebtControlCsm(BtnPanel);
    StorebtControlCsm(I1ListBtnPanel);
    BtList.Store_ListCoord(GlobComp);

  end; { with GlobComp do... }

  Dispose(GlobComp, Destroy);

  Store_Page1Coord(UpMode);
End;

//-----------------------------------------------------------------------------

procedure TfrmStkAdj.Store_Page1Coord(UpMode  :  Boolean);
var
  GlobComp: TGlobCompRec;
begin
  New(GlobComp, Create(BOff));

  with GlobComp^ do
  begin

    GetValues := UpMode;
    SaveCoord := StoreCoordFlg.Checked;
    PrimeKey  := LowerCase(DocCodes[ExLocal.LInv.InvDocHed])[1];

    if (MULVisiList[0] <> nil) then
    with BtList do
    begin
      VisiList := MULVisiList[0];

      Store_ListCoord(GlobComp);

      StorebtControlCsm(VisiList.LabHedPanel); {* Move to object store *}
    end;

  end; { with GlobComp^ do... }

  Dispose(GlobComp,Destroy);
end;

//-----------------------------------------------------------------------------

procedure TfrmStkAdj.WMCustGetRec(var Msg: TMessage);
begin
  with Msg do
  begin
    case WParam of
      0, 169: begin
                if (WParam = 169) then {* Treat as 0 *}
                begin
                  BtList.GetSelRec(BOff);
                  WParam := 0;
                end;
                DisplayTransactions(Id, False);
              end;
      1  :  begin
              {* Show nominal/cc dep data *}
              Link2Nom;
              DisplayTransactions(Id, True);
            end;
      2  :  ShowRightMenu(LParamLo,LParamHi,1);
     17  :  begin {* Force reset of form *}
              GotCoord   := BOff;
              SetDefault := BOn;
              Close;
            end;
      25  :  NeedCUpdate := BOn;
     100  : begin
              if LParam = 1 then
                IdLine := nil;
            end;
    end; { case WParam of... }
  end;
  inherited;
end;

//-----------------------------------------------------------------------------

procedure TfrmStkAdj.WMWindowPosChanged(var Msg : TMessage);
// IMPORTANT NOTE: This message handler is required to ensure the form stays
// on top, as it has a habit of losing its Stay-On-Top'ness at runtime.
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
  end; { if self.Visible then... }
end;

//-----------------------------------------------------------------------------

end.

