unit SRCPPYF;

{$I DEFOVR.Inc}

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ExtCtrls, SBSPanel, ComCtrls, StdCtrls, TEditVal, Mask,
  GlobVar,VarConst,ExWrap1U,BTSupU1,SupListU,SBSComp2,BorBtns,
  //SalTxL1U,

  PayLineU,      // Copy of Exchequer PayLineU - Payment Line window

  Menus;



type
  TRecepForm = class(TForm)
    PageControl1: TPageControl;
    RecepPage: TTabSheet;
    R1SBox: TScrollBox;
    R1HedPanel: TSBSPanel;
    R1PayPanel: TSBSPanel;
    R1NomPanel: TSBSPanel;
    R1NomD2Panel: TSBSPanel;
    R1BasePanel: TSBSPanel;
    R1ChqPanel: TSBSPanel;
    R1PayInPanel: TSBSPanel;
    R1ListBtnPanel: TSBSPanel;
    R1BtnPanel: TSBSPanel;
    R1BSBox: TScrollBox;
    btnViewLine: TButton;
    R1FPanel: TSBSPanel;
    Label817: Label8;
    Label84: Label8;
    Label87: Label8;
    R1CurrLab: Label8;
    Label82: Label8;
    R1XRateLab: Label8;
    R1Base2Lab: Label8;
    R1OrefF: Text8Pt;
    R1OpoF: Text8Pt;
    R1TDateF: TEditDate;
    R1TPerF: TEditPeriod;
    R1YrefF: Text8Pt;
    R1RValF: TCurrencyEdit;
    R1XRateF: TCurrencyEdit;
    SBSPanel2: TSBSPanel;
    R1CurrF: TSBSComboBox;
    R1AddrF: TMemo;
    R1BaseF: TCurrencyEdit;
    PopupMenu1: TPopupMenu;
    Add1: TMenuItem;
    Edit1: TMenuItem;
    Delete1: TMenuItem;
    Insert1: TMenuItem;
    Switch1: TMenuItem;
    N2: TMenuItem;
    PropFlg: TMenuItem;
    N1: TMenuItem;
    StoreCoordFlg: TMenuItem;
    N3: TMenuItem;
    R1StatLab: Label8;
    Defaults1: TMenuItem;
    SBSPanel1: TSBSPanel;
    SBSPanel4: TSBSPanel;
    ReqdTit: Label8;
    ReqdLab: Label8;
    VarPanel: TSBSPanel;
    VarTit: Label8;
    VarLab: Label8;
    CCPanel: TSBSPanel;
    CCTit: Label8;
    DepTit: Label8;
    CCLab: Label8;
    DepLab: Label8;
    R1NomLab: TSBSPanel;
    R1NomD2Lab: TSBSPanel;
    R1ChqLab: TSBSPanel;
    R1PayLab: TSBSPanel;
    R1BaseLab: TSBSPanel;
    R1PayInLab: TSBSPanel;
    Cleared1: TMenuItem;
    DiscPanel: TSBSPanel;
    Label81: Label8;
    DiscLab: Label8;
    Links1: TMenuItem;
    Check1: TMenuItem;
    Pay1: TMenuItem;
    TransExtForm1: TSBSExtendedForm;
    UDF1L: Label8;
    UDF3L: Label8;
    UDF2L: Label8;
    UDF4L: Label8;
    THUD1F: Text8Pt;
    THUD3F: Text8Pt;
    THUD4F: Text8Pt;
    THUD2F: Text8Pt;
    R1AccF: Text8Pt;
    Label88: Label8;
    DMDCNomF: Text8Pt;
    ClsR1Btn: TButton;
    UDF5L: Label8;
    UDF6L: Label8;
    THUD5F: Text8Pt;
    THUD7F: Text8Pt;
    THUD9F: Text8Pt;
    THUD6F: Text8Pt;
    THUD8F: Text8Pt;
    THUD10F: Text8Pt;
    UDF7L: Label8;
    UDF9L: Label8;
    UDF8L: Label8;
    UDF10L: Label8;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure FormKeyPress(Sender: TObject; var Key: Char);
    procedure ClsR1BtnClick(Sender: TObject);
    procedure PopupMenu1Popup(Sender: TObject);
    function R1TPerFShowPeriod(Sender: TObject; const EPr: Byte): string;
    procedure OkR1BtnClick(Sender: TObject);
    procedure PropFlgClick(Sender: TObject);
    procedure StoreCoordFlgClick(Sender: TObject);
    procedure FormResize(Sender: TObject);
    procedure btnViewLineClick(Sender: TObject);
  private
    { Private declarations }

    StoreCoord,
    NeedCUpdate,
    LastCoord,
    SetDefault,
    GotCoord     :  Boolean;

    PayCtrl      :  TPayLine;

    PagePoint  :  Array[0..4] of TPoint;

    StartSize,
    InitSize   :  TPoint;

    ExLocal    :  TdExLocal;

    procedure Find_FormCoord;

    procedure Store_FormCoord(UpMode  :  Boolean);

    procedure FormSetOfSet;

    procedure PayIPageReSize;

    procedure LinkToCC;

    Procedure WMCustGetRec(Var Message  :  TMessage); Message WM_CustGetRec;

    Procedure WMSysCommand(Var Message  :  TMessage); Message WM_SysCommand;
    procedure WMWindowPosChanged(var Msg : TMessage); Message WM_WindowPosChanged;

    Procedure RefreshList(ShowLines,IgMsg  :  Boolean);

    procedure SetFieldProperties;

    procedure SetFormProperties(SetList  :  Boolean);

    procedure BuildDesign;

    procedure FormDesign;

    procedure FormBuildList(ShowLines  :  Boolean);

    procedure SetRecepFields;

    Procedure OutRecepTotals;
  public
    { Public declarations }
    procedure DisplayTrans (Const TheTrans : InvRec; Const TheCust : CustRec);
  end;



