unit FindRecU;

interface

uses
  SysUtils, Windows, Messages, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, TEditVal, ExtCtrls, SBSPanel,
  GlobVar,VarConst,SBSComp,CmpCtrlU,  BTSupU1,BTSupU3, Menus,
  SupListU, ComCtrls,

  InvListU, Saltxl1U,

  {$IFDEF STK}
    Saltxl2U,
  {$ENDIF}

  {$IFDEF JC}
    Saltxl3U,
  {$ENDIF}

   ExtGetU, Tranl1U,

  //PR: 30/09/2013 MRD 1.1.25/26
  ConsumerUtils;




type

  TFCustList  =  Class(TCustList)

    Function GetCustBal(CCode  :  Str10;
                        BalPr,
                        BalYr  :  Byte)  :  Double;

    Function OutLine(Col  :  Byte)  :  Str255; Override;

  end;


  TFDocList  =  Class(TDDMList)

    Function SetCheckKey  :  Str255; Override;

    Function StkMatchWCard(InvR  :  InvRec)  :  Char;

    Function SetFilter  :  Str255; Override;

    Function OutLine(Col  :  Byte)  :  Str255; Override;

  end;


  {$IFDEF STK}

    TFStockList  =  Class(TStockList)

      Function OutLine(Col  :  Byte)  :  Str255; Override;

    end;

  {$ENDIF}

  {$IFDEF JC}

    TFJobList  =  Class(TJobList)

      Function OutLine(Col  :  Byte)  :  Str255; Override;

    end;

  {$ENDIF}


  TFindRec = class(TForm)
    PopupMenu1: TPopupMenu;
    PropFlg: TMenuItem;
    N1: TMenuItem;
    StoreCoordFlg: TMenuItem;
    PageControl1: TPageControl;
    GFScrollBox1: TScrollBox;
    GFLabPanel: TSBSPanel;
    GFAccLab: TSBSPanel;
    GFCompLab: TSBSPanel;
    GFBalLab: TSBSPanel;
    GFAccPanel: TSBSPanel;
    GFCompPanel: TSBSPanel;
    GFBalPanel: TSBSPanel;
    GFListBtnPanel: TSBSPanel;
    GFBtnPanel: TSBSPanel;
    GFSPanel: TSBSPanel;
    Label81: Label8;
    Label82: Label8;
    Customer: TTabSheet;
    Supplier: TTabSheet;
    Document: TTabSheet;
    Stock: TTabSheet;
    Serial: TTabSheet;
    GFCombo1: TSBSComboBox;
    GFCombo2: TSBSComboBox;
    GFFindBtn: TButton;
    GFStopBtn: TButton;
    GFCloseBtn: TButton;
    Job: TTabSheet;
    Bins: TTabSheet;
    tabConsumer: TTabSheet;

    procedure FormCreate(Sender: TObject); virtual;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure GFFindBtnClick(Sender: TObject);
    procedure GFCloseBtnClick(Sender: TObject);
    procedure FormKeyPress(Sender: TObject; var Key: Char);
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean); virtual;
    procedure FormDestroy(Sender: TObject);
    procedure FormResize(Sender: TObject);
    procedure GFAccLabMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure GFAccLabMouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure GFAccPanelMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure PopupMenu1Popup(Sender: TObject);
    procedure PropFlgClick(Sender: TObject);
    procedure StoreCoordFlgClick(Sender: TObject);
    procedure GFStopBtnClick(Sender: TObject);
    procedure PageControl1Change(Sender: TObject);
    procedure PageControl1Changing(Sender: TObject;
      var AllowChange: Boolean);

  private
    { Private declarations }

    ListOfSet  :  Integer;


    NewBuild,
    StoreCoord,
    LastCoord,
    SetDefault,
    fNeedCUpdate,
    FColorsChanged,
    fDoingClose,
    GotCoord   :  Boolean;

    PagePoint  :  Array[0..3] of TPoint;

    StartSize,
    InitSize   :  TPoint;


    DispCust   :  TFCustDisplay;

    DispDoc    :  TFInvDisplay;

    {$IFDEF STK}
      DispStk    :  TFStkDisplay;
    {$ENDIF}


    {$IFDEF JC}
      DispJob    :  TFJobDisplay;
    {$ENDIF}

    procedure Find_FormCoord;

    procedure Store_FormCoord(UpMode  :  Boolean);

    procedure FormSetOfSet;

    procedure FormDesign;

    Procedure WMFindFindRec(Var Message  :  TMessage); message WM_CustGetRec;

    Procedure WMFormCloseMsg(Var Message  :  TMessage); Message WM_FormCloseMsg;

    Procedure WMGetMinMaxInfo(Var Message  :  TWMGetMinMaxInfo); Message WM_GetMinMaxInfo;

    

    Function GetOwnListMainKey  : Str255;

    Procedure SetFView(NPage  :  Integer);

    procedure HideOwnList(State  :  Boolean);

    procedure RefreshOwnList;

    procedure SetListCaptions;

    function TxlateKey(IText  :  Str255)  :  Str255;

    function  TxlateListSearch(INo  :  Integer)  :  Integer;

    Procedure Send_UpdateList(Mode   :  Integer);


    procedure ShowRightMeny(X,Y,Mode  :  Integer);

    Procedure  SetNeedCUpdate(B  :  Boolean);

    Property NeedCUpDate :  Boolean Read fNeedCUpDate Write SetNeedCUpdate;

    procedure SetHelpContextIDs; // NF: 16/05/06

  public
    { Public declarations }

    EnableLink  :  Boolean;

    OwnList     :  TGenList;
    SuppList,
    CustList,
    ConsumerList    :  TFCustList;

    DocList     :  TFDocList;

    {$IFDEF STK}
      BinList,
      SerList,
      StkList   :  TFStockList;
    {$ENDIF}

    {$IFDEF JC}
      JobList   :  TFJobList;
    {$ENDIF}

    ReturnCtrl  :  TReturnCtrlRec;

    WCharNdx,
    Modus        :  Byte;

    OFnum,
    OKeypath,
    OKLen       :  Integer;

    OKey2F      :  Str255;

    NdxTxlate   :  Array[0..24] of Integer;

    ListPFix    :  Char;


    Function Current_Page  :  Integer;

    procedure SetFindHist(NPage  :  Integer);

    procedure SetxParent;

    procedure CreateOwnList(TOList  :  TGenList);

    Function StartLookup(AdvanceMode  :  Boolean)  :  Boolean;

    Procedure SetListFilters;  virtual;

    Procedure ChangePage(NewPage  :  Integer);

    procedure Display_AccRec;

    procedure Display_TransRec;

    {$IFDEF STK}
       procedure Display_StockRec;
    {$ENDIF}

    {$IFDEF JC}
       procedure Display_JobRec;
    {$ENDIF}

    Procedure DisplayRecord(LMode  :  Integer);

    Procedure ShowFullRecord(SMode,LMode  :  Integer); virtual;

    Procedure CtrlShowRecord(SMode,LMode  :  Integer);

    procedure SetFormProperties;

  end;


  {--------------------------------------------------------------------}


Procedure Destroy_FListDefaults;


{~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~}

Implementation

{~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~}


Uses
  ETStrU,
  ETMiscU,
  BTSupU2,
  DebugU,
  ColCtrlU,
  VarRec2U,
  BTKeys1U,
  PWarnU,
  ComnUnit,

  {$IFDEF CU}
    CustIntU,
    CustABSU,
    CustWinU,
    ExWrap1U,
  {$ENDIF}

  {$IFDEF STK}
    SysU2,
  {$ENDIF}

  SysU1;

{$R *.DFM}

