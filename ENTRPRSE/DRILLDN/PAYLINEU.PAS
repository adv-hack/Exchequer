//
//
//  NOTE: Copy of standard PayLineU for the OLE Drill-Down server
//
//

unit PaylineU;

{$I DefOvr.Inc}

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  Globvar,VarConst,SBSComp,SupListU,Grids, StdCtrls, Buttons,
  Mask, ExtCtrls, TEditVal, SBSPanel, BorBtns,ExWrap1U, Menus,
  BtSupU1;

Const
  WM_PayGetLine  =  WM_User+$112;


type



  TPayInSetUp  =  Record

                        ColPanels   :  Array[0..13] of TSBSPanel;

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
    THUD4F: Text8Pt;
    UDF4L: Label8;
    THUD3F: Text8Pt;
    UDF3L: Label8;
    THUD2F: Text8Pt;
    UDF2L: Label8;
    THUD1F: Text8Pt;
    UDF1L: Label8;
    PINDF: Text8Pt;
    Label84: Label8;
    JCLab: Label8;
    PIJCF: Text8Pt;
    PIJAF: Text8Pt;
    JALab: Label8;
    UDF5L: Label8;
    THUD5F: Text8Pt;
    THUD9F: Text8Pt;
    UDF9L: Label8;
    THUD8F: Text8Pt;
    UDF8L: Label8;
    THUD7F: Text8Pt;
    UDF7L: Label8;
    THUD6F: Text8Pt;
    UDF6L: Label8;
    UDF10L: Label8;
    THUD10F: Text8Pt;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure FormKeyPress(Sender: TObject; var Key: Char);
    procedure Candb1BtnClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
private
    { Private declarations }
    OrigWidth: Integer;
    OrigHeight: Integer;
    OrigOKTop: Integer;
    OrigOKLeft: Integer;
    OrigCanTop: Integer;
    OrigCanLeft: Integer;

    FormClosed: Boolean;

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

    procedure ShowJobFields(ShowMode  :  Boolean);

    procedure SetUDFields;

    procedure FormDesign;

    procedure PIPanelMouseDown(Sender: TObject;
                               Button: TMouseButton; Shift: TShiftState; X, Y: Integer);

    procedure PIPanelMouseMove(Sender: TObject;
                               Shift: TShiftState; X, Y: Integer);

    procedure PIPanelMouseUp(Sender: TObject;
                             Button: TMouseButton; Shift: TShiftState; X, Y: Integer);

    Procedure WMPayGetLine(Var Message  :  TMessage); message WM_PayGetLine;
    procedure WMWindowPosChanged(var Msg : TMessage); Message WM_WindowPosChanged;


    Procedure Send_UpdateList(Edit   :  Boolean;
                              Mode   :  Integer);


    Function CheckNeedStore  :  Boolean;

    Procedure SetFieldFocus;

    procedure SetIdStore(EnabFlag,
                         VOMode  :  Boolean);

    procedure SetFieldProperties(Panel  :  TSBSPanel;
                                 Field  :  Text8Pt) ;



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

    procedure ShowLink(Const InvR      :  InvRec;
                       Const VOMode    :  Boolean);

    procedure AddEditPay(Const Edit,VOMode  :  Boolean;
                         Const SBNom        :  LongInt;
                         Const SBValue      :  Double;
                         Const InvR         :  InvRec);



    procedure SetFormProperties;

    procedure CtrlView;



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
  EntLicence,     // Global Exchequer Licence object
  TranSOPF,

  {$IFDEF PF_On}

     //InvLst2U,

  {$ENDIF}

  ColCtrlU,
  CmpCtrlU,
  SysU2,
  SysU3,
  MiscU,
  //SaleTx2U,
  //RecepU,

  InvListU,
  CustomFieldsIntF;

  //PayF2U,

  {$IFDEF DBD}
    //DebugU,
  {$ENDIF}

  {$IFDEF CU}
    //Event1U,

  {$ENDIF}

  //PassWR2U,
  //Saltxl1U;





