unit Repdet;

{ prutherford440 14:10 30/10/2001: Disabled Byte Alignment in Delphi 6.0 }
{$ALIGN 1}  { Variable Alignment Disabled }


{$I DEFOVR.Inc}

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ExtCtrls, SBSPanel, ComCtrls,
  GlobVar,VarConst,SBSComp,SBSComp2,BTSupU1,ExWrap1U,SupListU, Menus,
  TEditVal, BorBtns, Mask, RwOpenF, RepLine, RepInp, RepNot, RepNom;

type
  TMAMList  =  Class(TGenList )
    Function SetCheckKey  :  Str255; Override;
    Function SetFilter  :  Str255; Override;
    Function Ok2Del :  Boolean; Override;
    Function OutLine(Col  :  Byte)  :  Str255; Override;
  end;

  TReportRec = class(TForm)
    PageControl1: TPageControl;
    PnlButt: TPanel;
    TabSheet1: TTabSheet;
    TabSheet2: TTabSheet;
    MListBtnPanel: TSBSPanel;
    TabSheet3: TTabSheet;
    TabSheet4: TTabSheet;
    TabSheet5: TTabSheet;
    MSBox: TScrollBox;
    MHedPanel: TSBSPanel;
    RRefLab: TSBSPanel;
    RDescLab: TSBSPanel;
    RLenLab: TSBSPanel;
    RPrnLab: TSBSPanel;
    RRefPanel: TSBSPanel;
    RDescPanel: TSBSPanel;
    RLenPanel: TSBSPanel;
    RPrnPanel: TSBSPanel;
    ScrlHed: TScrollBox;
    SBSGroup1: TSBSGroup;
    Label81: Label8;
    Label82: Label8;
    Label83: Label8;
    Label84: Label8;
    PopupMenu1: TPopupMenu;
    Add2: TMenuItem;
    Edit1: TMenuItem;
    Delete1: TMenuItem;
    Insert: TMenuItem;
    Print1: TMenuItem;
    N3: TMenuItem;
    PropFlg: TMenuItem;
    N1: TMenuItem;
    StoreCoordFlg: TMenuItem;
    OkRPBtn: TButton;
    CanCP1Btn: TButton;
    ClsCP1Btn: TButton;
    TCMBtnScrollBox: TScrollBox;
    EditBtn: TButton;
    DelBtn: TButton;
    AddBtn: TButton;
    InsBtn: TButton;
    RSubTPanel: TSBSPanel;
    RBrkPanel: TSBSPanel;
    RSmryPanel: TSBSPanel;
    RSortPanel: TSBSPanel;
    RSubTLab: TSBSPanel;
    RBrkLab: TSBSPanel;
    RSortLab: TSBSPanel;
    RSelPanel: TSBSPanel;
    RSelLab: TSBSPanel;
    RSmryLab: TSBSPanel;
    NomBox: TScrollBox;
    NHedPanel: TSBSPanel;
    NRefLabel: TSBSPanel;
    NDescLabel: TSBSPanel;
    NPrntLabel: TSBSPanel;
    NBrkLabel: TSBSPanel;
    NCalcLabel: TSBSPanel;
    NRefPanel: TSBSPanel;
    NDescPanel: TSBSPanel;
    NPrntPanel: TSBSPanel;
    NBrkPanel: TSBSPanel;
    NCalcPanel: TSBSPanel;
    InpBox: TScrollBox;
    IHedPanel: TSBSPanel;
    IVarLabel: TSBSPanel;
    IDescLabel: TSBSPanel;
    IInpLabel: TSBSPanel;
    IDefLabel: TSBSPanel;
    IVarPanel: TSBSPanel;
    IDescPanel: TSBSPanel;
    IInpPanel: TSBSPanel;
    IDefPanel: TSBSPanel;
    NoteBox: TScrollBox;
    NtHedPanel: TSBSPanel;
    NtNotLabel: TSBSPanel;
    NtNotPanel: TSBSPanel;
    FindBtn: TButton;
    PrintBtn: TButton;
    LayoutBtn: TButton;
    CopyBtn: TButton;
    ImpExpBtn: TButton;
    RPName: Text8Pt;
    RpHed: Text8Pt;
    RpDesc: Text8Pt;
    RpType: TSBSComboBox;
    SBSGroup2: TSBSGroup;
    Label85: Label8;
    Label86: Label8;
    Label87: Label8;
    RpFile: TSBSComboBox;
    RpSearch: TSBSComboBox;
    SBSGroup3: TSBSGroup;
    Label88: Label8;
    Label89: Label8;
    RpCSV: TBorRadio;
    RpPrn: TBorRadio;
    RpTest: TBorCheck;
    RpRStart: TBorCheck;
    RpREnd: TBorCheck;
    TabSheet6: TTabSheet;
    FontDialog1: TFontDialog;
    LblRepWidth: TSBSPanel;
    RpInp: TCurrencyEdit;
    RpSamp: TCurrencyEdit;
    ScrlMisc: TScrollBox;
    SBSGroup4: TSBSGroup;
    FontLbl1: TLabel;
    FontLbl2: TLabel;
    TmpFontLbl: TLabel;
    FontBtn: TButton;
    SBSGroup5: TSBSGroup;
    SBSGroup6: TSBSGroup;
    Label810: Label8;
    RpLand: TBorRadio;
    RpPort: TBorRadio;
    RpGlob: Text8Pt;
    SBSGroup7: TSBSGroup;
    Label811: Label8;
    Label812: Label8;
    RpColSpc: TCurrencyEdit;
    btnChangePWord: TButton;
    grpPWord: TSBSGroup;
    lblPwordStatus: Label8;
    SBSGroup8: TSBSGroup;
    chkInfoRep: TBorCheck;
    rpDBF: TBorRadio;
    chkCSVTotals: TBorCheck;
    extDBFCommand: Text8Pt;
    lblDBFCommand: Label8;
    procedure RRefPanelMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure RRefLabMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure RRefLabMouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure PopupMenu1Popup(Sender: TObject);
    procedure PropFlgClick(Sender: TObject);
    procedure StoreCoordFlgClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FormResize(Sender: TObject);
    procedure LClsBtnClick(Sender: TObject);
    procedure LVwBtnClick(Sender: TObject);
    procedure LAddBtnClick(Sender: TObject);
    procedure LDelBtnClick(Sender: TObject);
    procedure LDescBtnClick(Sender: TObject);
    procedure PageControl1Change(Sender: TObject);
    procedure PageControl1Changing(Sender: TObject;
      var AllowChange: Boolean);
    procedure ClsCP1BtnClick(Sender: TObject);
    procedure RpFileClick(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure FormKeyPress(Sender: TObject; var Key: Char);
    procedure RPNameExit(Sender: TObject);
    procedure RpHedExit(Sender: TObject);
    procedure OkRPBtnClick(Sender: TObject);
    procedure RpDescExit(Sender: TObject);
    procedure RpFileExit(Sender: TObject);
    procedure RpTypeClick(Sender: TObject);
    procedure DelBtnClick(Sender: TObject);
    procedure FontBtnClick(Sender: TObject);
    procedure AddBtnClick(Sender: TObject);
    procedure FindBtnClick(Sender: TObject);
    procedure InsBtnClick(Sender: TObject);
    procedure PrintBtnClick(Sender: TObject);
    procedure RpTestClick(Sender: TObject);
    procedure RpSearchClick(Sender: TObject);
    procedure btnChangePWordClick(Sender: TObject);
    procedure rpDBFClick(Sender: TObject);
  private
    { Private declarations }
    FClosing,
    StoreCoord,
    LastCoord,
    StopPageChange,
    SetDefault,
    GotCoord,
    CanDelete    :  Boolean;

    RKeypath     : Integer;

    RepBtnList   :  TVisiBtns;

    {OldMACtrl    :  TNHCtrlRec;}

    PagePoint    :  Array[0..5] of TPoint;

    SearchSet    : SmallInt;

    RepLine      : TFrmRepLine;   { Report Line Form }
    NomLine      : TFrmNomLine;   { Notes Line Form }
    InpLine      : TFrmInpLine;   { Input Line Form }
    NotLine      : TFrmNotLine;   { Notes Line Form }

    DBFCmdLineExists : Boolean;

    procedure Find_FormCoord;
    procedure Store_FormCoord(UpMode  :  Boolean);

    procedure FormSetOfSet;
    procedure PrimeButtons;
    Procedure BuildDesign;

    Procedure WMCustGetRec(Var Message  :  TMessage); Message WM_CustGetRec;
    Procedure WMGetMinMaxInfo(Var Message  :  TWMGetMinMaxInfo); Message WM_GetMinMaxInfo;
    Procedure WMRWPrint(Var Message  :  TMessage); Message WM_PrintRep;

    Procedure Send_UpdateList(WPar, LPar :  Integer);

    procedure ShowRightMeny(X,Y,Mode  :  Integer);

    procedure SetFieldProperties;

    Function Current_Page : Integer;
    Procedure OutReport;
    Procedure SetCaption;

    Procedure RenameLines(OKeyPath : Integer);

    procedure ProcessReport(Fnum, KeyPath : Integer;
                            Edit          : Boolean);
    procedure SetRepStore(EnabFlag, ButnFlg  :  Boolean);
    procedure SetCompRO(      TC      : TComponent;
                        Const TG      : Integer;
                        Const EnabFlg : Boolean);

    Function CheckCompleted (Edit  :  Boolean)  : Boolean;
    Function CheckNeedStore  :  Boolean;
    Function ConfirmQuit  :  Boolean;

    Procedure Form2Report;

    procedure StoreReport(Fnum, KeyPAth : Integer;
                          Edit          : Boolean);

    procedure SetFieldFocus;

    Function GetDriveFile : Integer;
    Function GetDrivePath : Integer;

    procedure Display_RepLine(Mode  :  Byte);
    procedure Display_NomLine(Mode  :  Byte);
    procedure Display_InpLine(Mode  :  Byte);
    procedure Display_NotLine(Mode  :  Byte);

    procedure UpdRepWidth (Const RepWidth : SmallInt);

    function FindCommandRec : Boolean;
    procedure GetCommandRec;
    procedure SaveCommandRec;
  public
    { Public declarations }

    ExLocal      :  TdExLocal;

    ListOfSet    :  Integer;

    MULCtrlO     :  Array [2..5] Of TMAMList;

    RepParent    : Str10;

    procedure FormDesign;

    procedure RefreshList(ShowLines,
                          IgMsg      :  Boolean);

    procedure FormBuildList(ShowLines  :  Boolean);
    procedure BuildNomList(ShowLines  :  Boolean);
    procedure BuildInpList(ShowLines  :  Boolean);
    procedure BuildNoteList(ShowLines  :  Boolean);

    procedure ShowLink;
    procedure SetFormProperties;

    Procedure ChangePage(NewPage  :  Integer);

    Procedure EditRep (Const Edit : Boolean);
    Procedure DeleteRep;
    Procedure ViewRep;
    Procedure ViewNotes;
  end;


Procedure SetRepDetMode(State  :  TNHCtrlRec);

Function GetDefaultStr (RepDet  :  ReportDetailType) : String;

Function DeleteRepLines (RepName : ShortString) : Boolean;

{~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~}

Implementation

{~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~}

Uses
  ETStrU,
  ETMiscU,
  ETDateU,
  BtrvU2,
  ExBtTh1U,
  BTSupU2,
  CmpCtrlU,
  ColCtrlU,

  ComnU2,
  CurrncyU,

  VarFPosU,
  RpCommon,
  RwFuncs,
  RwListU,
  PWarnU,
  RwPrintR,
  RepFNO1U,
  PwordDlg,
  RepObjCU;

{$R *.DFM}

Const
  HeadPage = 0;
  MiscPage = 1;
  RepPage  = 2;
  NomPage  = 3;
  InpPage  = 4;
  NotePage = 5;

  ListPages = [RepPage..NotePage];

Var
  DDFormMode   : TNHCtrlRec;

{$I RepDet2.PAS}

{ ========= Exported function to set View type b4 form is created ========= }
Procedure SetRepDetMode(State  :  TNHCtrlRec);
Begin
  DDFormMode:=State;
end;

{ Deletes a complete report including fields, notes, etc }
Function DeleteRepLines (RepName : ShortString) : Boolean;
Const
  FNum    = RepGenF;
  KeyPath : Integer = RGNdxK;
Var
  FoundCode  : String;
  TmpRep     : ^RepGenRec;
  KeyS       : Str255;
  TmpFn      : FileVar;
  TmpStat    : Integer;
  TmpRecAddr : LongInt;
Begin
  { Save position }
  New (TmpRep);
  TmpRep^ := RepGenRecs^;
  TmpFn:=F[FNum];
  TmpStat:=Presrv_BTPos(Fnum,KeyPath,TmpFn,TmpRecAddr,BOff,BOff);


  RepName := FullRepCode (RepName);
  If GetReport (RepName, FoundCode) Then Begin
    Ok:=GetMultiRec(B_GetDirect,B_MultLock,KeyS,Keypath,Fnum,BOn,GlobLocked);

    If (Ok) and (GlobLocked) then Begin
      { Delete header record }
      Status:=Delete_Rec(F[Fnum],Fnum,KeyPath);
      Report_BError(Fnum,Status);

      { Delete any dependant links etc }
      If (StatusOk) then Begin
        { Report Lines }
        KeyS := FullRepKey_NDX(ReportGenCode, RepRepCode, RepName);
        DeleteLinks(KeyS, RepGenF, Length(KeyS), RGK, BOff);

        { Nominal Lines }
        KeyS := FullRepKey_NDX(ReportGenCode, RepNomCode, RepName);
        DeleteLinks(KeyS, RepGenF, Length(KeyS), RGK, BOff);

        { Input Lines }
        KeyS := FullRepKey_NDX(ReportGenCode, RepLineTyp, RepName);
        DeleteLinks(KeyS, RepGenF, Length(KeyS), RGK, BOff);

        { Notes }
        KeyS := FullRepKey_NDX(RepNoteType, RepNoteCode, RepName);
        DeleteLinks(KeyS, RepGenF, Length(KeyS), RGK, BOff);
      End; { If }
    End; { If }
  End; { If }

  { Restore position }
  TmpStat:=Presrv_BTPos(Fnum,KeyPath,TmpFn,TmpRecAddr,BOn,BOff);
  Status:=GetDirect(F[Fnum],Fnum,RecPtr[Fnum]^,KeyPAth,0); {* Re-Establish Position *}
  RepGenRecs^ := TmpRep^;
  Dispose (TmpRep);
End;


procedure TReportRec.Find_FormCoord;
Var
  ThisForm:  TForm;
  VisibleRect:  TRect;
  GlobComp:  TGlobCompRec;
  I        : Integer;
Begin
(* MH 17/10/07: Removed as if printing a report on ExStkChk.Dat this process can clash causing records to be overwritten
  New(GlobComp,Create(BOn));

  ThisForm:=Self;

  With GlobComp^ do Begin
    GetValues:=BOn;

    PrimeKey:='*';

    If (GetbtControlCsm(ThisForm)) then Begin
      StoreCoord:=(ColOrd=1);
      HasCoord:=(HLite=1);
      LastCoord:=HasCoord;

      If (HasCoord) then Begin{* Go get postion, as would not have been set initianly *}
        SetPosition(ThisForm);
        FormResize(Self);
      End; { If }
    end;

    GetbtControlCsm(PageControl1);

    GetbtControlCsm(MHedPanel);
    GetbtControlCsm(NHedPanel);
    GetbtControlCsm(IHedPanel);
    GetbtControlCsm(NtHedPanel);

    If GetbtControlCsm(RpName) Then        { Header - Report Name }
      SetFieldProperties;                  { Other Header Fields }
  End; {With GlobComp..}

  Dispose(GlobComp,Destroy);
*)
end;


procedure TReportRec.Store_FormCoord(UpMode  :  Boolean);
Var
  GlobComp : TGlobCompRec;
  I        : Integer;
Begin
(* MH 17/10/07: Removed as if printing a report on ExStkChk.Dat this process can clash causing records to be overwritten
  New(GlobComp,Create(BOff));

  With GlobComp^ do Begin
    GetValues:=UpMode;

    PrimeKey:='*';

    ColOrd:=Ord(StoreCoord);

    HLite:=Ord(LastCoord);

    SaveCoord:=StoreCoord;

    If (Not LastCoord) then {* Attempt to store last coord *}
      HLite:=ColOrd;

    StorebtControlCsm(Self);

    StorebtControlCsm(PageControl1);
    StorebtControlCsm(RpName);

    StorebtControlCsm(MHedPanel);
    StorebtControlCsm(NHedPanel);
    StorebtControlCsm(IHedPanel);
    StorebtControlCsm(NtHedPanel);

    GetValues:=UpMode;
    SaveCoord:=StoreCoord;
    PrimeKey:='*';
    For I := Low(MULCtrlO) To High (MULCtrlO) Do
      If Assigned(MULCtrlO[I]) Then
        MULCtrlO[I].Store_ListCoord(GlobComp);
  end; {With GlobComp..}

  GlobComp.Destroy;
  *)
end;

{ Takes a copy of key positions used for resizing }
procedure TReportRec.FormSetOfSet;
Begin
  { Take points for button panel }
  PagePoint[0].X:=ClientWidth - PnlButt.Left;
  PagePoint[0].Y:=ClientHeight - PnlButt.Height;

  { Take points for the header tab's control scroll box }
  PagePoint[1].X:=PageControl1.ClientWidth-ScrlHed.Width;
  PagePoint[1].Y:=PageControl1.ClientHeight-ScrlHed.Height;

  { Take points for Btrieve Scroll Button Panel }
  PagePoint[2].X:=PageControl1.ClientWidth-MListBtnPanel.Left;
  PagePoint[2].Y:=PageControl1.ClientHeight-MListBtnPanel.Height;

  { Take points for Btrieve List scroll box }
  PagePoint[3].X:=PageControl1.ClientWidth-MsBox.Width;
  PagePoint[3].Y:=PageControl1.ClientHeight-MsBox.Height;

  { Take a point for column heights in the Btrieve List scroll box }
  PagePoint[4].Y:=MsBox.Height-RRefPanel.Height;

  { Take a point for scroll box heights in button panel }
  PagePoint[5].Y:=PnlButt.Height - TCMBtnScrollBox.Height;

  GotCoord:=BOn;
end;


Procedure TReportRec.WMCustGetRec(Var Message  :  TMessage);
Begin
  With Message Do
    Case WParam of
      0, 169 : Begin { 0 = dbl click on line, 169 = pressed drill down button}
                 If (WParam=169) then
                   MULCtrlO[Current_Page].GetSelRec(BOff);

                 AddBtnClick(EditBtn);
               End;

      { Selected line changed }
      1      : ;

      { pressed right click over list }
      2      : ShowRightMeny(LParamLo,LParamHi,1);

      { Sent when Report Line dialog closes }
      100    : Case LParam Of
                 0 : RepLine := Nil;
                 1 : InpLine := Nil;
                 2 : NotLine := Nil;
                 3 : NomLine := Nil;
               End; { Case }

      { Sent whenever the width has changed }
      109    : UpdRepWidth (ExLocal.LRepGen.ReportHed.MaxWidth);

      { Sent to change tab page when Ctrl-Page Up/Down is pressed }
      175    : With PageControl1 do
                 ChangePage(FindNextPage(ActivePage,(LParam=0),BOn).PageIndex);

      { Sent when an update has been performed }
      200..209
             : With MULCtrlO[WPAram - 200] do Begin
                 AddNewRow(MUListBoxes[0].Row,(LParam=1));
               End;

      { Sent when a deletion has been performed }
      300..309
             :  With MULCtrlO[WParam-300] do
                  If (MUListBox1.Row<>0) then
                    PageUpDn(0,BOn)
                  else
                    InitPage;
    End; { Case }

  Inherited;
end;


{ == Procedure to Send Message to Get Record == }
Procedure TReportRec.Send_UpdateList(WPar, LPar :  Integer);
Var
  Message1 :  TMessage;
  MessResult :  LongInt;
Begin
  FillChar(Message1,Sizeof(Message1),0);

  With Message1 do Begin
    MSg:=WM_CustGetRec;
    WParam := 100 + WPar;
    LParam := LPar;
  end;

  With Message1 do
    MessResult:=SendMessage((Owner as TForm).Handle,Msg,WParam,LParam);
end; {Proc..}

Procedure TReportRec.SetCaption;
Begin
  With ExLocal Do
    Caption := 'Report Record: ' + LRepGen^.ReportHed.RepName;
End;

procedure TReportRec.ShowLink;
begin
  ExLocal.AssignFromGlobal(RepGenF);
  ExLocal.LGetRecAddr(RepGenF);

  CanDelete:=Ok2DelRep (ExLocal.LRepGen^.ReportHed.RepName);

  SetCaption;

  OutReport;

  { Update lists }
  If (Current_Page In [RepPage..NotePage]) Then
    RefreshList(BOn, BOn);
end;


procedure TReportRec.FormDesign;
begin
  { Take a copy of positions for resizing }
  FormSetOfSet;

  { Load in the saved coordinates }
  Find_FormCoord;

  { Setup the button control object }
  PrimeButtons;
end;

Procedure TReportRec.BuildDesign;
Begin
  { Adjust depending on mode }
  TabSheet1.TabVisible := ChkAllowed_In (194);
  TabSheet6.TabVisible := ChkAllowed_In (194);
  TabSheet2.TabVisible := ChkAllowed_In (194) And (DDFormMode.NHMode <> 0);
  TabSheet3.TabVisible := ChkAllowed_In (194) And (DDFormMode.NHMode <> 0) And (ExLocal.LRepGen^.ReportHed.RepType = RepNomCode);
  TabSheet4.TabVisible := ChkAllowed_In (194) And (DDFormMode.NHMode <> 0);
  TabSheet5.TabVisible := (DDFormMode.NHMode <> 0);
End;

procedure TReportRec.PrimeButtons;
Var
  P4Blk     : Boolean;
  n, PageNo : Integer;
Begin
  PageNo:=Current_Page;

  If Not Assigned(RepBtnList) Then Begin
    RepBtnList:=TVisiBtns.Create;

    Try
      With RepBtnList do Begin
        PresEnab:=BOff;

      {0} AddVisiRec(AddBtn,    BOff);
      {1} AddVisiRec(EditBtn,   BOff);
      {2} AddVisiRec(InsBtn,    BOff);
      {3} AddVisiRec(DelBtn,    BOff);
      {4} AddVisiRec(FindBtn,   BOff);
      {5} AddVisiRec(PrintBtn,  BOff);
      {6} AddVisiRec(LayoutBtn, BOff);
      {7} AddVisiRec(CopyBtn,   BOff);
      {8} AddVisiRec(ImpExpBtn, BOff);

      End; {With..}
    Except
      RepBtnList.Free;
      RepBtnList:=nil;
    End; { Try }
  End; { If }

  Try
    With RepBtnList Do Begin
      PresEnab:=ExLocal.InAddEdit;

      { Add }
//      SetHideBtn(0, BOff, BOff);
      SetHideBtn(0, BOn, BOn);
      {SetBtnHelp(0,SetHelpC(PageNo,[0..3,5,7],156,156,88,128,0,0,0,0));}

      { Edit }
      SetHideBtn(1, BOff, BOff);
      {SetBtnHelp(1,SetHelpC(PageNo,[0..5,7],155,155,87,129,26,0,0,0));}

      { Insert }
      SetHideBtn(2, Not(PageNo In ListPages), BOff);

      { Delete }
      SetHideBtn(3,BOff,BOff);
      {SetBtnHelp(3,SetHelpC(PageNo,[0..5,7],159,159,89,130,0,0,0,0));}

      { Find }
      SetHideBtn(4,(PageNo <> HeadPage),BOff);
      {SetBtnHelp(4,SetHelpC(PageNo,[0,1,4],165,165,0,0,27,0,0,0));}

      { Print }
      SetHideBtn(5, BOff, BOff);

      { Layout }
      SetHideBtn(6, BOn, BOn);

      { Copy }
      SetHideBtn(7, BOn, BOff);
      {SetBtnHelp(7,SetHelpC(PageNo,[0,1,4],163,163,0,0,31,0,0,0));}

      { Import/Export }
      SetHideBtn(8, BOn, BOn);
      {SetBtnHelp(8,SetHelpC(PageNo,[0,1,4],154,154,0,0,32,0,0,0));}

      {
      DelCP1Btn.Enabled:=SetDelBtn;

      OkCP1Btn.Visible:=(PageNo In [0,1]);
      CanCP1Btn.Visible:=(PageNo In [0,1]);}
    end;
  except
    RepBtnList.Free;
    RepBtnList:=nil;
  end; {try..}
End;

procedure TReportRec.RefreshList(ShowLines,
                                 IgMsg      :  Boolean);
Var
  KeyStart    :  Str255;
  LKeyLen     :  Integer;
Begin
  If Assigned (MULCtrlO[Current_Page]) Then Begin
    Case Current_Page Of
      RepPage : Begin { Report Lines }
                  KeyStart := FullRepKey_NDX(ReportGenCode, RepRepCode, ExLocal.LRepGen^.ReportHed.RepName);
                  LKeyLen  := Length(KeyStart);
                End;
      NomPage : Begin { Nominal Lines }
                  KeyStart := FullRepKey_NDX(ReportGenCode, RepNomCode, ExLocal.LRepGen^.ReportHed.RepName);
                  LKeyLen  := Length(KeyStart);
                End;
      InpPage : Begin { Input Lines }
                  KeyStart := FullRepKey_NDX(ReportGenCode, RepLineTyp, ExLocal.LRepGen^.ReportHed.RepName);
                  LKeyLen  := Length(KeyStart);
                End;
      NotePage : Begin { Notes }
                  KeyStart := FullRepKey_NDX(RepNoteType, RepNoteCode, ExLocal.LRepGen^.ReportHed.RepName);
                  LKeyLen  := Length(KeyStart);
                End;
    End; { Case }

    With MULCtrlO[Current_Page] do Begin
      {DisplayMode:=Current_Page;}

      IgnoreMsg:=IgMsg;

      StartList(RepGenF,RGK,KeyStart,'','',LKeyLen,(Not ShowLines));

      IgnoreMsg:=BOff;
    End; { With }
  End; { If }
end;


procedure TReportRec.FormBuildList(ShowLines  :  Boolean);
Var
  GlobComp    :  TGlobCompRec;
  StartPanel  :  TSBSPanel;
  n           :  Byte;
Begin
  MULCtrlO[RepPage]:=TMAMList.Create(Self);

  Try
    With MULCtrlO[RepPage] do Begin
      Try
        DisplayMode := RepPage;

        With VisiList do Begin
          AddVisiRec(RRefPanel,  RRefLab);
          AddVisiRec(RDescPanel, RDescLab);
          AddVisiRec(RLenPanel,  RLenLab);
          AddVisiRec(RPrnPanel,  RPrnLab);
          AddVisiRec(RSubTPanel, RSubTLab);
          AddVisiRec(RBrkPanel,  RBrkLab);
          AddVisiRec(RSortPanel, RSortLab);
          AddVisiRec(RSelPanel,  RSelLab);
          AddVisiRec(RSmryPanel, RSmryLab);

          VisiRec:=List[0];

          StartPanel:=(VisiRec^.PanelObj as TSBSPanel);

          {HidePanels(0);}

          LabHedPanel:=MHedPanel;

          ListOfSet:=10;

          SetHedPanel(ListOfSet);
        end;
      except
        VisiList.Free;
      end;

      { Get Coordinates/Colours }
      New(GlobComp,Create(BOn));
      With GlobComp^ do Begin
        GetValues:=BOn;
        PrimeKey:='*';
        HasCoord:=LastCoord;
        Find_ListCoord(GlobComp);
      End; { With }
      Dispose(GlobComp, Destroy);

      TabOrder := -1;
      TabStop:=BOff;
      Visible:=BOff;
      BevelOuter := bvNone;
      ParentColor := False;
      Color:=StartPanel.Color;
      MUTotCols:=8;
      Font:=StartPanel.Font;

      LinkOtherDisp:=BOff;

      WM_ListGetRec:=WM_CustGetRec;

      Parent:=StartPanel.Parent;

      MessHandle:=Self.Handle;

      For n:=0 to MUTotCols do
        With ColAppear^[n] Do
          AltDefault:=BOn;

      ListLocal:=@ExLocal;

      ListCreate;

      {UseSet4End:=BOn;}

      NoUpCaseCheck:=BOn;

      Set_Buttons(MListBtnPanel);

      ReFreshList(ShowLines,BOff);
    end {With}
  Except
    MULCtrlO[RepPage].Free;
    MULCtrlO[RepPage]:=Nil;
  end;

  FormSetOfSet;

  {FormReSize(Self);}
end;

procedure TReportRec.BuildNomList(ShowLines  :  Boolean);
Var
  GlobComp    :  TGlobCompRec;
  StartPanel  :  TSBSPanel;
  n           :  Byte;
Begin
  MULCtrlO[NomPage]:=TMAMList.Create(Self);

  Try
    With MULCtrlO[NomPage] do Begin
      Try
        With VisiList do Begin
          DisplayMode := NomPage;

          AddVisiRec(NRefPanel,  NRefLabel);
          AddVisiRec(NDescPanel, NDescLabel);
          AddVisiRec(NPrntPanel, NPrntLabel);
          AddVisiRec(NBrkPanel,  NBrkLabel);
          AddVisiRec(NCalcPanel, NCalcLabel);

          VisiRec:=List[0];

          StartPanel:=(VisiRec^.PanelObj as TSBSPanel);

          {HidePanels(0);}

          LabHedPanel:=NHedPanel;

          ListOfSet:=10;

          SetHedPanel(ListOfSet);
        end;
      except
        VisiList.Free;
      end;

      { Get Coordinates/Colours }
      New(GlobComp,Create(BOn));
      With GlobComp^ do Begin
        GetValues:=BOn;
        PrimeKey:='*';
        HasCoord:=LastCoord;
        Find_ListCoord(GlobComp);
      End; { With }
      Dispose(GlobComp, Destroy);

      TabOrder := -1;
      TabStop:=BOff;
      Visible:=BOff;
      BevelOuter := bvNone;
      ParentColor := False;
      Color:=StartPanel.Color;
      MUTotCols:=4;
      Font:=StartPanel.Font;

      LinkOtherDisp:=BOff;

      WM_ListGetRec:=WM_CustGetRec;

      Parent:=StartPanel.Parent;

      MessHandle:=Self.Handle;

      For n:=0 to MUTotCols do
        With ColAppear^[n] Do
          AltDefault:=BOn;

      ListLocal:=@ExLocal;

      ListCreate;

      {UseSet4End:=BOn;}

      NoUpCaseCheck:=BOn;

      Set_Buttons(MListBtnPanel);

      ReFreshList(ShowLines,BOff);
    end {With}
  Except
    MULCtrlO[NomPage].Free;
    MULCtrlO[NomPage]:=Nil;
  end;

  FormSetOfSet;

  {FormReSize(Self);}
end;


procedure TReportRec.BuildInpList(ShowLines  :  Boolean);
Var
  GlobComp    :  TGlobCompRec;
  StartPanel  :  TSBSPanel;
  n           :  Byte;
Begin
  MULCtrlO[InpPage]:=TMAMList.Create(Self);

  Try
    With MULCtrlO[InpPage] do Begin
      Try
        With VisiList do Begin
          DisplayMode := InpPage;

          AddVisiRec(IVarPanel,  IVarLabel);
          AddVisiRec(IDescPanel, IDescLabel);
          AddVisiRec(IInpPanel,  IInpLabel);
          AddVisiRec(IDefPanel,  IDefLabel);

          VisiRec:=List[0];

          StartPanel:=(VisiRec^.PanelObj as TSBSPanel);

          {HidePanels(0);}

          LabHedPanel:=IHedPanel;

          ListOfSet:=10;

          SetHedPanel(ListOfSet);
        end;
      except
        VisiList.Free;
      end;

      { Get Coordinates/Colours }
      New(GlobComp,Create(BOn));
      With GlobComp^ do Begin
        GetValues:=BOn;
        PrimeKey:='*';
        HasCoord:=LastCoord;
        Find_ListCoord(GlobComp);
      End; { With }
      Dispose(GlobComp, Destroy);

      TabOrder := -1;
      TabStop:=BOff;
      Visible:=BOff;
      BevelOuter := bvNone;
      ParentColor := False;
      Color:=StartPanel.Color;
      MUTotCols:=3;
      Font:=StartPanel.Font;

      LinkOtherDisp:=BOff;

      WM_ListGetRec:=WM_CustGetRec;

      Parent:=StartPanel.Parent;

      MessHandle:=Self.Handle;

      For n:=0 to MUTotCols do
        With ColAppear^[n] Do
          AltDefault:=BOn;

      ListLocal:=@ExLocal;

      ListCreate;

      {UseSet4End:=BOn;}

      NoUpCaseCheck:=BOn;

      Set_Buttons(MListBtnPanel);

      ReFreshList(ShowLines,BOff);
    end {With}
  Except
    MULCtrlO[InpPage].Free;
    MULCtrlO[InpPage]:=Nil;
  end;

  FormSetOfSet;

  {FormReSize(Self);}
end;

procedure TReportRec.BuildNoteList(ShowLines  :  Boolean);
Var
  GlobComp    :  TGlobCompRec;
  StartPanel  :  TSBSPanel;
  n           :  Byte;
Begin
  MULCtrlO[NotePage]:=TMAMList.Create(Self);

  Try
    With MULCtrlO[NotePage] do Begin
      Try
        With VisiList do Begin
          DisplayMode := NotePage;

          AddVisiRec(NtNotPanel, NtNotLabel);

          VisiRec:=List[0];

          StartPanel:=(VisiRec^.PanelObj as TSBSPanel);

          {HidePanels(0);}

          LabHedPanel:=NtHedPanel;

          ListOfSet:=10;

          SetHedPanel(ListOfSet);
        end;
      except
        VisiList.Free;
      end;

      { Get Coordinates/Colours }
      New(GlobComp,Create(BOn));
      With GlobComp^ do Begin
        GetValues:=BOn;
        PrimeKey:='*';
        HasCoord:=LastCoord;
        Find_ListCoord(GlobComp);
      End; { With }
      Dispose(GlobComp, Destroy);

      TabOrder := -1;
      TabStop:=BOff;
      Visible:=BOff;
      BevelOuter := bvNone;
      ParentColor := False;
      Color:=StartPanel.Color;
      MUTotCols:=0;
      Font:=StartPanel.Font;

      LinkOtherDisp:=BOff;

      WM_ListGetRec:=WM_CustGetRec;

      Parent:=StartPanel.Parent;

      MessHandle:=Self.Handle;

      For n:=0 to MUTotCols do
        With ColAppear^[n] Do
          AltDefault:=BOn;

      ListLocal:=@ExLocal;

      ListCreate;

      {UseSet4End:=BOn;}

      NoUpCaseCheck:=BOn;

      Set_Buttons(MListBtnPanel);

      ReFreshList(ShowLines,BOff);
    end {With}
  Except
    MULCtrlO[NotePage].Free;
    MULCtrlO[NotePage]:=Nil;
  end;

  FormSetOfSet;

  {FormReSize(Self);}
end;

procedure TReportRec.FormCreate(Sender: TObject);
Var
  WantF : Boolean;
  n     :  Integer;
begin
  ExLocal.Create;

  FClosing:=False;
  LastCoord:=BOff;
  GotCoord := False;
  StopPageChange:=BOff;

  ClientHeight := 302;
  ClientWidth  := 589;

  { Take copy of font for later use }
  TmpFontLbl.Font.Assign (FontLbl1.Font);

  RpType.Items.Clear;
  For n := 1 To High(RepHedTypesL^) Do
    RpType.Items.Add (RepHedTypesL^[n]);

  RpFile.Items.Clear;
  For n := 1 To High(DataFilesL^) Do Begin
    Case N Of
      { Stock File }
      6       : WantF := (ExVersionNo In [2,4,5,6,8,9,11]);

      { Cost Centre and Departments }
      7, 8    : WantF := (ExVersionNo >= 3);

      { Not Used or Form Designer Only }
      9,
      11, 12,
      13      : WantF := False;

      { Bill Of Materials }
      10      : WantF := (ExVersionNo In [2,4,5,6,8,9,11]);

      { Discount Matrix }
      14      : WantF := (ExVersionNo In [2,4,5,6,8,9,11]);

      { Serial Number DB }
      16      : WantF := (ExVersionNo In [5, 6, 9, 11]);

      { Job Costing files - Job Costing versions only }
      15,
      17..19,
      21..25
        : WantF := (ExVersionNo In [6,11]);


      { FIFO }
      20      : WantF := (ExVersionNo In [2,4,5,6,8,9,11]);

      { Stock location files - SPOP versions only }
      26, 27  : WantF := (ExVersionNo In [5,6,9,11]);

      { Matched Payments }
      28      : WantF := True;

      { Stock Notes }
      31      : WantF := (ExVersionNo In [2,4,5,6,8,9,11]);
      //PR: 20/03/01 CIS Vouchers
      {$IFDEF EN550CIS}
      33      : WantF := (ExVersionNo In [6,11]) and CISOn;
      {$ENDIF}

    Else
      WantF := True;
    End; { Case }

    If WantF Then
      RpFile.Items.Add (DataFilesL^[n]);

    {
    If (Not (n In [9..16])) Or ((n In [16]) And (ExVersionNo In [5, 6, 9, 11])) Then
      RpFile.Items.Add (DataFilesL^[n]);
    }
  End; { For }

  RpSearch.Items.Clear;
  SearchSet := -1;

  MDI_SetFormCoord(TForm(Self));

  For n:=0 to Pred(ComponentCount) do
    If (Components[n] is TScrollBox) then
      With TScrollBox(Components[n]) do Begin
        VertScrollBar.Position:=0;
        HorzScrollBar.Position:=0;
      end;
  VertScrollBar.Position:=0;
  HorzScrollBar.Position:=0;

  FormDesign;

  With DDFormMode Do Begin
    Caption := IntToStr(NHMode) + ' - ' + MainK;

    Case NBMode Of
      0  : PageControl1.ActivePage := TabSheet1;
      1  : PageControl1.ActivePage := TabSheet2;
      2  : PageControl1.ActivePage := TabSheet3;
      3  : PageControl1.ActivePage := TabSheet4;
      4  : PageControl1.ActivePage := TabSheet5;
    End; { Case }
  End; { With }

  { Set Security }
  If (Not ChkAllowed_In (194)) Then Begin
    TabSheet1.TabVisible := False;  { Header }
    TabSheet1.Visible := False;     { Header }
    TabSheet6.TabVisible := False;  { Misc }
    TabSheet6.Visible := False;     { Misc }
    TabSheet2.TabVisible := False;  { Report }
    TabSheet2.Visible := False;     { Report }
    TabSheet3.TabVisible := False;  { Nom }
    TabSheet3.Visible := False;     { Nom }
    TabSheet4.TabVisible := False;  { Input }
    TabSheet4.Visible := False;     { Input }
  End; { If }

  rpDBFClick(Self);
end;


procedure TReportRec.FormDestroy(Sender: TObject);
Var
  n  :  Byte;
begin
  ExLocal.Destroy;

  If Assigned(RepBtnList) then
    RepBtnList.Free;

end;


procedure TReportRec.FormCloseQuery(Sender: TObject;
                                          var CanClose: Boolean);
Var
  n  : Integer;

begin
  For n:=0 to Pred(ComponentCount) do
    If (Components[n] is TScrollBox) then
      With TScrollBox(Components[n]) do Begin
        VertScrollBar.Position:=0;
        HorzScrollBar.Position:=0;
      end;

  VertScrollBar.Position:=0;
  HorzScrollBar.Position:=0;

  Store_FormCoord(Not SetDefault);

  Send_UpdateList(100, 0);
end;

procedure TReportRec.FormClose(Sender: TObject; var Action: TCloseAction);
Var
  I : Byte;
begin
  If (Not FClosing) Then Begin
    FClosing := True;

    For I := Low(MULCtrlO) To High(MULCtrlO) Do
      If Assigned(MULCtrlO[I]) Then Begin
        MULCtrlO [I].Destroy;
        MULCtrlO [I] := Nil;
      End; { If Assigned(MULCtrlO) }
  End; { If (Not FClosing) }

  Action:=caFree;
end;

procedure TReportRec.FormResize(Sender: TObject);
Var
  n           :  Byte;
  NewVal      :  Integer;
begin
  If (GotCoord) then Begin
    LockWindowUpDate(PageControl1.Handle);

    { Resize/position the buttons }
    PnlButt.Left   := ClientWidth - PagePoint[0].X;
    PnlButt.Height := ClientHeight - PagePoint[0].Y;

    { Resize scroll box height in button panel }
    TCMBtnScrollBox.Height := PnlButt.Height - PagePoint[5].Y;

    { Resize Header Tab Controls }
    ScrlHed.Width  := PageControl1.ClientWidth - PagePoint[1].X;
    ScrlHed.Height := PageControl1.ClientHeight - PagePoint[1].Y;
    ScrlMisc.Width  := ScrlHed.Width;
    ScrlMisc.Height := ScrlHed.Height;

    { Resize Btrieve List Button Panel }
    MListBtnPanel.Left   := PageControl1.ClientWidth - PagePoint[2].X;
    MListBtnPanel.Height := PageControl1.ClientHeight - PagePoint[2].Y;

    { Resize Report Lines Btrieve List scroll box }
    MsBox.Width  := PageControl1.ClientWidth - PagePoint[3].X;
    MsBox.Height := PageControl1.ClientHeight - PagePoint[3].Y;

    { Resize Nominal Lines Btrieve List scroll box }
    NomBox.Width  := PageControl1.ClientWidth - PagePoint[3].X;
    NomBox.Height := PageControl1.ClientHeight - PagePoint[3].Y;

    { Resize Input Lines Btrieve List scroll box }
    InpBox.Width  := PageControl1.ClientWidth - PagePoint[3].X;
    InpBox.Height := PageControl1.ClientHeight - PagePoint[3].Y;

    { Resize Notes Btrieve List scroll box }
    NoteBox.Width  := PageControl1.ClientWidth - PagePoint[3].X;
    NoteBox.Height := PageControl1.ClientHeight - PagePoint[3].Y;

    { Resize column heights in the Btrieve List scroll box }
    RRefPanel.Height := MsBox.Height - PagePoint[4].Y;

    For n:=Low(MULCtrlO) to High(MULCtrlO) do
      If Assigned(MULCtrlO[n]) then Begin
        With MULCtrlO[n],VisiList do Begin
          VisiRec:=List[0];

          With (VisiRec^.PanelObj as TSBSPanel) do
            Height:=RRefPanel.Height;

          ReFresh_Buttons;

          RefreshAllCols;
        end;
      end;

    LockWindowUpDate(0);
  End; { If }
end;

procedure TReportRec.RRefPanelMouseUp(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
Var
  BarPos     :  Integer;
  PanRSized  :  Boolean;
begin
  If (Sender is TSBSPanel) then
    With (Sender as TSBSPanel) do Begin
      PanRSized:=ReSized;

      BarPos:=MSBox.HorzScrollBar.Position;

      If (PanRsized) then
        MULCtrlO[Current_Page].ResizeAllCols(MULCtrlO[Current_Page].VisiList.FindxHandle(Sender),BarPos);

      MULCtrlO[Current_Page].FinishColMove(BarPos+(ListOfset*Ord(PanRSized)),PanRsized);
    end;
end;


procedure TReportRec.RRefLabMouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
Var
  ListPoint  :  TPoint;
begin
  If (Sender is TSBSPanel) then
    With (Sender as TSBSPanel) do Begin
      If (Not ReadytoDrag) and (Button=MBLeft) then Begin
        If (MULCtrlO[Current_Page]<>nil) then
          MULCtrlO[Current_Page].VisiList.PrimeMove(Sender);
      end
      else
        If (Button=mbRight) then Begin
          ListPoint:=ClientToScreen(Point(X,Y));

          ShowRightMeny(ListPoint.X,ListPoint.Y,0);
        end;
    end;
end;


procedure TReportRec.RRefLabMouseMove(Sender: TObject; Shift: TShiftState;
  X, Y: Integer);
begin
  If (Sender is TSBSPanel) then
    With (Sender as TSBSPanel) do Begin
      If (MULCtrlO[Current_Page]<>nil) then
        MULCtrlO[Current_Page].VisiList.MoveLabel(X,Y);
    end;
end;



procedure TReportRec.SetFormProperties;
Var
  TmpPanel    :  Array[1..3] of TPanel;
  n           :  Byte;
  ResetDefaults,
  BeenChange  :  Boolean;
  ColourCtrl  :  TCtrlColor;
Begin
  ResetDefaults:=BOff;

  For n:=1 to 3 do Begin
    TmpPanel[n]:=TPanel.Create(Self);
  end;

  try
    Case Current_Page Of
      HeadPage,
      MiscPage  : Begin
                    TmpPanel[1].Font:=RpName.Font;
                    TmpPanel[1].Color:=RpName.Color;

                    TmpPanel[2].Font:=PageControl1.Font;
                    TmpPanel[2].Color:=ScrlHed.Color;
                  End;
      RepPage..NotePage
                : With MULCtrlO[Current_Page].VisiList do Begin
                    VisiRec:=List[0];

                    TmpPanel[1].Font:=(VisiRec^.PanelObj as TSBSPanel).Font;
                    TmpPanel[1].Color:=(VisiRec^.PanelObj as TSBSPanel).Color;

                    TmpPanel[2].Font:=(VisiRec^.LabelObj as TSBSPanel).Font;
                    TmpPanel[2].Color:=(VisiRec^.LabelObj as TSBSPanel).Color;

                    TmpPanel[3].Color:=MULCtrlO[Current_Page].ColAppear^[0].HBKColor;
                    TmpPanel[3].Font.Assign(TmpPanel[1].Font);
                    TmpPanel[3].Font.Color:=MULCtrlO[Current_Page].ColAppear^[0].HTextColor;
                  End;
    End; { Case }


    ColourCtrl:=TCtrlColor.Create(Self);

    try
      With ColourCtrl do Begin
        SetProperties(TmpPanel[1],TmpPanel[2],TmpPanel[3],1,'Match Properties',BeenChange,ResetDefaults);

        If (BeenChange) and (not ResetDefaults) then Begin
          Case Current_Page Of
            HeadPage,
            MiscPage  : Begin
                          PageControl1.Font.Assign(TmpPanel[2].Font);
                          ScrlHed.Color:=TmpPanel[2].Color;

                          RpName.Font.Assign(TmpPanel[1].Font);
                          RpName.Color:=TmpPanel[1].Color;

                          SetFieldProperties;
                        End;
            RepPage..NotePage
                      : Begin
                          For n:=1 to 3 do
                            With TmpPanel[n] do
                              Case n of
                                1,2  :  MULCtrlO[Current_Page].ReColorCol(Font,Color,(n=2));

                                3    :  MULCtrlO[Current_Page].ReColorBar(Font,Color);
                              end; {Case..}

                          MULCtrlO[Current_Page].VisiList.LabHedPanel.Color:=TmpPanel[2].Color;
                        End;
          End; { Case }
        End; { If }
      end;
    finally
      ColourCtrl.Free;
    end;
  Finally
    For n:=1 to 3 do
      TmpPanel[n].Free;
  end;

  If (ResetDefaults) then Begin
    SetDefault:=BOn;
    Close;
  end;
end;

{ Sets the colours into all the controls on the Header Tab }
procedure TReportRec.SetFieldProperties;
Var
  n  : Integer;
Begin
  For n:=0 to Pred(ComponentCount) do Begin
    If (Components[n] is TMaskEdit) or
       (Components[n] is TComboBox) or
       (Components[n] is TCurrencyEdit) and
       (Components[n] <> RpName) Then
    With TGlobControl(Components[n]) do
      If (Tag>0) then Begin
        Font.Assign(RpName.Font);
        Color:=RpName.Color;
      End; { If }

    If (Components[n] is TBorCheck) then
      With (Components[n] as TBorCheck) do Begin
        CheckColor:=RpName.Color;
        Color:=ScrlHed.Color;
      end;
  End; { For }
End;


procedure TReportRec.ShowRightMeny(X,Y,Mode  :  Integer);
Begin
  With PopUpMenu1 do Begin
    PopUp(X,Y);
  end;
end;

procedure TReportRec.PopupMenu1Popup(Sender: TObject);
{Var
  n  :  Integer;}
begin
  StoreCoordFlg.Checked:=StoreCoord;

  Add2.Enabled := AddBtn.Enabled;
  Edit1.Enabled := EditBtn.Enabled;
  Insert.Enabled := InsBtn.Enabled;
  Delete1.Enabled := DelBtn.Enabled;
  Print1.Enabled := PrintBtn.Enabled;
end;

procedure TReportRec.PropFlgClick(Sender: TObject);
begin
  //SetFormProperties;
end;

procedure TReportRec.StoreCoordFlgClick(Sender: TObject);
begin
  StoreCoord := Not StoreCoord;
end;

procedure TReportRec.LClsBtnClick(Sender: TObject);
begin
  Close;
end;

{ view letter }
procedure TReportRec.LVwBtnClick(Sender: TObject);
Const
  FNum    = MiscF;
  KeyPath = MIK;
Var
  Res   : Byte;
  CDir  : String;
begin
  (*
  CDir:='';

  MULCtrlO.GetSelRec(BOff);


  GetDir(0,CDir);

  With MiscRecs^.btLetterRec Do
  Begin
    Case Version Of
      DocWord95 : Res := ViewWordLetter (LtrPath);
    End; { Case }

    ChDir(CDir);

    If (Res <> 0) Then
      DispLetterError (Res);
  End; { With }
  *)
end;

procedure TReportRec.LDelBtnClick(Sender: TObject);
Const
  FNum    = MiscF;
  KeyPath = MIK;
Var
  KeyS : Str255;
  Locked : Boolean;
  DocPath : String;
begin
  (*
  If (MessageDlg ('Are you sure you want to delete this letter?', mtConfirmation, [mbYes, mbNo], 0) = mrYes) Then Begin
    { delete letter }
    MULCtrlO.GetSelRec(BOff);

    With MiscRecs^, btLetterRec Do
      KeyS := RecMfix + SubType + CustomKey;
    Status := Find_Rec (B_GetEq, F[Fnum], Fnum, RecPtr[Fnum]^, KeyPath, KeyS);
    If (Status = 0) Then Begin
      Ok:=GetMultiRec(B_GetDirect, B_MultLock, KeyS, KeyPath, Fnum, BOn, Locked);
      Status := Delete_Rec(F[Fnum],Fnum,KeyPath);

      If (Status = 0) Then Begin
        { Delete actual document }
        DocPath := FullDocPath + MiscRecs^.btLetterRec.LtrPath;
        If Not DeleteFile(PCHAR(DocPath)) Then
          { Delete of doc failed }
          MessageDlg ('Error: Could not delete ' + Trim(DocPath), mtInformation, [mbOk], 0);
      End; { If }

      Report_Berror (Fnum, Status);
    End; { If }

    With MUlCtrlO Do Begin
      PageUpDn(0, BOn);

      If (PageKeys^[0] = 0) Then
        InitPage;
    End; { With }
  End; { If }
  *)
end;

{ edit description information }
procedure TReportRec.LDescBtnClick(Sender: TObject);
begin
  (*
  MULCtrlO.GetSelRec(BOff);

  ViewLetterDescr (MiscRecs^);

  With MULCtrlO Do
    AddNewRow(MUListBoxes[0].Row, Bon);
  *)
end;

procedure TReportRec.LAddBtnClick(Sender: TObject);
Var
  Version : btLetterDocType;
  Res     : Byte;

  CDir    : String;

begin
  (*
  If (LtrCustCode <> '') Then
  Begin
    Version := DocWord95;

    GetDir(0,CDir);

    Case Version Of
      DocWord95 : Res := AddWordLetter (LtrCustCode, Cust);
    End; { Case }

    ChDir(CDir);

    If (Res <> 0) Then
      DispLetterError (Res);

    { Update for add }
    With MULCtrlO Do
      AddNewRow(MUListBoxes[0].Row, Boff);
  End; { If }
  *)
end;

{ Called whenever the Tab Page is changed }
procedure TReportRec.PageControl1Change(Sender: TObject);
Var
  NewIndex : SmallInt;
begin
  If (Sender is TPageControl) Then
    With Sender as TPageControl do Begin
      NewIndex:=pcLivePage(Sender);

      If (NewIndex In [0]) Then
        LockWindowUpdate (0);

      If (NewIndex In ListPages) Then Begin
        { Move Btrieve Scroll button panel to new page }
        MListBtnPanel.Parent := PageControl1.ActivePage;
      End; { If }

      PrimeButtons;

      Case NewIndex Of
        HeadPage  : Begin { Header }
                      ;
                    End;
        MiscPage  : Begin
                      ;
                    End;
        RepPage   : Begin { Report Lines }
                      If (MULCtrlO[NewIndex]=nil) then Begin
                        { First time in - create list }
                        FormBuildList(BOn);
                      End { If }
                      Else
                        With EXLocal Do Begin
                           {If (Not CheckKey(LStock.StockCode,MULCtrlO[NewIndex].KeyRef,StkKeyLen,BOn)) then}
                             RefreshList(BOn,BOff);

                           MULCtrlO[NewIndex].ReFresh_Buttons;
                        End; { With }


                      MULCtrlO[NewIndex].SetListFocus;
                    End;
        NomPage   : Begin { Nominal Lines }
                      If (MULCtrlO[NewIndex]=nil) then Begin
                        { First time in - create list }
                        BuildNomList(BOn);
                      End { If }
                      Else
                        With EXLocal Do Begin
                           {If (Not CheckKey(LStock.StockCode,MULCtrlO[NewIndex].KeyRef,StkKeyLen,BOn)) then}
                             RefreshList(BOn,BOff);

                           MULCtrlO[NewIndex].ReFresh_Buttons;
                        End; { With }

                      MULCtrlO[NewIndex].SetListFocus;
                    End;
        InpPage   : Begin { Input Lines }
                      If (MULCtrlO[NewIndex]=nil) then Begin
                        { First time in - create list }
                        BuildInpList(BOn);
                      End { If }
                      Else
                        With EXLocal Do Begin
                           {If (Not CheckKey(LStock.StockCode,MULCtrlO[NewIndex].KeyRef,StkKeyLen,BOn)) then}
                             RefreshList(BOn,BOff);

                           MULCtrlO[NewIndex].ReFresh_Buttons;
                        End; { With }

                      MULCtrlO[NewIndex].SetListFocus;
                    End;
        NotePage  : Begin { Notes }
                      If (MULCtrlO[NewIndex]=nil) then Begin
                        { First time in - create list }
                        BuildNoteList(BOn);
                      End { If }
                      Else
                        With EXLocal Do Begin
                           {If (Not CheckKey(LStock.StockCode,MULCtrlO[NewIndex].KeyRef,StkKeyLen,BOn)) then}
                             RefreshList(BOn,BOff);

                           MULCtrlO[NewIndex].ReFresh_Buttons;
                        End; { With }

                      MULCtrlO[NewIndex].SetListFocus;
                    End;
      End; { Case }

      LockWindowUpdate (0);

      FormResize(Sender);
    End; { With }
end;

{ Returns the index of the current Tab Page }
Function TReportRec.Current_Page : Integer;
Begin
  Result:=pcLivePage(PageControl1);
end;


{ Called by RepTree to set the Tab Page }
Procedure TReportRec.ChangePage(NewPage  :  Integer);
Begin
  If (Current_Page <> NewPage) then
    With PageControl1 do
      If (Pages[NewPage].TabVisible) then Begin
        ActivePage:=Pages[NewPage];

        PageControl1Change(PageControl1);
      End; { If }
end;


{ Displays the report details }
Procedure TReportRec.OutReport;
Var
  I, J : SmallInt;
Begin
  With ExLocal, LRepGen^, ReportHed Do Begin
    { Hide tabs where necessary }
    TabSheet1.TabVisible  := ChkAllowed_In (194);
    TabSheet6.TabVisible  := ChkAllowed_In (194) And (RepType In ['N', 'R']);
    TabSheet2.TabVisible  := ChkAllowed_In (194) And (RepType In ['N', 'R']) And (DDFormMode.NHMode <> 0);
    TabSheet3.TabVisible  := ChkAllowed_In (194) And (RepType = 'N') And (DDFormMode.NHMode <> 0);
    TabSheet4.TabVisible  := ChkAllowed_In (194) And (RepType In ['N', 'R']) And (DDFormMode.NHMode <> 0);
    TabSheet5.TabVisible  := (RepType In ['N', 'R']) And (DDFormMode.NHMode <> 0);

    { Change Controls where necessary }
    {RpName.ReadOnly := (Trim(RepName) <> '');}

    { Display Fields }
    RpName.Text := Trim(RepName);
    RpHed.Text  := Trim(RepGroup);
    RpDesc.Text := Trim(RepDesc);
    Case RepType Of
      'H' : RpType.ItemIndex := 0;
      'N' : RpType.ItemIndex := 2;
      'R' : RpType.ItemIndex := 1;
    End; { Case }
    RpTypeClick(Self);

    { File }
    Try
      If (RpFile.Items.Count > 0) And (DriveFile > 0) Then Begin
        For I := 0 To (RpFile.Items.Count - 1) Do
          If (DataFilesL^[DriveFile] = RpFile.Items.Strings[I]) Then Begin
            RpFile.ItemIndex := I;
            Break;
          End; { If }
      End { If }
      Else
        RpFile.ItemIndex := 0;

      RpFileClick(Self);
    Except
      On Exception Do ;
    End;

    { Search Path }
    RpSearch.ItemIndex := DrivePath;
    (*
    Try
      If RpSearch.Enabled And (RpSearch.Items.Count > 0) And (DriveFile > 0) Then Begin
        If (DrivePath = 0) Then
          { Sequential }
          RpSearch.ItemIndex := 0
        Else Begin
          { Indexed - find Index id in array }
          For I := 1 To High(FastNDXOrdL^[DriveFile]) Do
            If ((DriveFile = 3) And (I In [1..13])) Or ((DriveFile = 4) And (I In [1..18])) Then
              If (FastNDXOrdL^[DriveFile, I] = DrivePath) Then Begin
                { found index in array - now find and select in list }
                For J := 0 To (RpSearch.Items.Count - 1) Do
                  If (FastNDXHedL^[DriveFile, I] = RpSearch.Items.Strings[J]) Then Begin
                    RpSearch.ItemIndex := J;
                    Break;
                  End; { If }

                Break;
              End; { If }
        End; { Else }
      End; { If }

      RpSearchClick(Self);
    Except
      On Exception Do ;
    End;
    *)

    { Input Line }
    RpInp.Value := FNDXInpNo;

    { Output To }
    RpPrn.Checked := (RepDest = 1);
//    RpCSV.Checked := Not RpPrn.Checked;
    RpCSV.Checked := RepDest = 2;
    RpDBF.Checked := RepDest = 3;

    { Test Mode }
    RpTest.Checked := TestMode;
    RpSamp.Enabled := RpTest.Enabled And RpTest.Checked;

    { Sample Count }
    RpSamp.Value := SampleNo;

    { Refresh Start/End }
    RpRStart.Checked := RefreshPos;
    RpREnd.Checked := RefreshEnd;

    { Default Font }
    If (Strip('B', [#0,#32], DefFont.fName) = '') Then
      CopyFont (TmpFontLbl.Font, DefFont, True);   { Set font to default font }

    CopyFont (FontLbl1.Font, DefFont, False); { copy font to labels }
    CopyFont (FontLbl2.Font, DefFont, False); { copy font to labels }

    { Global Report Selection }
    RpGlob.Text := RepSelect;

    { Paper Orientation }
    RpPort.Checked := (PaprOrient = 'P');
    RpLand.Checked := Not RpPort.Checked;

    { Space between columns }
    RpColSpc.Value := ColSpace;

    { Report Width }
    UpdRepWidth (MaxWidth);

    { HM 09/03/00: Added password }
    lblPwordStatus.Caption := 'Password: ';
    If (Pword <> '') Then
      lblPwordStatus.Caption := lblPwordStatus.Caption + 'Set'
    Else
      lblPwordStatus.Caption := lblPwordStatus.Caption + 'Not Set';

    { HM 13/03/00: Added Info Report }
    chkInfoRep.Checked := PrnInpData;

    GetCommandRec;
    chkCSVTotals.Checked := CSVTotals;

  End; { With }
End;


{  Adds / Edits a report }
Procedure TReportRec.EditRep (Const Edit : Boolean);
Begin
  With ExLocal Do Begin
    LastEdit:=Edit;

    DDFormMode.NHMode := Ord(Edit);

    If (Not Edit) then
      ChangePage(0);

    ProcessReport(RepGenF,CurrKeyPath^[RepGenF],LastEdit);
  end;
End;


{ Deletes an existing report }
Procedure TReportRec.DeleteRep;
Const
  Fnum  =  RepGenF;
Var
  MbRet  :  Word;
  KeyS   :  Str255;
  Keypath:  Integer;
Begin

  { need to display record here }
  SetRepStore(BOff,BOff);
  OutReport;

  MbRet:=MessageDlg('Please confirm you wish'#13+'to delete this Report',
                     mtConfirmation,[mbYes,mbNo],0);


  If (MbRet=MrYes) Then Begin
    DeleteRepLines(ExLocal.LRepGen^.ReportHed.RepName);

    { Update Tree }
    Send_UpdateList(200, 0);

    Close;
  End { If }
  Else
    PostMessage (Self.Handle, WM_CLOSE, 0, 0);
End;


Procedure TReportRec.WMGetMinMaxInfo(Var Message  :  TWMGetMinMaxInfo);
Begin
  With Message.MinMaxInfo^ do Begin
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


procedure TReportRec.PageControl1Changing(Sender: TObject;
  var AllowChange: Boolean);
begin
  AllowChange:=Not StopPageChange;

  If AllowChange Then Begin
    Release_PageHandle(Sender);
    LockWindowUpDate(Handle);
  End; { If }
end;

Procedure TReportRec.ViewRep;
Begin
  {  }
End;

Procedure TReportRec.ViewNotes;
Begin
  ChangePage(NotePage);
End;

procedure TReportRec.ProcessReport(Fnum, KeyPath : Integer;
                                   Edit          : Boolean);
Var
  KeyS     :  Str255;
  n        :  Integer;
Begin
  Addch:=ResetKey;

  KeyS:='';

  RKeypath:=Keypath;

  Elded:=Edit;

  If Edit Then Begin
    With ExLocal Do Begin
      LSetDataRecOfs(Fnum,LastRecAddr[Fnum]); {* Retrieve record by address Preserve position *}

      Status:=GetDirect(F[Fnum],Fnum,LRecPtr[Fnum]^,KeyPAth,0); {* Re-Establish Position *}

      Report_BError(Fnum,Status);

      Ok:=LGetMultiRec(B_GetDirect,B_MultLock,KeyS,KeyPAth,Fnum,BOff,GlobLocked);
    End; { With }

    If (Not Ok) or (Not GlobLocked) then
      AddCh:=#27;
  End { If }
  Else Begin
    {HideDAdd:=BOn;}
    BuildDesign;
  End; { Else }

  If (Addch<>#27) Then
    With ExLocal, LRepGen^ Do Begin
      If (Not Edit) Then Begin
        { Adding a report }
        Caption:='Add Report Record';
        LResetRec(Fnum);

        { Set default values here }
        RecPFix := ReportGenCode;
        SubType := RepGroupCode;
        With ReportHed Do Begin
          RepGroup := RepParent;
          RepType  := 'R';
          DriveFile := 1;
          DrivePath := 0;
          RepDest := 1;
          RepPgLen := 66;
          RefreshPos := True;
          RefreshEnd := True;
          PaprOrient := 'P';

          RLineCount := 1;
          HLineCount := 1;
          ILineCount := 1;
          MLineCount := 1;
          NLineCount := 1;

          ColSpace   := 3;
        End; { With }

        CanDelete:=BOn;
      End; { If }


      OutReport;

      LastRepGen^:=LRepGen^;

      SetRepStore(BOn,BOff);

      SetFieldFocus;
    End; { With }
End;

procedure TReportRec.SetFieldFocus;
Begin
  Case Current_Page Of
    HeadPage : Begin
                 If ExLocal.LastEdit Then Begin
                   If RpDesc.CanFocus Then
                     RpDesc.SetFocus
                 End { If }
                 Else
                   If RpName.CanFocus Then
                     RpName.SetFocus;
               End;
    MiscPage : Begin
                 If FontBtn.CanFocus Then
                   FontBtn.SetFocus;
               End;
  End; { Case }
End;

procedure TReportRec.SetRepStore(EnabFlag, ButnFlg  :  Boolean);
Var
  Loop  :  Integer;

  { Returns True if their are no child reports for this Group }
  Function NoBrats(Const RepName : ShortString) : Boolean;
  Const
    FNum    = RepGenF;
    KeyPath = RGK;
  Var
    KeyS, KeyChk : Str255;
  Begin
    KeyChk := FullRepKey_NDX (ReportGenCode, RepGroupCode, RepName);
    KeyS := KeyChk;

    Status:=Find_Rec(B_GetGEq,F[Fnum],Fnum,RecPtr[Fnum]^,KeyPath,KeyS);

    Result := Not (StatusOk And CheckKey(KeyChk,KeyS,Length(KeyChk),BOn));
  End;

Begin
  OkRPBtn.Enabled:=EnabFlag;
  CanCP1Btn.Enabled:=EnabFlag;

  AddBtn.Enabled:=Not EnabFlag;
  EditBtn.Enabled:=Not EnabFlag;
  InsBtn.Enabled:=Not EnabFlag;
  DelBtn.Enabled:=Not EnabFlag;
  FindBtn.Enabled:=Not EnabFlag;
  PrintBtn.Enabled:=Not EnabFlag;
  LayoutBtn.Enabled:=Not EnabFlag;
  CopyBtn.Enabled:=Not EnabFlag;
  ImpExpBtn.Enabled:=Not EnabFlag;

  ExLocal.InAddEdit:=EnabFlag;

  For Loop:=0 to ComponentCount-1 do Begin
    SetCompRO(Components[Loop],1,EnabFlag);
  end;

  With ExLocal do Begin
    RpName.ReadOnly:=((Not Enabled) or (Not CanDelete) and ((Not InAddEdit) or (LastEdit)));

    With LRepGen^, ReportHed Do Begin
      RpType.ReadOnly := (Not RpType.Enabled) Or
                         (Not InAddEdit) Or
                         (LastEdit And (RepType = 'H') And (Not NoBrats(RepName)));

      RpTypeClick(Self);
      (*
      If RpType.ReadOnly And (RepType = 'H') Then Begin
        SBSGroup2.Enabled := False;
        SBSGroup3.Enabled := False;

        RpFile.Enabled := False;
        RpSearch.Enabled := False;
        RpInp.Enabled := False;
        RpPrn.Enabled := False;
        RpCSV.Enabled := False;
        RpTest.Enabled := False;
        RpSamp.Enabled := False;
        RpRStart.Enabled := False;
        RpREnd.Enabled := False;
      End; { If }
      *)

      If EnabFlag Then Begin
        RpFileClick(Self);
        RpSearchClick(Self);

        { Sample Count is only available when Test Mode is selected }
        RpSamp.Enabled := RpTest.Enabled And RpTest.Checked;
      End; { If }
    End; { With }
  End; { With }
end;

procedure TReportRec.SetCompRO(      TC      : TComponent;
                               Const TG      : Integer;
                               Const EnabFlg : Boolean);
Begin
  If (TC is TMaskEdit) then
    With (TC as TMaskEdit) do Begin
      If (Tag=TG) then
        ReadOnly:= Not EnabFlg;
    End { With }
  Else
    If (TC is TCurrencyEdit ) then
      With (TC as TCurrencyEdit) do Begin
        If (Tag=TG) then
          ReadOnly:= Not EnabFlg;
      End { With }
    Else
      If (TC is TBorCheck) then
        With (TC as TBorCheck) do Begin
          If (Tag=TG) then
            Enabled:=EnabFlg;
        End { With }
      Else
        If (TC is TBorRadio) then
          With (TC as TBorRadio) do Begin
            If (Tag=TG) then
              Enabled:=EnabFlg;
          End { With }
        Else
          If (TC is TSBSComboBox) then
            With (TC as TSBSComboBox) do Begin
              If (Tag=TG) then
                ReadOnly:=Not EnabFlg;
            End { With }
          Else
            If (TC is TButton) then
              With (TC as TButton) do Begin
                If (Tag=TG) then
                  Enabled:=EnabFlg;
              End; { With }
end;

procedure TReportRec.ClsCP1BtnClick(Sender: TObject);
begin
  If ConfirmQuit then Begin
    {ManClose:=BOn;}
    Close;
  end;
end;

Function TReportRec.ConfirmQuit  :  Boolean;
Var
  MbRet  :  Word;
  TmpBo  :  Boolean;
Begin
  TmpBo:=BOff;

  If ExLocal.InAddEdit and CheckNeedStore then Begin
    If (Current_Page>1) then {* Force view of main page *}
      ChangePage(0);

    mbRet:=MessageDlg('Save changes to '+DoubleAmpers(Caption)+'?',mtConfirmation,[mbYes,mbNo,mbCancel],0);
  end
  else
    mbRet:=mrNo;

  Case MbRet of
    mrYes  :  Begin
                StoreReport(RepGenF,RKeypath,ExLocal.LastEdit);
                TmpBo:=(Not ExLocal.InAddEdit);
              end;

    mrNo   :  With ExLocal do
              Begin
                If (LastEdit) then
                  Status:=UnLockMLock(RepGenF,0);

                If (InAddEdit) then
                  SetRepStore(BOff,LastEdit);

                TmpBo:=BOn;
              end;

    mrCancel
           :  Begin
                TmpBo:=BOff;
                SetfieldFocus;
              end;
  end; {Case..}

  Result := TmpBo;
end; {Func..}

Function TReportRec.CheckNeedStore  :  Boolean;
Var
  Loop  :  Integer;
Begin
  Result:=BOff;
  Loop:=0;

  While (Loop<=Pred(ComponentCount)) and (Not Result) do Begin
    If (Components[Loop] is TMaskEdit) then
      With (Components[Loop] as TMaskEdit) do Begin
        Result:=((Tag=1) and (Modified));

        If (Result) then
          Modified:=BOff;
      End { With }
    Else
      If (Components[Loop] is TCurrencyEdit) then
        With (Components[Loop] as TCurrencyEdit) do Begin
          Result:=((Tag=1) and (FloatModified));

          If (Result) then
            FloatModified:=BOff;
        End { With }
      Else
        If (Components[Loop] is TBorCheck) then
          With (Components[Loop] as TBorCheck) do Begin
            Result:=((Tag=1) and (Modified));

            If (Result) then
              Modified:=BOff;
          End { With }
        Else
          If (Components[Loop] is TSBSComboBox) then
            With (Components[Loop] as TSBSComboBox) do Begin
              Result:=((Tag=1) and (Modified));

              If (Result) then
                Modified:=BOff;
            End; { With }

    Inc(Loop);
  end; {While..}
end;


{ Called to rename all detail lines when the report code is changed }
Procedure TReportRec.RenameLines(OKeyPath : Integer);
Const
  FNum              = RepGenF;
  KeyPath : Integer = RGNdxK;
Var
  TmpRep        : ^RepGenRec;
  KeyS, oKey    : Str255;
  {TmpFn         : FileVar;
  TmpStat       : Integer;
  TmpRecAddr    : LongInt;}
  RName, oRName : String[10];
  TmpAddr       : LongInt;

  Procedure rwChangeLinks (OCode, NCode : AnyStr;
                           Fnum         : Integer;
                           KLen         : Integer;
                           KeyPth       : Integer);
  Var
    KeyS  :  AnyStr;
    Locked:  Boolean;
    B_Func:  Integer;
    LAddr :  LongInt;
  Begin
    With ExLocal, LRepGen^ Do Begin
      KeyS:=OCode;

      B_Func:=B_GetNext;

      Status:=Find_Rec(B_GetGEq,F[Fnum],Fnum,LRecPtr[Fnum]^,Keypth,KeyS);

      While CheckKey(OCode,KeyS,KLen,BOn) and (Status = 0) Do Begin
        Ok:=LGetMultiRec(B_GetDirect, B_MultLock, KeyS, KeyPth, Fnum, BOn, Locked);

        If (RecPFix = ReportGenCode) Then
          Case SubType Of
            RepRepCode  : With ReportDet Do Begin { Report Lines }
                            RepName := NCode;
                            ReportKey := RepName + VarType + RepPadNo;
                          End;
            RepNomCode  : With ReportNom Do Begin { Nominal Lines }
                            RepName := NCode;
                            ReportKey := RepName + VarType + RepPadNo;
                          End;
            RepLineTyp  : With ReportDet Do Begin { Input Lines }
                            RepName := NCode;
                            ReportKey := RepName + VarType + RepPadNo;
                          End;
          End { Case }
        Else
          If (RecPFix = RepNoteType) Then
            { Notes }
            With RNotesRec Do Begin
              NoteFolio := NCode;
              NoteNo := NoteFolio + NType + SetPadNo(Form_Int(LineNo, 0), 4);
            End; { With }

        If Ok And Locked Then Begin
          Status:=Put_Rec(F[Fnum],Fnum,LRecPtr[Fnum]^,KeyPth);

          { unlock multiple-lock lock }
          ExLocal.UnLockMLock(Fnum,LastRecAddr[Fnum]);

          B_Func:=B_GetGEq;
          KeyS := OCode;
        End { If }
        Else
          B_Func:=B_GetNext;

        Status:=Find_Rec(B_Func,F[Fnum],Fnum,LRecPtr[Fnum]^,Keypth,KeyS);

        If (Debug) then Status_Means(Status);
      End; { While }
    End; { With }
  End; { rwChangeLinks }

Begin
  With ExLocal Do Begin
    { Save record }
    New (TmpRep);
    TmpRep^:=LRepGen^;
    TmpAddr := LastRecAddr[Fnum];

    oRName := FullRepCode (ExLocal.LastRepGen^.ReportHed.RepName);
    KeyS := FullRepCode (ExLocal.LRepGen^.ReportHed.RepName);

    { Report Lines }
    oKey := FullRepKey_NDX(ReportGenCode, RepRepCode, oRName);
    rwChangeLinks (oKey, KeyS, RepGenF, Length(oKey), RGK);

    { Nominal Lines }
    oKey := FullRepKey_NDX(ReportGenCode, RepNomCode, oRName);
    rwChangeLinks (oKey, KeyS, RepGenF, Length(oKey), RGK);

    { Input Lines }
    oKey := FullRepKey_NDX(ReportGenCode, RepLineTyp, oRName);
    rwChangeLinks (oKey, KeyS, RepGenF, Length(oKey), RGK);

    { Notes }
    oKey := FullRepKey_NDX(RepNoteType, RepNoteCode, oRName);
    rwChangeLinks (oKey, KeyS, RepGenF, Length(oKey), RGK);

    { CommandLine }
    oKey := FullRepKey_NDX(ReportGenCode, RepCommandType, oRName);
    rwChangeLinks (oKey, KeyS, RepGenF, Length(oKey), RGK);

    { Restore Record }
    If (TmpAddr<>0) Then Begin
      LastRecAddr[Fnum] := TmpAddr;
      LSetDataRecOfs(Fnum,LastRecAddr[Fnum]);
      Status:=GetDirect(F[Fnum],Fnum,LRecPtr[Fnum]^,OKeyPath,0); {* Re-Establish Position *}
      LRepGen^:=TmpRep^;
    End; { If }

    Dispose (TmpRep);
  End; { With }
End;


procedure TReportRec.StoreReport(Fnum, KeyPAth : Integer;
                                 Edit          : Boolean);
Var
  COk    : Boolean;
  TmpRep : RepGenRec;
  KeyS   : Str255;
  MbRet  : Word;
  Moved  : Byte;
Begin
  KeyS:='';

  Form2Report;

  With ExLocal, LRepGen^, ReportHed do
  Begin
    {Moved := (Not Edit) Or (LastRepGen^.ReportHed.ReportKey <> ReportKey);}

    If (Not Edit) Then
      { Added }
      Moved := 1
    Else
      If (LastRepGen^.ReportHed.ReportKey <> ReportKey) Then
        { Parent Changed }
        Moved := 2
      Else
        { Updated }
        Moved := 3;

    If (Edit) and (LastRepGen^.ReportHed.RepName <> RepName) then
    Begin
      COK := Not CheckExsists(FullRepKey_RGK(RecPFix, SubType, RepName),RepGenF,RGNdxK);

      If (Not COK) Then
        MessageDlg('That Report already exists!', mtWarning, [mbOk], 0);
    End
    else
      COk:=BOn;

    If (COk) then
      COk:=CheckCompleted(Edit);

    If (COk) then
    Begin
      COk:=(Not EmptyKey(ReportHed.RepName,RpName.MaxLength));

      If (Not COk) then
        mbRet:=MessageDlg('Report Name not valid!',mtError,[mbOk],0);
    end;

    If COk Then Begin
      If Edit Then Begin
        {* Re-establish position prior to storing *}
        If (LastRecAddr[Fnum]<>0) Then Begin
          TmpRep:=LRepGen^;

          LSetDataRecOfs(Fnum,LastRecAddr[Fnum]);

          Status:=GetDirect(F[Fnum],Fnum,LRecPtr[Fnum]^,KeyPAth,0); {* Re-Establish Position *}

          LRepGen^:=TmpRep;
        End; { If }

        Status:=Put_Rec(F[Fnum],Fnum,LRecPtr[Fnum]^,KeyPAth);

        If StatusOK And (LastRepGen^.ReportHed.RepName <> RepName) Then
          RenameLines(KeyPath);
      End
      Else Begin
        Status:=Add_Rec(F[Fnum],Fnum,LRecPtr[Fnum]^,KeyPAth);
        CanDelete:=BOn;
      End; { Else }

      //PR: 20/05/02 Added facility for command line for dbf files
      if (LRepGen^.ReportHed.RepDest = 3) and
         (Trim(extDBFCommand.Text) <> '') then
            SaveCommandRec;


      SetCaption;

      Report_BError(Fnum,Status);

      LGetRecAddr(Fnum);  {* Refresh record address *}

      If (StatusOk) then
        Send_UpdateList(0, Moved);

      If (Edit) then
        ExLocal.UnLockMLock(Fnum,LastRecAddr[Fnum]);

      SetRepStore(BOff,Edit);

      CStock^:=LStock;

      Cursor:=CrDefault;

      LastValueObj.UpdateAllLastValues(Self);

      If (ExLocal.LRepGen^.ReportHed.RepType <> 'H') Then Begin
        { Change to view mode }
        DDFormMode.NHMode := 3;
        BuildDesign;
      End { If }
      Else
        PostMessage (Self.Handle, WM_Close, 0, 0);
    End
    Else Begin
      SetFieldFocus;
    End; { Else }
 end; {If..}

end;

{ copies input info into report record }
Procedure TReportRec.Form2Report;
Begin
  With ExLocal.LRepGen^, ReportHed Do Begin
    { Report Name }
    RepName := FullRepCode(RpName.Text);

    { Parent Group }
    RepGroup  := FullRepCode(RpHed.Text);

    { Report Descriptions}
    RepDesc := Trim(RpDesc.Text);

    { Report Type }
    Case RpType.ItemIndex Of
      0 : RepType := 'H';
      2 : RepType := 'N';
      1 : RepType := 'R';
    End; { Case }

    { Driving File }
    DriveFile := GetDriveFile;

    { Search Index }
    DrivePath := GetDrivePath;

    { Input Link }
    FNDXInpNo := Round(RpInp.Value);

    { Output To }
    If RpPrn.Checked Then
      RepDest := 1
    Else
    if RpCSV.Checked then
      RepDest := 2
    else
      RepDest := 3;

    { Test Mode }
    TestMode := RpTest.Checked;

    { Sample Count }
    SampleNo := Round(RpSamp.Value);

    { Refresh Start/End }
    RefreshPos := RpRStart.Checked;
    RefreshEnd := RpREnd.Checked;

    { Miscellaneous Tab }
    { Font }
    CopyFont (FontLbl1.Font, DefFont, True);

    { Global Report Selection }
    RepSelect := RpGlob.Text;

    { Paper Orientation }
    If RpPort.Checked Then
      PaprOrient := 'P'
    Else
      PaprOrient := 'L';

    { Space between columns }
    If (Round(RpColSpc.Value) In [0..99]) Then
      ColSpace := Round(RpColSpc.Value)
    Else
      ColSpace := 0;

    { HM 13/03/00: Added Info Report }
    PrnInpData := chkInfoRep.Checked;

    { Rebuild ReportKey }
    RecPFix := ReportGenCode;
    SubType := RepHedTyp;

    ReportKey := RepGroup + RepName;

    CSVTotals := chkCSVTotals.Checked;
  End; { With }
End;


Function TReportRec.CheckCompleted (Edit  :  Boolean)  : Boolean;
Const
  NofMsgs      =  10;
Type
  PossMsgType  = Array[1..NofMsgs] of Str80;
Var
  PossMsg   : ^PossMsgType;
  Test      : Byte;
  n, mbRet  : Word;
  FoundCode : Str20;
  FoundLong : LongInt;
Begin
  New(PossMsg);

  FillChar(PossMsg^,Sizeof(PossMsg^),0);

  PossMsg^[1]:='That Report Name already exists.';
  PossMsg^[2]:='That Type is not valid.';
  PossMsg^[3]:='That Heading is not valid.';
  PossMsg^[4]:='The Description cannot be blank.';
  PossMsg^[5]:='The Main File is not valid.';
  PossMsg^[6]:='The Search Path is not valid.';
  PossMsg^[7]:='The Input Link is not valid.';
  PossMsg^[8]:='The Output Destination is not valid.';
  PossMsg^[9]:='The Column Space must be in the range 0 to 99mm';
  PossMsg^[10]:='The Sample Count must be greater than 0';

  Test:=1;

  Result:=BOn;

  While (Test<=NofMsgs) And (Result) Do
    With ExLocal, LRepGen^, ReportHed Do Begin
      Case Test of

        1  :  Begin
                If (Not Edit) then Begin
                  FoundCode := FullRepKey_RGK(RecPFix, SubType, RepName);
                  Result:=Not (CheckExsists(FoundCode, RepGenF, RGNdxK))
                End { If }
                else
                  Result:=BOn;
              end;

        2  :  Result:=(RepType In [RepGroupCode, RepNomCode, RepRepCode]);

        3  :  If (Trim(RepGroup) <> '') Then Begin
                { Check heading exists }
                Result:=CheckExsists(FullRepKey_RGK(RecPFix, SubType, RepGroup),RepGenF,RGNdxK);

                { Check its not screwing itself }
                Result := (Trim(RepGroup) <> Trim(RepName));
              End { If }
              Else
                Result:=BOn;

        4  :  Result:= (Trim(RepDesc) <> '');

        5  :  If (RepType <> RepGroupCode) Then
                Result := (DriveFile In [1..High(DataFilesL^)])
              Else
                Result := BOn;

        6  :  If (RepType <> RepGroupCode) And (DriveFile In [3, 4]) Then Begin
                { Check Search key }
                Result := Bon; {((DriveFile = 3) And (DrivePath In [0..13])) Or
                          ((DriveFile = 4) And (DrivePath In [0, 14..31]));}
              End { If }
              Else
                Result := BOn;

              { HM 02/01/98: Removed Validation as Idx No can be left at 0 }
        7  :  (*If (RepType <> RepGroupCode) And RpInp.Enabled And (DriveFile In [3, 4]) Then Begin
                { Check input link is set }
                Result := (FNDXInpNo > 0)
              End { If }
              Else*)
                Result := BOn;

        8  :  If (RepType <> RepGroupCode) Then
                Result := (RepDest In [1, 2, 3])
              Else
                Result := BOn;
        9  :  Result := (Round(RpColSpc.Value) In [0..99]);

        { Sample Count }
        10 :  If RpSamp.Enabled Then
                Result := (RpSamp.Value > 0)
              Else
                Result := BOn;
      End; { Case }

      If Result then
        Inc(Test);
    End; { With }

  If (Not Result) then
    mbRet:=MessageDlg(PossMsg^[Test],mtWarning,[mbOk],0);

  Dispose(PossMsg);
End; { CheckCompleted }

{ returns the file number of the currently selected file }
Function TReportRec.GetDriveFile : Integer;
Var
  I : SmallInt;
Begin
  Result := 1;

  For I := 1 To High(DataFilesL^) Do
    If (RpFile.Text = DataFilesL^[I]) Then Begin
      Result := I;
      Break;
    End; { If }
End;

{ returns the file number of the currently selected file }
Function TReportRec.GetDrivePath : Integer;
Var
  FileNo, I : SmallInt;
Begin { GetDrivePath }
  Result := RpSearch.ItemIndex;
  If (Result = -1) Then Result := 0;
  (*
  Result := 0;

  FileNo := GetDriveFile;

  If (FileNo In [3, 4]) And (RpSearch.ItemIndex > 0) Then Begin
    { Identify selected Path }
    For I := Low (FastNDXHedL^[FileNo]) To High(FastNDXHedL^[FileNo]) Do
      If ((FileNo = 3) And (I In [0..13])) Or ((FileNo = 4) And (I In [0..18])) Then
        If (FastNDXHedL^[FileNo, I] = RpSearch.Text) Then Begin
          Result := FastNDXOrdL^[FileNo, I];
          Break;
        End; { If }
  End; { If }
  *)
End;  { GetDrivePath }


procedure TReportRec.RpFileClick(Sender: TObject);
Var
  I, FileNo : Integer;
begin
  { Identify selected file }
  FileNo := GetDriveFile;

  { Do any changes to the search list required by selected file }
  RpSearch.Enabled := (FileNo In [3, 4, 23]);
  If RpSearch.Enabled Then Begin
    { Check to see if we need to reload the list }
    If (SearchSet <> FileNo) Then Begin
      Try
        RpSearch.Items.Clear;

        For I := Low (FastNDXHedL^[FileNo]) To High(FastNDXHedL^[FileNo]) Do
          If ((FileNo = 3) And (I In [0..{$IFDEF EN550CIS}15{$ELSE}14{$ENDIF}])) Or
             ((FileNo = 4) And (I In [0..20])) Or
             ((FileNo = 23) And (I In [0..18])) Then
            RpSearch.Items.Add (FastNDXHedL^[FileNo,I]);
        RpSearch.ItemIndex := 0;

        SearchSet := FileNo;
      Except
        SearchSet := -1;
      End;
    End;
  End { If }
  Else Begin
    { Check to see if we need to clear the list }
    If (SearchSet <> -1) Then Begin;
      RpSearch.Items.Clear;
      SearchSet := -1;
    End; { If }
  End; { If }

  RpSearchClick(Sender);
  {RpInp.Enabled := RpSearch.Enabled;
  RpInp.ReadOnly := RpSearch.ReadOnly;}
end;

procedure TReportRec.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  {If Not (Current_Page In ListPages) then}
    GlobFormKeyDown(Sender,Key,Shift,ActiveControl,Handle);
end;

procedure TReportRec.FormKeyPress(Sender: TObject; var Key: Char);
begin
  {If Not (Current_Page In ListPages) then}
    GlobFormKeyPress(Sender,Key,ActiveControl,Handle);
end;

procedure TReportRec.RPNameExit(Sender: TObject);
Var
  COk   :  Boolean;
  CCode :  Str30;
begin
  If (Sender is TMaskEdit) And (Screen.ActiveControl <> CanCP1Btn) And (Not RpName.ReadOnly) then
    With (Sender as TMaskEdit), ExLocal do Begin
      If (Trim(RpName.Text) <> '') Then Begin
        CCode:=FullRepKey_RGK(ReportGenCode, RepGroupCode, Text);

        If ((Not LastEdit) or (LastRepGen.ReportHed.RepName<>FullRepCode(Text))) and InAddEdit then Begin
          { Check to see if code is unique }
          COK := (Not CheckExsists(CCode,RepGenF,RGNdxK));

          If (Not COk) then Begin
            { Its not a valid report code - stay on this page until its ok }
            MessageDlg('That Report already exists!', mtWarning, [mbOk], 0);

            {ChangePage(0);}

            {If RpName.CanFocus Then RpName.SetFocus;}
          End; { If }

          { Report code is valid }
          {StopPageChange:=Not COk;}
        End; { If }
      End { If }
      Else Begin
        { Code is blank }
        MessageDlg('The Report Name cannot be left blank!', mtWarning, [mbOk], 0);

        {ChangePage(0);

        If RpName.CanFocus Then RpName.SetFocus;

        StopPageChange:=BOn;}
      End; { Else }
    End; { With }
end;

procedure TReportRec.RpHedExit(Sender: TObject);
Var
  COk   :  Boolean;
  CCode :  Str30;
  FoundCode : Str20;
begin
  If (Sender is TMaskEdit) And (Screen.ActiveControl <> CanCP1Btn) And (Not RpHed.ReadOnly) Then
    With (Sender as TMaskEdit), ExLocal do Begin
      If (Text <> '') Then Begin
        If GetRep(Self, Text, FoundCode, 0) And (Trim(Text) <> Trim(RpName.Text)) Then Begin
          Text := FoundCode;
        End  { If }
        Else
          MessageDlg('That Heading is not valid', mtWarning,[mbOk],0);
      End; { If }
    End; { With }
end;

procedure TReportRec.OkRPBtnClick(Sender: TObject);
begin
  If (Sender is TButton) then
    With (Sender as TButton) do Begin
      If (ModalResult=mrOk) then
        StoreReport(RepGenF,RGNDXK,ExLocal.LastEdit)
      else
        If (ModalResult=mrCancel) Then Begin
           If (Not ExLocal.LastEdit) then Begin {* Force close..}
             Close;
             Exit;
           End; { If }

          If (ConfirmQuit) then
            With ExLocal Do Begin
              LRepGen^:=LastRepGen^;
              OutReport;
            End; { With }
        End; { If }
    End; { With }
End;

procedure TReportRec.RpDescExit(Sender: TObject);
begin
  If (Sender is TMaskEdit) And (Screen.ActiveControl <> CanCP1Btn) Then
    With (Sender as TMaskEdit), ExLocal do Begin
      If (Trim(Text) = '') Then Begin
        { Cannot be blank }
        MessageDlg('The Description cannot be left blank!', mtWarning,[mbOk],0);

        {ChangePage(0);

        RpDesc.SetFocus;

        StopPageChange:=BOn;}
      End { If }
      Else
        { Report code is invalid - stay on this page until its ok }
        {StopPageChange:=BOff};
    End; { With }
end;

procedure TReportRec.RpFileExit(Sender: TObject);
begin
  If (Sender is TSBSComboBox) And (Screen.ActiveControl <> CanCP1Btn) Then
    With (Sender as TSBSComboBox), ExLocal do Begin
      If (ItemIndex < 0) Then Begin
        { Cannot be blank }
        MessageDlg('The Main File must be set!', mtWarning,[mbOk],0);

        {ChangePage(0);

        RpFile.SetFocus;

        StopPageChange:=BOn;}
      End { If }
      Else
        {StopPageChange:=BOff};
    End; { With }
end;

procedure TReportRec.RpTypeClick(Sender: TObject);
Var
  EnabFlag : Boolean;

  Function IIF (Const BoolCond : Boolean; Const HelpTrue, HelpFalse : LongInt) : LongInt;
  Begin
    If BoolCond Then Result := HelpTrue Else Result := HelpFalse;
  End;

begin
  { en/dis-able the non-header fields }
  {TabSheet2.TabVisible := ExLocal.LastEdit And (RpType.ItemIndex > 0);
  TabSheet3.TabVisible := ExLocal.LastEdit And (RpType.ItemIndex > 0);
  TabSheet4.TabVisible := ExLocal.LastEdit And (RpType.ItemIndex > 0);
  TabSheet5.TabVisible := ExLocal.LastEdit And (RpType.ItemIndex > 0);}

  {
  EnabFlag := (RpType.ItemIndex > 0) And (DDFormMode.NHMode In [0, 1]);
  RpFile.Enabled   := EnabFlag;
  RpSearch.Enabled := EnabFlag;
  RpInp.Enabled    := EnabFlag;
  RpPrn.Enabled    := EnabFlag;
  RpCSV.Enabled    := EnabFlag;
  RpTest.Enabled   := EnabFlag;
  RpSamp.Enabled   := EnabFlag;
  RpRStart.Enabled := EnabFlag;
  RpREnd.Enabled   := EnabFlag;
  }

  { Check in edit mode }
  If (DDFormMode.NHMode In [0, 1]) Then Begin
    { Enable non-group fields if type is enabled and group not selected }
    EnabFlag := RpType.Enabled And (RpType.Text <> RepHedTypesL^[1]);

    {ShowMessage ('GrpEnable: ' + IntToStr(Ord(EnabFlag)));}

    {SBSGroup2.Enabled := EnabFlag;
    SBSGroup3.Enabled := EnabFlag;

    RpFile.Enabled := EnabFlag;
    RpSearch.Enabled := EnabFlag;
    RpInp.Enabled := EnabFlag;
    RpPrn.Enabled := EnabFlag;
    RpCSV.Enabled := EnabFlag;
    RpTest.Enabled := EnabFlag;
    RpSamp.Enabled := RpTest.Checked And EnabFlag;
    RpRStart.Enabled := EnabFlag;
    RpREnd.Enabled := EnabFlag;}

    SBSGroup2.Visible := EnabFlag;
    SBSGroup3.Visible := EnabFlag;

    RpFile.Visible := EnabFlag;
    RpSearch.Visible := EnabFlag;
    RpInp.Visible := EnabFlag;
    RpPrn.Visible := EnabFlag;
    RpCSV.Visible := EnabFlag;
    RpDBF.Visible := EnabFlag;
    RpTest.Visible := EnabFlag;
    RpSamp.Visible := RpTest.Visible And EnabFlag;
    RpRStart.Visible := EnabFlag;
    RpREnd.Visible := EnabFlag;

    TabSheet6.TabVisible  := ChkAllowed_In (194) And EnabFlag;

    { HM 09/03/00: Display password section for groups }
    grpPWord.Visible := Not EnabFlag;
    btnChangePWord.Visible := grpPWord.Visible;
    btnChangePWord.Enabled := grpPWord.Visible;


    RpFile.HelpContext := IIF (EnabFlag, 15900, 15999);
    RpSearch.HelpContext := IIF (EnabFlag, 15901, 15999);
    RpInp.HelpContext := IIF (EnabFlag, 15005, 15999);
    RpPrn.HelpContext := IIF (EnabFlag, 15006, 15999);
    RpCSV.HelpContext := IIF (EnabFlag, 15006, 15999);
    RpDBF.HelpContext := IIF (EnabFlag, 15006, 15999);
    RpTest.HelpContext := IIF (EnabFlag, 15007, 15999);
    RpSamp.HelpContext := IIF (EnabFlag, 15007, 15999);
    RpRStart.HelpContext := IIF (EnabFlag, 15008, 15999);
    RpREnd.HelpContext := IIF (EnabFlag, 15009, 15999);
  End; { If }
end;

procedure TReportRec.DelBtnClick(Sender: TObject);
begin
  Case Current_Page Of
    HeadPage,
    MiscPage  : Begin
                  DeleteRep;
                End;
    RepPage   : Display_RepLine (3);
    NomPage   : Display_NomLine (3);
    InpPage   : Display_InpLine (3);
    NotePage  : Display_NotLine (3);
  End; { Case }
end;

procedure TReportRec.FontBtnClick(Sender: TObject);
begin
  Try
    FontDialog1.Font.Assign(FontLbl1.Font);

    If FontDialog1.Execute Then Begin
      FontLbl1.Font.Assign(FontDialog1.Font);
      FontLbl2.Font.Assign(FontDialog1.Font);
    End; { If }
  Except
    On Exception Do ;
  End;
end;

procedure TReportRec.AddBtnClick(Sender: TObject);
Var
  EditFl : Boolean;
begin
  EditFl := (Sender=EditBtn) Or (Sender=Edit1);

  Case Current_Page Of
    RepPage  : Display_RepLine (1 + Ord(EditFl));
    NomPage  : Display_NomLine (1 + Ord(EditFl));
    InpPage  : Display_InpLine (1 + Ord(EditFl));
    NotePage : Display_NotLine (1 + Ord(EditFl));
  else
    { HeadPage, MiscPage }
    EditRep (EditFl);
  end; {Case..}
end;

procedure TReportRec.FindBtnClick(Sender: TObject);
begin
  Case Current_Page Of
    HeadPage,
    MiscPage  : Begin
                  SendMessage((Owner as TForm).Handle, WM_CustGetRec, 400, 0);
                End;
  End; { Case }
end;


procedure TReportRec.Display_RepLine(Mode  :  Byte);
Var
  WasNew  :  Boolean;
Begin
  WasNew:=BOff;

  { Check we've got a valid line to edit where necessary }
  If (Mode = 1) Or ((Mode <> 1) And MulCtrlO[Current_Page].ValidLine) Then Begin
    If Not Assigned(RepLine) then Begin
      SetRepLineDets(RRefPanel, ExLocal.LRepGen, Mode);
      RepLine := TFrmRepLine.Create(Self);

      WasNew:=BOn;
    End; { If }

    Try
      With RepLine Do Begin
        WindowState:=wsNormal;

        If (Not ExLocal.InAddEdit) Then Begin
          ExLocal.AssignFromGlobal(RepGenF);
          ExLocal.LGetRecAddr(RepGenF);

          (*If WasNew Then Begin
            { Set Colours }
            RlRef.Font.Assign (RRefPanel.Font);
            RlRef.Color :=  RRefPanel.Color;
            SetFieldProperties;
          End; { If }*)

          Case Mode of
            { Add / Edit / Insert }
            1, 2, 4  : EditLine(Mode=2);

            { Delete }
            3        : DeleteRep;
          End { Case }
        End { If }
        Else
          Show;
      End; { With }
    Except
      RepLine.Free;
      RepLine := Nil;
    End;
  End; { If }
end;

procedure TReportRec.Display_NomLine(Mode  :  Byte);
Var
  WasNew  :  Boolean;
Begin
  WasNew:=BOff;

  { Check we've got a valid line to edit where necessary }
  If (Mode = 1) Or ((Mode <> 1) And MulCtrlO[Current_Page].ValidLine) Then Begin
    If Not Assigned(NomLine) then Begin
      SetNomLineDets(NRefPanel, ExLocal.LRepGen, Mode);
      NomLine := TFrmNomLine.Create(Self);

      WasNew:=BOn;
    End; { If }

    Try
      With NomLine Do Begin
        WindowState:=wsNormal;

        If (Not ExLocal.InAddEdit) Then Begin
          ExLocal.AssignFromGlobal(RepGenF);
          ExLocal.LGetRecAddr(RepGenF);

          (*If WasNew Then Begin
            { Set Colours }
            RlRef.Font.Assign (RRefPanel.Font);
            RlRef.Color :=  RRefPanel.Color;
            SetFieldProperties;
          End; { If }*)

          Case Mode of
            { Add / Edit / Insert }
            1, 2, 4  : EditLine(Mode=2);

            { Delete }
            3        : DeleteRep;
          End { Case }
        End { If }
        Else
          Show;
      End; { With }
    Except
      NomLine.Free;
      NomLine := Nil;
    End;
  End; { If }
end;

procedure TReportRec.Display_InpLine(Mode  :  Byte);
Var
  WasNew  :  Boolean;
Begin
  WasNew:=BOff;

  { Check we've got a valid line to edit where necessary }
  If (Mode = 1) Or ((Mode <> 1) And MulCtrlO[Current_Page].ValidLine) Then Begin
    If Not Assigned(InpLine) then Begin
      SetInpLineDets(IVarPanel, ExLocal.LRepGen, Mode);
      InpLine := TFrmInpLine.Create(Self);

      WasNew:=BOn;
    End; { If }

    Try
      With InpLine Do Begin
        WindowState:=wsNormal;

        If (Not ExLocal.InAddEdit) Then Begin
          ExLocal.AssignFromGlobal(RepGenF);
          ExLocal.LGetRecAddr(RepGenF);

          (*If WasNew Then Begin
            { Set Colours }
            RlRef.Font.Assign (RRefPanel.Font);
            RlRef.Color :=  RRefPanel.Color;
            SetFieldProperties;
          End; { If }*)

          Case Mode of
            { Add / Edit / Insert }
            1, 2, 4  : EditLine(Mode=2);

            { Delete }
            3        : DeleteRep;
          End { Case }
        End { If }
        Else
          Show;
      End; { With }
    Except
      InpLine.Free;
      InpLine := Nil;
    End;
  End; { If }
end;

procedure TReportRec.Display_NotLine(Mode  :  Byte);
Var
  WasNew  :  Boolean;
Begin
  WasNew:=BOff;

  { Check we've got a valid line to edit where necessary }
  If (Mode = 1) Or ((Mode <> 1) And MulCtrlO[Current_Page].ValidLine) Then Begin
    If Not Assigned(NotLine) then Begin
      SetNotLineDets(NtNotPanel, ExLocal.LRepGen, Mode);
      NotLine := TFrmNotLine.Create(Self);

      WasNew:=BOn;
    End; { If }

    Try
      With NotLine Do Begin
        WindowState:=wsNormal;

        If (Not ExLocal.InAddEdit) Then Begin
          ExLocal.AssignFromGlobal(RepGenF);
          ExLocal.LGetRecAddr(RepGenF);

          Case Mode of
            { Add / Edit / Insert }
            1, 2, 4  : EditLine(Mode=2);

            { Delete }
            3        : DeleteRep;
          End { Case }
        End { If }
        Else
          Show;
      End; { With }
    Except
      NotLine.Free;
      NotLine := Nil;
    End;
  End; { If }
end;

{ Insert a report field }
procedure TReportRec.InsBtnClick(Sender: TObject);
begin
  Case Current_Page Of
    RepPage  : Display_RepLine (4);
    NomPage  : Display_NomLine (4);
    InpPage  : Display_InpLine (4);
    NotePage : Display_NotLine (4);
  end; {Case..}
end;

procedure TReportRec.UpdRepWidth (Const RepWidth : SmallInt);
Begin
  LblRepWidth.Caption := 'Report Width: ' + Form_Int (RepWidth, 0);
End;

procedure TReportRec.PrintBtnClick(Sender: TObject);
begin
  With ExLocal, LRepGen^, ReportHed Do
    If (SubType = RepHedTyp) And (RepType In [RepRepCode, RepNomCode]) Then
      If (DefFont.fSize = 0) Then Begin
        { Needs converting }
        MessageDlg ('This report needs to be converted before it will print properly.', mtWarning, [mbOk], 0);
      End { If }
      Else
        PrintRWReport (LRepGen^.ReportHed.RepName);
end;

procedure TReportRec.RpTestClick(Sender: TObject);
begin
  If RpTest.Enabled Then
    RpSamp.Enabled := RpTest.Checked;
end;

Procedure TReportRec.WMRWPrint(Var Message  :  TMessage);
begin
  If PrintBtn.Enabled And PrintBtn.CanFocus Then
    PrintBtnClick(Self);
end;

procedure TReportRec.RpSearchClick(Sender: TObject);
Var
  FastObj   : FastNDXOPtr;
  MTExLocal : tdPostExLocalPtr;
  Ena       : Boolean;
begin
  { Enabled Input Link if non-sequential }
  Ena := False;

  If RpSearch.Enabled And (Not RpSearch.ReadOnly) Then Begin
    Ena := (RpSearch.ItemIndex > 0);

    If Ena Then Begin
      MTExLocal:=RepExLocal;

      { Check to see if index requires an Input Link }
      New(FastObj,Init(FastNDXOrdL^[GetDriveFile,GetDrivePath],-1,ExLocal.LRepGen^.ReportHed.RepName, MtExLocal));
      Ena := FastObj^.GetInp;
      Dispose(FastObj,Done);
    End; { If }
  End; { If }

  RpInp.Enabled := Ena;
  RpInp.ReadOnly := RpSearch.ReadOnly;
end;

procedure TReportRec.btnChangePWordClick(Sender: TObject);
Var
  PasswordDlg    : TRWPasswordDialog;
  Abort, DlgRes  : Boolean;
  NewPword       : String[8];
begin
  PasswordDlg := TRWPasswordDialog.Create(Application.MainForm);
  Try
    With ExLocal.LRepGen^.ReportHed, PasswordDlg Do Begin
      Abort := False;

      Caption := 'Change Password';

      { Re-enter existing password }
      If (Trim(Pword) <> '') Then Begin
        MSg := 'Enter Current Password:-';

        { Execute password dialog }
        DlgRes := Execute;

        If DlgRes Then Begin
          Abort := (Pword <> PasswordDlg.Password) And (PasswordDlg.Password <> SysPWord);
          If Abort Then
            MessageDlg ('Incorrect Password, the password cannot be changed', mtError, [mbOk], 0);
        End { If }
        Else
          Abort := True;
      End; { If }

      If (Not Abort) Then Begin
        { Enter new password }
        MSg := 'Enter New Password:-';

        { Execute password dialog }
        DlgRes := Execute;

        If DlgRes Then
          NewPword := Password
        Else
          Abort := True;
      End; { If (Not Abort) }

      If (Not Abort) Then Begin
        { Re-enter new password }
        Msg := 'Re-Enter New Password:-';

        { Execute password dialog }
        DlgRes := Execute;

        If DlgRes Then Begin
          If (Password = NewPword) Then
            Pword := NewPword
          Else
            MessageDlg ('The re-entered password was wrong, password not changed', mtError, [mbOk], 0);
        End { If }
        Else
          Abort := True;
      End; { If (Not Abort) }
    End; { With PasswordDlg }
  Finally
    FreeAndNil(PasswordDlg);
  End;
end;

procedure TReportRec.rpDBFClick(Sender: TObject);
begin
  extDBFCommand.Visible :=  rpDBF.Checked;
  lblDBFCommand.Visible :=  rpDBF.Checked;
  chkCSVTotals.Visible :=   rpCSV.Checked;
end;

function TReportRec.FindCommandRec : Boolean;
var
  KeyS : Str255;
  TmpLck : Boolean;
begin
  With ExLocal Do Begin
    KeyS := FullRepKey_RGK(ReportGenCode, RepCommandType, LRepGen^.ReportHed.ReportKey);
    Result := LGetMultiRec(B_GetEq,B_MultLock,KeyS,RGK,RepGenF,BOff,TmpLck);
  end;
end;

procedure TReportRec.GetCommandRec;
var
  KeyS : Str255;
begin
  With ExLocal Do Begin
  //Store existing position in file

  //Find (or not) existing commandrec
    DBFCmdLineExists := FindCommandRec;
    if DBFCmdLineExists then
      extDBFCommand.Text := Trim(LRepGen^.RCommand.Command);
  //Restore position
      LSetDataRecOfs(RepGenF,LastRecAddr[RepGenF]); {* Retrieve record by address Preserve position *}

      Status:=GetDirect(F[RepGenF],RepGenF,LRecPtr[RepGenF]^,RGK,0); {* Re-Establish Position *}

//      Report_BError(Fnum,Status);

      if LastEdit then
        Ok:=LGetMultiRec(B_GetDirect,B_MultLock,KeyS,RGK,RepGenF,BOff,GlobLocked);
    end;
end;

procedure TReportRec.SaveCommandRec;
var
  Res, FNum : SmallInt;
  TempRec : RepGenRec;
begin
  with ExLocal do
  begin
    FNum := RepGenF;
    if DBFCmdLineExists then
    begin
      if FindCommandRec then
      begin
        LRepGen^.RCommand.Command := Trim(extDBFCommand.Text);
        Res := Put_Rec(F[Fnum],Fnum,LRecPtr[Fnum]^,RGK);
      end;
    end
    else
    begin
      TempRec := LRepGen^;
      FillChar(LRepGen^, SizeOf(LRepGen^), #0);
      LRepGen^.RecPfix := ReportGenCode;
      LRepGen^.SubType := RepCommandType;
      LRepGen^.RCommand.ReportKey := TempRec.ReportHed.ReportKey;
      LRepGen^.RCommand.RepName := TempRec.ReportHed.RepName;
      LRepGen^.RCommand.Command := Trim(extDBFCommand.Text);

      Res := Add_Rec(F[Fnum],Fnum,LRecPtr[Fnum]^,RGK);

      LRepGen^ := TempRec;
    end;

    { unlock multiple-lock lock }
    UnLockMLock(Fnum,LastRecAddr[Fnum]);
      LSetDataRecOfs(RepGenF,LastRecAddr[RepGenF]); {* Retrieve record by address Preserve position *}

      Status:=GetDirect(F[RepGenF],RepGenF,LRecPtr[RepGenF]^,RGK,0); {* Re-Establish Position *}

  end;
end;


end.
