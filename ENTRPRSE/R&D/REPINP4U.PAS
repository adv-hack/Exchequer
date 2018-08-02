Unit RepInp4U;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  Repinp1u, ExtCtrls, SBSPanel, StdCtrls, TEditVal, BorBtns, Mask,BTSupU3,
  bkgroup, Animate;

type
  TRepInpMsg4 = class(TRepInpMsg)
    AgeX: TSBSComboBox;
    AgeInt: TCurrencyEdit;
    I1TransDateF: TEditDate;
    OS1: TBorCheck;
    SepCr: TBorCheck;
    ACFF: Text8Pt;
    ACTF: Text8Pt;
    Label87: Label8;
    Label86: Label8;
    Label84: Label8;
    Label85: Label8;
    Label81: Label8;
    Label83: Label8;
    Label82: Label8;
    Label88: Label8;
    ACFI: Text8Pt;
    Label89: Label8;
    FilterX: TSBSComboBox;
    Label810: Label8;
    CurrF: TSBSComboBox;
    Label811: Label8;
    IncF: TSBSComboBox;
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure OkCP1BtnClick(Sender: TObject);
    procedure ACFFExit(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure FormKeyPress(Sender: TObject; var Key: Char);
    procedure Label81Click(Sender: TObject);
  private
    { Private declarations }
    CRepParam  :  CustRepPtr;

    procedure EnableCurrency;

    procedure SetHelpContextIDs; // NF: 10/05/06

  public
    { Public declarations }
  end;

procedure Statement_Run(AOwner  :  TComponent);

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
  BTSupU1,
  BTSupU2;


{$R *.DFM}

procedure TRepInpMsg4.FormCreate(Sender: TObject);

Var
  AgeDate  :  LongDate;
  Lm,Ly    :  Word;

begin
  inherited;

  ClientHeight:=268;
  ClientWidth:=299;

  {$IFNDEF MC_On}

     SepCr.Visible:=BOff;
     Label81.Visible:=BOff;
     CurrF.Visible:=BOff;
     Label810.Visible:=BOff;
  {$ELSE}

    Set_DefaultCurr(CurrF.Items,BOn,BOff);
    Set_DefaultCurr(CurrF.ItemsL,BOn,BOn);
    CurrF.ItemIndex:=0;


  {$ENDIF}

  IncF.ItemIndex:=0;
  IncF.Visible:=BOn;
  Label811.Visible:=BOn;


  New(CRepParam);

  try
    FillChar(CRepParam^,Sizeof(CRepParam^),0);
  except
    Dispose(CRepParam);
    CRepParam:=nil;
  end;

  If (Not eCommsModule) then
  Begin
    Label89.Visible:=BOff;
    FilterX.Visible:=BOff;
  end
  else
    FilterX.ItemIndex:=0;

  With Syss do
  Begin
    OS1.Checked:=StaShowOS;

    If (StaAgeMthd In [1..3]) then
      AgeX.ItemIndex:=Pred(StaAgeMthd)
    else
      AgeX.ItemIndex:=2;

    AgeInt.Value:=StaAgeInt;

    SepCr.Checked:=StaSepCr;

    AgeDate:=Today;

    Lm:=Part_Date('M',AgeDate);
    Ly:=Part_Date('Y',AgeDate);

    AdjMnth(Lm,Ly,-1);

    If (Lm<>2) then
      AgeDate:=StrDate(Ly,Lm,MonthDays[Lm])
    else
      AgeDate:=StrDate(Ly,Succ(Lm),1);

    I1TransDateF.DateValue:=AgeDate;
  end; {With..}

  {$IFDEF LTE}
    FilterX.ITems.Delete(2);
  {$ENDIF}

  EnableCurrency;
  
  SetLastValues;

  SetHelpContextIDs; // NF: 10/05/06 Fix for incorrect Context IDs
end;

procedure TRepInpMsg4.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  inherited;

  If (Assigned(CRepParam)) then
    Dispose(CRepParam);

end;

procedure TRepInpMsg4.EnableCurrency;

Begin
  CurrF.Enabled:=SepCr.Checked;
  CurrF.TabStop:=SepCr.Checked;

  If (Not SepCr.Checked) then
  Begin
    CurrF.ITemIndex:=0;
  end
end;


procedure TRepInpMsg4.Label81Click(Sender: TObject);
begin
  inherited;
  EnableCurrency;
end;


procedure TRepInpMsg4.OkCP1BtnClick(Sender: TObject);
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
        If ValidExitHook(1000,103,ExLocal) Then
        {$ENDIF}
        Begin
          With CRepParam^ do
          Begin
            OKCP1Btn.Enabled:=BOff;

            ShowOS:=OS1.Checked;
            AgeDate:=I1TransDateF.DateValue;
            SAgeBy:=Succ(AgeX.ItemIndex);
            SAgeInt:=Round(AgeInt.Value);

            If (FilterX.ItemIndex>=0) then
              SFiltBy:=FilterX.ItemIndex;

            {$IFDEF LTE}
              If (SFiltBy=2) then
                SFiltBy:=3;
            {$ENDIF}

            {$IFNDEF MC_ON}
              RCr:=0;
            {$Else}
              RCr:=CurrF.ItemIndex;
              StSepCr:=SepCr.Checked;
            {$Endif}

            StaStart:=ACFF.Text;
            StaEnd:=ACTF.Text;
            AccTFilt:=ACFI.Text;

            If (IncF.ItemIndex>=0) then
              SBalIncF:=IncF.ItemIndex;


            If (Trim(StaEnd)='') then
              StaEnd:=NdxWeight;

            GlobLocked:=BOn;

            GetMultiSys(BOn,GlobLocked,SysR);

            With Syss do {* Update Last Record *}
            Begin

              StaSepCr:=StSepCr;
              StaAgeMthd:=SAgeBy;
              StaAgeInt:=SAgeInt;
              StaShowOs:=ShowOs;

              PutMultiSys(SysR,BOn);

            end;

            AddStaRep2Thread(2,CRepParam,Owner);
          End; // With CRepParam^
        End; // If ValidExitHook(1000,103,ExLocal)

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

procedure TRepInpMsg4.ACFFExit(Sender: TObject);
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

      FoundOk:=(GetCust(Self,FoundCode,FoundCode,BOn,0));


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


procedure Statement_Run(AOwner  :  TComponent);

Var
  RepInpMsg1  :  TRepInpMsg4;

Begin

  RepInpMsg1:=TRepInpMsg4.Create(AOwner);



end;



procedure TRepInpMsg4.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  {}
  Inherited;
end;

procedure TRepInpMsg4.FormKeyPress(Sender: TObject; var Key: Char);
begin
  {}
  Inherited;
end;

// NF: 10/05/06 Fix for incorrect Context IDs
procedure TRepInpMsg4.SetHelpContextIDs;
begin
  IncF.HelpContext := 1583;
  FilterX.HelpContext := 1722;
end;


end.
