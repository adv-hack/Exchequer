Unit NomTfrU;

{$ALIGN 1}

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ExtCtrls, SBSPanel, TEditVal, BorBtns, Mask, ComCtrls,

  GlobVar,VarConst, ExWrap1U,BTSupU1,SupListU,SBSComp, SBSComp2,

  //SalTxL1U,

  NomLineU,

  {$IFDEF NP}
    //NoteU,
  {$ENDIF}

  {$IFDEF Ltr}
    //Letters,
  {$ENDIF}

  VATMatrx,
  Menus;



type
  TNTxfrMList  =  Class(TGenList)


    Function SetCheckKey  :  Str255; Override;

    Function SetFilter  :  Str255; Override;

    Function Ok2Del :  Boolean; Override;

    Function OutLine(Col  :  Byte)  :  Str255; Override;


  end;


type
  TNTxfrForm = class(TForm)
    PageControl1: TPageControl;
    RecepPage: TTabSheet;
    N1SBox: TScrollBox;
    N1HedPanel: TSBSPanel;
    N1DLab: TSBSPanel;
    N1NomLab: TSBSPanel;
    N1CrLab: TSBSPanel;
    N1NDLab: TSBSPanel;
    N1DrLab: TSBSPanel;
    N1DPanel: TSBSPanel;
    N1DrPanel: TSBSPanel;
    N1NomPanel: TSBSPanel;
    N1NDPanel: TSBSPanel;
    N1CrPanel: TSBSPanel;
    N1BtnPanel: TSBSPanel;
    ClsN1Btn: TButton;
    N1BSBox: TScrollBox;
    btnViewLine: TButton;
    PopupMenu1: TPopupMenu;
    View1: TMenuItem;
    N2: TMenuItem;
    PropFlg: TMenuItem;
    N1: TMenuItem;
    StoreCoordFlg: TMenuItem;
    N3: TMenuItem;
    N1StatLab: Label8;
    N1BtmPanel: TSBSPanel;
    CCPanel: TSBSPanel;
    CCTit: Label8;
    DepTit: Label8;
    CCLab: Label8;
    DepLab: Label8;
    SBSPanel5: TSBSPanel;
    DrReqdTit: Label8;
    DrReqdLab: Label8;
    SBSPanel4: TSBSPanel;
    CrReqdTit: Label8;
    CrReqdLab: Label8;
    N1ListBtnPanel: TSBSPanel;
    TabSheet1: TTabSheet;
    N1FPanel: TSBSPanel;
    Label817: Label8;
    Label84: Label8;
    Label87: Label8;
    N1BLab: Label8;
    Label816: Label8;
    Label81: Label8;
    N1OrefF: Text8Pt;
    N1OpoF: Text8Pt;
    N1TDateF: TEditDate;
    N1YRefF: Text8Pt;
    N1SelBalF: Text8Pt;
    N1BaseF: TCurrencyEdit;
    TransExtForm1: TSBSExtendedForm;
    UDF1L: Label8;
    UDF3L: Label8;
    UDF2L: Label8;
    UDF4L: Label8;
    Label88: Label8;
    Label82: Label8;
    THUD1F: Text8Pt;
    THUD3F: Text8Pt;
    THUD4F: Text8Pt;
    THUD2F: Text8Pt;
    N1TPerF: TEditPeriod;
    N1YRef2F: Text8Pt;
    N1SelBalQF: TBorCheck;
    N1AutoRevF: TBorCheck;
    SBSPanel1: TSBSPanel;
    VATTit: Label8;
    VATTotLab: Label8;
    SBSPanel53: TSBSPanel;
    VATLab: Label8;
    SBSPanel54: TSBSPanel;
    I5VATRLab: TLabel;
    Label8: TLabel;
    I5VATLab: TLabel;
    NTIOHedCB: TSBSComboBox;
    ScrollBox8: TScrollBox;
    I5VR1F: Text8Pt;
    I5VR2F: Text8Pt;
    I5VR3F: Text8Pt;
    I5VR4F: Text8Pt;
    I5VR5F: Text8Pt;
    I5VR6F: Text8Pt;
    I5VR7F: Text8Pt;
    I5VG1F: TCurrencyEdit;
    I5VG2F: TCurrencyEdit;
    I5VG3F: TCurrencyEdit;
    I5VG4F: TCurrencyEdit;
    I5VG5F: TCurrencyEdit;
    I5VG6F: TCurrencyEdit;
    I5VG7F: TCurrencyEdit;
    I5VV1F: TCurrencyEdit;
    I5VV2F: TCurrencyEdit;
    I5VV3F: TCurrencyEdit;
    I5VV4F: TCurrencyEdit;
    I5VV5F: TCurrencyEdit;
    I5VV6F: TCurrencyEdit;
    I5VV7F: TCurrencyEdit;
    I5VR8F: Text8Pt;
    I5VG8F: TCurrencyEdit;
    I5VV8F: TCurrencyEdit;
    I5Vr9F: Text8Pt;
    I5VG9F: TCurrencyEdit;
    I5VV9F: TCurrencyEdit;
    I5Vr10F: Text8Pt;
    I5VG10F: TCurrencyEdit;
    I5VV10F: TCurrencyEdit;
    I5Vr11F: Text8Pt;
    I5VG11F: TCurrencyEdit;
    I5VV11F: TCurrencyEdit;
    I5VR12F: Text8Pt;
    I5VG12F: TCurrencyEdit;
    I5VV12F: TCurrencyEdit;
    I5Vr13F: Text8Pt;
    I5VG13F: TCurrencyEdit;
    I5VV13F: TCurrencyEdit;
    I5Vr14F: Text8Pt;
    I5VG14F: TCurrencyEdit;
    I5VV14F: TCurrencyEdit;
    I5Vr15F: Text8Pt;
    I5VG15F: TCurrencyEdit;
    I5VV15F: TCurrencyEdit;
    I5VV16F: TCurrencyEdit;
    I5VG16F: TCurrencyEdit;
    I5Vr16F: Text8Pt;
    I5Vr17F: Text8Pt;
    I5VG17F: TCurrencyEdit;
    I5VV17F: TCurrencyEdit;
    I5VV18F: TCurrencyEdit;
    I5VG18F: TCurrencyEdit;
    I5Vr18F: Text8Pt;
    I5Vr19F: Text8Pt;
    I5VG19F: TCurrencyEdit;
    I5VV19F: TCurrencyEdit;
    I5Vr20F: Text8Pt;
    I5VG20F: TCurrencyEdit;
    I5VV20F: TCurrencyEdit;
    I5Vr21F: Text8Pt;
    I5VG21F: TCurrencyEdit;
    I5VV21F: TCurrencyEdit;
    N1VCLab: TSBSPanel;
    N1VAmtLab: TSBSPanel;
    N1CCLab: TSBSPanel;
    N1DepLab: TSBSPanel;
    N1VCPanel: TSBSPanel;
    N1VAmtPanel: TSBSPanel;
    N1CCPanel: TSBSPanel;
    N1DepPanel: TSBSPanel;
    THUD6F: Text8Pt;
    THUD8F: Text8Pt;
    THUD10F: Text8Pt;
    THUD5F: Text8Pt;
    THUD7F: Text8Pt;
    THUD9F: Text8Pt;
    UDF5L: Label8;
    UDF7L: Label8;
    UDF9L: Label8;
    UDF6L: Label8;
    UDF8L: Label8;
    UDF10L: Label8;
    procedure PageControl1Changing(Sender: TObject;
      var AllowChange: Boolean);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure FormKeyPress(Sender: TObject; var Key: Char);
    procedure ClsN1BtnClick(Sender: TObject);
    procedure N1DPanelMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure N1DLabMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure N1DLabMouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure btnViewLineClick(Sender: TObject);
    procedure PopupMenu1Popup(Sender: TObject);
    procedure PropFlgClick(Sender: TObject);
    procedure StoreCoordFlgClick(Sender: TObject);
    procedure FormResize(Sender: TObject);
    function N1TPerFShowPeriod(Sender: TObject; const EPr: Byte): String;

  private
    {private declarations}

    JustCreated,
    fNeedCUpdate,
    StopPageChange,
    StoreCoord,
    LastCoord,
    SetDefault,
    HaveVAT,
    GotCoord     :  Boolean;

    SKeypath,
    MinHeight,
    MinWidth     :  Integer;

    IdLine       :  TNTLine;
    IdLineActive :  Boolean;

    RecordPage   :  Byte;
    DocHed       :  DocTypes;

    OldConTot    :  Double;


    VATMatrix    :  TVATMatrix;

    PagePoint    :  Array[0..4] of TPoint;

    StartSize,
    InitSize     :  TPoint;


    procedure Find_FormCoord;

    procedure Store_FormCoord(UpMode  :  Boolean);

    Procedure Link2Nom;

    Procedure WMCustGetRec(Var Message  :  TMessage); Message WM_CustGetRec;

    Procedure WMGetMinMaxInfo(Var Message  :  TWMGetMinMaxInfo); Message WM_GetMinMaxInfo;

    Procedure WMSysCommand(Var Message  :  TMessage); Message WM_SysCommand;
    procedure WMWindowPosChanged(var Msg : TMessage); Message WM_WindowPosChanged;

    procedure ShowRightMeny(X,Y,Mode  :  Integer);


    Procedure OutNTxfrTotals;

    procedure Display_Id (Const TheId : IDetail; Const DataChanged : Boolean);

    procedure SetFormProperties(SetList  :  Boolean);

    procedure SetFieldProperties;

    Procedure Set_NOMIOFlg(SetMode  :  Boolean);
  public
    { Public declarations }

    ExLocal    :  TdExLocal;
    ListOfSet  :  Integer;

    MULCtrlO   :  TNTxfrMList;

    Function SetHelpC(PageNo :  Integer;
                      Pages  :  TIntSet;
                      Help0,
                      Help1  :  LongInt) :  LongInt;

    procedure BuildDesign;

    procedure FormDesign;

    Function Current_BarPos(PageNo  :  Byte)  :  Integer;

    procedure HidePanels(PageNo    :  Byte);

    procedure RefreshList(ShowLines,
                          IgMsg      :  Boolean);

    procedure FormBuildList(ShowLines  :  Boolean);

    Function Current_Page  :  Integer;

    procedure FormSetOfSet;


    procedure SetNTxfrStore(VOMode  :  Boolean);

    procedure SetNTxfrFields;

    procedure OutNTxfr;

    Procedure SetFieldFocus;

    procedure DisplayTrans (Const TheTrans : InvRec);
  end;