{~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~}

Implementation

{~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~}

Uses
  Grids,
  ETStrU,
  ETMiscU,
  ETDateU,
  BtrvU2,
  BTSupU2,
  BTSupU3,
  BTKeys1U,
  CmpCtrlU,
  ColCtrlU,
  VarRec2U,
  ComnUnit,
  ComnU2,
  CurrncyU,
  InvListU,

  {$IFDEF PF_On}

    //InvLst2U,

    {$IFDEF JC}
       //JChkUseU,
    {$ENDIF}


  {$ENDIF}

  {$IFDEF GF}
    //FindRecU,
    //FindCtlU,
  {$ENDIF}

  {$IFDEF NP}
    //NoteSupU,
  {$ENDIF}

  {$IFDEF DBD}
    //DebugU,
  {$ENDIF}

  DispDocF,       // Transaction Display Manager and some common routines
  EntData,        // Global Exchequer Data object
  EntLicence,     // Global Exchequer Licence object

  SysU1,
  SysU2,
  SysU3,
  IntMU,
  MiscU,
  CUstomFieldsIntF,
  TransactionOriginator;
  //PayF2U,
  //AutoTxU,
  //SrcBnkU,

  {$IFDEF FRM}
    //DefProcU,
  {$ENDIF}

  //Event1U,
  {$IFDEF CU}

  {$ELSE}
    {$IFDEF EBUS}
      //Event1U,
    {$ENDIF}
  {$ENDIF}
  {$IFDEF RW}
    {Event1U,}
  {$ENDIF}

  {$IFDEF POST}
    //PostingU,
  {$ENDIF}


  //PassWR2U,
  //GenWarnU,
  //Warn1U;

{$R *.DFM}

//=========================================================================

procedure TRecepForm.FormCreate(Sender: TObject);
Var
  n  :  Integer;
begin
  // Create data interface object for list
  ExLocal.Create;

  // Initialise scroll-bar positions
  For n:=0 to Pred(ComponentCount) do
    If (Components[n] is TScrollBox) then
      With TScrollBox(Components[n]) do
      Begin
        VertScrollBar.Position:=0;
        HorzScrollBar.Position:=0;
      end;

  // Initialise Form Sizes
  InitSize.Y := 359;
  InitSize.X := 637;
  Self.ClientHeight := InitSize.Y;
  Self.ClientWidth  := InitSize.X;
  Constraints.MinHeight  := InitSize.Y - 1;
  Constraints.MinWidth   := InitSize.X - 1;

  // Setup misc internal variables
  LastCoord   := BOff;
  NeedCUpdate := BOff;
  SetDefault  := BOff;
  StoreCoord  := BOff;

  // Initialise the Btrieve Lists
  FormBuildList(BOff);
end;

//------------------------------

