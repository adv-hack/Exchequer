unit RepInp9U;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  Repinp1u, StdCtrls, bkgroup, BTSupU3, TEditVal, Mask, BorBtns, ExtCtrls,
  Animate, SBSPanel, ComCtrls, GlobVar;

type
  TRepInpMsg9 = class(TRepInpMsg)
    AgeInt: TCurrencyEdit;
    Label85: Label8;
    AgeInt2: TCurrencyEdit;
    Label82: Label8;
    Label81: Label8;
    ACFF: Text8Pt;
    ACCF2: Text8Pt;
    Label83: Label8;
    Label84: Label8;
    CurrF: TSBSComboBox;
    CurrF2: TSBSComboBox;
    I1PrYrF: TEditPeriod;
    Label87: Label8;
    I2PrYrF: TEditPeriod;
    Label88: Label8;
    Id3CCF: Text8Pt;
    Id3DepF: Text8Pt;
    Label89: Label8;
    AccF3: Text8Pt;
    DocFiltF: Text8Pt;
    Label810: Label8;
    Label811: Label8;
    Sum1: TBorCheck;
    CommitMCB: TSBSComboBox;
    ccTagChk: TBorCheck;
    UPF: TBorRadio;
    UDF: TBorRadio;
    I1TransDateF: TEditDate;
    Label812: Label8;
    I2TransDateF: TEditDate;
    chkPrintParameters: TBorCheck;
    cbAccountTypes: TSBSComboBox;
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure ACFFExit(Sender: TObject);
    procedure Id3CCFExit(Sender: TObject);
    procedure AccF3Exit(Sender: TObject);
    procedure DocFiltFExit(Sender: TObject);
    procedure OkCP1BtnClick(Sender: TObject);
    function I1PrYrFShowPeriod(Sender: TObject; const EPr: Byte): String;
    function I1PrYrFConvDate(Sender: TObject; const IDate: String;
      const Date2Pr: Boolean): String;
    procedure AgeInt2Exit(Sender: TObject);
    procedure AgeIntExit(Sender: TObject);
  private
    { Private declarations }
    RepMode    :  Byte;

    CRepParam  :  DocRepPtr;

    procedure SetHelpContextIDs; // NF: 10/05/06

  public
    { Public declarations }
  end;

procedure ANH_Report(IdMode  :  Byte;
                     AOwner  :  TComponent);

procedure Nom_Report(IdMode  :  Byte;
                     AOwner  :  TComponent);


procedure PrintRangeDocs(AOwner  :  TComponent);


{$IFDEF PF_On}

  procedure CCDep_Report(AOwner  :  TComponent);

  procedure ECVAT_Report(AOwner  :  TComponent);

{$ENDIF}

{$IFDEF STK}
  procedure Stk_Report(IdMode  :  Byte;
                       AOwner  :  TComponent);

  procedure PriceL_Report(AOwner  :  TComponent);

  procedure PBreak_Report(IdMode  :  Byte;
                          AOwner  :  TComponent);

  procedure SRecon_Report(IdMode  :  Byte;
                          AOwner  :  TComponent);

  procedure SList_Report(IdMode  :  Byte;
                         AOwner  :  TComponent);

  procedure SVal_Report(IdMode  :  Byte;
                        AOwner  :  TComponent);

  procedure SHist_Report(IdMode  :  Byte;
                         AOwner  :  TComponent);

  procedure SKit_Report(IdMode  :  Byte;
                         AOwner  :  TComponent);

  procedure SBOrd_Report(IdMode  :  Byte;
                         AOwner  :  TComponent);

  procedure SShort_Report(IdMode  :  Byte;
                          AOwner  :  TComponent);

  procedure StkLab_Report(AOwner  :  TComponent);


  procedure WOP_Report(IdMode  :  Byte;
                     AOwner  :  TComponent);

  procedure WOPWIP_Report(IdMode  :  Byte;
                          AOwner  :  TComponent);

  procedure Bin_Report(IdMode  :  Byte;
                       DocRef  :  Str10;
                       AOwner  :  TComponent);


  procedure RET_Report(IdMode  :  Byte;
                       SalesMode
                               :  Boolean;
                       AOwner  :  TComponent);

