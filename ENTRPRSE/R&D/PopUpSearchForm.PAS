unit PopUpSearchForm;

interface
{PR: 04/10/2013 MRD 1.1.15/6 New form for popup customer/supplier/consumer list - includes tabs for customer/consumer when necessary.}

uses
  SysUtils, Windows, Messages, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ExtCtrls, SBSPanel,SBSComp,  GlobVar, Menus,CmpCtrlU, Buttons, SupListU,
  ComCtrls;

Const
   WM_CustListFinish   =  WM_User+$101;

type

  TACPopUpList = class(TForm)
    PopupMenu1: TPopupMenu;
    PropFlg: TMenuItem;
    N1: TMenuItem;
    StoreCoordFlg: TMenuItem;
    BtnPanel: TSBSPanel;
    ListCanBttn: TButton;
    ListOkBttn: TButton;
    LeftSBtn: TBitBtn;
    RightSBtn: TBitBtn;
    tcList: TTabControl;
    ScrollBox1: TScrollBox;
    GenHedPanel: TSBSPanel;
    ListCol2Lab: TSBSPanel;
    ListCol1Lab: TSBSPanel;
    lsLab: TSBSPanel;
    lfLab: TSBSPanel;
    loLab: TSBSPanel;
    lsPanel: TSBSPanel;
    lfPanel: TSBSPanel;
    loPanel: TSBSPanel;
    ListCol2Panel: TSBSPanel;
    ListCol1Panel: TSBSPanel;
    ListBtnPanel: TSBSPanel;


    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure ListCanBttnClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure ListCol1LabMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure ListCol1LabMouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure ListCol1PanelMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure PopupMenu1Popup(Sender: TObject);
    procedure PropFlgClick(Sender: TObject);
    procedure FormResize(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure StoreCoordFlgClick(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure LeftSBtnClick(Sender: TObject);
    procedure tcListChange(Sender: TObject);
  private

   { Private declarations }

   ListOfSet  :  Integer;

   InFindFormCoOrd : Boolean;

   fNeedCUpdate,
   StoreCoord,
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

    //Only show consumer tab if False
    FHideConsumers : Boolean;

    Procedure  SetNeedCUpdate(B  :  Boolean);

    Property NeedCUpDate :  Boolean Read fNeedCUpDate Write SetNeedCUpdate;

    Function CheckListFinished  :  Boolean;

  public
    { Public declarations }

    FFoundOk    :  Boolean;

    OwnList     :  TGenList;

    OFnum,
    OKeypath,
    OKLen       :  Integer;

    OKey2F      :  Str255;

    ListPFix    :  Char;

    procedure FormSetOfSet;

    procedure Find_FormCoord;

    procedure Store_FormCoord(UpMode  :  Boolean);

    Procedure WMCustFindRec(Var Message  :  TMessage); message WM_CustListFinish;

    Procedure WMGetMinMaxInfo(Var Message  :  TWMGetMinMaxInfo); Message WM_GetMinMaxInfo;

    

    Function StartLookup  :  Boolean;

    Procedure Send_StartList(Mode   :  Integer);

    procedure CreateOwnList(TOList     :  TGenList;
                            SFnum,
                            SKeypath   :  Integer;
                            Key2F      :  Str255;
                            KLen,
                            XMode      :  Integer;
                            CFilters   :  FilterType);

    Procedure FinishList(State  :  Boolean);

    procedure SetFormProperties;

    procedure ShowRightMeny(X,Y,Mode  :  Integer);

    procedure SetListType(PrefixChar : Char; Mode : Byte);

    property HideConsumerTab : Boolean read FHideConsumers write FHideConsumers;


  end;


{~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~}

Implementation

{~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~}

Uses
  VarConst,
  ColCtrlU,


  {$IFNDEF COMP}
  {$IFNDEF EDLL}
  {$IFNDEF EXDLL}
  {$IFNDEF OLE}
  {$IFNDEF EBAD}
    ExThrd2U,
  {$ENDIF}
  {$ENDIF}
  {$ENDIF}
  {$ENDIF}
  {$ENDIF}

  BTSupU2,

  ConsumerUtils, InvListU;

{$R *.DFM}



{ ============ TGenList Methods ================= }





procedure TACPopUpList.FormSetOfSet;


Begin
  PageP.X:=ClientWidth-(ListBtnPanel.Left)+2;
  PageP.Y:=ClientHeight-(ListBtnPanel.Height)+2;

  ScrollAP.X:=ClientWidth-(ScrollBox1.Width);
  ScrollAP.Y:=ClientHeight-(ScrollBox1.Height);

  {ScrollBP.X:=PageControl1.Width-(Panel1.Left);
  ScrollBP.Y:=PageControl1.Height-(Panel1.Height);}

  {Misc1P.X:=ListPanel.Height-(ListBtnPanel.Height);}
  Misc1P.Y:=ScrollBox1.ClientHeight-(ListCol1Panel.Height);

  PanelP.X:=ClientWidth-(BtnPanel.Left);
  PanelP.Y:=ClientHeight-(BtnPanel.Top);


  GotCoord:=BOn;

end;


Procedure  TACPopUpList.SetNeedCUpdate(B  :  Boolean);

Begin
  If (Not fNeedCUpdate) then
    fNeedCUpdate:=B;
end;


procedure TACPopUpList.Find_FormCoord;


Var
  ThisForm:  TForm;

  VisibleRect
          :  TRect;

  GlobComp:  TGlobCompRec;


Begin
  InFindFormCoOrd := True;
  Try
    New(GlobComp,Create(BOn));

    ThisForm:=Self;

    With GlobComp^ do
    Begin
      PrimeKey:=ListPFix;

      //Only one set of properties for customer/consumer mode
      if PrimeKey = CONSUMER_CHAR then
        PrimeKey := CUSTOMER_CHAR;

      GetValues:=BOn;

      If (GetbtControlCsm(ThisForm)) then
      Begin
        {StoreCoord:=(ColOrd=1); v4.40. To avoid on going corruption, this is reset each time its loaded}
        StoreCoord:=BOff;
        HasCoord:=(HLite=1);
        LastCoord:=HasCoord;

        If (HasCoord) then {* Go get postion, as would not have been set initianly *}
          SetPosition(ThisForm);

      end;

      GetbtControlCsm(BtnPanel);


      OwnList.Find_ListCoord(GlobComp);

    end; {With GlobComp..}


    Dispose(GlobComp,Destroy);

        {* Check form is within current visible range *}

    With TForm(Owner) do
      VisibleRect:=Rect(0,0,ClientWidth,ClientHeight);

    If (Not PtInRect(VisibleRect,Point(Left,Top))) then
    Begin
      Left:=TControl(Owner).Width-(Width+10);
      Top:=TControl(Owner).Height-(Height-10);
    end;

    StartSize.X:=Width;
    StartSize.Y:=Height;
  Finally
    InFindFormCoOrd := False;
  End; // Try..Finally
end;


procedure TACPopUpList.Store_FormCoord(UpMode  :  Boolean);


Var
  GlobComp:  TGlobCompRec;


Begin


  New(GlobComp,Create(BOff));

  With GlobComp^ do
  Begin
    PrimeKey:=ListPFix;

    //Only one set of properties for customer/consumer mode
    if PrimeKey = CONSUMER_CHAR then
      PrimeKey := CUSTOMER_CHAR;

    GetValues:=UpMode;

    ColOrd:=Ord(StoreCoord);

    HLite:=Ord(LastCoord);

    SaveCoord:=StoreCoord;

    If (Not LastCoord) then {* Attempt to store last coord *}
      HLite:=ColOrd;

    StorebtControlCsm(Self);

    StorebtControlCsm(BtnPanel);

    OwnList.Store_ListCoord(GlobComp);

  end; {With GlobComp..}

  Dispose(GlobComp,Destroy);


end;


procedure TACPopUpList.FormCreate(Sender: TObject);

Var
  n  :  Integer;

begin
  FFoundOk:=BOff;
  InFindFormCoOrd:=False;

  InitSize.Y:=310;
  InitSize.X:=350;

  Self.ClientHeight:=InitSize.Y;
  Self.ClientWidth:=InitSize.X;

  NeedCUpdate:=BOff;

  For n:=0 to Pred(ComponentCount) do
    If (Components[n] is TScrollBox) then
    With TScrollBox(Components[n]) do
    Begin
      VertScrollBar.Position:=0;
      HorzScrollBar.Position:=0;
    end;

  VertScrollBar.Position:=0;
  HorzScrollBar.Position:=0;


end;


procedure TACPopUpList.FormResize(Sender: TObject);

const
  TabControlX = 19;
  TabControlY = 53;

Var
  n  :  Integer;

begin
  If (GotCoord) then
  Begin
    LockWindowUpdate(Self.Handle);
    Try
      tcList.Width := ClientWidth - TabControlX;
      tcList.Height := ClientHeight - TabControlY;

      Self.HorzScrollBar.Position:=0;
      Self.VertScrollBar.Position:=0;

      BtnPanel.Left:=(ClientWidth-PanelP.X);
      BtnPanel.Top:=(ClientHeight-PanelP.Y);


      ScrollBox1.Width:=ClientWidth-ScrollAP.X;
      ScrollBox1.Height:=ClientHeight-ScrollAP.Y;

       With OwnList,VisiList do
       Begin
         VisiRec:=List[0];

         With (VisiRec^.PanelObj as TSBSPanel) do
           Height:=ScrollBox1.ClientHeight-Misc1P.Y;

         ReFresh_Buttons;

         RefreshAllCols;

         VisiRec:=List[MUTotCols];

         With (VisiRec^.PanelObj as TSBSPanel) do
         Begin
           ListBtnPanel.Left:=ScrollBox1.Width+3+ScrollBox1.Left;
           ListBtnPanel.Height:=Height;
         end;

       end;{with}

       If (Not InFindFormCoOrd) And (StartLookUp) then
         OwnList.MUListBoxes[0].SetFocus;

       NeedCUpdate:=((StartSize.X<>Width) or (StartSize.Y<>Height));
    Finally
      LockWindowUpdate(0);
    End; // Try..Finally
  end; {If time to update}


end;

procedure TACPopUpList.FormClose(Sender: TObject; var Action: TCloseAction);
begin

  Action:=CaFree;

end;

Function TACPopUpList.CheckListFinished  :  Boolean;

Var
  n       :  Byte;
  mbRet   :  Word;
Begin
  Result:=BOn;

  If (Assigned(OwnList)) then
    Result:=Not OwnList.ListStillBusy;

  If (Not Result) then
  Begin
    {$IFNDEF COMP}
    {$IFNDEF EDLL}
    {$IFNDEF EXDLL}
    {$IFNDEF OLE}
    {$IFNDEF EBAD}
      Set_BackThreadMVisible(BOn);
    {$ENDIF}
    {$ENDIF}
    {$ENDIF}
    {$ENDIF}
    {$ENDIF}

    mbRet:=MessageDlg('The list is still busy.'+#13+#13+
                      'Do you wish to interrupt the list so that you can exit?',mtConfirmation,[mbYes,mbNo],0);

    If (mBRet=mrYes) then
    Begin
      OwnList.IRQSearch:=BOn;

      ShowMessage('Please wait a few seconds, then try closing again.');
    end;
    {$IFNDEF COMP}
    {$IFNDEF EDLL}
    {$IFNDEF EXDLL}
    {$IFNDEF OLE}
    {$IFNDEF EBAD}
      Set_BackThreadMVisible(BOff);
    {$ENDIF}
    {$ENDIF}
    {$ENDIF}
    {$ENDIF}
    {$ENDIF}

  end;
end;


procedure TACPopUpList.FormCloseQuery(Sender: TObject;
  var CanClose: Boolean);

Var
  n  :  Integer;

begin
  CanClose:=CheckListFinished;

  If (CanClose) then
  Begin
    If (NeedCUpdate) then
      Store_FormCoord(Not SetDefault);

    For n:=0 to Pred(ComponentCount) do
      If (Components[n] is TScrollBox) then
      With TScrollBox(Components[n]) do
      Begin
        VertScrollBar.Position:=0;
        HorzScrollBar.Position:=0;
      end;

    VertScrollBar.Position:=0;
    HorzScrollBar.Position:=0;
  end;
end;


procedure TACPopUpList.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  {* Disconnected, as form is show modal, and really sure if another form should be
     created during modal state, perhaps best not! *}

  {GlobFormKeyDown(Sender,Key,Shift,ActiveControl,Handle);}
end;


Procedure TACPopUpList.FinishList(State  :  Boolean);

Begin
  FFoundOk:=State and CheckListFinished;

  If (FFoundOk) then
    With OwnList do
      RefreshLine(MUListBoxes[0].Row,BOff);

  PostMessage(Handle,WM_Close,0,0);

  {Close;}

end;


procedure TACPopUpList.ListCanBttnClick(Sender: TObject);
begin
  If (Not OwnList.InListFind) then
    FinishList((Sender=ListOkBttn));
end;

Procedure TACPopUpList.WMCustFindRec(Var Message  :  TMessage);


Begin

  With Message do
    Case WParam of
      0  :  FinishList(BOn);

      2  :  ShowRightMeny(LParamLo,LParamHi,1);

    //PR: 04/10/2013 MRD 1.1.17 Only close an empty list if we're on Suppliers or mode = 99
    9999 :  if tcList.Tabs.Count < 2 then
               FinishList(BOff);

    end; {Case..}

  Inherited;
end;


Procedure TACPopUpList.WMGetMinMaxInfo(Var Message  :  TWMGetMinMaxInfo);

Begin

  With Message.MinMaxInfo^ do
  Begin

    ptMinTrackSize.X:=InitSize.X;
    ptMinTrackSize.Y:=InitSize.Y;

    {ptMaxSize.X:=530;
    ptMaxSize.Y:=368;
    ptMaxPosition.X:=1;
    ptMaxPosition.Y:=1;}

  end;

  Message.Result:=0;

  Inherited;

end;

Function TACPopUpList.StartLookup  :  Boolean;

Begin


  With OwnList do
  Begin


    StartList(OFnum,OKeyPath,OKey2F,OKey2F,'',OKLen,BOff);
    Result:=Not ExitScan;


  end;


end;


Procedure TACPopUpList.Send_StartList(Mode   :  Integer);

Var
  Message1 :  TMessage;
  MessResult
           :  LongInt;

Begin
  FillChar(Message1,Sizeof(Message1),0);

  With Message1 do
  Begin
    MSg:=0;
    WParam:=Mode;
  end;

  With Message1 do
    MessResult:=SendMEssage(Self.Handle,Msg,WParam,LParam);

end; {Proc..}

procedure TACPopUpList.FormShow(Sender: TObject);

Var
  NewLeft,
  NewTop    :   Integer;
begin
  FormSetOfSet;

  Find_FormCoord;

{$IFDEF EBAD}
  {$DEFINE CENTRE}
{$ENDIF}
{$IFDEF TRADE}
  {$DEFINE CENTRE}
{$ENDIF}

{$IFDEF CENTRE}
  {Centre popup window to parent}
  Left := TControl(Owner).Left + ((TControl(Owner).Width - Width) div 2);
  Top := TControl(Owner).Top + ((TControl(Owner).Height - Height) div 2);

{$ELSE}
  if (Owner = Application.MainForm) then
  begin
    NewLeft := TControl(Owner).Left + ((TControl(Owner).Width - Width) div 2);
    NewTop := TControl(Owner).Top + ((TControl(Owner).Height - Height) div 2);
  end
  else
  begin
    {* Reset Left pos so it is always relative *}
    NewLeft:=TControl(Owner).Width-(Width+10);
    NewTop:=TControl(Owner).Height-(Height-10);
  end;

  If (NewLeft>0) then
    Left:=NewLeft;

  If (NewTop>0) then
    Top:=NewTop;
{$ENDIF}

  MDI_UpdateParentStat;

end;


procedure TACPopUpList.CreateOwnList(TOList     :  TGenList;
                                   SFnum,
                                   SKeypath   :  Integer;
                                   Key2F      :  Str255;
                                   KLen,
                                   XMode      :  Integer;
                                   CFilters   :  FilterType);

Var
  StartPanel
     :  TSBSPanel;

  n  :  Integer;


Begin
  StartPanel := nil;
  OwnList:=TOList;

  OFnum:=SFnum;
  OKeypath:=SKeypath;
  OKey2F:=Key2F;
  OKLen:=KLen;

  Try
    With OwnList do
    Begin

      Try

        DisplayMode:=XMode;

        YieldMessage:=BOn;

        Filter:=CFilters;

        With VisiList do
        Begin
          AddVisiRec(ListCol1Panel,ListCol1Lab);
          AddVisiRec(ListCol2Panel,ListCol2Lab);

          If (DisplayMode In [77,78]) then
          Begin
            lsLab.Visible:=BOn;
            lfLab.Visible:=BOn;
            loLab.Visible:=BOn;
            lsPanel.Visible:=BOn;
            lfPanel.Visible:=BOn;
            loPanel.Visible:=BOn;

            AddVisiRec(lsPanel,lsLab);
            AddVisiRec(lfPanel,lfLab);
            AddVisiRec(loPanel,loLab);

            SetHidePanel(1,(DisplayMode=77),BOn);

          end;

          VisiRec:=List[0];

          StartPanel:=(VisiRec^.PanelObj as TSBSPanel);

          LabHedPanel:=GenHedPanel;

          ListOfSet:=10;

          SetHedPanel(ListOfSet);

          If (HasScroll) then
          Begin
            LeftSBtn.Visible:=BOn;
            RightSBtn.Visible:=BOn;
          end;
        end;
      except
        VisiList.Free;

      end;

      TabOrder := -1;
      TabStop:=BOff;
      Visible:=BOff;
      BevelOuter := bvNone;
      ParentColor := False;
      Color:=StartPanel.Color;

      Case DisplayMode of {V4.40}
        77,78
            : MUTotCols:=4;
        else  MUTotCols:=1;
      end; {Case..}

      {If (DisplayMode<>77) then
        MUTotCols:=1
      else
        MUTotCols:=4;}

      Font:=StartPanel.Font;

      WM_ListGetRec:=WM_CustListFinish;

      AbortOnEmpty:=BOn;

      Parent:=StartPanel.Parent;

      MessHandle:=Self.Handle;

      For n:=0 to MUTotCols do
      With ColAppear^[n] do
      Begin
        AltDefault:=BOn;

        If (DisplayMode In [77,78]) and (n>1) then
        Begin
          DispFormat:=SGFloat;
          NoDecPlaces:=Syss.NoQtyDec;
        end;
      end;

      ListCreate;

      Set_Buttons(ListBtnPanel);


      AbortOnEmpty:=BOn;

    end; {With..}

  except

    OwnList.Free;
    OwnList:=Nil;

  end;

end;


procedure TACPopUpList.SetFormProperties;


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

    With OwnList.VisiList do
    Begin

      VisiRec:=List[0];

      TmpPanel[1].Font:=(VisiRec^.PanelObj as TSBSPanel).Font;
      TmpPanel[1].Color:=(VisiRec^.PanelObj as TSBSPanel).Color;

      TmpPanel[2].Font:=(VisiRec^.LabelObj as TSBSPanel).Font;
      TmpPanel[2].Color:=(VisiRec^.LabelObj as TSBSPanel).Color;

      TmpPanel[3].Color:=OwnList.ColAppear^[0].HBKColor;
    end;

    TmpPanel[3].Font.Assign(TmpPanel[1].Font);

    TmpPanel[3].Font.Color:=OwnList.ColAppear^[0].HTextColor;


    ColourCtrl:=TCtrlColor.Create(Self);

    try
      With ColourCtrl do
      Begin
        SetProperties(TmpPanel[1],TmpPanel[2],TmpPanel[3],1,Self.Caption+' Properties',BeenChange,ResetDefaults);

        NeedCUpdate:=(BeenChange or ResetDefaults);

        If (BeenChange) and (not ResetDefaults) then
        Begin

          For n:=1 to 3 do
            With TmpPanel[n] do
              Case n of
                1,2  :  OwnList.ReColorCol(Font,Color,(n=2));

                3    :  OwnList.ReColorBar(Font,Color);
              end; {Case..}

          OwnList.VisiList.LabHedPanel.Color:=TmpPanel[2].Color;
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
    GotCoord:=BOff;
    SetDefault:=BOn;
    Close;
  end;

end;

procedure TACPopUpList.PopupMenu1Popup(Sender: TObject);
begin
  StoreCoordFlg.Checked:=StoreCoord;
end;


procedure TACPopUpList.ShowRightMeny(X,Y,Mode  :  Integer);

Begin
  With PopUpMenu1 do
  Begin

    PopUp(X,Y);

  end;


end;

procedure TACPopUpList.PropFlgClick(Sender: TObject);
begin
  SetFormProperties;
end;

procedure TACPopUpList.StoreCoordFlgClick(Sender: TObject);
begin
  StoreCoord:=Not StoreCoord;

  NeedCUpdate:=BOn;
end;


procedure TACPopUpList.ListCol1LabMouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
Var
  ListPoint  :  TPoint;


begin
  If (Sender is TSBSPanel) then
  With (Sender as TSBSPanel) do
  Begin

    If (Not ReadytoDrag) and (Button=MBLeft) then
    Begin
      OwnList.VisiList.PrimeMove(Sender);
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


procedure TACPopUpList.ListCol1LabMouseMove(Sender: TObject;
  Shift: TShiftState; X, Y: Integer);
begin
  If (Sender is TSBSPanel) then
  With (Sender as TSBSPanel) do
  Begin
    OwnList.VisiList.MoveLabel(X,Y);

    NeedCUpdate:=OwnList.VisiList.MovingLab;
  end;

end;

procedure TACPopUpList.ListCol1PanelMouseUp(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);

Var
  PanRSized
         :  Boolean;

  BarPos :  Integer;



begin
  BarPos:=0;

  If (Sender is TSBSPanel) then
  With (Sender as TSBSPanel) do
  Begin

    PanRSized:=ReSized;

    BarPos:=ScrollBox1.HorzScrollBar.Position;

    If (PanRsized) then
    Begin
      OwnList.ResizeAllCols(OwnList.VisiList.FindxHandle(Sender),BarPos);
      {FormReSize(Self);}
    end;

    OwnList.FinishColMove(BarPos+(ListOfset*Ord(PanRSized)),PanRsized);

    NeedCUpdate:=(OwnList.VisiList.MovingLab or PanRSized);

  end;

end;


procedure TACPopUpList.LeftSBtnClick(Sender: TObject);
begin
  If (assigned(OwnList)) then
    With OwnList do
    Begin
      SetScroll(Sender=RightSBtn);

      PageUpDn(0,BOn);

      ListCol2Lab.Caption:=SetColCaption;

    end;
end;

procedure TACPopUpList.SetListType(PrefixChar: Char; Mode: Byte);
begin
  tcList.Tabs.Clear;
  ListPFix := PrefixChar;
  if Mode = 99 then
    tcList.Tabs.Add('Accounts')
  else
  if ListPFix = SUPPLIER_CHAR then
    tcList.Tabs.Add('Suppliers')
  else
  begin
    tcList.Tabs.Add('Customers');

    //PR: 27/11/2013 Only show consumers tab if consumers enabled.
    //PR: 02/12/2013 add check that we don't want to hid consumers
    if Syss.ssConsumersEnabled and not FHideConsumers then
      tcList.Tabs.Add('Consumers');
    tcList.TabIndex := TraderTypeFromSubType(ListPFix);
  end;

end;

procedure TACPopUpList.tcListChange(Sender: TObject);
var
  KeyS : Str255;
  NewIdx : Integer;
begin
  NewIdx := 0;
  //When changing between customers & consumers we need to restart the list
  //with the correct prefix and index
  if tcList.Tabs.Count > 1 then
  begin

    //Set List Prefix
    ListPFix := SubTypeFromTraderType(tcList.TabIndex);
    with OwnList as TCustList do
    begin
      //Set filter
      Filter[1, 0] := ListPFix;

      //Change first char of search text to appropriate prefix
      KeyS := ListPFix + Copy(KeyRef, 2, Length(KeyRef));
      Case ListPFix of
        CUSTOMER_CHAR  : begin //consumer -> customer
                           if KeyPath = CustLongACCodeK then
                             NewIdx := CustACCodeK
                           else
                             NewIdx := KeyPath;

                           ConsumerMode := cmDontShow;
                         end;
        CONSUMER_CHAR  : begin //consumer -> customer
                           if KeyPath = CustACCodeK then
                             NewIdx := CustLongACCodeK
                           else
                             NewIdx := KeyPath;

                           ConsumerMode := cmShowLongCode;
                         end;
      end; //case

      //Start list
      StartList(ScanFileNum, NewIdx, KeyS, '', KeyS, KeyLen, False);
    end;


  end;
end;

Initialization

  {Application.Title:='Exchequer';}

end.
