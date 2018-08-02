unit JobLineF;

{$ALIGN 1}

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, Menus,
  GlobVar,       // Exchequer global const/type/var
  VarConst,      // Exchequer global const/type/var
  BTRVU2,
  BTSupU1,       // Custom Messages and Misc Btrieve Routines
  DispDocF,      // Parent Window for displaying Transaction Details
  uMultiList,
  uSettings, ComCtrls, TEditVal, SBSPanel;

const
  WM_VIEWTRANSACTION = WM_USER + 1000;

type
  // Display modes for the Job History Drill-Down
  TJobDrillMode = (jdGLActual);      // Base GL functions e.g. entGLJobActual

  TfrmJobLineDrill = class(TForm)
    PopupMenu: TPopupMenu;
    PropFlg: TMenuItem;
    N1: TMenuItem;
    StoreCoordFlg: TMenuItem;
    N2: TMenuItem;
    ViewTransaction1: TMenuItem;
    JList: TMultiList;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    lblCompany: TLabel;
    lblGLCode: TLabel;
    lblFrom: TLabel;
    lblTo: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    Label8: TLabel;
    lblJobCode: TLabel;
    lblCurrency: TLabel;
    lblAnalysisCode: TLabel;
    lblStockCode: TLabel;
    Label9: TLabel;
    Label10: TLabel;
    Label11: TLabel;
    Label12: TLabel;
    lblAccountCode: TLabel;
    lblCostCentre: TLabel;
    lblDepartment: TLabel;
    lblLocation: TLabel;
    Shape1: TShape;
    StatusBar: TStatusBar;
    BtnPanel: TSBSPanel;
    I1BSBox: TScrollBox;
    btnViewLine: TButton;
    btnClose: TButton;
    ResetCoordinates1: TMenuItem;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormResize(Sender: TObject);
    procedure PropFlgClick(Sender: TObject);
    procedure StoreCoordFlgClick(Sender: TObject);
    procedure ViewTransaction1Click(Sender: TObject);
    procedure PopupMenuPopup(Sender: TObject);
    procedure JListRowDblClick(Sender: TObject; RowIndex: Integer);
    procedure btnViewLineClick(Sender: TObject);
    procedure btnCloseClick(Sender: TObject);
    procedure WMViewTransaction(var Msg: TMessage); message WM_VIEWTRANSACTION;
    procedure JListClick(Sender: TObject);
    procedure ResetCoordinates1Click(Sender: TObject);
  private
    { Private declarations }
    FCompanyCode : ShortString;
    FCostCentre  : ShortString;
    FCurrency    : Byte;
    FDepartment  : ShortString;
    FGLCode      : LongInt;
    FGLDescr     : ShortString;
    FGLType      : Char;
    FMode        : TJobDrillMode;
    FStartPeriod : SmallInt;
    FEndPeriod   : SmallInt;
    FStartYear   : SmallInt;
    FEndYear     : SmallInt;
    FJobCode     : ShortString;
    FAnalysisCode : ShortString;
    FLocation    : ShortString;
    FStockCode   : ShortString;
    FAccountCode : ShortString;

    SetDefault   : Boolean;
