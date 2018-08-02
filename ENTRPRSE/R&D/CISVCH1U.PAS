unit CISVch1U;

interface

{$I DefOvr.Inc}

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ExtCtrls, SBSPanel,GlobVar,VarConst, VarRec2U,BTSupU1,ExWrap1U, BorBtns,
  SupListU,CustSupU,
  BTSupU3,
  SBSComp2, ExtGetU,
  Menus, TEditVal, Mask,
  {$IFDEF Ltr}
    Letters,
  {$ENDIF}

  CISVch2U;



type


 TCPMList  =  Class(TDDMList)
   Public
    NHCr       :  Byte;

    Function SetCheckKey  :  Str255; Override;

    Function SetFilter  :  Str255; Override;

    Function Ok2Del :  Boolean; Override;

    Function CheckRowEmph :  Byte; Override;

    Function Link2Inv  :  Boolean;

    Function OutLine(Col  :  Byte)  :  Str255; Override;


  end;






type
  TCISVList = class(TForm)
    CListBtnPanel: TSBSPanel;
    CSBox: TScrollBox;
    CHedPanel: TSBSPanel;
    CLORefLab: TSBSPanel;
    CLDueLab: TSBSPanel;
    CLYRefLab: TSBSPanel;
    CLOSLab: TSBSPanel;
    CLAMTLab: TSBSPanel;
    CLORefPanel: TSBSPanel;
    CLAMTPanel: TSBSPanel;
    CLOSPAnel: TSBSPanel;
    CLYRefPanel: TSBSPanel;
    CLDuePanel: TSBSPanel;
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
    CLSetCurrPanel: TSBSPanel;
    CLVarPanel: TSBSPanel;
    CLSetCLab: TSBSPanel;
    CLVarLab: TSBSPanel;
    TotPanel: TSBSPanel;
    Label82: Label8;
    CBalF: TCurrencyEdit;
    VarTotF: TCurrencyEdit;
    Label84: Label8;
    Label85: Label8;
    SDiscTotF: TCurrencyEdit;
    AlCP1Btn: TButton;
    PACP1Btn: TButton;
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
    View1: TMenuItem;
    Currency1: TMenuItem;
    PrintCP1Btn: TButton;
    Print1: TMenuItem;
    AutoLab: Label8;
    CLOSBPanel: TSBSPanel;
    CLOSCPanel: TSBSPanel;
    CLOSBLab: TSBSPanel;
    CLOSCLab: TSBSPanel;
    Check1: TMenuItem;
    CLLibPanel: TSBSPanel;
    CLLibLab: TSBSPanel;
    SetPayBtn: TButton;
    AllocatePIN1: TMenuItem;
    FiltCP1Btn: TButton;
    Filter1: TMenuItem;
    PopupMenu2: TPopupMenu;
    NoFillter1: TMenuItem;
    CIS23: TMenuItem;
    CIS24: TMenuItem;
    CIS25: TMenuItem;
    RCTDC: TMenuItem;
    RCT47: TMenuItem;
    PopupMenu3: TPopupMenu;
    Print2: TMenuItem;
    Print3: TMenuItem;
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
    procedure MACP1BtnClick(Sender: TObject);
    procedure PACP1BtnClick(Sender: TObject);
    procedure DelCP1BtnClick(Sender: TObject);
    procedure ViewCP1BtnClick(Sender: TObject);
    procedure SetPayBtnClick(Sender: TObject);
    procedure ChkCP1BtnClick(Sender: TObject);
    procedure NoFillter1Click(Sender: TObject);
    procedure FiltCP1BtnClick(Sender: TObject);
    procedure CurCP1BtnClick(Sender: TObject);
    procedure PrintCP1BtnClick(Sender: TObject);
    procedure Print2Click(Sender: TObject);
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
    FColorsChanged,
    fDoingClose,
    fLedgerMode,
    fNotCurrPeriod,
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

    StateTit     :  Str30;

    LastSValue   :  Str20;

    VchRec       :  TCISVoucher;

    UnAlVch      :  JobDetlRec;

    {$IFDEF Ltr}
      LetterActive: Boolean;
      LetterForm:   TLettersList;
    {$ENDIF}


    procedure Find_FormCoord;

    procedure Store_FormCoord(UpMode  :  Boolean);

    procedure FormSetOfSet;

    Function ScanMode  :  Boolean;

    procedure Display_Voucher(VMode       :  Byte;
                              VOMode      :  Boolean);

    procedure Display_Trans(Mode        :  Byte;
                            GlobalMode  :  Boolean);

    procedure Reset_Trans;

    Procedure WMCustGetRec(Var Message  :  TMessage); Message WM_CustGetRec;

    Procedure WMFormCloseMsg(Var Message  :  TMessage); Message WM_FormCloseMsg;

    Procedure WMGetMinMaxInfo(Var Message  :  TWMGetMinMaxInfo); Message WM_GetMinMaxInfo;

    

    Procedure Send_UpdateList(Mode   :  Integer);

    procedure ShowRightMeny(X,Y,Mode  :  Integer);

    Procedure  SetNeedCUpdate(B  :  Boolean);

    Property NeedCUpDate :  Boolean Read fNeedCUpDate Write SetNeedCUpdate;

    procedure Display_Match(ChangeFocus,
                            MatchMode     :  Boolean);

    Function FindxCode(KeyChk  :  Str255;
                       SM      :  SmallInt)  :  Boolean;

  public
    { Public declarations }

    ExLocal      :  TdExLocal;

    ListOfSet    :  Integer;

    MULCtrlO     :  TCPMList;

    DDownTitle   :  Str20;
    ColTagged    :  Boolean;

    CRepParam    :  CVATRepPtr;


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


  end;


