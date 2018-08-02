unit BankRCU;

interface

{$I DEFOvr.Inc}

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, TEditVal, ExtCtrls, SBSPanel, ComCtrls,
  GlobVar,VarConst,BTSupU1,ExWrap1U,

  {$IFDEF Post}
    Recon3U,
    PostingU,

  {$ENDIF}

  BankRMMU,

  BankEntU, Menus;






type
  TBankARec = class(TForm)
    PageControl1: TPageControl;
    ItemPage: TTabSheet;
    D1SBox: TScrollBox;
    D1HedPanel: TSBSPanel;
    D1PayLab: TSBSPanel;
    D1StatLab: TSBSPanel;
    D1RefLab: TSBSPanel;
    D1RefPanel: TSBSPanel;
    D1PayPanel: TSBSPanel;
    D1ListBtnPanel: TSBSPanel;
    TotalPanel: TSBSPanel;
    Label82: Label8;
    Label81: Label8;
    TotPay: TCurrencyEdit;
    TotRec: TCurrencyEdit;
    D1BtnPanel: TSBSPanel;
    D1BSBox: TScrollBox;
    AddD1Btn: TButton;
    EditCD1Btn: TButton;
    DelD1Btn: TButton;
    FindD1Btn: TButton;
    ChkD1Btn: TButton;
    BankD1Btn: TButton;
    RepD1Btn: TButton;
    MatchD1Btn: TButton;
    Clsd1Btn: TButton;
    D1RecPanel: TSBSPanel;
    D1StatPanel: TSBSPanel;
    D1RecLab: TSBSPanel;
    Label83: Label8;
    Label84: Label8;
    TotOB: TCurrencyEdit;
    TotCB: TCurrencyEdit;
    ProcD1Btn: TButton;
    PopupMenu1: TPopupMenu;
    Find1: TMenuItem;
    N2: TMenuItem;
    PropFlg: TMenuItem;
    N1: TMenuItem;
    StoreCoordFlg: TMenuItem;
    Add1: TMenuItem;
    Edit1: TMenuItem;
    Delete1: TMenuItem;
    BankRec1: TMenuItem;
    Match1: TMenuItem;
    Report1: TMenuItem;
    Process1: TMenuItem;
    Check1: TMenuItem;
    PopupMenu2: TPopupMenu;
    Amount1: TMenuItem;
    Details1: TMenuItem;
    PopupMenu3: TPopupMenu;
    AllEntries1: TMenuItem;
    UnmatchedEntries1: TMenuItem;
    MatchedEntries1: TMenuItem;
    NewEntries1: TMenuItem;
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
    procedure FindD1BtnClick(Sender: TObject);
    procedure RepD1BtnClick(Sender: TObject);
    procedure AddD1BtnClick(Sender: TObject);
    procedure DelD1BtnClick(Sender: TObject);
    procedure Amount1Click(Sender: TObject);
    procedure ChkD1BtnClick(Sender: TObject);
    procedure MatchD1BtnClick(Sender: TObject);
    procedure BankD1BtnClick(Sender: TObject);
    procedure AllEntries1Click(Sender: TObject);
  private
    InHBeen,
    TagClearMode,
    RecMode,
    BeenIn,
    JustCreated,
    StoreCoord,
    LastCoord,
    SetDefault,
    fNeedCUpdate,
    fFrmClosing,
    fDoingClose,
    GotCoord,
    CanDelete    :  Boolean;

    PagePoint    :  Array[0..4] of TPoint;

    BPTots       :  Array[0..3] of TCurrencyEdit;

    BPBtns       :  Array[0..9] of TButton;


    StartSize,
    InitSize     :  TPoint;

    ValRec       :  TReconEnt;

    DispTransPtr
                 :  Pointer;

    PayInFormPtr :  Pointer;

    ManBList     :  TBankRecMM;





    procedure Find_FormCoord;

    procedure Store_FormCoord(UpMode  :  Boolean);

    procedure FormSetOfSet;

    Procedure WMCustGetRec(Var Message  :  TMessage); Message WM_CustGetRec;

    Procedure WMFormCloseMsg(Var Message  :  TMessage); Message WM_FormCloseMsg;

    Procedure WMGetMinMaxInfo(Var Message  :  TWMGetMinMaxInfo); Message WM_GetMinMaxInfo;

    

    Procedure Send_UpdateList(Mode   :  Integer);

    procedure ShowRightMeny(X,Y,Mode  :  Integer);

    Procedure  SetNeedCUpdate(B  :  Boolean);

    Property NeedCUpDate :  Boolean Read fNeedCUpDate Write SetNeedCUpdate;

    procedure Link2Tot;


    Procedure Refresh_BankMCtrl;

    Procedure SetButtons(State  :  Boolean);


    procedure SetCaption;

    procedure Display_ValRec(Mode  :  Byte);

    Function CheckWarn(Mode  :  Byte)  :  Word;

    procedure Display_Trans(Mode    :  Byte;
                            MFolio  :  LongInt);

    procedure Display_PayIn(ChangeFocus   :  Boolean);

    Procedure Display_MatchDoc(Mode,LMode  :  Byte);

    Function ScanMode  :  Boolean;

    procedure Show_ItemList(LUpdate  :  Boolean);

    procedure Run_Process(Mode  :  Byte);

    procedure RunReport(Mode,SMode  :  Byte);

  public
    { Public declarations }

    ExLocal      :  TdExLocal;

    BankMCtrl    :  PassWordRec;

    CtrlNom      :  LongInt;

    CtrlCr       :  Byte;

    ListOfSet    :  Integer;

    MULCtrlO     :  TBRMList;



    procedure FormDesign;

    procedure RefreshList(ShowLines,
                          IgMsg      :  Boolean);

    procedure FormBuildList(ShowLines  :  Boolean);

    procedure SetFormProperties;

  end;

