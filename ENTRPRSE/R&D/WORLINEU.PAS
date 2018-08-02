unit WORLineU;

{$I DEFOVR.Inc}

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, TEditVal, Mask, ExtCtrls, SBSPanel, ComCtrls,
  GlobVar,VarConst,ExWrap1U,
  {$IFDEF SOP}
    InvLst3U,
  {$ENDIF}
  BTSupU1,
  SalTxl2U,
  BorBtns;


type
  TWORLine = class(TForm)
    A1SCodef: Text8Pt;
    A1PQF: TCurrencyEdit;
    A1QIF: TCurrencyEdit;
    A1LOF: Text8Pt;
    A1QOF: TCurrencyEdit;
    Label81: Label8;
    Id3QtyLab: Label8;
    PQLab: Label8;
    LocLab: Label8;
    Id3SCodeLab: Label8;
    Okdb1Btn: TButton;
    Candb1Btn: TButton;
    Label85: Label8;
    A1SDF: Text8Pt;
    A1UOF: TCurrencyEdit;
    Label82: Label8;
    A1IssF: TCurrencyEdit;
    Label83: Label8;
    Label84: Label8;
    A1UCF: TCurrencyEdit;
    A1GLF: Text8Pt;
    GLLab: Label8;
    CCLab: Label8;
    A1CCF: Text8Pt;
    DepLab: Label8;
    A1DpF: Text8Pt;
    UDF1L: Label8;
    THUD1F: Text8Pt;
    UDF2L: Label8;
    THUD2F: Text8Pt;
    UDF3L: Label8;
    THUD3F: Text8Pt;
    UDF4L: Label8;
    THUD4F: Text8Pt;
    THUD5F: Text8Pt;
    UDF5L: Label8;
    THUD6F: Text8Pt;
    THUD7F: Text8Pt;
    THUD8F: Text8Pt;
    THUD9F: Text8Pt;
    THUD10F: Text8Pt;
    UDF6L: Label8;
    UDF7L: Label8;
    UDF8L: Label8;
    UDF9L: Label8;
    UDF10L: Label8;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure FormKeyPress(Sender: TObject; var Key: Char);
    procedure Candb1BtnClick(Sender: TObject);
    procedure A1SCodefExit(Sender: TObject);
    procedure A1QIFExit(Sender: TObject);
    procedure A1GLFExit(Sender: TObject);
    procedure A1CCFExit(Sender: TObject);
    procedure A1SCodefDblClick(Sender: TObject);
    procedure A1LOFEnter(Sender: TObject);
    procedure A1LOFExit(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure A1IssFExit(Sender: TObject);
    procedure THUD1FEntHookEvent(Sender: TObject);
    procedure THUD1FExit(Sender: TObject);
    procedure SetUDFields(UDDocHed  :  DocTypes);
  private
    { Private declarations }

    IdStored,
    StopPageChange,
    BeenInLocSplit,
    JustCreated  :  Boolean;

    SKeypath     :  Integer;

    LastQtyValue :  Double;

    LocalBOMId   :  Idetail;

    DispStk      :  TFStkDisplay;

    {$IFDEF SOP}
        TxAutoMLId :  MLIdOPtr;


    {$ENDIF}

    //PR: 20/11/2017 ABSEXCH-19451
    FAllowPostedEdit : Boolean;
    function TransactionViewOnly : Boolean;

    Procedure Send_UpdateList(Edit   :  Boolean;
                              Mode   :  Integer);

    procedure BuildDesign;

    procedure FormDesign;

    Function CheckNeedStore  :  Boolean;

    Procedure SetFieldFocus;

    Procedure WMCustGetRec(Var Message  :  TMessage); Message WM_CustGetRec;

    Function ConfirmQuit  :  Boolean;

    procedure SetIdStore(EnabFlag,
                         VOMode  :  Boolean);

    Procedure SetQtyMulTab;

    Procedure OutId;

    procedure Form2Id;

    Procedure SetLink_Adj;

    {$IFDEF SOP}
      Procedure MLoc_GenLocSplit(Fnum,
                                 Keypath:  Integer);
    {$ENDIF}


    procedure StoreId(Fnum,
                      KeyPAth    :  Integer);

    Function Match_WORLines(ORef   :  Str20;
                        Var IdR    :  Idetail)  :  Boolean;

    Function Got_ChildWOR(InvR     :  InvRec;
                          IdR      :  IDetail;
                      Var LinkFolio,
                          LinkLine :  LongInt;
                          TKeypath :  Integer;
                          DocMode  :  Byte)  :  Boolean;

    procedure Warn_ChildWOR(LineLink,LinkLine  :  LongInt;
                            TKeypath           :  Integer);


  public
    { Public declarations }


    ExLocal    :  TdExLocal;

    procedure ShowLink(InvR      :  InvRec;
                       VOMode    :  Boolean);

    Function CompStillEdit  :  boolean;

    Procedure ProRataBOMQty(BomId  :  Idetail;
                            LAddr  :  LongInt);

    procedure ProcessId(Fnum,
                        KeyPAth    :  Integer;
                        Edit,
                        InsMode    :  Boolean);

    procedure SetFieldProperties(Panel  :  TSBSPanel;
                                 Field  :  Text8Pt) ;

    procedure EditLine(InvR       :  InvRec;
                       Edit,
                       InsMode,
                       ViewOnly   :  Boolean;
                       BOMId      :  IDetail);

    Function NTRight(Amount  :  Real)  :  TCurrencyEdit;


    Function NTOther(TCE  :  TObject)  :  TCurrencyEdit;

    //PR: 20/11/2017 ABSEXCH-19451
    procedure EnableEditPostedFields;
  end;

Function CheckCompleted(Edit,MainChk  :  Boolean;
                        ExLocal       :  TdExLocal;
                        WORLine       :  TWORLine)  : Boolean;


{~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~}

Implementation

{~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~}


Uses
  ETStrU,
  ETDateU,
  ETMiscU,
  BtrvU2,
  BtKeys1U,
  VARRec2U,
  BTSupU2,
  CurrncyU,
  SBSComp2,
  ComnUnit,
  ComnU2,

  {$IFDEF PF_On}

     InvLst2U,

  {$ENDIF}

  ColCtrlU,
  CmpCtrlU,
  SysU2,
  MiscU,

  StkAdjU,

  InvListU,

  InvCTSUU,

  PayF2U,
  GenWarnU,
  PWarnU,
  {$IFDEF DBD}
    DebugU,
  {$ENDIF}

  InvFSu3U,

  InvCt2SU,

  WOPCT1U,

  {$IFDEF CU}
    Event1U,
  {$ENDIF}

  {$IFDEF SOP}
    MLoc0U,

  {$ENDIF}


  Saltxl1U,
  PassWR2U,
  InvFSu2U,
  //GS 20/10/2011 ABSEXCH-11706: access to the new user defined fields interface
  CustomFieldsIntF;




{$R *.DFM}



Function MinBomReq(BomId  :  Idetail)  :  LongInt;

Const
  Fnum       = IdetailF;
  Keypath    = IdFolioK;

Var
  KeyChk,
  KeyS     :  Str255;

  MaxBuild,
  BuildSoFar :  LongInt;


Begin
  KeyChk:=FullNomKey(BOMId.FolioRef);

  KeyS:=FullIdKey(BOMId.FolioRef,2);

  MaxBuild:=0;  BuildSoFar:=0;

  Status:=Find_Rec(B_GetGEq,F[Fnum],Fnum,RecPtr[Fnum]^,Keypath,KeyS);

  While (StatusOk) and (CheckKey(KeyChk,KeyS,Length(KeyChk),BOn)) do
  With Id do
  Begin
    BuildSoFar:=Round(DivWChk(QtyWOff,QtyMul));

    If (BuildSoFar=0) and (QtyWOff<>0.0) then {Although not issued enough for one, some has been issued so the min would be one Bom}
      BuildSoFar:=1;

    If (BuildSoFar>MaxBuild) then
      MaxBuild:=BuildSoFar;

    Status:=Find_Rec(B_GetNext,F[Fnum],Fnum,RecPtr[Fnum]^,Keypath,KeyS);
  end;

  Result:=MaxBuild;

end;


Function CheckCompleted(Edit,MainChk  :  Boolean;
                        ExLocal       :  TdExLocal;
                        WORLine       :  TWORLine)  : Boolean;

Const
  NofMsgs      =  13;

Type
  PossMsgType  = Array[1..NofMsgs] of Str80;

Var
  PossMsg  :  ^PossMsgType;

  ExtraMsg :  Str80;

  Test     :  Byte;

  FoundCode:  Str20;

  Loop,
  ShowMsg  :  Boolean;

  mbRet    :  Word;

  MaxBuild,
  FoundLong
           :  LongInt;

  BalNow   :  Double;


Begin
  New(PossMsg);


  FillChar(PossMsg^,Sizeof(PossMsg^),0);

  PossMsg^[1]:='General Ledger Code is not valid.';
  PossMsg^[2]:='Stock Code is not valid.';
  PossMsg^[3]:='Cost Centre/ Department Code not valid.';
  PossMsg^[4]:='Line Over Delivered'; {* Over delivered *}
  PossMsg^[5]:='The minimum Qty Required based on component stock already issued must be ';
  PossMsg^[6]:='You must correct the last invalid entry before storing this line.';
  PossMsg^[7]:='Maximum line value exceeded.';
  PossMsg^[8]:='Location Code is not valid.';
  PossMsg^[9]:='An additional check is made via an external hook';
  PossMsg^[10]:='The first line of this works order must contain a BOM';
  PossMsg^[11]:='Cannot pick that many bom under pro mode';
  PossMsg^[12]:='Cannot pick that many bom under std mode';
  PossMsg^[13]:='Cannot pick that many serial no under pro mode';



  Loop:=BOff;

  Test:=1;

  Result:=BOn;

  BalNow:=InvLTotal(ExLocal.LId,BOff,0);

  MaxBuild:=0;

  While (Test<=NofMsgs) and (Result) do
  With ExLocal,LId do
  Begin
    ExtraMsg:='';

    ShowMsg:=BOn;

    Case Test of

      1  :  Begin
              Result:=Not Syss.AutoValStk;

              If (Not Result) then
              Begin
                Result:=GetNom(Application.MainForm,Form_Int(NomCode,0),FoundLong,-1);

                If (Result) and (Not SBSIn) then
                  Result:=(Nom.NomType In BankSet+ProfitBFSet);
              end;

            end;

      2  :  Begin
              {$IFDEF STK}


                Result:=GetStock(Application.MainForm,StockCode,Foundcode,-1);

              {$ELSE}

                Result:=BOn;

              {$ENDIF}
            end;




      {$IFDEF PF_On}

        3  :  Begin
                Result:=((Not Syss.UseCCDep) or (Not LComplete_CCDep(LId,BalNow)));

                If (Not Result) then
                Begin
                  Result:=BOn;
                  For Loop:=BOff to BOn do
                  Begin

                    Result:=(GetCCDep(Application.MainForm,CCDep[Loop],FoundCode,Loop,-1) and (Result));

                  end;
                end;

              end;

        4  :  Begin
                Result:=(Not Warn_OverDelv(LId,0,BOn,Not MainChk));

                If (Not MainChk) then
                  PossMsg^[Test]:='';

                ShowMsg:=Result;
              end;

        5  :  Begin
                Result:= (LineNo<>1) or (WORReqQty(LastId)=WORReqQty(LId));

                If (Not Result) then
                Begin
                  MaxBuild:=MinBomReq(LId);

                  Result:=(WORReqQty(LId)>=MaxBuild);

                  If (Not Result) then
                    PossMsg^[Test]:=PossMsg^[Test]+Form_Int(MaxBuild,0);

                end;


              end;

        9  :  Begin {* Opportunity for hook to validate this line as well *}
                 {$IFDEF CU}

                   Result:=ValidExitHook(4000,20,ExLocal);
                   ShowMsg:=BOff;

                 {$ENDIF}
              end;

       10  :  Begin
                Result:=(Stock.StockType=StkBillCode) or (LineNo<>1);

              end;

       11  :  Begin {* Opportunity for hook to validate this line as well *}
                {$B-}
                  Result:=(LineNo<>1) or (Not Check_PossBuild(LId,BOn));

                  ShowMsg:=BOff;
                {$B+}
              end;


       12  :  If (Assigned(WORLine)) then
              Begin {* Opportunity for hook to validate this line as well *}
                {$B-}
                  BalNow:=0.0;

                  Result:=(Not Is_StdWOP) or (LineNo<>1) or (LId.QtyPick=LastId.QtyPick) or CanPickStdBOM(LInv,LId,LId.QtyPick,BalNow,0,WORLine);

                  If (Not Result) then {Force another go}
                  Begin
                    QtyPick:=BalNow;
                  end;

                  ShowMsg:=BOff;
                {$B+}
              end;

       13 :   If (Not MainChk) and (Not ChkAllowed_In(244)) then
              Begin {* If picking snos then check we have enough available. If pw not to allow exit if insufficnet, set, then fail line}
                {$IFDEF SOP}
                  If (QtyPick>SerialQty) and (LineNo<>1) and Is_SerNo(Stock.StkValType) then {Check there is enough serial qty}
                  Begin
                    BalNow:=Sno4Sale(Stock.StockFolio,QtyPick-SerialQty,0);

                    If (BalNow<(QtyPick-SerialQty)) then
                    Begin
                      ShowMsg:=BOff;

                      ShowMessage('There are only '+Form_Real(BalNow,0,Syss.NoQtyDec)+' serial items available for allocation.');

                      Result:=BOff;
                    end;

                  end;
                {$ENDIF}
              end;


      {$ENDIF}

      6  :  If (Assigned(WORLine)) then
            Begin
              Result:=(Not WORLine.CompStillEdit);

            end;

      7  :  Begin

              Result:=(BalNow<=MaxLineValue);

            end;
      8  : {$IFDEF SOP}

              If (Syss.UseMLoc) and (LComplete_MLoc(LId)) then {* Check location valid *}
              Begin
                Result:=Global_GetMainRec(MLocF,Quick_MLKey(MLocStk));
              end
              else
            {$ENDIF}
                Result:=BOn;
            

     



    end;{Case..}

    If (Result) then
      Inc(Test);

  end; {While..}

  If (Not Result) and (ShowMsg) and (Not MainChk) then
    mbRet:=MessageDlg(ExtraMsg+PossMsg^[Test],mtWarning,[mbOk],0);

  {$IFDEF DBD}
    If (Not Result) and (Debug) then
      MessageBeep(0);

  {$ENDIF}

  Dispose(PossMsg);

end; {Func..}



procedure TWORLine.ShowLink(InvR      :  InvRec;
                            VOMode    :  Boolean);

Var
  FoundCode  :  Str20;

begin
  ExLocal.AssignFromGlobal(IdetailF);


  ExLocal.LGetRecAddr(IdetailF);

  ExLocal.LInv:=InvR;

  With ExLocal,LId,LInv do
  Begin
    Caption:=Pr_OurRef(LInv)+' Transaction Line';

    LViewOnly:=VOMode;


    If (Is_StdWOP) then
    Begin
      A1IssF.Visible:=BOff;
      Label83.Visible:=BOff;
    end;


    If (LineNo=1)  then
    Begin
      If (LastEdit) then
      Begin
        Label81.Caption:='  Total Qty Built';
        Label83.Caption:='Build Qty';

        PQLab.Visible:=BOff;
        A1PQF.Visible:=BOff;
        {Label84.Visible:=BOff;
        A1UCF.Visible:=BOff;}
        Label82.Left:=PQLab.Left;
        A1UOF.Left:=A1PQF.Left;

        A1IssF.Visible:=BOn;
        Label83.Visible:=BOn;
      end;


    end;


    If (LastEdit) then
    Begin
      With A1QIF do
      Begin
        TabStop:=BOff;
        ReadOnly:=BOn;
        Color:=clBtnFace;
      end;

      If (QtyDel<>0.0) then {Stop edit of Location and stock code as soon as its issued}
      Begin
        With A1LOF do
        Begin
          TabStop:=BOff;
          ReadOnly:=BOn;
          Color:=clBtnFace;
        end;
        With A1SCodeF do
        Begin
          TabStop:=BOff;
          ReadOnly:=BOn;
          Color:=clBtnFace;
        end;

      end;
    end;
  end;


  OutId;


  JustCreated:=BOff;

  If (ExLocal.LastEdit) then
    SetFieldFocus;

end;




{ ========== Build runtime view ======== }

procedure TWORLine.BuildDesign;


begin

end;



procedure TWORLine.FormDesign;

Var
  HideCC  :  Boolean;
  UseDec  :  Byte;

begin

  {* Set Version Specific Info *}

  {$IFNDEF SOP}

     LocLab.Visible:=BOff;
     A1LoF.Visible:=BOff;

  {$ENDIF}


  HideCC:=BOff;


  {$IFNDEF PF_On}

    HideCC:=BOn;

  {$ELSE}

    HideCC:=Not Syss.UseCCDep;
  {$ENDIF}

  A1CCF.Visible:=Not HideCC;
  A1DpF.Visible:=Not HideCC;

  CCLab.Visible:=A1CCF.Visible;
  DepLab.Visible:=A1CCF.Visible;

  A1PQF.DecPlaces:=Syss.NoQtyDec;
  A1QIF.DecPlaces:=Syss.NoQtyDec;
  A1QOF.DecPlaces:=Syss.NoQtyDec;
  A1UCF.DecPlaces:=Syss.NoCosDec;
  A1UOF.DecPlaces:=Syss.NoCosDec;
  A1IssF.DecPlaces:=Syss.NoCosDec;

  A1UCF.Visible:=PChkAllowed_In(143);
  Label84.Visible:=A1UCF.Visible;

  //GS 20/10/2011 ABSEXCH-11706: removed existing UDF setup code; replaced with calling pauls new method
  SetUDFields(ExLocal.LInv.InvDocHed);

  BuildDesign;

end;


 //GS 20/10/2011 ABSEXCH-11706: a copy of pauls user fields function
//PR: 14/11/2011 Amended to use centralised function EnableUdfs in CustomFieldsIntf.pas ABSEXCH-12129
procedure TWORLine.SetUDFields(UDDocHed  :  DocTypes);
begin
  EnableUDFs([UDF1L, UDF2L, UDF3L, UDF4L, UDF5L, UDF6L, UDF7L, UDF8L, UDF9L, UDF10L],
             [THUD1F, THUD2F, THUD3F, THUD4F, THUD5F, THUD6F, THUD7F, THUD8F, THUD9F, THUD10F],             cfWORLine);end;

procedure TWORLine.FormCreate(Sender: TObject);
begin
  ExLocal.Create;

  JustCreated:=BOn;

  SKeypath:=0;

  LastQtyValue:=0;

  Blank(LocalBOMId,sizeof(LocalBOMId));

  //GS 20/10/2011 ABSEXCH-11706: modified client height & width
  ClientHeight:=194;
  ClientWidth:=619;

  With TForm(Owner) do
    Self.Left:=Left+2;

  If (Owner is TStkAdj) then
    With TStkAdj(Owner) do
      Self.SetFieldProperties(A1FPanel,A1YRefF);

  DispStk:=nil;

  BeenInLocSplit:=BOff;

  {$IFDEF SOP}
    TxAutoMLId:=nil;
  {$ENDIF}  

  FormDesign;

end;




procedure TWORLine.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
begin

  GenCanClose(Self,Sender,CanClose,BOn);

  If (CanClose) then
    CanClose:=ConfirmQuit;

  If (CanClose) then
    Send_UpdateList(BOff,100);

end;

procedure TWORLine.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Action:=caFree;
end;

procedure TWORLine.FormDestroy(Sender: TObject);


begin
  ExLocal.Destroy;

  {$IFDEF SOP}
    If (Assigned(TxAutoMLId)) then
      Dispose(TxAutoMLId,Done);
  {$ENDIF}

end;



procedure TWORLine.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  GlobFormKeyDown(Sender,Key,Shift,ActiveControl,Handle);
end;

procedure TWORLine.FormKeyPress(Sender: TObject; var Key: Char);
begin
  GlobFormKeyPress(Sender,Key,ActiveControl,Handle);
end;

{ == Procedure to Send Message to Get Record == }

Procedure TWORLine.Send_UpdateList(Edit   :  Boolean;
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
    WParam:=Mode+100;
    LParam:=Ord(Edit);
  end;

  With Message1 do
    MessResult:=SendMEssage((Owner as TForm).Handle,Msg,WParam,LParam);

end; {Proc..}



Function TWORLine.CheckNeedStore  :  Boolean;

Begin
  Result:=CheckFormNeedStore(Self);
end;


Procedure TWORLine.SetFieldFocus;

Begin
  If (Not ExLocal.LastEdit) or (Not A1IssF.Visible) then
  Begin
    If (A1SCodeF.CanFocus) and (Not A1SCodeF.ReadOnly) then
      A1SCodeF.SetFocus;
  end
  else
    If (A1IssF.CanFocus) then
      A1IssF.SetFocus;

end; {Proc..}


Function TWORLine.CompStillEdit  :  boolean;

Var
  Loop  :  Integer;

Begin
  Result:=BOff;

  For Loop:=0 to ComponentCount-1 do
  Begin
    If (Components[Loop] is Text8Pt) then
    Begin
      Result:=Text8Pt(Components[Loop]).StillEdit;
    end
      else
        If (Components[Loop] is TCurrencyEdit) then
        Begin
          Result:=TCurrencyEdit(Components[Loop]).StillEdit;
        end;

    If (Result) then
      Break;
  end;

end;

procedure TWORLine.Candb1BtnClick(Sender: TObject);
begin
  If (Sender is TButton) then
    With (Sender as TButton) do
    Begin
      If (ModalResult=mrOk)  then
      Begin
        // MH 16/12/2010 v6.6 ABSEXCH-10548: Set focus to OK button to trigger OnExit event on date and Period/Year
        //                                   fields which processes the text and updates the value
        If (ActiveControl <> Okdb1Btn) Then
          // Move focus to OK button to force any OnExit validation to occur
          Okdb1Btn.SetFocus;

        // If focus isn't on the OK button then that implies a validation error so the store should be abandoned
        If (ActiveControl = Okdb1Btn) Then
          StoreId(IdetailF,SKeypath);
      End // If (ModalResult = mrOk)
      else
        If (ModalResult=mrCancel) then
        Begin

          Begin
            Close;
            Exit;
          end;
        end;
    end; {With..}
end;


Procedure TWORLine.WMCustGetRec(Var Message  :  TMessage);

Var
  DPtr    :  ^Double;

  {$IFDEF SOP}
    OpoLineCtrl  :  TOpoLineCtrl;
  {$ENDIF}

Begin

  With Message do
  Begin


    Case WParam of


     {$IFDEF SOP}
       212  :  Begin

                 DPtr:=Pointer(LParam);

                 Self.Enabled:=BOff;

                 TForm(Self.Owner).Enabled:=BOff;

                 Display_LocUse(Self,ExLocal.LId,ExLocal.LStock,DPtr^,TxAutoMLId);

                 Self.Enabled:=BOn;

                 With TForm(Self.Owner) do
                 Begin
                   Enabled:=BOn;
                   Show;
                 end;

                 Show;

                 Dispose(DPtr);
                 BeenInLocSplit:=BOn;

               end;
     {$ELSE}
       212  :  ;


     {$ENDIF}

     {$IFDEF SOP}
       1101..1102
             :  Begin
                  New(OpoLineCtrl,Create(Pointer(LParam)));

                  try
                    With OpoLineCtrl^ do
                    Begin
                      If (MapToStkWarn) and (A1SCodeF.Text<>OStockCode) then
                      Begin

                        A1SCodeF.OrigValue:=A1SCodeF.Text;

                        A1SCodeF.Text:=OStockCode;

                        A1SCodeF.Modified:=BOn;


                        A1SCodeFExit(A1SCodeF);
                      end;
                    end;
                  finally
                    Dispose(OpoLineCtrl,Destroy);

                  end; {try..}

                end;
       1129  :  Begin {* Respond that we do not require the opo section *}

                  SendMessage(THandle(LParam),WM_CustGetRec,1129,0);

                end;


     {$ENDIF}

    end; {Case..}

  end;
  Inherited;
end;


Function TWORLine.ConfirmQuit  :  Boolean;

Var
  MbRet  :  Word;
  TmpBo  :  Boolean;

Begin

  TmpBo:=BOff;

  If (ExLocal.InAddEdit) and (CheckNeedStore) and (Not ExLocal.LViewOnly) and (Not IdStored) then
  Begin

    mbRet:=MessageDlg('Save changes to '+Caption+'?',mtConfirmation,[mbYes,mbNo,mbCancel],0);
  end
  else
    mbRet:=mrNo;

  Case MbRet of

    mrYes  :  Begin
                StoreId(IdetailF,SKeyPath);
                TmpBo:=(Not ExLocal.InAddEdit);
              end;

    mrNo   :  With ExLocal do
              Begin
                If (LastEdit) and (Not LViewOnly) and (Not IdStored) then
                  Status:=UnLockMLock(IdetailF,LastRecAddr[IdetailF]);

                Send_UpdateList(BOff,20);

                TmpBo:=BOn;
              end;

    mrCancel
           :  Begin
                TmpBo:=BOff;
                SetfieldFocus;
              end;
  end; {Case..}


  ConfirmQuit:=TmpBo;
end; {Func..}



procedure TWORLine.SetIdStore(EnabFlag,
                             VOMode  :  Boolean);

Var
  Loop  :  Integer;

Begin

  ExLocal.InAddEdit:=Not VOMode or FAllowPostedEdit;

  Okdb1Btn.Enabled:=Not VOMode or FAllowPostedEdit;

  For Loop:=0 to ComponentCount-1 do
  Begin
    If (Components[Loop] is Text8Pt) then
    with Text8Pt(Components[Loop]) do
    Begin
      If (Tag=1) then
        ReadOnly:= VOMode and not AllowPostedEdit;
    end
      else
        If (Components[Loop] is TEditDate) then
        Begin
          If (TEditDate(Components[Loop]).Tag=1) then
            TEditDate(Components[Loop]).ReadOnly:= VOMode;
        end
        else
          If (Components[Loop] is TEditPeriod) then
          Begin
            If (TEditPeriod(Components[Loop]).Tag=1) then
              TEditPeriod(Components[Loop]).ReadOnly:= VOMode;
          end
          else
            If (Components[Loop] is TCurrencyEdit) then
            Begin
              If (TCurrencyEdit(Components[Loop]).Tag=1) then
                TCurrencyEdit(Components[Loop]).ReadOnly:= VOMode;
            end
            else
              If (Components[Loop] is TBorCheck) then
              Begin
                If (TBorCheck(Components[Loop]).Tag=1) then
                  TBorCheck(Components[Loop]).Enabled:= Not VOMode;
              end
              else
                If (Components[Loop] is TSBSComboBox) then
                Begin
                  If (TSBSComboBox(Components[Loop]).Tag=1) then
                    TSBSComboBox(Components[Loop]).ReadOnly:= VOMode;
              end;
  end; {Loop..}

  With A1QIF do {* Set stock code to readonly if inside auto doc *}
    ReadOnly:=(ReadOnly or (ExLocal.LastEdit));

  With A1LOF,ExLocal,LId do {* Set stock code to readonly if inside auto doc *}
    ReadOnly:=(ReadOnly or (LastEdit and (QtyDel<>0.0)));

  With A1SCodeF,ExLocal,LId do {* Set stock code to readonly if inside auto doc *}
    ReadOnly:=(ReadOnly or (LastEdit and (QtyDel<>0.0)));


end;


Procedure TWORLine.SetQtyMulTab;

Begin
end;



{ ============== Display Id Record ============ }

Procedure TWORLine.OutId;

Var
  FoundOk   :  Boolean;

  FoundCode :  Str20;

Begin
  With ExLocal,LId do
  Begin
    A1SCodeF.Text:=StockCode;
    A1SCodeF.OrigValue:=StockCode;

    A1PQF.Value:=QtyMul;

    A1UCF.Value:=CostPrice;
    A1GLF.Text:=Form_Int(NomCode,0);

    A1CCF.Text:=CCDep[BOn];
    A1DpF.Text:=CCDep[BOff];



    FoundOk:=GetStock(Self,A1SCodeF.Text,FoundCode,-1);

    If (FoundOk) then
      AssignFromGlobal(StockF);

    If (LineNo=1) then
      A1SDF.Text:=Desc
    else
      A1SDF.Text:=Stock.Desc[1];

    A1QIF.Value:=Qty;

    If (LineNo<>1) then
      A1QOF.Value:=QtyDel
    else
      A1QOF.Value:=QtyWOff;

    A1UOF.Value:=QtyPWOff;

    {If (QtyPick=0.0) and (LastEdit) then
    Begin
      If (LineNo=1) then
        QtyPick:=BuildQty_OS(LId)
      else
        QtyPick:=Qty_OS(LId);
    end;}

    A1IssF.Value:=QtyPick;

    A1LoF.Text:=MLocStk;

    THUd1F.Text:=LineUser1;
    THUd2F.Text:=LineUser2;
    THUd3F.Text:=LineUser3;
    THUd4F.Text:=LineUser4;
    //GS 20/10/2011 ABSEXCH-11706: put customisation values into text boxes
    THUd5F.Text:=LineUser5;
    THUd6F.Text:=LineUser6;
    THUd7F.Text:=LineUser7;
    THUd8F.Text:=LineUser8;
    THUd9F.Text:=LineUser9;
    THUd10F.Text:=LineUser10;
    JustCreated:=BOff;
  end;

  
end;


procedure TWORLine.Form2Id;

Begin

  With EXLocal,LId do
  Begin
    NomCode:=IntStr(A1GLF.Text);

    CCDep[BOn]:=A1CCF.Text;
    CCDep[BOff]:=A1DpF.Text;

    StockCode:=FullStockCode(A1SCodeF.Text);
    QtyMul:=A1PQF.Value;
    QtyPack:=QtyMul;
    Qty:=A1QIF.Value;

    CostPrice:=A1UCF.Value;

    {$IFDEF SOP}
      MLocStk:=Full_MLocKey(A1LoF.Text);

    {$ELSE}
      MLocStk:=A1LoF.Text;

    {$ENDIF}

    QtyPWOff:=A1UOF.Value;
    QtyPick:=A1IssF.Value;

    LineUser1:=THUd1F.Text;
    LineUser2:=THUd2F.Text;
    LineUser3:=THUd3F.Text;
    LineUser4:=THUd4F.Text;
    //GS 20/10/2011 ABSEXCH-11706: write udef field values into customisation object
    LineUser5:=THUd5F.Text;
    LineUser6:=THUd6F.Text;
    LineUser7:=THUd7F.Text;
    LineUser8:=THUd8F.Text;
    LineUser9:=THUd9F.Text;
    LineUser10:=THUd10F.Text;
    Desc:=A1SDF.Text;


  end; {with..}

end; {Proc..}





(*  Add is used to add Notes *)

procedure TWORLine.ProcessId(Fnum,
                            Keypath     :  Integer;
                            Edit,
                            InsMode     :  Boolean);

Var
  KeyS  :  Str255;

  CurrRLine
        :  LongInt;

Begin

  Addch:=ResetKey;

  IdStored:=BOff;

  KeyS:='';

  ExLocal.InAddEdit:=BOn;

  ExLocal.LastEdit:=Edit;

  If (Edit) then
  Begin

    With ExLocal do
    Begin
      LGetRecAddr(Fnum);

      If (Not TransactionViewOnly) then
        Ok:=LGetMultiRec(B_GetDirect,B_MultLock,KeyS,KeyPAth,Fnum,BOff,GlobLocked)
      else
        Ok:=BOn;

    end;

    If (Not Ok) or (Not GlobLocked) then
      AddCh:=Esc;
  end;


  If (Addch<>Esc) then
  With ExLocal,LId do
  begin
    LastIns:=InsMode;


    If (Not Edit) then
    Begin
      CurrRLine:=Id.LineNo; {* this is correct, as LId not set on an insert *}

      LastQtyValue:=0;

      LResetRec(Fnum);

      FolioRef:=LInv.FolioNum;

      DocPRef:=LInv.OurRef;

      If (InsMode) and (CurrRLine>0) then  {* Do not allow insert on first blank line! *}
        LineNo:=CurrRLine
      else
        LineNo:=LInv.ILineCount;

      ABSLineNo:=LInv.ILineCount;

      IDDocHed:=LInv.InvDocHed;

      PostedRun:=StkAdjRunNo;

      NomMode:=StkAdjNomMode;

      QtyMul:=1;

      QtyPack:=QtyMul;

      PriceMulX:=1.0;

      MLocStk:=LInv.DelTerms;

      LineType:=StkLineType[IdDocHed];

      Currency:=LInv.Currency;

      CXRate:=LInv.CXRate;

      CurrTriR:=LInv.CurrTriR;

      PYr:=LInv.ACYr;
      PPr:=LInv.AcPr;

      Payment:=SetRPayment(LInv.InvDocHed);

      If (Syss.AutoClearPay) then
        Reconcile:=ReconC;



      PDate:=LInv.DueDate;

      If (JBCostOn) then
      Begin

        JobCode:=LInv.DJobCode;
        AnalCode:=LInv.DJobAnal;


        NomCode:=Job_WIPNom(NomCode,JobCode,AnalCode,StockCode,MLocStk,CustCode);

      end;



    end
    else
      LastQtyValue:=QtyPick;

    LastId:=LId;


    OutId;

    SetIdStore(BOn,ExLocal.LViewOnly);

  end; {If Abort..}

end; {Proc..}





Procedure TWORLine.ProRataBOMQty(BomId  :  Idetail;
                                 LAddr  :  LongInt);

Const
  Fnum       = IdetailF;
  Keypath    = IdFolioK;

Var
  KeyChk,
  KeyS     :  Str255;

  MaxBuild,
  BuildSoFar :  LongInt;


Begin
  If (CustomDlg(Application.MainForm,'Please Confirm','WOR Production Qty altered',
                             'The build qty for this Works Order has been altered.'+#13+
                             'Do you wish to apply the new build qty to all the component lines?',
                             mtConfirmation,
                             [mbYes,mbNo]
                             )=mrOk) then
  With ExLocal do
  Begin
    KeyChk:=FullNomKey(BOMId.FolioRef);

    KeyS:=FullIdKey(BOMId.FolioRef,2);

    MaxBuild:=0;  BuildSoFar:=0;

    Status:=Find_Rec(B_GetGEq,F[Fnum],Fnum,RecPtr[Fnum]^,Keypath,KeyS);

    While (StatusOk) and (CheckKey(KeyChk,KeyS,Length(KeyChk),BOn)) do
    With Id do
    Begin
      Deduct_WORStk(Id,LInv,BOff);

      UpdateWORCost(LInv,Id,1);


      Qty:=WORReqQty(BOMId)*QtyMul;
      QtyPick:=0.0;


      Deduct_WORStk(Id,LInv,BOn);

      UpdateWORCost(LInv,Id,0);

      Status:=Put_Rec(F[Fnum],Fnum,RecPtr[Fnum]^,KeyPAth);

      Report_BError(Fnum,Status);

      Status:=Find_Rec(B_GetNext,F[Fnum],Fnum,RecPtr[Fnum]^,Keypath,KeyS);
    end;

    SetDataRecOfs(Fnum,LAddr);

    Status:=GetDirect(F[Fnum],Fnum,RecPtr[Fnum]^,SKeyPAth,0); {* Re-Establish Position *}

  end;

end;





{$IFDEF SOP}
{ ==== Proc to Generate Automatic ==== }

  Procedure TWORLine.MLoc_GenLocSplit(Fnum,
                                      Keypath:  Integer);

  Var
    Found  :  Boolean;
    TmpStr :  Str20;

    DCnst  :  Integer;

    TmpId  :  Idetail;

    StockR :  StockRec;

  Begin
    If (Assigned(TxAutoMLId)) then
    With TxAutoMLId^,EXLocal,LId do
    Begin
      LGetRecAddr(Fnum);

      Found:=FindDir(BOn);

      While (Found) do
      With CarryFR^ do
      Begin
        If (idLoc<>NdxWeight) then
        Begin
          LId.MLocStk:=IdLoc;

          LId.SerialQty:=0;

          LId.BinQty:=0.0;

          If (Not (IdDocHed In StkAdjSplit)) then
          Begin
            LineNo:=LInv.ILineCount;

            {* Set on all Lines *}


            ABSLineNo:=LInv.ILineCount;

            If (Stock.StockCode<>StockCode) then
            Begin
              If (LGetMainRecPos(StockF,StockCode)) then
                AssignToGlobal(StockF);
            end;


            Qty:=1;
            QtyPWOff:=0.0;
            QtyDel:=0.0;
            QtyWOff:=0.0;

            TmpId:=LId;

            SetLink_Adj;

            DCnst:=1;
          end
          else
            DCnst:=-1;

          Qty:=idQTLoc*DCnst;
          QtyPick:=Qty;

          Self.Enabled:=BOff;

          TForm(Self.Owner).Enabled:=BOff;

          StockR:=LStock;

          If (Is_SerNo(LStock.StkValType)) then
            StockR.StockCode:=NdxWeight; {* Force link up to stock *}

          Control_SNos(LId,LInv,StockR,1,Self);

          Self.Enabled:=BOn;

          With TForm(Self.Owner) do
          Begin
            Enabled:=BOn;
            Show;
          end;

          Deduct_WORStk(LId,LInv,BOn);

          Inc(LInv.ILineCount);

          Status:=Add_Rec(F[Fnum],Fnum,LRecPtr[Fnum]^,KeyPath);

          Report_BError(Fnum,Status);

          If (StatusOk) then
          Begin
            UpdateWORCost(LInv,LId,0);

          end;

        end;

        Found:=FindDir(BOff);

      end; {While..}

      LSetDataRecOfs(Fnum,LastRecAddr[Fnum]);

      Status:=GetDirect(F[Fnum],Fnum,LRecPtr[Fnum]^,KeyPath,Keypath); {* Re-Establish Position *}

      Send_UpdateList(BOff,31);
    end; {End With..}
  end;
{$ENDIF}


procedure TWORLine.StoreId(Fnum,
                          Keypath  :  Integer);

Var
  COk  :  Boolean;
  TmpId
       :  Idetail;

  KeyS :  Str255;

  { CJS 2013-08-06 - ABSEXCH-14210 - Access violation when storing Transaction }
  ButtonState: Boolean;
  CursorState: TCursor;

Begin
  KeyS:='';

  { CJS 2013-08-06 - ABSEXCH-14210 - Access violation when storing Transaction }
  ButtonState := Okdb1Btn.Enabled;
  CursorState := Cursor;

  Okdb1Btn.Enabled := False;
  try

    Form2Id;


    With ExLocal,LId do
    Begin

      COk:=CheckCompleted(LastEdit,BOff,ExLocal,Self);


      If (COk) then
      Begin
        //PR: 21/11/2017 ABSEXCH-19451 Don't do serial nos or stock if posted
        if not ExLocal.LViewOnly then
        begin
          Cursor:=CrHourGlass;

          {$IFDEF STK} {v5.52. Open up for non SPOP versions using multi bins}

              Self.Enabled:=BOff;
              TForm(Owner).Enabled:=BOff;

             Control_SNos(LId,LInv,LStock,1,Self);

              Self.Enabled:=BOn;
              TForm(Owner).Enabled:=BOn;
              TForm(Owner).Show;


          {$ENDIF}

          Deduct_WORStk(LastId,LInv,BOff);

          Deduct_WORStk(LId,LInv,BOn);
        end;
        {
          CJS 24/01/2011 - ASBEXCH-9963 - Silently make sure that NOMMODE
          holds the correct value. If it is 2 (StkAdjNomMode), reset it
          to 0.
        }
        if (IdDocHed <> ADJ) and (NomMode = 2) then
          NomMode := 0;

        If (LastEdit) then
        Begin

          If (LastRecAddr[Fnum]<>0) then  {* Re-establish position prior to storing *}
          Begin

            TmpId:=LId;

            LSetDataRecOfs(Fnum,LastRecAddr[Fnum]);

            Status:=GetDirect(F[Fnum],Fnum,LRecPtr[Fnum]^,KeyPAth,0); {* Re-Establish Position *}

            LId:=TmpId;

          end;

          Status:=Put_Rec(F[Fnum],Fnum,LRecPtr[Fnum]^,KeyPAth);

        end
        else
        Begin
          If (LastIns) then
          Begin
            TmpId:=LId;

            MoveEmUp(FullNomKey(LId.FolioRef),
                   FullIdKey(LId.FolioRef,LastAddrD),
                   FullIdKey(LId.FolioRef,LId.LineNo),
                   1,
                   Fnum,KeyPath,
                   // MH 02/11/2015 2016R1 ABSEXCH-16613: Re-instated SQL mod to improve performance when Exploding BoM's
                   mumInsert);

            LId:=TmpId;
          end;


          Inc(LInv.ILineCount);


          Status:=Add_Rec(F[Fnum],Fnum,LRecPtr[Fnum]^,KeyPAth);

        end;

        Report_BError(Fnum,Status);

        //PR: 21/11/2017 ABSEXCH-19451 Don't recalculate if posted
        If (StatusOk) and not ExLocal.LViewOnly then
        Begin

        
          If (LId.LineNo=1) then
          Begin
            If (WORReqQty(LastId)<>WORReqQty(LId)) and (QtyWOff=0.0) and (SSDUplift=0.0) then
              ProRataBOMQty(LId,LastRecAddr[Fnum]);
          end
          else
          Begin
            UpdateWORCost(LInv,LastId,1);

            UpdateWORCost(LInv,LId,0);
          end;

        end;

        { CJS 2013-08-06 - ABSEXCH-14210 - Access violation when storing Transaction }
        Cursor := CursorState;

        InAddEdit:=Boff;

        If (LastEdit) then
          ExLocal.UnLockMLock(Fnum,LastRecAddr[Fnum]);

        SetIdStore(BOff,BOff);

        IdStored:=BOn;

        Send_UpdateList(LastEdit,8);

        LastValueObj.UpdateAllLastValues(Self);

        {$IFDEF SOP}
          If (Assigned(TxAutoMLId)) then
            MLoc_GenLocSplit(Fnum,Keypath);
        {$ENDIF}

        Close;
      end
      else
        SetFieldFocus;

    end; {With..}

  { CJS 2013-08-06 - ABSEXCH-14210 - Access violation when storing Transaction }
  finally
    Cursor := CursorState;
    Okdb1Btn.Enabled := ButtonState;
  end;

end;


procedure TWORLine.SetFieldProperties(Panel  :  TSBSPanel;
                                      Field  :  Text8Pt) ;

Var
  n  : Integer;


Begin
  For n:=0 to Pred(ComponentCount) do
  Begin
    If (Components[n] is TMaskEdit) or (Components[n] is TComboBox)
     or (Components[n] is TCurrencyEdit) then
    With TGlobControl(Components[n]) do
      If (Tag>0) then
      Begin
        Font.Assign(Field.Font);
        Color:=Field.Color;
      end;

    If (Components[n] is TBorCheck) then
      With (Components[n] as TBorCheck) do
      Begin
        {CheckColor:=Field.Color;}
        Color:=Panel.Color;
      end;

  end; {Loop..}


end;


procedure TWORLine.EditLine(InvR       :  InvRec;
                           Edit,
                           InsMode,
                           ViewOnly   :  Boolean;
                           BOMId      :  IDetail);


begin
  With ExLocal do
  Begin
    LastEdit:=Edit;

    LocalBOMId:=BOMId;

    ShowLink(InvR,ViewOnly);

    ProcessId(IdetailF,CurrKeyPath^[IdetailF],LastEdit,InsMode);
  end;
end;



procedure TWORLine.A1GLFExit(Sender: TObject);
Var
  FoundCode  :  Str20;

  FoundOk,
  AltMod     :  Boolean;

  FoundLong  :  LongInt;


begin

  If (Sender is Text8pt) then
  With (Sender as Text8pt) do
  Begin
    AltMod:=Modified;

    FoundCode:=Strip('B',[#32],Text);

    If ((AltMod) or (FoundCode='')) and (ActiveControl<>Candb1Btn)  then
    Begin

      StillEdit:=BOn;

      FoundOk:=(GetNom(Self.Owner,FoundCode,FoundLong,2));

      If (FoundOk) then {* Credit Check *}
      With ExLocal do
      Begin

        AssignFromGlobal(NomF);



      end;


      If (FoundOk) then
      With ExLocal,LId do
      Begin

        StillEdit:=BOff;

        Text:=Form_Int(FoundLong,0);


      end
      else
      Begin
        SetFocus;
      end; {If not found..}
    end;


  end; {with..}
end;





procedure TWORLine.A1CCFExit(Sender: TObject);
Var
  FoundCode  :  Str20;

  FoundOk,
  AltMod     :  Boolean;

  IsCC       :  Boolean;


begin

  {$IFDEF PF_On}

    If (Sender is Text8pt) then
    With (Sender as Text8pt) do
    Begin
      FoundCode:=Name;

      IsCC:=Match_Glob(Sizeof(FoundCode),'CC',FoundCode,FoundOk);

      AltMod:=Modified;

      FoundCode:=Strip('B',[#32],Text);


      If ((AltMod) or (FoundCode='')) and (ActiveControl<>Candb1Btn) and (Syss.UseCCDep) then
      Begin

        StillEdit:=BOn;

        FoundOk:=(GetCCDep(Self.Owner,FoundCode,FoundCode,IsCC,2));

        If (FoundOk) then {* Credit Check *}
        With ExLocal do
        Begin

          AssignFromGlobal(PWrdF);

        end;


        If (FoundOk) then
        Begin

          StillEdit:=BOff;

          Text:=FoundCode;


        end
        else
        Begin

          SetFocus;
        end; {If not found..}
      end;

    end; {with..}
  {$ENDIF}
end;





{ ================= Function Return if input should be a debit / Credit ========= }

Function TWORLine.NTRight(Amount  :  Real)  :  TCurrencyEdit;

Begin
  If (Amount<0) then
    NTRight:=A1QOF
  else
    NTRight:=A1QIF;
end;


{ ================= Function Return if input should be a debit / Credit ========= }

Function TWORLine.NTOther(TCE  :  TObject)  :  TCurrencyEdit;

Begin
  If (TCE=A1QIF) then
    Result:=A1QOF
  else
    Result:=A1QIF;
end;



 Procedure TWORLine.SetLink_Adj;

 Var
   Rnum  :  Real;
   {$IFDEF SOP}
     TmpStk  :  ^StockRec;
   {$ENDIF}

 Begin
   With ExLocal,LId do
   Begin
     {$IFDEF SOP}
        New(TmpStk);
        TmpStk^:=LStock;

        Stock_LocLinkSubst(LStock,MLocStk);
     {$ENDIF}
                                                       {* Changed from BOff? *}
     Rnum:=Currency_ConvFT(Calc_StkCP(LStock.CostPrice,LStock.BuyUnit,(LStock.DPackQty And LStock.CalcPack)),
                           LStock.PCurrency,LInv.Currency,UseCoDayRate);

     {* To be replaced by FIFO Calc *}

     CostPrice:=Round_Up(Rnum,Syss.NoCosDec);

     If (LStock.StockType=StkBillCode) then
       NomCode:=LStock.NomCodes[5]  {* Asjust WIP *}
     else
       NomCode:=LStock.NomCodes[4];


     {$IFDEF PF_On}

       CCDep:=GetProfileCCDep('','',LStock.CCDep,CCDep,1);


     {$ENDIF}

     {$IFDEF SOP}
       LStock:=TmpStk^;
       Dispose(TmpStk);
     {$ENDIF}
   end;
 end; {Proc..}



procedure TWORLine.A1SCodefExit(Sender: TObject);
Var
  FoundCode  :  Str20;

  FoundOk,
  AltMod     :  Boolean;

  Rnum       :  Double;



begin

  Rnum:=0;

  If (Sender is Text8pt) then
  With (Sender as Text8pt) do
  Begin
    AltMod:=Modified;

    FoundCode:=Strip('B',[#32],Text);

    If ((AltMod) or (FoundCode='')) and (ActiveControl<>Candb1Btn) then
    Begin

      StillEdit:=BOn;

      FoundOk:=(GetStock(Self.Owner,FoundCode,FoundCode,0+(2*Ord(ExLocal.LId.LineNo=1))));

      If (FoundOk) then {* Credit Check *}
      With ExLocal do
      Begin

        AssignFromGlobal(StockF);

        SetQtyMulTab;

        A1SDF.Text:=LStock.Desc[1];



        StillEdit:=BOff;

        Text:=FoundCode;

        With ExLocal,LId do
        Begin
          Form2Id;


          If (OrigValue<>'') and (CheckNegStk) then
          Begin
            QtyPick:=0;
            LastQtyValue:=0.0;
          end;


          SendToObjectStkEnq(FoundCode,MLocStk,'',-1,-1,0);


          SetLink_Adj;

          OutId;
        end;

      end
      else
      Begin
        SetFocus;
      end; {If not found..}
    end;

  end; {with..}
end;


procedure TWORLine.A1IssFExit(Sender: TObject);
Var
  AltMod,
  FlowStk  :  Boolean;

begin
  FLowStk:=BOff;

  If (Sender is TCurrencyEdit) then
  With (Sender as TCurrencyEdit) do
  Begin
    AltMod:=FloatModified;

    If ((AltMod) or (StillEdit)) and (ActiveControl<>Candb1Btn) then
    With ExLocal,LId do
    Begin
      Form2Id;

      StillEdit:=BOn;


      If (Syss.UseStock) and (QtyPick<>0) then
      Begin
        If (LineNo=1) then
        Begin
          FLowStk:=Check_PossBuild(LId,BOn);

          If (FLowStk) and (BOMQtyIssue(LId)>0) then
            Value:=BOMQtyIssue(LId);
        end
        else
        Begin
          Check_StockCtrl(StockCode,(QtyPick-LastQtyValue)*DocNotCnst,1+Ord(CheckNegStk),FLowStk,IdDocHed,LId,Self.Handle);

          {$IFDEF SOP}
             If (Syss.UseMLoc) and (Assigned(TxAutoMLId)) then  {* Adjust quantity based on split *}
             Begin
               TxAutoMLId^.SetIdQty(LId);

               A1UOF.Value:=QtyPWOff;
               A1IssF.Value:=QtyPick;
             end;
          {$ENDIF}

        end;

        If (FLowStk) and (CanFocus) then {* Force adjustment *}
         SetFocus
        else
        Begin
          StillEdit:=BOff;

          {$IFDEF SOP}
             If (Syss.UseMLoc) and (BeenInLocSplit) then
             Begin
               FieldNextFix(Self.Handle,ActiveControl,Sender);
               BeenInLocSPlit:=BOff;
             end;
          {$ENDIF}

        end;
      end
      else
        StillEdit:=BOff;


    end;

  end; {If/With..}
end;


procedure TWORLine.A1QIFExit(Sender: TObject);
Var
  AltMod,
  FlowStk  :  Boolean;

  MaxBuild :  LongInt;

begin
  FLowStk:=BOff; MaxBuild:=0;

  If (Sender is TCurrencyEdit) then
  With (Sender as TCurrencyEdit) do
  Begin
    AltMod:=FloatModified;

    With ExLocal,LId do                                              {Only perform this check on master line}
    If ((AltMod) or (StillEdit)) and (ActiveControl<>Candb1Btn) and (ExLocal.LId.LineNo=1) then
    Begin
      Form2Id;

      StillEdit:=BOn;

      MaxBuild:=MinBomReq(LId);

      FLowStk:=(WORReqQty(LId)<MaxBuild);

      If (FLowStk) then
        ShowMessage('The minimum Qty Required based on component stock already issued must be '+Form_Int(MaxBuild,0));

      If (FLowStk) and (CanFocus) then {* Force adjustment *}
       SetFocus
      else
        StillEdit:=BOff;
    end
    else
      StillEdit:=BOff;
  end; {If/With..}
end;






procedure TWORLine.A1SCodefDblClick(Sender: TObject);
begin
  {$IFDEF STK}

    With A1SCodeF do
     If (CheckKey(FullStockCode(Text),ExLocal.LStock.StockCode,StkKeyLen,BOff)) then
    Begin
      If (Not MatchOwner('StockRec',Self.Owner.Owner)) then
      Begin

        If (DispStk=nil) then
          DispStk:=TFStkDisplay.Create(Self);

        try

          ExLocal.AssignToGlobal(StockF);

          With DispStk do

            Display_Account(0);

        except

          DispStk.Free;

        end;
      end
      else  {* We are being called via StockRec, hence double click should inform custrec *}
      Begin
        Send_UpdateList(BOff,10);
      end;
    end
    else
      A1SCodeFExit(A1SCodeF);

  {$ENDIF}

end;

procedure TWORLine.THUD1FEntHookEvent(Sender: TObject);
Var
  CUUDEvent  :  Byte;
  Result     :  LongInt;

begin
  {$IFDEF CU}
    If (Sender is Text8Pt)then
      With (Sender as Text8pt) do
      Begin
        If (Not ReadOnly) then
        Begin
          If (Sender=THUD1F) then
          Begin
            ExLocal.LId.LineUser1:=Text;
            CUUDEvent:=1;
          end
          else
            If (Sender=THUD2F) then
            Begin
              ExLocal.LId.LineUser2:=Text;
              CUUDEvent:=2;
            end
            else
              If (Sender=THUD3F) then
              Begin
                ExLocal.LId.LineUser3:=Text;
                CUUDEvent:=3;
              end
              else
                If (Sender=THUD4F) then
                Begin
                  ExLocal.LId.LineUser4:=Text;
                  CUUDEvent:=4;
                end
                //GS 20/10/2011 ABSEXCH-11706: create branches for the new UDFs
                //there is a 30 offset; event values are adjucted accordingly
                else
                  If (Sender=THUD5F) then
                  Begin
                    ExLocal.LId.LineUser5:=Text;
                    CUUDEvent:=(211 - 30);
                  end
                  else
                    If (Sender=THUD6F) then
                    Begin
                      ExLocal.LId.LineUser6:=Text;
                      CUUDEvent:=(212 - 30);
                    end
                    else
                      If (Sender=THUD7F) then
                      Begin
                        ExLocal.LId.LineUser7:=Text;
                        CUUDEvent:=(213 - 30);
                      end
                      else
                        If (Sender=THUD8F) then
                        Begin
                          ExLocal.LId.LineUser8:=Text;
                          CUUDEvent:=(214 - 30);
                        end
                        else
                          If (Sender=THUD9F) then
                          Begin
                            ExLocal.LId.LineUser9:=Text;
                            CUUDEvent:=(215 - 30);
                          end
                          else
                            If (Sender=THUD10F) then
                            Begin
                              ExLocal.LId.LineUser10:=Text;
                              CUUDEvent:=(216 - 30);
                            end;

          Result:=IntExitHook(4000,30+CUUDEvent,-1,ExLocal);

          If (Result=0) then
            SetFocus
          else
          With ExLocal do
          If (Result=1) then
          Begin
            Case CUUDEvent of
              1  :  Text:=LId.LineUser1;
              2  :  Text:=LId.LineUser2;
              3  :  Text:=LId.LineUser3;
              4  :  Text:=LId.LineUser4;
              //GS 20/10/2011 ABSEXCH-11706: put customisation object vals into UDFs
              (211 - 30)  :  Text:=LId.LineUser5;
              (212 - 30)  :  Text:=LId.LineUser6;
              (213 - 30)  :  Text:=LId.LineUser7;
              (214 - 30)  :  Text:=LId.LineUser8;
              (215 - 30)  :  Text:=LId.LineUser9;
              (216 - 30)  :  Text:=LId.LineUser10;
            end; {Case..}
          end;
        end;
     end; {With..}

  {$ELSE}
    CUUDEvent:=0;

  {$ENDIF}
end;


procedure TWORLine.THUD1FExit(Sender: TObject);
begin
  If (Sender is Text8Pt)  and (ActiveControl<>Candb1Btn) then
    Text8pt(Sender).ExecuteHookMsg;

end;


Function TWORLine.Match_WORLines(ORef   :  Str20;
                             Var IdR    :  Idetail)  :  Boolean;

Const
  Fnum    = IdetailF;
  Keypath = IdFolioK;


Var
  TmpInclude,
  FoundOk :  Boolean;
  MatchStr,
  KeyCS,
  KeyChk  :  Str255;

  RecAddr :  LongInt;



Begin
  With ExLocal do
  Begin
    KeyCS:=ORef; FoundOk:=BOff; TmpInclude:=BOff;

    Status:=Find_Rec(B_GetEq,F[InvF],InvF,LRecPtr[InvF]^,InvOurRefK,KeyCS);

    With LInv do
    {$B-}
    TmpInclude:=((StatusOk) and (InvDocHed=WOR));
    {$B+}

    If TmpInclude then
    With LInv do
    Begin
      KeyChk:=FullIDKey(FolioNum,1);
      KeyCS:=KeyChk;

      Status:=Find_Rec(B_GetEq,F[Fnum],Fnum,LRecPtr[Fnum]^,Keypath,KeyCS);

      {$B-}
      With LId do
      Begin
        FoundOk:=(StatusOk) and (CheckKey(KeyChk,KeyCS,Length(KeyChk),BOn)) and (SOPLink=IdR.FolioRef) and (SOPLineNo=IdR.AbsLineNo) and (MLocStk<>Idr.MLocStk);

        If (FoundOk) then
          IdR:=LId;
      end;
      {$B+}


    end;
  end; {With..}

  Result:=FoundOk;
end;

{== Proc to Pick up all related ADJ nos from the matching file == }

Function TWORLine.Got_ChildWOR(InvR     :  InvRec;
                               IdR      :  IDetail;
                           Var LinkFolio,
                               LinkLine :  LongInt;
                               TKeypath :  Integer;
                               DocMode  :  Byte)  :  Boolean;

Const
  Fnum  =  PWrdF;

Var
  FoundOk      :  Boolean;
  Keypath,
  LastKP       :  Integer;
  TmpStat      :  Integer;
  TmpRecAddr,
  TmpRecAddr2  :  LongInt;
  KeyCS,KeyChk,NKey
               :  Str255;

  LocalInv:  InvRec;
  LocalId :  IDetail;


Begin
  With ExLocal,InvR do
  Begin
    LocalInv:=LInv; LocalId:=LId;

    TmpStat:=Presrv_BTPos(IdetailF,TKeypath,F[IdetailF],TmpRecAddr,BOff,BOff);

    If ((RemitNo<>'') or (OrdMatch)) then
      Keypath:=PWK
    else
      Keypath:=HelpNDXK;

    LastKP:=GetPosKey;

    TmpStat:=Presrv_BTPos(Fnum,LastKP,F[Fnum],TmpRecAddr2,BOff,BOff);

    FoundOk:=BOff;

    KeyChk:=FullMatchKey(MatchTCode,MatchSCode,OurRef);
    KeyCS:=KeyChk;

    Status:=Find_Rec(B_GetGEq,F[Fnum],Fnum,LRecPtr[Fnum]^,Keypath,KeyCS);


    While (StatusOK) and (CheckKey(KeyChk,KeyCS,Length(KeyChk),BOff)) and (Not FoundOk) do
    With LPassword.MatchPayRec do
    Begin
      Case Keypath of
        PWK       :  Begin
                       NKey:=PayRef;
                     end;
        HelpNdxK  :  Begin
                       NKey:=DocCode;
                     end;
      end; {Case..}

      Case DocMode of
        0  :  If (Copy(NKey,1,3)=DocCodes[WOR]) then
                FoundOk:=Match_WORLines(NKey,IdR);


      end; {Case..}

      If (Not FoundOk) then
        Status:=Find_Rec(B_GetNext,F[Fnum],Fnum,LRecPtr[Fnum]^,Keypath,KeyCS)
      else
      With IdR do
      Begin
        LinkFolio:=FolioRef; LinkLine:=ABSLineNo;
      end;


    end;

    TmpStat:=Presrv_BTPos(Fnum,LastKP,F[Fnum],TmpRecAddr2,BOn,BOff);

    TmpStat:=Presrv_BTPos(IdetailF,TKeypath,F[IdetailF],TmpRecAddr,BOn,BOff);

    LInv:=LocalInv; LId:=LocalId;
  end; {With..}

  Result:=FoundOk;

end; {Proc..}

procedure TWORLine.Warn_ChildWOR(LineLink,LinkLine  :  LongInt;
                                 TKeypath           :  Integer);

Const
  Fnum    = IdetailF;
  Keypath = IdFolioK;

Var
  FoundOk      :  Boolean;
  TmpStat      :  Integer;
  TmpRecAddr   :  LongInt;
  KeyCS,KeyChk
               :  Str255;

  LocalId      :  IDetail;

Begin
  With ExLocal do
  Begin
    LocalId:=LId;

    TmpStat:=Presrv_BTPos(IdetailF,TKeypath,F[IdetailF],TmpRecAddr,BOff,BOff);

    KeyChk:=FullIDKey(LineLink,LinkLine);
    KeyCS:=KeyChk;

    Status:=Find_Rec(B_GetEq,F[Fnum],Fnum,LRecPtr[Fnum]^,Keypath,KeyCS);

    With LId do
    If (StatusOk) and (CheckKey(KeyChk,KeyCS,Length(KeyChk),BOn))  and (MLocStk<>LocalId.MLocStk) then
    Begin
      CustomDlg(Application.MainForm,'Warning!','Location Changed',
                             'This line is linked to '+DocPRef+', line '+Form_Int(AbsLineNo,0)+', which uses'+
                             ' location '+MLocStk+'.'+#13+
                             'By making the locations different, automatic picking will not be possible.',
                             mtWarning,
                             [mbOK]);

    end;

    TmpStat:=Presrv_BTPos(IdetailF,TKeypath,F[IdetailF],TmpRecAddr,BOn,BOff);

    LId:=LocalId;
  end; {With..}


end;


procedure TWORLine.A1LOFEnter(Sender: TObject);
begin
  If (Syss.UseMLoc) and (EmptyKey(A1LoF.Text,MLocKeyLen)) then
  Begin
    If (EmptyKey(A1LoF.Text,MLocKeyLen)) then
      A1LoF.Text:=ExLocal.LStock.DefMLoc;
  end;

end;

procedure TWORLine.A1LOFExit(Sender: TObject);
Var
  SCode      :  Str20;
  FoundCode  :  Str10;

  FoundOk,
  AltMod     :  Boolean;

  LineLink,
  LinkLine   :  LongInt;


begin

  {$IFDEF SOP}

    Form2Id;

    If (Sender is Text8pt) then
    With (Sender as Text8pt) do
    Begin
      AltMod:=Modified;

      FoundCode:=Strip('B',[#32],Text);

      Scode:=ExLocal.LId.StockCode;

      If ((AltMod) or (FoundCode='')) and (ActiveControl<>Candb1Btn) and (ActiveControl<>Okdb1Btn)
          and  (Syss.UseMLoc) then
      Begin

        StillEdit:=BOn;

        FoundOk:=(GetMLoc(Self.Owner,FoundCode,FoundCode,SCode,77));

        If (FoundOk) then {* Credit Check *}
        With ExLocal do
        Begin

          AssignFromGlobal(MLocF);

        end;


        If (FoundOk) then
        Begin

          StopPageChange:=BOff;

          StillEdit:=BOff;

          Text:=FoundCode;

          Form2Id;

          With ExLocal.LId do
            SendToObjectStkEnq(StockCode,MLocStk,'',-1,-1,0);

          SetLink_Adj;

          OutId;


          {$B-}
            With ExLocal,LInv,LId do
            Begin
              LineLink:=SOPLink;
              LinkLine:=SOPLineNo;

              If (PORPickSOR) and (((SOPLink<>0) and (SOPLineNo<>0)) or ((LineNo>1) and (Got_ChildWOR(LInv,LId,LineLink,LinkLine,SKeyPath,0))))  then
              Begin
                Warn_ChildWOR(LineLink,LinkLine,SKeypath);

              end;
            end;
          {$B+}

        end
        else
        Begin
          StopPageChange:=BOn;

          SetFocus;
        end; {If not found..}
      end;

    end; {with..}
  {$ENDIF}
end;





procedure TWORLine.FormActivate(Sender: TObject);
begin
  If (JustCreated) then
    SetFieldFocus;

  {$IFDEF SOP}
     OpoLineHandle:=Self.Handle;
  {$ENDIF}

end;




procedure TWORLine.EnableEditPostedFields;
begin
  FAllowPostedEdit := True;

  //UDFs
  THUD1F.AllowPostedEdit := True;
  THUD2F.AllowPostedEdit := True;
  THUD3F.AllowPostedEdit := True;
  THUD4F.AllowPostedEdit := True;
  THUD5F.AllowPostedEdit := True;
  THUD6F.AllowPostedEdit := True;
  THUD7F.AllowPostedEdit := True;
  THUD8F.AllowPostedEdit := True;
  THUD9F.AllowPostedEdit := True;
  THUD10F.AllowPostedEdit := True;
end;

function TWORLine.TransactionViewOnly: Boolean;
begin
  Result := ExLocal.LViewOnly and not FAllowPostedEdit;
end;

Initialization

end.
