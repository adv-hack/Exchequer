unit RepInp7U;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  Repinp1u, StdCtrls, bkgroup, BTSupU3, TEditVal, Mask, ExtCtrls, Animate,
  SBSPanel;

type
  TRepInpMsg7 = class(TRepInpMsg)
    DocFiltF: Text8Pt;
    I1PrYrF: TEditPeriod;
    I2PrYrF: TEditPeriod;
    Label81: Label8;
    CurrF: TSBSComboBox;
    Label83: Label8;
    Id3CCF: Text8Pt;
    Id3DepF: Text8Pt;
    Label82: Label8;
    ACFF: Text8Pt;
    Label84: Label8;
    Label85: Label8;
    Label86: Label8;
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure DocFiltFExit(Sender: TObject);
    procedure Id3CCFExit(Sender: TObject);
    procedure ACFFExit(Sender: TObject);
    procedure OkCP1BtnClick(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure FormKeyPress(Sender: TObject; var Key: Char);
    function I1PrYrFShowPeriod(Sender: TObject; const EPr: Byte): String;
    function I1PrYrFConvDate(Sender: TObject; const IDate: String;
      const Date2Pr: Boolean): String;
  private
    { Private declarations }
    RepMode    :  Byte;
    CRepParam  :  DocRepPtr;

  public
    { Public declarations }
  end;


procedure Doc_Report(IdMode  :  Byte;
                     AOwner  :  TComponent);

{~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~}

Implementation

{~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~}

Uses
  ETStrU,
  ETDateU,
  ETMiscU,
  GlobVar,
  VarConst,

  InvListU,
  Report3U,

  SysU1,
  SysU2,
  BTSupU2,

  // MH 07/02/2012 v6.10 ABSEXCH-12202: Added SLQ variants for the Sales and Purchase Daybook reports
  SQLUtils,
  SQLRep_Config,
  SQLRep_TransactionDaybooks;

{$R *.DFM}

Var
  GRNo  :  Byte;

procedure TRepInpMsg7.FormCreate(Sender: TObject);

Var
  HideCC  :  Boolean;
  RMode   :  Integer;

  LPr,LYr,
  SPr     :  Byte;

begin
  inherited;

  ClientHeight:=200;
  ClientWidth:=299;

  {$IFDEF MC_On}

    Set_DefaultCurr(CurrF.Items,BOn,BOff);
    Set_DefaultCurr(CurrF.ItemsL,BOn,BOn);
    CurrF.ItemIndex:=0;

  {$ELSE}
    Label81.Visible:=BOff;
    CurrF.Visible:=BOff;

  {$ENDIF}

    HideCC:=BOff;


  {$IFNDEF PF_On}

    HideCC:=BOn;

  {$ELSE}

    HideCC:=Not Syss.UseCCDep;
  {$ENDIF}

  Id3CCF.Visible:=Not HideCC;
  Id3DepF.Visible:=Not HideCC;
  Label83.Visible:=Not HideCC;

  New(CRepParam);

  try
    FillChar(CRepParam^,Sizeof(CRepParam^),0);
  except
    Dispose(CRepParam);
    CRepParam:=nil;
  end;

  RepMode:=GRNo;


  If (RepMode<>0) then
  Begin
    Label86.Visible:=BOff;
    DocFiltF.Visible:=BOff;
  end;


  SPr:=1;

  LPr:=GetLocalPr(0).CPr;
  LYr:=GetLocalPr(0).CYr;

  I1PrYrF.InitPeriod(SPr,LYr,BOn,BOn);
  I2PrYrF.InitPeriod(LPr,LYr,BOn,BOn);


  RMode:=Round(RepMode/10);

  Caption:=DocAnalRepTits[RMode];

  Case RMode of
    0  :  HelpContext:=677;
    1,2
       :  HelpContext:=712;
    3,5
       :  HelpContext:=713;
    4,6
       :  HelpContext:=714;
  end; {Case..}

  SetLastValues;
end;

procedure TRepInpMsg7.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  inherited;

  If (Assigned(CRepParam)) then
    Dispose(CRepParam);

end;

procedure TRepInpMsg7.DocFiltFExit(Sender: TObject);

Var
  AltMod    :  Boolean;
  FoundCode :  Str20;
  DT        :  DocTypes;

begin
  inherited;

  DT:=SIN;

  If (Sender is Text8pt) then
  With (Sender as Text8pt) do
  Begin
    AltMod:=Modified;

    FoundCode:=Strip('B',[#32],Text);

    If (AltMod) and (ActiveControl<>ClsCP1Btn) and (FoundCode<>'') then
    Begin
      Dt:=DocTypeFCode(FoundCode);


      If (DT=SKF) then
      Begin
        ShowMessage('That filter is not valid.'+#13+#13+'Please enter a full, or part document type.');
        SetFocus;
      end;
    end;
  end;
end;




procedure TRepInpMsg7.Id3CCFExit(Sender: TObject);
Var
  FoundCode  :  Str20;

  FoundOk,
  AltMod     :  Boolean;

  IsCC       :  Boolean;


begin
  Inherited;

  {$IFDEF PF_On}

    If (Sender is Text8pt) then
    With (Sender as Text8pt) do
    Begin
      FoundCode:=Name;

      IsCC:=Match_Glob(Sizeof(FoundCode),'CC',FoundCode,FoundOk);

      AltMod:=Modified;

      FoundCode:=Strip('B',[#32],Text);

      If (AltMod) and (ActiveControl<>ClsCP1Btn) and
          (Syss.UseCCDep)  and (FoundCode<>'') and (Not Has_CCWildChar(FoundCode)) then
      Begin

        StillEdit:=BOn;

        FoundOk:=(GetCCDep(Self,FoundCode,FoundCode,IsCC,0));


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

procedure TRepInpMsg7.ACFFExit(Sender: TObject);
Var
  FoundCode  :  Str20;

  FoundOk,
  AltMod     :  Boolean;
  DBIdx      :  SmallInt;


begin
  Inherited;

  If (Sender is Text8pt) then
  With (Sender as Text8pt) do
  Begin
    FoundCode:=Name;

    AltMod:=Modified;

    FoundCode:=Strip('B',[#32],Text);

    If (AltMod) and (ActiveControl<>ClsCP1Btn)  and (FoundCode<>'') then
    Begin

      StillEdit:=BOn;

      dbIdx:=Round(RepMode/10);

      FoundOk:=(GetCust(Self,FoundCode,FoundCode,(dbIdx In [1,3,5]),99*Ord(RepMode=0)));


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

procedure TRepInpMsg7.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  {}
  Inherited;
end;

procedure TRepInpMsg7.FormKeyPress(Sender: TObject; var Key: Char);
begin
  {}
  Inherited;
end;

function TRepInpMsg7.I1PrYrFShowPeriod(Sender: TObject;
  const EPr: Byte): String;
begin
  inherited;
  Result:=RepInpPPr_Pr(EPr);
end;

function TRepInpMsg7.I1PrYrFConvDate(Sender: TObject; const IDate: String;
  const Date2Pr: Boolean): String;
begin
  inherited;
  Result:=RepInpConvInpPr(IDate,Date2Pr);
end;



procedure TRepInpMsg7.OkCP1BtnClick(Sender: TObject);
begin
  If (Sender=OkCP1Btn) then
  Begin
    If AutoExitValidation Then
    Begin
      With CRepParam^ do
      Begin
        OKCP1Btn.Enabled:=BOff;
        {$IFDEF MC_On}
          RCr:=CurrF.ItemIndex;
        {$ENDIF}

        RCCDep[BOff]:=Id3DepF.Text;
        RCCDep[BOn]:=Id3CCF.Text;

        I1PrYrF.InitPeriod(RPr,RYr,BOff,BOff);
        I2PrYrF.InitPeriod(RPr2,RYr2,BOff,BOff);

        CustFilt:=AcFF.Text;
        DocWanted:=DocFiltF.Text;

        // MH 07/02/2012 v6.10 ABSEXCH-12202: Added SQL variants for the Sales and Purchase Daybook reports
        If SQLUtils.UsingSQLAlternateFuncs Then
        Begin
          If SQLReportsConfiguration.UseSQLSalesDaybookReport And (RepMode = Byte(Ord(tdrSales))) Then
            SQLReport_PrintTransactionDaybookReports (Owner, tdrSales, CRepParam^)
          Else If SQLReportsConfiguration.UseSQLPurchaseDaybookReport And (RepMode = Byte(Ord(tdrPurchase))) Then
            SQLReport_PrintTransactionDaybookReports (Owner, tdrPurchase, CRepParam^)
          // MH 19/06/2012 ABSEXCH-12965 v7.0: Added support for additional Daybook Reports
          Else If SQLReportsConfiguration.UseSQLDocumentAnalysisReport And (RepMode = Byte(Ord(tdrDocumentAnalysis))) Then
            SQLReport_PrintTransactionDaybookReports (Owner, tdrDocumentAnalysis, CRepParam^)
          Else If SQLReportsConfiguration.UseSQLReceiptsReport And (RepMode = Byte(Ord(tdrReceipts))) Then
            SQLReport_PrintTransactionDaybookReports (Owner, tdrReceipts, CRepParam^)
          Else If SQLReportsConfiguration.UseSQLPaymentsReport And (RepMode = Byte(Ord(tdrPayments))) Then
            SQLReport_PrintTransactionDaybookReports (Owner, tdrPayments, CRepParam^)
          Else If SQLReportsConfiguration.UseSQLSalesOrderReport And (RepMode = Byte(Ord(tdrSalesOrder))) Then
            SQLReport_PrintTransactionDaybookReports (Owner, tdrSalesOrder, CRepParam^)
          Else If SQLReportsConfiguration.UseSQLPurchaseOrderReport And (RepMode = Byte(Ord(tdrPurchaseOrder))) Then
            SQLReport_PrintTransactionDaybookReports (Owner, tdrPurchaseOrder, CRepParam^)
          Else If SQLReportsConfiguration.UseSQLNominalReport And (RepMode = Byte(Ord(tdrNominal))) Then
            SQLReport_PrintTransactionDaybookReports (Owner, tdrNominal, CRepParam^)
          Else
            AddDocRep2Thread(RepMode,0,CRepParam,Owner);
        End // If SQLUtils.UsingSQLAlternateFuncs
        Else
          AddDocRep2Thread(RepMode,0,CRepParam,Owner);
      end;

      inherited;
    End // If AutoExitValidation
    Else
      ModalResult := mrNone;
  End // If (Sender=OkCP1Btn)
  Else
    inherited;
end;


procedure Doc_Report(IdMode  :  Byte;
                     AOwner  :  TComponent);

Var
  RepInpMsg1  :  TRepInpMsg7;

Begin
  GRNo:=IdMode;

  RepInpMsg1:=TRepInpMsg7.Create(AOwner);

end;



end.