Procedure Set_ABRFormMode(BCr    :  Byte;
                          TRNo   :  LongInt);

Function Check_BRecAlready(CNom  :  LongInt;
                           CCr   :  Byte)  :  Boolean;


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

  {$IFDEF DBD}
    DebugU,
  {$ENDIF}

  SysU1,
  SysU2,

  {$IFDEF POST}
    BankRS2U,
  {$ENDIF}

  {$IFDEF Frm}
    RPDefine,
    PrintFrm,
  {$ENDIF}

  BankRCSU,
  SalTxl1U,
  BnkWarnU,
  Tranl1U,
  NLPayInU,

  {$IFDEF Rp}
    ReportJU,
  {$ENDIF}

  {$IFDEF EXSQL}
    SQLUtils,
  {$ENDIF}

  ExThrd2U;


{$R *.DFM}



{ ========= Exported function to set View type b4 form is created ========= }

Procedure Set_ABRFormMode(BCr    :  Byte;
                          TRNo   :  LongInt);


Begin

  BRCr:=BCr;
  BRNomCtrl:=TRNo;

end;





{ =========== Function to Check if Same Nomcode + Cr already running ========== }


Function Check_BRecAlready(CNom  :  LongInt;
                           CCr   :  Byte)  :  Boolean;

Var
  n  :  Integer;



Begin
  Result:=BOff;

  With Screen do
    For n:=0 to Pred(FormCount) do
      If (Forms[n] is TBankARec) then
        With TBankARec(Forms[n]) do
          If (Not Result) then
            Result:=((CtrlNom=CNom) and (CtrlCr=CCr));



end;



{$IFDEF POST}

Type
  TCheckBank      =  Object(TEntPost)

                     private
                       BankMCtrl  :  PassWordRec;
                       CtrlNom    :  LongInt;
                       CtrlCr     :  Byte;
                       KeyRef     :  Str255;
                       CallBackH  :  THandle;


                       Procedure Check_BankMatch(Fnum,
                                                 Keypath  :  Integer);

                     public
                       Constructor Create(AOwner  :  TObject);

                       Destructor  Destroy; Virtual;

                       Procedure Process; Virtual;
                       Procedure Finish;  Virtual;

                       Function Start(BCtrl    :  PassWordRec;
                                      CCtrl    :  LongInt;
                                      CCr      :  Byte;
                                      KeyChk   :  Str255;
                                      InpWinH  :  THandle)  :  Boolean;

                   end; {Class..}



  { ========== TCheckBank methods =========== }

  Constructor TCheckBank.Create(AOwner  :  TObject);

  Begin
    Inherited Create(AOwner);

    fTQNo:=3;
    fCanAbort:=BOn;

    IsParentTo:=BOn;

    fOwnMT:=BOn; {* This must be set if MTExLocal is created/destroyed by thread *}

    MTExLocal:=nil;

  end;

  Destructor TCheckBank.Destroy;

  Begin
    Inherited Destroy;
  end;



{ ======= Procedure to Recalculate Match Totals ======== }


Procedure TCheckBank.Check_BankMatch(Fnum,
                                     Keypath  :  Integer);


Var
  KeyS   :  Str255;
  ICount :  LongInt;



Begin

  ICount:=BankMCtrl.BankCRec.MatchCount;

  If (ICount<1) then
    ICount:=1;


  BankM_CtrlCalc(PWrdF,PWK,CtrlNom,CtrlCr,0,BOff,BOff,BOn,BankMCtrl,MTExLocal);

  KeyS:=KeyRef;

  With MTExLocal^,BankMCtrl.BankCRec do
  Begin
    ManCount:=0;
    MatchCount:=-1;

    InitProgress(ICount);
    ICount:=0;

    LStatus:=LFind_Rec(B_GetGEq,Fnum,KeyPath,KeyS);

    While (LStatusOk) and (CheckKey(KeyRef,KeyS,Length(KeyRef),BOn)) and (Not ThreadRec^.THAbort) do
    With LMiscRecs^.BankMRec do
    Begin

      ShowStatus(1,'Checking '+BankRef);

      BankM_CtrlCalc(PWrdF,PWK,CtrlNom,CtrlCr,BankValue,BOff,BOff,BOff,BankMCtrl,MTExLocal);

      LStatus:=LFind_Rec(B_GetNext,Fnum,KeyPath,KeyS);

      Inc(ICount);

      UpdateProgress(ICount);

    end;


    BankM_CtrlCalc(PWrdF,PWK,CtrlNom,CtrlCr,0,BOn,BOn,BOff,BankMCtrl,MTExLocal);
  end;

