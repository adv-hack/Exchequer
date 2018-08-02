unit RepICI1U;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  Repinp1u, StdCtrls, ExtCtrls, BTSupU3, bkgroup, BorBtns, TEditVal, Mask,
  Animate, SBSPanel;

type
  TRepJCCISEInp = class(TRepInpMsg)
    Label83: Label8;
    SxSF: TSBSComboBox;
    Label81: Label8;
    SortXCB: TSBSComboBox;
    Label85: Label8;
    AgeInt: TCurrencyEdit;
    Label82: Label8;
    Label86: Label8;
    I1TransDateF: TEditDate;
    Label87: Label8;
    I2TransDateF: TEditDate;
    procedure OkCP1BtnClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormCreate(Sender: TObject);
    procedure SxSFChange(Sender: TObject);
    procedure AgeIntKeyPress(Sender: TObject; var Key: Char);
  private
    { Private declarations }  private
    { Private declarations }
    RepMode    :  Byte;

    CRepParam  :  JobCRep1Ptr;

  public
    { Public declarations }
  end;


procedure SubCEmplList_Report(IDMode  :  Byte;
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
  VarJCstU,
  BTKeys1U,
  RepJCE2U,
  JobSup1U,
  JChkUseU,
  SysU1,
  SysU2,
  BTSupU2;


{$R *.DFM}


Var
  JCRNo   :  Byte;
  SetLV   :  Boolean;


procedure TRepJCCISEInp.FormCreate(Sender: TObject);

Var
  n           :  Integer;
  SDate,EDate :  LongDate;

begin
  inherited;

  ClientHeight:=175;
  ClientWidth:=343;


  RepMode:=JCRNo;

  Case RepMode of
    1  :  Begin
            Label83.Caption:=CCCISName^+Label83.Caption;

            If (CurrentCountry=IECCode) then
            Begin
              With SxSF do
              Begin
                With Items do
                Begin
                  Clear;

                  Add('All');
                  Add(TxLate_CISTypeStr(1));
                  Add(TxLate_CISTypeStr(2));
                  Add('Non RCT');
                  Add('Expired');
                end;

                ExtendedList:=BOn; MaxListWidth:=150;

                With ItemsL do
                Begin
                  Clear;

                  Add('All');
                  Add('No C2 or No RCT47. (Taxed)');
                  Add('C2 & RCT47. (Gross)');
                  Add('Non RCT');
                  Add('Expired');
                end;

              end; {With..}
            end; {If..}
          end;

    3  :  Begin
            Label83.Caption:='Cont. employment period :';
            With SxSF do
            Begin
              With Items do
              Begin
                Clear;
                Add('Months');
                Add('Weeks');
              end;
            end; {With..}

            AgeInt.Enabled:=BOn;
            Label85.Caption:='Report employment over : ';

            Label86.Visible:=BOn;
            Label87.Visible:=BOn;
            I1TransDateF.Visible:=BOn;
            I2TransDateF.Visible:=BOn;

            Calc_CISEOYRange(SDate,EDate,BOff);
            I1TransDateF.DateValue:=SDate;
            I2TransDateF.DateValue:=EDate;
            
            Caption:='Sub-contract continuous employment report';
          end;
  end; {Case..}


  SxSF.ItemIndex:=0;

  SortXCB.ItemIndex:=0;

  New(CRepParam);

  try
    FillChar(CRepParam^,Sizeof(CRepParam^),0);
  except
    Dispose(CRepParam);
    CRepParam:=nil;
  end;

  If (SetLV) then
    SetLastValues;

  SxSFChange(Nil);
end;

procedure TRepJCCISEInp.FormClose(Sender: TObject; var Action: TCloseAction);

begin
  inherited;

  If (Assigned(CRepParam)) then
    Dispose(CRepParam);
end;


procedure TRepJCCISEInp.SxSFChange(Sender: TObject);
begin
  inherited;

  Case RepMode of
    1  :  Begin
            AgeInt.Enabled:=(SxSF.ItemIndex=Pred(SxSF.Items.Count));
            AgeInt.TabStop:=AgeInt.Enabled;
          end;
    3  :  Begin
            Label82.Caption:=SxSF.Text;
          end;
  end; {case..}
end;


procedure TRepJCCISEInp.OkCP1BtnClick(Sender: TObject);

begin
  If (Sender=OkCP1Btn) then
  Begin
    If AutoExitValidation Then
    Begin
      With CRepParam^ do
      Begin
        OKCP1Btn.Enabled:=BOff;

        If (SortxCB.ItemIndex>0) then
          SortOrd:=SortxCB.ItemIndex;

        ExpTol:=Trunc(AgeInt.Value);

        Case RepMode of
          1  :  Begin
                  If (SxSF.ItemIndex>0) then
                    RepType:=TxLate_CISType(SxSF.ItemIndex,BOff);

                  QtyMode:=(RepType=(SxSF.Items.Count-2));

                  ShowER:=AgeInt.Enabled;
                end;
          3  :  Begin
                  If (SxSF.ItemIndex>0) then
                    RepType:=SxSF.ItemIndex;

                  RepSDate:=I1TransDateF.DateValue;
                  RepEDate:=I2TransDateF.DateValue;
                end;
        end; {Case..}

        AddCISListRep2Thread(RepMode,CRepParam,Owner);
      end;

      inherited;
    End // If AutoExitValidation
    Else
      ModalResult := mrNone;
  End // If (Sender=OkCP1Btn)
  Else
    inherited;
end;



procedure SubCEmplList_Report(IDMode  :  Byte;
                              AOwner  :  TComponent);

  Var
    RepInpMsg1  :  TRepJCCISEInp;

  Begin
    SetLV:=(JCRNo=IDMode);

    JCRNo:=IdMode;

    RepInpMsg1:=TRepJCCISEInp.Create(AOwner);

  end;


procedure TRepJCCISEInp.AgeIntKeyPress(Sender: TObject; var Key: Char);
begin
  If (Key = '-') Then
    Key := #0;
end;

Initialization

  JCRNo:=0;
  SetLV:=BOff;

end.
