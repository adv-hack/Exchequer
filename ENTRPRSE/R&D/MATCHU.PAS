unit MatchU;

{$I DEFOVR.Inc}

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ExtCtrls, SBSPanel, ComCtrls,
  GlobVar,VarConst,SBSComp,SBSComp2,BTSupU1,ExWrap1U,SupListU, Menus;

type


  TMAMList  =  Class(TGenList)

  Public
    LNHCtrl :  TNHCtrlRec;

    Function SetCheckKey  :  Str255; Override;

    Function SetFilter  :  Str255; Override;

    Function Ok2Del :  Boolean; Override;

    Function Link2Inv  :  Boolean;

    Function OutLine(Col  :  Byte)  :  Str255; Override;

  end;


type
  TMatchWin = class(TForm)
    MPanel: TSBSPanel;
    MSBox: TScrollBox;
    MHedPanel: TSBSPanel;
    MORefLab: TSBSPanel;
    MYRefLab: TSBSPanel;
    MDateLab: TSBSPanel;
    MAmtLab: TSBSPanel;
    MORefPanel: TSBSPanel;
    MYRefPanel: TSBSPanel;
    MDatePanel: TSBSPanel;
    MAmtPanel: TSBSPanel;
    MListBtnPanel: TSBSPanel;
    MClsBtn: TButton;
    MOKBtn: TButton;
    PopupMenu1: TPopupMenu;
    PropFlg: TMenuItem;
    N1: TMenuItem;
    StoreCoordFlg: TMenuItem;
    procedure MORefPanelMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure MORefLabMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure MORefLabMouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure PopupMenu1Popup(Sender: TObject);
    procedure PropFlgClick(Sender: TObject);
    procedure StoreCoordFlgClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FormResize(Sender: TObject);
    procedure MClsBtnClick(Sender: TObject);
    procedure MOKBtnClick(Sender: TObject);
  private
    { Private declarations }

    BeenIn,
    JustCreated,
    StoreCoord,
    LastCoord,
    SetDefault,
    fNeedCUpdate,
    fDoingClose,
    GotCoord,
    CanDelete    :  Boolean;


    OldMACtrl    :  TNHCtrlRec;

    PagePoint    :  Array[0..4] of TPoint;

    StartSize,
    InitSize     :  TPoint;


    procedure Find_FormCoord;

    procedure Store_FormCoord(UpMode  :  Boolean);

    procedure FormSetOfSet;

    Procedure WMCustGetRec(Var Message  :  TMessage); Message WM_CustGetRec;

    Procedure WMGetMinMaxInfo(Var Message  :  TWMGetMinMaxInfo); Message WM_GetMinMaxInfo;

    

    Procedure Send_UpdateList(Mode   :  Integer);

    procedure ShowRightMeny(X,Y,Mode  :  Integer);

    Procedure  SetNeedCUpdate(B  :  Boolean);

    Property NeedCUpDate :  Boolean Read fNeedCUpDate Write SetNeedCUpdate;

    procedure SetHelpContextIDs; // NF: 16/05/06

  public
    { Public declarations }

    ExLocal      :  TdExLocal;

    ListOfSet    :  Integer;

    MACtrl       :  TNHCtrlRec;

    MULCtrlO     :  TMAMList;


    procedure FormDesign;

    procedure RefreshList(ShowLines,
                          IgMsg      :  Boolean);

    procedure FormBuildList(ShowLines  :  Boolean);

    procedure SetCaption;

    procedure ShowLink(ShowLines  :  Boolean);


    procedure SetFormProperties;

  end;


  Procedure Set_MAFormMode(State  :  TNHCtrlRec);


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
  {IntMU,
  MiscU,
  PayF2U,
  Warn1U,}
  SalTxl1U;

{$R *.DFM}



Var
  MAFormMode  :  TNHCtrlRec;



{ ========= Exported function to set View type b4 form is created ========= }

Procedure Set_MAFormMode(State  :  TNHCtrlRec);

Begin

  MAFormMode:=State;

end;


{$I MTchTI1U.PAS}


Procedure  TMatchWin.SetNeedCUpdate(B  :  Boolean);

Begin
  If (Not fNeedCUpdate) then
    fNeedCUpdate:=B;
end;


procedure TMatchWin.Find_FormCoord;


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

    PrimeKey:='M';

    If (GetbtControlCsm(ThisForm)) then
    Begin
      {StoreCoord:=(ColOrd=1); v4.40. To avoid on going corruption, this is reset each time its loaded}
      StoreCoord:=BOff;
      HasCoord:=(HLite=1);
      LastCoord:=HasCoord;

      If (HasCoord) then {* Go get postion, as would not have been set initianly *}
        SetPosition(ThisForm);

    end;

    GetbtControlCsm(MPanel);

    GetbtControlCsm(MSBox);

    GetbtControlCsm(MListBtnPanel);

    GetbtControlCsm(MClsBtn);

    MULCtrlO.Find_ListCoord(GlobComp);

  end; {With GlobComp..}


  Dispose(GlobComp,Destroy);

  {NeedCUpdate}
  StartSize.X:=Width; StartSize.Y:=Height;


