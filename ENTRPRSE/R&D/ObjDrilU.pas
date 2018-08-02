unit ObjDrilU;

{$I DEFOVR.Inc}

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, Grids, SBSOutl,  ExWrap1U, Menus,
  GlobVar,VarConst,BTSupU1,Tranl1U,

  {$IFDEF Nom}
    Nominl1U,
  {$ENDIF}

  {$IFDEF STK}
    SalTxl2U,
    StkTreeU,

    {$IFDEF STK}
       {*EN431MB2B*}
       ExBtTh1U,
       SCRTCH2U,
       BTSupU3,
    {$ENDIF}
  {$ENDIF}


  {$IFDEF JC}
    SalTxl3U,
    JobTreeU,
  {$ENDIF}

  SalTxl1U;


type
  TObjDFrm = class(TForm)
    ODOLine: TSBSOutlineB;
    ClsI1Btn: TButton;
    PopupMenu1: TPopupMenu;
    Expand1: TMenuItem;
    MIETL: TMenuItem;
    MIEAL: TMenuItem;
    EntireGeneralLedger1: TMenuItem;
    MIColl: TMenuItem;
    MICTL: TMenuItem;
    EntireGeneralLedger2: TMenuItem;
    N2: TMenuItem;
    PropFlg: TMenuItem;
    N1: TMenuItem;
    StoreCoordFlg: TMenuItem;
    N3: TMenuItem;
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormCreate(Sender: TObject);
    procedure FormResize(Sender: TObject);
    procedure PropFlgClick(Sender: TObject);
    procedure StoreCoordFlgClick(Sender: TObject);
    procedure PopupMenu1Popup(Sender: TObject);
    procedure ClsI1BtnClick(Sender: TObject);
    procedure Expand1Click(Sender: TObject);
    procedure ODOLineExpand(Sender: TObject; Index: Longint);
    procedure FormDestroy(Sender: TObject);
  private
    { Private declarations }
    StoreCoord,
    LastCoord,
    SetDefault,
    StillInNeedData,
    PrintedPOR,
    ClsViaBtn,
    GotCoord     :   Boolean;

    LODDMode     :   Byte;

    WORSelected  :  Integer;
    
    ExLocal      :  TdExLocal;

    DispTrans    :  TFInvDisplay;
    //GS: 08/03/2012 ABSEXCH-9761
    //changed 'DispCust' declaration to an array; so that customer and supplier
    //forms can have their own TFCustDisplay object, instead of sharing! (as this causes a crash when loading a cust + supp rec!)
    DispCust     :  Array [0..1] of TFCustDisplay;
    {$IFDEF Nom}
      DispNom    :  TNomView;
    {$ENDIF}
    {$IFDEF Stk}
      DispStk    :  TFStkDisplay;
      {$IFDEF SOP}
        DispStkTree:  TStkView;

        
      {$ENDIF}

      OMTExLocal  :  tdPostExLocalPtr;

      OThisScrt   :  Scratch2Ptr;
    {$ENDIF}

    {$IFDEF JC}
      DispJob    :  TFJobDisplay;
      DispJobTree:  TJobView;

      DispVch    :  TFJobDisplay;

      DispEmp    :  TFJobDisplay;
    {$ENDIF}


    procedure Find_FormCoord;

    procedure Store_FormCoord(UpMode  :  Boolean);

    Procedure CreateParams(Var Params  :  TCreateParams); Override;

    Procedure WMFormCloseMsg(Var Message  :  TMessage); Message WM_FormCloseMsg;

    Procedure WMCustGetRec(Var Message  :  TMessage); Message WM_CustGetRec;

    Procedure Send_UpdateList(Mode   :  Integer);

    procedure SetFormProperties(SetList  :  Boolean);

    procedure DestroyNodes;

    Function BuildOLevel(Idx  :  Integer;
                         NTit :  Str80)  :  Integer;


    procedure BuildOAccount(Idx  :  Integer;
                            NTit :  Str80;
                            NCode:  Str10);


    {$IFDEF STK}
      procedure BuildOStock(Idx   :  Integer;
                            NCode :  Str20);

      {$IFDEF WOP}
        Function Get_WORDet(ORef  :  Str10)  :  Str255;


        Function FindTopWOR(Var WORInv  :  InvRec)  :  Boolean;

        Procedure BuildOWORChildren(WORInv,
                                    ParentInv
                                            :  InvRec;
                                    Idx     :  Integer;
                                    PIsWOR  :  Boolean;
                                    WORMatch:  Str255);

        Procedure BuildOWORTree(Idx  :  Integer; WORMatch  :  Str255);


      {$ENDIF}
      {$IFDEF SOP}
         Function Get_SORDet(ORef  :  Str10)  :  Str255;

         procedure Display_StkTree(Mode  :  Byte;
                                   CCode :  Str10);

         Procedure Build_SNos(Idx  :  Integer);




       {$ENDIF}

       {$IFDEF STK}
          Procedure Build_Bins(Idx  :  Integer);
       {$ENDIF}

       procedure BuildWORList(Idx       :  Integer;
                              WORDRec   :  Pointer);

       procedure BuildPORList(Idx   :  Integer);

       procedure Run_PrintPOR;

       {$IFDEF RET}
         procedure BuildORetLinks(Idx   :  Integer;
                                  OKey  :  Str255);
       {$ENDIF}

    {$ENDIF}

    Procedure Build_Links(Idx  :  Integer;
                          BKey :  Str255);

    {$IFDEf PF_On}

      procedure BuildOJob(Idx   :  Integer;
                          NCode :  Str20);
    {$ENDIF}

    {$IFDEF JC}

      procedure BuildOEmployee(Idx  :  Integer;
                               NTit :  Str80;
                               NCode:  Str10;
                               ShowSupp
                                    :  Boolean);

      procedure BuildOPayRate(Idx   :  Integer;
                              NCode :  Str20);

      procedure BuildCISMatch(Idx   :  Integer);

      {$IFDEF JAP}
        Function Chk_App(ORef      :  Str10;
                         CtrlDocs  :  Boolean)  :  Boolean;


        Function FindTopJAP(Var JAPInv  :  InvRec)  :  Boolean;

        Procedure BuildOJAPChildren(JAPInv,
                                    ParentInv
                                            :  InvRec;
                                    Idx     :  Integer;
                                    PIsJAP  :  Boolean;
                                    JAPMatch:  Str255);

        Procedure BuildOJAPTree(Idx  :  Integer; JAPMatch  :  Str255);

      {$ENDIF}

    {$ENDIF}
    procedure BuildONominal(Idx   :  Integer;
                            NCode :  LongInt);

    procedure BuildOCustomMatch(Idx   :  Integer);

    procedure BuildOMatch(Idx   :  Integer);

    {$IFDEF SOP}
    // CJS 2014-08-28 - v7.x Order Payments - T080 - extend Object-Drill for Order Payment matching
    procedure BuildOrderPaymentsMatch(NodeIndex: Integer);
    {$ENDIF}

    procedure Display_Trans(Mode  :  Byte);

    procedure Display_Account(Mode  :  Byte);

    procedure Display_Nominal(Mode  :  Byte;
                              CCode :  Str10;
                              CCMode:  Boolean);

    procedure Display_Stock(Mode  :  Byte);

    procedure Display_Job(Mode  :  Byte);

    procedure Display_Vch(Mode  :  Byte);

    procedure Display_Emp(Mode  :  Byte);

    procedure Display_JobTree(Mode  :  Byte;
                              CCode :  Str10);

    Procedure ObjDrillLink(Idx  :  Integer);

  public
    { Public declarations }
    procedure BuildObjectDrill;

    {$IFDEF Stk}
      {*EN431MB2B*}
        procedure BuildB2BList(SORInv     :  InvRec;
                               MTExLocal  :  tdPostExLocalPtr;
                               ThisScrt   :  Scratch2Ptr);

    {$ENDIF}

  end;


  {*EN431MB2B*}
  Procedure Set_ODDMode(DM  :  Byte);

{~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~}

Implementation

{~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~}


Uses
  ExtCtrls,
  ETStrU,
  ETDateU,
  ETMiscU,
  VARRec2U,
  CurrncyU,
  Mask,

  {$IFDEF DBD}
    DebugU,
  {$ENDIF}

  CmpCtrlU,
  ColCtrlU,
  BtrvU2,

  {$IFDEF STK}
    ComnUnit,
    {$IFDEF Frm}
      PrintFrm,
      FrmThrdU,
    {$ENDIF}

    {.$IFDEF WOP}
      OutLine,

    {.$ENDIF}

    ExtGetU,

  {$ENDIF}

  ComnU2,
  BtKeys1U,
  BtSupU2,
  SysU2,

  {$IFDEF LTR}
    Letters,
    LettrDlg,
  {$ENDIF}

  {$IFDEF JC}
    VarJCStU,
    JobSup1U,

    IntMU,
    CISSup1U,

    {$IFDEF JAP}
      JobSup2U,

    {$ENDIF}
  {$ENDIF}

  PWarnU,
  InvListU,
  EntMiscFuncs;


{$R *.DFM}


Type
  ODDType  =  Record

                NKeypath,
                NLKeypath,
                NLFnum,
                NFnum    :   Integer;
                NLKey,
                NKey     :  Str255;
                NCustSupp:  Char;
                NNeedData:  Boolean;
                NMiscMode:  Byte;
              end; {Rec..}

{*EN431MB2B*}
Var
  ODDMode  :  Byte;


{== Procedure to set the Drill down display mode ==}

Procedure Set_ODDMode(DM  :  Byte);

Begin
  If (ODDMode<>DM) then
    ODDMode:=DM;

end;





procedure TObjDFrm.Find_FormCoord;


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

    PrimeKey:='O';

    If (GetbtControlCsm(ThisForm)) then
    Begin
      {StoreCoord:=(ColOrd=1); v4.40. To avoid on going corruption, this is reset each time its loaded}
      StoreCoord:=BOff;
      HasCoord:=(HLite=1);
      LastCoord:=HasCoord;

      If (HasCoord) then {* Go get postion, as would not have been set initianly *}
        SetPosition(ThisForm);

    end;

    If GetbtControlCsm(ODOLine) then
    Begin
      ODOLine.BarColor:=HLite;
      ODOLine.BarTextColor:=HTLite;
    end;


  end; {With GlobComp..}


  Dispose(GlobComp,Destroy);


end;


procedure TObjDFrm.Store_FormCoord(UpMode  :  Boolean);


Var
  GlobComp:  TGlobCompRec;


Begin

  New(GlobComp,Create(BOff));

  With GlobComp^ do
  Begin
    GetValues:=UpMode;

    PrimeKey:='O';

    ColOrd:=Ord(StoreCoord);

    HLite:=Ord(LastCoord);

    SaveCoord:=StoreCoord;

    If (Not LastCoord) then {* Attempt to store last coord *}
      HLite:=ColOrd;

    StorebtControlCsm(Self);

    HLite:=ODOLine.BarColor;
    HTLite:=ODOLine.BarTextColor;

    StorebtControlCsm(ODOLine);

  end; {With GlobComp..}

  Dispose(GlobComp,Destroy);
end;


procedure TObjDFrm.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
begin
  CanClose:=Not StillInNeedData;

  GenCanClose(Self,Sender,CanClose,BOn);

  If (CanClose) then
  Begin
  {* Inform parent closing *}

    Store_FormCoord(Not SetDefault);


    {$IFDEF STK}
      If (LODDMode In [1,2]) and (ClsViaBtn) then
      Begin
        Run_PrintPOR;
      end
      else
        If (LODDMode<>1) then
    {$ENDIF}
        Send_UpdateList(45);

  end;

end;

procedure TObjDFrm.DestroyNodes;

Var
  n       : Integer;
  ONomRec :  ^ODDType;

Begin
  With ODOLine do {* Tidy up attached objects *}
  Begin
    For n:=1 to ItemCount do
    Begin
      ONomRec:=Items[n].Data;
      If (ONomRec<>nil) then
        Dispose(ONomRec);
    end;
  end; {With..}
end;


procedure TObjDFrm.FormClose(Sender: TObject; var Action: TCloseAction);


begin

  DestroyNodes;

  ExLocal.Destroy;

  Action:=caFree;

end;


Procedure TObjDFrm.CreateParams(Var Params  :  TCreateParams);
Begin
  Inherited CreateParams(Params);

  {Params.WndParent:=Application.Handle;}
end;

procedure TObjDFrm.FormCreate(Sender: TObject);

