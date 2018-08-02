unit RepInp5U;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs, BTSupU3,
  Repinp1u, StdCtrls, TEditVal, Mask, ExtCtrls, SBSPanel, bkgroup, Animate,
  BorBtns, ComCtrls;

type
  TRepInpMsg5 = class(TRepInpMsg)
    ACFF: Text8Pt;
    ACTF: Text8Pt;
    Label83: Label8;
    Label82: Label8;
    Label85: Label8;
    EMLF: TSBSComboBox;
    Label81: Label8;
    Label89: Label8;
    FilterX: TSBSComboBox;
    chkBackdatedTransactions: TBorCheck;
    cbAgeInt: TSBSComboBox;
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure OkCP1BtnClick(Sender: TObject);
    procedure ACFFExit(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure FormKeyPress(Sender: TObject; var Key: Char);
  private
    RepMode    :  Byte;
    CRepParam  :  CustRepPtr;
    procedure SetHelpContextIDs; // NF: 10/05/06
  public
    {Public declarations }
    CSMode     :  Boolean;

  end;


procedure Debt_Run(AOwner  :  TComponent;
                   RM      :  Byte;
                   CSM     :  Boolean);


{~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~}

Implementation

{~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~}

Uses
  ETStrU,
  ETDateU,
  ETMiscU,
  GlobVar,
  VarConst,
  Event1U,
  InvListU,
  ReportU,
  ExWrap1U,
  SysU2,
  BTSupU2;


{$R *.DFM}


Var
  GIdM  :  Byte;


procedure TRepInpMsg5.FormCreate(Sender: TObject);

Const
  RepTit  :  Array[3..10] of Str80 = ('Debt Chase Letters','','Trading Ledger','','','Account Details','','Account Labels');

begin
  inherited;

  ClientHeight:=210;
  ClientWidth:=299;

  RepMode:=GIDM;

  Caption:=RepTit[RepMode];

  Case RepMode of
    3  :  HelpContext:=622;
    5  :  Begin
            HelpContext:=702;
            ACFF.HelpContext:=652;
            ACTF.HelpContext:=652;
          end;
    8  :  Begin
            HelpContext:=701;
            ACFF.HelpContext:=652;
            ACTF.HelpContext:=652;
          end;
    10 :  HelpContext:=703;
  end;

  If (RepMode<>3) then
  Begin
    Label85.Visible:=BOff;
    cbAgeInt.Visible:=BOff;
    Label81.Visible:=BOff;
    EMLF.Visible:=BOff;
    Label83.Top:=Label81.Top;
    ACFF.Top:=EMLF.Top;
    ACTF.Top:=EMLF.Top;
    Label82.Top:=Label81.Top;

    Label89.Visible:=BOff;
    FilterX.Visible:=BOff;

    chkBackdatedTransactions.Visible := False;
  end
  else
  Begin
    EMLF.ItemIndex:=0;

    FilterX.ItemIndex:=0;


    If (Not (Syss.DebtLMode In [0,1])) then
    Begin
      Label85.Visible:=BOff;
      cbAgeInt.Visible:=BOff;
    end;
  end;

  New(CRepParam);

  try
    FillChar(CRepParam^,Sizeof(CRepParam^),0);
  except
    Dispose(CRepParam);
    CRepParam:=nil;
  end;

  SetLastValues;

  {$IFDEF LTE}
    FilterX.ITems.Delete(2);
  {$ENDIF}


  SetHelpContextIDs; // NF: 10/05/06 Fix for incorrect Context IDs
end;

procedure TRepInpMsg5.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  inherited;

  If (Assigned(CRepParam)) then
    Dispose(CRepParam);

end;

procedure TRepInpMsg5.OkCP1BtnClick(Sender: TObject);
Var
  ExLocal  :  TdExLocal;
begin
  If (Sender=OkCP1Btn) then
  Begin
    If AutoExitValidation Then
    Begin
      ExLocal.Create;
      Try
        {$IFDEF CU}
        If (RepMode<>3) or (ValidExitHook(1000,104,ExLocal)) then
        {$ENDIF}
        Begin
          With CRepParam^ do
          Begin
            OKCP1Btn.Enabled:=BOff;
            StaStart:=ACFF.Text;
            StaEnd:=ACTF.Text;

            If (Trim(StaEnd)='') then
              StaEnd:=NdxWeight;

            If (RepMode = 3) Then
              // Use existing unused flag to store the Backdated Transactions flag for the Debt Chase Letter routine
              stSepCr := chkBackdatedTransactions.Checked;

            If (RepMode In [5,8,10]) then
              ShowOS:=CSMode
            else
            Begin
              DebtLevel:=cbAgeInt.ItemIndex;

              If (EMLF.ItemIndex>=0) then
                NonIncStat:=EMLF.ItemIndex;

              SFiltBy:=FilterX.ItemIndex;

              {$IFDEF LTE}
                If (SFiltBy=2) then
                  SFiltBy:=3;
              {$ENDIF}
            End;

            AddStaRep2Thread(RepMode,CRepParam,Owner);
          End; // With CRepParam^
        End; // If (RepMode<>3) or (ValidExitHook(1000,104,ExLocal))

        inherited;
      Finally
        ExLocal.Destroy;
      End; // Try..Finally
    End // If AutoExitValidation
    Else
      ModalResult := mrNone;
  End // If (Sender=OkCP1Btn)
  Else
    inherited;
end;

procedure TRepInpMsg5.ACFFExit(Sender: TObject);
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

      FoundOk:=(GetCust(Application.MainForm,FoundCode,FoundCode,CSMode,0));


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


procedure Debt_Run(AOwner  :  TComponent;
                   RM      :  Byte;
                   CSM     :  Boolean);

Var
  RepInpMsg1  :  TRepInpMsg5;

Begin

  GIdM:=RM;

  RepInpMsg1:=TRepInpMsg5.Create(AOwner);

  try
    RepInpMsg1.CSMode:=CSM;
  except
    RepInpMsg1.Free;
  end; {try..}

end;



procedure TRepInpMsg5.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  {}
  Inherited;
end;

procedure TRepInpMsg5.FormKeyPress(Sender: TObject; var Key: Char);
begin
  {}
  Inherited;
end;

// NF: 10/05/06 Fix for incorrect Context IDs
procedure TRepInpMsg5.SetHelpContextIDs;
begin
  FilterX.HelpContext := 1753;
  cbAgeInt.HelpContext := 2088; // NF: 25/07/06
end;


Initialization

  GIdM:=0;

end.

