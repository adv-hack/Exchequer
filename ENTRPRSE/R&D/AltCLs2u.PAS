unit AltCLs2U;

interface

{$I DEFOVR.Inc}

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  Menus, StdCtrls, ExtCtrls, SBSPanel,
  GlobVar,VARRec2U,VarConst,SBSComp,SBSComp2,ExWrap1U,SupListU,

  {$IFDEF NP}
    DiarLstU,
  {$ENDIF}

  AltCRe2U,

  BTSupU1, ComCtrls;


type


  TACMList  =  Class(TGenList)

    Function SetCheckKey  :  Str255; Override;

    Function SetFilter  :  Str255; Override;

    Function Ok2Del :  Boolean; Override;

    Function OutAltList(Col  :  Byte)  :  Str255;

    Function OutOpoList(Col  :  Byte)  :  Str255;

    Function OutLine(Col  :  Byte)  :  Str255; Override;

  end;


type
  TAltCList = class(TForm)
    CBtnPanel: TSBSPanel;
    CListBtnPanel: TSBSPanel;
    ClsCP1Btn: TButton;
    CCBSBox: TScrollBox;
    AddBtn: TButton;
    EditBtn: TButton;
    DelBtn: TButton;
    PopupMenu1: TPopupMenu;
    Add1: TMenuItem;
    Edit1: TMenuItem;
    Delete1: TMenuItem;
    Notes1: TMenuItem;
    N2: TMenuItem;
    PropFlg: TMenuItem;
    N1: TMenuItem;
    StoreCoordFlg: TMenuItem;
    NteBtn: TButton;
    FindDb1Btn: TButton;
    UCP1Btn: TButton;
    Find1: TMenuItem;
    Use1: TMenuItem;
    DPageCtrl1: TPageControl;
    Altpage: TTabSheet;
    EquivPage: TTabSheet;
    SuperCPage: TTabSheet;
    OppoPage: TTabSheet;
    CSBox: TScrollBox;
    CCPanel: TSBSPanel;
    PricPanel: TSBSPanel;
    CHedPanel: TSBSPanel;
    DescLab: TSBSPanel;
    CCLab: TSBSPanel;
    PricLab: TSBSPanel;
    DescPanel: TSBSPanel;
    procedure FormCreate(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormDestroy(Sender: TObject);
    procedure FormResize(Sender: TObject);
    procedure PopupMenu1Popup(Sender: TObject);
    procedure ClsCP1BtnClick(Sender: TObject);
    procedure PropFlgClick(Sender: TObject);
    procedure StoreCoordFlgClick(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure CCPanelMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure CCLabMouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure CCLabMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure AddBtnClick(Sender: TObject);
    procedure NteBtnClick(Sender: TObject);
    procedure FindDb1BtnClick(Sender: TObject);
    procedure UseBtn1Click(Sender: TObject);
    procedure DPageCtrl1Change(Sender: TObject);
  private
    { Private declarations }
    BeenIn,
    JustCreated,
    ListActive,
    StoreCoord,
    LastCoord,
    SetDefault,
    fNeedCUpdate,
    fDoingClose,
    GotCoord,
    CanDelete    :  Boolean;



    PagePoint    :  Array[0..4] of TPoint;

    StartSize,
    InitSize     :  TPoint;

    ACARec       :  TAltSCRec;

    {$IFDEF NP}
      NoteCtrl   :  TDiaryList;
    {$ENDIF}

    procedure Find_FormCoord;

    procedure Store_FormCoord(UpMode  :  Boolean);

    procedure FormSetOfSet;

    Procedure WMCustGetRec(Var Message  :  TMessage); Message WM_CustGetRec;

    Procedure WMGetMinMaxInfo(Var Message  :  TWMGetMinMaxInfo); Message WM_GetMinMaxInfo;

    Procedure WMSysCommand(Var Message  :  TMessage); Message WM_SysCommand;

    Procedure Send_UpdateList(Mode   :  Integer);

    procedure ShowRightMeny(X,Y,Mode  :  Integer);

    procedure Display_Rec(Mode  :  Byte);

    Procedure  SetNeedCUpdate(B  :  Boolean);

    Property NeedCUpDate :  Boolean Read fNeedCUpDate Write SetNeedCUpdate;


    procedure Get_Notes;


    {$IFDEF NP}
      Procedure NoteUpdate(NewLineNo  :  LongInt);
    {$ENDIF}

    Procedure FindStkCode;

    Function CheckListFinished  :  Boolean;

  public
    { Public declarations }

    RecMode      :  Byte;
    RecFolio     :  LongInt;
    RecSupp      :  Str10;

    ExLocal      :  TdExLocal;

    ListOfSet    :  Integer;

    MULCtrlO     :  Array[0..3] of TACMList;


    procedure FormDesign;

    procedure RefreshList(ShowLines,
                          IgMsg      :  Boolean);

    procedure FormBuildList(ShowLines  :  Boolean);


    procedure HidePanels(PageNo  :  Byte);

    Function Current_Page  :  Integer;

    Procedure SetPageHelp(NewIndex  :  Integer);

    procedure Page1Create(Sender   : TObject;
                          NewPage  : Byte);

    procedure SetFormProperties;

    procedure SetCaption;

  end;

Procedure Set_ACFormMode(State  :  Byte;
                         Folio  :  LongInt;
                         SCode  :  Str10);

Procedure DeletesdbLinks (Code  :  AnyStr;
                          Fnum  :  Integer;
                          KeyPth:  Integer);

Function Link_sdbStk(lc  :  LongInt;
                 Var TSL :  sdbStkType)  :  Boolean;

Procedure Stock_sdbSubst(Var StockR  :  StockRec;
                             Lc      :  LongInt);

Procedure LinksdbStk(SFolio  :  LongInt;
                     SMode   :  Byte);

Procedure Shadow_StkRec(StockR  : StockRec);


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
  {InvListU,}

  {$IFDEF DBD}
    DebugU,
  {$ENDIF}

  {$IFDEF C_On}
    NoteSupU,
  {$ENDIF}

  SysU1,
  SysU2,

  {$IFNDEF EXDLL}
  ExThrd2U,
  {$ELSE}
  InvListU,
  {$ENDIF}

  SalTxl1U;

{$R *.DFM}




Var
  ACFormMode  :  Byte;
  ACFormFolio :  LongInt;
  ACFormSupp  :  Str10;



{ ========= Exported function to set View type b4 form is created ========= }

Procedure Set_ACFormMode(State  :  Byte;
                         Folio  :  LongInt;
                         SCode  :  Str10);

Begin

  ACFormMode:=State;
  ACFormFolio:=Folio;
  ACFormSupp:=SCode;

end;



{$I ACTI1.PAS}





Procedure  TAltCList.SetNeedCUpdate(B  :  Boolean);

Begin
  If (Not fNeedCUpdate) then
    fNeedCUpdate:=B;
end;

procedure TAltCList.Find_FormCoord;


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

    PrimeKey:='S';

    If (GetbtControlCsm(ThisForm)) then
    Begin
      {StoreCoord:=(ColOrd=1); v4.40. To avoid on going corruption, this is reset each time its loaded}
      StoreCoord:=BOff;
      HasCoord:=(HLite=1);
      LastCoord:=HasCoord;

      If (HasCoord) then {* Go get postion, as would not have been set initianly *}
        SetPosition(ThisForm);

    end;

    GetbtControlCsm(CSBox);

    GetbtControlCsm(CListBtnPanel);

    GetbtControlCsm(CBtnPanel);

    MULCtrlO[0].Find_ListCoord(GlobComp);

  end; {With GlobComp..}


  Dispose(GlobComp,Destroy);

    {NeedCUpdate}
  StartSize.X:=Width; StartSize.Y:=Height;

end;


procedure TAltCList.Store_FormCoord(UpMode  :  Boolean);


Var
  GlobComp:  TGlobCompRec;


Begin

  New(GlobComp,Create(BOff));

  With GlobComp^ do
  Begin
    GetValues:=UpMode;

    PrimeKey:='S';

    ColOrd:=Ord(StoreCoord);

    HLite:=Ord(LastCoord);

    SaveCoord:=StoreCoord;

    If (Not LastCoord) then {* Attempt to store last coord *}
      HLite:=ColOrd;

    StorebtControlCsm(Self);

    StorebtControlCsm(CBtnPanel);

    StorebtControlCsm(CSBox);

    StorebtControlCsm(CListBtnPanel);

    MULCtrlO[0].Store_ListCoord(GlobComp);

  end; {With GlobComp..}

  Dispose(GlobComp,Destroy);
end;



procedure TAltCList.FormSetOfSet;

Begin
  PagePoint[0].X:=ClientWidth-(CBtnPanel.Left);
  PagePoint[0].Y:=ClientHeight-(CBtnPanel.Height);

  PagePoint[1].X:=ClientWidth-(DPageCtrl1.Width);
  PagePoint[1].Y:=ClientHeight-(DPageCtrl1.Height);

  PagePoint[2].X:=DPageCtrl1.Width-(CSBox.Width);
  PagePoint[2].Y:=DPageCtrl1.Height-(CSBox.Height);

  PagePoint[3].X:=CBtnPanel.Height-(CCBSBox.Height);
  PagePoint[3].Y:=CSBox.ClientHeight-(CCPanel.Height);

  PagePoint[4].Y:=CBtnPanel.Height-(CListBtnPanel.Height);

  GotCoord:=BOn;

end;



Procedure TAltCList.WMCustGetRec(Var Message  :  TMessage);



Begin


  With Message do
  Begin

    {If (Debug) then
      DebugForm.Add('Mesage Flg'+IntToStr(WParam));}

    Case WParam of
      0,169
         :  Begin
              If (WParam=169) then
                MULCtrlO[Current_Page].GetSelRec(BOff);

              AddBtnClick(Edit1);

            end;

      {$IFDEF NP}

       1  :  Begin
               If (Assigned(NoteCtrl)) then
               With NoteCtrl, MLocCtrl^.sdbStkRec do
               Begin
                 TNKey:=FullNCode(FullNomKey(sdFolio));
                 SetCaption(dbFormatName(sdCode1,sdDesc));
                 ShowLink(BOff,BOff);
               end;


             end;

      {$ENDIF}


      2  :  ShowRightMeny(LParamLo,LParamHi,1);

      25 :  NeedCUpdate:=BOn;

      116
          :  Begin
               With MULCtrlO[Current_Page] do
               Begin
                 AddNewRow(MUListBoxes[0].Row,(LParam=1));
               end;
            end;

      117 :  With MULCtrlO[Current_Page] do
             Begin
               If (MUListBox1.Row<>0) then
                 PageUpDn(0,BOn)
                else
                  InitPage;
             end;


      202:  ACARec:=nil;

      {$IFDEF NP}
        213  :  NoteCtrl:=nil;

        250  :  NoteUpdate(LParam);

      {$ENDIF}


    end; {Case..}

  end;
  Inherited;
end;


{ == Procedure to Send Message to Get Record == }

Procedure TAltCList.Send_UpdateList(Mode   :  Integer);

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


Procedure TAltCList.WMGetMinMaxInfo(Var Message  :  TWMGetMinMaxInfo);

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


Procedure TAltCList.WMSysCommand(Var Message  :  TMessage);


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



procedure TAltCList.FormDesign;


begin
  UCP1Btn.Visible:=(RecMode In [2,3]);

  If (Not UCP1Btn.Visible) then
    NteBtn.Top:=UCP1Btn.Top;

  Use1.Visible:=UCP1Btn.Visible;

  EquivPage.TabVisible:=FullStkSysOn;
  SuperCPage.TabVisible:=EquivPage.TabVisible;
  SuperCPage.TabVisible:=EquivPage.TabVisible;
  OppoPage.TabVisible:=EquivPage.TabVisible;
end;





procedure TAltCList.RefreshList(ShowLines,
                               IgMsg      :  Boolean);

Var
  KeyStart    :  Str255;
  LKeypath,
  LKeyLen     :  Integer;

Begin

  KeyStart:=PartCCKey(NoteTCode,AltSPFix[Current_Page])+FullNomKey(RecFolio);
  LKeyLen:=Length(KeyStart);

  With MULCtrlO[Current_Page] do
  Begin
    IgnoreMsg:=IgMsg;

    StartList(MLocF,MLSecK,KeyStart,'','',LKeyLen,(Not ShowLines));

    IgnoreMsg:=BOff;
  end;

  
end;


procedure TAltCList.FormBuildList(ShowLines  :  Boolean);

Var
  StartPanel  :  TSBSPanel;
  n           :  Byte;



Begin
  StartPanel := nil; //PR: 22/03/2016 v2016 R2 ABSEXCH-17390
  MULCtrlO[0]:=TACMList.Create(Self);


  Try

    With MULCtrlO[0] do
    Begin


      Try

        With VisiList do
        Begin
          AddVisiRec(CCPanel,CCLab);
          AddVisiRec(DescPanel,DescLab);
          AddVisiRec(PricPanel,PricLab);

          VisiRec:=List[0];

          StartPanel:=(VisiRec^.PanelObj as TSBSPanel);

          {HidePanels(0);}

          LabHedPanel:=CHedPanel;

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
      MUTotCols:=2;
      Font:=StartPanel.Font;

      LinkOtherDisp:=BOn;
      {ChooseXCol:=BOn;}

      WM_ListGetRec:=WM_CustGetRec;


      Parent:=StartPanel.Parent;

      MessHandle:=Self.Handle;

      For n:=0 to MUTotCols do
      With ColAppear^[n] do
      Begin
        AltDefault:=BOn;

        If (n=2) then
        Begin
          DispFormat:=SGFloat;
          NoDecPlaces:=Syss.NoCosDec;
        end;
      end;


      ListLocal:=@ExLocal;

      ListCreate;

      UseSet4End:=BOff;

      NoUpCaseCheck:=BOn;

      HighLiteStyle[1]:=[fsBold];

      Set_Buttons(CListBtnPanel);

      ReFreshList(ShowLines,BOff);

    end {With}


  Except

    MULCtrlO[0].Free;
    MULCtrlO[0]:=Nil;
  end;



  FormSetOfSet;

  FormReSize(Self);

  RefreshList(BOn,BOn);

end;


procedure TAltCList.HidePanels(PageNo  :  Byte);


Begin
  With MULCtrlO[PageNo],VisiList do
  Begin

    Case PageNo of
      AltPageNo  :      Begin
                          CCLab.Caption:='A/C Code';
                          DescLab.Caption:='Alternative Code';
                          PricLab.Caption:='Price';

                          With ColAppear^[2] do
                          Begin
                            NoDecPlaces:=Syss.NoCosDec;
                          end;

                        end;
      EquivPageNo,
      SuperPageNo,
      OppoPageNo
                 :      Begin
                          CCLab.Caption:='Stk Code';
                          DescLab.Caption:='Description';
                          PricLab.Caption:='Qty';

                          With ColAppear^[2] do
                          Begin
                            NoDecPlaces:=Syss.NoQtyDec;
                          end;

                        end;

    end; {Case..}
  end;
end;


procedure TAltCList.Page1Create(Sender   : TObject;
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
   CSBox.HorzScrollBar.Position:=0;

   If (Not Assigned(MULCtrlO[NewPage])) then
     MULCtrlO[NewPage]:=MULCtrlO[0];

   HidePanels(NewPage);

   KeyPrime:='';

   With MULCtrlO[NewPage] do
   Begin
     HighLiteStyle[1]:=[fsBold];

     RefreshAllCols;

     KeyStart:=PartCCKey(NoteTCode,AltSPFix[NewPage])+FullNomKey(RecFolio);

     TKeyLen:=Length(KeyStart);

     KeyEnd:=KeyStart;

     {OrigKey:=KeyStart;
     OKLen:=TKeyLen;}

     TKeyPath:=MLSecK;
     TFnum:=MLocF;

     UseSet4End:=BOff;

     NoUpCaseCheck:=BOn;


     DisplayMode:=NewPage;


     StartList(TFnum,TKeyPath,KeyStart,KeyEnd,KeyPrime,TKeyLen,BOff);

   end; {With..}


   MDI_UpdateParentStat;


end;



Function TAltCList.Current_Page  :  Integer;


Begin


  Result:=pcLivePage(DPageCtrl1);

end;

Procedure TAltCList.SetPageHelp(NewIndex  :  Integer);

Begin
  With DPageCtrl1 do
    Case NewIndex of
      AltPageNo  :  ActivePage.HelpContext:=0;
      EquivPageNo:  ActivePage.HelpContext:=0;
      SuperPageNo:  ActivePage.HelpContext:=0;
      OppoPageNo :  ActivePage.HelpContext:=0;
    end; {Case..}


    CBtnPanel.HelpContext:=DPageCtrl1.ActivePage.HelpContext;
end;

procedure TAltCList.DPageCtrl1Change(Sender: TObject);
Var
  NewIndex  :  Integer;
begin

  Begin
    NewIndex:=pcLivePage(DPageCtrl1);

    Page1Create(Sender,NewIndex);

    SetPageHelp(NewIndex);


    CSBox.Parent:=DPageCtrl1.ActivePage;


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

  end;

end;



procedure TAltCList.FormCreate(Sender: TObject);

Var
  n  :  Integer;

begin
  fDoingClose:=BOff;

  ListActive:=BOff;
  
  ExLocal.Create;

  LastCoord:=BOff;

  NeedCUpdate:=BOff;

  JustCreated:=BOn;

  InitSize.Y:=245;
  InitSize.X:=432;

  Self.ClientHeight:=InitSize.Y;
  Self.ClientWidth:=InitSize.X;

  {Height:=244;
  Width:=370;}


  BeenIn:=BOff;

  RecMode:=ACFormMode;
  RecFolio:=ACFormFolio;
  RecSupp:=ACFormSupp;

  For n:=0 to Pred(ComponentCount) do
    If (Components[n] is TScrollBox) then
    With TScrollBox(Components[n]) do
    Begin
      VertScrollBar.Position:=0;
      HorzScrollBar.Position:=0;
    end;

  VertScrollBar.Position:=0;
  HorzScrollBar.Position:=0;

  DPageCtrl1.ActivePage:=AltPage;


  {$IFDEF NP}
    NoteCtrl:=Nil;
  {$ENDIF}

  {CCDepRec:=nil;}
  MDI_SetFormCoord(TForm(Self));

  FormDesign;

  FormBuildList(BOff);

end;



procedure TAltCList.FormDestroy(Sender: TObject);

Var
  n  :  Byte;
begin
  ExLocal.Destroy;

  {$IFDEF NP}
    If (Assigned(NoteCtrl)) then
    Begin
      NoteCtrl.Free;
      NoteCtrl:=nil;
    end;


  {$ENDIF}
end;


Function TAltCList.CheckListFinished  :  Boolean;

Var
  n       :  Byte;
  mbRet   :  Word;
Begin
  Result:=BOn;

  If (Assigned(MULCtrlO[Current_Page])) then
    Result:=Not MULCtrlO[Current_Page].ListStillBusy;

  If (Not Result) then
  Begin
    Set_BackThreadMVisible(BOn);

    mbRet:=MessageDlg('The list is still busy.'+#13+#13+
                      'Do you wish to interrupt the list so that you can exit?',mtConfirmation,[mbYes,mbNo],0);

    If (mBRet=mrYes) then
    Begin
      MULCtrlO[Current_Page].IRQSearch:=BOn;

      ShowMessage('Please wait a few seconds, then try closing again.');
    end;

    Set_BackThreadMVisible(BOff);

  end;
end;

procedure TAltCList.FormCloseQuery(Sender: TObject;
                              var CanClose: Boolean);
Var
  n  : Integer;

begin

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
      Store_FormCoord(Not SetDefault);

    Send_UpdateList(48);
  end;

end;

procedure TAltCList.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  If (Not fDoingClose) then
  Begin
    fDoingClose:=BOn;

    Action:=caFree;

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


procedure TAltCList.FormResize(Sender: TObject);
Var
  n           :  Byte;
  NewVal      :  Integer;


begin

  If (GotCoord) then
  Begin

    CBtnPanel.Left:=ClientWidth-PagePoint[0].X;

    CBtnPanel.Height:=ClientHeight-PagePoint[0].Y;

    DPageCtrl1.Width:=ClientWidth-PagePoint[1].X;
    DPageCtrl1.Height:=ClientHeight-PagePoint[1].Y;


    CSBox.Width:=DPageCtrl1.Width-PagePoint[2].X;
    CSBox.Height:=DPageCtrl1.Height-PagePoint[2].Y;

    CCBSBox.Height:=CBtnPanel.Height-PagePoint[3].X;

    CListBtnPanel.Height:=CBtnPanel.Height-PagePoint[4].Y;

    If (MULCtrlO[0]<>nil) then
    Begin
      LockWindowUpDate(Handle);

      With MULCtrlO[0],VisiList do
      Begin
        VisiRec:=List[0];

        With (VisiRec^.PanelObj as TSBSPanel) do
          Height:=CSBox.ClientHeight-PagePoint[3].Y;

        RefreshAllCols;
      end;

      LockWindowUpDate(0);

      MULCtrlO[0].ReFresh_Buttons;

      // MH 22/01/2010: Moved inside check on whether MULCtrlO[0] is assigned after ASAP Supplies crashed here
      MULCtrlO[0].LinkOtherDisp:=BOn;
    end;{Loop..}

    // MH 22/01/2010: Moved inside check on whether MULCtrlO[0] is assigned after ASAP Supplies crashed here
    //MULCtrlO[0].LinkOtherDisp:=BOn;

    NeedCUpdate:=((StartSize.X<>Width) or (StartSize.Y<>Height));

  end; {If time to update}
end;





procedure TAltCList.SetFormProperties;


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

    With MULCtrlO[0].VisiList do
    Begin
      VisiRec:=List[0];

      TmpPanel[1].Font:=(VisiRec^.PanelObj as TSBSPanel).Font;
      TmpPanel[1].Color:=(VisiRec^.PanelObj as TSBSPanel).Color;

      TmpPanel[2].Font:=(VisiRec^.LabelObj as TSBSPanel).Font;
      TmpPanel[2].Color:=(VisiRec^.LabelObj as TSBSPanel).Color;


      TmpPanel[3].Color:=MULCtrlO[0].ColAppear^[0].HBKColor;
    end;

    TmpPanel[3].Font.Assign(TmpPanel[1].Font);

    TmpPanel[3].Font.Color:=MULCtrlO[0].ColAppear^[0].HTextColor;


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
                1,2  :  MULCtrlO[0].ReColorCol(Font,Color,(n=2));

                3    :  MULCtrlO[0].ReColorBar(Font,Color);
              end; {Case..}

          MULCtrlO[0].VisiList.LabHedPanel.Color:=TmpPanel[2].Color;
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

procedure TAltCList.ShowRightMeny(X,Y,Mode  :  Integer);

Begin
  With PopUpMenu1 do
  Begin

    PopUp(X,Y);
  end;


end;


procedure TAltCList.PopupMenu1Popup(Sender: TObject);

Var
  n  :  Integer;

begin
  StoreCoordFlg.Checked:=StoreCoord;

end;



procedure TAltCList.PropFlgClick(Sender: TObject);
begin
  SetFormProperties;
end;

procedure TAltCList.StoreCoordFlgClick(Sender: TObject);
begin
  StoreCoord:=Not StoreCoord;
  NeedCUpdate:=BOn;
end;


procedure TAltCList.ClsCP1BtnClick(Sender: TObject);
begin
  Close;
end;

procedure TAltCList.CCPanelMouseUp(Sender: TObject; Button: TMouseButton;
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

    BarPos:=CSBox.HorzScrollBar.Position;

    If (PanRsized) then
      MULCtrlO[Current_Page].ResizeAllCols(MULCtrlO[Current_Page].VisiList.FindxHandle(Sender),BarPos);

    MULCtrlO[Current_Page].FinishColMove(BarPos+(ListOfset*Ord(PanRSized)),PanRsized);

    NeedCUpdate:=(MULCtrlO[Current_Page].VisiList.MovingLab or PanRSized);
  end;

end;



procedure TAltCList.CCLabMouseMove(Sender: TObject; Shift: TShiftState; X,
  Y: Integer);
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

procedure TAltCList.CCLabMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
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


procedure TAltCList.Display_Rec(Mode  :  Byte);


Var
  WasNew  :  Boolean;

  Begin
    WasNew:=BOff;

    If (ACARec=nil) then
    Begin
      ACARec:=TAltSCRec.Create(Self);

      WasNew:=BOn;

    end;

    Try


     With ACARec do
     Begin
       ExLocal.AssignFromGlobal(MLocF);
       ExLocal.LStock:=Self.ExLocal.LStock;

       WindowState:=wsNormal;

       If (Mode In [1..3]) then
       Begin

         Case Mode of

           1..2  :   If (Not ExLocal.InAddEdit) then
                       EditLine((Mode=2),Current_Page)
                     else
                       Show;
              3  :  If (Not ExLocal.InAddEdit) then
                       DeleteBOMLine(MLocF,MLSecK);
                     else
                       Show;

         end; {Case..}

       end;



     end; {With..}


    except

     ACARec.Free;
     ACARec:=nil;
    end;

  end;



procedure TAltCList.AddBtnClick(Sender: TObject);
begin
  If (Assigned(MULCtrlO[Current_Page])) then
    With MULCtrlO[Current_Page] do
    Begin
      {$IFDEF NP}
        If (Assigned(NoteCtrl)) then
          NoteCtrl.Close;
      {$ENDIF}


      {$B-}
        If (TComponent(Sender).Tag=1) or (ValidLine) then
      {$B+}
      {GetSelRec(BOff);}
          Display_Rec(TComponent(Sender).Tag);
    end;
end;



procedure TAltCList.SetCaption;

Begin
  With ExLocal,LStock do
    Caption:='Alternative Codes for '+dbFormatName(StockCode,Desc[1]);

end;


procedure TAltCList.FormActivate(Sender: TObject);
begin
  If (Assigned(MULCtrlO[Current_Page]))  then
    MULCtrlO[Current_Page].SetListFocus;

  ListActive:=BOn;
end;


procedure TAltCList.Get_Notes;

Var
  WasNew  :  Boolean;

Begin
  {$IFDEF NP}
    WasNew:=Not Assigned(NoteCtrl);

    With ExLocal,MLocCtrl^.sdbStkRec do
      Set_NFormMode(FullNCode(FullNomKey(sdFolio)),NotesdbCode,1,sdNLineCount);

    If (WasNew) then
    Begin
      NoteCtrl:=TDiaryList.Create(Self);


    end;


    try
      With NoteCtrl do
      Begin
        With MLocCtrl^.sdbStkRec do
          SetCaption(dbFormatName(sdCode1,sdDesc));

        Show;

      end;
    except
      NoteCtrl.Free;
      NoteCtrl:=nil;

    end;
  {$ENDIF}
end;

procedure TAltCList.NteBtnClick(Sender: TObject);
begin
  {$IFDEF NP}

    If (Assigned(MULCtrlO[Current_Page])) then
      If (MULCtrlO[Current_Page].ValidLine) then
        Get_Notes;

  {$ENDIF}
end;


{$IFDEF NP}

  Procedure TAltCList.NoteUpdate(NewLineNo  :  LongInt);


  Const
    Fnum     =  MlocF;
    Keypath  =  MLSuppK;


  Var
    KeyChk,
    KeyS    :  Str255;

    HoldMode:  Byte;

    B_Func  :  Integer;

    LOk,
    Locked,
    TmpBo   :  Boolean;


  Begin
(**** MH 08/10/2008: Commented out because the routine was not finding the correct Alt Stk Code
                     records because either KeyChk or KeyPath is wrong and that was leaving
                     record locks hanging on whatever record the GetGEq did find.

                     Additionally the GetGEq applying the lock is not supported under SQL, and the
                     lock should only be applied once the CheckKey has passed.



    Locked:=BOff;

    KeyChk:=PartCCKey(NoteTCode,NoteCCode)+NoteCtrl.NotesCtrl.GetFolio;

    KeyS:=KeyChk;

    With ExLocal do
    Begin
      LOk:=LGetMultiRec(B_GetGEq,B_MultLock,KeyS,KeyPath,Fnum,BOn,Locked);

      If (LOk) and (Locked) and (CheckKey(KeyChk,KeyS,Length(KeyChk),BOn)) then
      With LMLocCtrl^.sdbStkRec do
      Begin
        LGetRecAddr(Fnum);

        sdNLineCount:=NewLineNo;

        Status:=Put_Rec(F[Fnum],Fnum,LRecPtr[Fnum]^,Keypath);

        Report_BError(Fnum,Status);
        {* Explicitly remove multi lock *}

        UnLockMLock(Fnum,LastRecAddr[Fnum]);
      end;

    end; {With..}
****)
  end; {Func..}

{$ENDIF}



Procedure TAltCList.FindStkCode;


Var
  InpOk,
  FoundOk  :  Boolean;

  SCode    :  String;

  KeyS     :  Str255;


Begin
  FoundOK := False; //PR: 22/03/2016 v2016 R2 ABSEXCH-17390 
  SCode:='';

  Repeat

    InpOk:=InputQuery('Find Alternative Code','Please enter the alternative code you wish to find',SCode);

    KeyS:=UpCaseStr(MulCtrlO[Current_Page].KeyRef+SCode);

    If (InpOk) then
    With MULCtrlO[Current_Page], ExLocal do
      FoundOk:=(Find_Rec(B_GetGEq,F[ScanFilenum],ScanFilenum,LRecPtr[ScanFilenum]^,KeyPath,KeyS)=0);


  Until (FoundOk) or (Not InpOk);

  If (FoundOk) then
  With MULCtrlO[Current_Page] do
  Begin
    Find_OnList(KeyS,Keypath);
  end;


end;




procedure TAltCList.FindDb1BtnClick(Sender: TObject);
begin
  FindStkCode;
end;


procedure TAltCList.UseBtn1Click(Sender: TObject);
begin
  If (MULCtrlO[Current_Page].ValidLine) then
    Send_UpdateList(49);
end;


{ =========== Procedure to Delete all Alt Codes associated with a stock item *}

Procedure DeletesdbLinks (Code  :  AnyStr;
                          Fnum  :  Integer;
                          KeyPth:  Integer);

Var
  n     :  Byte;
  KeyChk,
  KeyS  :  AnyStr;
  Locked:  Boolean;
  KLen  :  Integer;

Begin
  For n:=Low(AltSPfix) to High(AltSPFix) do
  Begin
    KeyS:=PartCCKey(NoteTCode,AltSPfix[n])+Code;
    KeyChk:=KeyS;
    KLen:=Length(KeyS);

    Status:=Find_Rec(B_GetGEq,F[Fnum],Fnum,RecPtr[Fnum]^,Keypth,KeyS);

    While (Status=0) and (CheckKey(KeyChk,KeyS,KLen,BOn)) do
    Begin
      Application.ProcessMessages;

      Ok:=GetMultiRec(B_GetDirect,B_SingLock,KeyS,KeyPth,Fnum,BOn,Locked);

      If (Ok) and (Locked) then
      Begin
        {$IFDEF C_On}

          Delete_Notes(NotesdbCode,FullNCode(FullNomKey(MLocCtrl^.sdbStkRec.sdFolio)));

        {$ENDIF}

        Status:=Delete_Rec(F[Fnum],Fnum,KeyPth);

      end;


      Status:=Find_Rec(B_GetNext,F[Fnum],Fnum,RecPtr[Fnum]^,Keypth,KeyS);


    end;
  end; {Loop..}
end;



  { =========== Proc to return linked stock record ======== }

Function Link_sdbStk(lc  :  LongInt;
                 Var TSL :  sdbStkType)  :  Boolean;

Const
  Fnum      =  MLocF;
  Keypath   =  MLSuppK;

Var
  KeyS,
  KeyChk     :  Str255;

  TmpKPath,
  TmpStat    :  Integer;
  TmpRecAddr :  LongInt;

  TmpMLoc    :  MLocRec;


Begin
  TmpMLoc:=MLocCtrl^;

  Blank(TSL,Sizeof(TSL));

  Result:=BOff;

  KeyChk:=PartCCKey(NoteTCode,NoteCCode)+FullNomKey(lc);

  KeyS:=KeyChk;

  TmpKPath:=GetPosKey;

  Presrv_BTPos(Fnum,TmpKPath,F[Fnum],TmpRecAddr,BOff,BOff);

  TmpStat:=Find_Rec(B_GetGEq,F[Fnum],Fnum,RecPtr[Fnum]^,KeyPath,KeyS);

  If (TmpStat=0) and (CheckKey(KeyChk,KeyS,Length(KeyChk),BOff)) then
  Begin
    Result:=BOn;
    TSL:=MLocCtrl^.sdbStkRec;
  end;

  Presrv_BTPos(Fnum,TmpKPath,F[Fnum],TmpRecAddr,BOn,BOff);

  MLocCtrl^:=TmpMLoc;

end;


{ ==== Procedure to Substitute Stock levels for location levels ==== }

Procedure Stock_sdbStkSubst(Var StockR  :  StockRec;
                                Lc      :  LongInt;
                                Mode    :  Byte);
Var
 TSL     :  sdbStkType;
 n       :  Byte;
 FoundOk :  Boolean;



Begin
 If (lc<>0) and (Not EmptyKey(StockR.StockCode,StkKeyLen)) then
 With StockR,TSL do
 Begin

   FoundOk:=Link_sdbStk(Lc,TSL);


   Case Mode of

     1  :  If (FoundOk) and (sdOverRO) then
           Begin
             ROCurrency:=sdROCurrency;
             ROCPrice:=sdROPrice;
           end;

   end; {Case..}
 end;


end;


{ ==== Procedure to Substitute Stock levels for location levels ==== }

Procedure Stock_sdbSubst(Var StockR  :  StockRec;
                             Lc      :  LongInt);


Begin
 Stock_sdbStkSubst(StockR,Lc,1);

end;

{ ======== Procedure to return Stock Record based on Link ======}

Procedure LinksdbStk(SFolio  :  LongInt;
                     SMode   :  Byte);


Var
  KeyS       :  Str255;
  CDStatus   :  Integer;

Begin
  If (Stock.StockFolio<>SFolio) then
  Begin
    KeyS:=Strip('R',[#0],FullNomKey(SFolio));

    CDStatus:=Find_Rec(B_GetEq,F[StockF],StockF,RecPtr[StockF]^,StkFolioK,KeyS);

    If (CDStatus<>0) then
      ResetRec(StockF);
  end;
end;


{ ========= Procedure to shadow Alt code within Alt db ========== }


  Procedure Shadow_StkRec(StockR  : StockRec);

  Const
    Fnum     =  MLocF;
    Keypath  =  MLK;


  Var
    KeyChk,
    KeyS     :  Str255;

    LOk,
    LLocked,
    FoundOk,
    NewRec   :  Boolean;
    B_Func   :  Integer;

    LAddr    :  LongInt;


  Begin
    With StockR, MLocCtrl^,sdbStkRec do
    Begin
      If (Not EmptyKey(AltCode,StkKeyLen)) then
      Begin

        KeyChk:=PartCCKey(NoteTCode,NoteCCode)+FullStockCode(AltCode);
        KeyS:=KeyChk;

        FoundOk:=BOff; LOk:=BOff; LLocked:=BOff;

        B_Func:=B_GetGEq;

        Repeat

          Status:=Find_Rec(B_Func,F[Fnum],Fnum,RecPtr[Fnum]^,Keypath,KeyS);

          FoundOk:=(StatusOk and (CheckKey(KeyChk,KeyS,Length(KeyChk),BOff)) and (sdStkFolio=StockFolio));

          B_Func:=B_GetNext;

        Until (Not StatusOk) or (FoundOk) or (Not CheckKey(KeyChk,KeyS,Length(KeyS),BOff));

        NewRec:=(Status In [4,9]);

        If (FoundOk) then
        Begin

          LOk:=GetMultiRecAddr(B_GetDirect,B_MultLock,KeyS,KeyPath,Fnum,BOn,LLocked,LAddr);


        end
        else
          If (NewRec) then
          Begin
            LOk:=BOn; LLocked:=BOn;

            ResetRec(Fnum);

            RecPfix:=NoteTCode;

            Subtype:=NoteCCode;

            sdNLineCount:=1;
            sdStkFolio:=StockFolio;

            {$IFDEF MC_On}
              sdROCurrency:=1;
            {$ENDIF}

            sdFolio:=SetNextSFolio(SKF,BOn,1);


            sdCode3:=FullRunNoKey(sdFolio,sdStkFolio);

          end;



        If (LOk) and (LLocked) then
        Begin
          sdCode1:=FullStockCode(AltCode);
          sdCode2:=Full_SupStkKey(sdStkFolio,sdCode1);

          sdSuppCode:=Supplier;
          sdROCurrency:=ROCurrency;
          sdROPrice:=ROCPrice;
          {* Update last edited flag *}

          sdLastUsed:=Today;
          sdLastTime:=TimeNowStr;

          If (NewRec) then
            Status:=Add_Rec(F[Fnum],Fnum,RecPtr[Fnum]^,Keypath)
          else
          Begin
            Status:=Put_Rec(F[Fnum],Fnum,RecPtr[Fnum]^,Keypath);

            Status:=UnLockMultiSing(F[Fnum],Fnum,LAddr);
          end;  

          Report_BError(Fnum,Status);

        end;
      end;

    end;
  end;





Initialization

end.
