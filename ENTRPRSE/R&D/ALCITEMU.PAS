unit AlcItemU;

interface

{$I DefOvr.Inc}

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ExtCtrls, SBSPanel,GlobVar,VarConst, VarRec2U,BTSupU1,ExWrap1U, BorBtns,
  SupListU,CustSupU,

  SBSComp2, ExtGetU, DEFProcU,
  Menus, TEditVal, Mask, SBSComp, oTakePPD;



type


 TAPMList  =  Class(TDDMList)
   Public
    AllocCtrl  :  MLocRec;
    NHCr       :  Byte;

    Function SetCheckKey  :  Str255; Override;

    Function SetFilter  :  Str255; Override;

    {$IFDEF MC_On}
      Procedure Set_CurrencyFilt;
    {$ENDIF}

    Function Ok2Del :  Boolean; Override;

    Function CheckRowEmph :  Byte; Override;

    Function Link2Inv  :  Boolean;

    Function OutLine(Col  :  Byte)  :  Str255; Override;

    Function  Link2FindList(Opt       :   Byte)  :  Boolean; Override;

    Procedure Find_OnList(Opt       :   Byte;
                          Value     :   Str30); Override;

    procedure ModifyCell(Col, Row: Integer; var CellDetails: TCellDetails); override;
  end;






type
  TAllocItems = class(TForm)
    CListBtnPanel: TSBSPanel;
    CSBox: TScrollBox;
    CHedPanel: TSBSPanel;
    CLORefLab: TSBSPanel;
    CLDueLab: TSBSPanel;
    CLYRefLab: TSBSPanel;
    CLOSLab: TSBSPanel;
    CLAMTLab: TSBSPanel;
    CLDateLab: TSBSPanel;
    CLORefPanel: TSBSPanel;
    CLDatePanel: TSBSPanel;
    CLAMTPanel: TSBSPanel;
    CLOSPAnel: TSBSPanel;
    CLStatPanel: TSBSPanel;
    CLYRefPanel: TSBSPanel;
    CLDuePanel: TSBSPanel;
    CLStatLab: TSBSPanel;
    CBtnPanel: TSBSPanel;
    ClsCP1Btn: TButton;
    CCBSBox: TScrollBox;
    FindCP1Btn: TButton;
    PopupMenu1: TPopupMenu;
    ReCalc1: TMenuItem;
    Find1: TMenuItem;
    N2: TMenuItem;
    PropFlg: TMenuItem;
    N1: TMenuItem;
    StoreCoordFlg: TMenuItem;
    SDiscBtn: TButton;
    Discount1: TMenuItem;
    CLSetCurrPanel: TSBSPanel;
    CLVarPanel: TSBSPanel;
    CLSetCLab: TSBSPanel;
    CLVarLab: TSBSPanel;
    TotPanel: TSBSPanel;
    Label82: Label8;
    Label83: Label8;
    CBalF: TCurrencyEdit;
    DocTotF: TCurrencyEdit;
    UnalTotF: TCurrencyEdit;
    Label81: Label8;
    VarTotF: TCurrencyEdit;
    Label84: Label8;
    Label85: Label8;
    SDiscTotF: TCurrencyEdit;
    AlCP1Btn: TButton;
    PACP1Btn: TButton;
    UACP1Btn: TButton;
    MACP1Btn: TButton;
    SetCP1Btn: TButton;
    DelCP1Btn: TButton;
    ViewCP1Btn: TButton;
    CurCP1Btn: TButton;
    ChkCP1Btn: TButton;
    Allocate1: TMenuItem;
    Unallocate1: TMenuItem;
    Match1: TMenuItem;
    Settle1: TMenuItem;
    Remove1: TMenuItem;
    View1: TMenuItem;
    Currency1: TMenuItem;
    ReCalc2: TMenuItem;
    PrintCP1Btn: TButton;
    Print1: TMenuItem;
    CalcCP1Btn: TButton;
    AutoLab: Label8;
    DocCF: TCurrencyEdit;
    UnalCF: TCurrencyEdit;
    CBalCF: TCurrencyEdit;
    SDiscCF: TCurrencyEdit;
    CLOSBPanel: TSBSPanel;
    CLOSCPanel: TSBSPanel;
    CLOSBLab: TSBSPanel;
    CLOSCLab: TSBSPanel;
    Check1: TMenuItem;
    GenCP1Btn: TButton;
    SetSplitBtn: TButton;
    SetPaysplit1: TMenuItem;
    panPPDAvailable: TSBSPanel;
    panPPDAvailableHed: TSBSPanel;
    panTotWithPPD: TSBSPanel;
    panTotWithPPDHed: TSBSPanel;
    panPPDExpiry: TSBSPanel;
    panPPDStatus: TSBSPanel;
    panPPDExpiryHed: TSBSPanel;
    panPPDStatusHed: TSBSPanel;
    PPDAllocationMenu: TPopupMenu;
    Allocate2: TMenuItem;
    akePPD1: TMenuItem;
    N3: TMenuItem;
    Cancel1: TMenuItem;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormResize(Sender: TObject);
    procedure PropFlgClick(Sender: TObject);
    procedure StoreCoordFlgClick(Sender: TObject);
    procedure PopupMenu1Popup(Sender: TObject);
    procedure CLORefPanelMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure CLORefLabMouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure CLORefLabMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure FormActivate(Sender: TObject);
    procedure ClsCP1BtnClick(Sender: TObject);
    procedure FindCP1BtnClick(Sender: TObject);
    procedure AddCP1BtnClick(Sender: TObject);
    procedure PAllocBtnClick(Sender: TObject);
    procedure SDiscBtnClick(Sender: TObject);
    procedure AlCP1BtnClick(Sender: TObject);
    procedure CalcCP1BtnClick(Sender: TObject);
    procedure ViewCP1BtnClick(Sender: TObject);
    procedure DelCP1BtnClick(Sender: TObject);
    procedure GenCP1BtnClick(Sender: TObject);
    procedure ChkCP1BtnClick(Sender: TObject);
    procedure CurCP1BtnClick(Sender: TObject);
    procedure MACP1BtnClick(Sender: TObject);
    procedure SetCP1BtnClick(Sender: TObject);
    procedure PrintCP1BtnClick(Sender: TObject);
    procedure SetSplitBtnClick(Sender: TObject);
    procedure Allocate2Click(Sender: TObject);
    procedure akePPD1Click(Sender: TObject);
  private
    fFrmClosing,
    fFinishedOK,
    RecMode,
    BeenIn,
    InHBeen,
    JustCreated,
    StoreCoord,
    LastCoord,
    SetDefault,
    fNeedCUpdate,
    fDoingClose,
    InProcessBtn,
    InSettleBtn,
    InSplitPay,
    UpdateCS,
    GotCoord,
    CanDelete    :  Boolean;

    PagePoint    :  Array[0..5] of TPoint;

    StartSize,
    InitSize     :  TPoint;

    MatchFormPtr,
    DispTransPtr
                 :  Pointer;

    OriginalTotal:  Double;

    CustBtnList  :  TVisiBtns;

    LastSValue   :  Str20;

    FTakePPD : Boolean;

    TakePPDI : ITakePPD;

    procedure Find_FormCoord;

    procedure Store_FormCoord(UpMode  :  Boolean);

    procedure FormSetOfSet;

    Function ScanMode  :  Boolean;

    procedure Display_Trans(Mode        :  Byte;
                            GlobalMode  :  Boolean;
                            ViewOnly    :  Boolean);

    procedure Reset_Trans;

    Procedure WMFormCloseMsg(Var Message  :  TMessage); Message WM_FormCloseMsg;

    Procedure WMCustGetRec(Var Message  :  TMessage); Message WM_CustGetRec;

    Procedure WMGetMinMaxInfo(Var Message  :  TWMGetMinMaxInfo); Message WM_GetMinMaxInfo;

    Procedure Send_UpdateList(Mode   :  Integer);

    procedure ShowRightMeny(X,Y,Mode  :  Integer);

    Procedure  SetNeedCUpdate(B  :  Boolean);

    Property NeedCUpDate :  Boolean Read fNeedCUpDate Write SetNeedCUpdate;

    Function AllocCheckSum  :  Double;

    procedure DeleteAllocLine;

    procedure Display_Match(ChangeFocus,
                            MatchMode     :  Boolean);

    procedure SetHelpContextIDs; // NF: 11/05/06

  public
    { Public declarations }

    ExLocal      :  TdExLocal;

    ListOfSet    :  Integer;

    MULCtrlO     :  TAPMList;

    DDownTitle   :  Str20;
    ColTagged    :  Boolean;


    procedure FormDesign;

    Procedure SetButtons(State  :  Boolean);

    procedure PrimeButtons(PWRef   :  Boolean);

    procedure RefreshList(ShowLines,
                          IgMsg      :  Boolean);

    procedure FormBuildList(ShowLines  :  Boolean);

    procedure SetCaption;

    procedure SetFormProperties;

    procedure Link2Tot;

    Function GetInv(ORef  :  Str10)  :  Boolean;

    Function SRC_AllocStatus  :  Boolean;

    //PR: 13/05/2015 ABSEXCH-16284 Add default TakePPD parameter
    Procedure Allocate(AlMode  :  Byte; TakePPD : Boolean = False);

    Function SRCTol  :  Double;

    Function Within_SRCTol(TmpVariance  :  Double):  Boolean;

    //PR: 03/06/2015 ABSEXCH-16476 Added default parameter so func can take account of ppd
    //PR: 19/06/2015 ABSEXCH-16558 Added default BasePPD parameter
    Function Calc_Variance(Mode     :  Byte;
                                   BaseAmnt,
                                   OwnCAmnt :  Double;
                               Var CalcVar,
                                   CalcSet  :  Double;
                                   OwnCurrencyPPD : Double = 0.0;
                                   BasePPD : Double = 0.0)  :  Boolean;

    Procedure ReStateOS(AllocCtrl  :  MLocRec;
                        EInv       :  InvRec);

    Procedure SetDiscount(Mode  :  Byte);

    procedure ShowPPDAllocationMenu(OSValue : Double; PPDValue : Double);
    procedure PrepareTakePPD;
    function ExecuteTakePPD : Boolean;
  end;


Procedure Set_AIFormMode(State  :  Boolean);



{~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~}

Implementation

{~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~}


Uses
  {$IFDEF DBD}
    DebugU,
  {$ENDIF}

  ETStrU,
  ETMiscU,
  ETDateU,
  BtrvU2,
  BTSupU2,
  BTSupU3,
  BTKeys1U,
  BTSFrmU1,
  CmpCtrlU,
  ColCtrlU,
  ComnUnit,
  ComnU2,
  CurrncyU,
  CLPALU,

  {$IFDEF GF}
    FindCtlU,
  {$ENDIF}

  ExThrd2U,

  {$IFDEF CL_On}
    LedgSupU,
  {$ENDIF}

  {$IFDEF MC_On}
    LedCuU,
  {$ENDIF}

  {$IFDEF POST}
    PostingU,

  {$ENDIF}


  BPyItemU,

  MatchU,
  LedgSu2U,
  DocSupU1,
  InvListU,
  SysU1,
  SysU2,
  Tranl1U,
  PWarnU,
  GenWarnU,
  AllcWrnU,
  APIUtil,
  SalTxl1U,

  {$IFDEF RP}
    RepAlcU,
  {$ENDIF}

  {$IFDEF CU}
    Event1U,
  {$ENDIF}

  SQLUtils,

  BPWarnUU,
  AllocS1U,
  AllocS2U,
  AllCIP3U,

  //PR: 07/10/2013 MRD 1.1.17
  ConsumerUtils,

  // CJS 2015-02-26 - T1-009 - Allocation Wizard - remove settlement discount option for transactions > 01/04/2015
  TransactionHelperU,

  PromptPaymentDiscountFuncs, StrUtils, oSystemSEtup, AllocSettleWarningDialog, EntWindowSettings,

  MiscU;




{$R *.DFM}

Var
  AIFormMode  :  Boolean;

  //PR: 10/06/2015
  WindowSettings: IWindowSettings;


{ ========= Exported function to set View type b4 form is created ========= }

Procedure Set_AIFormMode(State  :  Boolean);

Begin

  AIFormMode:=State;

end;


{$I AITI1U.PAS}





{ ====================================== Form Methods ===================================== }
{ ========================================================================================= }


Procedure  TAllocItems.SetNeedCUpdate(B  :  Boolean);

Begin
  If (Not fNeedCUpdate) then
    fNeedCUpdate:=B;
end;

