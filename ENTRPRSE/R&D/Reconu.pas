unit ReconU;

{$I DEFOVR.Inc}

{$F+}

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ExtCtrls, SBSPanel, ComCtrls,
  GlobVar,VarConst,SBSComp,SBSComp2,ExWrap1U,BTSupU1,SupListU, Menus,
  TEditVal,

  // MH 09/03/2018 2018-R2 ABSEXCH-19172: Added support for exporting lists
  WindowExport, ExportListIntf, oExcelExport,

  Recon3U,
  ExtGetU,
  Tranl1U,
  EntWindowSettings;

type
  // CJS 2011-08-02 ABSEXCH-11044 - PORs showing in GL History Drill-Down
  // Added descendant of TDDMList to provide additional filtering
  TReconDDMList = class(TDDMList)
  public
    function ExtFilter: Boolean; override;
  end;

  TReconList = class(TForm)
    PageControl1: TPageControl;
    ItemPage: TTabSheet;
    D1SBox: TScrollBox;
    D1ListBtnPanel: TSBSPanel;
    GroupPage: TTabSheet;
    D2SBox: TScrollBox;
    D2DatePanel: TSBSPanel;
    D2ORefPanel: TSBSPanel;
    D2AccPanel: TSBSPanel;
    D2AmtPanel: TSBSPanel;
    D2StatPanel: TSBSPanel;
    d2HedPanel: TSBSPanel;
    D2ORefLab: TSBSPanel;
    D2DateLab: TSBSPanel;
    D2AccLab: TSBSPanel;
    D2AmtLab: TSBSPanel;
    D2StatLab: TSBSPanel;
    D2DesLab: TSBSPanel;
    D2DesPanel: TSBSPanel;
    d2ListBtnPanel: TSBSPanel;
    D1BtnPanel: TSBSPanel;
    D1BSBox: TScrollBox;
    ClrD1Btn: TButton;
    UnCD1Btn: TButton;
    FindD1Btn: TButton;
    ViewD1Btn: TButton;
    EditD1Btn: TButton;
    CopyD1Btn: TButton;
    NoteD1Btn: TButton;
    ChkD1Btn: TButton;
    Clsd1Btn: TButton;
    D1HedPanel: TSBSPanel;
    D1ORefLab: TSBSPanel;
    D1DateLab: TSBSPanel;
    D1AccLab: TSBSPanel;
    D1AmtLab: TSBSPanel;
    D1StatLab: TSBSPanel;
    D1DesLab: TSBSPanel;
    D1ORefPanel: TSBSPanel;
    D1DatePanel: TSBSPanel;
    D1AccPanel: TSBSPanel;
    D1DesPanel: TSBSPanel;
    D1AmtPanel: TSBSPanel;
    D1StatPanel: TSBSPanel;
    PopupMenu1: TPopupMenu;
    N2: TMenuItem;
    PropFlg: TMenuItem;
    N1: TMenuItem;
    StoreCoordFlg: TMenuItem;
    Edit1: TMenuItem;
    Check1: TMenuItem;
    Notes1: TMenuItem;
    PopupMenu2: TPopupMenu;
    NClr1: TMenuItem;
    Cancelled1: TMenuItem;
    Ret1: TMenuItem;
    PopupMenu3: TPopupMenu;
    Amount1: TMenuItem;
    NotCleared2: TMenuItem;
    UnclearedAmount1: TMenuItem;
    LineDetails1: TMenuItem;
    AccountCode1: TMenuItem;
    TotalPanel: TSBSPanel;
    Label82: Label8;
    Label81: Label8;
    TotBalance: TCurrencyEdit;
    TotCleared: TCurrencyEdit;
    PopupMenu4: TPopupMenu;
    Copy2: TMenuItem;
    Reverse1: TMenuItem;
    FIClr1: TMenuItem;
    Copy1: TMenuItem;
    View1: TMenuItem;
    Clear1: TMenuItem;
    Unclear1: TMenuItem;
    Find1: TMenuItem;
    D1DatPanel: TSBSPanel;
    D1DatLab: TSBSPanel;
    PopupMenu5: TPopupMenu;
    Check2: TMenuItem;
    Check3: TMenuItem;
    D1ReconLab: TSBSPanel;
    D1ReconPanel: TSBSPanel;
    ReconciliationDate1: TMenuItem;
    PopupMenu6: TPopupMenu;
    ClearedBalance: TMenuItem;
    YTDBalance: TMenuItem;
    WindowExport: TWindowExport;
    procedure PageControl1Changing(Sender: TObject;
      var AllowChange: Boolean);
    procedure PageControl1Change(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure FormKeyPress(Sender: TObject; var Key: Char);
    procedure FormResize(Sender: TObject);
    procedure Clsd1BtnClick(Sender: TObject);
    procedure D1ORefPanelMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure D1ORefLabMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure D1ORefLabMouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure PopupMenu1Popup(Sender: TObject);
    procedure PropFlgClick(Sender: TObject);
    procedure StoreCoordFlgClick(Sender: TObject);
    procedure ClrD1BtnClick(Sender: TObject);
    procedure UnCD1BtnClick(Sender: TObject);
    procedure Amount1Click(Sender: TObject);
    procedure Copy2Click(Sender: TObject);
    procedure ChkD1BtnClick(Sender: TObject);
    procedure ViewD1BtnClick(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure FIClr1Click(Sender: TObject);
    procedure PopupMenu4Popup(Sender: TObject);
    procedure Check2Click(Sender: TObject);
    procedure RecalculateBalance(Sender: TObject);
    function WindowExportEnableExport: Boolean;
    procedure WindowExportExecuteCommand(const CommandID: Integer;
      const ProgressHWnd: HWND);
    function WindowExportGetExportDescription: String;
  private
    { Private declarations }

    
    InHBeen,
    JustCreated,
    StopPageChange,
    StoreCoord,
    LastCoord,
    SetDefault,
    fNeedCUpdate,
    fFrmClosing,
    fDoingClose,
    GotCoord,
    CanDelete    :  Boolean;


    MinHeight,
    MinWidth     :  Integer;

    LastGroup    :  LongInt;

    InvBtnList   :  TVisiBtns;

    FNCMode      :  Array[0..1] of Boolean;

    PagePoint    :  Array[0..4] of TPoint;

    StartSize,
    InitSize     :  TPoint;

    DispTrans    :  TFInvDisplay;

    PayInFormPtr :  Pointer;

    // CJS: 13/12/2010 - Amendments for new Window Settings system
    FSettings: IWindowSettings;
    procedure LoadListSettings(ListNo: Integer);
    procedure SaveListSettings(ListNo: Integer);
    procedure LoadWindowSettings;
    procedure SaveWindowSettings;
    procedure EditWindowSettings;

    procedure FormSetOfSet;

    Function ScanMode  :  Boolean;

    Procedure WMCustGetRec(Var Message  :  TMessage); Message WM_CustGetRec;

    Procedure WMFormCloseMsg(Var Message  :  TMessage); Message WM_FormCloseMsg;

    Procedure WMGetMinMaxInfo(Var Message  :  TWMGetMinMaxInfo); Message WM_GetMinMaxInfo;

    

    Procedure Send_UpdateList(Mode   :  Integer);

    procedure Page1Create(Sender   : TObject;
                          NewPage  : Byte);

    procedure ShowRightMeny(X,Y,Mode  :  Integer);


    procedure Display_Trans(Mode  :  Byte);

    procedure Display_PayIn(ChangeFocus :  Boolean);

    Procedure  SetNeedCUpdate(B  :  Boolean);

    Property NeedCUpDate :  Boolean Read fNeedCUpDate Write SetNeedCUpdate;

    Function CheckListFinished  :  Boolean;

    procedure RunCheck(Sender: TObject);

    procedure Link2Inv;

  public
    { Public declarations }

    ExLocal    :  TdExLocal;
    ListOfSet  :  Integer;

    NCCtrl     :  Array[0..1] of TNHCtrlRec;

    DDCtrl     :  TNHCtrlRec;

    MULCtrlO   :  Array[0..1] of TReconDDMList;


    procedure PrimeButtons;

    procedure BuildDesign;

    procedure BuildMenus;

    procedure FormDesign;

    Function Current_BarPos(PageNo  :  Byte)  :  Integer;


    procedure RefreshList(ShowLines,
                          IgMsg      :  Boolean);

    procedure FormBuildList(ShowLines  :  Boolean);

    Function Current_Page  :  Integer;

    procedure SetCaption;

    procedure ShowLink(ShowLines  :  Boolean);

    Procedure ChangePage(NewPage  :  Integer);

    procedure SetFormProperties;

    procedure Out_ReconBal;

  end;


  Procedure Set_DDFormMode(State  :  TNHCtrlRec);


{~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~}

Implementation

{~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~}

Uses
  ETStrU,
  ETMiscU,
  ETDateU,
  BtrvU2,
  BTSupU2,
  BTSupU3,
  BTKeys1U,
  CmpCtrlU,
  ColCtrlU,

  ComnUnit,
  ComnU2,
  CurrncyU,
  InvListU,

  {$IFDEF DBD}
    DebugU,
  {$ENDIF}

  SysU1,
  SysU2,
  IntMU,
  MiscU,
  PayF2U,
  Warn1U,
  SalTxl1U,
  NLPayInU,

  {$IFDEF POST}
    PostingU,
    PostSp2U,
  {$ENDIF}

  PWarnU,
  ExThrd2U,
  ConvDocU,

  Event1U,
  CustIntU,

  { CJS 2013-02-26 - ABSEXCH-14054 - G/L Drill-down in SQL }
  SQLUtils;

{$R *.DFM}



Var
  DDFormMode  :  TNHCtrlRec;



{ ========= Exported function to set View type b4 form is created ========= }

Procedure Set_DDFormMode(State  :  TNHCtrlRec);

Begin

  DDFormMode:=State;

end;

{ TReconDDMList }

// CJS 2011-08-02 ABSEXCH-11044 - PORs showing in GL History Drill-Down
function TReconDDMList.ExtFilter: Boolean;
const
  ExcludeDocTypes = [POR, SOR, PDN, SDN, PQU, SQU, ADJ, TSH, WOR];
begin
  Result := inherited ExtFilter;
  if Result then
  begin
    // Filter out document types which should not appear in G/L History
    if (Id.IdDocHed in ExcludeDocTypes) then
      Result := False;
  end;

  if Result then
  begin
    //PR: 24/02/2017 ABSEXCH-18116 v2017 R1
    //Moved CJ's fix from RefreshList to here and changed to
    //check Run Number explicitly, as the original fix was setting
    //one of the filters to #0 which excluded any line where 1st byte
    //of Run No was #0 - i.e any number divisible by 256.
     
    { CJS 2013-02-26 - ABSEXCH-14054 - G/L Drill-down in SQL erroneously
                                            includes unposted records. }
    if SQLUtils.UsingSQLAlternateFuncs and (LNHCtrl.NHMode = 15) then
    begin
      // Exclude records where the Run Number (set by
      // TDDMList.SetFilter() in ExtGetU.pas) is zero (i.e. unposted).
      Result := Id.PostedRun <> 0;
    end;
  end;
end;

Function TReconList.Current_Page  :  Integer;
Begin

  Result:=pcLivePage(PAgeControl1);

end;



Procedure  TReconList.SetNeedCUpdate(B  :  Boolean);

Begin
  If (Not fNeedCUpdate) then
    fNeedCUpdate:=B;
end;

procedure TReconList.FormSetOfSet;

Begin
  PagePoint[0].X:=HorzScrollBar.Range-(PageControl1.Width);
  PagePoint[0].Y:=ClientHeight-(PageControl1.Height);

  PagePoint[1].X:=PageControl1.Width-(D1SBox.Width);
  PagePoint[1].Y:=PageControl1.Height-(D1SBox.Height);

  PagePoint[2].X:=PageControl1.Width-(D1BtnPanel.Left);
  PagePoint[2].Y:=PageControl1.Height-(D1BtnPanel.Height);

  PagePoint[3].X:=D1BtnPanel.Height-(D1BSBox.Height);
  PagePoint[3].Y:=D1SBox.ClientHeight-(D1ORefPanel.Height);

  PagePoint[4].X:=PageControl1.Width-(D1ListBtnPanel.Left);
  PagePoint[4].Y:=PageControl1.Height-(D1ListBtnPanel.Height);

  GotCoord:=BOn;

end;


Function TReconList.ScanMode  :  Boolean;

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


Procedure TReconList.WMCustGetRec(Var Message  :  TMessage);
var
 Ok2Exe : Boolean;
 KeyS : Str255;
 Res : Integer;
Begin


  With Message do
  Begin

    {If (Debug) then
      DebugForm.Add('Mesage Flg'+IntToStr(WParam));}

    Case WParam of
      0,1,169
         :  Begin
              If (WParam=169) then {* Treat as 0 *}
              Begin
                MULCtrlO[Current_Page].GetSelRec(BOff);
                WParam:=0;
              end;

              Case Current_Page of

                0  :  Begin
                        InHBeen:=((WParam=0) or ((InHBeen) and ScanMode));

                        //PR: 15/02/2016 v2016 R1 ABSEXCH-17308 Check list scan security hook
                        {$IFDEF CU}
                        if (InHBeen) and ScanMode and (CustomHandlers.CheckHandlerStatus (102000, 156) = 1) then
                        begin
                           //PR: 19/02/2016 v2016 R1 ABSEXCH-17320 Don't necessarily have invoice at this point, so may need to find it
                           if Inv.FolioNum <> Id.FolioRef then
                           begin
                              KeyS := FullNomKey(Id.FolioRef);
                              Res := Find_Rec(B_GetEq, F[InvF], InvF, RecPtr[InvF]^, InvFolioK, KeyS);
                           end;

                           ExLocal.AssignFromGlobal(InvF);
                           Ok2Exe:=ExecuteCustBtn(2000,156,ExLocal);
                        end
                        else
                       {$ENDIF Customisation}
                          OK2Exe := True;

                        if Ok2Exe then

                        Display_Trans(99+WParam);
                      end;

                1  :  Begin                                                  
                        If (PayInFormPtr<>nil) or (WParam=0) then
                        Begin
                          Display_PayIn(BOn);
                        end;
                      end;
              end; {Case..}

            end;


      2  :  ShowRightMeny(LParamLo,LParamHi,1);

      25 :  NeedCUpdate:=BOn;

      

      175
         :  With PageControl1 do
              ChangePage(FindNextPage(ActivePage,(LParam=0),BOn).PageIndex);

      200
         :  DispTrans:=nil;

      {3000,
      3001,
      3010,
      3011
         :  Begin
              If (WParam<3010) and (WindowState=wsMinimized) then
                WindowState:=wsNormal;

              If (WindowState<>wsMinimized) and (Not ExLocal.InAddEdit) then
              Begin
                ShowLink(BOn,BOn);
              end;
            end;}



    end; {Case..}

  end;
  Inherited;
end;


Procedure TReconList.WMFormCloseMsg(Var Message  :  TMessage);


Begin

  With Message do
  Begin

    Case WParam of

      8  :  Out_ReconBal; {* Update balance after full check *}


      45 :  Begin
              PayInFormPtr:=nil;
            end;

      65
         :  Begin
              InHBeen:=((WParam=65) or (InHBeen));

              Display_Trans(99);
            end;
      70,72
         :  Begin {Relay on command to hide totals from check actuals}
              PostMessage((Owner as TForm).Handle,WM_FormCloseMsg,WParam,LParam);
            end;

    end; {Case..}

  end;

  Inherited;
end;


Procedure TReconList.WMGetMinMaxInfo(Var Message  :  TWMGetMinMaxInfo);

Begin

  With Message.MinMaxInfo^ do
  Begin

    ptMinTrackSize.X:=200;
    ptMinTrackSize.Y:=210;

    {ptMaxSize.X:=530;
    ptMaxSize.Y:=368;
    ptMaxPosition.X:=1;
    ptMaxPosition.Y:=1;}

  end;

  Message.Result:=0;

  Inherited;

end;

{ == Procedure to Send Message to Get Record == }

Procedure TReconList.Send_UpdateList(Mode   :  Integer);

Var
  Message1 :  TMessage;
  MessResult
           :  LongInt;

Begin
  FillChar(Message1,Sizeof(Message1),0);

  With Message1 do
  Begin
    MSg:=WM_FormCloseMsg;
    WParam:=Mode;
    LParam:=0;
  end;

  With Message1 do
    MessResult:=SendMessage((Owner as TForm).Handle,Msg,WParam,LParam);

end; {Proc..}




procedure TReconList.SetCaption;

Const
  FiltTit  :  Array[BOff..BOn] of Str10 = ('',' Uncleared items.');

Var
  PayInStr,
  LevelStr  :  Str255;

Begin
  PayInStr:='';
  LevelStr:='Bug!';

  With ExLocal,DDCtrl do
  Begin
    If (NHMode=5) then
      PayInStr:='Paying In';

    With LNom do
    Begin
      LevelStr:=dbFormatName(Form_Int(NomCode,0),Desc)+':';

      If (NomType In BankSet) then
        LevelStr:=LevelStr+PayInStr+' '+Show_TreeCur(NHCr,NHTxCr)+' Reconciliation.'
      else
        LevelStr:=LevelStr+PayInStr+' '+Show_TreeCur(NHCr,NHTxCr)+' Audit.';
    end;

    Caption:=Show_CCFilt(NHCDCode,NHCCMode)+LevelStr+FiltTit[NHDDRecon<>0];

  end;

end;


procedure TReconList.ShowLink(ShowLines :  Boolean);
begin
  ExLocal.AssignFromGlobal(NomF);

  DDCtrl:=DDFormMode;

  SetCaption;

  BuildDesign;

  If (Not GroupPage.TabVisible) and (Current_Page=1) then
    ChangePage(0);
    
  ReFreshList(ShowLines,Not JustCreated);


  JustCreated:=BOff;

end;


procedure TReconList.PrimeButtons;

Var
  n,
  PageNo  :  Integer;

Begin
  PageNo:=Current_Page;

  If (InvBtnList=nil) then
  Begin
    InvBtnList:=TVisiBtns.Create;

    try

      With InvBtnList do
        Begin
          PWAddVisiRec(ClrD1Btn,BOff,196);
          PWAddVisiRec(UnCD1Btn,BOff,196);
          AddVisiRec(FindD1Btn,BOff);
          AddVisiRec(ViewD1Btn,BOff);
          PWAddVisiRec(CopyD1Btn,(ICEDFM<>0),197);

          {PWAddVisiRec(EditD1Btn,BOff,203); * EX32 Disabled until connected }
          PWAddVisiRec(EditD1Btn,BOff,0);

          AddVisiRec(ChkD1Btn,BOff);
          AddVisiRec(NoteD1Btn,BOff);
        end; {With..}

    except

      InvBtnList.Free;
      InvBtnList:=nil;
    end; {Try..}

  end; {If needs creating }

  try

    With InvBtnList do
    Begin
      PWSetHideBtn(4,(PageNo=1) or (ICEDFM<>0),BOff,197);

      {PWSetHideBtn(5,(PageNo=1),BOff,203);  * Disabled until connected }

      PWSetHideBtn(5,(PageNo=1),BOff,0);


      SetHideBtn(6,(PageNo=1),BOff);
      SetHideBtn(7,(PageNo=1),BOn);

    end;

  except
    InvBtnList.Free;
    InvBtnList:=nil;
  end; {try..}

end;

procedure TReconList.BuildDesign;


begin

  {* Set Version Specific Info *}

  If (MULCtrlO[0]<>nil) then
    With MULCtrlO[0],ExLocal,LNom do
    Begin
      GroupPage.TabVisible:=((Has_PayInMode(NomCode)) and (NomType<>CarryFlg));

      TotalPanel.Visible:=(NomType In YTDSet);

      Out_ReconBal;
    end;

end;




procedure TReconList.BuildMenus;

Begin
  CreateSubMenu(PopUpMenu2,UnClear1);
  CreateSubMenu(PopUpMenu3,Find1);
  CreateSubMenu(PopUpMenu4,Copy1);
  //AP: 03/10/2017 ABSEXCH-16645 Built-in Cumulative cleared balance recalc
  CreateSubMenu(PopUpMenu6,Check1);
end;

procedure TReconList.FormDesign;


begin

  PrimeButtons;

  BuildDesign;

  BuildMenus;

end;

Function TReconList.Current_BarPos(PageNo  :  Byte)  :  Integer;

Begin
  Case PageNo of
      0
         :  Result:=D1SBox.HorzScrollBar.Position;
      1
         :  Result:=D2SBox.HorzScrollBar.Position;

      else  Result:=0;
    end; {Case..}

end;

procedure TReconList.RefreshList(ShowLines,
                                 IgMsg      :  Boolean);

Var
  KeyStart,
  PrimeKey    :  Str255;
  PYr,PrPr    :  Byte;

  UseKeyPath,
  LKeyLen     :  Integer;
Begin
  Blank(PrimeKey,Sizeof(PrimeKey));

  UseKeyPath:=IdNomK;

  KeyStart:=DDCtrl.MainK;
  LKeyLen:=DDCtrl.NHKeyLen;

  With MULCtrlO[Current_Page] do
  Begin
    LNHCtrl:=DDCtrl;

    StartLess:=(Current_Page=1);

    With LNHCtrl do
    Begin
      If (NHNeedGExt) then
      Begin
        If (NomExtObjPtr=nil) then
          ExtObjCreate;

        With NomExtRecPtr^ do
        Begin
          FCr:=NHCr;


          If (NHSDDFilt) then
          Begin
            If (NHYTDMode) then
              FPr:=YTD
            else
              FPr:=NHPr;

            FYr:=NHYr;
          end
          else
          Begin
            FPr:=YTD;
            FYr:=YTD;
          end;

          FNomCode:=NHNomCode;


          If (Current_Page=1) then
          Begin
            FNomMode:=PayInNomMode;
            FNomCode:=FNomCode*DocNotCnst;

          end;


          FRDate:=Today;

          {$IFDEF MC_On}
            If (FCr<>0) then
               FMode:=2
             else
               FMode:=1;
           {$ELSE}
              FMode:=2;
           {$ENDIF}

          {$IFDEF PF_On}
            If (NHCCDDMode) or (Not NHSDDFilt) then
            {$IFDEF MC_On}
                LKeyLen:=Succ(Sizeof(Nom.NomCode))+Pred(FMode);  {* NomCode+NomMode *}
            {$ELSE}
                LKeyLen:=Succ(Sizeof(Nom.NomCode))+1;  {* NomCode+NomMode+Cr *}
            {$ENDIF}


            If (Not EmptyKeyS(NHCDCode,ccKeyLen,BOff)) then
            Begin
              FCCode:=NHCDCode;
              FMode:=FMode+((10*FMode)+Ord(NHCCMode))+(20*Ord(NHCCDDMode));
            end;

          {$ENDIF}

          FMode:=FMode+(100*Ord(NHDDRecon<>0));
        end;
      end
      else
      Begin
        If (NomExtObjPtr<>nil) then
          ExtObjDestroy; {* Remove previous link *}

        {$IFDEF SOP}
          If (NHCommitView=0) and (CommitAct) then
            Filter[1,1]:=NdxWeight;

        {$ENDIF}

        If (NHUnPostMode) then
        Begin
          UseKeypath:=IdRunK;
          Filter[1,1]:=NdxWeight;

        end;
      end;

      If (Current_Page=1) then
      Begin
        KeyStart:=FullIdPostKey(NHNomCode*DocNotCnst,0,PayInNomMode,NHCr,NHYr,NHPr);

        PYr:=NHYr; PrPr:=NHPr;

        If (LNHCtrl.NHSddFilt) then
          AdjPr(PYr,PrPr,BOff)
        else
        Begin
          PYr:=1;
          PrPr:=1;
        end;

        PrimeKey:=FullIdPostKey(NHNomCode*DocNotCnst,0,PayInNomMode,NHCr,PYr,PrPr);
      end;
    end; {With..}


    IgnoreMsg:=IgMsg;

    { CJS 2013-02-26 - ABSEXCH-14054 - G/L Drill-down in SQL }
    StartList(IDetailF,UseKeyPath,KeyStart,'',PrimeKey,LKeyLen,(Not ShowLines));

    IgnoreMsg:=BOff;
  end;

end;


procedure TReconList.FormBuildList(ShowLines  :  Boolean);

Var
  StartPanel  :  TSBSPanel;
  n           :  Byte;



Begin
  MULCtrlO[0]:=TReconDDMList.Create(Self);
  MULCtrlO[0].Name := 'ReconItemisedList';


  Try

    With MULCtrlO[0] do
    Begin


      Try

        With VisiList do
        Begin
          AddVisiRec(D1ORefPanel,D1ORefLab);   // Doc
          AddVisiRec(D1DatePanel,D1DateLab);   // Period
          AddVisiRec(D1AccPanel,D1AccLab);     // A/C
          AddVisiRec(D1DesPanel,D1DesLab);     // Description
          AddVisiRec(D1AmtPanel,D1AmtLab);     // Amount
          AddVisiRec(D1StatPanel,D1StatLab);   // Status
          AddVisiRec(D1DatPanel,D1DatLab);     // TransDate
          //PR: 20/03/2009 Added Reconciliation Date
          AddVisiRec(D1ReconPanel,D1ReconLab); // Reconciliation Date

          // MH 09/03/2018 2018-R2 ABSEXCH-19172: Added metadata for List Export functionality
          ColAppear^[1].ExportMetadata := emtPeriod;
          ColAppear^[4].ExportMetadata := emtCurrencyAmount;
          ColAppear^[6].ExportMetadata := emtDate;
          ColAppear^[7].ExportMetadata := emtDate;

          VisiRec:=List[0];

          StartPanel:=(VisiRec^.PanelObj as TSBSPanel);

          {HidePanels(0);}

          LabHedPanel:=D1HedPanel;

          SetHedPanel(ListOfSet);

        end;
      except
        VisiList.Free;

      end;


      ListOfSet:=10;


      TabOrder := -1;
      TabStop:=BOff;
      Visible:=BOff;
      BevelOuter := bvNone;
      ParentColor := False;
      Color:=StartPanel.Color;
      MUTotCols:=7; //PR: 20/03/2009 Incremented to 7 to accommodate Reconciliation Date
      Font:=StartPanel.Font;

      LinkOtherDisp:=BOn;

      WM_ListGetRec:=WM_CustGetRec;


      // CJS: 14/12/2010 - Amendments for new Window Settings system
      LoadListSettings(0);

      Parent:=StartPanel.Parent;

      MessHandle:=Self.Handle;

      For n:=0 to MUTotCols do
      With ColAppear^[n] do
      Begin
        AltDefault:=BOn;

        If (n In [4]) then
        Begin
          DispFormat:=SGFloat;

          NoDecPlaces:=2
        end;
      end;


      ListLocal:=@ExLocal;

      ListCreate;

      UseSet4End:=BOn;

      NoUpCaseCheck:=BOn;

      HighLiteStyle[1]:=[fsBold];

      Set_Buttons(D1ListBtnPanel);

      ReFreshList(ShowLines,BOff);

    end {With}


  Except

    MULCtrlO[0].Free;
    MULCtrlO[0]:=Nil;
  end;


  FormSetOfSet;

  FormReSize(Self);

end;


procedure TReconList.Page1Create(Sender   : TObject;
                                 NewPage  : Byte);

Var
  n           :  Byte;

  StartPanel  :  TSBSPanel;

  KeyStart,
  KeyEnd      :  Str255;

begin

   MULCtrlO[NewPage]:=TReconDDMList.Create(Self);
   MULCtrlO[NewPage].Name := 'ReconGroupedList';


   Try

     With MULCtrlO[NewPage] do
     Begin

       Try

         With VisiList do
         Begin
           Case NewPage of
             1  :  Begin
                     AddVisiRec(D2ORefPanel,D2ORefLab);      // Doc
                     AddVisiRec(D2DatePanel,D2DateLab);      // Period
                     AddVisiRec(D2AccPanel,D2AccLab);        // A/C
                     AddVisiRec(D2DesPanel,D2DesLab);        // Description
                     AddVisiRec(D2AmtPanel,D2AmtLab);        // Amount
                     AddVisiRec(D2StatPanel,D2StatLab);      // Status

                     // MH 09/03/2018 2018-R2 ABSEXCH-19172: Added metadata for List Export functionality
                     ColAppear^[1].ExportMetadata := emtPeriod;
                     ColAppear^[4].ExportMetadata := emtCurrencyAmount;
                   end;
           end; {Case..}


           {HidePanels(NewPage);}

           VisiRec:=List[0];

           StartPanel:=(VisiRec^.PanelObj as TSBSPanel);

           LabHedPanel:=D2HedPanel;

         end;
       except
         VisiList.Free;

       end;

       Match_VisiList(MULCtrlO[0].VisiList,VisiList);

       TabOrder := -1;
       TabStop:=BOff;
       Visible:=BOff;
       BevelOuter := bvNone;
       ParentColor := False;
       Color:=StartPanel.Color;
       MUTotCols:=5;
       Font:=StartPanel.Font;
       LinkOtherDisp:=Bon;

       WM_ListGetRec:=WM_CustGetRec;

       // CJS: 14/12/2010 - Amendments for new Window Settings system
       LoadListSettings(NewPage);

       Parent:=StartPanel.Parent;

       MessHandle:=Self.Handle;

       For n:=0 to MUTotCols do
       With ColAppear^[n] do
       Begin
         AltDefault:=BOn;

         {HBkColor:=ClHighLight;
         HTextColor:=ClHighLightText;}


         If (n=4) then
         Begin
           DispFormat:=SGFloat;
           NoDecPlaces:=2;
         end;
       end;

       ListCreate;

       UseSet4End:=BOn;

       NoUpCaseCheck:=BOn;

       HighLiteStyle[1]:=[fsBold];

       Case NewPage of

         1  :  Begin
                 Set_Buttons(d2ListBtnPanel);

               end;


       end; {Case..}

       With VisiList do
       Begin
         LabHedPanel.Color:=IdPanel(0,BOn).Color;

         SetHedPanel(ListOfSet);
       end;


       RefreshList(BOn,BOn);


     end {With}


   Except

     MULCtrlO[NewPage].Free;
     MULCtrlO[NewPage]:=Nil;
   end;

   MDI_UpdateParentStat;


end;


Procedure TReconList.ChangePage(NewPage  :  Integer);


Begin

  If (Current_Page<>NewPage) then
  With PageControl1 do
  Begin
    ActivePage:=Pages[NewPage];

    PageControl1Change(PageControl1);
  end; {With..}
end; {Proc..}


procedure TReconList.PageControl1Changing(Sender: TObject;
  var AllowChange: Boolean);
begin
  AllowChange:=Not StopPageChange;

  If (AllowChange) then
  Begin
    Release_PageHandle(Sender);
  end;
end;

procedure TReconList.PageControl1Change(Sender: TObject);
Var
  NewIndex  :  Integer;


begin
  If (Sender is TPageControl) then
    With Sender as TPageControl do
    Begin
      NewIndex:=pcLivePage(Sender);

      TotalPanel.Parent:=Pages[NewIndex];
      
      PrimeButtons;

      Case NewIndex of

        1    :  Begin
                  If (MULCtrlO[NewIndex]=nil) then
                    Page1Create(Sender,NewIndex)
                  else
                    With MULCtrlO[0] do
                    Begin
                      If (LastGroup<>LNHCtrl.NHNomCode) then
                        RefreshList(BOn,BOff);
                    end;

                  If (MULCtrlO[NewIndex]<>nil) then
                    With MULCtrlO[NewIndex] do
                      LastGroup:=LNHCtrl.NHNomCode;
                end;


      end; {Case..}


      If (Assigned(MULCtrlO[NewIndex])) then
        MULCtrlO[NewIndex].SetListFocus;

      MDI_UpdateParentStat;

    end; {With..}

end;


procedure TReconList.FormCreate(Sender: TObject);

Var
  n  :  Integer;

begin
  fFrmClosing:=BOff;
  fDoingClose:=BOff;
  ExLocal.Create;

  LastCoord:=BOff;

  JustCreated:=BOn;
  NeedCUpdate:=BOff;

  StopPageChange:=BOff;

  Blank(FNCMode,Sizeof(FNCMode));

  PayInFormPtr:=nil;
  DispTrans:=nil;

  InitSize.Y:=340;
  InitSize.X:=769; //PR: 20/03/2009 Changed default size for so Reconciliation Date is shown.

  Self.ClientHeight:=InitSize.Y;
  Self.ClientWidth:=InitSize.X;

  {Height:=381;
  Width:=419;}

  MinHeight:=339;
  MinWidth:=528;

  PageControl1.ActivePage:=ItemPage;

  // CJS: 14/12/2010 - Amendments for new Window Settings system
  //PR: 27/05/2011 Change to use ClassName rather than Name as identifier - if there are
  //2 instances of the form in existence at the same time, Delphi will change the name of one to Name + '_1' (ABSEXCH-11426)
  FSettings := GetWindowSettings(Self.ClassName);
  LoadWindowSettings;

  For n:=0 to Pred(ComponentCount) do
    If (Components[n] is TScrollBox) then
    With TScrollBox(Components[n]) do
    Begin
      VertScrollBar.Position:=0;
      HorzScrollBar.Position:=0;
    end;

  VertScrollBar.Position:=0;
  HorzScrollBar.Position:=0;


  FormDesign;

  FormBuildList(BOff);
end;


procedure TReconList.FormActivate(Sender: TObject);
begin
  If (Assigned(MULCtrlO[Current_Page]))  then
    MULCtrlO[Current_Page].SetListFocus;

end;

procedure TReconList.FormDestroy(Sender: TObject);

Var
  n  :  Byte;
begin
  ExLocal.Destroy;

  If (InvBtnList<>nil) then
    InvBtnList.Free;


  {If (MULCtrlO<>nil) then
    MULCtrlO.Free;}


end;


Function TReconList.CheckListFinished  :  Boolean;

Var
  n       :  Byte;
  mbRet   :  Word;
Begin
  Result:=BOn;

  For n:=Low(MULCtrlO) to High(MULCtrlO) do
  Begin
    If (Assigned(MULCtrlO[n])) then
      Result:=Not MULCtrlO[n].ListStillBusy;

    If (Not Result) then
    Begin
      Set_BackThreadMVisible(BOn);

      mbRet:=MessageDlg('One of the lists is still busy.'+#13+#13+
                        'Do you wish to interrupt the list so that you can exit?',mtConfirmation,[mbYes,mbNo],0);

      If (mBRet=mrYes) then
      Begin
        MULCtrlO[n].IRQSearch:=BOn;

        ShowMessage('Please wait a few seconds, then try closing again.');
      end;

      Set_BackThreadMVisible(BOff);

      Break;
    end;
  end;
end;


procedure TReconList.FormCloseQuery(Sender: TObject;
                              var CanClose: Boolean);
Var
  n  : Integer;

begin
  If (Not fFrmClosing) then
  Begin
    fFrmClosing:=BOn;

    Try
      GenCanClose(Self,Sender,CanClose,BOn);

      If (CanClose) then
        CanClose:=CheckListFinished;

      If (CanClose) then
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
          // CJS: 15/12/2010 - Amendments for new Window Settings system
          // Store_FormCoord(Not SetDefault);
          SaveWindowSettings;

        Send_UpdateList(42);
      end;
    Finally
      fFrmClosing:=BOff;
    end;
  end
  else
    CanClose:=BOff;
end;

procedure TReconList.FormClose(Sender: TObject; var Action: TCloseAction);
Var
  n  :  Byte;


begin
    If (Not fDoingClose) then
  Begin
    fDoingClose:=BOn;

    Action:=caFree;

    For n:=Low(MULCtrlO) to High(MULCtrlO) do  {* Seems to crash here if form open and you close app... *}
      If (MULCtrlO[n]<>nil) then
      Begin
        MULCtrlO[n].Destroy;
        MULCtrlO[n]:=nil;
      end;

  end;
end;

procedure TReconList.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  GlobFormKeyDown(Sender,Key,Shift,ActiveControl,Handle);
end;

procedure TReconList.FormKeyPress(Sender: TObject; var Key: Char);
begin
  GlobFormKeyPress(Sender,Key,ActiveControl,Handle);
end;

procedure TReconList.FormResize(Sender: TObject);
var
  n: Byte;
  h: Integer;
begin
  // CJS: 16/12/2010 - Amended for new Window Settings system
  if (GotCoord) and (Not fDoingClose) then
  begin
    LockWindowUpdate(self.Handle);
    try
      MULCtrlO[Current_Page].LinkOtherDisp := BOff;

      // Reset the scrollbars because we are resetting everything to top-left
      self.HorzScrollBar.Position:=0;
      self.VertScrollBar.Position:=0;

      // Resize and reposition the Page Control to fill the client area except
      // for a 2-pixel border on all sides.
      PageControl1.Top    := 2;
      PageControl1.Left   := 2;
      PageControl1.Width  := ClientWidth - 4;
      PageControl1.Height := ClientHeight - 4;

      // The button panel remains at a fixed width, so use the width to calculate
      // the correct width for the list panel.
      D1SBox.Top    := 4;
      D1SBox.Left   := 4;
      D1SBox.Width  := ItemPage.Width - (D1ListBtnPanel.Width + D1BtnPanel.Width + 8);
      D1SBox.Height := ItemPage.Height - (TotalPanel.Height + 4);  //PR: 07/11/2011 v6.9 Changed from 8 to 4 as it was resizing when no change was needed.

      // The list box on the Grouped tab page should have the same position and
      // size.
      D2SBox.Top    := 2;
      D2SBox.Left   := 2;
      D2SBox.Width  := D1SBox.Width;
      D2SBox.Height := D1SBox.Height;

      // Put the list box scroll bar panel on the right of the list panel.
      D1ListBtnPanel.Left   := D1SBox.Left + D1SBox.Width;
      D1ListBtnPanel.Height := D1SBox.Height - TotalPanel.Height - D1HedPanel.Height;
      D2ListBtnPanel.Left   := D2SBox.Left + D2SBox.Width;
      D2ListBtnPanel.Height := D2SBox.Height - TotalPanel.Height - D2HedPanel.Height;

      // Put the button panel on the right of the list box scroll bar panel.
      D1BtnPanel.Left   := D1ListBtnPanel.Left + D1ListBtnPanel.Width + 8;
      D1BtnPanel.Height := ItemPage.Height;

//      h := D1SBox.Height - D1HedPanel.Height;

      h := D1SBox.Height - 46;  //PR: 07/11/2011 v6.9
      for n:=0 to 1 do
      if (MULCtrlO[n]<>nil) then
      begin
        with MULCtrlO[n].VisiList do
        begin
          VisiRec:=List[0];
          with (VisiRec^.PanelObj as TSBSPanel) do
            Height := h;
        end;
        with MULCtrlO[n] do
        begin
          ReFresh_Buttons;
          RefreshAllCols;
        end;
      end;{Loop..}
      MULCtrlO[Current_Page].LinkOtherDisp := BOn;
      NeedCUpdate := ((StartSize.X <> Width) or (StartSize.Y <> Height));
    finally
      LockWindowUpdate(0);
    end;
  end; {If time to update}
end;


procedure TReconList.Clsd1BtnClick(Sender: TObject);
begin
  Close;
end;

procedure TReconList.D1ORefPanelMouseUp(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
Var
  BarPos :  Integer;
  PanRSized
         :  Boolean;



begin

  If (Sender is TSBSPanel) then
  With (Sender as TSBSPanel) do
  Begin

    PanRSized:=ReSized;

    BarPos:=Current_BarPos(Current_Page);

    If (PanRsized) then
      MULCtrlO[Current_Page].ResizeAllCols(MULCtrlO[Current_Page].VisiList.FindxHandle(Sender),BarPos);

    MULCtrlO[Current_Page].FinishColMove(BarPos+(ListOfset*Ord(PanRSized)),PanRsized);

    NeedCUpdate:=(MULCtrlO[Current_Page].VisiList.MovingLab or PanRSized);
  end;

end;

procedure TReconList.D1ORefLabMouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
Var
  ListPoint  :  TPoint;


begin
  If (Sender is TSBSPanel) then
  With (Sender as TSBSPanel) do
  Begin

    If (Not ReadytoDrag) and (Button=MBLeft) then
    Begin
      If (MULCtrlO[Current_Page]<>nil) then
        MULCtrlO[Current_Page].VisiList.PrimeMove(Sender);

      NeedCUpdate:=BOn;
    end
    else
      If (Button=mbRight) then
      Begin
        ListPoint:=ClientToScreen(Point(X,Y));

        ShowRightMeny(ListPoint.X,ListPoint.Y,0);
      end;

  end;
end;

procedure TReconList.D1ORefLabMouseMove(Sender: TObject;
  Shift: TShiftState; X, Y: Integer);
begin
  If (Sender is TSBSPanel) then
  With (Sender as TSBSPanel) do
  Begin

    If (MULCtrlO[Current_Page]<>nil) then
    Begin
      MULCtrlO[Current_Page].VisiList.MoveLabel(X,Y);
      NeedCUpdate:=MULCtrlO[Current_Page].VisiList.MovingLab;
    end;
  end;
end;


procedure TReconList.SetFormProperties;

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

    With MULCtrlO[Current_Page].VisiList do
    Begin
      VisiRec:=List[0];

      TmpPanel[1].Font:=(VisiRec^.PanelObj as TSBSPanel).Font;
      TmpPanel[1].Color:=(VisiRec^.PanelObj as TSBSPanel).Color;

      TmpPanel[2].Font:=(VisiRec^.LabelObj as TSBSPanel).Font;
      TmpPanel[2].Color:=(VisiRec^.LabelObj as TSBSPanel).Color;


      TmpPanel[3].Color:=MULCtrlO[Current_Page].ColAppear^[0].HBKColor;
    end;

    TmpPanel[3].Font.Assign(TmpPanel[1].Font);

    TmpPanel[3].Font.Color:=MULCtrlO[Current_Page].ColAppear^[0].HTextColor;


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
                1,2  :  MULCtrlO[Current_Page].ReColorCol(Font,Color,(n=2));

                3    :  MULCtrlO[Current_Page].ReColorBar(Font,Color);
              end; {Case..}

          MULCtrlO[Current_Page].VisiList.LabHedPanel.Color:=TmpPanel[2].Color;
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

procedure TReconList.ShowRightMeny(X,Y,Mode  :  Integer);

Begin
  With PopUpMenu1 do
  Begin

    PopUp(X,Y);
  end;


end;



procedure TReconList.PopupMenu1Popup(Sender: TObject);
Var
  n  :  Integer;

begin
  StoreCoordFlg.Checked:=StoreCoord;


  With InvBtnList do
  Begin
    ResetMenuStat(PopUpMenu1,BOn,BOn);

    With PopUpMenu1 do
    For n:=0 to Pred(Count) do
      SetMenuFBtn(Items[n],n);

  end; {With..}

  PopUpMenu4PopUp(Sender);

end;

procedure TReconList.PopupMenu4Popup(Sender: TObject);
begin
  Copy2.Visible:=BOn;
end;



procedure TReconList.PropFlgClick(Sender: TObject);
begin
  // CJS: 14/12/2010 - Amendments for Window Settings system
  // SetFormProperties;
  EditWindowSettings;
end;

procedure TReconList.StoreCoordFlgClick(Sender: TObject);
begin
  StoreCoord:=Not StoreCoord;
  NeedCUpdate:=BOn;
end;

procedure TReconList.Out_ReconBal;

Var
  NomBal,
  Purch,
  Sales,
  Cleared  :  Double;

  L        :  Integer;


Begin

  If (TotalPanel.Visible) then
    With ExLocal,LNom,DDCtrl do
    Begin
      NomBal:=Profit_To_Date(NomType,CalcCCKeyHistP(NomCode,NHCCMode,NHCDCode),NHCr,NHYr,NHPr,Purch,Sales,Cleared,BOn);

      TotBalance.Value:=Currency_Txlate(NomBal,NHCr,NHTxCr);

      TotCleared.Value:=Currency_Txlate(Cleared,NHCr,NHTxCr);
    end; {With..}
end; {Proc..}



procedure TReconList.ClrD1BtnClick(Sender: TObject);

Var
  LOk,
  GLocked  :  Boolean;
  KeyS    :  Str255;


begin
  With MULCtrlO[Current_Page],ExLocal do
    If (ValidLine) then
    Begin
      KeyS:=FullNomKey(LNom.NomCode);

      LOk:=LGetMultiRec(B_GetEq,B_MultLock,KeyS,NomCodeK,NomF,BOff,GLocked);

      If (LOk) and (GLocked) then
      Begin
        LGetRecAddr(NomF);

        LNHCtrl.NBMode:=TWinControl(Sender).Tag;

        RefreshLine(MUListBoxes[0].Row,BOff);

        Set_PayInStatus;

        Set_Row(MUListBoxes[0].Row);

        Out_ReconBal;

        Status:=UnLockMLock(NomF,LastRecAddr[NomF]);

        {PageUpDn(0,BOn);}
      end;

    end;
end;


procedure TReconList.UnCD1BtnClick(Sender: TObject);

Var
  ListPoint  :  TPoint;

begin
  With MULCtrlO[Current_Page] do
  Begin
    If ((ValidLine) or (Sender=Find1)) and (Not InListFind) then
    Begin

      With TWinControl(Sender) do
      Begin
        ListPoint.X:=1;
        ListPoint.Y:=1;

        ListPoint:=ClientToScreen(ListPoint);
       end;

       If (Sender = UnCD1Btn) or (Sender = UnClear1) then
         PopUpMenu2.PopUp(ListPoint.X,ListPoint.Y)
       else
         If (Sender = FindD1Btn) or (Sender = Find1) then
           PopUpMenu3.PopUp(ListPoint.X,ListPoint.Y)
         else
           If (Sender = CopyD1Btn) or (Sender = Copy1) then
             PopUpMenu4.PopUp(ListPoint.X,ListPoint.Y)
    end;
  end;{with..}
end;



procedure TReconList.Amount1Click(Sender: TObject);
begin
  With MULCtrlO[Current_Page] do
  Begin
    RefreshLine(MUListBoxes[0].Row,BOff);

    Find_ReconItem(TWinControl(Sender).Tag);
  end;
end;



procedure TReconList.Copy2Click(Sender: TObject);
var
  TmpKPath : Longint;
  TmpStat, TmpRecAddr : longint;
  KeyS : Str255;
begin
  With MULCtrlO[Current_Page] do
  begin
    RefreshLine(MUListBoxes[0].Row,BOff);

    //PR: 24/06/2016 v2016 R1 ABSEXCH-17320 Need to get inv record before copying/reversing
    GetSelRec(False);
    Link2Inv;

    ContraCopy_Doc(Id.FolioRef,TWinControl(Sender).Tag,'');
  end;
end;



procedure TReconList.RunCheck(Sender: TObject);

Begin
  With TWinControl(Sender) do
  Begin
    {$IFDEF POST}
      AddCheckNom2Thread(Self,ExLocal.LNom,ExLocal.LJobRec^,Tag);
    {$ENDIF}

  end;
end;


procedure TReconList.Check2Click(Sender: TObject);
begin
  RunCheck(Sender);
end;


procedure TReconList.ChkD1BtnClick(Sender: TObject);

Var
  mbRet      :  Word;
  ListPoint  :  TPoint;


begin
  //AP: 28/09/2017 ABSEXCH-16645 Built-in Cumulative cleared balance recalc
  With TWinControl(Sender) do
  Begin
    GetCursorPos(ListPoint);

    With ListPoint do
    Begin
      X:=X-50;
      Y:=Y-15;
    end;
  end;
  
  If (SBSIn) then
  Begin
    PopUpMenu5.PopUp(ListPoint.X,ListPoint.Y);
  end
  else
  Begin
    PopUpMenu6.PopUp(ListPoint.X,ListPoint.Y);
  end;

end;

{ ======= Link to Trans display ======== }

procedure TReconList.Display_Trans(Mode  :  Byte);
var
  KeyS : Str255;
  Res : Integer;
  TempInv : InvRec;

Begin

  If (DispTrans=nil) then
    DispTrans:=TFInvDisplay.Create(Self);

    try

      ExLocal.AssignFromGlobal(IdetailF);

      With ExLocal,DispTrans do
      Begin
        LastDocHed:=LId.IdDocHed;
        DocRunRef:=LId.DocPRef;
        DocHistRunNo:=LId.PostedRun;

        {$IFDEF SOP}
          DocHistCommPurch:=(DocHistRunNo=CommitOrdRunNo) and (LId.NomCode=Syss.NomCtrlCodes[PurchComm]);

        {$ENDIF}

        If ((LastFolio<>LId.FolioRef) or (Mode<>100)) and (InHBeen) then
        begin
        //PR: 11/02/2016 v2016 R1 ABSEXCH-17038 Add check for security hook point 155 (View) & 161 (Notes)
        {$IFDEF CU}
        //PR: 19/02/2016 v2016 R1 ABSEXCH-17320 Don't necessarily have invoice at this point, so may need to find it
        if Inv.FolioNum <> LId.FolioRef then
        begin
          KeyS := FullNomKey(LId.FolioRef);
          Res := Find_Rec(B_GetEq, F[InvF], InvF, RecPtr[InvF]^, InvFolioK, KeyS);
        end;
        {$B-} //2 is from view button, 99 is from double click
        if ((Mode in [2, 99]) and ValidSecurityHook(2000, 155, ExLocal)) or
           ((Mode = 7) and ValidSecurityHook(2000, 161, ExLocal)) then
        {$B+}
        {$ENDIF Customisation}
          Display_Trans(Mode,LId.FolioRef,BOn,(Mode<>100));
        end;
      end; {with..}

    except

      DispTrans.Free;

    end;

end;


procedure TReconList.Display_PayIn(ChangeFocus   :  Boolean);


Var
  NomNHCtrl  :  TNHCtrlRec;

  FoundLong  :  Longint;

  PayInForm  :  TPayInWin;

  WasNew     :  Boolean;

Begin

  WasNew:=BOff;

  With EXLocal,NomNHCtrl do
  Begin
    AssignFromGlobal(IdetailF);

    FillChar(NomNHCtrl,Sizeof(NomNHCtrl),0);

    NHMode:=0;

    NHCr:=DDCtrl.NHCr;

    With LId do
      MainK:=Full_PostPayInKey(PayInCode,NomCode,Currency,Extract_PayRef2(StockCode));

    NHKeyLen:=Length(MainK);

    Set_PIFormMode(NomNHCtrl);

  end;

  If (PayInFormPtr=nil) then
  Begin
    WasNew:=BOn;

    PayInForm:=TPayInWin.Create(Self);

    PayInFormPtr:=PayInForm;

  end
  else
    PayInForm:=PayInFormPtr;

  Try

   With PayInForm do
   Begin

     WindowState:=wsNormal;

     If (ChangeFocus) then
       Show;

     ShowLink(BOn);


   end; {With..}

   If (WasNew) then
   Begin
   end;

  except

   PayInFormPtr:=nil;

   PayInForm.Free;
   PayInForm:=nil;

  end; {try..}


end;


procedure TReconList.ViewD1BtnClick(Sender: TObject);

Var
  Modus  :  Byte;

begin
  With MULCtrlO[Current_Page] do
    If (ValidLine) then
    Begin
      RefreshLine(MUListBoxes[0].Row,BOff);

      InHBeen:=BOn;

      If (Sender=NoteD1Btn) or (Sender=Notes1) then
        Modus:=7
      else
        Modus:=2;

      Display_Trans(Modus);

    end;
end;


procedure TReconList.FIClr1Click(Sender: TObject);

Var
  Idx  :  Integer;

begin
  Idx:=Current_Page;

  FNCMode[Idx]:=Not FNCMode[Idx];

  If (FNCMode[Idx]) then
  With DDCtrl do
  Begin
    NCCtrl[Idx]:=DDCtrl;

    DDCtrl.NHNeedGExt:=BOn;

    NHDDRecon:=1+Idx;
    NHMode:=15;

    FIClr1.Caption:='&Show ALL Entries';

  end
  else
  Begin
    DDCtrl:=NCCtrl[Idx];

    FIClr1.Caption:='&Filter Not Cleared';
  end;

  DeleteSubMenu(Find1);
  CreateSubMenu(PopUpMenu3,Find1);
  RefreshList(BOn,BOn);
  SetCaption;
end;



// -----------------------------------------------------------------------------
// CJS: 14/12/2010 - Amendments for new Window Settings system

procedure TReconList.EditWindowSettings;
begin
  if Assigned(FSettings) and Assigned(MULCtrlO[Current_Page]) then
    if FSettings.Edit(MULCtrlO[Current_Page], MULCtrlO[Current_Page]) = mrOK then
      NeedCUpdate := True;
end;

// -----------------------------------------------------------------------------

procedure TReconList.LoadListSettings(ListNo: Integer);
begin
  if Assigned(FSettings) and Assigned(MULCtrlO[ListNo]) and not FSettings.UseDefaults then
    FSettings.SettingsToParent(MULCtrlO[ListNo]);
end;

// -----------------------------------------------------------------------------

procedure TReconList.LoadWindowSettings;
begin
  if Assigned(FSettings) then
  begin
    FSettings.LoadSettings;
    if not FSettings.UseDefaults then
      FSettings.SettingsToWindow(Self);
  end;
end;

// -----------------------------------------------------------------------------

procedure TReconList.SaveListSettings(ListNo: Integer);
begin
  if Assigned(MULCtrlO[ListNo]) then
    FSettings.ParentToSettings(MULCtrlO[ListNo], MULCtrlO[ListNo]);
end;

// -----------------------------------------------------------------------------

procedure TReconList.SaveWindowSettings;
var
  i: Integer;
begin
  if Assigned(FSettings) and NeedCUpdate then
  begin
    for i := Low(MULCtrlO) to High(MULCtrlO) do
      SaveListSettings(i);
    FSettings.WindowToSettings(self);
    FSettings.SaveSettings(StoreCoord);
  end;
  FSettings := nil;
end;

// -----------------------------------------------------------------------------

procedure TReconList.Link2Inv;
var
  TmpKPath : Longint;
  TmpStat, TmpRecAddr : longint;
  KeyS : Str255;
begin
  If (ExLocal.LInv.FolioNum<>Id.FolioRef) then
  Begin
    TmpKPath:=GetPosKey;

    TmpStat:=Presrv_BTPos(InvF,TmpKPath,F[InvF],TmpRecAddr,BOff,BOff);

    ResetRec(InvF);

    KeyS:=FullNomKey(Id.FolioRef);

    If (Id.FolioRef<>0) then
      Status:=Find_Rec(B_GetEq,F[InvF],InvF,RecPtr[InvF]^,InvFolioK,KeyS);

    TmpStat:=Presrv_BTPos(InvF,TmpKPath,F[InvF],TmpRecAddr,BOn,BOff);
  end;
end;

procedure TReconList.RecalculateBalance(Sender: TObject);
begin
  if Assigned(Sender) and (Sender is TMenuItem) then
  begin
      case TMenuItem(Sender).Tag of
        1:  AddCheckNom2Thread(Self,ExLocal.LNom,ExLocal.LJobRec^,0);
        2:  AddCheckNom2Thread(Self,ExLocal.LNom,ExLocal.LJobRec^,8);
      end;
  end;
end;

//-------------------------------------------------------------------------

// MH 09/03/2018 2018-R2 ABSEXCH-19172: Added metadata for List Export functionality
function TReconList.WindowExportEnableExport: Boolean;
begin
  Result := True;
  WindowExport.AddExportCommand (ecIDCurrentRow, ecdCurrentRow);
  WindowExport.AddExportCommand (ecIDCurrentPage, ecdCurrentPage);
  WindowExport.AddExportCommand (ecIDEntireList, ecdEntireList);
end;

//-------------------------------------------------------------------------

// MH 09/03/2018 2018-R2 ABSEXCH-19172: Added metadata for List Export functionality
procedure TReconList.WindowExportExecuteCommand(const CommandID: Integer; const ProgressHWnd: HWND);
Var
  ListExportIntf : IExportListData;
begin
  // Returns a new instance of an "Export Btrieve List To Excel" object
  ListExportIntf := NewExcelListExport;
  Try
    ListExportIntf.ExportTitle := WindowExportGetExportDescription;

    // Connect to Excel
    If ListExportIntf.StartExport Then
    Begin
      // Get the active Btrieve List to export the data
      MulCtrlO[Current_Page].ExportList (ListExportIntf, CommandID, ProgressHWnd);

      ListExportIntf.FinishExport;
    End; // If ListExportIntf.StartExport(sTitle)
  Finally
    ListExportIntf := NIL;
  End; // Try..Finally
end;

//-------------------------------------------------------------------------

// MH 09/03/2018 2018-R2 ABSEXCH-19172: Added metadata for List Export functionality
function TReconList.WindowExportGetExportDescription: String;
begin
  // GL Code
  Result := IntToStr(ExLocal.LNom.NomCode) + '-';
  Result := 'GL Drill-Down - ' + IntToStr(ExLocal.LNom.NomCode);

  Case Current_Page Of
    0 : Result := Result + ' - Itemised';
    1 : Result := Result + ' - Grouped';
  End; // Case Current_Page
end;

//-------------------------------------------------------------------------

end.