Begin
  LODDMode:=ODDMode;

  ExLocal.Create;


  ClientHeight:=225;
  ClientWidth:=233;

  WORSelected:=0;

  GotCoord:=BOff;

  DispTrans:=nil;
  //GS: 08/03/2012 ABSEXCH-9761:
  //modified 'DispCust' initialization code to work with the new array definition
  DispCust[0]:=nil;
  DispCust[1]:=nil;

  {$IFDEF Nom}
    DispNom:=nil;
  {$ENDIF}

  {$IFDEF Stk}
    DispStk:=nil;
  {$ENDIF}

  {$IFDEF JC}
    DispJob:=nil;
    DispJobTree:=nil;

    DispVch:=nil;
    DispEmp:=nil;
  {$ENDIF}


  Find_FormCoord;

  StillInNeedData:=BOff;
  PrintedPOR:=BOff;
  ClsViaBtn:=BOff;

  GotCoord:=BOn;

    Case LODDMode of
      1,2  :  Visible:=BOff;
      else  BuildObjectDrill;
    end;

  ODOLine.TreeColor   := ODOLine.Font.Color;

  FormReSize(Self);
end;


procedure TObjDFrm.FormDestroy(Sender: TObject);
begin
  If (Not PrintedPOR) and (LODDMode In [1,2]) then
  Begin
    {$IFDEF STK}

      If (Assigned(OThisScrt)) then
        Dispose(OThisScrt,Done);

      Dispose(OMTExLocal,Destroy);

    {$ENDIF}

  end;
end;

procedure TObjDFrm.FormResize(Sender: TObject);
begin
  If (GotCoord) then
  Begin
    ODOLine.Width:=ClientWidth-1;
    ODOLine.Height:=ClientHeight-35;

    ClsI1Btn.Top:=ClientHeight-27;
    ClsI1Btn.Left:=Round(DivWChk(ClientWidth,2)-DivWChk(ClsI1Btn.Width,2));
  end;


end;

procedure TObjDFrm.PropFlgClick(Sender: TObject);
begin
  SetFormProperties(BOff);
end;

procedure TObjDFrm.StoreCoordFlgClick(Sender: TObject);
begin
  StoreCoord:=Not StoreCoord;
end;

procedure TObjDFrm.PopupMenu1Popup(Sender: TObject);
begin
  StoreCoordFlg.Checked:=StoreCoord;
end;

Procedure TObjDFrm.WMFormCloseMsg(Var Message  :  TMessage);


Begin

  With Message do
  Begin

    Case WParam of

      0 :  ;

      {$IFDEF Nom}

        40  :  DispNom:=nil;

      {$ENDIF}

      
      {$IFDEF STK}

        46  :  {$IFDEF SOP}
                  If (LParam=-1) then
                    DispStkTree:=nil
                 else
               {$ENDIF}
                 DispStk:=nil;

      {$ENDIF}

      {$IFDEF JC}

        55  :  DispJobTree:=nil;

      {$ENDIF}

    end; {Case..}

  end;
  Inherited;
end;

Procedure TObjDFrm.WMCustGetRec(Var Message  :  TMessage);


Begin

  With Message do
  Begin

    Case WParam of

    
    {$IFDEF SOP}
       19  :  SerStkRec:=nil;
    {$ENDIF}

    {$IFDEF STK}
       28  :  BinStkRec:=nil;
    {$ENDIF}

    {$IFDEF JC}

        36  :  DispJob:=nil;

        37  :  DispVch:=nil;

        38  :  DispEmp:=nil;

    {$ENDIF}

      167  :  ODOLine.SelectedItem:=WORSelected;

      168  :  ODOLine.Items[LParam].FullExpand;

      169  : With ODOLine do
               Items[SelectedItem].Expand;

      200
           :  DispTrans:=nil;


      
    end; {Case..}

  end;
  Inherited;
end;


{ == Procedure to Send Message to Get Record == }

Procedure TObjDFrm.Send_UpdateList(Mode   :  Integer);

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


procedure TObjDFrm.SetFormProperties(SetList  :  Boolean);


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

    With ODOLine do
    Begin
      TmpPanel[1].Font:=Font;
      TmpPanel[1].Color:=Color;

      TmpPanel[2].Font:=Font;
      TmpPanel[2].Color:=Color;


      TmpPanel[3].Color:=BarColor;
      TmpPanel[3].Font.Assign(TmpPanel[1].Font);
      TmpPanel[3].Font.Color:=BarTextColor;
    end;



    ColourCtrl:=TCtrlColor.Create(Self);

    try
      With ColourCtrl do
      Begin
        SetProperties(TmpPanel[1],TmpPanel[2],TmpPanel[3],1,Self.Caption+' Properties',BeenChange,ResetDefaults);


        If (BeenChange) and (not ResetDefaults) then
        Begin

          With ODOLine do
          Begin
            Font.Assign(TmpPanel[1].Font);
            Color:=TmpPanel[1].Color;

            {NLDPanel.Font.Assign(TmpPanel[2].Font);
            NLDPanel.Color:=TmpPanel[2].Color;}


            BarColor:=TmpPanel[3].Color;
            BarTextColor:=TmpPanel[3].Font.Color;

            {NLCrPanel.Font.Assign(TmpPanel[2].Font);
            NLCrPanel.Color:=TmpPanel[2].Color;

            NLDrPanel.Font.Assign(TmpPanel[2].Font);
            NLDrPanel.Color:=TmpPanel[2].Color;}

            ODOLine.TreeColor   := ODOLine.Font.Color;

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


procedure TObjDFrm.ClsI1BtnClick(Sender: TObject);
begin
  ClsViaBtn:=BOn;
  Close;
end;

procedure TObjDFrm.ODOLineExpand(Sender: TObject; Index: Longint);
begin
  With ODOLine do
    If (Not Items[Index].HasItems) then
    Begin
      ObjDrillLink(Index);
    end;
end;

{ ===== Build Node Lines ===== }

Function TObjDFrm.BuildOLevel(Idx  :  Integer;
                              NTit :  Str80)  :  Integer;

Var
  ODDRec    :  ^ODDType;

Begin
  With ODOLine do
  Begin
    New(ODDRec);

    FillChar(ODDRec^,Sizeof(ODDRec^),0);

    Result:=AddChildObject(Idx,NTit,ODDRec);

  end; {With..}

end;



procedure TObjDFrm.BuildOAccount(Idx  :  Integer;
                                 NTit :  Str80;
                                 NCode:  Str10);

Var
  n,NIdx
            :  Integer;
  ODDRec    :  ^ODDType;
  FoundCode :  Str20;

Begin
  With ODOLine,ExLocal,LInv do
  Begin
    If (Cust.CustCode<>NCode) then
      GetCust(Self,NCode,FoundCode,BOff,-1);

    New(ODDRec);

    FillChar(ODDRec^,Sizeof(ODDRec^),0);

    With ODDRec^ do
    Begin
      NFnum:=CustF;
      NKey:=NCode;
      NCustSupp:=Cust.CustSupp;
    end;

    If (NTit='') then
      nIdx:=BuildOLevel(Idx,'Account')
    else
      nIdx:=Idx;

    n:=AddChildObject(nIdx,NTit+' '+dbFormatName(NCode,Cust.Company),ODDRec);

    {$IFDEF LTR}

    With Cust do
      If (AdbHasData(Ord(IsACust(CustSupp)),CustCode)) then
      Begin
        New(ODDRec);

        FillChar(ODDRec^,Sizeof(ODDRec^),0);

        With ODDRec^ do
        Begin
          NFnum:=MiscF;
          NNeedData:=BOn;
          NKey:=FullQDKey(LetterTCode,CustSupp,CustCode);
          NMiscMode:=1;
        end;

        n:=AddChildObject(nIdx,'Account links to additional information',ODDRec);

      end;

    {$ENDIF}

  end; {With..}

end;




{$IFDEF STK}

  procedure TObjDFrm.BuildOStock(Idx   :  Integer;
                                 NCode :  Str20);

  Var
    n,nIdx
              :  Integer;

    ODDRec    :  ^ODDType;

    FoundCode :  Str20;

  Begin
    With ODOLine,ExLocal,LInv do
    Begin
      If (Stock.StockCode<>NCode) then
        GetStock(Self,NCode,FoundCode,-1);

      LStock:=Stock;

      New(ODDRec);

      FillChar(ODDRec^,Sizeof(ODDRec^),0);

      With ODDRec^ do
      Begin
        NFnum:=StockF;
        NKey:=NCode;
      end;

      nIdx:=BuildOLevel(Idx,'Stock Details');

      n:=AddChildObject(nIdx,dbFormatName(NCode,Stock.Desc[1]),ODDRec);

      If (Not EmptyKey(Stock.Supplier,CustKeyLen)) then
        BuildOAccount(nIdx,'Supplier',Stock.Supplier);


      If (LId.BinQty<>0) then
      Begin
        New(ODDRec);

        FillChar(ODDRec^,Sizeof(ODDRec^),0);

        With ODDRec^ do
        Begin
          NFnum:=MLocF;
          NNeedData:=BOn;
          NMiscMode:=3;
        end;


        n:=AddChildObject(nIdx,'Bin Locations : '+Form_Real(LId.BinQty,0,Syss.NoQtyDec),ODDRec);


      end;

      {$IFDEF SOP}
        If (Not EmptyKey(LId.MLocStk,MLocKeyLen)) and (Syss.UseMLoc) then
        Begin
          New(ODDRec);

          FillChar(ODDRec^,Sizeof(ODDRec^),0);

          With ODDRec^ do
          Begin
            NFnum:=MLocF;
            {* EX32 needs conecting to cc/Dep record *}
            NKey:=FullCCKey(CostCCode,CSubCode[BOn],LId.MLocStk);
            NLKey:=NCode;
            NLFNum:=StockF;
            Global_GetMainRec(NFnum,NKey);
          end;


          n:=AddChildObject(nIdx,'Location : '+dbFormatName(LId.MLocStk,MLocCtrl^.MlocLoc.loName),ODDRec);


        end;


        If (Is_SerNo(LStock.StkValType)) and (LId.SerialQty<>0) then
        Begin
          New(ODDRec);

          FillChar(ODDRec^,Sizeof(ODDRec^),0);

          With ODDRec^ do
          Begin
            NFnum:=MiscF;
            NNeedData:=BOn;
          end;


          n:=AddChildObject(nIdx,'Serial & Batch Numbers : '+Form_Real(LId.SerialQty,0,Syss.NoQtyDec),ODDRec);


        end;
      {$ENDIF}


      {$IFDEF LTR}
      With Stock do
        If (AdbHasData(3,FullNomKey(StockFolio))) then
        Begin
          New(ODDRec);

          FillChar(ODDRec^,Sizeof(ODDRec^),0);

          With ODDRec^ do
          Begin
            NFnum:=MiscF;
            NNeedData:=BOn;
            NKey:=FullQDKey(LetterTCode,AdbType(3),FullNomKey(StockFolio));
            NMiscMode:=1;
          end;

          n:=AddChildObject(nIdx,'Stock links to additional information',ODDRec);

        end;
      {$ENDIF}

    end; {With..}

  end;

{$ENDIF}


{$IFDEF PF_On}

  procedure TObjDFrm.BuildOJob(Idx   :  Integer;
                               NCode :  Str20);

  Var
    n,nIdx
              :  Integer;
    ODDRec    :  ^ODDType;
    FoundCode :  Str20;

  Begin
    With ODOLine,ExLocal,LInv do
    Begin
      If (JobRec^.JobCode<>NCode) then
        GetJob(Self,NCode,FoundCode,-1);

      New(ODDRec);

      FillChar(ODDRec^,Sizeof(ODDRec^),0);

      With ODDRec^ do
      Begin
        NFnum:=JobF;
        NKey:=NCode;
      end;

      nIdx:=BuildOLevel(Idx,'Job Details');

      n:=AddChildObject(nIdx,dbFormatName(NCode,JobRec^.JobDesc),ODDRec);

      If (Not EmptyKey(JobRec^.CustCode,CustKeyLen)) then
        BuildOAccount(nIdx,'Account',JobRec^.CustCode);

      New(ODDRec);

      FillChar(ODDRec^,Sizeof(ODDRec^),0);

      With ODDRec^ do
      Begin
        NFnum:=JMiscF;
        NLFnum:=JobF;
        NLKey:=FullJobCode(NCode);

        GetJobMisc(Self,LId.AnalCode,FoundCode,2,-1);

        With JobMisc^,JobAnalRec do
          NKey:=PartCCKey(RecPFix,SubType)+JAnalCode;
      end;

      With JobMisc^.JobAnalRec do
        n:=AddChildObject(nIdx,dbFormatName(JAnalCode,JAnalName),ODDRec);

      {$IFDEF LTR}
      With JobRec^ Do
      Begin
        If AdbHasData(4,FullNomKey(JobFolio)) Then
        Begin
          New(ODDRec);

          FillChar(ODDRec^,Sizeof(ODDRec^),0);

          With ODDRec^ do
          Begin
            NFnum:=MiscF;
            NNeedData:=BOn;
            NKey:=FullQDKey(LetterTCode,AdbType(4),FullNomKey(JobFolio));
            NMiscMode:=1;
          end;

          n:=AddChildObject(nIdx,'Job links to additional information',ODDRec);
        End; { If }
      End; { With }
      {$ENDIF}
    end; {With..}

  end;