procedure TAllocItems.Find_FormCoord;
Begin
  //PR: 10/06/2015 ABSEXCH-16529 Change to use new settings sub-system
  WindowSettings.LoadSettings;
  WindowSettings.SettingsToWindow(self);
  WindowSettings.SettingsToParent(MULCtrlO);

  fNeedCUpdate := False;

  StartSize.X := Self.Width;
  StartSize.Y := Self.Height;
end;


procedure TAllocItems.Store_FormCoord(UpMode  :  Boolean);
Begin
  //PR: 10/06/2015 ABSEXCH-16529 Change to use new settings sub-system
  WindowSettings.WindowToSettings(self);
  WindowSettings.ParentToSettings(MULCtrlO,MULCtrlO);
  WindowSettings.SaveSettings(StoreCoord);
end;



procedure TAllocItems.FormSetOfSet;

Begin
  PagePoint[0].X:=ClientWidth-(CBtnPanel.Left);
  PagePoint[0].Y:=ClientHeight-(CBtnPanel.Height);

  PagePoint[1].X:=ClientWidth-(CSBox.Width);
  PagePoint[1].Y:=ClientHeight-(CSBox.Height);

  PagePoint[3].X:=CBtnPanel.Height-(CCBSBox.Height);
  PagePoint[3].Y:=CSBox.ClientHeight-(CLORefPanel.Height);

  PagePoint[4].Y:=CBtnPanel.Height-(CListBtnPanel.Height);
  PagePoint[4].X:=TotPanel.Top-(CSBox.Top+CSBox.Height);
  PagePoint[5].X:=CBtnPanel.Left-TotPanel.Width;


  GotCoord:=BOn;

end;


{ ======= Link to Trans display ======== }

procedure TAllocItems.Display_Trans(Mode        :  Byte;
                                    GlobalMode  :  Boolean;
                                    ViewOnly    :  Boolean);

Var
  DispTrans  :  TFInvDisplay;
  KeyInv     :  Str255;
  DisplayOptions : TransactionDisplayOptionsSet;
Begin

  If (DispTransPtr=nil) or (GlobalMode) then
  Begin
    If (GlobalMode) then
      DispTrans:=TFInvDisplay.Create(Application.MainForm)
    else
    Begin
      DispTrans:=TFInvDisplay.Create(Self);
      DispTransPtr:=DispTrans;
    end;
  end
  else
    DispTrans:=DispTransPtr;

    try

      ExLocal.AssignFromGlobal(InvF);

      With ExLocal,DispTrans do
      Begin
        LastDocHed:=LInv.InvDocHed;

        If (LInv.Settled=0.0) then
        Begin
          KeyInv:=LInv.OurRef;

          Find_Rec(B_GetEq,F[InvF],InvF,RecPtr[InvF]^,InvOurRefK,KeyInv);
        end;

        if RestrictedEditOnly(Inv) and not ViewOnly then
          DisplayOptions := [GDPR_AllowPostedEdit]
        else
          DisplayOptions := [];


        If ((LastFolio<>LInv.FolioNum) or (Mode<>100)) and ((InHBeen) or (GlobalMode)) then
          {Display_Trans(Mode,LInv.FolioNum,BOff,(Mode<>100));}
          Display_Trans(100-(98*Ord(LInv.Settled=0.0)),LInv.FolioNum,BOff,BOff, DisplayOptions);

      end; {with..}

    except
      DispTransPtr:=nil;
      DispTrans.Free;

    end;

end;



{ ======= Reset Trans display ======== }

procedure TAllocItems.Reset_Trans;

Var
  DispTrans  :  TFInvDisplay;
Begin

  If (DispTransPtr<>nil) then
  Begin
    DispTrans:=DispTransPtr;

    try
      With DispTrans do
        LastFolio:=0;

    except
      DispTransPtr:=nil;
      DispTrans.Free;

    end;
  end; {If..}
end;




Function TAllocItems.ScanMode  :  Boolean;

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



Procedure TAllocItems.WMCustGetRec(Var Message  :  TMessage);

Var
  IMode  :  SmallInt;
  KeyI   :  Str255;

Begin
  KeyI:='';

  With Message do
  Begin

    {If (Debug) then
      DebugForm.Add('Mesage Flg'+IntToStr(WParam));}

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

              If (GetInv(MiscRecs^.AllocSRec.ariOurRef)) then
                Display_Trans(2+(98*IMode),BOff, False);

            end;

      2  :  ShowRightMeny(LParamLo,LParamHi,1);

      18 :  Begin
              Reset_Trans;

            end;

      25 :  NeedCUpdate:=BOn;

      55,56
          :  Begin

               Set_BackThreadMVisible(BOn);

               Begin
                 SetButtons(BOn);

                 Enabled:=BOn;

                 Self.BringtoFront;

                 RefreshList(BOn,BOn);

                 Link2Tot;

                 InSettleBtn:=BOff;
               end;

               Set_BackThreadMVisible(BOff);

             end; {Start List}

      65,66
          :  Begin {Lock and un lock ctrl during scan}

               If (Assigned(MULCtrlO)) then
                 Alloc_CtrlPut(MLocF,MLK,MULCtrlO.AllocCtrl,Nil,Ord(WParam=66));

             end;

      67  :  Begin
               Set_BackThreadMVisible(BOn);

               //PR: 18/01/2011 After running the allocation wizard (whic uses  a ClientID) we need to refresh
               //the main cache otherwise changes won't be picked up. ABSEXCH-10724
               if SQLUtils.UsingSQL then
                 SQLUtils.DiscardCachedData(SetDrive + Filenames[InvF], nil);

               If (LParam=1) then
               Begin
                 Display_Trans(100,BOn, True);

                 {* Establish local position *}
                 KeyI:=Inv.OurRef;

                 Find_Rec(B_GetEq,F[InvF],InvF,RecPtr[InvF]^,InvOurRefK,KeyI);
                 // PS 19/05/2016 2016-R2 ABSEXCH-17476: Function to validate Document is in Auto print list
                 If (not ExLocal.LastEdit) and (Check_AutoPrint(ExLocal.LInv))  then {* Auto print *}
                 Begin
                   With ExLocal.LInv do
                   begin
                      Control_DefProcess(DEFDEFMode[InvDocHed],
                                 IdetailF,IdFolioK,
                                 FullNomKey(FolioNum),ExLocal,BOn);
                   end;
                 end;

                 If (Copy(Self.Owner.Name,1,6)='Daybk1') then {Refresh list}
                   PostMessage(TForm(Self.Owner).Handle,WM_CustGetRec,100,0);

                 {$IFDEF CU} {* Call any post store hooks here *}

                   {ExLocal.AssignFromGlobal(InvF);

                   GenHooks(2000,170,ExLocal);}  {* v5.61. moved to inside thread to avoid thread safe operation *}

                 {$ENDIF}

               end
               else
               Begin
                 If (Copy(Self.Owner.Name,1,8)='CustRec3') then
                   PostMessage(TForm(Self.Owner).Handle,WM_CustGetRec,121,0);

               end;

               fFinishedOk:=BOn;

               InProcessBtn:=BOff;

               // MH 15/10/2010 v6.5 ABSEXCH-9914: Prevent user closing the window whilst the process is running
               ClsCP1Btn.Enabled := True;

               Set_BackThreadMVisible(BOff);

               UpdateCS:=Not MULCtrlO.AllocCtrl.AllocCRec.arcFromTrans;

               PostMessage(Self.Handle,WM_Close,0,0);


             end;

      88  :  Begin {Start up process after ok from check}
               {AddAllocScan2Thread(Application.MainForm,MULCtrlO.AllocCtrl,Self.Handle,1);}
               InProcessBtn:=BOff;

             end;

      91,92
          :  Begin
               InSplitPay:=BOff;

               If (WParam=92) then
               Begin
                 If (Assigned(MULCtrlO)) then
                   Alloc_CtrlPut(MLocF,MLK,MULCtrlO.AllocCtrl,Nil,1);
               end;
             end;

      116
          :  Begin
               With MULCtrlO do
               Begin
                 AddNewRow(MUListBoxes[0].Row,(LParam=1));
               end;
            end;

      117 :  With MULCtrlO do
             Begin
               If (MUListBox1.Row<>0) then
                 PageUpDn(0,BOn)
                else
                  InitPage;
             end;

      177  :  Begin
                PrimeButtons(BOn);

              end;

      200   :  DispTransPtr:=nil;

      //PR: 09/07/2015 TakePPD after Invoices allocated and SRC/PPY created
      201   :  if FTakePPD then
                 ExecuteTakePPD;

    {$IFDEF GF}

      3002
            : If (Assigned(FindCust)) then
                With MULCtrlO,FindCust,ReturnCtrl do
                Begin
                  InFindLoop:=BOn;

                  Find_OnList(SearchMode,SearchKey);

                  With MUListBoxes[0] do
                  Begin
                    If (CanFocus) then
                      SetFocus;

                    GetSelRec(BOn);
                  end;

                  InFindLoop:=BOff;
                end;

    {$ENDIF}




    end; {Case..}

  end;
  Inherited;
end;


Procedure TAllocItems.WMFormCloseMsg(Var Message  :  TMessage);


Begin

  With Message do
  Begin

    Case WParam of

      {0,1 Reserved for posting notification - not sure why?}

      44 :  Begin
              MatchFormPtr:=nil;
            end;

    end; {Case..}

  end;

  Inherited;
end;


{ == Procedure to Send Message to Get Record == }

Procedure TAllocItems.Send_UpdateList(Mode   :  Integer);

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
    LParam:=0;
  end;

  With Message1 do
    MessResult:=SendMessage((Owner as TForm).Handle,Msg,WParam,LParam);

end; {Proc..}


Procedure TAllocItems.WMGetMinMaxInfo(Var Message  :  TWMGetMinMaxInfo);

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

procedure TAllocItems.SetCaption;

Var
  LevelStr  :  Str255;

  //PR: 07/10/2013 MRD 1.1.17
  sCustCode : string;
Begin

 //PR: 07/10/2013 MRD 1.1.17 Set acCode to appropriate for consumer/customer
 if IsConsumer(ExLocal.LCust) then
   sCustCode := ExLocal.LCust.acLongACCode
 else
   sCustCode := ExLocal.LCust.CustCode;


 With ExLocal.LCust do
    Caption:='Allocation list for '+dbFormatName(sCustCode,Company)+'. ';

  If (Assigned(MULCtrlO)) then
  With MULCtrlO.AllocCtrl.AllocCRec do
  Begin

    If (arcAutoTotal) then
      AutoLab.Caption:='Automatic Total.';

    DDownTitle:=DocNames[DocSplit[arcSalesMode,2]];
  end;

  FormDesign;   
end;



procedure TAllocItems.FormDesign;


begin
  If Assigned(MULCtrlO) then
  With MULCtrlO,AllocCtrl.AllocCRec do
  Begin
    
    Begin

      {$IFDEF MC_On}

        VisiList.SetHidePanel(7,(arcPayCurr=1),BOff);   {If base we do not need base o/s}

        VisiList.SetHidePanel(8,(arcPayCurr=arcInvCurr),BOn);   {own curr o/s, as o/s will be in own curr}

        {
        Sanjay Sonani
        Jira : ABSEXCH-16866 : Issue on re-sizing columns on Allocation wizard issue
               with columns not being set correctly where two columns appear incorrect

        Cause : Issue is raised due to the method FormDesign that override the columns
                position when the Allocation form is open first time.
        }

        LockWindowUpdate(Handle);
        try
          RefreshAllCols;
        finally
          LockWindowUpdate(0);
        end;
      {$ENDIF}
    end;



    {$IFNDEF MC_On}
      VarTotF.Visible:=BOff;  Label84.Visible:=BOff;
      DocCF.Visible:=BOff; UnAlCF.Visible:=BOff;
      CBalCF.Visible:=BOff; SDiscCF.Visible:=BOff;

    {$ENDIF}

    OriginalTotal:=AllocCheckSum;

    PrimeButtons(BOff);

    //PR: 13/08/2015 ABSEXCH-16754 Set PPD flag from stored record
    FTakePPD := arcUsePPD;

  end;

end;


Procedure TAllocItems.SetButtons(State  :  Boolean);


Begin
  CustBtnList.SetEnabBtn(State);

  GenCP1Btn.Enabled:=State;
end;