//    StoreCoord   : Boolean;
    PagePoint    : array[1..3] of TPoint;
    InitSize     : TPoint;
    DoneRestore  : Boolean;
    Populating   : Boolean;

    DisplayTrans : TfrmDisplayTransManager;

    procedure SetCompanyCode (Value : ShortString);
    procedure SetCostCentre(const Value: ShortString);
    procedure SetCurrency (Value : Byte);
    procedure SetDepartment(const Value: ShortString);
    procedure SetGLCode (Value : LongInt);
    procedure SetGLDescr (Value : ShortString);
    procedure SetMode (Value : TJobDrillMode);
    procedure SetEndPeriod(const Value: SmallInt);
    procedure SetEndYear(const Value: SmallInt);
    procedure SetStartPeriod(const Value: SmallInt);
    procedure SetStartYear(const Value: SmallInt);
    procedure SetAccountCode(const Value: ShortString);
    procedure SetAnalysisCode(const Value: ShortString);
    procedure SetJobCode(const Value: ShortString);
    procedure SetLocation(const Value: ShortString);
    procedure SetStockCode(const Value: ShortString);

    function  CheckListFinished : Boolean;
    procedure Display_Trans (Const IdFolio : LongInt; Const DataChanged : Boolean);
    procedure FormBuildList(ShowLines : Boolean);
    procedure SetFormProperties;
    procedure WMWindowPosChanged(var Msg : TMessage); Message WM_WindowPosChanged;

    procedure SetColoursAndPositions (Const Mode : Byte);

  public
    // Public Properties
    Property jlCompanyCode : ShortString Read FCompanyCode Write SetCompanyCode;
    Property jlCostCentre : ShortString Read FCostCentre Write SetCostCentre;
    Property jlCurrency : Byte Read FCurrency Write SetCurrency;
    Property jlDepartment : ShortString Read FDepartment Write SetDepartment;
    Property jlGLCode : LongInt Read FGLCode Write SetGLCode;
    Property jlGLdescr : ShortString Read FGLDescr Write SetGLDescr;
    Property jlGLType : Char Read FGLType Write FGLType;
    Property jlMode : TJobDrillMode Read FMode Write SetMode;
    Property jlStartPeriod : SmallInt Read FStartPeriod Write SetStartPeriod;
    Property jlStartYear : SmallInt Read FStartYear Write SetStartYear;
    Property jlEndPeriod : SmallInt Read FEndPeriod Write SetEndPeriod;
    Property jlEndYear : SmallInt Read FEndYear Write SetEndYear;
    property jlJobCode: ShortString read FJobCode write SetJobCode;
    property jlAnalysisCode: ShortString read FAnalysisCode write SetAnalysisCode;
    property jlLocation: ShortString read FLocation write SetLocation;
    property jlStockCode: ShortString read FStockCode write SetStockCode;
    property jlAccountCode: ShortString read FAccountCode write SetAccountCode;

    // Public Methods
    procedure StartList;
    procedure BuildLines;
  end;


function NewJobLines: TfrmJobLineDrill;

implementation

{$R *.dfm}

uses ComnU2,         // Exchequer Misc Routines
     ComnUnit,
     ETStrU,
     ETMiscU,
     ETDateU,
     CurrncyU,
     EntData,        // EntData object
     EntLicence,     // Global Exchequer Licence object
     MainF,          // Main form & Debug window
     SysU1,
     BTKeys1U;       // Exchequer Search Key utilities

var
  frmJobLines: TfrmJobLineDrill;

const
  COL_OREF = 0;
  COL_YRPR = 1;
  COL_ACCT = 2;
  COL_DESC = 3;
  COL_AMNT = 4;
  COL_STAT = 5;
  COL_DATE = 6;

//=========================================================================

Function NewJobLines : TfrmJobLineDrill;
Begin { NewJobLines }
  Result := NIL;

  If Assigned(frmJobLines) Then
    FreeAndNil(frmJobLines);
(*
    Try
      // Try to access the caption to determine whether the form is still
      // in existance - if not then should get an Access Violation
      If (frmJobLines.Caption <> '') Then
        Result := frmJobLines
    Except
      On Exception Do
        ;
    End;

  // If no pre-existing form then create a new one
*)
  If (Not Assigned(Result)) Then
    Result := TfrmJobLineDrill.Create (NIL);

  // Record global reference to form for later use
  frmJobLines := Result;
End;

//=========================================================================

procedure TfrmJobLineDrill.btnCloseClick(Sender: TObject);
begin
  Close;
end;

procedure TfrmJobLineDrill.btnViewLineClick(Sender: TObject);
begin
  ViewTransaction1Click(Sender);
end;

