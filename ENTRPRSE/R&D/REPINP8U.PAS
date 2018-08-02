unit RepInp8U;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  Repinp1u, StdCtrls, BTSupU3, bkgroup, BorBtns, TEditVal, Mask, ExtCtrls,
  Animate, SBSPanel;

type
  TRepInpMsg8 = class(TRepInpMsg)
    Label87: Label8;
    I1TransDateF: TEditDate;
    CurrF: TSBSComboBox;
    Label81: Label8;
    AgeInt: TCurrencyEdit;
    Label85: Label8;
    Label82: Label8;
    ACFF: Text8Pt;
    Label84: Label8;
    I1PrYrF: TEditPeriod;
    Label88: Label8;
    Back1: TBorCheck;
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure ACFFExit(Sender: TObject);
    procedure OkCP1BtnClick(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure FormKeyPress(Sender: TObject; var Key: Char);
    function I1PrYrFConvDate(Sender: TObject; const IDate: String;
      const Date2Pr: Boolean): String;
    function I1PrYrFShowPeriod(Sender: TObject; const EPr: Byte): String;
  private
    { Private declarations }
    CRepParam  :  DocRepPtr;

  public
    { Public declarations }
  end;

procedure Recon_Report(IdMode  :  Byte;
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
  Report3U,

  SysU1,
  SysU2,
  BTSupU2;

{$R *.DFM}






procedure TRepInpMsg8.FormCreate(Sender: TObject);

Var
  LPr,LYr  :  Byte;

begin
  inherited;
  ClientHeight:=216;
  ClientWidth:=299;


  {$IFDEF MC_On}

    Set_DefaultCurr(CurrF.Items,BOn,BOff);
    Set_DefaultCurr(CurrF.ItemsL,BOn,BOn);
    CurrF.ItemIndex:=0;

  {$ELSE}
    Label81.Visible:=BOff;
    CurrF.Visible:=BOff;

  {$ENDIF}


  New(CRepParam);

  try
    FillChar(CRepParam^,Sizeof(CRepParam^),0);
  except
    Dispose(CRepParam);
    CRepParam:=nil;
  end;

  I1TransDateF.DateValue:=Today;

  LPr:=GetLocalPr(0).CPr;
  LYr:=GetLocalPr(0).CYr;

  I1PrYrF.InitPeriod(LPr,LYr,BOn,BOn);

  SetLastValues;
end;

procedure TRepInpMsg8.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  inherited;

  If (Assigned(CRepParam)) then
    Dispose(CRepParam);

end;

procedure TRepInpMsg8.ACFFExit(Sender: TObject);
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

      FoundOk:=(GetNom(Self,FoundCode,FoundLong,0));


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



procedure TRepInpMsg8.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  {}
  Inherited;
end;

procedure TRepInpMsg8.FormKeyPress(Sender: TObject; var Key: Char);
begin
  {}
  Inherited;
end;

function TRepInpMsg8.I1PrYrFConvDate(Sender: TObject; const IDate: String;
  const Date2Pr: Boolean): String;
begin
  inherited;
  RepInpConvInpPr(IDate,Date2Pr);
end;


function TRepInpMsg8.I1PrYrFShowPeriod(Sender: TObject;
  const EPr: Byte): String;
begin
  inherited;
  Result:=RepInpPPr_Pr(EPr);
end;


procedure TRepInpMsg8.OkCP1BtnClick(Sender: TObject);
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
        {$ENDIF}


        I1PrYrF.InitPeriod(RPr,RYr,BOff,BOff);
        ReconCode:=IntStr(Trim(AcfF.Text));
        DueLimit:=I1TransDateF.DateValue;

        ShowPIMode:=Back1.Checked;

        StatTotal:=AgeInt.Value;

        AddDocRep2Thread(1,0,CRepParam,Owner);
      end;

      inherited;
    End // If AutoExitValidation
    //Else
      //ModalResult := mrNone;
  End // If (Sender=OkCP1Btn)
  Else
    inherited;
end;


procedure Recon_Report(IdMode  :  Byte;
                       AOwner  :  TComponent);

Var
  RepInpMsg1  :  TRepInpMsg8;

Begin

  RepInpMsg1:=TRepInpMsg8.Create(AOwner);

end;



end.
