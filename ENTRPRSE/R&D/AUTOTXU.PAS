unit AutoTxU;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  BorBtns, ExtCtrls, SBSPanel, TEditVal, StdCtrls, Mask,
  GlobVar,VarConst, bkgroup;

type
  TAutoTxPop = class(TForm)
    SBSPanel1: TSBSPanel;
    ClsCP1Btn: TButton;
    OkCP1Btn: TButton;
    ASDate1F: TEditDate;
    ASPeriod1F: TEditPeriod;
    ASDate2F: TEditDate;
    ASPeriod2F: TEditPeriod;
    ASAF: TBorCheck;
    ASDF: TBorRadio;
    ASPF: TBorRadio;
    ASNPerF: TCurrencyEdit;
    SBSBackGroup1: TSBSBackGroup;
    Label4: TLabel;
    Label1: TLabel;
    Label3: TLabel;
    ASKDF: TBorCheck;
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure FormKeyPress(Sender: TObject; var Key: Char);
    procedure ASDFClick(Sender: TObject);
    function ASPeriod1FConvDate(Sender: TObject; const IDate: string;
      const Date2Pr: Boolean): string;
    function ASPeriod1FShowPeriod(Sender: TObject;
      const EPr: Byte): string;
    procedure ASDate2FExit(Sender: TObject);
    procedure ASPeriod2FExit(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure OkCP1BtnClick(Sender: TObject);
  private
    { Private declarations }

    PrevHState  :  Boolean;

    Procedure OutAS;

    Procedure SetASStore(EnabFlg  :  Boolean;
                         DPMode   :  Byte);

    Procedure Form2AS;

    procedure SetHelpContextIDs; // NF: 11/05/06

  public
    { Public declarations }
    ASAutoIncBy  :  Char;
    ASAutoInc    :  SmallInt;
    ASTransDate,
    ASUntilDate  :  LongDate;
    ASUPr,
    ASUYr,
    ASPr,
    ASYr         :  Byte;
    ASAutoPost,
    ASKeepDate   :  Boolean;


    Function InitAS(VO    :  Boolean;
                    Col1  :  TColor;
                    Fon1  :  TFont):  Word;

  end;

{~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~}

Implementation

{~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~}

Uses
  ComnUnit,
  ComnU2,
  BTSupU1,
  BTSupU2,
  SysU1,
  Event1U;

{$R *.DFM}



{ ==== Procedure to Display Address ==== }

Procedure TAutoTxPop.OutAS;

Begin
  ASDF.Checked:=(ASAutoIncBy=DayInc);
  ASPF.Checked:=(Not ASDF.Checked);


  ASDate1F.DateValue:=ASTransDate;
  ASDate2F.DateValue:=ASUntilDate;

  ASPeriod1F.InitPeriod(ASPr,ASYr,BOn,BOn);
  ASPeriod2F.InitPeriod(ASUPr,ASUYr,BOn,BOn);


  {ASNPerF.WiggleHeight;}

  ASNPerF.Value:=ASAutoInc;
  ASAF.Checked:=ASAutoPost;

  ASKDF.Checked:=ASKeepDate;



end;


Procedure TAutoTxPop.SetASStore(EnabFlg  :  Boolean;
                                DPMode   :  Byte);

Var
  Loop  :  Integer;

Begin

  For Loop:=0 to ComponentCount-1 do
  Begin
    If (Components[Loop] is TMaskEdit) then
    With (Components[Loop] as TMaskEdit) do
    Begin
      Font.Assign(ASDate1F.Font);
      Color:=ASDate1F.Color;

      ReadOnly:=(((EnabFlg) and (Tag>0)) or (Tag=DPMode));

      TabStop:=(Tag<>DPMode);
    end
    else
      If (Components[Loop] is TCurrencyEdit) then
      With (Components[Loop] as TCurrencyEdit) do
      Begin
        Font.Assign(ASDate1F.Font);
        Color:=ASDate1F.Color;

        ReadOnly:=(((EnabFlg) and (Tag>0)) or (Tag=DPMode));
      end
      else
        If (Components[Loop] is TBorRadio) then
        With (Components[Loop] as TBorRadio) do
        Begin
          CheckColor:=clBlack;

          Enabled:=Not EnabFlg;
        end
        else
          If (Components[Loop] is TBorCheck) then
          With (Components[Loop] as TBorCheck) do
          Begin
            CheckColor:=clBlack;

            Enabled:=Not EnabFlg;
          end;
  end;

end;

Procedure TAutoTxPop.Form2AS;

Begin
  If (ASDF.Checked) then
  Begin
    ASAutoIncBy:=DayInc;
    ASTransDate:=ASDate1F.DateValue;
    ASUntilDate:=ASDate2F.DateValue;
  end
  else
  Begin
    ASAutoIncBy:=PeriodInc;

    ASPeriod1F.InitPeriod(ASPr,ASYr,BOff,BOff);
    ASPeriod2F.InitPeriod(ASUPr,ASUYr,BOff,BOff);

    ASKeepDate:=ASKDF.Checked;

    ASTransDate:=ASDate1F.DateValue;
  end;

  ASAutoInc:=Round(ASNPerF.Value);

  ASAutoPost:=ASAF.Checked;
end;


Function TAutoTxPop.InitAS(VO    :  Boolean;
                           Col1  :  TColor;
                           Fon1  :  TFont):  Word;


Begin
  With ASDate1F do
  Begin
    Color:=Col1;
    Font.Assign(Fon1);
  end;

  ASNPerF.BlockNegative:=BOn;

  OutAS;

  SetASStore(VO,(2*Ord(ASDF.Checked))+(3*Ord(ASPF.Checked)));

  SetAllowHotKey(BOff,PrevHState);

  Result:=ShowModal;

  SetAllowHotKey(BOn,PrevHState);

  If (Result=mrOk) then
    Form2AS;

end;





procedure TAutoTxPop.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  GlobFormKeyDown(Sender,Key,Shift,ActiveControl,Handle);
end;

procedure TAutoTxPop.FormKeyPress(Sender: TObject; var Key: Char);
begin
  GlobFormKeyPress(Sender,Key,ActiveControl,Handle);
end;

procedure TAutoTxPop.ASDFClick(Sender: TObject);
begin
  SetASStore(BOff,(2*Ord(ASDF.Checked))+(3*Ord(ASPF.Checked)));

  If (ASDF.Checked) then
    ASNPerF.Value:=30
  else
    ASNPerF.Value:=1;
end;

function TAutoTxPop.ASPeriod1FConvDate(Sender: TObject;
  const IDate: string; const Date2Pr: Boolean): string;
begin
  Result:=ConvInpPr(IDate,Date2Pr,nil);
end;

function TAutoTxPop.ASPeriod1FShowPeriod(Sender: TObject;
  const EPr: Byte): string;
begin
  Result:=PPr_Pr(EPr);
end;

procedure TAutoTxPop.ASDate2FExit(Sender: TObject);
begin
  If (ASDate2F.DateValue<ASDate1F.DateValue) and (ASDate1F.DateValue<>'') then
    ASDate2F.DateValue:=ASDate1F.DateValue;
end;

procedure TAutoTxPop.ASPeriod2FExit(Sender: TObject);
begin
  If Pr2Fig(ASPeriod2F.EYear,ASPeriod2F.EPeriod)<Pr2Fig(ASPeriod1F.EYear,ASPeriod1F.EPEriod) then
  Begin
    ASPeriod2F.EYear:=ASPeriod1F.EYear;
    ASPeriod2F.EPeriod :=ASPeriod1F.EPeriod;

  end;
end;

procedure TAutoTxPop.FormCreate(Sender: TObject);
begin
  SetHelpContextIDs; // NF: 11/05/06 Fix for incorrect Context IDs
end;

// NF: 11/05/06 Fix for incorrect Context IDs
procedure TAutoTxPop.SetHelpContextIDs;
begin
  ASKDF.HelpContext := 1451;
end;


procedure TAutoTxPop.OkCP1BtnClick(Sender: TObject);
begin
  If OkCP1Btn.CanFocus Then
    OkCP1Btn.SetFocus;
end;

end.
