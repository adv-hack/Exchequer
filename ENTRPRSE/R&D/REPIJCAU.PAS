unit RepIJCAU;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  Repinp1u, BorBtns, StdCtrls, TEditVal, Mask, ExtCtrls, BTSupU3, bkgroup,
  Animate, SBSPanel;

type
  TRepJCAInp = class(TRepInpMsg)
    Label83: Label8;
    Label85: Label8;
    I1PrYrF: TEditPeriod;
    I2PrYrF: TEditPeriod;
    Id3CCF: Text8Pt;
    Label81: Label8;
    Label811: Label8;
    CurrF: TSBSComboBox;
    CurrF2: TSBSComboBox;
    Sum1: TBorCheck;
    Label810: Label8;
    ProdF: Text8Pt;
    Label82: Label8;
    JATCB: TSBSComboBox;
    Label84: Label8;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormCreate(Sender: TObject);
    procedure ProdFExit(Sender: TObject);
    procedure Id3CCFExit(Sender: TObject);
    procedure OkCP1BtnClick(Sender: TObject);
  private
    { Private declarations }
    
    CRepParam  :  JobCRep3Ptr;

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
  VarJCstU,
  InvListU,
  RepJCA1U,
  SysU1,
  SysU2,
  BTSupU2;


{$R *.DFM}



procedure TRepJCAInp.FormCreate(Sender: TObject);


Var
  n,
  TB,
  LPr,LYr  :  Byte;

begin
  inherited;

  ClientHeight:=218;
  ClientWidth:=356;

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


  With JATCB do
  Begin
    For n:=1 to NofXTypes do
      Items.Add(JobXDesc^[n]);
  end;

  JATCB.Items.Insert(0,'All Types');

  JATCB.ItemIndex:=0;


  TB:=1;

  
  LPr:=GetLocalPr(0).CPr;
  LYr:=GetLocalPr(0).CYr;


  I1PrYrF.InitPeriod(TB,LYr,BOn,BOn);
  I2PrYrF.InitPeriod(LPr,LYr,BOn,BOn);



  New(CRepParam);

  try
    FillChar(CRepParam^,Sizeof(CRepParam^),0);
  except
    Dispose(CRepParam);
    CRepParam:=nil;
  end;

  SetLastValues;
end;

procedure TRepJCAInp.FormClose(Sender: TObject; var Action: TCloseAction);

begin
  inherited;

  If (Assigned(CRepParam)) then
    Dispose(CRepParam);
end;


procedure TRepJCAInp.ProdFExit(Sender: TObject);
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

    If ((AltMod) or (FoundCode='')) and (ActiveControl<>ClsCP1Btn) then
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



procedure TRepJCAInp.Id3CCFExit(Sender: TObject);
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

      If ((AltMod) and (FoundCode<>'')) and (ActiveControl<>ClsCp1Btn) then
      Begin

        StillEdit:=BOn;

        FoundOk:=(GetJobMisc(Self,FoundCode,FoundCode,2,99));

        If (FoundOk) then {* Credit Check *}
        Begin

          Text:=FoundCode;

        end
        else
        Begin
          SetFocus;
        end; {If not found..}
      end;

    end;
  {$ENDIF}

end;


procedure TRepJCAInp.OkCP1BtnClick(Sender: TObject);
Begin
  If (Sender=OkCP1Btn) then
  Begin
    If AutoExitValidation Then
    Begin
      With CRepParam^ do
      Begin
        OKCP1Btn.Enabled:=BOff;

        {$IFDEF MC_On}
          If (CurrF.ItemIndex>=0) then
            RCr:=CurrF.ItemIndex;

          If (CurrF2.ItemIndex>=0) then
            RTxCr:=CurrF2.ItemIndex;
        {$ENDIF}


        I1PrYrF.InitPeriod(RPr,RYr,BOff,BOff);
        I2PrYrF.InitPeriod(RPr2,RYr2,BOff,BOff);

        Summary:=Sum1.Checked;

        JobFilt:=FullJobCode(ProdF.Text);

        CustFilt:=Id3CCF.Text;


        If (JATCB.ItemIndex>=0) then
          AHedFilt:=JATCB.ItemIndex;

        AddJCAnalRep2Thread(RepMode,CRepParam,Owner);
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