{$ENDIF}

procedure VAT_Report(IDMode  :  Byte;
                     AOwner  :  TComponent);

procedure VAT_ReportIE(IDMode  :  Byte;
                       AOwner  :  TComponent);

procedure VAT_ReportNZ(IDMode  :  Byte;
                       AOwner  :  TComponent);


{~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~}

Implementation

{~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~}

Uses
  ETStrU,
  ETDateU,
  ETMiscU,

  VarConst,

  InvListU,
  Report3U,

  SysU1,
  SysU2,
  BTSupU2,

  RepInpPU,

  {$IFDEF PF_On}
    RepInpBU,
    RepInpFU,
  {$ENDIF}

  {$IFDEF STK}
    RepInpCU,
    RepInpDU,
    RepInpGU,
    RepInpHU,
    RepInpJU,
    RepInpKU,
    RepInpLU,
    RepInpMU,
    RepInpNU,
    RepInpOU,
    RepInpXU,
    RepInpYU,

    RepInpRU,

    {$IFDEF SOP}
      ReportDU,
    {$ENDIF}

    RepIRT1U,
  {$ENDIF}

  {$IFNDEF SOPDLL}
  // ABSEXCH-14371. Online submission of VAT 100 return
  // 18/07/2013. PKR
  VATSub,
  {$ENDIF}
    
  RepInpAU,
  RepInpVU,
  RepInpWU,
  RepInpEU,
  //GS 02/03/2012 ABSEXCH-12200 : requirements for new SQL GLHistory report
  GLHistoryReportSQL,
  SQLUtils,
  SQLCCDeptList,
  typinfo, ReportU, ExThrd2U,SQLRep_Config;

{$R *.DFM}

Var
  GRNo  :  Byte;


procedure TRepInpMsg9.FormCreate(Sender: TObject);

Const
  RepTit  :  Array[2..9] of Str80 = ('General Ledger History Report','General Ledger Audit Trail',
                                      '','','',
                                      'Document Audit Report','Customer Trading History Report',
                                      'Supplier Trading History Report');

Var
  HideCC  :  Boolean;
  LPr,LYr  :  Byte;


begin
  inherited;