procedure TfrmJobLineDrill.FormCreate(Sender: TObject);
begin
  // MH 11/11/2010 v6.5 ABSEXCH-2930: Switched to reference counting to prevent files being closed whilst another window open
  EnterpriseData.AddReferenceCount;

  PagePoint[1].X := Width - JList.Width;
  PagePoint[1].Y := Height - JList.Height;

  // Initialise Form Sizes
  InitSize.Y := 385;
  InitSize.X := 627;

  self.Height := InitSize.Y;
  self.Width  := InitSize.X;

  Constraints.MinHeight  := InitSize.Y - 1;
  Constraints.MinWidth   := InitSize.X;

  // Initialise internal variables
  DisplayTrans := NIL;
//  StoreCoord := BOff;
  Populating := BOff;

  // Load colours/positions/sizes/etc...
  DoneRestore := False;
  SetColoursAndPositions (0);

End; { Create }

//-------------------------------------------------------------------------

procedure TfrmJobLineDrill.FormDestroy(Sender: TObject);
begin
  if Assigned(DisplayTrans) then
    FreeAndNIL(DisplayTrans);

  // Remove global reference to form
  frmJobLines := nil;

  // Close the global Settings object (it will be automatically recreated
  // when needed -- see uSettings.pas, function oSettings.
  oSettings.Free;

  // MH 11/11/2010 v6.5 ABSEXCH-2930: Switched to reference counting to prevent files being closed whilst another window open
  // Closes any open data files in the range CustF (1) to SysF (15)
  //CloseDataFiles;
  EnterpriseData.RemoveReferenceCount;
end;

//-------------------------------------------------------------------------

procedure TfrmJobLineDrill.FormResize(Sender: TObject);
Begin
  JList.Width  := Width  - PagePoint[1].X;
  JList.Height := Height - PagePoint[1].Y;
  BtnPanel.Left := JList.Left + JList.Width + 4;
  BtnPanel.Top  := JList.Top - 2;
  BtnPanel.Height := JList.Height + 4;
//  JList.DesignColumns[3].Width := 100 + (Width - InitSize.X);
End;

//-------------------------------------------------------------------------

procedure TfrmJobLineDrill.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
Begin
  CanClose := CheckListFinished;
end;

//-------------------------------------------------------------------------

procedure TfrmJobLineDrill.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  if StoreCoordFlg.Checked then
    SetColoursAndPositions(1)
  else if ResetCoordinates1.Checked then
    SetColoursAndPositions(2);
  Action := caFree;
  frmJobLines := nil;
end;

//-------------------------------------------------------------------------

procedure TfrmJobLineDrill.StartList;
Begin { StartList }
  lblCompany.Caption  := FCompanyCode;
  lblGLCode.Caption   := IntToStr(FGLCode);
  lblFrom.Caption     := PPR_OutPr(FStartPeriod, FStartYear);
  lblTo.Caption       := PPR_OutPr(FEndPeriod, FEndYear);
  lblJobCode.Caption  := FJobCode;
  lblCurrency.Caption := SyssCurr.Currencies[FCurrency].Desc;

  if (FAnalysisCode = '') then
    lblAnalysisCode.Caption := 'All'
  else
    lblAnalysisCode.Caption := FAnalysisCode;

  if (FStockCode = '') then
    lblStockCode.Caption := 'All'
  else
    lblStockCode.Caption := FStockCode;

  if (FAccountCode = '') then
    lblAccountCode.Caption := 'All'
  else
    lblAccountCode.Caption := FAccountCode;

  if (FCostCentre = '') then
    lblCostCentre.Caption := 'All'
  else
    lblCostCentre.Caption := FCostCentre;

  if (FDepartment = '') then
    lblDepartment.Caption := 'All'
  else
    lblDepartment.Caption := FDepartment;

  if (FLocation = '') then
    lblLocation.Caption := 'All'
  else
    lblLocation.Caption := FLocation;

  // Setup the multi-list
  FormBuildList(BOn);
End; { StartList }

//-------------------------------------------------------------------------

procedure TfrmJobLineDrill.FormBuildList(ShowLines  :  Boolean);
begin
  BuildLines;
end;

//-------------------------------------------------------------------------