{~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~}

Implementation

{~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~}

Uses
  ETStrU,
  ETMiscU,
  ETDateU,
  BtrvU2,
  BTSupU2,
  //BTSupU3,
  BTKeys1U,
  CmpCtrlU,
  ColCtrlU,

  ComnUnit,
  ComnU2,
  CurrncyU,
  InvListU,
  EntLicence,     // Global Exchequer Licence object
  EntData,        // Global Exchequer Data object

  {$IFDEF PF_On}

    //InvLst2U,

  {$ENDIF}

  {$IFDEF GF}
    //FindRecU,
    //FindCtlU,
  {$ENDIF}

  {$IFDEF DBD}
    //DebugU,
  {$ENDIF}

  SysU1,
  SysU2,
  SysU3,
  //IntMU,
  MiscU,
  CustomFieldsIntF,
  TransactionOriginator;
  //AutoTxU,
  //PayF2U,

  //ConvDocU,

  {$IFDEF FRM}
    //DefProcU,
  {$ENDIF}
  //Event1U,
  //GenWarnU,
  //Warn1U;

{$R *.DFM}


{$I NTxfrI1U.PAS}



procedure TNtxfrForm.Find_FormCoord;


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

    PrimeKey:=DocCodes[DocHed][1];

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

    GetbtControlCsm(N1SBox);

    GetbtControlCsm(N1BSBox);

    GetbtControlCsm(N1BtnPanel);

    GetbtControlCsm(N1ListBtnPanel);


    If GetbtControlCsm(N1YrefF) then
      SetFieldProperties;


    MULCtrlO.Find_ListCoord(GlobComp);

  end; {With GlobComp..}


  Dispose(GlobComp,Destroy);

      {* Check form is within current visible range *}

  With TForm(Owner) do
    VisibleRect:=Rect(0,0,ClientWidth,ClientHeight);

  If (Not PtInRect(VisibleRect,Point(Left,Top))) then
  Begin
    Left:=0;
    Top:=0;
  end;


  StartSize.X:=Width; StartSize.Y:=Height;

