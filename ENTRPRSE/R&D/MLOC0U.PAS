unit MLoc0U;

interface

{$I DEFOVR.Inc}

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  Menus, StdCtrls, ExtCtrls, SBSPanel, TEditVal, ComCtrls,
  GlobVar,VarConst,SBSComp,SBSComp2,ExWrap1U,BTSupU1,SupListU,MLocMRIU,InvLst3U,

  {$IFDEF NP}
    DiarLstU,
  {$ENDIF}


  MLocSRIU,
  // SSK 21/05/2018 2018-R1.1 ABSEXCH-20306: Added support for exporting lists
  WindowExport, ExportListIntf, oExcelExport;



Type

TMLMList  =  Class(TGenList)

  Public
    LAutoMLId  :  MLIdOPtr;

    Procedure ExtObjCreate; Override;

    Function SetCheckKey  :  Str255; Override;

    Function SetFilter  :  Str255; Override;

    Function Ok2Del :  Boolean; Override;

    Function CheckRowEmph :  Byte; Override;

    Function OutMLLine(Col  :  Byte)  :  Str255;

    Function OutLSLine(Col  :  Byte)  :  Str255;

    Function OutSLLine(Col  :  Byte)  :  Str255;

    Function OutLine(Col  :  Byte)  :  Str255; Override;

  end;


type
  TLocnList = class(TForm)
    PopupMenu1: TPopupMenu;
    Add1: TMenuItem;
    Edit1: TMenuItem;
    Delete1: TMenuItem;
    Tag1: TMenuItem;
    Clear1: TMenuItem;
    N2: TMenuItem;
    PropFlg: TMenuItem;
    N1: TMenuItem;
    StoreCoordFlg: TMenuItem;
    PageControl1: TPageControl;
    LocPage: TTabSheet;
    SLocPage: TTabSheet;
    CSBox: TScrollBox;
    LoPanel: TSBSPanel;
    DePanel: TSBSPanel;
    CHedPanel: TSBSPanel;
    DeLab: TSBSPanel;
    LoLab: TSBSPanel;
    CBtnPanel: TSBSPanel;
    CListBtnPanel: TSBSPanel;
    ClsCP1Btn: TButton;
    CCBSBox: TScrollBox;
    AddBtn: TButton;
    EditBtn: TButton;
    DelBtn: TButton;
    CS2Box: TScrollBox;
    sloPanel: TSBSPanel;
    sdePanel: TSBSPanel;
    C2HedPanel: TSBSPanel;
    sdeLab: TSBSPanel;
    sloLab: TSBSPanel;
    sISPanel: TSBSPanel;
    SFPanel: TSBSPanel;
    SOPanel: TSBSPanel;
    sISLab: TSBSPanel;
    SFLab: TSBSPanel;
    SOLab: TSBSPanel;
    TagBtn: TButton;
    ClrBtn: TButton;
    MoveBtn: TButton;
    UseBtn: TButton;
    FillBtn: TButton;
    Use1: TMenuItem;
    MoveStock1: TMenuItem;
    Fill1: TMenuItem;
    I1StatLab: Label8;
    NteBtn: TButton;
    Notes1: TMenuItem;
    WindowExport: TWindowExport;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure FormResize(Sender: TObject);
    procedure FormKeyPress(Sender: TObject; var Key: Char);
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure FormActivate(Sender: TObject);
    procedure ClsCP1BtnClick(Sender: TObject);
    procedure LoPanelMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure LoLabMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure LoLabMouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure PopupMenu1Popup(Sender: TObject);
    procedure PropFlgClick(Sender: TObject);
    procedure StoreCoordFlgClick(Sender: TObject);
    procedure AddBtnClick(Sender: TObject);
    procedure PageControl1Change(Sender: TObject);
    procedure PageControl1Changing(Sender: TObject;
      var AllowChange: Boolean);
    procedure UseBtnClick(Sender: TObject);
    procedure FillBtnClick(Sender: TObject);
    procedure MoveBtnClick(Sender: TObject);
    procedure NteBtnClick(Sender: TObject);
    function WindowExportEnableExport: Boolean;
    function WindowExportGetExportDescription: String;
    procedure WindowExportExecuteCommand(const CommandID: Integer;const ProgressHWnd: HWND);

  private
    InHBeen,
    JustCreated,
    StopPageChange,
    StoreCoord,
    LastCoord,
    SetDefault,
    fNeedCUpdate,
    fFrmClosing,
    fDoingClose,
    GotCoord,
    CanDelete    :  Boolean;


    MinHeight,
    MinWidth     :  Integer;

    LastGroup    :  LongInt;

    InvBtnList   :  TVisiBtns;

    PagePoint    :  Array[0..4] of TPoint;

    StartSize,
    InitSize     :  TPoint;

    MLocMRec     :  TMlocMRec;
    MLocSRec     :  TMlocSRec;

    {$IFDEF NP}
      NoteCtrl   :  TDiaryList;
    {$ENDIF}


    procedure Display_Rec(Mode  :  Byte);

    procedure Display_StkRec(Mode  :  Byte);

    procedure Find_Page1Coord(PageNo  :  Integer);

    procedure Store_Page1Coord(UpMode  :  Boolean);

    procedure Find_FormCoord;

    procedure Store_FormCoord(UpMode  :  Boolean);

    procedure FormSetOfSet;

    Procedure WMCustGetRec(Var Message  :  TMessage); Message WM_CustGetRec;

    Procedure WMFormCloseMsg(Var Message  :  TMessage); Message WM_FormCloseMsg;

    Procedure WMGetMinMaxInfo(Var Message  :  TWMGetMinMaxInfo); Message WM_GetMinMaxInfo;

    

    Procedure Send_UpdateList(Mode   :  Integer);

    procedure Page1Create(Sender   : TObject;
                          NewPage  : Byte);

    Procedure Set_DeleteStat;

    procedure ShowRightMeny(X,Y,Mode  :  Integer);

    Procedure  SetNeedCUpdate(B  :  Boolean);

    Property NeedCUpDate :  Boolean Read fNeedCUpDate Write SetNeedCUpdate;


    procedure Get_Notes;

    
    {$IFDEF NP}
      Procedure NoteUpdate(NewLineNo  :  LongInt);
    {$ENDIF}

  public
    { Public declarations }

    ExLocal    :  TdExLocal;

    ListOfSet  :  Integer;

    MLFMode    :  Byte;

    OrigQty,
    QtyReq     :  Double;

    MULCtrlO   :  Array[0..1] of TMLMList;

    
    ExtFlgPtr  :  ^Boolean;

    LSRKey     :  Str255;


    Function SetHelpC(PageNo :  Integer;
                      Pages  :  TIntSet;
                      Help0,
                      Help1  :  LongInt) :  LongInt;

    procedure PrimeButtons;

    procedure BuildDesign;

    procedure BuildMenus;

    procedure FormDesign;

    Function Current_BarPos(PageNo  :  Byte)  :  Integer;

    Procedure OutUsedReq;

    procedure RefreshList(ShowLines,
                          IgMsg      :  Boolean);

    procedure FormBuildList(ShowLines  :  Boolean);

    Function Current_Page  :  Integer;

    procedure SetCaption;

    Procedure ChangePage(NewPage  :  Integer);

    procedure SetFormProperties;

  end;


  Procedure Set_MLFormMode(State  :  Byte);


  Procedure Display_LocUse(AOwner   :  TForm;
                         IdR      :  Idetail;
                         LStk     :  StockRec;
                         LQtyReq  :  Double;
                     Var LAMLId   :  MLIdOPtr);


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
  VarRec2U,
  ComnUnit,
  ComnU2,
  {CurrncyU,}
  InvListU,

  {$IFDEF DBD}
    DebugU,
  {$ENDIF}

  {$IFDEF POST}
    ReValueU,
  {$ENDIF}

  StkROCtl,
  SysU1,
  SysU2,
  MLocUseU;
  