end; {Proc..}




  Procedure TCheckBank.Process;

  Begin
    InMainThread:=BOn;

    Inherited Process;

    ShowStatus(0,'Check Automatic Bank Reconciliation');


    Check_BankMatch(MiscF,MIK);

  end;


  Procedure TCheckBank.Finish;
  Begin
    Inherited Finish;

    {Overridable method}

    InMainThread:=BOff;

    {* Inform input window batch has been calculated *}

    SendMessage(CallBackH,WM_CustGetRec,55,0);

  end;



  Function TCheckBank.Start(BCtrl    :  PassWordRec;
                            CCtrl    :  LongInt;
                            CCr      :  Byte;
                            KeyChk   :  Str255;
                            InpWinH  :  THandle)  :  Boolean;

  Var
    mbRet  :  Word;
    KeyS   :  Str255;

  Begin
    Result:=BOn;

    Begin
      If (Not Assigned(MTExLocal)) then { Open up files here }
      Begin
        {$IFDEF EXSQL}
        if SQLUtils.UsingSQL then
        begin
          // CJS - 18/04/2008: Thread-safe SQL Version (using unique ClientIDs)
          if (not Assigned(LPostLocal)) then
            Result := Create_LocalThreadFiles;

          If (Result) then
            MTExLocal := LPostLocal;

        end
        else
        {$ENDIF}
        begin
          New(MTExLocal,Create(15));

          try
            With MTExLocal^ do
              Open_System(PWrdF,MiscF);

          except
            Dispose(MTExLocal,Destroy);
            MTExLocal:=nil;

          end; {Except}

          Result:=Assigned(MTExLocal);
        end;
      end;
      If (Result) then
      Begin
        BankMCtrl:=BCtrl;
        CallBackH:=InpWinH;
        CtrlNom:=CCtrl;
        CtrlCr:=CCr;
        KeyRef:=KeyChk;

      end;
    end;
    {$IFDEF EXSQL}
    if Result and SQLUtils.UsingSQL then
    begin
      MTExLocal^.Close_Files;
      CloseClientIdSession(MTExLocal^.ExClientID, False);
    end;
    {$ENDIF}
  end;

{ ============== }



Procedure AddBankChk2Thread(AOwner   :  TObject;
                            BCtrl    :  PassWordRec;
                            CCtrl    :  LongInt;
                            CCr      :  Byte;
                            KeyChk   :  Str255;
                            MyHandle :  THandle);


  Var
    LCheck_Batch :  ^TCheckBank;

  Begin

    If (Create_BackThread) then
    Begin
      New(LCheck_Batch,Create(AOwner));

      try
        With LCheck_Batch^ do
        Begin
          If (Start(BCtrl,CCtrl,CCr,KeyChk,MyHandle)) and (Create_BackThread) then
          Begin
            With BackThread do
              AddTask(LCheck_Batch,'Bnk Rec Check');
          end
          else
          Begin
            Set_BackThreadFlip(BOff);
            Dispose(LCheck_Batch,Destroy);
          end;
        end; {with..}

      except
        Dispose(LCheck_Batch,Destroy);

      end; {try..}
    end; {If process got ok..}

  end;


{$ENDIF}


Procedure  TBankARec.SetNeedCUpdate(B  :  Boolean);

Begin
  If (Not fNeedCUpdate) then
    fNeedCUpdate:=B;
end;

procedure TBankARec.Find_FormCoord;


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

    PrimeKey:='B';

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

    GetbtControlCsm(D1SBox);

    GetbtControlCsm(D1ListBtnPanel);

    GetbtControlCsm(D1BtnPanel);

    MULCtrlO.Find_ListCoord(GlobComp);

  end; {With GlobComp..}


  Dispose(GlobComp,Destroy);

    {NeedCUpdate}
  StartSize.X:=Width; StartSize.Y:=Height;

end;


procedure TBankARec.Store_FormCoord(UpMode  :  Boolean);


Var
  GlobComp:  TGlobCompRec;


Begin

  New(GlobComp,Create(BOff));

  With GlobComp^ do
  Begin
    GetValues:=UpMode;

    PrimeKey:='B';

    ColOrd:=Ord(StoreCoord);

    HLite:=Ord(LastCoord);

    SaveCoord:=StoreCoord;

    If (Not LastCoord) then {* Attempt to store last coord *}
      HLite:=ColOrd;

    StorebtControlCsm(Self);


    StorebtControlCsm(PageControl1);

    StorebtControlCsm(d1SBox);

    StorebtControlCsm(d1BtnPanel);

    StorebtControlCsm(d1ListBtnPanel);


    MULCtrlO.Store_ListCoord(GlobComp);

  end; {With GlobComp..}

  Dispose(GlobComp,Destroy);
