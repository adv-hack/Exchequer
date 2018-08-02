unit RepInpWU;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  Repinp1u, StdCtrls, ExtCtrls, bkgroup, BTSupU3, Mask, TEditVal, BorBtns,
  Animate, SBSPanel, VarRec2U;

type
  TRepInpMsgW = class(TRepInpMsg)
    Label85: Label8;
    Label81: Label8;
    Label82: Label8;
    I1PrYrF: TEditPeriod;
    Sum1: TBorCheck;
    Id3VATF: TSBSComboBox;
    Label83: Label8;
    Id4VATF: TSBSComboBox;
    Label84: Label8;
    procedure FormCreate(Sender: TObject);
    procedure OkCP1BtnClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure I1PrYrFExit(Sender: TObject);
  private
    { Private declarations }
    RepMode    :  Byte;
    CRepParam  :  VATRepPtr;
    CRepParam2 :  ISVATRepPtr;
    IRVInp     :  IRVInpType;
    CompPr     :  String;



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

  InvListU,

  ReportKU,

  {$IFDEF PF_On}
    {$IFDEF STK}
       RepBSupU,
    {$ENDIF}
  {$ENDIF}

  RepInpVU,
  PWarnU,
  GenWarnU,
  SysU1,
  SysU2,
  BTSupU1,
  BTSupU2;

{$R *.DFM}





procedure TRepInpMsgW.FormCreate(Sender: TObject);


Var
  VSYr,VSPr
     :  Word;

  CVYr,CVPr,
  NYear,
  n  :  Integer;

begin
  inherited;

  ClientHeight:=197;
  ClientWidth:=299;

  RepMode:=0;

  New(Self.CRepParam);
  New(Self.CRepParam2);

  Blank(IRVInp,Sizeof(IRVInp));

  try
    With Self.CRepParam^ do
    Begin
      FillChar(Self.CRepParam^,Sizeof(Self.CRepParam^),0);
      VATEndD:=SyssVat.VATRates.CurrPeriod;

      NYear:=Part_Date('Y',VATEndd);

      VPr:=Part_Date('M',VATEndd);

      CVYr:=NYear; CVPr:=VPr;

      VYr:=TxlateYrVal(NYear,BOn);

      I1PrYrF.InitPeriod(VPr,VYr,BOn,BOn);

      I1PrYrF.PeriodsInYear:=12;

      CompPr:=I1PrYrF.Text;
    end;
  except
    Dispose(Self.CRepParam);
    Self.CRepParam:=nil;
  end;

  try
    With Self.CRepParam2^ do
    Begin
      FillChar(Self.CRepParam2^,Sizeof(Self.CRepParam2^),0);

    end;
  except
    Dispose(Self.CRepParam2);
    Self.CRepParam2:=nil;
  end;


  Sum1.Visible:=BoChkAllowed_In((RepMode=0),50);

  If (RepMode=0) then
    Caption:=CCVATName^+' '+Caption;

  Set_DefaultVAT(Id3VATF.Items,BOff,BOff);
  Set_DefaultVAT(Id4VATF.Items,BOff,BOff);

  Id3VATF.ItemIndex:=2;
  Id4VATF.ItemIndex:=1;


  If (Get_LastIRVVal(FullIRVFile(AllocTCode,AllocSCode,3),IRVInp)) then
  Begin
    If (IRVInp.T11Codes[1] In VATSet) then
      Id3VATF.ItemIndex:=GetVATIndex(IRVInp.T11Codes[1]);

    If (IRVInp.T21Codes[1] In VATSet) then
      Id4VATF.ItemIndex:=GetVATIndex(IRVInp.T21Codes[1]);

  end;

  SetLastValues;

  If (RepMode=0) and (Sum1.Checked) then
  With CRepParam^ do
  Begin
    I1PrYrF.InitPeriod(VPr,VYr,BOn,BOn);

    I1PrYrF.PeriodsInYear:=12;

    Sum1.Checked:=BOff;
  end;

end;


procedure TRepInpMsgW.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  inherited;

  If (Assigned(CRepParam)) then
    Dispose(CRepParam);

  If (Assigned(CRepParam2)) then
    Dispose(CRepParam2);

end;


procedure TRepInpMsgW.I1PrYrFExit(Sender: TObject);
begin
  inherited;

  If (RepMode=0) and (Sum1.Visible) then
  Begin
    With CRepParam^ do
      Sum1.Enabled:=(CompPr=I1PrYrF.Text);

    If (Sum1.Checked) and (Not Sum1.Enabled) then
      Sum1.Checked:=BOff;
  end;

end;


procedure TRepInpMsgW.OkCP1BtnClick(Sender: TObject);

Var
  VSYr,VSPr,
  AVPr
     :  Word;

  CVYr,CVPr,
  NYear,
  n  :  Integer;

begin
  If (Sender=OkCP1Btn) then
  Begin
    If AutoExitValidation Then
    Begin
      With Self.CRepParam^ do
      Begin
        I1PrYrFExit(Nil);

        If (Sum1.Checked) then {Warn about implications of closing the VAT period}
        Begin
          Sum1.Checked:=(CustomDlg(Application.MainForm,'Please Note!','The '+CCVATName^+' period is about to be closed',
                                   'Closing the '+CCVATName^+' period will prevent you from posting any future transactions to this '+
                                   CCVATName^+' period again.'+#13+
                                   'You should only close the current '+CCVATName^+' period once you have confirmed the report is '+
                                   'correct.'+#13+
                                   'You can also close the period via the '+CCVATName^+' setup screen (F5).'+#13+
                                   'Please confirm you wish to close the current '+CCVATName^+' period.',
                                   mtWarning,
                                   [mbYes,mbNo])=mrOK);



        end;


        OKCP1Btn.Enabled:=BOff;

        I1PrYrF.InitPeriod(VPr,VYr,BOff,BOff);

        NYear:=ConvTxYrVal(VYr,BOff);

        VSYr:=NYear; VSPr:=VPr;

        VISYr:=VYr; VISPr:=VPr;


        If (VPr=2) then {* Compensate for period 2 *}
          AVPr:=Pred(Monthdays[VPr])
        else
          AVPr:=Monthdays[VPr];

        VATEndD:=StrDate(NYear,VPr,AVPr);

        VATStartD:=VATEndD;

        AutoCloseVAT:=Sum1.Checked;

        With Id3VATF do
          If (ItemIndex>=0) then
          VATCode1:=Items[ItemIndex][1];

        With Id4VATF do
          If (ItemIndex>=0) then
          VATCode2:=Items[ItemIndex][1];


        With IRVatInp do
        Begin
          IRVInp.T11Codes:=VATCode1;
          IRVInp.T21Codes:=VATCode2;

          Put_LastIRVVal(AllocSCode,IRVInp,3);

        end;



        Case RepMode of
          0  :  AddVATRRep22Thread(0,CRepParam,Owner);

          {$IFDEF PF_On}
            {$IFDEF STK}
               else  AddISVATRep3Thread(RepMode,CRepParam2,Owner);
            {$ENDIF}
          {$ENDIF}

        end; {Case..}

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
