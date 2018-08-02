unit RepInp2U;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  Repinp1u, ExtCtrls, SBSPanel, StdCtrls, Mask, TEditVal,BTSupU3, bkgroup,
  Animate, BorBtns;

type
  TRepInpMsg1 = class(TRepInpMsg)
    CurrF: TSBSComboBox;
    I1TransDateF: TEditDate;
    Label81: Label8;
    Label82: Label8;
    IncSDueF: TBorCheck;
    Label84: Label8;
    AgeX: TSBSComboBox;
    Label811: Label8;
    CurrF2: TSBSComboBox;
    lblAccountTypes: Label8;
    cbAccountTypes: TSBSComboBox;
    chkDueSummary: TBorCheck;
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure OkCP1BtnClick(Sender: TObject);
    procedure FormKeyPress(Sender: TObject; var Key: Char);
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    
  private
    CRepParam  :  DueRepPtr;
    IsCust     :  Boolean;
    procedure SetHelpContextIDs; // NF: 10/05/06
  public
    { Public declarations }
  end;


procedure Payment_Report(IsCust  :  Boolean;
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

  ReportU,

  BTSupU2;

{$R *.DFM}

Var
  GIsCust  :  Boolean;

procedure TRepInpMsg1.FormCreate(Sender: TObject);
begin
  inherited;
  ClientHeight:=200;    // SSK 04/04/2017 2017-R1 ABSEXCH-18439: clientHeight increased
  ClientWidth:=308;


  {$IFDEF MC_On}

    Set_DefaultCurr(CurrF.Items,BOn,BOff);
    Set_DefaultCurr(CurrF.ItemsL,BOn,BOn);
    CurrF.ItemIndex:=0;

    Set_DefaultCurr(CurrF2.Items,BOn,BOff);
    Set_DefaultCurr(CurrF2.ItemsL,BOn,BOn);
    CurrF2.ItemIndex:=0;

  {$ELSE}
    Label81.Visible:=BOff;
    CurrF.Visible:=BOff;
    CurrF2.Visible:=BOff;
    Label811.Visible:=BOff;


  {$ENDIF}

  AgeX.ItemIndex:=0;

  I1TransDateF.DateValue:=Today;

  New(CRepParam);

  try
    FillChar(CRepParam^,Sizeof(CRepParam^),0);
  except
    Dispose(CRepParam);
    CRepParam:=nil;
  end;

  IsCust:=GIsCust;

  If (IsCust) then
    Caption:='Receipts '+Caption
  else
    Caption:='Payments '+Caption;

  // MH 02/10/2013 MRD1.2.27/28: Added drop-down list to filter account types
  lblAccountTypes.Visible := IsCust And Syss.ssConsumersEnabled;
  cbAccountTypes.Visible := lblAccountTypes.Visible;

  SetHelpContextIDs; // NF: 10/05/06 Fix for incorrect Context IDs

end;


procedure TRepInpMsg1.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  inherited;

  If (Assigned(CRepParam)) then
    Dispose(CRepParam);

end;

procedure TRepInpMsg1.OkCP1BtnClick(Sender: TObject);
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
          RTxCr:=CurrF2.ItemIndex;
        {$ENDIF}

        DueLimit:=I1TransDateF.DateValue;

        IncSDisc:=IncSDueF.Checked;

        Summary := chkDueSummary.Checked;        // SSK 04/04/2017 2017-R1 ABSEXCH-18439: option added for Summary Report

        If (AgeX.ItemIndex>=0) then
          RAgeBy:=AgeX.ItemIndex;

        If cbAccountTypes.Visible Then
        Begin
          // MH 04/10/2013 MRD1.1.29: Added report filter on account types
          Case cbAccountTypes.ItemIndex Of
            // Customers & Consumers
            0 : IncludeAccountTypes := atCustomersAndConsumers;
            // Customers Only
            1 : IncludeAccountTypes := atCustomersOnly;
            // Consumers Only
            2 : IncludeAccountTypes := atConsumersOnly;
          End; // Case cbAccountTypes.ItemIndex
        End; // If cbAccountTypes.Visible

        AddADebRep2Thread(0,IsCust,CRepParam,Owner);
      end;

      inherited;
    End // If AutoExitValidation
    Else
      ModalResult := mrNone;
  End // If (Sender=OkCP1Btn)
  Else
    inherited;
end;




procedure Payment_Report(IsCust  :  Boolean;
                         AOwner  :  TComponent);

Var
  RepInpMsg1  :  TRepInpMsg1;

Begin
  GIsCust:=IsCust;

  RepInpMsg1:=TRepInpMsg1.Create(AOwner);



end;



procedure TRepInpMsg1.FormKeyPress(Sender: TObject; var Key: Char);
begin
  {***}
  Inherited;
end;

procedure TRepInpMsg1.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  {***}
  Inherited;
end;

// NF: 10/05/06 Fix for incorrect Context IDs
procedure TRepInpMsg1.SetHelpContextIDs;
begin
  AgeX.HelpContext := 1752;
end;

Initialization

  GIsCust:=BOff;

Finalization

end.
