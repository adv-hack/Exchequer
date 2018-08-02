unit RepInp3U;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  Repinp1u, BorBtns, TEditVal, StdCtrls, Mask, ExtCtrls, SBSPanel,BTSupU3,
  bkgroup, Animate;

type
  TRepInpMsg3 = class(TRepInpMsg)
    CurrF: TSBSComboBox;
    Id3CCF: Text8Pt;
    Id3DepF: Text8Pt;
    AgeX: TSBSComboBox;
    AgeInt: TCurrencyEdit;
    I1PrYrF: TEditPeriod;
    Back1: TBorCheck;
    OS1: TBorCheck;
    Sum1: TBorCheck;
    Label82: Label8;
    Label81: Label8;
    Label83: Label8;
    Label84: Label8;
    Label85: Label8;
    Label86: Label8;
    Label87: Label8;
    Label88: Label8;
    Label811: Label8;
    CurrF2: TSBSComboBox;
    GLMDC: Text8Pt;
    Label810: Label8;
    ACCF: Text8Pt;
    chkPrintParameters: TBorCheck;
    Label89: Label8;
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure Id3CCFExit(Sender: TObject);
    procedure OkCP1BtnClick(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure FormKeyPress(Sender: TObject; var Key: Char);
    function I1PrYrFConvDate(Sender: TObject; const IDate: String;
      const Date2Pr: Boolean): String;
    function I1PrYrFShowPeriod(Sender: TObject; const EPr: Byte): String;
    procedure ACCFExit(Sender: TObject);
    procedure GLMDCExit(Sender: TObject);
  private
    { Private declarations }
    CRepParam  :  DueRepPtr;
    IsCust,
    IsMDC      :  Boolean;

  public
    { Public declarations }
  end;


procedure Aged_Report(IsCust,
                      IsXMDC  :  Boolean;
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
  ReportU,

  {$IFDEF EXSQL}
    SQLUtils,
    SQLRep_Config,
    SQLRep_ConsolidatedAgedDebtorsCreditors,
  {$ENDIF}

  SysU1,
  SysU2,
  BTSupU2;

{$R *.DFM}

Var
  GIsCust,
  GIsMDC   :  Boolean;

procedure TRepInpMsg3.FormCreate(Sender: TObject);

Const
  MDCTit  :  Array[BOff..BOn] of Str20 = ('','Control Account ');


Var
  HideCC  :  Boolean;
  LPr,LYr  :  Byte;


begin
  inherited;

//  ClientHeight:=263;
  ClientHeight:=284;
  ClientWidth:=311;

  {$IFDEF MC_On}

    Set_DefaultCurr(CurrF.Items,BOn,BOff);
    Set_DefaultCurr(CurrF.ItemsL,BOn,BOn);
    CurrF.ItemIndex:=0;

    Set_DefaultCurr(CurrF2.Items,BOn,BOff);
    Set_DefaultCurr(CurrF2.ItemsL,BOn,BOn);
    CurrF2.ItemIndex:=0;


  {$ELSE}
    Label81.Visible:=BOff;
    CurrF.Visible:=BOff;
    CurrF2.Visible:=BOff;
    Label811.Visible:=BOff;

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

  OS1.Checked:=BOn;

  New(CRepParam);

  try
    FillChar(CRepParam^,Sizeof(CRepParam^),0);
  except
    Dispose(CRepParam);
    CRepParam:=nil;
  end;

  AgeX.ItemIndex:=2;
  AgeInt.Value:=1;

  LPr:=GetLocalPr(0).CPr;
  LYr:=GetLocalPr(0).CYr;

  I1PrYrF.InitPeriod(LPr,LYr,BOn,BOn);

  IsCust:=GIsCust;
  IsMDC:=GIsMDC;

  If (IsCust) then
    Caption:=MDCTit[IsMDC]+Caption+' Debtors Report'
  else
    Caption:=MDCTit[IsMDC]+Caption+' Creditors Report';

  SetLastValues;
end;

procedure TRepInpMsg3.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  inherited;

  If (Assigned(CRepParam)) then
    Dispose(CRepParam);

end;

procedure TRepInpMsg3.Id3CCFExit(Sender: TObject);
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

      If (AltMod) and (ActiveControl<>ClsCP1Btn) and {(ActiveControl<>OkCP1Btn) and}
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

procedure TRepInpMsg3.ACCFExit(Sender: TObject);
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

    If ((AltMod) and (FoundCode<>'')) and (ActiveControl<>ClsCP1Btn) then
    Begin

      StillEdit:=BOn;

      FoundOk:=(GetCust(Self,FoundCode,FoundCode,IsCust,0));


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

procedure TRepInpMsg3.GLMDCExit(Sender: TObject);
Var
  FoundCode  :  Str20;

  FoundOk,
  AltMod     :  Boolean;

  FoundLong  :  LongInt;


begin
  FoundOk:=BOff;

  If (Sender is Text8pt) then
  With (Sender as Text8pt) do
  Begin
    AltMod:=Modified;

    FoundCode:=Text;

    If ((AltMod) or (FoundCode='')) and (ActiveControl<>ClsCP1Btn) and ((FoundCode<>'')) then
    Begin

      StillEdit:=BOn;

      FoundOk:=(GetNom(Self,FoundCode,FoundLong,79));


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



procedure TRepInpMsg3.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  {}
  Inherited;
end;

procedure TRepInpMsg3.FormKeyPress(Sender: TObject; var Key: Char);
begin
  {}
  Inherited;
end;

function TRepInpMsg3.I1PrYrFConvDate(Sender: TObject; const IDate: String;
  const Date2Pr: Boolean): String;
begin
  inherited;
  Result:=RepInpConvInpPr(IDate,Date2Pr);
end;

function TRepInpMsg3.I1PrYrFShowPeriod(Sender: TObject;
  const EPr: Byte): String;
begin
  inherited;
  Result:=RepInpPPr_Pr(EPr);
end;


procedure TRepInpMsg3.OkCP1BtnClick(Sender: TObject);
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
          RTxCr:=CurrF2.ItemIndex;
        {$ENDIF}

        PrevMode:=Back1.Checked;
        Summary:=Sum1.Checked;
        OSOnly:=OS1.Checked;

        RCCDep[BOff]:=Id3DepF.Text;
        RCCDep[BOn]:=Id3CCF.Text;
        RAgeBy:=Succ(AgeX.ItemIndex);
        RAgeInt:=Round(AgeInt.Value);
        ACFilt:=ACCF.Text;
        CtrlNomFilt:=IntStr(GLMDC.Text);

        I1PrYrF.InitPeriod(RPr,RYr,BOff,BOff);

        //PR: 22/10/2009
        PrintParameters := chkPrintParameters.Checked;

        If (IsMDC) then
          // Split By Control Account
          AddAMDCRep2Thread(1+Ord(Summary),IsCust,CRepParam,Owner)
        Else
        Begin
          // Consolidated Aged Debtors/Creditors
          {$IFDEF EXSQL}
            If SQLUtils.UsingSQLAlternateFuncs And IsCust And SQLReportsConfiguration.UseSQLConsolidatedAgedDebtors Then
              // Print SQL Aged Debtors
              SQLReport_PrintConsolidatedAgedDebtorsCreditors (Owner, rtAgedDebtors, CRepParam^)
            Else If SQLUtils.UsingSQLAlternateFuncs And (Not IsCust) And SQLReportsConfiguration.UseSQLConsolidatedAgedCreditors Then
              // Print SQL Aged Creditors
              SQLReport_PrintConsolidatedAgedDebtorsCreditors (Owner, rtAgedCreditors, CRepParam^)
            Else
              // Print legacy report
          {$ENDIF}
              AddADebRep2Thread(1+Ord(Summary),IsCust,CRepParam,Owner);
        End; // Else
      end;

      inherited;
    End // If AutoExitValidation
    Else
      ModalResult := mrNone;
  End // If (Sender=OkCP1Btn)
  Else
    inherited;
end;


procedure Aged_Report(IsCust,
                      IsXMDC  :  Boolean;
                      AOwner  :  TComponent);

Var
  RepInpMsg1  :  TRepInpMsg3;

Begin
  GIsCust:=IsCust;
  GIsMDC:=IsXMDC;

  RepInpMsg1:=TRepInpMsg3.Create(AOwner);

end;






Initialization

  GIsCust:=BOff;

Finalization


end.
