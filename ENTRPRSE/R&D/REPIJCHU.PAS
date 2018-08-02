unit RepIJCHU;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  Repinp1u, BorBtns, StdCtrls, TEditVal, Mask, ExtCtrls, BTSupU3, bkgroup,
  Animate, SBSPanel;

type
  TRepJCHInp = class(TRepInpMsg)
    Label83: Label8;
    AccLab: Label8;
    Label85: Label8;
    I1PrYrF: TEditPeriod;
    I2PrYrF: TEditPeriod;
    Id3CCF: Text8Pt;
    Id3DepF: Text8Pt;
    ACFF: Text8Pt;
    Label81: Label8;
    Label811: Label8;
    CurrF: TSBSComboBox;
    CurrF2: TSBSComboBox;
    Sum1: TBorCheck;
    Label810: Label8;
    ProdF: Text8Pt;
    LocLab: Label8;
    LocF: Text8Pt;
    RepQtyChk: TBorCheck;
    SUInvChk: TBorCheck;
    UPF: TBorRadio;
    UDF: TBorRadio;
    I1TransDateF: TEditDate;
    Label88: Label8;
    I2TransDateF: TEditDate;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormCreate(Sender: TObject);
    procedure ACFFExit(Sender: TObject);
    procedure ProdFExit(Sender: TObject);
    procedure Id3CCFExit(Sender: TObject);
    procedure OkCP1BtnClick(Sender: TObject);
    procedure LocFExit(Sender: TObject);
  private
    { Private declarations }
    
    CRepParam  :  JobCRep2Ptr;

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
  RepJCH1U,
  SysU1,
  SysU2,
  BTSupU2;


{$R *.DFM}



procedure TRepJCHInp.FormCreate(Sender: TObject);


Var
  HideCC  :  Boolean;
  TB,LPr,LYr
          :  Byte;

begin
  inherited;

  ClientHeight:=274;
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

    HideCC:=BOff;


  {$IFNDEF PF_On}

    HideCC:=BOn;

  {$ELSE}

    HideCC:=Not Syss.UseCCDep;

  {$ENDIF}



  If (HideCC) then
  Begin
    LocLab.Left:=(AccLab.Left+AccLab.Width)-LocLab.Width;
    LocF.Left:=Id3CCF.Left;
  end;


  Id3CCF.Visible:=Not HideCC;
  Id3DepF.Visible:=Not HideCC;
  Label83.Visible:=Not HideCC;

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

procedure TRepJCHInp.FormClose(Sender: TObject; var Action: TCloseAction);

begin
  inherited;

  If (Assigned(CRepParam)) then
    Dispose(CRepParam);
end;


procedure TRepJCHInp.ACFFExit(Sender: TObject);
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

      FoundOk:=(GetCust(Self,FoundCode,FoundCode,BOn,99));


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



procedure TRepJCHInp.ProdFExit(Sender: TObject);
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



procedure TRepJCHInp.Id3CCFExit(Sender: TObject);
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


procedure TRepJCHInp.LocFExit(Sender: TObject);
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

        FoundOk:=(GetJobMisc(Self,FoundCode,FoundCode,1,0));


        If (FoundOk) then
        Begin

          StillEdit:=BOff;

          Text:=LJVar(FoundCode,3);

        end
        else
        Begin

          SetFocus;
        end; {If not found..}
      end;

    end; {with..}
end;


procedure TRepJCHInp.OkCP1BtnClick(Sender: TObject);
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


        RCCDep[BOff]:=Id3DepF.Text;
        RCCDep[BOn]:=Id3CCF.Text;

        JobTFilt:=LocF.Text;

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

        CustFilt:=AcFF.Text;
        QtyMode:=RepQtyChk.Checked;
        UnInv:=SUInvChk.Checked;

        Summary:=Sum1.Checked;

        JobFilt:=FullJobCode(ProdF.Text);


        AddJHistRep2Thread(RepMode,CRepParam,Owner);
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