procedure TRecepForm.FormDestroy(Sender: TObject);
begin
  ExLocal.Destroy;

  If Assigned(PayCtrl) Then
    FreeAndNIL(PayCtrl);
end;

//-------------------------------------------------------------------------

procedure TRecepForm.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
Var
  n  : Integer;
begin
  For n:=0 to Pred(ComponentCount) do
    If (Components[n] is TScrollBox) then
      With TScrollBox(Components[n]) do
      Begin
        VertScrollBar.Position:=0;
        HorzScrollBar.Position:=0;
      end;

  If (NeedCUpdate) then
    Store_FormCoord(Not SetDefault);
end;

//------------------------------

procedure TRecepForm.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Action:=caFree;

  Try
    If (PayCtrl.MULCtrlO<>Nil) then
      PayCtrl.MULCtrlO.Destroy; {* Must be destroyed here, as owned by ROB1...}
  Finally
    PayCtrl.MULCtrlO:=Nil;
  end; {Finally..}

  SendMessage ((Owner As TForm).Handle, WM_CustGetRec, 100, 3);
end;

//-------------------------------------------------------------------------

procedure TRecepForm.FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  GlobFormKeyDown(Sender,Key,Shift,ActiveControl,Handle);
end;

//------------------------------

procedure TRecepForm.FormKeyPress(Sender: TObject; var Key: Char);
begin
  GlobFormKeyPress(Sender,Key,ActiveControl,Handle);
end;

//-------------------------------------------------------------------------

// IMPORTANT NOTE: This message handler is required to ensure the form stays
// on top, as it has a habit of losing its Stay-On-Top'ness at runtime.
procedure TRecepForm.WMWindowPosChanged(var Msg : TMessage);
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

Procedure TRecepForm.WMCustGetRec(Var Message  :  TMessage);
Begin
  With Message Do Begin
    Case WParam of
      { 0 = dbl click on line, 169 = pressed drill down button}
      0, 169  : If Assigned(PayCtrl) Then Begin
                  If (WParam = 169) Then
                    PayCtrl.MULCtrlO.GetSelRec(BOff);

                  If PayCtrl.MULCtrlO.ValidLine Then
                    PayCtrl.AddEditPay(True,True,0,0,ExLocal.LInv);
                End; { If Assigned(PayCtrl) }

      { 1 = Selected line changed }
      1       : Begin
                  LinkToCC;

                  If PayCtrl.Visible Then Begin
                    PayCtrl.MULCtrlO.GetSelRec(BOff);
                    PayCtrl.AddEditPay(True,True,0,0,ExLocal.LInv);
                  End; { If PayCtrl.Visible }
                End;

     25  :  NeedCUpdate:=BOn;
    end; {Case..}

  end;

  Inherited;
end;

//-------------------------------------------------------------------------

Procedure TRecepForm.WMSysCommand(Var Message  :  TMessage);
Begin
  With Message do
    Case WParam of
      SC_Maximize  :  Begin
                        Self.ClientHeight:=InitSize.Y;
                        Self.ClientWidth:=InitSize.X;

                        WParam:=0;
                      end;
    end; {Case..}

  Inherited;
end;

//-------------------------------------------------------------------------

procedure TRecepForm.Find_FormCoord;
Var
  ThisForm    : TForm;
  GlobComp    : TGlobCompRec;
Begin
  New(GlobComp,Create(BOn));

  ThisForm:=Self;

  With GlobComp^ do
  Begin

    GetValues:=BOn;

    PrimeKey:=Chr(Ord('!')+Ord(ExLocal.LInv.InvDocHed In SalesSplit));


    If (GetbtControlCsm(ThisForm)) then
    Begin
      {StoreCoord:=(ColOrd=1); v4.40. To avoid on going corruption, this is reset each time its loaded}
      StoreCoord:=BOff;
      HasCoord:=(HLite=1);
      LastCoord:=HasCoord;

      If (HasCoord) then {* Go get postion, as would not have been set initianly *}
        SetPosition(ThisForm);

    end;

    GetbtControlCsm(PageControl1);

    GetbtControlCsm(R1SBox);

    GetbtControlCsm(R1BSBox);

    GetbtControlCsm(R1BtnPanel);

    GetbtControlCsm(R1ListBtnPanel);

    //GetbtControlCsm(TCNScrollBox);
    //GetbtControlCsm(TCNListBtnPanel);

    If GetbtControlCsm(R1AccF) then
      SetFieldProperties;
  end; {With GlobComp..}

  StartSize.X:=Width; StartSize.Y:=Height;

  Dispose(GlobComp,Destroy);

  {* Check form is within current visible range *}
