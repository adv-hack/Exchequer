unit BomCmpU;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, TEditVal, ExtCtrls, SBSPanel, ComCtrls,
  GlobVar,VarConst,ExWrap1U,BTSupU1,SupListU,SBSComp2,

  {SalTxL2U,}

  StkAdjU,

  {$IFDEF SOP}
    StkLocEU,
  {$ENDIF}

  Menus;




type
  TCMPSerCtrl = class(TForm)
    PageControl1: TPageControl;
    AdjustPage: TTabSheet;
    A1SBox: TScrollBox;
    A1HedPanel: TSBSPanel;
    A1CLab: TSBSPanel;
    A1OLab: TSBSPanel;
    A1DLab: TSBSPanel;
    A1ILab: TSBSPanel;
    A1BLab: TSBSPanel;
    A1ULab: TSBSPanel;
    A1CPanel: TSBSPanel;
    A1IPanel: TSBSPanel;
    A1DPanel: TSBSPanel;
    A1OPanel: TSBSPanel;
    A1BPanel: TSBSPanel;
    A1UPanel: TSBSPanel;
    A1BtmPanel: TSBSPanel;
    BOMNameP: TSBSPanel;
    DrReqdTit: Label8;
    CostLab: Label8;
    A1ListBtnPanel: TSBSPanel;
    A1BtnPanel: TSBSPanel;
    ClsN1Btn: TButton;
    A1BSBox: TScrollBox;
    AddN1Btn: TButton;
    EditN1Btn: TButton;
    A1LocPanel: TSBSPanel;
    A1LocLab: TSBSPanel;
    PopupMenu1: TPopupMenu;
    Add1: TMenuItem;
    Edit1: TMenuItem;
    N2: TMenuItem;
    PropFlg: TMenuItem;
    N1: TMenuItem;
    StoreCoordFlg: TMenuItem;
    N3: TMenuItem;
    procedure PageControl1Change(Sender: TObject);
    procedure PageControl1Changing(Sender: TObject;
      var AllowChange: Boolean);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormResize(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure FormKeyPress(Sender: TObject; var Key: Char);
    procedure ClsN1BtnClick(Sender: TObject);
    procedure A1CPanelMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure A1CLabMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure A1CLabMouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure PopupMenu1Popup(Sender: TObject);
    procedure PropFlgClick(Sender: TObject);
    procedure StoreCoordFlgClick(Sender: TObject);
    procedure AddN1BtnClick(Sender: TObject);
    procedure EditN1BtnClick(Sender: TObject);
  private
    InGetSer,
    JustCreated,
    InvStored,
    StopPageChange,
    FirstStore,
    ReCalcTot,
    StoreCoord,
    LastCoord,
    SetDefault,
    fNeedCUpdate,
    fDoingClose,
    WarnOnce,
    GotCoord,
    CanDelete    :  Boolean;

    SKeypath,
    MinHeight,
    MinWidth     :  Integer;

    InvBtnList   :  TVisiBtns;

    RecordPage   :  Byte;
    DocHed       :  DocTypes;

    OldConTot    :  Double;


    PagePoint    :  Array[0..6] of TPoint;

    StartSize,
    InitSize     :  TPoint;

    {$IFDEF SOP}
      STARec       :  TCompAdj;
    {$ENDIF}

    Procedure ChangePage(NewPage  :  Integer);

    procedure Find_FormCoord;

    procedure Store_FormCoord(UpMode  :  Boolean);

    Procedure Link2Stk;

    Procedure WMCustGetRec(Var Message  :  TMessage); Message WM_CustGetRec;

    Procedure WMGetMinMaxInfo(Var Message  :  TWMGetMinMaxInfo); Message WM_GetMinMaxInfo;

    

    Procedure Send_UpdateList(Edit   :  Boolean;
                              Mode   :  Integer);

    procedure ShowRightMeny(X,Y,Mode  :  Integer);

    procedure SetFormProperties(SetList  :  Boolean);

    Procedure  SetNeedCUpdate(B  :  Boolean);

    Function Check_LinesOk(InvR      :  InvRec)  :  Boolean;


    Property NeedCUpDate :  Boolean Read fNeedCUpDate Write SetNeedCUpdate;

  public
    { Public declarations }

    StkActive  :  Boolean;

    ExLocal    :  TdExLocal;
    ListOfSet  :  Integer;

    MULCtrlO   :  TAdjMList;

    Opt        :  Byte;

    Function SetHelpC(PageNo :  Integer;
                      Pages  :  TIntSet;
                      Help0,
                      Help1  :  LongInt) :  LongInt;

    procedure Display_STARec;

    procedure PrimeButtons;

    procedure BuildDesign;

    procedure FormDesign;

    Function Current_BarPos(PageNo  :  Byte)  :  Integer;

    procedure RefreshList(ShowLines,
                          IgMsg      :  Boolean);

    procedure FormBuildList(ShowLines  :  Boolean);

    Function Current_Page  :  Integer;

    procedure FormSetOfSet;


    procedure EditAccount(InvR  :  InvRec;
                          OMode :  Byte);


  end;


Procedure Set_HiddenSer(fInv  :  InvRec;
                        OMode :  Byte);


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
  SBSComp,
  ComnUnit,
  ComnU2,
  CurrncyU,
  InvListU,

  {$IFDEF PF_On}

    InvLst2U,

  {$ENDIF}

  {$IFDEF GF}
    FindRecU,
    FindCtlU,
  {$ENDIF}

  {$IFDEF NP}
    NoteSupU,
  {$ENDIF}

  {$IFDEF DBD}
    DebugU,
  {$ENDIF}

  InvCTSUU,
  PWarnU,
  SysU1,
  SysU2,
  IntMU,
  MiscU,
  PayF2U,

  SalTxl2U,

  {$IFDEF FRM}
    DefProcU,
  {$ENDIF}

  ExThrd2U,

  AdjCtrlU;


{$R *.DFM}




Procedure  TCMPSerCtrl.SetNeedCUpdate(B  :  Boolean);

Begin
  If (Not fNeedCUpdate) then
    fNeedCUpdate:=B;
end;


procedure TCMPSerCtrl.Find_FormCoord;


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

    PrimeKey:='R';

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

    GetbtControlCsm(A1SBox);

    GetbtControlCsm(A1BSBox);

    GetbtControlCsm(A1BtnPanel);

    GetbtControlCsm(A1ListBtnPanel);


    MULCtrlO.Find_ListCoord(GlobComp);

  end; {With GlobComp..}


  Dispose(GlobComp,Destroy);

      {* Check form is within current visible range *}

  With TForm(Owner) do
    VisibleRect:=Rect(0,0,ClientWidth,ClientHeight);

  If (Not PtInRect(VisibleRect,Point(Left,Top))) then
  Begin
    Left:=0;
    Top:=0;
  end;

  StartSize.X:=Width; StartSize.Y:=Height;

end;


procedure TCMPSerCtrl.Store_FormCoord(UpMode  :  Boolean);


Var
  GlobComp:  TGlobCompRec;


Begin

  New(GlobComp,Create(BOff));

  With GlobComp^ do
  Begin
    GetValues:=UpMode;

    PrimeKey:='R';

    ColOrd:=Ord(StoreCoord);

    HLite:=Ord(LastCoord);

    SaveCoord:=StoreCoord;

    If (Not LastCoord) then {* Attempt to store last coord *}
      HLite:=ColOrd;

    StorebtControlCsm(Self);

    StorebtControlCsm(PageControl1);

    StorebtControlCsm(A1SBox);

    StorebtControlCsm(A1BSBox);

    StorebtControlCsm(A1BtnPanel);

    StorebtControlCsm(A1ListBtnPanel);

    MULCtrlO.Store_ListCoord(GlobComp);

  end; {With GlobComp..}

  Dispose(GlobComp,Destroy);

end;






Function TCMPSerCtrl.Current_Page  :  Integer;
Begin

  Result:=pcLivePage(PAgeControl1);

end;


Procedure TCMPSerCtrl.Link2Stk;

Var
  FoundOk   :  Boolean;
  FoundLong :  LongInt;
  FoundStk  :  Str20;

  TmpStk  :  StockRec;

  Begin
    TmpStk:=Stock;

    With Id, Stock do
    Begin

      If (Stock.StockFolio<>KitLink) then
        If CheckRecExsists(FullNomKey(KitLink),StockF,StkFolioK) then;


      CostLab.Caption:=dbFormatName(StockCode,Desc[1]);
  end;

  Stock:=TmpStk;
end;


Procedure TCMPSerCtrl.WMCustGetRec(Var Message  :  TMessage);
Begin


  With Message do
  Begin

    {If (Debug) then
      DebugForm.Add('Mesage Flg'+IntToStr(WParam));}

    Case WParam of
      0,169
         :  Begin

              If (WParam=169) then
                MULCtrlO.GetSelRec(BOff);

              Case Current_Page of

                  1  :  ;

                else  Begin

                        If (Syss.UseMLoc) and (Not InGetSer) then
                          Display_StaRec;
                      end;
              end; {Case..}
            end;

      1  :  Begin

              {* Show nominal/cc dep data *}

              Link2Stk;

            end;

      2  :  ShowRightMeny(LParamLo,LParamHi,1);

     17  :  Begin {* Force reset of form *}
              GotCoord:=BOff;
              SetDefault:=BOn;
              Close;
            end;

      25  :  NeedCUpdate:=BOn;


     108  :
             Begin
               With MULCtrlO do
                 AddNewRow(MUListBoxes[0].Row,(LParam=1));


            end;

    120,121
         :  Begin

              InvBtnList.SetEnabBtn((WParam=120));

            end;


     175
         :  With PageControl1 do
              ChangePage(FindNextPage(ActivePage,(LParam=0),BOn).PageIndex);


     176 :  Case LParam of
              0  :  Case Current_Page of
                      1  :  ;
                      else  If (Assigned(MULCtrlO)) then
                              MULCtrlO.SetListFocus;

                    end; {Case..}
            end; {Case..}



     
     217  :  Begin
                {$IFDEF SOP}
                  STARec:=nil;
                {$ENDIF}
              end;


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


Procedure TCMPSerCtrl.WMGetMinMaxInfo(Var Message  :  TWMGetMinMaxInfo);

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

Procedure TCMPSerCtrl.Send_UpdateList(Edit   :  Boolean;
                                  Mode   :  Integer);

Var
  Message1 :  TMessage;
  MessResult
           :  LongInt;

Begin
  FillChar(Message1,Sizeof(Message1),0);

  With Message1 do
  Begin
    MSg:=WM_CustGetRec;
    WParam:=Mode+100;
    LParam:=Ord(Edit);
  end;

  With Message1 do
    MessResult:=SendMEssage((Owner as TForm).Handle,Msg,WParam,LParam);

end; {Proc..}



procedure TCMPSerCtrl.FormSetOfSet;

Begin
  PagePoint[0].X:=ClientWidth-(PageControl1.Width);
  PagePoint[0].Y:=ClientHeight-(PageControl1.Height);

  PagePoint[1].X:=PageControl1.Width-(A1SBox.Width);
  PagePoint[1].Y:=PageControl1.Height-(A1SBox.Height);

  PagePoint[2].X:=PageControl1.Width-(A1BtnPanel.Left);
  PagePoint[2].Y:=PageControl1.Height-(A1BtnPanel.Height);

  PagePoint[3].X:=A1BtnPanel.Height-(A1BSBox.Height);
  PagePoint[3].Y:=A1SBox.ClientHeight-(A1DPanel.Height);

  PagePoint[4].X:=PageControl1.Width-(A1ListBtnPanel.Left);
  PagePoint[4].Y:=PageControl1.Height-(A1ListBtnPanel.Height);

  GotCoord:=BOn;

end;


Function TCMPSerCtrl.SetHelpC(PageNo :  Integer;
                             Pages  :  TIntSet;
                             Help0,
                             Help1  :  LongInt) :  LongInt;

Begin
  If (PageNo In Pages) then
  Begin
    If (PageNo=1) then
      Result:=Help1
    else
      Result:=Help0;
  end
  else
    Result:=-1;

end;

procedure TCMPSerCtrl.PrimeButtons;

Var
  HideLocBtn
          :  Boolean;
  PageNo  :  Integer;

Begin
  PageNo:=Current_Page;

  If (InvBtnList=nil) then
  Begin
    InvBtnList:=TVisiBtns.Create;

    try

      With InvBtnList do
        Begin
          AddVisiRec(AddN1Btn,BOff);
          AddVisiRec(EditN1Btn,BOff);
        end; {With..}

    except

      InvBtnList.Free;
      InvBtnList:=nil;
    end; {Try..}

  end; {If needs creating }

  {$IFDEF SOP}
    HideLocBtn:=(Not Syss.UseMLoc);

  {$ELSE}

    HideLocBtn:=BOn;

  {$ENDIF}

  try

    With InvBtnList do
    Begin

      SetHideBtn(0,HideLocBtn or (OPt=17),BOn);  {Disable loc edit on remove cycle}

      {SetBtnHelp(0,SetHelpC(PageNo,[0..1],260,88));
      SetBtnHelp(1,SetHelpC(PageNo,[0..1],261,87));


      SetHideBtn(2,Not IdButton(0).Visible,BOff);
      SetBtnHelp(2,SetHelpC(PageNo,[0..1],263,89));


      SetHideBtn(3,(PageNo=0),BOff);
      SetHideBtn(4,(PageNo=0),BOff);}
    end;

  except
    InvBtnList.Free;
    InvBtnList:=nil;
  end; {try..}

end;

procedure TCMPSerCtrl.BuildDesign;

begin

  {* Set Version Specific Info *}

  {$IFNDEF SOP}
    EditN1Btn.Caption:='&Bin';
    A1BLab.Caption:='Bin';
  {$ELSE}
    EditN1Btn.Caption:='&Serial/Bin';
    A1BLab.Caption:='SN/Bin';
  {$ENDIF}


end;


procedure TCMPSerCtrl.FormDesign;


begin

  PrimeButtons;

  BuildDesign;

end;



Function TCMPSerCtrl.Current_BarPos(PageNo  :  Byte)  :  Integer;

Begin
  Case PageNo of
      0
         :  Result:=A1SBox.HorzScrollBar.Position;
      else  Result:=0;
    end; {Case..}


end;


procedure TCMPSerCtrl.RefreshList(ShowLines,
                                 IgMsg      :  Boolean);

Var
  KeyStart    :  Str255;

Begin

  KeyStart:=FullIdkey(EXLocal.LInv.FolioNum,StkLineNo);

  With MULCtrlO do
  Begin
    IgnoreMsg:=IgMsg;

    StartList(IdetailF,IdFolioK,KeyStart,'','',8-(4*Ord(Opt=19)),(Not ShowLines));

    IgnoreMsg:=BOff;
  end;

end;


procedure TCMPSerCtrl.FormBuildList(ShowLines  :  Boolean);

Var
  StartPanel  :  TSBSPanel;
  n           :  Byte;



Begin
  MULCtrlO:=TAdjMList.Create(Self);
  StartPanel := nil;

  Try

    With MULCtrlO do
    Begin

      Try

        With VisiList do
        Begin
          AddVisiRec(A1CPanel,A1CLab);
          AddVisiRec(A1DPanel,A1DLab);
          AddVisiRec(A1IPanel,A1ILab);
          AddVisiRec(A1OPanel,A1OLab);
          AddVisiRec(A1BPanel,A1BLab);
          AddVisiRec(A1LocPanel,A1LocLab);
          AddVisiRec(A1UPanel,A1ULab);

          VisiRec:=List[0];

          StartPanel:=(VisiRec^.PanelObj as TSBSPanel);

          LabHedPanel:=A1HedPanel;

          SetHedPanel(ListOfSet);

        end;
      except
        VisiList.Free;

      end;


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

      For n:=0 to MUTotCols do
      With ColAppear^[n] do
      Begin
        AltDefault:=BOn;

        If (n In [2,3,6]) then
        Begin
          DispFormat:=SGFloat;

          Case n of
            2,3  :  NoDecPlaces:=Syss.NoQtyDec;
              6  :  NoDecPlaces:=Syss.NoCosDec;
          end; {Case..}
        end;
      end;


      ListLocal:=@ExLocal;

      ListCreate;

      NoUpCaseCheck:=BOn;

      
      HighLiteStyle[1]:=[fsBold];

      Set_Buttons(A1ListBtnPanel);

      ReFreshList(ShowLines,BOff);

    end {With}


  Except

    MULCtrlO.Free;
    MULCtrlO:=Nil;
  end;


  FormSetOfSet;

  FormReSize(Self);

end;





Procedure TCMPSerCtrl.ChangePage(NewPage  :  Integer);


Begin

  If (Current_Page<>NewPage) then
  With PageControl1 do
  Begin
    ActivePage:=Pages[NewPage];

    PageControl1Change(PageControl1);
  end; {With..}
end; {Proc..}


procedure TCMPSerCtrl.PageControl1Changing(Sender: TObject;
  var AllowChange: Boolean);
begin
  AllowChange:=Not StopPageChange;

  If (AllowChange) then
  Begin
    Release_PageHandle(Sender);
  end;
end;


procedure TCMPSerCtrl.PageControl1Change(Sender: TObject);
Var
  NewIndex  :  Integer;


begin
  If (Sender is TPageControl) then
    With Sender as TPageControl do
    Begin
      NewIndex:=pcLivePage(Sender);

      PrimeButtons;

      Case NewIndex of

        1  :  ;

      end; {Case..}


      MDI_UpdateParentStat;

    end; {With..}
end;




procedure TCMPSerCtrl.FormCreate(Sender: TObject);

Var
  n  :  Integer;

begin
  ExLocal.Create;

  LastCoord:=BOff;
  ReCalcTot:=BOn;
  NeedCUpdate:=BOff;
  fDoingClose:=BOff;

  Visible:=BOff;

  InvStored:=BOff;

  JustCreated:=BOn;

  StopPageChange:=BOff;

  InGetSer:=BOff;

  SKeypath:=0;

  StkActive:=BOn;

  WarnOnce:=BOff;
  
  MinHeight:=348;
  MinWidth:=578;

  InitSize.Y:=355;
  InitSize.X:=580;

  Self.ClientHeight:=InitSize.Y;
  Self.ClientWidth:=InitSize.X;

  {$IFDEF SOP}
    STARec:=nil;
  {$ENDIF}
  
  PageControl1.ActivePage:=AdjustPage;


  With TForm(Owner) do
  Begin
    Self.Left:=0;
    Self.Top:=0;
  end;

  
  For n:=0 to Pred(ComponentCount) do
    If (Components[n] is TScrollBox) then
    With TScrollBox(Components[n]) do
    Begin
      VertScrollBar.Position:=0;
      HorzScrollBar.Position:=0;
    end;


  FormDesign;

  FormBuildList(BOff);

end;



procedure TCMPSerCtrl.FormDestroy(Sender: TObject);

Var
  n  :  Byte;
begin
  ExLocal.Destroy;

  If (InvBtnList<>nil) then
    InvBtnList.Free;

  {If (MULCtrlO<>nil) then
    MULCtrlO.Free;}

end;

procedure TCMPSerCtrl.FormCloseQuery(Sender: TObject;
                                 var CanClose: Boolean);
Var
  n  : Integer;

begin

  CanClose:=Check_LinesOk(ExLocal.LInv);

  If (CanClose) then
  Begin
    GenCanClose(Self,Sender,CanClose,BOn);


    If (CanClose) then
      CanClose:=GenCheck_InPrint;

    If (CanClose) and (StkActive) then
    Begin

      For n:=0 to Pred(ComponentCount) do
      If (Components[n] is TScrollBox) then
      With TScrollBox(Components[n]) do
      Begin
        VertScrollBar.Position:=0;
        HorzScrollBar.Position:=0;
      end;

      If (NeedCUpdate) then
        Store_FormCoord(Not SetDefault);



      StkActive:=BOff;


    end;
  end;
  {CanClose:=BOff;}

end;

procedure TCMPSerCtrl.FormClose(Sender: TObject; var Action: TCloseAction);
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




procedure TCMPSerCtrl.FormResize(Sender: TObject);
Var
  n           :  Byte;
  NewVal      :  Integer;


begin

  If (GotCoord) and (Not fDoingClose) then
  Begin
    If (MULCtrlO<>nil) then
      MULCtrlO.LinkOtherDisp:=BOff;

    NewVal:=ClientWidth-PagePoint[0].X;
    If (NewVal<MinWidth) then
      NewVal:=MinWidth;

    PageControl1.Width:=NewVal;

    NewVal:=ClientHeight-PagePoint[0].Y;

    If (NewVal<MinHeight) then
      NewVal:=MinHeight;

    PageControl1.Height:=NewVal;


    A1SBox.Width:=PageControl1.Width-PagePoint[1].X;
    A1SBox.Height:=PageControl1.Height-PagePoint[1].Y;

    A1BtnPanel.Left:=PageControl1.Width-PagePoint[2].X;
    A1BtnPanel.Height:=PageControl1.Height-PagePoint[2].Y;

    A1BSBox.Height:=A1BtnPanel.Height-PagePoint[3].X;

    A1ListBtnPanel.Left:=PageControl1.Width-PagePoint[4].X;
    A1ListBtnPanel.Height:=PageControl1.Height-PagePoint[4].Y;


    If (MULCtrlO<>nil) then
    Begin
      LockWindowUpDate(Handle);

      With MULCtrlO,VisiList do
      Begin
        VisiRec:=List[0];

        With (VisiRec^.PanelObj as TSBSPanel) do
          Height:=A1SBox.ClientHeight-PagePoint[3].Y;

        RefreshAllCols;
      end;

      MULCtrlO.ReFresh_Buttons;

      LockWindowUpDate(0);
    end;{Loop..}

    MULCtrlO.LinkOtherDisp:=BOn;


    NeedCUpdate:=((StartSize.X<>Width) or (StartSize.Y<>Height));
  end; {If time to update}
end;


procedure TCMPSerCtrl.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  GlobFormKeyDown(Sender,Key,Shift,ActiveControl,Handle);

end;

procedure TCMPSerCtrl.FormKeyPress(Sender: TObject; var Key: Char);
begin
  GlobFormKeyPress(Sender,Key,ActiveControl,Handle);
end;





procedure TCMPSerCtrl.ClsN1BtnClick(Sender: TObject);
begin
  Close;
end;




procedure TCMPSerCtrl.EditAccount(InvR  :  InvRec;
                                  OMode :  Byte);

Const
  DedTit  :  Array[BOff..BOn] of Str20 = ('Remove','Add');

begin
  With ExLocal,LInv do
  Begin
    LInv:=InvR;
    Opt:=OMode;

    PrimeButtons;
    
    Caption:=DocNames[InvDocHed]+'. '+LInv.OurRef+', '+DedTit[Opt<>17]+' Bill of Material Deductions.';

    If (Assigned(MULCtrlO)) then
      MULCtrlO.DisplayMode:=Self.Opt;

    RefreshList(BOn,BOn);
  end;
end;




procedure TCMPSerCtrl.A1CPanelMouseUp(Sender: TObject; Button: TMouseButton;
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

    BarPos:=Current_BarPos(Current_Page);

    If (PanRsized) then
      MULCtrlO.ResizeAllCols(MULCtrlO.VisiList.FindxHandle(Sender),BarPos);

    MULCtrlO.FinishColMove(BarPos+(ListOfset*Ord(PanRSized)),PanRsized);

    NeedCUpdate:=(MULCtrlO.VisiList.MovingLab or PanRSized);
  end;
end; {Proc..}



procedure TCMPSerCtrl.A1CLabMouseDown(Sender: TObject; Button: TMouseButton;
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



procedure TCMPSerCtrl.A1CLabMouseMove(Sender: TObject; Shift: TShiftState;
  X, Y: Integer);
begin
  If (Sender is TSBSPanel) then
  With (Sender as TSBSPanel) do
  Begin

    If (MULCtrlO<>nil) then
      MULCtrlO.VisiList.MoveLabel(X,Y);

    NeedCUpdate:=MULCtrlO.VisiList.MovingLab;
  end;

end;



procedure TCMPSerCtrl.ShowRightMeny(X,Y,Mode  :  Integer);

Begin
  With PopUpMenu1 do
  Begin

    N3.Tag:=99;

    PopUp(X,Y);
  end;


end;

procedure TCMPSerCtrl.PopupMenu1Popup(Sender: TObject);
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

end;




procedure TCMPSerCtrl.SetFormProperties(SetList  :  Boolean);

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

    If (SetList) then
    Begin
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
                  1,2  :  MULCtrlO.ReColorCol(Font,Color,(n=2));

                  3    :  MULCtrlO.ReColorBar(Font,Color);
                end; {Case..}

            MULCtrlO.VisiList.LabHedPanel.Color:=TmpPanel[2].Color;
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


procedure TCMPSerCtrl.PropFlgClick(Sender: TObject);
begin
  SetFormProperties((N3.Tag=99));
  N3.Tag:=0;
end;



procedure TCMPSerCtrl.StoreCoordFlgClick(Sender: TObject);
begin
  StoreCoord:=Not StoreCoord;

  NeedCUpdate:=BOn;
end;


  procedure TCMPSerCtrl.Display_STARec;

  Var
    WasNew  :  Boolean;

  Begin
    WasNew:=BOff;

    {$IFDEF SOP}

      If (STARec=nil) then
      Begin

        STARec:=TCompAdj.Create(Self);
        WasNew:=BOn;

      end;

      Try


       With STARec do
       Begin

         WindowState:=wsNormal;

         If (Not ExLocal.InAddEdit) then
         With ExLocal do
         Begin
           LInv:=Self.ExLocal.LInv;
           LId:=Self.ExLocal.LId;

           EditLine(BOn,BOff,MULCtrlO.Keypath);
         end
         else
           Show;


       end; {With..}


      except

       STARec.Free;
       STARec:=nil;

      end;
    {$ENDIF}  

  end;




procedure TCMPSerCtrl.AddN1BtnClick(Sender: TObject);
begin
  If (Assigned(MULCtrlO)) and (Not InGetSer) then
    With MULCtrlO do
      If (ValidLine) then
    Begin
      ExLocal.AssignFromGlobal(IdetailF);

      Display_StaRec;

    end;
end;

procedure TCMPSerCtrl.EditN1BtnClick(Sender: TObject);

Const
  Fnum     =  IDetailF;
  Keypath  =  IdFolioK;

Var
  LOk,
  LLocked  :   Boolean;

  KeyS     :   Str255;

  TmpId    :   IDetail;

begin
  If (Assigned(MULCtrlO)) and (Not InGetSer) then
    With MULCtrlO, EXLocal do
      If MULCtrlO.ValidLine then
      Begin
        try
          InGetSer:=BOn;

          AddN1Btn.Enabled:=BOff;
          EditN1Btn.Enabled:=BOff;

          LGetRecAddr(Fnum);

          LOk:=LGetMultiRec(B_GetDirect,B_MultLock,KeyS,KeyPAth,Fnum,BOff,LLocked);


          If (LOk) and (LLocked) then
          Begin

            LId:=Id;

            If (Stock.StockCode<>LId.StockCode) then
              Global_GetMainRec(StockF,LId.StockCode);

            LStock:=Stock;

            Control_SNos(LId,LInv,LStock,1+(2*Ord(Opt=17)),Self);

            If (LastRecAddr[Fnum]<>0) then  {* Re-establish position prior to storing *}
            Begin

              TmpId:=LId;

              LSetDataRecOfs(Fnum,LastRecAddr[Fnum]);

              Status:=GetDirect(F[Fnum],Fnum,LRecPtr[Fnum]^,KeyPAth,0); {* Re-Establish Position *}

              LId:=TmpId;

            end;

            Status:=Put_Rec(F[Fnum],Fnum,LRecPtr[Fnum]^,KeyPAth);

            Report_BError(Fnum,Status);
            UnLockMLock(Fnum,LastRecAddr[Fnum]);

          end;

        finally
          Self.Show;
          InGetSer:=BOff;
          AddN1Btn.Enabled:=BOn;
          EditN1Btn.Enabled:=BOn;

        end; {try..}
      end;
end;


{ ====================== Function to Check ALL valid invlines (InvLTotal<>0) have a nominal =============== }

Function TCMPSerCtrl.Check_LinesOk(InvR      :  InvRec)  :  Boolean;

Const
  Fnum     =  IDetailF;
  Keypath  =  IDFolioK;



Var

  KeyS,
  KeyChk,
  BMsg,
  MsgStr    :  Str255;
  WarnBin,
  WarnSer,
  NomOk     :  Boolean;

  ExStatus  :  Integer;

  {$IFDEF CUxxx}

    LineCU  :  TCustomEvent;

  {$ELSE}
    LineCU  :  Pointer;

  {$ENDIF}

Begin
  NomOk:=BOn;

  ExStatus:=0; WarnBin:=BOff; WarnSer:=BOff;

  If ((Not ChkAllowed_In(244)) or (Not ChkAllowed_In(430))) or (Not WarnOnce) then
  With ExLocal do
  Begin

    KeyChk:=FullIdKey(InvR.FolioNum,StkLineNo);

    KeyS:=KeyChk;

    ExStatus:=Find_Rec(B_GetGEq,F[Fnum],Fnum,LRecPtr[Fnum]^,KeyPath,KeyS);

    LineCU:=Nil;

    Try

      While (ExStatus=0) and (CheckKey(KeyChk,KeyS,Length(KeyChk),BOn)) and (NomOk) and (LId.LineNo<>RecieptCode) do
      With LId do
      Begin
        {$IFDEF CUxxx}
          If (Not Assigned(LineCU)) then
          Begin
            LineCU:=TCustomEvent.Create(EnterpriseBase+4000, 18);

            If (LineCU.GotEvent) then
              LineCU.BuildEvent(ExLocal);

          end;

        {$ENDIF}

        If (Is_FullStkCode(StockCode)) then
        Begin
          {$B-}
          If (LStock.StockCode=StockCode) or LGetMainRecPos(StockF,StockCode) then
          {$B+}

          Begin
            If (Not (IdDocHed In OrderSet)) then
            Begin
              WarnBin:=(LStock.MultiBinMode) and (((BinQty<>(Qty*QtyMul)) and (Opt=18)) or ((BinQty<>0.0) and (Opt=17)));

              WarnSer:=(Is_SERNo(LStock.StkValType)) and (((SerialQty<>(Qty*QtyMul)) and (Opt=18)) or ((SerialQty<>0.0) and (Opt=17)));
            end;

            If (WarnBin) then
            Begin
              NomOk:=(ChkAllowed_In(430) and WarnOnce) or ((BinQty=0.0) and (Opt=17));
              BMsg:='Bins';
            end
            else
            If (WarnSer) then
            Begin
              NomOk:=(ChkAllowed_In(244) and WarnOnce) or ((SerialQty=0.0) and (Opt=17));

              BMsg:='Serial No''s';
            end;

            If (WarnSer or WarnBin) then
            With LStock do
            Begin
              MsgStr:='Warning!. The adjustment line for '+dbFormatName(StockCode,Desc[1])+' has not had enough '+
              BMsg+' allocated to it.';

              ShowMessage(MsgStr);

              WarnOnce:=BOn;
            end;
          end;

        end;

        ExStatus:=Find_Rec(B_GetNext,F[Fnum],Fnum,LRecPtr[Fnum]^,KeyPath,KeyS);

      end; {While..}

    Finally

      {$IFDEF CUxxxx}
        If (Assigned(LineCU)) then
          LineCU.Free;
      {$ENDIF}

    end; {Try..}
  end;

  Result:=NomOk;
end; {Func..}


{ ============ Procedure to Control Serial Nos =========== }


Procedure Set_HiddenSer(fInv  :  InvRec;
                        OMode :  Byte);

Var
  PrevHState
       :  Boolean;

  StkRec
       :  TCMPSerCtrl;

  { == Function to check if we have any bin or serial lines present == }

  Function Has_SerBinLines  :  Boolean;

  Const
    Fnum     = IDetailF;
    Keypath  = IdFolioK;

  Var
    KeyS,
    KeyChk  :  Str255;

    FoundOk :  Boolean;


  Begin
    Result:=Boff;

    If (OMode=19) then
    With fInv do
    Begin
      KeyChk:=FullNomKey(FolioNum);
      KeyS:=FullIdKey(FolioNum,StkLineNo);

      FoundOk:=BOff;

      Status:=Find_Rec(B_GetGEq,F[Fnum],Fnum,RecPtr[Fnum]^,Keypath,KeyS);


      While (StatusOk) and (CheckKey(KeyChk,KeyS,Length(KeyChk),BOff)) and (Not FoundOk) do
      With Id do
      Begin
        If (Stock.StockCode<>StockCode) then
          Global_GetMainRec(StockF,StockCode);

        FoundOk:=((Is_SERNo(SetStkVal(Stock.StkValType,Stock.SerNoWAvg,BOn))) or (Stock.MultiBinMode));

        Application.ProcessMessages;

        If (Not FoundOk) then
          Status:=Find_Rec(B_GetNext,F[Fnum],Fnum,RecPtr[Fnum]^,Keypath,KeyS);

      end;

      Result:=FoundOk;
    end;
  end;


Begin
  PrevHState:=BOff;

  With fInv do
    {$B-}
      If (Not (InvDocHed In QuotesSet)) and ((CheckExsists(FullIdKey(FolioNum,StkLineNo),IdetailF,IdFolioK)) or (Has_SerBinLines)) then
    {$B+}
    Begin
      StkRec:=TCMPSerCtrl.Create(Application.MainForm);

      try

        With StkRec do
        Begin

          EditAccount(fInv,OMode);

          SetAllowHotKey(BOff,PrevHState);
          Set_BackThreadMVisible(BOn);


          ShowModal;

          SetAllowHotKey(BOn,PrevHState);
          Set_BackThreadMVisible(BOff);

          {Repeat

            Application.ProcessMessages;

          Until (Not StkActive);}

        end; {With..}

      finally

        StkRec.Free;

      end; {try..}

    end; {If no lines..}
end; {Proc..}


 


Initialization

end.