end;


procedure TNTxfrForm.Store_FormCoord(UpMode  :  Boolean);


Var
  GlobComp:  TGlobCompRec;


Begin

  New(GlobComp,Create(BOff));

  With GlobComp^ do
  Begin
    GetValues:=UpMode;

    PrimeKey:=DocCodes[DocHed][1];

    ColOrd:=Ord(StoreCoord);

    HLite:=Ord(LastCoord);

    SaveCoord:=StoreCoord;

    If (Not LastCoord) then {* Attempt to store last coord *}
      HLite:=ColOrd;

    StorebtControlCsm(Self);

    StorebtControlCsm(PageControl1);

    StorebtControlCsm(N1SBox);

    StorebtControlCsm(N1BSBox);

    StorebtControlCsm(N1BtnPanel);

    StorebtControlCsm(N1ListBtnPanel);

    StorebtControlCsm(N1YrefF);


    MULCtrlO.Store_ListCoord(GlobComp);
  end; {With GlobComp..}

  Dispose(GlobComp,Destroy);

end;



Function TNTxfrForm.Current_Page  :  Integer;
Begin

  Result:=pcLivePage(PAgeControl1);

end;


Procedure TNTxfrForm.Link2Nom;


Begin
  With Id do
  Begin
    If (EnterpriseLicence.elCurrencyVersion In [cvEuro, cvGlobal]) Then
      // $IFDEF MC_On
      N1BaseF.Value:=Conv_TCurr(NetValue+VAT,CXRate[UseCoDayRate],Currency,UseORate,BOff);

    If (Syss.UseCCDep) then
    Begin
      CCLab.Caption:=CCDep[BOn];
      DepLab.Caption:=CCDep[BOff];
    end;
  end;
end;


Procedure TNTxfrForm.WMCustGetRec(Var Message  :  TMessage);

Var
  mbRet  :  Word;

Begin


  With Message do
  Begin

    {If (Debug) then
      DebugForm.Add('Mesage Flg'+IntToStr(WParam));}

    Case WParam of
      { 0 = dbl click on line, 169 = pressed drill down button}
      0,169 : Begin
                If (WParam=169) then
                  MULCtrlO.GetSelRec(BOff);

                Display_Id(Id, False);
              end;

      { 1 = Selected line changed }
      1  :  Begin
              Link2Nom;

              Display_Id(Id, True);
            end;

     25  :  FNeedCUpdate:=BOn;

     100 :  Begin
              Case LParam Of
                1  : Begin
                       IdLine:=nil;
                       IdLineActive:=BOff;
                     End;
              End; { Case }

              MULCtrlO.SetListFocus;
            end;

    end; {Case..}

  end;
  Inherited;
end;


Procedure TNTxfrForm.WMGetMinMaxInfo(Var Message  :  TWMGetMinMaxInfo);

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


Procedure TNTxfrForm.WMSysCommand(Var Message  :  TMessage);


Begin
  With Message do
    Case WParam of

      SC_Maximize  :  Begin
                        Self.ClientHeight:=InitSize.Y;
                        Self.ClientWidth:=InitSize.X;

                        WParam:=0;
                      end;

    end; {Case..}

  Inherited;
end;


procedure TNTxfrForm.FormSetOfSet;