{$R *.DFM}



Var
  MLFormMode  :  Byte;
  TxAutoMLId  :  MLIdOPtr;




{ ========= Exported function to set View type b4 form is created ========= }

Procedure Set_MLFormMode(State  :  Byte);

Begin

  MLFormMode:=State;

end;


{$I MLTI1U.PAS}


Function TLocnList.Current_Page  :  Integer;
Begin

  Result:=pcLivePage(PAgeControl1);

end;



procedure TLocnList.Find_Page1Coord(PageNo  :  Integer);


Var

  n       :  Integer;

  GlobComp:  TGlobCompRec;


Begin

  If (MULCtrlO[PageNo]<>nil) then
  With MULCtrlO[PageNo] do
  Begin

    New(GlobComp,Create(BOn));

    With GlobComp^ do
    Begin
      GetValues:=BOn;

      PrimeKey:='M';

      HasCoord:=LastCoord;


      Find_ListCoord(GlobComp);

    end; {With GlobComp..}


    Dispose(GlobComp,Destroy);

  end;
end;


procedure TLocnList.Store_Page1Coord(UpMode  :  Boolean);


Var
  n       :  Byte;
  GlobComp:  TGlobCompRec;


Begin

  New(GlobComp,Create(BOff));

  With GlobComp^ do
  Begin

    GetValues:=UpMode;

    SaveCoord:=StoreCoord;

    PrimeKey:='M';

    For n:=1 to High(MULCtrlO) do
    If (MULCtrlO[n]<>nil) then
      MULCtrlO[n].Store_ListCoord(GlobComp);

  end; {With GlobComp..}

  Dispose(GlobComp,Destroy);
end;


Procedure  TLocnList.SetNeedCUpdate(B  :  Boolean);

Begin
  If (Not fNeedCUpdate) then
    fNeedCUpdate:=B;
end;

procedure TLocnList.Find_FormCoord;


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

    GetbtControlCsm(PageControl1);

    GetbtControlCsm(CSBox);

    GetbtControlCsm(CCBSBox);

    GetbtControlCsm(CBtnPanel);

    GetbtControlCsm(CListBtnPanel);

    GetbtControlCsm(CHedPanel);

    MULCtrlO[0].Find_ListCoord(GlobComp);

  end; {With GlobComp..}

  With MULCtrlO[0].VisiList do
    LabHedPanel.Color:=IdPanel(0,BOn).Color;

  Dispose(GlobComp,Destroy);

  StartSize.X:=Width; StartSize.Y:=Height;

end;