Procedure TfrmJobLineDrill.SetCompanyCode (Value : ShortString);
Begin { SetCompanyCode }
  If (Value <> FCompanyCode) Then
    FCompanyCode := Value;
End; { SetCompanyCode }

//-------------------------------------------------------------------------

procedure TfrmJobLineDrill.SetCostCentre(const Value: ShortString);
begin
  If (Value <> FCostCentre) Then
    FCostCentre := Value;
end;

//-------------------------------------------------------------------------

Procedure TfrmJobLineDrill.SetCurrency (Value : Byte);
Begin { SetCurrency }
  If (Value <> FCurrency) Then
    FCurrency := Value;
End; { SetCurrency }

//-------------------------------------------------------------------------

procedure TfrmJobLineDrill.SetDepartment(const Value: ShortString);
begin
  If (Value <> FDepartment) Then
    FDepartment := Value;
end;

//-------------------------------------------------------------------------

Procedure TfrmJobLineDrill.SetGLCode (Value : LongInt);
Begin { SetGLCode }
  If (Value <> FGLCode) Then
    FGLCode := Value;
End; { SetGLCode }

//-------------------------------------------------------------------------

Procedure TfrmJobLineDrill.SetGLDescr (Value : ShortString);
Begin { SetGLDescr }
  If (Value <> FGLDescr) Then
    FGLDescr := Value;
End; { SetGLDescr }

//-------------------------------------------------------------------------

Procedure TfrmJobLineDrill.SetMode (Value : TJobDrillMode);
Begin { SetMode }
  If (Value <> FMode) Then
    FMode := Value;
End; { SetMode }

//-------------------------------------------------------------------------

procedure TfrmJobLineDrill.PropFlgClick(Sender: TObject);
begin
  SetFormProperties;
end;

//-------------------------------------------------------------------------

procedure TfrmJobLineDrill.StoreCoordFlgClick(Sender: TObject);
begin
//  StoreCoord := StoreCoordFlg.Checked;
  if StoreCoordFlg.Checked then
    ResetCoordinates1.Checked := False;
end;

//-------------------------------------------------------------------------

procedure TfrmJobLineDrill.SetColoursAndPositions (Const Mode : Byte);
var
  WantAutoSave : Boolean;
begin
  case Mode of
    0 : begin
          oSettings.LoadForm (Self, WantAutoSave);
          StoreCoordFlg.Checked := False;
          oSettings.LoadList (JList, Self.Name);
        end;
    1 : if (not DoneRestore) Then
        begin
          // Only save the details if the user didn't select Restore Defaults
          oSettings.SaveForm (Self, StoreCoordFlg.Checked);
          oSettings.SaveList (JList, Self.Name);
        end; // If (Not DoneRestore)
    2 : begin
          DoneRestore := True;
          oSettings.RestoreFormDefaults (Self.Name);
          oSettings.RestoreListDefaults (JList, Self.Name);
          StoreCoordFlg.Checked := False;
        end;
  else
    raise Exception.Create ('TfrmJobLineDrill.SetColoursAndPositions - Unknown Mode (' + IntToStr(Ord(Mode)) + ')');
  end; // Case Mode
end;

//-------------------------------------------------------------------------

procedure TfrmJobLineDrill.SetFormProperties;
var
  ResetDefaults: Boolean;
begin
  ResetDefaults := BOff;
  Hide;
  try
    // Call the colours dialog
    case oSettings.Edit(JList, Self.Name, nil) of
      mrRestoreDefaults : SetColoursAndPositions(2);
    end; // Case oSettings.Edit(...
  finally
    Show;
  end;
  if (ResetDefaults) then
  begin
    SetDefault := BOn;
    Close;
  end;
end;

//-------------------------------------------------------------------------

function TfrmJobLineDrill.CheckListFinished : Boolean;
begin
  Result := not Populating;
end;

//-------------------------------------------------------------------------

procedure TfrmJobLineDrill.ViewTransaction1Click(Sender: TObject);
var
  FolioRef: Integer;