{$ENDIF}


{$IFDEF JC}
   procedure TObjDFrm.BuildOEmployee(Idx  :  Integer;
                                     NTit :  Str80;
                                     NCode:  Str10;
                                     ShowSupp
                                          :  Boolean);

Var
  n,NIdx
            :  Integer;
  ODDRec    :  ^ODDType;
  FoundCode :  Str20;

Begin
  With ODOLine,ExLocal,LInv do
  Begin
    If (JobMisc^.EmplRec.EmpCode<>NCode) then
      GetJobMisc(Self,NCode,FoundCode,3,-1);

    New(ODDRec);

    FillChar(ODDRec^,Sizeof(ODDRec^),0);

    With ODDRec^ do
    Begin
      NFnum:=JMiscF;
      NKey:=PartCCKey(JARCode,JASubAry[3])+NCode;
      NKeypath:=JMK;
    end;

    If (NTit='') then
      nIdx:=BuildOLevel(Idx,'Employee/Sub Contractor')
    else
      nIdx:=Idx;

    n:=AddChildObject(nIdx,NTit+' '+dbFormatName(NCode,JobMisc^.EmplRec.EmpName),ODDRec);

    If (ShowSupp) then
    With JobMisc^.EmplRec do
    Begin
      If (Not EmptyKey(Supplier,CustKeyLen)) then
        BuildOAccount(nIdx,'Supplier',Supplier);

      {$IFDEF LTR}
      If (AdbHasData(Ord(IsACust(CustSupp)),CustCode)) then
      Begin
        New(ODDRec);

        FillChar(ODDRec^,Sizeof(ODDRec^),0);

        With ODDRec^ do
        Begin
          NFnum:=MiscF;
          NNeedData:=BOn;
          NKey:=FullQDKey(LetterTCode,CustSupp,CustCode);
          NMiscMode:=1;
        end;

        n:=AddChildObject(nIdx,'Account links to additional information',ODDRec);

      end;
      {$ENDIF}
    end;
  end; {With..}

end;

  procedure TObjDFrm.BuildOPayRate(Idx   :  Integer;
                                   NCode :  Str20);

  Var
    n,nIdx
              :  Integer;
    ODDRec    :  ^ODDType;
    ThisDesc  :  Str255;
    FoundCode :  Str20;

  Begin
    With ODOLine,ExLocal,LInv do
    Begin
      {If (JobCtrl^.EmplPay.EStockCode<>NCode) then}

      ThisDesc:=Get_StdPrDesc(NCode,JCtrlF,JCK,0);

      New(ODDRec);

      FillChar(ODDRec^,Sizeof(ODDRec^),0);

      With ODDRec^ do
      Begin
        NFnum:=JCtrlF;
        NKey:=NCode;
      end;

      nIdx:=BuildOLevel(Idx,'Pay Rate');

      n:=AddChildObject(nIdx,dbFormatName(NCode,ThisDesc),ODDRec);


    end; {With..}

  end;

{$ENDIF}

procedure TObjDFrm.BuildONominal(Idx   :  Integer;
                                 NCode :  LongInt);

Var
  n,nIdx
            :  Integer;
  ODDRec    :  ^ODDType;

  TBo       :  Boolean;
  FoundCode :  Str20;

  FoundLong :  LongInt;

Begin
  With ODOLine,ExLocal,LInv do
  Begin
    If (Nom.NomCode<>NCode) then
      GetNom(Self,Form_Int(NCode,0),FoundLong,-1);

    New(ODDRec);

    FillChar(ODDRec^,Sizeof(ODDRec^),0);

    With ODDRec^ do
    Begin
      NFnum:=NomF;

      NKey:=FullNomKey(NCode);
    end;


    nIdx:=BuildOLevel(Idx,'General Ledger');

    n:=AddChildObject(nIdx,dbFormatName(Form_Int(NCode,0),Nom.Desc),ODDRec);

    If (Syss.UseCCDep) then
    Begin

      For TBo:=BOff to BOn do
      Begin
        If (Not EmptyKeyS(LId.CCDep[TBo],CCKeyLen,BOff)) then
        Begin
          New(ODDRec);

          FillChar(ODDRec^,Sizeof(ODDRec^),0);

          With ODDRec^ do
          Begin
            NFnum:=PWrdF;
            {* EX32 needs conecting to cc/Dep record *}
            NKey:=FullCCKey(CostCCode,CSubCode[TBo],LId.CCDep[TBo]);
            NLFnum:=NomF;
            NLKey:=FullNomKey(NCode);
          end;


          GetCCDep(Self,LId.CCDep[TBo],FoundCode,TBo,-1);

          n:=AddChildObject(nIdx,CostCtrRTitle[TBo]+' '+dbFormatName(LId.CCDep[TBo],PassWord.CostCtrRec.CCDesc),ODDRec);
        end;
      end; {Loop..}
    end;

  end; {With..}

end;


{$IFDEF SOP}
  Function TObjDFrm.Get_SORDet(ORef  :  Str10)  :  Str255;

  Var
    TmpInv  :  InvRec;

  Begin
    TmpInv:=Inv;

    If (CheckRecExsists(ORef,InvF,InvOurRefK)) then
      Result:=FormatCurFloat(GenRealMask,ITotal(Inv)-Inv.InvVat,BOff,Inv.Currency)
    else
      Result:='';

    Inv:=TmpInv;
  end;


{$ENDIF}


{$IFDEF WOP}
  Function TObjDFrm.Get_WORDet(ORef  :  Str10)  :  Str255;

  Var
    TmpInv  :  InvRec;
    TmpId   :  Idetail;

  Begin
    TmpInv:=Inv;  TmpId:=Id;

    If (CheckRecExsists(ORef,InvF,InvOurRefK)) and (CheckRecExsists(FullIdKey(Inv.FolioNum,1),IdetailF,IdLinkK)) then
      Result:=Form_Real(WORReqQty(Id),0,Syss.NoQtyDec)+' x '+Trim(Id.StockCode)
    else
      Result:='';

    Inv:=TmpInv; Id:=TmpId;
  end;


{$ENDIF}


{$IFDEF JAP}
  Function TObjDFrm.Chk_App(ORef      :  Str10;
                            CtrlDocs  :  Boolean)  :  Boolean;

  Var
    n  :  DocTypes;

  Begin
    Result:=BOff;

    For n:=JCT to JPA do
    If (n In JAPOrdSplit+[JPT]) or (Not CtrlDocs) then
    Begin
      Result:=(DocCodes[n]=ORef);

      If (Result) then
        Break;
    end; {Loop..}

  end;


{$ENDIF}


procedure TObjDFrm.BuildOCustomMatch(Idx   :  Integer);

Const
  Fnum  =  PWrdF;

  CMChr  :  Array[3..7] of Char = ('0','1','2','3','4');

Var
  n,nIdx,ACnst,
  Keypath
            :  Integer;
  ODDRec    :  ^ODDType;

  KeyS,KeyChk
            :  Str255;
  MCType    :  Byte;

  MLoop,
  NeedHed,
  GotWOR,
  Ok2Add    :  Boolean;

  Rnum      :  Real;
  OLine     :  Str255;


Begin
  With ODOLine,ExLocal,LInv do
  Begin

    NeedHed:=BOn;  GotWOR:=BOff; Ok2Add:=BOn;

    MLoop:=BOff;

    Repeat
      MCType:=Low(CMChr);

      If (MLoop) then
        Keypath:=PWK
      else
        Keypath:=HelpNDXK;

      Repeat

        KeyChk:=FullMatchKey(MatchTCode,CMChr[MCType],OurRef);
        KeyS:=KeyChk;

        Status:=Find_Rec(B_GetGEq,F[Fnum],Fnum,RecPtr[Fnum]^,KeyPath,KeyS);


        While (StatusOK) and (CheckKey(KeyChk,KeyS,Length(KeyChk),BOff)) do
        With Password.MatchPayRec do
        Begin
          If (NeedHed) then
          Begin
            nIdx:=BuildOLevel(Idx,'Additonal Matching');

            NeedHed:=BOff;
          end;

          New(ODDRec);

          FillChar(ODDRec^,Sizeof(ODDRec^),0);

          Ok2Add:=BOn;

          With ODDRec^ do
          Begin
            NFnum:=InvF;
            NKeypath:=InvOurRefK;
            Case Keypath of
              PWK       :  Begin
                             NKey:=FullOurRefKey(PayRef);
                             ACnst:=1;
                           end;
              HelpNdxK  :  Begin
                             NKey:=FullOurRefKey(DocCode);
                             ACnst:=1;
                           end;
            end; {Case..}

            Rnum:=OwnCVal*ACnst;
            OLine:=FormatCurFloat(GenRealMask,Rnum,BOff,MCurrency);

            n:=AddChildObject(nIdx,' '+NKey+'. '+AltRef+'. '+OLine,ODDRec);

          end; {With..}


          Status:=Find_Rec(B_GetNext,F[Fnum],Fnum,RecPtr[Fnum]^,KeyPath,KeyS);

        end; {While..}

        Inc(MCType);
      Until (MCType>High(CMChr));

      MLoop:=Not MLoop;

    Until (Not MLoop);

  end; {With..}

end;


procedure TObjDFrm.BuildOMatch(Idx   :  Integer);

Const
  Fnum  =  PWrdF;

Var
  n,nIdx,ACnst,
  Keypath
            :  Integer;
  ODDRec    :  ^ODDType;

  KeyS,KeyChk
            :  Str255;
  Loop,
  NeedHed,
  GotJAP,

  GotRet,

  GotWOR,
  Ok2Add    :  Boolean;

  Rnum      :  Real;
  OLine     :  Str255;


Begin
  With ODOLine,ExLocal,LInv do
  Begin

    NeedHed:=BOn;  GotWOR:=BOff; Ok2Add:=BOn; nIdx:=Idx; GotJap:=BOff;  Loop:=BOff;

    GotRet:=BOff;

    Repeat
      If ((RemitNo<>'') or (OrdMatch) or (InvDocHed In [ADJ,TSH])) or (Loop) then
        Keypath:=PWK
      else
        Keypath:=HelpNDXK;

      KeyChk:=FullMatchKey(MatchTCode,MatchSCode,OurRef);
      KeyS:=KeyChk;

      Status:=Find_Rec(B_GetGEq,F[Fnum],Fnum,RecPtr[Fnum]^,KeyPath,KeyS);


      While (StatusOK) and (CheckKey(KeyChk,KeyS,Length(KeyChk),BOff)) do
      With Password.MatchPayRec do
      Begin
        If (NeedHed) then
        Begin
          nIdx:=BuildOLevel(Idx,'Matching Information');

          NeedHed:=BOff;
        end;

        New(ODDRec);

        FillChar(ODDRec^,Sizeof(ODDRec^),0);

        Ok2Add:=BOn;

        With ODDRec^ do
        Begin
          NFnum:=InvF;
          NKeypath:=InvOurRefK;
          Case Keypath of
            PWK       :  Begin
                           NKey:=PayRef;
                           ACnst:=-1;
                         end;
            HelpNdxK  :  Begin
                           NKey:=DocCode;
                           ACnst:=1;
                         end;
          end; {Case..}

          Rnum:=OwnCVal*ACnst;
          OLine:=FormatCurFloat(GenRealMask,Rnum,BOff,MCurrency);


          {$IFDEF SOP}
            If (Copy(Nkey,1,3)=DocCodes[SOR]) and (InvDocHed In [POR]) then {We have a back to back match need SOR details}
               OLine:=Get_SORDet(NKey);
          {$ENDIF}

          {$IFDEF WOP}
            If (Copy(Nkey,1,3)=DocCodes[WOR]) and (InvDocHed In [SOR,WOR]) then
            Begin
              If (Not GotWOR) or (InvDocHed=SOR) then
              Begin
                GotWOR:=BOn;
                NFnum:=MiscF;
                NNeedData:=BOn;
                NMiscMode:=2;



                If (InvDocHed<>SOR) then
                Begin
                  NKey:=OurRef;
                  OLine:='ObjectWOR View.';
                end
                else
                Begin
                  OLine:=Get_WORDet(NKey)+'. ';

                end;

              end
              else
                Ok2Add:=BOff;
            end;

          {$ENDIF}

          {$IFDEF JAP}
            If ((Chk_App(Copy(Nkey,1,3),BOff)) or (InvDocHed In JAPOrdSplit+[JPT])) and (InvDocHed In JAPSplit) then
            Begin
              If (Not GotJAP) then
              Begin
                GotJAP:=BOn;
                NFnum:=MiscF;
                NNeedData:=BOn;
                NMiscMode:=3;
                NKey:=OurRef;
                OLine:='ObjectApp View.';

              end
              else
                Ok2Add:=BOff;
            end;

          {$ENDIF}

          {$IFDEF RET}
            If (Copy(Nkey,1,3)=DocCodes[PRN]) or (Copy(Nkey,1,3)=DocCodes[SRN]) then
            Begin
              If (Not GotRET) then
              Begin
                GotRET:=BOn;
                NFnum:=MiscF;
                NNeedData:=BOn;
                NMiscMode:=4;
                OLine:=Oline+'. ObjectRet';

              end
              else
                Ok2Add:=BOff;
            end;

          {$ENDIF}


          If (Ok2Add) then
            n:=AddChildObject(nIdx,' '+NKey+'. '+OLine,ODDRec);

        end; {With..}


        Status:=Find_Rec(B_GetNext,F[Fnum],Fnum,RecPtr[Fnum]^,KeyPath,KeyS);

      end; {While..}


      Loop:=Not Loop;

    Until (Not Loop) or (Not (InvDocHed In StkRetSplit));


    BuildOCustomMatch(nIdx);

    // CJS 2014-08-28 - v7.x Order Payments - T080 - extend Object-Drill for Order Payment matching
    {$IFDEF SOP}
    BuildOrderPaymentsMatch(nIdx);
    {$ENDIF}

  end; {With..}