end;

//------------------------------

procedure TRecepForm.Store_FormCoord(UpMode  :  Boolean);
Var
  GlobComp:  TGlobCompRec;
Begin

  New(GlobComp,Create(BOff));

  With GlobComp^ do
  Begin
    GetValues:=UpMode;

    PrimeKey:=Chr(Ord('!')+Ord(ExLocal.LInv.InvDocHed In SalesSplit));

    ColOrd:=Ord(StoreCoord);

    HLite:=Ord(LastCoord);

    SaveCoord:=StoreCoord;

    If (Not LastCoord) then {* Attempt to store last coord *}
      HLite:=ColOrd;

    StorebtControlCsm(Self);

    StorebtControlCsm(PageControl1);

    StorebtControlCsm(R1SBox);

    StorebtControlCsm(R1BSBox);

    StorebtControlCsm(R1BtnPanel);

    StorebtControlCsm(R1ListBtnPanel);

    StorebtControlCsm(R1AccF);

    //StorebtControlCsm(TCNScrollBox);

    //StorebtControlCsm(TCNListBtnPanel);

    If (PayCtrl<>nil) then
      PayCtrl.MULCtrlO.Store_ListCoord(GlobComp);
  end; {With GlobComp..}

  Dispose(GlobComp,Destroy);

end;

//-------------------------------------------------------------------------

procedure TRecepForm.LinkToCC;

Begin
  With Id do
  Begin
    CCLab.Caption:=CCDep[BOn];
    DepLab.Caption:=CCDep[BOff];
  end;
end;


procedure TRecepForm.BuildDesign;

Var
  HideCC  :  Boolean;

begin
  With ExLocal.LInv Do Begin
    {* Set Version Specific Info *}

    R1StatLab.Caption := 'STATUS:'#13'View Only';

    If (Not EnterpriseLicence.elIsMultiCcy) Then Begin
      // IFNDEF MC_On
      R1CurrLab.Visible:=BOff;
      R1CurrF.Visible:=BOff;
      R1XRateF.Visible:=BOff;
      R1XRateLab.Visible:=BOff;
      R1Base2Lab.Visible:=BOff;
      R1BaseF.Visible:=BOff;
      VarPanel.Visible:=BOff;
      ReqdTit.Caption:='Required';

      TransExtForm1.TabNext:=R1RValF;
    End; { If (Not EnterpriseLicence.elIsMultiCcy) }

    HideCC:=Not Syss.UseCCDep;

    CCPanel.Visible:=Not HideCC;

    R1AccF.MaxLength:=CustKeyLen;
    R1YRefF.MaxLength:=DocYRef1Len;

    If (InvDocHed In PurchSplit) then
      RecepPage.Caption:='Payment';

   //GS 17/11/2011 ABSEXCH-12037: modifed UDF settings code to use the new "CustomFieldsIntF" unit

  EnableUDFs([UDF1L, UDF2L, UDF3L, UDF4L, UDF5L, UDF6L, UDF7L, UDF8L, UDF9L, UDF10L],
             [THUD1F, THUD2F, THUD3F, THUD4F, THUD5F, THUD6F, THUD7F, THUD8F, THUD9F, THUD10F], DocTypeToCFCategory(ExLocal.LInv.InvDocHed, False), True);


  ResizeUDFParentContainer(NumberOfVisibleUDFs([THUD1F, THUD2F, THUD3F, THUD4F, THUD5F, THUD6F, THUD7F, THUD8F, THUD9F, THUD10F]),
                           2,
                           TransExtForm1);

    R1BSBox.HorzScrollBar.Visible:=BOff;
  End; { With ExLocal.LInv }
end;

//-------------------------------------------------------------------------

procedure TRecepForm.FormDesign;
begin
  If EnterpriseLicence.elIsMultiCcy Then Begin
    // IFDEF MC_On
    Set_DefaultCurr(R1CurrF.Items,BOff,BOff);
    Set_DefaultCurr(R1CurrF.ItemsL,BOff,BOn);
  End; { If EnterpriseLicence.elIsMultiCcy }
end;

//-------------------------------------------------------------------------

