unit RepInpBU;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  Repinp1u, StdCtrls, bkgroup, BTSupU3, TEditVal, Mask, VarConst, Animate,
  ExtCtrls, SBSPanel, ComCtrls, BorBtns;

type
  TRepInpMsgB = class(TRepInpMsg)
    Label84: Label8;
    CurrF: TSBSComboBox;
    Label811: Label8;
    CurrF2: TSBSComboBox;
    Label86: Label8;
    I1PrYrF: TEditPeriod;
    Label87: Label8;
    I2PrYrF: TEditPeriod;
    Label88: Label8;
    Id3CCF: Text8Pt;
    Id3DepF: Text8Pt;
    Label810: Label8;
    DocFiltF: Text8Pt;
    Label81: Label8;
    I3PrYrF: TEditPeriod;
    Label82: Label8;
    I4PrYrF: TEditPeriod;
    ACFF: Text8Pt;
    Label83: Label8;
    Label85: Label8;
    ACCF2: Text8Pt;
    CommitMCB: TSBSComboBox;
    ccTagChk: TBorCheck;
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure Id3CCFExit(Sender: TObject);
    procedure DocFiltFExit(Sender: TObject);
    procedure OkCP1BtnClick(Sender: TObject);
    procedure ACFFExit(Sender: TObject);
    function I1PrYrFShowPeriod(Sender: TObject; const EPr: Byte): String;
    function I1PrYrFConvDate(Sender: TObject; const IDate: String;
      const Date2Pr: Boolean): String;
  private
    { Private declarations }
    CRepParam  :  NomRepRecPtr;

  public
    { Public declarations }
  end;


{~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~}

Implementation

{~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~}

Uses
  ETStrU,
  ETDateU,
  ETMiscU,
  GlobVar,
  InvListU,
  Report5U,

  SysU1,
  SysU2,
  BTSupU2;

{$R *.DFM}



procedure TRepInpMsgB.FormCreate(Sender: TObject);

Var
  HideCC   :  Boolean;
  LPr,LYr  :  Byte;


begin
  inherited;
  ClientHeight:=210;
  ClientWidth:=382;

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

    HideCC:=Not Syss.UseCCDep;

  {$ENDIF}

  Id3CCF.Visible:=Not HideCC;
  Id3DepF.Visible:=Not HideCC;
  Label88.Visible:=Not HideCC;


  ccTagChk.Visible:=Not HideCC;



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


  LPr:=GetLocalPr(0).CPr;
  LYr:=GetLocalPr(0).CYr;

  I1PrYrF.InitPeriod(LPr,LYr,BOn,BOn);
  I2PrYrF.InitPeriod(LPr,LYr,BOn,BOn);

  CRepParam^.F2YrPr[2,2]:=1;

  I3PrYrF.InitPeriod(CRepParam^.F2YrPr[2,2],LYr,BOn,BOn);
  I4PrYrF.InitPeriod(Syss.PrInYr,LYr,BOn,BOn);

  SetLastValues;
end;

procedure TRepInpMsgB.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  inherited;

  If (Assigned(CRepParam)) then
    Dispose(CRepParam);

end;

procedure TRepInpMsgB.Id3CCFExit(Sender: TObject);
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

procedure TRepInpMsgB.DocFiltFExit(Sender: TObject);
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


procedure TRepInpMsgB.ACFFExit(Sender: TObject);
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


function TRepInpMsgB.I1PrYrFShowPeriod(Sender: TObject;
  const EPr: Byte): String;
begin
  inherited;
  Result:=RepInpPPr_Pr(EPr);
end;

function TRepInpMsgB.I1PrYrFConvDate(Sender: TObject; const IDate: String;
  const Date2Pr: Boolean): String;
begin
  inherited;
  Result:=RepInpConvInpPr(IDate,Date2Pr);
end;

procedure TRepInpMsgB.OkCP1BtnClick(Sender: TObject);
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

        I1PrYrF.InitPeriod(F2YrPr[1,2],F2YrPr[1,1],BOff,BOff);
        I2PrYrF.InitPeriod(F2YrPr[1,4],F2YrPr[1,3],BOff,BOff);

        I3PrYrF.InitPeriod(F2YrPr[2,2],F2YrPr[2,1],BOff,BOff);
        I4PrYrF.InitPeriod(F2YrPr[2,4],F2YrPr[2,3],BOff,BOff);


        PALS:=IntStr(Trim(AcfF.Text));
        PALE:=IntStr(Trim(AccF2.Text));

        DocWant:=DocFiltF.Text;

        {$IFDEF SOP}
          If (CommitAct) and (CommitMCB.ItemIndex In [0..2]) then
            CommitMode:=CommitMCB.ItemIndex;

        {$ENDIF}



        AddCCDepRep2Thread(CRepParam,Owner);
      end;

      inherited;
    End // If AutoExitValidation
    Else
      ModalResult := mrNone;
  End // If (Sender=OkCP1Btn)
  Else
    inherited;
end;


procedure CCDep_Report(AOwner  :  TComponent);

Var
  RepInpMsg1  :  TRepInpMsg;

Begin
  RepInpMsg1:=TRepInpMsgB.Create(AOwner);

end;






end.