procedure TLocnList.Store_FormCoord(UpMode  :  Boolean);


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

    StorebtControlCsm(PageControl1);

    StorebtControlCsm(CSBox);

    StorebtControlCsm(CCBSBox);

    StorebtControlCsm(CBtnPanel);

    StorebtControlCsm(CListBtnPanel);

    StorebtControlCsm(CHedPanel);

    MULCtrlO[0].Store_ListCoord(GlobComp);

  end; {With GlobComp..}

  Dispose(GlobComp,Destroy);

  Store_Page1Coord(UpMode);
end;


procedure TLocnList.FormSetOfSet;

Begin
  PagePoint[0].X:=HorzScrollBar.Range-(PageControl1.Width);
  PagePoint[0].Y:=ClientHeight-(PageControl1.Height);

  PagePoint[1].X:=PageControl1.Width-(CSBox.Width);
  PagePoint[1].Y:=PageControl1.Height-(CSBox.Height);

  PagePoint[2].X:=PageControl1.Width-(CBtnPanel.Left);
  PagePoint[2].Y:=PageControl1.Height-(CBtnPanel.Height);

  PagePoint[3].X:=CBtnPanel.Height-(CCBSBox.Height);
  PagePoint[3].Y:=CSBox.Height-(loPanel.Height);

  PagePoint[4].X:=PageControl1.Width-(CListBtnPanel.Left);
  PagePoint[4].Y:=PageControl1.Height-(CListBtnPanel.Height);

  GotCoord:=BOn;

end;


Procedure TLocnList.Set_DeleteStat;
Begin
  If (Assigned(MULCtrlO[Current_Page])) then
    DelBtn.Enabled:=MULCtrlO[Current_Page].Ok2Del;

end;


Procedure TLocnList.WMCustGetRec(Var Message  :  TMessage);
Begin


  With Message do
  Begin

    {If (Debug) then
      DebugForm.Add('Mesage Flg'+IntToStr(WParam));}

    Case WParam of
      0,169
         :  Begin
              If (WParam=169) then {* Treat as 0 *}
              Begin
                MULCtrlO[Current_Page].GetSelRec(BOff);
                WParam:=0;
              end;

              If (MLFMode<>3) then
                AddBtnClick(Edit1)
              else
                UseBtnClick(Nil);

            end;


      {$IFDEF NP}

       1  :  Begin
               If (Assigned(NoteCtrl)) then
               With NoteCtrl,MLocCtrl^,MLocLoc do
               Begin
                 TNKey:=FullNCode(loCode);
                 SetCaption('Loc : '+dbFormatName(loCode,loName));
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


      175
         :  With PageControl1 do
              ChangePage(FindNextPage(ActivePage,(LParam=0),BOn).PageIndex);

      202:  MLocMRec:=nil;
      203:  MLocSRec:=nil;

      {$IFDEF NP}
        213  :  NoteCtrl:=nil;

        250  :  NoteUpdate(LParam);

      {$ENDIF}



    end; {Case..}


    If (WParam In [1,2]) then
      Set_DeleteStat;
  end;
  Inherited;
end;


Procedure TLocnList.WMFormCloseMsg(Var Message  :  TMessage);


Begin

  With Message do
  Begin

    Case WParam of

      0  :  ;

    end; {Case..}

  end;

  Inherited;
end;


Procedure TLocnList.WMGetMinMaxInfo(Var Message  :  TWMGetMinMaxInfo);

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

Procedure TLocnList.Send_UpdateList(Mode   :  Integer);

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




procedure TLocnList.SetCaption;


Begin

  Case MLFMode of
    1  :  Caption:='Location Master Records';
    else  With ExLocal,LStock do
            Caption:='Stock Location Records for '+dbFormatName(StockCode,Desc[1]);
  end; {case..}

end;



Function TLocnList.SetHelpC(PageNo :  Integer;
                            Pages  :  TIntSet;
                            Help0,
                            Help1  :  LongInt) :  LongInt;

Begin
  Result := Help0;
  If (PageNo In Pages) then
  Begin
    Case PageNo of
      0  :  Result:=Help0;
      1  :  Result:=Help1;
    end; {Case..}
  end
  else
    Result:=-1;

end;



procedure TLocnList.PrimeButtons;

Var
  n,
  PageNo  :  Integer;

Begin
  PageNo:=Current_Page;

  If (InvBtnList=nil) then
  Begin
    InvBtnList:=TVisiBtns.Create;

    try

      With InvBtnList do
      Begin
   {00} AddVisiRec(AddBtn,(PageNo=1));
   {01} AddVisiRec(EditBtn,BOff);
   {02} AddVisiRec(DelBtn,BOff);
   {03} AddVisiRec(UseBtn,(MLFMode<>3));
   {04} AddVisiRec(FillBtn,(MLFMode<>21));
   {05} AddVisiRec(MoveBtn,(PageNo<>0) or (Not Syss.UseMLoc) or (Not SBSIn));
   {06} AddVisiRec(TagBtn,{(PageNo<>0)}BOn);
   {07} AddVisiRec(ClrBtn,{(PageNo<>0)}BOn);
   {08} AddVisiRec(NteBtn,(PageNo<>0));
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
      SetBtnHelp(1,SetHelpC(PageNo,[0..1],509,513));

      SetHideBtn(2,(MLFMode=3),BOff);
      SetBtnHelp(2,SetHelpC(PageNo,[0..1],510,514));

      SetHideBtn(3,(MLFMode<>3),BOff);
      SetHideBtn(4,(MLFMode<>21),BOff);
      SetHideBtn(5,(PageNo<>0) or (Not Syss.UseMLoc) or (Not SBSIn),BOn);
      {SetHideBtn(6,(PageNo<>0),BOff);
      SetHideBtn(7,(PageNo<>0),BOn);}

    end;

  except
    InvBtnList.Free;
    InvBtnList:=nil;
  end; {try..}