Const
  //PR: 01/10/2013 MRD 1.1.25/26 Increment NoOfHistRecs to accommodate consumers
  NofHistRecs  =  7;

  //PR: 01/10/2013 MRD 1.1.25/26 Added constants for pages
  pnCustomer   = 0;
  pnConsumer   = 1;
  pnSupplier   = 2;
  pnTrans      = 3;
  pnStock      = 4;
  pnSerial     = 5;
  pnMultiBin   = 6;
  pnJob        = 7;


Type
  FindHistRec  =  Record
                    LastUsedNDX  :  Byte;
                    LastEntries  :  TStringList;
                    IsActive,
                    CallxParent  :  Boolean;
                  end;
Var
  FindHist  :  Array[0..NofHistRecs] of FindHistRec;




{ ============ TCustList Methods ================= }




Function TFCustList.GetCustBal(CCode  :  Str10;
                               BalPr,
                               BalYr  :  Byte)  :  Double;

Var
  Profit,
  Sales,
  Purch,
  Cleared      :  Double;

Begin

  Result:=Profit_to_Date(CustHistCde,CCode,0,BalYr,BalPr,Purch,Sales,Cleared,BOn);

end;

{ ========== Generic Function to Return Formatted Display for List ======= }

Function TFCustList.OutLine(Col  :  Byte)  :  Str255;

Var
  Dnum  :  Double;

Begin
  Dnum:=0;

   With Cust do
     Case Col of //PR: 01/10/2013 MRD 1.1.25/26 Change to show appropriate code
       0  :  OutLine:=TraderCodeToShow(ConsumerMode, Cust);
       1  :  OutLine:=Company;
       2  :  Begin
               {$B-}
               If (Not IsACust(CustSupp)) or (PChkAllowed_In(404))  then
               {$B+}
                 Dnum:=GetCustBal(CustCode,GetLocalPr(0).CPr,GetLocalPr(0).CYr);
                 
               OutLine:=FormatFloat(GenRealMask,Dnum);
             end;
     end; {Case..}
end;




{ ============ TDocList Methods ================= }



Function TFDocList.SetCheckKey  :  Str255;


Var
  DumStr  :  Str255;

Begin
  FillChar(DumStr,Sizeof(DumStr),0);

  Case Keypath of

    InvOurRefK :  DumStr:=Inv.OurRef;

    InvYrRefK  :  DumStr:=Inv.YourRef;

    InvLYRefK  :  DumStr:=Inv.TransDesc;

    InvFolioK  :  DumStr:=FullNomKey(Inv.FolioNum);

  end;

  SetCheckKey:=DumStr;
end;



{ ============ TStkList Methods ================= }

{$IFDEF STK}

  { ========== Generic Function to Return Formatted Display for List ======= }

  Function TFStockList.OutLine(Col  :  Byte)  :  Str255;

  Var
    Dnum  :  Double;

  Begin
    Case ScanFileNum of
      StockF  :
                 With Stock do
                   Case Col of
                     0  :  OutLine:=StockCode;
                     1  :  OutLine:=Desc[1];
                     2  :  OutLine:=FormatFloat(GenQtyMask,FreeStock(Stock));
                   end; {Case..}

      {$IFDEF SOP}

      MLocF  :  With MlocCtrl^.sdbStkRec, Stock do
                Begin
                   Case Col of
                     0  :  OutLine:=sdCode1;
                     1  :  OutLine:=dbFormatName(StockCode,Desc[1]);
                     2  :  OutLine:=FormatFloat(GenQtyMask,FreeStock(Stock));
                   end; {Case..}
                end;
      {$ENDIF}
    end; {Case...}
  end;


{$ENDIF}



{ ============ TJobList Methods ================= }

{$IFDEF JC}

  { ========== Generic Function to Return Formatted Display for List ======= }

  Function TFJobList.OutLine(Col  :  Byte)  :  Str255;

  Var
    Dnum  :  Double;

  Begin
    With JobRec^ do
      Case Col of
        0  :  OutLine:=JobCode;
        1  :  OutLine:=JobDesc;
        2  :  OutLine:=JobAltcode
      end; {Case..}
  end;


{$ENDIF}


{ ====== Function to Match Stock based on wild card ===== }

Function TFDocList.StkMatchWCard(InvR  :  InvRec)  :  Char;

Var
  TmpBo,
  FOk    :  Boolean;
  TChr   :  Char;
  TMode  :  Byte;
  WildMatch
         :  Str255;