Begin
  PagePoint[0].X:=ClientWidth-(PageControl1.Width);
  PagePoint[0].Y:=ClientHeight-(PageControl1.Height);

  PagePoint[1].X:=PageControl1.Width-(N1SBox.Width);
  PagePoint[1].Y:=PageControl1.Height-(N1SBox.Height);

  PagePoint[2].X:=PageControl1.Width-(N1BtnPanel.Left);
  PagePoint[2].Y:=PageControl1.Height-(N1BtnPanel.Height);

  PagePoint[3].X:=N1BtnPanel.Height-(N1BSBox.Height);
  PagePoint[3].Y:=N1SBox.ClientHeight-(N1DPanel.Height);

  PagePoint[4].X:=PageControl1.Width-(N1ListBtnPanel.Left);
  PagePoint[4].Y:=PageControl1.Height-(N1ListBtnPanel.Height);


  GotCoord:=BOn;

end;


Function TNTxfrForm.SetHelpC(PageNo :  Integer;
                             Pages  :  TIntSet;
                             Help0,
                             Help1  :  LongInt) :  LongInt;

Begin
  If (PageNo In Pages) then
  Begin
    If (PageNo=1) then
      Result:=Help1
    else
      Result:=Help0;
  end
  else
    Result:=-1;

end;


procedure TNTxfrForm.BuildDesign;

Var
  HideCC  :  Boolean;

begin

  {* Set Version Specific Info *}

  If (EnterpriseLicence.elCurrencyVersion = cvPro) Then Begin
    // IFNDEF MC_On
    N1BLab.Visible:=BOff;
    N1BaseF.Visible:=BOff;
  End; { If (EnterpriseLicence.elCurrencyVersion = cvPro) }


  N1YRefF.MaxLength:=DocYRef2Len;
  N1YRef2F.MaxLength:=DocYRef1Len;


  HideCC:=Not Syss.UseCCDep;
  CCPanel.Visible:=Not HideCC;

  // HM 13/05/03: Added VAT Fields to NOM Header window
  N1VAmtLab.Caption:=CCVATName^+N1VAmtLab.Caption;
  VATTit.Caption:=CCVATName^+VATtit.Caption;
  //N1AcalcVATF.Caption:=N1AcalcVATF.Caption+CCVATName^;
  VATLab.Caption:=VATLab.Caption+CCVATName^;

  //GS 17/11/2011 ABSEXCH-12037: modifed UDF settings code to use the new "CustomFieldsIntF" unit
  EnableUDFs([UDF1L, UDF2L, UDF3L, UDF4L, UDF5L, UDF6L, UDF7L, UDF8L, UDF9L, UDF10L],
             [THUD1F, THUD2F, THUD3F, THUD4F, THUD5F, THUD6F, THUD7F, THUD8F, THUD9F, THUD10F], cfNOMHeader, True);

  ResizeUDFParentContainer(NumberOfVisibleUDFs([THUD1F, THUD2F, THUD3F, THUD4F, THUD5F, THUD6F, THUD7F, THUD8F, THUD9F, THUD10F]),
                           2,
                           TransExtForm1);

end;


procedure TNTxfrForm.FormDesign;


begin

  BuildDesign;


  {* Build VAT Matrix *}

  try

    With VATMatrix do
    Begin
      AddVisiRec(I5VR1F,I5VV1F,I5VG1F);
      AddVisiRec(I5VR2F,I5VV2F,I5VG2F);
      AddVisiRec(I5VR3F,I5VV3F,I5VG3F);
      AddVisiRec(I5VR4F,I5VV4F,I5VG4F);
      AddVisiRec(I5VR5F,I5VV5F,I5VG5F);
      AddVisiRec(I5VR6F,I5VV6F,I5VG6F);
      AddVisiRec(I5VR7F,I5VV7F,I5VG7F);
      AddVisiRec(I5VR8F,I5VV8F,I5VG8F);
      AddVisiRec(I5VR9F,I5VV9F,I5VG9F);
      AddVisiRec(I5VR10F,I5VV10F,I5VG10F);
      AddVisiRec(I5VR11F,I5VV11F,I5VG11F);
      AddVisiRec(I5VR12F,I5VV12F,I5VG12F);
      AddVisiRec(I5VR13F,I5VV13F,I5VG13F);
      AddVisiRec(I5VR14F,I5VV14F,I5VG14F);
      AddVisiRec(I5VR15F,I5VV15F,I5VG15F);
      AddVisiRec(I5VR16F,I5VV16F,I5VG16F);
      AddVisiRec(I5VR17F,I5VV17F,I5VG17F);
      AddVisiRec(I5VR18F,I5VV18F,I5VG18F);
      AddVisiRec(I5VR19F,I5VV19F,I5VG19F);
      AddVisiRec(I5VR20F,I5VV20F,I5VG20F);
      AddVisiRec(I5VR21F,I5VV21F,I5VG21F);
    end;

  except

    VATMatrix:=nil

  end;

end;

procedure TNTxfrForm.HidePanels(PageNo    :  Byte);

Var
  TmpBo  :  Boolean;
  n      :  Integer;

Begin
  With MULCtrlO,VisiList do
  Begin
    fBarOfSet:=Current_BarPos(PageNo);

    Case PageNo of

      0
         :  Begin
              TmpBo:=Not Syss.UseCCDep;
              SetHidePanel(5,TmpBo,BOff);
              SetHidePanel(6,TmpBo,BOn);

            end;


    end; {Case..}

  end; {with..}
end;


Function TNTxfrForm.Current_BarPos(PageNo  :  Byte)  :  Integer;