//  ClientHeight:=255;
  ClientHeight:=278;
  ClientWidth:=420;

  RepMode:=GRNo;

  {$IFDEF MC_On}

    Set_DefaultCurr(CurrF.Items,BOn,BOff);
    Set_DefaultCurr(CurrF.ItemsL,BOn,BOn);
    CurrF.ItemIndex:=0;

    Set_DefaultCurr(CurrF2.Items,BOn,BOff);
    Set_DefaultCurr(CurrF2.ItemsL,BOn,BOn);
    CurrF2.ItemIndex:=0;

  {$ELSE}
    Label84.Visible:=BOff;
    CurrF.Visible:=BOff;
    Label811.Visible:=BOff;
    CurrF2.Visible:=BOff;

  {$ENDIF}

    HideCC:=BOff;


  {$IFNDEF PF_On}

    HideCC:=BOn;

  {$ELSE}

    HideCC:=(Not Syss.UseCCDep or (Repmode=7));

  {$ENDIF}

  Id3CCF.Visible:=Not HideCC;
  Id3DepF.Visible:=Not HideCC;
  Label88.Visible:=Not HideCC;

  ccTagChk.Visible:=Not HideCC and (RepMode In [2,3]);

  {$IFDEF SOP}
    If (RepMode=2) and (CommitAct) then
    Begin
      If (HideCC) then
        CommitMCB.Left:=Id3CCF.Left;

      CommitMCB.Visible:=BOn;
      CommitMCB.ItemIndex:=0;
    end;
  {$ENDIF}

  // MH 30/10/2013 v7.X MRD1.1: Added customer/Consumer support to Customer Trading History Report
  // MH 14/01/2014 v7.0.8 ABSEXCH-14941: Hide Include Account Types combo if Consumers turned off
  cbAccountTypes.Visible := (RepMode = 8) And Syss.ssConsumersEnabled;

  New(CRepParam);

  try
    FillChar(CRepParam^,Sizeof(CRepParam^),0);
  except
    Dispose(CRepParam);
    CRepParam:=nil;
  end;


  Case RepMode of

    2  :  HelpContext:=627;
    3  :  HelpContext:=709;
    7  :  HelpContext:=710;
    8,9
       :  HelpContext:=704;
  end; {Case..}


  AgeInt.Value:=0;

  If (Not (RepMode In [3,7])) then
  Begin
    Label85.Visible:=BOff;
    Label82.Visible:=BOff;

    AgeInt.Visible:=BOff;
    AgeInt2.Visible:=BOff;
  end
  else
    AgeInt2.Value:=MaxInt;

  UDF.Visible:=(RepMode=2);
  I1TransDateF.Visible:=(RepMode=2);
  I2TransDateF.Visible:=(RepMode=2);
  Label812.Visible:=(RepMode=2);

  If (RepMode In [7..9]) then
  Begin
    Label81.Visible:=BOff;
    Label83.Visible:=BOff;
    AcFF.Visible:=BOff;
    AccF2.Visible:=BOff;

  end;

  Sum1.Visible:=(RepMode In [8,9]);

  LPr:=GetLocalPr(0).CPr;
  LYr:=GetLocalPr(0).CYr;

  I1PrYrF.InitPeriod(LPr,LYr,BOn,BOn);
  I2PrYrF.InitPeriod(LPr,LYr,BOn,BOn);


  Caption:=RepTit[RepMode];

  // MH 24/03/2010 v6.3: Suppressed Print Parameters check-box for inapplicable reports
  chkPrintParameters.Visible := RepMode In [2,3,7];

  SetLastValues;

  SetHelpContextIDs; // NF: 10/05/06 Fix for incorrect Context IDs
end;

procedure TRepInpMsg9.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  inherited;

  If (Assigned(CRepParam)) then
    Dispose(CRepParam);

end;



procedure TRepInpMsg9.ACFFExit(Sender: TObject);
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

    If ((AltMod) and (FoundCode<>'')) and (ActiveControl<>ClsCP1Btn) then
    Begin

      StillEdit:=BOn;

      FoundOk:=(GetNom(Self,FoundCode,FoundLong,99));


      If (FoundOk) then
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

procedure TRepInpMsg9.Id3CCFExit(Sender: TObject);
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

procedure TRepInpMsg9.AccF3Exit(Sender: TObject);
Var
  FoundCode  :  Str20;

  FoundOk,
  AltMod     :  Boolean;


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

      FoundOk:=(GetCust(Self,FoundCode,FoundCode,(RepMode=8),99*Ord(RepMode In [2..7])));


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


function TRepInpMsg9.I1PrYrFShowPeriod(Sender: TObject;
  const EPr: Byte): String;
begin
  inherited;
  Result:=RepInpPPr_Pr(EPr);
end;

function TRepInpMsg9.I1PrYrFConvDate(Sender: TObject; const IDate: String;
  const Date2Pr: Boolean): String;
begin
  inherited;
  Result:=RepInpConvInpPr(IDate,Date2Pr);
end;


procedure TRepInpMsg9.DocFiltFExit(Sender: TObject);
const
  invalidDocTypes = [SDG,NDG,OVT,DEB,SDT,NDT,IVT,CRE,RUN,FOL,AFL, ADC,ACQ,API,
                     SKF,JBF,JRN,WIN];
Var
  DT, i : DocTypes;
  isValidDocType : boolean;
