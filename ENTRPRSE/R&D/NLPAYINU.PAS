unit NlPayInU;

{$I DEFOVR.Inc}

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ExtCtrls, SBSPanel, ComCtrls,
  GlobVar,VarConst,SBSComp,SBSComp2,BTSupU1,ExWrap1U,SupListU, Menus,
  Scrtch1U;

type


  TPIMList  =  Class(TGenList)

  Public
    ThisScrt:  ScratchPtr;

    LNHCtrl :  TNHCtrlRec;

    Procedure ExtObjDestroy; Override;

    Function SetCheckKey  :  Str255; Override;

    Function SetFilter  :  Str255; Override;

    Function Ok2Del :  Boolean; Override;

    {$IFDEF STK}

      Procedure Match_ORLine(IdR    :  IDetail;
                             ICode  :  Str10);

      Procedure Match_OSLine(IdR    :  IDetail;
                             ICode,
                             CCode  :  Str10);

      Function OutSORMatch(Col  :  Byte)  :  Str255;

      Function OutSORBack(Col  :  Byte)  :  Str255;

    {$ENDIF}


    Function Link2Inv  :  Boolean;

    Function OutPayIn(Col  :  Byte)  :  Str255;

    Function OutLine(Col  :  Byte)  :  Str255; Override;

  end;

type
  TPayInWin = class(TForm)
    PPanel: TSBSPanel;
    PSBox: TScrollBox;
    PHedPanel: TSBSPanel;
    PORefLab: TSBSPanel;
    PACLab: TSBSPanel;
    PDescLab: TSBSPanel;
    PORefPanel: TSBSPanel;
    PACPanel: TSBSPanel;
    PDescPanel: TSBSPanel;
    PStatPanel: TSBSPanel;
    PStatLab: TSBSPanel;
    PListBtnPanel: TSBSPanel;
    PClsBtn: TButton;
    POKBtn: TButton;
    PAmtPanel: TSBSPanel;
    PAmtLab: TSBSPanel;
    PopupMenu1: TPopupMenu;
    PropFlg: TMenuItem;
    N1: TMenuItem;
    StoreCoordFlg: TMenuItem;
    procedure PORefPanelMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure PORefLabMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure PORefLabMouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure PopupMenu1Popup(Sender: TObject);
    procedure PropFlgClick(Sender: TObject);
    procedure StoreCoordFlgClick(Sender: TObject);
    procedure PClsBtnClick(Sender: TObject);
    procedure POKBtnClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FormResize(Sender: TObject);
  private
    { Private declarations }
    BeenIn,
    JustCreated,
    StoreCoord,
    LastCoord,
    SetDefault,
    GotCoord,
    fDoingClose,
    CanDelete    :  Boolean;


    PagePoint    :  Array[0..4] of TPoint;

    InitSize     :  TPoint;


    DispTransPtr :  Pointer;


    procedure Find_FormCoord;

    procedure Store_FormCoord(UpMode  :  Boolean);

    procedure FormSetOfSet;

    Procedure WMCustGetRec(Var Message  :  TMessage); Message WM_CustGetRec;

    Procedure WMGetMinMaxInfo(Var Message  :  TWMGetMinMaxInfo); Message WM_GetMinMaxInfo;

    Procedure WMSysCommand(Var Message  :  TMessage); Message WM_SysCommand;

    Procedure Send_UpdateList(Mode   :  Integer);

    procedure ShowRightMeny(X,Y,Mode  :  Integer);


    procedure Display_Trans(Mode  :  Byte);

    procedure SetHelpContextIDs; // NF: 16/05/06

  public
    { Public declarations }

    ExLocal      :  TdExLocal;

    ListOfSet    :  Integer;

    PICtrl       :  TNHCtrlRec;

    MULCtrlO     :  TPIMList;


    procedure FormDesign;

    procedure HidePanels(PageNo    :  Byte);
    procedure RenamePanels(PageNo    :  Byte);

    procedure RefreshList(ShowLines,
                          IgMsg      :  Boolean);

    procedure FormBuildList(ShowLines  :  Boolean);

    procedure SetCaption;

    procedure ShowLink(ShowLines  :  Boolean);


    procedure SetFormProperties;

  end;


  Procedure Set_PIFormMode(State  :  TNHCtrlRec);


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
  PayF2U,}
  Warn1U,
  SalTxl1U,
  Recon3U,
  Tranl1U;

