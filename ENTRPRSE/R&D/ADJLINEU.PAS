unit AdjLineU;

{$I DEFOVR.Inc}

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, TEditVal, Mask, ExtCtrls, SBSPanel, ComCtrls,
  GlobVar,VarConst,ExWrap1U,

  SalTxl2U,

  BTSupU1,
  BorBtns;


type
  TAdjLine = class(TForm)
    A1SCodef: Text8Pt;
    A1PQF: TCurrencyEdit;
    A1QIF: TCurrencyEdit;
    A1LOF: Text8Pt;
    A1GLF: Text8Pt;
    A1UCF: TCurrencyEdit;
    A1QOF: TCurrencyEdit;
    Label81: Label8;
    Id3QtyLab: Label8;
    PQLab: Label8;
    LocLab: Label8;
    Label84: Label8;
    GLLab: Label8;
    Id3SCodeLab: Label8;
    Okdb1Btn: TButton;
    Candb1Btn: TButton;
    A1BUF: TBorCheck;
    Label86: Label8;
    UDF1L: Label8;
    UDF6L: Label8;
    THUD1F: Text8Pt;
    THUD6F: Text8Pt;
    UDF2L: Label8;
    UDF7L: Label8;
    THUD2F: Text8Pt;
    THUD7F: Text8Pt;
    UDF3L: Label8;
    UDF8L: Label8;
    THUD3F: Text8Pt;
    THUD8F: Text8Pt;
    UDF4L: Label8;
    UDF9L: Label8;
    THUD4F: Text8Pt;
    THUD9F: Text8Pt;
    UDF5L: Label8;
    UDF10L: Label8;
    THUD5F: Text8Pt;
    THUD10F: Text8Pt;
    Label85: Label8;
    A1SDF: Text8Pt;
    A1CCF: Text8Pt;
    CCLab: Label8;
    A1DpF: Text8Pt;
    DepLab: Label8;
    A1JCF: Text8Pt;
    JCLab: Label8;
    A1JAF: Text8Pt;
    JALab: Label8;
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
    procedure A1JCFExit(Sender: TObject);
    procedure A1JAFExit(Sender: TObject);
    procedure A1SCodefDblClick(Sender: TObject);
    procedure A1LOFEnter(Sender: TObject);
    procedure A1LOFExit(Sender: TObject);
    procedure A1BUFClick(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure THUD1FEntHookEvent(Sender: TObject);
    procedure THUD1FExit(Sender: TObject);
    procedure A1QIFEnter(Sender: TObject);
    procedure A1GLFEnter(Sender: TObject);
    Procedure RepositionControls;
    procedure SetUDFields(UDDocHed  :  DocTypes);
    procedure FormShow(Sender: TObject);
    procedure TransExtForm1Resize(Sender: TObject);
  private
    { Private declarations }
    FOrigWidth: Integer;
    A1BUFPrevState : Boolean;

    IdStored,
    StopPageChange,
    NegQtyChk,
    JustCreated  :  Boolean;

    SKeypath     :  Integer;

    LastQtyValue :  Double;

    DispStk      :  TFStkDisplay;

    {$IFDEF SOP}
      Procedure WMCustGetRec(Var Message  :  TMessage); Message WM_CustGetRec;
    {$ENDIF}

    Procedure Send_UpdateList(Edit   :  Boolean;
                              Mode   :  Integer);

    procedure BuildDesign;

    Procedure Set_JCFields(ShowThem  :  Boolean);

    procedure FormDesign;

    Function CheckNeedStore  :  Boolean;

    Procedure SetFieldFocus;

    Function ConfirmQuit  :  Boolean;

    procedure SetIdStore(EnabFlag,
                         VOMode  :  Boolean);

    Procedure SetQtyMulTab;

    Procedure OutId;

    procedure Form2Id;

    Procedure SetLink_Adj;

    procedure StoreId(Fnum,
                      KeyPAth    :  Integer);

    procedure SetHelpContextIDs; // NF: 22/06/06

    procedure OnSelectAlternateStock(AltStockCode: Str20);

    // CJS 2013-09-12 - ABSEXCH-13192 - add Job Costing to user profile rules
    procedure ApplyCCDeptRules;

  public
    { Public declarations }


    ExLocal    :  TdExLocal;

    procedure ShowLink(InvR      :  InvRec;
                       VOMode    :  Boolean);

    Function CompStillEdit  :  boolean;

    Function CheckCompleted(Edit,MainChk  :  Boolean)  : Boolean;

    procedure ProcessId(Fnum,
                        KeyPAth    :  Integer;
                        Edit       :  Boolean);

    procedure SetFieldProperties(Panel  :  TSBSPanel;
                                 Field  :  Text8Pt) ;

    procedure EditLine(InvR       :  InvRec;
                       Edit,
                       ViewOnly   :  Boolean);


    Function NTRight(Amount  :  Real)  :  TCurrencyEdit;


    Function NTOther(TCE  :  TObject)  :  TCurrencyEdit;

  end;



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

  {$IFDEF DBD}
    DebugU,
  {$ENDIF}

  {$IFDEF SOP}
    InvLst3U,
  {$ENDIF}

  {$IFDEF CU}
    Event1U,

  {$ENDIF}

  Saltxl1U,
  PassWR2U,

   PWarnU,

  InvFSu2U,
  //GS 20/10/2011 ABSEXCH-11706: access to the new user defined fields interface
  CustomFieldsIntF,

  // CJS 2013-09-12 - ABSEXCH-13192 - add Job Costing to user profile rules
  JobUtils;




{$R *.DFM}


// CJS 2013-09-12 - ABSEXCH-13192 - add Job Costing to user profile rules
procedure TAdjLine.ApplyCCDeptRules;
var
  JobCCDept: CCDepType;
begin
  // CJS 2013-09-12 - ABSEXCH-13192 - add Job Costing to user profile rules
  JobUtils.GetJobCCDept(ExLocal.LId.JobCode, JobCCDept);
  ExLocal.LId.CCDep := GetProfileCCDepEx('', '', ExLocal.LStock.CCDep, ExLocal.LId.CCDep, JobCCDept, 1);
end;

Procedure TAdjLine.RepositionControls;
begin

end;

//GS 20/10/2011 ABSEXCH-11706: a copy of pauls user fields function
//PR: 11/11/2011 Amended to use centralised function EnableUdfs in CustomFieldsIntf.pas ABSEXCH-12129
procedure TAdjLine.SetUDFields(UDDocHed  :  DocTypes);
var
  VisibleFieldCount: Integer;
begin
  EnableUDFs([UDF1L, UDF2L, UDF3L, UDF4L, UDF5L, UDF6L, UDF7L, UDF8L, UDF9L, UDF10L],
             [THUD1F, THUD2F, THUD3F, THUD4F, THUD5F, THUD6F, THUD7F, THUD8F, THUD9F, THUD10F]
             cfADJLine);

  VisibleFieldCount := NumberOfVisibleUDFs([THUD1F, THUD2F, THUD3F, THUD4F, THUD5F, THUD6F, THUD7F, THUD8F, THUD9F, THUD10F]);
  //adjust position of controls to compensate for hidden rows of UDFs
  ResizeUDFParentContainer(VisibleFieldCount, 5, self);
  ResizeUDFParentContainer(VisibleFieldCount, 5, Okdb1Btn);
  ResizeUDFParentContainer(VisibleFieldCount, 5, Candb1Btn);

  //made additional position adjustments if there are under 5 UDFs visible; resolves issues with slack width space
  if VisibleFieldCount < 5 then
  begin
    Self.width := self.width - 130;
    Candb1Btn.left := Candb1Btn.left - 130;
    Okdb1Btn.left := Okdb1Btn.left - 130;
  end;


end;

procedure TAdjLine.ShowLink(InvR      :  InvRec;
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

  end;

  OutId;


  JustCreated:=BOff;

end;




{ ========== Build runtime view ======== }

procedure TAdjLine.BuildDesign;


begin


end;

Procedure TAdjLine.Set_JCFields(ShowThem  :  Boolean);

Begin
  A1JCF.Visible:=ShowThem;
  A1JAF.Visible:=A1JCF.Visible;
  JCLab.Visible:=A1JCF.Visible;
  JALab.Visible:=A1JCF.Visible;
end;



procedure TAdjLine.FormDesign;

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

  A1PQF.Visible:=Syss.InpPack;
  PQLab.Visible:=Syss.InpPack;

  Set_JCFields(JBCostOn);


  If (Not Syss.AutoValStk) then
  Begin
    GLLab.Visible:=BOff;
    A1GLF.Visible:=BOff;
  end;


  A1PQF.DecPlaces:=Syss.NoQtyDec;
  A1QIF.DecPlaces:=Syss.NoQtyDec;
  A1QOF.DecPlaces:=Syss.NoQtyDec;
  A1UCF.DecPlaces:=Syss.NoCosDec;

  {$IFDEF XSOP not used any more!}
    If (Syss.UseMLoc) then
    Begin
      If (Not Syss.InpPack) then
      Begin
        LocLab.Left:=A1PQF.Left;
        LocLab.Top:=PQLab.Top;
        {LocLab.Width:=Id3PQLab.Width;}

        A1LoF.Left:=A1PQF.Left;
        A1LoF.Top:=A1PQF.Top;
      end
      else
      Begin
        {Id3LocF.Left:=Id3SCodeF.Left+Id3SCodeF.Width+5;
        Id3LocF.Top:=Id3SCodeF.Top;}
      end;
    end;
  {$ENDIF}

  //GS 20/10/2011 ABSEXCH-11706: removed existing UDF setup code; replaced with calling pauls new method
  SetUDFields(ExLocal.LInv.InvDocHed);

  BuildDesign;

end;




procedure TAdjLine.FormCreate(Sender: TObject);
begin
  ExLocal.Create;

  JustCreated:=BOn;

  SKeypath:=0;

  LastQtyValue:=0;

  //GS 20/10/ 2011 ABSEXCH-11706: use height instead of client height
  Height := 218;
  Width:=786;
  FOrigWIdth := self.width;
  NegQtyChk:=BOff;

  With TForm(Owner) do
    Self.Left:=Left+2;

  If (Owner is TStkAdj) then
    With TStkAdj(Owner) do
      Self.SetFieldProperties(A1FPanel,A1YRefF);

  DispStk:=nil;

  FormDesign;

  SetHelpContextIDs; // NF: 22/06/06 Fix for incorrect Context IDs
end;




procedure TAdjLine.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
begin

  GenCanClose(Self,Sender,CanClose,BOn);

  If (CanClose) then
    CanClose:=ConfirmQuit;

  If (CanClose) then
    Send_UpdateList(BOff,100);

end;

procedure TAdjLine.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Action:=caFree;
end;

procedure TAdjLine.FormDestroy(Sender: TObject);


begin
  ExLocal.Destroy;

end;



procedure TAdjLine.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  GlobFormKeyDown(Sender,Key,Shift,ActiveControl,Handle);
end;

procedure TAdjLine.FormKeyPress(Sender: TObject; var Key: Char);
begin
  GlobFormKeyPress(Sender,Key,ActiveControl,Handle);
end;

{ == Procedure to Send Message to Get Record == }

Procedure TAdjLine.Send_UpdateList(Edit   :  Boolean;
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

{$IFDEF SOP}


Procedure TAdjLine.WMCustGetRec(Var Message  :  TMessage);

Var
  DPtr         :  ^Double;
  OpoLineCtrl  :  TOpoLineCtrl;


Begin

  With Message do
  Begin


    Case WParam of

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


    end; {Case..}

  end;
  Inherited;
end;

{$ENDIF}


Function TAdjLine.CheckNeedStore  :  Boolean;

Begin
  Result:=CheckFormNeedStore(Self);
end;


Procedure TAdjLine.SetFieldFocus;

Begin
  A1SCodeF.SetFocus;

end; {Proc..}


Function TAdjLine.CompStillEdit  :  boolean;

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

procedure TAdjLine.Candb1BtnClick(Sender: TObject);
begin
  If (Sender is TButton) then
    With (Sender as TButton) do
    Begin
      If (ModalResult=mrOk) then
      Begin
        // MH 15/12/2010 v6.6 ABSEXCH-10548: Set focus to OK button to trigger OnExit event on date and Period/Year
        //                                   fields which processes the text and updates the value
        If (ActiveControl <> Okdb1Btn) Then
          // Move focus to OK button to force any OnExit validation to occur
          Okdb1Btn.SetFocus;

        // If focus isn't on the OK button then that implies a validation error so the store should be abandoned
        If (ActiveControl = Okdb1Btn) Then
          StoreId(IdetailF,SKeypath);
      End // If (ModalResult=mrOk)
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



Function TAdjLine.ConfirmQuit  :  Boolean;

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



procedure TAdjLine.SetIdStore(EnabFlag,
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


Procedure TAdjLine.SetQtyMulTab;

Begin
  With ExLocal do
    If (Not LViewOnly) and (Is_FullStkCode(LId.StockCode)) then
    With A1PQF, LStock do
    Begin
      TabStop:=Not DPackQty;
      ReadOnly:=DPackQty;
    end;
end;



{ ============== Display Id Record ============ }

Procedure TAdjLine.OutId;

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



    A1JCF.Text:=Strip('R',[#32],JobCode);
    A1JAF.Text:=Strip('R',[#32],AnalCode);

    FoundOk:=GetStock(Self,A1SCodeF.Text,FoundCode,-1);

    If (FoundOk) then
      AssignFromGlobal(StockF);

    A1SDF.Text:=Stock.Desc[1];

    A1QOF.Value:=0;
    A1QIF.Value:=0;

    NTRight(Qty).Value:=Ea2Case(LId,LStock,ABS(Qty));

    SetQtyMulTab;

    A1LoF.Text:=MLocStk;

    A1BuF.Enabled:=((LStock.StockType=StkBillCode) and (Not LStock.ShowasKit));

    A1BuF.Checked:=(KitLink=1);
    A1BUFPrevState := A1BuF.Checked;

    If (Not EmptyKey(LInv.DelTerms,MLocKeyLen)) {v5.00 location transfers only work in one direction and (Not ExLocal.LastEdit)} then
    Begin
      A1QIF.Visible:=BOff;
      Id3QtyLab.Visible:=BOff;
      A1BUF.Visible:=BOff;
      Label86.Visible:=BOff;
    end
    else
    Begin
      A1QIF.Visible:=BOn;
      Id3QtyLab.Visible:=BOn;
      A1BUF.Visible:=BOn;
      Label86.Visible:=BOn;
    end;

    If (InAddEdit) and (JBCostOn) then
    Begin
      Set_JCFields((Not A1BuF.Checked));
    end;

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

  end;


end;


procedure TAdjLine.Form2Id;

Begin

  With EXLocal,LId do
  Begin
    NomCode:=IntStr(A1GLF.Text);

    CCDep[BOn]:=A1CCF.Text;
    CCDep[BOff]:=A1DpF.Text;

    If (JBCostOn) then
    Begin
      JobCode:=FullJobCode(A1JCF.Text);
      AnalCode:=FullJACode(A1JAF.Text);
    end;

    StockCode:=FullStockCode(A1SCodeF.Text);
    QtyMul:=A1PQF.Value;
    QtyPack:=QtyMul;
    Qty:=Case2Ea(LId,LStock,A1QIF.Value+(A1QOF.Value*DocNotCnst));

    CostPrice:=A1UCF.Value;

    {$IFDEF SOP}
      MLocStk:=Full_MLocKey(A1LoF.Text);

    {$ELSE}
      MLocStk:=A1LoF.Text;

    {$ENDIF}

    KitLink:=Ord(A1BUF.Checked);

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

  end; {with..}

end; {Proc..}





(*  Add is used to add Notes *)

procedure TAdjLine.ProcessId(Fnum,
                            Keypath     :  Integer;
                            Edit        :  Boolean);

Var
  KeyS  :  Str255;


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

      If (Not LViewOnly) then
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

    If (Not Edit) then
    Begin

      LastQtyValue:=0;

      LResetRec(Fnum);

      FolioRef:=LInv.FolioNum;

      DocPRef:=LInv.OurRef;

      LineNo:=RecieptCode;

      ABSLineNo:=LInv.ILineCount;

      IDDocHed:=LInv.InvDocHed;

      PostedRun:=StkAdjRunNo;

      NomMode:=StkAdjNomMode;

      QtyMul:=1;

      QtyPack:=QtyMul;

      PriceMulX:=1.0;

      LineType:=StkLineType[IdDocHed];

      Currency:=LInv.Currency;

      CXRate:=LInv.CXRate;

      CurrTriR:=LInv.CurrTriR;

      PYr:=LInv.ACYr;
      PPr:=LInv.AcPr;

      Payment:=SetRPayment(LInv.InvDocHed);

      If (Syss.AutoClearPay) then
        Reconcile:=ReconC;



      PDate:=LInv.TransDate;

      If (JBCostOn) then
      Begin

        JobCode:=LInv.DJobCode;
        AnalCode:=LInv.DJobAnal;


        NomCode:=Job_WIPNom(NomCode,JobCode,AnalCode,StockCode,MLocStk,CustCode);

      end;



    end
    else
      LastQtyValue:=Qty*QtyMul;

    LastId:=LId;


    OutId;

    SetIdStore(BOn,ExLocal.LViewOnly);

  end; {If Abort..}

end; {Proc..}




Function TAdjLine.CheckCompleted(Edit,MainChk  :  Boolean)  : Boolean;

Const
  NofMsgs      =  10;

Type
  PossMsgType  = Array[1..NofMsgs] of Str80;

Var
  PossMsg  :  ^PossMsgType;

  ExtraMsg :  Str80;

  Test     :  Byte;

  FoundCode:  Str20;

  FLowStk
           :  Boolean;

  Loop,
  ShowMsg  :  Boolean;

  mbRet    :  Word;

  FoundLong
           :  LongInt;

  BalNow   :  Double;


Begin
  ShowMsg := False;
  New(PossMsg);


  FillChar(PossMsg^,Sizeof(PossMsg^),0);

  PossMsg^[1]:='General Ledger Code is not valid.';
  PossMsg^[2]:='Stock Code is not valid.';
  PossMsg^[3]:='Cost Centre/ Department Code not valid.';
  PossMsg^[4]:='Job Code is not valid.';
  PossMsg^[5]:='Job Analysis Code is not Valid.';
  PossMsg^[6]:='You must correct the last invalid entry before storing this line.';
  PossMsg^[7]:='Maximum line value exceeded.';
  PossMsg^[8]:='Location Code is not valid.';
  PossMsg^[9]:='An additional check is made via an external hook';
  PossMsg^[10]:='The checkstock routine was never called, so call it now';



  FLowStk:=BOff;

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
              Result:=Not Syss.AutoValStk;

              If (Not Result) then
              Begin
                Result:=GetNom(Self,Form_Int(NomCode,0),FoundLong,-1);

                If (Result) and (Not SBSIn) then
                  Result:=(Nom.NomType In BankSet+ProfitBFSet);
              end;

            end;

      2  :  Begin
              {$IFDEF STK}


                Result:=GetStock(Self,StockCode,Foundcode,-1);

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

                    Result:=(GetCCDep(Self,CCDep[Loop],FoundCode,Loop,-1) and (Result));

                  end;
                end;

              end;

        4  :  Begin

                Result:=((Not JBCostOn) or (EmptyKey(JobCode,JobCodeLen)));

                If (Not Result) then
                  Result:=GetJob(Self,JobCode,FoundCode,-1);

              end;


        5  :  Begin

                Result:=((Not JBCostOn)  or (EmptyKey(JobCode,JobCodeLen)));

                If (Not Result) then
                  Result:=GetJobMisc(Self,AnalCode,FoundCode,2,-1);

              end;

        9  :  Begin {* Opportunity for hook to validate this line as well *}
                 {$IFDEF CU}

                   Result:=ValidExitHook(4000,20,ExLocal);
                   ShowMsg:=BOff;

                 {$ENDIF}
              end;


      {$ENDIF}

      6  :  Begin
              Result:=(Not CompStillEdit);

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

       10  :  Begin
//                Result:= (Not Syss.UseStock) or (not CheckNegStk) or (NegQtyChk) or (Qty>0);

                if Syss.UseStock and CheckNegStk and (Qty>0) then
//                If (Not Result) then
                Begin
//                  If (LastId.MLocStk<>MLocStk) then {* Discount last qty as loc has changed and this is not an edit now *}
//                    LastId.Qty:=0;

                  // CJS 2012-01-19: ABSEXCH-11460 - Stock warning on in-loc transfer.
                  // For BoM items we need to recalculate the quantities from
                  // scratch, so pass the actual quantity required rather than
                  // the stock movement.
                  if (LStock.StockType = StkBillCode) and (A1BUF.Checked) then
                    Check_StockCtrl(StockCode,(Qty*QtyMul)*DocNotCnst,3,FLowStk,IdDocHed,LId,Self.Handle,OnSelectAlternateStock, LastEdit)
                  else
                  Check_StockCtrl(StockCode,((Qty*QtyMul)-(LastId.Qty*LastId.QtyMul))*DocNotCnst,1+Ord(CheckNegStk and (Not (IdDocHed In OrderSet))),
                           FLowStk,IdDocHed,LId,Self.Handle,OnSelectAlternateStock, LastEdit);

                  Result:=Not FLowStk;

                  ShowMsg:=Result;


                end;
              end;



    end;{Case..}

    If (Result) then
      Inc(Test);

  end; {While..}

  If (Not Result) and (ShowMsg) and (Not MainChk) then
    mbRet:=MessageDlg(ExtraMsg+PossMsg^[Test],mtWarning,[mbOk],0);

  Dispose(PossMsg);

end; {Func..}


procedure TAdjLine.StoreId(Fnum,
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

      {$IFDEF CU} {* Call hooks here *}
        GenHooks(4000,92,ExLocal);
      {$ENDIF}

      COk:=CheckCompleted(LastEdit,BOff);


      If (COk) then
      Begin
        Cursor:=CrHourGlass;

        {$IFDEF SOP}

            Self.Enabled:=BOff;
            TForm(Owner).Enabled:=BOff;

            Control_SNos(LId,LInv,LStock,1,Self);

            Self.Enabled:=BOn;
            TForm(Owner).Enabled:=BOn;
            TForm(Owner).Show;


        {$ENDIF}

        Deduct_AdjStk(LastId,LInv,BOff);

        Deduct_AdjStk(LId,LInv,BOn);

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
          Inc(LInv.ILineCount);


          Status:=Add_Rec(F[Fnum],Fnum,LRecPtr[Fnum]^,KeyPAth);

        end;

        Report_BError(Fnum,Status);

        If (StatusOk) then
        Begin



          {$IFDEF PF_On}

            If (JbCostOn) and (Not (LId.IdDocHed In PurchSet)) then

              Update_JobAct(LId,LInv);

          {$ENDIF}

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


procedure TAdjLine.SetFieldProperties(Panel  :  TSBSPanel;
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


procedure TAdjLine.EditLine(InvR       :  InvRec;
                           Edit,
                           ViewOnly   :  Boolean);


begin
  With ExLocal do
  Begin
    LastEdit:=Edit;

    ShowLink(InvR,ViewOnly);

    ProcessId(IdetailF,CurrKeyPath^[IdetailF],LastEdit);
  end;
end;



procedure TAdjLine.A1BUFClick(Sender: TObject);
begin
  If (ExLocal.InAddEdit) then
  Begin
    If (JBCostOn)  then
      Set_JCFields(Not A1BUF.Checked);

    If (CheckNegStk) then
    Begin
      A1QIF.Value:=0.0;
      LastQtyValue:=0.0;
    end;

    // MH 29/04/2010 v6.4 ABSEXCH-9707: Added message to warn that Build Costs need Updating
    If A1BUF.Checked And (Not A1BuFPrevState) And Syss.NeedBMUp Then
    Begin
      MessageDlg ('The Build Costs require updating due to changes in component costs', mtWarning, [mbOK, mbHelp], 8063);
    End; // If A1BUF.Checked And Syss.NeedBMUp

    // NOTE: Due to the crapness of the TBorCheck control it sends two click events
    // when the user clicks on it with a mouse - the first event has the old state - so
    // to prevent messages being displayed when the user unticks the fields we need to
    // track the last processed state
    A1BuFPrevState := A1BuF.Checked;
  end;
end;


procedure TAdjLine.A1GLFEnter(Sender: TObject);
begin
  If (Sender is Text8pt) then
  With (Sender as Text8pt) do
  With ExLocal do
  If (InAddEdit) and (Text<>'') then
  Begin
    ReadOnly:=(Not PChkAllowed_In(571));
  end;
end;



procedure TAdjLine.A1GLFExit(Sender: TObject);
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

      FoundOk:=(GetNom(Self.Owner,FoundCode,FoundLong,0));

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





procedure TAdjLine.A1CCFExit(Sender: TObject);
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

        // CJS 2013-09-12 - ABSEXCH-13192 - add Job Costing to user profile rules
        // For Job Costing, allow the user to pass through the Cost Centre and
        // Department fields without selecting anything, but if they have
        // entered values, do the normal validation.
        if (FoundCode <> '') or (not A1JCF.Visible) then
        begin
          StillEdit:=BOn;

          //TG 15-05-2017 2017 R2 18699 - Access Violation message - creating Job Record using inactive CC/Dept
          // Mode 2 has to sent instead of 0
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
      end;

    end; {with..}

  {$ENDIF}
end;





{ ================= Function Return if input should be a debit / Credit ========= }

Function TAdjLine.NTRight(Amount  :  Real)  :  TCurrencyEdit;

Begin
  If (Amount<0) then
    NTRight:=A1QOF
  else
    NTRight:=A1QIF;
end;


{ ================= Function Return if input should be a debit / Credit ========= }

Function TAdjLine.NTOther(TCE  :  TObject)  :  TCurrencyEdit;

Begin
  If (TCE=A1QIF) then
    Result:=A1QOF
  else
    Result:=A1QIF;
end;



Procedure TAdjLine.SetLink_Adj;
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
                                                     {* v5.00.001. Altered to only calcpack, otherwise
                                                     non split pack items priced individually were not showing the
                                                     correct cost price}
    Rnum:=Currency_ConvFT(Calc_StkCP(LStock.CostPrice,LStock.BuyUnit,({LStock.DPackQty And }LStock.CalcPack)),
                          LStock.PCurrency,LInv.Currency,UseCoDayRate);

    {* To be replaced by FIFO Calc *}

    CostPrice:=Round_Up(Rnum,Syss.NoCosDec);

    If (LStock.StockType=StkBillCode) then
      NomCode:=LStock.NomCodes[5]  {* Asjust WIP *}
    else
      NomCode:=LStock.NomCodes[3];

    ShowCase:=LStock.DPackQty;

    If (ShowCase) then
      QtyPack:=LStock.BuyUnit;

    {$IFDEF PF_On}

    {* Override with WIP Nominal code *}

    NomCode:=Job_WIPNom(NomCode,JobCode,AnalCode,StockCode,MLocStk,CustCode);

    With LStock do
      If (JBCostOn) and (Not EmptyKey(JAnalCode,AnalKeyLen)) then
        AnalCode:=JAnalCode;

     {If (EmptyKeyS(CCDep[BOff],CCKeyLen,BOff)) then v4.32 method
       CCDep[BOff]:=LStock.CCDep[BOff];

     If (EmptyKeyS(CCDep[BOn],CCKeyLen,BOff)) then
       CCDep[BOn]:=LStock.CCDep[BOn];}

    ApplyCCDeptRules;
    {$ENDIF}

    {$IFDEF SOP}
    LStock:=TmpStk^;
    Dispose(TmpStk);
    {$ENDIF}
  end;
end; {Proc..}



procedure TAdjLine.A1SCodefExit(Sender: TObject);
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

    FoundCode:=Text;

    {$IFDEF CU} {* Call hooks here *}

      Text:=TextExitHook(4000,15,Text,ExLocal);

      AltMod:=(AltMod or (FoundCode<>Text));

    {$ENDIF}

    FoundCode:=Strip('B',[#32],Text);

    If ((AltMod) or (FoundCode='')) and (ActiveControl<>Candb1Btn) then
    Begin

      StillEdit:=BOn;

      FoundOk:=(GetStock(Self.Owner,FoundCode,FoundCode,0));

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
            NTRight(Qty).Value:=0.0;
            Qty:=0;
            QtyMul:=1;
            QtyPack:=QtyMul;
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

procedure TAdjLine.A1QIFEnter(Sender: TObject);
begin
{$IFDEF CU}
  If (Sender is TCurrencyEdit) then
  With TCurrencyEdit(Sender) do
    If (Not ReadOnly) then
    Begin
      Value:=ValueExitHook(4000,1+(86*Ord(Sender=A1QOF)),Value,ExLocal,DoFocusFix);
    end;
  {$ENDIF}

end;

procedure TAdjLine.A1QIFExit(Sender: TObject);

Var
  AltMod,
  FlowStk  :  Boolean;

begin
  FLowStk:=BOff;

  If (Sender is TCurrencyEdit) then
  With (Sender as TCurrencyEdit) do
  Begin
//    AltMod:=FloatModified;
    AltMod := True;

    If ((AltMod) or (StillEdit)) and (ActiveControl<>Candb1Btn) then
    With ExLocal,LId do
    Begin
      {SS 30/06/2016 2016-R3
    	 ABSEXCH-14333:Negative stock - once the transaction is added then edited later the negative warning does not show.
       Reset In-Quantity before validate Out-Quantity. }
      if  (Sender = A1QOF)  and (Round_up(A1QIF.Value,2)<>0.0) and (Round_up(A1QOF.Value,2)<>0.0) then
      begin
        NTOther(Sender).Value:=0.0;
      end;

      Form2Id;

      NTRight(Qty).Value:=Ea2Case(LId,LStock,ABS(Qty));

      StillEdit:=BOn;


      If (Syss.UseStock) and (Qty<>0) and (CheckNegStk) then
      Begin
        NegQtyChk:=BOn;

//        LastQtyValue := 0;
        // CJS 2012-01-19: ABSEXCH-11460 - Stock warning on in-loc transfer.
        // For BoM items we need to recalculate the quantities from
        // scratch, so pass the actual quantity required rather than
        // the stock movement.
        if (LStock.StockType = StkBillCode) and (A1BUF.Checked) then
          Check_StockCtrl(StockCode,(Qty*QtyMul)*DocNotCnst,3,FLowStk,IdDocHed,LId,Self.Handle,OnSelectAlternateStock, LastEdit)
        else
        If ((LStock.StockType<>StkBillCode) or (A1BUF.Checked) or (Sender<>A1QIF)) then
          Check_StockCtrl(StockCode,((Qty*QtyMul)-LastQtyValue)*DocNotCnst,3,FLowStk,IdDocHed,LId,Self.Handle,OnSelectAlternateStock, LastEdit);

        If (FLowStk) and (CanFocus) then {* Force adjustment *}
         SetFocus
        else
          StillEdit:=BOff;
      end
      else
        StillEdit:=BOff;

      If (Round_up(Value,2)<>0.0) and (Not StillEdit) then
        NTOther(Sender).Value:=0.0;

      {$IFDEF CU} {* Call hooks here *}
        GenHooks(4000,90+Ord(Sender=A1QOF),ExLocal,DoFocusFix);
      {$ENDIF}

    end;

  end; {If/With..}
end;



procedure TAdjLine.A1JCFExit(Sender: TObject);
Var
  FoundCode  :  Str20;

  FoundOk,
  AltMod     :  Boolean;

begin
  {$IFDEF PF_On}

    If (Sender is Text8pt) then
    With (Sender as Text8pt) do
    Begin
//      AltMod:=Modified;
      AltMod := True;

      FoundCode:=Strip('B',[#32],Text);

      If (AltMod)  and (ActiveControl<>Candb1Btn) then
      Begin
        If (FoundCode<>'') then
        Begin

          StillEdit:=BOn;

          FoundOk:=(GetJob(Self.Owner,FoundCode,FoundCode,4));

          If (FoundOk) then {* Credit Check *}
          With ExLocal do
          Begin
            StillEdit:=BOff;

            AssignFromGlobal(JobF);

            Text:=FoundCode;

            With LId do
            Begin
              Form2Id;
              NomCode:=Job_WIPNom(NomCode,JobCode,AnalCode,StockCode,MLocStk,CustCode);

              // CJS 2013-09-12 - ABSEXCH-13192 - add Job Costing to user profile rules
              ApplyCCDeptRules;

              OutId;
            end;
          end
          else
          Begin

            SetFocus;
          end; {If not found..}
        end
        else
          If (OrigValue<>'') then
          Begin
            If (JBCostOn) then
            With ExLocal do
            Begin
              Form2Id;
              SetLink_Stock(LId,LInv,LCust,1,0,LId.Qty*LId.QtyMul,254);
              OutId;
            end;

            A1JAF.Text:='';
          end;
      end;

    end;
  {$ENDIF}
end;



procedure TAdjLine.A1JAFExit(Sender: TObject);
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

      If (((AltMod) or (FoundCode='')) and (Not EmptyKey(A1JCF.Text,JobCodeLen))) and (ActiveControl<>Candb1Btn) and (JBCostOn) then
      Begin

        StillEdit:=BOn;

        FoundOk:=(GetJobMisc(Self.Owner,FoundCode,FoundCode,2,Anal_FiltMode(ExLocal.LId.IdDocHed)));

        If (FoundOk) then {* Credit Check *}
        With ExLocal do
        Begin
          StillEdit:=BOff;
          
          AssignFromGlobal(JMiscF);

          Text:=FoundCode;

          With LId do
            Begin
              Form2Id;
              NomCode:=Job_WIPNom(NomCode,JobCode,AnalCode,StockCode,MLocStk,CustCode);
              OutId;
            end;
        end
        else
        Begin
          SetFocus;
        end; {If not found..}
      end;

    end;
  {$ENDIF}

end;



procedure TAdjLine.A1SCodefDblClick(Sender: TObject);
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

procedure TAdjLine.A1LOFEnter(Sender: TObject);

Var
  OldLoc  :  Str10;

begin
  {$IFDEF SOP}
    If (Syss.UseMLoc) and (EmptyKey(A1LoF.Text,MLocKeyLen)) then
    Begin
      If (EmptyKey(A1LoF.Text,MLocKeyLen)) then
      Begin
        OldLoc:=A1LoF.Text;

        A1LoF.Text:=GetProfileMLoc('',ExLocal.LStock.DefMLoc,'',0);

        If (OldLoc<>A1LoF.Text) then
        Begin
          A1LoF.AltMod:=BOn;
        end;
      end;
    end;

    If (UseEMLocStk) and (Syss.UseMLoc) then
        NegQtyChk:=BOff;
  {$ENDIF}
end;

procedure TAdjLine.A1LOFExit(Sender: TObject);
Var
  SCode      :  Str20;
  FoundCode  :  Str10;

  FoundOk,
  tAltMod    :  Boolean;


begin

  {$IFDEF SOP}

    Form2Id;

    If (Sender is Text8pt) then
    With (Sender as Text8pt) do
    Begin
      tAltMod:=(Modified or AltMod);

      FoundCode:=Strip('B',[#32],Text);

      Scode:=ExLocal.LId.StockCode;

      If ((tAltMod) or (FoundCode='')) and (ActiveControl<>Candb1Btn) and (ActiveControl<>Okdb1Btn)
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

          NegQtyChk:=BOff;

          OutId;

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





procedure TAdjLine.THUD1FEntHookEvent(Sender: TObject);
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

procedure TAdjLine.THUD1FExit(Sender: TObject);
begin
  If (Sender is Text8Pt)  and (ActiveControl<>Candb1Btn) then
    Text8pt(Sender).ExecuteHookMsg;

end;


procedure TAdjLine.FormActivate(Sender: TObject);
begin
  If (JustCreated) then
    SetFieldFocus;

  {$IFDEF SOP}
     OpoLineHandle:=Self.Handle;
  {$ENDIF}

end;

procedure TAdjLine.SetHelpContextIDs;
// NF: 22/06/06
begin
  // Fix incorrect IDs
  HelpContext := 1887;
  A1SCodef.HelpContext := 1886;
end;

procedure TAdjLine.OnSelectAlternateStock(AltStockCode: Str20);
{ Called from TStockLevelsFrm if the user selects an Equivalent stock item to
  replace an item with insufficient stock. }
begin
  A1SCodeF.OrigValue := A1SCodeF.Text;
  A1SCodeF.Text      := AltStockCode;
  A1SCodeF.Modified  := BOn;
  A1SCodeFExit(A1SCodeF);
end;

procedure TAdjLine.FormShow(Sender: TObject);
begin
  //GS 20/10/ 2011 ABSEXCH-11706: reposition the form controls when the form is shown
  RepositionControls;
end;

procedure TAdjLine.TransExtForm1Resize(Sender: TObject);
begin
  //GS 20/10/ 2011 ABSEXCH-11706: reposition the form controsl when the form is resized
  RepositionControls;
end;

Initialization

end.