begin
  if (JList.Selected > -1) then
  begin
    FolioRef := Integer(JList.DesignColumns[COL_OREF].Items.Objects[JList.Selected]);
    Display_Trans (FolioRef, False);
  end;
end;

//-------------------------------------------------------------------------

procedure TfrmJobLineDrill.Display_Trans (Const IdFolio : LongInt; Const DataChanged : Boolean);
Var
  KeyS    : Str255;
  lStatus : SmallInt;
Begin { Display_Trans }
  // Load Transaction
  KeyS := FullNomKey (IdFolio);
  lStatus := Find_Rec (B_GetEq, F[InvF], InvF, RecPtr[InvF]^, InvFolioK, KeyS);

  If (lStatus = 0) And (Not (Inv.InvDocHed In NomSplit + StkAdjSplit + TSTSplit)) Then Begin
    // Load Customer
    KeyS := FullCustCode(Inv.CustCode);
    lStatus := Find_Rec (B_GetEq, F[CustF], CustF, RecPtr[CustF]^, CustCodeK, KeyS);
  End; { If (lStatus = 0) }

  If (lStatus = 0) Then Begin
    // Check the transaction display manager has been created
    If Not Assigned (DisplayTrans) Then
      DisplayTrans := TfrmDisplayTransManager.Create(Self);

    // Display the Transaction
    DisplayTrans.Display_Trans(Inv, Cust, DataChanged);

  End; { If (lStatus = 0) }
end;

//-------------------------------------------------------------------------

// IMPORTANT NOTE: This message handler is required to ensure the form stays
// on top, as it has a habit of losing its Stay-On-Top'ness at runtime.
procedure TfrmJobLineDrill.WMWindowPosChanged(var Msg : TMessage);
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

//-------------------------------------------------------------------------

procedure TfrmJobLineDrill.PopupMenuPopup(Sender: TObject);
begin
//  StoreCoordFlg.Checked := StoreCoord;
  ViewTransaction1.Enabled := (JList.Selected > -1);
end;

//-------------------------------------------------------------------------

procedure TfrmJobLineDrill.ResetCoordinates1Click(Sender: TObject);
begin
  if ResetCoordinates1.Checked then
    StoreCoordFlg.Checked := False;
end;

//-------------------------------------------------------------------------

procedure TfrmJobLineDrill.SetEndPeriod(const Value: SmallInt);
begin
  If (Value <> FEndPeriod) Then
    FEndPeriod := Value;
end;

//-------------------------------------------------------------------------

procedure TfrmJobLineDrill.SetEndYear(const Value: SmallInt);
begin
  If (Value <> FEndYear) Then
    FEndYear := Value;
end;

//-------------------------------------------------------------------------

procedure TfrmJobLineDrill.SetStartPeriod(const Value: SmallInt);
begin
  If (Value <> FStartPeriod) Then
    FStartPeriod := Value;
end;

//-------------------------------------------------------------------------

procedure TfrmJobLineDrill.SetStartYear(const Value: SmallInt);
begin
  If (Value <> FStartYear) Then
    FStartYear := Value;
end;

//-------------------------------------------------------------------------

procedure TfrmJobLineDrill.BuildLines;
const
  FNum = JDetlF;
var
  KeyS, KeyChk, KeyS2 : Str255;
  GotCC, GotDept, GotAc, GotStock, GotLoc, GotAnal, WantTrans : Boolean;
  KPath               : Integer;
  Status: SmallInt;
  LineAmt: Double;
  UOR      : Byte;
  OurRef: ShortString;
  DateStr: ShortString;
  GLActuals: Double;
  RecCount: Integer;
