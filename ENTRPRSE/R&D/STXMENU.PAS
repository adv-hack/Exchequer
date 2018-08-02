unit STxMenu;

interface

{$I DEFOVR.Inc}

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, TEditVal, BorBtns, ComCtrls,

  GlobVar,VarConst,

  BTSupU1;


type
  TInvAddForm = class(TForm)
    PageControl1: TPageControl;
    SalesPage: TTabSheet;
    PurchPage: TTabSheet;
    SINBtn: TBorRadio;
    SRCBtn: TBorRadio;
    SCRBtn: TBorRadio;
    SJIBtn: TBorRadio;
    SJCBtn: TBorRadio;
    SRIBtn: TBorRadio;
    SRFBtn: TBorRadio;
    SQUBtn: TBorRadio;
    SBTBtn: TBorRadio;
    ClsCP1Btn: TButton;
    OkCP1Btn: TButton;
    PinBtn: TBorRadio;
    PPYBtn: TBorRadio;
    PCRBtn: TBorRadio;
    PJIBtn: TBorRadio;
    PJCBtn: TBorRadio;
    PPIBtn: TBorRadio;
    PRFBtn: TBorRadio;
    PQUBtn: TBorRadio;
    PBTBtn: TBorRadio;
    tsCashbook: TTabSheet;
    rbPayment: TBorRadio;
    rbReceipt: TBorRadio;
    rbTransfer: TBorRadio;
    rbStandard: TBorRadio;
    cbRecurring: TBorCheckEx;
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure OkCP1BtnClick(Sender: TObject);
    procedure ClsCP1BtnClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure SRCBtnClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure PageControl1Change(Sender: TObject);
  private
    { Private declarations }
    PrevHState,
    FromDayBk,

    SalesPurch  :  Boolean;

    LastDocHed  :  DocTypes;


    Procedure WMDayBkGetRec(Var Message  :  TMessage); Message WM_CustGetRec;

    Procedure Send_ParentMsg(Mode   :  Integer);

    Function Scan4Alloc(CMode  :  Boolean)  :  Boolean;

    Procedure RecepWiz;

    procedure SetHelpContextIDsForPage; //NF:

  public
    { Public declarations }

    DispTransPtr
               :  Pointer;


    Procedure SetDefault(DocTyp   :  DocTypes;
                         PrimeDoc :  Boolean;
                         MCC      :  Integer);



    Function SetResult  :  DocTypes;

    procedure Display_Trans(Mode  :  Byte);

    procedure Show_Current;

  end;


  Function AddDayBook(Sender   :   TObject;
                      SPurch   :   Boolean;
                  Var DocTyp   :   DocTypes;
                      Mode     :   Byte)  :  Boolean;


{~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~}

Implementation

{~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~}

Uses
  {$IFDEF C_On}
    Custr3U,
  {$ENDIF}

  AllcWizU,

  TranL1U,

  BTSupU2,
  PWarnU

  {$IFDEF ADDNOMWIZARD}
    ,AddNomWizard // NF: 31/05/06
  {$ENDIF}
  , NomTfr2U; // NF: 31/05/06



{$R *.DFM}



procedure TInvAddForm.FormCreate(Sender: TObject);

  Procedure SetHelpContextIDs; // NF: 07/04/06
  begin
    PurchPage.HelpContext := 9;
    {$IFDEF LTE}
      SalesPage.HelpContext := 5009;
      SINBtn.HelpContext := 5034;
      SRCBtn.HelpContext := 5035;
      SCRBtn.HelpContext := 5036;
      SJCBtn.HelpContext := 5039;
      SJIBtn.HelpContext := 5038;
      SQUBtn.HelpContext := 5037;
      SRIBtn.HelpContext := 5040;
      SRFBtn.HelpContext := 5041;
      SBTBtn.HelpContext := 45099;

      // NF: 01/06/06
      tsCashbook.HelpContext := 1831;
      rbPayment.HelpContext := 1832;
      rbReceipt.HelpContext := 1833;
      rbTransfer.HelpContext := 1834;
      rbStandard.HelpContext := 1835;
      cbRecurring.HelpContext := 1836;

      SetHelpContextIDsForPage;
    {$ENDIF}
  end;

