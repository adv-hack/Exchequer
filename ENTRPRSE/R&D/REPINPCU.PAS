unit RepInpCU;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  Repinp1u, StdCtrls, bkgroup, TEditVal, BorBtns, Mask, BTSupU3, ExtCtrls,
  Animate, SBSPanel;
                  
type
  TRepInpMsgC = class(TRepInpMsg)
    Label81: Label8;
    Label83: Label8;
    Label84: Label8;
    PrLab: Label8;
    LocLab: Label8;
    Label88: Label8;
    Label810: Label8;
    Label811: Label8;
    ACFF: Text8Pt;
    ACCF2: Text8Pt;
    CurrF: TSBSComboBox;
    CurrF2: TSBSComboBox;
    I1PrYrF: TEditPeriod;
    I2PrYrF: TEditPeriod;
    Id3CCF: Text8Pt;
    Id3DepF: Text8Pt;
    Sum1: TBorCheck;
    AgeInt: TCurrencyEdit;
    Label89: Label8;
    AccF3: Text8Pt;
    LocF: Text8Pt;
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure ACFFExit(Sender: TObject);
    procedure Id3CCFExit(Sender: TObject);
    procedure OkCP1BtnClick(Sender: TObject);
    procedure AccF3Exit(Sender: TObject);
    procedure LocFExit(Sender: TObject);
    procedure I1PrYrFExit(Sender: TObject);
    function I1PrYrFConvDate(Sender: TObject; const IDate: String;
      const Date2Pr: Boolean): String;
    function I1PrYrFShowPeriod(Sender: TObject; const EPr: Byte): String;
    procedure AgeIntKeyPress(Sender: TObject; var Key: Char);
  private
    { Private declarations }

    RepMode    :  Byte;
    CRepParam  :  StkRepRecPtr;


  public
    { Public declarations }
  end;

Var
  SGRNo  :  Byte;

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
  Report6U,
  Report7U,

  SysU1,
  SysU2,
  BTSupU2;


{$R *.DFM}



procedure TRepInpMsgC.FormCreate(Sender: TObject);


Var
  HideLoc,
  HideCC  :  Boolean;
  TB,LYr  :  Byte;

begin
  inherited;

  ClientHeight:=222;
  ClientWidth:=424;

  RepMode:=SGRNo;

  {$IFDEF MC_On}

    Set_DefaultCurr(CurrF.Items,BOn,BOff);
    Set_DefaultCurr(CurrF.ItemsL,BOn,BOn);
    CurrF.ItemIndex:=0;

    Set_DefaultCurr(CurrF2.Items,BOn,BOff);
    Set_DefaultCurr(CurrF2.ItemsL,BOn,BOn);
    CurrF2.ItemIndex:=0;

  {$ELSE}
    Label84.Visible:=BOff;
    CurrF.Visible:=BOff;
    Label811.Visible:=BOff;
    CurrF2.Visible:=BOff;

  {$ENDIF}

    HideCC:=BOff;


  {$IFNDEF PF_On}

    HideCC:=BOn;

  {$ELSE}

    HideCC:=(Not Syss.UseCCDep or (Repmode=1));

  {$ENDIF}


  {$IFNDEF SOP}

    HideLoc:=BOn;

  {$ELSE}

    HideLoc:=(Not Syss.UseMLoc);

  {$ENDIF}


  If (HideLoc) then
  Begin
    LocF.Visible:=BOff;
    LocLab.Visible:=BOff;
  end
  else
    If (HideCC) then
    Begin
      LocLab.Left:=(PrLab.Left+prLab.Width)-LocLab.Width;
      LocF.Left:=Id3CCF.Left;
    end;


  Id3CCF.Visible:=Not HideCC;
  Id3DepF.Visible:=Not HideCC;
  Label88.Visible:=Not HideCC;

  New(CRepParam);

  try
    FillChar(CRepParam^,Sizeof(CRepParam^),0);
  except
    Dispose(CRepParam);
    CRepParam:=nil;
  end;

  
  AgeInt.Value:=0;

  TB:=1;

  LYr:=GetLocalPr(0).CYr;

  I1PrYrF.InitPeriod(TB,LYr,BOn,BOn);

  TB:=12;
  I2PrYrF.InitPeriod(TB,LYr,BOn,BOn);

  HelpContext:=659+RepMode;
  
  If (RepMode=1) then
  Begin
    Label89.Visible:=BOff;
    AccF3.Visible:=BOff;
  end
  else
    Caption:='Cost Centre/Department '+Caption;

  SetLastValues;