procedure TAllocItems.PrimeButtons(PWRef   :  Boolean);
Var
  HideAge,
  HideSetl  :  Boolean;

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

    {$IFNDEF MC_On}
      HideAge:=BOn;
    {$ELSE}
      HideAge:=(MULCtrlO.AllocCtrl.AllocCRec.arcInvCurr<>0);
    {$ENDIF}

    If (Assigned(MULCtrlO)) then
      HideSetl:=MULCtrlO.AllocCtrl.AllocCRec.arcAutoTotal
    else
      HideSetl:=BOff;

    try

      With CustBtnList,MULCtrlO.AllocCtrl.AllocCRec do
        Begin
          {01} AddVisiRec(ALCP1Btn,BOff);

          {02} AddVisiRec(PACP1Btn,BOff);

          {03} AddVisiRec(UACP1Btn,BOff);
          {04} AddVisiRec(SDiscBtn,arcFromTrans or Not ChkAllowed_In(264+Ord(arcSalesMode)));
          {05} AddVisiRec(FindCP1Btn,BOff);
          {06} AddVisiRec(MACP1Btn,BOff);

          {07} AddVisiRec(SetCP1Btn,HideSetl or Not ChkAllowed_In(282-Ord(arcSalesMode)));

          {08} AddVisiRec(DelCP1Btn,BOff);
          {09} AddVisiRec(ViewCP1Btn,BOff);
          {10} AddVisiRec(CurCP1Btn,HideAge);

          {11} AddVisiRec(PrintCP1Btn,BOff);
          {12} AddVisiRec(SetSplitBtn,(arcAutoTotal) or (arcFromTrans) or (arcTransValue=0.0));
          {13} AddVisiRec(ChkCP1Btn,BOff);
          {14} AddVisiRec(CalcCP1Btn,BOff);


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

  //PR: 14/03/2015 ABSEXCH-16284 v7.0.14 Only enable write-off if write off gl is set
  SDiscBtn.Enabled := SystemSetup.ControlCodes.ssSettlementWriteOffCtrlGL <> 0;

end;



procedure TAllocItems.RefreshList(ShowLines,
                               IgMsg      :  Boolean);

Var
  KeyStart    :  Str255;
  LKeypath,
  LKeyLen     :  Integer;

Begin

  With MULCtrlO,AllocCtrl.AllocCRec do
  Begin
    KeyStart:=PartCCKey(MBACSCode,MBACSALSub)+TradeCode[arcSalesMode]+arcCustCode;

    LKeypath:=MIK;


    LKeyLen:=Length(KeyStart);



    IgnoreMsg:=IgMsg;

    StartList(MiscF,LKeypath,KeyStart,'','',LKeyLen,(Not ShowLines));

    IgnoreMsg:=BOff;
  end;

end;



procedure TAllocItems.FormBuildList(ShowLines  :  Boolean);

Var
  StartPanel  :  TSBSPanel;
  n           :  Byte;



Begin
  MULCtrlO:=TAPMList.Create(Self);
  MulCtrlO.Name := 'APMList1';

  Try

    With MULCtrlO do
    Begin


      Try

        With VisiList do
        Begin
     {0}  AddVisiRec(CLORefPanel,CLORefLab);
     {1}  AddVisiRec(CLYRefPanel,CLYRefLab);
     {2}  AddVisiRec(CLDuePanel,CLDueLab);
     {3}  AddVisiRec(CLOSPanel,CLOSLab);
     {4}  AddVisiRec(CLAMTPanel,CLAMTLab);
     {5}  AddVisiRec(CLSetCurrPanel,CLSetCLab);
     {6}  AddVisiRec(CLVarPanel,CLVarLab);
     {7}  AddVisiRec(CLOSBPanel,CLOSBLab);
     {8}  AddVisiRec(CLOSCPanel,CLOSCLab);
     {9}  AddVisiRec(CLStatPanel,CLStatLab);
     {10} AddVisiRec(CLDatePanel,CLDateLab);

     //PR: 08/05/2015  ABSEXCH-16284 v7.0.14 T2-147 Add PPD Fields
     {11} AddVisiRec(panPPDAvailable, panPPDAvailableHed);
     {12} AddVisiRec(panTotWithPPD, panTotWithPPDHed);
     {13} AddVisiRec(panPPDExpiry, panPPDExpiryHed);
     {14} AddVisiRec(panPPDStatus, panPPDStatusHed);

          VisiRec:=List[0];

          StartPanel:=(VisiRec^.PanelObj as TSBSPanel);

          {$IFNDEF MC_On}
            SetHidePanel(5,BOn,BOff);  {Settle own}
            SetHidePanel(6,BOn,BOff);  {Variance}
            SetHidePanel(7,BOn,BOff);  {base o/s}
            SetHidePanel(8,BOn,BOn);   {own curr o/s}


          {$ENDIF}

          //PR: 08/05/2015  ABSEXCH-16284 v7.0.14 T2-147 Show/hide PPD Fields as required
          SetHidePanel(11, Cust.acPPDMode = pmPPDDisabled, False);
          SetHidePanel(12, Cust.acPPDMode = pmPPDDisabled, False);
          SetHidePanel(13, Cust.acPPDMode = pmPPDDisabled, False);
          SetHidePanel(14, Cust.acPPDMode = pmPPDDisabled, False);

          LabHedPanel:=CHedPanel;

          ListOfSet:=10;

          SetHedPanel(ListOfSet);

        end;
      except
        VisiList.Free;

      end;


      TabOrder := -1;
      TabStop:=BOff;
      Visible:=BOff;
      BevelOuter := bvNone;
      ParentColor := False;
      Color:=StartPanel.Color;

      //PR: 08/05/2015  ABSEXCH-16284 v7.0.14 T2-147 Update column count
      MUTotCols:=14;
      Font:=StartPanel.Font;

      LinkOtherDisp:=BOff;

      WM_ListGetRec:=WM_CustGetRec;


      Parent:=StartPanel.Parent;

      MessHandle:=Self.Handle;

      For n:=0 to MUTotCols do
      With ColAppear^[n] do
      Begin
        AltDefault:=BOn;

        //PR: 08/05/2015  ABSEXCH-16284 v7.0.14 T2-147 Add PPD float columns so they get formatted correctly
        If (n In [3..8, 11..12]) then
        Begin
          DispFormat:=SGFloat;
          NoDecPlaces:=2;
        end;
      end;

      ListLocal:=@ExLocal;

      ListCreate;

      UseSet4End:=BOff;

      NoUpCaseCheck:=BOn;

      HighLiteStyle[1]:=[fsBold];
      HighLiteStyle[2]:=[fsUnderLine];
      HighLiteStyle[3]:=[fsBold,fsUnderLine];


      Set_Buttons(CListBtnPanel);

      {ReFreshList(ShowLines,BOff);}

    end {With}


  Except

    MULCtrlO.Free;
    MULCtrlO:=Nil;
  end;



  FormSetOfSet;

  Find_FormCoord;
  FormReSize(Self);

  Link2Tot;
  {RefreshList(BOn,BOn);}

end;


procedure TAllocItems.FormCreate(Sender: TObject);

Var
  n  :  Integer;

begin
  //PR: 10/06/2015 ABSEXCH-16529 Change to use new settings sub-system
  WindowSettings := EntWindowSettings.GetWindowSettings(self.Name);

  fDoingClose:=BOff;
  ExLocal.Create;

  fFrmClosing:=BOff;

  fFinishedOK:=BOff;

  LastCoord:=BOff;

  NeedCUpdate:=BOff;

  JustCreated:=BOn;

  InProcessBtn:=BOff;
  InSettleBtn:=BOff;

  InSplitPay:=BOff;

  OriginalTotal:=0.0;

  InitSize.Y:=327;
  InitSize.X:=723;

  Self.ClientHeight:=InitSize.Y;
  Self.ClientWidth:=InitSize.X;

  {Height:=244;
  Width:=370;}

  InHBeen:=BOff;

  DispTransPtr:=nil;

  MatchFormPtr:=nil;

  BeenIn:=BOff;

  ColTagged:=BOff;

  UpdateCS:=BOff;

  RecMode:=AIFormMode;

  LastSValue:='';

  MDI_SetFormCoord(TForm(Self));

  For n:=0 to Pred(ComponentCount) do
    If (Components[n] is TScrollBox) then
    With TScrollBox(Components[n]) do
    Begin
      VertScrollBar.Position:=0;
      HorzScrollBar.Position:=0;
    end;

  VertScrollBar.Position:=0;
  HorzScrollBar.Position:=0;


  DDownTitle:='';


  FormBuildList(BOff);

  SetHelpContextIDs; // NF: 11/05/06 Fix for incorrect Context IDs

  FTakePPD := False;
  TakePPDI := GetTakePPD;
  
end;



procedure TAllocItems.FormDestroy(Sender: TObject);

Var
  n  :  Byte;
begin
  TakePPDI := nil;

  ExLocal.Destroy;

 end;

{ == Function to caluclate checksum of changes == }

Function TAllocItems.AllocCheckSum  :  Double;

Begin
  Result:=0;

  If (Assigned(MULCtrlO)) then
  With MULCtrlO.AllocCtrl.AllocCRec do
  Begin
    Result:=Round_Up(arcTransValue+arcTotal+arcVariance+arcSettleD,2);

  end;

end;

procedure TAllocItems.FormCloseQuery(Sender: TObject;
                              var CanClose: Boolean);
Var
  n  : Integer;
  GenStr : String;
begin
  // MH 15/10/2010 v6.5 ABSEXCH-9914: Prevent user closing the window whilst the process is running
  If ClsCP1Btn.Enabled Then
  Begin
    If (Not fFrmClosing) then
    Begin
      fFrmClosing:=BOn;

      If (AllocChecksum<>OriginalTotal) and (Not fFinishedOK) then {Warn closing}
      Begin
        GenStr:='You are about to close this screen without finalising the allocation.'+#13+
                             'The allocation details will be kept safe under this account code so you'+
                             ' can retrieve it later.';


        {$IFDEF MC_On}
          GenStr:=GenStr+'  However, should a revaluation occur prior to processing this transaction, the allocation details will be lost.';

        {$ENDIF}

        GenStr:=GenStr+#13+#13+'Please confirm you wish to close this screen?';

        CanClose:=(CustomDlg(Application.MainForm,'Please Confirm','Closing Allocation screen.',
                             GenStr,
                             mtConfirmation,
                             [mbYes,mbNo])=mrOK);

      end;

      If (CanClose) then
      Begin
        //PR: 13/08/2015 ABSEXCH-16754 Store take ppd flag
        MULCtrlO.AllocCtrl.AllocCRec.arcUsePPD := FTakePPD;

        If (Assigned(MULCtrlO)) and (Not fFinishedOk) then {* Unlock ctrl record *}
          Alloc_CtrlPut(MLocF,MLK,MulCtrlO.AllocCtrl,nil,0);


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


        {$IFDEF Post}
          If (UpdateCS) and (Syss.LiveCredS) then {* Update Credit status Flg customers only *}
          Begin
            UpdateCS:=BOff;

            AddChkCAlloc2Thread(Self.Owner,ExLocal.LCust.CustCode);
          end;

        {$ENDIF}


        Send_UpdateList(70);
        //HV 14/03/2017 2017-R1 ABSEXCH-17696: Exception Log - Crash Closing Stock Record,
        //For this fix, While closing Allocation List, it will properly destroy the child screens before allocation list window.
        GenCanClose(Self,Sender,CanClose,BOn);
        {* This check was placed here in v4.31 as if this screen had an item tagged whilst this
          screen & the main BP list were maximized, a major GPF occured *}

        If (WindowState=wsMaximized) then
          WindowState:=wsNormal;
      end;

      fFrmClosing:=BOff;
    end;
  End // If ClsCP1Btn.Enabled
  Else
    CanClose := False;
end;

procedure TAllocItems.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  If (Not fDoingClose) then
  Begin
    fDoingClose:=BOn;

    Action:=caFree;

    If (MULCtrlO<>nil) then
    Begin
      try
        MULCtrlO.Destroy;
      finally
        MULCtrlO:=nil;
        //PR: 10/06/2015 ABSEXCH-16529 Change to use new settings sub-system
        WindowSettings := NIL;
      end;
    end;

  end;
end;


procedure TAllocItems.FormResize(Sender: TObject);
Var
  n           :  Byte;
  NewVal      :  Integer;


