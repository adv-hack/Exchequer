unit RepInpKU;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  Repinp1u, StdCtrls, ExtCtrls, BTSupU3, bkgroup, BorBtns, TEditVal, Mask,
  Animate, SBSPanel;

type
  TRepInpMsgK = class(TRepInpMsg)
    Label81: Label8;
    Label83: Label8;
    ACFF: Text8Pt;
    SxSF: TSBSComboBox;
    Sum1: TBorCheck;
    SLive: TBorCheck;
    LocLab: Label8;
    LocF: Text8Pt;
    I1TransDateF: TEditDate;
    Label86: Label8;
    chkPrintParameters: TBorCheck;
    procedure ACFFExit(Sender: TObject);
    procedure OkCP1BtnClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormCreate(Sender: TObject);
    procedure LocFExit(Sender: TObject);
  private
    { Private declarations }  private
    { Private declarations }
    RepMode    :  Byte;

    CRepParam  :  SListRepPtr;

  public
    { Public declarations }
  end;

Var
  SVRNo  :  Byte;

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
  ReportDU,
  SysU1,
  SysU2,
  BTSupU2;


{$R *.DFM}



procedure TRepInpMsgK.FormCreate(Sender: TObject);

Var
  HideLoc  :  Boolean;

begin
  inherited;

  ClientHeight:=200;
  ClientWidth:=299;

  RepMode:=SVRNo;

  Set_DefaultVal(SxSF.Items,BOff,BOff,BOff);
  Set_DefaultVal(SxSF.ItemsL,BOff,BOff,BOff);

  SxSF.Items.Insert(0,'All');
  SxSF.ItemsL.Insert(0,'All');

  SxSF.ItemIndex:=0;

  {$IFNDEF SOP}

    HideLoc:=BOn;

  {$ELSE}

    HideLoc:=(Not Syss.UseMLoc);

  {$ENDIF}

  {$IFDEF LTE}
    SLive.Visible:=BOff;
  {$ENDIF}


  If (HideLoc) then
  Begin
    LocF.Visible:=BOff;
    LocLab.Visible:=BOff;
  end;

  If (RepMode=44) then
  Begin
    Sum1.Visible:=BOff;
    Label83.Visible:=BOff;
    SxSF.Visible:=BOff;
    Label86.Visible:=BOn;
    Label86.BringToFront;
    I1TransDateF.Visible:=BOn;
    I1TransDateF.DateValue:=Today;

    Caption:='Stock Aging Report';
  end
  { PL 18/04/2017 2017-R1 ABSEXCH-18497 : added this to execute valuation
        report as Live and Posted, case-4 is used for Valuation Live report
        and case-5 is used for Valuation Posted report}
  else if (RepMode=4) then
  begin
    SLive.Checked := BOn;
    Slive.Visible := BOff;
    Caption :='Valuation Report - Live';
  end
  else if (RepMode=5) then
  Begin
    SLive.Checked := BOff;
    Slive.Visible := BOff;
    Caption :='Valuation Report - Posted';
  end;




  New(CRepParam);

  try
    FillChar(CRepParam^,Sizeof(CRepParam^),0);
  except
    Dispose(CRepParam);
    CRepParam:=nil;
  end;


  SetLastValues;
end;

procedure TRepInpMsgK.FormClose(Sender: TObject; var Action: TCloseAction);

begin
  inherited;

  If (Assigned(CRepParam)) then
    Dispose(CRepParam);
end;


procedure TRepInpMsgK.ACFFExit(Sender: TObject);
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

      FoundOk:=(GetStock(Self,FoundCode,FoundCode,1));


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



procedure TRepInpMsgK.LocFExit(Sender: TObject);
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


procedure TRepInpMsgK.OkCP1BtnClick(Sender: TObject);

begin
  If (Sender=OkCP1Btn) then
  Begin
    If AutoExitValidation Then
    Begin
      With CRepParam^ do
      Begin
        OKCP1Btn.Enabled:=BOff;

        StkToo:=FullStockCode(ACFF.Text);

        If (RepMode<>44) then
          ShowQty:=Sum1.Checked
        else
          ShowQty:=BOff;

        //AP 02/02/2018 ABSEXCH-19628:Stock Valuation reports showing incorrect results
        If (RepMode=4) then
          ShowLive:=BOn
        else
          ShowLive:=BOff;
          
        LocFilt:=LocF.Text;
        StkAgeDate:=I1TransDateF.DateValue;

        If (SxSF.ItemIndex>0) and (RepMode<>44) then
          RepValType:=StkI2VM(Pred(SxSF.ItemIndex))
        else
          RepValType:='';

        //PR: 21/10/2009
        PrintParameters := chkPrintParameters.Checked;

        AddSListRep2Thread(RepMode,CRepParam,Owner);
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
