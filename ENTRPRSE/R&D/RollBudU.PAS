unit RollBudU;

{$I DEFOVR.Inc}

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  Repinp1u, StdCtrls, ExtCtrls, BTSupU3, bkgroup, BorBtns, TEditVal, Mask,
  Animate, SBSPanel, VarConst, GlobVar;

type
  TRollBudgetInp = class(TRepInpMsg)
    RU1CB: TBorRadio;
    RU2CB: TBorRadio;
    BasisCB: TSBSComboBox;
    Label81: Label8;
    BudgetCB: TSBSComboBox;
    Label82: Label8;
    procedure FormCreate(Sender: TObject);
    procedure OkCP1BtnClick(Sender: TObject);
  private
    { Private declarations }

  public
    { Public declarations }
    NomR       :  NominalRec;
  end;


  procedure Roll_Budget(AOwner  :  TComponent;
                        RNom    :  NominalRec);

{~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~}

Implementation

{~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~}

Uses
  ETStrU,
  ETDateU,
  ETMiscU,
  BtrvU2,
  BTKeys1U,
  ComnU2,
  BTSupU1,
  GenWarnU,
  PayF2U,
  ThemeFix;


{$R *.DFM}



procedure TRollBudgetInp.FormCreate(Sender: TObject);


Var
  HideLoc  :  Boolean;

begin
  inherited;

  // MH 10/01/2011 v6.6 ABSEXCH-10548: Modified theming to fix problem with drop-down lists
  ApplyThemeFix (Self);

  ClientHeight:=183;
  ClientWidth:=299;

  Animated1.Visible:=BOff;

  BasisCB.ItemIndex:=0;
  BudgetCB.ItemIndex:=0;

  SetLastValues;

  If (Not Syss.PostCCDCombo) then
  With BasisCB do {Remove option for combo}
  Begin
    Items.Delete(Pred(Items.Count));
    Items.Delete(Pred(Items.Count));
  end;

  

end;

procedure TRollBudgetInp.OkCP1BtnClick(Sender: TObject);

Const
  RollTit  :  Array[0..4] of Str40 = ('Cost Centre','Department','CC + Dep (Individual)','CC/Dep combined','Dep/CC Combined');

  Fnum     =  NomF;
  Keypath  =  NomCodeK;

Var
  Ok2Cont  :  Boolean;

  ThisNom  :  NominalRec;

  KeyS     :  Str255;

begin
  If (Sender=OkCP1Btn) and (BasisCB.ItemIndex>=0) and (BudgetCB.ItemIndex>=0) then
  Begin
    Ok2Cont:=(CustomDlg(Self,'Please Confirm!','Roll Up CC/Dep Budgets',
                             'Please confirm you wish to Roll Up the '+RollTit[BasisCB.ItemIndex]+' budgets into the main G/L Code budget.',
                             mtConfirmation,
                             [mbYes,mbNo])=mrOk);


  end
  else
    Ok2Cont:=BOff;

  If OK2Cont then
  Begin
    OKCP1Btn.Enabled:=BOff;

    Blank(ThisNom,Sizeof(ThisNom));

    If (RU2CB.Checked) then
      ThisNom:=NomR;

    If (ThisNom.Cat<>0) and (ThisNom.NomType<>NomHedCode) then {Get Parent}
    Begin
      KeyS:=FullNomKey(ThisNom.Cat);

      Status:=Find_Rec(B_GetEq,F[Fnum],Fnum,RecPtr[Fnum]^,KeyPath,KeyS);

      If (StatusOk) then
        ThisNom:=Nom;

    end;

    RollUpBudget2Thread(Owner,5,BasisCB.ITemIndex,BudgetCB.ITemIndex,ThisNom);
  end;

  inherited;

end;


  procedure Roll_Budget(AOwner  :  TComponent;
                        RNom    :  NominalRec);

  Var
    RepInpMsg1  :  TRollBudgetInp;

  Begin
    RepInpMsg1:=TRollBudgetInp.Create(AOwner);

    Try
      RepInpMsg1.NomR:=RNom;
    except
      RepInpMsg1.Free;
    end; {Try..}

  end;




end.
