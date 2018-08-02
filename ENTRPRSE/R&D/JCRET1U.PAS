unit JCRet1U;

interface

{$I DEFOvr.Inc}

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, TEditVal, ExtCtrls, SBSPanel, ComCtrls,
  GlobVar,VarConst,VarRec2U, BTSupU1,ExWrap1U, ExtGetU, SBSComp2,
  CustSupU,

  {$IFDEF Post}
  {$ENDIF}


  SalTxl2U,

  Menus, Mask, TCustom, Buttons;




type
 TJRList  =  Class(TCLMList)

   Function OutLine(Col  :  Byte)  :  Str255; Override;


 end;


type
  TJCRetFrm = class(TForm)
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
    Find1: TMenuItem;
    N2: TMenuItem;
    PropFlg: TMenuItem;
    N1: TMenuItem;
    StoreCoordFlg: TMenuItem;
    TSQ3Panel: TSBSPanel;
    TSQ4Panel: TSBSPanel;
    TSQ5Panel: TSBSPanel;
    TSQ2Lab: TSBSPanel;
    TSQ3Lab: TSBSPanel;
    TSQ4Lab: TSBSPanel;
    TSQ5Lab: TSBSPanel;
    TeleInpFrm: TTabSheet;
    Currency1: TMenuItem;
    List1: TMenuItem;
    D1BtnPanel: TSBSPanel;
    D1BSBox: TScrollBox;
    FindD1Btn: TButton;
    MtchD1Btn: TButton;
    TSPrevBtn: TSBSButton;
    TSFinBtn: TSBSButton;
    CurD1Btn: TButton;
    FinSheet1: TTabSheet;
    Label83: Label8;
    HedPanel: TSBSPanel;
    Label81: Label8;
    Label86: Label8;
    Label88: Label8;
    Label810: Label8;
    Label814: Label8;
    Label815: Label8;
    Label87: Label8;
    Bevel2: TBevel;
    Label812: Label8;
    Label816: Label8;
    SBSPanel2: TSBSPanel;
    Bevel1: TBevel;
    TSNextBtn: TSBSButton;
    TSInpClsBtn: TSBSButton;
    ACFF: Text8Pt;
    SBSPanel3: TSBSPanel;
    Image1: TImage;
    CompF: Text8Pt;
    CurrF: TSBSComboBox;
    AnalFF: Text8Pt;
    Id3CCF: Text8Pt;
    Id3DepF: Text8Pt;
    LinkCF: Text8Pt;
    PCentF: TCurrencyEdit;
    SRCF: Text8Pt;
    JDeF: Text8Pt;
    SRC2F: Text8Pt;
    RetInvPanel: TSBSPanel;
    Label89: Label8;
    Label811: Label8;
    Label82: Label8;
    ExpDtF: TEditDate;
    RetAmF: TCurrencyEdit;
    InvNoF: Text8Pt;
    Clsd1Btn: TButton;
    HedBackBtn: TSBSButton;
    T2VATF: TSBSComboBox;
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
    procedure Find1Click(Sender: TObject);
    procedure TSNextBtnClick(Sender: TObject);
    procedure PageControl1Changing(Sender: TObject;
      var AllowChange: Boolean);
    procedure ACFFExit(Sender: TObject);
    procedure I4JobAnalFChange(Sender: TObject);
    procedure Id3CCFExit(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure FormKeyPress(Sender: TObject; var Key: Char);
    procedure TSPrevBtnClick(Sender: TObject);
    procedure CompFDblClick(Sender: TObject);
    procedure ACFFDblClick(Sender: TObject);
    procedure TSFinBtnClick(Sender: TObject);
    procedure PageControl1Change(Sender: TObject);
    procedure HedBackBtnClick(Sender: TObject);
    procedure PCentFExit(Sender: TObject);
    procedure MtchD1BtnClick(Sender: TObject);
  private
    InHBeen,
    RecMode,
    BeenIn,
    InOutMode,
    PastFCreate,
    JustCreated,
    StoreCoord,
    LastCoord,
    SetDefault,
    fNeedCUpdate,
    IdStored,
    ListBusy,
    fFrmClosing,
    GotCoord,
    ShowInvPanel,
    DuringActive,
    CanDelete    :  Boolean;


    SKeypath     :  Integer;

    PagePoint    :  Array[0..7] of TPoint;


    CustBtnList  :  TVisiBtns;

    StartSize,
    InitSize,
    MaxSize      :  TPoint;


    ListAcCode   :  Str10;

    MatchFormPtr,
    DispTransPtr
                 :  Pointer;



    procedure Find_FormCoord;

    procedure Store_FormCoord(UpMode  :  Boolean);

    procedure FormSetOfSet;

    Function ScanMode  :  Boolean;

    Function Current_Page  :  Integer;

    Procedure ChangePage(NewPage  :  Integer);

    Procedure WMCustGetRec(Var Message  :  TMessage); Message WM_CustGetRec;

    Procedure WMFormCloseMsg(Var Message  :  TMessage); Message WM_FormCloseMsg;

    Procedure WMGetMinMaxInfo(Var Message  :  TWMGetMinMaxInfo); Message WM_GetMinMaxInfo;

    Procedure WMSysCommand(Var Message  :  TMessage); Message WM_SysCommand;

    Procedure Send_UpdateList(Edit   :  Boolean;
                              Mode   :  Integer);

    procedure ShowRightMeny(X,Y,Mode  :  Integer);

    Procedure  SetNeedCUpdate(B  :  Boolean);

    Property NeedCUpDate :  Boolean Read fNeedCUpDate Write SetNeedCUpdate;

    Procedure SetButtons(State  :  Boolean);

    procedure PrimeButtons(PWRef   :  Boolean);

    Procedure UpdateListView(UpdateList  :  Boolean);

    procedure OutRetnImp;

    procedure Form2Retn;

    Function CheckTSCompleted(Edit  :  Boolean)  : Boolean;

    procedure BeginRetList(CP  :  Boolean);

    Function ConfirmQuit  :  Boolean;

    Function CheckNeedStore  :  Boolean;

    Procedure CheckEditRO(TC    :  TPanel;
                          Mode  :  Boolean);

    Procedure SetEditRO(Mode  :  Boolean);

    Procedure Ammend_RetExp(Const  DRef  :  Str10;
                            Const  ExpD  :  Str8;
                            Const  Fnum,
                                   Keypath,
                                   Fnum2,
                                   Keypath2
                                         :  Integer);

    procedure ProcessId(Fnum,
                        Keypath     :  Integer;
                        Edit        :  Boolean);

    procedure StoreId(Fnum,
                      Keypath  :  Integer);

    procedure Display_Trans(Mode  :  Byte);

    procedure CalcCISValue;

    procedure CalcRetenValue;

    procedure Display_Match(ChangeFocus,
                            MatchMode     :  Boolean);


  public
    { Public declarations }

    ExLocal      :  TdExLocal;

    ListOfSet    :  Integer;

    MULCtrlO     :  TJRList;



    procedure FormDesign;

    procedure SetCaption;

    procedure RefreshList(ShowLines,
                          IgMsg      :  Boolean);

    procedure FormBuildList(ShowLines  :  Boolean);

    procedure SetFormProperties;

    procedure EditLine(Edit       :  Boolean);


    procedure DeleteBOMLine(Fnum,
                            KeyPath  :  Integer);

  end;

  Procedure Set_JRFormMode(TSRec   :  Boolean);


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
  DocSupU1,

  {$IFDEF DBD}
    DebugU,
  {$ENDIF}

  {$IFDEF GF}
    FindRecU,
    FindCtlU,
  {$ENDIF}

  InvLst2U,

  {$IFDEF MC_On}
    LedCuU,
  {$ENDIF}

  {$IFDEF POST}
    JobPostU,
  {$ENDIF}

  {$IFDEF EXSQL}
  SQLUtils,
  {$ENDIF}

  ThemeFix,

  JobSup1U,
  Saltxl1U,
  Tranl1U,
  MiscU,
  MatchU,
  Warn1U,
  SysU1,
  SysU2;


{$R *.DFM}


Var
  LocalSP  :  Boolean;


{ ========= Exported function to set View type b4 form is created ========= }

Procedure Set_JRFormMode(TSRec   :  Boolean);


Begin

  LocalSP:=TSRec;
end;



{$I JRti1U.pas}



Procedure  TJCRetFrm.SetNeedCUpdate(B  :  Boolean);

Begin
  If (Not fNeedCUpdate) then
    fNeedCUpdate:=B;
end;

procedure TJCRetFrm.Find_FormCoord;


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

    PrimeKey:=Chr(Ord('R')+Ord(RecMode));

    If (GetbtControlCsm(ThisForm)) then
    Begin
      {StoreCoord:=(ColOrd=1); v4.40. To avoid on going corruption, this is reset each time its loaded}
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


procedure TJCRetFrm.Store_FormCoord(UpMode  :  Boolean);


Var
  GlobComp:  TGlobCompRec;


Begin

  New(GlobComp,Create(BOff));

  With GlobComp^ do
  Begin
    GetValues:=UpMode;

    PrimeKey:=Chr(Ord('R')+Ord(RecMode));

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



procedure TJCRetFrm.FormSetOfSet;

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

  PagePoint[6].X:=D1BtnPanel.Left-Clsd1Btn.Left;
  PagePoint[6].Y:=Clsd1Btn.Left-TSFinBtn.Left;

  PagePoint[7].X:=TSFinBtn.Left-TSPrevBtn.Left;



  {GotCoord:=BOn;}

end;



Procedure TJCRetFrm.SetButtons(State  :  Boolean);


Begin
  CustBtnList.SetEnabBtn(State);

end;


procedure TJCRetFrm.PrimeButtons(PWRef   :  Boolean);
Var
  HideAge  :  Boolean;

Begin
  If (PWRef) and (Assigned(CustBtnList)) then
  Begin
    LockWindowUpDate(Handle);

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
          {01} AddVisiRec(FindD1Btn,BOff);
          {02} AddVisiRec(MtchD1Btn,BOff);
          {03} AddVisiRec(CurD1Btn,BOff);


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



Function TJCRetFrm.ScanMode  :  Boolean;

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


Function TJCRetFrm.Current_Page  :  Integer;


Begin


  Result:=pcLivePage(PAgeControl1);

end;

Procedure TJCRetFrm.ChangePage(NewPage  :  Integer);


Begin

  If (Current_Page<>NewPage) then
  With PageControl1 do
  If (Pages[NewPage].TabVisible) then
  Begin
    ActivePage:=Pages[NewPage];

    PageControl1Change(PageControl1);
  end; {With..}
end; {Proc..}

Procedure TJCRetFrm.WMCustGetRec(Var Message  :  TMessage);

Var
  TSPtr  :  MLocPtr;

Begin


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

      25 :  NeedCUpdate:=BOn;

      175
         :  With PageControl1 do
              ChangePage(FindNextPage(ActivePage,(LParam=0),BOn).PageIndex);
              {ChangePage(GetNewTabIdx(PageControl1,LParam));}


     200 :  DispTransPtr:=nil;


  {$IFDEF GF}

    3002
          : If (Assigned(FindCust)) then
              With MULCtrlO,FindCust,ReturnCtrl do
              Begin
                InFindLoop:=BOn;

                Find_OnList(SearchMode,SearchKey);

                With MUListBoxes[0] do
                  If (CanFocus) then
                    SetFocus;

                InFindLoop:=BOff;
              end;
  {$ENDIF}


    end; {Case..}
  end;
  Inherited;
end;




Procedure TJCRetFrm.WMFormCloseMsg(Var Message  :  TMessage);

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

              InHBeen:=((WParam=0) or ((InHBeen) and ScanMode));

              Display_Trans(2+(98*WParam));

              If (MatchFormPtr<>nil) and (WParam=1) then
                Display_Match(BOff,((Inv.RemitNo<>'') or (Inv.OrdMatch)));

            end;

      44 :  Begin
              MatchFormPtr:=nil;
            end;


    end; {Case..}

  end;

  Inherited;
end;


{ == Procedure to Send Message to Get Record == }

Procedure TJCRetFrm.Send_UpdateList(Edit   :  Boolean;
                                    Mode   :  Integer);

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
    LParam:=Ord(Edit);
  end;

  With Message1 do
    MessResult:=SendMessage((Owner as TForm).Handle,Msg,WParam,LParam);

end; {Proc..}


Procedure TJCRetFrm.WMGetMinMaxInfo(Var Message  :  TWMGetMinMaxInfo);

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
      ptMinTrackSize.Y:=210;

    end;

    {ptMaxSize.X:=530;
    ptMaxSize.Y:=368;
    ptMaxPosition.X:=1;
    ptMaxPosition.Y:=1;}

  end;

  Message.Result:=0;

  Inherited;

end;


Procedure TJCRetFrm.WMSysCommand(Var Message  :  TMessage);


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






procedure TJCRetFrm.RefreshList(ShowLines,
                                IgMsg      :  Boolean);

Var
  KeyStart    :  Str255;
  LKeyLen     :  Integer;


Begin
  ListBusy:=BOn;

  Try
    With MULCtrlO,ExLocal,LCust do
    Begin

      KeyStart:=FullCustType(CustCode,CustSupp)+Chr(1);

      With LNHCtrl do
        If (NHNeedGExt) then
        Begin
          If (CusExtObjPtr=nil) then
            ExtObjCreate;

          With CusExtRecPtr^ do
          Begin

            FCusCode:=FullCustCode(CustCode);

            FNomAuto:=BOn;

            FAlCode:=TradeCode[RecMode];
            FAlDate:=Today;

            FCr:=NHCr;
            FPr:=NHPr;
            FYr:=NHYr;

            If (Not NHOSFilt) then
            Begin
              If (FCr<>0) then
                 FMode:=2
               else
                 FMode:=1;
            end
            else
              FMode:=4;

          end;
        end
        else
          If (CusExtObjPtr<>nil) then
            ExtObjDestroy; {* Remove previous link *}

      LKeyLen:=Length(KeyStart);

      IgnoreMsg:=IgMsg;

      StartList(InvF,InvCustK,KeyStart,'','',LKeyLen,(Not ShowLines));



      IgnoreMsg:=BOff;

      TSFinBtn.Enabled:=MULCtrlO.ValidLine;
    end;
  finally
    ListBusy:=BOff;
  end; {Try..}
end;





procedure TJCRetFrm.FormBuildList(ShowLines  :  Boolean);

Var
  StartPanel  :  TSBSPanel;
  n           :  Byte;



Begin
  MULCtrlO:=TJRList.Create(Self);


  Try

    With MULCtrlO do
    Begin


      Try

        With VisiList do
        Begin
          AddVisiRec(D1RefPanel,D1RefLab);
          AddVisiRec(TSQ1Panel,TSQ1Lab);
          AddVisiRec(TSQ2Panel,TSQ2Lab);
          AddVisiRec(TSQ3Panel,TSQ3Lab);
          AddVisiRec(TSQ4Panel,TSQ4Lab);
          AddVisiRec(TSQ5Panel,TSQ5Lab);

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

        If (n In [3..5]) then
        Begin
          DispFormat:=SGFloat;
          NoDecPlaces:=2;
        end;
      end;

      ListLocal:=@ExLocal;

      ListCreate;

      UseSet4End:=BOff;

      NoUpCaseCheck:=BOff;

      Set_Buttons(D1ListBtnPanel);

      LNHCtrl.NHNeedGExt:=BOn;
      LNHCtrl.NHosFilt:=BOn;


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


procedure TJCRetFrm.FormDesign;

Var
  HideCC  :  Boolean;

Begin
  HideCC:=BOff;

  With ExLocal do
  Begin
    HideCC:=Syss.UseCCDep;


    Id3CCF.Visible:=HideCC;
    Id3DepF.Visible:=HideCC;

    If (Not HideCC) then
    Begin
      Label810.Caption:=CCVATName^+' Code';
      T2VATF.Left:=Id3CCF.Left;
    end
    else
      Label810.Caption:=Label810.Caption+CCVATName^+' Code';

    {Label810.Visible:=HideCC;}


    {$IFNDEF MC_On}
      CurrF.Visible:=BOff;
      Label815.Visible:=BOff;
    {$ELSE}

      Set_DefaultCurr(CurrF.Items,BOff,BOff);
      Set_DefaultCurr(CurrF.ItemsL,BOff,BOn);


    {$ENDIF}

    Set_DefaultVAT(t2VATF.Items,BOn,BOff);
    Set_DefaultVAT(t2VATF.ItemsL,BOn,BOn);

    ItemPage.TabVisible:=BOff;

    PageControl1.ActivePage:=TeleInpFrm;

    If (MatchOwner('JobRec',Self.Owner)) then
    Begin
      SRCF.Visible:=BOff;
      SRC2F.Visible:=BOn;

      SRC2F.Left:=SRCF.Left;
    end;


  end;
end;



Procedure TJCRetFrm.UpdateListView(UpdateList  :  Boolean);

Begin
  If (Assigned(MULCtrlO)) then
  Begin
    SetCaption;

    RefreshList(UpdateList,BOff);

  end;
end;


procedure TJCRetFrm.SetCaption;

Var
  LevelStr  :  Str255;

Begin
  With ExLocal do
  Begin
    LevelStr:=DocGroup[1+Ord(RecMode)]+' Retention. '+dbFormatName(LJobRec^.JobCode,LJobRec^.JobDesc);

    Label86.Caption:=DocGroup[1+Ord(RecMode)]+' Retention';

    If (Not LastEdit) then
      Label86.Caption:=Label86.Caption+' Wizard.'
    else
      Label86.Caption:=Label86.Caption+'.';

    If (Assigned(MULCtrlO)) then
    With MULCtrlO do
    Begin
      LevelStr:=LevelStr+' '+Show_TreeCur(LNHCtrl.NHCr,0);
    end;
  end; {with..}

  Caption:=LevelStr;
end;


procedure TJCRetFrm.FormCreate(Sender: TObject);

Var
  n  :  Integer;

begin
  // MH 12/01/2011 v6.6 ABSEXCH-10548: Modified theming to fix problem with drop-down lists
  ApplyThemeFix (Self);

  fFrmClosing:=BOff;
  ExLocal.Create;

  LastCoord:=BOff;

  NeedCUpdate:=BOff;

  ListBusy:=BOff;
  InOutMode:=BOff;

  JustCreated:=BOn;
  ShowInvPanel:=BOff;

  SKeypath:=0;

  {* When adjusting screen size, adjust MaxSize below as well .... *}
  InitSize.Y:=359;
  InitSize.X:=622;


  Self.ClientHeight:=InitSize.Y;
  Self.ClientWidth:=InitSize.X;

  {Height:=244;
  Width:=370;}

  BeenIn:=BOff;
  InHBeen:=BOff;

  MatchFormPtr:=nil;
  DispTransPtr:=nil;

  ListAcCode:='';

  RecMode:=LocalSP;

  ExLocal.AssignFromGlobal(JobF);

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

  MaxSize.Y:=Height;
  MaxSize.X:=Width;

  If (MaxSize.Y<386) then
    MaxSize.Y:=386;

  If (MaxSize.X<630) then
    MaxSize.X:=630;

  {* Did not bother to reteive previous values, as add needs to be clean really...
  LastValueObj.GetAllLastValuesFull(Self);

  Form2Retn;}


  PastFCreate:=BOn;
end;



procedure TJCRetFrm.FormDestroy(Sender: TObject);

Var
  n  :  Byte;
begin

  ExLocal.Destroy;


end;


procedure TJCRetFrm.FormCloseQuery(Sender: TObject;
                              var CanClose: Boolean);
Var
  n  : Integer;

begin
  If (Not fFrmClosing) and (Not ListBusy) then
  Begin
    CanClose:=ConfirmQuit;

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

        Send_UpdateList(BOff,145+Ord(RecMode));
      Finally
        fFrmClosing:=BOff;
      end;
    end;
  end
  else
    CanClose:=BOff;
end;

procedure TJCRetFrm.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Action:=caFree;
end;


procedure TJCRetFrm.FormResize(Sender: TObject);
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

    Clsd1Btn.Left:=D1BtnPanel.Left-PagePoint[6].X;

    TSFinBtn.Left:=Clsd1Btn.Left-PagePoint[6].Y;
    TSPrevBtn.Left:=TSFinBtn.Left-PagePoint[7].X;
    TSNextBtn.Left:=TSFinBtn.Left;
    TSInpClsBtn.Left:=ClsD1Btn.Left;
    HedBackBtn.Left:=TSPrevBtn.Left;



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

    end;{Loop..}

    MULCtrlO.LinkOtherDisp:=BOn;

    NeedCUpdate:=((StartSize.X<>Width) or (StartSize.Y<>Height));

  end; {If time to update}
end;




procedure TJCRetFrm.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  GlobFormKeyDown(Sender,Key,Shift,ActiveControl,Handle);
end;

procedure TJCRetFrm.FormKeyPress(Sender: TObject; var Key: Char);
begin
  GlobFormKeyPress(Sender,Key,ActiveControl,Handle);
end;


procedure TJCRetFrm.SetFormProperties;


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

procedure TJCRetFrm.ShowRightMeny(X,Y,Mode  :  Integer);

Begin
  With PopUpMenu1 do
  Begin

    PopUp(X,Y);
  end;


end;


procedure TJCRetFrm.PopupMenu1Popup(Sender: TObject);

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



procedure TJCRetFrm.PropFlgClick(Sender: TObject);
begin
  SetFormProperties;
end;

procedure TJCRetFrm.StoreCoordFlgClick(Sender: TObject);
begin
  StoreCoord:=Not StoreCoord;
  NeedCUpdate:=BOn;
end;



procedure TJCRetFrm.Clsd1BtnClick(Sender: TObject);
begin
  If (ModalResult=mrOk) then
    Begin
      if TSNextBtn.CanFocus then
        TSNextBtn.SetFocus;
      if (ActiveControl = TSNextBtn) then
        StoreId(JDetlF,SKeypath);
    end
    else
      If (ModalResult=mrCancel) then
      Begin

        Begin
          Close;
          Exit;
        end;
      end;
end;


procedure TJCRetFrm.D1RefPanelMouseUp(Sender: TObject;
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


procedure TJCRetFrm.D1RefLabMouseMove(Sender: TObject; Shift: TShiftState;
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


procedure TJCRetFrm.D1RefLabMouseDown(Sender: TObject;
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




procedure TJCRetFrm.FormActivate(Sender: TObject);
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




procedure TJCRetFrm.Currency1Click(Sender: TObject);
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




procedure TJCRetFrm.Find1Click(Sender: TObject);
Var
  ReturnCtrl  :  TReturnCtrlRec;

begin

  {$IFDEF GF}

    If (Not MULCtrlO.InListFind)  then
    Begin

      With ReturnCtrl,MessageReturn do
      Begin
        FillChar(ReturnCtrl,Sizeof(ReturnCtrl),0);

        WParam:=3000;
        Msg:=WM_CustGetRec;
        DisplayxParent:=BOn;
        ShowOnly:=BOn;

        //PR: 04/12/2013 ABSEXCH-14824
        Ctrl_GlobalFind(Self, ReturnCtrl, tabFindDocument);

      end;
    end; {If in list find..}

  {$ENDIF}
end;



procedure TJCRetFrm.OutRetnImp;

Var
  n  :  Byte;

Begin

  With EXLocal,LJobDetl^,JobReten do
  Begin
    InOutMode:=BOn;

    ACFF.Text:=RetCustCode;
    LinkCF.Text:=ACFF.Text;

    If (LCust.CustCode<>RetCustCode) then
      If LGetMainRecPos(CustF,RetCustCode) then;

    CompF.Text:=LCust.Company;

    SRCF.Text:=JobCode;
    SRC2F.Text:=JobCode;

    If (LJobRec^.JobCode<>JobCode) then
      If LGetMainRecPos(JobF,JobCode) then;

    JDeF.Text:=LJobRec^.JobDesc;

    {$IFDEF MC_On}
      If (RetCurr>0) then
        CurrF.ItemIndex:=Pred(RetCurr);

    {$ENDIF}

    If (DefVATCode In VATSet) then
      t2VATF.ItemIndex:=GetVATIndex(DefVATCode)
    else
      t2VATF.ItemIndex:=0;

    AnalFF.Text:=AnalCode;

    ExpDtF.DateValue:=RetDate;

    Id3CCF.Text:=RetCCDep[BOn];
    Id3DepF.Text:=RetCCDep[BOff];

    PCentF.Value:=RetDisc;
    InvNoF.Text:=RetDoc;
    RetAmF.Value:=RetValue;

    RetInvPanel.Visible:=ShowInvPanel;

    InOutMode:=BOff;
  end;


end;


procedure TJCRetFrm.Form2Retn;

Var
  n  :  Byte;

Begin
  With EXLocal,LJobDetl^,JobReten do
  Begin

    RetCustCode:=FullCustCode(ACFF.Text);

    {$IFDEF MC_On}

      If (CurrF.ItemIndex>=0) then
        RetCurr:=Succ(CurrF.ItemIndex);

    {$ENDIF}


    With t2VATF do
      If (ItemIndex>=0) then
        DefVATCode:=Items[ItemIndex][1];

    AnalCode:=AnalFF.Text;

    RetDate:=ExpDtF.DateValue;

    RetCCDep[BOn]:=Id3CCF.Text;
    RetCCDep[BOff]:=Id3DepF.Text;

    RetDisc:=PCentF.Value;
    RetDoc:=InvNoF.Text;
    RetValue:=RetAmF.Value;

  end; {with..}
end;


Function TJCRetFrm.CheckTSCompleted(Edit  :  Boolean)  : Boolean;

Const
  NofMsgs      =  7;

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

  PossMsg^[1]:='That Account Code is not valid.';
  PossMsg^[2]:='That Cost Centre Code is not valid.';
  PossMsg^[3]:='That Department Code is not valid.';
  PossMsg^[4]:='That Currency is not valid.';
  PossMsg^[5]:='The Expiry date is not valid.';
  PossMsg^[6]:='That Job Costing Analysis Code is not valid.';
  PossMsg^[7]:='That Invoice No. is not valid.';


  Test:=1;

  Result:=BOn;


  While (Test<=NofMsgs) and (Result) do
  With ExLocal,LJobDetl^.JobReten do
  Begin
    {$B-}

    Case Test of

      1  :  Begin
              Result:=(Not EmptyKey(RetCustCode,CustKeyLen));

              If (Result) then
                Result:=(CheckRecExsists(RetCustCode,CustF,CustCodeK));

            end;

      2,3
         :  Result:=(Not Syss.UseCCDep) or ((Not EmptyKeyS(RetCCDep[Test=2],CCKeyLen,BOff) and GetCCDep(Self,RetCCDep[Test=2],FoundCode,(Test=2),-1)));

    {$IFDEF MC_On}
      4  :
               Result:=(RetCurr In [Succ(CurStart)..CurrencyType]);
    {$ENDIF}

      5  :   Result:=(RetDate<>'');

      6  :  Result:=(GetJobMisc(Self,AnalCode,FoundCode,2,-1));

      7  :  Result:=((Not EmptyKey(RetDoc,DocKeyLen)) or (PageControl1.ActivePage=TeleInpFrm)) and (CheckRecExsists(RetDoc,InvF,InvOurRefK));



    end;{Case..}

    {$B+}

    If (Result) then
      Inc(Test);

  end; {While..}

  If (Not Result) then
    mbRet:=MessageDlg(PossMsg^[Test],mtWarning,[mbOk],0);

  Dispose(PossMsg);

end; {Func..}


procedure TJCRetFrm.BeginRetList(CP  :  Boolean);

Begin
  Form2Retn;

  If (CheckTSCompleted(BOff)) then
  Begin
    If (CP) then
    Begin
      ItemPage.TabVisible:=BOn;

      PageControl1.ActivePage:=ItemPage;

      PageControl1Change(PageControl1);
    end;


    If (Not Assigned(MULCtrlO)) then
    Begin

      FormBuildList(BOff);

      UpdateListView(BOff);

      MULCtrlO.SetListFocus;

    end
    else
    Begin
      SetCaption;

      If (ListAcCode<>ACFF.Text) then
        RefreshList(BOn,BOff);
    end;

    ListACCode:=ACFF.Text;

  end;
end;


procedure TJCRetFrm.HedBackBtnClick(Sender: TObject);
begin
  PageControl1.ActivePage:=ItemPage;

end;



procedure TJCRetFrm.TSNextBtnClick(Sender: TObject);
begin
  With ExLocal do
  If (InAddEdit) then
  Begin
    If (Not LastEdit) then
    Begin
      If (PageControl1.ActivePage=TeleInpFrm) then
        BeginRetList(BOn)
      else
        Clsd1BtnClick(Sender);
    end
    else
      Clsd1BtnClick(Sender);
  end
  else
  Begin
    ModalResult:=mrCancel;
    Clsd1BtnClick(Sender);
  end;

end;

procedure TJCRetFrm.TSPrevBtnClick(Sender: TObject);
begin
  PageControl1.ActivePage:=TeleInpFrm;
  MDI_ForceParentBKGnd(BOn);
  PageControl1Change(PageControl1);
end;


procedure TJCRetFrm.CalcCISValue;

Var
  VRatio  :  Double;
  IdR     :  IDetail;

Begin
  With ExLocal,LInv,LJobDetl^.JobReten do
  Begin


    If (CISOn) and (CISEmpl<>'') then {* Work out the CIS Tax retention *}
    Begin
      Blank(IDr,Sizeof(IDr));

      {* We cannot take a stright percentage as the rentetion is exclusive of VAT, and when allocated agianst the
      original invoice, it is the total value of the retention inclusive of VAT prorata which will approtioned to the CIS *}

      With Idr do
      Begin
        Qty:=1.0; QtyMul:=1.0;

        NetValue:=RetValue;

        VATCode:=VATSTDCode;

        CalcVAT(Idr,0.0);

        VRatio:=DivWChk((NetValue+VAT),Round_Up(Currency_ConvFT(ITotal(LInv),Currency,
                                          RetCurr,UseCoDayRate),2));

      end;



      RetCISTax:=Round_Up(Currency_ConvFT(CISTax*VRatio,Currency,
                                          RetCurr,UseCoDayRate),2);

      RetCISGross:=Round_Up(Currency_ConvFT(CISGross*VRatio,Currency,
                                          RetCurr,UseCoDayRate),2);

      RetCISEmpl:=CISEmpl;
    end;


  end;
end;


procedure TJCRetFrm.CalcRetenValue;



Begin
  With ExLocal,LInv,LJobDetl^.JobReten do
  Begin

    AssignFromGlobal(InvF);

    RetValue:=Round_Up(Currency_ConvFT((ITotal(LInv)-InvVAT)*Pcnt(RetDisc),Currency,
                                            RetCurr,UseCoDayRate),2);
    OrgCurr:=LInv.Currency;
    RetDoc:=LInv.OurRef;

    OutRetnImp;

  end;
end;


procedure TJCRetFrm.TSFinBtnClick(Sender: TObject);
begin
  {$B-}
    If (Assigned(MULCtrlO)) and (MULCtrlO.ValidLine) then
    Begin
      {LastValueObj.UpdateAllLastValues(Self);}

      FinSheet1.TabVisible:=BOn;

      CalcRetenValue;

      PageControl1.ActivePage:=FinSheet1;

      PageControl1Change(PageControl1);
    end;
  {$B+}
end;


procedure TJCRetFrm.PageControl1Changing(Sender: TObject;
  var AllowChange: Boolean);

Var
  NewIndex  :  Integer;

begin
  NewIndex:=pcLivePage(Sender);


    {$B-}

    AllowChange:=(NewIndex<>0) or CheckTSCompleted(BOff);


    {$B+}

    If (NewIndex=1) and AllowChange then
      MDI_ForceParentBKGnd(BOn);


end;


procedure TJCRetFrm.PageControl1Change(Sender: TObject);
Var
  NewIndex  :  Integer;

begin
  NewIndex:=pcLivePage(Sender);

  Case NewIndex of
    0    :  Begin
              HedPanel.Parent:=TeleInpFrm;
              TSNextBtn.Caption:='&Next >>';
              HedBackBtn.Visible:=BOff;
              TSNextBtn.HelpContext:=1069;
            end;
    2    :  Begin
              HedPanel.Parent:=FinSheet1;
              TSNextBtn.Caption:='&Finish';
              HedBackBtn.Visible:=BOn;
              TSNextBtn.HelpContext:=1073;
            end;
  end; {case..}

  If (NewIndex In [0,2]) then
  Begin
    ShowInvPanel:=(NewIndex=2);

    OutRetnImp;
  end;

end;


procedure TJCRetFrm.ACFFExit(Sender: TObject);
Var
  FoundCode  :  Str20;

  WTrig,
  FoundOk,
  AltMod     :  Boolean;

begin

  If (Sender is Text8pt) then
  With (Sender as Text8pt) do
  Begin
    AltMod:=Modified;

    FoundCode:=Strip('B',[#32],Text);

    If ((AltMod) or (FoundCode='')) and (ActiveControl<>TsInpClsBtn) and (Not DuringActive) then
    Begin

      StillEdit:=BOn;

      FoundOk:=(GetCust(Self,FoundCode,FoundCode,RecMode,3));

      If (FoundOk) then {* Credit Check *}
      With ExLocal do
      Begin
        Text:=FoundCode;

        LinkCF.Text:=Text;

        CompF.Text:=Cust.Company;

        If (Cust.VATCode In VATSet) then
          t2VATF.ItemIndex:=GetVATIndex(Cust.VATCode);

        AssignFromGlobal(CustF);

        SendToObjectCC(FoundCode,0);


      end;

      If (Not FoundOk) then
        SetFocus;
    end;
  end; {With..}

end; {Proc..}



procedure TJCRetFrm.I4JobAnalFChange(Sender: TObject);
Var
  FoundCode  :  Str20;

  FoundOk,
  AltMod     :  Boolean;


begin

  If (Sender is Text8pt) then
  With (Sender as Text8pt) do
  Begin
    AltMod:=Modified;

    FoundCode:=Strip('B',[#32],Text);

    If (((AltMod) or (FoundCode='')) and (Not EmptyKey(SRCF.Text,JobCodeLen))) and (ActiveControl<>TsInpClsBtn) then
    Begin

      StillEdit:=BOn;

      FoundOk:=(GetJobMisc(Self,FoundCode,FoundCode,2,5+Ord(Self.RecMode)));

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



procedure TJCRetFrm.Id3CCFExit(Sender: TObject);
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

    If ((AltMod) or (FoundCode='')) and (ActiveControl<>TsInpClsBtn) and (Syss.UseCCDep) and (Not ReadOnly) then
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


procedure TJCRetFrm.CompFDblClick(Sender: TObject);
begin
  ACFF.DblClick;

end;

procedure TJCRetFrm.ACFFDblClick(Sender: TObject);
begin
  LinkCF.DblClick;
end;


procedure TJCRetFrm.PCentFExit(Sender: TObject);
begin
  If (Not InOutMode)  and (Not PCentF.ReadOnly) then
  Begin
    Form2Retn;

    If (ExLocal.LJobDetl^.JobReten.RetDoc<>'')  then
      CalcRetenValue;
  end;
end;



Function TJCRetFrm.CheckNeedStore  :  Boolean;

Var
  Loop  :  Integer;

Begin
  Result:=BOff;
  Loop:=0;

  While (Loop<=Pred(ControlCount)) and (Not Result) do
  Begin
    If (Controls[Loop] is TMaskEdit) then
    With (Controls[Loop] as TMaskEdit) do
    Begin
      Result:=((Tag=1) and (Modified));

      If (Result) then
        Modified:=BOff;
    end
    else
      If (Controls[Loop] is TCurrencyEdit) then
      With (Controls[Loop] as TCurrencyEdit) do
      Begin
        Result:=((Tag=1) and (FloatModified));

        If (Result) then
          FloatModified:=BOff;
      end
        else
          If (Controls[Loop] is TSBSComboBox) then
          With (Controls[Loop] as TSBSComboBox) do
          Begin
            Result:=((Tag=1) and (Modified));

            If (Result) then
              Modified:=BOff;
          end;

    Inc(Loop);
  end; {While..}
end;


Procedure TJCRetFrm.CheckEditRO(TC    :  TPanel;
                                Mode  :  Boolean);

Var
  Loop  :  Integer;

Begin
  Loop:=0;

  With TC do
  While (Loop<=Pred(TC.ControlCount)) do
  Begin
    Application.ProcessMessages;

    If (Controls[Loop] is TMaskEdit) then
    With (Controls[Loop] as TMaskEdit) do
    Begin
      If (Tag=1) then
      Begin
        ReadOnly:=Mode;
        TabStop:=Not ReadOnly;
      end;
    end
    else
      If (Controls[Loop] is TCurrencyEdit) then
      With (Controls[Loop] as TCurrencyEdit) do
      Begin
        If (Tag=1) then
        Begin
          ReadOnly:=Mode;
          TabStop:=Not ReadOnly;
        end;
      end
        else
          If (Controls[Loop] is TSBSComboBox) then
          With (Controls[Loop] as TSBSComboBox) do
          Begin
            If (Tag=1) then
            Begin
              ReadOnly:=Mode;
              TabStop:=Not ReadOnly;
            end;
          end;

    If (Controls[Loop] is TPanel) and (Controls[Loop]<>TC) then
      CheckEditRO(TPanel(Controls[Loop]),Mode);

    Inc(Loop);
  end; {While..}


end;


Procedure TJCRetFrm.SetEditRO(Mode  :  Boolean);


Begin

  CheckEditRO(HeDPanel,Mode);


  With ExpDtF do
  Begin
    ReadOnly:=BOff;
    TabStop:=BOn;

    If (Mode) and CanFocus then
      SetFocus;
  end;

  If (Mode) then
  Begin
    TSNextBtn.Caption:='&OK';

  end;
end;


Function TJCRetFrm.ConfirmQuit  :  Boolean;

Var
  MbRet  :  Word;
  TmpBo  :  Boolean;

Begin

  TmpBo:=BOff;

  If (ExLocal.InAddEdit) and (CheckNeedStore) and (Not ExLocal.LViewOnly) and (Not IdStored) then
  Begin

    mbRet:=MessageDlg('Save changes to '+Caption+'?',mtConfirmation,[mbYes,mbNo,mbCancel],0);
  end
  else
    mbRet:=mrNo;

  Case MbRet of

    mrYes  :  Begin
                StoreId(JDetlF,SKeyPath);
                TmpBo:=(Not ExLocal.InAddEdit);
              end;

    mrNo   :  With ExLocal do
              Begin
                If (LastEdit) and (Not LViewOnly) and (Not IdStored) then
                  Status:=UnLockMLock(JDetlF,LastRecAddr[JDetlF]);

                TmpBo:=BOn;
              end;

    mrCancel
           :  Begin
                TmpBo:=BOff;
                
                If (ACFF.CanFocus) then
                  ACFF.SetFocus;
              end;
  end; {Case..}


  ConfirmQuit:=TmpBo;
end; {Func..}



(*  Add is used to add Notes *)

procedure TJCRetFrm.ProcessId(Fnum,
                              Keypath     :  Integer;
                              Edit        :  Boolean);

Var
  KeyS     :  Str255;
  UseNext  :  LongInt;


Begin

  Addch:=ResetKey;

  KeyS:='';

  ExLocal.InAddEdit:=BOn;

  ExLocal.LastEdit:=Edit;

  SKeypath:=Keypath;

  SetCaption;

  If (Edit) then
  Begin
    ShowInvPanel:=BOn;

    OutRetnImp;

    With ExLocal do
    Begin
      LGetRecAddr(Fnum);

      If (Not LViewOnly) then
        Ok:=LGetMultiRec(B_GetDirect,B_MultLock,KeyS,KeyPAth,Fnum,BOff,GlobLocked)
      else
        Ok:=BOn;

    end;

    If (Not Ok) or (Not GlobLocked) then
      AddCh:=Esc;
  end;


  If (Addch<>Esc) then
  With ExLocal,LJobDetl^,JobReten do
  begin

    If (Not Edit) then
    Begin

      LResetRec(Fnum);

      RecPfix:=JARCode;

      SubType:=JBPCode;

      JobCode:=LJobRec^.JobCode;
      OrigDate:=Today;

      AccType:=TradeCode[RecMode];

      RetYr:=GetLocalPr(0).CYr;
      RetPr:=GetLocalPr(0).CPr;

      RetDate:=CalcDueDate(OrigDate,30);

      {$IFDEF MC_On}

        RetCurr:=1;

      {$ENDIF}

      If (AccType=TradeCode[BOn]) then
        RetCustCode:=LJobRec^.CustCode;


    end;

    LastJobDetl^:=LJobDetl^;

    SetEditRO(Edit);

    OutRetnImp;

  end {If Abort..}
  else
    Close;

end; {Proc..}


{ === Proc to update a Retention credit if the expiry date changes === }

Procedure TJCRetFrm.Ammend_RetExp(Const  DRef  :  Str10;
                                  Const  ExpD  :  Str8;
                                  Const  Fnum,
                                         Keypath,
                                         Fnum2,
                                         Keypath2
                                               :  Integer);


Var
  KeyS    :  Str255;
  LOk,
  Locked  :  Boolean;


Begin

  With ExLocal do
  Begin

    Locked:=BOff;

    KeyS:=DRef;

    Status:=Find_Rec(B_GetEq,F[Fnum],Fnum,LRecPtr[Fnum]^,KeyPath,KeyS);

    If (StatusOk) then
    Begin

      LOk:=LGetMultiRec(B_GetDirect,B_MultLock,KeyS,KeyPAth,Fnum,BOff,Locked);


      If (LOk) and (Locked) then
      With LInv do
      Begin
        KeyS:=FullRunNoKey(FolioNum,1);

        DueDate:=ExpD;

        Status:=Find_Rec(B_GetEq,F[Fnum2],Fnum2,LRecPtr[Fnum2]^,KeyPath2,KeyS);

        If (StatusOk) then
        Begin
          LId.Desc:='Retention Credit. Expires '+PoutDate(DueDate);

          Status:=Put_Rec(F[Fnum2],Fnum2,LRecPtr[Fnum2]^,KeyPath2);

          Report_BError(Fnum2,Status);

        end;

        Status:=Put_Rec(F[Fnum],Fnum,LRecPtr[Fnum]^,KeyPath);

        Report_BError(Fnum,Status);

        UnLockMLock(Fnum,LastRecAddr[Fnum]);

      end;

    end; {If Doc Found ok..}
  end; {With..}
end;


procedure TJCRetFrm.StoreId(Fnum,
                            Keypath  :  Integer);

Var
  COk  :  Boolean;

  TmpMLoc
           :  JobDetlRec;

  mbRet    :  Word;

  {$IFDEF POST}
    LCheck_Batch :  ^TPostJob;
  {$ENDIF}



Begin

  Form2Retn;


  With ExLocal,LJobDetl^.JobReten do
  Begin
    COk:=CheckTSCompleted(BOff);



    If (COk) then
    Begin
      Cursor:=CrHourGlass;

      RetenCode:=FullJRHedKey(JobCode,AccType,RetCurr,RetDate);
      InvoiceKey:=FullJRDryKey(JobCode,AccType,RetDate);



      If (LastEdit) then
      Begin
        If (RetDate<>LastJobDetl^.JobReten.RetDate) then {* Alter CR to new date (}
          Ammend_RetExp(RetCrDoc,RetDate,InvF,InvOurRefK,IdetailF,IdLinkK);

        If (LastRecAddr[Fnum]<>0) then  {* Re-establish position prior to storing *}
        Begin

          TmpMLoc:=LJobDetl^;

          LSetDataRecOfs(Fnum,LastRecAddr[Fnum]);

          Status:=GetDirect(F[Fnum],Fnum,LRecPtr[Fnum]^,KeyPAth,0); {* Re-Establish Position *}

          LJobDetl^:=TmpMLoc;

        end;

        Status:=Put_Rec(F[Fnum],Fnum,LRecPtr[Fnum]^,KeyPAth);

      end
      else
      Begin
        {$IFDEF POST}
          CalcCISValue;

          Self.Enabled:=BOff;

          New(LCheck_Batch,Create(Self));

          try
            With LCheck_Batch^ do
            Begin
              If (Start(99,Self.Handle)) then
              Begin
                MTExLocal^.LJobDetl^:=Self.ExLocal.LJobDetl^;

                {$IFDEF EXSQL}
                // CJS - 30/07/2009 - The following would normally be done in
                // the Process method, but in this particular case the Process
                // method is never called, so we do it here instead.
                if SQLUtils.UsingSQL then
                begin
                  if not ReOpen_LocalThreadFiles then
                  begin
                    ThreadRec^.THAbort := True;
                    ThreadRec^.THShowAbort := True;
                  end;
                end;
                {$ENDIF}

                Gen_RetSCR(RetCRDoc);

                Finish;
              end;
            end;
          finally
            Self.Enabled:=BOn;

            Dispose(LCheck_Batch,Destroy);
          end; {try..}

        {$ENDIF}

        If (RetCrDoc<>'') then
          Status:=Add_Rec(F[Fnum],Fnum,LRecPtr[Fnum]^,KeyPAth)
        else
          Status:=4;


      end;

      Report_BError(Fnum,Status);


      Cursor:=CrDefault;

      InAddEdit:=BOff;

      If (LastEdit) then
        ExLocal.UnLockMLock(Fnum,LastRecAddr[Fnum]);

      IdStored:=BOn;

      Send_UpdateList(LastEdit,150+Ord(RecMode));

      LastValueObj.UpdateAllLastValues(Self);

      Close;
    end
    else
      If (ACFF.CanFocus) then
        ACFF.SetFocus;

  end; {With..}


end;


procedure TJCRetFrm.EditLine(Edit       :  Boolean);


begin
  With ExLocal do
  Begin
    try
      LastEdit:=Edit;

      ProcessId(JDetlF,JDLedgerK,LastEdit);

    finally

    end;
  end;
end;


{ ======= Link to Trans display ======== }

procedure TJCRetFrm.Display_Trans(Mode  :  Byte);

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
        AssignFromGlobal(InvF);

        LastDocHed:=LInv.InvDocHed;

        If ((LastFolio<>LInv.FolioNum) or (Mode<>100)) and (InHBeen) then
          Display_Trans(Mode,Inv.FolioNum,BOn,(Mode<>100));

      end; {with..}

    except

      DispTrans.Free;

    end;

end;


procedure TJCRetFrm.Display_Match(ChangeFocus,
                                  MatchMode     :  Boolean);


Var
  NomNHCtrl  :  TNHCtrlRec;

  FoundLong  :  Longint;

  MatchForm  :  TMatchWin;

  WasNew     :  Boolean;

Begin

  WasNew:=BOff;

  With EXLocal,NomNHCtrl do
  Begin
    AssignFromGlobal(InvF);

    FillChar(NomNHCtrl,Sizeof(NomNHCtrl),0);

    NHMode:=4-Ord(MatchMode);

    NHCr:=MULCtrlO.LNHCtrl.NHCr;

    MainK:=FullMatchKey(MatchTCode,MatchSCode,LInv.OurRef);

    NHKeyLen:=Length(MainK);

    Set_MAFormMode(NomNHCtrl);

  end;

  If (MatchFormPtr=nil) then
  Begin
    WasNew:=BOn;

    MatchForm:=TMatchWin.Create(Self);

    MatchFormPtr:=MatchForm;

  end
  else
    MatchForm:=MatchFormPtr;

  Try

   With MatchForm do
   Begin

     WindowState:=wsNormal;

     If (ChangeFocus) then
       Show;

     ShowLink(BOn);


   end; {With..}

   If (WasNew) then
   Begin
   end;

  except

   MatchFormPtr:=nil;

   MatchForm.Free;
   MatchForm:=nil;

  end; {try..}


end;



procedure TJCRetFrm.MtchD1BtnClick(Sender: TObject);
begin
  If (MULCtrlO<>nil) then
  With MULCtrlO,EXLocal do
  Begin
    If (ValidLine) then
    Begin
      RefreshLine(MUListBoxes[0].Row,BOff);

      Display_Match(BOn,((Inv.RemitNo<>'') or (Inv.OrdMatch)));

    end;
  end;
end;


procedure TJCRetFrm.DeleteBOMLine(Fnum,
                                  KeyPath  :  Integer);

Var
  MbRet  :  Word;
  GotRec :  Integer;
  KeyS   :  Str255;

Begin
  With ExLocal do
  Begin
    AssignFromGlobal(Fnum);
    LGetRecAddr(Fnum);
    ShowInvPanel:=BOn;
    OutRetnImp;
    TSFinBtn.Enabled:=BOff;
    TSNextBtn.Enabled:=BOff;
    Clsd1Btn.Enabled:=BOff;
    TSInpClsBtn.Enabled:=BOff;

    MbRet:=MessageDlg('Please confirm you wish'#13+'to delete this record',
                       mtConfirmation,[mbYes,mbNo],0);

    If (MbRet=MrYes) then
    Begin
      Status:=LGetDirectRec(Fnum,KeyPath);

      If (StatusOk) then
      Begin

        Ok:=LGetMultiRec(B_GetDirect,B_MultLock,KeyS,KeyPath,Fnum,BOn,GlobLocked);

        If (Ok) and (GlobLocked) then
        Begin

          Status:=Delete_Rec(F[Fnum],Fnum,KeyPath);

          Report_BError(Fnum,Status);
        end;


        If (StatusOk) then
        Begin

          Send_UpdateList(BOff,158+Ord(RecMode));


        end;
      end; {If line is valid for deletion..}
    end
    else
      Report_BError(Fnum,Status);
  end; {With..}

  Close;
end; {PRoc..}


Initialization

  LocalSP:=BOff;

Finalization

end.