begin
  DispTransPtr:=nil;

  // Check Add nom Wizard Password (user permission), to see if we should show the cashbook tab
  //RJha 05/02/2016 2016-R1 ABSEXCH-15817: Disabling Add NOM Transaction access setting can be bypassed if use Standard Journal Wizard is also disabled
  tsCashbook.TabVisible := not ChkAllowed_In(572) and ChkAllowed_In(25) ; // NF: 31/05/06

  // Make sure that the first tab is shown, not the design-time tab
  PageControl1.ActivePageIndex := 0; // NF: 31/05/06

  SetHelpContextIDs; // NF: 07/04/06

  PPYBtn.Visible:=(Not Syss.BatchPPY) and ChkAllowed_In(365);

  SINBtn.Visible:=(Not Syss.ExternSIN) and ChkAllowed_In(355);

  If (SINBtn.Checked) and (Not SINBtn.Visible) then
    SINBtn.Checked:=BOff;

  SCRBtn.Visible:=(Not Syss.ExternSIN) and ChkAllowed_In(357);
  SRCBtn.Visible:=ChkAllowed_In(356);
  SJIBtn.Visible:=ChkAllowed_In(359);
  SJCBtn.Visible:=ChkAllowed_In(360);
  SRIBtn.Visible:=ChkAllowed_In(361);
  SRFBtn.Visible:=ChkAllowed_In(362);
  SQUBtn.Visible:=ChkAllowed_In(358);
  SBTBtn.Visible:=ChkAllowed_In(363);

  // MH 07/11/2011 v6.9 ABSEXCH-10868: Modified to check whether any options within the tab are available
  SalesPage.TabVisible:=ChkAllowed_In(02) And (SINBtn.Visible Or SQUBtn.Visible Or SRIBtn.Visible Or
                                               SRCBtn.Visible Or SJIBtn.Visible Or SRFBtn.Visible Or
                                               SCRBtn.Visible Or SJCBtn.Visible Or SBTBtn.Visible);

  PINBtn.Visible:=ChkAllowed_In(364);
  PCRBtn.Visible:=ChkAllowed_In(366);
  PJIBtn.Visible:=ChkAllowed_In(368);
  PJCBtn.Visible:=ChkAllowed_In(369);
  PPIBtn.Visible:=ChkAllowed_In(370);
  PRFBtn.Visible:=ChkAllowed_In(371);
  PQUBtn.Visible:=ChkAllowed_In(367);
  PBTBtn.Visible:=ChkAllowed_In(372);

  // MH 07/11/2011 v6.9 ABSEXCH-10868: Modified to check whether any options within the tab are available
  PurchPage.TabVisible := ChkAllowed_In(11) And (PINBtn.Visible Or PPYBtn.Visible Or PCRBtn.Visible Or
                                                 PQUBtn.Visible Or PJIBtn.Visible Or PJCBtn.Visible Or
                                                 PPIBtn.Visible Or PRFBtn.Visible Or PBTBtn.Visible);
  SetDefault(SIN,BOff,ComponentCount);

  If (Not SalesPage.TabVisible) then
    PageControl1.ActivePage:=PurchPage
  else
    If (Not PurchPage.TabVisible) then
      PageControl1.ActivePage:=SalesPage;

end;


Procedure TInvAddForm.SetDefault(DocTyp   :  DocTypes;
                                 PrimeDoc :  Boolean;
                                 MCC      :  Integer);

Var
  n,
  Counter  :  Integer;

  NextOne  :  Boolean;

Begin
  Counter:=0; NextOne:=BOff;

  For n:=0 to Pred(MCC) do
    If (Components[n] is TBorRadio) then
    With TBorRadio(Components[n]) do
    Begin
      Case PrimeDoc of
        BOff :  Begin
                  Case Counter of
                    0  :  Checked:=Visible;
                    1  :  Checked:=(Visible And (Parent=SalesPage));
                  end;

                  If (Checked) then
                    Inc(Counter);

                  If (Counter=2) then
                    Exit;
                end;
        BOn  :  Begin
                  Checked:=(((DocSplit[SalesPurch,Tag]=DocTyp) or (NextOne)) and (GroupIndex=1+Ord(SalesPurch))) and (Visible);

                  If ((DocSplit[SalesPurch,Tag]=DocTyp) and (GroupIndex=1+Ord(SalesPurch))) and (Not Checked) then
                    NextOne:=BOn;

                  If (Checked) then
                    Exit;
                end;
      end;

      
    end;
end;


Function TInvAddForm.SetResult  :  DocTypes;

Var
  n  :  Integer;

Begin
  Result:=DocSplit[SalesPurch,1];

  For n:=0 to Pred(ComponentCount) do
    If (Components[n] is TBorRadio) then
    With TBorRadio(Components[n]) do
    Begin
      If (Checked) and (GroupIndex=1+Ord(SalesPurch)) then
      Begin
        Result:=DocSplit[SalesPurch,Tag];
        Exit;
      end;
    end;
end;


Function TInvAddForm.Scan4Alloc(CMode  :  Boolean)  :  Boolean;

Var
  n  :  Integer;