Procedure Set_CIFormMode(State  :  CVATRepParam);

procedure Show_CISList(AOwner     :  TComponent;
                       CRepParam  :  CVATRepParam);


{~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~}

Implementation

{~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~}


Uses
  ETStrU,
  ETMiscU,
  ETDateU,
  BtrvU2,
  BTSupU2,
  BTKeys1U,
  BTSFrmU1,
  CmpCtrlU,
  ColCtrlU,
  SBSComp,
  ComnUnit,
  ComnU2,
  CurrncyU,

  {$IFDEF GF}
    FindCtlU,
  {$ENDIF}

  ExThrd2U,

  {$IFDEF Ltr}
    MSWord95,
  {$ENDIF}

  MatchU,
  LedgSu2U,
  DocSupU1,
  InvListU,
  SysU1,
  SysU2,
  Tranl1U,
  PWarnU,
  GenWarnU,
  APIUtil,
  SalTxl1U,
  IntMU,

  {$IFDEF RP}
    RepICI2U,
  {$ENDIF}

  {$IFDEF POST}
    CISSup2U,
  {$ENDIF}

  JobSup1U,

  ObjCISMU,
  BPWarnUU,
  JChkUseU,
  CISSup1U,
  // CJS 2014-06-09 - ABSEXCH-14981 - Unable to delete zero lines
  MathUtil
  ;




{$R *.DFM}

Var
  CIFormMode  :  CVATRepParam;


{ ========= Exported function to set View type b4 form is created ========= }

Procedure Set_CIFormMode(State  :  CVATRepParam);

Begin

  CIFormMode:=State;

end;


{$I CIT1U.PAS}





{ ====================================== Form Methods ===================================== }
{ ========================================================================================= }


Procedure  TCISVList.SetNeedCUpdate(B  :  Boolean);

Begin
  If (Not fNeedCUpdate) then
    fNeedCUpdate:=B;
end;

procedure TCISVList.Find_FormCoord;


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

    PrimeKey:='I';

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

    GetbtControlCsm(TotPanel);

    MULCtrlO.Find_ListCoord(GlobComp);

  end; {With GlobComp..}


  Dispose(GlobComp,Destroy);

    {NeedCUpdate}
  StartSize.X:=Width; StartSize.Y:=Height;

end;


procedure TCISVList.Store_FormCoord(UpMode  :  Boolean);


Var
  GlobComp:  TGlobCompRec;


Begin

  New(GlobComp,Create(BOff));

  With GlobComp^ do
  Begin
    GetValues:=UpMode;

    PrimeKey:='I';

    ColOrd:=Ord(StoreCoord);

    HLite:=Ord(LastCoord);

    SaveCoord:=StoreCoord;

    If (Not LastCoord) then {* Attempt to store last coord *}
      HLite:=ColOrd;

    StorebtControlCsm(Self);

    StorebtControlCsm(CBtnPanel);

    StorebtControlCsm(CSBox);

    StorebtControlCsm(CListBtnPanel);

    StorebtControlCsm(TotPanel);


    MULCtrlO.Store_ListCoord(GlobComp);

  end; {With GlobComp..}

  Dispose(GlobComp,Destroy);
end;



procedure TCISVList.FormSetOfSet;

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



{ ======= Link to Voucher display ======== }

procedure TCISVList.Display_Voucher(VMode       :  Byte;
                                    VOMode      :  Boolean);
Var
  WasNew  :  Boolean;

Begin

  {$B-}
  If (VMode In [1,4]) or (MULCtrlO.ValidLine) then
  {$B+}
  Begin
    If (VchRec=nil) then
    Begin
      If (VMode<>1) then
        SetCTMode:=JobDetl^.JobCISV.CISCType
      else
        SetCTMode:=ECISType2Voucher(JobMisc^.EmplRec.CISType,0.0,'');


      VchRec:=TCISVoucher.Create(Self);

      WasNew:=BOn;
    end
    else
      WasNew:=BOff;

      try

      With VchRec,MULCtrlO  do
      Begin
        If (VMode<>1) then
          ExLocal.AssignFromGlobal(JDetlF)
        else
        Begin
          ExLocal.AssignFromGlobal(JMiscF); {Employee}
          ExLocal.AssignFromGlobal(CustF);  {Supplier}
        end;

        If (WasNew) then
        Case VMode of
          1,2,4:  EditLine((VMode In [2,4]),VOMode,Keypath);
          3    :  DeleteBOMLine(JDetlF,Keypath);
        end {Case..}
        else
          VchRec.Show;
      end; {with..}

      except
        FreeandNil(VchRec);

      end;
  end;