Begin
  Case PageNo of
      0
         :  Result:=N1SBox.HorzScrollBar.Position;
      else  Result:=0;
    end; {Case..}


end;


procedure TNTxfrForm.RefreshList(ShowLines,
                                 IgMsg      :  Boolean);

Var
  KeyStart    :  Str255;

Begin

  KeyStart:=FullIdkey(EXLocal.LInv.FolioNum,RecieptCode);

  With MULCtrlO do
  Begin
    IgnoreMsg:=IgMsg;

    StartList(IdetailF,IdFolioK,KeyStart,'','',4,(Not ShowLines));

    IgnoreMsg:=BOff;
  end;

end;


procedure TNTxfrForm.FormBuildList(ShowLines  :  Boolean);

Var
  StartPanel  :  TSBSPanel;
  n           :  Byte;



Begin
  MULCtrlO:=TNTxfrMList.Create(Self);


  Try

    With MULCtrlO do
    Begin

      Try

        With VisiList do
        Begin
          AddVisiRec(N1DPanel,N1DLab);
          AddVisiRec(N1NomPanel,N1NomLab);
          AddVisiRec(N1NDPanel,N1NDLab);
          AddVisiRec(N1DrPanel,N1DrLab);
          AddVisiRec(N1CrPanel,N1CrLab);
          AddVisiRec(N1VCPanel,N1VCLab);
          AddVisiRec(N1VAmtPanel,N1VAmtLab);
          AddVisiRec(N1CCPanel,N1CCLab);
          AddVisiRec(N1DepPanel,N1DepLab);

          VisiRec:=List[0];

          StartPanel:=(VisiRec^.PanelObj as TSBSPanel);

          HidePanels(0);

          LabHedPanel:=N1HedPanel;

          SetHedPanel(ListOfSet);

        end;
      except
        VisiList.Free;

      end;


      ListOfSet:=10;


      Find_FormCoord;

      TabOrder := -1;
      TabStop:=BOff;
      Visible:=BOff;
      BevelOuter := bvNone;
      ParentColor := False;
      Color:=StartPanel.Color;
      MUTotCols:=8;
      Font:=StartPanel.Font;

      LinkOtherDisp:=BOn;

      WM_ListGetRec:=WM_CustGetRec;


      Parent:=StartPanel.Parent;

      MessHandle:=Self.Handle;

      For n:=0 to MUTotCols do
      With ColAppear^[n] do
      Begin
        AltDefault:=BOn;

        If (n In [1,3,4,6]) then
        Begin
          DispFormat:=SGFloat;

          If (n<>1) then
            NoDecPlaces:=2
          else
            NoDecPlaces:=0;
        end;
      end;


      ListLocal:=@ExLocal;

      ListCreate;

      NoUpCaseCheck:=BOn;

      UseSet4End:=BOn;

      Set_Buttons(N1ListBtnPanel);

      ReFreshList(ShowLines,BOff);

    end {With}


  Except

    MULCtrlO.Free;
    MULCtrlO:=Nil;
  end;


  FormSetOfSet;

  FormReSize(Self);

end;



{ ======== Display Receipt Record ========== }

procedure TNTxfrForm.SetNTxfrFields;

Var
  GenStr       :  Str255;

  n,m          :  Byte;


Begin

  With ExLocal,LInv do
  Begin
    N1ORefF.Text:=Pr_OurRef(LInv);
    N1OpoF.Text:=OpName;

    { CJS - 2013-10-28 - ABSEXCH-14705 - MRD2.6 - Transaction Originator }
    if (Trim(thOriginator) <> '') then
      N1OpoF.Hint := GetOriginatorHint(LInv)
    else
      N1OpoF.Hint := '';

    N1TPerF.InitPeriod(AcPr,AcYr,BOn,BOn);

    N1TDateF.DateValue:=TransDate;

    N1YRefF.Text:=TransDesc;
    N1YRef2F.Text:=YourRef;

    N1AutoRevF.Checked:=UnTagged;

    N1SelBalF.Text:=Form_BInt(BatchNom,0);

    THUd1F.Text:=DocUser1;
    THUd2F.Text:=DocUser2;
    THUd3F.Text:=DocUser3;
    THUd4F.Text:=DocUser4;
    //GS 17/11/2011 ABSEXCH-12037: put customisation values into text boxes
    THUd5F.Text:=DocUser5;
    THUd6F.Text:=DocUser6;
    THUd7F.Text:=DocUser7;
    THUd8F.Text:=DocUser8;
    THUd9F.Text:=DocUser9;
    THUd10F.Text:=DocUser10;
    Set_NOMIOFlg(BOff);

  end; {With..}
end;



Procedure TNTxfrForm.Set_NOMIOFlg(SetMode  :  Boolean);
Begin
  With ExLocal,LInv do
  Case SetMode of
    BOff  :  Begin
               NTIOHedCB.ItemIndex:=(1*Ord(NOMVATIO=IOVATCh[BOff]))+(2*Ord(NOMVATIO=IOVATCh[BOn]));
             end;
    BOn   :  Begin
               If (HaveVAT) and (NTIOHedCB.ItemIndex>=0) then
               Begin
                 Case NTIOHedCB.ItemIndex of
                   1,2  : NOMVATIO:=IOVATCh[NTIOHedCB.ItemIndex=2];
                   else   NOMVATIO:=C0;
                 end; {Case..}
               end
               else
                 NOMVATIO:=C0;
             end;

  end;{Case..}