end;



procedure TBankARec.FormSetOfSet;

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



  GotCoord:=BOn;

end;


procedure TBankARec.Link2Tot;

Var
  n        :  Byte;

  NomBal,
  Purch,
  Sales,
  Cleared,

  Dnum     :  Double;

Begin
  DNum := 0;
  With BankMCtrl.BankCRec do
  Begin

    NomBal:=0;
    Purch:=0;
    Sales:=0;
    Cleared:=0;

    For n:=Low(BPTots) to High(BPTots) do
    With MULCtrlO.VisiList do
    Begin
      Case n of
        0  :  Begin
                NomBal:=Profit_To_Date(NomEntTyp,FullNomKey(BankNom),BankCr,GetLocalPr(0).CYr,GetLocalPr(0).CPr,Purch,Sales,Cleared,BOn);

                Dnum:=Cleared;

                MatchOBal:=Dnum;

              end;

        1  :  Dnum:=EntryTotDr;

        2  :  Dnum:=EntryTotCr;

        3  :  Dnum:=Cleared+(EntryTotCr-EntryTotDr);

      end; {Case..}


      With BPTots[n] do
      Begin
        CurrencySymb:=SSymb(CtrlCr);
        Value:=Dnum;
      end;
    end;

  end; {With..}
end;


Procedure TBankARec.SetButtons(State  :  Boolean);

Var
  n  :  Byte;

Begin
  For n:=Low(BPBtns) to High(BPBtns) do
    BPBtns[n].Enabled:=State;

end;


Procedure TBankARec.Refresh_BankMCtrl;

Begin

  BankM_CtrlGet(PwrdF,PWK,CtrlNom,CtrlCr,BankMCtrl,nil);


end;


{ ======= Link to Trans display ======== }

procedure TBankARec.Display_Trans(Mode    :  Byte;
                                  MFolio  :  LongInt);

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

      With ExLocal,DispTrans do
      Begin
        
        If ((LastFolio<>MFolio) or (Mode<>100)) and (InHBeen) then
        Begin
          If (WasNew) and (MFolio<>0) then
            LastDocHed:=Run
          else
            LastDocHed:=Inv.InvDocHed;

          Display_Trans(Mode,MFolio,(MFolio<>0),(Mode<>100));

        end;

      end; {with..}

    except

      DispTrans.Free;

    end;

end;


procedure TBankARec.Display_PayIn(ChangeFocus   :  Boolean);


Var
  NomNHCtrl  :  TNHCtrlRec;

  FoundLong  :  Longint;

  PayInForm  :  TPayInWin;

  WasNew     :  Boolean;

Begin

  WasNew:=BOff;

  With EXLocal,NomNHCtrl do
  Begin
    FillChar(NomNHCtrl,Sizeof(NomNHCtrl),0);

    NHMode:=0;

    NHCr:=CtrlCr;

    With MiscRecs^.BankMRec do
      MainK:=Full_PostPayInKey(PayInCode,CtrlNom,CtrlCr,BankRef);

    NHKeyLen:=Length(MainK);

    Set_PIFormMode(NomNHCtrl);

    Id.StockCode:=Full_PostPayInKey(PayInCode,0,0,MiscRecs^.BankMRec.BankRef);

  end;

  If (PayInFormPtr=nil) then
  Begin
    WasNew:=BOn;

    PayInForm:=TPayInWin.Create(Self);

    PayInFormPtr:=PayInForm;

  end
  else
    PayInForm:=PayInFormPtr;

  Try

   With PayInForm do
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

   PayInFormPtr:=nil;

   PayInForm.Free;
   PayInForm:=nil;

  end; {try..}


end;


Procedure TBankARec.Display_MatchDoc(Mode,LMode  :  Byte);


Var
  KeyS,
  KeyChk   :  Str255;

  RecAddr  :  LongInt;


Begin


  With MiscRecs^.BankMRec do
  Begin


    If (Not EmptyKey(BankRef,BankRLen)) then
    Begin


      If (UsePayIn) then
      Begin
        If (PayInFormPtr<>nil) or (LMode=0) then
          Display_PayIn(BOn);
      end
      else
      Begin
        Display_Trans(Mode,MatchFolio);

      end;
    end; {If..}

  end; {With..}

end; {Proc..}


Function TBankARec.ScanMode  :  Boolean;

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