{ ============ TPayList Methods ================= }



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


  Function FormatCurFloat(Fmask  :  Str255;
                          Value  :  Double;
                          SBlnk  :  Boolean;
                          Cr     :  Byte)  :  Str255;
  Var
    GenStr  :  Str5;
  Begin
    If (EnterpriseLicence.elCurrencyVersion In [cvEuro, cvGlobal]) Then
      // $IFDEF MC_On
      GenStr:=SSymb(Cr)
    Else
      GenStr:='';

    If (Value<>0.0) or (Not SBlnk) then
      Result:=GenStr+FormatFloat(Fmask,Value)
    else
      Result:='';
  end;


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

       5  :  Begin
               Case DisplayMode of
                 0  :  If (PostedRun>0) then
                         OutLine:=Extract_PayRef2(Id.StockCode)
                       else
                         OutLine:=Extract_PayRef1(Id.StockCode);

                 1  :  OutLine:=GetReconcileStatus(Reconcile);

               end; {Case..}
             end;

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

procedure TPayLine.SetUDFields;
const
  UDF_ROW_COUNT = 5;
var
  VisibleUDFCount: Integer;

Begin  
  //GS 17/11/2011 ABSEXCH-12037: modifed UDF settings code to use the new "CustomFieldsIntF" unit

  if FormClosed = True then
    begin

    self.Width := OrigWidth;
    self.Height := OrigHeight;
    Okdb1Btn.Top := OrigOKTop;
    Okdb1Btn.Left := OrigOKLeft;
    Candb1Btn.Top := OrigCanTop;
    Candb1Btn.Left := OrigCanLeft;

    EnableUDFs([UDF1L, UDF2L, UDF3L, UDF4L, UDF5L, UDF6L, UDF7L, UDF8L, UDF9L, UDF10L],
               [THUD1F, THUD2F, THUD3F, THUD4F, THUD5F, THUD6F, THUD7F, THUD8F, THUD9F, THUD10F], DocTypeToCFCategory(ExLocal.LInv.InvDocHed, True));

    VisibleUDFCount := NumberOfVisibleUDFs([THUD1F, THUD2F, THUD3F, THUD4F, THUD5F, THUD6F, THUD7F, THUD8F, THUD9F, THUD10F]);

    if (VisibleUDFCount < 5) and (self.width = origWidth) then
    begin
      Self.Width := Self.Width - 130;
      Okdb1Btn.Left := Okdb1Btn.Left - 130;
      Candb1Btn.Left := Candb1Btn.Left - 130;
    end;

    if (VisibleUDFCount >= 5) and (self.width <> origWidth) then
    begin
      Self.Width := Self.Width + 130;
      Okdb1Btn.Left := Okdb1Btn.Left + 130;
      Candb1Btn.Left := Candb1Btn.Left + 130;
    end;

    ResizeUDFParentContainer(VisibleUDFCount, UDF_ROW_COUNT, self, 30);
    ResizeUDFParentContainer(VisibleUDFCount, UDF_ROW_COUNT, Okdb1Btn, 30);
    ResizeUDFParentContainer(VisibleUDFCount, UDF_ROW_COUNT, Candb1Btn, 30);
  end;
  FormClosed := False;

end;


procedure TPayLine.FormDesign;

Var
  HideCC  :  Boolean;

Begin

  If (EnterpriseLicence.elCurrencyVersion = cvPro) Then Begin
    // $IFNDEF MC_On
    PIBEF.Visible:=BOff;
    BELab.Visible:=BOff;
    CurLab.Visible:=BOff;
    PICurrF.Visible:=BOff;
  End { If }
  Else Begin
    Set_DefaultCurr(PICurrF.Items,BOff,BOff);
    Set_DefaultCurr(PICurrF.ItemsL,BOff,BOn);
  End; { Else }


  HideCC:=BOff;


  HideCC:=Not Syss.UseCCDep;

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




  Height:= 214;
  Width:=749;

  With TForm(Owner) do
    Self.Left:=Left+2;



end;

procedure TPayLine.FormCreate(Sender: TObject);
begin
  FormCLosed := True;
  OrigWidth := Self.Width;
  OrigHeight := self.Height;
  OrigOKTop := Okdb1Btn.Top;
  OrigOKLeft := Okdb1Btn.Left;
  OrigCanTop := Candb1Btn.Top;
  OrigCanLeft := Candb1Btn.Left;

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


  If (Owner is TfrmSOPTrans) then
  Begin
    With TfrmSOPTrans(Owner) do
      Self.SetFieldProperties(I1FPanel,I1AccF)
  end