{$R *.DFM}



Var
  PIFormMode   :  TNHCtrlRec;
  RepScrCount  :  ^LongInt;


Const
  PrimeNDX  :  Array[0..3] of Char = ('P','M','B','M');

{ ========= Exported function to set View type b4 form is created ========= }

Procedure Set_PIFormMode(State  :  TNHCtrlRec);

Begin

  PIFormMode:=State;

end;


{$I PayITI1U.PAS}




procedure TPayInWin.Find_FormCoord;


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

    PrimeKey:=PrimeNDX[PICtrl.NHMode];

    If (GetbtControlCsm(ThisForm)) then
    Begin
      {StoreCoord:=(ColOrd=1); v4.40. To avoid on going corruption, this is reset each time its loaded}
      StoreCoord:=BOff;
      HasCoord:=(HLite=1);
      LastCoord:=HasCoord;

      If (HasCoord) then {* Go get postion, as would not have been set initianly *}
        SetPosition(ThisForm);

    end;

    GetbtControlCsm(PPanel);

    GetbtControlCsm(PSBox);

    GetbtControlCsm(PListBtnPanel);

    If GetbtControlCsm(PClsBtn) then
      POkBtn.Top:=PClsBtn.Top;

    MULCtrlO.Find_ListCoord(GlobComp);

  end; {With GlobComp..}


  Dispose(GlobComp,Destroy);

end;


procedure TPayInWin.Store_FormCoord(UpMode  :  Boolean);


Var
  GlobComp:  TGlobCompRec;


Begin

  New(GlobComp,Create(BOff));

  With GlobComp^ do
  Begin
    GetValues:=UpMode;

    PrimeKey:=PrimeNDX[PICtrl.NHMode];

    ColOrd:=Ord(StoreCoord);

    HLite:=Ord(LastCoord);

    SaveCoord:=StoreCoord;

    If (Not LastCoord) then {* Attempt to store last coord *}
      HLite:=ColOrd;

    StorebtControlCsm(Self);

    StorebtControlCsm(PPanel);

    StorebtControlCsm(PSBox);

    StorebtControlCsm(PListBtnPanel);

    StorebtControlCsm(PClsBtn);

    MULCtrlO.Store_ListCoord(GlobComp);

  end; {With GlobComp..}

  Dispose(GlobComp,Destroy);
end;



procedure TPayInWin.FormSetOfSet;

Begin
  PagePoint[0].X:=ClientWidth-(PPanel.Width);
  PagePoint[0].Y:=ClientHeight-(PPanel.Height);

  PagePoint[1].X:=PPanel.Width-(PSBox.Width);
  PagePoint[1].Y:=PPanel.Height-(PSBox.Height);

  PagePoint[2].Y:=ClientHeight-(PClsBtn.Top);

  PagePoint[3].Y:=PSBox.ClientHeight-(PORefPanel.Height);

  PagePoint[4].X:=PPanel.Width-(PListBtnPanel.Left);
  PagePoint[4].Y:=PPanel.Height-(PListBtnPanel.Height);

  GotCoord:=BOn;

end;



Procedure TPayInWin.WMCustGetRec(Var Message  :  TMessage);



Begin


  With Message do
  Begin

    {If (Debug) then
      DebugForm.Add('Mesage Flg'+IntToStr(WParam));}

    Case WParam of
      0,169
         :  Begin
              POKBtnClick(nil);
            end;

      2  :  ShowRightMeny(LParamLo,LParamHi,1);




    end; {Case..}

  end;
  Inherited;
end;


Procedure TPayInWin.WMGetMinMaxInfo(Var Message  :  TWMGetMinMaxInfo);

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


Procedure TPayInWin.WMSysCommand(Var Message  :  TMessage);


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

{ == Procedure to Send Message to Get Record == }

Procedure TPayInWin.Send_UpdateList(Mode   :  Integer);

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




procedure TPayInWin.SetCaption;

Var
  LevelStr  :  Str255;