Begin
  Result:=BOff;

  {$IFDEF C_On}
    With Screen do
      For n:=0 to Pred(FormCount) do
        If (Forms[n] is TCustRec3) then
          With TCustRec3(Forms[n]) do
          Begin
            Result:=((Not AllocateOk(BOff)) and (RecordMode=CMode));

            If (Result) then
              Exit;
          end;


  {$ENDIF}
end;



{ ======= Link to Trans display ======== }

procedure TInvAddForm.Display_Trans(Mode  :  Byte);

Var
  DispTrans  :  TFInvDisplay;
  WasNew     :  Boolean;

Begin
  WasNew:=BOff;

  If (DispTransPtr=nil) then
  Begin
    DispTrans:=TFInvDisplay.Create(Self);
    DispTransPtr:=DispTrans;
    WasNew:=BOn;
  end
  else
    DispTrans:=DispTransPtr;

    try

      With DispTrans do
      Begin
        If (Not TransActive[LastActive]) then
          LastDocHed:=Self.LastDocHed;

        Display_Trans(Mode,0,BOff,BOn);

      end; {with..}

    except

      DispTrans.Free;

    end;

end;




Procedure TInvAddForm.WMDayBkGetRec(Var Message  :  TMessage);


Begin


  With Message do
  Begin

    {If (Debug) then
      DebugForm.Add('Mesage Flg'+IntToStr(WParam));}

    Case WParam of



    200,
    205  :  Begin
              DispTransPtr:=nil;


              Show;
            end;

    {300,
    301  :  With MULCtrlO[WParam-300] do
            Begin
              If (MUListBox1.Row<>0) then
                PageUpDn(0,BOn)
              else
                InitPage;
            end;


    3000,
    3001  : With MULCtrlO[WParam-3000] do
            Begin
              Find_OnList(Cust.CustCode,CustCodeK);

              With MUListBoxes[0] do
                If (CanFocus) then
                  SetFocus;
            end;}

    end; {Case..}

  end;
  Inherited;
end;


Procedure TInvAddForm.Send_ParentMsg(Mode   :  Integer);

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


procedure TInvAddForm.FormCloseQuery(Sender: TObject;
  var CanClose: Boolean);
begin
  GenCanClose(Self,Sender,CanClose,BOn);

  If (Not FromDayBk) and (CanClose) then
    Send_ParentMsg(20);
end;


Procedure TInvAddForm.RecepWiz;

Begin
  Set_alSales(SalesPurch,BOff);


  With TAllocateWiz.Create(Self) do
  Try

  except
    Free;

  end; {try..}

end;



procedure TInvAddForm.OkCP1BtnClick(Sender: TObject);

  // NF: 31/05/06
  procedure AddNominal(bAutoNom : boolean);
  // This code is duplicated, and contains modified excepts from
  // DayBK2 : AddButtonExecute
  // DayBK2 : Display_Trans
  // DayBK2 : Display_NTxfr
  var
    NTxfrForm  :  TNTxfrForm;
  begin{AddNominal}
    if bAutoNom then Set_NTxfrFormMode(NMT, 2)
    else Set_NTxfrFormMode(NMT, 0);

    NTxfrForm:=TNTxfrForm.Create(Self);

    Try
      With NTxfrForm do
      Begin
        WindowState:=wsNormal;
        Show;
        ChangePage(0);
        EditAccount(FALSE, bAutoNom, FALSE);
      end;{with}
    except
      NTxfrForm.Free;
    end;{try}
  end;{AddNominal}

Var
  UseRecepWiz  :  Boolean;

begin
  If (Not FromDayBk) then
  Begin

    // NF: 31/05/06
    if PageControl1.ActivePage = tsCashbook then
    begin
      // Add Nominal Transaction
      {$IFDEF ADDNOMWIZARD}
        if rbPayment.Checked then ShowAddNomWizard(0, ttPayment, cbRecurring.Checked);
        if rbReceipt.Checked then ShowAddNomWizard(0, ttReceipt, cbRecurring.Checked);
        if rbTransfer.Checked then ShowAddNomWizard(0, ttTransfer, cbRecurring.Checked);

        if rbStandard.Checked then
        begin
//          AddNewTransaction(nil, self, cbRecurring.Checked);
          AddNominal(cbRecurring.Checked);
        end;{if}
      {$ENDIF}
    end else
    begin
      // Add Sales / Purchase Transaction
      SalesPurch:=(PageControl1.ActivePage=SalesPage);
      LastDocHed:=SetResult;
      UseRecepWiz:=(Not FromDayBk) and (LastDocHed In RecieptSet) and (PChkAllowed_In((410*Ord(SaleSPurch))+(413*Ord(Not SalesPurch))));

      If (UseRecepWiz) then RecepWiz
      else Display_Trans(1);
    end;{if}

