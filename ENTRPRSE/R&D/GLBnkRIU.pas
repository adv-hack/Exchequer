unit GLBnkRIU;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  Repinp1u, StdCtrls, Mask, TEditVal, ExtCtrls, bkgroup, Animate, SBSPanel;

type
  TGLReconFrm = class(TRepInpMsg)
    Label82: Label8;
    CurrF: TSBSComboBox;
    Label83: Label8;
    ACFF: Text8Pt;
    procedure FormCreate(Sender: TObject);
    procedure ACFFExit(Sender: TObject);
    procedure OkCP1BtnClick(Sender: TObject);
    procedure CurrFExit(Sender: TObject);
    procedure ClsCP1BtnClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
  private
    { Private declarations }
    AutoMode  :  Boolean;

    procedure Display_Recon(OutNomCode  :  LongInt;
                            NCr         :  Byte);

    procedure Show_BatchList(CtrlCr  :  Byte;
                             CtrlNom :  LongInt);

  public
    { Public declarations }
  end;


procedure Recon_BankGL(AOwner  :  TComponent;
                       AutoMode:  Boolean);


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
  BTKeys1U,
  BTSupU2,
  BankRCU,
  BankRCSU,
  ExThrd2U,
  SysU1,
  {$IFDEF CU}
    ExWrap1U,
    Event1U,
  {$ENDIF}
  ReconU;


{$R *.DFM}

Var
  BRAutoMode  :  Boolean;




procedure TGLReconFrm.FormCreate(Sender: TObject);

begin
  inherited;
  {$IFDEF MC_On}

    Set_DefaultCurr(CurrF.Items,BOn,BOff);
    Set_DefaultCurr(CurrF.ItemsL,BOn,BOn);
    CurrF.ItemIndex:=1;

  {$ELSE}
    Label82.Visible:=BOff;
    CurrF.Visible:=BOff;

  {$ENDIF}

  AutoMode:=BRAutoMode;

  If (AutoMode) then
    Self.HelpContext:=590;

  ClientHeight:=144;
  ClientWidth:=299;

end;


procedure TGLReconFrm.ACFFExit(Sender: TObject);
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

    If ((AltMod) or (FoundCode='')) and (ActiveControl<>ClsCP1Btn) then
    Begin

      StillEdit:=BOn;

      FoundOk:=(GetNom(Self.Owner,FoundCode,FoundLong,77));


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


procedure TGLReconFrm.Display_Recon(OutNomCode  :  LongInt;
                                    NCr         :  Byte);


Var
  NomNHCtrl    :  TNHCtrlRec;

  FoundLong    :  Longint;

  ReconForm    :   TReconList;


Begin
  With NomNHCtrl do
  Begin
    FillChar(NomNHCtrl,Sizeof(NomNHCtrl),0);

    NHMode:=3;

    NHCr:=NCr;
    NHYr:=GetLocalPr(0).CYr;
    NHPr:=GetLocalPr(0).CPr;

    NHNomCode:=OutNomCode;

    If (Nom.NomCode<>NHNomCode) then
      GetNom(Self.Owner,Form_Int(NHNomCode,0),FoundLong,-1);


    NHKeyLen:=Succ(Sizeof(Nom.NomCode));  {* NomCode+NomMode *}

    {$IFDEF MC_On}

      If (NHCr<>0) then
      Begin

        Inc(NHKeyLen);  { Include Currency }

      end;


    {$ENDIF}


    With Nom do
    Begin
      MainK:=FullIdPostKey(NomCode,0,0,NHCr,0,0);
    end;


    Set_DDFormMode(NomNHCtrl);

  end;

  ReconForm:=TReconList.Create(Self.Owner);


  Try

   With ReconForm do
   Begin

     WindowState:=wsNormal;

     ShowLink(BOn);

   end; {With..}


  except

   ReconForm.Free;
   ReconForm:=nil;

  end; {try..}


end;



procedure TGLReconFrm.Show_BatchList(CtrlCr  :  Byte;
                                     CtrlNom :  LongInt);

Var
  BPay  :  TBankARec;
Begin
  Set_ABRFormMode(CtrlCr,CtrlNom);

  BPay:=TBankARec.Create(Self.Owner);

  try
    With BPay do
    Begin

      BankM_CtrlGet(PwrdF,PWK,CtrlNom,CtrlCr,BankMCtrl,nil);

      RefreshList(BOn,BOn);


    end;
  except
    BPay.Free;

  end;

end;


procedure TGLReconFrm.CurrFExit(Sender: TObject);
begin
  inherited;
  If (CurrF.ItemIndex<0) then
    CurrF.ItemIndex:=0;
end;


procedure TGLReconFrm.OkCP1BtnClick(Sender: TObject);
Var
  RCr        :  Byte;
  ReconCode  :  LongInt;
  {$IFDEF CU}
    ExLocal    :  TdExLocal;
  {$ENDIF}
begin
  if (ModalResult = mrOK) then
  begin
    ACFF.SetFocus;
    // Move focus to OK button to force OnExit validation/formatting to kick in
    If OkCP1Btn.CanFocus Then
      OkCP1Btn.SetFocus;
  end;

  // If focus isn't on the OK button then that implies a validation error so the store should be abandoned
  If (ActiveControl = OkCP1Btn) Then
  Begin
    {$IFDEF MC_On}
      RCr:=CurrF.ItemIndex;
    {$ENDIF}

    ReconCode:=IntStr(Trim(AcfF.Text));

    {$IFDEF CU}
      ExLocal.Create;
      Try
        ReconCode:=IntExitHook(2050,102,ReconCode,ExLocal);
      Finally
        ExLocal.Destroy;
      end; {try..}
    {$ENDIF}

    If (ReconCode>0) then
    Begin
      If (Not AutoMode) then
        Display_Recon(ReconCode,RCr)
      else
      Begin
        If (Not Check_BRecAlready(ReconCode,RCr)) then
          Show_BatchList(RCr,ReconCode)
        else
        Begin
          Set_BackThreadMVisible(BOn);
          ShowMessage('That bank account is already being reconciled.');
          Set_BackThreadMVisible(BOff);
        end;
      end;
      Close;
    end;
  end;
end;


procedure Recon_BankGL(AOwner  :  TComponent;
                       AutoMode:  Boolean);

Var
  RepInpMsg1  :  TGLReconFrm;

Begin

  BRAutoMode:=AutoMode;

  RepInpMsg1:=TGLReconFrm.Create(AOwner);

end;



procedure TGLReconFrm.ClsCP1BtnClick(Sender: TObject);
begin
  Close;
end;

procedure TGLReconFrm.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  inherited;
  //PR: 15/05/2017 ABSEXCH-18683 v2017 R1 Release process lock
{  if ModalResult <> mrOK then
    SendMessage(Application.MainForm.Handle, WM_LOCKEDPROCESSFINISHED, Ord(plBankReconciliation), 0);}
end;

Initialization

  BRAutoMode:=BOff;

end.
