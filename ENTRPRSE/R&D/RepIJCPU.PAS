unit RepIJCPU;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  Repinp1u, BorBtns, StdCtrls, TEditVal, Mask, ExtCtrls, BTSupU3, bkgroup,
  Animate, SBSPanel, GlobVar,VarConst, ExWrap1U;


type
  TRepJCPInp = class(TRepInpMsg)
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
    Label82: Label8;
    LocLab: Label8;
    LocF: Text8Pt;
    IncFcb: TSBSComboBox;
    Label84: Label8;
    Label86: Label8;
    SubCF: Text8Pt;
    Label87: Label8;
    Sortcb: TSBSComboBox;
    Label88: Label8;
    JCTFiltF: Text8Pt;
    Label89: Label8;
    QSF1: Text8Pt;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormCreate(Sender: TObject);
    procedure ACFFExit(Sender: TObject);
    procedure ProdFExit(Sender: TObject);
    procedure Id3CCFExit(Sender: TObject);
    procedure OkCP1BtnClick(Sender: TObject);
    procedure LocFExit(Sender: TObject);
    procedure SubCFExit(Sender: TObject);
    procedure JCTFiltFExit(Sender: TObject);
    procedure QSF1Exit(Sender: TObject);
    procedure QSF1EntHookEvent(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
  private
    { Private declarations }
    DocHed     :  DocTypes;
    CRepParam  :  JobCRep4Ptr;
    ExLocal    :  TdExLocal;

  public
    { Public declarations }
    RepMode    :  Byte;

  end;


  procedure JAApps1_Report(IDMode  :  Byte;
                           AOwner  :  TComponent);


{~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~}

Implementation

{~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~}

Uses
  ETStrU,
  ETDateU,
  ETMiscU,
  BtrvU2,
  BTKeys1U,
  InvListU,
  RepJCA2U,
  SysU1,
  SysU2,

  {$IFDEF CU}
    Event1U,
  {$ENDIF}

  BTSupU2;


{$R *.DFM}


Var
  JAMode  :  Byte;

procedure TRepJCPInp.FormCreate(Sender: TObject);


Var
  HideCC  :  Boolean;
  TB,LPr,LYr
          :  Byte;

begin
  inherited;

  ClientHeight:=337;
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

  ExLocal.Create;

  If (HideCC) then
  Begin
    LocLab.Left:=(AccLab.Left+AccLab.Width)-LocLab.Width;
    LocF.Left:=Id3CCF.Left;
  end;


  RepMode:=JAMode;

  If (RepMode In [3,20]) then
    DocHed:=JPA
  else
  Begin
    DocHed:=JSA;
    Label86.Visible:=BOff;
    SubCF.Visible:=BOff;
  end;

  Caption:=DocNames[DocHed]+' Report';

  Id3CCF.Visible:=Not HideCC;
  Id3DepF.Visible:=Not HideCC;
  Label83.Visible:=Not HideCC;

  TB:=1;

  If (RepMode In [20,21]) then
  Begin
    Label88.Visible:=BOff;
    JCTFiltF.Visible:=BOff;

    Caption:=DocNames[DocHed]+' Due Report';

  end;

  LPr:=GetLocalPr(0).CPr;
  LYr:=GetLocalPr(0).CYr;

  I1PrYrF.InitPeriod(TB,LYr,BOn,BOn);
  I2PrYrF.InitPeriod(LPr,LYr,BOn,BOn);

  Sum1.Checked:=(RepMode In [3,4]);
  Sortcb.ItemIndex:=0;
  IncFcb.ItemIndex:=2;

  New(CRepParam);

  try
    FillChar(CRepParam^,Sizeof(CRepParam^),0);
  except
    Dispose(CRepParam);
    CRepParam:=nil;
  end;

  SetLastValues;

  If (RepMode In [20,21]) then
  Begin
    JCTFiltF.Text:='';
    Sum1.Checked:=BOff;
  end;
end;


procedure TRepJCPInp.FormDestroy(Sender: TObject);
begin
  inherited;

  ExLocal.Destroy;
end;

procedure TRepJCPInp.FormClose(Sender: TObject; var Action: TCloseAction);

begin
  inherited;

  If (Assigned(CRepParam)) then
    Dispose(CRepParam);

  
end;


procedure TRepJCPInp.ACFFExit(Sender: TObject);
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

      FoundOk:=(GetCust(Self,FoundCode,FoundCode,(RepMode=4),99));


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



procedure TRepJCPInp.ProdFExit(Sender: TObject);
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



procedure TRepJCPInp.Id3CCFExit(Sender: TObject);
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


procedure TRepJCPInp.LocFExit(Sender: TObject);
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


procedure TRepJCPInp.SubCFExit(Sender: TObject);
Var
  FoundCode  :  Str20;

  FoundOk,
  AltMod     :  Boolean;

  mbRet      :  Word;


begin
  Inherited;

  If (Sender is Text8pt) then
  With (Sender as Text8pt) do
  Begin
    AltMod:=Modified;

    FoundCode:=Strip('B',[#32],Text);

    If ((AltMod) and (FoundCode<>'')) and (ActiveControl<>ClsCP1Btn) then
    Begin

      StillEdit:=BOn;

      FoundOk:=(GetJobMisc(Self,FoundCode,FoundCode,3,11));



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


procedure TRepJCPInp.JCTFiltFExit(Sender: TObject);
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
    AltMod:=Modified;

    FoundCode:=Trim(Text);

    If ((AltMod) and (FoundCode<>'')) and (ActiveControl<>ClsCP1Btn) then
    Begin

      StillEdit:=BOn;

      FoundCode:=AutoSetInvKey(Text,0);

      GenStr:=FoundCode;

      Status:=Find_Rec(B_GetEq,F[Fnum],Fnum,RecPtr[Fnum]^,Keypath,GenStr);

      FoundOk:=(StatusOk and (Inv.InvDocHed In JAPSplit-JAPJAPSplit));

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

procedure TRepJCPInp.QSF1EntHookEvent(Sender: TObject);
Var
  CUUDEvent  :  Byte;
  Result     :  LongInt;



begin           
  {$IFDEF CU}
    CUUDEvent := 0;
    If (Sender is Text8Pt)then
      With (Sender as Text8pt) do
      Begin
        If (Not ReadOnly) then
        Begin
          If (Sender=QSF1) then
          Begin
            ExLocal.LJobRec^.JQSCode:=Text;
            CUUDEvent:=9;
          end;



          Result:=IntExitHook(5000,30+CUUDEvent,-1,ExLocal);

          If (Result=0) then
            SetFocus
          else
          With ExLocal do
          If (Result=1) then
          Begin
            Case CUUDEvent of
              9  :  Text:=LJobRec^.JQSCode;
            end; {Case..}
          end;
        end;
     end; {With..}

  {$ELSE}
    CUUDEvent:=0;

  {$ENDIF}
end;



procedure TRepJCPInp.QSF1Exit(Sender: TObject);
begin
  inherited;

  If (Sender is Text8Pt)  and (ActiveControl<>ClsCP1Btn) then
      Text8pt(Sender).ExecuteHookMsg;
end;

procedure TRepJCPInp.OkCP1BtnClick(Sender: TObject);
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

        I1PrYrF.InitPeriod(RPr,RYr,BOff,BOff);
        I2PrYrF.InitPeriod(RPr2,RYr2,BOff,BOff);

        CustFilt:=AcFF.Text;
        {QtyMode:=RepQtyChk.Checked;
        UnInv:=SUInvChk.Checked;}

        Summary:=Sum1.Checked;

        JobFilt:=FullJobCode(ProdF.Text);
        EmpFilt:=SubCF.Text;
        CertMode:=IncFcb.ItemIndex;
        ShowOCbal:=BOn;
        SortOrd:=Sortcb.ItemIndex;
        JCTFilt:=JCTFiltF.Text;

        QSFilt:=QSF1.Text;

        AddJCAppsRep2Thread(RepMode,CRepParam,Owner);
      end;

      inherited;
    End // If AutoExitValidation
    Else
      ModalResult := mrNone;
  End // If (Sender=OkCP1Btn)
  Else
    inherited;
end;



procedure JAApps1_Report(IDMode  :  Byte;
                         AOwner  :  TComponent);

  Var
    RepInpMsg1  :  TRepJCPInp;

  Begin
    JAMode:=IdMode;

    RepInpMsg1:=TRepJCPInp.Create(AOwner);

  end;



Begin
  JAMode:=0;




end.
