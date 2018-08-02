unit DiarLstU;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, SBSPanel, ExtCtrls,

  GlobVar,VarConst,ExWrap1U,BTSupU1,SupListU,SBSComp2,

  NoteU, Menus;

  
  


type
  TDiaryList = class(TForm)
    Panel1: TPanel;
    A1SBox: TScrollBox;
    A1HedPanel: TSBSPanel;
    ADateLab: TSBSPanel;
    ADescLab: TSBSPanel;
    ASRCLab: TSBSPanel;
    ADatePanel: TSBSPanel;
    ADescPanel: TSBSPanel;
    ASRCPanel: TSBSPanel;
    A1BtnPanel: TSBSPanel;
    A1BsBox: TScrollBox;
    EditN1Btn: TButton;
    DelN1Btn: TButton;
    AddN1Btn: TButton;
    InsN1Btn: TButton;
    SwiN1Btn: TButton;
    AUserPanel: TSBSPanel;
    AToPanel: TSBSPanel;
    AtoLab: TSBSPanel;
    AUserLab: TSBSPanel;
    ClrN1Btn: TButton;
    ViewN1Btn: TButton;
    TelSN1Btn: TButton;
    A1ListBtnPanel: TSBSPanel;
    ClsN1Btn: TButton;
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
    Clear1: TMenuItem;
    View1: TMenuItem;
    TeleSales1: TMenuItem;
    procedure FormCreate(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormDestroy(Sender: TObject);
    procedure FormResize(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure FormKeyPress(Sender: TObject; var Key: Char);
    procedure AddN1BtnClick(Sender: TObject);
    procedure DelN1BtnClick(Sender: TObject);
    procedure SwiN1BtnClick(Sender: TObject);
    procedure PopupMenu1Popup(Sender: TObject);
    procedure PropFlgClick(Sender: TObject);
    procedure StoreCoordFlgClick(Sender: TObject);
    procedure ClsN1BtnClick(Sender: TObject);
    procedure ViewN1BtnClick(Sender: TObject);
    procedure ClrN1BtnClick(Sender: TObject);
  private
    BeingCded,
    JustCreated,
    StopPageChange,
    FirstStore,
    StoreCoord,
    LastCoord,
    SetDefault,
    fNeedCUpdate,
    GotCoord,
    CanDelete    :  Boolean;

    SKeypath,
    MinHeight,
    MinWidth     :  Integer;


    InvBtnList   :  TVisiBtns;

    PagePoint    :  Array[0..6] of TPoint;

    StartSize,
    InitSize     :  TPoint;



    TNCode       :  Char;
    TNMode       :  Byte;

    ThisRecAddr,
    TNLineCount  :  LongInt;

    DispCust     :  Pointer;

    DispDoc      :  Pointer;

    {$IFDEF STK}
      DispStk    :  Pointer;
    {$ENDIF}

    {$IFDEF JC}
      DispJob    :  Pointer;

      DispEmp    :  Pointer;
    {$ENDIF}



    procedure Find_FormCoord;

    procedure Store_FormCoord(UpMode  :  Boolean);

    Procedure SetForceStore(State  :  Boolean);

    procedure NotePageReSize;

    Procedure WMCustGetRec(Var Message  :  TMessage); Message WM_CustGetRec;

    Procedure WMGetMinMaxInfo(Var Message  :  TWMGetMinMaxInfo); Message WM_GetMinMaxInfo;

    

    Procedure Send_UpdateList(Edit   :  LongInt;
                              Mode   :  Integer);

    procedure ShowRightMeny(X,Y,Mode  :  Integer);

    Procedure  SetNeedCUpdate(B  :  Boolean);

    Property NeedCUpDate :  Boolean Read fNeedCUpDate Write SetNeedCUpdate;

    procedure Display_AccRec;

    procedure Display_TransRec;

    {$IFDEF STK}
      procedure Display_StockRec;
    {$ENDIF}


    {$IFDEF JC}
      procedure Display_JobRec;

      procedure Display_EmpRec;

    {$ENDIF}

    Procedure DisplayRecord(LMode  :  Integer;
                            NC     :  Char;
                            NK     :  Str10);


  public
    { Public declarations }

    fForceStore:  Boolean;

    ExLocal    :  TdExLocal;
    ListOfSet  :  Integer;

    TNKey        :  Str255;
    NotesCtrl    :  TNoteCtrl;

    Property ForceStore  : Boolean read fForceStore write SetForceStore default False;

    procedure PrimeButtons;

    procedure BuildDesign;

    procedure FormDesign;

    Function Current_BarPos(PageNo  :  Byte)  :  Integer;

    procedure FormBuildList(ShowLines  :  Boolean);

    procedure ShowLink(ShowLines,
                       VOMode    :  Boolean);


    procedure SetCaption(CTit  :  Str255);

    procedure FormSetOfSet;


    procedure SetRecAddr(Fnum  : SmallInt);

    procedure GetRecFAddr(Fnum,Keypath  : SmallInt);

  end;

  Procedure Set_NFormMode(SKey  :  Str255;
                          SCode :  Char;
                          SMode :  Byte;
                          NL    :  LongInt);


  Procedure Create_Diary(     AOwner :  TWinControl;
                         Var  Diary  :  TDiaryList;
                              Opt    :  Byte);

  Function Check_Diary(MatchDate  :  LongDate)  :  Boolean;

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
  PWarnU,
  NoteSupU,

  {$IFDEF DBD}
    DebugU,
  {$ENDIF}


  SysU1,

  Saltxl1U,

  {$IFDEF STK}
    Saltxl2U,
  {$ENDIF}

  Tranl1U,

  {$IFDEF JC}
    Saltxl3U,
  {$ENDIF}


  ExThrd2U,
  
  SysU2;

{$R *.DFM}



Var
  NTKey   :   Str255;
  NTCode  :   Char;
  NTMode  :   Byte;
  NLC     :   LongInt;



{ ========= Exported function to set View type b4 form is created ========= }

Procedure Set_NFormMode(SKey  :  Str255;
                        SCode :  Char;
                        SMode :  Byte;
                        NL    :  LongInt);


Begin
  NTKey:=SKey;
  NTCode:=SCode;
  NTMode:=SMode;
  NLC:=NL;

end;





Procedure  TDiaryList.SetNeedCUpdate(B  :  Boolean);

Begin
  If (Not fNeedCUpdate) then
    fNeedCUpdate:=B;
end;


procedure TDiaryList.Find_FormCoord;


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

    PrimeKey:=TNCode;

    If (GetbtControlCsm(ThisForm)) then
    Begin
      {StoreCoord:=(ColOrd=1); v4.40. To avoid on going corruption, this is reset each time its loaded}
      StoreCoord:=BOff;
      HasCoord:=(HLite=1);
      LastCoord:=HasCoord;

      If (HasCoord) then {* Go get postion, as would not have been set initianly *}
        SetPosition(ThisForm);

    end;

    GetbtControlCsm(A1SBox);

    GetbtControlCsm(A1BSBox);

    GetbtControlCsm(A1BtnPanel);

    GetbtControlCsm(A1ListBtnPanel);

    {MULCtrlO.Find_ListCoord(GlobComp);}

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


procedure TDiaryList.Store_FormCoord(UpMode  :  Boolean);


Var
  GlobComp:  TGlobCompRec;


Begin

  New(GlobComp,Create(BOff));

  With GlobComp^ do
  Begin
    GetValues:=UpMode;

    PrimeKey:=TNCode;

    ColOrd:=Ord(StoreCoord);

    HLite:=Ord(LastCoord);

    SaveCoord:=StoreCoord;

    If (Not LastCoord) then {* Attempt to store last coord *}
      HLite:=ColOrd;

    StorebtControlCsm(Self);

    StorebtControlCsm(A1SBox);

    StorebtControlCsm(A1BSBox);

    StorebtControlCsm(A1BtnPanel);

    StorebtControlCsm(A1ListBtnPanel);

    If (NotesCtrl<>nil) then
      NotesCtrl.MULCtrlO.Store_ListCoord(GlobComp);

  end; {With GlobComp..}

  Dispose(GlobComp,Destroy);

end;




procedure TDiaryList.SetForceStore(State  :  Boolean);

Begin
  If (State<>fForceStore) then
  Begin
    fForceStore:=State;

    If (Not ExLocal.LViewOnly) then
    Begin
      ClsN1Btn.Enabled:=Not fForceStore;
    end;
  end;
end;




Procedure TDiaryList.WMCustGetRec(Var Message  :  TMessage);
Begin


  With Message do
  Begin

    {If (Debug) then
      DebugForm.Add('Mesage Flg'+IntToStr(WParam));}

    Case WParam of
      0,169
         :  Begin

              AddN1BtnClick(EditN1Btn);

            end;

      1  :  Begin

            end;

      2  :  ShowRightMeny(LParamLo,LParamHi,1);

      7  :  If (Assigned(NotesCtrl)) then
            Begin {* Update note line count *}
              Send_UpdateList(NotesCtrl.GetLineNo,150);
            end;

     17  :  Begin {* Force reset of form *}
              GotCoord:=BOff;
              SetDefault:=BOn;
              Close;
            end;


     25  :  NeedCUpdate:=BOn;


    120,121
         :  Begin

              InvBtnList.SetEnabBtn((WParam=120));

            end;

     176 :  Case LParam of
              0  :  If (Assigned(NotesCtrl)) then
                      NotesCtrl.MULCtrlO.SetListFocus;
            end; {Case..}

     307  :  ; {Clear}

     308  :  ViewN1BtnClick(nil);

     309  :  ; {TeleSales}

    end; {Case..}

  end;
  Inherited;
end;


Procedure TDiaryList.WMGetMinMaxInfo(Var Message  :  TWMGetMinMaxInfo);

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

Procedure TDiaryList.Send_UpdateList(Edit   :  LongInt;
                                     Mode   :  Integer);

Var
  Message1 :  TMessage;
  MessResult
           :  LongInt;

Begin
  FillChar(Message1,Sizeof(Message1),0);

  With Message1 do
  Begin
    If (TNMode<>1) then
      MSg:=WM_FormCloseMsg
    else
      MSg:=WM_CustGetRec;

    WParam:=Mode+100;
    LParam:=Edit;
  end;

  With Message1 do
    MessResult:=SendMEssage((Owner as TForm).Handle,Msg,WParam,LParam);

end; {Proc..}


procedure TDiaryList.ShowLink(ShowLines,
                               VOMode    :  Boolean);
begin
  If (NotesCtrl<>nil) then {* Assume record has changed *}
  With ExLocal do
  Begin
    If (NotesCtrl.MULCtrlO.DisplayMode<>NTMode) then
      NotesCtrl.MULCtrlO.DisplayMode:=NTMode;

    NotesCtrl.RefreshList(TNKey,NotesCtrl.GetNType);
    NotesCtrl.GetLineNo:=TNLineCount;
  end;

  JustCreated:=BOff;

end;


procedure TDiaryList.FormSetOfSet;

Begin
  PagePoint[0].X:=ClientWidth-(Panel1.Width);
  PagePoint[0].Y:=ClientHeight-(Panel1.Height);

  PagePoint[1].X:=Panel1.Width-(A1SBox.Width);
  PagePoint[1].Y:=Panel1.Height-(A1SBox.Height);

  PagePoint[2].X:=Panel1.Width-(A1BtnPanel.Left);
  PagePoint[2].Y:=Panel1.Height-(A1BtnPanel.Height);

  PagePoint[3].X:=A1BtnPanel.Height-(A1BSBox.Height);
  PagePoint[3].Y:=A1SBox.ClientHeight-(ADescPanel.Height);

  PagePoint[4].X:=Panel1.Width-(A1ListBtnPanel.Left);
  PagePoint[4].Y:=Panel1.Height-(A1ListBtnPanel.Height);

  GotCoord:=BOn;

end;


procedure TDiaryList.PrimeButtons;


Begin

  If (InvBtnList=nil) then
  Begin
    InvBtnList:=TVisiBtns.Create;

    try

      With InvBtnList do
        Begin
   {00}   AddVisiRec(AddN1Btn,BOff);
   {01}   AddVisiRec(EditN1Btn,BOff);
   {02}   AddVisiRec(InsN1Btn,BOff);
   {03}   AddVisiRec(DelN1Btn,BOff);
   {04}   AddVisiRec(SwiN1Btn,BOff);
   {05}   AddVisiRec(ClrN1Btn,BOff);
   {06}   AddVisiRec(ViewN1Btn,BOff);
   {07}   AddVisiRec(TelSN1Btn,BOff);

        end; {With..}

    except

      InvBtnList.Free;
      InvBtnList:=nil;
    end; {Try..}

  end; {If needs creating }

  try

    With InvBtnList do
    Begin

      SetBtnHelp(0,88);
      SetBtnHelp(1,87);
      SetBtnHelp(2,89);

      SetHideBtn(0,(TNMode<>1),BOff);
      SetHideBtn(3,(TNMode<>1),BOff);
      SetHideBtn(4,(TNMode<>1),BOff);
      SetHideBtn(5,(TNMode=1),BOff);
      SetHideBtn(6,(TNMode=1),BOff);
      PWSetHideBtn(7,BOn,BOn,245);

    end;

    // NF: 09/05/06 Fixes for incorrect Context IDs
    // CJS 08/06/2011 ABSEXCH-10425 - Corrected main Help Context ID
    HelpContext := 1719;
    Panel1.HelpContext := HelpContext;
    ADatePanel.HelpContext := 1719;
    InsN1Btn.HelpContext := 86;
    DelN1Btn.HelpContext := 89;
    SwiN1Btn.HelpContext := 90;

  except
    InvBtnList.Free;
    InvBtnList:=nil;
  end; {try..}

end;

procedure TDiaryList.BuildDesign;


begin

  {* Set Version Specific Info *}

end;


procedure TDiaryList.FormDesign;


begin

  PrimeButtons;

  BuildDesign;

end;



Function TDiaryList.Current_BarPos(PageNo  :  Byte)  :  Integer;

Begin
  Case PageNo of
      0
         :  Result:=A1SBox.HorzScrollBar.Position;
      else  Result:=0;
    end; {Case..}


end;




procedure TDiaryList.FormBuildList(ShowLines  :  Boolean);

Var
  n,
  NewIndex  :  Integer;

  NoteSetUp :  TNotePadSetUp;

begin
  If (NotesCtrl=nil) then
  With ExLocal do
  Begin
    NotesCtrl:=TNoteCtrl.Create(Self);

    NotesCtrl.Caption:=Caption+' - Notes';

    With NoteSetUp do
    Begin
      FillChar(NoteSetup,Sizeof(NoteSetUp),0);
      XtraMode:=TNMode;

      ColPanels[0]:=ADatePanel; ColPanels[1]:=ADateLab;
      ColPanels[2]:=ADescPanel; ColPanels[3]:=ADescLab;
      ColPanels[4]:=AUserPanel; ColPanels[5]:=AUserLab;

      ColPanels[8]:=ASRCPanel; ColPanels[9]:=ASRCLab;
      ColPanels[10]:=AToPanel; ColPanels[11]:=AToLab;

      ColPanels[6]:=A1HedPanel;
      ColPanels[7]:=A1ListBtnPanel;

      ScrollBox:=A1SBox;
      PropPopUp:=StoreCoordFlg;

      CoorPrime:=TNCode;

      Find_FormCoord;

      CoorHasCoor:=LastCoord;


    end;

    try
      NotesCtrl.CreateList(Self,NoteSetUp,TNCode,NoteCDCode,TNKey);
      NotesCtrl.GetLineNo:=TNLineCount;

      With InvBtnList do
      Begin
        ResetMenuStat(NotesCtrl.NotesPopUpM,BOn,BOn);

        With NotesCtrl.NotesPopUpM do
        For n:=0 to Pred(Count) do
          SetMenuFBtn(Items[n],n);

      end; {With..}


    except
      NotesCtrl.Free;
      NotesCtrl:=Nil
    end;


    FormSetOfSet;

    FormReSize(Self);

  end
  else
  With ExLocal do
    If (TNKey<>NotesCtrl.GetFolio) then {* Refresh notes *}
    with NotesCtrl do
    Begin
      RefreshList(TNKey,GetNType);
      GetLineNo:=TNLineCount
    end;
end;



procedure TDiaryList.FormCreate(Sender: TObject);

Var
  n  :  Integer;

begin
  ExLocal.Create;

  ForceStore:=BOff;

  LastCoord:=BOff;

  NeedCUpdate:=BOff;

  BeingCded:=BOff;

  Visible:=BOff;

  JustCreated:=BOn;

  StopPageChange:=BOff;

  SKeypath:=0;

  MinHeight:=315;
  MinWidth:=511;

  InitSize.Y:=318;
  InitSize.X:=513;

  Self.ClientHeight:=InitSize.Y;
  Self.ClientWidth:=InitSize.X;

  TNKey:=NTKey;
  TNCode:=NTCode;
  TNMode:=NTMode;
  TNLineCount:=NLC;

  {Caption:=DocNames[DocHed];}

  For n:=0 to Pred(ComponentCount) do
    If (Components[n] is TScrollBox) then
    With TScrollBox(Components[n]) do
    Begin
      VertScrollBar.Position:=0;
      HorzScrollBar.Position:=0;
    end;


  FormDesign;

  FormBuildList(BOff);

  If (TNMode=3) then
  Begin
    WindowState:=wsMinimized;
  end
  else
  Begin
    MDI_SetFormCoord(TForm(Self));
  end;

end;



procedure TDiaryList.FormDestroy(Sender: TObject);

Var
  n  :  Byte;
begin
  ExLocal.Destroy;

  If (InvBtnList<>nil) then
    InvBtnList.Free;
end;

procedure TDiaryList.FormCloseQuery(Sender: TObject;
                                 var CanClose: Boolean);
Var
  n  : Integer;

begin

  GenCanClose(Self,Sender,CanClose,BOn);

  If (CanClose) then
    CanClose:=GenCheck_InPrint;

  If (CanClose) then
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


      If (NotesCtrl<>nil) then
      Begin
        try
          // MH 11/01/2011 v6.6 ABSEXCH-10718: Fix to prevent access violations if mouse moved across Notes column titles whilst form closes
          NotesCtrl.UnHookOnMouse;
          NotesCtrl.Free;

        finally

          NotesCtrl:=nil;
        end;
      end;

    Send_UpdateList(0,113);

  end;


end;

procedure TDiaryList.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Action:=caFree;
end;


procedure TDiaryList.NotePageReSize;

Begin
  ADatePanel.Height:=A1ListBtnPanel.Height;

  ADescPanel.Height:=ADatePanel.Height;
  AUserPanel.Height:=ADatePanel.Height;

    If (NotesCtrl<>nil) then {* Adjust list *}
    With NotesCtrl.MULCtrlO,VisiList do
    Begin
      VisiRec:=List[0];

      With (VisiRec^.PanelObj as TSBSPanel) do
          Height:=ADatePanel.Height;

      ReFresh_Buttons;

      RefreshAllCols;

      A1HedPanel.Width:=(IdPanel(MUTotCols,BOff).Left+IdPanel(MUTotCols,BOff).Width);

    end;

  
end;


procedure TDiaryList.SetCaption(CTit  :  Str255);

Begin
  Self.Caption:='Notes for '+CTit;
end;



procedure TDiaryList.FormResize(Sender: TObject);
Var
  n           :  Byte;
  NewVal      :  Integer;


begin

  If (GotCoord) then
  Begin

    NewVal:=ClientWidth-PagePoint[0].X;
    If (NewVal<MinWidth) then
      NewVal:=MinWidth;

    NewVal:=ClientHeight-PagePoint[0].Y;

    If (NewVal<MinHeight) then
      NewVal:=MinHeight;


    A1SBox.Width:=Panel1.Width-PagePoint[1].X;
    A1SBox.Height:=Panel1.Height-PagePoint[1].Y;

    A1BtnPanel.Left:=Panel1.Width-PagePoint[2].X;
    A1BtnPanel.Height:=Panel1.Height-PagePoint[2].Y;

    A1BSBox.Height:=A1BtnPanel.Height-PagePoint[3].X;

    A1ListBtnPanel.Height:=Panel1.Height-PagePoint[4].Y;


    NotePageResize;


    NeedCUpdate:=((StartSize.X<>Width) or (StartSize.Y<>Height));

  end; {If time to update}
end;


procedure TDiaryList.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  GlobFormKeyDown(Sender,Key,Shift,ActiveControl,Handle);
end;

procedure TDiaryList.FormKeyPress(Sender: TObject; var Key: Char);
begin
  GlobFormKeyPress(Sender,Key,ActiveControl,Handle);
end;




procedure TDiaryList.ClsN1BtnClick(Sender: TObject);
begin
  Close;
end;





procedure TDiaryList.AddN1BtnClick(Sender: TObject);

Var
  Mode  :  Byte;

begin
  Mode:=0;

  If (NotesCtrl<>nil) then
  With ExLocal,NotesCtrl do
  Begin
    If (TNKey<> GetFolio) then
    Begin
      RefreshList(TNKey,GetNType);
    end;

    NotesCtrl.AddEditNote((Sender=EditN1Btn),(Sender=InsN1Btn));
   end;
end;




procedure TDiaryList.DelN1BtnClick(Sender: TObject);
begin
  If (NotesCtrl<>nil) then
    NotesCtrl.Delete1Click(Sender);

end;

procedure TDiaryList.SwiN1BtnClick(Sender: TObject);
begin
    If (NotesCtrl<>nil) then
    With NotesCtrl do
    Begin

      SwitchGenMode;

    end;
end;


procedure TDiaryList.ShowRightMeny(X,Y,Mode  :  Integer);

Begin
  With PopUpMenu1 do
  Begin

    N3.Tag:=99;

    PopUp(X,Y);
  end;


end;

procedure TDiaryList.PopupMenu1Popup(Sender: TObject);
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






procedure TDiaryList.PropFlgClick(Sender: TObject);
begin
  {SetFormProperties((N3.Tag=99));}
  N3.Tag:=0;
end;



procedure TDiaryList.StoreCoordFlgClick(Sender: TObject);
begin
  StoreCoord:=Not StoreCoord;

  NeedCUpdate:=BOn;
end;


procedure TDiaryList.SetRecAddr(Fnum  : SmallInt);

Begin
  Status:=GetPos(F[Fnum],Fnum,ThisRecAddr);
end;


procedure TDiaryList.GetRecFAddr(Fnum,Keypath  : SmallInt);

Begin

  SetDataRecOfs(Fnum,ThisRecAddr);


  GetDirect(F[Fnum],Fnum,RecPtr[Fnum]^,Keypath,0); {* Re-Establish Position *}

end;


procedure TDiaryList.Display_AccRec;

Var
  DC  :  TFCustDisplay;
Begin
  If (DispCust=nil) then
  Begin
    DC:=TFCustDisplay.Create(Self);
    DispCust:=DC;
  end
  else
    DC:=DispCust;

  try

    With DC do
      //Display_Account(IsACust(Cust.CustSupp),50,Inv);
      //SSK 02/02/2018 2018 R1 ABSEXCH-19696: this will display associated Trader Record when accessed from Workflow Diary
      Display_Trader(IsACust(Cust.CustSupp),0,Inv);

  except

    DC.Free;
    DispCust:=nil;

  end;

end; {Proc..}


procedure TDiaryList.Display_TransRec;

Var
  DC  :  TFInvDisplay;
Begin
  If (DispDoc=nil) then
  Begin
    DC:=TFInvDisplay.Create(Self);
    DispDoc:=DC;
  end
  else
    DC:=DispDoc;

  try

    With DC do
    Begin
      LastDocHed:=Inv.InvDocHed;

      Display_Trans(0,Inv.FolioNum,BOff,BOff);
    end;

  except

    DC.Free;
    DispDoc:=nil;

  end;

end; {Proc..}



{$IFDEF STK}

  procedure TDiaryList.Display_StockRec;

  Var
    DC  :  TFStkDisplay;

  Begin
    If (DispStk=nil) then
    Begin
      DC:=TFStkDisplay.Create(Self);
      DispStk:=DC;
    end
    else
      DC:=DispStk;

    try

      With DC do
      Begin
        Display_Account(0);
      end;

    except

      DC.Free;
      DispStk:=nil;

    end;

  end; {Proc..}


{$ENDIF}


{$IFDEF JC}

  procedure TDiaryList.Display_JobRec;

  Var
    DC  :  TFJobDisplay;

  Begin
    If (DispJob=nil) then
    Begin
      DC:=TFJobDisplay.Create(Self);
      DispJob:=DC;
    end
    else
      DC:=DispJob;

    try

      With DC do
      Begin
        Display_Account(0,JobRec^.JobCode,'',0,0,BOff,nil);
      end;

    except

      DC.Free;
      DispJob:=nil;

    end;

  end; {Proc..}


  procedure TDiaryList.Display_EmpRec;

  Var
    DC  :  TFJobDisplay;

  Begin
    If (DispEmp=nil) then
    Begin
      DC:=TFJobDisplay.Create(Self);
      DispEmp:=DC;
    end
    else
      DC:=DispEmp;

    try

      With DC do
      Begin
        Display_Employee(2,BOn);
      end;

    except

      DC.Free;
      DispEmp:=nil;

    end;

  end; {Proc..}



{$ENDIF}


Procedure TDiaryList.DisplayRecord(LMode  :  Integer;
                                   NC     :  Char;
                                   NK     :  Str10);


Var
  NT  :  Byte;

  TmpFn
      :  Integer;
  CS  :  Boolean;


Begin
  NT:=GetNoteType(NC);

  If (Not (NT In [0,4,5,11])) then
  Begin
    LinkFNote(NC,NK);

    {$B-}
    Case NT of
      1    :  If ((Assigned(DispCust)) or (LMode=0)) and
              ((Allowed_In(IsACust(Cust.CustSupp),34)) or (Allowed_In(Not IsACust(Cust.CustSupp),44))) then

                Display_AccRec;

      2    :  With Inv do
               If ((Assigned(DispDoc)) or (LMode=0)) and
                  ((Allowed_In(InvDocHed In (SalesSplit-OrderSet),05)) or
                  (Allowed_In(InvDocHed In (PurchSplit-OrderSet),14)) or
                  (Allowed_In(InvDocHed In NomSplit,26)) or
                  (Allowed_In(InvDocHed In (OrderSet-PurchSplit),158)) or
                  (Allowed_In(InvDocHed In (OrderSet-SalesSplit),168)) or
                  (Allowed_In(InvDocHed In (TSTSplit),217)) or
                  (Allowed_In(InvDocHed In (WOPSplit),378)) or
                  (Allowed_In(InvDocHed In (JAPSalesSplit),446)) or
                  (Allowed_In(InvDocHed In (JAPPurchSplit),437)) or
                  (Allowed_In(InvDocHed In (StkAdjSplit),118))) then
                    Display_TransRec;

      {$IFDEF STK}
        3    :  If ((Assigned(DispStk)) or (LMode=0)) and
                    (Allowed_In(BOn,469)) then
                  Display_StockRec;

      {$ENDIF}


      {$IFDEF JC}
        8  :    If ((Assigned(DispJob)) or (LMode=0)) and
                    (Allowed_In(JBCostOn,206)) then
                  Display_JobRec;

        10  :    If ((Assigned(DispEmp)) or (LMode=0)) {and
                  (Allowed_In(JBCostOn,206))} then
                Display_EmpRec;

      {$ENDIF}


      else      Begin
                  Set_BackThreadMVisible(BOn);

                  ShowMessage('The source record for that type of note is not available.');

                  Set_BackThreadMVisible(BOff);
                end;
    end; {Case..}

  {$B+}

  end;

end;




{ =============== Create Global Diary ============== }


Procedure Create_Diary(     AOwner :  TWinControl;
                       Var  Diary  :  TDiaryList;
                            Opt    :  Byte);


Var
  WasNew  :  Boolean;

Begin
  WasNew:=Not Assigned(Diary);

  Set_NFormMode(NoteTCode,#2,Opt,0);

  If (WasNew) then
  Begin
    Diary:=TDiaryList.Create(AOwner);


  end;


  try
    With Diary do
    Begin
        SetCaption('Workflow Diary');

      If (WasNew) then
        Show
      else
        ShowLink(BOff,BOff);

    end;
  except
    Diary.Free;
    Diary:=nil;

  end;
end;


{* function to check for expired diaries *}

Function Check_Diary(MatchDate  :  LongDate)  :  Boolean;


Const
  Fnum       =  PWrdF;
  Keypath    =  HelpNdxK;

    DLoop      =  9;
                                             //HV 17/05/2016 2016-R2 ABSEXCH-17357: Added condition to display diary having workflow diary notes 
    DiaryLoopC :  Array[1..DLoop] of Char = (NoteManualCode,NoteCCode,NoteDCode,NoteSCode,NoteRCode,NoteLCode,NoteDP1Code,NoteDP2Code,NoteECode);

Var
  KeyS,KeyChk  :  Str255;


  FoundOk,
  Abort        :  Boolean;

  n            :  Byte;

  MatchFor     :  Str10;



Begin

  n:=1;

  Repeat  {* Scan each diary type, as they will be sorted differently *}

    FoundOk:=BOff; Abort:=BOff;

    KeyChk:=NoteTCode+DiaryLoopC[n];
    KeyS:=KeyChk;

    Status:=Find_Rec(B_GetGEq,F[Fnum],Fnum,RecPtr[Fnum]^,Keypath,KeyS);

    While (StatusOk) and (CheckKey(KeyChk,KeyS,Length(KeyChk),BOn)) and (Not FoundOk) and (Not Abort) do
    With Password.NotesRec do
    Begin

      MatchFor:=Strip('R',[#32],NoteFor);

      FoundOk:=((NoteAlarm<=MatchDate) and (NoteAlarm>=FirstDDate)
               and ((CheckKey(MatchFor,EntryRec^.Login,Length(MatchFor),BOff)) or (Not Syss.UsePassWords)));

      Abort:=(NoteAlarm>MatchDate);

      If (Not FoundOk) and (Not Abort) then
        Status:=Find_Rec(B_GetNext,F[Fnum],Fnum,RecPtr[Fnum]^,Keypath,KeyS);

    end; {While..}

    Inc(n);

  Until (FoundOk) or (n>DLoop);


  Check_Diary:=FoundOk;

end; {Func..}


procedure TDiaryList.ViewN1BtnClick(Sender: TObject);
begin
  {$B-}
  If (Assigned(NotesCtrl.MULCtrlO)) and (NotesCtrl.MulCtrlO.ValidLine) then
  With Password,NotesRec do
    DisplayRecord(0,SubType,ExtNoteKey(NoteNo));

  {$B+}
end;



procedure TDiaryList.ClrN1BtnClick(Sender: TObject);
begin
  If (Assigned(NotesCtrl)) then
    NotesCtrl.Clear_Alarm;
end;


Initialization

  NTKey:='';
  NTCode:=#0;
  NTMode:=0;
  NLC:=1;
end.
