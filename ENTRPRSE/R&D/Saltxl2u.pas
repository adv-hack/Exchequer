unit Saltxl2u;


{$I DEFOVR.INC}

interface

uses
  SysUtils, Windows, Messages, Classes, Graphics, Controls,
  Dialogs, StdCtrls, ExtCtrls,Forms,TEditVal,
  Globvar,VarConst,

  {$IFDEF STK}
    StockU,
    CuStkA4U,
  {$ENDIF}

  BTSupU1, Menus;

type
  TFSTKDisplay = class(TForm)
    PopupMenu2: TPopupMenu;
    Clsdb1Btn: TButton;
    Timer1: TTimer;
    PopupMenu1: TPopupMenu;
    MenuItem1: TMenuItem;
    MenuItem2: TMenuItem;
    MenuItem3: TMenuItem;
    MenuItem4: TMenuItem;
    AsQuotation1: TMenuItem;
    Order1: TMenuItem;
    Proforma1: TMenuItem;
    DeliveryNote1: TMenuItem;
    Cancel1: TMenuItem;
    PopupMenu3: TPopupMenu;
    MenuItem5: TMenuItem;
    MenuItem6: TMenuItem;
    MenuItem7: TMenuItem;
    MenuItem9: TMenuItem;
    PopupMenu4: TPopupMenu;
    MenuItem8: TMenuItem;
    MenuItem10: TMenuItem;
    MenuItem11: TMenuItem;
    MenuItem12: TMenuItem;
    PopupMenu5: TPopupMenu;
    MenuItem13: TMenuItem;
    MenuItem14: TMenuItem;
    MenuItem16: TMenuItem;
    PopupMenu6: TPopupMenu;
    MenuItem15: TMenuItem;
    MenuItem17: TMenuItem;
    MenuItem19: TMenuItem;
    PStkL: TMenuItem;
    PStkL2: TMenuItem;
    PStkL3: TMenuItem;
    PopupMenu7: TPopupMenu;
    MenuItem18: TMenuItem;
    MenuItem20: TMenuItem;
    MenuItem24: TMenuItem;
    BinAvail1: TMenuItem;
    PopupMenu8: TPopupMenu;
    MenuItem21: TMenuItem;
    MenuItem22: TMenuItem;
    MenuItem23: TMenuItem;
    popOrderPaymentsSRC: TPopupMenu;
    MenuItem25: TMenuItem;
    MenuItem26: TMenuItem;
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure FormCreate(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure Acc1Click(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
    procedure Cancel1Click(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
  private
    { Private declarations }

    Procedure Send_UpdateMain(Edit   :  Boolean;
                              Mode   :  Integer);

    procedure ShowMenu;

  public
    { Public declarations }

    PopPoint   :  TPoint;

    MenuChoice,
    MenuMode   :  Byte;

    TInv       :  InvRec;
    TId        :  IDetail;
    TCust      :  CustRec;

    TSerFind,
    InSerMode,
    InBinMode,
    TBinFind,
    StkActive  :  Boolean;

    {$IFDEF STK}


      StkRecForm :  TStockRec;

      CuStkCtrlRec
                 :  CKAnalType;

    {$ENDIF}

    DDPr,DDYr,
    CallBackBias,

    TSerRetMode,

    TSerFindMode :  Byte;
    TChosenQty,
    TSerialReq,
    TDocCostP    :  Double;

    TSerMainK    :  Str255;

    //PR: 08/02/2012 ABSECH-9795
    CDiscountRec : CustDiscType;

    procedure Display_Account(Mode    :  Byte);

    Procedure Send_UpdateList(Edit   :  Boolean;
                              Mode   :  Integer);


    Procedure WMCustGetRec(Var Message  :  TMessage); Message WM_CustGetRec;


  end;



{ ----------------------}

{$IFDEF STK}

  Procedure Control_SNos(Var Idr  :  IDetail;
                             InvR :  InvRec;
                            StockR
                                  :  StockRec;
                             Mode :  Byte;
                             Sender
                                  :  TObject);


  Procedure Control_BINS(Var Idr  :  IDetail;
                             InvR :  InvRec;
                             StockR
                                  :  StockRec;
                             Mode :  Byte;
                             Sender
                                  :  TObject);

  {$IFDEF PF_On}
      //PR: 08/02/2012 Add parameter to pass through folio number for qty breaks ABSECH-9795
      Procedure Control_CQtyB(CustR   :  CustRec;
                              SCode   :  Str20;
                              Sender  :  TObject;
                              CustomerDiscountRec : CustDiscType);

      {$IFDEF SOP}
        Procedure Control_FindSer(Sender  :  TObject;
                                  SCode   :  Str255;
                                  SMode   :  Byte);
      {$ENDIF}


      Procedure Control_FindBin(Sender  :  TObject;
                                SCode   :  Str255;
                                SMode   :  Byte);

  {$ENDIF}


{$ENDIF}

Var
  SerStkRec,
  BinStkRec  :  TFSTKDisplay;


{~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~}

Implementation

{~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~}

Uses
  StockProc, // NF:
  {$IFDEF CU}
    CustWinU, {NF}
    CustIntU, {NF}
    Event1U,  {EL}
  {$ENDIF}
  ETStrU,
  EtMiscU,
  SBSPanel,
  VarRec2U,
  BtrvU2,
  BtKeys1U,
  ComnUnit,
  ComnU2,
  CurrncyU,
  InvFSu2U,
  BTSupU2,
  SysU2,
  InvListU;


{$R *.DFM}





procedure TFSTKDisplay.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  If (TSerFind) then
    Send_UpdateList(BOff,19);
end;


procedure TFSTKDisplay.FormCloseQuery(Sender: TObject;
  var CanClose: Boolean);
begin
  If (Not StkActive) or (Not InSerMode) or (TSerFind) then
  Begin
    GenCanClose(Self,Sender,CanClose,BOn);

    If (CanClose) and (TSerFind) then
      Send_UpDateList(BOff,19);

    
  end
  else
  Begin
    {$IFDEF STK}
      CanClose:=BOff;

      If (StkActive) and (InSerMode) and (Not TSerFind) then
      Begin
        StkRecForm.Show;
        ShowMessage('Please complete the Serial Number allocation.');
      end
      else
        If (StkActive) and (InBinMode) and (Not TBinFind) then
        Begin
          StkRecForm.Show;
          ShowMessage('Please complete the Bin code allocation.');
        end
    {$ENDIF}
  end;
end;


procedure TFSTKDisplay.FormCreate(Sender: TObject);
begin
  InSerMode:=BOff;
  InBinMode:=BOff;

  StkActive:=BOff;

  {$IFDEF STK}
    StkRecForm:=nil;
    Blank(CuStkCtrlRec,SizeOf(CuStkCtrlRec));

    {$IFDEF LTE}
      BinAvail1.Visible:=BOff;

    {$ENDIF}

  {$ELSE}
    PStkL.Visible:=BOff;
    PStkL2.Visible:=BOff;
    PStkL3.Visible:=BOff;
  {$ENDIF}


  TSerMainK:='';
  TSerFind:=BOff;

  TBinFind:=BOff;

  TSerFindMode:=0;

  TSerRetMode:=0;

  CallBackBias:=0;
  TChosenQty:=0.0;

  DDPr:=0; DDYr:=0;

  With PopPoint do
  Begin
    X:=1; Y:=1;
  end;

end;

{ == Procedure to Send Message to Get Record == }

Procedure TFSTKDisplay.Send_UpdateList(Edit   :  Boolean;
                                        Mode   :  Integer);

Var
  Message1 :  TMessage;
  MessResult
           :  LongInt;

Begin
  FillChar(Message1,Sizeof(Message1),0);

  With Message1 do
  Begin
    MSg:=WM_CustGetRec;
    WParam:=Mode;
    LParam:=Ord(Edit);
  end;

  If (Owner is TForm) then
    With Message1 do
      MessResult:=SendMEssage((Owner as TForm).Handle,Msg,WParam,LParam);

end; {Proc..}


{ == Procedure to Send Message to EparentU == }

Procedure TFSTKDisplay.Send_UpdateMain(Edit   :  Boolean;
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



Procedure TFSTKDisplay.WMCustGetRec(Var Message  :  TMessage);
Begin


  With Message do
  Begin


    Case WParam of

         1  :  ;

       200,
       201  :  Begin


                 {$IFDEF STK}
                   If (StkActive) then
                   Begin
                     If (TSerialReq<0) then {Its a use basis}
                       TChosenQty:=Round_up(StkRecForm.SerialReq-TSerialReq,Syss.NoQtyDec)
                     else {Its an add serial no basis}
                       TChosenQty:=Round_up(TSerialReq-StkRecForm.SerialReq,Syss.NoQtyDec);

                     TSerialReq:=StkRecForm.SerialReq;
                     TDocCostP:=StkRecForm.DocCostP;


                     StkRecForm:=nil;
                   end;
                 {$ENDIF}

                 StkActive:=BOff;

                 If (Owner=Application.MainForm) then
                   Send_UpDateMain(BOff,21)
                 else
                   Send_UpDateList(BOff,18+CallBackBias);
               end;


    end; {Case..}

  end;
  Inherited;
end;




procedure TFSTKDisplay.Display_Account(Mode    :  Byte);

Var
  NomNHCtrl  :  TNHCtrlRec;
  WasNew     :  Boolean;
  FKey       :  Str255;


Begin
  WasNew:=BOff;


  {$IFDEF STK}
    FillChar(NomNHCtrl,Sizeof(NomNHCtrl),0);

    If (Mode In [20,41..86]) then {* Its a drill down with filters *}
    With NomNHCtrl,CuStkCtrlRec do
    Begin
      If (Mode=20) then
      Begin
        NHFilterMode:=11;

        NHPr:=DDPr;

        NHYr:=DDYr;

        NHNomCode:=SFolio;

        NHNeedGExt:=BOn;

      end
      else
        NHFilterMode:=Mode-40;

      NHCr:=RCr;
      NHTxCr:=RTxCr;

      NHCuCode:=CCode;
      NHCuIsaC:=IsaC;
      NHLocCode:=LocFilt;
      NHCDCode:=RCCDep[IsCCDep];
      NHCCMode:=IsCCDep;
      Mode:=0;
    end;

    If (StkRecForm=nil) then
    Begin

      WasNew:=BOn;

      If (Mode In [5,6]) then
      Begin
        NomNHCtrl.NHMode:=Mode;
        InSerMode:=(Mode=5);
        InBinMode:=(Mode=6);
        NomNHCtrl.NHNeedGExt:=TSerFind or TBinFind;

       {Set up location filter}

//       If (Syss.FiltSNoBinLoc) and (Mode In [5,6]) then
       If FilterSerialBinByLocation(Syss.FiltSNoBinLoc, TInv.InvDocHed in SalesSplit // NF:
       , ChemilinesStockLocHookEnabled)
       then NomNHCtrl.NHLocCode:=TId.MLocStk;

      end
      else
        If (Mode=16) then
          NomNHCtrl.NHMode:=16;



      Set_DDFormMode(NomNHCtrl);

      StkRecForm:=TStockRec.Create(Self);


    end;

    Try

     StkActive:=BOn;

     With StkRecForm do
     Begin
       //TW 14/11/2011: Added Postmessage set focus call to fix use button not working
       PostMessage(StkRecForm.ActiveControl.Handle, WM_SETFOCUS, 0, 0);
       WindowState:=wsNormal;

       If (WasNew) then
       With ExLocal do
       Begin
         If (Self.Owner Is TForm) then
         Begin
           If (TForm(Self.Owner).Name='CMPSerCtrl') then
           Begin
             FormStyle:=fsNormal;
             InSerModal:=BOn;
           end;
         end;

         Case Mode of
           5,6
              :  Begin
                   LInv:=TInv;
                   LId:=TId;
                   SerialReq:=TSerialReq;
                   DocCostP:=TDocCostP;
                   InSerFind:=TSerFind;
                   InBinFind:=TBinFind;
                   SerMainK:=TSerMainK;
                   SerFindMode:=TSerFindMode;

                   SerRetMode:=TSerRetMode;

                   OutSerialReq;


                 end;
          16  :  begin
                   LCust:=TCust;

                   //PR: 08/02/2012 ABSECH-9795
                   CustDiscountRec := CDiscountRec;
                 end;
         end; {Case..}

       end
       else
       Case Mode of
           5
              :  If (InSerFind) then
                 Begin
                   SerMainK:=TSerMainK;
                   SerFindMode:=TSerFindMode;
                 end;
           6
              :  If (InBinFind) then
                 Begin
                   SerMainK:=TSerMainK;
                   SerFindMode:=TSerFindMode;
                 end;

       end; {Case..}

       SetTabs;

       If (Mode In [1..9,16,17]) then
         Show;


       If (Not ExLocal.InAddEdit) then
       Begin
         {* Re-establish file position *}

         FKey:=FullStockCode(Stock.StockCode);

         ExLocal.LGetMainRecPos(StockF,FKey);

         {$B-}
         If (Not WasNew) and (CheckLedgerFiltStatus) then
           Set_DDFormMode(NomNHCtrl);

         {$B+}

         ShowLink;


         With ExLocal do
           If (Mode=6) and (Not Emptykey(LStock.BinLoc,BinKeyLen)) and (CheckKey(Trim(LStock.DefMLoc),LId.MLocStk,Length(Trim(LStock.DefMLoc)),BOff))  
            and ((LId.IdDocHed In PurchSplit-PurchCreditSet+StkAdjSplit) or ((LId.IdDocHed In WOPSplit) and (LId.LineNo=1)))
            and ((EmptyKey(LId.JobCode,JobKeyLen)) or (Not (LId.IdDocHed In PurchSplit)))
             then
           With LStock do
           Begin
             FKey:=FullQDKey(brRecCode,MSernSub,FullBinCode3(StockFolio,TId.MLocStk,BinLoc));

             Status:=Find_Rec(B_GetEq,F[MLocF],MLocF,LRecPtr[MLocF]^,MLSuppK,FKey);

             With LMLocCtrl^.brBinRec do
               If (StatusOk) and (SerialReq>0) and ((brBuyQty-brQtyUsed+SerialReq<=brBinCap) or (brBinCap=0.0)) then {Offer to edit this one}
               Begin
                 stkStopAutoLoc:=BOn;

                 If  (Check_B2BStatus(LId,LInv,LMLocCtrl^)) then {For b2b we must have an identifiable indoc ref or it will not deduct it properly when the SOR is picked}
                 Begin
                   AssignToGlobal(MLocF);
                   Display_BinRec(2);

                   If (Assigned(BinRec)) then {Auto inflate the primary location qty by the qty required }
                   With BinRec do
                   Begin
                     UQF.Value:=SerialReq;

                     If (UQF.CanFocus) then
                       UQF.SetFocus;
                   end;
                 end; {If not B2B..}
               end;
           end;

         If (NomNHCtrl.NHFilteRMode<>0) and (WasNew) then
           ChangePage(StockU.SLedgerPNo)
       end;


     end; {With..}


    except

     StkActive:=BOff;

     StkRecForm.Free;

    end;



  {$ENDIF}
end;

procedure TFSTKDisplay.Timer1Timer(Sender: TObject);
begin
  If (Application.Hint='') then
    PostMessage(Self.Handle,WM_Close,0,0);
end;


procedure TFSTKDisplay.ShowMenu;

Var
  SubMenu  :  TPopUpMenu;

Begin
  Case MenuMode of

    1  :  SubMenu:=PopUpMenu1;
    2  :  SubMenu:=PopUpMenu2;
    3  :  SubMenu:=PopUpMenu3;
    4  :  SubMenu:=PopUpMenu4;
    5  :  SubMenu:=PopUpMenu5;
    6  :  SubMenu:=PopUpMenu6;
    7  :  SubMenu:=PopUpMenu7;

    8  :  SubMenu:=PopUpMenu8;

    // MH 15/09/2014: Extended for Order Payment Payment/Refund transactions
    9  :  SubMenu := popOrderPaymentsSRC;
    else
      SubMenu := PopUpMenu1; //PR: 22/03/2016 v2016 R2 ABSEXCH-17390 Avoid warning message
  end; {Case..}

  Timer1.Enabled:=BOn;

  With SubMenu do
  Begin
    If (Assigned(Items[0])) then
      Application.Hint:=Items[0].Hint;

    With PopPoint do
      PopUp(X,Y);
  end;
end;

procedure TFSTKDisplay.FormActivate(Sender: TObject);
begin
  If (MenuMode<>0) then
    ShowMenu;
end;


procedure TFSTKDisplay.Acc1Click(Sender: TObject);
begin
  If (Sender is TMenuItem) then
    With TMenuItem(Sender) do
    Begin
      Timer1.Enabled:=BOff;
      MenuChoice:=Tag;
      ModalResult:=mrOk;
    end;
end;

procedure TFSTKDisplay.Cancel1Click(Sender: TObject);
begin
  Timer1.Enabled:=BOff;
  MenuChoice:=0;
  ModalResult:=mrCancel;
end;


{-----------------------}


{$IFDEF STK}
  { ============ Procedure to Control Serial Nos =========== }

  {Modes : 1 = Normal operation
           3 = Deletion of line, hence reverse effect
          23 = Deletion of Return effect on SerialQty
          33 = Deletion of Return    "   "  SerialRetQty
          25 = When Sales Return stock being booked in...
          26 = When Sales Return stock being issued out }



  Procedure Control_SNos(Var Idr  :  IDetail;
                             InvR :  InvRec;
                             StockR
                                  :  StockRec;
                             Mode :  Byte;
                             Sender
                                  :  TObject);

  Var
    OrigIdx,
    Idx,
    Rnum,
    RQtySer,
    DiscP,
    OrigCPrice,
    QtyChosen


         :  Real;

    SerDT:  DocTypes;

    StkRec
         :  TFSTKDisplay;

    FoundCode
         :  Str20;

    {$IFDEF CU}
      function SpecialHookPointEnabled : boolean; {NF}
      {var
        CustomEvent  :  TCustomEvent;}
      begin{SpecialHookPointEnabled}
        Result := FALSE;

        // PDN and Quantity has not changed, Location has
        if ((InvR.InvDocHed = PDN) and (Idr.Qty = Id.Qty) and (Idr.MLocStk <> Id.MLocStk)) then
        begin
          // Creates object to do this customisation event

          Result:= EnableCustBtns(4000, 89);

          {CustomEvent := TCustomEvent.Create(wiTransine, 89); {EL: This code not necessary as routine exists already to provide same service 

          try
            // Has the event been enabled by any plug-ins ?
            Result := CustomEvent.GotEvent;
          finally
            // Clear up
            CustomEvent.Free;
          end;{try}
        end;{if}
      end;{SpecialHookPointEnabled}
    {$ENDIF}

  Begin

    Idx:=0; OrigIdx:=0.0;

    Rnum:=0;

    DiscP:=0;

    RQtySer:=0;

    SerDT:=Idr.IdDocHed;

    OrigCPrice:=0.0; QtyChosen:=0.0;


    With Idr do
    Begin
      If (StockR.StockCode<>StockCode) then
      Begin
        GetStock(TWinControl(Sender),StockCode,FoundCode,-1);
        StockR:=Stock;
      end;

      If (Is_FullStkCode(StockCode)) and (Is_SERNo(StockR.StkValType)) and (Not (SerDT In QuotesSet)) then
      With StockR do
      Begin
        OrigCPrice:=CostPrice;


        If (SerDT In OrderSet) then
        Begin

          If (SerDT In [SOR,SQU]) then
            SerDT:=SDN
          else
            SerDT:=PDN;

        end;

        Case Mode of


          3  :  Begin
                  Idx:=SerialQty*StkAdjCnst[SerDT]*DocNotCnst;
                end;

          23  :  Begin
                   Idx:=(SerialQty-SerialRetQty)*StkAdjCnst[SerDT]*DocNotCnst;
                 end;
          33 :  Begin
                  Idx:=SerialRetQty*StkAdjCnst[SerDT]*DocNotCnst;
                end;

          else  Begin

                  If (IdDocHed In OrderSet) and (LineNo<>StkLineNo) then {* Act on Picked Qty *}
                    RQtySer:=QtyPick+QtyDel
                  else
                    If (IdDocHed In WOPSplit) then
                    Begin
                      If (LineNo<>1) then
                        RQtySer:=QtyPick+QtyDel
                      else
                        RQtySer:=QtyPick+QtyWOff; {Include built}
                    end
                    else
                      If (IdDocHed In StkRetSplit) then
                      Begin
                        Case IdDocHed of
                          PRN  :  Case Mode of
                                    26  :  RQtySer:=QtyDel+QtyPWoff;

                                    else  RQtySer:={QtyPick+}Qty;
                                  end; {Case..}

                          SRN  :  Case Mode of
                                    25  :  RQtySer:={QtyPick+}Qty;
                                    else   RQtySer:=QtyDel+QtyPWoff;
                                  end;
                        end; {Case..}
                      end
                      else
                        RQtySer:=Qty;

                  If (IdDocHed In WOPSplit) and (LineNo<>1) then {* We are building it, so we need to add it in *}
                  Begin
                    RQtySer:=(RQtySer*-1);

                    Idx:=(RQtySer-SerialQty)*StkAdjCnst[SerDT];
                  end
                  else
                  Begin
                    Case Mode of
                      26  :  Idx:=((RQtySer*QtyMul)-SerialRetQty)*StkAdjCnst[SerDT];
                      else   Idx:=((RQtySer*QtyMul)-SerialQty)*StkAdjCnst[SerDT];
                    end; {Case..}

                    If (Mode=26) and (IdDocHed=PRN) then
                      Idx:=Idx*DocNotCnst;

                    
                  end;
                end;

        end; {Case..}

//        If (Idx<>0) then
        If (Idx<>0)
        {$IFDEF CU}
          or (SpecialHookPointEnabled) {NF}
        {$ENDIF}
        then
        Begin

          Rnum:=0;

          If (IdDocHed In PurchSplit) then
          Begin
            // MH 25/03/2009: Added support for 2 new discounts for Advanced Discounts
            //DiscP:=Calc_PAmount(Round_Up(NetValue,Syss.NoCosDec),Discount,DiscountChr);
            DiscP := Calc_PAmountAD (Round_Up(NetValue,Syss.NoCosDec),
                                     Discount, DiscountChr,
                                     Discount2, Discount2Chr,
                                     Discount3, Discount3Chr);

            If (ShowCase) then
              Rnum:=Round_Up(Calc_StkCP((NetValue-DiscP),QtyPack,UsePack)+Idr.CostPrice,Syss.NoCosDec)
            else
              Rnum:=Round_Up(Calc_StkCP((NetValue-DiscP+Idr.CostPrice),QtyMul,UsePack),Syss.NoCosDec);
          end
          else
            If (IdDocHed In StkAdjSplit) or ((IdDocHed In WOPSplit) and (LineNo=1)) then
            Begin
              If (Mode=1) and (IdR.Qty>0.0) then
                Rnum:=IdR.CostPrice
              else
                Rnum:=IdR.CostPrice*SerialQty;
            end
            else      {* V5.50 Check on Idx added for returned batches via SOR pick qty being reduced *}
              If (IdDocHed In StkRetSalesSplit) and (Mode=26) then
                Rnum:=(Calc_StkCP(IdR.CostPrice,QtyMul,UsePack)*SerialRetQty)
              else
                If ((IdDocHed<>SOR) or (Idx>0)) and (Not (IdDocHed In WOPSplit)) and ((Not (IdDocHed In StkRetPurchSplit)) or (Mode<>26)) then {* Don't keep running average for picked lines, replace with last s nos *}
                  Rnum:=(Calc_StkCP(IdR.CostPrice,QtyMul,UsePack)*SerialQty);
              {else
                If (IdDocHed In [SCR,SJC,SRF]) then {* It may be added back in, so we need cost of one *}
                  {Rnum:=Calc_StkCP(IdR.CostPrice,QtyMul,UsePack); v5 Credits had to be treated the same as normals}


                {Round_Up(Currency_ConvFT(DivWChk(Stock.CostPrice,Stock.BuyUnit),PCurrency,Inv.Currency,UseCoDayRate),
                             Syss.NoCosDec);}

          StkRec:=TFSTKDisplay.Create(TComponent(Sender));

          OrigIdx:=Idx;

          try

            With StkRec do
            Begin
              TInv:=InvR;
              TId:=IdR;

              TSerialReq:=Idx;

              TDocCostP:=Rnum;

              If (Mode In [25,26]) then {* We are in special returns mode *}
              Begin
                TSerRetMode:=Mode;

              end;

              Display_Account(5);

              Repeat

                Application.ProcessMessages;

                SleepEx(100,BOn);

              Until (Not StkActive);

              Idx:=TSerialReq;
              Rnum:=TDocCostP;
              QtyChosen:=TChosenQty;

            end; {With..}

          finally

            StkRec.Free;

          end; {try..}

          If (SerNoWAvg=0) then
          Begin

            If (IdDocHed In SalesSplit) then
            Begin
              Begin {v5.00.001 we need to multiply by the pack size to re-establish the line cost}
                { CJS 2013-05-23 - ABSEXCH-13954 - Cost Price on Batch items does
                                   not calculate correctly when Purchase UoM is
                                   greater than 1 -- added check against
                                   StkValType }
                If (Not StockR.CalcPack) and
                   (Not StockR.PricePack) and
                   (StockR.BuyUnit<>1.0) and
                   ((StockR.StkValType <> 'R') or
                    ((StockR.StkValType = 'R') and (QtyMul > 1))) then
                  Rnum:=(Rnum*StockR.BuyUnit);

              end;

              If (IdDocHed<>SOR) or (OrigIdx>0) then  {* V5.50 Check on OrigIdx added for returned batches via SOR pick qty being reduced *}
              Begin
                If (QtyChosen<0) then
                  QtyChosen:=RQtySer
                else
                  If (SerialQty<QtyChosen) or (RQtySeR>SerialQty) then
                    QtyChosen:=QtyChosen+SerialQty {* Compensate for any costs already there on an incremental edit *}
                  else
                    QtyChosen:=SerialQty-QtyChosen; {* We must be reducing qty so cost will be based on what is left *}
              end
              else
              Begin
                If (QtyChosen<0) then
                  QtyChosen:=OrigIdx*StkAdjCnst[SerDT];
              end;

              IdR.CostPrice:=Round_Up(DivWChk(Rnum,QtyChosen),Syss.NoCosDec);

              If (QtyChosen>0) and (Rnum<>0.0) then {* v4.32.003 We need to refresh the COS conversion rate here as the
                                                         current daily rate will have been used *}
                  IdR.COSConvRate:=SyssCurr^.Currencies[Currency].CRates[UseCoDayRate];

              {If (IdDocHed<>SOR) then Replaced with qty chosen v4.32
                  IdR.CostPrice:=Round_Up(DivWChk(Rnum,RQtySer),Syss.NoCosDec)
                else {* Don't keep running avergae for picked lines, replace with last s nos  cost*}
                  {IdR.CostPrice:=Round_Up(DivWChk(Rnum,OrigIdx*StkAdjCnst[SerDT]),Syss.NoCosDec);}
            end
            else
              If (IdDocHed In StkAdjSplit+WOPSPlit) and ((Mode<>1) or (IdR.Qty<0.0)) then
              Begin
                If (QtyChosen<0) or (SerialQty<>0) then
                  QtyChosen:=RQtySer
                else
                  QtyChosen:=QtyChosen*DocNotCnst;

                IdR.CostPrice:=Round_Up(DivWChk(Rnum,QtyChosen),Syss.NoCosDec);

                {Replaced with qty chosen v4.32}
                {IdR.CostPrice:=Round_Up(DivWChk(Rnum,RQtySer),Syss.NoCosDec);}

              end
              else
                If (IdDocHed In WOPSPlit) and ((Mode<>1) or (OrigIdx<0.0)) then
                Begin
                  If (QtyChosen<0) then
                    QtyChosen:=OrigIdx*StkAdjCnst[SerDT];

                  IdR.CostPrice:=Round_Up(DivWChk(Rnum,QtyChosen),Syss.NoCosDec);

                  {Replaced with qty chosen v4.32}
                  {IdR.CostPrice:=Round_Up(DivWChk(Rnum,RQtySer),Syss.NoCosDec);}

                end
                else
                If (IdDocHed In StkRETSPlit) and ((Mode<>1) or (OrigIdx<0.0)) then
                Begin
                  If (QtyChosen<0) then
                    QtyChosen:=OrigIdx*StkAdjCnst[SerDT];

                  If (IdDocHed In StkRetPurchSplit) and (Mode<>26) then
                  Begin
                    IdR.CostPrice:=Round_Up(DivWChk(Rnum*StkAdjCnst[SerDT],QtyChosen),Syss.NoCosDec);

                    IdR.NetValue:=IdR.CostPrice;

                  end
                  else
                  Begin
                    If (Mode=25) then
                      Rnum:=Rnum*DocNotCnst;

                    IdR.CostPrice:=Round_Up(DivWChk(Rnum,QtyChosen),Syss.NoCosDec);

                  end;


                end;


                                                     {* Or we are putting back via sales *}
            If (Idr.CostPrice=0.0) and (((QtyChosen=0) or (OrigIdx>0)) and (IdDocHed In SalesSplit+WOPSplit+StkAdjSplit))
              and (OrigCPrice<>0.0) then {We have not picked anything, restore it back}
              Idr.CostPrice:=Currency_ConvFT(OrigCPrice,StockR.PCurrency,IdR.Currency,UseCoDayRate);

          end
          else {If serial average}
            Begin
              If (IdDocHed In SalesSplit+StkAdjSplit) and (QtyChosen>0) and (OrigIdx<0) then
              Begin
                Rnum:=Currency_ConvFT(Calc_StkCP(StockR.CostPrice,StockR.BuyUnit,UsePack),
                                        StockR.PCurrency,IdR.Currency,UseCoDayRate);


                IdR.CostPrice:=Round_Up(Calc_IdQty(Rnum,QtyMul,Not UsePack),Syss.NoCosDec);


              end;

            end;


          If (IdDocHed In WOPSPlit) then
            SerialQty:=RQtySer
          else
          Begin
            Case Mode of
              26  :  SerialRetQty:=RQtySer*QtyMul;
              else   SerialQty:=RQtySer*QtyMul;
            end; {Case..}
          end;
        end;

      end
      else
        If (Is_FullStkCode(StockCode)) and (Stock.MultiBinMode) and (Not (SerDT In QuotesSet)) then
          Control_BINS(Idr,InvR,StockR,Mode,Sender);

    end; {With..}
  end; {Proc..}


  { ============ Procedure to Control Bin Codes =========== }

  {23 = Deletion of Return effect on BinQty
   33 = Deletion of Return    "   "  BinRetQty
   25 = When Sales Return stock being booked in...
   26 = When Sales Return stock being issued out }


  Procedure Control_BINS(Var Idr  :  IDetail;
                             InvR :  InvRec;
                             StockR
                                  :  StockRec;
                             Mode :  Byte;
                             Sender
                                  :  TObject);

  Var
    OrigIdx,
    Idx,
    Rnum,
    RQtySer,
    DiscP,
    OrigCPrice,
    QtyChosen


         :  Real;

    SerDT:  DocTypes;

    StkRec
         :  TFSTKDisplay;

    FoundCode
         :  Str20;




  Begin

    Idx:=0; OrigIdx:=0.0;

    Rnum:=0;

    DiscP:=0;

    RQtySer:=0;

    SerDT:=Idr.IdDocHed;

    OrigCPrice:=0.0; QtyChosen:=0.0;


    With Idr do
    Begin
      If (StockR.StockCode<>StockCode) then
      Begin
        GetStock(TWinControl(Sender),StockCode,FoundCode,-1);
        StockR:=Stock;
      end;

      If (Is_FullStkCode(StockCode)) and (StockR.MultiBinMode) and (Not (SerDT In QuotesSet))   then
      With StockR do
      Begin
        OrigCPrice:=CostPrice;


        If (SerDT In OrderSet) then
        Begin

          If (SerDT In [SOR,SQU]) then
            SerDT:=SDN
          else
            SerDT:=PDN;

        end;

        Case Mode of

          3  :  Begin
                  Idx:=BinQty*StkAdjCnst[SerDT]*DocNotCnst;
                end;

         23  :  Begin
                  Idx:=(BinQty-BinRetQty)*StkAdjCnst[SerDT]*DocNotCnst;
                end;
         33 :  Begin
                 Idx:=BinRetQty*StkAdjCnst[SerDT]*DocNotCnst;
               end;

          else  Begin

                  If (IdDocHed In OrderSet) and (LineNo<>StkLineNo) then {* Act on Picked Qty *}
                    RQtySer:=QtyPick+QtyDel
                  else
                    If (IdDocHed In WOPSplit) then
                    Begin
                      If (LineNo<>1) then
                        RQtySer:=QtyPick+QtyDel
                      else
                        RQtySer:=QtyPick+QtyWOff; {Include built}
                    end
                    else
                      If (IdDocHed In StkRetSplit) then
                      Begin
                        Case IdDocHed of
                          PRN  :  Case Mode of
                                    26  :  RQtySer:=QtyDel+QtyPWoff;

                                    else  RQtySer:={QtyPick+}Qty;
                                  end; {Case..}

                          SRN  :  Case Mode of
                                    25  :  RQtySer:={QtyPick+}Qty;
                                    else   RQtySer:=QtyDel+QtyPWoff;
                                  end;
                        end; {Case..}
                      end
                      else
                        RQtySer:=Qty;

                  If (IdDocHed In WOPSplit) and (LineNo<>1) then {* We are building it, so we need to add it in *}
                  Begin
                    RQtySer:=(RQtySer*-1);

                    Idx:=(RQtySer-BinQty)*StkAdjCnst[SerDT];
                  end
                  else
                  Begin

                    Case Mode of
                      26  :  Idx:=((RQtySer*QtyMul)-BinRetQty)*StkAdjCnst[SerDT];
                      else   Idx:=((RQtySer*QtyMul)-BinQty)*StkAdjCnst[SerDT];
                    end; {Case..}

                    If (Mode=26) {and (IdDocHed=PRN)} then
                      Idx:=Idx*DocNotCnst;

                  end;

                end;

        end; {Case..}

        If (Idx<>0) then
        Begin

          Rnum:=0;

          If (IdDocHed In PurchSplit) then
          Begin
            // MH 25/03/2009: Added support for 2 new discounts for Advanced Discounts
            //DiscP:=Calc_PAmount(Round_Up(NetValue,Syss.NoCosDec),Discount,DiscountChr);
            DiscP := Calc_PAmountAD (Round_Up(NetValue,Syss.NoCosDec),
                                     Discount, DiscountChr,
                                     Discount2, Discount2Chr,
                                     Discount3, Discount3Chr);

            If (ShowCase) then
              Rnum:=Round_Up(Calc_StkCP((NetValue-DiscP),QtyPack,UsePack)+Idr.CostPrice,Syss.NoCosDec)
            else
              Rnum:=Round_Up(Calc_StkCP((NetValue-DiscP+Idr.CostPrice),QtyMul,UsePack),Syss.NoCosDec);
          end
          else
            If (IdDocHed In StkAdjSplit) or ((IdDocHed In WOPSplit) and (LineNo=1)) then
            Begin
              If (Mode=1) and (IdR.Qty>0.0) then
                Rnum:=IdR.CostPrice
              else
                Rnum:=IdR.CostPrice*BinQty;
            end
            else      {* V5.50 Check on Idx added for returned batches via SOR pick qty being reduced *}
              If ((IdDocHed<>SOR) or (Idx>0)) and (Not (IdDocHed In WOPSplit)) then {* Don't keep running avergae for picked lines, replace with last s nos *}
                Rnum:=(Calc_StkCP(IdR.CostPrice,QtyMul,UsePack)*BinQty);
              {else
                If (IdDocHed In [SCR,SJC,SRF]) then {* It may be added back in, so we need cost of one *}
                  {Rnum:=Calc_StkCP(IdR.CostPrice,QtyMul,UsePack); v5 Credits had to be treated the same as normals}


                {Round_Up(Currency_ConvFT(DivWChk(Stock.CostPrice,Stock.BuyUnit),PCurrency,Inv.Currency,UseCoDayRate),
                             Syss.NoCosDec);}

          StkRec:=TFSTKDisplay.Create(TComponent(Sender));

          OrigIdx:=Idx;

          try

            With StkRec do
            Begin
              TInv:=InvR;
              TId:=IdR;

              TSerialReq:=Idx;

              TDocCostP:=Rnum;

              If (Mode In [25,26]) then {* We are in special returns mode *}
              Begin
                TSerRetMode:=Mode;

              end;


              Display_Account(6);

              Repeat

                Application.ProcessMessages;

              Until (Not StkActive);

              Idx:=TSerialReq;
              Rnum:=TDocCostP;
              QtyChosen:=TChosenQty;

            end; {With..}

          finally

            StkRec.Free;

          end; {try..}

          If (SerNoWAvg=0) then
          Begin

            If (IdDocHed In SalesSplit) then
            Begin
              Begin {v5.00.001 we need to multiply by the pack size to re-establish the line cost}
                If (Not StockR.CalcPack) and (Not StockR.PricePack) and (StockR.BuyUnit<>1.0) then
                  Rnum:=(Rnum*StockR.BuyUnit);

              end;

              If (IdDocHed<>SOR) or (OrigIdx>0) then  {* V5.50 Check on OrigIdx added for returned batches via SOR pick qty being reduced *}
              Begin
                If (QtyChosen<0) then
                  QtyChosen:=RQtySer
                else
                  If (BinQty<QtyChosen) or (RQtySeR>BinQty) then
                    QtyChosen:=QtyChosen+BinQty {* Compensate for any costs already there on an incremental edit *}
                  else
                    QtyChosen:=BinQty-QtyChosen; {* We must be reducing qty so cost will be based on what is left *}
              end
              else
              Begin
                If (QtyChosen<0) then
                  QtyChosen:=OrigIdx*StkAdjCnst[SerDT];
              end;

              {$IFDEF NABINS} {* Not applicable to bins, I don't think as other valuation methods come into play *}
                IdR.CostPrice:=Round_Up(DivWChk(Rnum,QtyChosen),Syss.NoCosDec);

                If (QtyChosen>0) and (Rnum<>0.0) then {* v4.32.003 We need to refresh the COS conversion rate here as the
                                                           current daily rate will have been used *}
                    IdR.COSConvRate:=SyssCurr^.Currencies[Currency].CRates[UseCoDayRate];

              {$ENDIF}

              {If (IdDocHed<>SOR) then Replaced with qty chosen v4.32
                  IdR.CostPrice:=Round_Up(DivWChk(Rnum,RQtySer),Syss.NoCosDec)
                else {* Don't keep running avergae for picked lines, replace with last s nos  cost*}
                  {IdR.CostPrice:=Round_Up(DivWChk(Rnum,OrigIdx*StkAdjCnst[SerDT]),Syss.NoCosDec);}
            end
            else
              If (IdDocHed In StkAdjSplit+WOPSPlit) and ((Mode<>1) or (IdR.Qty<0.0)) then
              Begin
                If (QtyChosen<0) or (BinQty<>0) then
                  QtyChosen:=RQtySer
                else
                  QtyChosen:=QtyChosen*DocNotCnst;

                {$IFDEF NABINS} {* Not applicable to bins, I don't think as other valuation methods come into play *}
                  IdR.CostPrice:=Round_Up(DivWChk(Rnum,QtyChosen),Syss.NoCosDec);
                {$ENDIF}

                {Replaced with qty chosen v4.32}
                {IdR.CostPrice:=Round_Up(DivWChk(Rnum,RQtySer),Syss.NoCosDec);}

              end
              else
                If (IdDocHed In WOPSPlit) and ((Mode<>1) or (OrigIdx<0.0)) then
                Begin
                  If (QtyChosen<0) then
                    QtyChosen:=OrigIdx*StkAdjCnst[SerDT];

                  {$IFDEF NABINS} {* Not applicable to bins, I don't think as other valuation methods come into play *}

                    IdR.CostPrice:=Round_Up(DivWChk(Rnum,QtyChosen),Syss.NoCosDec);

                  {$ENDIF}

                  {Replaced with qty chosen v4.32}
                  {IdR.CostPrice:=Round_Up(DivWChk(Rnum,RQtySer),Syss.NoCosDec);}

                end
                else
                If (IdDocHed In StkRETSPlit) and ((Mode<>1) or (OrigIdx<0.0)) then
                Begin
                  If (QtyChosen<0) then
                    QtyChosen:=OrigIdx*StkAdjCnst[SerDT];

                  {$IFDEF NABINS} {* Not applicable to bins, I don't think as other valuation methods come into play *}

                    If (IdDocHed In StkRetPurchSplit) then
                    Begin
                      IdR.CostPrice:=Round_Up(DivWChk(Rnum*StkAdjCnst[SerDT],QtyChosen),Syss.NoCosDec);

                      IdR.NetValue:=IdR.CostPrice;

                    end
                    else
                      IdR.CostPrice:=Round_Up(DivWChk(Rnum*DocNotCnst,QtyChosen),Syss.NoCosDec);
                  {$ENDIF}

                end;



                                                     {* Or we are putting back via sales *}
            {$IFDEF NABINS} {* Not applicable to bins, I don't think as other valuation methods come into play *}
              If (Idr.CostPrice=0.0) and (((QtyChosen=0) or (OrigIdx>0)) and (IdDocHed In SalesSplit+WOPSplit+StkAdjSplit))
              and (OrigCPrice<>0.0) then {We have not picked anything, restore it back}
              Idr.CostPrice:=OrigCPrice;
            {$ENDIF}
          end
          else {If serial average}
            Begin
              If (IdDocHed In SalesSplit+StkAdjSplit) and (QtyChosen>0) and (OrigIdx<0) then
              Begin
                Rnum:=Currency_ConvFT(Calc_StkCP(StockR.CostPrice,StockR.BuyUnit,UsePack),
                                        StockR.PCurrency,IdR.Currency,UseCoDayRate);


                {$IFDEF NABINS} {* Not applicable to bins, I don't think as other valuation methods come into play *}
                  IdR.CostPrice:=Round_Up(Calc_IdQty(Rnum,QtyMul,Not UsePack),Syss.NoCosDec);
                {$ENDIF}

              end;

            end;


          If (IdDocHed In WOPSPlit) then
            BinQty:=RQtySer
          else
          Begin
            Case Mode of
              26  :  BinRetQty:=RQtySer*QtyMul;
              else   BinQty:=RQtySer*QtyMul
            end; {Case..}

          end;

            
        end;

      end;
    end; {With..}
  end; {Proc..}

  {$IFDEF PF_On}
    //PR: 08/02/2012 Add parameter to pass through folio number for qty breaks ABSECH-9795
    Procedure Control_CQtyB(CustR   :  CustRec;
                            SCode   :  Str20;
                            Sender  :  TObject;
                            CustomerDiscountRec : CustDiscType);

    Var
      FoundCode
           :  Str20;

      FoundOk
           :  Boolean;

      StkRec
           :  TFSTKDisplay;



    Begin

      If (Stock.StockCode<>SCode) then
        FoundOk:=GetStock(TWinControl(Sender),SCode,FoundCode,-1)
      else
        FoundOk:=BOn;

      If (FoundOk) then
      Begin

        StkRec:=TFSTKDisplay.Create(TComponent(Sender));

        try

          With StkRec do
          Begin
            TCust:=CustR;

            //PR: 08/02/2012 ABSSEXCH-9795
            CDiscountRec := CustomerDiscountRec;
            If (TComponent(Sender).Name='CustRec3') then
              CallBackBias:=110;

            Display_Account(16);

          end; {With..}

        except

          StkRec.Free;

        end; {try..}
      end; {With..}
    end; {Proc..}


    {$IFDEF SOP}
      Procedure Control_FindSer(Sender  :  TObject;
                                SCode   :  Str255;
                                SMode   :  Byte);


      Begin

        If (Not Assigned(SerStkRec)) then
          SerStkRec:=TFSTKDisplay.Create(TComponent(Sender));

        try

          With SerStkRec do
          Begin
            TSerFind:=BOn;
            TSerMainK:=SCode;
            TSerFindMode:=SMode;

            Display_Account(5);

          end; {With..}

        except

          SerStkRec.Free;

        end; {try..}
      end; {Proc..}



    {$ENDIF}


    Procedure Control_FindBin(Sender  :  TObject;
                              SCode   :  Str255;
                              SMode   :  Byte);


    Begin

      If (Not Assigned(BinStkRec)) then       
        BinStkRec:=TFSTKDisplay.Create(Application);

      try

        With BinStkRec do
        Begin
          TBinFind:=BOn;
          TSerMainK:=SCode;
          TSerFindMode:=SMode;
          CallBackBias:=10;

          Display_Account(6);

        end; {With..}

      except

        BinStkRec.Free;

      end; {try..}
    end; {Proc..}

  {$ENDIF}

{$ENDIF}


Initialization

  SerStkRec:=nil;

  BinStkRec:=nil;



end.
