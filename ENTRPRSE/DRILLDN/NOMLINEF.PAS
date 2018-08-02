unit NomLineF;

{$ALIGN 1}

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, SBSPanel, Menus, 
  GlobVar,       // Exchequer global const/type/var
  VarConst,      // Exchequer global const/type/var
  SBSComp,       // Btrieve List Routines
  SupListU,      // Btrieve List Classes (TGenList)
  SBSComp2,      // Routines for Loading/Saving Window Colours/Co-Ordinates
  ExWrap1U,      // Btrieve File Wrapper Object
  BTRVU2,
  BTSupU1,       // Custom Messages and Misc Btrieve Routines
  EBGLLine,      // Extended Btrieve Ops class for reading Transaction Lines for GL Drill-Down
  DispDocF,      // Parent Window for displaying Transaction Details
  Recon3U;       // Extended Btrieve Ops classes for reading data

type
  // Display modes for the GL Drill-Down
  TGLDrillMode = (glOnly,           // Base GL functions e.g. entGLActual
                  glCC,             // Cost Centre functions e.g. entGLCCActual
                  glDept,           // Department functions e.g. entGLDPActual
                  glCCDept,         // Cost Centre and Department functions e.g. entGLCCDpActual
                  glCommit,         // Committed GL functions e.g. entGLCOMActual
                  glCommitCCDept);  // Committed Cost Centre and Department functions e.g. entGLCCDpCOMActual

  // Data access modes to identify how the data is to be retrieved
  TGLDrillDataAccessMode = (daFullIdx,        // Index: NomCode + NomMode + Ccy + Year + Period
                            daPartIdx2Segs,   // Index: NomCode + NomMode
                            daPartIdx3Segs,   // Index: NomCode + NomMode + Ccy
                            daFilter1,        // ExBtr: NomCode + NomMode + Year + Period
                            daFilter2,        // ExBtr: NomCode + NomMode + Ccy + Year + Period
                            daFilter3,        // ExBtr: NomCode + NomMode + Ccy + Year
                            daFilter4);       // ExBtr: NomCode + NomMode + Ccy + Year + Period + CC + Dept

Const
  // The set of Data Access Modes which utilise extended Btrieve Operations
  TGLDrillExtBtrDataModeSet = [daFilter1, daFilter2, daFilter3, daFilter4];

  // The set of Display Modes which display commitment accounting lines
  TGLDrillModeCommitSet = [glCommit, glCommitCCDept];

Type
  //---------------------------

  TGLLinesList = Class(TGenList)
  Private
  Public
    // Properties to control the loading of the Transaction Lines
    lstDataMode    : TGLDrillDataAccessMode;
    lstMode        : TGLDrillMode;
    lstCurrency    : Byte;
    lstGLCode      : LongInt;
    lstGLType      : Char;
    lstPeriod      : SmallInt;
    lstYear        : SmallInt;
    lstInCcy       : Boolean;      // True = Specific Currency, False = Consolidated
    lstCostCentre  : String[3];
    lstDepartment  : String[3];

    // Extended Btrieve Operations object
    DataObj        : ^TExtBtrieveGLLines;

    Procedure ExtObjCreate; Override;
    Procedure ExtObjDestroy; Override;

    Function ExtFilter : Boolean; Override;
    Function GetExtList(B_End : Integer; Var KeyS : Str255)  :  Integer; Override;

    Function OutLine (Col : Byte) : Str255; Override;
    Function SetCheckKey : Str255; Override;
    Function SetFilter  :  Str255; Override;
  End; { TGLLinesList }

  //---------------------------

  TfrmGLLineDrill = class(TForm)
    D1SBox: TScrollBox;
    D1HedPanel: TSBSPanel;
    D1ORefLab: TSBSPanel;
    D1DateLab: TSBSPanel;
    D1AccLab: TSBSPanel;
    D1AmtLab: TSBSPanel;
    D1StatLab: TSBSPanel;
    D1DesLab: TSBSPanel;
    D1DatLab: TSBSPanel;
    D1ORefPanel: TSBSPanel;
    D1DatePanel: TSBSPanel;
    D1AccPanel: TSBSPanel;
    D1DesPanel: TSBSPanel;
    D1AmtPanel: TSBSPanel;
    D1StatPanel: TSBSPanel;
    D1DatPanel: TSBSPanel;
    D1ListBtnPanel: TSBSPanel;
    PopupMenu1: TPopupMenu;
    PropFlg: TMenuItem;
    N1: TMenuItem;
    StoreCoordFlg: TMenuItem;
    N2: TMenuItem;
    ViewTransaction1: TMenuItem;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormActivate(Sender: TObject);
    procedure FormResize(Sender: TObject);
    procedure D1ORefPanelMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure D1ORefLabMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure D1ORefLabMouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure PropFlgClick(Sender: TObject);
    procedure StoreCoordFlgClick(Sender: TObject);
    procedure ViewTransaction1Click(Sender: TObject);
    procedure PopupMenu1Popup(Sender: TObject);
  private
    { Private declarations }
    FCompanyCode : ShortString;
    FCostCentre  : ShortString;
    FCurrency    : Byte;
    FDepartment  : ShortString;
    FGLCode      : LongInt;
    FGLDescr     : ShortString;
    FGLType      : Char;
    FMode        : TGLDrillMode;
    FPeriod      : SmallInt;
    FYear        : SmallInt;

    ReadFormPos  : Boolean;
    GotCoord     : Boolean;
    LastCoord    : Boolean;
    SetDefault   : Boolean;
    StoreCoord   : Boolean;
    StartSize    : TPoint;
    InitSize     : TPoint;
    PagePoint    : Array[1..3] of TPoint;

    fNeedCUpdate : Boolean;
    SysMenuH     : HWnd;

    DisplayTrans : TfrmDisplayTransManager;

    Procedure SetCompanyCode (Value : ShortString);
    procedure SetCostCentre(const Value: ShortString);
    Procedure SetCurrency (Value : Byte);
    procedure SetDepartment(const Value: ShortString);
    Procedure SetGLCode (Value : LongInt);
    Procedure SetGLDescr (Value : ShortString);
    Procedure SetMode (Value : TGLDrillMode);
    Procedure SetPeriod (Value : SmallInt);
    Procedure SetYear (Value : SmallInt);

    Function  CheckListFinished : Boolean;
    procedure Display_Trans (Const IdFolio : LongInt; Const DataChanged : Boolean);
    procedure Find_FormCoord;
    procedure FormBuildList(ShowLines : Boolean);
    procedure RefreshList (ShowLines, IgMsg : Boolean);
    procedure FormSetOffSet;
    procedure SetFormProperties;
    Procedure SetNeedCUpdate (B : Boolean);
    procedure ShowRightMeny(X,Y,Mode  :  Integer);
    procedure Store_FormCoord(UpMode  :  Boolean);
    Procedure WMCustGetRec(Var Message  :  TMessage); Message WM_CustGetRec;
    procedure WMWindowPosChanged(var Msg : TMessage); Message WM_WindowPosChanged;

    Property NeedCUpDate : Boolean Read fNeedCUpDate Write SetNeedCUpdate;
  public
    // Public Variables
    ExLocal    :  TdExLocal;
    MULCtrlO   :  TGLLinesList;
    ListOfSet  :  Integer;

    // Public Properties
    Property glCompanyCode : ShortString Read FCompanyCode Write SetCompanyCode;
    Property glCostCentre : ShortString Read FCostCentre Write SetCostCentre;
    Property glCurrency : Byte Read FCurrency Write SetCurrency;
    Property glDepartment : ShortString Read FDepartment Write SetDepartment;
    Property glGLCode : LongInt Read FGLCode Write SetGLCode;
    Property glGLdescr : ShortString Read FGLDescr Write SetGLDescr;
    Property glGLType : Char Read FGLType Write FGLType;
    Property glMode : TGLDrillMode Read FMode Write SetMode;
    Property glPeriod : SmallInt Read FPeriod Write SetPeriod;
    Property glYear : SmallInt Read FYear Write SetYear;

    // Public Methods
    procedure StartList;
  end;