end;

{$IFDEF SOP}
// CJS 2014-08-28 - v7.x Order Payments - T080 - extend Object-Drill for Order Payment matching
procedure TObjDFrm.BuildOrderPaymentsMatch(NodeIndex: Integer);
const
  Fnum = PWrdF;
var
  HeadNodeIndex  : Integer;
  SignMultiplier : Integer;
  Keypath        : Integer;
  ODDRec         : ^ODDType;
  KeyS           : Str255;
  KeyChk         : Str255;
  MLoop          : Boolean;
  AddHeadNode    : Boolean;
  Rnum           : Double;
  LineCaption    : Str255;
Begin

  AddHeadNode := True;
  MLoop       := False;

  // Loop through twice, once to pick up order transactions and once
  // to pick up payment transactions
  repeat

    if (MLoop) then
      // Search for records where this transaction is a payment
      Keypath := PWK
    else
      // Search for records where this transaction is an order
      Keypath := HelpNDXK;

    // Work through all the Auto-Receipt Matching records against this
    // transaction
    KeyChk := FullMatchKey(MatchTCode, MatchOrderPaymentCode, ExLocal.LInv.OurRef);
    KeyS   := KeyChk;

    Status := Find_Rec(B_GetGEq, F[Fnum], Fnum, RecPtr[Fnum]^, KeyPath, KeyS);

    while (StatusOK) and (CheckKey(KeyChk, KeyS, Length(KeyChk), BOff)) do
    begin
      // When we find the first matching record, add the header node
      if (AddHeadNode) then
      begin
        HeadNodeIndex := BuildOLevel(NodeIndex, 'Order Payments Matching');
        AddHeadNode   := False;
      end;

      // Create a record structure to attach to the node, and populate it
      // with the details of the matching transaction
      New(ODDRec);
      FillChar(ODDRec^, Sizeof(ODDRec^), 0);

      ODDRec.NFnum    := InvF;
      ODDRec.NKeypath := InvOurRefK;
      case Keypath of
        PWK       :  begin
                       ODDRec.NKey     := FullOurRefKey(Password.MatchPayRec.PayRef);
                       SignMultiplier := -1;
                     end;
        HelpNdxK  :  begin
                       ODDRec.NKey     := FullOurRefKey(Password.MatchPayRec.DocCode);
                       SignMultiplier := 1;
end;
      end; { case KeyPath... }

      // Build the caption for this node, including the transaction reference
      // and the sign-adjusted value, and add it to the tree
      Rnum  := Password.MatchPayRec.OwnCVal * SignMultiplier;
      LineCaption := ' ' + ODDRec.NKey + '. ' +
                     FormatCurFloat(GenRealMask, Rnum, BOff, Password.MatchPayRec.MCurrency);

      ODOLine.AddChildObject(HeadNodeIndex, LineCaption, ODDRec);

      // Get the next matching record
      Status := Find_Rec(B_GetNext, F[Fnum], Fnum, RecPtr[Fnum]^, KeyPath, KeyS);

    end; { while (StatusOK)... }

    MLoop := Not MLoop;

  until (not MLoop);

end;
{$ENDIF}

{$IFDEF JC}
  procedure TObjDFrm.BuildCISMatch(Idx   :  Integer);

  Const
    Fnum  =  PWrdF;

  Var
    n,nIdx,ACnst,
    Keypath
              :  Integer;
    ODDRec    :  ^ODDType;

    VTit      :  Str30;
    KeyS,KeyChk
              :  Str255;
    NeedHed,
    GotWOR,
    Ok2Add    :  Boolean;

    Rnum      :  Real;
    OLine     :  Str255;


  Begin
    With ODOLine,ExLocal,LInv do
    Begin


      NeedHed:=BOn;  GotWOR:=BOff; Ok2Add:=BOn;  nIdx:=Idx;

      VTit:='';

      If (NeedHed) then
      Begin
        nIdx:=BuildOLevel(Idx,CCCISName^+' Information');

        NeedHed:=BOff;
      end;

      Keypath:=PWK;

      KeyChk:=FullMatchKey(MatchTCode,MatchCCode,OurRef);
      KeyS:=KeyChk;

      Status:=Find_Rec(B_GetGEq,F[Fnum],Fnum,RecPtr[Fnum]^,KeyPath,KeyS);


      While (StatusOK) and (CheckKey(KeyChk,KeyS,Length(KeyChk),BOff)) do
      With Password.MatchPayRec do
      Begin

        New(ODDRec);

        FillChar(ODDRec^,Sizeof(ODDRec^),0);

        Ok2Add:=BOn;

        With ODDRec^ do
        Begin
          NFnum:=JDetlF;
          NKeypath:=JdStkK;

          Case Keypath of
            PWK       :  Begin

                           ACnst:=1;
                         end;
          end; {Case..}

          Rnum:=OwnCVal*ACnst;
          OLine:=FormatCurFloat(GenRealMask,Rnum,BOff,MCurrency);


          If (CheckRecExsists(Trim(CISPrefix+PayRef),NFnum,JDPostedK)) then
          With JobDetl^.JobCISV do
          Begin
            NKey:=CISCertKey(CISCertNo);

            If (CIS340) then
              VTit:='Statement'
            else
              VTit:=GetIntMsg(4);


            n:=AddChildObject(nIdx,VTit+' No. '+Trim(CISCertNo)+'. '+OLine,ODDRec);

          end;

        end; {With..}


        Status:=Find_Rec(B_GetNext,F[Fnum],Fnum,RecPtr[Fnum]^,KeyPath,KeyS);

      end; {While..}

      If (CISEmpl<>'') then
      Begin
        BuildOEmployee(nIdx,'',CISEmpl,BOff);
      end;

    end; {With..}

  end;



{$ENDIF}

procedure TObjDFrm.BuildObjectDrill;

Var
  n,Tmpn    :  Integer;
  ODDRec    :  ^ODDType;
  FoundCode :  Str20;

Begin
  With ODOLine,ExLocal,LInv do
  Begin
    AssignFromGlobal(InvF);
    AssignFromGlobal(IdetailF);

    DestroyNodes;
    Clear;

    New(ODDRec);

    FillChar(ODDRec^,Sizeof(ODDRec^),0);

    With ODDRec^ do
    Begin
      NFnum:=InvF;
      NKeypath:=InvOurRefK;
      NKey:=OurRef;
    end;

    n:=AddChildObject(0,OurRef,ODDRec);



    If (InvDocHed In SalesSplit+PurchSplit+WOPSplit+StkAdjSplit+NOMSplit+TSTSplit+JAPSplit+StkRetSplit) then
    Begin
      If (Trim(CustCode)<>'') then
        BuildOAccount(n,'',CustCode);

      BuildOMatch(n);
    end;


    {$IFDEF STK}

      If (Is_FullStkCode(LId.StockCode)) and (InvDocHed<>TSH) then
        BuildOStock(n,LId.StockCode);

    {$ENDIF}

    {$IFDEF JC}
      If (InvDocHed=TSH) then
        BuildOEmployee(n,'',BatchLink,BOn);

      If (Is_FullStkCode(LId.StockCode)) and (InvDocHed=TSH) then
        BuildOPayRate(n,LId.StockCode);

      If (CISOn) and (CISEmpl<>'') then
      Begin
        BuildCISMatch(n);

      end;

    {$ENDIF}

    If (LId.NomCode<>0) then
      BuildONominal(n,LId.NomCode);

    {$IFDEF PF_On}
      If (Not EmptyKey(LId.JobCode,JobCodeLen)) then
        BuildOJob(n,LId.JobCode);
    {$ENDIF}

    {$IFDEF LTR}
    If (AdbHasData(2,FullNomKey(FolioNum))) then
    Begin

      Tmpn:=BuildOLevel(n,'Miscellaneous Information');

      New(ODDRec);

      FillChar(ODDRec^,Sizeof(ODDRec^),0);

      With ODDRec^ do
      Begin
        NFnum:=MiscF;
        NNeedData:=BOn;
        NKey:=FullQDKey(LetterTCode,AdbType(2),FullNomKey(FolioNum));
        NMiscMode:=1;
      end;

      Tmpn:=AddChildObject(Tmpn,'Links to additional information',ODDRec);

    end;
    {$ENDIF}


    FullExpand;
  end; {With..}

end;


procedure TObjDFrm.Expand1Click(Sender: TObject);
begin
  If (Sender is TMenuItem) then
  With ODOLine do
  Begin
    Case TMenuItem(Sender).Tag of
      1  :  Items[SelectedItem].Expand;
      2  :  Items[SelectedItem].FullExpand;
      3  :  FullExpand;
      4  :  Items[SelectedItem].Collapse;
      5  :  FullCollapse;
    end; {case..}
  end;

end;


{ ======= Link to Trans display ======== }

procedure TObjDFrm.Display_Trans(Mode  :  Byte);

Begin

  ExLocal.LastInv:=ExLocal.LInv;

  ExLocal.AssignFromGlobal(InvF);

  If (DispTrans=nil) then
    DispTrans:=TFInvDisplay.Create(Self);

    try

      With ExLocal,DispTrans do
      Begin
        LastDocHed:=LInv.InvDocHed;

        Display_Trans(Mode,0,BOff,BOn);

      end; {with..}

    except

      DispTrans.Free;

    end;

  ExLocal.LInv:=ExLocal.LastInv;
end;


{ ======= Link to Account display ======== }

procedure TObjDFrm.Display_Account(Mode  :  Byte);
var
  Index: Integer;
Begin
  ExLocal.AssignFromGlobal(CustF);

  //GS: 08/03/2012 ABSEXCH-9761 Adjusted code to use a TFCustDisplay array; previously DispCust was a single
  //TFCustDisplay instance which was causing the ObjDrill to crash when the user attemps to
  //display a customer and supplier list simultaneously. Now customer and supplier forms
  //created from the ObjDrill have their own TFCustDisplay objects

  //Added an 'Index' var, its value is set to the ordinal boolean result
  //of the "Is this record a customer?" function. 0 = customer, 1 = supplier
  Index := Ord(IsACust(ExLocal.LCust.CustSupp));

  //areas where 'DispCust' is used have been modified to use an array instead of a singular instance:

  //if 'DispCust' is uninitialised, then create an intance, and populate it with the record data:

  //create instance
  If (DispCust[Index]=nil) then
  begin
    DispCust[Index]:=TFCustDisplay.Create(Self);
  end;//end if

  //get customer/supplier record
  try
    With DispCust[Index] do
    begin
      Display_Account(IsACust(ExLocal.LCust.CustSupp),0,ExLocal.LInv);
    end;//end with
  except
    DispCust[Index].Free;
  end; {try..}
end;


{ ======= Link to Nominal display ======== }

procedure TObjDFrm.Display_Nominal(Mode  :  Byte;
                                   CCode :  Str10;
                                   CCMode:  Boolean);


Begin

  {$IFDEF Nom}

    ExLocal.AssignFromGlobal(NomF);

    If (DispNom=nil) then
      DispNom:=TNomView.Create(Self);

    try

      With DispNom do
      Begin
        Show;
        PlaceNomCode(ExLocal.LNom.NomCode);

        If (Syss.PostCCNom) and (CCode<>CCNomFilt[CCMode]) then
        Begin
          CCNomMode:=CCMode;

          CCNomFilt[CCNomMode]:=CCode;

          CurrencyClick(Self);
        end;
      end;

    except

      DispNom.Free;

    end; {try..}

  {$ENDIF}
end;

{ ======= Link to Stock display ======== }

procedure TObjDFrm.Display_Stock(Mode  :  Byte);

Begin

  {$IFDEF Stk}

    ExLocal.AssignFromGlobal(StockF);

    If (DispStk=nil) then
      DispStk:=TFStkDisplay.Create(Self);

    try

      With DispStk do
      Begin
        Display_Account(1);
      end;
    except

      DispStk.Free;

    end; {try..}

  {$ENDIF}