begin

  If (GotCoord) then
  Begin

    CBtnPanel.Left:=ClientWidth-PagePoint[0].X;

    CBtnPanel.Height:=ClientHeight-PagePoint[0].Y;


    CSBox.Width:=ClientWidth-PagePoint[1].X;
    CSBox.Height:=ClientHeight-PagePoint[1].Y;

    CCBSBox.Height:=CBtnPanel.Height-PagePoint[3].X;

    CListBtnPanel.Height:=CBtnPanel.Height-PagePoint[4].Y;
    CListBtnPanel.Left:=Pred(CBtnPanel.Left-CListBtnPanel.Width);
    TotPanel.Top:=(CSBox.Top+CSBox.Height+PagePoint[4].X);
    TotPanel.Width:=CBtnPanel.Left-PagePoint[5].X;


    If (MULCtrlO<>nil) then
    Begin
      LockWindowUpDate(Handle);

      With MULCtrlO,VisiList do
      Begin
        VisiRec:=List[0];

        With (VisiRec^.PanelObj as TSBSPanel) do
          Height:=CSBox.ClientHeight-PagePoint[3].Y;

        RefreshAllCols;
      end;

      LockWindowUpDate(0);

      MULCtrlO.ReFresh_Buttons;

    end;{Loop..}

    MULCtrlO.LinkOtherDisp:=BOn;

    NeedCUpdate:=((StartSize.X<>Width) or (StartSize.Y<>Height));

  end; {If time to update}
end;





procedure TAllocItems.SetFormProperties;


Begin
  if Assigned(WindowSettings) then
    if WindowSettings.Edit(MULCtrlO, MULCtrlO) = mrOK then
      NeedCUpdate := True;
end;

procedure TAllocItems.ShowRightMeny(X,Y,Mode  :  Integer);

Begin
  With PopUpMenu1 do
  Begin

    PopUp(X,Y);
  end;


end;


procedure TAllocItems.PopupMenu1Popup(Sender: TObject);

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



procedure TAllocItems.PropFlgClick(Sender: TObject);
begin
  SetFormProperties;
end;

procedure TAllocItems.StoreCoordFlgClick(Sender: TObject);
begin
  StoreCoord:=Not StoreCoord;
  NeedCUpdate:=BOn;
end;





procedure TAllocItems.ClsCP1BtnClick(Sender: TObject);
begin
  Close;
end;


