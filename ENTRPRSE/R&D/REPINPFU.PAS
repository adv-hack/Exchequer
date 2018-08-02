unit RepInpFU;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  Repinp1u, StdCtrls, ExtCtrls, bkgroup, BTSupU3, Mask, TEditVal, GlobVar,
  Animate, SBSPanel, VarRec2U;

type
  TRepInpMsgF = class(TRepInpMsg)
    Label86: Label8;
    Label87: Label8;
    I1TransDateF: TEditDate;
    I2TransDateF: TEditDate;
    Label81: Label8;
    ECSigF: Text8Pt;
    Label82: Label8;
    ECIEPF: Text8Pt;
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure OkCP1BtnClick(Sender: TObject);
    procedure ECIEPFExit(Sender: TObject);
  private
    { Private declarations }
    CRepParam  :  CVATRepPtr;

    IRVInp     :  IRVInpType;

    Procedure Get_ECSuggest(LastDate  :  LongDate;
                        Var StartDate,
                            EndDate   :  LongDate);


  public
    { Public declarations }
  end;

{~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~}

Implementation

{~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~}

Uses
  ETStrU,
  ETMiscU,
  ETDateU,
  VarConst,

  InvListU,
  ReportAU,
  RepInpVU,
  SysU1,
  SysU2,
  BTSupU2;

{$R *.DFM}

{ ========= Calculate next EC Suggested sales Range ========= }

Procedure TRepInpMsgF.Get_ECSuggest(LastDate  :  LongDate;
                                Var StartDate,
                                    EndDate   :  LongDate);



Var

  Ld,Lm,Ly  :  Word;



Begin

  DateStr(LastDate,Ld,Lm,Ly);

  AdjMnth(Lm,Ly,1);

  Ld:=01;

  StartDate:=StrDate(Ly,Lm,Ld);

  AdjMnth(Lm,Ly,2);

  Ld:=Monthdays[Lm];

  EndDate:=StrDate(Ly,Lm,Ld);

end; {Proc..}


procedure TRepInpMsgF.FormCreate(Sender: TObject);
begin
  inherited;
  ClientHeight:=152;
  ClientWidth:=323;


  New(Self.CRepParam);


  try
    With Self.CRepParam^ do
    Begin
      FillChar(Self.CRepParam^,Sizeof(Self.CRepParam^),0);

      Get_ECSuggest(SyssVAT.VATRates.LastECSalesDate,VATStartD,VATEndD);

      I1TransDateF.DateValue:=VATStartD;
      I2TransDateF.DateValue:=VATEndD;

      If (CurrentCountry=IECCode) then
      Begin
        Label81.Visible:=BOn;
        Label82.Visible:=BOn;
        ECSigF.Visible:=BOn;
        ECIEPF.Visible:=BOn;

        If (Get_LastIRVVal(FullIRVFile(AllocTCode,AllocSCode,2),IRVInp)) then
        With IRVInp do
        Begin
          VSig:=Signtry;
          VType:=VIESType;
          ECSigF.Text:=VSig;
          ECIEPF.Text:=VType;
        end;


      end;
    end;
  except
    Dispose(Self.CRepParam);
    Self.CRepParam:=nil;
  end;

  If (CurrentCountry=IECCode) Then
    Caption:= ' - VIES Statement';
  Caption:=CCVATName^+Caption;

  SetLastValues;
end;

procedure TRepInpMsgF.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  inherited;

  If (Assigned(CRepParam)) then
    Dispose(CRepParam);

end;

procedure TRepInpMsgF.ECIEPFExit(Sender: TObject);
begin
  inherited;

  With ECIEPF do
  Begin
    If (Text<>'M') and (Text<>'Q') and (Text<>'A1') and (Text<>'A2') then
    Begin
      ShowMessage('The period must be M,Q,A1, or A2');

      SetFocus;
    end;

  end;


end;


procedure TRepInpMsgF.OkCP1BtnClick(Sender: TObject);
begin
  If (Sender=OkCP1Btn) then
  Begin
    If AutoExitValidation Then
    Begin
      With Self.CRepParam^ do
      Begin
        OKCP1Btn.Enabled:=BOff;

        VATStartD:=I1TransDateF.DateValue;
        VATEndD:=I2TransDateF.DateValue;

        With IRVInp do
        If (CurrentCountry=IECCode) then
        Begin
          Signtry:=UpCaseStr(ECSigF.Text);
          VIESType:=UpCaseStr(ECIEPF.Text);

          VSig:=Signtry;
          VType:=VIESType;

          Put_LastIRVVal(AllocSCode,IRVInp,2);
        end;

        //PR: 19/02/2014 ABSEXCH-15042 Include services for ireland
        if Syss.USRCntryCode = IECCode then
          AddECVATRep2Thread(EC_SALES_REPORT_MODE, CRepParam,Owner, True, True)
        else
          AddECVATRep2Thread(EC_VAT_REPORT_MODE, CRepParam,Owner);
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