end;


Procedure TNTxfrForm.OutNTxfrTotals;

Var
  Dnum    :  Double;
  NTDrCr  :  DrCrType;
  n       :  VATType;
Begin
  With ExLocal,LInv do
  Begin
    HaveVAT:=BOff;

    // Calc VAT Totals
    CalcInvVATTotals(LInv,ExLocal,Not ManVAT);
    VATMatrix.HideVATMatrix(LInvNetTrig);

    // HM 20/12/02: Replaced PRequired with equiv code as can't include PayF2U
    //ShowDrCr((PRequired(BOn,LInv)*DocNotCnst),NTDrCr);
    ShowDrCr((ConvCurrITotal(LInv,BOff,BOff,BOn)-TotalInvoiced)*DocNotCnst,NTDrCr);

    DrReqdLab.Caption:=FormatFloat(GenRealMask,NTDrCr[BOff]);

    CrReqdLab.Caption:=FormatFloat(GenRealMask,NTDrCr[BOn]);


    If (VATMatrix<>nil) then
    With VATMatrix do
    Begin
      For n:=VStart to VEnd do
      Begin
        IdRec(Ord(n))^.GoodsD.Value:=LInvNetAnal[n];
        IdRec(Ord(n))^.VATD.Value:=InvVATAnal[n];

        HaveVAT:=(HaveVAT or LInvNetTrig[n]);
      end;
    end;

    If (InvVAT<>0.0) or HaveVAT then
      VATTotLab.Caption:=FormatFloat(GenRealMask,InvVAT)
    else
      VATTotLab.Caption:='';
    //VATTotLab.Caption:=FormatBFloat(GenRealMask,InvVAT,Not HaveVAT);

    If (HaveVAT) and (NTIOHedCB.ItemIndex>0) then
      VATTotLab.Caption:=VATTotLab.Caption+' '+NTIOHedCB.Items[NTIOHedCB.ItemIndex][1];
  end; {With..}

end;

{ ======== Display Invoice Record ========== }

procedure TNTxfrForm.OutNTxfr;

Var
  GenStr       :  Str255;
  FoundCode    :  Str20;

  n,m          :  Byte;


Begin

  With ExLocal,LInv do
  Begin
    SetNTxfrFields;

    OutNTxfrTotals;
  end; {With..}
end;


Procedure TNTxfrForm.SetFieldFocus;

Begin
  With ExLocal do
    Case Current_Page of

      0
         :  N1YRefF.SetFocus;

    end; {Case&With..}

end; {Proc..}



procedure TNTxfrForm.PageControl1Changing(Sender: TObject;
  var AllowChange: Boolean);
begin
  AllowChange:=Not StopPageChange;

  If (AllowChange) then
  Begin
    Release_PageHandle(Sender);
  end;
end;

procedure TNTxfrForm.FormCreate(Sender: TObject);

Var
  n  :  Integer;

begin
  ExLocal.Create;

  LastCoord:=BOff;

  Visible:=BOff;

  JustCreated:=BOn;

  FNeedCUpdate:=BOff;

  StopPageChange:=BOff;

  SKeypath:=0;

  HaveVAT:=BOff;

  // Initialise Form Sizes
  InitSize.Y := 358;
  InitSize.X := 632;
  Self.ClientHeight := InitSize.Y;
  Self.ClientWidth  := InitSize.X;
  Constraints.MinHeight  := InitSize.Y - 1;
  Constraints.MinWidth   := InitSize.X - 1;

  // Initialise scroll-bar positions
  For N := 0 To Pred(ComponentCount) Do
    If (Components[n] is TScrollBox) Then
      With TScrollBox(Components[N]) Do Begin
        VertScrollBar.Position := 0;
        HorzScrollBar.Position := 0;
      End; { With TScrollBox(Components[n]) }
  VertScrollBar.Position:=0;
  HorzScrollBar.Position:=0;

  VATMatrix:=TVATMatrix.Create;

  FormDesign;

  FormBuildList(BOff);
end;


procedure TNTxfrForm.FormDestroy(Sender: TObject);
begin
  FreeAndNIL(VATMatrix);
  ExLocal.Destroy;
end;

procedure TNTxfrForm.FormCloseQuery(Sender: TObject;
                                 var CanClose: Boolean);
Var
  n  : Integer;

begin
  For n:=0 to Pred(ComponentCount) do
    If (Components[n] is TScrollBox) then
      With TScrollBox(Components[n]) do
      Begin
        VertScrollBar.Position:=0;
        HorzScrollBar.Position:=0;
      end;

  If (FNeedCUpdate) then
    Store_FormCoord(Not SetDefault);

  SendMessage ((Owner As TForm).Handle, WM_CustGetRec, 100, 2);
end;


procedure TNTxfrForm.FormClose(Sender: TObject; var Action: TCloseAction);
begin
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



procedure TNTxfrForm.FormResize(Sender: TObject);
Var
  n           :  Byte;
  NewVal      :  Integer;