Begin
  LevelStr:='Bug!';

  With ExLocal,PICtrl do
  Begin

    Case NHMode of
      0
         :  With LId do
            Begin
              LevelStr:='Group Information for '+Extract_PayRef2(StockCode);
            end;

      1,3
         :  With LInv,LId do
            Begin
              LevelStr:='Match for '+OurRef+','+LId.StockCode;
            end;
      2
         :  With LInv,LId do
            Begin
              LevelStr:='Back Orders for '+CustCode+'.';
            end;


    end; {Case..}

    Caption:=LevelStr;

  end;

end;


procedure TPayInWin.ShowLink(ShowLines :  Boolean);
begin
  ExLocal.AssignFromGlobal(IdetailF);
  ExLocal.AssignFromGlobal(InvF);
  ExLocal.AssignFromGlobal(NomF);


  PICtrl:=PIFormMode;

  SetCaption;


  ReFreshList(ShowLines,Not JustCreated);


  JustCreated:=BOff;

end;




procedure TPayInWin.FormDesign;


begin


end;

procedure TPayInWin.HidePanels(PageNo    :  Byte);


Begin
  With MULCtrlO,VisiList do
  Begin

    Case PageNo of

      1,3
         :  Begin
              SetHidePanel(3,BOn,BOff);
              SetHidePanel(4,BOn,BOn);
            end;
    end; {Case..}

  end;
end;

procedure TPayInWin.RenamePanels(PageNo    :  Byte);


Begin
  With MULCtrlO,VisiList do
  Begin

    Case PageNo of

      1,3
         :  Begin
              IdPanel(1,BOn).Caption:='Date';
              IdPanel(2,BOn).Caption:='    Qty';
            end;

      2
         :  Begin
              IdPanel(1,BOn).Caption:='Del Date';
              IdPanel(2,BOn).Caption:='Stock Code';
              IdPanel(3,BOn).Caption:='Qty OS';
              IdPanel(4,BOn).Caption:='Qty Avail (Global)';
            end;
    end; {Case..}

  end;
end;



procedure TPayInWin.RefreshList(ShowLines,
                               IgMsg      :  Boolean);

Var
  KeyStart    :  Str255;
  LFnum,
  LKeypath,
  LKeyLen     :  Integer;

Begin

  KeyStart:=PICtrl.MainK;
  LKeyLen:=PICtrl.NHKeyLen;

  With MULCtrlO do
  Begin
    LNHCtrl:=PICtrl;

    DisplayMode:=LNHCtrl.NHMode;

    IgnoreMsg:=IgMsg;

    Case DisplayMode of
      0  :  Begin
              LKeypath:=IdStkK;
              LFnum:=IdetailF;
            end;

      {$IFDEF STK}

        1..3
           :  With ExLocal do
              Begin
                LKeypath:=RpK;
                LFnum:=ReportF;

                Case DisplayMode of
                  1,3
                     :  Match_OrLine(LId,LInv.OurRef);
                  2  :  Match_OSline(LId,LInv.OurRef,LInv.CustCode);
                end;

                If (ThisScrt<>nil) then
                  KeyStart:=FullNomKey(ThisScrt^.Process)
                else
                  KeyStart:=NdxWeight;

                LKeyLen:=Length(KeyStart);

              end;
      {$ENDIF}
    end; {Case..}


    StartList(LFnum,LKeypath,KeyStart,'','',LKeyLen,(Not ShowLines));

    IgnoreMsg:=BOff;
  end;

end;


procedure TPayInWin.FormBuildList(ShowLines  :  Boolean);

Var
  StartPanel  :  TSBSPanel;
  n           :  Byte;