end;

procedure TLocnList.BuildDesign;


begin

  {* Set Version Specific Info *}
  SLocPage.TabVisible:=(MLFMode<>1);
  LocPage.TabVisible:=(MLFMode=1);
  

  If (MLFMode=3) then
  Begin
    sISLab.Caption:='Free';
    SFLab.Caption:='Used';
  end;
end;




procedure TLocnList.BuildMenus;

Begin
end;

procedure TLocnList.FormDesign;


begin

  PrimeButtons;

  BuildDesign;

  BuildMenus;

end;

Function TLocnList.Current_BarPos(PageNo  :  Byte)  :  Integer;

Begin
  Case PageNo of
      0
         :  Result:=CSBox.HorzScrollBar.Position;
      1
         :  Result:=CS2Box.HorzScrollBar.Position;

      else  Result:=0;
    end; {Case..}

end;

procedure TLocnList.RefreshList(ShowLines,
                                IgMsg      :  Boolean);

Var
  KeyStart    :  Str255;
  LKeypath,
  LKeyLen     :  Integer;

Begin

  KeyStart:=PartCCKey(CostCCode,CSubCode[(MLFMode<>21)])+LSRKey;
  LKeyLen:=Length(KeyStart);

  If (MLFMode In [3,21]) then
    SetCaption;

  If (Assigned(MULCtrlO[Current_Page])) then
  With MULCtrlO[Current_Page] do
  Begin
    IgnoreMsg:=IgMsg;

    StartList(MLocF,MLK,KeyStart,'','',LKeyLen,(Not ShowLines));

    IgnoreMsg:=BOff;
  end;

end;


procedure TLocnList.FormBuildList(ShowLines  :  Boolean);

Var
  StartPanel  :  TSBSPanel;
  n           :  Byte;



Begin
  MULCtrlO[0]:=TMLMList.Create(Self);
  StartPanel := nil;

  Try

    With MULCtrlO[0] do
    Begin


      Try

        With VisiList do
        Begin
          AddVisiRec(loPanel,loLab);
          AddVisiRec(dePanel,deLab);

          VisiRec:=List[0];

          StartPanel:=(VisiRec^.PanelObj as TSBSPanel);

          {HidePanels(0);}

          LabHedPanel:=CHedPanel;

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
      MUTotCols:=1;
      Font:=StartPanel.Font;

      LinkOtherDisp:=BOn;

      WM_ListGetRec:=WM_CustGetRec;

      DisplayMode:=MLFMode;

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

      NoUpCaseCheck:=BOff;

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

end;


procedure TLocnList.Page1Create(Sender   : TObject;
                                 NewPage  : Byte);

Var
  n           :  Byte;

  StartPanel  :  TSBSPanel;

  KeyStart,
  KeyEnd      :  Str255;

begin

   MULCtrlO[NewPage]:=TMLMList.Create(Self);
   StartPanel := nil;

   Try

     With MULCtrlO[NewPage] do
     Begin

       Try

         With VisiList do
         Begin
           Case NewPage of
             1  :  Begin
                     AddVisiRec(SloPanel,SloLab);
                     AddVisiRec(SdePanel,SdeLab);
                     AddVisiRec(SISPanel,SISLab);
                     AddVisiRec(SFPanel,SFLab);

                     AddVisiRec(SOPanel,SOLab);

                     // SSK 21/05/2018 2018-R1.1 ABSEXCH-20306: Added metadata for Stock at Locations tab
                     ColAppear^[2].ExportMetadata := emtQuantity;     // In Stock
                     ColAppear^[3].ExportMetadata := emtQuantity;     // Free Stock
                     ColAppear^[4].ExportMetadata := emtQuantity;     // On Order
                   end;
           end; {Case..}


           {HidePanels(NewPage);}

           VisiRec:=List[0];

           StartPanel:=(VisiRec^.PanelObj as TSBSPanel);

           LabHedPanel:=C2HedPanel;

         end;
       except
         VisiList.Free;

       end;

       Find_Page1Coord(NewPage);

       Match_VisiList(MULCtrlO[0].VisiList,VisiList);

       TabOrder := -1;
       TabStop:=BOff;
       Visible:=BOff;
       BevelOuter := bvNone;
       ParentColor := False;
       Color:=StartPanel.Color;
       MUTotCols:=4;
       Font:=StartPanel.Font;

       LinkOtherDisp:=Bon;

       DisplayMode:=MLFMode;

       If (DisplayMode=3) then
         Filter[1,1]:=ExLocal.LId.MLocStk; {* Exclude current location *}

       WM_ListGetRec:=WM_CustGetRec;

       
       Parent:=StartPanel.Parent;

       MessHandle:=Self.Handle;

       For n:=0 to MUTotCols do
       With ColAppear^[n] do
       Begin
         AltDefault:=BOn;

         If (n>1) then
         Begin
           DispFormat:=SGFloat;
           NoDecPlaces:=Syss.NoQtyDec;
         end;
       end;

       ListLocal:=@ExLocal;

       ListCreate;

       LAutoMLId:=TxAutoMLId;

       UseSet4End:=BOff;

       NoUpCaseCheck:=BOff;

       Case NewPage of

         1  :  Begin
                 Set_Buttons(CListBtnPanel);

               end;


       end; {Case..}

       With VisiList do
       Begin
         LabHedPanel.Color:=IdPanel(0,BOn).Color;

         SetHedPanel(ListOfSet);
       end;


       RefreshList(BOn,BOn);


     end {With}


   Except

     MULCtrlO[NewPage].Free;
     MULCtrlO[NewPage]:=Nil;
   end;

   MDI_UpdateParentStat;