Procedure TBankARec.WMCustGetRec(Var Message  :  TMessage);


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

              If (WParam=1) then
                Link2Tot;

              With MiscRecs^.BankMRec do
              Begin
                If (MatchDoc<>'') then
                Begin
                  InHBeen:=((WParam=0) or ((InHBeen) and ScanMode));

                  If (InHBeen) then
                    Display_MatchDoc(2+(98*IMode),WParam);
                end
                else
                  If (WParam<>1) then
                    Display_ValRec(2);
              end;


            end;


      2  :  ShowRightMeny(LParamLo,LParamHi,1);

      25 :  NeedCUpdate:=BOn;

      55 :  Begin
              Enabled:=BOn;
              {WindowState:=wsNormal;}

              If (Assigned(ManBList)) then
                ManBList.SetFormStatus(BOn,BOff);

              SetButtons(BOn);

              {BACS_CtrlGet(PWrdF,PWK,BatchCtrl,RecMode,nil);}

              RefreshList(BOn,BOn);


              Show;

            end;

      56 :  Begin
              SendMessage(Self.Handle,WM_Close,0,0);

            end;

      65 :  Begin
              Enabled:=BOn;
              SetButtons(BOn);

              If (Assigned(ManBList)) then
              Begin
                ManBList.SetFormStatus(BOn,BOff);
              end;

              Refresh_BankMCtrl;

              Show_ItemList(BOn);

            end;

      66 :  BankD1BtnClick(nil);

      67 :  Run_Process(2);

      68 :  RunReport(2,0);

      70 :  Begin
              ManBList:=Nil;
            end;

      80 :  ;

     118 :  With MULCtrlO do
             Begin

               AddNewRow(MUListBoxes[0].Row,(LParam=1));


             end;

      119 : With MULCtrlO do
            Begin

              If (MUListBox1.Row<>0) then
               PageUpDn(0,BOn)
             else
               InitPage;
            end;

      200  :  DispTransPtr:=nil;

      204  :  ValRec:=nil;

    end; {Case..}


    If (WParam In [55,80,118,119]) then
    Begin
      BankM_CtrlGet(PWrdF,PWK,CtrlNom,CtrlCr,BankMCtrl,nil);

      Link2Tot;
    end;
  end;
  Inherited;
end;


Procedure TBankARec.WMFormCloseMsg(Var Message  :  TMessage);


Begin

  With Message do
  Begin

    Case WParam of

      45 :  Begin
              PayInFormPtr:=nil;
            end;

      65
         :  Begin
              InHBeen:=((WParam=65) or (InHBeen));

              Display_Trans(99,0);
            end;


    end; {Case..}

  end;

  Inherited;
end;


{ == Procedure to Send Message to Get Record == }

Procedure TBankARec.Send_UpdateList(Mode   :  Integer);

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


Procedure TBankARec.WMGetMinMaxInfo(Var Message  :  TWMGetMinMaxInfo);

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

procedure TBankARec.FormDesign;


begin


end;





procedure TBankARec.RefreshList(ShowLines,
                               IgMsg      :  Boolean);

Var
  KeyStart    :  Str255;
  LKeypath,
  LKeyLen     :  Integer;

Begin

  KeyStart:=FullBankMKey(MBankHed,MBankSub,CtrlNom,CtrlCr);

  LKeyLen:=Length(KeyStart);

  With MULCtrlO do
  Begin
    IgnoreMsg:=IgMsg;

    StartList(MiscF,MIK,KeyStart,'','',LKeyLen,(Not ShowLines));

    IgnoreMsg:=BOff;
  end;

end;



procedure TBankARec.FormBuildList(ShowLines  :  Boolean);

Var
  StartPanel  :  TSBSPanel;
  n           :  Byte;



Begin
  MULCtrlO:=TBRMList.Create(Self);
  StartPanel := nil;

  Try

    With MULCtrlO do
    Begin


      Try

        With VisiList do
        Begin
          AddVisiRec(D1RefPanel,D1RefLab);
          AddVisiRec(D1PayPanel,D1PayLab);
          AddVisiRec(D1RecPanel,D1RecLab);
          AddVisiRec(D1StatPanel,D1StatLab);

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




      Find_FormCoord;

      TabOrder := -1;
      TabStop:=BOff;
      Visible:=BOff;
      BevelOuter := bvNone;
      ParentColor := False;
      Color:=StartPanel.Color;
      MUTotCols:=3;
      Font:=StartPanel.Font;

      LinkOtherDisp:=BOn;

      WM_ListGetRec:=WM_CustGetRec;


      Parent:=StartPanel.Parent;

      MessHandle:=Self.Handle;

      For n:=0 to MUTotCols do
      With ColAppear^[n] do
      Begin
        AltDefault:=BOn;

        If (n In [1,2]) then
        Begin
          DispFormat:=SGFloat;
          NoDecPlaces:=2;
        end;
      end;

      DisplayMode:=1;
      
      ListLocal:=@ExLocal;

      ListCreate;

      UseSet4End:=BOff;

      NoUpCaseCheck:=BOn;

      HighLiteStyle[1]:=[fsBold];

      Set_Buttons(D1ListBtnPanel);

      ReFreshList(ShowLines,BOff);

    end {With}


  Except

    MULCtrlO.Free;
    MULCtrlO:=Nil;
  end;



  FormSetOfSet;

  FormReSize(Self);

  {RefreshList(BOn,BOn);}

