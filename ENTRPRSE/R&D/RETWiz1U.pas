unit RetWiz1U;

{$I DEFOVR.Inc}

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, WIZTEMPU, StdCtrls, TEditVal, TCustom, ExtCtrls, SBSPanel,
  ComCtrls, Mask,
  GlobVar,
  VarConst,BTSupU3,
  RetSup1U,
  ExWrap1U, BorBtns;



type
  TRetWizard = class(TWizTemplate)
    Label87: Label8;
    PQuotF: TCurrencyEdit;
    A1StartDF: TEditDate;
    Label82: Label8;
    I4RetF: Text8Pt;
    A1b2bRepcb: TBorCheckEx;
    A1BQtyCB: TSBSComboBox;
    Label83: Label8;
    A1PActionCB: TSBSComboBox;
    A1RepCb: TSBSComboBox;
    Label84: Label8;
    A2BQtyCB: TSBSComboBox;
    Label85: Label8;
    A1RestockCb: TBorCheckEx;
    A1Matchcb: TBorCheckEx;
    TabSheet3: TTabSheet;
    Label88: Label8;
    Sum1: TCurrencyEdit;
    Label89: Label8;
    AgeInt: TCurrencyEdit;
    Label810: Label8;
    Label811: Label8;
    ACFF: Text8Pt;
    PDNote: TSBSComboBox;
    Sum2: TBorCheck;
    PrnScrnB: TBorCheck;
    Sum3: TBorCheck;
    PInvDoc: TSBSComboBox;
    A1Pricecb: TSBSComboBox;
    A1AppPricecb: TBorCheckEx;
    Label813: Label8;
    R1TPerF: TEditPeriod;
    Label812: Label8;
    I1YRef: Text8Pt;
    Label815: Label8;
    RetLocF: Text8Pt;
    A1StkCodeF: Text8Pt;
    Id3StatCB1: TSBSComboBox;
    Label816: Label8;
    A1SetExpcb: TBorCheckEx;
    A1ARetcb: TBorCheckEx;
    I1AccF: Text8Pt;
    Label814: Label8;
    UseSystemDateChk: TBorCheckEx;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure A1PActionCBChange(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure PageControl1Change(Sender: TObject);
    procedure RetLocFExit(Sender: TObject);
    procedure I4RetFExit(Sender: TObject);
    procedure A1ARetcbClick(Sender: TObject);
    procedure I1AccFClick(Sender: TObject);
    procedure I4RetFEnter(Sender: TObject);
    procedure A1StartDFExit(Sender: TObject);
    procedure I1YRefChange(Sender: TObject);
    procedure TWPrevBtnClick(Sender: TObject);
  private
    { Private declarations }
    PrevHState
               :  Boolean;

    awRefOk,
    awWarned,
    JustCreated:  Boolean;
    JTMode     :  Byte;
    DocHed     :  DocTypes;
    ExLocal    :  TdExLocal;
    AccCode    :  Str10;
    wJCode     :  Str10;
    SOPInp     :  SOPInpRec;
    NextRNo  :  LongInt;


    Function GetPageCount  :  Integer; Override;

    Function GetEndPageCount  :  Integer; Override;

    Function RetWizQty  :  Double;

    procedure Form2Wizard;

    Function CheckCompleted(Edit,MainChk  :  Boolean)  : Boolean;

    procedure Display_GlobalTrans(Mode  :  Byte);

    procedure FinishAction;

    procedure TryFinishWizard; Override;

    procedure SetWizHelp;

  public
    { Public declarations }
    RetWizRec  :  tRetWizRec;
    CRepParam  :  PPickRepPtr;

  end;

Procedure Set_RetWiz(LInv  :  InvRec;
                     LId   :  IDetail;
                     RDoc  :  DocTypes;
                     ACode :  Str20;
                     RMode :  Byte;
                     LAddr :  LongInt);

Procedure Gen_RetDocWiz(InvR  :  InvRec;
                        IdR   :  IDetail;
                        Mode  :  Byte;
                        AOwner:  TWinControl);

Procedure Gen_RetSerWiz(RetSerial  :  MiscRec;
                        UseOutDoc  :  Boolean;
                        AOwner     :  TWinControl);

{~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~}

Implementation

{~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~}

Uses
  VarRec2U,
  RPDefine,
  InvListU,
  ETDateU,
  ETMiscU,
  ETStrU,
  BtrvU2,
  ComnUnit,
  ComnU2,
  BTSupU1,
  BTSupU2,
  BTKeys1U,
  SBSComp2,
  GenWarnU,
  RetInpU,
  SysU1,
  SysU2,
  SOPCT2U,
  SOPCT3U,
  {$IFDEF FRM}
    PrintFrm,
    DelvRunU,
  {$ENDIF}

  Event1U,

  {$IFDEF SOP}
    SOPB2BWU,
  {$ENDIF}

  ThemeFix,

  Exthrd2U,
  PassWR2U,
  Tranl1U;

{$R *.dfm}



Var
  LocalInv   :  ^InvRec;
  LocalId    :  ^Idetail;
  LocalRetAddr
             :  LongInt;

  LocalDoc   :  DocTypes;
  LocalMode  :  Byte;
  LocalAc    :  Str20;
  RetWizard  :  TRetWizard;
  RetWActive :  Boolean;
  GlobAppRetRef
             :  Array[BOff..BOn] of Str20;



{ Mode. 0 = Normal Create call from full transaction
        1 = Action one Return
        2 = Action all Returns
       10 = Create call from single line
       11 = Create call from Serial record }

Procedure Set_RetWiz(LInv  :  InvRec;
                     LId   :  IDetail;
                     RDoc  :  DocTypes;
                     ACode :  Str20;
                     RMode :  Byte;
                     LAddr :  LongInt);

Begin
  If (Not Assigned(LocalInv)) then
    New(LocalInv);

  LocalInv^:=LInv;

  If (Not Assigned(LocalId)) then
    New(LocalId);

  LocalId^:=LId;

  If (LocalRetAddr<>LAddr) then
    LocalREtAddr:=LAddr;

  If (LocalMode<>RMode) then
    LocalMode:=RMode;

  If (LocalDoc<>RDoc) then
    LocalDoc:=RDoc;

  If (LocalAc<>ACode) then
    LocalAc:=ACode;

end;


Function TRetWizard.RetWizQty  :  Double;

Begin
  If (RetWizRec.rwDocLine.IdDocHed In WOPSplit) then
    Result:=Qty_OS(RetWizRec.rwDocLine)
  else
    If (Not (RetWizRec.rwDocLine.IdDocHed In StkRetSalesSplit)) then
      Result:=RetWizRec.rwDocLine.Qty
    else
      Result:=RetWizRec.rwDocLine.QtyDel;
end;

procedure TRetWizard.FormCreate(Sender: TObject);

Var
  LPr,LYr,
  n     :  Byte;
  JRef  :  Str10;

  BasisSet
        :  Boolean;


begin
  JTMode:=LocalMode;

  inherited;

  // MH 12/01/2011 v6.6 ABSEXCH-10548: Modified theming to fix problem with drop-down lists
  ApplyThemeFix (Self);

  ExLocal.Create;

  RetWActive:=BOn;  awWarned:=BOff;  BasisSet:=BOff;

  FillChar(RetWizRec,Sizeof(RetWizRec),#0);

  awRefOk:=BOff;

  JustCreated:=BOn;


  A1StartDF.DateValue:=Today;


  DocHed:=LocalDoc;


  AccCode:=LocalAc;


  With RetWizRec do
  Begin
    rwWizMode:=JTMode;
    rwDocHed:=DocHed;
    rwDoc:=LocalInv^;
    rwDocLine:=LocalId^;
    
    If (JTMode=11) then
      rwSerialRef:=LocalAc;
  end;


  ClientHeight:=291;
  ClientWidth:=533;


  For n:=0 to PageControl1.PageCount-1 do {Hide Tabs}
  With PageControl1 do
  Begin
    If (Assigned(Pages[n])) then
    Begin
      Pages[n].TabVisible:=BOff;
      Pages[n].Visible:=BOn;
    end;

  end; {Loop}

  If (JTMode In [1,2]) then
  Begin
    A1AppPricecb.Checked:=BOff;

    RetWizRec.rwCanMatch:=(JTMode=2) or (GetDocType(RetWizRec.rwDoc.TransDesc) In StkRetGenSplit-[POR,SRN]);

    If (DocHed In StkRetSalesSplit) then
    Begin
      UseSystemDateChk.Visible := False;
      {A1PActionCB.Visible:=BOff;}
      A1BQtyCb.Visible:=BOff;
      {A1SActionCB.Top:=A1PActionCB.Top;}
      A2BQtyCB.Top:=A1BQtyCB.Top;

      A2BQtyCB.ItemIndex:=0;

      With A1PActionCB do
      Begin
        Items.Strings[0]:='Generate Credit Note & Write Off / Issue Stock';
        Items.Strings[1]:='Generate Credit Note & Send Replacement Stock';
        Items.Strings[2]:='Generate Repair Invoice';
      end;

      TabSheet2.HelpContext:=1602;

      A1PActionCb.HelpContext:=1603;


      Label83.Caption:=Label83.Caption+'Sent via';

      A1ReStockCB.Checked:=BOn;

      {A1RepCb.Visible:=(JTMode=1); {* Cannot enable this in run mode as if multi bins need to assign them, and we are in modal mode... *}

      If (JTMode=2) then
      Begin
        With A1PActionCB do {* Delete ref to repair mode in run mode due to unsuitability of that mode in a run *}
        Begin
          Items.Delete(Items.Count-1);

        end;

        With A2BQtyCB do {* Delete ref to SOR->POR in Run *}
        Begin
          Items.Delete(Items.Count-1);

        end;



      end
    end
    else
    Begin
      UseSystemDateChk.Visible := False;
      A2BQtyCb.Visible:=BOff;
      A1PActionCB.ItemIndex:=1;
      A1BQtyCB.ItemIndex:=0;
      A1RepCb.Visible:=BOff;

      Label83.Caption:=Label83.Caption+'Received via';

      With A1PActionCB do {* Delete ref to Issue back to stock *}
      Begin
        {For n:=0 to 1 do}
          Items.Delete(Items.Count-1);

      end;

      A1ReStockCB.Visible:=BOff;
    end;

    Label85.Visible:=A1RepCB.Visible;


    {$IFNDEF SOP}
      With A1BQtyCB do {* Delete ref to delivery note *}
      Begin
        Items.Delete(Items.Count-1);
        Enabled:=BOff;
      end;

      With A2BQtyCB do {* Delete ref to SPOP & B2B *}
      Begin
        For n:=0 to 1 do
          Items.Delete(Items.Count-1);

        ItemIndex:=0;
        Enabled:=BOff;

      end;

      Label83.Visible:=BOff;

    {$ENDIF}

    A1RepCb.ItemIndex:=0;
    A1PActionCB.ItemIndex:=0;

    Label86.Caption:=DocNames[DocHed]+' '+Label86.Caption;

    A1MatchCB.Checked:=RetWizRec.rwCanMatch;

  end
  else
    If (JTMode In [0,10,11]) then
    Begin
      Self.Caption:='Generate Return from '+RetWizRec.rwDoc.OurRef;

      Label86.Caption:='Generate '+DocNames[DocHed];

      Set_RetLineStat(Id3StatCB1.Items);

      Id3StatCB1.ItemIndex:=0;

      {If (DocHed In StkRetSalesSplit) then
        A1PriceCb.ItemIndex:=1;}

      A1SetExpCb.Checked:=(DocHed In StkRetPurchSplit);

      If (JTMode=0) then
      Begin
        Label87.Visible:=BOff;
        PQuotF.Visible:=BOff;
        A1PriceCb.Left:=PQuotF.Left;

      end
      else
      Begin
        PQuotF.Value:=RetWizQty;

        RetLocF.Text:=RetWizRec.rwDocLine.MLocStk;
      end;

      With RetWizRec.rwDoc do
      Begin
        LPr:=GetLocalPr(0).CPr;
        LYr:=GetLocalPr(0).CYr;

        R1TPerF.InitPeriod(LPr,LYr,BOn,BOn);

        I1YRef.Text:=Trim(YourRef);

      end;

      {$IFDEF SOP}
        If (Not UseEMLocStk) or (DocHed In StkRetSalesSplit) then
      {$ENDIF}
      Begin
        RetLocF.Visible:=BOff;
        Label815.Visible:=BOff;
      end;

      With RetWizRec.rwDocLine do
        A1b2bRepcb.Visible:=(RetWizRec.rwDoc.InvDocHed In StkRetSalesSplit+WOPSplit) and (JTMode In [0,10]) and ((QtyDel<>0.0) or (RetWizRec.rwDoc.InvDocHed In WOPSplit) or (JTMode=0));

      A1b2bRepcb.Checked:=A1b2bRepcb.Visible;

      If (RetWizRec.rwDoc.InvDocHed In WOPSplit) then
      Begin
        A1b2bRepcb.Caption:='Auto Pick WOR';
      end;

      With RetWizRec.rwDocLine do
        I1AccF.Visible:=(RetWizRec.rwDoc.InvDocHed In StkRetSalesSplit+WOPSplit);

      Label814.Visible:=I1AccF.Visible;

      If (I1AccF.Visible) then {* Atempt to get supplier record *}
      Begin
        If (Stock.StockCode<>RetWizRec.rwDocLine.StockCode) then
          If (Not Global_GetMainRec(StockF,RetWizRec.rwDocLine.StockCode)) then
            ResetRec(StockF);

        I1AccF.Text:=Stock.Supplier;

        If Not (Global_GetMainRec(CustF,I1AccF.Text)) then {If all else fails use system set-up supplier}
          I1AccF.Text:=GetProfileAccount(BOff);

      end;

      A1StkCodeF.Visible:=Label87.Visible;

      A1StkCodeF.Text:=dbFormatName(RetWizRec.rwDocLine.StockCode,RetWizRec.rwDocLine.Desc);

      I4RetF.Text:=GlobAppRetRef[RetWizRec.rwDocHed In StkRetSalesSPlit];

      If (Trim(I4RetF.Text)='') then
        I4RetF.Text:=DocCodes[RetWizRec.rwDocHed];
    end;


  With PageControl1 do
  Begin
    Case JTMode of
      0,10,11
         :  Begin
              Pages[0].Visible:=BOn;
              Pages[1].Visible:=BOff;
              Pages[2].Visible:=BOff;
              ActivePage:=TabSheet1;

              Case JTMode of
                0  :  If (A1PriceCB.CanFocus) then
                       Self.ActiveControl:=A1PriceCB;
                else  If (PQuotF.CanFocus) then
                       Self.ActiveControl:=PQuotF;
              end; {Case..}

            end;
      1,2
         :  Begin
              Pages[1].Visible:=BOn;
              Pages[0].Visible:=BOff;
              Pages[2].Visible:=(JTMode=2);
              ActivePage:=TabSheet2;
              StartPage:=1;

              If (A1PActionCB.CanFocus) then
                Self.ActiveControl:=A1PActionCB;

            end;

    end; {Case..}

    For n:=0 to PageCount-1 do
      Pages[n].Enabled:=Pages[n].Visible;
  end;
  
  If (JTMode=2) then
  Begin
    New(CRepParam);

    try
      FillChar(CRepParam^,Sizeof(CRepParam^),0);

      With CRepParam^.PParam do
      Begin
        PBatch:=BOn;
        PDevRec.Preview:=BOn;
        PDevRec.NoCopies:=1;
        Orient:=poPortrait;
        UFont:=Nil;
        RepCaption:=DocNames[DocHed]+'s';
      end;
    except
      Dispose(CRepParam);
      CRepParam:=nil;
    end;

    If (Not Get_LastSOPVal(FullSOPFile(AllocTCode,AllocSCode,100+Ord(DocHed In StkRetSalesSplit)),SOPInp)) then
    Begin

      Init_SOPInp(SOPInp);

    end;


    {$IFDEF Frm}
      With SOPInp do
      Begin

        pfSet_NDPDefaultPrinter(PDNote,WPrnName[1],2);


        If (PDNote.ItemIndex<0) then
          PDNote.ItemIndex:=0;

        If (WPrnName[1]<>'') then
          PdNote.Text:=WPrnName[1];

        pfSet_NDPDefaultPrinter(PInvDoc,WPrnName[2],2);


        If (PInvDoc.ItemIndex<0) then
          PInvDoc.ItemIndex:=0;

        If (WPrnName[2]<>'') then
          PInvDoc.Text:=WPrnName[2];


        
      end; {With..}
    {$ENDIF}

    NextRNo:=SetNextWOPRunNo(DocHed,BOff,0);


    With SOPInp do
    Begin

      Sum1.Value:=DelTag;

      Sum2.Checked:=DelPrn[1];
      Sum3.Checked:=DelPrn[2];

      AcFF.Text:=SOPMLoc;

      PrnScrnB.Checked:=PrnScrn;

      AgeInt.Value:=NextRNo;

      If (DocHed In StkRetPurchSplit) then
      Begin
        Sum2.Checked:=BOff;
        Sum3.Checked:=BOff;
        Label89.Visible:=BOff;
        AgeInt.Visible:=BOff;
      end;

    end; {With..}

    {$IFDEF SOP}
      If (Not UseEMLocStk) then
    {$ENDIF}
    Begin
      AcFF.Visible:=BOff;
      {Label83.Visible:=BOff;}
      Label811.Visible:=BOff;

    end;

  end
  else
    CRepParam:=nil;

  {LastValueObj.GetAllLastValuesFull(Self);}

  A1PActionCBChange(Nil);

  JustCreated:=BOff;

  SetWizHelp;
end;


procedure TRetWizard.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  inherited;

  If (Assigned(CRepParam)) then
    Dispose(CRepParam);

end;


procedure TRetWizard.FormDestroy(Sender: TObject);
begin
  inherited;

  ExLocal.Destroy;

  RetWActive:=BOff;

end;


procedure TRetWizard.Form2Wizard;

Begin
  With RetWizRec do
  Begin
    If (JTMode In [1,2]) then
    Begin
      If (A1PActionCB.ItemIndex>=0) then
        rwPAction:=A1PActionCB.ItemIndex+60;


      {If (A1SActionCB.ItemIndex>=0) then
        rwSAction:=A1SActionCB.ItemIndex;}

      If (A1BQtyCB.ItemIndex>=0) then
        rwPBased:=Succ(A1BQtyCB.ItemIndex);

      If (A2BQtyCB.ItemIndex>=0) then
        rwSBased:=Succ(A2BQtyCB.ItemIndex);

      rwRepairInv:=(A1RepCb.ItemIndex=1);

      {If (rwPAction In [65]) then {* Generate repair quote, move out of the way of other modes * Not supported.
        rwPAction:=68;}

      If (rwPAction In [60,61]) and (rwRepairInv) then {* We are issuing back so we need to use repair stock, not woff *}
        rwPAction:=rwPAction+5;

      If (rwPAction In [61,66]) then
        rwSAction:=Pred(rwPAction)
      else
        rwSAction:=rwPAction;

      rwRSCharge:=A1ReStockCB.Checked;

      rwIgnoreSer:=((RetWizRec.rwRepairInv) and (RetWizRec.rwSAction In [64,65])) or
                    ((RetWizRec.rwPAction In [61,66]) and (RetWizRec.rwSBased =1));

      rwAppNewPrice:=A1AppPricecb.Checked;

      rwMatch:=A1Matchcb.Checked;
    end
    else
    Begin
      rwLineQty:=PQuotF.Value;

      rwWarrantyPrice:=(A1Pricecb.ItemIndex=1);

      rwDate:=A1StartDF.DateValue;

      R1TPerF.InitPeriod(rwPR,rwYr,BOff,BOff);

      rwYourRef:=LJVar(I1YRef.Text,DocYref1Len);

      If (Syss.WarnYRef) then
        rwYourRef:=UpCaseStr(rwYourRef);

      rwLoc:=RetLocF.Text;

      rwAppendMode:=A1ARetcb.Checked;

      If (rwAppendMode) then
        rwRetRef:=I4RetF.Text
      else
        Blank(rwRetRef,Sizeof(rwRetRef));

      rwB2BRepair:=A1b2bRepcb.Checked;
      rwRetReason:=Id3StatCB1.ItemIndex;
      rwSetEQty:=A1SetExpCb.Checked;
      rwSuppCode:=FullCustCode(I1AccF.Text);
    end;
  end;
end;


procedure TRetWizard.A1PActionCBChange(Sender: TObject);
begin
  inherited;

  With RetWizRec do
  Begin
    With A1PActionCB do
    Begin
      If (ItemIndex=1) then
      Begin
        Label83.Enabled:=BOn;

      end
      else
      Begin
        A1BQtyCB.ItemIndex:=0;
        A2BQtyCB.ItemIndex:=0;        Label83.Enabled:=BOff;

      end;

      A1RepCB.Enabled:=(Not (ItemIndex In [2..5])); {and (rwDocHed In StkRetSalesSplit);}

      A1AppPriceCB.Visible:=((ItemIndex In [1])); {and (rwDocHed In StkRetSalesSplit);}

      If (Not A1RepCB.Enabled) then
        If (ItemIndex In [4]) then
          A1RepCb.ItemIndex:=1
        else
          A1RepCb.ItemIndex:=0;

      UseSystemDateChk.Visible := ItemIndex = 3;
      A1ReStockCb.Visible:=(rwDocHed In StkRetSalesSplit) and (Not (ItemIndex In [2..5]));
      A1MatchCB.Visible:=(ItemIndex In [0,1]) and (RetWizRec.rwCanMatch);
    end;

    Label85.Visible:=A1RepCB.Visible;

    If (rwDocHed In StkRetPurchSplit) then
      A1BQtyCB.Enabled:=Label83.Enabled
    else
      A2BQtyCB.Enabled:=Label83.Enabled;


  end;
end;

procedure TRetWizard.PageControl1Change(Sender: TObject);
begin
  inherited;

  With PageControl1 do
  Begin
    If (ActivePage=TabSheet3) then
    Begin
      Sum2.Visible:=(A1PActionCB.ItemIndex In [0,1]) and (RetWizRec.rwDocHed<>PRN);
      Sum3.Visible:=(A1PActionCB.ItemIndex In [1,2]) and (RetWizRec.rwDocHed<>PRN);

      PDNote.Visible:=Sum2.Visible;
      PInvDoc.Visible:=Sum3.Visible;

      PRNScrnB.Visible:=(Sum2.Visible or Sum3.Visible);

    end;
  end;
end;


procedure TRetWizard.RetLocFExit(Sender: TObject);
Var
  FoundCode  :  Str10;

  FoundOk,
  AltMod     :  Boolean;


begin
  Inherited;

  If (Sender is Text8pt) then
  With (Sender as Text8pt) do
  Begin
    FoundCode:=Name;

    AltMod:=Modified;

    FoundCode:=Trim(Text);

    If (AltMod) and (ActiveControl<>TWClsBtn)  and (FoundCode<>'') then
    Begin

      StillEdit:=BOn;

      {$IFDEF SOP}
        FoundOk:=(GetMLoc(Self.Owner,FoundCode,FoundCode,'',0));
      {$ENDIF}

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
end;

procedure TRetWizard.I4RetFEnter(Sender: TObject);
begin
  inherited;

  With I4RetF do
    If (Length(Text)=3) then
    Begin
      SelStart:=4; SelLength:=0;
    end;
end;


procedure TRetWizard.I4RetFExit(Sender: TObject);
Const
  Fnum     =   InvF;

  Keypath  =   InvOurRefK;

Var
  FoundCode  :  Str20;

  FoundOk,
  AltMod     :  Boolean;

  GenStr     :  Str255;


begin

  If (Sender is Text8pt) then
  With (Sender as Text8pt) do
  Begin
    AltMod:=Modified or JustCreated;

    FoundCode:=Trim(Text);

    If ((AltMod) and (FoundCode<>'')) and (Length(FoundCode)>3) and (ActiveControl<>TWClsBtn) then
    Begin

      awRefOk:=BOff;

      StillEdit:=BOn;

      FoundCode:=AutoSetInvKey(Text,0);

      GenStr:=FoundCode;

      Status:=Find_Rec(B_GetEq,F[Fnum],Fnum,RecPtr[Fnum]^,Keypath,GenStr);

      FoundOk:=(StatusOk and (Inv.InvDocHed=RetWizRec.rwDocHed));

      If (FoundOk) then
      With RetWizRec.rwDoc do
        FoundOk:=(((Inv.CustCode=CustCode) or (CheckKey(I1AccF.Text,Inv.CustCode,Length(I1AccF.Text),BOff))) and (Inv.Currency=Currency)) and ((Inv.RunNo=SRNUPRunNo) or (Inv.RunNo=PRNUPRunNo));

      If (FoundOk) then
      Begin

        StillEdit:=BOff;

        Text:=FoundCode;

        awRefOk:=BOn;
      end
      else
      Begin
        CustomDlg(Application.MainForm,'Please Note','Invalid Returns Reference',
                               FoundCode+' is not a valid Return reference upon which to append this transaction.'+#13+#13+
                               'The Return reference must be a valid unposted Return with matching account code and currency.',
                               mtInformation,
                               [mbOK]);

        If (CanFocus) then
          SetFocus;
      end; {If not found..}

    end;

  end; {with..}
end;

procedure TRetWizard.A1ARetcbClick(Sender: TObject);
begin
  inherited;

  I4RetF.Enabled:=A1ARetcb.Checked;

  If (A1ARetcb.Checked) then
  Begin
    I4RetF.Modified:=BOn;

    I4RetFExit(I4RetF);
  end;
end;


procedure TRetWizard.I1AccFClick(Sender: TObject);
Var
  FoundCode  :  Str20;

  FoundOk,
  AltMod     :  Boolean;


begin
  Inherited;

  If (Sender is Text8pt) then
  With (Sender as Text8pt) do
  Begin
    AltMod:=Modified;

    FoundCode:=Strip('B',[#32],Text);

    If ((AltMod) or (FoundCode='')) and (ActiveControl<>TWClsBtn) then
    Begin
      {$IFDEF CUXX} {* Call hooks here *}

        FoundCode:=TextExitHook(2000,6,FoundCode,ExLocal);

      {$ENDIF}

      StillEdit:=BOn;

      FoundOk:=(GetCust(Self,FoundCode,FoundCode,BOff,3));

      If (FoundOk) then
      With ExLocal,LInv do
      Begin
        StillEdit:=BOff;

        Text:=FoundCode;

        SendToObjectCC(FoundCode,0);

      end
      else
      Begin
        If (CanFocus) then
          SetFocus;
      end; {If not found..}
    end;

  end; {with..}
end;


procedure TRetWizard.A1StartDFExit(Sender: TObject);

Var
  WP,WY  :  Byte;

begin
  inherited;

  If (Syss.AutoPrCalc) then  {* Set Pr from input date *}
  With ExLocal,A1StartDF,R1TPerF do
  Begin
    Date2Pr(A1StartDF.DateValue,WP,WY,@ExLocal);

    InitPeriod(WP,WY,BOn,BOn);
  end;

end;


Function TRetWizard.CheckCompleted(Edit,MainChk  :  Boolean)  : Boolean;

Const
  NofMsgs      =  8;

Type
  PossMsgType  = Array[1..NofMsgs] of Str255;

Var
  PossMsg  :  ^PossMsgType;

  ExtraMsg,
  ExtraMsg2:  Str255;

  Test     :  Byte;

  FoundCode:  Str20;

  Loop,
  ShowMsg  :  Boolean;

  mbRet    :  Word;

  MaxBuild,
  FoundLong
           :  LongInt;

  GenStr,
  GenStr2  :  Str255;


Begin
  New(PossMsg);


  FillChar(PossMsg^,Sizeof(PossMsg^),0);

  PossMsg^[1]:='There are no Written off Return lines. You must select the amount of returned stock to credit';
  PossMsg^[2]:='There are no Repaired Return lines. You must select the amount of returned stock to Repair';
  PossMsg^[3]:='There are no Repaired Return lines. You must select the amount of returned stock to Issue back to stock';
  PossMsg^[4]:='Warn serial & multi bin items will not be processed in a run';
  PossMsg^[5]:='The returned quantity cannot exceed the original quantity';
  PossMsg^[6]:='That Return reference is not valid';
  PossMsg^[7]:='That Supplier Account is not valid';
  PossMsg^[8]:='There is not enough stock ';



  Loop:=BOff;

  Test:=1;

  Result:=BOn;

  MaxBuild:=0;

  While (Test<=NofMsgs) and (Result) do
  With RetWizRec do
  Begin
    ExtraMsg:='';  ExtraMsg2:='';  GenStr2:='';

    ShowMsg:=BOn;

    Case Test of

      1  :  Begin
              If (RetWizRec.rwPAction In [60,61,63]) and (JTMode=1) then
                Result:=(SOP_Check4Pick(IDetailF,IdFolioK,Inv,'',RetWizRec.rwSAction));
            end;

      2  :  Begin
              If (RetWizRec.rwPAction In [62])  and (JTMode=1)  then
                Result:=(SOP_Check4Pick(IDetailF,IdFolioK,Inv,'',RetWizRec.rwSAction));
            end;
      3  :  Begin
              If (RetWizRec.rwPAction In [64..66]) and (JTMode=1)  then
                Result:=(SOP_Check4Pick(IDetailF,IdFolioK,Inv,'',RetWizRec.rwSAction));
            end;

      4  :  Begin
              Result:=(JTMode<>2) or (Not (RetWizRec.rwPAction In [61,64])) or (Not rwIgnoreSer);

              If (Not Result) then
              Begin
                Result:=BOn;

                If (rwIgnoreSer) then
                Begin
                  ShowMsg:=BOff;

                  {$IFDEF SOP}
                    GenStr:='Serial && Multi Bin';
                  {$ELSE}
                    GenStr:='Multi Bin';

                  {$ENDIF}

                  If (RetWizRec.rwPAction In [61]) and (RetWizRec.rwSBased =1) and (CheckNegStk) then
                    GenStr2:='In addition, any Return being replaced with insufficient stock will also be excluded.'#13+#13
                  else
                    GenStr2:=#13;

                  Result:=(CustomDlg(Application.MainForm,'Please Note',GenStr+' Returns!',
                               'Due to the requirement for allocating '+GenStr+' items individually,'+
                               ' any Return transactions containing '+GenStr+' items will be excluded from this run.'#13+
                               GenStr2+
                               'Please confirm you wish to proceed with the run on this basis.',
                               mtConfirmation,
                               [mbOK,mbCancel])=mrOk);

                end
                else
                  Result:=BOn;
              end;

            end;

      5  :  Begin
              Result:=(Not (JTMode In [10,11])) or (Round_Up(RetWizRec.rwLineQty,Syss.NoQtyDec)<=Round_Up(RetWizQty,Syss.NoQtyDec));

              ExtraMsg:='('+Form_Real(RetWizRec.rwLineQty,0,Syss.NoQtyDec)+'). ';

              ExtraMsg2:='. ('+Form_Real(RetWizQty,0,Syss.NoQtyDec)+')';

              If (Not Result) and (RetWizRec.rwDoc.InvDocHed=SRN) then
                ExtraMsg2:=ExtraMsg2+#13+#13+'When generating a back to back Return, the items on the Sales Return must be returned to stock first before they can be placed on the Purchase Return.';

            end;
      6  :  Begin
              Result:=(Not (JTMode In [0,10,11])) or (awRefOk) or (Trim(RetWizRec.rwRetRef)='');
            end;

      7  :  Begin
              {$B-}
                Result:=(Not (RetWizRec.rwDoc.InvDocHed In StkRetSalesSplit)) or (Not (JTMode In [0,10,11])) or (((GetCust(Self,RetWizRec.rwSuppCode,FoundCode,BOff,-1))
                        and (Not EmptyKey(RetWizRec.rwSuppCode,CustKeyLen)) and (Cust.AccStatus<=AccClose)));
              {$B+}
            end;

      8  :  Begin
              Result:=Ret_Check4Stk(IDetailF,IdFolioK,Inv,RetWizRec,RetWizRec.rwPAction);

              If (Not Result) then
              Begin
                With Stock do
                  ExtraMsg2:=dbFormatName(StockCode,Desc[1])+'.';

              end;
            end; {8..}  


    end;{Case..}

    If (Result) then
      Inc(Test);

  end; {While..}

  If (Not Result) and (ShowMsg) and (Not MainChk) then
    mbRet:=MessageDlg(ExtraMsg+PossMsg^[Test]+ExtraMsg2,mtWarning,[mbOk],0);

  Dispose(PossMsg);

end; {Func..}

Function TRetWizard.GetPageCount  :  Integer;
Begin
  Result:=1+Ord(JTMode=2);

end;


Function TRetWizard.GetEndPageCount  :  Integer;
Begin
  Result:=1+Ord(JTMode=2);

end;

{ ======= Link to Trans display ======== }

procedure TRetWizard.Display_GlobalTrans(Mode  :  Byte);

Var
  KeyS  :  Str255;
Begin

  ExLocal.LastInv:=ExLocal.LInv;

  With TFInvDisplay.Create(Self.Owner) do
  Begin
    ExLocal.AssignToGlobal(InvF);
    try

      KeyS:=ExLocal.LInv.OurRef;

      With ExLocal do
      If (Find_Rec(B_GetEq,F[InvF],InvF,LRecPtr[InvF]^,InvOurRefK,KeyS)=0) then
      Begin

        LastDocHed:=LInv.InvDocHed;

        Display_Trans(Mode,0,BOff,BOn);

      end; {with..}

    except

      Free;

    end;
  end;

  ExLocal.LInv:=ExLocal.LastInv;
end;


procedure TRetWizard.FinishAction;

Var
  n  :  Byte;

  GenCredit
     :  Boolean;

  {$IFDEF FRM}

    MsgForm  :  TSOPRunFrm;

  {$ENDIF}

Begin
  GenCredit:=BOff;

  Case JTMode of
    0,10,11
       :  Begin
            GlobAppRetRef[RetWizRec.rwDocHed In StkRetSalesSPlit]:=I4RetF.Text;

            If (Genereate_RetFromDoc(RetWizRec,ExLocal,ExLocal.LInv)) then
            Begin

              If (Trim(GlobAppRetRef[RetWizRec.rwDocHed In StkRetSalesSPlit])='') then
                GlobAppRetRef[RetWizRec.rwDocHed In StkRetSalesSPlit]:=ExLocal.LInv.OurRef;


            {* Unlock source *}

              Begin
                Display_GlobalTrans(2);

                PostMessage(TForm(Self.Owner).Handle,WM_CustGetRec,182,0);
              end;
            end; {If..}
          end;
    1  :  Begin
            If (Not (RetWizRec.rwPAction In [60,61])) or (RetWizRec.rwDoc.InvNetVal<>0.0) then
              GenCredit:=Genereate_ActionDocFromRet(RetWizRec,ExLocal,ExLocal.LInv);

            If (GenCredit) or (RetWizRec.rwPAction=63) or ((RetWizRec.rwPAction In [60,61]) and (RetWizRec.rwDoc.InvNetVal=0.0)) then
            Begin

            {* Unlock source *}

              If (RetWizRec.rwPAction In [60,61,62,65,66,68]) and (GenCredit) then
              Begin
                Display_GlobalTrans(2);

                PostMessage(TForm(Self.Owner).Handle,WM_CustGetRec,182,0);
              end;

              With RetWizRec do
              Begin
                If (rwPAction In [61,66]) then
                Begin
                  rwSAction:=rwPAction;
                  If Genereate_ActionDocFromRet(RetWizRec,ExLocal,ExLocal.LInv) and (rwPAction<>64) then {Generate Delivery invoice}
                  Begin
                    Display_GlobalTrans(2);

                    PostMessage(TForm(Self.Owner).Handle,WM_CustGetRec,182,0);

                    {$IFDEF SOP}
                      If (RetWizRec.rwSBased=3) and (RetWizRec.rwDocHed In StkRetSalesSplit) then {Its an SOR with back2back, raise back2back wizard}
                        Run_B2BWizard(Inv,Application.MainForm);
                    {$ENDIF}


                  end;
                end;

                Inv:=RetWizRec.rwDoc;


                {$IFDEF FRM}
                  Begin
                    {* We are returning to stock as part of write off or Repair *}
                    If (rwPAction In [{62,}64]) {and (rwRepairInv)} and (rwDocHed In StkRetSalesSplit) then
                      rwSAction:=101;

                    rwUseSystemDate := UseSystemDateChk.Checked;
                    Start_RETRun(DocHed,rwSAction,BOn,RetWizRec,Self.Owner);
                  end;
                {$ENDIF}

              end; {With..}
            end; {If..}
          end;

    2  :  With CRepParam^,PParam,SopInp do
          Begin


            {$IFDEF FRM}
              If (pf_Check4Printers) then
            {$ENDIF}
            Begin

              DelPrn[1]:=Sum2.Checked;
              DelPrn[2]:=Sum3.Checked;

              PrnScrn:=PrnScrnB.Checked;

              NextRNo:=Round(AgeInt.Value);

              WPrnName[1]:=Copy(PDNote.Text,1,20);

              WPrnName[2]:=Copy(PInvDoc.Text,1,20);


              SOPMLoc:=AcFF.Text;

              DelTag:=Round(Sum1.Value);

              PSopInp:=SopInp;

              Put_LastSOPVal(AllocSCode,SOPInp,100+Ord(DocHed In StkRetSalesSplit));

              RetWizRec.rwRun:=BOn;

              

              {$IFDEF FRM}

                MsgForm:=TSOPRunFrm.Create(Self);

                try
                  With MsgForm do
                  Begin
                    {* Update here for single document *}

                    {If (SingDoc) then
                      NextRNo:=SetNextWOPRunNo(DocHed,SingDoc,0);}

                    PCRepParam:=CRepParam;
                    PDocHed:=RetWizRec.rwDocHed;
                    ThisRun:=NextRNo;
                    ThisMode:=100;
                    DRetWizRec:=RetWizRec;
                    SingleDoc:=BOff;


                    SetAllowHotKey(BOff,PrevHState);

                    Set_BackThreadMVisible(BOn);

                    ShowModal;

                    Set_BackThreadMVisible(BOff);

                    SetAllowHotKey(BOn,PrevHState);

                  end;

                Finally
                  MsgForm.Free;

                  PostMessage(TForm(Self.Owner).Handle,WM_CustGetRec,182,0);
                end; {try..}
              {$ENDIF}
             end
             {$IFDEF FRM}
               else
                 MessageDlg ('A printer must be defined before anything can be printed!', mtWarning, [mbOk], 0);
             {$ELSE}
               ;

             {$ENDIF}
          end;

  end; {Case..}
end;

procedure TRetWizard.TryFinishWizard;

Var
  SuppOk  :  Boolean;

Begin
  Form2Wizard;

  SuppOk:=CheckCompleted(BOff,BOff);


  If (SuppOk) then
  Begin
    {Create J?A}

    LastValueObj.UpdateAllLastValues(Self);

    Self.Enabled:=BOff;

    {* Lock source *}
    //Generate_JAFromJT(ord(JAppWizRec.awJCTRef=''),JAppWizRec,ExLocal);

    FinishAction;

    PostMessage(Self.Handle,WM_Close,0,0);

  end;
end;




procedure TRetWizard.SetWizHelp;

Begin

end;



Procedure Gen_RetDocWiz(InvR  :  InvRec;
                        IdR   :  IDetail;
                        Mode  :  Byte;
                        AOwner:  TWinControl);

Var
  DocHed  :  DocTypes;

Begin
  If (InvR.InvDocHed In SalesSplit) then
    DocHed:=SRN
  else
    DocHed:=PRN;

  Set_RetWiz(InvR,IdR,DocHed,'',Mode,0);

  with TRetWizard.Create(AOwner) do
    Show;

end;


Procedure Gen_RetSerWiz(RetSerial  :  MiscRec;
                        UseOutDoc  :  Boolean;
                        AOwner     :  TWinControl);

Var
  DocHed  :  DocTypes;

  mbRet   :  Word;

  InvR    :  InvRec;
  IdR     :  IDetail;

  RetRef  :  Str10;
  KeyI    :  Str255;

Begin
  With RetSerial.SerialRec do
  Begin
    InvR:=Inv;  IdR:=Id;  RetRef:=''; mbRet:=mrCancel;

    If (USeOutDoc) then
      KeyI:=OutDoc
    else
      KeyI:=InDoc;

    NoteFolio:=0; {* Temp assign Notefolio to Serial no address so we get exact record back *}

    Status:=GetPos(F[MiscF],MiscF,NoteFolio);  {* Preserve DocPosn *}

    If ((GetDocType(KeyI) In StkRetGenSplit)) then
    Begin
      If (Find_Rec(B_GetEq,F[InvF],InvF,RecPtr[InvF]^,InvOurRefK,KeyI)=0) then
      Begin
        If (USeOutDoc) then
          KeyI:=FullIdKey(Inv.FolioNum,SoldLine)
        else
          KeyI:=FullIdKey(Inv.FolioNum,BuyLine);

        If (Find_Rec(B_GetEq,F[IdetailF],IdetailF,RecPtr[IdetailF]^,IdLinkK,KeyI)=0) then
        Begin
          If (CheckExsiting_RET(Inv,Id,RETRef,BOn)) then
          Begin
            mbRet:=CustomDlg(Application.MainForm,'Please note','Return Exists',
                                    'Return '+RETRef+' already exists for this Serial/Batch item.'+#13+#13+
                                    'Please confirm you want to create another Return for this Serial/Batch item.',mtConfirmation,[mbOk,mbCancel]);
          end
          else
            mbRet:=mrOk;

          If (mbRet=mrOk) then
          Begin

            If (Inv.InvDocHed In SalesSplit) then
              DocHed:=SRN
            else
              DocHed:=PRN;

            If (BatchRec) then
            Begin
              KeyI:=BatchNo;
              If (BatchChild) then
                Id.Qty:=QtyUsed
              else
                Id.Qty:=BuyQty;
            end
            else
            Begin
              KeyI:=SerialNo;
              Id.Qty:=1.0;
            end;



            Set_RetWiz(Inv,Id,DocHed,KeyI,11,0);

            with TRetWizard.Create(AOwner) do
            Begin
              Show;

              RetWizRec.rwSerialRec:=RetSerial;
            end;
          end; {If Not one already..}
        end; {If Id found ok..}
      end; {If Found Invheader }
    end
    else
      CustomDlg(Application.MainForm,'Please Note','Invalid Basis for a Return',
                               KeyI+' is not a valid transaction from which to base a Return upon.'+#13+#13+
                               'A Return can only be based on an account code based transaction.',
                               mtInformation,
                               [mbOK]);

    Inv:=InvR; Id:=IdR;
  end; {With..}
end;

// MHYR 25/10/07
procedure TRetWizard.I1YRefChange(Sender: TObject);
begin
  inherited;
  I1YRef.Hint := I1YRef.Text;
end;

procedure TRetWizard.TWPrevBtnClick(Sender: TObject);
begin
  // MH 15/12/2010 v6.6 ABSEXCH-10548: Set focus to OK button to trigger OnExit event on date and Period/Year
  //                                   fields which processes the text and updates the value
  If (Sender = TWNextBtn) And (ActiveControl <> TWNextBtn) And TWNextBtn.CanFocus Then
    TWNextBtn.SetFocus;

  inherited;

end;

Initialization
  LocalInv:=Nil;
  LocalId:=Nil;
  RetWizard:=Nil;
  RetWActive:=BOff;

  LocalRetAddr:=0;
  LocalAc:='';

  FillChar(GlobAppRetRef,Sizeof(GlobAppRetRef),#0);

Finalization
  If (Assigned(LocalInv)) then
    Dispose(LocalInv);

  If (Assigned(LocalId)) then
    Dispose(LocalId);


end.