end;

procedure TRepInpMsgC.FormClose(Sender: TObject; var Action: TCloseAction);

begin
  inherited;                                                                      

  If (Assigned(CRepParam)) then
    Dispose(CRepParam);
end;



procedure TRepInpMsgC.ACFFExit(Sender: TObject);
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


        FoundOk:=(ACFF.Text<>ACCF2.Text);

        If (Not FoundOk) then
        Begin
          ShowMessage('The "from" and "to" stock codes cannot be the same.'+#13+'If you wish to report on a single code, specify'+#13+
                      'the next stock code on from the one you want to report as the "to" code.');
          Text:='';

        end;

      end;

      If (Not FoundOk) then
      Begin

        SetFocus;
      end; {If not found..}
    end;


  end; {with..}
end;

procedure TRepInpMsgC.Id3CCFExit(Sender: TObject);
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

procedure TRepInpMsgC.OkCP1BtnClick(Sender: TObject);

Var
  TB  :  Byte;

Begin
  If (Sender=OkCP1Btn) then
  Begin
    If AutoExitValidation Then
    Begin
      With CRepParam^ do
      Begin
        OKCP1Btn.Enabled:=BOff;

        {$IFDEF MC_On}
          FCr:=CurrF.ItemIndex;
          FTxCr:=CurrF2.ItemIndex;
        {$ENDIF}


        NCCDep[BOff]:=Id3DepF.Text;
        NCCDep[BOn]:=Id3CCF.Text;

        LocFilt:=LocF.Text;

        If (RepMode=1) then
        Begin
          If (I2PrYrF.EYear<>I1PrYrF.EYear) then
            I2PrYrF.EYear:=I1PrYrF.EYear;

          If (I2PrYrF.EPeriod<I1PrYrF.EPeriod) then
            I2PrYrF.EPeriod:=Syss.PrInYr;

        end;


        I1PrYrF.InitPeriod(PrS,RYr,BOff,BOff);
        I2PrYrF.InitPeriod(PrE,TB,BOff,BOff);

        CustFilt:=AccF3.Text;

        PaLS:=FullStockCode(ACFF.Text);
        PaLE:=FullStockCode(ACCF2.Text);

        RepLimit:=Round(AgeInt.Value);

        ShowBudg:=Sum1.Checked;

        Case RepMode of
          1  :  AddStkRep2Thread(1,CRepParam,Owner);
          2  :  AddCCStkRep2Thread(1,CRepParam,Owner);
        end;
      end;

      inherited;
    End // If AutoExitValidation
    Else
      ModalResult := mrNone;
  End // If (Sender=OkCP1Btn)
  Else
    inherited;
end;


procedure TRepInpMsgC.AccF3Exit(Sender: TObject);
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

procedure TRepInpMsgC.I1PrYrFExit(Sender: TObject);
begin
  {inherited;}

end;

function TRepInpMsgC.I1PrYrFConvDate(Sender: TObject; const IDate: String;
  const Date2Pr: Boolean): String;
begin
  inherited;
  Result:=RepInpConvInpPr(IDate,Date2Pr);
end;

function TRepInpMsgC.I1PrYrFShowPeriod(Sender: TObject;
  const EPr: Byte): String;
begin
  inherited;
  Result:=RepInpPPr_Pr(EPr);
end;
procedure TRepInpMsgC.LocFExit(Sender: TObject);
Var
  FoundCode  :  Str10;

  FoundOk,
  AltMod     :  Boolean;


begin
  {$IFDEF SOP}
    If (Sender is Text8pt) then
    With (Sender as Text8pt) do
    Begin
      AltMod:=Modified;

      FoundCode:=Strip('B',[#32],Text);

      If ((AltMod) and (FoundCode<>'')) and (ActiveControl<>ClsCP1Btn) then
      Begin

        StillEdit:=BOn;

        FoundOk:=(GetMLoc(Self,FoundCode,FoundCode,'',0));


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

procedure TRepInpMsgC.AgeIntKeyPress(Sender: TObject; var Key: Char);
begin
  If (Key = '-') Then
    Key := #0;
end;

Initialization

  SGRNo:=0;

end.