begin
  GotAnal  := (FAnalysisCode <> '');
  GotStock := (FStockCode <> '');
  GotLoc   := (FLocation <> '');
  GotCC    := (FCostCentre <> '');
  GotDept  := (FDepartment <> '');
  GotAc    := (FAccountCode <> '');

  if (FStartYear > 1900) then
    FStartYear := FStartYear - 1900;

  if (FEndYear > 1900) then
    FEndYear := FEndYear - 1900;

  GLActuals := 0.00;
  RecCount  := 0;

  Populating := BOn;
  { Pass through the posted Job Actuals for the Job/Currency }
  if GotAnal Then Begin
    { Use Job-Analysis Index - 01 - (RecPfix+SubType) +  AnalKey + Cr+Yr+Pr }
    KPath := JDAnalK;

    If (FCurrency > 0) Then Begin
      KeyS := FullNHistKey(PartCCKey(JBRCode, JBECode),
                           FullJobCode(FJobCode) + FullJACode(FAnalysisCode),
                           FCurrency,
                           FStartYear,
                           FStartPeriod);
      KeyChk := KeyS;
      SetLength(KeyChk, 23);
    End { If }
    Else Begin
      KeyS := PartCCKey(JBRCode, JBECode) + FullJobCode(FJobCode) + FullJACode(FAnalysisCode);
      KeyChk := KeyS;
    End; { Else }
  End { If }
  Else Begin
    { Use Job Index }
    KPath := JDLedgerK;

    If (FCurrency > 0) Then Begin
      { Specific Currency }
      KeyS := FullJAKey (JBRCode, JBECode, FullJobCode(FJobCode))+#1+Chr(FCurrency)
    End { If }
    Else Begin
      { All Currencies }
      KeyS := FullJAKey (JBRCode, JBECode, FullJobCode(FJobCode))+#1;
    End; { Else }

    KeyChk := KeyS;
  End; { Else }
  Status := Find_Rec(B_GetGEq, F[FNum], FNum, RecPtr[FNum]^, KPath, KeyS);

  while (Status = 0) And CheckKey(KeyS, KeyChk, Length(KeyChk), BOn) do
  begin
    with JobDetl.JobActual Do Begin
      { Check date is in range and its posted }
      If (Pr2Fig(ActYr,ActPr) >= Pr2Fig(FStartYear, FStartPeriod)) And
         (Pr2Fig(ActYr,ActPr) <= Pr2Fig(FEndYear, FEndPeriod)) And
         Posted Then Begin

        { Check GL Code }
        WantTrans := (OrigNCode = FGLCode);

        If WantTrans And GotStock Then Begin
          WantTrans := (FStockCode = Trim(JobDetl.JobActual.StockCode));
        End; { If }

        { Check its a document type we want }
        If WantTrans Then Begin
          { Link to Transaction Line }
          KeyS2 := FullNomKey(LineFolio) + FullNomKey(LineNo);
          Status := Find_Rec(B_GetEq, F[IDetailF], IDetailF, RecPtr[IDetailF]^, IdLinkK, KeyS2);
          If (Status = 0) And (Id.FolioRef = LineFolio) And (Id.ABSLineNo = LineNo) Then Begin
            { Check Document Type }
            WantTrans := Not (Id.IdDocHed In PSOPSet +
                                              QuotesSet +
                                              StkAdjSplit +
                                              TSTSplit);

            { Check Location if req }
            If WantTrans And GotLoc Then Begin
              WantTrans := (FLocation = Id.MLocStk);
            End; { If }


            { Check Account if req }
            If WantTrans And GotAc Then Begin
              WantTrans := (FAccountCode = Id.CustCode);
            End; { If }

            { Check Cost Centre if req }
            If WantTrans And GotCC Then Begin
              WantTrans := (FCostCentre = Id.CCDep[True]);
            End; { If }

            { Check Department if req }
            If WantTrans And GotDept Then Begin
              WantTrans := (FDepartment = Id.CCDep[False]);
            End; { If }

            If WantTrans Then Begin
              { Do the Biz - Calc line total in transaction currency }
              LineAmt := DetLTotal (Id, False, False, 0.0) * DocNotCnst;

              if (FCurrency = 0) and (FCurrency <> Id.Currency) then
              begin
                { Convert to Consolidated if not already consolidated }
                UOR := fxUseORate(False, BOn, Id.CXRate, Id.UseORate, Id.Currency, 0);
                LineAmt := Round_Up(Conv_TCurr(LineAmt, XRate(Id.CXRate, False, Id.Currency), Id.Currency, UOR, False), 2);
              end; { If }

              { Add the line to the multilist }

              // OurRef
              if (Trim(Id.DocPRef) <> '') and (Id.IdDocHed <> RUN) then
                OurRef := Id.DocPRef
              else
                OurRef := DocCodes[Id.IdDocHed];
              JList.DesignColumns[COL_OREF].Items.AddObject(OurRef, Pointer(Id.FolioRef));

              // Year / Period
              JList.DesignColumns[COL_YRPR].Items.Add(PPR_OutPr(Id.PPr, Id.PYr));

              // Account Code
              JList.DesignColumns[COL_ACCT].Items.Add(Id.CustCode);

              // Description
              JList.DesignColumns[COL_DESC].Items.Add(Id.Desc);

              // Amount
              JList.DesignColumns[COL_AMNT].Items.Add(FormatFloat(GenRealMask, LineAmt));

              // Status
              JList.DesignColumns[COL_STAT].Items.Add(GetReconcileStatus(Id.Reconcile));

              // Date
              if (Id.IdDocHed <> RUN) Or (Id.PostedRun = PayInRunNo) Then
                DateStr := POutDate(Id.PDate)
              else
                DateStr := Id.PDate;
              JList.DesignColumns[COL_DATE].Items.Add(DateStr);

              GLActuals := GLActuals + LineAmt;
              RecCount  := RecCount  + 1;

            End; { If }
          End; { If }
        End; { If }
      End; { If }
    End; { With }

    Status:= Find_Rec(B_GetNext, F[FNum], FNum, RecPtr[FNum]^, KPath, KeyS);

    Application.ProcessMessages;

  End; { While }

  Populating := BOff;

  StatusBar.Panels[0].Text := Format('Records found: %d', [RecCount]);
  StatusBar.Panels[1].Text := Format('Total amount: %.2n', [GLActuals]);

