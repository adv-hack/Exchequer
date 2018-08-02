unit RepInpTU;

{$I DEFOVR.Inc}

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  Repinp1u, StdCtrls, ExtCtrls, BTSupU3, bkgroup, BorBtns, TEditVal, Mask,
  Animate, SBSPanel;

type
  TRepInpMsgT = class(TRepInpMsg)
    Label81: Label8;
    BR1: TBorRadio;
    BR2: TBorRadio;
    LabQtyF: TCurrencyEdit;
    BR3: TBorRadio;
    BR4: TBorCheck;
    BCSNo1: TBorCheck;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormCreate(Sender: TObject);
    procedure OkCP1BtnClick(Sender: TObject);
    procedure BR2Click(Sender: TObject);
  private
    { Private declarations }
    RepMode    :  Byte;
    ViaOrder   :  Boolean;
    FAccountCode : ShortString;

    CRepParam  :  CustRepPtr;
  public
    { Public declarations }
    Constructor Create(AOwner: TComponent; Const AccountCode : ShortString); Reintroduce;
  end;

Var
  SLRNo  :  Byte;

procedure StkTransLab_Report(AOwner  :  TComponent;
                             InvFolio,
                             InvLNo  :  LongInt;
                             SLMode  :  Byte;
                             ViaOrder:  Boolean;
                             AccountCode : ShortString);

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
  ReportU,
  SysU1,
  SysU2,

  BTSupU2;


{$R *.DFM}

Var
  SLInvFolio,
  SLInvLNo     :  LongInt;
  SLViaOrder   :  Boolean;

//=========================================================================

// MH 07/02/2012 v6.10 ABSEXCH-10984: Added Constructor with Account Code parameter so it can
// be safely passed through to the report so that the correct form definition set can be used
Constructor TRepInpMsgT.Create(AOwner: TComponent; Const AccountCode : ShortString);
Begin // Create
  Inherited Create (AOwner);

  FAccountCode := AccountCode;
End; // Create

//-------------------------------------------------------------------------

procedure TRepInpMsgT.FormCreate(Sender: TObject);


begin
  inherited;

  ClientHeight:=186;
  ClientWidth:=299;

  RepMode:=SLRNo;

  ViaOrder:=SLViaOrder;

  New(CRepParam);

  BR3.Visible:=SLViaOrder;

  BR4.Visible:=(RepMode In [12,14]);

  {$IFDEF SOP}
    BCSNo1.Visible:=BR4.Visible;

  {$ELSE}
    BCSNo1.Visible:=BOff;

  {$ENDIF}

  If (ViaOrder) then
    BR3.Checked:=BOn;

  try
    FillChar(CRepParam^,Sizeof(CRepParam^),0);

    CRepParam^.StkLabFolio:=SLInvFolio;
    CRepParam^.StkLabLineNo:=SLInvLNo;

  except
    Dispose(CRepParam);
    CRepParam:=nil;
  end;


  SetLastValues;
end;

procedure TRepInpMsgT.FormClose(Sender: TObject; var Action: TCloseAction);

begin
  inherited;

  If (Assigned(CRepParam)) then
    Dispose(CRepParam);
end;



procedure TRepInpMsgT.BR2Click(Sender: TObject);
begin
  inherited;

  LabQtyF.Enabled:=BR2.Checked;
  BCSNo1.Enabled:=BR2.Checked;

  If (Not BCSNo1.Enabled) then
  Begin
    BCSNo1.Checked:=BOff;
    LabQtyF.Value:=1.0;
  end;

end;




procedure TRepInpMsgT.OkCP1BtnClick(Sender: TObject);


begin
  If (Sender=OkCP1Btn) then
  Begin
    If AutoExitValidation Then
    Begin
      With CRepParam^ do
      Begin
        OKCP1Btn.Enabled:=BOff;

        If (Br2.Checked) then
          StkLabQtyMode:=2
        else
          If (Br3.Checked) then
            StkLabQtyMode:=3
          else
            StkLabQtyMode:=1;

        StkLabXComp:=BR4.Checked;

        {$IFDEF SOP}
          If BCSNo1.Checked then
            RepMode:=14;
        {$ENDIF}

        StkLabCopies:=Round(LabQtyF.Value);

        // MH 07/02/2012 v6.10 ABSEXCH-10984: Added Account Code so correct form definition set can be used in report
        AccTFilt := FAccountCode;

        AddStaRep2Thread(RepMode,CRepParam,Owner);
      end;

      inherited;
    End // If AutoExitValidation
    Else
      ModalResult := mrNone;
  End // If (Sender=OkCP1Btn)
  Else
    inherited;
end;


// MH 07/02/2012 v6.10 ABSEXCH-10984: Added Account Code parameter so correct form definition set can be used
procedure StkTransLab_Report(AOwner  :  TComponent;
                             InvFolio,
                             InvLNo  :  LongInt;
                             SLMode  :  Byte;
                             ViaOrder:  Boolean;
                             AccountCode : ShortString);

  Var
    RepInpMsg1  :  TRepInpMsgT;

  Begin
    SLRNo:=SLMode;
    SLInvFolio:=InvFolio;
    SLInvLNo:=InvLNo;
    SLViaOrder:=ViaOrder;

    RepInpMsg1:=TRepInpMsgT.Create(AOwner, AccountCode);

  end;


Initialization

  SLInvFolio:=0;
  SLViaOrder:=BOff;
  SLInvLNo:=0;
  SLRNo:=0;

end.
