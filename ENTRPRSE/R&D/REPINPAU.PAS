unit RepInpAU;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  Repinp1u, StdCtrls, bkgroup,
  GlobVar,VarConst,BTSupU3, BorBtns, Mask, TEditVal, Animate, ExtCtrls, SBSPanel,
  ComCtrls;

type
  TRepInpMsgA = class(TRepInpMsg)
    Label84: Label8;
    CurrF: TSBSComboBox;
    Label811: Label8;
    CurrF2: TSBSComboBox;
    Label85: Label8;
    AgeInt: TCurrencyEdit;
    Label86: Label8;
    I1PrYrF: TEditPeriod;
    CYTDF: TBorCheck;
    IncZBF: TBorCheck;
    GLSLAb: Label8;
    ACFF: Text8Pt;
    GLELab: Label8;
    ACCF2: Text8Pt;
    Label88: Label8;
    Id3CCF: Text8Pt;
    Id3DepF: Text8Pt;
    CommitMCB: TSBSComboBox;
    ccTagChk: TBorCheck;
    chkPrintParameters: TBorCheck;
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure OkCP1BtnClick(Sender: TObject);
    procedure ACFFExit(Sender: TObject);
    procedure Id3CCFExit(Sender: TObject);
    procedure Id3CCFEnter(Sender: TObject);
    function I1PrYrFConvDate(Sender: TObject; const IDate: String;
      const Date2Pr: Boolean): String;
    function I1PrYrFShowPeriod(Sender: TObject; const EPr: Byte): String;
    procedure AgeIntKeyPress(Sender: TObject; var Key: Char);
  private
    { Private declarations }
    RepMode    :  Byte;

    CRepParam  :  NomRepRecPtr;

    CCCtrl     :  Array[BOff..BOn] of Text8Pt;

  public
    { Public declarations }
  end;

Var
  GRNo  :  Byte;

{~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~}

Implementation

{~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~}

Uses
  ETStrU,
  ETDateU,
  ETMiscU,
  InvListU,
  Report4U,

  {$IFDEF EXSQL}
    SQLUtils,
    SQLRep_Config,
    // MH 10/02/2012 v6.9: Modified to use rewritten Full TB Report for Simplified TB
    //SQLRep_SimplifiedTrialBalance,
    SQLRep_FullTrialBalance,
  {$ENDIF}

  SysU1,
  SysU2,
  BTKeys1U,
  BTSupU2;

{$R *.DFM}



procedure TRepInpMsgA.FormCreate(Sender: TObject);
Const
  RepTit  :  Array[1..8] of Str80 = ('Trial Balance','Profit + Loss','Balance Sheet',
                                      'Source + Application of Funds','','','',
                                      'Simplified Trial Balance');

Var
  HideCC  :  Boolean;
  LPr,LYr  :  Byte;


begin
  inherited;
//  ClientHeight:=211;
  ClientHeight:=224;
  ClientWidth:=326;

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

    With Syss do
      HideCC:=(Not UseCCDep or Not PostCCNom);

  {$ENDIF}

  Id3CCF.Visible:=Not HideCC;
  Id3DepF.Visible:=Not HideCC;
  Label88.Visible:=Not HideCC;

  ccTagChk.Visible:=Not HideCC;


  CCCtrl[BOff]:=Id3DepF;
  CCCtrl[BOn]:=Id3CCF;

  {$IFDEF SOP}
    If (CommitAct) then
    Begin

      CommitMCB.Visible:=BOn;
      CommitMCB.ItemIndex:=0;
    end;
  {$ENDIF}


  New(CRepParam);

  try
    FillChar(CRepParam^,Sizeof(CRepParam^),0);
  except
    Dispose(CRepParam);
    CRepParam:=nil;
  end;

  RepMode:=GRNo;

  AgeInt.Value:=0;

  If (RepMode<>8) then
    HelpContext:=622+RepMode;

  
  If (RepMode In [4]) then
  Begin
    CYTDF.Visible:=BOff;
  end;

  // MH 26/10/2011 v6.9 ABSEXCH-11938: Hid GL Range fields for Balance Sheet Report (RepMode=3)
  If (RepMode In [2, 3]) then
  Begin
    GLSLab.Visible:=BOff; GLELab.Visible:=BOff;
    AcFF.Visible:=BOff; ACCF2.Visible:=BOff;
  end;

  LPr:=GetLocalPr(0).CPr;
  LYr:=GetLocalPr(0).CYr;

  I1PrYrF.InitPeriod(LPr,LYr,BOn,BOn);

  Caption:=RepTit[RepMode];

  // MH 24/03/2010 v6.3: Suppressed Print Parameters check-box for inapplicable reports
  chkPrintParameters.Visible := RepMode In [1,8];

  SetLastValues;
end;


procedure TRepInpMsgA.ACFFExit(Sender: TObject);
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


procedure TRepInpMsgA.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  inherited;

  If (Assigned(CRepParam)) then
    Dispose(CRepParam);

