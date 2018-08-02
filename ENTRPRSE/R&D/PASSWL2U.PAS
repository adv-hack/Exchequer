unit PassWL2U;

{$I DEFOVR.INC}

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ExtCtrls, SBSPanel, ComCtrls, BTSupU1,GlobVar, VarConst,VarRec2U,SBSComp,SBSComp2,
  ExWrap1U, Menus, PassWR2U, Animate, Grids, SBSOutl, Buttons, BorBtns,
  TEditVal, Mask, bkgroup, ImgList, ToolWin, AdvToolBar, AdvGlowButton, EntWindowSettings,
  AdvToolBarStylers;


type
  tPWTreeGrpRec  =  Record
                      tCaption  :  String;
                      IsChild   :  Byte;
                      PWLink    :  String;
                      Exclude   :  Boolean;
                    end;

  //PR 26/01/2009 Increased size of array from 913 to 914 for CC/Dept passwords in 6.01
  // CJS 05/02/2009 Increased size of array, for Sort Views
  tPWTreeGrpAry  =  Array[1..915] of tPWTreeGrpRec;


  TPwordList2 = class(TForm)
    PageControl1: TPageControl;
    ItemPage: TTabSheet;
    D1SBox: TScrollBox;
    D1HedPanel: TSBSPanel;
    UNLab: TSBSPanel;
    UNPanel: TSBSPanel;
    PBtnPanel: TSBSPanel;
    P1BSBox: TScrollBox;
    AddBtn: TButton;
    EditBtn: TButton;
    DelBtn: TButton;
    CopyBtn: TButton;
    Clsd1Btn: TButton;
    PopupMenu1: TPopupMenu;
    Add1: TMenuItem;
    N2: TMenuItem;
    PropFlg: TMenuItem;
    N1: TMenuItem;
    StoreCoordFlg: TMenuItem;
    Edit1: TMenuItem;
    Delete1: TMenuItem;
    Copy1: TMenuItem;
    InterBtn: TButton;
    ResetCBtn: TButton;
    Interactive1: TMenuItem;
    ResetCustom1: TMenuItem;
    AccessPage: TTabSheet;
    PListBtnPanel: TSBSPanel;
    D2SBox: TScrollBox;
    NLOLine: TSBSOutlineB;
    D3SBox: TScrollBox;
    SBSBackGroup1: TSBSBackGroup;
    Label81: Label8;
    SCodeF: Text8Pt;
    Label82: Label8;
    DescF: Text8Pt;
    Label811: Label8;
    DSRIF: Text8Pt;
    DPPIF: Text8Pt;
    PWExDateF: TEditDate;
    PWModeCBF: TSBSComboBox;
    PWEDaysF: TCurrencyEdit;
    Label83: Label8;
    MaxSAF: TCurrencyEdit;
    Label85: Label8;
    Label86: Label8;
    MaxPAF: TCurrencyEdit;
    Label87: Label8;
    CCF: Text8Pt;
    DepF: Text8Pt;
    Label88: Label8;
    LocF: Text8Pt;
    Label89: Label8;
    SBankGLF: Text8Pt;
    Label810: Label8;
    PBankGLF: Text8Pt;
    Label828: Label8;
    DefRPrn: TSBSComboBox;
    Label829: Label8;
    DefFPrn: TSBSComboBox;
    SBSBackGroup2: TSBSBackGroup;
    SBSBackGroup3: TSBSBackGroup;
    CCDRulesCB: TSBSComboBox;
    LOCRulesCB: TSBSComboBox;
    SRCGLLab: Label8;
    PPYGLLab: Label8;
    OkCP1Btn: TButton;
    CanCP1Btn: TButton;
    FindBtn: TButton;
    SetYesBtn: TButton;
    SetNoBtn: TButton;
    btnExpand: TButton;
    btnCollapse: TButton;
    Label813: Label8;
    PWALogF: TCurrencyEdit;
    Label814: Label8;
    SigPage: TTabSheet;
    memEmailSig: TMemo;
    memFaxSig: TMemo;
    Label815: Label8;
    Label816: Label8;
    emailUserLab: Label8;
    FaxUserLab: Label8;
    Label812: Label8;
    FullNameF: Text8Pt;
    SBSBackGroup4: TSBSBackGroup;
    PWEmlF: Text8Pt;
    PrintBtn: TButton;
    Print1: TMenuItem;
    Find1: TMenuItem;
    ExpandLevel1: TMenuItem;
    CollapseLevel1: TMenuItem;
    BN1: TMenuItem;
    DN1: TMenuItem;
    AdvDockPanel1: TAdvDockPanel;
    AdvToolBar1: TAdvToolBar;
    AdvToolBarOfficeStyler1: TAdvToolBarOfficeStyler;
    FullExBtn: TAdvGlowButton;
    FullColBtn: TAdvGlowButton;
    AdvToolBarSeparator1: TAdvToolBarSeparator;
    Label84: Label8;
    Panel1: TPanel;
    Image5: TImage;
    Label826: Label8;
    Label817: Label8;
    Label818: Label8;
    Label819: Label8;
    Label820: Label8;
    SBSBackGroup5: TSBSBackGroup;
    Label821: Label8;
    TBorCh_ShowGLCode: TBorCheck;
    Bevel1: TBevel;
    Label822: Label8;
    TBorCh_ShowStockCode: TBorCheck;
    TBorCh_ShowProductType: TBorCheck;
    procedure FormCreate(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormDestroy(Sender: TObject);
    procedure FormResize(Sender: TObject);
    procedure PropFlgClick(Sender: TObject);
    procedure StoreCoordFlgClick(Sender: TObject);
    procedure PopupMenu1Popup(Sender: TObject);
    procedure Clsd1BtnClick(Sender: TObject);
    procedure UNPanelClick(Sender: TObject);
    procedure PYNPanelClick(Sender: TObject);
    procedure PYNLabMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure PYNLabMouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure PYNLabMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure UNLabMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure UNLabMouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure UNLabMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure AddBtnClick(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure InterBtnClick(Sender: TObject);
    procedure NLOLineExpand(Sender: TObject; Index: Integer);
    procedure FullExBtnClick(Sender: TObject);
    procedure FullColBtnClick(Sender: TObject);
    procedure NLOLineNeedValue(Sender: TObject);
    procedure BN2Click(Sender: TObject);
    procedure SN1Click(Sender: TObject);
    procedure PageControl1Change(Sender: TObject);
    procedure CanCP1BtnClick(Sender: TObject);
    procedure DescFEnter(Sender: TObject);
    procedure DescFExit(Sender: TObject);
    procedure SCodeFExit(Sender: TObject);
    procedure PageControl1Changing(Sender: TObject;
      var AllowChange: Boolean);
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure FormKeyPress(Sender: TObject; var Key: Char);
    procedure PWModeCBFChange(Sender: TObject);
    procedure DSRIFExit(Sender: TObject);
    procedure CCFExit(Sender: TObject);
    procedure LocFExit(Sender: TObject);
    procedure SBankGLFExit(Sender: TObject);
    procedure Collapse1Click(Sender: TObject);
    procedure NLOLineUpdateNode(Sender: TObject; var Node: TSBSOutLNode;
      Row: Integer);
    procedure PWEDaysFExit(Sender: TObject);
    procedure NLOLineNodeChkHotSpot(Sender: TObject;
      var Node: TSBSOutLNode; Row: Integer);
    procedure PrintBtnClick(Sender: TObject);
  private
    { Private declarations }
    HideDAdd,
    CopyMode,
    SysMMode,
    InterMode,
    RecMode,
    BeenIn,
    JustCreated,
    StoreCoord,
    LastCoord,
    SetDefault,
    GotCoord,
    fNeedCUpdate,
    OverW,
    IdStored,
    fDoingClose,
    TreeExpanded,
    fLoadCompanySig,
    CanDelete    :  Boolean;

    Sel_User,
    Current_User :  Str10;

    PagePoint    :  Array[0..4] of TPoint;

    StartSize,
    InitSize     :  TPoint;

    SKeypath     :  Integer;

    EntryRec2    :  EntryRecType;

    EntryDefaults2
                 :  tPassDefType;


    PWTreeGrpAry :  tPWTreeGrpAry;

    LastFind     :  String;

    InvBtnList   :  TVisiBtns;

    FFiles       : Array [1..2] Of String;
    FStrings     : TStrings;

    PrintJob     : TStringList;

    Procedure LoadText (Const Idx : Byte; FName1, FName2 : ShortString; TheMemo : TMemo);

    procedure LoadUserSig(Mode  :  Byte);

    procedure StoreSigs(EditMode  :  Boolean);

    procedure Find_FormCoord;

    procedure SetFieldProperties(Field  :  TSBSPanel) ;

    procedure Store_FormCoord(UpMode  :  Boolean);

    procedure FormSetOfSet;

    Procedure ChangePage(NewPage  :  Integer);

    Function Current_Page  :  Integer;

    Procedure PrimeButtons;

    Procedure BuildDesign;

    Procedure WMCustGetRec(Var Message  :  TMessage); Message WM_CustGetRec;

    Procedure WMFormClose(Var Message  :  TMessage); Message WM_FormCloseMsg;

    Procedure WMGetMinMaxInfo(Var Message  :  TWMGetMinMaxInfo); Message WM_GetMinMaxInfo;

    

    procedure Display_Rec2(Mode  :  Byte);

    Procedure Send_UpdateList(Mode   :  Integer);

    Procedure StoreEntryRec(PgNo    :  Byte;
                            PLogin  :  Str10;
                            StoreRec:  Boolean);

    Procedure RenameEntryRec(PgNo    :  Byte;
                             PLogin,
                             NewLogin
                                     :  Str10);

    procedure SetLevelEntry(Idx,SetTMode  :  Integer);

    procedure OpenThisNode(Index,SetTMode :  Integer);

    procedure SetEntry(Idx,SetTMode  :  Integer);



    procedure ShowRightMeny(X,Y,Mode  :  Integer);

    Procedure  SetNeedCUpdate(B  :  Boolean);

    Property NeedCUpDate :  Boolean Read fNeedCUpDate Write SetNeedCUpdate;

    procedure Prime_TreeGroups;

    Function GetPWText(PWCode  :  Str255;
                   Var PNo     :  SmallInt )  :  String;

    Function AddTreeNode(ParentIdx  :  LongInt;
                         LineText   :  String;
                         GrpAry,
                         Level      :  LongInt;
                         PWNo       :  SmallInt;
                         Mode       :  Byte)  :  Integer;

    procedure Build_TreeGroups(Var GrpAry     :  LongInt;
                                   ParentIdx  :  LongInt;
                                   Level      :  LongInt);

    procedure GetMoreLinks(Index  :  Integer);

    procedure SetThisNode(Index,SetTMode,Level   :  Integer);

    Procedure FindPassword;

    procedure SetCompRORules;
    
    procedure SetCompRO(TC     :  TComponent;
                  Const TG     :  Integer;
                  Const EnabFlg:  Boolean);

    procedure SetPWStore(EnabFlag,
                         ButnFlg  :  Boolean);

    Procedure SetFieldFocus;

    Procedure OutUP;

    procedure Form2Id;

    Procedure Show_UserProps;

    procedure ProcessId(Fnum,
                        Keypath     :  Integer;
                        Edit        :  Boolean);

    procedure EditLine(Edit       :  Boolean;
                       MMode      :  Byte);

    Function CheckNeedStore  :  Boolean;

    Function ConfirmQuit  :  Boolean;

    Function CheckCompleted(Edit,MainChk  :  Boolean)  : Boolean;

    Procedure Delete_PosRecs(DelCode  :  Str20);

    Procedure ReName_PosRecs(OldCode,
                             NewCode   :  Str20);

    Procedure Copy_PosRecs(OldCode,
                           NewCode   :  Str20);


    Function Link_PWDefaults(PLogin  :  Str10;
                         Var NewRec  :  SmallInt)  :  tPassDefType;

    Procedure Store_PWDefaults(PLogin,
                               NewCode  :  Str10;
                               RenMode  :  Boolean);

    Procedure Delete_PWDefaults(PLogin  :  Str10);

    procedure StoreId(Fnum,
                      Keypath  :  Integer);


    procedure DeleteBOMLine(Fnum,
                            KeyPath  :  Integer);

    procedure DeleteCustomPos;

    procedure PrintSettings;

    procedure SetHelpContextIDsForPage; // NF: 16/05/06

  public
    { Public declarations }

    ExLocal      :  TdExLocal;

    ListOfSet    :  Integer;

    MULCtrlO     :  TPWMList;


    procedure FormDesign;

    procedure RefreshList(ShowLines,
                          IgMsg      :  Boolean);

    procedure FormBuildList(ShowLines  :  Boolean);

    procedure FormBuildList2(ShowLines  :  Boolean);

    procedure RefreshList2(ShowLines,
                           IgMsg      :  Boolean);

    procedure SetFormProperties;

  end;



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

  {$IFDEF FRM}
    PrintFrm,

    RpDevice,
  {$ENDIF}

  {$IFDEF RP}
    ReportHU,

  {$ENDIF}

  HelpSupU,
  CryptO,
  SysU1,
  SysU2,
  InpPWU,
  {$IFDEF EXSQL}
  SQLUtils,
  SQLFuncs,
  {$ENDIF}
  {IntMU,
  MiscU,
  PayF2U,
  Warn1U,}
  SalTxl1U,
  UA_Const;

{$R *.DFM}




Procedure  TPwordList2.SetNeedCUpdate(B  :  Boolean);

Begin
  If (Not fNeedCUpdate) then
    fNeedCUpdate:=B;
end;

procedure TPwordList2.Find_FormCoord;


Var
  ThisForm:  TForm;

  VisibleRect
          :  TRect;

  GlobComp:  TGlobCompRec;


Begin

  New(GlobComp,Create(BOn));

  ThisForm:=Self;

  With GlobComp^ do
  Begin

    GetValues:=BOn;

    PrimeKey:='P';

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

    GetbtControlCsm(D1SBox);
    GetbtControlCsm(D2SBox);

    GetbtControlCsm(PListBtnPanel);

    GetbtControlCsm(PBtnPanel);

    GetbtControlCsm(NLOLine);


    MULCtrlO.Find_ListCoord(GlobComp);

  end; {With GlobComp..}

  SetFieldProperties(UNPanel);

  Dispose(GlobComp,Destroy);

  {NeedCUpdate}
  StartSize.X:=Width; StartSize.Y:=Height;


end;


procedure TPwordList2.SetFieldProperties(Field  :  TSBSPanel) ;

Var
  n  : Integer;


Begin
  With D3SBox do
  For n:=0 to Pred(ControlCount) do
  Begin
    If (Controls[n] is TMaskEdit) or (Controls[n] is TComboBox)
     or (Controls[n] is TCurrencyEdit) then
    With TGlobControl(Controls[n]) do
      If (Tag>0) then
      Begin
        Font.Assign(Field.Font);
        Color:=Field.Color;
      end;


  end; {Loop..}


end;



procedure TPwordList2.Store_FormCoord(UpMode  :  Boolean);


Var
  GlobComp:  TGlobCompRec;


Begin

  New(GlobComp,Create(BOff));

  With GlobComp^ do
  Begin
    GetValues:=UpMode;

    PrimeKey:='P';

    ColOrd:=Ord(StoreCoord);

    HLite:=Ord(LastCoord);

    SaveCoord:=StoreCoord;

    If (Not LastCoord) then {* Attempt to store last coord *}
      HLite:=ColOrd;

    StorebtControlCsm(Self);

    StorebtControlCsm(PageControl1);

    StorebtControlCsm(PBtnPanel);

    StorebtControlCsm(D1SBox);
    StorebtControlCsm(D2SBox);

    StorebtControlCsm(NLOLine);


    StorebtControlCsm(PListBtnPanel);

    MULCtrlO.Store_ListCoord(GlobComp);

  end; {With GlobComp..}

  Dispose(GlobComp,Destroy);
end;



procedure TPwordList2.FormSetOfSet;

Begin
  PagePoint[0].X:=ClientWidth-(PageControl1.Width);
  PagePoint[0].Y:=ClientHeight-(PageControl1.Height);

  PagePoint[2].X:=PageControl1.Width-(PBtnPanel.Left);
  PagePoint[2].Y:=PageControl1.Height-(PBtnPanel.Height);

  PagePoint[1].X:=PageControl1.Width-(D1SBox.Width);
  PagePoint[1].Y:=PageControl1.Height-(D1SBox.Height);

  PagePoint[3].X:=PBtnPanel.Height-(P1BSBox.Height);
  PagePoint[3].Y:=D1SBox.ClientHeight-(UNPanel.Height);

  PagePoint[4].X:=PageControl1.Width-(D2SBox.Width);
  PagePoint[4].Y:=PBtnPanel.Height-(PListBtnPanel.Height);

  GotCoord:=BOn;

end;

Procedure TPwordList2.BuildDesign;

Begin
  AccessPage.Tabvisible:=Not HideDAdd;
  SigPage.Tabvisible:=(Not HideDAdd) and (eCommsModule);

end;

Function TPwordList2.Current_Page  :  Integer;


Begin


  Result:=pcLivePage(PageControl1);

end;



procedure TPwordList2.PrimeButtons;

Var
  PageNo  :  Integer;



Begin
  PageNo:=Current_Page;

  If (InvBtnList=nil) then
  Begin
    InvBtnList:=TVisiBtns.Create;

    try

      With InvBtnList do
      Begin

      {0} AddVisiRec(AddBtn,BOff);
      {1} AddVisiRec(EditBtn,BOff);
      {2} AddVisiRec(DelBtn,BOff);
      {3} AddVisiRec(CopyBtn,BOff);
      {4} AddVisiRec(InterBtn,BOff);
      {5} AddVisiRec(ResetCBtn,BOff);
      {6} AddVisiRec(FindBtn,BOff);
      {7} AddVisiRec(BtnExpand,BOff);
      {8} AddVisiRec(BtnCollapse,BOff);
      {9} AddVisiRec(SetYesBtn,BOff);
      {10} AddVisiRec(SetNoBtn,BOff);
      {11} AddVisiRec(PrintBtn,BOff);

        end; {With..}

    except

      InvBtnList.Free;
      InvBtnList:=nil;
    end; {Try..}

  end; {If needs creating }

  try

    With InvBtnList do
    Begin
      SetHideBtn(0,(PageNo<>0),BOff);
      SetHideBtn(1,(PageNo=1),BOff);
      SetHideBtn(2,(PageNo<>0),BOff);
      SetHideBtn(3,(PageNo<>0),BOff);
      SetHideBtn(4,(PageNo<>1),BOff);
      SetHideBtn(5,(PageNo<>0),BOff);
      SetHideBtn(6,(PageNo=0),BOff);
      SetHideBtn(7,(PageNo<>1),BOff);
      SetHideBtn(8,(PageNo<>1),BOff);

      SetHideBtn(9,(PageNo<>1),BOff);
      SetHideBtn(10,(PageNo<>1),BOff);
      SetHideBtn(11,BOff,BOn);



      OkCP1Btn.Visible:=(PageNo In [0,2]);
      CanCP1Btn.Visible:=(PageNo In [0,2]);

      Case PageNo of
        0,1
           :  Begin
                FindBtn.Caption:='&Find';
                FindBtn.Hint:='Find Password option|Searches the password tree to find a password';
                EditBtn.Hint:='Edit a user record|Allows the settings for the currently highlighted user to be changed.';

              end;
        2  :  Begin
                FindBtn.Caption:='&Company Sig';
                FindBtn.Hint:='Load Company or User Signature|Toggles between loading the default Company and current user signature.';
                EditBtn.Hint:='Edit the current signature|Allows the signatures for the currently highlighted user to be changed.';
              end;
      end; {case..}

      Find1.Caption:=FindBtn.Caption;

    end;




  except
    InvBtnList.Free;
    InvBtnList:=nil;
  end; {try..}

end;



Procedure TPwordList2.WMCustGetRec(Var Message  :  TMessage);

Var
  TmpStat      :  Integer;
  TmpRecAddr   :  LongInt;
  n            :  Byte;

Begin


  With Message do
  Begin

    {If (Debug) then
      DebugForm.Add('Mesage Flg'+IntToStr(WParam));}

    Case WParam of
      0,169
         :  Begin
              MULCtrlO.GetSelRec(BOff);

              //AddBtnClick(Edit1);

              If (Not ExLocal.InAddEdit) then
                ChangePage(1);

            end;

       1  :  Begin

               Case Current_Page of
                 0  :  Show_UserProps;

                 1  :  If (OverW) then
                       With MULCtrlO do
                       Begin
                         Label84.Caption:='Access settings for user : '+SCodeF.Text;

                         TmpStat:=Presrv_BTPos(ScanFileNum,Keypath,F[ScanFileNum],TmpRecAddr,BOff,BOff);

                         {EntryRec2:=PassWord.PassEntryRec;}

                         For n:=0 to 3 do {* Get any password settings + additional page settings *}
                           SetEntryRecVar(n,PassWord.PassEntryRec.Login,(n>0),BOn,EntryRec2);


                         //PageUpDn(0,BOn);

                         NLOLine.Refresh;

                         TmpStat:=Presrv_BTPos(ScanFileNum,Keypath,F[ScanFileNum],TmpRecAddr,BOn,BOn);

                         If (InterMode) then
                         Begin
                           EntryRec^:=EntryRec2;
                           Send_UpdateList(102);
                         end;

                       end;

                 2  :  LoadUserSig(0);
               end; {Case..}
             end;

       2  :  ShowRightMeny(LParamLo,LParamHi,1);

       25 :  NeedCUpdate:=BOn;

      116
          :  Begin
               With MULCtrlO do
               Begin
                 AddNewRow(MUListBoxes[0].Row,(LParam=1));

                 If (LParam=0) then {* Add second page *}
                 Begin
                   EntryRec2:=EntryRec^;

                   For n:=1 to 3 do
                     StoreEntryRec(n,PassWord.PassEntryRec.Login,BOn);

                   If (Not OverW) then
                   Begin
                     OverW:=BOn;

                     SendMessage(Self.Handle,WM_CustGetRec,1,0);

                   end;
                 end;
               end;
            end;

      117 :  With MULCtrlO do
             Begin
               If (MUListBox1.Row<>0) then
                 PageUpDn(0,BOn)
                else
                  InitPage;

               If (ValidLine) then
                 Show_UserProps;
             end;
      175
         :  With PageControl1 do
              ChangePage(FindNextPage(ActivePage,(LParam=0),BOn).PageIndex);



      250 :  GetMoreLinks(LParam);


    end; {Case..}

  end;
  Inherited;
end;


Procedure TPwordList2.WMFormClose(Var Message  :  TMessage);

Begin


  With Message do
  Begin

    {If (Debug) then
      DebugForm.Add('Mesage Flg'+IntToStr(WParam));}

    Case WParam of
      0,169
         :  Begin
              {If (WParam=169) then
                MULCtrlO2.GetSelRec(BOff);}

              SetEntry(Password.PassListRec.PassLNo,0);

              {AddBtnClick(Edit1);}

            end;


      2  :  ShowRightMeny(LParamLo,LParamHi,1);


    end; {Case..}

  end;
  Inherited;
end;

Procedure TPwordList2.WMGetMinMaxInfo(Var Message  :  TWMGetMinMaxInfo);

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

Procedure TPwordList2.Send_UpdateList(Mode   :  Integer);

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






procedure TPwordList2.FormDesign;

Var
  ShowLoc  :  Boolean;

begin
  {CreateSubMenu(PopUpMenu4,Options1);}

  {$IFNDEF SOP}
     ShowLoc:=BOff;
  {$ELSE}

     ShowLoc:=Syss.UseMLoc;

  {$ENDIF}

  Label88.Visible:=ShowLoc;
  LocF.Visible:=ShowLoc;
  LocRulesCB.Visible:=ShowLoc;

  Label87.Visible:=Syss.UseCCDep;
  CCF.Visible:=Syss.UseCCDep;
  DepF.Visible:=Syss.UseCCDep;
  CCDRulesCB.Visible:=Syss.UseCCDep;

  PWEDaysF.BlockNegative:=BOn;
  PWALogf.BlockNegative:=BOn;
  MaxSAF.BlockNegative:=BOn;
  MaxPAF.BlockNegative:=BOn;

  If (Not EnSecurity) then  {Only show u/n, pw}
  Begin
    PWModeCBF.Visible:=BOff;
    Label83.Visible:=BOff;
    PWEDaysF.Visible:=BOff;
    PWExDateF.Visible:=BOff;
    Label813.Visible:=BOff;
    PWALogF.Visible:=BOff;
    Label814.Visible:=BOff;
    Label811.Visible:=BOff;
    DSRIF.Visible:=BOff;
    DPPIF.Visible:=BOff;
    Label85.Visible:=BOff;
    MaxSAF.Visible:=BOff;
    Label87.Visible:=BOff;
    MaxPAF.Visible:=BOff;
    Label86.Visible:=BOff;
    CCF.Visible:=BOff;
    DepF.Visible:=BOff;
    CCDRulesCB.Visible:=BOff;
    Label88.Visible:=BOff;
    LocF.Visible:=BOff;
    LocRulesCB.Visible:=BOff;
    Label89.Visible:=BOff;
    SBankGLF.Visible:=BOff;
    Label810.Visible:=BOff;
    PBankGLF.Visible:=BOff;
    {PWEmlF.Visible:=BOff;}
    Label828.Visible:=BOff;
    Label829.Visible:=BOff;
    DefFPrn.Visible:=BOff;
    DefRPrn.Visible:=BOff;
    SRCGLLab.Visible:=BOff;
    PPYGLLab.Visible:=BOff;
    SBSBackGroup3.Visible:=BOff;
    SBSBackGroup2.Visible:=BOff;
    {SBSBackGroup4.Visible:=BOff;}
    SBSBackGroup1.Height:=70;
    SBSBackGroup4.Top:=66;
    PWEmlF.Top:=84;
    //PS 06/04/2016 2016-R2 ABSEXCH-13555: Rogue Show G/L Code Checkbox on Password Settings.
    Label819.Visible:=BOff;
    Label820.Visible:=BOff;
    Label818.Visible:=BOff;
  end;


  {$IFDEF LTE}
    PWModeCBF.Visible:=BOff;
    Label83.Visible:=BOff;
    PWEDaysF.Visible:=BOff;
    PWExDateF.Visible:=BOff;

    Label816.Visible:=BOff;
    MemFaxSig.Visible:=BOff;
    FaxUserLab.Visible:=BOff;

  {$ENDIF}


  PrimeButtons;


end;

procedure TPwordList2.RefreshList2(ShowLines,
                                 IgMsg      :  Boolean);

Var
  KeyStart    :  Str255;
  LKeypath,
  LKeyLen     :  Integer;

Begin

  KeyStart:=PassLCode+#0;
  LKeyLen:=Length(KeyStart);


end;


procedure TPwordList2.FormBuildList2(ShowLines  :  Boolean);

Var
  StartPanel  :  TSBSPanel;
  n           :  Byte;



Begin
  


end;


procedure TPwordList2.RefreshList(ShowLines,
                               IgMsg      :  Boolean);

Var
  KeyStart    :  Str255;
  LKeypath,
  LKeyLen     :  Integer;

Begin

  KeyStart:=PassUCode+#0;
  LKeyLen:=Length(KeyStart);

  With MULCtrlO do
  Begin
    IgnoreMsg:=IgMsg;

    StartList(PWrdF,PWK,KeyStart,'','',LKeyLen,(Not ShowLines));

    IgnoreMsg:=BOff;
  end;

end;


procedure TPwordList2.FormBuildList(ShowLines  :  Boolean);

Var
  StartPanel  :  TSBSPanel;
  n           :  Byte;



Begin
  FormBuildList2(ShowLines);
  StartPanel := nil;
  MULCtrlO:=TPWMList.Create(Self);


  Try

    With MULCtrlO do
    Begin


      Try

        With VisiList do
        Begin
          AddVisiRec(UNPanel,UNLab);

          VisiRec:=List[0];

          StartPanel:=(VisiRec^.PanelObj as TSBSPanel);

          {HidePanels(0);}

          LabHedPanel:=D1HedPanel;

          ListOfSet:=10;

          SetHedPanel(ListOfSet);

        end;
      except
        VisiList.Free;

      end;




      Find_FormCoord;

      TabOrder := -1;
      TabStop:=BOff;
      Visible:=BOff;
      BevelOuter := bvNone;
      ParentColor := False;
      Color:=StartPanel.Color;
      MUTotCols:=0;
      Font:=StartPanel.Font;

      LinkOtherDisp:=BOn;

      WM_ListGetRec:=WM_CustGetRec;


      Parent:=StartPanel.Parent;

      MessHandle:=Self.Handle;

      For n:=0 to MUTotCols do
      With ColAppear^[n] do
      Begin
        AltDefault:=BOn;


      end;


      ListLocal:=@ExLocal;

      ListCreate;

      UseSet4End:=BOff;

      NoUpCaseCheck:=BOn;

      HighLiteStyle[1]:=[fsBold];

      Set_Buttons(PListBtnPanel);

      MUListBoxes[0].OnClick:=UNPanelClick;

      CUser:=Current_User;

      ReFreshList(ShowLines,BOff);


    end {With}


  Except

    MULCtrlO.Free;
    MULCtrlO:=Nil;
  end;



  FormSetOfSet;

  // CA 23/07/2012 ABSEXCH-12952 - Setting the TreeColor
  NLOLine.TreeColor   := NLOLine.Font.Color;

  FormReSize(Self);


  RefreshList(BOn,BOn);


end;



procedure TPwordList2.Prime_TreeGroups;

Var
  SentimailOn,
  VizRepWrt,
  CanSaveOLE,
  TradeCounter  :  Boolean;
  HoldStr,
  WOPStr,
  JAPStr,
  RetStr        :  Str255;

Begin
  WOPStr:=''; JAPStr:='';  RetStr:='';

  CanSaveOLE:=Check_ModRel(9,BOff);

  {$IFDEF DBD}
     TradeCounter:=BOn;
     SentimailOn:=BOn;
     VizRepWrt:=BOff;
  {$ELSE}
     TradeCounter:=Check_ModRel(11,BOn);
     SentimailOn:=Check_ModRel(14,BOn);
     VizRepWrt:=Check_ModRel(19,BOn);;
  {$ENDIF}

  {$I PWARY.PAS}



end;


Function TPwordList2.AddTreeNode(ParentIdx  :  LongInt;
                                 LineText   :  String;
                                 GrpAry,
                                 Level      :  LongInt;
                                 PWNo       :  SmallInt;
                                 Mode       :  Byte)  :  Integer;
Var
  ONomRec   :  ^OutNomType;

Begin
  Result := -1;
  If (LineText<>'XNANX') then {* Exclude those which cannot be found *}
  With NLOLine do
  Begin
    New(ONomRec);
    FillChar(ONomRec^,Sizeof(ONomRec^),0);
    With ONomRec^ do
    Begin
      OutNomCode:=GrpAry;
      OutDepth:=Level;
      LastPr:=PWNo;
      MoreLink:=(Mode=0);
    end;

    Result:=AddChildObject(ParentIdx,LineText,ONomRec);

    
    If (Result>-1) then
    With Items[Result] do
    Begin
      ShowCheckBox:=(PWNo>0);


    end;

  end; {With..}


end;


Function TPwordList2.GetPWText(PWCode  :  Str255;
                           Var PNo     :  SmallInt )  :  String;

Const
  Fnum    =  PWrdF;
  Keypath =  PWK;

Var
  KeyS  :  Str255;

Begin
  KeyS:=PassLCode+#0+PWCode;
  PNo:=0;

  With ExLocal do
  Begin
    Status:=Find_Rec(B_GetEq,F[Fnum],Fnum,LRecPtr[Fnum]^,KeyPath,KeyS);

    If (StatusOk) then
    With LPassWord.PassListRec do
    Begin
      Result:=PassDesc;
      PNo:=PassLNo;
    end
    else
      {$IFDEF DBD}
        Result:='** Invalid Password setting ** '+PWCode;
      {$ELSE}
        Result:='XNANX'; {Non debug mode deliberatly exclude those which cannot be found}
      {$ENDIF}
  end;


end;


procedure TPwordList2.Build_TreeGroups(Var GrpAry     :  LongInt;
                                          ParentIdx  :  LongInt;
                                          Level      :  LongInt);

Var
  LastIdx  :  LongInt;
  PNo      :  SmallInt;
  LineText :  Str255;


Begin
  LastIdx:=ParentIdx;

  While (GrpAry<=High(PWTreeGrpAry)) do
  With PWTreeGrpAry[GrpAry] do
  If (Not Exclude) and (tCaption<>'') then {* Exclude for modules sensitive, + deliberrate gaps for other groups *}
  Begin
    If (IsChild=Level) then
    Begin
      LastIdx:=AddTreeNode(ParentIdx,tCaption,GrpAry,Level,0,0);

      If (WordCnt(PWLink)>0) and (PWLink[1]<>'X') then {Add in first item so we get a folder unless we already have sub nodes}
      Begin
        LineText:=GetPWText(ExtractWords(1,1,PWLink),PNo);

        AddTreeNode(LastIdx,LineText,0,Level,PNo,1);
      end;

      Inc(GrpAry);
    end
    else
      If (IsChild>Level) then {Drop it down a level based on last parent added}
        Build_TreeGroups(GrpAry,LastIdx,Level+1)
      else
        Exit;



  end {While..}
  else
    Inc(GrpAry);

  NLOLine.TreeReady:=BOn;

end; {Proc..}



procedure TPwordList2.FormCreate(Sender: TObject);
Var
  BMap1       :  TBitMap;

  RectD       :  TRect;

  n           :  Integer;

  Rule: string;

begin
  fDoingClose:=BOff;

  RecMode:=BOff;

  fLoadCompanySig:=BOff;

  Current_User:=EntryRec^.Login;
  Sel_User:='';

  Blank(EntryRec2,Sizeof(EntryRec2));

  OverW:=BOn;

  TreeExpanded:=BOff;

  HideDAdd:=BOff;

  PrintJob:=Nil;

  BuildDesign;


  {BMap1:=TBitMap.Create;

  try

    BMap1.Handle:=LoadBitMap(HInstance,'ENTLOG_1');

    With BMap1 do
      RectD:=Rect(0,0,Width,Height);


    With Image1.Picture.Bitmap do
    Begin
      Width:=BMap1.Width;
      Height:=BMap1.Height;

      Canvas.Brush.Color:=clBtnFace;
      Canvas.BrushCopy(RectD,BMap1,RectD,clWhite);
    end;
  finally
    BMap1.Free;

  end; {try..}

  {With Animated1 do Removed for new pw screen in v4.40
  Begin
    SetBounds(Left,Top,64,47);

    Loop:=True;
    Play:=Not NoXLogo;

    Visible:=Play;
  end;}

  ExLocal.Create;

  SKeypath:=0;

  LastCoord:=BOff;
  NeedCUpdate:=BOff;

  JustCreated:=BOn;

  InterMode:=BOff;

  { EH 45 Stock Tree = Type and Code Diplay Options
    was InitSize.Y:=469. Increased height and altered}
  InitSize.Y:=534;
  InitSize.X:=675;

  Self.ClientHeight:=InitSize.Y;
  Self.ClientWidth:=InitSize.X;

  {Height:=360;
  Width:=530;}

  LastFind:='';

  FFiles[1] := '';
  FFiles[2] := '';
  FStrings := TStringList.Create;



  BeenIn:=BOff;

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

  // CJS 2013-09-11 - ABSEXCH-13192 - add Job Costing to user profile rules
  if JBCostOn then
  begin
    for n := 0 to CCDRulesCB.Items.Count - 1 do
    begin
      Rule := CCDRulesCB.Items[n];
      Rule := Rule + ', Job';
      CCDRulesCB.Items[n] := Rule;
    end;
  end;

  With CCDRulesCB do
  Begin
    ItemsL.Assign(Items);
  end;

  {$IFDEF SOP}

    With LocRulesCB do
    Begin
      ItemsL.Assign(Items);
    end;


  {$ENDIF}


  {$IFDEF STK}
    //PS 06/04/2016 2016-R2 ABSEXCH-13555: Rogue Show G/L Code Checkbox on Password Settings.
    if not EnSecurity then
      Label817.Visible                   :=False
    else
     Label817.Visible                   := True;
     TBorCh_ShowStockCode.Visible       := True;
     TBorCh_ShowProductType.Visible     := True;
  {$ENDIF}

  FormBuildList(BOff);

  MDI_SetFormCoord(TForm(Self));

  ChangePage(0);

  SetHelpContextIDsForPage; // NF: 16/05/06 Fix for incorrect Context IDs

end;




procedure TPwordList2.FormDestroy(Sender: TObject);

Var
  n  :  Byte;
begin
  ExLocal.Destroy;

  FStrings.Destroy;

  If (Assigned(PrintJob)) then
    FreeAndNil(PrintJob);
end;

procedure TPwordList2.FormCloseQuery(Sender: TObject;
                             var CanClose: Boolean);
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

  VertScrollBar.Position:=0;
  HorzScrollBar.Position:=0;

  If (NeedCUpdate) then
    Store_FormCoord(Not SetDefault);

  Send_UpdateList(61);
end;

procedure TPwordList2.FormClose(Sender: TObject; var Action: TCloseAction);

Var
  ONomRec :  ^OutNomType;
  n       :  Integer;

begin
  If (Not fDoingClose) then
  Begin
    fDoingClose:=BOn;

    Action:=caFree;

    If (EntryRec^.Login<>Current_User) then
    Begin
      GetLoginRec(Current_User);

      Send_UpdateList(102);
    end;

    If (MULCtrlO<>nil) then
    Begin
      try
        MULCtrlO.Destroy;
      finally
        MULCtrlO:=nil;
      end;
    end;

    With NLOLine do {* Tidy up attached objects *}
    Begin
      For n:=1 to ItemCount do
      Begin
        ONomRec:=Items[n].Data;
        If (ONomRec<>nil) then
        Begin
          Dispose(ONomRec);
          Items[n].Data:=nil;
        end;
      end;

    end;


  end;
end;


procedure TPwordList2.FormResize(Sender: TObject);
Var
  n           :  Byte;
  NewVal      :  Integer;


begin

  If (GotCoord) then
  Begin


    PageControl1.Width:=ClientWidth-PagePoint[0].X;
    PageControl1.Height:=ClientHeight-PagePoint[0].Y;


    PBtnPanel.Left:=PageControl1.Width-PagePoint[2].X;

    PBtnPanel.Height:=PageControl1.Height-PagePoint[2].Y;

    {D1SBox.Width:=PageControl1.Width-PagePoint[1].X;}
    D1SBox.Height:=PageControl1.Height-PagePoint[1].Y;

    D2SBox.Height:=D1SBox.Height;
    D2SBox.Width:=PageControl1.Width-PagePoint[4].X;

    D3SBox.Height:=D1SBox.Height;
    D3SBox.Width:=PageControl1.Width-PagePoint[4].X;

    P1BSBox.Height:=PBtnPanel.Height-PagePoint[3].X;


    PListBtnPanel.Height:=PBtnPanel.Height-PagePoint[4].Y;
    PListBtnPanel.Left:=D1SBox.Left+D1SBox.Width+2;

    NLOLine.Height:=D2SBox.Height-57;
    NLOLine.Width:=D2SBox.Width-4;
    {SBSPanel1.Width:=NLOLine.Width;}



    If (MULCtrlO<>nil) then
    Begin
      LockWindowUpDate(Handle);

      With MULCtrlO,VisiList do
      Begin
        VisiRec:=List[0];

        With (VisiRec^.PanelObj as TSBSPanel) do
        Begin
          Height:=D1SBox.ClientHeight-PagePoint[3].Y;
        end;

        RefreshAllCols;
      end;


      LockWindowUpDate(0);


      MULCtrlO.ReFresh_Buttons;

      MULCtrlO.LinkOtherDisp:=BOn;

    end;{Loop..}

    
    NeedCUpdate:=((StartSize.X<>Width) or (StartSize.Y<>Height));
  end; {If time to update}
end;





procedure TPwordList2.SetFormProperties;


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
        SetProperties(TmpPanel[1],TmpPanel[2],TmpPanel[3],1,Caption+' Properties',BeenChange,ResetDefaults);

        NeedCUpdate:=(BeenChange or ResetDefaults);

        If (BeenChange) and (not ResetDefaults) then
        Begin

          For n:=1 to 3 do
            With TmpPanel[n] do
              Case n of
                1,2  :  Begin
                          MULCtrlO.ReColorCol(Font,Color,(n=2));
                          With NLOLine do
                          Begin
                            Case n of
                              1  :  Begin
                                      Font.Assign(TmpPanel[1].Font);
                                      Color:=TmpPanel[1].Color;
                                    end;

                              2  :  Begin

                                    end;
                            end; {case..}

                          end;
                        end;

                3    :  Begin
                          MULCtrlO.ReColorBar(Font,Color);
                          With NLOLine do
                          Begin
                            BarColor:=TmpPanel[3].Color;
                            BarTextColor:=TmpPanel[3].Font.Color;


                          end;
                        end;

              end; {Case..}

          MULCtrlO.VisiList.LabHedPanel.Color:=TmpPanel[2].Color;
          //MULCtrlO2.VisiList.LabHedPanel.Color:=TmpPanel[2].Color;

          SetFieldProperties(UNPanel);

          // CA 23/07/2012 ABSEXCH-12952 - Setting the TreeColor
          NLOLine.TreeColor   := NLOLine.Font.Color;
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




  procedure TPwordList2.Display_Rec2(Mode  :  Byte);

  Var
    n  :  SmallInt;

  Begin

    Try


     Begin
       ExLocal.AssignFromGlobal(PWrdF);

       If (Mode In [1..6]) then
       Begin

         OverW:=(Not (Mode In [4,5]));

         If (Mode=5) and (Not ExLocal.InAddEdit) then {Get current settings}
         Begin
           For n:=0 to 3 do {* Get any password settings + additional page settings *}
             SetEntryRecVar(n,PassWord.PassEntryRec.Login,(n>0),BOn,EntryRec2);


           EntryDefaults2:=Link_PWDefaults(PassWord.PassEntryRec.Login,n);

           EntryRec^:=EntryRec2;
         end;

         Case Mode of

           1..2,4..5
                 :   If (Not ExLocal.InAddEdit) then
                       EditLine((Mode=2),Mode)
                     else
                       Show;

              3  :  If (Not ExLocal.InAddEdit) then
                       DeleteBOMLine(PWrdF,PWK)
                     else
                       Show;

              6  :  If (Not ExLocal.InAddEdit) then
                       DeleteCustomPos
                     else
                       Show;

         end; {Case..}

       end;



     end; {With..}


    except


    end;

  end;




procedure TPwordList2.ShowRightMeny(X,Y,Mode  :  Integer);

Begin
  With PopUpMenu1 do
  Begin

    PopUp(X,Y);
  end;


end;



procedure TPwordList2.PropFlgClick(Sender: TObject);
begin
  SetFormProperties;
end;

procedure TPwordList2.StoreCoordFlgClick(Sender: TObject);
begin
  StoreCoord:=Not StoreCoord;
end;

procedure TPwordList2.PopupMenu1Popup(Sender: TObject);
Var
  n  :  Integer;

begin
  StoreCoordFlg.Checked:=StoreCoord;

  NeedCUpdate:=BOn;

  With InvBtnList do
  Begin
    ResetMenuStat(PopUpMenu1,BOn,BOn);

    With PopUpMenu1 do
    For n:=0 to Pred(Count) do
      SetMenuFBtn(Items[n],n);

  end; {With..}

end;

procedure TPwordList2.Clsd1BtnClick(Sender: TObject);
begin
  If (Not MULCtrlO.InListFind) then
  Begin
    If (Current_Page=0) then
    Begin
      {$B-}
      If (Not ExLocal.InAddEdit) or (ConfirmQuit) then
      {$B+}
        Close;
    end
    else
      ChangePage(0);
  end;    
end;

procedure TPwordList2.UNPanelClick(Sender: TObject);
begin
  If (RecMode) then
  Begin
    MULCtrlO.Set_ButtonsVisible(BOn);
    RecMode:=Not RecMode;
  end;

  MULCtrlO.MUListBox1.OnClick(Sender);
end;

procedure TPwordList2.PYNPanelClick(Sender: TObject);
begin
  If (Not RecMode) then
  Begin
    RecMode:=Not RecMode;
    MULCtrlO.Set_ButtonsVisible(BOff);
  end;

end;

procedure TPwordList2.PYNLabMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
Var
  ListPoint  :  TPoint;


begin
  If (Sender is TSBSPanel) then
  With (Sender as TSBSPanel) do
  Begin

    If (Not ReadytoDrag) and (Button=MBLeft) then
    Begin

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


procedure TPwordList2.PYNLabMouseMove(Sender: TObject; Shift: TShiftState; X,
  Y: Integer);
begin
  If (Sender is TSBSPanel) then
  With (Sender as TSBSPanel) do
  Begin

  end;

end;

procedure TPwordList2.PYNLabMouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
  Var
  BarPos :  Integer;
  PanRSized
         :  Boolean;

begin

  If (Sender is TSBSPanel) then
  With (Sender as TSBSPanel) do
  Begin

    PanRSized:=ReSized;

    BarPos:=D2SBox.HorzScrollBar.Position;

  end;

end;



procedure TPwordList2.UNLabMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
Var
  ListPoint  :  TPoint;


begin
  If (Sender is TSBSPanel) then
  With (Sender as TSBSPanel) do
  Begin

    If (Not ReadytoDrag) and (Button=MBLeft) then
    Begin
      If (MULCtrlO<>nil) then
        MULCtrlO.VisiList.PrimeMove(Sender);

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

procedure TPwordList2.UNLabMouseMove(Sender: TObject; Shift: TShiftState; X,
  Y: Integer);
Begin
  If (Sender is TSBSPanel) then
  With (Sender as TSBSPanel) do
  Begin

    If (MULCtrlO<>nil) then
    Begin
      MULCtrlO.VisiList.MoveLabel(X,Y);
      NeedCUpdate:=MULCtrlO.VisiList.MovingLab;
    end;
  end;
end;

procedure TPwordList2.UNLabMouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
Var
  BarPos :  Integer;
  PanRSized
         :  Boolean;

begin

  If (Sender is TSBSPanel) then
  With (Sender as TSBSPanel) do
  Begin

    PanRSized:=ReSized;

    BarPos:=D1SBox.HorzScrollBar.Position;

    If (PanRsized) then
      MULCtrlO.ResizeAllCols(MULCtrlO.VisiList.FindxHandle(Sender),BarPos);

    MULCtrlO.FinishColMove(BarPos+(ListOfset*Ord(PanRSized)),PanRsized);

    NeedCUpdate:=(MULCtrlO.VisiList.MovingLab or PanRSized);
  end;

end;

procedure TPwordList2.AddBtnClick(Sender: TObject);
Var
  SendTag  :  Integer;

begin
  If (Not MULCtrlO.InListFind) then
  Case Current_Page of
    0  :  Begin
            SendTag:=TComponent(Sender).Tag;

            If (SendTag=1) then
            Begin
              If (MessageDlg('Would you like to create a user with all the password access settings set to Yes.',
                                 mtConfirmation,[mbYes,mbNo],0)=mrYes) then
              SendTag:=4;
            end;

            If (Assigned(MULCtrlO)) then
            With MULCtrlO do
            Begin
              If (ValidLine) or (SendTag In [1,4]) then
                Display_Rec2(SendTag)
              else
                MessageBeep(0);
            end;
          end;

    2  :  Begin
            // Edit -

            memFaxSig.ReadOnly := False;
            memEmailSig.ReadOnly := False;

            OkCP1Btn.Enabled:=BOn;
            CanCP1Btn.Enabled:=BOn;
            EditBtn.Enabled:=BOff;

            If memEmailSig.CanFocus then
              memEmailSig.SetFocus;


        end;


  end; {Case..}
end;

procedure TPwordList2.FormActivate(Sender: TObject);
begin
  If (Assigned(MULCtrlO))   then
    MULCtrlO.SetListFocus;
end;



Procedure TPwordList2.StoreEntryRec(PgNo    :  Byte;
                                   PLogin  :  Str10;
                                   StoreRec:  Boolean);



Var
  KeyS  :  Str255;
  n     :  Byte;
  Idx   :  Longint;
  NewRec:  Boolean;


Begin

  NewRec:=BOff;

  With ExLocal,MULCtrlO do
  Begin

      If (StoreRec) then
      Begin
        KeyS:=FullPWordKey(PassUCode,Chr(PgNo),PLogin);

        Status:=Find_Rec(B_GetEq,F[ScanFileNum],ScanFileNum,LRecPtr[ScanFileNum]^,KeyPath,KeyS);

        If (Not StatusOk) then
        Begin
          LResetRec(ScanFileNum);
          NewRec:=BOn;
        end;

      end;

      Idx:=256*PgNo;

      With LPassWord,PassEntryRec do
      Begin
        For n:=Low(Access) to High(Access) do
        Begin
          Access[n]:=EntryRec2.Access[n+Idx];

        end;

        If (StoreRec) then
        Begin
          If (NewRec) then
          Begin
            RecPfix:=PassUCode;
            SubType:=Chr(PgNo);
            Login:=PLogIn;

            Status:=Add_Rec(F[ScanFileNum],ScanFileNum,LRecPtr[ScanFileNum]^,KeyPath);
          end
          else
            Status:=Put_Rec(F[ScanFileNum],ScanFileNum,LRecPtr[ScanFileNum]^,KeyPath);

          Report_BError(ScanFileNum,Status);

        end;
      end;
  end;
end;


Procedure TPwordList2.RenameEntryRec(PgNo    :  Byte;
                                     PLogin,
                                     NewLogin
                                             :  Str10);



Var
  KeyS  :  Str255;
  n     :  Byte;
  Idx   :  Longint;
  NewRec:  Boolean;


Begin

  NewRec:=BOff;

  With ExLocal,MULCtrlO do
  Begin

      Begin
        KeyS:=FullPWordKey(PassUCode,Chr(PgNo),PLogin);

        Status:=Find_Rec(B_GetEq,F[ScanFileNum],ScanFileNum,LRecPtr[ScanFileNum]^,KeyPath,KeyS);

        If (Not StatusOk) then
        Begin
          LResetRec(ScanFileNum);
          NewRec:=BOn;
        end;

      end;

      Idx:=256*PgNo;

      With LPassWord,PassEntryRec do
      Begin
        Begin
          If (Not NewRec) then
          Begin
            RecPfix:=PassUCode;
            SubType:=Chr(PgNo);
            Login:=NewLogin;

            Status:=Put_Rec(F[ScanFileNum],ScanFileNum,LRecPtr[ScanFileNum]^,KeyPath);

            Report_BError(ScanFileNum,Status);

          end;

        end;
      end;
  end;
end;


procedure TPwordList2.SetEntry(Idx,SetTMode  :  Integer);

Var
  Tbo,
  LOk,
  LLocked :  Boolean;

  KeyS    :  Str255;

  FKeypath,
  NLSelItem
          :  Integer;



begin
  If (Assigned(MULCtrlO)) then
  With ExLocal,MULCtrlO do
    If (ValidLine) then
    Begin

      GetSelRec(BOff);

      AssignFromGlobal(ScanFileNum);
      LGetRecAddr(ScanFileNum);

      FKeyPath:=KeyPath;

      LOk:=LGetMultiRec(B_GetDirect,B_MultLock,KeyS,FKeyPAth,ScanFileNum,BOff,LLocked);

      If (LOk) and (LLocked) then
      With LPassWord,PassEntryRec do
      Begin
        Case SetTMode of
          1,2
             :  Begin
                  EntryRec2.Access[Idx]:=Ord(SetTMode=1);

                end;
          3  :  ; {Just go through the motions of storing it}

          else  Begin
                  Tbo:=(EntryRec2.Access[Idx]>0);

                  Tbo:=Not Tbo;

                  EntryRec2.Access[Idx]:=Ord(Tbo);

                end;
        end; {Case..}


        {Access:=(MULCtrlO2.EntryRec2.Access);}

        StoreEntryRec(0,LogIn,BOff);

        Status:=Put_Rec(F[ScanFileNum],ScanFileNum,LRecPtr[ScanFileNum]^,KeyPAth);

        Report_BError(ScanFileNum,Status);

        UnLockMLock(ScanFileNum,LastRecAddr[ScanFileNum]);

        {* Store any additional Pages *}
                         {* Extra page added to list v5.61 *}


        {$IFDEF EN560}
        If (Idx>255) and (Idx<=496) then  {* Was 496 v5.60}
          StoreEntryRec(1,LogIn,BOn)
          else
            If (Idx>496) and (Idx<=751) then
              StoreEntryRec(2,LogIn,BOn)
            else
              If (Idx>751) then
                StoreEntryRec(3,LogIn,BOn);
        {$ELSE}

          If (Idx>255) and (Idx<=511) then  {* Was 496 v5.60}
            StoreEntryRec(1,LogIn,BOn)
            else
              If (Idx>511) and (Idx<=766) then
                StoreEntryRec(2,LogIn,BOn)
              else
                If (Idx>766) then
                  StoreEntryRec(3,LogIn,BOn);
        {$ENDIF}

        With NLOLine do
        Begin
          NLSelItem:=SelectedItem;

          If (NLSelItem>-1) then
          Begin
            If (NLSelItem>1) then
              SelectedItem:=Pred(NLSelItem)
            else
              SelectedItem:=1;

            SelectedItem:=NLSelItem;
          end;

          If (EntryRec2.Login=EntryRec^.Login) or (InterMode) then {* Show effect immedieatley *}
          Begin
            EntryRec^:=EntryRec2;
            Send_UpdateList(102);
          end;
        end;
      end;
    end;
end;


procedure TPwordList2.SetLevelEntry(Idx,SetTMode  :  Integer);

Var
  Tbo,
  LOk,
  LLocked :  Boolean;

  KeyS    :  Str255;

  FKeypath,
  NLSelItem
          :  Integer;



begin
  With ExLocal do
    Case SetTMode of
      1,2
         :  Begin
              EntryRec2.Access[Idx]:=Ord(SetTMode=1);

            end;

      else  Begin
              Tbo:=(EntryRec2.Access[Idx]>0);

              Tbo:=Not Tbo;

              EntryRec2.Access[Idx]:=Ord(Tbo);

            end;
    end; {Case..}
end;


procedure TPwordList2.InterBtnClick(Sender: TObject);

Const
  InterTit  :  Array[False..True] of Str20 = ('&Interactive','&Normal');
begin
  If (Not MULCtrlO.InListFind) then
  Begin
    InterMode:=Not InterMode;

    InterBtn.Caption:=InterTit[InterMode];

    If (Not InterMode) and (EntryRec^.Login<>Current_User) then
      GetLoginRec(Current_User);

    If (InterMode) then
      EntryRec^:=EntryRec2;

    Send_UpdateList(102);
  end;
end;


procedure TPwordList2.GetMoreLinks(Index  :  Integer);

Var
  ONomRec :  ^OutNomType;

  n,PNo       :  SmallInt;

  PWText  :  Str255;

Begin
  With NLOLine do
  Begin
    ONomRec:=Items[Index].Data;

    If (ONomRec<>nil) then
    With ONomRec^ do
    If (OutNomCode<>0) then
    Begin
      MoreLink:=BOff;

      With PWTreeGrpAry[OutNomCode] do
      Begin
        If (WordCnt(PWLink)>1) then
          For n:=2 to WordCnt(PWLink) do
          Begin
            PWText:=GetPWText(ExtractWords(n,1,PWLink),PNo);


            AddTreeNode(Index,PWText,0,OutDepth,PNo,1);


          end;

      end;
    end;

  end; {With..}

end;

procedure TPwordList2.NLOLineExpand(Sender: TObject; Index: Integer);
Var
  ONomRec :  ^OutNomType;

begin
  With (Sender as TSBSOutLineB) do
  Begin
    ONomRec:=Items[Index].Data;

    If (ONomRec<>nil) then
    With ONomRec^ do
    Begin
      If (ITems[Index].HasItems) then
      Begin

        If (MoreLink) then {* Get next load *}
        Begin
          //PostMessage(Self.Handle,WM_CustGetRec,250,Index);

          GetMoreLinks(Index);
        end;
      end
      else
      If (LastPR>0) then
      Begin
        {Change value of password }

        SetEntry(LastPr,0);

      end;
    end;
  end; {With..}
end;

procedure TPwordList2.FullExBtnClick(Sender: TObject);
begin
  NLOLine.FullExpand;
  TreeExpanded:=BOn;
end;

procedure TPwordList2.FullColBtnClick(Sender: TObject);
begin
  NLOLine.FullCollapse;
  TreeExpanded:=BOff;
end;

procedure TPwordList2.NLOLineNeedValue(Sender: TObject);
Var
  ONomRec      :  ^OutNomType;
  DrawIdxCode  :  LongInt;

begin
  With Sender as TSBSOutLineB do
  Begin
    DrawIdxCode:=CalcIdx;

    If (DrawIdxCode>0) then
    Begin
      ONomRec:=Items[DrawIdxCode].Data;

      If (ONomRec<>nil) then
      With ONomRec^ do
      Begin
        ColValue:=0;

        If (LastPr>0) then
        With Items[DrawIdxCode] do
          Begin
            CheckBoxChecked:=(EntryRec2.Access[LastPr]=1);

            If  CheckBoxChecked then
              UseLeafX:=obLeaf2
            else
              UseLeafX:=obLeaf;

            If (EntryRec2.Access[LastPr]=0) then
              ColValue:=0.001
            else
              ColValue:=EntryRec2.Access[LastPr];

            ColFmt:=GenUnitMask[BOff]
          end;

          ColsX:=Width-15;
      end;
    end; {If found equiv index..}
  end;

end;




procedure TPwordList2.NLOLineUpdateNode(Sender: TObject;
  var Node: TSBSOutLNode; Row: Integer);

var
  ONomRec      :  ^OutNomType;

begin
  With Node do
  Begin
    ONomRec:=Data;

    If (ONomRec<>nil) then
    With ONomRec^ do
    Begin
      If (LastPr>0) then
      Begin
        CheckBoxChecked:=(EntryRec2.Access[LastPr]=1);

        If  CheckBoxChecked then
          UseLeafX:=obLeaf2
        else
          UseLeafX:=obLeaf;

      end;
    end;

  end;
end;

procedure TPwordList2.NLOLineNodeChkHotSpot(Sender: TObject;
  var Node: TSBSOutLNode; Row: Integer);
Var
  ONomRec :  ^OutNomType;

begin
  With (Sender as TSBSOutLineB) do
  Begin
    ONomRec:=Node.Data;

    If (ONomRec<>nil) then
    With ONomRec^ do
    Begin
      If (LastPR>0) then
      Begin
        {Change value of password }

        SetEntry(LastPr,0);

      end;
    end;
  end; {With..}
end;



procedure TPwordList2.SetThisNode(Index,SetTMode,Level  :  Integer);

Var
  ONomRec      :  ^OutNomType;
  n            :  Integer;
  DrawIdxCode  :  LongInt;
  FoundOk      :  Boolean;

begin
  FoundOk:=BOff;

  With NLOLine do
  Begin
    If (Index>=0) then
    Begin

      ONomRec:=Items[Index].Data;

      If (ONomRec<>nil) then
      With ONomRec^ do
      Begin

        If (Items[Index].HasItems) then
        Begin
          Items[Index].Expand;

          DrawIdxCode:=Items[Index].GetFirstChild;

          While (DrawIdxCode>=0) do
          Begin
            If (Items[DrawIdxCode].HasItems) then
              SetThisNode(DrawIdxCode,SetTMode,Level+1)
            else
            Begin
              ONomRec:=Items[DrawIdxCode].Data;

              If (ONomRec<>nil) then
              With ONomRec^ do
              Begin
                If (LastPr>0) then
                Begin
                  SetLevelEntry(LastPr,SetTMode);
                end;

                If (Not FoundOk) then
                  FoundOk:=(LastPr>0);
              end;
            end;

            DrawIdxCode:=Items[Index].GetNextChild(DrawIdxCode);

          end; {While..}

          If (Level=0) then
          Begin
            For n:=1 to 3 do
              SetEntry(n*256,3); {Final update}

            Refresh;
          end;
        end
        else
          If (LastPr>0) then
          Begin
            If (Level=0) then {* Do one and only store}
            Begin
              SetEntry(LastPr,SetTMode);

              If (SelectedItem>1) then
                SelectedItem:=Pred(SelectedItem)
              else
                SelectedItem:=0;

              SelectedItem:=Index;
            end
            else {Just in memory}
              SetLevelEntry(LastPr,SetTMode);

          end;
      end;{With..}


    end;
  end;{With..}

end;{Proc..}

procedure TPwordList2.BN2Click(Sender: TObject);
begin
  If (NLOLine.SelectedItem>=0) then
    SetThisNode(NLOLine.SelectedItem,(1*Ord((Sender=BN1) or (Sender=SetYesBtn)))+(2*Ord((Sender=DN1) or (Sender=SetNoBtn))),0);
end;


procedure TPwordList2.OpenThisNode(Index,SetTMode :  Integer);

Var
  ONomRec      :  ^OutNomType;
  DrawIdxCode  :  LongInt;
  FoundOk      :  Boolean;

begin
  FoundOk:=BOff;

  With NLOLine do
  Begin
    If (Index>=0) then
    Begin

      ONomRec:=Items[Index].Data;

      If (ONomRec<>nil) then
      With ONomRec^ do
      Begin

        If (Items[Index].HasItems) then
        Begin
          Case SetTMode of
            0  :  Items[Index].Collapse;
            1  :  Items[Index].Expand;
          end; {Case..}

        end;
      end;{With..}


    end;
  end;{With..}

end;{Proc..}


procedure TPwordList2.Collapse1Click(Sender: TObject);
begin
  If (NLOLine.SelectedItem>=0) then
    OpenThisNode(NLOLine.SelectedItem,TComponent(Sender).Tag);

end;

Procedure TPwordList2.FindPassword;


Var
  InpOk,
  FoundOk  :  Boolean;

  FoundCode:  Str20;
  FoundLong
           :  LongInt;

  n,INCode,
  StartNode:  Integer;

  SCode    :  String;

  SearchStr,
  KeyS     :  Str255;


Begin

  SCode:=LastFind;
  FoundOk:=BOff;

  InpOk:=InputQuery('Find Password Setting','Please enter the text code you wish to find',SCode);

  If (InpOk) then
  With NLOLine do
  Begin
    
    If (Not TreeExpanded) then
      FullExpand;

    If (SelectedItem<0) then
      StartNode:=0
    else
      StartNode:=SelectedItem;

    SearchStr:=Items[StartNode].Text;

    If (Match_Glob(Succ(Length(SearchStr)),Copy(SCode,1,30),SearchStr,InpOk)) then {Jump past the one we are on}
      StartNode:=StartNode+1;

    LastFind:=SCode;

    For n:=StartNode to ItemCount-1 do
    Begin
      Blank(SearchStr,Sizeof(SearchStr));

      SearchStr:=Items[n].Text;

      FoundOk:=Match_Glob(Succ(Length(SearchStr)),Copy(SCode,1,30),SearchStr,InpOk);

      If (FoundOk) then
        Break;

    end;

    If (FoundOk) then
      SelectedItem:=n
    else
      ShowMessage('Unable to locate '+SCode);
  end;


end;



procedure TPwordList2.SN1Click(Sender: TObject);
begin
  If (Not MULCtrlO.InListFind) then
  Case Current_Page of
    1  :  FindPassWord;
    2  :  Begin
            fLoadCompanySig:=Not fLoadCompanySig;

            LoadUserSig(Ord(fLoadCompanySig));

          end;
  end;
end;


procedure TPwordList2.PageControl1Changing(Sender: TObject;
  var AllowChange: Boolean);
begin
  If (AllowChange) then
  Begin
    Release_PageHandle(Sender);

    If (Current_Page=2) then {Abort Edit}
      StoreSigs(BOff);
  end;
end;


procedure TPwordList2.PageControl1Change(Sender: TObject);
Var
  GrpAry,
  NewIndex  :  Integer;
begin
  SetHelpContextIDsForPage; // NF: 16/05/06 Fix for incorrect Context IDs

  Begin
    {NewIndex:=pcLivePage(PageControl1);}

    PrimeButtons;

    {$B-}

    If (Not BeenIn) and (Current_Page=1) then
    Begin
      BeenIn:=BOn;

      Blank(PWTreeGrpAry,Sizeof(PWTreeGrpAry));
      Prime_TreeGroups;

      GrpAry:=1;

      Build_TreeGroups(GrpAry,0,0);


    end;

    If (Assigned(MULCtrlO)) and (MULCtrlO.ValidLine) then
      SendMessage(Self.Handle,WM_CustGetRec,1,0);


    {$B+}

  end;

end;


procedure TPwordList2.SetCompRORules;
Begin
  PWEDaysF.Enabled:=(PWModeCBF.ItemIndex=1);
  PWExDateF.Enabled:=PWEDaysF.Enabled;

  CCDRulesCB.Enabled:=((Not EmptyKeyS(CCF.Text,CCKeyLen,BOff)) or (Not EmptyKeyS(DepF.Text,CCKeyLen,BOff)));

  {$IFDEF SOP}
    LocRulesCB.Enabled:=(Not EmptyKey(Locf.Text,MLocKeyLen));

  {$ENDIF}

end;

procedure TPwordList2.SetCompRO(TC : TComponent; Const TG     :  Integer;
                                Const EnabFlg:  Boolean);
Begin
  //TW 15/08/2011 Rewrote & extended loop.
  if TC.Tag = TG then
  begin
    If (TC is TMaskEdit) then
    begin
      TMaskEdit(TC).ReadOnly := Not EnabFlg;
      TMaskEdit(TC).TabStop := Not TMaskEdit(TC).ReadOnly;
    end
    else if (TC is TCurrencyEdit) then
    begin
      TCurrencyEdit(TC).ReadOnly := Not EnabFlg;
      TCurrencyEdit(TC).TabStop := Not TCurrencyEdit(TC).ReadOnly;
    end
    else if (TC is TSBSComboBox) then
    begin
      TSBSComboBox(TC).ReadOnly := Not EnabFlg;
      TSBSComboBox(TC).TabStop := Not TSBSComboBox(TC).ReadOnly;
    end
    else if (TC is TBorCheck) then
      TBorCheck(TC).Enabled := EnabFlg
    else if (TC is TBorRadio) then
      TBorRadio(TC).Enabled := Not EnabFlg;
  end;
end;
procedure TPwordList2.SetPWStore(EnabFlag,
                                 ButnFlg  :  Boolean);

Var
  Loop  :  Integer;

Begin

  OkCP1Btn.Enabled:=EnabFlag;
  CanCP1Btn.Enabled:=EnabFlag;

  AddBtn.Enabled:=Not EnabFlag;

  EditBtn.Enabled:=Not EnabFlag;

  DelBtn.Enabled:=(Not EnabFlag);

  CopyBtn.Enabled:=(Not EnabFlag);

  InterBtn.Enabled:=(Not EnabFlag);

  ResetCBtn.Enabled:=(Not EnabFlag);

  PrintBtn.Enabled:=(Not EnabFlag);


  HideDAdd:=EnabFlag;

  BuildDesign;

  ExLocal.InAddEdit:=EnabFlag;

  For Loop:=0 to ComponentCount-1 do
  Begin
    SetCompRO(Components[Loop],1,EnabFlag);
  end;


  If (EnabFlag) then
    SetCompRORules;

end;




procedure TPwordList2.SCodeFExit(Sender: TObject);
Var
  COk   :  Boolean;
  CCode :  Str20;


begin

  If (Sender is TMaskEdit) then
  With (Sender as TMaskEdit),ExLocal,LPassWord do
  Begin
    Text:=UpcaseStr(Text);

    CCode:=LJVar(Text,LoginKeyLen);

    If ((Not LastEdit) or (LastPassWord.PassEntryRec.Login<>CCode)) and (InAddEdit) and (ActiveControl<>CanCP1Btn) then
    Begin
      COk:=(Not Check4DupliGen(FullPWordKey(RecPFix,SubType,CCode),PWrdF,PWK,'User Name ('+Strip('B',[#32],CCode)+')'));

      If (Not COk) then
      Begin

        SetFocus;
      end;
    end;
  end;
end;


procedure TPwordList2.DescFEnter(Sender: TObject);
begin
  If (Not DescF.ReadOnly) then
  Begin
    {DescF.PassWordChar:=#0;}
    DescF.Text:=Trim(DescF.Text);
  end;
end;

procedure TPwordList2.DescFExit(Sender: TObject);

Var
  WasModified  :  Boolean;

begin
  WasModified:=DescF.Modified;

  If (Not DescF.ReadOnly) and (ActiveControl<> CanCP1Btn) then
  Begin
    DescF.Text:=LJVar(DescF.Text,PWKeyLen);

    If (WasModified) then
    Begin
      If (Not VerifyPassword(Encode(UpCaseStr(Trim(DescF.Text))),Self)) then
      Begin
        DescF.Text:='';
        DescF.SetFocus;
      end
      else
      begin
        //GS 01/06/2011 ABSEXCH-11376: added code to increment the password expiry date of the target
        //account when its password is changed from the 'utilities > system setup > passwords' form:
        //update the password expiry date if the users 'password mode' is set to 'expire after 'x' number of days'..
        if PWModeCBF.ItemIndex = 1 then
        begin
          PWExDateF.DateValue := PassWR2U.IncPasswordExpDate(StrToInt(Trim(PWEDaysF.Text)), PWExDateF.DateValue);
        end;
      end;

    end;
      
    {DescF.PassWordChar:='x';}
  end;
end;


procedure TPwordList2.PWModeCBFChange(Sender: TObject);
begin
  SetCompRORules;
end;



procedure TPwordList2.DSRIFExit(Sender: TObject);
Var
  FoundCode  :  Str20;

  FoundOk,
  AltMod     :  Boolean;

begin

  If (Sender is Text8pt) then
  With (Sender as Text8pt) do
  Begin
    AltMod:=Modified;

    FoundCode:=Strip('B',[#32],Text);

    If (AltMod) and  ((FoundCode<>'') and (OrigValue<>Text))  and (ActiveControl<>CanCP1Btn) then
    Begin

      StillEdit:=BOn;

      FoundOk:=(GetCust(Self,FoundCode,FoundCode,(Sender=DSRIF),0));

      If (FoundOk) then
      Begin

        StillEdit:=BOff;

        Text:=FoundCode;

        {* Weird bug when calling up a list caused the Enter/Exit methods
             of the next field not to be called. This fix sets the focus to the next field, and then
             sends a false move to previous control message ... *}

        {FieldNextFix(Self.Handle,ActiveControl,Sender);}

      end
      else
      Begin

        SetFocus;
      end; {If not found..}
    end;
  end; {with..}
end;

procedure TPwordList2.CCFExit(Sender: TObject);
Var
  FoundCode  :  Str20;

  FoundOk,
  AltMod     :  Boolean;

  IsCC       :  Boolean;


begin

  {$IFDEF PF_On}

    If (Sender is Text8pt) then
    With (Sender as Text8pt) do
    Begin
      FoundCode:=Name;

      IsCC:=Match_Glob(Sizeof(FoundCode),'CC',FoundCode,FoundOk);

      AltMod:=Modified;

      FoundCode:=Strip('B',[#32],Text);

      If ((AltMod) and (FoundCode<>'')) and (ActiveControl<>CanCP1Btn) and (Syss.UseCCDep) and (ExLocal.InAddEdit) then
      Begin

        StillEdit:=BOn;

        FoundOk:=(GetCCDep(Self.Owner,FoundCode,FoundCode,IsCC,2));

        If (FoundOk) then
        Begin

          StillEdit:=BOff;

          Text:=FoundCode;

        end
        else
        Begin

          SetFocus;
        end; {If not found..}
      end;

    end; {with..}
  {$ENDIF}
end;


procedure TPwordList2.LocFExit(Sender: TObject);
Var
  FoundCode  :  Str10;

  FoundOk,
  AltMod     :  Boolean;

begin
  {$IFDEF SOP}
    If (Sender is Text8pt) then
    With (Sender as Text8pt) do
    Begin
      AltMod:=Modified;

      FoundCode:=Strip('B',[#32],Text);

      If (AltMod) and  (FoundCode<>'') and (OrigValue<>Text) and (ExLocal.InAddEdit) and (Syss.UseMLoc) and (ActiveControl<>CanCP1Btn) then
      Begin

        StillEdit:=BOn;

        FoundOk:=(GetMLoc(Self,FoundCode,FoundCode,'',0));

        If (FoundOk) then
        Begin

          StillEdit:=BOff;

          Text:=FoundCode;

          {* Weird bug when calling up a list caused the Enter/Exit methods
               of the next field not to be called. This fix sets the focus to the next field, and then
               sends a false move to previous control message ... *}

          {FieldNextFix(Self.Handle,ActiveControl,Sender);}

        end
        else
        Begin

          SetFocus;
        end; {If not found..}
      end;
    end; {with..}
  {$ENDIF}
end;


procedure TPwordList2.SBankGLFExit(Sender: TObject);
Var
  FoundCode  :  Str20;

  FoundOk,
  AltMod     :  Boolean;

  FoundLong  :  LongInt;


begin

  If (Sender is Text8pt) then
  With (Sender as Text8pt) do
  Begin
    AltMod:=Modified;

    FoundCode:=Strip('B',[#32],Text);

    If ((AltMod) and (FoundCode<>'')) and (ActiveControl<>CanCP1Btn) and (ExLocal.InAddEdit) then
    Begin

      StillEdit:=BOn;

      FoundOk:=(GetNom(Self.Owner,FoundCode,FoundLong,2));

      If (FoundOk) then {* Credit Check *}
      With ExLocal do
      Begin

        AssignFromGlobal(NomF);

      end;


      If (FoundOk) then
      Begin

        Text:=Form_Int(FoundLong,0);

        If (Sender=SBankGLF) then
          SRCGLLab.Caption:=Nom.Desc
        else
          PPYGLLab.Caption:=Nom.Desc;

      end
      else
      Begin

        SetFocus;
      end; {If not found..}
    end;


  end; {with..}
end;



procedure TPwordList2.PWEDaysFExit(Sender: TObject);
Var
  FoundCode  :  Str20;

  FoundOk,
  AltMod     :  Boolean;

  FoundLong  :  LongInt;


begin

  If (Sender is TCurrencyEdit) then
  With (Sender as TCurrencyEdit) do
  Begin
    AltMod:=FloatModified;

    If (((AltMod) and (Value<>0.0)) or (PWExDateF.DateValue<Today)) and (ActiveControl<>CanCP1Btn) and (ExLocal.InAddEdit) then
    Begin
      PWExDateF.DateValue:=CalcDueDate(Today,Round(Value));

    end;
  end;

end;


Procedure TPwordList2.SetFieldFocus;

Begin
  SCodeF.SetFocus;

end; {Proc..}

{ ============== Display PW Properties Record ============ }

Procedure TPwordList2.OutUP;
Var
  FoundOk   :  Boolean;
  FoundInt  :  LongInt;
  KeyS      :  Str255;
  FoundCode :  Str20;
Begin
  With ExLocal,LPassWord.PassEntryRec do
  Begin
    SCodeF.Text:=Strip('R',[#32],Login);

    ChangeCryptoKey (23130);
    DescF.Text:=LJVar(Decode(PWord),PWKeyLen);

    With EntryDefaults2 do
    Begin
      If (PWExpMode In [0..2]) then
        PWModeCBF.ItemIndex:=PWExpMode
      else
        PWModeCBF.ItemIndex:=0;

      //TW 15/08/2011 - Added checkbox for show gl code user defaults
      TBorCh_ShowGLCode.Checked := ShowGLCodes;

      // CA  05/06/2012   v7.0  ABSEXCH-12452: - Added two Checkboxes for the Stock Tree - Type and Code Options
      {$IFDEF STK}
         TBorCh_ShowStockCode.Checked   := ShowStockCode;
         TBorCh_ShowProductType.Checked := ShowProductType;
      {$ENDIF}

      FullNameF.Text:=UserName;
      PWEDaysF.Value:=PWExpDays;
      PWALogF.Value:=PWTimeOut;
      PWExDateF.DateValue:=PWExpDate;

      DSRIF.Text:=Trim(DirCust);
      DPPIF.Text:=Trim(DirSupp);

      MaxSAF.Value:=MaxSalesA;
      MaxPAF.Value:=MaxPurchA;

      CCF.Text:=Trim(CCDep[BOn]);
      DepF.Text:=Trim(CCDep[BOff]);

      If (CCDepRule In [0..3]) then
        CCDRulesCB.ITemIndex:=CCDepRule
      else
        CCDRulesCB.ITemIndex:=0;

      {$IFDEF SOP}
        LocF.Text:=Trim(Loc);

        If (LocRule In [0..3]) then
          LocRulesCB.ItemIndex:=LocRule
        else
          LocRulesCB.ItemIndex:=0;
      {$ENDIF}

      SBankGLF.Text:=Form_BInt(SalesBank,0);

      If (SalesBank<>0) then
      Begin
        If GetNom(Self,SBankGLF.Text,FoundInt,-1) then
          SRCGlLab.Caption:=Nom.Desc;
      end;

      PBankGLF.Text:=Form_BInt(PurchBank,0);

      if (PurchBank<>0) then
      begin
        If GetNom(Self,PBankGLF.Text,FoundInt,-1) then
          PPYGlLab.Caption:=Nom.Desc;
      end;

      {$IFDEF Frm}
        pfSet_NDPDefaultPrinter(DefRPrn,ReportPrn,2);

        If (DefRPrn.ItemIndex<0) then
          DefRPrn.ItemIndex:=0;

        If (ReportPrn<>'') then
          DefRPrn.Text:=ReportPrn;

        pfSet_NDPDefaultPrinter(DefFPrn,FormPrn,2);

        If (DefFPrn.ItemIndex<0) then
          DefFPrn.ItemIndex:=0;

        If (FormPrn<>'') then
          DefFPrn.Text:=FormPrn;
      {$ENDIF}
      pwEmlF.Text:=emailAddr;
    end; {With EntryDefaults 2}
  end;
end;


procedure TPwordList2.Form2Id;
Begin
  With EXLocal,LPassWord.PassEntryRec do
  Begin
    Login := LJVar(SCodeF.Text,LoginKeyLen);
    ChangeCryptoKey (23130);
    PWord := EnCode(Trim(DescF.Text));

    With EntryDefaults2 do
    Begin
      If (PWModeCBF.ItemIndex In [0..2]) then
        PWExpMode := PWModeCBF.ItemIndex
      else
        PWExpMode := 0;

      UserName := FullNameF.Text;
      PWExpDays := Round(PWEDaysF.Value);
      PWExpDate := PWExDateF.DateValue;
      PWTimeOut := Round(PWALogF.Value);

      //TW 15/08/2011 - Added checkbox for show gl code user defaults
      ShowGLCodes := TBorCh_ShowGLCode.Checked;

      // CA  05/06/2012   v7.0  ABSEXCH-12452: - Added two Checkboxes for the Stock Tree - Type and Code Options
      {$IFDEF STK}
         ShowStockCode    := TBorCh_ShowStockCode.Checked;
         ShowProductType  := TBorCh_ShowProductType.Checked;
      {$ENDIF}

      If (DSRIF.Text <> '') then
        DirCust := FullCustCode(DSRIF.Text)
      else
        Blank(DirCust,Sizeof(DirCust));

      If (DPPIF.Text <> '') then
        DirSupp := FullCustCode(DPPIF.Text)
      else
        Blank(DirSupp,Sizeof(DirSupp));

      MaxSalesA := MaxSAF.Value;
      MaxPurchA := MaxPAF.Value;

      If (CCF.Text <> '') then
        CCDep[BOn] := FullCCDepKey(CCF.Text)
      else
        Blank(CCDep[BOn],Sizeof(CCDep[BOn]));

      If (DepF.Text <> '') then
        CCDep[BOff] := FullCCDepKey(DepF.Text)
      else
        Blank(CCDep[BOff],Sizeof(CCDep[BOff]));

      If (CCDRulesCB.ITemIndex In [0..3]) then
        CCDepRule := CCDRulesCB.ITemIndex
      else
        CCDepRule := 0;

      {$IFDEF SOP}
        If (LocF.Text <> '') then
          Loc := LocF.Text
        else
          Blank(Loc,Sizeof(Loc));

        If (LocRulesCB.ItemIndex In [0..3]) then
          LocRule := LocRulesCB.ItemIndex
        else
          LocRule := 0;
      {$ENDIF}

      If (SBankGLF.Text <> '') then
        SalesBank := StrToInt(Trim(SBankGLF.Text))
      else
        SalesBank := 0;

      If (PBankGLF.Text <> '') then
        PurchBank := StrToInt(Trim(PBankGLF.Text))
      else
        PurchBank := 0;

      If (DefRPrn.Text <> '') then
        ReportPrn := Copy(        DefRPrn.Text,1,50)
      else
        Blank(ReportPRN,Sizeof(ReportPRN));

      If (DefFPrn.Text <> '') then
        FormPrn := Copy(DefFPrn.Text,1,50)
      else
        Blank(FormPRN,Sizeof(FormPRN));

      emailAddr := pwEmlF.Text;
    end; {With EntryDefaults 2}
  end; {with..}
end; {Proc..}


Procedure TPwordList2.Show_UserProps;

Var
  n  :  Smallint;

Begin
  With ExLocal do
  If (Not InAddEdit) then
  Begin
    AssignFromGlobal(PwrdF);

    EntryDefaults2:=Link_PWDefaults(LPassWord.PassEntryRec.Login,n);


    OutUP;
  end; {With..}
end; {Proc..}


(*  Add is used to add Notes *)

procedure TPwordList2.ProcessId(Fnum,
                                Keypath     :  Integer;
                                Edit        :  Boolean);

Var
  KeyS  :  Str255;


Begin

  Addch:=ResetKey;

  KeyS:='';

  ExLocal.InAddEdit:=BOn;

  ExLocal.LastEdit:=Edit;

  SKeypath:=Keypath;

  If (Edit) then
  Begin
    OutUP;

    With ExLocal do
    Begin
      LGetRecAddr(Fnum);

      If (Not LViewOnly) then
        Ok:=LGetMultiRec(B_GetDirect,B_MultLock,KeyS,KeyPAth,Fnum,BOff,GlobLocked)
      else
        Ok:=BOn;

    end;

    If (Not Ok) or (Not GlobLocked) then
      AddCh:=Esc;
  end;
  

  If (Addch<>Esc) then
  With ExLocal,LPassWord,PassEntryRec do
  begin

    If (Not Edit) then
    Begin
      Sel_User:=Login;

      If (Not CopyMode) then
      Begin
        LResetRec(Fnum);
        FillChar(EntryRec^.Access,Sizeof(EntryRec^.Access),0);
        FillChar(EntryDefaults2,Sizeof(EntryDefaults2),#0);


      end;

      If (SysMMode) then
      Begin
        FillChar(LPassword.PassEntryRec.Access,Sizeof(LPassword.PassEntryRec.Access),1);
        FillChar(EntryRec^.Access,Sizeof(EntryRec^.Access),1);
        {$IFDEF LTE}
          EntryRec^.Access[572]:=0;
        {$ENDIF}
      end;

      Blank(EntryRec^.Login,sizeof(EntryRec^.Login));

      RecPfix:=PassUCode;

    end;

    LastPassWord:=LPassWord;

    OutUP;

    SetPWStore(BOn,BOff);

    SetFieldFocus;

  end {If Abort..}

end; {Proc..}


procedure TPwordList2.EditLine(Edit       :  Boolean;
                               MMode      :  Byte);


begin
  With ExLocal do
  Begin
    IdStored:=BOff;

    AssignFromGlobal(PWrdF);

    LastEdit:=Edit;

    CopyMode:=(MMode=5);
    SysMMode:=(MMode=4);

    ProcessId(PWrdF,PWK,LastEdit);
  end;
end;


{ ======== Procedure to clear all position records ========= }

Procedure TPwordList2.Delete_PosRecs(DelCode  :  Str20);

Const
  Fnum     =  MiscF;
  Keypath  =  MiscNDXK;

Var
  Mbret  :  Word;

  KeyS,
  KeyChk :  Str255;

  B_Func :  Integer;

  LOk,
  LLocked
         :  Boolean;

Begin
{$IFDEF EXSQL}
  if SQLUtils.UsingSQLAlternateFuncs then
  begin
    Status := SQLFuncs.ResetCustomSettings(SetDrive, DelCode);
    if (Status = 0) then
      MessageDlg('Custom settings deleted', mtInformation, [mbOk], 0)
    else
      MessageDlg('Failed to delete custom settings, error #' + IntToStr(Status),
                 mtError, [mbOk], 0);
  end
  else
{$ENDIF}  
  begin
    KeyChk:=PartCCKey(btCustTCode,btCustSCode);

    KeyChk:=KeyChk+DelCode;

    KeyS:=KeyChk;

    With ExLocal do
    Begin
      Status:=Find_Rec(B_GetGEq,F[Fnum],Fnum,LRecPtr[Fnum]^,KeyPath,KeyS);

      While (StatusOk) and (CheckKey(KeyChk,KeyS,Length(KeyChk),BOn)) do
      Begin

        LOk:=LGetMultiRec(B_GetDirect,B_MultLock,KeyS,KeyPath,Fnum,BOn,LLocked);

        If (LOk) and (LLocked) then
        Begin

          Status:=Delete_Rec(F[Fnum],Fnum,KeyPath);

          Report_BError(Fnum,Status);

          If (StatusOk) then
            B_Func:=B_GetGEq
          else
            B_Func:=B_GetNext;

        end
        else
          B_Func:=B_GetNext;

        Status:=Find_Rec(B_Func,F[Fnum],Fnum,LRecPtr[Fnum]^,KeyPath,KeyS);

      end; {While..}

    end; {With..}
  end;
end;



{ ======== Procedure to clear all position records ========= }

Procedure TPwordList2.Copy_PosRecs(OldCode,
                                   NewCode   :  Str20);

Const
  Fnum     =  MiscF;
  Keypath  =  MiscNDXK;

Var
  Mbret  :  Word;

  KeyS,
  KeyChk :  Str255;

  B_Func :  Integer;

  LOk,
  LLocked
         :  Boolean;

Begin

  KeyChk:=PartCCKey(btCustTCode,btCustSCode);

  KeyChk:=KeyChk+OldCode;

  KeyS:=KeyChk;

  With ExLocal do
  Begin
    Status:=Find_Rec(B_GetGEq,F[Fnum],Fnum,LRecPtr[Fnum]^,KeyPath,KeyS);

    While (StatusOk) and (CheckKey(KeyChk,KeyS,Length(KeyChk),BOn)) do
    With LMiscRecs^.btCustomRec do
    Begin
      LGetRecAddr(Fnum);

      UserName:=NewCode;

      CustomKey:=FullCompoKey(CompName,UserName);
      UserKey:=FullCompoKey(UserName,CompName);

      Status:=Add_Rec(F[Fnum],Fnum,LRecPtr[Fnum]^,KeyPAth);

      Report_BError(Fnum,Status);

      Status:=LGetDirectRec(Fnum,Keypath);

      Status:=Find_Rec(B_GetNext,F[Fnum],Fnum,LRecPtr[Fnum]^,KeyPath,KeyS);

    end; {While..}

  end; {With..}
end;



{ ======== Procedure to clear all position records ========= }

Procedure TPwordList2.ReName_PosRecs(OldCode,
                                     NewCode   :  Str20);

Const
  Fnum     =  MiscF;
  Keypath  =  MiscNDXK;

Var
  Mbret  :  Word;

  KeyS,
  KeyChk :  Str255;

  B_Func :  Integer;

  LOk,
  LLocked
         :  Boolean;

Begin

  KeyChk:=PartCCKey(btCustTCode,btCustSCode);

  KeyChk:=KeyChk+OldCode;

  KeyS:=KeyChk;

  With ExLocal do
  Begin
    Status:=Find_Rec(B_GetGEq,F[Fnum],Fnum,LRecPtr[Fnum]^,KeyPath,KeyS);

    While (StatusOk) and (CheckKey(KeyChk,KeyS,Length(KeyChk),BOn)) do
    With LMiscRecs^.btCustomRec do
    Begin
      LGetRecAddr(Fnum);

      UserName:=NewCode;

      CustomKey:=FullCompoKey(CompName,UserName);
      UserKey:=FullCompoKey(UserName,CompName);

      Status:=Put_Rec(F[Fnum],Fnum,LRecPtr[Fnum]^,KeyPAth);

      Report_BError(Fnum,Status);

      Status:=LGetDirectRec(Fnum,Keypath);

      Status:=Find_Rec(B_GetGEq,F[Fnum],Fnum,LRecPtr[Fnum]^,KeyPath,KeyS);

    end; {While..}

  end; {With..}
end;


{ ======== Procedure to clear all position records ========= }

Function TPwordList2.Link_PWDefaults(PLogin  :  Str10;
                                 Var NewRec  :  SmallInt)  :  tPassDefType;

Const
  Fnum     =  MLocF;
  Keypath  =  MLK;

Var
  Mbret  :  Word;

  KeyS,
  KeyChk :  Str255;

  B_Func :  Integer;

  LOk,
  LLocked
         :  Boolean;

Begin
  Blank(Result,Sizeof(Result));

  KeyChk:=FullPWordKey(PassUCode,'D',PLogin);

  KeyS:=KeyChk;

  With ExLocal do
  Begin
    Status:=Find_Rec(B_GetEq,F[Fnum],Fnum,LRecPtr[Fnum]^,KeyPath,KeyS);

    NewRec:=Status;

    If (StatusOk) then
    begin
      Result:=LMLocCtrl^.PassDefRec;

      {$IFDEF LTE}
        Result.PWExpMode:=0;
      {$ENDIF}
    end;
  end; {With..}
end;


Procedure TPwordList2.Store_PWDefaults(PLogin,
                                       NewCode  :  Str10;
                                       RenMode  :  Boolean);

Const
  Fnum     =  MLocF;
  Keypath  =  MLK;

Var
  Mbret  :  SmallInt;

  KeyS,
  KeyChk :  Str255;

  B_Func :  Integer;

  GetPWDef
         :  tPassDefType;


  NewRec,
  OldRec,
  LOk,
  LLocked
         :  Boolean;

Begin
  If (RenMode) then
    Link_PWDefaults(PLogin,MbRet)
  else
    Link_PWDefaults(NewCode,MbRet);


  NewRec:=(mbRet=4);
  OldRec:=(mbRet=0);


  If (NewRec or OldRec) then
  With ExLocal,LMLocCtrl^ do
  Begin
    RecPfix:=PassUCode;

    SubType:='D';

    PassDefRec:=EntryDefaults2;

    PassDefRec.Login:=NewCode;

    If (OldRec) then
      Status:=Put_Rec(F[Fnum],Fnum,LRecPtr[Fnum]^,KeyPAth)
    else
      Status:=Add_Rec(F[Fnum],Fnum,LRecPtr[Fnum]^,KeyPAth);

    Report_BError(Fnum,Status);

    LastValueObj.UpdateAllLastValuesFull(Self);

    If (StatusOk) then
    Begin
      
      If (EntryDefaults2.Login=UserProfile^.Login) then {* Show effect immedieatley *}
      Begin
        UserProfile^:=EntryDefaults2;
        GetLocalPr(1); {Synchronise local with global}
      end;

    end;

  end {With..}
  else
  Begin
    Report_BError(Fnum,mbRet);

  end;
end;



Procedure TPwordList2.Delete_PWDefaults(PLogin  :  Str10);

Const
  Fnum     =  MLocF;
  Keypath  =  MLK;

Var
  Mbret  :  SmallInt;

  KeyS,
  KeyChk :  Str255;

  B_Func :  Integer;

  GetPWDef
         :  tPassDefType;


  OldRec,
  LOk,
  LLocked
         :  Boolean;

Begin
  Link_PWDefaults(PLogin,MbRet);


  OldRec:=(mbRet=0);


  If (OldRec) then
  With ExLocal,LMLocCtrl^ do
  Begin
    Status:=Delete_Rec(F[Fnum],Fnum,KeyPath);

    Report_BError(Fnum,Status);


  end; {With..}
end;




Procedure TPwordList2.ChangePage(NewPage  :  Integer);


Begin

  If (Current_Page<>NewPage) then
  With PageControl1 do
  If (Pages[NewPage].TabVisible) then
  Begin
    ActivePage:=Pages[NewPage];

    PageControl1Change(PageControl1);


  end; {With..}
end; {Proc..}


Function TPwordList2.CheckNeedStore  :  Boolean;

Var
  Loop  :  Integer;

Begin
  Result:=BOff;
  Loop:=0;

  While (Loop<=Pred(ComponentCount)) and (Not Result) do
  Begin
    If (Components[Loop] is TMaskEdit) then
    With (Components[Loop] as TMaskEdit) do
    Begin
      Result:=((Tag=1) and (Modified));

      If (Result) then
        Modified:=BOff;
    end
    else
      If (Components[Loop] is TCurrencyEdit) then
      With (Components[Loop] as TCurrencyEdit) do
      Begin
        Result:=((Tag=1) and (FloatModified));

        If (Result) then
          FloatModified:=BOff;
      end
      else
        If (Components[Loop] is TBorCheck) then
        With (Components[Loop] as TBorCheck) do
        Begin
          Result:=((Tag=1) and (Modified));

          If (Result) then
            Modified:=BOff;
        end
        else
          If (Components[Loop] is TSBSComboBox) then
          With (Components[Loop] as TSBSComboBox) do
          Begin
            Result:=((Tag=1) and (Modified));

            If (Result) then
              Modified:=BOff;
          end;

    Inc(Loop);
  end; {While..}
end;


Function TPwordList2.ConfirmQuit  :  Boolean;

Var
  MbRet  :  Word;
  TmpBo  :  Boolean;

Begin

  TmpBo:=BOff;

  If (ExLocal.InAddEdit) and (CheckNeedStore) and (Not ExLocal.LViewOnly) and (Not IdStored) then
  Begin

    mbRet:=MessageDlg('Save changes to user record '+SCodeF.Text+'?',mtConfirmation,[mbYes,mbNo,mbCancel],0);
  end
  else
    mbRet:=mrNo;

  Case MbRet of

    mrYes  :  Begin
                StoreId(PwrdF,SKeyPath);
                TmpBo:=(Not ExLocal.InAddEdit);
              end;

    mrNo   :  With ExLocal do
              Begin
                If (LastEdit) and (Not LViewOnly) and (Not IdStored) then
                  Status:=UnLockMLock(PwrdF,LastRecAddr[PWrdF]);

                If (InAddEdit) then
                Begin
                  SetPWStore(BOff,LastEdit);
                                  end;


                TmpBo:=BOn;
              end;

    mrCancel
           :  Begin
                TmpBo:=BOff;
                SetfieldFocus;
              end;
  end; {Case..}


  ConfirmQuit:=TmpBo;
end; {Func..}


Function TPwordList2.CheckCompleted(Edit,MainChk  :  Boolean)  : Boolean;

Const
  NofMsgs      =  8;
  Fnum         =  StockF;
  Keypath      =  StkFolioK;


Type
  PossMsgType  = Array[1..NofMsgs] of Str80;

Var
  PossMsg  :  ^PossMsgType;

  ExtraMsg :  Str80;

  KeyS     :  Str255;

  Test     :  Byte;

  Foundcode1
           :  Str10;
  FoundCode:  Str20;

  FoundLong:  LongInt;

  Loop,
  ShowMsg  :  Boolean;

  mbRet    :  Word;


Begin
  New(PossMsg);
  ShowMsg := False;

  FillChar(PossMsg^,Sizeof(PossMsg^),0);

  PossMsg^[1]:='That User Name is not valid.';
  PossMsg^[2]:='That Direct Customer is not valid.';
  PossMsg^[3]:='That Direct Supplier is not valid.';
  PossMsg^[4]:='The Location is not valid.';
  PossMsg^[5]:='The Sales General Ledger Code is not valid.';
  PossMsg^[6]:='The Purchase General Ledger Code is not valid.';
  PossMsg^[7]:='The default Department Code is not valid.';
  PossMsg^[8]:='The default Cost Centre Code is not valid.';



  Loop:=BOff;

  Test:=1;

  Result:=BOn;


  While (Test<=NofMsgs) and (Result) do
  With EntryDefaults2, ExLocal,LPassWord.PassEntryRec do
  Begin
    ExtraMsg:='';

    ShowMsg:=BOn;

    Case Test of

      1  :  Begin

              Result:=Not EmptyKey(Login,LoginKeyLen);

            end;

      2  :  Begin
              {$B-}
                Result:=(EmptyKey(DirCust,CustKeyLen)) or CheckExsists(DirCust,CustF,CustCodeK);

              {$B+}
            end;
      3  :  Begin
              {$B-}
                Result:=(EmptyKey(DirSupp,CustKeyLen)) or CheckExsists(DirSupp,CustF,CustCodeK);

              {$B+}
            end;

      {$IFDEF SOP}
        4  :  Begin
              {$B-}
                Result:=(EmptyKey(Loc,MLocKeyLen)) or GetMLoc(Self,Loc,FoundCode1,'',-1);

              {$B+}
              end;


      {$ENDIF}

      5    :  Begin
              {$B-}
                Result:=(SalesBank=0) or GetNom(Self,Form_Int(SalesBank,0),FoundLong,-1);

              {$B+}
            end;

      6    :  Begin
              {$B-}
                Result:=(PurchBank=0) or GetNom(Self,Form_Int(PurchBank,0),FoundLong,-1);

              {$B+}
            end;


      7,8  :  Begin
                Result:=(EmptyKeyS(CCDep[(Test=8)],CCKeyLen,BOff) or (Not Syss.UseCCDep) or GetCCDep(Self,CCDep[(Test=8)],FoundCode,(Test=8),-1));
              end;




    end;{Case..}

    If (Result) then
      Inc(Test);

  end; {While..}

  If (Not Result) and (ShowMsg) and (Not MainChk) then
    mbRet:=MessageDlg(ExtraMsg+PossMsg^[Test],mtWarning,[mbOk],0);

  Dispose(PossMsg);

end; {Func..}



procedure TPwordList2.StoreId(Fnum,
                              Keypath  :  Integer);

Var
  n    :  Byte;

  COk,
  ReCode
       :  Boolean;
  TmpPWrd
       :  PassWordRec;

  KeyS :  Str255;

  mbRet:  Word;




Begin
  KeyS:='';

  Form2Id;

  Recode:=BOff;

  With ExLocal,LPassWord,PassEntryRec do
  Begin
    If (LastEdit) and (LastPassword.PassEntryRec.Login<>Login) then
    Begin
      COk:=(Not Check4DupliGen(FullPWordKey(RecPfix,SubType,PassEntryRec.Login),Fnum,Keypath,'User Name'));

      ReCode:=COk;
    end
    else
      COk:=BOn;


    If (COk) then
      COk:=CheckCompleted(LastEdit,BOff);



    If (COk) then
    Begin
      Cursor:=CrHourGlass;

      If (LastEdit) then
      Begin

        If (LastRecAddr[Fnum]<>0) then  {* Re-establish position prior to storing *}
        Begin

          TmpPWrd:=LPassWord;

          LSetDataRecOfs(Fnum,LastRecAddr[Fnum]);

          Status:=GetDirect(F[Fnum],Fnum,LRecPtr[Fnum]^,KeyPAth,0); {* Re-Establish Position *}

          LPassWord:=TmpPWrd;

        end;

        Status:=Put_Rec(F[Fnum],Fnum,LRecPtr[Fnum]^,KeyPAth);

      end
      else
      Begin

        Status:=Add_Rec(F[Fnum],Fnum,LRecPtr[Fnum]^,KeyPAth);

      end;

      Report_BError(Fnum,Status);

      If (StatusOk) then
        {* Store the Default page *}

        Store_PWDefaults(LastPassword.PassEntryRec.Login,Login,ReCode);


      Cursor:=CrDefault;

      InAddEdit:=BOff;

      If (LastEdit) then
        ExLocal.UnLockMLock(Fnum,LastRecAddr[Fnum]);

      If (Not LastEdit) and (CopyMode) then
        Copy_PosRecs(Sel_User,Login);

      
      IdStored:=BOn;

      SendMessage(Self.Handle,WM_custGetRec,116,Ord(LastEdit));

      If (LastEdit) and (ReCode) then {Recode the pos & Second page}
      Begin
        For n:=1 to 3 do
          RenameEntryRec(n,LastPassword.PassEntryRec.Login,Login);

        ReName_PosRecs(LastPassword.PassEntryRec.Login,Login);

      end;




      SetPWStore(BOff,LastEdit);

      Cursor:=CrDefault;

      If (HideDAdd) then
      Begin
        HideDAdd:=BOff;
        BuildDesign;
      end;

    end
    else
      SetFieldFocus;

  end; {With..}


end;




procedure TPwordList2.CanCP1BtnClick(Sender: TObject);
begin
  If (Sender is TButton) then
    With (Sender as TButton) do
    Begin
      If (ModalResult=mrOk) and (Assigned(MULCtrlO)) then
      Begin
        // MH 22/12/2010 v6.6 ABSEXCH-10548: Set focus to OK button to trigger OnExit event on date and Period/Year
        //                                   fields which processes the text and updates the value
        If (ActiveControl <> OkCP1Btn) Then
          // Move focus to OK button to force any OnExit validation to occur
          OkCP1Btn.SetFocus;

        // If focus isn't on the OK button then that implies a validation error so the store should be abandoned
        If (ActiveControl = OkCP1Btn) Then
          Case Current_Page of
            0  :  StoreId(PWrdF,MULCtrlO.Keypath);
            2  :  Begin
                    StoreSigs(BOn);
                  end;
          end; {Case..}
      end
      else
        If (ModalResult=mrCancel) then
        Begin
          Case Current_Page of
            0  :  If (ConfirmQuit) then
                  With ExLocal do
                  Begin

                    LPassWord:=LastPassWord;

                    OutUP;

                    NLOLine.Refresh;

                  end;
            2  :  Begin
                    StoreSigs(BOff);
                  end;
          end; {Case..}
        end;
    end; {With..}
end;





procedure TPwordList2.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  GlobFormKeyDown(Sender,Key,Shift,ActiveControl,Handle);
end;

procedure TPwordList2.FormKeyPress(Sender: TObject; var Key: Char);
begin
  GlobFormKeyPress(Sender,Key,ActiveControl,Handle);
end;


procedure TPwordList2.DeleteBOMLine(Fnum,
                                    KeyPath  :  Integer);

Var
  MbRet  :  Word;
  GotRec :  Integer;
  KeyS   :  Str255;

Begin
  With ExLocal do
  Begin
    AssignFromGlobal(Fnum);
    LGetRecAddr(Fnum);
    OutUP;
    OKCP1Btn.Enabled:=BOff;
    CanCP1Btn.Enabled:=BOff;

    MbRet:=MessageDlg('Please confirm you wish'#13+'to delete this record',
                       mtConfirmation,[mbYes,mbNo],0);

    If (MbRet=MrYes) then
    Begin
      Status:=LGetDirectRec(Fnum,KeyPath);


      If (StatusOk) then
      Begin

        Ok:=LGetMultiRec(B_GetDirect,B_MultLock,KeyS,KeyPath,Fnum,BOn,GlobLocked);

        If (Ok) and (GlobLocked) then
        Begin

          Status:=Delete_Rec(F[Fnum],Fnum,KeyPath);

          Report_BError(Fnum,Status);
        end;

        If (StatusOk) then
        Begin

          Delete_PosRecs(LPassWord.PassEntryRec.Login);


          { == Delete any additional pages == }

          KeyS:=FullPWordKey(PassUCode,Chr(1),LPassWord.PassEntryRec.Login);

          Status:=Find_Rec(B_GetEq,F[Fnum],Fnum,LRecPtr[Fnum]^,KeyPath,KeyS);

          If (StatusOk) then
          Begin
            Status:=Delete_Rec(F[Fnum],Fnum,KeyPath);

            Report_BError(Fnum,Status);
          end;

          {== Delete defaults page ==}

          Delete_PWDefaults(LPassWord.PassEntryRec.Login);



          SendMessage(Self.Handle,WM_CustGetRec,117,0);


        end;
      end; {If line is valid for deletion..}
    end
    else
      Report_BError(Fnum,Status);
  end; {With..}
end; {PRoc..}



procedure TPwordList2.DeleteCustomPos;

Var
  MbRet  :  Word;
  GotRec :  Integer;
  KeyS   :  Str255;
  oSettings : IWindowSettings;

Begin
  With ExLocal do
  Begin
    AssignFromGlobal(PWrdF);
    OutUP;
    OKCP1Btn.Enabled:=BOff;
    CanCP1Btn.Enabled:=BOff;

    MbRet:=MessageDlg('Please confirm you wish'#13+'to reset all custom settings for this user.',
                       mtConfirmation,[mbYes,mbNo],0);

    If (MbRet=MrYes) then
    Begin

      oSettings := GetWindowSettings('');
      if Assigned(oSettings) then
      Try
        oSettings.DeleteAllSettingsForUser;
      Finally
        oSettings := nil;
      End;
      Delete_PosRecs(LPassWord.PassEntryRec.Login);

    end;
  end; {With..}

end; {PRoc..}


Procedure TPwordList2.LoadText (Const Idx : Byte; FName1, FName2 : ShortString; TheMemo : TMemo);

Const
  PathMaster = 'DOCMASTR\';

Begin { LoadText }
  FName1 := SetDrive + PathMaster + FName1;

  // Take copy of filename for later save operation
  FFiles[Idx] := FName1;

  If Not FileExists (FName1) Then
    FName1 := SetDrive + PathMaster + FName2;

  If FileExists (FName1) Then Begin
    // Load Text
    TheMemo.Lines.LoadFromFile (FName1);
  End { If FileExists (FName) }
  Else
    TheMemo.Clear;
End; { LoadText }


// Load signatures
procedure TPwordList2.LoadUserSig(Mode  :  Byte);
Var
  UCode : String[8];
begin
  If (Mode=1) Then
  Begin
    // Load Company Defaults
    LoadText (1, 'COMPANY.TXT', 'COMPANY.TXT', memEmailSig);
    LoadText (2, 'COMPANY.TX2', 'COMPANY.TX2', memFaxSig);

    FindBtn.Caption:='&User Sig';

    EmailUserLab.Caption:='For the default Company signature';
    FaxUserLab.Caption:='For the default Company signature';

  End { If (lstUsers.ItemIndex = 0) }
  Else
  Begin
    // Extract User Code from list and load text files
    UCode := Uppercase(Trim(Copy (SCodeF.Text, 1, 8)));
    LoadText (1, UCode + '.TXT', 'COMPANY.TXT', memEmailSig);
    LoadText (2, UCode + '.TX2', 'COMPANY.TX2', memFaxSig);

    If (Mode<>3) then
      FindBtn.Caption:='&Company Sig';

    EmailUserLab.Caption:='For user '+UCode;
    FaxUserLab.Caption:='For user '+UCode;

  End; { Else }

  Find1.Caption:=FindBtn.Caption;

end;

procedure TPwordList2.StoreSigs(EditMode  :  Boolean);

Begin
  // Save
  If (EditMode) then
  Begin
    memFaxSig.ReadOnly := True;
    memFaxSig.Lines.SaveToFile (FFiles[2]);

    memEmailSig.ReadOnly := True;
    memEmailSig.Lines.SaveToFile (FFiles[1]);

  End { Else }
  else
  Begin
    memFaxSig.ReadOnly := True;
    memEmailSig.ReadOnly := True;
  end;

  OkCP1Btn.Enabled:=BOff;
  CanCP1Btn.Enabled:=BOff;
  EditBtn.Enabled:=BOn;
end; {Proc..}


procedure TPwordList2.PrintSettings;

Var
  GrpAry,
  LastIdx  :  LongInt;
  Effect   :  Byte;

  PNo,n    :  SmallInt;
  LineWord,
  LineText,
  SendLine :  Str255;
  {$IFDEF FRM}
    PrnInfo  : TSBSPrintSetupInfo;
  {$ENDIF}  

Begin
  If (Not Assigned(PrintJob)) then
    PrintJob:=TStringList.Create;

  Try
   PrintJob.Clear;

   Prime_TreeGroups;

   For n:=0 to 3 do {* Get any password settings + additional page settings *}
     SetEntryRecVar(n,PassWord.PassEntryRec.Login,(n>0),BOn,EntryRec2);

   
   
   GrpAry:=1;  LineWord:='';

   While (GrpAry<=High(PWTreeGrpAry)) do
   With PWTreeGrpAry[GrpAry] do
   If (Not Exclude) and (tCaption<>'') then {* Exclude for modules sensitive, + deliberrate gaps for other groups *}
   Begin
     With PrintJob do
     Begin
       Effect:=2-IsChild;
       If (Effect<1) then
         Effect:=1;

       PrintJob.Add('');
       
       Add(Chr(Effect)+#9+tCaption);

       If (WordCnt(PWLink)>0) then
       Begin
         For n:=1 to WordCnt(PWLink) do
         Begin
           LineWord:=ExtractWords(n,1,PWLink);

           If (LineWord<>'X') then
           Begin
             LineText:=GetPWText(LineWord,PNo);

             If (LineText='XNANX') then
               LineText:='Password Missing!';

             SendLine:=YesNoBo((EntryRec2.Access[Pno]<>0))+#9+LineText+' ('+LineWord+')';

             If (EntryRec2.Access[Pno]<>0) then
               SendLine:=#0+SendLine;

             Add(SendLine);
           end;
         end; {Loop..}
       end;

       Inc(GrpAry);
     end; {With..}

   end {While..}
   else
     Inc(GrpAry);


   LoadUserSig(3);

   PrintJob.Add('');
   PrintJob.Add(#1+#9+'Email Signature Settings');

   With memEmailSig do
     For n:=0 to Pred(Lines.Count) do
       PrintJob.Add(#9+memEmailSig.Lines[n]);

   {$IFNDEF LTE}
     PrintJob.Add('');
     PrintJob.Add(#1+#9+'Fax Signature Settings');
   {$ENDIF}

   With memFaxSig do
     For n:=0 to Pred(Lines.Count) do
       PrintJob.Add(#9+memFaxSig.Lines[n]);


   LineText:='Password Access Listing For User '+dbFormatName(SCodeF.Text,FullNameF.Text);

   {$IFDEF RP}
     {$IFDEF FRM}
       AddMemoRep2ThreadMode(PrnInfo,PrintJob,LineText,Application.MainForm,1);
     {$ENDIF}
   {$ENDIF}

  except;
    PrintJob.Free;
    PrintJob:=Nil;
  end;


end;

procedure TPwordList2.PrintBtnClick(Sender: TObject);
begin
  If (Not MULCtrlO.InListFind) then
    PrintSettings;
end;

// NF: 16/05/06 Fix for incorrect Context IDs
procedure TPwordList2.SetHelpContextIDsForPage;
const
  TAB_PROPERTIES = 0;
  TAB_ACCESS = 1;
  TAB_SIGNATURES = 2;
begin
  FindBtn.HelpContext := 1769;
  btnExpand.HelpContext := 1770;
  btnCollapse.HelpContext := 1771;
  SetYesBtn.HelpContext := 1772;
  SetNoBtn.HelpContext := 1773;

  case PageControl1.ActivePage.PageIndex of
    TAB_PROPERTIES : EditBtn.HelpContext := 397;
    TAB_SIGNATURES : begin
      EditBtn.HelpContext := 1774;
      FindBtn.HelpContext := 2087; // NF: 25/07/06
    end;
  end;{case}
end;

{--------------------------}
end.