Begin
  MULCtrlO:=TPIMList.Create(Self);

  

  Try

    With MULCtrlO do
    Begin

      DisplayMode:=PICtrl.NHMode;

      Try

        With VisiList do
        Begin
          AddVisiRec(PORefPanel,PORefLab);
          AddVisiRec(PACPanel,PACLab);
          AddVisiRec(PDescPanel,PDescLab);
          AddVisiRec(PAMTPanel,PAMTLab);
          AddVisiRec(PStatPanel,PStatLab);

          VisiRec:=List[0];

          StartPanel:=(VisiRec^.PanelObj as TSBSPanel);

          HidePanels(DisplayMode);
          RenamePanels(DisplayMode);

          LabHedPanel:=PHedPanel;

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
      MUTotCols:=4;
      Font:=StartPanel.Font;

      LinkOtherDisp:=BOff;

      WM_ListGetRec:=WM_CustGetRec;


      Parent:=StartPanel.Parent;

      MessHandle:=Self.Handle;

      For n:=0 to MUTotCols do
      With ColAppear^[n] do
      Begin
        AltDefault:=BOn;

        If ((n In [3]) and (DisplayMode=0)) or ((n In [2]) and (DisplayMode In [1,3]))
        or ((n In [3,4]) and (DisplayMode=2)) then
        Begin
          DispFormat:=SGFloat;

          If (DisplayMode=0) then
            NoDecPlaces:=2
          else
            NoDecPlaces:=Syss.NoQtyDec;

        end;
      end;


      ListLocal:=@ExLocal;

      ListCreate;

      UseSet4End:=BOn;

      NoUpCaseCheck:=BOn;

      AbortOnEmpty:=(DisplayMode<>0);
      
      Set_Buttons(PListBtnPanel);


      If (DisplayMode=0) then
        ReFreshList(ShowLines,BOff);

    end {With}


  Except

    MULCtrlO.Free;
    MULCtrlO:=Nil;
  end;



  FormSetOfSet;

  FormReSize(Self);

end;


procedure TPayInWin.FormCreate(Sender: TObject);

Var
  n  :  Integer;

begin
  ExLocal.Create;

  LastCoord:=BOff;

  JustCreated:=BOn;
  fDoingClose:=BOff;

  InitSize.Y:=180;
  InitSize.X:=398;

  Self.ClientHeight:=InitSize.Y;
  Self.ClientWidth:=InitSize.X;

  {Height:=207;
  Width:=406;}


  DispTransPtr:=nil;

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

  PICtrl:=PIFormMode;

  FormDesign;

  FormBuildList(BOff);

  SetHelpContextIDs; // NF: 16/05/06 Fix for incorrect Context IDs
end;



procedure TPayInWin.FormDestroy(Sender: TObject);

Var
  n  :  Byte;
begin
  ExLocal.Destroy;


end;

procedure TPayInWin.FormCloseQuery(Sender: TObject;
                              var CanClose: Boolean);
Var
  n  : Integer;

begin
  GenCanClose(Self,Sender,CanClose,BOn);

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

    Store_FormCoord(Not SetDefault);

    If (MULCtrlO.ThisScrt<>nil) then
    With MULCtrlO do
    Begin
      Dispose(ThisScrt,Done);
      ThisScrt:=nil;
    end;

    Send_UpdateList(45+MULCtrlO.DisplayMode);
  end;

end;

procedure TPayInWin.FormClose(Sender: TObject; var Action: TCloseAction);
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


procedure TPayInWin.FormResize(Sender: TObject);
Var
  n           :  Byte;
  NewVal      :  Integer;


begin

  If (GotCoord) and (Not fDoingClose) then
  Begin

    MULCtrlO.LinkOtherDisp:=BOff;

    Self.HorzScrollBar.Position:=0;
    Self.VertScrollBar.Position:=0;

    PPanel.Width:=ClientWidth-PagePoint[0].X;

    PPanel.Height:=ClientHeight-PagePoint[0].Y;


    PSBox.Width:=PPanel.Width-PagePoint[1].X;
    PSBox.Height:=PPanel.Height-PagePoint[1].Y;

    PListBtnPanel.Left:=PPanel.Width-PagePoint[4].X;
    PListBtnPanel.Height:=PPanel.Height-PagePoint[4].Y;

    PClsBtn.Top:=ClientHeight-PagePoint[2].Y;
    POkBtn.Top:=PClsBtn.Top;


    If (MULCtrlO<>nil) then
    Begin
      LockWindowUpDate(Handle);

      With MULCtrlO,VisiList do
      Begin
        VisiRec:=List[0];

        With (VisiRec^.PanelObj as TSBSPanel) do
          Height:=PSBox.ClientHeight-PagePoint[3].Y;

        RefreshAllCols;
      end;

      LockWindowUpDate(0);

      MULCtrlO.ReFresh_Buttons;

    end;{Loop..}

    MULCtrlO.LinkOtherDisp:=BOn;

  end; {If time to update}