{    SalesPurch:=(PageControl1.ActivePage=SalesPage);
    LastDocHed:=SetResult;
    UseRecepWiz:=(Not FromDayBk) and (LastDocHed In RecieptSet) and (PChkAllowed_In((410*Ord(SaleSPurch))+(413*Ord(Not SalesPurch))));

    If (UseRecepWiz) then
      RecepWiz
    else
      Display_Trans(1);}

  end;
end;

procedure TInvAddForm.ClsCP1BtnClick(Sender: TObject);
begin
  If (Not FromDayBk) then
    Close;
end;



{ ========== Function to return Add Inv choice ======== }

// MH 07/11/2011: Best guess at Mode: 0=Man Daybook, 1=Batch Entry, 2=Quotes Daybook
Function AddDayBook(Sender   :   TObject;
                    SPurch   :   Boolean;
                Var DocTyp   :   DocTypes;
                    Mode     :   Byte)  :  Boolean;
Var
  mRet   :  Word;

  AddInvForm
         :  TInvAddForm;

  OrigCC :  Integer;


Begin
  Result:=BOff;

  AddInvForm:=TInvAddForm.Create(TWinControl(Sender));

  try

    With AddInvForm do
    Begin
      FromDayBk:=BOn;
      SalesPurch:=SPurch;

      OrigCC:=ComponentCount;

      If (Mode In [0,1,2]) then
      Begin
        With PageControl1 do
        Begin
          Pages[Ord(Not SalesPurch)].TabVisible:=BOff;
          tsCashbook.TabVisible:=BOff; // NF: 31/05/06

          ActivePage:=Pages[Ord(SalesPurch)];

          // MH 07/11/2011 v6.9 ABSEXCH-10868: Modified to suppress OK button when no options are available
          OkCP1Btn.Enabled := PageControl1.ActivePage.TabVisible;
        end;
      end;

      If (Mode=0) then
        SetDefault(DocTyp,BOn,OrigCC)
      else
        If (Mode=2) then
        Begin
          PBTBtn.Visible:=BOff;
          SBTBtn.Visible:=BOff;
        end
        else
        Begin
          PPyBtn.Visible:=BOff;
          SRCBtn.Visible:=BOff;
          PBTBtn.Visible:=BOff;
          SBTBtn.Visible:=BOff;
        end;

      SetAllowHotKey(BOff,PrevHState);

      // MH 07/11/2011 v6.9 ABSEXCH-10868: Modified to suppress OK button when no options are available
      If OkCP1Btn.Enabled Then
        mRet:=ShowModal
      Else
      Begin
        mRet := mrCancel;
        MessageDlg ('Your current user permissions do not permit you to add any transactions here', mtInformation, [mbOK], 0);
      End; // Else

      SetAllowHotKey(BOn,PrevHState);

      Result:=(mRet=mrOk);

      If (Result) then
        DocTyp:=SetResult;

    end;

  finally

    AddInvForm.Free;

  end; {try..}


end;




procedure TInvAddForm.FormClose(Sender: TObject; var Action: TCloseAction);
begin

  If (Not FromDayBk) then
    Action:=caFree;
    
end;

procedure TInvAddForm.SRCBtnClick(Sender: TObject);

Var
  TmpBo  :  Boolean;

begin
  TmpBo:=(Sender=SRCBtn);

  If (Scan4Alloc(TmpBo)) then
  With TBorRadio(Sender) do
  Begin
    ShowMessage('It is not possible to add a '+DocNames[DocSplit[TmpBo,Tag]]+' whilst allocation is in progress.');

    Checked:=BOff;
    Case TmpBo of
      BOff  :  PINBtn.Checked:=BOn;
      BOn   :  SINBtn.Checked:=BOn;
    end;  
  end;
end;



procedure TInvAddForm.Show_Current;

Var
  DispTrans  :  TFInvDisplay;


Begin

  If (DispTransPtr<>nil) then
  Begin
    DispTrans:=DispTransPtr;

    With DispTrans do
      If (TransActive[LastActive]) then
        Display_Trans(1,0,BOff,BOn)
      else
        Self.Show;

  end
  else
    Show;

end;



procedure TInvAddForm.PageControl1Change(Sender: TObject);
begin
  SetHelpContextIDsForPage; // NF: 07/04/06
end;

procedure TInvAddForm.SetHelpContextIDsForPage; // NF: 07/04/06
begin
  {$IFDEF LTE}
    HelpContext := PageControl1.ActivePage.HelpContext;
    PageControl1.HelpContext := PageControl1.ActivePage.HelpContext;
    OkCP1Btn.HelpContext := PageControl1.ActivePage.HelpContext;
    ClsCP1Btn.HelpContext := PageControl1.ActivePage.HelpContext;
  {$ENDIF}
end;


Initialization

end.
