unit StkWarnU;


interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ExtCtrls, TEditVal, SBSPanel, ComCtrls, Buttons,

  GlobVar,VarConst,VarRec2U,ExWrap1U, bkgroup, BTSupU1, Saltxl2u, Grids, SBSOutl,
  AdvOfficeImage, AdvReflectionImage;


type
  tdSOPFuncsPtr  =  ^tdSOPFuncs;

  tdSOPFuncs  =  Object
                   MTExLocal  :  tdMTExLocalPtr;

                   Constructor Create(MTE  :  tdMTExLocalPtr);

                   Destructor Destroy;

                   Function LGet_LastAlloc(FileKey  :  Str255;
                                       Var FoundOk  :  Boolean;
                                           Presv    :  Boolean)  :  Real;

                   Procedure LPut_LastAlloc(FoundOk  :  Boolean;
                                            AllocVal :  Real;
                                            ASubCode :  Char;
                                            EMode    :  LongInt);

                   Procedure LReset_Alloc(ASubCode  :  Char);

                 end;

  TStkEnqThread = class(TThread)
    private
      fMode    :  Byte;

      Display  :  Array[1..5] of TCurrencyEdit;

      TotAged  :  AgedTyp;

      ExLocal  :  TdMTExLocalPtr;

      StkFuncs :  tdSOPFuncsPtr;

      procedure ThreadDelay(dt  :  Word;
                            SAPM:  Boolean);

      procedure SetTotals;

      procedure OutTotals;

    protected
      BeingCreated1  :  Boolean;

      procedure Execute; override;

    public
      constructor Create(StockR   :  StockRec;
                         TMode    :  Byte;
                         TC1      :  TCurrencyEdit);

      Destructor Destroy;

      procedure CleanUp;

      Function WaitforTerminate  :  Boolean;

      procedure Set_NewStock(StockR  :  StockRec);

    private

      ExecuteOff  :  Boolean;

      Function LHowManyBOM(StockR  :  StockRec;
                           WithOwn,
                           TopMan  :  Boolean)  :  Double;


    end;


  TStkWarn = class(TForm)
    PageControl1: TPageControl;
    StkLevelsPage: TTabSheet;
    AgeingPage: TTabSheet;
    Id4QOF: TCurrencyEdit;
    Id4QAF: TCurrencyEdit;
    Id4QAWF: TCurrencyEdit;
    Id4QOSF: TCurrencyEdit;
    Id4QNF: TCurrencyEdit;
    OkCP1Btn: TButton;
    Image1: TImage;
    Panel1: TPanel;
    A1F: TCurrencyEdit;
    A2F: TCurrencyEdit;
    A3F: TCurrencyEdit;
    A4F: TCurrencyEdit;
    A5F: TCurrencyEdit;
    O1F: TCurrencyEdit;
    O2F: TCurrencyEdit;
    O3F: TCurrencyEdit;
    O4F: TCurrencyEdit;
    O5F: TCurrencyEdit;
    A1Lab: TLabel;
    A2Lab: TLabel;
    A4Lab: TLabel;
    A5Lab: TLabel;
    A6Lab: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    AgeLab: TLabel;
    Bevel1: TBevel;
    Pan1: TSBSBackGroup;
    Label831: Label8;
    Label833: Label8;
    Label834: Label8;
    Pan2: TSBSBackGroup;
    Label835: Label8;
    Label81: Label8;
    Id4QPF: TCurrencyEdit;
    PickLab: Label8;
    LocBtn: TButton;
    Label82: Label8;
    Id4QIWF: TCurrencyEdit;
    Label83: Label8;
    Id4QFF: TCurrencyEdit;
    Label84: Label8;
    Id4QPWF: TCurrencyEdit;
    Label1: TLabel;
    W1F: TCurrencyEdit;
    W2F: TCurrencyEdit;
    W3F: TCurrencyEdit;
    W4F: TCurrencyEdit;
    W5F: TCurrencyEdit;
    BinPage: TTabSheet;
    ODOLine: TSBSOutlineB;
    EquivPage: TTabSheet;
    ODOLine2: TSBSOutlineB;
    FreezeBtn: TButton;
    procedure FormCreate(Sender: TObject);
    procedure OkCP1BtnKeyPress(Sender: TObject; var Key: Char);
    procedure PageControl1Change(Sender: TObject);
    procedure OkCP1BtnClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure FormDestroy(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure Id4QOFDblClick(Sender: TObject);
    procedure LocBtnClick(Sender: TObject);
    procedure ODOLineExpand(Sender: TObject; Index: Integer);
    procedure ODOLine2Expand(Sender: TObject; Index: Integer);
    procedure FormResize(Sender: TObject);
    procedure FreezeBtnClick(Sender: TObject);
    procedure ODOLine2Click(Sender: TObject);
  private
    { Private declarations }
    InReset,
    ObjectMode,
    Frozen,
    fNeedToRestore,
    GotCoord,
    ScanMode,
    NewPage  :  Boolean;

    DispStk  :  TFStkDisplay;

    ShowTotals
             :  TStkEnqThread;

    AllocNum :  Array[0..2] of AgedTyp;

    ExLocal  :  TdExLocal;

    MLocListPtr
             :  Pointer;

    {$IFDEF SOP}
        AltIdxPos       :  Array[0..4] of LongInt;
        InEquivReset,
        SupressOpo      :  Boolean;
    {$ENDIF}


    //PR: 16/03/2012 ABSEXCH-12399
    FStockFormDisplayed : Boolean;

    procedure FormBMPCreate;

    Procedure ChangePage(NewPage  :  Integer);

    Function Current_Page  :  Integer;

    Procedure Send_UpdateList(Edit   :  Boolean;
                              Mode   :  Integer);

    Procedure Out_AllocHed(Mode   :  Byte);

    Procedure Out_Alloc(Mode   :  Byte);

    Function DetRange(PCode  :  Str20;
                      ToDate :  LongDate)  :  Byte;

    Function Compare_Dates(ToDate,DlDate  :  Str8;
                           DrvMode        :  Byte)  :  LongInt;

    Procedure Get_StockAged(Var  StockPos  :  AgedTyp;
                                 Idr       :  IDetail;
                                 ChkDate   :  LongDate;
                                 DrvMode   :  Byte);

    Procedure View_Allocation(PCode     :  Str20;
                              AllocQty,
                              OnOrdQty  :  Real);

    Procedure WMCustGetRec(Var Message  :  TMessage); Message WM_CustGetRec;

    Procedure WMFormCloseMsg(Var Message  :  TMessage); Message WM_FormCloseMsg;

    {$IFDEF SOP}
      procedure Link2MLoc(ScanMode  :  Boolean);
    {$ENDIF}

    procedure CalcTotals;

    procedure ResetTotals;

    procedure Display_ObjectMode(SCode  : Str20;
                                 LCode,
                                 CCode  : Str10);

    procedure Link2Stk(StkViewFilter  :  Byte);

    procedure DestroyNodes;

    procedure BuildOBins(Idx  :  Integer);

    procedure BuildObjectDrill;

    {$IFDEF SOP}

    procedure DestroyNodes2;

    procedure BuildOEquivStk(Idx  :  Integer);

    procedure BuildObjectEquiv;

    {$ENDIF}


  public
    { Public declarations }

    fCustCode,
    fLocFilt:  Str10;

    fPCode  :  Str20;

    fQAL,
    fQOO    :  Double;

    fPHandle:  THandle;

    fpOSCode  :  Str20;
    fpOSQty   :  Double;
    fpSetQty  :  Boolean;
    fpSetCurr :  Byte;

    procedure InitScanMode;

    procedure InitObjectMode(SCode  :  Str20;
                             LCode,
                             CCode  :  Str10);

    procedure ShowAged;
    procedure ShowBinAvailability;

    {$IFDEF SOP}
      procedure SetEquivView(SectionNo  :  Integer);

      Function ReturnObjectEquiv  :  Boolean;

      Function ReturnObjectMLoc  :  MLocRec;

    {$ENDIF}

    //PR: 16/03/2012 ABSEXCH-12399
    property StockFormDisplayed : Boolean read FStockFormDisplayed;
  end;


{~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~}

Implementation

{~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~}

Uses
  ETStrU,
  ETMiscU,
  ETDateU,
  BtrvU2,

  ExtGetU,

  BTSupU2,
  CmpCtrlU,
  BTKeys1U,
  SOPCt2U,
  {$IFDEF SOP}
    MLoc0U,
    InvLst3U,

    AltCRe2U,
    //PR: 20/04/2009
    MultiBuyFuncs,
    MultiBuyVar,
  {$ENDIF}

  Saltxl1U,

  SysU2;


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
                NOQty,
                NNeedData:  Boolean;
                NOCurr,
                NMiscMode:  Byte;
                NOurRef  :  Str10;
                NValue   :  Double;
              end; {Rec..}


Constructor tdSOPFuncs.Create(MTE  :  tdMTExLocalPtr);

Begin
  MTExLocal:=MTE;

end;


Destructor tdSOPFuncs.Destroy;

Begin


end;


Function tdSOPFuncs.LGet_LastAlloc(FileKey  :  Str255;
                               Var FoundOk  :  Boolean;
                                   Presv    :  Boolean)  :  Real;



Const
  Fnum     =  PWrdF;

  KeyPAth  =  PWK;

Var
  TmpKPath,
  TmpStat  :  Integer;

  TmpRecAddr
           :  LongInt;

  TmpPWrd  :  PassWordRec;



Begin
  Result := 0;
  If (Assigned(MTExLocal)) then
  With MTExLocal^ do
  Begin

    TmpKPath:=GetPosKey;

    TmpPWrd:=LPassWord;

    TmpStat:=LPresrv_BTPos(Fnum,TmpKPath,LocalF^[Fnum],TmpRecAddr,BOff,BOff);


    LStatus:=LFind_Rec(B_GetEq,Fnum,Keypath,FileKey);


    FoundOk:=LStatusOk;

    If (FoundOk) then
      LGet_LastAlloc:=LPassword.AllocFileRec.AllocSF
    else
      LGet_LastAlloc:=0;


    If (Presv) then
    Begin
      TmpStat:=LPresrv_BTPos(Fnum,TmpKPath,LocalF^[Fnum],TmpRecAddr,BOn,BOff);
      LPassWord:=TmpPWrd;
    end;
  end; {With..}

end; {Func..}



Procedure tdSOPFuncs.LPut_LastAlloc(FoundOk  :  Boolean;
                                    AllocVal :  Real;
                                    ASubCode :  Char;
                                    EMode    :  LongInt);



Const
  Fnum     =  PWrdF;

  KeyPAth  =  PWK;


Var
  FOk      :  Boolean;

  GAlloc   :  Real;

  TmpKPath,
  TmpStat  :  Integer;

  TmpRecAddr
           :  LongInt;

  TmpPWrd  :  PassWordRec;


Begin
  If (Assigned(MTExLocal)) then
  With MTExLocal^ do
  Begin
    TmpPWrd:=LPassWord;

    TmpKPath:=GetPosKey;

    TmpStat:=LPresrv_BTPos(Fnum,TmpKPath,LocalF^[Fnum],TmpRecAddr,BOff,BOff);

    With LPassword do
    With AllocFileRec do
    Begin

      GAlloc:=LGet_LastAlloc(FullAllocFile(AllocTCode,ASubCode,EMode),FOk,BOff);


      If (Not FOk) then
      Begin

        LResetRec(Fnum);

        RecPFix:=AllocTCode;

        SubType:=ASubCode;

        AllocCode:=FullNomKey(Emode)+HelpKStop;

        AllocSF:=AllocVal;

        LStatus:=LAdd_Rec(Fnum,Keypath);

      end
      else
      Begin

        AllocSF:=AllocSF+AllocVal;

        LStatus:=LPut_Rec(Fnum,Keypath);

      end;


      LReport_BError(Fnum,LStatus);

    end; {With..}

    TmpStat:=LPresrv_BTPos(Fnum,TmpKPath,LocalF^[Fnum],TmpRecAddr,BOn,BOff);

    LPassWord:=TmpPwrd;
  end;
end; {Proc..}



{ ============= Procedure to Clear Allocation =========== }


Procedure tdSOPFuncs.LReset_Alloc(ASubCode  :  Char);


Const
  Fnum     =  PwrdF;

  Keypath  =  PWK;



Var
  KeyChk,
  KeyS     :  Str255;
  MsgForm  :  TForm;




Begin

  KeyCHk:=AllocTCode+ASubCode;

  KeyS:=KeyChk;

  If (Assigned(MTExLocal)) then
  With MTExLocal^ do
  Begin

    LStatus:=LFind_Rec(B_GetGEq,Fnum,Keypath,KeyS);


    While (LStatusOk) and (CheckKey(KeyChk,KeyS,Length(KeyChk),BOff)) do
    Begin

      LStatus:=LDelete_Rec(Fnum,KeyPath);

      LReport_Berror(Fnum,LStatus);

      LStatus:=LFind_Rec(B_GetNext,Fnum,Keypath,KeyS);

    end; {Loop..}
  end; {With..}
end; {Proc..}



{ TStkEnq }

constructor TStkEnqThread.Create(StockR   :  StockRec;
                                 TMode    :  Byte;
                                 TC1      :  TCurrencyEdit);

begin
  BeingCreated1:=BOn;

  FreeOnTerminate := BOff;
  fMode:=TMode;

  
  Display[1]:=TC1;

  ExecuteOff:=BOff;

  FillChar(Totaged,Sizeof(TotAged),0);

  New(ExLocal,Create(31+fMode));

  try
    With ExLocal^ do
    Begin

      Open_System(StockF,PWrdF);
      LStock:=StockR;

    end;

    New(StkFuncs,Create(ExLocal));

  except
    ShowMessage('Unable to create Stock Enquiry thread.');
    StkFuncs:=nil;
  end;

  inherited Create(True);

  Priority:=tpIdle;

  Resume;

end;

Destructor TStkEnqThread.Destroy;

Begin

  Inherited Destroy;
end;


procedure TStkEnqThread.CleanUp;

Begin
  If (Assigned(StkFuncs)) then
    Dispose(StkFuncs,Destroy);

  Dispose(ExLocal,Destroy);

end;


procedure TStkEnqThread.Set_NewStock(StockR  :  StockRec);

Begin
  ExLocal^.LStock:=StockR;
end;

procedure TStkEnqThread.ThreadDelay(dt  :  Word;
                                    SAPM:  Boolean);

Var
  ThTimeS,
  thTimeN   :  TDateTime;

  thGap     :  Double;

Begin
  thTimeS:=Now;

  thGap:=dt/1e8;

  Repeat
    thTimeN:=Now-ThTimeS;

    If (SAPM) then
      Application.ProcessMessages;

  Until (thTimeN>thgap);

end;

Function TStkEnqThread.WaitforTerminate  :  Boolean;

Var
  n       :  Integer;

  TmpBo   :  Boolean;

Begin
  n:=0;

  Repeat

    Inc(n);

    Application.ProcessMessages;

    ThreadDelay(200,BOn);

    TmpBo:=Terminated;

    ThreadDelay(200,BOn);

    If (TmpBo) then
      TmpBo:=ExecuteOff;

  Until (TmpBo) or (n>9);

  Result:=TmpBo;
end;


procedure TStkEnqThread.SetTotals;
Var
  n  :  Byte;
begin
  For n:=1 to 5 do
    If (Assigned(Display[n])) then
      Display[n].Value:=TotAged[n];

end;

procedure TStkEnqThread.OutTotals;
begin
  Synchronize(SetTotals);
end;

{ The Execute method is called when the thread starts }

procedure TStkEnqThread.Execute;
begin
  ExecuteOff:=BOff;

  try
    Case fMode of
      0  :  LHowManyBOM(ExLocal^.LStock,BOff,BOn);

    end; {Case..}
  finally
    ExecuteOff:=BOn;
  end;

end;



{ ==== Follow Chain and calc max poss build qty ==== }

{ ==== Replicated in SOPCT3U ==== }

Function TStkEnqThread.LHowManyBOM(StockR  :  StockRec;
                                   WithOwn,
                                   TopMan  :  Boolean)  :  Double;

Const

  Fnum     =  PWrdF;

  Keypath  =  PWK;


  Fnum2    =  StockF;
  Keypath2 =  StkFolioK;



Var
  NoStop,
  TmpOk,
  Ok2Cont  :  Boolean;

  KeyS,
  KeyChk,
  KeyStk   :  Str255;

  RecAddr2,
  RecAddr  :  LongInt;

  QtyAvail,
  fQtyUsed,
  BomQtyUsed,
  MaxQty,
  LowQty   :  Double;

  OldStk   :  StockRec;


Begin
  MaxQty:=0; LowQty:=0; Result:=0; QtyAvail:=0;  BOMQtyUsed:=0.0;

  Ok2Cont:=BOn; TmpOk:=BOff; fQtyUSed:=0.0;

  NoStop:=Not Terminated;


  With ExLocal^ do
  Begin

    OldStk:=LStock;

    If (TopMan) then
      LStatus:=LGetPos(Fnum,RecAddr2);

    With StockR do
    Begin

      KeyS:=Strip('R',[#32],FullMatchKey(BillMatTCode,BillMatSCode,FullNomKey(StockFolio)));

      KeyChk:=KeyS;

      {$IFDEF SOP}

          {LStock_LocSubst(StockR,lc); Not sure yet if componets should be location based? }

       {$ENDIF}

    end;

    StkFuncs^.LReset_Alloc(AllocBCode);

    LStatus:=LFind_Rec(B_GetGEq,Fnum,Keypath,KeyS);

    BeingCreated1:=BOff;

    While (LStatusOk) and (CheckKey(KeyChk,KeyS,Length(KeyChk),BOn)) and (Ok2Cont) and (NoStop) and (Not Terminated) do
    With LPassword.BillMatRec do
    Begin
      LStatus:=LGetPos(Fnum,RecAddr);


      KeySTk:=Copy(BillLink,1,Sizeof(RecAddr));

      LStatus:=LFind_Rec(B_GetEq,Fnum2,Keypath2,KeyStk);

      BOMQtyUsed:=QtyUsed;

      If (LStatusOk) and (LStock.StockType<>StkDescCode) then
      Begin
        {$IFDEF SOP}

            {LStock_LocSubst(Stock,lc); Not sure yet if componets should be location based? }

          {$ENDIF}

        If (LStock.StockType<>StkBillCode) then
        Begin

          QtyAvail:=LStock.QtyInStock;

          {* This takes into account any allocation during auto pick as well
                            If used for any other purpase, additional switch required *}
          QtyAvail:=(LStock.QtyInStock-LStock.QtyPicked-
                     StkFuncs^.LGet_LastAlloc(FullAllocFile(AllocTCode,AllocBCode,LStock.StockFolio),TmpOk,BOn){-
                     StkFuncs^.LGet_LastAlloc(FullAllocFile(AllocTCode,AllocUCode,LStock.StockFolio),TmpOk,BOn)});

          If (QtyAvail>0) then
          Begin

            If (QtyUsed<>0) then
              fQtyUsed:=QtyUsed
            else
              fQtyUsed:=1;

            MaxQty:=Trunc(DivWChk(QtyAvail,fQtyUsed));

          end
          else
            MaxQty:=0;

          StkFuncs^.LPut_LastAlloc(BOff,QtyUsed*MaxQty,AllocBCode,LStock.StockFolio);


        end
        else
          MaxQty:=Trunc(DivWChk(LHowManyBOM(LStock,BOn,BOff),BOMQtyUsed));


        Ok2Cont:=(MaxQty>0);

        If (MaxQty<LowQty) or (LowQty=0) then
          LowQty:=MaxQty;
      end; {If Stock record found..}


      LSetDataRecOfs(Fnum,RecAddr);

      LStatus:=LGetDirect(Fnum,KeyPath,0);

      If (Ok2Cont) then
        LStatus:=LFind_Rec(B_GetNext,Fnum,Keypath,KeyS);

      TotAged[1]:=Result;

      OutTotals;

    end; {While..}

    If (TopMan) then
    Begin
      LSetDataRecOfs(Fnum,RecAddr2);

      LStatus:=LGetDirect(Fnum,KeyPath,0);
    end;

    LStock:=OldStk;
  end; {If..}

  Result:=LowQty;

  If (WithOwn) then
    Result:=Result+StockR.QtyInStock;

  TotAged[1]:=Result;

  OutTotals;

end; {Proc..}




{ ======================================================================================= }








procedure TStkWarn.FormBMPCreate;

Var
  BMap1       :  TBitMap;

  RectD       :  TRect;
Begin
  BMap1:=TBitMap.Create;

  try

    If (ObjectMode) then
      BMap1.Handle:=LoadBitMap(HInstance,'INFO_1')
    else
      BMap1.Handle:=LoadBitMap(HInstance,'EXCLAM_2');

    With BMap1 do
      RectD:=Rect(0,0,Width,Height);


    With Image1.Picture.Bitmap do
    Begin
      Width:=BMap1.Width;
      Height:=BMap1.Height;

      Canvas.Brush.Color:=clBtnFace;
      Canvas.BrushCopy(RectD,BMap1,RectD,clSilver);
    end;
  finally
    BMap1.Free;

  end; {try..}

  MLocListPtr:=nil;

end;

procedure TStkWarn.FormResize(Sender: TObject);
begin
    If (GotCoord) and ((BinPage.TabVisible) or (EquivPage.TabVisible)) then
    Begin
      ODOLine.Width:=ClientWidth-101;
      ODOLine.Height:=ClientHeight-31;

      ODOLine2.Width:=ODOLine.Width;
      ODOLine2.Height:=ODOLine.Height

    end;

end;

procedure TStkWarn.FormCreate(Sender: TObject);

Var
  n           :  Integer;
  HideWOR     :  Boolean;

begin
  GotCoord:=BOff;

  Frozen:=BOff;

  If Not NoXLogo then
    FormBMPCreate;

  For n:=0 to Pred(ComponentCount) do
    If (Components[n] is TCurrencyEdit) then
      TCurrencyEdit(Components[n]).DecPlaces:=Syss.NoQtyDec;

  NewPage:=BOn;

  {$IFNDEF SOP}

    AgeingPage.TabVisible:=BOff;

  {$ENDIF}


  {$IFDEF LTE}
    BinPage.TabVisible:=BOff;
    EquivPage.TabVisible:=BOff;
  {$ENDIF}


  fNeedToRestore:=BOff;

  HideWOR:=Not WOPOn;

  ScanMode:=BOff;
  ObjectMode:=BOff;
  DispStk:=nil;
  ShowTotals:=nil;

  InReset:=BOff;

  {$IFDEF SOP}
    InEquivReset:=BOff;
  {$ENDIF}

  fpHandle:=(Owner as TForm).Handle;

  ExLocal.Create;

  ClientHeight:=215;
  ClientWidth:=410;

  If (HideWOR) then
  Begin
    Label834.Visible:=BOff;
    Label82.Visible:=BOff;
    Id4QAWF.Visible:=BOff;
    Id4QIWF.Visible:=BOff;
    Label83.Top:=Label834.Top;
    Id4QFF.Top:=Id4QAWF.Top;
    Pan1.Height:=102;
    Label84.Visible:=BOff;
    Id4QPWF.Visible:=BOff;
    Pan2.Height:=102;

    LocBtn.Top:=157;
    OkCp1Btn.Top:=181;

    Panel1.Height:=75;
    Label1.Visible:=BOff;
    W1F.Visible:=BOff;
    W2F.Visible:=BOff;
    W3F.Visible:=BOff;
    W4F.Visible:=BOff;
    W5F.Visible:=BOff;


    ClientHeight:=158;
  end;

  {$IF Defined(SOP) and Not Defined(LTE)}
    EquivPage.TabVisible:=BOn; {v5.61.001 was being hidden if WOP not enabled for some reason...}

    SupressOpo:=BOff;

  {$IFEND}

  GotCoord:=BOn;

  //PR: 16/03/2012 ABSEXCH-12399
  FStockFormDisplayed := False;
end;




{ == Procedure to Send Message to Get Record == }

Procedure TStkWarn.Send_UpdateList(Edit   :  Boolean;
                                   Mode   :  Integer);

Var
  Message1 :  TMessage;
  MessResult
           :  LongInt;

Begin
  FillChar(Message1,Sizeof(Message1),0);

  With Message1 do
  Begin
    If (ObjectMode) then
      Msg:=WM_FormCloseMsg
    else
      MSg:=WM_CustGetRec;

    WParam:=Mode;

    LParam:=Ord(Edit);
  end;


  With Message1 do
    MessResult:=SendMEssage(fpHandle,Msg,WParam,LParam);

end; {Proc..}

procedure TStkWarn.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Action:=CaFree;

  If Assigned(ShowTotals) then
  With ShowTotals do
  Begin
    try
      Terminate;
      WaitForTerminate;

      If (Not ExecuteOff) then
        Suspend;
      CleanUp;
      Free;
    except;
      ShowTotals.CleanUp;
      ShowTotals.Free;
    end;
  end;

  DestroyNodes;


  {$IFDEF SOP}
    DestroyNodes2;

  {$ENDIF}

end;

procedure TStkWarn.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
begin
  If (ScanMode) then
    Send_UpdateList(BOff,211);
end;

procedure TStkWarn.FormDestroy(Sender: TObject);
begin
  ExLocal.Destroy;
end;

procedure TStkWarn.OkCP1BtnKeyPress(Sender: TObject; var Key: Char);
begin
  If (Key=Esc) then
    ModalResult:=mrCancel;

  If (ScanMode) then
    Close
  else
    GlobFormKeyPress(Sender,Key,ActiveControl,Handle);

end;


procedure TStkWarn.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);

Var
  LastAHK  :  Boolean;

begin
  LastAHK:=AllowHotKey;

  If (Not ScanMode) then
    AllowHotKey:=((Key In [VK_Prior,VK_Next,VK_Home,VK_End]) and (ssCtrl In Shift));

  GlobFormKeyDown(Sender,Key,Shift,ActiveControl,Handle);

  If (Not ScanMode) then
    AllowHotKey:=LastAHK;
end;


Function TStkWarn.Current_Page  :  Integer;
Begin

  Result:=pcLivePage(PAgeControl1);

end;

Procedure TStkWarn.WMCustGetRec(Var Message  :  TMessage);

Begin


  With Message do
  Begin


    Case WParam of

     18  :  Begin
              DispStk:=nil;
            end;


     175
         :  With PageControl1 do
              ChangePage(FindNextPage(ActivePage,(LParam=0),BOn).PageIndex);

     {$IFDEF SOP}
     1129 :  Begin
               SupressOpo:=BOn;
             end;

     {$ENDIF}

    end; {Case..}

  end;
  Inherited;
end;


Procedure TStkWarn.WMFormCloseMsg(Var Message  :  TMessage);

Begin

  With Message do
  Begin

    Case WParam of

      {$IFDEF SOP}
        43 :  MLocListPtr:=nil;
      {$ELSE}
        43  :  ;
      {$ENDIF}

    end; {Case..}

  end;

  Inherited;
end;


Procedure TStkWarn.ChangePage(NewPage  :  Integer);


Begin

  If (Current_Page<>NewPage) then
  With PageControl1 do
  Begin
    LockWindowUpdate(Self.Handle);

    ActivePage:=Pages[NewPage];

    PageControl1Change(PageControl1);

    LockWindowUpdate(0);
  end; {With..}
end; {Proc..}


{ =============== Quick Check on Allocation Split  ============= }

Procedure TStkWarn.Out_AllocHed(Mode   :  Byte);



Var

  AgeStr,
  Age1Str  :  String[6];


  n        :  Byte;


Begin

  Case Mode of

    1  :  AgeStr:='Days  ';
    2  :  AgeStr:='Weeks ';
    else  AgeStr:='Months';

  end; {Case..}

  AgeLab.Caption:=AgeStr;

end;


Procedure TStkWarn.Out_Alloc(Mode   :  Byte);

Begin

  A1F.Value:=AllocNum[0,1];
  A2F.Value:=AllocNum[0,2];
  A3F.Value:=AllocNum[0,3];
  A4F.Value:=AllocNum[0,4];
  A5F.Value:=AllocNum[0,5];

  O1F.Value:=AllocNum[1,1];
  O2F.Value:=AllocNum[1,2];
  O3F.Value:=AllocNum[1,3];
  O4F.Value:=AllocNum[1,4];
  O5F.Value:=AllocNum[1,5];

  W1F.Value:=AllocNum[2,1];
  W2F.Value:=AllocNum[2,2];
  W3F.Value:=AllocNum[2,3];
  W4F.Value:=AllocNum[2,4];
  W5F.Value:=AllocNum[2,5];

end; {Proc..}


{ ======== Function Determine Ageing Range ========== }

Function TStkWarn.DetRange(PCode  :  Str20;
                           ToDate :  LongDate)  :  Byte;



Const

  LTAry    :  Array[0..2] of DocTypes = (SOR,POR,WOR);



Var
  KeyS,
  KeyChk   :  Str255;

  TmpMode  :  Byte;
  FoundOk  :  Boolean;

  Loop     :  Byte;

  NextAL   :  LongInt;


Begin

  TmpMode:=1;

  FoundOk:=BOff;
  Loop:=0;

  NextAL:=0;

  {* Check First Matching SOR, if none, then POR *}


  Repeat

    KeyChk:=FullIdType(StkLineType[LTAry[Loop]],PCode);

    FoundOk:=CheckRecExsists(KeyChk,IDetailF,IdAnalK);

    Inc(Loop);

  Until (Loop>1+Ord(WOPOn)) or (FoundOk);


  If (FoundOk) then
  Begin
    NextAL:=NoDays(ToDate,Id.Pdate);

    If (NextAL>29) then
      TmpMode:=3
    else
      If (NextAL>5) then
        TmpMode:=2;

  end;

  DetRange:=TmpMode;

end; {Func..}


{ ======= Function to Return Stock Aged ======= }


Function TStkWarn.Compare_Dates(ToDate,DlDate  :  Str8;
                                DrvMode        :  Byte)  :  LongInt;


Var
  Res  :  LongInt;


Begin
  Res:=0;

  Case DrvMode of

    1  :  Res:=NoDays(Todate,DlDate);

    2  :  Res:=Round(DivwChk(NoDays(ToDate,DlDate),7));

    else
          Res:=MonthDiff(ToDate,DlDate);

  end;

  If (Res<0) then
    Res:=0;

  Compare_Dates:=Res;

end; {Func..}



{ ======= Proc to Age Stock Anal ====== }

Procedure TStkWarn.Get_StockAged(Var  StockPos  :  AgedTyp;
                                      Idr       :  IDetail;
                                      ChkDate   :  LongDate;
                                      DrvMode   :  Byte);

Var
  Anal    :  Integer;

  TotQty  :  Real;


Begin


  With Idr do
  Begin

    Anal:=Compare_Dates(ChkDate,PDate,DrvMode);

    If (IdDocHed<>WOR) then
      TotQty:=CaseQty(Stock,DeductQty)
    else
      TotQty:=Qty_OS(IdR);


    Case Anal of

      0..1  :  StockPos[1]:=StockPos[1]+TotQty;

      2..4  :  StockPos[Anal]:=StockPos[Anal]+TotQty;

      else     StockPos[5]:=StockPos[5]+TotQty;

    end; {case..}

  end; {with..}

end; {Proc..}





{ =============== Proc Scan detail and predict allocation =========== }

Procedure TStkWarn.View_Allocation(PCode     :  Str20;
                                   AllocQty,
                                   OnOrdQty  :  Real);


Const
  Fnum     =  IDetailF;

  Keypath  =  IdAnalK;

  LTAry    :  Array[0..2] of DocTypes = (SOR,POR,WOR);


Var

  TmpKPath,
  TmpStat  :  Integer;

  TmpRecAddr
           :  LongInt;


  KeyS,
  KeyChk   :  Str255;


  Loop     :  Byte;

  TmpId    :  IDetail;

  Mode     :  Byte;



Begin

  Blank(AllocNum,Sizeof(AllocNum));

  Loop:=0;

  TmpId:=Id;

  TmpKPath:=GetPosKey;

  TmpStat:=Presrv_BTPos(Fnum,TmpKPath,F[Fnum],TmpRecAddr,BOff,BOff);

  Mode:=3;


  If ((AllocQty+OnOrdQty)<>0) then
  Begin

    Mode:=DetRange(PCode,Today);

    Out_AllocHed(Mode);

    Repeat

      KeyChk:=FullIdType(StkLineType[LTAry[Loop]],PCode);

      KeyS:=KeyChk;

      Status:=Find_Rec(B_GetGEq,F[Fnum],Fnum,RecPtr[Fnum]^,KeyPath,KeyS);

      While (StatusOk) and (CheckKey(KeyChk,KeyS,Length(KeyChk),BOn)) and (ModalResult=mrNone) do
      With Id do
      Begin

        If (CheckKey(fLocFilt,MLocStk,Length(fLocFilt),BOff)) and ((IdDocHed<>WOR) or (ABSLineNo=1)) then
          Get_StockAged(AllocNum[Loop],Id,Today,Mode);

        Out_Alloc(Mode);

        Status:=Find_Rec(B_GetNext,F[Fnum],Fnum,RecPtr[Fnum]^,KeyPath,KeyS);

        Application.ProcessMessages;

      end; {While..}

      Inc(Loop)

    Until (Loop>1+Ord(WOPOn));


  end {If Alloc<>0..}
  else
    Out_Alloc(Mode);


  TmpStat:=Presrv_BTPos(Fnum,TmpKPath,F[Fnum],TmpRecAddr,BOn,BOff);

  Id:=TmpId;
  //HV and R Jha 06/01/2016, JIRA-2526, Stock - Bin Availability / Equivalents blank via 'AGE' button on stock lisl and telesales screen.
  //NewPage:=BOff;

end; {Proc..}



procedure TStkWarn.PageControl1Change(Sender: TObject);

Var
  NewIndex  :  Integer;

begin
  If (Sender is TPageControl) then
    With Sender as TPageControl do
    Begin
      NewIndex:=pcLivePage(Sender);

      Case NewIndex of

        {$IFDEF SOP}

          0  :  Begin
                  If (fNeedToRestore) and (Not ObjectMode) then
                  Begin
                    fNeedToRestore:=BOff;

                    SendToObjectStkEnq(fPCode,fCustCode,fLocFilt,-1,-1,0);

                  end;
                end;
        {$ENDIF}

        1  :  Begin
                If (NewPage) or (ObjectMode) then
                  View_Allocation(fPCode,fQAL,fQOO);

              end;

        2  :  If (NewPage) and (ExLocal.LStock.MultiBinMode) then
                BuildObjectDrill;

      {$IFDEF SOP}
        3  :  If (NewPage)  then
                BuildObjectEquiv;
      {$ENDIF}


      end; {Case..}

    end; {With..}
end;

procedure TStkWarn.OkCP1BtnClick(Sender: TObject);
begin
  If (ScanMode) then
    Close;

end;


{$IFDEF SOP}
  procedure TStkWarn.Link2MLoc(ScanMode  :  Boolean);

  Var
    WasNew    :  Boolean;
    MLocList  :  TLocnList;

  begin
    WasNew:=BOff;


    Begin
      MLocList:=MLocListPtr;

      If (Not Assigned(MLocList)) then
      Begin
        Set_MLFormMode(21);
        MLocList:=TLocnList.Create(Self);
        WasNew:=BOn;
        MLocListPtr:=MLocList;
      end;


      With MLocList do
      Begin
        try
          LSRKey:=Self.ExLocal.LStock.StockCode;
          ExLocal.LStock:=Self.ExLocal.LStock;

          If (WasNew) then
            ChangePage(1)
          else
          Begin

            If (WindowState=wsMinimized) then
              WindowState:=wsNormal;

            RefreshList(BOn,BOn);

            If (Not ScanMode) then
              Show;
          end;

        except
          MLocList.Free;
          MLocList:=nil;
          MLocListPtr:=nil;
        end; {try..}
      end; {With..}
    end;
  end;

{$ENDIF}

procedure TStkWarn.LocBtnClick(Sender: TObject);
begin
  If (ScanMode) and (Not ObjectMode) then
    Close
  else
    If (ObjectMode) then
    Begin
      {$IFDEF SOP}
        Link2MLoc(BOff);
      {$ENDIF}
    end;
end;


procedure TStkWarn.InitScanMode;

Begin
  ScanMode:=BOn;
  StkLevelsPage.TabVisible:=BOff;

  PageControl1.ActivePage:=AgeingPage;

  FormStyle:=fsMDIChild;
end;



procedure TStkWarn.CalcTotals;


Begin

  With ExLocal do
  If (ShowTotals=nil) and (LStock.StockCode<>'') then
    ShowTotals:=TStkEnqThread.Create(LStock,0,Id4QNF);

end;



procedure TStkWarn.ResetTotals;

Var
  n  :  Integer;

Begin
  InReset:=BOn;

  If (ShowTotals<>nil) then
  With ShowTotals do
  Begin
    If (Not BeingCreated1) then
    Begin

      Terminate;

      If (WaitForTerminate) then
      Begin
        If (Not ShowTotals.ExecuteOff) then
          ShowTotals.Suspend;

        ShowTotals.CleanUp;
        ShowTotals.Free;
        ShowTotals:=nil;
        CalcTotals;
      end
      else
        If (Debug) then
          ShowMessage('Stk Enquiry Thread Not aborted correctly in ObjectStkEnq')
        else
          MessageBeep(0);
    end; {We have not really started yet, so cannot terminate}
  end
  else
    CalcTotals;

  InReset:=BOff;

end;



procedure TStkWarn.Display_ObjectMode(SCode  : Str20;
                                      LCode,
                                      CCode  : Str10);

Var
  GotOk  :  Boolean;
  LocTit :  Str80;

Begin
  With ExLocal,LStock do
  Begin
    LocTit:='';

    If (LStock.StockCode<>SCode) then
      GotOk:=LGetMainRecPos(StockF,SCode)
    else
      GotOk:=BOn;

    If (GotOk) then
    Begin
      If (Current_Page<>0) and (Current_Page<>3) then
        ChangePage(0);

      Caption:='ObjectStock Enquiry : '+LocTit+dbFormatName(StockCode,Desc[1]);

      fPCode:=SCode;
      fLocFilt:=LCode;
      fCustCode:=CCode;

      fQAL:=CaseQty(LStock,AllocStock(Stock));
      fQOO:=CaseQty(LStock,QtyOnOrder);

      BinPage.TabVisible:=MultiBinMode;


      {$IFDEF SOP}
        If (Not EmptyKey(fLocFilt,LocKeyLen)) and Syss.UseMLoc then
        Begin
          LocTit:=' - Locn : '+fLocFilt+'. ';

          Pan1.Caption:='At Location : '+fLocFilt;

          Stock_LocSubst(LStock,fLocFilt);


        end
        else
        Begin
          Pan1.Caption:='';
        end;

        LocBtn.Visible:=Syss.UseMLoc;

        If (Assigned(MLocListPtr)) then
          Link2MLoc(BOn);

        Pan2.Caption:=Pan1.Caption;

        Id4QPF.Value:=CaseQty(LStock,QtyPicked);

      {$ENDIF}

      Id4QOF.Value:=CaseQty(LStock,QtyInStock);
      Id4QAF.Value:=CaseQty(LStock,AllocStock(LStock));
      Id4QFF.Value:=CaseQty(LStock,FreeStock(LStock));
      Id4QOSF.Value:=CaseQty(LStock,QtyOnOrder);
      Id4QAWF.Value:=CaseQty(LStock,QtyAllocWOR);
      Id4QIWF.Value:=CaseQty(LStock,QtyIssueWOR);
      Id4QPWF.Value:=CaseQty(LStock,QtyPickWOR);

      If (LStock.StockType=StkBillCode) then
      Begin
        Label835.Visible:=BOn;
        Label835.Caption:='Could build';
        Id4QNF.Visible:=BOn;

        If (WOPOn) then
          Label81.Caption:='On WOR';

        If (Not InReset) then
          ResetTotals;

      end
      else
      Begin
        Label835.Visible:=BOff;
        Id4QNF.Visible:=BOff;

        If (WOPOn) then
          Label81.Caption:='On POR';

      end;

      {$IFDEF SOP}
        If (EquivPage.TabVisible) and (Not InEquivReset) and (EquivPage=PageControl1.ActivePage) then
          BuildObjectEquiv;
      {$ENDIF}

    end;
  end;
end;


procedure TStkWarn.InitObjectMode(SCode  :  Str20;
                                  LCode,
                                  CCode  :  Str10);

Begin
  If (Not ObjectMode) then
  Begin
    ScanMode:=BOn;
    ObjectMode:=BOn;
    FormStyle:=fsMDIChild;

    Left:=Screen.Width-Width+1;

    Caption:='ObjectStock Enquiry';

    BorderStyle:=bsSizeable;

    FormBMPCreate;

    FreezeBtn.Visible:=BOn;

    {$IFDEF SOP}
      Id4QPF.Visible:=BOn;
      PickLab.Visible:=BOn;
    {$ENDIF}
  end;

  If (Not Frozen) then
    Display_ObjectMode(SCode,LCode,CCode);
end;


{$IFDEF SOP}
  procedure TStkWarn.SetEquivView(SectionNo  :  Integer);

  Begin
    If (Current_Page<>3) then
      ChangePage(3);

    With ODOLine2 do
    Begin
      If (AltIdxPos[SectionNo]<>0) and (AltIdxPos[SectionNo]<=ItemCount) then
        SelectedItem:=AltIdxPos[SectionNo];

    end; {With..}

  end;

{$ENDIF}


procedure TStkWarn.Link2Stk(StkViewFilter  :  Byte);

Begin

  If (DispStk=nil) then
    DispStk:=TFStkDisplay.Create(Self);

  try
    If (Stock.StockCode<>ExLocal.LStock.StockCode) and (ObjectMode) then
      ExLocal.AssignToGlobal(StockF);

    With DispStk do

      Display_Account(StkViewFilter);

  except

    DispStk.Free;
    DispStk:=nil;
  end;

end;


procedure TStkWarn.ShowAged;

Var
  LocTit  :  Str80;

Begin
  LocTit:='';

  With ExLocal,LStock do
  Begin
    AssignFromGlobal(StockF);

    {$IFDEF SOP}
      If (Not EmptyKey(fLocFilt,LocKeyLen)) then
        LocTit:=' - Locn : '+fLocFilt+'. ';

    {$ENDIF}

    Caption:='Supply/Demand : '+LocTit+dbFormatName(StockCode,Desc[1]);

    View_Allocation(StockCode,AllocStock(LStock),QtyOnOrder);
  end;
end;

//HV and R Jha 06/01/2016, JIRA-2526, Stock - Bin Availability / Equivalents blank via 'AGE' button on stock lisl and telesales screen.
procedure TStkWarn.ShowBinAvailability;
Begin  
  With ExLocal,LStock do
  Begin
    AssignFromGlobal(StockF);
  end;
end;


procedure TStkWarn.Id4QOFDblClick(Sender: TObject);

Var
  S  :  Byte;
begin
  S:=0;

  If (Sender=Id4QAF) then
    S:=41
  else
    If (Sender=Id4QPF) then
      S:=44
    else
      If (Sender=Id4QOSF) then
      Begin
        If (WOPOn) and (ExLocal.LStock.StockType=StkBillCode) then {Chances are its on a works order}
          S:=57
        else
          S:=42;
      end
      else
        If (Sender=Id4QAWF) or (Sender=Id4QIWF) then
          S:=57
        else
          If (Sender<>Image1) then
            S:=54;

  Link2Stk(S);

  //PR: 16/03/2012 ABSEXCH-12399 Record that we've displayed the stock window.
  FStockFormDisplayed := True;
end;


procedure TStkWarn.DestroyNodes;

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


procedure TStkWarn.BuildOBins(Idx  :  Integer);

Const
  Fnum  =  MLocF;

Var
  n,nIdx,ACnst,
  TmpStat,
  TmpKPath,
  Keypath
            :  Integer;

  Idx2,
  TmpRecAddr
            :  LongInt;

  ODDRec    :  ^ODDType;

  KeyS,KeyChk
            :  Str255;
  Ok2Add    :  Boolean;

  LastLoc   :  Str10;

  OLine     :  Str255;


Begin
  OKCP1Btn.Enabled:=BOff;

  With ODOLine,ExLocal,LStock do
  Begin
    Keypath:=MLSecK;  LastLoc:='';  Idx2:=Idx;

    TmpKPAth:=GetPosKey;

    TmpStat:=Presrv_BTPos(Fnum,TmpKPath,F[Fnum],TmpRecAddr,BOff,BOff);

    If (fLocFilt<>'') then
      KeyChk:=FullQDKey(brRecCode,MSernSub,FullNomKey(LStock.StockFolio)+Full_MLocKey(fLocFilt)+Chr(0))
    else
      KeyChk:=FullQDKey(brRecCode,MSernSub,FullNomKey(Stock.StockFolio));

    KeyS:=KeyChk;

    Status:=Find_Rec(B_GetGEq,F[Fnum],Fnum,LRecPtr[Fnum]^,KeyPath,KeyS);


    While (StatusOK) and (CheckKey(KeyChk,KeyS,Length(KeyChk),BOff)) do
    With LMLocCtrl^.brBinRec do
    Begin

      If (Not brSold) and (Not brBatchChild) then
      Begin
        New(ODDRec);

        FillChar(ODDRec^,Sizeof(ODDRec^),0);

        Ok2Add:=BOn;

        If (brInMLoc<>LastLoc) then
        Begin
          LastLoc:=brInMLoc;

          Idx2:=AddChildObject(Idx,'Loc: '+LastLoc,nil);
        end;


        With ODDRec^ do
        Begin
          NFnum:=MLocF;
          NKeypath:=MLSecK;
          NKey:=FullQDKey(brRecCode,MSernSub,brCode2);
          NLKey:=brCode2;

          OLine:=Trim(BrBincode1)+'.  '+Bin_AQty(brBuyQty,brQtyUsed,brBinCap,brBatchChild);


          n:=AddChildObject(Idx2,' '+OLine,ODDRec);
        end; {With..}
      end;

      Status:=Find_Rec(B_GetNext,F[Fnum],Fnum,LRecPtr[Fnum]^,KeyPath,KeyS);

    end; {While..}


    TmpStat:=Presrv_BTPos(Fnum,TmpKPath,F[Fnum],TmpRecAddr,BOn,BOff);

  end; {With..}

  OKCp1Btn.Enabled:=BOn;

end;


procedure TStkWarn.BuildObjectDrill;

Var
  n,Tmpn    :  Integer;
  ODDRec    :  ^ODDType;

  GenStr    :  Str255;

Begin
  With ODOLine,ExLocal,LStock do
  Begin

    DestroyNodes;
    Clear;

    If (MultiBinMode) then
    Begin
      New(ODDRec);

      FillChar(ODDRec^,Sizeof(ODDRec^),0);

      With ODDRec^ do
      Begin
        NFnum:=StockF;
        NKeypath:=StkCodeK;
        NKey:=StockCode;
        NOurRef:=StockCode;


        n:=AddChildObject(0,dbFormatName(StockCode,Desc[1]),ODDRec);

      end;



      BuildOBins(n);

    end;



    FullExpand;
  end; {With..}

end;

procedure TStkWarn.ODOLineExpand(Sender: TObject; Index: Integer);

Var
  ODDRec  :  ^ODDType;

begin
  ODDRec:=ODOLine.Items[Index].Data;

  With ODOLine do
  If (Not Items[Index].HasItems) and (Assigned(ODDRec)) then
  With ODDRec^ do
  Begin
    Control_FindBin(Self,NLKey,NKeypath);
  end;

end;


{$IFDEF SOP}
  procedure TStkWarn.DestroyNodes2;

  Var
    n       : Integer;
    ONomRec :  ^ODDType;

  Begin

    With ODOLine2 do {* Tidy up attached objects *}
    Begin
      For n:=1 to ItemCount do
      Begin
        ONomRec:=Items[n].Data;
        If (ONomRec<>nil) then
          Dispose(ONomRec);
      end;
    end; {With..}

  end;


  procedure TStkWarn.BuildOEquivStk(Idx  :  Integer);

  Const
    Fnum  =  MLocF;

  Var


    n,nIdx,ACnst,
    TmpStat,
    TmpKPath,
    Keypath
              :  Integer;

    Idx2,
    TmpRecAddr
              :  LongInt;

    ODDRec    :  ^ODDType;

    GenStr,KeyStk,
    KeyS,KeyChk
              :  Str255;
    SetHed,
    GotHed,
    Ok2Add    :  Boolean;

    LastLoc   :  Str10;

    OLine     :  Str255;

    TmpStk    :  StockRec;

    //PR: 20/04/2009
    {$IFDEF SOP}
     i : Integer;
     MBList : TStringList;
     MultiBuyFunctions : TMultiBuyFunctions;
    {$ENDIF}
  Begin
    OKCP1Btn.Enabled:=BOff;

    SupressOpo:=BOff;

    If (OpoLineHandle<>0) then {* Query if opo should be shown *}
      SendMessage(OpoLineHandle,WM_CustGetRec,1129,LongInt(Self.Handle));

    //PR: 20/04/2009
    {$IFDEF SOP}
    MultiBuyFunctions := TMultiBuyFunctions.Create;
    {$ENDIF}

    With ODOLine2,ExLocal,LStock do
    Begin
      Keypath:=MLSuppK;  LastLoc:='';  Idx2:=Idx;  SetHed:=BOff;

      TmpKPAth:=GetPosKey;

      TmpStat:=Presrv_BTPos(Fnum,TmpKPath,F[Fnum],TmpRecAddr,BOff,BOff);

      For n:=Low(AltSPFix) to High(AltSPFix) do
      Begin

        GotHed:=BOff;

        Case n of
            0  :  Keypath:=MLSecK;
            SuperSdPageNo
               :  Keypath:=MLK;

          else    Keypath:=MLSuppK;
        end; {Case..}

        If (n<>SuperSdPageNo) then
          KeyChk:=PartCCKey(NoteTCode,AltSPfix[n])+FullNomKey(Stock.StockFolio)
        else
          KeyChk:=PartCCKey(NoteTCode,AltSPfix[n])+Stock.StockCode;

        KeyS:=KeyChk;

        Status:=Find_Rec(B_GetGEq,F[Fnum],Fnum,LRecPtr[Fnum]^,KeyPath,KeyS);


        While (StatusOK) and (CheckKey(KeyChk,KeyS,Length(KeyChk),BOff)) and ((n<>OppoPageNo) or (Not SupressOpo)) do
        With LMLocCtrl^,sdbStkRec do
        Begin
          If (CheckKey(fCustCode,sdSuppCode,Length(fCustCode),BOff)) or (Trim(sdSuppCode)='') then
          Begin

            If (Not GotHed) then
            Begin
              GotHed:=BOn;

              Idx2:=AddChildObject(Idx,AltRecCaption[n],nil);

              SetHed:=BOn;
            end;

            Begin
              New(ODDRec);

              FillChar(ODDRec^,Sizeof(ODDRec^),0);

              Ok2Add:=BOn;

              With ODDRec^ do
              Begin
                NFnum:=MLocF;
                NKeypath:=MLK;
                NKey:=PartCCKey(RecPFix,SubType)+sdCode1;
                NLKey:=sdCode1;

                If (n=AltPageNo) then
                Begin
                  NValue:=sdROPrice;
                  nOQty:=sdOverRO;
                  NOCurr:=sdROCurrency;
                end
                else
                Begin
                  NValue:=sdLineQty;
                  nOQty:=sdOVerLineQty;
                end;

                NMiscMode:=n;

                If (n<>SuperSdPageNo) then
                Begin
                  If (sdOverLineQty) then
                    GenStr:=FormatBFloat(GenQtyMask,sdLineQty,BOn)+' x '+sdCode1
                  else
                    Case n of
                      AltPageNo  :  Begin
                                      If (sdOverRO) then
                                        GenStr:=FormatCurFloat(GenRealMask,sdROPrice,BOn,sdROCurrency)+'. '
                                      else
                                        GenStr:='';

                                      If (sdOverMinEcc) then
                                        GenStr:=GenStr+FormatBFloat(GenQtyMask,sdMinEccQty,BOn)+' x ';

                                      GenStr:=GenStr+sdCode1;
                                    end;

                      else          GenStr:=sdCode1;

                    end; {Case..}

                  OLine:=dbFormatName(GenStr,sdDesc);
                  {$IFDEF SOP}  //PR: 20/04/2009   //PR: 15/07/2009 Added -1 to get any currency
                  MBList := MultiBuyFunctions.GetMultiBuyList(Cust.CustCode, GenStr, Today, @ExLocal, -1, False);
                  {$ENDIF}
                end
                else
                Begin
                  TmpStk:=LStock;
                  KeyStk:=FullNomKey(sdStkFolio);

                  Status:=Find_Rec(B_GetEq,F[StockF],StockF,LRecPtr[StockF]^,StkFolioK,KeyStk);

                  If (StatusOk) then
                    OLine:=dbFormatName(LStock.StockCode,LStock.Desc[1])
                  else
                    OLine:='Stock Record not found.';

                  LStock:=TmpStk;
                end;



                nIdx:=AddChildObject(Idx2,' '+OLine,ODDRec);

                If (SetHed) then
                Begin
                  AltIdxPos[n]:=nIdx;
                  SetHed:=BOff;
                end;
                
                //PR: 20/04/2009
                {$IFDEF SOP}
                if Assigned(MBList) then
                Try
                  for i := 0 to MBList.Count - 1 do
                    AddChildObject(nIdx,' ' + MBList[i],nil);
                Finally
                  MultiBuyFunctions.FreeMultiBuyList(MBList);
                End;
                {$ENDIF}
              end; {With..}
            end;
          end; {If Supp filter applied..}

          Status:=Find_Rec(B_GetNext,F[Fnum],Fnum,LRecPtr[Fnum]^,KeyPath,KeyS);

        end; {While..}
      end; {Loop..}


      TmpStat:=Presrv_BTPos(Fnum,TmpKPath,F[Fnum],TmpRecAddr,BOn,BOff);

    end; {With..}

    //PR: 20/04/2009
    {$IFDEF SOP}
    if Assigned(MultiBuyFunctions) then
      MultiBuyFunctions.Free;
    {$ENDIF}

    OKCp1Btn.Enabled:=BOn;

  end;


  procedure TStkWarn.BuildObjectEquiv;

  Var
    n,Tmpn    :  Integer;
    ODDRec    :  ^ODDType;

    GenStr    :  Str255;

  Begin
    With ODOLine2,ExLocal,LStock do
    Begin
      InEquivReset:=BOn;

      Try
        DestroyNodes2;
        Clear;

        {If (MultiBinMode) then
        Begin
          New(ODDRec);

          FillChar(ODDRec^,Sizeof(ODDRec^),0);

          With ODDRec^ do
          Begin
            NFnum:=StockF;
            NKeypath:=StkCodeK;
            NKey:=StockCode;
            NOurRef:=StockCode;


            n:=AddChildObject(0,dbFormatName(StockCode,Desc[1]),ODDRec);

          end;



          BuildOEQuivStk(n);

        end;}


        BuildOEQuivStk(0);


        FullExpand;
      finally
        InEquivReset:=BOff;

      end;{try..}
    end; {With..}

  end;


  Function TStkWarn.ReturnObjectEquiv  :  Boolean;

  Var
    n,Tmpn    :  Integer;
    ODDRec    :  ^ODDType;


  Begin
    With ODOLine2 do
    If (SelectedItem>=0) then
    Begin
      ODDRec:=ODOLine2.Items[SelectedItem].Data;

      fpOSCode:=ODDRec^.NLKey;

      fpOSQty:=ODDRec^.NValue;

      fpSetQty:=ODDRec^.NOQty;

      fpSetCurr:=ODDRec^.NOCurr;

      Result:=BOn;
    end {With..}
    else
      Result:=BOff;
  end;


  Function TStkWarn.ReturnObjectMLoc  :  MLocRec;

  Var
    n,Tmpn    :  Integer;
    ODDRec    :  ^ODDType;

    KeyChk    :  Str255;


  Begin
    FillChar(Result,Sizeof(Result),#0);

    With ODOLine2 do
    If (SelectedItem>=0) then
    Begin
      ODDRec:=ODOLine2.Items[SelectedItem].Data;

      With ExLocal,ODDRec^ do
      Begin
        KeyChk:=NKey;

        Status:=Find_Rec(B_GetGEq,F[NFnum],NFnum,LRecPtr[NFnum]^,NKeyPath,KeyChk);

        If (StatusOk) then
          Result:=LMLocCtrl^;

      end; {With..}
    end {With..}
  end;

{$ENDIF}




  procedure TStkWarn.ODOLine2Expand(Sender: TObject; Index: Integer);

  Var
    ODDRec  :  ^ODDType;

  begin
    {$IFDEF SOP}
      ODDRec:=ODOLine2.Items[Index].Data;

      With ODOLine2 do
      If (Not Items[Index].HasItems) and (Assigned(ODDRec)) and (OpoLineHandle<>0) then
      With ODDRec^ do
      Begin
        If (Not Frozen) and (NMiscMode=OppoPageNo) then
          FreezeBtnClick(nil);

        PostMessage(OpoLineHandle,WM_CustGetRec,1100+NMiscMode,LongInt(Self));

        {MessageDlg(IntToStr(OpoLineHandle),mtInformation,[mbok],0);}
      end;
    {$ENDIF}
  end;




procedure TStkWarn.FreezeBtnClick(Sender: TObject);
begin
  {$IFDEF SOP}
    Frozen:=Not Frozen;

    If (Frozen) then
      FreezeBtn.Caption:='Un&freeze'
    else
      FreezeBtn.Caption:='&Freeze';
  {$ENDIF}
end;

procedure TStkWarn.ODOLine2Click(Sender: TObject);

Var
    ODDRec  :  ^ODDType;

begin
  {$IFDEF SOP}
  If (Not ObjectMode) then
  With ODOLine2 do
  begin
    If (SelectedItem>=0) then
    Begin
      ODDRec:=ODOLine2.Items[SelectedItem].Data;

      With ODOLine2 do
      If (Not Items[SelectedItem].HasItems) and (Assigned(ODDRec)) then
      begin
        With ODDRec^ do
        begin
          If (NMiscMode>AltPageNo) then
          Begin
            SendToObjectStkEnq(NLKey,fCustCode,fLocFilt,-1,-1,0);

            fNeedToRestore:=BOn;
          end;
        end; {With..}
        {SS 23/08/2016 2016-R3
        ABSEXCH-17075:Stock Equivalents - Negative Stock qty}
        ODOLine2Expand(ODOLine2,SelectedItem);
      end;

    end;
  end; {With ODOLine2 do}

  {$ENDIF}
end;

end.