end;


{$IFDEF SOP}
  { ======= Link to Nominal display ======== }

  procedure TObjDFrm.Display_StkTree(Mode  :  Byte;
                                     CCode :  Str10);


  Begin

      ExLocal.AssignFromGlobal(StockF);

      If (DispStkTree=nil) then
        DispStkTree:=TStkView.Create(Self);

      try

        With DispStkTree do
        Begin
          Show;

          ExLocal.AssignToGlobal(StockF);

          PlaceNomCode(ExLocal.LStock.StockFolio);

          If (Syss.UseMLoc) and (CCode<>StkLocFilt) then
          Begin
            StkLocFilt:=CCode;

            CurrencyClick(Self);
          end;
        end;

      except

        DispStkTree.Free;

      end; {try..}
  end;



  Procedure TObjDFrm.Build_SNos(Idx  :  Integer);

  Const
    Fnum2     =  MiscF;
    Keypath2  =  MIK;


  Var
    KeyS2,
    KeyChk2  :  Str255;

    LinkDoc  :  Str10;

    FoundOk,
    FoundAll,
    SalesDoc
             :  Boolean;

    SerGot,
    SerCount :  Double;


    n        :  Integer;
    LinkLNo
             :  LongInt;

    ODDRec    :  ^ODDType;

    TmpStr   :  Str255;


  Begin
    FoundOk:=BOff;  TmpStr:='';

    StillInNeedData:=BOn;

    ClsI1Btn.Enabled:=BOff;

    FoundAll:=BOff; SerCount:=0;

    With ODOLine,ExLocal,LId do
    Begin

      SalesDoc:=(IdDocHed In SalesSplit-[SCR,SJC,SRF]+[PCR,PJC,PRF]+StkRetPurchSplit) or ((IdDocHed=ADJ) and (Qty<0)) or ((IdDocHed=WOR) and (LineNo>1));


      If (SalesDoc) then
        KeyChk2:=FullQDKey(MFIFOCode,MSERNSub,FullNomKey(LStock.StockFolio)+#1)
      else
        KeyChk2:=FullQDKey(MFIFOCode,MSERNSub,FullNomKey(LStock.StockFolio));

      KeyS2:=KeyChk2+NdxWeight;

      //PR: 27/05/2011 ABSEXCH-11406 Setting LinkDoc from the related order was causing SDNs to show the wrong serial numbers
      //under certain circumstances.
(*      If (SOPLink<>0) and (IdDocHed<>Adj) and (Not (IdDocHed In StkRetSplit)) then
      Begin
        LinkDoc:=SOP_GetSORNo(SOPLink);
        LinkLNo:=SOPLineNo;
      end
      else
      Begin
        LinkDoc:=LInv.OurRef;
        LinkLNo:=ABSLineNo;
      end;
*)
      SerGot:=SerialQty;

      If (SerGot<0) and (((Qty<0) and (IdDocHed=ADJ)) or ((LineNo>1) and (IdDocHed=WOR))) then
        SerGot:=SerGot*DocNotCnst;

      Status:=Find_Rec(B_GetLessEq,F[Fnum2],Fnum2,LRecPtr[Fnum2]^,KeyPath2,KeyS2);

      While (StatusOk) and (CheckKey(KeyChk2,KeyS2,Length(KeyChk2),BOn)) and (Not FoundAll) do
      With LInv, ExLocal.LMiscRecs^.SerialRec do
      Begin
        //PR: 27/05/2011 ABSEXCH-11406 Refactored check to new function Funcs\EntMiscFuncs.DoesSerialBelong
        FoundOK := DoesSerialBelong(OurRef, ExLocal.LId, ExLocal.LMiscRecs^.SerialRec);
(*        {$B+}
        FoundOk:=((CheckKey(LinkDoc,OutDoc,Length(LinkDoc),BOff)) and (SoldLine=LinkLNo)) or
                 ((CheckKey(LinkDoc,OutOrdDoc,Length(LinkDoc),BOff)) and (OutOrdLine=LinkLNo)
                 and (IdDocHed In OrderSet+[WOR])) or
                 ((CheckKey(OurRef,OutDoc,Length(OurRef),BOff)) and (SoldLine=ABSLineNo)) or
                   ((CheckKey(OurRef,RetDoc,Length(OurRef),BOff)) and (RetDocLine=ABSLineNo)) or

                 ((CheckKey(LinkDoc,InDoc,Length(LinkDoc),BOff)) and (BuyLine=LinkLNo) and (Not BatchChild)) or
                 ((CheckKey(OurRef,InDoc,Length(OurRef),BOff)) and (BuyLine=ABSLineNo) and (Not BatchChild)) or
                 ((CheckKey(LinkDoc,InOrdDoc,Length(LinkDoc),BOff)) and (InOrdLine=LinkLNo)
                 and (IdDocHed In OrderSet+[WOR]) and (Not BatchChild));

        {$B-}
*)
        Application.ProcessMessages;

        If (FoundOk) then
        Begin

          TmpStr:='';

          New(ODDRec);

          FillChar(ODDRec^,Sizeof(ODDRec^),0);

          With ODDRec^ do
          Begin
            NFnum:=MiscF;

            If (Not BatchRec) then
            Begin
              NLKey:=SerialNo;
              NKey:=FullQDKey(MFIFOCode,MSERNSub,SerialNo);

              NKeyPath:=MiscNdxK;

              TmpStr:='SNo.: '+Trim(SerialNo);
            end
            else
            Begin
              NLKey:=BatchNo;
              NLKeyPath:=1;

              NKey:=FullQDKey(MFIFOCode,MSERNSub,BatchNo);
              NKeyPath:=MiscBtcK;

            end;

          end;

          If (TmpStr<>'') then
            TmpStr:=TmpStr+', ';

          If (Trim(BatchNo)<>'') then
            TmpStr:=TmpStr+'Batch: ';

          If (BatchChild) then
            TmpStr:=TmpStr+Form_Real(QtyUsed,0,Syss.NoQtyDec)+' x ';

          TmpStr:=TmpStr+Trim(BatchNo);

          n:=AddChildObject(Idx,TmpStr,ODDRec);

          If (Not BatchChild) or (SalesDoc) then
          Begin
            If (BatchRec) then
            Begin
              If (BatchChild) then
                SerCount:=SerCount+QtyUsed
              else
                SerCount:=SerCount+BuyQty;
            end
            else
              SerCount:=SerCount+1.0;
          end;

        end;

        FoundAll:=(SerCount>=SerGot);

        If (Not FoundAll) then
          Status:=Find_Rec(B_GetPrev,F[Fnum2],Fnum2,LRecPtr[Fnum2]^,KeyPath2,KeyS2);
      end;


      {Items[Idx].Expand;}

    end; {With..}

    StillInNeedData:=BOff;
    ClsI1Btn.Enabled:=BOn;


  end;


{$ENDIF}


{$IFDEF STK}
  Procedure TObjDFrm.Build_Bins(Idx  :  Integer);

  Const
    Fnum2     =  MLocF;
    Keypath2  =  MLSecK;


  Var
    KeyS2,
    KeyChk2  :  Str255;

    LinkDoc  :  Str10;

    FoundOk,
    FoundAll,
    SalesDoc
             :  Boolean;

    SerGot,
    SerCount :  Double;


    n        :  Integer;
    LinkLNo
             :  LongInt;

    ODDRec    :  ^ODDType;

    TmpStr   :  Str255;


  Begin
    FoundOk:=BOff;  TmpStr:='';

    StillInNeedData:=BOn;

    ClsI1Btn.Enabled:=BOff;

    FoundAll:=BOff; SerCount:=0;

    With ODOLine,ExLocal,LId do
    Begin

      SalesDoc:=(IdDocHed In SalesSplit-[SCR,SJC,SRF]+[PCR,PJC,PRF]+StkRetPurchSplit) or ((IdDocHed=ADJ) and (Qty<0)) or ((IdDocHed=WOR) and (LineNo>1));
      
      If (SalesDoc) then
        KeyChk2:=FullQDKey(BRRecCode,MSERNSub,FullNomKey(LStock.StockFolio)+Full_MLocKey(MLocStk)+#1)
      else
        KeyChk2:=FullQDKey(BRRecCode,MSERNSub,FullNomKey(LStock.StockFolio)+Full_MLocKey(MLocStk));

      KeyS2:=KeyChk2+NdxWeight;

      If (SOPLink<>0) and (IdDocHed<>Adj) then
      Begin
        LinkDoc:=SOP_GetSORNo(SOPLink);
        LinkLNo:=SOPLineNo;
      end
      else
      Begin
        LinkDoc:=LInv.OurRef;
        LinkLNo:=ABSLineNo;
      end;

      SerGot:=BinQty;

      If (SerGot<0) and (((Qty<0) and (IdDocHed=ADJ)) or ((LineNo>1) and (IdDocHed=WOR))) then
        SerGot:=SerGot*DocNotCnst;

      Status:=Find_Rec(B_GetLessEq,F[Fnum2],Fnum2,LRecPtr[Fnum2]^,KeyPath2,KeyS2);

      While (StatusOk) and (CheckKey(KeyChk2,KeyS2,Length(KeyChk2),BOn)) and (Not FoundAll) do
      With LInv, ExLocal.LMLocCtrl^.brBinRec do
      Begin

        {$B+}
        FoundOk:=((CheckKey(LinkDoc,brOutDoc,Length(LinkDoc),BOff)) and (brSoldLine=LinkLNo)) or
                 ((CheckKey(LinkDoc,brOutOrdDoc,Length(LinkDoc),BOff)) and (brOutOrdLine=LinkLNo)
                 and (IdDocHed In OrderSet+[WOR])) or
                 ((CheckKey(OurRef,brOutDoc,Length(OurRef),BOff)) and (brSoldLine=ABSLineNo)) or
                 ((CheckKey(LinkDoc,brInDoc,Length(LinkDoc),BOff)) and (brBuyLine=LinkLNo) and ((Not brBatchChild) or (Not Syss.KeepBinHist))) or
                 ((CheckKey(OurRef,brInDoc,Length(OurRef),BOff)) and (brBuyLine=ABSLineNo) and ((Not brBatchChild) or (Not Syss.KeepBinHist))) or
                 ((CheckKey(LinkDoc,brInOrdDoc,Length(LinkDoc),BOff)) and (brInOrdLine=LinkLNo)
                 and (IdDocHed In OrderSet+[WOR]) and ((Not brBatchChild) or (Not Syss.KeepBinHist)));

        {$B-}

        Application.ProcessMessages;

        If (FoundOk) then
        Begin

          TmpStr:='';

          New(ODDRec);

          FillChar(ODDRec^,Sizeof(ODDRec^),0);

          With ODDRec^ do
          Begin
            NFnum:=MLocF;

            NLKey:=brCode2;
            {NKey:=FullQDKey(BRRecCode,MSERNSub,FullBinCode3(brStkFolio,brInMLoc,brBinCode1));
            NKeyPath:=MLSuppK;}

            NKey:=FullQDKey(BRRecCode,MSERNSub,brCode2);

            NKeyPath:=MLSecK;

            TmpStr:='Bin.: '+Trim(brBinCode1);
            NMiscMode:=3;
          end;

          If (brBatchChild) then
            TmpStr:=TmpStr+' x '+Form_Real(brQtyUsed,0,Syss.NoQtyDec)
          else
            TmpStr:=TmpStr+'. '+Bin_AQty(brBuyQty,brQtyUsed,brBinCap,brBatchChild);

          n:=AddChildObject(Idx,TmpStr,ODDRec);

          If (Not brBatchChild) or (SalesDoc) then
          Begin
            If (brBatchChild) then
              SerCount:=SerCount+brQtyUsed
            else
              SerCount:=SerCount+brBuyQty;

          end;

        end;

        FoundAll:=(SerCount>=SerGot);

        If (Not FoundAll) then
          Status:=Find_Rec(B_GetPrev,F[Fnum2],Fnum2,LRecPtr[Fnum2]^,KeyPath2,KeyS2);
      end;


      {Items[Idx].Expand;}

    end; {With..}

    StillInNeedData:=BOff;
    ClsI1Btn.Enabled:=BOn;


  end;
{$ENDIF}


{ ======= Link to Job display ======== }

procedure TObjDFrm.Display_Job(Mode  :  Byte);

Begin

  {$IFDEF JC}

    ExLocal.AssignFromGlobal(JobF);

    If (DispJob=nil) then
      DispJob:=TFJobDisplay.Create(Self);

    try

      With DispJob do
      Begin
        Display_Account(1,ExLocal.LJobRec^.JobCode,'',0,0,BOff,nil);
      end;
    except

      DispJob.Free;

    end; {try..}

  {$ENDIF}
end;



{ ======= Link to Voucher display ======== }

procedure TObjDFrm.Display_Vch(Mode  :  Byte);

Begin

  {$IFDEF JC}

    ExLocal.AssignFromGlobal(JDetlF);

    If (DispVch=nil) then
      DispVch:=TFJobDisplay.Create(Self);

    try

      With DispVch do
      Begin
        Display_Voucher(2,BOn);
      end;
    except

      DispVch.Free;

    end; {try..}

  {$ENDIF}
end;

{ ======= Link to Employee display ======== }

procedure TObjDFrm.Display_Emp(Mode  :  Byte);

Begin

  {$IFDEF JC}

    ExLocal.AssignFromGlobal(JMiscF);

    If (DispEmp=nil) then
      DispEmp:=TFJobDisplay.Create(Self);

    try

      With DispEmp do
      Begin
        Display_Employee(2,BOn);
      end;
    except

      DispEmp.Free;

    end; {try..}

  {$ENDIF}
end;


{ ======= Link to Job  display ======== }

procedure TObjDFrm.Display_JobTree(Mode  :  Byte;
                                   CCode :  Str10);


Begin
    {$IFDEF JC}

      ExLocal.AssignFromGlobal(JobF);

      If (DispJobTree=nil) then
        DispJobTree:=TJobView.Create(Self);

      try

        With DispJobTree do
        Begin
          Show;

          ExLocal.AssignToGlobal(JobF);

          PlaceNomCode(ExLocal.LJobRec^.JobFolio);

          ReconBtnClick(nil);

        end;

      except

        DispJobTree.Free;

      end; {try..}
    {$ENDIF}
end;


Procedure TObjDFrm.Build_Links(Idx  :  Integer;
                               BKey :  Str255);

Const
  Fnum2     =  MiscF;
  Keypath2  =  MIK;


Var
  KeyS2,
  KeyChk2  :  Str255;

  n        :  Integer;

  ODDRec    :  ^ODDType;

  TmpStr   :  Str255;

  RecAddr  :  LongInt;

Begin
  TmpStr:='';

  StillInNeedData:=BOn;

  ClsI1Btn.Enabled:=BOff;

  RecAddr := 0;

  With ODOLine,ExLocal do
  Begin

    KeyChk2:=BKey;

    KeyS2:=KeyChk2;

    Status:=Find_Rec(B_GetGEq,F[Fnum2],Fnum2,LRecPtr[Fnum2]^,KeyPath2,KeyS2);

    While (StatusOk) and (CheckKey(KeyChk2,KeyS2,Length(KeyChk2),BOn)) do
    With ExLocal.LMiscRecs^ do
    Begin


      Application.ProcessMessages;


      TmpStr:='';

      New(ODDRec);

      FillChar(ODDRec^,Sizeof(ODDRec^),0);

      With ODDRec^ do
      Begin
        NFnum:=MiscF;

        NKey:=FullQDKey(RecMfix,SubType,btLinkRec.CustomKey);
        NKeyPath:=MIK;
        NMiscMode:=1;
        //HV 27/04/2016 2016-R2 ABSEXCH-14737: ObjectDrill + Links - Always Executes First Link - Not The One You Click On
        Status:= GetPos(F[NFnum],NFnum,RecAddr);
        if (Status = 0) and (RecAddr <> 0) then
          NLKey := IntToStr(RecAddr);
      end;

      {$IFDEF LTR}

        If (btLinkRec.Version=DocWord95) then
        With btLetterRec do
          TmpStr:=DocTypeName(Version)+' : '+LtrDescr
        else
        With btLinkRec do
          TmpStr:=DocTypeName(Version)+' : '+LtrDescr;

      {$ELSE}
        TmpStr:='LTRS Off!';

      {$ENDIF}

      n:=AddChildObject(Idx,TmpStr,ODDRec);

      Status:=Find_Rec(B_GetNext,F[Fnum2],Fnum2,LRecPtr[Fnum2]^,KeyPath2,KeyS2);
    end;

  end; {With..}

  StillInNeedData:=BOff;
  ClsI1Btn.Enabled:=BOn;

end;


{$IFDEF WOP}
  {== Function to return top of WOR Tree ==}

  Function TObjDFrm.FindTopWOR(Var WORInv  :  InvRec)  :  Boolean;

  Const
    Fnum     =  IdetailF;
    Keypath  =  IdLinkK;
    Fnum2    =  InvF;
    Keypath2 =  InvFolioK;

  Var
    KeyS,
    KeyChkI,
    KeyChk   :  Str255;

  Begin
    Result:=BOff;

    With WORInv do
    Begin
      KeyChk:=FullNomKey(FolioNum);
      KeyS:=FullIdKey(FolioNum,1);
    end; {With..}

    Status:=Find_Rec(B_GetEq,F[Fnum],Fnum,RecPtr[Fnum]^,KeyPath,KeyS);

    If (StatusOk) and (CheckKey(KeyChk,KeyS,Length(KeyChk),BOn)) then
    With Id do
    Begin
      Result:=(SOPLink=0) and (SOPLineNo=0);

      If (Not Result) and (SOPLink<>WORInv.FolioNum) then {We need to travelup}
      Begin
        KeyChkI:=FullNomKey(SOPLink);

        Status:=Find_Rec(B_GetEq,F[Fnum2],Fnum2,RecPtr[Fnum2]^,KeyPath2,KeyChkI);

        If (StatusOk) and (Inv.InvDocHed<>SOR) then
        Begin
          WORInv:=Inv;

          Result:=FindTopWOR(WORInv);
        end
        else
          Result:=(StatusOk and (Inv.InvDocHed=SOR));

      end;

    end;

  end;


  { == Proc to recursivley build up the Object WOR tree == }

  Procedure TObjDFrm.BuildOWORChildren(WORInv,
                                       ParentInv
                                               :  InvRec;
                                       Idx     :  Integer;
                                       PIsWOR  :  Boolean;
                                       WORMatch:  Str255);


  Const
    Fnum      =  PWrdF;
    Fnum2     =  IdetailF;
    Keypath2  =  IdLinkK;

  Var

    TmpRecAddr
              :  LongInt;

    TmpKPath,
    TmpStat,
    n,nIdx,ACnst,
    Keypath
              :  Integer;
    ODDRec    :  ^ODDType;

    KeyS,KeyChk,
    KeyI
              :  Str255;

    Rnum      :  Double;
    OLine     :  Str255;


  Begin
    With WORInv do
    Begin
      KeyChk:=FullNomKey(FolioNum);
      KeyS:=FullIdKey(FolioNum,1);
    end; {With..}

    nIdx:=Idx;

    Status:=Find_Rec(B_GetEq,F[Fnum2],Fnum2,RecPtr[Fnum2]^,KeyPath2,KeyS);
    {$B-}
    If (WORInv.InvDocHed=SOR) or ((StatusOk) and (CheckKey(KeyChk,KeyS,Length(KeyChk),BOn)) and (Global_GetMainRec(StockF,Id.StockCode)) and (Stock.StockType=StkBillCode)) then
    {$B+}
    Begin

      With ODOLine,WORInv do
      Begin
        If (WORInv.InvDocHed=WOR) then
        Begin
          New(ODDRec);

          FillChar(ODDRec^,Sizeof(ODDRec^),0);

          {If (ExLocal.LInv.OurRef<>ParentInv.OurRef) or (ExLocal.LInv.OurRef<>WORInv.OurRef) then}
          If (WORInv.OurRef<>WORMatch) and (ParentInv.InvDocHed<>SOR) then
          Begin
            OLine:=' '+OurRef+'. '+Form_Real(WORReqQty(Id),0,Syss.NoQtyDec)+' x '+Trim(Id.StockCode);

            nIdx:=AddChildObject(Idx,OLine,ODDRec);

            New(ODDRec);

            FillChar(ODDRec^,Sizeof(ODDRec^),0);

            With ODDRec^ do
            Begin
              NFnum:=InvF;

              NKeypath:=InvOurRefK;
              NKey:=OurRef;
            end;
          end
          else
            With ODDRec^ do
            Begin
              NFnum:=InvF;

              NKeypath:=InvOurRefK;
              NKey:=OurRef;
            end;


          If PIsWOR then
          With ODDRec^ do
          Begin
            NFnum:=MiscF;
            NMiscMode:=5;
          end;
          
          With Stock do
            Oline:=Form_Real(WORReqQty(Id),0,Syss.NoQtyDec)+' x '+dbFormatName(StockCode,Desc[1]);

          n:=AddChildObject(nIdx,OLine,ODDRec);

          If (PIsWOR) then
          Begin
            Items[n].UseLeafX:=obLeaf4;

            WORSelected:=n;
          end;

          New(ODDRec);

          FillChar(ODDRec^,Sizeof(ODDRec^),0);

          With ODDRec^ do
          Begin
            NFnum:=StockF;
            NKeypath:=StkCodeK;
            NKey:=Stock.StockCode;
          end;

          OLine:=Trim(Stock.StockCode)+'. Stock record';

          n:=AddChildObject(nIdx,OLine,ODDRec);

          If (PIsWOR) then
            Items[n].UseLeafX:=obLeaf4;

          {Add more details, how many o/s etc.}


          New(ODDRec);

          FillChar(ODDRec^,Sizeof(ODDRec^),0);


          With ODDRec^ do
          Begin
            NFnum:=MiscF;
            NMiscMode:=5;
          end;

          If (PChkAllowed_In(143)) then
            Rnum:=Id.CostPrice
          else
            Rnum:=0.0;

            With Id do
              OLine:='Cost ea. '+FormatCurFloat(GenUnitMask[BOff],Rnum,BOff,Currency)+'. Issued : '+Form_Real(SSDUplift,0,Syss.NoQtyDec)+'. Built : '+Form_Real(QtyWOff,0,Syss.NoQtyDec);

          With WORInv do
            OLine:=OLine+'. '+FormatFloat(GenPcntMask,DivWChk(TotalReserved,TotalCost)*100)+' Complete';

          n:=AddChildObject(nIdx,OLine,ODDRec);
          Items[n].UseLeafX:=obLeaf5;


        end;



        If ((RemitNo<>'') or (OrdMatch)) then
          Keypath:=PWK
        else
          Keypath:=HelpNDXK;

        KeyChk:=FullMatchKey(MatchTCode,MatchSCode,OurRef);
        KeyS:=KeyChk;

        Status:=Find_Rec(B_GetGEq,F[Fnum],Fnum,RecPtr[Fnum]^,KeyPath,KeyS);


        While (StatusOK) and (CheckKey(KeyChk,KeyS,Length(KeyChk),BOff)) do
        With Password.MatchPayRec do
        Begin
          Case Keypath of
            PWK       :  Begin
                           KeyI:=PayRef;
                         end;
            HelpNdxK  :  Begin
                           KeyI:=DocCode;
                         end;
          end; {Case..}

          If (Copy(KeyI,1,3)=DocCodes[WOR]) and (KeyI<>OurRef) and (KeyI<>ParentInv.OurRef)
            and ((CheckKey(WORMatch,KeyI,Length(WORMatch),BOff)) or (ExLocal.LInv.InvDocHed<>SOR)) then
          Begin
            TmpKPath:=Keypath;

            TmpStat:=Presrv_BTPos(Fnum,TmpKPath,F[Fnum],TmpRecAddr,BOff,BOff);

            If (CheckRecExsists(KeyI,InvF,InvOurRefK)) then
              BuildOWORChildren(Inv,WORInv,nIdx,(ExLocal.LInv.OurRef=Inv.OurRef),'');

            TmpStat:=Presrv_BTPos(Fnum,TmpKPath,F[Fnum],TmpRecAddr,BOn,BOff);

          end;

          Status:=Find_Rec(B_GetNext,F[Fnum],Fnum,RecPtr[Fnum]^,KeyPath,KeyS);

        end; {While..}

      end; {With..}
    end; {We have found line 1}

  end;

  { == Proc to create Object WOR tree == }

  Procedure TObjDFrm.BuildOWORTree(Idx  :  Integer; WORMatch  :  Str255);

  Var
    Ok2Cont   :  Boolean;

    WORInv    :  InvRec;


  Begin

    With ExLocal do
    Begin
      WORInv:=LInv;

      If (LInv.InvDocHed=WOR) then
        Ok2Cont:=FindTopWOR(WORInv)
      else
        Ok2Cont:=BOn;


      If (Ok2Cont) then
      Begin
        BuildOWORChildren(WORInv,WORInv,Idx,(LInv.OurRef=WORInv.OurRef),WORMatch);

        PostMessage(Self.Handle,WM_CustGetRec,168,Idx);

        If (WORSelected<>0) then
          PostMessage(Self.Handle,WM_CustGetRec,167,WORSelected);

      end;

      Inv:=LInv;
    end; {With..}
  end;

{$ENDIF}


{$IFDEF JAP}
  {== Function to return top of JAP Tree ==}

  Function TObjDFrm.FindTopJAP(Var JAPInv  :  InvRec)  :  Boolean;

  Const
    Fnum     =  IdetailF;
    Keypath  =  IdLinkK;
    Fnum2    =  InvF;
    Keypath2 =  InvFolioK;

  Var
    KeyS,
    KeyChkI,
    KeyChk   :  Str255;

  Begin
    Result:=BOff;

    With JAPInv do
    Begin
      KeyChk:=FullNomKey(FolioNum);
      KeyS:=FullIdKey(FolioNum,JALRetLineNo);
    end; {With..}

    Status:=Find_Rec(B_GetGEq,F[Fnum],Fnum,RecPtr[Fnum]^,KeyPath,KeyS);

    While (StatusOk) and (CheckKey(KeyChk,KeyS,Length(KeyChk),BOn)) and (Not Result) do
    With Id do
    Begin
      Result:=(SOPLink=0) and (SOPLineNo=0) and (Not (AutoLineType In [2,3]));

      If (Not Result) and (SOPLink<>JAPInv.FolioNum) and (SOPLink<>0) then {We need to travelup}
      Begin
        KeyChkI:=FullNomKey(SOPLink);

        Status:=Find_Rec(B_GetEq,F[Fnum2],Fnum2,RecPtr[Fnum2]^,KeyPath2,KeyChkI);

        If (StatusOk) then
        Begin
          JAPInv:=Inv;

          If (Inv.InvDocHed<>JPT) then
            Result:=FindTopJAP(JAPInv)
          else
            Result:=BOn;
        end
        else
          Result:=(StatusOk and (Inv.InvDocHed=JPT));

      end;

      If (Not Result) then
        Status:=Find_Rec(B_GetNext,F[Fnum],Fnum,RecPtr[Fnum]^,KeyPath,KeyS);

    end;

  end;


  { == Proc to recursivley build up the Object JAP tree == }

  Procedure TObjDFrm.BuildOJAPChildren(JAPInv,
                                       ParentInv
                                               :  InvRec;
                                       Idx     :  Integer;
                                       PIsJAP  :  Boolean;
                                       JAPMatch:  Str255);


  Const
    Fnum      =  PWrdF;
    Fnum2     =  IdetailF;
    Keypath2  =  IdLinkK;

  Var

    TmpRecAddr
              :  LongInt;

    TmpKPath,
    TmpStat,
    n,nIdx,ACnst,
    Keypath
              :  Integer;
    ODDRec    :  ^ODDType;

    Foundcode :  Str20;
    KeyS,KeyChk,
    GenStr,
    KeyI
              :  Str255;

    Rnum      :  Double;
    OLine     :  Str255;


  Begin
    With JAPInv do
    Begin
      KeyChk:=FullNomKey(FolioNum);
      KeyS:=FullIdKey(FolioNum,JALRetLineNo);
    end; {With..}

    nIdx:=Idx;  GenStr:='';

    Status:=Find_Rec(B_GetGEq,F[Fnum2],Fnum2,RecPtr[Fnum2]^,KeyPath2,KeyS);
    {$B-}
    If (JAPInv.InvDocHed=JPT) or ((StatusOk) and (CheckKey(KeyChk,KeyS,Length(KeyChk),BOn)))  then
    {$B+}
    Begin

      With ODOLine,JAPInv do
      Begin
        If (JAPInv.InvDocHed In JAPSplit) then
        Begin
          New(ODDRec);

          FillChar(ODDRec^,Sizeof(ODDRec^),0);

          If (JAPInv.OurRef<>JAPMatch) {and (ParentInv.InvDocHed<>JPT)} then
          Begin
            With ODDRec^ do
            Begin
              NFnum:=InvF;

              NKeypath:=InvOurRefK;
              NKey:=OurRef;
            end;


            OLine:=' '+OurRef+'. '+JAGiStatus(JAPInv);

            If (InvDocHed In JAPJAPSplit) then
              OLine:=OLine+'. % of Application certified : '+Form_Real(DivWChk(InvNetVal,TotalCost)*100,0,1)+'%'
            else
              OLine:=OLine+'. % of Budget Applied : '+Form_Real(DivWChk(TotalReserved,TotalCost)*100,0,1)+'%. Cert. : '+Form_Real(DivwChk(TotalOrdered,TotalCost)*100,0,1)+'%';

            nIdx:=AddChildObject(Idx,OLine,ODDRec);

            New(ODDRec);

            FillChar(ODDRec^,Sizeof(ODDRec^),0);

            With ODDRec^ do
            Begin
              NFnum:=InvF;

              NKeypath:=InvOurRefK;
              NKey:=OurRef;
            end;
          end
          else
            With ODDRec^ do
            Begin
              NFnum:=InvF;

              NKeypath:=InvOurRefK;
              NKey:=OurRef;
            end;


          {If PIsJAP then
          With ODDRec^ do
          Begin
            NFnum:=MiscF;
            NMiscMode:=5;
          end;}

          If (InvDocHed In JAPJAPSplit) then
            OLine:=' Applied : '+FormatCurFloat(GenRealMask,TotalCost,BOff,Currency)+'. Cert. : '+FormatCurFloat(GenRealMask,InvNetVal,BOff,Currency)
          else
            OLine:=' Budget : '+FormatCurFloat(GenRealMask,TotalCost,BOff,Currency)+'. Applied : '+FormatCurFloat(GenRealMask,TotalReserved,BOff,Currency)+'. Cert. '+FormatCurFloat(GenRealMask,TotalOrdered,BOff,Currency);

          OLine:=OLine+'. '+AppsStatusStr(JAPInv,BOn,BOff,BOff);

          n:=AddChildObject(nIdx,OLine,ODDRec);

          If (PIsJAP) then
          Begin
            WORSelected:=n;
          end
          else
          Begin


            {Add more details, how many o/s etc.}

            If (Not EmptyKey(DJobCode,JobCodeLen)) then
            Begin
              If (JobRec^.JobCode<>DJobCode) then
                GetJob(Self,DJobCode,FoundCode,-1);

              New(ODDRec);

              FillChar(ODDRec^,Sizeof(ODDRec^),0);

              With ODDRec^ do
              Begin
                NFnum:=JobF;

                NKeypath:=JobCodeK;
                NKey:=DJobCode;
              end;

              n:=AddChildObject(nIdx,'Job : '+dbFormatName(DJobCode,JobRec^.JobDesc),ODDRec);

            end;


            If (CISEmpl<>'') then
            Begin
              If (JobMisc^.EmplRec.EmpCode<>CISEmpl) then
                GetJobMisc(Self,CISEmpl,FoundCode,3,-1);

              New(ODDRec);

              FillChar(ODDRec^,Sizeof(ODDRec^),0);

              With ODDRec^ do
              Begin
                NFnum:=JMiscF;
                NKey:=PartCCKey(JARCode,JASubAry[3])+CISEmpl;
                NKeypath:=JMK;
              end;

              n:=AddChildObject(nIdx,'Sub Contractor : '+dbFormatName(CISEmpl,JobMisc^.EmplRec.EmpName),ODDRec);

            end;
          end;
        end;



        If ((RemitNo<>'') or (OrdMatch)) then
          Keypath:=PWK
        else
          Keypath:=HelpNDXK;

        KeyChk:=FullMatchKey(MatchTCode,MatchSCode,OurRef);
        KeyS:=KeyChk;

        Status:=Find_Rec(B_GetGEq,F[Fnum],Fnum,RecPtr[Fnum]^,KeyPath,KeyS);


        While (StatusOK) and (CheckKey(KeyChk,KeyS,Length(KeyChk),BOff)) do
        With Password.MatchPayRec do
        Begin
          Case Keypath of
            PWK       :  Begin
                           KeyI:=PayRef;
                         end;
            HelpNdxK  :  Begin
                           KeyI:=DocCode;
                         end;
          end; {Case..}

          If (Chk_App(Copy(keyI,1,3),BOff)) and (KeyI<>OurRef) and (KeyI<>ParentInv.OurRef)
            and ((CheckKey(JAPMatch,KeyI,Length(JAPMatch),BOff)) or (ExLocal.LInv.InvDocHed<>JPT) or (ParentInv.InvDocHed=JPT)) then
          Begin
            TmpKPath:=Keypath;

            TmpStat:=Presrv_BTPos(Fnum,TmpKPath,F[Fnum],TmpRecAddr,BOff,BOff);

            If (CheckRecExsists(KeyI,InvF,InvOurRefK)) then
              BuildOJAPChildren(Inv,JAPInv,nIdx,(ExLocal.LInv.OurRef=Inv.OurRef),'');

            TmpStat:=Presrv_BTPos(Fnum,TmpKPath,F[Fnum],TmpRecAddr,BOn,BOff);

          end;

          Status:=Find_Rec(B_GetNext,F[Fnum],Fnum,RecPtr[Fnum]^,KeyPath,KeyS);

        end; {While..}

      end; {With..}
    end; {We have found line 1}

  end;

  { == Proc to create Object WOR tree == }

  Procedure TObjDFrm.BuildOJAPTree(Idx  :  Integer; JAPMatch  :  Str255);

  Var
    Ok2Cont   :  Boolean;

    JAPInv    :  InvRec;


  Begin

    With ExLocal do
    Begin
      JAPInv:=LInv;

      If (LInv.InvDocHed In JapSplit) then
        Ok2Cont:=FindTopJAP(JAPInv)
      else
        Ok2Cont:=BOn;


      If (Ok2Cont) then
      Begin
        BuildOJAPChildren(JAPInv,JAPInv,Idx,(LInv.OurRef=JAPInv.OurRef),JAPMatch);

        PostMessage(Self.Handle,WM_CustGetRec,168,Idx);

        If (WORSelected<>0) then
          PostMessage(Self.Handle,WM_CustGetRec,167,WORSelected);

      end;

      Inv:=LInv;
    end; {With..}
  end;

{$ENDIF}


{$IFDEF RET}
  procedure TObjDFrm.BuildORetLinks(Idx   :  Integer;
                                    OKey  :  Str255);

  Const
    Fnum  =  PWrdF;

  Var
    n,nIdx,ACnst,
    Keypath
              :  Integer;
    ODDRec    :  ^ODDType;

    KeyS,KeyChk
              :  Str255;
    Loop,
    NeedHed,
    Ok2Add    :  Boolean;

    Rnum      :  Real;
    OLine     :  Str255;


  Begin
    With ODOLine,ExLocal,LInv do
    Begin

      NeedHed:=BOn;  Ok2Add:=BOn; nIdx:=Idx; Loop:=BOff;

      New(ODDRec);

      FillChar(ODDRec^,Sizeof(ODDRec^),0);

      With ODDRec^ do
      Begin
        NFnum:=InvF;
        NKeypath:=InvOurRefK;
        NKey:=OKey;

      end;

      n:=AddChildObject(nIdx,' '+OKey+'. ',ODDRec);

      Repeat
        If  (Loop) then
          Keypath:=PWK
        else
          Keypath:=HelpNDXK;

        KeyChk:=FullMatchKey(MatchTCode,MatchSCode,OKey);
        KeyS:=KeyChk;

        Status:=Find_Rec(B_GetGEq,F[Fnum],Fnum,RecPtr[Fnum]^,KeyPath,KeyS);


        While (StatusOK) and (CheckKey(KeyChk,KeyS,Length(KeyChk),BOff)) do
        With Password.MatchPayRec do
        Begin


          New(ODDRec);

          FillChar(ODDRec^,Sizeof(ODDRec^),0);

          Ok2Add:=BOn;

          With ODDRec^ do
          Begin
            NFnum:=InvF;
            NKeypath:=InvOurRefK;
            Case Keypath of
              PWK       :  Begin
                             NKey:=PayRef;
                             ACnst:=-1;
                           end;
              HelpNdxK  :  Begin
                             NKey:=DocCode;
                             ACnst:=1;
                           end;
            end; {Case..}

            Rnum:=OwnCVal*ACnst;
            OLine:=FormatCurFloat(GenRealMask,Rnum,BOff,MCurrency);



            If (Ok2Add) and (NKey<>ExLocal.Linv.OurRef) then
              n:=AddChildObject(nIdx,' '+NKey+'. '+OLine,ODDRec)
            else
              Dispose(ODDRec);

          end; {With..}


          Status:=Find_Rec(B_GetNext,F[Fnum],Fnum,RecPtr[Fnum]^,KeyPath,KeyS);

        end; {While..}

        Loop:=Not Loop;

      Until (Not Loop) ;


    end; {With..}

  end;

{$ENDIF}


Procedure TObjDFrm.ObjDrillLink(Idx  :  Integer);

Var
  ODDRec  :  ^ODDType;
  RecAddr  :  LongInt;
  
Begin  
  ODDRec:=ODOLine.Items[Idx].Data;
  RecAddr :=0;

  With ODDRec^ do
  Begin
    If (NNeedData) then
    Begin
      NNeedData:=BOff;
      Case NFnum of
        MiscF  :  Case NMiscMode of
                   {$IFDEF SOP}
                     0  :  Build_SNos(Idx);
                   {$ENDIF}

                     1  :  Build_Links(Idx,ODDRec^.NKey);

                   {$IFDEF WOP}
                     2  :  BuildOWORTree(Idx,ODDRec^.NKey);

                   {$ENDIF}

                   {$IFDEF JAP}
                     3  :  BuildOJAPTree(Idx,ODDRec^.NKey);

                   {$ENDIF}


                   {$IFDEF Ret}
                     4  :  BuildORetLinks(Idx,ODDRec^.NKey);

                   {$ENDIF}

                  end; {Case..}

      {$IFDEF Stk}

        MLocF  :  Case NMiscMode of
                     3  :  Build_Bins(Idx);
                  end; {Case..}
      {$ENDIF}

      end;
    end
    else
    Begin

      Status:=Find_Rec(B_GetEq,F[NFnum],NFnum,RecPtr[NFnum]^,NKeyPath,NKey);
      
      If (StatusOk) then
      Begin
        Case NFnum of
          CustF :  If (Allowed_In(IsACust(Cust.CustSupp),34)) or (Allowed_In(Not IsACust(Cust.CustSupp),44)) then
                     Display_Account(0);

          InvF  :  With Inv do
                     If (Allowed_In(InvDocHed In (SalesSplit-OrderSet),05)) or
                        (Allowed_In(InvDocHed In (PurchSplit-OrderSet),14)) or
                        (Allowed_In(InvDocHed In NomSplit,26)) or
                        (Allowed_In(InvDocHed In (OrderSet-PurchSplit),158)) or
                        (Allowed_In(InvDocHed In (OrderSet-SalesSplit),168)) or
                        (Allowed_In(InvDocHed In (TSTSplit),217)) or
                        (Allowed_In(InvDocHed In (WOPSplit),378)) or
                        (Allowed_In(InvDocHed In (StkRetSalesSplit),580)) or
                        (Allowed_In(InvDocHed In (StkRetSplit),534)) or 
                        (Allowed_In(InvDocHed In (JAPSalesSplit),446)) or
                        (Allowed_In(InvDocHed In (JAPPurchSplit),437)) or
                        (Allowed_In(InvDocHed In (StkAdjSplit),118)) then
                           Display_Trans(99+(-97*Ord(LODDMode In[1,2])));

          {$IFDEF Nom}
            NomF  :  If (Allowed_In(BOn,26)) then
                       Display_Nominal(0,'',BOff);

            PWrdF :  With PassWord,CostCtrRec do
                     Begin
                       {* Get Nominal *}
                       Status:=Find_Rec(B_GetEq,F[NLFnum],NLFnum,RecPtr[NLFnum]^,NLKeyPath,NLKey);

                       If (Allowed_In(BOn,26)) then
                         Display_Nominal(0,PCostC,(SubType=CSubCode[BOn]));
                     end;
          {$ENDIF}

          {$IFDEF Stk}
              StockF : If (Allowed_In(BOn,469)) then
                         Display_Stock(0);


              MLocF : Case NMiscMode of
                         3  :  With MLocCtrl^.brBinRec do
                               Begin
                                {* Get Bin *}

                                {If (Allowed_In(BOn,149)) then}
                                  Control_FindBin(Self,NLKey,NKeypath);

                              end;

                        {$IFDEF SOP}
                        else   With MLocCtrl^.MLocLoc do
                               Begin
                                {* Get Stock*}
                                Status:=Find_Rec(B_GetEq,F[NLFnum],NLFnum,RecPtr[NLFnum]^,NLKeyPath,NLKey);

                                If (Allowed_In(BOn,111)) then
                                  Display_StkTree(0,loCode)
                              end;
                        {$ENDIF}
                      end; {Case..}

          {$ENDIF}


          {$IFDEF JC}
            JobF    :  If (Allowed_In(BOn,205)) then
                         Display_Job(0);

            JMiscF  :  Case NLFnum of
                         0    :  Begin {Employee}
                                   Display_Emp(0);
                                 end;

                        JobF  :  Begin
                                   {* Get Job*}
                                   Status:=Find_Rec(B_GetEq,F[NLFnum],NLFnum,RecPtr[NLFnum]^,NLKeyPath,NLKey);

                                   If (Allowed_In(BOn,205)) then
                                     Display_JobTree(0,JobMisc^.JobAnalRec.JAnalCode);
                                 end;
                        end; {Case..}

              JDetlF    :  Display_Vch(0);


          {$ENDIF}


          MiscF  :  Case NMiscMode of

                     {$IFDEF SOP}
                       0  :  With MiscRecs^.SerialRec do
                             Begin
                              {* Get SNo *}

                              If (Allowed_In(BOn,149)) then
                                Control_FindSer(Self,NLKey,NLKeypath);

                            end;
                     {$ELSE}
                       0  :  ;

                     {$ENDIF}

                     {$IFDEF LTR}
                       1  : begin
                              //HV 27/04/2016 2016-R2 ABSEXCH-14737: ObjectDrill + Links - Always Executes First Link - Not The One You Click On
                              if NLKey <> '' then
                                RecAddr := StrToInt(NLKey);
                              Move(RecAddr, F[NFnum], SizeOf(RecAddr));
                              SetDataRecOfs(NFnum,RecAddr);
                              Status:=GetDirect (F[NFnum], NFnum, RecPtr[NFnum]^, NKeyPath, 0);
                              if Status = 0 then
                                ExecLink(MiscRecs^);
                            end;
                     {$ELSE}
                       1  :  ;
                     {$ENDIF}

                       2  :  ; {Dummy used to create ObjectWOR}

                       5  :  ; {Dummy used to not drill down to anything}

                     end; {Case..}
        end;

      end; {If foundok..}
    end;
  end; {With..}


end; {PRoc..}

{$IFDEF STK}

  procedure TObjDFrm.BuildWORList(Idx       :  Integer;
                                  WORDRec   :  Pointer);

  Const
    Fnum     =  IdetailF;

    KeyPath =   IdFolioK;


  Var
    n,nIdx,ACnst
              :  Integer;
    ODDRec    :  ^ODDType;

    KeyS,KeyChk
              :  Str255;

    Rnum      :  Double;
    OLine     :  Str255;


  Begin
    With ODOLine,OMTExLocal^,LInv do
    Begin

      KeyS:=FullIdKey(FolioNum,1);

      LStatus:=LFind_Rec(B_GetEq,Fnum,KeyPath,KeyS);

      If (LStatusOk) then
      Begin
        If (LGetMainRecPos(StockF,LId.StockCode)) and (LStock.StockType=StkBillCode) then
        Begin
          New(ODDRec);

          ODDRec^:=ODDType(WORDRec^);

          With LStock do
          Begin
            Oline:=Form_Real(WORReqQty(LId),0,Syss.NoQtyDec)+' x '+dbFormatName(StockCode,Desc[1]);

            If PChkAllowed_In(143) then
              OLine:=OLine+'. Cost ea. '+FormatCurFloat(GenUnitMask[BOff],LId.CostPrice,BOff,Currency);
          end;

          n:=AddChildObject(Idx,OLine,ODDRec);

          New(ODDRec);

          FillChar(ODDRec^,Sizeof(ODDRec^),0);



          With ODDRec^ ,LStock do
          Begin
            NFnum:=StockF;
            NKeypath:=StkCodeK;
            NKey:=StockCode;

            OLine:=Trim(StockCode)+'. Stock record';

            n:=AddChildObject(Idx,OLine,ODDRec);
          end; {With..}

        end;

      end;
    end; {With..}
  end; {Proc..}



  procedure TObjDFrm.BuildPORList(Idx   :  Integer);

  Const
    Fnum     =  ReportF;

    KeyPath =   RpK;


  Var
    ParentNode:  Boolean;

    n,nIdx,ACnst,
    LastIdx,TopIdx
              :  Integer;
    ODDRec    :  ^ODDType;

    KeyS,KeyChk
              :  Str255;

    Rnum      :  Real;

    ParentInv :  InvRec;

    OLine     :  Str255;


  Begin
    If (Assigned((OThisScrt))) and (Assigned(OMTExLocal)) then
    With ODOLine,OMTExLocal^,LInv do
    Begin
      LastIdx:=Idx;  TopIdx:=Idx;  ParentNode:=BOff;

      KeyChk:=FullNomKey(OThisScrt^.Process);
      KeyS:=KeyChk;

      LStatus:=LFind_Rec(B_GetGEq,Fnum,KeyPath,KeyS);


      While (LStatusOK) and (CheckKey(KeyChk,KeyS,Length(KeyChk),BOff)) do
      With LInv do
      Begin
        ParentInv:=LInv;

        OThisScrt^ .Get_Scratch(LRepScr^);

        New(ODDRec);

        FillChar(ODDRec^,Sizeof(ODDRec^),0);



        With ODDRec^ do
        Begin
          NFnum:=InvF;
          NKeypath:=InvOurRefK;
          NKey:=OurRef;

          Case LODDMode of
            2  :  If PChkAllowed_In(143) then
                    Rnum:=TotalCost
                  else
                    Rnum:=0.0;

            else  Rnum:=ITotal(LInv)-InvVAT;
          end; {Case..}

          OLine:=FormatCurFloat(GenRealMask,Rnum,BOff,Currency);

          n:=AddChildObject(TopIdx,' '+NKey+'. '+OLine,ODDRec);

          If (LODDMode=2) then {Go get the BOM being built and add that in}
          Begin
            If (Not ParentNode) then
            Begin
              TopIdx:=n;
              ParentNode:=BOn;
            end;

            BuildWORList(n,ODDRec);

            If (LId.SOPLink=ParentInv.FolioNum) and (ParentInv.FolioNum<>0) then {Move it in to last branch}
              Items[n].MoveTo(LastIdx,oaAddChild);

            LastIdx:=n;

          end;

        end; {With..}


        LStatus:=LFind_Rec(B_GetNext,Fnum,KeyPath,KeyS);

      end; {While..}

    end; {With..}

  end;


  procedure TObjDFrm.BuildB2BList(SORInv     :  InvRec;
                                  MTExLocal  :  tdPostExLocalPtr;
                                  ThisScrt   :  Scratch2Ptr);


  Var
    n,Tmpn    :  Integer;
    ODDRec    :  ^ODDType;
    FoundCode :  Str20;

  Begin
    OMTExLocal:=MTExLocal;
    OThisScrt:=ThisScrt;

    n:=0;

    With ODOLine,ExLocal,LInv do
    Begin
      LInv:=SORInv;

      DestroyNodes;
      Clear;

      New(ODDRec);

      FillChar(ODDRec^,Sizeof(ODDRec^),0);

      With ODDRec^ do
      Begin
        NFnum:=InvF;
        NKeypath:=InvOurRefK;
        NKey:=OurRef;
      end;

      Case LODDMode of
        2  :  n:=AddChildObject(0,' Works Orders',Nil);
        else  Begin
                n:=AddChildObject(0,'Back to Back Orders',Nil);
                
              end;

      end; {Case..}
      If (SORInv.InvDocHed=SOR) or (LODDMode=1) then
        n:=AddChildObject(n,OurRef,ODDRec);

      BuildPORList(n);


      FullExpand;
      Show;
    end; {With..}

  end;


  procedure TObjDFrm.Run_PrintPOR;

  Var
    FormRepPtr :  PFormRepPtr;
    Ok2Print   :  Boolean;

  Begin
    New(FormRepPtr);

    FillChar(FormRepPtr^,Sizeof(FormRepPtr^),0);

    With FormRepPtr^,PParam do
    Begin
      PBatch:=BOn;
      Case LODDMode of
        2  :  RForm:=SyssForms.FormDefs.PrimaryForm[49];
        else  RForm:=SyssForms.FormDefs.PrimaryForm[25];
      end; {Case..}

      {$IFDEF Frm}
        Ok2Print:=pfSelectFormPrinter(PDevRec,BOn,RForm,UFont,Orient)
      {$ELSE}
        Ok2Print:=BOff;
      {$ENDIF}
    end;

    If (Ok2Print) then
    Begin
      {$IFDEF Frm}
          //PR: 21/03/2014 ABSEXCH-14853 Set KeepFile param on Scratch Object to true, so that scratch file doesn't get deleted when ThisScrt is destroyed
          //the file needs to be used by the print thread, which will then delete it.
          OThisScrt.KeepFile := True;
          Start_PORThread(Application.MainForm,OMTExLocal,OThisScrt,FormRepPtr);
          PrintedPOR:=BOn;

      {$ELSE}
         PrintedPOR:=BOff;
      {$ENDIF}

    end;


    If (Assigned(FormRepPtr)) then
      Dispose(FormRepPtr);

  end;

{$ENDIF}





Initialization

  ODDMode  :=0;

end.