begin

  If (GotCoord) then
  Begin
    MULCtrlO.LinkOtherDisp:=BOff;

    Self.HorzScrollBar.Position:=0;
    Self.VertScrollBar.Position:=0;

    NewVal:=ClientWidth-PagePoint[0].X;
    If (NewVal<MinWidth) then
      NewVal:=MinWidth;

    PageControl1.Width:=NewVal;

    NewVal:=ClientHeight-PagePoint[0].Y;

    If (NewVal<MinHeight) then
      NewVal:=MinHeight;

    PageControl1.Height:=NewVal;


    N1SBox.Width:=PageControl1.Width-PagePoint[1].X;
    N1SBox.Height:=PageControl1.Height-PagePoint[1].Y;

    N1BtnPanel.Left:=PageControl1.Width-PagePoint[2].X;
    N1BtnPanel.Height:=PageControl1.Height-PagePoint[2].Y;

    N1BSBox.Height:=N1BtnPanel.Height-PagePoint[3].X;

    N1ListBtnPanel.Left:=PageControl1.Width-PagePoint[4].X;
    N1ListBtnPanel.Height:=PageControl1.Height-PagePoint[4].Y;

    If (MULCtrlO<>nil) then
    Begin
      LockWindowUpDate(Handle);

      With MULCtrlO,VisiList do
      Begin
        VisiRec:=List[0];

        With (VisiRec^.PanelObj as TSBSPanel) do
          Height:=N1SBox.ClientHeight-PagePoint[3].Y;

        RefreshAllCols;
      end;

      MULCtrlO.ReFresh_Buttons;

      LockWindowUpDate(0);
    end;{Loop..}

    MULCtrlO.LinkOtherDisp:=BOn;

    FNeedCUpdate:=((StartSize.X<>Width) or (StartSize.Y<>Height));


  end; {If time to update}
end;


procedure TNTxfrForm.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  GlobFormKeyDown(Sender,Key,Shift,ActiveControl,Handle);
end;

procedure TNTxfrForm.FormKeyPress(Sender: TObject; var Key: Char);
begin
  GlobFormKeyPress(Sender,Key,ActiveControl,Handle);
end;


procedure TNTxfrForm.ClsN1BtnClick(Sender: TObject);
begin
  Close;
end;


procedure TNTxfrForm.SetNTxfrStore(VOMode  :  Boolean);

Var
  Loop  :  Integer;

Begin
  ExLocal.InAddEdit:=Not VOMode;

  For Loop:=0 to ComponentCount-1 do
  Begin
    If (Components[Loop] is Text8Pt) then
    Begin
      If (Text8Pt(Components[Loop]).Tag=1) then
        Text8Pt(Components[Loop]).ReadOnly:= VOMode;
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

  N1SelBalQF.Enabled:=((Not ExLocal.LastEdit) and (Not VOMode));

  N1SelBalF.ReadOnly:=Not N1SelBalQF.Enabled;
end;



procedure TNTxfrForm.N1DPanelMouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);

Var
  BarPos :  Integer;
  PanRSized
         :  Boolean;



begin

  If (Sender is TSBSPanel) then
  With (Sender as TSBSPanel) do
  Begin

    PanRSized:=ReSized;

    BarPos:=Current_BarPos(Current_Page);

    If (PanRsized) then
      MULCtrlO.ResizeAllCols(MULCtrlO.VisiList.FindxHandle(Sender),BarPos);

    MULCtrlO.FinishColMove(BarPos+(ListOfset*Ord(PanRSized)),PanRsized);

    FNeedCUpdate:=(MULCtrlO.VisiList.MovingLab or PanRSized);
  end;
end; {Proc..}



procedure TNTxfrForm.N1DLabMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
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

      FNeedCUpdate:=BOn;
    end
    else
      If (Button=mbRight) then
      Begin
        ListPoint:=ClientToScreen(Point(X,Y));

        ShowRightMeny(ListPoint.X,ListPoint.Y,0);
      end;

  end;
end;



procedure TNTxfrForm.N1DLabMouseMove(Sender: TObject; Shift: TShiftState;
  X, Y: Integer);
begin
  If (Sender is TSBSPanel) then
  With (Sender as TSBSPanel) do
  Begin

    If (MULCtrlO<>nil) then
      MULCtrlO.VisiList.MoveLabel(X,Y);

    FNeedCUpdate:=MULCtrlO.VisiList.MovingLab;
  end;

end;

procedure TNTxfrForm.btnViewLineClick(Sender: TObject);
begin
  If MULCtrlO.ValidLine Then Begin
    MULCtrlO.RefreshLine(MULCtrlO.MUListBoxes[0].Row,BOff);
    Display_Id (Id, False);
  End; { If MULCtrlO.ValidLine }
end;


procedure TNTxfrForm.ShowRightMeny(X,Y,Mode  :  Integer);
Begin
  With PopUpMenu1 do
  Begin
    N3.Tag:=99;
    PopUp(X,Y);
  end;
end;


procedure TNTxfrForm.PopupMenu1Popup(Sender: TObject);
Var
  n  :  Integer;
begin
  StoreCoordFlg.Checked:=StoreCoord;
end;


function TNTxfrForm.N1TPerFShowPeriod(Sender: TObject;
  const EPr: Byte): string;
begin
  Result:=PPr_Pr(EPr);
end;


procedure TNTxfrForm.Display_Id (Const TheId : IDetail; Const DataChanged : Boolean);
Begin
  // Create form if required
  If (Not Assigned(IdLine)) And (Not DataChanged) Then
    IDLine := TNTLine.Create(Self);

  If Assigned(IdLine) Then
    // Display Transaction Line
    IdLine.DisplayNomId (ExLocal.LInv, TheId);


