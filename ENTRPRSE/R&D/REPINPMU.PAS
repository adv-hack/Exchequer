unit RepInpMU;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  Repinp1u, StdCtrls, TEditVal, Mask, Animate, ExtCtrls, SBSPanel, bkgroup,
  BTSupU3, BorBtns;

type
  TRepInpMsgM = class(TRepInpMsg)
    Label81: Label8;
    ACFF: Text8Pt;
    Label810: Label8;
    AgeInt: TCurrencyEdit;
    Label82: Label8;
    SorF: Text8Pt;
    UseFreeF: TBorCheckEx;
    AccLab: Label8;
    ACCF: Text8Pt;
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure ACFFExit(Sender: TObject);
    procedure AgeIntEnter(Sender: TObject);
    procedure SorFEnter(Sender: TObject);
    procedure SorFExit(Sender: TObject);
    procedure OkCP1BtnClick(Sender: TObject);
    procedure ACCFExit(Sender: TObject);
  private
    { Private declarations }
    CRepParam  :  KitRepPtr;
    RMode      :  Byte;

  public
    { Public declarations }
  end;

Var
  RepIMode  :  Byte;


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



procedure TRepInpMsgM.FormCreate(Sender: TObject);


begin
  inherited;
  ClientHeight:=156;
  ClientWidth:=326;

  AgeInt.DecPlaces:=Syss.NoQtyDec;
  New(CRepParam);

  RMode:=RepIMode;

  If (RMode=2) then
  Begin
    Caption:='Kitting Shortages Report';
    HelpContext:=673;
    UseFreeF.Visible:=BOff;
    ACCLab.Visible:=BOn;
    ACCF.Visible:=BOn;
  end;


  try
    FillChar(CRepParam^,Sizeof(CRepParam^),0);
  except
    Dispose(CRepParam);
    CRepParam:=nil;
  end;

  SetLastValues;
end;

procedure TRepInpMsgM.FormClose(Sender: TObject; var Action: TCloseAction);

begin
  inherited;

  If (Assigned(CRepParam)) then
    Dispose(CRepParam);
end;


procedure TRepInpMsgM.ACFFExit(Sender: TObject);
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

      FoundOk:=(GetStock(Application.MainForm,FoundCode,FoundCode,2));


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

procedure TRepInpMsgM.ACCFExit(Sender: TObject);
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

      FoundOk:=(GetCust(Self,FoundCode,FoundCode,BOff,99));


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


procedure TRepInpMsgM.AgeIntEnter(Sender: TObject);
begin
  inherited;
  AgeInt.ReadOnly:=(EmptyKey(AcFF.Text,StkKeyLen));
end;

procedure TRepInpMsgM.SorFEnter(Sender: TObject);
begin
  inherited;

  SorF.ReadOnly:=(Not EmptyKey(AcFF.Text,StkKeyLen));
end;

procedure TRepInpMsgM.SorFExit(Sender: TObject);

Const
  Fnum     =   InvF;

  Keypath  =   InvOurRefK;

Var
  FoundCode  :  Str20;

  FoundOk,
  AltMod     :  Boolean;

  GenStr     :  Str255;


begin

  If (Sender is Text8pt) then
  With (Sender as Text8pt) do
  Begin
    AltMod:=Modified;

    FoundCode:=Strip('B',[#32],Text);

    If ((AltMod) and (FoundCode<>'')) and (ActiveControl<>ClsCP1Btn) then
    Begin

      StillEdit:=BOn;

      FoundCode:=AutoSetInvKey(Text,0);

      GenStr:=FoundCode;

      Status:=Find_Rec(B_GetEq,F[Fnum],Fnum,RecPtr[Fnum]^,Keypath,GenStr);

      FoundOk:=StatusOk;

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



procedure TRepInpMsgM.OkCP1BtnClick(Sender: TObject);
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
        SKitQty:=AgeInt.Value;
        ROrdNo:=SORF.Text;
        UseFree:=UseFreeF.Checked;
        CustFilt:=ACCF.Text;

        If (Not EmptyKey(STCode,StkKeyLen)) or (Not EmptyKey(ROrdNo,DocKeyLen)) then
        Begin
          If (Not EmptyKey(STCode,StkKeyLen)) then
            TB:=RMode+1
          else
            TB:=RMode;

          AddSKitRep2Thread(TB+Ord(RMode=2),CRepParam,Owner);

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


Initialization

  RepIMode:=0;

end.