end;

//-------------------------------------------------------------------------

procedure TfrmJobLineDrill.SetAccountCode(const Value: ShortString);
begin
  If (Value <> FAccountCode) Then
    FAccountCode := Value;
end;

//-------------------------------------------------------------------------

procedure TfrmJobLineDrill.SetAnalysisCode(const Value: ShortString);
begin
  If (Value <> FAnalysisCode) Then
    FAnalysisCode := Value;
end;

//-------------------------------------------------------------------------

procedure TfrmJobLineDrill.SetJobCode(const Value: ShortString);
begin
  If (Value <> FJobCode) Then
    FJobCode := Value;
end;

//-------------------------------------------------------------------------

procedure TfrmJobLineDrill.SetLocation(const Value: ShortString);
begin
  If (Value <> FLocation) Then
    FLocation := Value;
end;

//-------------------------------------------------------------------------

procedure TfrmJobLineDrill.SetStockCode(const Value: ShortString);
begin
  If (Value <> FStockCode) Then
    FStockCode := Value;
end;

//-------------------------------------------------------------------------

procedure TfrmJobLineDrill.JListRowDblClick(Sender: TObject;
  RowIndex: Integer);
begin
  PostMessage(self.Handle, WM_VIEWTRANSACTION, 0, 0);
end;

//-------------------------------------------------------------------------

procedure TfrmJobLineDrill.WMViewTransaction(var Msg: TMessage);
begin
  ViewTransaction1Click(nil);
end;

//-------------------------------------------------------------------------

procedure TfrmJobLineDrill.JListClick(Sender: TObject);
var
  FolioRef: Integer;
begin
  if (JList.Selected > -1) then
  begin
    FolioRef := Integer(JList.DesignColumns[COL_OREF].Items.Objects[JList.Selected]);
    Display_Trans (FolioRef, True);
  end;
end;

//-------------------------------------------------------------------------

initialization
  frmJobLines := nil;

end.