end;



procedure TPayInWin.PORefPanelMouseUp(Sender: TObject;
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

    BarPos:=PSBox.HorzScrollBar.Position;

    If (PanRsized) then
      MULCtrlO.ResizeAllCols(MULCtrlO.VisiList.FindxHandle(Sender),BarPos);

    MULCtrlO.FinishColMove(BarPos+(ListOfset*Ord(PanRSized)),PanRsized);
  end;

end;


procedure TPayInWin.PORefLabMouseDown(Sender: TObject;
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
    end
    else
      If (Button=mbRight) then
      Begin
        ListPoint:=ClientToScreen(Point(X,Y));

        ShowRightMeny(ListPoint.X,ListPoint.Y,0);
      end;

  end;
end;


procedure TPayInWin.PORefLabMouseMove(Sender: TObject; Shift: TShiftState;
  X, Y: Integer);
begin
  If (Sender is TSBSPanel) then
  With (Sender as TSBSPanel) do
  Begin

    If (MULCtrlO<>nil) then
      MULCtrlO.VisiList.MoveLabel(X,Y);
  end;
end;



procedure TPayInWin.SetFormProperties;


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
        SetProperties(TmpPanel[1],TmpPanel[2],TmpPanel[3],1,Self.Caption+'Properties',BeenChange,ResetDefaults);


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

procedure TPayInWin.ShowRightMeny(X,Y,Mode  :  Integer);

Begin
  With PopUpMenu1 do
  Begin

    PopUp(X,Y);
  end;


end;


procedure TPayInWin.PopupMenu1Popup(Sender: TObject);

Var
  n  :  Integer;

begin
  StoreCoordFlg.Checked:=StoreCoord;

end;



procedure TPayInWin.PropFlgClick(Sender: TObject);
begin
  SetFormProperties;
end;

procedure TPayInWin.StoreCoordFlgClick(Sender: TObject);
begin
  StoreCoord:=Not StoreCoord;
end;




procedure TPayInWin.PClsBtnClick(Sender: TObject);
begin
  Close;
end;

{ ======= Link to Trans display ======== }

procedure TPayInWin.Display_Trans(Mode  :  Byte);

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

      ExLocal.AssignFromGlobal(InvF);

      With ExLocal,DispTrans do
      Begin
        LastDocHed:=LInv.InvDocHed;

        If ((LastFolio<>LInv.FolioNum) or (Mode<>100)) then
          Display_Trans(Mode,LInv.FolioNum,BOff,(Mode<>100));

      end; {with..}

    except

      DispTrans.Free;

    end;

end;


procedure TPayInWin.POKBtnClick(Sender: TObject);
begin
  With MULCtrlO do
  Begin
    If (ValidLine) then
      RefreshLine(MUListBoxes[0].Row,(DisplayMode<>0))
    else
      Exit;

    If (Link2Inv) then
      Case DisplayMode of
        0  :  Send_UpdateList(65);

        {$IFDEF STK}

          1..3  :  Display_Trans(0+(2*Ord(DisplayMode=3)));  {* Set to 0 from 2 here, as editing not allowed via a match *}

        {$ENDIF}

      end;
  end;

end;

procedure TPayInWin.SetHelpContextIDs;
// NF: 22/06/06 Fix for incorrect Context IDs
begin
  Case PICtrl.NHMode of
    0 : begin  // Group Information for
      HelpContext := 1895;
    end;

    1,3 : begin // Match For
      HelpContext := 1814;
//      POKBtn.HelpContext := 1815;
//      PClsBtn.HelpContext := 1816;
    end;

    2 : begin  // back orders for
      HelpContext := 1894;
    end;
  end; {Case..}
end;

Initialization

  New(RepScrCount);

  RepScrCount^:=0;

Finalization

  If (Assigned(RepScrCount)) then
    Dispose(RepScrCount);
  RepScrCount:=nil;
end.
