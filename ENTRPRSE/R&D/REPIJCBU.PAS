unit RepIJCBU;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  Repinp1u, BorBtns, StdCtrls, TEditVal, Mask, ExtCtrls, BTSupU3, bkgroup,
  Animate, SBSPanel;

type
  TRepJCBInp = class(TRepInpMsg)
    Label85: Label8;
    I1PrYrF: TEditPeriod;
    I2PrYrF: TEditPeriod;
    Sum1: TBorCheck;
    Label810: Label8;
    ProdF: Text8Pt;
    Label82: Label8;
    RepQtyChk: TBorCheck;
    SUInvChk: TBorCheck;
    Label81: Label8;
    CurrF: TSBSComboBox;
    Label811: Label8;
    CurrF2: TSBSComboBox;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormCreate(Sender: TObject);
    procedure ProdFExit(Sender: TObject);
    procedure OkCP1BtnClick(Sender: TObject);
  private
    { Private declarations }

    CRepParam  :  JobCRep1Ptr;

  public
    { Public declarations }
    RepMode    :  Byte;

  end;


{~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~}

Implementation

{~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~}

Uses
  ETStrU,
  ETDateU,
  ETMiscU,
  GlobVar,
  VarConst,
  BTKeys1U,
  InvListU,
  RepJCB1U,
  SysU1,
  SysU2,
  BTSupU2,
  ExThrd2U;


{$R *.DFM}



procedure TRepJCBInp.FormCreate(Sender: TObject);


Var
  TB,LPr,LYr  :  Byte;

begin
  inherited;

  ClientHeight:=219;
  ClientWidth:=356;


  TB:=1;

  LPr:=GetLocalPr(0).CPr;
  LYr:=GetLocalPr(0).CYr;

  I1PrYrF.InitPeriod(TB,LYr,BOn,BOn);
  I2PrYrF.InitPeriod(LPr,LYr,BOn,BOn);

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
    Label811.Visible:=BOff;
    CurrF2.Visible:=BOff;

  {$ENDIF}

  New(CRepParam);

  try
    FillChar(CRepParam^,Sizeof(CRepParam^),0);
  except
    Dispose(CRepParam);
    CRepParam:=nil;
  end;

  SetLastValues;
end;

procedure TRepJCBInp.FormClose(Sender: TObject; var Action: TCloseAction);

begin
  inherited;

  If (Assigned(CRepParam)) then
    Dispose(CRepParam);
end;


procedure TRepJCBInp.ProdFExit(Sender: TObject);
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

    If ((AltMod) or (FoundCode ='')) and (ActiveControl<>ClsCP1Btn) then
    Begin

      StillEdit:=BOn;

      FoundOk:=(GetJob(Self,FoundCode,FoundCode,99));


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



procedure TRepJCBInp.OkCP1BtnClick(Sender: TObject);
Begin
  If (Sender=OkCP1Btn) then
  Begin
    If AutoExitValidation Then
    Begin
      With CRepParam^ do
      Begin
        If (Not EmptyKey(ProdF.Text,JobKeyLen)) then
        Begin
          OKCP1Btn.Enabled:=BOff;


          I1PrYrF.InitPeriod(RPr,RYr,BOff,BOff);
          I2PrYrF.InitPeriod(RPr2,RYr2,BOff,BOff);

          QtyMode:=RepQtyChk.Checked;
          ShowER:=SUInvChk.Checked;

          StkDetl:=Sum1.Checked;

          JobFilt:=FullJobCode(ProdF.Text);

          {$IFDEF MC_On}
            If (CurrF.ItemIndex>=0) then
              RCr:=CurrF.ItemIndex;

            If (CurrF2.ItemIndex>=0) then
              RTxCr:=CurrF2.ItemIndex;
          {$ENDIF}


          AddJBudgRep2Thread(RepMode,CRepParam,Owner);
        end
        else
        Begin
          Set_BackThreadMVisible(BOn);

          ShowMessage('A Job/Contract code must be specified for this report.');

          Set_BackThreadMVisible(BOff);

        end;
      end;

      inherited;
    End // If AutoExitValidation
    Else
      ModalResult := mrNone;
  End // If (Sender=OkCP1Btn)
  Else
    inherited;
end;


end.
