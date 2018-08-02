unit RepInpNU;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  Repinp1u, Animate, ExtCtrls, SBSPanel, StdCtrls, bkgroup, BTSupU3,
  TEditVal, BorBtns, Mask;

type
  TRepInpMsgN = class(TRepInpMsg)
    Label81: Label8;
    ACFF: Text8Pt;
    Label89: Label8;
    AccF3: Text8Pt;
    Sum1: TBorCheck;
    Label86: Label8;
    I1TransDateF: TEditDate;
    Label82: Label8;
    CurrF: TSBSComboBox;
    LocLab: Label8;
    LocF: Text8Pt;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormCreate(Sender: TObject);
    procedure ACFFExit(Sender: TObject);
    procedure AccF3Exit(Sender: TObject);
    procedure OkCP1BtnClick(Sender: TObject);
    procedure LocFExit(Sender: TObject);
  private
    CRepParam  :  KitRepPtr;

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
  BtrvU2,
  BTKeys1U,
  InvListU,
  ReportFU,

  SysU1,
  SysU2,
  BTSupU2;

{$R *.DFM}



procedure TRepInpMsgN.FormCreate(Sender: TObject);

Var
  HideLoc  :  Boolean;

begin
  inherited;
  ClientHeight:=194;
  ClientWidth:=299;

  New(CRepParam);

  I1TransDateF.DateValue:=MaxUntilDate;

  {$IFNDEF PF_On}
    Sum1.Visible:=BOff;
  {$ELSE}
    Sum1.Checked:=BOn;
  {$ENDIF}

  {$IFDEF MC_On}

    Set_DefaultCurr(CurrF.Items,BOn,BOff);
    Set_DefaultCurr(CurrF.ItemsL,BOn,BOn);
    CurrF.ItemIndex:=0;

  {$ELSE}
    Label82.Visible:=BOff;
    CurrF.Visible:=BOff;

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
  end;


  try
    FillChar(CRepParam^,Sizeof(CRepParam^),0);
  except
    Dispose(CRepParam);
    CRepParam:=nil;
  end;

  SetLastValues;
end;

procedure TRepInpMsgN.FormClose(Sender: TObject; var Action: TCloseAction);

begin
  inherited;

  If (Assigned(CRepParam)) then
    Dispose(CRepParam);
end;


procedure TRepInpMsgN.ACFFExit(Sender: TObject);
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

      FoundOk:=(GetStock(Application.MainForm,FoundCode,FoundCode,99));


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



procedure TRepInpMsgN.AccF3Exit(Sender: TObject);
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

      FoundOk:=(GetCust(Application.MainForm,FoundCode,FoundCode,BOn,0));


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


procedure TRepInpMsgN.LocFExit(Sender: TObject);
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


procedure TRepInpMsgN.OkCP1BtnClick(Sender: TObject);
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
        STCode:=AcFF.Text;
        CustFilt:=AccF3.Text;
        EDate:=I1TransDateF.DateValue;
        ExpBOM:=Sum1.Checked;
        LocFilt:=LocF.Text;

        {$IFDEF MC_On}
          RCr:=CurrF.ItemIndex;
        {$ENDIF}

        AddSKitRep2Thread(5,CRepParam,Owner);
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
