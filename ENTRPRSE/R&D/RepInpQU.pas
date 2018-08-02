unit RepInpQU;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  Repinp1u, Animate, ExtCtrls, SBSPanel, BTSupU3, StdCtrls, bkgroup,
  BorBtns, TEditVal, VarConst;

type
  TRepInpMsgQ = class(TRepInpMsg)
    Label85: Label8;
    AgeInt: TCurrencyEdit;
    Label88: Label8;
    Back1: TBorCheck;
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure OkCP1BtnClick(Sender: TObject);
    procedure AgeIntKeyPress(Sender: TObject; var Key: Char);
  private
    { Private declarations }
    CRepParam  :  BatchPRepPtr;
    BatchCtrl  :  PassWordRec;
    BSPMode    :  Boolean;

  public
    { Public declarations }
  end;

procedure Batch_Report(SPMode  :  Boolean;
                       AOwner  :  TComponent);

{~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~}

Implementation

{~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~}

Uses
  ETStrU,
  ETDateU,
  ETMiscU,
  GlobVar,
  BPyItemU,
  ReportIU,

  SysU1,
  SysU2,
  BTSupU2;

{$R *.DFM}



Var
  RSPMode  :  Boolean;


procedure TRepInpMsgQ.FormCreate(Sender: TObject);

begin
  inherited;
  ClientHeight:=144;
  ClientWidth:=299;

  New(CRepParam);

  BSPMode:=RSPMode;

  AgeInt.BlockNegative:=BOn;
  If (BSPMode) then
    Caption:='Batch Receipts Report';


  try
    FillChar(CRepParam^,Sizeof(CRepParam^),0);
  except
    Dispose(CRepParam);
    CRepParam:=nil;
  end;

  
  BACS_CtrlGet(PWrdF,PWK,BatchCtrl,BSPMode,Nil);

  AgeInt.Value:=BatchCtrl.BACSCRec.TagRunNo;

  SetLastValues;
end;

procedure TRepInpMsgQ.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  inherited;

  If (Assigned(CRepParam)) then
    Dispose(CRepParam);

end;


procedure TRepInpMsgQ.OkCP1BtnClick(Sender: TObject);
begin
  If (Sender=OkCP1Btn) then
  Begin
    If AutoExitValidation Then
    Begin
      With CRepParam^, BatchCtrl.BACSCRec do
      Begin
        OKCP1Btn.Enabled:=BOff;

        NomToo:=Round(Self.AgeInt.Value);

        {$IFDEF MC_On}
          If (TagRunNo=NomToo) then
            RCr:=PayCurr;
        {$ENDIF}

        Summary:=Back1.Checked;

        SPMode:=BSPMode;

        AddBatchPRep2Thread(7,CRepParam,Owner);
      end;

      inherited;
    End // If AutoExitValidation
    Else
      ModalResult := mrNone;
  End // If (Sender=OkCP1Btn)
  Else
    inherited;
end;


procedure Batch_Report(SPMode  :  Boolean;
                       AOwner  :  TComponent);
Var
  RepInpMsg1  :  TRepInpMsgQ;

Begin
  RSPMode:=SPMode;

  RepInpMsg1:=TRepInpMsgQ.Create(AOwner);

end;


procedure TRepInpMsgQ.AgeIntKeyPress(Sender: TObject; var Key: Char);
begin
  If (Key = '-') Then
    Key := #0;
end;

Initialization

  RSPMode:=BOff;

end.