Begin

  TmpBO:=BOff;
  TMode:=0;

  FOk:=(Not UseWildCard);

  If (Not FOk) then
  With InvR do
  Begin

    TMode:=(1*Ord(KeyWildM[1]=#32))+(2*Ord(KeyWildM[1]='/'))+(3*Ord(KeyWildM[1]=WildChQ))+(4*Ord(KeyWildM[1]=WildCha));

    If (TMode>0) then
      WildMatch:=Copy(KeyWildM,2,Pred(Length(KeyWildM)))
    else
      WildMatch:=KeyWildM;

    Case TMode of

      0,1
         :  FOk:=(Match_Glob(Sizeof(OurRef),WildMatch,OurRef,TmpBo));
      2  :  FOk:=(Match_Glob(Sizeof(YourRef),WildMatch,YourRef,TmpBo));
      3  :  FOk:=(Match_Glob(Sizeof(TransDesc),WildMatch,TransDesc,TmpBo));
      4  :  FOk:=(Match_Glob(Sizeof(InvR),WildMatch,InvR,TmpBo));

      else  FOk:=BOff;


    end; {Case..}



  end; {With..}

  If (FOk) then
    TChr:=#1
  else
    TChr:=NdxWeight;

  StkMatchWCard:=TChr;

end;


Function TFDocList.SetFilter  :  Str255;

Begin

  Case ScanFileNum of
    InvF  :  Begin
               SetFilter:=StkMatchWCard(Inv);

               If ((Keypath=InvYrRefK) and (Inv.YourRef='') and (Inv.YourRef[1]<>#0)) or
                  ((Keypath=InvLYRefK) and (Inv.TransDesc='') and (Inv.TransDesc[1]<>#0))  and (KeyRef<>'') then
                 SetFilter:=NDxWeight;
             end;

  end; {Case..}

end;



{ ========== Generic Function to Return Formatted Display for List ======= }

Function TFDocList.OutLine(Col  :  Byte)  :  Str255;

Var
  FoundCode  :  Str20;
  TCr        :  Byte;
  Dnum       :  Double;


Begin
   With Inv do
     Case Col of
       0  :  OutLine:=OurRef;
       1  :  Begin
               If (Cust.CustCode<>CustCode) then
                 GetCust(Self,CustCode,FoundCode,IsACust(CustSupp),-1);

               OutLine:=Cust.Company;

             end;

       2  :  Begin
               TCr:=0;

               {$IFDEF MC_On}

                 TCr:=Currency;

               {$ENDIF}

               Dnum:=Itotal(Inv);

               If (InvDocHed In CreditSet+RecieptSet) then
                 Dnum:=Dnum*DocNotCnst;

               OutLine:=FormatCurFloat(GenRealMask,Dnum,BOff,TCr);

             end;
     end; {Case..}
end;





Function TFindRec.Current_Page  :  Integer;


Begin


  Result:=pcLivePage(PAgeControl1);

end;

Procedure  TFindRec.SetNeedCUpdate(B  :  Boolean);

Begin
  If (Not fNeedCUpdate) then
    fNeedCUpdate:=B;
end;


procedure TFindRec.Find_FormCoord;


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
    PrimeKey:=ListPFix;

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

    GetbtControlCsm(GFScrollBox1);
    GetbtControlCsm(GFSPanel);
    GetbtControlCsm(GFCombo1);

    GFCombo2.Width:=GFCombo1.Width;

    GetbtControlCsm(GFBtnPanel);
    GetbtControlCsm(GFListBtnPanel);


    OwnList.Find_ListCoord(GlobComp);


    With OwnList.VisiList.LabHedPanel do
    Begin
     Color:=GFAccLab.Color;
     Width:=GFScrollBox1.ClientWidth-4;
   end;

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

  {NeedCUpdate}
  StartSize.X:=Width; StartSize.Y:=Height;

end;


procedure TFindRec.Store_FormCoord(UpMode  :  Boolean);


Var
  GlobComp:  TGlobCompRec;


Begin

  New(GlobComp,Create(BOff));

  With GlobComp^ do
  Begin
    PrimeKey:=ListPFix;

    GetValues:=UpMode;

    ColOrd:=Ord(StoreCoord);

    HLite:=Ord(LastCoord);

    SaveCoord:=StoreCoord;

    If (Not LastCoord) then {* Attempt to store last coord *}
      HLite:=ColOrd;

    StorebtControlCsm(Self);

    StorebtControlCsm(GFScrollBox1);
    StorebtControlCsm(GFSPanel);
    StorebtControlCsm(GFCombo1);
    StorebtControlCsm(GFBtnPanel);
    StorebtControlCsm(GFListBtnPanel);

    OwnList.Store_ListCoord(GlobComp);

  end; {With GlobComp..}

  Dispose(GlobComp,Destroy);
end;


procedure TFindRec.FormSetOfSet;


Begin

  With PagePoint[0] do
  Begin
    X:=ClientWidth-(GFScrollBox1.Width);
    Y:=ClientHeight-(GFScrollBox1.Height);
  end; {With..}

  With PagePoint[1] do
  Begin
    X:=ClientWidth-(GFSPanel.Width);
    Y:=ClientWidth-(GFBtnPanel.Left);
  end; {With..}

  With PagePoint[2] do
  Begin
    X:=GFSPanel.Width-(GFCombo1.Width);
    Y:=GFScrollBox1.ClientHeight-GFAccPanel.Height;
  end; {With..}

  With PagePoint[3] do
  Begin
    Y:=ClientHeight-GFListBtnPanel.Height;
    X:={GFFindBtn.Left-GFBtnPanel.Left;}4;
  end; {With..}

  GotCoord:=BOn;

end;


procedure TFindRec.FormDesign;

Var
  n  :  Byte;

begin

  {$IFNDEF STK}

    Stock.TabVisible:=BOff;
    Serial.TabVisible:=BOff;
    Bins.TabVisible:=BOff;

  {$ELSE}
    Bins.TabVisible:=FullStkSysOn;
    
    {$IFNDEF SOP}
      Serial.TabVisible:=BOff;
    {$ELSE}
      {$IFNDEF LTE}
        Serial.TabVisible:=FullStkSysOn;
      {$ELSE}
        Serial.TabVisible:=BOff;
        Bins.TabVisible:=BOff;
      {$ENDIF}

    {$ENDIF}

     

  {$ENDIF}

  {$IFNDEF JC}
    Job.TabVisible:=BOff;
  {$ELSE}
    Job.TabVisible:=JBCostOn;

  {$ENDIF}

  // MH 14/01/2014 v7.0.8 ABSEXCH-14944: Hide ObjectFind for Consumers if Consumers disabled
  tabConsumer.TabVisible := Syss.ssConsumersEnabled;

  If (ReturnCtrl.ShowOnly) then
  With PageControl1 do
  Begin
    For n:=0 to Pred(PageControl1.PageCount) do
      If (n<>Modus) and (Not (n In ReturnCtrl.DontHide)) then
        Pages[n].TabVisible:=BOff;

  end;


end;


procedure TFindRec.FormCreate(Sender: TObject);

Var
  n  :  Byte;

begin
  InitSize.Y:=235;
  InitSize.X:=398;

  Self.ClientHeight:=InitSize.Y;
  Self.ClientWidth:=InitSize.X;

  NeedCUpdate:=BOff;
  FColorsChanged := False;

  {Height:=262;
  Width:=406;}

  GotCoord:=BOff;

  fDoingClose:=BOff;

  GFFindBtn.Default:=Not Syss.TxlateCr;

  GFScrollBox1.VertScrollBar.Position:=0;
  GFScrollBox1.HorzScrollBar.Position:=0;

  ListOfSet:=10;

  Listpfix:=Tradecode[BOn];

  CustList:=nil;

  //PR: 01/10/2013 MRD 1.1.25/26
  ConsumerList := nil;
  
  SuppList:=nil;
  DocList:=nil;

  {$IFDEF STK}
    StkList:=nil;

    BinList:=nil;

  {$ENDIF}

  {$IFDEF JC}
    JobList:=nil;
  {$ENDIF}

  {$IFDEF SOP}
    SerList:=nil;
  {$ENDIF}

  OwnList:=nil;

  InFindDoc:=BOn;

  NewBuild:=BOn;

  FormDesign;

  {FormSetOfSet;}

  SetHelpContextIDs; // NF: 16/05/06
end;

procedure TFindRec.FormDestroy(Sender: TObject);
begin

  FindHist[Modus].IsActive:=BOff;

  InFindDoc:=BOff;

end;

procedure TFindRec.FormClose(Sender: TObject; var Action: TCloseAction);
begin

  If (Not fDoingClose) then
  Begin
    fDoingClose:=BOn;

    Action:=CaFree;


    If Assigned(SuppList) then
      SuppList.Destroy;

    If Assigned(CustList) then
      CustList.Destroy;

    //PR: 01/10/2013 Free consumerlist
    If Assigned(ConsumerList) then
      ConsumerList.Destroy;

    If Assigned(DocList) then
      DocList.Destroy;

    {$IFDEF STK}
      If Assigned(SerList) then
        SerList.Destroy;

      If Assigned(BinList) then
        BinList.Destroy;

      If Assigned(StkList) then
        StkList.Destroy;
    {$ENDIF}

    {$IFDEF JC}
      If Assigned(JobList) then
        JobList.Destroy;
    {$ENDIF}


  end;
end;

procedure TFindRec.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
begin
  GenCanClose(Self,Sender,CanClose,BOn);

  If (CanClose) and (Assigned(OwnList)) then
  Begin
    CanClose:=Not OwnList.ListStillBusy and (Not ReturnCtrl.InFindLoop);

    If (Not CanClose) then
      ShowMessage('A search is still in progress. The search must finish before this window can close.');
  end;

  If (CanClose) then
  Begin
    If (Assigned(OwnList)) then {* Force stop *}
      OwnList.IRQSearch:=BOn;

    GFScrollBox1.HorzScrollBar.Position:=0;
    GFScrollBox1.VertScrollBar.Position:=0;

    If (NeedCUpdate) And (StoreCoord Or FColorsChanged) then
      Store_FormCoord(Not SetDefault);


    {If (Assigned(CustList)) then
      CustList.Destroy;

    If (Assigned(SuppList)) then
      SuppList.Destroy;

    If (Assigned(DocList)) then
      DocList.Destroy;}

    With FindHist[Current_Page] do
    Begin
      LastUsedNdx:=GFCombo2.ItemIndex;

      LastEntries.Assign(GFCombo1.Items);
    end;


    CanClose:=BOn;
  end;

end;




procedure TFindRec.FormResize(Sender: TObject);
begin
  //PR: 10/02/2011 In certain circumstances, it's possible to come in here after closing the form.
  // Avoid any problems by checking that we're not in the process of destroying the form
  if not (csDestroying in ComponentState) then
  begin
    If (GotCoord) then
    Begin
      Self.HorzScrollBar.Position:=0;
      Self.VertScrollBar.Position:=0;

      With PagePoint[0] do
      Begin
        GFScrollBox1.Width:=ClientWidth-X;
        GFSCrollBox1.Height:=ClientHeight-Y;
      end;

      With PagePoint[1] do
      Begin
        GFSPanel.Width:=ClientWidth-X;
        GFBtnPanel.Left:=ClientWidth-Y;
      end;

      With PagePoint[2] do
      Begin
        GFCombo1.Width:=GFSPanel.Width-X;
        GFAccPanel.Height:=GFScrollBox1.ClientHeight-Y;
      end;

      GFCombo2.Width:=GFCombo1.Width;

      GFListBtnPanel.Left:=GFScrollBox1.Width+1;
      GFListBtnPanel.Height:=ClientHeight-PagePoint[3].Y;


      GFFindBtn.Left:=GFBtnPanel.Left+PagePoint[3].X;
      GFStopBtn.Left:=GFFindBtn.Left;
      GFCloseBtn.Left:=GFFindBtn.Left;

      {GFLabPanel.Width:=GFScrollBox1.ClientWidth-4;}

      NeedCUpdate:=((StartSize.X<>Width) or (StartSize.Y<>Height));

      If (Assigned(OwnList)) then
      Begin
        OwnList.LinkOtherDisp:=BOff;


        With OwnList do
        Begin
          ReFresh_Buttons;

          RefreshAllCols;
        end;{Loop..}

        OwnList.LinkOtherDisp:=BOn;
      end;

    end; {If time to update}
  end; //if not csDestroying in ComponentState
end;




procedure TFindRec.FormKeyPress(Sender: TObject; var Key: Char);
begin
  {$B-}

  If (Not Assigned(OwnList)) or (Not OwnList.CheckInListFocus) then
    GlobFormKeyPress(Sender,Key,ActiveControl,Handle);

  {$B+}
end;


procedure TFindRec.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
Begin
  {$B-}

    If (Not Assigned(OwnList)) or  (Not OwnList.CheckInListFocus) then
      GlobFormKeyDown(Sender,Key,Shift,ActiveControl,Handle);

  {$B+}
end;

Procedure TFindRec.WMFindFindRec(Var Message  :  TMessage);


Begin

  With Message do
    Case WParam of

      0,1,
      200,
      201  :  Begin
                PostMessage(Self.Handle,WM_FormCloseMsg,WParam,LParam);
              end;

        2  :  ShowRightMeny(LParamLo,LParamHi,1);

       18,36
           :  EnableLink:=BOff;


       {$IFDEF SOP}
         19  :  SerStkRec:=nil;
       {$ENDIF}

       {$IFDEF STK}
          28  :  BinStkRec:=nil;
       {$ENDIF}

       25  :  Begin
                NeedCUpdate:=BOn;
                FColorsChanged := True;
              End;

      175
           :  With PageControl1 do
                ChangePage(FindNextPage(ActivePage,(LParam=0),BOn).PageIndex);



    end; {Case..}

  Inherited;
end;


Procedure TFindRec.WMFormCloseMsg(Var Message  :  TMessage);


Begin

  With Message do
    Case WParam of

      0,1,
      200,
      201  :  Begin
                CtrlShowRecord(WParam,LParam);

                If (Assigned(OwnList)) and (WParam=0) then
                With OwnList do
                  If ListStillBusy and (Not IRQSearch) then
                  Begin
                    GFStopBtnClick(nil);

                  end;
              end;

      7  :    PostMessage(Self.Handle,WM_Close,0,0);


    end; {Case..}

  Inherited;
end;



Procedure TFindRec.WMGetMinMaxInfo(Var Message  :  TWMGetMinMaxInfo);

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

Procedure TFindRec.Send_UpdateList(Mode   :  Integer);

Var
  Message1 :  TMessage;
  MessResult
           :  LongInt;

Begin
  FillChar(Message1,Sizeof(Message1),0);

  With Message1 do
  Begin
    MSg:=ReturnCtrl.MessageReturn.Msg;

    WParam:=Mode+ReturnCtrl.MessageReturn.WParam;
    LParam:=ReturnCtrl.MessageReturn.LParam;
  end;

  With Message1 do
    MessResult:=SendMEssage((Owner as TForm).Handle,Msg,WParam,LParam);
    {PostMEssage((Owner as TForm).Handle,Msg,WParam,LParam);}



end; {Proc..}

procedure TFindRec.SetFindHist(NPage  :  Integer);

Begin

  With FindHist[NPage] do
  Begin
    If (LastUsedNdx<=Pred(GFCombo2.Items.Count)) then
      GFCombo2.ItemIndex:=LastUsedNdx
    else
      GFCombo2.ItemIndex:=0;

    GFCombo1.Items.Assign(LastEntries);

    If (LastEntries.Count>0) then
      GFCombo1.Text:=LastEntries[0];
  end; {With..}

end;


procedure TFindRec.SetxParent;

Var
  l,m,n  :  Integer;

Begin

  If (Not ReturnCtrl.ShowOnly) or (ReturnCtrl.ShowSome) then
  Begin
    m:=Low(FindHist);
    l:=High(FindHist);
  end
  else
  Begin
    m:=Modus;
    l:=Modus;
  end;

  For n:=m to l do
    If (n In ReturnCtrl.DontHide) or (Not ReturnCtrl.ShowSome) then
      FindHist[n].CallxParent:=ReturnCtrl.DisplayxParent;


end;


procedure TFindRec.SetListCaptions;


Begin
  //PR: 30/09/2013 MRD 1.1.25/26 Inserted page 1 for consumers and moved other numbers up accordingly. Replaced numbers with constants.
  If (Not (Current_Page In [5,6])) then
  With OwnList,VisiList do
  Case Current_Page of
    pnCustomer..pnSupplier
          : Begin
              IdOrdPanel(0,BOn).Caption:='A/C Code';
              IdOrdPanel(1,BOn).Caption:='Company';
              IdOrdPanel(2,BOn).Caption:='Balance';
            end;

    pnTrans
          :  Begin
              IdOrdPanel(0,BOn).Caption:='Document';
              IdOrdPanel(1,BOn).Caption:='Company';
              IdOrdPanel(2,BOn).Caption:='Value';
            end;

    pnStock
          : Begin
              IdOrdPanel(0,BOn).Caption:='Stock Code';
              IdOrdPanel(1,BOn).Caption:='Description';
              IdOrdPanel(2,BOn).Caption:='Free Stock';
            end;


  {$IFDEF JC}
     pnJob: Begin
              IdOrdPanel(0,BOn).Caption:='Job Code';
              IdOrdPanel(1,BOn).Caption:='Description';
              IdOrdPanel(2,BOn).Caption:='Alt Job Code';
            end;
  {$ENDIF}



  end {Case..}
  else
  Begin
    GFAccLab.Caption:='';
    GFCompLab.Caption:='';
    GFBalLab.Caption:='';
  end;
end;


procedure TFindRec.CreateOwnList(TOList  :  TGenList);

Var
  StartPanel
     :  TSBSPanel;

  n  :  Integer;



Begin

  OwnList:=TOList;

  Try
    With OwnList do
    Begin

      Try

        YieldMessage:=BOn;

        With VisiList do
        Begin
          AddVisiRec(GFAccPanel,GFAccLab);
          AddVisiRec(GFCompPanel,GFCompLab);
          AddVisiRec(GFBalPanel,GFBalLab);

          VisiRec:=List[0];

          StartPanel:=(VisiRec^.PanelObj as TSBSPanel);

        end;
      except
        VisiList.Free;

      end;

      VisiList.LabHedPanel:=GFLabPanel;

      If (NewBuild) then
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
      EnableLink:=BOn;

      WM_ListGetRec:=WM_CustGetRec;


      Parent:=StartPanel.Parent;

      MessHandle:=Self.Handle;

      For n:=0 to MUTotCols do
      With ColAppear^[n] do
      Begin
        AltDefault:=BOn;

        //PR: 30/09/2013 MRD 1.1.25/26 Adjusted page numbers to accommodate insertion of consumer page. Replaced numbers with constants.
        If (Current_Page In [pnTrans,pnStock]) and (n=2) then
        Begin
          DispFormat:=SGFloat;

          Case Current_Page of
            3  :  NoDecPlaces:=2;
            4  :  NoDecPlaces:=Syss.NoQtyDec;
          end; {Case..}
          
        end;
      end;

      ListCreate;


      AbortOnEmpty:=BOn;

      Set_Buttons(GFListBtnPanel);

      ScanFileNum:=1;

    end; {With..}

  except

    OwnList.Free;
    OwnList:=Nil;

  end;


  If (NewBuild) then
  Begin
    FormSetOfSet;

    FormReSize(Self);

    MDI_UpdateParentStat;

    NewBuild:=BOff;
  end;
end;


procedure TFindRec.HideOwnList(State  :  Boolean);

Var
  n  :  Byte;

Begin
  If (Assigned(OwnList)) then
  With OwnList do
  Begin
    For n:=0 to MUTotCols do
      MUListBoxes[n].Visible:=Not State;

  end;
end;

procedure TFindRec.RefreshOwnList;

Begin
  If (Assigned(OwnList)) then
  With OwnList do
  Begin

    HideOwnList(BOff);

    {GFScrollBox1.HorzScrollBar.Position:=0;

    ReSizeAllCols(0,0);}

    
    {If (PageKeys^[0]<>0) then
      PageUpDn(0,BOn);}

  end; {with..}
end;



procedure TFindRec.SetListFilters;

Begin
  If (Assigned(OwnList)) then
    With OwnList do
    Case Current_Page of
     //PR: 30/09/2013 MRD 1.1.25/26 Add consumer page and amend prefix char. Replaced numbers with constants.
      pnCustomer..pnSupplier
            :  Begin
                 Filter[1,0]:=SubTypeFromTraderType(Current_Page);
               end;

    end; {Case..}
end;


Function TFindRec.GetOwnListMainKey  : Str255;

Var
  LastKP  :  Integer;

Begin
  If (Assigned(OwnList)) then
    With OwnList do
    Begin
      LastKP:=Keypath;
      Keypath:=0;

      Result:=SetCheckKey;
      Keypath:=LastKP;
    end; {With..}
end;


Procedure TFindRec.SetFView(NPage  :  Integer);


Const
  NoNDXs      =    9;

  //PR: 30/09/2013 MRD 1.1.25/26 Insert extra line after Customers for Consumers
  SearchNDX   :    Array[0..7,0..NoNDXs] of Str20 = (('Account Code','Account Name','Alt Code','Tax Code','Phone No.','Post Code','Their Code for us','Invoice To','Email Addr','Any Field'),
                                                     ('Long Account Code','Account Name','Alt Code','Short Account Code','Phone No.','Post Code','Email Addr','Any Field','',''),
                                                     ('Account Code','Account Name','Alt Code','Tax Code','Phone No.','Post Code','Their Code for us','Invoice To','Email Addr','Any Field'),
                                                     ('Our Ref','Your Ref','Alt Ref','Folio Number','Any Header Field','','','','',''),
                                                     {$IFDEF SOP}
                                                       ('Stock Code','Description','Alt Code','Bar Code','Alt Code database','Any Field','','','',''),
                                                     {$ELSE}
                                                       ('Stock Code','Description','Alt Code','Bar Code','Any Field','','','','',''),
                                                     {$ENDIF}
                                                     ('Serial Number','Batch Number','','','','','','','',''),
                                                     ('Bin code','','','','','','','','',''),
                                                     ('Job Code','Description','Alt Job Code','Any Field','','','','','','')
                                                    );

  //PR: 30/09/2013 MRD 1.1.25/26 Insert extra line after Customers for Consumers
  SearchNDXTx :    Array[0..7,0..NoNDXs] of Integer = ((ATCodeK,ATCompK,ATAltK,CustCntyK,CustTelK,CustPCodeK,CustRCodeK,CustInvToK,CustEmailK,ATCodeK),
                                                       (CustLongACCodeK,CustNameK,CustAltCodeK,CustACCodeK,CustTelK,CustPCodeK,CustEmailK,CustACCodeK,0,0),
                                                       (ATCodeK,ATCompK,ATAltK,CustCntyK,CustTelK,CustPCodeK,CustRCodeK,CustInvToK,CustEmailK,ATCodeK),
                                                       (InvOurRefK,InvYrRefK,InvLYRefK,InvFolioK,InvOurRefK,0,0,0,0,0),

                                                       {$IFDEF SOP}
                                                         (StkCodeK,StkDescK,StkAltK,StkBarCK,MLK,StkCodeK,0,0,0,0),

                                                       {$ELSE}
                                                         (StkCodeK,StkDescK,StkAltK,StkBarCK,StkCodeK,0,0,0,0,0),

                                                       {$ENDIF}

                                                       (0,0,0,0,0,0,0,0,0,0),
                                                       (0,0,0,0,0,0,0,0,0,0),
                                                       (JobCodeK,JobDescK,JobAltK,JobCodeK,0,0,0,0,0,0)
                                                      );


Var

  n           :  Byte;

  NotNew      :  Boolean;

  PrevList    :  TGenList;


Begin
  NotNew:=BOff;

  FindHist[NPage].IsActive:=BOn;

  PrevList:=OwnList;

  If (Assigned(OwnList)) then
    OwnList.Set_ButtonsVisible(BOff);

  //PR: 30/09/2013 MRD 1.1.25/26 Inserted page 1 for consumers and moved other numbers up accordingly
  Case NPage of

    pnCustomer..pnSupplier
         :  Begin
              Case NPage of
                pnCustomer
                   :  Begin
                        If (Not Assigned(CustList)) then
                        Begin
                          CustList:=TFCustList.Create(Self);

                          try
                            CreateOwnList(CustList);
                          except
                            CustList.Free;
                            CustList:=nil;
                            exit;
                          end; {try..}

                        end
                        else
                        Begin
                          NotNew:=BOn;
                          OwnList:=CustList;
                        end;

                        //PR: 01/10/2013 MRD 1.1.25/26 Set consumer mode
                        CustList.ConsumerMode := cmDontShow;
                      end;
                pnConsumer
                   :  Begin  //Consumers
                        If (Not Assigned(ConsumerList)) then
                        Begin
                          ConsumerList:=TFCustList.Create(Self);

                          try
                            CreateOwnList(ConsumerList);
                          except
                            ConsumerList.Free;
                            ConsumerList:=nil;
                            exit;
                          end; {try..}

                        end
                        else
                        Begin
                          NotNew:=BOn;
                          OwnList:=ConsumerList;
                        end;

                        //Set consumer mode
                        ConsumerList.ConsumerMode := cmShowLongCode;
                      end;
                pnSupplier
                   :  Begin
                        If (Not Assigned(SuppList)) then
                        Begin
                          SuppList:=TFCustList.Create(Self);

                          try
                            CreateOwnList(SuppList);
                          except
                            SuppList.Free;
                            SuppList:=nil;
                            exit;
                          end; {try..}

                        end
                        else
                        Begin
                          NotNew:=BOn;
                          OwnList:=SuppList;
                        end;

                        //PR: 01/10/2013 MRD 1.1.25/26 Set consumer mode
                        SuppList.ConsumerMode := cmDontShow;
                      end;
              end; {Case..}

              Caption:='ObjectFind. Find '+TraderTypeNameFromSubType(SubTypeFromTraderType(NPage))+' Record';

              OFnum:=CustF;
              OwnList.ExtRecPtr := @Cust;

              //PR: 01/10/2013 MRD 1.1.25/26 Set correct wild chard index for Consumers
              if NPage = pnConsumer then
                WCharNDX := 7
              else
                WCharNdx:=NoNdxs;
            end;

    pnTrans
         :  Begin
              If (Not Assigned(DocList)) then
              Begin
                DocList:=TFDocList.Create(Self);

                try
                  CreateOwnList(DocList);
                except
                  DocList.Free;
                  DocList:=nil;
                  exit;
                end; {try..}

              end
              else
              Begin
                NotNew:=BOn;
                OwnList:=DocList;
              end;

              Caption:='ObjectFind. Find Document Record';

              OFnum:=InvF;


              WCharNdx:=NoNdxs-5;

              If (ReturnCtrl.Pass2Parent) then
              Begin
                SearchNdx[2,NoNdxs-5]:='Account Code';
              end
              else
                SearchNdx[2,NoNdxs-5]:='Any Header field';
            end;

    {$IFDEF STK}

    pnStock
         :  Begin
              If (Not Assigned(StkList)) then
              Begin
                StkList:=TFStockList.Create(Self);

                try
                  CreateOwnList(StkList);
                except
                  StkList.Free;
                  StkList:=nil;
                  exit;
                end; {try..}

              end
              else
              Begin
                NotNew:=BOn;
                OwnList:=StkList;
              end;

              Caption:='ObjectFind. Find Stock Record';

              OFnum:=StockF;

              {$IFDEF SOP}
                WCharNdx:=NoNdxs-Ord(ReturnCtrl.Pass2Parent)-4;

                {$IFDEF LTE}
                  WCharNdx:=NoNdxs-Ord(ReturnCtrl.Pass2Parent)-5;

                  If (Not NotNew) then
                  Begin
                    SearchNDX[3,4]:=SearchNDX[3,5];
                    SearchNDX[3,5]:='';

                    SearchNDXTx[3,4]:=SearchNDXTx[3,5];

                    SearchNDXTx[3,5]:=0;
                  end;
                {$ENDIF}
              {$ELSE}
                WCharNdx:=NoNdxs-Ord(ReturnCtrl.Pass2Parent)-5;
              {$ENDIF}

              With ReturnCtrl do
                If (AllowAnyField and Pass2Parent) then
                  WCharNdx:=Succ(WCharNdx);
            end;

      {$IFDEF SOP}
        pnSerial
             :  Begin
                  If (Not Assigned(SerList)) then
                  Begin
                    SerList:=TFStockList.Create(Self);

                    try
                      CreateOwnList(SerList);
                    except
                      SerList.Free;
                      SerList:=nil;
                      exit;
                    end; {try..}

                  end
                  else
                  Begin
                    NotNew:=BOn;
                    OwnList:=SerList;
                  end;


                  Caption:='ObjectFind. Find Serial/Batch Record';

                  OFnum:=MiscF;

                  WCharNdx:=1;
                end;


      {$ENDIF}

        pnMultiBin
            :  Begin
                  If (Not Assigned(BinList)) then
                  Begin
                    BinList:=TFStockList.Create(Self);

                    try
                      CreateOwnList(BinList);
                    except
                      BinList.Free;
                      BinList:=nil;
                      exit;
                    end; {try..}

                  end
                  else
                  Begin
                    NotNew:=BOn;
                    OwnList:=BinList;
                  end;


                  Caption:='ObjectFind. Find Bin Record';

                  OFnum:=MLocF;

                  WCharNdx:=1;
                end;



    {$ENDIF}

    {$IFDEF JC}

      pnJob :  Begin
                If (Not Assigned(JobList)) then
                Begin
                  JobList:=TFJobList.Create(Self);

                  try
                    CreateOwnList(JobList);
                  except
                    JobList.Free;
                    JobList:=nil;
                    exit;
                  end; {try..}

                end
                else
                Begin
                  NotNew:=BOn;
                  OwnList:=JobList;
                end;

                Caption:='ObjectFind. Find Job Record';

                OFnum:=JobF;

                WCharNdx:=NoNdxs-Ord(ReturnCtrl.Pass2Parent)-6;

              end;
    {$ENDIF}

  end; {Case..}

  If (Assigned(PrevList)) then {* Re apply any col changes *}
    OwnList.VisiList.AssignFromMaster(PrevList.VisiList);

  If (Assigned(OwnList)) then
    OwnList.RefreshAllCols;

  If (NotNew) then
  Begin
    
    RefreshOwnList;

    If (Assigned(OwnList)) then
    With OwnList do
    Begin

      Set_ButtonsVisible(BOn);
      ReFresh_Buttons;
    end;

  end;


  GFCombo2.Items.Clear;

  for n:=0 to WCharNdx do
  Begin
    GFCombo2.Items.Add(SearchNdx[NPage,n]);
    NdxTxlate[n]:=SearchNdxTx[NPage,n];
  end;

  SetFindHist(NPage);



end; {Proc..}



Function TFindRec.StartLookup(AdvanceMode  :  Boolean)  :  Boolean;

Var
  SKPath  :  Integer;
Begin


  With OwnList do
  Begin
    SKPAth:=NdxTxlate[GFCombo2.ItemIndex];

    StartList(OFnum,SKPath,OKey2F,OKey2F,OKey2F,OKLen,AdvanceMode);

    If (AdvanceMode) then
      Result:=GetCode(0)
    else
      Result:=Not ExitScan;
  end;

end;


function TFindRec.TxlateKey(IText  :  Str255)  :  Str255;

Begin
  //PR: 01/10/2013 MRD 1.1.25/26 Add 1 for consumers & increment following numbers. Replaced numbers with constants.
  Case Current_Page of
    pnCustomer, pnSupplier
         :  Case GFCombo2.ItemIndex of
              0..3,8
                 :  Result:=SubTypeFromTraderType(Current_Page)+UpCaseStr(IText);

              else  Result:=UpCaseStr(IText);

            end; {Case..}

    pnConsumer
        :  Case GFCombo2.ItemIndex of
              0..3
                 :  Result:=SubTypeFromTraderType(Current_Page)+UpCaseStr(IText);
                    //6 is email address index - we don't have an index using acSubType, so set prefix to customer ('C')
              6  :  Result := TradeCode[True] + UpCaseStr(IText);

              else  Result:=UpCaseStr(IText);

            end; {Case..}

    pnTrans
         :  Case GFCombo2.ItemIndex of
              0  :  If (IText[Length(Itext)] In ['0'..'9']) then
                       Result:=AutoSetInvKey(IText,0)
                    else
                      Result:=UpCaseStr(IText);

              3  :  Result:=FullNomKey(IntStr(IText));

              else  Result:=UpCaseStr(IText);

            end; {Case..}


    pnStock
         :  Begin
              {$IFDEF SOP}
                {$IFNDEF LTE}
                  If (GFCombo2.ItemIndex=4) then
                  Begin
                    Result:=PartCCKey(NoteTCode,NoteCCode)+UpCaseStr(IText);
                    OFnum:=MLocF;
                  end
                  else
                {$ENDIF}

                Begin
                  OFnum:=StockF;
                  Result:=UpCaseStr(IText);
                end;

              {$ELSE}
                Result:=UpCaseStr(IText);
              {$ENDIF}
            end;

    pnSerial..pnJob
         :  Result:=UpCaseStr(IText);

  end; {Case..}
end;


function  TFindRec.TxlateListSearch(INo  :  Integer)  :  Integer;

Begin
  Result:=0;
  //PR: 01/10/2013 MRD 1.1.25/26 increment page numbers to allow for insertion of consumer page. Replaced numbers with constants.
  Case Current_Page of

    pnTrans
       :  Case INo of
            0,1  :  Result:=5+Ino;
            2,3  :  Result:=9+Ino;
            4    :  If (ReturnCtrl.Pass2Parent) then
                      Result:=35;

          end;

    pnStock
       :  Begin
            Case INo of
              5  :  If (ReturnCtrl.AllowAnyField) then
                      Result:=38
                    else
                      Result:=30;
              else  Result:=30+INo;
            end; {Case..}

          end;

  end; {Case..}

end;






procedure TFindRec.GFFindBtnClick(Sender: TObject);

Const
  // CJS 2014-01-24 - ABSEXCH-14919 - Range check error on Find Job Code - added
  //                                  missing HookIds entry for Consumers
  HookIds  :    Array[0..7,0..1] of SmallInt = ((1000,135),
                                                (1000,135),
                                                (1000,137),
                                                (2000,185),
                                                (3000,115),
                                                (0,0),
                                                (0,0),
                                                (5000,85)
                                                );


{$IFDEF CU}
Var
  CustomEvent  :  TCustomEvent;
  n            :  Byte;
  ExLocal      :  TdExLocal;
{$ENDIF}

begin
  GFStopBtn.Enabled:=BOn;

  {$B-}
  If (Not Assigned(OwnList)) or (Not OwnList.InListFind) then
  Begin

  {$B+}

    With GFCombo1 do
    Begin
      If (Items.Indexof(Text)=-1) then
        Items.Insert(0,Text);

      OKey2F:=TxlateKey(Strip('B',[#32],Text));

      ReturnCtrl.SearchKey:=OKey2F;

      ReturnCtrl.SearchPAth:=NdxTxlate[GFCombo2.ItemIndex];

    end; {With..}

    With ReturnCtrl do  //PR: 30/09/2013 MRD 1.1.25/26 Incremented page numbers to accommodate insertion of consumers page.Replaced numbers with constants.
    If ((Not Pass2Parent) or (ShowOnly and (Current_Page<>Modus))) and (Not (Current_Page In [pnSerial,pnMultiBin])) then
    With OwnList do
    Begin
      UseWildCard:=(GFCombo2.ItemIndex=WCharNdx);

      {$IFDEF CU}
        n:=Current_Page;

        //PR: 30/09/2013 MRD 1.1.25/26 For customisation, consumers are treated as customers, so set n accordingly.
        if n = pnConsumer then
          n := pnCustomer;

        If (HookIds[n,0]<>0) and (UseWildCard) then {Offer search to hook}
        Begin
          CustomEvent:=TCustomEvent.Create(EnterpriseBase+HookIds[n,0],HookIds[n,1]);


          Try
            With CustomEvent do
            Begin
              If (GotEvent) then
              Begin
                ExLocal.Create;

                BuildEvent(ExLocal);

                EntSysObj.StrResult:=OKey2F;

                Execute;

                If (EntSysObj.BoResult) then
                Begin
                  UseWildCard:=BOff;


                  ReturnCtrl.SearchPAth:=NdxTxlate[0];
                  GFCombo2.ItemIndex:=0;
                  OKey2F:=TxlateKey(EntSysObj.StrResult);
                  GFCombo1.Text:=EntSysObj.StrResult;


                end;

                ExLocal.Destroy;
              end;
            end; {With..}
          finally
            CustomEvent.Free;
          end; {Try..}
        end;

      {$ENDIF}


      If (UseWildCard) then
      Begin
        Filter[1,1]:=NdxWeight;

        KeyWildM:=WildCha+OKey2F;
        OKey2F:='';
      end
      else
      With OwnList do
      Begin
        Case OFnum of
          InvF  :  Begin
                     If (NdxTxlate[GFCombo2.ItemIndex]=InvYrRefK) or (NdxTxlate[GFCombo2.ItemIndex]=InvLYRefK) then
                       Filter[1,1]:=NDXWeight;
                   end;
        end; {Case..}
      end;


      SetListFilters;

      OKLen:=Length(OKey2F);




      If (StartLookUp(BOn)) then {* We have a unique match take appropriate action *}
      Begin
        CtrlShowRecord(0,0);
      end
      else
        If (StartLookUp(BOff)) and (MUListBoxes[0].CanFocus) then
          MUListBoxes[0].SetFocus

    end
    else
      CtrlShowRecord(0,0);

  end; {If in list find..}

end;


procedure TFindRec.GFStopBtnClick(Sender: TObject);

Const
  StopBtnCap  :  Array[BOff..BOn] of Str10 = ('&Stop','&Start');


begin

  If (Assigned(OwnList)) then
  With OwnList do
  Begin
    IRQSearch:=Not IRQSearch;

    GFStopBtn.Caption:=StopBtnCap[IRQSearch];

    If (Not IRQSearch) then
      PageUpDn(MUListBoxes[0].Row,BOn);

  end; {With..}


end;


procedure TFindRec.GFCloseBtnClick(Sender: TObject);
begin
  {$B-}

  If ((Not Assigned(OwnList)) or (Not OwnList.InListFind)) and (Not ReturnCtrl.InFindLoop) then
  Begin

  {$B+}

    If (Sender=GFCloseBtn) then
      Close
    else
      If (Sender=GFStopBtn) then;

  end;
end;


procedure TFindRec.Display_AccRec;


Begin
  If (DispCust=nil) then
    DispCust:=TFCustDisplay.Create(Self);

  try

    With DispCust do
      Display_Account(IsACust(Cust.CustSupp),50,Inv);

  except

    DispCust.Free;
    DispCust:=nil;

  end;

end; {Proc..}


procedure TFindRec.Display_TransRec;


Begin
  If (DispDoc=nil) then
    DispDoc:=TFInvDisplay.Create(Self);

  try

    With DispDoc do
    Begin
      LastDocHed:=Inv.InvDocHed;

      Display_Trans(0,Inv.FolioNum,BOff,BOff);
    end;

  except

    DispDoc.Free;
    DispDoc:=nil;

  end;

end; {Proc..}



{$IFDEF STK}

   procedure TFindRec.Display_StockRec;

  Begin
    If (DispStk=nil) then
      DispStk:=TFStkDisplay.Create(Self);

    try

      With DispStk do
      Begin
        Display_Account(0);
      end;

    except

      DispStk.Free;
      DispStk:=nil;

    end;

  end; {Proc..}


{$ENDIF}


{$IFDEF JC}

   procedure TFindRec.Display_JobRec;

  Begin
    If (DispJob=nil) then
      DispJob:=TFJobDisplay.Create(Self);

    try

      With DispJob do
      Begin
        Display_Account(0,JobRec^.JobCode,'',0,0,BOff,nil);
      end;

    except

      DispJob.Free;
      DispJob:=nil;

    end;

  end; {Proc..}


{$ENDIF}


Procedure TFindRec.DisplayRecord(LMode  :  Integer);

Begin
  {$B-}
  //PR: 01/10/2013 MRD 1.1.25/26 Inserted page 1 for consumers and moved other numbers up accordingly. Replaced numbers with constants.
  Case Current_Page of
    pnCustomer..pnSupplier
         :  If ((Assigned(DispCust)) or (LMode=0)) {and
            ((Allowed_In(IsACust(Cust.CustSupp),32)) or (Allowed_In(Not IsACust(Cust.CustSupp),42)))} then
              Display_AccRec;

  {* Removed v4.31 as these are edit checks which are already taken care of once inside the transaction *}
  {* v5.00 check for Nom re-instated as this is a back door way into seeing noms with all g/l passwords off*}

    pnTrans
         :  With Inv do
             If ((Assigned(DispDoc)) or (LMode=0)) {and
                ((Allowed_In(InvDocHed In (SalesSplit-OrderSet),03)) or
                (Allowed_In(InvDocHed In (PurchSplit-OrderSet),12)) or
                (Allowed_In(InvDocHed In NomSplit,26)) or
                (Allowed_In(InvDocHed In (OrderSet-PurchSplit),156)) or
                (Allowed_In(InvDocHed In (OrderSet-SalesSplit),166)) or
                (Allowed_In(InvDocHed In (TSTSplit),217)) or
                (Allowed_In(InvDocHed In (StkAdjSplit),118)))}

                and ((Allowed_In(InvDocHed In NomSplit,26))
                     or (Not (InvDocHed In NomSplit)))

                then
                  Display_TransRec;

    {$IFDEF STK}
      pnStock
           :  If ((Assigned(DispStk)) or (LMode=0)) and
                    (Allowed_In(BOn,469))

                  then
                Display_StockRec;

      {$IFDEF SOP}

        pnSerial
           :  Begin
                If (Allowed_In(BOn,149)) then
                  Control_FindSer(Self,ReturnCtrl.SearchKey,GFCombo2.ItemIndex);
              end;

      {$ENDIF}

        pnMultiBin
           :  Begin
                If (Allowed_In(BOn,149)) then
                  Control_FindBin(Self,ReturnCtrl.SearchKey,GFCombo2.ItemIndex);
              end;

    {$ENDIF}

    {$IFDEF JC}
      pnJob
           :  If ((Assigned(DispJob)) or (LMode=0)) and
                  (Allowed_In(BOn,206)) then
                Display_JobRec;
    {$ENDIF}
  end; {Case..}

  {$B+}

  If (Assigned(OwnList)) then
    EnableLink:=Not OwnList.ListStillBusy
  else
    EnableLink:=BOn;

end;


Procedure TFindRec.ShowFullRecord(SMode,LMode  :  Integer);
Begin
  Case SMode of

    0  :  Begin
            EnableLink:=BOff;

            DisplayRecord(SMode);

          end;

    1  :  If (EnableLink) then
            DisplayRecord(SMode);

  end; {Case..}

end;



Procedure TFindRec.CtrlShowRecord(SMode,LMode  :  Integer);
var
  TempMode : Integer;
Begin

  With ReturnCtrl do
  Begin
    If (FindHist[Current_Page].CallxParent) and (SMode<200) then
    Begin
      ReturnCtrl.SearchMode:=TxlateListSearch(GFCombo2.ItemIndex);

      ReturnCtrl.ActiveFindPage:=Current_Page;
      ReturnCtrl.RecMainKey:=GetOwnListMainKey;

      //PR: 5/12/2013 ABSEXCH-14824 For transactions and above, need to decrement value in posted message
      TempMode := Modus;
      if TempMode > 2 then
        TempMode := TempMode - 1;

      Send_UpdateList(TempMode+(10*SMode));

      If (SMode=0) then
      With TForm(Owner) do
      Begin
        Show;
      end;
      If (SMode<>1) then
      Begin
        If (Assigned(OwnList)) then {* Abort any further searching *}
        Begin
          OwnList.IRQSearch:=BOn;

        end;

        If (Not OwnList.InListFind) and (Not OwnList.ListStarted) and (Not ManualClose) then
          PostMessage(Self.Handle,WM_FormCloseMsg,7,0);
      end;
      Exit;
    end
    else
      ShowFullRecord(Smode,LMode);
  end; {With..}

end;


procedure TFindRec.PageControl1Changing(Sender: TObject;
  var AllowChange: Boolean);
begin
  If (Assigned(OwnList)) then
    AllowChange:=Not OwnList.ListStillBusy;

  If (AllowChange) then
  Begin
    HideOwnList(BOn);

    FindHist[Current_Page].IsActive:=BOff;

    With FindHist[Current_Page] do
      Begin
        LastUsedNdx:=GFCombo2.ItemIndex;

        LastEntries.Assign(GFCombo1.Items);
      end;
  end;
end;


Procedure TFindRec.ChangePage(NewPage  :  Integer);


Begin

  With PageControl1 do
  If (Pages[NewPage].TabVisible) then
  Begin

    ActivePage:=Pages[NewPage];

    PageControl1Change(PageControl1);


  end; {With..}
end; {Proc..}


procedure TFindRec.PageControl1Change(Sender: TObject);
begin

  SetFView(Current_Page);
  SetListCaptions;

end;

procedure TFindRec.PopupMenu1Popup(Sender: TObject);
begin
  StoreCoordFlg.Checked:=StoreCoord;
end;

procedure TFindRec.ShowRightMeny(X,Y,Mode  :  Integer);

Begin
  With PopUpMenu1 do
  Begin

    PopUp(X,Y);

  end;


end;

procedure TFindRec.GFAccLabMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);

Var
  ListPoint  :  TPoint;


begin
  If (Sender is TSBSPanel) and (Assigned(OwnList)) then
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



procedure TFindRec.GFAccLabMouseMove(Sender: TObject; Shift: TShiftState;
  X, Y: Integer);
begin
  If (Sender is TSBSPanel) and (Assigned(OwnList)) then
  With (Sender as TSBSPanel) do
  Begin
    OwnList.VisiList.MoveLabel(X,Y);
    NeedCUpdate:=OwnList.VisiList.MovingLab;
  end;

end;


procedure TFindRec.GFAccPanelMouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);

Var
  BarPos :  Integer;

  PanRSized
         :  Boolean;



begin
  BarPos:=0;

  If (Sender is TSBSPanel) and (Assigned(OwnList)) then
  With (Sender as TSBSPanel) do
  Begin
    PanRSized:=Resized;

    BarPos:=GFScrollBox1.HorzScrollBar.Position;

    If (PanRsized) then
      OwnList.ResizeAllCols(OwnList.VisiList.FindxHandle(Sender),BarPos);

    
    OwnList.FinishColMove(BarPos+(ListOfset*Ord(PanRsized)),PanRsized);
    NeedCUpdate:=(OwnList.VisiList.MovingLab or PanRSized);
  end;

end;

procedure TFindRec.SetFormProperties;


Var
  TmpPanel    :  Array[1..3] of TPanel;

  n           :  Byte;

  ResetDefaults,
  BeenChange  :  Boolean;
  ColourCtrl  :  TCtrlColor;

Begin
  If (Assigned(OwnList)) then
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
          FColorsChanged := NeedCUpdate;

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
  end; {If ownlist assogned..}
end;


procedure TFindRec.PropFlgClick(Sender: TObject);
begin
  SetFormProperties;
end;

procedure TFindRec.StoreCoordFlgClick(Sender: TObject);
begin
  StoreCoord:=Not StoreCoord;
  NeedCUpdate:=BOn;
end;

// NF: 16/05/06 Fix for incorrect Context IDs
procedure TFindRec.SetHelpContextIDs;
begin
  HelpContext := 1805;
  GFCombo1.HelpContext := 1806;
  GFCombo2.HelpContext := 1807;
  GFFindBtn.HelpContext := 1808;
  GFStopBtn.HelpContext := 1809;
  GFCloseBtn.HelpContext := 1810;
end;


{ -------------------------------------------------------------------------- }


Procedure Init_FlistDefaults;

Var
  n  :  Byte;

Begin
  For n:=0 to NofHistRecs do
    With FindHist[n] do
    Begin
      LastUsedNdx:=0;

      LastEntries:=TStringList.Create;
    end;
end;


Procedure Destroy_FListDefaults;

Var
  n  :  Byte;

Begin
  For n:=0 to NofHistRecs do
    With FindHist[n] do
    Begin
      LastEntries.Free;
    end;
end;






Initialization

  Init_FListDefaults;


Finalization

  Destroy_FListDefaults;


end.