end;



{ ======= Link to Trans display ======== }

procedure TCISVList.Display_Trans(Mode        :  Byte;
                                    GlobalMode  :  Boolean);

Var
  DispTrans  :  TFInvDisplay;
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


        If ((LastFolio<>LInv.FolioNum) or (Mode<>100)) and ((InHBeen) or (GlobalMode)) then
          {Display_Trans(Mode,LInv.FolioNum,BOff,(Mode<>100));}
          Display_Trans(100,LInv.FolioNum,BOff,BOff);

      end; {with..}

    except
      DispTransPtr:=nil;
      DispTrans.Free;

    end;

end;





{ ======= Reset Trans display ======== }

procedure TCISVList.Reset_Trans;

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




Function TCISVList.ScanMode  :  Boolean;

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



Procedure TCISVList.WMCustGetRec(Var Message  :  TMessage);

Var
  IMode  :  SmallInt;

Begin


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

              {If (GetInv(JobDetl^.JobCISv.CISVORef)) then
                Display_Trans(2+(98*IMode),BOff)
              else}
                If (IMode=0) then
                  Display_Voucher(2,Not CRepParam^.AllowEditCIS);

            end;

      2  :  ShowRightMeny(LParamLo,LParamHi,1);

      18 :  Begin
              Reset_Trans;

            end;

      25 :  NeedCUpdate:=BOn;

      55,56
          :  Begin
               Begin
                 SetButtons(BOn);

                 Enabled:=BOn;

                 Self.BringtoFront;

                 RefreshList(BOn,BOn);

                 Link2Tot;
               end;
             end; {Start List}

      65,66
          :  Begin {Lock and un lock ctrl during scan}


             end;

      67  :  Begin

             end;

      68  :  Begin {Start up process after ok from check}
               If (LParam<>0) then
                 CRepParam^:=CVATRepPtr(LParam)^;

               If (Not Self.Enabled) then
               Begin
                 SetButtons(BOn);

                 Enabled:=BOn;

                 Self.BringtoFront;
               end;

               Link2Tot;
             end;

       69   :  MACP1BtnClick(Nil);

      177   :  Begin
                 PrimeButtons(BOn);
               end;


      200   :  DispTransPtr:=nil;

      300   :  VchRec:=nil;

      301
            :  Begin
                 With MULCtrlO do
                 Begin
                   AddNewRow(MUListBoxes[0].Row,(LParam=1));
                 end;
              end;

      302   :  Begin
                 If (MULCtrlO.ValidLine) then
                 Begin
                   Update_CISScreenTotals(CRepParam^,JobDetl^,UnAlVch);

                 end;
               end;

      303   :  With MULCtrlO do
               Begin
                 If (MUListBox1.Row<>0) then
                   PageUpDn(0,BOn)
                  else
                    InitPage;
               end;

     {$IFDEF Ltr}
       400,
       401  : Begin
                LetterActive:=Boff;
                LetterForm:=nil;
              end;
     {$ENDIF}


    end; {Case..}

  end;
  Inherited;
end;



Procedure TCISVList.WMFormCloseMsg(Var Message  :  TMessage);

Var
  Locked  :  Boolean;

  PFix    :  Str5;
  Cnt     :  Int64;

Begin


  With Message do
  Begin


    Case WParam of

      179   :  Begin
                 MatchFormPtr:=nil;
               end;

      68    :  Begin {We need to update CISSyss}
                 Locked:=BOn;

                 With SyssCIS^.CISRates do
                 Begin
                   With CISVouchers[LParam] do
                   Begin
                     PFix:=Prefix;
                     Cnt:=Counter;
                   end;
                 end;

                 If (GetMultiSys(BOn,Locked,CISR)) then
                 Begin
                   With SyssCIS^.CISRates do
                   Begin
                     With CISVouchers[LParam] do
                     Begin
                       Prefix:=PFix;
                       Counter:=Cnt;
                     end;
                   end;

                   PutMultiSys(CISR,BOn);
                 end;

                 PostMessage(Self.Handle,WM_CustGetRec,303,0);
               end;

    end; {Case..}

  end;
  Inherited;
end;




{ == Procedure to Send Message to Get Record == }

Procedure TCISVList.Send_UpdateList(Mode   :  Integer);

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