(***
  If (IdLine=nil) then
  Begin

    IdLine:=TNTLine.Create(Self);

  end;

  Try


   With IdLine do
   Begin

     WindowState:=wsNormal;
     {Show;}


     InvBtnList.SetEnabBtn(BOff);

     If (Mode In [1..3]) then
     Begin

       Case Mode of

         1..3  :   If (Not ExLocal.InAddEdit) then
                     EditLine(Self.ExLocal.LInv,(Mode=2),Self.ExLocal.LViewOnly)
                   else
                     Show;


       end; {Case..}

     end
     else
       If (Not ExLocal.InAddEdit) then
         ShowLink(Self.ExLocal.LInv,Self.ExLocal.LViewOnly);



   end; {With..}

   IdLineActive:=BOn;


  except

   IdLineActive:=BOff;

   IdLine.Free;

   InvBtnList.SetEnabBtn(BOn);

  end;
***)
end;




procedure TNTxfrForm.SetFieldProperties;
Var
  n  : Integer;
Begin
  N1BtmPanel.Color:=N1FPanel.Color;
  N1BtnPanel.Color:=N1FPanel.Color;

  For n:=0 to Pred(ComponentCount) do
  Begin
    If (Components[n] is TMaskEdit) or (Components[n] is TComboBox)
     or (Components[n] is TCurrencyEdit) and (Components[n]<>N1YrefF) then
    With TGlobControl(Components[n]) do
      If (Tag>0) then
      Begin
        Font.Assign(N1YrefF.Font);
        Color:=N1YrefF.Color;
      end;

    If (Components[n] is TBorCheck) then
      With (Components[n] as TBorCheck) do
      Begin
        CheckColor:=clBlack;
        Color:=N1FPanel.Color;
      end;

  end; {Loop..}

end;


procedure TNTxfrForm.SetFormProperties(SetList  :  Boolean);

Const
  PropTit     :  Array[BOff..BOn] of Str5 = ('Form','List');



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

    If (SetList) then
    Begin
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
    end
    else
    Begin
      TmpPanel[1].Font:=N1YrefF.Font;
      TmpPanel[1].Color:=N1YrefF.Color;

      TmpPanel[2].Font:=N1FPanel.Font;
      TmpPanel[2].Color:=N1FPanel.Color;
    end;


    ColourCtrl:=TCtrlColor.Create(Self);

    try
      With ColourCtrl do
      Begin
        SetProperties(TmpPanel[1],TmpPanel[2],TmpPanel[3],Ord(SetList),Self.Caption+' '+PropTit[SetList]+' Properties',BeenChange,ResetDefaults);

        FNeedCUpdate:=(BeenChange or ResetDefaults);

        If (BeenChange) and (not ResetDefaults) then
        Begin

          If (SetList) then
          Begin
            For n:=1 to 3 do
              With TmpPanel[n] do
                Case n of
                  1,2  :  MULCtrlO.ReColorCol(Font,Color,(n=2));

                  3    :  MULCtrlO.ReColorBar(Font,Color);
                end; {Case..}

            MULCtrlO.VisiList.LabHedPanel.Color:=TmpPanel[2].Color;
          end
          else
          Begin
            N1FPanel.Font.Assign(TmpPanel[2].Font);
            N1FPanel.Color:=TmpPanel[2].Color;

            N1YrefF.Font.Assign(TmpPanel[1].Font);
            N1YrefF.Color:=TmpPanel[1].Color;

            SetFieldProperties;
          end;
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


procedure TNTxfrForm.PropFlgClick(Sender: TObject);
begin
  SetFormProperties((N3.Tag=99));
  N3.Tag:=0;
end;



procedure TNTxfrForm.StoreCoordFlgClick(Sender: TObject);
begin
  StoreCoord:=Not StoreCoord;

  FNeedCUpdate:=BOn;
end;

//-------------------------------------------------------------------------

procedure TNTxfrForm.DisplayTrans (Const TheTrans : InvRec);
Begin { DisplayTrans }
  // Get static data from database
  ExLocal.LInv := TheTrans;

  Caption:=DocNames[EXLocal.LInv.InvDocHed]+' Record - '+Pr_OurRef(EXLocal.LInv);
  N1StatLab.Caption := 'STATUS:'#13'View Only';

  // Change all fields to read-only
  SetNTxfrStore (True);

  // Display Transaction
  OutNTxfr;

  ReFreshList(True,True);
End; { DisplayTrans }

//-------------------------------------------------------------------------

// IMPORTANT NOTE: This message handler is required to ensure the form stays
// on top, as it has a habit of losing its Stay-On-Top'ness at runtime.
procedure TNTxfrForm.WMWindowPosChanged(var Msg : TMessage);
Var
  TopWindow : TWinControl;
Begin
  // Do standard message processing
  Inherited;

  // HM 22/10/03: Added Visible check as it hangs under win 98 otherwise
  If Self.Visible Then
  Begin
    // Check to see if the TopMost window is a Drill-Down window
    TopWindow := FindControl(PWindowPos(Msg.LParam).hwndInsertAfter);
    If Not Assigned(TopWindow) Then
      // Restore TopMost back to window
      SetWindowPos(Handle, HWND_TOPMOST, 0, 0, 0, 0, SWP_NOSIZE or SWP_NOMOVE or SWP_NOACTIVATE);
  End; // If Self.Visible
End;

//-------------------------------------------------------------------------



end.