end;


procedure TRepInpMsgA.Id3CCFEnter(Sender: TObject);
Var
  IsCC  :  Boolean;
begin
  inherited;

  IsCC:=(Sender=Id3CCF);

  If (Not EmptyKeyS(CCCtrl[Not IsCC].Text,ccKeyLen,BOff)) and (Not Syss.PostCCDCombo) then
  With CCCtrl[IsCC] do
  Begin
    ReadOnly:=BOn;
  end;

end;


procedure TRepInpMsgA.Id3CCFExit(Sender: TObject);
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

      If (AltMod) and (ActiveControl<>ClsCP1Btn) and (Syss.PostCCNom) and
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

function TRepInpMsgA.I1PrYrFConvDate(Sender: TObject; const IDate: String;
  const Date2Pr: Boolean): String;
begin
  inherited;
  Result:=RepInpConvInpPr(IDate,Date2Pr);
end;

function TRepInpMsgA.I1PrYrFShowPeriod(Sender: TObject;
  const EPr: Byte): String;
begin
  inherited;
  Result:=RepInpPPr_Pr(EPr);
end;

procedure TRepInpMsgA.OkCP1BtnClick(Sender: TObject);
Begin
  If (Sender=OkCP1Btn) then
  Begin
    If AutoExitValidation Then
    Begin
      With CRepParam^ do
      Begin
        OKCP1Btn.Enabled:=BOff;

        {$IFDEF MC_On}
          FCr:=CurrF.ItemIndex;
          FTxCr:=CurrF2.ItemIndex;
        {$ENDIF}

        NCCDep[BOff]:=Id3DepF.Text;
        NCCDep[BOn]:=Id3CCF.Text;
        CCDpTag:=ccTagChk.Checked;

        IncludeAll:=IncZBF.Checked;

        RepLimit:=Round(AgeInt.Value);

        If (RepLimit<=0) then
          RepLimit:=YTD;

        I1PrYrF.InitPeriod(RPr,RYr,BOff,BOff);

        PALS:=IntStr(Trim(AcfF.Text));
        PALE:=IntStr(Trim(AccF2.Text));

        {$IFDEF SOP}
          If (CommitAct) and (CommitMCB.ItemIndex In [0..2]) then
            CommitMode:=CommitMCB.ItemIndex;

        {$ENDIF}


        If (Not (RepMode In [4])) and (CYTDF.Checked) then
          RepMode:=RepMode*10;

        //PR: 22/10/2009
        PrintParameters := chkPrintParameters.Checked;

        {$IFDEF EXSQL}
        If SQLUtils.UsingSQLAlternateFuncs And SQLReportsConfiguration.UseSQLSimplifiedTrialBalance And (RepMode In [8, 80]) Then
        Begin
          // Simplified Trial Balance Report (v6.8)
          CRepParam^.Mode := RepMode;
          // MH 10/02/2012 v6.9: Modified to use rewritten Full TB Report
          //SQLReport_PrintSimplifiedTrialBalance (Owner, CRepParam^)
          SQLReport_PrintFullTrialBalance (rtSimplifiedTB, CYTDF.Checked, Owner, CRepParam^);
        End // If SQLUtils.UsingSQLAlternateFuncs And SQLReportsConfiguration.UseSQLSimplifiedTrialBalance And (RepMode In [8, 80])
        Else If SQLUtils.UsingSQLAlternateFuncs And SQLReportsConfiguration.UseSQLFullTrialBalance And (RepMode In [1..3, 10, 20, 30]) Then
        Begin
          // MH 10/10/2011 v6.9 ABSEXCH-11815/ABSEXCH-11816/ABSEXCH-11817 - Added new SQL specific reports
          CRepParam^.Mode := RepMode;
          Case RepMode Of
            // Full Trial Balance Report (v6.9)
            1, 10 : SQLReport_PrintFullTrialBalance (rtFullTrialBalance, CYTDF.Checked, Owner, CRepParam^);
            // Profit & Loss Report (v6.9)
            2, 20 : SQLReport_PrintFullTrialBalance (rtProfitAndLoss, CYTDF.Checked, Owner, CRepParam^);
            // Balance Sheet Report (v6.9)
            3, 30 : SQLReport_PrintFullTrialBalance (rtBalanceSheet, CYTDF.Checked, Owner, CRepParam^);
          End; // Case RepMode
        End // If SQLUtils.UsingSQLAlternateFuncs And SQLReportsConfiguration.UseSQLSimplifiedTrialBalance And (RepMode In [8, 80])
        Else
        {$ENDIF}
          AddNomRep2Thread(RepMode,CRepParam,Owner);
      end;

      inherited;
    End // If AutoExitValidation
    Else
      ModalResult := mrNone;
  End // If (Sender=OkCP1Btn)
  Else
    inherited;
end;

procedure TRepInpMsgA.AgeIntKeyPress(Sender: TObject; var Key: Char);
begin
  If (Key = '-') Then
    Key := #0;
end;

end.