Procedure TRecepForm.RefreshList(ShowLines,IgMsg  :  Boolean);
Begin
  If (PayCtrl<>nil) then
    With ExLocal do
      If (LInv.FolioNum<>PayCtrl.GetFolio) and (ShowLines) then {* Refresh notes *}
        with PayCtrl do
        Begin
          ExLocal.LInv:=Self.ExLocal.LInv;
          RefreshList(LInv.FolioNum);
        end;
end;

//-------------------------------------------------------------------------

procedure TRecepForm.FormBuildList(ShowLines  :  Boolean);

Var
  PaySetUp    :  TPayInSetUp;
Begin
  Find_FormCoord;

  With ExLocal do
  Begin
    PayCtrl:=TPayLine.Create(Self);

    With PaySetUp do
    Begin
      ColPanels[0]:=R1NomPanel; ColPanels[1]:=R1NomLab;
      ColPanels[2]:=R1NomD2Panel; ColPanels[3]:=R1NomD2Lab;
      ColPanels[4]:=R1ChQPanel; ColPanels[5]:=R1ChQLab;

      ColPanels[6]:=R1PayPanel; ColPanels[7]:=R1PayLab;
      ColPanels[8]:=R1BasePanel; ColPanels[9]:=R1BaseLab;
      ColPanels[10]:=R1PayInPanel; ColPanels[11]:=R1PayInLab;

      ColPanels[12]:=R1HedPanel;
      ColPanels[13]:=R1ListBtnPanel;

      ScrollBox:=R1SBox;
      PropPopUp:=StoreCoordFlg;

      CoorPrime:=Chr(Ord('!')+Ord(LInv.InvDocHed In SalesSplit));
      CoorHasCoor:=LastCoord;

    end;

    try
      PayCtrl.CreateList(Self,PaySetUp,ShowLines,LInv);


    except
      PayCtrl.Free;
      PayCtrl:=Nil
    end;

    MDI_UpdateParentStat;

  end;


  FormSetOfSet;

  FormReSize(Self);

end;



{ ======== Display Receipt Record ========== }

procedure TRecepForm.SetRecepFields;
Var
  UOR :  Byte;