end;


Procedure TLocnList.ChangePage(NewPage  :  Integer);


Begin

  If (Current_Page<>NewPage) then
  With PageControl1 do
  Begin
    ActivePage:=Pages[NewPage];

    PageControl1Change(PageControl1);
  end; {With..}
end; {Proc..}


procedure TLocnList.PageControl1Changing(Sender: TObject;
  var AllowChange: Boolean);
begin
  AllowChange:=Not StopPageChange;

  If (AllowChange) then
  Begin
    Release_PageHandle(Sender);
  end;
end;

procedure TLocnList.PageControl1Change(Sender: TObject);
Var
  NewIndex  :  Integer;


begin
  If (Sender is TPageControl) then
    With Sender as TPageControl do
    Begin
      NewIndex:=pcLivePage(Sender);

      PrimeButtons;

      Case NewIndex of

        0    :  Self.HelpContext:=501;
        
        1    :  Begin
                  If (MULCtrlO[NewIndex]=nil) then
                    Page1Create(Sender,NewIndex);

                  Self.HelpContext:=500;
                end;


      end; {Case..}


      If (Assigned(MULCtrlO[NewIndex])) then
        MULCtrlO[NewIndex].SetListFocus;

      MDI_UpdateParentStat;

    end; {With..}

end;


procedure TLocnList.FormCreate(Sender: TObject);

Var
  n  :  Integer;

begin
  fFrmClosing:=BOff;
  fDoingClose:=BOff;
  ExLocal.Create;

  MLFMode:=MLFormMode;

  TxAutoMLId:=nil;

  ExtFlgPtr:=nil;

  LastCoord:=BOff;

  JustCreated:=BOn;
  NeedCUpdate:=BOff;

  StopPageChange:=BOff;

  InitSize.Y:=248;
  InitSize.X:=413;

  Self.ClientHeight:=InitSize.Y;
  Self.ClientWidth:=InitSize.X;

  {Height:=381;
  Width:=419;}

  MinHeight:=247;
  MinWidth:=412;

  PageControl1.ActivePage:=LocPage;

  MLocMRec:=nil;
  MLocSRec:=nil;

  For n:=0 to Pred(ComponentCount) do
    If (Components[n] is TScrollBox) then
    With TScrollBox(Components[n]) do
    Begin
      VertScrollBar.Position:=0;
      HorzScrollBar.Position:=0;
    end;

  VertScrollBar.Position:=0;
  HorzScrollBar.Position:=0;

  {$IFDEF NP}
    NoteCtrl:=Nil;
  {$ENDIF}

  SetCaption;

  FormDesign;

  PageControl1.ActivePage:=LocPage;

  FormBuildList((MLFMode=1));

end;


procedure TLocnList.FormActivate(Sender: TObject);
begin
  If (Assigned(MULCtrlO[Current_Page]))  then
    MULCtrlO[Current_Page].SetListFocus;

end;

procedure TLocnList.FormDestroy(Sender: TObject);

Var
  n  :  Byte;
begin
  ExLocal.Destroy;

  If (InvBtnList<>nil) then
    InvBtnList.Free;


  {$IFDEF NP}
    If (Assigned(NoteCtrl)) then
    Begin
      NoteCtrl.Free;
      NoteCtrl:=nil;
    end;


  {$ENDIF}

end;

procedure TLocnList.FormCloseQuery(Sender: TObject;
                              var CanClose: Boolean);
Var
  n  : Integer;

begin
  If (Not fFrmClosing) then
  Begin
    fFrmClosing:=BOn;

    Try
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

        If (NeedCUpdate) then
          Store_FormCoord(Not SetDefault);

        Send_UpdateList(43);

        If (Assigned(ExtFlgPtr)) then
          ExtFlgPtr^:=BOff;

        If (Assigned(TxAutoMLId)) then
          TxAutoMLId^.StoreLocQty(ExLocal.LId,OrigQty,QtyReq,NDxWeight);
      end;
    Finally
      fFrmClosing:=BOff;
    end;
  end
  else
    CanClose:=BOff;
end;


procedure TLocnList.FormClose(Sender: TObject; var Action: TCloseAction);
Var
  n  :  Byte;

begin
  If (Not fDoingClose) then
  Begin
    fDoingClose:=BOn;

    Action:=caFree;

    For n:=Low(MULCtrlO) to High(MULCTrlO) do
      If (MULCtrlO[n]<>nil) then
      Begin
        try
          MULCtrlO[n].Destroy;
        finally
          MULCtrlO[n]:=nil;
        end;
      end;

  end;
