unit JCSSet1U;

interface

{$I DEFOVR.Inc}

{$F+}

uses
  SysUtils, Windows, Messages, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, TEditVal, ComCtrls, ExtCtrls, SBSPanel, Tabnotbk, Buttons,
  ETMiscU,GlobVar,VarConst,SBSComp,SBSComp2,ExWrap1U,BTSupU1,ColCtrlU,  CmpCtrlU,

  SupListU,

  JCEmpL1U,

  JCAnlI3U,


  Menus;




type

 {=== Cust List ===}

  TAnalList  =  Class(TEmplBList)

    Function Ok2Del :  Boolean; Override;

    Function OutJALine(Col  :  Byte)  :  Str255;

    Function OutJTLine(Col  :  Byte)  :  Str255;

    Function OutLine(Col  :  Byte)  :  Str255; Override;

  end;


  TJAnalList = class(TForm)
    PageControl1: TPageControl;
    TabSheet1: TTabSheet;
    ScrolBox5: TScrollBox;
    TLCompPanel: TSBSPanel;
    TLBalPanel: TSBSPanel;
    TLAccPanel: TSBSPanel;
    TLTelPanel: TSBSPanel;
    SBSPanel1: TSBSPanel;
    PopupMenu1: TPopupMenu;
    PropFlg: TMenuItem;
    N1: TMenuItem;
    StoreCoordFlg: TMenuItem;
    Add1: TMenuItem;
    Edit1: TMenuItem;
    N2: TMenuItem;
    Find1: TMenuItem;
    Ledger1: TMenuItem;
    Notes1: TMenuItem;
    N3: TMenuItem;
    Delete1: TMenuItem;
    Hist1: TMenuItem;
    Print1: TMenuItem;
    Check1: TMenuItem;
    PopupMenu2: TPopupMenu;
    SEC1: TMenuItem;
    SES1: TMenuItem;
    TLAccLab: TSBSPanel;
    TLCompLab: TSBSPanel;
    TLBalLab: TSBSPanel;
    TLTelLab: TSBSPanel;
    Letters1: TMenuItem;
    StkAnal1: TMenuItem;
    TeleSales1: TMenuItem;
    TLWPanel: TSBSPanel;
    TLWLab: TSBSPanel;
    TLPPanel: TSBSPanel;
    TLPLab: TSBSPanel;
    JTypeTSheet: TTabSheet;
    Panel1: TSBSPanel;
    SBSPanel2: TSBSPanel;
    Button13: TButton;
    ScrolBox6: TScrollBox;
    TLCAddBtn: TButton;
    TLCEditBtn: TButton;
    TLCFindBtn: TButton;
    TLCDelBtn: TButton;
    TLCNoteBtn: TButton;
    TLCChkBtn: TButton;
    TLCPrnBtn: TButton;
    TLCLedBtn: TButton;
    TLCHistBtn: TButton;
    TLCLetrBtn: TButton;
    TLCSABtn: TButton;
    TLCTSBtn: TButton;
    procedure FormCreate(Sender: TObject);
    procedure TLAccPanelMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure TLAccLabMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure TLAccLabMouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure FormResize(Sender: TObject);
    procedure TLCloseBtnClick(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure PropFlgClick(Sender: TObject);
    procedure StoreCoordFlgClick(Sender: TObject);
    procedure PopupMenu1Popup(Sender: TObject);
    procedure PageControl1Change(Sender: TObject);
    procedure PageControl1Changing(Sender: TObject;
      var AllowChange: Boolean);
    procedure TLCAddBtnClick(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure FormActivate(Sender: TObject);
    procedure SEC1Click(Sender: TObject);
    procedure TLCSABtnClick(Sender: TObject);
    procedure TLCFindBtnClick(Sender: TObject);

  private
    { Private declarations }


    MULCtrlO   :  Array[0..3] of TAnalList;

    ListOfSet  :  Integer;

    ListActive,
    StoreCoord,
    InAutoRefresh,
    fFrmClosing,
    fDoingClose,
    fNeedCUpdate,
    LastCoord,
    SetDefault,
    GotCoord   :  Boolean;



    PageP,
    ScrollAP,
    ScrollBP,
    Misc1P,
    PanelP     :  TPoint;

    StartSize,
    InitSize   :  TPoint;

    CustActive :  Array[0..3] of Boolean;

    CustRecForm:  Array[0..3] of TJCAnlI1;

    CustBtnList:  Array[0..3] of TVisiBtns;

    procedure Display_Account(Mode  :  Byte);

    procedure FormSetOfSet;

    procedure BuildMenus;

    procedure PrimeButtons(PageNo  :  Integer;
                           PWRef   :  Boolean);


    procedure SetTabs2;

    Procedure Send_ParentMsg(Mode   :  Integer);

    Procedure SetDeleteStat(CPage  :  Integer);

    Procedure WMCustGetRec(Var Message  :  TMessage); Message WM_CustGetRec;

    Procedure WMFormCloseMsg(Var Message  :  TMessage); Message WM_FormCloseMsg;

    Procedure WMGetMinMaxInfo(Var Message  :  TWMGetMinMaxInfo); Message WM_GetMinMaxInfo;

    

    Function KeyPressOk  :  Boolean;

    procedure SetFormProperties;

    procedure Find_FormCoord;

    procedure Store_FormCoord(UpMode  :  Boolean);

    procedure HidePanels(PageNo  :  Byte);

    procedure Page1Create(Sender   : TObject;
                          NewPage  : Byte);

    procedure ShowRightMeny(X,Y,Mode  :  Integer);

    Procedure  SetNeedCUpdate(B  :  Boolean);

    Property NeedCUpDate :  Boolean Read fNeedCUpDate Write SetNeedCUpdate;

    Function CheckListFinished  :  Boolean;

    procedure Check_ValidJATypes;

  public
    { Public declarations }
    ExLocal    :  TdExLocal;

    Function Current_Page  :  Integer;

    Procedure ChangePage(NewPage  :  Integer);

  end;



{~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~}

Implementation

{~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~}

Uses
  ETStrU,
  DebugU,
  BTSupU2,
  VarJCstU,
  JobSup1U,
  BtrvU2,
  BTKeys1U,

  SysU2,
  PWarnU,
  ExThrd2U,
  GenWarnU,
  JChkUseU,
  BTSupU3;

{$R *.DFM}


{ ============== TAnalList Methods =============== }


Function TAnalList.Ok2Del :  Boolean;

Begin
  Result:=(Not CheckExsists(JobMisc^.EmplRec.EmpCode,InvF,InvBatchK));
end;


{ ========== Generic Function to Return Formatted Display for List ======= }


Function TAnalList.OutJALine(Col  :  Byte)  :  Str255;


Var
  FoundCode  :  Str10;
  FoundOk    :  Boolean;
  Dnum       :  Double;

Begin

   With JobMisc^,JobAnalRec do
     Case Col of

       0  :  Result:=JAnalCode;
       1  :  Result:=JAnalName;

       2  :  Begin
               Result:=JobXDesc^[JAType];
             end;
       3  :  Begin
               Result:=SyssJob^.JobSetUp.SummDesc[AnalHed];
             end;

       4,5
          :  Begin
               Result:=Form_BInt(WIPNom[(Col=4)],0);

             end;

       else
             Result:='';

     end; {Case..}
end;



Function TAnalList.OutJTLine(Col  :  Byte)  :  Str255;


Var
  FoundCode  :  Str10;
  FoundOk    :  Boolean;
  Dnum       :  Double;

Begin

   With JobMisc^,JobTypeRec do
     Case Col of

       0  :  Result:=JobType;

       1  :  Result:=JTypeName;


       else
             Result:='';

     end; {Case..}
end;

Function TAnalList.OutLine(Col  :  Byte)  :  Str255;



Begin
  Case DisplayMode of
    0  :  Result:=OutJALine(Col);
    1  :  Result:=OutJTLine(Col);
  end; {Case..}
end;




{ =================================================================================== }



Function TJAnalList.Current_Page  :  Integer;


Begin


  Result:=pcLivePage(PAgeControl1);

end;


procedure TJAnalList.Display_Account(Mode  :  Byte);

Var
  CPage    :  Integer;

  TSBtn    :  TObject;

Begin
  CPage:=Current_Page;


  If (CustRecForm[CPage]=nil) then
  Begin
    SetJTMode:=(CPage=1);
    {Set_CustFormMode(1-CPage);}

    CustRecForm[CPage]:=TJCAnlI1.Create(Self);

  end;

  Try

   CustActive[CPage]:=BOn;

   With CustRecForm[CPage] do
   Begin

     If (Mode=1) then
       ResetRec(JMiscF);

       

     ExLocal.AssignFromGlobal(JMiscF);

     If (Mode=2) then
     Begin
       CSStkCode.ReadOnly:=BOff; {Ent_BeenUsed(2-CPage,JobMisc^.JobAnalRec.JAnalCode);}
     end;

     WindowState:=wsNormal;

     Case Mode of
       1,2  :  If (Mode=2) then
               Begin
                 If JADF.CanFocus then
                   JADF.SetFocus;
               end
               else
                 If (CSStkCode.CanFocus) then
                   CSStkCode.SetFocus;
     end; {case..}

     If (Mode In [1..3]) and (Not ExLocal.InAddEdit) then
     Begin

       If (Mode=3) then
         DeleteBomLine(JMiscF,JMK)
       else
         EditLine((Mode=2));
     end;


   end; {With..}


  except

   CustActive[Current_Page]:=BOff;

   CustRecForm[Current_Page].Free;

  end;



end;




Procedure  TJAnalList.SetNeedCUpdate(B  :  Boolean);

Begin
  If (Not fNeedCUpdate) then
    fNeedCUpdate:=B;
end;

procedure TJAnalList.Find_FormCoord;


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

    PrimeKey:='A';

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

    GetbtControlCsm(ScrolBox5);

    GetbtControlCsm(ScrolBox6);

    GetbtControlCsm(Panel1);

    GetbtControlCsm(SBSPanel2);

    GetbtControlCsm(SBSPanel1);

    MULCtrlO[0].Find_ListCoord(GlobComp);

  end; {With GlobComp..}

  SBSPanel1.Color:=TLAccLab.Color;

  Dispose(GlobComp,Destroy);

      {* Check form is within current visible range *}

  With TForm(Owner) do
    VisibleRect:=Rect(0,0,ClientWidth,ClientHeight);

  If (Not PtInRect(VisibleRect,Point(Left,Top))) then
  Begin
    Left:=0;
    Top:=0;
  end;

    {NeedCUpdate}
  StartSize.X:=Width; StartSize.Y:=Height;

end;


procedure TJAnalList.Store_FormCoord(UpMode  :  Boolean);


Var
  GlobComp:  TGlobCompRec;


Begin


  New(GlobComp,Create(BOff));

  With GlobComp^ do
  Begin
    GetValues:=UpMode;

    PrimeKey:='A';

    ColOrd:=Ord(StoreCoord);

    HLite:=Ord(LastCoord);

    SaveCoord:=StoreCoord;

    If (Not LastCoord) then {* Attempt to store last coord *}
      HLite:=ColOrd;

    StorebtControlCsm(Self);

    StorebtControlCsm(PageControl1);

    StorebtControlCsm(ScrolBox5);

    StorebtControlCsm(ScrolBox6);

    StorebtControlCsm(Panel1);

    StorebtControlCsm(SBSPanel1);

    StorebtControlCsm(SBSPanel2);

    MULCtrlO[0].Store_ListCoord(GlobComp);

  end; {With GlobComp..}

  GlobComp.Destroy;

end;



procedure TJAnalList.FormSetOfSet;


Begin
  PageP.X:=ClientWidth-(PageControl1.Width);
  PageP.Y:=ClientHeight-(PageControl1.Height);

  ScrollAP.X:=PageControl1.Width-(ScrolBox5.Width);
  ScrollAP.Y:=PageControl1.Height-(ScrolBox5.Height);

  ScrollBP.X:=PageControl1.Width-(Panel1.Left);
  ScrollBP.Y:=PageControl1.Height-(Panel1.Height);

  Misc1P.X:=Panel1.Height-(ScrolBox6.Height);
  Misc1P.Y:=ScrolBox5.ClientHeight-(TLAccPanel.Height);

  PanelP.X:=PageControl1.Width-(SBSPanel2.Left);
  PanelP.Y:=Panel1.Height-(SBSPanel2.Height);


  GotCoord:=BOn;

end;

procedure TJAnalList.BuildMenus;

Begin
  {}
  CreateSubMenu(PopUpMenu2,StkAnal1);
end;


procedure TJAnalList.PrimeButtons(PageNo  :  Integer;
                                 PWRef   :  Boolean);

Var
  LastPage  :  TTabSheet;


Begin
  If (PWRef) and (Assigned(CustBtnList[PageNo])) then
  Begin
    LastPage:=PageControl1.ActivePage;

    SetTabs2;

    If (PageControl1.ActivePage<>LastPage) then
      PageControl1.ActivePage:=LastPage;

    CustBtnList[PageNo].ResetButtons;
    CustBtnList[PageNo].Free;
    CustBtnList[PageNo]:=nil;
  end;

  If (CustBtnList[PageNo]=Nil) then
  Begin
    CustBtnList[PageNo]:=TVisiBtns.Create;

    try

      With CustBtnList[PageNo] do
      Case PageNo of

        0   :  Begin
            {00} PWAddVisiRec(TLCAddBtn,BOff,-255);
            {01} PWAddVisiRec(TLCEditBtn,BOff,-255);
            {02} PWAddVisiRec(TLCFindBtn,BOff,-255);
            {03} PWAddVisiRec(TLCDelBtn,BOff,-255);
            {04} PWAddVisiRec(TLCLedBtn,BOn,223);
            {05} PWAddVisiRec(TLCHistBtn,BOn,224);
            {06} PWAddVisiRec(TLCNoteBtn,BOn,-255);
            {07} PWAddVisiRec(TLCLetrBtn,BOn,-255);
            {08} PWAddVisiRec(TLCSABtn,BOff,-255);
            {09} PWAddVisiRec(TLCTSBtn,BOn,222);
            {10} PWAddVisiRec(TLCPrnBtn,BOn,-255);
            {11} PWAddVisiRec(TLCChkBtn,BOn,-255);

                 HideButtons;
               end;


      end; {Case..}

    except

      CustBtnList[PageNo].Free;

    end; {Try..}

  end;

end;

procedure TJAnalList.SetTabs2;

Begin
  {Control visible tabs}

  TabSheet1.TabVisible:=PChkAllowed_In(236);
  JTypeTSheet.TabVisible:=PChkAllowed_In(237);

end;

procedure TJAnalList.FormCreate(Sender: TObject);
Var
  n  :  Integer;

  StartPanel
     :  TSBSPanel;

  KeyStart
     :  Str255;

begin
  fDoingClose:=BOff;

  PrimeButtons(0,BOff);

  BuildMenus;

  ListActive:=BOff;
  GotCoord:=BOff;

  LastCoord:=BOff;
  NeedCUpdate:=BOff;

  InAutoRefresh:=BOff;
  fFrmClosing:=BOff;

  ExLocal.Create;

  StartPanel := nil;


  
  For n:=0 to Pred(ComponentCount) do
    If (Components[n] is TScrollBox) then
    With TScrollBox(Components[n]) do
    Begin
      VertScrollBar.Position:=0;
      HorzScrollBar.Position:=0;
    end;

  VertScrollBar.Position:=0;
  HorzScrollBar.Position:=0;


  MULCtrlO[0]:=TAnalList.Create(Self);

  PageControl1.ActivePage:=TabSheet1;


  Try

    With MULCtrlO[0] do
    Begin

      Try

        With VisiList do
        Begin
          AddVisiRec(TLAccPanel,TLAccLab);
          AddVisiRec(TLCompPanel,TLCompLab);
          AddVisiRec(TLBalPanel,TLBalLab);
          AddVisiRec(TLTelPanel,TLTelLab);
          AddVisiRec(TLWPanel,TLWLab);
          AddVisiRec(TLPPanel,TLPLab);

          VisiRec:=List[0];

          StartPanel:=(VisiRec^.PanelObj as TSBSPanel);

          LabHedPanel:=SBSPanel1;

        end;
      except
        VisiList.Free;

      end;

      {InitSize.Y:=366;
      InitSize.X:=472;

      Self.Height:=InitSize.Y;
      Self.Width:=InitSize.X;}

      InitSize.Y:=342;
      InitSize.X:=576;

      Self.ClientHeight:=InitSize.Y;
      Self.ClientWidth:=InitSize.X;


      MDI_SetFormCoord(TForm(Self));

      Find_FormCoord;



      TabOrder := -1;
      TabStop:=BOff;
      Visible:=BOff;
      BevelOuter := bvNone;
      ParentColor := False;
      Color:=StartPanel.Color;
      MUTotCols:=5;
      Font:=StartPanel.Font;
      LinkOtherDisp:=BOn;

      WM_ListGetRec:=WM_CustGetRec;


      Parent:=StartPanel.Parent;

      MessHandle:=Self.Handle;

      For n:=0 to MUTotCols do
      With ColAppear^[n] do
      Begin
        AltDefault:=BOn;

        {HBkColor:=ClHighLight;
        HTextColor:=ClHighLightText;}

      end;

      Self.Refresh;

      ListCreate;


      Set_Buttons(SBSPanel2);

      AbortOnEmpty:=BOn;

      KeyStart:=PartCCKey(JARCode,JASubAry[2]);

      StartList(JMiscF,JMK,KeyStart,'','',Length(KeyStart),BOff);


      ListOfSet:=10;



    end {With}


  Except

    MULCtrlO[0].Free;
    MULCtrlO[0]:=Nil;
  end;


  FormSetOfSet;

  SetTabs2;

  If (Not TabSheet1.TabVisible) then
  Begin
    PageControl1.ActivePage:=JTypeTSheet;
    PageControl1Change(PageControl1);
  end;
end;


procedure TJAnalList.FormActivate(Sender: TObject);
begin
  If (MULCtrlO[0]<>nil) then
    MULCtrlO[0].SetListFocus;

  ListActive:=BOn;
end;


procedure TJAnalList.FormDestroy(Sender: TObject);

Var
  n  :  Byte;

begin

  ExLocal.Destroy;

  For n:=Low(CustBtnList) to High(CustBtnList) do
    If (CustBtnList[n]<>nil) then
    Begin
      CustBtnList[n].Free;
      CustBtnList[n]:=nil;
    end;


  {$IFDEF XXXXX} {*EN430}
    For n:=0 to High(MULCtrlO) do  {* Seems to crash here if form open and you close app... *}
      If (MULCtrlO[n]<>nil) then
      Begin
        MULCtrlO[n].Destroy;
        MULCtrlO[n]:=nil;
      end;

  {$ENDIF}

end;





Procedure TJAnalList.SetDeleteStat(CPage  :  Integer);

Var
  CanDelete  :  Boolean;

Begin
  If (Assigned(MULCtrlO[0])) then
  Begin
    CanDelete:=BOn;

    Case Current_Page of

      0  :  TLCDelBtn.Enabled:=CanDelete;

    end; {Case..}
  end;
end;


Procedure TJAnalList.WMCustGetRec(Var Message  :  TMessage);


Begin


  With Message do
  Begin

    {If (Debug) then
      DebugForm.Add('Mesage Flg'+IntToStr(WParam));}

    Case WParam of


      0,169
         :  Begin

              Display_Account(2);

            end;

      1  :  PostMessage(Self.Handle,WM_FormCloseMsg,1000+WParam,0); {* This was placed here to stop the mouse up event from being corrupted *}


      2  :  ShowRightMeny(LParamLo,LParamHi,1);

      25 :  NeedCUpdate:=BOn;

    100,
    101  :  With MULCtrlO[WParam-100] do
            Begin
              AddNewRow(MUListBoxes[0].Row,(LParam=1));
            end;

    170  :  ;{TLCPrnBtnClick(nil);}
    175
         :  With PageControl1 do
              ChangePage(FindNextPage(ActivePage,(LParam=0),BOn).PageIndex);

    177  :  Begin
              PrimeButtons(0,BOn);

              Check_TabAfterPW(PageControl1,Self,WM_CustGetRec);

            end;


    200,
    201  :  Begin
              CustActive[WParam-200]:=Boff;
              CustRecForm[WParam-200]:=nil;

            end;

    300,
    301  :  With MULCtrlO[WParam-300] do
            Begin
              If (MUListBox1.Row<>0) then
                PageUpDn(0,BOn)
              else
                InitPage;
            end;




    end; {Case..}

    If (WParam in [1,2]) then
     SetDeleteStat(Current_Page);

  end;
  Inherited;
end;



Procedure TJAnalList.WMFormCloseMsg(Var Message  :  TMessage);


Begin

  With Message do
  Begin

    Case WParam of
      1001  : {* This handling was placed here so to give the list a chance to see the mouse up event *}

            Begin

            End; { 1 }


    end; {Case..}

  end; {With..}

end; {Proc..}



Procedure TJAnalList.WMGetMinMaxInfo(Var Message  :  TWMGetMinMaxInfo);

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

procedure TJAnalList.TLAccPanelMouseUp(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);

Var
  BarPos :  Integer;
  PanRSized
         :  Boolean;



begin
  BarPos:=0;

  If (Sender is TSBSPanel) then
  With (Sender as TSBSPanel) do
  Begin

    PanRSized:=ReSized;

    Case Current_Page of
      0  :  BarPos:=ScrolBox5.HorzScrollBar.Position;
    end;

    If (PanRsized) then
      MULCtrlO[Current_Page].ResizeAllCols(MULCtrlO[Current_Page].VisiList.FindxHandle(Sender),BarPos);

    MULCtrlO[Current_Page].FinishColMove(BarPos+(ListOfset*Ord(PanRSized)),PanRsized);

    NeedCUpdate:=(MULCtrlO[Current_Page].VisiList.MovingLab or PanRSized);
  end;

end;


procedure TJAnalList.TLAccLabMouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
Var
  ListPoint  :  TPoint;


begin
  If (Sender is TSBSPanel) then
  With (Sender as TSBSPanel) do
  Begin

    If (Not ReadytoDrag) and (Button=MBLeft) then
    Begin
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

procedure TJAnalList.TLAccLabMouseMove(Sender: TObject; Shift: TShiftState;
  X, Y: Integer);


begin
  If (Sender is TSBSPanel) then
  With (Sender as TSBSPanel) do
  Begin

    MULCtrlO[Current_Page].VisiList.MoveLabel(X,Y);
    NeedCUpdate:=MULCtrlO[Current_Page].VisiList.MovingLab;
  end;

end;

procedure TJAnalList.FormResize(Sender: TObject);

Var
  n          :  Byte;


begin

  If (GotCoord) and (Not fDoingClose) then
  Begin
    MULCtrlO[Current_Page].LinkOtherDisp:=BOff;

    Self.HorzScrollBar.Position:=0;
    Self.VertScrollBar.Position:=0;

    PageControl1.Width:=ClientWidth-PageP.X;
    PageControl1.Height:=ClientHeight-PageP.Y;


    ScrolBox5.Width:=PageControl1.Width-ScrollAP.X;
    ScrolBox5.Height:=PageControl1.Height-ScrollAP.Y;

    Panel1.Left:=PageControl1.Width-ScrollBP.X;
    Panel1.Height:=PageControl1.Height-ScrollBP.Y;

    ScrolBox6.Height:=Panel1.Height-Misc1P.X;

    {SBSPanel2.Left:=PageControl1.Width-PanelP.X;}
    SBSPanel2.Height:=Panel1.Height-PanelP.Y;


    n:=0;

    If (MULCtrlO[n]<>nil) then
    Begin
      With MULCtrlO[n].VisiList do
      Begin
        VisiRec:=List[0];

        With (VisiRec^.PanelObj as TSBSPanel) do
          Height:=ScrolBox5.ClientHeight-Misc1P.Y;
      end;


      With MULCtrlO[n] do
      Begin
        ReFresh_Buttons;

        RefreshAllCols;
      end;
    end;{Loop..}

    MULCtrlO[Current_Page].LinkOtherDisp:=BOn;

    NeedCUpdate:=((StartSize.X<>Width) or (StartSize.Y<>Height));

  end; {If time to update}
end; {Proc..}

procedure TJAnalList.TLCloseBtnClick(Sender: TObject);
begin
  If (Not MULCtrlO[Current_Page].InListFind) then
  Begin

    Close;

  end;
end;

procedure TJAnalList.SetFormProperties;


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
        SetProperties(TmpPanel[1],TmpPanel[2],TmpPanel[3],1,'Job Analysis List Properties',BeenChange,ResetDefaults);

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

procedure TJAnalList.PropFlgClick(Sender: TObject);
begin
  SetFormProperties;
end;

procedure TJAnalList.StoreCoordFlgClick(Sender: TObject);
begin
  StoreCoord:=Not StoreCoord;
  NeedCUpdate:=BOn;
end;


procedure TJAnalList.PopupMenu1Popup(Sender: TObject);

Var
  n  :  Integer;

begin
  StoreCoordFlg.Checked:=StoreCoord;

  With CustBtnList[0] do
  Begin
    ResetMenuStat(PopUpMenu1,BOn,BOn);

    With PopUpMenu1 do
    For n:=0 to Pred(Count) do
      SetMenuFBtn(Items[n],n);

  end;


end;

procedure TJAnalList.ShowRightMeny(X,Y,Mode  :  Integer);

Begin
  With PopUpMenu1 do
  Begin
    N3.Tag:=99*Mode;

    PopUp(X,Y);

    N3.Tag:=0;
  end;


end;


{ == Procedure to Send Message to Get Record == }

Procedure TJAnalList.Send_ParentMsg(Mode   :  Integer);

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

  end;

  With Message1 do
    MessResult:=SendMEssage((Owner as TForm).Handle,Msg,WParam,LParam);

end; {Proc..}

procedure TJAnalList.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  If (Not fDoingClose) then
  Begin
    fDoingClose:=BOn;

    Action:=caFree;

    Send_ParentMsg(57); {Form closing..}

    If (MULCtrlO[0]<>nil) then
    Begin
      try
        MULCtrlO[0].Destroy;
      finally
        MULCtrlO[0]:=nil;
      end;
    end;

  end;

end;

Function TJAnalList.CheckListFinished  :  Boolean;

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


procedure TJAnalList.FormCloseQuery(Sender: TObject; var CanClose: Boolean);

Var
  n  :  Integer;

begin

  If (Not fFrmClosing) then
  Begin
    fFrmClosing:=BOn;

    Try
      GenCanClose(Self,Sender,CanClose,BOn);

      If (CanClose) then
        CanClose:=CheckListFinished;

      If (CanClose) then
        CanClose:=Not InAutoRefresh;

      If (CanClose) then
        Check_ValidJATypes;
        
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
          Store_FormCoord(Not SetDefault);

      end;
    Finally
      fFrmClosing:=BOff;
    end;
  end
  else
    CanClose:=BOff;
end;


procedure TJAnalList.HidePanels(PageNo  :  Byte);

Var
  NomDayBk  :  Boolean;

Begin
  With MULCtrlO[PageNo],VisiList do
  Begin
    SetHidePanel(FindxColOrder(2),(PageNo<>0),BOff);
    SetHidePanel(FindxColOrder(3),(PageNo<>0),BOff);
    SetHidePanel(FindxColOrder(4),(PageNo<>0),BOff);
    SetHidePanel(FindxColOrder(5),(PageNo<>0),BOn);
  end;
end;


procedure TJAnalList.Page1Create(Sender   : TObject;
                                 NewPage  : Byte);

Var
  n           :  Byte;

  StartPanel  :  TSBSPanel;

  TKeyLen,
  TFnum,
  TKeypath    :  Integer;

  KeyStart,
  KeyPrime,
  KeyEnd      :  Str255;

begin
   TKeyLen := 0;
   TFNum := 0;
   TKeypath := 0;
   
   ScrolBox5.HorzScrollBar.Position:=0;

   If (Not Assigned(MULCtrlO[NewPage])) then
     MULCtrlO[NewPage]:=MULCtrlO[0];

   HidePanels(NewPage);

   KeyPrime:='';

   With MULCtrlO[NewPage] do
   Begin
     HighLiteStyle[1]:=[fsBold];

     RefreshAllCols;

     Case NewPage of

       0  :  Begin
               KeyStart:=PartCCKey(JARCode,JASubAry[2]);

               TKeyLen:=Length(KeyStart);

               KeyEnd:=KeyStart;

               TKeyPath:=JMK;
               TFnum:=JMiscF;

               UseSet4End:=BOff;

               NoUpCaseCheck:=BOff;

             end;

       1  :  Begin
               KeyStart:=PartCCKey(JARCode,JASubAry[1]);

               TKeyLen:=Length(KeyStart);

               KeyEnd:=KeyStart;

               TKeyPath:=JMK;
               TFnum:=JMiscF;

               UseSet4End:=BOff;

               NoUpCaseCheck:=BOff;


             end;



     end; {case...}

     DisplayMode:=NewPage;


     StartList(TFnum,TKeyPath,KeyStart,KeyEnd,KeyPrime,TKeyLen,BOff);

   end; {With..}


   MDI_UpdateParentStat;

end;


procedure TJAnalList.PageControl1Change(Sender: TObject);
Var
  n,
  NewIndex  :  Integer;
begin

  If (Sender is TPageControl) then
    With Sender as TPageControl do
    Begin
      NewIndex:=pcLivePage(Sender);

      Case NewIndex of
        0..1  :  Page1Create(Sender,NewIndex);
      end; {Case..}

      ScrolBox5.Parent:=PageControl1.ActivePage;


      If (MULCtrlO[NewIndex]<>nil) and (ListActive) then
      With MULCtrlO[NewIndex] do
      Begin
        {If (Not (NewIndex In [3,5])) then}
        Begin
          If (MUListBox1.Row<>0) then
            PageUpDn(0,BOn)
          else
            InitPage;
        end;

        SetListFocus;
      end;

      PrimeButtons(0,BOff);

    end;

end;


procedure TJAnalList.PageControl1Changing(Sender: TObject;
  var AllowChange: Boolean);

begin

  Release_PageHandle(Sender);

end;

Procedure TJAnalList.ChangePage(NewPage  :  Integer);


Begin

  If (Current_Page<>NewPage) then
  With PageControl1 do
  Begin
    Case NewPage of

      0  :  ActivePage:=TabSheet1;
      1  :  ActivePage:=JTypeTSheet;

    end; {Case..}

    PageControl1Change(PageControl1);
  end; {With..}
end; {Proc..}


Function TJAnalList.KeyPressOk  :  Boolean;

Begin
  If (Assigned(MULCtrlO[Current_Page])) then
    Result:=Not MULCtrlO[Current_Page].InListFind
  else
    Result:=BOn;
end;

procedure TJAnalList.TLCAddBtnClick(Sender: TObject);

Var
  EditMode,
  DelMode,
  NoteMode,
  HistMode,
  LedgMode   :  Boolean;

begin
  If (Not MULCtrlO[Current_Page].InListFind) then
  Begin

    With MULCtrlO[Current_Page] do
      RefreshLine(MUListBoxes[0].Row,BOff);

    EditMode:=((Sender=TLCEditBtn) or (Sender=Edit1));

    DelMode:=((Sender=TLCDelBtn) or (Sender=Delete1));

    NoteMode:=((Sender=TLCNoteBtn) or (Sender=Notes1));

    LedgMode:=((Sender=TLCLedBtn) or (Sender=Ledger1));

    {$B-}
    If (DelMode) and (Ent_BeenUsed(2-Current_Page,JobMisc^.JobAnalRec.JAnalCode)) then
      ShowMessage('This record is in use elsewhere in the system, it cannot be deleted.')

    {$B+}

    else
      Display_Account(1+(1*Ord(EditMode))+(2*Ord(DelMode))+(4*Ord(NoteMode))+(5*Ord(LedgMode)));

  end;
end;


procedure TJAnalList.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  GlobFormKeyDown(Sender,Key,Shift,ActiveControl,Handle);
end;

procedure TJAnalList.SEC1Click(Sender: TObject);
begin
  If Assigned(MULCtrlO[Current_Page]) and (Sender is TMenuItem) then
  With MULCtrlO[Current_Page] do
  Begin
    Case TMenuItem(Sender).Tag of
      0  :  Keypath:=JMK;
      1  :  Keypath:=JMSecK;
      2  :  Keypath:=JMTrdK;

    end; {Case..}

    InitPage;
  end;


end;

procedure TJAnalList.TLCSABtnClick(Sender: TObject);
Var
  ListPoint  :  TPoint;

begin

  If (KeyPressOk) then
  Begin

    If (Current_Page=0) then
    Begin
      Begin
        With TWinControl(Sender) do
        Begin
          ListPoint.X:=1;
          ListPoint.Y:=1;

          ListPoint:=ClientToScreen(ListPoint);

        end;

        PopUpMenu2.PopUp(ListPoint.X,ListPoint.Y);
      end;
    end;
  end;
end;



procedure TJAnalList.TLCFindBtnClick(Sender: TObject);
begin

  If (Not MULCtrlO[Current_Page].InListFind)  then
  Begin
    MULCtrlO[Current_Page].GetMiniRec(2-Current_Page);
  end;

end;


{ == Procedure to check for minimal analysis code types == }
{1=WIP, 2=S.Ret, 3=P.Ret, 4=Rev }

procedure TJAnalList.Check_ValidJATypes;

Const
  Fnum      =  JMiscF;
  Keypath   =  JMK;

  CatXlate  :  Array[1..5] of Byte = (8,9,10,1,7);

Var
  UpSyss,
  FoundOk :  Boolean;

  n       :  Byte;
  KeyChk,
  KeyS    :  Str255;

  TmpJCA  :  Array[1..5] of Str10;


Begin
  UpSyss:=BOff;

  FillChar(TmpJCA,Sizeof(TmpJCA),0);

  With SyssJob^.JobSetUp do
  Begin
    For n:=Low(JCChkACode) to High(JCChkACode) do
    Begin
      TmpJCA[n]:=JCChkACode[n];

      FoundOk:=BOff;


      If (Not EmptyKey(JCChkACode[n],AnalKeyLen)) then {* See if it still there.. *}
      Begin
        FoundOk:=CheckRecExsists(FullJAKey(JARCode,JASubAry[2],JCChkACode[n]),JMiscF,JMK);

        If (FoundOk) then
          FoundOk:=(JobMisc^.JobAnalRec.AnalHed=CatXlate[n]);
      end;

      If (Not FoundOk) then {* Finad another one... *}
      Begin
        KeyChk:=PartCCKey(JARCode,JASubAry[2]);
        KeyS:=KeyChk;

        Status:=Find_Rec(B_GetGEq,F[Fnum],Fnum,RecPtr[Fnum]^,keypath,KeyS);

        While (StatusOk) and (CheckKey(KeyChk,KeyS,Length(KeyChk),BOn)) and (Not FoundOk) do
        With JobMisc^.JobAnalRec do
        Begin
          Application.ProcessMessages;

          FoundOk:=(AnalHed=CatXlate[n]);

          If (Not FoundOk) then
            Status:=Find_Rec(B_GetNext,F[Fnum],Fnum,RecPtr[Fnum]^,keypath,KeyS);

        end; {While..}


        If (FoundOk) then
        Begin
          TmpJCA[n]:=JobMisc^.JobAnalRec.JAnalCode;

          UpSyss:=BOn;
        end
        else
        Begin
          {* Warn type missing *}
          Set_BackThreadMVisible(BOn);

          CustomDlg(Application.MainForm,'Please Note!','Analysis Code missing',
                               'Within the Job Analysis Codes you must specify at least one '+
                               Trim(SummDesc[CatXlate[n]])+' type.'+#13+
                               'The Job Costing system will not operate correctly without it.'+#13+
                               'Please add this type in before attempting to use Job Costing.',
                               mtInformation,
                               [mbOk]);

          Set_BackThreadMVisible(BOff);

        end;
      end; {Serach for new analysis code}
    end; {Loop..}

    If (UpSyss) then
    Begin
      FoundOk:=BOn;

      If GetMultiSys(BOff,FoundOk,JobSR) then {* Update control codes *}
      Begin
        For n:=Low(JCChkACode) to High(JCChkACode) do
          JCChkACode[n]:=TmpJCA[n];

        PutMultiSys(JobSR,BOn);
      end;
    end;
  end; {With..}


end;


Initialization


end.
