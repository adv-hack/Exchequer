unit RepInpYU;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  Repinp1u, StdCtrls, ExtCtrls, bkgroup, TEditVal, BorBtns, Mask, BTSupU3,
  Animate, SBSPanel;

type
  TRepInpMsgW2 = class(TRepInpMsg)
    AccLab: Label8;
    Label810: Label8;
    AccF3: Text8Pt;
    StkFiltF: Text8Pt;
    Sum1: TBorCheck;
    Label81: Label8;
    I1PrYrF: TEditPeriod;
    Label82: Label8;
    I2PrYrF: TEditPeriod;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormCreate(Sender: TObject);
    procedure AccF3Exit(Sender: TObject);
    procedure StkFiltFExit(Sender: TObject);
    procedure OkCP1BtnClick(Sender: TObject);
    function I1PrYrFShowPeriod(Sender: TObject; const EPr: Byte): String;
    function I1PrYrFConvDate(Sender: TObject; const IDate: String;
      const Date2Pr: Boolean): String;
  private
    { Private declarations }
    RepMode    :  Byte;

    CRepParam  :  WOPRepPtr;

  public
    { Public declarations }
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
  ReportWU,
  SysU1,
  SysU2,
  BTSupU2;


{$R *.DFM}



procedure TRepInpMsgW2.FormCreate(Sender: TObject);


Var
  HideLoc,
  HideCC  :  Boolean;
  TB,LPr,LYr
          :  Byte;

begin
  inherited;

  ClientHeight:=182;
  ClientWidth:=349;

  RepMode:=3;


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

procedure TRepInpMsgW2.FormClose(Sender: TObject; var Action: TCloseAction);

begin
  inherited;

  If (Assigned(CRepParam)) then
    Dispose(CRepParam);
end;



procedure TRepInpMsgW2.AccF3Exit(Sender: TObject);
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

    If ((AltMod) and (FoundCode<>'')) and (ActiveControl<>ClsCP1Btn) then
    Begin

      StillEdit:=BOn;

      FoundOk:=(GetNom(Self,FoundCode,FoundLong,99));


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


procedure TRepInpMsgW2.StkFiltFExit(Sender: TObject);
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

      FoundOk:=(GetStock(Self,FoundCode,FoundCode,99));


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


function TRepInpMsgW2.I1PrYrFShowPeriod(Sender: TObject;
  const EPr: Byte): String;
begin
  inherited;
  Result:=RepInpPPr_Pr(EPr);
end;

function TRepInpMsgW2.I1PrYrFConvDate(Sender: TObject; const IDate: String;
  const Date2Pr: Boolean): String;
begin
  inherited;
  Result:=RepInpConvInpPr(IDate,Date2Pr);
end;

procedure TRepInpMsgW2.OkCP1BtnClick(Sender: TObject);
begin
  If (Sender=OkCP1Btn) then
  Begin
    If AutoExitValidation Then
    Begin
      With CRepParam^ do
      Begin
        OKCP1Btn.Enabled:=BOff;


        GLFilt:=IntStr(Trim(AccF3.Text));

        StockFilt:=StkFiltF.Text;

        I1PrYrF.InitPeriod(RPr,RYr,BOff,BOff);
        I2PrYrF.InitPeriod(RPr2,RYr2,BOff,BOff);

        UseSalesOB:=Sum1.Checked;

        AddWOP1Rep2Thread(RepMode,CRepParam,Owner);

      end;

      inherited;
    End // If AutoExitValidation
    Else
      ModalResult := mrNone;
  End // If (Sender=OkCP1Btn)
  Else
    inherited;
end;




Initialization


end.