Function NewGLLines : TfrmGLLineDrill;

implementation

{$R *.dfm}

Uses ComnU2,         // Exchequer Misc Routines
     ComnUnit,
     ETStrU,
     ETMiscU,
     ETDateU,
     CurrncyU,
     CmpCtrlU,       // Misc Routines for loading/saving Colours & Positions
     ColCtrlU,       // Form Color/Font Properties Window
     EntData,        // EntData object
     EntLicence,     // Global Exchequer Licence object
     MainF,          // Main form & Debug window
     BTKeys1U;       // Exchequer Search Key utilities

Var
  frmGLLines : TfrmGLLineDrill;

//=========================================================================

Function NewGLLines : TfrmGLLineDrill;
Begin { NewGLLines }
  Result := NIL;

  If Assigned(frmGLLines) Then
    Try
      // Try to access the caption to determine whether the form is still
      // in existance - if not then should get an Access Violation
      If (frmGLLines.Caption <> '') Then
        Result := frmGLLines;
    Except
      On Exception Do
        ;
    End;

  // If no pre-existing form then create a new one
  If (Not Assigned(Result)) Then
    Result := TfrmGLLineDrill.Create (NIL);

  // Record global reference to form for later use
  frmGLLines := Result;
End; { NewGLLines }

//=========================================================================

Procedure TGLLinesList.ExtObjCreate;
Begin { ExtObjCreate }
  Inherited;

  If (lstDataMode in TGLDrillExtBtrDataModeSet) Then Begin
    // Create Extended Btrieve Ops sub-object
    New (DataObj, Init);
    ExtObjPtr := DataObj;

    ExtRecPtr := Pointer(1);
  End { If (lstDataMode in TGLDrillExtBtrDataModeSet) }
  Else Begin
    DataObj := NIL;
    ExtRecPtr := NIL;
  End; { Else }
End; { ExtObjCreate }

//-------------------------

Procedure TGLLinesList.ExtObjDestroy;
Begin { ExtObjDestroy }
  If Assigned(DataObj) Then Dispose (DataObj, Done);
  DataObj := NIL;
  ExtRecPtr := NIL;

  Inherited;
End; { ExtObjDestroy }

//-------------------------

Function TGLLinesList.ExtFilter : Boolean;
Begin { ExtFilter }
            // Must either be Posted if not displaying commitment or marked as commitment
  Result := (
              ((Id.PostedRun > 0) And (Not (lstMode In TGLDrillModeCommitSet))) Or      // Non-Commitment
              ((Id.PostedRun = CommitOrdRunNo) And (lstMode In TGLDrillModeCommitSet))  // Commitment
            ) And
            // GL Code must match exactly
            (Id.NomCode = lstGLCode) And
            // Currency must match unless we are displaying Consolidated figures
            ((Id.Currency = lstCurrency) Or (lstCurrency = 0)) And
            // Year must match except for mode 0 where we display up to and including the specified
            // year unless its a P&L GL Code in which case we just show the current year
            (
              (Id.PYr = lstYear) Or                                                    // Matches
              ((lstPeriod = 0) And (Id.PYr <= lstYear) And (lstGLType <> PLNHCode)) Or // Period 0
              ((lstPeriod = -98) And (lstGLType <> PLNHCode))                          // Period -98
            ) And
            // Period must match except for Modes 0 and -98 where all periods are shown and
            // except for Mode 101-199 where we are displaying year-to-date
            (
              (Id.PPr = lstPeriod) Or                                                // Matches
              (lstPeriod = 0) Or                                                     // Period 0
              (lstPeriod = -98) Or                                                   // Period -98
              ((lstPeriod > 100) And (Id.PPr <= (lstPeriod - 100)))                  // Period 1xx
            ) And
            // Cost Centre must match if specified
            ((lstCostCentre = '') Or (Id.CCDep[True] = lstCostCentre)) And
            // Department must match if specified
            ((lstDepartment = '') Or (Id.CCDep[False] = lstDepartment));

  {$IFDEF DRILLDEBUG}
    frmMainDebug.DebugStr(Format ('ExtFilter (Ref=%s,GL=%d,Ccy=%d,Per=%d/%d, CC/DP=%s/%s) : %s',
                                  [Id.DocPRef,      Id.NomCode,   Id.Currency,
                                   Id.Ppr,          Id.PYr,       Id.CCDep[True],
                                   Id.CCDep[False], BoolToStr(Result,True)]));
  {$ENDIF} // DRILLDEBUG
End; { ExtFilter }

//-------------------------

