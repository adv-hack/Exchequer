unit ObjPrceU;

{$I DEFOVR.Inc}

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, TEditVal, Mask, ExtCtrls, SBSPanel,
  GlobVar,VarConst,ExWrap1U, ExBtTh1U,BTSupU1, Recon3U,CuStkA4U,
  SalTxl1U, pwarnu,

  //PR: 09/02/2012 ABSEXCH-9795
  QtyBreakVar

  {$IFDEF Rp}
    , Report6U;

  {$ELSE}
     ;

  {$ENDIF}


type
  TPriceThread = class(TThread)
  private
    fKeyChk  :  Str255;
    fCKAnal  :  CKAnalType;

    Display  :  TMemo;

    NewMLine :  String;

    ExLocal  :  TdPostExLocalPtr;

    {$IFDEF Rp}
      ShareRep    :  ^TStkReport;
    {$ENDIF}

    procedure ThreadDelay(dt  :  Word;
                          SAPM:  Boolean);


    procedure SyncResetDisplay;

    procedure ResetDisplay;

    procedure SetTotals;

    procedure OutTotals;

  protected
    BeingCreated1  :  Boolean;

    procedure Execute; override;

  public

    constructor Create(CKAnal  :  CKAnalType;
                       PMemo   :  TMemo);

    Destructor Destroy; override;

    procedure CleanUp;

    Function WaitforTerminate  :  Boolean;

  private

    ExecuteOff  :  Boolean;

    {$IFDEF Rp}
      //PR: 09/02/2012 Amended function to use new Qty Breaks file ABSEXCH-9795
      Function Find_QtyBreak(TStock,
                             PStock  :  StockRec;
                             TCust   :  CustRec;
                             TCurr   :  Byte;
                             Fnum,
                             Keypath :  Integer;
                             Mode    :  Byte;
                             QBFolio :  longint = 0)  :  Boolean;


      Function Find_AccDMatch(TStock,
                              PStock  :  StockRec;
                              TCust   :  CustRec;
                              TCurr   :  Byte;
                              Fnum,
                              Keypath :  Integer)  :  Boolean;

      Function Has_QtyBreak(TStock  :  StockRec;
                            TCust   :  CustRec)  :  Boolean;


    {$ENDIF}


    Procedure Price_Scan;

  end;


  TObjPrice = class(TForm)
    SBSPanel1: TSBSPanel;
    AccCodeLab: Label8;
    AccF: Text8Pt;
    CompF: Text8Pt;
    SBSPanel3: TSBSPanel;
    SBSPanel2: TSBSPanel;
    OkCP1Btn: TButton;
    FrzeBtn: TButton;
    PriceMemo: TMemo;
    Label81: Label8;
    STCF: Text8Pt;
    SDescF: Text8Pt;
    CurrF: TSBSComboBox;
    procedure FormCreate(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormDestroy(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure FormKeyPress(Sender: TObject; var Key: Char);
    procedure OkCP1BtnClick(Sender: TObject);
    procedure AccFExit(Sender: TObject);
    procedure CompFDblClick(Sender: TObject);
    procedure FrzeBtnClick(Sender: TObject);
    procedure AccFDblClick(Sender: TObject);
    procedure SDescFDblClick(Sender: TObject);
    procedure CurrFChange(Sender: TObject);
    procedure STCFExit(Sender: TObject);
  private
    { Private declarations }

    fFreeze,
    InReset     :  Boolean;
    LastLedgMode
                :  Byte;


    ShowPrices  :  TPriceThread;


    procedure SetCaption;

    Procedure Send_UpdateList(Edit   :  Boolean;
                              Mode   :  Integer);

    Procedure WMCustGetRec(Var Message  :  TMessage); Message WM_CustGetRec;

    Procedure OutPrice;

    procedure CalcTotals;

    procedure ResetTotals;

    procedure SetFreeze(F  :  Boolean);

  public
    { Public declarations }
    OPCKAnal   :  CKAnalType;

    ExLocal    :  TdExLocal;

    procedure SetUpAccount(CustR  :  Str10);

    Procedure InitObjectMode(EPCKAnal  :  CKAnalType);

    Property  Freeze  :  Boolean Read fFreeze Write SetFreeze;
  end;


{~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~}

Implementation

{~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~}


Uses
  ETStrU,
  ETDateU,
  ETMiscU,
  BtrvU2,
  VarRec2U,
  BtKeys1U,
  SBSComp2,
  BTSupU2,
  CurrncyU,
  DocSupU1,
  ComnUnit,
  ComnU2,
  InvCT2SU,

  {$IFDEF SOP}
    InvLst3U,
    MultiBuyFuncs,
    MultiBuyVar,
  {$ENDIF}
  
  InvListU;

{$R *.DFM}



{ TPriceThread }

constructor TPriceThread.Create(CKAnal  :  CKAnalType;
                                PMemo   :  TMemo);


begin
  BeingCreated1:=BOn;

  FreeOnTerminate := BOff;

  
  fCKAnal:=CKAnal;

  Display:=PMemo;

  ExecuteOff:=BOff;

  New(ExLocal,Create(50));

  try
    With ExLocal^ do
    Begin
      Open_System(CustF,MLocF);
      {$IFDEF SOP}
       Open_System(MultiBuyF, MultiBuyF);
      {$ENDIF}

      //PR: 09/02/2012 ABSEXCH-9795
      {$IFDEF STK}
       Open_System(QtyBreakF, QtyBreakF);
      {$ENDIF}
    end;

    {$IFDEF Rp}
       New(ShareRep,Create(Display.Owner));

       ShareRep^.MTExLocal:=ExLocal;

    {$ENDIF}

    inherited Create(True);

    Priority:=tpIdle;

    Resume;

  except
    ShowMessage('Unable to create Object Price thread.');

  end;


end;

Destructor TPriceThread.Destroy;

Begin

  Inherited Destroy;
end;


procedure TPriceThread.CleanUp;

Begin
  Dispose(ExLocal,Destroy);

  {$IFDEF Rp}

    Dispose(ShareRep,Destroy);

  {$ENDIF}

  {ExLocal.Destroy;}

end;


procedure TPriceThread.ThreadDelay(dt  :  Word;
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

Function TPriceThread.WaitforTerminate  :  Boolean;

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


procedure TPriceThread.SyncResetDisplay;
Var
  n  :  Byte;
begin

  Display.Clear;

end;

procedure TPriceThread.ResetDisplay;
begin
  Synchronize(SyncResetDisplay);
end;


procedure TPriceThread.SetTotals;
Var
  n  :  Byte;
begin

  Display.Lines.Add(NewMLine);

end;

procedure TPriceThread.OutTotals;
begin
  Synchronize(SetTotals);
end;



{ The Execute method is called when the thread starts }

procedure TPriceThread.Execute;
begin
  ExecuteOff:=BOff;

  try
    Price_Scan;
  finally
    ExecuteOff:=BOn;
  end;

end;


{$IFDEF Rp}

  { ======= Function to Match Qty Break with Account/Stock Combo ======== }
  //PR: 09/02/2012 Amended function to use new Qty Breaks file ABSEXCH-9795
  Function TPriceThread.Find_QtyBreak(TStock,
                                      PStock  :  StockRec;
                                      TCust   :  CustRec;
                                      TCurr   :  Byte;
                                      Fnum,
                                      Keypath :  Integer;
                                      Mode    :  Byte;
                                      QBFolio :  longint = 0)  :  Boolean;




  Var
    KeyS,
    KeyChk  :  Str255;
    NoStop,
    FoundOk :  Boolean;
    Rnum,
    DiscR   :  Real;
    DiscCh  :  Char;
    SNod    :  Byte;
    FormatStr
            :  Str255;
    dtToday : LongDate;

  Begin
    dtToday := FormatDateTime('yyyymmdd', SysUtils.Date);
    FoundOk:=BOff; DiscR:=0; DiscCh:=#0; Rnum:=0;

    If (IsACust(TCust.CustSupp)) then
    Begin
      SNoD:=Syss.NoNetDec;
      FormatStr:=GenUnitMask[BOn];
    end
    else
    Begin
      SNoD:=Syss.NoCosDec;
      FormatStr:=GenUnitMask[BOff];
    end;


    Case Mode of
      //PR: 09/02/2012 ABSEXCH-9795
      1  :  begin
              //PR: 09/07/2012 Add false parameter to QtyBreakStartKey call so that it keeps zeros and matches currency
              KeyChk := QtyBreakStartKey('', TStock.StockFolio, False) + Chr(TCurr);
              KeyPath := qbAcCodeIdx;
            end;

      2  :  begin
              KeyChk:=FullNomKey(QBFolio);
              KeyPath := qbFolioIdx;
            end;

    end; {Case..}

    NoStop:=Not Terminated;

    With ExLocal^ do
    Begin
      KeyS:=KeyChk;

      LStatus:=LFind_Rec(B_GetGEq,QtyBreakF,Keypath,KeyS);

      While (LStatusOk) and (CheckKey(KeyChk,KeyS,Length(KeyChk),BOn)) and (Not FoundOk)  and (NoStop) and (Not Terminated) do
      With LQtyBreakRec, fCKAnal  do
      Begin

        NoStop:=Not Terminated;

        //PR: 27/01/2009 - Was listing all QtyBreaks regardless of effective dates.
        //PR: 09/02/2012 Use new qty break record ABSEXCH-9795
        if (Not qbUseDates) or ((dtToday >= qbStartDate) and (dtToday <= qbEndDate)) then
        begin

          NewMLine:=Form_Real(qbQtyFrom,0,Syss.NoQtyDec)+#9+' - '+#9+Form_Real(qbQtyTo,0,Syss.NoQtyDec);


          {QBAnal[QBCount].QBRange:=Form_Real(FQB,0,Syss.NoQtyDec)+' - '+#9+Form_Real(TQB,0,Syss.NoQtyDec);}

          ShareRep^.Calc_UPriceDisc(PStock,LMiscRecs^,RCr,1,Rnum,DiscR,DiscCh,LocFilt,1, LQtyBreakRec);

          {QBAnal[QBCount].QBPrice:=Round_Up(Rnum-Calc_PAmount(Round_Up(Rnum,SNoD),DiscR,DiscCh),SNoD);}

          NewMLine:=NewMLine+#9+FormatCurFloat(FormatStr,Round_Up(Rnum-Calc_PAmount(Round_Up(Rnum,SNoD),DiscR,DiscCh),SNoD),BOff,RCr);

          OutTotals;

          Inc(QBCount);
        end;

        {FoundOk:=(QBCount>=High(QBAnal));}

        If (Not FoundOk) then
          LStatus:=LFind_Rec(B_GetNext,QtyBreakF,Keypath,KeyS);

      end; {While.}

      Find_QtyBreak:=(fCKAnal.QBCount>0);

    end; {Func..}
  end;

  { ========= Function to find Account Discount match ========== }

  Function TPriceThread.Find_AccDMatch(TStock,
                                       PStock  :  StockRec;
                                       TCust   :  CustRec;
                                       TCurr   :  Byte;
                                       Fnum,
                                       Keypath :  Integer)  :  Boolean;





  Var
  KeyChk    :  Str255;
  FoundOk   :  Boolean;

  DiscCh    :  Char;
  DiscR,
  Rnum      :  Real;


  Begin

//  KeyChk:=FullQDKey(CDDiscCode,TCust.CustSupp,MakeCDKey(TCust.CustCode,TStock.StockCode,TCurr));

  With ExLocal^ do
  Begin
//    FoundOk:=LCheckRecExsists(KeyChk,Fnum,Keypath);
    //PR: 27/01/2009 Wasn't taking account of date ranges. Changed to use function in ShareRep object (Report6U.TStkReport) to find the correct discount.
    FoundOK := ShareRep^.Calc_AccDMatch(TStock, TCust, TCurr, FormatDateTime('yyyymmdd', SysUtils.Date), FNum, KeyPath);

    If (FoundOk) then
    With fCKAnal do
    Begin
      If (LMiscRecs^.CustDiscRec.QBType=QBQtyBCode) then //PR: 09/02/2012 ABSEXCH-9795
        FoundOk:=Find_QtyBreak(TStock,PStock,TCust,TCurr,Fnum,Keypath,2, LMiscRecs^.CustDiscRec.QtyBreakFolio)
      else
      Begin

        NewMLine:=' Any Qty ->';

        ShareRep^.Calc_UPriceDisc(PStock,LMiscRecs^,RCr,1,Rnum,DiscR,DiscCh,LocFilt,2, LQtyBreakRec);

        {QBAnal[QBCount].QBPrice:=Round_Up(Rnum-Calc_PAmount(Round_Up(Rnum,Syss.NoNetDec),DiscR,DiscCh),Syss.NoNetDec);}

        NewMLine:=NewMLine+#9+FormatCurFloat(GenUnitMask[BOn],Round_Up(Rnum-Calc_PAmount(Round_Up(Rnum,Syss.NoNetDec),DiscR,DiscCh),Syss.NoNetDec),BOff,RCr);

        QBCount:=1;

        OutTotals;
      end;

    end;
  end; {With..}

  Find_AccDMatch:=FoundOk;
  end;



  Function TPriceThread.Has_QtyBreak(TStock  :  StockRec;
                                     TCust   :  CustRec)  :  Boolean;



  Const
    Fnum     =  MiscF;
    Keypath  =  MIK;


  Var
    Loop,
    TreeLoop,
    FoundOk   :  Boolean;

    PopCurr,
    LCurr     :  Byte;

    Rnum,
    DiscR     :  Real;
    DiscCh    :  Char;

    KeyS      :  Str255;


  Begin
    With ExLocal^,fCKAnal do
    Begin
      FoundOk:=BOff;

      TreeLoop:=BOn;

      PopCurr:=RCr;

      {If (IsTeleS) then
        RCr:=TeleSHed^.TeleSRec.TcCurr; }

      LCurr:=RCr;

      DiscR:=0;
      DiscCh:=#0;  Rnum:=0;

      Blank(QBAnal,Sizeof(QBAnal));

      QBCount:=0;

      {$IFDEF MC_On}

        Loop:=BOff;

      {$ELSE}

        Loop:=BOn;

        LCurr:=0;

      {$ENDIF}


      Repeat

          {* Search for an exact match *}

        FoundOk:=Find_AccDMatch(TStock,TStock,TCust,LCurr,Fnum,Keypath);

        If (Not FoundOk) then {* Search for a match via the tree *}
        Repeat

          TreeLoop:=ShareRep^.Get_DiscTree(LStock.StockCat);

          If (TreeLoop) then
          Begin

            FoundOk:=Find_AccDMatch(LStock,TStock,TCust,LCurr,Fnum,Keypath);

          end;

        Until (Not TreeLoop) or (FoundOk) or (Terminated);

        LCurr:=0;

        Loop:=Not Loop;  {* Repeat for Currecncy 0 *}


        LStock:=TStock;

      Until (FoundOk) or (Not Loop) or (Terminated);

      If (Not FoundOk) and (IsaCust(TCust.CustSupp)) and (Not Terminated) then {* Search for product QB match *}
      Begin

        LCurr:=RCr;


        {$IFDEF MC_On}

          Loop:=BOff;

        {$ELSE}

          Loop:=BOn;

        {$ENDIF}


        Repeat

          FoundOk:=Find_QtyBreak(TStock,TStock,TCust,LCurr,Fnum,Keypath,1);


          LCurr:=0;

          Loop:=Not Loop;

        Until (Not Loop) or (FoundOk) or (Terminated);

      end; {If Actual stock has qty break..}

      With TCust do
        If (Not FoundOk) then {* Use account defaults *}
        Begin
          NewMLine:=' Any Qty ->';

          {QBAnal[QBCount].QBRange:=' Any Qty ->';}

          If (IsACust(CustSupp)) then
          Begin
            If ((Discount<>0) or (CDiscCh<>#0)) then
            Begin
              DiscR:=Discount;
              DiscCh:=CDiscCh;
            end;

            Rnum:=Get_StkPrice(TStock.SaleBands,DiscR,DiscCh,RCr,1,1,TStock.CalcPack);

            NewMLine:=NewMLine+#9+FormatCurFloat(GenUnitMask[BOn],Round_Up(Rnum-Calc_PAmount(Round_Up(Rnum,Syss.NoNetDec),DiscR,DiscCh),Syss.NoNetDec),BOff,RCr);

            {QBAnal[QBCount].QBPrice:=Round_Up(Rnum-Calc_PAmount(Round_Up(Rnum,Syss.NoNetDec),DiscR,DiscCh),
                                              Syss.NoNetDec);}



          end
          else
          Begin
            {$IFDEF SOP}

              ExLocal^.LStock_LocROCPSubst(TStock,LocFilt);

            {$ENDIF}

            {QBAnal[QBCount].QBPrice:=Round_Up(Currency_ConvFT(TStock.ROCPrice,TStock.ROCurrency,RCr,UseCoDayRate),
                                              Syss.NoCosDec);}
            //HV and R Jha 06/01/2016, JIRA-14736, 'Misc - Show GP% on Screen' unchecked in the password that cost should not be shown on a stock record or transaction in "object price lookup screen"
            if PChkAllowed_In(143) then
              NewMLine:=NewMLine+#9+FormatCurFloat(GenUnitMask[BOff],Round_Up(Currency_ConvFT(TStock.ROCPrice,TStock.ROCurrency,RCr,UseCoDayRate),Syss.NoCosDec),BOff,RCr)
            else
              NewMLine:=NewMLine+#9+FormatCurFloat(GenUnitMask[BOff],Round_Up(Currency_ConvFT(0.00,TStock.ROCurrency,RCr,UseCoDayRate),Syss.NoCosDec),BOff,RCr);

          end;

          OutTotals;
          QBCount:=1;
        end;

      If (IsTeleS) then
        RCr:=PopCurr;

    end; {With..}


    Has_QtyBreak:=FoundOk;

  end; {Func..}

{$ENDIF}


Procedure TPriceThread.Price_Scan;


Const
  Fnum     =  MiscF;
  Keypath  =  MIK;


Var

  KeyChk,
  KeyS        :  Str255;

  n,m         :  Byte;

  LFilt       :  Str10;

  {$IFDEF SOP}
   MBList : TStringList;
   i : Integer;
  {$ENDIF}
Begin
  With ExLocal^,fCKAnal do
  Begin
    If (LCust.CustCode<>CCode) then
      LGetMainRec(CustF,CCode);

    If (LStock.StockCode<>SCode) then
      LGetMainRec(StockF,SCode);

    If (EmptyKey(LocFilt,MLocKeyLen)) then
      LFilt:=LStock.DefMLoc
    else
      LFilt:=LocFilt;

    {$IFDEF SOP}
      Stock_LocPSubst(LStock,LFilt);
    {$ENDIF}

    {ResetDisplay;}

    If (IsACust(LCust.CustSupp)) then {* Give normal bands first *}
    Begin

      NewMLine:='Normal Band Pricing:-';

      If (Not EmptyKey(LFilt,MLocKeyLen)) then
        NewMLine:='Loc '+LFilt+'. '+NewMLine;


      OutTotals;

      m:=1;

      For n:=1 to Round(NofSBands/2) do
      With LStock,SaleBands[n] do
      If (SaleBands[m].SalesPrice<>0.0) or (SaleBands[m+1].SalesPrice<>0.0) then
      Begin
        NewMLine:=Chr(64+m);

        With SaleBands[m] do
          If (SalesPrice<>0.0) then
            NewMLine:=NewMLine+#9+FormatCurFloat(GenUnitMask[BOn],Round_Up(Currency_ConvFT(SalesPrice,Currency,RCr,UseCoDayRate),Syss.NoNetDec),BOff,RCr)
          else
            NewMLine:=NewMLine+#9+'Not Used';


        NewMLine:=NewMLine+#9+Chr(64+m+1);

        With SaleBands[m+1] do
          If (SalesPrice<>0.0) then
            NewMLine:=NewMLine+#9+FormatCurFloat(GenUnitMask[BOn],Round_Up(Currency_ConvFT(SalesPrice,Currency,RCr,UseCoDayRate),Syss.NoNetDec),BOff,RCr)
          else
            NewMLine:=NewMLine+#9+'Not Used';

        OutTotals;

        m:=m+2;
      end;
    end; {If Customer }

    NewMLine:='';

    OutTotals;

    NewMLine:='Pricing for';

    {$IFDEF MC_On}
      NewMLine:=NewMLine+' '+CurrDesc(RCr);
    {$ENDIF}

    If (Not EmptyKey(LFilt,MLocKeyLen)) then
      NewMLine:='Loc '+LFilt+'. '+NewMLine;

    NewMLine:=NewMLine+' :-'+#13+#10;


    OutTotals;

    BeingCreated1:=BOff;

    {$IFDEF Rp}
       Has_QtyBreak(LStock,LCust);

    {$ENDIF}

    {$IFDEF SOP}
     with TMultiBuyFunctions.Create do
     Try
       //PR: 15/07/2009 Added currency to list
       MBList := GetMultiBuyList(LCust.CustCode, LStock.StockCode, Today, ExLocal, RCr);
       if Assigned(MBList) and (MBList.Count > 0) then
       begin
         NewMLine := '';
         OutTotals;
         NewMLine := 'Multi-Buy Discounts:-';
         OutTotals;
         NewMLine := '';
         OutTotals;
         for i := 0 to MBList.Count - 1 do
         begin
           NewMLine := MBList[i];
           OutTotals;
         end;
       end;
     Finally
       if Assigned(MBList) then
         FreeMultiBuyList(MBList);
       Free; {TMultiBuyFunctions.Free}
     End;
    {$ENDIF}



  end; {With..}
end; {Proc..}




{ ======================================================================================= }






procedure TObjPrice.SetCaption;

Begin
  With ExLocal,LCust do
  Begin
    Caption:='ObjectPrice for '+dbFormatName(CustCode,Company);

  end;

end;




procedure TObjPrice.FormCreate(Sender: TObject);


begin

  ExLocal.Create;

  ClientHeight:=234;
  ClientWidth:=337;

  MDI_SetFormCoord(TForm(Self));

  // Allow room for two scroll bars (the second being the scrollbar for the
  // dropdown Currency list, which will extend beyond the right edge of this
  // form).
  Left := Application.MainForm.ClientWidth - (Width + (GetSystemMetrics(SM_CXHTHUMB) * 2) + 4);

  ShowPrices:=nil;

  InReset:=BOn;
  fFreeze:=BOff;

  FillChar(OPCKAnal,Sizeof(OPCKAnal),0);

  LastLedgMode:=0;

  {$IFDEF MC_On}

    Set_DefaultCurr(CurrF.Items,BOn,BOff);
    Set_DefaultCurr(CurrF.ItemsL,BOn,BOn);
    CurrF.ItemIndex:=0;

  {$ELSE}

   CurrF.Visible:=BOff;

  {$ENDIF}

  InReset:=BOff;

  LastValueObj.GetAllLastValuesFull(Self);

end;


procedure TObjPrice.FormCloseQuery(Sender: TObject;
  var CanClose: Boolean);
begin
  If (CanClose) then
    Send_UpdateList(BOff,217);

end;

procedure TObjPrice.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Action:=caFree;

  If Assigned(ShowPrices) then
  With ShowPrices do
  Begin
    try
      Terminate;
      WaitForTerminate;

      If (Not ExecuteOff) then
        Suspend;

      CleanUp;
      Free;
    except;
      ShowPrices.CleanUp;
      ShowPrices.Free;
    end;
  end;


end;

procedure TObjPrice.FormDestroy(Sender: TObject);
begin
  ExLocal.Destroy;

end;

procedure TObjPrice.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  GlobFormKeyDown(Sender,Key,Shift,ActiveControl,Handle);
end;

procedure TObjPrice.FormKeyPress(Sender: TObject; var Key: Char);
begin
  GlobFormKeyPress(Sender,Key,ActiveControl,Handle);
end;


Procedure TObjPrice.WMCustGetRec(Var Message  :  TMessage);



Begin


  With Message do
  Begin

    {If (Debug) then
      DebugForm.Add('Mesage Flg'+IntToStr(WParam));}

    Case WParam of

      18  :  Begin

             end;

    end; {Case..}

  end;
  Inherited;
end;



{ == Procedure to Send Message to Get Record == }

Procedure TObjPrice.Send_UpdateList(Edit   :  Boolean;
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
    MessResult:=SendMEssage((Owner as TForm).Handle,Msg,WParam,LParam);

end; {Proc..}


{ ============== Display Credit Control Record ============ }

Procedure TObjPrice.OutPrice;


Begin

  With ExLocal,LCust,LStock do
  Begin

    AcCF.Text:=Strip('B',[#32],CustCode);

    CompF.Text:=Strip('R',[#32],Company);

    STCF.Text:=Strip('B',[#32],StockCode);

    SDescF.Text:=Strip('R',[#32],Desc[1]);

    CurrF.ItemIndex:=OPCKAnal.RCr;

  end; {with..}



end; {Proc..}


procedure TObjPrice.OkCP1BtnClick(Sender: TObject);
begin
  LastValueObj.UpdateAllLastValues(Self);

  Close;
end;

procedure TObjPrice.AccFExit(Sender: TObject);
Var
  FoundCode  :  Str20;

  FoundOk,
  AltMod     :  Boolean;


begin
  Inherited;

  If (Sender is Text8pt) then
  With (Sender as Text8pt) do
  Begin
    AltMod:=Modified;

    FoundCode:=Strip('B',[#32],Text);

    If ((AltMod) or (FoundCode='')) and (ActiveControl<>OKCP1Btn)  then
    Begin
      Freeze:=BOff;

      StillEdit:=BOn;

      FoundOk:=(GetCust(Self,FoundCode,FoundCode,BOn,99));


      If (FoundOk) then
      Begin

        StillEdit:=BOff;

        Text:=FoundCode;

        ExLocal.AssignFromGlobal(CustF);

        SetUpAccount(FoundCode);
      end
      else
      Begin

        SetFocus;
      end; {If not found..}
    end;

  end; {with..}
end;


procedure TObjPrice.SetUpAccount(CustR  :  Str10);

Begin
  { Stop any threads here }

  If (ExLocal.LCust.CustCode<>CustR) then
    ExLocal.LGetMainRecPos(CustF,CustR);

  OPCKAnal.CCode:=CustR;

  {ExLocal.LCust:=CustR;}

  SetCaption;

  OutPrice;

  If (Not InReset) then
    ResetTotals;

end;


procedure TObjPrice.CalcTotals;


Begin

  With ExLocal do
  If (ShowPrices=nil) and (LCust.CustCode<>'') and (LStock.StockCode<>'') then
    ShowPrices:=TPriceThread.Create(OPCkAnal,PriceMemo);

end;



procedure TObjPrice.ResetTotals;

Var
  n  :  Integer;

Begin
  InReset:=BOn;

  PriceMemo.Clear;

  If (ShowPrices<>nil) then
  With ShowPrices do
  Begin
    If (Not BeingCreated1) then
    Begin

      Terminate;

      If (WaitForTerminate) then
      Begin
        If (Not ShowPrices.ExecuteOff) then
          ShowPrices.Suspend;

        ShowPrices.CleanUp;
        ShowPrices.Free;
        ShowPrices:=nil;
        CalcTotals;
      end
      else
        If (Debug) then
          ShowMessage('Aging Thread Not aborted correctly in ObjectPrice')
        else
          MessageBeep(0);
    end; {We have not really started yet, so cannot terminate}
  end
  else
    CalcTotals;

  InReset:=BOff;

end;




procedure TObjPrice.AccFDblClick(Sender: TObject);
begin
  {If (Not EmptyKey(AccF.Text,CustKeyLen)) and (ExLocal.LCust.CustCode=AccF.Text) then
    Link2Ledger(-9);}
end;

procedure TObjPrice.CompFDblClick(Sender: TObject);
begin
  AccF.DblClick;
end;

procedure TObjPrice.SDescFDblClick(Sender: TObject);
begin
  STCF.DblClick;
end;




procedure TObjPrice.SetFreeze(F  :  Boolean);

Begin
  If (F<>fFreeze) then
  Begin
    fFreeze:=F;

    If F then
      FrzeBtn.Caption:='Un&freeze'
    else
      FrzeBtn.Caption:='&Freeze';
  end;
end;
procedure TObjPrice.FrzeBtnClick(Sender: TObject);
begin
  Freeze:=Not Freeze;
end;


Procedure TObjPrice.InitObjectMode(EPCKAnal  :  CKAnalType);

Begin
  OPCKAnal:=EPCKAnal;

  With OPCKAnal do
  Begin

    If (ExLocal.LCust.CustCode<>CCode) then
      ExLocal.LGetMainRecPos(CustF,CCode);

    If (ExLocal.LStock.StockCode<>SCode) then
      ExLocal.LGetMainRecPos(StockF,SCode);

    SetCaption;

    OutPrice;

    If (Not InReset) then
      ResetTotals;


  end; {With..}
end;



procedure TObjPrice.CurrFChange(Sender: TObject);
begin
  Freeze:=BOff;

  If (Not InReset) then
  Begin
    OPCKAnal.RCr:=CurrF.ItemIndex;

    ResetTotals;
  end;
end;

procedure TObjPrice.STCFExit(Sender: TObject);
Var
  FoundCode  :  Str20;

  FoundOk,
  AltMod     :  Boolean;


begin
  Inherited;

  If (Sender is Text8pt) then
  With (Sender as Text8pt) do
  Begin
    AltMod:=Modified;

    FoundCode:=Strip('B',[#32],Text);

    If ((AltMod) or (FoundCode='')) and (ActiveControl<>OKCP1Btn)  then
    Begin
      Freeze:=BOff;

      StillEdit:=BOn;

      FoundOk:=(GetStock(Self,FoundCode,FoundCode,3));


      If (FoundOk) then
      Begin

        StillEdit:=BOff;

        Text:=FoundCode;

        ExLocal.AssignFromGlobal(StockF);

        OPCKAnal.SCode:=FoundCode;

        InitObjectMode(OPCKAnal);
      end
      else
      Begin

        SetFocus;
      end; {If not found..}
    end;

  end; {with..}
end;



end.
