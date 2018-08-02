unit AllcWizU;

interface

{$I DEFOVR.Inc}

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, WIZTEMPU, StdCtrls, TEditVal, TCustom, ExtCtrls, SBSPanel,
  ComCtrls, BorBtns, Mask, GlobVar, VarConst, VarRec2U, BTSupU1;


type
  TAllocateWiz = class(TWizTemplate)
    DAddr1F: Text8Pt;
    DAddr2F: Text8Pt;
    DAddr3F: Text8Pt;
    DAddr4F: Text8Pt;
    DAddr5F: Text8Pt;
    Label822: Label8;
    I4JAnalL: Label8;
    I4JobAnalF: Text8Pt;
    I4JobCodeF: Text8Pt;
    I4JobCodeL: Label8;
    Label812: Label8;
    PayIF: Text8Pt;
    Label819: Label8;
    cbSortLF: TSBSComboBox;
    Label820: Label8;
    bcAllowSDiscF: TBorCheck;
    UDF1L: Label8;
    THUD1F: Text8Pt;
    UDF2L: Label8;
    THUD2F: Text8Pt;
    THUD4F: Text8Pt;
    UDF4L: Label8;
    THUD3F: Text8Pt;
    UDF3L: Label8;
    Label821: Label8;
    SDDOverF: TCurrencyEdit;
    Bevel1: TBevel;
    Label823: Label8;
    cbSort2LF: TSBSComboBox;
    cbSortD: TBorCheck;
    CqNo: Text8Pt;
    TabSheet3: TTabSheet;
    GLPay1F: Text8Pt;
    Label89: Label8;
    Label818: Label8;
    GLPay1NameF: Text8Pt;
    Label824: Label8;
    Label825: Label8;
    GLPayAmt1: TCurrencyEdit;
    Label826: Label8;
    GLPay2F: Text8Pt;
    Label827: Label8;
    GLPay2NameF: Text8Pt;
    Label828: Label8;
    GLPayAmt2: TCurrencyEdit;
    THUD5F: Text8Pt;
    THUD7F: Text8Pt;
    THUD9F: Text8Pt;
    THUD6F: Text8Pt;
    THUD8F: Text8Pt;
    THUD10F: Text8Pt;
    UDF5L: Label8;
    UDF7L: Label8;
    UDF9L: Label8;
    UDF6L: Label8;
    UDF8L: Label8;
    UDF10L: Label8;
    JobCCDeptDefaultsLbl: TLabel;
    ACOurRef: Text8Pt;
    LinkCF: Text8Pt;
    ACFF: Text8Pt;
    CompF: Text8Pt;
    CurrF: TSBSComboBox;
    R1RValF: TCurrencyEdit;
    I1ExLab: Label8;
    I1EXRateF: TCurrencyEdit;
    Label83: Label8;
    Label82: Label8;
    Label814: Label8;
    Label815: Label8;
    AmtLab: Label8;
    Label87: Label8;
    Label88: Label8;
    Label810: Label8;
    Label84: Label8;
    Label85: Label8;
    GLMDC: Text8Pt;
    GLBankF: Text8Pt;
    Id3CCF: Text8Pt;
    Id3DepF: Text8Pt;
    I1YRef: Text8Pt;
    I1TransDateF: TEditDate;
    Label811: Label8;
    LCurrF: TSBSComboBox;
    bcVarianceF: TBorCheck;
    R1BaseF: TCurrencyEdit;
    R1Base2Lab: Label8;
    Label813: Label8;
    R1TPerF: TEditPeriod;
    NomDescF: Text8Pt;
    Label816: Label8;
    Label817: Label8;
    NomDescF2: Text8Pt;
    Label829: Label8;
    UDF12L: Label8;
    THUD12F: Text8Pt;
    UDF11L: Label8;
    THUD11F: Text8Pt;
    procedure FormCreate(Sender: TObject);
    procedure ACFFExit(Sender: TObject);
    procedure ACFFDblClick(Sender: TObject);
    procedure ACFFEnter(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure CurrFExit(Sender: TObject);
    procedure I1EXRateFExit(Sender: TObject);
    procedure Id3CCFExit(Sender: TObject);
    procedure GLBankFExit(Sender: TObject);
    procedure R1RValFExit(Sender: TObject);
    procedure I4JobCodeFExit(Sender: TObject);
    procedure I4JobAnalFExit(Sender: TObject);
    procedure I1TransDateFExit(Sender: TObject);
    procedure bcAllowSDiscFClick(Sender: TObject);
    procedure PageControl1Change(Sender: TObject);
    procedure TWClsBtnClick(Sender: TObject);
    procedure THUD1FExit(Sender: TObject);
    procedure THUD1FEntHookEvent(Sender: TObject);
    procedure TWPrevBtnClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure GLPay1FExit(Sender: TObject);
    procedure GLPayAmt1Enter(Sender: TObject);
    procedure GLPayAmt2Enter(Sender: TObject);
    procedure I1YRefChange(Sender: TObject);
    //GS 21/10/2011 ABSEXCH-11706: a copy of pauls user fields function
    procedure SetUDFields(UDDocHed  :  DocTypes);
    procedure DAddr5FExit(Sender: TObject);
    //AP : 23/02/2017 2017-R1 ABSEXCH-17054 : Calender in SRC Allocation wizard is not showing correctly when FY is not Jan-Dec
    function R1TPerFShowPeriod(Sender: TObject; const EPr: Byte): String;
    function R1TPerFConvDate(Sender: TObject; const IDate: String;
      const Date2Pr: Boolean): String;
  private
    { Private declarations }
    LastCtrlRec,
    AllocCtrlRec  :  MLocRec;

    bHelpContextInc, //NF: 12/04/06
    JustCreated,
    DuringActive,
    ForceACEdit,
    IgnoreAutoPost,
    InFormClose,
    FormProcess,
    FromTrans,
    WarnZero,
    WarnNeg,
    SalesMode     :  Boolean;

    BeenAECnt     :  Integer;

    //PR: 07/10/2013 MRD 1.1.17
    WasConsumer : Boolean;

    procedure SetFieldRO(EnabFlag,
                         VOMode  :  Boolean);

    procedure FormDesign;

    procedure SetWizCaption;

    Procedure ShutDown;

    procedure Display_Trans(Mode        :  Byte;
                            GlobalMode  :  Boolean);

    Procedure WMCustGetRec(Var Message  :  TMessage); Message WM_CustGetRec;

    procedure Link2Links(Mode  :  Byte);

    procedure OutWizTotals;

    procedure OutAllocWiz;

    procedure Form2AllocWiz;

    Function Confirm_Reset(ChooseAbort  :  Boolean)  :  Boolean;

    Procedure ChangePage(NewPage  :  Integer);

    procedure WarnLocked;

    procedure SetCurrStat;

    Function CheckGLCurr  :  Boolean;

    Function CheckAWCompleted(Edit  :  Boolean)  : Boolean;

    procedure StartAllocation;

    Function CheckChange  :  Boolean;

    Procedure TryFinishWizard; Override;

    procedure Show_AllocList;

    procedure HideChargePage;

    procedure SetHelpContextIDsForPage(bInc : boolean); // NF: 12/04/06

  public
    SRCInv  :  InvRec;
    
    { Public declarations }

    procedure Set_UpTransAlloc;

    Function GetPageCount  :  Integer; Override;
  end;

  Procedure Set_alSales(Flag1,Flag2  :  Boolean);


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
  SBSComp2,
  ComnUnit,
  ComnU2,
  SysU1,
  SysU3,
  CurrncyU,
  GenWarnU,
  AllcWrnU,
  LedgSupU,
  InvListU,
  InvLst2U,
  Event1U,
  Tranl1U,
  AlcItemU,

  {$IFDEF POST}
    AllocS2U,
  {$ENDIF}

  {$IFDEF JC}
    JChkUseU,
  {$ENDIF}

  ExThrd2U,

  {$IFDEF LTE}
    Brand,
  {$ENDIF}

  ThemeFix,

  ExWrap1U,
  AllocS1U,
  //GS 21/10/2011 ABSEXCH-11706: access to the new user defined fields interface
  CustomFieldsIntF,

  // CJS 2013-09-13 - ABSEXCH-13192 - add Job Costing to user profile rules
  PassWR2U,
  JobUtils,
  //PR: 02/10/2013 MRD 1.1.17
  ConsumerUtils;


{$R *.dfm}

Var
  alSales,
  alFromTrans  :  Boolean;

Procedure Set_alSales(Flag1,Flag2  :  Boolean);

Begin
  alSales:=Flag1;
  alFromTrans:=Flag2;

end;


procedure TAllocateWiz.SetFieldRO(EnabFlag,
                                  VOMode  :  Boolean);

Var
  Loop    :  Integer;
  ShowCol :  TColor;

Begin
  If VOMode then
    ShowCol:=clBtnFace
  else
    ShowCol:=clWindow;

  For Loop:=0 to ComponentCount-1 do
  Begin

    If (Components[Loop] is Text8Pt) then
    Begin
      If (Text8Pt(Components[Loop]).Tag=1) then
      Begin
        Text8Pt(Components[Loop]).ReadOnly:= VOMode;
        Text8Pt(Components[Loop]).TabStop:=Not VOMode;
        Text8Pt(Components[Loop]).Color:=ShowCol;
      end;
    end
      else
        If (Components[Loop] is TEditDate) then
        Begin
          If (TEditDate(Components[Loop]).Tag=1) then
          Begin
            TEditDate(Components[Loop]).ReadOnly:= VOMode;
            TEditDate(Components[Loop]).TabStop:=Not VOMode;
            TEditDate(Components[Loop]).Color:=ShowCol;
          end;
        end
        else
          If (Components[Loop] is TEditPeriod) then
          Begin
            If (TEditPeriod(Components[Loop]).Tag=1) then
            Begin
              TEditPeriod(Components[Loop]).ReadOnly:= VOMode;
              TEditPeriod(Components[Loop]).TabStop:=Not VOMode;
              TEditPeriod(Components[Loop]).Color:=ShowCol;
            end;
          end
          else
            If (Components[Loop] is TCurrencyEdit) then
            Begin
              If (TCurrencyEdit(Components[Loop]).Tag=1) then
              Begin
                TCurrencyEdit(Components[Loop]).ReadOnly:= VOMode;

                TCurrencyEdit(Components[Loop]).TabStop:=Not VOMode;
                TCurrencyEdit(Components[Loop]).Color:=ShowCol;
              end;
            end
            else
              If (Components[Loop] is TBorCheck) then
              Begin
                If (TBorCheck(Components[Loop]).Tag=1) then
                Begin
                  TBorCheck(Components[Loop]).Enabled:= Not VOMode;
                  TBorCheck(Components[Loop]).TabStop:=Not VOMode;

                end;
              end
              else
                If (Components[Loop] is TSBSComboBox) then
                Begin
                  If (TSBSComboBox(Components[Loop]).Tag=1) then
                  Begin
                    TSBSComboBox(Components[Loop]).ReadOnly:= VOMode;
                    TSBSComboBox(Components[Loop]).TabStop:=Not VOMode;
                    TSBSComboBox(Components[Loop]).Color:=ShowCol;
                  end;
              end;

  end; {Loop..}

end;


procedure TAllocateWiz.FormDesign;

Var
  ShowJCF,
  HideCC  :  Boolean;

Begin
  Label83.Visible:=FromTrans;
  ACOurRef.Visible:=FromTrans;
  bcVarianceF.Visible:=Not FromTrans;

  {Label819.Visible:=Not SalesMode;
  CQNo.Visible:=Not SalesMode;}

  Label812.Visible:=SalesMode;
  PayIF.Visible:=SalesMode;

  {If (SalesMode) then
  Begin
    Label812.Left:=Label819.Left;
    PayIF.Left:=CQNo.Left;
  end;}

  SetFieldRO(BOff,FromTrans);

  // CJS 2014-01-14 - ABSEXCH-14943 - Consumers - account code field width
  if Syss.ssConsumersEnabled then
    ACFF.Width := 184
  else
    ACFF.Width := 80;

  If (FromTrans) then
  Begin
    bcVarianceF.Visible:=BOff;
    bcAllowSDiscF.Visible:=BOff;
    Label821.Visible:=BOff;
    SDDOverF.Visible:=BOff;

    Label84.Visible:=BOff;
    GLBankF.Visible:=BOff;
    Label816.Visible:=BOff;
    NomDescF.Visible:=BOff;

    Label819.Visible:=BOff;
    CQNo.Visible:=BOff;
    Label812.Visible:=BOff;
    PayIF.Visible:=BOff;

  end;


  HideCC:=BOff;


  {$IFNDEF PF_On}

    HideCC:=BOn;

  {$ELSE}

    HideCC:=Not Syss.UseCCDep or FromTrans;
  {$ENDIF}

  Id3CCF.Visible:=Not HideCC;
  Id3DepF.Visible:=Not HideCC;
  Label810.Visible:=Not HideCC;

  ShowJCF:=(JBCostOn and SalesMode);

  I4JobCodeL.Visible:=ShowJCF;
  I4JobCodeF.Visible:=ShowJCF;
  I4JobAnalF.Visible:=ShowJCF;
  I4JAnalL.Visible:=ShowJCF;

  //GS 21/10/2011 ABSEXCH-11706: removed existing UDF setup code; replaced with calling pauls new method
  if SalesMode then
    SetUDFields(SRC)
  else
    SetUDFields(PPY);

  {$IFNDEF MC_On}
    Label815.Visible:=BOff;
    Label811.Visible:=BOff;
    CurrF.Visible:=BOff;
    LCurrF.Visible:=BOff;
    I1ExLab.Visible:=BOff;
    I1ExRateF.Visible:=BOff;
    R1Base2Lab.Visible:=BOff;
    R1BaseF.Visible:=BOff;
    bcVarianceF.Visible:=BOff;
  {$ENDIF}


  Label815.Caption:=DocCodes[DocSplit[SalesMode,2]]+Label815.Caption;

end;

//GS 21/10/2011 ABSEXCH-11706: a copy of pauls user fields function
procedure TAllocateWiz.SetUDFields(UDDocHed  :  DocTypes);
begin
{$IFDEF ENTER1}
// PKR. 24/03/2016. ABSEXCH-17383. Add handlers for UDFs 11 and 12. (Transaction Headers)
  EnableUDFs([UDF1L, UDF2L, UDF3L, UDF4L, UDF5L, UDF6L, UDF7L, UDF8L, UDF9L, UDF10L, UDF11L, UDF12L],
             [THUD1F, THUD2F, THUD3F, THUD4F, THUD5F, THUD6F, THUD7F, THUD8F, THUD9F, THUD10F, THUD11F, THUD12F],
             DocTypeToCFCategory(UDDocHed));
{$ENDIF}
end;

procedure TAllocateWiz.SetWizCaption;

Var
  CStr  :  Str50;

Begin
  If (Not FromTrans) then
    CStr:='Creation &'
  else
    CStr:='';

  Caption:=DocNames[DocSplit[SalesMode,2]]+' '+CStr+' '+Caption;

  If (CStr<>'') then
    CStr:=CStr+'& ';
    
  Label86.Caption:=DocNames[DocSplit[SalesMode,2]]+' '+CStr+Label86.Caption;

end;


Function TAllocateWiz.GetPageCount  :  Integer;

Begin
  Result:=2+Ord(TabSheet3.Visible);

end;

procedure TAllocateWiz.FormCreate(Sender: TObject);

Var
  LPr,LYr,n  :  Byte;

begin
  inherited;

  // MH 12/01/2011 v6.6 ABSEXCH-10548: Modified theming to fix problem with drop-down lists
  ApplyThemeFix (Self);

  //GS 21/10/2011 ABSEXCH-11706: adjusted the form height to accomodate the new UDEFs
  ClientHeight:=442; ClientWidth:=653;

  SalesMode:=alSales;
  FromTrans:=alFromTrans;
  InFormClose:=BOff; FormProcess:=BOff;

  WarnZero:=BOff;
  WarnNeg:=BOff;

  BeenAECnt:=0;
  DuringActive:=BOff; JustCreated:=BOn;

  ForceACEdit:=BOff; IgnoreAutoPost:=BOff;

  {Sanjay Sonani 25/02/2016 2016-R2
   ABSEXCH-16165:Sales Receipt & Purchase Payments Wizard,
               if you shift+tab from the G/L Control Account box the
               screen moves to step 2.
  - Set Tabsheet2 and Tabsheet3 visible false to make Next Button focus properly.}
  For n:=0 to PageControl1.PageCount-1 do {Hide Tabs}
  With PageControl1 do
  Begin
    If (Assigned(Pages[n])) then
    Begin
      Pages[n].TabVisible:=BOff;
      Pages[n].Visible:=BOff;
    end;

  end; {Loop}

  PageControl1.ActivePage:=TabSheet1;


  {$IFDEF MC_On}

    Set_DefaultCurr(CurrF.Items,BOff,BOff);
    Set_DefaultCurr(CurrF.ItemsL,BOff,BOn);
    CurrF.ItemIndex:=0;

    Set_DefaultCurr(LCurrF.Items,BOn,BOff);
    Set_DefaultCurr(LCurrF.ItemsL,BOn,BOn);
    LCurrF.ItemIndex:=0;

  {$ENDIF}

  LPr:=GetLocalPr(0).CPr;
  LYr:=GetLocalPr(0).CYr;

  R1TPerF.InitPeriod(LPr,LYr,BOn,BOn);

  I1TransDateF.DateValue:=Today;

  cbSortLF.ItemIndex:=0;

  {$IFDEF LTE}
    {$IFDEF DBD}
      InitBranding(SetDrive); // Not Necessary at run time taken from Main Co direct not data set directory
    {$ENDIF}

    With Branding do
      If (BrandingFileExists ('EntSplash')) then
        With BrandingFile('EntSplash') Do
    Begin

      If Image1.Visible Then

      Begin

        // Get appropriate bitmap from branding file

        ExtractImageCD (Image1, 'ALLOWIZ');


      end;
    end; {With..}
  {$ENDIF}


  SetWizCaption;

  FormDesign;

  //PR: 07/10/2013 MRD 1.1.17 Set consumer indicator appropriately
  If (FromTrans) then {Poulate the transaction details}
  Begin  //Set to global cust type - coming from customer ledger so it will be populated correctly
    SRCInv:=Inv;
    WasConsumer := IsConsumer(Cust);
  end
  else //set to false until we exit a/c field
    WasConsumer := False;

  bHelpContextInc := FALSE; //NF: 12/04/06
  SetHelpContextIDsForPage(FALSE);// NF: 12/04/06
  SetHelpContextIDsForPage(TRUE);// NF: 12/04/06

end;

procedure TAllocateWiz.FormClose(Sender: TObject;
  var Action: TCloseAction);

Var
  OrigAC  :  Str10;

begin
  inherited;

  If (Not FormProcess) and (Not InFormClose) then
  Begin
    InFormClose:=BOn;

    If (AllocCtrlRec.AllocCRec.arcLocked<>2) then {Prev locked}
    Begin
      OrigAC:=AllocCtrlRec.AllocCRec.arcCustCode;

      Alloc_CtrlPut(MLocF,MLK,AllocCtrlRec,nil,1);

      {* Unlock ctrl record *}

      AllocCtrlRec.AllocCRec.arcCustCode:=OrigAC;

      Alloc_CtrlPut(MLocF,MLK,AllocCtrlRec,nil,0);
    end;

  end;
end;



procedure TAllocateWiz.FormActivate(Sender: TObject);
begin
  inherited;
  If (JustCreated) then
  Begin
    JustCreated:=BOff;

    MDI_ForceParentBKGnd(BOn);

    DuringActive:=BOn;

    If (ACFF.CanFocus) and (ACFF.Text='') then
    Begin
      ACFF.SetFocus;

      If (GetMaxColors(Application.MainForm.Canvas.Handle) <2) then
      Begin
        FieldNextFix(Handle,ActiveControl,CompF); {* Added so that qty is auto selected *}
        Inc(BeenAECnt);
      end
      else
        BeenAECnt:=4;

    end
    else
      If (I1TransDateF.CanFocus) and (ACFF.Text<>'') then
      Begin
        I1TransDateF.SetFocus;

        FieldNextFix(Handle,ActiveControl,CompF); {* Added so that qty is auto selected *}


      end;

    DuringActive:=BOff;

  end;

end;

Procedure TAllocateWiz.ShutDown;

Begin
  LastValueObj.UpdateAllLastValues(Self);

  FormProcess:=BOn;

  PostMessage(Self.Handle,WM_Close,0,0);

end;


{ ======= Link to Trans display ======== }

procedure TAllocateWiz.Display_Trans(Mode        :  Byte;
                                     GlobalMode  :  Boolean);

Var
  DispTrans  :  TFInvDisplay;
  KeyInv     :  Str255;

Begin

  DispTrans:=TFInvDisplay.Create(Application.MainForm);

    try

      
      With DispTrans do
      Begin
        LastDocHed:=Inv.InvDocHed;

        If (Inv.Settled=0.0) then
        Begin
          KeyInv:=Inv.OurRef;

          Find_Rec(B_GetEq,F[InvF],InvF,RecPtr[InvF]^,InvOurRefK,KeyInv);

        end;

        If ((LastFolio<>Inv.FolioNum) or (Mode<>100)) and ((GlobalMode)) then
          {Display_Trans(Mode,LInv.FolioNum,BOff,(Mode<>100));}
          Display_Trans(100-(98*Ord(Inv.Settled=0.0)),Inv.FolioNum,BOff,BOff);

      end; {with..}

    except
      DispTrans.Free;

    end;

end;

Procedure TAllocateWiz.WMCustGetRec(Var Message  :  TMessage);


Begin


  With Message do
  Begin

    {If (Debug) then
      DebugForm.Add('Mesage Flg'+IntToStr(WParam));}

    Case WParam of
      1  :  CurrFExit(Nil);

      5  :  If (Not IgnoreAutoPost) then
              TWPrevBtnClick(TWNextBtn)
            else
              IgnoreAutoPost:=BOff;

      55,56
          :  Begin

               Set_BackThreadMVisible(BOn);

               Begin
                 TWClsBtn.Enabled:=BOn;
                 Show_AllocList;
               end;

               Set_BackThreadMVisible(BOff);

               ShutDown;
             end; {Start List}

      65,66
          :  Begin {Lock and un lock ctrl during scan}
               Alloc_CtrlPut(MLocF,MLK,AllocCtrlRec,Nil,Ord(WParam=66));


             end;
      67  :  Begin
               Set_BackThreadMVisible(BOn);

               If (LParam=1) then
               Begin
                 Display_Trans(100,BOn);

                 If (Copy(Self.Owner.Name,1,6)='Daybk1') then {Refresh list}
                   PostMessage(TForm(Self.Owner).Handle,WM_CustGetRec,100,0);
               end;

               Set_BackThreadMVisible(BOff);
               ShutDown;
             end;

      
    end; {Case..}

  end;
  Inherited;
end;

procedure TAllocateWiz.Link2Links(Mode  :  Byte);

Var
  FoundCode  :  Str10;
  FoundLong  :  LongInt;
Begin
  If (Mode In [0,1]) then
  Begin
    If (Cust.CustCode<>AllocCtrlRec.AllocCRec.arcCustCode) then
      Global_GetMainRec(CustF,AllocCtrlRec.AllocCRec.arcCustCode);

    CompF.Text:=Cust.Company;
  end;

  If (Mode In [0,2,4]) and (GLBankF.Text<>'0') then
  Begin
    FoundCode:=GLBankF.Text;

    If GetNom(Self,FoundCode,FoundLong,-1) then
      NomDescF.Text:=Nom.Desc;
  end;

  If (Mode In [0,3,4]) and (GLMDC.Text<>'0') then
  Begin
    FoundCode:=GLMDC.Text;

    If GetNom(Self,FoundCode,FoundLong,-1) then
      NomDescF2.Text:=Nom.Desc;
  end;

  If (Mode In [0,4,5]) and (GLPay1F.Text<>'') then
  Begin
    FoundCode:=GLPay1F.Text;

    If GetNom(Self,FoundCode,FoundLong,-1) then
      GLPay1NameF.Text:=Nom.Desc;
  end;


  If (Mode In [0,4,6]) and (GLPay2F.Text<>'') then
  Begin
    FoundCode:=GLPay2F.Text;

    If GetNom(Self,FoundCode,FoundLong,-1) then
      GLPay2NameF.Text:=Nom.Desc;
  end;

end;


procedure TAllocateWiz.OutWizTotals;
Var
  UOR  :  Byte;
begin
  With AllocCtrlRec.AllocCRec do
  Begin
    Form2AllocWiz;
    UOR:=fxUseORate(BOff,BOn,arcCXRate,0,arcPayCurr,0);

    R1BaseF.Value:=Conv_TCurr(arcOwnTransValue,XRate(arcCXRate,BOff,arcPayCurr),arcPayCurr,UOR,BOff);
  end;
end;




procedure TAllocateWiz.OutAllocWiz;

begin
  With AllocCtrlRec.AllocCRec do
  Begin
    //PR: 07/10/2013 MRD Set contents of a/c code field appropriately for trader type
    if (Trim(ACFF.Text) = '') and (Trim(arcCustCode) <> '') then
    begin
      if IsConsumer(Cust) then
      begin
        ACFF.Text := Trim(Cust.acLongACCode);
        WasConsumer := True; //Set consumer indicator
      end
      else
      begin
        ACFF.Text:=arcCustCode;
        WasConsumer := False; //Set consumer indicator
      end;
    end;

    ACOurRef.Text:=arcOurRef;

    I1TransDateF.DateValue:=arcTransDate;

    R1TPerF.InitPeriod(arcTagRunPr,arcTagRunYr,BOn,BOn);

    I1YRef.Text:=arcYourRef;

    cbSortD.Checked:=arcSortD;

    If (arcPayCurr>0) then
      CurrF.ItemIndex:=Pred(arcPayCurr)
    else
      CurrF.ItemIndex:=0;

    LCurrF.ItemIndex:=arcInvCurr;

    I1EXRateF.Value:=XRate(arcCXRate,BOff,arcPayCurr);

    Id3CCF.Text:=arcCCDep[BOn];
    Id3DepF.Text:=arcCCDep[BOff];
    bcVarianceF.Checked:=arcIncVar;

    GLBankF.Text:=Form_Int(arcBankNom,0);

    GLPay1F.Text:=Form_BInt(arcCharge1GL,0);
    GLPay2F.Text:=Form_BInt(arcCharge2GL,0);

    GLMDC.Text:=Form_BInt(arcCtrlNom,0);


    Link2Links(0);

    R1RValF.Value:=arcOwnTransValue;

    If (Not FromTrans) then
    Begin
      If (Not arcAutoTotal) then
      Begin
        GLPayAmt1.CurrencySymb:=PSymb(arcPayCurr);
        GLPayAmt2.CurrencySymb:=PSymb(arcPayCurr);

        GLPayAmt1.Value:=arcCharge1Amt;
        GLPayAmt2.Value:=arcCharge2Amt;
      end;

      If (arcAutoTotal) or (arcTotal<>0.0) then
      Begin
        If (arcAutoTotal) then
        With AmtLab do
        Begin
          Caption:='Calculated Amount';
          Font.Style:=[fsBold];
        end;

        With R1RValF do
        Begin
          ReadOnly:=BOn;
          TabStop:=BOff;
          color:=clBtnFace;
        end;

        With I1ExRateF do
        Begin
          ReadOnly:=BOn;
          TabStop:=BOff;
          color:=clBtnFace;
        end;

        With CurrF do
        Begin
          Enabled:=BOff;
          TabStop:=BOff;
          color:=clBtnFace;
        end;

        With LCurrF do
        Begin
          Enabled:=BOff;
          TabStop:=BOff;
          color:=clBtnFace;
        end;

      end
      else
      Begin
      
        With AmtLab do
        Begin
          Caption:='Amount';
          Font.Color:=clWindowText;
          Font.Style:=[];
        end;

        With R1RValF do
        Begin
          ReadOnly:=BOff;
          TabStop:=BOn;
          color:=clWindow;
        end;

        With CurrF do
        Begin
          Enabled:=BOn;
          TabStop:=BOn;
          color:=clWindow;
        end;

        With LCurrF do
        Begin
          Enabled:=BOn;
          TabStop:=BOn;
          color:=clWindow;
        end;

        With I1ExRateF do
        Begin
          color:=clWindow;
        end;

        SetCurrStat;

      end;
    end;

    If (Not SalesMode) then
      CQNo.Text:=arcChequeNo2;

    PayIf.Text:=arcSRCPIRef;
    cbSortLF.ItemIndex:=arcSortBy;
    cbSort2LF.ItemIndex:=arcSort2By;
    bcAllowSDiscF.Checked:=arcIncSDisc;
    SDDOverF.Value:=arcSDDaysOver;

    bcAllowSDiscFClick(nil);


    I4JobCodeF.Text:=arcJobCode;
    I4JobAnalF.Text:=arcAnalCode;
    THUD1F.Text:=arcUD1;
    THUD2F.Text:=arcUD2;
    THUD3F.Text:=arcUD3;
    THUD4F.Text:=arcUD4;
    //GS 21/10/2011 ABSEXCH-11706: put customisation values into text boxes
    THUd5F.Text:=arcUD5;
    THUd6F.Text:=arcUD6;
    THUd7F.Text:=arcUD7;
    THUd8F.Text:=arcUD8;
    THUd9F.Text:=arcUD9;
    THUd10F.Text:=arcUD10;
// PKR. 24/03/2016. ABSEXCH-17383. Added handlers for UDFs 11 and 12. (Transaction Headers)
    THUd11F.Text:=arcUD11;
    THUd12F.Text:=arcUD12;

    DAddr1F.Text:=arcDelAddr[1];
    DAddr2F.Text:=arcDelAddr[2];
    DAddr3F.Text:=arcDelAddr[3];
    DAddr4F.Text:=arcDelAddr[4];
    DAddr5F.Text:=arcDelAddr[5];

    OutWizTotals;

  end;


end;


procedure TAllocateWiz.Form2AllocWiz;

Var
  UOR  :  Byte;
  
begin
  With AllocCtrlRec.AllocCRec do
  Begin
    //PR: 07/10/2013 MRD 1.1.17 Set a/c code in Alloc record appropriately for customer/consumer
    if WasConsumer then
      arcCustCode := Cust.CustCode
    else
      arcCustCode:=ACFF.Text;
      
    arcSalesMode:=SalesMode;
    arcTransDate:=I1TransDateF.DaTeValue;

    R1TPerF.InitPeriod(arcTagRunPr,arcTagRunYr,BOff,BOff);

    arcYourRef:=I1YRef.Text;

    arcSortD:=cbSortD.Checked;

    {$IFDEF MC_On}
      If (CurrF.ItemIndex>=0) then
        arcPayCurr:=Succ(CurrF.ItemIndex);

      If (LCurrF.ItemIndex>=0) then
        arcInvCurr:=LCurrF.ItemIndex;

    {$ELSE}
      arcPayCurr:=0; arcInvCurr:=0;
    {$ENDIF}

    arcCXrate[UseCoDayRate]:=I1ExRateF.Value;
    arcCCDep[BOn]:=Id3CCF.Text;
    arcCCDep[BOff]:=Id3DepF.Text;
    arcIncVar:=bcVarianceF.Checked;
    arcBankNom:=IntStr(GLBankF.Text);
    arcCtrlNom:=IntStr(GLMDC.Text);

    arcCharge1GL:=IntStr(GLPay1F.Text);
    arcCharge2GL:=IntStr(GLPay2F.Text);

    arcCharge1Amt:=GLPayAmt1.Value;
    arcCharge2Amt:=GLPayAmt2.Value;


    If (Not arcAutoTotal) and (Not FromTrans) then
    Begin
      arcOwnTransValue:=R1RValF.Value;

      UOR:=fxUseORate(BOff,BOn,arcCXRate,0,arcPayCurr,0);

      arcTransValue:=Round_Up(Conv_TCurr(arcOwnTransValue,XRate(arcCXRate,BOff,arcPayCurr),arcPayCurr,UOR,BOff),2);
    end;


    arcChequeNo2:=CQNo.Text;

    arcSRCPIRef:=PayIf.Text;
    arcSortBy:=cbSortLF.ItemIndex;
    arcSort2By:=cbSort2LF.ItemIndex;

    arcIncSDisc:=bcAllowSDiscF.Checked;
    arcSDDaysOver:=Round(SDDOverF.Value);

    arcJobCode:=I4JobCodeF.Text;
    arcAnalCode:=I4JobAnalF.Text;
    arcUD1:=THUD1F.Text;
    arcUD2:=THUD2F.Text;
    arcUD3:=THUD3F.Text;
    arcUD4:=THUD4F.Text;
    //GS 21/10/2011 ABSEXCH-11706: write udef field values into customisation object
    arcUD5:=THUd5F.Text;
    arcUD6:=THUd6F.Text;
    arcUD7:=THUd7F.Text;
    arcUD8:=THUd8F.Text;
    arcUD9:=THUd9F.Text;
    arcUD10:=THUd10F.Text;
// PKR. 24/03/2016. ABSEXCH-17383. Add handlers for UDFs 11 and 12. (Transaction Headers)
    arcUD11:=THUd11F.Text;
    arcUD12:=THUd12F.Text;

    arcDelAddr[1]:=DAddr1F.Text;
    arcDelAddr[2]:=DAddr2F.Text;
    arcDelAddr[3]:=DAddr3F.Text;
    arcDelAddr[4]:=DAddr4F.Text;
    arcDelAddr[5]:=DAddr5F.Text;

    arcUseOsNdx:=UseV5OsNdx;
  end;
end;


procedure TAllocateWiz.PageControl1Change(Sender: TObject);
Var
  NewIndex  :  Integer;


begin
  SetHelpContextIDsForPage(FALSE);// NF: 12/04/06
  SetHelpContextIDsForPage(TRUE);// NF: 12/04/06

  If (Sender is TPageControl) then
  begin
    With Sender as TPageControl do
    Begin
      NewIndex:=pcLivePage(Sender);
      {Sanjay Sonani 25/02/2016 2016-R2
       ABSEXCH-16165:Sales Receipt & Purchase Payments Wizard,
	                   if you shift+tab from the G/L Control Account box the
                     screen moves to step 2.
       - Set Tabsheet2 and Tabsheet3 visible false to make Next Button focus properly.}
      if (NewIndex = 0) then
      begin
        TabSheet2.Visible := BOff;
        TabSheet3.Visible := BOff;
      end
      //TW 15/11/2011: Defocus next button and set focus to correct control
      else if(NewIndex = 1) and (CqNo.Visible) then
      begin
        self.DefocusControl(TWPrevBtn, true);
        self.ActiveControl := nil;
        CQNo.SetFocus;

        {SS 6/04/2016 2016-R2
         ABSEXCH-13454:Allocation Wizard - Step 3 Disappears If You Go Back From Step 3 to 2
         - The tab order needs to be switched to maintain proper behaviour for Tabsheet2 }
        TWPrevBtn.TabOrder := 1;
        TWNextBtn.TabOrder := 0;
      end
      else if (newIndex = 2) then
      begin
        self.DefocusControl(TWPrevBtn, true);
        self.ActiveControl := nil;
        GLPay1F.SetFocus;
        
        {SS 6/04/2016 2016-R2
        ABSEXCH-13454:Allocation Wizard - Step 3 Disappears If You Go Back From Step 3 to 2
        - The tab order needs to be switched to maintain proper behaviour for Tabsheet3}
        TWPrevBtn.TabOrder := 0;
        TWNextBtn.TabOrder := 1;
      end
    end;
  end; {If..}
end;

Procedure TAllocateWiz.ChangePage(NewPage  :  Integer);


Begin

  If (Current_Page<>NewPage) then
  With PageControl1 do
  If (Pages[NewPage].TabVisible) then
  Begin
    ActivePage:=Pages[NewPage];

    PageControl1Change(PageControl1);
  end; {With..}
end; {Proc..}


procedure TAllocateWiz.TWClsBtnClick(Sender: TObject);
begin
  inherited;
  {* Reset ctrl record *}


end;


Function TAllocateWiz.Confirm_Reset(ChooseAbort  :  Boolean)  :  Boolean;

Var
  GenStr,
  GenStr2,
  GenStr3  :  str255;

Begin

  With AllocCtrlRec.AllocCRec do
  Begin
    If (arcOpoName<>EntryRec^.LogIn) then
      GenStr:=Trim(arcOpoName)+' ('+Trim(arcWinLogIn)+')'
    else
      GenStr:='you';

    GenStr:=GenStr+'. On '+POutDate(arcStartDate)+' at '+arcStartTime+'.';

    If (arcFromTrans) then
    Begin
      GenStr2:=DocNames[DocSplit[arcSalesMode,2]]+' '+arcOurRef;

      If (Not FromTrans) then
        SRCInv.OurRef:=arcOurRef;
    end
    else
      GenStr2:='this account';

    If (ChooseAbort) then
      GenStr3:='However, this allocation cannot be used with '+SRCInv.OurRef+'.'+#13+
               'Choose &New to start a new allocation - losing any allocation details, or &Cancel to abandon this allocation.'
    else
      GenStr3:='Choose &OK to continue with the stored allocation, or &New to start a new one - losing any allocation details.';

    Result:=(CustomDlgNew(Application.MainForm,'Please Note','Incomplete allocation',
                                 'A previous allocation has been stored for '+GenStr2+' by '+GenStr+#13+#13+
                                 GenStr3,
                                 mtConfirmation,
                                 [mbOK,mbCancel],2-Ord(ChooseAbort))=mrOK);

  end;

end;


procedure TAllocateWiz.WarnLocked;

Begin
  With AllocCtrlRec.AllocCRec do
  Begin

    CustomDlg(Application.MainForm,'Please Note','Allocation in Progress',
                                 'An allocation is currently in progress for this account by '+Trim(arcOpoName)+
                                 ' ('+Trim(arcWinLogIn)+'). On '+POutDate(arcStartDate)+' at '+arcStartTime+'.',
                                 mtInformation,
                                 [mbOK]);
  end; {With..}
end;

procedure TAllocateWiz.ACFFDblClick(Sender: TObject);
begin
  inherited;
  //HV 05/02/2016 2016-R1 ABSEXCH-16556: - Double click to drill down not working wtihout exit ACFF text
  if WasConsumer then
  begin
    if Trim(Cust.acLongACCode) <> Trim(acff.Text) then
      ACFFExit(ACFF);
  end
  else
    LinkCF.Text:=ACFF.Text;
  LinkCF.DblClick;

end;

procedure TAllocateWiz.ACFFEnter(Sender: TObject);
begin
  inherited;
  
  If (Not JustCreated) then
    Inc(BeenAECnt);


end;


procedure TAllocateWiz.ACFFExit(Sender: TObject);
Var
  FoundCode  :  Str20;

  WTrig,
  FoundOk,
  ChangeFMode,
  AltMod     :  Boolean;

  n          :  Byte;

begin


  If (Sender is Text8pt) then
  With (Sender as Text8pt) do
  Begin
    AltMod:=(Modified or ForceACEdit);

    ChangeFMode:=BOff;

    {$IFDEF CU}
      If (Not ReadOnly) then
      Begin
        FoundCode:=Text;

        //Text:=TextExitHook(1000,100,Trim(Text),ExLocal);

        AltMod:=(AltMod or (FoundCode<>Text));
      end;
    {$ENDIF}

    FoundCode:=Strip('B',[#32],Text);



    If ((AltMod) or (FoundCode='')) and (ActiveControl<>TWClsBtn) and (Not DuringActive) and (BeenAECnt>3) then
    Begin

      StillEdit:=BOn;

      ForceACEdit:=BOff;

      //PR: 07/10/2013 MRD 1.1.17 Set consumer prefix if we previously had a consumer
      if WasConsumer then
      begin
        if Copy(FoundCode, 1, 1) <> CONSUMER_PREFIX then
          FoundCode := CONSUMER_PREFIX + FoundCode;
      end;


      FoundOk:=(GetCust(Self,FoundCode,FoundCode,SalesMode,0));

      {$IFDEF JC}
        {$IFDEF PF_On}
           If (FoundOK) and (JBCostOn) and (Not SalesMode) and (Not FromTrans) then
             FoundOk:=Not Cert_Expired(FoundCode,Today,BOn,BOn);
        {$ENDIF}
      {$ENDIF}


      If (FoundOk) then {* Credit Check *}
      Begin
        //HV 05/02/2016 2016-R1 ABSEXCH-16556: - Double click to drill down not working
    		LinkCF.Text:=FoundCode;

        SendToObjectCC(FoundCode,0);

        FoundOk:=Alloc_CtrlGet(SalesMode,FoundCode,AllocCtrlRec,Nil,1);

        TWNextBtn.Enabled:=BOn;

        If (FoundOk) then
        With AllocCtrlRec.AllocCRec do
        Begin
          LastCtrlRec:=AllocCtrlRec;

          If (arcLocked=1) then
          Begin
            ChangeFMode:=(arcFromTrans and Not FromTrans);
            {If we are going from a transaction mode to a creation mode, either force it through as a new allocation, or abandon}

            arcForceNew:=Not Confirm_Reset(ChangeFMode);

            If (arcForceNew and Not ChangeFMode) or (Not arcForceNew and ChangeFMode) then {Reset values}
            Begin
              arcFromTrans:=FromTrans;
              arcForceNew:=BOn;
              
              Init_AllocCtrl(AllocCtrlRec);

            end
            else
              If (ChangeFMode) then
              Begin
                Text:='';

                PostMessage(Self.Handle,WM_Close,0,0);

                Exit;
              end
              else
                If (Not arcForceNew) then {Refresh use who has lock even though it originated from someone else}
                Begin
                  Init_AllocCtrlUser(AllocCtrlRec);
                    {SS 6/04/2016 2016-R2
                  	 ABSEXCH-10408: Sales Receipt and allocation wizard. When you populate the
                     amount to be allocated within the Amount field on Step 1, at this point can
                     the number of steps change to reflect correctly. i.e ratehr than show step
                     1 of 2, show step 1 of 3? }
                  AllocCtrlRec.AllocCRec.arcAutoTotal:=R1RValF.Value = 0;
                  HideChargePage;
                  {SS 8/04/2016 2016-R2 ABSEXCH-10408 - Make Tabsheet3 visible false so that tab order behaviour works properly.}
                  if PageControl1.ActivePage = TabSheet1 then
                    TabSheet3.Visible := False;
                end;

          end
          else
          Begin
            FoundOk:=(arcLocked<>2);

            If (Not FoundOk) then
              WarnLocked;

            TWNextBtn.Enabled:=FoundOk;

          end;

          If (FoundOk) then
          Begin

            OutAllocWiz;

            //PR: 07/10/2013 MRD Set contents of a/c code field appropriately for trader type
            if IsConsumer(Cust) then
            begin
              Text := Trim(Cust.acLongACCode);
              WasConsumer := True; //Set consumer indicator
            end
            else
            begin
              Text:=FoundCode;
              WasConsumer := False; //Set consumer indicator
            end;

            If (arcLocked=0) then
              PostMessage(Self.Handle,WM_CustGetRec,1,0)
            else
              SetCurrStat;
          end;



        end;
      end;

      If (Not FoundOk) then
      Begin
        SetFocus;
        ForceACEdit:=BOn;
      end;
    end;
  end; {With..}

end; {Proc..}

procedure TAllocateWiz.I1TransDateFExit(Sender: TObject);
begin
  inherited;
  {$B-}
  If (Syss.AutoPrCalc) and (ActiveControl<>TWClsBtn) and (AllocCtrlRec.AllocCRec.arcLocked=0) and (I1TransDateF.Modified) then  {* Set Pr from input date *}
  {$B+}
  With AllocCtrlRec.AllocCRec, CurrF do
  Begin
    Form2AllocWiz;

    Date2Pr(arcTransDate,arcTagRunPr,arcTagRunYr,nil);

    OutAllocWiz;
  end;

end;

procedure TAllocateWiz.SetCurrStat;

Begin
  With AllocCtrlRec.AllocCRec do
  Begin
    I1EXRateF.ReadOnly:=(SyssGCuR^.GhostRates.TriEuro[arcPayCurr]<>0) or (arcPayCurr=1) or (Not CanEditTriEuro(arcPayCurr)) or (Not UseCoDayRate);

    I1ExRateF.TabStop:=Not I1EXRateF.ReadOnly;
  end; {With..}
end;

procedure TAllocateWiz.CurrFExit(Sender: TObject);
begin
  inherited;
  {$IFDEF MC_On}
     If (ActiveControl<>TWClsBtn) then
     With AllocCtrlRec.AllocCRec, CurrF do
     If (Modified) or (Not Assigned(Sender)) then
     Begin
       arcPayCurr:=Succ(CurrF.ItemIndex);

       {If (Not CheckGLCurr) and (CanFocus) then
         SetFocus
       else}
         Begin
           arcCXrate:=SyssCurr.Currencies[arcPayCurr].CRates;
           arcCXrate[BOff]:=0;

           I1EXRateF.Value:=XRate(arcCXRate,BOff,arcPayCurr);

           SetCurrStat;

           OutWizTotals;
         end;

     end;
  {$ENDIF}
end;

procedure TAllocateWiz.I1EXRateFExit(Sender: TObject);
begin
  inherited;

  OutWizTotals;
end;

procedure TAllocateWiz.Id3CCFExit(Sender: TObject);
Var
  FoundCode  :  Str20;

  FoundOk,
  AltMod     :  Boolean;

  IsCC       :  Boolean;


begin

  If (Sender is Text8pt) then
  With (Sender as Text8pt) do
  Begin
    FoundCode:=Name;

    IsCC:=Match_Glob(Sizeof(FoundCode),'CC',FoundCode,FoundOk);

    AltMod:=Modified;

    FoundCode:=Strip('B',[#32],Text);

    If ((AltMod) or (FoundCode='')) and (ActiveControl<>TWClsBtn) and (Syss.UseCCDep)  then
    Begin

      StillEdit:=BOn;

      FoundOk:=(GetCCDep(Self,FoundCode,FoundCode,IsCC,2));


      If (FoundOk) then
      Begin

        StillEdit:=BOff;

        Text:=FoundCode;


      end
      else
      Begin

        SetFocus;
      end; {If not found..}
    end
    else
      If (AltMod) and (FoundCode='') then
        Text:='';

  end; {with..}
end;


procedure TAllocateWiz.GLBankFExit(Sender: TObject);
Var
  FoundCode  :  Str20;

  FoundOk,
  FailOk,
  AltMod,
  MDCFlg     :  Boolean;
  FoundLong  :  LongInt;
begin
  MDCFlg:=(Sender=GLMDC);
  FoundOk:=BOff; FailOk:=BOff;

  If (Sender is Text8pt) then
  With (Sender as Text8pt) do
  Begin
    AltMod:=Modified;

    If (Not MDCFlg) then
      FoundCode:=Strip('B',[#32],Text)
    else
      FoundCode:=Text;

    If ((AltMod) or (FoundCode='')) and (ActiveControl<>TWClsBtn) and ((FoundCode<>'') or (Not MDCFlg)) then
    Begin
      StillEdit:=BOn;

      {$IFDEF LTE}
        If (Not MDCFlg) then
          FoundOk:=(GetNom(Self,FoundCode,FoundLong,11))
        else
          FoundOk:=(GetNom(Self,FoundCode,FoundLong,2+(77*Ord(MDCFlg))));
     {$ELSE}
        FoundOk:=(GetNom(Self,FoundCode,FoundLong,2+(77*Ord(MDCFlg))));
      {$ENDIF}

      If (FoundOk) then
      Begin
        StillEdit:=BOff;
        Text:=Form_Int(FoundLong,0);

        {$B-}
        If (Nom.DefCurr<>0) and (CurrF.ItemIndex<>Pred(Nom.DefCurr)) then
        {$B+}
        Begin
          CurrF.ItemIndex:=Pred(Nom.DefCurr);
          PostMessage(Self.Handle,WM_CustGetRec,1,0);
        end;

        Link2Links(2+Ord(MDCFlg));
      end
      else
      Begin
        FailOk:=BOn;
        SetFocus;
      end; {If not found..}
    end;

    If (Not FoundOk) and (AltMod) and (FoundCode='') then
    Begin
      If (MDCFlg) then
        NomDescF2.Text:=''
      else
        NomDescF.Text:='';
    end;
  end; {with..}

  //TW 15/11/2011: Fix so second tab registers next button event
  if (self.ActiveControl = GLMDC) then
   IgnoreAutoPost := false;

  {SS 22/03/2016 2016-R2 
   ABSEXCH-16165:Sales Receipt & Purchase Payments Wizard, moving onto screen 2 without clicking next.} 
   If (Not FailOk) and (MDCFlg) and (ActiveControl<>TWNextBtn) and ((ActiveControl.TabOrder >= GLMDC.TabOrder) or (ActiveControl.Parent <> GLMDC.Parent)) then
    PostMessage(Self.Handle,WM_CustGetRec,5,0); //
end;

procedure TAllocateWiz.GLPay1FExit(Sender: TObject);
Var
  FoundCode  :  Str20;

  FoundOk,
  FailOk,
  AltMod,
  MDCFlg     :  Boolean;

  FoundLong  :  LongInt;


begin
  MDCFlg:=(Sender=GLPay2F);

  FoundOk:=BOff; FailOk:=BOff;

  If (Sender is Text8pt) then
  With (Sender as Text8pt) do
  Begin
    AltMod:=Modified;

    FoundCode:=Strip('B',[#32],Text);

    If ((AltMod) or (FoundCode='')) and (ActiveControl<>TWClsBtn) and (FoundCode<>'') then
    Begin

      StillEdit:=BOn;

      FoundOk:=(GetNom(Self,FoundCode,FoundLong,2));


      If (FoundOk) then
      Begin

        StillEdit:=BOff;

        Text:=Form_Int(FoundLong,0);


        Link2Links(5+Ord(MDCFlg));

      end
      else
      Begin
        FailOk:=BOn;
        SetFocus;
      end; {If not found..}
    end;


    If (Not FoundOk) and (AltMod) and (FoundCode='') then
    Begin
      If (MDCFlg) then
        GLPay2NameF.Text:=''
      else
        GLPay1NameF.Text:='';
    end;
  end; {with..}

end;

procedure TAllocateWiz.GLPayAmt1Enter(Sender: TObject);
begin
  inherited;

  GLPayAmt1.ReadOnly:=(GLPay1F.Text='');

end;


procedure TAllocateWiz.GLPayAmt2Enter(Sender: TObject);
begin
  inherited;

  GLPayAmt2.ReadOnly:=(GLPay2F.Text='');

end;


procedure TAllocateWiz.R1RValFExit(Sender: TObject);
begin
  inherited;

  OutWizTotals;
  {SS 6/04/2016 2016-R2
	 ABSEXCH-10408: Sales Receipt and allocation wizard. When you populate the
   amount to be allocated within the Amount field on Step 1, at this point can
   the number of steps change to reflect correctly. i.e ratehr than show step
   1 of 2, show step 1 of 3? }
  AllocCtrlRec.AllocCRec.arcAutoTotal := R1RValF.Value = 0;
  if not AllocCtrlRec.AllocCRec.arcAutoTotal then
    Form2AllocWiz;
  HideChargePage;
  
  {SS 8/04/2016 2016-R2 ABSEXCH-10408 - Make Tabsheet3 visible false so that tab order behaviour works properly.}
  if PageControl1.ActivePage = TabSheet1 then
    TabSheet3.Visible := False;
end;


Function TAllocateWiz.CheckGLCurr  :  Boolean;

Var
  InvR  :  InvRec;
  LId   :  Idetail;
  mbRet :  Word;

Begin
  Result:=BOn;

  Blank(InvR,Sizeof(InvR));
  Blank(LId,Sizeof(LId));

  {$IFDEF MC_On}
     With LId do
     Begin
       InvR.InvDocHed:=NMT;
       Currency:=Succ(CurrF.ItemIndex);
       NomCode:=IntStr(Trim(GLBankF.Text));

       Result:=Check_GLCurr(InvR,LId,0);

       If (Not Result) then
       Begin
         mbRet:=CustomDlg(Application.MainForm,'Currency Warning','Currency of payments is not '+SSymb(Nom.DefCurr),
                               'The bank account you have chosen cannot be paid in '+Ssymb(Currency)+#13+
                               'Please change the currency, or the bank account.',
                               mtInformation,
                               [mbOk])
       end;
     end;
  {$ENDIF}
end;


procedure TAllocateWiz.I4JobCodeFExit(Sender: TObject);
Var
  FoundCode  :  Str20;

  FoundOk,
  AltMod     :  Boolean;

  {
    Internal procedure to check for a default Cost Centre/Department against
    the Job, and to update the Cost Centre/Department on the form if found.
  }
  procedure ApplyJobCCDept(JobCode: string);
  var
    JobCCDept: CCDepType;
    OriginalCCDept: CCDepType;
    ReplacementCCDept: CCDepType;
    AccountCCDept: CCDepType;
  begin
    // CJS 2013-09-13 - ABSEXCH-13192 - add Job Costing to user profile rules
    JobUtils.GetJobCCDept(JobCode, JobCCDept);

    // Take a copy of the current CC/Dept values, as we will need to check
    // whether they match with the default CC/Dept values
    OriginalCCDept[True] := Id3CCF.Text;
    OriginalCCDept[False] := Id3DepF.Text;

    // Get the default Cost Centre/Department
    ReplacementCCDept := GetCustProfileCCDepEx(Cust.CustCC, Cust.CustDep, OriginalCCDept, JobCCDept, 0);

    // If the defaults returned by the GetCustProfileCCDepEx() function are not
    // the same as the current contents of the CC/Dept fields, and if they are
    // the Job defaults, overwrite them
    if (ReplacementCCDept[True] <> '') and
       (ReplacementCCDept[True] <> OriginalCCDept[True]) and
       (ReplacementCCDept[True] = JobCCDept[True]) then
    begin
      // Update Cost Centre
      Id3CCF.Text := ReplacementCCDept[True];
      JobCCDeptDefaultsLbl.Visible := True;
    end;

    if (ReplacementCCDept[False] <> '') and
       (ReplacementCCDept[False] <> OriginalCCDept[False]) and
       (ReplacementCCDept[False] = JobCCDept[False]) then
    begin
      // Update Department
      Id3DepF.Text := ReplacementCCDept[False];
      JobCCDeptDefaultsLbl.Visible := True;
    end;
  end;

begin
  // CJS 2013-09-13 - ABSEXCH-13192 - add Job Costing to user profile rules
  JobCCDeptDefaultsLbl.Visible := False;

  If (Sender is Text8pt) then
  With (Sender as Text8pt) do
  Begin
    AltMod:=Modified;

    FoundCode:=Strip('B',[#32],Text);

    If ((AltMod) and (FoundCode<>'')) and (ActiveControl<>TWClsBtn) and (JBCostOn) then
    Begin

      StillEdit:=BOn;

      FoundOk:=(GetJob(Self,FoundCode,FoundCode,3));

      If (FoundOk) then {* Credit Check *}
      Begin
        Text:=FoundCode;

        {FieldNextFix(Self.Handle,ActiveControl,Sender);}

        // CJS 2013-09-13 - ABSEXCH-13192 - add Job Costing to user profile rules
        ApplyJobCCDept(FoundCode);

      end
      else
      Begin
        {StopPageChange:=BOn;}

          SetFocus;
      end; {If not found..}

    end
    else
      If (FoundCode='') then {* Reset Janal code *}
        I4JobAnalF.Text:='';

  end;
end;


procedure TAllocateWiz.I4JobAnalFExit(Sender: TObject);
Var
  FoundCode  :  Str20;

  FoundOk,
  AltMod     :  Boolean;


begin

    If (Sender is Text8pt) then
    With (Sender as Text8pt) do
    Begin
      AltMod:=Modified;

      FoundCode:=Strip('B',[#32],Text);

      If (((AltMod) or (FoundCode='')) and (Not EmptyKey(I4JobCodeF.Text,JobCodeLen))) and (JBCostOn) and (ActiveControl<>TWClsBtn) then
      Begin

        StillEdit:=BOn;

        FoundOk:=(GetJobMisc(Self,FoundCode,FoundCode,2,Anal_FiltMode(DocSplit[SalesMode,2])));

        If (FoundOk) then {* Credit Check *}
        Begin

          Text:=FoundCode;

          {FieldNextFix(Self.Handle,ActiveControl,Sender);}

        end
        else
        Begin
          {StopPageChange:=BOn;}

          SetFocus;
        end; {If not found..}
      end;

    end;

end;


procedure TAllocateWiz.THUD1FExit(Sender: TObject);
begin
  If (Sender is Text8Pt)  and (ActiveControl<>TWClsBtn) then
    Text8pt(Sender).ExecuteHookMsg;

end;

procedure TAllocateWiz.THUD1FEntHookEvent(Sender: TObject);
Var
  CUUDEvent  :  Byte;
  Result     :  LongInt;
  ExLocal    :  TdExLocal;

begin
  {$IFDEF CU}

    ExLocal.Create;

    Try
      With ExLocal,LInv do
      Begin

        LResetRec(InvF);

        InvDocHed:=DocSplit[SalesMode,2];
        FolioNum:=-1;

      end;

      If (Sender is Text8Pt)then
        With (Sender as Text8pt) do
        Begin
          If (Not ReadOnly) then
          Begin
            If (Sender=THUD1F) then
            Begin
              ExLocal.LInv.DocUser1:=Text;
              CUUDEvent:=1;
            end
            else
              If (Sender=THUD2F) then
              Begin
                ExLocal.LInv.DocUser2:=Text;
                CUUDEvent:=2;
              end
              else
                If (Sender=THUD3F) then
                Begin
                  ExLocal.LInv.DocUser3:=Text;
                  CUUDEvent:=3;
                end
                else
                  If (Sender=THUD4F) then
                  Begin
                    ExLocal.LInv.DocUser4:=Text;
                    CUUDEvent:=4;
                  end
                  //GS 21/10/2011 ABSEXCH-11706: create branches for the new UDFs
                //there is a 60 offset; event values are adjucted accordingly
                else
                  If (Sender=THUD5F) then
                  Begin
                    ExLocal.LInv.DocUser5:=Text;
                    CUUDEvent:=(211 - 60);
                  end
                  else
                    If (Sender=THUD6F) then
                    Begin
                      ExLocal.LInv.DocUser6:=Text;
                      CUUDEvent:=(212 - 60);
                    end
                    else
                      If (Sender=THUD7F) then
                      Begin
                        ExLocal.LInv.DocUser7:=Text;
                        CUUDEvent:=(213 - 60);
                      end
                      else
                        If (Sender=THUD8F) then
                        Begin
                          ExLocal.LInv.DocUser8:=Text;
                          CUUDEvent:=(214 - 60);
                        end
                        else
                          If (Sender=THUD9F) then
                          Begin
                            ExLocal.LInv.DocUser9:=Text;
                            CUUDEvent:=(215 - 60);
                          end
                          else
                            If (Sender=THUD10F) then
                            Begin
                              ExLocal.LInv.DocUser10:=Text;
                              CUUDEvent:=(216 - 60);
                            end
                            else
// PKR. 24/03/2016. ABSEXCH-17383. Added handlers for UDFs 11 and 12. (Transaction Headers)
                              If (Sender=THUD11F) then
                              Begin
                                ExLocal.LInv.thUserField11:=Text;
                                CUUDEvent:=(217 - 60);
                              end
                              else
                                If (Sender=THUD12F) then
                                Begin
                                  ExLocal.LInv.thUserField12:=Text;
                                  CUUDEvent:=(218 - 60);
                                end
                                else
                              If (Sender=I1YReF) then
                              Begin
                                ExLocal.LInv.YourRef:=Text;
                                CUUDEvent:=120;
                              end;

            Result:=IntExitHook(2000,60+CUUDEvent,-1,ExLocal);

            If (Result=0) then
              SetFocus
            else
            With ExLocal do
            If (Result=1) then
            Begin
              Case CUUDEvent of
                1  :  Text:=LInv.DocUser1;
                2  :  Text:=LInv.DocUser2;
                3  :  Text:=LInv.DocUser3;
                4  :  Text:=LInv.DocUser4;
                //GS 21/10/2011 ABSEXCH-11706: put customisation object vals into UDFs
              (211 - 60)  :  Text:=LInv.DocUser5;
              (212 - 60)  :  Text:=LInv.DocUser6;
              (213 - 60)  :  Text:=LInv.DocUser7;
              (214 - 60)  :  Text:=LInv.DocUser8;
              (215 - 60)  :  Text:=LInv.DocUser9;
              (216 - 60) :  Text:=LInv.DocUser10;
// PKR. 24/03/2016. ABSEXCH-17383. Added handlers for UDFs 11 and 12. (Transaction Headers)
              (217 - 60) :  Text:=LInv.thUserField11;
              (218 - 60) :  Text:=LInv.thUserField12;
              120  :  Text:=LInv.YourRef;

              end; {Case..}
            end;
          end;
       end; {With..}
    except

    end; {Try..}

    ExLocal.Destroy;


  {$ELSE}
    CUUDEvent:=0;

  {$ENDIF}
end;

procedure TAllocateWiz.bcAllowSDiscFClick(Sender: TObject);
begin
  inherited;
  SDDOverF.Enabled:=bcAllowSDiscF.Checked;
end;

{* Prime the form as we are being driven via an existing transaction. Most options disabled *}

procedure TAllocateWiz.Set_UpTransAlloc;

Var
  fAbandon,
  FoundOk  :  Boolean;

Begin
  With SRCInv, AllocCtrlRec.AllocCRec do
  Begin
    FoundOk:=Alloc_CtrlGet(SalesMode,CustCode,AllocCtrlRec,Nil,1);

    fAbandon:=BOff;

    If (FoundOk) then
    With AllocCtrlRec.AllocCRec do
    Begin
      LastCtrlRec:=AllocCtrlRec;

      If (arcLocked=1) then
      Begin
        {* If we have a partialy complete record, not matching the transaction we have chosen, then abort screen *}

        If ((arcOurRef<>OurRef) or (Not arcFromTrans) or (Round_Up(ABS(arcTransValue),2)<>Round_Up(ABS(BaseTotalOS(SRCInv)),2))) then
        Begin
          fAbandon:=Not Confirm_Reset(BOn);
          
          arcForceNew:=Not fAbandon;
        end
        else
          arcForceNew:=Not Confirm_Reset(BOff);


      end
      else
      Begin
        FoundOk:=(arcLocked<>2);

        If (Not FoundOk) then
          WarnLocked
        else
          arcForceNew:=BOn;

        fAbandon:=Not FoundOk;

      end;

      If (FoundOk) and (Not fAbandon) then
      Begin
        If (arcForceNew) then {Reset values}
        Begin
          Init_AllocCtrl(AllocCtrlRec);

          arcIncVar:=BOff;  arcIncSDisc:=BOff;

          arcCXrate:=CXRate; arcPayCurr:=Currency;

          arcOwnTransValue:=CurrencyOS(SRCInv,BOff,BOff,BOff)*DocCnst[InvDocHed]*DocNotCnst;
          arcTransValue:=BaseTotalOS(SRCInv)*DocCnst[InvDocHed]*DocNotCnst;

          If (arcOwnTransValue<0) and (Not RightSignDoc(SRCInv)) then {* v5.52 Its a negative transaction *}
          Begin
            arcOwnTransValue:=arcOwnTransValue*DocNotCnst;
            arcTransValue:=arcTransValue*DocNotCnst;
          end;

          arcCtrlNom:=CtrlNom;

          arcYourRef:=YourRef; {arcLYourRef:=TransDesc;}
          arcTransDate:=TransDate;

          arcTagRunPr:=AcPR;  arcTagRunYr:=AcYR;

          arcUD1:=DocUser1;  arcUD2:=DocUser2;
          arcUD3:=DocUser3;  arcUD4:=DocUser4;

          arcJobCode:=DJobCode; arcAnalCode:=DJobAnal;
          arcOurRef:=OurRef; arcFromTrans:=BOn;

          arcDelAddr:=DAddr;  arcOpoName:=OpName;
          arcCustCode:=CustCode;

        end;

        OutAllocWiz;

        {$IFDEF MC_On}
         If (LCurrF.CanFocus) then
           LCurrF.SetFocus;
        {$ENDIF}
        
      end
      else
        If fAbandon then
        Begin
          PostMessage(Self.Handle,WM_Close,0,0);
        end;

    end; {If Ctrl record found}
  end; {With..}

end; {Proc..}

Function TAllocateWiz.CheckAWCompleted(Edit  :  Boolean)  : Boolean;

  Const
    NofMsgs      =  21;

  Type
    PossMsgType  = Array[1..NofMsgs] of Str80;

  Var
    PossMsg  :  ^PossMsgType;

    Test     :  Byte;

    ShowMsg  :  Boolean;

    mbRet    :  Word;

    FoundCode2
             :  Str10;

    FoundCode:  Str20;

    FoundLong:  LongInt;

    {$IFDEF CU}
      ExLocal    :  TdExLocal;


    {$ENDIF}
   Begin
    New(PossMsg);

    FillChar(PossMsg^,Sizeof(PossMsg^),0);

    PossMsg^[1]:='That Account Code is not valid.';
    PossMsg^[2]:='The default Cost Centre Code is not valid.';
    PossMsg^[3]:='The default Department Code is not valid.';
    PossMsg^[4]:='The default Currency is not valid.';
    PossMsg^[5]:='The G/L Control Code is not valid.';
    PossMsg^[6]:='The Currency and G/L Code combination is not valid.';
    PossMsg^[7]:='The Bank G/L Code is not valid.';
    PossMsg^[8]:='The default Job Costing Code is not valid.';
    PossMsg^[9]:='An Exchange Rate of zero is not valid.';
    PossMsg^[10]:='The default date is not valid.';
    PossMsg^[11]:='The default Job Costing Analysis Code is not valid.';
    PossMsg^[12]:='For local currency the exchange rate must be 1.0.';
    PossMsg^[13]:='Confirm we wish to proceed in manual mode';
    PossMsg^[14]:='The value of this transaction must be zero or positive.';
    PossMsg^[15]:='The default period is not valid.';
    PossMsg^[16]:='Check sub contractor expiry';
    PossMsg^[17]:='The value of split charges is greater than the total value.';
    PossMsg^[18]:='The G/L code for split charge 1 is not valid.';
    PossMsg^[19]:='The G/L code for split charge 2 is not valid.';
    PossMsg^[20]:='A negative total has been entered';
    PossMsg^[21]:='External hook called';




    Test:=1;

    Result:=BOn;


    While (Test<=NofMsgs) and (Result) do
    With AllocCtrlRec,AllocCRec do
    Begin
      {$B-}

      ShowMsg:=BOn;

      Case Test of

        1  :  Begin
                Result:=(Not EmptyKey(arcCustCode,CustKeyLen));

                If (Result) then
                  Result:=(CheckRecExsists(arcCustCode,CustF,CustCodeK));

              end;

        2  :  {$B-}
                 Result:=(FromTrans) or (Not Syss.UseCCDep) or GetCCDep(Self,arcCCDep[BOn],FoundCode,BOn,-1);
              {$B+}

        3  :  {$B-}
                 Result:=(FromTrans) or (Not Syss.UseCCDep) or GetCCDep(Self,arcCCDep[BOff],FoundCode,BOff,-1);
              {$B+}

      {$IFDEF MC_On}
        4  :
                 Result:=(arcPayCurr In [Succ(CurStart)..CurrencyType]);

        9  :     Result:=(arcCXRate[UseCoDayRate]<>0);

        12 :     Result:=((arcPayCurr=1) and (arcCXRate[UseCoDayRate]=1.0)) or (arcPayCurr>1);

      {$ENDIF}

        5  :   Result:=(arcCtrlNom=0) or (GetNom(Self,Form_Int(arcCtrlNom,0),FoundLong,-1));

        6  :   If (Not FromTrans) then
               Begin
                 Result:=CheckGLCurr;
                 ShowMsg:=BOff;
               end;


        7  :   {$B-}
                 Result:=(FromTrans) or (GetNom(Self,Form_Int(arcBankNom,0),FoundLong,-1));
               {$B+}


        8  :   {$B-}
                 Result:=(FromTrans) or (Not JBCostOn) or (EmptyKey(arcJobCode,JobCodeLen)) or (GetJob(Self,arcJobCode,FoundCode,-1));
               {$B+}

        10 :   Result:=(arcTransDate<>'');

        11 :  {$B+}
                Result:=(FromTrans) or (Not JBCostOn) or (EmptyKey(arcJobCode,JobCodeLen)) or (GetJobMisc(Self,arcAnalCode,FoundCode,2,-1));
              {$B-}

        13 :  Begin
                ShowMsg:=BOff;

                If (arcTransValue=0.0) and (Not FromTrans) and (Not Edit) and (Not WarnZero) then {* Confirm auto mode *}
                Begin
                  arcAutoTotal:=(CustomDlg(Application.MainForm,'Automatic mode','The amount to be allocated is zero',
                               'The amount to be allocated is zero. In this mode, the allocation routine will automatically calculate'+
                               ' the total value of the '+DocNames[DocSplit[SalesMode,2]]+' based on the transactions being allocated.'#13+#13+
                               'Please confirm you wish to proceed in automatic mode, or go back and enter a value for this allocation.',
                               mtConfirmation,
                               [mbOK,mbCancel])=mrOk);

                  Result:=arcAutoTotal;

                  WarnZero:=Result;

                end;
              end;

        14 :  Begin
                {Result:=(arcTransValue>=0.0);}

              end;
        15 :  Begin
                Result:=(arcTagRunYr<>0) and (arcTagRunPr<>0);

              end;

        16 :  Begin
                ShowMsg:=BOff;

                {$IFDEF JC}
                  {$IFDEF PF_On}
                     If (JBCostOn) and (Not SalesMode) and (Not FromTrans) then
                       Result:=Not Cert_Expired(arcCustCode,Today,BOn,BOn);
                  {$ENDIF}
                {$ENDIF}

              end;

        17 :  Begin
                {$B-}

                Result:=(arcAutoTotal) or (((arcCharge1Amt+arcCharge2Amt)<arcOwnTransValue) and (arcTransValue>0))
                    or (((arcCharge1Amt+arcCharge2Amt)>arcOwnTransValue) and (arcTransValue<0));

                {$B+}
              end;
        {$B-}
          18  :   Result:=(arcCharge1GL=0) or (GetNom(Self,Form_Int(arcCharge1GL,0),FoundLong,-1));

          19  :   Result:=(arcCharge2GL=0) or (GetNom(Self,Form_Int(arcCharge2GL,0),FoundLong,-1));

        {$B+}

        20 :  Begin
                ShowMsg:=BOff;

                If (arcTransValue<0.0) and (Not FromTrans) and (Not Edit) and (Not WarnNeg) then {* Confirm auto mode *}
                Begin
                  
                  Result:=(CustomDlg(Application.MainForm,'Negative Total','Amount to be allocated is negative',
                               'The amount to be allocated is negative. In this mode, the allocation routine will automatically create'+
                               ' a negative '+DocNames[DocSplit[SalesMode,2]]+' without allowing any transactions to be allocated.'+#13+
                               'Allocation will have to take place later against a genuine credit.'+#13+#13+
                               'Please confirm you wish to proceed in negative mode.',
                               mtConfirmation,
                               [mbOK,mbCancel])=mrOk);
                               
                  WarnNeg:=Result;

                end;
              end;
        21  : Begin
                {$IFDEF CU}

                   ExLocal.Create;

                   Try
                     With ExLocal,LId do
                     Begin
                       if (arcSalesMode) then
                         IdDocHed:=SRC
                       else
                         IdDocHed:=PPY;


                       CCDep:=arcCCDep;
                       NomCode:=arcBankNom;

                       With LInv do
                       Begin
                         InvDocHed:=IdDocHed;
                         ILineCount:=1;
                       end;
                     end;

                     // CA  25/06/2012   v7.0.3  ABSEXGENERIC-299: Ensuring only if the CC/Dept are visible should the validation happen
                     If (Id3CCF.Visible) And
                        (Id3DepF.Visible) Then
                         Result:=ValidExitHook(4000,20,ExLocal);

                     { CJS 2013-08-05 - ABSEXCH-14311 - UDF validation on SRC and PPY }
                     if Result and (PageControl1.ActivePage = TabSheet2) then
                     begin
                       { This validation is using a temporary ExLocal, so we
                         need to populate the User-Defined Fields in it. }
                       ExLocal.LInv.DocUser1  := thUD1F.Text;
                       ExLocal.LInv.DocUser2  := thUD2F.Text;
                       ExLocal.LInv.DocUser3  := thUD3F.Text;
                       ExLocal.LInv.DocUser4  := thUD4F.Text;
                       ExLocal.LInv.DocUser5  := thUD5F.Text;
                       ExLocal.LInv.DocUser6  := thUD6F.Text;
                       ExLocal.LInv.DocUser7  := thUD7F.Text;
                       ExLocal.LInv.DocUser8  := thUD8F.Text;
                       ExLocal.LInv.DocUser9  := thUD9F.Text;
                       ExLocal.LInv.DocUser10 := thUD10F.Text;
                       // PKR. 24/03/2016. ABSEXCH-17383. Added handlers for UDFs 11 and 12. (Transaction Headers)
                       ExLocal.LInv.thUserField11 := thUD11F.Text;
                       ExLocal.LInv.thUserField12 := thUD12F.Text;
                       
                       Result := ValidExitHook(2000, 82, ExLocal);
                     end;

                     ShowMsg:=BOff;
                   Finally

                     ExLocal.Destroy;
                   end; {Try..}

               {$ENDIF}
              end;

      end;{Case..}

      {$B+}

      If (Result) then
        Inc(Test);

    end; {While..}

    If (Not Result) and (ShowMsg) then
    begin
      //TW 15/11/2011 Fix for missing focus after invalid GL code message.
      mbRet:=MessageDlg(PossMsg^[Test],mtWarning,[mbOk],0);

      if (Test = 7) then
        self.ActiveControl := GLBankF;
    end;
    Dispose(PossMsg);

  end; {Func..}



Function TAllocateWiz.CheckChange  :  Boolean;

Begin
  With AllocCtrlRec.AllocCRec do
  Begin
    Result:=((arcPayCurr<>LastCtrlRec.AllocCRec.arcPayCurr) or
             (arcInvCurr<>LastCtrlRec.AllocCRec.arcInvCurr) or
             (arcCtrlNom<>LastCtrlRec.AllocCRec.arcCtrlNom) or
             (arcSortBy<>LastCtrlRec.AllocCRec.arcSortBy) or
             (arcSort2By<>LastCtrlRec.AllocCRec.arcSort2By) or
             (arcSortD<>LastCtrlRec.AllocCRec.arcSortD) or
             (arcIncSDisc<>LastCtrlRec.AllocCRec.arcIncSDisc) or
             (arcSDDaysOver<>LastCtrlRec.AllocCRec.arcSDDaysOver) or
             (arcIncVar<>LastCtrlRec.AllocCRec.arcIncVar) or
             (arcIncVar<>LastCtrlRec.AllocCRec.arcIncVar));

  end;


end;

procedure TAllocateWiz.StartAllocation;

  Begin
    Form2AllocWiz;

    If (CheckAWCompleted(BOff)) then
    Begin
      If (Not AllocCtrlRec.AllocCRec.arcForceNew) then
        AllocCtrlRec.AllocCRec.arcForceNew:=CheckChange;

      AllocCtrlRec.AllocCRec.arcLocked:=1;

      With AllocCtrlRec.AllocCRec do
      Begin
        If (arcTransValue<0.0) and (Not arcFromTrans) then {* Reset full allocation which may still be set from last allocation *}
          arcAllocFull:=BOff;

      end;

      Alloc_CtrlPut(MLocF,MLK,AllocCtrlRec,Nil,2);

      LastValueObj.UpdateAllLastValuesFull(Self);


      {$IFDEF POST}

        With AllocCtrlRec.AllocCRec do
        If (arcForceNew) or (arcLocked=0) then
        Begin
          TWNextBtn.Enabled:=BOff;
          TWPrevBtn.Enabled:=BOff;

          TWClsBtn.Enabled:=BOff;

          If (arcTransValue<0) then
          Begin
            AddAllocScan2Thread(Application.MainForm,AllocCtrlRec,Self.Handle,1);
          end
          else
          Begin
            AddAllocScan2Thread(Application.MainForm,AllocCtrlRec,Self.Handle,0);


          end;

          Enabled:=BOff;
        end
        else
        Begin
          Show_AllocList;

          ShutDown;
        end;

      {$ENDIF}
    end;
  end;



procedure TAllocateWiz.TryFinishWizard;

Begin
  StartAllocation;

end;


procedure TAllocateWiz.Show_AllocList;

Var
  BPay  :  TAllocItems;

  Sales,Purch,Cleared  :  Double;

Begin
  Set_AIFormMode(SalesMode);


  BPay:=TAllocItems.Create(Self.Owner);

  Cust.Balance:=Profit_to_Date(CustHistCde,AllocCtrlRec.AllocCRec.arcCustCode,0,150,Syss.PrinYr,Sales,Purch,Cleared,BOn);


  try
    With BPay do
    Begin
      MULCTrlO.AllocCtrl:=Self.AllocCtrlRec;

      ExLocal.AssignFromGlobal(CustF);

      RefreshList(BOn,BOn);

      SetCaption;
      
      Link2Tot;

    end;
  except
    BPay.Free;

  end;

end;




procedure TAllocateWiz.HideChargePage;

Var
  ShowChargePage  :  Boolean;

Begin
  With AllocCtrlRec.AllocCRec do
  Begin
    ShowChargePage:=(Not arcAutoTotal) and (Not FromTrans) and (arcTransValue<>0.0);

    If (Not ShowChargePage) then {* Reset any previous charges *}
    Begin
      GLPayAmt1.Value:=0.0;
      GLPayAmt2.Value:=0.0;
    end
    else
    Begin
      GLPayAmt1.CurrencySymb:=PSymb(arcPayCurr);

      GLPayAmt2.CurrencySymb:=PSymb(arcPayCurr);

    end;

    TabSheet3.Visible:=ShowChargePage;

    SetWizButtons;
    SetStepCaption;

  end; {Proc..}
end;
                         
procedure TAllocateWiz.TWPrevBtnClick(Sender: TObject);
Var
  newIndex : Integer;
  Continue : Boolean;
begin

  // MH 15/12/2010 v6.6 ABSEXCH-10548: Set focus to Next/Finish button to trigger OnExit validation
  If (Sender = TWNextBtn) And (ActiveControl <> TWNextBtn) Then
  Begin
    // Move focus to OK button to force any OnExit validation to occur
    TWNextBtn.SetFocus;
    Continue := (ActiveControl = TWNextBtn);
  End
  Else
    Continue := True;

  If Continue Then
  Begin
    Self.ActiveControl := nil;
    IgnoreAutoPost:=BOn;
  
    NewIndex:=pcLivePage(PageControl1);
    
    Form2AllocWiz;
    If (NewIndex In [0]) then
    Begin

      HideChargePage;
    end;

    If (CheckAWCompleted((NewIndex<>0))) then
      inherited;

    {SS 6/04/2016 2016-R2
	  ABSEXCH-13454:Allocation Wizard - Step 3 Disappears If You Go Back From Step 3 to 2}
    If (NewIndex In [2]) then
      HideChargePage;

  End; // If Continue
end;

procedure TAllocateWiz.SetHelpContextIDsForPage(bInc : boolean); // NF: 12/04/06
var
  iOffSet : integer;
  bPurchase : boolean;

  procedure IncHelpContextIDs(iInc : integer; TheControl : TControl);
  var
    iPos : integer;

    procedure SetContextID(AControl : TControl; iNewID : integer);
    begin{SetContextID}
      // Exceptions
      if AControl is TTabSheet then exit;
      if AControl.Name = 'OkR1Btn' then exit;
      if AControl.Name = 'CanR1Btn' then exit;
      if AControl.Name = 'ClsR1Btn' then exit;

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
      and (not (Thecontrol.Components[iPos] is TForm))  // NF: 08/05/06 - Fixed so that it does not itterate through other Forms
      then IncHelpContextIDs(iInc, TControl(TheControl.Components[iPos]));
    end;{for}
  end;{IncHelpContextIDs}

begin
  {$IFDEF LTE}
    // IAO
    if (not bHelpContextInc) and (not bInc) then exit;

    bPurchase := not SalesMode;
    if bPurchase then iOffSet := 0
    else begin
      if bInc then
      begin
        iOffSet := 5000;
        bHelpContextInc := TRUE;
      end else
      begin
        iOffSet := -5000;
        bHelpContextInc := FALSE;
      end;{if}
    end;{if}

    // Set Correct Tab IDs
    if (bInc) then
    begin
      case PageControl1.ActivePage.PageIndex of
        0 : begin
          PageControl1.ActivePage.HelpContext := iOffSet + 1687;
          CompF.HelpContext := 92;
          ACFF.HelpContext := 1839; // NF: 20/06/06 Added to differenciate between other similar fields
          CompF.HelpContext := 1840; // NF: 20/06/06 Added to differenciate between other similar fields
          NomDescF.HelpContext := GLBankF.HelpContext;
          NomDescF2.HelpContext := GLMDC.HelpContext;
        end;
        1 : begin
          PageControl1.ActivePage.HelpContext := iOffSet + 1688;
          CqNo.HelpContext := 1703; // NF: 09/05/06 Fix for incorrect Context ID
          PayIF.HelpContext := 1704; // NF: 09/05/06 Fix for incorrect Context ID
        end;
        2 : begin
          PageControl1.ActivePage.HelpContext := iOffSet + 1689;
          GLPayAmt1.HelpContext := 1837; // NF: 20/06/06 Fix for incorrect Context ID
          GLPayAmt2.HelpContext := 1838; // NF: 20/06/06 Fix for incorrect Context ID
          GLPay1NameF.HelpContext := GLPay1F.HelpContext;
          GLPay2NameF.HelpContext := GLPay2F.HelpContext;
        end;
      end;{case}

      TWPrevBtn.HelpContext := 1698;

      if TWNextBtn.Caption = '&Finish' then
      begin
        TWNextBtn.HelpContext := 1699; // Finish
      end else
      begin
        TWNextBtn.HelpContext := 1696; // Next
      end;{if}

      TWClsBtn.HelpContext := 1697;
    end;{if}

    if (iOffSet <> 0) then IncHelpContextIDs(iOffSet, Self);

    HelpContext := PageControl1.ActivePage.HelpContext;
    PageControl1.HelpContext := PageControl1.ActivePage.HelpContext;
  {$ELSE}
    // Exchequer
    // NF: 09/05/06 Fixes for incorrect Context IDs
    if bPurchase then
    begin
      // PPY Wizard
      CqNo.HelpContext := 6703;
      PayIF.HelpContext := 6704;
      GLPayAmt1.HelpContext := 6837;
      GLPayAmt2.HelpContext := 6838;
    end else
    begin
      // SRC Wizard
      CqNo.HelpContext := 1703;
      PayIF.HelpContext := 1704;
      GLPayAmt1.HelpContext := 1837;
      GLPayAmt2.HelpContext := 1838;
    end;{if}
  {$ENDIF}
end;


// MHYR 25/10/07
procedure TAllocateWiz.I1YRefChange(Sender: TObject);
begin
  inherited;
  I1YRef.Hint := I1YRef.Text;
end;

procedure TAllocateWiz.DAddr5FExit(Sender: TObject);
begin
  inherited;
  {SS 22/03/2016 2016-R2 
     ABSEXCH-16165:Sales Receipt & Purchase Payments Wizard, moving onto screen 2 without clicking next.}

  if ((ActiveControl.TabOrder <= DAddr5F.TabOrder) and (ActiveControl.Parent = DAddr5F.Parent)) then
    Exit;
  {SS 6/04/2016 2016-R2
  ABSEXCH-13454:Allocation Wizard - Step 3 Disappears If You Go Back From Step 3 to 2}
  if (ActiveControl = TWPrevBtn) then Exit;

  //TW: 15/11/2011 Dirty fix to proc next button after tabbing from last field on tab 2
  self.ActiveControl := TWNextBtn;
  PostMessage(Self.Handle,WM_CustGetRec,5,0);
  PostMessage(Self.Handle,WM_CustGetRec,5,0);
end;

//AP : 23/02/2017 2017-R1 ABSEXCH-17054 : Calender in SRC Allocation wizard is not showing correctly when FY is not Jan-Dec
function TAllocateWiz.R1TPerFConvDate(Sender: TObject; const IDate: String;
  const Date2Pr: Boolean): String;
begin
  Result := ConvInpPr(IDate, Date2Pr, nil);
end;

//AP : 23/02/2017 2017-R1 ABSEXCH-17054 : Calender in SRC Allocation wizard is not showing correctly when FY is not Jan-Dec
function TAllocateWiz.R1TPerFShowPeriod(Sender: TObject;
  const EPr: Byte): String;
begin
  Result := PPr_Pr(EPr);
end;

Initialization

  alSales:=BOff;
  alFromTrans:=BOff;

end.


