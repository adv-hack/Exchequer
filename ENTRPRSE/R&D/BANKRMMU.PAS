unit BankRMMU;

{$I DEFOVR.Inc}

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, TEditVal, ExtCtrls, SBSPanel, ComCtrls,
  GlobVar,VarConst,BTSupU1,ExWrap1U,

  ExtGetU,Menus;



type


  TBRMList  =  Class(TDDMList)

    Function SetCheckKey  :  Str255; Override;

    Function SetFilter  :  Str255; Override;

    Function Ok2Del :  Boolean; Override;

    Function CheckRowEmph :  Byte; Override;

    Function OutBMLine(Col  :  Byte)  :  Str255;

    Function OutBMMLine(Col  :  Byte)  :  Str255;

    Function OutLine(Col  :  Byte)  :  Str255; Override;

  end;


type
  TBankRecMM = class(TForm)
    PageControl1: TPageControl;
    ItemPage: TTabSheet;
    D1SBox: TScrollBox;
    D1HedPanel: TSBSPanel;
    D1CBLab: TSBSPanel;
    D1DetLab: TSBSPanel;
    D1DesLab: TSBSPanel;
    D1StatLab: TSBSPanel;
    D1DesPanel: TSBSPanel;
    D1CBPanel: TSBSPanel;
    D1StatPanel: TSBSPanel;
    D1DetPanel: TSBSPanel;
    D1ListBtnPanel: TSBSPanel;
    TotalPanel: TSBSPanel;
    Label82: Label8;
    Label81: Label8;
    Label84: Label8;
    TotTag1: TCurrencyEdit;
    TotTag2: TCurrencyEdit;
    TotBal: TCurrencyEdit;
    D1BtnPanel: TSBSPanel;
    D1BSBox: TScrollBox;
    TagD1Btn: TButton;
    FindD1Btn: TButton;
    ViewD1Btn: TButton;
    RefD1Btn: TButton;
    ChkD1Btn: TButton;
    ProcD1Btn: TButton;
    RepD1Btn: TButton;
    Clsd1Btn: TButton;
    SplitD1Btn: TButton;
    PopupMenu1: TPopupMenu;
    Find1: TMenuItem;
    View1: TMenuItem;
    Ref1: TMenuItem;
    Process1: TMenuItem;
    Check1: TMenuItem;
    N2: TMenuItem;
    PropFlg: TMenuItem;
    N1: TMenuItem;
    StoreCoordFlg: TMenuItem;
    PopupMenu2: TPopupMenu;
    Amount1: TMenuItem;
    Details1: TMenuItem;
    Tag1: TMenuItem;
    Report1: TMenuItem;
    SplitList1: TMenuItem;
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FormResize(Sender: TObject);
    procedure PopupMenu1Popup(Sender: TObject);
    procedure PropFlgClick(Sender: TObject);
    procedure StoreCoordFlgClick(Sender: TObject);
    procedure Clsd1BtnClick(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure D1DesPanelMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure D1DesLabMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure D1DesLabMouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure ChkD1BtnClick(Sender: TObject);
    procedure TagD1BtnClick(Sender: TObject);
    procedure FindD1BtnClick(Sender: TObject);
    procedure Amount1Click(Sender: TObject);
    procedure ViewD1BtnClick(Sender: TObject);
    procedure RefD1BtnClick(Sender: TObject);
    procedure ProcD1BtnClick(Sender: TObject);
    procedure SplitD1BtnClick(Sender: TObject);
    procedure RepD1BtnClick(Sender: TObject);
  private
    { Private declarations }
    BeenIn,
    InHBeen,
    JustCreated,
    StoreCoord,
    ChildOf,
    LastCoord,
    SetDefault,
    fNeedCUpdate,
    fFrmClosing,
    fDoingClose,
    GotCoord,
    CanDelete    :  Boolean;

    PagePoint    :  Array[0..4] of TPoint;

    BPTots       :  Array[0..2] of TCurrencyEdit;

    BPBtns       :  Array[0..8] of TButton;


    StartSize,
    InitSize     :  TPoint;



    procedure Find_FormCoord;

    procedure Store_FormCoord(UpMode  :  Boolean);

    procedure FormSetOfSet;

    
    procedure Link2Tot;

    Procedure WMCustGetRec(Var Message  :  TMessage); Message WM_CustGetRec;

    Procedure WMGetMinMaxInfo(Var Message  :  TWMGetMinMaxInfo); Message WM_GetMinMaxInfo;

    

    Procedure Send_UpdateList(Mode   :  Integer);

    procedure ShowRightMeny(X,Y,Mode  :  Integer);

    Procedure  SetNeedCUpdate(B  :  Boolean);

    Property NeedCUpDate :  Boolean Read fNeedCUpDate Write SetNeedCUpdate;

    Function Manual_Balance  :  Boolean;

  public
    { Public declarations }

    ExLocal      :  TdExLocal;

    ListOfSet    :  Integer;

    MULCtrlO     :  TBRMList;

    ListCaption  :  Str255;

    BankMCtrl    :  PassWordRec;

    CtrlNom      :  LongInt;

    CtrlCr       :  Byte;

    ManBList     :  TBankRecMM;



    procedure FormDesign;

    procedure RefreshList(ShowLines,
                          IgMsg      :  Boolean);

    procedure FormBuildList(ShowLines  :  Boolean);

    Procedure SetButtons(State  :  Boolean);

    procedure SetCaption;

    procedure SetFormProperties;

    procedure Update_Tag;

    procedure SetFormStatus(State,CallxC  :  Boolean);

  end;


Var
  BRCr        :  Byte;
  BRNomCtrl   :  LongInt;



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

  BankRCSU,
  InvListU,
  SysU1,
  SysU2,

  {$IFDEF Post}
    PostingU,
    ExThrd2U,
  {$ENDIF}

  {$IFDEF EXSQL}
    SQLUtils,
  {$ENDIF}

  SalTxl1U;



{$R *.DFM}


{$I BRTI1U.PAS}




{$IFDEF POST}

Type
  TCheckMBank      =  Object(TEntPost)

                     private
                       BankMCtrl  :  PassWordRec;
                       CtrlNom    :  LongInt;
                       CtrlCr     :  Byte;
                       KeyRef     :  Str255;
                       CallBackH  :  THandle;


                       Procedure Check_BankManMatch(Fnum,
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

  Constructor TCheckMBank.Create(AOwner  :  TObject);

  Begin
    Inherited Create(AOwner);

    fTQNo:=3;
    fCanAbort:=BOn;

    IsParentTo:=BOn;

    fOwnMT:=BOn; {* This must be set if MTExLocal is created/destroyed by thread *}

    MTExLocal:=nil;

  end;

  Destructor TCheckMBank.Destroy;

  Begin
    Inherited Destroy;
  end;



{ ======= Procedure to Recalculate Match Totals ======== }


Procedure TCheckMBank.Check_BankManMatch(Fnum,
                                         Keypath  :  Integer);


Var
  KeyS   :  Str255;
  CrDr   :  DrCrType;
  ICount :  LongInt;




Begin

  ICount:=BankMCtrl.BankCRec.ManCount;

  Blank(CrDr,Sizeof(CrDr));

  BankM_ManCalc(PWrdF,PWK,CtrlNom,CtrlCr,CrDr,BOff,BOff,BOn,BankMCtrl,MTExLocal);

  KeyS:=KeyRef;

  With MTExLocal^,BankMCtrl.BankCRec do
  Begin

    InitProgress(ICount);
    ICount:=0;

    LStatus:=LFind_Rec(B_GetGEq,Fnum,KeyPath,KeyS);

    While (LStatusOk) and (CheckKey(KeyRef,KeyS,Pred(Length(KeyRef)),BOn)) and (Not ThreadRec^.THAbort) do
    With LMiscRecs^.BankMRec do
    Begin

      ShowStatus(1,'Checking '+BankRef);

      If (Tagged) then
      Begin
        Blank(CrDr,Sizeof(CrDr));

        CrDr[(EntryStat=2)]:=BankValue;

        BankM_ManCalc(PWrdF,PWK,CtrlNom,CtrlCr,CrDr,BOff,BOff,BOff,BankMCtrl,MTExLocal);


      end;

      LStatus:=LFind_Rec(B_GetNext,Fnum,KeyPath,KeyS);

      Inc(ICount);

      UpdateProgress(ICount);

    end;

    Blank(CrDr,Sizeof(CrDr));

    BankM_ManCalc(PWrdF,PWK,CtrlNom,CtrlCr,CrDr,BOff,BOn,BOff,BankMCtrl,MTExLocal);

  end; {With..}

end; {Proc..}




  Procedure TCheckMBank.Process;

  Begin
    InMainThread:=BOn;

    Inherited Process;

    ShowStatus(0,'Check Manual Bank Reconciliation');


    Check_BankManMatch(MiscF,MIK);

  end;


  Procedure TCheckMBank.Finish;
  Begin
    Inherited Finish;

    {Overridable method}

    InMainThread:=BOff;

    {* Inform input window batch has been calculated *}

    SendMessage(CallBackH,WM_CustGetRec,55,0);

  end;



  Function TCheckMBank.Start(BCtrl    :  PassWordRec;
                             CCtrl    :  LongInt;
                             CCr      :  Byte;
                             KeyChk   :  Str255;
                             InpWinH  :  THandle)  :  Boolean;

  Var
    mbRet  :  Word;
    KeyS   :  Str255;

  Begin
    Result:=BOn;

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

      If (Result) then
      Begin
        BankMCtrl:=BCtrl;
        CallBackH:=InpWinH;
        CtrlNom:=CCtrl;
        CtrlCr:=CCr;
        KeyRef:=KeyChk;

      end;
      {$IFDEF EXSQL}
      if Result and SQLUtils.UsingSQL then
      begin
        MTExLocal^.Close_Files;
        CloseClientIdSession(MTExLocal^.ExClientID, False);
      end;
      {$ENDIF}
    end; //If Not Assigned
  end;

{ ============== }



Procedure AddMBankChk2Thread(AOwner   :  TObject;
                             BCtrl    :  PassWordRec;
                             CCtrl    :  LongInt;
                             CCr      :  Byte;
                             KeyChk   :  Str255;
                             MyHandle :  THandle);


  Var
    LCheck_Batch :  ^TCheckMBank;

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



Procedure  TBankRecMM.SetNeedCUpdate(B  :  Boolean);

Begin
  If (Not fNeedCUpdate) then
    fNeedCUpdate:=B;
end;

procedure TBankRecMM.Find_FormCoord;


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

    PrimeKey:='M';

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


procedure TBankRecMM.Store_FormCoord(UpMode  :  Boolean);


Var
  GlobComp:  TGlobCompRec;


Begin

  New(GlobComp,Create(BOff));

  With GlobComp^ do
  Begin
    GetValues:=UpMode;

    PrimeKey:='M';

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



procedure TBankRecMM.FormSetOfSet;

Begin

  PagePoint[0].X:=ClientWidth-(PageControl1.Width);
  PagePoint[0].Y:=ClientHeight-(PageControl1.Height);

  PagePoint[1].X:=PageControl1.Width-(D1SBox.Width);
  PagePoint[1].Y:=PageControl1.Height-(D1SBox.Height);

  PagePoint[2].X:=PageControl1.Width-(D1BtnPanel.Left);
  PagePoint[2].Y:=PageControl1.Height-(D1BtnPanel.Height);

  PagePoint[3].X:=D1BtnPanel.Height-(D1BSBox.Height);
  PagePoint[3].Y:=D1SBox.ClientHeight-(D1DesPanel.Height);

  PagePoint[4].Y:=PageControl1.Height-(D1ListBtnPanel.Height);

  GotCoord:=BOn;

end;


Procedure TBankRecMM.SetButtons(State  :  Boolean);

Var
  n  :  Byte;

Begin
  For n:=Low(BPBtns) to High(BPBtns) do
    If (BPBtns[n].Tag=0) then
      BPBtns[n].Enabled:=State;

end;


procedure TBankRecMM.Update_Tag;

Begin
  BankM_CtrlGet(PWrdF,PWK,CtrlNom,CtrlCr,BankMCtrl,nil);

  Link2Tot;

end;

procedure TBankRecMM.Link2Tot;

Var
  n        :  Byte;

  Dnum     :  Double;

Begin
  DNum := 0;
  With BankMCtrl.BankCRec do
  Begin

    For n:=Low(BPTots) to High(BPTots) do
    With MULCtrlO.VisiList do
    Begin
      Case n of
        0  :  Begin
                Dnum:=ManTotDr;

              end;

        1  :  Dnum:=ManTotCr;

        2  :  Begin
                Dnum:=(ManTotDr-ManTotCr);

                If (ABS(ManTotDr)<ABS(ManTotCr)) then
                  Dnum:=Dnum*DocNotCnst;
              end;

      end; {Case..}


      With BPTots[n] do
      Begin
        CurrencySymb:=SSymb(CtrlCr);
        Value:=Dnum;
      end;
    end;

  end; {With..}
end;




Procedure TBankRecMM.WMCustGetRec(Var Message  :  TMessage);

Var
  IMode  :  SmallInt;

Begin


  With Message do
  Begin

    {If (Debug) then
      DebugForm.Add('Mesage Flg'+IntToStr(WParam));}

    Case WParam of
      0,169
         :  Begin
              If (WParam=169) then
              Begin
                MULCtrlO.GetSelRec(BOff);
                IMode:=0;
              end
              else
                IMode:=WParam;

              Link2Tot;

              If (MiscRecs^.BankMRec.MatchDoc<>'') then
                Send_UpdateList(IMode);

            end;

      2  :  ShowRightMeny(LParamLo,LParamHi,1);

      25 :  NeedCUpdate:=BOn;

      55,80
         :  Begin
              SetFormStatus(BOn,ChildOf);

              Update_Tag;

              If (WParam<>80) or (Not Assigned(ManBList)) then
                Show;

              Send_UpdateList(80);
            end;

       66,67
          : Send_UpdateList(WParam);
          
       70 : Begin
              ManBList:=nil;
              SplitD1Btn.Tag:=0;
              SplitD1Btn.Enabled:=BOn;
              MULCTrlO.Filter[1,0]:='';

              D1SBox.HorzScrollBar.Position:=0;
              MulCtrlO.VisiList.SetHidePanel(2,BOff,BOn);
              MulCtrlO.ReAssignCols;

              RefreshList(BOn,BOn);
            end;


       81,82
          :  SetFormStatus((Wparam=82),ChildOf);

      116
          :  Begin
               With MULCtrlO do
               Begin
                 AddNewRow(MUListBoxes[0].Row,(LParam=1));
               end;
            end;



    end; {Case..}

  end;
  Inherited;
end;


{ == Procedure to Send Message to Get Record == }

Procedure TBankRecMM.Send_UpdateList(Mode   :  Integer);

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


Procedure TBankRecMM.WMGetMinMaxInfo(Var Message  :  TWMGetMinMaxInfo);

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

procedure TBankRecMM.SetCaption;


Begin
  Caption:=ListCaption;
end;



procedure TBankRecMM.FormDesign;


begin


end;





procedure TBankRecMM.RefreshList(ShowLines,
                               IgMsg      :  Boolean);

Var
  KeyStart    :  Str255;
  LKeypath,
  LKeyLen     :  Integer;

Begin
  KeyStart:=FullBankMKey(MBankHed,MBankMSub,CtrlNom,CtrlCr);

  LKeyLen:=Pred(Length(KeyStart));

  With MULCtrlO do
  Begin
    IgnoreMsg:=IgMsg;

    StartList(MiscF,MIK,KeyStart,'','',LKeyLen,(Not ShowLines));

    IgnoreMsg:=BOff;
  end;

  Link2Tot;
end;



procedure TBankRecMM.FormBuildList(ShowLines  :  Boolean);

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
          AddVisiRec(D1DesPanel,D1DesLab);
          AddVisiRec(D1CBPanel,D1CBLab);
          AddVisiRec(D1StatPanel,D1StatLab);
          AddVisiRec(D1DetPanel,D1DetLab);

          VisiRec:=List[0];

          StartPanel:=(VisiRec^.PanelObj as TSBSPanel);

          {HidePanels(0);}

          LabHedPanel:=D1HedPanel;

          ListOfSet:=10;

          SetHedPanel(ListOfSet);

          If (ChildOf) then
            SetHidePanel(1,BOn,BOn);

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

      DisplayMode:=2;

      ListLocal:=@ExLocal;

      ListCreate;

      UseSet4End:=BOn;

      NoUpCaseCheck:=BOn;

      HighLiteStyle[1]:=[fsBold];
      HighLiteStyle[2]:=[fsUnderline];
      HighLiteStyle[3]:=[fsBold,fsUnderline];

      If (ChildOf) then
        Filter[1,1]:='1';

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


procedure TBankRecMM.FormCreate(Sender: TObject);

Var
  n  :  Integer;

begin
  fFrmClosing:=BOff;
  fDoingClose:=BOff;
  ExLocal.Create;

  LastCoord:=BOff;

  NeedCUpdate:=BOff;

  JustCreated:=BOn;

  InitSize.Y:=358;
  InitSize.X:=545;

  ChildOf:=(Owner is TBankRecMM);

  Self.ClientHeight:=InitSize.Y;
  Self.ClientWidth:=InitSize.X;

  {Height:=244;
  Width:=370;}

  CtrlNom:=BRNomCtrl;
  CtrlCr:=BrCr;

  InHBeen:=BOff;

  BeenIn:=BOff;

  ManBList:=nil;

  If (ChildOf) then
  With TForm(Owner) do
  Begin
    Self.Left:=Left+Width-D1BtnPanel.Width;
    Self.Top:=Top;
    Self.HelpContext:=610;
  end
  else
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

  BPTots[0]:=TotTag1;
  BPTots[1]:=TotTag2;
  BPTots[2]:=TotBal;

  BPBtns[0]:=TagD1Btn;
  BPBtns[1]:=FindD1Btn;
  BPBtns[2]:=ViewD1Btn;
  BPBtns[3]:=ProcD1Btn;
  BPBtns[4]:=RepD1Btn;
  BPBtns[5]:=SplitD1Btn;
  BPBtns[6]:=ChkD1Btn;
  BPBtns[7]:=RefD1Btn;
  BPBtns[8]:=ClsD1Btn;


  If (ChildOf) then
  Begin
    SplitD1Btn.Tag:=1;
    SplitD1Btn.Enabled:=BOff;
  end;


  CreateSubMenu(PopUpMenu2,Find1);


  ListCaption:='';

  FormDesign;

  FormBuildList(BOff);

end;



procedure TBankRecMM.FormDestroy(Sender: TObject);

Var
  n  :  Byte;
begin
  ExLocal.Destroy;


end;

procedure TBankRecMM.FormCloseQuery(Sender: TObject;
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

      Send_UpdateList(70);
    Finally
      fFrmClosing:=BOff;
    end;
  end
  else
    CanClose:=BOff;


end;

procedure TBankRecMM.FormClose(Sender: TObject; var Action: TCloseAction);
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


procedure TBankRecMM.FormResize(Sender: TObject);
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

      MULCtrlO.LinkOtherDisp:=BOn;

    end;{Loop..}

    
    NeedCUpdate:=((StartSize.X<>Width) or (StartSize.Y<>Height));

  end; {If time to update}

end;





procedure TBankRecMM.SetFormProperties;


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

procedure TBankRecMM.ShowRightMeny(X,Y,Mode  :  Integer);

Begin
  With PopUpMenu1 do
  Begin

    PopUp(X,Y);
  end;


end;


procedure TBankRecMM.PopupMenu1Popup(Sender: TObject);

Var
  n  :  Integer;

begin
  StoreCoordFlg.Checked:=StoreCoord;

end;



procedure TBankRecMM.PropFlgClick(Sender: TObject);
begin
  SetFormProperties;
end;

procedure TBankRecMM.StoreCoordFlgClick(Sender: TObject);
begin
  StoreCoord:=Not StoreCoord;
  NeedCUpdate:=BOn;
end;





procedure TBankRecMM.ClsD1BtnClick(Sender: TObject);
begin
  Close;
end;




procedure TBankRecMM.FormActivate(Sender: TObject);
begin
  If (Assigned(MULCtrlO))  then
    MULCtrlO.SetListFocus;

end;






procedure TBankRecMM.D1DesPanelMouseUp(Sender: TObject;
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


procedure TBankRecMM.D1DesLabMouseMove(Sender: TObject; Shift: TShiftState;
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


procedure TBankRecMM.D1DesLabMouseDown(Sender: TObject;
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



procedure TBankRecMM.ChkD1BtnClick(Sender: TObject);
Var
  mbRet  :  Word;
begin
  {$IFDEF POST}

  Set_BackThreadMVisible(BOn);

  MbRet:=MessageDlg('Please confirm you wish to recalculate the Bank totals screen.',
                     mtConfirmation,[mbYes,mbNo],0);

  Set_BackThreadMVisible(BOff);

  If (mbRet=mrYes) then
  Begin
    AddMBankChk2Thread(Self,BankMCtrl,CtrlNom,CtrlCr,MulCtrlO.KeyRef,Self.Handle);

    SetFormStatus(BOff,ChildOf);

    {WindowState:=wsMinimized;}
  end;

  {$ENDIF}
end;



procedure TBankRecMM.TagD1BtnClick(Sender: TObject);

Var
  CrDr     :  DrCrType;
  LOk,
  LLocked   :  Boolean;

  LAddr    :  LongInt;

  KeyS     :  Str255;


begin
  If (MULCtrlO.ValidLine) then
  With MULCtrlO, MiscRecs^.BankMRec do
  Begin

    LOk:=GetMultiRecAddr(B_GetDirect,B_MultLock,KeyS,Keypath,ScanFileNum,BOn,LLocked,LAddr);

    If (LOk) and (LLocked) then
    Begin


      Blank(CrDr,Sizeof(CrDr));

      CrDr[(EntryStat=2)]:=BankValue;

      Tagged:=Not Tagged;

      Status:=Put_Rec(F[ScanFileNum],ScanFilenum,RecPtr[ScanFilenum]^,KeyPath);

      Report_BError(ScanFileNum,Status);

      Status:=UnLockMultiSing(F[ScanFileNum],ScanFileNum,LAddr);

      BankM_ManCalc(PWrdF,PWK,CtrlNom,CtrlCr,CrDr,(Not Tagged),BOn,BOff,BankMCtrl,Nil);

      Link2Tot;

      AddNewRow(MUListBoxes[0].Row,BOn);

      Send_UpdateList(80);

      If (Assigned(ManBList)) then
        ManBList.Update_Tag;
    end;
  end;

end;

procedure TBankRecMM.FindD1BtnClick(Sender: TObject);
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



procedure TBankRecMM.Amount1Click(Sender: TObject);
begin
  With MULCtrlO do
    If (ValidLine) then
      Find_ReconItem(TWinControl(Sender).Tag);
end;

procedure TBankRecMM.ViewD1BtnClick(Sender: TObject);
begin
  If (MULCtrlO.ValidLine) and (MiscRecs^.BankMRec.MatchDoc<>'') then
    Send_UpdateList(0);
end;

procedure TBankRecMM.RefD1BtnClick(Sender: TObject);
Var
  mbRet  :  Word;
begin
  {$IFDEF POST}

  Set_BackThreadMVisible(BOn);

  MbRet:=MessageDlg('Please confirm you wish to refresh the list of items.',
                     mtConfirmation,[mbYes,mbNo],0);

  Set_BackThreadMVisible(BOff);

  If (mbRet=mrYes) then
  Begin
    Send_UpdateList(66);
    SetButtons(BOff);
    {WindowState:=wsMinimized;}
  end;

  {$ENDIF}


end;


{ ======= Function to check if screen balances ======= }

Function TBankRecMM.Manual_Balance  :  Boolean;

Begin

  With BankMCtrl.BankCRec do
  Begin

    Manual_Balance:=(Round_Up((ManTotDr-ManTotCr),2)=0);

  end; {With..}
end; {Proc..}


procedure TBankRecMM.ProcD1BtnClick(Sender: TObject);
Var
  mbRet  :  Word;
begin
  {$IFDEF POST}

  If (Manual_Balance) then
  Begin


    Set_BackThreadMVisible(BOn);

    MbRet:=MessageDlg('Please confirm you wish to process the list of items.',
                       mtConfirmation,[mbYes,mbNo],0);

    Set_BackThreadMVisible(BOff);

    If (mbRet=mrYes) then
    Begin
      Send_UpdateList(67);
      SetButtons(BOff);
      {WindowState:=wsMinimized;}
    end;

  end
  else
  Begin
    Set_BackThreadMVisible(BOn);

    ShowMessage('Before processing can begin, the tagged totals must balance.');

    Set_BackThreadMVisible(BOff);

  end;

  {$ENDIF}

end;

procedure TBankRecMM.SplitD1BtnClick(Sender: TObject);

Var
  WasNew  :  Boolean;

begin
  WasNew:=BOff;

  If (Not Assigned(ManBList)) and (Assigned(Sender)) then
  Begin

    SplitD1Btn.Tag:=1;
    SplitD1Btn.Enabled:=BOff;

    ManBList:=TBankRecMM.Create(Self);

    With MULCtrlO do
    Begin
      Filter[1,0]:='1';
      D1SBox.HorzScrollBar.Position:=0;
      VisiList.SetHidePanel(2,BOn,BOn);
      ReAssignCols;
    end;

    RefreshList(BOn,BOn);

    WasNew:=BOn;
  end;

  try
    If (Assigned(ManBList)) then
    With ManBList do
    Begin
      CtrlNom:=Self.CtrlNom;
      CtrlCr:=Self.CtrlCr;
      BankMCtrl:=Self.BankMCtrl;

      If (WasNew) then
      Begin
        ListCaption:=Self.ListCaption+' Cash Book Entries Only';
        SetCaption;
      end;

      RefreshList(BOn,BOn);
    end;
  except
    ManBList.Free;
    ManBList:=nil;
  end; {try..}

end;


procedure TBankRecMM.SetFormStatus(State,CallxC  :  Boolean);

Begin
  Enabled:=State;
  SetButtons(State);

  If (ChildOf and CallxC) then
    Send_UpdateList(81+Ord(State));

  If (Assigned(ManBList)) then
    ManBList.SetFormStatus(State,ChildOf);

end;


procedure TBankRecMM.RepD1BtnClick(Sender: TObject);
begin
  Send_UpdateList(68);
end;

Initialization

  BRCr:=0; BRNomCtrl:=0;

end.