procedure TAllocItems.CLORefPanelMouseUp(Sender: TObject;
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

    BarPos:=CSBox.HorzScrollBar.Position;

    If (PanRsized) then
      MULCtrlO.ResizeAllCols(MULCtrlO.VisiList.FindxHandle(Sender),BarPos);

    MULCtrlO.FinishColMove(BarPos+(ListOfset*Ord(PanRSized)),PanRsized);

    NeedCUpdate:=(MULCtrlO.VisiList.MovingLab or PanRSized);

  end;

end;


procedure TAllocItems.CLORefLabMouseMove(Sender: TObject; Shift: TShiftState;
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


procedure TAllocItems.CLORefLabMouseDown(Sender: TObject;
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




procedure TAllocItems.FormActivate(Sender: TObject);
begin
  If (Assigned(MULCtrlO))  then
    MULCtrlO.SetListFocus;

end;

procedure TAllocItems.Link2Tot;

Var
  n    :  Byte;
  COrd :  Integer;

  Dnum,
  Unall:  Double;

Begin
  Dnum:=0.0;  Unall:=0.0;

  With MulCtrlO.AllocCtrl.AllocCRec do
  Begin
    With CBalF do
    Begin
      {$IFDEF MC_On}
        CurrencySymb:=SSymb(0);

      {$ELSE}
        ShowCurrency:=BOff;
      {$ENDIF}

      Value:=ExLocal.LCust.Balance;
    end;

    {$IFDEF MC_On}
        DocTotF.CurrencySymb:=SSymb(0);

    {$ELSE}
      DocTotF.ShowCurrency:=BOff;
    {$ENDIF}

      DocTotF.Value:=arcTransValue;

    {$IFDEF MC_On}
        UnalTotF.CurrencySymb:=SSymb(0);
    {$ELSE}
      UnalTotF.ShowCurrency:=BOff;
    {$ENDIF}

    Unall:=Round_up(Calc_arcUnallocated(MulCtrlO.AllocCtrl,BOff),2);

    UnalTotF.Value:=Unall;

    {$IFDEF MC_On}
      VarTotF.CurrencySymb:=SSymb(0);
    {$ELSE}
      VarTotF.ShowCurrency:=BOff;
    {$ENDIF}

    VarTotF.Value:=arcVariance;

    {$IFDEF MC_On}
        SDiscTotF.CurrencySymb:=SSymb(0);

    {$ELSE}
      SDiscTotF.ShowCurrency:=BOff;
    {$ENDIF}

    SDiscTotF.Value:=arcSettleD;

    With CBalCF do
    Begin
      {$IFDEF MC_On}
        CurrencySymb:=SSymb(arcPayCurr);

      {$ELSE}
        ShowCurrency:=BOff;
      {$ENDIF}

      Value:=Currency_ConvFT(ExLocal.LCust.Balance,0,arcPayCurr,UseCoDayRate);

    end;

    With DocCF do
    Begin
      {$IFDEF MC_On}
        CurrencySymb:=SSymb(arcPayCurr);

      {$ELSE}
        ShowCurrency:=BOff;
      {$ENDIF}

      Value:=arcOwnTransValue;

    end;

    With UnAlCF do
    Begin
      {$IFDEF MC_On}
        CurrencySymb:=SSymb(arcPayCurr);

      {$ELSE}
        ShowCurrency:=BOff;
      {$ENDIF}

      Dnum:=Calc_arcUnallocated(MulCtrlO.AllocCtrl,BOn);

      Value:=1E-6;

      If {(Dnum>0.0) or} (Unall<>0.0) or SBSIn then
        Value:=Dnum
      else
        Value:=0.0;

    end;

    With SDiscCF do
    Begin
      {$IFDEF MC_On}
        CurrencySymb:=SSymb(arcPayCurr);

      {$ELSE}
        ShowCurrency:=BOff;
      {$ENDIF}

      Value:=arcOwnSettleD;

    end;



  end; {With..}

end;



procedure TAllocItems.FindCP1BtnClick(Sender: TObject);
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
        LParam:=0;
        Msg:=WM_CustGetRec;
        DisplayxParent:=BOn;
        ShowOnly:=BOn;
        Pass2Parent:=BOn;

        //PR: 04/12/2013 ABSEXCH-14824
        Ctrl_GlobalFind(Self, ReturnCtrl, tabFindDocument);

      end;
    end; {If in list find..}

  {$ENDIF}
end;







procedure TAllocItems.AddCP1BtnClick(Sender: TObject);

Var
  BColNo   :  SmallInt;
  TagMode,
  POk      :  Boolean;

begin
  If (MULCtrlO.ValidLine) then
  With ExLocal,LMiscRecs^.AllocSRec, MULCtrlO.AllocCtrl.AllocCRec,Inv do
  Begin

    LSetDataRecOfs(MiscF,LastRecAddr[MiscF]); {* Retrieve record by address Preserve position *}

    Status:=GetDirect(F[MiscF],MiscF,LRecPtr[MiscF]^,MIK,0); {* Re-Establish Position *}

  end;
end;

procedure TAllocItems.PAllocBtnClick(Sender: TObject);

Var
  BColNo   :  SmallInt;

begin

end;


Function TAllocItems.GetInv(ORef  :  Str10)  :  Boolean;

Const
  Fnum    =  InvF;
  Keypath =  InvOurRefK;

Var
  KeyS      :  Str255;
  GStatus   :  Integer;

Begin
  KeyS:=ORef;

  With ExLocal do
  If (LInv.OurRef<>ORef) then
  Begin
    GStatus:=Find_Rec(B_GetEq,F[Fnum],Fnum,LRecPtr[Fnum]^,KeyPath,KeyS);

    If (GStatus=0) then
      AssignToGlobal(Fnum);
  end
  else
    GStatus:=0;

  Result:=(GStatus=0);

end;


{ ============================ Allocation Control methods ========================== }


{ ============ Allocate Documents ============ }

Procedure TAllocItems.Allocate(AlMode  :  Byte; TakePPD : Boolean = False);


Var
  UOR     :  Byte;

  AlCnst  :  Integer;

  ForceORate,
  Ok2Store:  Boolean;

  BlankAlloc,
  OldAlloc,
  TmpAlloc:  MiscRec;

  AddThen,
  AddNow,
  OwnPartS,
  AddOwnC :  Real;

  EInv    :  InvRec;

  KeyS    :  Str255;

  TmpGlobAlloc
          :  ^GlobAllocAry;

  PPDAvailable : Double;
  PPDAvailableBase : Double;

  OK2Continue : Boolean;
  PartAllocationMode : Byte;

{ Replicated in AllocS2U }

Procedure  ReapplySDisc;

Begin
  With ExLocal, LMiscRecs^.AllocSRec do
  Begin

    ariOrigSetDisc:=ariOrigSetDisc-ariOwnDiscOR;

    LInv.BDiscount:=ariOrigSetDisc;

    AllocForceInvSDisc(LInv,EInv,MULCtrlO.AllocCtrl,1);

    ReStateOS(MULCtrlO.AllocCtrl,EInv);
  end; {With..}


end;

Begin
  KeyS:=''; Ok2Store:=BOff;

  AddThen:=0.0; AddNow:=0.0; AddOwnC:=0.0;  OwnPartS:=0.0;

  UOR:=0;

  New(TmpGlobAlloc);

  TmpGlobAlloc^:=GlobalAllocRec^;

  Blank(GlobalAllocRec^,Sizeof(GlobalAllocRec^));

  Blank(BlankAlloc,Sizeof(BlankAlloc));

  ForceORate:=BOff;

  With MULCtrlO,ExLocal,LInv do
  Begin
    LGetRecAddr(ScanFileNum);

    Ok:=LGetMultiRec(B_GetDirect,B_MultLock,KeyS,KeyPAth,ScanFileNum,BOff,GlobLocked);


    If (Ok) and (GlobLocked) then
    With AllocCtrl.AllocCRec, LMiscRecs^.AllocSRec do
    Begin
      AlCnst:=1;

      {$IFDEF CU}
        ForceORate:=(UseCoDayRate and ((Not EnableCustBtns(2000,200)) or (arcPayCurr<>Currency) or (AlMode=3))); {*EL v6.01 Force behavior of part allocation to use Invoice exchange rate*}
      {$ELSE}
        ForceORate:=UseCoDayRate;
      {$ENDIF}

      //PR: 13/05/2015 ABSEXCH-16284
      //PR: 12/06/2015 ABSEXCH-16545 Remove date check - need to allow expired ppd
      //PR: 16/06/2016 ABSEXCH-16550 Removed ptPPDNotTaken check as taken Manual PCR PPD can be taken into account.
      if TakePPD then
      begin
        //PR: 22/09/2015 ABSEXCH-16897 Only set FTakePPD here if full allocation. Set below for part allocations
        if AlMode = 3 then
          FTakePPD := TakePPD;
        PPDAvailable := Round_Up(ExLocal.LInv.thPPDGoodsValue + ExLocal.LInv.thPPDVATValue, 2);

        {$IFDEF MC_ON}
        UOR:=fxUseORate(UseCoDayRate,BOn,CXRate,UseORate,Currency,0);
        PPDAvailableBase := Round_Up(Conv_TCurr(PPDAvailable,XRate(CXRate,ForceORate,Currency),Currency,UOR,False), 2);
        {$ELSE}

        PPDAvailableBase := PPDAvailable;
      {$ENDIF}
      end
      else
      begin
        PPDAvailable := 0;
        PPDAvailableBase := 0;
      end;

      OldAlloc:=LMiscRecs^;  Ok2Store:=BOn;

      {Put any exitising allocations back}

      UpdateAllocCRec(OldAlloc,BlankAlloc,AllocCtrl,Nil);

      Link2Tot;

      AllocForceInvSDisc(LInv,EInv,AllocCtrl,0);


      Case AlMode of
        3,5   :  Begin
                   Begin



                     If (AlMode=5) or TakePPD then
                       With CLORefPanel do
                       Begin
                         //PR: 28/08/2015 ABSEXCH-16777 Post-PPD Write-off is stored in ariOrigSetDisc, so allow part alloc if after
                         //                             march 2015
                         If (ariOrigSetDisc=0.0) or
                         not SettlementDiscountSupportedForDate(TransDate) then {* Do not allow part allocation if settlement discount exsists *}
                         Begin
                           With GlobalAllocRec^[RecMode] do
                           Begin
                             LFullUnallocated:=Calc_arcUnallocated(MulCtrlO.AllocCtrl,BOff)*DocCnst[InvdocHed]*DocNotCnst;

                             LUnallocated:=Round_Up(LFullUnallocated,2);

                             {$IFDEF MC_On}

                               UOR:=fxUseORate(UseCoDayRate,BOn,CXRate,UseORate,Currency,0);

                               {v5.52. We are manufacturing LFullOwnUnAlloc here, but can only really do it on this basis if the payment currency matches the currency of the transaction being part allocated
                                       Otherwise we need to convert using the controlling receipts rates *}
                               If (arcPayCurr>1) then
                               Begin
                                 If (arcPayCurr=Currency) then {* Check added on matching currencies as what we are converting is the receipts unallocated value to base *}
                                                               {* Bug. Daily rate. Sin for EUR 100. @0.71 EUR inverted. SRC for 30 USD @ 1.62  Part allocate, and amount part allocated was showing as EUR 30,
                                                                  should have been EUR 26.08}
                                   LFullOwnUnAlloc:=Conv_TCurr(Calc_arcUnallocated(MulCtrlO.AllocCtrl,BOn),XRate(CXRate,UseCoDayRate{BOff},Currency),Currency,UOR,BOff)
                                                   *DocCnst[InvdocHed]*DocNotCnst
                                 else
                                   LFullOwnUnAlloc:=Conv_TCurr(Calc_arcUnallocated(MulCtrlO.AllocCtrl,BOn),XRate(arcCXRate,UseCoDayRate{BOff},arcPayCurr),arcPayCurr,UOR,BOff)
                                                   *DocCnst[InvdocHed]*DocNotCnst;
                               end
                               else
                                 LFullOwnUnAlloc:=LFullUnallocated;

                             {$ELSE}

                               LFullOwnUnAlloc:=LFullUnallocated;

                             {$ENDIF}
                           end;

                           {$IFDEF CL_On}
                             ariSettle:=PartAlloc(EInv,arcPayCurr,Color,Font,Self,AddNow,AddOwnC,Ok2Store,
                                                    TakePPD, PPDAvailableBase, AlMode = 3, ariOrigSetDisc);
                                                    
                             //PR: 22/09/2015 ABSEXCH-16897 for part allocation set FTakePPD here, on return from dialog
                             //PR: 02/12/2015 ABSEXCH-17036 Don't make FTakePPD false if it's already true
                             FTakePPD := FTakePPD or TakePPD;
                           {$ELSE}
                             ariSettle:=0.0;
                           {$ENDIF}

                           If (PayRight(LInv,AllocCtrl.AllocCRec.arcSalesMode)) then
                           Begin
                             ariSettle:=ariSettle*DocNotCnst;
                             AddOwnC:=AddOwnC*DocNotCnst;
                             AddNow:=AddNow*DocNotCnst;
                           end;

                           {$IFDEF MC_On}


                             OwnPartS:=Conv_TCurr(AddOwnC,XRate(CXRate,ForceORate{BOff},Currency),Currency,UOR,BOn);

                           {$ELSE}

                             OwnPartS:=AddOwnC;

                           {$ENDIF}

                           //Need to pass 0 rather than 1 into Calc_Variance for full alloc with ppd
                           if AlMode = 3 then
                             PartAllocationMode := 0
                           else
                             PartAllocationMode := 1;

                           {$B-}

                           OK2Continue := (Calc_Variance(PartAllocationMode,ariSettle,OwnPartS,ariVariance,ariOwnDiscOR, PPDAvailable, PPDAvailableBase));

                           If (Ok2Store) and OK2Continue then
                           Begin
                           {$B+}
                             If (ariOwnDiscOR<>0) then
                             Begin
                               ariDiscOR:=ariVariance;

                               ReApplySDisc;
                               ariSettle:=ariSettle+(ariDiscOR*DocCnst[InvDocHed]*DocNotCnst);

                               {$IFDEF MC_On}

                                 OwnPartS:=Conv_TCurr(AddOwnC,XRate(CXRate,ForceORate{BOff},Currency),Currency,UOR,BOn);

                               {$ELSE}

                                 OwnPartS:=AddOwnC;

                               {$ENDIF}

                               OwnPartS:=OwnPartS+(ariOwnDiscOR*DocCnst[InvDocHed]*DocNotCnst);

                               ariVariance:=0.0; {*Only used as a temp holder for base equiv of settlement discount *}
                             end;

                             ariSettleOwn:=OwnPartS;

                             ariSetDisc:=ariOrigSetDisc;

                             ariTagMode:=2;

                           end
                           else
                             ariSettle:=0.0;

                           If (ariSettle=ariBaseOS) then {We have part allocated the whole amount}
                           Begin
                             If (arcAutoTotal) then
                               ariReValAdj:=ariOrigReValAdj;

                           end;
                         end
                         else
                           CustomDlg(Self,'Part Allocate','Not allowed with settlement discount.',
                                           'It is not possible to part allocate a transaction if settlement discount has been applied.'+#13+
                                           'Please remove the settlement discount first, before attempting to part allocate.',
                                     mtInformation,
                                     [mbOK]);

                       end
                     else
                     {$B-}
                       If (ariTagMode<>1) and (Calc_Variance(0,ariBaseOS,ariOutStanding,ariVariance,ariOwnDiscOR,
                                                             PPDAvailable, PPDAvailableBase)) then
                     {$B+}
                       Begin
                         If (ariOwnDiscOR<>0) then
                         Begin
                           ariDiscOr:=ariVariance;
                           ariVariance:=0.0;

                           ReApplySDisc;
                         end;
                         //PR: 03/06/2015 ABSEXCH-16476 Added DocCnst[InvDocHed]*DocNotCnst to ensure correct sign
                         ariSettle:= Round_Up(ariBaseOS - (PPDAvailableBase * DocCnst[InvDocHed] * DocNotCnst), 2);

                         ariSettleOwn:= Round_Up(ariCurrOs - (PPDAvailable * DocCnst[InvDocHed] * DocNotCnst), 2);

                         ariSetDisc:=ariOrigSetDisc;

                         ariReValAdj:=ariOrigReValAdj;

                         if TakePPD then //Need to set to only part settled - tagmode 2
                           ariTagMode := 2
                         else
                           ariTagMode:=1;

                       end;

                       //PR: 13/05/2015 ABSEXCH-16284
                       if TakePPD then
                       begin
                         ariPPDStatus := 1;
                       end;
                   end;

                   AlCnst:=1;
                 end;

        4     :  Begin
                   ariSettle:=0.0;

                   ariSettleOwn:=0.0;

                   ariSetDisc:=0.0;

                   ariVariance:=0.0;

                   ariReValAdj:=0.0;

                   ariTagMode:=0;

                   If (ariOwnDiscOR<>0) then
                   Begin
                     ariOwnDiscOR:=ariOwnDiscOR*DocNotCnst;

                     ReApplySDisc;

                     ariDiscOR:=0.0; ariOwnDiscOR:=0.0;
                   end;

                   AlCnst:=-1;

                   //PR: 13/05/2015 ABSEXCH-16284 Unallocating so untake PPD
                   ariPPDStatus := 0;
                 end;
      end; {Case..}


      If (Ok2Store) then
      Begin


        If (LastRecAddr[Scanfilenum]<>0) then  {* Re-establish position prior to storing *}
        Begin

          TmpAlloc:=LMiscRecs^;

          LSetDataRecOfs(Scanfilenum,LastRecAddr[Scanfilenum]);

          Status:=GetDirect(F[Scanfilenum],Scanfilenum,LRecPtr[Scanfilenum]^,KeyPAth,0); {* Re-Establish Position *}

          LMiscRecs^:=TmpAlloc;

        end;

        Status:=Put_Rec(F[Scanfilenum],Scanfilenum,LRecptr[Scanfilenum]^,keypath);

        AssignToGlobal(ScanFileNum);

        Report_BError(ScanFileNum,Status);

        If (StatusOk) then
        Begin
          UpdateAllocCRec(BlankAlloc,LMiscRecs^,AllocCtrl,Nil);


        end;

      end
      else
        UpdateAllocCRec(BlankAlloc,OldAlloc,AllocCtrl,Nil);


      Link2Tot;
      Set_Row(MUListBoxes[0].Row);

      UnLockMLock(ScanFileNum,LastRecAddr[ScanFileNum]);

    end; {With..}
  end;

  GlobalAllocRec^:=TmpGlobAlloc^;

  Dispose(TmpGLobAlloc);

end;



Function TAllocItems.SRCTol  :  Double;

Begin
  Case Syss.AlTolMode of
    1  :  Result:=Syss.AlTolVal;
    2  :  Result:=Round_Up(Pcnt(Syss.AlTolVal)*MulCtrlO.AllocCtrl.AllocCRec.arcTransValue,2);
    else  Result:=0;
  end; {Case..}


end;


Function TAllocItems.Within_SRCTol(TmpVariance  :  Double):  Boolean;

Var
  Equiv,
  EquivDNC,
  MaxEq  :  Double;

Begin

  If (Assigned(MULCtrlO)) then
  With MULCtrlO.AllocCtrl.AllocCRec, ExLocal, LMiscRecs^.AllocSRec, LInv do
  Begin
    Equiv:=TmpVariance;

    EquivDNC:=SRCTol;

    MaxEq:=arcTransValue;

    {$IFDEF MC_On}
      Result:=((Round_Up(Equiv,2)<=EquivDNC) or (SBSIn) or (Syss.AlTolMode=0))
    {$ELSE}
      Result:=BOn;

    {$ENDIF}
  end; {With..}
end;


{Mode : 0 Called by full allocation where matching currencies will have their variance auto calculated
        1 Called by part allocation where all variances must be confirmed }
//PR: 03/06/2015 ABSEXCH-16476 Added default parameter so func can take account of ppd
//PR: 19/06/2015 ABSEXCH-16558 Added default BasePPD parameter
Function TAllocItems.Calc_Variance(Mode     :  Byte;
                                   BaseAmnt,
                                   OwnCAmnt :  Double;
                               Var CalcVar,
                                   CalcSet  :  Double;
                                   OwnCurrencyPPD : Double = 0.0;
                                   BasePPD : Double = 0.0)  :  Boolean;

Var
  UOR      :  Byte;

  UseSetD,
  SingleCMode,
  Ok2Store :  Boolean;

  TransCnst:  Integer;

  OwnUnalloc,
  TmpVariance,
  NewBase,
  Unalloc  :  Double;

  GenStr   :  Str255;
  CanTakeDiscount: Boolean;
  CanAllocate: Boolean;
Begin
  //If we're taking PPD on any transactions then
  //variance will be calculated at the end.
  if FTakePPD then
  begin
    Result := True;
    EXIT;
  end;
  Result:=BOff; Ok2Store:=BOff;  TmpVariance:=0.0;  CalcVar:=0.0;  CalcSet:=0.0;

  UseSetD:=BOff;


  {$IFNDEF MC_On}

    SingleCMode:=BOn;
  {$ELSE}

    SingleCMode:=BOff;
  {$ENDIF}

  If (Assigned(MULCtrlO)) then
  With MULCtrlO.AllocCtrl,AllocCRec, ExLocal, LMiscRecs^.AllocSRec, LInv do

  Begin

    // CJS 2015-02-26 - T1-009 - Allocation Wizard - remove settlement discount option for transactions > 01/04/2015
    CanTakeDiscount := TransactionHelper(@LInv).SettlementDiscountSupported;

    Unalloc:=Round_Up(arcTransValue-arcTotal-arcVariance,2);
    OwnUnalloc:=Round_Up(arcOwnTransValue-arcTotalOwn,2);

    TransCnst:=DocCnst[InvDocHed]*DocNotCnst;

    //PR: 03/06/2015 ABSEXCH-16476 Include PPD
    Ok2Store:=((arcPayCurr=ariOrigCurr) and ((Round_Up(OwnUnalloc,2)>=Round_Up(Abs(OwnCAmnt) - Abs(OwnCurrencyPPD),2)) or
                      (arcAutoTotal)) and (Mode<>1) and (Not arcFromTrans));

    UOR:=fxUseORate(BOff,BOn,arcCXRate,0,arcPayCurr,0);

    If (Ok2Store) then {*Auto Calculate variance from transaction *}
    Begin

      NewBase:=Conv_TCurr(OwnCAmnt*TransCnst,XRate(arcCXRate,BOff,arcPayCurr),arcPayCurr,UOR,BOff);

      TmpVariance:=Round_Up(NewBase-BaseAmnt*TransCnst,2);
    end
    else
      TmpVariance:=Round_Up(Unalloc-(((BaseAmnt + BasePPD)*TransCnst)),2) ;


    //PR: 19/06/2015 ABSEXCH-16558 Included BasePPD in check
    If ((Unalloc<Round_Up((BaseAmnt*TransCnst) - (BasePPD * (1-Mode)),2)) and (Not arcAutoTotal)) or (Ok2Store) then
    Begin
      If (Within_SRCTol(TmpVariance)) then
      Begin

        If (Not Ok2Store) then
        Begin
          If (Not arcFromTrans) then
          Begin
            // CJS 2015-02-26 - ABSEXCH-15298 - T1-009 - Allocation Wizard - remove settlement discount option for transactions > 01/04/2015
            CanAllocate := True;
            if CanTakeDiscount then
            begin
              If (Not arcIncVar) or (SingleCMode) then
              Begin
                GenStr := 'There are insufficient funds left to allocate this ' +
                          'transaction without generating a settlement discount of ' +
                          FormatCurFloat(GenRealMask, tmpVariance, BOff, 0) + '.' +
                          #13+#13+
                          'Please confirm that you wish to complete this allocation by ' +
                          'generating a settlement discount.';

              end
              else
              Begin
                GenStr := 'There are insufficient funds left to allocate this ' +
                          'transaction without generating a currency variance or ' +
                          'settlement discount of ' +
                          FormatCurFloat(GenRealMask, tmpVariance, BOff, 0) + '.' +
                          #13+#13+
                          'Please confirm that you wish to complete this allocation by ' +
                          'choosing below the method for accounting for the ' +
                          'difference.';
              end;
            end
            else
            begin
              If (Not arcIncVar) or (SingleCMode) then
              Begin
                GenStr := 'There are insufficient funds left to allocate this transaction.';
                CanAllocate := False;
              end
              else
              Begin
                GenStr := 'There are insufficient funds left to allocate this ' +
                          'transaction without generating a currency variance of ' +
                          FormatCurFloat(GenRealMask, tmpVariance, BOff, 0) + '.' +
                          #13+#13+
                          'Please confirm that you wish to complete this ' +
                          'allocation by generating a currency variance.';
              end;
            end;

            if CanAllocate then
              Ok2Store := (AllocCustomDlg(Application.MainForm,
                                          'Over allocation',
                                          'Insufficient Funds',
                                          GenStr,
                                          mtConfirmation,
                                          [mbOK,mbCancel],
                                          arcIncVar,
                                          UseSetD,
                                          False,
                                          CanTakeDiscount) = mrOk);
          end
          else
            CanAllocate := False;

          if not CanAllocate then
          Begin
            Ok2Store:=BOff;
            CustomDlg(Application.MainForm,
                      'Over allocation',
                      'Insufficient Funds',
                      'There are insufficient funds left to allocate this transaction.',
                      mtInformation,
                      [mbCancel]);
          end;

        end
        else
        Begin

        end;

        Result:=Ok2Store;
      end
      else
        CustomDlg(Application.MainForm,'Tolerance exceeded','Tolerance exceeded.',
                                'A currency variance of '+FormatCurFloat(GenRealMask,tmpVariance,BOff,0)+' would be required to allocate this transaction.'+#13+
                                'The maximum value allowed for over allocation is '+FormatCurFloat(GenRealMask,SRCTol,BOff,0),
                                mtWarning,
                                [mbOK]);


    end {If..}
    else
    Begin
      Result:=BOn;
      TmpVariance:=0.0;
    end;


    If (Result) then
    Begin
      If (UseSetD) then
      Begin
        {* Convert difference back to transactions own currency *}
        CalcSet:=Round_Up(Conv_TCurr(TmpVariance,XRate(ariCXRate,BOff,ariOrigCurr),ariOrigCurr,UOR,BOn),2);

        CalcVar:=TmpVariance;

      end
      else
        CalcVar:=TmpVariance;

    end;


  end; {With..}

end;


procedure TAllocItems.AlCP1BtnClick(Sender: TObject);
Var
  SReason  :  Byte;
  GenStr   :  Str255;
  PPDCheckResult : Byte;

  OSIncPPD : Double;
  OSIncPPDBase : Double;
  RemainingOnAlloc : Double;
  RemainingOnAllocCurr : Double;
  PPD : Double;
  PPDBase : Double;

  UOR : Byte;
  TakePPD : Boolean;
  PartAllocMessage : string;

  function IsPCR : Boolean;
  begin
    Result := (Copy(MULCtrlO.AllocCtrl.AllocCRec.arcOurRef, 1, 3) = 'PCR')
  end;
begin
  If (Assigned(MULCtrlO)) then
  With MULCtrlO ,TWincontrol(Sender), MiscRecs^.AllocSRec do
    If (ValidLine) and (Not InListFind) and (GetInv(ariOurRef)) then
    Begin

      // CJS 16/03/2011 - ABSEXCH-2567
      // Replaced global Inv parameter with ExLocal.LInv
      SReason := SanityCheckAllocS(MiscRecs^, ExLocal.LInv);

      {$B-}
      If (Tag=4) or (SReason=0) then
      {$B+}
      with ExLocal.LInv do
      begin
        //Don't allow full allocation to be done again if we've done allocation with PPD
        if (Tag = 3) and (Round_Up(ExLocal.LInv.thPPDGoodsValue + ExLocal.LInv.thPPDVATValue, 2) <> 0) and
           (ariPPDStatus > 0) then
           EXIT;

        if (Tag = 3) and ValidPPDAvailable(ExLocal.LInv, EtDateU.Today, -1) and (ariPPDStatus = 0) and
        //PR: 22/09/2015 ABSEXCH-16898 Removed check for Inv.Settled = 0 to allow for part payments
           { (Round_Up(Inv.Settled, 2) = 0.0) and}
           (abs(ariCurrOS) >= (ExLocal.LInv.thPPDGoodsValue + ExLocal.LInv.thPPDVATValue)) then
        begin
            //O/S on invoice including PPD
            OSIncPPD := Round_Up(Abs(ariCurrOS) - (ExLocal.LInv.thPPDGoodsValue + ExLocal.LInv.thPPDVATValue), 2);
            PPD := ExLocal.LInv.thPPDGoodsValue + ExLocal.LInv.thPPDVATValue;
            with ExLocal.LInv do
            begin
              {$IFDEF MC_ON}
              UOR:=fxUseORate(UseCoDayRate,BOn,CXRate,UseORate,Currency,0);
              OSIncPPDBase := Round_Up(Conv_TCurr(OSIncPPD,XRate(CXRate,True,Currency),Currency,UOR,False), 2);

              PPDBase := Round_Up(Conv_TCurr(PPD,XRate(CXRate,True,Currency),Currency,UOR,False), 2);
              {$ELSE}
              OSIncPPDBase := OSIncPPD;
              PPDBase := PPD;
              {$ENDIF}
            end;

            //Remaining value to allocate
            RemainingOnAlloc := Round_Up(AllocCtrl.AllocCRec.arcTransValue - AllocCtrl.AllocCRec.arcTotal, 2);

            RemainingOnAllocCurr := Round_Up(AllocCtrl.AllocCRec.arcOwnTransValue - AllocCtrl.AllocCRec.arcTotalOwn, 2);

            //If amount to allocate is equal to or more than o/s on invoice then show menu
            //PR: 10/06/2015 ABSEXCH-
            if ((Round_Up(Abs(ariBaseOS), 2) <=  RemainingOnAlloc) or AllocCtrl.AllocCRec.arcAutoTotal or
               ((ariOrigCurr = AllocCtrl.AllocCRec.arcPayCurr) and (Round_Up(Abs(OSIncPPD), 2) <=  RemainingOnAllocCurr))) then
              ShowPPDAllocationMenu(Abs(ariCurrOS), ExLocal.LInv.thPPDGoodsValue + ExLocal.LInv.thPPDVATValue)
            else
            if OSIncPPDBase <= RemainingOnAlloc then
            begin
              //If amount to allocate is equal to or more than o/s less ppd, then confirm user wants to take PPD
              if (thPPDTaken = ptPPDNotTaken) then
                PPDcheckResult :=  msgBox(Format('Do you wish to %s %s PPD?',
                                  [PPDGiveTakeWord(Cust.CustSupp, False),
                                   Trim(FormatCurFloat(GenRealMask,PPD, BOff, ariOrigCurr))]),
                                     mtConfirmation, mbYesNoCancel, mbYes, 'Allocation');

              if PPDCheckResult in [mrYes, mrNo] then
                Allocate(Tag, PPDCheckResult = mrYes);
            end
            else //Pass to allocate routine which will show over-allocation message and offer variance
              Allocate(Tag);
        end
        else
        if (Tag = 5) and (ExLocal.LInv.thPPDTaken <> ptPPDNotTaken) then
        begin   //If allocating the PCR then allow
          if IsPCR and  (Cust.acPPDMode = pmPPDEnabledWithManualCreditNote) then
             Allocate(Tag)
          else
          begin
            //Trying to part-allocate a transaction with PPD taken
            PartAllocMessage := 'It is not possible to part allocate a transaction once PPD has been ' +
                              PPDGiveTakeWord(ExLocal.LInv.CustSupp, False) + 'n.';

            //If manual then tell them to do the PCR first
            if (Cust.acPPDMode = pmPPDEnabledWithManualCreditNote) and
               (Abs(CurrencyOS(ExLocal.LInv, True, False, False)) <> Round_Up(ITotal(ExLocal.LInv) - (ExLocal.LInv.thPPDGoodsValue + ExLocal.LInv.thPPDVATValue), 2)) then
              PartAllocMessage := PartAllocMessage + #13#13 + 'Please allocate a credit note for the PPD before proceeding.';
            ShowMessage(PartAllocMessage);

          end;
        end
        else
        begin
          //PR: 16/06/2015 ABSEXCH-16550 Taken Manual PCR PPD should be taken into account.
          TakePPD := ((Tag = 5) or ((Tag = 3) and (Cust.acPPDMode = pmPPDEnabledWithManualCreditNote)))
                         and (Round_Up(ExLocal.LInv.thPPDGoodsValue + ExLocal.LInv.thPPDVATValue, 2) <> 0.0);

          //PR: 09/07/2015 ABSEXCH-16633 If PPD has already been taken then set TakePPD paramenter to False
          if Cust.acPPDMode <> pmPPDEnabledWithManualCreditNote then
            TakePPD := TakePPD and (ExLocal.LInv.thPPDTaken = ptPPDNotTaken)
          else //PR: 09/07/2015 ABSEXCH-16616 Check if PCR has already been created and allocated
            TakePPD := TakePPD and (CurrencyOS(ExLocal.LInv, True, False, False) = ITotal(ExLocal.LInv));

          Allocate(Tag,  TakePPD);
        end;
      end
      else
      Begin
        GenStr:='It is not possible to allocate '+Inv.OurRef+' because '+Sanity_Reason(SReason)+#13+#13;
        CustomDlg(Self,'Allocation Denied.','Transaction No Longer Valid.',
                   GenStr,
                   mtWarning,
                   [mbOK]);

      end;
    end;
end;

{ == Restate the amount outstanding based on settlement discount == }
{ Replicated in AllocS2U }

Procedure TAllocItems.ReStateOS(AllocCtrl  :  MLocRec;
                                EInv       :  InvRec);

Begin
  With ExLocal, AllocCtrl.AllocCRec, LMiscRecs^.AllocSRec do
  Begin
    ariBaseOS:=BasetotalOS(EInv);

    {$IFDEF MC_On}

      ariCurrOS:=CurrencyOS(EInv,BOff,BOff,BOff);

      If (arcPayCurr=ariOrigCurr) then
        ariOutStanding:=ariCurrOS
      else
        ariOutStanding:=Currency_ConvFT(ariBaseOS,0,arcPayCurr,UseCoDayRate);

    {$ELSE}

      ariOutStanding:=ariBaseOS;

      ariCurrOS:=ariBaseOS;
    {$ENDIF}

    

  end; {With..}
end;




{ ============ Discount Documents ============ }

Procedure TAllocItems.SetDiscount(Mode  :  Byte);


Var
  UOR     :  Byte;

  Ok2Store:  Boolean;

  EInv    :  InvRec;

  TmpAlloc:  MiscRec;

  TransCnst
          :  Integer;

  mrResult:  Word;
  ISCtrl  :  TCLPAL;

  KeyS    :  Str255;

Begin

  KeyS:=''; Ok2Store:=BOff;

  UOR:=0;

  With MULCtrlO,ExLocal,LInv do
  Begin
    LGetRecAddr(ScanFileNum);

    Ok:=LGetMultiRec(B_GetDirect,B_MultLock,KeyS,KeyPAth,ScanFileNum,BOff,GlobLocked);


    If (Ok) and (GlobLocked) then
    With AllocCtrl.AllocCRec, LMiscRecs^.AllocSRec do
    Begin

      Ok2Store:=BOff;

      ISCtrl:=TCLPAL.Create(Self);

      try

        With ISCtrl do
        Begin
          PAValue:=ariOrigSetDisc;
          BSDiscMode:=BOn;
          BCurSymb:=SSymb(Currency);

          mrResult:=InitIS(BOff,CLORefPanel.Color,CLORefPanel.Font);

          If (mrResult=mrOk) then
          Begin
            ariOrigSetDisc:=PAValue;
            Ok2Store:=BOn;
          end;
        end;

      finally

        ISCtrl.Free;

      end; {Try..}



      If (Ok2Store) then
      Begin


        If (LastRecAddr[Scanfilenum]<>0) then  {* Re-establish position prior to storing *}
        Begin

          TmpAlloc:=LMiscRecs^;

          LSetDataRecOfs(Scanfilenum,LastRecAddr[Scanfilenum]);

          Status:=GetDirect(F[Scanfilenum],Scanfilenum,LRecPtr[Scanfilenum]^,KeyPAth,0); {* Re-Establish Position *}

          LMiscRecs^:=TmpAlloc;

        end;

        EInv:=LInv;

        If ((InvDocHed In RecieptSet+CreditSet) and (ITotal(LInv)<0)) or ((PayRight(LInv,AllocCtrl.AllocCRec.arcSalesMode)) and (ITotal(LInv)>=0)) then
          TransCnst:=-1
        else
          TransCnst:=1;

        LInv.BDiscount:=ariOrigSetDisc;

        AllocForceInvSDisc(LInv,EInv,AllocCtrl,1);

        ReStateOS(AllocCtrl,EInv);

        {*v 5.52. Need to re-establish sign after re-setting o/s for any credit notes which have a modified discount in them *}

        ariOrigSetDisc:=ariOrigSetDisc*TransCnst;
        ariOutStanding:=ariOutStanding*TransCnst;
        ariBaseOS:=ariBaseOS*TransCnst;
        ariCurrOS:=ariCurrOs*TransCnst;

        Status:=Put_Rec(F[Scanfilenum],Scanfilenum,LRecptr[Scanfilenum]^,keypath);

        AssignToGlobal(ScanFileNum);

        Report_BError(ScanFileNum,Status);


      end;

      Set_Row(MUListBoxes[0].Row);

      UnLockMLock(ScanFileNum,LastRecAddr[ScanFileNum]);

    end; {With..}
  end;
end;


procedure TAllocItems.SDiscBtnClick(Sender: TObject);
begin
  If (Assigned(MULCtrlO)) then
  With MULCtrlO ,TWincontrol(Sender), MiscRecs^.AllocSRec do
    If (ValidLine) and (Not InListFind) and (GetInv(ariOurRef)) then
    Begin

      If (ariSettle=0.0) then
        SetDiscount(0)
      else
        CustomDlg(Application.MainForm,'Transaction already settled','Transaction settled.',
                                'It is not possible to alter the settlement write-off while a transaction is settled.'+#13+
                                'Unallocate the transaction first, then adjust the write-off, and re-allocate.',
                                mtInformation,
                                [mbOK]);

    end;

end;


procedure TAllocItems.CalcCP1BtnClick(Sender: TObject);
Var
  mbRet  :  Word;
begin
  {$B-}
  If (Assigned(MULCtrlO)) and (Not MULCtrlO.InListFind) then
  {$B+}
  Begin
    Set_BackThreadMVisible(BOn);

    mbRet:=CustomDlg(Self,'Please note!','Recalculate this screen.',
                 'Recalculating this screen will reset any allocated lines.'+#13+#13+
                 'In addition the account will be re-scanned for new transactions which could now be included.'+#13+#13+
                 'Please confirm you wish recalculate this allocation screen.',
                 mtConfirmation,
                 [mbOK,mbCancel]);

    Set_BackThreadMVisible(BOff);

    {$IFDEF POST}

      If (mbRet=mrOK) then
      Begin
        AddAllocScan2Thread(Application.MainForm,MULCtrlO.AllocCtrl,Self.Handle,0);


        SetButtons(BOff);
        Enabled:=BOff;

      end;
    {$ENDIF}
  end;
end;

procedure TAllocItems.ViewCP1BtnClick(Sender: TObject);

Var
  OldInHBeen  :  Boolean;

begin
  If (Assigned(MULCtrlO)) then
  With MULCtrlO ,TWincontrol(Sender), MiscRecs^.AllocSRec do
    If (ValidLine) and (Not InListFind) and (GetInv(ariOurRef)) then
    Begin
      OldInHBeen:=InHBeen;

      InHBeen:=BOn;

      Display_Trans(100,BOff, True);

      InHBeen:=OldInHBeen;   

    end;


end;


procedure TAllocItems.DeleteAllocLine;

Var
  MbRet  :  Word;
  GotRec :  Integer;
  KeyS   :  Str255;

  TmpAlloc:  MiscRec;


Begin
  If (Assigned(MULCtrlO)) then
  With MULCtrlO ,MiscRecs^.AllocSRec do
  Begin
    If (ValidLine) and (Not InListFind) then
    Begin
      FillChar(TmpAlloc,Sizeof(TmpAlloc),#0);

      With ExLocal do
      Begin
        AssignFromGlobal(ScanFileNum);
        LGetRecAddr(ScanFileNum);

        MbRet:=CustomDlg(Self,'Remove Allocation Entry','','Please confirm you wish to remove this allocation entry.'+#13+
                          'The original transaction will not be affected.',
                           mtConfirmation,[mbOK,mbCancel]);

        If (MbRet=MrOK) then
        Begin
          Status:=LGetDirectRec(ScanFileNum,KeyPath);

          If (StatusOk) then
          Begin

            Ok:=LGetMultiRec(B_GetDirect,B_MultLock,KeyS,KeyPath,ScanFileNum,BOn,GlobLocked);

            If (Ok) and (GlobLocked) then
            Begin

              Status:=Delete_Rec(F[ScanFileNum],ScanFileNum,KeyPath);

              Report_BError(ScanFileNum,Status);
            end;

            If (StatusOk) then
            Begin
              If (MUListBox1.Row<>0) then
                PageUpDn(0,BOn)
              else
                InitPage;

              UpdateAllocCRec(LMiscRecs^,TmpAlloc,AllocCtrl,Nil);

              Link2Tot;
            end;

          end; {If line is valid for deletion..}
        end
        else
          Report_BError(ScanFileNum,Status);
      end; {With..}
    end;
  end; {With..}
end; {PRoc..}


procedure TAllocItems.DelCP1BtnClick(Sender: TObject);
begin
  DeleteAllocLine;
end;


{ == Function to load SRC and check its allocation status == }

Function TAllocItems.SRC_AllocStatus  :  Boolean;


Begin
  Result:=BOff;

  {$B-}
  If (Assigned(MULCtrlO)) and (Not MULCtrlO.InListFind) then
  With MULCtrlO,AllocCtrl,AllocCRec, ExLocal do
  Begin
    Result:=(GetInv(arcOurRef) and (Round_Up(ABS(arcTransValue),2)=Round_Up(ABS(BasetotalOS(LInv)),2)));

  {$B+}

  end; {Func..}
end;

procedure TAllocItems.GenCP1BtnClick(Sender: TObject);
Var
  Ok2Start
         :  Boolean;

  RetFail:  Byte;

  mbRet  :  Word;

  GenStr2,
  GenStr :  Str255;

  UnaVal :  Double;

  Buttons:  TMsgDlgButtons;

  CanTakeDiscount: Boolean;
  Res : Integer;
begin
  {$B-}
  If (Assigned(MULCtrlO)) and (Not MULCtrlO.InListFind) and (Not InProcessBtn) and (Not InSettleBtn) then
  With MULCtrlO,AllocCtrl,AllocCRec do
  Begin
    InProcessBtn:=BOn;

    Set_BackThreadMVisible(BOn);

    UnaVal:=Round_up(Calc_arcUnallocated(AllocCtrl,FTakePPD),2);

    arcAllocFull:=(UnaVal=0.0);

    {$IFDEF MC_On}
      If (arcAllocFull) and (arcPayCurr>1) and (arcTransValue=0.0) and (arcVariance<>0.0) then
        arcAllocFull:=False;  {* v5.71.001. Allow for a variance only situation with a zero value receipt on matching currencies *}
    {$ENDIF}

    If (arcFromTrans) then
      GenStr2:='Please confirm you wish to allocate '+DDownTitle+' '+arcOurRef
    else
      GenStr2:='Please confirm you wish to generate a '+DDownTitle;

    Buttons:=[mbOK,mbCancel];

    If (BACS_HasUsers(arcSalesMode,BOff,0)) then
    Begin
      GenStr:='A '+BatchPTit(arcSalesMode)+' is currently in progress.'#13+#13+
                'It is not possible to process the allocation at this time.';
      GenStr2:='';

      Buttons:=[mbCancel];

      RetFail:=1;

    end
    else                              {* v5.71 This check added so own currency allocations where base was different sign to own
                                         can still go ahead as long as variance present *}
      If (UnaVal>arcTransValue) and ((arcVariance=0.0) or (arcPayCurr<>arcInvCurr) or arcFromTrans) then
      Begin
        GenStr:='The value unallocated is greater than the '+DDownTitle+' value.'#13+#13+
                'It is not possible to process the allocation on this basis.';
        GenStr2:='';

        Buttons:=[mbCancel];

        RetFail:=2;

      end
      else
        If (arcFromTrans) and (Not SRC_AllocStatus) then
        Begin
          GenStr:='These allocations are no longer valid for '+arcOurRef+' because '+Sanity_Reason(7)+#13+#13;
          GenStr2:='Confirming &OK will reset these allocations.';
        end
        else
          If (Round_Up(arcOwnTransValue+arcTransValue+arcVariance+arcSettleD,2)=0) then
            GenStr:='This '+DDownTitle+' has no value!'+#13+#13
          else
            If (arcTotal=0.0) then
              GenStr:='Nothing has been allocated against this '+DDownTitle+#13+#13
            else
              If (Not arcAllocFull) then
              Begin
                // CJS 2015-02-26 - ABSEXCH-15298 - T1-009 - Allocation Wizard - remove settlement discount option for transactions > 01/04/2015
                CanTakeDiscount := TransactionHelper(@ExLocal.LInv).SettlementDiscountSupported;
                If (Not arcFromTrans) then
                Begin
                  arcFinSetD:=BOff;

                  {$IFDEF MC_On}
                    arcFinVar:=arcIncVar;
                  {$ELSE}
                    arcFinVar:=BOff;
                  {$ENDIF}

                  // CJS 2015-02-26 - ABSEXCH-15298 - T1-009 - Allocation Wizard - remove settlement discount option for transactions > 01/04/2015
                  if CanTakeDiscount then
                  begin
                    If (arcFinVar) then
                      GenStr := 'Not all of this ' + DDownTitle + ' has been ' +
                                'allocated. If you wish to settle the remainder ' +
                                'against variance or settlement discount, ' +
                                'choose the appropriate option below and confirm ' +
                                'with &OK, or you can leave the remainder ' +
                                'unallocated by choosing &Leave O/S.'
                    else
                      GenStr := 'Not all of this ' + DDownTitle + ' has been ' +
                                'allocated. If you wish to settle the remainder ' +
                                'against settlement discount, choose &OK, or you ' +
                                'can leave the remainder outstanding by choosing ' +
                                '&Leave O/S.';
                  end
                  else
                  begin
                    If (arcFinVar) then
                      GenStr := 'Not all of this ' + DDownTitle + ' has been ' +
                                'allocated. If you wish to settle the remainder ' +
                                'against variance, confirm this with &Ok, or ' +
                                'you can leave the remainder unallocated by ' +
                                'choosing &Leave O/S.'
                    else
                      GenStr := 'Not all of this ' + DDownTitle + ' has been ' +
                                'allocated. The remainder will be left '+
                                'unallocated.' + #13#13;
                  end;

                  if (CanTakeDiscount or arcFinVar) then
                    mbRet := AllocCustomDlg(Application.MainForm,
                                            'Under Allocation',
                                            'Allocate Remainder',
                                            GenStr,
                                            mtConfirmation,
                                            [mbOK, mbCancel],
                                            arcFinVar,
                                            arcFinSetD,
                                            False,
                                            CanTakeDiscount)
                  else
                    mbRet := mrOk;

                  {$IFDEF MC_On}
                    If ((mbRet=mrOK) and (arcFinSetD)) or (mbRet=mrCancel) then
                      arcFinVar:=BOff;
                  {$ENDIF}

                  //PR: 31/01/2011 ABSEXCH-2233 Warn user about the settlement discount line.
                  If ((mbRet=mrOK) and (arcFinSetD)) then
                    GenStr := 'PLEASE NOTE: A settlement discount line will be added to this ' + DDownTitle + #10#10
                  else
                    GenStr := '';
                end
                else
                  GenStr:='Not all of this '+DDownTitle+' has been allocated.  The remainder will be left unallocated.'+#13+#13;
              end
              else
                GenStr:='';

    mbRet:=CustomDlg(Self,'Process Allocation','Generate '+DDownTitle,
                   GenStr+
                   GenStr2,
                   mtConfirmation,
                   Buttons);


    {$B+}

    Set_BackThreadMVisible(BOff);

    {$IFDEF POST}

      Ok2Start:=(mbRet=mrOK);

      If (OK2Start) then
      Begin

        //Load invoices into PPD object
        PrepareTakePPD;

        If (Ok2Start)then
        Begin
          AddAllocScan2Thread(Application.MainForm,MULCtrlO.AllocCtrl,Self.Handle,3, apDontTake, FTakePPD);

          // MH 15/10/2010 v6.5 ABSEXCH-9914: Prevent user closing the window whilst the process is running
          ClsCP1Btn.Enabled := False;

          SetButtons(BOff);
          Enabled:=BOff;
        end;

      end
      else
      Begin
        If (RetFail=1) then {Display list of logged in users}
          Show_LIUsers(arcSalesMode,0);

        InProcessBtn:=BOff;
      end;

    {$ENDIF}

  
  end;
end;


procedure TAllocItems.ChkCP1BtnClick(Sender: TObject);
Var
  mbRet  :  Word;

begin
  {$B-}
  If (Assigned(MULCtrlO)) and (Not MULCtrlO.InListFind) and (Not InProcessBtn) and (Not InSettleBtn) then
  {$B+}
  With MULCtrlO,AllocCtrl,AllocCRec do
  Begin
    Set_BackThreadMVisible(BOn);

    mbRet:=CustomDlg(Self,'Check Allocation','Check for any inconsistencies',
                     'Check will re-calculate the screen totals based on the allocations present in the list.'+#13+
                     'A check is also made against the original transactions to ensure they have not changed since the list was created.'+#13+
                     'Any transactions which have changed will have their allocations cancelled.'+#13+#13+
                     'Please confirm you wish check the allocations.',
                     mtConfirmation,
                     [mbOK,mbCancel]);

  Set_BackThreadMVisible(BOff);

    {$IFDEF POST}

      If (mbRet=mrOK) then
      Begin
        {* Run check first, the process if all ok *}

        AddAllocScan2Thread(Application.MainForm,MULCtrlO.AllocCtrl,Self.Handle,2);

        SetButtons(BOff);
        Enabled:=BOff;

      end;
    {$ENDIF}
  end;
  
end;

procedure TAllocItems.CurCP1BtnClick(Sender: TObject);
{$IFDEF MC_On}

  Var
    LedCur  :  TLCForm;

    mrRet   :  Word;
{$ENDIF}

begin
  {$IFDEF MC_On}

    LedCur:=TLCForm.Create(Self);

    try

      With MULCtrlO,VisiList do
      Begin
        mrRet:=LedCur.InitAS(NHCr,0,IdPanel(0,BOff).Color,IdPanel(0,BOff).Font);

        If (mrRet=mrOk) then
        Begin
          Set_CurrencyFilt;
        end;
      end;

    finally

      LedCur.Free;

    end; {try..}

  {$ENDIF}
end;

procedure TAllocItems.Display_Match(ChangeFocus,
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

    FillChar(NomNHCtrl,Sizeof(NomNHCtrl),0);

    NHMode:=4-Ord(MatchMode);

    NHCr:=MULCtrlO.NHCr;

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



procedure TAllocItems.MACP1BtnClick(Sender: TObject);
begin
  If (Assigned(MULCtrlO)) then
  With MULCtrlO ,MiscRecs^.AllocSRec, ExLocal do
  Begin
    If (ValidLine) and (Not InListFind) and (GetInv(ariOurRef)) then
      Display_Match(BOn,((LInv.RemitNo<>'') or (LInv.OrdMatch)));
  end; {WIth..}
end;

procedure TAllocItems.SetCP1BtnClick(Sender: TObject);
const
  Msg =  'Starting from the top of the list, Settle will automatically allocate the current amount outstanding until it runs out.'+#13+
         'Any transactions which have already been allocated will be excluded from this process.'+#13+#13+
         'Please confirm you wish to Settle.';

Var
  mbRet  :  Word;
  PPDOption : Byte;
  PPDMode : TAllocPPDMode;
begin
  {$B-}
  If (Assigned(MULCtrlO)) and (Not MULCtrlO.InListFind) and (Not InProcessBtn) and (Not InSettleBtn) then
  {$B+}
  With MULCtrlO,AllocCtrl,AllocCRec do
  Begin
    //PR: 24/08/2017 ABSEXCH-19160 Uninitialised PPDOption was causing issues further
    //                             on in the process
    PPDOption := 0;
    InSettleBtn:=BOn;

    Set_BackThreadMVisible(BOn);

    if Cust.acPPDMode = pmPPDDisabled then //original behaviour
      mbRet:=CustomDlg(Self,'Auto Allocate','Auto Settle Transactions', Msg,
                     mtConfirmation,
                     [mbOK,mbCancel])
    else  //display new form with PPD dropdown
      mbRet := SettleCustomDlg(Self,'Auto Allocate','Auto Settle Transactions', Msg,
                     mtConfirmation,
                     [mbOK,mbCancel],
                     Cust.CustSupp,
                     PPDOption);

    Set_BackThreadMVisible(BOff);


    {$IFDEF POST}

      If (mbRet=mrOK) then
      Begin

        //PR: 22/05/2015 v7.0.14 Need to tell settle how to give/take PPD.
        Case PPDOption of
          0  :  PPDMOde := apDontTake;
          1  :  PPDMOde := apTakeWithinTerms;
          2  :  PPDMOde := apTakeAlways;
          else
            PPDMode := apDontTake; //PR: 24/08/2017 ABSEXCH-19160
        end;

        FTakePPD := PPDMode <> apDontTake;

        AddAllocScan2Thread(Application.MainForm,MULCtrlO.AllocCtrl,Self.Handle,30, PPDMode);

        SetButtons(BOff);
        Enabled:=BOff;

      end
      else
        InSettleBtn:=BOff;
    {$ENDIF}


  end;
end;

procedure TAllocItems.PrintCP1BtnClick(Sender: TObject);
begin
  {$IFDEF RP}
    If Assigned(MULCtrlO) then
      AddAllocRep2Thread(7,MULCtrlO.AllocCtrl,Nil,Application.MainForm);
  {$ENDIF}
end;

procedure TAllocItems.SetSplitBtnClick(Sender: TObject);
begin
  If (Assigned(MULCtrlO)) and (Not InSplitPay) then
  Begin
    InSplitPay:=BOn;
    AllocAPLCtrl(MULCtrlO.AllocCtrl,Self);

  end;

end;

procedure TAllocItems.SetHelpContextIDs;
// NF: 11/05/06 Fix for incorrect Context IDs
// NF: 20/06/06 Added in support for different IDs for Sales and Purchase.

  procedure IncHelpContextIDs(iInc : integer; TheControl : TControl);
  var
    iPos : integer;

    procedure SetContextID(AControl : TControl; iNewID : integer);
    begin{SetContextID}
      // Exceptions
//      if AControl.Name = 'ClsCP1Btn' then exit;

      // Set Context ID
      if AControl.HelpContext > 0
      then AControl.HelpContext := iNewID;
    end;{SetContextID}

  begin{IncHelpContextIDs}
    // Inc the control's Context ID
    SetContextID(TheControl, TheControl.HelpContext + iInc);

    // Inc the Context IDs of the controls in the control
    For iPos := 0 to Thecontrol.ComponentCount -1 do
    begin
      if Thecontrol.Components[iPos] is TControl
      and (not (Thecontrol.Components[iPos] is TForm))
      then IncHelpContextIDs(iInc, TControl(TheControl.Components[iPos]));
    end;{for}
  end;{IncHelpContextIDs}

var
  bSales : boolean;
begin
  // Fix incorrect IDs
  FindCP1Btn.HelpContext := 27;
  MACP1Btn.HelpContext := 138;
// NF: for some reason the columns don't work in code - I can't figure out why, so I have had to fix them on the form
//  CLORefPanel.HelpContext := 142;
//  CLYRefPanel.HelpContext := 5148;

   bSales := RecMode;
  {$IFDEF LTE}
    // Set Correct Tab IDs
    if bSales then IncHelpContextIDs(5000, Self);
  {$ELSE}
    // Exchequer
  {$ENDIF}
end;



procedure TAllocItems.ShowPPDAllocationMenu(OSValue : Double; PPDValue : Double);
var
  MenuPos : TPoint;
  Currency : Integer;
  UOR : Byte;
  ExpiredS : string;
begin
  with ExLocal.LInv do
  begin

    if ValidPPDAvailable(ExLocal.LInv, EtDateU.Today) then
      ExpiredS := ''
    else
      ExpiredS := ' EXPIRED';

    with PPDAllocationMenu do
    begin
      Items[0].Caption := Format('Allocate outstanding balance of %s', [Trim(FormatCurFloat(GenRealMask,OSValue,BOff, Currency))]);
      Items[1].Caption := Format('%s %s%s PPD and allocate remaining balance of %s',
                                       [PPDGiveTakeWord(ExLocal.LInv.CustSupp),
                                        Trim(FormatCurFloat(GenRealMask,PPDValue,BOff,ExLocal.LInv.Currency)), ExpiredS,
                                        Trim(FormatCurFloat(GenRealMask, Round_Up(OSValue - PPDValue, 2),BOff, ExLocal.LInv.Currency))]);

      MenuPos := AlcP1Btn.ClientToScreen(Point(2, 3));
      PopUp(MenuPos.X, MenuPos.Y);
    end;
  end;
end;

procedure TAllocItems.Allocate2Click(Sender: TObject);
begin
  //allocate without PPD
  Allocate(3);
end;

procedure TAllocItems.akePPD1Click(Sender: TObject);
var
  TempUnalloc, TempUnallocBase : Double;
  UOR : Byte;
begin
  //Allocate with PPD
  Allocate(3, True);
end;

//PR: 09/07/2015 As we've changed to taking PPD after SRC/PPY has been created, split original RunTakePPD function into PrepareTakePPD
//               and ExecuteTakePPD.
procedure TAllocItems.PrepareTakePPD;
var
  Res : Integer;
  KeyS : Str255;
  KeyChk : Str255;
begin
  TakePPDI.tpAccount := ExLocal.LCust;
  TakePPDI.tpDate := MULCtrlO.AllocCtrl.AllocCRec.arcTransDate;
  TakePPDI.tpYear := MULCtrlO.AllocCtrl.AllocCRec.arcTagRunYr;
  TakePPDI.tpPeriod := MULCtrlO.AllocCtrl.AllocCRec.arcTagRunPr;

  With MULCtrlO,AllocCtrl.AllocCRec do
    KeyS :=PartCCKey(MBACSCode,MBACSALSub)+TradeCode[arcSalesMode]+arcCustCode;

  KeyChk := KeyS;

  //Read through records and add any needing PPD to TakePPD object
  Res := Find_Rec(B_GetGEq, F[MiscF], MiscF, RecPtr[MiscF]^, MIK, KeyS);

  while (Res = 0) and (Copy(KeyS, 1, Length(KeyChk)) = KeyChk) do
  begin
    begin
      if MULCtrlO.Link2Inv then
        TakePPDI.AddInvoice(Inv, MiscRecs^.AllocSRec.ariPPDStatus > 0);
    end;

    Res := Find_Rec(B_GetNext, F[MiscF], MiscF, RecPtr[MiscF]^, MIK, KeyS);
  end;

end;

//Called after SRC/PPY has been created
function TAllocItems.ExecuteTakePPD: Boolean;
var
  Res : Integer;
begin
  //If TakePPD object has any invoices then call Execute
  if FTakePPD and (TakePPDI.tpInvoiceCount > 0) then
  begin
    TakePPDI.tpPayRec := Inv;
    Res := TakePPDI.Execute;
  end
  else
    Res := 0;

  Result := Res = 0;

  if not Result then
  begin
    ShowMessage('It was not possible to take the Prompt Payment Discounts. Error:'#10#13 + TakePPDI.tpErrorString + ' (' +
                 IntToStr(Res) + ')');
  end;

end;

Initialization

  AIFormMode:=BOff;

end.
