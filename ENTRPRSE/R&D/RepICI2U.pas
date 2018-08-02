unit RepICI2U;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  Repinp1u, StdCtrls, ExtCtrls, BTSupU3, bkgroup, BorBtns, TEditVal, Mask,
  Animate, SBSPanel,
  GlobVar,
  VarConst,
  VarJCstU;


type
  TRepJCCISVInp = class(TRepInpMsg)
    Label83: Label8;
    SxSF: TSBSComboBox;
    Label81: Label8;
    Label84: Label8;
    V23CF: Text8Pt;
    V23PF: Text8Pt;
    cbRenum: TBorCheck;
    procedure OkCP1BtnClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormCreate(Sender: TObject);
    procedure cbRenumClick(Sender: TObject);
    procedure SxSFChange(Sender: TObject);
  private
    { Private declarations }
    VNo,
    RepMode    :  Byte;

    JobDetlR   :  JobDetlRec;


  public
    { Public declarations }
    CRepParam  :  JobCRep1Ptr;
  end;


procedure VoucherList_Report(IDMode  :  Byte;
                             CParam  :  CVATRepParam;
                             AOwner  :  TComponent);




{~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~}

Implementation

{~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~}

Uses
  ETStrU,
  ETDateU,
  ETMiscU,
  BTKeys1U,
  RepJCE2U,
  JobSup1U,
  SysU1,
  SysU2,
  JChkUseU,
  CISSUp1U,
  IntMU,
  BTSupU2;


{$R *.DFM}


Var
  CISRNo     :  Byte;
  SetCISLV   :  Boolean;


procedure TRepJCCISVInp.FormCreate(Sender: TObject);

Var
  n       :  Integer;

begin
  inherited;

  ClientHeight:=175;
  ClientWidth:=343;


  RepMode:=CISRNo;

  If (CIS340) then
    Caption:=Caption+'Statement'
  else
    Caption:=Caption+GetIntMsg(4);

  Case RepMode of
    4  :  Begin
            SxSF.Visible:=BOff;
            Label83.Visible:=BOff;

            JobDetlR:=JobDetl^;

            VNo:=JobDetlR.JobCISV.CISCType;

            If (CIS340) then
            Begin
              SxSF.Visible:=BOn;
              Label83.Visible:=BOn;

              Label81.Visible:=BOff;
              Label84.Visible:=BOff;

              cbRenum.Visible:=BOff;
              V23PF.Visible:=BOff;
              V23CF.Visible:=BOff;
              With SxSF,Items do
              Begin
                Clear;
                Add(CISVTypeName(4));
                Add(CISVTypeName(5));
              end;

              // CJS 2013-04-09 - ABSEXCH-14053 - Unable to print single CIS Statements
              SxSF.Enabled := False;

            end;
          end;
    5  :  Begin
            Caption:=Caption+'s';

            Label83.Caption:=GetIntMsg(4)+Label83.Caption;

            If (CurrentCountry=IECCode) then
            Begin
              With SxSF do
              Begin
                With Items do
                Begin
                  Clear;
                  Add(CISVTypeName(4));
                  Add(CISVTypeName(5));
                end;
              end; {With..}
            end {If..}
            else
            Begin
              If (CIS340) then
              Begin
                Label83.Caption:='Tax Rate Type  ';
                Label81.Visible:=BOff;
                Label84.Visible:=BOff;

                cbRenum.Visible:=BOff;
                V23PF.Visible:=BOff;
                V23CF.Visible:=BOff;
                With SxSF,Items do
                Begin
                  Clear;
                  Add(CISVTypeName(4));
                  Add(CISVTypeName(5));
                end;

              end;
            end;
          end;
  end; {Case..}

  If (CurrentCountry=IECCode) then
  Begin
    Label81.Visible:=BOff;
    V23PF.Visible:=BOff;
    V23CF.Left:=V23PF.Left;
    Label84.Left:=Label81.Left;
  end;

  SxSF.ItemIndex:=0;

  New(CRepParam);

  try
    FillChar(CRepParam^,Sizeof(CRepParam^),0);
  except
    Dispose(CRepParam);
    CRepParam:=nil;
  end;

  If (SetCISLV) then
    SetLastValues;

  Case RepMode of
    4  :  Begin
            With JobDetlR.JobCISV do
            Begin
              // CJS 2013-04-09 - ABSEXCH-14053 - Unable to print single CIS Statements
              //    CISCType: 1, 4 = High/Low Type
              //    CISCType: other = Zero-rate
              if (CurrentCountry = IECCode) then
                SxSF.ItemIndex:=CISVTypeOrd(CISCType,BOff)
              else
              begin
                if (JobDetlR.JobCISV.CISCType in [1, 4]) then
                  SxSF.ItemIndex := 0
                else
                  SxSF.ItemIndex := 1;
              end;
            end;
          end;
  end; {Case..}


  cbRenumClick(Nil);
  SxSFChange(Nil);
end;

procedure TRepJCCISVInp.FormClose(Sender: TObject; var Action: TCloseAction);

begin
  inherited;

  If (Assigned(CRepParam)) then
    Dispose(CRepParam);
end;

procedure TRepJCCISVInp.cbRenumClick(Sender: TObject);
begin
  inherited;

  V23PF.Enabled:=cbRenum.Checked;
  V23PF.TabStop:=cbRenum.Checked;
  V23CF.TabStop:=cbRenum.Checked;
  V23CF.Enabled:=cbRenum.Checked;

end;


procedure TRepJCCISVInp.SxSFChange(Sender: TObject);
begin
  inherited;

  // CJS 2013-04-09 - ABSEXCH-14053 - Unable to print single CIS Statements
  If (RepMode in [4, 5]) then
  Begin
    VNo:=CISVTypeOrd(SxSF.ItemIndex,BOn);
  end;

  With SyssCIS^.CISRates.CISVouchers[VNo] do
  Begin
    V23PF.Text:=Prefix;
    V23CF.Text:=IntToStr(Counter);

  end;

end;

procedure TRepJCCISVInp.OkCP1BtnClick(Sender: TObject);

begin
  If (Sender=OkCP1Btn) then
  Begin
    If AutoExitValidation Then
    Begin
      With CRepParam^ do
      Begin
        OKCP1Btn.Enabled:=BOff;

        RepType:=VNo;

        ShowER:=cbRenum.Checked;

        JobFilt:=V23PF.Text;

        If (V23CF.Text<>'') then
          CISCount:=StrToInt64(V23CF.Text)
        else
          CISCount:=0;

        If (RepMode=4) then
          RepKey1:=CISCertKey(JobDetlR.JobCISV.CISCertNo);

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



procedure VoucherList_Report(IDMode  :  Byte;
                             CParam  :  CVATRepParam;
                             AOwner  :  TComponent);

  Var
    RepInpMsg1  :  TRepJCCISVInp;

  Begin
    SetCISLV:=(CISRNo=IDMode);

    CISRNo:=IdMode;

    RepInpMsg1:=TRepJCCISVInp.Create(AOwner);

    With RepInpMsg1 do
    Begin
      If (IdMode=5) then
      With CRepParam^ do
      Begin
        SetCISListKeys(CParam,RepKey1,RepKey2,RepKPath);

      end;
    end;
  end;






Initialization

  CISRNo:=0;
  SetCISLV:=BOff;

end.