end;


procedure TBankARec.SetCaption;

Var
  LevelStr  :  Str255;

Begin
  With Nom do
  Begin
    If (Nom.NomCode<>CtrlNom) then
      Global_GetMainRec(NomF,FullNomKey(CtrlNom));

    LevelStr:=dbFormatName(Form_Int(NomCode,0),Desc)+':';

  end;

  LevelStr:=LevelStr+' '+Show_TreeCur(CtrlCr,CtrlCr)+' Reconciliation.';

  Caption:=LevelStr;
end;


procedure TBankARec.FormCreate(Sender: TObject);

Var
  n  :  Integer;

begin
  fFrmClosing:=BOff;
  fDoingClose:=BOff;
  ExLocal.Create;

  LastCoord:=BOff;

  NeedCUpdate:=BOff;

  JustCreated:=BOn;

  InitSize.Y:=359;
  InitSize.X:=546;

  Self.ClientHeight:=InitSize.Y;
  Self.ClientWidth:=InitSize.X;

  {Height:=244;
  Width:=370;}

  BeenIn:=BOff;
  InHBeen:=BOff;

  DispTransPtr:=nil;
  PayInFormPtr:=nil;


  CtrlNom:=BRNomCtrl;
  CtrlCr:=BrCr;

  SetCaption;

  For n:=0 to Pred(ComponentCount) do
    If (Components[n] is TScrollBox) then
    With TScrollBox(Components[n]) do
    Begin
      VertScrollBar.Position:=0;
      HorzScrollBar.Position:=0;
    end;

  VertScrollBar.Position:=0;
  HorzScrollBar.Position:=0;


  {CCDepRec:=nil;}

  BPTots[0]:=TotOB;
  BPTots[1]:=TotPay;
  BPTots[2]:=TotRec;
  BPTots[3]:=TotCB;

  BPBtns[0]:=AddD1Btn;
  BPBtns[1]:=EditCD1Btn;
  BPBtns[2]:=DelD1Btn;
  BPBtns[3]:=FindD1Btn;
  BPBtns[4]:=BankD1Btn;
  BPBtns[5]:=MatchD1Btn;
  BPBtns[6]:=RepD1Btn;
  BPBtns[7]:=ProcD1Btn;
  BPBtns[8]:=ChkD1Btn;
  BPBtns[9]:=ClsD1Btn;



  CreateSubMenu(PopUpMenu2,Find1);
  CreateSubMenu(PopUpMenu3,Report1);

  FormDesign;

  FormBuildList(BOff);

end;



procedure TBankARec.FormDestroy(Sender: TObject);

Var
  n  :  Byte;
begin
  ExLocal.Destroy;


end;


procedure TBankARec.FormCloseQuery(Sender: TObject;
                              var CanClose: Boolean);
Var
  n  : Integer;

begin
  If (Not fFrmClosing) then
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

      Send_UpdateList(70+Ord(RecMode));
    Finally
      fFrmClosing:=BOff;
    end;
  end
  else
    CanClose:=BOff;


end;

procedure TBankARec.FormClose(Sender: TObject; var Action: TCloseAction);
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

  end;
end;


procedure TBankARec.FormResize(Sender: TObject);
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

    D1ListBtnPanel.Left:=(D1BtnPanel.Left-D1ListBtnPanel.Width)-6;
    D1ListBtnPanel.Height:=PageControl1.Height-PagePoint[4].Y;


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





procedure TBankARec.SetFormProperties;


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

procedure TBankARec.ShowRightMeny(X,Y,Mode  :  Integer);

Begin
  With PopUpMenu1 do
  Begin

    PopUp(X,Y);
  end;


end;


procedure TBankARec.PopupMenu1Popup(Sender: TObject);

Var
  n  :  Integer;

begin
  StoreCoordFlg.Checked:=StoreCoord;

end;



procedure TBankARec.PropFlgClick(Sender: TObject);
begin
  SetFormProperties;
end;

procedure TBankARec.StoreCoordFlgClick(Sender: TObject);
begin
  StoreCoord:=Not StoreCoord;
  NeedCUpdate:=BOn;
end;



procedure TBankARec.Clsd1BtnClick(Sender: TObject);
begin
  Close
end;