Begin
  With ExLocal,LInv do
  Begin
    R1ORefF.Text:=Pr_OurRef(LInv);
    R1OpoF.Text:=OpName;

    { CJS - 2013-10-28 - ABSEXCH-14705 - MRD2.6 - Transaction Originator }
    if (Trim(thOriginator) <> '') then
      R1OpoF.Hint := GetOriginatorHint(LInv)
    else
      R1OpoF.Hint := '';

    R1AccF.Text:=Strip('R',[#32],CustCode);

    R1TPerF.InitPeriod(AcPr,AcYr,BOn,BOn);

    R1TDateF.DateValue:=TransDate;

    R1YRefF.Text:=YourRef;

    If EnterpriseLicence.elIsMultiCcy Then Begin
      // $IFDEF MC_On
      If (Currency>0) then
        R1CurrF.ItemIndex:=Pred(Currency);

      R1XRateF.Value:=CXRate[BOn];

      UOR:=fxUseORate(BOff,BOn,CXRate,UseORate,Currency,0);

      R1BaseF.Value:=Conv_TCurr(InvNetVal,XRate(CXRate,BOff,Currency),Currency,UOR,BOff);
    End; { If EnterpriseLicence.elIsMultiCcy }

    DMDCNomF.Text:=Form_BInt(CtrlNom,0);

    CustToMemo(LCust,R1AddrF,0);

    R1RValF.Value:=InvNetVal;

    THUd1F.Text:=DocUser1;
    THUd2F.Text:=DocUser2;
    THUd3F.Text:=DocUser3;
    THUd4F.Text:=DocUser4;
    //GS 17/11/2011 ABSEXCH-12037: put customisation values into text boxes
    THUd5F.Text:=DocUser5;
    THUd6F.Text:=DocUser6;
    THUd7F.Text:=DocUser7;
    THUd8F.Text:=DocUser8;
    THUd9F.Text:=DocUser9;
    THUd10F.Text:=DocUser10;
  end; {With..}
end;


Procedure TRecepForm.OutRecepTotals;
Var
  Dnum  :  Double;
Begin
  With ExLocal,LInv do
  Begin
    Dnum:=(TotalReserved-(Variance+PostDiscAm));

    VarLab.Caption:=FormatFloat(GenRealMask,Dnum);

    // HM 22/01/03: Replaced PRequired with equiv code as can't include PayF2U
    //ReqdLab.Caption:=FormatFloat(GenRealMask,PRequired(BOn,LInv)*DocNotCnst);
    ReqdLab.Caption:=FormatFloat(GenRealMask,(ConvCurrITotal(LInv,BOff,BOff,BOn)-TotalInvoiced)*DocNotCnst);

    Dnum:=(DiscSetl-PostDiscAm);

    DiscLab.Caption:=FormatFloat(GenRealMask,Dnum);
  end; {With..}
end;


procedure TRecepForm.FormSetOfSet;

Begin
  PagePoint[0].X:=ClientWidth-(PageControl1.Width);
  PagePoint[0].Y:=ClientHeight-(PageControl1.Height);

  PagePoint[1].X:=PageControl1.Width-(R1SBox.Width);
  PagePoint[1].Y:=PageControl1.Height-(R1SBox.Height);

  PagePoint[2].X:=PageControl1.Width-(R1BtnPanel.Left);
  PagePoint[2].Y:=PageControl1.Height-(R1BtnPanel.Height);

  PagePoint[3].X:=R1BtnPanel.Height-(R1BSBox.Height);
  PagePoint[3].Y:=R1SBox.ClientHeight-(R1NomPanel.Height);

  PagePoint[4].X:=PageControl1.Width-(R1ListBtnPanel.Left);
  PagePoint[4].Y:=PageControl1.Height-(R1ListBtnPanel.Height);

  //PagePoint[5].X:=PageControl1.Width-(TCNScrollBox.Width);
  //PagePoint[5].Y:=PageControl1.Height-(TCNScrollBox.Height);

  //PagePoint[6].X:=PageControl1.Width-(TCNListBtnPanel.Left);
  //PagePoint[6].Y:=PageControl1.Height-(TCNListBtnPanel.Height);


  GotCoord:=BOn;

end;





procedure TRecepForm.PayIPageReSize;
Begin
  With R1SBox do
  Begin
    R1HedPanel.Width:=HorzScrollBar.Range;
    R1NomPanel.Height:=R1SBox.ClientHeight-PagePoint[3].Y;
  end;

  R1NomD2Panel.Height:=R1NomPanel.Height;
  R1ChQPanel.Height:=R1NomPanel.Height;
  R1PayPanel.Height:=R1NomPanel.Height;
  R1BasePanel.Height:=R1NomPanel.Height;
  R1PayInPanel.Height:=R1NomPanel.Height;


  If (PayCtrl<>nil) and (PayCtrl.MULCtrlO<>Nil) then {* Adjust list *}
  With PayCtrl.MULCtrlO,VisiList do
  Begin
    VisiRec:=List[0];

    With (VisiRec^.PanelObj as TSBSPanel) do
        Height:=R1NomPanel.Height;

    ReFresh_Buttons;

    RefreshAllCols;
  end;
end;



procedure TRecepForm.FormResize(Sender: TObject);
Var
  NewVal      :  Integer;
begin
  If (GotCoord) then
  Begin

    Self.HorzScrollBar.Position:=0;
    Self.VertScrollBar.Position:=0;

    NewVal:=ClientWidth-PagePoint[0].X;
    (* HM Handled by Constraints
    If (NewVal<MinWidth) then
      NewVal:=MinWidth;
    *)

    PageControl1.Width:=NewVal;

    NewVal:=ClientHeight-PagePoint[0].Y;
    (* HM Handled by Constraints
    If (NewVal<MinHeight) then
      NewVal:=MinHeight;
    *)

    PageControl1.Height:=NewVal;


    R1SBox.Width:=PageControl1.Width-PagePoint[1].X;
    R1SBox.Height:=PageControl1.Height-PagePoint[1].Y;


    {TCNScrollBox.Width:=PageControl1.Width-PagePoint[5].X;
    TCNScrollBox.Height:=PageControl1.Height-PagePoint[5].Y;}


    R1BtnPanel.Left:=PageControl1.Width-PagePoint[2].X;
    R1BtnPanel.Height:=PageControl1.Height-PagePoint[2].Y;

    R1BSBox.Height:=R1BtnPanel.Height-PagePoint[3].X;

    R1ListBtnPanel.Left:=PageControl1.Width-PagePoint[4].X;
    R1ListBtnPanel.Height:=PageControl1.Height-PagePoint[4].Y;


    {TCNListBtnPanel.Left:=PageControl1.Width-PagePoint[6].X;
    TCNListBtnPanel.Height:=PageControl1.Height-PagePoint[6].Y;}

    //NotePageResize;
    PayIPageResize;

    NeedCUpdate:=((StartSize.X<>Width) or (StartSize.Y<>Height));

  end; {If time to update}
end;


procedure TRecepForm.ClsR1BtnClick(Sender: TObject);
begin
  Close;
end;

procedure TRecepForm.PopupMenu1Popup(Sender: TObject);
begin
  StoreCoordFlg.Checked:=StoreCoord;
end;

function TRecepForm.R1TPerFShowPeriod(Sender: TObject;
  const EPr: Byte): string;
begin
  Result:=PPr_Pr(EPr);
end;


procedure TRecepForm.OkR1BtnClick(Sender: TObject);
begin
  Close;
end;


procedure TRecepForm.SetFieldProperties;
Var
  n  : Integer;
Begin
  SBSPanel1.Color:=R1FPanel.Color;
  R1BtnPanel.Color:=R1FPanel.Color;

  For n:=0 to Pred(ComponentCount) do
  Begin
    If (Components[n] is TMaskEdit) or (Components[n] is TComboBox)
     or (Components[n] is TCurrencyEdit) and (Components[n]<>R1AccF) then
    With TGlobControl(Components[n]) do
      If (Tag>0) then
      Begin
        Font.Assign(R1AccF.Font);
        Color:=R1AccF.Color;
      end;

    If (Components[n] is TBorCheck) then
      With (Components[n] as TBorCheck) do
      Begin
        CheckColor:=R1AccF.Color;
        Color:=R1FPanel.Color;
      end;

  end; {Loop..}

  R1AddrF.Color:=R1AccF.Color;
  R1AddrF.Font.Assign(R1AccF.Font);
end;


procedure TRecepForm.SetFormProperties(SetList  :  Boolean);
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

    TmpPanel[1].Font:=R1AccF.Font;
    TmpPanel[1].Color:=R1AccF.Color;

    TmpPanel[2].Font:=R1FPanel.Font;
    TmpPanel[2].Color:=R1FPanel.Color;


    ColourCtrl:=TCtrlColor.Create(Self);

    try
      With ColourCtrl do
      Begin
        SetProperties(TmpPanel[1],TmpPanel[2],TmpPanel[3],Ord(SetList),Self.Caption+' '+PropTit[SetList]+' Properties',BeenChange,ResetDefaults);

        NeedCUpdate:=(BeenChange or ResetDefaults);

        If (BeenChange) and (not ResetDefaults) then
        Begin

          R1FPanel.Font.Assign(TmpPanel[2].Font);
          R1FPanel.Color:=TmpPanel[2].Color;

          R1AccF.Font.Assign(TmpPanel[1].Font);
          R1AccF.Color:=TmpPanel[1].Color;

          SetFieldProperties;
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


procedure TRecepForm.PropFlgClick(Sender: TObject);
Begin
  If (N3.Tag=99) and (PayCtrl<>nil) then
  Begin
    N3.Tag:=0;
    PayCtrl.SetFormProperties;
  end
  else
    SetFormProperties(BOff);
end;


procedure TRecepForm.StoreCoordFlgClick(Sender: TObject);
begin
  StoreCoord:=Not StoreCoord;

  NeedCUpdate:=BOn;
end;

//-------------------------------------------------------------------------

procedure TRecepForm.DisplayTrans (Const TheTrans : InvRec; Const TheCust : CustRec);
Begin { DisplayTrans }
  // Get static data from database
  ExLocal.LInv := TheTrans;
  ExLocal.LCust := TheCust;

  // Update Form Caption
  Caption := Trim(EnterpriseData.edCompanyCode) + ', ' + ExLocal.LInv.OurRef;

  // Update form layout for licencing and document type
  BuildDesign;

  // Setup Currencies, Decimals, etc...
  FormDesign;

  // Display Invoice
  SetRecepFields;

  // Display Invoice Footer Totals
  OutRecepTotals;

  ReFreshList (True, True);
End; { DisplayTrans }

//-------------------------------------------------------------------------

procedure TRecepForm.btnViewLineClick(Sender: TObject);
begin
 If PayCtrl.MULCtrlO.ValidLine Then
   PayCtrl.AddEditPay(True,True,0,0,ExLocal.LInv);
end;

end.