end;

procedure TLocnList.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  GlobFormKeyDown(Sender,Key,Shift,ActiveControl,Handle);
end;

procedure TLocnList.FormKeyPress(Sender: TObject; var Key: Char);
begin
  GlobFormKeyPress(Sender,Key,ActiveControl,Handle);
end;

procedure TLocnList.FormResize(Sender: TObject);
Var
  n           :  Byte;
  NewVal      :  Integer;


begin

  If (GotCoord) then
  Begin
    If (Assigned(MULCtrlO[Current_Page])) then
      MULCtrlO[Current_Page].LinkOtherDisp:=BOff;

    Self.HorzScrollBar.Position:=0;
    Self.VertScrollBar.Position:=0;

    NewVal:=ClientWidth-PagePoint[0].X;

    {If (ClientWidth<MinWidth) then {* Use this for invoice type effect
      NewVal:=MinWidth;}

    PageControl1.Width:=NewVal;

    NewVal:=ClientHeight-PagePoint[0].Y;

    PageControl1.Height:=NewVal;


    CSBox.Width:=PageControl1.Width-PagePoint[1].X;
    CSBox.Height:=PageControl1.Height-PagePoint[1].Y;

    CS2Box.Width:=CSBox.Width;
    CS2Box.Height:=CSBox.Height;

    CBtnPanel.Left:=PageControl1.Width-PagePoint[2].X;
    CBtnPanel.Height:=PageControl1.Height-PagePoint[2].Y;

    CCBSBox.Height:=CBtnPanel.Height-PagePoint[3].X;

    {CListBtnPanel.Left:=CSBox.Width+CSBox.Left+3;}
    CListBtnPanel.Height:=PageControl1.Height-PagePoint[4].Y;

    For n:=0 to 1 do
    If (MULCtrlO[n]<>nil) then
    Begin
      With MULCtrlO[n].VisiList do
      Begin
        VisiRec:=List[0];

        With (VisiRec^.PanelObj as TSBSPanel) do
          Height:=CSBox.Height-PagePoint[3].Y;
      end;


      With MULCtrlO[n] do
      Begin
        ReFresh_Buttons;

        RefreshAllCols;
      end;
    end;{Loop..}

    If (Assigned(MULCtrlO[Current_Page])) then
      MULCtrlO[Current_Page].LinkOtherDisp:=BOn;

    NeedCUpdate:=((StartSize.X<>Width) or (StartSize.Y<>Height));

  end; {If time to update}
end;


procedure TLocnList.ClsCP1BtnClick(Sender: TObject);
begin
  Close;
end;


procedure TLocnList.LoPanelMouseUp(Sender: TObject; Button: TMouseButton;
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
      MULCtrlO[Current_Page].ResizeAllCols(MULCtrlO[Current_Page].VisiList.FindxHandle(Sender),BarPos);

    MULCtrlO[Current_Page].FinishColMove(BarPos+(ListOfset*Ord(PanRSized)),PanRsized);

    NeedCUpdate:=(MULCtrlO[Current_Page].VisiList.MovingLab or PanRSized);
  end;

end;




procedure TLocnList.LoLabMouseDown(Sender: TObject; Button: TMouseButton;
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

procedure TLocnList.LoLabMouseMove(Sender: TObject; Shift: TShiftState; X,
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


procedure TLocnList.SetFormProperties;

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
        SetProperties(TmpPanel[1],TmpPanel[2],TmpPanel[3],1,'List Properties',BeenChange,ResetDefaults);

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

procedure TLocnList.ShowRightMeny(X,Y,Mode  :  Integer);

Begin
  With PopUpMenu1 do
  Begin

    PopUp(X,Y);
  end;


end;



procedure TLocnList.PopupMenu1Popup(Sender: TObject);
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

procedure TLocnList.PropFlgClick(Sender: TObject);
begin
  SetFormProperties;
end;

procedure TLocnList.StoreCoordFlgClick(Sender: TObject);
begin
  StoreCoord:=Not StoreCoord;
  NeedCUpdate:=BOn;
end;


procedure TLocnList.Display_Rec(Mode  :  Byte);

Var
  WasNew  :  Boolean;

  Begin
    WasNew:=BOff;


    If (MLocMRec=nil) then
    Begin
      MLocMRec:=TMLocMRec.Create(Self);

      WasNew:=BOn;

    end;

    Try


     With MLocMRec do
     Begin

       ExLocal.AssignFromGlobal(MLocF);

       WindowState:=wsNormal;

       If (Mode In [1..3]) then
       Begin

         Case Mode of

           1..2  :   If (Not ExLocal.InAddEdit) then
                       EditLine((Mode=2))
                     else
                       Show;
              3  :  If (Not ExLocal.InAddEdit) then
                       DeleteBOMLine(MLocF,MLK);
                     else
                       Show;

         end; {Case..}

       end;



     end; {With..}


    except

     MLocMRec.Free;
     MLocMRec:=nil;

    end;

  end;


procedure TLocnList.Display_StkRec(Mode  :  Byte);

Var
  WasNew  :  Boolean;

  Begin
    WasNew:=BOff;


    If (MLocSRec=nil) then
    Begin
      MLocSRec:=TMLocSRec.Create(Self);

      WasNew:=BOn;

    end;

    Try


     With MLocSRec do
     Begin

       ExLocal.AssignFromGlobal(MLocF);
       ExLocal.LStock:=Self.ExLocal.LStock;

       WindowState:=wsNormal;

       If (Mode In [1..3]) then
       Begin

         Case Mode of

           1..2  :   If (Not ExLocal.InAddEdit) then
                       EditLine((Mode=2))
                     else
                       Show;
              3  :  If (Not ExLocal.InAddEdit) then
                       DeleteBOMLine(MLocF,MLK);
                     else
                       Show;

         end; {Case..}

       end;



     end; {With..}


    except

     MLocSRec.Free;
     MLocSRec:=nil;

    end;

  end;


procedure TLocnList.AddBtnClick(Sender: TObject);
begin
  If (Assigned(MULCtrlO[Current_Page])) then
    With MULCtrlO[Current_Page] do
    If (ValidLine) or ((Sender=AddBtn) or (Sender=Add1)) then
    Begin
      {$IFDEF NP}
        If (Assigned(NoteCtrl)) then
          NoteCtrl.Close;
      {$ENDIF}


      GetSelRec(BOff);
      Case Current_Page of
        0  :  Display_Rec(TComponent(Sender).Tag);
        1  :  Display_StkRec(TComponent(Sender).Tag);
      end; {Case..}
    end;
end;


procedure TLocnList.UseBtnClick(Sender: TObject);


Var
  Tc       :  Char;

  Rnum,
  Rnum2    :  Real;

  DedQty,
  FreeQty,
  LastQty  :  Double;
  TStkLoc  :  MStkLocType;

  mrResult :  Word;

  ISCtrl   :  TMLUseI;


Begin
  LastQty:=QtyReq;

  DedQty:=0;

  If (Assigned(MULCtrlO[Current_Page])) then
  With MULCtrlO[Current_Page] do
  If (ValidLine) then
  Begin
    GetSelRec(BOff);

    With MLocCtrl^,MLocLoc,TStkLoc,ExLocal do
    Begin

      If (Assigned(TxAutoMLId)) then
      Begin
        LastQty:=TxAutoMLId^.FindLQty(LId,loCode);

        DedQty:=LastQty;
      end
      else
      Begin
        New(TxAutoMLId,Init);
        
        LastQty:=0;
        
        LAutoMLId:=TxAutoMLId;

      end;

      LinkMLoc_Stock(loCode,LId.StockCode,TStkLoc);

      FreeQty:=FreeMLocStock(TStkLoc);

      If (LastQty=0) and (QtyReq<>0) then {* Keep suggesting last qty *}
      Begin
        LastQty:=QtyReq;


        If (LastQty>FreeQty) then
        Begin
          LastQty:=FreeQty;
        end;

        If (LastQty<0) then
          LastQty:=0;
      end;


      With TxAutoMLId^ do
      Begin
        ISCtrl:=TMLUseI.Create(Self);

        try

          With ISCtrl do
          Begin
            If (Syss.InpPack) then
            Begin
              Rnum:=PAValue;
              Rnum2:=PKValue;
              CalcCases(Rnum,Rnum2,LastQty);
              PKValue:=Rnum2;
              PAValue:=Rnum;
            end
            else
            Begin
              PAValue:=LastQty;
              PKValue:=1;
              Rnum2:=1;
              Rnum:=LastQty;
            end;

            mrResult:=InitIS(BOff,sloPanel.Color,sloPanel.Font);

            If (mrResult=mrOk) then
            Begin
              If (CheckNegStk) and (PKValue*PAValue>FreeQty) then
              Begin
                PKValue:=Rnum2;
                PAValue:=Rnum;
              end;

              LastQty:=PAValue*PKValue;
              StoreLocQty(LId,QtyReq,LastQty,loCode);

              QtyReq:=QtyReq-LastQty+DedQty;

              OutUsedReq;

              AddNewRow(MUListBoxes[0].Row,BOn);
            end;
          end;

        finally

          ISCtrl.Free;

        end; {Try..}
      end;

      SetListFocus;
      
    end; {With..}
  end; {If..}
end; {Proc..}



Procedure TLocnList.OutUsedReq;

Begin
  I1StatLab.Caption:='Items Required:'+#13+FormatFloat(GenQtyMask,QtyReq);
end;



Procedure Display_LocUse(AOwner   :  TForm;
                         IdR      :  Idetail;
                         LStk     :  StockRec;
                         LQtyReq  :  Double;
                     Var LAMLId   :  MLIdOPtr);

Var
  StkActive  :  Boolean;
  MLocList   :  TLocnList;


Begin
  StkActive:=BOn;

  Set_MLFormMode(3);

  MLocList:=TLocnList.Create(AOwner);

  try
    With MLocList do
    Begin
      ExLocal.LId:=IdR;
      ExLocal.LStock:=LStk;
      TxAutoMLId:=LAMLId;

      ExtFlgPtr:=@StkActive;

      OrigQty:=LQtyReq;
      QtyReq:=LQtyReq;

      OutUsedReq;

      ChangePage(1);

      Repeat

        Application.ProcessMessages;

      Until (Not StkActive);

      LAMLId:=TxAutoMLId;
    end;
  except
    MLocList.Free;
  end; {try..}
end;



procedure TLocnList.FillBtnClick(Sender: TObject);

Var
  mbRet  :  Word;

begin
  MbRet:=MessageDlg('Please Confirm you wish to generate all location records',
                       mtConfirmation,[mbYes,mbNo],0);

  If (mbRet=mrYes) then
  Begin
    {$IFDEF POST}
      AddStkLocFill2Thread(Self,ExLocal.LStock);
    {$ENDIF}
  end;
end;



procedure TLocnList.MoveBtnClick(Sender: TObject);
Var
  InpOk,
  FoundOk  :  Boolean;


  OCode,
  SCode    :  String;

  LocFilt  :  Str10;

  mbRet    :  Word;

Begin

  SCode:='';
  OCode:=SCode;

  mbRet:=MessageDlg('Choosing this option will transfer all current stock'+#13+
                    'levels to a specified location. In addition any unsold'+#13+
                    'serial nos will also be transfered to this location.'+#13+
                    'This option should be run only once.',
                       mtWarning,[mbOk,mbCancel],0);


  If (mbRet=mrOk) then
  Begin
    FoundOK := False;
    Repeat

      InpOk:=InputQuery('Location Filter','Which Location do you wish to move all stock to?',SCode);

      {$IFDEF SOP}
        If (InpOk) then
          FoundOk:=GetMLoc(Self,SCode,LocFilt,'',0);
      {$ENDIF}

    Until (FoundOk) or (Not InpOk);

    If (InpOk) then
    Begin
      Generate_LocTxfrAdj(LocFilt);

    end;
  end;
end;



procedure TLocnList.Get_Notes;

Var
  WasNew  :  Boolean;

Begin
  {$IFDEF NP}
    WasNew:=Not Assigned(NoteCtrl);

    With ExLocal,MLocCtrl^.MlocLoc do
      Set_NFormMode(FullNCode(loCode),NoteLCode,1,loNLineCount);

    If (WasNew) then
    Begin
      NoteCtrl:=TDiaryList.Create(Self);


    end;


    try
      With NoteCtrl do
      Begin
        With MLocCtrl^.MlocLoc do
          SetCaption('Loc : '+dbFormatName(loCode,loName));

        Show;

      end;
    except
      NoteCtrl.Free;
      NoteCtrl:=nil;

    end;
  {$ENDIF}
end;


procedure TLocnList.NteBtnClick(Sender: TObject);
begin
  {$IFDEF NP}

    If (Assigned(MULCtrlO[Current_Page])) then
      If (MULCtrlO[Current_Page].ValidLine) then
        Get_Notes;

  {$ENDIF}
end;


{$IFDEF NP}

  Procedure TLocnList.NoteUpdate(NewLineNo  :  LongInt);


  Const
    Fnum     =  MLocF;
    Keypath  =  MIK;


  Var
    KeyChk,
    KeyS    :  Str255;

    HoldMode:  Byte;

    B_Func  :  Integer;

    LOk,
    Locked,
    TmpBo   :  Boolean;


  Begin

    Locked:=BOff;

    KeyS:=FullCCKey(CostCCode,CSubCode[BOn],NoteCtrl.NotesCtrl.GetFolio);

    With ExLocal do
    Begin
      LOk:=LGetMultiRec(B_GetEq,B_MultLock,KeyS,KeyPath,Fnum,BOn,Locked);

      If (LOk) and (Locked) then
      With LMLocCtrl^.MLocLoc do
      Begin
        LGetRecAddr(Fnum);

        LoNLineCount:=NewLineNo;

        Status:=Put_Rec(F[Fnum],Fnum,LRecPtr[Fnum]^,Keypath);

        Report_BError(Fnum,Status);
        {* Explicitly remove multi lock *}

        UnLockMLock(Fnum,LastRecAddr[Fnum]);
      end;

    end; {With..}

  end; {Func..}

{$ENDIF}


function TLocnList.WindowExportEnableExport: Boolean;
begin
  Result := (MLFMode <> 1);
  if Result then
  begin
    WindowExport.AddExportCommand (ecIDCurrentRow, ecdCurrentRow);
    WindowExport.AddExportCommand (ecIDCurrentPage, ecdCurrentPage);
    WindowExport.AddExportCommand (ecIDEntireList, ecdEntireList);
  end;
end;

function TLocnList.WindowExportGetExportDescription: String;
begin
  Result := 'Stock at Loc - ' + trim(ExLocal.LStock.StockCode) ;
end;

procedure TLocnList.WindowExportExecuteCommand(const CommandID: Integer;const ProgressHWnd: HWND);
Var
  ListExportIntf : IExportListData;
begin
  // Returns a new instance of an "Export Btrieve List To Excel" object
  ListExportIntf := NewExcelListExport;
  try
    ListExportIntf.ExportTitle := WindowExportGetExportDescription;

    // Connect to Excel
    If ListExportIntf.StartExport Then
    begin
      // Get the active Btrieve List to export the data
      MulCtrlO[Current_Page].ExportList (ListExportIntf, CommandID, ProgressHWnd);

      ListExportIntf.FinishExport;
    end; // If ListExportIntf.StartExport(sTitle)
  finally
    ListExportIntf := NIL;
  end; // Try..Finally

end;

Initialization

  MLFormMode:=0;

  TxAutoMLId:=Nil;


end.
