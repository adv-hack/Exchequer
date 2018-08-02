unit PaylineU;

{$I DefOvr.Inc}

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  Globvar,VarConst,SBSComp,SupListU,Grids, StdCtrls, Buttons,
  Mask, ExtCtrls, TEditVal, SBSPanel, BorBtns,ExWrap1U, Menus, EntWindowSettings,
  BtSupU1;

Const
  WM_PayGetLine  =  WM_User+$112;


type



  TPayInSetUp  =  Record
                        //PR: 19/03/2009 Extended array to accommodate ReconDate
                        ColPanels   :  Array[0..15] of TSBSPanel;

                        ScrollBox   :  TScrollBox;

                        PropPopUp   :  TMenuItem;

                        CoorPrime   :  Char;
                        CoorHasCoor :  Boolean;
                      end;


  TPayList  =  Class(TGenList)
                                                                                       
    Function SetCheckKey  :  Str255; Override;

    Function SetFilter  :  Str255; Override;

    Function Ok2Del :  Boolean; Override;

    Function OutLine(Col  :  Byte)  :  Str255; Override;

  end;



type
  TPayLine = class(TForm)
    Label87: Label8;
    Label81: Label8;
    Label82: Label8;
    CCLab: Label8;
    DepLab: Label8;
    PICQF: Text8Pt;
    PINAF: Text8Pt;
    PICCF: Text8Pt;
    PIDepF: Text8Pt;
    Candb1Btn: TButton;
    Okdb1Btn: TButton;
    CurLab: Label8;
    PIPIF: Text8Pt;
    PILab: Label8;
    BELab: Label8;
    PICurrF: TSBSComboBox;
    PIAmtF: TCurrencyEdit;
    PIBEF: TCurrencyEdit;
    UDF1L: Label8;
    THUD1F: Text8Pt;
    UDF6L: Label8;
    THUD6F: Text8Pt;
    UDF2L: Label8;
    THUD2F: Text8Pt;
    UDF7L: Label8;
    THUD7F: Text8Pt;
    UDF3L: Label8;
    THUD3F: Text8Pt;
    UDF8L: Label8;
    THUD8F: Text8Pt;
    UDF10L: Label8;
    THUD10F: Text8Pt;
    UDF5L: Label8;
    THUD5F: Text8Pt;
    UDF9L: Label8;
    THUD9F: Text8Pt;
    UDF4L: Label8;
    JALab: Label8;
    PIJAF: Text8Pt;
    THUD4F: Text8Pt;
    JCLab: Label8;
    PIJCF: Text8Pt;
    Label84: Label8;
    PINDF: Text8Pt;
    procedure FormCreate(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure FormDestroy(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure Okdb1BtnClick(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure FormKeyPress(Sender: TObject; var Key: Char);
    procedure Delete1Click(Sender: TObject);
    procedure PINAFExit(Sender: TObject);
    procedure PIAmtFEnter(Sender: TObject);
    procedure PIAmtFExit(Sender: TObject);
    procedure PICCFEnter(Sender: TObject);
    procedure PICCFExit(Sender: TObject);
    procedure PIJCFsExit(Sender: TObject);
    procedure PIJAFExit(Sender: TObject);
    procedure THUD1FExit(Sender: TObject);
    procedure THUD1FEntHookEvent(Sender: TObject);
    procedure SetUDFields(UDDocHed  :  DocTypes);
private
    { Private declarations }
    UDFLabelSettings, UDFFieldSettings: Array[0..9] of TPoint;
    UDFSettingsStored: Boolean;

    Fnum,
    KeyPath      :  Integer;

    VariOn,
    UnVariOn,
    DiscOn,
    InPassing,
    GenSelect,
    GenSelfBal,
    HasStored,
    JustCreated,
    fDoingClose,
    fFrmClosing,
    IdStored     :  Boolean;


    SelfBalNom   :  LongInt;

    SelfBalVal   :  Double;

    ScrollCont   :  TScrollBox;
    FormStoreCoord
                 :  TMenuItem;

    LastId       :  IDetail;

    //PR: 10/11/2010
    FSettings : IWindowSettings;

    //PR: 16/11/2017 ABSEXCH-19451
    FAllowPostedEdit : Boolean;
    function TransactionViewOnly : Boolean;

    procedure ShowJobFields(ShowMode  :  Boolean);


    procedure FormDesign;

    procedure PIPanelMouseDown(Sender: TObject;
                               Button: TMouseButton; Shift: TShiftState; X, Y: Integer);

    procedure PIPanelMouseMove(Sender: TObject;
                               Shift: TShiftState; X, Y: Integer);

    procedure PIPanelMouseUp(Sender: TObject;
                             Button: TMouseButton; Shift: TShiftState; X, Y: Integer);

    Procedure WMPayGetLine(Var Message  :  TMessage); message WM_PayGetLine;


    Procedure Send_UpdateList(Edit   :  Boolean;
                              Mode   :  Integer);


    Function CheckNeedStore  :  Boolean;

    Procedure SetFieldFocus;

    Function ConfirmQuit  :  Boolean;


    procedure SetIdStore(EnabFlag,
                         VOMode  :  Boolean);

    procedure SetFieldProperties(Panel  :  TSBSPanel;
                                 Field  :  Text8Pt) ;
    Procedure RepositionControls;

    procedure StoreUDFDefaults(const Captions : Array of TLabel; const Edits : Array of TCustomEdit);
    Procedure RestoreUDFDefaults(const Captions : Array of TLabel; const Edits : Array of TCustomEdit);


  public
    KillList     :  Boolean;

    GetFolio     :  LongInt;

    { Public declarations }

    MULCtrlO     :  TPayList;

    ExLocal      :  TdExLocal;



    Procedure HookOnMouse;

    procedure Find_PayInCoord(CPrimeKey  :  Char;
                              CHCoor     :  Boolean);

    Procedure CreateList(AOwner          :  TComponent;
                         PayInSetup      :  TPayInSetUp;
                         ShowLines       :  Boolean;
                         TInv            :  InvRec);



    Procedure RefreshList(NFolio  :  LongInt);

    Procedure OutPay;

    Procedure Form2Pay;

    procedure ProcessPay(Edit,
                         InsMode,
                         ViewOnly    :  Boolean);

    Function CheckCompleted(Edit,MainChk  :  Boolean)  : Boolean;

    procedure StorePay(Edit  :  Boolean);

    procedure DeletePayLine(InvR  :  InvRec);

    procedure ShowLink(Const InvR      :  InvRec;
                       Const VOMode    :  Boolean);

    procedure AddEditPay(Const Edit,VOMode  :  Boolean;
                         Const SBNom        :  LongInt;
                         Const SBValue      :  Double;
                         Const InvR         :  InvRec);



    procedure SetFormProperties;

    procedure CtrlView;

    //PR: 16/11/2017 ABSEXCH-19451
    procedure EnableEditPostedFields;

    property WindowSettings : IWindowSettings read FSettings write FSettings;

  end;


{~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~}

Implementation

{~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~}


{$R *.DFM}


Uses
  ETStrU,
  ETDateU,
  ETMiscU,
  BtrvU2,
  BtKeys1U,
  SBSComp2,
  BTSupU2,
  CurrncyU,
  ComnUnit,
  ComnU2,

  {$IFDEF PF_On}

     InvLst2U,

  {$ENDIF}

  ColCtrlU,
  CmpCtrlU,
  SysU2,
  SysU3,
  MiscU,
  SaleTx2U,
  RecepU,

  InvListU,

  PayF2U,

  {$IFDEF DBD}
    DebugU,
  {$ENDIF}

  {$IFDEF CU}
    Event1U,

  {$ENDIF}

  PassWR2U,
  Saltxl1U,
  //GS 19/10/ 2011 ABSEXCH-11706: access to the new user defined fields interface
  CustomFieldsIntF,

  VarRec2U,
  JobUtils;





{ ============ TPayList Methods ================= }


Procedure TPayLine.RepositionControls;
var
  VisibleFieldCount: Integer;
begin
  //GS 20/10/2011 ABSEXCH-11706: due to the way the form is designed it expands
  //and contracts in size along with the extension form; this procedure
  //repositions and resizes certain controls when the form is resized

  //determine how many UDFs are visible
  VisibleFieldCount := NumberOfVisibleUDFs([THUD1F, THUD2F, THUD3F, THUD4F, THUD5F, THUD6F, THUD7F, THUD8F, THUD9F, THUD10F]);

  //adjust the forms controls to accomodate the visible UDFs; use different settings depending on the quantity visible

  if VisibleFieldCount = 0 then
  begin
    //default the form setup to support zero visible user defined fields
    Self.ClientHeight := 83;
    Self.ClientWidth := 598;
    Okdb1Btn.Left := 423;
    Okdb1Btn.Top := 58;
    Candb1Btn.Left := 507;
    Candb1Btn.Top := 58;
  end
  else if VisibleFieldCount > 4 then
  begin
    Self.ClientHeight := 157;
    Self.ClientWidth := 768;
    Okdb1Btn.Left := 599;
    Okdb1Btn.Top := 132;
    Candb1Btn.Left := 683;
    Candb1Btn.Top := 132;
  end
  else
  begin
    Self.ClientHeight := 157;
    Self.ClientWidth := 611;
    Okdb1Btn.Left := 439;
    Okdb1Btn.Top := 132;
    Candb1Btn.Left := 523;
    Candb1Btn.Top := 132;
  end;

  //make additional adjustments depending on how many full UDF rows are hidden
  if VisibleFieldCount <> 0 then
  begin
    ResizeUDFParentContainer(VisibleFieldCount, 5, self);
    ResizeUDFParentContainer(VisibleFieldCount, 5, Okdb1Btn);
    ResizeUDFParentContainer(VisibleFieldCount, 5, Candb1Btn);
  end;

end;

Function TPayList.SetCheckKey  :  Str255;


Var
  DumStr  :  Str255;

Begin
  FillChar(DumStr,Sizeof(DumStr),0);

  With Id do
  Begin
    DumStr:=FullIdKey(FolioRef,LineNo);
  end;

  SetCheckKey:=DumStr;
end;




Function TPayList.SetFilter  :  Str255;

Begin

  SetFilter:=ID.Payment;

end;


Function TPayList.Ok2Del :  Boolean;

Begin
  With Id do
    Result:=((PostedRun = 0) or (PostedRun=StkAdjRunNo));;
end;


{ ========== Generic Function to Return Formatted Display for List ======= }

Function TPayList.OutLine(Col  :  Byte)  :  Str255;

Var
  UOR        :  Byte;

  FoundOk    :  Boolean;

  FoundLong  :  LongInt;

  Dnum       :  Double;

  ExLocal    : ^TdExLocal;

Begin

  ExLocal:=ListLocal;

  UOR:=0;

   With Id do
     Case Col of
       0  :  OutLine:=Form_Int(NomCode,0);

       1  :  Begin
               FoundOk:=GetNom(Self,Form_Int(NomCode,0),FoundLong,-1);

               OutLine:=Nom.Desc;
             end;

       2  :  OutLine:=Desc;

       3  :  Begin

               OutLine:=FormatCurFloat(GenRealMask,NetValue,BOff,Currency);

             end;

       {$IFDEF MC_On}

         4  :  Begin

                 If (NomCode<>Syss.NomCtrlCodes[CurrVar]) and (NomCode<>Syss.NomCtrlCodes[SDiscNom(IdDocHed)]) and (NomCode<>Syss.NomCtrlCodes[UnRCurrVar]) then
                 Begin
                 {** Use Inv CXRate to stop Unposted Allocated Items
                     becomming incorrect because the line Co Rate is
                     not set unless Variance Line, then show with own **}
                   UOR:=fxUseORate(BOff,BOn,ExLocal.LInv.CXRate,UseORate,Currency,0);

                   Dnum:=Conv_TCurr(NetValue,XRate(ExLocal.LInv.CXRate,BOff,Currency),Currency,UOR,BOff);
                 end
                 else
                 Begin
                   UOR:=fxUseORate(BOff,BOn,CXRate,UseORate,Currency,0);

                   Dnum:=Conv_TCurr(NetValue,XRate(CXRate,BOff,Currency),Currency,UOR,BOff);
                 end;

                 OutLine:=FormatCurFloat(GenRealMask,Dnum,BOff,0);

               end;
       {$ENDIF}

         5  :  Begin
                 Case DisplayMode of
                   0  :  If (PostedRun>0) then
                           OutLine:=Extract_PayRef2(Id.StockCode)
                         else
                           OutLine:=Extract_PayRef1(Id.StockCode);

                   1  :  OutLine:=GetReconcileStatus(Reconcile);

                 end; {Case..}
               end;
          //PR: 19/03/2009 Added functionality for Reconciliation Date
         6:    if ValidDate(ReconDate) and (ReconDate < MaxUntilDate) then
                 Outline := POutDate(Id.ReconDate)
               else
                 Outline := '';

       else    OutLine:='';


     end; {Case..}
end;



procedure TPayLine.ShowJobFields(ShowMode  :  Boolean);
Begin
  PIJCF.Visible:=ShowMode;
  PIJAF.Visible:=ShowMode;
  JCLab.Visible:=ShowMode;
  JALab.Visible:=ShowMode;
end;

//GS 19/10/2011 ABSEXCH-11706: a copy of pauls user fields function
//PR: 14/11/2011 Amended to use centralised function EnableUdfs in CustomFieldsIntf.pas ABSEXCH-12129
procedure TPayLine.SetUDFields(UDDocHed  :  DocTypes);
var
  CFCategory: Integer;
begin
{$IFDEF ENTER1}

  //over-ride CFCategory for certain doc types
  if UDDocHed = SRI then
  begin
    CFCategory := cfSRCLine;
  end
  else if UDDocHed = PPI then
  begin
    CFCategory := cfPRCLine;
  end
  else
  begin
    CFCategory := DocTypeToCFCategory(UDDocHed, True);
  end;

  //if UDF field co-ord settings have not been stored before; then store then
  //however if we have stored settings, restore them
  //this reinitialises the UDF controls whenever it is opened; works around the fact that the
  //form is not destroyed when it is closed, only hidden until it is reopened again; consequently retaining old settings
  if UDFSettingsStored = False then
  begin
    StoreUDFDefaults([UDF1L, UDF2L, UDF3L, UDF4L, UDF5L, UDF6L, UDF7L, UDF8L, UDF9L, UDF10L],
             [THUD1F, THUD2F, THUD3F, THUD4F, THUD5F, THUD6F, THUD7F, THUD8F, THUD9F, THUD10F]);
  end
  else
  begin
    RestoreUDFDefaults([UDF1L, UDF2L, UDF3L, UDF4L, UDF5L, UDF6L, UDF7L, UDF8L, UDF9L, UDF10L],
             [THUD1F, THUD2F, THUD3F, THUD4F, THUD5F, THUD6F, THUD7F, THUD8F, THUD9F, THUD10F]);
  end;

  EnableUDFs([UDF1L, UDF2L, UDF3L, UDF4L, UDF5L, UDF6L, UDF7L, UDF8L, UDF9L, UDF10L],
             [THUD1F, THUD2F, THUD3F, THUD4F, THUD5F, THUD6F, THUD7F, THUD8F, THUD9F, THUD10F],
             CFCategory);

  RepositionControls;
{$ENDIF}
end;


procedure TPayLine.FormDesign;

Var
  HideCC  :  Boolean;

Begin

  {$IFNDEF MC_On}
     PIBEF.Visible:=BOff;
     BELab.Visible:=BOff;
     CurLab.Visible:=BOff;
     PICurrF.Visible:=BOff;


  {$ELSE}

     Set_DefaultCurr(PICurrF.Items,BOff,BOff);
     Set_DefaultCurr(PICurrF.ItemsL,BOff,BOn);

  {$ENDIF}


  HideCC:=BOff;


  {$IFNDEF PF_On}

    HideCC:=BOn;

  {$ELSE}

    HideCC:=Not Syss.UseCCDep;
  {$ENDIF}

  CCLab.Visible:=Not HideCC;
  DepLab.Visible:=Not HideCC;
  PICCF.Visible:=Not HideCC;
  PIDepF.Visible:=Not HideCC;

  ShowJobFields(JBCostOn);

  If (Not Syss.UsePayIn) then
  Begin
    PIPIF.Visible:=BOff;
    PILab.Visible:=BOff;
  end;



  //GS 11/11/2011 ABSEXCH-12126: use client height instead of height
  ClientHeight := 132;
  ClientWidth:=786;

  With TForm(Owner) do
    Self.Left:=Left+2;

  //PII Field shape create issue fixed
  SetUDFields(Inv.InvDocHed);

end;

procedure TPayLine.FormCreate(Sender: TObject);
begin
  fDoingClose:=BOff;
  JustCreated:=BOff;

  fFrmClosing:=BOff;
  ExLocal.Create;

  KillList:=BOff;
  Fnum:=IdetailF;
  KeyPath:=IdFolioK;

  ScrollCont:=Nil;


  FormDesign;

  VariOn:=BOff;
  UnVariOn:=BOff;
  DiscOn:=BOff;
  InPassing:=BOff;
  GenSelect:=BOff;
  GenSelfBal:=BOff;

  HasStored:=BOff;

  SelfBalNom:=0;
  SelfBalVal:=0;


  If (Owner is TSalesTBody) then
  Begin
    With TSalesTBody(Owner) do
      Self.SetFieldProperties(I1FPanel,I1AccF)
  end
  else
  If (Owner is TRecepForm) then
  Begin
    With TRecepForm(Owner) do
      Self.SetFieldProperties(R1FPanel,R1AccF);
  end;

end;

procedure TPayLine.FormCloseQuery(Sender: TObject; var CanClose: Boolean);

Var
  Ok2Close  :  Boolean;
  Inum      :  Integer;

begin
  If (Not fFrmClosing) then
  Begin
    fFrmClosing:=BOn;

    Try
      Ok2Close:=ConfirmQuit;

      If (Ok2Close) then
      Begin

        CanClose:=(FormStyle=fsNormal);

        Inum:=Width;
        Width:=0;
        FormStyle:=fsNormal;
        Visible:=BOff;
        Width:=Inum;

        {If (Not CanClose) then {* it is part of the final close, no msg necessary *}
        {* Was checking for canclose up to v4.20b, but this broke normal SRI's working. Fixed by sending message anyway. *}
        If (HasStored) then
          Send_UpdateList(BOff,108);

        HasStored:=BOff;  {* Added v4.22 as otherwise changing the value of the line, then the header kept resetting
        the header value back to the total captured when the line was changed. This was caused by GenCanClose calling this
        routine as part of the completeness check}
      end
      else
        CanClose:=BOff;
    Finally
      fFrmClosing:=BOff;
    end;
  end
  else
    CanClose:=BOff;

end;


procedure TPayLine.FormDestroy(Sender: TObject);
begin

  If (Not fDoingClose) then
  Begin
    fDoingClose:=BOn;

    ExLocal.Destroy;

    Begin
      Try
        If (MULCtrlO<>Nil) then
          MULCtrlO.Destroy; {* Must be destroyed here, as owned by ROB1...}

      Finally

        MULCtrlO:=Nil;

      end; {Finally..}

    end;

  end;

  FSettings := nil;
end;

procedure TPayLine.FormShow(Sender: TObject);
begin
  PINAF.SetFocus;
end;


Procedure TPayLine.HookOnMouse;

Var
  n  :  Byte;

Begin

  With MULCtrlO,VisiList do
  Begin

    For n:=0 to Count-1 do
    Begin
      VisiRec:=List[n];

      With VisiRec^ do
      Begin
        TSBSPanel(PanelObj).OnMouseUp:=PIPanelMouseUp;

        TSBSPanel(LabelObj).OnMouseMove:=PIPanelMouseMove;

        TSBSPanel(LabelObj).OnMouseDown:=PIPanelMouseDown;

        TSBSPanel(LabelObj).OnMouseUp:=PIPanelMouseUp;

      end; {With..}

    end; {Loop..}
  end; {With..}

end;



procedure TPayLine.Find_PayInCoord(CPrimeKey  :  Char;
                                   CHCoor     :  Boolean);


Var
  GlobComp:  TGlobCompRec;


Begin
  if Assigned(FSettings) then
  begin
    FSettings.SettingsToParent(MULCtrlO);
    EXIT;
  end;

  New(GlobComp,Create(BOn));

  With GlobComp^ do
  Begin
    GetValues:=BOn;

    PrimeKey:=CPrimeKey;
    HasCoord:=CHCoor;

    MULCtrlO.Find_ListCoord(GlobComp);

  end; {With GlobComp..}


  Dispose(GlobComp,Destroy);


end;


Procedure TPayLine.CreateList(AOwner          :  TComponent;
                              PayInSetup      :  TPayInSetUp;
                              ShowLines       :  Boolean;
                              TInv            :  InvRec);

Var
  Key2F    :  Str255;

  StartPanel
           :  TSBSPanel;

  n        :  Byte;

  NFolio   :  LongInt;


Begin
  StartPanel := nil;
  ExLocal.LInv:=TInv;


  With ExLocal.LInv do
    NFolio:=FolioNum;

    Key2F:=FullIdKey(NFolio,RecieptCode);

  If (AOwner is TForm) and (MULCtrlO=Nil) then
  Begin


    MULCtrlO:=TPayList.Create(Self);
    MulCtrlO.Name := 'List_PayLines';


    Try

      With MULCtrlO do
      Begin

        Try

          With VisiList,PayInSetUp do
          Begin
            AddVisiRec(ColPanels[0],ColPanels[1]);
            AddVisiRec(ColPanels[2],ColPanels[3]);
            AddVisiRec(ColPanels[4],ColPanels[5]);
            AddVisiRec(ColPanels[6],ColPanels[7]);
            AddVisiRec(ColPanels[8],ColPanels[9]);
            AddVisiRec(ColPanels[10],ColPanels[11]);

            AddVisiRec(ColPanels[14],ColPanels[15]);

            VisiRec:=List[0];

            StartPanel:=(VisiRec^.PanelObj as TSBSPanel);

            ScrollCont:=ScrollBox;

            FormStoreCoord:=PropPopUp;

            {$IFNDEF MC_On} {* Hide Base Equiv Panel *}

              SetHidePanel(4,BOn,BOn);

            {$ENDIF}

            Find_PayInCoord(CoorPrime,CoorHasCoor);
          end;

        except
          VisiList.Free;

        end;

        {Find_FormCoord;}


        HookOnMouse;

        TabOrder := -1;
        TabStop:=BOff;
        Visible:=BOff;
        BevelOuter := bvNone;
        ParentColor := False;
        Color:=StartPanel.Color;
        MUTotCols:=6;
        Font:=StartPanel.Font;
        LinkOtherDisp:=Bon;

        WM_ListGetRec:=WM_CustGetRec;


        Parent:=StartPanel.Parent;

        MessHandle:=TForm(Self.Owner).Handle;

        For n:=0 to MUTotCols do
        With ColAppear^[n] do
        Begin
          AltDefault:=BOn;

          If (n In [0,3,4]) then
          Begin
            DispFormat:=SGFloat;

            If (n<>0) then
              NoDecPlaces:=2
            else
              NoDecPlaces:=0;

          end;
        end;

        ListLocal:=@ExLocal;

        ListCreate;

        With PayInSetUp do
        Begin
          VisiList.LabHedPanel:=ColPanels[12];

          Set_Buttons(ColPanels[13]);
        end;

        StartList(Self.Fnum,Self.Keypath,Key2F,Key2F,'',Length(Key2F),Not ShowLines);

      end {With}


    Except

      MULCtrlO.Free;
      MULCtrlO:=Nil;
    end;


    {FormSetOfSet;}


  end
  else
    If (MULCtrlO<>Nil) then
    With MULCtrlO do
      StartList(Self.Fnum,Self.KeyPath,Key2F,Key2F,'',Length(Key2F),(NFolio=GetFolio));

  GetFolio:=NFolio;

end; {Proc..}


{ ======= Refresh list for scan  ====== }

Procedure TPayLine.RefreshList(NFolio  :  LongInt);

Var
  OldKey2F,
  Key2F  :  Str255;

Begin

  OldKey2F:=FullIdKey(GetFolio,RecieptCode);

  Key2F:=FullIdKey(NFolio,RecieptCode);



  If (MULCtrlO<>Nil) then
  With MULCtrlO do
    StartList(Self.Fnum,Self.KeyPath,Key2F,Key2F,'',Length(Key2F),(Key2F=OldKey2F));

  GetFolio:=NFolio;

end; {Proc..}



Function TPayLine.CheckNeedStore  :  Boolean;
Begin
  Result:=CheckFormNeedStore(Self);
end;


Procedure TPayLine.SetFieldFocus;

Begin
  With ExLocal do
    PINAF.SetFocus;
end; {Proc..}


Function TPayLine.ConfirmQuit  :  Boolean;

Var
  MbRet  :  Word;
  TmpBo  :  Boolean;

Begin


  TmpBo:=BOff;

  If (ExLocal.InAddEdit) and (CheckNeedStore) and (Not TransactionViewOnly) and (Not IdStored) then
  Begin
    mbRet:=MessageDlg('Save changes to '+Caption+'?',mtConfirmation,[mbYes,mbNo,mbCancel],0);
  end
  else
    mbRet:=mrNo;

  Case MbRet of

    mrYes  :  Begin
                StorePay(ExLocal.LastEdit);
                TmpBo:=(Not ExLocal.InAddEdit);
              end;

    mrNo   :  With ExLocal do
              Begin
                If (LastEdit) and (Not LViewOnly) and (Not IdStored) then
                  Status:=UnLockMLock(IdetailF,LastRecAddr[IdetailF]);

                Send_UpdateList(BOff,120);

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


procedure TPayLine.SetIdStore(EnabFlag,
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

end;



{ === Procedure to Output one Line record === }

Procedure TPayLine.OutPay;

Var
  UOR       :  Byte;

  Dnum      :  Double;

  FoundOk   :  Boolean;
  FoundLong :  LongInt;

Begin
  Dnum:=0; UOR:=0;

  With ExLocal.LId do
  Begin
    PINAF.Text:=Form_BInt(NomCode,0);
    PICQF.Text:=Desc;

    
    If (PostedRun>0) then
      PIPIF.Text:=Extract_PayRef2(StockCode)
    else
      PIPIF.Text:=Extract_PayRef1(StockCode);

    PICCF.Text:=CCDep[BOn];
    PIDepF.Text:=CCDep[BOff];

    PIAMTF.Value:=NetValue;

    {$IFDEF MC_On}
      If (Currency>0) then
        PICurrF.ItemIndex:=Pred(Currency);

      If (NomCode<>Syss.NomCtrlCodes[CurrVar]) and (NomCode<>Syss.NomCtrlCodes[SDiscNom(IdDocHed)]) then
      {** Use Inv CXRate to stop Unposted Allocated Items
          becomming incorrect because the line Co Rate is
          not set unless Variance Line, then show with own **}
      Begin
        UOR:=fxUseORate(BOff,BOn,ExLocal.LInv.CXRate,UseORate,Currency,0);

        Dnum:=Conv_TCurr(NetValue,XRate(ExLocal.LInv.CXRate,BOff,Currency),Currency,UOR,BOff)
      end
      else
      Begin
        UOR:=fxUseORate(BOff,BOn,CXRate,UseORate,Currency,0);

        Dnum:=Conv_TCurr(NetValue,XRate(CXRate,BOff,Currency),Currency,UOR,BOff);
      end;

      PIBEF.Value:=Dnum;
    {$ENDIF}

    PIJCF.Text:=Strip('R',[#32],JobCode);
    PIJAF.Text:=Strip('R',[#32],AnalCode);

    FoundOk:=GetNom(Self,PINAF.Text,FoundLong,-1);

    PINDF.Text:=Nom.Desc;

    THUd1F.Text:=LineUser1;
    THUd2F.Text:=LineUser2;
    THUd3F.Text:=LineUser3;
    THUd4F.Text:=LineUser4;
    //GS 19/10/2011 ABSEXCH-11706: put customisation values into text boxes
    THUd5F.Text:=LineUser5;
    THUd6F.Text:=LineUser6;
    THUd7F.Text:=LineUser7;
    THUd8F.Text:=LineUser8;
    THUd9F.Text:=LineUser9;
    THUd10F.Text:=LineUser10;
                                                      
    JustCreated:=BOff;

  end; {with..}

end; {Proc..}


{ === Procedure to Output one cust record === }

Procedure TPayLine.Form2Pay;

Begin

  With EXLocal.LId do
  Begin
    NomCode:=IntStr(PINAF.Text);
    Desc:=PICQF.Text;

    If (Syss.UsePayIn) then
    begin
      //PR: 16/11/2017 ABSEXCH-19451 If we're editing a posted transaction
      //then we have to use the existing prefix chars
      if PostedRun > 0 then
        StockCode := Copy(StockCode, 1, 6) + LJVar(PIPIF.Text, 10)
      else
        StockCode:=Pre_PostPayInKey(PayInCode,PIPIF.Text);

    end;

    CCDep[BOn]:=PICCF.Text;
    CCDep[BOff]:=PIDepF.Text;

    {$IFDEF MC_On}

      {* Not needed, as cannot set manualy *}
      {Currency:=Succ(PICurrF.ItemIndex);}
    {$ENDIF}

    If (JBCostOn) then
    Begin
      JobCode:=FullJobCode(PIJCF.Text);
      AnalCode:=FullJACode(PIJAF.Text);
    end;

    NetValue:=PIAMtF.Value;

    LineUser1:=THUd1F.Text;
    LineUser2:=THUd2F.Text;
    LineUser3:=THUd3F.Text;
    LineUser4:=THUd4F.Text;
    //GS 18/10/2011 ABSEXCH-11706: write udef field values into customisation object
    LineUser5:=THUd5F.Text;
    LineUser6:=THUd6F.Text;
    LineUser7:=THUd7F.Text;
    LineUser8:=THUd8F.Text;
    LineUser9:=THUd9F.Text;
    LineUser10:=THUd10F.Text;

  end; {with..}

end; {Proc..}




(*  Add is used to add Notes *)

procedure TPayLine.ProcessPay(Edit,
                            InsMode,
                            ViewOnly    :  Boolean);

Var
  KeyS  :  Str255;

  LOk,
  Locked
        :  Boolean;
  JobCCDept: CCDepType;
Begin

  Addch:=ResetKey;

  KeyS:='';  LOk:=BOff; Locked:=BOff;

  ExLocal.InAddEdit:=BOn;

  ExLocal.LastEdit:=Edit;
  ExLocal.LastIns:=InsMode;

  IdStored:=BOff;

  If (Edit) or (InsMode) then
    With MULCtrlO do
    Begin
      RefreshLine(MUListBoxes[0].Row,BOn);
      ExLocal.AssignFromGlobal(Fnum);
    end;

  If (Edit) then
  Begin

    With ExLocal do
    Begin
      LGetRecAddr(Fnum);

      //PR: 16/11/2017 ABSEXCH-19451 Allow edit posted transaction
      If (Not TransactionViewOnly) then
        LOk:=LGetMultiRec(B_GetDirect,B_MultLock,KeyS,KeyPAth,Fnum,BOff,Locked)
      else
      Begin
        LOk:=BOn;
      end;

    end;

    If (Not LOk) or ((Not Locked) and (Not ExLocal.LViewOnly)) then
      AddCh:=Esc;
  end;



  If (Addch<>Esc) then
  With ExLocal,LId do
  begin

    If (Not Edit) then
    Begin

      LResetRec(Fnum);

      FolioRef:=LInv.FolioNum;

      DocPRef:=LInv.OurRef;

      LineNo:=RecieptCode;

      ABSLineNo:=LInv.ILineCount;

      IDDocHed:=LInv.InvDocHed;

      Qty:=1;

      Currency:=LInv.Currency;

      CXRate:=LInv.CXRate;

      CurrTriR:=LInv.CurrTriR;

      PYr:=LInv.ACYr;
      PPr:=LInv.AcPr;

      Payment:=SetRPayment(LInv.InvDocHed);

      If (Syss.AutoClearPay) then
        Reconcile:=ReconC;



      CustCode:=LInv.CustCode;

      PDate:=LInv.TransDate;

      If (IDDocHed In ChequeSet) and (Syss.AutoCQNo) then
        Desc:=Get_NextChequeNo(BOff);


      {$IFDEF PF_On}

        If (Syss.UseCCDep) and (LCust.CustCode=CustCode) then
        Begin
          {CCDep[BOn]:=LCust.CustCC; v4.32 method
          CCDep[BOff]:=LCust.CustDep;}

          // CJS 2013-09-13 - ABSEXCH-13192 - add Job Costing to user profile rules
          JobUtils.GetJobCCDept(ExLocal.LId.JobCode, JobCCDept);
          With LCust do
            CCDep:=GetCustProfileCCDepEx(CustCC,CustDep,CCDep,JobCCDept,1);

        end;

      {$ENDIF}



    end;

    LastId:=LId;

    If (GenSelfBal) and (Not Edit) then
    Begin
      NomCode:=SelfBalNom;
      NetValue:=SelfBalVal;
      GenSelfBal:=BOff;
    end;


    OutPay;


    SetIdStore(BOn,ExLocal.LViewOnly);


  end; {If Abort..}

  If (Not Visible) then
    FormStyle:=fsMDIChild
  else
  Begin

    Show;

    BringToFront;


  end;


end; {Proc..}




Function TPayLine.CheckCompleted(Edit,MainChk  :  Boolean)  : Boolean;

Const
  NofMsgs      =  8;

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

  FoundLong
           :  LongInt;

  BalNow   :  Double;


Begin
  New(PossMsg);
  ShowMsg := False;

  FillChar(PossMsg^,Sizeof(PossMsg^),0);

  PossMsg^[1]:='General Ledger Code is not valid.';
  PossMsg^[2]:='An additional check is made via an external hook';
  PossMsg^[3]:=' Cost Centre/ Department Code not valid.';
  PossMsg^[4]:='Job Code is not valid.';
  PossMsg^[5]:='Job Analysis Code is not Valid.';
  PossMsg^[6]:='That G/L and currency combination are not allowed.';
  PossMsg^[7]:='Maximum line value exceeded.';
  PossMsg^[8]:='A valid Job code must be present for that G/L Code.';


  Loop:=BOff;

  Test:=1;

  Result:=BOn;

  BalNow:=InvLTotal(ExLocal.LId,BOff,0);


  While (Test<=NofMsgs) and (Result) do
  With ExLocal,LId do
  Begin
    ExtraMsg:='';

    ShowMsg:=BOn;

    Case Test of

      1  :  Begin
              Result:=(BalNow=0);

              If (Not Result) then
              Begin
                Result:=GetNom(Self,Form_Int(NomCode,0),FoundLong,-1);

                If (Result) and (Not SBSIn) then
                  Result:=(Nom.NomType In BankSet+ProfitBFSet);
              end;

            end;



      {$IFDEF PF_On}
        2  :  Begin {* Opportunity for hook to validate this line as well *}
                 {$IFDEF CU}

                   Result:=ValidExitHook(4000,24,ExLocal);
                   ShowMsg:=BOff;

                 {$ENDIF}
              end;

        3  :  Begin
                Result:=((Not Syss.UseCCDep) or (Not LComplete_CCDep(LId,BalNow)));

                If (Not Result) then
                Begin
                  Result:=BOn;
                  For Loop:=BOff to BOn do
                  Begin

                    Result:=(GetCCDep(Self,CCDep[Loop],FoundCode,Loop,-1) and (Result));

                  end;
                end;

              end;

        4  :  Begin

                Result:=((Not JBCostOn) or (Not LComplete_JobAnl(LId,BalNow)) or (EmptyKey(JobCode,JobCodeLen)));

                If (Not Result) then
                  Result:=GetJob(Self,JobCode,FoundCode,-1);

              end;

        5  :  Begin

                Result:=((Not JBCostOn) or (Not LComplete_JobAnl(LId,BalNow)) or (EmptyKey(JobCode,JobCodeLen)));

                If (Not Result) then
                  Result:=GetJobMisc(Self,AnalCode,FoundCode,2,-1);

              end;


      {$ENDIF}

      6  :  Begin
              Result:=Check_GLCurr(LInv,LId,0);
            end;

      7  :  Begin

              Result:=(BalNow<=MaxLineValue);

            end;

      8  :  Result:=Check_GLJC(LInv,LId,0);


    end;{Case..}

    If (Result) then
      Inc(Test);

  end; {While..}

  If (Not Result) and (ShowMsg) and (Not MainChk) then
    mbRet:=MessageDlg(ExtraMsg+PossMsg^[Test],mtWarning,[mbOk],0);

  Dispose(PossMsg);

end; {Func..}


procedure TPayLine.StorePay(Edit   :  Boolean);

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

    Form2Pay;


    With ExLocal,LId do
    Begin

      COk:=CheckCompleted(LastEdit,BOff);


      If (COk) then
      Begin
        Cursor:=CrHourGlass;

        {
          CJS 24/01/2011 - ASBEXCH-9963 - Silently make sure that NOMMODE
          holds the correct value. If it is 2 (StkAdjNomMode), reset it
          to 0.
        }
        if (IdDocHed <> ADJ) and (NomMode = 2) then
          NomMode := 0;

        If (Edit) then
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
          Inc(LInv.ILineCount);


          Status:=Add_Rec(F[Fnum],Fnum,LRecPtr[Fnum]^,KeyPAth);

        end;

        Report_BError(Fnum,Status);

        //PR: 16/11/2017 ABSEXCH-19451 Allow edit posted transaction
        If (StatusOk) and not LViewOnly then
        Begin
          HasStored:=BOn;

          With MULCtrlO do
          Begin
            AddNewRow(MUListBoxes[0].Row,Edit);
          end;

          With LastId  do
            UpdateRecBal(LInv,NomCode,(NetValue*DocNotCnst),0.0,CXRate,Currency,UseORate,1);

          With LId do
            UpdateRecBal(LInv,NomCode,NetValue,0.0,CXRate,Currency,UseORate,1);

          With LId do
            If (IDDocHed In ChequeSet) and (Syss.AutoCQNo) then
              Put_NextChequeNo(Desc,BOn);

          {$IFDEF PF_On}

            If (JbCostOn) and ((DetLTotal(LId,BOn,BOff,0.0)<>0) or (DetLTotal(LastId,BOn,BOff,0.0)<>0) or (LId.IdDocHed In StkADJSplit))
              and (Not (LId.IdDocHed In PurchSet)) then

              Update_JobAct(LId,LInv);

          {$ENDIF}

         end;

        { CJS 2013-08-06 - ABSEXCH-14210 - Access violation when storing Transaction }
        Cursor := CursorState;

        InAddEdit:=Boff;

        MULCtrlO.PageUpDn(0,BOn);
        MULCtrlO.MUListBoxes[0].SetFocus;

        If (LastEdit) then
          ExLocal.UnLockMLock(Fnum,LastRecAddr[Fnum]);

        SetIdStore(BOff,BOff);

        IdStored:=BOn;

        LastValueObj.UpdateAllLastValues(Self);

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





procedure TPayLine.Okdb1BtnClick(Sender: TObject);
begin
  If (Sender=OKdb1Btn) then
  begin
    // Move focus to OK button to force OnExit validation/formatting to kick in
    If OKdb1Btn.CanFocus Then
      OKdb1Btn.SetFocus;
    // If focus isn't on the OK button then that implies a validation error so the store should be abandoned
    If (ActiveControl = OKdb1Btn) Then
    begin
      StorePay(ExLocal.LastEdit);
    end;
  end
  else
  Begin
    ExLocal.InAddEdit:=Boff;
    Close;
  end;

end;


procedure TPayLine.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  GlobFormKeyDown(Sender,Key,Shift,ActiveControl,Handle);

end;

procedure TPayLine.FormKeyPress(Sender: TObject; var Key: Char);
begin
  GlobFormKeyPress(Sender,Key,ActiveControl,Handle);

end;

procedure TPayLine.DeletePayLine(InvR  :  InvRec);

Var
  MbRet  :  Word;
  KeyS   :  Str255;

Begin
  ExLocal.LInv:=InvR;

  With ExLocal,MULCtrlO do
    If (PageKeys^[MUListBoxes[0].Row]<>0) and (ValidLine) and (Not InListFind) then
    Begin
      MbRet:=MessageDlg('Please confirm you wish'#13+'to delete this Line',
                         mtConfirmation,[mbYes,mbNo],0);

      If (MbRet=MrYes) then
      Begin

        RefreshLine(MUListBoxes[0].Row,BOff);

        Ok:=LGetMultiRec(B_GetDirect,B_MultLock,KeyS,KeyPath,ScanFileNum,BOn,GlobLocked);

        If (Ok) and (GlobLocked) then
        Begin

          Status:=Delete_Rec(F[ScanFileNum],ScanFilenum,KeyPath);

          Report_BError(ScanFileNum,Status);
        end;

        If (StatusOk) then
        Begin
          With LId do
            UpdateRecBal(LInv,NomCode,(NetValue*DocNotCnst),0.0,CXRate,Currency,UseORate, 6);
            //HV 20-02-2017 ABSEXCH-16581 - Copy reversing a transaction with currency variance which is then altered throws up a warning message where the only option is to crash out

          {$IFDEF PF_On}

            If (Not EmptyKey(LId.JobCode,JobCodeLen)) then
              Delete_JobAct(LId);

          {$ENDIF}

          With MULCtrlO do
          Begin
            If (MUListBox1.Row<>0) then
              PageUpDn(0,BOn)
            else
              InitPage;
          end;

          Send_UpdateList(BOff,108);

        end;
      end;
    end; {If line is valid for deletion..}
end; {PRoc..}


Procedure TPayLine.WMPayGetLine(Var Message  :  TMessage);

Var
  TBo  :  Boolean;

Begin

  With Message do
  Case WParam of

    0  :  If (Not ExLocal.InAddEdit) then
          With Exlocal do
          Begin
            ProcessPay(BOn,BOff,LViewOnly);

          end;


  end;

end;


procedure TPayLine.PIPanelMouseDown(Sender: TObject;
Button: TMouseButton; Shift: TShiftState; X, Y: Integer);

Var
  ListPoint  :  TPoint;


begin
  If (Sender is TSBSPanel) then
  With (Sender as TSBSPanel) do
  Begin

    If (Not ReadytoDrag) and (Button=MBLeft) then
    Begin
      MULCtrlO.VisiList.PrimeMove(Sender);
      Send_UpdateList(BOff,25);

    end
    else
      If (Button=mbRight) then
      Begin
        ListPoint:=ClientToScreen(Point(X,Y));

        {ShowRightMeny(ListPoint.X,ListPoint.Y,0);}
      end;

  end;
end;

procedure TPayLine.PIPanelMouseMove(Sender: TObject;
  Shift: TShiftState; X, Y: Integer);
begin
  If (Sender is TSBSPanel) then
  With (Sender as TSBSPanel) do
  Begin
    MULCtrlO.VisiList.MoveLabel(X,Y);

    If (MULCtrlO.VisiList.MovingLab) then
      Send_UpdateList(BOff,25);
  end;

end;

procedure TPayLine.PIPanelMouseUp(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);

  Var
    BarPos :  Integer;
    PanRSized
           :  Boolean;



begin
  BarPos:=0;

  If (Sender is TSBSPanel) then
  With (Sender as TSBSPanel) do
  Begin

    PanRSized:=ReSized;

    If (ScrollCont<>nil) then
      BarPos:=ScrollCont.HorzScrollBar.Position;

    If (PanRsized) then
      MULCtrlO.ResizeAllCols(MULCtrlO.VisiList.FindxHandle(Sender),BarPos);


    MULCtrlO.FinishColMove(BarPos+(10*Ord(PanRSized)),PanRsized);

    If (MULCtrlO.VisiList.MovingLab or PanRSized) then
      Send_UpdateList(BOff,25);
  end;

end;


{ =========== Procedure to Update parent of notes ========= }

{ == Procedure to Send Message to Get Record == }

Procedure TPayLine.Send_UpdateList(Edit   :  Boolean;
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

  With Message1 do
    MessResult:=SendMEssage((Owner as TForm).Handle,Msg,WParam,LParam);

end; {Proc..}


procedure TPayLine.SetFormProperties;


Var
  TmpPanel    :  Array[1..3] of TPanel;

  n           :  Byte;

  ResetDefaults,
  BeenChange  :  Boolean;
  ColourCtrl  :  TCtrlColor;

Begin
  //PR: 10/11/2010
  if Assigned(FSettings) then
  begin
    FSettings.Edit(MULCtrlO, MULCtrlO);
    EXIT;
  end;

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
        SetProperties(TmpPanel[1],TmpPanel[2],TmpPanel[3],1,Self.Caption+' Properties',BeenChange,ResetDefaults);

        If (BeenChange or ResetDefaults) then
          Send_UpdateList(BOff,25);

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
    Send_UpdateList(BOff,17);
  end;

end;



procedure TPayLine.ShowLink(Const InvR      :  InvRec;
                            Const VOMode    :  Boolean);

Var
  FoundCode  :  Str20;

begin
  ExLocal.AssignFromGlobal(IdetailF);


  ExLocal.LGetRecAddr(IdetailF);

  ExLocal.LInv:=InvR;

  With ExLocal,LId,LInv do
  Begin
    If (Cust.CustCode<>CustCode) then
      GetCust(Self,CustCode,FoundCode,IsACust(CustSupp),-1);

    AssignFromGlobal(CustF);

    ShowJobFields(JBCostOn and (InvDocHed In SalesSplit));


    Caption:=Pr_OurRef(LInv)+' Payment Line';

    LViewOnly:=VOMode;

    

  end;


end;


procedure TPayLine.SetFieldProperties(Panel  :  TSBSPanel;
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


procedure TPayLine.AddEditPay(Const Edit,VOMode  :  Boolean;
                              Const SBNom        :  LongInt;
                              Const SBValue      :  Double;
                              Const InvR         :  InvRec);
Begin

  With ExLocal do
  Begin


    LastEdit:=Edit;

    ShowLink(InvR,VOMode);

    Self.Visible:=BOn;

    SelfBalNom:=SBNom;
    SelfBalVal:=SBValue;
    GenSelfBal:=(SelfBalNom<>0);



    With MULCtrlO do
      If ((PageKeys^[MUListBoxes[0].Row]<>0) or (Not Edit)) and (Not InListFind) then
        ProcessPay(Edit,BOff,VOMode);

    
  end; {With..}

end;





procedure TPayLine.Delete1Click(Sender: TObject);
begin
  DeletePayLine(ExLocal.LInv);
end;




procedure TPayLine.PINAFExit(Sender: TObject);
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

    If ((AltMod) or (FoundCode='')) and (ActiveControl<>Candb1Btn) and (ActiveControl<>Okdb1Btn)
        and (GenSelect) then
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

        PINDF.Text:=Nom.Desc;

        VariOn:=(FoundLong=Syss.NomCtrlCodes[CurrVar]);

        UnVariOn:=(FoundLong=Syss.NomCtrlCodes[UnRCurrVar]);

        DiscOn:=(FoundLong=Syss.NomCtrlCodes[SDiscNom(IdDocHed)]);

        {$IFDEF MC_On}

          If (VariOn) or (DiscOn) or (UnVariOn) then
          Begin
            Currency:=1;
            PICurrF.ItemIndex:=Pred(Currency);

            CXRate:=SyssCurr.Currencies[Currency].CRates;

            SetTriRec(Currency,UseORate,CurrTriR);


            If (Not LastEdit) then
              PIAmtF.Value:=0;
          end;

        {$ENDIF}




        {* Weird bug when calling up a list caused the Enter/Exit methods
             of the next field not to be called. This fix sets the focus to the next field, and then
             sends a false move to previous control message ... *}

        InPassing:=BOn;

        {FieldNextFix(Self.Handle,ActiveControl,Sender);}

        InPassing:=BOff;
      end
      else
      Begin
        SetFocus;
      end; {If not found..}
    end;


  end; {with..}
end;



procedure TPayLine.PIAmtFEnter(Sender: TObject);

Var
  UOR  :  Byte;

begin
  If (Sender Is TCurrencyEdit) then
  With ExLocal, (Sender as TCurrencyEdit) do
  Begin
    If (Value=0) and ((Not (LInv.InvDocHed In DirectSet)) or (LId.Currency<=1)) then
    With LInv do
      If (VariOn) then
        Value:=TotalReserved-Variance-PostDiscAm
      else
        If (DiscOn) then
          Value:=DiscSetl-PostDiscAm
        else
          If (UnVariOn) then
            Value:=Round_Up(PRequired(BOff,LInv),2)
          else
          Begin
            UOR:=fxUseORate(BOff,BOn,CXRate,UseORate,Currency,0);

            Value:=Conv_TCurr(PRequired((Round_Up(PRequired(BOff,LInv),2)=0),LInv),XRate(CXRate,BOff,Currency),Currency,UOR,BOn);
          end;
  end; {If..}

end;

procedure TPayLine.PIAmtFExit(Sender: TObject);

Var
  UOR  :  Byte;

begin
  {$IFDEF MC_On}
    With ExLocal,LId do
    Begin
      UOR:=fxUseORate(BOff,BOn,CXRate,UseORate,Currency,0);

      PIBEF.Value:=Conv_TCurr(PIAmtF.Value,XRate(CXRate,BOff,Currency),Currency,UOR,BOff);
    end;
  {$ENDIF}

end;

procedure TPayLine.PICCFEnter(Sender: TObject);
begin
    {* Also ised by any validated control with no on enter routine of it own *}

  GenSelect:=Not InPassing;
end;



procedure TPayLine.PICCFExit(Sender: TObject);
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


      If ((AltMod) or (FoundCode='')) and (ActiveControl<>Candb1Btn) and (ActiveControl<>Okdb1Btn)
          and (Syss.UseCCDep) and (GenSelect) then
      Begin

        // CJS 2013-09-12 - ABSEXCH-13192 - add Job Costing to user profile rules
        // For Job Costing, allow the user to pass through the Cost Centre and
        // Department fields without selecting anything, but if they have
        // entered values, do the normal validation.
        if (FoundCode <> '') or (not PIJCF.Visible) then
        begin
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

            InPassing:=BOn;

            {FieldNextFix(Self.Handle,ActiveControl,Sender);}

            InPassing:=BOff;

          end
          else
          Begin

            SetFocus;
          end; {If not found..}
        end;
      end;

    end; {with..}
  {$ENDIF}
end;




procedure TPayLine.PIJCFsExit(Sender: TObject);
Var
  FoundCode  :  Str20;

  FoundOk,
  AltMod     :  Boolean;
  // CJS 2013-09-13 - ABSEXCH-13192 - add Job Costing to user profile rules
  JobCCDept : CCDepType;
  OriginalCCDept: CCDepType;
begin
  {$IFDEF PF_On}

    If (Sender is Text8pt) then
    With (Sender as Text8pt) do
    Begin
      AltMod:=Modified;

      FoundCode:=Strip('B',[#32],Text);

      If ((AltMod) and (FoundCode<>'')) and (ActiveControl<>Candb1Btn) and (GenSelect) then
      Begin

        StillEdit:=BOn;

        FoundOk:=(GetJob(Self.Owner,FoundCode,FoundCode,3));

        If (FoundOk) then {* Credit Check *}
        With ExLocal do
        Begin
          AssignFromGlobal(JobF);

          Text:=FoundCode;

          InPassing:=BOn;

          {FieldNextFix(Self.Handle,ActiveControl,Sender);}

          // CJS 2013-09-13 - ABSEXCH-13192 - add Job Costing to user profile rules
          JobUtils.GetJobCCDept(FoundCode, JobCCDept);
          With ExLocal.LCust do
          begin
            OriginalCCDept[True] := PICCF.Text;
            OriginalCCDept[False] := PIDepF.Text;
            ExLocal.LId.CCDep:=GetCustProfileCCDepEx(CustCC,CustDep,OriginalCCDept,JobCCDept,1);
            PICCF.Text := ExLocal.LId.CCDep[True];
            PIDepF.Text := ExLocal.LId.CCDep[False];
          end;

          InPassing:=BOff;
        end
        else
        Begin

          SetFocus;
        end; {If not found..}

      end
      else
        If (FoundCode='') then {* Reset Janal code *}
          PIJAF.Text:='';

    end;
  {$ENDIF}
end;



procedure TPayLine.PIJAFExit(Sender: TObject);
Var
  FoundCode  :  Str20;

  FoundOk,
  AltMod     :  Boolean;


begin
  {$IFDEF PF_On}

    If (Sender is Text8pt) then
    With (Sender as Text8pt) do
    Begin
      AltMod:=Modified;

      FoundCode:=Strip('B',[#32],Text);

      If (((AltMod) or (FoundCode='')) and (Not EmptyKey(PIJCF.Text,JobCodeLen))) and (ActiveControl<>Candb1Btn) and (GenSelect) then
      Begin

        StillEdit:=BOn;

        FoundOk:=(GetJobMisc(Self.Owner,FoundCode,FoundCode,2,Anal_FiltMode(ExLocal.LId.IdDocHed)));

        If (FoundOk) then {* Credit Check *}
        With ExLocal do
        Begin

          AssignFromGlobal(JMiscF);

          Text:=FoundCode;

          InPassing:=BOn;

          {FieldNextFix(Self.Handle,ActiveControl,Sender);}

          InPassing:=BOff;
        end
        else
        Begin
          SetFocus;
        end; {If not found..}
      end;

    end;
  {$ENDIF}

end;


procedure TPayLine.CtrlView;

Var
  SPanel  :  TSBSPanel;
Begin
  If (Assigned(MULCtrlO)) then
  With MULCtrlO,VisiList do
  Begin
    VisiRec:=List[5];
    SPanel:=TSBSPanel(VisiRec^.LabelObj);

    Case DisplayMode of
      0  :  Begin
              SPanel.Caption:='Status';
              DisplayMode:=1;
            end;

      1  :  Begin
              SPanel.Caption:='Pay-In Ref';

              DisplayMode:=0;
            end;
    end; {Case..}

    PageUpDn(0,BOn);
  end;
end;




procedure TPayLine.THUD1FEntHookEvent(Sender: TObject);
Var
  CUUDEvent  :  Byte;
  Result     :  LongInt;

begin
   CUUDEvent := 0;
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
                //GS 19/10/2011 ABSEXCH-11706: create branches for the new UDFs
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
              //GS 19/10/2011 ABSEXCH-11706: put customisation object vals into UDFs
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


procedure TPayLine.THUD1FExit(Sender: TObject);
begin
  If (Sender is Text8Pt)  and (ActiveControl<>Candb1Btn) then
    Text8pt(Sender).ExecuteHookMsg;

end;

//GS 24/11/2011 ABSEXCH-12172: procedure to restore the top + left position co-ords of all UDF field and labels
procedure TPayLine.RestoreUDFDefaults(const Captions : Array of TLabel; const Edits : Array of TCustomEdit);
var
  i: Integer;
begin
  for i := Low(UDFLabelSettings) to High(UDFLabelSettings) do
  begin
    Captions[i].Top := UDFLabelSettings[i].x;
    Captions[i].Left := UDFLabelSettings[i].y;

    Edits[i].Top := UDFFieldSettings[i].x;
    Edits[i].Left := UDFFieldSettings[i].y;
  end;
end;

//GS 24/11/2011 ABSEXCH-12172: procedure to store the top + left position co-ords of all UDF field and labels
procedure TPayLine.StoreUDFDefaults(const Captions : Array of TLabel; const Edits : Array of TCustomEdit);
var
  i: Integer;
begin
  UDFSettingsStored := True;
  for i := Low(Captions) to High(Captions) do
  begin
    UDFLabelSettings[i].x := Captions[i].Top;
    UDFLabelSettings[i].y := Captions[i].Left;

    UDFFieldSettings[i].x := Edits[i].Top;
    UDFFieldSettings[i].y := Edits[i].Left;
  end;
end;

function TPayLine.TransactionViewOnly: Boolean;
begin
  Result := ExLocal.LViewOnly and not FAllowPostedEdit;
end;

procedure TPayLine.EnableEditPostedFields;
begin
  FAllowPostedEdit := True;

  //Pay-in Ref
  PIPIF.AllowPostedEdit := True;

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

Initialization

end.