(*
  else
  If (Owner is TRecepForm) then
  Begin
    With TRecepForm(Owner) do
      Self.SetFieldProperties(R1FPanel,R1AccF);
  end;
*)

end;

procedure TPayLine.FormDestroy(Sender: TObject);
begin
  ExLocal.Destroy;

  Try
    If (MULCtrlO<>Nil) then
      MULCtrlO.Destroy; {* Must be destroyed here, as owned by ROB1...}

  Finally

    MULCtrlO:=Nil;

  end; {Finally..}
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

  ExLocal.LInv:=TInv;


  With ExLocal.LInv do
    NFolio:=FolioNum;

    Key2F:=FullIdKey(NFolio,RecieptCode);

  If (AOwner is TForm) and (MULCtrlO=Nil) then
  Begin


    MULCtrlO:=TPayList.Create(Self);


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

            VisiRec:=List[0];

            StartPanel:=(VisiRec^.PanelObj as TSBSPanel);

            ScrollCont:=ScrollBox;

            FormStoreCoord:=PropPopUp;

            If (EnterpriseLicence.elCurrencyVersion = cvPro) Then
              // $IFNDEF MC_On {* Hide Base Equiv Panel *}
              SetHidePanel(4,BOn,BOn);

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
        MUTotCols:=5;
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


procedure TPayLine.SetIdStore(EnabFlag,
                              VOMode  :  Boolean);

Var
  Loop  :  Integer;

Begin

  ExLocal.InAddEdit:=Not VOMode;

  Okdb1Btn.Enabled:=Not VOMode;

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

    If (EnterpriseLicence.elCurrencyVersion In [cvEuro, cvGlobal]) Then Begin
      // $IFDEF MC_On
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
    End; { If (EnterpriseLicence.elCurrencyVersion In [cvEuro, cvGlobal]) }

    PIJCF.Text:=Strip('R',[#32],JobCode);
    PIJAF.Text:=Strip('R',[#32],AnalCode);

    FoundOk:=GetNom(Self,PINAF.Text,FoundLong,-1);

    PINDF.Text:=Nom.Desc;

    THUd1F.Text:=LineUser1;
    THUd2F.Text:=LineUser2;
    THUd3F.Text:=LineUser3;
    THUd4F.Text:=LineUser4;
    //GS 17/11/2011 ABSEXCH-12037: put customisation values into text boxes
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
      StockCode:=Pre_PostPayInKey(PayInCode,PIPIF.Text);

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
    //GS 17/11/2011 ABSEXCH-12037: write udef field values into customisation object
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

      If (Not LViewOnly) then
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
    (** HM: This section not required for Drill-Down
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


      If (EnterpriseLicence.elCurrencyVersion = cvPro) Then Begin
        // $IFDEF PF_On
        If (Syss.UseCCDep) and (LCust.CustCode=CustCode) then
        Begin
          {CCDep[BOn]:=LCust.CustCC; v4.32 method
          CCDep[BOff]:=LCust.CustDep;}

          With LCust do
            CCDep:=GetCustProfileCCDep(CustCC,CustDep,CCDep,0);

        end;
      End; { If (EnterpriseLicence.elCurrencyVersion = cvPro) }
    end;
    **)

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


procedure TPayLine.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  GlobFormKeyDown(Sender,Key,Shift,ActiveControl,Handle);
end;


procedure TPayLine.FormKeyPress(Sender: TObject; var Key: Char);
begin
  GlobFormKeyPress(Sender,Key,ActiveControl,Handle);
end;



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
        CheckColor:=Field.Color;
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



    SetUDFields;


    Self.Visible:=BOn;

    SelfBalNom:=SBNom;
    SelfBalVal:=SBValue;
    GenSelfBal:=(SelfBalNom<>0);



    With MULCtrlO do
      If ((PageKeys^[MUListBoxes[0].Row]<>0) or (Not Edit)) and (Not InListFind) then
        ProcessPay(Edit,BOff,VOMode);


  end; {With..}

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

procedure TPayLine.Candb1BtnClick(Sender: TObject);
begin
  Close;
end;

procedure TPayLine.WMWindowPosChanged(var Msg: TMessage);
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
end;

procedure TPayLine.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  FormClosed := True;
end;

Initialization

end.