end;


procedure TMatchWin.Store_FormCoord(UpMode  :  Boolean);


Var
  GlobComp:  TGlobCompRec;


Begin

  New(GlobComp,Create(BOff));

  With GlobComp^ do
  Begin
    GetValues:=UpMode;

    PrimeKey:='M';

    ColOrd:=Ord(StoreCoord);

    HLite:=Ord(LastCoord);

    SaveCoord:=StoreCoord;

    If (Not LastCoord) then {* Attempt to store last coord *}
      HLite:=ColOrd;

    StorebtControlCsm(Self);

    StorebtControlCsm(MPanel);

    StorebtControlCsm(MSBox);

    StorebtControlCsm(MListBtnPanel);

    StorebtControlCsm(MClsBtn);

    MULCtrlO.Store_ListCoord(GlobComp);

  end; {With GlobComp..}

  Dispose(GlobComp,Destroy);
end;



procedure TMatchWin.FormSetOfSet;

Begin
  PagePoint[0].X:=ClientWidth-(MPanel.Width);
  PagePoint[0].Y:=ClientHeight-(MPanel.Height);

  PagePoint[1].X:=MPanel.Width-(MSBox.Width);
  PagePoint[1].Y:=MPanel.Height-(MSBox.Height);

  PagePoint[2].Y:=ClientHeight-(MClsBtn.Top);

  PagePoint[3].Y:=MSBox.ClientHeight-(MORefPanel.Height);

  PagePoint[4].X:=MPanel.Width-(MListBtnPanel.Left);
  PagePoint[4].Y:=MPanel.Height-(MListBtnPanel.Height);

  GotCoord:=BOn;

end;



Procedure TMatchWin.WMCustGetRec(Var Message  :  TMessage);



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

              MOKBtnClick(nil);
            end;

      {1  :  Begin
              If (BeenIn) and (MULCtrlO.Link2Inv) then
              Begin
                Send_UpdateList(65);
              end;


            end;}


      2  :  ShowRightMeny(LParamLo,LParamHi,1);


      25 :  NeedCUpdate:=BOn;

    end; {Case..}

  end;
  Inherited;
end;


Procedure TMatchWin.WMGetMinMaxInfo(Var Message  :  TWMGetMinMaxInfo);

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

Procedure TMatchWin.Send_UpdateList(Mode   :  Integer);

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




procedure TMatchWin.SetCaption;

Var
  LevelStr  :  Str255;

Begin
  LevelStr:='Bug!';

  With ExLocal,MACtrl do
  Begin

    Case NHMode of
      3,4
         :  With LInv do
            Begin
              LevelStr:='Matching Information for '+LInv.OurRef;
            end;


    end; {Case..}

    Caption:=LevelStr;

  end;

end;


procedure TMatchWin.ShowLink(ShowLines :  Boolean);
begin
  ExLocal.AssignFromGlobal(InvF);

  MACtrl:=MAFormMode;

  SetCaption;


  ReFreshList(ShowLines,Not JustCreated);


  JustCreated:=BOff;

end;




procedure TMatchWin.FormDesign;


begin


end;





procedure TMatchWin.RefreshList(ShowLines,
                               IgMsg      :  Boolean);

Var
  KeyStart    :  Str255;
  LKeypath,
  LKeyLen     :  Integer;

Begin

  KeyStart:=MACtrl.MainK;
  LKeyLen:=MACtrl.NHKeyLen;

  With MULCtrlO do
  Begin
    LNHCtrl:=MACtrl;

    DisplayMode:=MACtrl.NHMode;

    IgnoreMsg:=IgMsg;

    Case DisplayMode of
      3  :  LKeypath:=PWK;
      4  :  LKeypath:=HelpNDXK;
    end; {Case..}


    StartList(PWrdF,LKeypath,KeyStart,'','',LKeyLen,(Not ShowLines));

    IgnoreMsg:=BOff;
  end;

end;


procedure TMatchWin.FormBuildList(ShowLines  :  Boolean);

Var
  StartPanel  :  TSBSPanel;
  n           :  Byte;



Begin
  MULCtrlO:=TMAMList.Create(Self);


  Try

    With MULCtrlO do
    Begin


      Try

        With VisiList do
        Begin
          AddVisiRec(MORefPanel,MORefLab);
          AddVisiRec(MYRefPanel,MYRefLab);
          AddVisiRec(MDatePanel,MDateLab);
          AddVisiRec(MAMTPanel,MAMTLab);

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


      

      Find_FormCoord;

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
      With ColAppear^[n] do
      Begin
        AltDefault:=BOn;

        If (n In [3]) then
        Begin
          DispFormat:=SGFloat;
          NoDecPlaces:=2
        end;
      end;


      ListLocal:=@ExLocal;

      ListCreate;

      UseSet4End:=BOn;

      NoUpCaseCheck:=BOn;

      Set_Buttons(MListBtnPanel);


      ReFreshList(ShowLines,BOff);

    end {With}


  Except

    MULCtrlO.Free;
    MULCtrlO:=Nil;
  end;



  FormSetOfSet;

  FormReSize(Self);

