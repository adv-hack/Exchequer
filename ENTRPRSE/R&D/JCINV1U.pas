unit JCInv1U;

interface

{$I DEFOvr.Inc}

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, TEditVal, ExtCtrls, SBSPanel, ComCtrls,
  GlobVar,VarConst,VarRec2U, BTSupU1,ExWrap1U, ExtGetU, SBSComp2,
  CuStkA4U,

  {$IFDEF Post}
    JobPostU,
  {$ENDIF}
  JobSup1U,

  JobMn2U,

  Menus, Mask, TCustom, AccelLbl, Buttons, BorBtns;




type
 TJIList  =  Class(TJLMList)

   Function CheckRowEmph :  Byte; Override;

   Function Find_ReCharge  :  Boolean;

   Function OutLine(Col  :  Byte)  :  Str255; Override;

 end;


type
  TJInvFrm = class(TForm)
    PageControl1: TPageControl;
    ItemPage: TTabSheet;
    D1SBox: TScrollBox;
    D1HedPanel: TSBSPanel;
    TSQ1Lab: TSBSPanel;
    D1RefLab: TSBSPanel;
    D1RefPanel: TSBSPanel;
    TSQ1Panel: TSBSPanel;
    D1ListBtnPanel: TSBSPanel;
    TotalPanel: TSBSPanel;
    TSQ2Panel: TSBSPanel;
    PopupMenu1: TPopupMenu;
    N2: TMenuItem;
    PropFlg: TMenuItem;
    N1: TMenuItem;
    StoreCoordFlg: TMenuItem;
    Edit1: TMenuItem;
    View1: TMenuItem;
    TSQ3Panel: TSBSPanel;
    TSQ4Panel: TSBSPanel;
    TSQ5Panel: TSBSPanel;
    TSQ2Lab: TSBSPanel;
    TSQ3Lab: TSBSPanel;
    TSQ4Lab: TSBSPanel;
    TSQ5Lab: TSBSPanel;
    TeleInpFrm: TTabSheet;
    Label81: Label8;
    ACFF: Text8Pt;
    D1BtnPanel: TSBSPanel;
    D1BSBox: TScrollBox;
    TagD1Btn: TButton;
    EditD1Btn: TButton;
    ViewD1Btn: TButton;
    Clsd1Btn: TButton;
    SBSPanel1: TSBSPanel;
    Image1: TImage;
    Label86: Label8;
    CompF: Text8Pt;
    PCurrF: TSBSComboBox;
    Label88: Label8;
    ChTypF: Text8Pt;
    Id3CCF: Text8Pt;
    Id3DepF: Text8Pt;
    Label810: Label8;
    TSPrevBtn: TSBSButton;
    TSFinBtn: TSBSButton;
    LinkCF: Text8Pt;
    Label814: Label8;
    SBSPanel2: TSBSPanel;
    TSNextBtn: TSBSButton;
    TSInpClsBtn: TSBSButton;
    Bevel1: TBevel;
    PQuotF: TCurrencyEdit;
    Label87: Label8;
    Label812: Label8;
    JCodeF: Text8Pt;
    Label816: Label8;
    JDeF: Text8Pt;
    Label82: Label8;
    RevAnlF: Text8Pt;
    Label83: Label8;
    ICurrF: TSBSComboBox;
    BackSht: TBorCheck;
    TfrWIP: TBorCheck;
    JIChPanel: TSBSPanel;
    JIChLab: TSBSPanel;
    JIAPanel: TSBSPanel;
    JIALab: TSBSPanel;
    JITPanel: TSBSPanel;
    JITLab: TSBSPanel;
    Label84: Label8;
    WIPAnlF: Text8Pt;
    UPBOMP: TSBSPanel;
    Tag1: TMenuItem;
    ITypeCB: TSBSComboBox;
    Label85: Label8;
    Label89: Label8;
    IdetCB: TSBSComboBox;
    MTagD1Btn: TButton;
    MTag1: TMenuItem;
    SBSPopupMenu1: TSBSPopupMenu;
    TagAll1: TMenuItem;
    UntagAll1: TMenuItem;
    InvertTagAll1: TMenuItem;
    TCharge1: TMenuItem;
    TagMat1: TMenuItem;
    TagMat2: TMenuItem;
    TabLab1: TMenuItem;
    TagLab2: TMenuItem;
    UseOCCD: TBorCheck;
    TSQ6Panel: TSBSPanel;
    TSQ6Lab: TSBSPanel;
    TagedTotP: TSBSPanel;
    TagPcntP: TSBSPanel;
    CustomTag1: TMenuItem;
    JIDisPnl: TSBSPanel;
    JIDisLab: TSBSPanel;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormResize(Sender: TObject);
    procedure PopupMenu1Popup(Sender: TObject);
    procedure PropFlgClick(Sender: TObject);
    procedure StoreCoordFlgClick(Sender: TObject);
    procedure Clsd1BtnClick(Sender: TObject);
    procedure D1RefPanelMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure D1RefLabMouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure D1RefLabMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure FormActivate(Sender: TObject);
    procedure Currency1Click(Sender: TObject);
    procedure TagD1BtnClick(Sender: TObject);
    procedure TSNextBtnClick(Sender: TObject);
    procedure PageControl1Changing(Sender: TObject;
      var AllowChange: Boolean);
    procedure I4JobAnalFChange(Sender: TObject);
    procedure Id3CCFExit(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure FormKeyPress(Sender: TObject; var Key: Char);
    procedure TSPrevBtnClick(Sender: TObject);
    procedure CompFDblClick(Sender: TObject);
    procedure ACFFDblClick(Sender: TObject);
    procedure TfrWIPClick(Sender: TObject);
    procedure ViewD1BtnClick(Sender: TObject);
    procedure EditD1BtnClick(Sender: TObject);
    procedure MTagD1BtnClick(Sender: TObject);
    procedure TagAll1Click(Sender: TObject);
    procedure TSFinBtnClick(Sender: TObject);
    procedure IdetCBExit(Sender: TObject);
    procedure ITypeCBChange(Sender: TObject);
    procedure CustomTag1Click(Sender: TObject);
    procedure PageControl1Change(Sender: TObject);
  private
    InHBeen,
    JustCreated,
    PastFCreate,
    StoreCoord,
    LastCoord,
    JustInved,
    StartInv,
    SetDefault,
    fNeedCUpdate,
    WizLocked,
    InTagged,
    fFrmClosing,
    fDoingClose,
    ListBusy,
    InOutMode,
    GotCoord,
    DuringActive,
    CanDelete    :  Boolean;

    SKeypath     :  Integer;

    PagePoint    :  Array[0..6] of TPoint;

    CustBtnList  :  TVisiBtns;

    DispTransPtr
                 :  Pointer;

    StartSize,
    InitSize,
    MaxSize      :  TPoint;

    JInvHed      :  JInvHedRec;

    procedure Find_FormCoord;

    procedure Store_FormCoord(UpMode  :  Boolean);

    procedure FormSetOfSet;

    Procedure WMCustGetRec(Var Message  :  TMessage); Message WM_CustGetRec;

    Procedure WMFormCloseMsg(Var Message  :  TMessage); Message WM_FormCloseMsg;

    Procedure WMGetMinMaxInfo(Var Message  :  TWMGetMinMaxInfo); Message WM_GetMinMaxInfo;

    Procedure WMSysCommand(Var Message  :  TMessage); Message WM_SysCommand;

    Procedure Send_UpdateList(Mode   :  Integer);

    procedure ShowRightMeny(X,Y,Mode  :  Integer);

    Procedure  SetNeedCUpdate(B  :  Boolean);

    Property NeedCUpDate :  Boolean Read fNeedCUpDate Write SetNeedCUpdate;

    procedure OutLstBot;

    procedure Link2Tot;

    Procedure SetButtons(State  :  Boolean);

    procedure PrimeButtons(PWRef   :  Boolean);

    Procedure UpdateListView(UpdateList  :  Boolean);

    Function ScanMode  :  Boolean;

    Function CheckListFinished  :  Boolean;

    procedure Form2JInv;

    Function CheckTSCompleted(Edit  :  Boolean)  : Boolean;

    procedure BeginTeleSales(CP  :  Boolean);

    procedure Display_Trans(Mode    :  Byte;
                            FromTh  :  Boolean);

    procedure EditCharge(UpTagged  :  Boolean);

    procedure OutTaggedTots;

    procedure PrintDoc;

  public
    { Public declarations }

    ExLocal      :  TdExLocal;

    ListOfSet    :  Integer;

    MULCtrlO     :  TJIList;



    procedure FormDesign;

    procedure SetCaption;

    procedure RefreshList(ShowLines,
                          IgMsg      :  Boolean);

    procedure FormBuildList(ShowLines  :  Boolean);

    procedure SetFormProperties;

    procedure OutJInvImp;

    Procedure SetFirstFieldFocus;

    procedure EditIWiz(Fnum,
                       Keypath     :  Integer);

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
  VarJCstU,
  SBSComp,
  ComnUnit,
  ComnU2,
  CurrncyU,
  InvListU,

  {$IFDEF DBD}
    DebugU,
  {$ENDIF}

  InvLst2U,


  {$IFDEF MC_On}
    LedCuU,
  {$ENDIF}

  {$IFDEF FRM}
    RPDevice,
    PrintFrm,
    FrmThrdU,
    RPDefine,
  {$ENDIF}

  {$IFDEF POST}
    JCCstmWU,
  {$ENDIF}

  Tranl1U,

  Saltxl1U,
  MiscU,
  Warn1U,
  ExThrd2U,

{$IFDEF EXSQL}
  SQLUtils,
{$ENDIF}

  SysU1,
  SysU2;


{$R *.DFM}





{$I JIti1U.pas}



Procedure  TJInvFrm.SetNeedCUpdate(B  :  Boolean);

Begin
  If (Not fNeedCUpdate) then
    fNeedCUpdate:=B;
end;

procedure TJInvFrm.Find_FormCoord;


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

    PrimeKey:='I';

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

    GetbtControlCsm(D1ListBtnPanel);

    GetbtControlCsm(D1BtnPanel);

    GetbtControlCsm(D1BSBox);

    MULCtrlO.Find_ListCoord(GlobComp);

  end; {With GlobComp..}


  Dispose(GlobComp,Destroy);

    {NeedCUpdate}
  StartSize.X:=Width; StartSize.Y:=Height;

end;


procedure TJInvFrm.Store_FormCoord(UpMode  :  Boolean);


Var
  GlobComp:  TGlobCompRec;


Begin

  New(GlobComp,Create(BOff));

  With GlobComp^ do
  Begin
    GetValues:=UpMode;

    PrimeKey:='I';

    ColOrd:=Ord(StoreCoord);

    HLite:=Ord(LastCoord);

    SaveCoord:=StoreCoord;

    If (Not LastCoord) then {* Attempt to store last coord *}
      HLite:=ColOrd;

    StorebtControlCsm(Self);


    StorebtControlCsm(PageControl1);

    StorebtControlCsm(d1SBox);

    StorebtControlCsm(d1BtnPanel);

    StorebtControlCsm(d1BSBox);

    StorebtControlCsm(d1ListBtnPanel);


    MULCtrlO.Store_ListCoord(GlobComp);

  end; {With GlobComp..}

  Dispose(GlobComp,Destroy);
end;



procedure TJInvFrm.FormSetOfSet;

Begin
  PagePoint[0].X:=ClientWidth-(PageControl1.Width);
  PagePoint[0].Y:=ClientHeight-(PageControl1.Height);

  PagePoint[1].X:=PageControl1.Width-(D1SBox.Width);
  PagePoint[1].Y:=PageControl1.Height-(D1SBox.Height);

  PagePoint[2].X:=PageControl1.Width-(D1BtnPanel.Left);
  PagePoint[2].Y:=PageControl1.Height-(D1BtnPanel.Height);

  PagePoint[3].X:=D1BtnPanel.Height-(D1BSBox.Height);
  PagePoint[3].Y:=D1SBox.ClientHeight-(D1RefPanel.Height);

  PagePoint[4].Y:=PageControl1.Height-(D1ListBtnPanel.Height);


  PagePoint[5].X:=ClientWidth-Bevel1.Width;
  PagePoint[5].Y:=ClientHeight-Bevel1.Top;

  PagePoint[6].X:=D1BtnPanel.Left-TSFinBtn.Left;
  PagePoint[6].Y:=TSFinBtn.Left-TSPrevBtn.Left;



  {GotCoord:=BOn;}


end;


procedure TJInvFrm.OutLstBot;


Var
  GenDesc    :  Str255;

  FoundCode  :  Str20;

Begin
  With ExLocal, JobDetl^.JobActual do
  Begin
    GetJobMisc(Self,AnalCode,FoundCode,2,-1);

    If (JDDT=TSH) then
      GenDesc:=Get_StdPRDesc(StockCode,JCtrlF,JCK,-1)
    else
    Begin
      {$IFDEF STK}

        GetStock(Self,StockCode,StockCode,-1);

        GenDesc:=Stock.Desc[1];

      {$ENDIF}
    end;


    UPBOMP.Caption:=Trim(GenDesc)+'/'+Trim(JobMisc^.JobAnalRec.JAnalName);

  end; {With..}
end;


procedure TJInvFrm.Link2Tot;


Begin
  {If (Assigned(MULCtrlO)) then
    MULCtrlO.GetSelRec(BOn);}

  OutLstBot;
end;


Procedure TJInvFrm.SetButtons(State  :  Boolean);


Begin
  CustBtnList.SetEnabBtn(State);

  Clsd1Btn.Enabled:=State;
  TSPrevBtn.Enabled:=State;
  TSFinBtn.Enabled:=State;
  TSNextBtn.Enabled:=State;
  TSInpClsBtn.Enabled:=State;

end;

procedure TJInvFrm.PrimeButtons(PWRef   :  Boolean);

Begin
  If (PWRef) and (Assigned(CustBtnList)) then
  Begin
    LockWindowUpDate(Handle);

    {SetTabs2;}
    CustBtnList.ResetButtons;
    CustBtnList.Free;
    CustBtnList:=nil;

  end;


  If (CustBtnList=nil) then
  Begin
    CustBtnList:=TVisiBtns.Create;


    try

      With CustBtnList do
        Begin
          {01} AddVisiRec(TagD1Btn,BOff);
          {02} PWAddVisiRec(EditD1Btn,BOff,215);
          {03} AddVisiRec(ViewD1Btn,BOff);
          {04} AddVisiRec(MTagD1Btn,BOff);
          HideButtons;
        end; {With..}

    except

      CustBtnList.Free;
      CustBtnList:=nil;
    end; {Try..}

    If (PWRef) then
      LockWindowUpDate(0);


  end {If needs creating }
  else
    CustBtnList.RefreshButtons;
end;




Procedure TJInvFrm.WMCustGetRec(Var Message  :  TMessage);

Var
  JInvRetPtr :  ^JInvRetRec;


Begin
  JInvRetPtr:=nil;

  With Message do
  Begin

    {If (Debug) then
      DebugForm.Add('Mesage Flg'+IntToStr(WParam));}

    Case WParam of
      0,1,169
         :  Begin
              If (Assigned(MULCtrlO)) then
                PostMessage(Self.Handle,WM_FormCloseMsg,WParam,LParam);

            end;


      2  :  ShowRightMeny(LParamLo,LParamHi,1);

      18 :  Begin
              If (JustInved) then
              Begin
                PrintDoc;

                JustInved:=BOff;

                {PostMessage(Self.Handle,WM_CustGetRec,74,0); v5.50. Form closed here as get
                                                                     extended taking to long to refresh when only one item remaining}

                SetButtons(BOn);

                InTagged:=BOff;
                StartInv:=BOff;

                PostMessage(Self.Handle,WM_Close,0,0);

              end;
            end;

      25 :  NeedCUpdate:=BOn;


      74 :  If (Assigned(MULCtrlO)) then
            Begin
              With MULCtrlO do
              begin
                if (SQLCacheID <> 0) then
                RefreshCache;
                If (MUListBox1.Row<>0) then
                  PageUpDn(0,BOn)
                else
                  InitPage;
              end;
              {MULCtrlO.PageUpDn(0,BOn);}

              SetButtons(BOn);

              InTagged:=BOff;
              StartInv:=BOff;

            end;

      75 :  If (LParam<>0) then
            With ExLocal do
            Begin
              JInvRetPtr:=Pointer(LParam);

              If (Assigned(JInvRetPtr)) then
              Begin
                LInv:=JInvRetPtr^.RetInv;
                AssignToGlobal(InvF);

                JInvHed.RetInv:=LInv;

                Dispose(JInvRetPtr);

                InHBeen:=BOn;

                Display_Trans(2,BOn);

                InHBeen:=BOff;

                JustInved:=BOn;
              end;
            end;

      76 :  Begin
              InTagged:=BOff;
              PostMessage(Self.Handle,WM_Close,0,0); {If only transferring WIP, Shut it!}
            end;

      77 :  If (LParam<>0) then
            With ExLocal do
            Begin
              JInvRetPtr:=Pointer(LParam);

              If (Assigned(JInvRetPtr)) then
              Begin
                JInvHed.TagCost:=JInvRetPtr^.RTagCost;
                JInvHed.TotCost:=JInvRetPtr^.RTotCost;
                JInvHed.TagCharge:=JInvRetPtr^.RTagCharge;

                Dispose(JInvRetPtr);

                OutTaggedTots;
              end;
            end;


     200 :  DispTransPtr:=nil;


    end; {Case..}
  end;
  Inherited;
end;

Function TJInvFrm.ScanMode  :  Boolean;

Var
  n  :  Byte;

Begin
  If (Assigned(DispTransPtr)) then
  With TFInvDisplay(DispTransPtr) do
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


Procedure TJInvFrm.WMFormCloseMsg(Var Message  :  TMessage);

Var
  IMode  :  SmallInt;

Begin

  With Message do
  Begin
    Case WParam of
      0,1,169
         :  Begin
              If (WParam=169) then
              Begin
                MULCtrlO.GetSelRec(BOff);
                IMode:=0;
              end
              else
                IMode:=WParam;

              If (IMode=1) then
                Link2Tot;

              InHBeen:=((WParam=0) or ((InHBeen) and ScanMode));

              Display_Trans(2+(98*WParam),BOff);

            end;

      84  : Begin
              SetButtons(BOff);

              InTagged:=BOn;
            end;


    end; {Case..}

  end;

  Inherited;
end;


{ == Procedure to Send Message to Get Record == }

Procedure TJInvFrm.Send_UpdateList(Mode   :  Integer);

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


Procedure TJInvFrm.WMGetMinMaxInfo(Var Message  :  TWMGetMinMaxInfo);

Begin

  With Message.MinMaxInfo^ do
  Begin


    If (Not GotCoord) and (Not JustCreated) and (PastFCreate) then
    Begin
      ptMinTrackSize.X:=MaxSize.X;
      ptMinTrackSize.Y:=MaxSize.Y;
      ptMaxTrackSize.X:=MaxSize.X;
      ptMaxTrackSize.Y:=MaxSize.Y;
    end
    else
    Begin
      ptMinTrackSize.X:=200;
      ptMinTrackSize.Y:=264;

    end;

    {ptMaxSize.X:=ClientWidth;
     ptMaxSize.Y:=ClientHeight;
    ptMaxPosition.X:=1;
    ptMaxPosition.Y:=1;}

  end;

  Message.Result:=0;

  Inherited;

end;


Procedure TJInvFrm.WMSysCommand(Var Message  :  TMessage);


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




procedure TJInvFrm.RefreshList(ShowLines,
                               IgMsg      :  Boolean);
Const
  JACCMode :  Array[13..19] of Byte = (13,14,15,5,5,15,15);

Var
  KeyStart    :  Str255;
  LKeyLen,
  KPath,
  CPage       :  Integer;

{$IFDEF EXSQL}
  KeyCode: string;
  WhereClause: string;
{$ENDIF}
Begin

  {$B-}
  If (Assigned(MULCtrlO)) then
  With MULCtrlO,ExLocal,LJobRec^ do
  {$B+}
  Begin
    {LNHCtrl:=DDCtrl;}

    KPath:=JDLedgerK;

    With ExLocal,LJobRec^,LNHCtrl do
    Begin

       KeyStart:=PartCCKey(JBRCode,JBECode)+FullJobCode(JobCode)+#1;

       NHCr:=JInvHed.InCurr;

       {NHTxCR:=Level_TxCr;}


       If (NHNeedGExt) then
       Begin
         If (StkExtObjPtr=nil) then
         Begin
           ExtObjCreate;

         end;

         With StkExtRecPtr^ do
         Begin
           FDesc:=FullJobCode(JobCode)+#1;
           FMode:=29;
         end;

       end
       else
         If (StkExtObjPtr<>nil) then
           ExtObjDestroy; {* Remove previous link *}
    end;

    LKeyLen:=Length(KeyStart);

    IgnoreMsg:=IgMsg;

{$IFDEF EXSQL}
    KeyCode := FullJobCode(JobCode);
    WhereClause :=
      '(RecPFix = ''J'' AND SubType = ''E'') AND ' +
      '(SUBSTRING(varcode1computed, 1, 10) = ' + StringToHex(Copy(KeyCode, 1, 10)) + ') AND ' +
      'Invoiced = 0 AND ' +
      { The following reproduces a bug in the Pervasive version, so that the
        behaviour is identical. See Term 4 in Nom5ExtSObj.SetNomObj1() in
        JHistDDU.pas. }
      '(CAST(SUBSTRING(CAST(PostedRun as VARBINARY(4)),2,1) + ' +
      '      SUBSTRING(CAST(PostedRun as VARBINARY(4)),3,1) + ' +
      '      SUBSTRING(CAST(PostedRun as VARBINARY(4)),4,1) + ' +
      '      SUBSTRING(CAST(JAType    as VARBINARY(4)),4,1) AS INT)) > 1 AND (';
      {
      // This is what the above expression *should* be:
      'JAType > ' + IntToStr(SysAnlsRev) + ' AND (';
      }

    if (StkExtRecPtr^.FMode <> 29) then
      WhereClause := WhereClause + 'JAType <= ' + IntToStr(SysOH2) + ' OR '
    else
      WhereClause := WhereClause + 'JAType <= ' + IntToStr(SysAnlsEnd) + ' OR ';

    if (StkExtRecPtr^.FMode <> 29) then
      WhereClause := WhereClause + 'JAType > ' + IntToStr(SysAnlsRev) + ') AND '
    else
      WhereClause := WhereClause + 'JAType > ' + IntToStr(Pred(SysSubLab)) + ') AND ';

    WhereClause := WhereClause + 'JAType <= ' + IntToStr(SysOH2);

    StartList(JDetlF,KPath,KeyStart,'','',LKeyLen,(Not ShowLines), WhereClause);

{$ELSE}
    StartList(JDetlF,KPath,KeyStart,'','',LKeyLen,(Not ShowLines));
{$ENDIF}

    IgnoreMsg:=BOff;
  end;

end;



Procedure TJInvFrm.UpdateListView(UpdateList  :  Boolean);

Begin
  With MULCtrlO do
  Begin

    If (UpdateList) then
    Begin
      PageUpDn(0,BOn);
    end;

  end;
end;



procedure TJInvFrm.FormBuildList(ShowLines  :  Boolean);

Var
  StartPanel  :  TSBSPanel;
  n           :  Byte;



Begin
  MULCtrlO:=TJIList.Create(Self);


  Try

    With MULCtrlO do
    Begin


      Try

        With VisiList do
        Begin
          AddVisiRec(D1RefPanel,D1RefLab);
          AddVisiRec(TSQ1Panel,TSQ1Lab);
          AddVisiRec(TSQ2Panel,TSQ2Lab);
          AddVisiRec(JICHPanel,JICHLab);
          AddVisiRec(TSQ3Panel,TSQ3Lab);
          AddVisiRec(TSQ4Panel,TSQ4Lab);
          AddVisiRec(TSQ6Panel,TSQ6Lab);
          AddVisiRec(TSQ5Panel,TSQ5Lab);
          AddVisiRec(JIAPanel,JIALab);
          AddVisiRec(JITPanel,JITLab);
          AddVisiRec(JIDisPnl,JIDisLab);

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


      FormSetOfSet;


      Find_FormCoord;

      TabOrder := -1;
      TabStop:=BOff;
      Visible:=BOff;
      BevelOuter := bvNone;
      ParentColor := False;
      Color:=StartPanel.Color;
      MUTotCols:=10;
      Font:=StartPanel.Font;

      LinkOtherDisp:=BOn;

      WM_ListGetRec:=WM_CustGetRec;


      Parent:=StartPanel.Parent;

      MessHandle:=Self.Handle;

      For n:=0 to MUTotCols do
      With ColAppear^[n] do
      Begin
        AltDefault:=BOn;

        If (n In [4..10]) then
        Begin
          DispFormat:=SGFloat;

          Case n of
            4  :  NoDecPlaces:=Syss.NoQtyDec;
            5..8 :  NoDecPlaces:=2;
           10  :  NoDecPlaces:=2;
          end; {Case..}
        end;
      end;

      ListLocal:=@ExLocal;

      ListCreate;

      UseSet4End:=BOff;

      NoUpCaseCheck:=BOn;

      HighLiteStyle[1]:=[fsBold];

      DisplayMode:=29;

      LNHCtrl.NHNeedGExt:=BOn;

      Set_Buttons(D1ListBtnPanel);

      ReFreshList(BOn,BOff);

    end {With}


  Except

    MULCtrlO.Free;
    MULCtrlO:=Nil;
  end;

  GotCoord:=BOn;

  FormReSize(Self);


  {RefreshList(BOn,BOn);}

end;


procedure TJInvFrm.FormDesign;

Var
  HideCC  :  Boolean;

Begin
  HideCC:=BOff;

  With ExLocal do
  Begin
    HideCC:=Syss.UseCCDep;


    Id3CCF.Visible:=HideCC;
    Id3DepF.Visible:=HideCC;
    Label810.Visible:=HideCC;
    UseOCCD.Visible:=HideCC;


    {$IFNDEF MC_On}
      ICurrF.Visible:=BOff;
      PCurrF.Visible:=BOff;
      //Label87.Visible:=BOff;
      Label83.Visible:=BOff;
      Label89.Left:=Label83.Left;
      Label89.Width:=Label83.Width;
      IDetCB.Left:=ICurrF.Left;
      PQuotF.Left:=PCurrF.Left;

    {$ELSE}

      Set_DefaultCurr(ICurrF.Items,BOff,BOff);
      Set_DefaultCurr(ICurrF.ItemsL,BOff,BOn);
      Set_DefaultCurr(PCurrF.Items,BOff,BOff);
      Set_DefaultCurr(PCurrF.ItemsL,BOff,BOn);

    {$ENDIF}

    ItemPage.TabVisible:=BOff;

    PageControl1.ActivePage:=TeleInpFrm;

    CreateSubMenu(SBSPopUpMenu1,MTag1);
  end;
end;


procedure TJInvFrm.SetCaption;

Var
  LevelStr  :  Str255;

Begin
  With ExLocal do
  Begin
    LevelStr:='Generate Invoice for '+dbFormatName(LJobRec^.JobCode,LJobRec^.JobDesc);

    If (Assigned(MULCtrlO)) then
    With MULCtrlO do
    Begin
      LevelStr:=LevelStr+' '+Show_TreeCur(LNHCtrl.NHCr,0);
    end;
  end; {with..}

  Caption:=LevelStr;
end;



procedure TJInvFrm.FormCreate(Sender: TObject);

Var
  n  :  Integer;

begin
  fFrmClosing:=BOff;
  fDoingClose:=BOff;
  
  ExLocal.Create;

  LastCoord:=BOff;

  NeedCUpdate:=BOff;

  ListBusy:=BOff;

  JustCreated:=BOn;

  InTagged:=BOff;

  {* When adjusting screen size, adjust MaxSize below as well .... *}
  InitSize.Y:=366;
  InitSize.X:=639;

  Self.ClientHeight:=InitSize.Y;
  Self.ClientWidth:=InitSize.X;

  If NoXLogo then
    Image1.Visible:=BOff;


  {Height:=244;
  Width:=370;}

  InHBeen:=BOff;
  InOutMode:=BOff;

  JustInved:=BOff;
  StartInv:=BOff;

  DispTransPtr:=nil;

  ExLocal.AssignFromGlobal(JobF);

  Blank(JInvHed,Sizeof(JInvHed));

  With JInvHed do
  Begin
    InCurr:=1;

    PrintBS:=BOn;
    FinalInv:=BOff;

  end;

  LastValueObj.GetAllLastValuesFull(Self);

  Form2JInv;

  With JInvHed,ExLocal do
  Begin
    If (JAPOn) then
    Begin
      UseWIP:=BOn;
      WIPOnly:=BOn;
    end
    else
      If (LCust.CustCode<>LJobRec^.CustCode) then
      Begin
        If (LGetMainRecPos(CustF,LJobRec^.CustCode)) then
          InCurr:=LCust.Currency
        else
          InCurr:=1;
      end;
  end;


  DuringActive:=BOff;

  For n:=0 to Pred(ComponentCount) do
    If (Components[n] is TScrollBox) then
    With TScrollBox(Components[n]) do
    Begin
      VertScrollBar.Position:=0;
      HorzScrollBar.Position:=0;
    end;

  VertScrollBar.Position:=0;
  HorzScrollBar.Position:=0;


  PrimeButtons(BOff);


  FormDesign;

  SetCaption;

  OutJInvImp;
  OutTaggedTots;

  MaxSize.Y:=Height;
  MaxSize.X:=Width;

  If (MaxSize.Y<386) then
    MaxSize.Y:=386;

  If (MaxSize.X<630) then
    MaxSize.X:=630;

  PastFCreate:=BOn;
end;



procedure TJInvFrm.FormDestroy(Sender: TObject);

Var
  n  :  Byte;
begin

  ExLocal.Destroy;


end;


Function TJInvFrm.CheckListFinished  :  Boolean;

Var
  n       :  Byte;
  mbRet   :  Word;
Begin
  Result:=BOn;

  If (Assigned(MULCtrlO)) then
    Result:=Not MULCtrlO.ListStillBusy;

  If (Not Result) then
  Begin
    Set_BackThreadMVisible(BOn);

    mbRet:=MessageDlg('The lists is still busy.'+#13+#13+
                      'Do you wish to interrupt the list so that you can exit?',mtConfirmation,[mbYes,mbNo],0);

    If (mBRet=mrYes) then
    Begin
      MULCtrlO.IRQSearch:=BOn;

      ShowMessage('Please wait a few seconds, then try closing again.');
    end;

    Set_BackThreadMVisible(BOff);

  end;
end;

procedure TJInvFrm.FormCloseQuery(Sender: TObject;
                              var CanClose: Boolean);
Var
  n  : Integer;

begin
  If (Not fFrmClosing) and (Not ListBusy) and (Not InTagged) then
  Begin
    {CanClose:=ConfirmQuit;}

    If (CanClose) then
      CanClose:=CheckListFinished;

    If (CanClose) then
    Begin
      fFrmClosing:=BOn;

      Try
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

        If (WizLocked) then
          With ExLocal do
            UnLockMLock(JobF,LastRecAddr[JobF]);

        Send_UpdateList(159);
      Finally
        fFrmClosing:=BOff;
      end;
    end;
  end
  else
    CanClose:=BOff;
end;




procedure TJInvFrm.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  If (Not fDoingClose) then
  Begin
    fDoingClose:=BOn;

    Action:=caFree;

    If (MULCtrlO<>nil) then
    Begin
      try
        MULCtrlO.Destroy;
      finally
        MULCtrlO:=nil;
      end;
    end;

  end;
  
end;


procedure TJInvFrm.FormResize(Sender: TObject);
Var
  n           :  Byte;
  NewVal      :  Integer;


begin

  If (GotCoord) then
  Begin
    PageControl1.Width:=ClientWidth-PagePoint[0].X;

    PageControl1.Height:=ClientHeight-PagePoint[0].Y;

    D1SBox.Width:=PageControl1.Width-PagePoint[1].X;
    D1SBox.Height:=PageControl1.Height-PagePoint[1].Y;

    D1BtnPanel.Left:=PageControl1.Width-PagePoint[2].X;
    D1BtnPanel.Height:=PageControl1.Height-PagePoint[2].Y;

    D1BSBox.Height:=D1BtnPanel.Height-PagePoint[3].X;

    D1ListBtnPanel.Left:=(D1BtnPanel.Left-D1ListBtnPanel.Width)-2;
    D1ListBtnPanel.Height:=PageControl1.Height-PagePoint[4].Y;

    Bevel1.Width:=ClientWidth-PagePoint[5].X;

    TSFinBtn.Left:=D1BtnPanel.Left-PagePoint[6].X;
    TSPrevBtn.Left:=TSFinBtn.Left-PagePoint[6].Y;
    TSNextBtn.Left:=TSPrevBtn.Left;
    TSInpClsBtn.Left:=TSFinBtn.Left;



    If (MULCtrlO<>nil) then
    Begin
      LockWindowUpDate(Handle);

      With MULCtrlO,VisiList do
      Begin
        VisiRec:=List[0];

        With (VisiRec^.PanelObj as TSBSPanel) do
          Height:=D1SBox.ClientHeight-PagePoint[3].Y;

        RefreshAllCols;
      end;

      LockWindowUpDate(0);

      MULCtrlO.ReFresh_Buttons;

      MULCtrlO.LinkOtherDisp:=BOn;

    end;{Loop..}

    
    NeedCUpdate:=((StartSize.X<>Width) or (StartSize.Y<>Height));

  end; {If time to update}
end;




procedure TJInvFrm.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  GlobFormKeyDown(Sender,Key,Shift,ActiveControl,Handle);
end;

procedure TJInvFrm.FormKeyPress(Sender: TObject; var Key: Char);
begin
  GlobFormKeyPress(Sender,Key,ActiveControl,Handle);
end;


procedure TJInvFrm.SetFormProperties;


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

procedure TJInvFrm.ShowRightMeny(X,Y,Mode  :  Integer);

Begin
  With PopUpMenu1 do
  Begin

    PopUp(X,Y);
  end;


end;


procedure TJInvFrm.PopupMenu1Popup(Sender: TObject);

Var
  n  :  Integer;

begin
  StoreCoordFlg.Checked:=StoreCoord;

  With CustBtnList do
  Begin
    ResetMenuStat(PopUpMenu1,BOn,BOn);

    With PopUpMenu1 do
    For n:=0 to Pred(Count) do
      SetMenuFBtn(Items[n],n);

  end;

end;



procedure TJInvFrm.PropFlgClick(Sender: TObject);
begin
  SetFormProperties;
end;

procedure TJInvFrm.StoreCoordFlgClick(Sender: TObject);
begin
  StoreCoord:=Not StoreCoord;
  NeedCUpdate:=BOn;
end;



procedure TJInvFrm.Clsd1BtnClick(Sender: TObject);
begin
  Close;
end;


procedure TJInvFrm.D1RefPanelMouseUp(Sender: TObject;
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

    BarPos:=D1SBox.HorzScrollBar.Position;

    If (PanRsized) then
      MULCtrlO.ResizeAllCols(MULCtrlO.VisiList.FindxHandle(Sender),BarPos);

    MULCtrlO.FinishColMove(BarPos+(ListOfset*Ord(PanRSized)),PanRsized);

    NeedCUpdate:=(MULCtrlO.VisiList.MovingLab or PanRSized);

  end;

end;


procedure TJInvFrm.D1RefLabMouseMove(Sender: TObject; Shift: TShiftState;
  X, Y: Integer);
begin
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


procedure TJInvFrm.D1RefLabMouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
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




procedure TJInvFrm.FormActivate(Sender: TObject);
begin
  If (Assigned(MULCtrlO))  then
    MULCtrlO.SetListFocus;

  If (JustCreated) then
  Begin
    MDI_ForceParentBKGnd(BOn);

    DuringActive:=BOn;



    DuringActive:=BOff;

    JustCreated:=BOff;
  end;

end;



procedure TJInvFrm.Currency1Click(Sender: TObject);
{$IFDEF MC_On}

  Var
    LedCur  :  TLCForm;

    mrRet   :  Word;

    UseCr   :  Byte;
{$ENDIF}

begin
  {$IFDEF MC_On}

    LedCur:=TLCForm.Create(Self);

    try

      With MULCtrlO,VisiList,LNHCtrl do
      Begin
        UseCr:=NHCr;

        mrRet:=LedCur.InitAS(UseCr,1,IdPanel(0,BOff).Color,IdPanel(0,BOff).Font);

        If (mrRet=mrOk) then
        Begin
          NHCr:=UseCr;

          UpDateListView(BOn);
        end;
      end;

    finally

      LedCur.Free;

    end; {try..}

  {$ENDIF}
end;



procedure TJInvFrm.TagD1BtnClick(Sender: TObject);
begin
  {$B-}
  If (Assigned(MULCtrlO)) and ((MULCtrlO.ValidLine) or (TComponent(Sender).Tag=1)) then

  {$B+}

  Begin

  end;


end;

procedure TJInvFrm.OutJInvImp;

  Var
    n  :  Byte;

  Begin

    With EXLocal,LJobRec^,JInvHed do
    Begin

      ACFF.Text:=CustCode;
      LinkCF.Text:=ACFF.Text;
      ChTypF.Text:=JobCHTDescL^[ChargeType];

      If (LCust.CustCode<>CustCode) then
        If LGetMainRecPos(CustF,CustCode) then;

      CompF.Text:=LCust.Company;

      JCodeF.Text:=JobCode;

      JDeF.Text:=JobDesc;

      {$IFDEF MC_On}
        If (InCurr>0) then
          ICurrF.ItemIndex:=Pred(InCurr);

        If (CurrPrice>0) then
          PCurrF.ItemIndex:=Pred(CurrPrice);
      {$ENDIF}

      PQuotF.Value:=QuotePrice;

      ItypeCB.ItemIndex:=(1*Ord(FinalInv))+(2*Ord(WIPOnly));

      IdetCB.ItemIndex:=DetLev;

      RevAnlF.Text:=IJACode;

      BackSht.Checked:=PrintBS;
      TFrWIP.Checked:=UseWIP;

      WIPAnlF.Text:=WJACode;

      Id3CCF.Text:=ICCDep[BOn];
      Id3DepF.Text:=ICCDep[BOff];

      If (DetLev=2) then
        UseOCCd.Checked:=UseOrigCCDep
      else
      Begin
        UseOCCd.Enabled:=BOff;
        UseOCCd.Checked:=BOff;
      end;

      InOutMode:=BOff;
    end;


  end;


  procedure TJInvFrm.Form2JInv;

  Var
    n  :  Byte;

  Begin
    With EXLocal,LJobRec^,JInvHed do
    Begin
      {$IFDEF MC_On}
        If (ICurrF.ItemIndex>=0) then
          InCurr:=Succ(ICurrF.ItemIndex);
      {$ENDIF}

      QuotePrice:=PQuotF.Value;


      IJACode:=RevAnlF.Text;

      PrintBS:=BackSht.Checked;
      UseWIP:=TFrWIP.Checked;

      WJACode:=WIPAnlF.Text;

      ICCDep[BOn]:=Id3CCF.Text;
      ICCDep[BOff]:=Id3DepF.Text;

      UseOrigCCDep:=UseOCCd.Checked;

      FinalInv:=(ItypeCB.ItemIndex=1);
      WIPOnly:=(ItypeCB.ItemIndex=2);

      If (IDetCB.ItemIndex>=0) then
        DetLev:=IDetCB.ItemIndex;

    end; {with..}
  end;


  Function TJInvFrm.CheckTSCompleted(Edit  :  Boolean)  : Boolean;

  Const
  NofMsgs      =  5;

Type
  PossMsgType  = Array[1..NofMsgs] of Str80;

Var
  PossMsg  :  ^PossMsgType;

  Test     :  Byte;

  mbRet    :  Word;

  FoundCode2
           :  Str10;

  FoundCode:  Str20;

  FoundLong:  LongInt;


Begin
  New(PossMsg);

  FillChar(PossMsg^,Sizeof(PossMsg^),0);

  PossMsg^[1]:='That Cost Centre Code is not valid.';
  PossMsg^[2]:='That Department Code is not valid.';
  PossMsg^[3]:='That Currency is not valid.';
  PossMsg^[4]:='That Revenue Analysis Code is not valid.';
  PossMsg^[5]:='That WIP Analysis Code is not valid.';


  Test:=1;

  Result:=BOn;


  While (Test<=NofMsgs) and (Result) do
  With ExLocal,JInvHed do
  Begin
    {$B-}

    Case Test of


      1,2
         :  Result:=(Not Syss.UseCCDep) or ((Not EmptyKeyS(ICCDep[Test=1],CCKeyLen,BOff) and GetCCDep(Self,ICCDep[Test=1],FoundCode,(Test=1),-1)));

    {$IFDEF MC_On}
      3  :
               Result:=(InCurr In [Succ(CurStart)..CurrencyType]);
    {$ENDIF}

      4  :  Result:=(GetJobMisc(Self,IJACode,FoundCode,2,-1));


      5  :  Result:=(Not UseWIP) or (GetJobMisc(Self,WJACode,FoundCode,2,-1));


    end;{Case..}

    {$B+}

    If (Result) then
      Inc(Test);

  end; {While..}

  If (Not Result) then
    mbRet:=MessageDlg(PossMsg^[Test],mtWarning,[mbOk],0);

  Dispose(PossMsg);

  end; {Func..}


  procedure TJInvFrm.BeginTeleSales(CP  :  Boolean);

  Begin
    Form2JInv;

    If (CheckTSCompleted(BOff)) then
    Begin
      {* If TeleSMode, then get TeleS Values, once ready to display list *}

      If (CP) then
      Begin

        ItemPage.TabVisible:=BOn;

        PageControl1.ActivePage:=ItemPage;

      end;

      If (Not Assigned(MULCtrlO)) then
      Begin

        FormBuildList(BOff);

        UpdateListView(BOff);

        MULCtrlO.SetListFocus;

      end
      else
        ReFreshList(BOn,BOff);


      If (CP) then
      Begin

        {$IFDEF Post} {Calc totals}
          AddJobPost2Thread(Self,22,ExLocal.LJobRec^.JobCode,@JInvHed,Self.Handle);
        {$ENDIF}

      end;

      
    end;
  end;




procedure TJInvFrm.TSNextBtnClick(Sender: TObject);
begin
  BeginTeleSales(BOn);
end;

procedure TJInvFrm.TSPrevBtnClick(Sender: TObject);
begin
  PageControl1.ActivePage:=TeleInpFrm;
  MDI_ForceParentBKGnd(BOn);
end;


procedure TJInvFrm.PageControl1Changing(Sender: TObject;
  var AllowChange: Boolean);

Var
  NewIndex  :  Integer;

begin
  NewIndex:=pcLivePage(Sender);


  {$IFDEF SOP}
    {$B-}

    AllowChange:=((NewIndex=1) or CheckTSCompleted(BOff)) and (Not InTagged);


    {$B+}

    If (NewIndex=1) and AllowChange then
      MDI_ForceParentBKGnd(BOn);


  {$ELSE}

    AllowChange:=BOff;

  {$ENDIF}

  

end;

{Proc..}



procedure TJInvFrm.I4JobAnalFChange(Sender: TObject);
Var
  FoundCode  :  Str20;

  FoundOk,
  AltMod     :  Boolean;

  AMode      :  Byte;

begin

    If (Sender is Text8pt) then
    With (Sender as Text8pt) do
    Begin
      If (Sender=WIPAnlF) then
        AMode:=8
      else
        AMode:=1;

      AltMod:=Modified;

      FoundCode:=Strip('B',[#32],Text);

      If ((AltMod) or (FoundCode=''))  and (ActiveControl<>TsInpClsBtn) and ((TFrWIP.Checked) or (AMode=1)) then
      Begin

        StillEdit:=BOn;

        FoundOk:=(GetJobMisc(Self,FoundCode,FoundCode,2,AMode));

        If (FoundOk) then {* Credit Check *}
        Begin

          Text:=FoundCode;

          {FieldNextFix(Self.Handle,ActiveControl,Sender);}

        end
        else
        Begin
          {StopPageChange:=BOn;}

          SetFocus;
        end; {If not found..}
      end;

    end;

end;



procedure TJInvFrm.Id3CCFExit(Sender: TObject);
Var
  FoundCode  :  Str20;

  FoundOk,
  AltMod     :  Boolean;

  IsCC       :  Boolean;


begin

  If (Sender is Text8pt) then
  With (Sender as Text8pt) do
  Begin
    FoundCode:=Name;

    IsCC:=Match_Glob(Sizeof(FoundCode),'CC',FoundCode,FoundOk);

    AltMod:=Modified;

    FoundCode:=Strip('B',[#32],Text);

    If ((AltMod) or (FoundCode='')) and (ActiveControl<>TsInpClsBtn) and (Syss.UseCCDep)  then
    Begin

      StillEdit:=BOn;
      //TG 15-05-2017 2017 R2 18699 - Access Violation message - creating Job Record using inactive CC/Dept
      // Mode 2 has to sent instead of 0
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
    end
    else
      If (AltMod) and (FoundCode='') then
        Text:='';

  end; {with..}
end;

procedure TJInvFrm.IdetCBExit(Sender: TObject);
begin
  UseOCCd.Enabled:=(IdetCB.ItemIndex=2);
end;



procedure TJInvFrm.CompFDblClick(Sender: TObject);
begin
  ACFF.DblClick;

end;

procedure TJInvFrm.ACFFDblClick(Sender: TObject);
begin
  LinkCF.DblClick;
end;


procedure TJInvFrm.ITypeCBChange(Sender: TObject);
begin
  If (ITypeCB.ItemIndex=2) then
    TfrWIP.Checked:=BOn;
end;


Procedure TJInvFrm.SetFirstFieldFocus;

Begin
  {$IFDEF MC_On}
     If (ICurrF.CanFocus) then
       ICurrF.SetFocus
     else

  {$ENDIF}

  If (Syss.UseCCDep) and (Id3CCf.CanFocus) then
    Id3CCF.SetFocus
  else
    If (RevAnlF.CanFocus) then
      RevAnlf.SetFocus;

end;


procedure TJInvFrm.TfrWIPClick(Sender: TObject);
begin
  With WIPAnlF do
  Begin
    ReadOnly:=Not TFrWIP.Checked;
    TabStop:=TFrWIP.Checked;
  end;
end;


{ ======= Link to Trans display ======== }

procedure TJInvFrm.Display_Trans(Mode    :  Byte;
                                 FromTh  :  Boolean);

Var
  DispTrans  :  TFInvDisplay;
Begin

  If (DispTransPtr=nil) then
  Begin
    DispTrans:=TFInvDisplay.Create(Self);
    DispTransPtr:=DispTrans;
  end
  else
    DispTrans:=DispTransPtr;

    try

      With ExLocal,DispTrans do
      Begin
        If (Not FromTh) then
        With MULCtrlO do
        Begin
          Link2Inv;
          AssignFromGlobal(InvF);
        end;

        LastDocHed:=LInv.InvDocHed;

        If ((LastFolio<>LInv.FolioNum) or (Mode<>100)) and (InHBeen) then
          Display_Trans(Mode,Inv.FolioNum,BOn,(Mode<>100));

      end; {with..}

    except

      DispTrans.Free;

    end;

end;


procedure TJInvFrm.ViewD1BtnClick(Sender: TObject);
begin
  If (Assigned(MULCtrlO)) then
  With MULCtrlO do
  If (ValidLine) then
  Begin
    InHBeen:=BOn;

    Display_Trans(2,BOff);

  end;

end;

procedure TJInvFrm.EditCharge(UpTagged  :  Boolean);
var
  FuncRes, RecAddr: Integer;
Begin
  If (Assigned(MULCtrlO)) then
    If (MULCtrlO.ValidLine) then
    With MULCtrlO do
    Begin
      Update_TaggedWIPBal(JInvHed,JobDetl^,0,BOn);

{$IFDEF EXSQL}
      if (SQLCacheID <> 0) then
      begin
        { The Job Costing Invoicing list uses a prefilled cache (as a
          replacement for Get Extended calls). Unfortunately, the 'Tag' routine
          makes use of generic Btrieve access routines which cannot easily be
          amended to pick up and use the prefilled cache used by the list. To
          get round this, we will get the record position of the current record
          in the prefilled cache, and then locate this record in the standard
          cache, so that the 'Tag' routines update the correct record. }
        with JobDetl^.JobActual do
        begin
          UseCustomPrefillCache(SQLCacheID);
          FuncRes := GetPos(F[JDetlF], JDetlF, RecAddr);
          if (FuncRes <> 0) then
            MessageDlg('Failed to get record address, error #' + IntToStr(FuncRes),
                       mtError, [mbOk], 0)
          else
          begin
            Move(RecAddr, ExLocal.LRecPtr[JDetlF]^, SizeOf(RecAddr));
            FuncRes := GetDirect(F[JDetlF], JDetlF, ExLocal.LRecPtr[JDetlF]^, 0, 0);
            if (FuncRes <> 0) then
              MessageDlg('Failed to set record address, error #' + IntToStr(FuncRes),
                         mtError, [mbOk], 0)
          end;
        end;
      end;
      EditActCharge(Self,D1RefPanel.Color,D1RefPanel.Font,Ord(UpTagged),ExLocal,ScanFileNum,KeyPath,LNHCtrl.NHCr);
      if (SQLCacheID <> 0) then
        RefreshCache;
{$ELSE}
      EditActCharge(Self,D1RefPanel.Color,D1RefPanel.Font,Ord(UpTagged),ExLocal,ScanFileNum,KeyPath,LNHCtrl.NHCr);
{$ENDIF}

      If (ValidLine) then
        Update_TaggedWIPBal(JInvHed,JobDetl^,0,BOff);

      RefreshLine(MUListBoxes[0].Row,BOn);


      OutTaggedTots;
    end;

end;

procedure TJInvFrm.OutTaggedTots;

Begin
  With JInvHed do
  Begin
    TagedTotP.Caption:=FormatCurFloat(GenRealMask,TagCost,BOff,InCurr)+' / '+FormatFloat(GenRealMask,TagCharge);
    TagPcntP.Caption:=FormatFloat(GenPcntMask,DivWChk(TagCost,TotCost)*100);
  end;
end;


procedure TJInvFrm.EditD1BtnClick(Sender: TObject);
begin
  EditCharge((Sender=TagD1Btn) or (Sender=Tag1));
end;

procedure TJInvFrm.MTagD1BtnClick(Sender: TObject);
Var
  ListPoint  :  TPoint;

begin
  If (Sender is TButton) then
  With TWinControl(Sender) do
  Begin
    ListPoint.X:=1;
    ListPoint.Y:=1;

    ListPoint:=ClientToScreen(ListPoint);

    SBSPopUpMenu1.PopUp(ListPoint.X,ListPoint.Y);
  end;
end;



procedure TJInvFrm.TagAll1Click(Sender: TObject);
begin
  {$IFDEF Post}
    If (Sender is TMenuItem) then
      AddJobPost2Thread(Self,TMenuItem(Sender).Tag,ExLocal.LJobRec^.JobCode,@JInvHed,Self.Handle);
  {$ENDIF}
end;


procedure TJInvFrm.CustomTag1Click(Sender: TObject);
begin
  {$IFDEF Post}
    Begin
      JCCustmTagInput(Self,23,ExLocal.LJobRec^,JInvHed);
    end;
  {$ENDIF}

end;


procedure TJInvFrm.TSFinBtnClick(Sender: TObject);

begin
  LastValueObj.UpdateAllLastValues(Self);

  If (Not StartInv) then
  Begin
    StartInv:=BOn;

    TSFinBtn.Enabled:=BOff;

    {$IFDEF Post}
      If (CheckTSCompleted(BOn)) then
      Begin


        If (WizLocked) then
          With ExLocal do
          Begin
            UnLockMLock(JobF,LastRecAddr[JobF]);
            WizLocked:=BOff;
          end;

        AddJobPost2Thread(Self,20,ExLocal.LJobRec^.JobCode,@JInvHed,Self.Handle);

      end;
    {$ENDIF}


  end;
end;


procedure TJInvFrm.PrintDoc;


  Begin
    With JInvHed do
    Begin
      {$IFDEF FRM}
        PrintJCDoc(BOn,PrintBS,RetInv.OurRef);
      {$ENDIF}  
    end;


  end;


procedure TJInvFrm.EditIWiz(Fnum,
                            Keypath     :  Integer);

Var
  KeyS  :  Str255;
  
Begin

  SKeypath:=Keypath;

  With ExLocal do
  Begin
    LGetRecAddr(Fnum);

    Ok:=LGetMultiRec(B_GetDirect,B_MultLock,KeyS,KeyPAth,Fnum,BOff,GlobLocked);

    WizLocked:=(Ok) and (GlobLocked);

    If (Not WizLocked) then
      AddCh:=Esc;
  end;


  If (Addch=Esc) then
    Close;

end; {Proc..}

procedure TJInvFrm.PageControl1Change(Sender: TObject);
begin
  if PageControl1.ActivePage = ItemPage then
    BeginTeleSales(True);
end;

Initialization


Finalization


end.