procedure TBankARec.D1RefPanelMouseUp(Sender: TObject;
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


procedure TBankARec.D1RefLabMouseMove(Sender: TObject; Shift: TShiftState;
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


procedure TBankARec.D1RefLabMouseDown(Sender: TObject;
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




procedure TBankARec.FormActivate(Sender: TObject);
begin
  If (Assigned(MULCtrlO))  then
    MULCtrlO.SetListFocus;

end;


procedure TBankARec.FindD1BtnClick(Sender: TObject);
Var
  ListPoint  :  TPoint;

begin
  With MULCtrlO do
  Begin
    If (Not InListFind) then
    Begin

       With TWinControl(Sender) do
       Begin
         ListPoint.X:=1;
         ListPoint.Y:=1;

         ListPoint:=ClientToScreen(ListPoint);

       end;

       PopUpMenu2.PopUp(ListPoint.X,ListPoint.Y);

    end;
  end;{with..}

end;



procedure TBankARec.RepD1BtnClick(Sender: TObject);
Var
  ListPoint  :  TPoint;

begin
  With MULCtrlO do
  Begin
    If (Not InListFind) then
    Begin

       With TWinControl(Sender) do
       Begin
         ListPoint.X:=1;
         ListPoint.Y:=1;

         ListPoint:=ClientToScreen(ListPoint);

       end;

       PopUpMenu3.PopUp(ListPoint.X,ListPoint.Y);

    end;
  end;{with..}

end;


procedure TBankARec.Display_ValRec(Mode  :  Byte);

Var
  WasNew  :  Boolean;

Begin
  WasNew:=BOff;


  If (ValRec=nil) then
  Begin

    ValRec:=TReconEnt.Create(Self);
    WasNew:=BOn;

  end;

  Try


   With ValRec do
   Begin

     WindowState:=wsNormal;
     {Show;}


     If (Mode In [1..3]) then
     Begin

       Case Mode of

         1..2  :   If (Not ExLocal.InAddEdit) then
                     EditLine(Self.BankMCtrl,Self.CtrlNom,Self.CtrlCr,(Mode=2),BOff)
                   else
                     Show;
            3  :  If (Not ExLocal.InAddEdit) then
                     DeleteBOMLine(MiscF,MIK,Self.BankMCtrl,Self.CtrlNom,Self.CtrlCr);
                   else
                     Show;

       end; {Case..}

     end;



   end; {With..}


  except

   ValRec.Free;


  end;

end;



procedure TBankARec.AddD1BtnClick(Sender: TObject);
begin
  With MULCtrlO do
  If (ValidLine) or (Sender=AddD1Btn) or (Sender=Add1) then
  Begin
    Display_ValRec(1+Ord((Sender=EditCD1Btn) or (Sender=Edit1)));
  end;
end;

procedure TBankARec.DelD1BtnClick(Sender: TObject);
begin
  With MULCtrlO do
  If (ValidLine) then
    Display_ValRec(3);

end;

procedure TBankARec.Amount1Click(Sender: TObject);
begin
  With MULCtrlO do
    If (ValidLine) then
      Find_ReconItem(TWinControl(Sender).Tag);
end;

procedure TBankARec.ChkD1BtnClick(Sender: TObject);
Var
  mbRet  :  Word;
begin
  {$IFDEF POST}

  {$B-}
    If (Assigned(MULCtrlO)) and (MULCtrlO.PageKeys[0]<>0) then
    Begin

  {$B+}
      Set_BackThreadMVisible(BOn);

      MbRet:=MessageDlg('Please confirm you wish to recalculate the Bank totals screen.',
                         mtConfirmation,[mbYes,mbNo],0);

      Set_BackThreadMVisible(BOff);

      If (mbRet=mrYes) then
      Begin
        AddBankChk2Thread(Self,BankMCtrl,CtrlNom,CtrlCr,MulCtrlO.KeyRef,Self.Handle);

        If (Assigned(ManBList)) then
          ManBList.SetFormStatus(BOff,BOff);

        SetButtons(BOff);
        Enabled:=BOff;

        {WindowState:=wsMinimized;}
      end;
    end
    else
    Begin
      Set_BackThreadMVisible(BOn);

      MessageDlg('There are no records to check!',mtInformation,[mbOK],0);

      Set_BackThreadMVisible(BOff);
    end;

  {$ENDIF}
end;



Function TBankARec.CheckWarn(Mode  :  Byte)  :  Word;

Var
  PrevHState
         :  Boolean;

  WForm  :  TBankWarnFrm;

Begin
  WForm:=TBankWarnFrm.Create(Self);

  try

   With WForm do
   Begin
     DMode:=Mode;
     FormDesign;

     SetAllowHotKey(BOff,PrevHState);

     Result:=ShowModal;

     SetAllowHotKey(BOn,PrevHState);
   end;

  finally
   WForm.Free;
  end;

end;

procedure TBankARec.MatchD1BtnClick(Sender: TObject);

Const
  RunMsg  :  Array[0..1] of Str10 = ('Match','Process');


Var
  Ok2Print   :  Boolean;
  mbRet      :  Word;
  Mode       :  Byte;
  FormRepPtr :  PFormRepPtr;


begin
  Ok2Print:=BOff;

  Mode:=Ord((Sender=ProcD1Btn) or (Sender=Process1));

  {$IFDEF POST}
    With BankMCtrl.BankCRec do
      Ok2Print:=((Mode=0) and (MatchCount<=0)) or ((Mode=1) and (Not AllMatchOk));

    Set_BackThreadMVisible(BOn);

    If (Ok2Print) then
      mbRet:=CheckWarn(Mode)
    else

      mbRet:=MessageDlg('Please confirm you wish to '+RunMsg[Mode]+' the bank entries.',
                        mtConfirmation,[mbYes,mbNo],0);

    Set_BackThreadMVisible(BOff);


    If (mbRet In [mrYes,mrOk]) then
    Begin
      New(FormRepPtr);

      FillChar(FormRepPtr^,Sizeof(FormRepPtr^),0);

      

      With FormRepPtr^,PParam do
      Begin
        {$IFDEF Frm}
          If (Mode=1) then
          Begin
            UFont:=TFont.Create;

            try
              UFont.Assign(Application.MainForm.Font);
            except
              UFont.Free;
              UFont:=nil;
            end;

            Orient:=RPDefine.PoPortrait;

            {Preview:=BOn;}
            PDevRec.NoCopies:=1;

            Ok2Print:=pfSelectFormPrinter(PDevRec,BOff,RForm,UFont,Orient);
          end
          else
            Ok2Print:=BOn;
          {$ELSE}
            Ok2Print:=BOn;

        {$ENDIF}
      end;

      If (Ok2Print) then
      Begin
        AddBankMatch2Thread(Self.Owner,BankMCtrl,Mode,CtrlNom,CtrlCr,MULCtrlO.KeyRef,FormRepPtr,Self.Handle);

        If (Assigned(ManBList)) then
          ManBList.SetFormStatus(BOff,BOff);

        SetButtons(BOff);
        Enabled:=BOff;


        {WindowState:=wsMinimized;}
      end;

      With FormRepPtr^,PParam do
        If (Assigned(UFont)) then
          UFont.Free;

      Dispose(FormRepPtr);
    end;

  {$ENDIF}
end;



procedure TBankARec.Show_ItemList(LUpdate  :  Boolean);

Var
  WasNew  :  Boolean;


Begin
  WasNew:=BOff;

  BRCr:=CtrlCr;
  BrNomCtrl:=CtrlNom;

  If (Not Assigned(ManBList)) then
  Begin
    ManBList:=TBankRecMM.Create(Self);
    WasNew:=BOn;
  end;

  try

    With ManBList do
    Begin
      BankMCtrl:=Self.BankMCtrl;

      If (WasNew) then
      Begin
        CtrlNom:=Self.CtrlNom;
        CtrlCr:=Self.CtrlCr;

        ListCaption:='Manual '+Self.Caption;

        SetCaption;

        RefreshList(BOn,BOn);

      end
      else
      Begin
        Show;

        If (LUpdate) then
        Begin
          RefreshList(BOn,BOn);

          SplitD1BtnClick(Nil);
        end;
      end;
    end
  except
    ManBList.Free;
    ManBList:=Nil;
  end;

end;


procedure TBankARec.Run_Process(Mode  :  Byte);

Var
  KRef  :  Str255;

begin
  {$IFDEF POST}
    If (Assigned(ManBList)) then
      KRef:=ManBList.MULCtrlO.KeyRef
    else
      KRef:='';

    AddMBankMatch2Thread(Self.Owner,BankMCtrl,Mode,CtrlNom,CtrlCr,KRef,Nil,Self.Handle);

    If (Assigned(ManBList)) then
      ManBList.SetFormStatus(BOff,BOff);

    Enabled:=BOff;
    SetButtons(BOff);

  {$ENDIF}

end;


procedure TBankARec.BankD1BtnClick(Sender: TObject);
begin
  Run_Process(Ord(Not Assigned(Sender)));
end;


procedure TBankARec.RunReport(Mode,SMode  :  Byte);

{$IFDEF Rp}

  Var
    IRRec  :  MBRRepPtr;
    NomBal,
    Purch,
    Sales,
    Cleared  :  Double;

{$ENDIF}

begin
  {$IFDEF Rp}
   New(IRRec);

   FillChar(IRRec^,Sizeof(IRRec^),0);

   With IRRec^ do
   Begin
     BankMCtrl:=Self.BankMCtrl;
     ReconCode:=CtrlNom;
     RCr:=CtrlCr;

     If (Mode=1) then
     With BankMCtrl,BankCRec do
     Begin
       OBal:=Profit_To_Date(NomEntTyp,FullNomKey(CtrlNom),CtrlCr,GetLocalPr(0).CYr,GetLocalPr(0).CPr,Purch,Sales,Cleared,BOn);

       OBal:=Cleared*DocNotCnst;
       
       RepMode:=SMode;
       KeyChk:=MULCtrlO.KeyRef;
     end
     else
       With MULCtrlO do
       Begin
         KeyChk:=FullBankMKey(MBankHed,MBankMSub,CtrlNom,CtrlCr);
         KeyChk:=Copy(KeyChk,1,Pred(Length(KeyChk)));
       end;  

     AddBankRecRep2Thread(Mode,IRRec,Application.MainForm);
   end;

  {$ENDIF}
end;


procedure TBankARec.AllEntries1Click(Sender: TObject);
begin
  RunReport(1,TMenuItem(Sender).Tag);
end;

Initialization


end.