end;


procedure TMatchWin.FormCreate(Sender: TObject);

Var
  n  :  Integer;

begin
  fDoingClose:=BOff;
  
  ExLocal.Create;

  LastCoord:=BOff;

  JustCreated:=BOn;

  NeedCUpdate:=BOff;

  InitSize.Y:=185;
  InitSize.X:=386;

  Self.ClientHeight:=InitSize.Y;
  Self.ClientWidth:=InitSize.X;

  {Height:=212;
  Width:=394;}


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

  FormBuildList(BOff);

  SetHelpContextIDs; // NF: 16/05/06 Fix for incorrect Context IDs
end;



procedure TMatchWin.FormDestroy(Sender: TObject);

Var
  n  :  Byte;
begin
  ExLocal.Destroy;


end;

procedure TMatchWin.FormCloseQuery(Sender: TObject;
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

  Send_UpdateList(44);


end;

procedure TMatchWin.FormClose(Sender: TObject; var Action: TCloseAction);
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


procedure TMatchWin.FormResize(Sender: TObject);
Var
  n           :  Byte;
  NewVal      :  Integer;


begin

  If (GotCoord) and (Not fDoingClose) then
  Begin

    MULCtrlO.LinkOtherDisp:=BOff;

    Self.HorzScrollBar.Position:=0;
    Self.VertScrollBar.Position:=0;
    
    MPanel.Width:=ClientWidth-PagePoint[0].X;

    MPanel.Height:=ClientHeight-PagePoint[0].Y;


    MSBox.Width:=MPanel.Width-PagePoint[1].X;
    MSBox.Height:=MPanel.Height-PagePoint[1].Y;

    MListBtnPanel.Left:=MPanel.Width-PagePoint[4].X;
    MListBtnPanel.Height:=MPanel.Height-PagePoint[4].Y;

    MClsBtn.Top:=ClientHeight-PagePoint[2].Y;
    MOkBtn.Top:=MClsBtn.Top;


    If (MULCtrlO<>nil) then
    Begin
      LockWindowUpDate(Handle);

      With MULCtrlO,VisiList do
      Begin
        VisiRec:=List[0];

        With (VisiRec^.PanelObj as TSBSPanel) do
          Height:=MSBox.ClientHeight-PagePoint[3].Y;

        RefreshAllCols;
      end;

      LockWindowUpDate(0);

      MULCtrlO.ReFresh_Buttons;

    end;{Loop..}

    MULCtrlO.LinkOtherDisp:=BOn;

    NeedCUpdate:=((StartSize.X<>Width) or (StartSize.Y<>Height));
  end; {If time to update}
end;



procedure TMatchWin.MORefPanelMouseUp(Sender: TObject;
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

    BarPos:=MSBox.HorzScrollBar.Position;

    If (PanRsized) then
      MULCtrlO.ResizeAllCols(MULCtrlO.VisiList.FindxHandle(Sender),BarPos);

    MULCtrlO.FinishColMove(BarPos+(ListOfset*Ord(PanRSized)),PanRsized);
    NeedCUpdate:=(MULCtrlO.VisiList.MovingLab or PanRSized);
  end;

end;


procedure TMatchWin.MORefLabMouseDown(Sender: TObject;
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


procedure TMatchWin.MORefLabMouseMove(Sender: TObject; Shift: TShiftState;
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



procedure TMatchWin.SetFormProperties;


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
        SetProperties(TmpPanel[1],TmpPanel[2],TmpPanel[3],1,'Match Properties',BeenChange,ResetDefaults);

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

procedure TMatchWin.ShowRightMeny(X,Y,Mode  :  Integer);

Begin
  With PopUpMenu1 do
  Begin

    PopUp(X,Y);
  end;


end;


procedure TMatchWin.PopupMenu1Popup(Sender: TObject);

Var
  n  :  Integer;

begin
  StoreCoordFlg.Checked:=StoreCoord;

end;



procedure TMatchWin.PropFlgClick(Sender: TObject);
begin
  SetFormProperties;
end;

procedure TMatchWin.StoreCoordFlgClick(Sender: TObject);
begin
  StoreCoord:=Not StoreCoord;
  NeedCUpdate:=BOn;
end;




procedure TMatchWin.MClsBtnClick(Sender: TObject);
begin
  Close;
end;

procedure TMatchWin.MOKBtnClick(Sender: TObject);
begin
  If (Sender<>nil) then
  With MULCtrlO do
  Begin
    If (ValidLine) then
      RefreshLine(MUListBoxes[0].Row,BOff)
    else
      Exit;

  end;

  If (MULCtrlO.Link2Inv) then
    Send_UpdateList(64);

end;

// NF: 16/05/06 Fix for incorrect Context IDs
procedure TMatchWin.SetHelpContextIDs;
begin
  HelpContext := 1822;
  MOKBtn.HelpContext := 1823;
  MClsBtn.HelpContext := 1824;
end;


Initialization

end.