Procedure TCISVList.WMGetMinMaxInfo(Var Message  :  TWMGetMinMaxInfo);

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

procedure TCISVList.SetCaption;

Var
  KeyJF,
  LevelStr  :  Str255;

Begin
  If (CurrentCountry=IECCode) then
    Caption:=CCCISName^+' '+GetIntMsg(4)+' Ledger.'
  else
    Caption:=CCCISName^+' Statement Ledger.';



  With CRepParam^ do
    If (CISSMode<>2) and (VSig='') then
      Caption:=Caption+' '+POutDate(VATStartD)+' - '+POutDate(VATEndD)
    else
    Begin
      Case CISSMode of
        0  :  Begin
                KeyJF:=Strip('R',[#0],PartCCKey(JARCode,JASubAry[3])+FullEmpCode(VSig));

               If (Global_GetMainRec(JMiscF,KeyJF)) then
               With JobMisc^,EmplRec do
                 Caption:=Caption+' '+dbFormatName(EmpCode,EmpName);
              end;

        1  :  Begin
                KeyJF:=FullCustCode(VSig);

               If (Global_GetMainRec(CustF,KeyJF)) then
               With Cust do
                 Caption:=Caption+' '+dbFormatName(CustCode,Company);
              end;
      end; {Case..}
    end;


end;



procedure TCISVList.FormDesign;


begin
  If (CurrentCountry=IECCode) then
  Begin
    SDiscTotF.Visible:=BOff;
    Label85.Visible:=BOff;
    VarTotF.Left:=SDiscTotF.Left;
    Label84.Left:=Label85.Left;
    CLAMTLab.Caption:='Net  ';
    Label84.Caption:='Net ';
    CLDueLab.Caption:=GetIntMsg(4);
    CIS23.Visible:=BOff;
    CIS24.Visible:=BOff;
    CIS25.Visible:=BOff;
    RCTDC.Visible:=BOn;
    RCT47.Visible:=BOn;
    Print2.Caption:=Print2.Caption+GetIntMsg(4);
    Print3.Caption:=Print3.Caption+GetIntMsg(4)+'s';

  end
  else
  Begin
    CLDueLab.Caption:='Statement';
    Print2.Caption:=Print2.Caption+'Statement';
    Print3.Caption:=Print3.Caption+'Statements';

    If (CIS340) then
    Begin
      CIS25.Caption:='High/Low Statements';
      CIS23.Caption:='Zero Rate Statements';
      CIS24.Visible:=BOff;

    end;
  end;


  TotPanel.Visible:=Not fLedgerMode;
  
  PrimeButtons(BOff);

end;


Procedure TCISVList.SetButtons(State  :  Boolean);


Begin
  CustBtnList.SetEnabBtn(State);

end;

procedure TCISVList.PrimeButtons(PWRef   :  Boolean);
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

    HideAge:=BOff;
    HideSetl:=BOff;

    try

      With CustBtnList do
        Begin
          {01} AddVisiRec(ALCP1Btn,fNotCurrPeriod or (Not ChkAllowed_In(251)));

          {02} AddVisiRec(PACP1Btn,(Not ChkAllowed_In(252)));

          {03} AddVisiRec(SetPayBtn,fNotCurrPeriod or (Not ChkAllowed_In(253)));
          {04} AddVisiRec(DelCP1Btn,(Not ChkAllowed_In(417)));
          {05} AddVisiRec(FiltCP1Btn,(Not ChkAllowed_In(418)));
          {06} AddVisiRec(FindCP1Btn,BOff);
          {07} AddVisiRec(MACP1Btn,(Not ChkAllowed_In(419)));

          {08} AddVisiRec(SetCP1Btn,BOn);

          {09} AddVisiRec(ViewCP1Btn,BOff);
          {10} AddVisiRec(CurCP1Btn,BOff);

          {11} AddVisiRec(PrintCP1Btn,(Not ChkAllowed_In(420)));

          {12} AddVisiRec(ChkCP1Btn,fLedgerMode or (Not ChkAllowed_In(421)));


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



procedure TCISVList.RefreshList(ShowLines,
                               IgMsg      :  Boolean);

Var
  KeyStart,
  KeyEnd      :  Str255;
  LKeypath,
  LKeyLen     :  Integer;

Begin

  With MULCtrlO, CRepParam^, SyssCIS^.CISRates do
  Begin
    SetCISListKeys(CRepParam^,KeyStart,KeyEnd,LKeypath);

    LKeyLen:=Length(KeyStart);



    IgnoreMsg:=IgMsg;

    StartList(JDetlF,LKeypath,KeyStart,KeyEnd,'',LKeyLen,(Not ShowLines));

    IgnoreMsg:=BOff;
  end;

end;



procedure TCISVList.FormBuildList(ShowLines  :  Boolean);

Var
  StartPanel  :  TSBSPanel;
  n           :  Byte;



Begin
  MULCtrlO:=TCPMList.Create(Self);


  Try

    With MULCtrlO do
    Begin

      //AP:11/10/2017 ABSEXCH-18533:CIS ledger
      Filter[1,1] := #0;

      Try

        With VisiList do
        Begin
     {0}  AddVisiRec(CLORefPanel,CLORefLab);
     {1}  AddVisiRec(CLYRefPanel,CLYRefLab);
     {2}  AddVisiRec(CLDuePanel,CLDueLab);
     {3}  AddVisiRec(CLOSPanel,CLOSLab);
     {4}  AddVisiRec(CLAMTPanel,CLAMTLab);
     {5}  AddVisiRec(CLSetCurrPanel,CLSetCLab);
     {6}  AddVisiRec(CLLibPanel,CLLibLab);
     {7}  AddVisiRec(CLVarPanel,CLVarLab);
     {8}  AddVisiRec(CLOSCPanel,CLOSCLab);
     {9}  AddVisiRec(CLOSBPanel,CLOSBLab);

          VisiRec:=List[0];

          StartPanel:=(VisiRec^.PanelObj as TSBSPanel);

          With CRepParam^ do
          Begin
            SetHidePanel(1,((CISSMode=0) and (VSig<>'')),BOff);
            SetHidePanel(9,((CISSMode=1) and (VSig<>'')),BOff);
          end;

          SetHidePanel(5,(CurrentCountry=IECCode),BOff);
          SetHidePanel(6,(CurrentCountry=IECCode),BOn);   {If base we do not need base o/s}

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
      MUTotCols:=9;
      Font:=StartPanel.Font;

      LinkOtherDisp:=BOff;

      WM_ListGetRec:=WM_CustGetRec;


      Parent:=StartPanel.Parent;

      MessHandle:=Self.Handle;

      For n:=0 to MUTotCols do
      With ColAppear^[n] do
      Begin
        AltDefault:=BOn;

        If (n In [4..7]) then
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

  FormReSize(Self);

  Link2Tot;
  {RefreshList(BOn,BOn);}

end;


procedure TCISVList.FormCreate(Sender: TObject);

Var
  n  :  Integer;

begin
  fDoingClose:=BOff;
  ExLocal.Create;

  fFrmClosing:=BOff;

  fFinishedOK:=BOff;

  LastCoord:=BOff;

  NeedCUpdate:=BOff;
  FColorsChanged := False;

  JustCreated:=BOn;

  OriginalTotal:=0.0;

  InitSize.Y:=333;
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

  RecMode:=BOff;

  New(Self.CRepParam);

  CRepParam^:=CIFormMode;

  LastSValue:='';

  If (CIS340) then
    StateTit:='Statement'
  else
    StateTit:=GetIntMsg(4);


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

  With CRepParam^ do
  Begin
    fLedgerMode:=((CISSMode In [0,1]) and (VSig<>''));
    fNotCurrPeriod:=((VATStartD>SyssCIS^.CISRates.Currperiod) or (VATEndD<SyssCIS^.CISRates.Currperiod));
  end;

  DDownTitle:='';

  FormDesign;

  FormBuildList(BOff);

end;



procedure TCISVList.FormDestroy(Sender: TObject);

Var
  n  :  Byte;
begin
  ExLocal.Destroy;


 end;


procedure TCISVList.FormCloseQuery(Sender: TObject;
                              var CanClose: Boolean);
Var
  n  : Integer;

  GenStr
     :  String;

begin
  If (Not fFrmClosing) then
  Begin
    fFrmClosing:=BOn;



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

      If (NeedCUpdate) And (StoreCoord Or FColorsChanged) then
        Store_FormCoord(Not SetDefault);

      Send_UpdateList(66);

      {* This check was placed here in v4.31 as if this screen had an item tagged whilst this
        screen & the main BP list were maximized, a major GPF occured *}

      If (WindowState=wsMaximized) then
        WindowState:=wsNormal;
    end;

    fFrmClosing:=BOff;

  end;
end;

procedure TCISVList.FormClose(Sender: TObject; var Action: TCloseAction);
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
      end;
    end;

    If (Assigned(CRepParam)) then
      Dispose(CRepParam);

  end;
end;


procedure TCISVList.FormResize(Sender: TObject);
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





procedure TCISVList.SetFormProperties;


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
        FColorsChanged := NeedCUpdate;

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

procedure TCISVList.ShowRightMeny(X,Y,Mode  :  Integer);

Begin
  With PopUpMenu1 do
  Begin

    PopUp(X,Y);
  end;


end;


procedure TCISVList.PopupMenu1Popup(Sender: TObject);

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



procedure TCISVList.PropFlgClick(Sender: TObject);
begin
  SetFormProperties;
end;

procedure TCISVList.StoreCoordFlgClick(Sender: TObject);
begin
  StoreCoord:=Not StoreCoord;
  NeedCUpdate:=BOn;
end;





procedure TCISVList.ClsCP1BtnClick(Sender: TObject);
begin
  Close;
end;


procedure TCISVList.CLORefPanelMouseUp(Sender: TObject;
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


procedure TCISVList.CLORefLabMouseMove(Sender: TObject; Shift: TShiftState;
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


procedure TCISVList.CLORefLabMouseDown(Sender: TObject;
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




procedure TCISVList.FormActivate(Sender: TObject);
begin
  If (Assigned(MULCtrlO))  then
    MULCtrlO.SetListFocus;

end;

procedure TCISVList.Link2Tot;

Var
  n    :  Byte;
  COrd :  Integer;

  Dnum,
  Unall:  Double;

Begin
  Dnum:=0.0;  Unall:=0.0;

  With CRepParam^ do
  Begin
    VarTotF.Value:=GrossTot; SDiscTotF.Value:=MatTot; CBalF.Value:=TriTot;
  end; {With..}
end;


procedure TCISVList.PACP1BtnClick(Sender: TObject);
Var
  AddMode  :  Byte;
  FoundOk,
  InpOk    :  Boolean;

  FoundCode:  Str20;

  SCode    :  String;


begin
  AddMode:=1+Ord((Sender=PACP1Btn) or (Sender=Recalc1));

  FoundOk:=BOff;

  If (AddMode=1) then
  Begin
    Repeat
      With CRepParam^ do
        If (Not fLedgerMode) or (CISSMode<>0) then
          InpOk:=InputQuery('Add a new '+StateTit,'Please enter the employee code for this '+StateTit,SCode)
        else
        Begin
          InpOk:=BOn;
          SCode:=FullEmpCode(VSig);
        end;

      If (InpOk) then
      Begin
        If (GetJobMisc(Self,SCode,FoundCode,3,11)) then
        With JobMisc^.EmplRec do
        Begin
          FoundOk:=(CISType>0) and (Etype=2) and (Global_GetMainRec(CustF,Supplier));

          If (Not FoundOk) then
            ShowMessage(StateTit+'s can only be added for sub contractors under the '+CCCISName^+' scheme, linked to a valid supplier.');
        end;
      end;

    Until (FoundOk) or (Not InpOk);

  end
  else
    FoundOk:=BOn;

  If (FoundOk) then
  Begin

    Display_Voucher(AddMode,BOff);
  end;

end;


procedure TCISVList.DelCP1BtnClick(Sender: TObject);
begin
  If (MULCtrlO.ValidLine) then
  With JobDetl^.JobCISV do
  Begin
    // CJS 2014-06-09 - ABSEXCH-14981 - Unable to delete zero lines
    If (ZeroFloat(CISVGrossTotal+CISVAutoTotalTax)) then
      Display_Voucher(3,BOff)
    else
      ShowMessage('It is only possible to delete '+StateTit+'s which have not been allocated to any transactions.');
  end;

  
end;

procedure TCISVList.ViewCP1BtnClick(Sender: TObject);
begin

  Display_Voucher(2,BOn);
end;

procedure TCISVList.SetPayBtnClick(Sender: TObject);

Const
  Fnum     =  InvF;
  IKeypath =  InvOurRefK;

Var
  LOk,
  LLocked,
  FoundOk,
  InpOk    :  Boolean;

  LAddr1,
  LAddr2   :  LongInt;

  FoundCode:  Str20;

  KeyChk,
  KeyS     :  Str255;

  CWorth,
  MGross,
  VWorth   :  Double;

  SCode    :  String;

  TmpRec   :  JobDetlRec;



begin
  FoundOk:=BOff; LOk:=BOff; LLocked:=BOff;

  CWorth:=0.0; VWorth:=0.0; MGross:=0.0;

  If (MULCtrlO.ValidLine) then
  With ExLocal do
  Begin
    Repeat

      InpOk:=InputQuery('Allocate Purchase Transaction to '+StateTit,'Please enter the transaction reference you wish to allocate against '+StateTit+' '+JobDetl^.JobCISV.CISCertNo,SCode);

      If (InpOk) then
      Begin
        KeyChk:=AutoSetInvKey(SCode,0);

        Status:=Find_Rec(B_GetEq,F[Fnum],Fnum,LRecPtr[Fnum]^,IKeyPath,KeyChk);

        {B-}
          With LInv do
          If (StatusOk) and (InvDocHed In CISDocSet) and (RunNo>0) and (CISEmpl=Copy(JobDetl^.JobCISV.CISVCode1,1,EmplKeyLen)) then
          Begin
            If (CurrSettled<>CISDeclared) then
            Begin
              FoundOk:=BOn;
            end
            else
              ShowMessage('That Transaction does not currently have any outstanding '+CCCISName^+' tax values.');

          end
          else
            ShowMessage('That Transaction reference is not valid.  Only posted purchase transactions for the same employee, with '+CCCISName^+' tax are valid.');

      end;

    Until (FoundOk) or (Not InpOk);

    If (FoundOk) then
    With MULCtrlO do
    Begin
      AssignFromGlobal(ScanFileNum);

      LGetRecAddr(ScanFilenum);

      LOk:=LGetMultiRec(B_GetDirect,B_MultLock,KeyS,KeyPAth,ScanFileNum,BOff,LLocked);

      If (LOk) and (LLocked) then
      Begin
        LGetRecAddr(Fnum);

        LOk:=LGetMultiRec(B_GetDirect,B_MultLock,KeyS,IKeyPAth,Fnum,BOff,LLocked);

        If (LOk) and (LLocked) then
        Begin
          TmpRec:=LJobDetl^;

          Update_CISVoucher(LJobDetl^,LInv,VWorth,MGross,CWorth,0);

          Update_CISScreenTotals(CRepParam^,LJobDetl^,TmpRec);

          Status:=Put_Rec(F[Fnum],Fnum,LRecPtr[Fnum]^,IKeyPAth);

          Report_BError(Fnum,Status);

          Status:=UnLockMLock(Fnum,LastRecAddr[Fnum]);

          Status:=Put_Rec(F[ScanFilenum],ScanFilenum,LRecPtr[ScanFilenum]^,KeyPAth);

          Report_BError(ScanFilenum,Status);

          PostMessage(Self.Handle,WM_CustGetRec,301,1);

          {* Generate match record *}

          Match_Voucher(LInv,FullOurRefKey(LJobDetl^.JobCISV.CISFolio),CWorth,VWorth,MGross,8);

          PostMessage(Self.Handle,WM_CustGetRec,69,0); {Show match}

          Link2Tot;

        end;
        Status:=UnLockMLock(ScanFilenum,LastRecAddr[ScanFilenum]);

      end;

    end;
  end;
end;


Function TCISVList.FindxCode(KeyChk  :  Str255;
                             SM      :  SmallInt)  :  Boolean;


Var
  OKeyS     :  Str255;
  OKeypath  :  Integer;

Begin
  Result:=BOff;

  OKeyS:=KeyChk;

  Case SM of
    0   :  OKeypath:=JDStkK;
  end; {case..}

  With MULCtrlO, CRepParam^ do
  Begin

    Status:=Find_Rec(B_GetGEq,F[ScanFileNum],ScanFileNum,RecPtr[ScanFileNum]^,OKeyPath,OKeyS);

    If (Status=0) and (CheckKey(KeyChk,OKeyS,Length(KeyChk),BOff)) then
    Begin
      If (LineOk(SetCheckKey)) then
      Begin

        Result:=BOn;
        Status:=GetPos(F[ScanFileNum],ScanFileNum,PageKeys^[0]);

        MUListBoxes[0].Row:=0;
        PageUpDn(0,BOn);
      end
      else
      Begin
        Display_Voucher(4,BOn);
      end;
    end;
  end; {With..}

end;


procedure TCISVList.FindCP1BtnClick(Sender: TObject);

Var
  FoundOk,
  InpOk    :  Boolean;

  SCode    :  String;


begin
  FoundOk:=BOff;

  InpOk:=InputQuery('Find a '+StateTit,'Please enter the '+StateTit+' number you wish to search for',SCode);

  If (InpOk) then
    FindxCode(UpCaseStr(CISPrefix+SCode),0);

end; {Proc..}



Function TCISVList.GetInv(ORef  :  Str10)  :  Boolean;

Const
  Fnum    =  InvF;
  Keypath =  InvOurRefK;

Var
  KeyS      :  Str255;
  GStatus   :  Integer;

Begin
  KeyS:=ORef;

  With ExLocal do
  If (LInv.OurRef<>ORef) and (ORef<>'') then
  Begin
    GStatus:=Find_Rec(B_GetEq,F[Fnum],Fnum,LRecPtr[Fnum]^,KeyPath,KeyS);

    If (GStatus=0) then
      AssignToGlobal(Fnum);
  end
  else
    GStatus:=0+(4*Ord(ORef=''));

  Result:=(GStatus=0);

end;



procedure TCISVList.Display_Match(ChangeFocus,
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



procedure TCISVList.MACP1BtnClick(Sender: TObject);
Var
  DispTrans  :  TObjCFrm;
  NewNow     :  Boolean;
  AlMode     :  Byte;
Begin
  NewNow:=BOff;


  If (MULCtrlO.ValidLine) then
  Begin
    AlMode:=Ord((Sender=SetPayBtn) or (Sender=AllocatePin1));

    {$B-}
    If (AlMode=0) or (Copy(JobDetl^.JobCISV.CISVCode2,1,LDateKeyLen)=SyssCIS^.CISRates.CurrPeriod) then
    {$B+}
    Begin
      UnAlVch:=JobDetl^;

      If (MatchFormPtr=nil) then
      Begin
        SetOCMMode(AlMode);

        DispTrans:=TObjCFrm.Create(Self);
        MatchFormPtr:=DispTrans;
        NewNow:=BOn;
      end
      else
        DispTrans:=MatchFormPtr;

        try
          If (Not NewNow) then
            DispTrans.BuildObjectDrill;


          DispTrans.Show;


        except

          DispTrans.Free;

        end;
    end
    else
      ShowMessage('Allocation is only possible for '+StateTit+'s belonging to the current '+CCCISName^+' period.');
  end;

end;






procedure TCISVList.ChkCP1BtnClick(Sender: TObject);
begin
  {$IFDEF POST}
    If (Not fLedgerMode) then {Taken out as ledger view is for all time, could take a while to calc!}
    Begin
      AddCISScan2Thread(Self,CRepParam^,Self.Handle,1);

      If (Self.Visible) then
      Begin
        SetButtons(BOff);

        Self.Enabled:=BOff;
      end;
    end;

  {$ENDIF}
end;

procedure TCISVList.NoFillter1Click(Sender: TObject);
begin
  If (Sender is TMenuItem) then
  With MULCtrlO  do
  Begin
    Case TMenuItem(Sender).Tag of
      0  :  Filter[1,0]:='';
      else  Filter[1,0]:=Char(TMenuItem(Sender).Tag);
    end;

    RefreshList(BOn,BOn);

  end;
end;

procedure TCISVList.FiltCP1BtnClick(Sender: TObject);
Var
  ListPoint  :  TPoint;

begin
  With TWinControl(Sender) do
  Begin
    GetCursorPos(ListPoint);

    With ListPoint do
    Begin
      X:=X-50;
      Y:=Y-15;
    end;

  end;

  PopUpMenu2.PopUp(ListPoint.X,ListPoint.Y);

end;


procedure TCISVList.PrintCP1BtnClick(Sender: TObject);
Var
  ListPoint  :  TPoint;

begin
  With TWinControl(Sender) do
  Begin
    GetCursorPos(ListPoint);

    With ListPoint do
    Begin
      X:=X-50;
      Y:=Y-15;
    end;

  end;

  PopUpMenu3.PopUp(ListPoint.X,ListPoint.Y);

end;



procedure TCISVList.CurCP1BtnClick(Sender: TObject);

{$IFDEF Ltr}

  Var
    KeyJF  :  Str255;
    CustPtr: CustRecPtr;
    EmpPtr : JobMiscPtr;
{$ENDIF}

begin
  {$IFDEF Ltr}
    { Create form if not already created }
    {$B-}
    If (MUlCtrlO.ValidLine) then
    Begin
      If Not Assigned (LetterForm) Then
    {$B+}
      Begin
        { Create letters form }
        LetterForm := TLettersList.Create (Self);
      End; { If }

      Try
        { mark form as active }
        LetterActive := BOn;

        EmpPtr:=Nil; CustPtr:=Nil;

        { Display form }
        LetterForm.WindowState := wsNormal;
        LetterForm.Show;

        With JobDetl^.JobCISV Do
        Begin
          KeyJF:=Strip('R',[#0],PartCCKey(JARCode,JASubAry[3])+FullEmpCode(Copy(CISvCode1,1,EmplKeyLen)));

          { Get CIS Employee }
          If (Global_GetMainRec(JMiscF,KeyJF)) then
            EmpPtr:=JobMisc;

          KeyJF:=FullCustCode(Copy(CISvSDate,1,CustKeyLen));

          { Get CIS Supplier }
          If (Global_GetMainRec(CustF,KeyJF)) then
            CustPtr:=@Cust;

          LetterForm.LoadLettersFor (CISFolio,
                                     StateTit+' No. '+CISCertNo,
                                     CCCIsName^,
                                     LetterCISCode,
                                     CustPtr, Nil, Nil, Nil, EmpPtr);
        End; { With }
      Except
       LetterActive := BOff;
       LetterForm.Free;
      End;
    end; {If..}  
  {$ENDIF}

end;


procedure TCISVList.Print2Click(Sender: TObject);
begin
  {$IFDEF RP}
    If (Sender is TMenuItem) then
    Begin
      VoucherList_Report(TMenuItem(Sender).Tag,CRepParam^,Self);
    end;
  {$ENDIF}
end;


procedure Show_CISList(AOwner     :  TComponent;
                       CRepParam  :  CVATRepParam);

Var
  BPay  :  TCISVList;

Begin
  Set_CIFormMode(CRepParam);


  BPay:=TCISVList.Create(AOwner);


  try
    With BPay do
    Begin
      SetCaption;


      ChkCP1BtnClick(Nil);

      RefreshList(BOn,BOn);
    end;
  except
    BPay.Free;

  end;

end;




Initialization

  FillChar(CIFormMode,SizeOf(CIFormMode),#0);

end.