begin
  inherited;

  DT:=SIN;
 
  //TW 10/08/2011: Added new document filtering which actually works!
  if Length(DocFiltF.Text) > 0 then
  begin
    isValidDocType := false;
    for i :=low(DocTypes) to high(DocTypes)  do
    begin
      if not (i in invalidDocTypes) then
      begin
        if (copy(DocCodes[i], 1, length(trim(DocFiltF.Text))) = DocFiltF.Text) then
        begin
         isValidDocType := true;
         Break;
        end;
      end;
    end;
  end
  else
    isValidDocType := true;

  If  (isValidDocType) then
    Dt := DocTypeFCode(Strip('B',[#32],DocFiltF.Text))
  else if (isvalidDocType = false) and (ActiveControl<>ClsCP1Btn) then
  begin
   MessageBox(self.Handle, PChar(Format('%S is not a valid document type', [DocFiltF.Text])) , 'Warning', MB_SYSTEMMODAL + mb_OK +
     MB_ICONWARNING);
   DocFiltF.SetFocus;
  end;
  {If (Sender is Text8pt) then
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
  end;}
end;


procedure TRepInpMsg9.OkCP1BtnClick(Sender: TObject);
//GS 08/03/2012 ABSEXCH-12200: vars for new GLHistory report
var
  CCDeptCombos : ICostCentreDepartmentCombinationList;
  I : LongInt;

Begin
  If (Sender=OkCP1Btn) then
  Begin
    If AutoExitValidation Then
    Begin
      With CRepParam^ do
      Begin

        OKCP1Btn.Enabled:=BOff;

        {$IFDEF MC_On}
          RCr:=CurrF.ItemIndex;
          RTxCr:=CurrF2.ItemIndex;
        {$ENDIF}


        RCCDep[BOff]:=Id3DepF.Text;
        RCCDep[BOn]:=Id3CCF.Text;
        CCDpTag:=ccTagChk.Checked;

        If (UPF.Checked) then
        Begin
          I1PrYrF.InitPeriod(RPr,RYr,BOff,BOff);
          I2PrYrF.InitPeriod(RPr2,RYr2,BOff,BOff);
        end
        else
        Begin
          SDate:=I1TransDateF.DateValue;
          EDate:=I2TransDateF.DateValue;
          RYr:=1;
          ByDate:=BOn;
        end;

        CustFilt:=AccF3.Text;
        DocWanted:=DocFiltF.Text;

        {$IFDEF SOP}
          If (CommitAct) and (CommitMCB.ItemIndex In [0..2]) then
            CommitMode:=CommitMCB.ItemIndex;

        {$ENDIF}

        ReconCode:=IntStr(Trim(AcfF.Text));
        NomToo:=IntStr(Trim(AccF2.Text));

        If (NomToo=0) then
          NomToo:=MaxInt;

        FolStart:=Round(AgeInt.Value);
        FolEnd:=Round(AgeInt2.Value);

        If (RepMode In [8,9]) and (Sum1.Checked) then
          RepMode:=RepMode+3;

        //PR: 22/10/2009
        PrintParameters := chkPrintParameters.Checked;

        // MH 30/10/2013 v7.X MRD1.1: Added customer/Consumer support to Customer Trading History Report (8) and Summary Report (11)
        If (RepMode In [8, 11]) Then
        Begin
          // MH 14/01/2014 v7.0.8 ABSEXCH-14941: Hide Include Account Types combo if Consumers turned off
          If cbAccountTypes.Visible Then
          Begin
            Case cbAccountTypes.ItemIndex Of
              // Customers & Consumers
              0 : IncludeAccountTypes := atCustomersAndConsumers;
              // Customers Only
              1 : IncludeAccountTypes := atCustomersOnly;
              // Consumers Only
              2 : IncludeAccountTypes := atConsumersOnly;
            End; // Case cbAccountTypes.ItemIndex
          End // If cbAccountTypes.Visible
          Else
            IncludeAccountTypes := atCustomersOnly;
        End; // If (RepMode In [8, 11])

        //GS 08/03/2012 ABSEXCH-12200 : rewritten the SQL GL History report:

        //code for producing the new SQL version of the GL history report
        //we will branch off here and handle the GH history report for SQL

        // MH 22/08/2012 v7.0 ABSEXCH-13329: Added check on mode so code this isn't used for GL Audit, Doc Audit and Trading History Reports
        if (RepMode = 2) And (UsingSQL and SQLReportsConfiguration.GetUseSQLGLHistoryReport) then
        begin
          If Create_BackThread then
          Begin
            // Check whether we need to get a list of Cost Centres and Departments from SQL Server
            //  PS - 20-11-2015 - ABSEXCH-13036 - GL history Report - Wildcard rules are not respected in MSSQL.
            //  PS - Add function to Print report. This function will be call for each CC type and Dept type
            If (Trim(CRepParam.RCCDep[BOff]) <> '') Or (Trim(CRepParam.RCCDep[BOn]) <> '') Or CRepParam.CCDpTag Then
            Begin
              CCDeptCombos := GetCCDeptCombinations (CRepParam.RCCDep[True], CRepParam.RCCDep[False], CRepParam.CCDpTag);
              For I := 0 To (CCDeptCombos.CombinationCount - 1) Do
              Begin
                With CCDeptCombos.Combinations[I] Do
                  If Not PrintGLHisToryReportSQL (ccdpCostCentreCode, ccdpCostCentreDesc, ccdpDepartmentCode, ccdpDepartmentDesc, I=0,CRepParam,Owner) Then
                    // Report Cancelled
                    Break;
              End; // For I
            End // If (Trim(ReportParameters.NCCDep[True]) <> '') Or (Trim(ReportParameters.NCCDep[False]) <> '') Or ReportParameters.CCDpTag
            Else
              PrintGLHisToryReportSQL ('', '', '', '', True,CRepParam,Owner)
          end;
        end
        else
        begin
          //if we are on a Btrieve system, run the old report logic:
          AddDocRep2Thread(RepMode,0,CRepParam,Owner);
        end;//end if Using SQL
      end;
      inherited;
    End // If AutoExitValidation
    Else
      ModalResult := mrNone;
  End // If (Sender=OkCP1Btn)
  Else
    inherited;
end;

// NF: 10/05/06 Fix for incorrect Context IDs
procedure TRepInpMsg9.SetHelpContextIDs;
begin
  UPF.HelpContext := 636;
end;

procedure ANH_Report(IdMode  :  Byte;
                     AOwner  :  TComponent);

Var
  RepInpMsg1  :  TRepInpMsg9;

Begin
  GRNo:=IdMode;

  RepInpMsg1:=TRepInpMsg9.Create(AOwner);

end;


procedure Nom_Report(IdMode  :  Byte;
                     AOwner  :  TComponent);

Var
  RepInpMsg1  :  TRepInpMsgA;

Begin
  RepInpAU.GRNo:=IdMode;

  RepInpMsg1:=TRepInpMsgA.Create(AOwner);

end;


procedure PrintRangeDocs(AOwner  :  TComponent);
  Var
    RepInpMsg1  :  TRepInpMsgP;

  Begin
    RepInpMsg1:=TRepInpMsgP.Create(AOwner);

  end;


{$IFDEF PF_On}

  procedure CCDep_Report(AOwner  :  TComponent);

  Var
    RepInpMsg1  :  TRepInpMsgB;

  Begin
    RepInpMsg1:=TRepInpMsgB.Create(AOwner);

  end;


  procedure ECVAT_Report(AOwner  :  TComponent);

  Var
    RepInpMsg1  :  TRepInpMsgF;

  Begin
    RepInpMsg1:=TRepInpMsgF.Create(AOwner);

  end;

{$ENDIF}


{$IFDEF STK}
  procedure Stk_Report(IdMode  :  Byte;
                       AOwner  :  TComponent);

  Var
    RepInpMsg1  :  TRepInpMsgC;

  Begin
    RepInpCU.SGRNo:=IdMode;

    RepInpMsg1:=TRepInpMsgC.Create(AOwner);

  end;


  procedure PriceL_Report(AOwner  :  TComponent);

  Var
    RepInpMsg1  :  TRepInpMsgD;

  Begin
    RepInpMsg1:=TRepInpMsgD.Create(AOwner);

  end;

  procedure PBreak_Report(IdMode  :  Byte;
                          AOwner  :  TComponent);

  Var
    RepInpMsg1  :  TRepInpMsgG;

  Begin
    RepInpGU.PBRNo:=IdMode;

    RepInpMsg1:=TRepInpMsgG.Create(AOwner);

  end;


  procedure SRecon_Report(IdMode  :  Byte;
                          AOwner  :  TComponent);

  Var
    RepInpMsg1  :  TRepInpMsgH;

  Begin
    RepInpHU.SRRNo:=IdMode;

    RepInpMsg1:=TRepInpMsgH.Create(AOwner);

  end;

  procedure SList_Report(IdMode  :  Byte;
                         AOwner  :  TComponent);

  Var
    RepInpMsg1  :  TRepInpMsgJ;

  Begin
    RepInpJU.SLRNo:=IdMode;

    {$IFDEF SOP}
      If (Not Syss.UseMLoc) and (IdMode=1) then
        AddSListRep2Thread(1,nil,AOwner)
      else
    {$ENDIF}
        RepInpMsg1:=TRepInpMsgJ.Create(AOwner);

  end;

  procedure SVal_Report(IdMode  :  Byte;
                        AOwner  :  TComponent);

  Var
    RepInpMsg1  :  TRepInpMsgK;

  Begin
    RepInpKU.SVRNo:=IdMode;

    RepInpMsg1:=TRepInpMsgK.Create(AOwner);

  end;

  procedure SHist_Report(IdMode  :  Byte;
                         AOwner  :  TComponent);

  Var
    RepInpMsg1  :  TRepInpMsgL;

  Begin
    RepInpLU.SHRNo:=IdMode;

    RepInpMsg1:=TRepInpMsgL.Create(AOwner);

  end;

  procedure SKit_Report(IdMode  :  Byte;
                        AOwner  :  TComponent);

  Var
    RepInpMsg1  :  TRepInpMsgM;

  Begin
    RepInpMU.RepIMode:=IdMode;

    RepInpMsg1:=TRepInpMsgM.Create(AOwner)

  end;


  procedure SBOrd_Report(IdMode  :  Byte;
                         AOwner  :  TComponent);

  Var
    RepInpMsg1  :  TRepInpMsgN;

  Begin
    RepInpMsg1:=TRepInpMsgN.Create(AOwner)

  end;

  procedure SShort_Report(IdMode  :  Byte;
                          AOwner  :  TComponent);

  Var
    RepInpMsg1  :  TRepInpMsgO;

  Begin
    RepInpOU.RepSMode:=IdMode;

    RepInpMsg1:=TRepInpMsgO.Create(AOwner)

  end;

  procedure StkLab_Report(AOwner  :  TComponent);

  Var
    RepInpMsg1  :  TRepInpMsgJ;

  Begin
    RepInpJU.SLRNo:=7;

    RepInpMsg1:=TRepInpMsgJ.Create(AOwner);

  end;


  procedure WOP_Report(IdMode  :  Byte;
                       AOwner  :  TComponent);

  Var
    RepInpMsg1  :  TRepInpMsgX;

  Begin
    RepInpXU.RepWMode:=IdMode;

    RepInpMsg1:=TRepInpMsgX.Create(AOwner)

  end;

  procedure WOPWIP_Report(IdMode  :  Byte;
                         AOwner  :  TComponent);

  Var
    RepInpMsg1  :  TRepInpMsgW2;

  Begin
    RepInpMsg1:=TRepInpMsgW2.Create(AOwner)

  end;

  procedure Bin_Report(IdMode  :  Byte;
                       DocRef  :  Str10;
                       AOwner  :  TComponent);

  Var
    RepInpMsg1  :  TRepInpMsgR;

  Begin
    RepInpRU.SLRNo:=IdMode;

    RepInpMsg1:=TRepInpMsgR.Create(AOwner);

    Try
      RepInpMsg1.OrdFiltF.Text:=DocRef;
    except
      RepInpMsg1.Free;
    end; {Try..}

  end;


  procedure RET_Report(IdMode  :  Byte;
                       SalesMode
                               :  Boolean;
                       AOwner  :  TComponent);

    Var
      RepInpMsg1  :  TRepInpRT;

    Begin
      RepIRT1U.RepRMode:=IdMode;
      RepIRT1U.RepRSales:=SaleSMode;


      RepInpMsg1:=TRepInpRT.Create(AOwner)

    end;

{$ENDIF}


procedure VAT_Report(IDMode  :  Byte;
                     AOwner  :  TComponent);

  Var
    RepInpMsg1  :  TRepInpMsgE;

  Begin
    VMNo:=IdMode;

    RepInpMsg1:=TRepInpMsgE.Create(AOwner);

{$IFNDEF SOPDLL}
    // ABSEXCH-14371. PKR. 25/07/2013.  Submit VAT 100 online.

    { CJS 2013-08-09 - ABSEXCH-14525 - VAT100 form opens unnecessarily }
    // VatSubForm := TVatSubForm.Create(AOwner);
    
    // ABSEXCH-14509. PKR. 02/08/2013.  Removed Form Hide.
{$ENDIF}
  end;


procedure VAT_ReportIE(IDMode  :  Byte;
                       AOwner  :  TComponent);

  Var
    RepInpMsg1  :  TRepInpMsgV;

  Begin
    VMNo:=IdMode;

    RepInpMsg1:=TRepInpMsgV.Create(AOwner);

  end;


procedure VAT_ReportNZ(IDMode  :  Byte;
                       AOwner  :  TComponent);

  Var
    RepInpMsg1  :  TRepInpMsgW;

  Begin
    VMNo:=IdMode;

    RepInpMsg1:=TRepInpMsgW.Create(AOwner);

  end;

//------------------------------

procedure TRepInpMsg9.AgeIntExit(Sender: TObject);
begin
  // MH 22/12/2010 v6.6 ABSEXCH-10548: Prevent out of range numbers as stored in LongInt
  If (ActiveControl <> ClsCP1Btn) And ((AgeInt.Value < Low(LongInt)) Or (AgeInt.Value > MaxLongInt)) Then
  Begin
    MessageDlg ('The From Folio number is not valid', mtError, [mbOK], 0);
    If AgeInt.CanFocus Then
      AgeInt.SetFocus;
  End; // If (ActiveControl <> ClsCP1Btn) And ((AgeInt.Value < Low(LongInt)) Or (AgeInt.Value > MaxLongInt))
end;

procedure TRepInpMsg9.AgeInt2Exit(Sender: TObject);
begin
  // MH 22/12/2010 v6.6 ABSEXCH-10548: Prevent out of range numbers as stored in LongInt
  If (ActiveControl <> ClsCP1Btn) And ((AgeInt2.Value < Low(LongInt)) Or (AgeInt2.Value > MaxLongInt) Or (AgeInt2.Value < AgeInt.Value)) Then
  Begin
    MessageDlg ('The To Folio number is not valid', mtError, [mbOK], 0);
    If AgeInt2.CanFocus Then
      AgeInt2.SetFocus;
  End; // If (ActiveControl <> ClsCP1Btn) And ((AgeInt2.Value < Low(LongInt)) Or (AgeInt2.Value > MaxLongInt) Or (AgeInt2.Value < AgeInt.Value))
end;

//------------------------------


end.