Function TGLLinesList.GetExtList(B_End : Integer; Var KeyS : Str255) : Integer;
Var
  lStatus, Period : Integer;
  Period1xx       : Boolean;

  Function CalcFilter4Conditions : TFilter4ConditionsType;
  Begin { CalcFilter4Conditions }
    FillChar (Result, SizeOf(Result), #0);
    With Result Do Begin
      // Set currency compare mode - common across all data access methods
      If lstInCcy Then
        CcyCompareMode := cmpEqual
      Else
        // CJS 23/03/2011 - ABSEXCH-10164
        CcyCompareMode := cmpGreaterThanOrEqual; // Previously was cmpGreaterThan;
      CcyCompareVal := lstCurrency;

      //------------------------------

      // Set CC/Dept codes as required by the drill-down function type
      CCCompareMode := cmpEqual;
      If (lstMode = glCC) Then Begin
        // GL + CC
        CCCompareVal    := lstCostCentre;
        CCCompareOffset := BtKeyPos(@Id.CCDep,@Id)+4;
//        CCCompareOffset := GECC + 1;
        DeptCompareMode := cmpNotEqual;
        DeptCompareVal  := '   '; // NDXWeight;
      End { If (lstMode = glCC) }
      Else
        If (lstMode = glDept) Then Begin
          // GL + DP
          CCCompareVal    := lstDepartment;
          CCCompareOffset := GEDep + 1;
          DeptCompareMode := cmpNotEqual;
          DeptCompareVal  := '   '; // NDXWeight;
        End { If (lstMode = glDp) }
        Else Begin
          // GL + CC + DP
          CCCompareVal    := lstCostCentre;
          CCCompareOffset := GECC + 1;
          DeptCompareMode := cmpEqual;
          DeptCompareVal  := lstDepartment;
        End; { Else }

      //------------------------------

      // Determine how the data is to be accessed
      If (lstPeriod = -98) Then Begin
        // Everything Ever - list all trans
        YearCompareMode    := cmpNotEqual;
        YearCompareVal     := 255;
        PeriodCompareMode  := cmpNotEqual;
        PeriodCompareVal   := 255;
      End { If (lstPeriod = -98) }
      Else
        If (lstPeriod = 0) Then Begin
          // All Trans up to and including the current year except for P&L GL
          // Codes which just show the current year
          If (lstGLType = PLNHCode) Then
            YearCompareMode    := cmpLessThanOrEqual
          Else
            YearCompareMode    := cmpLessThanOrEqual;
          YearCompareVal     := lstYear;
          PeriodCompareMode  := cmpNotEqual;
          PeriodCompareVal   := 255;
        End { If (lstPeriod = 0) }
        Else
          If (lstPeriod >= 1) And (lstPeriod <= 99) Then Begin
            // Specific Period
            YearCompareMode    := cmpEqual;
            YearCompareVal     := lstYear;
            PeriodCompareMode  := cmpEqual;
            PeriodCompareVal   := lstPeriod;
          End { If (lstPeriod >= 1) And (lstPeriod <= 99) }
          Else
            If (lstPeriod >= 101) And (lstPeriod <= 199) Then Begin
              // Total for the Year from period 1 to X
              YearCompareMode    := cmpEqual;
              YearCompareVal     := lstYear;
              PeriodCompareMode  := cmpLessThanOrEqual;
              PeriodCompareVal   := lstPeriod;
            End; { If (lstPeriod >= 101) And (lstPeriod <= 199) }
    End; { With Result }
  End; { CalcFilter4Conditions }

Begin { GetExtList }
  If (B_End In [B_GetPrev,B_GetNext]) And Assigned(DataObj) then
  Begin
    // Display Please Wait... message
    DispExtMsg(BOn);

    // Locally translate period before data access
    Period1xx := (lstPeriod > 100);
    If Period1xx Then
      Period := lstPeriod - 100
    Else
      Period := lstPeriod;

    // Do extended Btrieve call to get next record
    Case lstDataMode Of
      // ExBtr: NomCode + NomMode + Year + Period / Period <= X
      // Used for Consolidated perdio 1-99 & 1xx
      daFilter1  : lStatus := DataObj.GLFilter1 (B_End+30,                // Btrieve Operation
                                                 ScanFileNum,             // File Number
                                                 KeyPath,                 // Index Number
                                                 KeyS,                    // Search Key
                                                 lstGLCode,
                                                 lstYear,
                                                 Period,
                                                 Not Period1xx);

      // ExBtr: NomCode + NomMode + Ccy + Year + Period / Period <= X
      // Used for non-consolidated 1xx periods
      daFilter2  : lStatus := DataObj.GLFilter2 (B_End+30,                // Btrieve Operation
                                                 ScanFileNum,             // File Number
                                                 KeyPath,                 // Index Number
                                                 KeyS,                    // Search Key
                                                 lstGLCode,
                                                 lstCurrency,
                                                 lstYear,
                                                 Period,
                                                 Not Period1xx);

      // ExBtr: NomCode + NomMode + [Ccy] + (Year<=X | Year=X)
      // Used for Period = 0
      daFilter3  : lStatus := DataObj.GLFilter3 (B_End+30,                // Btrieve Operation
                                                 ScanFileNum,             // File Number
                                                 KeyPath,                 // Index Number
                                                 KeyS,                    // Search Key
                                                 lstGLCode,
                                                 lstCurrency,
                                                 lstInCcy,
                                                 lstYear,
                                                 lstGLType = PLNHCode);   // Only display previous years for non-P&L GL Codes

      // ExBtr: NomCode + NomMode + Ccy + Year + Period + CC + Dept
      // Used for GL + CC and GL + DP
      daFilter4  : lStatus := DataObj.GLFilter4 (B_End+30,                // Btrieve Operation
                                                 ScanFileNum,             // File Number
                                                 KeyPath,                 // Index Number
                                                 KeyS,                    // Search Key
                                                 lstGLCode,
                                                 CalcFilter4Conditions);
    Else
      Raise Exception.Create ('TGLLinesList.GetExtList - Unsupported Data Mode (' + IntToStr(Ord(lstDataMode)) + ')');
    End; { Case lstDataMode }

    {$IFDEF DRILLDEBUG}
      frmMainDebug.DebugStr('GetExtList(' + IntToStr(Ord(lstDataMode)) + '): ' + IntToStr(Ord(lStatus)));
    {$ENDIF} // DRILLDEBUG

    // Hide Please Wait... message
    DispExtMsg(BOff);
  End
  Else
    lStatus := Find_Rec(B_End,F[ScanFileNum],ScanFileNum,RecPtr[ScanFileNum]^,KeyPath,KeyS);

  Result := lStatus;
End; { GetExtList }

//-------------------------

Function TGLLinesList.OutLine (Col : Byte) : Str255;
Var
  //ExLocal  : ^TdExLocal;
  DeductD  : Boolean;
  UOR      : Byte;
  LineBal  : Double;
Begin { OutLine }
  Result := '';

  //ExLocal:=ListLocal;

  With {ExLocal^,} Id Do
    Case Col Of
      // Doc
      0 : If (Trim(DocPRef) <> '') And (IdDocHed <> RUN) Then
            Result := DocPRef
          Else
            Result := DocCodes[IdDocHed];
      // Period
      1 : Result := PPR_OutPr(PPr,PYr);
      // A/C
      2 : Result := CustCode;
      // Description
      3 : Result := Desc;
      // Amount
      4 : Begin
            // Work out whether to deduct discounts from the line totals or not
            DeductD := (IdDocHed = RUN);
            If (Not DeductD) then
              DeductD := Not Syss.SepDiscounts;

            // Calculate the Line total
            LineBal := DetLTotal(Id, DeductD, BOff, 0.0);

            If (EnterpriseLicence.elCurrencyVersion <> cvPro) Then Begin
              // Euro/Global - Convert the balance to the appropriate currency
              If (lstCurrency = 0) Then
              Begin
                // Consolidated
                UOR:=fxUseORate(BOff,BOn,CXRate,UseORate,Currency,0);

                LineBal:=Conv_TCurr(LineBal,XRate(CXRate,BOff,Currency),Currency,UOR,BOff);

                Result := SSymb(0)
              End { If (NHCr=0) }
              Else
                // Start amount string with currency symbol
                Result := SSymb(Currency)
            End; { If (EnterpriseLicence.elCurrencyVersion <> cvPro) }

            Result := Result + FormatFloat(GenRealMask,LineBal);
          End;
      // Status
      5 : Begin
            {If (PostedRun = PayInRunNo) then
              Result := GetPayInStatus(Reconcile)
            Else}
              Result := GetReconcileStatus(Reconcile);
          End;
      // Date
      6 : If (IdDocHed <> RUN) Or (PostedRun = PayInRunNo) Then
            Result := POutDate(PDate)
          Else
            Result := PDate;
    Else
      Result := '?';
    End; { Case Col }
End; { OutLine }

//-------------------------

Function TGLLinesList.SetCheckKey : Str255;
Var
  DumStr    :  Str255;
Begin { SetCheckKey }
  FillChar(DumStr,Sizeof(DumStr),0);

  With Id Do
    DumStr := FullNomKey(NomCode) + Chr(NomMode) + Chr(Currency) + Chr(PYr) + Chr (PPr);

  {$IFDEF DRILLDEBUG}
    frmMainDebug.DebugStr(Format ('SetCheckKey (Doc=%s,GL=%d,NM=%d,Ccy=%d,Per=%d/%d,Run=%d,CC/Dept=%s/%s)',
                                  [Id.DocPRef,   Id.NomCode,     Id.NomMode,
                                   Id.Currency,  Id.Ppr,         Id.PYr,
                                   Id.PostedRun, Id.CCDep[True], Id.CCDep[False]]));
  {$ENDIF} // DRILLDEBUG

  Result := DumStr;
End; { SetCheckKey }

//-------------------------

Function TGLLinesList.SetFilter : Str255;
Begin { SetFilter }
  If ExtFilter Then
    Result := FullNomKey(Id.PostedRun)
  Else
    // Filter out unposted transactions in conjunction with SetFilter
    // MH 24/05/2017 ABSEXCH-18546 2016-R2: List filtering out any TL's where the first byte
    //                                      of the Posting Run No is 255
    //Result := NDXWeight;
    Result := NDXWeight + NDXWeight + NDXWeight + #127;

  {$IFDEF DRILLDEBUG}
    frmMainDebug.DebugStr('SetFilter: ' + BoolToStr(Result<>NDXWeight + NDXWeight + NDXWeight + #127,True));
  {$ENDIF} // DRILLDEBUG
End; { SetFilter }

//=========================================================================

procedure TfrmGLLineDrill.FormCreate(Sender: TObject);
Var
  n : Integer;
begin
  // MH 11/11/2010 v6.5 ABSEXCH-2930: Switched to reference counting to prevent files being closed whilst another window open
  EnterpriseData.AddReferenceCount;

  // Create data interface object for list
  ExLocal.Create;

  // Initialise scroll-bar positions
  For N := 0 To Pred(ComponentCount) Do
    If (Components[n] is TScrollBox) Then
      With TScrollBox(Components[N]) Do Begin
        VertScrollBar.Position := 0;
        HorzScrollBar.Position := 0;
      End; { With TScrollBox(Components[n]) }
  VertScrollBar.Position:=0;
  HorzScrollBar.Position:=0;

  // Initialise Form Sizes
  InitSize.Y := 199;
  InitSize.X := 477;
  Self.ClientHeight := InitSize.Y;
  Self.ClientWidth  := InitSize.X;
  Constraints.MinHeight  := InitSize.Y - 1;
  Constraints.MinWidth   := InitSize.X - 1;

  // Initialise internal variables
  DisplayTrans := NIL;
  LastCoord := BOff;
  NeedCUpdate := BOff;
  StoreCoord := BOff;
  ReadFormPos := BOff;
End; { Create }

//-------------------------

procedure TfrmGLLineDrill.FormDestroy(Sender: TObject);
begin
  If Assigned(DisplayTrans) Then
    FreeAndNIL(DisplayTrans);

  // Remove global reference to form
  frmGLLines := NIL;

  ExLocal.Destroy;

  // MH 11/11/2010 v6.5 ABSEXCH-2930: Switched to reference counting to prevent files being closed whilst another window open
  // Closes any open data files in the range CustF (1) to SysF (15)
  //CloseDataFiles;
  EnterpriseData.RemoveReferenceCount;
end;

//-------------------------

procedure TfrmGLLineDrill.FormActivate(Sender: TObject);
begin
  If Assigned(MULCtrlO) Then
    MULCtrlO.SetListFocus;
end;

//-------------------------

procedure TfrmGLLineDrill.FormResize(Sender: TObject);
Begin
  If GotCoord {and (Not fDoingClose)} then
  Begin
    If Assigned(MULCtrlO) Then MULCtrlO.LinkOtherDisp:=BOff;

    Self.HorzScrollBar.Position:=0;
    Self.VertScrollBar.Position:=0;

    // Resize Scrollbox containing the list
    D1SBox.Width  := ClientWidth - PagePoint[1].X;
    D1SBox.Height := ClientHeight - PagePoint[1].Y;

    // Resize panel containing Btrieve Up/Down buttons
    D1ListBtnPanel.Left   := ClientWidth - PagePoint[2].X;
    D1ListBtnPanel.Height := ClientHeight - PagePoint[2].Y;

    If Assigned(MULCtrlO) Then
    Begin
      With MULCtrlO.VisiList Do
      Begin
        VisiRec:=List[0];

        With (VisiRec^.PanelObj as TSBSPanel) do
          Height:= D1SBox.ClientHeight - PagePoint[3].Y;
      End; { With MULCtrlO.VisiList  }

      With MULCtrlO Do
      Begin
        ReFresh_Buttons;

        RefreshAllCols;
      End; { With MULCtrlO }

      MULCtrlO.LinkOtherDisp:=BOn;
    End;{ If Assigned(MULCtrlO) }

    NeedCUpdate:=((StartSize.X<>Width) or (StartSize.Y<>Height));
  end; {If time to update}
End;

//-------------------------

procedure TfrmGLLineDrill.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
Var
  n  : Integer;
Begin
  //GenCanClose(Self,Sender,CanClose,BOn);

  CanClose:=CheckListFinished;

  If CanClose then
  Begin
    For n:=0 to Pred(ComponentCount) do
      If (Components[n] is TScrollBox) then
        With TScrollBox(Components[n]) do
        Begin
          VertScrollBar.Position:=0;
          HorzScrollBar.Position:=0;
        end;

    VertScrollBar.Position:=0;
    HorzScrollBar.Position:=0;

    If (NeedCUpdate) then
      Store_FormCoord(Not SetDefault);

    //Send_UpdateList(42);
  End; { If CanClose }
end;

//-------------------------

procedure TfrmGLLineDrill.FormClose(Sender: TObject; var Action: TCloseAction);
Begin { FormClose }
  //If (Not fDoingClose) Then
  //Begin
  //  fDoingClose:=BOn;

    Action:=caFree;

    If Assigned(MULCtrlO) Then
    Begin
      MULCtrlO.Destroy;
      MULCtrlO := Nil;
    End; { If Assigned(MULCtrlO) }
  //End; { If (Not fDoingClose) }
End; { FormClose }

//-------------------------------------------------------------------------

// Records positions used during FormResize
procedure TfrmGLLineDrill.FormSetOffSet;
Begin
  // Record co-ordinates for resizing the main scrollbox containing the Btrieve list
  PagePoint[1].X := ClientWidth - (D1SBox.Width);
  PagePoint[1].Y := ClientHeight - (D1SBox.Height);

  // Record co-ordinates for resizing the btrieve up/down button panel
  PagePoint[2].X := ClientWidth - D1ListBtnPanel.Left;
  PagePoint[2].Y := ClientHeight - D1ListBtnPanel.Height;

  // Record co-ordinates for resizing the btrieve list panels within the scrollbox
  PagePoint[3].Y := D1SBox.ClientHeight - D1ORefPanel.Height;

  GotCoord := BON;
end;

//-------------------------------------------------------------------------

procedure TfrmGLLineDrill.StartList;
Var
  lCaption : ShortString;
Begin { StartList }
  // Update caption to reflect data on display
  lCaption := Format('%s, %d - %s (%s - ',
                     [Trim(FCompanyCode), FGLCode,
                      FGLDescr,           SyssCurr.Currencies[FCurrency].Desc]);

  Case FMode Of
    glCC           : lCaption := Format ('%sCC: %s - ', [lCaption, Trim(FCostCentre)]);
    glDept         : lCaption := Format ('%sDep: %s - ', [lCaption, Trim(FDepartment)]);
    glCCDept       : lCaption := Format ('%sCC: %s Dep: %s - ', [lCaption, Trim(FCostCentre), Trim(FDepartment)]);
    glCommit       : lCaption := lCaption + 'Commit - ';
    glCommitCCDept : lCaption := Format ('%sCommit - CC: %s Dep: %s - ', [lCaption, Trim(FCostCentre), Trim(FDepartment)]);
  End; { Case FMode }

  If (FPeriod = -98) Then
    Caption := lCaption + 'All Periods)'
  Else
    If (FPeriod = 0) Then
      Caption := Format('%sAll->%s)', [lCaption, PPR_OutPr(Syss.PrinYr, FYear)])
    Else
      If ((FPeriod >= 101) And (FPeriod <= 199)) Then
        Caption := Format('%s01->%s)', [lCaption, PPR_OutPr(FPeriod-100, FYear)])
      Else
        Caption := Format('%s%s)', [lCaption, PPR_OutPr(FPeriod, FYear)]);

  // Setup the btrieve list
  FormBuildList(BOn);
End; { StartList }

//-----------------------

procedure TfrmGLLineDrill.FormBuildList(ShowLines  :  Boolean);
Var
  StartPanel  :  TSBSPanel;
  n           :  Byte;

  Function IIF (Const BoolCond          : Boolean;
                Const TrueVal, FalseVal : TGLDrillDataAccessMode) : TGLDrillDataAccessMode;
  Begin { IIF }
    If BoolCond Then
      Result := TrueVal
    Else
      Result := FalseVal;
  End; { IIF }

Begin
  // This routine is called each time the GL Drill-Down is performed
  // even if the window is already visible.  To prevent problems any
  // existing MULCtrlo is destroyed and a new one is created
  If Assigned(MULCtrlO) Then Begin
    MULCtrlO.Destroy;
    MULCtrlO := NIL;
  End;
  MULCtrlO := TGLLinesList.Create(Self);

  Try
    With MULCtrlO Do
    Begin
      // Properties to control the loading of the Transaction Lines
      lstMode       := FMode;
      lstCurrency   := FCurrency;
      lstGLCode     := FGLCode;
      lstGLType     := FGLType;
      lstPeriod     := FPeriod;
      lstYear       := FYear;
      lstCostCentre := FCostCentre;
      lstDepartment := FDepartment;

      // Determine which system to use to access the data
      lstInCcy := (lstcurrency > 0) Or (EnterpriseLicence.elCurrencyVersion = cvPro);
      Case lstMode Of
        // Base GL functions e.g. entGLActual
        glOnly,
        // Committed GL functions e.g. entGLCOMActual
        glCommit       : Begin
                           // Determine how the data is to be accessed
                           If (lstPeriod = -98) Then
                             // Everything Ever - list all trans
                             lstDataMode := IIF (lstInCcy, daPartIdx3Segs, daPartIdx2Segs)
                           Else
                             If (lstPeriod = 0) Then
                               // All Trans up to and including the current year
                               lstDataMode := daFilter3
                             Else
                               If (lstPeriod >= 1) And (lstPeriod <= 99) Then
                                 // Specific Period
                                 lstDataMode := IIF (lstInCcy, daFullIdx, daFilter1)
                               Else
                                 If (lstPeriod >= 101) And (lstPeriod <= 199) Then
                                   // Total for the Year from period 1 to X
                                   lstDataMode := IIF (lstInCcy, daFilter2, daFilter1);
                         End;
        // Cost Centre functions e.g. entGLCCActual
        glCC, glDept   : lstDataMode := daFilter4;

        // Cost Centre and Department functions e.g. entGLCCDpActual
        glCCDept       : lstDataMode := daFilter4;

        // Committed Cost Centre and Department functions e.g. entGLCCDpCOMActual
        glCommitCCDept : lstDataMode := daFilter4;
      Else 
        lstDataMode := daFullIdx;
      End; { Case lstMode }

      Try
        With VisiList do
        Begin
          AddVisiRec(D1ORefPanel,D1ORefLab);
          AddVisiRec(D1DatePanel,D1DateLab);
          AddVisiRec(D1AccPanel,D1AccLab);
          AddVisiRec(D1DesPanel,D1DesLab);

          AddVisiRec(D1AmtPanel,D1AmtLab);
          AddVisiRec(D1StatPanel,D1StatLab);
          AddVisiRec(D1DatPanel,D1DatLab);

          VisiRec:=List[0];

          StartPanel:=(VisiRec^.PanelObj as TSBSPanel);

          {HidePanels(0);}

          LabHedPanel:=D1HedPanel;

          SetHedPanel(ListOfSet);
        End; { With VisiList }
      Except
        VisiList.Free;
      End;

      ListOfSet:=10;

      Find_FormCoord;

      TabOrder := -1;
      TabStop:=BOff;
      Visible:=BOff;
      BevelOuter := bvNone;
      ParentColor := False;
      Color:=StartPanel.Color;
      MUTotCols:=6;
      Font:=StartPanel.Font;

      LinkOtherDisp:=BOn;

      WM_ListGetRec:=WM_CustGetRec;

      Parent:=StartPanel.Parent;

      MessHandle:=Self.Handle;

      For N := 0 to MUTotCols Do
        With ColAppear^[N] Do
        Begin
          AltDefault:=BOn;

          If (N In [4]) then
          Begin
            DispFormat:=SGFloat;
            NoDecPlaces:=2
          End; { If (N In [4]) }
        End; { With ColAppear^[n]  }

      ListLocal:=@ExLocal;

      ListCreate;

      UseSet4End:=BOn;

      NoUpCaseCheck:=BOn;

      HighLiteStyle[1]:=[fsBold];

      Set_Buttons(D1ListBtnPanel);

      ReFreshList(ShowLines,BOff);
    End { With MULCtrlO }
  Except
    FreeAndNIL(MULCtrlO);
  end;

  // Record window positions for resize events
  FormSetOffSet;
  FormReSize(Self);
end;

//-------------------------------------------------------------------------

procedure TfrmGLLineDrill.RefreshList (ShowLines, IgMsg : Boolean);
Var
  KeyStart,
  PrimeKey    :  Str255;
  LKeyLen     :  Integer;
Begin
  FillChar(PrimeKey,Sizeof(PrimeKey), #0);

  //KeyStart:=DDCtrl.MainK;
  //LKeyLen:=DDCtrl.NHKeyLen;

  With MULCtrlO do
  Begin
    Case lstDataMode Of
      // Index: NomCode + NomMode + Ccy + Year + Period
      daFullIdx      : Begin
                         KeyStart := FullNomKey (FGLCode) +     // Seg1 - GL Code
                                     #0 +                       // Seg2 - NOM Mode
                                     Chr(FCurrency) +           // Seg3 - Currency
                                     Chr(FYear) +               // Seg4 - Year
                                     Chr(FPeriod);              // Seg3 - Period
                         LKeyLen := Length(KeyStart);

                         // Filter out unposted transactions in conjunction with SetFilter
                         // MH 24/05/2017 ABSEXCH-18546 2016-R2: List filtering out any TL's where the first byte
                         //                                      of the Posting Run No is 255
                         //Filter[1,1] := NDXWeight;
                         Filter[1,1] := NDXWeight + NDXWeight + NDXWeight + #127;
                       End;
      // Index: NomCode + NomMode
      daPartIdx2Segs : Begin
                         KeyStart := FullNomKey (FGLCode) +     // Seg1 - GL Code
                                     #0;                        // Seg2 - NOM Mode
                         LKeyLen := Length(KeyStart);

                         // Filter out unposted transactions in conjunction with SetFilter
                         // MH 24/05/2017 ABSEXCH-18546 2016-R2: List filtering out any TL's where the first byte
                         //                                      of the Posting Run No is 255
                         //Filter[1,1] := NDXWeight;
                         Filter[1,1] := NDXWeight + NDXWeight + NDXWeight + #127;
                       End;
      // Index: NomCode + NomMode + Ccy
      daPartIdx3Segs : Begin
                         KeyStart := FullNomKey (FGLCode) +     // Seg1 - GL Code
                                     #0 +                       // Seg2 - NOM Mode
                                     Chr(FCurrency);            // Seg3 - Currency
                         LKeyLen := Length(KeyStart);

                         // Filter out unposted transactions in conjunction with SetFilter
                         // MH 24/05/2017 ABSEXCH-18546 2016-R2: List filtering out any TL's where the first byte
                         //                                      of the Posting Run No is 255
                         //Filter[1,1] := NDXWeight;
                         Filter[1,1] := NDXWeight + NDXWeight + NDXWeight + #127;
                       End;
      // ExBtr: NomCode + NomMode + Year + (Period <= X)
      daFilter1      : Begin
                         KeyStart := FullNomKey (FGLCode) +     // Seg1 - GL Code
                                     #0;                        // Seg2 - NOM Mode
                         LKeyLen := Length(KeyStart);
                       End;

      // ExBtr: NomCode + NomMode + Ccy + Year + (Period <= X)
      daFilter2      : Begin
                         KeyStart := FullNomKey (FGLCode) +     // Seg1 - GL Code
                                     #0 +                       // Seg2 - NOM Mode
                                     Chr(FCurrency) +           // Seg3 - Currency
                                     Chr(FYear);                // Seg4 - Year
                         LKeyLen := Length(KeyStart);
                       End;

      // ExBtr: NomCode + NomMode + [Ccy] + (Year <= X)
      daFilter3,
      daFilter4      : Begin
                         If lstInCcy Then
                           // For Specific currency
                           KeyStart := FullNomKey (FGLCode) +     // Seg1 - GL Code
                                       #0 +                       // Seg2 - NOM Mode
                                       Chr(FCurrency)             // Seg3 - Currency
                         Else
                           // Consolidated
                           KeyStart := FullNomKey (FGLCode) +     // Seg1 - GL Code
                                       #0;                        // Seg2 - NOM Mode

                         LKeyLen := Length(KeyStart);

                         If (lstDataMode = daFilter4) Then
                           // Filter out unwanted CC/Dept lines
                           // MH 24/05/2017 ABSEXCH-18546 2016-R2: List filtering out any TL's where the first byte
                           //                                      of the Posting Run No is 255
                           //Filter[1,1] := NDXWeight;
                           Filter[1,1] := NDXWeight + NDXWeight + NDXWeight + #127;
                       End;
    Else
      raise Exception.Create ('TfrmGLLineDrill.RefreshList - Unhandled Data Mode - Please notify your Technical Support');
    End; { Case lstDataMode }

    {$IFDEF DRILLDEBUG}
      frmMainDebug.DebugStr('TfrmGLLineDrill.RefreshList Calling StartList', 2);
    {$ENDIF} // DRILLDEBUG
    StartList(IDetailF, IdNomK, KeyStart, '', '' {PrimeKey}, LKeyLen, (Not ShowLines));
    {$IFDEF DRILLDEBUG}
      frmMainDebug.DebugStr('TfrmGLLineDrill.RefreshList StartList Finished', -2);
    {$ENDIF} // DRILLDEBUG
    //IgnoreMsg:=BOff;
  End; { With MULCtrlO }
end;

//-------------------------------------------------------------------------

procedure TfrmGLLineDrill.Find_FormCoord;
Var
  ThisForm    : TForm;
  VisibleRect : TRect;
  GlobComp    : TGlobCompRec;
Begin { Find_FormCoord }
  If (Not ReadFormPos) Then Begin
    New(GlobComp,Create(BOn));

    ThisForm:=Self;

    With GlobComp^ do
    Begin
      GetValues:=BOn;

      PrimeKey:='E';

      If (GetbtControlCsm(ThisForm)) then
      Begin
        {StoreCoord:=(ColOrd=1); v4.40. To avoid on going corruption, this is reset each time its loaded}
        StoreCoord:=BOff;
        HasCoord:=(HLite=1);
        LastCoord:=HasCoord;

        If (HasCoord) then {* Go get postion, as would not have been set initianly *}
          SetPosition(ThisForm);
      end;

      //GetbtControlCsm(PageControl1);

      GetbtControlCsm(D1SBox);

      //GetbtControlCsm(D1BSBox);

      //GetbtControlCsm(D1BtnPanel);

      GetbtControlCsm(D1ListBtnPanel);

      GetbtControlCsm(D1HedPanel);

      MULCtrlO.Find_ListCoord(GlobComp);
    End; { With GlobComp^ }

    With MULCtrlO.VisiList do
      LabHedPanel.Color:=IdPanel(0,BOn).Color;

    Dispose(GlobComp,Destroy);

    StartSize.X:=Width; StartSize.Y:=Height;

    ReadFormPos := True;
  End; { If (Not ReadFormPos) }
End; { Find_FormCoord }

//-------------------------

procedure TfrmGLLineDrill.Store_FormCoord(UpMode  :  Boolean);
Var
  GlobComp:  TGlobCompRec;
Begin { Store_FormCoord }
  New(GlobComp,Create(BOff));

  With GlobComp^ do
  Begin
    GetValues:=UpMode;

    PrimeKey:='E';

    ColOrd:=Ord(StoreCoord);

    HLite:=Ord(LastCoord);

    SaveCoord:=StoreCoord;

    If (Not LastCoord) then {* Attempt to store last coord *}
      HLite:=ColOrd;

    StorebtControlCsm(Self);

    //StorebtControlCsm(PageControl1);

    StorebtControlCsm(d1SBox);

    //StorebtControlCsm(d1BSBox);

    //StorebtControlCsm(d1BtnPanel);

    StorebtControlCsm(d1ListBtnPanel);

    StorebtControlCsm(d1HedPanel);

    MULCtrlO.Store_ListCoord(GlobComp);
  End; { With GlobComp^ }

  Dispose(GlobComp,Destroy);
End; { Store_FormCoord }

//-------------------------------------------------------------------------

Procedure TfrmGLLineDrill.SetCompanyCode (Value : ShortString);
Begin { SetCompanyCode }
  If (Value <> FCompanyCode) Then
    FCompanyCode := Value;
End; { SetCompanyCode }

//-------------------------

procedure TfrmGLLineDrill.SetCostCentre(const Value: ShortString);
begin
  If (Value <> FCostCentre) Then
    FCostCentre := Value;
end;

//-------------------------

Procedure TfrmGLLineDrill.SetCurrency (Value : Byte);
Begin { SetCurrency }
  If (Value <> FCurrency) Then
    FCurrency := Value;
End; { SetCurrency }

//-------------------------

procedure TfrmGLLineDrill.SetDepartment(const Value: ShortString);
begin
  If (Value <> FDepartment) Then
    FDepartment := Value;
end;

//-------------------------

Procedure TfrmGLLineDrill.SetGLCode (Value : LongInt);
Begin { SetGLCode }
  If (Value <> FGLCode) Then
    FGLCode := Value;
End; { SetGLCode }

//-------------------------

Procedure TfrmGLLineDrill.SetGLDescr (Value : ShortString);
Begin { SetGLDescr }
  If (Value <> FGLDescr) Then
    FGLDescr := Value;
End; { SetGLDescr }

//-------------------------

Procedure TfrmGLLineDrill.SetMode (Value : TGLDrillMode);
Begin { SetMode }
  If (Value <> FMode) Then
    FMode := Value;
End; { SetMode }

//-------------------------

Procedure TfrmGLLineDrill.SetPeriod (Value : SmallInt);
Begin { SetPeriod }
  If (Value <> FPeriod) Then
    FPeriod := Value;
End; { SetPeriod }

//-------------------------

Procedure TfrmGLLineDrill.SetYear (Value : SmallInt);
Begin { SetYear }
  If (Value <> FYear) Then
    FYear := Value;
End; { SetYear }

//-------------------------------------------------------------------------

procedure TfrmGLLineDrill.D1ORefPanelMouseUp(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
Var
  BarPos    : Integer;
  PanRSized : Boolean;
begin
  If (Sender is TSBSPanel) then
    With (Sender as TSBSPanel) Do
    Begin
      PanRSized:=ReSized;

      //BarPos:=Current_BarPos(Current_Page);
      BarPos:=D1SBox.HorzScrollBar.Position;

      If (PanRsized) then
        MULCtrlO.ResizeAllCols(MULCtrlO.VisiList.FindxHandle(Sender),BarPos);

      MULCtrlO.FinishColMove(BarPos+(ListOfset*Ord(PanRSized)),PanRsized);

      NeedCUpdate:=(MULCtrlO.VisiList.MovingLab or PanRSized);
    End; { With (Sender as TSBSPanel) }
end;

//-------------------------------------------------------------------------

Procedure TfrmGLLineDrill.SetNeedCUpdate(B : Boolean);
Begin
  If (Not fNeedCUpdate) then
    fNeedCUpdate := B;
end;

//-------------------------------------------------------------------------

Procedure TfrmGLLineDrill.WMCustGetRec (Var Message : TMessage);
Begin
  With Message do
    Case WParam of
      { 0 = dbl click on line, 1 = Selected line changed, 169 = pressed drill down button}
      0,1,169
         :  Begin
              If (WParam=169) Then {* Treat as 0 *}
              Begin
                MULCtrlO.GetSelRec(BOff);
                WParam:=0;
              End;

              // Display Trans
              If (WParam = 0) Or ((WParam = 1) And Assigned(DisplayTrans)) Then
                Display_Trans (Id.FolioRef, (WParam = 1));
            End;

      { pressed right click over list }
      2  :  ; //ShowRightMeny(LParamLo,LParamHi,1);

      25 :  NeedCUpdate:=BOn;
    End; { Case WParam }

  Inherited;
End;

//-------------------------------------------------------------------------

procedure TfrmGLLineDrill.D1ORefLabMouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
Var
  ListPoint  :  TPoint;
begin
  If (Sender Is TSBSPanel) Then
    With (Sender As TSBSPanel) Do
    Begin
      If (Not ReadytoDrag) And (Button = MBLeft) Then
      Begin
        If Assigned (MULCtrlO) then
          MULCtrlO.VisiList.PrimeMove(Sender);

        NeedCUpdate:=BOn;
      End { If (Not ReadytoDrag) And (Button = MBLeft) }
      Else
        If (Button=mbRight) Then
        Begin
          ListPoint:=ClientToScreen(Point(X,Y));

          ShowRightMeny(ListPoint.X,ListPoint.Y,0);
        End; { If (Button=mbRight) }
    End; { With (Sender As TSBSPanel) }
end;

//-------------------------------------------------------------------------

procedure TfrmGLLineDrill.D1ORefLabMouseMove(Sender: TObject;
  Shift: TShiftState; X, Y: Integer);
begin
  If (Sender is TSBSPanel) Then
    With (Sender As TSBSPanel) Do
    Begin
      If Assigned(MULCtrlO) Then
      Begin
        MULCtrlO.VisiList.MoveLabel(X,Y);
        NeedCUpdate:=MULCtrlO.VisiList.MovingLab;
      End; { If Assigned(MULCtrlO) }
    End; { With (Sender As TSBSPanel) }
end;

//-------------------------------------------------------------------------

procedure TfrmGLLineDrill.ShowRightMeny(X,Y,Mode  :  Integer);
Begin
  With PopUpMenu1 Do
    PopUp(X,Y);
End;

//-------------------------------------------------------------------------

procedure TfrmGLLineDrill.PropFlgClick(Sender: TObject);
begin
  SetFormProperties;
end;

//-------------------------------------------------------------------------

procedure TfrmGLLineDrill.StoreCoordFlgClick(Sender: TObject);
begin
  StoreCoord:=Not StoreCoord;
  NeedCUpdate:=BOn;
end;

//-------------------------------------------------------------------------

procedure TfrmGLLineDrill.SetFormProperties;
Var
  TmpPanel                   : Array[1..3] of TPanel;
  n                          : Byte;
  ResetDefaults, BeenChange  : Boolean;
  ColourCtrl                 : TCtrlColor;
Begin
  ResetDefaults:=BOff;

  For n:=1 to 3 do
  Begin
    TmpPanel[n]:=TPanel.Create(Self);
  end;

  try
    With MULCtrlO.VisiList do
    Begin
      VisiRec:=List[0];

      TmpPanel[1].Font:=(VisiRec^.PanelObj as TSBSPanel).Font;
      TmpPanel[1].Color:=(VisiRec^.PanelObj as TSBSPanel).Color;

      TmpPanel[2].Font:=(VisiRec^.LabelObj as TSBSPanel).Font;
      TmpPanel[2].Color:=(VisiRec^.LabelObj as TSBSPanel).Color;


      TmpPanel[3].Color:=MULCtrlO.ColAppear^[0].HBKColor;
    end;

    TmpPanel[3].Font.Assign(TmpPanel[1].Font);
    TmpPanel[3].Font.Color:=MULCtrlO.ColAppear^[0].HTextColor;

    ColourCtrl:=TCtrlColor.Create(Self);
    try
      With ColourCtrl do
      Begin
        SetProperties(TmpPanel[1],TmpPanel[2],TmpPanel[3],1,'List Properties',BeenChange,ResetDefaults);

        NeedCUpdate:=(BeenChange or ResetDefaults);

        If (BeenChange) and (not ResetDefaults) then
        Begin
          For n:=1 to 3 do
            With TmpPanel[n] do
              Case n of
                1,2  :  MULCtrlO.ReColorCol(Font,Color,(n=2));

                3    :  MULCtrlO.ReColorBar(Font,Color);
              end; {Case..}

          MULCtrlO.VisiList.LabHedPanel.Color:=TmpPanel[2].Color;
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

//-------------------------------------------------------------------------

Function TfrmGLLineDrill.CheckListFinished : Boolean;

Var
  n       :  Byte;
  mbRet   :  Word;
Begin
  Result:=BOn;

  If Assigned(MULCtrlO) then
    Result := Not MULCtrlO.ListStillBusy;

  If (Not Result) then
  Begin
    //Set_BackThreadMVisible(BOn);

    mbRet:=MessageDlg('One of the lists is still busy.'+#13+#13+
                      'Do you wish to interrupt the list so that you can exit?',mtConfirmation,[mbYes,mbNo],0);

    If (mBRet=mrYes) then
    Begin
      MULCtrlO.IRQSearch:=BOn;

      ShowMessage('Please wait a few seconds, then try closing again.');
    end;

    //Set_BackThreadMVisible(BOff);
  End; { If (Not Result) }
end;

//-------------------------------------------------------------------------

procedure TfrmGLLineDrill.ViewTransaction1Click(Sender: TObject);
begin
  With MULCtrlO Do
    If ValidLine Then
    Begin
      RefreshLine(MUListBoxes[0].Row,BOff);

      Display_Trans (Id.FolioRef, False);
    End; { If ValidLine  }
end;

//-------------------------------------------------------------------------

procedure TfrmGLLineDrill.Display_Trans (Const IdFolio : LongInt; Const DataChanged : Boolean);
Var
  KeyS    : Str255;
  lStatus : SmallInt;
Begin { Display_Trans }
  With ExLocal Do Begin
    // Load Transaction
    KeyS := FullNomKey (IdFolio);
    lStatus := Find_Rec (B_GetEq, F[InvF], InvF, LRecPtr[InvF]^, InvFolioK, KeyS);

    If (lStatus = 0) And (Not (LInv.InvDocHed In NomSplit + StkAdjSplit + TSTSplit)) Then Begin
      // Load Customer
      KeyS := FullCustCode(LInv.CustCode);
      lStatus := Find_Rec (B_GetEq, F[CustF], CustF, LRecPtr[CustF]^, CustCodeK, KeyS);
    End; { If (lStatus = 0) }

    If (lStatus = 0) Then Begin
      // Check the transaction display manager has been created
      If Not Assigned (DisplayTrans) Then
        DisplayTrans := TfrmDisplayTransManager.Create(Self);

      // Display the Transaction
      DisplayTrans.Display_Trans(LInv, LCust, DataChanged);
    End; { If (lStatus = 0) }
  End; { With ExLocal }
end;

//-------------------------------------------------------------------------

// IMPORTANT NOTE: This message handler is required to ensure the form stays
// on top, as it has a habit of losing its Stay-On-Top'ness at runtime.
procedure TfrmGLLineDrill.WMWindowPosChanged(var Msg : TMessage);
Var
  TopWindow : TWinControl;
Begin
  // Do standard message processing
  Inherited;

  // HM 22/10/03: Added Visible check as it hangs under win 98 otherwise
  If Self.Visible Then
  Begin
    // Check to see if the TopMost window is a Drill-Down window
    TopWindow := FindControl(PWindowPos(Msg.LParam).hwndInsertAfter);
    If Not Assigned(TopWindow) Then
      // Restore TopMost back to window
      SetWindowPos(Handle, HWND_TOPMOST, 0, 0, 0, 0, SWP_NOSIZE or SWP_NOMOVE or SWP_NOACTIVATE);
  End; // If Self.Visible
End;

//-------------------------------------------------------------------------

procedure TfrmGLLineDrill.PopupMenu1Popup(Sender: TObject);
begin
  StoreCoordFlg.Checked:=StoreCoord;
end;

//=========================================================================

initialization
  frmGLLines := nil;

end.
